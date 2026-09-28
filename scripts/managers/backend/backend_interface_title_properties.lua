-- chunkname: @scripts/managers/backend/backend_interface_title_properties.lua

BackendInterfaceTitleProperties = class(BackendInterfaceTitleProperties)

BackendInterfaceTitleProperties.init = function (self)
	-- function 1
	return
end

BackendInterfaceTitleProperties._refresh_if_needed = function (self)
	-- function 2
	if not self._properties then
		local data = Backend.get_title_properties()
		local properties = {}

		for key, value in pairs(data) do
			properties[key] = cjson.decode(value)
		end

		self._properties = properties
	end
end

BackendInterfaceTitleProperties.get = function (self)
	-- function 3
	self:_refresh_if_needed()

	return self._properties
end

BackendInterfaceTitleProperties.get_value = function (self, key)
	-- function 4
	self:_refresh_if_needed()

	local value = self._properties[key]

	fassert(value ~= nil, "No such key '%s'", key)

	local decoded = cjson.decode(value)

	return decoded
end
