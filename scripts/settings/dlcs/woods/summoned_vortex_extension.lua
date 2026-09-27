-- chunkname: @scripts/settings/dlcs/woods/summoned_vortex_extension.lua

SummonedVortexExtension = class(SummonedVortexExtension)

local alive = Unit.alive
local POSITION_LOOKUP = POSITION_LOOKUP
local BLACKBOARDS = BLACKBOARDS
local num = 36
local num_2 = 2 * math.pi / num
local num_3 = 0.5
local tbl = {
	chaos_marauder_with_shield = true,
	chaos_raider = true,
	chaos_fanatic = true,
	skaven_slave = true,
	chaos_berzerker = true,
	skaven_clan_rat_with_shield = true,
	skaven_clan_rat = true,
	chaos_marauder = true
}

SummonedVortexExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self.world = world
	self.unit = arg_1_2
	self._target_is_caught = false

	local system = Managers.state.entity:system("ai_system")

	self.ai_system = system
	self.nav_world = system:nav_world()

	local side_id = arg_1_3.side_id

	self._vortex_bp_categories = Managers.state.side:get_side(side_id).enemy_broadphase_categories

	local vortex_template_name = arg_1_3.vortex_template_name
	local var_1_4 = VortexTemplates[vortex_template_name]

	self.vortex_template_name = vortex_template_name
	self.vortex_template = var_1_4

	local inner_fx_name = var_1_4.inner_fx_name
	local var_1_6 = POSITION_LOOKUP[arg_1_2]
	local create_particles = World.create_particles(world, inner_fx_name, var_1_6)
	local local_rotation = Unit.local_rotation(arg_1_2, 0)
	local from_quaternion = Matrix4x4.from_quaternion(local_rotation)
	local num = var_1_4.full_inner_radius / var_1_4.full_fx_radius
	local inner_fx_z_scale_multiplier = var_1_4.inner_fx_z_scale_multiplier

	inner_fx_z_scale_multiplier = inner_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(from_quaternion, Vector3(num, num, inner_fx_z_scale_multiplier))
	World.link_particles(world, create_particles, arg_1_2, 0, from_quaternion, "stop")

	self._inner_fx_id = create_particles

	local outer_fx_name = var_1_4.outer_fx_name
	local create_particles_2 = World.create_particles(world, outer_fx_name, var_1_6)
	local from_quaternion_2 = Matrix4x4.from_quaternion(local_rotation)
	local num_2 = var_1_4.full_outer_radius / var_1_4.full_fx_radius
	local outer_fx_z_scale_multiplier = var_1_4.outer_fx_z_scale_multiplier

	outer_fx_z_scale_multiplier = outer_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(from_quaternion_2, Vector3(num_2, num_2, outer_fx_z_scale_multiplier))
	World.link_particles(world, create_particles_2, arg_1_2, 0, from_quaternion_2, "stop")

	self._outer_fx_id = create_particles_2
	self.current_height_lerp = 0
	self._target_unit = arg_1_3.target_unit

	if not ALIVE[self._target_unit] then
		self._target_is_player = BLACKBOARDS[self._target_unit].is_player
	end

	local inner_decal_unit = arg_1_3.inner_decal_unit

	if not inner_decal_unit then
		World.link_unit(world, inner_decal_unit, arg_1_2, 0)
		Unit.set_local_scale(inner_decal_unit, 0, Vector3(num, num, 1))
		Unit.flow_event(inner_decal_unit, "vortex_spawned")

		self._inner_decal_unit = inner_decal_unit
	end

	local outer_decal_unit = arg_1_3.outer_decal_unit

	if not outer_decal_unit then
		World.link_unit(world, outer_decal_unit, arg_1_2, 0)
		Unit.set_local_scale(outer_decal_unit, 0, Vector3(num_2, num_2, 1))
		Unit.flow_event(outer_decal_unit, "vortex_spawned")

		self._outer_decal_unit = outer_decal_unit
	end

	if not var_1_4.use_nav_cost_map_volumes then
		local full_outer_radius = var_1_4.full_outer_radius
		local high_cost_nav_cost_map_cost_type = var_1_4.high_cost_nav_cost_map_cost_type
		local medium_cost_nav_cost_map_cost_type = var_1_4.medium_cost_nav_cost_map_cost_type

		self:_create_nav_cost_maps(system, var_1_6, full_outer_radius, high_cost_nav_cost_map_cost_type, medium_cost_nav_cost_map_cost_type)
	end

	local owner_unit = arg_1_3.owner_unit

	owner_unit = owner_unit or arg_1_2
	self._owner_unit = owner_unit
