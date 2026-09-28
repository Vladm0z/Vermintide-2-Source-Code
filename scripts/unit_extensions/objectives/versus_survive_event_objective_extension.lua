-- chunkname: @scripts/unit_extensions/objectives/versus_survive_event_objective_extension.lua

VersusSurviveEventObjectiveExtension = class(VersusSurviveEventObjectiveExtension, BaseObjectiveExtension)
VersusSurviveEventObjectiveExtension.NAME = "VersusSurviveEventObjectiveExtension"

VersusSurviveEventObjectiveExtension.init = function (self, ...)
	-- function 1
	VersusSurviveEventObjectiveExtension.super.init(self, ...)

	self._survive_time_done = 0
	self._remaining_survive_time = 0
	self._current_time_survived = 0
	self._percentage = 0
end

VersusSurviveEventObjectiveExtension._set_objective_data = function (self, objective_data)
	-- function 2
	local survive_default_settings = GameModeSettings.versus.objectives.survive_event
	local num_sections = objective_data.num_sections

	num_sections = not not num_sections or not not survive_default_settings.num_sections
	self._num_sections = num_sections

	local score_per_section = objective_data.score_per_section

	score_per_section = not not score_per_section or not not survive_default_settings.score_per_section
	self._score_per_section = score_per_section

	local time_per_section = objective_data.time_per_section

	time_per_section = not not time_per_section or not not survive_default_settings.time_per_section
	self._time_per_section = time_per_section

	local score_for_completion = objective_data.score_for_completion

	score_for_completion = not not score_for_completion or not not survive_default_settings.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = objective_data.time_for_completion

	time_for_completion = not not time_for_completion or not not survive_default_settings.time_for_completion
	self._time_for_completion = time_for_completion

	local on_last_leaf_complete_sound_event = objective_data.on_last_leaf_complete_sound_event

	on_last_leaf_complete_sound_event = not not on_last_leaf_complete_sound_event or not not survive_default_settings.on_last_leaf_complete_sound_event
	self._on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event

	local on_leaf_complete_sound_event = objective_data.on_leaf_complete_sound_event

	on_leaf_complete_sound_event = not not on_leaf_complete_sound_event or not not survive_default_settings.on_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = on_leaf_complete_sound_event

	local on_section_progress_sound_event = objective_data.on_section_progress_sound_event

	on_section_progress_sound_event = not not on_section_progress_sound_event or not not survive_default_settings.on_section_progress_sound_event
	self._on_section_progress_sound_event = on_section_progress_sound_event
end

VersusSurviveEventObjectiveExtension._activate = function (self)
	-- function 3
	self._survive_time_done = Managers.time:time("game") + self._time_for_completion
end

VersusSurviveEventObjectiveExtension._deactivate = function (self)
	-- function 4
	return
end

VersusSurviveEventObjectiveExtension._server_update = function (self, dt, t)
	-- function 5
	local time_remaining = math.clamp(self._survive_time_done - t, 0, self._time_for_completion)

	if time_remaining ~= self._remaining_survive_time then
		self._remaining_survive_time = time_remaining

		local percentage_done = self:get_percentage_done()

		self:server_set_value(percentage_done)

		if percentage_done >= (self._current_section + 1) * (1 / self._num_sections) then
			self:on_section_completed()
		end
	end
end

VersusSurviveEventObjectiveExtension._client_update = function (self, dt, t)
	-- function 6
	self._percentage = self:client_get_value()
end

VersusSurviveEventObjectiveExtension.update_testify = function (self, dt, t)
	-- function 7
	return
end

VersusSurviveEventObjectiveExtension.get_percentage_done = function (self)
	-- function 8
	if self._is_server then
		local value = 1 - self._remaining_survive_time / self._time_for_completion

		return math.clamp(value, 0, 1)
	end

	return self._percentage
end
