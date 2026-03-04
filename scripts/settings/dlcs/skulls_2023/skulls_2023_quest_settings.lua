-- chunkname: @scripts/settings/dlcs/skulls_2023/skulls_2023_quest_settings.lua

local var_0_0 = DLCSettings.skulls_2023
local var_0_1 = 100
local var_0_2 = 100

var_0_0.quest_templates = {
	event_skulls_2023_collect_skulls = {
		name = "quest_event_skulls_2023_pickups",
		icon = "quest_book_event_skull",
		summary_icon = "achievement_symbol_book_event_skull",
		desc = function()
			return string.format(Localize("quest_event_skulls_2023_pickups_desc"), var_0_1)
		end,
		completed = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			local var_2_0 = QuestSettings.stat_mappings[arg_2_2][1]

			return arg_2_0:get_persistent_stat(arg_2_1, "quest_statistics", var_2_0) >= var_0_1
		end,
		progress = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			local var_3_0 = QuestSettings.stat_mappings[arg_3_2][1]
			local var_3_1 = arg_3_0:get_persistent_stat(arg_3_1, "quest_statistics", var_3_0)

			return {
				var_3_1,
				var_0_1
			}
		end,
		events = {
			"register_skulls_2023_pickup"
		},
		on_event = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
			local var_4_0 = QuestSettings.stat_mappings[arg_4_5][1]

			arg_4_0:increment_stat(arg_4_1, "quest_statistics", var_4_0)
		end
	}
}
var_0_0.quest_templates = {
	event_skulls_2024_collect_skulls = {
		name = "quest_event_skulls_2024_pickups",
		icon = "quest_book_event_skull",
		summary_icon = "achievement_symbol_book_event_skull",
		desc = function()
			return string.format(Localize("quest_event_skulls_2024_pickups_desc"), var_0_2)
		end,
		completed = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = QuestSettings.stat_mappings[arg_6_2][1]

			return arg_6_0:get_persistent_stat(arg_6_1, "quest_statistics", var_6_0) >= var_0_2
		end,
		progress = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			local var_7_0 = QuestSettings.stat_mappings[arg_7_2][1]
			local var_7_1 = arg_7_0:get_persistent_stat(arg_7_1, "quest_statistics", var_7_0)

			return {
				var_7_1,
				var_0_2
			}
		end,
		events = {
			"register_skulls_2023_pickup"
		},
		on_event = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
			local var_8_0 = QuestSettings.stat_mappings[arg_8_5][1]

			arg_8_0:increment_stat(arg_8_1, "quest_statistics", var_8_0)
		end
	}
}
