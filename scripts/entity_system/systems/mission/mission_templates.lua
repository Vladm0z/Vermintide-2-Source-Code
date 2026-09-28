-- chunkname: @scripts/entity_system/systems/mission/mission_templates.lua

MissionTemplates = {
	collect = {
		init = function (mission_data, unit)
			-- function 1
			assert(mission_data.collect_amount > 0, "Collect mission with 0 needed collects")

			local collect_amount = mission_data.collect_amount
			local mission_text = Localize(mission_data.text)
			local evaluate_at_level_end = mission_data.evaluate_at_level_end
			local tbl = {
				info_slate_type = "mission_objective",
				manual_update = true,
				current_amount = 0,
				update_sound = true,
				get_current_amount = function (self)
					-- function 2
					return self.current_amount
				end,
				set_current_amount = function (self, value)
					-- function 3
					self.current_amount = value
				end,
				increase_current_amount = function (self, amount)
					-- function 4
					self.current_amount = self.current_amount + amount

					return self.current_amount
				end,
				collect_amount = collect_amount,
				mission_text = mission_text,
				unit = unit,
				mission_data = mission_data,
				evaluate_at_level_end = evaluate_at_level_end
			}
			local evaluation_type = mission_data.evaluation_type

			evaluation_type = not not evaluation_type or not not "percent"
			tbl.evaluation_type = evaluation_type
			tbl.experience = mission_data.experience
			tbl.bonus_dice = mission_data.bonus_dice
			tbl.experience_per_percent = mission_data.experience_per_percent
			tbl.dice_per_percent = mission_data.dice_per_percent
			tbl.tokens_per_percent = mission_data.tokens_per_percent
			tbl.experience_per_amount = mission_data.experience_per_amount
			tbl.dice_per_amount = mission_data.dice_per_amount
			tbl.tokens_per_amount = mission_data.tokens_per_amount
			tbl.dice_type = mission_data.dice_type
			tbl.token_type = mission_data.token_type

			local data = tbl

			return data
		end,
		reset_mission = function (data)
			-- function 5
			data:set_current_amount(0)
		end,
		update = function (data, positive, dt)
			-- function 6
			local collect_amount = data.collect_amount
			local evaluate_at_level_end = data.evaluate_at_level_end
			local var_6_0 = data
			local increase_current_amount = data.increase_current_amount
			local flag

			flag = (not positive or not 1) and not not -1

			local current_amount = increase_current_amount(var_6_0, flag)

			return not evaluate_at_level_end and current_amount == collect_amount
		end,
		update_text = function (data)
			-- function 7
			local collect_amount = data.collect_amount
			local current_amount = data:get_current_amount()
			local text = string.format("%s/%s\n%s", tostring(current_amount), tostring(collect_amount), data.mission_text)
			local center_text = string.format("%s/%s %s", tostring(current_amount), tostring(collect_amount), data.mission_text)

			data.text = text
			data.center_text = center_text
		end,
		evaluate_mission = function (data, dt)
			-- function 8
			return data:get_current_amount() == data.collect_amount, data:get_current_amount() / data.collect_amount
		end,
		create_sync_data = function (data)
			-- function 9
			local sync_data = {
				data:get_current_amount()
			}

			return sync_data
		end,
		sync = function (data, sync_data)
			-- function 10
			data:set_current_amount(sync_data[1])
		end
	},
	defend = {
		init = function (mission_data, unit)
			-- function 11
			assert(mission_data.defend_amount > 0, "Defend mission with 0 needed defends")

			local defend_amount = mission_data.defend_amount
			local mission_text = Localize(mission_data.text)
			local data = {
				info_slate_type = "mission_objective",
				update_sound = true,
				manual_update = true,
				flow_update = true,
				defend_amount = defend_amount,
				current_amount = defend_amount,
				mission_text = mission_text,
				unit = unit,
				mission_data = mission_data
			}

			return data
		end,
		update = function (data, dt)
			-- function 12
			local current_amount = data.current_amount - 1

			data.current_amount = current_amount

			return current_amount == 0
		end,
		update_text = function (data)
			-- function 13
			local defend_amount = data.defend_amount
			local current_amount = data.current_amount
			local text = data.mission_text

			data.text = text
		end,
		evaluate_mission = function (data, dt)
			-- function 14
			return data.current_amount == data.defend_amount, data.current_amount / data.defend_amount
		end,
		create_sync_data = function (data)
			-- function 15
			local sync_data = {
				data.current_amount
			}

			return sync_data
		end,
		sync = function (data, sync_data)
			-- function 16
			local current_amount = sync_data[1]

			data.current_amount = current_amount
		end
	},
	simple = {
		init = function (mission_data, unit)
			-- function 17
			local mission_text = Localize(mission_data.text)
			local text = string.format("%s", mission_text)
			local data = {
				info_slate_type = "mission_objective",
				update_sound = true,
				manual_update = true,
				done = false,
				flow_update = true,
				mission_text = mission_text,
				unit = unit,
				mission_data = mission_data,
				text = text
			}

			return data
		end,
		update = function (data, dt)
			-- function 18
			data.done = true

			return true
		end,
		update_text = function (data)
			-- function 19
			return
		end,
		evaluate_mission = function (data, dt)
			-- function 20
			local done = data.done
			local flag

			flag = (not data.done or not 1) and not not 0

			return done, flag
		end,
		create_sync_data = function (data)
			-- function 21
			local sync_data = {}

			return sync_data
		end,
		sync = function (data, sync_data)
			-- function 22
			return
		end
	},
	timed = {
		init = function (mission_data, unit)
			-- function 23
			local duration = mission_data.duration
			local mission_text = Localize(mission_data.text)
			local network_time = Managers.state.network:network_time()
			local end_time = math.floor(network_time + duration)
			local time_left = math.max(end_time - network_time, 0)
			local data = {
				info_slate_type = "mission_objective",
				end_time = end_time,
				time_left = time_left,
				mission_text = mission_text,
				unit = unit,
				mission_data = mission_data
			}

			return data
		end,
		update = function (data, positive, dt, network_time)
			-- function 24
			local end_time = data.end_time

			data.time_left = math.max(end_time - network_time, 0)

			return end_time <= network_time
		end,
		update_text = function (data)
			-- function 25
			local mission_data = data.mission_data
			local time = math.ceil(data.time_left)
			local minutes = math.floor(time / 60)
			local seconds = time % 60
			local var_25_0

			if minutes >= 10 then
				var_25_0 = tostring(minutes)

				if not var_25_0 then
					-- Nothing
				end
			end

			var_25_0 = string.format("0%s", tostring(minutes))

			local sminutes = var_25_0

			do
				local var_25_1
			end

			::label_25_0::

			if seconds >= 10 then
				var_25_1 = tostring(seconds)

				if not var_25_1 then
					-- Nothing
				end
			end

			var_25_1 = string.format("0%s", tostring(seconds))

			local sseconds = var_25_1

			::label_25_1::

			local text = string.format("%s", data.mission_text)
			local duration_text = string.format("%s:%s", sminutes, sseconds)

			data.text = text
			data.duration_text = duration_text
		end,
		evaluate_mission = function (data, dt)
			-- function 26
			return data.time_left > 0, 0
		end,
		create_sync_data = function (data)
			-- function 27
			local sync_data = {
				data.end_time
			}

			return sync_data
		end,
		sync = function (data, sync_data)
			-- function 28
			local end_time = sync_data[1]

			data.end_time = end_time
		end
	},
	goal = {
		init = function (mission_data, unit)
			-- function 29
			local mission_text = Localize(mission_data.text)
			local data = {
				manual_update = true,
				info_slate_type = "mission_goal",
				is_goal = true,
				mission_text = mission_text,
				mission_data = mission_data,
				unit = unit
			}

			return data
		end,
		update = function (data, positive, dt, network_time)
			-- function 30
			return
		end,
		update_text = function (data)
			-- function 31
			data.text = data.mission_text
		end,
		evaluate_mission = function (data, dt)
			-- function 32
			return true, 1
		end,
		create_sync_data = function (data)
			-- function 33
			local sync_data = {}

			return sync_data
		end,
		sync = function (data, sync_data)
			-- function 34
			return
		end
	},
	players_alive = {
		init = function (mission_data, unit)
			-- function 35
			local mission_text = Localize(mission_data.text)
			local evaluate_at_level_end = mission_data.evaluate_at_level_end
			local data = {
				info_slate_type = "mission_objective",
				mission_text = mission_text,
				unit = unit,
				mission_data = mission_data,
				evaluate_at_level_end = evaluate_at_level_end,
				experience_per_amount = mission_data.experience_per_amount,
				evaluation_type = mission_data.evaluation_type
			}

			return data
		end,
		update = function (data, positive, dt)
			-- function 36
			return
		end,
		update_text = function (data)
			-- function 37
			data.text = ""
		end,
		evaluate_mission = function (data, dt)
			-- function 38
			local players = Managers.player:human_and_bot_players()
			local num_alive = 0

			for _, player in pairs(players) do
				local unit = player.player_unit

				if Unit.alive(unit) then
					local status_extension = ScriptUnit.extension(unit, "status_system")

					if not status_extension:is_disabled() and (status_extension:is_in_end_zone() or player.bot_player) then
						num_alive = num_alive + 1
					end
				end
			end

			return false, num_alive
		end,
		create_sync_data = function (data)
			-- function 39
			local sync_data = {}

			return sync_data
		end,
		sync = function (data, sync_data)
			-- function 40
			return
		end
	},
	survival = {
		init = function (mission_data, unit)
			-- function 41
			local wave = SurvivalSettings.wave
			local starting_wave = SurvivalSettings.initial_wave
			local states = {
				wave = 2,
				completed = 3,
				prepare = 1
			}
			local wave_state = states.prepare
			local wave_completed_text

			if mission_data.wave_completed_text then
				wave_completed_text = Localize(mission_data.wave_completed_text)
			else
				wave_completed_text = nil
			end

			local wave_prepare_text

			if mission_data.wave_prepare_text then
				wave_prepare_text = Localize(mission_data.wave_prepare_text)
			else
				wave_prepare_text = nil
			end

			local mission_text = Localize(mission_data.wave_text)
			local start_time = Managers.state.network:network_time()
			local data = {
				info_slate_type = "mission_objective",
				manual_update = true,
				flow_update = true,
				wave_completed = 0,
				update_sound = true,
				mission_text = mission_text,
				mission_data = mission_data,
				unit = unit,
				wave = wave,
				wave_state = wave_state,
				wave_completed_text = wave_completed_text,
				wave_prepare_text = wave_prepare_text,
				states = states,
				evaluate_at_level_end = mission_data.evaluate_at_level_end,
				experience_per_percent = mission_data.experience_per_percent,
				start_time = start_time,
				wave_completed_time = start_time,
				starting_wave = starting_wave
			}

			return data
		end,
		update = function (data, positive, dt, network_time)
			-- function 42
			if data.wave_state == data.states.wave and data.wave_completed_text then
				data.wave_state = data.states.completed
				data.wave_completed = data.wave
				data.wave_completed_time = network_time
			elseif data.wave_state == data.states.completed and data.wave_prepare_text then
				data.wave_state = data.states.prepare
			elseif data.wave_state == data.states.prepare then
				data.wave_state = data.states.wave
				data.wave = data.wave + 1
			elseif data.wave_state == data.states.wave and data.wave_prepare_text then
				data.wave_state = data.states.prepare
			else
				data.wave_state = data.states.wave
				data.wave = data.wave + 1
			end
		end,
		update_text = function (data)
			-- function 43
			if data.wave_state == data.states.wave then
				data.text = data.mission_text .. " " .. data.wave - data.starting_wave
			elseif data.wave_state == data.states.completed then
				data.text = data.mission_text .. " " .. data.wave - data.starting_wave .. " " .. data.wave_completed_text
			elseif data.wave_state == data.states.prepare then
				data.text = data.wave_prepare_text .. " " .. data.wave - data.starting_wave + 1
			else
				data.text = data.mission_text .. " " .. data.wave - data.starting_wave
			end
		end,
		evaluate_mission = function (data, dt)
			-- function 44
			return false, data.wave_completed
		end,
		create_sync_data = function (data)
			-- function 45
			local sync_data = {
				data.wave,
				data.wave_state,
				data.start_time,
				data.wave_completed,
				data.wave_completed_time,
				data.starting_wave
			}

			return sync_data
		end,
		sync = function (data, sync_data)
			-- function 46
			local wave_num = sync_data[1]

			data.wave = wave_num

			local state = sync_data[2]

			data.wave_state = state

			local start_time = sync_data[3]

			data.start_time = start_time

			local wave_completed = sync_data[4]

			data.wave_completed = wave_completed

			local wave_completed_time = sync_data[5]

			data.wave_completed_time = wave_completed_time

			local starting_wave = sync_data[6]

			data.starting_wave = starting_wave
		end
	},
	tutorial = {
		init = function (mission_data, unit)
			-- function 47
			local start_time = Managers.state.network:network_time()
			local data = {
				manual_update = true,
				info_slate_type = "mission_goal",
				done = false,
				flow_update = true,
				start_time = start_time,
				unit = unit,
				mission_data = mission_data
			}

			return data
		end,
		update = function (data, dt)
			-- function 48
			data.done = true

			return true
		end,
		update_text = function (data)
			-- function 49
			data.text = ""
		end,
		evaluate_mission = function (data, dt)
			-- function 50
			local done = data.done
			local flag

			flag = (not data.done or not 1) and not not 0

			return done, flag
		end,
		create_sync_data = function (data)
			-- function 51
			local sync_data = {}

			return sync_data
		end,
		sync = function (data, sync_data)
			-- function 52
			return
		end
	}
}
MissionTemplates.collect_uncompletable = table.clone(MissionTemplates.collect)

MissionTemplates.collect_uncompletable.evaluate_mission = function (data, dt)
	-- function 53
	return false, data:get_current_amount()
end
