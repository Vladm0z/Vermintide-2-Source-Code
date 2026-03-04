-- chunkname: @scripts/settings/dlcs/woods/summoned_vortex_extension.lua

SummonedVortexExtension = class(SummonedVortexExtension)

local var_0_0 = Unit.alive
local var_0_1 = POSITION_LOOKUP
local var_0_2 = BLACKBOARDS
local var_0_3 = 36
local var_0_4 = 2 * math.pi / var_0_3
local var_0_5 = 0.5
local var_0_6 = {
	chaos_marauder_with_shield = true,
	chaos_raider = true,
	chaos_fanatic = true,
	skaven_slave = true,
	chaos_berzerker = true,
	skaven_clan_rat_with_shield = true,
	skaven_clan_rat = true,
	chaos_marauder = true
}

SummonedVortexExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0.world = var_1_0
	arg_1_0.unit = arg_1_2
	arg_1_0._target_is_caught = false

	local var_1_1 = Managers.state.entity:system("ai_system")

	arg_1_0.ai_system = var_1_1
	arg_1_0.nav_world = var_1_1:nav_world()

	local var_1_2 = arg_1_3.side_id

	arg_1_0._vortex_bp_categories = Managers.state.side:get_side(var_1_2).enemy_broadphase_categories

	local var_1_3 = arg_1_3.vortex_template_name
	local var_1_4 = VortexTemplates[var_1_3]

	arg_1_0.vortex_template_name = var_1_3
	arg_1_0.vortex_template = var_1_4

	local var_1_5 = var_1_4.inner_fx_name
	local var_1_6 = var_0_1[arg_1_2]
	local var_1_7 = World.create_particles(var_1_0, var_1_5, var_1_6)
	local var_1_8 = Unit.local_rotation(arg_1_2, 0)
	local var_1_9 = Matrix4x4.from_quaternion(var_1_8)
	local var_1_10 = var_1_4.full_inner_radius / var_1_4.full_fx_radius
	local var_1_11 = var_1_4.inner_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(var_1_9, Vector3(var_1_10, var_1_10, var_1_11))
	World.link_particles(var_1_0, var_1_7, arg_1_2, 0, var_1_9, "stop")

	arg_1_0._inner_fx_id = var_1_7

	local var_1_12 = var_1_4.outer_fx_name
	local var_1_13 = World.create_particles(var_1_0, var_1_12, var_1_6)
	local var_1_14 = Matrix4x4.from_quaternion(var_1_8)
	local var_1_15 = var_1_4.full_outer_radius / var_1_4.full_fx_radius
	local var_1_16 = var_1_4.outer_fx_z_scale_multiplier or 1

	Matrix4x4.set_scale(var_1_14, Vector3(var_1_15, var_1_15, var_1_16))
	World.link_particles(var_1_0, var_1_13, arg_1_2, 0, var_1_14, "stop")

	arg_1_0._outer_fx_id = var_1_13
	arg_1_0.current_height_lerp = 0
	arg_1_0._target_unit = arg_1_3.target_unit

	if ALIVE[arg_1_0._target_unit] then
		arg_1_0._target_is_player = var_0_2[arg_1_0._target_unit].is_player
	end

	local var_1_17 = arg_1_3.inner_decal_unit

	if var_1_17 then
		World.link_unit(var_1_0, var_1_17, arg_1_2, 0)
		Unit.set_local_scale(var_1_17, 0, Vector3(var_1_10, var_1_10, 1))
		Unit.flow_event(var_1_17, "vortex_spawned")

		arg_1_0._inner_decal_unit = var_1_17
	end

	local var_1_18 = arg_1_3.outer_decal_unit

	if var_1_18 then
		World.link_unit(var_1_0, var_1_18, arg_1_2, 0)
		Unit.set_local_scale(var_1_18, 0, Vector3(var_1_15, var_1_15, 1))
		Unit.flow_event(var_1_18, "vortex_spawned")

		arg_1_0._outer_decal_unit = var_1_18
	end

	if var_1_4.use_nav_cost_map_volumes then
		local var_1_19 = var_1_4.full_outer_radius
		local var_1_20 = var_1_4.high_cost_nav_cost_map_cost_type
		local var_1_21 = var_1_4.medium_cost_nav_cost_map_cost_type

		arg_1_0:_create_nav_cost_maps(var_1_1, var_1_6, var_1_19, var_1_20, var_1_21)
	end

	arg_1_0._owner_unit = arg_1_3.owner_unit or arg_1_2
