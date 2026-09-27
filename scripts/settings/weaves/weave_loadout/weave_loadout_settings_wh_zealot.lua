-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_wh_zealot.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = WeaveLoadoutSettings or {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local str = "witch_hunter"
local talent_tree_index = CareerSettings.wh_zealot.talent_tree_index

WeaveLoadoutSettings.wh_zealot = {
	talent_tree = TalentTrees[str][talent_tree_index],
	properties = {},
	traits = {}
}
