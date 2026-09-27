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
	local has_extension = ScriptUnit.has_extension(self._unit, "objective_socket_system")

	if not has_extension then
		self._socket_extension = has_extension
		self._num_sections = has_extension.num_sockets
	end
end

VersusSocketObjectiveExtension._set_objective_data = function (self, arg_3_1)
	-- function 3
	local socket = GameModeSettings.versus.objectives.socket
	local score_per_socket = arg_3_1.score_per_socket

	score_per_socket = score_per_socket or socket.score_per_socket
	self._score_per_section = score_per_socket

	local time_per_socket = arg_3_1.time_per_socket

	time_per_socket = time_per_socket or socket.time_per_socket
	self._time_per_section = time_per_socket

	local score_for_completion = arg_3_1.score_for_completion

	score_for_completion = score_for_completion or socket.score_for_completion
	self._score_for_completion = score_for_completion

	local time_for_completion = arg_3_1.time_for_completion

	time_for_completion = time_for_completion or socket.time_for_completion
	self._time_for_completion = time_for_completion

	local on_last_leaf_complete_sound_event = arg_3_1.on_last_leaf_complete_sound_event

	on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event or socket.on_last_leaf_complete_sound_event
	self._on_last_leaf_complete_sound_event = on_last_leaf_complete_sound_event

	local on_leaf_complete_sound_event = arg_3_1.on_leaf_complete_sound_event

	on_leaf_complete_sound_event = on_leaf_complete_sound_event or socket.on_leaf_complete_sound_event
	self._on_leaf_complete_sound_event = on_leaf_complete_sound_event

	local on_section_progress_sound_event = arg_3_1.on_section_progress_sound_event

	on_section_progress_sound_event = on_section_progress_sound_event or socket.on_section_progress_sound_event
	self._on_section_progress_sound_event = on_section_progress_sound_event
end

VersusSocketObjectiveExtension._activate = function (arg_4_0)
	-- function 4
	return
end

VersusSocketObjectiveExtension._deactivate = function (arg_5_0)
	-- function 5
	return
end

VersusSocketObjectiveExtension._server_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local num_closed_sockets = self._socket_extension.num_closed_sockets
	local num = num_closed_sockets - self._num_closed_sockets

	for i = 1, num do
		self:on_section_completed()
	end

	self._num_closed_sockets = num_closed_sockets
end

VersusSocketObjectiveExtension._client_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

VersusSocketObjectiveExtension.get_percentage_done = function (self)
	-- function 8
	return self._socket_extension.num_closed_sockets / self._num_sections + math.epsilon
end
