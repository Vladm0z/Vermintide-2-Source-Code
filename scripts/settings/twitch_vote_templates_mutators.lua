-- chunkname: @scripts/settings/twitch_vote_templates_mutators.lua

local var_0_0 = TwitchSettings

local function var_0_1(arg_1_0, ...)
	if DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

TwitchVoteTemplates = TwitchVoteTemplates or {}

local function var_0_2(arg_2_0)
	local var_2_0 = Managers.player:human_and_bot_players()

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		local var_2_1 = iter_2_1.player_unit

		if Unit.alive(var_2_1) then
			local var_2_2 = Managers.state.entity:system("buff_system")
			local var_2_3 = false

			var_2_2:add_buff(var_2_1, arg_2_0, var_2_1, var_2_3)
		end
	end
end

TwitchVoteTemplates.twitch_vote_activate_splitting_enemies = {
	text = "display_name_mutator_splitting_enemies",
	cost = 200,
	texture_id = "twitch_icon_splitting_enemies",
	description = "description_mutator_splitting_enemies",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_3_0)
		return not Managers.state.game_mode._mutator_handler:has_activated_mutator("splitting_enemies") and not var_0_0.disable_mutators
	end,
	on_success = function (arg_4_0)
		if arg_4_0 then
			local var_4_0 = Managers.state.game_mode._mutator_handler
			local var_4_1 = "splitting_enemies"
			local var_4_2 = 30 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_4_1))
			var_4_0:initialize_mutators({
				var_4_1
			})
			var_4_0:activate_mutator(var_4_1, var_4_2, "activated_by_twitch")
			var_0_2("twitch_mutator_buff_splitting_enemies")
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_leash = {
	text = "display_name_mutator_leash",
	cost = 200,
	texture_id = "twitch_icon_leash",
	description = "description_mutator_leash",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_5_0)
		return Managers.player:num_human_players() > 1 and not Managers.state.game_mode._mutator_handler:has_activated_mutator("leash") and not var_0_0.disable_mutators
	end,
	on_success = function (arg_6_0)
		if arg_6_0 then
			local var_6_0 = Managers.state.game_mode._mutator_handler
			local var_6_1 = "leash"
			local var_6_2 = 30 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_6_1))
			var_6_0:initialize_mutators({
				var_6_1
			})
			var_6_0:activate_mutator(var_6_1, var_6_2, "activated_by_twitch")
			var_0_2("twitch_mutator_buff_leash")
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_slayer_curse = {
	text = "display_name_mutator_slayer_curse",
	cost = 200,
	texture_id = "twitch_icon_slayer_curse",
	description = "description_mutator_slayer_curse",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_7_0)
		return not Managers.state.game_mode._mutator_handler:has_activated_mutator("slayer_curse") and not var_0_0.disable_mutators
	end,
	on_success = function (arg_8_0)
		if arg_8_0 then
			local var_8_0 = Managers.state.game_mode._mutator_handler
			local var_8_1 = "slayer_curse"
			local var_8_2 = 30 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_8_1))
			var_8_0:initialize_mutators({
				var_8_1
			})
			var_8_0:activate_mutator(var_8_1, var_8_2, "activated_by_twitch")
			var_0_2("twitch_mutator_buff_slayers_curse")
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_bloodlust = {
	text = "display_name_mutator_bloodlust",
	cost = 200,
	texture_id = "twitch_icon_bloodlust",
	description = "description_mutator_bloodlust",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_9_0)
		return not Managers.state.game_mode._mutator_handler:has_activated_mutator("bloodlust") and not var_0_0.disable_mutators
	end,
	on_success = function (arg_10_0)
		if arg_10_0 then
			local var_10_0 = Managers.state.game_mode._mutator_handler
			local var_10_1 = "bloodlust"
			local var_10_2 = 30 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_10_1))
			var_10_0:initialize_mutators({
				var_10_1
			})
			var_10_0:activate_mutator(var_10_1, var_10_2, "activated_by_twitch")
			var_0_2("twitch_mutator_buff_bloodlust")
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_realism = {
	text = "display_name_mutator_realism",
	cost = 200,
	texture_id = "twitch_icon_realism",
	description = "description_mutator_realism",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_11_0)
		return not Managers.state.game_mode._mutator_handler:has_activated_mutator("realism") and not var_0_0.disable_mutators
	end,
	on_success = function (arg_12_0)
		if arg_12_0 then
			local var_12_0 = Managers.state.game_mode._mutator_handler
			local var_12_1 = "realism"
			local var_12_2 = 60 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_12_1))
			var_12_0:initialize_mutators({
				var_12_1
			})
			var_12_0:activate_mutator(var_12_1, var_12_2, "activated_by_twitch")
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_darkness = {
	text = "display_name_mutator_darkness",
	cost = 200,
	texture_id = "twitch_icon_darkness",
	description = "description_mutator_darkness",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_13_0)
		return not Managers.state.game_mode._mutator_handler:has_activated_mutator("darkness") and not Managers.state.game_mode._mutator_handler:has_activated_mutator("twitch_darkness") and not Managers.state.game_mode._mutator_handler:has_activated_mutator("night_mode") and Managers.level_transition_handler:get_current_environment_variation_id() ~= 0 and not var_0_0.disable_mutators
	end,
	on_success = function (arg_14_0)
		if arg_14_0 then
			local var_14_0 = Managers.state.game_mode._mutator_handler
			local var_14_1 = "twitch_darkness"
			local var_14_2 = 30 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_14_1))
			var_14_0:initialize_mutators({
				var_14_1
			})
			var_14_0:activate_mutator(var_14_1, var_14_2, "activated_by_twitch")
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_ticking_bomb = {
	text = "display_name_mutator_ticking_bomb",
	cost = 100,
	texture_id = "twitch_icon_ticking_bomb",
	description = "description_mutator_ticking_bomb",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_15_0)
		return not Managers.state.game_mode._mutator_handler:has_activated_mutator("ticking_bomb") and not var_0_0.disable_mutators
	end,
	on_success = function (arg_16_0)
		if arg_16_0 then
			local var_16_0 = Managers.state.game_mode._mutator_handler
			local var_16_1 = "ticking_bomb"
			local var_16_2 = 30 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_16_1))
			var_16_0:initialize_mutators({
				var_16_1
			})
			var_16_0:activate_mutator(var_16_1, var_16_2, "activated_by_twitch")
			var_0_2("twitch_mutator_buff_ticking_bomb")
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_lightning_strike = {
	text = "display_name_lightning_strike",
	cost = 100,
	texture_id = "twitch_icon_heavens_lightning",
	description = "description_mutator_lightning_strike",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_17_0)
		return not Managers.state.game_mode._mutator_handler:has_activated_mutator("lightning_strike") and not var_0_0.disable_mutators
	end,
	on_success = function (arg_18_0)
		if arg_18_0 then
			local var_18_0 = Managers.state.game_mode._mutator_handler
			local var_18_1 = "lightning_strike"
			local var_18_2 = 33 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_18_1))
			var_18_0:initialize_mutators({
				var_18_1
			})
			var_18_0:activate_mutator(var_18_1, var_18_2, "activated_by_twitch")
			var_0_2("twitch_mutator_buff_lightning_strike")
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_chasing_spirits = {
	text = "display_name_chasing_spirits",
	cost = 100,
	texture_id = "twitch_icon_death_spirits",
	description = "description_mutator_chasing_spirits",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_19_0)
		return not Managers.state.game_mode._mutator_handler:has_activated_mutator("chasing_spirits") and not var_0_0.disable_mutators
	end,
	on_success = function (arg_20_0)
		if arg_20_0 then
			local var_20_0 = Managers.state.game_mode._mutator_handler
			local var_20_1 = "chasing_spirits"
			local var_20_2 = 30 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_20_1))
			var_20_0:initialize_mutators({
				var_20_1
			})
			var_20_0:activate_mutator(var_20_1, var_20_2, "activated_by_twitch")
			var_0_2("twitch_mutator_buff_chasing_spirits")
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_flames = {
	text = "display_name_flames",
	cost = 100,
	texture_id = "twitch_icon_fire_burn",
	description = "description_mutator_flames",
	texture_size = {
		60,
		70
	},
	condition_func = function (arg_21_0)
		return not Managers.state.game_mode._mutator_handler:has_activated_mutator("flames") and not var_0_0.disable_mutators
	end,
	on_success = function (arg_22_0)
		if arg_22_0 then
			local var_22_0 = Managers.state.game_mode._mutator_handler
			local var_22_1 = "flames"
			local var_22_2 = 30 * var_0_0.mutator_duration_multiplier

			var_0_1(string.format("[TWITCH VOTE] Activating mutator %s", var_22_1))
			var_22_0:initialize_mutators({
				var_22_1
			})
			var_22_0:activate_mutator(var_22_1, var_22_2, "activated_by_twitch")
			var_0_2("twitch_mutator_buff_flames")
		end
	end
}
