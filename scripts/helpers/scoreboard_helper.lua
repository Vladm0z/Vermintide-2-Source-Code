-- chunkname: @scripts/helpers/scoreboard_helper.lua

local ScoreboardHelper = ScoreboardHelper

ScoreboardHelper = ScoreboardHelper or {}
ScoreboardHelper = ScoreboardHelper
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
		sort_function = function (self, arg_1_1)
			-- function 1
			return self.score > arg_1_1.score
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
		sort_function = function (self, arg_2_1)
			-- function 2
			return self.score > arg_2_1.score
		end
	},
	{
		name = "kills_total",
		stat_type = "kills_total",
		display_text = "scoreboard_topic_kills_total",
		sort_function = function (self, arg_3_1)
			-- function 3
			return self.score > arg_3_1.score
		end
	},
	{
		name = "kills_melee",
		stat_type = "kills_melee",
		display_text = "scoreboard_topic_kills_melee",
		sort_function = function (self, arg_4_1)
			-- function 4
			return self.score > arg_4_1.score
		end
	},
	{
		name = "kills_ranged",
		stat_type = "kills_ranged",
		display_text = "scoreboard_topic_kills_ranged",
		sort_function = function (self, arg_5_1)
			-- function 5
			return self.score > arg_5_1.score
		end
	},
	{
		name = "damage_taken",
		stat_type = "damage_taken",
		display_text = "scoreboard_topic_damage_taken",
		sort_function = function (self, arg_6_1)
			-- function 6
			return self.score < arg_6_1.score
		end
	},
	{
		name = "damage_dealt",
		stat_type = "damage_dealt",
		display_text = "scoreboard_topic_damage_dealt",
		sort_function = function (self, arg_7_1)
			-- function 7
			return self.score > arg_7_1.score
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
		sort_function = function (self, arg_8_1)
			-- function 8
			return self.score > arg_8_1.score
		end
	},
	{
		name = "headshots",
		stat_type = "headshots",
		display_text = "scoreboard_topic_headshots",
		sort_function = function (self, arg_9_1)
			-- function 9
			return self.score > arg_9_1.score
		end
	},
	{
		name = "saves",
		stat_type = "saves",
		display_text = "scoreboard_topic_saves",
		sort_function = function (self, arg_10_1)
			-- function 10
			return self.score > arg_10_1.score
		end
	},
	{
		name = "revives",
		stat_type = "revives",
		display_text = "scoreboard_topic_revives",
		sort_function = function (self, arg_11_1)
			-- function 11
			return self.score > arg_11_1.score
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

local num = 0

for i, v in ipairs(ScoreboardHelper.scoreboard_grouped_topic_stats) do
	num = num + #v.stats
end

ScoreboardHelper.num_stats_per_player = num

local tbl = {}

local function fn(self, arg_12_1, arg_12_2)
	-- function 12
	if type(arg_12_2) == "table" then
		return self:get_stat(arg_12_1, unpack(arg_12_2))
	else
		return self:get_stat(arg_12_1, arg_12_2)
	end
end

local function fn_2(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local var_13_0

	for i, v in ipairs(ScoreboardHelper.scoreboard_topic_stats) do
		if v.name == arg_13_2 then
			var_13_0 = v

			break
		end
	end

	assert(var_13_0, "Could not find stats topic with name: %s", arg_13_2)

	local var_13_1
	local stat_types = var_13_0.stat_types

	if stat_types ~= nil then
		local count = #stat_types
		local num = 0

		for k = 1, count do
			local var_13_5 = stat_types[k]

			num = num + fn(arg_13_0, arg_13_1, var_13_5)
		end

		var_13_1 = num
	else
		local stat_type = var_13_0.stat_type

		var_13_1 = fn(arg_13_0, arg_13_1, stat_type)
	end

	if not arg_13_3 then
		table.clear(tbl)

		local var_13_7 = arg_13_3[arg_13_1]
		local scores

		if not var_13_7 then
			scores = var_13_7.scores

			if not scores then
				-- Nothing
			end
		end

		scores = tbl

		::label_13_0::

		local var_13_9 = scores[arg_13_2]

		var_13_9 = var_13_9 or 0

		if var_13_9 > 0 then
			print(string.format("### Adding saved score for %q: %i ID: %s", arg_13_2, var_13_9, arg_13_1))
		end

		var_13_1 = var_13_1 + var_13_9
	end

	assert(var_13_1 ~= nil, "Couldn't find scoreboard statistic for '%s'", var_13_0.name)

	return {
		score = var_13_1,
		stat_name = arg_13_2,
		display_text = var_13_0.display_text
	}
end

ScoreboardHelper.get_weave_stats = function (arg_14_0, arg_14_1)
	-- function 14
	assert(arg_14_0, "Missing statistics_database reference.")
	assert(arg_14_1, "Missing profile_synchronizer reference.")

	local get_current_players = ScoreboardHelper.get_current_players()
	local tbl = {}

	for k, v in pairs(get_current_players) do
		local network_id = v:network_id()
		local name = v:name()
		local stats_id = v:stats_id()
		local profile_by_peer = arg_14_1:profile_by_peer(network_id, v:local_player_id())
		local is_player_controlled = v:is_player_controlled()

		tbl[stats_id] = {
			name = name,
			peer_id = network_id,
			local_player_id = v:local_player_id(),
			stats_id = stats_id,
			profile_index = profile_by_peer,
			is_player_controlled = is_player_controlled,
			scores = {}
		}
	end

	local scoreboard_topic_stats = ScoreboardHelper.scoreboard_topic_stats

	for i, v_2 in ipairs(scoreboard_topic_stats) do
		local stat_types = v_2.stat_types

		for k_2, v_3 in pairs(tbl) do
			if stat_types ~= nil then
				local count = #stat_types
				local num = 0

				for i6 = 1, count do
					local var_14_11 = stat_types[i6]

					num = num + fn(arg_14_0, v_3.stats_id, var_14_11)
				end

				tbl[k_2].scores[v_2.name] = num
			else
				local stat_type = v_2.stat_type
				local var_14_13 = fn(arg_14_0, v_3.stats_id, stat_type)

				tbl[k_2].scores[v_2.name] = var_14_13
			end
		end
	end

	return tbl
end

ScoreboardHelper.get_grouped_topic_statistics = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	assert(arg_15_0, "Missing statistics_database reference.")
	assert(arg_15_1, "Missing profile_synchronizer reference.")

	local get_current_players = ScoreboardHelper.get_current_players()
	local tbl = {}

	for k, v in pairs(get_current_players) do
		local network_id = v:network_id()
		local name = v:name()
		local stats_id = v:stats_id()
		local profile_by_peer = arg_15_1:profile_by_peer(network_id, v:local_player_id())
		local player_unit = v.player_unit
		local flag = not Unit.alive(player_unit) and ScriptUnit.extension(player_unit, "career_system")
		local career_index

		if not flag then
			career_index = flag:career_index()

			if not career_index then
				-- Nothing
			end
		end

		career_index = v:career_index()

		::label_15_0::

		local is_player_controlled = v:is_player_controlled()
		local get_player_level = ExperienceSettings.get_player_level(v)
		local get_versus_player_level

		if not is_player_controlled then
			get_versus_player_level = ExperienceSettings.get_versus_player_level(v)

			if not get_versus_player_level then
				-- Nothing
			end
		end

		get_versus_player_level = 0

		::label_15_1::

		local var_15_12 = SPProfiles[profile_by_peer].careers[career_index]
		local preview_wield_slot = var_15_12.preview_wield_slot
		local var_15_14 = InventorySettings.slot_names_by_type[preview_wield_slot][1]
		local get_cosmetic_slot = CosmeticUtils.get_cosmetic_slot(v, "slot_frame")
		local get_cosmetic_slot_2 = CosmeticUtils.get_cosmetic_slot(v, "slot_skin")
		local get_cosmetic_slot_3 = CosmeticUtils.get_cosmetic_slot(v, "slot_hat")
		local get_cosmetic_slot_4 = CosmeticUtils.get_cosmetic_slot(v, var_15_14)
		local get_cosmetic_slot_5 = CosmeticUtils.get_cosmetic_slot(v, "slot_pose")

		if not CosmeticUtils.is_valid(get_cosmetic_slot_2) then
			get_cosmetic_slot_2 = CosmeticUtils.get_default_cosmetic_slot(var_15_12, "slot_skin")
		end

		if not CosmeticUtils.is_valid(get_cosmetic_slot_3) then
			get_cosmetic_slot_3 = CosmeticUtils.get_default_cosmetic_slot(var_15_12, "slot_hat")
		end

		if not CosmeticUtils.is_valid(get_cosmetic_slot_4) then
			get_cosmetic_slot_4 = CosmeticUtils.get_default_cosmetic_slot(var_15_12, var_15_14)
		end

		if not CosmeticUtils.is_valid(get_cosmetic_slot_5) then
			get_cosmetic_slot_5 = CosmeticUtils.get_default_cosmetic_slot(var_15_12, "slot_pose")
		end

		tbl[stats_id] = {
			name = name,
			peer_id = network_id,
			local_player_id = v:local_player_id(),
			career_index = career_index,
			stats_id = stats_id,
			profile_index = profile_by_peer,
			is_player_controlled = is_player_controlled,
			player_level = get_player_level,
			versus_player_level = get_versus_player_level,
			portrait_frame = not get_cosmetic_slot and get_cosmetic_slot.item_name,
			hero_skin = not get_cosmetic_slot_2 and get_cosmetic_slot_2.item_name,
			weapon = get_cosmetic_slot_4,
			weapon_pose = get_cosmetic_slot_5,
			hat = get_cosmetic_slot_3
		}
	end

	for k_2, v_2 in pairs(tbl) do
		local tbl_2 = {}

		for i, v_3 in ipairs(ScoreboardHelper.scoreboard_grouped_topic_stats) do
			local group_name = v_3.group_name
			local stats = v_3.stats

			tbl_2[group_name] = {}

			local var_15_23 = tbl_2[group_name]

			for k_3, v_4 in pairs(stats) do
				local var_15_24 = fn_2(arg_15_0, k_2, v_4, arg_15_2)

				var_15_23[#var_15_23 + 1] = var_15_24
			end
		end

		v_2.group_scores = tbl_2
	end

	return tbl
end

local tbl_2 = {}
local tbl_3 = {}

ScoreboardHelper.get_current_players = function (self)
	-- function 16
	local max_instance_members = Managers.mechanism:max_instance_members()
	local human_and_bot_players = Managers.player:human_and_bot_players()

	if max_instance_members >= table.size(human_and_bot_players) then
		return human_and_bot_players
	else
		table.clear(tbl_2)
		table.clear(tbl_3)

		local var_16_2 = tbl_2
		local human_players = Managers.player:human_players()
		local bots = Managers.player:bots()

		for k, v in pairs(human_players) do
			local var_16_5

			if not self then
				local network_id = v:network_id()
				local local_player_id = v:local_player_id()

				var_16_5 = self:profile_by_peer(network_id, local_player_id)
			else
				var_16_5 = v:profile_index()
			end

			if not tbl_3[var_16_5] then
				var_16_2[#var_16_2 + 1] = v
				tbl_3[var_16_5] = true
			end

			if max_instance_members <= #var_16_2 then
				break
			end
		end

		for k_2, v_2 in pairs(bots) do
			if max_instance_members <= #var_16_2 then
				break
			end

			local profile_index = v_2:profile_index()

			if not tbl_3[profile_index] then
				var_16_2[#var_16_2 + 1] = v_2
			end
		end

		return var_16_2
	end
end

ScoreboardHelper.debug_get_grouped_topic_statistics = function ()
	-- function 17
	local tbl = {}

	for i = 1, 4 do
		local tbl_2 = {
			career_index = 1,
			portrait_frame = "default",
			player_level = 1,
			name = "player_name_" .. tostring(i),
			peer_id = "fake_peer_id_" .. tostring(i),
			local_player_id = i,
			stats_id = i,
			profile_index = i
		}
		local flag

		flag = i ~= 1 or not true or false
		tbl_2.is_player_controlled = flag
		tbl[i] = tbl_2
	end

	for k, v in pairs(tbl) do
		local tbl_3 = {}

		for i_2, v_2 in ipairs(ScoreboardHelper.scoreboard_grouped_topic_stats) do
			local group_name = v_2.group_name
			local stats = v_2.stats

			tbl_3[group_name] = {}

			local var_17_6 = tbl_3[group_name]

			for k_2, v_3 in pairs(stats) do
				local tbl_4 = {
					score = 10,
					display_text = "display_text!",
					stat_name = "stat_name_" .. tostring(k_2)
				}

				var_17_6[#var_17_6 + 1] = tbl_4
			end
		end

		v.group_scores = tbl_3
	end

	return tbl
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
		sort_function = function (self, arg_18_1)
			-- function 18
			return self.score > arg_18_1.score
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
		sort_function = function (self, arg_19_1)
			-- function 19
			return self.score > arg_19_1.score
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
		sort_function = function (self, arg_20_1)
			-- function 20
			return self.score > arg_20_1.score
		end
	},
	{
		name = "vs_damage_dealt_to_pactsworn",
		stat_type = "vs_damage_dealt_to_pactsworn",
		display_text = "scoreboard_topic_damage_dealt_pactsworn",
		sort_function = function (self, arg_21_1)
			-- function 21
			return self.score > arg_21_1.score
		end
	},
	{
		name = "saves",
		stat_type = "saves",
		display_text = "scoreboard_topic_saves",
		sort_function = function (self, arg_22_1)
			-- function 22
			return self.score > arg_22_1.score
		end
	},
	{
		name = "revives",
		stat_type = "revives",
		display_text = "scoreboard_topic_revives",
		sort_function = function (self, arg_23_1)
			-- function 23
			return self.score > arg_23_1.score
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
		sort_function = function (self, arg_24_1)
			-- function 24
			return self.score > arg_24_1.score
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
		sort_function = function (self, arg_25_1)
			-- function 25
			return self.score > arg_25_1.score
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
		sort_function = function (self, arg_26_1)
			-- function 26
			return self.score > arg_26_1.score
		end
	},
	{
		name = "kills_total",
		stat_type = "kills_total",
		display_text = "scoreboard_topic_kills_total",
		sort_function = function (self, arg_27_1)
			-- function 27
			return self.score > arg_27_1.score
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
		sort_function = function (self, arg_28_1)
			-- function 28
			return self.score > arg_28_1.score
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
		sort_function = function (self, arg_29_1)
			-- function 29
			return self.score > arg_29_1.score
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
		sort_function = function (self, arg_30_1)
			-- function 30
			return self.score > arg_30_1.score
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
		sort_function = function (self, arg_31_1)
			-- function 31
			return self.score > arg_31_1.score
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

ScoreboardHelper.get_versus_stats = function (arg_32_0, arg_32_1)
	-- function 32
	assert(arg_32_0, "Missing statistics_database reference.")

	local human_players = Managers.player:human_players()
	local game_mechanism = Managers.mechanism:game_mechanism()
	local party = Managers.party
	local tbl = {}

	for k, v in pairs(human_players) do
		repeat
			local network_id = v:network_id()
			local get_persistent_profile_index_reservation, var_32_6 = Managers.mechanism:get_persistent_profile_index_reservation(network_id)

			if not (get_persistent_profile_index_reservation == 0 or var_32_6 ~= 0) then
				break
			end

			local name = v:name()
			local stats_id = v:stats_id()
			local local_player_id = v:local_player_id()
			local get_player_level = ExperienceSettings.get_player_level(v)
			local get_versus_player_level

			if not v:is_player_controlled() then
				get_versus_player_level = ExperienceSettings.get_versus_player_level(v)

				if not get_versus_player_level then
					-- Nothing
				end
			end

			get_versus_player_level = 0

			::label_32_0::

			local get_hero_cosmetics, var_32_13, var_32_14, var_32_15, var_32_16, var_32_17, var_32_18 = game_mechanism:get_hero_cosmetics(network_id, local_player_id)

			tbl[stats_id] = {
				name = name,
				peer_id = network_id,
				local_player_id = local_player_id,
				stats_id = stats_id,
				profile_index = get_persistent_profile_index_reservation,
				career_index = var_32_6,
				player_level = get_player_level,
				versus_player_level = get_versus_player_level,
				portrait_frame = var_32_17,
				hero_skin = var_32_15,
				weapon = {
					item_name = get_hero_cosmetics
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

	local scoreboard_topic_stats_versus = ScoreboardHelper.scoreboard_topic_stats_versus

	for i, v_2 in ipairs(scoreboard_topic_stats_versus) do
		local stat_types = v_2.stat_types

		for k_2, v_3 in pairs(tbl) do
			if stat_types ~= nil then
				local count = #stat_types
				local num = 0

				for i6 = 1, count do
					local var_32_23 = stat_types[i6]

					num = num + fn(arg_32_0, v_3.stats_id, var_32_23)
				end

				local var_32_24 = tbl[k_2]
				local flag = not arg_32_1 and arg_32_1[k_2]
				local scores = var_32_24.scores
				local name_2 = v_2.name
				local var_32_28

				if not flag and not flag.scores then
					var_32_28 = flag.scores[v_2.name]

					if not var_32_28 then
						-- Nothing
					end
				end

				var_32_28 = 0

				::label_32_1::

				scores[name_2] = num + var_32_28
			else
				local stat_type = v_2.stat_type
				local var_32_30 = fn(arg_32_0, v_3.stats_id, stat_type)
				local var_32_31 = tbl[k_2]
				local flag_2 = not arg_32_1 and arg_32_1[k_2]
				local scores_2 = var_32_31.scores
				local name_3 = v_2.name
				local var_32_35

				if not flag_2 and not flag_2.scores then
					var_32_35 = flag_2.scores[v_2.name]

					if not var_32_35 then
						-- Nothing
					end
				end

				var_32_35 = 0

				::label_32_2::

				scores_2[name_3] = var_32_30 + var_32_35
			end
		end
	end

	return tbl, #scoreboard_topic_stats_versus
end
