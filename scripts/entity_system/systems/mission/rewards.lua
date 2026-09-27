-- chunkname: @scripts/entity_system/systems/mission/rewards.lua

require("scripts/settings/economy")

local tbl = {
	gold = "dice_04",
	metal = "dice_02",
	warpstone = "dice_05",
	wood = "dice_01"
}
local tbl_2 = {
	iron_tokens = "token_icon_01",
	silver_tokens = "token_icon_03",
	bronze_tokens = "token_icon_02",
	gold_tokens = "token_icon_04"
}

Rewards = class(Rewards)

local num = 800
local num_2 = 500

Rewards.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._level_key = arg_1_1
	self._game_mode_key = arg_1_2
	self._multiplier = ExperienceSettings.multiplier
	self._end_of_level_loot_id = nil
	self._quickplay_bonus = arg_1_3
end

Rewards.award_end_of_level_rewards = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	local deed = Managers.deed

	if not (not arg_2_1 and not deed:has_deed() and deed:is_deed_owner()) then
		print("Awarding end of level rewards, found deed! Waiting for owner to consume.")

		self._consuming_deed = true
		self._end_of_level_info = {
			game_won = arg_2_1,
			hero_name = arg_2_2,
			game_time = arg_2_4,
			end_of_level_rewards_arguments = arg_2_5
		}

		local var_2_1 = callback(self, "cb_deed_consumed")

		Managers.deed:consume_deed(var_2_1)
	else
		self._end_of_level_info = {
			game_won = arg_2_1
		}

		local flag

		flag = not arg_2_3 and "event" and "default"

		self:_award_end_of_level_rewards(arg_2_1, arg_2_2, flag, arg_2_4, arg_2_5, arg_2_6)
	end
end

Rewards._award_end_of_level_rewards = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local backend = Managers.backend
	local get_interface = backend:get_interface("hero_attributes")
	local get = get_interface:get(arg_3_2, "experience")
	local get_2 = get_interface:get(arg_3_2, "experience_pool")
	local get_profile_data = backend:get_interface("versus"):get_profile_data("experience")

	self._versus_start_experience = get_profile_data

	local var_3_5
	local var_3_6

	if not Managers.deed:has_deed() then
		print("Awarding end of level rewards, found deed!")

		local active_deed, var_3_8 = Managers.deed:active_deed()

		var_3_5 = active_deed.name
		var_3_6 = var_3_8
	end

	self._mission_results = self:_mission_results(arg_3_1, arg_3_6, arg_3_5)
	self._start_experience = get
	self._start_experience_pool = get_2

	local get_interface_2 = Managers.backend:get_interface("win_tracks")

	if not get_interface_2 then
		local get_current_win_track_id = get_interface_2:get_current_win_track_id()

		self._start_win_track_experience = get_interface_2:get_win_track_experience(get_current_win_track_id)
	end

	local get_level_end, var_3_12 = self:get_level_end()
	local get_versus_level_end, var_3_14 = self:get_versus_level_end()

	self:_generate_end_of_level_loot(arg_3_1, arg_3_2, get, var_3_12, get_profile_data, var_3_14, arg_3_3, var_3_5, var_3_6, arg_3_4, arg_3_5)
end

