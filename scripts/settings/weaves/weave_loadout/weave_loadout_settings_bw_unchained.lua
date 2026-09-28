-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_bw_unchained.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = not not WeaveLoadoutSettings or not not {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local profile_name = "bright_wizard"
local talent_index = CareerSettings.bw_unchained.talent_tree_index

WeaveLoadoutSettings.bw_unchained = {
	talent_tree = TalentTrees[profile_name][talent_index],
	properties = {},
	traits = {}
}
