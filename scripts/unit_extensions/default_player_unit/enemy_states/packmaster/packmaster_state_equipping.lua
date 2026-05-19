-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_equipping.lua

PackmasterStateEquipping = class(PackmasterStateEquipping, EnemyCharacterState)

function PackmasterStateEquipping.init(arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "packmaster_equipping")

	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
end

local var_0_0 = POSITION_LOOKUP

function PackmasterStateEquipping.on_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	table.clear(arg_2_0._temp_params)

	arg_2_0._unit = arg_2_1
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_1, "first_person_system")
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_1, "status_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_1, "career_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_1, "buff_system")
	arg_2_0._locomotion_extension = ScriptUnit.extension(arg_2_1, "locomotion_system")
	arg_2_0._input_extension = ScriptUnit.has_extension(arg_2_1, "input_system")
	arg_2_0._inventory_extension = ScriptUnit.extension(arg_2_1, "inventory_system")

	local var_2_0 = Unit.get_data(arg_2_1, "breed")
	local var_2_1 = arg_2_0._first_person_extension

	CharacterStateHelper.play_animation_event(arg_2_1, "equip")
	CharacterStateHelper.play_animation_event_first_person(var_2_1, "equip")

	arg_2_0._spawn_weapon_time = arg_2_5 + var_2_0.equip_hook_weapon_spawn_time
	arg_2_0._finish_time = arg_2_5 + var_2_0.equip_hook_exit_state_time
end

function PackmasterStateEquipping.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_0._csm
	local var_3_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_3_1)
	local var_3_2 = arg_3_0._input_extension
	local var_3_3 = arg_3_0._status_extension
	local var_3_4 = arg_3_0._first_person_extension
	local var_3_5 = arg_3_0._locomotion_extension
	local var_3_6 = arg_3_0._inventory_extension
	local var_3_7 = arg_3_0._health_extension

	if CharacterStateHelper.do_common_state_transitions(var_3_3, var_3_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_3_3) then
		var_3_0:change_state("using_transport")

		return
	end

	if CharacterStateHelper.is_pushed(var_3_3) then
		var_3_3:set_pushed(false)

		local var_3_8 = var_3_1.stun_settings.pushed

		var_3_8.hit_react_type = var_3_3:hit_react_type() .. "_push"

		var_3_0:change_state("stunned", var_3_8)

		return
	end

	if CharacterStateHelper.is_block_broken(var_3_3) then
		var_3_3:set_block_broken(false)

		local var_3_9 = var_3_1.stun_settings.parry_broken

		var_3_9.hit_react_type = "medium_push"

		var_3_0:change_state("stunned", var_3_9)

		return
	end

	local var_3_10 = arg_3_0._spawn_weapon_time

	if var_3_10 and var_3_10 <= arg_3_5 then
		CharacterStateHelper.show_inventory_3p(arg_3_1, true, true, arg_3_0._is_server, var_3_6)
		var_3_4:unhide_weapons("catapulted")

		arg_3_0._spawn_weapon_time = nil
	end

	local var_3_11 = arg_3_0._finish_time

	if var_3_11 and var_3_11 <= arg_3_5 then
		CharacterStateHelper.play_animation_event(arg_3_1, "to_armed")
		CharacterStateHelper.play_animation_event_first_person(var_3_4, "to_armed")
		var_3_4:animation_set_variable("armed", 1)
		var_3_3:set_unarmed(false)
		var_3_0:change_state("standing")

		return
	end

	local var_3_12 = 1

	CharacterStateHelper.look(var_3_2, arg_3_0._player.viewport_name, var_3_4, var_3_3, var_3_6, var_3_12)
end

function PackmasterStateEquipping._finish(arg_4_0, arg_4_1)
	if not arg_4_0._locomotion_extension:is_on_ground() then
		return
	end

	local var_4_0 = arg_4_0._unit
	local var_4_1 = arg_4_0._career_extension
	local var_4_2 = arg_4_0._status_extension
	local var_4_3 = arg_4_0._locomotion_extension

	arg_4_0:_play_vo()
end

function PackmasterStateEquipping.on_exit(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	if not Managers.state.network:in_game_session() then
		return
	end

	local var_5_0 = arg_5_0._csm
	local var_5_1 = arg_5_0._status_extension
	local var_5_2 = arg_5_0._locomotion_extension

	arg_5_0._career_extension:start_activated_ability_cooldown(1, 1)

	arg_5_0._finish_time = nil
end

function PackmasterStateEquipping._play_vo(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._unit
end
