-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2025/weapon_skins_geheimnisnacht_2025.lua

local var_0_0 = {
	{
		name = "dw_2h_pick_skin_04_runed_03",
		data = {
			description = "dw_2h_pick_skin_04_runed_03_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_dw_pick_01_t4/wpn_dw_pick_01_t4_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_pick_01_t4",
			display_name = "dw_2h_pick_skin_04_runed_03_name",
			material_settings_name = "golden_glow",
			template = "two_handed_picks_template_1",
			display_unit = "units/weapons/weapon_display/display_2h_picks"
		}
	},
	{
		name = "we_2h_sword_skin_06_runed_03",
		data = {
			description = "we_2h_sword_skin_06_runed_03_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_we_2h_sword_03_t2/wpn_we_2h_sword_03_t2_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_we_2h_sword_03_t2",
			display_name = "we_2h_sword_skin_06_runed_03_name",
			material_settings_name = "golden_glow",
			template = "two_handed_swords_wood_elf_template",
			display_unit = "units/weapons/weapon_display/display_2h_swords_wood_elf"
		}
	},
	{
		name = "es_1h_sword_skin_02_runed_03",
		data = {
			description = "es_1h_sword_skin_02_runed_03_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_emp_sword_02_t2/wpn_emp_sword_02_t2_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_emp_sword_02_t2",
			display_name = "es_1h_sword_skin_02_runed_03_name",
			material_settings_name = "golden_glow",
			template = "one_handed_swords_template_1",
			display_unit = "units/weapons/weapon_display/display_1h_swords"
		}
	},
	{
		name = "bw_conflagration_staff_skin_02_runed_03",
		data = {
			description = "bw_conflagration_staff_skin_02_runed_03_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_brw_staff_04/wpn_brw_staff_04_runed_01",
			display_name = "bw_conflagration_staff_skin_02_runed_03_name",
			inventory_icon = "icon_wpn_brw_staff_04",
			left_hand_unit = "units/weapons/player/wpn_fireball/wpn_fireball",
			material_settings_name = "golden_glow",
			template = "staff_fireball_geiser_template_1",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_staff"
		}
	},
	{
		name = "wh_1h_axe_skin_04_runed_03",
		data = {
			description = "wh_1h_axe_skin_04_runed_03_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_axe_03_t2/wpn_axe_03_t2_runed_01",
			hud_icon = "weapon_generic_icon_axe1h",
			inventory_icon = "icon_wpn_axe_03_t2",
			display_name = "wh_1h_axe_skin_04_runed_03_name",
			material_settings_name = "golden_glow",
			template = "one_hand_axe_template_1",
			display_unit = "units/weapons/weapon_display/display_1h_axes"
		}
	}
}
local var_0_1 = {
	dr_2h_pick_skins = {
		unique = {
			"dw_2h_pick_skin_04_runed_03"
		}
	},
	we_2h_sword_skins = {
		unique = {
			"we_2h_sword_skin_06_runed_03"
		}
	},
	es_1h_sword_skins = {
		unique = {
			"es_1h_sword_skin_02_runed_03"
		}
	},
	bw_skullstaff_geiser_skins = {
		unique = {
			"bw_conflagration_staff_skin_02_runed_03"
		}
	},
	wh_1h_axe_skins = {
		unique = {
			"wh_1h_axe_skin_04_runed_03"
		}
	}
}

for iter_0_0, iter_0_1 in ipairs(var_0_0) do
	WeaponSkins.skins[iter_0_1.name] = iter_0_1.data
end

for iter_0_2, iter_0_3 in pairs(var_0_1) do
	if not WeaponSkins.skin_combinations[iter_0_2] then
		WeaponSkins.skin_combinations[iter_0_2] = {}
	end

	for iter_0_4, iter_0_5 in pairs(iter_0_3) do
		if not WeaponSkins.skin_combinations[iter_0_2][iter_0_4] then
			WeaponSkins.skin_combinations[iter_0_2][iter_0_4] = {}
		end

		for iter_0_6, iter_0_7 in ipairs(iter_0_5) do
			WeaponSkins.skin_combinations[iter_0_2][iter_0_4][#WeaponSkins.skin_combinations[iter_0_2][iter_0_4] + 1] = iter_0_7
		end
	end
end
