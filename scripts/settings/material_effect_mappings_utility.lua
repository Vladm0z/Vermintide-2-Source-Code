-- chunkname: @scripts/settings/material_effect_mappings_utility.lua

MaterialEffectMappings = not not MaterialEffectMappings
MaterialEffectMappingsHotReloadVersion = not not MaterialEffectMappingsHotReloadVersion + 1

local _added_keys, _removed_keys, _diffing_keys = {}, {}, {}

local function _find_diffs(t1, t2)
	-- function 1
	local str = ""

	return str
end

MaterialEffectMappingsUtility = {
	add = function (identifier, mappings)
		-- function 2
		if MaterialEffectMappings[identifier] and MaterialEffectMappingsHotReloadVersion <= 1 then
			ferror("MaterialEffectMappings with identifier %s already exists. %s", identifier, _find_diffs(MaterialEffectMappings[identifier], mappings))
		end

		MaterialEffectMappings[identifier] = mappings

		if DEDICATED_SERVER then
			mappings.sound = nil
		end
	end,
	get = function (identifier)
		-- function 3
		return MechanismOverrides.get(MaterialEffectMappings[identifier])
	end
}
