-- chunkname: @scripts/managers/music/music.lua

local function var_0_0(...)
	if script_data.debug_music then
		print("[Music]", ...)
	end
end

Music = class(Music)

function Music.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_0._wwise_world = arg_2_1
	arg_2_0._stop = arg_2_3
	arg_2_0._name = arg_2_4
	arg_2_0._game_state_voice_thresholds = arg_2_6

	arg_2_0:_init_group_states(arg_2_5)

	arg_2_0._id = arg_2_0:_trigger_event(arg_2_2)
end

function Music._init_group_states(arg_3_0, arg_3_1)
	arg_3_0._group_states = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		arg_3_0:set_group_state(iter_3_0, iter_3_1)
	end
end

function Music.name(arg_4_0)
	return arg_4_0._name
end

function Music.stop(arg_5_0)
	if arg_5_0._stop then
		var_0_0("Stopping Music player", arg_5_0._name, "with switch:", arg_5_0._stop.switch, "and value", arg_5_0._stop.value)
		arg_5_0:set_group_state(arg_5_0._stop.group, arg_5_0._stop.state)
		arg_5_0:_trigger_event(arg_5_0._stop.event)
	else
		arg_5_0:destroy()
	end

	arg_5_0._stopped = true
end

function Music.is_stopped(arg_6_0)
	return arg_6_0._stopped
end

function Music.is_playing(arg_7_0)
	return WwiseWorld.is_playing(arg_7_0._wwise_world, arg_7_0._id)
end

function Music.destroy(arg_8_0)
	if arg_8_0:is_playing() then
		WwiseWorld.stop_event(arg_8_0._wwise_world, arg_8_0._id)
	end
end

function Music.set_group_state(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0._group_states[arg_9_1] ~= arg_9_2 then
		var_0_0("Player", arg_9_0._name, "setting group state:", arg_9_1, "to", arg_9_2)
		Wwise.set_state(arg_9_1, arg_9_2)

		arg_9_0._group_states[arg_9_1] = arg_9_2

		if arg_9_1 == "game_state" then
			local var_9_0 = arg_9_0._game_state_voice_thresholds[arg_9_2] or arg_9_0._game_state_voice_thresholds.default

			Wwise.set_volume_threshold(var_9_0)
		end
	end
end

function Music.has_game_faction(arg_10_0)
	return arg_10_0._group_states.game_faction and arg_10_0._group_states.game_faction ~= "undecided"
end

function Music._trigger_event(arg_11_0, arg_11_1)
	var_0_0("trigger event", arg_11_1)

	return WwiseWorld.trigger_event(arg_11_0._wwise_world, arg_11_1)
end

function Music.post_trigger(arg_12_0, arg_12_1)
	var_0_0("post trigger", arg_12_1)
	WwiseWorld.trigger_event(arg_12_0._wwise_world, arg_12_1)
end
