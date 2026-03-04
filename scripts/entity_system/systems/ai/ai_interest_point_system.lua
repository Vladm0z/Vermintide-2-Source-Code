-- chunkname: @scripts/entity_system/systems/ai/ai_interest_point_system.lua

local var_0_0 = 20
local var_0_1 = 128
local var_0_2 = script_data

AIInterestPointSystem = class(AIInterestPointSystem, ExtensionSystemBase)

local var_0_3 = {
	"AIInterestPointExtension",
	"AIInterestPointHuskExtension"
}
local var_0_4 = {
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

local function var_0_5(...)
	if var_0_2.ai_interest_point_debug then
		printf(...)
	end
end

AIInterestPointSystem.init = function (arg_2_0, arg_2_1, arg_2_2)
	AIInterestPointSystem.super.init(arg_2_0, arg_2_1, arg_2_2, var_0_3)

	arg_2_0.wwise_world = Managers.world:wwise_world(arg_2_0.world)
	arg_2_0.network_manager = arg_2_1.network_manager
	arg_2_0.is_server = arg_2_1.is_server
	arg_2_0.network_transmit = arg_2_1.network_transmit
	arg_2_0.system_api = arg_2_1.system_api
	arg_2_0.system_api[arg_2_2] = {
		start_async_claim_request = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
			return arg_2_0:api_start_async_claim_request(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		end,
		get_claim = function (arg_4_0)
			return arg_2_0:api_get_claim(arg_4_0)
		end,
		release_claim = function (arg_5_0)
			return arg_2_0:api_release_claim(arg_5_0)
		end
	}
	arg_2_0.requests = {}
	arg_2_0.current_request_index = 0
	arg_2_0.last_request_index = 0
	arg_2_0.interest_points = {}
	arg_2_0.interest_points_to_spawn = {}
	arg_2_0.reachable_interest_points = {}

	local var_2_0 = Managers.state.entity:system("ai_system"):nav_world()

	arg_2_0.nav_world = var_2_0
	arg_2_0.astar = GwNavAStar.create(var_2_0)
	arg_2_0.processing_astar = false

	local var_2_1 = GwNavTagLayerCostTable.create()
	local var_2_2 = GwNavCostMap.create_tag_cost_table()
	local var_2_3 = {
		ledges = 1,
		ledges_with_fence = 1,
		jumps = 1
	}

	table.merge(var_2_3, NAV_TAG_VOLUME_LAYER_COST_AI)
	AiUtils.initialize_cost_table(var_2_1, var_2_3)

	arg_2_0.navtag_layer_cost_table = var_2_1

	AiUtils.initialize_nav_cost_map_cost_table(var_2_2)

	arg_2_0.nav_cost_map_cost_table = var_2_2

	local var_2_4 = GwNavTraverseLogic.create(var_2_0, var_2_2)

	GwNavTraverseLogic.set_navtag_layer_cost_table(var_2_4, var_2_1)

	arg_2_0.traverse_logic = var_2_4
	arg_2_0.broadphase_radius = var_0_0
	arg_2_0.broadphase = Broadphase(arg_2_0.broadphase_radius, var_0_1, var_0_4.all)

	local var_2_5 = arg_2_1.network_event_delegate

	arg_2_0.network_event_delegate = var_2_5

	var_2_5:register(arg_2_0, "rpc_interest_point_chatter_update")

	local var_2_6 = Managers.mechanism:get_level_seed()

	arg_2_0._seed = var_2_6

	print("[AIInterestPointSystem] Level Seed: ", var_2_6)

	arg_2_0.current_obsolete_request = nil
end

AIInterestPointSystem._random = function (arg_6_0, ...)
	local var_6_0, var_6_1 = Math.next_random(arg_6_0._seed, ...)

	arg_6_0._seed = var_6_0

	return var_6_1
end

AIInterestPointSystem.set_seed = function (arg_7_0, arg_7_1)
	fassert(arg_7_1 and type(arg_7_1) == "number", "Bad seed input!")

	arg_7_0._seed = arg_7_1
end

AIInterestPointSystem.destroy = function (arg_8_0)
	local var_8_0 = table.clear

	arg_8_0.system_api[arg_8_0.name] = nil
	arg_8_0.system_api = nil

	for iter_8_0, iter_8_1 in pairs(arg_8_0.requests) do
		var_8_0(iter_8_1.failed_interest_points)

		arg_8_0.requests[iter_8_0] = nil
	end

	var_8_0(arg_8_0.interest_points_to_spawn)
	var_8_0(arg_8_0.interest_points)

	local var_8_1 = arg_8_0.traverse_logic

	GwNavTagLayerCostTable.destroy(arg_8_0.navtag_layer_cost_table)
	GwNavCostMap.destroy_tag_cost_table(arg_8_0.nav_cost_map_cost_table)
	GwNavTraverseLogic.destroy(var_8_1)

	local var_8_2 = arg_8_0.astar

	GwNavAStar.destroy(var_8_2)
	table.for_each(arg_8_0.reachable_interest_points, var_8_0)
	arg_8_0.network_event_delegate:unregister(arg_8_0)
end

local var_0_6 = {}

AIInterestPointSystem.on_add_extension = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = {}
	local var_9_1, var_9_2 = arg_9_0.network_manager:game_object_or_level_id(arg_9_2)

	if not arg_9_4.recycler and var_9_2 and not var_0_2.ai_dont_randomize_interest_points and arg_9_0:_random() < InterestPointSettings.interest_point_spawn_chance then
		if var_0_2.ai_interest_point_debug then
			local var_9_3 = Unit.local_position(arg_9_2, 0)

			QuickDrawerStay:line(var_9_3, var_9_3 + Vector3(0, 0, 4), Color(255, 0, 0))
		end

		ScriptUnit.set_extension(arg_9_2, arg_9_0.name, var_9_0, var_0_6)

		return var_9_0
	end

	ScriptUnit.set_extension(arg_9_2, arg_9_0.name, var_9_0, var_0_6)

	if arg_9_3 == "AIInterestPointExtension" then
		if Unit.get_data(arg_9_2, "interest_point", "enabled") then
			local var_9_4 = NetworkLookup.interest_point_anims
			local var_9_5 = #var_9_4
			local var_9_6 = arg_9_0.nav_world
			local var_9_7 = Unit.local_position(arg_9_2, 0)

			arg_9_0.interest_points[arg_9_2] = var_9_0

			if var_0_2.ai_interest_point_debug then
				QuickDrawerStay:line(var_9_7, var_9_7 + Vector3(0, 0, 4), Color(255, 255, 0))
			end

			var_9_0.wwise_event = Unit.get_data(arg_9_2, "interest_point", "wwise_event") or "enemy_skaven_idle_chatter"
			var_9_0.wwise_minimum_needed = Unit.get_data(arg_9_2, "interest_point", "wwise_minimum_needed") or 2

			local var_9_8 = Unit.get_data(arg_9_2, "interest_point", "race_filter")

			if var_9_8 then
				fassert(var_0_4[var_9_8], "Badly named race filter '%s' for interest-point. See 'broadphase_race_filters' ", var_9_8)
			else
				var_9_8 = "skaven"
			end

			var_9_0.race_filter = var_0_4[var_9_8]

			local var_9_9 = 0

			var_9_0.num_claimed_points = 0
			var_9_0.points = {}
			var_9_0.duration = Unit.get_data(arg_9_2, "interest_point", "duration")

			local var_9_10 = 0

			while Unit.has_data(arg_9_2, "interest_point", "points", var_9_10) do
				local var_9_11 = Unit.get_data(arg_9_2, "interest_point", "points", var_9_10, "node")
				local var_9_12 = Unit.node(arg_9_2, var_9_11)
				local var_9_13 = Unit.world_position(arg_9_2, var_9_12)
				local var_9_14 = Unit.world_rotation(arg_9_2, var_9_12)
				local var_9_15 = {}
				local var_9_16 = 0
				local var_9_17 = var_9_13.x
				local var_9_18 = var_9_13.y
				local var_9_19 = var_9_13.z
				local var_9_20, var_9_21 = GwNavQueries.triangle_from_position(var_9_6, var_9_13, 0.3, 0.3)

				if var_9_20 then
					var_9_19 = var_9_21

					for iter_9_0 = 1, var_9_5 do
						local var_9_22 = var_9_4[iter_9_0]

						if Unit.get_data(arg_9_2, "interest_point", "points", var_9_10, "animation_map", var_9_22) then
							fassert(var_9_22 ~= nil, "No animation name in interest point unit %q for point %d", tostring(arg_9_2), var_9_10)

							var_9_16 = var_9_16 + 1
							var_9_15[var_9_16] = var_9_22
						end
					end

					var_9_9 = var_9_9 + 1
				end

				local var_9_23 = {
					position = {
						var_9_17,
						var_9_18,
						var_9_19
					},
					animations = var_9_15,
					animations_n = var_9_16,
					is_position_on_navmesh = var_9_20,
					rotation = QuaternionBox(var_9_14)
				}

				fassert(not var_9_20 or var_9_23.animations_n > 0, "There is an interest point %q (point index=%d, node name=%s) on the level with no valid animations at position=%s", tostring(arg_9_2), var_9_10 + 1, var_9_11, tostring(var_9_13))

				var_9_0.points[var_9_10 + 1] = var_9_23
				var_9_10 = var_9_10 + 1
			end

			local var_9_24 = 4

			var_9_0.broadphase_id = Broadphase.add(arg_9_0.broadphase, arg_9_2, var_9_7, var_9_24, var_9_0.race_filter)
			var_9_0.num_valid_to_spawn = var_9_9

			if var_9_9 == 0 then
				var_9_0.points_n = 0
			else
				var_9_0.points_n = var_9_10
				var_9_0.pack_members = arg_9_4.pack_members
				var_9_0.zone_data = arg_9_4.zone_data

				if arg_9_4.do_spawn then
					arg_9_0.interest_points_to_spawn[arg_9_2] = var_9_0
				end
			end
		end
	elseif arg_9_3 == "AIInterestPointHuskExtension" and Unit.get_data(arg_9_2, "interest_point", "enabled") then
		if var_0_2.ai_interest_point_debug then
			local var_9_25 = Unit.local_position(arg_9_2, 0)

			QuickDrawerStay:line(var_9_25, var_9_25 + Vector3(0, 0, 4), Color(255, 255, 0))
		end

		arg_9_0.interest_points[arg_9_2] = var_9_0
		var_9_0.wwise_event = Unit.get_data(arg_9_2, "interest_point", "sound_event") or "enemy_skaven_idle_chatter"
	end

	return var_9_0
end

AIInterestPointSystem.on_remove_extension = function (arg_10_0, arg_10_1, arg_10_2)
	ScriptUnit.remove_extension(arg_10_1, arg_10_0.NAME)

	local var_10_0 = arg_10_0.interest_points[arg_10_1]

	if not var_10_0 then
		return
	end

	if arg_10_1 == arg_10_0.processing_best_ip_unit then
		arg_10_0.processing_astar = false
		arg_10_0.processing_best_point = nil
		arg_10_0.processing_best_ip_unit = nil
		arg_10_0.processing_best_point_extension = nil

		local var_10_1 = arg_10_0.astar

		if not GwNavAStar.processing_finished(var_10_1) then
			GwNavAStar.cancel(var_10_1)
		end
	end

	if var_10_0.broadphase_id ~= nil then
		Broadphase.remove(arg_10_0.broadphase, var_10_0.broadphase_id)
	end

	arg_10_0.interest_points[arg_10_1] = nil

	if var_10_0.wwise_playing_id then
		WwiseWorld.stop_event(arg_10_0.wwise_world, var_10_0.wwise_playing_id)
		WwiseWorld.destroy_manual_source(arg_10_0.wwise_world, var_10_0.wwise_source_id)
	end
end

AIInterestPointSystem.update = function (arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0.is_server then
		arg_11_0:debug_draw(arg_11_2, arg_11_1.dt)
		arg_11_0:spawn_interest_points()
		arg_11_0:release_obsolete_requests(arg_11_2)
		arg_11_0:resolve_requests()
	end

	local var_11_0 = arg_11_1.dt

	if not var_0_2.navigation_thread_disabled then
		GwNavWorld.kick_async_update(arg_11_0.nav_world, var_11_0)

		NAVIGATION_RUNNING_IN_THREAD = true
	else
		GwNavWorld.update(arg_11_0.nav_world, var_11_0)
	end
end

AIInterestPointSystem.breed_spawned_callback = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2.dead_breed_data

	BREED_DIE_LOOKUP[arg_12_0] = {
		AIInterestPointSystem.cleanup_dead_breed,
		var_12_0
	}
end

AIInterestPointSystem.cleanup_dead_breed = function (arg_13_0, arg_13_1)
	arg_13_1[1] = false
end

local var_0_7 = {}
local var_0_8 = 0

AIInterestPointSystem.spawn_interest_points = function (arg_14_0)
	local var_14_0 = Managers.state.conflict
	local var_14_1 = 8
	local var_14_2 = arg_14_0.interest_points_to_spawn
	local var_14_3 = next(var_14_2)
	local var_14_4 = arg_14_0._breed_override_lookup

	while var_14_1 > 0 and var_14_3 ~= nil do
		local var_14_5 = var_14_2[var_14_3]
		local var_14_6 = var_14_5.pack_members
		local var_14_7 = var_14_5.points_n

		for iter_14_0 = 1, var_14_7 do
			local var_14_8 = var_14_5.points[iter_14_0]

			if var_14_8.is_position_on_navmesh then
				local var_14_9 = var_14_6[iter_14_0]

				if not var_14_9.name then
					var_14_9 = var_14_9[math.random(1, #var_14_9)]
				end

				local var_14_10 = {
					ignore_event_counter = true
				}
				local var_14_11 = "enemy_recycler"
				local var_14_12
				local var_14_13 = "roam"
				local var_14_14
				local var_14_15 = Vector3Aux.unbox(var_14_8.position)

				if var_14_4 and var_14_4[var_14_9.name] then
					var_14_9 = Breeds[var_14_4[var_14_9.name]]
				end

				var_14_8[1] = var_14_0:spawn_queued_unit(var_14_9, Vector3Box(var_14_15), var_14_8.rotation, var_14_11, var_14_12, var_14_13, var_14_10, var_14_14, var_14_8)
			else
				print("FAIL INTEREST POINT SPAWN UNIT")
			end
		end

		var_0_8 = var_0_8 + 1
		var_0_7[var_0_8] = var_14_3
		var_14_1 = var_14_1 - 1
		var_14_3 = next(var_14_2, var_14_3)
	end

	for iter_14_1 = 1, var_0_8 do
		var_14_2[var_0_7[iter_14_1]] = nil
	end

	var_0_8 = 0
end

AIInterestPointSystem.release_obsolete_requests = function (arg_15_0, arg_15_1)
	if arg_15_0.requests[arg_15_0.current_obsolete_request] == nil then
		arg_15_0.current_obsolete_request = nil
	end

	local var_15_0 = next(arg_15_0.requests, arg_15_0.current_obsolete_request)

	if var_15_0 == nil then
		arg_15_0.current_obsolete_request = nil

		return
	end

	local var_15_1 = false
	local var_15_2 = arg_15_0.requests[var_15_0].claim_unit
	local var_15_3 = BLACKBOARDS[var_15_2]

	if not HEALTH_ALIVE[var_15_2] and true or var_15_3.confirmed_player_sighting then
		arg_15_0.current_obsolete_request = nil

		arg_15_0:api_release_claim(var_15_0)

		if var_15_3 then
			var_15_3.ip_request_id = nil
		end
	else
		arg_15_0.current_obsolete_request = var_15_0
	end
end

local function var_0_9(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0
	local var_16_1

	for iter_16_0 = arg_16_1, arg_16_2 do
		var_16_0 = arg_16_0[iter_16_0]

		if var_16_0 ~= nil then
			var_16_1 = iter_16_0

			break
		end
	end

	return var_16_0, var_16_1
end

AIInterestPointSystem._update_astar_result = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	arg_17_0.processing_astar = false
	arg_17_0.processing_best_point = nil
	arg_17_0.processing_best_ip_unit = nil
	arg_17_0.processing_best_point_extension = nil

	local var_17_0 = GwNavAStar.path_found(arg_17_4)

	if not var_17_0 then
		arg_17_2.failed_interest_points[arg_17_3] = true
	end

	if arg_17_1 then
		if not arg_17_0.reachable_interest_points[arg_17_1] then
			arg_17_0.reachable_interest_points[arg_17_1] = {}
		end

		arg_17_0.reachable_interest_points[arg_17_1][arg_17_3] = var_17_0
	end

	return var_17_0
end

local var_0_10 = {}

local function var_0_11(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = ScriptUnit.extension
	local var_18_1
	local var_18_2
	local var_18_3
	local var_18_4
	local var_18_5
	local var_18_6 = arg_18_1.min_range * arg_18_1.min_range
	local var_18_7 = arg_18_1.max_range * arg_18_1.max_range
	local var_18_8 = Vector3Aux.unbox(arg_18_1.position)
	local var_18_9 = math.huge
	local var_18_10 = BLACKBOARDS[arg_18_1.claim_unit]
	local var_18_11 = var_0_4[var_18_10.breed.race]
	local var_18_12 = Broadphase.query(arg_18_0, var_18_8, arg_18_1.max_range, var_0_10, var_18_11)

	for iter_18_0 = 1, var_18_12 do
		local var_18_13 = var_0_10[iter_18_0]
		local var_18_14 = var_18_0(var_18_13, "ai_interest_point_system")
		local var_18_15 = arg_18_1.current_request and arg_18_1.current_request.point_extension
		local var_18_16 = arg_18_3 and arg_18_4[arg_18_3] and arg_18_4[arg_18_3][var_18_13]

		if arg_18_3 and var_18_16 == nil then
			var_18_16 = arg_18_4[var_18_13] and arg_18_4[var_18_13][arg_18_3]
		end

		local var_18_17

		if var_18_16 == nil then
			local var_18_18 = arg_18_1.failed_interest_points[var_18_13]

			var_18_17 = var_18_18 and not var_18_18
		else
			var_18_17 = var_18_16
		end

		if var_18_15 ~= var_18_14 and (var_18_17 or var_18_17 == nil) then
			for iter_18_1 = 1, var_18_14.points_n do
				local var_18_19 = var_18_14.points[iter_18_1]

				if not var_18_19.claimed and var_18_19.is_position_on_navmesh and var_18_14 then
					local var_18_20 = Vector3Aux.unbox(var_18_19.position)
					local var_18_21 = Vector3.distance_squared(var_18_20, arg_18_2)

					if var_18_6 <= var_18_21 and var_18_21 < var_18_7 and var_18_21 < var_18_9 then
						var_18_3 = var_18_13
						var_18_4 = var_18_19
						var_18_5 = var_18_14
						var_18_9 = var_18_21
						var_18_2 = not var_18_17
						var_18_1 = not var_18_2
					end
				end
			end
		end
	end

	return var_18_3, var_18_4, var_18_5, var_18_1, var_18_2
end

local var_0_12 = 15

AIInterestPointSystem._start_astar_query = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8)
	GwNavAStar.start_with_propagation_box(arg_19_1, arg_19_4, arg_19_2, arg_19_3, var_0_12, arg_19_5)

	arg_19_0.processing_astar = true
	arg_19_0.processing_best_ip_unit = arg_19_6
	arg_19_0.processing_best_point = arg_19_7
	arg_19_0.processing_best_point_extension = arg_19_8
end

local function var_0_13(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	if arg_20_2 == nil then
		arg_20_0.result = "failed"
		arg_20_0.current_request = nil

		return true
	elseif arg_20_4 then
		arg_20_3.num_claimed_points = arg_20_3.num_claimed_points + 1
		arg_20_2.claimed = true
		arg_20_2.claim_unit = arg_20_0.claim_unit
		arg_20_0.interest_point_unit = arg_20_1
		arg_20_0.point = arg_20_2
		arg_20_0.point_extension = arg_20_3
		arg_20_0.result = "success"
		arg_20_0.current_request = nil

		local var_20_0 = arg_20_3.num_claimed_points / arg_20_3.points_n

		if arg_20_3.wwise_minimum_needed > arg_20_3.num_claimed_points then
			var_20_0 = 0
		end

		local var_20_1, var_20_2 = arg_20_5:game_object_or_level_id(arg_20_1)

		arg_20_6:send_rpc_all("rpc_interest_point_chatter_update", var_20_1, var_20_2, var_20_0)

		return true
	else
		return false
	end
end

AIInterestPointSystem.resolve_requests = function (arg_21_0)
	if next(arg_21_0.interest_points_to_spawn) ~= nil then
		return
	end

	local var_21_0, var_21_1 = var_0_9(arg_21_0.requests, arg_21_0.current_request_index, arg_21_0.last_request_index)

	if var_21_0 ~= nil then
		arg_21_0.current_request_index = var_21_1

		local var_21_2 = arg_21_0.astar
		local var_21_3 = arg_21_0.processing_astar
		local var_21_4 = false
		local var_21_5 = false
		local var_21_6
		local var_21_7
		local var_21_8
		local var_21_9 = var_21_0.current_request and var_21_0.current_request.interest_point_unit

		if not var_21_3 then
			local var_21_10 = false
			local var_21_11 = var_21_0.claim_unit
			local var_21_12 = POSITION_LOOKUP[var_21_11]

			if var_21_12 then
				local var_21_13

				var_21_6, var_21_7, var_21_8, var_21_5, var_21_13 = var_0_11(arg_21_0.broadphase, var_21_0, var_21_12, var_21_9, arg_21_0.reachable_interest_points)

				if var_21_7 and var_21_13 then
					local var_21_14 = var_21_12
					local var_21_15 = Vector3Aux.unbox(var_21_7.position)

					arg_21_0:_start_astar_query(var_21_2, var_21_14, var_21_15, arg_21_0.nav_world, arg_21_0.traverse_logic, var_21_6, var_21_7, var_21_8)

					var_21_4 = false
				else
					var_21_4 = true
				end
			else
				var_21_4 = true
			end
		elseif GwNavAStar.processing_finished(var_21_2) then
			var_21_6 = arg_21_0.processing_best_ip_unit
			var_21_7 = arg_21_0.processing_best_point
			var_21_8 = arg_21_0.processing_best_point_extension
			var_21_4 = true
			var_21_5 = arg_21_0:_update_astar_result(var_21_9, var_21_0, var_21_6, var_21_2)
		end

		if var_21_4 and var_0_13(var_21_0, var_21_6, var_21_7, var_21_8, var_21_5, arg_21_0.network_manager, arg_21_0.network_transmit) then
			arg_21_0.current_request_index = arg_21_0.current_request_index + 1
		end
	end
end

AIInterestPointSystem.debug_draw = function (arg_22_0, arg_22_1, arg_22_2)
	if not var_0_2.ai_interest_point_debug then
		return
	end

	local var_22_0 = QuickDrawer

	arg_22_0.debug_anim_t = (arg_22_0.debug_anim_t or 0) + arg_22_2

	if arg_22_0.debug_anim_t > 1 then
		arg_22_0.debug_anim_t = 0
	end

	for iter_22_0, iter_22_1 in pairs(arg_22_0.interest_points) do
		for iter_22_2 = 1, iter_22_1.points_n do
			local var_22_1, var_22_2, var_22_3 = Script.temp_count()
			local var_22_4 = iter_22_1.points[iter_22_2]
			local var_22_5 = Vector3Aux.unbox(var_22_4.position)
			local var_22_6 = Quaternion.forward(var_22_4.rotation:unbox())

			if not var_22_4.is_position_on_navmesh then
				var_22_0:cylinder(var_22_5, var_22_5 + Vector3.up(), 0.25, Colors.get("dark_red"), 5)
				var_22_0:cone(var_22_5 + Vector3.up() * 1.3 + var_22_6 * 0.25, var_22_5 + Vector3.up() * 1.3 - var_22_6 * 0.25, 0.1, Colors.get("dark_red"), 8, 8)
			elseif var_22_4.claimed then
				local var_22_7 = Vector3.up() * (arg_22_0.debug_anim_t * 0.2)

				var_22_0:circle(var_22_5 + Vector3.up() * 0.8, 0.25, Vector3.up(), Colors.get("lime_green"))
				var_22_0:cylinder(var_22_5 - var_22_7, var_22_5 + Vector3.up() * 1 - var_22_7, 0.25, Colors.get("lime_green"), 5)
				var_22_0:cone(var_22_5 + Vector3.up() * 1.3 + var_22_6 * 0.25, var_22_5 + Vector3.up() * 1.3 - var_22_6 * 0.25, 0.1, Colors.get("lime_green"), 8, 8)
			else
				var_22_0:cylinder(var_22_5, var_22_5 + Vector3.up(), 0.25, Colors.get("dark_green"), 5)
				var_22_0:cone(var_22_5 + Vector3.up() * 1.3 + var_22_6 * 0.25, var_22_5 + Vector3.up() * 1.3 - var_22_6 * 0.25, 0.1, Colors.get("dark_green"), 8, 8)
			end

			Script.set_temp_count(var_22_1, var_22_2, var_22_3)
		end
	end

	for iter_22_3, iter_22_4 in pairs(arg_22_0.requests) do
		local var_22_8 = iter_22_4.claim_unit

		if HEALTH_ALIVE[var_22_8] then
			local var_22_9 = BLACKBOARDS[var_22_8].ip_end_time

			if var_22_9 then
				local var_22_10 = POSITION_LOOKUP[var_22_8] + Vector3.up() * (var_22_9 - arg_22_1) + Vector3.up()

				var_22_0:cylinder(POSITION_LOOKUP[var_22_8], var_22_10, 0.25, Colors.get("dark_red"), 5)
			end
		end
	end
end

AIInterestPointSystem.api_start_async_claim_request = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	arg_23_0.last_request_index = arg_23_0.last_request_index + 1

	local var_23_0 = arg_23_0.last_request_index
	local var_23_1 = {
		claim_unit = arg_23_1,
		position = Vector3Aux.box(nil, arg_23_2),
		min_range = arg_23_3,
		max_range = arg_23_4,
		failed_interest_points = {}
	}

	if arg_23_5 ~= nil then
		var_23_1.current_request = arg_23_0.requests[arg_23_5]
	end

	arg_23_0.requests[var_23_0] = var_23_1

	return var_23_0
end

AIInterestPointSystem.api_get_claim = function (arg_24_0, arg_24_1)
	fassert(arg_24_1, "Tried to get claim with no request_id")

	return arg_24_0.requests[arg_24_1]
end

AIInterestPointSystem.api_release_claim = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.requests[arg_25_1]

	assert(var_25_0)

	if var_25_0.result == "success" and Unit.alive(var_25_0.interest_point_unit) then
		local var_25_1 = var_25_0.point_extension

		var_25_1.num_claimed_points = var_25_1.num_claimed_points - 1
		var_25_0.point.claimed = nil
		var_25_0.point.claim_unit = nil

		local var_25_2 = var_25_1.num_claimed_points / var_25_1.points_n

		if var_25_1.wwise_minimum_needed > var_25_1.num_claimed_points then
			var_25_2 = 0
		end

		local var_25_3 = var_25_0.interest_point_unit
		local var_25_4, var_25_5 = arg_25_0.network_manager:game_object_or_level_id(var_25_3)

		assert(var_25_4)

		if arg_25_0.network_manager:in_game_session() then
			Managers.state.network.network_transmit:send_rpc_all("rpc_interest_point_chatter_update", var_25_4, var_25_5, var_25_2)
		end
	end

	if arg_25_0.current_request_index == arg_25_1 and arg_25_0.processing_astar then
		local var_25_6 = arg_25_0.astar

		if not GwNavAStar.processing_finished(var_25_6) then
			GwNavAStar.cancel(var_25_6)
		end

		arg_25_0.processing_astar = false
		arg_25_0.processing_best_point = nil
		arg_25_0.processing_best_ip_unit = nil
		arg_25_0.processing_best_point_extension = nil
	end

	table.clear(var_25_0.failed_interest_points)

	var_25_0.current_request = nil
	arg_25_0.requests[arg_25_1] = nil
end

AIInterestPointSystem.rpc_interest_point_chatter_update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = arg_26_0.network_manager:game_object_or_level_unit(arg_26_2, arg_26_3)

	if var_26_0 == nil then
		return
	end

	local var_26_1 = arg_26_0.interest_points[var_26_0]

	if not var_26_1 then
		print("Missing interest_point should not happen?")

		return
	end

	local var_26_2 = arg_26_0.wwise_world
	local var_26_3 = var_26_1.percent_claimed or 0

	if arg_26_4 == var_26_3 then
		return
	elseif var_26_3 > 0 and arg_26_4 == 0 then
		var_0_5("AIInterestPointSystem stopping event")

		if not var_26_1.wwise_source_id or not WwiseWorld.has_source(var_26_2, var_26_1.wwise_source_id) then
			print("[AIInterestPointExtension] Trying to stop event on non-existing wwise_source_id", var_26_1.wwise_source_id)

			var_26_1.percent_claimed = 0
			var_26_1.wwise_source_id = nil
			var_26_1.wwise_playing_id = nil

			return
		end

		WwiseWorld.stop_event(var_26_2, var_26_1.wwise_playing_id)
		WwiseWorld.destroy_manual_source(var_26_2, var_26_1.wwise_source_id)

		var_26_1.wwise_source_id = nil
		var_26_1.wwise_playing_id = nil
	elseif var_26_3 == 0 and arg_26_4 > 0 then
		var_0_5("AIInterestPointSystem starting event %f", arg_26_4)

		local var_26_4 = var_26_1.wwise_event
		local var_26_5 = true
		local var_26_6 = WwiseWorld.make_manual_source(var_26_2, var_26_0)

		var_26_1.wwise_playing_id, var_26_1.wwise_source_id = WwiseWorld.trigger_event(var_26_2, var_26_4, var_26_5, var_26_6), var_26_6

		WwiseWorld.set_source_parameter(var_26_2, var_26_1.wwise_source_id, "chatter_number", arg_26_4)
	elseif arg_26_4 < 0 then
		fassert(false, "[AIInterestPointExtension] percent_claimed can never be a negative value")
	else
		if not var_26_1.wwise_source_id or not WwiseWorld.has_source(var_26_2, var_26_1.wwise_source_id) then
			print("[AIInterestPointExtension] Trying to set parameter on non-existing wwise_source_id", var_26_1.wwise_source_id)

			var_26_1.percent_claimed = 0
			var_26_1.wwise_source_id = nil
			var_26_1.wwise_playing_id = nil

			return
		end

		var_0_5("AIInterestPointSystem setting percent_claimed %f", arg_26_4)
		WwiseWorld.set_source_parameter(var_26_2, var_26_1.wwise_source_id, "chatter_number", arg_26_4)
	end

	var_26_1.percent_claimed = arg_26_4
end

AIInterestPointSystem.set_breed_override_lookup = function (arg_27_0, arg_27_1)
	arg_27_0._breed_override_lookup = arg_27_1
end
