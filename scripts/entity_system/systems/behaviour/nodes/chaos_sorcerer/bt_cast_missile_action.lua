-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_cast_missile_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCastMissileAction = class(BTCastMissileAction, BTNode)
BTCastMissileAction.name = "BTCastMissileAction"

BTCastMissileAction.init = function (arg_1_0, ...)
	-- function 1
	BTCastMissileAction.super.init(arg_1_0, ...)
end

BTCastMissileAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.active_node = BTCastMissileAction

	local spell_count = arg_2_2.spell_count

	spell_count = spell_count or 0
	arg_2_2.spell_count = spell_count

	local cast_time = action_data.cast_time

	cast_time = cast_time or 1
	arg_2_2.cast_time_done = arg_2_3 + cast_time
	arg_2_2.summoning = true
	arg_2_2.volleys = 0

	local target_unit = arg_2_2.target_unit
	local var_2_4

	arg_2_2.cast_target_unit = target_unit

	if not Unit.alive(target_unit) then
		var_2_4 = Vector3.distance_squared(POSITION_LOOKUP[target_unit], POSITION_LOOKUP[arg_2_1])
		arg_2_2.target_position = Vector3Box(POSITION_LOOKUP[target_unit])
	end

	if not (not action_data.target_close_anim and not var_2_4 and not (var_2_4 < action_data.target_close_distance)) then
		Managers.state.network:anim_event(arg_2_1, action_data.target_close_anim)
	elseif not action_data.cast_anim then
		Managers.state.network:anim_event(arg_2_1, action_data.cast_anim)
	end

	if not arg_2_2.navigation_extension then
		arg_2_2.navigation_extension:stop()
	end

	if not action_data.init_spell_func then
		action_data.init_spell_func(arg_2_2)
	end
end

BTCastMissileAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.active_node = nil
	arg_3_2.cast_time_done = nil
	arg_3_2.summoning = nil
	arg_3_2.ready_to_summon = false
end

BTCastMissileAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local cast_target_unit = arg_4_2.cast_target_unit

	if not Unit.alive(cast_target_unit) then
		local has_extension = ScriptUnit.has_extension(cast_target_unit, "status_system")

		if not (not has_extension and has_extension:is_invisible() and has_extension:get_is_dodging()) then
			arg_4_2.target_position:store(POSITION_LOOKUP[cast_target_unit])
		end
	else
		return "done"
	end

	local unbox = arg_4_2.target_position:unbox()
	local action = arg_4_2.action

	if (action.only_cb or not (arg_4_3 > arg_4_2.cast_time_done)) and not arg_4_2.anim_cb_throw then
		arg_4_2.anim_cb_throw = false

		local current_spell = arg_4_2.current_spell

		current_spell = current_spell or action.spell_data

		local var_4_5
		local var_4_6

		if not action.get_throw_position_func then
			var_4_5, var_4_6 = action.get_throw_position_func(arg_4_1, arg_4_2, unbox)
		elseif not current_spell.read_from_missile_data then
			var_4_5 = current_spell.throw_pos:unbox()
			var_4_6 = current_spell.target_direction:unbox()
		else
			local copy = Vector3.copy(POSITION_LOOKUP[arg_4_1])
			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, cast_target_unit)
			local var_4_9, var_4_10, var_4_11 = unpack(arg_4_2.action.missile_spawn_offset)
			local var_4_12 = Vector3(var_4_9, var_4_10, var_4_11)

			var_4_5 = copy + Quaternion.rotate(rotation_towards_unit_flat, var_4_12)
			var_4_6 = Vector3.normalize(unbox - var_4_5)
		end

		if not current_spell.magic_missile then
			local launch_angle = action.launch_angle

			launch_angle = launch_angle or 0.7

			local magic_missile_speed = current_spell.magic_missile_speed

			var_4_6 = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(var_4_6, Vector3.up()), launch_angle), var_4_6)

			local num = Vector3.cross(var_4_6, Vector3.up()) * (1 - 2 * math.random()) * 0.25
			local num_2 = Vector3.cross(var_4_6, Vector3.right()) * (1 - 2 * math.random()) * 0.25

			var_4_6 = Vector3.normalize(var_4_6 + num + num_2)

			local target_ground = current_spell.target_ground

			target_ground = not target_ground and POSITION_LOOKUP[arg_4_2.target_unit]

			self:launch_magic_missile(arg_4_2, action, var_4_5, var_4_6, launch_angle, magic_missile_speed, arg_4_1, arg_4_2.target_unit, target_ground, current_spell)
		else
			local angle = current_spell.angle
			local speed = current_spell.speed

			self:launch_projectile(arg_4_2, action, var_4_5, var_4_6, angle, speed, arg_4_1, arg_4_2.target_unit, current_spell)
		end

		arg_4_2.spell_count = arg_4_2.spell_count + 1
		arg_4_2.volleys = arg_4_2.volleys + 1

		if not (action.only_cb or not (arg_4_2.volleys >= action.volleys)) then
			return "done"
		else
			arg_4_2.cast_time_done = arg_4_3 + action.volley_delay
		end
	end

	if not arg_4_2.attack_finished then
		arg_4_2.attack_finished = false

		return "done"
	end

	if not action.face_target_while_casting and not arg_4_2.locomotion_extension then
		local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_4_1, unbox)

		arg_4_2.locomotion_extension:set_wanted_rotation(look_at_position_flat)
	end

	return "running"
