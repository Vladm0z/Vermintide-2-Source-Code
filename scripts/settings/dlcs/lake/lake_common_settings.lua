-- chunkname: @scripts/settings/dlcs/lake/lake_common_settings.lua

local var_0_0 = DLCSettings.lake

var_0_0.career_setting_files = {
	"scripts/settings/dlcs/lake/career_settings_lake"
}
var_0_0.player_breeds = {
	"scripts/settings/dlcs/lake/player_breeds_lake"
}
var_0_0.career_ability_settings = {
	"scripts/settings/dlcs/lake/passive_ability_questing_knight",
	"scripts/settings/dlcs/lake/career_ability_settings_lake"
}
var_0_0.action_template_files = {
	"scripts/settings/dlcs/lake/action_templates_lake"
}
var_0_0.talent_settings = {
	"scripts/settings/dlcs/lake/talent_settings_lake_empire_soldier"
}
var_0_0.profile_files = {
	"scripts/settings/dlcs/lake/lake_profiles"
}
var_0_0.challenge_categories = {
	"questing_knight"
}
var_0_0.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_lake"
}
var_0_0.statistics_lookup = {
	"lake_mission_streak_act1_legend_es_questingknight",
	"lake_mission_streak_act2_legend_es_questingknight",
	"lake_mission_streak_act3_legend_es_questingknight",
	"lake_boss_killblow",
	"lake_charge_stagger",
	"lake_bastard_block",
	"lake_untouchable",
	"lake_speed_quest",
	"lake_timing_quest",
	"complete_all_grailknight_challenges"
}
var_0_0.anim_lookup = {
	"swap_charge_stance",
	"holding_right_charge"
}
var_0_0.effects = {
	"fx/grail_knight_active_ability"
}
var_0_0.unlock_settings = {
	lake = {
		id = "1343500",
		class = "UnlockDlc",
		requires_restart = true
	},
	lake_upgrade = {
		id = "1345990",
		class = "UnlockDlc",
		requires_restart = true
	}
}
var_0_0.unlock_settings_xb1 = {
	lake = {
		id = "52544E39-5A56-305A-C058-52563853C200",
		backend_reward_id = "lake",
		class = "UnlockDlc",
		requires_restart = true
	},
	lake_upgrade = {
		id = "52544E39-5A56-305A-C058-52563853C200",
		backend_reward_id = "lake_upgrade",
		class = "UnlockDlc"
	}
}
var_0_0.unlock_settings_ps4 = {
	CUSA13595_00 = {
		lake = {
			product_label = "V2USGRAILKNIGHTK",
			backend_reward_id = "lake",
			class = "UnlockDlc",
			requires_restart = true,
			id = "7f6d2826dc0b4c23b28f56e169af41f6"
		},
		lake_upgrade = {
			id = "7f6d2826dc0b4c23b28f56e169af41f6",
			product_label = "V2USGRAILKNIGHTK",
			class = "UnlockDlc",
			backend_reward_id = "lake_upgrade"
		}
	},
	CUSA13645_00 = {
		lake = {
			product_label = "V2EUGRAILKNIGHTK",
			backend_reward_id = "lake",
			class = "UnlockDlc",
			requires_restart = true,
			id = "bc65d303c0774842b2f06a164082d76b"
		},
		lake_upgrade = {
			id = "bc65d303c0774842b2f06a164082d76b",
			product_label = "V2EUGRAILKNIGHTK",
			class = "UnlockDlc",
			backend_reward_id = "lake_upgrade"
		}
	}
}
var_0_0.progression_unlocks = {
	es_questingknight = {
		description = "end_screen_career_unlocked",
		profile = "empire_soldier",
		value = "es_questingknight",
		title = "es_questingknight",
		level_requirement = 0,
		unlock_type = "career"
	}
}
