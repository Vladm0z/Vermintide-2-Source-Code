-- chunkname: @scripts/unit_extensions/ai_supplementary/vortex_extension.lua

VortexExtension = class(VortexExtension)

local alive = Unit.alive
local POSITION_LOOKUP = POSITION_LOOKUP
local BLACKBOARDS = BLACKBOARDS
local num = 36
local num_2 = 2 * math.pi / num
local num_3 = 0.5

VortexExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self.world = world
	self.unit = arg_1_2

	local system = Managers.state.entity:system("ai_system")

	self.ai_system = system

	local vortex_template_name = arg_1_3.vortex_template_name
	local var_1_3 = VortexTemplates[vortex_template_name]

	self.vortex_template_name = vortex_template_name
	self.vortex_template = var_1_3

	local inner_fx_name = var_1_3.inner_fx_name
	local var_1_5 = POSITION_LOOKUP[arg_1_2]
	local create_particles = World.create_particles(world, inner_fx_name, var_1_5)
	local local_rotation = Unit.local_rotation(arg_1_2, 0)
	local from_quaternion = Matrix4x4.from_quaternion(local_rotation)
	local num = var_1_3.full_inner_radius / var_1_3.full_fx_radius
	local inner_fx_z_scale_multiplier = var_1_3.inner_fx_z_scale_multiplier

	inner_fx_z_scale_multiplier = inner_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(from_quaternion, Vector3(num, num, inner_fx_z_scale_multiplier))
	World.link_particles(world, create_particles, arg_1_2, 0, from_quaternion, "stop")

	self._inner_fx_id = create_particles

	local outer_fx_name = var_1_3.outer_fx_name
	local create_particles_2 = World.create_particles(world, outer_fx_name, var_1_5)
	local from_quaternion_2 = Matrix4x4.from_quaternion(local_rotation)
	local num_2 = var_1_3.full_outer_radius / var_1_3.full_fx_radius
	local outer_fx_z_scale_multiplier = var_1_3.outer_fx_z_scale_multiplier

	outer_fx_z_scale_multiplier = outer_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(from_quaternion_2, Vector3(num_2, num_2, outer_fx_z_scale_multiplier))
	World.link_particles(world, create_particles_2, arg_1_2, 0, from_quaternion_2, "stop")

	self._outer_fx_id = create_particles_2
	self.current_height_lerp = 0

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

	if not var_1_3.use_nav_cost_map_volumes then
		local full_outer_radius = var_1_3.full_outer_radius
		local high_cost_nav_cost_map_cost_type = var_1_3.high_cost_nav_cost_map_cost_type
		local medium_cost_nav_cost_map_cost_type = var_1_3.medium_cost_nav_cost_map_cost_type

		self:_create_nav_cost_maps(system, var_1_5, full_outer_radius, high_cost_nav_cost_map_cost_type, medium_cost_nav_cost_map_cost_type)

		self._use_nav_cost_map_volumes = true
	end

	local owner_unit = arg_1_3.owner_unit

	owner_unit = owner_unit or arg_1_2
	self._owner_unit = owner_unit
end

VortexExtension._create_nav_cost_maps = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local num = 1
	local from_translation = Matrix4x4.from_translation(arg_2_2)
	local var_2_2 = Vector3(arg_2_3, arg_2_3, 1)
	local create_nav_cost_map = arg_2_1:create_nav_cost_map(arg_2_4, num)

	self._high_cost_nav_cost_map_volume_id = arg_2_1:add_nav_cost_map_box_volume(from_translation, var_2_2, create_nav_cost_map)
	self._high_cost_nav_cost_map_id = create_nav_cost_map

	local create_nav_cost_map_2 = arg_2_1:create_nav_cost_map(arg_2_5, num)

	self._medium_cost_nav_cost_map_volume_id = arg_2_1:add_nav_cost_map_box_volume(from_translation, var_2_2, create_nav_cost_map_2)
	self._medium_cost_nav_cost_map_id = create_nav_cost_map_2
	self._next_nav_cost_map_update_t = Managers.time:time("game") + num_3