end

BTCastMissileAction.launch_projectile = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	-- function 5
	local get_difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_5_1 = arg_5_2.aoe_dot_damage[get_difficulty_rank]

	var_5_1 = var_5_1 or arg_5_2.aoe_dot_damage[2]

	local calculate_damage = DamageUtils.calculate_damage(var_5_1)
	local var_5_3 = arg_5_2.aoe_init_damage[get_difficulty_rank]

	var_5_3 = var_5_3 or arg_5_2.aoe_init_damage[2]

	local calculate_damage_2 = DamageUtils.calculate_damage(var_5_3)
	local aoe_dot_damage_interval = arg_5_2.aoe_dot_damage_interval
	local radius = arg_5_2.radius
	local duration = arg_5_2.duration
	local name = arg_5_1.breed.name
	local create_nav_tag_volume = arg_5_2.create_nav_tag_volume
	local nav_tag_volume_layer = arg_5_2.nav_tag_volume_layer
	local tbl = {
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
			damage_source = name,
			owner_unit = arg_5_7
		},
		area_damage_system = {
			area_damage_template = "sorcerer_area_dot_damage",
			invisible_unit = false,
			area_ai_random_death_template = "area_poison_ai_random_death",
			damage_players = true,
			aoe_dot_damage = calculate_damage,
			aoe_init_damage = calculate_damage_2,
			aoe_dot_damage_interval = aoe_dot_damage_interval,
			radius = radius,
			life_time = duration,
			player_screen_effect_name = arg_5_2.player_screen_effect_name,
			dot_effect_name = arg_5_2.dot_effect_name,
			damage_source = name,
			create_nav_tag_volume = create_nav_tag_volume,
			nav_tag_volume_layer = nav_tag_volume_layer
		}
	}
	local str = "units/hub_elements/empty"
	local spawn_network_unit = Managers.state.unit_spawner:spawn_network_unit(str, "aoe_projectile_unit", tbl, arg_5_3)
end

BTCastMissileAction.launch_magic_missile = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	-- function 6
	local num = 1
	local num_2 = 0.2
	local num_3 = 0.5
	local flag

	flag = 0.5 or math.lerp(num_2, num_3, num)

	local name = arg_6_1.breed.name
	local true_flight_template_name = arg_6_10.true_flight_template_name
	local var_6_6 = TrueFlightTemplates[true_flight_template_name]
	local str = "ai_true_flight_projectile_unit"
	local var_6_8
	local var_6_9
	local health = var_6_6.health

	if not health then
		if type(health) == "table" then
			health = health[Managers.state.difficulty:get_difficulty_rank()] or health[2]
		end

		str = "ai_true_flight_killable_projectile_unit"
		var_6_8 = {
			health = health
		}
		var_6_9 = {
			is_husk = false,
			death_reaction_template = var_6_6.death_reaction_template
		}
	end

	local tbl = {
		projectile_locomotion_system = {
			trajectory_template_name = "throw_trajectory",
			gravity_settings = "arrows",
			angle = arg_6_5,
			speed = arg_6_6,
			initial_position = arg_6_3,
			target_vector = arg_6_4,
			true_flight_template_name = true_flight_template_name,
			target_unit = arg_6_8,
			owner_unit = arg_6_7,
			position_target = arg_6_9,
			life_time = arg_6_10.life_time
		}
	}
	local tbl_2 = {
		impact_template_name = "direct_impact",
		owner_unit = arg_6_7,
		damage_source = name
	}
	local explosion_template_name = arg_6_10.explosion_template_name

	explosion_template_name = explosion_template_name or "chaos_magic_missile"
	tbl_2.explosion_template_name = explosion_template_name
	tbl.projectile_system = tbl_2
	tbl.projectile_impact_system = {
		collision_filter = "filter_enemy_ray_projectile",
		server_side_raycast = true,
		owner_unit = arg_6_7,
		radius = flag
	}
	tbl.health_system = var_6_8
	tbl.death_system = var_6_9

	local look = Quaternion.look(arg_6_4)
	local projectile_unit_name = arg_6_10.projectile_unit_name
	local var_6_16

	if not arg_6_10.projectile_size then
		local projectile_size = arg_6_10.projectile_size
		local from_quaternion_position = Matrix4x4.from_quaternion_position(Quaternion.identity(), arg_6_3)

		Matrix4x4.set_scale(from_quaternion_position, Vector3(projectile_size[1], projectile_size[2], projectile_size[3]))

		var_6_16 = Managers.state.unit_spawner:spawn_network_unit(projectile_unit_name, str, tbl, from_quaternion_position)
	else
		var_6_16 = Managers.state.unit_spawner:spawn_network_unit(projectile_unit_name, str, tbl, arg_6_3, look)
	end

	Unit.set_unit_visibility(var_6_16, true)
end
