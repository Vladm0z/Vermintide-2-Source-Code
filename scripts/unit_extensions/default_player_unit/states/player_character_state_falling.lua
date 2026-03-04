-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_falling.lua

local var_0_0 = {
	"Double",
	"Triple",
	"Quad",
	"Penta",
	"Hexa",
	"Hepta",
	"Octa",
	"Nona",
	"Deca",
	"Hendeca",
	"Dodeca",
	"Trideca",
	"Tetradeca",
	"Pentadeca",
	"Hexadeca",
	"Heptadeca",
	"Octadeca",
	"Enneadeca",
	"Icosa"
}

script_data.ledge_hanging_turned_off = script_data.ledge_hanging_turned_off or Development.parameter("ledge_hanging_turned_off")
TimesJumpedInAir = 0
PlayerCharacterStateFalling = class(PlayerCharacterStateFalling, PlayerCharacterState)

local var_0_1 = POSITION_LOOKUP

function PlayerCharacterStateFalling.init(arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "falling")

	arg_1_0.last_valid_nav_position = Vector3Box()
	arg_1_0.shaking_ladder_unit = false
end

function PlayerCharacterStateFalling.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0.falling_reason = arg_2_6

	local var_2_0 = arg_2_0.input_extension
	local var_2_1 = arg_2_0.status_extension
	local var_2_2 = arg_2_0.locomotion_extension
	local var_2_3 = arg_2_0.first_person_extension
	local var_2_4 = arg_2_0.inventory_extension

	var_2_1:set_falling_height()
	var_2_2:set_maximum_upwards_velocity(math.huge)

	local var_2_5 = var_2_4:get_wielded_slot_item_template()

	arg_2_0._play_fp_anim = var_2_5 and var_2_5.jump_anim_enabled_1p

	if arg_2_6 ~= "jumping" then
		local var_2_6
		local var_2_7
		local var_2_8 = CharacterStateHelper.is_moving(var_2_2) and "jump_fwd" or "jump_idle"
		local var_2_9 = arg_2_0._play_fp_anim and "to_falling" or "idle"

		CharacterStateHelper.play_animation_event(arg_2_1, var_2_8)
		CharacterStateHelper.play_animation_event_first_person(var_2_3, var_2_9)
	end

	arg_2_0.jumped = arg_2_7.jumped

	CharacterStateHelper.look(var_2_0, arg_2_0.player.viewport_name, var_2_3, var_2_1, arg_2_0.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_0, var_2_4, arg_2_0.health_extension)

	arg_2_0.is_active = true
	arg_2_0.times_jumped_in_air = 0
	arg_2_0.shaking_ladder_unit = arg_2_7.shaking_ladder_unit or nil

	if arg_2_6 ~= "jumping" and arg_2_6 ~= "leaping" and arg_2_6 ~= "overcharge_exploding" and arg_2_6 ~= "lunging" then
		ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_fell()
	end

	local var_2_10 = Managers.player:owner(arg_2_1)

	arg_2_0.is_bot = var_2_10 and var_2_10.bot_player
end

