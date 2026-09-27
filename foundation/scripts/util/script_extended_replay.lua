-- chunkname: @foundation/scripts/util/script_extended_replay.lua

ScriptExtendedReplay = class(ScriptExtendedReplay)

ScriptExtendedReplay.reload = function ()
	-- function 1
	Managers.replay:reload()
end

ScriptExtendedReplay.play = function (arg_2_0)
	-- function 2
	Managers.replay:play(arg_2_0)
end

ScriptExtendedReplay.set_frame = function (arg_3_0)
	-- function 3
	Managers.replay:set_frame(arg_3_0)
end

ScriptExtendedReplay.set_level = function (arg_4_0)
	-- function 4
	Managers.replay:set_level(arg_4_0)
end

ScriptExtendedReplay.set_stories = function (arg_5_0)
	-- function 5
	Managers.replay:set_stories(arg_5_0)
end

ScriptExtendedReplay.request_moving_units = function ()
	-- function 6
	local tbl = {
		message = "moving_units",
		type = "replay",
		units = ExtendedReplay.moving_units()
	}

	Application.console_send(tbl)
end