end

SummonedVortexExtension._create_nav_cost_maps = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_2 = Vector3Box(arg_2_2)

	local function var_2_0()
		if arg_2_0._nav_cb_blocker then
			return
		end

		local var_3_0 = 1
		local var_3_1 = Matrix4x4.from_translation(arg_2_2:unbox())
		local var_3_2 = Vector3(arg_2_3, arg_2_3, 1)
		local var_3_3 = arg_2_1:create_nav_cost_map(arg_2_4, var_3_0)

		arg_2_0._high_cost_nav_cost_map_volume_id = arg_2_1:add_nav_cost_map_box_volume(var_3_1, var_3_2, var_3_3)
		arg_2_0._high_cost_nav_cost_map_id = var_3_3

		local var_3_4 = arg_2_1:create_nav_cost_map(arg_2_5, var_3_0)

		arg_2_0._medium_cost_nav_cost_map_volume_id = arg_2_1:add_nav_cost_map_box_volume(var_3_1, var_3_2, var_3_4)
		arg_2_0._medium_cost_nav_cost_map_id = var_3_4

		local var_3_5 = Managers.time:time("game")

		arg_2_0._next_nav_cost_map_update_t = var_3_5 + var_0_5
		arg_2_0._use_nav_cost_map_volumes = true
	end

	Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_2_0)
end

SummonedVortexExtension.extensions_ready = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.vortex_template
	local var_4_1 = Managers.time:time("game")
	local var_4_2

	if arg_4_0._target_is_player then
		var_4_2 = var_4_0.time_of_life_player_target
	else
		var_4_2 = var_4_0.time_of_life
	end

	local var_4_3 = var_0_3

	arg_4_0.vortex_data = {
		height = 5,
		current_raycast_rad = 0,
		start_lerp_height = 5,
		physics_world = World.get_data(arg_4_1, "physics_world"),
		wanted_height = var_4_0.max_height,
		height_ring_buffer = {
			write_index = 1,
			buffer = Script.new_array(var_4_3),
			max_size = var_4_3
		},
		inner_radius = var_4_0.full_inner_radius,
		outer_radius = var_4_0.full_outer_radius,
		fx_radius = var_4_0.full_fx_radius,
		windup_time = var_4_1 + var_4_0.windup_time,
		time_of_death = var_4_1 + ConflictUtils.random_interval(var_4_2),
		vortex_template = var_4_0
	}

	local var_4_4 = var_4_0.start_sound_event_name or "Play_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(arg_4_1, var_4_4, arg_4_2)
end

SummonedVortexExtension.refresh_duration = function (arg_5_0)
	if not arg_5_0.vortex_data then
		return
	end

	local var_5_0 = Managers.time:time("game")
	local var_5_1 = arg_5_0.vortex_template
	local var_5_2 = ConflictUtils.random_interval(var_5_1.time_of_life)
	local var_5_3 = arg_5_0._target_unit

	if not ALIVE[var_5_3] then
		arg_5_0.vortex_data.time_of_death = var_5_0 + var_5_2

		return
	end

	local var_5_4 = var_0_2[var_5_3].breed.name
	local var_5_5 = var_5_1.reduce_duration_per_breed
	local var_5_6 = var_5_5 and var_5_5[var_5_4] or 1
	local var_5_7 = math.clamp(var_5_2 * var_5_6, 0, math.huge)

	arg_5_0.vortex_data.time_of_death = var_5_0 + var_5_7
end

