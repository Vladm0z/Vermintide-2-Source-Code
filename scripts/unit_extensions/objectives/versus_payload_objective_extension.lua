-- chunkname: @scripts/unit_extensions/objectives/versus_payload_objective_extension.lua

VersusPayloadObjectiveExtension = class(VersusPayloadObjectiveExtension, BaseObjectiveExtension)
VersusPayloadObjectiveExtension.NAME = "VersusPayloadObjectiveExtension"

function VersusPayloadObjectiveExtension.init(arg_1_0, ...)
	VersusPayloadObjectiveExtension.super.init(arg_1_0, ...)

	arg_1_0._total_distance = math.huge
	arg_1_0._current_distance = 0
	arg_1_0._percentage = 0
end

function VersusPayloadObjectiveExtension.extensions_ready(arg_2_0)
	local var_2_0 = ScriptUnit.has_extension(arg_2_0._unit, "payload_system")

	if var_2_0 then
		arg_2_0._payload_extension = var_2_0
	end
end

function VersusPayloadObjectiveExtension._set_objective_data(arg_3_0, arg_3_1)
	local var_3_0 = GameModeSettings.versus.objectives.payload

	arg_3_0._num_sections = arg_3_1.num_sections or var_3_0.num_sections
	arg_3_0._score_per_section = arg_3_1.score_per_section or var_3_0.score_per_section
	arg_3_0._time_per_section = arg_3_1.time_per_section or var_3_0.time_per_section
	arg_3_0._score_for_completion = arg_3_1.score_for_completion or var_3_0.score_for_completion
	arg_3_0._time_for_completion = arg_3_1.time_for_completion or var_3_0.time_for_completion
	arg_3_0._on_last_leaf_complete_sound_event = arg_3_1.on_last_leaf_complete_sound_event or var_3_0.on_last_leaf_complete_sound_event
	arg_3_0._on_section_progress_sound_event = arg_3_1.on_section_progress_sound_event or var_3_0.on_section_progress_sound_event
end

function VersusPayloadObjectiveExtension._activate(arg_4_0)
	arg_4_0._spline_movement = arg_4_0._payload_extension:movement()
	arg_4_0._total_distance = arg_4_0._spline_movement:distance(1, 1, 0, #arg_4_0._spline_movement._splines, #arg_4_0._spline_movement:_current_spline().subdivisions, 1)
end

function VersusPayloadObjectiveExtension._deactivate(arg_5_0)
	return
end

function VersusPayloadObjectiveExtension._server_update(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0._payload_extension:started() then
		return
	end

	local var_6_0 = arg_6_0._spline_movement:current_spline_curve_distance()

	if var_6_0 ~= arg_6_0._current_distance then
		arg_6_0._current_distance = var_6_0

		local var_6_1 = arg_6_0:get_percentage_done()

		arg_6_0:server_set_value(var_6_1)

		if var_6_1 >= (arg_6_0._current_section + 1) * (1 / arg_6_0._num_sections) then
			arg_6_0:on_section_completed()
		end
	end
end

function VersusPayloadObjectiveExtension._client_update(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._percentage = arg_7_0:client_get_value()
end

function VersusPayloadObjectiveExtension.get_percentage_done(arg_8_0)
	if arg_8_0._is_server then
		return arg_8_0._current_distance / arg_8_0._total_distance + math.epsilon
	end

	return arg_8_0._percentage
end
