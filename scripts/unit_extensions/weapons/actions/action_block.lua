-- chunkname: @scripts/unit_extensions/weapons/actions/action_block.lua

ActionBlock = class(ActionBlock, ActionBase)

ActionBlock.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	self.world = arg_1_1
	self.owner_unit = arg_1_4
	self.first_person_unit = arg_1_6
	self.weapon_unit = arg_1_7
	self.is_server = arg_1_3
	self.item_name = arg_1_2
	self._blocked_flag = false
	self._blocked_time = 0
	self._status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	self._ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
end

ActionBlock.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionBlock.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1
	self.action_time_started = arg_2_2

	ScriptUnit.extension(self.owner_unit, "input_system"):reset_input_buffer()

	local owner_unit = self.owner_unit
	local go_id = Managers.state.unit_storage:go_id(owner_unit)

	if not LEVEL_EDITOR_TEST then
		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
		end
	end

	Unit.flow_event(self.first_person_unit, "sfx_block_started")

	local _status_extension = self._status_extension

	_status_extension:set_blocking(true)

	_status_extension.timed_block = arg_2_2 + 0.5
end

ActionBlock.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local _status_extension = self._status_extension

	if not _status_extension:has_blocked() then
		self._blocked_flag = true
		self._blocked_time = arg_3_2 - self.action_time_started

		_status_extension:set_has_blocked(false)
	end
end

ActionBlock.finish = function (self, arg_4_1, arg_4_2)
	-- function 4
	local flag = true
	local flag_2 = not arg_4_2 and arg_4_2.new_action_settings

	if not flag_2 and not flag_2.keep_block then
		flag = false
	end

	local owner_unit = self.owner_unit

	if arg_4_1 ~= "new_interupting_action" then
		local _ammo_extension = self._ammo_extension
		local current_action = self.current_action
		local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func
		local flag_3

		flag_3 = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(owner_unit, arg_4_1)

		if not _ammo_extension and not current_action.reload_when_out_of_ammo and not flag_3 and _ammo_extension:ammo_count() ~= 0 or not _ammo_extension:can_reload() then
			local flag_4 = true

			_ammo_extension:start_reload(flag_4)
		end
	end

	if not flag then
		if not LEVEL_EDITOR_TEST then
			local go_id = Managers.state.unit_storage:go_id(owner_unit)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, false)
			end
		end

		local _status_extension = self._status_extension

		_status_extension:set_blocking(false)
		_status_extension:set_has_blocked(false)
	end

	self._blocked_flag = false
end

ActionBlock.streak_available = function (self, arg_5_1, arg_5_2)
	-- function 5
	local flag = not arg_5_2 and arg_5_2.relative_start_time
	local flag_2 = not arg_5_2 and arg_5_2.relative_end_time

	if not (not self._blocked_flag and not flag and flag_2) then
		return false
	end

	local _blocked_time = self._blocked_time
	local num = flag + _blocked_time

	if arg_5_1 > flag_2 + _blocked_time then
		self._blocked_flag = false
		self._blocked_time = 0
	elseif num <= arg_5_1 then
		return true
	end

	return false
end
