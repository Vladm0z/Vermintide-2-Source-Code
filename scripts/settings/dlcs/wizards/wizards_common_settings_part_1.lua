-- chunkname: @scripts/settings/dlcs/wizards/wizards_common_settings_part_1.lua

local var_0_0 = DLCSettings.wizards_part_1

var_0_0.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_wizards_part_1"
}
var_0_0.unlock_settings = {
	wizards_part_1 = {
		class = "AlwaysUnlocked"
	}
}
var_0_0.unlock_settings_xb1 = {
	wizards_part_1 = {
		class = "AlwaysUnlocked"
	}
}
var_0_0.unlock_settings_ps4 = {
	CUSA13595_00 = {
		wizards_part_1 = {
			class = "AlwaysUnlocked"
		}
	},
	CUSA13645_00 = {
		wizards_part_1 = {
			class = "AlwaysUnlocked"
		}
	}
}
var_0_0.entity_extensions = {
	"scripts/unit_extensions/wizards/trail_urn_alignment_extension"
}
var_0_0.entity_system_params = {
	trail_urn_alignment = {
		system_class_name = "ExtensionSystemBase",
		system_name = "trail_urn_alignment_system",
		extension_list = {
			"TrailUrnAlignmentExtension"
		}
	}
}
var_0_0.network_go_types = {
	"trail_cog_pickup_projectile_unit_limited"
}
var_0_0.statistics_lookup = {
	"trail_cog_strike",
	"trail_shatterer",
	"trail_sleigher",
	"trail_beacons_are_lit",
	"trail_bonfire_watch_tower",
	"trail_bonfire_river_path",
	"trail_bonfire_lookout_point"
}
var_0_0.interactions = {
	"trail_light_urn"
}
var_0_0.interactions_filenames = {
	"scripts/settings/dlcs/wizards/wizards_interactions"
}
var_0_0.anim_lookup = {
	"interaction_torch"
}