end

SummonedVortexExtension._create_nav_cost_maps = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_2 = Vector3Box(arg_2_2)

	local function fn()
		-- function 3
		if not arg_2_0._nav_cb_blocker then
			return
		end

		local num = 1
		local from_translation = Matrix4x4.from_translation(arg_2_2:unbox())
		local var_3_2 = Vector3(arg_2_3, arg_2_3, 1)
		local create_nav_cost_map = arg_2_1:create_nav_cost_map(arg_2_4, num)

		arg_2_0._high_cost_nav_cost_map_volume_id = arg_2_1:add_nav_cost_map_box_volume(from_translation, var_3_2, create_nav_cost_map)
		arg_2_0._high_cost_nav_cost_map_id = create_nav_cost_map

		local create_nav_cost_map_2 = arg_2_1:create_nav_cost_map(arg_2_5, num)

		arg_2_0._medium_cost_nav_cost_map_volume_id = arg_2_1:add_nav_cost_map_box_volume(from_translation, var_3_2, create_nav_cost_map_2)
		arg_2_0._medium_cost_nav_cost_map_id = create_nav_cost_map_2

		local time = Managers.time:time("game")

		arg_2_0._next_nav_cost_map_update_t = time + num_3
		arg_2_0._use_nav_cost_map_volumes = true
	end

	Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)
end

SummonedVortexExtension.extensions_ready = function (self, arg_4_1, arg_4_2)
	-- function 4
	local vortex_template = self.vortex_template
	local time = Managers.time:time("game")
	local var_4_2

	if not self._target_is_player then
		var_4_2 = vortex_template.time_of_life_player_target
	else
		var_4_2 = vortex_template.time_of_life
	end

	local var_4_3 = num

	self.vortex_data = {
		height = 5,
		current_raycast_rad = 0,
		start_lerp_height = 5,
		physics_world = World.get_data(arg_4_1, "physics_world"),
		wanted_height = vortex_template.max_height,
		height_ring_buffer = {
			write_index = 1,
			buffer = Script.new_array(var_4_3),
			max_size = var_4_3
		},
		inner_radius = vortex_template.full_inner_radius,
		outer_radius = vortex_template.full_outer_radius,
		fx_radius = vortex_template.full_fx_radius,
		windup_time = time + vortex_template.windup_time,
		time_of_death = time + ConflictUtils.random_interval(var_4_2),
		vortex_template = vortex_template
	}

	local start_sound_event_name = vortex_template.start_sound_event_name

	start_sound_event_name = start_sound_event_name or "Play_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(arg_4_1, start_sound_event_name, arg_4_2)
end

SummonedVortexExtension.refresh_duration = function (self)
	-- function 5
	if not self.vortex_data then
		return
	end

	local time = Managers.time:time("game")
	local vortex_template = self.vortex_template
	local random_interval = ConflictUtils.random_interval(vortex_template.time_of_life)
	local _target_unit = self._target_unit

	if not ALIVE[_target_unit] then
		self.vortex_data.time_of_death = time + random_interval

		return
	end

	local name = BLACKBOARDS[_target_unit].breed.name
	local reduce_duration_per_breed = vortex_template.reduce_duration_per_breed
	local var_5_6

	if not reduce_duration_per_breed then
		var_5_6 = reduce_duration_per_breed[name]

		if not var_5_6 then
			-- Nothing
		end
	end

	var_5_6 = 1

	::label_5_0::

	local clamp = math.clamp(random_interval * var_5_6, 0, math.huge)

	self.vortex_data.time_of_death = time + clamp
end

