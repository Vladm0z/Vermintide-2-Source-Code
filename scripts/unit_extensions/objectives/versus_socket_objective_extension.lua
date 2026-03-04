-- chunkname: @scripts/unit_extensions/objectives/versus_socket_objective_extension.lua

VersusSocketObjectiveExtension = class(VersusSocketObjectiveExtension, BaseObjectiveExtension)
VersusSocketObjectiveExtension.NAME = "VersusSocketObjectiveExtension"

VersusSocketObjectiveExtension.init = function (arg_1_0, ...)
	VersusSocketObjectiveExtension.super.init(arg_1_0, ...)

	arg_1_0._num_closed_sockets = 0
end

VersusSocketObjectiveExtension.extensions_ready = function (arg_2_0)
	local var_2_0 = ScriptUnit.has_extension(arg_2_0._unit, "objective_socket_system")

	if var_2_0 then
		arg_2_0._socket_extension = var_2_0
		arg_2_0._num_sections = var_2_0.num_sockets
	end
end

VersusSocketObjectiveExtension._set_objective_data = function (arg_3_0, arg_3_1)
	local var_3_0 = GameModeSettings.versus.objectives.socket

	arg_3_0._score_per_section = arg_3_1.score_per_socket or var_3_0.score_per_socket
	arg_3_0._time_per_section = arg_3_1.time_per_socket or var_3_0.time_per_socket
	arg_3_0._score_for_completion = arg_3_1.score_for_completion or var_3_0.score_for_completion
	arg_3_0._time_for_completion = arg_3_1.time_for_completion or var_3_0.time_for_completion
	arg_3_0._on_last_leaf_complete_sound_event = arg_3_1.on_last_leaf_complete_sound_event or var_3_0.on_last_leaf_complete_sound_event
	arg_3_0._on_leaf_complete_sound_event = arg_3_1.on_leaf_complete_sound_event or var_3_0.on_leaf_complete_sound_event
	arg_3_0._on_section_progress_sound_event = arg_3_1.on_section_progress_sound_event or var_3_0.on_section_progress_sound_event
end

VersusSocketObjectiveExtension._activate = function (arg_4_0)
	return
end

VersusSocketObjectiveExtension._deactivate = function (arg_5_0)
	return
end

VersusSocketObjectiveExtension._server_update = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._socket_extension.num_closed_sockets
	local var_6_1 = var_6_0 - arg_6_0._num_closed_sockets

	for iter_6_0 = 1, var_6_1 do
		arg_6_0:on_section_completed()
	end

	arg_6_0._num_closed_sockets = var_6_0
end

VersusSocketObjectiveExtension._client_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

VersusSocketObjectiveExtension.get_percentage_done = function (arg_8_0)
	return arg_8_0._socket_extension.num_closed_sockets / arg_8_0._num_sections + math.epsilon
end
