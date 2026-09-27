-- chunkname: @scripts/settings/dlcs/penny/penny_common_settings_part_1.lua

local penny_part_1 = DLCSettings.penny_part_1

penny_part_1.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_penny_part_1"
}
penny_part_1.unlock_settings_xb1 = {
	penny = {
		class = "AlwaysUnlocked"
	}
}
penny_part_1.unlock_settings_ps4 = {
	CUSA13595_00 = {
		penny = {
			class = "AlwaysUnlocked"
		}
	},
	CUSA13645_00 = {
		penny = {
			class = "AlwaysUnlocked"
		}
	}
}
