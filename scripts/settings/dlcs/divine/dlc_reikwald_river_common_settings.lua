-- chunkname: @scripts/settings/dlcs/divine/dlc_reikwald_river_common_settings.lua

local var_0_0 = DLCSettings.divine

var_0_0.unlock_settings = {
	divine = {
		class = "AlwaysUnlocked"
	}
}
var_0_0.unlock_settings_xb1 = {
	divine = {
		class = "AlwaysUnlocked"
	}
}
var_0_0.unlock_settings_ps4 = {
	CUSA13595_00 = {
		divine = {
			class = "AlwaysUnlocked"
		}
	},
	CUSA13645_00 = {
		divine = {
			class = "AlwaysUnlocked"
		}
	}
}
var_0_0.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_divine"
}
var_0_0.statistics_lookup = {
	"divine_nautical_miles_challenge",
	"divine_anchor_challenge",
	"divine_sink_ships_challenge",
	"divine_cannon_challenge",
	"divine_chaos_warrior_challenge"
}
var_0_0.item_master_list_file_names = {
	"scripts/settings/dlcs/divine/item_master_list_divine"
}
var_0_0.ui_portrait_frame_settings = {
	frame_divine = {
		{
			texture = "portrait_frame_divine",
			layer = 10,
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	frame_tyot_creator = {
		{
			texture = "portrait_frame_tyot_creator",
			layer = 10,
			color = {
				255,
				255,
				255,
				255
			}
		}
	}
}
