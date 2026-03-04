-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_dark_pact_base.lua

CareerAbilityDarkPactBase = class(CareerAbilityDarkPactBase)

CareerAbilityDarkPactBase.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._unit = arg_1_2
	arg_1_0._world = arg_1_1.world
	arg_1_0._wwise_world = Managers.world:wwise_world(arg_1_0._world)
	arg_1_0._physics_world = World.physics_world(arg_1_0._world)
	arg_1_0._ability_data = arg_1_4

	local var_1_0 = arg_1_3.player

	arg_1_0._player = var_1_0
	arg_1_0._is_server = var_1_0.is_server
	arg_1_0._local_player = var_1_0.local_player
	arg_1_0._bot_player = var_1_0.bot_player
	arg_1_0._network_manager = Managers.state.network
	arg_1_0._input_manager = Managers.input
end

CareerAbilityDarkPactBase.destroy = function (arg_2_0)
	return
end

CareerAbilityDarkPactBase.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._first_person_extension = ScriptUnit.has_extension(arg_3_2, "first_person_system")
	arg_3_0._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	arg_3_0._career_extension = ScriptUnit.extension(arg_3_2, "career_system")
	arg_3_0._locomotion_extension = ScriptUnit.extension(arg_3_2, "locomotion_system")
	arg_3_0._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	arg_3_0._ghost_mode_extension = ScriptUnit.has_extension(arg_3_2, "ghost_mode_system")
	arg_3_0._inventory_extension = ScriptUnit.extension(arg_3_2, "inventory_system")
	arg_3_0._is_server = Managers.player.is_server
	arg_3_0._ability_input = arg_3_0._ability_data.input_action

	if arg_3_0._first_person_extension then
		arg_3_0._first_person_unit = arg_3_0._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityDarkPactBase.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	return
end

CareerAbilityDarkPactBase.was_triggered = function (arg_5_0)
	local var_5_0 = arg_5_0._input_extension

	if not var_5_0 then
		return false
	end

	if var_5_0:get(arg_5_0._ability_input) then
		if not arg_5_0:_ability_available() then
			arg_5_0:_play_sound("versus_hud_ability_not_ready")

			return false
		end

		arg_5_0:_start()

		return true
	end

	return false
end

CareerAbilityDarkPactBase.finish = function (arg_6_0, arg_6_1)
	return
end

CareerAbilityDarkPactBase.stop = function (arg_7_0, arg_7_1)
	return
end

CareerAbilityDarkPactBase.ability_ready = function (arg_8_0)
	local var_8_0 = arg_8_0._first_person_extension

	if var_8_0 then
		var_8_0:play_hud_sound_event("Play_hud_ability_ready")
	end

	arg_8_0:_cooldown_ready()
	arg_8_0._status_extension:set_unarmed(false)
end

CareerAbilityDarkPactBase._cooldown_ready = function (arg_9_0)
	local var_9_0 = arg_9_0._inventory_extension:equipment()
	local var_9_1 = var_9_0.right_hand_wielded_unit or var_9_0.left_hand_wielded_unit

	if var_9_1 then
		Unit.flow_event(var_9_1, "cooldown_ready")
	end
end

CareerAbilityDarkPactBase.ability_available = function (arg_10_0)
	return arg_10_0:_ability_available()
end

CareerAbilityDarkPactBase._ability_available = function (arg_11_0)
	local var_11_0 = arg_11_0._career_extension
	local var_11_1 = arg_11_0._status_extension
	local var_11_2 = arg_11_0._locomotion_extension
	local var_11_3 = arg_11_0._ghost_mode_extension:is_in_ghost_mode()

	return not var_11_1:is_disabled() and not var_11_3 and var_11_0:can_use_activated_ability(arg_11_0._ability_data.ability_id)
end

CareerAbilityDarkPactBase._start = function (arg_12_0)
	arg_12_0:_play_vo()
end

CareerAbilityDarkPactBase._play_vo = function (arg_13_0)
	local var_13_0 = arg_13_0._unit
	local var_13_1 = ScriptUnit.extension_input(var_13_0, "dialogue_system")
	local var_13_2 = FrameTable.alloc_table()

	var_13_1:trigger_networked_dialogue_event("activate_ability", var_13_2)
end

CareerAbilityDarkPactBase._play_sound = function (arg_14_0, arg_14_1)
	WwiseWorld.trigger_event(arg_14_0._wwise_world, arg_14_1)
end
