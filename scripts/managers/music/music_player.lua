-- chunkname: @scripts/managers/music/music_player.lua

require("scripts/managers/music/music")

local function var_0_0(...)
	if script_data.debug_music then
		print("[MusicPlayer] ", ...)
	end
end

MusicPlayer = class(MusicPlayer)

function MusicPlayer.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
	arg_2_0._wwise_world = arg_2_1
	arg_2_0._start_event = arg_2_2
	arg_2_0._stop_switch = arg_2_3
	arg_2_0._name = arg_2_4
	arg_2_0._set_flags = arg_2_5
	arg_2_0._unset_flags = arg_2_6
	arg_2_0._parameters = arg_2_7
	arg_2_0._enabled = true
	arg_2_0._init_group_states = arg_2_8
	arg_2_0._game_state_voice_thresholds = arg_2_9
	arg_2_0._old_music = {}

	var_0_0(arg_2_0._name, "init")
end

function MusicPlayer.name(arg_3_0)
	return arg_3_0._name
end

function MusicPlayer.set_events(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._start_event = arg_4_1
	arg_4_0._stop_event = arg_4_2
end

function MusicPlayer._should_play(arg_5_0, arg_5_1)
	if not arg_5_0._enabled then
		return false
	end

	for iter_5_0, iter_5_1 in pairs(arg_5_0._set_flags) do
		if not arg_5_1[iter_5_1] then
			return false
		end
	end

	for iter_5_2, iter_5_3 in pairs(arg_5_0._unset_flags) do
		if arg_5_1[iter_5_3] then
			return false
		end
	end

	return true
end

function MusicPlayer.set_enabled(arg_6_0, arg_6_1)
	var_0_0(arg_6_0._name, "set_enabled", arg_6_1)

	arg_6_0._enabled = arg_6_1
end

function MusicPlayer.is_playing(arg_7_0)
	return arg_7_0._playing and not table.is_empty(arg_7_0._old_music)
end

function MusicPlayer.set_group_state(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_0._playing then
		arg_8_0._playing:set_group_state(arg_8_1, arg_8_2)
	end
end

function MusicPlayer.post_trigger(arg_9_0, arg_9_1)
	if arg_9_0._playing then
		var_0_0(arg_9_0._name, "post_trigger", arg_9_1)
		arg_9_0._playing:post_trigger(arg_9_1)
	end
end

function MusicPlayer.update(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0:_should_play(arg_10_1)

	if not arg_10_0._playing and var_10_0 then
		arg_10_0._playing = Music:new(arg_10_0._wwise_world, arg_10_0._start_event, arg_10_0._stop_switch, arg_10_0._name, arg_10_0._init_group_states, arg_10_0._game_state_voice_thresholds)
	elseif arg_10_0._playing and not var_10_0 then
		arg_10_0._old_music[arg_10_0._playing] = true

		arg_10_0._playing:stop()

		arg_10_0._playing = false
	end

	if arg_10_0._playing and arg_10_2 and not DEDICATED_SERVER and arg_10_3 and arg_10_0._playing and arg_10_0._playing:has_game_faction() then
		local var_10_1 = Managers.state.network:game()

		for iter_10_0 = 1, #SyncedMusicGroupFlags do
			local var_10_2 = SyncedMusicGroupFlags[iter_10_0]
			local var_10_3 = GameSession.game_object_field(var_10_1, arg_10_2, var_10_2)

			if type(var_10_3) == "table" then
				local var_10_4 = Managers.player:local_player():get_party()

				if var_10_4 then
					var_10_3 = var_10_3[var_10_4.party_id]
				else
					var_10_3 = nil
				end
			end

			if var_10_3 then
				local var_10_5 = NetworkLookup.music_group_states[var_10_3]

				arg_10_0._playing:set_group_state(var_10_2, var_10_5)
			end
		end
	end

	for iter_10_1, iter_10_2 in pairs(arg_10_0._old_music) do
		if not iter_10_1:is_playing() then
			arg_10_0._old_music[iter_10_1] = nil

			iter_10_1:destroy()
		end
	end

	if script_data.debug_music and arg_10_0._playing then
		Debug.text(arg_10_0._playing:name())

		for iter_10_3, iter_10_4 in pairs(arg_10_0._playing._group_states) do
			Debug.text("\t %s: %s", iter_10_3, iter_10_4)
		end
	end
end

function MusicPlayer.destroy(arg_11_0)
	var_0_0(arg_11_0._name, "destroy")

	if arg_11_0._playing then
		arg_11_0._playing:destroy()

		arg_11_0._playing = nil
	end

	for iter_11_0, iter_11_1 in pairs(arg_11_0._old_music) do
		arg_11_0._old_music[iter_11_0] = nil

		iter_11_0:destroy()
	end

	arg_11_0._old_music = nil
end

function MusicPlayer.event_match(arg_12_0, arg_12_1, arg_12_2)
	return arg_12_0._start_event == arg_12_1 and arg_12_0._stop_event == arg_12_2
end
