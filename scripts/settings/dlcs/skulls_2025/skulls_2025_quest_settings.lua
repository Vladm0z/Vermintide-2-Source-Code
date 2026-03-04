-- chunkname: @scripts/settings/dlcs/skulls_2025/skulls_2025_quest_settings.lua

local var_0_0 = DLCSettings.skulls_2025
local var_0_1 = 100

var_0_0.quest_templates = {
	event_skulls_2025_collect_skulls = {
		name = "quest_event_skulls_2025_pickups",
		icon = "quest_book_event_skull",
		summary_icon = "achievement_symbol_book_event_skull",
		desc = function ()
			return string.format(Localize("quest_event_skulls_2025_pickups_desc"), var_0_1)
		end,
		completed = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			local var_2_0 = QuestSettings.stat_mappings[arg_2_2][1]

			return arg_2_0:get_persistent_stat(arg_2_1, "quest_statistics", var_2_0) >= var_0_1
		end,
		progress = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
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
		on_event = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
			local var_4_0 = QuestSettings.stat_mappings[arg_4_5][1]

			arg_4_0:increment_stat(arg_4_1, "quest_statistics", var_4_0)
		end
	}
}