SummonedVortexExtension.destroy = function (arg_6_0)
	local var_6_0 = arg_6_0.unit

	arg_6_0._nav_cb_blocker = true

	local var_6_1 = arg_6_0._target_unit

	if HEALTH_ALIVE[var_6_1] then
		local var_6_2 = var_0_2[var_6_1]

		if var_6_2 then
			if arg_6_0._target_is_player then
				StatusUtils.set_in_vortex_network(var_6_1, false, nil)
			else
				local var_6_3 = Vector3(0, 0, -6)
				local var_6_4 = var_6_2.locomotion_extension

				if var_6_4 then
					var_6_4:set_wanted_velocity(var_6_3)
					var_6_4:set_affected_by_gravity(true)
					var_6_4:set_movement_type("constrained_by_mover")
				end

				local var_6_5 = var_6_2.ejected_from_vortex or Vector3Box()

				var_6_5:store(var_6_3)

				var_6_2.ejected_from_vortex = var_6_5
				var_6_2.in_vortex_state = "ejected_from_vortex"
			end
		end
	end

	local var_6_6 = arg_6_0._inner_decal_unit

	if var_0_0(var_6_6) then
		Unit.flow_event(var_6_6, "vortex_despawned")
	end

	local var_6_7 = arg_6_0._outer_decal_unit

	if var_0_0(var_6_7) then
		Unit.flow_event(var_6_7, "vortex_despawned")
	end

	table.clear(arg_6_0.vortex_data)

	arg_6_0.vortex_data = nil

	local var_6_8 = arg_6_0.world
	local var_6_9 = arg_6_0.vortex_template.stop_sound_event_name or "Stop_enemy_sorcerer_vortex_loop"

	WwiseUtils.trigger_unit_event(var_6_8, var_6_9, var_6_0)

	if arg_6_0._use_nav_cost_map_volumes then
		local var_6_10 = arg_6_0.ai_system
		local var_6_11 = arg_6_0._high_cost_nav_cost_map_id
		local var_6_12 = arg_6_0._high_cost_nav_cost_map_volume_id

		var_6_10:remove_nav_cost_map_volume(var_6_12, var_6_11)
		var_6_10:destroy_nav_cost_map(var_6_11)

		local var_6_13 = arg_6_0._medium_cost_nav_cost_map_id
		local var_6_14 = arg_6_0._medium_cost_nav_cost_map_volume_id

		var_6_10:remove_nav_cost_map_volume(var_6_14, var_6_13)
		var_6_10:destroy_nav_cost_map(var_6_13)
	end
end

local var_0_7 = 2

SummonedVortexExtension.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_0.vortex_template
	local var_7_1 = arg_7_0.vortex_data

	if arg_7_5 > var_7_1.time_of_death or not HEALTH_ALIVE[arg_7_0._target_unit] then
		Managers.state.unit_spawner:mark_for_deletion(arg_7_0.unit)

		return
	end

	arg_7_0:_update_height(arg_7_1, arg_7_5, arg_7_3, var_7_0, var_7_1)

	local var_7_2 = var_7_1.inner_radius
	local var_7_3 = var_7_1.outer_radius
	local var_7_4 = var_7_1.fx_radius
	local var_7_5 = var_0_1[arg_7_1]

	if arg_7_5 > var_7_1.windup_time then
		arg_7_0:attract(arg_7_1, arg_7_5, arg_7_3, var_7_0, var_7_1, var_7_5, var_7_2, var_7_3)
	end

	local var_7_6 = var_7_1.height / var_7_0.max_height
	local var_7_7 = arg_7_0.current_height_lerp
	local var_7_8 = math.lerp(var_7_7, var_7_6, math.min(arg_7_3 * var_0_7, 1))

	arg_7_0.current_height_lerp = var_7_8

	local var_7_9 = var_7_1.fx_radius
	local var_7_10 = var_7_8 * var_7_0.max_height

	Unit.set_local_scale(arg_7_1, 0, Vector3(var_7_9, var_7_9, var_7_10))
end

