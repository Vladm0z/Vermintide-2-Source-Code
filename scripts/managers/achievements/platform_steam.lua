-- chunkname: @scripts/managers/achievements/platform_steam.lua

local platform_functions = {
	init = function (achievement_manager)
		-- function 1
		return
	end,
	check_version_number = function ()
		-- function 2
		return true
	end,
	version_result = function (token)
		-- function 3
		local result = Stats.progress(token)

		if result.done then
			return true, result.error
		end
	end,
	is_unlocked = function (template)
		-- function 4
		assert(template.ID_STEAM, "[AchievementManager] There is no Achievement ID specified for achievement: " .. template.id)

		local unlocked, error_msg = Achievement.unlocked(template.ID_STEAM)

		return unlocked, error_msg
	end,
	is_platform_achievement = function (template)
		-- function 5
		return template.ID_STEAM
	end,
	verify_platform_unlocked = function (template)
		-- function 6
		assert(template.ID_STEAM, "[AchievementManager] There is no Achievement ID specified for achievement: " .. template.id)

		local verified = true
		local name = template.name
		local template_id = template.id
		local achievement_id = template.ID_STEAM

		printf("[AchievementManager] Verifying - Name: %q. Template: %q. ID: %q", Localize(name), template_id, achievement_id)

		local token, error_msg = Achievement.unlock(achievement_id)

		if error_msg then
			printf("[AchievementManager] #### Error: %s", error_msg)
		end

		return verified, token
	end,
	unlock = function (template)
		-- function 7
		assert(template.ID_STEAM, "[AchievementManager] There is no Achievement ID specified for achievement: " .. template.id)

		local token, error_msg = Achievement.unlock(template.ID_STEAM)

		return token, error_msg
	end,
	unlock_result = function (token)
		-- function 8
		local result = Achievement.progress(token)

		if result.done then
			return true, result.error
		end
	end,
	reset = function ()
		-- function 9
		Achievement.reset()
	end
}

return platform_functions
