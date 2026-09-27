-- chunkname: @scripts/unit_extensions/generic/scale_unit_extension.lua

ScaleUnitExtension = class(ScaleUnitExtension)

ScaleUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local time = Managers.time:time("game")

	self.start_size = arg_1_3.start_size

	local end_size = arg_1_3.end_size

	self.duration = arg_1_3.duration
	self.full_scale = end_size - self.start_size
	self.timer = 0
end

ScaleUnitExtension.setup = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self.start_size = arg_2_1 or self.start_size
	self.full_scale = arg_2_2 - self.start_size
	self.duration = arg_2_3
	self.timer = 0
end

ScaleUnitExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local timer = self.timer

	if timer < self.duration then
		local clamp = math.clamp(timer / self.duration, 0, 1)
		local num = self.start_size + math.easeCubic(clamp) * self.full_scale
		local var_3_3 = Vector3(1, 1, num)

		Unit.set_local_scale(arg_3_1, 0, var_3_3)

		self.timer = self.timer + arg_3_3
	end
end

ScaleUnitExtension.scaling_complete = function (self)
	-- function 4
	return self.timer >= self.duration
end

ScaleUnitExtension.despawn = function (arg_5_0)
	-- function 5
	return
end
