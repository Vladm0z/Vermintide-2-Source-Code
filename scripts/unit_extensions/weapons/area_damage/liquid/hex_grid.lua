-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/hex_grid.lua

require("scripts/managers/debug/debug_manager")

HexGrid = class(HexGrid)

function HexGrid.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = Vector3.right()
	local var_1_1 = Vector3.forward()
	local var_1_2 = Vector3.up()
	local var_1_3 = math.tan(math.pi / 3) * 0.5 * arg_1_4
	local var_1_4 = math.pi / 3
	local var_1_5 = math.pi * 2

	arg_1_0._directions = {
		{
			1,
			0,
			angle = 0
		},
		{
			1,
			-1,
			angle = var_1_5 - var_1_4
		},
		{
			0,
			-1,
			angle = var_1_5 - var_1_4 * 2
		},
		{
			-1,
			0,
			angle = var_1_5 - var_1_4 * 3
		},
		{
			-1,
			1,
			angle = var_1_5 - var_1_4 * 4
		},
		{
			0,
			1,
			angle = var_1_5 - var_1_4 * 5
		}
	}

	local var_1_6 = arg_1_1 - var_1_0 * ((arg_1_2 + 1 + arg_1_2 * 0.5) * arg_1_4) - var_1_1 * ((arg_1_2 + 1) * var_1_3) - var_1_2 * (arg_1_3 + 1) * arg_1_5

	arg_1_0._root_position = Vector3Box(var_1_6)
	arg_1_0._x_cell_size = arg_1_4
	arg_1_0._y_cell_size = var_1_3
	arg_1_0._z_cell_size = arg_1_5
	arg_1_0._xy_extents = arg_1_2
	arg_1_0._z_extents = arg_1_3
	arg_1_0._check_player_units = true
end

function HexGrid.directions(arg_2_0)
	return arg_2_0._directions
end

function HexGrid.find_index(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1 - arg_3_0._root_position:unbox()
	local var_3_1 = arg_3_0._x_cell_size
	local var_3_2 = arg_3_0._y_cell_size
	local var_3_3 = arg_3_0._z_cell_size
	local var_3_4 = math.floor(var_3_0.y / var_3_2 + 0.5)
	local var_3_5 = math.floor((var_3_0.x - (var_3_4 - 1) * 0.5 * var_3_1) / var_3_1 + 0.5)
	local var_3_6 = math.floor(var_3_0.z / var_3_3 + 0.5)

	return var_3_5, var_3_4, var_3_6
end

function HexGrid.real_index(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0._xy_extents * 2 + 1
	local var_4_1 = var_4_0 * var_4_0

	return arg_4_1 + (arg_4_2 - 1) * var_4_0 + (arg_4_3 - 1) * var_4_1
end

function HexGrid.ijk(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._xy_extents * 2 + 1
	local var_5_1 = arg_5_1 % var_5_0
	local var_5_2 = (arg_5_1 - var_5_1) / var_5_0
	local var_5_3 = var_5_2 % var_5_0
	local var_5_4 = (var_5_2 - var_5_3) / var_5_0

	return var_5_1, var_5_3 + 1, var_5_4 + 1
end

function HexGrid.is_out_of_bounds(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0._xy_extents * 2 + 1

	return arg_6_1 < 0 or var_6_0 <= arg_6_1 or arg_6_2 < 0 or var_6_0 <= arg_6_2 or arg_6_3 < 0
end

function HexGrid.find_position(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0._root_position:unbox()
	local var_7_1 = arg_7_3 * arg_7_0._z_cell_size
	local var_7_2 = arg_7_2 * arg_7_0._y_cell_size
	local var_7_3 = (0.5 * (arg_7_2 - 1) + arg_7_1) * arg_7_0._x_cell_size

	return var_7_0 + Vector3(var_7_3, var_7_2, var_7_1)
end

function HexGrid.sample_grid(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = QuickDrawerStay

	var_8_0:reset()

	local var_8_1 = arg_8_0._xy_extents
	local var_8_2 = 1
	local var_8_3 = 1
	local var_8_4 = var_8_1 * 2 + 1
	local var_8_5 = var_8_1 * 2 + 1
	local var_8_6 = arg_8_0._root_position:unbox()
	local var_8_7 = var_8_6.x + var_8_1 * arg_8_0._x_cell_size * (1 - arg_8_3)
	local var_8_8 = var_8_6.x + (var_8_1 * (1 + 1 * arg_8_3) + 1) * arg_8_0._x_cell_size
	local var_8_9 = var_8_6.y + var_8_1 * arg_8_0._x_cell_size * (1 - arg_8_3)
	local var_8_10 = var_8_6.y + (var_8_1 * (1 + 1 * arg_8_3) + 1) * arg_8_0._y_cell_size
	local var_8_11 = Math.random

	local function var_8_12(arg_9_0, arg_9_1)
		return arg_9_0 + var_8_11() * (arg_9_1 - arg_9_0)
	end

	local var_8_13 = Color(0, 0, 0)
	local var_8_14 = var_8_4 - var_8_2
	local var_8_15 = var_8_5 - var_8_3
	local var_8_16 = true

	for iter_8_0 = 1, arg_8_1 do
		local var_8_17 = Vector3(var_8_12(var_8_7, var_8_8), var_8_12(var_8_9, var_8_10), arg_8_2)
		local var_8_18, var_8_19, var_8_20 = arg_8_0:find_index(var_8_17)
		local var_8_21

		if var_8_18 < var_8_2 or var_8_4 < var_8_18 or var_8_19 < var_8_3 or var_8_5 < var_8_19 then
			var_8_21 = var_8_16 and var_8_13
		else
			local var_8_22 = var_8_18 - var_8_2
			local var_8_23 = var_8_19 - var_8_3
			local var_8_24 = var_8_22 % 2 == 0 and 125 * var_8_22 / var_8_14 or 125 + 125 * var_8_22 / var_8_14
			local var_8_25 = var_8_23 % 2 == 0 and 125 * var_8_23 / var_8_15 or 125 + 125 * var_8_23 / var_8_15
			local var_8_26 = 0

			var_8_21 = Color(var_8_24, var_8_25, var_8_26)
		end

		if var_8_21 then
			var_8_0:sphere(var_8_17, 0.05, var_8_21)
		end
	end
end
