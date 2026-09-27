-- chunkname: @scripts/unit_extensions/weapons/actions/action_melee_start.lua

ActionMeleeStart = class(ActionMeleeStart, ActionDummy)

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	return arg_1_1 / ActionUtils.get_action_time_scale(arg_1_2, arg_1_0)
end

ActionMeleeStart.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	-- function 2
	ActionMeleeStart.super.init(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)

	self._owner_unit = arg_2_4
	self.input_extension = ScriptUnit.extension(arg_2_4, "input_system")
	self.buff_extension = ScriptUnit.extension(arg_2_4, "buff_system")
	self.spread_extension = ScriptUnit.has_extension(arg_2_7, "spread_system")
end

ActionMeleeStart.client_owner_start_action = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	ActionMeleeStart.super.client_owner_start_action(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	Unit.flow_event(self.first_person_unit, "sfx_swing_charge")
	self:_play_additional_animation(arg_3_1.custom_start_anim_data)

	self.zoom_condition_function = arg_3_1.zoom_condition_function

	local owner_unit = self.owner_unit
	local buff_extension = self.buff_extension
	local var_3_2 = fn
	local var_3_3 = arg_3_1
	local blocking_charge_start_time = arg_3_1.blocking_charge_start_time

	blocking_charge_start_time = blocking_charge_start_time or 0
	self._block_delay = var_3_2(var_3_3, blocking_charge_start_time, owner_unit, buff_extension)

	if not self.zoom_condition_function then
		local var_3_5 = fn
		local var_3_6 = arg_3_1
		local aim_zoom_delay = arg_3_1.aim_zoom_delay

		aim_zoom_delay = aim_zoom_delay or 0
		self.aim_zoom_time = arg_3_2 + var_3_5(var_3_6, aim_zoom_delay, owner_unit, buff_extension)
	end
end

ActionMeleeStart.client_owner_post_update = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local action_start_t = self.action_start_t
	local blocking_charge = current_action.blocking_charge
	local status_extension = self.status_extension

	if not ((status_extension.blocking or not blocking_charge) and not (arg_4_2 > action_start_t + self._block_delay)) then
		local go_id = Managers.state.unit_storage:go_id(owner_unit)

		if not LEVEL_EDITOR_TEST then
			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_charge_blocking", go_id, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_charge_blocking", go_id, true)
			end
		end

		status_extension:set_blocking(true)
		status_extension:set_charge_blocking(true)

		status_extension.timed_block = arg_4_2 + 0.5
	end

	if not self.zoom_condition_function and not self.zoom_condition_function(current_action.lookup_data) then
		local input_extension = self.input_extension
		local buff_extension = self.buff_extension

		if not (status_extension:is_zooming() or not (arg_4_2 >= self.aim_zoom_time)) then
			status_extension:set_zooming(true, current_action.default_zoom)
		end

		if not buff_extension:has_buff_perk("increased_zoom") and not status_extension:is_zooming() and not input_extension:get("action_three") then
			status_extension:switch_variable_zoom(current_action.buffed_zoom_thresholds)
		end
	end
end

ActionMeleeStart.finish = function (self, arg_5_1, arg_5_2)
	-- function 5
	local flag = true
	local flag_2 = true

	if arg_5_1 == "new_interupting_action" then
		local flag_3 = not arg_5_2 and arg_5_2.new_action_settings

		if not flag_3 then
			flag = not flag_3.chain_block_charge
			flag_2 = not flag_3.chain_aim
		end
	end

	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if not flag_2 then
		local unzoom_condition_function = current_action.unzoom_condition_function

		if not unzoom_condition_function and not unzoom_condition_function(arg_5_1, arg_5_2) then
			ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)
		end
	end

	if not flag then
		if not LEVEL_EDITOR_TEST then
			local go_id = Managers.state.unit_storage:go_id(owner_unit)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, false)
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_charge_blocking", go_id, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, false)
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_charge_blocking", go_id, false)
			end
		end

		local extension = ScriptUnit.extension(owner_unit, "status_system")

		extension:set_blocking(false)
		extension:set_charge_blocking(false)
	end

	self:_play_additional_animation(current_action.custom_finish_anim_data)
end
