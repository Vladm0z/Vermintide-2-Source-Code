-- chunkname: @scripts/unit_extensions/objectives/versus_mission_objective_extension.lua

VersusMissionObjectiveExtension = class(VersusMissionObjectiveExtension, BaseObjectiveExtension)
VersusMissionObjectiveExtension.NAME = "VersusMissionObjectiveExtension"

function VersusMissionObjectiveExtension.init(arg_1_0, ...)
	VersusMissionObjectiveExtension.super.init(arg_1_0, ...)

	arg_1_0._mission_system = Managers.state.entity:system("mission_system")
	arg_1_0._percentage = 0
end

function VersusMissionObjectiveExtension._set_objective_data(arg_2_0, arg_2_1)
	local var_2_0 = GameModeSettings.versus.objectives.mission

	arg_2_0._score_for_completion = arg_2_1.score_for_completion or var_2_0.score_for_completion
	arg_2_0._time_for_completion = arg_2_1.time_for_completion or var_2_0.time_for_completion
	arg_2_0._on_last_leaf_complete_sound_event = arg_2_1.on_last_leaf_complete_sound_event or var_2_0.on_last_leaf_complete_sound_event
	arg_2_0._on_leaf_complete_sound_event = arg_2_1.on_leaf_complete_sound_event or var_2_0.on_leaf_complete_sound_event
	arg_2_0._on_section_progress_sound_event = arg_2_1.on_section_progress_sound_event or var_2_0.on_section_progress_sound_event
	arg_2_0._mission_name = arg_2_1.mission_name
end

function VersusMissionObjectiveExtension._activate(arg_3_0)
	return
end

function VersusMissionObjectiveExtension._deactivate(arg_4_0)
	return
end

function VersusMissionObjectiveExtension._server_update(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._mission_system.completed_missions[arg_5_0._mission_name] ~= nil then
		arg_5_0._percentage = 1

		arg_5_0:server_set_value(arg_5_0._percentage)
	end
end

function VersusMissionObjectiveExtension._client_update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._percentage = arg_6_0:client_get_value()
end

function VersusMissionObjectiveExtension.get_percentage_done(arg_7_0)
	return arg_7_0._percentage
end
