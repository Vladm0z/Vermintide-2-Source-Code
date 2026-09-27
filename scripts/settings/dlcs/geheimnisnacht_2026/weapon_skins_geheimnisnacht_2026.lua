-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2026/weapon_skins_geheimnisnacht_2026.lua

local tbl = {
	{
		name = "dw_drake_pistol_skin_04_runed_03",
		data = {
			description = "dw_drake_pistol_skin_04_runed_03_description",
			rarity = "unique",
			display_name = "dw_drake_pistol_skin_04_runed_03_name",
			right_hand_unit = "units/weapons/player/wpn_dw_drake_pistol_02_t2/wpn_dw_drake_pistol_02_t2_runed_01",
			inventory_icon = "icons_placeholder",
			left_hand_unit = "units/weapons/player/wpn_dw_drake_pistol_02_t2/wpn_dw_drake_pistol_02_t2_runed_01",
			material_settings_name = "golden_glow",
			template = "brace_of_drakefirepistols_template_1",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_drakefire_pistols"
		}
	},
	{
		name = "we_dual_sword_skin_05_runed_03",
		data = {
			description = "we_dual_sword_skin_05_runed_03_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_we_sword_02_t2/wpn_we_sword_02_t2_runed_01",
			display_name = "we_dual_sword_skin_05_runed_03_name",
			inventory_icon = "icons_placeholder",
			left_hand_unit = "units/weapons/player/wpn_we_sword_02_t2/wpn_we_sword_02_t2_runed_01",
			material_settings_name = "golden_glow",
			template = "dual_wield_swords_template_1",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_dual_weapons"
		}
	},
	{
		name = "es_longbow_skin_05_runed_03",
		data = {
			description = "es_longbow_skin_05_runed_03_description",
			ammo_unit = "units/weapons/player/wpn_emp_arrows/wpn_es_arrow_t1",
			display_name = "es_longbow_skin_05_runed_03_name",
			rarity = "unique",
			inventory_icon = "icons_placeholder",
			left_hand_unit = "units/weapons/player/wpn_emp_bow_05/wpn_emp_bow_05_runed_01",
			material_settings_name = "golden_glow",
			template = "longbow_empire_template",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_longbow"
		}
	},
	{
		name = "wh_brace_of_pistols_skin_05_runed_03",
		data = {
			description = "wh_brace_of_pistols_skin_05_runed_03_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_emp_pistol_03_t2/wpn_emp_pistol_03_t2_runed_01",
			display_name = "wh_brace_of_pistols_skin_05_runed_03_name",
			inventory_icon = "icons_placeholder",
			left_hand_unit = "units/weapons/player/wpn_emp_pistol_03_t2/wpn_emp_pistol_03_t2_runed_01",
			material_settings_name = "golden_glow",
			template = "brace_of_pistols_template_1",
			hud_icon = "weapon_generic_icon_brace_of_pistol",
			display_unit = "units/weapons/weapon_display/display_pistols"
		}
	},
	{
		name = "bw_1h_sword_skin_02_runed_03",
		data = {
			description = "bw_1h_sword_skin_02_runed_03_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_brw_sword_01_t2/wpn_brw_sword_01_t2_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icons_placeholder",
			display_name = "bw_1h_sword_skin_02_runed_03_name",
			material_settings_name = "golden_glow",
			template = "one_handed_swords_template_1",
			display_unit = "units/weapons/weapon_display/display_1h_swords_wizard"
		}
	}
}
local tbl_2 = {
	dr_drake_pistol_skins = {
		unique = {
			"dw_drake_pistol_skin_04_runed_03"
		}
	},
	we_dual_wield_swords_skins = {
		unique = {
			"we_dual_sword_skin_05_runed_03"
		}
	},
	es_longbow_skins = {
		unique = {
			"es_longbow_skin_05_runed_03"
		}
	},
	wh_brace_of_pistols_skins = {
		unique = {
			"wh_brace_of_pistols_skin_05_runed_03"
		}
	},
	bw_sword_skins = {
		unique = {
			"bw_1h_sword_skin_02_runed_03"
		}
	}
}

for i, v in ipairs(tbl) do
	WeaponSkins.skins[v.name] = v.data
end

for k, v_2 in pairs(tbl_2) do
	if not WeaponSkins.skin_combinations[k] then
		WeaponSkins.skin_combinations[k] = {}
	end

	for k_2, v_3 in pairs(v_2) do
		if not WeaponSkins.skin_combinations[k][k_2] then
			WeaponSkins.skin_combinations[k][k_2] = {}
		end

		for i_2, v_4 in ipairs(v_3) do
			WeaponSkins.skin_combinations[k][k_2][#WeaponSkins.skin_combinations[k][k_2] + 1] = v_4
		end
	end
end
