-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_catapulted.lua

require("scripts/settings/player_movement_settings")

EnemyCharacterStateCatapulted = class(EnemyCharacterStateCatapulted, EnemyCharacterState)

local var_0_0 = POSITION_LOOKUP
local var_0_1 = PlayerUnitMovementSettings.catapulted.directions

EnemyCharacterStateCatapulted.init = function (arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "catapulted")
end

EnemyCharacterStateCatapulted.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	CharacterStateHelper.stop_weapon_actions(arg_2_0._inventory_extension, "stunned")
	CharacterStateHelper.stop_career_abilities(arg_2_0._career_extension, "stunned")

	local var_2_0 = arg_2_7.direction
	local var_2_1 = arg_2_0._status_extension.catapulted_velocity:unbox()
	local var_2_2 = arg_2_0._locomotion_extension

	var_2_2:set_maximum_upwards_velocity(var_2_1.z)
	var_2_2:set_forced_velocity(var_2_1)
	var_2_2:set_wanted_velocity(var_2_1)

	arg_2_0._direction = var_2_0

	local var_2_3 = "idle"
	local var_2_4 = "idle"

	CharacterStateHelper.play_animation_event(arg_2_1, var_2_3)
	CharacterStateHelper.play_animation_event_first_person(arg_2_0._first_person_extension, var_2_4 or var_2_3)

	local var_2_5 = arg_2_0._first_person_extension

	var_2_5:hide_weapons("catapulted")

	local var_2_6 = false

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_6, arg_2_0._is_server, arg_2_0._inventory_extension)

	local var_2_7 = arg_2_7.sound_event

	if var_2_7 then
		var_2_5:play_hud_sound_event(var_2_7)
	end

	arg_2_0.start_catapulted_height = var_0_0[arg_2_1].z
end

EnemyCharacterStateCatapulted.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0._direction

	arg_3_0._direction = nil

	arg_3_0._status_extension:set_catapulted(false)
	arg_3_0._first_person_extension:unhide_weapons("catapulted")
	arg_3_0._locomotion_extension:reset_maximum_upwards_velocity()

	if Managers.state.network:game() then
		local var_3_1 = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_1, arg_3_0._is_server, arg_3_0._inventory_extension)
		CharacterStateHelper.play_animation_event(arg_3_1, "idle")
	end

	arg_3_0._status_extension:set_falling_height(nil, arg_3_0.start_catapulted_height)
end

EnemyCharacterStateCatapulted.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = arg_4_0._unit
	local var_4_2 = arg_4_0._world
	local var_4_3 = arg_4_0._input_extension
	local var_4_4 = arg_4_0._status_extension

	if var_0_0[var_4_1].z < -240 then
		print("Player has fallen outside the world -- kill meeeee ", var_0_0[var_4_1].z)

		local var_4_5 = arg_4_0._unit_storage:go_id(var_4_1)

		arg_4_0._network_transmit:send_rpc_server("rpc_suicide", var_4_5)
	end

	if CharacterStateHelper.is_dead(var_4_4) then
		var_4_0:change_state("dead")

		return
	end

	if CharacterStateHelper.is_in_vortex(var_4_4) then
		var_4_0:change_state("in_vortex")

		return
	end

	if CharacterStateHelper.is_colliding_down(var_4_1) and arg_4_0._locomotion_extension:current_velocity().z < 0 then
		local var_4_6 = "idle"

		CharacterStateHelper.play_animation_event(var_4_1, var_4_6)

		if CharacterStateHelper.has_move_input(var_4_3) then
			var_4_0:change_state("walking")
		else
			var_4_0:change_state("standing")
		end

		return
	end

	if CharacterStateHelper.is_colliding_down(var_4_1) and arg_4_0._locomotion_extension:is_on_ground() and arg_4_0._locomotion_extension:current_velocity().z >= 0 then
		local var_4_7 = "idle"

		CharacterStateHelper.play_animation_event(var_4_1, var_4_7)

		if CharacterStateHelper.has_move_input(var_4_3) then
			var_4_0:change_state("walking")
		else
			var_4_0:change_state("standing")
		end

		arg_4_0._locomotion_extension:add_external_velocity(arg_4_0._locomotion_extension:current_velocity() * 0.2)

		return
	end

	if CharacterStateHelper.is_colliding_sides(var_4_1) then
		local var_4_8 = "idle"

		CharacterStateHelper.play_animation_event(var_4_1, var_4_8)
		var_4_0:change_state("standing")

		return
	end

	local var_4_9 = arg_4_0._first_person_extension

	CharacterStateHelper.look(var_4_3, arg_4_0._player.viewport_name, var_4_9, var_4_4, arg_4_0._inventory_extension)
end
