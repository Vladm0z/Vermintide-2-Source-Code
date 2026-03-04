-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2025/generate_geheimnisnacht_quests.lua

local var_0_0 = require("scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_utils")
local var_0_1 = {}

local function var_0_2(arg_1_0)
	local var_1_0 = #arg_1_0

	return function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		local var_2_0 = 0

		for iter_2_0 = 1, var_1_0 do
			if arg_2_4[arg_1_0[iter_2_0]] then
				var_2_0 = var_2_0 + 1
			end
		end

		return {
			var_2_0,
			var_1_0
		}
	end
end

local function var_0_3(arg_3_0)
	local var_3_0 = #arg_3_0

	return function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		for iter_4_0 = 1, var_3_0 do
			if not arg_4_4[arg_3_0[iter_4_0]] then
				return false
			end
		end

		return true
	end
end

local function var_0_4(arg_5_0)
	local var_5_0 = #arg_5_0

	return function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		local var_6_0 = {}

		for iter_6_0 = 1, var_5_0 do
			local var_6_1 = arg_5_0[iter_6_0]
			local var_6_2 = arg_6_4[var_6_1]
			local var_6_3 = arg_6_3[var_6_1].name

			var_6_0[iter_6_0] = {
				name = var_6_3,
				completed = var_6_2
			}
		end

		return var_6_0
	end
end

