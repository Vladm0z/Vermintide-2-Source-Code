-- chunkname: @scripts/level/environment/environment_handler.lua

require("scripts/level/environment/environment_blend_time")
require("scripts/level/environment/environment_blend_volume")

EnvironmentHandler = class(EnvironmentHandler)
EnvironmentHandler.ID = EnvironmentHandler.ID or 0

EnvironmentHandler.init = function (arg_1_0)
	arg_1_0._blends = {}
	arg_1_0._weights = {}
end

EnvironmentHandler.add_blend_group = function (arg_2_0, arg_2_1)
	arg_2_0._blends[arg_2_1] = {}
end

EnvironmentHandler.add_blend = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0

	if arg_3_5 then
		var_3_0 = arg_3_5
	else
		EnvironmentHandler.ID = EnvironmentHandler.ID + 1
		var_3_0 = EnvironmentHandler.ID
	end

	local var_3_1 = rawget(_G, arg_3_1):new(arg_3_4)
	local var_3_2 = arg_3_0._blends[arg_3_2]

	var_3_2[#var_3_2 + 1] = {
		priority = arg_3_3,
		blend = var_3_1,
		id = var_3_0
	}

	table.sort(var_3_2, function (arg_4_0, arg_4_1)
		return arg_4_0.priority > arg_4_1.priority
	end)

	return var_3_0
end

EnvironmentHandler.remove_blend = function (arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in pairs(arg_5_0._blends) do
		for iter_5_2, iter_5_3 in pairs(iter_5_1) do
			if iter_5_3.id == arg_5_1 then
				iter_5_3.blend:destroy()
				table.remove(iter_5_1, iter_5_2)
				table.clear(arg_5_0._weights)
				arg_5_0:_update_weights()

				return
			end
		end
	end
end

EnvironmentHandler.update = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_blends(arg_6_1)
	arg_6_0:_update_weights(arg_6_1)
end

EnvironmentHandler._update_blends = function (arg_7_0, arg_7_1)
	for iter_7_0, iter_7_1 in pairs(arg_7_0._blends) do
		for iter_7_2, iter_7_3 in ipairs(iter_7_1) do
			iter_7_3.blend:update(arg_7_1)
		end
	end
end

EnvironmentHandler._update_weights = function (arg_8_0)
	local var_8_0

	for iter_8_0, iter_8_1 in pairs(arg_8_0._blends) do
		local var_8_1 = arg_8_0._weights[iter_8_0] or {}
		local var_8_2 = 1
		local var_8_3 = 1

		for iter_8_2 = 1, #iter_8_1 do
			local var_8_4 = iter_8_1[iter_8_2]

			if not var_8_1[iter_8_2] then
				local var_8_5 = {}
			end

			local var_8_6 = var_8_1[iter_8_2] or {}

			var_8_6.environment = var_8_4.blend:environment()
			var_8_6.blend = var_8_4.blend
			var_8_6.particle_light_intensity = var_8_4.blend:particle_light_intensity()

			if var_8_2 > 0 then
				local var_8_7 = math.min(var_8_4.blend:value(), var_8_2)

				var_8_6.weight = var_8_7
				var_8_2 = var_8_2 - var_8_7
			else
				var_8_6.weight = 0
			end

			var_8_1[iter_8_2] = var_8_6
			iter_8_2 = iter_8_2 + 1
		end

		arg_8_0._weights[iter_8_0] = var_8_1
	end
end

EnvironmentHandler.weights = function (arg_9_0, arg_9_1)
	return arg_9_0._weights[arg_9_1]
end

EnvironmentHandler.override_settings = function (arg_10_0)
	local var_10_0 = 0
	local var_10_1

	for iter_10_0, iter_10_1 in pairs(arg_10_0._blends.volumes) do
		if iter_10_1.blend:is_inside() and var_10_0 < iter_10_1.priority then
			var_10_1 = iter_10_1.blend
			var_10_0 = iter_10_1.priority
		end
	end

	if var_10_1 then
		return var_10_1:override_settings()
	end

	return nil
end

EnvironmentHandler.destroy = function (arg_11_0)
	for iter_11_0, iter_11_1 in pairs(arg_11_0._blends) do
		for iter_11_2, iter_11_3 in ipairs(iter_11_1) do
			iter_11_3.blend:destroy()
		end
	end

	arg_11_0._blends = nil
end
