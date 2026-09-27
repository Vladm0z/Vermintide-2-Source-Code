-- chunkname: @scripts/settings/dlcs/skulls_2023/skulls_2023_quest_settings.lua

local skulls_2023 = DLCSettings.skulls_2023
local num = 100
local num_2 = 100

skulls_2023.quest_templates = {
	event_skulls_2023_collect_skulls = {
		name = "quest_event_skulls_2023_pickups",
		icon = "quest_book_event_skull",
		summary_icon = "achievement_symbol_book_event_skull",
		desc = function ()
			-- function 1
			return string.format(Localize("quest_event_skulls_2023_pickups_desc"), num)
		end,
		completed = function (self, arg_2_1, arg_2_2, arg_2_3)
			-- function 2
			local var_2_0 = QuestSettings.stat_mappings[arg_2_2][1]

			return self:get_persistent_stat(arg_2_1, "quest_statistics", var_2_0) >= num
		end,
		progress = function (self, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			local var_3_0 = QuestSettings.stat_mappings[arg_3_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_3_1, "quest_statistics", var_3_0)

			return {
				get_persistent_stat,
				num
			}
		end,
		events = {
			"register_skulls_2023_pickup"
		},
		on_event = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
			-- function 4
			local var_4_0 = QuestSettings.stat_mappings[arg_4_5][1]

			self:increment_stat(arg_4_1, "quest_statistics", var_4_0)
		end
	}
}
skulls_2023.quest_templates = {
	event_skulls_2024_collect_skulls = {
		name = "quest_event_skulls_2024_pickups",
		icon = "quest_book_event_skull",
		summary_icon = "achievement_symbol_book_event_skull",
		desc = function ()
			-- function 5
			return string.format(Localize("quest_event_skulls_2024_pickups_desc"), num_2)
		end,
		completed = function (self, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			local var_6_0 = QuestSettings.stat_mappings[arg_6_2][1]

			return self:get_persistent_stat(arg_6_1, "quest_statistics", var_6_0) >= num_2
		end,
		progress = function (self, arg_7_1, arg_7_2, arg_7_3)
			-- function 7
			local var_7_0 = QuestSettings.stat_mappings[arg_7_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_7_1, "quest_statistics", var_7_0)

			return {
				get_persistent_stat,
				num_2
			}
		end,
		events = {
			"register_skulls_2023_pickup"
		},
		on_event = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
			-- function 8
			local var_8_0 = QuestSettings.stat_mappings[arg_8_5][1]

			self:increment_stat(arg_8_1, "quest_statistics", var_8_0)
		end
	}
}