end

VortexExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = BLACKBOARDS[arg_3_2]

	self.blackboard = var_3_0

	local vortex_template = self.vortex_template
	local time = Managers.time:time("game")
	local var_3_3 = num
	local tbl = {
		idle_time = 0,
		height = 5,
		inner_radius = 2,
		start_lerp_height = 5,
		start_lerp_fx_radius = 8,
		wander_time = 0,
		start_lerp_inner_radius = 2,
		current_raycast_rad = 0,
		num_players_inside = 0,
		outer_radius = 8,
		ai_units_inside = {},
		players_inside = {},
		players_ejected = {},
		physics_world = World.get_data(arg_3_1, "physics_world")
	}
	local flag

	flag = not vortex_template.forced_standing_still and "forced_standing_still" and "recalc_path"
	tbl.wander_state = flag
	tbl.wanted_height = vortex_template.max_height
	tbl.height_ring_buffer = {
		write_index = 1,
		buffer = Script.new_array(var_3_3),
		max_size = var_3_3
	}
	tbl.fx_radius = vortex_template.start_radius
	tbl.wanted_inner_radius = vortex_template.full_inner_radius
	tbl.wanted_fx_radius = vortex_template.full_fx_radius
	tbl.inner_radius_ring_buffer = {
		write_index = 1,
		buffer = Script.new_array(var_3_3),
		max_size = var_3_3
	}
	tbl.windup_time = time + vortex_template.windup_time
	tbl.time_of_death = time + ConflictUtils.random_interval(vortex_template.time_of_life)
	tbl.vortex_template = vortex_template
	var_3_0.vortex_data = tbl

	var_3_0.locomotion_extension:set_rotation_speed(0)

	local navigation_extension = var_3_0.navigation_extension

	navigation_extension:init_position()

	if not vortex_template.override_movement_speed then
		navigation_extension:set_max_speed(vortex_template.override_movement_speed)
	end

	local start_sound_event_name = vortex_template.start_sound_event_name

	start_sound_event_name = start_sound_event_name or "Play_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(arg_3_1, start_sound_event_name, arg_3_2)
end

VortexExtension.destroy = function (self)
	-- function 4
	local blackboard = self.blackboard
	local vortex_data = blackboard.vortex_data
	local players_inside = vortex_data.players_inside
	local players_ejected = vortex_data.players_ejected
	local ai_units_inside = vortex_data.ai_units_inside
	local var_4_5 = BLACKBOARDS
	local unit = self.unit
	local sides = Managers.state.side:sides()

	for i = 1, #sides do
		local PLAYER_AND_BOT_UNITS = sides[i].PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS

		for j = 1, count do
			local var_4_10 = PLAYER_AND_BOT_UNITS[j]

			if not alive(var_4_10) then
				if not players_inside[var_4_10] then
					StatusUtils.set_in_vortex_network(var_4_10, false, nil)

					players_inside[var_4_10] = nil
				elseif not players_ejected[var_4_10] then
					players_ejected[var_4_10] = nil
				end

				local extension = ScriptUnit.extension(var_4_10, "status_system")

				extension.smacked_into_wall = false

				if extension.near_vortex_unit == unit then
					StatusUtils.set_near_vortex_network(var_4_10, false)
				end
			end
		end
	end

	for k, v in pairs(ai_units_inside) do
		if not ALIVE[k] then
			local var_4_12 = Vector3(0, 0, -6)
			local var_4_13 = var_4_5[k]

			if not var_4_13 then
				local locomotion_extension = var_4_13.locomotion_extension

				locomotion_extension:set_wanted_velocity(var_4_12)
				locomotion_extension:set_affected_by_gravity(true)
				locomotion_extension:set_movement_type("constrained_by_mover")

				local ejected_from_vortex = var_4_13.ejected_from_vortex

				ejected_from_vortex = ejected_from_vortex or Vector3Box()

				ejected_from_vortex:store(var_4_12)

				var_4_13.ejected_from_vortex = ejected_from_vortex
				var_4_13.in_vortex_state = "ejected_from_vortex"
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

	table.clear(vortex_data)

	blackboard.vortex_data = nil

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

VortexExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local blackboard = self.blackboard
	local vortex_template = self.vortex_template
	local vortex_data = blackboard.vortex_data
	local nav_world = blackboard.nav_world
	local navigation_extension = blackboard.navigation_extension
	local traverse_logic = navigation_extension:traverse_logic()
	local var_5_6 = POSITION_LOOKUP[arg_5_1]
	local control_size, var_5_8, var_5_9 = self:control_size(arg_5_1, arg_5_5, arg_5_3, nav_world, traverse_logic, vortex_template, vortex_data)

	if arg_5_5 > vortex_data.windup_time then
		self:attract(arg_5_1, arg_5_5, arg_5_3, blackboard, vortex_template, vortex_data, var_5_6, control_size, var_5_8)
	end

	if arg_5_5 > vortex_data.time_of_death then
		Managers.state.conflict:destroy_unit(arg_5_1, blackboard, "vortex")

		return
	end

	if not (not self._use_nav_cost_map_volumes and not (arg_5_5 > self._next_nav_cost_map_update_t)) then
		local ai_system = self.ai_system
		local locomotion_extension = blackboard.locomotion_extension
		local full_outer_radius = vortex_template.full_outer_radius

		self:_update_nav_cost_map_volumes(var_5_6, full_outer_radius, nav_world, ai_system, navigation_extension, locomotion_extension)

		self._next_nav_cost_map_update_t = arg_5_5 + num_3
	end

	local num = var_5_9 / vortex_template.full_fx_radius
	local num_2 = vortex_data.height / vortex_template.max_height
	local current_height_lerp = self.current_height_lerp
	local lerp = math.lerp(current_height_lerp, num_2, math.min(arg_5_3 * num_4, 1))

	self.current_height_lerp = lerp

	local num_5 = num * vortex_template.full_fx_radius
	local num_6 = lerp * vortex_template.max_height

	Unit.set_local_scale(arg_5_1, 0, Vector3(num_5, num_5, num_6))
end

