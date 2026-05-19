-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_we_shade.lua

CareerAbilityWEShade = class(CareerAbilityWEShade)

function CareerAbilityWEShade.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._owner_unit = arg_1_2
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

function CareerAbilityWEShade.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	arg_2_0._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	arg_2_0._buff_system = Managers.state.entity:system("buff_system")
	arg_2_0._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")
	arg_2_0._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
end

function CareerAbilityWEShade.destroy(arg_3_0)
	return
end

function CareerAbilityWEShade.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if not arg_4_0:_ability_available() then
		return
	end

	local var_4_0 = arg_4_0._input_extension

	if var_4_0 and var_4_0:get("action_career") then
		arg_4_0:_run_ability()
	end
end

function CareerAbilityWEShade.stop(arg_5_0, arg_5_1)
	if arg_5_0._is_priming then
		arg_5_0:_stop_priming()
	end
end

function CareerAbilityWEShade._ability_available(arg_6_0)
	local var_6_0 = arg_6_0._career_extension
	local var_6_1 = arg_6_0._status_extension
	local var_6_2 = true

	return var_6_2 and var_6_0:can_use_activated_ability() and not var_6_1:is_disabled()
end

function CareerAbilityWEShade._run_ability(arg_7_0)
	local var_7_0 = arg_7_0._owner_unit
	local var_7_1 = arg_7_0._bot_player
	local var_7_2 = arg_7_0._network_manager
	local var_7_3 = var_7_2.network_transmit
	local var_7_4 = arg_7_0._buff_extension
	local var_7_5 = arg_7_0._career_extension
	local var_7_6 = arg_7_0._status_extension
	local var_7_7 = var_7_6:is_invisible()
	local var_7_8 = "kerillian_shade_activated_ability"

	if ScriptUnit.extension(arg_7_0._owner_unit, "talent_system"):has_talent("kerillian_shade_activated_ability_phasing") then
		var_7_8 = "kerillian_shade_activated_ability_phasing"
	end

	var_7_4:add_buff(var_7_8)

	local var_7_9 = arg_7_0._first_person_extension

	var_7_9:play_hud_sound_event("Play_career_ability_kerillian_shade_enter", nil, true)
	var_7_9:play_remote_hud_sound_event("Play_career_ability_kerillian_shade_loop_husk")

	if not var_7_1 then
		if not var_7_7 then
			var_7_9:play_hud_sound_event("Play_career_ability_kerillian_shade_loop")
		end

		var_7_9:animation_event("shade_stealth_ability")
		var_7_5:set_state("kerillian_activate_shade")
	end

	if Managers.state.network:game() then
		var_7_6:set_is_dodging(true)

		local var_7_10 = var_7_2:unit_game_object_id(var_7_0)

		var_7_3:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, var_7_10, 0)
	end

	var_7_5:start_activated_ability_cooldown()
	arg_7_0:_play_vo()
end

function CareerAbilityWEShade._play_vo(arg_8_0)
	local var_8_0 = arg_8_0._owner_unit
	local var_8_1 = ScriptUnit.extension_input(var_8_0, "dialogue_system")
	local var_8_2 = FrameTable.alloc_table()

	var_8_1:trigger_networked_dialogue_event("activate_ability", var_8_2)
end
