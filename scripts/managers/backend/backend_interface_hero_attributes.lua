-- chunkname: @scripts/managers/backend/backend_interface_hero_attributes.lua

BackendInterfaceHeroAttributes = class(BackendInterfaceHeroAttributes)

local str = "hero_attributes_"
local str_2 = "hero_attributes"
local str_3 = "hero_attribute_"

BackendInterfaceHeroAttributes.init = function (arg_1_0)
	-- function 1
	return
end

BackendInterfaceHeroAttributes._refresh_attributes = function (self)
	-- function 2
	local get_entities_with_attributes = Backend.get_entities_with_attributes(str_2)
	local tbl = {}

	for k, v in pairs(get_entities_with_attributes) do
		local entity_name = v.entity_name
		local attributes = v.attributes

		attributes.entity_id = k
		tbl[entity_name] = attributes
	end

	self._attributes = tbl
end

BackendInterfaceHeroAttributes.on_authenticated = function (self)
	-- function 3
	self:_refresh_attributes()
end

BackendInterfaceHeroAttributes.get = function (self, arg_4_1, arg_4_2)
	-- function 4
	local str_2 = str .. arg_4_1
	local str_4 = str_3 .. arg_4_2
	local var_4_2 = self._attributes[str_2]
	local flag = not var_4_2 and var_4_2[str_4]

	if not flag then
		return
	end

	return (cjson.decode(flag))
end

BackendInterfaceHeroAttributes.set = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local str_2 = str .. arg_5_1
	local str_4 = str_3 .. arg_5_2
	local var_5_2 = self._attributes[str_2]

	if not (not var_5_2 and var_5_2[str_4]) then
		return
	end

	if arg_5_3 == nil then
		return
	end

	local entity_id = var_5_2.entity_id
	local encode = cjson.encode(arg_5_3)
	local set_entity_attribute = Backend.set_entity_attribute(entity_id, str_4, encode)

	fassert(not set_entity_attribute and set_entity_attribute == Backend.RES_NO_CHANGE, "[BackendInterfaceHeroAttributes:set] BackendItem.set_entity_attribute() returned an unexpected result: %d", set_entity_attribute)
	self:_refresh_attributes()
end
