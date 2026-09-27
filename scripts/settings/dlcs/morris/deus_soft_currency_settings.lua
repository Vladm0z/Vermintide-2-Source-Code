-- chunkname: @scripts/settings/dlcs/morris/deus_soft_currency_settings.lua

local tbl = {
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
local tbl_2 = {
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
local DeusSoftCurrencySettings = DeusSoftCurrencySettings

DeusSoftCurrencySettings = DeusSoftCurrencySettings or {
	loot_amount = {
		["n/a"] = tbl_2,
		beastmen_minotaur = tbl,
		chaos_exalted_champion_norsca = tbl,
		chaos_exalted_champion_warcamp = tbl,
		chaos_exalted_sorcerer = tbl,
		chaos_exalted_sorcerer_drachenfels = tbl,
		chaos_spawn = tbl,
		chaos_spawn_exalted_champion_warcamp = tbl,
		chaos_troll = tbl,
		skaven_grey_seer = tbl,
		skaven_rat_ogre = tbl,
		skaven_storm_vermin_champion = tbl,
		skaven_storm_vermin_warlord = tbl,
		skaven_stormfiend = tbl,
		skaven_stormfiend_boss = tbl,
		skaven_loot_rat = tbl
	},
	types = {
		GROUND = 1,
		MONSTER = 2
	}
}
DeusSoftCurrencySettings = DeusSoftCurrencySettings
