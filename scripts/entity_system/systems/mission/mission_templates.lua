-- chunkname: @scripts/entity_system/systems/mission/mission_templates.lua

MissionTemplates = {
	collect = {
		init = function(arg_1_0, arg_1_1)
			assert(arg_1_0.collect_amount > 0, "Collect mission with 0 needed collects")

			local var_1_0 = arg_1_0.collect_amount
			local var_1_1 = Localize(arg_1_0.text)
			local var_1_2 = arg_1_0.evaluate_at_level_end

			return {
				info_slate_type = "mission_objective",
				manual_update = true,
				current_amount = 0,
				update_sound = true,
				get_current_amount = function(arg_2_0)
					return arg_2_0.current_amount
				end,
				set_current_amount = function(arg_3_0, arg_3_1)
					arg_3_0.current_amount = arg_3_1
				end,
				increase_current_amount = function(arg_4_0, arg_4_1)
					arg_4_0.current_amount = arg_4_0.current_amount + arg_4_1

					return arg_4_0.current_amount
				end,
				collect_amount = var_1_0,
				mission_text = var_1_1,
				unit = arg_1_1,
				mission_data = arg_1_0,
				evaluate_at_level_end = var_1_2,
				evaluation_type = arg_1_0.evaluation_type or "percent",
				experience = arg_1_0.experience,
				bonus_dice = arg_1_0.bonus_dice,
				experience_per_percent = arg_1_0.experience_per_percent,
				dice_per_percent = arg_1_0.dice_per_percent,
				tokens_per_percent = arg_1_0.tokens_per_percent,
				experience_per_amount = arg_1_0.experience_per_amount,
				dice_per_amount = arg_1_0.dice_per_amount,
				tokens_per_amount = arg_1_0.tokens_per_amount,
				dice_type = arg_1_0.dice_type,
				token_type = arg_1_0.token_type
			}
		end,
		reset_mission = function(arg_5_0)
			arg_5_0:set_current_amount(0)
		end,
		update = function(arg_6_0, arg_6_1, arg_6_2)
			local var_6_0 = arg_6_0.collect_amount
			local var_6_1 = arg_6_0.evaluate_at_level_end
			local var_6_2 = arg_6_0:increase_current_amount(arg_6_1 and 1 or -1)

			return not var_6_1 and var_6_2 == var_6_0
		end,
		update_text = function(arg_7_0)
			local var_7_0 = arg_7_0.collect_amount
			local var_7_1 = arg_7_0:get_current_amount()
			local var_7_2 = string.format("%s/%s\n%s", tostring(var_7_1), tostring(var_7_0), arg_7_0.mission_text)

			arg_7_0.center_text, arg_7_0.text = string.format("%s/%s %s", tostring(var_7_1), tostring(var_7_0), arg_7_0.mission_text), var_7_2
		end,
		evaluate_mission = function(arg_8_0, arg_8_1)
			return arg_8_0:get_current_amount() == arg_8_0.collect_amount, arg_8_0:get_current_amount() / arg_8_0.collect_amount
		end,
		create_sync_data = function(arg_9_0)
			return {
				arg_9_0:get_current_amount()
			}
		end,
		sync = function(arg_10_0, arg_10_1)
			arg_10_0:set_current_amount(arg_10_1[1])
		end
	},
	defend = {
		init = function(arg_11_0, arg_11_1)
			assert(arg_11_0.defend_amount > 0, "Defend mission with 0 needed defends")

			local var_11_0 = arg_11_0.defend_amount
			local var_11_1 = Localize(arg_11_0.text)

			return {
				info_slate_type = "mission_objective",
				update_sound = true,
				manual_update = true,
				flow_update = true,
				defend_amount = var_11_0,
				current_amount = var_11_0,
				mission_text = var_11_1,
				unit = arg_11_1,
				mission_data = arg_11_0
			}
		end,
		update = function(arg_12_0, arg_12_1)
			local var_12_0 = arg_12_0.current_amount - 1

			arg_12_0.current_amount = var_12_0

			return var_12_0 == 0
		end,
		update_text = function(arg_13_0)
			local var_13_0 = arg_13_0.defend_amount
			local var_13_1 = arg_13_0.current_amount

			arg_13_0.text = arg_13_0.mission_text
		end,
		evaluate_mission = function(arg_14_0, arg_14_1)
			return arg_14_0.current_amount == arg_14_0.defend_amount, arg_14_0.current_amount / arg_14_0.defend_amount
		end,
		create_sync_data = function(arg_15_0)
			return {
				arg_15_0.current_amount
			}
		end,
		sync = function(arg_16_0, arg_16_1)
			arg_16_0.current_amount = arg_16_1[1]
		end
	},
	simple = {
		init = function(arg_17_0, arg_17_1)
			local var_17_0 = Localize(arg_17_0.text)
			local var_17_1 = string.format("%s", var_17_0)

			return {
				info_slate_type = "mission_objective",
				update_sound = true,
				manual_update = true,
				done = false,
				flow_update = true,
				mission_text = var_17_0,
				unit = arg_17_1,
				mission_data = arg_17_0,
				text = var_17_1
			}
		end,
		update = function(arg_18_0, arg_18_1)
			arg_18_0.done = true

			return true
		end,
		update_text = function(arg_19_0)
			return
		end,
		evaluate_mission = function(arg_20_0, arg_20_1)
			return arg_20_0.done, arg_20_0.done and 1 or 0
		end,
		create_sync_data = function(arg_21_0)
			return {}
		end,
		sync = function(arg_22_0, arg_22_1)
			return
		end
	},
	timed = {
		init = function(arg_23_0, arg_23_1)
			local var_23_0 = arg_23_0.duration
			local var_23_1 = Localize(arg_23_0.text)
			local var_23_2 = Managers.state.network:network_time()
			local var_23_3 = math.floor(var_23_2 + var_23_0)
			local var_23_4 = math.max(var_23_3 - var_23_2, 0)

			return {
				info_slate_type = "mission_objective",
				end_time = var_23_3,
				time_left = var_23_4,
				mission_text = var_23_1,
				unit = arg_23_1,
				mission_data = arg_23_0
			}
		end,
		update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			local var_24_0 = arg_24_0.end_time

			arg_24_0.time_left = math.max(var_24_0 - arg_24_3, 0)

			return var_24_0 <= arg_24_3
		end,
		update_text = function(arg_25_0)
			local var_25_0 = arg_25_0.mission_data
			local var_25_1 = math.ceil(arg_25_0.time_left)
			local var_25_2 = math.floor(var_25_1 / 60)
			local var_25_3 = var_25_1 % 60
			local var_25_4 = var_25_2 >= 10 and tostring(var_25_2) or string.format("0%s", tostring(var_25_2))
			local var_25_5 = var_25_3 >= 10 and tostring(var_25_3) or string.format("0%s", tostring(var_25_3))
			local var_25_6 = string.format("%s", arg_25_0.mission_text)

			arg_25_0.duration_text, arg_25_0.text = string.format("%s:%s", var_25_4, var_25_5), var_25_6
		end,
		evaluate_mission = function(arg_26_0, arg_26_1)
			return arg_26_0.time_left > 0, 0
		end,
		create_sync_data = function(arg_27_0)
			return {
				arg_27_0.end_time
			}
		end,
		sync = function(arg_28_0, arg_28_1)
			arg_28_0.end_time = arg_28_1[1]
		end
	},
	goal = {
		init = function(arg_29_0, arg_29_1)
			local var_29_0 = Localize(arg_29_0.text)

			return {
				manual_update = true,
				info_slate_type = "mission_goal",
				is_goal = true,
				mission_text = var_29_0,
				mission_data = arg_29_0,
				unit = arg_29_1
			}
		end,
		update = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
			return
		end,
		update_text = function(arg_31_0)
			arg_31_0.text = arg_31_0.mission_text
		end,
		evaluate_mission = function(arg_32_0, arg_32_1)
			return true, 1
		end,
		create_sync_data = function(arg_33_0)
			return {}
		end,
		sync = function(arg_34_0, arg_34_1)
			return
		end
	},
	players_alive = {
		init = function(arg_35_0, arg_35_1)
			local var_35_0 = Localize(arg_35_0.text)
			local var_35_1 = arg_35_0.evaluate_at_level_end

			return {
				info_slate_type = "mission_objective",
				mission_text = var_35_0,
				unit = arg_35_1,
				mission_data = arg_35_0,
				evaluate_at_level_end = var_35_1,
				experience_per_amount = arg_35_0.experience_per_amount,
				evaluation_type = arg_35_0.evaluation_type
			}
		end,
		update = function(arg_36_0, arg_36_1, arg_36_2)
			return
		end,
		update_text = function(arg_37_0)
			arg_37_0.text = ""
		end,
		evaluate_mission = function(arg_38_0, arg_38_1)
			local var_38_0 = Managers.player:human_and_bot_players()
			local var_38_1 = 0

			for iter_38_0, iter_38_1 in pairs(var_38_0) do
				local var_38_2 = iter_38_1.player_unit

				if Unit.alive(var_38_2) then
					local var_38_3 = ScriptUnit.extension(var_38_2, "status_system")

					if not var_38_3:is_disabled() and (var_38_3:is_in_end_zone() or iter_38_1.bot_player) then
						var_38_1 = var_38_1 + 1
					end
				end
			end

			return false, var_38_1
		end,
		create_sync_data = function(arg_39_0)
			return {}
		end,
		sync = function(arg_40_0, arg_40_1)
			return
		end
	},
	survival = {
		init = function(arg_41_0, arg_41_1)
			local var_41_0 = SurvivalSettings.wave
			local var_41_1 = SurvivalSettings.initial_wave
			local var_41_2 = {
				wave = 2,
				completed = 3,
				prepare = 1
			}
			local var_41_3 = var_41_2.prepare
			local var_41_4

			if arg_41_0.wave_completed_text then
				var_41_4 = Localize(arg_41_0.wave_completed_text)
			else
				var_41_4 = nil
			end

			local var_41_5

			if arg_41_0.wave_prepare_text then
				var_41_5 = Localize(arg_41_0.wave_prepare_text)
			else
				var_41_5 = nil
			end

			local var_41_6 = Localize(arg_41_0.wave_text)
			local var_41_7 = Managers.state.network:network_time()

			return {
				info_slate_type = "mission_objective",
				manual_update = true,
				flow_update = true,
				wave_completed = 0,
				update_sound = true,
				mission_text = var_41_6,
				mission_data = arg_41_0,
				unit = arg_41_1,
				wave = var_41_0,
				wave_state = var_41_3,
				wave_completed_text = var_41_4,
				wave_prepare_text = var_41_5,
				states = var_41_2,
				evaluate_at_level_end = arg_41_0.evaluate_at_level_end,
				experience_per_percent = arg_41_0.experience_per_percent,
				start_time = var_41_7,
				wave_completed_time = var_41_7,
				starting_wave = var_41_1
			}
		end,
		update = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
			if arg_42_0.wave_state == arg_42_0.states.wave and arg_42_0.wave_completed_text then
				arg_42_0.wave_state = arg_42_0.states.completed
				arg_42_0.wave_completed = arg_42_0.wave
				arg_42_0.wave_completed_time = arg_42_3
			elseif arg_42_0.wave_state == arg_42_0.states.completed and arg_42_0.wave_prepare_text then
				arg_42_0.wave_state = arg_42_0.states.prepare
			elseif arg_42_0.wave_state == arg_42_0.states.prepare then
				arg_42_0.wave_state = arg_42_0.states.wave
				arg_42_0.wave = arg_42_0.wave + 1
			elseif arg_42_0.wave_state == arg_42_0.states.wave and arg_42_0.wave_prepare_text then
				arg_42_0.wave_state = arg_42_0.states.prepare
			else
				arg_42_0.wave_state = arg_42_0.states.wave
				arg_42_0.wave = arg_42_0.wave + 1
			end
		end,
		update_text = function(arg_43_0)
			if arg_43_0.wave_state == arg_43_0.states.wave then
				arg_43_0.text = arg_43_0.mission_text .. " " .. arg_43_0.wave - arg_43_0.starting_wave
			elseif arg_43_0.wave_state == arg_43_0.states.completed then
				arg_43_0.text = arg_43_0.mission_text .. " " .. arg_43_0.wave - arg_43_0.starting_wave .. " " .. arg_43_0.wave_completed_text
			elseif arg_43_0.wave_state == arg_43_0.states.prepare then
				arg_43_0.text = arg_43_0.wave_prepare_text .. " " .. arg_43_0.wave - arg_43_0.starting_wave + 1
			else
				arg_43_0.text = arg_43_0.mission_text .. " " .. arg_43_0.wave - arg_43_0.starting_wave
			end
		end,
		evaluate_mission = function(arg_44_0, arg_44_1)
			return false, arg_44_0.wave_completed
		end,
		create_sync_data = function(arg_45_0)
			return {
				arg_45_0.wave,
				arg_45_0.wave_state,
				arg_45_0.start_time,
				arg_45_0.wave_completed,
				arg_45_0.wave_completed_time,
				arg_45_0.starting_wave
			}
		end,
		sync = function(arg_46_0, arg_46_1)
			arg_46_0.wave = arg_46_1[1]
			arg_46_0.wave_state = arg_46_1[2]
			arg_46_0.start_time = arg_46_1[3]
			arg_46_0.wave_completed = arg_46_1[4]
			arg_46_0.wave_completed_time = arg_46_1[5]
			arg_46_0.starting_wave = arg_46_1[6]
		end
	},
	tutorial = {
		init = function(arg_47_0, arg_47_1)
			local var_47_0 = Managers.state.network:network_time()

			return {
				manual_update = true,
				info_slate_type = "mission_goal",
				done = false,
				flow_update = true,
				start_time = var_47_0,
				unit = arg_47_1,
				mission_data = arg_47_0
			}
		end,
		update = function(arg_48_0, arg_48_1)
			arg_48_0.done = true

			return true
		end,
		update_text = function(arg_49_0)
			arg_49_0.text = ""
		end,
		evaluate_mission = function(arg_50_0, arg_50_1)
			return arg_50_0.done, arg_50_0.done and 1 or 0
		end,
		create_sync_data = function(arg_51_0)
			return {}
		end,
		sync = function(arg_52_0, arg_52_1)
			return
		end
	}
}
MissionTemplates.collect_uncompletable = table.clone(MissionTemplates.collect)

function MissionTemplates.collect_uncompletable.evaluate_mission(arg_53_0, arg_53_1)
	return false, arg_53_0:get_current_amount()
end
