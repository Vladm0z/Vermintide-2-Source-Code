-- chunkname: @scripts/unit_extensions/weapons/area_damage/area_damage_extension.lua

AreaDamageExtension = class(AreaDamageExtension)

local script_data = script_data
local debug_area_damage = script_data.debug_area_damage

debug_area_damage = debug_area_damage or Development.parameter("debug_area_damage")
script_data.debug_area_damage = debug_area_damage

local num = 0.5

AreaDamageExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2

	local aoe_dot_damage = arg_1_3.aoe_dot_damage

	aoe_dot_damage = aoe_dot_damage or Unit.get_data(arg_1_2, "aoe_dot_damage")
	self.aoe_dot_damage = aoe_dot_damage

	local aoe_init_damage = arg_1_3.aoe_init_damage

	aoe_init_damage = aoe_init_damage or Unit.get_data(arg_1_2, "aoe_init_damage")
	self.aoe_init_damage = aoe_init_damage

	local aoe_dot_damage_interval = arg_1_3.aoe_dot_damage_interval

	aoe_dot_damage_interval = aoe_dot_damage_interval or Unit.get_data(arg_1_2, "aoe_dot_damage_interval")
	self.aoe_dot_damage_interval = aoe_dot_damage_interval
	self.damage_ramping_function = arg_1_3.damage_ramping_function

	local radius = arg_1_3.radius

	radius = radius or Unit.get_data(arg_1_2, "radius")
	self.radius = radius

	local initial_radius = arg_1_3.initial_radius

	if not initial_radius then
		initial_radius = arg_1_3.radius
		initial_radius = initial_radius or Unit.get_data(arg_1_2, "radius")
	end

	self.initial_radius = initial_radius

	local life_time = arg_1_3.life_time

	life_time = life_time or Unit.get_data(arg_1_2, "life_time")
	self.life_time = life_time

	local player_screen_effect_name = arg_1_3.player_screen_effect_name

	player_screen_effect_name = player_screen_effect_name or Unit.get_data(arg_1_2, "player_screen_effect_name")
	self.player_screen_effect_name = player_screen_effect_name

	local dot_effect_name = arg_1_3.dot_effect_name

	dot_effect_name = dot_effect_name or Unit.get_data(arg_1_2, "dot_effect_name")
	self.dot_effect_name = dot_effect_name

	local extra_dot_effect_name = arg_1_3.extra_dot_effect_name

	extra_dot_effect_name = extra_dot_effect_name or Unit.get_data(arg_1_2, "extra_dot_effect_name")
	self.extra_dot_effect_name = extra_dot_effect_name
	self.nav_mesh_effect = arg_1_3.nav_mesh_effect

	local area_damage_template = arg_1_3.area_damage_template

	area_damage_template = area_damage_template or Unit.get_data(arg_1_2, "area_damage_template")
	self.area_damage_template = area_damage_template

	local area_ai_random_death_template = arg_1_3.area_ai_random_death_template

	area_ai_random_death_template = area_ai_random_death_template or Unit.get_data(arg_1_2, "area_ai_random_death_template")
	self.area_ai_random_death_template = area_ai_random_death_template

	local invisible_unit = arg_1_3.invisible_unit

	invisible_unit = invisible_unit or Unit.get_data(arg_1_2, "invisible_unit")
	self.invisible_unit = invisible_unit
	self.damage_players = T(arg_1_3.damage_players, T(Unit.get_data(arg_1_2, "damage_players"), true))

	local damage_source = arg_1_3.damage_source

	damage_source = damage_source or "n/a"
	self.damage_source = damage_source

	local create_nav_tag_volume = arg_1_3.create_nav_tag_volume

	create_nav_tag_volume = create_nav_tag_volume or Unit.get_data(arg_1_2, "create_nav_tag_volume")
	self.create_nav_tag_volume = create_nav_tag_volume

	local nav_tag_volume_layer = arg_1_3.nav_tag_volume_layer

	nav_tag_volume_layer = nav_tag_volume_layer or Unit.get_data(arg_1_2, "nav_tag_volume_layer")
	self.nav_tag_volume_layer = nav_tag_volume_layer
	self.explosion_template_name = arg_1_3.explosion_template_name
	self.owner_player = arg_1_3.owner_player
	self.slow_modifier = arg_1_3.slow_modifier
	self.source_attacker_unit = arg_1_3.source_attacker_unit
	self.threat_duration = arg_1_3.threat_duration
	self.effect_size = self.radius * 1.5
	self.damage_timer = 0
	self.life_timer = 0
	self.is_server = Managers.player.is_server
	self.num_hits = 0
	self.enabled = false
	self.ai_system = Managers.state.entity:system("ai_system")
	self.player_unit_particles = {}
	self._current_damage_buffer_index = 1
	self._damage_buffer = {}

	if not self.owner_player then
		Managers.player:assign_unit_ownership(self.unit, self.owner_player)
	end

	self._side = Managers.state.side.side_by_unit[self.source_attacker_unit]

	if not self.invisible_unit then
		Unit.set_unit_visibility(arg_1_2, false)
	end

	self._custom_data_table = {
		parent = self
	}
