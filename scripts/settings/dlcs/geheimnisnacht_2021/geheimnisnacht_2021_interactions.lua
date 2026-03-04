-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_interactions.lua

local var_0_0 = true
local var_0_1 = false

InteractionDefinitions.geheimnisnacht_2021_altar = InteractionDefinitions.geheimnisnacht_2021_altar or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.geheimnisnacht_2021_altar.config = {
	only_once = true,
	hud_verb = "player_interaction",
	hold = true,
	swap_to_3p = false,
	activate_block = true,
	block_other_interactions = true
}

InteractionDefinitions.geheimnisnacht_2021_altar.server.stop = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	local var_1_0 = arg_1_6 == InteractionResult.SUCCESS

	if var_1_0 then
		local var_1_1 = Managers.mechanism:get_level_seed()
		local var_1_2 = Unit.local_position(arg_1_2, 0)
		local var_1_3 = Managers.state.conflict.nav_world
		local var_1_4 = ConflictUtils.get_pos_towards_goal(var_1_3, var_1_2, 15, 1)
		local var_1_5 = var_1_4 and Vector3Box(var_1_4) or nil

		Managers.state.conflict:start_terror_event("geheimnisnacht_2021_event", var_1_1, nil, var_1_5)
	end

	ScriptUnit.extension(arg_1_2, "props_system"):on_interact(var_0_0, var_1_0)

	local var_1_6 = "lua_interaction_stopped_smartobject_" .. InteractionResult[arg_1_6]

	Unit.flow_event(arg_1_2, var_1_6)
end

InteractionDefinitions.geheimnisnacht_2021_altar.client.stop = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	InteractionDefinitions.smartobject.client.stop(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)

	local var_2_0 = ScriptUnit.has_extension(arg_2_2, "props_system")

	if var_2_0 then
		var_2_0:on_interact(var_0_1)
	end
end

InteractionDefinitions.geheimnisnacht_2021_altar.server.can_interact = function (arg_3_0, arg_3_1)
	if not ScriptUnit.extension(arg_3_1, "props_system"):can_interact() then
		return
	end

	local var_3_0 = Unit.get_data(arg_3_1, "interaction_data", "custom_interaction_check_name")

	if var_3_0 and InteractionCustomChecks[var_3_0] and not InteractionCustomChecks[var_3_0](arg_3_0, arg_3_1) then
		return false
	end

	return not Unit.get_data(arg_3_1, "interaction_data", "used")
end

InteractionDefinitions.geheimnisnacht_2021_altar.client.can_interact = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not ScriptUnit.extension(arg_4_1, "props_system"):can_interact() then
		return
	end

	local var_4_0 = Unit.get_data(arg_4_1, "interaction_data", "custom_interaction_check_name")

	if var_4_0 and InteractionCustomChecks[var_4_0] and not InteractionCustomChecks[var_4_0](arg_4_0, arg_4_1) then
		return false
	end

	local var_4_1 = Unit.get_data(arg_4_1, "interaction_data", "used")
	local var_4_2 = Unit.get_data(arg_4_1, "interaction_data", "being_used")

	return not var_4_1 and not var_4_2
end

InteractionDefinitions.geheimnisnacht_2021_altar.client.start = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	InteractionDefinitions.smartobject.client.start(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)

	local var_5_0 = ScriptUnit.has_extension(arg_5_2, "props_system")

	if var_5_0 then
		var_5_0:on_interact_start(var_0_1)
	end
end

InteractionDefinitions.geheimnisnacht_2021_altar.server.start = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	InteractionDefinitions.smartobject.server.start(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)

	local var_6_0 = ScriptUnit.has_extension(arg_6_2, "props_system")

	if var_6_0 then
		var_6_0:on_interact_start(var_0_0)
	end
end
