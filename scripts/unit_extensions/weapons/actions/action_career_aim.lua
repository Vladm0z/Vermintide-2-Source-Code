-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_aim.lua

ActionCareerAim = class(ActionCareerAim, ActionAim)

ActionCareerAim.client_owner_start_action = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	ActionCareerAim.super.client_owner_start_action(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	ScriptUnit.extension(arg_1_0.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end
