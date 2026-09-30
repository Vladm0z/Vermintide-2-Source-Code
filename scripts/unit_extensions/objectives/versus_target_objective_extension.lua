-- chunkname: @scripts/unit_extensions/objectives/versus_target_objective_extension.lua

VersusTargetObjectiveExtension = class(VersusTargetObjectiveExtension, BaseObjectiveExtension)
VersusTargetObjectiveExtension.NAME = "VersusTargetObjectiveExtension"

VersusTargetObjectiveExtension._set_objective_data = function (self, objective_data)
	-- function 1
	local target_default_settings = GameModeSettings.versus.objectives.target

	self._num_sections = objective_data.num_sections
	self._score_per_section = objective_data.score_per_section
	self._time_per_section = objective_data.time_per_section
	self._score_for_completion = objective_data.score_for_completion
	self._time_for_completion = objective_data.time_for_completion
	self._on_last_leaf_complete_sound_event = objective_data.on_last_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = objective_data.on_leaf_complete_sound_event
	self._on_section_progress_sound_event = objective_data.on_section_progress_sound_event
end

VersusTargetObjectiveExtension._activate = function (self)
	-- function 2
	return
end

VersusTargetObjectiveExtension.extensions_ready = function (self)
	-- function 3
	self._health_extension = ScriptUnit.has_extension(self._unit, "health_system")
	self._max_health = self._health_extension:current_health()
	self._health = self._max_health
end

VersusTargetObjectiveExtension._deactivate = function (self)
	-- function 4
	return
end

VersusTargetObjectiveExtension._store_position = function (self)
	-- function 5
	return
end

VersusTargetObjectiveExtension._server_update = function (self, dt, t)
	-- function 6
	self._health = self._health_extension:current_health()

	local percentage_done = self:get_percentage_done()

	if percentage_done >= (self._current_section + 1) * (1 / self._num_sections) then
		self:on_section_completed()
	end
end

VersusTargetObjectiveExtension._client_update = function (self, dt, t)
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