local function var_0_8(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0, var_8_1, var_8_2, var_8_3, var_8_4 = GwNavQueries.triangle_from_position(arg_8_0, arg_8_1, 3, 3)

	if var_8_0 then
		local var_8_5 = Vector3.normalize(var_8_3 - var_8_2)
		local var_8_6 = Vector3.normalize(var_8_4 - var_8_2)
		local var_8_7 = Vector3.normalize(Vector3.cross(var_8_5, var_8_6))
		local var_8_8 = Vector3.cross(var_8_7, arg_8_2)
		local var_8_9 = Quaternion.look(var_8_8, var_8_7)
		local var_8_10 = Vector3(arg_8_1.x, arg_8_1.y, var_8_1)

		return Matrix4x4.from_quaternion_position(var_8_9, var_8_10), var_8_10, var_8_9, var_8_8
	end
end

SummonedVortexExtension._update_nav_cost_map_volumes = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	local var_9_0 = arg_9_6:current_velocity()
	local var_9_1 = Vector3.normalize(var_9_0)
	local var_9_2 = Vector3.cross(var_9_1, Vector3.up())
	local var_9_3, var_9_4, var_9_5, var_9_6 = var_0_8(arg_9_3, arg_9_1, var_9_2)

	if not var_9_3 then
		return
	end

	local var_9_7 = arg_9_0._high_cost_nav_cost_map_id
	local var_9_8 = arg_9_0._high_cost_nav_cost_map_volume_id

	arg_9_4:set_nav_cost_map_volume_transform(var_9_8, var_9_7, var_9_3)

	local var_9_9 = Vector3.length(var_9_0) / arg_9_5:get_max_speed()
	local var_9_10 = math.lerp(1, 2, var_9_9)
	local var_9_11 = Vector3(arg_9_2, var_9_10 * arg_9_2, 1)
	local var_9_12 = arg_9_0._medium_cost_nav_cost_map_id
	local var_9_13 = arg_9_0._medium_cost_nav_cost_map_volume_id

	arg_9_4:set_nav_cost_map_volume_scale(var_9_13, var_9_12, var_9_11)

	local var_9_14 = var_9_4 + var_9_6 * (0.5 * arg_9_2 * var_9_10)
	local var_9_15 = Matrix4x4.from_quaternion_position(var_9_5, var_9_14)

	arg_9_4:set_nav_cost_map_volume_transform(var_9_13, var_9_12, var_9_15)
end

local var_0_9 = 0.25

SummonedVortexExtension._update_height = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = 1
	local var_10_1 = arg_10_5.current_raycast_rad
	local var_10_2 = arg_10_5.inner_radius
	local var_10_3 = var_0_1[arg_10_1] + Vector3(math.cos(var_10_1) * var_10_2, math.sin(var_10_1) * var_10_2, var_10_0)
	local var_10_4 = arg_10_5.physics_world
	local var_10_5 = arg_10_5.height
	local var_10_6 = arg_10_4.max_height - var_10_0
	local var_10_7, var_10_8, var_10_9, var_10_10, var_10_11 = PhysicsWorld.immediate_raycast(var_10_4, var_10_3, Vector3.up(), var_10_6, "closest", "collision_filter", "filter_ai_mover")
	local var_10_12 = var_10_7 and var_10_9 or var_10_6
	local var_10_13 = math.max(var_10_12, 4)
	local var_10_14 = arg_10_5.height_ring_buffer
	local var_10_15 = var_10_14.buffer
	local var_10_16 = var_10_14.max_size
	local var_10_17 = var_10_13 + var_10_0

	for iter_10_0 = 1, var_10_16 do
		local var_10_18 = var_10_15[iter_10_0]

		if var_10_18 and var_10_18 < var_10_17 then
			var_10_17 = var_10_18
		end
	end

	local var_10_19 = var_10_14.write_index

	var_10_15[var_10_19] = var_10_13 + var_10_0
	var_10_14.write_index = var_10_19 % var_10_16 + 1

	if arg_10_5.wanted_height ~= var_10_17 then
		arg_10_5.wanted_height = var_10_17
		arg_10_5.start_lerp_height = var_10_5
	end

	local var_10_20 = arg_10_5.wanted_height

	if var_10_20 < var_10_5 then
		arg_10_5.height = var_10_20
	elseif var_10_5 < var_10_20 then
		local var_10_21 = arg_10_5.start_lerp_height
		local var_10_22 = math.abs(var_10_5 - var_10_21) / math.abs(var_10_20 - var_10_21)
		local var_10_23 = math.clamp(var_10_22 + arg_10_3 * var_0_9, 0, 1)

		arg_10_5.height = math.lerp(var_10_21, var_10_20, var_10_23)
	end
end

SummonedVortexExtension._update_attract_outside_target = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
	local var_11_0 = arg_11_0._target_unit
	local var_11_1 = var_0_2[var_11_0]
	local var_11_2 = var_11_1.locomotion_extension or ScriptUnit.has_extension(var_11_0, "locomotion_system")

	if not var_11_2 then
		return
	end

	local var_11_3 = arg_11_3 - var_0_1[var_11_0]

	Vector3.set_z(var_11_3, 0)

	local var_11_4 = Vector3.length(var_11_3)

	if arg_11_0._target_is_player then
		local var_11_5 = arg_11_6 + 2
		local var_11_6 = ScriptUnit.extension(var_11_0, "status_system")

		if not var_11_6.near_vortex and var_11_4 < var_11_5 then
			StatusUtils.set_near_vortex_network(var_11_0, true, arg_11_0.unit)
		elseif var_11_6.near_vortex_unit == arg_11_0.unit and var_11_5 <= var_11_4 then
			StatusUtils.set_near_vortex_network(var_11_0, false)
		end
	end

	if arg_11_5 < var_11_4 then
		local var_11_7 = var_11_4 - arg_11_5
		local var_11_8 = math.clamp(1 - var_11_7 / arg_11_7, 0, 1)

		if arg_11_0._target_is_player then
			local var_11_9 = arg_11_2.player_attract_speed * var_11_8 * var_11_8
			local var_11_10 = Vector3.normalize(var_11_3)

			var_11_2:add_external_velocity(var_11_10 * var_11_9)
		else
			local var_11_11 = arg_11_2.ai_attract_speed * var_11_8 * var_11_8
			local var_11_12 = Vector3.normalize(var_11_3) * var_11_11

			var_11_2:set_external_velocity(var_11_12)
		end
	else
		arg_11_0._target_is_caught = true

		local var_11_13 = true

		if arg_11_0._target_is_player then
			var_11_13 = StatusUtils.set_in_vortex_network(var_11_0, true, arg_11_0.unit)
		else
			var_11_1.in_vortex_state = "in_vortex_init"
			var_11_1.in_vortex = true
			var_11_1.thornsister_vortex = true
			var_11_1.thornsister_vortex_ext = arg_11_0

			local var_11_14 = var_11_1.breed.name

			if var_0_6[var_11_14] then
				var_11_1.sot_landing = true
			end

			local var_11_15 = Managers.time:time("game")
			local var_11_16 = ConflictUtils.random_interval(arg_11_2.time_of_life)
			local var_11_17 = arg_11_2.reduce_duration_per_breed
			local var_11_18 = var_11_17 and var_11_17[var_11_14] or 1
			local var_11_19 = math.clamp(var_11_16 * var_11_18, 0, math.huge)

			arg_11_0.vortex_data.time_of_death = var_11_15 + var_11_19

			if ScriptUnit.has_extension(var_11_0, "ai_system") then
				var_11_1.only_trust_your_own_eyes = false

				AiUtils.aggro_unit_of_enemy(var_11_0, arg_11_0._owner_unit)
			end

			var_11_1.eject_height = ConflictUtils.random_interval(arg_11_2.ai_eject_height)
		end

		if not arg_11_0._target_is_player or var_11_13 then
			Managers.state.achievement:trigger_event("vortex_caught_unit", arg_11_0._owner_unit, var_11_0)
		end
	end
end

SummonedVortexExtension._update_caught_target = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = arg_12_0._target_unit

	if arg_12_0._target_is_player then
		if not ScriptUnit.extension(var_12_0, "status_system"):is_in_vortex() then
			arg_12_1.time_of_death = 0
		end

		return
	end

	local var_12_1 = arg_12_2.ai_rotation_speed
	local var_12_2 = arg_12_2.ai_radius_change_speed
	local var_12_3 = arg_12_2.ai_ascension_speed
	local var_12_4 = arg_12_2.ai_max_ascension_height
	local var_12_5 = arg_12_5
	local var_12_6 = arg_12_1.height
	local var_12_7 = Vector3.up()
	local var_12_8 = var_0_2[var_12_0]

	if var_12_8.in_vortex_state == "in_vortex" then
		local var_12_9 = var_0_1[var_12_0]
		local var_12_10, var_12_11, var_12_12 = LocomotionUtils.get_vortex_spin_velocity(var_12_9, arg_12_4, var_12_5, var_12_7, var_12_1, var_12_2, var_12_3, arg_12_3)
		local var_12_13 = var_12_8.locomotion_extension

		var_12_13:set_wanted_velocity(var_12_10)

		if var_12_12 > var_12_8.eject_height or var_12_6 < var_12_12 or arg_12_6 < var_12_11 or var_12_4 < var_12_12 then
			local var_12_14 = var_12_10 * 0

			var_12_13:set_wanted_velocity(var_12_14)
		end
	elseif var_12_8.in_vortex_state == "landed" then
		arg_12_0._target_unit = nil
	end
end

SummonedVortexExtension.attract = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8)
	local var_13_0 = -0.5
	local var_13_1 = arg_13_8 - arg_13_7
	local var_13_2 = arg_13_7 + arg_13_4.max_allowed_inner_radius_dist

	if not arg_13_0._target_is_caught then
		arg_13_0:_update_attract_outside_target(arg_13_5, arg_13_4, arg_13_6, var_13_0, arg_13_7, arg_13_8, var_13_1)
	else
		arg_13_0:_update_caught_target(arg_13_5, arg_13_4, arg_13_3, arg_13_6, arg_13_7, var_13_2)
	end
