-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_dr_ironbreaker.lua

WeaveLoadoutSettings = WeaveLoadoutSettings or {}

local var_0_0 = "dwarf_ranger"
local var_0_1 = CareerSettings.dr_ironbreaker.talent_tree_index

WeaveLoadoutSettings.dr_ironbreaker = {
	talent_tree = TalentTrees[var_0_0][var_0_1],
	properties = {},
	traits = {}
}
