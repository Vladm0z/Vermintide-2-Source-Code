-- chunkname: @scripts/unit_extensions/objectives/versus_mission_objective_extension.lua

VersusMissionObjectiveExtension = class(VersusMissionObjectiveExtension, BaseObjectiveExtension)
VersusMissionObjectiveExtension.NAME = "VersusMissionObjectiveExtension"

VersusMissionObjectiveExtension.init = function (self, ...)
	-- function 1
	VersusMissionObjectiveExtension.super.init(self, ...)

	self._mission_system = Managers.state.entity:system("mission_system")
	self._percentage = 0
end

VersusMissionObjectiveExtension._set_objective_data = function (self, objective_data)
	-- function 2
	local mission_default_settings = GameModeSettings.versus.objectives.mission

	self._score_for_completion = not not objective_data.score_for_completion
	self._time_for_completion = not not objective_data.time_for_completion
	self._on_last_leaf_complete_sound_event = not not objective_data.on_last_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = not not objective_data.on_leaf_complete_sound_event
	self._on_section_progress_sound_event = not not objective_data.on_section_progress_sound_event
	self._mission_name = objective_data.mission_name
end

VersusMissionObjectiveExtension._activate = function (self)
	-- function 3
	return
end

VersusMissionObjectiveExtension._deactivate = function (self)
	-- function 4
	return
end

VersusMissionObjectiveExtension._server_update = function (self, dt, t)
	-- function 5
	local missions = self._mission_system.completed_missions

	if missions[self._mission_name] ~= nil then
		self._percentage = 1

		self:server_set_value(self._percentage)
	end
end

VersusMissionObjectiveExtension._client_update = function (self, dt, t)
	-- function 6
	self._percentage = self:client_get_value()
end

VersusMissionObjectiveExtension.get_percentage_done = function (self)
	-- function 7
	return self._percentage
end
