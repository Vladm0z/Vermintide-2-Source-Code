-- chunkname: @scripts/helpers/scoreboard_helper.lua

ScoreboardHelper = ScoreboardHelper or {}
ScoreboardHelper.scoreboard_topic_stats = {
	{
		name = "kills_elites",
		display_text = "scoreboard_topic_kills_elites",
		stat_types = {
			{
				"kills_per_breed",
				"skaven_storm_vermin"
			},
			{
				"kills_per_breed",
				"skaven_storm_vermin_commander"
			},
			{
				"kills_per_breed",
				"skaven_storm_vermin_with_shield"
			},
			{
				"kills_per_breed",
				"skaven_plague_monk"
			},
			{
				"kills_per_breed",
				"chaos_warrior"
			},
			{
				"kills_per_breed",
				"chaos_bulwark"
			},
			{
				"kills_per_breed",
				"chaos_berzerker"
			},
			{
				"kills_per_breed",
				"chaos_raider"
			},
			{
				"kills_per_breed",
				"beastmen_bestigor"
			}
		},
		sort_function = function(arg_1_0, arg_1_1)
			return arg_1_0.score > arg_1_1.score
		end
	},
	{
		name = "kills_specials",
		display_text = "scoreboard_topic_kills_specials",
		stat_types = {
			{
				"kills_per_breed",
				"skaven_gutter_runner"
			},
			{
				"kills_per_breed",
				"skaven_poison_wind_globadier"
			},
			{
				"kills_per_breed",
				"skaven_pack_master"
			},
			{
				"kills_per_breed",
				"skaven_ratling_gunner"
			},
			{
				"kills_per_breed",
				"skaven_warpfire_thrower"
			},
			{
				"kills_per_breed",
				"chaos_corruptor_sorcerer"
			},
			{
				"kills_per_breed",
				"chaos_vortex_sorcerer"
			},
			{
				"kills_per_breed",
				"beastmen_standard_bearer"
			}
		},
		sort_function = function(arg_2_0, arg_2_1)
			return arg_2_0.score > arg_2_1.score
		end
	},
	{
		name = "kills_total",
		stat_type = "kills_total",
		display_text = "scoreboard_topic_kills_total",
		sort_function = function(arg_3_0, arg_3_1)
			return arg_3_0.score > arg_3_1.score
		end
	},
	{
		name = "kills_melee",
		stat_type = "kills_melee",
		display_text = "scoreboard_topic_kills_melee",
		sort_function = function(arg_4_0, arg_4_1)
			return arg_4_0.score > arg_4_1.score
		end
	},
	{
		name = "kills_ranged",
		stat_type = "kills_ranged",
		display_text = "scoreboard_topic_kills_ranged",
		sort_function = function(arg_5_0, arg_5_1)
			return arg_5_0.score > arg_5_1.score
		end
	},
	{
		name = "damage_taken",
		stat_type = "damage_taken",
		display_text = "scoreboard_topic_damage_taken",
		sort_function = function(arg_6_0, arg_6_1)
			return arg_6_0.score < arg_6_1.score
		end
	},
	{
		name = "damage_dealt",
		stat_type = "damage_dealt",
		display_text = "scoreboard_topic_damage_dealt",
		sort_function = function(arg_7_0, arg_7_1)
			return arg_7_0.score > arg_7_1.score
		end
	},
	{
		name = "damage_dealt_bosses",
		display_text = "scoreboard_topic_damage_dealt_bosses",
		stat_types = {
			{
				"damage_dealt_per_breed",
				"skaven_rat_ogre"
			},
			{
				"damage_dealt_per_breed",
				"skaven_stormfiend"
			},
			{
				"damage_dealt_per_breed",
				"chaos_spawn"
			},
			{
				"damage_dealt_per_breed",
				"chaos_troll"
			},
			{
				"damage_dealt_per_breed",
				"chaos_troll_chief"
			},
			{
				"damage_dealt_per_breed",
				"beastmen_minotaur"
			}
		},
		sort_function = function(arg_8_0, arg_8_1)
			return arg_8_0.score > arg_8_1.score
		end
	},
	{
		name = "headshots",
		stat_type = "headshots",
		display_text = "scoreboard_topic_headshots",
		sort_function = function(arg_9_0, arg_9_1)
			return arg_9_0.score > arg_9_1.score
		end
	},
	{
		name = "saves",
		stat_type = "saves",
		display_text = "scoreboard_topic_saves",
		sort_function = function(arg_10_0, arg_10_1)
			return arg_10_0.score > arg_10_1.score
		end
	},
	{
		name = "revives",
		stat_type = "revives",
		display_text = "scoreboard_topic_revives",
		sort_function = function(arg_11_0, arg_11_1)
			return arg_11_0.score > arg_11_1.score
		end
	}
}
ScoreboardHelper.scoreboard_grouped_topic_stats = {
	{
		group_name = "offense",
		stats = {
			"kills_total",
			"kills_specials",
			"kills_elites",
			"kills_ranged",
			"kills_melee",
			"damage_dealt",
			"damage_dealt_bosses",
			"damage_taken",
			"headshots",
			"saves",
			"revives"
		}
	},
	{
		group_name = "defense",
		stats = {}
	}
}

