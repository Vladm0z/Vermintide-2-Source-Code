-- chunkname: @scripts/unit_extensions/objectives/versus_target_objective_extension.lua

VersusTargetObjectiveExtension = class(VersusTargetObjectiveExtension, BaseObjectiveExtension)
VersusTargetObjectiveExtension.NAME = "VersusTargetObjectiveExtension"

VersusTargetObjectiveExtension._set_objective_data = function (arg_1_0, arg_1_1)
	local var_1_0 = GameModeSettings.versus.objectives.target

	arg_1_0._num_sections = arg_1_1.num_sections or var_1_0.num_sections
	arg_1_0._score_per_section = arg_1_1.score_per_section or var_1_0.score_per_section
	arg_1_0._time_per_section = arg_1_1.time_per_section or var_1_0.time_per_section
	arg_1_0._score_for_completion = arg_1_1.score_for_completion or var_1_0.score_for_completion
	arg_1_0._time_for_completion = arg_1_1.time_for_completion or var_1_0.time_for_completion
	arg_1_0._on_last_leaf_complete_sound_event = arg_1_1.on_last_leaf_complete_sound_event or var_1_0.on_last_leaf_complete_sound_event
	arg_1_0._on_leaf_complete_sound_event = arg_1_1.on_leaf_complete_sound_event or var_1_0.on_leaf_complete_sound_event
	arg_1_0._on_section_progress_sound_event = arg_1_1.on_section_progress_sound_event or var_1_0.on_section_progress_sound_event
end

VersusTargetObjectiveExtension._activate = function (arg_2_0)
	return
end

VersusTargetObjectiveExtension.extensions_ready = function (arg_3_0)
	arg_3_0._health_extension = ScriptUnit.has_extension(arg_3_0._unit, "health_system")
	arg_3_0._max_health = arg_3_0._health_extension:current_health()
	arg_3_0._health = arg_3_0._max_health
end

VersusTargetObjectiveExtension._deactivate = function (arg_4_0)
	return
end

VersusTargetObjectiveExtension._store_position = function (arg_5_0)
	return
end

VersusTargetObjectiveExtension._server_update = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._health = arg_6_0._health_extension:current_health()

	if arg_6_0:get_percentage_done() >= (arg_6_0._current_section + 1) * (1 / arg_6_0._num_sections) then
		arg_6_0:on_section_completed()
	end
end

VersusTargetObjectiveExtension._client_update = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._health = arg_7_0._health_extension:current_health()
end

VersusTargetObjectiveExtension.get_percentage_done = function (arg_8_0)
	if arg_8_0._max_health == 0 then
		return 1
	end

	return math.clamp01(1 - arg_8_0._health / arg_8_0._max_health + math.epsilon)
end
