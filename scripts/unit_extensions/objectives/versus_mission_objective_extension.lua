-- chunkname: @scripts/unit_extensions/objectives/versus_mission_objective_extension.lua

VersusMissionObjectiveExtension = class(VersusMissionObjectiveExtension, BaseObjectiveExtension)
VersusMissionObjectiveExtension.NAME = "VersusMissionObjectiveExtension"

VersusMissionObjectiveExtension.init = function (self, ...)
	-- function 1
	VersusMissionObjectiveExtension.super.init(self, ...)

	self._mission_system = Managers.state.entity:system("mission_system")
	self._percentage = 0
end

VersusMissionObjectiveExtension._set_objective_data = function (self, arg_2_1)
	-- function 2
	local mission = GameModeSettings.versus.objectives.mission
	local score_for_completion = arg_2_1.score_for_completion

	score_for_completion = score_for_completion or mission.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = arg_2_1.time_for_completion

	time_for_completion = time_for_completion or mission.time_for_completion
	self._time_for_completion = time_for_completion

	local on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event

	on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event or mission.on_last_leaf_complete_sound_event
	self._on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event

	local on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event

	on_leaf_complete_sound_event = on_leaf_complete_sound_event or mission.on_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = on_leaf_complete_sound_event

	local on_section_progress_sound_event = arg_2_1.on_section_progress_sound_event

	on_section_progress_sound_event = on_section_progress_sound_event or mission.on_section_progress_sound_event
	self._on_section_progress_sound_event = on_section_progress_sound_event
	self._mission_name = arg_2_1.mission_name
end

VersusMissionObjectiveExtension._activate = function (arg_3_0)
	-- function 3
	return
end

VersusMissionObjectiveExtension._deactivate = function (arg_4_0)
	-- function 4
	return
end

VersusMissionObjectiveExtension._server_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if self._mission_system.completed_missions[self._mission_name] ~= nil then
		self._percentage = 1

		self:server_set_value(self._percentage)
	end
end

VersusMissionObjectiveExtension._client_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._percentage = self:client_get_value()
end

VersusMissionObjectiveExtension.get_percentage_done = function (self)
	-- function 7
	return self._percentage
end
