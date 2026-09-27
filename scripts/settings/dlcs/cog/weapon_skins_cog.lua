-- chunkname: @scripts/settings/dlcs/cog/weapon_skins_cog.lua

local tbl = {
	{
		name = "dr_2h_cog_hammer_skin_01",
		data = {
			description = "dr_cog_hammer_skin_01_description",
			rarity = "common",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_2h_hammers",
			inventory_icon = "icon_wpn_dw_coghammer_01_t1",
			display_name = "dr_cog_hammer_skin_01_name",
			right_hand_unit = "units/weapons/player/wpn_dw_coghammer_01_t1/wpn_dw_coghammer_01_t1",
			template = "two_handed_cog_hammers_template_1"
		}
	},
	{
		name = "dr_2h_cog_hammer_skin_02",
		data = {
			description = "dr_cog_hammer_skin_02_description",
			rarity = "rare",
			right_hand_unit = "units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_coghammer_01_t2",
			display_name = "dr_cog_hammer_skin_02_name",
			template = "two_handed_cog_hammers_template_1",
			display_unit = "units/weapons/weapon_display/display_2h_hammers",
			action_anim_overrides = {
				animation_variation_id = 1
			}
		}
	},
	{
		name = "dr_2h_cog_hammer_skin_02_magic_01",
		data = {
			description = "dr_cog_hammer_skin_02_magic_01_description",
			rarity = "magic",
			right_hand_unit = "units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2_magic",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_coghammer_01_t2_magic",
			material_settings_name = "weaves",
			display_name = "dr_cog_hammer_skin_02_magic_01_name",
			template = "two_handed_cog_hammers_template_1",
			display_unit = "units/weapons/weapon_display/display_2h_hammers",
			action_anim_overrides = {
				animation_variation_id = 1
			}
		}
	},
	{
		name = "dr_2h_cog_hammer_skin_01_runed_01",
		data = {
			description = "dr_cog_hammer_skin_01_runed_01_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_dw_coghammer_01_t1/wpn_dw_coghammer_01_t1_runed",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_coghammer_01_t1_runed_01",
			display_name = "dr_cog_hammer_skin_01_runed_01_name",
			material_settings_name = "blue_glow",
			template = "two_handed_cog_hammers_template_1",
			display_unit = "units/weapons/weapon_display/display_2h_hammers"
		}
	},
	{
		name = "dr_2h_cog_hammer_skin_01_runed_02",
		data = {
			description = "dr_cog_hammer_skin_01_runed_02_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_dw_coghammer_01_t1/wpn_dw_coghammer_01_t1_runed",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_coghammer_01_t1_runed_02",
			display_name = "dr_cog_hammer_skin_01_runed_02_name",
			material_settings_name = "purple_glow",
			template = "two_handed_cog_hammers_template_1",
			display_unit = "units/weapons/weapon_display/display_2h_hammers"
		}
	},
	{
		name = "dr_2h_cog_hammer_skin_02_runed_01",
		data = {
			description = "dr_cog_hammer_skin_02_runed_01_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2_runed",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_coghammer_01_t2_runed_01",
			material_settings_name = "blue_glow",
			display_name = "dr_cog_hammer_skin_02_runed_01_name",
			template = "two_handed_cog_hammers_template_1",
			display_unit = "units/weapons/weapon_display/display_2h_hammers",
			action_anim_overrides = {
				animation_variation_id = 1
			}
		}
	},
	{
		name = "dr_2h_cog_hammer_skin_02_runed_02",
		data = {
			description = "dr_cog_hammer_skin_02_runed_02_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2_runed",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_coghammer_01_t2_runed_02",
			material_settings_name = "purple_glow",
			display_name = "dr_cog_hammer_skin_02_runed_02_name",
			template = "two_handed_cog_hammers_template_1",
			display_unit = "units/weapons/weapon_display/display_2h_hammers",
			action_anim_overrides = {
				animation_variation_id = 1
			}
		}
	},
	{
		name = "dr_steam_pistol_skin_01",
		data = {
			description = "dr_steam_pistol_skin_01_description",
			rarity = "common",
			hud_icon = "weapon_generic_icon_staff_3",
			display_unit = "units/weapons/weapon_display/display_drakefire_pistols",
			inventory_icon = "icon_wpn_dw_steam_pistol_01_t1",
			display_name = "dr_steam_pistol_skin_01_name",
			right_hand_unit = "units/weapons/player/wpn_dw_steam_pistol_01_t1/wpn_dw_steam_pistol_01_t1",
			template = "heavy_steam_pistol_template_1"
		}
	},
	{
		name = "dr_steam_pistol_skin_02",
		data = {
			description = "dr_steam_pistol_skin_02_description",
			rarity = "rare",
			right_hand_unit = "units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_steam_pistol_01_t2",
			display_name = "dr_steam_pistol_skin_02_name",
			template = "heavy_steam_pistol_template_1",
			display_unit = "units/weapons/weapon_display/display_drakefire_pistols",
			action_anim_overrides = {
				animation_variation_id = 1
			}
		}
	},
	{
		name = "dr_steam_pistol_01_t2_magic_01",
		data = {
			description = "dr_steam_pistol_skin_02_magic_01_description",
			rarity = "magic",
			right_hand_unit = "units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2_magic_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_steam_pistol_01_t2_magic",
			material_settings_name = "weaves",
			display_name = "dr_steam_pistol_skin_02_magic_01_name",
			template = "heavy_steam_pistol_template_1",
			display_unit = "units/weapons/weapon_display/display_drakefire_pistols",
			action_anim_overrides = {
				animation_variation_id = 1
			}
		}
	},
	{
		name = "dr_steam_pistol_skin_01_runed_01",
		data = {
			description = "dr_steam_pistol_skin_01_runed_01_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_dw_steam_pistol_01_t1/wpn_dw_steam_pistol_01_t1_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_steam_pistol_01_t1_runed_01",
			display_name = "dr_steam_pistol_skin_01_runed_01_name",
			material_settings_name = "blue_glow",
			template = "heavy_steam_pistol_template_1",
			display_unit = "units/weapons/weapon_display/display_drakefire_pistols"
		}
	},
	{
		name = "dr_steam_pistol_skin_01_runed_02",
		data = {
			description = "dr_steam_pistol_skin_01_runed_02_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_dw_steam_pistol_01_t1/wpn_dw_steam_pistol_01_t1_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_steam_pistol_01_t1_runed_02",
			display_name = "dr_steam_pistol_skin_01_runed_02_name",
			material_settings_name = "purple_glow",
			template = "heavy_steam_pistol_template_1",
			display_unit = "units/weapons/weapon_display/display_drakefire_pistols"
		}
	},
	{
		name = "dr_steam_pistol_skin_02_runed_01",
		data = {
			description = "dr_steam_pistol_skin_02_runed_01_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_steam_pistol_01_t2_runed_01",
			material_settings_name = "blue_glow",
			display_name = "dr_steam_pistol_skin_02_runed_01_name",
			template = "heavy_steam_pistol_template_1",
			display_unit = "units/weapons/weapon_display/display_drakefire_pistols",
			action_anim_overrides = {
				animation_variation_id = 1
			}
		}
	},
	{
		name = "dr_steam_pistol_skin_02_runed_02",
		data = {
			description = "dr_steam_pistol_skin_02_runed_02_description",
			rarity = "unique",
			right_hand_unit = "units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2_runed_01",
			hud_icon = "weapon_generic_icon_staff_3",
			inventory_icon = "icon_wpn_dw_steam_pistol_01_t2_runed_02",
			material_settings_name = "purple_glow",
			display_name = "dr_steam_pistol_skin_02_runed_02_name",
			template = "heavy_steam_pistol_template_1",
			display_unit = "units/weapons/weapon_display/display_drakefire_pistols",
			action_anim_overrides = {
				animation_variation_id = 1
			}
		}
	}
}
local tbl_2 = {
	dr_2h_cog_hammer_skins = {
		common = {
			"dr_2h_cog_hammer_skin_01"
		},
		rare = {
			"dr_2h_cog_hammer_skin_02"
		},
		exotic = {},
		unique = {
			"dr_2h_cog_hammer_skin_01_runed_01",
			"dr_2h_cog_hammer_skin_01_runed_02",
			"dr_2h_cog_hammer_skin_02_runed_01",
			"dr_2h_cog_hammer_skin_02_runed_02"
		},
		magic = {
			"dr_2h_cog_hammer_skin_02_magic_01"
		}
	},
	dr_steam_pistol_skins = {
		common = {
			"dr_steam_pistol_skin_01"
		},
		rare = {
			"dr_steam_pistol_skin_02"
		},
		exotic = {},
		unique = {
			"dr_steam_pistol_skin_01_runed_01",
			"dr_steam_pistol_skin_01_runed_02",
			"dr_steam_pistol_skin_02_runed_01",
			"dr_steam_pistol_skin_02_runed_02"
		},
		magic = {
			"dr_steam_pistol_01_t2_magic_01"
		}
	}
}
local tbl_3 = {
	dr_2h_cog_hammer = "dr_2h_cog_hammer_skin_01",
	dr_steam_pistol = "dr_steam_pistol_skin_01"
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

for k_3, v_5 in pairs(tbl_3) do
	WeaponSkins.default_skins[k_3] = v_5
end
