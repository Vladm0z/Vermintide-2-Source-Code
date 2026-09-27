-- chunkname: @scripts/unit_extensions/weapons/actions/action_one_time_consumable.lua

ActionOneTimeConsumable = class(ActionOneTimeConsumable, ActionBase)

ActionOneTimeConsumable.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionOneTimeConsumable.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self._ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
end

ActionOneTimeConsumable.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionOneTimeConsumable.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1
end

ActionOneTimeConsumable.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionOneTimeConsumable.finish = function (self, arg_4_1)
	-- function 4
	if not (arg_4_1 == "action_complete" or arg_4_1 == "hungover") then
		return
	end

	local owner_unit = self.owner_unit
	local current_action = self.current_action
	local buff_template = current_action.buff_template

	if not buff_template then
		local network_manager = self.network_manager
		local var_4_4 = NetworkLookup.buff_templates[buff_template]
		local unit_game_object_id = network_manager:unit_game_object_id(owner_unit)

		if not self.is_server then
			self._buff_extension:add_buff(buff_template)
			network_manager.network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_4_4, unit_game_object_id, 0, false)
		else
			network_manager.network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_4_4, unit_game_object_id, 0, true)
		end
	end

	local _ammo_extension = self._ammo_extension

	if not _ammo_extension then
		local ammo_usage = current_action.ammo_usage

		_ammo_extension:use_ammo(ammo_usage)
	end
end
