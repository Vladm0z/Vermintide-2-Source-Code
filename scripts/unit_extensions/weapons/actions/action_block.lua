-- chunkname: @scripts/unit_extensions/weapons/actions/action_block.lua

ActionBlock = class(ActionBlock, ActionBase)

function ActionBlock.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	arg_1_0.world = arg_1_1
	arg_1_0.owner_unit = arg_1_4
	arg_1_0.first_person_unit = arg_1_6
	arg_1_0.weapon_unit = arg_1_7
	arg_1_0.is_server = arg_1_3
	arg_1_0.item_name = arg_1_2
	arg_1_0._blocked_flag = false
	arg_1_0._blocked_time = 0
	arg_1_0._status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	arg_1_0._ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
end

function ActionBlock.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionBlock.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.current_action = arg_2_1
	arg_2_0.action_time_started = arg_2_2

	ScriptUnit.extension(arg_2_0.owner_unit, "input_system"):reset_input_buffer()

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = Managers.state.unit_storage:go_id(var_2_0)

	if not LEVEL_EDITOR_TEST then
		if arg_2_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_2_1, true)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_2_1, true)
		end
	end

	Unit.flow_event(arg_2_0.first_person_unit, "sfx_block_started")

	local var_2_2 = arg_2_0._status_extension

	var_2_2:set_blocking(true)

	var_2_2.timed_block = arg_2_2 + 0.5
end

function ActionBlock.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0._status_extension

	if var_3_0:has_blocked() then
		arg_3_0._blocked_flag = true
		arg_3_0._blocked_time = arg_3_2 - arg_3_0.action_time_started

		var_3_0:set_has_blocked(false)
	end
end

function ActionBlock.finish(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = true
	local var_4_1 = arg_4_2 and arg_4_2.new_action_settings

	if var_4_1 and var_4_1.keep_block then
		var_4_0 = false
	end

	local var_4_2 = arg_4_0.owner_unit

	if arg_4_1 ~= "new_interupting_action" then
		local var_4_3 = arg_4_0._ammo_extension
		local var_4_4 = arg_4_0.current_action
		local var_4_5 = var_4_4.reload_when_out_of_ammo_condition_func
		local var_4_6 = not var_4_5 and true or var_4_5(var_4_2, arg_4_1)

		if var_4_3 and var_4_4.reload_when_out_of_ammo and var_4_6 and var_4_3:ammo_count() == 0 and var_4_3:can_reload() then
			local var_4_7 = true

			var_4_3:start_reload(var_4_7)
		end
	end

	if var_4_0 then
		if not LEVEL_EDITOR_TEST then
			local var_4_8 = Managers.state.unit_storage:go_id(var_4_2)

			if arg_4_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_4_8, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_4_8, false)
			end
		end

		local var_4_9 = arg_4_0._status_extension

		var_4_9:set_blocking(false)
		var_4_9:set_has_blocked(false)
	end

	arg_4_0._blocked_flag = false
end

function ActionBlock.streak_available(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2 and arg_5_2.relative_start_time
	local var_5_1 = arg_5_2 and arg_5_2.relative_end_time

	if not arg_5_0._blocked_flag or not var_5_0 or not var_5_1 then
		return false
	end

	local var_5_2 = arg_5_0._blocked_time
	local var_5_3 = var_5_0 + var_5_2

	if arg_5_1 > var_5_1 + var_5_2 then
		arg_5_0._blocked_flag = false
		arg_5_0._blocked_time = 0
	elseif var_5_3 <= arg_5_1 then
		return true
	end

	return false
end
