-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_falling.lua

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
EnemyCharacterStateFalling = class(EnemyCharacterStateFalling, EnemyCharacterState)

local var_0_1 = POSITION_LOOKUP

EnemyCharacterStateFalling.init = function (arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "falling")

	arg_1_0.last_valid_nav_position = Vector3Box()
	arg_1_0.shaking_ladder_unit = false
end

EnemyCharacterStateFalling.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0.falling_reason = arg_2_6

	local var_2_0 = arg_2_0._input_extension
	local var_2_1 = arg_2_0._status_extension
	local var_2_2 = arg_2_0._locomotion_extension
	local var_2_3 = arg_2_0._first_person_extension

	arg_2_0._breed = Unit.get_data(arg_2_1, "breed")

	var_2_1:set_falling_height()
	var_2_2:set_maximum_upwards_velocity(math.huge)
	CharacterStateHelper.play_animation_event_first_person(var_2_3, "idle")

	if arg_2_6 ~= "jumping" then
		local var_2_4
		local var_2_5
		local var_2_6 = CharacterStateHelper.is_moving(var_2_2) and "jump_idle" or "jump_idle"
		local var_2_7 = arg_2_0._play_fp_anim and "to_falling" or "idle"

		CharacterStateHelper.play_animation_event(arg_2_1, var_2_6)
		CharacterStateHelper.play_animation_event_first_person(var_2_3, var_2_7)
	end

	arg_2_0.jumped = arg_2_7.jumped

	local var_2_8 = arg_2_0._inventory_extension

	CharacterStateHelper.look(var_2_0, arg_2_0._player.viewport_name, var_2_3, var_2_1, arg_2_0._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_0, var_2_8, arg_2_0._health_extension)

	arg_2_0.is_active = true
	arg_2_0.times_jumped_in_air = 0
	arg_2_0.shaking_ladder_unit = arg_2_7.shaking_ladder_unit or false

	if arg_2_6 ~= "jumping" and arg_2_6 ~= "leaping" and arg_2_6 ~= "lunging" and arg_2_6 ~= "pouncing" then
		ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_fell()
	end
end

local var_0_2 = 7
local var_0_3 = 1

EnemyCharacterStateFalling.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	if not Managers.state.network:game() or not arg_3_6 then
		return
	end

	arg_3_0._locomotion_extension:reset_maximum_upwards_velocity()

	local var_3_0 = arg_3_0._status_extension:fall_distance()

	if var_3_0 > var_0_2 then
		local var_3_1 = "Play_versus_pactsworn_jump_land"

		arg_3_0._first_person_extension:play_unit_sound_event(var_3_1, arg_3_1, 0)
	elseif var_3_0 > var_0_3 then
		Unit.flow_event(arg_3_1, "pactsworn_land_after_jump")
	elseif arg_3_0.falling_reason == "tunneling" then
		Unit.flow_event(arg_3_1, "pactsworn_land_after_jump")
	elseif arg_3_0.falling_reason == "jumping" then
		Unit.flow_event(arg_3_1, "pactsworn_land_after_jump")
	end

	arg_3_0.is_active = false
	arg_3_0.jumped = nil

	local var_3_2 = "idle"

	if arg_3_6 == "walking" or arg_3_6 == "standing" then
		if arg_3_0.falling_reason == "tunneling" then
			local var_3_3 = "jump_down_land"
		end

		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
	else
		ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
	end

	if arg_3_6 and arg_3_6 ~= "falling" and Managers.state.network:game() then
		if arg_3_6 == "dead" then
			CharacterStateHelper.play_animation_event(arg_3_1, "ragdoll")
		else
			CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
			CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")

			if arg_3_0._play_fp_anim then
				CharacterStateHelper.play_animation_event_first_person(arg_3_0._first_person_extension, "to_onground")
			end
		end
	end
end

EnemyCharacterStateFalling.common_movement = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0._locomotion_extension
	local var_4_1 = arg_4_0._first_person_extension
	local var_4_2 = arg_4_0._breed

	if var_4_0:current_velocity().z > 0 then
		arg_4_0.start_fall_height = var_0_1[arg_4_3].z
	end

	CharacterStateHelper.update_dodge_lock(arg_4_3, arg_4_0._input_extension, arg_4_0._status_extension)

	if var_0_1[arg_4_3].z < -240 then
		local var_4_3 = arg_4_0._unit_storage:go_id(arg_4_3)

		arg_4_0._network_transmit:send_rpc_server("rpc_suicide", var_4_3)
	end

	local var_4_4 = arg_4_0._csm
	local var_4_5 = arg_4_0._input_extension
	local var_4_6 = arg_4_0._status_extension

	if CharacterStateHelper.do_common_state_transitions(var_4_6, var_4_4) then
		return
	end

	local var_4_7 = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_3)

	if CharacterStateHelper.is_pushed(var_4_6) then
		var_4_6:set_pushed(false)

		local var_4_8 = var_4_7.stun_settings.pushed

		var_4_8.hit_react_type = var_4_6:hit_react_type() .. "_push"

		var_4_4:change_state("stunned", var_4_8)

		return
	end

	if not var_4_4.state_next and var_4_0:is_on_ground() then
		if CharacterStateHelper.is_moving(var_4_0) then
			var_4_4:change_state("walking")
			var_4_1:change_state("walking")
		else
			var_4_4:change_state("standing")
			var_4_1:change_state("standing")
		end

		return
	end

	if script_data.use_super_jumps and (var_4_5:get("jump") or var_4_5:get("jump_only")) then
		arg_4_0.times_jumped_in_air = math.min(#var_0_0, arg_4_0.times_jumped_in_air + 1)

		local var_4_9 = string.format("%sjump!", var_0_0[arg_4_0.times_jumped_in_air])

		Debug.sticky_text(var_4_9)

		local var_4_10 = var_4_7.jump.initial_vertical_speed
		local var_4_11 = arg_4_0._locomotion_extension:current_velocity()
		local var_4_12 = Vector3(var_4_11.x, var_4_11.y, var_4_11.z < -3 and var_4_10 * 0.5 or var_4_10 * 1.5)

		arg_4_0._locomotion_extension:set_forced_velocity(var_4_12)
		arg_4_0._locomotion_extension:set_wanted_velocity(var_4_12)
	end

	local var_4_13 = var_4_2.movement_speed_multiplier
	local var_4_14 = var_4_7.move_speed

	if arg_4_1 then
		var_4_14 = var_4_7.ghost_move_speed
	end

	local var_4_15 = var_4_14 * var_4_13
	local var_4_16 = arg_4_0._buff_extension:apply_buffs_to_value(var_4_15, "movement_speed") * var_4_7.player_speed_scale

	CharacterStateHelper.move_in_air_pactsworn(arg_4_0._first_person_extension, var_4_5, arg_4_0._locomotion_extension, var_4_16, arg_4_3)
	CharacterStateHelper.ghost_mode(arg_4_0._ghost_mode_extension, var_4_5)
	CharacterStateHelper.look(var_4_5, arg_4_0._player.viewport_name, arg_4_0._first_person_extension, var_4_6, arg_4_0._inventory_extension)
end

EnemyCharacterStateFalling.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0._ghost_mode_extension:is_in_ghost_mode()
	local var_5_1 = arg_5_0:common_movement(var_5_0, arg_5_3, arg_5_1)
end