end

AreaDamageExtension.destroy = function (self)
	-- function 2
	Unit.flow_event(self.unit, "lua_projectile_end")

	if not self.area_damage_started then
		return
	end

	local world = self.world

	if not self.explosion_template_name then
		local stop_aoe_sound_event_name = ExplosionUtils.get_template(self.explosion_template_name).aoe.stop_aoe_sound_event_name

		if not stop_aoe_sound_event_name then
			WwiseUtils.trigger_unit_event(world, stop_aoe_sound_event_name, self.unit, 0)
		end
	end

	local get_template = AreaDamageTemplates.get_template(self.area_damage_template)

	if not self.is_server and not get_template.server.destroy then
		get_template.server.destroy(self._custom_data_table)
	end

	if not get_template.client.destroy then
		get_template.client.destroy(self._custom_data_table)
	end

	if not self.effect_id then
		World.stop_spawning_particles(world, self.effect_id)
	end

	local nav_mesh_effect_ids = self.nav_mesh_effect_ids

	if not nav_mesh_effect_ids then
		for i = 1, #nav_mesh_effect_ids do
			local var_2_4 = nav_mesh_effect_ids[i]

			World.stop_spawning_particles(world, var_2_4)
		end
	end

	if not self.extra_effect_id then
		World.stop_spawning_particles(world, self.extra_effect_id)
	end

	for k, v in pairs(self.player_unit_particles) do
		World.stop_spawning_particles(world, v.particle_id)
	end

	table.clear(self.player_unit_particles)

	if not self.nav_tag_volume_id then
		Managers.state.entity:system("volume_system"):destroy_nav_tag_volume(self.nav_tag_volume_id)
	end
end

AreaDamageExtension.enable_area_damage = function (self, arg_3_1)
	-- function 3
	if not arg_3_1 then
		self.enabled = true

		self:start_area_damage()
	else
		self.enabled = false
		self.area_damage_started = false

		if not self.effect_id then
			World.stop_spawning_particles(self.world, self.effect_id)

			if not self.extra_effect_id then
				World.stop_spawning_particles(self.world, self.extra_effect_id)
			end
		end

		local nav_mesh_effect_ids = self.nav_mesh_effect_ids

		if not nav_mesh_effect_ids then
			for i = 1, #nav_mesh_effect_ids do
				local var_3_1 = nav_mesh_effect_ids[i]

				World.stop_spawning_particles(self.world, var_3_1)
			end
		end

		for k, v in pairs(self.player_unit_particles) do
			World.stop_spawning_particles(self.world, v.particle_id)
		end

		table.clear(self.player_unit_particles)

		if not self.nav_tag_volume_id then
			Managers.state.entity:system("volume_system"):destroy_nav_tag_volume(self.nav_tag_volume_id)
		end
	end
end

