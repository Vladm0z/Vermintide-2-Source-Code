-- chunkname: @scripts/settings/dlcs/skulls_2023/skulls_2023_quest_settings.lua

local settings = DLCSettings.skulls_2023
local SKULLS_2023_PICKUP_COUNT = 100
local SKULLS_2024_PICKUP_COUNT = 100

settings.quest_templates = {
	event_skulls_2023_collect_skulls = {
		name = "quest_event_skulls_2023_pickups",
		icon = "quest_book_event_skull",
		summary_icon = "achievement_symbol_book_event_skull",
		desc = function ()
			-- function 1
			return string.format(Localize("quest_event_skulls_2023_pickups_desc"), SKULLS_2023_PICKUP_COUNT)
		end,
		completed = function (statistics_db, stats_id, quest_key, quest_templates)
			-- function 2
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= SKULLS_2023_PICKUP_COUNT
		end,
		progress = function (statistics_db, stats_id, quest_key, quest_templates)
			-- function 3
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				SKULLS_2023_PICKUP_COUNT
			}
		end,
		events = {
			"register_skulls_2023_pickup"
		},
		on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
			-- function 4
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	}
}
settings.quest_templates = {
	event_skulls_2024_collect_skulls = {
		name = "quest_event_skulls_2024_pickups",
		icon = "quest_book_event_skull",
		summary_icon = "achievement_symbol_book_event_skull",
		desc = function ()
			-- function 5
			return string.format(Localize("quest_event_skulls_2024_pickups_desc"), SKULLS_2024_PICKUP_COUNT)
		end,
		completed = function (statistics_db, stats_id, quest_key, quest_templates)
			-- function 6
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= SKULLS_2024_PICKUP_COUNT
		end,
		progress = function (statistics_db, stats_id, quest_key, quest_templates)
			-- function 7
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				SKULLS_2024_PICKUP_COUNT
			}
		end,
		events = {
			"register_skulls_2023_pickup"
		},
		on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
			-- function 8
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	}
}
