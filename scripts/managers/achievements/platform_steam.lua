-- chunkname: @scripts/managers/achievements/platform_steam.lua

return {
	init = function (arg_1_0)
		-- function 1
		return
	end,
	check_version_number = function ()
		-- function 2
		return true
	end,
	version_result = function (arg_3_0)
		-- function 3
		local progress = Stats.progress(arg_3_0)

		if not progress.done then
			return true, progress.error
		end
	end,
	is_unlocked = function (self)
		-- function 4
		assert(self.ID_STEAM, "[AchievementManager] There is no Achievement ID specified for achievement: " .. self.id)

		local unlocked, var_4_1 = Achievement.unlocked(self.ID_STEAM)

		return unlocked, var_4_1
	end,
	is_platform_achievement = function (self)
		-- function 5
		return self.ID_STEAM
	end,
	verify_platform_unlocked = function (self)
		-- function 6
		assert(self.ID_STEAM, "[AchievementManager] There is no Achievement ID specified for achievement: " .. self.id)

		local flag = true
		local name = self.name
		local id = self.id
		local ID_STEAM = self.ID_STEAM

		printf("[AchievementManager] Verifying - Name: %q. Template: %q. ID: %q", Localize(name), id, ID_STEAM)

		local unlock, var_6_5 = Achievement.unlock(ID_STEAM)

		if not var_6_5 then
			printf("[AchievementManager] #### Error: %s", var_6_5)
		end

		return flag, unlock
	end,
	unlock = function (self)
		-- function 7
		assert(self.ID_STEAM, "[AchievementManager] There is no Achievement ID specified for achievement: " .. self.id)

		local unlock, var_7_1 = Achievement.unlock(self.ID_STEAM)

		return unlock, var_7_1
	end,
	unlock_result = function (arg_8_0)
		-- function 8
		local progress = Achievement.progress(arg_8_0)

		if not progress.done then
			return true, progress.error
		end
	end,
	reset = function ()
		-- function 9
		Achievement.reset()
	end
}