AreaDamageExtension.start_area_damage = function (self)
	-- function 4
	self.area_damage_started = true

	local get_template = AreaDamageTemplates.get_template(self.area_damage_template)

	if not self.is_server and not self.aoe_init_damage then
		local update, var_4_2 = get_template.server.update(self.damage_source, self.unit, self.initial_radius, self.aoe_init_damage, 0, 0, 0, 0, self.damage_players, self.explosion_template_name, self.slow_modifier, self._side)

		if not update then
			self:_add_to_damage_buffer(var_4_2)
		end
	end

	local tbl = {
		{
			particle_variable = "pool_size",
			value = Vector3(self.effect_size, self.effect_size, 1)
		}
	}

	if not self.dot_effect_name then
		self.effect_id = get_template.client.spawn_effect(self.world, self.unit, self.dot_effect_name, tbl)
	end

	if not self.extra_dot_effect_name then
		self.extra_effect_id = get_template.client.spawn_effect(self.world, self.unit, self.extra_dot_effect_name)
	end

	local nav_mesh_effect = self.nav_mesh_effect

	if not nav_mesh_effect then
		local world_position = Unit.world_position(self.unit, 0)
		local radius = self.radius
		local debug_nav_mesh_vfx = script_data.debug_nav_mesh_vfx

		if not debug_nav_mesh_vfx then
			QuickDrawerStay:circle(world_position, radius, Vector3.up(), Color(255, 255, 255), 24)
		end

		local pi = math.pi
		local tbl_2 = {}
		local num_2 = 0

		self.nav_mesh_effect_ids = tbl_2

		local particle_radius = nav_mesh_effect.particle_radius
		local particle_spacing = nav_mesh_effect.particle_spacing
		local particle_name = nav_mesh_effect.particle_name
		local num_3 = 2 * particle_radius
		local num_4 = 2 * particle_spacing
		local num_5 = (radius - particle_radius) / num_4
		local floor = math.floor(num_5)
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()

		if not debug_nav_mesh_vfx then
			QuickDrawerStay:circle(world_position, particle_spacing, Vector3.up(), Color(255, 255, 255), 32)
			QuickDrawerStay:circle(world_position, particle_radius, Vector3.up(), Color(255, 0, 255), 32)
		end

		local num_6

		tbl_2[num_6], num_6 = get_template.client.spawn_effect(self.world, self.unit, particle_name, nil, world_position), num_2 + 1

		for i = 1, floor do
			local num_7 = radius - (floor - i) * num_4 - particle_radius
			local num_8 = num_7 * 2 * pi
			local floor_2 = math.floor(num_8 / num_4)
			local num_9 = 2 * pi / floor_2

			for j = 1, floor_2 do
				local num_10 = j * num_9
				local num_11 = world_position + num_7 * Vector3(math.cos(num_10), math.sin(num_10), 0)
				local triangle_from_position, var_4_27 = GwNavQueries.triangle_from_position(nav_world, num_11, 1.5, 2)

				if not triangle_from_position then
					num_11.z = var_4_27

					if not debug_nav_mesh_vfx then
						QuickDrawerStay:circle(num_11, particle_spacing, Vector3.up(), Color(255, 255, 255), 32)
						QuickDrawerStay:circle(num_11, particle_radius, Vector3.up(), Color(255, 0, 255), 32)
					end

					tbl_2[num_6], num_6 = get_template.client.spawn_effect(self.world, self.unit, particle_name, nil, num_11), num_6 + 1
				elseif not debug_nav_mesh_vfx then
					QuickDrawerStay:circle(num_11, particle_spacing, Vector3.up(), Color(125, 125, 125), 32)
					QuickDrawerStay:circle(num_11, particle_radius, Vector3.up(), Color(125, 125, 125), 32)
				end
			end
		end
	end

	if not self.explosion_template_name then
		local unit = self.unit
		local world = self.world
		local get_template_2 = ExplosionUtils.get_template(self.explosion_template_name)
		local sound_event_name = get_template_2.aoe.sound_event_name

		if not sound_event_name then
			local local_position = Unit.local_position(unit, 0)

			WwiseUtils.trigger_position_event(world, sound_event_name, local_position)
		end

		local start_aoe_sound_event_name = get_template_2.aoe.start_aoe_sound_event_name

		if not start_aoe_sound_event_name then
			WwiseUtils.trigger_unit_event(world, start_aoe_sound_event_name, unit, 0)
		end
	end

	if not self.is_server then
		if not self.create_nav_tag_volume then
			if not self.nav_tag_volume_layer then
				local system = Managers.state.entity:system("volume_system")
				local world_position_2 = Unit.world_position(self.unit, 0)

				self.nav_tag_volume_id = system:create_nav_tag_volume_from_data(world_position_2, self.radius + num, self.nav_tag_volume_layer)
			else
				Application.warning(string.format("[AreaDamageExtension] create_nav_tag_volume is set but there are no nav_tag_volume_template set for unit %s", self.unit))
			end
		end

		if not (not self.threat_duration and not (self.threat_duration > 0)) then
			local str = "AreaDamageExtension"
			local world_position_3 = Unit.world_position(self.unit, 0)

			Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(world_position_3, "sphere", self.radius + num, nil, self.threat_duration, str)
		end
	end
