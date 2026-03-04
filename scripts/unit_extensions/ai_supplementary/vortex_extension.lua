-- chunkname: @scripts/unit_extensions/ai_supplementary/vortex_extension.lua

VortexExtension = class(VortexExtension)

local var_0_0 = Unit.alive
local var_0_1 = POSITION_LOOKUP
local var_0_2 = BLACKBOARDS
local var_0_3 = 36
local var_0_4 = 2 * math.pi / var_0_3
local var_0_5 = 0.5

VortexExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0.world = var_1_0
	arg_1_0.unit = arg_1_2

	local var_1_1 = Managers.state.entity:system("ai_system")

	arg_1_0.ai_system = var_1_1

	local var_1_2 = arg_1_3.vortex_template_name
	local var_1_3 = VortexTemplates[var_1_2]

	arg_1_0.vortex_template_name = var_1_2
	arg_1_0.vortex_template = var_1_3

	local var_1_4 = var_1_3.inner_fx_name
	local var_1_5 = var_0_1[arg_1_2]
	local var_1_6 = World.create_particles(var_1_0, var_1_4, var_1_5)
	local var_1_7 = Unit.local_rotation(arg_1_2, 0)
	local var_1_8 = Matrix4x4.from_quaternion(var_1_7)
	local var_1_9 = var_1_3.full_inner_radius / var_1_3.full_fx_radius
	local var_1_10 = var_1_3.inner_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(var_1_8, Vector3(var_1_9, var_1_9, var_1_10))
	World.link_particles(var_1_0, var_1_6, arg_1_2, 0, var_1_8, "stop")

	arg_1_0._inner_fx_id = var_1_6

	local var_1_11 = var_1_3.outer_fx_name
	local var_1_12 = World.create_particles(var_1_0, var_1_11, var_1_5)
	local var_1_13 = Matrix4x4.from_quaternion(var_1_7)
	local var_1_14 = var_1_3.full_outer_radius / var_1_3.full_fx_radius
	local var_1_15 = var_1_3.outer_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(var_1_13, Vector3(var_1_14, var_1_14, var_1_15))
	World.link_particles(var_1_0, var_1_12, arg_1_2, 0, var_1_13, "stop")

	arg_1_0._outer_fx_id = var_1_12
	arg_1_0.current_height_lerp = 0

	local var_1_16 = arg_1_3.inner_decal_unit

	if var_1_16 then
		World.link_unit(var_1_0, var_1_16, arg_1_2, 0)
		Unit.set_local_scale(var_1_16, 0, Vector3(var_1_9, var_1_9, 1))
		Unit.flow_event(var_1_16, "vortex_spawned")

		arg_1_0._inner_decal_unit = var_1_16
	end

	local var_1_17 = arg_1_3.outer_decal_unit

	if var_1_17 then
		World.link_unit(var_1_0, var_1_17, arg_1_2, 0)
		Unit.set_local_scale(var_1_17, 0, Vector3(var_1_14, var_1_14, 1))
		Unit.flow_event(var_1_17, "vortex_spawned")

		arg_1_0._outer_decal_unit = var_1_17
	end

	if var_1_3.use_nav_cost_map_volumes then
		local var_1_18 = var_1_3.full_outer_radius
		local var_1_19 = var_1_3.high_cost_nav_cost_map_cost_type
		local var_1_20 = var_1_3.medium_cost_nav_cost_map_cost_type

		arg_1_0:_create_nav_cost_maps(var_1_1, var_1_5, var_1_18, var_1_19, var_1_20)

		arg_1_0._use_nav_cost_map_volumes = true
	end

	arg_1_0._owner_unit = arg_1_3.owner_unit or arg_1_2
end

VortexExtension._create_nav_cost_maps = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = 1
	local var_2_1 = Matrix4x4.from_translation(arg_2_2)
	local var_2_2 = Vector3(arg_2_3, arg_2_3, 1)
	local var_2_3 = arg_2_1:create_nav_cost_map(arg_2_4, var_2_0)

	arg_2_0._high_cost_nav_cost_map_volume_id = arg_2_1:add_nav_cost_map_box_volume(var_2_1, var_2_2, var_2_3)
	arg_2_0._high_cost_nav_cost_map_id = var_2_3

	local var_2_4 = arg_2_1:create_nav_cost_map(arg_2_5, var_2_0)

	arg_2_0._medium_cost_nav_cost_map_volume_id = arg_2_1:add_nav_cost_map_box_volume(var_2_1, var_2_2, var_2_4)
	arg_2_0._medium_cost_nav_cost_map_id = var_2_4
	arg_2_0._next_nav_cost_map_update_t = Managers.time:time("game") + var_0_5
