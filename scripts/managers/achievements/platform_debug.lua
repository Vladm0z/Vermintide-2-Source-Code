-- chunkname: @scripts/managers/achievements/platform_debug.lua

local platform_functions = {
	init = function (achievement_manager)
		-- function 1
		return
	end,
	check_version_number = function ()
		-- function 2
		local token = Application.time_since_launch() + 1 + math.random() * 2

		return false, token
	end,
	version_result = function (token)
		-- function 3
		local time = Application.time_since_launch()

		return token < time
	end,
	is_unlocked = function (template)
		-- function 4
		return false
	end,
	is_platform_achievement = function (template)
		-- function 5
		return false
	end,
	verify_platform_unlocked = function (template)
		-- function 6
		local verified = true
		local token

		return verified, token
	end,
	unlock = function (template)
		-- function 7
		local token = Application.time_since_launch() + 5 + math.random() * 2

		return token
	end,
	unlock_result = function (token)
		-- function 8
		local time = Application.time_since_launch()

		return token < time
	end,
	reset = function ()
		-- function 9
		return
	end
}

return platform_functions
