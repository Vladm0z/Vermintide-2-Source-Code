-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_raycast_impact_unit_extension.lua

ProjectileRaycastImpactUnitExtension = class(ProjectileRaycastImpactUnitExtension, ProjectileBaseImpactUnitExtension)

local var_0_0 = 1
local var_0_1 = 2
local var_0_2 = 3
local var_0_3 = 4

function ProjectileRaycastImpactUnitExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	ProjectileRaycastImpactUnitExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0.collision_filter = arg_1_3.collision_filter or "filter_player_ray_projectile"
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.owner_unit = arg_1_3.owner_unit

	local var_1_0 = Managers.player:owner(arg_1_0.owner_unit)

	arg_1_0.owner_is_local = var_1_0 and var_1_0.local_player or var_1_0 and var_1_0.bot_player or false
	arg_1_0.server_side_raycast = arg_1_3.server_side_raycast
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0._dont_target_friendly = arg_1_3.dont_target_friendly
	arg_1_0._dont_target_patrols = arg_1_3.dont_target_patrols
	arg_1_0._ignore_dead = arg_1_3.ignore_dead
	arg_1_0.last_position = nil
end

function ProjectileRaycastImpactUnitExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
end

function ProjectileRaycastImpactUnitExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	ProjectileRaycastImpactUnitExtension.super.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	if arg_3_0.server_side_raycast and not arg_3_0.is_server then
		return
	end

	if not arg_3_0.server_side_raycast and not arg_3_0.owner_is_local then
		return
	end

	if not arg_3_0.locomotion_extension:moved_this_frame() then
		return
	end

	local var_3_0 = arg_3_0.physics_world
	local var_3_1 = arg_3_0.collision_filter
	local var_3_2 = POSITION_LOOKUP[arg_3_1]
	local var_3_3 = Unit.local_position(arg_3_1, 0)

	if arg_3_0.last_position then
		arg_3_0:_do_raycast(arg_3_1, arg_3_0.last_position:unbox(), var_3_3, var_3_0, var_3_1, arg_3_5, arg_3_3)
	else
		arg_3_0.last_position = Vector3Box()
	end

	arg_3_0.last_position:store(var_3_2)
	arg_3_0:_do_raycast(arg_3_1, var_3_2, var_3_3, var_3_0, var_3_1, arg_3_5, arg_3_3)
end

function ProjectileRaycastImpactUnitExtension._do_raycast(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	local var_4_0, var_4_1 = Vector3.direction_length(arg_4_3 - arg_4_2)

	if var_4_1 < math.epsilon then
		var_4_1 = math.epsilon
	end

	if script_data.debug_projectiles then
		QuickDrawerStay:vector(arg_4_2, var_4_0, Color(255, 255, 255, 0))
	end

	PhysicsWorld.prepare_actors_for_raycast(arg_4_4, arg_4_2, var_4_0, 0.1, 9, var_4_1 * var_4_1)

	local var_4_2 = PhysicsWorld.immediate_raycast(arg_4_4, arg_4_2, var_4_0, var_4_1, "all", "collision_filter", arg_4_5)

	if not var_4_2 then
		return
	end

	local var_4_3 = #var_4_2

	for iter_4_0 = 1, var_4_3 do
		local var_4_4 = var_4_2[iter_4_0]
		local var_4_5 = var_4_4[var_0_3]
		local var_4_6 = Actor.unit(var_4_5)

		if arg_4_0:_valid_target(arg_4_1, var_4_6, var_4_5) then
			local var_4_7 = Unit.num_actors(var_4_6)
			local var_4_8

			for iter_4_1 = 0, var_4_7 - 1 do
				if var_4_5 == Unit.actor(var_4_6, iter_4_1) then
					var_4_8 = iter_4_1

					break
				end
			end

			local var_4_9 = var_4_4[var_0_0]
			local var_4_10 = var_4_4[var_0_1]
			local var_4_11 = var_4_4[var_0_2]

			arg_4_0:impact(var_4_6, var_4_9, var_4_0, var_4_11, var_4_8)
		end
	end
end

function ProjectileRaycastImpactUnitExtension._valid_target(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_2 == arg_5_1 or arg_5_2 == arg_5_0.owner_unit then
		return false
	end

	if Unit.actor(arg_5_2, "c_afro") == arg_5_3 then
		return false
	end

	if arg_5_0._dont_target_friendly then
		local var_5_0 = Managers.state.side

		if var_5_0.side_by_unit[arg_5_2] and not var_5_0:is_enemy(arg_5_0.owner_unit, arg_5_2) then
			return false
		end
	end

	if arg_5_0._dont_target_patrols and AiUtils.is_part_of_patrol(arg_5_2) and not AiUtils.is_aggroed(arg_5_2) then
		return false
	end

	if arg_5_0._ignore_dead and ScriptUnit.has_extension(arg_5_2, "health_system") and not HEALTH_ALIVE[arg_5_2] then
		return false
	end

	return true
end
