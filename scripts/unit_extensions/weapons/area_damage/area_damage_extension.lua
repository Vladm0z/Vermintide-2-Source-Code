-- chunkname: @scripts/unit_extensions/weapons/area_damage/area_damage_extension.lua

AreaDamageExtension = class(AreaDamageExtension)
script_data.debug_area_damage = script_data.debug_area_damage or Development.parameter("debug_area_damage")

local var_0_0 = 0.5

AreaDamageExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.aoe_dot_damage = arg_1_3.aoe_dot_damage or Unit.get_data(arg_1_2, "aoe_dot_damage")
	arg_1_0.aoe_init_damage = arg_1_3.aoe_init_damage or Unit.get_data(arg_1_2, "aoe_init_damage")
	arg_1_0.aoe_dot_damage_interval = arg_1_3.aoe_dot_damage_interval or Unit.get_data(arg_1_2, "aoe_dot_damage_interval")
	arg_1_0.damage_ramping_function = arg_1_3.damage_ramping_function
	arg_1_0.radius = arg_1_3.radius or Unit.get_data(arg_1_2, "radius")
	arg_1_0.initial_radius = arg_1_3.initial_radius or arg_1_3.radius or Unit.get_data(arg_1_2, "radius")
	arg_1_0.life_time = arg_1_3.life_time or Unit.get_data(arg_1_2, "life_time")
	arg_1_0.player_screen_effect_name = arg_1_3.player_screen_effect_name or Unit.get_data(arg_1_2, "player_screen_effect_name")
	arg_1_0.dot_effect_name = arg_1_3.dot_effect_name or Unit.get_data(arg_1_2, "dot_effect_name")
	arg_1_0.extra_dot_effect_name = arg_1_3.extra_dot_effect_name or Unit.get_data(arg_1_2, "extra_dot_effect_name")
	arg_1_0.nav_mesh_effect = arg_1_3.nav_mesh_effect
	arg_1_0.area_damage_template = arg_1_3.area_damage_template or Unit.get_data(arg_1_2, "area_damage_template")
	arg_1_0.area_ai_random_death_template = arg_1_3.area_ai_random_death_template or Unit.get_data(arg_1_2, "area_ai_random_death_template")
	arg_1_0.invisible_unit = arg_1_3.invisible_unit or Unit.get_data(arg_1_2, "invisible_unit")
	arg_1_0.damage_players = T(arg_1_3.damage_players, T(Unit.get_data(arg_1_2, "damage_players"), true))
	arg_1_0.damage_source = arg_1_3.damage_source or "n/a"
	arg_1_0.create_nav_tag_volume = arg_1_3.create_nav_tag_volume or Unit.get_data(arg_1_2, "create_nav_tag_volume")
	arg_1_0.nav_tag_volume_layer = arg_1_3.nav_tag_volume_layer or Unit.get_data(arg_1_2, "nav_tag_volume_layer")
	arg_1_0.explosion_template_name = arg_1_3.explosion_template_name
	arg_1_0.owner_player = arg_1_3.owner_player
	arg_1_0.slow_modifier = arg_1_3.slow_modifier
	arg_1_0.source_attacker_unit = arg_1_3.source_attacker_unit
	arg_1_0.threat_duration = arg_1_3.threat_duration
	arg_1_0.effect_size = arg_1_0.radius * 1.5
	arg_1_0.damage_timer = 0
	arg_1_0.life_timer = 0
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.num_hits = 0
	arg_1_0.enabled = false
	arg_1_0.ai_system = Managers.state.entity:system("ai_system")
	arg_1_0.player_unit_particles = {}
	arg_1_0._current_damage_buffer_index = 1
	arg_1_0._damage_buffer = {}

	if arg_1_0.owner_player then
		Managers.player:assign_unit_ownership(arg_1_0.unit, arg_1_0.owner_player)
	end

	arg_1_0._side = Managers.state.side.side_by_unit[arg_1_0.source_attacker_unit]

	if arg_1_0.invisible_unit then
		Unit.set_unit_visibility(arg_1_2, false)
	end

	arg_1_0._custom_data_table = {
		parent = arg_1_0
	}
end

