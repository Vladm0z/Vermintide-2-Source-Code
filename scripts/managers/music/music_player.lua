-- chunkname: @scripts/managers/music/music_player.lua

require("scripts/managers/music/music")

local function fn(...)
	-- function 1
	if not script_data.debug_music then
		print("[MusicPlayer] ", ...)
	end
end

MusicPlayer = class(MusicPlayer)

MusicPlayer.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
	-- function 2
	self._wwise_world = arg_2_1
	self._start_event = arg_2_2
	self._stop_switch = arg_2_3
	self._name = arg_2_4
	self._set_flags = arg_2_5
	self._unset_flags = arg_2_6
	self._parameters = arg_2_7
	self._enabled = true
	self._init_group_states = arg_2_8
	self._game_state_voice_thresholds = arg_2_9
	self._old_music = {}

	fn(self._name, "init")
end

MusicPlayer.name = function (self)
	-- function 3
	return self._name
end

MusicPlayer.set_events = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._start_event = arg_4_1
	self._stop_event = arg_4_2
end

MusicPlayer._should_play = function (self, arg_5_1)
	-- function 5
	if not self._enabled then
		return false
	end

	for k, v in pairs(self._set_flags) do
		if not arg_5_1[v] then
			return false
		end
	end

	for k_2, v_2 in pairs(self._unset_flags) do
		if not arg_5_1[v_2] then
			return false
		end
	end

	return true
end

MusicPlayer.set_enabled = function (self, arg_6_1)
	-- function 6
	fn(self._name, "set_enabled", arg_6_1)

	self._enabled = arg_6_1
end

MusicPlayer.is_playing = function (self)
	-- function 7
	local _playing = self._playing

	_playing = not _playing and not table.is_empty(self._old_music)

	return _playing
end

MusicPlayer.set_group_state = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._playing then
		self._playing:set_group_state(arg_8_1, arg_8_2)
	end
end

MusicPlayer.post_trigger = function (self, arg_9_1)
	-- function 9
	if not self._playing then
		fn(self._name, "post_trigger", arg_9_1)
		self._playing:post_trigger(arg_9_1)
	end
end

MusicPlayer.update = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local _should_play = self:_should_play(arg_10_1)

	if self._playing or not _should_play then
		self._playing = Music:new(self._wwise_world, self._start_event, self._stop_switch, self._name, self._init_group_states, self._game_state_voice_thresholds)
	elseif not (not self._playing and _should_play) then
		self._old_music[self._playing] = true

		self._playing:stop()

		self._playing = false
	end

	if not self._playing and not arg_10_2 and (DEDICATED_SERVER or not arg_10_3) and not self._playing and not self._playing:has_game_faction() then
		local game = Managers.state.network:game()

		for i = 1, #SyncedMusicGroupFlags do
			local var_10_2 = SyncedMusicGroupFlags[i]
			local game_object_field = GameSession.game_object_field(game, arg_10_2, var_10_2)

			if type(game_object_field) == "table" then
				local get_party = Managers.player:local_player():get_party()

				if not get_party then
					game_object_field = game_object_field[get_party.party_id]
				else
					game_object_field = nil
				end
			end

			if not game_object_field then
				local var_10_5 = NetworkLookup.music_group_states[game_object_field]

				self._playing:set_group_state(var_10_2, var_10_5)
			end
		end
	end

	for k, v in pairs(self._old_music) do
		if not k:is_playing() then
			self._old_music[k] = nil

			k:destroy()
		end
	end

	if not script_data.debug_music and not self._playing then
		Debug.text(self._playing:name())

		for k_2, v_2 in pairs(self._playing._group_states) do
			Debug.text("\t %s: %s", k_2, v_2)
		end
	end
end

MusicPlayer.destroy = function (self)
	-- function 11
	fn(self._name, "destroy")

	if not self._playing then
		self._playing:destroy()

		self._playing = nil
	end

	for k, v in pairs(self._old_music) do
		self._old_music[k] = nil

		k:destroy()
	end

	self._old_music = nil
end

MusicPlayer.event_match = function (self, arg_12_1, arg_12_2)
	-- function 12
	return self._start_event ~= arg_12_1 or self._stop_event == arg_12_2
end
