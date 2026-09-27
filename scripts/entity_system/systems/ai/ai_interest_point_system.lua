-- chunkname: @scripts/entity_system/systems/ai/ai_interest_point_system.lua

local num = 20
local num_2 = 128
local script_data = script_data

AIInterestPointSystem = class(AIInterestPointSystem, ExtensionSystemBase)

local tbl = {
	"AIInterestPointExtension",
	"AIInterestPointHuskExtension"
}
local tbl_2 = {
	skaven = {
		"skaven"
	},
	human = {
		"human"
	},
	all = {
		"skaven",
		"human"
	}
}

local function fn(...)
	-- function 1
	if not script_data.ai_interest_point_debug then
		printf(...)
	end
end

AIInterestPointSystem.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	AIInterestPointSystem.super.init(self, arg_2_1, arg_2_2, tbl)

	self.wwise_world = Managers.world:wwise_world(self.world)
	self.network_manager = arg_2_1.network_manager
	self.is_server = arg_2_1.is_server
	self.network_transmit = arg_2_1.network_transmit
	self.system_api = arg_2_1.system_api
	self.system_api[arg_2_2] = {
		start_async_claim_request = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
			-- function 3
			return self:api_start_async_claim_request(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		end,
		get_claim = function (arg_4_0)
			-- function 4
			return self:api_get_claim(arg_4_0)
		end,
		release_claim = function (arg_5_0)
			-- function 5
			return self:api_release_claim(arg_5_0)
		end
	}
	self.requests = {}
	self.current_request_index = 0
	self.last_request_index = 0
	self.interest_points = {}
	self.interest_points_to_spawn = {}
	self.reachable_interest_points = {}

	local nav_world = Managers.state.entity:system("ai_system"):nav_world()

	self.nav_world = nav_world
	self.astar = GwNavAStar.create(nav_world)
	self.processing_astar = false

	local var_2_1 = GwNavTagLayerCostTable.create()
	local create_tag_cost_table = GwNavCostMap.create_tag_cost_table()
	local tbl_3 = {
		ledges = 1,
		ledges_with_fence = 1,
		jumps = 1
	}

	table.merge(tbl_3, NAV_TAG_VOLUME_LAYER_COST_AI)
	AiUtils.initialize_cost_table(var_2_1, tbl_3)

	self.navtag_layer_cost_table = var_2_1

	AiUtils.initialize_nav_cost_map_cost_table(create_tag_cost_table)

	self.nav_cost_map_cost_table = create_tag_cost_table

	local var_2_4 = GwNavTraverseLogic.create(nav_world, create_tag_cost_table)

	GwNavTraverseLogic.set_navtag_layer_cost_table(var_2_4, var_2_1)

	self.traverse_logic = var_2_4
	self.broadphase_radius = num
	self.broadphase = Broadphase(self.broadphase_radius, num_2, tbl_2.all)

	local network_event_delegate = arg_2_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, "rpc_interest_point_chatter_update")

	local get_level_seed = Managers.mechanism:get_level_seed()

	self._seed = get_level_seed

	print("[AIInterestPointSystem] Level Seed: ", get_level_seed)

	self.current_obsolete_request = nil
end

AIInterestPointSystem._random = function (self, ...)
	-- function 6
	local next_random, var_6_1 = Math.next_random(self._seed, ...)

	self._seed = next_random

	return var_6_1
end

AIInterestPointSystem.set_seed = function (self, arg_7_1)
	-- function 7
	fassert(not arg_7_1 and type(arg_7_1) == "number", "Bad seed input!")

	self._seed = arg_7_1
end

AIInterestPointSystem.destroy = function (self)
	-- function 8
	local clear = table.clear

	self.system_api[self.name] = nil
	self.system_api = nil

	for k, v in pairs(self.requests) do
		clear(v.failed_interest_points)

		self.requests[k] = nil
	end

	clear(self.interest_points_to_spawn)
	clear(self.interest_points)

	local traverse_logic = self.traverse_logic

	GwNavTagLayerCostTable.destroy(self.navtag_layer_cost_table)
	GwNavCostMap.destroy_tag_cost_table(self.nav_cost_map_cost_table)
	GwNavTraverseLogic.destroy(traverse_logic)

	local astar = self.astar

	GwNavAStar.destroy(astar)
	table.for_each(self.reachable_interest_points, clear)
	self.network_event_delegate:unregister(self)
