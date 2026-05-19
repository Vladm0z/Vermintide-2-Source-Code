-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state.lua

require("scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_helper")

EnemyCharacterState = class(EnemyCharacterState)

function EnemyCharacterState.init(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.unit
	local var_1_1 = Unit.get_data(var_1_0, "breed")

	arg_1_0.name = arg_1_2
	arg_1_0._world = arg_1_1.world
	arg_1_0._physics_world = World.get_data(arg_1_0._world, "physics_world")
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._unit = var_1_0
	arg_1_0._breed = var_1_1
	arg_1_0._csm = arg_1_1.csm
	arg_1_0._player = arg_1_1.player
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._unit_storage = arg_1_1.unit_storage
	arg_1_0._nav_world = arg_1_1.nav_world
	arg_1_0._is_server = Managers.player.is_server
	arg_1_0._temp_params = {}
	arg_1_0._buff_extension = ScriptUnit.extension(var_1_0, "buff_system")
	arg_1_0._input_extension = ScriptUnit.extension(var_1_0, "input_system")
	arg_1_0._interactor_extension = ScriptUnit.extension(var_1_0, "interactor_system")
	arg_1_0._inventory_extension = ScriptUnit.extension(var_1_0, "inventory_system")
	arg_1_0._career_extension = ScriptUnit.extension(var_1_0, "career_system")
	arg_1_0._health_extension = ScriptUnit.extension(var_1_0, "health_system")
	arg_1_0._locomotion_extension = ScriptUnit.extension(var_1_0, "locomotion_system")
	arg_1_0._first_person_extension = ScriptUnit.extension(var_1_0, "first_person_system")
	arg_1_0._status_extension = ScriptUnit.extension(var_1_0, "status_system")
	arg_1_0._ghost_mode_extension = ScriptUnit.extension(var_1_0, "ghost_mode_system")
	arg_1_0._overcharge_extension = ScriptUnit.extension(var_1_0, "overcharge_system")
	arg_1_0._first_person_unit = arg_1_0._first_person_extension:get_first_person_unit()
	arg_1_0._particle_ids = {}
	arg_1_0._left_wpn_particle_name = nil
	arg_1_0._left_wpn_particle_node_name = nil
	arg_1_0._right_wpn_particle_name = nil
	arg_1_0._right_wpn_particle_node_name = nil
	arg_1_0._weighted_taunt_values = {}
	arg_1_0._taunt_timer = 0
	arg_1_0._max_taunt_distance = 30
	arg_1_0._taunt_cooldown = 20
end

function EnemyCharacterState.on_exit(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_0:destroy_particles()
end

function EnemyCharacterState.handle_disabled_ghost_mode(arg_3_0)
	local var_3_0 = arg_3_0._ghost_mode_extension

	if var_3_0:is_in_ghost_mode() and Development.parameter("disable_ghost_mode") then
		local var_3_1 = true

		var_3_0:try_leave_ghost_mode(var_3_1)
	end
end

function EnemyCharacterState.set_breed_action(arg_4_0, arg_4_1)
	local var_4_0 = Unit.get_data(arg_4_0._unit, "breed").name

	if not Managers.state.network:game() then
		return
	end

	if arg_4_0._is_server then
		arg_4_0._status_extension:set_breed_action(var_4_0, arg_4_1)
	else
		local var_4_1 = NetworkLookup.breeds[var_4_0]
		local var_4_2 = NetworkLookup.bt_action_names[arg_4_1]
		local var_4_3 = Managers.state.unit_storage:go_id(arg_4_0._unit)

		Managers.state.network.network_transmit:send_rpc_server("rpc_set_action_data", var_4_3, var_4_1, var_4_2)
	end
end

function EnemyCharacterState.has_move_input(arg_5_0)
	local var_5_0 = arg_5_0._input_extension

	return CharacterStateHelper.has_move_input(var_5_0)
end

function EnemyCharacterState.has_jump_input(arg_6_0)
	local var_6_0 = arg_6_0._input_extension

	return var_6_0:get("jump") or var_6_0:get("jump_only")
end

function EnemyCharacterState.has_movement_input(arg_7_0)
	local var_7_0 = false or arg_7_0:has_move_input()

	var_7_0 = var_7_0 or arg_7_0:has_jump_input()

	return var_7_0
end

function EnemyCharacterState.to_movement_state(arg_8_0)
	local var_8_0 = arg_8_0._csm
	local var_8_1 = arg_8_0._locomotion_extension

	if arg_8_0:has_move_input() then
		var_8_0:change_state("walking")
	elseif arg_8_0:has_jump_input() and var_8_1:jump_allowed() then
		local var_8_2 = arg_8_0._first_person_extension

		var_8_0:change_state("jumping")
		var_8_2:change_state("jumping")
	else
		var_8_0:change_state("standing")
	end
end

function EnemyCharacterState.update_movement(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	local var_9_0 = arg_9_0._input_extension
	local var_9_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_9_1)
	local var_9_2 = CharacterStateHelper.has_move_input(var_9_0)
	local var_9_3 = arg_9_0.current_movement_speed_scale or 0

	if not arg_9_0.is_bot then
		local var_9_4 = var_9_1.move_acceleration_up * arg_9_3
		local var_9_5 = var_9_1.move_acceleration_down * arg_9_3

		if var_9_2 then
			var_9_3 = math.min(1, var_9_3 + var_9_4)
		else
			var_9_3 = math.max(0, var_9_3 - var_9_5)
		end
	else
		var_9_3 = var_9_2 and 1 or 0
	end

	local var_9_6 = arg_9_4
	local var_9_7 = arg_9_0._buff_extension:apply_buffs_to_value(var_9_6, "movement_speed") * var_9_3 * var_9_1.player_speed_scale
	local var_9_8 = Vector3(0, 0, 0)
	local var_9_9 = CharacterStateHelper.get_movement_input(var_9_0)

	if var_9_9 then
		var_9_8 = var_9_8 + var_9_9
	end

	local var_9_10 = arg_9_0._first_person_extension
	local var_9_11 = Vector3.normalize(var_9_8)

	CharacterStateHelper.move_on_ground(var_9_10, var_9_0, arg_9_0._locomotion_extension, var_9_11, var_9_7, arg_9_1)
	CharacterStateHelper.look(var_9_0, arg_9_0._player.viewport_name, var_9_10, arg_9_0._status_extension, arg_9_0._inventory_extension)

	if arg_9_5 or arg_9_6 then
		local var_9_12, var_9_13 = CharacterStateHelper.get_move_animation(arg_9_0._locomotion_extension, var_9_0, arg_9_0._status_extension, arg_9_0.move_anim_3p)

		if arg_9_5 and var_9_12 ~= arg_9_0.move_anim_3p then
			CharacterStateHelper.play_animation_event(arg_9_1, var_9_12)

			arg_9_0.move_anim_3p = var_9_12
		end

		if arg_9_6 and var_9_13 ~= arg_9_0.move_anim_1p then
			CharacterStateHelper.play_animation_event_first_person(var_9_10, var_9_13)

			arg_9_0.move_anim_1p = var_9_13
		end
	end

	arg_9_0.current_movement_speed_scale = var_9_3
end

function EnemyCharacterState.create_particles(arg_10_0)
	if #arg_10_0._particle_ids == 0 then
		local var_10_0, var_10_1 = arg_10_0._inventory_extension:get_all_weapon_unit()

		if var_10_0 and arg_10_0._left_wpn_particle_name then
			arg_10_0:_create_particle_for_weapon(var_10_0, arg_10_0._left_wpn_particle_name, arg_10_0._left_wpn_particle_node_name)
		end

		if var_10_1 and arg_10_0._right_wpn_particle_name then
			arg_10_0:_create_particle_for_weapon(var_10_1, arg_10_0._right_wpn_particle_name, arg_10_0._right_wpn_particle_node_name)
		end
	end
end

function EnemyCharacterState._create_particle_for_weapon(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_3 and Unit.node(arg_11_1, arg_11_3) or 0
	local var_11_1 = ScriptWorld.create_particles_linked(arg_11_0._world, arg_11_2, arg_11_1, var_11_0, "destroy")

	arg_11_0._particle_ids[#arg_11_0._particle_ids + 1] = var_11_1
end

function EnemyCharacterState.destroy_particles(arg_12_0)
	local var_12_0 = arg_12_0._particle_ids

	for iter_12_0 = 1, #var_12_0 do
		local var_12_1 = var_12_0[iter_12_0]

		World.stop_spawning_particles(arg_12_0._world, var_12_1)
	end

	table.clear(var_12_0)
end

function EnemyCharacterState.check_enemies_in_range_vfx(arg_13_0, ...)
	if EnemyCharacterStateHelper.get_enemies_in_line_of_sight(arg_13_0._unit, arg_13_0._first_person_unit, arg_13_0._physics_world, ...) then
		arg_13_0:create_particles()
	else
		arg_13_0:destroy_particles()
	end
end

function EnemyCharacterState._update_taunt_dialogue(arg_14_0, arg_14_1)
	if arg_14_0._ghost_mode_extension:is_in_ghost_mode() then
		return
	end

	if arg_14_1 <= arg_14_0._taunt_timer then
		return
	end

	arg_14_0._taunt_timer = arg_14_1 + arg_14_0._taunt_cooldown

	local var_14_0 = arg_14_0._first_person_unit
	local var_14_1 = arg_14_0._unit
	local var_14_2 = Managers.player
	local var_14_3 = POSITION_LOOKUP[var_14_0]
	local var_14_4 = Unit.world_rotation(var_14_0, 0)
	local var_14_5 = Vector3.normalize(Quaternion.forward(var_14_4))
	local var_14_6 = Managers.state.side.side_by_unit[var_14_1].VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS
	local var_14_7 = {}

	for iter_14_0, iter_14_1 in pairs(var_14_6) do
		local var_14_8 = Unit.world_position(iter_14_0, Unit.node(iter_14_0, "c_spine"))
		local var_14_9 = Vector3.distance(var_14_8, var_14_3)

		if var_14_9 <= arg_14_0._max_taunt_distance and EnemyCharacterStateHelper.is_infront_player(var_14_3, var_14_5, var_14_8) then
			local var_14_10 = Vector3.normalize(var_14_8 - var_14_3)
			local var_14_11, var_14_12, var_14_13, var_14_14, var_14_15 = PhysicsWorld.immediate_raycast(arg_14_0._physics_world, var_14_3, var_14_10, var_14_9, "closest", "collision_filter", "filter_husk_in_line_of_sight")

			if not var_14_11 then
				var_14_7[#var_14_7 + 1] = iter_14_0
			end
		end
	end

	local var_14_16 = {}

	for iter_14_2, iter_14_3 in ipairs(var_14_7) do
		local var_14_17 = var_14_2:owner(iter_14_3):profile_display_name()
		local var_14_18 = arg_14_0._weighted_taunt_values[var_14_17]

		if not var_14_18 then
			var_14_18 = 1
			arg_14_0._weighted_taunt_values[var_14_17] = var_14_18
		end

		var_14_16[iter_14_2] = 1 / var_14_18
	end

	if #var_14_16 > 0 then
		local var_14_19, var_14_20 = LoadedDice.create(var_14_16, false)
		local var_14_21 = var_14_7[LoadedDice.roll(var_14_19, var_14_20)]
		local var_14_22 = var_14_2:owner(var_14_21):profile_display_name()

		arg_14_0._weighted_taunt_values[var_14_22] = arg_14_0._weighted_taunt_values[var_14_22] + 1

		local var_14_23 = ScriptUnit.extension_input(arg_14_0._unit, "dialogue_system")
		local var_14_24 = "taunting_" .. var_14_22
		local var_14_25 = FrameTable.alloc_table()

		var_14_23:trigger_networked_dialogue_event(var_14_24, var_14_25)
	end
end

function EnemyCharacterState.debug_display_ratling_gunner_ammo(arg_15_0, arg_15_1, arg_15_2)
	Managers.state.event:trigger("on_dark_pact_ammo_changed", arg_15_1, arg_15_2)
end
