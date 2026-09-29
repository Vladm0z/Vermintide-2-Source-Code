-- chunkname: @scripts/managers/backend_playfab/backend_interface_hero_attributes_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceHeroAttributesPlayFab = class(BackendInterfaceHeroAttributesPlayFab)

local DEFAULT_READ_ONLY_ATTRIBUTES = {
	wood_elf_experience_pool = 0,
	empire_soldier_experience = 0,
	wood_elf_experience = 0,
	dwarf_ranger_experience = 0,
	bright_wizard_prestige = 0,
	dwarf_ranger_prestige = 0,
	empire_soldier_prestige = 0,
	bright_wizard_experience = 0,
	witch_hunter_prestige = 0,
	empire_soldier_tutorial_experience_pool = 0,
	empire_soldier_tutorial_prestige = 0,
	witch_hunter_experience_pool = 0,
	empire_soldier_experience_pool = 0,
	wood_elf_prestige = 0,
	bright_wizard_experience_pool = 0,
	witch_hunter_experience = 0,
	dwarf_ranger_experience_pool = 0,
	empire_soldier_tutorial_experience = 0
}
local DEFAULT_CHARACTER_ATTRIBUTES = {
	career = 1,
	bot_career = 1
}

BackendInterfaceHeroAttributesPlayFab.init = function (self, backend_mirror)
	-- function 1
	self._attributes = {}
	self._attributes_to_save = {}
	self._backend_mirror = backend_mirror

	self:_refresh()

	self._initialized = true
end

BackendInterfaceHeroAttributesPlayFab.make_dirty = function (self)
	-- function 2
	self._dirty = true
end

BackendInterfaceHeroAttributesPlayFab._refresh = function (self)
	-- function 3
	table.clear(self._attributes)

	local mirror = self._backend_mirror

	if script_data.honduras_demo then
		for attribute_name, default_value in pairs(DEFAULT_DEMO_ATTRIBUTES) do
			self._attributes[attribute_name] = default_value
		end
	else
		for attribute_name, default_value in pairs(DEFAULT_READ_ONLY_ATTRIBUTES) do
			local backend_value = mirror:get_read_only_data(attribute_name)

			self._attributes[attribute_name] = not not backend_value or not not default_value
		end
	end

	local characters_data = mirror:get_characters_data()
	local attributes = self._attributes

	for character, data in pairs(characters_data) do
		for attribute_name, default_value in pairs(DEFAULT_CHARACTER_ATTRIBUTES) do
			local key = string.format("%s_%s", character, attribute_name)

			attributes[key] = not not data[attribute_name]
		end
	end

	self._dirty = false
end

BackendInterfaceHeroAttributesPlayFab.ready = function (self)
	-- function 4
	return self._initialized
end

BackendInterfaceHeroAttributesPlayFab.update = function (self, dt)
	-- function 5
	return
end

BackendInterfaceHeroAttributesPlayFab.get = function (self, hero, attribute)
	-- function 6
	if self._dirty then
		self:_refresh()
	end

	local key = hero .. "_" .. attribute

	return self._attributes[key]
end

BackendInterfaceHeroAttributesPlayFab.set = function (self, hero, attribute, value)
	-- function 7
	fassert(value ~= nil, "Trying to set a hero attribute to nil, don't do this")

	local mirror = self._backend_mirror

	if DEFAULT_CHARACTER_ATTRIBUTES[attribute] then
		mirror:set_career_read_only_data(hero, attribute, value, nil, false)
	else
		local key = hero .. "_" .. attribute

		mirror:set_read_only_data(key, value, true)
	end

	self._dirty = true
end
