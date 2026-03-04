-- chunkname: @scripts/managers/backend_playfab/backend_interface_hero_attributes_playfab.lua

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceHeroAttributesPlayFab = class(BackendInterfaceHeroAttributesPlayFab)

local var_0_1 = {
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
local var_0_2 = {
	career = 1,
	bot_career = 1
}

BackendInterfaceHeroAttributesPlayFab.init = function (arg_1_0, arg_1_1)
	arg_1_0._attributes = {}
	arg_1_0._attributes_to_save = {}
	arg_1_0._backend_mirror = arg_1_1

	arg_1_0:_refresh()

	arg_1_0._initialized = true
end

BackendInterfaceHeroAttributesPlayFab.make_dirty = function (arg_2_0)
	arg_2_0._dirty = true
end

BackendInterfaceHeroAttributesPlayFab._refresh = function (arg_3_0)
	table.clear(arg_3_0._attributes)

	local var_3_0 = arg_3_0._backend_mirror

	if script_data.honduras_demo then
		for iter_3_0, iter_3_1 in pairs(DEFAULT_DEMO_ATTRIBUTES) do
			arg_3_0._attributes[iter_3_0] = iter_3_1
		end
	else
		for iter_3_2, iter_3_3 in pairs(var_0_1) do
			local var_3_1 = var_3_0:get_read_only_data(iter_3_2)

			arg_3_0._attributes[iter_3_2] = var_3_1 or iter_3_3
		end
	end

	local var_3_2 = var_3_0:get_characters_data()
	local var_3_3 = arg_3_0._attributes

	for iter_3_4, iter_3_5 in pairs(var_3_2) do
		for iter_3_6, iter_3_7 in pairs(var_0_2) do
			var_3_3[string.format("%s_%s", iter_3_4, iter_3_6)] = iter_3_5[iter_3_6] or iter_3_7
		end
	end

	arg_3_0._dirty = false
end

BackendInterfaceHeroAttributesPlayFab.ready = function (arg_4_0)
	return arg_4_0._initialized
end

BackendInterfaceHeroAttributesPlayFab.update = function (arg_5_0, arg_5_1)
	return
end

BackendInterfaceHeroAttributesPlayFab.get = function (arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._dirty then
		arg_6_0:_refresh()
	end

	local var_6_0 = arg_6_1 .. "_" .. arg_6_2

	return arg_6_0._attributes[var_6_0]
end

BackendInterfaceHeroAttributesPlayFab.set = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	fassert(arg_7_3 ~= nil, "Trying to set a hero attribute to nil, don't do this")

	local var_7_0 = arg_7_0._backend_mirror

	if var_0_2[arg_7_2] then
		var_7_0:set_career_read_only_data(arg_7_1, arg_7_2, arg_7_3, nil, false)
	else
		local var_7_1 = arg_7_1 .. "_" .. arg_7_2

		var_7_0:set_read_only_data(var_7_1, arg_7_3, true)
	end

	arg_7_0._dirty = true
end
