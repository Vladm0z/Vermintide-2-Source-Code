-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_wave.lua

ActionCareerBWNecromancerWave = class(ActionCareerBWNecromancerWave, ActionBase)

ActionCareerBWNecromancerWave.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerBWNecromancerWave.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
end

ActionCareerBWNecromancerWave.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or {}

	ActionCareerBWNecromancerWave.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	if arg_2_3 then
		arg_2_0:_play_vo()
		arg_2_0._first_person_extension:play_hud_sound_event("Play_career_necro_ability_withering_wave_start", nil, true)
		arg_2_0:_spawn_wave(arg_2_3.position:unbox(), arg_2_3.direction:unbox())
		arg_2_0._career_extension:start_activated_ability_cooldown()
	end
end

ActionCareerBWNecromancerWave.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

ActionCareerBWNecromancerWave.finish = function (arg_4_0, arg_4_1)
	arg_4_0._inventory_extension:wield_previous_non_level_slot()
end

ActionCareerBWNecromancerWave._spawn_wave = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Managers.state.network
	local var_5_1 = var_5_0:unit_game_object_id(arg_5_0.owner_unit)

	var_5_0.network_transmit:send_rpc_server("rpc_necromancer_create_curse_weave", var_5_1, arg_5_1, arg_5_2)
end

ActionCareerBWNecromancerWave._play_vo = function (arg_6_0)
	local var_6_0 = arg_6_0.owner_unit
	local var_6_1 = ScriptUnit.extension_input(var_6_0, "dialogue_system")
	local var_6_2 = FrameTable.alloc_table()

	var_6_1:trigger_networked_dialogue_event("activate_ability", var_6_2)
end
