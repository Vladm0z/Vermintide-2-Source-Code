-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_bw_unchained.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = WeaveLoadoutSettings or {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local str = "bright_wizard"
local talent_tree_index = CareerSettings.bw_unchained.talent_tree_index

WeaveLoadoutSettings.bw_unchained = {
	talent_tree = TalentTrees[str][talent_tree_index],
	properties = {},
	traits = {}
}
