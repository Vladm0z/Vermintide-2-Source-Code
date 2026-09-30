-- chunkname: @scripts/managers/music/music.lua

local function dprint(...)
	-- function 1
	if script_data.debug_music then
		print("[Music]", ...)
	end
end

Music = class(Music)

Music.init = function (self, wwise_world, start_event, stop, name, group_states, game_state_voice_thresholds)
	-- function 2
	self._wwise_world = wwise_world
	self._stop = stop
	self._name = name
	self._game_state_voice_thresholds = game_state_voice_thresholds

	self:_init_group_states(group_states)

	self._id = self:_trigger_event(start_event)
end

Music._init_group_states = function (self, states)
	-- function 3
	self._group_states = {}

	for group, state in pairs(states) do
		self:set_group_state(group, state)
	end
end

Music.name = function (self)
	-- function 4
	return self._name
end

Music.stop = function (self)
	-- function 5
	if self._stop then
		dprint("Stopping Music player", self._name, "with switch:", self._stop.switch, "and value", self._stop.value)
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
	if self:is_playing() then
		WwiseWorld.stop_event(self._wwise_world, self._id)
	end
end

Music.set_group_state = function (self, state, value)
	-- function 9
	if self._group_states[state] ~= value then
		dprint("Player", self._name, "setting group state:", state, "to", value)
		Wwise.set_state(state, value)

		self._group_states[state] = value

		if state == "game_state" then
			local voice_threshold = self._game_state_voice_thresholds[value]

			Wwise.set_volume_threshold(voice_threshold)
		end
	end
end

Music.has_game_faction = function (self)
	-- function 10
	return self._group_states.game_faction
end

Music._trigger_event = function (self, event)
	-- function 11
	dprint("trigger event", event)

	return WwiseWorld.trigger_event(self._wwise_world, event)
end

Music.post_trigger = function (self, trigger)
	-- function 12
	dprint("post trigger", trigger)
	WwiseWorld.trigger_event(self._wwise_world, trigger)
end
