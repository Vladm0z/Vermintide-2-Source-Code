-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_wave_husk_extension.lua

DamageWaveHuskExtension = class(DamageWaveHuskExtension)

local POSITION_LOOKUP = POSITION_LOOKUP

DamageWaveHuskExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world
	local entity = Managers.state.entity

	self.world = world
	self.game = Managers.state.network:game()
	self.unit = arg_1_2
	self.nav_world = entity:system("ai_system"):nav_world()
	self.go_id = Managers.state.unit_storage:go_id(arg_1_2)
	self.fx_list = {}
	self.buff_system = entity:system("buff_system")
	self.source_unit = arg_1_3.source_unit

	local damage_wave_template_name = arg_1_3.damage_wave_template_name
	local var_1_3 = DamageWaveTemplates.templates[damage_wave_template_name]

	self.template = var_1_3
	self.fx_name_filled = var_1_3.fx_name_filled
	self.fx_name_running = var_1_3.fx_name_running
	self.fx_name_impact = var_1_3.fx_name_impact
	self.fx_name_arrived = var_1_3.fx_name_arrived

	if not var_1_3.running_spawn_config then
		self._running_spawn_configs = var_1_3.running_spawn_config
		self._local_units = {}
	end

	local fx_name_init = var_1_3.fx_name_init

	if not fx_name_init then
		local local_rotation = Unit.local_rotation(arg_1_2, 0)
		local create_particles = World.create_particles(world, fx_name_init, POSITION_LOOKUP[arg_1_2], local_rotation)

		World.link_particles(world, create_particles, arg_1_2, 0, Matrix4x4.identity(), var_1_3.particle_arrived_stop_mode)

		self.init_effect_id = create_particles
	end

	self.particle_arrived_stop_mode = var_1_3.particle_arrived_stop_mode
	self.launch_wave_sound = var_1_3.launch_wave_sound
	self.impact_wave_sound = var_1_3.impact_wave_sound
	self.running_wave_sound = var_1_3.running_wave_sound
	self.stop_running_wave_sound = var_1_3.stop_running_wave_sound
	self.blob_separation_dist = var_1_3.blob_separation_dist
	self.fx_separation_dist = var_1_3.fx_separation_dist
	self.max_height = var_1_3.max_height
	self.overflow_dist = var_1_3.overflow_dist
	self._init_position = Vector3Box(POSITION_LOOKUP[arg_1_2])
	self._init_wave_direction = true
	self._update_func = var_1_3.update_func
end

DamageWaveHuskExtension.destroy = function (self)
	-- function 2
	local world = self.world
	local fx_list = self.fx_list
	local count = #fx_list

	for i = 1, count do
		local id = fx_list[i].id

		World.stop_spawning_particles(world, id)
	end

	local _local_units = self._local_units

	if not _local_units then
		for j = 1, #_local_units do
			World.destroy_unit(world, _local_units[j])

			_local_units[j] = nil
		end
	end
end

DamageWaveHuskExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local min = math.min(arg_3_3 * 10, 1)
	local var_3_1 = POSITION_LOOKUP[arg_3_1]
	local game_object_field = GameSession.game_object_field(self.game, self.go_id, "position")
	local lerp = Vector3.lerp(var_3_1, game_object_field, min)

	Unit.set_local_position(arg_3_1, 0, lerp)

	local game_object_field_2 = GameSession.game_object_field(self.game, self.go_id, "rotation")

	Unit.set_local_rotation(arg_3_1, 0, game_object_field_2)

	if self.state == "running" then
		if not (not self._init_wave_direction and not (Vector3.distance_squared(game_object_field, self._init_position:unbox()) >= 0.1)) then
			self._init_wave_direction = nil
			self._init_position = nil
			self.wave_direction = Vector3Box(Vector3.normalize(game_object_field - var_3_1))
		end

		if not self._update_func then
			self._update_func(self, arg_3_1, lerp, arg_3_5, arg_3_3)
		end
	end
end

