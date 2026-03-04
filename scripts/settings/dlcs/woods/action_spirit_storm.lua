-- chunkname: @scripts/settings/dlcs/woods/action_spirit_storm.lua

ActionSpiritStorm = class(ActionSpiritStorm, ActionBase)

ActionSpiritStorm.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionSpiritStorm.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
end

ActionSpiritStorm.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionSpiritStorm.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.current_action = arg_2_1

	local var_2_0 = arg_2_0.owner_unit

	arg_2_0.owner_buff_extension = ScriptUnit.extension(var_2_0, "buff_system")
	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + (arg_2_1.fire_time or 0)
	arg_2_0.target = arg_2_3.target
	arg_2_0.is_critical_strike = ActionUtils.is_critical_strike(var_2_0, arg_2_1)
end

ActionSpiritStorm.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.current_action

	if arg_3_0.state == "waiting_to_shoot" and arg_3_2 >= arg_3_0.time_to_shoot then
		arg_3_0.state = "shooting"
	end

	if arg_3_0.state == "shooting" then
		arg_3_0:fire()

		arg_3_0.state = "doing_damage"
	end

	if arg_3_0.state == "doing_damage" then
		arg_3_0:_proc_spell_used(arg_3_0.owner_buff_extension)

		arg_3_0.state = "shot"
	end
end

ActionSpiritStorm.finish = function (arg_4_0, arg_4_1)
	if arg_4_0.state ~= "waiting_to_shoot" and arg_4_0.state ~= "shot" then
		arg_4_0:_proc_spell_used(arg_4_0.owner_buff_extension)
	end

	arg_4_0.position = nil

	local var_4_0 = ScriptUnit.has_extension(arg_4_0.owner_unit, "hud_system")

	if var_4_0 then
		var_4_0.show_critical_indication = false
	end
end

ActionSpiritStorm.fire = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.current_action
	local var_5_1 = arg_5_0.owner_unit
	local var_5_2 = arg_5_0.target
	local var_5_3 = POSITION_LOOKUP[var_5_2]
	local var_5_4 = var_5_0.overcharge_amount

	if var_5_3 then
		local var_5_5 = Managers.state.unit_storage:go_id(var_5_1)
		local var_5_6 = Managers.state.unit_storage:go_id(arg_5_0.target)

		arg_5_0.network_transmit:send_rpc_server("rpc_summon_vortex", var_5_5, var_5_6)

		local var_5_7 = Unit.get_data(var_5_2, "breed")

		if var_5_7 and var_5_7.is_player then
			var_5_4 = var_5_0.overcharge_amount_player_target or var_5_4

			if var_5_0.player_target_buff then
				arg_5_0.owner_buff_extension:add_buff(var_5_0.player_target_buff)
			end
		end
	end

	if var_5_4 then
		local var_5_8 = arg_5_0.owner_buff_extension

		if arg_5_0.is_critical_strike and var_5_8:has_buff_perk("no_overcharge_crit") then
			var_5_4 = 0
		end

		arg_5_0.overcharge_extension:add_charge(var_5_4)
	end

	local var_5_9 = arg_5_0.current_action.fire_sound_event

	if var_5_9 then
		local var_5_10 = arg_5_0.current_action.fire_sound_on_husk

		ScriptUnit.extension(var_5_1, "first_person_system"):play_hud_sound_event(var_5_9, nil, var_5_10)
	end

	if var_5_0.alert_enemies and var_5_3 then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_5_1, var_5_3, var_5_0.alert_sound_range_fire)
	end
end
