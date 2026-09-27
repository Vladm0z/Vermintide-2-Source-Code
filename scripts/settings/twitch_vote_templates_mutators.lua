-- chunkname: @scripts/settings/twitch_vote_templates_mutators.lua

local TwitchSettings = TwitchSettings

local function fn(arg_1_0, ...)
	-- function 1
	if not DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

local TwitchVoteTemplates = TwitchVoteTemplates

TwitchVoteTemplates = TwitchVoteTemplates or {}
TwitchVoteTemplates = TwitchVoteTemplates

local function fn_2(arg_2_0)
	-- function 2
	local human_and_bot_players = Managers.player:human_and_bot_players()

	for k, v in pairs(human_and_bot_players) do
		local player_unit = v.player_unit

		if not Unit.alive(player_unit) then
			local system = Managers.state.entity:system("buff_system")
			local flag = false

			system:add_buff(player_unit, arg_2_0, player_unit, flag)
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
		-- function 3
		return not not Managers.state.game_mode._mutator_handler:has_activated_mutator("splitting_enemies") or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_4_0)
		-- function 4
		if not arg_4_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "splitting_enemies"
			local num = 30 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
			fn_2("twitch_mutator_buff_splitting_enemies")
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
		-- function 5
		return not (Managers.player:num_human_players() > 1) or not not Managers.state.game_mode._mutator_handler:has_activated_mutator("leash") or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_6_0)
		-- function 6
		if not arg_6_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "leash"
			local num = 30 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
			fn_2("twitch_mutator_buff_leash")
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
		-- function 7
		return not not Managers.state.game_mode._mutator_handler:has_activated_mutator("slayer_curse") or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_8_0)
		-- function 8
		if not arg_8_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "slayer_curse"
			local num = 30 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
			fn_2("twitch_mutator_buff_slayers_curse")
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
		-- function 9
		return not not Managers.state.game_mode._mutator_handler:has_activated_mutator("bloodlust") or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_10_0)
		-- function 10
		if not arg_10_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "bloodlust"
			local num = 30 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
			fn_2("twitch_mutator_buff_bloodlust")
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
		-- function 11
		return not not Managers.state.game_mode._mutator_handler:has_activated_mutator("realism") or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_12_0)
		-- function 12
		if not arg_12_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "realism"
			local num = 60 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
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
		-- function 13
		return not not Managers.state.game_mode._mutator_handler:has_activated_mutator("darkness") or not not Managers.state.game_mode._mutator_handler:has_activated_mutator("twitch_darkness") or not not Managers.state.game_mode._mutator_handler:has_activated_mutator("night_mode") or Managers.level_transition_handler:get_current_environment_variation_id() == 0 or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_14_0)
		-- function 14
		if not arg_14_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "twitch_darkness"
			local num = 30 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
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
		-- function 15
		return not not Managers.state.game_mode._mutator_handler:has_activated_mutator("ticking_bomb") or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_16_0)
		-- function 16
		if not arg_16_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "ticking_bomb"
			local num = 30 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
			fn_2("twitch_mutator_buff_ticking_bomb")
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
		-- function 17
		return not not Managers.state.game_mode._mutator_handler:has_activated_mutator("lightning_strike") or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_18_0)
		-- function 18
		if not arg_18_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "lightning_strike"
			local num = 33 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
			fn_2("twitch_mutator_buff_lightning_strike")
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
		-- function 19
		return not not Managers.state.game_mode._mutator_handler:has_activated_mutator("chasing_spirits") or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_20_0)
		-- function 20
		if not arg_20_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "chasing_spirits"
			local num = 30 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
			fn_2("twitch_mutator_buff_chasing_spirits")
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
		-- function 21
		return not not Managers.state.game_mode._mutator_handler:has_activated_mutator("flames") or not TwitchSettings.disable_mutators
	end,
	on_success = function (arg_22_0)
		-- function 22
		if not arg_22_0 then
			local _mutator_handler = Managers.state.game_mode._mutator_handler
			local str = "flames"
			local num = 30 * TwitchSettings.mutator_duration_multiplier

			fn(string.format("[TWITCH VOTE] Activating mutator %s", str))
			_mutator_handler:initialize_mutators({
				str
			})
			_mutator_handler:activate_mutator(str, num, "activated_by_twitch")
			fn_2("twitch_mutator_buff_flames")
		end
	end
}
