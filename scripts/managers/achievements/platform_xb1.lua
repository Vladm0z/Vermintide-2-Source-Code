-- chunkname: @scripts/managers/achievements/platform_xb1.lua

local var_0_0 = Achievements2017.PROGRESS_TASK_IDLE
local var_0_1 = Achievements2017.PROGRESS_TASK_STARTED
local var_0_2 = Achievements2017.PROGRESS_TASK_COMPLETED
local var_0_3 = Achievements2017.PROGRESS_TASK_FAILED

local function var_0_4()
	rawset(_G, "XB1Achievements", Achievements2017(Managers.account:user_id()))

	if Managers.account:is_online() then
		Achievements2017.refresh(XB1Achievements)
	end
end

local function var_0_5(arg_2_0, arg_2_1)
	if not rawget(_G, "XB1Achievements") then
		return
	end

	local var_2_0 = Managers.account

	if var_2_0:user_detached() then
		return
	end

	if Achievements2017.is_refreshing(XB1Achievements) or Achievements2017.progress_task_status(XB1Achievements) == var_0_1 then
		return
	end

	local var_2_1 = not var_2_0:offline_mode()
	local var_2_2 = arg_2_0.id
	local var_2_3 = arg_2_0.ID_XB1
	local var_2_4

	if var_2_1 then
		var_2_4 = Achievements2017.progress(XB1Achievements, var_2_3)
	else
		var_2_4 = var_2_0:offline_achievement_progress(var_2_2)

		if not var_2_4 then
			print("[AchievementManager] [Offline] No current progress, setting", var_2_2, arg_2_1)
			var_2_0:set_offline_achievement_progress(var_2_2, arg_2_1)

			return
		end
	end

	if var_2_4 == -1 then
		var_2_0:set_achievement_unlocked(var_2_2)

		return false, string.format("[AchievementManager] Error when fetching current progress for achievement %q", var_2_2)
	end

	if var_2_4 == 100 then
		var_2_0:set_achievement_unlocked(var_2_2)

		return
	end

	if not var_2_4 or arg_2_1 <= var_2_4 then
		return
	end

	local var_2_5

	if var_2_1 then
		var_2_5 = Achievements2017.set_progress(XB1Achievements, var_2_3, arg_2_1)
	else
		print("[AchievementManager] [Offline] Setting progress", var_2_2, var_2_4, "->", arg_2_1)

		var_2_5 = Achievements2017.set_progress_offline(XB1Achievements, var_2_3, arg_2_1)

		if not var_2_5 then
			print("[AchievementManager] [Offline] Updating current progress", var_2_2, arg_2_1)
			var_2_0:set_offline_achievement_progress(var_2_2, arg_2_1)
		end
	end

	if var_2_5 then
		var_2_0:set_achievement_unlocked(var_2_2)

		return false, var_2_5
	end

	local var_2_6 = arg_2_1 == 100

	return true, nil, var_2_6
end

return {
	init = function(arg_3_0)
		arg_3_0.init_state = "not_initialized"

		if not Managers.account:user_detached() then
			var_0_4()

			arg_3_0.init_state = "started"
		end

		arg_3_0._unlocked_achievements = Managers.account:get_unlocked_achievement_list()
	end,
	update = function(arg_4_0)
		if arg_4_0.init_state == "not_initialized" then
			if not Managers.account:user_detached() then
				var_0_4()

				arg_4_0.init_state = "started"
			end

			return true
		end

		if arg_4_0.init_state == "started" then
			if not Achievements2017.is_refreshing(XB1Achievements) then
				arg_4_0.init_state = "complete"
			end

			return true
		end
	end,
	check_version_number = function()
		return true
	end,
	version_result = function(arg_6_0)
		return true
	end,
	is_unlocked = function(arg_7_0)
		return not arg_7_0.ID_XB1
	end,
	is_platform_achievement = function(arg_8_0)
		return arg_8_0.ID_XB1
	end,
	verify_platform_unlocked = function(arg_9_0)
		if not rawget(_G, "XB1Achievements") then
			return
		end

		if Managers.account:user_detached() then
			return
		end

		if Achievements2017.is_refreshing(XB1Achievements) or Achievements2017.progress_task_status(XB1Achievements) == var_0_1 then
			return
		end

		local var_9_0 = Managers.account
		local var_9_1 = not var_9_0:offline_mode()
		local var_9_2 = arg_9_0.ID_XB1
		local var_9_3 = arg_9_0.id
		local var_9_4 = arg_9_0.name
		local var_9_5 = 100

		printf("[Achievements2017] Verifying - Name: %q. Template: %q. ID: %q", Localize(var_9_4), var_9_3, var_9_2)

		local var_9_6

		if var_9_1 then
			var_9_6 = Achievements2017.progress(XB1Achievements, var_9_2)
		else
			var_9_6 = var_9_0:offline_achievement_progress(var_9_3)
		end

		local var_9_7 = true
		local var_9_8 = false

		if not var_9_6 or var_9_6 == -1 then
			printf("   - #### Error: Couldn't get progress for achievement %q - Removing it from evaluation", var_9_3)
			var_9_0:set_achievement_unlocked(var_9_3)

			return var_9_7, var_9_8
		end

		if var_9_6 < var_9_5 then
			printf("[Achievements2017] [%s] - Unlocking Name: %q. Template: %q. ID: %q", var_9_1 and "ONLINE" or "OFFLINE", Localize(var_9_4), var_9_3, var_9_2)

			local var_9_9

			if var_9_1 then
				var_9_9 = Achievements2017.set_progress(XB1Achievements, var_9_2, var_9_5)
			else
				var_9_9 = Achievements2017.set_progress_offline(XB1Achievements, var_9_2, var_9_6)

				if not var_9_9 then
					var_9_0:set_offline_achievement_progress(var_9_3, var_9_6)
				end
			end

			if var_9_9 then
				printf("[Achievements2017] #### Error: %s", var_9_9)
				var_9_0:set_achievement_unlocked(var_9_3)
			else
				var_9_8 = true
			end
		else
			print("[Achievements2017] - Already Unlocked")
		end

		return var_9_7, var_9_8
	end,
	set_progress = function(arg_10_0, arg_10_1, arg_10_2)
		if arg_10_1 > 0 then
			local var_10_0 = arg_10_1 / arg_10_2 * 100
			local var_10_1 = math.floor(var_10_0 + 0.5)

			return var_0_5(arg_10_0, var_10_1)
		end
	end,
	unlock = function(arg_11_0)
		return var_0_5(arg_11_0, 100)
	end,
	unlock_result = function(arg_12_0, arg_12_1)
		local var_12_0 = Achievements2017.progress_task_status(XB1Achievements)

		if var_12_0 == var_0_1 then
			return false
		elseif var_12_0 == var_0_2 then
			if Managers.account:is_online() then
				Achievements2017.refresh(XB1Achievements)
			end

			return true
		elseif var_12_0 == var_0_3 then
			print("[AchievementManager] PROGRESS_TASK_FAILED", arg_12_1)
			Managers.account:set_achievement_unlocked(arg_12_1)

			return true, "error"
		end
	end,
	reset = function()
		errorf("Tried to reset Achievements, not implemented!")
	end
}
