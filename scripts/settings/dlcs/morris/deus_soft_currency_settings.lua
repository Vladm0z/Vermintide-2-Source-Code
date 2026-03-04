-- chunkname: @scripts/settings/dlcs/morris/deus_soft_currency_settings.lua

local var_0_0 = {
	{
		max = 104,
		min = 43
	},
	{
		max = 90,
		min = 37
	},
	{
		max = 78,
		min = 32
	},
	{
		max = 68,
		min = 28
	}
}
local var_0_1 = {
	{
		max = 59,
		min = 28
	},
	{
		max = 51,
		min = 24
	},
	{
		max = 44,
		min = 21
	},
	{
		max = 38,
		min = 18
	}
}

DeusSoftCurrencySettings = DeusSoftCurrencySettings or {
	loot_amount = {
		["n/a"] = var_0_1,
		beastmen_minotaur = var_0_0,
		chaos_exalted_champion_norsca = var_0_0,
		chaos_exalted_champion_warcamp = var_0_0,
		chaos_exalted_sorcerer = var_0_0,
		chaos_exalted_sorcerer_drachenfels = var_0_0,
		chaos_spawn = var_0_0,
		chaos_spawn_exalted_champion_warcamp = var_0_0,
		chaos_troll = var_0_0,
		skaven_grey_seer = var_0_0,
		skaven_rat_ogre = var_0_0,
		skaven_storm_vermin_champion = var_0_0,
		skaven_storm_vermin_warlord = var_0_0,
		skaven_stormfiend = var_0_0,
		skaven_stormfiend_boss = var_0_0,
		skaven_loot_rat = var_0_0
	},
	types = {
		GROUND = 1,
		MONSTER = 2
	}
}