end

AreaDamageExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	self:_update_damage_buffer()

	if not self.area_damage_started then
		return
	end

	local get_template = AreaDamageTemplates.get_template(self.area_damage_template)

	if not self.is_server then
		local update, var_5_2 = get_template.server.update(self.damage_source, self.unit, self.radius, self.aoe_dot_damage, self.life_time, self.life_timer, self.aoe_dot_damage_interval, self.damage_timer, self.damage_players, self.explosion_template_name, self.slow_modifier, self._side, self._custom_data_table)

		if not update then
			self:_add_to_damage_buffer(var_5_2)
		end

		if not self.area_ai_random_death_template then
			local update_2, var_5_4 = AreaDamageTemplates.get_template(self.area_ai_random_death_template).server.update(self.damage_source, self.unit, self.radius, self.aoe_dot_damage_interval, self.damage_timer)

			if not update_2 then
				self:_add_to_damage_buffer(var_5_4)
			end
		end

		if not update then
			self.damage_timer = 0
		end
	end

	get_template.client.update(self.world, self.radius, self.unit, self.player_screen_effect_name, self.player_unit_particles, self.damage_players, self.explosion_template_name, self.slow_modifier, self._side, self._custom_data_table)

	self.damage_timer = self.damage_timer + arg_5_3
	self.life_timer = self.life_timer + arg_5_3

	if not script_data.debug_area_damage then
		QuickDrawer:sphere(Unit.local_position(self.unit, 0), self.radius, Colors.get("hot_pink"))
	end
end

local num_2 = 1

AreaDamageExtension._update_damage_buffer = function (self)
	-- function 6
	if not self.is_server then
		return
	end

	local _damage_buffer = self._damage_buffer
	local num_hits = self.num_hits

	if #_damage_buffer == 0 then
		return
	end

	local _current_damage_buffer_index = self._current_damage_buffer_index
	local num = _current_damage_buffer_index + num_2 - 1
	local flag = false

	for i = _current_damage_buffer_index, num do
		local var_6_5 = _damage_buffer[i]

		if not var_6_5 then
			flag = true

			break
		end

		local unit = var_6_5.unit

		if not Unit.alive(unit) then
			num_hits = num_hits + 1

			AreaDamageTemplates.get_template(var_6_5.area_damage_template).server.do_damage(var_6_5, self.unit, self.source_attacker_unit, self._custom_data_table)
		end
	end

	self.num_hits = num_hits

	if not flag then
		self._current_damage_buffer_index = 1

		table.clear(_damage_buffer)
	else
		self._current_damage_buffer_index = num + 1
	end
end

AreaDamageExtension._add_to_damage_buffer = function (self, arg_7_1)
	-- function 7
	local _damage_buffer = self._damage_buffer
	local count = #self._damage_buffer
	local count_2 = #arg_7_1

	for i = 1, count_2 do
		_damage_buffer[count + i] = arg_7_1[i]
	end
end

AreaDamageExtension.hot_join_sync = function (arg_8_0, arg_8_1)
	-- function 8
	return
end
