-- chunkname: @scripts/settings/dlcs/skulls_2025/weapon_skins_skulls_2025.lua

local tbl = {
	{
		name = "dw_dual_axe_skin_06_runed_04",
		data = {
			description = "dw_dual_axe_skin_06_runed_04_description",
			rarity = "unique",
			display_name = "dw_dual_axe_skin_06_runed_04_name",
			right_hand_unit = "units/weapons/player/wpn_dw_axe_03_t2/wpn_dw_axe_03_t2_runed_01",
			inventory_icon = "icon_wpn_dw_axe_03_t2_dual",
			left_hand_unit = "units/weapons/player/wpn_dw_axe_03_t2/wpn_dw_axe_03_t2_runed_01",
			material_settings_name = "deep_crimson",
			template = "dual_wield_axes_template_1",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_dual_axes"
		}
	},
	{
		name = "we_spear_skin_03_runed_04",
		data = {
			description = "we_spear_skin_03_runed_04_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_we_spear_03/wpn_we_spear_03_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_we_spear_03",
			display_name = "we_spear_skin_03_runed_04_name",
			material_settings_name = "deep_crimson",
			template = "two_handed_spears_elf_template_1",
			display_unit = "units/weapons/weapon_display/display_2h_spears_wood_elf"
		}
	},
	{
		name = "es_halberd_skin_04_runed_04",
		data = {
			description = "es_halberd_skin_04_runed_04_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_wh_halberd_04/wpn_wh_halberd_04_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_wh_halberd_04",
			display_name = "es_halberd_skin_04_runed_04_name",
			material_settings_name = "deep_crimson",
			template = "two_handed_halberds_template_1",
			display_unit = "units/weapons/weapon_display/display_2h_halberds"
		}
	},
	{
		name = "bw_flamethrower_staff_skin_02_runed_04",
		data = {
			description = "bw_flamethrower_staff_skin_02_runed_04_description",
			rarity = "unique",
			display_name = "bw_flamethrower_staff_skin_02_runed_04_name",
			right_hand_unit = "units/weapons/player/wpn_brw_flame_staff_02/wpn_brw_flame_staff_02_runed_01",
			inventory_icon = "icon_wpn_brw_flame_staff_02",
			left_hand_unit = "units/weapons/player/wpn_fireball/wpn_fireball",
			material_settings_name = "deep_crimson",
			template = "staff_flamethrower_template",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_staff"
		}
	},
	{
		name = "wh_repeating_crossbow_skin_03_runed_04",
		data = {
			description = "wh_repeating_crossbow_skin_03_runed_04_description",
			ammo_unit = "units/weapons/player/wpn_crossbow_quiver/wpn_crossbow_bolt_pile",
			display_name = "wh_repeating_crossbow_skin_03_runed_04_name",
			rarity = "unique",
			inventory_icon = "icon_wpn_wh_repeater_crossbow_t3",
			left_hand_unit = "units/weapons/player/wpn_wh_repeater_crossbow_t3/wpn_wh_repeater_crossbow_t3_runed_01",
			material_settings_name = "deep_crimson",
			template = "repeating_crossbow_template_1",
			ammo_unit_3p = "units/weapons/player/wpn_crossbow_quiver/wpn_crossbow_bolt_3p",
			hud_icon = "weapon_generic_icon_fencing_sword",
			display_unit = "units/weapons/weapon_display/display_1h_crossbow"
		}
	}
}
local tbl_2 = {
	dr_dual_wield_axes_skins = {
		unique = {
			"dw_dual_axe_skin_06_runed_04"
		}
	},
	we_spear_skins = {
		unique = {
			"we_spear_skin_03_runed_04"
		}
	},
	es_halberd_skins = {
		unique = {
			"es_halberd_skin_04_runed_04"
		}
	},
	bw_skullstaff_flamethrower_skins = {
		unique = {
			"bw_flamethrower_staff_skin_02_runed_04"
		}
	},
	wh_crossbow_repeater_skins = {
		unique = {
			"wh_repeating_crossbow_skin_03_runed_04"
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
