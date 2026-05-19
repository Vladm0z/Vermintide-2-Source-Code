-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_tunneling.lua

EnemyCharacterStateTunneling = class(EnemyCharacterStateTunneling, EnemyCharacterState)

local var_0_0 = {
	chimney = {
		"enter_teleporter_1m",
		false
	},
	window = {
		"enter_teleporter_1m",
		true
	},
	well = {
		"enter_teleporter_1m",
		false
	},
	pipe = {
		"enter_teleporter_1m",
		true
	},
	manhole = {
		"enter_teleporter_1m",
		false
	}
}
local var_0_1 = {
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

function EnemyCharacterStateTunneling.init(arg_1_0, arg_1_1)
	EnemyCharacterStateTunneling.super.init(arg_1_0, arg_1_1, "tunneling")
end

function EnemyCharacterStateTunneling.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0._input_extension
	local var_2_1 = arg_2_0._first_person_extension
	local var_2_2 = arg_2_0._status_extension
	local var_2_3 = arg_2_0._inventory_extension
	local var_2_4 = arg_2_0._health_extension
	local var_2_5 = arg_2_0._locomotion_extension
	local var_2_6 = arg_2_0._interactor_extension

	arg_2_0.pactsworn_video_transition_view = Managers.state.game_mode:game_mode().pactsworn_video_transition_view
	arg_2_0.transition_manager = Managers.transition

	local var_2_7 = var_2_6:interactable_unit()
	local var_2_8 = ScriptUnit.extension(var_2_7, "door_system")
	local var_2_9 = var_2_8.partner_unit

	arg_2_0.id = var_2_8.id

	assert(var_2_9, "Crawl Space is missing a partner unit. Either it has no partner, or the id is wrong.")

	local var_2_10 = ScriptUnit.extension(var_2_9, "door_system")

	arg_2_0.exit_unit = var_2_9
	arg_2_0.enter_pos = var_2_8.enter_pos

	local var_2_11 = var_2_8.enter_rot

	arg_2_0.enter_rot = var_2_11

	local var_2_12 = -Vector3Box.unbox(var_2_10.enter_rot)

	arg_2_0.exit_rot = QuaternionBox(Quaternion.look(var_2_12))
	arg_2_0.wanted_rot = arg_2_0.enter_rot

	local var_2_13 = var_2_8.entrance_type
	local var_2_14 = var_2_10.entrance_type

	arg_2_0._player = Managers.player:owner(arg_2_1)
	arg_2_0.exit_anim = var_0_1[var_2_14][1]
	arg_2_0.forward_offset = var_0_1[var_2_14][2]
	arg_2_0.height_offset = var_0_1[var_2_14][3]

	local var_2_15 = var_0_0[var_2_13][2]
	local var_2_16

	if var_2_15 then
		var_2_16 = arg_2_0.enter_pos:unbox()
	else
		local var_2_17 = Unit.local_position(var_2_7, 0) + Vector3.normalize(var_2_11:unbox()) * 0.5

		var_2_17.z = arg_2_0.enter_pos.z + (var_2_13 == "manhole" and 1 or 0)

		local var_2_18 = POSITION_LOOKUP[arg_2_1] - var_2_17

		var_2_18.z = 0

		local var_2_19 = 1.5

		var_2_16 = var_2_17 + Vector3.normalize(var_2_18) * var_2_19
		arg_2_0.wanted_rot = Vector3Box(-var_2_18)
	end

	arg_2_0.alignment_vector = Vector3Box(var_2_16 - POSITION_LOOKUP[arg_2_1])
	arg_2_0.alignment_total_t = 0.25
	arg_2_0.alignment_time_t = arg_2_0.alignment_total_t

	var_2_5:enable_animation_driven_movement_with_rotation_no_mover()

	local var_2_20 = var_0_0[var_2_13][1]

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_20)
	CharacterStateHelper.change_camera_state(arg_2_0._player, "follow_third_person_tunneling")

	local var_2_21 = false
	local var_2_22
	local var_2_23 = false

	if var_2_2:get_unarmed() then
		var_2_23 = true
	end

	var_2_1:set_first_person_mode(var_2_21, var_2_22, var_2_23)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_0, var_2_3, var_2_4)
	var_2_2:set_should_tunnel(false)
	arg_2_0:set_breed_action("tunneling")

	arg_2_0.state = "init"
end

