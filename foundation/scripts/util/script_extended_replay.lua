-- chunkname: @foundation/scripts/util/script_extended_replay.lua

ScriptExtendedReplay = class(ScriptExtendedReplay)

function ScriptExtendedReplay.reload()
	Managers.replay:reload()
end

function ScriptExtendedReplay.play(arg_2_0)
	Managers.replay:play(arg_2_0)
end

function ScriptExtendedReplay.set_frame(arg_3_0)
	Managers.replay:set_frame(arg_3_0)
end

function ScriptExtendedReplay.set_level(arg_4_0)
	Managers.replay:set_level(arg_4_0)
end

function ScriptExtendedReplay.set_stories(arg_5_0)
	Managers.replay:set_stories(arg_5_0)
end

function ScriptExtendedReplay.request_moving_units()
	local var_6_0 = {
		message = "moving_units",
		type = "replay",
		units = ExtendedReplay.moving_units()
	}

	Application.console_send(var_6_0)
end
