-- chunkname: @scripts/unit_extensions/objectives/versus_target_objective_extension.lua

VersusTargetObjectiveExtension = class(VersusTargetObjectiveExtension, BaseObjectiveExtension)
VersusTargetObjectiveExtension.NAME = "VersusTargetObjectiveExtension"

VersusTargetObjectiveExtension._set_objective_data = function (self, arg_1_1)
	-- function 1
	local target = GameModeSettings.versus.objectives.target
	local num_sections = arg_1_1.num_sections

	num_sections = num_sections or target.num_sections
	self._num_sections = num_sections

	local score_per_section = arg_1_1.score_per_section

	score_per_section = score_per_section or target.score_per_section
	self._score_per_section = score_per_section

	local time_per_section = arg_1_1.time_per_section

	time_per_section = time_per_section or target.time_per_section
	self._time_per_section = time_per_section

	local score_for_completion = arg_1_1.score_for_completion

	score_for_completion = score_for_completion or target.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = arg_1_1.time_for_completion

	time_for_completion = time_for_completion or target.time_for_completion
	self._time_for_completion = time_for_completion

	local on_last_leaf_complete_sound_event = arg_1_1.on_last_leaf_complete_sound_event

	on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event or target.on_last_leaf_complete_sound_event
	self._on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event

	local on_leaf_complete_sound_event = arg_1_1.on_leaf_complete_sound_event

	on_leaf_complete_sound_event = on_leaf_complete_sound_event or target.on_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = on_leaf_complete_sound_event

	local on_section_progress_sound_event = arg_1_1.on_section_progress_sound_event

	on_section_progress_sound_event = on_section_progress_sound_event or target.on_section_progress_sound_event
	self._on_section_progress_sound_event = on_section_progress_sound_event
end

VersusTargetObjectiveExtension._activate = function (arg_2_0)
	-- function 2
	return
end

VersusTargetObjectiveExtension.extensions_ready = function (self)
	-- function 3
	self._health_extension = ScriptUnit.has_extension(self._unit, "health_system")
	self._max_health = self._health_extension:current_health()
	self._health = self._max_health
end

VersusTargetObjectiveExtension._deactivate = function (arg_4_0)
	-- function 4
	return
end

VersusTargetObjectiveExtension._store_position = function (arg_5_0)
	-- function 5
	return
end

VersusTargetObjectiveExtension._server_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._health = self._health_extension:current_health()

	if self:get_percentage_done() >= (self._current_section + 1) * (1 / self._num_sections) then
		self:on_section_completed()
	end
end

VersusTargetObjectiveExtension._client_update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._health = self._health_extension:current_health()
end

VersusTargetObjectiveExtension.get_percentage_done = function (self)
	-- function 8
	if self._max_health == 0 then
		return 1
	end

	return math.clamp01(1 - self._health / self._max_health + math.epsilon)
end
