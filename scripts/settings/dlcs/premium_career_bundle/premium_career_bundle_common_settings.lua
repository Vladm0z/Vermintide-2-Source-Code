-- chunkname: @scripts/settings/dlcs/premium_career_bundle/premium_career_bundle_common_settings.lua

local var_0_0 = DLCSettings.premium_career_bundle

var_0_0.unlock_settings = {
	premium_career_bundle = {
		id = "38849",
		class = "UnlockDlcBundle",
		requires_restart = false,
		bundle_contains = {
			"lake",
			"cog",
			"woods",
			"bless",
			"shovel"
		}
	},
	premium_career_bundle_upgrade = {
		id = "38850",
		class = "UnlockDlcBundle",
		requires_restart = false,
		bundle_contains = {
			"lake",
			"lake_upgrade",
			"cog",
			"cog_upgrade",
			"woods",
			"woods_upgrade",
			"bless",
			"bless_upgrade",
			"shovel",
			"shovel_upgrade"
		}
	}
}
var_0_0.unlock_settings_xb1 = {
	premium_career_bundle = {
		id = "51445039-3837-3035-C032-42353531D100",
		backend_reward_id = "premium_career_bundle",
		class = "UnlockDlc",
		requires_restart = true
	}
}
var_0_0.unlock_settings_ps4 = {
	CUSA13595_00 = {
		premium_career_bundle = {
			backend_reward_id = "premium_career_bundle",
			product_label = "00USCAREERSANDCO",
			class = "UnlockDlc",
			requires_restart = true,
			id = "0a282aa920c44c02a1ab700cb227edfa"
		}
	},
	CUSA13645_00 = {
		premium_career_bundle = {
			backend_reward_id = "premium_career_bundle",
			product_label = "00EUCAREERSANDCO",
			class = "UnlockDlc",
			requires_restart = true,
			id = "8cc4259a478f46a9b2132cfe6cdf44d3"
		}
	}
}