return function (arg_7_0)
	local var_7_0 = table.mirror_array(var_0_0.maps_by_year(arg_7_0))
	local var_7_1 = {
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_1",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_2",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_3",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_4",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_5"
	}
	local var_7_2 = {
		"event_geheimnisnacht_" .. arg_7_0 .. "_participation",
		"event_geheimnisnacht_" .. arg_7_0 .. "_kill_cultists",
		"event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_all",
		"event_geheimnisnacht_" .. arg_7_0 .. "_skull"
	}
	local var_7_3 = 250
	local var_7_4 = 5
	local var_7_5 = 5
	local var_7_6 = 2

	var_0_1["event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_all"] = {
		name = "quest_event_geheimnisnacht_disrupt_all",
		custom_order = 4,
		icon = "quest_book_geheimnisnacht",
		desc = "quest_event_geheimnisnacht_disrupt_all_desc",
		completed = var_0_3(var_7_1),
		progress = var_0_2(var_7_1),
		requirements = var_0_4(var_7_1)
	}
	var_0_1["event_geheimnisnacht_" .. arg_7_0 .. "_complete_all"] = {
		name = "quest_event_geheimnisnacht_complete_all",
		custom_order = 0,
		icon = "quest_book_geheimnisnacht",
		desc = "quest_event_geheimnisnacht_complete_all_desc",
		completed = var_0_3(var_7_2),
		progress = var_0_2(var_7_2),
		requirements = var_0_4(var_7_2)
	}

	for iter_7_0 = 1, #var_7_0 do
		local var_7_7 = var_7_0[iter_7_0]

		var_0_1["event_geheimnisnacht_" .. arg_7_0 .. "_disrupt_" .. iter_7_0] = {
			icon = "quest_book_geheimnisnacht",
			name = function ()
				return string.format(Localize(LevelSettings[var_7_7].display_name))
			end,
			desc = function ()
				return string.format(Localize("quest_event_geheimnisnacht_disrupt_ritual_desc"), Localize(LevelSettings[var_7_7].display_name))
			end,
			custom_order = 4 + iter_7_0,
			completed = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				local var_10_0 = QuestSettings.stat_mappings[arg_10_2][1]

				return arg_10_0:get_persistent_stat(arg_10_1, "quest_statistics", var_10_0) >= 1
			end,
			events = {
				"altar_destroyed"
			},
			on_event = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
				if Managers.level_transition_handler:get_current_level_keys() ~= var_7_0[iter_7_0] then
					return
				end

				local var_11_0 = QuestSettings.stat_mappings[arg_11_5][1]

				arg_11_0:increment_stat(arg_11_1, "quest_statistics", var_11_0)
			end
		}
	end

	var_0_1["event_geheimnisnacht_" .. arg_7_0 .. "_skull"] = {
		name = "quest_event_geheimnisnacht_skull",
		custom_order = 3,
		icon = "quest_book_geheimnisnacht",
		desc = function ()
			return string.format(Localize("quest_event_geheimnisnacht_skull_desc"), var_7_5)
		end,
		completed = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			for iter_13_0 = 1, #var_7_0 do
				local var_13_0 = QuestSettings.stat_mappings[arg_13_2][iter_13_0]

				if arg_13_0:get_persistent_stat(arg_13_1, "quest_statistics", var_13_0) <= 0 then
					return false
				end
			end

			return true
		end,
		progress = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			local var_14_0 = 0

			for iter_14_0 = 1, #var_7_0 do
				local var_14_1 = QuestSettings.stat_mappings[arg_14_2][iter_14_0]

				if arg_14_0:get_persistent_stat(arg_14_1, "quest_statistics", var_14_1) > 0 then
					var_14_0 = var_14_0 + 1
				end
			end

			return {
				var_14_0,
				5
			}
		end,
		requirements = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
			local var_15_0 = {}

			for iter_15_0 = 1, #var_7_0 do
				local var_15_1 = var_7_0[iter_15_0]
				local var_15_2 = QuestSettings.stat_mappings[arg_15_2][iter_15_0]
				local var_15_3 = arg_15_0:get_persistent_stat(arg_15_1, "quest_statistics", var_15_2) > 0

				var_15_0[iter_15_0] = {
					name = LevelSettings[var_15_1].display_name,
					completed = var_15_3
				}
			end

			return var_15_0
		end,
		events = {
			"register_completed_level"
		},
		on_event = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
			if Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
				local var_16_0 = arg_16_4[2]
				local var_16_1 = var_7_0[var_16_0]

				if not var_16_1 then
					Application.warning("Failed to increment stat for completing level %s due to not being featured in the map list: (%s)", var_16_0, table.concat(var_7_0, ", "))

					return
				end

				local var_16_2 = QuestSettings.stat_mappings[arg_16_5][var_16_1]

				arg_16_0:increment_stat(arg_16_1, "quest_statistics", var_16_2)
			end
		end
	}
	var_0_1["event_geheimnisnacht_" .. arg_7_0 .. "_kill_cultists"] = {
		name = "quest_event_geheimnisnacht_kill_cultists",
		custom_order = 2,
		icon = "quest_book_geheimnisnacht",
		desc = function ()
			return string.format(Localize("quest_event_geheimnisnacht_kill_cultists_desc"), var_7_3)
		end,
		completed = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			local var_18_0 = QuestSettings.stat_mappings[arg_18_2][1]

			return arg_18_0:get_persistent_stat(arg_18_1, "quest_statistics", var_18_0) >= 250
		end,
		progress = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			local var_19_0 = QuestSettings.stat_mappings[arg_19_2][1]
			local var_19_1 = arg_19_0:get_persistent_stat(arg_19_1, "quest_statistics", var_19_0)

			return {
				var_19_1,
				250
			}
		end,
		events = {
			"register_kill"
		},
		on_event = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
			local var_20_0 = arg_20_4[var_7_6]

			if not var_20_0 then
				return
			end

			local var_20_1 = ScriptUnit.has_extension(var_20_0, "buff_system")

			if not var_20_1 or not var_20_1:has_buff_type("geheimnisnacht_2021_event_eye_glow") then
				return
			end

			local var_20_2 = QuestSettings.stat_mappings[arg_20_5][1]

			arg_20_0:increment_stat(arg_20_1, "quest_statistics", var_20_2)
		end
	}
	var_0_1["event_geheimnisnacht_" .. arg_7_0 .. "_participation"] = {
		name = "quest_event_geheimnisnacht_participation",
		custom_order = 1,
		icon = "quest_book_geheimnisnacht",
		desc = function ()
			return string.format(Localize("quest_event_geheimnisnacht_participation_desc"), var_7_4)
		end,
		completed = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			local var_22_0 = QuestSettings.stat_mappings[arg_22_2][1]

			return arg_22_0:get_persistent_stat(arg_22_1, "quest_statistics", var_22_0) >= 5
		end,
		progress = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			local var_23_0 = QuestSettings.stat_mappings[arg_23_2][1]
			local var_23_1 = arg_23_0:get_persistent_stat(arg_23_1, "quest_statistics", var_23_0)

			return {
				var_23_1,
				5
			}
		end,
		events = {
			"register_completed_level"
		},
		on_event = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
			if Managers.state.game_mode:has_activated_mutator("night_mode") then
				local var_24_0 = QuestSettings.stat_mappings[arg_24_5][1]

				arg_24_0:increment_stat(arg_24_1, "quest_statistics", var_24_0)
			end
		end
	}

	local var_7_8 = DLCSettings.geheimnisnacht_2021

	table.merge(var_7_8.quest_templates, var_0_1)
end
