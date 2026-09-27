-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_aim.lua

ActionCareerAim = class(ActionCareerAim, ActionAim)

ActionCareerAim.client_owner_start_action = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	ActionCareerAim.super.client_owner_start_action(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	ScriptUnit.extension(self.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end