Rewards._mission_results = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local _game_mode_key = self._game_mode_key
	local tbl = {}
	local difficulty = Managers.state.difficulty
	local get_difficulty = difficulty:get_difficulty()
	local get_difficulty_rank = difficulty:get_difficulty_rank()
	local flag = true

	if not arg_4_1 then
		if _game_mode_key == "weave" then
			local experience_reward_on_complete = difficulty:get_difficulty_settings().weave_settings.experience_reward_on_complete

			tbl[1] = {
				text = "end_screen_mission_completed",
				affected_by_multipliers = true,
				experience = experience_reward_on_complete
			}
		elseif _game_mode_key == "versus" then
			local experience = Managers.state.game_mode:settings().experience

			tbl[#tbl + 1] = {
				text = "vs_match_won",
				affected_by_multipliers = true,
				experience = experience.win_match
			}
		elseif _game_mode_key == "deus" then
			local tbl_2 = {
				affected_by_multipliers = true,
				text = "expedition_completed_" .. get_difficulty,
				experience = num
			}

			table.insert(tbl, 1, tbl_2)
		else
			self:_add_missions_from_mission_system(tbl, get_difficulty_rank)

			local tbl_3 = {
				text = "end_screen_mission_completed",
				affected_by_multipliers = true,
				experience = num
			}

			table.insert(tbl, 1, tbl_3)
		end

		if _game_mode_key ~= "adventure" or not arg_4_3.first_time_completion then
			tbl[#tbl + 1] = {
				text = "xp_first_time_completion",
				experience = num_2,
				format_values = {
					{
						localize = true,
						value = arg_4_3.ingame_display_name
					}
				}
			}
		end
	elseif _game_mode_key == "weave" then
		local experience_reward_on_complete_2 = difficulty:get_difficulty_settings().weave_settings.experience_reward_on_complete
		local percentages_completed = Managers.state.entity:system("mission_system"):percentages_completed()
		local num_3 = 0

		for k, v in pairs(percentages_completed) do
			if num_3 < v then
				num_3 = v
			end
		end

		local current_level_settings = LevelHelper:current_level_settings()

		num_3 = not (not current_level_settings and current_level_settings.disable_percentage_completed) and 0 and math.clamp(num_3, 0, 1)

		local tbl_4 = {
			text = "mission_failed",
			affected_by_multipliers = true,
			experience = experience_reward_on_complete_2 * num_3
		}

		table.insert(tbl, 1, tbl_4)
	elseif _game_mode_key == "versus" then
		local experience_2 = Managers.state.game_mode:settings().experience
		local tbl_5 = {
			text = "mission_failed",
			affected_by_multipliers = true,
			experience = experience_2.lose_match
		}

		table.insert(tbl, 1, tbl_5)
	elseif _game_mode_key == "deus" then
		local percentages_completed_2 = Managers.state.entity:system("mission_system"):percentages_completed()
		local num_4 = 0

		for k_2, v_2 in pairs(percentages_completed_2) do
			if num_4 < v_2 then
				num_4 = v_2
			end
		end

		local current_level_settings_2 = LevelHelper:current_level_settings()

		num_4 = not (not current_level_settings_2 and current_level_settings_2.disable_percentage_completed) and 0 and math.clamp(num_4, 0, 1)

		local tbl_6 = {
			affected_by_multipliers = true
		}
		local flag_2

		flag_2 = get_difficulty ~= "cataclysm" or not "expedition_failed_cataclysm" or "expedition_failed"
		tbl_6.text = flag_2
		tbl_6.experience = num * num_4

		table.insert(tbl, 1, tbl_6)
	else
		local percentages_completed_3 = Managers.state.entity:system("mission_system"):percentages_completed()
		local num_5 = 0

		for k_3, v_3 in pairs(percentages_completed_3) do
			if num_5 < v_3 then
				num_5 = v_3
			end
		end

		local current_level_settings_3 = LevelHelper:current_level_settings()

		num_5 = not (not current_level_settings_3 and current_level_settings_3.disable_percentage_completed) and 0 and math.clamp(num_5, 0, 1)

		local tbl_7 = {
			affected_by_multipliers = true,
			text = "mission_failed_" .. get_difficulty,
			experience = num * num_5
		}

		table.insert(tbl, 1, tbl_7)
	end

	if _game_mode_key == "versus" then
		local experience_3 = Managers.state.game_mode:settings().experience

		flag = false

		table.insert(tbl, 1, {
			text = "vs_match_completed",
			affected_by_multipliers = true,
			experience = experience_3.complete_match
		})

		tbl[#tbl + 1] = {
			text = "vs_rounds_played",
			affected_by_multipliers = true,
			experience = Managers.mechanism:game_mechanism():num_sets() * experience_3.rounds_played
		}

		local statistics = Managers.venture.statistics
		local profile_synchronizer = Managers.mechanism:profile_synchronizer()
		local var_4_29 = Managers.mechanism:get_players_session_score(statistics, profile_synchronizer)[Managers.player:local_player():unique_id()]
		local scores

		if not var_4_29 then
			scores = var_4_29.scores

			if not scores then
				-- Nothing
			end
		end

		scores = {}

		do
			local kills_heroes
		end

		::label_4_0::

		if not scores then
			kills_heroes = scores.kills_heroes

			if not kills_heroes then
				-- Nothing
			end
		end

		kills_heroes = 0

		::label_4_1::

		local num_6 = kills_heroes * experience_3.hero_kills
		local kills_specials

		if not scores then
			kills_specials = scores.kills_specials

			if not kills_specials then
				-- Nothing
			end
		end

		kills_specials = 0

		::label_4_2::

		local num_7 = kills_specials * experience_3.special_kills

		tbl[#tbl + 1] = {
			text = "vs_scoreboard_eliminations",
			affected_by_multipliers = true,
			experience = num_6 + num_7
		}

		local num_8 = 0
		local get_stored_challenge_progression_status = Managers.mechanism:get_stored_challenge_progression_status()
		local get_challenge_progression_status = Managers.mechanism:get_challenge_progression_status()

		for k_4, v_4 in pairs(get_stored_challenge_progression_status) do
			local var_4_38 = get_challenge_progression_status[k_4]

			if not (not (v_4 < 1) or var_4_38 ~= 1) then
				num_8 = num_8 + 1
			end
		end

		local challenges = experience_3.challenges

		tbl[#tbl + 1] = {
			text = "achv_menu_achievements_category_title",
			affected_by_multipliers = true,
			experience = num_8 * challenges,
			value = num_8
		}
	end

	if not arg_4_2 then
		for i, v_5 in ipairs(arg_4_2) do
			v_5.experience = v_5.experience
			v_5.affected_by_multipliers = true
			tbl[#tbl + 1] = v_5
		end
	end

	local num_9 = 0
	local count = #tbl

	for i10 = 1, count do
		local var_4_42 = tbl[i10]

		if not var_4_42.affected_by_multipliers then
			num_9 = num_9 + var_4_42.experience
		end
	end

	local _experience_multipliers = self:_experience_multipliers(flag)
	local count_2 = #_experience_multipliers

	if count_2 > 0 then
		local max_num_rewards_displayed = Managers.state.game_mode:settings().max_num_rewards_displayed

		max_num_rewards_displayed = max_num_rewards_displayed or 0

		if not (max_num_rewards_displayed >= count + count_2) then
			for i11 = 1, count_2 do
				local var_4_46 = _experience_multipliers[i11]
				local multiplier = var_4_46.multiplier

				tbl[#tbl + 1] = {
					text = var_4_46.text,
					format_values = {
						{
							value = multiplier
						}
					},
					experience = num_9 * (multiplier - 1)
				}
			end
		else
			local num_10 = 1

			for i12 = 1, count_2 do
				num_10 = num_10 + (_experience_multipliers[i12].multiplier - 1)
			end

			if max_num_rewards_displayed <= count then
				for i13 = 1, count do
					local var_4_49 = tbl

					if not var_4_49.experience then
						var_4_49.experience = var_4_49.experience * num_10
					end
				end
			else
				tbl[#tbl + 1] = {
					text = "xp_multipliers",
					format_values = {
						{
							value = num_10
						}
					},
					experience = num_9 * (num_10 - 1)
				}
			end
		end
	end

	return tbl
end

Rewards._add_missions_from_mission_system = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local num = 0
	local get_missions, var_5_2 = Managers.state.entity:system("mission_system"):get_missions()

	for k, v in pairs(var_5_2) do
		if not (v.is_goal or v.mission_data.disable_rewards) then
			local experience = v.experience

			experience = experience or 0

			if not v.bonus_dice then
				local num_2 = 0
			end

			if not v.bonus_tokens then
				local num_3 = 0
			end

			local dice_type = v.dice_type
			local token_type = v.token_type

			if experience > 0 then
				num = num + 1
				arg_5_1[num] = {
					text = v.mission_data.text,
					experience = experience
				}
			end
		end
	end

	for k_2, v_2 in pairs(get_missions) do
		if not (v_2.is_goal or v_2.mission_data.disable_rewards) then
			local mission_template_name = v_2.mission_data.mission_template_name
			local evaluate_mission, var_5_10 = MissionTemplates[mission_template_name].evaluate_mission(v_2)

			fassert(not evaluate_mission, "mission was active AND done...")

			local num_4 = 0
			local num_5 = 0
			local dice_type_2 = v_2.dice_type
			local num_6 = 0
			local token_type_2 = v_2.token_type

			if v_2.evaluation_type == "percent" then
				local num_7 = var_5_10 * 100
				local experience_per_percent = v_2.experience_per_percent

				experience_per_percent = experience_per_percent or 0

				local dice_per_percent = v_2.dice_per_percent

				dice_per_percent = dice_per_percent or 0

				local tokens_per_percent = v_2.tokens_per_percent

				tokens_per_percent = tokens_per_percent or 0

				local ceil = math.ceil(num_7 * experience_per_percent)
				local floor = math.floor(num_7 * dice_per_percent)
				local floor_2 = math.floor(num_7 * tokens_per_percent)

				if ceil > 0 then
					num = num + 1
					arg_5_1[num] = {
						affected_by_multipliers = true,
						text = v_2.mission_data.text,
						experience = ceil
					}
				end
			elseif v_2.evaluation_type == "amount" then
				local var_5_23 = var_5_10
				local experience_per_amount = v_2.experience_per_amount

				experience_per_amount = experience_per_amount or 0

				local dice_per_amount = v_2.dice_per_amount

				dice_per_amount = dice_per_amount or 0

				local tokens_per_amount = v_2.tokens_per_amount

				tokens_per_amount = tokens_per_amount or 0

				local num_8 = var_5_23 * experience_per_amount
				local num_9 = var_5_23 * dice_per_amount
				local num_10 = var_5_23 * tokens_per_amount

				if num_8 > 0 then
					num = num + 1
					arg_5_1[num] = {
						affected_by_multipliers = true,
						text = v_2.mission_data.text,
						experience = num_8
					}
				end
			end
		end
	end
end

Rewards._generate_end_of_level_loot = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10, arg_6_11)
	-- function 6
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local get_interface = Managers.backend:get_interface("loot")
	local _quickplay_bonus = self._quickplay_bonus

	self._end_of_level_loot_id = get_interface:generate_end_of_level_loot(arg_6_1, _quickplay_bonus, get_difficulty, self._level_key, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, self._game_mode_key, arg_6_10, arg_6_11)
	self._end_of_level_rewards_arguments = arg_6_11
	self._is_loot_handled = false
