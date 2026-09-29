-- chunkname: @scripts/entity_system/systems/tutorial/tutorial_condition_evaluator.lua

TutorialConditions = not not TutorialConditions

TutorialConditions.player = function (ctx)
	-- function 1
	return Managers.player:local_player()
end

TutorialConditions.hero_name = function (ctx)
	-- function 2
	local player = ctx:get("player")
	local hero_name = player:profile_display_name()

	if hero_name then
		return hero_name
	end

	local wanted_profile_index = not not Managers.matchmaking.selected_profile_index

	hero_name = SPProfiles[wanted_profile_index].display_name

	return hero_name
end

TutorialConditions.career_name = function (ctx)
	-- function 3
	local player = ctx:get("player")

	return player:career_name()
end

TutorialConditions.player_level = function (ctx)
	-- function 4
	local hero_name = ctx:get("hero_name")
	local experience = ExperienceSettings.get_experience(hero_name)

	return ExperienceSettings.get_level(experience)
end

TutorialConditions.has_max_level_character = function (ctx)
	-- function 5
	return ExperienceSettings.get_highest_character_level() == ExperienceSettings.max_level
end

TutorialConditions.has_unlocked_non_dlc_career_for_current_hero = function (ctx)
	-- function 6
	local player = ctx:get("player")
	local player_level = ctx:get("player_level")
	local career_name = ctx:get("career_name")
	local profile_index = player:profile_index()
	local profile = SPProfiles[profile_index]
	local careers = not not profile and not not profile.careers

	for _, career in pairs(careers) do
		if career.name ~= career_name and not career.required_dlc then
			local career_unlocked = career:is_unlocked_function(profile.display_name, player_level)

			if career_unlocked then
				return true
			end
		end
	end

	return false
end

TutorialConditions.num_spent_talent_points = function (ctx)
	-- function 7
	local career_name = ctx:get("career_name")
	local talent_interface = Managers.backend:get_interface("talents")
	local current_talents = talent_interface:get_talents(career_name)
	local num_spent_talents = 0

	if current_talents then
		for i = 1, #current_talents do
			if current_talents[i] > 0 then
				num_spent_talents = num_spent_talents + 1
			end
		end
	end

	return num_spent_talents
end

TutorialConditions.num_unlocked_talent_points = function (ctx)
	-- function 8
	local player_level = ctx:get("player_level")
	local unlocked_talents_points = 0

	for template_name in pairs(TalentUnlockLevels) do
		if ProgressionUnlocks.is_unlocked(template_name, player_level) then
			unlocked_talents_points = unlocked_talents_points + 1
		end
	end

	return unlocked_talents_points
end

TutorialConditions.has_unspent_talent_points = function (ctx)
	-- function 9
	local num_unlocked_talent_points = ctx:get("num_unlocked_talent_points")
	local num_spent_talent_points = ctx:get("num_spent_talent_points")

	return num_spent_talent_points < num_unlocked_talent_points
end

TutorialConditions.has_unopened_chests = function (ctx)
	-- function 10
	return ItemHelper.has_new_backend_ids_by_slot_type("loot_chest")
end

TutorialConditions.has_new_cosmetics = function (ctx)
	-- function 11
	local career_name = ctx:get("career_name")

	if ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(career_name, "skin") then
		return true
	elseif ItemHelper.has_new_backend_ids_by_slot_type("frame") then
		return true
	elseif ItemHelper.has_new_backend_ids_by_career_name_and_slot_type(career_name, "hat") then
		return true
	end

	return false
end

TutorialConditions.best_acquired_power_level = function (ctx)
	-- function 12
	local player = ctx:get("player")
	local best_aquired_power_level = player:best_aquired_power_level()

	return best_aquired_power_level
end

local function is_difficulty_unlocked(ctx, difficulty_key)
	-- function 13
	local difficulty_settings = DifficultySettings[difficulty_key]
	local best_acquired_power_level = ctx:get("best_acquired_power_level")
	local required_power_level = difficulty_settings.required_power_level

	if best_acquired_power_level < required_power_level then
		return false
	end

	local extra_requirement_name = difficulty_settings.extra_requirement_name

	if extra_requirement_name then
		local extra_requirement_data = ExtraDifficultyRequirements[extra_requirement_name]

		if not extra_requirement_data.requirement_function() then
			return false
		end
	end

	local dlc_requirement = difficulty_settings.dlc_requirement

	if dlc_requirement and not Managers.unlock:is_dlc_unlocked(dlc_requirement) then
		return false
	end

	return true
end

TutorialConditions.harder_unlocked = function (ctx)
	-- function 14
	return is_difficulty_unlocked(ctx, "harder")
end

TutorialConditions.hardest_unlocked = function (ctx)
	-- function 15
	return is_difficulty_unlocked(ctx, "hardest")
end

TutorialConditions.cataclysm_unlocked = function (ctx)
	-- function 16
	return is_difficulty_unlocked(ctx, "cataclysm")
end

TutorialConditions.current_mechanism_name = function (ctx)
	-- function 17
	return Managers.mechanism:current_mechanism_name()
end

TutorialConditions.is_versus_mechanism = function (ctx)
	-- function 18
	return ctx:get("current_mechanism_name") == "versus"
end

TutorialConditions.is_adventure_mechanism = function (ctx)
	-- function 19
	return ctx:get("current_mechanism_name") == "adventure"
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

TutorialConditionEvaluator.get = function (self, key)
	-- function 22
	local value = self._values[key]

	if value ~= nil then
		return value
	end

	local eval_func = TutorialConditions[key]

	value = not not eval_func(self) or not not false
	self._values[key] = value

	return value
end
