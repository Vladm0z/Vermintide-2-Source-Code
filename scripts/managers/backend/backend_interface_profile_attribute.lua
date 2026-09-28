-- chunkname: @scripts/managers/backend/backend_interface_profile_attribute.lua

BackendInterfaceProfileAttribute = class(BackendInterfaceProfileAttribute)

BackendInterfaceProfileAttribute.init = function (self)
	-- function 1
	return
end

BackendInterfaceProfileAttribute.set = function (self, name, value)
	-- function 2
	Backend.write_profile_attribute_as_number(name, value)
end

BackendInterfaceProfileAttribute.get = function (self, name)
	-- function 3
	return Backend.read_profile_attribute_as_number(name)
end

BackendInterfaceProfileAttribute.set_string = function (self, name, value)
	-- function 4
	Backend.write_profile_attribute_as_string(name, value)
end

BackendInterfaceProfileAttribute.get_string = function (self, name)
	-- function 5
	return Backend.read_profile_attribute_as_string(name)
end
