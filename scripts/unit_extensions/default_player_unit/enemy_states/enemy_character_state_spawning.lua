-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_spawning.lua

EnemyCharacterStateSpawning = class(EnemyCharacterStateSpawning, EnemyCharacterState)

local var_0_0 = {
	chimney = {
		"exit_teleporter_chimney",
		0,
		-0.5
	},
	window = {
		"exit_teleporter_window",
		-0.5,
		-0.5
	},
	well = {
		"exit_teleporter_well",
		0,
		-2.5
	},
	pipe = {
		"exit_teleporter_pipe_run",
		0,
		-0.5
	},
	manhole = {
		"exit_teleporter_manhole",
		0,
		-1.5
	}
}

function EnemyCharacterStateSpawning.init(arg_1_0, arg_1_1)
	EnemyCharacterStateSpawning.super.init(arg_1_0, arg_1_1, "spawning")
end

function EnemyCharacterStateSpawning.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0._input_extension
	local var_2_1 = arg_2_0._first_person_extension
	local var_2_2 = arg_2_0._status_extension
	local var_2_3 = arg_2_0._inventory_extension
	local var_2_4 = arg_2_0._health_extension
	local var_2_5 = arg_2_0._locomotion_extension
	local var_2_6 = arg_2_0._interactor_extension:interactable_unit()
	local var_2_7 = ScriptUnit.extension(var_2_6, "door_system")

	arg_2_0.enter_unit = var_2_6
	arg_2_0.transition_manager = Managers.transition
	arg_2_0.enter_pos = var_2_7.enter_pos
	arg_2_0.enter_rot = var_2_7.enter_rot

	local var_2_8 = Vector3Box.unbox(arg_2_0.enter_rot)

	arg_2_0.exit_rot = QuaternionBox(Quaternion.look(-var_2_8))
	arg_2_0.wanted_rot = arg_2_0.enter_rot

	local var_2_9 = var_2_7.entrance_type

	arg_2_0._player = Managers.player:owner(arg_2_1)
	arg_2_0.exit_anim = var_0_0[var_2_9][1]
	arg_2_0.forward_offset = var_0_0[var_2_9][2]
	arg_2_0.height_offset = var_0_0[var_2_9][3]
	arg_2_0.fade_t = arg_2_5 + 0.5

	local var_2_10 = 5

	arg_2_0.transition_manager:fade_in(var_2_10)
	var_2_5:enable_animation_driven_movement_with_rotation_no_mover()

	local var_2_11 = false
	local var_2_12
	local var_2_13 = false

	if var_2_2:get_unarmed() then
		var_2_13 = true
	end

	var_2_1:set_first_person_mode(var_2_11, var_2_12, var_2_13)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_0, var_2_3, var_2_4)
	var_2_2:set_should_spawn(false)
	arg_2_0:set_breed_action("spawning")
end

function EnemyCharacterStateSpawning.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = BLACKBOARDS[arg_3_1]
	local var_3_1 = arg_3_0._input_extension
	local var_3_2 = arg_3_0._status_extension
	local var_3_3 = arg_3_0._first_person_extension
	local var_3_4 = arg_3_0._inventory_extension

	CharacterStateHelper.look(var_3_1, arg_3_0._player.viewport_name, var_3_3, var_3_2, var_3_4)

	if arg_3_0.fade_t and arg_3_5 > arg_3_0.fade_t then
		local var_3_5 = QuaternionBox.unbox(arg_3_0.exit_rot)

		arg_3_0._first_person_extension:force_look_rotation(var_3_5)

		local var_3_6 = Quaternion.forward(var_3_5)

		arg_3_0.wanted_rot = Vector3Box(var_3_6)

		local var_3_7 = var_3_6 * arg_3_0.forward_offset + Vector3.up() * arg_3_0.height_offset
		local var_3_8 = Unit.local_position(arg_3_0.enter_unit, 0) + var_3_7
		local var_3_9 = Unit.mover(arg_3_1)

		Mover.set_position(var_3_9, var_3_8)
		Unit.set_local_position(arg_3_1, 0, var_3_8)
		CharacterStateHelper.change_camera_state(arg_3_0._player, "follow_third_person_tunneling")

		local var_3_10 = arg_3_0.exit_anim

		CharacterStateHelper.play_animation_event(arg_3_1, var_3_10)
		CharacterStateHelper.look(var_3_1, arg_3_0._player.viewport_name, var_3_3, var_3_2, var_3_4, nil, Vector3(-2, 0, 0))

		local var_3_11 = Managers.state.entity:system("camera_system")
		local var_3_12 = -var_3_6 + Vector3.up()
		local var_3_13 = Vector3Box.unbox(arg_3_0.enter_pos) + var_3_12 * 2

		var_3_11:update_tunnel_camera_position(arg_3_0._player, var_3_13)

		local var_3_14 = ScriptUnit.extension(arg_3_1, "ghost_mode_system")
		local var_3_15 = true

		var_3_14:try_leave_ghost_mode(var_3_15)

		local var_3_16 = 5

		arg_3_0.transition_manager:fade_out(var_3_16)

		arg_3_0.fade_t = nil
	end

	if var_3_0.tunneling_finished then
		var_3_3:force_look_rotation(QuaternionBox.unbox(arg_3_0.exit_rot), 0.1)
		arg_3_0:start_camera_transition()
		arg_3_0:to_movement_state()

		var_3_0.tunneling_finished = nil
	end

	Unit.set_local_rotation(arg_3_1, 0, Quaternion.look(Vector3Box.unbox(arg_3_0.wanted_rot)))
end

function EnemyCharacterStateSpawning.on_exit(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	if arg_4_0._status_extension:get_unarmed() then
		CharacterStateHelper.play_animation_event(arg_4_1, "to_unarmed")
	end

	arg_4_0:grant_control_to_player()
	arg_4_0:set_breed_action("n/a")

	ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

function EnemyCharacterStateSpawning.grant_control_to_player(arg_5_0)
	local var_5_0 = arg_5_0._locomotion_extension
	local var_5_1 = Unit.animation_wanted_root_pose(arg_5_0._unit)

	var_5_0:teleport_to(Matrix4x4.translation(var_5_1))
	var_5_0:set_wanted_velocity(Vector3.zero())
	var_5_0:enable_script_driven_movement()
	var_5_0:set_animation_translation_scale(Vector3(1, 1, 1))
	var_5_0:force_on_ground(true)
end

function EnemyCharacterStateSpawning.start_camera_transition(arg_6_0)
	local var_6_0 = arg_6_0._first_person_extension

	CharacterStateHelper.change_camera_state(arg_6_0._player, "follow")
	CharacterStateHelper.play_animation_event_first_person(var_6_0, "idle")
	var_6_0:toggle_visibility(0.4)
end
