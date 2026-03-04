-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_templates.lua

local var_0_0 = require("scripts/utils/stagger_types")

DamageWaveTemplates = {}
DamageWaveTemplates.templates = {
	plague_wave_teleport = {
		trigger_dialogue_on_impact = true,
		stop_running_wave_sound = "Stop_magic_plague_wave_loop",
		buff_wave_impact_name = "plague_wave_face_base",
		create_bot_aoe_threat = true,
		launch_wave_sound = "Play_magic_plague_wave",
		fx_unit = "units/beings/enemies/chaos_sorcerer_fx/chr_chaos_sorcerer_fx",
		start_speed = 5,
		max_speed = 10,
		fx_name_arrived = "fx/chaos_sorcerer_plague_wave_hit_01",
		apply_buff_to_player = true,
		fx_separation_dist = 1.5,
		running_wave_sound = "Play_magic_plague_wave_loop",
		max_height = 2.5,
		fx_name_running = "fx/chaos_sorcerer_plauge_wave_01",
		ai_query_distance = 0.8,
		launch_animation = "wave_summon_release",
		acceleration = 10,
		overflow_dist = 5,
		player_query_distance = 0.8,
		particle_arrived_stop_mode = "stop",
		apply_impact_buff_to_ai = false,
		impact_wave_sound = "Play_magic_plague_wave_hit",
		damage_friendly_ai = true,
		apply_buff_to_ai = true,
		time_of_life = 10,
		use_nav_cost_map_volumes = false,
		fx_name_impact = "fx/plague_wave_03",
		nav_cost_map_cost_type = "plague_wave",
		apply_impact_buff_to_player = true,
		fx_name_init = "fx/chaos_sorcerer_plauge_wave_02",
		immune_breeds = {
			chaos_troll = true,
			chaos_spawn = true,
			skaven_grey_seer = true,
			chaos_exalted_sorcerer = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		ai_push_data = {
			stagger_distance = 3,
			push_along_wave_direction = true,
			stagger_impact = {
				var_0_0.explosion,
				var_0_0.heavy,
				var_0_0.none,
				var_0_0.none,
				var_0_0.explosion
			},
			stagger_duration = {
				2.5,
				1,
				0,
				0,
				4
			}
		},
		player_push_data = {
			ahead_dist = 1.5,
			push_forward_offset = 1.5,
			push_width = 1.25,
			player_pushed_speed = 20,
			dodged_width = 0.5
		}
	},
	plague_wave = {
		trigger_dialogue_on_impact = true,
		stop_running_wave_sound = "Stop_magic_plague_wave_loop",
		buff_wave_impact_name = "plague_wave_face_base",
		create_bot_aoe_threat = true,
		launch_wave_sound = "Play_magic_plague_wave",
		fx_unit = "units/beings/enemies/chaos_sorcerer_fx/chr_chaos_sorcerer_fx",
		start_speed = 10,
		max_speed = 20,
		fx_name_arrived = "fx/chaos_sorcerer_plague_wave_hit_01",
		apply_buff_to_player = true,
		fx_separation_dist = 1.5,
		running_wave_sound = "Play_magic_plague_wave_loop",
		max_height = 2.5,
		fx_name_running = "fx/chaos_sorcerer_plauge_wave_01",
		ai_query_distance = 0.8,
		launch_animation = "wave_summon_release",
		acceleration = 15,
		overflow_dist = 5,
		player_query_distance = 0.8,
		particle_arrived_stop_mode = "stop",
		apply_impact_buff_to_ai = false,
		impact_wave_sound = "Play_magic_plague_wave_hit",
		damage_friendly_ai = true,
		apply_buff_to_ai = true,
		time_of_life = 10,
		use_nav_cost_map_volumes = false,
		fx_name_impact = "fx/plague_wave_03",
		nav_cost_map_cost_type = "plague_wave",
		apply_impact_buff_to_player = true,
		fx_name_init = "fx/chaos_sorcerer_plauge_wave_02",
		immune_breeds = {
			chaos_troll = true,
			chaos_spawn = true,
			skaven_grey_seer = true,
			chaos_exalted_sorcerer = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		ai_push_data = {
			stagger_distance = 3,
			push_along_wave_direction = true,
			stagger_impact = {
				var_0_0.explosion,
				var_0_0.heavy,
				var_0_0.none,
				var_0_0.none,
				var_0_0.explosion
			},
			stagger_duration = {
				2.5,
				1,
				0,
				0,
				4
			}
		},
		player_push_data = {
			ahead_dist = 1.5,
			push_forward_offset = 1.5,
			push_width = 1.25,
			player_pushed_speed = 20,
			dodged_width = 0.5
		}
	},
	pattern_plague_wave = {
		fx_separation_dist = 1.5,
		max_speed = 15,
		fx_unit = "units/beings/enemies/chaos_sorcerer_fx/chr_chaos_sorcerer_fx",
		launch_animation = "wave_summon_release",
		buff_wave_impact_name = "plague_wave_face_base",
		overflow_dist = 5,
		fx_name_running = "fx/chaos_sorcerer_plauge_wave_01",
		fx_name_arrived = "fx/chaos_sorcerer_plague_wave_hit_01",
		start_speed = 10,
		particle_arrived_stop_mode = "stop",
		player_query_distance = 0.8,
		apply_buff_to_player = false,
		launch_wave_sound = "Play_magic_plague_wave",
		running_wave_sound = "Play_magic_plague_wave_loop",
		apply_impact_buff_to_ai = false,
		max_height = 2.5,
		impact_wave_sound = "Play_magic_plague_wave_hit",
		damage_friendly_ai = true,
		apply_buff_to_ai = false,
		time_of_life = 3,
		acceleration = 8,
		stop_running_wave_sound = "Stop_magic_plague_wave_loop",
		use_nav_cost_map_volumes = false,
		ai_query_distance = 0.8,
		fx_name_impact = "fx/plague_wave_03",
		nav_cost_map_cost_type = "plague_wave",
		apply_impact_buff_to_player = true,
		fx_name_init = "fx/chaos_sorcerer_plauge_wave_02",
		immune_breeds = {
			chaos_troll = true,
			chaos_spawn = true,
			chaos_exalted_sorcerer = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		ai_push_data = {
			stagger_distance = 3,
			push_along_wave_direction = true,
			stagger_impact = {
				var_0_0.explosion,
				var_0_0.heavy,
				var_0_0.none,
				var_0_0.none,
				var_0_0.explosion
			},
			stagger_duration = {
				2.5,
				1,
				0,
				0,
				4
			}
		},
		player_push_data = {
			ahead_dist = 1.5,
			push_forward_offset = 1.5,
			push_width = 1.25,
			player_pushed_speed = 17,
			dodged_width = 0.5
		}
	},
	vermintide = {
		fx_separation_dist = 1.5,
		max_speed = 25,
		fx_unit = "units/hub_elements/empty",
		acceleration = 25,
		buff_wave_impact_name = "vermintide_face_base",
		overflow_dist = 5,
		fx_name_running = "fx/chr_grey_seer_lightning_wave_01",
		fx_name_arrived = "fx/chr_grey_seer_lightning_hit_02",
		start_speed = 12,
		particle_arrived_stop_mode = "stop",
		player_query_distance = 1,
		apply_buff_to_player = true,
		create_bot_aoe_threat = true,
		running_wave_sound = "Play_emitter_grey_seer_electric_ground_wave",
		apply_impact_buff_to_ai = false,
		max_height = 2.5,
		stop_running_wave_sound = "Stop_emitter_grey_seer_electric_ground_wave",
		damage_friendly_ai = true,
		apply_buff_to_ai = true,
		time_of_life = 10,
		trigger_dialogue_on_impact = true,
		use_nav_cost_map_volumes = false,
		ai_query_distance = 1,
		fx_name_impact = "fx/chr_grey_seer_lightning_hit_01",
		nav_cost_map_cost_type = "plague_wave",
		apply_impact_buff_to_player = true,
		fx_name_init = "fx/chr_grey_seer_lightning_init_01",
		immune_breeds = {
			chaos_troll = true,
			chaos_spawn = true,
			skaven_grey_seer = true,
			chaos_exalted_sorcerer = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		ai_push_data = {
			stagger_distance = 3,
			push_along_wave_direction = true,
			stagger_impact = {
				var_0_0.explosion,
				var_0_0.heavy,
				var_0_0.none,
				var_0_0.none,
				var_0_0.explosion
			},
			stagger_duration = {
				2.5,
				1,
				0,
				0,
				4
			}
		},
		player_push_data = {
			ahead_dist = 1.5,
			push_forward_offset = 1.5,
			push_width = 1.25,
			player_pushed_speed = 17,
			dodged_width = 0.5
		}
	}
}
DamageWaveTemplates.templates.sienna_adept_ability_trail = {
	fx_separation_dist = 0.45,
	max_speed = 100,
	ignore_obstacles = true,
	acceleration = 100,
	overflow_dist = 0,
	buff_template_name = "sienna_adept_ability_trail",
	start_speed = 15,
	fx_name_running = "fx/brw_adept_skill_02",
	player_query_distance = 1,
	apply_buff_to_player = true,
	blob_separation_dist = 1,
	fx_name_impact = "fx/brw_adept_skill_02",
	apply_impact_buff_to_ai = false,
	max_height = 2.5,
	fx_name_arrived = "fx/brw_adept_skill_02",
	fx_name_filled = "fx/brw_adept_skill_02",
	apply_buff_to_ai = true,
	time_of_life = 6,
	particle_arrived_stop_mode = "stop",
	launch_wave_sound = "Play_sienna_adept_blink_ability",
	ai_query_distance = 2,
	buff_template_type = "sienna_adept_ability_trail",
	apply_impact_buff_to_player = false,
	fx_name_init = "fx/brw_adept_skill_02",
	immune_breeds = {},
	add_buff_func = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		if Unit.alive(arg_1_1) then
			local var_1_0 = Managers.state.entity:system("buff_system")
			local var_1_1 = FrameTable.alloc_table()

			var_1_1.attacker_unit = arg_1_3
			var_1_1.source_attacker_unit = arg_1_4

			var_1_0:add_buff_synced(arg_1_1, arg_1_2, BuffSyncType.All, var_1_1)
		end
	end,
	leave_area_func = function(arg_2_0)
		if Unit.alive(arg_2_0) then
			local var_2_0 = ScriptUnit.extension(arg_2_0, "buff_system"):get_stacking_buff("sienna_adept_ability_trail")
			local var_2_1 = var_2_0 and var_2_0[1]

			if var_2_1 then
				var_2_1.start_time = Managers.time:time("game")
				var_2_1.duration = var_2_1.template.leave_linger_time
			end
		end
	end
}
DamageWaveTemplates.templates.sienna_adept_ability_trail_increased_duration = table.clone(DamageWaveTemplates.templates.sienna_adept_ability_trail)
DamageWaveTemplates.templates.sienna_adept_ability_trail_increased_duration.time_of_life = 10
DamageWaveTemplates.templates.sienna_adept_ability_trail_increased_duration.fx_name_init = "fx/brw_adept_skill_02_upgraded"
DamageWaveTemplates.templates.sienna_adept_ability_trail_increased_duration.fx_name_running = "fx/brw_adept_skill_02_upgraded"
DamageWaveTemplates.templates.sienna_adept_ability_trail_increased_duration.fx_name_impact = "fx/brw_adept_skill_02_upgraded"
DamageWaveTemplates.templates.sienna_adept_ability_trail_increased_duration.fx_name_filled = "fx/brw_adept_skill_02_upgraded"
DamageWaveTemplates.templates.sienna_adept_ability_trail_increased_duration.fx_name_arrived = "fx/brw_adept_skill_02_upgraded"
DamageWaveTemplates.templates.thornsister_thorn_wall_push = {
	launch_wave_sound = "career_ability_kerilian_thorngrasp",
	max_speed = 10,
	ignore_obstacles = true,
	time_of_life = 6,
	acceleration = 100,
	overflow_dist = 0.2,
	fx_name_running = "fx/thorn_vines",
	particle_arrived_stop_mode = "stop",
	start_speed = 10,
	fx_unit = "units/hub_elements/empty",
	player_query_distance = 1.5,
	apply_buff_to_player = false,
	apply_impact_buff_to_ai = false,
	max_height = 2.5,
	damage_friendly_ai = true,
	apply_buff_to_ai = false,
	create_blobs = false,
	is_transient = true,
	transient_name_override = "units/beings/player/way_watcher_thornsister/abilities/ww_thornsister_thorn_wave_01",
	ai_query_distance = 1.5,
	apply_impact_buff_to_player = false,
	immune_breeds = {
		chaos_troll = true,
		chaos_spawn = true,
		skaven_grey_seer = true,
		chaos_exalted_sorcerer = true,
		skaven_rat_ogre = true,
		skaven_stormfiend = true
	},
	ai_push_data = {
		push_along_wave_direction = true,
		drag_along_wave = true,
		stagger_impact = {
			var_0_0.heavy,
			var_0_0.heavy,
			var_0_0.heavy,
			var_0_0.none,
			var_0_0.heavy,
			var_0_0.medium
		},
		stagger_duration = {
			0.5,
			0.5,
			0.5,
			0,
			0.5,
			0.5
		},
		stagger_refresh_time = {
			0.5,
			0.5,
			0.5,
			math.huge,
			0.5,
			math.huge
		},
		stagger_distance_table = {
			0.5,
			0.5,
			0.5,
			0.5,
			0.5,
			1
		},
		wave_drag_multiplier_table = {
			1,
			0.1,
			1,
			0,
			1,
			0
		}
	},
	update_func = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = arg_3_0._update_data

		if not var_3_0 then
			var_3_0 = {
				next_spawn_t = 0
			}
			arg_3_0._update_data = var_3_0
		end

		if arg_3_3 >= var_3_0.next_spawn_t and arg_3_0.wave_direction then
			local var_3_1 = "units/beings/player/way_watcher_thornsister/abilities/ww_thornsister_thorn_wave_01"
			local var_3_2 = 0.75
			local var_3_3 = 1.25
			local var_3_4 = math.rad(15)
			local var_3_5 = 0.1
			local var_3_6 = 0.1
			local var_3_7 = 0.2
			local var_3_8 = 1
			local var_3_9 = 3
			local var_3_10 = Quaternion.look(arg_3_0.wave_direction:unbox())
			local var_3_11 = arg_3_0.template.ai_query_distance
			local var_3_12 = Quaternion.right(var_3_10) * math.lerp(-var_3_11, var_3_11, math.random())
			local var_3_13 = Vector3(0, 0, -var_3_5 * math.random())
			local var_3_14, var_3_15, var_3_16, var_3_17 = ConflictUtils.get_spawn_pos_on_circle(arg_3_0.nav_world, arg_3_2 + var_3_12, 0, var_3_8, var_3_9)

			if var_3_14 then
				local var_3_18 = math.lerp(-var_3_4, var_3_4, math.random())
				local var_3_19 = Quaternion.multiply(var_3_10, Quaternion.axis_angle(Vector3.up(), var_3_18))
				local var_3_20 = Vector3.normalize(Vector3.cross(var_3_16 - var_3_15, var_3_17 - var_3_15))
				local var_3_21 = Quaternion.forward(var_3_19)
				local var_3_22 = Vector3.cross(var_3_21, var_3_20)
				local var_3_23 = Vector3.cross(var_3_20, var_3_22)
				local var_3_24 = Quaternion.look(var_3_23, var_3_20)
				local var_3_25 = Managers.state.unit_spawner:spawn_local_unit(var_3_1, var_3_14 + var_3_13, var_3_24)
				local var_3_26 = math.lerp(var_3_2, var_3_3, math.random())

				Unit.set_local_scale(var_3_25, 0, Vector3(var_3_26, var_3_26, var_3_26))
			end

			var_3_0.next_spawn_t = arg_3_3 + math.lerp(var_3_6, var_3_7, math.random())
		end
	end,
	on_arrive_func = function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = arg_4_0.optional_data

		if var_4_0 then
			local var_4_1 = "we_thornsister_career_skill_wall_explosion"
			local var_4_2 = 1
			local var_4_3 = arg_4_0.source_unit
			local var_4_4 = var_4_0.power_level

			Managers.state.entity:system("area_damage_system"):create_explosion(var_4_3, arg_4_1, arg_4_2, var_4_1, var_4_2, "career_ability", var_4_4, false)

			local var_4_5 = var_4_0.wall_index
			local var_4_6 = var_4_0.boxed_wall_segments

			for iter_4_0 = 1, #var_4_6 do
				local var_4_7 = var_4_6[iter_4_0]:unbox()

				Managers.state.unit_spawner:request_spawn_template_unit("thornsister_thorn_wall_unit", var_4_7, arg_4_2, var_4_3, var_4_5, iter_4_0)
			end
		end
	end
}

local function var_0_1(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_1 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), -arg_5_3), arg_5_2)
	local var_5_1, var_5_2 = GwNavQueries.raycast(arg_5_0, arg_5_1, var_5_0)
	local var_5_3 = Vector3.normalize(var_5_2 - arg_5_1)

	if var_5_1 then
		return true, var_5_2, var_5_3
	end

	return false, var_5_2, var_5_3
end

DamageWaveTemplates.templates.necromancer_curse_wave = {
	stop_running_wave_sound = "Stop_career_necro_ability_withering_wave_loop",
	max_speed = 4,
	ignore_obstacles = true,
	num_waves = 1,
	acceleration = 0,
	overflow_dist = 0.2,
	buff_wave_impact_name = "sienna_necromancer_career_skill_on_hit_damage",
	fx_name_running = "fx/necromancer_wave",
	start_speed = 4,
	particle_arrived_stop_mode = "stop",
	player_query_distance = 2.2,
	apply_buff_to_player = false,
	running_wave_sound = "Play_career_necro_ability_withering_wave_loop",
	apply_impact_buff_to_ai = true,
	max_height = 2.5,
	fx_unit = "units/hub_elements/empty",
	damage_friendly_ai = false,
	apply_buff_to_ai = false,
	time_of_life = 3.5,
	spawn_separation_dist = 0.4,
	target_separation_dist = 1.5,
	apply_impact_buff_to_player = false,
	immune_breeds = {},
	running_spawn_config = {
		{
			separation_type = "box",
			spawn_type = "unit",
			start_delay = 0,
			max_random_angle = 0,
			frequency = 1,
			names = {
				"units/decals/necromancer_ability_decal"
			},
			bounds = {
				0,
				0,
				0
			},
			offset = {
				0,
				4,
				0
			},
			on_spawn = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = Vector3(5, 6, 5)

				Unit.set_local_scale(arg_6_3, 0, var_6_0)

				local var_6_1 = World.time(Application.main_world())
				local var_6_2 = DamageWaveTemplates.templates.necromancer_curse_wave.start_speed
				local var_6_3 = var_6_1 + var_6_0.y / var_6_2
				local var_6_4 = Vector2(0, 1)

				Unit.set_vector2_for_material(arg_6_3, "projector", "start_end_time", Vector2(var_6_1, var_6_3))
				Unit.set_vector2_for_material(arg_6_3, "projector", "fade_direction", var_6_4)
				Unit.set_scalar_for_material(arg_6_3, "projector", "trailing_fade_delay", 1.5)
			end
		},
		{
			separation_type = "box",
			spawn_type = "unit",
			start_delay = 0,
			max_random_angle = 0,
			frequency = 0.5,
			names = {
				"units/decals/necromancer_ability_decal_mark1",
				"units/decals/necromancer_ability_decal_mark2",
				"units/decals/necromancer_ability_decal_mark3",
				"units/decals/necromancer_ability_decal_mark4",
				"units/decals/necromancer_ability_decal_mark5",
				"units/decals/necromancer_ability_decal_mark6"
			},
			bounds = {
				0.4,
				2,
				0
			},
			offset = {
				-1.1,
				4,
				0
			},
			on_spawn = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				local var_7_0 = Vector3(1, 1, 1)

				Unit.set_local_scale(arg_7_3, 0, var_7_0)

				local var_7_1 = World.time(Application.main_world())
				local var_7_2 = var_7_1 + 3
				local var_7_3 = 1.5

				Unit.set_vector2_for_material(arg_7_3, "projector", "start_end_time", Vector2(var_7_1, var_7_2))
				Unit.set_scalar_for_material(arg_7_3, "projector", "fade_time", var_7_3)
				Unit.set_scalar_for_material(arg_7_3, "projector", "enable_fade", 1)
			end
		},
		{
			separation_type = "box",
			spawn_type = "unit",
			start_delay = 0.25,
			max_random_angle = 0,
			frequency = 0.5,
			names = {
				"units/decals/necromancer_ability_decal_mark1",
				"units/decals/necromancer_ability_decal_mark2",
				"units/decals/necromancer_ability_decal_mark3",
				"units/decals/necromancer_ability_decal_mark4",
				"units/decals/necromancer_ability_decal_mark5",
				"units/decals/necromancer_ability_decal_mark6"
			},
			bounds = {
				0.4,
				2,
				0
			},
			offset = {
				1.4,
				4,
				0
			},
			on_spawn = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = Vector3(1, 1, 1)

				Unit.set_local_scale(arg_8_3, 0, var_8_0)

				local var_8_1 = World.time(Application.main_world())
				local var_8_2 = var_8_1 + 3
				local var_8_3 = 1.5

				Unit.set_vector2_for_material(arg_8_3, "projector", "start_end_time", Vector2(var_8_1, var_8_2))
				Unit.set_scalar_for_material(arg_8_3, "projector", "fade_time", var_8_3)
				Unit.set_scalar_for_material(arg_8_3, "projector", "enable_fade", 1)
			end
		}
	},
	ai_push_data = {
		push_along_wave_direction = true,
		drag_along_wave = false,
		stagger_impact = {
			var_0_0.heavy,
			var_0_0.heavy,
			var_0_0.heavy,
			var_0_0.none,
			var_0_0.heavy,
			var_0_0.heavy
		},
		stagger_duration = {
			0.7,
			0.7,
			0,
			0,
			0.7,
			0.5
		},
		stagger_refresh_time = {
			math.huge,
			math.huge,
			math.huge,
			math.huge,
			math.huge,
			math.huge
		},
		stagger_distance_table = {
			0.5,
			0.5,
			0.5,
			0.5,
			0.5,
			1
		},
		wave_drag_multiplier_table = {
			1,
			0.1,
			0,
			0,
			1,
			0
		},
		hit_half_extends = {
			2.5,
			0.5,
			1.5
		}
	},
	update_func = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		if not arg_9_0.wave_direction then
			return
		end

		local var_9_0 = arg_9_0._update_data

		if not var_9_0 then
			local var_9_1 = arg_9_0.wave_direction:unbox()

			var_9_0 = {
				next_spawn_t = 0,
				failed_attempts = 0,
				next_direction_update_t = 0,
				hand_units_by_player = {},
				original_direction = Vector3Box(var_9_1),
				last_pos = Vector3Box(arg_9_2 - var_9_1)
			}
			arg_9_0._update_data = var_9_0
		end

		if script_data.debug_necromancer_curse_wave then
			QuickDrawer:sphere(arg_9_2, 0.5)
		end

		if not Managers.player.is_server then
			return
		end

		if arg_9_3 >= var_9_0.next_direction_update_t then
			if var_9_0.next_direction then
				arg_9_0.wave_direction = var_9_0.next_direction
				var_9_0.next_direction = nil
			end

			local var_9_2 = arg_9_0.acceleration

			assert(not var_9_2 or var_9_2 == 0, "Calculations won't be accurate if wave has acceleration")

			local var_9_3 = DamageWaveTemplates.templates.necromancer_curse_wave.ai_query_distance
			local var_9_4 = arg_9_0.wave_speed
			local var_9_5 = arg_9_0.wave_direction:unbox() * var_9_4 * var_9_3
			local var_9_6 = arg_9_2
			local var_9_7 = arg_9_2 + var_9_0.original_direction:unbox() * var_9_4 * var_9_3 * 2
			local var_9_8 = Managers.state.entity:system("ai_system"):nav_world()
			local var_9_9, var_9_10 = GwNavQueries.raycast(var_9_8, var_9_6, var_9_7)
			local var_9_11

			if var_9_9 or Vector3.distance_squared(var_9_6, var_9_10) > var_9_3 * var_9_3 then
				var_9_0.next_direction = var_9_0.original_direction
				var_9_11 = var_9_10
			else
				local var_9_12 = var_9_6 + var_9_5
				local var_9_13

				var_9_9, var_9_13 = GwNavQueries.raycast(var_9_8, var_9_6, var_9_12)

				if var_9_9 then
					var_9_0.next_direction_update_t = arg_9_3 + 1
				elseif var_9_0.failed_attempts < 4 then
					local var_9_14 = var_9_13 + Vector3.normalize(var_9_6 - var_9_13) * var_9_3
					local var_9_15 = math.pi * 0.25

					repeat
						local var_9_16
						local var_9_17

						var_9_9, var_9_11, var_9_17 = var_0_1(var_9_8, var_9_14, var_9_5, -var_9_15)

						if var_9_9 then
							var_9_0.next_direction = Vector3Box(var_9_17)

							break
						end

						local var_9_18

						var_9_9, var_9_11, var_9_18 = var_0_1(var_9_8, var_9_14, var_9_5, var_9_15)

						if var_9_9 then
							var_9_0.next_direction = Vector3Box(var_9_18)

							break
						end

						local var_9_19

						var_9_9, var_9_11, var_9_19 = var_0_1(var_9_8, var_9_14, var_9_5, -2 * var_9_15)

						if var_9_9 then
							var_9_0.next_direction = Vector3Box(var_9_19)

							break
						end

						local var_9_20

						var_9_9, var_9_11, var_9_20 = var_0_1(var_9_8, var_9_14, var_9_5, 2 * var_9_15)

						if var_9_9 then
							var_9_0.next_direction = Vector3Box(var_9_20)
						end

						break
					until true
				end
			end

			if var_9_9 then
				var_9_0.next_direction_update_t = arg_9_3 + 1
				var_9_0.failed_attempts = 0
			elseif var_9_11 then
				var_9_0.next_direction_update_t = arg_9_3 + (Vector3.distance(var_9_11, var_9_6) - var_9_3) / var_9_4
				var_9_0.failed_attempts = var_9_0.failed_attempts + 1
			end
		end
	end,
	on_arrive_func = function(arg_10_0, arg_10_1, arg_10_2)
		return
	end
}

local var_0_2 = table.clone(DamageWaveTemplates.templates.necromancer_curse_wave)

var_0_2.fx_name_filled = "fx/necromancer_wave_linger"
var_0_2.fx_separation_dist = 1.5
var_0_2.blob_separation_dist = 1
var_0_2.apply_buff_to_owner = true
var_0_2.buff_template_name = "sienna_necromancer_empowered_overcharge"
var_0_2.buff_template_type = "sienna_necromancer_empowered_overcharge"

function var_0_2.add_buff_func(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if not ALIVE[arg_11_1] or not Managers.state.network.is_server then
		return
	end

	if arg_11_1 ~= arg_11_0.source_unit then
		return
	end

	local var_11_0 = Managers.player:owner(arg_11_1)

	if not var_11_0 then
		return
	end

	local var_11_1 = ScriptUnit.extension(arg_11_1, "buff_system"):get_stacking_buff(arg_11_2)

	if not (var_11_1 and var_11_1[1]) then
		Managers.state.entity:system("buff_system"):add_buff_synced(arg_11_1, "sienna_necromancer_empowered_overcharge", BuffSyncType.ClientAndServer, nil, var_11_0.peer_id)
	end
end

function var_0_2.leave_area_func(arg_12_0)
	if ALIVE[arg_12_0] then
		local var_12_0 = ScriptUnit.extension(arg_12_0, "buff_system")
		local var_12_1 = var_12_0:get_stacking_buff("sienna_necromancer_empowered_overcharge")
		local var_12_2 = var_12_1 and var_12_1[1]

		if var_12_2 then
			var_12_0:remove_buff(var_12_2.id)
		end
	end
end

DamageWaveTemplates.templates.necromancer_curse_wave_linger = var_0_2

for iter_0_0, iter_0_1 in pairs(DamageWaveTemplates.templates) do
	local var_0_3 = iter_0_1.ai_push_data
	local var_0_4 = var_0_3 and var_0_3.hit_half_extends

	if var_0_4 then
		fassert(not iter_0_1.ai_query_distance, "[DamageWaveTemplates] 'ai_query_distance' will be overridden by 'hit_half_extends'. (%s)", iter_0_0)

		local var_0_5 = Vector3Aux.unbox(var_0_4)

		iter_0_1.ai_query_distance = Vector3.length(var_0_5)
	end
end
