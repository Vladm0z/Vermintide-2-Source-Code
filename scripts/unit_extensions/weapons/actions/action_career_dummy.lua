-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_dummy.lua

ActionCareerDummy = class(ActionCareerDummy, ActionDummy)

ActionCareerDummy.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerDummy.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.owner_unit = arg_1_4
	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
end

ActionCareerDummy.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionCareerDummy.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self.current_action = arg_2_1

	ScriptUnit.extension(self.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

ActionCareerDummy.finish = function (self, arg_3_1)
	-- function 3
	local finish = ActionCareerDummy.super.finish(self, arg_3_1)

	if arg_3_1 ~= "new_interupting_action" then
		self.inventory_extension:wield_previous_non_level_slot()
	end

	local current_action = self.current_action
	local owner_unit = self.owner_unit
	local unzoom_condition_function = current_action.unzoom_condition_function

	if not unzoom_condition_function and not unzoom_condition_function(arg_3_1) then
		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)
	end

	return finish
end
