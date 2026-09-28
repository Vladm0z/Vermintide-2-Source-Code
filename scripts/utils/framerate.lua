-- chunkname: @scripts/utils/framerate.lua

Framerate = {}

Framerate.set_low_power = function ()
	-- function 1
	if IS_WINDOWS and not DEDICATED_SERVER then
		Application.set_time_step_policy("no_smoothing", "clear_history", "throttle", 60)
	end
end

Framerate.set_playing = function ()
	-- function 2
	Application.set_time_step_policy("external_step_range", 0, 100, "system_step_range", 0, 100, "debt_payback", 0)

	if DEDICATED_SERVER then
		local tickrate = 30

		Application.set_time_step_policy("no_smoothing", "throttle", tickrate)
	elseif IS_WINDOWS then
		Application.set_time_step_policy("smoothing", 11, 2, 0.1)

		local max_fps = Application.user_setting("max_fps")

		if max_fps == nil or max_fps == 0 then
			Application.set_time_step_policy("no_throttle")
		else
			Application.set_time_step_policy("throttle", max_fps)
		end
	else
		Application.set_time_step_policy("no_smoothing")
	end
end

Framerate.set_catchup = function ()
	-- function 3
	if IS_WINDOWS then
		Application.set_time_step_policy("smoothing", 11, 2, 0.5)
	end
end

Framerate.set_replay = function ()
	-- function 4
	Application.set_time_step_policy("throttle", 60, "no_smoothing", "debt_payback", 0)
end
