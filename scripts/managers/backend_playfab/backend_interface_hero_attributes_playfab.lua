-- chunkname: @scripts/managers/backend_playfab/backend_interface_hero_attributes_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceHeroAttributesPlayFab = class(BackendInterfaceHeroAttributesPlayFab)

local tbl = {
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
local tbl_2 = {
	career = 1,
	bot_career = 1
}

BackendInterfaceHeroAttributesPlayFab.init = function (self, arg_1_1)
	-- function 1
	self._attributes = {}
	self._attributes_to_save = {}
	self._backend_mirror = arg_1_1

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

	local _backend_mirror = self._backend_mirror

	if not script_data.honduras_demo then
		for k, v in pairs(DEFAULT_DEMO_ATTRIBUTES) do
			self._attributes[k] = v
		end
	else
		for k_2, v_2 in pairs(tbl) do
			local get_read_only_data = _backend_mirror:get_read_only_data(k_2)

			self._attributes[k_2] = get_read_only_data or v_2
		end
	end

	local get_characters_data = _backend_mirror:get_characters_data()
	local _attributes = self._attributes

	for k_3, v_3 in pairs(get_characters_data) do
		for k_4, v_4 in pairs(tbl_2) do
			local format = string.format("%s_%s", k_3, k_4)
			local var_3_5 = v_3[k_4]

			var_3_5 = var_3_5 or v_4
			_attributes[format] = var_3_5
		end
	end

	self._dirty = false
end

BackendInterfaceHeroAttributesPlayFab.ready = function (self)
	-- function 4
	return self._initialized
end

BackendInterfaceHeroAttributesPlayFab.update = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

BackendInterfaceHeroAttributesPlayFab.get = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._dirty then
		self:_refresh()
	end

	local str = arg_6_1 .. "_" .. arg_6_2

	return self._attributes[str]
end

BackendInterfaceHeroAttributesPlayFab.set = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	fassert(arg_7_3 ~= nil, "Trying to set a hero attribute to nil, don't do this")

	local _backend_mirror = self._backend_mirror

	if not tbl_2[arg_7_2] then
		_backend_mirror:set_career_read_only_data(arg_7_1, arg_7_2, arg_7_3, nil, false)
	else
		local str = arg_7_1 .. "_" .. arg_7_2

		_backend_mirror:set_read_only_data(str, arg_7_3, true)
	end

	self._dirty = true
end
