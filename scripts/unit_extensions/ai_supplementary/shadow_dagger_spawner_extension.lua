-- chunkname: @scripts/unit_extensions/ai_supplementary/shadow_dagger_spawner_extension.lua

ShadowDaggerSpawnerExtension = class(ShadowDaggerSpawnerExtension)

local var_0_0 = 12
local var_0_1 = 1.2
local var_0_2 = 0.5
local var_0_3 = 1
local var_0_4 = 1.5
local var_0_5 = 4
local var_0_6 = "filter_in_line_of_sight_no_players_no_enemies"
local var_0_7 = "units/props/blk/blk_curse_shadow_dagger_01"
local var_0_8 = "drake_pistols"
local var_0_9 = "throw_trajectory"
local var_0_10 = "filter_ray_projectile"
local var_0_11 = "shadow_dagger_impact"
local var_0_12 = 300
local var_0_13 = 0.5
local var_0_14 = true

local function var_0_15(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = "n/a"
	local var_1_1 = var_0_8
	local var_1_2 = var_0_9
	local var_1_3 = var_0_10
	local var_1_4 = var_0_12
	local var_1_5 = var_0_7
	local var_1_6 = Quaternion.look(arg_1_2, Vector3.up())
	local var_1_7 = ActionUtils.pitch_from_rotation(var_1_6)
	local var_1_8 = var_0_11
	local var_1_9 = var_0_13
	local var_1_10 = var_0_14
	local var_1_11 = {
		projectile_locomotion_system = {
			rotate_around_forward = true,
			rotation_speed = 10,
			angle = var_1_7,
			speed = var_1_4,
			target_vector = arg_1_2,
			initial_position = arg_1_1,
			trajectory_template_name = var_1_2,
			gravity_settings = var_1_1,
			start_paused_for_time = var_0_3
		},
		projectile_impact_system = {
			sphere_radius = var_1_9,
			only_one_impact = var_1_10,
			collision_filter = var_1_3,
			owner_unit = arg_1_0
		},
		projectile_system = {
			impact_template_name = "direct_impact",
			damage_source = var_1_0,
			owner_unit = arg_1_0,
			explosion_template_name = var_1_8
		}
	}

	return Managers.state.unit_spawner:spawn_network_unit(var_1_5, "shadow_dagger_unit", var_1_11, arg_1_1)
end

local function var_0_16(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_1 - arg_2_0
	local var_2_1 = Vector3.length(var_2_0)
	local var_2_2 = Vector3.normalize(var_2_0)

	if var_2_1 < 0.001 then
		var_2_1 = 0.001
	end

	local var_2_3 = var_0_13
	local var_2_4 = arg_2_0 + var_2_2 * var_2_1 * 0.5
	local var_2_5 = var_2_1

	PhysicsWorld.prepare_actors_for_overlap(arg_2_2, var_2_4, var_2_5)

	local var_2_6 = 1

	return not PhysicsWorld.linear_sphere_sweep(arg_2_2, arg_2_0, arg_2_1, var_2_3, var_2_6, "collision_filter", arg_2_3, "report_initial_overlap")
end

ShadowDaggerSpawnerExtension.init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_1.world

	arg_3_0.world = var_3_0
	arg_3_0.physics_world = World.get_data(var_3_0, "physics_world")
	arg_3_0.unit = arg_3_2
	arg_3_0.is_server = Managers.player.is_server
	arg_3_0._limitted_spawner = arg_3_3.limitted_spawner
end

ShadowDaggerSpawnerExtension.destroy = function (arg_4_0)
	return
end

ShadowDaggerSpawnerExtension.on_remove_extension = function (arg_5_0, arg_5_1, arg_5_2)
	return
end

ShadowDaggerSpawnerExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if arg_6_0._done then
		return
	end

	if not arg_6_0.is_server then
		return
	end

	if arg_6_0._destroy_t then
		if arg_6_5 > arg_6_0._destroy_t then
			if Unit.alive(arg_6_1) then
				Managers.state.unit_spawner:mark_for_deletion(arg_6_1)
			end

			arg_6_0._done = true
		end

		return
	end

	local var_6_0 = arg_6_0._next_dagger_t

	if not var_6_0 or var_6_0 < arg_6_5 then
		local var_6_1 = (arg_6_0._launched_daggers or -1) + 1
		local var_6_2 = Unit.world_position(arg_6_1, 0) + Vector3(0, 0, 1)
		local var_6_3 = Vector3.up()
		local var_6_4 = Quaternion.forward(Quaternion(var_6_3, 2 * math.pi * (var_6_1 / var_0_0)))
		local var_6_5 = Vector3.normalize(var_6_4)
		local var_6_6 = var_6_2 + var_6_5 * var_0_2
		local var_6_7 = var_6_6 + var_6_5 * var_0_5

		if var_0_16(var_6_6, var_6_7, arg_6_0.physics_world, var_0_6) then
			var_0_15(arg_6_0.unit, var_6_6, var_6_4)

			arg_6_0._next_dagger_t = arg_6_5 + var_0_1
		end

		arg_6_0._launched_daggers = var_6_1

		if arg_6_0._limitted_spawner and var_6_1 >= var_0_0 then
			arg_6_0._destroy_t = arg_6_5 + var_0_4
		end
	end
end
