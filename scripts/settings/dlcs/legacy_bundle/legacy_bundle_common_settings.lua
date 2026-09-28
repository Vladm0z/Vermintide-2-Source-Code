-- chunkname: @scripts/settings/dlcs/legacy_bundle/legacy_bundle_common_settings.lua

local settings = DLCSettings.legacy_bundle

settings.unlock_settings = {
	legacy_bundle = {
		id = "47337",
		class = "UnlockDlcBundle",
		requires_restart = false,
		bundle_contains = {
			"lake",
			"cog",
			"woods",
			"bless",
			"shovel",
			"pre_order",
			"bogenhafen",
			"holly",
			"scorpion",
			"grass"
		}
	}
}
