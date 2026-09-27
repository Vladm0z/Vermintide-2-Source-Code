-- chunkname: @scripts/utils/ik_chain.lua

IkChain = class(IkChain)

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	for i = 1, arg_1_2 do
		arg_1_1[i] = self[i]:unbox()
	end

	return arg_1_1
end

local function fn_2(self, arg_2_1, arg_2_2)
	-- function 2
	for i = 1, arg_2_2 do
		arg_2_1[i]:store(self[i])
	end
end

IkChain.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	self._nodes = {}

	local tbl = {}
	local num = 0
	local tbl_2 = {}

	for i = 1, #arg_3_1 - 1 do
		local length = Vector3.length(arg_3_1[i] - arg_3_1[i + 1])

		tbl[i] = length
		num = num + length
	end

	for j = 1, #arg_3_1 do
		tbl_2[j] = Vector3Box(arg_3_1[j])
	end

	self.n = #arg_3_1
	self.tolerance = arg_3_4 or 0.1
	self.target_pos = Vector3Box(arg_3_3)
	self.aim_pos = Vector3Box(arg_3_1[self.n])
	self.joints = tbl_2
	self.lengths = tbl
	self.origin_pos = Vector3Box(arg_3_1[1])
	self.totallength = num

	if not arg_3_5 then
		self.constrain_angle = arg_3_5
		self.dot_constrain = math.cos(arg_3_5)
	end
end

IkChain.set_origin_pos = function (self, arg_4_1)
	-- function 4
	self.origin_pos:store(arg_4_1)
end

IkChain.set_target_pos = function (self, arg_5_1, arg_5_2)
	-- function 5
	self.target_pos:store(arg_5_1)

	self.acc = arg_5_2 or 1
end

IkChain.set_whip = function (self, arg_6_1)
	-- function 6
	self.whip_angle_velocity = arg_6_1
end

IkChain.update_whip = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local num = 1
	local num_2 = 2
	local axis_angle = Quaternion.axis_angle(Vector3.up(), arg_7_3 % 6.28)
	local var_7_3 = arg_7_1[num]
	local num_3 = arg_7_1[num_2] - var_7_3

	arg_7_1[num_2] = var_7_3 + Quaternion.rotate(axis_angle, num_3)

	QuickDrawer:line(arg_7_1[num], arg_7_1[num_2], Color(20, 255, 175))
end

IkChain.debug_draw = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0

	if not self.constrain_angle then
		var_8_0 = Color(120, 0, 120)

		if not var_8_0 then
			-- Nothing
		end
	end

	var_8_0 = Color(120, 255, 0)

	::label_8_0::

	local var_8_1 = Color(0, 155, 255)

	for i = 1, arg_8_2 - 1 do
		QuickDrawer:line(arg_8_1[i], arg_8_1[i + 1], var_8_0)
		QuickDrawer:sphere(arg_8_1[i], 0.05 + i * 0.01, var_8_1)
	end

	QuickDrawer:sphere(arg_8_1[arg_8_2], 0.05, var_8_1)
	QuickDrawer:sphere(self.target_pos:unbox(), 0.1, Color(255, 45, 0))
	QuickDrawer:sphere(self.aim_pos:unbox(), 0.095, Color(255, 0, 200))
end

IkChain.backward = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	arg_9_1[arg_9_3] = arg_9_4

	for i = arg_9_3 - 1, 1, -1 do
		local num = arg_9_1[i + 1] - arg_9_1[i]
		local num_2 = arg_9_2[i] / Vector3.length(num)

		arg_9_1[i] = (1 - num_2) * arg_9_1[i + 1] + num_2 * arg_9_1[i]
	end
end

IkChain.forward = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	arg_10_1[1] = arg_10_4

	for i = 1, arg_10_3 - 1 do
		local num = arg_10_1[i + 1] - arg_10_1[i]
		local num_2 = arg_10_2[i] / Vector3.length(num)
		local num_3 = (1 - num_2) * arg_10_1[i] + num_2 * arg_10_1[i + 1]

		arg_10_1[i + 1] = num_3
	end
end

local num = 0.7
local acos = math.acos(num)

