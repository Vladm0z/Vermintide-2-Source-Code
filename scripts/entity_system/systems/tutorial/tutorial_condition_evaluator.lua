-- chunkname: @scripts/entity_system/systems/tutorial/tutorial_condition_evaluator.lua

TutorialConditions = TutorialConditions or {}

TutorialConditions.player = function (arg_1_0)
	return Managers.player:local_player()
end

TutorialConditions.hero_name = function (arg_2_0)
	local var_2_0 = arg_2_0:get("player"):profile_display_name()

	if var_2_0 then
		return var_2_0
	end

	local var_2_1 = Managers.matchmaking.selected_profile_index or SaveData.wanted_profile_index or 1

	return SPProfiles[var_2_1].display_name
end

TutorialConditions.career_name = function (arg_3_0)
	return arg_3_0:get("player"):career_name()
end

TutorialConditions.player_level = function (arg_4_0)
	local var_4_0 = arg_4_0:get("hero_name")
	local var_4_1 = ExperienceSettings.get_experience(var_4_0)

	return ExperienceSettings.get_level(var_4_1)
end

TutorialConditions.has_max_level_character = function (arg_5_0)
	return ExperienceSettings.get_highest_character_level() == ExperienceSettings.max_level
end

TutorialConditions.has_unlocked_non_dlc_career_for_current_hero = function (arg_6_0)
	local var_6_0 = arg_6_0:get("player")
	local var_6_1 = arg_6_0:get("player_level")
	local var_6_2 = arg_6_0:get("career_name")
	local var_6_3 = var_6_0:profile_index()
	local var_6_4 = SPProfiles[var_6_3]
	local var_6_5 = var_6_4 and var_6_4.careers

	for iter_6_0, iter_6_1 in pairs(var_6_5) do
		if iter_6_1.name ~= var_6_2 and not iter_6_1.required_dlc and iter_6_1:is_unlocked_function(var_6_4.display_name, var_6_1) then
			return true
		end
	end

	return false
end

TutorialConditions.num_spent_talent_points = function (arg_7_0)
	local var_7_0 = arg_7_0:get("career_name")
	local var_7_1 = Managers.backend:get_interface("talents"):get_talents(var_7_0)
	local var_7_2 = 0

	if var_7_1 then
		for iter_7_0 = 1, #var_7_1 do
			if var_7_1[iter_7_0] > 0 then
				var_7_2 = var_7_2 + 1
			end
		end
	end

	return var_7_2
end

TutorialConditions.num_unlocked_talent_points = function (arg_8_0)
	local var_8_0 = arg_8_0:get("player_level")
	local var_8_1 = 0

	for iter_8_0 in pairs(TalentUnlockLevels) do
		if ProgressionUnlocks.is_unlocked(iter_8_0, var_8_0) then
			var_8_1 = var_8_1 + 1
		end
	end

	return var_8_1
end

TutorialConditions.has_unspent_talent_points = function (arg_9_0)
	return arg_9_0:get("num_unlocked_talent_points") > arg_9_0:get("num_spent_talent_points")
end

TutorialConditions.has_unopened_chests = function (arg_10_0)
	return ItemHelper.has_new_backend_ids_by_slot_type("loot_chest")
end

TutorialConditions.has_new_cosmetics = function (arg_11_0)
	local var_11_0 = arg_11_0:get("career_name")

	if ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(var_11_0, "skin") then
		return true
	elseif ItemHelper.has_new_backend_ids_by_slot_type("frame") then
		return true
	elseif ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(var_11_0, "hat") then
		return true
	end

	return false
end

TutorialConditions.best_acquired_power_level = function (arg_12_0)
	return (arg_12_0:get("player"):best_aquired_power_level())
end

local function var_0_0(arg_13_0, arg_13_1)
	local var_13_0 = DifficultySettings[arg_13_1]

	if arg_13_0:get("best_acquired_power_level") < var_13_0.required_power_level then
		return false
	end

	local var_13_1 = var_13_0.extra_requirement_name

	if var_13_1 and not ExtraDifficultyRequirements[var_13_1].requirement_function() then
		return false
	end

	local var_13_2 = var_13_0.dlc_requirement

	if var_13_2 and not Managers.unlock:is_dlc_unlocked(var_13_2) then
		return false
	end

	return true
end

TutorialConditions.harder_unlocked = function (arg_14_0)
	return var_0_0(arg_14_0, "harder")
end

TutorialConditions.hardest_unlocked = function (arg_15_0)
	return var_0_0(arg_15_0, "hardest")
end

TutorialConditions.cataclysm_unlocked = function (arg_16_0)
	return var_0_0(arg_16_0, "cataclysm")
end

TutorialConditions.current_mechanism_name = function (arg_17_0)
	return Managers.mechanism:current_mechanism_name()
end

TutorialConditions.is_versus_mechanism = function (arg_18_0)
	return arg_18_0:get("current_mechanism_name") == "versus"
end

TutorialConditions.is_adventure_mechanism = function (arg_19_0)
	return arg_19_0:get("current_mechanism_name") == "adventure"
end

TutorialConditionEvaluator = class(TutorialConditionEvaluator)

TutorialConditionEvaluator.init = function (arg_20_0)
	arg_20_0._values = {}
end

TutorialConditionEvaluator.clear_cache = function (arg_21_0)
	table.clear(arg_21_0._values)
end

TutorialConditionEvaluator.get = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._values[arg_22_1]

	if var_22_0 ~= nil then
		return var_22_0
	end

	local var_22_1 = TutorialConditions[arg_22_1](arg_22_0) or false

	arg_22_0._values[arg_22_1] = var_22_1

	return var_22_1
end