SummonedVortexExtension.destroy = function (self)
	-- function 6
	local unit = self.unit

	self._nav_cb_blocker = true

	local _target_unit = self._target_unit

	if not HEALTH_ALIVE[_target_unit] then
		local var_6_2 = BLACKBOARDS[_target_unit]

		if not var_6_2 then
			if not self._target_is_player then
				StatusUtils.set_in_vortex_network(_target_unit, false, nil)
			else
				local var_6_3 = Vector3(0, 0, -6)
				local locomotion_extension = var_6_2.locomotion_extension

				if not locomotion_extension then
					locomotion_extension:set_wanted_velocity(var_6_3)
					locomotion_extension:set_affected_by_gravity(true)
					locomotion_extension:set_movement_type("constrained_by_mover")
				end

				local ejected_from_vortex = var_6_2.ejected_from_vortex

				ejected_from_vortex = ejected_from_vortex or Vector3Box()

				ejected_from_vortex:store(var_6_3)

				var_6_2.ejected_from_vortex = ejected_from_vortex
				var_6_2.in_vortex_state = "ejected_from_vortex"
			end
		end
	end

	local _inner_decal_unit = self._inner_decal_unit

	if not alive(_inner_decal_unit) then
		Unit.flow_event(_inner_decal_unit, "vortex_despawned")
	end

	local _outer_decal_unit = self._outer_decal_unit

	if not alive(_outer_decal_unit) then
		Unit.flow_event(_outer_decal_unit, "vortex_despawned")
	end

	table.clear(self.vortex_data)

	self.vortex_data = nil

	local world = self.world
	local stop_sound_event_name = self.vortex_template.stop_sound_event_name

	stop_sound_event_name = stop_sound_event_name or "Stop_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(world, stop_sound_event_name, unit)

	if not self._use_nav_cost_map_volumes then
		local ai_system = self.ai_system
		local _high_cost_nav_cost_map_id = self._high_cost_nav_cost_map_id
		local _high_cost_nav_cost_map_volume_id = self._high_cost_nav_cost_map_volume_id

		ai_system:remove_nav_cost_map_volume(_high_cost_nav_cost_map_volume_id, _high_cost_nav_cost_map_id)
		ai_system:destroy_nav_cost_map(_high_cost_nav_cost_map_id)

		local _medium_cost_nav_cost_map_id = self._medium_cost_nav_cost_map_id
		local _medium_cost_nav_cost_map_volume_id = self._medium_cost_nav_cost_map_volume_id

		ai_system:remove_nav_cost_map_volume(_medium_cost_nav_cost_map_volume_id, _medium_cost_nav_cost_map_id)
		ai_system:destroy_nav_cost_map(_medium_cost_nav_cost_map_id)
	end
end

local num_4 = 2

SummonedVortexExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local vortex_template = self.vortex_template
	local vortex_data = self.vortex_data

	if not (arg_7_5 > vortex_data.time_of_death or HEALTH_ALIVE[self._target_unit]) then
		Managers.state.unit_spawner:mark_for_deletion(self.unit)

		return
	end

	self:_update_height(arg_7_1, arg_7_5, arg_7_3, vortex_template, vortex_data)

	local inner_radius = vortex_data.inner_radius
	local outer_radius = vortex_data.outer_radius
	local fx_radius = vortex_data.fx_radius
	local var_7_5 = POSITION_LOOKUP[arg_7_1]

	if arg_7_5 > vortex_data.windup_time then
		self:attract(arg_7_1, arg_7_5, arg_7_3, vortex_template, vortex_data, var_7_5, inner_radius, outer_radius)
	end

	local num = vortex_data.height / vortex_template.max_height
	local current_height_lerp = self.current_height_lerp
	local lerp = math.lerp(current_height_lerp, num, math.min(arg_7_3 * num_4, 1))

	self.current_height_lerp = lerp

	local fx_radius_2 = vortex_data.fx_radius
	local num_2 = lerp * vortex_template.max_height

	Unit.set_local_scale(arg_7_1, 0, Vector3(fx_radius_2, fx_radius_2, num_2))
