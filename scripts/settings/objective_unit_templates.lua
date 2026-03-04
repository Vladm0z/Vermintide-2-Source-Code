-- chunkname: @scripts/settings/objective_unit_templates.lua

ObjectiveUnitTemplates = {}
ObjectiveUnitTemplates.objective_group = {
	unit_name = "units/hub_elements/empty",
	unit_template_name = "objective_group",
	create_extension_init_data_func = function(arg_1_0, arg_1_1, arg_1_2)
		return {
			objective_system = {
				objective_name = arg_1_0,
				on_start_func = arg_1_1.on_start_func,
				on_enter_func = arg_1_1.on_enter_func,
				on_progress_func = arg_1_1.on_progress_func,
				on_exit_func = arg_1_1.on_exit_func,
				on_complete_func = arg_1_1.on_complete_func
			}
		}
	end
}
ObjectiveUnitTemplates.weave_capture_point = {
	unit_name = "units/gameplay/weave_capture_point",
	unit_template_name = "weave_capture_point_unit",
	create_extension_init_data_func = function(arg_2_0, arg_2_1, arg_2_2)
		return {
			objective_system = {
				objective_name = arg_2_0,
				timer = arg_2_1.timer,
				percentage_of_players_required = arg_2_1.percentage_of_players_required,
				capture_rate_multiplier = arg_2_1.capture_rate_multiplier,
				scale = Unit.local_scale(arg_2_2, 0),
				terror_event_spawner_id = Unit.get_data(arg_2_2, "terror_event_spawner_id"),
				on_start_func = arg_2_1.on_start_func,
				on_enter_func = arg_2_1.on_enter_func,
				on_progress_func = arg_2_1.on_progress_func,
				on_exit_func = arg_2_1.on_exit_func,
				on_complete_func = arg_2_1.on_complete_func
			}
		}
	end
}
ObjectiveUnitTemplates.weave_target = {
	unit_name = "units/props/generic/weave_target",
	unit_template_name = "weave_target_unit",
	create_extension_init_data_func = function(arg_3_0, arg_3_1, arg_3_2)
		return {
			objective_system = {
				objective_name = arg_3_0,
				attacks_allowed = arg_3_1.attacks_allowed,
				terror_event_spawner_id = Unit.get_data(arg_3_2, "terror_event_spawner_id"),
				on_start_func = arg_3_1.on_start_func,
				on_progress_func = arg_3_1.on_progress_func,
				on_complete_func = arg_3_1.on_complete_func
			},
			health_system = {
				health = arg_3_1.health,
				damage_per_hit = arg_3_1.damage_per_hit,
				health_regen = arg_3_1.health_regen
			}
		}
	end
}
ObjectiveUnitTemplates.weave_interaction = {
	unit_name = "units/gameplay/weave_interaction",
	unit_template_name = "weave_interaction_unit",
	create_extension_init_data_func = function(arg_4_0, arg_4_1, arg_4_2)
		return {
			objective_system = {
				objective_name = arg_4_0,
				terror_event_spawner_id = Unit.get_data(arg_4_2, "terror_event_spawner_id"),
				on_start_func = arg_4_1.on_start_func,
				on_interact_start_func = arg_4_1.on_interact_start_func,
				on_interact_interupt_func = arg_4_1.on_interact_interupt_func,
				on_interact_complete_func = arg_4_1.on_interact_complete_func,
				on_progress_func = arg_4_1.on_progress_func,
				on_complete_func = arg_4_1.on_complete_func,
				duration = arg_4_1.duration,
				num_times_to_complete = arg_4_1.num_times_to_complete
			}
		}
	end
}
ObjectiveUnitTemplates.weave_doom_wheel = {
	unit_name = "units/gameplay/weave/weave_prop_skaven_doom_wheel_01",
	unit_template_name = "weave_doom_wheel",
	create_extension_init_data_func = function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = Unit.get_data(arg_5_2, "group_name")

		return {
			objective_system = {
				objective_name = arg_5_0,
				terror_event_spawner_id = Unit.get_data(arg_5_2, "terror_event_spawner_id"),
				timer = arg_5_1.timer,
				on_socket_start_func = arg_5_1.on_socket_start_func,
				on_socket_progress_func = arg_5_1.on_socket_progress_func,
				on_socket_complete_func = arg_5_1.on_socket_complete_func,
				on_fuze_start_func = arg_5_1.on_fuze_start_func,
				on_fuze_progress_func = arg_5_1.on_fuze_progress_func,
				on_fuze_complete_func = arg_5_1.on_fuze_complete_func
			}
		}
	end
}
ObjectiveUnitTemplates.weave_kill_enemies = {
	unit_name = "units/gameplay/weave_kill_enemies",
	unit_template_name = "weave_kill_enemies_unit",
	create_extension_init_data_func = function(arg_6_0, arg_6_1, arg_6_2)
		return {
			objective_system = {
				objective_name = arg_6_0,
				on_start_func = arg_6_1.on_start_func,
				on_progress_func = arg_6_1.on_progress_func,
				on_complete_func = arg_6_1.on_complete_func,
				base_score_per_kill = arg_6_1.base_score_per_kill,
				breed_score_multipliers = arg_6_1.breed_score_multipliers,
				score_multiplier = arg_6_1.score_multiplier,
				amount = arg_6_1.amount,
				breeds_allowed = arg_6_1.breeds_allowed,
				races_allowed = arg_6_1.races_allowed,
				hit_zones_allowed = arg_6_1.hit_zones_allowed,
				attacks_allowed = arg_6_1.attacks_allowed,
				damage_types_allowed = arg_6_1.damage_types_allowed
			}
		}
	end
}
ObjectiveUnitTemplates.versus_volume_objective = {
	unit_name = "units/gameplay/versus_volume_objective",
	unit_template_name = "versus_volume_objective_unit",
	create_extension_init_data_func = function(arg_7_0, arg_7_1, arg_7_2)
		return {
			objective_system = {
				objective_name = arg_7_0,
				scale = Unit.local_scale(arg_7_2, 0),
				description = arg_7_1.description,
				on_complete_func = arg_7_1.on_complete_func,
				num_sections = arg_7_1.num_sections,
				score_per_section = arg_7_1.score_per_section,
				time_per_section = arg_7_1.time_per_section,
				score_for_completion = arg_7_1.score_for_completion,
				time_for_completion = arg_7_1.time_for_completion,
				on_last_leaf_complete_sound_event = arg_7_1.on_last_leaf_complete_sound_event,
				on_leaf_complete_sound_event = arg_7_1.on_leaf_complete_sound_event,
				on_section_progress_sound_event = arg_7_1.on_section_progress_sound_event
			}
		}
	end
}
ObjectiveUnitTemplates.versus_capture_point_objective = {
	unit_name = "units/gameplay/versus_capture_point_objective",
	unit_template_name = "versus_capture_point_objective_unit",
	create_extension_init_data_func = function(arg_8_0, arg_8_1, arg_8_2)
		return {
			objective_system = {
				objective_name = arg_8_0,
				scale = Unit.local_scale(arg_8_2, 0),
				description = arg_8_1.description,
				on_complete_func = arg_8_1.on_complete_func,
				num_sections = arg_8_1.num_sections,
				score_per_section = arg_8_1.score_per_section,
				time_per_section = arg_8_1.time_per_section,
				score_for_completion = arg_8_1.score_for_completion,
				time_for_completion = arg_8_1.time_for_completion,
				capture_rate_multiplier = arg_8_1.capture_rate_multiplier,
				capture_time = arg_8_1.capture_time,
				on_last_leaf_complete_sound_event = arg_8_1.on_last_leaf_complete_sound_event,
				on_leaf_complete_sound_event = arg_8_1.on_leaf_complete_sound_event,
				on_section_progress_sound_event = arg_8_1.on_section_progress_sound_event
			}
		}
	end
}
ObjectiveUnitTemplates.versus_mission_objective = {
	unit_name = "units/gameplay/versus_mission_objective",
	unit_template_name = "versus_mission_objective_unit",
	create_extension_init_data_func = function(arg_9_0, arg_9_1, arg_9_2)
		return {
			objective_system = {
				objective_name = arg_9_0,
				scale = Unit.local_scale(arg_9_2, 0),
				description = arg_9_1.description,
				on_complete_func = arg_9_1.on_complete_func,
				num_sections = arg_9_1.num_sections,
				score_per_section = arg_9_1.score_per_section,
				time_per_section = arg_9_1.time_per_section,
				score_for_completion = arg_9_1.score_for_completion,
				time_for_completion = arg_9_1.time_for_completion,
				on_last_leaf_complete_sound_event = arg_9_1.on_last_leaf_complete_sound_event,
				on_leaf_complete_sound_event = arg_9_1.on_leaf_complete_sound_event,
				on_section_progress_sound_event = arg_9_1.on_section_progress_sound_event
			}
		}
	end
}