AreaDamageExtension.destroy = function (arg_2_0)
	Unit.flow_event(arg_2_0.unit, "lua_projectile_end")

	if not arg_2_0.area_damage_started then
		return
	end

	local var_2_0 = arg_2_0.world

	if arg_2_0.explosion_template_name then
		local var_2_1 = ExplosionUtils.get_template(arg_2_0.explosion_template_name).aoe.stop_aoe_sound_event_name

		if var_2_1 then
			WwiseUtils.trigger_unit_event(var_2_0, var_2_1, arg_2_0.unit, 0)
		end
	end

	local var_2_2 = AreaDamageTemplates.get_template(arg_2_0.area_damage_template)

	if arg_2_0.is_server and var_2_2.server.destroy then
		var_2_2.server.destroy(arg_2_0._custom_data_table)
	end

	if var_2_2.client.destroy then
		var_2_2.client.destroy(arg_2_0._custom_data_table)
	end

	if arg_2_0.effect_id then
		World.stop_spawning_particles(var_2_0, arg_2_0.effect_id)
	end

	local var_2_3 = arg_2_0.nav_mesh_effect_ids

	if var_2_3 then
		for iter_2_0 = 1, #var_2_3 do
			local var_2_4 = var_2_3[iter_2_0]

			World.stop_spawning_particles(var_2_0, var_2_4)
		end
	end

	if arg_2_0.extra_effect_id then
		World.stop_spawning_particles(var_2_0, arg_2_0.extra_effect_id)
	end

	for iter_2_1, iter_2_2 in pairs(arg_2_0.player_unit_particles) do
		World.stop_spawning_particles(var_2_0, iter_2_2.particle_id)
	end

	table.clear(arg_2_0.player_unit_particles)

	if arg_2_0.nav_tag_volume_id then
		Managers.state.entity:system("volume_system"):destroy_nav_tag_volume(arg_2_0.nav_tag_volume_id)
	end
end

AreaDamageExtension.enable_area_damage = function (arg_3_0, arg_3_1)
	if arg_3_1 then
		arg_3_0.enabled = true

		arg_3_0:start_area_damage()
	else
		arg_3_0.enabled = false
		arg_3_0.area_damage_started = false

		if arg_3_0.effect_id then
			World.stop_spawning_particles(arg_3_0.world, arg_3_0.effect_id)

			if arg_3_0.extra_effect_id then
				World.stop_spawning_particles(arg_3_0.world, arg_3_0.extra_effect_id)
			end
		end

		local var_3_0 = arg_3_0.nav_mesh_effect_ids

		if var_3_0 then
			for iter_3_0 = 1, #var_3_0 do
				local var_3_1 = var_3_0[iter_3_0]

				World.stop_spawning_particles(arg_3_0.world, var_3_1)
			end
		end

		for iter_3_1, iter_3_2 in pairs(arg_3_0.player_unit_particles) do
			World.stop_spawning_particles(arg_3_0.world, iter_3_2.particle_id)
		end

		table.clear(arg_3_0.player_unit_particles)

		if arg_3_0.nav_tag_volume_id then
			Managers.state.entity:system("volume_system"):destroy_nav_tag_volume(arg_3_0.nav_tag_volume_id)
		end
	end
end

