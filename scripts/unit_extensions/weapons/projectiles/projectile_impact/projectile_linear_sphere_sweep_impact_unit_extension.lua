-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_linear_sphere_sweep_impact_unit_extension.lua

local var_0_0 = 0.01

ProjectileLinearSphereSweepImpactUnitExtension = class(ProjectileLinearSphereSweepImpactUnitExtension, ProjectileBaseImpactUnitExtension)

ProjectileLinearSphereSweepImpactUnitExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	ProjectileLinearSphereSweepImpactUnitExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0.collision_filter = arg_1_3.collision_filter or "filter_player_ray_projectile"
	arg_1_0.sphere_radius = arg_1_3.sphere_radius
	arg_1_0.only_one_impact = arg_1_3.only_one_impact
	arg_1_0.owner_unit = arg_1_3.owner_unit
	arg_1_0._dont_target_friendly = arg_1_3.dont_target_friendly
	arg_1_0._dont_target_patrols = arg_1_3.dont_target_patrols
	arg_1_0._next_check_t = 0

	local var_1_0 = Unit.local_position(arg_1_2, 0)

	arg_1_0._last_position = Vector3Box(var_1_0)
end

ProjectileLinearSphereSweepImpactUnitExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
end

ProjectileLinearSphereSweepImpactUnitExtension.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	ProjectileLinearSphereSweepImpactUnitExtension.super.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	if not arg_3_0.locomotion_extension:moved_this_frame() then
		return
	end

	if arg_3_5 > arg_3_0._next_check_t then
		local var_3_0 = arg_3_0.physics_world
		local var_3_1 = arg_3_0.collision_filter
		local var_3_2 = arg_3_0.sphere_radius
		local var_3_3 = arg_3_0._last_position:unbox()
		local var_3_4 = Unit.local_position(arg_3_1, 0)
		local var_3_5 = arg_3_0.only_one_impact
		local var_3_6 = var_3_3 - var_3_4
		local var_3_7 = Vector3.length(var_3_6)
		local var_3_8 = Vector3.normalize(var_3_6)
		local var_3_9 = var_3_3 + var_3_8 * var_3_7 * 0.5
		local var_3_10 = var_3_7

		PhysicsWorld.prepare_actors_for_overlap(var_3_0, var_3_9, var_3_10)

		local var_3_11 = PhysicsWorld.linear_sphere_sweep(var_3_0, var_3_3, var_3_4, var_3_2, 100, "collision_filter", var_3_1, "report_initial_overlap")

		if var_3_11 then
			local var_3_12 = #var_3_11

			for iter_3_0 = 1, var_3_12 do
				local var_3_13 = var_3_11[iter_3_0]
				local var_3_14 = var_3_13.position
				local var_3_15 = var_3_13.normal
				local var_3_16 = var_3_13.actor
				local var_3_17 = Actor.unit(var_3_16)

				if arg_3_0:_valid_target(arg_3_1, var_3_17, var_3_16) and not (var_3_17 == arg_3_1) then
					local var_3_18 = Unit.num_actors(var_3_17)
					local var_3_19

					for iter_3_1 = 0, var_3_18 - 1 do
						if var_3_16 == Unit.actor(var_3_17, iter_3_1) then
							var_3_19 = iter_3_1

							break
						end
					end

					fassert(var_3_19, "No actor index found for unit [\"%s\"] that was hit on actor [\"%s\"]", var_3_17, var_3_16)
					arg_3_0:impact(var_3_17, var_3_14, var_3_8, var_3_15, var_3_19)

					if var_3_5 then
						break
					end
				end
			end
		end

		arg_3_0._last_position:store(var_3_4)

		arg_3_0._next_check_t = arg_3_5 + var_0_0
	end
end

ProjectileLinearSphereSweepImpactUnitExtension._valid_target = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_2 == arg_4_1 or Unit.is_frozen(arg_4_2) or arg_4_3 == Unit.actor(arg_4_2, "c_afro") then
		return false
	end

	if arg_4_0._dont_target_friendly then
		local var_4_0 = Managers.state.side

		if var_4_0.side_by_unit[arg_4_2] and not var_4_0:is_enemy(arg_4_0.owner_unit, arg_4_2) then
			return false
		end
	end

	if arg_4_0._dont_target_patrols and AiUtils.is_part_of_patrol(arg_4_1) and not AiUtils.is_aggroed(arg_4_1) then
		return false
	end

	return true
end
