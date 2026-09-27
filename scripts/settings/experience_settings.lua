-- chunkname: @scripts/settings/experience_settings.lua

local tbl = {
	0,
	200,
	400,
	600,
	650,
	700,
	750,
	800,
	850,
	900,
	1000,
	1100,
	1200,
	1300,
	1400,
	1500,
	1600,
	1700,
	1800,
	1900,
	2000,
	2100,
	2200,
	2300,
	2400,
	2500,
	2600,
	2700,
	2800,
	2900,
	3000,
	3100,
	3200,
	3300,
	3400
}
local num = 30
local count = #tbl
local var_0_3 = tbl[num]
local num_2 = 0

for i = 1, count do
	num_2 = num_2 + tbl[i]
end

local num_3 = 0

for j = 1, math.min(#tbl, num) do
	num_3 = num_3 + tbl[j]
end

local ExperienceSettings = ExperienceSettings

ExperienceSettings = ExperienceSettings or {}
ExperienceSettings = ExperienceSettings

ExperienceSettings.get_player_level = function (self)
	-- function 1
	local game = Managers.state.network:game()

	if not game then
		return nil
	end

	local unit_storage = Managers.state.unit_storage
	local player_unit = self.player_unit
	local go_id = unit_storage:go_id(player_unit)

	if not go_id then
		return nil
	end

	return (GameSession.game_object_field(game, go_id, "level"))
end

ExperienceSettings.get_highest_hero_level = function ()
	-- function 2
	local var_2_0
	local num = 0

	for i = 1, 5 do
		local var_2_2 = SPProfiles[i]
		local get_experience = ExperienceSettings.get_experience(var_2_2.display_name)

		if num < get_experience then
			var_2_0 = var_2_2
			num = get_experience
		end
	end

	return ExperienceSettings.get_level(num), num, var_2_0
end

ExperienceSettings.get_reward_level = function ()
	-- function 3
	local num = 0
	local num_2 = 0

	for i = 1, 5 do
		local var_3_2 = SPProfiles[i]
		local get_experience = ExperienceSettings.get_experience(var_3_2.display_name)

		if num <= get_experience then
			num = math.min(get_experience, num_3)
			num_2 = num_2 + math.max(0, get_experience - num_3)
		end

		num_2 = num_2 + ExperienceSettings.get_experience_pool(var_3_2.display_name)
	end

	local get_level, var_3_5, var_3_6, var_3_7 = ExperienceSettings.get_level(num + num_2)

	return get_level + var_3_7
end

ExperienceSettings.get_experience = function (arg_4_0)
	-- function 4
	local get = Managers.backend:get_interface("hero_attributes"):get(arg_4_0, "experience")

	get = get or 0

	return get
end

ExperienceSettings.get_experience_pool = function (arg_5_0)
	-- function 5
	local get = Managers.backend:get_interface("hero_attributes"):get(arg_5_0, "experience_pool")

	get = get or 0

	return get
end

ExperienceSettings.get_level = function (arg_6_0)
	-- function 6
	arg_6_0 = arg_6_0 or 0

	assert(arg_6_0 >= 0, "Negative XP!??")

	local num = 0
	local num_3 = 0
	local num_4 = 0
	local num_5 = 0
	local num_6 = 0

	if arg_6_0 >= num_2 then
		num_3 = count
		num_5 = 0
		num_6 = 0
		num_4 = ExperienceSettings.get_extra_level(arg_6_0 - num_2)
	else
		local var_6_5

		for i = 1, count do
			local var_6_6 = num

			num = num + tbl[i]

			if arg_6_0 < num then
				num_3 = i - 1
				num_6 = arg_6_0 - var_6_6
				num_5 = num_6 / tbl[i]

				break
			end
		end
	end

	return num_3, num_5, num_6, num_4
end

ExperienceSettings.get_extra_level = function (arg_7_0)
	-- function 7
	local floor = math.floor(arg_7_0 / var_0_3)
	local num = arg_7_0 % var_0_3 / var_0_3

	return floor, num
end

ExperienceSettings.get_total_experience_required_for_level = function (arg_8_0)
	-- function 8
	local num = 0

	for i = 1, arg_8_0 do
		local var_8_1 = tbl[i]

		var_8_1 = var_8_1 or var_0_3
		num = num + var_8_1
	end

	return num
end

ExperienceSettings.get_experience_required_for_level = function (arg_9_0)
	-- function 9
	local var_9_0 = tbl[arg_9_0]

	var_9_0 = var_9_0 or var_0_3

	return var_9_0
end

ExperienceSettings.get_highest_character_level = function ()
	-- function 10
	local num = 0

	for i, v in ipairs(ProfilePriority) do
		local display_name = SPProfiles[v].display_name
		local get_experience = ExperienceSettings.get_experience(display_name)
		local get_level = ExperienceSettings.get_level(get_experience)

		if num < get_level then
			num = get_level
		end
	end

	return num
end

ExperienceSettings.get_character_level = function (arg_11_0)
	-- function 11
	local get = Managers.backend:get_interface("hero_attributes"):get(arg_11_0, "experience")

	get = get or 0

	return ExperienceSettings.get_level(get)
end

local tbl_2 = {
	[20] = 0.1,
	[10] = 0.05
}

ExperienceSettings.hero_commendation_experience_multiplier = function ()
	-- function 12
	local num = 1

	for i = 1, 5 do
		local var_12_1 = SPProfiles[i]
		local get_character_level = ExperienceSettings.get_character_level(var_12_1.display_name)

		for k, v in pairs(tbl_2) do
			if k < get_character_level then
				num = num + v
			end
		end
	end

	return num
end

ExperienceSettings.max_experience = num_2
ExperienceSettings.max_level = count
ExperienceSettings.multiplier = 1
ExperienceSettings.level_length_experience_multiplier = {
	short = 1,
	long = 1
}
