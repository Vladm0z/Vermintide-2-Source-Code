-- chunkname: @scripts/settings/twitch_vote_templates_buffs.lua

local function var_0_0(arg_1_0, ...)
	if DEBUG_TWITCH then
		print("[Twitch] " .. string.format(arg_1_0, ...))
	end
end

TwitchVoteTemplates = TwitchVoteTemplates or {}

local var_0_1 = TwitchSettings

TwitchVoteTemplates.twitch_add_speed_potion_buff = {
	cost = -200,
	use_frame_texture = true,
	texture_id = "twitch_icon_boon_of_speed",
	text = "twitch_vote_speed_potion_buff_all",
	texture_size = {
		70,
		70
	},
	condition_func = function()
		return not var_0_1.disable_positive_votes
	end,
	on_success = function(arg_3_0)
		if arg_3_0 then
			var_0_0("[TWITCH VOTE] Speed boosting all players")

			local var_3_0 = Managers.player:human_and_bot_players()

			for iter_3_0, iter_3_1 in pairs(var_3_0) do
				local var_3_1 = iter_3_1.player_unit

				if Unit.alive(var_3_1) then
					local var_3_2 = Managers.state.entity:system("buff_system")
					local var_3_3 = false

					var_3_2:add_buff(var_3_1, "twitch_speed_boost", var_3_1, var_3_3)
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
	condition_func = function()
		return not var_0_1.disable_positive_votes
	end,
	on_success = function(arg_5_0)
		if arg_5_0 then
			var_0_0("[TWITCH VOTE] Damage boosting all players")

			local var_5_0 = Managers.player:human_and_bot_players()

			for iter_5_0, iter_5_1 in pairs(var_5_0) do
				local var_5_1 = iter_5_1.player_unit

				if Unit.alive(var_5_1) then
					local var_5_2 = Managers.state.entity:system("buff_system")
					local var_5_3 = false

					var_5_2:add_buff(var_5_1, "twitch_damage_boost", var_5_1, var_5_3)
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
	condition_func = function()
		return not var_0_1.disable_positive_votes
	end,
	on_success = function(arg_7_0)
		if arg_7_0 then
			var_0_0("[TWITCH VOTE] Cooldown boosting all players")

			local var_7_0 = Managers.player:human_and_bot_players()

			for iter_7_0, iter_7_1 in pairs(var_7_0) do
				local var_7_1 = iter_7_1.player_unit

				if Unit.alive(var_7_1) then
					local var_7_2 = Managers.state.entity:system("buff_system")
					local var_7_3 = false

					var_7_2:add_buff(var_7_1, "twitch_cooldown_reduction_boost", var_7_1, var_7_3)
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
	on_success = function(arg_8_0)
		if arg_8_0 then
			var_0_0("[TWITCH VOTE] Adding grimoire health debuff")

			local var_8_0 = Managers.player:human_and_bot_players()

			for iter_8_0, iter_8_1 in pairs(var_8_0) do
				local var_8_1 = iter_8_1.player_unit

				if Unit.alive(var_8_1) then
					local var_8_2 = Managers.state.entity:system("buff_system")
					local var_8_3 = false

					var_8_2:add_buff(var_8_1, "twitch_grimoire_health_debuff", var_8_1, var_8_3)
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
	condition_func = function()
		return not var_0_1.disable_positive_votes
	end,
	on_success = function(arg_10_0)
		if arg_10_0 then
			var_0_0("[TWITCH VOTE] Adding no overcharge/no ammo reloads buff")

			local var_10_0 = Managers.player:human_and_bot_players()

			for iter_10_0, iter_10_1 in pairs(var_10_0) do
				local var_10_1 = iter_10_1.player_unit

				if Unit.alive(var_10_1) then
					local var_10_2 = Managers.state.entity:system("buff_system")
					local var_10_3 = false

					var_10_2:add_buff(var_10_1, "twitch_no_overcharge_no_ammo_reloads", var_10_1, var_10_3)

					local var_10_4 = "slot_ranged"
					local var_10_5 = 1
					local var_10_6 = ScriptUnit.extension(var_10_1, "inventory_system")
					local var_10_7 = var_10_6:get_slot_data(var_10_4)
					local var_10_8 = var_10_7.right_unit_1p
					local var_10_9 = var_10_7.left_unit_1p
					local var_10_10 = ScriptUnit.has_extension(var_10_8, "ammo_system")
					local var_10_11 = ScriptUnit.has_extension(var_10_9, "ammo_system")
					local var_10_12 = var_10_10 or var_10_11

					if var_10_12 and not var_10_6:is_ammo_blocked() then
						var_10_12:add_ammo(var_10_5)
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
	condition_func = function()
		return not var_0_1.disable_positive_votes
	end,
	on_success = function(arg_12_0)
		if arg_12_0 then
			var_0_0("[TWITCH VOTE] Adding health regen for all")

			local var_12_0 = Managers.player:human_and_bot_players()

			for iter_12_0, iter_12_1 in pairs(var_12_0) do
				local var_12_1 = iter_12_1.player_unit

				if Unit.alive(var_12_1) then
					local var_12_2 = Managers.state.entity:system("buff_system")
					local var_12_3 = false

					var_12_2:add_buff(var_12_1, "twitch_health_regen", var_12_1, var_12_3)
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
	on_success = function(arg_13_0, arg_13_1)
		if arg_13_0 then
			var_0_0("[TWITCH VOTE] Adding health degen for one")

			local var_13_0 = Managers.player:human_and_bot_players()
			local var_13_1 = SPProfiles[arg_13_1].display_name

			for iter_13_0, iter_13_1 in pairs(var_13_0) do
				local var_13_2 = iter_13_1:profile_index()

				if SPProfiles[var_13_2].display_name == var_13_1 then
					local var_13_3 = iter_13_1.player_unit

					if Unit.alive(var_13_3) then
						local var_13_4 = Managers.state.entity:system("buff_system")
						local var_13_5 = false

						var_13_4:add_buff(var_13_3, "twitch_health_degen", var_13_3, var_13_5)
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
	condition_func = function()
		return Managers.state.conflict.pacing:get_pacing_intensity() >= 80
	end,
	on_success = function(arg_15_0, arg_15_1)
		if arg_15_0 then
			var_0_0("[TWITCH VOTE] Adding root for all")

			local var_15_0 = Managers.player:human_and_bot_players()

			for iter_15_0, iter_15_1 in pairs(var_15_0) do
				local var_15_1 = iter_15_1.player_unit

				if Unit.alive(var_15_1) then
					local var_15_2 = Managers.state.entity:system("buff_system")
					local var_15_3 = false

					var_15_2:add_buff(var_15_1, "twitch_vote_buff_root", var_15_1, var_15_3)
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
	condition_func = function()
		return Managers.state.conflict.pacing:get_pacing_intensity() >= 80
	end,
	on_success = function(arg_17_0, arg_17_1)
		if arg_17_0 then
			var_0_0("[TWITCH VOTE] Adding root for one")

			local var_17_0 = Managers.player:human_and_bot_players()
			local var_17_1 = SPProfiles[arg_17_1].display_name

			for iter_17_0, iter_17_1 in pairs(var_17_0) do
				local var_17_2 = iter_17_1:profile_index()

				if SPProfiles[var_17_2].display_name == var_17_1 then
					local var_17_3 = iter_17_1.player_unit

					if Unit.alive(var_17_3) then
						local var_17_4 = Managers.state.entity:system("buff_system")
						local var_17_5 = false

						var_17_4:add_buff(var_17_3, "twitch_vote_buff_root", var_17_3, var_17_5)
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
	on_success = function(arg_18_0, arg_18_1)
		if arg_18_0 then
			var_0_0("[TWITCH VOTE] Adding hemmoraghe for one")

			local var_18_0 = Managers.player:human_and_bot_players()
			local var_18_1 = SPProfiles[arg_18_1].display_name

			for iter_18_0, iter_18_1 in pairs(var_18_0) do
				local var_18_2 = iter_18_1:profile_index()

				if SPProfiles[var_18_2].display_name == var_18_1 then
					local var_18_3 = iter_18_1.player_unit

					if Unit.alive(var_18_3) then
						local var_18_4 = Managers.state.entity:system("buff_system")
						local var_18_5 = false

						var_18_4:add_buff(var_18_3, "twitch_vote_buff_hemmoraghe", var_18_3, var_18_5)
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
	condition_func = function()
		return not var_0_1.disable_positive_votes
	end,
	on_success = function(arg_20_0, arg_20_1)
		if arg_20_0 then
			var_0_0("[TWITCH VOTE] Adding twitch_vote_full_temp_hp")

			local var_20_0 = Managers.player:human_and_bot_players()

			for iter_20_0, iter_20_1 in pairs(var_20_0) do
				local var_20_1 = iter_20_1.player_unit

				if Unit.alive(var_20_1) then
					local var_20_2 = ScriptUnit.extension(var_20_1, "health_system"):get_max_health()

					DamageUtils.heal_network(var_20_1, var_20_1, var_20_2, "healing_draught_temp_health")
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
	condition_func = function()
		return not var_0_1.disable_positive_votes
	end,
	on_success = function(arg_22_0, arg_22_1)
		if arg_22_0 then
			var_0_0("[TWITCH VOTE] Adding twitch_vote_invisibility")

			local var_22_0 = Managers.player:human_and_bot_players()

			for iter_22_0, iter_22_1 in pairs(var_22_0) do
				local var_22_1 = iter_22_1.player_unit

				if Unit.alive(var_22_1) then
					local var_22_2 = Managers.state.entity:system("buff_system")
					local var_22_3 = false

					var_22_2:add_buff(var_22_1, "twitch_vote_buff_critical_strikes", var_22_1, var_22_3)
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
	condition_func = function()
		return not var_0_1.disable_positive_votes
	end,
	on_success = function(arg_24_0, arg_24_1)
		if arg_24_0 then
			var_0_0("[TWITCH VOTE] Adding twitch_vote_infinite_bombs for one")

			local var_24_0 = Managers.player:human_and_bot_players()
			local var_24_1 = SPProfiles[arg_24_1].display_name

			for iter_24_0, iter_24_1 in pairs(var_24_0) do
				local var_24_2 = iter_24_1:profile_index()

				if SPProfiles[var_24_2].display_name == var_24_1 then
					local var_24_3 = iter_24_1.player_unit

					if Unit.alive(var_24_3) then
						local var_24_4 = Managers.state.entity:system("buff_system")
						local var_24_5 = false

						var_24_4:add_buff(var_24_3, "twitch_vote_buff_infinite_bombs", var_24_3, var_24_5)
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
	condition_func = function()
		local var_25_0 = Managers.state.conflict.pacing:get_pacing_intensity()

		return not var_0_1.disable_positive_votes and var_25_0 >= 100
	end,
	on_success = function(arg_26_0, arg_26_1)
		if arg_26_0 then
			var_0_0("[TWITCH VOTE] Adding twitch_vote_invincibility for one")

			local var_26_0 = Managers.player:human_and_bot_players()
			local var_26_1 = SPProfiles[arg_26_1].display_name

			for iter_26_0, iter_26_1 in pairs(var_26_0) do
				local var_26_2 = iter_26_1:profile_index()

				if SPProfiles[var_26_2].display_name == var_26_1 then
					local var_26_3 = iter_26_1.player_unit

					if Unit.alive(var_26_3) then
						local var_26_4 = Managers.state.entity:system("buff_system")
						local var_26_5 = false

						var_26_4:add_buff(var_26_3, "twitch_vote_buff_invincibility", var_26_3, var_26_5)
					end
				end
			end
		end
	end
}
