-- chunkname: @scripts/entity_system/systems/proximity/proximity_system.lua

script_data.dialogue_debug_proximity_system = script_data.dialogue_debug_proximity_system or Development.parameter("dialogue_debug_proximity_system")

local var_0_0 = math.max(DialogueSettings.enemies_close_distance, DialogueSettings.enemies_distant_distance)
local var_0_1 = math.max(DialogueSettings.friends_close_distance, DialogueSettings.friends_distant_distance)
local var_0_2 = DialogueSettings.raycast_enemy_check_interval
local var_0_3 = DialogueSettings.hear_enemy_check_interval
local var_0_4 = DialogueSettings.special_proximity_distance
local var_0_5 = DialogueSettings.special_proximity_distance_heard
local var_0_6 = var_0_5 * var_0_5
local var_0_7 = 1
local var_0_8 = 2
local var_0_9 = 3
local var_0_10 = 4

ProximitySystem = class(ProximitySystem, ExtensionSystemBase)

local var_0_11 = {
	"PlayerProximityExtension",
	"AIProximityExtension"
}

ProximitySystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_1.entity_manager:register_system(arg_1_0, arg_1_2, var_0_11)

	arg_1_0.world = arg_1_1.world
	arg_1_0.physics_world = World.get_data(arg_1_1.world, "physics_world")
	arg_1_0.unit_extension_data = {}
	arg_1_0.frozen_unit_extension_data = {}
	arg_1_0.player_unit_extensions_map = {}
	arg_1_0.ai_unit_extensions_map = {}
	arg_1_0.special_unit_extension_map = {}
	arg_1_0.unit_forwards = {}

	local var_1_0 = FrameTable.alloc_table()
	local var_1_1 = Managers.state.side:sides()

	for iter_1_0 = 1, #var_1_1 do
		local var_1_2 = var_1_1[iter_1_0]

		var_1_0[#var_1_0 + 1] = var_1_2:name()
	end

	arg_1_0.enemy_broadphase = Broadphase(var_0_0, 128, var_1_0)
	arg_1_0.special_units_broadphase = Broadphase(var_0_4, 8)
	arg_1_0.player_units_broadphase = Broadphase(var_0_1, 8, var_1_0)
	arg_1_0.enemy_check_raycasts = {}
	arg_1_0.raycast_read_index = 1
	arg_1_0.raycast_write_index = 1
	arg_1_0.raycast_max_index = 16
	arg_1_0._old_nearby = {}
	arg_1_0._new_nearby = {}
	arg_1_0._broadphase_result = {}
	arg_1_0._pseudo_sorted_list = {}
	arg_1_0._old_enabled_fx = {}
	arg_1_0._new_enabled_fx = {}
	arg_1_0._is_spectator = false
	arg_1_0._spectated_player = nil
	arg_1_0._spectated_player_unit = nil

	Managers.state.event:register(arg_1_0, "on_spectator_target_changed", "on_spectator_target_changed")
end

ProximitySystem.destroy = function (arg_2_0)
	arg_2_0.unit_extension_data = nil
end

ProximitySystem.on_spectator_target_changed = function (arg_3_0, arg_3_1)
	arg_3_0._spectated_player_unit = arg_3_1
	arg_3_0._spectated_player = Managers.player:owner(arg_3_1)
	arg_3_0._is_spectator = true
end

ProximitySystem.on_add_extension = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_4.side
	local var_4_1 = {
		last_num_friends_nearby = 0,
		last_num_enemies_nearby = 0,
		side = var_4_0
	}

	ScriptUnit.set_extension(arg_4_2, "proximity_system", var_4_1)

	arg_4_0.unit_extension_data[arg_4_2] = var_4_1

	if arg_4_3 == "PlayerProximityExtension" then
		arg_4_0.player_unit_extensions_map[arg_4_2] = var_4_1
		var_4_1.proximity_types = {
			friends_close = {
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.friends_close_distance,
				broadphase_pairs = {
					{
						check = arg_4_0.player_unit_extensions_map,
						broadphase = arg_4_0.player_units_broadphase
					}
				},
				broadphase_categories = var_4_0.ally_broadphase_categories
			},
			friends_distant = {
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.friends_distant_distance,
				broadphase_pairs = {
					{
						check = arg_4_0.player_unit_extensions_map,
						broadphase = arg_4_0.player_units_broadphase
					}
				},
				broadphase_categories = var_4_0.ally_broadphase_categories
			},
			enemies_close = {
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.enemies_close_distance,
				broadphase_pairs = {
					{
						check = arg_4_0.ai_unit_extensions_map,
						broadphase = arg_4_0.enemy_broadphase
					},
					{
						check = arg_4_0.player_unit_extensions_map,
						broadphase = arg_4_0.player_units_broadphase
					}
				},
				broadphase_categories = var_4_0.enemy_broadphase_categories
			},
			enemies_distant = {
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.enemies_distant_distance,
				broadphase_pairs = {
					{
						check = arg_4_0.ai_unit_extensions_map,
						broadphase = arg_4_0.enemy_broadphase
					},
					{
						check = arg_4_0.player_unit_extensions_map,
						broadphase = arg_4_0.player_units_broadphase
					}
				},
				broadphase_categories = var_4_0.enemy_broadphase_categories
			},
			vs_passing_hoisted_hero = {
				disable_in_ghost_mode = true,
				cooldown = 0,
				num = 0,
				distance = DialogueSettings.passing_hoisted_range,
				broadphase_pairs = {
					{
						check = arg_4_0.player_unit_extensions_map,
						broadphase = arg_4_0.player_units_broadphase
					}
				},
				broadphase_categories = var_4_0.enemy_broadphase_categories
			}
		}
		var_4_1.raycast_timer = 0
		var_4_1.hear_timer = 0
		var_4_1.player_broadphase_id = Broadphase.add(arg_4_0.player_units_broadphase, arg_4_2, Unit.world_position(arg_4_2, 0), 0.5, arg_4_4.side.broadphase_category)

		local var_4_2 = arg_4_4.breed or arg_4_4.profile.breed

		if var_4_2 and var_4_2.proximity_system_check then
			var_4_1.special_broadphase_id = Broadphase.add(arg_4_0.special_units_broadphase, arg_4_2, Unit.world_position(arg_4_2, 0), 0.5)
			arg_4_0.special_unit_extension_map[arg_4_2] = var_4_1
		end

		var_4_1.bot_reaction_times = {}
		var_4_1.has_been_seen = false
	elseif arg_4_3 == "AIProximityExtension" then
		var_4_1.enemy_broadphase_id = Broadphase.add(arg_4_0.enemy_broadphase, arg_4_2, Unit.world_position(arg_4_2, 0), 0.5)
		var_4_1.bot_reaction_times = {}
		var_4_1.has_been_seen = false
		arg_4_0.ai_unit_extensions_map[arg_4_2] = var_4_1

		if arg_4_4.breed.proximity_system_check then
			var_4_1.special_broadphase_id = Broadphase.add(arg_4_0.special_units_broadphase, arg_4_2, Unit.world_position(arg_4_2, 0), 0.5)
			arg_4_0.special_unit_extension_map[arg_4_2] = var_4_1
		end
	end

	return var_4_1
end

ProximitySystem.extensions_ready = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_3 == "PlayerProximityExtension" then
		local var_5_0 = arg_5_0.player_unit_extensions_map[arg_5_2]

		if var_5_0.side then
			return
		end

		var_5_0.side = Managers.state.side.side_by_unit[arg_5_2]
	end
end

ProximitySystem.on_remove_extension = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.frozen_unit_extension_data[arg_6_1] = nil

	arg_6_0:_cleanup_extension(arg_6_1, arg_6_2)
	ScriptUnit.remove_extension(arg_6_1, arg_6_0.NAME)
end

ProximitySystem.on_freeze_extension = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.unit_extension_data[arg_7_1]

	fassert(var_7_0, "Unit was already frozen.")

	arg_7_0.frozen_unit_extension_data[arg_7_1] = var_7_0

	arg_7_0:_cleanup_extension(arg_7_1, arg_7_2)
end

ProximitySystem._cleanup_extension = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.unit_extension_data[arg_8_1]

	if var_8_0 == nil then
		return
	end

	if var_8_0.enemy_broadphase_id then
		Broadphase.remove(arg_8_0.enemy_broadphase, var_8_0.enemy_broadphase_id)

		var_8_0.enemy_broadphase_id = nil
	end

	if var_8_0.player_broadphase_id then
		Broadphase.remove(arg_8_0.player_units_broadphase, var_8_0.player_broadphase_id)

		var_8_0.player_broadphase_id = nil
	end

	if var_8_0.special_broadphase_id then
		Broadphase.remove(arg_8_0.special_units_broadphase, var_8_0.special_broadphase_id)

		var_8_0.special_broadphase_id = nil
	end

	arg_8_0.unit_extension_data[arg_8_1] = nil
	arg_8_0.player_unit_extensions_map[arg_8_1] = nil
	arg_8_0.ai_unit_extensions_map[arg_8_1] = nil
	arg_8_0.special_unit_extension_map[arg_8_1] = nil
end

ProximitySystem.freeze = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.frozen_unit_extension_data

	if var_9_0[arg_9_1] then
		return
	end

	local var_9_1 = arg_9_0.unit_extension_data[arg_9_1]

	fassert(var_9_1, "Unit to freeze didn't have unfrozen extension")
	arg_9_0:_cleanup_extension(arg_9_1, arg_9_2)

	arg_9_0.unit_extension_data[arg_9_1] = nil
	var_9_0[arg_9_1] = var_9_1
end

ProximitySystem.unfreeze = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.frozen_unit_extension_data[arg_10_1]

	fassert(var_10_0, "Unit to unfreeze didn't have frozen extension")

	arg_10_0.frozen_unit_extension_data[arg_10_1] = nil
	arg_10_0.unit_extension_data[arg_10_1] = var_10_0

	fassert(arg_10_2 == "AIProximityExtension", "Unexpected unfreeze extension")

	var_10_0.enemy_broadphase_id = Broadphase.add(arg_10_0.enemy_broadphase, arg_10_1, Unit.world_position(arg_10_1, 0), 0.5)
	var_10_0.bot_reaction_times = {}
	var_10_0.has_been_seen = false
	arg_10_0.ai_unit_extensions_map[arg_10_1] = var_10_0

	if Unit.get_data(arg_10_1, "breed").proximity_system_check then
		var_10_0.special_broadphase_id = Broadphase.add(arg_10_0.special_units_broadphase, arg_10_1, Unit.world_position(arg_10_1, 0), 0.5)
		arg_10_0.special_unit_extension_map[arg_10_1] = var_10_0
	end
end

local function var_0_12(arg_11_0)
	local var_11_0 = Unit.world_pose(arg_11_0, 0)

	return (Matrix4x4.forward(var_11_0))
end

local function var_0_13(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = Unit.world_position(arg_12_1, Unit.node(arg_12_1, "camera_attach"))
	local var_12_1, var_12_2 = Unit.box(arg_12_2)
	local var_12_3 = Matrix4x4.translation(var_12_1)
	local var_12_4 = Vector3.normalize(var_12_3 - var_12_0)
	local var_12_5 = Vector3.length(var_12_3 - var_12_0)
	local var_12_6 = PhysicsWorld.immediate_raycast(arg_12_0, var_12_0, var_12_4, var_12_5, "all", "types", "both", "collision_filter", "filter_lookat_object_ray")

	if var_12_6 then
		for iter_12_0, iter_12_1 in ipairs(var_12_6) do
			local var_12_7 = Actor.unit(iter_12_1[var_0_10])

			if var_12_7 ~= arg_12_1 then
				if var_12_7 == arg_12_2 then
					if script_data.debug_has_been_seen then
						QuickDrawerStay:line(var_12_0, iter_12_1[var_0_7], Color(0, 255, 0))
						QuickDrawerStay:line(iter_12_1[var_0_7], var_12_0 + var_12_4 * var_12_5, Color(255, 0, 0))
					end

					return true
				elseif not Unit.get_data(var_12_7, "breed") then
					return false
				end
			end
		end
	end
end

local var_0_14 = {}

ProximitySystem.update = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.player_unit_extensions_map
	local var_13_1 = arg_13_0.unit_forwards
	local var_13_2 = var_0_12
	local var_13_3 = Managers.state.network
	local var_13_4 = var_13_3:game()

	if var_13_4 and not LEVEL_EDITOR_TEST then
		for iter_13_0, iter_13_1 in pairs(var_13_0) do
			local var_13_5 = var_13_3:unit_game_object_id(iter_13_0)

			var_13_1[iter_13_0] = GameSession.game_object_field(var_13_4, var_13_5, "aim_direction")
		end
	else
		for iter_13_2, iter_13_3 in pairs(var_13_0) do
			var_13_1[iter_13_2] = var_13_2(iter_13_2, 0)
		end
	end

	if script_data.debug_has_been_seen then
		for iter_13_4, iter_13_5 in pairs(arg_13_0.unit_extension_data) do
			local var_13_6 = iter_13_5.has_been_seen and Color(0, 255, 0) or Color(255, 0, 0)

			QuickDrawer:sphere(Unit.local_position(iter_13_4, 0) + Vector3.up(), 2, var_13_6)
		end
	end
end

ProximitySystem._valid_dialogue_unit = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = ScriptUnit.has_extension(arg_14_1, "ghost_mode_system")

	if var_14_0 and var_14_0:is_in_ghost_mode() then
		return false
	end

	if arg_14_2 == "vs_passing_hoisted_hero" then
		local var_14_1 = ScriptUnit.has_extension(arg_14_1, "status_system")

		if not var_14_1 or not var_14_1:is_grabbed_by_pack_master() then
			return false
		end
	end

	return true
end

ProximitySystem.physics_async_update = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = var_0_14
	local var_15_1 = arg_15_1.dt
	local var_15_2 = Broadphase.move
	local var_15_3 = Unit.local_position
	local var_15_4 = arg_15_0.enemy_broadphase

	for iter_15_0, iter_15_1 in pairs(arg_15_0.ai_unit_extensions_map) do
		local var_15_5 = var_15_3(iter_15_0, 0)

		if var_15_5 then
			var_15_2(var_15_4, iter_15_1.enemy_broadphase_id, var_15_5)
		end
	end

	local var_15_6 = arg_15_0.player_unit_extensions_map
	local var_15_7 = arg_15_0.player_units_broadphase

	for iter_15_2, iter_15_3 in pairs(var_15_6) do
		local var_15_8 = var_15_3(iter_15_2, 0)

		if var_15_8 then
			var_15_2(var_15_7, iter_15_3.player_broadphase_id, var_15_8)
		end
	end

	local var_15_9 = arg_15_0.special_units_broadphase

	for iter_15_4, iter_15_5 in pairs(arg_15_0.special_unit_extension_map) do
		local var_15_10 = var_15_3(iter_15_4, 0)

		if var_15_10 then
			var_15_2(var_15_9, iter_15_5.special_broadphase_id, var_15_10)
		end
	end

	local var_15_11 = arg_15_0.enemy_check_raycasts
	local var_15_12 = arg_15_0.unit_forwards
	local var_15_13 = arg_15_0.raycast_read_index
	local var_15_14 = arg_15_0.raycast_write_index
	local var_15_15 = arg_15_0.raycast_max_index

	for iter_15_6, iter_15_7 in pairs(var_15_6) do
		repeat
			local var_15_16 = var_15_3(iter_15_6, 0)

			if not var_15_16 then
				break
			end

			local var_15_17 = iter_15_7.side.enemy_units_lookup

			for iter_15_8, iter_15_9 in pairs(iter_15_7.proximity_types) do
				repeat
					iter_15_9.cooldown = iter_15_9.cooldown - var_15_1

					if iter_15_9.cooldown > 0 then
						break
					end

					iter_15_9.cooldown = DialogueSettings.proximity_trigger_interval

					if iter_15_9.disable_in_ghost_mode then
						local var_15_18 = ScriptUnit.has_extension(iter_15_6, "ghost_mode_system")

						if var_15_18 and var_15_18:is_in_ghost_mode() then
							break
						end
					end

					local var_15_19 = iter_15_9.distance
					local var_15_20 = iter_15_9.broadphase_categories
					local var_15_21 = iter_15_9.broadphase_pairs
					local var_15_22 = iter_15_9.num
					local var_15_23 = 0

					for iter_15_10 = 1, #var_15_21 do
						local var_15_24 = var_15_21[iter_15_10].broadphase
						local var_15_25 = Broadphase.query(var_15_24, var_15_16, var_15_19, var_15_0, var_15_20)
						local var_15_26 = var_15_21[iter_15_10].check

						for iter_15_11 = 1, var_15_25 do
							local var_15_27 = var_15_0[iter_15_11]

							if var_15_27 ~= iter_15_6 and var_15_26[var_15_27] and arg_15_0:_valid_dialogue_unit(var_15_27, iter_15_8) then
								var_15_23 = var_15_23 + 1
							end
						end
					end

					if var_15_22 ~= var_15_23 then
						iter_15_9.num = var_15_23

						local var_15_28 = ScriptUnit.extension_input(iter_15_6, "dialogue_system")
						local var_15_29 = FrameTable.alloc_table()

						var_15_29.num_units = var_15_23

						var_15_28:trigger_dialogue_event(iter_15_8, var_15_29)
					end
				until true
			end

			local var_15_30 = iter_15_7.raycast_timer + var_15_1
			local var_15_31 = iter_15_7.hear_timer + var_15_1
			local var_15_32
			local var_15_33

			if var_15_30 > var_0_2 then
				local var_15_34 = var_15_12[iter_15_6]

				if var_15_34 then
					local var_15_35 = Vector3.flat(var_15_16)
					local var_15_36 = var_15_34.z

					var_15_34.z = 0

					local var_15_37 = var_0_4
					local var_15_38 = Broadphase.query(var_15_9, var_15_16, var_15_37, var_15_0)

					for iter_15_12 = 1, var_15_38 do
						local var_15_39 = var_15_0[iter_15_12]

						var_15_0[iter_15_12] = nil

						local var_15_40 = HEALTH_ALIVE[var_15_39]

						if var_15_39 ~= iter_15_6 and var_15_40 and var_15_17[var_15_39] and arg_15_0:_valid_dialogue_unit(var_15_39, nil) then
							local var_15_41 = var_15_3(var_15_39, 0)
							local var_15_42 = Vector3.flat(var_15_41)
							local var_15_43 = var_15_42 - var_15_35
							local var_15_44 = Vector3.normalize(var_15_43)

							if var_15_31 > var_0_3 and Vector3.distance_squared(var_15_41, var_15_16) < var_0_6 then
								local var_15_45 = ScriptUnit.extension_input(iter_15_6, "dialogue_system")
								local var_15_46 = FrameTable.alloc_table()
								local var_15_47 = Unit.get_data(var_15_39, "breed")

								if var_15_47 then
									var_15_46.enemy_tag = var_15_47.name

									assert(var_15_46.enemy_tag)

									var_15_46.enemy_unit = var_15_39
									var_15_46.distance = Vector3.distance(var_15_42, var_15_35)

									var_15_45:trigger_dialogue_event("heard_enemy", var_15_46)

									var_15_33 = true
								end
							end

							if Vector3.dot(var_15_44, var_15_34) > 0.7 then
								var_15_32 = true
								var_15_11[var_15_14] = iter_15_6
								var_15_11[var_15_14 + 1] = var_15_39
								var_15_14 = (var_15_14 + 1) % var_15_15 + 1

								if var_15_13 == var_15_14 then
									var_15_13 = (var_15_13 + 1) % var_15_15 + 1
								end
							end
						end
					end
				end
			end

			if var_15_32 then
				var_15_30 = 0
			end

			if var_15_33 then
				var_15_31 = 0
			end

			arg_15_0.raycast_read_index = var_15_13
			arg_15_0.raycast_write_index = var_15_14
			iter_15_7.hear_timer = var_15_31
			iter_15_7.raycast_timer = var_15_30
			var_15_12[iter_15_6] = nil
		until true
	end

	arg_15_0:_update_nearby_boss()
	arg_15_0:_update_nearby_enemies()
end

local var_0_15 = 12
local var_0_16 = Unit.flow_event
local var_0_17 = Unit.alive

local function var_0_18(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0[arg_16_2]

	arg_16_0[arg_16_1] = var_16_0
	arg_16_0[arg_16_2] = nil

	return var_16_0
end

local function var_0_19(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0[arg_17_2]

	arg_17_0[arg_17_2] = arg_17_0[arg_17_1]
	arg_17_0[arg_17_1] = var_17_0

	return var_17_0
end

local function var_0_20(arg_18_0, arg_18_1, arg_18_2)
	return var_0_18(arg_18_0, arg_18_1, arg_18_2), arg_18_2 - 1
end

local function var_0_21(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_0[arg_19_2] then
		arg_19_0[arg_19_2] = nil
	else
		var_0_16(arg_19_2, "enable_proximity_fx")
	end

	arg_19_1[arg_19_2] = true
end

local function var_0_22(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0[arg_20_2] then
		var_0_16(arg_20_2, "disable_proximity_fx")

		arg_20_0[arg_20_2] = nil
	end
end

ProximitySystem._update_nearby_boss = function (arg_21_0)
	if DEDICATED_SERVER then
		return
	end

	local var_21_0 = arg_21_0._is_spectator and arg_21_0._spectated_player or Managers.player:local_player()

	if not var_21_0 then
		return
	end

	local var_21_1 = var_21_0.player_unit

	if not var_21_1 then
		return
	end

	local var_21_2 = arg_21_0._broadphase_result
	local var_21_3 = Unit.local_position(var_21_1, 0)

	if not var_21_3 then
		return
	end

	local var_21_4 = Broadphase.query(arg_21_0.enemy_broadphase, var_21_3, 3, var_21_2)
	local var_21_5 = Managers.state.entity:system("ai_system")

	for iter_21_0 = 1, var_21_4 do
		local var_21_6 = var_21_2[iter_21_0]
		local var_21_7 = Unit.get_data(var_21_6, "breed")
		local var_21_8 = var_21_5:get_attributes(var_21_6)

		if var_21_7 and var_21_7.boss and not var_21_7.server_controlled_health_bar or var_21_8.grudge_marked and arg_21_0:_valid_dialogue_unit(var_21_6, nil) then
			arg_21_0.closest_boss_unit = var_21_6

			break
		end
	end
end

ProximitySystem._update_nearby_enemies = function (arg_22_0)
	if DEDICATED_SERVER then
		return
	end

	local var_22_0 = arg_22_0._old_nearby
	local var_22_1 = arg_22_0._new_nearby
	local var_22_2 = arg_22_0._broadphase_result

	table.clear(var_22_1)

	local var_22_3 = arg_22_0._pseudo_sorted_list
	local var_22_4 = arg_22_0._old_enabled_fx
	local var_22_5 = arg_22_0._new_enabled_fx
	local var_22_6 = arg_22_0._is_spectator and {
		arg_22_0._spectated_player
	} or Managers.player:players_at_peer(Network.peer_id())
	local var_22_7 = Vector3(0, 0, 0)
	local var_22_8 = 0
	local var_22_9 = Managers.state.camera

	for iter_22_0, iter_22_1 in pairs(var_22_6) do
		if arg_22_0._is_spectator then
			var_22_7 = Unit.world_position(iter_22_1.player_unit, 0)
			var_22_8 = var_22_8 + 1
		elseif not iter_22_1.bot_player then
			var_22_7 = var_22_9:camera_position(iter_22_1.viewport_name)
			var_22_8 = var_22_8 + 1
		end
	end

	if var_22_8 > 0 then
		local var_22_10 = var_22_7 / var_22_8
		local var_22_11 = #var_22_3
		local var_22_12 = Broadphase.query(arg_22_0.enemy_broadphase, var_22_10, 30, var_22_2)

		for iter_22_2 = 1, var_22_12 do
			local var_22_13 = var_22_2[iter_22_2]

			if arg_22_0:_valid_dialogue_unit(var_22_13, nil) then
				var_22_1[var_22_13] = Vector3.distance_squared(Unit.local_position(var_22_13, 0), var_22_10)

				if not var_22_0[var_22_13] then
					var_22_11 = var_22_11 + 1
					var_22_3[var_22_11] = var_22_13
				end
			end
		end

		local var_22_14 = script_data.max_allowed_proximity_fx or var_0_15
		local var_22_15 = var_22_3[1]

		if var_22_15 then
			local var_22_16 = var_22_1[var_22_15]

			while not var_22_16 and var_22_11 > 0 do
				var_22_15, var_22_11 = var_0_20(var_22_3, 1, var_22_11)
				var_22_16 = var_22_1[var_22_15]
			end

			local var_22_17
			local var_22_18 = 1

			while var_22_18 <= var_22_11 do
				local var_22_19 = var_22_18

				var_22_18 = var_22_18 + 1

				local var_22_20 = var_22_15
				local var_22_21 = var_22_16

				var_22_15 = var_22_3[var_22_18]
				var_22_16 = var_22_1[var_22_15]

				while not var_22_16 and var_22_18 <= var_22_11 do
					var_22_15, var_22_11 = var_0_20(var_22_3, var_22_18, var_22_11)
					var_22_16 = var_22_1[var_22_15]
				end

				if var_22_16 and var_22_16 < var_22_21 then
					var_0_19(var_22_3, var_22_19, var_22_18)

					var_22_15 = var_22_20
					var_22_16 = var_22_21
				end

				if not var_0_17(var_22_3[var_22_19]) then
					table.dump(var_22_4, "old_enabled_fx", 2)
					table.dump(var_22_5, "new_enabled_fx", 2)
					table.dump(var_22_0, "old_nearby", 2)
					table.dump(var_22_1, "new_nearby", 2)
					table.dump(var_22_3, "list", 2)
					assert(false, "Detected deleted unit in proximity fx list.")
				end

				local var_22_22 = var_22_3[var_22_19]

				if var_22_19 <= var_22_14 then
					var_0_21(var_22_4, var_22_5, var_22_22)

					local var_22_23 = ScriptUnit.has_extension(var_22_22, "aim_system")

					if var_22_23 then
						var_22_23:set_enabled(true)
					end
				else
					var_0_22(var_22_4, var_22_5, var_22_22)

					local var_22_24 = ScriptUnit.has_extension(var_22_22, "aim_system")

					if var_22_24 then
						var_22_24:set_enabled(false)
					end
				end
			end

			if var_22_16 then
				if var_22_18 <= var_22_14 then
					var_0_21(var_22_4, var_22_5, var_22_15)
				else
					var_0_22(var_22_4, var_22_5, var_22_15)
				end
			end

			arg_22_0:_clear_old_enabled_fx(var_22_4)
			arg_22_0:_nearby_enemies_debug(var_22_3, var_22_1, var_22_5)

			arg_22_0._old_enabled_fx = var_22_5
			arg_22_0._new_enabled_fx = var_22_4
		end
	end

	arg_22_0._old_nearby = var_22_1
	arg_22_0._new_nearby = var_22_0
end

ProximitySystem._nearby_enemies_debug = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if script_data.debug_proximity_fx then
		for iter_23_0, iter_23_1 in ipairs(arg_23_1) do
			local var_23_0 = arg_23_2[iter_23_1]

			if var_23_0 then
				local var_23_1 = math.sqrt(var_23_0)
				local var_23_2 = 255 - math.min(var_23_1 * 8, 255)
				local var_23_3 = arg_23_3[iter_23_1]
				local var_23_4

				if var_23_3 then
					var_23_4 = Color(var_23_2, var_23_2, 255)
				else
					var_23_4 = Color(var_23_2, 255, var_23_2)
				end

				Debug.colored_text(var_23_4, tostring(Unit.get_data(iter_23_1, "debug_random")) .. (var_23_3 and " enabled " or " disabled ") .. string.format("%.2f", var_23_1))
			else
				print("ERROR", iter_23_0)
			end
		end

		for iter_23_2, iter_23_3 in pairs(arg_23_3) do
			QuickDrawer:sphere(Unit.local_position(iter_23_2, 0), 1.2, Color(0, 255, 0))
		end
	end
end

ProximitySystem._clear_old_enabled_fx = function (arg_24_0, arg_24_1)
	for iter_24_0, iter_24_1 in pairs(arg_24_1) do
		if var_0_17(iter_24_0) then
			var_0_16(iter_24_0, "disable_proximity_fx")
		end
	end

	table.clear(arg_24_1)
end

ProximitySystem.post_update = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0.enemy_check_raycasts
	local var_25_1 = arg_25_0.unit_forwards
	local var_25_2 = arg_25_0.physics_world
	local var_25_3 = Managers.state.entity:system("darkness_system")
	local var_25_4 = arg_25_0.raycast_read_index

	if var_25_4 ~= arg_25_0.raycast_write_index then
		arg_25_0.raycast_read_index = (var_25_4 + 1) % arg_25_0.raycast_max_index + 1

		local var_25_5 = var_25_0[var_25_4]
		local var_25_6 = var_25_0[var_25_4 + 1]

		if var_0_17(var_25_5) and var_0_17(var_25_6) then
			local var_25_7 = Unit.world_position(var_25_6, 0)

			if not var_25_3:is_in_darkness(var_25_7) and var_0_13(var_25_2, var_25_5, var_25_6) then
				local var_25_8 = Vector3.flat(var_25_7)
				local var_25_9 = Unit.local_position(var_25_5, 0)
				local var_25_10 = Vector3.flat(var_25_9)
				local var_25_11 = ScriptUnit.extension_input(var_25_5, "dialogue_system")
				local var_25_12 = FrameTable.alloc_table()

				var_25_12.enemy_tag = Unit.get_data(var_25_6, "breed").name

				assert(var_25_12.enemy_tag)

				var_25_12.enemy_unit = var_25_6
				var_25_12.distance = Vector3.distance(var_25_8, var_25_10)
				ScriptUnit.extension(var_25_6, "proximity_system").has_been_seen = true

				var_25_11:trigger_dialogue_event("seen_enemy", var_25_12)
			end
		end
	end
end

ProximitySystem.hot_join_sync = function (arg_26_0, arg_26_1)
	return
end
