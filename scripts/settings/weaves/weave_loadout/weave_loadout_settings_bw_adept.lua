-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_bw_adept.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = WeaveLoadoutSettings or {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local str = "bright_wizard"
local talent_tree_index = CareerSettings.bw_adept.talent_tree_index

WeaveLoadoutSettings.bw_adept = {
	talent_tree = TalentTrees[str][talent_tree_index],
	properties = {},
	traits = {}
}
