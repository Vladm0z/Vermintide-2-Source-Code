-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_dr_ranger.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = not not WeaveLoadoutSettings or not not {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local profile_name = "dwarf_ranger"
local talent_index = CareerSettings.dr_ranger.talent_tree_index

WeaveLoadoutSettings.dr_ranger = {
	talent_tree = TalentTrees[profile_name][talent_index],
	properties = {},
	traits = {}
}
