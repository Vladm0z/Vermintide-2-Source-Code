-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_impact/player_projectile_impact_unit_extension.lua

PlayerProjectileImpactUnitExtension = class(PlayerProjectileImpactUnitExtension, ProjectileBaseImpactUnitExtension)

function PlayerProjectileImpactUnitExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	PlayerProjectileImpactUnitExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0.network_manager = Managers.state.network
	arg_1_0.is_server = Managers.player.is_server

	local var_1_0 = arg_1_3.owner_unit

	arg_1_0.owner_unit = var_1_0

	local var_1_1 = Managers.player:owner(var_1_0)

	arg_1_0._dont_target_friendly = arg_1_3.dont_target_friendly
	arg_1_0._dont_target_patrols = arg_1_3.dont_target_patrols

	local var_1_2 = arg_1_3.item_name
	local var_1_3 = ItemMasterList[var_1_2]
	local var_1_4 = BackendUtils.get_item_template(var_1_3)
	local var_1_5 = arg_1_3.item_template_name
	local var_1_6 = arg_1_3.action_name
	local var_1_7 = arg_1_3.sub_action_name

	arg_1_0.action_lookup_data = {
		item_template_name = var_1_5,
		action_name = var_1_6,
		sub_action_name = var_1_7
	}

	local var_1_8 = var_1_4.actions[var_1_6][var_1_7].projectile_info

	arg_1_0.impact_type = var_1_8.impact_type
	arg_1_0.static_impact_type = var_1_8.static_impact_type

	local var_1_9 = "filter_player_ray_projectile_dynamic_only"
	local var_1_10 = "filter_player_ray_projectile_no_player"
	local var_1_11 = "filter_player_ray_projectile_static_only"
	local var_1_12 = Managers.state.difficulty:get_difficulty_settings()

	if DamageUtils.allow_friendly_fire_ranged(var_1_12, var_1_1) then
		var_1_10 = "filter_player_ray_projectile"
	end

	arg_1_0.enemy_collision_filter = arg_1_3.collision_filter or var_1_9
	arg_1_0.static_collision_filter = arg_1_3.collision_filter or var_1_11
	arg_1_0.collision_filter = arg_1_3.collision_filter or var_1_10
	arg_1_0.radius = arg_1_3.radius
	arg_1_0.scene_query_height_offset = var_1_8.scene_query_height_offset or 0
	arg_1_0.last_position = nil
	arg_1_0._friendly_fire_grace_period = Managers.time:time("game") + (var_1_8.friendly_fire_grace_period or 0)
end

function PlayerProjectileImpactUnitExtension.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.locomotion_extension = ScriptUnit.extension(arg_2_2, "projectile_locomotion_system")
end

function PlayerProjectileImpactUnitExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	PlayerProjectileImpactUnitExtension.super.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)

	local var_3_0 = arg_3_0.impact_type
	local var_3_1 = arg_3_0.static_impact_type

	if var_3_0 == "raycast" then
		arg_3_0:update_raycast(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	elseif var_3_0 == "sphere_sweep" then
		if var_3_1 == "sphere_sweep" then
			arg_3_0:update_sphere_sweep(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_0.radius, arg_3_0.enemy_collision_filter)
			arg_3_0:update_sphere_sweep(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_0.radius * 0.25, arg_3_0.static_collision_filter)
		elseif var_3_1 == "raycast" then
			arg_3_0:update_sphere_sweep(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_0.radius, arg_3_0.enemy_collision_filter)
			arg_3_0:update_raycast(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_0.static_collision_filter)
		else
			arg_3_0:update_sphere_sweep(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_0.radius, arg_3_0.collision_filter)
		end
	else
		local var_3_2 = arg_3_0.action_lookup_data
		local var_3_3 = var_3_2.item_template_name
		local var_3_4 = var_3_2.action_name
		local var_3_5 = var_3_2.sub_action_name

		fassert(false, "Unsupported impact type %q in projectile spawned by %q - %q - %q", var_3_0, var_3_3, var_3_4, var_3_5)
	end
end

local var_0_0 = 1
local var_0_1 = 3
local var_0_2 = 4

function PlayerProjectileImpactUnitExtension.update_raycast(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = arg_4_0.locomotion_extension

	if not var_4_0:moved_this_frame() then
		return
	end

	local var_4_1 = var_4_0:last_position()
	local var_4_2 = var_4_0:current_position()
	local var_4_3 = arg_4_0.physics_world
	local var_4_4 = arg_4_6 or arg_4_0.collision_filter
	local var_4_5 = arg_4_0.last_position

	if var_4_5 then
		arg_4_0:_do_raycast(arg_4_1, var_4_5:unbox(), var_4_1, var_4_3, var_4_4, arg_4_5)
	else
		var_4_5 = Vector3Box()
		arg_4_0.last_position = var_4_5
	end

	var_4_5:store(var_4_1)
	arg_4_0:_do_raycast(arg_4_1, var_4_1, var_4_2, var_4_3, var_4_4, arg_4_5)
end

function PlayerProjectileImpactUnitExtension._do_raycast(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	local var_5_0 = arg_5_3 - arg_5_2
	local var_5_1 = Vector3.length(var_5_0)
	local var_5_2 = Vector3.normalize(var_5_0)

	PhysicsWorld.prepare_actors_for_raycast(arg_5_4, arg_5_2, var_5_2, 0, 1, var_5_1 * var_5_1)

	local var_5_3 = Vector3(0, 0, arg_5_0.scene_query_height_offset)
	local var_5_4 = PhysicsWorld.immediate_raycast(arg_5_4, arg_5_2 + var_5_3, var_5_2, var_5_1, "all", "collision_filter", arg_5_5)

	if not var_5_4 then
		return
	end

	local var_5_5 = #var_5_4

	for iter_5_0 = 1, var_5_5 do
		local var_5_6 = var_5_4[iter_5_0]
		local var_5_7 = var_5_6[var_0_0]
		local var_5_8 = var_5_6[var_0_1]
		local var_5_9 = var_5_6[var_0_2]
		local var_5_10 = Actor.unit(var_5_9)

		if arg_5_0:_valid_target(arg_5_1, var_5_10, arg_5_0._owner_unit, arg_5_6) then
			local var_5_11 = Unit.num_actors(var_5_10)
			local var_5_12

			for iter_5_1 = 0, var_5_11 - 1 do
				if var_5_9 == Unit.actor(var_5_10, iter_5_1) then
					var_5_12 = iter_5_1

					break
				end
			end

			fassert(var_5_12, "No actor index found for unit [\"%s\"] that was hit on actor [\"%s\"]", var_5_10, var_5_9)
			arg_5_0:impact(var_5_10, var_5_7, var_5_2, var_5_8, var_5_12)
		end
	end
end

function PlayerProjectileImpactUnitExtension.update_sphere_sweep(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	local var_6_0 = arg_6_0.locomotion_extension

	if not var_6_0:moved_this_frame() then
		return
	end

	local var_6_1 = Vector3(0, 0, arg_6_0.scene_query_height_offset)
	local var_6_2 = var_6_0:last_position() + var_6_1
	local var_6_3 = var_6_0:current_position() + var_6_1
	local var_6_4 = arg_6_0.physics_world

	PhysicsWorld.prepare_actors_for_raycast(var_6_4, var_6_2, Vector3.normalize(var_6_3 - var_6_2), 0, 1, Vector3.length_squared(var_6_3 - var_6_2))

	local var_6_5 = PhysicsWorld.linear_sphere_sweep(var_6_4, var_6_2, var_6_3, arg_6_6, 100, "collision_filter", arg_6_7, "report_initial_overlap")

	if var_6_5 then
		local var_6_6 = Vector3.normalize(var_6_3 - var_6_2)
		local var_6_7 = #var_6_5

		for iter_6_0 = 1, var_6_7 do
			local var_6_8 = var_6_5[iter_6_0]
			local var_6_9 = var_6_8.position
			local var_6_10 = var_6_8.normal
			local var_6_11 = var_6_8.actor
			local var_6_12 = Actor.unit(var_6_11)

			if arg_6_0:_valid_target(arg_6_1, var_6_12, arg_6_0.owner_unit, arg_6_5) then
				local var_6_13 = Unit.num_actors(var_6_12)
				local var_6_14

				for iter_6_1 = 0, var_6_13 - 1 do
					if var_6_11 == Unit.actor(var_6_12, iter_6_1) then
						var_6_14 = iter_6_1

						break
					end
				end

				fassert(var_6_14, "No actor index found for unit [\"%s\"] that was hit on actor [\"%s\"]", var_6_12, var_6_11)
				arg_6_0:impact(var_6_12, var_6_9, var_6_6, var_6_10, var_6_14)
			end
		end
	end
end

function PlayerProjectileImpactUnitExtension._valid_target(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_1 == arg_7_2 or arg_7_3 == arg_7_2 or Unit.is_frozen(arg_7_2) then
		return false
	end

	if arg_7_0._dont_target_friendly or arg_7_4 < arg_7_0._friendly_fire_grace_period then
		local var_7_0 = Managers.state.side

		if var_7_0.side_by_unit[arg_7_2] and not var_7_0:is_enemy(arg_7_0.owner_unit, arg_7_2) then
			return false
		end
	end

	if arg_7_0._dont_target_patrols and AiUtils.is_part_of_patrol(arg_7_1) and not AiUtils.is_aggroed(arg_7_1) then
		return false
	end

	return true
end
