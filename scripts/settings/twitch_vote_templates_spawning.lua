-- chunkname: @scripts/settings/twitch_vote_templates_spawning.lua

local var_0_0 = TwitchSettings

local function var_0_1(arg_1_0, ...)
	if DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

local function var_0_2(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1[Managers.state.difficulty:get_difficulty()] or arg_2_1.hardest
	local var_2_1 = math.ceil(math.random(var_2_0[1], var_2_0[2]) * var_0_0.spawn_amount_multiplier)
	local var_2_2 = Managers.state.side:get_side_from_name("dark_pact").side_id
	local var_2_3 = {}

	for iter_2_0 = 1, var_2_1 do
		var_2_3[#var_2_3 + 1] = arg_2_0
	end

	local var_2_4 = Managers.state.conflict
	local var_2_5 = false
	local var_2_6 = var_2_4.main_path_info

	if var_2_6.ahead_unit or var_2_6.behind_unit then
		var_2_4.horde_spawner:execute_custom_horde(var_2_3, var_2_5, var_2_2)
	end
end

local function var_0_3(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1[Managers.state.difficulty:get_difficulty()] or arg_3_1.hardest
	local var_3_1

	if type(var_3_0) == "table" then
		var_3_1 = math.ceil(math.random(var_3_0[1], var_3_0[2]) * var_0_0.spawn_amount_multiplier)
	else
		var_3_1 = math.ceil(var_3_0 * var_0_0.spawn_amount_multiplier)
	end

	local var_3_2 = Managers.state.conflict

	for iter_3_0 = 1, var_3_1 do
		local var_3_3 = var_3_2.specials_pacing:get_special_spawn_pos()

		var_3_2:spawn_one(Breeds[arg_3_0], var_3_3)
	end
end

TwitchVoteTemplates = TwitchVoteTemplates or {}
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
		if arg_4_0 then
			var_0_1("[TWITCH VOTE] Spawning rat ogre")

			local var_4_0 = Breeds.skaven_rat_ogre
			local var_4_1 = math.floor(1 * var_0_0.spawn_amount_multiplier)

			for iter_4_0 = 1, var_4_1 do
				Managers.state.conflict:spawn_one(var_4_0, nil, nil, {
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
		if arg_5_0 then
			var_0_1("[TWITCH VOTE] Spawning stormfiend")

			local var_5_0 = Breeds.skaven_stormfiend
			local var_5_1 = math.floor(1 * var_0_0.spawn_amount_multiplier)

			for iter_5_0 = 1, var_5_1 do
				Managers.state.conflict:spawn_one(var_5_0, nil, nil, {
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
		if arg_6_0 then
			var_0_1("[TWITCH VOTE] Spawning chaos troll")

			local var_6_0 = Breeds.chaos_troll
			local var_6_1 = math.floor(1 * var_0_0.spawn_amount_multiplier)

			for iter_6_0 = 1, var_6_1 do
				Managers.state.conflict:spawn_one(var_6_0, nil, nil, {
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
		if arg_7_0 then
			var_0_1("[TWITCH VOTE] Spawning chaos spawn")

			local var_7_0 = Breeds.chaos_spawn
			local var_7_1 = math.floor(1 * var_0_0.spawn_amount_multiplier)

			for iter_7_0 = 1, var_7_1 do
				Managers.state.conflict:spawn_one(var_7_0, nil, nil, {
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
		return Managers.unlock:is_dlc_unlocked("scorpion")
	end,
	on_success = function (arg_9_0)
		if arg_9_0 then
			var_0_1("[TWITCH VOTE] Spawning chaos spawn")

			local var_9_0 = Breeds.beastmen_minotaur
			local var_9_1 = math.floor(1 * var_0_0.spawn_amount_multiplier)

			for iter_9_0 = 1, var_9_1 do
				Managers.state.conflict:spawn_one(var_9_0, nil, nil, {
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
		if arg_10_0 then
			var_0_1("[TWITCH VOTE] Spawning group of corruptor sorcerers")

			local var_10_0 = {
				harder = 3,
				hard = 2,
				hardest = 3,
				normal = 2
			}

			var_0_3("chaos_corruptor_sorcerer", var_10_0)
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
		if arg_11_0 then
			var_0_1("[TWITCH VOTE] Spawning group of vortex sorceres")

			local var_11_0 = {
				harder = 4,
				hard = 3,
				hardest = 4,
				normal = 3
			}

			var_0_3("chaos_vortex_sorcerer", var_11_0)
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
		if arg_12_0 then
			var_0_1("[TWITCH VOTE] Spawning group of gutter runners")

			local var_12_0 = {
				harder = 3,
				hard = 2,
				hardest = 4,
				normal = 2
			}

			var_0_3("skaven_gutter_runner", var_12_0)
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
		if arg_13_0 then
			var_0_1("[TWITCH VOTE] Spawning group of packmasters")

			local var_13_0 = {
				harder = 3,
				hard = 3,
				hardest = 4,
				normal = 3
			}

			var_0_3("skaven_pack_master", var_13_0)
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
		if arg_14_0 then
			var_0_1("[TWITCH VOTE] Spawning group of poison wind globadiers")

			local var_14_0 = {
				harder = 3,
				hard = 3,
				hardest = 4,
				normal = 3
			}

			var_0_3("skaven_poison_wind_globadier", var_14_0)
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
		if arg_15_0 then
			var_0_1("[TWITCH VOTE] Spawning group of ratling gunners")

			local var_15_0 = {
				harder = 4,
				hard = 3,
				hardest = 4,
				normal = 3
			}

			var_0_3("skaven_ratling_gunner", var_15_0)
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
		if arg_16_0 then
			var_0_1("[TWITCH VOTE] Spawning group of warpfire throwers")

			local var_16_0 = {
				harder = 4,
				hard = 4,
				hardest = 5,
				normal = 4
			}

			var_0_3("skaven_warpfire_thrower", var_16_0)
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
		if arg_17_0 then
			var_0_1("[TWITCH VOTE] Spawning horde")

			local var_17_0 = {
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
			local var_17_1 = {
				"skaven_slave",
				"chaos_fanatic"
			}
			local var_17_2 = var_17_1[Math.random(1, #var_17_1)]

			var_0_2(var_17_2, var_17_0)
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
		if arg_18_0 then
			var_0_1("[TWITCH VOTE] Spawning explosive loot rats")

			local var_18_0 = {
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

			var_0_2("skaven_explosive_loot_rat", var_18_0)
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
		if arg_19_0 then
			var_0_1("[TWITCH VOTE] Spawning plague_monks")

			local var_19_0 = {
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

			var_0_2("skaven_plague_monk", var_19_0)
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
		if arg_20_0 then
			var_0_1("[TWITCH VOTE] Spawning chaos_berzerker")

			local var_20_0 = {
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

			var_0_2("chaos_berzerker", var_20_0)
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
		if arg_21_0 then
			var_0_1("[TWITCH VOTE] Spawning storm vermin patrol")

			local var_21_0 = {
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

			var_0_2("skaven_storm_vermin", var_21_0)
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
		if arg_22_0 then
			var_0_1("[TWITCH VOTE] Spawning chaos warriors death squad")

			local var_22_0 = {
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

			var_0_2("chaos_warrior", var_22_0)
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
		if arg_23_0 then
			var_0_1("[TWITCH VOTE] Spawning loot rat fiesta")

			local var_23_0 = 10 * var_0_0.spawn_amount_multiplier

			for iter_23_0 = 1, var_23_0 do
				local var_23_1 = Breeds.skaven_loot_rat

				Managers.state.conflict:spawn_one(var_23_1)
			end
		end
	end
}
