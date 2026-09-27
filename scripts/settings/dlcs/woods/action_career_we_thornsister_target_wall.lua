-- chunkname: @scripts/settings/dlcs/woods/action_career_we_thornsister_target_wall.lua

ActionCareerWEThornsisterTargetWall = class(ActionCareerWEThornsisterTargetWall, ActionBase)

local num = 10
local num_2 = 1.5
local str = "filter_geiser_check"
local str_2 = "units/decals/decal_thorn_sister_wall_target"
local num_3 = 0.15
local num_4 = 0.15
local num_5 = 0.3
local num_6 = 0.5
local num_7 = 0.9 + num_5
local enum = table.enum("linear", "radial")

ActionCareerWEThornsisterTargetWall.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerWEThornsisterTargetWall.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	self.talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
	self._inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	self._weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self._decal_unit = nil
	self._unit_spawner = Managers.state.unit_spawner
	self._target_pos = Vector3Box()
	self._target_rot = QuaternionBox()
	self._segment_positions = {
		{
			num_segments = 0
		},
		{
			num_segments = 0
		}
	}
	self._valid_segment_positions_idx = 0
	self._current_segment_positions_idx = 1
	self._num_segments = 0
	self._max_segments = 0
	self._wall_left_offset = 0
	self._wall_right_offset = 0
	self._wall_shape = enum.linear
end

ActionCareerWEThornsisterTargetWall.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}

	ActionCareerWEThornsisterTargetWall.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)

	self._valid_segment_positions_idx = 0
	self._current_segment_positions_idx = 1

	self._weapon_extension:set_mode(false)

	self._target_sim_gravity = arg_2_1.target_sim_gravity
	self._target_sim_speed = arg_2_1.target_sim_speed
	self._target_width = arg_2_1.target_width
	self._target_thickness = arg_2_1.target_thickness
	self._vertical_rotation = arg_2_1.vertical_rotation
	self._wall_shape = enum.linear

	if not self.talent_extension:has_talent("kerillian_thorn_sister_debuff_wall") then
		self._target_thickness = 5
		self._target_width = 5
		self._wall_shape = enum.radial
		self._num_segmetns_to_check = 3
		self._radial_center_offset = 0.5
		self._bot_target_unit = true
	elseif not self.talent_extension:has_talent("kerillian_thorn_sister_tanky_wall") then
		self._target_width = 8

		local num = self._target_thickness / 2

		self._num_segmetns_to_check = math.floor(self._target_width / num)
		self._bot_target_unit = false
	else
		local num_2 = self._target_thickness / 2

		self._num_segmetns_to_check = math.floor(self._target_width / num_2)
		self._bot_target_unit = false
	end

	local _max_segments = self._max_segments
	local _num_segmetns_to_check = self._num_segmetns_to_check

	if _max_segments < _num_segmetns_to_check then
		local _segment_positions = self._segment_positions

		for i = _max_segments, _num_segmetns_to_check do
			for j = 1, 2 do
				_segment_positions[j][i + 1] = Vector3Box()
			end
		end

		self._max_segments = _num_segmetns_to_check
	end

	self:_update_targeting()
end

ActionCareerWEThornsisterTargetWall.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	self:_update_targeting()
end

ActionCareerWEThornsisterTargetWall._update_targeting = function (self)
	-- function 4
	local get_projectile_start_position_rotation, var_4_1 = self._first_person_extension:get_projectile_start_position_rotation()
	local right

	if not self._vertical_rotation then
		right = Quaternion.right

		if not right then
			-- Nothing
		end
	end

	right = Quaternion.forward

	::label_4_0::

	local flat = Vector3.flat(right(var_4_1))
	local look = Quaternion.look(flat, Vector3.up())
	local num_3 = Quaternion.forward(var_4_1) * self._target_sim_speed
	local var_4_6 = Vector3(0, 0, self._target_sim_gravity)
	local var_4_7
	local var_4_8

	if not self.is_bot then
		var_4_7 = true

		local var_4_9 = BLACKBOARDS[self.owner_unit]
		local target_unit = var_4_9.target_unit

		if not self._bot_target_unit and not ALIVE[target_unit] then
			var_4_8 = POSITION_LOOKUP[target_unit]
		else
			var_4_8 = var_4_9.activate_ability_data.aim_position:unbox()
		end
	else
		var_4_7, var_4_8 = WeaponHelper:ballistic_raycast(self.physics_world, num, num_2, get_projectile_start_position_rotation, num_3, var_4_6, str)
	end

	if not var_4_7 then
		local var_4_11
		local var_4_12
		local var_4_13

		if self._wall_shape == enum.radial then
			var_4_11, var_4_12, var_4_13 = self:_check_wall_radial(var_4_8, look, self._target_width, self._target_thickness)
		else
			var_4_11, var_4_12, var_4_13 = self:_check_wall_linear(var_4_8, look, self._target_width, self._target_thickness)
		end

		if not var_4_11 then
			self._target_pos:store(var_4_8)
			self._target_rot:store(look)

			self._valid_segment_positions_idx = self._current_segment_positions_idx
			self._current_segment_positions_idx = self._current_segment_positions_idx % 2 + 1
			self._wall_right_offset = var_4_12
			self._wall_left_offset = var_4_13

			self._weapon_extension:set_mode(true)
		end
	end

	if not (self._decal_unit or not (self._valid_segment_positions_idx > 0) or self.is_bot) then
		self._decal_unit = self._unit_spawner:spawn_local_unit(str_2)
	end

	if not self._decal_unit then
		local num_4 = self._target_thickness * 0.5
		local num_5 = self._wall_left_offset * 0.5
		local num_6 = self._wall_right_offset * 0.5
		local num_7 = Quaternion.right(look) * ((num_6 - num_5) * 0.5)
		local num_8 = self._target_pos:unbox() + num_7
		local unbox = self._target_rot:unbox()

		Unit.set_local_position(self._decal_unit, 0, num_8)
		Unit.set_local_rotation(self._decal_unit, 0, unbox)

		local var_4_20

		if self._wall_shape == enum.radial then
			var_4_20 = self._target_width * 0.5
		else
			var_4_20 = self._target_width * 0.5 + num_4 * (num_5 + num_6 + 1)
		end

		Unit.set_local_scale(self._decal_unit, 0, Vector3(var_4_20, num_4, 3))
	end
