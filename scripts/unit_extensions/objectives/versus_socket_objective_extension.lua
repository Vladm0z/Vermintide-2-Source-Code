-- chunkname: @scripts/unit_extensions/objectives/versus_socket_objective_extension.lua

VersusSocketObjectiveExtension = class(VersusSocketObjectiveExtension, BaseObjectiveExtension)
VersusSocketObjectiveExtension.NAME = "VersusSocketObjectiveExtension"

VersusSocketObjectiveExtension.init = function (self, ...)
	-- function 1
	VersusSocketObjectiveExtension.super.init(self, ...)

	self._num_closed_sockets = 0
end

VersusSocketObjectiveExtension.extensions_ready = function (self)
	-- function 2
	local socket_extension = ScriptUnit.has_extension(self._unit, "objective_socket_system")

	if socket_extension then
		self._socket_extension = socket_extension
		self._num_sections = socket_extension.num_sockets
	end
end

VersusSocketObjectiveExtension._set_objective_data = function (self, objective_data)
	-- function 3
	local socket_default_settings = GameModeSettings.versus.objectives.socket

	self._score_per_section = not not objective_data.score_per_socket
	self._time_per_section = not not objective_data.time_per_socket
	self._score_for_completion = not not objective_data.score_for_completion
	self._time_for_completion = not not objective_data.time_for_completion
	self._on_last_leaf_complete_sound_event = not not objective_data.on_last_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = not not objective_data.on_leaf_complete_sound_event
	self._on_section_progress_sound_event = not not objective_data.on_section_progress_sound_event
end

VersusSocketObjectiveExtension._activate = function (self)
	-- function 4
	return
end

VersusSocketObjectiveExtension._deactivate = function (self)
	-- function 5
	return
end

VersusSocketObjectiveExtension._server_update = function (self, dt, t)
	-- function 6
	local num_closed_sockets = self._socket_extension.num_closed_sockets
	local num_new_closed_sockets = num_closed_sockets - self._num_closed_sockets

	for i = 1, num_new_closed_sockets do
		self:on_section_completed()
	end

	self._num_closed_sockets = num_closed_sockets
end

VersusSocketObjectiveExtension._client_update = function (self, dt, t)
	-- function 7
	return
end

VersusSocketObjectiveExtension.get_percentage_done = function (self)
	-- function 8
	return self._socket_extension.num_closed_sockets / self._num_sections + math.epsilon
end
