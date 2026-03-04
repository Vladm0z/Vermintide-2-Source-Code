-- chunkname: @scripts/settings/dlcs/belladonna/belladonna_common_settings.lua

local var_0_0 = DLCSettings.belladonna

var_0_0.husk_lookup = {
	"units/beings/enemies/beastmen_gor/chr_beastmen_gor",
	"units/beings/enemies/beastmen_ungor/chr_beastmen_ungor",
	"units/beings/enemies/beastmen_ungor_archer/chr_beastmen_ungor_archer",
	"units/beings/enemies/beastmen_bestigor/chr_beastmen_bestigor",
	"units/beings/enemies/beastmen_standard_bearer/chr_beastmen_standard_bearer",
	"units/weapons/enemy/wpn_bm_standard_01/wpn_bm_standard_01_placed",
	"units/weapons/enemy/wpn_bm_ungor_set_01/wpn_bm_ungor_arrow_01_3p"
}
var_0_0.material_effect_mappings_file_names = {
	"scripts/settings/material_effect_mappings_beastmen"
}
var_0_0.hit_effects = {
	"scripts/settings/hit_effects/hit_effects_beastmen_gor",
	"scripts/settings/hit_effects/hit_effects_beastmen_ungor"
}
var_0_0.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_belladonna"
}
