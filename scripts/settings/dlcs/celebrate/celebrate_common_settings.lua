-- chunkname: @scripts/settings/dlcs/celebrate/celebrate_common_settings.lua

local celebrate = DLCSettings.celebrate

celebrate.unlock_settings = {
	celebrate = {
		class = "AlwaysUnlocked"
	}
}
celebrate.unlock_settings_xb1 = {
	celebrate = {
		class = "AlwaysUnlocked"
	}
}
celebrate.unlock_settings_ps4 = {
	CUSA13595_00 = {
		celebrate = {
			class = "AlwaysUnlocked"
		}
	},
	CUSA13645_00 = {
		celebrate = {
			class = "AlwaysUnlocked"
		}
	}
}
celebrate.husk_lookup = {
	"units/weapons/player/pup_ale/pup_ale"
}
celebrate.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_celebrate"
}