AreaDamageExtension.start_area_damage = function (arg_4_0)
	arg_4_0.area_damage_started = true

	local var_4_0 = AreaDamageTemplates.get_template(arg_4_0.area_damage_template)

	if arg_4_0.is_server and arg_4_0.aoe_init_damage then
		local var_4_1, var_4_2 = var_4_0.server.update(arg_4_0.damage_source, arg_4_0.unit, arg_4_0.initial_radius, arg_4_0.aoe_init_damage, 0, 0, 0, 0, arg_4_0.damage_players, arg_4_0.explosion_template_name, arg_4_0.slow_modifier, arg_4_0._side)

		if var_4_1 then
			arg_4_0:_add_to_damage_buffer(var_4_2)
		end
	end

	local var_4_3 = {
		{
			particle_variable = "pool_size",
			value = Vector3(arg_4_0.effect_size, arg_4_0.effect_size, 1)
		}
	}

	if arg_4_0.dot_effect_name then
		arg_4_0.effect_id = var_4_0.client.spawn_effect(arg_4_0.world, arg_4_0.unit, arg_4_0.dot_effect_name, var_4_3)
	end

	if arg_4_0.extra_dot_effect_name then
		arg_4_0.extra_effect_id = var_4_0.client.spawn_effect(arg_4_0.world, arg_4_0.unit, arg_4_0.extra_dot_effect_name)
	end

	local var_4_4 = arg_4_0.nav_mesh_effect

	if var_4_4 then
		local var_4_5 = Unit.world_position(arg_4_0.unit, 0)
		local var_4_6 = arg_4_0.radius
		local var_4_7 = script_data.debug_nav_mesh_vfx

		if var_4_7 then
			QuickDrawerStay:circle(var_4_5, var_4_6, Vector3.up(), Color(255, 255, 255), 24)
		end

		local var_4_8 = math.pi
		local var_4_9 = {}
		local var_4_10 = 0

		arg_4_0.nav_mesh_effect_ids = var_4_9

		local var_4_11 = var_4_4.particle_radius
		local var_4_12 = var_4_4.particle_spacing
		local var_4_13 = var_4_4.particle_name
		local var_4_14 = 2 * var_4_11
		local var_4_15 = 2 * var_4_12
		local var_4_16 = (var_4_6 - var_4_11) / var_4_15
		local var_4_17 = math.floor(var_4_16)
		local var_4_18 = Managers.state.entity:system("ai_system"):nav_world()

		if var_4_7 then
			QuickDrawerStay:circle(var_4_5, var_4_12, Vector3.up(), Color(255, 255, 255), 32)
			QuickDrawerStay:circle(var_4_5, var_4_11, Vector3.up(), Color(255, 0, 255), 32)
		end

		local var_4_19

		var_4_9[var_4_19], var_4_19 = var_4_0.client.spawn_effect(arg_4_0.world, arg_4_0.unit, var_4_13, nil, var_4_5), var_4_10 + 1

		for iter_4_0 = 1, var_4_17 do
			local var_4_20 = var_4_6 - (var_4_17 - iter_4_0) * var_4_15 - var_4_11
			local var_4_21 = var_4_20 * 2 * var_4_8
			local var_4_22 = math.floor(var_4_21 / var_4_15)
			local var_4_23 = 2 * var_4_8 / var_4_22

			for iter_4_1 = 1, var_4_22 do
				local var_4_24 = iter_4_1 * var_4_23
				local var_4_25 = var_4_5 + var_4_20 * Vector3(math.cos(var_4_24), math.sin(var_4_24), 0)
				local var_4_26, var_4_27 = GwNavQueries.triangle_from_position(var_4_18, var_4_25, 1.5, 2)

				if var_4_26 then
					var_4_25.z = var_4_27

					if var_4_7 then
						QuickDrawerStay:circle(var_4_25, var_4_12, Vector3.up(), Color(255, 255, 255), 32)
						QuickDrawerStay:circle(var_4_25, var_4_11, Vector3.up(), Color(255, 0, 255), 32)
					end

					var_4_9[var_4_19], var_4_19 = var_4_0.client.spawn_effect(arg_4_0.world, arg_4_0.unit, var_4_13, nil, var_4_25), var_4_19 + 1
				elseif var_4_7 then
					QuickDrawerStay:circle(var_4_25, var_4_12, Vector3.up(), Color(125, 125, 125), 32)
					QuickDrawerStay:circle(var_4_25, var_4_11, Vector3.up(), Color(125, 125, 125), 32)
				end
			end
		end
	end

	if arg_4_0.explosion_template_name then
		local var_4_28 = arg_4_0.unit
		local var_4_29 = arg_4_0.world
		local var_4_30 = ExplosionUtils.get_template(arg_4_0.explosion_template_name)
		local var_4_31 = var_4_30.aoe.sound_event_name

		if var_4_31 then
			local var_4_32 = Unit.local_position(var_4_28, 0)

			WwiseUtils.trigger_position_event(var_4_29, var_4_31, var_4_32)
		end

		local var_4_33 = var_4_30.aoe.start_aoe_sound_event_name

		if var_4_33 then
			WwiseUtils.trigger_unit_event(var_4_29, var_4_33, var_4_28, 0)
		end
	end

	if arg_4_0.is_server then
		if arg_4_0.create_nav_tag_volume then
			if arg_4_0.nav_tag_volume_layer then
				local var_4_34 = Managers.state.entity:system("volume_system")
				local var_4_35 = Unit.world_position(arg_4_0.unit, 0)

				arg_4_0.nav_tag_volume_id = var_4_34:create_nav_tag_volume_from_data(var_4_35, arg_4_0.radius + var_0_0, arg_4_0.nav_tag_volume_layer)
			else
				Application.warning(string.format("[AreaDamageExtension] create_nav_tag_volume is set but there are no nav_tag_volume_template set for unit %s", arg_4_0.unit))
			end
		end

		if arg_4_0.threat_duration and arg_4_0.threat_duration > 0 then
			local var_4_36 = "AreaDamageExtension"
			local var_4_37 = Unit.world_position(arg_4_0.unit, 0)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_4_37, "sphere", arg_4_0.radius + var_0_0, nil, arg_4_0.threat_duration, var_4_36)
		end
	end
