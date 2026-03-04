-- chunkname: @scripts/settings/dlcs/celebrate/celebrate_equipment_settings.lua

local var_0_0 = DLCSettings.celebrate

var_0_0.item_master_list_file_names = {
	"scripts/settings/equipment/item_master_list_celebrate"
}
var_0_0.weapon_template_file_names = {
	"scripts/settings/equipment/weapon_templates/beer_bottle",
	"scripts/settings/equipment/weapon_templates/bardin_survival_ale"
}
var_0_0.inventory_package_list = {
	"units/weapons/player/wpn_ale/wpn_ale",
	"units/weapons/player/wpn_ale/wpn_ale_3p",
	"units/weapons/player/wpn_ale/wpn_ale_3ps",
	"units/weapons/player/pup_ale/pup_ale"
}
var_0_0.action_template_file_names = {
	"scripts/unit_extensions/weapons/actions/action_one_time_consumable"
}
var_0_0.action_classes_lookup = {
	one_time_consumable = "ActionOneTimeConsumable"
}