end

Rewards.cb_deed_consumed = function (self)
	-- function 7
	print("Deed has been consumed callback!")

	self._consuming_deed = nil

	local _end_of_level_info = self._end_of_level_info

	self._end_of_level_info = nil

	local game_won = _end_of_level_info.game_won
	local hero_name = _end_of_level_info.hero_name
	local str = "default"
	local game_time = _end_of_level_info.game_time
	local end_of_level_rewards_arguments = _end_of_level_info.end_of_level_rewards_arguments

	self:_award_end_of_level_rewards(game_won, hero_name, str, game_time, end_of_level_rewards_arguments)
end

Rewards.rewards_generated = function (self)
	-- function 8
	local get_interface = Managers.backend:get_interface("loot")
	local _end_of_level_loot_id = self._end_of_level_loot_id

	if not _end_of_level_loot_id then
		local is_loot_generated = get_interface:is_loot_generated(_end_of_level_loot_id)

		if not is_loot_generated then
			local deed = Managers.deed

			if not (not deed:has_deed() and not deed:is_deed_owner() and self._sent_consuming_deed) then
				deed:consume_deed()

				self._sent_consuming_deed = true
			end

			if not self._is_loot_handled then
				local get_loot = get_interface:get_loot(_end_of_level_loot_id)

				for k, v in pairs(get_loot) do
					if string.find(k, "experience_reward") == 1 then
						self._mission_results[#self._mission_results + 1] = {
							text = "bonus_experience_earned",
							experience = v.amount
						}
					end
				end

				self._is_loot_handled = true
			end

			if not self._backend_mission_results_evaluated then
				self:_evaluate_backend_mission_results()
			end
		end

		return is_loot_generated
	end

	return false
