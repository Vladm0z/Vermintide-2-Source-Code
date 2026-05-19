-- chunkname: @scripts/settings/dlcs/carousel/end_screen_award_settings.lua

local var_0_0 = {}

local function var_0_1(arg_1_0, arg_1_1)
	table.clear(var_0_0)

	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		var_0_0[#var_0_0 + 1] = iter_1_1
	end

	local function var_1_0(arg_2_0, arg_2_1)
		return arg_2_0.scores[arg_1_1] > arg_2_1.scores[arg_1_1]
	end

	table.sort(var_0_0, var_1_0)

	local var_1_1
	local var_1_2 = var_0_0[1]

	return var_1_2 and var_1_2.scores[arg_1_1] > 0 and var_1_2.stats_id or var_1_1, var_1_2 and var_1_2.scores[arg_1_1]
end

EndScreenAwardSettings = {}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	prio = 1,
	stat_key = "vs_award_mvp",
	sound = "Play_vs_hud_eom_parading_mvp",
	award_mask_material = "mvp_award_mask",
	award_material = "mvp_award",
	name = Localize("vs_award_mvp_name"),
	evaluate = function(arg_3_0)
		return false
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	sound = "Play_vs_hud_eom_parading_hero_killer",
	stat_key = "vs_award_hero_killer",
	award_mask_material = "hero_killer_award_mask",
	prio = 2,
	award_material = "hero_killer_award",
	breeds = {
		PlayerBreeds.vs_gutter_runner,
		PlayerBreeds.vs_packmaster,
		PlayerBreeds.vs_warpfire_thrower,
		PlayerBreeds.vs_ratling_gunner,
		PlayerBreeds.vs_poison_wind_globadier
	},
	name = Localize("vs_award_hero_killer_name"),
	sub_header = Localize("vs_award_hero_killer_description"),
	screen_sub_header = Localize("vs_award_hero_killer_sub_header"),
	evaluate = function(arg_4_0)
		return var_0_1(arg_4_0, "kills_heroes")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	award_material = "slayer_award",
	award_mask_material = "slayer_award_mask",
	sound = "Play_vs_hud_eom_parading_slayer",
	stat_key = "vs_award_slayer",
	prio = 2,
	name = Localize("vs_award_slayer_name"),
	sub_header = Localize("vs_award_slayer_description"),
	screen_sub_header = Localize("vs_award_slayer_sub_header"),
	evaluate = function(arg_5_0)
		return var_0_1(arg_5_0, "kills_specials")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	award_material = "smiter_award",
	award_mask_material = "smiter_award_mask",
	sound = "Play_vs_hud_eom_parading_smiter",
	stat_key = "vs_award_smiter",
	prio = 2,
	name = Localize("vs_award_smiter_name"),
	sub_header = Localize("vs_award_smiter_description"),
	screen_sub_header = Localize("vs_award_smiter_sub_header"),
	evaluate = function(arg_6_0)
		return var_0_1(arg_6_0, "vs_damage_dealt_to_pactsworn")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	sound = "Play_vs_hud_eom_parading_damage_dealer",
	stat_key = "vs_award_damage_dealer",
	award_mask_material = "damage_dealer_award_mask",
	prio = 2,
	award_material = "damage_dealer_award",
	breeds = {
		PlayerBreeds.vs_gutter_runner,
		PlayerBreeds.vs_packmaster,
		PlayerBreeds.vs_warpfire_thrower,
		PlayerBreeds.vs_ratling_gunner,
		PlayerBreeds.vs_poison_wind_globadier
	},
	name = Localize("vs_award_damage_dealer_name"),
	sub_header = Localize("vs_award_damage_dealer_description"),
	screen_sub_header = Localize("vs_award_damage_dealer_sub_header"),
	evaluate = function(arg_7_0)
		return var_0_1(arg_7_0, "damage_dealt_heroes")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	award_material = "saviour_award",
	award_mask_material = "saviour_award_mask",
	sound = "Play_vs_hud_eom_parading_saviour",
	stat_key = "vs_award_saviour",
	prio = 3,
	name = Localize("vs_award_saviour_name"),
	sub_header = Localize("vs_award_saviour_description"),
	screen_sub_header = Localize("vs_award_saviour_sub_header"),
	evaluate = function(arg_8_0)
		return var_0_1(arg_8_0, "saves")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	sound = "Play_vs_hud_eom_parading_hero_napper",
	stat_key = "vs_award_hero_napper",
	award_mask_material = "hero_napper_award_mask",
	prio = 3,
	award_material = "hero_napper_award",
	breeds = {
		PlayerBreeds.vs_packmaster
	},
	name = Localize("vs_award_hero_napper_name"),
	sub_header = Localize("vs_award_hero_napper_description"),
	screen_sub_header = Localize("vs_award_hero_napper_sub_header"),
	evaluate = function(arg_9_0)
		return var_0_1(arg_9_0, "packmaster_disables")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	sound = "Play_vs_hud_eom_parading_assassin",
	stat_key = "vs_award_assassin",
	award_mask_material = "assassin_award_mask",
	prio = 3,
	award_material = "assassin_award",
	breeds = {
		PlayerBreeds.vs_gutter_runner
	},
	name = Localize("vs_award_assassin_name"),
	sub_header = Localize("vs_award_assassin_description"),
	screen_sub_header = Localize("vs_award_assassin_sub_header"),
	evaluate = function(arg_10_0)
		return var_0_1(arg_10_0, "gutter_runner_disables")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	award_material = "horde_killer_award",
	award_mask_material = "horde_killer_award_mask",
	sound = "Play_vs_hud_eom_parading_horde_killer",
	stat_key = "vs_award_horde_killer",
	prio = 3,
	name = Localize("vs_award_horde_killer_name"),
	sub_header = Localize("vs_award_horde_killer_description"),
	screen_sub_header = Localize("vs_award_horde_killer_sub_header"),
	evaluate = function(arg_11_0)
		return var_0_1(arg_11_0, "kills_total")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	sound = "Play_vs_hud_eom_parading_bile",
	stat_key = "vs_award_troll",
	award_mask_material = "monster_award_mask",
	prio = 3,
	award_material = "monster_award",
	breeds = {
		PlayerBreeds.vs_chaos_troll
	},
	name = Localize("vs_award_troll_name"),
	sub_header = Localize("vs_award_troll_description"),
	screen_sub_header = Localize("vs_award_troll_sub_header"),
	evaluate = function(arg_12_0)
		return var_0_1(arg_12_0, "troll_damage")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	sound = "Play_vs_hud_eom_parading_bile",
	stat_key = "vs_award_rat_ogre",
	award_mask_material = "roger_award_mask",
	prio = 3,
	award_material = "roger_award",
	breeds = {
		PlayerBreeds.vs_rat_ogre
	},
	name = Localize("vs_award_rat_ogre_name"),
	sub_header = Localize("vs_award_rat_ogre_description"),
	screen_sub_header = Localize("vs_award_rat_ogre_sub_header"),
	evaluate = function(arg_13_0)
		return var_0_1(arg_13_0, "rat_ogre_damage")
	end
}
EndScreenAwardSettings[#EndScreenAwardSettings + 1] = {
	award_material = "monster_killer_award",
	award_mask_material = "monster_killer_award_mask",
	sound = "Play_vs_hud_eom_parading_monster_killer",
	stat_key = "vs_award_monster_killer",
	prio = 3,
	name = Localize("vs_award_monster_killer_name"),
	sub_header = Localize("vs_award_monster_killer_description"),
	screen_sub_header = Localize("vs_award_monster_killer_sub_header"),
	evaluate = function(arg_14_0)
		return var_0_1(arg_14_0, "damage_to_monster")
	end
}
EndScreenAwardSettingsLookup = EndScreenAwardSettingsLookup or {}

for iter_0_0, iter_0_1 in ipairs(EndScreenAwardSettings) do
	EndScreenAwardSettingsLookup[iter_0_1.stat_key] = iter_0_1
end