end

local tbl_3 = {}

AIInterestPointSystem.on_add_extension = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local tbl = {}
	local game_object_or_level_id, var_9_2 = self.network_manager:game_object_or_level_id(arg_9_2)

	if not (arg_9_4.recycler or not var_9_2 and script_data.ai_dont_randomize_interest_points or not (self:_random() < InterestPointSettings.interest_point_spawn_chance)) then
		if not script_data.ai_interest_point_debug then
			local local_position = Unit.local_position(arg_9_2, 0)

			QuickDrawerStay:line(local_position, local_position + Vector3(0, 0, 4), Color(255, 0, 0))
		end

		ScriptUnit.set_extension(arg_9_2, self.name, tbl, tbl_3)

		return tbl
	end

	ScriptUnit.set_extension(arg_9_2, self.name, tbl, tbl_3)

	if arg_9_3 == "AIInterestPointExtension" then
		if not Unit.get_data(arg_9_2, "interest_point", "enabled") then
			local interest_point_anims = NetworkLookup.interest_point_anims
			local count = #interest_point_anims
			local nav_world = self.nav_world
			local local_position_2 = Unit.local_position(arg_9_2, 0)

			self.interest_points[arg_9_2] = tbl

			if not script_data.ai_interest_point_debug then
				QuickDrawerStay:line(local_position_2, local_position_2 + Vector3(0, 0, 4), Color(255, 255, 0))
			end

			local get_data = Unit.get_data(arg_9_2, "interest_point", "wwise_event")

			get_data = get_data or "enemy_skaven_idle_chatter"
			tbl.wwise_event = get_data

			local get_data_2 = Unit.get_data(arg_9_2, "interest_point", "wwise_minimum_needed")

			get_data_2 = get_data_2 or 2
			tbl.wwise_minimum_needed = get_data_2

			local get_data_3 = Unit.get_data(arg_9_2, "interest_point", "race_filter")

			if not get_data_3 then
				fassert(tbl_2[get_data_3], "Badly named race filter '%s' for interest-point. See 'broadphase_race_filters' ", get_data_3)
			else
				get_data_3 = "skaven"
			end

			tbl.race_filter = tbl_2[get_data_3]

			local num = 0

			tbl.num_claimed_points = 0
			tbl.points = {}
			tbl.duration = Unit.get_data(arg_9_2, "interest_point", "duration")

			local num_2 = 0

			while not Unit.has_data(arg_9_2, "interest_point", "points", num_2) do
				local get_data_4 = Unit.get_data(arg_9_2, "interest_point", "points", num_2, "node")
				local node = Unit.node(arg_9_2, get_data_4)
				local world_position = Unit.world_position(arg_9_2, node)
				local world_rotation = Unit.world_rotation(arg_9_2, node)
				local tbl_4 = {}
				local num_3 = 0
				local x = world_position.x
				local y = world_position.y
				local z = world_position.z
				local triangle_from_position, var_9_23 = GwNavQueries.triangle_from_position(nav_world, world_position, 0.3, 0.3)

				if not triangle_from_position then
					z = var_9_23

					for i = 1, count do
						local var_9_24 = interest_point_anims[i]

						if not Unit.get_data(arg_9_2, "interest_point", "points", num_2, "animation_map", var_9_24) then
							fassert(var_9_24 ~= nil, "No animation name in interest point unit %q for point %d", tostring(arg_9_2), num_2)

							num_3 = num_3 + 1
							tbl_4[num_3] = var_9_24
						end
					end

					num = num + 1
				end

				local tbl_5 = {
					position = {
						x,
						y,
						z
					},
					animations = tbl_4,
					animations_n = num_3,
					is_position_on_navmesh = triangle_from_position,
					rotation = QuaternionBox(world_rotation)
				}

				fassert(not triangle_from_position and tbl_5.animations_n > 0, "There is an interest point %q (point index=%d, node name=%s) on the level with no valid animations at position=%s", tostring(arg_9_2), num_2 + 1, get_data_4, tostring(world_position))

				tbl.points[num_2 + 1] = tbl_5
				num_2 = num_2 + 1
			end

			local num_4 = 4

			tbl.broadphase_id = Broadphase.add(self.broadphase, arg_9_2, local_position_2, num_4, tbl.race_filter)
			tbl.num_valid_to_spawn = num

			if num == 0 then
				tbl.points_n = 0
			else
				tbl.points_n = num_2
				tbl.pack_members = arg_9_4.pack_members
				tbl.zone_data = arg_9_4.zone_data

				if not arg_9_4.do_spawn then
					self.interest_points_to_spawn[arg_9_2] = tbl
				end
			end
		end
	elseif arg_9_3 ~= "AIInterestPointHuskExtension" or not Unit.get_data(arg_9_2, "interest_point", "enabled") then
		if not script_data.ai_interest_point_debug then
			local local_position_3 = Unit.local_position(arg_9_2, 0)

			QuickDrawerStay:line(local_position_3, local_position_3 + Vector3(0, 0, 4), Color(255, 255, 0))
		end

		self.interest_points[arg_9_2] = tbl

		local get_data_5 = Unit.get_data(arg_9_2, "interest_point", "sound_event")

		get_data_5 = get_data_5 or "enemy_skaven_idle_chatter"
		tbl.wwise_event = get_data_5
	end

	return tbl
