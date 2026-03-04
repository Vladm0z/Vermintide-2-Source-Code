-- chunkname: @scripts/managers/achievements/platform_ps4.lua

return {
	init = function (arg_1_0)
		return
	end,
	check_version_number = function ()
		return true
	end,
	version_result = function (arg_3_0)
		return true
	end,
	is_unlocked = function (arg_4_0)
		return not arg_4_0.ID_PS4
	end,
	is_platform_achievement = function (arg_5_0)
		return arg_5_0.ID_PS4
	end,
	verify_platform_unlocked = function (arg_6_0)
		local var_6_0 = true
		local var_6_1 = arg_6_0.name
		local var_6_2 = arg_6_0.id
		local var_6_3 = arg_6_0.ID_PS4

		printf("[Trophies] Verifying - Name: %q. Template: %q. ID: %q", Localize(var_6_1), var_6_2, var_6_3)
		assert(arg_6_0.ID_PS4, "[AchievementManager] There is no Trophy ID specified for achievement: " .. arg_6_0.id)

		local var_6_4 = Trophies.unlock(Managers.account:initial_user_id(), arg_6_0.ID_PS4)

		return var_6_0, var_6_4
	end,
	unlock = function (arg_7_0)
		assert(arg_7_0.ID_PS4, "[Trophies] There is no Trophy ID specified for achievement: " .. arg_7_0.id)

		return (Trophies.unlock(Managers.account:initial_user_id(), arg_7_0.ID_PS4))
	end,
	unlock_result = function (arg_8_0, arg_8_1)
		local var_8_0 = Trophies.status(arg_8_0)

		if var_8_0 == Trophies.STARTED then
			return false
		end

		Trophies.free(arg_8_0)

		if var_8_0 == Trophies.COMPLETED then
			return true
		elseif var_8_0 == Trophies.ERROR then
			printf("[Trophies] Failed unlocking trophy - %q", arg_8_1 or "Unknown")

			return true, "error"
		elseif var_8_0 == Trophies.UNKNOWN then
			return true, "unknown"
		end
	end,
	reset = function ()
		errorf("Tried to reset Trophies, not implemented!")
	end
}
