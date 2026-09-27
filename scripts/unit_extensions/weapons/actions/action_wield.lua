-- chunkname: @scripts/unit_extensions/weapons/actions/action_wield.lua

ActionWield = class(ActionWield, ActionBase)

ActionWield.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionWield.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.input_extension = ScriptUnit.extension(arg_1_4, "input_system")
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
end

ActionWield.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	ActionWield.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3)

	local inventory_extension = self.inventory_extension
	local input_extension = self.input_extension

	self.current_action = arg_2_1
	self.action_time_started = arg_2_2

	if not self.current_action.reset_aim_on_attack then
		ScriptUnit.extension(self.owner_unit, "first_person_system"):reset_aim_assist_multiplier()
	end

	local wield_input, var_2_3, var_2_4 = CharacterStateHelper.wield_input(input_extension, inventory_extension, "action_wield")

	self.new_slot = wield_input

	assert(self.new_slot, "went into wield action without input")

	if wield_input == inventory_extension:get_wielded_slot_name() or not var_2_4 then
		inventory_extension:swap_equipment_from_storage(wield_input, var_2_4)
		Managers.state.event:trigger("swap_equipment_from_storage", wield_input, inventory_extension:get_additional_items(wield_input))
	end

	input_extension:set_last_scroll_value(var_2_3)

	local flag = true

	input_extension:clear_input_buffer(flag)

	local item_data = inventory_extension:equipment().slots[wield_input].item_data
	local get_item_template = BackendUtils.get_item_template(item_data)

	get_item_template.next_action = get_item_template.action_on_wield

	input_extension:add_wield_cooldown(arg_2_2 + arg_2_1.wield_cooldown)
	inventory_extension:wield(self.new_slot)
end

ActionWield.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionWield.finish = function (self, arg_4_1)
	-- function 4
	local status_extension = self.status_extension

	if not status_extension:is_zooming() then
		status_extension:set_zooming(false)
	end
end