local function fn(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local triangle_from_position, var_6_1, var_6_2, var_6_3, var_6_4 = GwNavQueries.triangle_from_position(arg_6_0, arg_6_1, 3, 3)

	if not triangle_from_position then
		local normalize = Vector3.normalize(var_6_3 - var_6_2)
		local normalize_2 = Vector3.normalize(var_6_4 - var_6_2)
		local normalize_3 = Vector3.normalize(Vector3.cross(normalize, normalize_2))
		local cross = Vector3.cross(normalize_3, arg_6_2)
		local look = Quaternion.look(cross, normalize_3)
		local var_6_10 = Vector3(arg_6_1.x, arg_6_1.y, var_6_1)

		return Matrix4x4.from_quaternion_position(look, var_6_10), var_6_10, look, cross
	end
end

VortexExtension._update_nav_cost_map_volumes = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local current_velocity = arg_7_6:current_velocity()
	local normalize = Vector3.normalize(current_velocity)
	local cross = Vector3.cross(normalize, Vector3.up())
	local var_7_3, var_7_4, var_7_5, var_7_6 = fn(arg_7_3, arg_7_1, cross)

	if not var_7_3 then
		return
	end

	local _high_cost_nav_cost_map_id = self._high_cost_nav_cost_map_id
	local _high_cost_nav_cost_map_volume_id = self._high_cost_nav_cost_map_volume_id

	arg_7_4:set_nav_cost_map_volume_transform(_high_cost_nav_cost_map_volume_id, _high_cost_nav_cost_map_id, var_7_3)

	local num = Vector3.length(current_velocity) / arg_7_5:get_max_speed()
	local lerp = math.lerp(1, 2, num)
	local var_7_11 = Vector3(arg_7_2, lerp * arg_7_2, 1)
	local _medium_cost_nav_cost_map_id = self._medium_cost_nav_cost_map_id
	local _medium_cost_nav_cost_map_volume_id = self._medium_cost_nav_cost_map_volume_id

	arg_7_4:set_nav_cost_map_volume_scale(_medium_cost_nav_cost_map_volume_id, _medium_cost_nav_cost_map_id, var_7_11)

	local num_2 = var_7_4 + var_7_6 * (0.5 * arg_7_2 * lerp)
	local from_quaternion_position = Matrix4x4.from_quaternion_position(var_7_5, num_2)

	arg_7_4:set_nav_cost_map_volume_transform(_medium_cost_nav_cost_map_volume_id, _medium_cost_nav_cost_map_id, from_quaternion_position)
end

local num_5 = 0.25

VortexExtension._update_height = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local num = 1
	local current_raycast_rad = arg_8_5.current_raycast_rad
	local inner_radius = arg_8_5.inner_radius
	local num_2 = POSITION_LOOKUP[arg_8_1] + Vector3(math.cos(current_raycast_rad) * inner_radius, math.sin(current_raycast_rad) * inner_radius, num)
	local physics_world = arg_8_5.physics_world
	local height = arg_8_5.height
	local num_3 = arg_8_4.max_height - num
	local immediate_raycast, var_8_8, var_8_9, var_8_10, var_8_11 = PhysicsWorld.immediate_raycast(physics_world, num_2, Vector3.up(), num_3, "closest", "collision_filter", "filter_ai_mover")
	local flag = not immediate_raycast and var_8_9 and num_3
	local max = math.max(flag, 4)
	local height_ring_buffer = arg_8_5.height_ring_buffer
	local buffer = height_ring_buffer.buffer
	local max_size = height_ring_buffer.max_size
	local num_4 = max + num

	for i = 1, max_size do
		local var_8_18 = buffer[i]

		if not (not var_8_18 and not (var_8_18 < num_4)) then
			num_4 = var_8_18
		end
	end

	local write_index = height_ring_buffer.write_index

	buffer[write_index] = max + num
	height_ring_buffer.write_index = write_index % max_size + 1

	if arg_8_5.wanted_height ~= num_4 then
		arg_8_5.wanted_height = num_4
		arg_8_5.start_lerp_height = height
	end

	local wanted_height = arg_8_5.wanted_height

	if wanted_height < height then
		arg_8_5.height = wanted_height
	elseif height < wanted_height then
		local start_lerp_height = arg_8_5.start_lerp_height
		local num_6 = math.abs(height - start_lerp_height) / math.abs(wanted_height - start_lerp_height)
		local clamp = math.clamp(num_6 + arg_8_3 * num_5, 0, 1)

		arg_8_5.height = math.lerp(start_lerp_height, wanted_height, clamp)
	end
end

local num_6 = 0.75
local num_7 = 1.5

VortexExtension._update_radius = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	local var_9_0 = POSITION_LOOKUP[arg_9_1]
	local inner_radius = arg_9_7.inner_radius
	local fx_radius = arg_9_7.fx_radius
	local current_raycast_rad = arg_9_7.current_raycast_rad
	local full_inner_radius = arg_9_6.full_inner_radius
	local num = var_9_0 + Vector3(math.cos(current_raycast_rad) * full_inner_radius, math.sin(current_raycast_rad) * full_inner_radius, 0)
	local raycast_on_navmesh, var_9_7, var_9_8, var_9_9 = LocomotionUtils.raycast_on_navmesh(arg_9_4, var_9_0, num, arg_9_5, 1, 1)

	if not var_9_7 then
		return
	end

	local distance = Vector3.distance(var_9_7, var_9_9)
	local inner_radius_ring_buffer = arg_9_7.inner_radius_ring_buffer
	local buffer = inner_radius_ring_buffer.buffer
	local max_size = inner_radius_ring_buffer.max_size
	local min = math.min(distance, arg_9_6.full_inner_radius)

	for i = 1, max_size do
		local var_9_15 = buffer[i]

		if not (not var_9_15 and not (var_9_15 < min)) then
			min = var_9_15
		end
	end

	local max = math.max(min, arg_9_6.min_inner_radius)
	local write_index = inner_radius_ring_buffer.write_index

	buffer[write_index] = distance
	inner_radius_ring_buffer.write_index = write_index % max_size + 1

	if arg_9_7.wanted_inner_radius ~= max then
		local num_2 = max / arg_9_6.full_inner_radius

		arg_9_7.wanted_fx_radius = math.max(arg_9_6.full_fx_radius * num_2, arg_9_6.min_fx_radius)
		arg_9_7.wanted_inner_radius = max
		arg_9_7.start_lerp_inner_radius = inner_radius
		arg_9_7.start_lerp_fx_radius = fx_radius
	end

	local wanted_inner_radius = arg_9_7.wanted_inner_radius

	if wanted_inner_radius < inner_radius then
		arg_9_7.inner_radius = wanted_inner_radius
	elseif inner_radius < wanted_inner_radius then
		local start_lerp_inner_radius = arg_9_7.start_lerp_inner_radius
		local num_3 = math.abs(inner_radius - start_lerp_inner_radius) / math.abs(wanted_inner_radius - start_lerp_inner_radius)
		local clamp = math.clamp(num_3 + arg_9_3 * num_6, 0, 1)

		arg_9_7.inner_radius = math.lerp(start_lerp_inner_radius, wanted_inner_radius, clamp)
	end

	local wanted_fx_radius = arg_9_7.wanted_fx_radius

	if wanted_fx_radius ~= fx_radius then
		local start_lerp_fx_radius = arg_9_7.start_lerp_fx_radius
		local num_4 = math.abs(fx_radius - start_lerp_fx_radius) / math.abs(wanted_fx_radius - start_lerp_fx_radius)
		local var_9_26

		if fx_radius < wanted_fx_radius then
			var_9_26 = num_6

			if not var_9_26 then
				-- Nothing
			end
		end

		var_9_26 = num_7

		::label_9_0::

		local clamp_2 = math.clamp(num_4 + arg_9_3 * var_9_26, 0, 1)

		arg_9_7.fx_radius = math.lerp(start_lerp_fx_radius, wanted_fx_radius, clamp_2)
	end

	local num_5 = arg_9_7.inner_radius / arg_9_6.full_inner_radius

	arg_9_7.outer_radius = math.max(arg_9_6.min_outer_radius, arg_9_6.full_outer_radius * num_5)
end

VortexExtension.control_size = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	-- function 10
	arg_10_7.current_raycast_rad = math.fmod(arg_10_7.current_raycast_rad + num_2, 2 * math.pi)

	self:_update_radius(arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	self:_update_height(arg_10_1, arg_10_2, arg_10_3, arg_10_6, arg_10_7)

	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_10_1)

	if not game and not go_id then
		local num = arg_10_7.inner_radius / arg_10_6.full_inner_radius
		local num_3 = arg_10_7.fx_radius / arg_10_6.full_fx_radius
		local num_4 = arg_10_7.height / arg_10_6.max_height

		GameSession.set_game_object_field(game, go_id, "inner_radius_percentage", num)
		GameSession.set_game_object_field(game, go_id, "fx_radius_percentage", num_3)
		GameSession.set_game_object_field(game, go_id, "height_percentage", num_4)
	end

	return arg_10_7.inner_radius, arg_10_7.outer_radius, arg_10_7.fx_radius
end

local num_8 = 4
local new_array = Script.new_array(num_8)

VortexExtension._update_attract_players = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11)
	-- function 11
	local nav_world = arg_11_2.nav_world
	local physics_world = arg_11_3.physics_world
	local height = arg_11_3.height
	local players_inside = arg_11_3.players_inside
	local players_ejected = arg_11_3.players_ejected
	local player_eject_speed = arg_11_4.player_eject_speed
	local player_attract_speed = arg_11_4.player_attract_speed
	local player_eject_distance = arg_11_4.player_eject_distance
	local gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration
	local str = "filter_player_mover"
	local num = 15
	local num_2 = 15
	local num_3 = Vector3.up() * 0.05
	local num_4 = arg_11_9 + 2
	local sides = Managers.state.side:sides()

	for i = 1, #sides do
		local PLAYER_AND_BOT_UNITS = sides[i].PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS

		for j = 1, count do
			local var_11_17 = PLAYER_AND_BOT_UNITS[j]
			local breed = BLACKBOARDS[var_11_17].breed
			local extension = ScriptUnit.extension(var_11_17, "status_system")
			local vortexable = breed.vortexable

			vortexable = not vortexable and extension:is_valid_vortex_target()

			local extension_2 = ScriptUnit.extension(var_11_17, "locomotion_system")
			local var_11_22 = POSITION_LOOKUP[var_11_17]
			local num_5 = arg_11_6 - var_11_22
			local num_6 = -num_5.z

			Vector3.set_z(num_5, 0)

			local length = Vector3.length(num_5)

			if not (extension.near_vortex or not (length < num_4)) then
				StatusUtils.set_near_vortex_network(var_11_17, true, arg_11_1)
			elseif not (extension.near_vortex_unit ~= arg_11_1 or not (num_4 <= length)) then
				StatusUtils.set_near_vortex_network(var_11_17, false)
			end

			if not players_inside[var_11_17] then
				local vortex_eject_height = players_inside[var_11_17].vortex_eject_height
				local vortex_eject_time = players_inside[var_11_17].vortex_eject_time
				local mover = Unit.mover(var_11_17)

				if not Mover.collides_sides(mover) then
					if not extension.smacked_into_wall then
						extension.smacked_into_wall = arg_11_5 + 0.7

						local current_velocity = extension_2:current_velocity()
						local normalize = Vector3.normalize(current_velocity)
						local name = arg_11_2.breed.name
						local calculate_damage = DamageUtils.calculate_damage(arg_11_4.damage, var_11_17, arg_11_1)

						DamageUtils.add_damage_network(var_11_17, arg_11_1, calculate_damage, "torso", "cutting", nil, -normalize, name, nil, nil, nil, arg_11_4.hit_react_type, nil, nil, nil, nil, nil, nil, 1)
					end
				elseif not (not extension.smacked_into_wall and not (arg_11_5 > extension.smacked_into_wall)) then
					extension.smacked_into_wall = false
				end

				if not (not vortexable and not (arg_11_11 < length)) then
					StatusUtils.set_in_vortex_network(var_11_17, false, nil)

					players_inside[var_11_17] = nil
					arg_11_3.num_players_inside = arg_11_3.num_players_inside - 1
				elseif not (vortex_eject_height < num_6 or height < num_6 or not (vortex_eject_time < arg_11_5)) then
					local current_velocity_2 = extension_2:current_velocity()
					local normalize_2 = Vector3.normalize(current_velocity_2)
					local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_11_22 + normalize_2 * player_eject_distance, num, num_2)

					if not pos_on_mesh then
						local test_angled_trajectory, var_11_37 = WeaponHelper.test_angled_trajectory(physics_world, var_11_22, pos_on_mesh + num_3, -gravity_acceleration, player_eject_speed, nil, new_array, num_8, str)

						if not test_angled_trajectory then
							StatusUtils.set_in_vortex_network(var_11_17, false, nil)
							StatusUtils.set_catapulted_network(var_11_17, true, var_11_37)

							players_inside[var_11_17] = nil
							players_ejected[var_11_17] = -1
							arg_11_3.num_players_inside = arg_11_3.num_players_inside - 1
						end
					end
				end
			elseif not players_ejected[var_11_17] then
				local var_11_38 = players_ejected[var_11_17]

				if var_11_38 < 0 then
					if not extension:is_catapulted() then
						if length < arg_11_9 then
							local num_7 = (arg_11_9 - length) / arg_11_9

							players_ejected[var_11_17] = arg_11_5 + 0.5 + arg_11_4.player_ejected_bliss_time * 0.5 + arg_11_4.player_ejected_bliss_time * num_7 * 0.5
						else
							players_ejected[var_11_17] = arg_11_5 + 0.5 + arg_11_4.player_ejected_bliss_time
						end
					end
				elseif var_11_38 < arg_11_5 then
					players_ejected[var_11_17] = nil
				end
			elseif not (not vortexable and extension:is_in_vortex() or not (length < arg_11_9) or not (arg_11_7 <= num_6) or not (num_6 < height)) then
				if arg_11_8 < length then
					local num_9 = length - arg_11_8
					local clamp = math.clamp(1 - num_9 / arg_11_10, 0, 1)
					local num_10 = player_attract_speed * clamp * clamp
					local normalize_3 = Vector3.normalize(num_5)

					extension_2:add_external_velocity(normalize_3 * num_10)
				elseif not StatusUtils.set_in_vortex_network(var_11_17, true, arg_11_1) then
					local random_interval = ConflictUtils.random_interval(arg_11_4.player_eject_height)

					players_inside[var_11_17] = {
						vortex_eject_height = random_interval,
						vortex_eject_time = arg_11_5 + arg_11_4.player_in_vortex_max_duration
					}
					arg_11_3.num_players_inside = arg_11_3.num_players_inside + 1
				end
			end
		end
	end
