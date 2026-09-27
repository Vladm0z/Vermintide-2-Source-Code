-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_dr_slayer.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = WeaveLoadoutSettings or {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local str = "dwarf_ranger"
local talent_tree_index = CareerSettings.dr_slayer.talent_tree_index

WeaveLoadoutSettings.dr_slayer = {
	talent_tree = TalentTrees[str][talent_tree_index],
	properties = {},
	traits = {}
}