end

VortexExtension.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = var_0_2[arg_3_2]

	arg_3_0.blackboard = var_3_0

	local var_3_1 = arg_3_0.vortex_template
	local var_3_2 = Managers.time:time("game")
	local var_3_3 = var_0_3

	var_3_0.vortex_data = {
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
		physics_world = World.get_data(arg_3_1, "physics_world"),
		wander_state = var_3_1.forced_standing_still and "forced_standing_still" or "recalc_path",
		wanted_height = var_3_1.max_height,
		height_ring_buffer = {
			write_index = 1,
			buffer = Script.new_array(var_3_3),
			max_size = var_3_3
		},
		fx_radius = var_3_1.start_radius,
		wanted_inner_radius = var_3_1.full_inner_radius,
		wanted_fx_radius = var_3_1.full_fx_radius,
		inner_radius_ring_buffer = {
			write_index = 1,
			buffer = Script.new_array(var_3_3),
			max_size = var_3_3
		},
		windup_time = var_3_2 + var_3_1.windup_time,
		time_of_death = var_3_2 + ConflictUtils.random_interval(var_3_1.time_of_life),
		vortex_template = var_3_1
	}

	var_3_0.locomotion_extension:set_rotation_speed(0)

	local var_3_4 = var_3_0.navigation_extension

	var_3_4:init_position()

	if var_3_1.override_movement_speed then
		var_3_4:set_max_speed(var_3_1.override_movement_speed)
	end

	local var_3_5 = var_3_1.start_sound_event_name or "Play_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(arg_3_1, var_3_5, arg_3_2)
end

VortexExtension.destroy = function (arg_4_0)
	local var_4_0 = arg_4_0.blackboard
	local var_4_1 = var_4_0.vortex_data
	local var_4_2 = var_4_1.players_inside
	local var_4_3 = var_4_1.players_ejected
	local var_4_4 = var_4_1.ai_units_inside
	local var_4_5 = var_0_2
	local var_4_6 = arg_4_0.unit
	local var_4_7 = Managers.state.side:sides()

	for iter_4_0 = 1, #var_4_7 do
		local var_4_8 = var_4_7[iter_4_0].PLAYER_AND_BOT_UNITS
		local var_4_9 = #var_4_8

		for iter_4_1 = 1, var_4_9 do
			local var_4_10 = var_4_8[iter_4_1]

			if var_0_0(var_4_10) then
				if var_4_2[var_4_10] then
					StatusUtils.set_in_vortex_network(var_4_10, false, nil)

					var_4_2[var_4_10] = nil
				elseif var_4_3[var_4_10] then
					var_4_3[var_4_10] = nil
				end

				local var_4_11 = ScriptUnit.extension(var_4_10, "status_system")

				var_4_11.smacked_into_wall = false

				if var_4_11.near_vortex_unit == var_4_6 then
					StatusUtils.set_near_vortex_network(var_4_10, false)
				end
			end
		end
	end

	for iter_4_2, iter_4_3 in pairs(var_4_4) do
		if ALIVE[iter_4_2] then
			local var_4_12 = Vector3(0, 0, -6)
			local var_4_13 = var_4_5[iter_4_2]

			if var_4_13 then
				local var_4_14 = var_4_13.locomotion_extension

				var_4_14:set_wanted_velocity(var_4_12)
				var_4_14:set_affected_by_gravity(true)
				var_4_14:set_movement_type("constrained_by_mover")

				local var_4_15 = var_4_13.ejected_from_vortex or Vector3Box()

				var_4_15:store(var_4_12)

				var_4_13.ejected_from_vortex = var_4_15
				var_4_13.in_vortex_state = "ejected_from_vortex"
			end
		end
	end

	local var_4_16 = arg_4_0._inner_decal_unit

	if var_0_0(var_4_16) then
		Unit.flow_event(var_4_16, "vortex_despawned")
	end

	local var_4_17 = arg_4_0._outer_decal_unit

	if var_0_0(var_4_17) then
		Unit.flow_event(var_4_17, "vortex_despawned")
	end

	table.clear(var_4_1)

	var_4_0.vortex_data = nil

	local var_4_18 = arg_4_0.world
	local var_4_19 = arg_4_0.vortex_template.stop_sound_event_name or "Stop_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(var_4_18, var_4_19, var_4_6)

	if arg_4_0._use_nav_cost_map_volumes then
		local var_4_20 = arg_4_0.ai_system
		local var_4_21 = arg_4_0._high_cost_nav_cost_map_id
		local var_4_22 = arg_4_0._high_cost_nav_cost_map_volume_id

		var_4_20:remove_nav_cost_map_volume(var_4_22, var_4_21)
		var_4_20:destroy_nav_cost_map(var_4_21)

		local var_4_23 = arg_4_0._medium_cost_nav_cost_map_id
		local var_4_24 = arg_4_0._medium_cost_nav_cost_map_volume_id

		var_4_20:remove_nav_cost_map_volume(var_4_24, var_4_23)
		var_4_20:destroy_nav_cost_map(var_4_23)
	end
