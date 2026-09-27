-- chunkname: @scripts/settings/dlcs/karak_azgaraz/karak_azgaraz_achievement_settings_part_2.lua

local karak_azgaraz_part_2 = DLCSettings.karak_azgaraz_part_2

karak_azgaraz_part_2.achievement_outline = {
	levels = {
		entries = {},
		categories = {
			{
				sorting = 8,
				name = "area_selection_karak_azgaraz_name",
				entries = {
					"dwarf_towers",
					"dwarf_chain_speed",
					"dwarf_jump_puzzle",
					"dwarf_push",
					"karak_azgaraz_complete_dlc_dwarf_exterior_recruit",
					"karak_azgaraz_complete_dlc_dwarf_exterior_veteran",
					"karak_azgaraz_complete_dlc_dwarf_exterior_champion",
					"karak_azgaraz_complete_dlc_dwarf_exterior_legend",
					"karak_azgaraz_complete_dlc_dwarf_exterior_cataclysm",
					"exterior_all_challenges"
				}
			}
		}
	}
}
karak_azgaraz_part_2.achievement_template_file_names = {
	"scripts/managers/achievements/achievement_templates_karak_azgaraz_part_2"
}
