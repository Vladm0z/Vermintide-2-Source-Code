-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2026/weapon_skins_geheimnisnacht_2026.lua

local var_0_0 = {
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
local var_0_1 = {
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
