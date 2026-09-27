-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_dr_ironbreaker.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = WeaveLoadoutSettings or {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local str = "dwarf_ranger"
local talent_tree_index = CareerSettings.dr_ironbreaker.talent_tree_index

WeaveLoadoutSettings.dr_ironbreaker = {
	talent_tree = TalentTrees[str][talent_tree_index],
	properties = {},
	traits = {}
}
