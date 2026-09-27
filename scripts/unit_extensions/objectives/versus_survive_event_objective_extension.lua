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

VersusSurviveEventObjectiveExtension._set_objective_data = function (self, arg_2_1)
	-- function 2
	local survive_event = GameModeSettings.versus.objectives.survive_event
	local num_sections = arg_2_1.num_sections

	num_sections = num_sections or survive_event.num_sections
	self._num_sections = num_sections

	local score_per_section = arg_2_1.score_per_section

	score_per_section = score_per_section or survive_event.score_per_section
	self._score_per_section = score_per_section

	local time_per_section = arg_2_1.time_per_section

	time_per_section = time_per_section or survive_event.time_per_section
	self._time_per_section = time_per_section

	local score_for_completion = arg_2_1.score_for_completion

	score_for_completion = score_for_completion or survive_event.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = arg_2_1.time_for_completion

	time_for_completion = time_for_completion or survive_event.time_for_completion
	self._time_for_completion = time_for_completion

	local on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event

	on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event or survive_event.on_last_leaf_complete_sound_event
	self._on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event

	local on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event

	on_leaf_complete_sound_event = on_leaf_complete_sound_event or survive_event.on_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = on_leaf_complete_sound_event

	local on_section_progress_sound_event = arg_2_1.on_section_progress_sound_event

	on_section_progress_sound_event = on_section_progress_sound_event or survive_event.on_section_progress_sound_event
	self._on_section_progress_sound_event = on_section_progress_sound_event
end

VersusSurviveEventObjectiveExtension._activate = function (self)
	-- function 3
	self._survive_time_done = Managers.time:time("game") + self._time_for_completion
end

VersusSurviveEventObjectiveExtension._deactivate = function (arg_4_0)
	-- function 4
	return
end

VersusSurviveEventObjectiveExtension._server_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local clamp = math.clamp(self._survive_time_done - arg_5_2, 0, self._time_for_completion)

	if clamp ~= self._remaining_survive_time then
		self._remaining_survive_time = clamp

		local get_percentage_done = self:get_percentage_done()

		self:server_set_value(get_percentage_done)

		if get_percentage_done >= (self._current_section + 1) * (1 / self._num_sections) then
			self:on_section_completed()
		end
	end
end

VersusSurviveEventObjectiveExtension._client_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._percentage = self:client_get_value()
end

VersusSurviveEventObjectiveExtension.update_testify = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

VersusSurviveEventObjectiveExtension.get_percentage_done = function (self)
	-- function 8
	if not self._is_server then
		local num = 1 - self._remaining_survive_time / self._time_for_completion

		return math.clamp(num, 0, 1)
	end

	return self._percentage
end
