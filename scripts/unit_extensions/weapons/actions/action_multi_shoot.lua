-- chunkname: @scripts/unit_extensions/weapons/actions/action_multi_shoot.lua

ActionMultiShoot = class(ActionMultiShoot, ActionShotgun)

local var_0_0 = Unit.set_flow_variable
local var_0_1 = Unit.flow_event

ActionMultiShoot._use_ammo = function (arg_1_0)
	local var_1_0 = arg_1_0.current_action
	local var_1_1 = arg_1_0.ammo_extension
	local var_1_2 = var_1_0.ammo_usage
	local var_1_3 = arg_1_0:_get_total_shots()

	if var_1_0.special_ammo_thing and not arg_1_0.extra_buff_shot then
		var_1_2 = var_1_1:current_ammo()
		var_1_3 = var_1_2
	end

	if var_1_1 and not arg_1_0.extra_buff_shot and not arg_1_0.infinite_ammo then
		var_1_1:use_ammo(var_1_2)
	end

	arg_1_0._num_shots_total = var_1_3
end

ActionMultiShoot._get_barrel_data = function (arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.current_action.barrels
	local var_2_1 = 0

	for iter_2_0, iter_2_1 in ipairs(var_2_0) do
		local var_2_2 = var_2_1 + iter_2_1.shot_count

		if var_2_1 <= arg_2_1 and arg_2_1 <= var_2_2 then
			return iter_2_1
		end

		var_2_1 = var_2_2
	end

	return var_2_0[1]
end

ActionMultiShoot._get_total_shots = function (arg_3_0)
	local var_3_0 = 0
	local var_3_1 = arg_3_0.current_action.barrels

	for iter_3_0, iter_3_1 in ipairs(var_3_1) do
		var_3_0 = var_3_0 + iter_3_1.shot_count
	end

	return var_3_0
end

ActionMultiShoot._combine_rotations = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = Quaternion(Vector3.up(), arg_4_1)
	local var_4_1 = Quaternion(Vector3.right(), arg_4_2)
	local var_4_2 = Quaternion.multiply(arg_4_3, var_4_0)

	return (Quaternion.multiply(var_4_2, var_4_1))
end

ActionMultiShoot._get_spread_rotation = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.spread_extension

	if var_5_0 then
		local var_5_1 = arg_5_0:_get_barrel_data(arg_5_0._shots_fired)
		local var_5_2 = math.degrees_to_radians(var_5_1.yaw)
		local var_5_3 = math.degrees_to_radians(var_5_1.pitch)
		local var_5_4 = arg_5_0:_combine_rotations(var_5_2, var_5_3, arg_5_2)

		return var_5_0:get_target_style_spread(arg_5_0._shots_fired, arg_5_1, var_5_4, arg_5_3, arg_5_4, arg_5_5)
	else
		return arg_5_2
	end
end

ActionMultiShoot._shoot = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.current_action
	local var_6_1 = arg_6_0._fire_position:unbox()
	local var_6_2 = arg_6_0._fire_rotation:unbox()
	local var_6_3 = arg_6_0.world
	local var_6_4 = arg_6_0.physics_world
	local var_6_5 = arg_6_0._check_buffs
	local var_6_6 = var_6_0.num_layers_spread or 1
	local var_6_7 = var_6_0.bullseye or false
	local var_6_8 = var_6_0.spread_pitch or 0.8
	local var_6_9 = arg_6_0.weapon_unit
	local var_6_10 = arg_6_0.item_name
	local var_6_11 = arg_6_0.owner_unit
	local var_6_12 = arg_6_0.is_server

	for iter_6_0 = 1, arg_6_2 do
		arg_6_0._shots_fired = arg_6_0._shots_fired + 1

		local var_6_13 = arg_6_0:_get_spread_rotation(arg_6_1, var_6_2, var_6_6, var_6_7, var_6_8)
		local var_6_14 = Quaternion.forward(var_6_13)
		local var_6_15 = PhysicsWorld.immediate_raycast_actors(var_6_4, var_6_1, var_6_14, var_6_0.range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")

		if var_6_15 then
			local var_6_16 = DamageUtils.process_projectile_hit(var_6_3, var_6_10, var_6_11, var_6_12, var_6_15, var_6_0, var_6_14, var_6_5, nil, arg_6_0.shield_users_blocking, arg_6_0._is_critical_strike, arg_6_0.power_level)

			if var_6_16.buffs_checked then
				var_6_5 = var_6_5 and false
			end

			if var_6_16.blocked_by_unit then
				arg_6_0.shield_users_blocking[var_6_16.blocked_by_unit] = true
			end

			local var_6_17 = var_6_15[#var_6_15][1] or var_6_1 + var_6_14 * var_6_0.range

			var_0_0(var_6_9, "hit_position", var_6_17)
			var_0_0(var_6_9, "fire_position", var_6_1)
			var_0_0(var_6_9, "fire_direction", var_6_14)
			var_0_0(var_6_9, "trail_life", Vector3.length(var_6_17 - var_6_1) * 0.1)
			var_0_1(var_6_9, "lua_bullet_trail")
		end
	end

	arg_6_0._check_buffs = var_6_5
end

ActionMultiShoot.finish = function (arg_7_0, arg_7_1)
	ActionMultiShoot.super.finish(arg_7_0, arg_7_1)

	local var_7_0 = arg_7_0.ammo_extension
	local var_7_1 = arg_7_0.current_action
	local var_7_2 = arg_7_0.owner_unit

	if arg_7_1 ~= "new_interupting_action" then
		ScriptUnit.extension(var_7_2, "status_system"):set_zooming(false)

		local var_7_3 = var_7_1.reload_when_out_of_ammo_condition_func
		local var_7_4 = not var_7_3 and true or var_7_3(var_7_2, arg_7_1)

		if var_7_0 and var_7_1.reload_when_out_of_ammo and var_7_4 and var_7_0:ammo_count() == 0 and var_7_0:can_reload() then
			var_7_0:start_reload(true)
		end
	end
end
