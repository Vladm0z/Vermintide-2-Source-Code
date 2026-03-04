-- chunkname: @scripts/managers/backend_playfab/tutorial_backend/backend_interface_hero_attributes_tutorial.lua

BackendInterfaceHeroAttributesTutorial = class(BackendInterfaceHeroAttributesTutorial)

local var_0_0 = {
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

function BackendInterfaceHeroAttributesTutorial.init(arg_1_0, arg_1_1)
	arg_1_0._attributes = table.clone(var_0_0)
	arg_1_0._initialized = true
end

function BackendInterfaceHeroAttributesTutorial.ready(arg_2_0)
	return arg_2_0._initialized
end

function BackendInterfaceHeroAttributesTutorial.update(arg_3_0, arg_3_1)
	return
end

function BackendInterfaceHeroAttributesTutorial.get(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_1 .. "_" .. arg_4_2

	return arg_4_0._attributes[var_4_0] or var_0_0[var_4_0]
end

function BackendInterfaceHeroAttributesTutorial.set(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	return
end

function BackendInterfaceHeroAttributesTutorial.prestige(arg_6_0, arg_6_1, arg_6_2)
	return
end

function BackendInterfaceHeroAttributesTutorial.prestige_request_cb(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	return
end

function BackendInterfaceHeroAttributesTutorial.save(arg_8_0, arg_8_1)
	return false
end
