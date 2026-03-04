-- chunkname: @scripts/unit_extensions/weapons/actions/action_melee_start.lua

ActionMeleeStart = class(ActionMeleeStart, ActionDummy)

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	return arg_1_1 / ActionUtils.get_action_time_scale(arg_1_2, arg_1_0)
end

ActionMeleeStart.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	ActionMeleeStart.super.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)

	arg_2_0._owner_unit = arg_2_4
	arg_2_0.input_extension = ScriptUnit.extension(arg_2_4, "input_system")
	arg_2_0.buff_extension = ScriptUnit.extension(arg_2_4, "buff_system")
	arg_2_0.spread_extension = ScriptUnit.has_extension(arg_2_7, "spread_system")
end

ActionMeleeStart.client_owner_start_action = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	ActionMeleeStart.super.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	Unit.flow_event(arg_3_0.first_person_unit, "sfx_swing_charge")
	arg_3_0:_play_additional_animation(arg_3_1.custom_start_anim_data)

	arg_3_0.zoom_condition_function = arg_3_1.zoom_condition_function

	local var_3_0 = arg_3_0.owner_unit
	local var_3_1 = arg_3_0.buff_extension

	arg_3_0._block_delay = var_0_0(arg_3_1, arg_3_1.blocking_charge_start_time or 0, var_3_0, var_3_1)

	if arg_3_0.zoom_condition_function then
		arg_3_0.aim_zoom_time = arg_3_2 + var_0_0(arg_3_1, arg_3_1.aim_zoom_delay or 0, var_3_0, var_3_1)
	end
end

ActionMeleeStart.client_owner_post_update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0.current_action
	local var_4_1 = arg_4_0.owner_unit
	local var_4_2 = arg_4_0.action_start_t
	local var_4_3 = var_4_0.blocking_charge
	local var_4_4 = arg_4_0.status_extension

	if not var_4_4.blocking and var_4_3 and arg_4_2 > var_4_2 + arg_4_0._block_delay then
		local var_4_5 = Managers.state.unit_storage:go_id(var_4_1)

		if not LEVEL_EDITOR_TEST then
			if arg_4_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_4_5, true)
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_charge_blocking", var_4_5, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_4_5, true)
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_charge_blocking", var_4_5, true)
			end
		end

		var_4_4:set_blocking(true)
		var_4_4:set_charge_blocking(true)

		var_4_4.timed_block = arg_4_2 + 0.5
	end

	if arg_4_0.zoom_condition_function and arg_4_0.zoom_condition_function(var_4_0.lookup_data) then
		local var_4_6 = arg_4_0.input_extension
		local var_4_7 = arg_4_0.buff_extension

		if not var_4_4:is_zooming() and arg_4_2 >= arg_4_0.aim_zoom_time then
			var_4_4:set_zooming(true, var_4_0.default_zoom)
		end

		if var_4_7:has_buff_perk("increased_zoom") and var_4_4:is_zooming() and var_4_6:get("action_three") then
			var_4_4:switch_variable_zoom(var_4_0.buffed_zoom_thresholds)
		end
	end
end

ActionMeleeStart.finish = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = true
	local var_5_1 = true

	if arg_5_1 == "new_interupting_action" then
		local var_5_2 = arg_5_2 and arg_5_2.new_action_settings

		if var_5_2 then
			var_5_0 = not var_5_2.chain_block_charge
			var_5_1 = not var_5_2.chain_aim
		end
	end

	local var_5_3 = arg_5_0.current_action
	local var_5_4 = arg_5_0.owner_unit

	if var_5_1 then
		local var_5_5 = var_5_3.unzoom_condition_function

		if not var_5_5 or var_5_5(arg_5_1, arg_5_2) then
			ScriptUnit.extension(var_5_4, "status_system"):set_zooming(false)
		end
	end

	if var_5_0 then
		if not LEVEL_EDITOR_TEST then
			local var_5_6 = Managers.state.unit_storage:go_id(var_5_4)

			if arg_5_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_5_6, false)
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_charge_blocking", var_5_6, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_5_6, false)
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_charge_blocking", var_5_6, false)
			end
		end

		local var_5_7 = ScriptUnit.extension(var_5_4, "status_system")

		var_5_7:set_blocking(false)
		var_5_7:set_charge_blocking(false)
	end

	arg_5_0:_play_additional_animation(var_5_3.custom_finish_anim_data)
end
