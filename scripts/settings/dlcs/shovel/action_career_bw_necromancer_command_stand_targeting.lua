-- chunkname: @scripts/settings/dlcs/shovel/action_career_bw_necromancer_command_stand_targeting.lua

require("scripts/settings/profiles/career_constants")

local str = "fx/bw_necromancer_ability_indicator"
local num = 0.35
local num_2 = 11
local num_3 = -10
local num_4 = 0.55
local num_5 = 0.9

ActionCareerBwNecromancerCommandStandTargetingUtility = {}

ActionCareerBwNecromancerCommandStandTargetingUtility.generate_positions = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local flag = arg_1_3 or {}
	local min = math.min(arg_1_2, CareerConstants.bw_necromancer.pets_per_rank)

	if min == 0 then
		table.clear(flag)

		return flag
	end

	local num_2 = 2
	local num_3 = 2
	local axis_angle = Quaternion.axis_angle(Vector3.up(), Quaternion.yaw(arg_1_1))
	local forward = Quaternion.forward(axis_angle)
	local right = Quaternion.right(axis_angle)
	local var_1_7
	local ceil = math.ceil(arg_1_2 / min)

	for i = 1, ceil do
		local min_2 = math.min(arg_1_2 - (i - 1) * min, min)
		local num_6 = (num + num_4) * min_2
		local num_7 = -right * num_6
		local num_8 = right * num_6
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local raycast, var_1_15 = GwNavQueries.raycast(nav_world, arg_1_0, arg_1_0 + num_7)
		local raycast_2, var_1_17 = GwNavQueries.raycast(nav_world, arg_1_0, arg_1_0 + num_8)
		local num_9 = var_1_15 - arg_1_0
		local num_10 = var_1_17 - arg_1_0
		local num_11 = num_7 * 0.5
		local num_12 = num_8 * 0.5
		local num_13

		if Vector3.length_squared(num_10) < Vector3.length_squared(num_12) then
			num_13 = num_10 - num_12

			if not num_13 then
				-- Nothing
			end
		end

		num_13 = Vector3.zero()

		do
			local num_14
		end

		::label_1_0::

		if Vector3.length_squared(num_9) < Vector3.length_squared(num_11) then
			num_14 = num_9 - num_11

			if not num_14 then
				-- Nothing
			end
		end

		num_14 = Vector3.zero()

		::label_1_1::

		local closest_point_on_line = Geometry.closest_point_on_line(arg_1_0 + num_12 + num_14, var_1_15, var_1_17)
		local closest_point_on_line_2 = Geometry.closest_point_on_line(arg_1_0 + num_11 + num_13, var_1_15, closest_point_on_line)
		local num_15 = Vector3.length(closest_point_on_line - closest_point_on_line_2) / min_2

		for j = 1, min_2 do
			local num_16 = closest_point_on_line_2 + right * num_15 * (j - 0.5) - forward * num_5 * (i - 1)
			local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, num_16, num_2, num_3)
			local num_17 = (i - 1) * min + j

			if not pos_on_mesh then
				local num_18 = 3
				local num_19 = 0.5

				pos_on_mesh = GwNavQueries.inside_position_from_outside_position(nav_world, num_16, num_2, num_3, num_18, num_19)
			end

			if not pos_on_mesh then
				flag[num_17] = Vector3Box(pos_on_mesh)
				var_1_7 = var_1_7 or pos_on_mesh
			else
				flag[num_17] = false
			end
		end
	end

	if not var_1_7 then
		table.clear(flag)

		return flag
	end

	for k = 1, arg_1_2 do
		if not flag[k] then
			flag[k] = Vector3Box(var_1_7)
		else
			var_1_7 = flag[k]:unbox()
		end
	end

	for l = arg_1_2 + 1, #flag do
		flag[l] = nil
	end

	return flag
end

ActionCareerBwNecromancerCommandStandTargeting = class(ActionCareerBwNecromancerCommandStandTargeting, ActionBase)

