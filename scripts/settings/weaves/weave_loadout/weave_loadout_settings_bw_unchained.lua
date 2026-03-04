-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_bw_unchained.lua

WeaveLoadoutSettings = WeaveLoadoutSettings or {}

local var_0_0 = "bright_wizard"
local var_0_1 = CareerSettings.bw_unchained.talent_tree_index

WeaveLoadoutSettings.bw_unchained = {
	talent_tree = TalentTrees[var_0_0][var_0_1],
	properties = {},
	traits = {}
}