end

AIInterestPointSystem.on_remove_extension = function (self, arg_10_1, arg_10_2)
	-- function 10
	ScriptUnit.remove_extension(arg_10_1, self.NAME)

	local var_10_0 = self.interest_points[arg_10_1]

	if not var_10_0 then
		return
	end

	if arg_10_1 == self.processing_best_ip_unit then
		self.processing_astar = false
		self.processing_best_point = nil
		self.processing_best_ip_unit = nil
		self.processing_best_point_extension = nil

		local astar = self.astar

		if not GwNavAStar.processing_finished(astar) then
			GwNavAStar.cancel(astar)
		end
	end

	if var_10_0.broadphase_id ~= nil then
		Broadphase.remove(self.broadphase, var_10_0.broadphase_id)
	end

	self.interest_points[arg_10_1] = nil

	if not var_10_0.wwise_playing_id then
		WwiseWorld.stop_event(self.wwise_world, var_10_0.wwise_playing_id)
		WwiseWorld.destroy_manual_source(self.wwise_world, var_10_0.wwise_source_id)
	end
end

AIInterestPointSystem.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self.is_server then
		self:debug_draw(arg_11_2, arg_11_1.dt)
		self:spawn_interest_points()
		self:release_obsolete_requests(arg_11_2)
		self:resolve_requests()
	end

	local dt = arg_11_1.dt

	if not script_data.navigation_thread_disabled then
		GwNavWorld.kick_async_update(self.nav_world, dt)

		NAVIGATION_RUNNING_IN_THREAD = true
	else
		GwNavWorld.update(self.nav_world, dt)
	end
end

AIInterestPointSystem.breed_spawned_callback = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local dead_breed_data = arg_12_2.dead_breed_data

	BREED_DIE_LOOKUP[arg_12_0] = {
		AIInterestPointSystem.cleanup_dead_breed,
		dead_breed_data
	}
end

AIInterestPointSystem.cleanup_dead_breed = function (arg_13_0, arg_13_1)
	-- function 13
	arg_13_1[1] = false
end

local tbl_4 = {}
local num_3 = 0

