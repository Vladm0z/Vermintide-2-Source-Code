-- chunkname: @scripts/settings/dlcs/skulls_2025/skulls_2025_quest_settings.lua

local skulls_2025 = DLCSettings.skulls_2025
local num = 100

skulls_2025.quest_templates = {
	event_skulls_2025_collect_skulls = {
		name = "quest_event_skulls_2025_pickups",
		icon = "quest_book_event_skull",
		summary_icon = "achievement_symbol_book_event_skull",
		desc = function ()
			-- function 1
			return string.format(Localize("quest_event_skulls_2025_pickups_desc"), num)
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
