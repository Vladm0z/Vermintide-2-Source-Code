-- chunkname: @scripts/managers/backend/backend_interface_profile_attribute.lua

BackendInterfaceProfileAttribute = class(BackendInterfaceProfileAttribute)

function BackendInterfaceProfileAttribute.init(arg_1_0)
	return
end

function BackendInterfaceProfileAttribute.set(arg_2_0, arg_2_1, arg_2_2)
	Backend.write_profile_attribute_as_number(arg_2_1, arg_2_2)
end

function BackendInterfaceProfileAttribute.get(arg_3_0, arg_3_1)
	return Backend.read_profile_attribute_as_number(arg_3_1)
end

function BackendInterfaceProfileAttribute.set_string(arg_4_0, arg_4_1, arg_4_2)
	Backend.write_profile_attribute_as_string(arg_4_1, arg_4_2)
end

function BackendInterfaceProfileAttribute.get_string(arg_5_0, arg_5_1)
	return Backend.read_profile_attribute_as_string(arg_5_1)
end
