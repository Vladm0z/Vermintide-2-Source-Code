-- chunkname: @foundation/scripts/util/rectangle.lua

Rectangle = class(Rectangle)

function Rectangle.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.x = arg_1_1
	arg_1_0.y = arg_1_2
	arg_1_0.width = arg_1_3
	arg_1_0.height = arg_1_4
end

function Rectangle.split_horizontal(arg_2_0)
	local var_2_0 = arg_2_0.height * 0.5
	local var_2_1 = Rectangle:new(arg_2_0.x, arg_2_0.y, arg_2_0.width, var_2_0)
	local var_2_2 = Rectangle:new(arg_2_0.x, arg_2_0.y + var_2_0, arg_2_0.width, var_2_0)

	return var_2_1, var_2_2
end

function Rectangle.split_vertical(arg_3_0)
	local var_3_0 = arg_3_0.width * 0.5
	local var_3_1 = Rectangle:new(arg_3_0.x, arg_3_0.y, var_3_0, arg_3_0.height)
	local var_3_2 = Rectangle:new(arg_3_0.x + var_3_0, arg_3_0.y, var_3_0, arg_3_0.height)

	return var_3_1, var_3_2
end
