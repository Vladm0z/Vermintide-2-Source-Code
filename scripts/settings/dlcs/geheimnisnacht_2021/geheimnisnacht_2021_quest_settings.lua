-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_quest_settings.lua

local var_0_0 = require("scripts/settings/dlcs/geheimnisnacht_2025/generate_geheimnisnacht_quests")
local var_0_1 = DLCSettings.geheimnisnacht_2021
local var_0_2 = {}

var_0_1.quest_templates = var_0_2

var_0_0(2025)

local var_0_3 = {
	event_geheimnisnacht_2024_disrupt_all = {
		"event_geheimnisnacht_2024_disrupt_bardin",
		"event_geheimnisnacht_2024_disrupt_markus",
		"event_geheimnisnacht_2024_disrupt_kerillian",
		"event_geheimnisnacht_2024_disrupt_victor",
		"event_geheimnisnacht_2024_disrupt_sienna"
	},
	event_geheimnisnacht_2024_complete_all = {
		"event_geheimnisnacht_2024_play_5",
		"event_geheimnisnacht_2024_kill_cultists",
		"event_geheimnisnacht_2024_disrupt_bardin",
		"event_geheimnisnacht_2024_disrupt_markus",
		"event_geheimnisnacht_2024_disrupt_kerillian",
		"event_geheimnisnacht_2024_disrupt_victor",
		"event_geheimnisnacht_2024_disrupt_sienna",
		"event_geheimnisnacht_2024_disrupt_all",
		"event_geheimnisnacht_2024_play_5_hardmode"
	},
	event_geheimnisnacht_2023_disrupt_all = {
		"event_geheimnisnacht_2023_disrupt_bardin",
		"event_geheimnisnacht_2023_disrupt_markus",
		"event_geheimnisnacht_2023_disrupt_kerillian",
		"event_geheimnisnacht_2023_disrupt_victor",
		"event_geheimnisnacht_2023_disrupt_sienna"
	},
	event_geheimnisnacht_2023_complete_all = {
		"event_geheimnisnacht_2023_play_5",
		"event_geheimnisnacht_2023_kill_cultists",
		"event_geheimnisnacht_2023_disrupt_bardin",
		"event_geheimnisnacht_2023_disrupt_markus",
		"event_geheimnisnacht_2023_disrupt_kerillian",
		"event_geheimnisnacht_2023_disrupt_victor",
		"event_geheimnisnacht_2023_disrupt_sienna",
		"event_geheimnisnacht_2023_disrupt_all",
		"event_geheimnisnacht_2023_play_5_hardmode"
	},
	event_geheimnisnacht_2022_disrupt_all = {
		"event_geheimnisnacht_2022_disrupt_bardin",
		"event_geheimnisnacht_2022_disrupt_markus",
		"event_geheimnisnacht_2022_disrupt_kerillian",
		"event_geheimnisnacht_2022_disrupt_victor",
		"event_geheimnisnacht_2022_disrupt_sienna"
	},
	event_geheimnisnacht_2022_complete_all = {
		"event_geheimnisnacht_2022_play_5",
		"event_geheimnisnacht_2022_kill_cultists",
		"event_geheimnisnacht_2022_disrupt_bardin",
		"event_geheimnisnacht_2022_disrupt_markus",
		"event_geheimnisnacht_2022_disrupt_kerillian",
		"event_geheimnisnacht_2022_disrupt_victor",
		"event_geheimnisnacht_2022_disrupt_sienna",
		"event_geheimnisnacht_2022_disrupt_all",
		"event_geheimnisnacht_2022_play_5_hardmode"
	},
	event_geheimnisnacht_2021_disrupt_all = {
		"event_geheimnisnacht_2021_disrupt_bardin",
		"event_geheimnisnacht_2021_disrupt_markus",
		"event_geheimnisnacht_2021_disrupt_kerillian",
		"event_geheimnisnacht_2021_disrupt_victor",
		"event_geheimnisnacht_2021_disrupt_sienna"
	},
	event_geheimnisnacht_2021_complete_all = {
		"event_geheimnisnacht_2021_play_5",
		"event_geheimnisnacht_2021_kill_cultists",
		"event_geheimnisnacht_2021_disrupt_bardin",
		"event_geheimnisnacht_2021_disrupt_markus",
		"event_geheimnisnacht_2021_disrupt_kerillian",
		"event_geheimnisnacht_2021_disrupt_victor",
		"event_geheimnisnacht_2021_disrupt_sienna",
		"event_geheimnisnacht_2021_disrupt_all",
		"event_geheimnisnacht_2021_play_5_hardmode"
	}
}
local var_0_4 = table.mirror_array_inplace({
	"dlc_dwarf_whaling",
	"catacombs",
	"ground_zero",
	"elven_ruins",
	"farmlands"
})

