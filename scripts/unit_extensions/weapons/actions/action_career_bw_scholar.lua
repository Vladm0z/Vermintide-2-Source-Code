-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_bw_scholar.lua

ActionCareerBWScholar = class(ActionCareerBWScholar, ActionTrueFlightBow)

function ActionCareerBWScholar.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerBWScholar.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.career_extension = ScriptUnit.extension(arg_1_4, "career_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	arg_1_0.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
end

function ActionCareerBWScholar.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionCareerBWScholar.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	local var_2_0 = arg_2_0.talent_extension
	local var_2_1 = arg_2_0.owner_unit

	if var_2_0:has_talent("sienna_scholar_activated_ability_dump_overcharge", "bright_wizard", true) then
		local var_2_2 = Managers.player:owner(var_2_1)

		if var_2_2.local_player or arg_2_0.is_server and var_2_2.bot_player then
			arg_2_0.overcharge_extension:reset()
		end
	end

	if var_2_0:has_talent("sienna_scholar_activated_ability_no_overcharge", "bright_wizard", true) then
		local var_2_3 = Managers.player:owner(var_2_1)

		if var_2_3.local_player or arg_2_0.is_server and var_2_3.bot_player then
			arg_2_0.buff_extension:add_buff("sienna_scholar_activated_ability_no_overcharge")
		end
	end

	if var_2_0:has_talent("sienna_scholar_activated_ability_heal", "bright_wizard", true) then
		local var_2_4 = Managers.state.network
		local var_2_5 = var_2_4.network_transmit
		local var_2_6 = var_2_4:unit_game_object_id(var_2_1)
		local var_2_7 = NetworkLookup.heal_types.career_skill

		var_2_5:send_rpc_server("rpc_request_heal", var_2_6, 35, var_2_7)
	end

	arg_2_0:_play_vo()
	arg_2_0.career_extension:start_activated_ability_cooldown()
	arg_2_0.inventory_extension:check_and_drop_pickups("career_ability")
end

function ActionCareerBWScholar.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	ActionCareerBWScholar.super.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end

function ActionCareerBWScholar.finish(arg_4_0, arg_4_1)
	if arg_4_0.state == "waiting_to_shoot" then
		arg_4_0:fire(arg_4_0.current_action, false)

		arg_4_0.state = "shot"
	end

	Unit.flow_event(arg_4_0.owner_unit, "lua_force_stop")
	Unit.flow_event(arg_4_0.first_person_unit, "lua_force_stop")
	ActionCareerBWScholar.super.finish(arg_4_0, arg_4_1)
	arg_4_0.inventory_extension:wield_previous_non_level_slot()
end

function ActionCareerBWScholar._play_vo(arg_5_0)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = ScriptUnit.extension_input(var_5_0, "dialogue_system")
	local var_5_2 = FrameTable.alloc_table()

	var_5_1:trigger_networked_dialogue_event("activate_ability", var_5_2)
end
