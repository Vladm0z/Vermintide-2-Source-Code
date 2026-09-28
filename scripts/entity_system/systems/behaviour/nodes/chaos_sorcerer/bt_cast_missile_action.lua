-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_cast_missile_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCastMissileAction = class(BTCastMissileAction, BTNode)
BTCastMissileAction.name = "BTCastMissileAction"

BTCastMissileAction.init = function (self, ...)
	-- function 1
	BTCastMissileAction.super.init(self, ...)
end

BTCastMissileAction.enter = function (self, unit, blackboard, t)
	-- function 2
	local action = self._tree_node.action_data

	blackboard.action = action
	blackboard.active_node = BTCastMissileAction

	local spell_count = blackboard.spell_count

	spell_count = not not spell_count or not not 0
	blackboard.spell_count = spell_count

	local cast_time = action.cast_time

	cast_time = not not cast_time or not not 1
	blackboard.cast_time_done = t + cast_time
	blackboard.summoning = true
	blackboard.volleys = 0

	local target_unit = blackboard.target_unit
	local distance_to_target

	blackboard.cast_target_unit = target_unit

	if Unit.alive(target_unit) then
		distance_to_target = Vector3.distance_squared(POSITION_LOOKUP[target_unit], POSITION_LOOKUP[unit])
		blackboard.target_position = Vector3Box(POSITION_LOOKUP[target_unit])
	end

	if action.target_close_anim and distance_to_target and distance_to_target < action.target_close_distance then
		Managers.state.network:anim_event(unit, action.target_close_anim)
	elseif action.cast_anim then
		Managers.state.network:anim_event(unit, action.cast_anim)
	end

	if blackboard.navigation_extension then
		blackboard.navigation_extension:stop()
	end

	if action.init_spell_func then
		action.init_spell_func(blackboard)
	end
end

BTCastMissileAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 3
	blackboard.active_node = nil
	blackboard.cast_time_done = nil
	blackboard.summoning = nil
	blackboard.ready_to_summon = false
end

BTCastMissileAction.run = function (self, unit, blackboard, t, dt)
	-- function 4
	local cast_target_unit = blackboard.cast_target_unit

	if Unit.alive(cast_target_unit) then
		local status_ext = ScriptUnit.has_extension(cast_target_unit, "status_system")

		if not status_ext or not status_ext:is_invisible() and not status_ext:get_is_dodging() then
			blackboard.target_position:store(POSITION_LOOKUP[cast_target_unit])
		end
	else
		return "done"
	end

	local target_position = blackboard.target_position:unbox()
	local action = blackboard.action

	if (action.only_cb or not (t > blackboard.cast_time_done)) and blackboard.anim_cb_throw then
		blackboard.anim_cb_throw = false

		local current_spell = blackboard.current_spell

		if not current_spell then
			-- Nothing
		end

		current_spell = action.spell_data

		local missile_data = current_spell

		::label_4_0::

		local throw_pos, target_dir

		if action.get_throw_position_func then
			throw_pos, target_dir = action.get_throw_position_func(unit, blackboard, target_position)
		else
			local stored = missile_data.read_from_missile_data

			if stored then
				throw_pos = missile_data.throw_pos:unbox()
				target_dir = missile_data.target_direction:unbox()
			else
				local curr_pos = Vector3.copy(POSITION_LOOKUP[unit])
				local rot = LocomotionUtils.rotation_towards_unit_flat(unit, cast_target_unit)
				local x, y, z = unpack(blackboard.action.missile_spawn_offset)
				local pos = Vector3(x, y, z)
				local throw_offset = Quaternion.rotate(rot, pos)

				throw_pos = curr_pos + throw_offset
				target_dir = Vector3.normalize(target_position - throw_pos)
			end
		end

		if missile_data.magic_missile then
			local launch_angle = action.launch_angle

			if not launch_angle then
				-- Nothing
			end

			launch_angle = 0.7

			local angle = launch_angle

			::label_4_1::

			local speed = missile_data.magic_missile_speed

			target_dir = Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(target_dir, Vector3.up()), angle), target_dir)

			local up = Vector3.cross(target_dir, Vector3.up()) * (1 - 2 * math.random()) * 0.25
			local right = Vector3.cross(target_dir, Vector3.right()) * (1 - 2 * math.random()) * 0.25

			target_dir = Vector3.normalize(target_dir + up + right)

			local target_ground = missile_data.target_ground

			if target_ground then
				-- Nothing
			end

			target_ground = POSITION_LOOKUP[blackboard.target_unit]

			local position_target = target_ground

			::label_4_2::

			self:launch_magic_missile(blackboard, action, throw_pos, target_dir, angle, speed, unit, blackboard.target_unit, position_target, missile_data)
		else
			local angle = missile_data.angle
			local speed = missile_data.speed

			self:launch_projectile(blackboard, action, throw_pos, target_dir, angle, speed, unit, blackboard.target_unit, missile_data)
		end

		blackboard.spell_count = blackboard.spell_count + 1
		blackboard.volleys = blackboard.volleys + 1

		if not action.only_cb and blackboard.volleys >= action.volleys then
			return "done"
		else
			blackboard.cast_time_done = t + action.volley_delay
		end
	end

	if blackboard.attack_finished then
		blackboard.attack_finished = false

		return "done"
	end

	if action.face_target_while_casting and blackboard.locomotion_extension then
		local rot = LocomotionUtils.look_at_position_flat(unit, target_position)

		blackboard.locomotion_extension:set_wanted_rotation(rot)
	end

	return "running"
end

