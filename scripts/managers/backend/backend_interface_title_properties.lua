-- chunkname: @scripts/managers/backend/backend_interface_title_properties.lua

BackendInterfaceTitleProperties = class(BackendInterfaceTitleProperties)

function BackendInterfaceTitleProperties.init(arg_1_0)
	return
end

function BackendInterfaceTitleProperties._refresh_if_needed(arg_2_0)
	if not arg_2_0._properties then
		local var_2_0 = Backend.get_title_properties()
		local var_2_1 = {}

		for iter_2_0, iter_2_1 in pairs(var_2_0) do
			var_2_1[iter_2_0] = cjson.decode(iter_2_1)
		end

		arg_2_0._properties = var_2_1
	end
end

function BackendInterfaceTitleProperties.get(arg_3_0)
	arg_3_0:_refresh_if_needed()

	return arg_3_0._properties
end

function BackendInterfaceTitleProperties.get_value(arg_4_0, arg_4_1)
	arg_4_0:_refresh_if_needed()

	local var_4_0 = arg_4_0._properties[arg_4_1]

	fassert(var_4_0 ~= nil, "No such key '%s'", arg_4_1)

	return (cjson.decode(var_4_0))
end