end

local var_0_6 = 2

VortexExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.blackboard
	local var_5_1 = arg_5_0.vortex_template
	local var_5_2 = var_5_0.vortex_data
	local var_5_3 = var_5_0.nav_world
	local var_5_4 = var_5_0.navigation_extension
	local var_5_5 = var_5_4:traverse_logic()
	local var_5_6 = var_0_1[arg_5_1]
	local var_5_7, var_5_8, var_5_9 = arg_5_0:control_size(arg_5_1, arg_5_5, arg_5_3, var_5_3, var_5_5, var_5_1, var_5_2)

	if arg_5_5 > var_5_2.windup_time then
		arg_5_0:attract(arg_5_1, arg_5_5, arg_5_3, var_5_0, var_5_1, var_5_2, var_5_6, var_5_7, var_5_8)
	end

	if arg_5_5 > var_5_2.time_of_death then
		Managers.state.conflict:destroy_unit(arg_5_1, var_5_0, "vortex")

		return
	end

	if arg_5_0._use_nav_cost_map_volumes and arg_5_5 > arg_5_0._next_nav_cost_map_update_t then
		local var_5_10 = arg_5_0.ai_system
		local var_5_11 = var_5_0.locomotion_extension
		local var_5_12 = var_5_1.full_outer_radius

		arg_5_0:_update_nav_cost_map_volumes(var_5_6, var_5_12, var_5_3, var_5_10, var_5_4, var_5_11)

		arg_5_0._next_nav_cost_map_update_t = arg_5_5 + var_0_5
	end

	local var_5_13 = var_5_9 / var_5_1.full_fx_radius
	local var_5_14 = var_5_2.height / var_5_1.max_height
	local var_5_15 = arg_5_0.current_height_lerp
	local var_5_16 = math.lerp(var_5_15, var_5_14, math.min(arg_5_3 * var_0_6, 1))

	arg_5_0.current_height_lerp = var_5_16

	local var_5_17 = var_5_13 * var_5_1.full_fx_radius
	local var_5_18 = var_5_16 * var_5_1.max_height

	Unit.set_local_scale(arg_5_1, 0, Vector3(var_5_17, var_5_17, var_5_18))
end

