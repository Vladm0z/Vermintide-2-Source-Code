-- chunkname: @foundation/scripts/util/script_extended_replay.lua

ScriptExtendedReplay = class(ScriptExtendedReplay)

ScriptExtendedReplay.reload = function ()
	-- function 1
	Managers.replay:reload()
end

ScriptExtendedReplay.play = function (enable)
	-- function 2
	Managers.replay:play(enable)
end

ScriptExtendedReplay.set_frame = function (frame)
	-- function 3
	Managers.replay:set_frame(frame)
end

ScriptExtendedReplay.set_level = function (level)
	-- function 4
	Managers.replay:set_level(level)
end

ScriptExtendedReplay.set_stories = function (stories)
	-- function 5
	Managers.replay:set_stories(stories)
end

ScriptExtendedReplay.request_moving_units = function ()
	-- function 6
	local cmd = {
		message = "moving_units",
		type = "replay",
		units = ExtendedReplay.moving_units()
	}

	Application.console_send(cmd)
end
