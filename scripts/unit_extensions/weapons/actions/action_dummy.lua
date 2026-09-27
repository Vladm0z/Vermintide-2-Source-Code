-- chunkname: @scripts/unit_extensions/weapons/actions/action_dummy.lua

ActionDummy = class(ActionDummy, ActionBase)

ActionDummy.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionDummy.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._owner_unit = arg_1_4
	self.status_extension = ScriptUnit.has_extension(arg_1_4, "status_system")
	self.spread_extension = ScriptUnit.has_extension(arg_1_7, "spread_system")
end

ActionDummy.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionDummy.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1
	self.action_time_started = arg_2_2

	local spread_template_override = arg_2_1.spread_template_override

	if not spread_template_override then
		self.spread_extension:override_spread_template(spread_template_override)
	end
end

ActionDummy.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionDummy.finish = function (self, arg_4_1)
	-- function 4
	if not self.spread_extension then
		self.spread_extension:reset_spread_template()
	end

	Unit.flow_event(self.owner_unit, "lua_force_stop")
	Unit.flow_event(self.first_person_unit, "lua_force_stop")
end
