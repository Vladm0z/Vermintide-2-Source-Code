-- chunkname: @scripts/settings/dlcs/karak_azgaraz/karak_azgaraz_common_settings_part_2.lua

local karak_azgaraz_part_2 = DLCSettings.karak_azgaraz_part_2

karak_azgaraz_part_2.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_karak_azgaraz_part_2"
}
karak_azgaraz_part_2.unlock_settings = {
	karak_azgaraz_part_2 = {
		class = "AlwaysUnlocked"
	}
}
karak_azgaraz_part_2.unlock_settings_xb1 = {
	karak_azgaraz_part_2 = {
		class = "AlwaysUnlocked"
	}
}
karak_azgaraz_part_2.unlock_settings_ps4 = {
	CUSA13595_00 = {
		karak_azgaraz_part_2 = {
			class = "AlwaysUnlocked"
		}
	},
	CUSA13645_00 = {
		karak_azgaraz_part_2 = {
			class = "AlwaysUnlocked"
		}
	}
}
karak_azgaraz_part_2.statistics_lookup = {
	"dwarf_towers",
	"dwarf_chain_speed",
	"dwarf_jump_puzzle",
	"dwarf_push"
}
karak_azgaraz_part_2.item_master_list_file_names = {
	"scripts/settings/equipment/item_master_list_karak"
}
