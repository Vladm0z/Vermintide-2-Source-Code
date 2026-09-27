-- chunkname: @scripts/unit_extensions/weapons/actions/action_multi_shoot.lua

ActionMultiShoot = class(ActionMultiShoot, ActionShotgun)

local set_flow_variable = Unit.set_flow_variable
local flow_event = Unit.flow_event

ActionMultiShoot._use_ammo = function (self)
	-- function 1
	local current_action = self.current_action
	local ammo_extension = self.ammo_extension
	local ammo_usage = current_action.ammo_usage
	local _get_total_shots = self:_get_total_shots()

	if not (not current_action.special_ammo_thing and self.extra_buff_shot) then
		ammo_usage = ammo_extension:current_ammo()
		_get_total_shots = ammo_usage
	end

	if not (not ammo_extension and self.extra_buff_shot or self.infinite_ammo) then
		ammo_extension:use_ammo(ammo_usage)
	end

	self._num_shots_total = _get_total_shots
end

ActionMultiShoot._get_barrel_data = function (self, arg_2_1)
	-- function 2
	local barrels = self.current_action.barrels
	local num = 0

	for i, v in ipairs(barrels) do
		local num_2 = num + v.shot_count

		if not (not (num <= arg_2_1) or arg_2_1 <= num_2) then
			return v
		end

		num = num_2
	end

	return barrels[1]
end

ActionMultiShoot._get_total_shots = function (self)
	-- function 3
	local num = 0
	local barrels = self.current_action.barrels

	for i, v in ipairs(barrels) do
		num = num + v.shot_count
	end

	return num
end

ActionMultiShoot._combine_rotations = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local var_4_0 = Quaternion(Vector3.up(), arg_4_1)
	local var_4_1 = Quaternion(Vector3.right(), arg_4_2)
	local multiply = Quaternion.multiply(arg_4_3, var_4_0)

	return (Quaternion.multiply(multiply, var_4_1))
end

ActionMultiShoot._get_spread_rotation = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local spread_extension = self.spread_extension

	if not spread_extension then
		local _get_barrel_data = self:_get_barrel_data(self._shots_fired)
		local degrees_to_radians = math.degrees_to_radians(_get_barrel_data.yaw)
		local degrees_to_radians_2 = math.degrees_to_radians(_get_barrel_data.pitch)
		local _combine_rotations = self:_combine_rotations(degrees_to_radians, degrees_to_radians_2, arg_5_2)

		return spread_extension:get_target_style_spread(self._shots_fired, arg_5_1, _combine_rotations, arg_5_3, arg_5_4, arg_5_5)
	else
		return arg_5_2
	end
end

ActionMultiShoot._shoot = function (self, arg_6_1, arg_6_2)
	-- function 6
	local current_action = self.current_action
	local unbox = self._fire_position:unbox()
	local unbox_2 = self._fire_rotation:unbox()
	local world = self.world
	local physics_world = self.physics_world
	local _check_buffs = self._check_buffs
	local num_layers_spread = current_action.num_layers_spread

	num_layers_spread = num_layers_spread or 1

	local bullseye = current_action.bullseye

	bullseye = bullseye or false

	local spread_pitch = current_action.spread_pitch

	spread_pitch = spread_pitch or 0.8

	local weapon_unit = self.weapon_unit
	local item_name = self.item_name
	local owner_unit = self.owner_unit
	local is_server = self.is_server

	for i = 1, arg_6_2 do
		self._shots_fired = self._shots_fired + 1

		local _get_spread_rotation = self:_get_spread_rotation(arg_6_1, unbox_2, num_layers_spread, bullseye, spread_pitch)
		local forward = Quaternion.forward(_get_spread_rotation)
		local immediate_raycast_actors = PhysicsWorld.immediate_raycast_actors(physics_world, unbox, forward, current_action.range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")

		if not immediate_raycast_actors then
			local process_projectile_hit = DamageUtils.process_projectile_hit(world, item_name, owner_unit, is_server, immediate_raycast_actors, current_action, forward, _check_buffs, nil, self.shield_users_blocking, self._is_critical_strike, self.power_level)

			if not process_projectile_hit.buffs_checked then
				_check_buffs = not _check_buffs and false
			end

			if not process_projectile_hit.blocked_by_unit then
				self.shield_users_blocking[process_projectile_hit.blocked_by_unit] = true
			end

			local var_6_17 = immediate_raycast_actors[#immediate_raycast_actors][1]

			var_6_17 = var_6_17 or unbox + forward * current_action.range

			set_flow_variable(weapon_unit, "hit_position", var_6_17)
			set_flow_variable(weapon_unit, "fire_position", unbox)
			set_flow_variable(weapon_unit, "fire_direction", forward)
			set_flow_variable(weapon_unit, "trail_life", Vector3.length(var_6_17 - unbox) * 0.1)
			flow_event(weapon_unit, "lua_bullet_trail")
		end
	end

	self._check_buffs = _check_buffs
end

ActionMultiShoot.finish = function (self, arg_7_1)
	-- function 7
	ActionMultiShoot.super.finish(self, arg_7_1)

	local ammo_extension = self.ammo_extension
	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if arg_7_1 ~= "new_interupting_action" then
		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)

		local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func
		local flag

		flag = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(owner_unit, arg_7_1)

		if not ammo_extension and not current_action.reload_when_out_of_ammo and not flag and ammo_extension:ammo_count() ~= 0 or not ammo_extension:can_reload() then
			ammo_extension:start_reload(true)
		end
	end
end
