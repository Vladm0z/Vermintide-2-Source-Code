-- chunkname: @scripts/unit_extensions/weapons/projectiles/true_flight_templates.lua

TrueFlightTemplates = TrueFlightTemplates or {}
TrueFlightTemplates.active_ability_kerillian_way_watcher = {
	retarget_on_miss = true,
	forward_search_distance_to_find_target = 5,
	legitimate_target_func = "legitimate_target_keep_target",
	target_node = "c_head",
	target_tracking_check_func = "update_towards_target",
	dont_target_friendly = true,
	dot_threshold = 1,
	lerp_squared_distance_threshold = 625,
	speed_multiplier = 0.01,
	broadphase_radius = 7.5,
	find_target_func = "find_closest_highest_value_target",
	keep_target_on_miss_check_func = "legitimate_only_dot_check",
	life_time_factor = 0.6,
	time_between_raycasts = 0.05,
	lerp_constant = 150,
	max_on_target_time = math.huge
}
TrueFlightTemplates.active_ability_sienna_scholar = {
	retarget_on_miss = true,
	dot_threshold = 1,
	forward_search_distance_to_find_target = 5,
	target_node = "c_head",
	target_tracking_check_func = "update_towards_target",
	legitimate_target_func = "legitimate_target_keep_target",
	broadphase_radius = 7.5,
	speed_multiplier = 0.01,
	time_between_raycasts = 0.05,
	keep_target_on_miss_check_func = "legitimate_only_dot_check",
	find_target_func = "find_closest_highest_value_target",
	life_time_factor = 0.6,
	lerp_distance_threshold = 625,
	lerp_constant = 150,
	max_on_target_time = math.huge
}
TrueFlightTemplates.machinegun = {
	speed_multiplier = 0.001,
	lerp_constant = 50,
	time_between_raycasts = 0.1,
	broadphase_radius = 5,
	dot_threshold = 0.9999,
	lerp_squared_distance_threshold = 2000
}
TrueFlightTemplates.carbine = {
	speed_multiplier = 0.01,
	lerp_constant = 50,
	time_between_raycasts = 0.05,
	broadphase_radius = 5,
	dot_threshold = 0.9999,
	lerp_squared_distance_threshold = 2000
}
TrueFlightTemplates.sniper = {
	speed_multiplier = 0.01,
	lerp_constant = 50,
	time_between_raycasts = 0.05,
	broadphase_radius = 10,
	dot_threshold = 0.9999,
	lerp_squared_distance_threshold = 2000
}
TrueFlightTemplates.sorcerer_magic_missile = {
	target_tracking_check_func = "update_towards_target",
	legitimate_target_func = "legitimate_only_dot_check",
	target_node = "c_spine",
	create_bot_threat = true,
	bot_threat_at_distance = 5,
	dot_threshold = 0.9999,
	lerp_squared_distance_threshold = 2000,
	speed_multiplier = 1,
	initial_target_node = "c_spine",
	find_target_func = "find_player_target",
	target_players = true,
	time_between_raycasts = 0.1,
	lerp_constant = 50,
	lerp_modifier_func = function(arg_1_0)
		return arg_1_0 < 7 and 0.01 or 5 / arg_1_0
	end
}
TrueFlightTemplates.sorcerer_strike_missile = {
	create_bot_threat = true,
	triggered_speed_mult = 6,
	target_node = "c_spine",
	lingering_duration = 0.4,
	target_tracking_check_func = "update_towards_strike_missile_target",
	legitimate_target_func = "legitimate_only_dot_check",
	dot_threshold = 0.9999,
	lerp_squared_distance_threshold = 2000,
	speed_multiplier = 1,
	initial_target_node = "c_spine",
	find_target_func = "find_player_target",
	target_players = true,
	time_between_raycasts = 0.1,
	lerp_constant = 50,
	lerp_modifier_func = function(arg_2_0)
		return arg_2_0 < 7 and 0.01 or 3 / arg_2_0
	end,
	template_state_func = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if arg_3_2 == 1 then
			Unit.flow_event(arg_3_1, "lua_projectile_triggered")
		elseif arg_3_2 == 2 then
			Unit.flow_event(arg_3_1, "lua_projectile_striking")
		end
	end
}
TrueFlightTemplates.sorcerer_magic_missile_ground = {
	target_tracking_check_func = "update_towards_position_target",
	dot_threshold = 0.9999,
	lerp_squared_distance_threshold = 2000,
	speed_multiplier = 1,
	find_target_func = "find_player_target",
	target_players = true,
	time_between_raycasts = 0.1,
	lerp_constant = 50,
	lerp_modifier_func = function(arg_4_0)
		return arg_4_0 < 7 and 0.01 or 5 / arg_4_0
	end
}
TrueFlightTemplates.sorcerer_slow_bomb_missile = {
	overpowered_blob_health = 5,
	target_node = "c_spine",
	target_tracking_check_func = "update_towards_slow_bomb_target",
	legitimate_target_func = "legitimate_always",
	dot_threshold = 0.9999,
	lerp_squared_distance_threshold = 2000,
	speed_multiplier = 1.5,
	initial_target_node = "c_spine",
	time_between_raycasts = 0.1,
	triggered_speed_mult = 3.5,
	update_after_impact = true,
	trigger_dist = 0.5,
	attached_life_time = 10,
	find_target_func = "find_player_target",
	target_players = true,
	death_reaction_template = "killable_projectile",
	lerp_constant = 50,
	health = {
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1
	},
	lerp_modifier_func = function(arg_5_0)
		return arg_5_0 < 5 and 1 or 5 / arg_5_0
	end,
	template_state_func = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		if arg_6_2 == 1 then
			Unit.flow_event(arg_6_1, "lua_projectile_triggered")
		elseif arg_6_2 == 2 then
			if not arg_6_4 then
				return
			end

			if arg_6_3 then
				-- block empty
			end
		end
	end,
	init_func = function(arg_7_0, arg_7_1)
		local var_7_0 = Unit.actor(arg_7_0, "c_large")

		Actor.set_collision_enabled(var_7_0, false)
	end
}
TrueFlightTemplates.sorcerer_vortex_dummy_missile = {
	speed_multiplier = 1,
	time_between_raycasts = 0.05,
	target_tracking_check_func = "update_towards_position_target",
	target_players = true,
	broadphase_radius = 7.5,
	lerp_modifier_func = function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = math.clamp(112.5 / (arg_8_1 + 0.01)^2, 0.25, 40)

		return arg_8_0 / (var_8_0 - 0.5 * var_8_0 * math.abs(math.sin(0.5 * arg_8_2)))
	end
}
TrueFlightTemplates.necromancer_trapped_soul = {
	target_players = false,
	dot_threshold = 0.9999,
	dont_target_patrols = true,
	lerp_distance_threshold = 625,
	target_tracking_check_func = "update_towards_target",
	retarget_broadphase_offset = 0,
	target_node = "c_neck",
	speed_multiplier = 6.5,
	valid_target_dot = 0.99,
	time_between_raycasts = 0.1,
	dont_target_friendly = true,
	broadphase_radius = 7.5,
	ignore_dead = true,
	max_on_target_time = math.huge,
	lerp_modifier_func = function(arg_9_0, arg_9_1, arg_9_2)
		return 0.75
	end,
	init_func = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		arg_10_3.seed = arg_10_2
		arg_10_3.spin_dir = 1 - bit.band(arg_10_2, 128) / 64
		arg_10_2, arg_10_3.wobble_min = math.next_random_range(arg_10_2, 0.3, 0.3)
		arg_10_2, arg_10_3.wobble_max = math.next_random_range(arg_10_2, 0.3, 0.4)
		arg_10_2, arg_10_3.wobble_speed = math.next_random_range(arg_10_2, 2.5, 5)
		arg_10_2, arg_10_3.wobble_vertical_mult = math.next_random_range(arg_10_2, 0.7, 1)
		arg_10_2, arg_10_3.wobble_horizontal_mult = math.next_random_range(arg_10_2, 1, 1.2)
		arg_10_2, arg_10_3.wobble_stabiliztion_speed = math.next_random_range(arg_10_2, 0.3, 0.5)
	end,
	update_unit_position = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		local var_11_0 = Vector3Box.unbox(arg_11_4.target_vector_boxed)
		local var_11_1 = arg_11_4.t - arg_11_4.spawn_time
		local var_11_2 = arg_11_3.lerped_wobble_scale or 1
		local var_11_3 = ALIVE[arg_11_4.target_unit] and Vector3.distance(POSITION_LOOKUP[arg_11_4.target_unit], arg_11_1) or 0
		local var_11_4 = math.remap(1, 5, 0, 1, math.clamp(var_11_3, 1, 5))
		local var_11_5 = arg_11_4.dt
		local var_11_6 = math.clamp01(var_11_2 + var_11_5 * math.sign(var_11_4 - var_11_2))

		arg_11_3.lerped_wobble_scale = var_11_6

		local var_11_7 = arg_11_4.speed
		local var_11_8 = math.easeCubic(math.clamp(var_11_1 * arg_11_3.wobble_stabiliztion_speed * var_11_7, 0, 1))
		local var_11_9 = math.clamp(var_11_8 * 100, 0, 1)
		local var_11_10 = math.lerp(arg_11_3.wobble_max, arg_11_3.wobble_min, var_11_8) * var_11_9 * var_11_6
		local var_11_11 = var_11_10 * arg_11_3.wobble_vertical_mult
		local var_11_12 = var_11_10 * arg_11_3.wobble_horizontal_mult
		local var_11_13 = arg_11_3.wobble_speed * arg_11_3.spin_dir
		local var_11_14 = 2.007128639793479
		local var_11_15 = Vector3(math.sin(var_11_1 * var_11_13 - var_11_14) * var_11_12, 0, math.cos(var_11_1 * var_11_13 - var_11_14) * var_11_11)
		local var_11_16 = Quaternion.rotate(Quaternion.look(var_11_0), var_11_15)
		local var_11_17 = var_11_12 < math.epsilon and 0 or Vector3.dot(Vector3.right(), var_11_15) / var_11_12
		local var_11_18 = Quaternion.axis_angle(Vector3.forward(), -var_11_17 * math.pi * 0.1)
		local var_11_19 = Quaternion.look(var_11_0)
		local var_11_20 = Quaternion.multiply(var_11_19, var_11_18)

		Unit.set_local_rotation(arg_11_0, 0, var_11_20)
		Unit.set_local_position(arg_11_0, 0, arg_11_1 + var_11_16)
	end
}

local var_0_0 = 0

TrueFlightTemplatesLookup = TrueFlightTemplatesLookup or {}

for iter_0_0, iter_0_1 in pairs(TrueFlightTemplates) do
	var_0_0 = var_0_0 + 1
	iter_0_1.lookup_id = var_0_0
	TrueFlightTemplatesLookup[var_0_0] = iter_0_0
end
