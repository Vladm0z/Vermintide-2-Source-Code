-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_dr_ranger.lua

WeaveLoadoutSettings = WeaveLoadoutSettings or {}

local var_0_0 = "dwarf_ranger"
local var_0_1 = CareerSettings.dr_ranger.talent_tree_index

WeaveLoadoutSettings.dr_ranger = {
	talent_tree = TalentTrees[var_0_0][var_0_1],
	properties = {},
	traits = {}
}
