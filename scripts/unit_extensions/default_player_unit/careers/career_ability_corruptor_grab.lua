-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_corruptor_grab.lua

CareerAbilityCorruptorGrab = class(CareerAbilityCorruptorGrab)

CareerAbilityCorruptorGrab.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._world = arg_1_1.world
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)

	local var_1_0 = arg_1_3.player

	arg_1_0._player = var_1_0
	arg_1_0._is_server = var_1_0.is_server
	arg_1_0._local_player = var_1_0.local_player
	arg_1_0._bot_player = var_1_0.bot_player
	arg_1_0._network_manager = Managers.state.network
	arg_1_0._input_manager = Managers.input
end

CareerAbilityCorruptorGrab.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0._locomotion_extension = ScriptUnit.extension(arg_2_2, "locomotion_system")
	arg_2_0._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")
	arg_2_0._inventory_extension = ScriptUnit.has_extension(arg_2_2, "inventory_system")
	arg_2_0._ghost_mode_extension = ScriptUnit.has_extension(arg_2_2, "ghost_mode_system")
	arg_2_0._ability_input = arg_2_0._career_extension:get_activated_ability_data(1).input_action

	if arg_2_0._first_person_extension then
		arg_2_0._first_person_unit = arg_2_0._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityCorruptorGrab.destroy = function (arg_3_0)
	return
end

CareerAbilityCorruptorGrab._ability_available = function (arg_4_0)
	local var_4_0 = arg_4_0._career_extension
	local var_4_1 = arg_4_0._status_extension
	local var_4_2 = arg_4_0._locomotion_extension
	local var_4_3 = arg_4_0._ghost_mode_extension:is_in_ghost_mode()

	return var_4_0:can_use_activated_ability() and not var_4_1:is_disabled() and var_4_2:is_on_ground() and not var_4_3
end

CareerAbilityCorruptorGrab.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	return
end

CareerAbilityCorruptorGrab.was_triggered = function (arg_6_0)
	if not arg_6_0:_ability_available() then
		return false
	end

	local var_6_0 = arg_6_0._input_extension

	if not var_6_0 then
		return false
	end

	if var_6_0:get(arg_6_0._ability_input) then
		arg_6_0:_start()

		return true
	end

	return false
end

CareerAbilityCorruptorGrab.finish = function (arg_7_0, arg_7_1)
	return
end

CareerAbilityCorruptorGrab.stop = function (arg_8_0, arg_8_1)
	return
end

CareerAbilityCorruptorGrab._start = function (arg_9_0)
	return
end