AIInterestPointSystem.spawn_interest_points = function (self)
	-- function 14
	local conflict = Managers.state.conflict
	local num = 8
	local interest_points_to_spawn = self.interest_points_to_spawn
	local var_14_3 = next(interest_points_to_spawn)
	local _breed_override_lookup = self._breed_override_lookup

	while not (not (num > 0) or var_14_3 == nil) do
		local var_14_5 = interest_points_to_spawn[var_14_3]
		local pack_members = var_14_5.pack_members
		local points_n = var_14_5.points_n

		for i = 1, points_n do
			local var_14_8 = var_14_5.points[i]

			if not var_14_8.is_position_on_navmesh then
				local var_14_9 = pack_members[i]

				if not var_14_9.name then
					var_14_9 = var_14_9[math.random(1, #var_14_9)]
				end

				local tbl = {
					ignore_event_counter = true
				}
				local str = "enemy_recycler"
				local var_14_12
				local str_2 = "roam"
				local var_14_14
				local unbox = Vector3Aux.unbox(var_14_8.position)

				if not _breed_override_lookup and not _breed_override_lookup[var_14_9.name] then
					var_14_9 = Breeds[_breed_override_lookup[var_14_9.name]]
				end

				var_14_8[1] = conflict:spawn_queued_unit(var_14_9, Vector3Box(unbox), var_14_8.rotation, str, var_14_12, str_2, tbl, var_14_14, var_14_8)
			else
				print("FAIL INTEREST POINT SPAWN UNIT")
			end
		end

		num_3 = num_3 + 1
		tbl_4[num_3] = var_14_3
		num = num - 1
		var_14_3 = next(interest_points_to_spawn, var_14_3)
	end

	for j = 1, num_3 do
		interest_points_to_spawn[tbl_4[j]] = nil
	end

	num_3 = 0
end

AIInterestPointSystem.release_obsolete_requests = function (self, arg_15_1)
	-- function 15
	if self.requests[self.current_obsolete_request] == nil then
		self.current_obsolete_request = nil
	end

	local var_15_0 = next(self.requests, self.current_obsolete_request)

	if var_15_0 == nil then
		self.current_obsolete_request = nil

		return
	end

	local flag = false
	local claim_unit = self.requests[var_15_0].claim_unit
	local var_15_3 = BLACKBOARDS[claim_unit]
	local flag_2

	flag_2 = HEALTH_ALIVE[claim_unit] or not true or var_15_3.confirmed_player_sighting

	if not flag_2 then
		self.current_obsolete_request = nil

		self:api_release_claim(var_15_0)

		if not var_15_3 then
			var_15_3.ip_request_id = nil
		end
	else
		self.current_obsolete_request = var_15_0
	end
end

local function fn_2(self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0
	local var_16_1

	for i = arg_16_1, arg_16_2 do
		var_16_0 = self[i]

		if var_16_0 ~= nil then
			var_16_1 = i

			break
		end
	end

	return var_16_0, var_16_1
end

AIInterestPointSystem._update_astar_result = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	self.processing_astar = false
	self.processing_best_point = nil
	self.processing_best_ip_unit = nil
	self.processing_best_point_extension = nil

	local path_found = GwNavAStar.path_found(arg_17_4)

	if not path_found then
		arg_17_2.failed_interest_points[arg_17_3] = true
	end

	if not arg_17_1 then
		if not self.reachable_interest_points[arg_17_1] then
			self.reachable_interest_points[arg_17_1] = {}
		end

		self.reachable_interest_points[arg_17_1][arg_17_3] = path_found
	end

	return path_found
end

local tbl_5 = {}

local function fn_3(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local extension = ScriptUnit.extension
	local var_18_1
	local var_18_2
	local var_18_3
	local var_18_4
	local var_18_5
	local num = arg_18_1.min_range * arg_18_1.min_range
	local num_2 = arg_18_1.max_range * arg_18_1.max_range
	local unbox = Vector3Aux.unbox(arg_18_1.position)
	local huge = math.huge
	local var_18_10 = BLACKBOARDS[arg_18_1.claim_unit]
	local var_18_11 = tbl_2[var_18_10.breed.race]
	local query = Broadphase.query(arg_18_0, unbox, arg_18_1.max_range, tbl_5, var_18_11)

	for i = 1, query do
		local var_18_13 = tbl_5[i]
		local var_18_14 = extension(var_18_13, "ai_interest_point_system")
		local current_request = arg_18_1.current_request

		current_request = not current_request and arg_18_1.current_request.point_extension

		if not arg_18_3 then
			-- Nothing
		end

		::label_18_0::

		local var_18_16 = arg_18_4[arg_18_3]

		var_18_16 = not var_18_16 and arg_18_4[arg_18_3][var_18_13]

		::label_18_1::

		if not (not arg_18_3 and var_18_16 ~= nil) then
			var_18_16 = not arg_18_4[var_18_13] and arg_18_4[var_18_13][arg_18_3]
		end

		local var_18_17

		if var_18_16 == nil then
			local var_18_18 = arg_18_1.failed_interest_points[var_18_13]

			var_18_17 = not var_18_18 and not var_18_18
		else
			var_18_17 = var_18_16
		end

		if not (current_request == var_18_14 or var_18_17 or var_18_17 ~= nil) then
			for j = 1, var_18_14.points_n do
				local var_18_19 = var_18_14.points[j]

				if (var_18_19.claimed or not var_18_19.is_position_on_navmesh) and not var_18_14 then
					local unbox_2 = Vector3Aux.unbox(var_18_19.position)
					local distance_squared = Vector3.distance_squared(unbox_2, arg_18_2)

					if not (not (num <= distance_squared) or not (distance_squared < num_2) or not (distance_squared < huge)) then
						var_18_3 = var_18_13
						var_18_4 = var_18_19
						var_18_5 = var_18_14
						huge = distance_squared
						var_18_2 = not var_18_17
						var_18_1 = not var_18_2
					end
				end
			end
		end
	end

	return var_18_3, var_18_4, var_18_5, var_18_1, var_18_2
end

local num_4 = 15

AIInterestPointSystem._start_astar_query = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8)
	-- function 19
	GwNavAStar.start_with_propagation_box(arg_19_1, arg_19_4, arg_19_2, arg_19_3, num_4, arg_19_5)

	self.processing_astar = true
	self.processing_best_ip_unit = arg_19_6
	self.processing_best_point = arg_19_7
	self.processing_best_point_extension = arg_19_8
end

local function fn_4(self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	-- function 20
	if arg_20_2 == nil then
		self.result = "failed"
		self.current_request = nil

		return true
	elseif not arg_20_4 then
		arg_20_3.num_claimed_points = arg_20_3.num_claimed_points + 1
		arg_20_2.claimed = true
		arg_20_2.claim_unit = self.claim_unit
		self.interest_point_unit = arg_20_1
		self.point = arg_20_2
		self.point_extension = arg_20_3
		self.result = "success"
		self.current_request = nil

		local num = arg_20_3.num_claimed_points / arg_20_3.points_n

		if arg_20_3.wwise_minimum_needed > arg_20_3.num_claimed_points then
			num = 0
		end

		local game_object_or_level_id, var_20_2 = arg_20_5:game_object_or_level_id(arg_20_1)

		arg_20_6:send_rpc_all("rpc_interest_point_chatter_update", game_object_or_level_id, var_20_2, num)

		return true
	else
		return false
	end
end

AIInterestPointSystem.resolve_requests = function (self)
	-- function 21
	if next(self.interest_points_to_spawn) ~= nil then
		return
	end

	local var_21_0, var_21_1 = fn_2(self.requests, self.current_request_index, self.last_request_index)

	if var_21_0 ~= nil then
		self.current_request_index = var_21_1

		local astar = self.astar
		local processing_astar = self.processing_astar
		local flag = false
		local flag_2 = false
		local var_21_6
		local var_21_7
		local var_21_8
		local current_request = var_21_0.current_request

		current_request = not current_request and var_21_0.current_request.interest_point_unit

		if not processing_astar then
			local flag_3 = false
			local claim_unit = var_21_0.claim_unit
			local var_21_12 = POSITION_LOOKUP[claim_unit]

			if not var_21_12 then
				local var_21_13

				var_21_6, var_21_7, var_21_8, flag_2, var_21_13 = fn_3(self.broadphase, var_21_0, var_21_12, current_request, self.reachable_interest_points)

				if not var_21_7 and not var_21_13 then
					local var_21_14 = var_21_12
					local unbox = Vector3Aux.unbox(var_21_7.position)

					self:_start_astar_query(astar, var_21_14, unbox, self.nav_world, self.traverse_logic, var_21_6, var_21_7, var_21_8)

					flag = false
				else
					flag = true
				end
			else
				flag = true
			end
		elseif not GwNavAStar.processing_finished(astar) then
			var_21_6 = self.processing_best_ip_unit
			var_21_7 = self.processing_best_point
			var_21_8 = self.processing_best_point_extension
			flag = true
			flag_2 = self:_update_astar_result(current_request, var_21_0, var_21_6, astar)
		end

		if not flag and not fn_4(var_21_0, var_21_6, var_21_7, var_21_8, flag_2, self.network_manager, self.network_transmit) then
			self.current_request_index = self.current_request_index + 1
		end
	end
end

AIInterestPointSystem.debug_draw = function (self, arg_22_1, arg_22_2)
	-- function 22
	if not script_data.ai_interest_point_debug then
		return
	end

	local QuickDrawer = QuickDrawer
	local debug_anim_t = self.debug_anim_t

	debug_anim_t = debug_anim_t or 0
	self.debug_anim_t = debug_anim_t + arg_22_2

	if self.debug_anim_t > 1 then
		self.debug_anim_t = 0
	end

	for k, v in pairs(self.interest_points) do
		for k_2 = 1, v.points_n do
			local temp_count, var_22_3, var_22_4 = Script.temp_count()
			local var_22_5 = v.points[k_2]
			local unbox = Vector3Aux.unbox(var_22_5.position)
			local forward = Quaternion.forward(var_22_5.rotation:unbox())

			if not var_22_5.is_position_on_navmesh then
				QuickDrawer:cylinder(unbox, unbox + Vector3.up(), 0.25, Colors.get("dark_red"), 5)
				QuickDrawer:cone(unbox + Vector3.up() * 1.3 + forward * 0.25, unbox + Vector3.up() * 1.3 - forward * 0.25, 0.1, Colors.get("dark_red"), 8, 8)
			elseif not var_22_5.claimed then
				local num = Vector3.up() * (self.debug_anim_t * 0.2)

				QuickDrawer:circle(unbox + Vector3.up() * 0.8, 0.25, Vector3.up(), Colors.get("lime_green"))
				QuickDrawer:cylinder(unbox - num, unbox + Vector3.up() * 1 - num, 0.25, Colors.get("lime_green"), 5)
				QuickDrawer:cone(unbox + Vector3.up() * 1.3 + forward * 0.25, unbox + Vector3.up() * 1.3 - forward * 0.25, 0.1, Colors.get("lime_green"), 8, 8)
			else
				QuickDrawer:cylinder(unbox, unbox + Vector3.up(), 0.25, Colors.get("dark_green"), 5)
				QuickDrawer:cone(unbox + Vector3.up() * 1.3 + forward * 0.25, unbox + Vector3.up() * 1.3 - forward * 0.25, 0.1, Colors.get("dark_green"), 8, 8)
			end

			Script.set_temp_count(temp_count, var_22_3, var_22_4)
		end
	end

	for k_3, v_2 in pairs(self.requests) do
		local claim_unit = v_2.claim_unit

		if not HEALTH_ALIVE[claim_unit] then
			local ip_end_time = BLACKBOARDS[claim_unit].ip_end_time

			if not ip_end_time then
				local num_2 = POSITION_LOOKUP[claim_unit] + Vector3.up() * (ip_end_time - arg_22_1) + Vector3.up()

				QuickDrawer:cylinder(POSITION_LOOKUP[claim_unit], num_2, 0.25, Colors.get("dark_red"), 5)
			end
		end
	end
end

AIInterestPointSystem.api_start_async_claim_request = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	self.last_request_index = self.last_request_index + 1

	local last_request_index = self.last_request_index
	local tbl = {
		claim_unit = arg_23_1,
		position = Vector3Aux.box(nil, arg_23_2),
		min_range = arg_23_3,
		max_range = arg_23_4,
		failed_interest_points = {}
	}

	if arg_23_5 ~= nil then
		tbl.current_request = self.requests[arg_23_5]
	end

	self.requests[last_request_index] = tbl

	return last_request_index
end

AIInterestPointSystem.api_get_claim = function (self, arg_24_1)
	-- function 24
	fassert(arg_24_1, "Tried to get claim with no request_id")

	return self.requests[arg_24_1]
end

AIInterestPointSystem.api_release_claim = function (self, arg_25_1)
	-- function 25
	local var_25_0 = self.requests[arg_25_1]

	assert(var_25_0)

	if var_25_0.result ~= "success" or not Unit.alive(var_25_0.interest_point_unit) then
		local point_extension = var_25_0.point_extension

		point_extension.num_claimed_points = point_extension.num_claimed_points - 1
		var_25_0.point.claimed = nil
		var_25_0.point.claim_unit = nil

		local num = point_extension.num_claimed_points / point_extension.points_n

		if point_extension.wwise_minimum_needed > point_extension.num_claimed_points then
			num = 0
		end

		local interest_point_unit = var_25_0.interest_point_unit
		local game_object_or_level_id, var_25_5 = self.network_manager:game_object_or_level_id(interest_point_unit)

		assert(game_object_or_level_id)

		if not self.network_manager:in_game_session() then
			Managers.state.network.network_transmit:send_rpc_all("rpc_interest_point_chatter_update", game_object_or_level_id, var_25_5, num)
		end
	end

	if self.current_request_index ~= arg_25_1 or not self.processing_astar then
		local astar = self.astar

		if not GwNavAStar.processing_finished(astar) then
			GwNavAStar.cancel(astar)
		end

		self.processing_astar = false
		self.processing_best_point = nil
		self.processing_best_ip_unit = nil
		self.processing_best_point_extension = nil
	end

	table.clear(var_25_0.failed_interest_points)

	var_25_0.current_request = nil
	self.requests[arg_25_1] = nil
end

AIInterestPointSystem.rpc_interest_point_chatter_update = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	local game_object_or_level_unit = self.network_manager:game_object_or_level_unit(arg_26_2, arg_26_3)

	if game_object_or_level_unit == nil then
		return
	end

	local var_26_1 = self.interest_points[game_object_or_level_unit]

	if not var_26_1 then
		print("Missing interest_point should not happen?")

		return
	end

	local wwise_world = self.wwise_world
	local percent_claimed = var_26_1.percent_claimed

	percent_claimed = percent_claimed or 0

	if arg_26_4 == percent_claimed then
		return
	elseif not (not (percent_claimed > 0) or arg_26_4 ~= 0) then
		fn("AIInterestPointSystem stopping event")

		if not (not var_26_1.wwise_source_id and WwiseWorld.has_source(wwise_world, var_26_1.wwise_source_id)) then
			print("[AIInterestPointExtension] Trying to stop event on non-existing wwise_source_id", var_26_1.wwise_source_id)

			var_26_1.percent_claimed = 0
			var_26_1.wwise_source_id = nil
			var_26_1.wwise_playing_id = nil

			return
		end

		WwiseWorld.stop_event(wwise_world, var_26_1.wwise_playing_id)
		WwiseWorld.destroy_manual_source(wwise_world, var_26_1.wwise_source_id)

		var_26_1.wwise_source_id = nil
		var_26_1.wwise_playing_id = nil
	elseif not (percent_claimed ~= 0 or not (arg_26_4 > 0)) then
		fn("AIInterestPointSystem starting event %f", arg_26_4)

		local wwise_event = var_26_1.wwise_event
		local flag = true
		local make_manual_source = WwiseWorld.make_manual_source(wwise_world, game_object_or_level_unit)

		var_26_1.wwise_playing_id, var_26_1.wwise_source_id = WwiseWorld.trigger_event(wwise_world, wwise_event, flag, make_manual_source), make_manual_source

		WwiseWorld.set_source_parameter(wwise_world, var_26_1.wwise_source_id, "chatter_number", arg_26_4)
	elseif arg_26_4 < 0 then
		fassert(false, "[AIInterestPointExtension] percent_claimed can never be a negative value")
	else
		if not (not var_26_1.wwise_source_id and WwiseWorld.has_source(wwise_world, var_26_1.wwise_source_id)) then
			print("[AIInterestPointExtension] Trying to set parameter on non-existing wwise_source_id", var_26_1.wwise_source_id)

			var_26_1.percent_claimed = 0
			var_26_1.wwise_source_id = nil
			var_26_1.wwise_playing_id = nil

			return
		end

		fn("AIInterestPointSystem setting percent_claimed %f", arg_26_4)
		WwiseWorld.set_source_parameter(wwise_world, var_26_1.wwise_source_id, "chatter_number", arg_26_4)
	end

	var_26_1.percent_claimed = arg_26_4
end

AIInterestPointSystem.set_breed_override_lookup = function (self, arg_27_1)
	-- function 27
	self._breed_override_lookup = arg_27_1
end