ActionCareerBwNecromancerCommandStandTargeting.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	-- function 2
	ActionCareerBwNecromancerCommandStandTargeting.super.init(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)

	self._ai_navigation_system = Managers.state.entity:system("ai_navigation_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_2_4, "first_person_system")
	self._inventory_extension = ScriptUnit.extension(arg_2_4, "inventory_system")
	self._weapon_extension = ScriptUnit.extension(arg_2_7, "weapon_system")
	self._commander_extension = ScriptUnit.extension(arg_2_4, "ai_commander_system")
	self._world = arg_2_1
	self._owner_unit = arg_2_4
	self._last_valid_spawn_position = Vector3Box()
	self._fp_rotation = QuaternionBox()
	self._decal_diameter_id = World.find_particles_variable(self._world, str, "diameter")

	self._nav_callback = function ()
		-- function 3
		local time = Managers.time:time("game")

		self:_update_targeting(time)
	end
end

ActionCareerBwNecromancerCommandStandTargeting.client_owner_start_action = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_5 = arg_4_5 or {}

	ActionCareerBwNecromancerCommandStandTargeting.super.client_owner_start_action(self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	self._weapon_extension:set_mode(true)

	self._controlled_unit_template = arg_4_1.controlled_unit_template
	self._breed_to_spawn = arg_4_1.breed_to_spawn
	self._spawn_decal_ids = {}

	local var_4_0 = POSITION_LOOKUP[self._owner_unit]

	self._last_valid_spawn_position:store(var_4_0)
	self._ai_navigation_system:add_safe_navigation_callback(self._nav_callback)
end

ActionCareerBwNecromancerCommandStandTargeting.client_owner_post_update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	self._ai_navigation_system:add_safe_navigation_callback(self._nav_callback)
end

ActionCareerBwNecromancerCommandStandTargeting._update_targeting = function (self, arg_6_1)
	-- function 6
	local _update_spawn_positions = self:_update_spawn_positions()
	local count = #_update_spawn_positions
	local _world = self._world
	local _spawn_decal_ids = self._spawn_decal_ids

	for i = 1, count do
		local var_6_4 = _update_spawn_positions[i]
		local var_6_5 = _spawn_decal_ids[i]
		local unbox = var_6_4:unbox()

		if not var_6_5 then
			var_6_5 = World.create_particles(_world, str, unbox)
			_spawn_decal_ids[i] = var_6_5

			World.set_particles_variable(_world, var_6_5, self._decal_diameter_id, Vector3(num * 2, num * 2, 1))
		end

		World.move_particles(_world, var_6_5, unbox)
	end

	for j = count + 1, #_spawn_decal_ids do
		local var_6_7 = _spawn_decal_ids[j]

		if not var_6_7 then
			World.destroy_particles(_world, var_6_7)
		end

		_spawn_decal_ids[j] = nil
	end
end

ActionCareerBwNecromancerCommandStandTargeting._update_spawn_positions = function (self)
	-- function 7
	local _commander_extension = self._commander_extension
	local keys = table.keys(_commander_extension:get_controlled_units())

	table.array_remove_if(keys, function (arg_8_0)
		-- function 8
		return Unit.get_data(arg_8_0, "breed").name ~= "pet_skeleton_armored" or _commander_extension:command_state(arg_8_0) ~= CommandStates.Following
	end)

	local count = #keys
	local var_7_3
	local _get_projectile_position, var_7_5 = self:_get_projectile_position(num_2)

	if not _get_projectile_position then
		var_7_3 = var_7_5

		self._last_valid_spawn_position:store(var_7_5)
	else
		var_7_3 = self._last_valid_spawn_position:unbox()
	end

	local current_rotation = self._first_person_extension:current_rotation()
	local axis_angle = Quaternion.axis_angle(Vector3.up(), Quaternion.yaw(current_rotation))

	self._fp_rotation:store(axis_angle)

	self._spawn_positions = ActionCareerBwNecromancerCommandStandTargetingUtility.generate_positions(var_7_3, axis_angle, count, self._spawn_positions)

	return self._spawn_positions
end

ActionCareerBwNecromancerCommandStandTargeting._get_projectile_position = function (self)
	-- function 9
	local _world = self._world
	local get_data = World.get_data(_world, "physics_world")
	local str = "filter_adept_teleport"
	local _get_first_person_position_direction, var_9_4 = self:_get_first_person_position_direction()
	local num = var_9_4 * num_2
	local var_9_6 = Vector3(0, 0, num_3)
	local ground_target, var_9_8 = WeaponHelper:ground_target(get_data, self._owner_unit, _get_first_person_position_direction, num, var_9_6, str)

	if not ground_target then
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local num_4 = 1
		local num_5 = 1
		local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_9_8, num_4, num_5)

		if not pos_on_mesh then
			local num_6 = 3
			local num_7 = 0.5

			pos_on_mesh = GwNavQueries.inside_position_from_outside_position(nav_world, var_9_8, num_4, num_5, num_6, num_7)
		end

		ground_target = not not pos_on_mesh
		var_9_8 = pos_on_mesh
	end

	return ground_target, var_9_8
end

ActionCareerBwNecromancerCommandStandTargeting._get_first_person_position_direction = function (self)
	-- function 10
	local _first_person_extension = self._first_person_extension
	local current_position = _first_person_extension:current_position()
	local current_rotation = _first_person_extension:current_rotation()
	local rad = math.rad(45)
	local rad_2 = math.rad(12.5)
	local yaw = Quaternion.yaw(current_rotation)
	local clamp = math.clamp(Quaternion.pitch(current_rotation), -rad, rad_2)
	local var_10_7 = Quaternion(Vector3.up(), yaw)
	local var_10_8 = Quaternion(Vector3.right(), clamp)
	local multiply = Quaternion.multiply(var_10_7, var_10_8)
	local forward = Quaternion.forward(multiply)

	return current_position, forward
end

ActionCareerBwNecromancerCommandStandTargeting.finish = function (self, arg_11_1)
	-- function 11
	local _world = self._world
	local _spawn_decal_ids = self._spawn_decal_ids

	if not self._spawn_positions then
		return nil
	end

	for i = 1, #_spawn_decal_ids do
		if not _spawn_decal_ids[i] then
			World.destroy_particles(_world, _spawn_decal_ids[i])

			_spawn_decal_ids[i] = nil
		end
	end

	if arg_11_1 == "new_interupting_action" then
		return {
			target_center = self._last_valid_spawn_position,
			fp_rotation = self._fp_rotation
		}
	end

	return nil
end
