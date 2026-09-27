-- chunkname: @scripts/managers/backend/backend_interface_title_properties.lua

BackendInterfaceTitleProperties = class(BackendInterfaceTitleProperties)

BackendInterfaceTitleProperties.init = function (arg_1_0)
	-- function 1
	return
end

BackendInterfaceTitleProperties._refresh_if_needed = function (self)
	-- function 2
	if not self._properties then
		local get_title_properties = Backend.get_title_properties()
		local tbl = {}

		for k, v in pairs(get_title_properties) do
			tbl[k] = cjson.decode(v)
		end

		self._properties = tbl
	end
end

BackendInterfaceTitleProperties.get = function (self)
	-- function 3
	self:_refresh_if_needed()

	return self._properties
end

BackendInterfaceTitleProperties.get_value = function (self, arg_4_1)
	-- function 4
	self:_refresh_if_needed()

	local var_4_0 = self._properties[arg_4_1]

	fassert(var_4_0 ~= nil, "No such key '%s'", arg_4_1)

	return (cjson.decode(var_4_0))
end