end

AreaDamageExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_0:_update_damage_buffer()

	if not arg_5_0.area_damage_started then
		return
	end

	local var_5_0 = AreaDamageTemplates.get_template(arg_5_0.area_damage_template)

	if arg_5_0.is_server then
		local var_5_1, var_5_2 = var_5_0.server.update(arg_5_0.damage_source, arg_5_0.unit, arg_5_0.radius, arg_5_0.aoe_dot_damage, arg_5_0.life_time, arg_5_0.life_timer, arg_5_0.aoe_dot_damage_interval, arg_5_0.damage_timer, arg_5_0.damage_players, arg_5_0.explosion_template_name, arg_5_0.slow_modifier, arg_5_0._side, arg_5_0._custom_data_table)

		if var_5_1 then
			arg_5_0:_add_to_damage_buffer(var_5_2)
		end

		if arg_5_0.area_ai_random_death_template then
			local var_5_3, var_5_4 = AreaDamageTemplates.get_template(arg_5_0.area_ai_random_death_template).server.update(arg_5_0.damage_source, arg_5_0.unit, arg_5_0.radius, arg_5_0.aoe_dot_damage_interval, arg_5_0.damage_timer)

			if var_5_3 then
				arg_5_0:_add_to_damage_buffer(var_5_4)
			end
		end

		if var_5_1 then
			arg_5_0.damage_timer = 0
		end
	end

	var_5_0.client.update(arg_5_0.world, arg_5_0.radius, arg_5_0.unit, arg_5_0.player_screen_effect_name, arg_5_0.player_unit_particles, arg_5_0.damage_players, arg_5_0.explosion_template_name, arg_5_0.slow_modifier, arg_5_0._side, arg_5_0._custom_data_table)

	arg_5_0.damage_timer = arg_5_0.damage_timer + arg_5_3
	arg_5_0.life_timer = arg_5_0.life_timer + arg_5_3

	if script_data.debug_area_damage then
		QuickDrawer:sphere(Unit.local_position(arg_5_0.unit, 0), arg_5_0.radius, Colors.get("hot_pink"))
	end
end

local var_0_1 = 1

AreaDamageExtension._update_damage_buffer = function (arg_6_0)
	if not arg_6_0.is_server then
		return
	end

	local var_6_0 = arg_6_0._damage_buffer
	local var_6_1 = arg_6_0.num_hits

	if #var_6_0 == 0 then
		return
	end

	local var_6_2 = arg_6_0._current_damage_buffer_index
	local var_6_3 = var_6_2 + var_0_1 - 1
	local var_6_4 = false

	for iter_6_0 = var_6_2, var_6_3 do
		local var_6_5 = var_6_0[iter_6_0]

		if not var_6_5 then
			var_6_4 = true

			break
		end

		local var_6_6 = var_6_5.unit

		if Unit.alive(var_6_6) then
			var_6_1 = var_6_1 + 1

			AreaDamageTemplates.get_template(var_6_5.area_damage_template).server.do_damage(var_6_5, arg_6_0.unit, arg_6_0.source_attacker_unit, arg_6_0._custom_data_table)
		end
	end

	arg_6_0.num_hits = var_6_1

	if var_6_4 then
		arg_6_0._current_damage_buffer_index = 1

		table.clear(var_6_0)
	else
		arg_6_0._current_damage_buffer_index = var_6_3 + 1
	end
end

AreaDamageExtension._add_to_damage_buffer = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._damage_buffer
	local var_7_1 = #arg_7_0._damage_buffer
	local var_7_2 = #arg_7_1

	for iter_7_0 = 1, var_7_2 do
		var_7_0[var_7_1 + iter_7_0] = arg_7_1[iter_7_0]
	end
end

AreaDamageExtension.hot_join_sync = function (arg_8_0, arg_8_1)
	return
end