end

local tbl = {}

VortexExtension._update_attract_outside_ai = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8)
	-- function 12
	local height = arg_12_1.height
	local ai_attract_speed = arg_12_3.ai_attract_speed
	local ai_units_inside = arg_12_1.ai_units_inside
	local broadphase_query = AiUtils.broadphase_query(arg_12_4, arg_12_7, tbl)

	for i = 1, broadphase_query do
		local var_12_4 = tbl[i]

		if not ai_units_inside[var_12_4] then
			local var_12_5 = BLACKBOARDS[var_12_4]

			if not var_12_5.breed.vortexable then
				local locomotion_extension = var_12_5.locomotion_extension
				local var_12_7 = HEALTH_ALIVE[var_12_4]

				if not locomotion_extension and not var_12_7 then
					local num = arg_12_4 - POSITION_LOOKUP[var_12_4]
					local num_2 = -num.z

					Vector3.set_z(num, 0)

					if not (not (arg_12_5 <= num_2) or not (num_2 < height)) then
						local length = Vector3.length(num)

						if arg_12_6 < length then
							local num_3 = length - arg_12_6
							local clamp = math.clamp(1 - num_3 / arg_12_8, 0, 1)
							local num_4 = ai_attract_speed * clamp * clamp
							local num_5 = Vector3.normalize(num) * num_4

							locomotion_extension:set_external_velocity(num_5)
						else
							var_12_5.in_vortex_state = "in_vortex_init"
							var_12_5.in_vortex = true
							var_12_5.eject_height = ConflictUtils.random_interval(arg_12_3.ai_eject_height)
							ai_units_inside[var_12_4] = true

							if not arg_12_3.suck_in_ai_func then
								arg_12_3:suck_in_ai_func(arg_12_2)
							end
						end
					end
				end
			end
		end
	end
