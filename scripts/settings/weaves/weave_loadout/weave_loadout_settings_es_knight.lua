-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_es_knight.lua

WeaveLoadoutSettings = WeaveLoadoutSettings or {}

local var_0_0 = "empire_soldier"
local var_0_1 = CareerSettings.es_knight.talent_tree_index

WeaveLoadoutSettings.es_knight = {
	talent_tree = TalentTrees[var_0_0][var_0_1],
	properties = {},
	traits = {}
}