end

Rewards._evaluate_backend_mission_results = function (self)
	-- function 9
	if self._game_mode_key ~= "versus" or not self._end_of_level_info.game_won then
		local experience = Managers.state.game_mode:settings().experience
		local get_interface = Managers.backend:get_interface("versus")
		local get_profile_data = get_interface:get_profile_data("first_win_of_the_day_timestamp")

		get_profile_data = get_profile_data or 0

		local get_profile_data_2 = get_interface:get_profile_data("last_win_timestamp")

		get_profile_data_2 = get_profile_data_2 or 0

		if get_profile_data_2 == get_profile_data then
			table.insert(self._mission_results, 3, {
				text = "vs_first_win_of_the_day",
				experience = experience.first_win_of_the_day
			})
		end
	end

	self._end_of_level_info = nil
	self._backend_mission_results_evaluated = true
end

Rewards.consuming_deed = function (self)
	-- function 10
	return self._consuming_deed
end

Rewards.get_rewards = function (self)
	-- function 11
	local get_interface = Managers.backend:get_interface("loot")
	local _end_of_level_loot_id = self._end_of_level_loot_id

	return get_interface:get_loot(_end_of_level_loot_id), self._end_of_level_rewards_arguments
end

Rewards.get_end_of_level_rewards_arguments = function (self)
	-- function 12
	return self._end_of_level_rewards_arguments
