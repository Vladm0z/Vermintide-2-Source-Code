-- chunkname: @scripts/entity_system/systems/mission/rewards.lua

require("scripts/settings/economy")

local var_0_0 = {
	gold = "dice_04",
	metal = "dice_02",
	warpstone = "dice_05",
	wood = "dice_01"
}
local var_0_1 = {
	iron_tokens = "token_icon_01",
	silver_tokens = "token_icon_03",
	bronze_tokens = "token_icon_02",
	gold_tokens = "token_icon_04"
}

Rewards = class(Rewards)

local var_0_2 = 800
local var_0_3 = 500

function Rewards.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._level_key = arg_1_1
	arg_1_0._game_mode_key = arg_1_2
	arg_1_0._multiplier = ExperienceSettings.multiplier
	arg_1_0._end_of_level_loot_id = nil
	arg_1_0._quickplay_bonus = arg_1_3
end

function Rewards.award_end_of_level_rewards(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	local var_2_0 = Managers.deed

	if arg_2_1 and var_2_0:has_deed() and not var_2_0:is_deed_owner() then
		print("Awarding end of level rewards, found deed! Waiting for owner to consume.")

		arg_2_0._consuming_deed = true
		arg_2_0._end_of_level_info = {
			game_won = arg_2_1,
			hero_name = arg_2_2,
			game_time = arg_2_4,
			end_of_level_rewards_arguments = arg_2_5
		}

		local var_2_1 = callback(arg_2_0, "cb_deed_consumed")

		Managers.deed:consume_deed(var_2_1)
	else
		arg_2_0._end_of_level_info = {
			game_won = arg_2_1
		}

		local var_2_2 = arg_2_3 and "event" or "default"

		arg_2_0:_award_end_of_level_rewards(arg_2_1, arg_2_2, var_2_2, arg_2_4, arg_2_5, arg_2_6)
	end
end

function Rewards._award_end_of_level_rewards(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = Managers.backend
	local var_3_1 = var_3_0:get_interface("hero_attributes")
	local var_3_2 = var_3_1:get(arg_3_2, "experience")
	local var_3_3 = var_3_1:get(arg_3_2, "experience_pool")
	local var_3_4 = var_3_0:get_interface("versus"):get_profile_data("experience")

	arg_3_0._versus_start_experience = var_3_4

	local var_3_5
	local var_3_6

	if Managers.deed:has_deed() then
		print("Awarding end of level rewards, found deed!")

		local var_3_7, var_3_8 = Managers.deed:active_deed()

		var_3_5 = var_3_7.name
		var_3_6 = var_3_8
	end

	arg_3_0._mission_results = arg_3_0:_mission_results(arg_3_1, arg_3_6, arg_3_5)
	arg_3_0._start_experience = var_3_2
	arg_3_0._start_experience_pool = var_3_3

	local var_3_9 = Managers.backend:get_interface("win_tracks")

	if var_3_9 then
		local var_3_10 = var_3_9:get_current_win_track_id()

		arg_3_0._start_win_track_experience = var_3_9:get_win_track_experience(var_3_10)
	end

	local var_3_11, var_3_12 = arg_3_0:get_level_end()
	local var_3_13, var_3_14 = arg_3_0:get_versus_level_end()

	arg_3_0:_generate_end_of_level_loot(arg_3_1, arg_3_2, var_3_2, var_3_12, var_3_4, var_3_14, arg_3_3, var_3_5, var_3_6, arg_3_4, arg_3_5)
end

function Rewards._mission_results(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0._game_mode_key
	local var_4_1 = {}
	local var_4_2 = Managers.state.difficulty
	local var_4_3 = var_4_2:get_difficulty()
	local var_4_4 = var_4_2:get_difficulty_rank()
	local var_4_5 = true

	if arg_4_1 then
		if var_4_0 == "weave" then
			local var_4_6 = var_4_2:get_difficulty_settings().weave_settings.experience_reward_on_complete

			var_4_1[1] = {
				text = "end_screen_mission_completed",
				affected_by_multipliers = true,
				experience = var_4_6
			}
		elseif var_4_0 == "versus" then
			local var_4_7 = Managers.state.game_mode:settings().experience

			var_4_1[#var_4_1 + 1] = {
				text = "vs_match_won",
				affected_by_multipliers = true,
				experience = var_4_7.win_match
			}
		elseif var_4_0 == "deus" then
			local var_4_8 = {
				affected_by_multipliers = true,
				text = "expedition_completed_" .. var_4_3,
				experience = var_0_2
			}

			table.insert(var_4_1, 1, var_4_8)
		else
			arg_4_0:_add_missions_from_mission_system(var_4_1, var_4_4)

			local var_4_9 = {
				text = "end_screen_mission_completed",
				affected_by_multipliers = true,
				experience = var_0_2
			}

			table.insert(var_4_1, 1, var_4_9)
		end

		if var_4_0 == "adventure" and arg_4_3.first_time_completion then
			var_4_1[#var_4_1 + 1] = {
				text = "xp_first_time_completion",
				experience = var_0_3,
				format_values = {
					{
						localize = true,
						value = arg_4_3.ingame_display_name
					}
				}
			}
		end
	elseif var_4_0 == "weave" then
		local var_4_10 = var_4_2:get_difficulty_settings().weave_settings.experience_reward_on_complete
		local var_4_11 = Managers.state.entity:system("mission_system"):percentages_completed()
		local var_4_12 = 0

		for iter_4_0, iter_4_1 in pairs(var_4_11) do
			if var_4_12 < iter_4_1 then
				var_4_12 = iter_4_1
			end
		end

		local var_4_13 = LevelHelper:current_level_settings()

		var_4_12 = var_4_13 and var_4_13.disable_percentage_completed and 0 or math.clamp(var_4_12, 0, 1)

		local var_4_14 = {
			text = "mission_failed",
			affected_by_multipliers = true,
			experience = var_4_10 * var_4_12
		}

		table.insert(var_4_1, 1, var_4_14)
	elseif var_4_0 == "versus" then
		local var_4_15 = Managers.state.game_mode:settings().experience
		local var_4_16 = {
			text = "mission_failed",
			affected_by_multipliers = true,
			experience = var_4_15.lose_match
		}

		table.insert(var_4_1, 1, var_4_16)
	elseif var_4_0 == "deus" then
		local var_4_17 = Managers.state.entity:system("mission_system"):percentages_completed()
		local var_4_18 = 0

		for iter_4_2, iter_4_3 in pairs(var_4_17) do
			if var_4_18 < iter_4_3 then
				var_4_18 = iter_4_3
			end
		end

		local var_4_19 = LevelHelper:current_level_settings()

		var_4_18 = var_4_19 and var_4_19.disable_percentage_completed and 0 or math.clamp(var_4_18, 0, 1)

		local var_4_20 = {
			affected_by_multipliers = true,
			text = var_4_3 == "cataclysm" and "expedition_failed_cataclysm" or "expedition_failed",
			experience = var_0_2 * var_4_18
		}

		table.insert(var_4_1, 1, var_4_20)
	else
		local var_4_21 = Managers.state.entity:system("mission_system"):percentages_completed()
		local var_4_22 = 0

		for iter_4_4, iter_4_5 in pairs(var_4_21) do
			if var_4_22 < iter_4_5 then
				var_4_22 = iter_4_5
			end
		end

		local var_4_23 = LevelHelper:current_level_settings()

		var_4_22 = var_4_23 and var_4_23.disable_percentage_completed and 0 or math.clamp(var_4_22, 0, 1)

		local var_4_24 = {
			affected_by_multipliers = true,
			text = "mission_failed_" .. var_4_3,
			experience = var_0_2 * var_4_22
		}

		table.insert(var_4_1, 1, var_4_24)
	end

	if var_4_0 == "versus" then
		local var_4_25 = Managers.state.game_mode:settings().experience

		var_4_5 = false

		table.insert(var_4_1, 1, {
			text = "vs_match_completed",
			affected_by_multipliers = true,
			experience = var_4_25.complete_match
		})

		var_4_1[#var_4_1 + 1] = {
			text = "vs_rounds_played",
			affected_by_multipliers = true,
			experience = Managers.mechanism:game_mechanism():num_sets() * var_4_25.rounds_played
		}

		local var_4_26 = Managers.venture.statistics
		local var_4_27 = Managers.mechanism:profile_synchronizer()
		local var_4_28 = Managers.mechanism:get_players_session_score(var_4_26, var_4_27)[Managers.player:local_player():unique_id()]
		local var_4_29 = var_4_28 and var_4_28.scores or {}
		local var_4_30 = (var_4_29 and var_4_29.kills_heroes or 0) * var_4_25.hero_kills
		local var_4_31 = (var_4_29 and var_4_29.kills_specials or 0) * var_4_25.special_kills

		var_4_1[#var_4_1 + 1] = {
			text = "vs_scoreboard_eliminations",
			affected_by_multipliers = true,
			experience = var_4_30 + var_4_31
		}

		local var_4_32 = 0
		local var_4_33 = Managers.mechanism:get_stored_challenge_progression_status()
		local var_4_34 = Managers.mechanism:get_challenge_progression_status()

		for iter_4_6, iter_4_7 in pairs(var_4_33) do
			local var_4_35 = var_4_34[iter_4_6]

			if iter_4_7 < 1 and var_4_35 == 1 then
				var_4_32 = var_4_32 + 1
			end
		end

		local var_4_36 = var_4_25.challenges

		var_4_1[#var_4_1 + 1] = {
			text = "achv_menu_achievements_category_title",
			affected_by_multipliers = true,
			experience = var_4_32 * var_4_36,
			value = var_4_32
		}
	end

	if arg_4_2 then
		for iter_4_8, iter_4_9 in ipairs(arg_4_2) do
			iter_4_9.experience = iter_4_9.experience
			iter_4_9.affected_by_multipliers = true
			var_4_1[#var_4_1 + 1] = iter_4_9
		end
	end

	local var_4_37 = 0
	local var_4_38 = #var_4_1

	for iter_4_10 = 1, var_4_38 do
		local var_4_39 = var_4_1[iter_4_10]

		if var_4_39.affected_by_multipliers then
			var_4_37 = var_4_37 + var_4_39.experience
		end
	end

	local var_4_40 = arg_4_0:_experience_multipliers(var_4_5)
	local var_4_41 = #var_4_40

	if var_4_41 > 0 then
		local var_4_42 = Managers.state.game_mode:settings().max_num_rewards_displayed or 0

		if var_4_42 >= var_4_38 + var_4_41 then
			for iter_4_11 = 1, var_4_41 do
				local var_4_43 = var_4_40[iter_4_11]
				local var_4_44 = var_4_43.multiplier

				var_4_1[#var_4_1 + 1] = {
					text = var_4_43.text,
					format_values = {
						{
							value = var_4_44
						}
					},
					experience = var_4_37 * (var_4_44 - 1)
				}
			end
		else
			local var_4_45 = 1

			for iter_4_12 = 1, var_4_41 do
				var_4_45 = var_4_45 + (var_4_40[iter_4_12].multiplier - 1)
			end

			if var_4_42 <= var_4_38 then
				for iter_4_13 = 1, var_4_38 do
					local var_4_46 = var_4_1

					if var_4_46.experience then
						var_4_46.experience = var_4_46.experience * var_4_45
					end
				end
			else
				var_4_1[#var_4_1 + 1] = {
					text = "xp_multipliers",
					format_values = {
						{
							value = var_4_45
						}
					},
					experience = var_4_37 * (var_4_45 - 1)
				}
			end
		end
	end

	return var_4_1
end

function Rewards._add_missions_from_mission_system(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = 0
	local var_5_1, var_5_2 = Managers.state.entity:system("mission_system"):get_missions()

	for iter_5_0, iter_5_1 in pairs(var_5_2) do
		if not iter_5_1.is_goal and not iter_5_1.mission_data.disable_rewards then
			local var_5_3 = iter_5_1.experience or 0

			if not iter_5_1.bonus_dice then
				local var_5_4 = 0
			end

			if not iter_5_1.bonus_tokens then
				local var_5_5 = 0
			end

			local var_5_6 = iter_5_1.dice_type
			local var_5_7 = iter_5_1.token_type

			if var_5_3 > 0 then
				var_5_0 = var_5_0 + 1
				arg_5_1[var_5_0] = {
					text = iter_5_1.mission_data.text,
					experience = var_5_3
				}
			end
		end
	end

	for iter_5_2, iter_5_3 in pairs(var_5_1) do
		if not iter_5_3.is_goal and not iter_5_3.mission_data.disable_rewards then
			local var_5_8 = iter_5_3.mission_data.mission_template_name
			local var_5_9, var_5_10 = MissionTemplates[var_5_8].evaluate_mission(iter_5_3)

			fassert(not var_5_9, "mission was active AND done...")

			local var_5_11 = 0
			local var_5_12 = 0
			local var_5_13 = iter_5_3.dice_type
			local var_5_14 = 0
			local var_5_15 = iter_5_3.token_type

			if iter_5_3.evaluation_type == "percent" then
				local var_5_16 = var_5_10 * 100
				local var_5_17 = iter_5_3.experience_per_percent or 0
				local var_5_18 = iter_5_3.dice_per_percent or 0
				local var_5_19 = iter_5_3.tokens_per_percent or 0
				local var_5_20 = math.ceil(var_5_16 * var_5_17)
				local var_5_21 = math.floor(var_5_16 * var_5_18)
				local var_5_22 = math.floor(var_5_16 * var_5_19)

				if var_5_20 > 0 then
					var_5_0 = var_5_0 + 1
					arg_5_1[var_5_0] = {
						affected_by_multipliers = true,
						text = iter_5_3.mission_data.text,
						experience = var_5_20
					}
				end
			elseif iter_5_3.evaluation_type == "amount" then
				local var_5_23 = var_5_10
				local var_5_24 = iter_5_3.experience_per_amount or 0
				local var_5_25 = iter_5_3.dice_per_amount or 0
				local var_5_26 = iter_5_3.tokens_per_amount or 0
				local var_5_27 = var_5_23 * var_5_24
				local var_5_28 = var_5_23 * var_5_25
				local var_5_29 = var_5_23 * var_5_26

				if var_5_27 > 0 then
					var_5_0 = var_5_0 + 1
					arg_5_1[var_5_0] = {
						affected_by_multipliers = true,
						text = iter_5_3.mission_data.text,
						experience = var_5_27
					}
				end
			end
		end
	end
end

function Rewards._generate_end_of_level_loot(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10, arg_6_11)
	local var_6_0 = Managers.state.difficulty:get_difficulty()
	local var_6_1 = Managers.backend:get_interface("loot")
	local var_6_2 = arg_6_0._quickplay_bonus

	arg_6_0._end_of_level_loot_id = var_6_1:generate_end_of_level_loot(arg_6_1, var_6_2, var_6_0, arg_6_0._level_key, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_0._game_mode_key, arg_6_10, arg_6_11)
	arg_6_0._end_of_level_rewards_arguments = arg_6_11
	arg_6_0._is_loot_handled = false
end

function Rewards.cb_deed_consumed(arg_7_0)
	print("Deed has been consumed callback!")

	arg_7_0._consuming_deed = nil

	local var_7_0 = arg_7_0._end_of_level_info

	arg_7_0._end_of_level_info = nil

	local var_7_1 = var_7_0.game_won
	local var_7_2 = var_7_0.hero_name
	local var_7_3 = "default"
	local var_7_4 = var_7_0.game_time
	local var_7_5 = var_7_0.end_of_level_rewards_arguments

	arg_7_0:_award_end_of_level_rewards(var_7_1, var_7_2, var_7_3, var_7_4, var_7_5)
end

function Rewards.rewards_generated(arg_8_0)
	local var_8_0 = Managers.backend:get_interface("loot")
	local var_8_1 = arg_8_0._end_of_level_loot_id

	if var_8_1 then
		local var_8_2 = var_8_0:is_loot_generated(var_8_1)

		if var_8_2 then
			local var_8_3 = Managers.deed

			if var_8_3:has_deed() and var_8_3:is_deed_owner() and not arg_8_0._sent_consuming_deed then
				var_8_3:consume_deed()

				arg_8_0._sent_consuming_deed = true
			end

			if not arg_8_0._is_loot_handled then
				local var_8_4 = var_8_0:get_loot(var_8_1)

				for iter_8_0, iter_8_1 in pairs(var_8_4) do
					if string.find(iter_8_0, "experience_reward") == 1 then
						arg_8_0._mission_results[#arg_8_0._mission_results + 1] = {
							text = "bonus_experience_earned",
							experience = iter_8_1.amount
						}
					end
				end

				arg_8_0._is_loot_handled = true
			end

			if not arg_8_0._backend_mission_results_evaluated then
				arg_8_0:_evaluate_backend_mission_results()
			end
		end

		return var_8_2
	end

	return false
end

function Rewards._evaluate_backend_mission_results(arg_9_0)
	if arg_9_0._game_mode_key == "versus" and arg_9_0._end_of_level_info.game_won then
		local var_9_0 = Managers.state.game_mode:settings().experience
		local var_9_1 = Managers.backend:get_interface("versus")
		local var_9_2 = var_9_1:get_profile_data("first_win_of_the_day_timestamp") or 0

		if (var_9_1:get_profile_data("last_win_timestamp") or 0) == var_9_2 then
			table.insert(arg_9_0._mission_results, 3, {
				text = "vs_first_win_of_the_day",
				experience = var_9_0.first_win_of_the_day
			})
		end
	end

	arg_9_0._end_of_level_info = nil
	arg_9_0._backend_mission_results_evaluated = true
end

function Rewards.consuming_deed(arg_10_0)
	return arg_10_0._consuming_deed
end

function Rewards.get_rewards(arg_11_0)
	local var_11_0 = Managers.backend:get_interface("loot")
	local var_11_1 = arg_11_0._end_of_level_loot_id

	return var_11_0:get_loot(var_11_1), arg_11_0._end_of_level_rewards_arguments
end

function Rewards.get_end_of_level_rewards_arguments(arg_12_0)
	return arg_12_0._end_of_level_rewards_arguments
end

function Rewards.get_mission_results(arg_13_0)
	return arg_13_0._mission_results
end

function Rewards.get_level_start(arg_14_0)
	local var_14_0 = arg_14_0._start_experience or 0
	local var_14_1 = arg_14_0._start_experience_pool or 0

	return ExperienceSettings.get_level(var_14_0), var_14_0, var_14_1
end

function Rewards.get_versus_level_start(arg_15_0)
	local var_15_0 = arg_15_0._versus_start_experience or 0

	return ExperienceSettings.get_versus_level_from_experience(var_15_0), var_15_0
end

function Rewards.get_win_track_experience_start(arg_16_0)
	return arg_16_0._start_win_track_experience
end

function Rewards.get_level_end(arg_17_0)
	local var_17_0 = arg_17_0._mission_results
	local var_17_1 = 0

	for iter_17_0, iter_17_1 in ipairs(var_17_0) do
		var_17_1 = var_17_1 + (iter_17_1.experience or 0)
	end

	local var_17_2 = (arg_17_0._start_experience or 0) + var_17_1

	return ExperienceSettings.get_level(var_17_2), var_17_2
end

function Rewards.get_versus_level_end(arg_18_0)
	local var_18_0 = arg_18_0._mission_results
	local var_18_1 = 0

	for iter_18_0, iter_18_1 in ipairs(var_18_0) do
		var_18_1 = var_18_1 + (iter_18_1.experience or 0)
	end

	local var_18_2 = (arg_18_0._versus_start_experience or 0) + var_18_1

	return ExperienceSettings.get_versus_level_from_experience(var_18_2), var_18_2
end

function Rewards._experience_multipliers(arg_19_0, arg_19_1)
	local var_19_0 = {}
	local var_19_1 = Managers.backend:get_title_data("experience_multiplier") or 1

	if var_19_1 > 1 then
		var_19_0[#var_19_0 + 1] = {
			text = "xp_multiplier_event",
			multiplier = var_19_1
		}
	end

	local var_19_2 = Managers.state.difficulty:get_difficulty_settings().xp_multiplier or 1

	if var_19_2 > 1 then
		var_19_0[#var_19_0 + 1] = {
			text = "xp_multiplier_difficulty",
			multiplier = var_19_2
		}
	end

	if arg_19_1 then
		local var_19_3 = ExperienceSettings.hero_commendation_experience_multiplier()

		if var_19_3 > 1 then
			var_19_0[#var_19_0 + 1] = {
				text = "xp_multiplier_hero_commendation",
				multiplier = var_19_3
			}
		end
	end

	return var_19_0
end
