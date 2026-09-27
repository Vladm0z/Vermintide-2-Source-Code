-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_templates.lua

local scripts_utils_stagger_types = require("scripts/utils/stagger_types")

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
				scripts_utils_stagger_types.explosion,
				scripts_utils_stagger_types.heavy,
				scripts_utils_stagger_types.none,
				scripts_utils_stagger_types.none,
				scripts_utils_stagger_types.explosion
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
				scripts_utils_stagger_types.explosion,
				scripts_utils_stagger_types.heavy,
				scripts_utils_stagger_types.none,
				scripts_utils_stagger_types.none,
				scripts_utils_stagger_types.explosion
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
				scripts_utils_stagger_types.explosion,
				scripts_utils_stagger_types.heavy,
				scripts_utils_stagger_types.none,
				scripts_utils_stagger_types.none,
				scripts_utils_stagger_types.explosion
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
				scripts_utils_stagger_types.explosion,
				scripts_utils_stagger_types.heavy,
				scripts_utils_stagger_types.none,
				scripts_utils_stagger_types.none,
				scripts_utils_stagger_types.explosion
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
	add_buff_func = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		-- function 1
		if not Unit.alive(arg_1_1) then
			local system = Managers.state.entity:system("buff_system")
			local alloc_table = FrameTable.alloc_table()

			alloc_table.attacker_unit = arg_1_3
			alloc_table.source_attacker_unit = arg_1_4

			system:add_buff_synced(arg_1_1, arg_1_2, BuffSyncType.All, alloc_table)
		end
	end,
	leave_area_func = function (arg_2_0)
		-- function 2
		if not Unit.alive(arg_2_0) then
			local get_stacking_buff = ScriptUnit.extension(arg_2_0, "buff_system"):get_stacking_buff("sienna_adept_ability_trail")
			local flag = not get_stacking_buff and get_stacking_buff[1]

			if not flag then
				flag.start_time = Managers.time:time("game")
				flag.duration = flag.template.leave_linger_time
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
			scripts_utils_stagger_types.heavy,
			scripts_utils_stagger_types.heavy,
			scripts_utils_stagger_types.heavy,
			scripts_utils_stagger_types.none,
			scripts_utils_stagger_types.heavy,
			scripts_utils_stagger_types.medium
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
	update_func = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		local _update_data = self._update_data

		if not _update_data then
			_update_data = {
				next_spawn_t = 0
			}
			self._update_data = _update_data
		end

		if not (arg_3_3 >= _update_data.next_spawn_t) or not self.wave_direction then
			local str = "units/beings/player/way_watcher_thornsister/abilities/ww_thornsister_thorn_wave_01"
			local num = 0.75
			local num_2 = 1.25
			local rad = math.rad(15)
			local num_3 = 0.1
			local num_4 = 0.1
			local num_5 = 0.2
			local num_6 = 1
			local num_7 = 3
			local look = Quaternion.look(self.wave_direction:unbox())
			local ai_query_distance = self.template.ai_query_distance
			local num_8 = Quaternion.right(look) * math.lerp(-ai_query_distance, ai_query_distance, math.random())
			local var_3_13 = Vector3(0, 0, -num_3 * math.random())
			local get_spawn_pos_on_circle, var_3_15, var_3_16, var_3_17 = ConflictUtils.get_spawn_pos_on_circle(self.nav_world, arg_3_2 + num_8, 0, num_6, num_7)

			if not get_spawn_pos_on_circle then
				local lerp = math.lerp(-rad, rad, math.random())
				local multiply = Quaternion.multiply(look, Quaternion.axis_angle(Vector3.up(), lerp))
				local normalize = Vector3.normalize(Vector3.cross(var_3_16 - var_3_15, var_3_17 - var_3_15))
				local forward = Quaternion.forward(multiply)
				local cross = Vector3.cross(forward, normalize)
				local cross_2 = Vector3.cross(normalize, cross)
				local look_2 = Quaternion.look(cross_2, normalize)
				local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(str, get_spawn_pos_on_circle + var_3_13, look_2)
				local lerp_2 = math.lerp(num, num_2, math.random())

				Unit.set_local_scale(spawn_local_unit, 0, Vector3(lerp_2, lerp_2, lerp_2))
			end

			_update_data.next_spawn_t = arg_3_3 + math.lerp(num_4, num_5, math.random())
		end
	end,
	on_arrive_func = function (self, arg_4_1, arg_4_2)
		-- function 4
		local optional_data = self.optional_data

		if not optional_data then
			local str = "we_thornsister_career_skill_wall_explosion"
			local num = 1
			local source_unit = self.source_unit
			local power_level = optional_data.power_level

			Managers.state.entity:system("area_damage_system"):create_explosion(source_unit, arg_4_1, arg_4_2, str, num, "career_ability", power_level, false)

			local wall_index = optional_data.wall_index
			local boxed_wall_segments = optional_data.boxed_wall_segments

			for i = 1, #boxed_wall_segments do
				local unbox = boxed_wall_segments[i]:unbox()

				Managers.state.unit_spawner:request_spawn_template_unit("thornsister_thorn_wall_unit", unbox, arg_4_2, source_unit, wall_index, i)
			end
		end
	end
}