end

VortexExtension._update_attract_inside_ai = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
	-- function 13
	local ai_rotation_speed = arg_13_3.ai_rotation_speed
	local ai_radius_change_speed = arg_13_3.ai_radius_change_speed
	local ai_ascension_speed = arg_13_3.ai_ascension_speed
	local var_13_3 = arg_13_6
	local height = arg_13_2.height
	local up = Vector3.up()
	local ai_units_inside = arg_13_2.ai_units_inside

	for k, v in pairs(ai_units_inside) do
		if not HEALTH_ALIVE[k] then
			local var_13_7 = BLACKBOARDS[k]

			if var_13_7.in_vortex_state == "in_vortex" then
				local var_13_8 = POSITION_LOOKUP[k]
				local get_vortex_spin_velocity, var_13_10, var_13_11 = LocomotionUtils.get_vortex_spin_velocity(var_13_8, arg_13_5, var_13_3, up, ai_rotation_speed, ai_radius_change_speed, ai_ascension_speed, arg_13_4)
				local locomotion_extension = var_13_7.locomotion_extension

				locomotion_extension:set_wanted_velocity(get_vortex_spin_velocity)

				if not (var_13_11 > var_13_7.eject_height or height < var_13_11 or not (arg_13_7 < var_13_10)) then
					local ejected_from_vortex = var_13_7.ejected_from_vortex

					ejected_from_vortex = ejected_from_vortex or Vector3Box()

					ejected_from_vortex:store(get_vortex_spin_velocity)

					var_13_7.ejected_from_vortex = ejected_from_vortex
					var_13_7.in_vortex_state = "ejected_from_vortex"

					AiUtils.aggro_unit_of_enemy(k, arg_13_1.target_unit)
					locomotion_extension:set_affected_by_gravity(true)
					locomotion_extension:set_movement_type("constrained_by_mover")
				end
			elseif var_13_7.in_vortex_state == "landed" then
				ai_units_inside[k] = nil
			end
		else
			ai_units_inside[k] = nil
		end
	end
