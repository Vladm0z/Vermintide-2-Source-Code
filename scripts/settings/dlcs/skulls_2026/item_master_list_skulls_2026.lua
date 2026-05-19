-- chunkname: @scripts/settings/dlcs/skulls_2026/item_master_list_skulls_2026.lua

ItemMasterList.dw_crossbow_skin_02_runed_04 = {
	hud_icon = "weapon_generic_icon_staff_3",
	rarity = "unique",
	template = "crossbow_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "dr_crossbow",
	can_wield = {
		"dr_ironbreaker",
		"dr_ranger"
	}
}
ItemMasterList.we_longbow_skin_05_runed_04 = {
	hud_icon = "weapon_generic_icon_staff_3",
	rarity = "unique",
	template = "longbow_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "we_longbow",
	can_wield = {
		"we_shade",
		"we_maidenguard",
		"we_waywatcher"
	}
}
ItemMasterList.es_blunderbuss_skin_04_runed_04 = {
	hud_icon = "weapon_generic_icon_staff_3",
	rarity = "unique",
	template = "blunderbuss_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "es_blunderbuss",
	can_wield = {
		"es_huntsman",
		"es_knight",
		"es_mercenary"
	}
}
ItemMasterList.es_1h_flail_skin_05_runed_04 = {
	hud_icon = "weapon_generic_icon_mace",
	rarity = "unique",
	template = "one_handed_flail_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "es_1h_flail",
	can_wield = {
		"wh_zealot",
		"wh_captain",
		"wh_bountyhunter"
	}
}
ItemMasterList.bw_dagger_skin_05_runed_04 = {
	hud_icon = "weapon_generic_icon_daggers",
	rarity = "unique",
	template = "one_handed_daggers_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "bw_dagger",
	can_wield = {
		"bw_scholar",
		"bw_adept",
		"bw_unchained"
	}
}
ItemMasterList.frame_skulls_2026 = {
	description = "frame_skulls_2026_description",
	temporary_template = "frame_skulls_2026",
	display_name = "frame_skulls_2026_name",
	hud_icon = "unit_frame_02",
	inventory_icon = "icon_portrait_frame_skulls_2026",
	slot_type = "frame",
	information_text = "information_text_frame",
	rarity = "promo",
	display_unit = "units/weapons/weapon_display/display_portrait_frame",
	item_type = "frame",
	can_wield = CanWieldAllItemTemplates,
	events = {
		"skulls",
		"dwarf_fest"
	}
}
