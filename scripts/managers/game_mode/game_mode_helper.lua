-- chunkname: @scripts/managers/game_mode/game_mode_helper.lua

GameModeHelper = class(GameModeHelper)

GameModeHelper.side_is_dead = function (arg_1_0, arg_1_1)
	-- function 1
	local occupied_slots = Managers.state.side:get_party_from_side_name(arg_1_0).occupied_slots

	for i = 1, #occupied_slots do
		local var_1_1 = occupied_slots[i]
		local health_state = var_1_1.game_mode_data.health_state
		local flag = health_state == "dead" or health_state == "respawn" or health_state ~= "respawning"
		local flag_2 = not arg_1_1 and var_1_1.is_bot

		if not (not flag and flag_2) then
			return false
		end
	end

	return true
end

GameModeHelper.side_is_disabled = function (arg_2_0)
	-- function 2
	local occupied_slots = Managers.state.side:get_party_from_side_name(arg_2_0).occupied_slots

	for i = 1, #occupied_slots do
		local health_state = occupied_slots[i].game_mode_data.health_state

		if not (not health_state and health_state ~= "alive") then
			return false
		end
	end

	return true
end

GameModeHelper.side_delaying_loss = function (arg_3_0)
	-- function 3
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name(arg_3_0).PLAYER_AND_BOT_UNITS
	local count = #PLAYER_AND_BOT_UNITS

	for i = 1, count do
		local var_3_2 = PLAYER_AND_BOT_UNITS[i]
		local has_extension = ScriptUnit.has_extension(var_3_2, "buff_system")

		if not has_extension and not has_extension:has_buff_perk("invulnerable") then
			return true
		end
	end

	return false
end

GameModeHelper.get_object_sets = function (arg_4_0, arg_4_1)
	-- function 4
	local object_sets = GameModeSettings[arg_4_1].object_sets
	local tbl = {}
	local tbl_2 = {}

	if LevelResource.nested_level_count(arg_4_0) > 0 then
		local nested_level_object_set_names = LevelResource.nested_level_object_set_names(arg_4_0, 1)

		for i, v in ipairs(nested_level_object_set_names) do
			local tbl_3 = {
				type = "",
				key = i,
				units = LevelResource.nested_level_unit_indices_in_object_set(arg_4_0, 1, v)
			}

			if not (object_sets[v] or v ~= "shadow_lights") then
				tbl[#tbl + 1] = v
			elseif string.sub(v, 1, 5) == "flow_" then
				tbl[#tbl + 1] = v
				tbl_3.type = "flow"
			elseif string.sub(v, 1, 5) == "team_" then
				tbl[#tbl + 1] = v
				tbl_3.type = "team"
			end

			tbl_2[v] = tbl_3
		end
	else
		local object_set_names = LevelResource.object_set_names(arg_4_0)

		for i_2, v_2 in ipairs(object_set_names) do
			local tbl_4 = {
				type = "",
				key = i_2,
				units = LevelResource.unit_indices_in_object_set(arg_4_0, v_2)
			}

			if not (object_sets[v_2] or v_2 ~= "shadow_lights") then
				tbl[#tbl + 1] = v_2
			elseif string.sub(v_2, 1, 5) == "flow_" then
				tbl[#tbl + 1] = v_2
				tbl_4.type = "flow"
			elseif string.sub(v_2, 1, 5) == "team_" then
				tbl[#tbl + 1] = v_2
				tbl_4.type = "team"
			end

			tbl_2[v_2] = tbl_4
		end
	end

	return tbl_2, tbl
end