end

local function fn(arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local triangle_from_position, var_8_1, var_8_2, var_8_3, var_8_4 = GwNavQueries.triangle_from_position(arg_8_0, arg_8_1, 3, 3)

	if not triangle_from_position then
		local normalize = Vector3.normalize(var_8_3 - var_8_2)
		local normalize_2 = Vector3.normalize(var_8_4 - var_8_2)
		local normalize_3 = Vector3.normalize(Vector3.cross(normalize, normalize_2))
		local cross = Vector3.cross(normalize_3, arg_8_2)
		local look = Quaternion.look(cross, normalize_3)
		local var_8_10 = Vector3(arg_8_1.x, arg_8_1.y, var_8_1)

		return Matrix4x4.from_quaternion_position(look, var_8_10), var_8_10, look, cross
	end
end

SummonedVortexExtension._update_nav_cost_map_volumes = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	-- function 9
	local current_velocity = arg_9_6:current_velocity()
	local normalize = Vector3.normalize(current_velocity)
	local cross = Vector3.cross(normalize, Vector3.up())
	local var_9_3, var_9_4, var_9_5, var_9_6 = fn(arg_9_3, arg_9_1, cross)

	if not var_9_3 then
		return
	end

	local _high_cost_nav_cost_map_id = self._high_cost_nav_cost_map_id
	local _high_cost_nav_cost_map_volume_id = self._high_cost_nav_cost_map_volume_id

	arg_9_4:set_nav_cost_map_volume_transform(_high_cost_nav_cost_map_volume_id, _high_cost_nav_cost_map_id, var_9_3)

	local num = Vector3.length(current_velocity) / arg_9_5:get_max_speed()
	local lerp = math.lerp(1, 2, num)
	local var_9_11 = Vector3(arg_9_2, lerp * arg_9_2, 1)
	local _medium_cost_nav_cost_map_id = self._medium_cost_nav_cost_map_id
	local _medium_cost_nav_cost_map_volume_id = self._medium_cost_nav_cost_map_volume_id

	arg_9_4:set_nav_cost_map_volume_scale(_medium_cost_nav_cost_map_volume_id, _medium_cost_nav_cost_map_id, var_9_11)

	local num_2 = var_9_4 + var_9_6 * (0.5 * arg_9_2 * lerp)
	local from_quaternion_position = Matrix4x4.from_quaternion_position(var_9_5, num_2)

	arg_9_4:set_nav_cost_map_volume_transform(_medium_cost_nav_cost_map_volume_id, _medium_cost_nav_cost_map_id, from_quaternion_position)
end

local num_5 = 0.25

SummonedVortexExtension._update_height = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local num = 1
	local current_raycast_rad = arg_10_5.current_raycast_rad
	local inner_radius = arg_10_5.inner_radius
	local num_2 = POSITION_LOOKUP[arg_10_1] + Vector3(math.cos(current_raycast_rad) * inner_radius, math.sin(current_raycast_rad) * inner_radius, num)
	local physics_world = arg_10_5.physics_world
	local height = arg_10_5.height
	local num_3 = arg_10_4.max_height - num
	local immediate_raycast, var_10_8, var_10_9, var_10_10, var_10_11 = PhysicsWorld.immediate_raycast(physics_world, num_2, Vector3.up(), num_3, "closest", "collision_filter", "filter_ai_mover")
	local flag = not immediate_raycast and var_10_9 and num_3
	local max = math.max(flag, 4)
	local height_ring_buffer = arg_10_5.height_ring_buffer
	local buffer = height_ring_buffer.buffer
	local max_size = height_ring_buffer.max_size
	local num_4 = max + num

	for i = 1, max_size do
		local var_10_18 = buffer[i]

		if not (not var_10_18 and not (var_10_18 < num_4)) then
			num_4 = var_10_18
		end
	end

	local write_index = height_ring_buffer.write_index

	buffer[write_index] = max + num
	height_ring_buffer.write_index = write_index % max_size + 1

	if arg_10_5.wanted_height ~= num_4 then
		arg_10_5.wanted_height = num_4
		arg_10_5.start_lerp_height = height
	end

	local wanted_height = arg_10_5.wanted_height

	if wanted_height < height then
		arg_10_5.height = wanted_height
	elseif height < wanted_height then
		local start_lerp_height = arg_10_5.start_lerp_height
		local num_6 = math.abs(height - start_lerp_height) / math.abs(wanted_height - start_lerp_height)
		local clamp = math.clamp(num_6 + arg_10_3 * num_5, 0, 1)

		arg_10_5.height = math.lerp(start_lerp_height, wanted_height, clamp)
	end
end

SummonedVortexExtension._update_attract_outside_target = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
	-- function 11
	local _target_unit = self._target_unit
	local var_11_1 = BLACKBOARDS[_target_unit]
	local locomotion_extension = var_11_1.locomotion_extension

	locomotion_extension = locomotion_extension or ScriptUnit.has_extension(_target_unit, "locomotion_system")

	if not locomotion_extension then
		return
	end

	local num = arg_11_3 - POSITION_LOOKUP[_target_unit]

	Vector3.set_z(num, 0)

	local length = Vector3.length(num)

	if not self._target_is_player then
		local num_2 = arg_11_6 + 2
		local extension = ScriptUnit.extension(_target_unit, "status_system")

		if not (extension.near_vortex or not (length < num_2)) then
			StatusUtils.set_near_vortex_network(_target_unit, true, self.unit)
		elseif not (extension.near_vortex_unit ~= self.unit or not (num_2 <= length)) then
			StatusUtils.set_near_vortex_network(_target_unit, false)
		end
	end

	if arg_11_5 < length then
		local num_3 = length - arg_11_5
		local clamp = math.clamp(1 - num_3 / arg_11_7, 0, 1)

		if not self._target_is_player then
			local num_4 = arg_11_2.player_attract_speed * clamp * clamp
			local normalize = Vector3.normalize(num)

			locomotion_extension:add_external_velocity(normalize * num_4)
		else
			local num_5 = arg_11_2.ai_attract_speed * clamp * clamp
			local num_6 = Vector3.normalize(num) * num_5

			locomotion_extension:set_external_velocity(num_6)
		end
	else
		self._target_is_caught = true

		local flag = true

		if not self._target_is_player then
			flag = StatusUtils.set_in_vortex_network(_target_unit, true, self.unit)
		else
			var_11_1.in_vortex_state = "in_vortex_init"
			var_11_1.in_vortex = true
			var_11_1.thornsister_vortex = true
			var_11_1.thornsister_vortex_ext = self

			local name = var_11_1.breed.name

			if not tbl[name] then
				var_11_1.sot_landing = true
			end

			local time = Managers.time:time("game")
			local random_interval = ConflictUtils.random_interval(arg_11_2.time_of_life)
			local reduce_duration_per_breed = arg_11_2.reduce_duration_per_breed
			local var_11_18

			if not reduce_duration_per_breed then
				var_11_18 = reduce_duration_per_breed[name]

				if not var_11_18 then
					-- Nothing
				end
			end

			var_11_18 = 1

			::label_11_0::

			local clamp_2 = math.clamp(random_interval * var_11_18, 0, math.huge)

			self.vortex_data.time_of_death = time + clamp_2

			if not ScriptUnit.has_extension(_target_unit, "ai_system") then
				var_11_1.only_trust_your_own_eyes = false

				AiUtils.aggro_unit_of_enemy(_target_unit, self._owner_unit)
			end

			var_11_1.eject_height = ConflictUtils.random_interval(arg_11_2.ai_eject_height)
		end

		if not self._target_is_player and not flag then
			Managers.state.achievement:trigger_event("vortex_caught_unit", self._owner_unit, _target_unit)
		end
	end
end

SummonedVortexExtension._update_caught_target = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	local _target_unit = self._target_unit

	if not self._target_is_player then
		if not ScriptUnit.extension(_target_unit, "status_system"):is_in_vortex() then
			arg_12_1.time_of_death = 0
		end

		return
	end

	local ai_rotation_speed = arg_12_2.ai_rotation_speed
	local ai_radius_change_speed = arg_12_2.ai_radius_change_speed
	local ai_ascension_speed = arg_12_2.ai_ascension_speed
	local ai_max_ascension_height = arg_12_2.ai_max_ascension_height
	local var_12_5 = arg_12_5
	local height = arg_12_1.height
	local up = Vector3.up()
	local var_12_8 = BLACKBOARDS[_target_unit]

	if var_12_8.in_vortex_state == "in_vortex" then
		local var_12_9 = POSITION_LOOKUP[_target_unit]
		local get_vortex_spin_velocity, var_12_11, var_12_12 = LocomotionUtils.get_vortex_spin_velocity(var_12_9, arg_12_4, var_12_5, up, ai_rotation_speed, ai_radius_change_speed, ai_ascension_speed, arg_12_3)
		local locomotion_extension = var_12_8.locomotion_extension

		locomotion_extension:set_wanted_velocity(get_vortex_spin_velocity)

		if not (var_12_12 > var_12_8.eject_height or height < var_12_12 or arg_12_6 < var_12_11 or not (ai_max_ascension_height < var_12_12)) then
			local num = get_vortex_spin_velocity * 0

			locomotion_extension:set_wanted_velocity(num)
		end
	elseif var_12_8.in_vortex_state == "landed" then
		self._target_unit = nil
	end
end

SummonedVortexExtension.attract = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8)
	-- function 13
	local num = -0.5
	local num_2 = arg_13_8 - arg_13_7
	local num_3 = arg_13_7 + arg_13_4.max_allowed_inner_radius_dist

	if not self._target_is_caught then
		self:_update_attract_outside_target(arg_13_5, arg_13_4, arg_13_6, num, arg_13_7, arg_13_8, num_2)
	else
		self:_update_caught_target(arg_13_5, arg_13_4, arg_13_3, arg_13_6, arg_13_7, num_3)
	end