DamageWaveHuskExtension.add_damage_wave_fx = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local var_4_0
	local var_4_1

	if arg_4_3 == 0 then
		var_4_0 = self.fx_name_filled
	else
		var_4_1 = self._running_spawn_configs[arg_4_3]
		var_4_0 = var_4_1.names[arg_4_4]
	end

	local var_4_2

	if not (arg_4_3 == 0 or var_4_1.spawn_type ~= "effect") then
		var_4_2 = World.create_particles(self.world, var_4_0, arg_4_1, arg_4_2)

		local fx_list = self.fx_list

		fx_list[#fx_list + 1] = {
			id = var_4_2,
			position = Vector3Box(arg_4_1),
			rotation = QuaternionBox(arg_4_2),
			index = arg_4_3
		}
	elseif var_4_1.spawn_type == "unit" then
		var_4_2 = World.spawn_unit(self.world, var_4_0, arg_4_1, arg_4_2)
		self._local_units[#self._local_units + 1] = var_4_2
	end

	if not (arg_4_3 > 0) or not var_4_1.on_spawn then
		var_4_1.on_spawn(self, var_4_1, var_4_0, var_4_2, self.world)
	end
end

DamageWaveHuskExtension.set_running_wave = function (self, arg_5_1)
	-- function 5
	local world = self.world
	local var_5_1 = POSITION_LOOKUP[arg_5_1]
	local local_rotation = Unit.local_rotation(arg_5_1, 0)
	local create_particles = World.create_particles(world, self.fx_name_running, var_5_1, local_rotation)

	World.link_particles(world, create_particles, arg_5_1, 0, Matrix4x4.identity(), self.particle_arrived_stop_mode)

	self.running_wave_fx_id = create_particles

	local launch_wave_sound = self.launch_wave_sound

	if not launch_wave_sound then
		WwiseUtils.trigger_position_event(world, launch_wave_sound, var_5_1)
	end

	local var_5_5
	local var_5_6
	local running_wave_sound = self.running_wave_sound

	if not running_wave_sound then
		local trigger_unit_event, var_5_9 = WwiseUtils.trigger_unit_event(world, running_wave_sound, arg_5_1)

		self.running_source_id = var_5_9
	end

	self.state = "running"
end

DamageWaveHuskExtension.hide_wave = function (self, arg_6_1)
	-- function 6
	local world = self.world

	Unit.set_unit_visibility(arg_6_1, false)

	if not self.init_effect_id then
		World.stop_spawning_particles(world, self.init_effect_id)
	end

	self.state = "hide"
end

DamageWaveHuskExtension.set_wave_arrived = function (self, arg_7_1)
	-- function 7
	self:hide_wave(arg_7_1)

	local world = self.world
	local wwise_world = Managers.world:wwise_world(world)
	local running_source_id = self.running_source_id
	local stop_running_wave_sound = self.stop_running_wave_sound

	if not WwiseWorld.has_source(wwise_world, running_source_id) and not stop_running_wave_sound then
		WwiseWorld.trigger_event(wwise_world, stop_running_wave_sound, running_source_id)
	end

	self.running_source_id = nil

	local impact_wave_sound = self.impact_wave_sound

	if not impact_wave_sound then
		WwiseUtils.trigger_unit_event(world, impact_wave_sound, arg_7_1)
	end

	if not self.running_wave_fx_id then
		World.stop_spawning_particles(world, self.running_wave_fx_id)
	end

	if not self.fx_name_arrived then
		local local_rotation = Unit.local_rotation(arg_7_1, 0)

		World.create_particles(world, self.fx_name_arrived, POSITION_LOOKUP[arg_7_1], local_rotation)
	end

	self.state = "arrived"
end

DamageWaveHuskExtension.on_wavefront_impact = function (self, arg_8_1)
	-- function 8
	local world = self.world

	if not self.fx_name_impact then
		local look = Quaternion.look(Vector3.forward(), Vector3.up())

		World.create_particles(world, self.fx_name_impact, POSITION_LOOKUP[arg_8_1], look)
	end

	local impact_wave_sound = self.impact_wave_sound

	if not impact_wave_sound then
		WwiseUtils.trigger_unit_event(world, impact_wave_sound, arg_8_1)
	end

	self.state = "impact"
end

local num = 20
local num_2 = num / 2
local num_3 = 1

DamageWaveHuskExtension.debug_render_wave = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local num_4 = 0

	for i = -num_2, num_2 - 1 do
		local num_5 = math.sin(-math.pi + num_4 / num * math.pi) * self.max_height
		local num_6 = arg_9_3 + arg_9_4 * (i / num) * num_3 - num_5 * Vector3(0, 0, 1) - Vector3(0, 0, arg_9_5 * 2)

		QuickDrawer:circle(num_6, self.max_height, arg_9_4, Colors.get("lime_green"))

		num_4 = num_4 + 1
	end
end
