-- chunkname: @scripts/unit_extensions/weapons/actions/action_instant_wield.lua

ActionInstantWield = class(ActionInstantWield, ActionBase)

ActionInstantWield.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionInstantWield.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.input_extension = ScriptUnit.extension(arg_1_4, "input_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
end

ActionInstantWield.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	ActionInstantWield.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	local slot_to_wield = arg_2_1.slot_to_wield
	local action_on_wield = arg_2_1.action_on_wield
	local var_2_2 = self.inventory_extension:equipment().slots[slot_to_wield]

	if not var_2_2 then
		local item_data = var_2_2.item_data

		BackendUtils.get_item_template(item_data).next_action = action_on_wield

		self.inventory_extension:wield(slot_to_wield)
		self.input_extension:add_wield_cooldown(arg_2_2)
	end
end

ActionInstantWield.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionInstantWield.finish = function (self)
	-- function 4
	local status_extension = self.status_extension

	if not status_extension:is_zooming() then
		status_extension:set_zooming(false)
	end
end
