-- chunkname: @scripts/managers/backend/backend_interface_profile_attribute.lua

BackendInterfaceProfileAttribute = class(BackendInterfaceProfileAttribute)

BackendInterfaceProfileAttribute.init = function (arg_1_0)
	return
end

BackendInterfaceProfileAttribute.set = function (arg_2_0, arg_2_1, arg_2_2)
	Backend.write_profile_attribute_as_number(arg_2_1, arg_2_2)
end

BackendInterfaceProfileAttribute.get = function (arg_3_0, arg_3_1)
	return Backend.read_profile_attribute_as_number(arg_3_1)
end

BackendInterfaceProfileAttribute.set_string = function (arg_4_0, arg_4_1, arg_4_2)
	Backend.write_profile_attribute_as_string(arg_4_1, arg_4_2)
end

BackendInterfaceProfileAttribute.get_string = function (arg_5_0, arg_5_1)
	return Backend.read_profile_attribute_as_string(arg_5_1)
end
