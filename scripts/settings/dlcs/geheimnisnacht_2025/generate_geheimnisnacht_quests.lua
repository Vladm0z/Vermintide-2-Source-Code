-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2025/generate_geheimnisnacht_quests.lua

local scripts_settings_dlcs_geheimnisnacht_2025_geheimnisnacht_utils = require("scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_utils")
local tbl = {}

local function fn(arg_1_0)
	-- function 1
	local count = #arg_1_0

	return function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		local num = 0

		for i = 1, count do
			if not arg_2_4[arg_1_0[i]] then
				num = num + 1
			end
		end

		return {
			num,
			count
		}
	end
end

local function fn_2(arg_3_0)
	-- function 3
	local count = #arg_3_0

	return function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		for i = 1, count do
			if not arg_4_4[arg_3_0[i]] then
				return false
			end
		end

		return true
	end
end

local function fn_3(arg_5_0)
	-- function 5
	local count = #arg_5_0

	return function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		local tbl = {}

		for i = 1, count do
			local var_6_1 = arg_5_0[i]
			local var_6_2 = arg_6_4[var_6_1]
			local name = arg_6_3[var_6_1].name

			tbl[i] = {
				name = name,
				completed = var_6_2
			}
		end

		return tbl
	end
end

return function (arg_7_0)
	-- function 7
	local mirror_array = table.mirror_array(scripts_settings_dlcs_geheimnisnacht_2025_geheimnisnacht_utils.maps_by_year(arg_7_0, true))
	local tbl_2 = {
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_1",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_2",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_3",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_4",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_5"
	}
	local tbl_3 = {
		"event_geheimnisnacht_" .. arg_7_0 .. "_participation",
		"event_geheimnisnacht_" .. arg_7_0 .. "_kill_cultists",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_all",
		"event_geheimnisnacht_" .. arg_7_0 .. "_skull"
	}
	local num = 250
	local num_2 = 5
	local num_3 = 5
	local num_4 = 2

	tbl["event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_all"] = {
		name = "quest_event_geheimnisnacht_disrupt_all",
		custom_order = 4,
		icon = "quest_book_geheimnisnacht",
		desc = "quest_event_geheimnisnacht_disrupt_all_desc",
		completed = fn_2(tbl_2),
		progress = fn(tbl_2),
		requirements = fn_3(tbl_2)
	}
	tbl["event_geheimnisnacht_" .. arg_7_0 .. "_complete_all"] = {
		name = "quest_event_geheimnisnacht_complete_all",
		custom_order = 0,
		icon = "quest_book_geheimnisnacht",
		desc = "quest_event_geheimnisnacht_complete_all_desc",
		completed = fn_2(tbl_3),
		progress = fn(tbl_3),
		requirements = fn_3(tbl_3)
	}

	for i = 1, #mirror_array do
		local var_7_7 = mirror_array[i]

		tbl["event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_" .. i] = {
			icon = "quest_book_geheimnisnacht",
			name = function ()
				-- function 8
				return string.format(Localize(LevelSettings[var_7_7].display_name))
			end,
			desc = function ()
				-- function 9
				return string.format(Localize("quest_event_geheimnisnacht_disrupt_ritual_desc"), Localize(LevelSettings[var_7_7].display_name))
			end,
			custom_order = 4 + i,
			completed = function (self, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				local var_10_0 = QuestSettings.stat_mappings[arg_10_2][1]

				return self:get_persistent_stat(arg_10_1, "quest_statistics", var_10_0) >= 1
			end,
			events = {
				"altar_destroyed"
			},
			on_event = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
				-- function 11
				if Managers.level_transition_handler:get_current_level_keys() ~= mirror_array[i] then
					return
				end

				local var_11_0 = QuestSettings.stat_mappings[arg_11_5][1]

				self:increment_stat(arg_11_1, "quest_statistics", var_11_0)
			end
		}
	end

	tbl["event_geheimnisnacht_" .. arg_7_0 .. "_skull"] = {
		name = "quest_event_geheimnisnacht_skull",
		custom_order = 3,
		icon = "quest_book_geheimnisnacht",
		desc = function ()
			-- function 12
			return string.format(Localize("quest_event_geheimnisnacht_skull_desc"), num_3)
		end,
		completed = function (self, arg_13_1, arg_13_2, arg_13_3)
			-- function 13
			for i = 1, #mirror_array do
				local var_13_0 = QuestSettings.stat_mappings[arg_13_2][i]

				if self:get_persistent_stat(arg_13_1, "quest_statistics", var_13_0) <= 0 then
					return false
				end
			end

			return true
		end,
		progress = function (self, arg_14_1, arg_14_2, arg_14_3)
			-- function 14
			local num = 0

			for i = 1, #mirror_array do
				local var_14_1 = QuestSettings.stat_mappings[arg_14_2][i]

				if self:get_persistent_stat(arg_14_1, "quest_statistics", var_14_1) > 0 then
					num = num + 1
				end
			end

			return {
				num,
				5
			}
		end,
		requirements = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
			-- function 15
			local tbl = {}

			for i = 1, #mirror_array do
				local var_15_1 = mirror_array[i]
				local var_15_2 = QuestSettings.stat_mappings[arg_15_2][i]
				local flag = self:get_persistent_stat(arg_15_1, "quest_statistics", var_15_2) > 0

				tbl[i] = {
					name = LevelSettings[var_15_1].display_name,
					completed = flag
				}
			end

			return tbl
		end,
		events = {
			"register_completed_level"
		},
		on_event = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
			-- function 16
			if not Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
				local var_16_0 = arg_16_4[2]
				local var_16_1 = mirror_array[var_16_0]

				if not var_16_1 then
					Application.warning("Failed to increment stat for completing level %s due to not being featured in the map list: (%s)", var_16_0, table.concat(mirror_array, ", "))

					return
				end

				local var_16_2 = QuestSettings.stat_mappings[arg_16_5][var_16_1]

				self:increment_stat(arg_16_1, "quest_statistics", var_16_2)
			end
		end
	}
	tbl["event_geheimnisnacht_" .. arg_7_0 .. "_kill_cultists"] = {
		name = "quest_event_geheimnisnacht_kill_cultists",
		custom_order = 2,
		icon = "quest_book_geheimnisnacht",
		desc = function ()
			-- function 17
			return string.format(Localize("quest_event_geheimnisnacht_kill_cultists_desc"), num)
		end,
		completed = function (self, arg_18_1, arg_18_2, arg_18_3)
			-- function 18
			local var_18_0 = QuestSettings.stat_mappings[arg_18_2][1]

			return self:get_persistent_stat(arg_18_1, "quest_statistics", var_18_0) >= 250
		end,
		progress = function (self, arg_19_1, arg_19_2, arg_19_3)
			-- function 19
			local var_19_0 = QuestSettings.stat_mappings[arg_19_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_19_1, "quest_statistics", var_19_0)

			return {
				get_persistent_stat,
				250
			}
		end,
		events = {
			"register_kill"
		},
		on_event = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
			-- function 20
			local var_20_0 = arg_20_4[num_4]

			if not var_20_0 then
				return
			end

			local has_extension = ScriptUnit.has_extension(var_20_0, "buff_system")

			if not (not has_extension and has_extension:has_buff_type("geheimnisnacht_2021_event_eye_glow")) then
				return
			end

			local var_20_2 = QuestSettings.stat_mappings[arg_20_5][1]

			self:increment_stat(arg_20_1, "quest_statistics", var_20_2)
		end
	}
	tbl["event_geheimnisnacht_" .. arg_7_0 .. "_participation"] = {
		name = "quest_event_geheimnisnacht_participation",
		custom_order = 1,
		icon = "quest_book_geheimnisnacht",
		desc = function ()
			-- function 21
			return string.format(Localize("quest_event_geheimnisnacht_participation_desc"), num_2)
		end,
		completed = function (self, arg_22_1, arg_22_2, arg_22_3)
			-- function 22
			local var_22_0 = QuestSettings.stat_mappings[arg_22_2][1]

			return self:get_persistent_stat(arg_22_1, "quest_statistics", var_22_0) >= 5
		end,
		progress = function (self, arg_23_1, arg_23_2, arg_23_3)
			-- function 23
			local var_23_0 = QuestSettings.stat_mappings[arg_23_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_23_1, "quest_statistics", var_23_0)

			return {
				get_persistent_stat,
				5
			}
		end,
		events = {
			"register_completed_level"
		},
		on_event = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
			-- function 24
			if not Managers.state.game_mode:has_activated_mutator("night_mode") then
				local var_24_0 = QuestSettings.stat_mappings[arg_24_5][1]

				self:increment_stat(arg_24_1, "quest_statistics", var_24_0)
			end
		end
	}

	local geheimnisnacht_2021 = DLCSettings.geheimnisnacht_2021

	table.merge(geheimnisnacht_2021.quest_templates, tbl)
end
