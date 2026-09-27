-- chunkname: @scripts/managers/backend_playfab/tutorial_backend/backend_interface_hero_attributes_tutorial.lua

BackendInterfaceHeroAttributesTutorial = class(BackendInterfaceHeroAttributesTutorial)

local tbl = {
	dwarf_ranger_career = 1,
	empire_soldier_tutorial_career = 1,
	wood_elf_experience = 0,
	dwarf_ranger_experience = 0,
	bright_wizard_prestige = 0,
	dwarf_ranger_prestige = 0,
	empire_soldier_prestige = 0,
	bright_wizard_experience = 0,
	witch_hunter_prestige = 0,
	empire_soldier_tutorial_prestige = 0,
	wood_elf_career = 1,
	empire_soldier_career = 1,
	wood_elf_prestige = 0,
	witch_hunter_career = 1,
	bright_wizard_career = 1,
	witch_hunter_experience = 0,
	empire_soldier_experience = 0,
	empire_soldier_tutorial_experience = 0
}

BackendInterfaceHeroAttributesTutorial.init = function (self, arg_1_1)
	-- function 1
	self._attributes = table.clone(tbl)
	self._initialized = true
end

BackendInterfaceHeroAttributesTutorial.ready = function (self)
	-- function 2
	return self._initialized
end

BackendInterfaceHeroAttributesTutorial.update = function (arg_3_0, arg_3_1)
	-- function 3
	return
end

BackendInterfaceHeroAttributesTutorial.get = function (self, arg_4_1, arg_4_2)
	-- function 4
	local str = arg_4_1 .. "_" .. arg_4_2
	local var_4_1 = self._attributes[str]

	var_4_1 = var_4_1 or tbl[str]

	return var_4_1
end

BackendInterfaceHeroAttributesTutorial.set = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	return
end

BackendInterfaceHeroAttributesTutorial.prestige = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

BackendInterfaceHeroAttributesTutorial.prestige_request_cb = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	return
end

BackendInterfaceHeroAttributesTutorial.save = function (arg_8_0, arg_8_1)
	-- function 8
	return false
end