end

SummonedVortexExtension.is_position_inside = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = (arg_14_0.vortex_data.outer_radius + (arg_14_2 or 0))^2
	local var_14_1 = arg_14_0.unit
	local var_14_2 = POSITION_LOOKUP[var_14_1]

	return var_14_0 > Vector3.distance_squared(arg_14_1, var_14_2)
end

local var_0_10 = {}
local var_0_11 = 8
local var_0_12 = 10

SummonedVortexExtension.debug_render_vortex = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8)
	arg_15_4 = arg_15_4 + math.sin(arg_15_1 * 1.7) * 0.4

	local var_15_0 = 2 * math.pi / 6
	local var_15_1 = math.floor(155 / var_0_11)
	local var_15_2 = arg_15_8 / var_0_11

	for iter_15_0 = 1, var_0_12 do
		local var_15_3 = iter_15_0 * 2 * math.pi / var_0_12

		for iter_15_1 = 1, var_0_11 do
			local var_15_4 = arg_15_4 + 0.5 * (iter_15_1 * iter_15_1) / var_0_11
			local var_15_5 = arg_15_1 * arg_15_7 + iter_15_1 * var_15_0 + var_15_3

			var_0_10[iter_15_1] = Vector3(math.sin(var_15_5) * var_15_4, math.cos(var_15_5) * var_15_4, (iter_15_1 - 1) * var_15_2)
		end

		local var_15_6 = arg_15_4 + math.sin(arg_15_1) * 0.2
		local var_15_7 = arg_15_1 * arg_15_7 + var_15_3 + 0 * var_15_0
		local var_15_8 = Vector3(math.sin(var_15_7) * var_15_6, math.cos(var_15_7) * var_15_6, 0)

		QuickDrawer:sphere(arg_15_3 + var_15_8, (math.sin(var_15_7 * 3) + 1) / 3, Color(155, 255, 155))

		for iter_15_2 = 1, var_0_11 do
			local var_15_9 = var_0_10[iter_15_2]
			local var_15_10 = Color(155 - var_15_1 * iter_15_2, 255 - var_15_1 * iter_15_2, 155 - var_15_1 * iter_15_2)

			QuickDrawer:line(arg_15_3 + var_15_8, arg_15_3 + var_15_9, var_15_10)

			var_15_8 = var_15_9
		end
	end

	QuickDrawer:circle(arg_15_3, arg_15_5, Vector3.up(), Colors.get("pink"))
	QuickDrawer:circle(arg_15_3, arg_15_6, Vector3.up(), Colors.get("lime_green"))
end
