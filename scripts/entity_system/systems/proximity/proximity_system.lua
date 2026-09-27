-- chunkname: @scripts/entity_system/systems/proximity/proximity_system.lua

local script_data = script_data
local dialogue_debug_proximity_system = script_data.dialogue_debug_proximity_system

dialogue_debug_proximity_system = dialogue_debug_proximity_system or Development.parameter("dialogue_debug_proximity_system")
script_data.dialogue_debug_proximity_system = dialogue_debug_proximity_system

local max = math.max(DialogueSettings.enemies_close_distance, DialogueSettings.enemies_distant_distance)
local max_2 = math.max(DialogueSettings.friends_close_distance, DialogueSettings.friends_distant_distance)
local raycast_enemy_check_interval = DialogueSettings.raycast_enemy_check_interval
local hear_enemy_check_interval = DialogueSettings.hear_enemy_check_interval
local special_proximity_distance = DialogueSettings.special_proximity_distance
local special_proximity_distance_heard = DialogueSettings.special_proximity_distance_heard
local num = special_proximity_distance_heard * special_proximity_distance_heard
local num_2 = 1
local num_3 = 2
local num_4 = 3
local num_5 = 4

ProximitySystem = class(ProximitySystem, ExtensionSystemBase)

local tbl = {
	"PlayerProximityExtension",
	"AIProximityExtension"
}

ProximitySystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	arg_1_1.entity_manager:register_system(self, arg_1_2, tbl)

	self.world = arg_1_1.world
	self.physics_world = World.get_data(arg_1_1.world, "physics_world")
	self.unit_extension_data = {}
	self.frozen_unit_extension_data = {}
	self.player_unit_extensions_map = {}
	self.ai_unit_extensions_map = {}
	self.special_unit_extension_map = {}
	self.unit_forwards = {}

	local alloc_table = FrameTable.alloc_table()
	local sides = Managers.state.side:sides()

	for i = 1, #sides do
		local var_1_2 = sides[i]

		alloc_table[#alloc_table + 1] = var_1_2:name()
	end

	self.enemy_broadphase = Broadphase(max, 128, alloc_table)
	self.special_units_broadphase = Broadphase(special_proximity_distance, 8)
	self.player_units_broadphase = Broadphase(max_2, 8, alloc_table)
	self.enemy_check_raycasts = {}
	self.raycast_read_index = 1
	self.raycast_write_index = 1
	self.raycast_max_index = 16
	self._old_nearby = {}
	self._new_nearby = {}
	self._broadphase_result = {}
	self._pseudo_sorted_list = {}
	self._old_enabled_fx = {}
	self._new_enabled_fx = {}
	self._is_spectator = false
	self._spectated_player = nil
	self._spectated_player_unit = nil

	Managers.state.event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
end

ProximitySystem.destroy = function (self)
	-- function 2
	self.unit_extension_data = nil
end

ProximitySystem.on_spectator_target_changed = function (self, arg_3_1)
	-- function 3
	self._spectated_player_unit = arg_3_1
	self._spectated_player = Managers.player:owner(arg_3_1)
	self._is_spectator = true
end

ProximitySystem.on_add_extension = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local side = arg_4_4.side
	local tbl = {
		last_num_friends_nearby = 0,
		last_num_enemies_nearby = 0,
		side = side
	}

	ScriptUnit.set_extension(arg_4_2, "proximity_system", tbl)

	self.unit_extension_data[arg_4_2] = tbl

	if arg_4_3 == "PlayerProximityExtension" then
		self.player_unit_extensions_map[arg_4_2] = tbl
		tbl.proximity_types = {
			friends_close = {
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.friends_close_distance,
				broadphase_pairs = {
					{
						check = self.player_unit_extensions_map,
						broadphase = self.player_units_broadphase
					}
				},
				broadphase_categories = side.ally_broadphase_categories
			},
			friends_distant = {
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.friends_distant_distance,
				broadphase_pairs = {
					{
						check = self.player_unit_extensions_map,
						broadphase = self.player_units_broadphase
					}
				},
				broadphase_categories = side.ally_broadphase_categories
			},
			enemies_close = {
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.enemies_close_distance,
				broadphase_pairs = {
					{
						check = self.ai_unit_extensions_map,
						broadphase = self.enemy_broadphase
					},
					{
						check = self.player_unit_extensions_map,
						broadphase = self.player_units_broadphase
					}
				},
				broadphase_categories = side.enemy_broadphase_categories
			},
			enemies_distant = {
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.enemies_distant_distance,
				broadphase_pairs = {
					{
						check = self.ai_unit_extensions_map,
						broadphase = self.enemy_broadphase
					},
					{
						check = self.player_unit_extensions_map,
						broadphase = self.player_units_broadphase
					}
				},
				broadphase_categories = side.enemy_broadphase_categories
			},
			vs_passing_hoisted_hero = {
				disable_in_ghost_mode = true,
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.passing_hoisted_range,
				broadphase_pairs = {
					{
						check = self.player_unit_extensions_map,
						broadphase = self.player_units_broadphase
					}
				},
				broadphase_categories = side.enemy_broadphase_categories
			}
		}
		tbl.raycast_timer = 0
		tbl.hear_timer = 0
		tbl.player_broadphase_id = Broadphase.add(self.player_units_broadphase, arg_4_2, Unit.world_position(arg_4_2, 0), 0.5, arg_4_4.side.broadphase_category)

		local breed = arg_4_4.breed

		breed = breed or arg_4_4.profile.breed

		if not breed and not breed.proximity_system_check then
			tbl.special_broadphase_id = Broadphase.add(self.special_units_broadphase, arg_4_2, Unit.world_position(arg_4_2, 0), 0.5)
			self.special_unit_extension_map[arg_4_2] = tbl
		end

		tbl.bot_reaction_times = {}
		tbl.has_been_seen = false
	elseif arg_4_3 == "AIProximityExtension" then
		tbl.enemy_broadphase_id = Broadphase.add(self.enemy_broadphase, arg_4_2, Unit.world_position(arg_4_2, 0), 0.5)
		tbl.bot_reaction_times = {}
		tbl.has_been_seen = false
		self.ai_unit_extensions_map[arg_4_2] = tbl

		if not arg_4_4.breed.proximity_system_check then
			tbl.special_broadphase_id = Broadphase.add(self.special_units_broadphase, arg_4_2, Unit.world_position(arg_4_2, 0), 0.5)
			self.special_unit_extension_map[arg_4_2] = tbl
		end
	end

	return tbl
end

ProximitySystem.extensions_ready = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if arg_5_3 == "PlayerProximityExtension" then
		local var_5_0 = self.player_unit_extensions_map[arg_5_2]

		if not var_5_0.side then
			return
		end

		var_5_0.side = Managers.state.side.side_by_unit[arg_5_2]
	end
end

ProximitySystem.on_remove_extension = function (self, arg_6_1, arg_6_2)
	-- function 6
	self.frozen_unit_extension_data[arg_6_1] = nil

	self:_cleanup_extension(arg_6_1, arg_6_2)
	ScriptUnit.remove_extension(arg_6_1, self.NAME)
end

ProximitySystem.on_freeze_extension = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = self.unit_extension_data[arg_7_1]

	fassert(var_7_0, "Unit was already frozen.")

	self.frozen_unit_extension_data[arg_7_1] = var_7_0

	self:_cleanup_extension(arg_7_1, arg_7_2)
end

ProximitySystem._cleanup_extension = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = self.unit_extension_data[arg_8_1]

	if var_8_0 == nil then
		return
	end

	if not var_8_0.enemy_broadphase_id then
		Broadphase.remove(self.enemy_broadphase, var_8_0.enemy_broadphase_id)

		var_8_0.enemy_broadphase_id = nil
	end

	if not var_8_0.player_broadphase_id then
		Broadphase.remove(self.player_units_broadphase, var_8_0.player_broadphase_id)

		var_8_0.player_broadphase_id = nil
	end

	if not var_8_0.special_broadphase_id then
		Broadphase.remove(self.special_units_broadphase, var_8_0.special_broadphase_id)

		var_8_0.special_broadphase_id = nil
	end

	self.unit_extension_data[arg_8_1] = nil
	self.player_unit_extensions_map[arg_8_1] = nil
	self.ai_unit_extensions_map[arg_8_1] = nil
	self.special_unit_extension_map[arg_8_1] = nil
end

ProximitySystem.freeze = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local frozen_unit_extension_data = self.frozen_unit_extension_data

	if not frozen_unit_extension_data[arg_9_1] then
		return
	end

	local var_9_1 = self.unit_extension_data[arg_9_1]

	fassert(var_9_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_9_1, arg_9_2)

	self.unit_extension_data[arg_9_1] = nil
	frozen_unit_extension_data[arg_9_1] = var_9_1
end

ProximitySystem.unfreeze = function (self, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = self.frozen_unit_extension_data[arg_10_1]

	fassert(var_10_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extension_data[arg_10_1] = nil
	self.unit_extension_data[arg_10_1] = var_10_0

	fassert(arg_10_2 == "AIProximityExtension", "Unexpected unfreeze extension")

	var_10_0.enemy_broadphase_id = Broadphase.add(self.enemy_broadphase, arg_10_1, Unit.world_position(arg_10_1, 0), 0.5)
	var_10_0.bot_reaction_times = {}
	var_10_0.has_been_seen = false
	self.ai_unit_extensions_map[arg_10_1] = var_10_0

	if not Unit.get_data(arg_10_1, "breed").proximity_system_check then
		var_10_0.special_broadphase_id = Broadphase.add(self.special_units_broadphase, arg_10_1, Unit.world_position(arg_10_1, 0), 0.5)
		self.special_unit_extension_map[arg_10_1] = var_10_0
	end
end

local function fn(arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local world_position = Unit.world_position(arg_11_1, Unit.node(arg_11_1, "camera_attach"))
	local box, var_11_2 = Unit.box(arg_11_2)
	local translation = Matrix4x4.translation(box)
	local normalize = Vector3.normalize(translation - world_position)
	local length = Vector3.length(translation - world_position)
	local immediate_raycast = PhysicsWorld.immediate_raycast(arg_11_0, world_position, normalize, length, "all", "types", "both", "collision_filter", "filter_lookat_object_ray")

	if not immediate_raycast then
		for i, v in ipairs(immediate_raycast) do
			local unit = Actor.unit(v[num_5])

			if unit ~= arg_11_1 then
				if unit == arg_11_2 then
					if not script_data.debug_has_been_seen then
						QuickDrawerStay:line(world_position, v[num_2], Color(0, 255, 0))
						QuickDrawerStay:line(v[num_2], world_position + normalize * length, Color(255, 0, 0))
					end

					return true
				elseif not Unit.get_data(unit, "breed") then
					return false
				end
			end
		end
	end
end

local function fn_2(arg_12_0, arg_12_1)
	-- function 12
	local game = arg_12_1:game()

	if not game then
		local unit_game_object_id = arg_12_1:unit_game_object_id(arg_12_0)

		return (GameSession.game_object_field(game, unit_game_object_id, "aim_direction"))
	else
		local world_rotation = Unit.world_rotation(arg_12_0, 0)

		return (Quaternion.forward(world_rotation))
	end
end

local tbl_2 = {}

ProximitySystem.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not script_data.debug_has_been_seen then
		for k, v in pairs(self.unit_extension_data) do
			local var_13_0

			if not v.has_been_seen then
				var_13_0 = Color(0, 255, 0)

				if not var_13_0 then
					-- Nothing
				end
			end

			var_13_0 = Color(255, 0, 0)

			::label_13_0::

			QuickDrawer:sphere(Unit.local_position(k, 0) + Vector3.up(), 2, var_13_0)
		end
	end
end

ProximitySystem._valid_dialogue_unit = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local has_extension = ScriptUnit.has_extension(arg_14_1, "ghost_mode_system")

	if not has_extension and not has_extension:is_in_ghost_mode() then
		return false
	end

	if arg_14_2 == "vs_passing_hoisted_hero" then
		local has_extension_2 = ScriptUnit.has_extension(arg_14_1, "status_system")

		if not (not has_extension_2 and has_extension_2:is_grabbed_by_pack_master()) then
			return false
		end
	end

	return true
end

ProximitySystem.physics_async_update = function (self, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0 = tbl_2
	local dt = arg_15_1.dt
	local move = Broadphase.move
	local local_position = Unit.local_position
	local enemy_broadphase = self.enemy_broadphase

	for k, v in pairs(self.ai_unit_extensions_map) do
		local var_15_5 = local_position(k, 0)

		if not var_15_5 then
			move(enemy_broadphase, v.enemy_broadphase_id, var_15_5)
		end
	end

	local player_unit_extensions_map = self.player_unit_extensions_map
	local player_units_broadphase = self.player_units_broadphase

	for k_2, v_2 in pairs(player_unit_extensions_map) do
		local var_15_8 = local_position(k_2, 0)

		if not var_15_8 then
			move(player_units_broadphase, v_2.player_broadphase_id, var_15_8)
		end
	end

	local special_units_broadphase = self.special_units_broadphase

	for k_3, v_3 in pairs(self.special_unit_extension_map) do
		local var_15_10 = local_position(k_3, 0)

		if not var_15_10 then
			move(special_units_broadphase, v_3.special_broadphase_id, var_15_10)
		end
	end

	local enemy_check_raycasts = self.enemy_check_raycasts
	local raycast_read_index = self.raycast_read_index
	local raycast_write_index = self.raycast_write_index
	local raycast_max_index = self.raycast_max_index
	local network = Managers.state.network

	for k_4, v_4 in pairs(player_unit_extensions_map) do
		repeat
			local var_15_16 = local_position(k_4, 0)

			if not var_15_16 then
				break
			end

			local enemy_units_lookup = v_4.side.enemy_units_lookup

			for k_5, v_5 in pairs(v_4.proximity_types) do
				repeat
					v_5.cooldown = v_5.cooldown - dt

					if v_5.cooldown > 0 then
						break
					end

					v_5.cooldown = DialogueSettings.proximity_trigger_interval

					if not v_5.disable_in_ghost_mode then
						local has_extension = ScriptUnit.has_extension(k_4, "ghost_mode_system")

						if not has_extension and not has_extension:is_in_ghost_mode() then
							break
						end
					end

					local distance = v_5.distance
					local broadphase_categories = v_5.broadphase_categories
					local broadphase_pairs = v_5.broadphase_pairs
					local num_2 = v_5.num
					local num_3 = 0

					for i10 = 1, #broadphase_pairs do
						local broadphase = broadphase_pairs[i10].broadphase
						local query = Broadphase.query(broadphase, var_15_16, distance, var_15_0, broadphase_categories)
						local check = broadphase_pairs[i10].check

						for i11 = 1, query do
							local var_15_27 = var_15_0[i11]

							if (var_15_27 == k_4 or not check[var_15_27]) and not self:_valid_dialogue_unit(var_15_27, k_5) then
								num_3 = num_3 + 1
							end
						end
					end

					if num_2 ~= num_3 then
						v_5.num = num_3

						local extension_input = ScriptUnit.extension_input(k_4, "dialogue_system")
						local alloc_table = FrameTable.alloc_table()

						alloc_table.num_units = num_3

						extension_input:trigger_dialogue_event(k_5, alloc_table)
					end
				until true
			end

			local num_4 = v_4.raycast_timer + dt
			local num_5 = v_4.hear_timer + dt
			local var_15_32
			local var_15_33

			if num_4 > raycast_enemy_check_interval then
				local var_15_34 = fn_2(k_4, network)
				local flat = Vector3.flat(var_15_16)

				var_15_34.z = 0

				local var_15_36 = special_proximity_distance
				local query_2 = Broadphase.query(special_units_broadphase, var_15_16, var_15_36, var_15_0)

				for i12 = 1, query_2 do
					local var_15_38 = var_15_0[i12]

					var_15_0[i12] = nil

					local var_15_39 = HEALTH_ALIVE[var_15_38]

					if (var_15_38 == k_4 or not var_15_39) and not enemy_units_lookup[var_15_38] and not self:_valid_dialogue_unit(var_15_38, nil) then
						local var_15_40 = local_position(var_15_38, 0)
						local flat_2 = Vector3.flat(var_15_40)
						local num_6 = flat_2 - flat
						local normalize = Vector3.normalize(num_6)

						if not (not (num_5 > hear_enemy_check_interval) or not (Vector3.distance_squared(var_15_40, var_15_16) < num)) then
							local extension_input_2 = ScriptUnit.extension_input(k_4, "dialogue_system")
							local alloc_table_2 = FrameTable.alloc_table()
							local get_data = Unit.get_data(var_15_38, "breed")

							if not get_data then
								alloc_table_2.enemy_tag = get_data.name

								assert(alloc_table_2.enemy_tag)

								alloc_table_2.enemy_unit = var_15_38
								alloc_table_2.distance = Vector3.distance(flat_2, flat)

								extension_input_2:trigger_dialogue_event("heard_enemy", alloc_table_2)

								var_15_33 = true
							end
						end

						if Vector3.dot(normalize, var_15_34) > 0.7 then
							var_15_32 = true
							enemy_check_raycasts[raycast_write_index] = k_4
							enemy_check_raycasts[raycast_write_index + 1] = var_15_38
							raycast_write_index = (raycast_write_index + 1) % raycast_max_index + 1

							if raycast_read_index == raycast_write_index then
								raycast_read_index = (raycast_read_index + 1) % raycast_max_index + 1
							end
						end
					end
				end
			end

			if not var_15_32 then
				num_4 = 0
			end

			if not var_15_33 then
				num_5 = 0
			end

			self.raycast_read_index = raycast_read_index
			self.raycast_write_index = raycast_write_index
			v_4.hear_timer = num_5
			v_4.raycast_timer = num_4
		until true
	end

	self:_update_nearby_boss()
	self:_update_nearby_enemies()
end

local num_6 = 12
local flow_event = Unit.flow_event
local alive = Unit.alive

local function fn_3(self, arg_16_1, arg_16_2)
	-- function 16
	local var_16_0 = self[arg_16_2]

	self[arg_16_1] = var_16_0
	self[arg_16_2] = nil

	return var_16_0
end

local function fn_4(self, arg_17_1, arg_17_2)
	-- function 17
	local var_17_0 = self[arg_17_2]

	self[arg_17_2] = self[arg_17_1]
	self[arg_17_1] = var_17_0

	return var_17_0
end

local function fn_5(arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	return fn_3(arg_18_0, arg_18_1, arg_18_2), arg_18_2 - 1
end

local function fn_6(self, arg_19_1, arg_19_2)
	-- function 19
	if not self[arg_19_2] then
		self[arg_19_2] = nil
	else
		flow_event(arg_19_2, "enable_proximity_fx")
	end

	arg_19_1[arg_19_2] = true
end

local function fn_7(self, arg_20_1, arg_20_2)
	-- function 20
	if not self[arg_20_2] then
		flow_event(arg_20_2, "disable_proximity_fx")

		self[arg_20_2] = nil
	end
end

ProximitySystem._update_nearby_boss = function (self)
	-- function 21
	if not DEDICATED_SERVER then
		return
	end

	local _spectated_player

	if not self._is_spectator then
		_spectated_player = self._spectated_player

		if not _spectated_player then
			-- Nothing
		end
	end

	_spectated_player = Managers.player:local_player()

	::label_21_0::

	if not _spectated_player then
		return
	end

	local player_unit = _spectated_player.player_unit

	if not player_unit then
		return
	end

	local _broadphase_result = self._broadphase_result
	local local_position = Unit.local_position(player_unit, 0)

	if not local_position then
		return
	end

	local query = Broadphase.query(self.enemy_broadphase, local_position, 3, _broadphase_result)
	local system = Managers.state.entity:system("ai_system")

	for i = 1, query do
		local var_21_6 = _broadphase_result[i]
		local get_data = Unit.get_data(var_21_6, "breed")
		local get_attributes = system:get_attributes(var_21_6)

		if not get_data and not get_data.boss and get_data.server_controlled_health_bar and not get_attributes.grudge_marked or not self:_valid_dialogue_unit(var_21_6, nil) then
			self.closest_boss_unit = var_21_6

			break
		end
	end
end

ProximitySystem._update_nearby_enemies = function (self)
	-- function 22
	if not DEDICATED_SERVER then
		return
	end

	local _old_nearby = self._old_nearby
	local _new_nearby = self._new_nearby
	local _broadphase_result = self._broadphase_result

	table.clear(_new_nearby)

	local _pseudo_sorted_list = self._pseudo_sorted_list
	local _old_enabled_fx = self._old_enabled_fx
	local _new_enabled_fx = self._new_enabled_fx
	local tbl

	if not self._is_spectator then
		tbl = {
			self._spectated_player
		}

		if not tbl then
			-- Nothing
		end
	end

	tbl = Managers.player:players_at_peer(Network.peer_id())

	::label_22_0::

	local var_22_7 = Vector3(0, 0, 0)
	local num = 0
	local camera = Managers.state.camera

	for k, v in pairs(tbl) do
		if not self._is_spectator then
			var_22_7 = Unit.world_position(v.player_unit, 0)
			num = num + 1
		elseif not v.bot_player then
			var_22_7 = camera:camera_position(v.viewport_name)
			num = num + 1
		end
	end

	if num > 0 then
		local num_2 = var_22_7 / num
		local count = #_pseudo_sorted_list
		local query = Broadphase.query(self.enemy_broadphase, num_2, 30, _broadphase_result)

		for k_2 = 1, query do
			local var_22_13 = _broadphase_result[k_2]

			if not self:_valid_dialogue_unit(var_22_13, nil) then
				_new_nearby[var_22_13] = Vector3.distance_squared(Unit.local_position(var_22_13, 0), num_2)

				if not _old_nearby[var_22_13] then
					count = count + 1
					_pseudo_sorted_list[count] = var_22_13
				end
			end
		end

		local max_allowed_proximity_fx = script_data.max_allowed_proximity_fx

		max_allowed_proximity_fx = max_allowed_proximity_fx or num_6

		local var_22_15 = _pseudo_sorted_list[1]

		if not var_22_15 then
			local var_22_16 = _new_nearby[var_22_15]

			while not (var_22_16 or not (count > 0)) do
				var_22_15, count = fn_5(_pseudo_sorted_list, 1, count)
				var_22_16 = _new_nearby[var_22_15]
			end

			local var_22_17
			local num_3 = 1

			while num_3 <= count do
				local var_22_19 = num_3

				num_3 = num_3 + 1

				local var_22_20 = var_22_15
				local var_22_21 = var_22_16

				var_22_15 = _pseudo_sorted_list[num_3]
				var_22_16 = _new_nearby[var_22_15]

				while not (var_22_16 or not (num_3 <= count)) do
					var_22_15, count = fn_5(_pseudo_sorted_list, num_3, count)
					var_22_16 = _new_nearby[var_22_15]
				end

				if not (not var_22_16 and not (var_22_16 < var_22_21)) then
					fn_4(_pseudo_sorted_list, var_22_19, num_3)

					var_22_15 = var_22_20
					var_22_16 = var_22_21
				end

				if not alive(_pseudo_sorted_list[var_22_19]) then
					table.dump(_old_enabled_fx, "old_enabled_fx", 2)
					table.dump(_new_enabled_fx, "new_enabled_fx", 2)
					table.dump(_old_nearby, "old_nearby", 2)
					table.dump(_new_nearby, "new_nearby", 2)
					table.dump(_pseudo_sorted_list, "list", 2)
					assert(false, "Detected deleted unit in proximity fx list.")
				end

				local var_22_22 = _pseudo_sorted_list[var_22_19]

				if var_22_19 <= max_allowed_proximity_fx then
					fn_6(_old_enabled_fx, _new_enabled_fx, var_22_22)

					local has_extension = ScriptUnit.has_extension(var_22_22, "aim_system")

					if not has_extension then
						has_extension:set_enabled(true)
					end
				else
					fn_7(_old_enabled_fx, _new_enabled_fx, var_22_22)

					local has_extension_2 = ScriptUnit.has_extension(var_22_22, "aim_system")

					if not has_extension_2 then
						has_extension_2:set_enabled(false)
					end
				end
			end

			if not var_22_16 then
				if num_3 <= max_allowed_proximity_fx then
					fn_6(_old_enabled_fx, _new_enabled_fx, var_22_15)
				else
					fn_7(_old_enabled_fx, _new_enabled_fx, var_22_15)
				end
			end

			self:_clear_old_enabled_fx(_old_enabled_fx)
			self:_nearby_enemies_debug(_pseudo_sorted_list, _new_nearby, _new_enabled_fx)

			self._old_enabled_fx = _new_enabled_fx
			self._new_enabled_fx = _old_enabled_fx
		end
	end

	self._old_nearby = _new_nearby
	self._new_nearby = _old_nearby
end

ProximitySystem._nearby_enemies_debug = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	if not script_data.debug_proximity_fx then
		for i, v in ipairs(arg_23_1) do
			local var_23_0 = arg_23_2[v]

			if not var_23_0 then
				local sqrt = math.sqrt(var_23_0)
				local num = 255 - math.min(sqrt * 8, 255)
				local var_23_3 = arg_23_3[v]
				local var_23_4

				if not var_23_3 then
					var_23_4 = Color(num, num, 255)
				else
					var_23_4 = Color(num, 255, num)
				end

				local colored_text = Debug.colored_text
				local var_23_6 = var_23_4
				local var_23_7 = tostring(Unit.get_data(v, "debug_random"))
				local flag

				flag = not var_23_3 and " enabled " and " disabled "

				colored_text(var_23_6, var_23_7 .. flag .. string.format("%.2f", sqrt))
			else
				print("ERROR", i)
			end
		end

		for k, v_2 in pairs(arg_23_3) do
			QuickDrawer:sphere(Unit.local_position(k, 0), 1.2, Color(0, 255, 0))
		end
	end
end

ProximitySystem._clear_old_enabled_fx = function (arg_24_0, arg_24_1)
	-- function 24
	for k, v in pairs(arg_24_1) do
		if not alive(k) then
			flow_event(k, "disable_proximity_fx")
		end
	end

	table.clear(arg_24_1)
end

ProximitySystem.post_update = function (self, arg_25_1, arg_25_2)
	-- function 25
	local enemy_check_raycasts = self.enemy_check_raycasts
	local physics_world = self.physics_world
	local system = Managers.state.entity:system("darkness_system")
	local raycast_read_index = self.raycast_read_index

	if raycast_read_index ~= self.raycast_write_index then
		self.raycast_read_index = (raycast_read_index + 1) % self.raycast_max_index + 1

		local var_25_4 = enemy_check_raycasts[raycast_read_index]
		local var_25_5 = enemy_check_raycasts[raycast_read_index + 1]

		if not alive(var_25_4) and not alive(var_25_5) then
			local world_position = Unit.world_position(var_25_5, 0)

			if not (not not system:is_in_darkness(world_position) or fn(physics_world, var_25_4, var_25_5)) then
				local flat = Vector3.flat(world_position)
				local local_position = Unit.local_position(var_25_4, 0)
				local flat_2 = Vector3.flat(local_position)
				local extension_input = ScriptUnit.extension_input(var_25_4, "dialogue_system")
				local alloc_table = FrameTable.alloc_table()

				alloc_table.enemy_tag = Unit.get_data(var_25_5, "breed").name

				assert(alloc_table.enemy_tag)

				alloc_table.enemy_unit = var_25_5
				alloc_table.distance = Vector3.distance(flat, flat_2)
				ScriptUnit.extension(var_25_5, "proximity_system").has_been_seen = true

				extension_input:trigger_dialogue_event("seen_enemy", alloc_table)
			end
		end
	end
end

ProximitySystem.hot_join_sync = function (arg_26_0, arg_26_1)
	-- function 26
	return
end
