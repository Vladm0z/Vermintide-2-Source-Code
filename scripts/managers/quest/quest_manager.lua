-- chunkname: @scripts/managers/quest/quest_manager.lua

local var_0_0 = require("scripts/managers/quest/quest_templates")
local var_0_1 = require("scripts/managers/quest/quest_outline")
local var_0_2 = {}
local var_0_3 = QuestSettings.rules

for iter_0_0, iter_0_1 in pairs(var_0_3) do
	local var_0_4 = string.format("%s_quest", iter_0_0)
	local var_0_5 = {}

	for iter_0_2 = 1, iter_0_1.max_quests do
		local var_0_6 = string.format("%s_%d", var_0_4, iter_0_2)

		var_0_5[#var_0_5 + 1] = var_0_6
	end

	var_0_2[iter_0_0] = var_0_5
end

QuestManager = class(QuestManager)

function QuestManager.init(arg_1_0, arg_1_1)
	arg_1_0._statistics_db = arg_1_1
	arg_1_0._backend_interface_quests = Managers.backend:get_interface("quests")

	Managers.state.event:register(arg_1_0, "event_stat_incremented", "event_stat_incremented")
	Managers.state.event:register(arg_1_0, "on_achievement_event", "on_achievement_event")
	arg_1_0:on_quests_updated()
end

function QuestManager.event_stat_incremented(arg_2_0, arg_2_1, ...)
	local var_2_0 = arg_2_0._backend_interface_quests:get_quests()
	local var_2_1 = var_2_0.daily
	local var_2_2 = var_2_0.weekly
	local var_2_3 = var_2_0.event

	if var_2_1 then
		arg_2_0:_increment_quest_stats(var_2_1, arg_2_1, ...)
	end

	if var_2_2 then
		arg_2_0:_increment_quest_stats(var_2_2, arg_2_1, ...)
	end

	if var_2_3 then
		arg_2_0:_increment_quest_stats(var_2_3, arg_2_1, ...)
	end
end

function QuestManager.on_achievement_event(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._backend_interface_quests:get_quests().event
	local var_3_1 = var_0_0.quests
	local var_3_2 = arg_3_0._statistics_db
	local var_3_3 = Managers.player:local_player():stats_id()
	local var_3_4 = arg_3_0._quest_event_mapping[arg_3_1]

	if var_3_4 then
		for iter_3_0 = 1, #var_3_4 do
			local var_3_5 = var_3_4[iter_3_0]
			local var_3_6 = var_3_0[var_3_5]

			if var_3_6 and not var_3_6.completed then
				var_3_1[var_3_6.name].on_event(var_3_2, var_3_3, nil, arg_3_1, arg_3_2, var_3_5)
			end
		end
	end
end

function QuestManager._increment_quest_stats(arg_4_0, arg_4_1, arg_4_2, ...)
	local var_4_0 = var_0_0.quests
	local var_4_1 = arg_4_0._statistics_db
	local var_4_2 = select("#", ...)

	for iter_4_0, iter_4_1 in pairs(arg_4_1) do
		local var_4_3 = var_4_0[iter_4_1.name]

		if var_4_3 then
			local var_4_4 = var_4_3.stat_mappings

			if var_4_4 then
				for iter_4_2 = 1, #var_4_4 do
					local var_4_5 = var_4_4[iter_4_2]
					local var_4_6 = true

					for iter_4_3 = 1, var_4_2 do
						var_4_5 = var_4_5[select(iter_4_3, ...)]

						if not var_4_5 then
							var_4_6 = false

							break
						end
					end

					if var_4_6 then
						local var_4_7 = QuestSettings.stat_mappings[iter_4_0][iter_4_2]

						var_4_1:increment_stat(arg_4_2, "quest_statistics", var_4_7)

						break
					end
				end
			end
		end
	end
end

function QuestManager.update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._reward_poll_id
	local var_5_1 = Managers.player:local_player()

	if not var_5_1 then
		return
	end

	local var_5_2 = var_5_1:stats_id()

	if var_5_0 then
		local var_5_3 = arg_5_0._statistics_db
		local var_5_4 = arg_5_0._backend_interface_quests

		if var_5_4:quest_rewards_generated(var_5_0) then
			local var_5_5 = var_5_4:get_quest_rewards(var_5_0).quest_key

			if type(var_5_5) == "string" then
				local var_5_6 = QuestSettings.stat_mappings[var_5_5]

				for iter_5_0 = 1, #var_5_6 do
					local var_5_7 = var_5_6[iter_5_0]

					var_5_3:set_stat(var_5_2, "quest_statistics", var_5_7, 0)
				end
			else
				for iter_5_1 = 1, #var_5_5 do
					local var_5_8 = var_5_5[iter_5_1]
					local var_5_9 = QuestSettings.stat_mappings[var_5_8]

					for iter_5_2 = 1, #var_5_9 do
						local var_5_10 = var_5_9[iter_5_2]

						var_5_3:set_stat(var_5_2, "quest_statistics", var_5_10, 0)
					end
				end
			end

			Managers.backend:commit()

			arg_5_0._reward_poll_id = nil
		end
	end

	local var_5_11 = arg_5_0._refresh_poll_id

	if var_5_11 then
		local var_5_12 = arg_5_0._statistics_db
		local var_5_13, var_5_14 = arg_5_0._backend_interface_quests:is_quest_refreshed(var_5_11)

		if var_5_13 then
			if var_5_14 then
				local var_5_15 = QuestSettings.stat_mappings[var_5_14]

				for iter_5_3 = 1, #var_5_15 do
					local var_5_16 = var_5_15[iter_5_3]

					var_5_12:set_stat(var_5_2, "quest_statistics", var_5_16, 0)
				end

				Managers.backend:commit()
			end

			arg_5_0._refresh_poll_id = nil
		end
	end
end

local var_0_7 = {}

function QuestManager.get_quest_outline(arg_6_0)
	local var_6_0 = arg_6_0._backend_interface_quests:get_quests()
	local var_6_1 = table.clone(var_0_1)
	local var_6_2 = var_6_1.categories

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		local var_6_3

		for iter_6_2, iter_6_3 in ipairs(var_6_2) do
			if iter_6_3.quest_type == iter_6_0 then
				var_6_3 = iter_6_3

				break
			end
		end

		for iter_6_4, iter_6_5 in pairs(iter_6_1) do
			local var_6_4 = iter_6_5.name
			local var_6_5 = iter_6_5.type
			local var_6_6 = iter_6_5.category_name
			local var_6_7 = var_0_0.quests[var_6_4] ~= nil

			if not var_6_7 and not table.contains(var_0_7, var_6_4) then
				Application.warning("[QuestManager] Quest does not exist for id %s", var_6_4)
				table.insert(var_0_7, var_6_4)
			end

			if var_6_7 then
				if var_6_6 then
					if not var_6_3.categories then
						var_6_3.categories = {}
					end

					local var_6_8 = var_6_3.categories
					local var_6_9

					for iter_6_6, iter_6_7 in ipairs(var_6_8) do
						if iter_6_7.name == var_6_6 then
							var_6_9 = iter_6_7

							break
						end
					end

					if not var_6_9 then
						var_6_9 = {
							type = "quest",
							entries = {},
							name = var_6_6
						}
						var_6_8[#var_6_8 + 1] = var_6_9
					end

					local var_6_10 = var_6_9.entries
					local var_6_11 = var_0_0.quests[var_6_4].custom_order
					local var_6_12

					if var_6_11 then
						for iter_6_8 = 1, #var_6_10 do
							if var_6_11 < (var_0_0.quests[var_6_10[iter_6_8]].custom_order or math.huge) then
								var_6_12 = iter_6_8

								break
							end
						end
					end

					table.insert(var_6_10, var_6_12 or #var_6_10 + 1, var_6_4)
				else
					local var_6_13 = var_6_3.entries
					local var_6_14 = var_0_0.quests[var_6_4].custom_order
					local var_6_15

					if var_6_14 then
						for iter_6_9 = 1, #var_6_13 do
							if var_6_14 < (var_0_0.quests[var_6_13[iter_6_9]].custom_order or math.huge) then
								var_6_15 = iter_6_9

								break
							end
						end
					end

					table.insert(var_6_13, var_6_15 or #var_6_13 + 1, var_6_4)
				end
			end
		end
	end

	return var_6_1
end

function QuestManager.get_data_by_id(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._backend_interface_quests
	local var_7_1 = var_7_0:get_quest_key(arg_7_1)
	local var_7_2 = var_0_0.quests
	local var_7_3 = var_7_2[arg_7_1]
	local var_7_4 = var_7_0:get_claimed_event_quests()

	fassert(var_7_1, "Trying to fetch data for quest %q not found in user's quest list.", arg_7_1)
	fassert(var_7_3, "Quest %q does not exist in quest_templates.", arg_7_1)

	local var_7_5
	local var_7_6
	local var_7_7
	local var_7_8
	local var_7_9
	local var_7_10
	local var_7_11 = Managers.player:local_player()

	if not var_7_11 then
		return nil, "Missing player"
	end

	local var_7_12 = var_7_11:stats_id()

	if type(var_7_3.name) == "function" then
		local var_7_13, var_7_14 = pcall(var_7_3.name)

		if var_7_13 then
			var_7_5 = var_7_14
		else
			Application.warning("Failed to evaluate quest name for %s: %s", arg_7_1, var_7_14)

			var_7_5 = "<Error>"
		end
	elseif type(var_7_3.name) == "string" then
		var_7_5 = Localize(var_7_3.name)
	end

	if type(var_7_3.desc) == "function" then
		local var_7_15, var_7_16 = pcall(var_7_3.desc)

		if var_7_15 then
			var_7_6 = var_7_16
		else
			Application.warning("Failed to evaluate quest desc for %s: %s", arg_7_1, var_7_16)

			var_7_6 = "<Error>"
		end
	elseif type(var_7_3.desc) == "string" then
		var_7_6 = Localize(var_7_3.desc)
	end

	if type(var_7_3.completed) == "boolean" then
		var_7_7 = var_7_3.completed
	elseif type(var_7_3.completed) == "function" then
		var_7_7 = var_7_3.completed(arg_7_0._statistics_db, var_7_12, var_7_1, var_7_2, var_7_4)
	end

	if type(var_7_3.progress) == "table" then
		var_7_8 = var_7_3.progress
	elseif type(var_7_3.progress) == "function" then
		var_7_8 = var_7_3.progress(arg_7_0._statistics_db, var_7_12, var_7_1, var_7_2, var_7_4)
	end

	if type(var_7_3.requirements) == "table" then
		var_7_9 = var_7_3.requirements
	elseif type(var_7_3.requirements) == "function" then
		var_7_9 = var_7_3.requirements(arg_7_0._statistics_db, var_7_12, var_7_1, var_7_2, var_7_4)
	end

	if var_7_9 then
		for iter_7_0, iter_7_1 in ipairs(var_7_9) do
			if type(iter_7_1.name) == "string" then
				iter_7_1.name = Localize(iter_7_1.name)
			elseif type(iter_7_1.name) == "function" then
				local var_7_17, var_7_18 = pcall(iter_7_1.name)

				if var_7_17 then
					iter_7_1.name = var_7_18
				else
					Application.warning("Failed to evaluate requirement name for %s: %s", arg_7_1, var_7_18)

					iter_7_1.name = "<Error>"
				end
			end
		end
	end

	local var_7_19 = var_7_3.icon
	local var_7_20 = var_7_3.reward
	local var_7_21
	local var_7_22 = var_7_0:get_quest_by_key(var_7_1)

	if var_7_22 and var_7_22.reward then
		var_7_20 = var_7_22.reward
	end

	return {
		claimed = false,
		id = arg_7_1,
		name = var_7_5,
		desc = var_7_6,
		icon = var_7_19,
		required_dlc = var_7_21,
		summary_icon = var_7_3.summary_icon,
		completed = var_7_7,
		progress = var_7_8,
		requirements = var_7_9,
		reward = var_7_20
	}
end

function QuestManager.has_any_unclaimed_quests(arg_8_0)
	local var_8_0 = arg_8_0:get_quest_outline()

	for iter_8_0, iter_8_1 in ipairs(var_8_0.categories) do
		local var_8_1 = iter_8_1.entries

		if var_8_1 then
			for iter_8_2, iter_8_3 in ipairs(var_8_1) do
				local var_8_2 = arg_8_0:get_data_by_id(iter_8_3)

				if var_8_2 and var_8_2.completed and not var_8_2.claimed then
					return true
				end
			end
		end
	end

	return false
end

function QuestManager.can_refresh_daily_quest(arg_9_0)
	if not arg_9_0._backend_interface_quests:can_refresh_daily_quest() then
		return nil, "Refresh Unavailable"
	end

	if arg_9_0._reward_poll_id or arg_9_0._refresh_poll_id then
		return nil, "Polling in progress."
	end

	return true
end

function QuestManager.refresh_daily_quest(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._backend_interface_quests
	local var_10_1 = var_10_0:get_quest_key(arg_10_1)
	local var_10_2 = var_10_0:refresh_daily_quest(var_10_1)

	arg_10_0._refresh_poll_id = var_10_2

	return var_10_2
end

function QuestManager.polling_quest_refresh(arg_11_0)
	return arg_11_0._refresh_poll_id and true or false
end

function QuestManager.claim_reward(arg_12_0, arg_12_1)
	if arg_12_0._reward_poll_id or arg_12_0._refresh_poll_id then
		return nil, "Polling in progress."
	end

	local var_12_0 = arg_12_0._backend_interface_quests
	local var_12_1 = var_12_0:get_quest_key(arg_12_1)

	if not var_12_1 then
		return nil, "Unable to find active quest"
	end

	local var_12_2 = var_12_0:claim_quest_rewards(var_12_1)

	arg_12_0._reward_poll_id = var_12_2

	return var_12_2
end

function QuestManager.claim_multiple_quest_rewards(arg_13_0, arg_13_1)
	if arg_13_0._reward_poll_id or arg_13_0._refresh_poll_id then
		return nil, "Polling in progress."
	end

	local var_13_0 = arg_13_0._backend_interface_quests
	local var_13_1 = {}

	for iter_13_0 = 1, #arg_13_1 do
		local var_13_2 = arg_13_1[iter_13_0]
		local var_13_3 = var_13_0:get_quest_key(var_13_2)

		if var_13_3 then
			var_13_1[#var_13_1 + 1] = var_13_3
		end
	end

	if table.is_empty(var_13_1) then
		return nil, "Unable to find any of the quests"
	end

	local var_13_4 = var_13_0:claim_multiple_quest_rewards(var_13_1)

	arg_13_0._reward_poll_id = var_13_4

	return var_13_4
end

function QuestManager.polling_quest_reward(arg_14_0)
	return arg_14_0._reward_poll_id and true or false
end

function QuestManager.can_claim_quest_rewards(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._backend_interface_quests
	local var_15_1 = var_15_0:get_quest_key(arg_15_1)

	if not var_15_1 then
		return nil, "Quest not currently active"
	end

	if not var_15_0:can_claim_quest_rewards(var_15_1) then
		return nil, "Quest already claimed."
	end

	if arg_15_0._reward_poll_id or arg_15_0._refresh_poll_id then
		return nil, "Polling in progress."
	end

	return true
end

function QuestManager.can_claim_multiple_quest_rewards(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._backend_interface_quests
	local var_16_1 = {}

	for iter_16_0 = 1, #arg_16_1 do
		local var_16_2 = arg_16_1[iter_16_0]
		local var_16_3 = var_16_0:get_quest_key(var_16_2)

		if var_16_3 then
			var_16_1[#var_16_1 + 1] = var_16_3
		end
	end

	if table.is_empty(var_16_1) then
		return nil, nil, "No quest currently active"
	end

	local var_16_4, var_16_5 = var_16_0:can_claim_multiple_quest_rewards(var_16_1)

	if not var_16_4 then
		return nil, nil, "Quest already claimed."
	end

	if arg_16_0._reward_poll_id or arg_16_0._refresh_poll_id then
		return nil, nil, "Polling in progress."
	end

	return true, var_16_5
end

function QuestManager.time_until_new_daily_quest(arg_17_0)
	return (arg_17_0._backend_interface_quests:get_daily_quest_update_time())
end

function QuestManager.time_until_new_weekly_quest(arg_18_0)
	return (arg_18_0._backend_interface_quests:get_weekly_quest_update_time())
end

function QuestManager.time_left_on_event_quest(arg_19_0)
	local var_19_0 = arg_19_0._backend_interface_quests
	local var_19_1 = var_19_0:get_quests().event

	if var_19_1 and not table.is_empty(var_19_1) then
		local var_19_2 = var_0_2.event

		for iter_19_0 = 1, #var_19_2 do
			local var_19_3 = var_19_2[iter_19_0]

			if var_19_1[var_19_3] then
				return (var_19_0:get_time_left_on_event_quest(var_19_3))
			end
		end
	end

	return 0
end

function QuestManager.update_quests(arg_20_0)
	local var_20_0 = arg_20_0._backend_interface_quests

	if var_20_0.update_quests then
		var_20_0:update_quests(callback(arg_20_0, "on_quests_updated"))
	end
end

local var_0_8 = {}

function QuestManager.on_quests_updated(arg_21_0)
	local var_21_0 = {}
	local var_21_1 = arg_21_0._backend_interface_quests:get_quests().event or var_0_8
	local var_21_2 = var_0_0.quests

	for iter_21_0, iter_21_1 in pairs(var_21_1) do
		local var_21_3 = var_21_2[iter_21_1.name]
		local var_21_4 = var_21_3 and var_21_3.events

		if var_21_4 then
			for iter_21_2 = 1, #var_21_4 do
				local var_21_5 = var_21_4[iter_21_2]

				var_21_0[var_21_5] = var_21_0[var_21_5] or {}
				var_21_0[var_21_5][#var_21_0[var_21_5] + 1] = iter_21_0
			end
		end
	end

	arg_21_0._quest_event_mapping = var_21_0
end
