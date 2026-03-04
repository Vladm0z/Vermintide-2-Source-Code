-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_cast_missile_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCastMissileAction = class(BTCastMissileAction, BTNode)
BTCastMissileAction.name = "BTCastMissileAction"

BTCastMissileAction.init = function (arg_1_0, ...)
	BTCastMissileAction.super.init(arg_1_0, ...)
end

BTCastMissileAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.active_node = BTCastMissileAction
	arg_2_2.spell_count = arg_2_2.spell_count or 0
	arg_2_2.cast_time_done = arg_2_3 + (var_2_0.cast_time or 1)
	arg_2_2.summoning = true
	arg_2_2.volleys = 0

	local var_2_1 = arg_2_2.target_unit
	local var_2_2

	arg_2_2.cast_target_unit = var_2_1

	if Unit.alive(var_2_1) then
		var_2_2 = Vector3.distance_squared(POSITION_LOOKUP[var_2_1], POSITION_LOOKUP[arg_2_1])
		arg_2_2.target_position = Vector3Box(POSITION_LOOKUP[var_2_1])
	end

	if var_2_0.target_close_anim and var_2_2 and var_2_2 < var_2_0.target_close_distance then
		Managers.state.network:anim_event(arg_2_1, var_2_0.target_close_anim)
	elseif var_2_0.cast_anim then
		Managers.state.network:anim_event(arg_2_1, var_2_0.cast_anim)
	end

	if arg_2_2.navigation_extension then
		arg_2_2.navigation_extension:stop()
	end

	if var_2_0.init_spell_func then
		var_2_0.init_spell_func(arg_2_2)
	end
end

BTCastMissileAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.active_node = nil
	arg_3_2.cast_time_done = nil
	arg_3_2.summoning = nil
	arg_3_2.ready_to_summon = false
end

BTCastMissileAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.cast_target_unit

	if Unit.alive(var_4_0) then
		local var_4_1 = ScriptUnit.has_extension(var_4_0, "status_system")

		if not var_4_1 or not var_4_1:is_invisible() and not var_4_1:get_is_dodging() then
			arg_4_2.target_position:store(POSITION_LOOKUP[var_4_0])
		end
	else
		return "done"
	end

	local var_4_2 = arg_4_2.target_position:unbox()
	local var_4_3 = arg_4_2.action

	if not var_4_3.only_cb and arg_4_3 > arg_4_2.cast_time_done or arg_4_2.anim_cb_throw then
		arg_4_2.anim_cb_throw = false

		local var_4_4 = arg_4_2.current_spell or var_4_3.spell_data
		local var_4_5
		local var_4_6

		if var_4_3.get_throw_position_func then
			var_4_5, var_4_6 = var_4_3.get_throw_position_func(arg_4_1, arg_4_2, var_4_2)
		elseif var_4_4.read_from_missile_data then
			var_4_5 = var_4_4.throw_pos:unbox()
			var_4_6 = var_4_4.target_direction:unbox()
		else
			local var_4_7 = Vector3.copy(POSITION_LOOKUP[arg_4_1])
			local var_4_8 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, var_4_0)
			local var_4_9, var_4_10, var_4_11 = unpack(arg_4_2.action.missile_spawn_offset)
			local var_4_12 = Vector3(var_4_9, var_4_10, var_4_11)

			var_4_5 = var_4_7 + Quaternion.rotate(var_4_8, var_4_12)
			var_4_6 = Vector3.normalize(var_4_2 - var_4_5)
		end

		if var_4_4.magic_missile then
			local var_4_13 = var_4_3.launch_angle or 0.7
			local var_4_14 = var_4_4.magic_missile_speed

			var_4_6 = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(var_4_6, Vector3.up()), var_4_13), var_4_6)

			local var_4_15 = Vector3.cross(var_4_6, Vector3.up()) * (1 - 2 * math.random()) * 0.25
			local var_4_16 = Vector3.cross(var_4_6, Vector3.right()) * (1 - 2 * math.random()) * 0.25

			var_4_6 = Vector3.normalize(var_4_6 + var_4_15 + var_4_16)

			local var_4_17 = var_4_4.target_ground and POSITION_LOOKUP[arg_4_2.target_unit]

			arg_4_0:launch_magic_missile(arg_4_2, var_4_3, var_4_5, var_4_6, var_4_13, var_4_14, arg_4_1, arg_4_2.target_unit, var_4_17, var_4_4)
		else
			local var_4_18 = var_4_4.angle
			local var_4_19 = var_4_4.speed

			arg_4_0:launch_projectile(arg_4_2, var_4_3, var_4_5, var_4_6, var_4_18, var_4_19, arg_4_1, arg_4_2.target_unit, var_4_4)
		end

		arg_4_2.spell_count = arg_4_2.spell_count + 1
		arg_4_2.volleys = arg_4_2.volleys + 1

		if not var_4_3.only_cb and arg_4_2.volleys >= var_4_3.volleys then
			return "done"
		else
			arg_4_2.cast_time_done = arg_4_3 + var_4_3.volley_delay
		end
	end

	if arg_4_2.attack_finished then
		arg_4_2.attack_finished = false

		return "done"
	end

	if var_4_3.face_target_while_casting and arg_4_2.locomotion_extension then
		local var_4_20 = LocomotionUtils.look_at_position_flat(arg_4_1, var_4_2)

		arg_4_2.locomotion_extension:set_wanted_rotation(var_4_20)
	end

	return "running"
