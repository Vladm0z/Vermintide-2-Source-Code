-- chunkname: @foundation/scripts/util/script_extended_replay.lua

ScriptExtendedReplay = class(ScriptExtendedReplay)

ScriptExtendedReplay.reload = function ()
	Managers.replay:reload()
end

ScriptExtendedReplay.play = function (arg_2_0)
	Managers.replay:play(arg_2_0)
end

ScriptExtendedReplay.set_frame = function (arg_3_0)
	Managers.replay:set_frame(arg_3_0)
end

ScriptExtendedReplay.set_level = function (arg_4_0)
	Managers.replay:set_level(arg_4_0)
end

ScriptExtendedReplay.set_stories = function (arg_5_0)
	Managers.replay:set_stories(arg_5_0)
end

ScriptExtendedReplay.request_moving_units = function ()
	local var_6_0 = {
		message = "moving_units",
		type = "replay",
		units = ExtendedReplay.moving_units()
	}

	Application.console_send(var_6_0)
end
