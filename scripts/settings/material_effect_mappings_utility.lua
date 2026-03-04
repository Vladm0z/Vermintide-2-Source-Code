-- chunkname: @scripts/settings/material_effect_mappings_utility.lua

MaterialEffectMappings = MaterialEffectMappings or {}
MaterialEffectMappingsHotReloadVersion = (MaterialEffectMappingsHotReloadVersion or 0) + 1

local var_0_0 = {}
local var_0_1 = {}
local var_0_2 = {}

local function var_0_3(arg_1_0, arg_1_1)
	return ""
end

MaterialEffectMappingsUtility = {
	add = function(arg_2_0, arg_2_1)
		if MaterialEffectMappings[arg_2_0] and MaterialEffectMappingsHotReloadVersion <= 1 then
			ferror("MaterialEffectMappings with identifier %s already exists. %s", arg_2_0, var_0_3(MaterialEffectMappings[arg_2_0], arg_2_1))
		end

		MaterialEffectMappings[arg_2_0] = arg_2_1

		if DEDICATED_SERVER then
			arg_2_1.sound = nil
		end
	end,
	get = function(arg_3_0)
		return MechanismOverrides.get(MaterialEffectMappings[arg_3_0])
	end
}
