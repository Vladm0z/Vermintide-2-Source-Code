-- chunkname: @scripts/settings/experience_settings.lua

local var_0_0 = {
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
local var_0_1 = 30
local var_0_2 = #var_0_0
local var_0_3 = var_0_0[var_0_1]
local var_0_4 = 0

for iter_0_0 = 1, var_0_2 do
	var_0_4 = var_0_4 + var_0_0[iter_0_0]
end

local var_0_5 = 0

for iter_0_1 = 1, math.min(#var_0_0, var_0_1) do
	var_0_5 = var_0_5 + var_0_0[iter_0_1]
end

ExperienceSettings = ExperienceSettings or {}

ExperienceSettings.get_player_level = function (arg_1_0)
	local var_1_0 = Managers.state.network:game()

	if not var_1_0 then
		return nil
	end

	local var_1_1 = Managers.state.unit_storage
	local var_1_2 = arg_1_0.player_unit
	local var_1_3 = var_1_1:go_id(var_1_2)

	if not var_1_3 then
		return nil
	end

	return (GameSession.game_object_field(var_1_0, var_1_3, "level"))
end

ExperienceSettings.get_highest_hero_level = function ()
	local var_2_0
	local var_2_1 = 0

	for iter_2_0 = 1, 5 do
		local var_2_2 = SPProfiles[iter_2_0]
		local var_2_3 = ExperienceSettings.get_experience(var_2_2.display_name)

		if var_2_1 < var_2_3 then
			var_2_0 = var_2_2
			var_2_1 = var_2_3
		end
	end

	return ExperienceSettings.get_level(var_2_1), var_2_1, var_2_0
end

ExperienceSettings.get_reward_level = function ()
	local var_3_0 = 0
	local var_3_1 = 0

	for iter_3_0 = 1, 5 do
		local var_3_2 = SPProfiles[iter_3_0]
		local var_3_3 = ExperienceSettings.get_experience(var_3_2.display_name)

		if var_3_0 <= var_3_3 then
			var_3_0 = math.min(var_3_3, var_0_5)
			var_3_1 = var_3_1 + math.max(0, var_3_3 - var_0_5)
		end

		var_3_1 = var_3_1 + ExperienceSettings.get_experience_pool(var_3_2.display_name)
	end

	local var_3_4, var_3_5, var_3_6, var_3_7 = ExperienceSettings.get_level(var_3_0 + var_3_1)

	return var_3_4 + var_3_7
end

ExperienceSettings.get_experience = function (arg_4_0)
	return Managers.backend:get_interface("hero_attributes"):get(arg_4_0, "experience") or 0
end

ExperienceSettings.get_experience_pool = function (arg_5_0)
	return Managers.backend:get_interface("hero_attributes"):get(arg_5_0, "experience_pool") or 0
end

ExperienceSettings.get_level = function (arg_6_0)
	arg_6_0 = arg_6_0 or 0

	assert(arg_6_0 >= 0, "Negative XP!??")

	local var_6_0 = 0
	local var_6_1 = 0
	local var_6_2 = 0
	local var_6_3 = 0
	local var_6_4 = 0

	if arg_6_0 >= var_0_4 then
		var_6_1 = var_0_2
		var_6_3 = 0
		var_6_4 = 0
		var_6_2 = ExperienceSettings.get_extra_level(arg_6_0 - var_0_4)
	else
		local var_6_5

		for iter_6_0 = 1, var_0_2 do
			local var_6_6 = var_6_0

			var_6_0 = var_6_0 + var_0_0[iter_6_0]

			if arg_6_0 < var_6_0 then
				var_6_1 = iter_6_0 - 1
				var_6_4 = arg_6_0 - var_6_6
				var_6_3 = var_6_4 / var_0_0[iter_6_0]

				break
			end
		end
	end

	return var_6_1, var_6_3, var_6_4, var_6_2
end

ExperienceSettings.get_extra_level = function (arg_7_0)
	local var_7_0 = math.floor(arg_7_0 / var_0_3)
	local var_7_1 = arg_7_0 % var_0_3 / var_0_3

	return var_7_0, var_7_1
end

ExperienceSettings.get_total_experience_required_for_level = function (arg_8_0)
	local var_8_0 = 0

	for iter_8_0 = 1, arg_8_0 do
		var_8_0 = var_8_0 + (var_0_0[iter_8_0] or var_0_3)
	end

	return var_8_0
end

ExperienceSettings.get_experience_required_for_level = function (arg_9_0)
	return var_0_0[arg_9_0] or var_0_3
end

ExperienceSettings.get_highest_character_level = function ()
	local var_10_0 = 0

	for iter_10_0, iter_10_1 in ipairs(ProfilePriority) do
		local var_10_1 = SPProfiles[iter_10_1].display_name
		local var_10_2 = ExperienceSettings.get_experience(var_10_1)
		local var_10_3 = ExperienceSettings.get_level(var_10_2)

		if var_10_0 < var_10_3 then
			var_10_0 = var_10_3
		end
	end

	return var_10_0
end

ExperienceSettings.get_character_level = function (arg_11_0)
	local var_11_0 = Managers.backend:get_interface("hero_attributes"):get(arg_11_0, "experience") or 0

	return ExperienceSettings.get_level(var_11_0)
end

local var_0_6 = {
	[20] = 0.1,
	[10] = 0.05
}

ExperienceSettings.hero_commendation_experience_multiplier = function ()
	local var_12_0 = 1

	for iter_12_0 = 1, 5 do
		local var_12_1 = SPProfiles[iter_12_0]
		local var_12_2 = ExperienceSettings.get_character_level(var_12_1.display_name)

		for iter_12_1, iter_12_2 in pairs(var_0_6) do
			if iter_12_1 < var_12_2 then
				var_12_0 = var_12_0 + iter_12_2
			end
		end
	end

	return var_12_0
end

ExperienceSettings.max_experience = var_0_4
ExperienceSettings.max_level = var_0_2
ExperienceSettings.multiplier = 1
ExperienceSettings.level_length_experience_multiplier = {
	short = 1,
	long = 1
}