end

BTCastMissileAction.launch_projectile = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	local var_5_0 = Managers.state.difficulty:get_difficulty_rank()
	local var_5_1 = arg_5_2.aoe_dot_damage[var_5_0] or arg_5_2.aoe_dot_damage[2]
	local var_5_2 = DamageUtils.calculate_damage(var_5_1)
	local var_5_3 = arg_5_2.aoe_init_damage[var_5_0] or arg_5_2.aoe_init_damage[2]
	local var_5_4 = DamageUtils.calculate_damage(var_5_3)
	local var_5_5 = arg_5_2.aoe_dot_damage_interval
	local var_5_6 = arg_5_2.radius
	local var_5_7 = arg_5_2.duration
	local var_5_8 = arg_5_1.breed.name
	local var_5_9 = arg_5_2.create_nav_tag_volume
	local var_5_10 = arg_5_2.nav_tag_volume_layer
	local var_5_11 = {
		projectile_locomotion_system = {
			trajectory_template_name = "throw_trajectory",
			angle = arg_5_5,
			speed = arg_5_6,
			target_vector = arg_5_4,
			initial_position = arg_5_3
		},
		projectile_impact_system = {
			server_side_raycast = true,
			collision_filter = "filter_enemy_ray_projectile",
			owner_unit = arg_5_7
		},
		projectile_system = {
			impact_template_name = "explosion_impact",
			damage_source = var_5_8,
			owner_unit = arg_5_7
		},
		area_damage_system = {
			area_damage_template = "sorcerer_area_dot_damage",
			invisible_unit = false,
			area_ai_random_death_template = "area_poison_ai_random_death",
			damage_players = true,
			aoe_dot_damage = var_5_2,
			aoe_init_damage = var_5_4,
			aoe_dot_damage_interval = var_5_5,
			radius = var_5_6,
			life_time = var_5_7,
			player_screen_effect_name = arg_5_2.player_screen_effect_name,
			dot_effect_name = arg_5_2.dot_effect_name,
			damage_source = var_5_8,
			create_nav_tag_volume = var_5_9,
			nav_tag_volume_layer = var_5_10
		}
	}
	local var_5_12 = "units/hub_elements/empty"
	local var_5_13 = Managers.state.unit_spawner:spawn_network_unit(var_5_12, "aoe_projectile_unit", var_5_11, arg_5_3)
end

BTCastMissileAction.launch_magic_missile = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	local var_6_0 = 1
	local var_6_1 = 0.2
	local var_6_2 = 0.5
	local var_6_3 = 0.5 or math.lerp(var_6_1, var_6_2, var_6_0)
	local var_6_4 = arg_6_1.breed.name
	local var_6_5 = arg_6_10.true_flight_template_name
	local var_6_6 = TrueFlightTemplates[var_6_5]
	local var_6_7 = "ai_true_flight_projectile_unit"
	local var_6_8
	local var_6_9
	local var_6_10 = var_6_6.health

	if var_6_10 then
		if type(var_6_10) == "table" then
			var_6_10 = var_6_10[Managers.state.difficulty:get_difficulty_rank()] or var_6_10[2]
		end

		var_6_7 = "ai_true_flight_killable_projectile_unit"
		var_6_8 = {
			health = var_6_10
		}
		var_6_9 = {
			is_husk = false,
			death_reaction_template = var_6_6.death_reaction_template
		}
	end

	local var_6_11 = {
		projectile_locomotion_system = {
			trajectory_template_name = "throw_trajectory",
			gravity_settings = "arrows",
			angle = arg_6_5,
			speed = arg_6_6,
			initial_position = arg_6_3,
			target_vector = arg_6_4,
			true_flight_template_name = var_6_5,
			target_unit = arg_6_8,
			owner_unit = arg_6_7,
			position_target = arg_6_9,
			life_time = arg_6_10.life_time
		},
		projectile_system = {
			impact_template_name = "direct_impact",
			owner_unit = arg_6_7,
			damage_source = var_6_4,
			explosion_template_name = arg_6_10.explosion_template_name or "chaos_magic_missile"
		},
		projectile_impact_system = {
			collision_filter = "filter_enemy_ray_projectile",
			server_side_raycast = true,
			owner_unit = arg_6_7,
			radius = var_6_3
		},
		health_system = var_6_8,
		death_system = var_6_9
	}
	local var_6_12 = Quaternion.look(arg_6_4)
	local var_6_13 = arg_6_10.projectile_unit_name
	local var_6_14

	if arg_6_10.projectile_size then
		local var_6_15 = arg_6_10.projectile_size
		local var_6_16 = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_6_3)

		Matrix4x4.set_scale(var_6_16, Vector3(var_6_15[1], var_6_15[2], var_6_15[3]))

		var_6_14 = Managers.state.unit_spawner:spawn_network_unit(var_6_13, var_6_7, var_6_11, var_6_16)
	else
		var_6_14 = Managers.state.unit_spawner:spawn_network_unit(var_6_13, var_6_7, var_6_11, arg_6_3, var_6_12)
	end

	Unit.set_unit_visibility(var_6_14, true)
end
