-- chunkname: @scripts/settings/dlcs/bless/bless_sound_settings.lua

local var_0_0 = DLCSettings.bless

var_0_0.dialogue_lookup = {
	"dialogues/generated/lookup_witch_hunter_bless",
	"dialogues/generated/lookup_dlc_bless"
}
var_0_0.dialogue_settings = {
	inn_level = {
		"dialogues/generated/dlc_bless"
	},
	inn_level_halloween = {
		"dialogues/generated/dlc_bless"
	},
	inn_level_skulls = {
		"dialogues/generated/dlc_bless"
	},
	inn_level_sonnstill = {
		"dialogues/generated/dlc_bless"
	},
	morris_hub = {
		"dialogues/generated/dlc_bless"
	}
}
var_0_0.dialogue_events = {
	"activate_fury"
}
var_0_0.auto_load_files = {
	"dialogues/generated/witch_hunter_bless"
}
var_0_0.network_sound_events = {
	"career_talent_priest_bolt_cast",
	"career_talent_priest_bolt_impact",
	"career_ability_priest_cast_t1",
	"career_ability_priest_cast_t2",
	"career_ability_priest_cast_t3",
	"career_ability_priest_shield_start",
	"career_ability_priest_shield_end",
	"career_ability_priest_buff_power",
	"career_ability_priest_buff_shield",
	"career_ability_priest_buildup",
	"career_ability_priest_buildup_stop",
	"career_ability_priest_buildup_husk",
	"career_ability_priest_buildup_husk_stop",
	"career_ability_priest_explosion",
	"activate_ability",
	"activate_fury",
	"career_priest_fury_start",
	"career_priest_fury_stop",
	"career_priest_fury_smite",
	"career_priest_fury_smite_husk",
	"career_priest_fury_ready"
}
