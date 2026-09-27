-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_es_knight.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = WeaveLoadoutSettings or {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local str = "empire_soldier"
local talent_tree_index = CareerSettings.es_knight.talent_tree_index

WeaveLoadoutSettings.es_knight = {
	talent_tree = TalentTrees[str][talent_tree_index],
	properties = {},
	traits = {}
}
