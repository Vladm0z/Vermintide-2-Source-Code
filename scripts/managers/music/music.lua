-- chunkname: @scripts/managers/music/music.lua

local function fn(...)
	-- function 1
	if not script_data.debug_music then
		print("[Music]", ...)
	end
end

Music = class(Music)

Music.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	self._wwise_world = arg_2_1
	self._stop = arg_2_3
	self._name = arg_2_4
	self._game_state_voice_thresholds = arg_2_6

	self:_init_group_states(arg_2_5)

	self._id = self:_trigger_event(arg_2_2)
end

Music._init_group_states = function (self, arg_3_1)
	-- function 3
	self._group_states = {}

	for k, v in pairs(arg_3_1) do
		self:set_group_state(k, v)
	end
end

Music.name = function (self)
	-- function 4
	return self._name
end

Music.stop = function (self)
	-- function 5
	if not self._stop then
		fn("Stopping Music player", self._name, "with switch:", self._stop.switch, "and value", self._stop.value)
		self:set_group_state(self._stop.group, self._stop.state)
		self:_trigger_event(self._stop.event)
	else
		self:destroy()
	end

	self._stopped = true
end

Music.is_stopped = function (self)
	-- function 6
	return self._stopped
end

Music.is_playing = function (self)
	-- function 7
	return WwiseWorld.is_playing(self._wwise_world, self._id)
end

Music.destroy = function (self)
	-- function 8
	if not self:is_playing() then
		WwiseWorld.stop_event(self._wwise_world, self._id)
	end
end

Music.set_group_state = function (self, arg_9_1, arg_9_2)
	-- function 9
	if self._group_states[arg_9_1] ~= arg_9_2 then
		fn("Player", self._name, "setting group state:", arg_9_1, "to", arg_9_2)
		Wwise.set_state(arg_9_1, arg_9_2)

		self._group_states[arg_9_1] = arg_9_2

		if arg_9_1 == "game_state" then
			local var_9_0 = self._game_state_voice_thresholds[arg_9_2]

			var_9_0 = var_9_0 or self._game_state_voice_thresholds.default

			Wwise.set_volume_threshold(var_9_0)
		end
	end
end

Music.has_game_faction = function (self)
	-- function 10
	local game_faction = self._group_states.game_faction

	game_faction = not game_faction and self._group_states.game_faction ~= "undecided"

	return game_faction
end

Music._trigger_event = function (self, arg_11_1)
	-- function 11
	fn("trigger event", arg_11_1)

	return WwiseWorld.trigger_event(self._wwise_world, arg_11_1)
end

Music.post_trigger = function (self, arg_12_1)
	-- function 12
	fn("post trigger", arg_12_1)
	WwiseWorld.trigger_event(self._wwise_world, arg_12_1)
end
