-- chunkname: @scripts/settings/dlcs/skulls_2026/weapon_skins_skulls_2026.lua

local var_0_0 = {
	{
		name = "dw_crossbow_skin_02_runed_04",
		data = {
			description = "dw_crossbow_skin_02_runed_04_description",
			ammo_unit = "units/weapons/player/wpn_crossbow_quiver/wpn_crossbow_bolt",
			display_name = "dw_crossbow_skin_02_runed_04_name",
			rarity = "unique",
			inventory_icon = "icon_wpn_dw_crossbow_skin_02_runed_04",
			left_hand_unit = "units/weapons/player/wpn_dw_xbow_01_t2/wpn_dw_xbow_01_t2_runed_01",
			material_settings_name = "deep_crimson",
			template = "crossbow_template_1",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_1h_crossbow"
		}
	},
	{
		name = "we_longbow_skin_05_runed_04",
		data = {
			description = "we_longbow_skin_05_runed_04_description",
			ammo_unit = "units/weapons/player/wpn_we_quiver_t1/wpn_we_arrow_t1",
			display_name = "we_longbow_skin_05_runed_04_name",
			rarity = "unique",
			inventory_icon = "icon_wpn_we_longbow_skin_05_runed_04",
			left_hand_unit = "units/weapons/player/wpn_we_bow_03_t1/wpn_we_bow_03_t1_runed_01",
			material_settings_name = "deep_crimson",
			template = "longbow_template_1",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_bow"
		}
	},
	{
		name = "es_blunderbuss_skin_04_runed_04",
		data = {
			description = "es_blunderbuss_skin_04_runed_04_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_empire_blunderbuss_t2/wpn_empire_blunderbuss_t2_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_es_blunderbuss_skin_04_runed_04",
			material_settings_name = "deep_crimson",
			display_name = "es_blunderbuss_skin_04_runed_04_name",
			template = "blunderbuss_template_1",
			display_unit = "units/weapons/weapon_display/display_blunderbusses",
			action_anim_overrides = {
				animation_variation_id = 0
			}
		}
	},
	{
		name = "es_1h_flail_skin_05_runed_04",
		data = {
			description = "es_1h_flail_skin_05_runed_04_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_emp_flail_05_t1/wpn_emp_flail_05_t1_runed_01",
			hud_icon = "weapon_generic_icon_mace",
			inventory_icon = "icon_wpn_es_1h_flail_skin_05_runed_04",
			display_name = "es_1h_flail_skin_05_runed_04_name",
			material_settings_name = "deep_crimson",
			template = "one_handed_flail_template_1",
			display_unit = "units/weapons/weapon_display/display_1h_flail"
		}
	},
	{
		name = "bw_dagger_skin_05_runed_04",
		data = {
			description = "bw_dagger_skin_05_runed_04_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_brw_dagger_05/wpn_brw_dagger_05_runed_01",
			hud_icon = "weapon_generic_icon_daggers",
			inventory_icon = "icon_wpn_bw_dagger_skin_05_runed_04",
			display_name = "bw_dagger_skin_05_runed_04_name",
			material_settings_name = "deep_crimson",
			template = "one_handed_daggers_template_1",
			display_unit = "units/weapons/weapon_display/display_1h_dagger_wizard"
		}
	}
}
local var_0_1 = {
	dr_crossbow_skins = {
		unique = {
			"dw_crossbow_skin_02_runed_04"
		}
	},
	we_longbow_skins = {
		unique = {
			"we_longbow_skin_05_runed_04"
		}
	},
	es_blunderbuss_skins = {
		unique = {
			"es_blunderbuss_skin_04_runed_04"
		}
	},
	es_1h_flail_skins = {
		unique = {
			"es_1h_flail_skin_05_runed_04"
		}
	},
	bw_dagger_skins = {
		unique = {
			"bw_dagger_skin_05_runed_04"
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