function PlayerCharacterStateFalling.on_exit(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	if not Managers.state.network:game() or not arg_3_6 then
		return
	end

	local var_3_0 = arg_3_0.status_extension

	arg_3_0.locomotion_extension:reset_maximum_upwards_velocity()
	CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
	CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")

	if arg_3_0._play_fp_anim then
		CharacterStateHelper.play_animation_event_first_person(arg_3_0.first_person_extension, "to_onground")
	end

	arg_3_0.is_active = false
	arg_3_0.jumped = nil

	if arg_3_6 == "walking" or arg_3_6 == "standing" then
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	else
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end
end

function PlayerCharacterStateFalling.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.world
	local var_4_1 = arg_4_0.locomotion_extension
	local var_4_2 = arg_4_0.first_person_extension
	local var_4_3 = var_4_1:current_velocity()
	local var_4_4 = POSITION_LOOKUP[arg_4_1]

	if var_4_3.z > 0 then
		arg_4_0.start_fall_height = var_0_1[arg_4_1].z
	end

	CharacterStateHelper.update_dodge_lock(arg_4_1, arg_4_0.input_extension, arg_4_0.status_extension)

	if var_0_1[arg_4_1].z < -240 then
		if arg_4_0.is_server then
			Managers.state.entity:system("health_system"):suicide(arg_4_1)
		else
			local var_4_5 = arg_4_0.unit_storage:go_id(arg_4_1)

			arg_4_0.network_transmit:send_rpc_server("rpc_suicide", var_4_5)
		end
	end

	local var_4_6 = arg_4_0.csm
	local var_4_7 = arg_4_0.unit
	local var_4_8 = arg_4_0.input_extension
	local var_4_9 = arg_4_0.status_extension

	if CharacterStateHelper.do_common_state_transitions(var_4_9, var_4_6) then
		return
	end

	if CharacterStateHelper.is_overcharge_exploding(var_4_9) then
		var_4_6:change_state("overcharge_exploding")

		return
	end

	local var_4_10 = PlayerUnitMovementSettings.get_movement_settings_table(var_4_7)

	if CharacterStateHelper.is_pushed(var_4_9) then
		var_4_9:set_pushed(false)

		local var_4_11 = var_4_10.stun_settings.pushed

		var_4_11.hit_react_type = var_4_9:hit_react_type() .. "_push"

		var_4_6:change_state("stunned", var_4_11)

		return
	end

	if CharacterStateHelper.is_charged(var_4_9) then
		local var_4_12 = var_4_10.charged_settings.charged

		var_4_12.hit_react_type = "charged"

		var_4_6:change_state("charged", var_4_12)

		return
	end

	if CharacterStateHelper.is_block_broken(var_4_9) then
		var_4_9:set_block_broken(false)

		local var_4_13 = var_4_10.stun_settings.parry_broken

		var_4_13.hit_react_type = "medium_push"

		var_4_6:change_state("stunned", var_4_13)

		return
	end

	if not var_4_6.state_next and var_4_1:is_on_ground() then
		if CharacterStateHelper.is_moving(var_4_1) then
			var_4_6:change_state("walking")
			var_4_2:change_state("walking")
		else
			var_4_6:change_state("standing")
			var_4_2:change_state("standing")
		end

		return
	end

	local var_4_14, var_4_15 = CharacterStateHelper.is_colliding_with_gameplay_collision_box(var_4_0, var_4_7, "filter_ladder_collision")
	local var_4_16 = CharacterStateHelper.recently_left_ladder(var_4_9, arg_4_5)
	local var_4_17
	local var_4_18
	local var_4_19

	if var_4_14 and not var_4_16 and (not arg_4_0.shaking_ladder_unit or arg_4_0.shaking_ladder_unit ~= var_4_15) then
		local var_4_20 = Unit.node(var_4_15, "c_platform")
		local var_4_21 = Unit.local_rotation(var_4_15, 0)
		local var_4_22 = Quaternion.forward(var_4_21)
		local var_4_23 = Unit.local_position(var_4_15, 0) - var_4_4

		var_4_19 = Vector3.dot(var_4_22, var_4_23)

		local var_4_24 = 0.1

		var_4_17 = var_4_4.z < Vector3.z(Unit.world_position(var_4_15, var_4_20))
		var_4_18 = var_4_19 > 0 and var_4_19 < 0.7 + var_4_24
		can_climb_ladder = var_4_17 and var_4_18

		if can_climb_ladder then
			local var_4_25 = arg_4_0.temp_params

			var_4_25.ladder_unit = var_4_15

			var_4_6:change_state("climbing_ladder", var_4_25)

			return
		end
	end

	if script_data.debug_ladder_climbing then
		Debug.text("CAN CLIMB: %s", can_climb_ladder)

		if not can_climb_ladder then
			Debug.text("Can't climb because:")

			if var_4_16 then
				Debug.text("\tRecently left ladder: %s", arg_4_5 - ScriptUnit.extension(var_4_7, "status_system").left_ladder_timer)
			end

			if var_4_14 == false then
				Debug.text("\tNot colliding with ladder")
			end

			if var_4_17 == false then
				Debug.text("\tAbove ladder")
			end

			if var_4_18 == false then
				Debug.text("\tToo far from ladder. Is %s, needs %s", var_4_19, 0.8)
			end

			if arg_4_0.shaking_ladder_unit and var_4_15 == arg_4_0.shaking_ladder_unit then
				Debug.text("\tAttempting to latch onto shaking ladder")
			end
		end
	end

	if CharacterStateHelper.is_ledge_hanging(var_4_0, var_4_7, arg_4_0.temp_params) and not CharacterStateHelper.handle_bot_ledge_hanging_failsafe(var_4_7, arg_4_0.is_bot) then
		var_4_6:change_state("ledge_hanging", arg_4_0.temp_params)

		return
	end

	if script_data.use_super_jumps and (var_4_8:get("jump") or var_4_8:get("jump_only")) then
		arg_4_0.times_jumped_in_air = math.min(#var_0_0, arg_4_0.times_jumped_in_air + 1)

		local var_4_26 = string.format("%sjump!", var_0_0[arg_4_0.times_jumped_in_air])

		Debug.sticky_text(var_4_26)

		local var_4_27 = var_4_10.jump.initial_vertical_speed
		local var_4_28 = arg_4_0.locomotion_extension:current_velocity()
		local var_4_29 = Vector3(var_4_28.x, var_4_28.y, var_4_28.z < -3 and var_4_27 * 0.5 or var_4_27 * 1.5)

		arg_4_0.locomotion_extension:set_forced_velocity(var_4_29)
		arg_4_0.locomotion_extension:set_wanted_velocity(var_4_29)
	end

	local var_4_30 = arg_4_0.inventory_extension
	local var_4_31 = var_4_10.move_speed * var_4_9:current_move_speed_multiplier() * var_4_10.player_speed_scale * var_4_10.player_air_speed_scale

	CharacterStateHelper.move_in_air(arg_4_0.first_person_extension, var_4_8, arg_4_0.locomotion_extension, var_4_31, var_4_7)
	CharacterStateHelper.look(var_4_8, arg_4_0.player.viewport_name, arg_4_0.first_person_extension, var_4_9, arg_4_0.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_4_5, var_4_7, var_4_8, var_4_30, arg_4_0.health_extension)

	local var_4_32 = arg_4_0.interactor_extension

	if CharacterStateHelper.is_starting_interaction(var_4_8, var_4_32) then
		local var_4_33, var_4_34 = InteractionHelper.interaction_action_names(var_4_7)

		var_4_32:start_interaction(var_4_34)

		if var_4_32:allow_movement_during_interaction() then
			return
		end

		local var_4_35 = var_4_32:interaction_config()
		local var_4_36 = arg_4_0.temp_params

		var_4_36.swap_to_3p = var_4_35.swap_to_3p
		var_4_36.show_weapons = var_4_35.show_weapons
		var_4_36.activate_block = var_4_35.activate_block
		var_4_36.allow_rotation_update = var_4_35.allow_rotation_update

		var_4_6:change_state("interacting", var_4_36)

		return
	end

	if CharacterStateHelper.is_interacting(var_4_32) then
		if var_4_32:allow_movement_during_interaction() then
			return
		end

		local var_4_37 = var_4_32:interaction_config()
		local var_4_38 = arg_4_0.temp_params

		var_4_38.swap_to_3p = var_4_37.swap_to_3p
		var_4_38.show_weapons = var_4_37.show_weapons
		var_4_38.activate_block = var_4_37.activate_block
		var_4_38.allow_rotation_update = var_4_37.allow_rotation_update

		var_4_6:change_state("interacting", var_4_38)

		return
	end
end