end

Rewards.get_mission_results = function (self)
	-- function 13
	return self._mission_results
end

Rewards.get_level_start = function (self)
	-- function 14
	local _start_experience = self._start_experience

	_start_experience = _start_experience or 0

	local _start_experience_pool = self._start_experience_pool

	_start_experience_pool = _start_experience_pool or 0

	return ExperienceSettings.get_level(_start_experience), _start_experience, _start_experience_pool
end

Rewards.get_versus_level_start = function (self)
	-- function 15
	local _versus_start_experience = self._versus_start_experience

	_versus_start_experience = _versus_start_experience or 0

	return ExperienceSettings.get_versus_level_from_experience(_versus_start_experience), _versus_start_experience
end

Rewards.get_win_track_experience_start = function (self)
	-- function 16
	return self._start_win_track_experience
end

Rewards.get_level_end = function (self)
	-- function 17
	local _mission_results = self._mission_results
	local num = 0

	for i, v in ipairs(_mission_results) do
		local experience = v.experience

		experience = experience or 0
		num = num + experience
	end

	local _start_experience = self._start_experience

	_start_experience = _start_experience or 0

	local num_2 = _start_experience + num

	return ExperienceSettings.get_level(num_2), num_2
end

Rewards.get_versus_level_end = function (self)
	-- function 18
	local _mission_results = self._mission_results
	local num = 0

	for i, v in ipairs(_mission_results) do
		local experience = v.experience

		experience = experience or 0
		num = num + experience
	end

	local _versus_start_experience = self._versus_start_experience

	_versus_start_experience = _versus_start_experience or 0

	local num_2 = _versus_start_experience + num

	return ExperienceSettings.get_versus_level_from_experience(num_2), num_2
end

Rewards._experience_multipliers = function (arg_19_0, arg_19_1)
	-- function 19
	local tbl = {}
	local get_title_data = Managers.backend:get_title_data("experience_multiplier")

	get_title_data = get_title_data or 1

	if get_title_data > 1 then
		tbl[#tbl + 1] = {
			text = "xp_multiplier_event",
			multiplier = get_title_data
		}
	end

	local xp_multiplier = Managers.state.difficulty:get_difficulty_settings().xp_multiplier

	xp_multiplier = xp_multiplier or 1

	if xp_multiplier > 1 then
		tbl[#tbl + 1] = {
			text = "xp_multiplier_difficulty",
			multiplier = xp_multiplier
		}
	end

	if not arg_19_1 then
		local hero_commendation_experience_multiplier = ExperienceSettings.hero_commendation_experience_multiplier()

		if hero_commendation_experience_multiplier > 1 then
			tbl[#tbl + 1] = {
				text = "xp_multiplier_hero_commendation",
				multiplier = hero_commendation_experience_multiplier
			}
		end
	end

	return tbl
end
