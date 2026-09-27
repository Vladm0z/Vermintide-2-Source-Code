-- chunkname: @scripts/managers/quest/quest_manager.lua

local scripts_managers_quest_quest_templates = require("scripts/managers/quest/quest_templates")
local scripts_managers_quest_quest_outline = require("scripts/managers/quest/quest_outline")
local tbl = {}
local rules = QuestSettings.rules

for k, v in pairs(rules) do
	local format = string.format("%s_quest", k)
	local tbl_2 = {}

	for k_2 = 1, v.max_quests do
		local format_2 = string.format("%s_%d", format, k_2)

		tbl_2[#tbl_2 + 1] = format_2
	end

	tbl[k] = tbl_2
end

QuestManager = class(QuestManager)

QuestManager.init = function (self, arg_1_1)
	-- function 1
	self._statistics_db = arg_1_1
	self._backend_interface_quests = Managers.backend:get_interface("quests")

	Managers.state.event:register(self, "event_stat_incremented", "event_stat_incremented")
	Managers.state.event:register(self, "on_achievement_event", "on_achievement_event")
	self:on_quests_updated()
end

QuestManager.event_stat_incremented = function (self, arg_2_1, ...)
	-- function 2
	local get_quests = self._backend_interface_quests:get_quests()
	local daily = get_quests.daily
	local weekly = get_quests.weekly
	local event = get_quests.event

	if not daily then
		self:_increment_quest_stats(daily, arg_2_1, ...)
	end

	if not weekly then
		self:_increment_quest_stats(weekly, arg_2_1, ...)
	end

	if not event then
		self:_increment_quest_stats(event, arg_2_1, ...)
	end
end

QuestManager.on_achievement_event = function (self, arg_3_1, arg_3_2)
	-- function 3
	local event = self._backend_interface_quests:get_quests().event
	local quests = scripts_managers_quest_quest_templates.quests
	local _statistics_db = self._statistics_db
	local stats_id = Managers.player:local_player():stats_id()
	local var_3_4 = self._quest_event_mapping[arg_3_1]

	if not var_3_4 then
		for i = 1, #var_3_4 do
			local var_3_5 = var_3_4[i]
			local var_3_6 = event[var_3_5]

			if not (not var_3_6 and var_3_6.completed) then
				quests[var_3_6.name].on_event(_statistics_db, stats_id, nil, arg_3_1, arg_3_2, var_3_5)
			end
		end
	end
end

QuestManager._increment_quest_stats = function (self, arg_4_1, arg_4_2, ...)
	-- function 4
	local quests = scripts_managers_quest_quest_templates.quests
	local _statistics_db = self._statistics_db
	local var_4_2 = select("#", ...)

	for k, v in pairs(arg_4_1) do
		local var_4_3 = quests[v.name]

		if not var_4_3 then
			local stat_mappings = var_4_3.stat_mappings

			if not stat_mappings then
				for k_2 = 1, #stat_mappings do
					local var_4_5 = stat_mappings[k_2]
					local flag = true

					for l = 1, var_4_2 do
						var_4_5 = var_4_5[select(l, ...)]

						if not var_4_5 then
							flag = false

							break
						end
					end

					if not flag then
						local var_4_7 = QuestSettings.stat_mappings[k][k_2]

						_statistics_db:increment_stat(arg_4_2, "quest_statistics", var_4_7)

						break
					end
				end
			end
		end
	end
end

QuestManager.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _reward_poll_id = self._reward_poll_id
	local local_player = Managers.player:local_player()

	if not local_player then
		return
	end

	local stats_id = local_player:stats_id()

	if not _reward_poll_id then
		local _statistics_db = self._statistics_db
		local _backend_interface_quests = self._backend_interface_quests

		if not _backend_interface_quests:quest_rewards_generated(_reward_poll_id) then
			local quest_key = _backend_interface_quests:get_quest_rewards(_reward_poll_id).quest_key

			if type(quest_key) == "string" then
				local var_5_6 = QuestSettings.stat_mappings[quest_key]

				for i = 1, #var_5_6 do
					local var_5_7 = var_5_6[i]

					_statistics_db:set_stat(stats_id, "quest_statistics", var_5_7, 0)
				end
			else
				for j = 1, #quest_key do
					local var_5_8 = quest_key[j]
					local var_5_9 = QuestSettings.stat_mappings[var_5_8]

					for k = 1, #var_5_9 do
						local var_5_10 = var_5_9[k]

						_statistics_db:set_stat(stats_id, "quest_statistics", var_5_10, 0)
					end
				end
			end

			Managers.backend:commit()

			self._reward_poll_id = nil
		end
	end

	local _refresh_poll_id = self._refresh_poll_id

	if not _refresh_poll_id then
		local _statistics_db_2 = self._statistics_db
		local is_quest_refreshed, var_5_14 = self._backend_interface_quests:is_quest_refreshed(_refresh_poll_id)

		if not is_quest_refreshed then
			if not var_5_14 then
				local var_5_15 = QuestSettings.stat_mappings[var_5_14]

				for l = 1, #var_5_15 do
					local var_5_16 = var_5_15[l]

					_statistics_db_2:set_stat(stats_id, "quest_statistics", var_5_16, 0)
				end

				Managers.backend:commit()
			end

			self._refresh_poll_id = nil
		end
	end
end

local tbl_3 = {}

QuestManager.get_quest_outline = function (self)
	-- function 6
	local get_quests = self._backend_interface_quests:get_quests()
	local clone = table.clone(scripts_managers_quest_quest_outline)
	local categories = clone.categories

	for k, v in pairs(get_quests) do
		local var_6_3

		for i, v_2 in ipairs(categories) do
			if v_2.quest_type == k then
				var_6_3 = v_2

				break
			end
		end

		for k_2, v_3 in pairs(v) do
			local name = v_3.name
			local type = v_3.type
			local category_name = v_3.category_name
			local flag = scripts_managers_quest_quest_templates.quests[name] ~= nil

			if not (flag or table.contains(tbl_3, name)) then
				Application.warning("[QuestManager] Quest does not exist for id %s", name)
				table.insert(tbl_3, name)
			end

			if not flag then
				if not category_name then
					if not var_6_3.categories then
						var_6_3.categories = {}
					end

					local categories_2 = var_6_3.categories
					local var_6_9

					for i_2, v_4 in ipairs(categories_2) do
						if v_4.name == category_name then
							var_6_9 = v_4

							break
						end
					end

					if not var_6_9 then
						var_6_9 = {
							type = "quest",
							entries = {},
							name = category_name
						}
						categories_2[#categories_2 + 1] = var_6_9
					end

					local entries = var_6_9.entries
					local custom_order = scripts_managers_quest_quest_templates.quests[name].custom_order
					local var_6_12

					if not custom_order then
						for i8 = 1, #entries do
							local custom_order_2 = scripts_managers_quest_quest_templates.quests[entries[i8]].custom_order

							custom_order_2 = custom_order_2 or math.huge

							if custom_order < custom_order_2 then
								var_6_12 = i8

								break
							end
						end
					end

					table.insert(entries, var_6_12 or #entries + 1, name)
				else
					local entries_2 = var_6_3.entries
					local custom_order_3 = scripts_managers_quest_quest_templates.quests[name].custom_order
					local var_6_16

					if not custom_order_3 then
						for i9 = 1, #entries_2 do
							local custom_order_4 = scripts_managers_quest_quest_templates.quests[entries_2[i9]].custom_order

							custom_order_4 = custom_order_4 or math.huge

							if custom_order_3 < custom_order_4 then
								var_6_16 = i9

								break
							end
						end
					end

					table.insert(entries_2, var_6_16 or #entries_2 + 1, name)
				end
			end
		end
	end

	return clone
end

QuestManager.get_data_by_id = function (self, arg_7_1)
	-- function 7
	local _backend_interface_quests = self._backend_interface_quests
	local get_quest_key = _backend_interface_quests:get_quest_key(arg_7_1)
	local quests = scripts_managers_quest_quest_templates.quests
	local var_7_3 = quests[arg_7_1]
	local get_claimed_event_quests = _backend_interface_quests:get_claimed_event_quests()

	fassert(get_quest_key, "Trying to fetch data for quest %q not found in user's quest list.", arg_7_1)
	fassert(var_7_3, "Quest %q does not exist in quest_templates.", arg_7_1)

	local var_7_5
	local var_7_6
	local var_7_7
	local var_7_8
	local var_7_9
	local var_7_10
	local local_player = Managers.player:local_player()

	if not local_player then
		return nil, "Missing player"
	end

	local stats_id = local_player:stats_id()

	if type(var_7_3.name) == "function" then
		local var_7_13, var_7_14 = pcall(var_7_3.name)

		if not var_7_13 then
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

		if not var_7_15 then
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
		var_7_7 = var_7_3.completed(self._statistics_db, stats_id, get_quest_key, quests, get_claimed_event_quests)
	end

	if type(var_7_3.progress) == "table" then
		var_7_8 = var_7_3.progress
	elseif type(var_7_3.progress) == "function" then
		var_7_8 = var_7_3.progress(self._statistics_db, stats_id, get_quest_key, quests, get_claimed_event_quests)
	end

	if type(var_7_3.requirements) == "table" then
		var_7_9 = var_7_3.requirements
	elseif type(var_7_3.requirements) == "function" then
		var_7_9 = var_7_3.requirements(self._statistics_db, stats_id, get_quest_key, quests, get_claimed_event_quests)
	end

	if not var_7_9 then
		for i, v in ipairs(var_7_9) do
			if type(v.name) == "string" then
				v.name = Localize(v.name)
			elseif type(v.name) == "function" then
				local var_7_17, var_7_18 = pcall(v.name)

				if not var_7_17 then
					v.name = var_7_18
				else
					Application.warning("Failed to evaluate requirement name for %s: %s", arg_7_1, var_7_18)

					v.name = "<Error>"
				end
			end
		end
	end

	local icon = var_7_3.icon
	local reward = var_7_3.reward
	local var_7_21
	local get_quest_by_key = _backend_interface_quests:get_quest_by_key(get_quest_key)

	if not get_quest_by_key and not get_quest_by_key.reward then
		reward = get_quest_by_key.reward
	end

	return {
		claimed = false,
		id = arg_7_1,
		name = var_7_5,
		desc = var_7_6,
		icon = icon,
		required_dlc = var_7_21,
		summary_icon = var_7_3.summary_icon,
		completed = var_7_7,
		progress = var_7_8,
		requirements = var_7_9,
		reward = reward
	}
end

QuestManager.has_any_unclaimed_quests = function (self)
	-- function 8
	local get_quest_outline = self:get_quest_outline()

	for i, v in ipairs(get_quest_outline.categories) do
		local entries = v.entries

		if not entries then
			for i_2, v_2 in ipairs(entries) do
				local get_data_by_id = self:get_data_by_id(v_2)

				if not (not get_data_by_id and not get_data_by_id.completed and get_data_by_id.claimed) then
					return true
				end
			end
		end
	end

	return false
end

QuestManager.can_refresh_daily_quest = function (self)
	-- function 9
	if not self._backend_interface_quests:can_refresh_daily_quest() then
		return nil, "Refresh Unavailable"
	end

	if self._reward_poll_id or not self._refresh_poll_id then
		return nil, "Polling in progress."
	end

	return true
end

QuestManager.refresh_daily_quest = function (self, arg_10_1)
	-- function 10
	local _backend_interface_quests = self._backend_interface_quests
	local get_quest_key = _backend_interface_quests:get_quest_key(arg_10_1)
	local refresh_daily_quest = _backend_interface_quests:refresh_daily_quest(get_quest_key)

	self._refresh_poll_id = refresh_daily_quest

	return refresh_daily_quest
end

QuestManager.polling_quest_refresh = function (self)
	-- function 11
	local flag

	flag = not self._refresh_poll_id and true and false

	return flag
end

QuestManager.claim_reward = function (self, arg_12_1)
	-- function 12
	if self._reward_poll_id or not self._refresh_poll_id then
		return nil, "Polling in progress."
	end

	local _backend_interface_quests = self._backend_interface_quests
	local get_quest_key = _backend_interface_quests:get_quest_key(arg_12_1)

	if not get_quest_key then
		return nil, "Unable to find active quest"
	end

	local claim_quest_rewards = _backend_interface_quests:claim_quest_rewards(get_quest_key)

	self._reward_poll_id = claim_quest_rewards

	return claim_quest_rewards
end

QuestManager.claim_multiple_quest_rewards = function (self, arg_13_1)
	-- function 13
	if self._reward_poll_id or not self._refresh_poll_id then
		return nil, "Polling in progress."
	end

	local _backend_interface_quests = self._backend_interface_quests
	local tbl = {}

	for i = 1, #arg_13_1 do
		local var_13_2 = arg_13_1[i]
		local get_quest_key = _backend_interface_quests:get_quest_key(var_13_2)

		if not get_quest_key then
			tbl[#tbl + 1] = get_quest_key
		end
	end

	if not table.is_empty(tbl) then
		return nil, "Unable to find any of the quests"
	end

	local claim_multiple_quest_rewards = _backend_interface_quests:claim_multiple_quest_rewards(tbl)

	self._reward_poll_id = claim_multiple_quest_rewards

	return claim_multiple_quest_rewards
end

QuestManager.polling_quest_reward = function (self)
	-- function 14
	local flag

	flag = not self._reward_poll_id and true and false

	return flag
end

QuestManager.can_claim_quest_rewards = function (self, arg_15_1)
	-- function 15
	local _backend_interface_quests = self._backend_interface_quests
	local get_quest_key = _backend_interface_quests:get_quest_key(arg_15_1)

	if not get_quest_key then
		return nil, "Quest not currently active"
	end

	if not _backend_interface_quests:can_claim_quest_rewards(get_quest_key) then
		return nil, "Quest already claimed."
	end

	if self._reward_poll_id or not self._refresh_poll_id then
		return nil, "Polling in progress."
	end

	return true
end

QuestManager.can_claim_multiple_quest_rewards = function (self, arg_16_1)
	-- function 16
	local _backend_interface_quests = self._backend_interface_quests
	local tbl = {}

	for i = 1, #arg_16_1 do
		local var_16_2 = arg_16_1[i]
		local get_quest_key = _backend_interface_quests:get_quest_key(var_16_2)

		if not get_quest_key then
			tbl[#tbl + 1] = get_quest_key
		end
	end

	if not table.is_empty(tbl) then
		return nil, nil, "No quest currently active"
	end

	local can_claim_multiple_quest_rewards, var_16_5 = _backend_interface_quests:can_claim_multiple_quest_rewards(tbl)

	if not can_claim_multiple_quest_rewards then
		return nil, nil, "Quest already claimed."
	end

	if self._reward_poll_id or not self._refresh_poll_id then
		return nil, nil, "Polling in progress."
	end

	return true, var_16_5
end

QuestManager.time_until_new_daily_quest = function (self)
	-- function 17
	return (self._backend_interface_quests:get_daily_quest_update_time())
end

QuestManager.time_until_new_weekly_quest = function (self)
	-- function 18
	return (self._backend_interface_quests:get_weekly_quest_update_time())
end

QuestManager.time_left_on_event_quest = function (self)
	-- function 19
	local _backend_interface_quests = self._backend_interface_quests
	local event = _backend_interface_quests:get_quests().event

	if not (not event and table.is_empty(event)) then
		local event_2 = tbl.event

		for i = 1, #event_2 do
			local var_19_3 = event_2[i]

			if not event[var_19_3] then
				return (_backend_interface_quests:get_time_left_on_event_quest(var_19_3))
			end
		end
	end

	return 0
end

QuestManager.update_quests = function (self)
	-- function 20
	local _backend_interface_quests = self._backend_interface_quests

	if not _backend_interface_quests.update_quests then
		_backend_interface_quests:update_quests(callback(self, "on_quests_updated"))
	end
end

local tbl_4 = {}

QuestManager.on_quests_updated = function (self)
	-- function 21
	local tbl = {}
	local event = self._backend_interface_quests:get_quests().event

	event = event or tbl_4

	local quests = scripts_managers_quest_quest_templates.quests

	for k, v in pairs(event) do
		local var_21_3 = quests[v.name]
		local flag = not var_21_3 and var_21_3.events

		if not flag then
			for k_2 = 1, #flag do
				local var_21_5 = flag[k_2]
				local var_21_6 = tbl[var_21_5]

				var_21_6 = var_21_6 or {}
				tbl[var_21_5] = var_21_6
				tbl[var_21_5][#tbl[var_21_5] + 1] = k
			end
		end
	end

	self._quest_event_mapping = tbl
end
