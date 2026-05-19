-- chunkname: @scripts/managers/achievements/platform_steam.lua

return {
	init = function(arg_1_0)
		return
	end,
	check_version_number = function()
		return true
	end,
	version_result = function(arg_3_0)
		local var_3_0 = Stats.progress(arg_3_0)

		if var_3_0.done then
			return true, var_3_0.error
		end
	end,
	is_unlocked = function(arg_4_0)
		assert(arg_4_0.ID_STEAM, "[AchievementManager] There is no Achievement ID specified for achievement: " .. arg_4_0.id)

		local var_4_0, var_4_1 = Achievement.unlocked(arg_4_0.ID_STEAM)

		return var_4_0, var_4_1
	end,
	is_platform_achievement = function(arg_5_0)
		return arg_5_0.ID_STEAM
	end,
	verify_platform_unlocked = function(arg_6_0)
		assert(arg_6_0.ID_STEAM, "[AchievementManager] There is no Achievement ID specified for achievement: " .. arg_6_0.id)

		local var_6_0 = true
		local var_6_1 = arg_6_0.name
		local var_6_2 = arg_6_0.id
		local var_6_3 = arg_6_0.ID_STEAM

		printf("[AchievementManager] Verifying - Name: %q. Template: %q. ID: %q", Localize(var_6_1), var_6_2, var_6_3)

		local var_6_4, var_6_5 = Achievement.unlock(var_6_3)

		if var_6_5 then
			printf("[AchievementManager] #### Error: %s", var_6_5)
		end

		return var_6_0, var_6_4
	end,
	unlock = function(arg_7_0)
		assert(arg_7_0.ID_STEAM, "[AchievementManager] There is no Achievement ID specified for achievement: " .. arg_7_0.id)

		local var_7_0, var_7_1 = Achievement.unlock(arg_7_0.ID_STEAM)

		return var_7_0, var_7_1
	end,
	unlock_result = function(arg_8_0)
		local var_8_0 = Achievement.progress(arg_8_0)

		if var_8_0.done then
			return true, var_8_0.error
		end
	end,
	reset = function()
		Achievement.reset()
	end
}
