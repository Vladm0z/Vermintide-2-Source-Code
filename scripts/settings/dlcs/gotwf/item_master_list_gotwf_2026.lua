-- chunkname: @scripts/settings/dlcs/gotwf/item_master_list_gotwf_2026.lua

ItemMasterList.dr_1h_throwing_axes_skin_01_runed_05 = {
	rarity = "unique",
	is_ammo_weapon = true,
	hud_icon = "weapon_generic_icon_falken",
	required_dlc = "scorpion",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	template = "one_handed_throwing_axes_template",
	item_type = "weapon_skin",
	matching_item_key = "dr_1h_throwing_axes",
	can_wield = {
		"dr_slayer",
		"dr_ranger"
	}
}
ItemMasterList.we_1h_spears_shield_skin_01_runed_05 = {
	rarity = "unique",
	hud_icon = "weapon_generic_icon_falken",
	required_dlc = "scorpion",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	template = "one_handed_spears_shield_template",
	item_type = "weapon_skin",
	matching_item_key = "we_1h_spears_shield",
	can_wield = {
		"we_maidenguard"
	}
}
ItemMasterList.es_sword_shield_breton_skin_03_runed_05 = {
	rarity = "unique",
	hud_icon = "weapon_generic_icon_staff_3",
	required_dlc = "lake_upgrade",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	template = "one_handed_sword_shield_template_2",
	item_type = "weapon_skin",
	matching_item_key = "es_sword_shield_breton",
	can_wield = {
		"es_questingknight"
	}
}
ItemMasterList.wh_flail_shield_skin_02_runed_05 = {
	rarity = "unique",
	hud_icon = "weapon_generic_icon_hammer2h",
	required_dlc = "bless",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	template = "one_handed_flail_shield_template",
	item_type = "weapon_skin",
	matching_item_key = "wh_flail_shield",
	can_wield = {
		"wh_priest"
	}
}
ItemMasterList.bw_1h_flail_flaming_skin_01_runed_05 = {
	rarity = "unique",
	hud_icon = "weapon_generic_icon_falken",
	required_dlc = "scorpion",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	template = "one_handed_flails_flaming_template",
	item_type = "weapon_skin",
	matching_item_key = "bw_1h_flail_flaming",
	can_wield = {
		"bw_scholar",
		"bw_adept",
		"bw_unchained"
	}
}
ItemMasterList.dw_2h_axe_skin_06_runed_05 = {
	hud_icon = "weapon_generic_icon_staff_3",
	rarity = "unique",
	template = "two_handed_axes_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "dr_2h_axe",
	can_wield = {
		"dr_ironbreaker",
		"dr_slayer",
		"dr_ranger"
	}
}
ItemMasterList.we_hagbane_skin_04_runed_05 = {
	hud_icon = "weapon_generic_icon_staff_3",
	rarity = "unique",
	template = "shortbow_hagbane_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "we_shortbow_hagbane",
	can_wield = {
		"we_shade",
		"we_maidenguard",
		"we_waywatcher"
	}
}
ItemMasterList.es_1h_mace_shield_skin_03_runed_05 = {
	hud_icon = "weapon_generic_icon_staff_3",
	rarity = "unique",
	template = "one_handed_hammer_shield_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "es_mace_shield",
	can_wield = {
		"es_huntsman",
		"es_knight",
		"es_mercenary"
	}
}
ItemMasterList.wh_repeating_crossbow_skin_03_runed_05 = {
	hud_icon = "weapon_generic_icon_fencing_sword",
	rarity = "unique",
	template = "repeating_crossbow_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "wh_crossbow_repeater",
	can_wield = {
		"wh_zealot",
		"wh_bountyhunter",
		"wh_captain"
	}
}
ItemMasterList.bw_spear_staff_skin_02_runed_05 = {
	hud_icon = "weapon_generic_icon_staff_3",
	rarity = "unique",
	template = "staff_spark_spear_template_1",
	item_type = "weapon_skin",
	slot_type = "weapon_skin",
	information_text = "information_weapon_skin",
	matching_item_key = "bw_skullstaff_spear",
	can_wield = {
		"bw_scholar",
		"bw_adept",
		"bw_unchained"
	}
}
ItemMasterList.frame_gotwf_2026 = {
	description = "frame_gotwf_2026_description",
	temporary_template = "frame_gotwf_2026",
	display_name = "frame_gotwf_2026_name",
	hud_icon = "unit_frame_02",
	inventory_icon = "icon_portrait_frame_gotwf_2026",
	slot_type = "frame",
	information_text = "information_text_frame",
	rarity = "promo",
	display_unit = "units/weapons/weapon_display/display_portrait_frame",
	item_type = "frame",
	can_wield = CanWieldAllItemTemplates,
	events = {
		"gotwf",
		"dwarf_fest"
	}
}
