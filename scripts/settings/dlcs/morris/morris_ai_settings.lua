-- chunkname: @scripts/settings/dlcs/morris/morris_ai_settings.lua

local morris = DLCSettings.morris

morris.vortex_templates = {
	blood_storm = {
		override_movement_speed = 3,
		outer_fx_z_scale_multiplier = 0.1,
		min_inner_radius = 0.38,
		inner_fx_z_scale_multiplier = 0.1,
		medium_cost_nav_cost_map_cost_type = "vortex_near",
		min_outer_radius = 2,
		player_actions_allowed = true,
		stop_sound_event_name = "Stop_curse_blood_storm_loop",
		outer_fx_name = "fx/deus_bloodstorm_vortex_small_outer",
		full_fx_radius = 6,
		high_cost_nav_cost_map_cost_type = "vortex_danger_zone",
		min_fx_radius = 2,
		inner_fx_name = "fx/deus_bloodstorm_vortex_small",
		windup_time = 3,
		random_wander = true,
		stop_and_process_player = false,
		max_height = 10,
		start_sound_event_name = "Play_curse_blood_storm_loop",
		full_inner_radius = 4,
		post_vortex_buff = "vortex_base",
		damage = 5,
		full_outer_radius = 6,
		forced_standing_still = false,
		use_nav_cost_map_volumes = true,
		breed_name = "chaos_vortex",
		max_allowed_inner_radius_dist = 3.5,
		start_radius = 0.1,
		time_of_life = {
			4,
			6
		}
	}
}
morris.breeds = {
	"scripts/settings/breeds/breed_chaos_greed_pinata",
	"scripts/settings/breeds/breed_chaos_curse_mutator_sorcerer"
}
morris.behaviour_trees = {
	"scripts/entity_system/systems/behaviour/trees/chaos/chaos_greed_pinata_behavior",
	"scripts/entity_system/systems/behaviour/trees/chaos/chaos_curse_mutator_sorcerer_behavior"
}
morris.behaviour_trees_precompiled = {
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_chaos_greed_pinata",
	"scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_curse_mutator_sorcerer"
}
morris.health_extensions = {
	"GreedPinataHealthExtension"
}
morris.ai_breed_snippets_file_names = {
	"scripts/settings/dlcs/morris/morris_ai_breed_snippets"
}
morris.bt_enter_hooks = {
	on_skulking_sorcerer_grab = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		ScriptUnit.extension(arg_1_0, "health_system").is_invincible = false

		local target_unit = arg_1_1.target_unit
		local extension_input = ScriptUnit.extension_input(target_unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_dialogue_event("curse_damage_taken", alloc_table)
	end
}
