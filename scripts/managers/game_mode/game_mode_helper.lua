-- chunkname: @scripts/managers/game_mode/game_mode_helper.lua

GameModeHelper = class(GameModeHelper)

GameModeHelper.side_is_dead = function (arg_1_0, arg_1_1)
	local var_1_0 = Managers.state.side:get_party_from_side_name(arg_1_0).occupied_slots

	for iter_1_0 = 1, #var_1_0 do
		local var_1_1 = var_1_0[iter_1_0]
		local var_1_2 = var_1_1.game_mode_data.health_state
		local var_1_3 = var_1_2 ~= "dead" and var_1_2 ~= "respawn" and var_1_2 ~= "respawning"
		local var_1_4 = arg_1_1 and var_1_1.is_bot

		if var_1_3 and not var_1_4 then
			return false
		end
	end

	return true
end

GameModeHelper.side_is_disabled = function (arg_2_0)
	local var_2_0 = Managers.state.side:get_party_from_side_name(arg_2_0).occupied_slots

	for iter_2_0 = 1, #var_2_0 do
		local var_2_1 = var_2_0[iter_2_0].game_mode_data.health_state

		if not var_2_1 or var_2_1 == "alive" then
			return false
		end
	end

	return true
end

GameModeHelper.side_delaying_loss = function (arg_3_0)
	local var_3_0 = Managers.state.side:get_side_from_name(arg_3_0).PLAYER_AND_BOT_UNITS
	local var_3_1 = #var_3_0

	for iter_3_0 = 1, var_3_1 do
		local var_3_2 = var_3_0[iter_3_0]
		local var_3_3 = ScriptUnit.has_extension(var_3_2, "buff_system")

		if var_3_3 and var_3_3:has_buff_perk("invulnerable") then
			return true
		end
	end

	return false
end

GameModeHelper.get_object_sets = function (arg_4_0, arg_4_1)
	local var_4_0 = GameModeSettings[arg_4_1].object_sets
	local var_4_1 = {}
	local var_4_2 = {}

	if LevelResource.nested_level_count(arg_4_0) > 0 then
		local var_4_3 = LevelResource.nested_level_object_set_names(arg_4_0, 1)

		for iter_4_0, iter_4_1 in ipairs(var_4_3) do
			local var_4_4 = {
				type = "",
				key = iter_4_0,
				units = LevelResource.nested_level_unit_indices_in_object_set(arg_4_0, 1, iter_4_1)
			}

			if var_4_0[iter_4_1] or iter_4_1 == "shadow_lights" then
				var_4_1[#var_4_1 + 1] = iter_4_1
			elseif string.sub(iter_4_1, 1, 5) == "flow_" then
				var_4_1[#var_4_1 + 1] = iter_4_1
				var_4_4.type = "flow"
			elseif string.sub(iter_4_1, 1, 5) == "team_" then
				var_4_1[#var_4_1 + 1] = iter_4_1
				var_4_4.type = "team"
			end

			var_4_2[iter_4_1] = var_4_4
		end
	else
		local var_4_5 = LevelResource.object_set_names(arg_4_0)

		for iter_4_2, iter_4_3 in ipairs(var_4_5) do
			local var_4_6 = {
				type = "",
				key = iter_4_2,
				units = LevelResource.unit_indices_in_object_set(arg_4_0, iter_4_3)
			}

			if var_4_0[iter_4_3] or iter_4_3 == "shadow_lights" then
				var_4_1[#var_4_1 + 1] = iter_4_3
			elseif string.sub(iter_4_3, 1, 5) == "flow_" then
				var_4_1[#var_4_1 + 1] = iter_4_3
				var_4_6.type = "flow"
			elseif string.sub(iter_4_3, 1, 5) == "team_" then
				var_4_1[#var_4_1 + 1] = iter_4_3
				var_4_6.type = "team"
			end

			var_4_2[iter_4_3] = var_4_6
		end
	end

	return var_4_2, var_4_1
end