end

ActionCareerWEThornsisterTargetWall.finish = function (self, arg_5_1)
	-- function 5
	if not self._decal_unit then
		self._unit_spawner:mark_for_deletion(self._decal_unit)

		self._decal_unit = nil
	end

	if arg_5_1 == "new_interupting_action" then
		if self._valid_segment_positions_idx > 0 then
			self._weapon_extension:set_mode(true)

			return {
				position = self._target_pos,
				rotation = self._target_rot,
				segments = self._segment_positions[self._valid_segment_positions_idx],
				num_segments = self._segment_positions[self._valid_segment_positions_idx].num_segments
			}
		end
	else
		self._inventory_extension:wield_previous_non_level_slot()
	end

	return nil
end

ActionCareerWEThornsisterTargetWall._check_wall_linear = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not Network.game_session() then
		local num = arg_6_3 / 2
		local num_2 = arg_6_4 / 2
		local _num_segmetns_to_check = self._num_segmetns_to_check
		local floor = math.floor(_num_segmetns_to_check / 2)
		local var_6_4 = self._segment_positions[self._current_segment_positions_idx]
		local forward = Quaternion.forward(arg_6_2)
		local right = Quaternion.right(arg_6_2)
		local num_3 = right * num_2
		local num_4 = arg_6_1 - right * (num - num_2) - num_3 * 0.5
		local num_5 = 0
		local var_6_10
		local num_6 = 0

		for i = floor, _num_segmetns_to_check - 1 do
			local num_7 = num_4 + num_3 * i

			var_6_10 = self:_check_segment(var_6_10, num_7, forward)

			if not var_6_10 then
				num_5 = num_5 + 1

				var_6_4[num_5]:store(var_6_10)
			else
				num_6 = i - _num_segmetns_to_check

				break
			end
		end

		local var_6_13
		local num_8 = 0

		for j = floor - 1, 0, -1 do
			local num_9 = num_4 + num_3 * j

			var_6_13 = self:_check_segment(var_6_13, num_9, forward)

			if not var_6_13 then
				num_5 = num_5 + 1

				var_6_4[num_5]:store(var_6_13)
			else
				num_8 = -j - 1

				break
			end
		end

		var_6_4.num_segments = num_5

		return num_5 > 0, num_6, num_8
	end

	return nil
end

ActionCareerWEThornsisterTargetWall._check_wall_radial = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if not Network.game_session() then
		local num = arg_7_3 / 2
		local num_2 = arg_7_4 / 2
		local _num_segmetns_to_check = self._num_segmetns_to_check
		local floor = math.floor(_num_segmetns_to_check / 2)
		local var_7_4 = self._segment_positions[self._current_segment_positions_idx]
		local forward = Quaternion.forward(arg_7_2)
		local num_3 = 2 * math.pi / _num_segmetns_to_check
		local num_4 = forward * self._radial_center_offset
		local num_5 = 0

		for i = 1, _num_segmetns_to_check do
			local num_6 = arg_7_1 + Quaternion.rotate(Quaternion(Vector3.up(), num_3 * i), num_4)
			local _check_segment = self:_check_segment(arg_7_1, num_6, forward)

			if not _check_segment then
				num_5 = num_5 + 1

				var_7_4[num_5]:store(_check_segment)
			end
		end

		var_7_4.num_segments = num_5

		return num_5 > 0, 0, 0
	end

	return nil
end

ActionCareerWEThornsisterTargetWall._check_segment = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not arg_8_2 then
		local physics_world = self.physics_world
		local var_8_1 = arg_8_2

		if not arg_8_1 then
			var_8_1.z = arg_8_1.z + num_6
		else
			var_8_1.z = arg_8_2.z + num_6
		end

		local down = Vector3.down()
		local num = 2 * num_6
		local immediate_raycast, var_8_5, var_8_6 = PhysicsWorld.immediate_raycast(physics_world, var_8_1, down, num, "closest", "collision_filter", "filter_player_mover")

		if not immediate_raycast then
			if not (not arg_8_1 and not (math.abs(var_8_5.z - arg_8_1.z) > num_6)) then
				return false
			end

			local num_2 = 0
			local num_8 = var_8_5 + Vector3.up() * num_7
			local var_8_9 = Vector3(num_4, num_3, num_5)
			local look = Quaternion.look(arg_8_3, Vector3.up())

			if not arg_8_1 then
				local num_9 = arg_8_1 + Vector3.up() * num_7
				local linear_obb_sweep = PhysicsWorld.linear_obb_sweep(physics_world, num_9, num_8, var_8_9, look, 5, "collision_filter", "filter_player_mover", "report_initial_overlap")

				num_2 = not linear_obb_sweep and #linear_obb_sweep and 0
			else
				local var_8_13
				local immediate_overlap

				immediate_overlap, num_2 = PhysicsWorld.immediate_overlap(physics_world, "position", num_8, "rotation", look, "size", var_8_9, "shape", "oobb", "collision_filter", "filter_player_mover")
			end

			if num_2 > 0 then
				return false
			end

			return var_8_5
		end
	end

	return false
end
