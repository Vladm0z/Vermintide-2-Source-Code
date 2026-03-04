-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_dummy.lua

ActionCareerDummy = class(ActionCareerDummy, ActionDummy)

function ActionCareerDummy.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerDummy.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.owner_unit = arg_1_4
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
end

function ActionCareerDummy.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionCareerDummy.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.current_action = arg_2_1

	ScriptUnit.extension(arg_2_0.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

function ActionCareerDummy.finish(arg_3_0, arg_3_1)
	local var_3_0 = ActionCareerDummy.super.finish(arg_3_0, arg_3_1)

	if arg_3_1 ~= "new_interupting_action" then
		arg_3_0.inventory_extension:wield_previous_non_level_slot()
	end

	local var_3_1 = arg_3_0.current_action
	local var_3_2 = arg_3_0.owner_unit
	local var_3_3 = var_3_1.unzoom_condition_function

	if not var_3_3 or var_3_3(arg_3_1) then
		ScriptUnit.extension(var_3_2, "status_system"):set_zooming(false)
	end

	return var_3_0
end
