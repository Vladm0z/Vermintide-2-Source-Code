-- chunkname: @scripts/settings/twitch_vote_templates_spawning.lua

local TwitchSettings = TwitchSettings

local function fn(arg_1_0, ...)
	-- function 1
	if not DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local var_2_0 = arg_2_1[Managers.state.difficulty:get_difficulty()]

	var_2_0 = var_2_0 or arg_2_1.hardest

	local ceil = math.ceil(math.random(var_2_0[1], var_2_0[2]) * TwitchSettings.spawn_amount_multiplier)
	local side_id = Managers.state.side:get_side_from_name("dark_pact").side_id
	local tbl = {}

	for i = 1, ceil do
		tbl[#tbl + 1] = arg_2_0
	end

	local conflict = Managers.state.conflict
	local flag = false
	local main_path_info = conflict.main_path_info

	if main_path_info.ahead_unit or not main_path_info.behind_unit then
		conflict.horde_spawner:execute_custom_horde(tbl, flag, side_id)
	end
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local var_3_0 = arg_3_1[Managers.state.difficulty:get_difficulty()]

	var_3_0 = var_3_0 or arg_3_1.hardest

	local var_3_1

	if type(var_3_0) == "table" then
		var_3_1 = math.ceil(math.random(var_3_0[1], var_3_0[2]) * TwitchSettings.spawn_amount_multiplier)
	else
		var_3_1 = math.ceil(var_3_0 * TwitchSettings.spawn_amount_multiplier)
	end

	local conflict = Managers.state.conflict

	for i = 1, var_3_1 do
		local get_special_spawn_pos = conflict.specials_pacing:get_special_spawn_pos()

		conflict:spawn_one(Breeds[arg_3_0], get_special_spawn_pos)
	end
end

local TwitchVoteTemplates = TwitchVoteTemplates

TwitchVoteTemplates = TwitchVoteTemplates or {}
TwitchVoteTemplates = TwitchVoteTemplates
TwitchVoteTemplates.twitch_spawn_rat_ogre = {
	text = "twitch_vote_spawn_rat_ogre",
	breed_name = "skaven_rat_ogre",
	texture_id = "twitch_icon_all_the_rage",
	cost = 180,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_4_0)
		-- function 4
		if not arg_4_0 then
			fn("[TWITCH VOTE] Spawning rat ogre")

			local skaven_rat_ogre = Breeds.skaven_rat_ogre
			local floor = math.floor(1 * TwitchSettings.spawn_amount_multiplier)

			for i = 1, floor do
				Managers.state.conflict:spawn_one(skaven_rat_ogre, nil, nil, {
					max_health_modifier = 0.85
				})
			end
		end
	end
}
TwitchVoteTemplates.twitch_spawn_stormfiend = {
	text = "twitch_vote_spawn_stormfiend",
	breed_name = "skaven_stormfiend",
	texture_id = "twitch_icon_fire_and_fury",
	cost = 180,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_5_0)
		-- function 5
		if not arg_5_0 then
			fn("[TWITCH VOTE] Spawning stormfiend")

			local skaven_stormfiend = Breeds.skaven_stormfiend
			local floor = math.floor(1 * TwitchSettings.spawn_amount_multiplier)

			for i = 1, floor do
				Managers.state.conflict:spawn_one(skaven_stormfiend, nil, nil, {
					max_health_modifier = 0.85
				})
			end
		end
	end
}
TwitchVoteTemplates.twitch_spawn_chaos_troll = {
	text = "twitch_vote_spawn_chaos_troll",
	breed_name = "chaos_troll",
	texture_id = "twitch_icon_bad_indigestion",
	cost = 180,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_6_0)
		-- function 6
		if not arg_6_0 then
			fn("[TWITCH VOTE] Spawning chaos troll")

			local chaos_troll = Breeds.chaos_troll
			local floor = math.floor(1 * TwitchSettings.spawn_amount_multiplier)

			for i = 1, floor do
				Managers.state.conflict:spawn_one(chaos_troll, nil, nil, {
					max_health_modifier = 0.85
				})
			end
		end
	end
}
TwitchVoteTemplates.twitch_spawn_chaos_spawn = {
	text = "twitch_vote_spawn_chaos_spawn",
	breed_name = "chaos_spawn",
	texture_id = "twitch_icon_writhing_horror",
	cost = 180,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_7_0)
		-- function 7
		if not arg_7_0 then
			fn("[TWITCH VOTE] Spawning chaos spawn")

			local chaos_spawn = Breeds.chaos_spawn
			local floor = math.floor(1 * TwitchSettings.spawn_amount_multiplier)

			for i = 1, floor do
				Managers.state.conflict:spawn_one(chaos_spawn, nil, nil, {
					max_health_modifier = 0.85
				})
			end
		end
	end
}
TwitchVoteTemplates.twitch_spawn_minotaur = {
	text = "twitch_vote_spawn_minotaur",
	breed_name = "beastmen_minotaur",
	texture_id = "twitch_icon_the_bloodkine_wakes",
	cost = 180,
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_8_0)
		-- function 8
		return Managers.unlock:is_dlc_unlocked("scorpion")
	end,
	on_success = function (arg_9_0)
		-- function 9
		if not arg_9_0 then
			fn("[TWITCH VOTE] Spawning chaos spawn")

			local beastmen_minotaur = Breeds.beastmen_minotaur
			local floor = math.floor(1 * TwitchSettings.spawn_amount_multiplier)

			for i = 1, floor do
				Managers.state.conflict:spawn_one(beastmen_minotaur, nil, nil, {
					max_health_modifier = 0.85
				})
			end
		end
	end
}
TwitchVoteTemplates.twitch_spawn_corruptor_sorcerer = {
	text = "twitch_vote_spawn_corruptor_sorcerer",
	breed_name = "chaos_corruptor_sorcerer",
	texture_id = "twitch_icon_soul_drinkers",
	cost = 150,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_10_0)
		-- function 10
		if not arg_10_0 then
			fn("[TWITCH VOTE] Spawning group of corruptor sorcerers")

			local tbl = {
				harder = 3,
				hard = 2,
				hardest = 3,
				normal = 2
			}

			fn_3("chaos_corruptor_sorcerer", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_vortex_sorcerer = {
	text = "twitch_vote_spawn_vortex_sorcerer",
	breed_name = "chaos_vortex_sorcerer",
	texture_id = "twitch_icon_all_aboard_the_wild_ride",
	cost = 100,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_11_0)
		-- function 11
		if not arg_11_0 then
			fn("[TWITCH VOTE] Spawning group of vortex sorceres")

			local tbl = {
				harder = 4,
				hard = 3,
				hardest = 4,
				normal = 3
			}

			fn_3("chaos_vortex_sorcerer", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_gutter_runner = {
	text = "twitch_vote_spawn_gutter_runner",
	breed_name = "skaven_gutter_runner",
	texture_id = "twitch_icon_sneaking_stabbing",
	cost = 150,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_12_0)
		-- function 12
		if not arg_12_0 then
			fn("[TWITCH VOTE] Spawning group of gutter runners")

			local tbl = {
				harder = 3,
				hard = 2,
				hardest = 4,
				normal = 2
			}

			fn_3("skaven_gutter_runner", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_pack_master = {
	text = "twitch_vote_spawn_pack_master",
	breed_name = "skaven_pack_master",
	texture_id = "twitch_icon_cruel_hooks",
	cost = 150,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_13_0)
		-- function 13
		if not arg_13_0 then
			fn("[TWITCH VOTE] Spawning group of packmasters")

			local tbl = {
				harder = 3,
				hard = 3,
				hardest = 4,
				normal = 3
			}

			fn_3("skaven_pack_master", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_poison_wind_globadier = {
	text = "twitch_vote_spawn_poison_wind_globadier",
	breed_name = "skaven_poison_wind_globadier",
	texture_id = "twitch_icon_hold_your_breath",
	cost = 100,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_14_0)
		-- function 14
		if not arg_14_0 then
			fn("[TWITCH VOTE] Spawning group of poison wind globadiers")

			local tbl = {
				harder = 3,
				hard = 3,
				hardest = 4,
				normal = 3
			}

			fn_3("skaven_poison_wind_globadier", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_ratling_gunner = {
	text = "twitch_vote_spawn_ratling_gunner",
	breed_name = "skaven_ratling_gunner",
	texture_id = "twitch_icon_gunline",
	cost = 100,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_15_0)
		-- function 15
		if not arg_15_0 then
			fn("[TWITCH VOTE] Spawning group of ratling gunners")

			local tbl = {
				harder = 4,
				hard = 3,
				hardest = 4,
				normal = 3
			}

			fn_3("skaven_ratling_gunner", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_warpfire_thrower = {
	text = "twitch_vote_spawn_warpfire_thrower",
	breed_name = "skaven_warpfire_thrower",
	texture_id = "twitch_icon_kill_it_with_fire",
	cost = 100,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_16_0)
		-- function 16
		if not arg_16_0 then
			fn("[TWITCH VOTE] Spawning group of warpfire throwers")

			local tbl = {
				harder = 4,
				hard = 4,
				hardest = 5,
				normal = 4
			}

			fn_3("skaven_warpfire_thrower", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_horde_vector_blob = {
	text = "twitch_vote_spawn_horde",
	cost = 100,
	texture_id = "twitch_icon_release_the_slaves",
	texture_size = {
		60,
		70
	},
	on_success = function (arg_17_0)
		-- function 17
		if not arg_17_0 then
			fn("[TWITCH VOTE] Spawning horde")

			local tbl = {
				normal = {
					16,
					22
				},
				hard = {
					22,
					28
				},
				harder = {
					28,
					36
				},
				hardest = {
					36,
					42
				}
			}
			local tbl_2 = {
				"skaven_slave",
				"chaos_fanatic"
			}
			local var_17_2 = tbl_2[Math.random(1, #tbl_2)]

			fn_2(var_17_2, tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_explosive_loot_rats = {
	text = "display_name_explosive_loot_rats",
	cost = 100,
	texture_id = "twitch_icon_explosive_loot_rats",
	texture_size = {
		60,
		70
	},
	on_success = function (arg_18_0)
		-- function 18
		if not arg_18_0 then
			fn("[TWITCH VOTE] Spawning explosive loot rats")

			local tbl = {
				normal = {
					3,
					4
				},
				hard = {
					4,
					6
				},
				harder = {
					6,
					8
				},
				hardest = {
					8,
					10
				}
			}

			fn_2("skaven_explosive_loot_rat", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_plague_monks = {
	text = "twitch_vote_spawn_plague_monks",
	cost = 100,
	texture_id = "twitch_icon_plague_monk",
	texture_size = {
		60,
		70
	},
	on_success = function (arg_19_0)
		-- function 19
		if not arg_19_0 then
			fn("[TWITCH VOTE] Spawning plague_monks")

			local tbl = {
				normal = {
					3,
					4
				},
				hard = {
					4,
					6
				},
				harder = {
					6,
					8
				},
				hardest = {
					8,
					10
				}
			}

			fn_2("skaven_plague_monk", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_berzerkers = {
	text = "twitch_vote_spawn_berzerkers",
	cost = 100,
	texture_id = "twitch_icon_berzerker",
	texture_size = {
		60,
		70
	},
	on_success = function (arg_20_0)
		-- function 20
		if not arg_20_0 then
			fn("[TWITCH VOTE] Spawning chaos_berzerker")

			local tbl = {
				normal = {
					3,
					4
				},
				hard = {
					4,
					6
				},
				harder = {
					6,
					8
				},
				hardest = {
					8,
					10
				}
			}

			fn_2("chaos_berzerker", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_death_squad_storm_vermin = {
	text = "twitch_vote_spawn_death_squad_storm_vermin",
	cost = 250,
	texture_id = "twitch_icon_blackfurs_on_parade",
	boss_equivalent = true,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_21_0)
		-- function 21
		if not arg_21_0 then
			fn("[TWITCH VOTE] Spawning storm vermin patrol")

			local tbl = {
				normal = {
					6,
					8
				},
				hard = {
					8,
					10
				},
				harder = {
					10,
					12
				},
				hardest = {
					12,
					14
				}
			}

			fn_2("skaven_storm_vermin", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_death_squad_chaos_warrior = {
	text = "twitch_vote_spawn_death_squad_chaos_warrior",
	cost = 250,
	texture_id = "twitch_icon_eavymetal",
	boss_equivalent = true,
	texture_size = {
		60,
		70
	},
	on_success = function (arg_22_0)
		-- function 22
		if not arg_22_0 then
			fn("[TWITCH VOTE] Spawning chaos warriors death squad")

			local tbl = {
				normal = {
					4,
					5
				},
				hard = {
					4,
					6
				},
				harder = {
					6,
					8
				},
				hardest = {
					8,
					10
				}
			}

			fn_2("chaos_warrior", tbl)
		end
	end
}
TwitchVoteTemplates.twitch_spawn_loot_rat_fiesta = {
	text = "twitch_vote_spawn_loot_rat_fiesta",
	cost = 0,
	texture_id = "twitch_icon_treasure_hunt",
	texture_size = {
		60,
		70
	},
	on_success = function (arg_23_0)
		-- function 23
		if not arg_23_0 then
			fn("[TWITCH VOTE] Spawning loot rat fiesta")

			local num = 10 * TwitchSettings.spawn_amount_multiplier

			for i = 1, num do
				local skaven_loot_rat = Breeds.skaven_loot_rat

				Managers.state.conflict:spawn_one(skaven_loot_rat)
			end
		end
	end
}
