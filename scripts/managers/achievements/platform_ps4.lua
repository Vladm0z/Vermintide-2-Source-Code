-- chunkname: @scripts/managers/achievements/platform_ps4.lua

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
		return true
	end,
	is_unlocked = function (self)
		-- function 4
		return not self.ID_PS4
	end,
	is_platform_achievement = function (self)
		-- function 5
		return self.ID_PS4
	end,
	verify_platform_unlocked = function (self)
		-- function 6
		local flag = true
		local name = self.name
		local id = self.id
		local ID_PS4 = self.ID_PS4

		printf("[Trophies] Verifying - Name: %q. Template: %q. ID: %q", Localize(name), id, ID_PS4)
		assert(self.ID_PS4, "[AchievementManager] There is no Trophy ID specified for achievement: " .. self.id)

		local unlock = Trophies.unlock(Managers.account:initial_user_id(), self.ID_PS4)

		return flag, unlock
	end,
	unlock = function (self)
		-- function 7
		assert(self.ID_PS4, "[Trophies] There is no Trophy ID specified for achievement: " .. self.id)

		return (Trophies.unlock(Managers.account:initial_user_id(), self.ID_PS4))
	end,
	unlock_result = function (arg_8_0, arg_8_1)
		-- function 8
		local status = Trophies.status(arg_8_0)

		if status == Trophies.STARTED then
			return false
		end

		Trophies.free(arg_8_0)

		if status == Trophies.COMPLETED then
			return true
		elseif status == Trophies.ERROR then
			printf("[Trophies] Failed unlocking trophy - %q", arg_8_1 or "Unknown")

			return true, "error"
		elseif status == Trophies.UNKNOWN then
			return true, "unknown"
		end
	end,
	reset = function ()
		-- function 9
		errorf("Tried to reset Trophies, not implemented!")
	end
}
