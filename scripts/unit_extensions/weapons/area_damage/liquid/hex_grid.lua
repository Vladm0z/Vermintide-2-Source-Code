-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/hex_grid.lua

require("scripts/managers/debug/debug_manager")

HexGrid = class(HexGrid)

HexGrid.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local right = Vector3.right()
	local forward = Vector3.forward()
	local up = Vector3.up()
	local num = math.tan(math.pi / 3) * 0.5 * arg_1_4
	local num_2 = math.pi / 3
	local num_3 = math.pi * 2

	self._directions = {
		{
			1,
			0,
			angle = 0
		},
		{
			1,
			-1,
			angle = num_3 - num_2
		},
		{
			0,
			-1,
			angle = num_3 - num_2 * 2
		},
		{
			-1,
			0,
			angle = num_3 - num_2 * 3
		},
		{
			-1,
			1,
			angle = num_3 - num_2 * 4
		},
		{
			0,
			1,
			angle = num_3 - num_2 * 5
		}
	}

	local num_4 = arg_1_1 - right * ((arg_1_2 + 1 + arg_1_2 * 0.5) * arg_1_4) - forward * ((arg_1_2 + 1) * num) - up * (arg_1_3 + 1) * arg_1_5

	self._root_position = Vector3Box(num_4)
	self._x_cell_size = arg_1_4
	self._y_cell_size = num
	self._z_cell_size = arg_1_5
	self._xy_extents = arg_1_2
	self._z_extents = arg_1_3
	self._check_player_units = true
end

HexGrid.directions = function (self)
	-- function 2
	return self._directions
end

HexGrid.find_index = function (self, arg_3_1)
	-- function 3
	local num = arg_3_1 - self._root_position:unbox()
	local _x_cell_size = self._x_cell_size
	local _y_cell_size = self._y_cell_size
	local _z_cell_size = self._z_cell_size
	local floor = math.floor(num.y / _y_cell_size + 0.5)
	local floor_2 = math.floor((num.x - (floor - 1) * 0.5 * _x_cell_size) / _x_cell_size + 0.5)
	local floor_3 = math.floor(num.z / _z_cell_size + 0.5)

	return floor_2, floor, floor_3
end

HexGrid.real_index = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local num = self._xy_extents * 2 + 1
	local num_2 = num * num

	return arg_4_1 + (arg_4_2 - 1) * num + (arg_4_3 - 1) * num_2
end

HexGrid.ijk = function (self, arg_5_1)
	-- function 5
	local num = self._xy_extents * 2 + 1
	local num_2 = arg_5_1 % num
	local num_3 = (arg_5_1 - num_2) / num
	local num_4 = num_3 % num
	local num_5 = (num_3 - num_4) / num

	return num_2, num_4 + 1, num_5 + 1
end

HexGrid.is_out_of_bounds = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local num = self._xy_extents * 2 + 1

	return arg_6_1 < 0 or num <= arg_6_1 or arg_6_2 < 0 or num <= arg_6_2 or arg_6_3 < 0
end

HexGrid.find_position = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local unbox = self._root_position:unbox()
	local num = arg_7_3 * self._z_cell_size
	local num_2 = arg_7_2 * self._y_cell_size
	local num_3 = (0.5 * (arg_7_2 - 1) + arg_7_1) * self._x_cell_size

	return unbox + Vector3(num_3, num_2, num)
end

HexGrid.sample_grid = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local QuickDrawerStay = QuickDrawerStay

	QuickDrawerStay:reset()

	local _xy_extents = self._xy_extents
	local num = 1
	local num_2 = 1
	local num_3 = _xy_extents * 2 + 1
	local num_4 = _xy_extents * 2 + 1
	local unbox = self._root_position:unbox()
	local num_5 = unbox.x + _xy_extents * self._x_cell_size * (1 - arg_8_3)
	local num_6 = unbox.x + (_xy_extents * (1 + 1 * arg_8_3) + 1) * self._x_cell_size
	local num_7 = unbox.y + _xy_extents * self._x_cell_size * (1 - arg_8_3)
	local num_8 = unbox.y + (_xy_extents * (1 + 1 * arg_8_3) + 1) * self._y_cell_size
	local random = Math.random

	local function fn(arg_9_0, arg_9_1)
		-- function 9
		return arg_9_0 + random() * (arg_9_1 - arg_9_0)
	end

	local var_8_13 = Color(0, 0, 0)
	local num_9 = num_3 - num
	local num_10 = num_4 - num_2
	local flag = true

	for i = 1, arg_8_1 do
		local var_8_17 = Vector3(fn(num_5, num_6), fn(num_7, num_8), arg_8_2)
		local find_index, var_8_19, var_8_20 = self:find_index(var_8_17)
		local var_8_21

		if not (find_index < num or num_3 < find_index or var_8_19 < num_2 or not (num_4 < var_8_19)) then
			var_8_21 = not flag and var_8_13
		else
			local num_11 = find_index - num
			local num_12 = var_8_19 - num_2
			local num_13

			if num_11 % 2 == 0 then
				num_13 = 125 * num_11 / num_9

				if not num_13 then
					-- Nothing
				end
			end

			num_13 = 125 + 125 * num_11 / num_9

			do
				local num_14
			end

			::label_8_0::

			if num_12 % 2 == 0 then
				num_14 = 125 * num_12 / num_10

				if not num_14 then
					-- Nothing
				end
			end

			num_14 = 125 + 125 * num_12 / num_10

			::label_8_1::

			local num_15 = 0

			var_8_21 = Color(num_13, num_14, num_15)
		end

		if not var_8_21 then
			QuickDrawerStay:sphere(var_8_17, 0.05, var_8_21)
		end
	end
end