local function var_0_7(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0, var_6_1, var_6_2, var_6_3, var_6_4 = GwNavQueries.triangle_from_position(arg_6_0, arg_6_1, 3, 3)

	if var_6_0 then
		local var_6_5 = Vector3.normalize(var_6_3 - var_6_2)
		local var_6_6 = Vector3.normalize(var_6_4 - var_6_2)
		local var_6_7 = Vector3.normalize(Vector3.cross(var_6_5, var_6_6))
		local var_6_8 = Vector3.cross(var_6_7, arg_6_2)
		local var_6_9 = Quaternion.look(var_6_8, var_6_7)
		local var_6_10 = Vector3(arg_6_1.x, arg_6_1.y, var_6_1)

		return Matrix4x4.from_quaternion_position(var_6_9, var_6_10), var_6_10, var_6_9, var_6_8
	end
end

VortexExtension._update_nav_cost_map_volumes = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = arg_7_6:current_velocity()
	local var_7_1 = Vector3.normalize(var_7_0)
	local var_7_2 = Vector3.cross(var_7_1, Vector3.up())
	local var_7_3, var_7_4, var_7_5, var_7_6 = var_0_7(arg_7_3, arg_7_1, var_7_2)

	if not var_7_3 then
		return
	end

	local var_7_7 = arg_7_0._high_cost_nav_cost_map_id
	local var_7_8 = arg_7_0._high_cost_nav_cost_map_volume_id

	arg_7_4:set_nav_cost_map_volume_transform(var_7_8, var_7_7, var_7_3)

	local var_7_9 = Vector3.length(var_7_0) / arg_7_5:get_max_speed()
	local var_7_10 = math.lerp(1, 2, var_7_9)
	local var_7_11 = Vector3(arg_7_2, var_7_10 * arg_7_2, 1)
	local var_7_12 = arg_7_0._medium_cost_nav_cost_map_id
	local var_7_13 = arg_7_0._medium_cost_nav_cost_map_volume_id

	arg_7_4:set_nav_cost_map_volume_scale(var_7_13, var_7_12, var_7_11)

	local var_7_14 = var_7_4 + var_7_6 * (0.5 * arg_7_2 * var_7_10)
	local var_7_15 = Matrix4x4.from_quaternion_position(var_7_5, var_7_14)

	arg_7_4:set_nav_cost_map_volume_transform(var_7_13, var_7_12, var_7_15)
end

local var_0_8 = 0.25

VortexExtension._update_height = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = 1
	local var_8_1 = arg_8_5.current_raycast_rad
	local var_8_2 = arg_8_5.inner_radius
	local var_8_3 = var_0_1[arg_8_1] + Vector3(math.cos(var_8_1) * var_8_2, math.sin(var_8_1) * var_8_2, var_8_0)
	local var_8_4 = arg_8_5.physics_world
	local var_8_5 = arg_8_5.height
	local var_8_6 = arg_8_4.max_height - var_8_0
	local var_8_7, var_8_8, var_8_9, var_8_10, var_8_11 = PhysicsWorld.immediate_raycast(var_8_4, var_8_3, Vector3.up(), var_8_6, "closest", "collision_filter", "filter_ai_mover")
	local var_8_12 = var_8_7 and var_8_9 or var_8_6
	local var_8_13 = math.max(var_8_12, 4)
	local var_8_14 = arg_8_5.height_ring_buffer
	local var_8_15 = var_8_14.buffer
	local var_8_16 = var_8_14.max_size
	local var_8_17 = var_8_13 + var_8_0

	for iter_8_0 = 1, var_8_16 do
		local var_8_18 = var_8_15[iter_8_0]

		if var_8_18 and var_8_18 < var_8_17 then
			var_8_17 = var_8_18
		end
	end

	local var_8_19 = var_8_14.write_index

	var_8_15[var_8_19] = var_8_13 + var_8_0
	var_8_14.write_index = var_8_19 % var_8_16 + 1

	if arg_8_5.wanted_height ~= var_8_17 then
		arg_8_5.wanted_height = var_8_17
		arg_8_5.start_lerp_height = var_8_5
	end

	local var_8_20 = arg_8_5.wanted_height

	if var_8_20 < var_8_5 then
		arg_8_5.height = var_8_20
	elseif var_8_5 < var_8_20 then
		local var_8_21 = arg_8_5.start_lerp_height
		local var_8_22 = math.abs(var_8_5 - var_8_21) / math.abs(var_8_20 - var_8_21)
		local var_8_23 = math.clamp(var_8_22 + arg_8_3 * var_0_8, 0, 1)

		arg_8_5.height = math.lerp(var_8_21, var_8_20, var_8_23)
	end
end

local var_0_9 = 0.75
local var_0_10 = 1.5

VortexExtension._update_radius = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	local var_9_0 = var_0_1[arg_9_1]
	local var_9_1 = arg_9_7.inner_radius
	local var_9_2 = arg_9_7.fx_radius
	local var_9_3 = arg_9_7.current_raycast_rad
	local var_9_4 = arg_9_6.full_inner_radius
	local var_9_5 = var_9_0 + Vector3(math.cos(var_9_3) * var_9_4, math.sin(var_9_3) * var_9_4, 0)
	local var_9_6, var_9_7, var_9_8, var_9_9 = LocomotionUtils.raycast_on_navmesh(arg_9_4, var_9_0, var_9_5, arg_9_5, 1, 1)

	if not var_9_7 then
		return
	end

	local var_9_10 = Vector3.distance(var_9_7, var_9_9)
	local var_9_11 = arg_9_7.inner_radius_ring_buffer
	local var_9_12 = var_9_11.buffer
	local var_9_13 = var_9_11.max_size
	local var_9_14 = math.min(var_9_10, arg_9_6.full_inner_radius)

	for iter_9_0 = 1, var_9_13 do
		local var_9_15 = var_9_12[iter_9_0]

		if var_9_15 and var_9_15 < var_9_14 then
			var_9_14 = var_9_15
		end
	end

	local var_9_16 = math.max(var_9_14, arg_9_6.min_inner_radius)
	local var_9_17 = var_9_11.write_index

	var_9_12[var_9_17] = var_9_10
	var_9_11.write_index = var_9_17 % var_9_13 + 1

	if arg_9_7.wanted_inner_radius ~= var_9_16 then
		local var_9_18 = var_9_16 / arg_9_6.full_inner_radius

		arg_9_7.wanted_fx_radius = math.max(arg_9_6.full_fx_radius * var_9_18, arg_9_6.min_fx_radius)
		arg_9_7.wanted_inner_radius = var_9_16
		arg_9_7.start_lerp_inner_radius = var_9_1
		arg_9_7.start_lerp_fx_radius = var_9_2
	end

	local var_9_19 = arg_9_7.wanted_inner_radius

	if var_9_19 < var_9_1 then
		arg_9_7.inner_radius = var_9_19
	elseif var_9_1 < var_9_19 then
		local var_9_20 = arg_9_7.start_lerp_inner_radius
		local var_9_21 = math.abs(var_9_1 - var_9_20) / math.abs(var_9_19 - var_9_20)
		local var_9_22 = math.clamp(var_9_21 + arg_9_3 * var_0_9, 0, 1)

		arg_9_7.inner_radius = math.lerp(var_9_20, var_9_19, var_9_22)
	end

	local var_9_23 = arg_9_7.wanted_fx_radius

	if var_9_23 ~= var_9_2 then
		local var_9_24 = arg_9_7.start_lerp_fx_radius
		local var_9_25 = math.abs(var_9_2 - var_9_24) / math.abs(var_9_23 - var_9_24)
		local var_9_26 = var_9_2 < var_9_23 and var_0_9 or var_0_10
		local var_9_27 = math.clamp(var_9_25 + arg_9_3 * var_9_26, 0, 1)

		arg_9_7.fx_radius = math.lerp(var_9_24, var_9_23, var_9_27)
	end

	local var_9_28 = arg_9_7.inner_radius / arg_9_6.full_inner_radius

	arg_9_7.outer_radius = math.max(arg_9_6.min_outer_radius, arg_9_6.full_outer_radius * var_9_28)
end

VortexExtension.control_size = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	arg_10_7.current_raycast_rad = math.fmod(arg_10_7.current_raycast_rad + var_0_4, 2 * math.pi)

	arg_10_0:_update_radius(arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	arg_10_0:_update_height(arg_10_1, arg_10_2, arg_10_3, arg_10_6, arg_10_7)

	local var_10_0 = Managers.state.network:game()
	local var_10_1 = Managers.state.unit_storage:go_id(arg_10_1)

	if var_10_0 and var_10_1 then
		local var_10_2 = arg_10_7.inner_radius / arg_10_6.full_inner_radius
		local var_10_3 = arg_10_7.fx_radius / arg_10_6.full_fx_radius
		local var_10_4 = arg_10_7.height / arg_10_6.max_height

		GameSession.set_game_object_field(var_10_0, var_10_1, "inner_radius_percentage", var_10_2)
		GameSession.set_game_object_field(var_10_0, var_10_1, "fx_radius_percentage", var_10_3)
		GameSession.set_game_object_field(var_10_0, var_10_1, "height_percentage", var_10_4)
	end

	return arg_10_7.inner_radius, arg_10_7.outer_radius, arg_10_7.fx_radius
end

local var_0_11 = 4
local var_0_12 = Script.new_array(var_0_11)

VortexExtension._update_attract_players = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11)
	local var_11_0 = arg_11_2.nav_world
	local var_11_1 = arg_11_3.physics_world
	local var_11_2 = arg_11_3.height
	local var_11_3 = arg_11_3.players_inside
	local var_11_4 = arg_11_3.players_ejected
	local var_11_5 = arg_11_4.player_eject_speed
	local var_11_6 = arg_11_4.player_attract_speed
	local var_11_7 = arg_11_4.player_eject_distance
	local var_11_8 = PlayerUnitMovementSettings.gravity_acceleration
	local var_11_9 = "filter_player_mover"
	local var_11_10 = 15
	local var_11_11 = 15
	local var_11_12 = Vector3.up() * 0.05
	local var_11_13 = arg_11_9 + 2
	local var_11_14 = Managers.state.side:sides()

	for iter_11_0 = 1, #var_11_14 do
		local var_11_15 = var_11_14[iter_11_0].PLAYER_AND_BOT_UNITS
		local var_11_16 = #var_11_15

		for iter_11_1 = 1, var_11_16 do
			local var_11_17 = var_11_15[iter_11_1]
			local var_11_18 = var_0_2[var_11_17].breed
			local var_11_19 = ScriptUnit.extension(var_11_17, "status_system")
			local var_11_20 = var_11_18.vortexable and var_11_19:is_valid_vortex_target()
			local var_11_21 = ScriptUnit.extension(var_11_17, "locomotion_system")
			local var_11_22 = var_0_1[var_11_17]
			local var_11_23 = arg_11_6 - var_11_22
			local var_11_24 = -var_11_23.z

			Vector3.set_z(var_11_23, 0)

			local var_11_25 = Vector3.length(var_11_23)

			if not var_11_19.near_vortex and var_11_25 < var_11_13 then
				StatusUtils.set_near_vortex_network(var_11_17, true, arg_11_1)
			elseif var_11_19.near_vortex_unit == arg_11_1 and var_11_13 <= var_11_25 then
				StatusUtils.set_near_vortex_network(var_11_17, false)
			end

			if var_11_3[var_11_17] then
				local var_11_26 = var_11_3[var_11_17].vortex_eject_height
				local var_11_27 = var_11_3[var_11_17].vortex_eject_time
				local var_11_28 = Unit.mover(var_11_17)

				if Mover.collides_sides(var_11_28) then
					if not var_11_19.smacked_into_wall then
						var_11_19.smacked_into_wall = arg_11_5 + 0.7

						local var_11_29 = var_11_21:current_velocity()
						local var_11_30 = Vector3.normalize(var_11_29)
						local var_11_31 = arg_11_2.breed.name
						local var_11_32 = DamageUtils.calculate_damage(arg_11_4.damage, var_11_17, arg_11_1)

						DamageUtils.add_damage_network(var_11_17, arg_11_1, var_11_32, "torso", "cutting", nil, -var_11_30, var_11_31, nil, nil, nil, arg_11_4.hit_react_type, nil, nil, nil, nil, nil, nil, 1)
					end
				elseif var_11_19.smacked_into_wall and arg_11_5 > var_11_19.smacked_into_wall then
					var_11_19.smacked_into_wall = false
				end

				if not var_11_20 or arg_11_11 < var_11_25 then
					StatusUtils.set_in_vortex_network(var_11_17, false, nil)

					var_11_3[var_11_17] = nil
					arg_11_3.num_players_inside = arg_11_3.num_players_inside - 1
				elseif var_11_26 < var_11_24 or var_11_2 < var_11_24 or var_11_27 < arg_11_5 then
					local var_11_33 = var_11_21:current_velocity()
					local var_11_34 = Vector3.normalize(var_11_33)
					local var_11_35 = LocomotionUtils.pos_on_mesh(var_11_0, var_11_22 + var_11_34 * var_11_7, var_11_10, var_11_11)

					if var_11_35 then
						local var_11_36, var_11_37 = WeaponHelper.test_angled_trajectory(var_11_1, var_11_22, var_11_35 + var_11_12, -var_11_8, var_11_5, nil, var_0_12, var_0_11, var_11_9)

						if var_11_36 then
							StatusUtils.set_in_vortex_network(var_11_17, false, nil)
							StatusUtils.set_catapulted_network(var_11_17, true, var_11_37)

							var_11_3[var_11_17] = nil
							var_11_4[var_11_17] = -1
							arg_11_3.num_players_inside = arg_11_3.num_players_inside - 1
						end
					end
				end
			elseif var_11_4[var_11_17] then
				local var_11_38 = var_11_4[var_11_17]

				if var_11_38 < 0 then
					if not var_11_19:is_catapulted() then
						if var_11_25 < arg_11_9 then
							local var_11_39 = (arg_11_9 - var_11_25) / arg_11_9

							var_11_4[var_11_17] = arg_11_5 + 0.5 + arg_11_4.player_ejected_bliss_time * 0.5 + arg_11_4.player_ejected_bliss_time * var_11_39 * 0.5
						else
							var_11_4[var_11_17] = arg_11_5 + 0.5 + arg_11_4.player_ejected_bliss_time
						end
					end
				elseif var_11_38 < arg_11_5 then
					var_11_4[var_11_17] = nil
				end
			elseif var_11_20 and not var_11_19:is_in_vortex() and var_11_25 < arg_11_9 and arg_11_7 <= var_11_24 and var_11_24 < var_11_2 then
				if arg_11_8 < var_11_25 then
					local var_11_40 = var_11_25 - arg_11_8
					local var_11_41 = math.clamp(1 - var_11_40 / arg_11_10, 0, 1)
					local var_11_42 = var_11_6 * var_11_41 * var_11_41
					local var_11_43 = Vector3.normalize(var_11_23)

					var_11_21:add_external_velocity(var_11_43 * var_11_42)
				elseif StatusUtils.set_in_vortex_network(var_11_17, true, arg_11_1) then
					local var_11_44 = ConflictUtils.random_interval(arg_11_4.player_eject_height)

					var_11_3[var_11_17] = {
						vortex_eject_height = var_11_44,
						vortex_eject_time = arg_11_5 + arg_11_4.player_in_vortex_max_duration
					}
					arg_11_3.num_players_inside = arg_11_3.num_players_inside + 1
				end
			end
		end
	end
end

local var_0_13 = {}

VortexExtension._update_attract_outside_ai = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, arg_12_8)
	local var_12_0 = arg_12_1.height
	local var_12_1 = arg_12_3.ai_attract_speed
	local var_12_2 = arg_12_1.ai_units_inside
	local var_12_3 = AiUtils.broadphase_query(arg_12_4, arg_12_7, var_0_13)

	for iter_12_0 = 1, var_12_3 do
		local var_12_4 = var_0_13[iter_12_0]

		if not var_12_2[var_12_4] then
			local var_12_5 = var_0_2[var_12_4]

			if var_12_5.breed.vortexable then
				local var_12_6 = var_12_5.locomotion_extension
				local var_12_7 = HEALTH_ALIVE[var_12_4]

				if var_12_6 and var_12_7 then
					local var_12_8 = arg_12_4 - var_0_1[var_12_4]
					local var_12_9 = -var_12_8.z

					Vector3.set_z(var_12_8, 0)

					if arg_12_5 <= var_12_9 and var_12_9 < var_12_0 then
						local var_12_10 = Vector3.length(var_12_8)

						if arg_12_6 < var_12_10 then
							local var_12_11 = var_12_10 - arg_12_6
							local var_12_12 = math.clamp(1 - var_12_11 / arg_12_8, 0, 1)
							local var_12_13 = var_12_1 * var_12_12 * var_12_12
							local var_12_14 = Vector3.normalize(var_12_8) * var_12_13

							var_12_6:set_external_velocity(var_12_14)
						else
							var_12_5.in_vortex_state = "in_vortex_init"
							var_12_5.in_vortex = true
							var_12_5.eject_height = ConflictUtils.random_interval(arg_12_3.ai_eject_height)
							var_12_2[var_12_4] = true

							if arg_12_3.suck_in_ai_func then
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
	local var_13_0 = arg_13_3.ai_rotation_speed
	local var_13_1 = arg_13_3.ai_radius_change_speed
	local var_13_2 = arg_13_3.ai_ascension_speed
	local var_13_3 = arg_13_6
	local var_13_4 = arg_13_2.height
	local var_13_5 = Vector3.up()
	local var_13_6 = arg_13_2.ai_units_inside

	for iter_13_0, iter_13_1 in pairs(var_13_6) do
		if HEALTH_ALIVE[iter_13_0] then
			local var_13_7 = var_0_2[iter_13_0]

			if var_13_7.in_vortex_state == "in_vortex" then
				local var_13_8 = var_0_1[iter_13_0]
				local var_13_9, var_13_10, var_13_11 = LocomotionUtils.get_vortex_spin_velocity(var_13_8, arg_13_5, var_13_3, var_13_5, var_13_0, var_13_1, var_13_2, arg_13_4)
				local var_13_12 = var_13_7.locomotion_extension

				var_13_12:set_wanted_velocity(var_13_9)

				if var_13_11 > var_13_7.eject_height or var_13_4 < var_13_11 or arg_13_7 < var_13_10 then
					local var_13_13 = var_13_7.ejected_from_vortex or Vector3Box()

					var_13_13:store(var_13_9)

					var_13_7.ejected_from_vortex = var_13_13
					var_13_7.in_vortex_state = "ejected_from_vortex"

					AiUtils.aggro_unit_of_enemy(iter_13_0, arg_13_1.target_unit)
					var_13_12:set_affected_by_gravity(true)
					var_13_12:set_movement_type("constrained_by_mover")
				end
			elseif var_13_7.in_vortex_state == "landed" then
				var_13_6[iter_13_0] = nil
			end
		else
			var_13_6[iter_13_0] = nil
		end
	end
