-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_wh_bountyhunter.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = WeaveLoadoutSettings or {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local str = "witch_hunter"
local talent_tree_index = CareerSettings.wh_bountyhunter.talent_tree_index

WeaveLoadoutSettings.wh_bountyhunter = {
	talent_tree = TalentTrees[str][talent_tree_index],
	properties = {},
	traits = {}
}