local function var_0_5(arg_1_0)
	local var_1_0 = #arg_1_0

	return function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
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

local function var_0_6(arg_3_0)
	local var_3_0 = #arg_3_0

	return function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		for iter_4_0 = 1, var_3_0 do
			if not arg_4_4[arg_3_0[iter_4_0]] then
				return false
			end
		end

		return true
	end
end

local function var_0_7(arg_5_0)
	local var_5_0 = #arg_5_0

	return function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
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

local var_0_8 = 2

var_0_2.event_geheimnisnacht_2024_play_5 = {
	name = "quest_event_geheimnisnacht_2024_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_play_5_desc",
	completed = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		local var_7_0 = QuestSettings.stat_mappings[arg_7_2][1]

		return arg_7_0:get_persistent_stat(arg_7_1, "quest_statistics", var_7_0) >= 5
	end,
	progress = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		local var_8_0 = QuestSettings.stat_mappings[arg_8_2][1]
		local var_8_1 = arg_8_0:get_persistent_stat(arg_8_1, "quest_statistics", var_8_0)

		return {
			var_8_1,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
		if Managers.state.game_mode:has_activated_mutator("night_mode") then
			local var_9_0 = QuestSettings.stat_mappings[arg_9_5][1]

			arg_9_0:increment_stat(arg_9_1, "quest_statistics", var_9_0)
		end
	end
}
var_0_2.event_geheimnisnacht_2024_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2024_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_markus_desc",
	completed = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		local var_10_0 = QuestSettings.stat_mappings[arg_10_2][1]

		return arg_10_0:get_persistent_stat(arg_10_1, "quest_statistics", var_10_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "ground_zero" then
			return
		end

		local var_11_0 = QuestSettings.stat_mappings[arg_11_5][1]

		arg_11_0:increment_stat(arg_11_1, "quest_statistics", var_11_0)
	end
}
var_0_2.event_geheimnisnacht_2024_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2024_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_bardin_desc",
	completed = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = QuestSettings.stat_mappings[arg_12_2][1]

		return arg_12_0:get_persistent_stat(arg_12_1, "quest_statistics", var_12_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "farmlands" then
			return
		end

		local var_13_0 = QuestSettings.stat_mappings[arg_13_5][1]

		arg_13_0:increment_stat(arg_13_1, "quest_statistics", var_13_0)
	end
}
var_0_2.event_geheimnisnacht_2024_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2024_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_kerillian_desc",
	completed = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		local var_14_0 = QuestSettings.stat_mappings[arg_14_2][1]

		return arg_14_0:get_persistent_stat(arg_14_1, "quest_statistics", var_14_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "elven_ruins" then
			return
		end

		local var_15_0 = QuestSettings.stat_mappings[arg_15_5][1]

		arg_15_0:increment_stat(arg_15_1, "quest_statistics", var_15_0)
	end
}
var_0_2.event_geheimnisnacht_2024_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2024_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_victor_desc",
	completed = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
		local var_16_0 = QuestSettings.stat_mappings[arg_16_2][1]

		return arg_16_0:get_persistent_stat(arg_16_1, "quest_statistics", var_16_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "catacombs" then
			return
		end

		local var_17_0 = QuestSettings.stat_mappings[arg_17_5][1]

		arg_17_0:increment_stat(arg_17_1, "quest_statistics", var_17_0)
	end
}
var_0_2.event_geheimnisnacht_2024_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2024_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_sienna_desc",
	completed = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		local var_18_0 = QuestSettings.stat_mappings[arg_18_2][1]

		return arg_18_0:get_persistent_stat(arg_18_1, "quest_statistics", var_18_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_dwarf_whaling" then
			return
		end

		local var_19_0 = QuestSettings.stat_mappings[arg_19_5][1]

		arg_19_0:increment_stat(arg_19_1, "quest_statistics", var_19_0)
	end
}
var_0_2.event_geheimnisnacht_2024_disrupt_all = {
	name = "quest_event_geheimnisnacht_2024_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_all_desc",
	completed = var_0_6(var_0_3.event_geheimnisnacht_2024_disrupt_all),
	progress = var_0_5(var_0_3.event_geheimnisnacht_2024_disrupt_all),
	requirements = var_0_7(var_0_3.event_geheimnisnacht_2024_disrupt_all)
}
var_0_2.event_geheimnisnacht_2024_complete_all = {
	name = "quest_event_geheimnisnacht_2024_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_complete_all_desc",
	completed = var_0_6(var_0_3.event_geheimnisnacht_2024_complete_all),
	progress = var_0_5(var_0_3.event_geheimnisnacht_2024_complete_all),
	requirements = var_0_7(var_0_3.event_geheimnisnacht_2024_complete_all)
}
var_0_2.event_geheimnisnacht_2024_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2024_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_play_5_hardmode_desc",
	completed = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		for iter_20_0 = 1, #var_0_4 do
			local var_20_0 = QuestSettings.stat_mappings[arg_20_2][iter_20_0]

			if arg_20_0:get_persistent_stat(arg_20_1, "quest_statistics", var_20_0) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		local var_21_0 = 0

		for iter_21_0 = 1, #var_0_4 do
			local var_21_1 = QuestSettings.stat_mappings[arg_21_2][iter_21_0]

			if arg_21_0:get_persistent_stat(arg_21_1, "quest_statistics", var_21_1) > 0 then
				var_21_0 = var_21_0 + 1
			end
		end

		return {
			var_21_0,
			5
		}
	end,
	requirements = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		local var_22_0 = {}

		for iter_22_0 = 1, #var_0_4 do
			local var_22_1 = var_0_4[iter_22_0]
			local var_22_2 = QuestSettings.stat_mappings[arg_22_2][iter_22_0]
			local var_22_3 = arg_22_0:get_persistent_stat(arg_22_1, "quest_statistics", var_22_2) > 0

			var_22_0[iter_22_0] = {
				name = LevelSettings[var_22_1].display_name,
				completed = var_22_3
			}
		end

		return var_22_0
	end,
	events = {
		"register_completed_level"
	},
	on_event = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
		if Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local var_23_0 = var_0_4[arg_23_4[2]]
			local var_23_1 = QuestSettings.stat_mappings[arg_23_5][var_23_0]

			arg_23_0:increment_stat(arg_23_1, "quest_statistics", var_23_1)
		end
	end
}
var_0_2.event_geheimnisnacht_2024_kill_cultists = {
	name = "quest_event_geheimnisnacht_2024_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_kill_cultists_desc",
	completed = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
		local var_24_0 = QuestSettings.stat_mappings[arg_24_2][1]

		return arg_24_0:get_persistent_stat(arg_24_1, "quest_statistics", var_24_0) >= 250
	end,
	progress = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
		local var_25_0 = QuestSettings.stat_mappings[arg_25_2][1]
		local var_25_1 = arg_25_0:get_persistent_stat(arg_25_1, "quest_statistics", var_25_0)

		return {
			var_25_1,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
		local var_26_0 = arg_26_4[var_0_8]

		if not var_26_0 then
			return
		end

		local var_26_1 = ScriptUnit.has_extension(var_26_0, "buff_system")

		if not var_26_1 or not var_26_1:has_buff_type("geheimnisnacht_2021_event_eye_glow") then
			return
		end

		local var_26_2 = QuestSettings.stat_mappings[arg_26_5][1]

		arg_26_0:increment_stat(arg_26_1, "quest_statistics", var_26_2)
	end
}
var_0_2.event_geheimnisnacht_2023_play_5 = {
	name = "quest_event_geheimnisnacht_2023_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_play_5_desc",
	completed = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		local var_27_0 = QuestSettings.stat_mappings[arg_27_2][1]

		return arg_27_0:get_persistent_stat(arg_27_1, "quest_statistics", var_27_0) >= 5
	end,
	progress = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
		local var_28_0 = QuestSettings.stat_mappings[arg_28_2][1]
		local var_28_1 = arg_28_0:get_persistent_stat(arg_28_1, "quest_statistics", var_28_0)

		return {
			var_28_1,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
		if Managers.state.game_mode:has_activated_mutator("night_mode") then
			local var_29_0 = QuestSettings.stat_mappings[arg_29_5][1]

			arg_29_0:increment_stat(arg_29_1, "quest_statistics", var_29_0)
		end
	end
}
var_0_2.event_geheimnisnacht_2023_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2023_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_markus_desc",
	completed = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
		local var_30_0 = QuestSettings.stat_mappings[arg_30_2][1]

		return arg_30_0:get_persistent_stat(arg_30_1, "quest_statistics", var_30_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_bastion" then
			return
		end

		local var_31_0 = QuestSettings.stat_mappings[arg_31_5][1]

		arg_31_0:increment_stat(arg_31_1, "quest_statistics", var_31_0)
	end
}
var_0_2.event_geheimnisnacht_2023_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2023_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_bardin_desc",
	completed = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
		local var_32_0 = QuestSettings.stat_mappings[arg_32_2][1]

		return arg_32_0:get_persistent_stat(arg_32_1, "quest_statistics", var_32_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_dwarf_beacons" then
			return
		end

		local var_33_0 = QuestSettings.stat_mappings[arg_33_5][1]

		arg_33_0:increment_stat(arg_33_1, "quest_statistics", var_33_0)
	end
}
var_0_2.event_geheimnisnacht_2023_kill_cultists = {
	name = "quest_event_geheimnisnacht_2023_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_kill_cultists_desc",
	completed = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
		local var_34_0 = QuestSettings.stat_mappings[arg_34_2][1]

		return arg_34_0:get_persistent_stat(arg_34_1, "quest_statistics", var_34_0) >= 250
	end,
	progress = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
		local var_35_0 = QuestSettings.stat_mappings[arg_35_2][1]
		local var_35_1 = arg_35_0:get_persistent_stat(arg_35_1, "quest_statistics", var_35_0)

		return {
			var_35_1,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
		local var_36_0 = arg_36_4[var_0_8]

		if not var_36_0 then
			return
		end

		local var_36_1 = ScriptUnit.has_extension(var_36_0, "buff_system")

		if not var_36_1 or not var_36_1:has_buff_type("geheimnisnacht_2021_event_eye_glow") then
			return
		end

		local var_36_2 = QuestSettings.stat_mappings[arg_36_5][1]

		arg_36_0:increment_stat(arg_36_1, "quest_statistics", var_36_2)
	end
}
var_0_2.event_geheimnisnacht_2023_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2023_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_kerillian_desc",
	completed = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
		local var_37_0 = QuestSettings.stat_mappings[arg_37_2][1]

		return arg_37_0:get_persistent_stat(arg_37_1, "quest_statistics", var_37_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "nurgle" then
			return
		end

		local var_38_0 = QuestSettings.stat_mappings[arg_38_5][1]

		arg_38_0:increment_stat(arg_38_1, "quest_statistics", var_38_0)
	end
}
var_0_2.event_geheimnisnacht_2023_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2023_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_victor_desc",
	completed = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		local var_39_0 = QuestSettings.stat_mappings[arg_39_2][1]

		return arg_39_0:get_persistent_stat(arg_39_1, "quest_statistics", var_39_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "warcamp" then
			return
		end

		local var_40_0 = QuestSettings.stat_mappings[arg_40_5][1]

		arg_40_0:increment_stat(arg_40_1, "quest_statistics", var_40_0)
	end
}
var_0_2.event_geheimnisnacht_2023_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2023_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_sienna_desc",
	completed = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
		local var_41_0 = QuestSettings.stat_mappings[arg_41_2][1]

		return arg_41_0:get_persistent_stat(arg_41_1, "quest_statistics", var_41_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_wizards_tower" then
			return
		end

		local var_42_0 = QuestSettings.stat_mappings[arg_42_5][1]

		arg_42_0:increment_stat(arg_42_1, "quest_statistics", var_42_0)
	end
}
var_0_2.event_geheimnisnacht_2023_disrupt_all = {
	name = "quest_event_geheimnisnacht_2023_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_all_desc",
	completed = var_0_6(var_0_3.event_geheimnisnacht_2023_disrupt_all),
	progress = var_0_5(var_0_3.event_geheimnisnacht_2023_disrupt_all),
	requirements = var_0_7(var_0_3.event_geheimnisnacht_2023_disrupt_all)
}
var_0_2.event_geheimnisnacht_2023_complete_all = {
	name = "quest_event_geheimnisnacht_2023_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_complete_all_desc",
	completed = var_0_6(var_0_3.event_geheimnisnacht_2023_complete_all),
	progress = var_0_5(var_0_3.event_geheimnisnacht_2023_complete_all),
	requirements = var_0_7(var_0_3.event_geheimnisnacht_2023_complete_all)
}
var_0_2.event_geheimnisnacht_2023_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2023_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_play_5_hardmode_desc",
	completed = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
		for iter_43_0 = 1, #var_0_4 do
			local var_43_0 = QuestSettings.stat_mappings[arg_43_2][iter_43_0]

			if arg_43_0:get_persistent_stat(arg_43_1, "quest_statistics", var_43_0) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
		local var_44_0 = 0

		for iter_44_0 = 1, #var_0_4 do
			local var_44_1 = QuestSettings.stat_mappings[arg_44_2][iter_44_0]

			if arg_44_0:get_persistent_stat(arg_44_1, "quest_statistics", var_44_1) > 0 then
				var_44_0 = var_44_0 + 1
			end
		end

		return {
			var_44_0,
			5
		}
	end,
	requirements = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
		local var_45_0 = {}

		for iter_45_0 = 1, #var_0_4 do
			local var_45_1 = var_0_4[iter_45_0]
			local var_45_2 = QuestSettings.stat_mappings[arg_45_2][iter_45_0]
			local var_45_3 = arg_45_0:get_persistent_stat(arg_45_1, "quest_statistics", var_45_2) > 0

			var_45_0[iter_45_0] = {
				name = LevelSettings[var_45_1].display_name,
				completed = var_45_3
			}
		end

		return var_45_0
	end,
	events = {
		"register_completed_level"
	},
	on_event = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5)
		if Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local var_46_0 = var_0_4[arg_46_4[2]]
			local var_46_1 = QuestSettings.stat_mappings[arg_46_5][var_46_0]

			arg_46_0:increment_stat(arg_46_1, "quest_statistics", var_46_1)
		end
	end
}
var_0_2.event_geheimnisnacht_2022_play_5 = {
	name = "quest_event_geheimnisnacht_2022_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_play_5_desc",
	completed = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
		local var_47_0 = QuestSettings.stat_mappings[arg_47_2][1]

		return arg_47_0:get_persistent_stat(arg_47_1, "quest_statistics", var_47_0) >= 5
	end,
	progress = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
		local var_48_0 = QuestSettings.stat_mappings[arg_48_2][1]
		local var_48_1 = arg_48_0:get_persistent_stat(arg_48_1, "quest_statistics", var_48_0)

		return {
			var_48_1,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
		if Managers.state.game_mode:has_activated_mutator("night_mode") then
			local var_49_0 = QuestSettings.stat_mappings[arg_49_5][1]

			arg_49_0:increment_stat(arg_49_1, "quest_statistics", var_49_0)
		end
	end
}
var_0_2.event_geheimnisnacht_2022_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2022_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_markus_desc",
	completed = function(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
		local var_50_0 = QuestSettings.stat_mappings[arg_50_2][1]

		return arg_50_0:get_persistent_stat(arg_50_1, "quest_statistics", var_50_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "catacombs" then
			return
		end

		local var_51_0 = QuestSettings.stat_mappings[arg_51_5][1]

		arg_51_0:increment_stat(arg_51_1, "quest_statistics", var_51_0)
	end
}
var_0_2.event_geheimnisnacht_2022_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2022_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_bardin_desc",
	completed = function(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
		local var_52_0 = QuestSettings.stat_mappings[arg_52_2][1]

		return arg_52_0:get_persistent_stat(arg_52_1, "quest_statistics", var_52_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "mines" then
			return
		end

		local var_53_0 = QuestSettings.stat_mappings[arg_53_5][1]

		arg_53_0:increment_stat(arg_53_1, "quest_statistics", var_53_0)
	end
}
var_0_2.event_geheimnisnacht_2022_kill_cultists = {
	name = "quest_event_geheimnisnacht_2022_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_kill_cultists_desc",
	completed = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
		local var_54_0 = QuestSettings.stat_mappings[arg_54_2][1]

		return arg_54_0:get_persistent_stat(arg_54_1, "quest_statistics", var_54_0) >= 250
	end,
	progress = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
		local var_55_0 = QuestSettings.stat_mappings[arg_55_2][1]
		local var_55_1 = arg_55_0:get_persistent_stat(arg_55_1, "quest_statistics", var_55_0)

		return {
			var_55_1,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5)
		local var_56_0 = arg_56_4[var_0_8]

		if not var_56_0 then
			return
		end

		local var_56_1 = ScriptUnit.has_extension(var_56_0, "buff_system")

		if not var_56_1 or not var_56_1:has_buff_type("geheimnisnacht_2021_event_eye_glow") then
			return
		end

		local var_56_2 = QuestSettings.stat_mappings[arg_56_5][1]

		arg_56_0:increment_stat(arg_56_1, "quest_statistics", var_56_2)
	end
}
var_0_2.event_geheimnisnacht_2022_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2022_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_kerillian_desc",
	completed = function(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
		local var_57_0 = QuestSettings.stat_mappings[arg_57_2][1]

		return arg_57_0:get_persistent_stat(arg_57_1, "quest_statistics", var_57_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "elven_ruins" then
			return
		end

		local var_58_0 = QuestSettings.stat_mappings[arg_58_5][1]

		arg_58_0:increment_stat(arg_58_1, "quest_statistics", var_58_0)
	end
}
var_0_2.event_geheimnisnacht_2022_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2022_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_victor_desc",
	completed = function(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
		local var_59_0 = QuestSettings.stat_mappings[arg_59_2][1]

		return arg_59_0:get_persistent_stat(arg_59_1, "quest_statistics", var_59_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "ground_zero" then
			return
		end

		local var_60_0 = QuestSettings.stat_mappings[arg_60_5][1]

		arg_60_0:increment_stat(arg_60_1, "quest_statistics", var_60_0)
	end
}
var_0_2.event_geheimnisnacht_2022_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2022_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_sienna_desc",
	completed = function(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
		local var_61_0 = QuestSettings.stat_mappings[arg_61_2][1]

		return arg_61_0:get_persistent_stat(arg_61_1, "quest_statistics", var_61_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "farmlands" then
			return
		end

		local var_62_0 = QuestSettings.stat_mappings[arg_62_5][1]

		arg_62_0:increment_stat(arg_62_1, "quest_statistics", var_62_0)
	end
}
var_0_2.event_geheimnisnacht_2022_disrupt_all = {
	name = "quest_event_geheimnisnacht_2022_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_all_desc",
	completed = var_0_6(var_0_3.event_geheimnisnacht_2022_disrupt_all),
	progress = var_0_5(var_0_3.event_geheimnisnacht_2022_disrupt_all),
	requirements = var_0_7(var_0_3.event_geheimnisnacht_2022_disrupt_all)
}
var_0_2.event_geheimnisnacht_2022_complete_all = {
	name = "quest_event_geheimnisnacht_2022_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_complete_all_desc",
	completed = var_0_6(var_0_3.event_geheimnisnacht_2022_complete_all),
	progress = var_0_5(var_0_3.event_geheimnisnacht_2022_complete_all),
	requirements = var_0_7(var_0_3.event_geheimnisnacht_2022_complete_all)
}
var_0_2.event_geheimnisnacht_2022_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2022_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_play_5_hardmode_desc",
	completed = function(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		for iter_63_0 = 1, #var_0_4 do
			local var_63_0 = QuestSettings.stat_mappings[arg_63_2][iter_63_0]

			if arg_63_0:get_persistent_stat(arg_63_1, "quest_statistics", var_63_0) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
		local var_64_0 = 0

		for iter_64_0 = 1, #var_0_4 do
			local var_64_1 = QuestSettings.stat_mappings[arg_64_2][iter_64_0]

			if arg_64_0:get_persistent_stat(arg_64_1, "quest_statistics", var_64_1) > 0 then
				var_64_0 = var_64_0 + 1
			end
		end

		return {
			var_64_0,
			5
		}
	end,
	requirements = function(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
		local var_65_0 = {}

		for iter_65_0 = 1, #var_0_4 do
			local var_65_1 = var_0_4[iter_65_0]
			local var_65_2 = QuestSettings.stat_mappings[arg_65_2][iter_65_0]
			local var_65_3 = arg_65_0:get_persistent_stat(arg_65_1, "quest_statistics", var_65_2) > 0

			var_65_0[iter_65_0] = {
				name = LevelSettings[var_65_1].display_name,
				completed = var_65_3
			}
		end

		return var_65_0
	end,
	events = {
		"register_completed_level"
	},
	on_event = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5)
		if Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local var_66_0 = var_0_4[arg_66_4[2]]
			local var_66_1 = QuestSettings.stat_mappings[arg_66_5][var_66_0]

			arg_66_0:increment_stat(arg_66_1, "quest_statistics", var_66_1)
		end
	end
}
var_0_2.event_geheimnisnacht_2021_play_5 = {
	name = "quest_event_geheimnisnacht_2021_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_play_5_desc",
	completed = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
		local var_67_0 = QuestSettings.stat_mappings[arg_67_2][1]

		return arg_67_0:get_persistent_stat(arg_67_1, "quest_statistics", var_67_0) >= 5
	end,
	progress = function(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
		local var_68_0 = QuestSettings.stat_mappings[arg_68_2][1]
		local var_68_1 = arg_68_0:get_persistent_stat(arg_68_1, "quest_statistics", var_68_0)

		return {
			var_68_1,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5)
		if Managers.state.game_mode:has_activated_mutator("night_mode") then
			local var_69_0 = QuestSettings.stat_mappings[arg_69_5][1]

			arg_69_0:increment_stat(arg_69_1, "quest_statistics", var_69_0)
		end
	end
}
var_0_2.event_geheimnisnacht_2021_kill_cultists = {
	name = "quest_event_geheimnisnacht_2021_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_kill_cultists_desc",
	completed = function(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
		local var_70_0 = QuestSettings.stat_mappings[arg_70_2][1]

		return arg_70_0:get_persistent_stat(arg_70_1, "quest_statistics", var_70_0) >= 250
	end,
	progress = function(arg_71_0, arg_71_1, arg_71_2, arg_71_3)
		local var_71_0 = QuestSettings.stat_mappings[arg_71_2][1]
		local var_71_1 = arg_71_0:get_persistent_stat(arg_71_1, "quest_statistics", var_71_0)

		return {
			var_71_1,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5)
		local var_72_0 = arg_72_4[var_0_8]

		if not var_72_0 then
			return
		end

		local var_72_1 = ScriptUnit.has_extension(var_72_0, "buff_system")

		if not var_72_1 or not var_72_1:has_buff_type("geheimnisnacht_2021_event_eye_glow") then
			return
		end

		local var_72_2 = QuestSettings.stat_mappings[arg_72_5][1]

		arg_72_0:increment_stat(arg_72_1, "quest_statistics", var_72_2)
	end
}
var_0_2.event_geheimnisnacht_2021_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2021_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_bardin_desc",
	completed = function(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
		local var_73_0 = QuestSettings.stat_mappings[arg_73_2][1]

		return arg_73_0:get_persistent_stat(arg_73_1, "quest_statistics", var_73_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4, arg_74_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "bell" then
			return
		end

		local var_74_0 = QuestSettings.stat_mappings[arg_74_5][1]

		arg_74_0:increment_stat(arg_74_1, "quest_statistics", var_74_0)
	end
}
var_0_2.event_geheimnisnacht_2021_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2021_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_markus_desc",
	completed = function(arg_75_0, arg_75_1, arg_75_2, arg_75_3)
		local var_75_0 = QuestSettings.stat_mappings[arg_75_2][1]

		return arg_75_0:get_persistent_stat(arg_75_1, "quest_statistics", var_75_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4, arg_76_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "military" then
			return
		end

		local var_76_0 = QuestSettings.stat_mappings[arg_76_5][1]

		arg_76_0:increment_stat(arg_76_1, "quest_statistics", var_76_0)
	end
}
var_0_2.event_geheimnisnacht_2021_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2021_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_kerillian_desc",
	completed = function(arg_77_0, arg_77_1, arg_77_2, arg_77_3)
		local var_77_0 = QuestSettings.stat_mappings[arg_77_2][1]

		return arg_77_0:get_persistent_stat(arg_77_1, "quest_statistics", var_77_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_portals" then
			return
		end

		local var_78_0 = QuestSettings.stat_mappings[arg_78_5][1]

		arg_78_0:increment_stat(arg_78_1, "quest_statistics", var_78_0)
	end
}
var_0_2.event_geheimnisnacht_2021_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2021_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_victor_desc",
	completed = function(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
		local var_79_0 = QuestSettings.stat_mappings[arg_79_2][1]

		return arg_79_0:get_persistent_stat(arg_79_1, "quest_statistics", var_79_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4, arg_80_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_castle" then
			return
		end

		local var_80_0 = QuestSettings.stat_mappings[arg_80_5][1]

		arg_80_0:increment_stat(arg_80_1, "quest_statistics", var_80_0)
	end
}
var_0_2.event_geheimnisnacht_2021_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2021_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_sienna_desc",
	completed = function(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
		local var_81_0 = QuestSettings.stat_mappings[arg_81_2][1]

		return arg_81_0:get_persistent_stat(arg_81_1, "quest_statistics", var_81_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function(arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4, arg_82_5)
		if Managers.level_transition_handler:get_current_level_keys() ~= "ussingen" then
			return
		end

		local var_82_0 = QuestSettings.stat_mappings[arg_82_5][1]

		arg_82_0:increment_stat(arg_82_1, "quest_statistics", var_82_0)
	end
}
var_0_2.event_geheimnisnacht_2021_disrupt_all = {
	name = "quest_event_geheimnisnacht_2021_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_all_desc",
	completed = var_0_6(var_0_3.event_geheimnisnacht_2021_disrupt_all),
	progress = var_0_5(var_0_3.event_geheimnisnacht_2021_disrupt_all),
	requirements = var_0_7(var_0_3.event_geheimnisnacht_2021_disrupt_all)
}
var_0_2.event_geheimnisnacht_2021_complete_all = {
	name = "quest_event_geheimnisnacht_2021_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_complete_all_desc",
	completed = var_0_6(var_0_3.event_geheimnisnacht_2021_complete_all),
	progress = var_0_5(var_0_3.event_geheimnisnacht_2021_complete_all),
	requirements = var_0_7(var_0_3.event_geheimnisnacht_2021_complete_all)
}
var_0_2.event_geheimnisnacht_2021_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2021_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_play_5_hardmode_desc",
	completed = function(arg_83_0, arg_83_1, arg_83_2, arg_83_3)
		for iter_83_0 = 1, #var_0_4 do
			local var_83_0 = QuestSettings.stat_mappings[arg_83_2][iter_83_0]

			if arg_83_0:get_persistent_stat(arg_83_1, "quest_statistics", var_83_0) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function(arg_84_0, arg_84_1, arg_84_2, arg_84_3)
		local var_84_0 = 0

		for iter_84_0 = 1, #var_0_4 do
			local var_84_1 = QuestSettings.stat_mappings[arg_84_2][iter_84_0]

			if arg_84_0:get_persistent_stat(arg_84_1, "quest_statistics", var_84_1) > 0 then
				var_84_0 = var_84_0 + 1
			end
		end

		return {
			var_84_0,
			5
		}
	end,
	requirements = function(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
		local var_85_0 = {}

		for iter_85_0 = 1, #var_0_4 do
			local var_85_1 = var_0_4[iter_85_0]
			local var_85_2 = QuestSettings.stat_mappings[arg_85_2][iter_85_0]
			local var_85_3 = arg_85_0:get_persistent_stat(arg_85_1, "quest_statistics", var_85_2) > 0

			var_85_0[iter_85_0] = {
				name = LevelSettings[var_85_1].display_name,
				completed = var_85_3
			}
		end

		return var_85_0
	end,
	events = {
		"register_completed_level"
	},
	on_event = function(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4, arg_86_5)
		if Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local var_86_0 = var_0_4[arg_86_4[2]]
			local var_86_1 = QuestSettings.stat_mappings[arg_86_5][var_86_0]

			arg_86_0:increment_stat(arg_86_1, "quest_statistics", var_86_1)
		end
	end
}