end

VortexExtension.attract = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9)
	local var_14_0 = -0.5
	local var_14_1 = arg_14_9 - arg_14_8
	local var_14_2 = arg_14_8 + arg_14_5.max_allowed_inner_radius_dist

	if arg_14_5.player_attractable then
		arg_14_0:_update_attract_players(arg_14_1, arg_14_4, arg_14_6, arg_14_5, arg_14_2, arg_14_7, var_14_0, arg_14_8, arg_14_9, var_14_1, var_14_2)
	end

	if arg_14_5.ai_attractable then
		arg_14_0:_update_attract_outside_ai(arg_14_6, arg_14_4, arg_14_5, arg_14_7, var_14_0, arg_14_8, arg_14_9, var_14_1)
		arg_14_0:_update_attract_inside_ai(arg_14_4, arg_14_6, arg_14_5, arg_14_3, arg_14_7, arg_14_8, var_14_2)
	end
end

VortexExtension.is_position_inside = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = (arg_15_0.blackboard.vortex_data.outer_radius + (arg_15_2 or 0))^2
	local var_15_1 = arg_15_0.unit
	local var_15_2 = POSITION_LOOKUP[var_15_1]

	return var_15_0 > Vector3.distance_squared(arg_15_1, var_15_2)
end

local var_0_14 = {}
local var_0_15 = 8
local var_0_16 = 10

