-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_quest_settings.lua

local scripts_settings_dlcs_geheimnisnacht_2025_generate_geheimnisnacht_quests = require("scripts/settings/dlcs/geheimnisnacht_2025/generate_geheimnisnacht_quests")
local geheimnisnacht_2021 = DLCSettings.geheimnisnacht_2021
local tbl = {}

geheimnisnacht_2021.quest_templates = tbl

scripts_settings_dlcs_geheimnisnacht_2025_generate_geheimnisnacht_quests(2025)
scripts_settings_dlcs_geheimnisnacht_2025_generate_geheimnisnacht_quests(2026)

local tbl_2 = {
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
local mirror_array_inplace = table.mirror_array_inplace({
	"dlc_dwarf_whaling",
	"catacombs",
	"ground_zero",
	"elven_ruins",
	"farmlands"
})

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

local num = 2

tbl.event_geheimnisnacht_2024_play_5 = {
	name = "quest_event_geheimnisnacht_2024_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_play_5_desc",
	completed = function (self, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		local var_7_0 = QuestSettings.stat_mappings[arg_7_2][1]

		return self:get_persistent_stat(arg_7_1, "quest_statistics", var_7_0) >= 5
	end,
	progress = function (self, arg_8_1, arg_8_2, arg_8_3)
		-- function 8
		local var_8_0 = QuestSettings.stat_mappings[arg_8_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_8_1, "quest_statistics", var_8_0)

		return {
			get_persistent_stat,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
		-- function 9
		if not Managers.state.game_mode:has_activated_mutator("night_mode") then
			local var_9_0 = QuestSettings.stat_mappings[arg_9_5][1]

			self:increment_stat(arg_9_1, "quest_statistics", var_9_0)
		end
	end
}
tbl.event_geheimnisnacht_2024_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2024_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_markus_desc",
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
		if Managers.level_transition_handler:get_current_level_keys() ~= "ground_zero" then
			return
		end

		local var_11_0 = QuestSettings.stat_mappings[arg_11_5][1]

		self:increment_stat(arg_11_1, "quest_statistics", var_11_0)
	end
}
tbl.event_geheimnisnacht_2024_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2024_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_bardin_desc",
	completed = function (self, arg_12_1, arg_12_2, arg_12_3)
		-- function 12
		local var_12_0 = QuestSettings.stat_mappings[arg_12_2][1]

		return self:get_persistent_stat(arg_12_1, "quest_statistics", var_12_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
		-- function 13
		if Managers.level_transition_handler:get_current_level_keys() ~= "farmlands" then
			return
		end

		local var_13_0 = QuestSettings.stat_mappings[arg_13_5][1]

		self:increment_stat(arg_13_1, "quest_statistics", var_13_0)
	end
}
tbl.event_geheimnisnacht_2024_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2024_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_kerillian_desc",
	completed = function (self, arg_14_1, arg_14_2, arg_14_3)
		-- function 14
		local var_14_0 = QuestSettings.stat_mappings[arg_14_2][1]

		return self:get_persistent_stat(arg_14_1, "quest_statistics", var_14_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
		-- function 15
		if Managers.level_transition_handler:get_current_level_keys() ~= "elven_ruins" then
			return
		end

		local var_15_0 = QuestSettings.stat_mappings[arg_15_5][1]

		self:increment_stat(arg_15_1, "quest_statistics", var_15_0)
	end
}
tbl.event_geheimnisnacht_2024_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2024_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_victor_desc",
	completed = function (self, arg_16_1, arg_16_2, arg_16_3)
		-- function 16
		local var_16_0 = QuestSettings.stat_mappings[arg_16_2][1]

		return self:get_persistent_stat(arg_16_1, "quest_statistics", var_16_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
		-- function 17
		if Managers.level_transition_handler:get_current_level_keys() ~= "catacombs" then
			return
		end

		local var_17_0 = QuestSettings.stat_mappings[arg_17_5][1]

		self:increment_stat(arg_17_1, "quest_statistics", var_17_0)
	end
}
tbl.event_geheimnisnacht_2024_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2024_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_sienna_desc",
	completed = function (self, arg_18_1, arg_18_2, arg_18_3)
		-- function 18
		local var_18_0 = QuestSettings.stat_mappings[arg_18_2][1]

		return self:get_persistent_stat(arg_18_1, "quest_statistics", var_18_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
		-- function 19
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_dwarf_whaling" then
			return
		end

		local var_19_0 = QuestSettings.stat_mappings[arg_19_5][1]

		self:increment_stat(arg_19_1, "quest_statistics", var_19_0)
	end
}
tbl.event_geheimnisnacht_2024_disrupt_all = {
	name = "quest_event_geheimnisnacht_2024_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_all_desc",
	completed = fn_2(tbl_2.event_geheimnisnacht_2024_disrupt_all),
	progress = fn(tbl_2.event_geheimnisnacht_2024_disrupt_all),
	requirements = fn_3(tbl_2.event_geheimnisnacht_2024_disrupt_all)
}
tbl.event_geheimnisnacht_2024_complete_all = {
	name = "quest_event_geheimnisnacht_2024_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_complete_all_desc",
	completed = fn_2(tbl_2.event_geheimnisnacht_2024_complete_all),
	progress = fn(tbl_2.event_geheimnisnacht_2024_complete_all),
	requirements = fn_3(tbl_2.event_geheimnisnacht_2024_complete_all)
}
tbl.event_geheimnisnacht_2024_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2024_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_play_5_hardmode_desc",
	completed = function (self, arg_20_1, arg_20_2, arg_20_3)
		-- function 20
		for i = 1, #mirror_array_inplace do
			local var_20_0 = QuestSettings.stat_mappings[arg_20_2][i]

			if self:get_persistent_stat(arg_20_1, "quest_statistics", var_20_0) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function (self, arg_21_1, arg_21_2, arg_21_3)
		-- function 21
		local num = 0

		for i = 1, #mirror_array_inplace do
			local var_21_1 = QuestSettings.stat_mappings[arg_21_2][i]

			if self:get_persistent_stat(arg_21_1, "quest_statistics", var_21_1) > 0 then
				num = num + 1
			end
		end

		return {
			num,
			5
		}
	end,
	requirements = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		-- function 22
		local tbl = {}

		for i = 1, #mirror_array_inplace do
			local var_22_1 = mirror_array_inplace[i]
			local var_22_2 = QuestSettings.stat_mappings[arg_22_2][i]
			local flag = self:get_persistent_stat(arg_22_1, "quest_statistics", var_22_2) > 0

			tbl[i] = {
				name = LevelSettings[var_22_1].display_name,
				completed = flag
			}
		end

		return tbl
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
		-- function 23
		if not Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local var_23_0 = mirror_array_inplace[arg_23_4[2]]
			local var_23_1 = QuestSettings.stat_mappings[arg_23_5][var_23_0]

			self:increment_stat(arg_23_1, "quest_statistics", var_23_1)
		end
	end
}
tbl.event_geheimnisnacht_2024_kill_cultists = {
	name = "quest_event_geheimnisnacht_2024_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_kill_cultists_desc",
	completed = function (self, arg_24_1, arg_24_2, arg_24_3)
		-- function 24
		local var_24_0 = QuestSettings.stat_mappings[arg_24_2][1]

		return self:get_persistent_stat(arg_24_1, "quest_statistics", var_24_0) >= 250
	end,
	progress = function (self, arg_25_1, arg_25_2, arg_25_3)
		-- function 25
		local var_25_0 = QuestSettings.stat_mappings[arg_25_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_25_1, "quest_statistics", var_25_0)

		return {
			get_persistent_stat,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
		-- function 26
		local var_26_0 = arg_26_4[num]

		if not var_26_0 then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_26_0, "buff_system")

		if not (not has_extension and has_extension:has_buff_type("geheimnisnacht_2021_event_eye_glow")) then
			return
		end

		local var_26_2 = QuestSettings.stat_mappings[arg_26_5][1]

		self:increment_stat(arg_26_1, "quest_statistics", var_26_2)
	end
}
tbl.event_geheimnisnacht_2023_play_5 = {
	name = "quest_event_geheimnisnacht_2023_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_play_5_desc",
	completed = function (self, arg_27_1, arg_27_2, arg_27_3)
		-- function 27
		local var_27_0 = QuestSettings.stat_mappings[arg_27_2][1]

		return self:get_persistent_stat(arg_27_1, "quest_statistics", var_27_0) >= 5
	end,
	progress = function (self, arg_28_1, arg_28_2, arg_28_3)
		-- function 28
		local var_28_0 = QuestSettings.stat_mappings[arg_28_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_28_1, "quest_statistics", var_28_0)

		return {
			get_persistent_stat,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
		-- function 29
		if not Managers.state.game_mode:has_activated_mutator("night_mode") then
			local var_29_0 = QuestSettings.stat_mappings[arg_29_5][1]

			self:increment_stat(arg_29_1, "quest_statistics", var_29_0)
		end
	end
}
tbl.event_geheimnisnacht_2023_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2023_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_markus_desc",
	completed = function (self, arg_30_1, arg_30_2, arg_30_3)
		-- function 30
		local var_30_0 = QuestSettings.stat_mappings[arg_30_2][1]

		return self:get_persistent_stat(arg_30_1, "quest_statistics", var_30_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
		-- function 31
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_bastion" then
			return
		end

		local var_31_0 = QuestSettings.stat_mappings[arg_31_5][1]

		self:increment_stat(arg_31_1, "quest_statistics", var_31_0)
	end
}
tbl.event_geheimnisnacht_2023_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2023_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_bardin_desc",
	completed = function (self, arg_32_1, arg_32_2, arg_32_3)
		-- function 32
		local var_32_0 = QuestSettings.stat_mappings[arg_32_2][1]

		return self:get_persistent_stat(arg_32_1, "quest_statistics", var_32_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
		-- function 33
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_dwarf_beacons" then
			return
		end

		local var_33_0 = QuestSettings.stat_mappings[arg_33_5][1]

		self:increment_stat(arg_33_1, "quest_statistics", var_33_0)
	end
}
tbl.event_geheimnisnacht_2023_kill_cultists = {
	name = "quest_event_geheimnisnacht_2023_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_kill_cultists_desc",
	completed = function (self, arg_34_1, arg_34_2, arg_34_3)
		-- function 34
		local var_34_0 = QuestSettings.stat_mappings[arg_34_2][1]

		return self:get_persistent_stat(arg_34_1, "quest_statistics", var_34_0) >= 250
	end,
	progress = function (self, arg_35_1, arg_35_2, arg_35_3)
		-- function 35
		local var_35_0 = QuestSettings.stat_mappings[arg_35_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_35_1, "quest_statistics", var_35_0)

		return {
			get_persistent_stat,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
		-- function 36
		local var_36_0 = arg_36_4[num]

		if not var_36_0 then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_36_0, "buff_system")

		if not (not has_extension and has_extension:has_buff_type("geheimnisnacht_2021_event_eye_glow")) then
			return
		end

		local var_36_2 = QuestSettings.stat_mappings[arg_36_5][1]

		self:increment_stat(arg_36_1, "quest_statistics", var_36_2)
	end
}
tbl.event_geheimnisnacht_2023_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2023_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_kerillian_desc",
	completed = function (self, arg_37_1, arg_37_2, arg_37_3)
		-- function 37
		local var_37_0 = QuestSettings.stat_mappings[arg_37_2][1]

		return self:get_persistent_stat(arg_37_1, "quest_statistics", var_37_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
		-- function 38
		if Managers.level_transition_handler:get_current_level_keys() ~= "nurgle" then
			return
		end

		local var_38_0 = QuestSettings.stat_mappings[arg_38_5][1]

		self:increment_stat(arg_38_1, "quest_statistics", var_38_0)
	end
}
tbl.event_geheimnisnacht_2023_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2023_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_victor_desc",
	completed = function (self, arg_39_1, arg_39_2, arg_39_3)
		-- function 39
		local var_39_0 = QuestSettings.stat_mappings[arg_39_2][1]

		return self:get_persistent_stat(arg_39_1, "quest_statistics", var_39_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5)
		-- function 40
		if Managers.level_transition_handler:get_current_level_keys() ~= "warcamp" then
			return
		end

		local var_40_0 = QuestSettings.stat_mappings[arg_40_5][1]

		self:increment_stat(arg_40_1, "quest_statistics", var_40_0)
	end
}
tbl.event_geheimnisnacht_2023_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2023_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_sienna_desc",
	completed = function (self, arg_41_1, arg_41_2, arg_41_3)
		-- function 41
		local var_41_0 = QuestSettings.stat_mappings[arg_41_2][1]

		return self:get_persistent_stat(arg_41_1, "quest_statistics", var_41_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
		-- function 42
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_wizards_tower" then
			return
		end

		local var_42_0 = QuestSettings.stat_mappings[arg_42_5][1]

		self:increment_stat(arg_42_1, "quest_statistics", var_42_0)
	end
}
tbl.event_geheimnisnacht_2023_disrupt_all = {
	name = "quest_event_geheimnisnacht_2023_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_all_desc",
	completed = fn_2(tbl_2.event_geheimnisnacht_2023_disrupt_all),
	progress = fn(tbl_2.event_geheimnisnacht_2023_disrupt_all),
	requirements = fn_3(tbl_2.event_geheimnisnacht_2023_disrupt_all)
}
tbl.event_geheimnisnacht_2023_complete_all = {
	name = "quest_event_geheimnisnacht_2023_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_complete_all_desc",
	completed = fn_2(tbl_2.event_geheimnisnacht_2023_complete_all),
	progress = fn(tbl_2.event_geheimnisnacht_2023_complete_all),
	requirements = fn_3(tbl_2.event_geheimnisnacht_2023_complete_all)
}
tbl.event_geheimnisnacht_2023_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2023_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_play_5_hardmode_desc",
	completed = function (self, arg_43_1, arg_43_2, arg_43_3)
		-- function 43
		for i = 1, #mirror_array_inplace do
			local var_43_0 = QuestSettings.stat_mappings[arg_43_2][i]

			if self:get_persistent_stat(arg_43_1, "quest_statistics", var_43_0) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function (self, arg_44_1, arg_44_2, arg_44_3)
		-- function 44
		local num = 0

		for i = 1, #mirror_array_inplace do
			local var_44_1 = QuestSettings.stat_mappings[arg_44_2][i]

			if self:get_persistent_stat(arg_44_1, "quest_statistics", var_44_1) > 0 then
				num = num + 1
			end
		end

		return {
			num,
			5
		}
	end,
	requirements = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
		-- function 45
		local tbl = {}

		for i = 1, #mirror_array_inplace do
			local var_45_1 = mirror_array_inplace[i]
			local var_45_2 = QuestSettings.stat_mappings[arg_45_2][i]
			local flag = self:get_persistent_stat(arg_45_1, "quest_statistics", var_45_2) > 0

			tbl[i] = {
				name = LevelSettings[var_45_1].display_name,
				completed = flag
			}
		end

		return tbl
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5)
		-- function 46
		if not Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local var_46_0 = mirror_array_inplace[arg_46_4[2]]
			local var_46_1 = QuestSettings.stat_mappings[arg_46_5][var_46_0]

			self:increment_stat(arg_46_1, "quest_statistics", var_46_1)
		end
	end
}
tbl.event_geheimnisnacht_2022_play_5 = {
	name = "quest_event_geheimnisnacht_2022_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_play_5_desc",
	completed = function (self, arg_47_1, arg_47_2, arg_47_3)
		-- function 47
		local var_47_0 = QuestSettings.stat_mappings[arg_47_2][1]

		return self:get_persistent_stat(arg_47_1, "quest_statistics", var_47_0) >= 5
	end,
	progress = function (self, arg_48_1, arg_48_2, arg_48_3)
		-- function 48
		local var_48_0 = QuestSettings.stat_mappings[arg_48_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_48_1, "quest_statistics", var_48_0)

		return {
			get_persistent_stat,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (self, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5)
		-- function 49
		if not Managers.state.game_mode:has_activated_mutator("night_mode") then
			local var_49_0 = QuestSettings.stat_mappings[arg_49_5][1]

			self:increment_stat(arg_49_1, "quest_statistics", var_49_0)
		end
	end
}
tbl.event_geheimnisnacht_2022_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2022_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_markus_desc",
	completed = function (self, arg_50_1, arg_50_2, arg_50_3)
		-- function 50
		local var_50_0 = QuestSettings.stat_mappings[arg_50_2][1]

		return self:get_persistent_stat(arg_50_1, "quest_statistics", var_50_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
		-- function 51
		if Managers.level_transition_handler:get_current_level_keys() ~= "catacombs" then
			return
		end

		local var_51_0 = QuestSettings.stat_mappings[arg_51_5][1]

		self:increment_stat(arg_51_1, "quest_statistics", var_51_0)
	end
}
tbl.event_geheimnisnacht_2022_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2022_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_bardin_desc",
	completed = function (self, arg_52_1, arg_52_2, arg_52_3)
		-- function 52
		local var_52_0 = QuestSettings.stat_mappings[arg_52_2][1]

		return self:get_persistent_stat(arg_52_1, "quest_statistics", var_52_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
		-- function 53
		if Managers.level_transition_handler:get_current_level_keys() ~= "mines" then
			return
		end

		local var_53_0 = QuestSettings.stat_mappings[arg_53_5][1]

		self:increment_stat(arg_53_1, "quest_statistics", var_53_0)
	end
}
tbl.event_geheimnisnacht_2022_kill_cultists = {
	name = "quest_event_geheimnisnacht_2022_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_kill_cultists_desc",
	completed = function (self, arg_54_1, arg_54_2, arg_54_3)
		-- function 54
		local var_54_0 = QuestSettings.stat_mappings[arg_54_2][1]

		return self:get_persistent_stat(arg_54_1, "quest_statistics", var_54_0) >= 250
	end,
	progress = function (self, arg_55_1, arg_55_2, arg_55_3)
		-- function 55
		local var_55_0 = QuestSettings.stat_mappings[arg_55_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_55_1, "quest_statistics", var_55_0)

		return {
			get_persistent_stat,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5)
		-- function 56
		local var_56_0 = arg_56_4[num]

		if not var_56_0 then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_56_0, "buff_system")

		if not (not has_extension and has_extension:has_buff_type("geheimnisnacht_2021_event_eye_glow")) then
			return
		end

		local var_56_2 = QuestSettings.stat_mappings[arg_56_5][1]

		self:increment_stat(arg_56_1, "quest_statistics", var_56_2)
	end
}
tbl.event_geheimnisnacht_2022_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2022_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_kerillian_desc",
	completed = function (self, arg_57_1, arg_57_2, arg_57_3)
		-- function 57
		local var_57_0 = QuestSettings.stat_mappings[arg_57_2][1]

		return self:get_persistent_stat(arg_57_1, "quest_statistics", var_57_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
		-- function 58
		if Managers.level_transition_handler:get_current_level_keys() ~= "elven_ruins" then
			return
		end

		local var_58_0 = QuestSettings.stat_mappings[arg_58_5][1]

		self:increment_stat(arg_58_1, "quest_statistics", var_58_0)
	end
}
tbl.event_geheimnisnacht_2022_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2022_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_victor_desc",
	completed = function (self, arg_59_1, arg_59_2, arg_59_3)
		-- function 59
		local var_59_0 = QuestSettings.stat_mappings[arg_59_2][1]

		return self:get_persistent_stat(arg_59_1, "quest_statistics", var_59_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5)
		-- function 60
		if Managers.level_transition_handler:get_current_level_keys() ~= "ground_zero" then
			return
		end

		local var_60_0 = QuestSettings.stat_mappings[arg_60_5][1]

		self:increment_stat(arg_60_1, "quest_statistics", var_60_0)
	end
}
tbl.event_geheimnisnacht_2022_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2022_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_sienna_desc",
	completed = function (self, arg_61_1, arg_61_2, arg_61_3)
		-- function 61
		local var_61_0 = QuestSettings.stat_mappings[arg_61_2][1]

		return self:get_persistent_stat(arg_61_1, "quest_statistics", var_61_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5)
		-- function 62
		if Managers.level_transition_handler:get_current_level_keys() ~= "farmlands" then
			return
		end

		local var_62_0 = QuestSettings.stat_mappings[arg_62_5][1]

		self:increment_stat(arg_62_1, "quest_statistics", var_62_0)
	end
}
tbl.event_geheimnisnacht_2022_disrupt_all = {
	name = "quest_event_geheimnisnacht_2022_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_all_desc",
	completed = fn_2(tbl_2.event_geheimnisnacht_2022_disrupt_all),
	progress = fn(tbl_2.event_geheimnisnacht_2022_disrupt_all),
	requirements = fn_3(tbl_2.event_geheimnisnacht_2022_disrupt_all)
}
tbl.event_geheimnisnacht_2022_complete_all = {
	name = "quest_event_geheimnisnacht_2022_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_complete_all_desc",
	completed = fn_2(tbl_2.event_geheimnisnacht_2022_complete_all),
	progress = fn(tbl_2.event_geheimnisnacht_2022_complete_all),
	requirements = fn_3(tbl_2.event_geheimnisnacht_2022_complete_all)
}
tbl.event_geheimnisnacht_2022_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2022_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_play_5_hardmode_desc",
	completed = function (self, arg_63_1, arg_63_2, arg_63_3)
		-- function 63
		for i = 1, #mirror_array_inplace do
			local var_63_0 = QuestSettings.stat_mappings[arg_63_2][i]

			if self:get_persistent_stat(arg_63_1, "quest_statistics", var_63_0) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function (self, arg_64_1, arg_64_2, arg_64_3)
		-- function 64
		local num = 0

		for i = 1, #mirror_array_inplace do
			local var_64_1 = QuestSettings.stat_mappings[arg_64_2][i]

			if self:get_persistent_stat(arg_64_1, "quest_statistics", var_64_1) > 0 then
				num = num + 1
			end
		end

		return {
			num,
			5
		}
	end,
	requirements = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
		-- function 65
		local tbl = {}

		for i = 1, #mirror_array_inplace do
			local var_65_1 = mirror_array_inplace[i]
			local var_65_2 = QuestSettings.stat_mappings[arg_65_2][i]
			local flag = self:get_persistent_stat(arg_65_1, "quest_statistics", var_65_2) > 0

			tbl[i] = {
				name = LevelSettings[var_65_1].display_name,
				completed = flag
			}
		end

		return tbl
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (self, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5)
		-- function 66
		if not Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local var_66_0 = mirror_array_inplace[arg_66_4[2]]
			local var_66_1 = QuestSettings.stat_mappings[arg_66_5][var_66_0]

			self:increment_stat(arg_66_1, "quest_statistics", var_66_1)
		end
	end
}
tbl.event_geheimnisnacht_2021_play_5 = {
	name = "quest_event_geheimnisnacht_2021_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_play_5_desc",
	completed = function (self, arg_67_1, arg_67_2, arg_67_3)
		-- function 67
		local var_67_0 = QuestSettings.stat_mappings[arg_67_2][1]

		return self:get_persistent_stat(arg_67_1, "quest_statistics", var_67_0) >= 5
	end,
	progress = function (self, arg_68_1, arg_68_2, arg_68_3)
		-- function 68
		local var_68_0 = QuestSettings.stat_mappings[arg_68_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_68_1, "quest_statistics", var_68_0)

		return {
			get_persistent_stat,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (self, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5)
		-- function 69
		if not Managers.state.game_mode:has_activated_mutator("night_mode") then
			local var_69_0 = QuestSettings.stat_mappings[arg_69_5][1]

			self:increment_stat(arg_69_1, "quest_statistics", var_69_0)
		end
	end
}
tbl.event_geheimnisnacht_2021_kill_cultists = {
	name = "quest_event_geheimnisnacht_2021_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_kill_cultists_desc",
	completed = function (self, arg_70_1, arg_70_2, arg_70_3)
		-- function 70
		local var_70_0 = QuestSettings.stat_mappings[arg_70_2][1]

		return self:get_persistent_stat(arg_70_1, "quest_statistics", var_70_0) >= 250
	end,
	progress = function (self, arg_71_1, arg_71_2, arg_71_3)
		-- function 71
		local var_71_0 = QuestSettings.stat_mappings[arg_71_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_71_1, "quest_statistics", var_71_0)

		return {
			get_persistent_stat,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function (self, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5)
		-- function 72
		local var_72_0 = arg_72_4[num]

		if not var_72_0 then
			return
		end

		local has_extension = ScriptUnit.has_extension(var_72_0, "buff_system")

		if not (not has_extension and has_extension:has_buff_type("geheimnisnacht_2021_event_eye_glow")) then
			return
		end

		local var_72_2 = QuestSettings.stat_mappings[arg_72_5][1]

		self:increment_stat(arg_72_1, "quest_statistics", var_72_2)
	end
}
tbl.event_geheimnisnacht_2021_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2021_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_bardin_desc",
	completed = function (self, arg_73_1, arg_73_2, arg_73_3)
		-- function 73
		local var_73_0 = QuestSettings.stat_mappings[arg_73_2][1]

		return self:get_persistent_stat(arg_73_1, "quest_statistics", var_73_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_74_1, arg_74_2, arg_74_3, arg_74_4, arg_74_5)
		-- function 74
		if Managers.level_transition_handler:get_current_level_keys() ~= "bell" then
			return
		end

		local var_74_0 = QuestSettings.stat_mappings[arg_74_5][1]

		self:increment_stat(arg_74_1, "quest_statistics", var_74_0)
	end
}
tbl.event_geheimnisnacht_2021_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2021_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_markus_desc",
	completed = function (self, arg_75_1, arg_75_2, arg_75_3)
		-- function 75
		local var_75_0 = QuestSettings.stat_mappings[arg_75_2][1]

		return self:get_persistent_stat(arg_75_1, "quest_statistics", var_75_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_76_1, arg_76_2, arg_76_3, arg_76_4, arg_76_5)
		-- function 76
		if Managers.level_transition_handler:get_current_level_keys() ~= "military" then
			return
		end

		local var_76_0 = QuestSettings.stat_mappings[arg_76_5][1]

		self:increment_stat(arg_76_1, "quest_statistics", var_76_0)
	end
}
tbl.event_geheimnisnacht_2021_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2021_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_kerillian_desc",
	completed = function (self, arg_77_1, arg_77_2, arg_77_3)
		-- function 77
		local var_77_0 = QuestSettings.stat_mappings[arg_77_2][1]

		return self:get_persistent_stat(arg_77_1, "quest_statistics", var_77_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5)
		-- function 78
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_portals" then
			return
		end

		local var_78_0 = QuestSettings.stat_mappings[arg_78_5][1]

		self:increment_stat(arg_78_1, "quest_statistics", var_78_0)
	end
}
tbl.event_geheimnisnacht_2021_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2021_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_victor_desc",
	completed = function (self, arg_79_1, arg_79_2, arg_79_3)
		-- function 79
		local var_79_0 = QuestSettings.stat_mappings[arg_79_2][1]

		return self:get_persistent_stat(arg_79_1, "quest_statistics", var_79_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_80_1, arg_80_2, arg_80_3, arg_80_4, arg_80_5)
		-- function 80
		if Managers.level_transition_handler:get_current_level_keys() ~= "dlc_castle" then
			return
		end

		local var_80_0 = QuestSettings.stat_mappings[arg_80_5][1]

		self:increment_stat(arg_80_1, "quest_statistics", var_80_0)
	end
}
tbl.event_geheimnisnacht_2021_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2021_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_sienna_desc",
	completed = function (self, arg_81_1, arg_81_2, arg_81_3)
		-- function 81
		local var_81_0 = QuestSettings.stat_mappings[arg_81_2][1]

		return self:get_persistent_stat(arg_81_1, "quest_statistics", var_81_0) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (self, arg_82_1, arg_82_2, arg_82_3, arg_82_4, arg_82_5)
		-- function 82
		if Managers.level_transition_handler:get_current_level_keys() ~= "ussingen" then
			return
		end

		local var_82_0 = QuestSettings.stat_mappings[arg_82_5][1]

		self:increment_stat(arg_82_1, "quest_statistics", var_82_0)
	end
}
tbl.event_geheimnisnacht_2021_disrupt_all = {
	name = "quest_event_geheimnisnacht_2021_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_all_desc",
	completed = fn_2(tbl_2.event_geheimnisnacht_2021_disrupt_all),
	progress = fn(tbl_2.event_geheimnisnacht_2021_disrupt_all),
	requirements = fn_3(tbl_2.event_geheimnisnacht_2021_disrupt_all)
}
tbl.event_geheimnisnacht_2021_complete_all = {
	name = "quest_event_geheimnisnacht_2021_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_complete_all_desc",
	completed = fn_2(tbl_2.event_geheimnisnacht_2021_complete_all),
	progress = fn(tbl_2.event_geheimnisnacht_2021_complete_all),
	requirements = fn_3(tbl_2.event_geheimnisnacht_2021_complete_all)
}
tbl.event_geheimnisnacht_2021_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2021_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_play_5_hardmode_desc",
	completed = function (self, arg_83_1, arg_83_2, arg_83_3)
		-- function 83
		for i = 1, #mirror_array_inplace do
			local var_83_0 = QuestSettings.stat_mappings[arg_83_2][i]

			if self:get_persistent_stat(arg_83_1, "quest_statistics", var_83_0) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function (self, arg_84_1, arg_84_2, arg_84_3)
		-- function 84
		local num = 0

		for i = 1, #mirror_array_inplace do
			local var_84_1 = QuestSettings.stat_mappings[arg_84_2][i]

			if self:get_persistent_stat(arg_84_1, "quest_statistics", var_84_1) > 0 then
				num = num + 1
			end
		end

		return {
			num,
			5
		}
	end,
	requirements = function (self, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
		-- function 85
		local tbl = {}

		for i = 1, #mirror_array_inplace do
			local var_85_1 = mirror_array_inplace[i]
			local var_85_2 = QuestSettings.stat_mappings[arg_85_2][i]
			local flag = self:get_persistent_stat(arg_85_1, "quest_statistics", var_85_2) > 0

			tbl[i] = {
				name = LevelSettings[var_85_1].display_name,
				completed = flag
			}
		end

		return tbl
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (self, arg_86_1, arg_86_2, arg_86_3, arg_86_4, arg_86_5)
		-- function 86
		if not Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local var_86_0 = mirror_array_inplace[arg_86_4[2]]
			local var_86_1 = QuestSettings.stat_mappings[arg_86_5][var_86_0]

			self:increment_stat(arg_86_1, "quest_statistics", var_86_1)
		end
	end
}
