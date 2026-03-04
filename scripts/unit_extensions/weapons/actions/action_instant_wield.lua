-- chunkname: @scripts/unit_extensions/weapons/actions/action_instant_wield.lua

ActionInstantWield = class(ActionInstantWield, ActionBase)

ActionInstantWield.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionInstantWield.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.input_extension = ScriptUnit.extension(arg_1_4, "input_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
end

ActionInstantWield.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	ActionInstantWield.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	local var_2_0 = arg_2_1.slot_to_wield
	local var_2_1 = arg_2_1.action_on_wield
	local var_2_2 = arg_2_0.inventory_extension:equipment().slots[var_2_0]

	if var_2_2 then
		local var_2_3 = var_2_2.item_data

		BackendUtils.get_item_template(var_2_3).next_action = var_2_1

		arg_2_0.inventory_extension:wield(var_2_0)
		arg_2_0.input_extension:add_wield_cooldown(arg_2_2)
	end
end

ActionInstantWield.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

ActionInstantWield.finish = function (arg_4_0)
	local var_4_0 = arg_4_0.status_extension

	if var_4_0:is_zooming() then
		var_4_0:set_zooming(false)
	end
end
