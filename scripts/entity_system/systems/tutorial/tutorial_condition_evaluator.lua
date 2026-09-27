-- chunkname: @scripts/entity_system/systems/tutorial/tutorial_condition_evaluator.lua

local TutorialConditions = TutorialConditions

TutorialConditions = TutorialConditions or {}
TutorialConditions = TutorialConditions

TutorialConditions.player = function (arg_1_0)
	-- function 1
	return Managers.player:local_player()
end

TutorialConditions.hero_name = function (self)
	-- function 2
	local profile_display_name = self:get("player"):profile_display_name()

	if not profile_display_name then
		return profile_display_name
	end

	local selected_profile_index = Managers.matchmaking.selected_profile_index

	if not selected_profile_index then
		selected_profile_index = SaveData.wanted_profile_index
		selected_profile_index = selected_profile_index or 1
	end

	return SPProfiles[selected_profile_index].display_name
end

TutorialConditions.career_name = function (self)
	-- function 3
	return self:get("player"):career_name()
end

TutorialConditions.player_level = function (self)
	-- function 4
	local get = self:get("hero_name")
	local get_experience = ExperienceSettings.get_experience(get)

	return ExperienceSettings.get_level(get_experience)
end

TutorialConditions.has_max_level_character = function (arg_5_0)
	-- function 5
	return ExperienceSettings.get_highest_character_level() == ExperienceSettings.max_level
end

TutorialConditions.has_unlocked_non_dlc_career_for_current_hero = function (self)
	-- function 6
	local get = self:get("player")
	local get_2 = self:get("player_level")
	local get_3 = self:get("career_name")
	local profile_index = get:profile_index()
	local var_6_4 = SPProfiles[profile_index]
	local flag = not var_6_4 and var_6_4.careers

	for k, v in pairs(flag) do
		if v.name == get_3 or v.required_dlc or not v:is_unlocked_function(var_6_4.display_name, get_2) then
			return true
		end
	end

	return false
end

TutorialConditions.num_spent_talent_points = function (self)
	-- function 7
	local get = self:get("career_name")
	local get_talents = Managers.backend:get_interface("talents"):get_talents(get)
	local num = 0

	if not get_talents then
		for i = 1, #get_talents do
			if get_talents[i] > 0 then
				num = num + 1
			end
		end
	end

	return num
end

TutorialConditions.num_unlocked_talent_points = function (self)
	-- function 8
	local get = self:get("player_level")
	local num = 0

	for k in pairs(TalentUnlockLevels) do
		if not ProgressionUnlocks.is_unlocked(k, get) then
			num = num + 1
		end
	end

	return num
end

TutorialConditions.has_unspent_talent_points = function (self)
	-- function 9
	return self:get("num_unlocked_talent_points") > self:get("num_spent_talent_points")
end

TutorialConditions.has_unopened_chests = function (arg_10_0)
	-- function 10
	return ItemHelper.has_new_backend_ids_by_slot_type("loot_chest")
end

TutorialConditions.has_new_cosmetics = function (self)
	-- function 11
	local get = self:get("career_name")

	if not ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(get, "skin") then
		return true
	elseif not ItemHelper.has_new_backend_ids_by_slot_type("frame") then
		return true
	elseif not ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(get, "hat") then
		return true
	end

	return false
end

TutorialConditions.best_acquired_power_level = function (self)
	-- function 12
	return (self:get("player"):best_aquired_power_level())
end

local function fn(self, arg_13_1)
	-- function 13
	local var_13_0 = DifficultySettings[arg_13_1]

	if self:get("best_acquired_power_level") < var_13_0.required_power_level then
		return false
	end

	local extra_requirement_name = var_13_0.extra_requirement_name

	if not (not extra_requirement_name and ExtraDifficultyRequirements[extra_requirement_name].requirement_function()) then
		return false
	end

	local dlc_requirement = var_13_0.dlc_requirement

	if not (not dlc_requirement and Managers.unlock:is_dlc_unlocked(dlc_requirement)) then
		return false
	end

	return true
end

TutorialConditions.harder_unlocked = function (arg_14_0)
	-- function 14
	return fn(arg_14_0, "harder")
end

TutorialConditions.hardest_unlocked = function (arg_15_0)
	-- function 15
	return fn(arg_15_0, "hardest")
end

TutorialConditions.cataclysm_unlocked = function (arg_16_0)
	-- function 16
	return fn(arg_16_0, "cataclysm")
end

TutorialConditions.current_mechanism_name = function (arg_17_0)
	-- function 17
	return Managers.mechanism:current_mechanism_name()
end

TutorialConditions.is_versus_mechanism = function (self)
	-- function 18
	return self:get("current_mechanism_name") == "versus"
end

TutorialConditions.is_adventure_mechanism = function (self)
	-- function 19
	return self:get("current_mechanism_name") == "adventure"
end

TutorialConditionEvaluator = class(TutorialConditionEvaluator)

TutorialConditionEvaluator.init = function (self)
	-- function 20
	self._values = {}
end

TutorialConditionEvaluator.clear_cache = function (self)
	-- function 21
	table.clear(self._values)
end

TutorialConditionEvaluator.get = function (self, arg_22_1)
	-- function 22
	local var_22_0 = self._values[arg_22_1]

	if var_22_0 ~= nil then
		return var_22_0
	end

	local flag = TutorialConditions[arg_22_1](self) or false

	self._values[arg_22_1] = flag

	return flag
end