end

VortexExtension.attract = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9)
	-- function 14
	local num = -0.5
	local num_2 = arg_14_9 - arg_14_8
	local num_3 = arg_14_8 + arg_14_5.max_allowed_inner_radius_dist

	if not arg_14_5.player_attractable then
		self:_update_attract_players(arg_14_1, arg_14_4, arg_14_6, arg_14_5, arg_14_2, arg_14_7, num, arg_14_8, arg_14_9, num_2, num_3)
	end

	if not arg_14_5.ai_attractable then
		self:_update_attract_outside_ai(arg_14_6, arg_14_4, arg_14_5, arg_14_7, num, arg_14_8, arg_14_9, num_2)
		self:_update_attract_inside_ai(arg_14_4, arg_14_6, arg_14_5, arg_14_3, arg_14_7, arg_14_8, num_3)
	end
end

VortexExtension.is_position_inside = function (self, arg_15_1, arg_15_2)
	-- function 15
	local num = (self.blackboard.vortex_data.outer_radius + (arg_15_2 or 0))^2
	local unit = self.unit
	local var_15_2 = POSITION_LOOKUP[unit]

	return num > Vector3.distance_squared(arg_15_1, var_15_2)
end

local tbl_2 = {}
local num_9 = 8
local num_10 = 10

