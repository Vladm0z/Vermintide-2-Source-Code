-- chunkname: @scripts/unit_extensions/weapons/actions/action_dummy.lua

ActionDummy = class(ActionDummy, ActionBase)

function ActionDummy.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionDummy.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._owner_unit = arg_1_4
	arg_1_0.status_extension = ScriptUnit.has_extension(arg_1_4, "status_system")
	arg_1_0.spread_extension = ScriptUnit.has_extension(arg_1_7, "spread_system")
end

function ActionDummy.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionDummy.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0.current_action = arg_2_1
	arg_2_0.action_time_started = arg_2_2

	local var_2_0 = arg_2_1.spread_template_override

	if var_2_0 then
		arg_2_0.spread_extension:override_spread_template(var_2_0)
	end
end

function ActionDummy.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return
end

function ActionDummy.finish(arg_4_0, arg_4_1)
	if arg_4_0.spread_extension then
		arg_4_0.spread_extension:reset_spread_template()
	end

	Unit.flow_event(arg_4_0.owner_unit, "lua_force_stop")
	Unit.flow_event(arg_4_0.first_person_unit, "lua_force_stop")
end
