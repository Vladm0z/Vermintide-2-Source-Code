-- chunkname: @scripts/managers/achievements/platform_debug.lua

return {
	init = function(arg_1_0)
		return
	end,
	check_version_number = function()
		local var_2_0 = Application.time_since_launch() + 1 + math.random() * 2

		return false, var_2_0
	end,
	version_result = function(arg_3_0)
		return arg_3_0 < Application.time_since_launch()
	end,
	is_unlocked = function(arg_4_0)
		return false
	end,
	is_platform_achievement = function(arg_5_0)
		return false
	end,
	verify_platform_unlocked = function(arg_6_0)
		local var_6_0 = true
		local var_6_1

		return var_6_0, var_6_1
	end,
	unlock = function(arg_7_0)
		return Application.time_since_launch() + 5 + math.random() * 2
	end,
	unlock_result = function(arg_8_0)
		return arg_8_0 < Application.time_since_launch()
	end,
	reset = function()
		return
	end
}
