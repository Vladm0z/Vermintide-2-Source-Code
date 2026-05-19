-- chunkname: @scripts/utils/framerate.lua

Framerate = {}

function Framerate.set_low_power()
	if IS_WINDOWS and not DEDICATED_SERVER then
		Application.set_time_step_policy("no_smoothing", "clear_history", "throttle", 60)
	end
end

function Framerate.set_playing()
	Application.set_time_step_policy("external_step_range", 0, 100, "system_step_range", 0, 100, "debt_payback", 0)

	if DEDICATED_SERVER then
		local var_2_0 = 30

		Application.set_time_step_policy("no_smoothing", "throttle", var_2_0)
	elseif IS_WINDOWS then
		Application.set_time_step_policy("smoothing", 11, 2, 0.1)

		local var_2_1 = Application.user_setting("max_fps")

		if var_2_1 == nil or var_2_1 == 0 then
			Application.set_time_step_policy("no_throttle")
		else
			Application.set_time_step_policy("throttle", var_2_1)
		end
	else
		Application.set_time_step_policy("no_smoothing")
	end
end

function Framerate.set_catchup()
	if IS_WINDOWS then
		Application.set_time_step_policy("smoothing", 11, 2, 0.5)
	end
end

function Framerate.set_replay()
	Application.set_time_step_policy("throttle", 60, "no_smoothing", "debt_payback", 0)
end