BTCastMissileAction.launch_projectile = function (self, blackboard, action, initial_position, target_dir, angle, speed, owner_unit, target_unit)
	-- function 5
	local difficulty_rank = Managers.state.difficulty:get_difficulty_rank()
	local var_5_0 = action.aoe_dot_damage[difficulty_rank]

	if not var_5_0 then
		-- Nothing
	end

	var_5_0 = action.aoe_dot_damage[2]

	local aoe_dot_damage_table = var_5_0

	::label_5_0::

	local aoe_dot_damage = DamageUtils.calculate_damage(aoe_dot_damage_table)
	local var_5_1 = action.aoe_init_damage[difficulty_rank]

	if not var_5_1 then
		-- Nothing
	end

	var_5_1 = action.aoe_init_damage[2]

	local aoe_init_damage_table = var_5_1

	::label_5_1::

	local aoe_init_damage = DamageUtils.calculate_damage(aoe_init_damage_table)
	local aoe_dot_damage_interval = action.aoe_dot_damage_interval
	local radius = action.radius
	local duration = action.duration
	local damage_source = blackboard.breed.name
	local create_nav_tag_volume = action.create_nav_tag_volume
	local nav_tag_volume_layer = action.nav_tag_volume_layer
	local extension_init_data = {
		projectile_locomotion_system = {
			trajectory_template_name = "throw_trajectory",
			angle = angle,
			speed = speed,
			target_vector = target_dir,
			initial_position = initial_position
		},
		projectile_impact_system = {
			server_side_raycast = true,
			collision_filter = "filter_enemy_ray_projectile",
			owner_unit = owner_unit
		},
		projectile_system = {
			impact_template_name = "explosion_impact",
			damage_source = damage_source,
			owner_unit = owner_unit
		},
		area_damage_system = {
			area_damage_template = "sorcerer_area_dot_damage",
			invisible_unit = false,
			area_ai_random_death_template = "area_poison_ai_random_death",
			damage_players = true,
			aoe_dot_damage = aoe_dot_damage,
			aoe_init_damage = aoe_init_damage,
			aoe_dot_damage_interval = aoe_dot_damage_interval,
			radius = radius,
			life_time = duration,
			player_screen_effect_name = action.player_screen_effect_name,
			dot_effect_name = action.dot_effect_name,
			damage_source = damage_source,
			create_nav_tag_volume = create_nav_tag_volume,
			nav_tag_volume_layer = nav_tag_volume_layer
		}
	}
	local projectile_unit_name = "units/hub_elements/empty"
	local projectile_unit = Managers.state.unit_spawner:spawn_network_unit(projectile_unit_name, "aoe_projectile_unit", extension_init_data, initial_position)
end

BTCastMissileAction.launch_magic_missile = function (self, blackboard, action, position, target_dir, angle, speed, owner_unit, target_unit, position_target, missile_data)
	-- function 6
	local scale = 1
	local radius_min = 0.2
	local radius_max = 0.5
	local num = 0.5

	goto label_6_0

	num = math.lerp(radius_min, radius_max, scale)

	local radius = num

	::label_6_0::

	local damage_source = blackboard.breed.name
	local true_flight_template_name = missile_data.true_flight_template_name
	local true_flight_template = TrueFlightTemplates[true_flight_template_name]
	local unit_template_name = "ai_true_flight_projectile_unit"
	local health_system, death_system
	local missile_health = true_flight_template.health

	if missile_health then
		if type(missile_health) == "table" then
			local difficulty_rank = Managers.state.difficulty:get_difficulty_rank()

			missile_health = not not missile_health[difficulty_rank] or not not missile_health[2]
		end

		unit_template_name = "ai_true_flight_killable_projectile_unit"
		health_system = {
			health = missile_health
		}
		death_system = {
			is_husk = false,
			death_reaction_template = true_flight_template.death_reaction_template
		}
	end

	local tbl = {
		projectile_locomotion_system = {
			trajectory_template_name = "throw_trajectory",
			gravity_settings = "arrows",
			angle = angle,
			speed = speed,
			initial_position = position,
			target_vector = target_dir,
			true_flight_template_name = true_flight_template_name,
			target_unit = target_unit,
			owner_unit = owner_unit,
			position_target = position_target,
			life_time = missile_data.life_time
		}
	}
	local tbl_2 = {
		impact_template_name = "direct_impact",
		owner_unit = owner_unit,
		damage_source = damage_source
	}
	local explosion_template_name = missile_data.explosion_template_name

	explosion_template_name = not not explosion_template_name or not not "chaos_magic_missile"
	tbl_2.explosion_template_name = explosion_template_name
	tbl.projectile_system = tbl_2
	tbl.projectile_impact_system = {
		collision_filter = "filter_enemy_ray_projectile",
		server_side_raycast = true,
		owner_unit = owner_unit,
		radius = radius
	}
	tbl.health_system = health_system
	tbl.death_system = death_system

	local extension_init_data = tbl
	local rotation = Quaternion.look(target_dir)
	local projectile_unit_name = missile_data.projectile_unit_name
	local projectile_unit

	if missile_data.projectile_size then
		local s = missile_data.projectile_size
		local pose = Matrix4x4.from_quaternion_position(Quaternion.identity(), position)

		Matrix4x4.set_scale(pose, Vector3(s[1], s[2], s[3]))

		projectile_unit = Managers.state.unit_spawner:spawn_network_unit(projectile_unit_name, unit_template_name, extension_init_data, pose)
	else
		projectile_unit = Managers.state.unit_spawner:spawn_network_unit(projectile_unit_name, unit_template_name, extension_init_data, position, rotation)
	end

	Unit.set_unit_visibility(projectile_unit, true)
end
