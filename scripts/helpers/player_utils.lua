-- chunkname: @scripts/helpers/player_utils.lua

PlayerUtils = {}

function PlayerUtils.unique_player_id(arg_1_0, arg_1_1)
	return arg_1_0 .. ":" .. arg_1_1
end

function PlayerUtils.split_unique_player_id(arg_2_0)
	local var_2_0, var_2_1 = string.match(arg_2_0, "^([^:]+):(.*)$")

	return var_2_0, tonumber(var_2_1)
end

function PlayerUtils.get_random_alive_hero()
	local var_3_0 = (Managers.state.side:get_side_from_name("heroes") or Managers.state.side:sides()[1]).PLAYER_AND_BOT_UNITS
	local var_3_1 = {}
	local var_3_2 = 0

	for iter_3_0 = 1, #var_3_0 do
		local var_3_3 = var_3_0[iter_3_0]

		if HEALTH_ALIVE[var_3_3] then
			var_3_2 = var_3_2 + 1
			var_3_1[var_3_2] = var_3_3
		end
	end

	if var_3_2 > 0 then
		return var_3_1[math.random(1, var_3_2)]
	end

	return nil
end

function PlayerUtils.get_career_override(arg_4_0)
	local var_4_0 = Managers.mechanism:mechanism_setting_for_title("override_career_availability")

	if not var_4_0 then
		return true
	end

	local var_4_1 = var_4_0[arg_4_0]

	if var_4_1 ~= nil then
		return var_4_1
	end

	return true
end

function PlayerUtils.get_enabled_career_index_by_profile(arg_5_0)
	local var_5_0 = SPProfiles[arg_5_0].careers

	for iter_5_0 = 1, #var_5_0 do
		if PlayerUtils.get_career_override(var_5_0[iter_5_0].display_name) then
			return iter_5_0
		end
	end
end

function PlayerUtils.get_random_enabled_career_index_by_profile(arg_6_0)
	local var_6_0 = table.shallow_copy(SPProfiles[arg_6_0].careers)
	local var_6_1

	repeat
		local var_6_2 = math.random(1, #var_6_0)

		if PlayerUtils.get_career_override(var_6_0[var_6_2].display_name) then
			var_6_1 = var_6_2
		else
			table.remove(var_6_0, var_6_2)
		end
	until var_6_1 or table.is_empty(var_6_0)

	return var_6_1
end

function PlayerUtils.get_random_enabled_non_dlc_career_index_by_profile(arg_7_0)
	local var_7_0 = table.shallow_copy(SPProfiles[arg_7_0].careers)

	table.shuffle(var_7_0)

	for iter_7_0 = 1, #var_7_0 do
		local var_7_1 = var_7_0[iter_7_0]

		if not var_7_1.required_dlc then
			return (career_index_from_name(arg_7_0, var_7_1.name))
		end
	end
end

function PlayerUtils.get_talent_overrides_by_career(arg_8_0)
	local var_8_0 = Managers.mechanism:mechanism_setting_for_title("override_career_talents")

	if not var_8_0 then
		return
	end

	return var_8_0[arg_8_0]
end

function PlayerUtils.broadphase_query(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	fassert(arg_9_2, "No result_table given to PlayerUtils.broadphase_query")

	local var_9_0 = Managers.state.entity:system("proximity_system").player_units_broadphase

	return (Broadphase.query(var_9_0, arg_9_0, arg_9_1, arg_9_2, arg_9_3))
end

function PlayerUtils.peer_id_compare(arg_10_0, arg_10_1)
	return arg_10_0 <= arg_10_1
end

function PlayerUtils.player_name(arg_11_0, arg_11_1)
	if not arg_11_0 then
		return "Peer #nil"
	end

	local var_11_0 = rawget(_G, "Steam") or stingray.Steam
	local var_11_1

	if IS_CONSOLE then
		if arg_11_1:has_user_name(arg_11_0) then
			var_11_1 = arg_11_1:user_name(arg_11_0)
		end
	elseif var_11_0 then
		var_11_1 = var_11_0.user_name(arg_11_0)
	end

	if not var_11_1 or var_11_1 == "" then
		var_11_1 = string.format("Peer #%s", string.sub(arg_11_0, -3))
	end

	return (string.gsub(var_11_1, "{#", "{​#"))
end
