-- chunkname: @scripts/managers/camera/cameras/blend_camera.lua

require("scripts/managers/camera/cameras/base_camera")

BlendCamera = class(BlendCamera, BaseCamera)

function BlendCamera.init(arg_1_0, arg_1_1)
	BlendCamera.super.init(arg_1_0, arg_1_1)

	arg_1_0._offset_position = Vector3(0, 0, 0)
	arg_1_0._blend_setups = {}
	arg_1_0._blend_functions = {
		match_2d = function(arg_2_0, arg_2_1)
			local var_2_0 = arg_2_1[arg_2_0.blend_parameter_x]
			local var_2_1 = arg_2_1[arg_2_0.blend_parameter_y]
			local var_2_2 = arg_2_0.match_value_x
			local var_2_3 = arg_2_0.match_value_y

			return (1 - math.min(math.abs(var_2_0 - var_2_2), 1)) * (1 - math.min(math.abs(var_2_1 - var_2_3), 1))
		end,
		match = function(arg_3_0, arg_3_1)
			local var_3_0 = arg_3_1[arg_3_0.blend_parameter]
			local var_3_1 = arg_3_0.match_value

			return 1 - math.min(math.abs(var_3_0 - var_3_1), 1)
		end
	}
end

function BlendCamera.parse_parameters(arg_4_0, arg_4_1, arg_4_2)
	BlendCamera.super.parse_parameters(arg_4_0, arg_4_1, arg_4_2)

	arg_4_0._child_node_definitions = arg_4_1.child_node_blend_definitions
end

function BlendCamera.add_child_node(arg_5_0, arg_5_1)
	BlendCamera.super.add_child_node(arg_5_0, arg_5_1)

	local var_5_0 = #arg_5_0._blend_setups + 1
	local var_5_1 = arg_5_0._child_node_definitions[var_5_0]

	arg_5_0._blend_setups[var_5_0] = {
		node = arg_5_1,
		weight_function = arg_5_0._blend_functions[var_5_1.blend_function],
		definition = var_5_1
	}
end

function BlendCamera.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_0._active_children > 0 then
		BlendCamera.super.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)

		return
	end

	local var_6_0 = 0
	local var_6_1 = Vector3(0, 0, 0)

	for iter_6_0, iter_6_1 in ipairs(arg_6_0._blend_setups) do
		local var_6_2 = iter_6_1.node

		var_6_2:update(arg_6_1, arg_6_2, arg_6_3, arg_6_4)

		local var_6_3 = var_6_2:position() - arg_6_2
		local var_6_4 = iter_6_1.weight_function(iter_6_1.definition, arg_6_4)

		var_6_0 = var_6_0 + var_6_4

		assert(var_6_4 >= 0, "[BlendCamera:update() individual weight lesser than 0, undefined.")

		var_6_1 = var_6_1 + var_6_3 * var_6_4
	end

	assert(var_6_0 > 0, "[BlendCamera:update() total blend weights are lower than 0")

	local var_6_5 = arg_6_2 + var_6_1 / var_6_0

	BlendCamera.super.update(arg_6_0, arg_6_1, var_6_5, arg_6_3, arg_6_4)
end
