-- chunkname: @scripts/entity_system/systems/mission/mission_templates.lua

MissionTemplates = {
	collect = {
		init = function (self, arg_1_1)
			-- function 1
			assert(self.collect_amount > 0, "Collect mission with 0 needed collects")

			local collect_amount = self.collect_amount
			local var_1_1 = Localize(self.text)
			local evaluate_at_level_end = self.evaluate_at_level_end
			local tbl = {
				info_slate_type = "mission_objective",
				manual_update = true,
				current_amount = 0,
				update_sound = true,
				get_current_amount = function (self)
					-- function 2
					return self.current_amount
				end,
				set_current_amount = function (self, arg_3_1)
					-- function 3
					self.current_amount = arg_3_1
				end,
				increase_current_amount = function (self, arg_4_1)
					-- function 4
					self.current_amount = self.current_amount + arg_4_1

					return self.current_amount
				end,
				collect_amount = collect_amount,
				mission_text = var_1_1,
				unit = arg_1_1,
				mission_data = self,
				evaluate_at_level_end = evaluate_at_level_end
			}
			local evaluation_type = self.evaluation_type

			evaluation_type = evaluation_type or "percent"
			tbl.evaluation_type = evaluation_type
			tbl.experience = self.experience
			tbl.bonus_dice = self.bonus_dice
			tbl.experience_per_percent = self.experience_per_percent
			tbl.dice_per_percent = self.dice_per_percent
			tbl.tokens_per_percent = self.tokens_per_percent
			tbl.experience_per_amount = self.experience_per_amount
			tbl.dice_per_amount = self.dice_per_amount
			tbl.tokens_per_amount = self.tokens_per_amount
			tbl.dice_type = self.dice_type
			tbl.token_type = self.token_type

			return tbl
		end,
		reset_mission = function (self)
			-- function 5
			self:set_current_amount(0)
		end,
		update = function (self, arg_6_1, arg_6_2)
			-- function 6
			local collect_amount = self.collect_amount
			local evaluate_at_level_end = self.evaluate_at_level_end
			local var_6_2 = self
			local increase_current_amount = self.increase_current_amount
			local flag

			flag = not arg_6_1 and 1 and -1

			local var_6_5 = increase_current_amount(var_6_2, flag)

			return not not evaluate_at_level_end or var_6_5 == collect_amount
		end,
		update_text = function (self)
			-- function 7
			local collect_amount = self.collect_amount
			local get_current_amount = self:get_current_amount()
			local format = string.format("%s/%s\n%s", tostring(get_current_amount), tostring(collect_amount), self.mission_text)

			self.center_text, self.text = string.format("%s/%s %s", tostring(get_current_amount), tostring(collect_amount), self.mission_text), format
		end,
		evaluate_mission = function (self, arg_8_1)
			-- function 8
			return self:get_current_amount() == self.collect_amount, self:get_current_amount() / self.collect_amount
		end,
		create_sync_data = function (arg_9_0)
			-- function 9
			return {
				arg_9_0:get_current_amount()
			}
		end,
		sync = function (self, arg_10_1)
			-- function 10
			self:set_current_amount(arg_10_1[1])
		end
	},
	defend = {
		init = function (self, arg_11_1)
			-- function 11
			assert(self.defend_amount > 0, "Defend mission with 0 needed defends")

			local defend_amount = self.defend_amount
			local var_11_1 = Localize(self.text)

			return {
				info_slate_type = "mission_objective",
				update_sound = true,
				manual_update = true,
				flow_update = true,
				defend_amount = defend_amount,
				current_amount = defend_amount,
				mission_text = var_11_1,
				unit = arg_11_1,
				mission_data = self
			}
		end,
		update = function (self, arg_12_1)
			-- function 12
			local num = self.current_amount - 1

			self.current_amount = num

			return num == 0
		end,
		update_text = function (self)
			-- function 13
			local defend_amount = self.defend_amount
			local current_amount = self.current_amount

			self.text = self.mission_text
		end,
		evaluate_mission = function (self, arg_14_1)
			-- function 14
			return self.current_amount == self.defend_amount, self.current_amount / self.defend_amount
		end,
		create_sync_data = function (self)
			-- function 15
			return {
				self.current_amount
			}
		end,
		sync = function (self, arg_16_1)
			-- function 16
			self.current_amount = arg_16_1[1]
		end
	},
	simple = {
		init = function (self, arg_17_1)
			-- function 17
			local var_17_0 = Localize(self.text)
			local format = string.format("%s", var_17_0)

			return {
				info_slate_type = "mission_objective",
				update_sound = true,
				manual_update = true,
				done = false,
				flow_update = true,
				mission_text = var_17_0,
				unit = arg_17_1,
				mission_data = self,
				text = format
			}
		end,
		update = function (self, arg_18_1)
			-- function 18
			self.done = true

			return true
		end,
		update_text = function (arg_19_0)
			-- function 19
			return
		end,
		evaluate_mission = function (self, arg_20_1)
			-- function 20
			local done = self.done
			local flag

			flag = not self.done and 1 and 0

			return done, flag
		end,
		create_sync_data = function (arg_21_0)
			-- function 21
			return {}
		end,
		sync = function (arg_22_0, arg_22_1)
			-- function 22
			return
		end
	},
	timed = {
		init = function (self, arg_23_1)
			-- function 23
			local duration = self.duration
			local var_23_1 = Localize(self.text)
			local network_time = Managers.state.network:network_time()
			local floor = math.floor(network_time + duration)
			local max = math.max(floor - network_time, 0)

			return {
				info_slate_type = "mission_objective",
				end_time = floor,
				time_left = max,
				mission_text = var_23_1,
				unit = arg_23_1,
				mission_data = self
			}
		end,
		update = function (self, arg_24_1, arg_24_2, arg_24_3)
			-- function 24
			local end_time = self.end_time

			self.time_left = math.max(end_time - arg_24_3, 0)

			return end_time <= arg_24_3
		end,
		update_text = function (self)
			-- function 25
			local mission_data = self.mission_data
			local ceil = math.ceil(self.time_left)
			local floor = math.floor(ceil / 60)
			local num = ceil % 60
			local var_25_4

			if floor >= 10 then
				var_25_4 = tostring(floor)

				if not var_25_4 then
					-- Nothing
				end
			end

			var_25_4 = string.format("0%s", tostring(floor))

			do
				local var_25_5
			end

			::label_25_0::

			if num >= 10 then
				var_25_5 = tostring(num)

				if not var_25_5 then
					-- Nothing
				end
			end

			var_25_5 = string.format("0%s", tostring(num))

			::label_25_1::

			local format = string.format("%s", self.mission_text)

			self.duration_text, self.text = string.format("%s:%s", var_25_4, var_25_5), format
		end,
		evaluate_mission = function (self, arg_26_1)
			-- function 26
			return self.time_left > 0, 0
		end,
		create_sync_data = function (self)
			-- function 27
			return {
				self.end_time
			}
		end,
		sync = function (self, arg_28_1)
			-- function 28
			self.end_time = arg_28_1[1]
		end
	},
	goal = {
		init = function (self, arg_29_1)
			-- function 29
			local var_29_0 = Localize(self.text)

			return {
				manual_update = true,
				info_slate_type = "mission_goal",
				is_goal = true,
				mission_text = var_29_0,
				mission_data = self,
				unit = arg_29_1
			}
		end,
		update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
			-- function 30
			return
		end,
		update_text = function (self)
			-- function 31
			self.text = self.mission_text
		end,
		evaluate_mission = function (arg_32_0, arg_32_1)
			-- function 32
			return true, 1
		end,
		create_sync_data = function (arg_33_0)
			-- function 33
			return {}
		end,
		sync = function (arg_34_0, arg_34_1)
			-- function 34
			return
		end
	},
	players_alive = {
		init = function (self, arg_35_1)
			-- function 35
			local var_35_0 = Localize(self.text)
			local evaluate_at_level_end = self.evaluate_at_level_end

			return {
				info_slate_type = "mission_objective",
				mission_text = var_35_0,
				unit = arg_35_1,
				mission_data = self,
				evaluate_at_level_end = evaluate_at_level_end,
				experience_per_amount = self.experience_per_amount,
				evaluation_type = self.evaluation_type
			}
		end,
		update = function (arg_36_0, arg_36_1, arg_36_2)
			-- function 36
			return
		end,
		update_text = function (self)
			-- function 37
			self.text = ""
		end,
		evaluate_mission = function (arg_38_0, arg_38_1)
			-- function 38
			local human_and_bot_players = Managers.player:human_and_bot_players()
			local num = 0

			for k, v in pairs(human_and_bot_players) do
				local player_unit = v.player_unit

				if not Unit.alive(player_unit) then
					local extension = ScriptUnit.extension(player_unit, "status_system")

					if extension:is_disabled() or extension:is_in_end_zone() or not v.bot_player then
						num = num + 1
					end
				end
			end

			return false, num
		end,
		create_sync_data = function (arg_39_0)
			-- function 39
			return {}
		end,
		sync = function (arg_40_0, arg_40_1)
			-- function 40
			return
		end
	},
	survival = {
		init = function (self, arg_41_1)
			-- function 41
			local wave = SurvivalSettings.wave
			local initial_wave = SurvivalSettings.initial_wave
			local tbl = {
				wave = 2,
				completed = 3,
				prepare = 1
			}
			local prepare = tbl.prepare
			local var_41_4

			if not self.wave_completed_text then
				var_41_4 = Localize(self.wave_completed_text)
			else
				var_41_4 = nil
			end

			local var_41_5

			if not self.wave_prepare_text then
				var_41_5 = Localize(self.wave_prepare_text)
			else
				var_41_5 = nil
			end

			local var_41_6 = Localize(self.wave_text)
			local network_time = Managers.state.network:network_time()

			return {
				info_slate_type = "mission_objective",
				manual_update = true,
				flow_update = true,
				wave_completed = 0,
				update_sound = true,
				mission_text = var_41_6,
				mission_data = self,
				unit = arg_41_1,
				wave = wave,
				wave_state = prepare,
				wave_completed_text = var_41_4,
				wave_prepare_text = var_41_5,
				states = tbl,
				evaluate_at_level_end = self.evaluate_at_level_end,
				experience_per_percent = self.experience_per_percent,
				start_time = network_time,
				wave_completed_time = network_time,
				starting_wave = initial_wave
			}
		end,
		update = function (self, arg_42_1, arg_42_2, arg_42_3)
			-- function 42
			if self.wave_state ~= self.states.wave or not self.wave_completed_text then
				self.wave_state = self.states.completed
				self.wave_completed = self.wave
				self.wave_completed_time = arg_42_3
			elseif self.wave_state ~= self.states.completed or not self.wave_prepare_text then
				self.wave_state = self.states.prepare
			elseif self.wave_state == self.states.prepare then
				self.wave_state = self.states.wave
				self.wave = self.wave + 1
			elseif self.wave_state ~= self.states.wave or not self.wave_prepare_text then
				self.wave_state = self.states.prepare
			else
				self.wave_state = self.states.wave
				self.wave = self.wave + 1
			end
		end,
		update_text = function (self)
			-- function 43
			if self.wave_state == self.states.wave then
				self.text = self.mission_text .. " " .. self.wave - self.starting_wave
			elseif self.wave_state == self.states.completed then
				self.text = self.mission_text .. " " .. self.wave - self.starting_wave .. " " .. self.wave_completed_text
			elseif self.wave_state == self.states.prepare then
				self.text = self.wave_prepare_text .. " " .. self.wave - self.starting_wave + 1
			else
				self.text = self.mission_text .. " " .. self.wave - self.starting_wave
			end
		end,
		evaluate_mission = function (self, arg_44_1)
			-- function 44
			return false, self.wave_completed
		end,
		create_sync_data = function (self)
			-- function 45
			return {
				self.wave,
				self.wave_state,
				self.start_time,
				self.wave_completed,
				self.wave_completed_time,
				self.starting_wave
			}
		end,
		sync = function (self, arg_46_1)
			-- function 46
			self.wave = arg_46_1[1]
			self.wave_state = arg_46_1[2]
			self.start_time = arg_46_1[3]
			self.wave_completed = arg_46_1[4]
			self.wave_completed_time = arg_46_1[5]
			self.starting_wave = arg_46_1[6]
		end
	},
	tutorial = {
		init = function (arg_47_0, arg_47_1)
			-- function 47
			local network_time = Managers.state.network:network_time()

			return {
				manual_update = true,
				info_slate_type = "mission_goal",
				done = false,
				flow_update = true,
				start_time = network_time,
				unit = arg_47_1,
				mission_data = arg_47_0
			}
		end,
		update = function (self, arg_48_1)
			-- function 48
			self.done = true

			return true
		end,
		update_text = function (self)
			-- function 49
			self.text = ""
		end,
		evaluate_mission = function (self, arg_50_1)
			-- function 50
			local done = self.done
			local flag

			flag = not self.done and 1 and 0

			return done, flag
		end,
		create_sync_data = function (arg_51_0)
			-- function 51
			return {}
		end,
		sync = function (arg_52_0, arg_52_1)
			-- function 52
			return
		end
	}
}
MissionTemplates.collect_uncompletable = table.clone(MissionTemplates.collect)

MissionTemplates.collect_uncompletable.evaluate_mission = function (self, arg_53_1)
	-- function 53
	return false, self:get_current_amount()
end
