-- chunkname: @scripts/managers/achievements/platform_xb1.lua

local PROGRESS_TASK_IDLE = Achievements2017.PROGRESS_TASK_IDLE
local PROGRESS_TASK_STARTED = Achievements2017.PROGRESS_TASK_STARTED
local PROGRESS_TASK_COMPLETED = Achievements2017.PROGRESS_TASK_COMPLETED
local PROGRESS_TASK_FAILED = Achievements2017.PROGRESS_TASK_FAILED

local function fn()
	-- function 1
	rawset(_G, "XB1Achievements", Achievements2017(Managers.account:user_id()))

	if not Managers.account:is_online() then
		Achievements2017.refresh(XB1Achievements)
	end
end

local function fn_2(self, arg_2_1)
	-- function 2
	if not rawget(_G, "XB1Achievements") then
		return
	end

	local account = Managers.account

	if not account:user_detached() then
		return
	end

	if not (Achievements2017.is_refreshing(XB1Achievements) or Achievements2017.progress_task_status(XB1Achievements) ~= PROGRESS_TASK_STARTED) then
		return
	end

	local flag = not account:offline_mode()
	local id = self.id
	local ID_XB1 = self.ID_XB1
	local var_2_4

	if not flag then
		var_2_4 = Achievements2017.progress(XB1Achievements, ID_XB1)
	else
		var_2_4 = account:offline_achievement_progress(id)

		if not var_2_4 then
			print("[AchievementManager] [Offline] No current progress, setting", id, arg_2_1)
			account:set_offline_achievement_progress(id, arg_2_1)

			return
		end
	end

	if var_2_4 == -1 then
		account:set_achievement_unlocked(id)

		return false, string.format("[AchievementManager] Error when fetching current progress for achievement %q", id)
	end

	if var_2_4 == 100 then
		account:set_achievement_unlocked(id)

		return
	end

	if not (not var_2_4 and not (arg_2_1 <= var_2_4)) then
		return
	end

	local var_2_5

	if not flag then
		var_2_5 = Achievements2017.set_progress(XB1Achievements, ID_XB1, arg_2_1)
	else
		print("[AchievementManager] [Offline] Setting progress", id, var_2_4, "->", arg_2_1)

		var_2_5 = Achievements2017.set_progress_offline(XB1Achievements, ID_XB1, arg_2_1)

		if not var_2_5 then
			print("[AchievementManager] [Offline] Updating current progress", id, arg_2_1)
			account:set_offline_achievement_progress(id, arg_2_1)
		end
	end

	if not var_2_5 then
		account:set_achievement_unlocked(id)

		return false, var_2_5
	end

	local flag_2 = arg_2_1 == 100

	return true, nil, flag_2
end

return {
	init = function (self)
		-- function 3
		self.init_state = "not_initialized"

		if not Managers.account:user_detached() then
			fn()

			self.init_state = "started"
		end

		self._unlocked_achievements = Managers.account:get_unlocked_achievement_list()
	end,
	update = function (self)
		-- function 4
		if self.init_state == "not_initialized" then
			if not Managers.account:user_detached() then
				fn()

				self.init_state = "started"
			end

			return true
		end

		if self.init_state == "started" then
			if not Achievements2017.is_refreshing(XB1Achievements) then
				self.init_state = "complete"
			end

			return true
		end
	end,
	check_version_number = function ()
		-- function 5
		return true
	end,
	version_result = function (arg_6_0)
		-- function 6
		return true
	end,
	is_unlocked = function (self)
		-- function 7
		return not self.ID_XB1
	end,
	is_platform_achievement = function (self)
		-- function 8
		return self.ID_XB1
	end,
	verify_platform_unlocked = function (self)
		-- function 9
		if not rawget(_G, "XB1Achievements") then
			return
		end

		if not Managers.account:user_detached() then
			return
		end

		if not (Achievements2017.is_refreshing(XB1Achievements) or Achievements2017.progress_task_status(XB1Achievements) ~= PROGRESS_TASK_STARTED) then
			return
		end

		local account = Managers.account
		local flag = not account:offline_mode()
		local ID_XB1 = self.ID_XB1
		local id = self.id
		local name = self.name
		local num = 100

		printf("[Achievements2017] Verifying - Name: %q. Template: %q. ID: %q", Localize(name), id, ID_XB1)

		local var_9_6

		if not flag then
			var_9_6 = Achievements2017.progress(XB1Achievements, ID_XB1)
		else
			var_9_6 = account:offline_achievement_progress(id)
		end

		local flag_2 = true
		local flag_3 = false

		if not (not var_9_6 and var_9_6 ~= -1) then
			printf("   - #### Error: Couldn't get progress for achievement %q - Removing it from evaluation", id)
			account:set_achievement_unlocked(id)

			return flag_2, flag_3
		end

		if var_9_6 < num then
			local printf = printf
			local str = "[Achievements2017] [%s] - Unlocking Name: %q. Template: %q. ID: %q"
			local flag_4

			flag_4 = not flag and "ONLINE" and "OFFLINE"

			printf(str, flag_4, Localize(name), id, ID_XB1)

			local var_9_12

			if not flag then
				var_9_12 = Achievements2017.set_progress(XB1Achievements, ID_XB1, num)
			else
				var_9_12 = Achievements2017.set_progress_offline(XB1Achievements, ID_XB1, var_9_6)

				if not var_9_12 then
					account:set_offline_achievement_progress(id, var_9_6)
				end
			end

			if not var_9_12 then
				printf("[Achievements2017] #### Error: %s", var_9_12)
				account:set_achievement_unlocked(id)
			else
				flag_3 = true
			end
		else
			print("[Achievements2017] - Already Unlocked")
		end

		return flag_2, flag_3
	end,
	set_progress = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		if arg_10_1 > 0 then
			local num = arg_10_1 / arg_10_2 * 100
			local floor = math.floor(num + 0.5)

			return fn_2(arg_10_0, floor)
		end
	end,
	unlock = function (arg_11_0)
		-- function 11
		return fn_2(arg_11_0, 100)
	end,
	unlock_result = function (arg_12_0, arg_12_1)
		-- function 12
		local progress_task_status = Achievements2017.progress_task_status(XB1Achievements)

		if progress_task_status == PROGRESS_TASK_STARTED then
			return false
		elseif progress_task_status == PROGRESS_TASK_COMPLETED then
			if not Managers.account:is_online() then
				Achievements2017.refresh(XB1Achievements)
			end

			return true
		elseif progress_task_status == PROGRESS_TASK_FAILED then
			print("[AchievementManager] PROGRESS_TASK_FAILED", arg_12_1)
			Managers.account:set_achievement_unlocked(arg_12_1)

			return true, "error"
		end
	end,
	reset = function ()
		-- function 13
		errorf("Tried to reset Achievements, not implemented!")
	end
}
