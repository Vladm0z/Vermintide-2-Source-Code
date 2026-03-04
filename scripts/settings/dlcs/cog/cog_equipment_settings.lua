-- chunkname: @scripts/settings/dlcs/cog/cog_equipment_settings.lua

local var_0_0 = DLCSettings.cog

var_0_0.item_master_list_file_names = {
	"scripts/settings/dlcs/cog/item_master_list_cog"
}
var_0_0.weapon_skins_file_names = {
	"scripts/settings/dlcs/cog/weapon_skins_cog"
}
var_0_0.cosmetics_files = {
	"scripts/settings/dlcs/cog/cosmetics_cog"
}
var_0_0.weapon_template_file_names = {
	"scripts/settings/equipment/weapon_templates/bardin_engineer_career_skill",
	"scripts/settings/equipment/weapon_templates/2h_cog_hammers",
	"scripts/settings/equipment/weapon_templates/heavy_steam_pistol"
}
var_0_0.default_items = {
	dr_2h_cog_hammer = {
		inventory_icon = "icon_wpn_dw_coghammer_01_t1",
		description = "description_default_dwarf_ranger_dr_2h_hammer",
		display_name = "dr_2h_cog_hammer_blacksmith_name"
	},
	dr_steam_pistol = {
		inventory_icon = "icon_wpn_dw_steam_pistol_01_t1",
		description = "description_default_dwarf_ranger_dr_2h_hammer",
		display_name = "dr_steam_pistol_blacksmith_name"
	}
}
var_0_0.damage_profile_template_files_names = {
	"scripts/settings/equipment/damage_profile_templates_dlc_cog"
}
var_0_0.attack_template_files_names = {}
var_0_0.action_template_file_names = {
	"scripts/settings/dlcs/cog/action_career_dr_engineer",
	"scripts/settings/dlcs/cog/action_career_dr_engineer_charge",
	"scripts/settings/dlcs/cog/action_career_dr_engineer_spin",
	"scripts/settings/dlcs/cog/action_change_mode",
	"scripts/settings/dlcs/cog/action_charged_sweep"
}
var_0_0.action_classes_lookup = {
	career_dr_four = "ActionCareerDREngineer",
	career_dr_four_spin = "ActionCareerDREngineerSpin",
	charged_sweep = "ActionChargedSweep",
	career_dr_four_charge = "ActionCareerDREngineerCharge",
	change_mode = "ActionChangeMode"
}
var_0_0.inventory_package_list = {
	"resource_packages/careers/dr_engineer",
	"units/beings/player/dwarf_ranger_engineer/first_person_base/chr_first_person_mesh",
	"units/beings/player/dwarf_ranger_engineer/third_person_base/chr_third_person_mesh",
	"units/beings/player/dwarf_ranger_engineer/skins/black_and_gold/chr_dwarf_ranger_engineer_black_and_gold",
	"units/beings/player/dwarf_ranger_engineer/skins/blue_and_gold/chr_dwarf_ranger_engineer_blue_and_gold",
	"units/beings/player/dwarf_ranger_engineer/skins/brown_and_iron/chr_dwarf_ranger_engineer_brown_and_iron",
	"units/beings/player/dwarf_ranger_engineer/skins/purple_and_copper/chr_dwarf_ranger_engineer_purple_and_copper",
	"units/beings/player/dwarf_ranger_engineer/skins/white/chr_dwarf_ranger_engineer_white",
	"units/weapons/player/wpn_dw_coghammer_01_t1/wpn_dw_coghammer_01_t1",
	"units/weapons/player/wpn_dw_coghammer_01_t1/wpn_dw_coghammer_01_t1_3p",
	"units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2",
	"units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2_3p",
	"units/weapons/player/wpn_dw_coghammer_01_t1/wpn_dw_coghammer_01_t1_runed",
	"units/weapons/player/wpn_dw_coghammer_01_t1/wpn_dw_coghammer_01_t1_runed_3p",
	"units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2_runed",
	"units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2_runed_3p",
	"units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2_magic",
	"units/weapons/player/wpn_dw_coghammer_01_t2/wpn_dw_coghammer_01_t2_magic_3p",
	"units/weapons/player/wpn_dw_rotary_gun_01_t1/wpn_dw_rotary_gun_01_t1",
	"units/weapons/player/wpn_dw_rotary_gun_01_t1/wpn_dw_rotary_gun_01_t1_3p",
	"units/weapons/player/wpn_dw_rotary_gun_01_t2/wpn_dw_rotary_gun_01_t2",
	"units/weapons/player/wpn_dw_rotary_gun_01_t2/wpn_dw_rotary_gun_01_t2_3p",
	"units/weapons/player/wpn_dw_steam_pistol_01_t1/wpn_dw_steam_pistol_01_t1",
	"units/weapons/player/wpn_dw_steam_pistol_01_t1/wpn_dw_steam_pistol_01_t1_3p",
	"units/weapons/player/wpn_dw_steam_pistol_01_t1/wpn_dw_steam_pistol_01_t1_runed_01",
	"units/weapons/player/wpn_dw_steam_pistol_01_t1/wpn_dw_steam_pistol_01_t1_runed_01_3p",
	"units/weapons/player/wpn_dw_steam_pistol_01_t1/wpn_dw_steam_pistol_01_t1_magic_01",
	"units/weapons/player/wpn_dw_steam_pistol_01_t1/wpn_dw_steam_pistol_01_t1_magic_01_3p",
	"units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2",
	"units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2_3p",
	"units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2_runed_01",
	"units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2_runed_01_3p",
	"units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2_magic_01",
	"units/weapons/player/wpn_dw_steam_pistol_01_t2/wpn_dw_steam_pistol_01_t2_magic_01_3p",
	"units/beings/player/dwarf_ranger_engineer/headpiece/dr_e_hat_01",
	"units/beings/player/dwarf_ranger_engineer/headpiece/dr_e_hat_02",
	"units/beings/player/dwarf_ranger_engineer/headpiece/dr_e_hat_03"
}
