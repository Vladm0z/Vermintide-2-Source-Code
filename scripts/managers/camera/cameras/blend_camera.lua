-- chunkname: @scripts/managers/camera/cameras/blend_camera.lua

require("scripts/managers/camera/cameras/base_camera")

BlendCamera = class(BlendCamera, BaseCamera)

BlendCamera.init = function (self, arg_1_1)
	-- function 1
	BlendCamera.super.init(self, arg_1_1)

	self._offset_position = Vector3(0, 0, 0)
	self._blend_setups = {}
	self._blend_functions = {
		match_2d = function (self, arg_2_1)
			-- function 2
			local var_2_0 = arg_2_1[self.blend_parameter_x]
			local var_2_1 = arg_2_1[self.blend_parameter_y]
			local match_value_x = self.match_value_x
			local match_value_y = self.match_value_y

			return (1 - math.min(math.abs(var_2_0 - match_value_x), 1)) * (1 - math.min(math.abs(var_2_1 - match_value_y), 1))
		end,
		match = function (self, arg_3_1)
			-- function 3
			local var_3_0 = arg_3_1[self.blend_parameter]
			local match_value = self.match_value

			return 1 - math.min(math.abs(var_3_0 - match_value), 1)
		end
	}
end

BlendCamera.parse_parameters = function (self, arg_4_1, arg_4_2)
	-- function 4
	BlendCamera.super.parse_parameters(self, arg_4_1, arg_4_2)

	self._child_node_definitions = arg_4_1.child_node_blend_definitions
end

BlendCamera.add_child_node = function (self, arg_5_1)
	-- function 5
	BlendCamera.super.add_child_node(self, arg_5_1)

	local num = #self._blend_setups + 1
	local var_5_1 = self._child_node_definitions[num]

	self._blend_setups[num] = {
		node = arg_5_1,
		weight_function = self._blend_functions[var_5_1.blend_function],
		definition = var_5_1
	}
end

BlendCamera.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if self._active_children > 0 then
		BlendCamera.super.update(self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)

		return
	end

	local num = 0
	local var_6_1 = Vector3(0, 0, 0)

	for i, v in ipairs(self._blend_setups) do
		local node = v.node

		node:update(arg_6_1, arg_6_2, arg_6_3, arg_6_4)

		local num_2 = node:position() - arg_6_2
		local weight_function = v.weight_function(v.definition, arg_6_4)

		num = num + weight_function

		assert(weight_function >= 0, "[BlendCamera:update() individual weight lesser than 0, undefined.")

		var_6_1 = var_6_1 + num_2 * weight_function
	end

	assert(num > 0, "[BlendCamera:update() total blend weights are lower than 0")

	local num_3 = arg_6_2 + var_6_1 / num

	BlendCamera.super.update(self, arg_6_1, num_3, arg_6_3, arg_6_4)
end
