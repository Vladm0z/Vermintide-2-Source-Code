-- chunkname: @scripts/ui/views/hero_view/loot_crates_previewer.lua

LootCratesPreviewer = class(LootCratesPreviewer)

LootCratesPreviewer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	self.background_world = arg_1_5
	self.background_viewport = arg_1_6
	self.spawn_positions = arg_1_3
	self.end_positions = arg_1_4
	self.units = arg_1_2
	self._rewards = arg_1_1
	self._spawned_units = self:spawn_units(arg_1_2)

	local tbl = {}

	for i, v in ipairs(arg_1_1) do
		local key = v.key

		tbl[self._spawned_units[i]] = key
	end

	self._item_key_by_unit = tbl
end

LootCratesPreviewer.destroy = function (self)
	-- function 2
	self:_destroy_units()
end

LootCratesPreviewer._destroy_units = function (self)
	-- function 3
	local background_world = self.background_world
	local _spawned_units = self._spawned_units

	if not _spawned_units then
		for i, v in ipairs(_spawned_units) do
			World.destroy_unit(background_world, v)
		end
	end

	self.units_spawned = nil
end

LootCratesPreviewer.update = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	return
end

LootCratesPreviewer.post_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._entry_animation_complete then
		self:_animate_entry_positions(arg_5_1, arg_5_2)
	end
end

LootCratesPreviewer._animate_entry_positions = function (self, arg_6_1, arg_6_2)
	-- function 6
	local spawn_positions = self.spawn_positions
	local end_positions = self.end_positions
	local num = 1
	local _entry_progress = self._entry_progress

	_entry_progress = _entry_progress or 0

	local min = math.min(_entry_progress + arg_6_1 * num, 1)
	local easeInCubic = math.easeInCubic(min)
	local background_world = self.background_world
	local _spawned_units = self._spawned_units
	local flag = true

	for i, v in ipairs(_spawned_units) do
		local var_6_9 = end_positions[i]
		local var_6_10 = spawn_positions[i]
		local local_position = Unit.local_position(v, 0)
		local num_2 = var_6_10[3] - var_6_9[3]
		local num_3 = local_position[3] - var_6_9[3]

		local_position[3] = var_6_10[3] - easeInCubic * num_2

		Unit.set_local_position(v, 0, local_position)
	end

	if min == 1 then
		self._entry_animation_complete = true
	end

	self._entry_progress = min
end

LootCratesPreviewer._trigger_unit_flow_event = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	if not arg_7_1 and not Unit.alive(arg_7_1) then
		Unit.flow_event(arg_7_1, arg_7_2)
	end
end

LootCratesPreviewer._get_world = function (self)
	-- function 8
	return self.background_world, self.background_viewport
end

LootCratesPreviewer._get_camera_position = function (self)
	-- function 9
	local background_viewport = self.background_viewport
	local camera = ScriptViewport.camera(background_viewport)

	return ScriptCamera.position(camera)
end

LootCratesPreviewer._get_camera_rotation = function (self)
	-- function 10
	local background_viewport = self.background_viewport
	local camera = ScriptViewport.camera(background_viewport)

	return ScriptCamera.rotation(camera)
end

LootCratesPreviewer.get_units = function (self)
	-- function 11
	return self._spawned_units
end

LootCratesPreviewer.has_units = function (self)
	-- function 12
	local _spawned_units = self._spawned_units

	_spawned_units = not _spawned_units and #self._spawned_units > 0

	return _spawned_units
end

LootCratesPreviewer.get_item_key_by_unit = function (self, arg_13_1)
	-- function 13
	return self._item_key_by_unit[arg_13_1]
end

LootCratesPreviewer.delete_unit = function (self, arg_14_1)
	-- function 14
	local background_world = self.background_world
	local _spawned_units = self._spawned_units

	for i, v in ipairs(_spawned_units) do
		if arg_14_1 == v then
			table.remove(_spawned_units, i)
			World.destroy_unit(background_world, v)

			return
		end
	end
end

LootCratesPreviewer.spawn_units = function (self, arg_15_1)
	-- function 15
	local tbl = {}
	local spawn_positions = self.spawn_positions

	if not arg_15_1 then
		local tbl_2 = {}
		local background_world = self.background_world

		for i = 1, #arg_15_1 do
			local var_15_4 = spawn_positions[i]
			local var_15_5 = arg_15_1[i]
			local spawn_unit = World.spawn_unit(background_world, var_15_5)
			local _get_camera_rotation = self:_get_camera_rotation()
			local forward = Quaternion.forward(_get_camera_rotation)
			local look = Quaternion.look(forward, Vector3.up())
			local axis_angle = Quaternion.axis_angle(Vector3.up(), math.pi * 1)
			local multiply = Quaternion.multiply(look, axis_angle)
			local _get_camera_position = self:_get_camera_position()
			local var_15_13 = Vector3(var_15_4[1], var_15_4[2], var_15_4[3])
			local box, var_15_15 = Unit.box(spawn_unit)
			local num = Matrix4x4.translation(box) - Unit.world_position(spawn_unit, 0)

			if not var_15_15 then
				local num_2 = 0.3
				local num_3 = 0

				if num_3 < var_15_15.x then
					num_3 = var_15_15.x
				end

				if num_3 < var_15_15.z then
					num_3 = var_15_15.z
				end

				if num_3 < var_15_15.y then
					num_3 = var_15_15.y
				end

				if num_2 < num_3 then
					local num_4 = 1 - (num_3 - num_2) / num_3
					local var_15_20 = Vector3(num_4, num_4, num_4)

					Unit.set_local_scale(spawn_unit, 0, var_15_20)

					num = num * num_4
				end

				local num_5 = var_15_13 - num

				Unit.set_local_position(spawn_unit, 0, num_5)
			end

			Unit.set_unit_visibility(spawn_unit, true)

			tbl[#tbl + 1] = spawn_unit
		end

		self.units_spawned = true
	end

	return tbl
end

LootCratesPreviewer._enable_units_visibility = function (self)
	-- function 16
	local _spawned_units = self._spawned_units

	for i, v in ipairs(_spawned_units) do
		if not v and not Unit.alive(v) then
			Unit.set_unit_visibility(v, true)

			local str = "lua_presentation"

			self:_trigger_unit_flow_event(v, str)
		end
	end
end