IkChain.forward_constrained = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local dot_constrain = self.dot_constrain
	local constrain_angle = self.constrain_angle
	local up = Vector3.up()

	arg_11_1[1] = arg_11_4

	local normalize = Vector3.normalize(arg_11_1[2] - arg_11_4)

	for i = 1, arg_11_3 - 1 do
		local num = arg_11_1[i + 1] - arg_11_1[i]
		local num_2 = arg_11_2[i] / Vector3.length(num)
		local num_3 = (1 - num_2) * arg_11_1[i] + num_2 * arg_11_1[i + 1]
		local normalize_2 = Vector3.normalize(num_3 - arg_11_1[i])

		if dot_constrain < Vector3.dot(normalize, normalize_2) then
			arg_11_1[i + 1] = num_3
		else
			local cross = Vector3.cross(normalize, normalize_2)
			local var_11_9 = Quaternion(cross, constrain_angle)
			local rotate = Quaternion.rotate(var_11_9, normalize)

			arg_11_1[i + 1] = arg_11_1[i] + rotate * arg_11_2[i]
		end

		normalize = Vector3.normalize(arg_11_1[i + 1] - arg_11_1[i])
	end
end

local tbl = {}

IkChain.solve = function (self, arg_12_1, arg_12_2)
	-- function 12
	local unbox = self.target_pos:unbox()
	local unbox_2 = self.aim_pos:unbox()
	local num = unbox - unbox_2
	local acc = self.acc

	acc = acc or 1

	local num_2 = unbox_2 + num * acc * arg_12_2

	self.aim_pos:store(num_2)

	local unbox_3 = self.origin_pos:unbox()
	local n = self.n
	local var_12_7 = fn(self.joints, tbl, n)

	if not self.whip_angle_velocity then
		self:update_whip(var_12_7, self.whip_angle_velocity, arg_12_1, arg_12_2)
	end

	local lengths = self.lengths
	local num_3 = 0

	if Vector3.length(var_12_7[1] - num_2) > self.totallength then
		for i = 1, n - 1 do
			local length = Vector3.length(num_2 - var_12_7[i])
			local num_4 = lengths[i] / length

			var_12_7[i + 1] = (1 - num_4) * var_12_7[i] + num_4 * num_2
		end
	else
		local length_2 = Vector3.length(var_12_7[n] - num_2)

		while length_2 > self.tolerance do
			self:backward(var_12_7, lengths, n, num_2)

			if not self.constrain_angle then
				self:forward_constrained(var_12_7, lengths, n, unbox_3)
			else
				self:forward(var_12_7, lengths, n, unbox_3)
			end

			length_2 = Vector3.length(var_12_7[n] - num_2)
			num_3 = num_3 + 1

			if num_3 > 10 then
				break
			end
		end
	end

	fn_2(var_12_7, self.joints, n)
	self:debug_draw(var_12_7, n)
	Debug.text("Solving tentacle: %d iterations, %d joints", num_3, self.n)
end

IkChain.solve_dragging = function (self, arg_13_1, arg_13_2)
	-- function 13
	local unbox = self.target_pos:unbox()
	local unbox_2 = self.aim_pos:unbox()
	local num = unbox - unbox_2
	local acc = self.acc

	acc = acc or 1

	local num_2 = unbox_2 + num * acc * arg_13_2

	self.aim_pos:store(num_2)

	local unbox_3 = self.origin_pos:unbox()
	local n = self.n
	local var_13_7 = fn(self.joints, tbl, n)
	local lengths = self.lengths
	local num_3 = 0

	if Vector3.length(var_13_7[1] - num_2) > self.totallength then
		for i = 1, n - 1 do
			local length = Vector3.length(num_2 - var_13_7[i])
			local num_4 = lengths[i] / length

			var_13_7[i + 1] = (1 - num_4) * var_13_7[i] + num_4 * num_2
		end
	else
		self:backward(var_13_7, lengths, n, num_2)
	end

	fn_2(var_13_7, self.joints, n)
	self:debug_draw(var_13_7, n)
	Debug.text("Solving tentacle dragging: %d iterations, %d joints", num_3, self.n)
end