VortexExtension.debug_render_vortex = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8)
	arg_16_4 = arg_16_4 + math.sin(arg_16_1 * 1.7) * 0.4

	local var_16_0 = 2 * math.pi / 6
	local var_16_1 = math.floor(155 / var_0_15)
	local var_16_2 = arg_16_8 / var_0_15

	for iter_16_0 = 1, var_0_16 do
		local var_16_3 = iter_16_0 * 2 * math.pi / var_0_16

		for iter_16_1 = 1, var_0_15 do
			local var_16_4 = arg_16_4 + 0.5 * (iter_16_1 * iter_16_1) / var_0_15
			local var_16_5 = arg_16_1 * arg_16_7 + iter_16_1 * var_16_0 + var_16_3

			var_0_14[iter_16_1] = Vector3(math.sin(var_16_5) * var_16_4, math.cos(var_16_5) * var_16_4, (iter_16_1 - 1) * var_16_2)
		end

		local var_16_6 = arg_16_4 + math.sin(arg_16_1) * 0.2
		local var_16_7 = arg_16_1 * arg_16_7 + var_16_3 + 0 * var_16_0
		local var_16_8 = Vector3(math.sin(var_16_7) * var_16_6, math.cos(var_16_7) * var_16_6, 0)

		QuickDrawer:sphere(arg_16_3 + var_16_8, (math.sin(var_16_7 * 3) + 1) / 3, Color(155, 255, 155))

		for iter_16_2 = 1, var_0_15 do
			local var_16_9 = var_0_14[iter_16_2]
			local var_16_10 = Color(155 - var_16_1 * iter_16_2, 255 - var_16_1 * iter_16_2, 155 - var_16_1 * iter_16_2)

			QuickDrawer:line(arg_16_3 + var_16_8, arg_16_3 + var_16_9, var_16_10)

			var_16_8 = var_16_9
		end
	end

	QuickDrawer:circle(arg_16_3, arg_16_5, Vector3.up(), Colors.get("pink"))
	QuickDrawer:circle(arg_16_3, arg_16_6, Vector3.up(), Colors.get("lime_green"))
end