VortexExtension.debug_render_vortex = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8)
	-- function 16
	arg_16_4 = arg_16_4 + math.sin(arg_16_1 * 1.7) * 0.4

	local num = 2 * math.pi / 6
	local floor = math.floor(155 / num_9)
	local num_2 = arg_16_8 / num_9

	for i = 1, num_10 do
		local num_3 = i * 2 * math.pi / num_10

		for j = 1, num_9 do
			local num_4 = arg_16_4 + 0.5 * (j * j) / num_9
			local num_5 = arg_16_1 * arg_16_7 + j * num + num_3

			tbl_2[j] = Vector3(math.sin(num_5) * num_4, math.cos(num_5) * num_4, (j - 1) * num_2)
		end

		local num_6 = arg_16_4 + math.sin(arg_16_1) * 0.2
		local num_7 = arg_16_1 * arg_16_7 + num_3 + 0 * num
		local var_16_8 = Vector3(math.sin(num_7) * num_6, math.cos(num_7) * num_6, 0)

		QuickDrawer:sphere(arg_16_3 + var_16_8, (math.sin(num_7 * 3) + 1) / 3, Color(155, 255, 155))

		for k = 1, num_9 do
			local var_16_9 = tbl_2[k]
			local var_16_10 = Color(155 - floor * k, 255 - floor * k, 155 - floor * k)

			QuickDrawer:line(arg_16_3 + var_16_8, arg_16_3 + var_16_9, var_16_10)

			var_16_8 = var_16_9
		end
	end

	QuickDrawer:circle(arg_16_3, arg_16_5, Vector3.up(), Colors.get("pink"))
	QuickDrawer:circle(arg_16_3, arg_16_6, Vector3.up(), Colors.get("lime_green"))
end