end

SummonedVortexExtension.is_position_inside = function (self, arg_14_1, arg_14_2)
	-- function 14
	local num = (self.vortex_data.outer_radius + (arg_14_2 or 0))^2
	local unit = self.unit
	local var_14_2 = POSITION_LOOKUP[unit]

	return num > Vector3.distance_squared(arg_14_1, var_14_2)
end

local tbl_2 = {}
local num_6 = 8
local num_7 = 10

SummonedVortexExtension.debug_render_vortex = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8)
	-- function 15
	arg_15_4 = arg_15_4 + math.sin(arg_15_1 * 1.7) * 0.4

	local num = 2 * math.pi / 6
	local floor = math.floor(155 / num_6)
	local num_2 = arg_15_8 / num_6

	for i = 1, num_7 do
		local num_3 = i * 2 * math.pi / num_7

		for j = 1, num_6 do
			local num_4 = arg_15_4 + 0.5 * (j * j) / num_6
			local num_5 = arg_15_1 * arg_15_7 + j * num + num_3

			tbl_2[j] = Vector3(math.sin(num_5) * num_4, math.cos(num_5) * num_4, (j - 1) * num_2)
		end

		local num_8 = arg_15_4 + math.sin(arg_15_1) * 0.2
		local num_9 = arg_15_1 * arg_15_7 + num_3 + 0 * num
		local var_15_8 = Vector3(math.sin(num_9) * num_8, math.cos(num_9) * num_8, 0)

		QuickDrawer:sphere(arg_15_3 + var_15_8, (math.sin(num_9 * 3) + 1) / 3, Color(155, 255, 155))

		for k = 1, num_6 do
			local var_15_9 = tbl_2[k]
			local var_15_10 = Color(155 - floor * k, 255 - floor * k, 155 - floor * k)

			QuickDrawer:line(arg_15_3 + var_15_8, arg_15_3 + var_15_9, var_15_10)

			var_15_8 = var_15_9
		end
	end

	QuickDrawer:circle(arg_15_3, arg_15_5, Vector3.up(), Colors.get("pink"))
	QuickDrawer:circle(arg_15_3, arg_15_6, Vector3.up(), Colors.get("lime_green"))
end
