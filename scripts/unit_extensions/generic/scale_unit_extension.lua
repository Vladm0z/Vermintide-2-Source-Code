-- chunkname: @scripts/unit_extensions/generic/scale_unit_extension.lua

ScaleUnitExtension = class(ScaleUnitExtension)

function ScaleUnitExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = Managers.time:time("game")

	arg_1_0.start_size = arg_1_3.start_size

	local var_1_1 = arg_1_3.end_size

	arg_1_0.duration = arg_1_3.duration
	arg_1_0.full_scale = var_1_1 - arg_1_0.start_size
	arg_1_0.timer = 0
end

function ScaleUnitExtension.setup(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.start_size = arg_2_1 or arg_2_0.start_size
	arg_2_0.full_scale = arg_2_2 - arg_2_0.start_size
	arg_2_0.duration = arg_2_3
	arg_2_0.timer = 0
end

function ScaleUnitExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_0.timer

	if var_3_0 < arg_3_0.duration then
		local var_3_1 = math.clamp(var_3_0 / arg_3_0.duration, 0, 1)
		local var_3_2 = arg_3_0.start_size + math.easeCubic(var_3_1) * arg_3_0.full_scale
		local var_3_3 = Vector3(1, 1, var_3_2)

		Unit.set_local_scale(arg_3_1, 0, var_3_3)

		arg_3_0.timer = arg_3_0.timer + arg_3_3
	end
end

function ScaleUnitExtension.scaling_complete(arg_4_0)
	return arg_4_0.timer >= arg_4_0.duration
end

function ScaleUnitExtension.despawn(arg_5_0)
	return
end
