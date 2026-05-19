-- chunkname: @scripts/unit_extensions/weapons/actions/action_wield.lua

ActionWield = class(ActionWield, ActionBase)

function ActionWield.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionWield.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.input_extension = ScriptUnit.extension(arg_1_4, "input_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
end

function ActionWield.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	ActionWield.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3)

	local var_2_0 = arg_2_0.inventory_extension
	local var_2_1 = arg_2_0.input_extension

	arg_2_0.current_action = arg_2_1
	arg_2_0.action_time_started = arg_2_2

	if arg_2_0.current_action.reset_aim_on_attack then
		ScriptUnit.extension(arg_2_0.owner_unit, "first_person_system"):reset_aim_assist_multiplier()
	end

	local var_2_2, var_2_3, var_2_4 = CharacterStateHelper.wield_input(var_2_1, var_2_0, "action_wield")

	arg_2_0.new_slot = var_2_2

	assert(arg_2_0.new_slot, "went into wield action without input")

	if var_2_2 == var_2_0:get_wielded_slot_name() or var_2_4 then
		var_2_0:swap_equipment_from_storage(var_2_2, var_2_4)
		Managers.state.event:trigger("swap_equipment_from_storage", var_2_2, var_2_0:get_additional_items(var_2_2))
	end

	var_2_1:set_last_scroll_value(var_2_3)

	local var_2_5 = true

	var_2_1:clear_input_buffer(var_2_5)

	local var_2_6 = var_2_0:equipment().slots[var_2_2].item_data
	local var_2_7 = BackendUtils.get_item_template(var_2_6)

	var_2_7.next_action = var_2_7.action_on_wield

	var_2_1:add_wield_cooldown(arg_2_2 + arg_2_1.wield_cooldown)
	var_2_0:wield(arg_2_0.new_slot)
end

function ActionWield.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

function ActionWield.finish(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.status_extension

	if var_4_0:is_zooming() then
		var_4_0:set_zooming(false)
	end
end
