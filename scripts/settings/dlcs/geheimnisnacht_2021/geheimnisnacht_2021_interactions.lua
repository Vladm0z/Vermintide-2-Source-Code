-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_interactions.lua

local flag = true
local flag_2 = false
local InteractionDefinitions = InteractionDefinitions
local geheimnisnacht_2021_altar = InteractionDefinitions.geheimnisnacht_2021_altar

geheimnisnacht_2021_altar = geheimnisnacht_2021_altar or table.clone(InteractionDefinitions.smartobject)
InteractionDefinitions.geheimnisnacht_2021_altar = geheimnisnacht_2021_altar
InteractionDefinitions.geheimnisnacht_2021_altar.config = {
	only_once = true,
	hud_verb = "player_interaction",
	hold = true,
	swap_to_3p = false,
	activate_block = true,
	block_other_interactions = true
}

InteractionDefinitions.geheimnisnacht_2021_altar.server.stop = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	local flag_2 = arg_1_6 == InteractionResult.SUCCESS

	if not flag_2 then
		local get_level_seed = Managers.mechanism:get_level_seed()
		local local_position = Unit.local_position(arg_1_2, 0)
		local nav_world = Managers.state.conflict.nav_world
		local get_pos_towards_goal = ConflictUtils.get_pos_towards_goal(nav_world, local_position, 15, 1)
		local var_1_5

		if not get_pos_towards_goal then
			var_1_5 = Vector3Box(get_pos_towards_goal)

			if not var_1_5 then
				-- Nothing
			end
		end

		var_1_5 = nil

		::label_1_0::

		Managers.state.conflict:start_terror_event("geheimnisnacht_2021_event", get_level_seed, nil, var_1_5)
	end

	ScriptUnit.extension(arg_1_2, "props_system"):on_interact(flag, flag_2)

	local str = "lua_interaction_stopped_smartobject_" .. InteractionResult[arg_1_6]

	Unit.flow_event(arg_1_2, str)
end

InteractionDefinitions.geheimnisnacht_2021_altar.client.stop = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	InteractionDefinitions.smartobject.client.stop(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)

	local has_extension = ScriptUnit.has_extension(arg_2_2, "props_system")

	if not has_extension then
		has_extension:on_interact(flag_2)
	end
end

InteractionDefinitions.geheimnisnacht_2021_altar.server.can_interact = function (arg_3_0, arg_3_1)
	-- function 3
	if not ScriptUnit.extension(arg_3_1, "props_system"):can_interact() then
		return
	end

	local get_data = Unit.get_data(arg_3_1, "interaction_data", "custom_interaction_check_name")

	if not (not get_data and not InteractionCustomChecks[get_data] and InteractionCustomChecks[get_data](arg_3_0, arg_3_1)) then
		return false
	end

	return not Unit.get_data(arg_3_1, "interaction_data", "used")
end

InteractionDefinitions.geheimnisnacht_2021_altar.client.can_interact = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not ScriptUnit.extension(arg_4_1, "props_system"):can_interact() then
		return
	end

	local get_data = Unit.get_data(arg_4_1, "interaction_data", "custom_interaction_check_name")

	if not (not get_data and not InteractionCustomChecks[get_data] and InteractionCustomChecks[get_data](arg_4_0, arg_4_1)) then
		return false
	end

	local get_data_2 = Unit.get_data(arg_4_1, "interaction_data", "used")
	local get_data_3 = Unit.get_data(arg_4_1, "interaction_data", "being_used")

	return not not get_data_2 or not get_data_3
end

InteractionDefinitions.geheimnisnacht_2021_altar.client.start = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	InteractionDefinitions.smartobject.client.start(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)

	local has_extension = ScriptUnit.has_extension(arg_5_2, "props_system")

	if not has_extension then
		has_extension:on_interact_start(flag_2)
	end
end

InteractionDefinitions.geheimnisnacht_2021_altar.server.start = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	InteractionDefinitions.smartobject.server.start(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)

	local has_extension = ScriptUnit.has_extension(arg_6_2, "props_system")

	if not has_extension then
		has_extension:on_interact_start(flag)
	end
end
