-- chunkname: @scripts/settings/material_effect_mappings_utility.lua

local MaterialEffectMappings = MaterialEffectMappings

MaterialEffectMappings = MaterialEffectMappings or {}
MaterialEffectMappings = MaterialEffectMappings

local MaterialEffectMappingsHotReloadVersion = MaterialEffectMappingsHotReloadVersion

MaterialEffectMappingsHotReloadVersion = MaterialEffectMappingsHotReloadVersion or 0
MaterialEffectMappingsHotReloadVersion = MaterialEffectMappingsHotReloadVersion + 1

local tbl = {}
local tbl_2 = {}
local tbl_3 = {}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	return ""
end

MaterialEffectMappingsUtility = {
	add = function (arg_2_0, arg_2_1)
		-- function 2
		if not (not MaterialEffectMappings[arg_2_0] and not (MaterialEffectMappingsHotReloadVersion <= 1)) then
			ferror("MaterialEffectMappings with identifier %s already exists. %s", arg_2_0, fn(MaterialEffectMappings[arg_2_0], arg_2_1))
		end

		MaterialEffectMappings[arg_2_0] = arg_2_1

		if not DEDICATED_SERVER then
			arg_2_1.sound = nil
		end
	end,
	get = function (arg_3_0)
		-- function 3
		return MechanismOverrides.get(MaterialEffectMappings[arg_3_0])
	end
}
