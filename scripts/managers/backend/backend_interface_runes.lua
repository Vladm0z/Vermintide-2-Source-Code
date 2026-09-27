-- chunkname: @scripts/managers/backend/backend_interface_runes.lua

BackendInterfaceRunes = class(BackendInterfaceRunes)

local str = "runes_"
local str_2 = "runes"
local str_3 = "rune_"

BackendInterfaceRunes.init = function (arg_1_0)
	-- function 1
	return
end

BackendInterfaceRunes._refresh_attributes = function (self)
	-- function 2
	local get_entities_with_attributes = Backend.get_entities_with_attributes(str_2)
	local tbl = {}

	for k, v in pairs(get_entities_with_attributes) do
		local entity_name = v.entity_name
		local runes = v.runes

		runes.entity_id = k
		tbl[entity_name] = runes
	end

	self._runes = tbl
end

BackendInterfaceRunes.on_authenticated = function (self)
	-- function 3
	self:_refresh_attributes()
end

BackendInterfaceRunes.get = function (self, arg_4_1)
	-- function 4
	local str_2 = str .. arg_4_1
	local var_4_1 = self._runes[str_2]

	if not var_4_1 then
		Application.warning(string.format("[BackendInterfaceRunes:get] Tried to get undefined rune %q", str_2))

		return
	end

	return (cjson.decode(var_4_1))
end

BackendInterfaceRunes.set = function (self, arg_5_1, arg_5_2)
	-- function 5
	local str_2 = str .. arg_5_1
	local str_4 = str_3 .. arg_5_2.rune_slot
	local var_5_2 = self._runes[str_2]

	if arg_5_2 == nil then
		Application.warning(string.format("[BackendInterfaceRunes:set] Tried to set runes %q for entity %q to nil", str_4, str_2))

		return
	end

	local entity_id = var_5_2.entity_id
	local encode = cjson.encode(arg_5_2)
	local set_entity_attribute = Backend.set_entity_attribute(entity_id, str_4, encode)

	fassert(not set_entity_attribute and set_entity_attribute == Backend.RES_NO_CHANGE, "[BackendInterfaceRunes:set] BackendItem.set_entity_attribute() returned an unexpected result: %d", set_entity_attribute)
	self:_refresh_attributes()
end