function EnemyCharacterStateTunneling.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = BLACKBOARDS[arg_3_1]
	local var_3_1 = arg_3_0._csm
	local var_3_2 = arg_3_0._input_extension
	local var_3_3 = arg_3_0._status_extension
	local var_3_4 = arg_3_0._first_person_extension
	local var_3_5 = arg_3_0._locomotion_extension
	local var_3_6 = arg_3_0._inventory_extension

	CharacterStateHelper.look(var_3_2, arg_3_0._player.viewport_name, var_3_4, var_3_3, var_3_6)

	if CharacterStateHelper.do_common_state_transitions(var_3_3, var_3_1) then
		return
	end

	if arg_3_0.alignment_time_t > 0 then
		local var_3_7 = Vector3Box.unbox(arg_3_0.alignment_vector) * arg_3_3 / arg_3_0.alignment_total_t
		local var_3_8 = POSITION_LOOKUP[arg_3_1]
		local var_3_9 = Unit.mover(arg_3_1)

		Mover.set_position(var_3_9, var_3_8 + var_3_7)
		Unit.set_local_position(arg_3_1, 0, var_3_8 + var_3_7)

		arg_3_0.alignment_time_t = arg_3_0.alignment_time_t - arg_3_3
	end

	if arg_3_0.state == "init" and var_3_0.tunneling_begin then
		arg_3_0.fade_t = arg_3_5 + 0.5

		local var_3_10 = 5

		arg_3_0.transition_manager:fade_in(var_3_10)

		arg_3_0.state = "fade_in"
	end

	if arg_3_0.state == "fade_in" and arg_3_5 > arg_3_0.fade_t then
		local var_3_11 = QuaternionBox.unbox(arg_3_0.exit_rot)

		arg_3_0._first_person_extension:force_look_rotation(var_3_11)

		local var_3_12 = Quaternion.forward(var_3_11)

		arg_3_0.wanted_rot = Vector3Box(var_3_12)

		local var_3_13 = var_3_12 * arg_3_0.forward_offset + Vector3.up() * arg_3_0.height_offset
		local var_3_14 = Unit.local_position(arg_3_0.exit_unit, 0) + var_3_13
		local var_3_15 = Unit.mover(arg_3_1)

		Mover.set_position(var_3_15, var_3_14)
		Unit.set_local_position(arg_3_1, 0, var_3_14)
		var_3_3:set_invisible(true, nil, "tunneling")
		var_3_5:set_mover_filter_property("dark_pact_noclip", true)

		arg_3_0.state = "transition_video"
		arg_3_0.sub_state = "start_video"
	end

	if arg_3_0.state == "transition_video" then
		if arg_3_0.sub_state == "start_video" then
			local var_3_16 = 5
			local var_3_17 = arg_3_0.id % 4 + 1

			arg_3_0.transition_manager:fade_out(var_3_16)
			arg_3_0.pactsworn_video_transition_view:play_video(var_3_17)
			arg_3_0.pactsworn_video_transition_view:enable_video(true)

			arg_3_0.sub_state = "playing_video"
			arg_3_0.end_video_t = arg_3_5 + 3
		elseif arg_3_0.sub_state == "playing_video" then
			if arg_3_0.end_video_t - arg_3_5 < 0.25 then
				local var_3_18 = 10

				arg_3_0.transition_manager:fade_in(var_3_18)

				arg_3_0.sub_state = "end_video"
			end
		elseif arg_3_0.sub_state == "end_video" and arg_3_5 > arg_3_0.end_video_t then
			arg_3_0.fade_t = arg_3_5 + 0.25

			local var_3_19 = 5

			arg_3_0.transition_manager:fade_out(var_3_19)
			arg_3_0.pactsworn_video_transition_view:enable_video(false)

			local var_3_20 = Managers.state.entity:system("camera_system")
			local var_3_21 = QuaternionBox.unbox(arg_3_0.exit_rot)
			local var_3_22 = Quaternion.forward(var_3_21) + Quaternion.right(var_3_21) + Vector3.up() * 0.5
			local var_3_23 = Unit.local_position(arg_3_0.exit_unit, 0) + var_3_22 * 2

			var_3_20:update_tunnel_camera_position(arg_3_0._player, var_3_23)

			local var_3_24 = arg_3_0.exit_anim

			CharacterStateHelper.play_animation_event(arg_3_1, var_3_24)
			CharacterStateHelper.look(var_3_2, arg_3_0._player.viewport_name, var_3_4, var_3_3, var_3_6, nil, Vector3(-2, 0, 0))

			arg_3_0.end_video_t = nil
			arg_3_0.state = "fade_out"
		end
	end

	if arg_3_0.state == "fade_out" and arg_3_5 > arg_3_0.fade_t then
		var_3_3:set_invisible(false, nil, "tunneling")

		arg_3_0.state = "end"
	end

	if arg_3_0.state == "end" and var_3_0.tunneling_finished then
		var_3_5:set_mover_filter_property("dark_pact_noclip", false)
		var_3_4:force_look_rotation(QuaternionBox.unbox(arg_3_0.exit_rot), 0.1)
		arg_3_0:start_camera_transition()
		arg_3_0:to_movement_state()
	end

	local var_3_25 = arg_3_0.wanted_rot:unbox()

	Unit.set_local_rotation(arg_3_1, 0, Quaternion.look(var_3_25))
end

function EnemyCharacterStateTunneling.on_exit(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = BLACKBOARDS[arg_4_1]

	if var_4_0 then
		var_4_0.tunneling_begin = nil
		var_4_0.tunneling_finished = nil
	end

	if arg_4_0._status_extension:get_unarmed() then
		CharacterStateHelper.play_animation_event(arg_4_1, "to_unarmed")
	end

	arg_4_0:grant_control_to_player()
	arg_4_0:set_breed_action("n/a")

	ScriptUnit.extension(arg_4_1, "hit_reaction_system").force_ragdoll_on_death = nil
end

function EnemyCharacterStateTunneling.grant_control_to_player(arg_5_0)
	local var_5_0 = arg_5_0._locomotion_extension
	local var_5_1 = Unit.animation_wanted_root_pose(arg_5_0._unit)

	var_5_0:teleport_to(Matrix4x4.translation(var_5_1))
	var_5_0:set_wanted_velocity(Vector3.zero())
	var_5_0:enable_script_driven_movement()
	var_5_0:set_animation_translation_scale(Vector3(1, 1, 1))
	var_5_0:force_on_ground(true)
end

function EnemyCharacterStateTunneling.start_camera_transition(arg_6_0)
	local var_6_0 = arg_6_0._first_person_extension

	CharacterStateHelper.change_camera_state(arg_6_0._player, "follow")
	CharacterStateHelper.play_animation_event_first_person(var_6_0, "idle")
	var_6_0:toggle_visibility(0.4)
end