local var_0_0 = 0

for iter_0_0, iter_0_1 in ipairs(ScoreboardHelper.scoreboard_grouped_topic_stats) do
	var_0_0 = var_0_0 + #iter_0_1.stats
end

ScoreboardHelper.num_stats_per_player = var_0_0

local var_0_1 = {}

local function var_0_2(arg_12_0, arg_12_1, arg_12_2)
	if type(arg_12_2) == "table" then
		return arg_12_0:get_stat(arg_12_1, unpack(arg_12_2))
	else
		return arg_12_0:get_stat(arg_12_1, arg_12_2)
	end
end

local function var_0_3(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0

	for iter_13_0, iter_13_1 in ipairs(ScoreboardHelper.scoreboard_topic_stats) do
		if iter_13_1.name == arg_13_2 then
			var_13_0 = iter_13_1

			break
		end
	end

	assert(var_13_0, "Could not find stats topic with name: %s", arg_13_2)

	local var_13_1
	local var_13_2 = var_13_0.stat_types

	if var_13_2 ~= nil then
		local var_13_3 = #var_13_2
		local var_13_4 = 0

		for iter_13_2 = 1, var_13_3 do
			local var_13_5 = var_13_2[iter_13_2]

			var_13_4 = var_13_4 + var_0_2(arg_13_0, arg_13_1, var_13_5)
		end

		var_13_1 = var_13_4
	else
		local var_13_6 = var_13_0.stat_type

		var_13_1 = var_0_2(arg_13_0, arg_13_1, var_13_6)
	end

	if arg_13_3 then
		table.clear(var_0_1)

		local var_13_7 = arg_13_3[arg_13_1]
		local var_13_8 = (var_13_7 and var_13_7.scores or var_0_1)[arg_13_2] or 0

		if var_13_8 > 0 then
			print(string.format("### Adding saved score for %q: %i ID: %s", arg_13_2, var_13_8, arg_13_1))
		end

		var_13_1 = var_13_1 + var_13_8
	end

	assert(var_13_1 ~= nil, "Couldn't find scoreboard statistic for '%s'", var_13_0.name)

	return {
		score = var_13_1,
		stat_name = arg_13_2,
		display_text = var_13_0.display_text
	}
end

function ScoreboardHelper.get_weave_stats(arg_14_0, arg_14_1)
	assert(arg_14_0, "Missing statistics_database reference.")
	assert(arg_14_1, "Missing profile_synchronizer reference.")

	local var_14_0 = ScoreboardHelper.get_current_players()
	local var_14_1 = {}

	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		local var_14_2 = iter_14_1:network_id()
		local var_14_3 = iter_14_1:name()
		local var_14_4 = iter_14_1:stats_id()
		local var_14_5 = arg_14_1:profile_by_peer(var_14_2, iter_14_1:local_player_id())
		local var_14_6 = iter_14_1:is_player_controlled()

		var_14_1[var_14_4] = {
			name = var_14_3,
			peer_id = var_14_2,
			local_player_id = iter_14_1:local_player_id(),
			stats_id = var_14_4,
			profile_index = var_14_5,
			is_player_controlled = var_14_6,
			scores = {}
		}
	end

	local var_14_7 = ScoreboardHelper.scoreboard_topic_stats

	for iter_14_2, iter_14_3 in ipairs(var_14_7) do
		local var_14_8 = iter_14_3.stat_types

		for iter_14_4, iter_14_5 in pairs(var_14_1) do
			if var_14_8 ~= nil then
				local var_14_9 = #var_14_8
				local var_14_10 = 0

				for iter_14_6 = 1, var_14_9 do
					local var_14_11 = var_14_8[iter_14_6]

					var_14_10 = var_14_10 + var_0_2(arg_14_0, iter_14_5.stats_id, var_14_11)
				end

				var_14_1[iter_14_4].scores[iter_14_3.name] = var_14_10
			else
				local var_14_12 = iter_14_3.stat_type
				local var_14_13 = var_0_2(arg_14_0, iter_14_5.stats_id, var_14_12)

				var_14_1[iter_14_4].scores[iter_14_3.name] = var_14_13
			end
		end
	end

	return var_14_1
end

function ScoreboardHelper.get_grouped_topic_statistics(arg_15_0, arg_15_1, arg_15_2)
	assert(arg_15_0, "Missing statistics_database reference.")
	assert(arg_15_1, "Missing profile_synchronizer reference.")

	local var_15_0 = ScoreboardHelper.get_current_players()
	local var_15_1 = {}

	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		local var_15_2 = iter_15_1:network_id()
		local var_15_3 = iter_15_1:name()
		local var_15_4 = iter_15_1:stats_id()
		local var_15_5 = arg_15_1:profile_by_peer(var_15_2, iter_15_1:local_player_id())
		local var_15_6 = iter_15_1.player_unit
		local var_15_7 = Unit.alive(var_15_6) and ScriptUnit.extension(var_15_6, "career_system")
		local var_15_8 = var_15_7 and var_15_7:career_index() or iter_15_1:career_index()
		local var_15_9 = iter_15_1:is_player_controlled()
		local var_15_10 = ExperienceSettings.get_player_level(iter_15_1)
		local var_15_11 = var_15_9 and ExperienceSettings.get_versus_player_level(iter_15_1) or 0
		local var_15_12 = SPProfiles[var_15_5].careers[var_15_8]
		local var_15_13 = var_15_12.preview_wield_slot
		local var_15_14 = InventorySettings.slot_names_by_type[var_15_13][1]
		local var_15_15 = CosmeticUtils.get_cosmetic_slot(iter_15_1, "slot_frame")
		local var_15_16 = CosmeticUtils.get_cosmetic_slot(iter_15_1, "slot_skin")
		local var_15_17 = CosmeticUtils.get_cosmetic_slot(iter_15_1, "slot_hat")
		local var_15_18 = CosmeticUtils.get_cosmetic_slot(iter_15_1, var_15_14)
		local var_15_19 = CosmeticUtils.get_cosmetic_slot(iter_15_1, "slot_pose")

		if not CosmeticUtils.is_valid(var_15_16) then
			var_15_16 = CosmeticUtils.get_default_cosmetic_slot(var_15_12, "slot_skin")
		end

		if not CosmeticUtils.is_valid(var_15_17) then
			var_15_17 = CosmeticUtils.get_default_cosmetic_slot(var_15_12, "slot_hat")
		end

		if not CosmeticUtils.is_valid(var_15_18) then
			var_15_18 = CosmeticUtils.get_default_cosmetic_slot(var_15_12, var_15_14)
		end

		if not CosmeticUtils.is_valid(var_15_19) then
			var_15_19 = CosmeticUtils.get_default_cosmetic_slot(var_15_12, "slot_pose")
		end

		var_15_1[var_15_4] = {
			name = var_15_3,
			peer_id = var_15_2,
			local_player_id = iter_15_1:local_player_id(),
			career_index = var_15_8,
			stats_id = var_15_4,
			profile_index = var_15_5,
			is_player_controlled = var_15_9,
			player_level = var_15_10,
			versus_player_level = var_15_11,
			portrait_frame = var_15_15 and var_15_15.item_name,
			hero_skin = var_15_16 and var_15_16.item_name,
			weapon = var_15_18,
			weapon_pose = var_15_19,
			hat = var_15_17
		}
	end

	for iter_15_2, iter_15_3 in pairs(var_15_1) do
		local var_15_20 = {}

		for iter_15_4, iter_15_5 in ipairs(ScoreboardHelper.scoreboard_grouped_topic_stats) do
			local var_15_21 = iter_15_5.group_name
			local var_15_22 = iter_15_5.stats

			var_15_20[var_15_21] = {}

			local var_15_23 = var_15_20[var_15_21]

			for iter_15_6, iter_15_7 in pairs(var_15_22) do
				local var_15_24 = var_0_3(arg_15_0, iter_15_2, iter_15_7, arg_15_2)

				var_15_23[#var_15_23 + 1] = var_15_24
			end
		end

		iter_15_3.group_scores = var_15_20
	end

	return var_15_1
end

local var_0_4 = {}
local var_0_5 = {}

function ScoreboardHelper.get_current_players(arg_16_0)
	local var_16_0 = Managers.mechanism:max_instance_members()
	local var_16_1 = Managers.player:human_and_bot_players()

	if var_16_0 >= table.size(var_16_1) then
		return var_16_1
	else
		table.clear(var_0_4)
		table.clear(var_0_5)

		local var_16_2 = var_0_4
		local var_16_3 = Managers.player:human_players()
		local var_16_4 = Managers.player:bots()

		for iter_16_0, iter_16_1 in pairs(var_16_3) do
			local var_16_5

			if arg_16_0 then
				local var_16_6 = iter_16_1:network_id()
				local var_16_7 = iter_16_1:local_player_id()

				var_16_5 = arg_16_0:profile_by_peer(var_16_6, var_16_7)
			else
				var_16_5 = iter_16_1:profile_index()
			end

			if not var_0_5[var_16_5] then
				var_16_2[#var_16_2 + 1] = iter_16_1
				var_0_5[var_16_5] = true
			end

			if var_16_0 <= #var_16_2 then
				break
			end
		end

		for iter_16_2, iter_16_3 in pairs(var_16_4) do
			if var_16_0 <= #var_16_2 then
				break
			end

			local var_16_8 = iter_16_3:profile_index()

			if not var_0_5[var_16_8] then
				var_16_2[#var_16_2 + 1] = iter_16_3
			end
		end

		return var_16_2
	end
end

function ScoreboardHelper.debug_get_grouped_topic_statistics()
	local var_17_0 = {}

	for iter_17_0 = 1, 4 do
		var_17_0[iter_17_0] = {
			career_index = 1,
			portrait_frame = "default",
			player_level = 1,
			name = "player_name_" .. tostring(iter_17_0),
			peer_id = "fake_peer_id_" .. tostring(iter_17_0),
			local_player_id = iter_17_0,
			stats_id = iter_17_0,
			profile_index = iter_17_0,
			is_player_controlled = iter_17_0 == 1 and true or false
		}
	end

	for iter_17_1, iter_17_2 in pairs(var_17_0) do
		local var_17_1 = {}

		for iter_17_3, iter_17_4 in ipairs(ScoreboardHelper.scoreboard_grouped_topic_stats) do
			local var_17_2 = iter_17_4.group_name
			local var_17_3 = iter_17_4.stats

			var_17_1[var_17_2] = {}

			local var_17_4 = var_17_1[var_17_2]

			for iter_17_5, iter_17_6 in pairs(var_17_3) do
				local var_17_5 = {
					score = 10,
					display_text = "display_text!",
					stat_name = "stat_name_" .. tostring(iter_17_5)
				}

				var_17_4[#var_17_4 + 1] = var_17_5
			end
		end

		iter_17_2.group_scores = var_17_1
	end

	return var_17_0
end

ScoreboardHelper.scoreboard_topic_stats_versus = {
	{
		name = "kills_specials",
		display_text = "scoreboard_topic_kills_specials",
		stat_types = {
			{
				"kills_per_breed",
				"vs_gutter_runner"
			},
			{
				"kills_per_breed",
				"vs_packmaster"
			},
			{
				"kills_per_breed",
				"vs_poison_wind_globadier"
			},
			{
				"kills_per_breed",
				"vs_ratling_gunner"
			},
			{
				"kills_per_breed",
				"vs_warpfire_thrower"
			}
		},
		sort_function = function(arg_18_0, arg_18_1)
			return arg_18_0.score > arg_18_1.score
		end
	},
	{
		name = "kills_heroes",
		display_text = "scoreboard_topic_kills_heroes",
		stat_types = {
			{
				"kills_per_breed",
				"hero_wh_captain"
			},
			{
				"kills_per_breed",
				"hero_dr_slayer"
			},
			{
				"kills_per_breed",
				"hero_wh_priest"
			},
			{
				"kills_per_breed",
				"hero_dr_ironbreaker"
			},
			{
				"kills_per_breed",
				"hero_we_maidenguard"
			},
			{
				"kills_per_breed",
				"hero_bw_necromancer"
			},
			{
				"kills_per_breed",
				"hero_es_questingknight"
			},
			{
				"kills_per_breed",
				"hero_we_thornsister"
			},
			{
				"kills_per_breed",
				"hero_es_knight"
			},
			{
				"kills_per_breed",
				"hero_es_huntsman"
			},
			{
				"kills_per_breed",
				"hero_wh_bountyhunter"
			},
			{
				"kills_per_breed",
				"hero_dr_ranger"
			},
			{
				"kills_per_breed",
				"hero_dr_engineer"
			},
			{
				"kills_per_breed",
				"hero_es_mercenary"
			},
			{
				"kills_per_breed",
				"hero_bw_scholar"
			},
			{
				"kills_per_breed",
				"hero_bw_unchained"
			},
			{
				"kills_per_breed",
				"hero_bw_adept"
			},
			{
				"kills_per_breed",
				"hero_wh_zealot"
			},
			{
				"kills_per_breed",
				"hero_we_shade"
			},
			{
				"kills_per_breed",
				"hero_we_waywatcher"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_wh_captain"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_dr_slayer"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_wh_priest"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_dr_ironbreaker"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_we_maidenguard"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_bw_necromancer"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_es_questingknight"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_we_thornsister"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_es_knight"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_es_huntsman"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_wh_bountyhunter"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_dr_ranger"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_dr_engineer"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_es_mercenary"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_bw_scholar"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_bw_unchained"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_bw_adept"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_wh_zealot"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_we_shade"
			},
			{
				"vs_knockdowns_per_breed",
				"hero_we_waywatcher"
			}
		},
		sort_function = function(arg_19_0, arg_19_1)
			return arg_19_0.score > arg_19_1.score
		end
	},
	{
		name = "damage_dealt_heroes",
		display_text = "scoreboard_topic_damage_dealt_heroes",
		stat_types = {
			{
				"damage_dealt_per_breed",
				"hero_wh_captain"
			},
			{
				"damage_dealt_per_breed",
				"hero_dr_slayer"
			},
			{
				"damage_dealt_per_breed",
				"hero_wh_priest"
			},
			{
				"damage_dealt_per_breed",
				"hero_dr_ironbreaker"
			},
			{
				"damage_dealt_per_breed",
				"hero_we_maidenguard"
			},
			{
				"damage_dealt_per_breed",
				"hero_bw_necromancer"
			},
			{
				"damage_dealt_per_breed",
				"hero_es_questingknight"
			},
			{
				"damage_dealt_per_breed",
				"hero_we_thornsister"
			},
			{
				"damage_dealt_per_breed",
				"hero_es_knight"
			},
			{
				"damage_dealt_per_breed",
				"hero_es_huntsman"
			},
			{
				"damage_dealt_per_breed",
				"hero_wh_bountyhunter"
			},
			{
				"damage_dealt_per_breed",
				"hero_dr_ranger"
			},
			{
				"damage_dealt_per_breed",
				"hero_dr_engineer"
			},
			{
				"damage_dealt_per_breed",
				"hero_es_mercenary"
			},
			{
				"damage_dealt_per_breed",
				"hero_bw_scholar"
			},
			{
				"damage_dealt_per_breed",
				"hero_bw_unchained"
			},
			{
				"damage_dealt_per_breed",
				"hero_bw_adept"
			},
			{
				"damage_dealt_per_breed",
				"hero_wh_zealot"
			},
			{
				"damage_dealt_per_breed",
				"hero_we_shade"
			},
			{
				"damage_dealt_per_breed",
				"hero_we_waywatcher"
			}
		},
		sort_function = function(arg_20_0, arg_20_1)
			return arg_20_0.score > arg_20_1.score
		end
	},
	{
		name = "vs_damage_dealt_to_pactsworn",
		stat_type = "vs_damage_dealt_to_pactsworn",
		display_text = "scoreboard_topic_damage_dealt_pactsworn",
		sort_function = function(arg_21_0, arg_21_1)
			return arg_21_0.score > arg_21_1.score
		end
	},
	{
		name = "saves",
		stat_type = "saves",
		display_text = "scoreboard_topic_saves",
		sort_function = function(arg_22_0, arg_22_1)
			return arg_22_0.score > arg_22_1.score
		end
	},
	{
		name = "revives",
		stat_type = "revives",
		display_text = "scoreboard_topic_revives",
		sort_function = function(arg_23_0, arg_23_1)
			return arg_23_0.score > arg_23_1.score
		end
	},
	{
		name = "disables",
		stat_type = "vs_disables_per_breed",
		display_text = "scoreboard_topic_disables",
		stat_types = {
			{
				"vs_disables_per_breed",
				"vs_gutter_runner"
			},
			{
				"vs_disables_per_breed",
				"vs_packmaster"
			}
		},
		sort_function = function(arg_24_0, arg_24_1)
			return arg_24_0.score > arg_24_1.score
		end
	},
	{
		name = "gutter_runner_disables",
		stat_type = "vs_disables_per_breed",
		display_text = "scoreboard_topic_gutter_runner_disables",
		stat_types = {
			{
				"vs_disables_per_breed",
				"vs_gutter_runner"
			}
		},
		sort_function = function(arg_25_0, arg_25_1)
			return arg_25_0.score > arg_25_1.score
		end
	},
	{
		name = "packmaster_disables",
		stat_type = "vs_disables_per_breed",
		display_text = "scoreboard_topic_packmaster_disables",
		stat_types = {
			{
				"vs_disables_per_breed",
				"vs_packmaster"
			}
		},
		sort_function = function(arg_26_0, arg_26_1)
			return arg_26_0.score > arg_26_1.score
		end
	},
	{
		name = "kills_total",
		stat_type = "kills_total",
		display_text = "scoreboard_topic_kills_total",
		sort_function = function(arg_27_0, arg_27_1)
			return arg_27_0.score > arg_27_1.score
		end
	},
	{
		name = "monster_damage",
		display_text = "scoreboard_topic_damage_dealt_by_monster",
		stat_types = {
			{
				"state_damage_dealt_as_pactsworn_breed",
				"vs_chaos_troll"
			},
			{
				"state_damage_dealt_as_pactsworn_breed",
				"vs_rat_ogre"
			}
		},
		sort_function = function(arg_28_0, arg_28_1)
			return arg_28_0.score > arg_28_1.score
		end
	},
	{
		name = "troll_damage",
		stat_types = {
			{
				"state_damage_dealt_as_pactsworn_breed",
				"vs_chaos_troll"
			}
		},
		sort_function = function(arg_29_0, arg_29_1)
			return arg_29_0.score > arg_29_1.score
		end
	},
	{
		name = "rat_ogre_damage",
		stat_types = {
			{
				"state_damage_dealt_as_pactsworn_breed",
				"vs_rat_ogre"
			}
		},
		sort_function = function(arg_30_0, arg_30_1)
			return arg_30_0.score > arg_30_1.score
		end
	},
	{
		name = "damage_to_monster",
		display_text = "scoreboard_topic_damage_dealt_to_monster",
		stat_types = {
			{
				"damage_dealt_per_breed",
				"vs_chaos_troll"
			}
		},
		sort_function = function(arg_31_0, arg_31_1)
			return arg_31_0.score > arg_31_1.score
		end
	}
}
ScoreboardHelper.scoreboard_grouped_topic_stats_versus = {
	{
		group_name = "heroes",
		stats = {
			"kills_specials",
			"vs_damage_dealt_to_pactsworn",
			"saves",
			"revives"
		}
	},
	{
		group_name = "pactsworn",
		stats = {
			"kills_heroes",
			"damage_dealt_heroes",
			"disables"
		}
	}
}

function ScoreboardHelper.get_versus_stats(arg_32_0, arg_32_1)
	assert(arg_32_0, "Missing statistics_database reference.")

	local var_32_0 = Managers.player:human_players()
	local var_32_1 = Managers.mechanism:game_mechanism()
	local var_32_2 = Managers.party
	local var_32_3 = {}

	for iter_32_0, iter_32_1 in pairs(var_32_0) do
		repeat
			local var_32_4 = iter_32_1:network_id()
			local var_32_5, var_32_6 = Managers.mechanism:get_persistent_profile_index_reservation(var_32_4)

			if var_32_5 == 0 or var_32_6 == 0 then
				break
			end

			local var_32_7 = iter_32_1:name()
			local var_32_8 = iter_32_1:stats_id()
			local var_32_9 = iter_32_1:local_player_id()
			local var_32_10 = ExperienceSettings.get_player_level(iter_32_1)
			local var_32_11 = iter_32_1:is_player_controlled() and ExperienceSettings.get_versus_player_level(iter_32_1) or 0
			local var_32_12, var_32_13, var_32_14, var_32_15, var_32_16, var_32_17, var_32_18 = var_32_1:get_hero_cosmetics(var_32_4, var_32_9)

			var_32_3[var_32_8] = {
				name = var_32_7,
				peer_id = var_32_4,
				local_player_id = var_32_9,
				stats_id = var_32_8,
				profile_index = var_32_5,
				career_index = var_32_6,
				player_level = var_32_10,
				versus_player_level = var_32_11,
				portrait_frame = var_32_17,
				hero_skin = var_32_15,
				weapon = {
					item_name = var_32_12
				},
				weapon_pose = {
					item_name = var_32_13,
					skin_name = var_32_14
				},
				hat = {
					item_name = var_32_16
				},
				pactsworn_cosmetics = var_32_18,
				scores = {}
			}
		until true
	end

	local var_32_19 = ScoreboardHelper.scoreboard_topic_stats_versus

	for iter_32_2, iter_32_3 in ipairs(var_32_19) do
		local var_32_20 = iter_32_3.stat_types

		for iter_32_4, iter_32_5 in pairs(var_32_3) do
			if var_32_20 ~= nil then
				local var_32_21 = #var_32_20
				local var_32_22 = 0

				for iter_32_6 = 1, var_32_21 do
					local var_32_23 = var_32_20[iter_32_6]

					var_32_22 = var_32_22 + var_0_2(arg_32_0, iter_32_5.stats_id, var_32_23)
				end

				local var_32_24 = var_32_3[iter_32_4]
				local var_32_25 = arg_32_1 and arg_32_1[iter_32_4]

				var_32_24.scores[iter_32_3.name] = var_32_22 + (var_32_25 and var_32_25.scores and var_32_25.scores[iter_32_3.name] or 0)
			else
				local var_32_26 = iter_32_3.stat_type
				local var_32_27 = var_0_2(arg_32_0, iter_32_5.stats_id, var_32_26)
				local var_32_28 = var_32_3[iter_32_4]
				local var_32_29 = arg_32_1 and arg_32_1[iter_32_4]

				var_32_28.scores[iter_32_3.name] = var_32_27 + (var_32_29 and var_32_29.scores and var_32_29.scores[iter_32_3.name] or 0)
			end
		end
	end

	return var_32_3, #var_32_19
end
