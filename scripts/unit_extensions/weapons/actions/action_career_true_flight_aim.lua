-- chunkname: @scripts/unit_extensions/weapons/actions/action_career_true_flight_aim.lua

ActionCareerTrueFlightAim = class(ActionCareerTrueFlightAim, ActionTrueFlightBowAim)

function ActionCareerTrueFlightAim.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerTrueFlightAim.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
end

function ActionCareerTrueFlightAim.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionCareerTrueFlightAim.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	arg_2_0.not_wield_previous = arg_2_1.not_wield_previous

	local var_2_0 = arg_2_0.current_action.init_flow_event

	if var_2_0 then
		Unit.flow_event(arg_2_0.owner_unit, var_2_0)
		Unit.flow_event(arg_2_0.first_person_unit, var_2_0)
	end

	ScriptUnit.extension(arg_2_0.owner_unit, "inventory_system"):check_and_drop_pickups("career_ability")
end

function ActionCareerTrueFlightAim.finish(arg_3_0, arg_3_1)
	local var_3_0 = ActionCareerTrueFlightAim.super.finish(arg_3_0, arg_3_1)

	if arg_3_1 ~= "new_interupting_action" then
		if not arg_3_0.not_wield_previous then
			arg_3_0.inventory_extension:wield_previous_slot()
		end

		Unit.flow_event(arg_3_0.owner_unit, "lua_force_stop")
		Unit.flow_event(arg_3_0.first_person_unit, "lua_force_stop")
	end

	return var_3_0
end
