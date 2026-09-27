-- chunkname: @scripts/helpers/player_utils.lua

PlayerUtils = {}

PlayerUtils.unique_player_id = function (arg_1_0, arg_1_1)
	-- function 1
	return arg_1_0 .. ":" .. arg_1_1
end

PlayerUtils.split_unique_player_id = function (arg_2_0)
	-- function 2
	local match, var_2_1 = string.match(arg_2_0, "^([^:]+):(.*)$")

	return match, tonumber(var_2_1)
end

PlayerUtils.get_random_alive_hero = function ()
	-- function 3
	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	get_side_from_name = get_side_from_name or Managers.state.side:sides()[1]

	local PLAYER_AND_BOT_UNITS = get_side_from_name.PLAYER_AND_BOT_UNITS
	local tbl = {}
	local num = 0

	for i = 1, #PLAYER_AND_BOT_UNITS do
		local var_3_4 = PLAYER_AND_BOT_UNITS[i]

		if not HEALTH_ALIVE[var_3_4] then
			num = num + 1
			tbl[num] = var_3_4
		end
	end

	if num > 0 then
		return tbl[math.random(1, num)]
	end

	return nil
end

PlayerUtils.get_career_override = function (arg_4_0)
	-- function 4
	local mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("override_career_availability")

	if not mechanism_setting_for_title then
		return true
	end

	local var_4_1 = mechanism_setting_for_title[arg_4_0]

	if var_4_1 ~= nil then
		return var_4_1
	end

	return true
end

PlayerUtils.get_enabled_career_index_by_profile = function (arg_5_0)
	-- function 5
	local careers = SPProfiles[arg_5_0].careers

	for i = 1, #careers do
		if not PlayerUtils.get_career_override(careers[i].display_name) then
			return i
		end
	end
end

PlayerUtils.get_random_enabled_career_index_by_profile = function (arg_6_0)
	-- function 6
	local shallow_copy = table.shallow_copy(SPProfiles[arg_6_0].careers)
	local var_6_1

	repeat
		local random = math.random(1, #shallow_copy)

		if not PlayerUtils.get_career_override(shallow_copy[random].display_name) then
			var_6_1 = random
		else
			table.remove(shallow_copy, random)
		end
	until var_6_1 or not table.is_empty(shallow_copy)

	return var_6_1
end

PlayerUtils.get_random_enabled_non_dlc_career_index_by_profile = function (arg_7_0)
	-- function 7
	local shallow_copy = table.shallow_copy(SPProfiles[arg_7_0].careers)

	table.shuffle(shallow_copy)

	for i = 1, #shallow_copy do
		local var_7_1 = shallow_copy[i]

		if not var_7_1.required_dlc then
			return (career_index_from_name(arg_7_0, var_7_1.name))
		end
	end
end

PlayerUtils.get_talent_overrides_by_career = function (arg_8_0)
	-- function 8
	local mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("override_career_talents")

	if not mechanism_setting_for_title then
		return
	end

	return mechanism_setting_for_title[arg_8_0]
end

PlayerUtils.broadphase_query = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	fassert(arg_9_2, "No result_table given to PlayerUtils.broadphase_query")

	local player_units_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

	return (Broadphase.query(player_units_broadphase, arg_9_0, arg_9_1, arg_9_2, arg_9_3))
end

PlayerUtils.peer_id_compare = function (arg_10_0, arg_10_1)
	-- function 10
	return arg_10_0 <= arg_10_1
end

PlayerUtils.player_name = function (arg_11_0, arg_11_1)
	-- function 11
	if not arg_11_0 then
		return "Peer #nil"
	end

	local var_11_0 = rawget(_G, "Steam")

	var_11_0 = var_11_0 or stingray.Steam

	local var_11_1

	if not IS_CONSOLE then
		if not arg_11_1:has_user_name(arg_11_0) then
			var_11_1 = arg_11_1:user_name(arg_11_0)
		end
	elseif not var_11_0 then
		var_11_1 = var_11_0.user_name(arg_11_0)
	end

	if not (not var_11_1 and var_11_1 ~= "") then
		var_11_1 = string.format("Peer #%s", string.sub(arg_11_0, -3))
	end

	return (string.gsub(var_11_1, "{#", "{​#"))
end
