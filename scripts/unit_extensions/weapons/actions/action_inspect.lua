-- chunkname: @scripts/unit_extensions/weapons/actions/action_inspect.lua

ActionInspect = class(ActionInspect, ActionBase)

ActionInspect.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionInspect.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._owner_unit = arg_1_4

	if not ScriptUnit.has_extension(arg_1_4, "status_system") then
		self.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	end

	if not ScriptUnit.has_extension(arg_1_7, "spread_system") then
		self.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
	end

	self._first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
end

ActionInspect.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionInspect.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self.current_action = arg_2_1
	self.action_time_started = arg_2_2

	local spread_template_override = arg_2_1.spread_template_override

	if not spread_template_override then
		self.spread_extension:override_spread_template(spread_template_override)
	end

	local _first_person_extension = self._first_person_extension

	if not _first_person_extension then
		local current_rotation = _first_person_extension:current_rotation()

		_first_person_extension:force_look_rotation(current_rotation, math.huge)
	end
end

ActionInspect.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return
end

ActionInspect.finish = function (self, arg_4_1)
	-- function 4
	if not self.spread_extension then
		self.spread_extension:reset_spread_template()
	end

	local _first_person_extension = self._first_person_extension

	if not _first_person_extension then
		_first_person_extension:stop_force_look_rotation()
	end

	Unit.flow_event(self.owner_unit, "lua_force_stop")
	Unit.flow_event(self.first_person_unit, "lua_force_stop")
end
