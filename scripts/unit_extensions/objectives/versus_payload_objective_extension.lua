-- chunkname: @scripts/unit_extensions/objectives/versus_payload_objective_extension.lua

VersusPayloadObjectiveExtension = class(VersusPayloadObjectiveExtension, BaseObjectiveExtension)
VersusPayloadObjectiveExtension.NAME = "VersusPayloadObjectiveExtension"

VersusPayloadObjectiveExtension.init = function (self, ...)
	-- function 1
	VersusPayloadObjectiveExtension.super.init(self, ...)

	self._total_distance = math.huge
	self._current_distance = 0
	self._percentage = 0
end

VersusPayloadObjectiveExtension.extensions_ready = function (self)
	-- function 2
	local has_extension = ScriptUnit.has_extension(self._unit, "payload_system")

	if not has_extension then
		self._payload_extension = has_extension
	end
end

VersusPayloadObjectiveExtension._set_objective_data = function (self, arg_3_1)
	-- function 3
	local payload = GameModeSettings.versus.objectives.payload
	local num_sections = arg_3_1.num_sections

	num_sections = num_sections or payload.num_sections
	self._num_sections = num_sections

	local score_per_section = arg_3_1.score_per_section

	score_per_section = score_per_section or payload.score_per_section
	self._score_per_section = score_per_section

	local time_per_section = arg_3_1.time_per_section

	time_per_section = time_per_section or payload.time_per_section
	self._time_per_section = time_per_section

	local score_for_completion = arg_3_1.score_for_completion

	score_for_completion = score_for_completion or payload.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = arg_3_1.time_for_completion

	time_for_completion = time_for_completion or payload.time_for_completion
	self._time_for_completion = time_for_completion

	local on_last_leaf_complete_sound_event = arg_3_1.on_last_leaf_complete_sound_event

	on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event or payload.on_last_leaf_complete_sound_event
	self._on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event

	local on_section_progress_sound_event = arg_3_1.on_section_progress_sound_event

	on_section_progress_sound_event = on_section_progress_sound_event or payload.on_section_progress_sound_event
	self._on_section_progress_sound_event = on_section_progress_sound_event
end

VersusPayloadObjectiveExtension._activate = function (self)
	-- function 4
	self._spline_movement = self._payload_extension:movement()
	self._total_distance = self._spline_movement:distance(1, 1, 0, #self._spline_movement._splines, #self._spline_movement:_current_spline().subdivisions, 1)
end

VersusPayloadObjectiveExtension._deactivate = function (arg_5_0)
	-- function 5
	return
end

VersusPayloadObjectiveExtension._server_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._payload_extension:started() then
		return
	end

	local current_spline_curve_distance = self._spline_movement:current_spline_curve_distance()

	if current_spline_curve_distance ~= self._current_distance then
		self._current_distance = current_spline_curve_distance

		local get_percentage_done = self:get_percentage_done()

		self:server_set_value(get_percentage_done)

		if get_percentage_done >= (self._current_section + 1) * (1 / self._num_sections) then
			self:on_section_completed()
		end
	end
end

VersusPayloadObjectiveExtension._client_update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._percentage = self:client_get_value()
end

VersusPayloadObjectiveExtension.get_percentage_done = function (self)
	-- function 8
	if not self._is_server then
		return self._current_distance / self._total_distance + math.epsilon
	end

	return self._percentage
end
