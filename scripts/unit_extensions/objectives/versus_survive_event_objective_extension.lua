-- chunkname: @scripts/unit_extensions/objectives/versus_survive_event_objective_extension.lua

VersusSurviveEventObjectiveExtension = class(VersusSurviveEventObjectiveExtension, BaseObjectiveExtension)
VersusSurviveEventObjectiveExtension.NAME = "VersusSurviveEventObjectiveExtension"

function VersusSurviveEventObjectiveExtension.init(arg_1_0, ...)
	VersusSurviveEventObjectiveExtension.super.init(arg_1_0, ...)

	arg_1_0._survive_time_done = 0
	arg_1_0._remaining_survive_time = 0
	arg_1_0._current_time_survived = 0
	arg_1_0._percentage = 0
end

function VersusSurviveEventObjectiveExtension._set_objective_data(arg_2_0, arg_2_1)
	local var_2_0 = GameModeSettings.versus.objectives.survive_event

	arg_2_0._num_sections = arg_2_1.num_sections or var_2_0.num_sections
	arg_2_0._score_per_section = arg_2_1.score_per_section or var_2_0.score_per_section
	arg_2_0._time_per_section = arg_2_1.time_per_section or var_2_0.time_per_section
	arg_2_0._score_for_completion = arg_2_1.score_for_completion or var_2_0.score_for_completion
	arg_2_0._time_for_completion = arg_2_1.time_for_completion or var_2_0.time_for_completion
	arg_2_0._on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event or var_2_0.on_last_leaf_complete_sound_event
	arg_2_0._on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event or var_2_0.on_leaf_complete_sound_event
	arg_2_0._on_section_progress_sound_event = arg_2_1.on_section_progress_sound_event or var_2_0.on_section_progress_sound_event
end

function VersusSurviveEventObjectiveExtension._activate(arg_3_0)
	arg_3_0._survive_time_done = Managers.time:time("game") + arg_3_0._time_for_completion
end

function VersusSurviveEventObjectiveExtension._deactivate(arg_4_0)
	return
end

function VersusSurviveEventObjectiveExtension._server_update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = math.clamp(arg_5_0._survive_time_done - arg_5_2, 0, arg_5_0._time_for_completion)

	if var_5_0 ~= arg_5_0._remaining_survive_time then
		arg_5_0._remaining_survive_time = var_5_0

		local var_5_1 = arg_5_0:get_percentage_done()

		arg_5_0:server_set_value(var_5_1)

		if var_5_1 >= (arg_5_0._current_section + 1) * (1 / arg_5_0._num_sections) then
			arg_5_0:on_section_completed()
		end
	end
end

function VersusSurviveEventObjectiveExtension._client_update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._percentage = arg_6_0:client_get_value()
end

function VersusSurviveEventObjectiveExtension.update_testify(arg_7_0, arg_7_1, arg_7_2)
	return
end

function VersusSurviveEventObjectiveExtension.get_percentage_done(arg_8_0)
	if arg_8_0._is_server then
		local var_8_0 = 1 - arg_8_0._remaining_survive_time / arg_8_0._time_for_completion

		return math.clamp(var_8_0, 0, 1)
	end

	return arg_8_0._percentage
end
