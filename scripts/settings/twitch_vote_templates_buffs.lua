-- chunkname: @scripts/settings/twitch_vote_templates_buffs.lua

local function fn(arg_1_0, ...)
	-- function 1
	if not DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

local TwitchVoteTemplates = TwitchVoteTemplates

TwitchVoteTemplates = TwitchVoteTemplates or {}
TwitchVoteTemplates = TwitchVoteTemplates

local TwitchSettings = TwitchSettings

TwitchVoteTemplates.twitch_add_speed_potion_buff = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_boon_of_speed",
	text = "twitch_vote_speed_potion_buff_all",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 2
		return not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_3_0)
		-- function 3
		if not arg_3_0 then
			fn("[TWITCH VOTE] Speed boosting all players")

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local system = Managers.state.entity:system("buff_system")
					local flag = false

					system:add_buff(player_unit, "twitch_speed_boost", player_unit, flag)
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_add_damage_potion_buff = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_boon_of_strength",
	text = "twitch_vote_damage_potion_buff_all",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 4
		return not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_5_0)
		-- function 5
		if not arg_5_0 then
			fn("[TWITCH VOTE] Damage boosting all players")

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local system = Managers.state.entity:system("buff_system")
					local flag = false

					system:add_buff(player_unit, "twitch_damage_boost", player_unit, flag)
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_add_cooldown_potion_buff = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_boon_of_concentration",
	text = "twitch_vote_cooldown_potion_buff_all",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 6
		return not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_7_0)
		-- function 7
		if not arg_7_0 then
			fn("[TWITCH VOTE] Cooldown boosting all players")

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local system = Managers.state.entity:system("buff_system")
					local flag = false

					system:add_buff(player_unit, "twitch_cooldown_reduction_boost", player_unit, flag)
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_grimoire_health_debuff = {
	cost = 200,
	use_frame_texture = true,
	texture_id = "twitch_icon_curse_of_the_rat",
	text = "twitch_vote_grimoire_health_debuff_all",
	texture_size = {
		70,
		70
	},
	on_success = function (arg_8_0)
		-- function 8
		if not arg_8_0 then
			fn("[TWITCH VOTE] Adding grimoire health debuff")

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local system = Managers.state.entity:system("buff_system")
					local flag = false

					system:add_buff(player_unit, "twitch_grimoire_health_debuff", player_unit, flag)
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_no_overcharge_no_ammo_reloads = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_guns_blazing",
	text = "twitch_vote_twitch_no_overcharge_no_ammo_reloads_all",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 9
		return not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_10_0)
		-- function 10
		if not arg_10_0 then
			fn("[TWITCH VOTE] Adding no overcharge/no ammo reloads buff")

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local system = Managers.state.entity:system("buff_system")
					local flag = false

					system:add_buff(player_unit, "twitch_no_overcharge_no_ammo_reloads", player_unit, flag)

					local str = "slot_ranged"
					local num = 1
					local extension = ScriptUnit.extension(player_unit, "inventory_system")
					local get_slot_data = extension:get_slot_data(str)
					local right_unit_1p = get_slot_data.right_unit_1p
					local left_unit_1p = get_slot_data.left_unit_1p
					local has_extension = ScriptUnit.has_extension(right_unit_1p, "ammo_system")
					local has_extension_2 = ScriptUnit.has_extension(left_unit_1p, "ammo_system")
					local flag_2 = has_extension or has_extension_2

					if not (not flag_2 and extension:is_ammo_blocked()) then
						flag_2:add_ammo(num)
					end
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_health_regen = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_blessing_of_regeneration",
	text = "twitch_vote_health_regen_all",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 11
		return not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_12_0)
		-- function 12
		if not arg_12_0 then
			fn("[TWITCH VOTE] Adding health regen for all")

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local system = Managers.state.entity:system("buff_system")
					local flag = false

					system:add_buff(player_unit, "twitch_health_regen", player_unit, flag)
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_health_degen = {
	cost = 100,
	use_frame_texture = true,
	texture_id = "twitch_icon_blood_loss",
	multiple_choice = true,
	text = "twitch_vote_health_degen_all",
	texture_size = {
		70,
		70
	},
	on_success = function (arg_13_0, arg_13_1)
		-- function 13
		if not arg_13_0 then
			fn("[TWITCH VOTE] Adding health degen for one")

			local human_and_bot_players = Managers.player:human_and_bot_players()
			local display_name = SPProfiles[arg_13_1].display_name

			for k, v in pairs(human_and_bot_players) do
				local profile_index = v:profile_index()

				if SPProfiles[profile_index].display_name == display_name then
					local player_unit = v.player_unit

					if not Unit.alive(player_unit) then
						local system = Managers.state.entity:system("buff_system")
						local flag = false

						system:add_buff(player_unit, "twitch_health_degen", player_unit, flag)
					end
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_root_all = {
	cost = 200,
	use_frame_texture = true,
	texture_id = "twitch_icon_root_all_players",
	text = "display_name_twitch_root_all",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 14
		return Managers.state.conflict.pacing:get_pacing_intensity() >= 80
	end,
	on_success = function (arg_15_0, arg_15_1)
		-- function 15
		if not arg_15_0 then
			fn("[TWITCH VOTE] Adding root for all")

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local system = Managers.state.entity:system("buff_system")
					local flag = false

					system:add_buff(player_unit, "twitch_vote_buff_root", player_unit, flag)
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_vote_activate_root = {
	cost = 100,
	use_frame_texture = true,
	texture_id = "twitch_icon_root_player",
	multiple_choice = true,
	text = "display_name_twitch_root",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 16
		return Managers.state.conflict.pacing:get_pacing_intensity() >= 80
	end,
	on_success = function (arg_17_0, arg_17_1)
		-- function 17
		if not arg_17_0 then
			fn("[TWITCH VOTE] Adding root for one")

			local human_and_bot_players = Managers.player:human_and_bot_players()
			local display_name = SPProfiles[arg_17_1].display_name

			for k, v in pairs(human_and_bot_players) do
				local profile_index = v:profile_index()

				if SPProfiles[profile_index].display_name == display_name then
					local player_unit = v.player_unit

					if not Unit.alive(player_unit) then
						local system = Managers.state.entity:system("buff_system")
						local flag = false

						system:add_buff(player_unit, "twitch_vote_buff_root", player_unit, flag)
					end
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_vote_hemmoraghe = {
	cost = 200,
	use_frame_texture = true,
	texture_id = "twitch_icon_hemmohage",
	multiple_choice = true,
	text = "display_name_hemmoraghe",
	texture_size = {
		70,
		70
	},
	on_success = function (arg_18_0, arg_18_1)
		-- function 18
		if not arg_18_0 then
			fn("[TWITCH VOTE] Adding hemmoraghe for one")

			local human_and_bot_players = Managers.player:human_and_bot_players()
			local display_name = SPProfiles[arg_18_1].display_name

			for k, v in pairs(human_and_bot_players) do
				local profile_index = v:profile_index()

				if SPProfiles[profile_index].display_name == display_name then
					local player_unit = v.player_unit

					if not Unit.alive(player_unit) then
						local system = Managers.state.entity:system("buff_system")
						local flag = false

						system:add_buff(player_unit, "twitch_vote_buff_hemmoraghe", player_unit, flag)
					end
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_vote_full_temp_hp = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_shield",
	text = "display_name_twitch_full_temp_hp",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 19
		return not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_20_0, arg_20_1)
		-- function 20
		if not arg_20_0 then
			fn("[TWITCH VOTE] Adding twitch_vote_full_temp_hp")

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local get_max_health = ScriptUnit.extension(player_unit, "health_system"):get_max_health()

					DamageUtils.heal_network(player_unit, player_unit, get_max_health, "healing_draught_temp_health")
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_vote_critical_strikes = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_critical_senses",
	text = "display_name_twitch_critical_strikes",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 21
		return not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_22_0, arg_22_1)
		-- function 22
		if not arg_22_0 then
			fn("[TWITCH VOTE] Adding twitch_vote_invisibility")

			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local system = Managers.state.entity:system("buff_system")
					local flag = false

					system:add_buff(player_unit, "twitch_vote_buff_critical_strikes", player_unit, flag)
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_vote_infinite_bombs = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_infinite_bomb",
	multiple_choice = true,
	text = "display_name_twitch_infinite_bombs",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 23
		return not TwitchSettings.disable_positive_votes
	end,
	on_success = function (arg_24_0, arg_24_1)
		-- function 24
		if not arg_24_0 then
			fn("[TWITCH VOTE] Adding twitch_vote_infinite_bombs for one")

			local human_and_bot_players = Managers.player:human_and_bot_players()
			local display_name = SPProfiles[arg_24_1].display_name

			for k, v in pairs(human_and_bot_players) do
				local profile_index = v:profile_index()

				if SPProfiles[profile_index].display_name == display_name then
					local player_unit = v.player_unit

					if not Unit.alive(player_unit) then
						local system = Managers.state.entity:system("buff_system")
						local flag = false

						system:add_buff(player_unit, "twitch_vote_buff_infinite_bombs", player_unit, flag)
					end
				end
			end
		end
	end
}
TwitchVoteTemplates.twitch_vote_invincibility = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_invincibility",
	multiple_choice = true,
	text = "display_name_twitch_invincibility",
	texture_size = {
		70,
		70
	},
	condition_func = function ()
		-- function 25
		local get_pacing_intensity = Managers.state.conflict.pacing:get_pacing_intensity()

		return not not TwitchSettings.disable_positive_votes or get_pacing_intensity >= 100
	end,
	on_success = function (arg_26_0, arg_26_1)
		-- function 26
		if not arg_26_0 then
			fn("[TWITCH VOTE] Adding twitch_vote_invincibility for one")

			local human_and_bot_players = Managers.player:human_and_bot_players()
			local display_name = SPProfiles[arg_26_1].display_name

			for k, v in pairs(human_and_bot_players) do
				local profile_index = v:profile_index()

				if SPProfiles[profile_index].display_name == display_name then
					local player_unit = v.player_unit

					if not Unit.alive(player_unit) then
						local system = Managers.state.entity:system("buff_system")
						local flag = false

						system:add_buff(player_unit, "twitch_vote_buff_invincibility", player_unit, flag)
					end
				end
			end
		end
	end
}
