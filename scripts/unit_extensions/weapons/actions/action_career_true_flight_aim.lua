-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_true_flight_aim.lua

ActionCareerTrueFlightAim = class(ActionCareerTrueFlightAim, ActionTrueFlightBowAim)

ActionCareerTrueFlightAim.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerTrueFlightAim.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
end

ActionCareerTrueFlightAim.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionCareerTrueFlightAim.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	self.not_wield_previous = arg_2_1.not_wield_previous

	local init_flow_event = self.current_action.init_flow_event

	if not init_flow_event then
		Unit.flow_event(self.owner_unit, init_flow_event)
		Unit.flow_event(self.first_person_unit, init_flow_event)
	end

	ScriptUnit.extension(self.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

ActionCareerTrueFlightAim.finish = function (self, arg_3_1)
	-- function 3
	local finish = ActionCareerTrueFlightAim.super.finish(self, arg_3_1)

	if arg_3_1 ~= "new_interupting_action" then
		if not self.not_wield_previous then
			self.inventory_extension:wield_previous_slot()
		end

		Unit.flow_event(self.owner_unit, "lua_force_stop")
		Unit.flow_event(self.first_person_unit, "lua_force_stop")
	end

	return finish
end
