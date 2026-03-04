-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_wh_captain.lua

WeaveLoadoutSettings = WeaveLoadoutSettings or {}

local var_0_0 = "witch_hunter"
local var_0_1 = CareerSettings.wh_captain.talent_tree_index

WeaveLoadoutSettings.wh_captain = {
	talent_tree = TalentTrees[var_0_0][var_0_1],
	properties = {},
	traits = {}
}