local function fn(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local num = arg_5_1 + Quaternion.rotate(Quaternion.axis_angle(Vector3.up(), -arg_5_3), arg_5_2)
	local raycast, var_5_2 = GwNavQueries.raycast(arg_5_0, arg_5_1, num)
	local normalize = Vector3.normalize(var_5_2 - arg_5_1)

	if not raycast then
		return true, var_5_2, normalize
	end

	return false, var_5_2, normalize
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
			on_spawn = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local var_6_0 = Vector3(5, 6, 5)

				Unit.set_local_scale(arg_6_3, 0, var_6_0)

				local time = World.time(Application.main_world())
				local start_speed = DamageWaveTemplates.templates.necromancer_curse_wave.start_speed
				local num = time + var_6_0.y / start_speed
				local var_6_4 = Vector2(0, 1)

				Unit.set_vector2_for_material(arg_6_3, "projector", "start_end_time", Vector2(time, num))
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
			on_spawn = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				local var_7_0 = Vector3(1, 1, 1)

				Unit.set_local_scale(arg_7_3, 0, var_7_0)

				local time = World.time(Application.main_world())
				local num = time + 3
				local num_2 = 1.5

				Unit.set_vector2_for_material(arg_7_3, "projector", "start_end_time", Vector2(time, num))
				Unit.set_scalar_for_material(arg_7_3, "projector", "fade_time", num_2)
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
			on_spawn = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local var_8_0 = Vector3(1, 1, 1)

				Unit.set_local_scale(arg_8_3, 0, var_8_0)

				local time = World.time(Application.main_world())
				local num = time + 3
				local num_2 = 1.5

				Unit.set_vector2_for_material(arg_8_3, "projector", "start_end_time", Vector2(time, num))
				Unit.set_scalar_for_material(arg_8_3, "projector", "fade_time", num_2)
				Unit.set_scalar_for_material(arg_8_3, "projector", "enable_fade", 1)
			end
		}
	},
	ai_push_data = {
		push_along_wave_direction = true,
		drag_along_wave = false,
		stagger_impact = {
			scripts_utils_stagger_types.heavy,
			scripts_utils_stagger_types.heavy,
			scripts_utils_stagger_types.heavy,
			scripts_utils_stagger_types.none,
			scripts_utils_stagger_types.heavy,
			scripts_utils_stagger_types.heavy
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
	update_func = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
		if not self.wave_direction then
			return
		end

		local _update_data = self._update_data

		if not _update_data then
			local unbox = self.wave_direction:unbox()

			_update_data = {
				next_spawn_t = 0,
				failed_attempts = 0,
				next_direction_update_t = 0,
				hand_units_by_player = {},
				original_direction = Vector3Box(unbox),
				last_pos = Vector3Box(arg_9_2 - unbox)
			}
			self._update_data = _update_data
		end

		if not script_data.debug_necromancer_curse_wave then
			QuickDrawer:sphere(arg_9_2, 0.5)
		end

		if not Managers.player.is_server then
			return
		end

		if arg_9_3 >= _update_data.next_direction_update_t then
			if not _update_data.next_direction then
				self.wave_direction = _update_data.next_direction
				_update_data.next_direction = nil
			end

			local acceleration = self.acceleration

			assert(not acceleration and acceleration == 0, "Calculations won't be accurate if wave has acceleration")

			local ai_query_distance = DamageWaveTemplates.templates.necromancer_curse_wave.ai_query_distance
			local wave_speed = self.wave_speed
			local num = self.wave_direction:unbox() * wave_speed * ai_query_distance
			local var_9_6 = arg_9_2
			local num_2 = arg_9_2 + _update_data.original_direction:unbox() * wave_speed * ai_query_distance * 2
			local nav_world = Managers.state.entity:system("ai_system"):nav_world()
			local raycast, var_9_10 = GwNavQueries.raycast(nav_world, var_9_6, num_2)
			local var_9_11

			if not (raycast or not (Vector3.distance_squared(var_9_6, var_9_10) > ai_query_distance * ai_query_distance)) then
				_update_data.next_direction = _update_data.original_direction
				var_9_11 = var_9_10
			else
				local num_3 = var_9_6 + num
				local var_9_13

				raycast, var_9_13 = GwNavQueries.raycast(nav_world, var_9_6, num_3)

				if not raycast then
					_update_data.next_direction_update_t = arg_9_3 + 1
				elseif _update_data.failed_attempts < 4 then
					local num_4 = var_9_13 + Vector3.normalize(var_9_6 - var_9_13) * ai_query_distance
					local num_5 = math.pi * 0.25

					repeat
						local var_9_16
						local var_9_17

						raycast, var_9_11, var_9_17 = fn(nav_world, num_4, num, -num_5)

						if not raycast then
							_update_data.next_direction = Vector3Box(var_9_17)

							break
						end

						local var_9_18

						raycast, var_9_11, var_9_18 = fn(nav_world, num_4, num, num_5)

						if not raycast then
							_update_data.next_direction = Vector3Box(var_9_18)

							break
						end

						local var_9_19

						raycast, var_9_11, var_9_19 = fn(nav_world, num_4, num, -2 * num_5)

						if not raycast then
							_update_data.next_direction = Vector3Box(var_9_19)

							break
						end

						local var_9_20

						raycast, var_9_11, var_9_20 = fn(nav_world, num_4, num, 2 * num_5)

						if not raycast then
							_update_data.next_direction = Vector3Box(var_9_20)
						end

						break
					until true
				end
			end

			if not raycast then
				_update_data.next_direction_update_t = arg_9_3 + 1
				_update_data.failed_attempts = 0
			elseif not var_9_11 then
				_update_data.next_direction_update_t = arg_9_3 + (Vector3.distance(var_9_11, var_9_6) - ai_query_distance) / wave_speed
				_update_data.failed_attempts = _update_data.failed_attempts + 1
			end
		end
	end,
	on_arrive_func = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		return
	end
}

local clone = table.clone(DamageWaveTemplates.templates.necromancer_curse_wave)

clone.fx_name_filled = "fx/necromancer_wave_linger"
clone.fx_separation_dist = 1.5
clone.blob_separation_dist = 1
clone.apply_buff_to_owner = true
clone.buff_template_name = "sienna_necromancer_empowered_overcharge"
clone.buff_template_type = "sienna_necromancer_empowered_overcharge"

clone.add_buff_func = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	if not (not ALIVE[arg_11_1] and Managers.state.network.is_server) then
		return
	end

	if arg_11_1 ~= self.source_unit then
		return
	end

	local owner = Managers.player:owner(arg_11_1)

	if not owner then
		return
	end

	local get_stacking_buff = ScriptUnit.extension(arg_11_1, "buff_system"):get_stacking_buff(arg_11_2)

	if not (not get_stacking_buff and get_stacking_buff[1]) then
		Managers.state.entity:system("buff_system"):add_buff_synced(arg_11_1, "sienna_necromancer_empowered_overcharge", BuffSyncType.ClientAndServer, nil, owner.peer_id)
	end
end

clone.leave_area_func = function (arg_12_0)
	-- function 12
	if not ALIVE[arg_12_0] then
		local extension = ScriptUnit.extension(arg_12_0, "buff_system")
		local get_stacking_buff = extension:get_stacking_buff("sienna_necromancer_empowered_overcharge")
		local flag = not get_stacking_buff and get_stacking_buff[1]

		if not flag then
			extension:remove_buff(flag.id)
		end
	end
end

DamageWaveTemplates.templates.necromancer_curse_wave_linger = clone

for k, v in pairs(DamageWaveTemplates.templates) do
	local ai_push_data = v.ai_push_data
	local flag = not ai_push_data and ai_push_data.hit_half_extends

	if not flag then
		fassert(not v.ai_query_distance, "[DamageWaveTemplates] 'ai_query_distance' will be overridden by 'hit_half_extends'. (%s)", k)

		local unbox = Vector3Aux.unbox(flag)

		v.ai_query_distance = Vector3.length(unbox)
	end
end
