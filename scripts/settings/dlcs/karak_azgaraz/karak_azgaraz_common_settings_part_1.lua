-- chunkname: @scripts/settings/dlcs/karak_azgaraz/karak_azgaraz_common_settings_part_1.lua

local karak_azgaraz_part_1 = DLCSettings.karak_azgaraz_part_1

karak_azgaraz_part_1.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_karak_azgaraz_part_1"
}
karak_azgaraz_part_1.statistics_lookup = {
	"dwarf_valaya_emote",
	"dwarf_rune",
	"dwarf_barrel_carry",
	"dwarf_bells",
	"dwarf_pressure"
}
karak_azgaraz_part_1.unlock_settings = {
	karak_azgaraz_part_1 = {
		class = "AlwaysUnlocked"
	}
}
karak_azgaraz_part_1.unlock_settings_xb1 = {
	karak_azgaraz_part_1 = {
		class = "AlwaysUnlocked"
	}
}
karak_azgaraz_part_1.unlock_settings_ps4 = {
	CUSA13595_00 = {
		karak_azgaraz_part_1 = {
			class = "AlwaysUnlocked"
		}
	},
	CUSA13645_00 = {
		karak_azgaraz_part_1 = {
			class = "AlwaysUnlocked"
		}
	}
}
karak_azgaraz_part_1.item_master_list_file_names = {
	"scripts/settings/equipment/item_master_list_karak"
}
