-- chunkname: @foundation/scripts/util/rectangle.lua

Rectangle = class(Rectangle)

Rectangle.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self.x = arg_1_1
	self.y = arg_1_2
	self.width = arg_1_3
	self.height = arg_1_4
end

Rectangle.split_horizontal = function (self)
	-- function 2
	local num = self.height * 0.5
	local var_2_1 = Rectangle:new(self.x, self.y, self.width, num)
	local var_2_2 = Rectangle:new(self.x, self.y + num, self.width, num)

	return var_2_1, var_2_2
end

Rectangle.split_vertical = function (self)
	-- function 3
	local num = self.width * 0.5
	local var_3_1 = Rectangle:new(self.x, self.y, num, self.height)
	local var_3_2 = Rectangle:new(self.x + num, self.y, num, self.height)

	return var_3_1, var_3_2
end
