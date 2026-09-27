-- chunkname: @scripts/settings/weaves/weave_loadout/weave_loadout_settings_we_maidenguard.lua

local WeaveLoadoutSettings = WeaveLoadoutSettings

WeaveLoadoutSettings = WeaveLoadoutSettings or {}
WeaveLoadoutSettings = WeaveLoadoutSettings

local str = "wood_elf"
local talent_tree_index = CareerSettings.we_maidenguard.talent_tree_index

WeaveLoadoutSettings.we_maidenguard = {
	talent_tree = TalentTrees[str][talent_tree_index],
	properties = {},
	traits = {}
}
