-- chunkname: @scripts/unit_extensions/objectives/objective_group_extension.lua

ObjectiveGroupExtension = class(ObjectiveGroupExtension, BaseObjectiveExtension)
ObjectiveGroupExtension.NAME = "ObjectiveGroupExtension"

function ObjectiveGroupExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	ObjectiveGroupExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._children = {}
end

function ObjectiveGroupExtension._set_objective_data(arg_2_0, arg_2_1)
	arg_2_0._time_for_completion = arg_2_1.time_for_completion or 0
end

function ObjectiveGroupExtension._activate(arg_3_0)
	return
end

function ObjectiveGroupExtension.register_child(arg_4_0, arg_4_1)
	arg_4_0._children[arg_4_1] = true
end

function ObjectiveGroupExtension.get_percentage_done(arg_5_0)
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

function ObjectiveGroupExtension.get_total_sections(arg_6_0)
	local var_6_0 = 0

	for iter_6_0 in pairs(arg_6_0._children) do
		var_6_0 = var_6_0 + iter_6_0:get_total_sections()
	end

	return var_6_0
end

function ObjectiveGroupExtension.description(arg_7_0)
	for iter_7_0 in pairs(arg_7_0._children) do
		local var_7_0 = iter_7_0:description()

		if var_7_0 then
			return var_7_0
		end
	end
end

function ObjectiveGroupExtension.objective_icon(arg_8_0)
	for iter_8_0 in pairs(arg_8_0._children) do
		local var_8_0 = iter_8_0:objective_icon()

		if var_8_0 then
			return var_8_0
		end
	end
end

function ObjectiveGroupExtension.objective_type(arg_9_0)
	for iter_9_0 in pairs(arg_9_0._children) do
		local var_9_0 = iter_9_0:objective_type()

		if var_9_0 then
			return var_9_0
		end
	end
end

function ObjectiveGroupExtension.is_done(arg_10_0)
	return arg_10_0:get_percentage_done() >= 1
end

function ObjectiveGroupExtension.is_active(arg_11_0)
	return arg_11_0._activated
end

function ObjectiveGroupExtension._client_update(arg_12_0)
	return
end

function ObjectiveGroupExtension._server_update(arg_13_0)
	return
end

function ObjectiveGroupExtension._deactivate(arg_14_0)
	return
end
