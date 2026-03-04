-- chunkname: @scripts/unit_extensions/objectives/objective_group_extension.lua

ObjectiveGroupExtension = class(ObjectiveGroupExtension, BaseObjectiveExtension)
ObjectiveGroupExtension.NAME = "ObjectiveGroupExtension"

ObjectiveGroupExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	ObjectiveGroupExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._children = {}
end

ObjectiveGroupExtension._set_objective_data = function (arg_2_0, arg_2_1)
	arg_2_0._time_for_completion = arg_2_1.time_for_completion or 0
end

ObjectiveGroupExtension._activate = function (arg_3_0)
	return
end

ObjectiveGroupExtension.register_child = function (arg_4_0, arg_4_1)
	arg_4_0._children[arg_4_1] = true
end

ObjectiveGroupExtension.get_percentage_done = function (arg_5_0)
	local var_5_0 = 0
	local var_5_1 = 0

	for iter_5_0 in pairs(arg_5_0._children) do
		var_5_0 = var_5_0 + iter_5_0:get_percentage_done()
		var_5_1 = var_5_1 + 1
	end

	if var_5_1 == 0 then
		return 1
	end

	return var_5_0 / var_5_1
end

ObjectiveGroupExtension.get_total_sections = function (arg_6_0)
	local var_6_0 = 0

	for iter_6_0 in pairs(arg_6_0._children) do
		var_6_0 = var_6_0 + iter_6_0:get_total_sections()
	end

	return var_6_0
end

ObjectiveGroupExtension.description = function (arg_7_0)
	for iter_7_0 in pairs(arg_7_0._children) do
		local var_7_0 = iter_7_0:description()

		if var_7_0 then
			return var_7_0
		end
	end
end

ObjectiveGroupExtension.objective_icon = function (arg_8_0)
	for iter_8_0 in pairs(arg_8_0._children) do
		local var_8_0 = iter_8_0:objective_icon()

		if var_8_0 then
			return var_8_0
		end
	end
end

ObjectiveGroupExtension.objective_type = function (arg_9_0)
	for iter_9_0 in pairs(arg_9_0._children) do
		local var_9_0 = iter_9_0:objective_type()

		if var_9_0 then
			return var_9_0
		end
	end
end

ObjectiveGroupExtension.is_done = function (arg_10_0)
	return arg_10_0:get_percentage_done() >= 1
end

ObjectiveGroupExtension.is_active = function (arg_11_0)
	return arg_11_0._activated
end

ObjectiveGroupExtension._client_update = function (arg_12_0)
	return
end

ObjectiveGroupExtension._server_update = function (arg_13_0)
	return
end

ObjectiveGroupExtension._deactivate = function (arg_14_0)
	return
end
