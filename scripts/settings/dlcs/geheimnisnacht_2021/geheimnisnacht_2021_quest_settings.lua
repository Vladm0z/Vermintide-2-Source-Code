-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2021/geheimnisnacht_2021_quest_settings.lua

local generate_geheimnisnacht_quests = require("scripts/settings/dlcs/geheimnisnacht_2025/generate_geheimnisnacht_quests")
local settings = DLCSettings.geheimnisnacht_2021
local geheim_quest_templates = {}

settings.quest_templates = geheim_quest_templates

generate_geheimnisnacht_quests(2025)
generate_geheimnisnacht_quests(2026)

local quest_meta_mapping = {
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
local hard_mode_levels = table.mirror_array_inplace({
	"dlc_dwarf_whaling",
	"catacombs",
	"ground_zero",
	"elven_ruins",
	"farmlands"
})

local function make_meta_progress(meta_quest_map)
	-- function 1
	local num_meta_quests = #meta_quest_map

	return function (statistics_db, stats_id, quest_key, quest_templates, claimed_quests)
		-- function 2
		local count = 0

		for i = 1, num_meta_quests do
			local quest_name = meta_quest_map[i]
			local completed = claimed_quests[quest_name]

			if completed then
				count = count + 1
			end
		end

		return {
			count,
			num_meta_quests
		}
	end
end

local function make_meta_completed(meta_quest_map)
	-- function 3
	local num_meta_quests = #meta_quest_map

	return function (statistics_db, stats_id, quest_key, quest_templates, claimed_quests)
		-- function 4
		for i = 1, num_meta_quests do
			local quest_name = meta_quest_map[i]
			local completed = claimed_quests[quest_name]

			if not completed then
				return false
			end
		end

		return true
	end
end

local function make_meta_requirements(meta_quest_map)
	-- function 5
	local num_meta_quests = #meta_quest_map

	return function (statistics_db, stats_id, quest_key, quest_templates, claimed_quests)
		-- function 6
		local reqs = {}

		for i = 1, num_meta_quests do
			local quest_name = meta_quest_map[i]
			local completed = claimed_quests[quest_name]
			local quest_display_name = quest_templates[quest_name].name

			reqs[i] = {
				name = quest_display_name,
				completed = completed
			}
		end

		return reqs
	end
end

local register_kill_victim_unit = 2

geheim_quest_templates.event_geheimnisnacht_2024_play_5 = {
	name = "quest_event_geheimnisnacht_2024_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_play_5_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 7
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 5
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 8
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 9
		if Managers.state.game_mode:has_activated_mutator("night_mode") then
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	end
}
geheim_quest_templates.event_geheimnisnacht_2024_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2024_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_markus_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 10
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 11
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "ground_zero" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2024_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2024_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_bardin_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 12
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 13
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "farmlands" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2024_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2024_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_kerillian_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 14
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 15
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "elven_ruins" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2024_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2024_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_victor_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 16
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 17
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "catacombs" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2024_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2024_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_sienna_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 18
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 19
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "dlc_dwarf_whaling" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2024_disrupt_all = {
	name = "quest_event_geheimnisnacht_2024_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_disrupt_all_desc",
	completed = make_meta_completed(quest_meta_mapping.event_geheimnisnacht_2024_disrupt_all),
	progress = make_meta_progress(quest_meta_mapping.event_geheimnisnacht_2024_disrupt_all),
	requirements = make_meta_requirements(quest_meta_mapping.event_geheimnisnacht_2024_disrupt_all)
}
geheim_quest_templates.event_geheimnisnacht_2024_complete_all = {
	name = "quest_event_geheimnisnacht_2024_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_complete_all_desc",
	completed = make_meta_completed(quest_meta_mapping.event_geheimnisnacht_2024_complete_all),
	progress = make_meta_progress(quest_meta_mapping.event_geheimnisnacht_2024_complete_all),
	requirements = make_meta_requirements(quest_meta_mapping.event_geheimnisnacht_2024_complete_all)
}
geheim_quest_templates.event_geheimnisnacht_2024_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2024_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_play_5_hardmode_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 20
		for i = 1, #hard_mode_levels do
			local stat_name = QuestSettings.stat_mappings[quest_key][i]

			if statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 21
		local count = 0

		for i = 1, #hard_mode_levels do
			local stat_name = QuestSettings.stat_mappings[quest_key][i]

			if statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0 then
				count = count + 1
			end
		end

		return {
			count,
			5
		}
	end,
	requirements = function (statistics_db, stats_id, quest_key, quest_templates, claimed_quests)
		-- function 22
		local reqs = {}

		for i = 1, #hard_mode_levels do
			local level_id = hard_mode_levels[i]
			local stat_name = QuestSettings.stat_mappings[quest_key][i]
			local completed = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0

			reqs[i] = {
				name = LevelSettings[level_id].display_name,
				completed = completed
			}
		end

		return reqs
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 23
		if Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local stat_id = hard_mode_levels[event_data[2]]
			local stat_name = QuestSettings.stat_mappings[quest_key][stat_id]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	end
}
geheim_quest_templates.event_geheimnisnacht_2024_kill_cultists = {
	name = "quest_event_geheimnisnacht_2024_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2024_kill_cultists_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 24
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 250
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 25
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 26
		local killed_unit = event_data[register_kill_victim_unit]

		if not killed_unit then
			return
		end

		local killed_buff_extension = ScriptUnit.has_extension(killed_unit, "buff_system")

		if not killed_buff_extension or not killed_buff_extension:has_buff_type("geheimnisnacht_2021_event_eye_glow") then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2023_play_5 = {
	name = "quest_event_geheimnisnacht_2023_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_play_5_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 27
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 5
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 28
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 29
		if Managers.state.game_mode:has_activated_mutator("night_mode") then
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	end
}
geheim_quest_templates.event_geheimnisnacht_2023_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2023_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_markus_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 30
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 31
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "dlc_bastion" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2023_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2023_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_bardin_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 32
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 33
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "dlc_dwarf_beacons" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2023_kill_cultists = {
	name = "quest_event_geheimnisnacht_2023_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_kill_cultists_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 34
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 250
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 35
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 36
		local killed_unit = event_data[register_kill_victim_unit]

		if not killed_unit then
			return
		end

		local killed_buff_extension = ScriptUnit.has_extension(killed_unit, "buff_system")

		if not killed_buff_extension or not killed_buff_extension:has_buff_type("geheimnisnacht_2021_event_eye_glow") then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2023_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2023_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_kerillian_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 37
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 38
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "nurgle" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2023_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2023_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_victor_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 39
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 40
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "warcamp" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2023_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2023_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_sienna_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 41
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 42
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "dlc_wizards_tower" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2023_disrupt_all = {
	name = "quest_event_geheimnisnacht_2023_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_disrupt_all_desc",
	completed = make_meta_completed(quest_meta_mapping.event_geheimnisnacht_2023_disrupt_all),
	progress = make_meta_progress(quest_meta_mapping.event_geheimnisnacht_2023_disrupt_all),
	requirements = make_meta_requirements(quest_meta_mapping.event_geheimnisnacht_2023_disrupt_all)
}
geheim_quest_templates.event_geheimnisnacht_2023_complete_all = {
	name = "quest_event_geheimnisnacht_2023_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_complete_all_desc",
	completed = make_meta_completed(quest_meta_mapping.event_geheimnisnacht_2023_complete_all),
	progress = make_meta_progress(quest_meta_mapping.event_geheimnisnacht_2023_complete_all),
	requirements = make_meta_requirements(quest_meta_mapping.event_geheimnisnacht_2023_complete_all)
}
geheim_quest_templates.event_geheimnisnacht_2023_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2023_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2023_play_5_hardmode_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 43
		for i = 1, #hard_mode_levels do
			local stat_name = QuestSettings.stat_mappings[quest_key][i]

			if statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 44
		local count = 0

		for i = 1, #hard_mode_levels do
			local stat_name = QuestSettings.stat_mappings[quest_key][i]

			if statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0 then
				count = count + 1
			end
		end

		return {
			count,
			5
		}
	end,
	requirements = function (statistics_db, stats_id, quest_key, quest_templates, claimed_quests)
		-- function 45
		local reqs = {}

		for i = 1, #hard_mode_levels do
			local level_id = hard_mode_levels[i]
			local stat_name = QuestSettings.stat_mappings[quest_key][i]
			local completed = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0

			reqs[i] = {
				name = LevelSettings[level_id].display_name,
				completed = completed
			}
		end

		return reqs
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 46
		if Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local stat_id = hard_mode_levels[event_data[2]]
			local stat_name = QuestSettings.stat_mappings[quest_key][stat_id]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	end
}
geheim_quest_templates.event_geheimnisnacht_2022_play_5 = {
	name = "quest_event_geheimnisnacht_2022_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_play_5_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 47
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 5
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 48
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 49
		if Managers.state.game_mode:has_activated_mutator("night_mode") then
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	end
}
geheim_quest_templates.event_geheimnisnacht_2022_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2022_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_markus_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 50
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 51
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "catacombs" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2022_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2022_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_bardin_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 52
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 53
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "mines" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2022_kill_cultists = {
	name = "quest_event_geheimnisnacht_2022_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_kill_cultists_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 54
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 250
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 55
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 56
		local killed_unit = event_data[register_kill_victim_unit]

		if not killed_unit then
			return
		end

		local killed_buff_extension = ScriptUnit.has_extension(killed_unit, "buff_system")

		if not killed_buff_extension or not killed_buff_extension:has_buff_type("geheimnisnacht_2021_event_eye_glow") then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2022_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2022_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_kerillian_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 57
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 58
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "elven_ruins" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2022_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2022_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_victor_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 59
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 60
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "ground_zero" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2022_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2022_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_sienna_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 61
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 62
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "farmlands" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2022_disrupt_all = {
	name = "quest_event_geheimnisnacht_2022_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_disrupt_all_desc",
	completed = make_meta_completed(quest_meta_mapping.event_geheimnisnacht_2022_disrupt_all),
	progress = make_meta_progress(quest_meta_mapping.event_geheimnisnacht_2022_disrupt_all),
	requirements = make_meta_requirements(quest_meta_mapping.event_geheimnisnacht_2022_disrupt_all)
}
geheim_quest_templates.event_geheimnisnacht_2022_complete_all = {
	name = "quest_event_geheimnisnacht_2022_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_complete_all_desc",
	completed = make_meta_completed(quest_meta_mapping.event_geheimnisnacht_2022_complete_all),
	progress = make_meta_progress(quest_meta_mapping.event_geheimnisnacht_2022_complete_all),
	requirements = make_meta_requirements(quest_meta_mapping.event_geheimnisnacht_2022_complete_all)
}
geheim_quest_templates.event_geheimnisnacht_2022_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2022_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2022_play_5_hardmode_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 63
		for i = 1, #hard_mode_levels do
			local stat_name = QuestSettings.stat_mappings[quest_key][i]

			if statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 64
		local count = 0

		for i = 1, #hard_mode_levels do
			local stat_name = QuestSettings.stat_mappings[quest_key][i]

			if statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0 then
				count = count + 1
			end
		end

		return {
			count,
			5
		}
	end,
	requirements = function (statistics_db, stats_id, quest_key, quest_templates, claimed_quests)
		-- function 65
		local reqs = {}

		for i = 1, #hard_mode_levels do
			local level_id = hard_mode_levels[i]
			local stat_name = QuestSettings.stat_mappings[quest_key][i]
			local completed = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0

			reqs[i] = {
				name = LevelSettings[level_id].display_name,
				completed = completed
			}
		end

		return reqs
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 66
		if Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local stat_id = hard_mode_levels[event_data[2]]
			local stat_name = QuestSettings.stat_mappings[quest_key][stat_id]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	end
}
geheim_quest_templates.event_geheimnisnacht_2021_play_5 = {
	name = "quest_event_geheimnisnacht_2021_play_5",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_play_5_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 67
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 5
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 68
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			5
		}
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 69
		if Managers.state.game_mode:has_activated_mutator("night_mode") then
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	end
}
geheim_quest_templates.event_geheimnisnacht_2021_kill_cultists = {
	name = "quest_event_geheimnisnacht_2021_kill_cultists",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_kill_cultists_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 70
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 250
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 71
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			250
		}
	end,
	events = {
		"register_kill"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 72
		local killed_unit = event_data[register_kill_victim_unit]

		if not killed_unit then
			return
		end

		local killed_buff_extension = ScriptUnit.has_extension(killed_unit, "buff_system")

		if not killed_buff_extension or not killed_buff_extension:has_buff_type("geheimnisnacht_2021_event_eye_glow") then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2021_disrupt_bardin = {
	name = "quest_event_geheimnisnacht_2021_disrupt_bardin",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_bardin_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 73
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 74
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "bell" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2021_disrupt_markus = {
	name = "quest_event_geheimnisnacht_2021_disrupt_markus",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_markus_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 75
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 76
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "military" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2021_disrupt_kerillian = {
	name = "quest_event_geheimnisnacht_2021_disrupt_kerillian",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_kerillian_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 77
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 78
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "dlc_portals" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2021_disrupt_victor = {
	name = "quest_event_geheimnisnacht_2021_disrupt_victor",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_victor_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 79
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 80
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "dlc_castle" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2021_disrupt_sienna = {
	name = "quest_event_geheimnisnacht_2021_disrupt_sienna",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_sienna_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 81
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
	end,
	events = {
		"altar_destroyed"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 82
		local level_transition_handler = Managers.level_transition_handler
		local level_key = level_transition_handler:get_current_level_keys()

		if level_key ~= "ussingen" then
			return
		end

		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
	end
}
geheim_quest_templates.event_geheimnisnacht_2021_disrupt_all = {
	name = "quest_event_geheimnisnacht_2021_disrupt_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_disrupt_all_desc",
	completed = make_meta_completed(quest_meta_mapping.event_geheimnisnacht_2021_disrupt_all),
	progress = make_meta_progress(quest_meta_mapping.event_geheimnisnacht_2021_disrupt_all),
	requirements = make_meta_requirements(quest_meta_mapping.event_geheimnisnacht_2021_disrupt_all)
}
geheim_quest_templates.event_geheimnisnacht_2021_complete_all = {
	name = "quest_event_geheimnisnacht_2021_complete_all",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_complete_all_desc",
	completed = make_meta_completed(quest_meta_mapping.event_geheimnisnacht_2021_complete_all),
	progress = make_meta_progress(quest_meta_mapping.event_geheimnisnacht_2021_complete_all),
	requirements = make_meta_requirements(quest_meta_mapping.event_geheimnisnacht_2021_complete_all)
}
geheim_quest_templates.event_geheimnisnacht_2021_play_5_hardmode = {
	name = "quest_event_geheimnisnacht_2021_play_5_hardmode",
	icon = "quest_book_geheimnisnacht",
	desc = "quest_event_geheimnisnacht_2021_play_5_hardmode_desc",
	completed = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 83
		for i = 1, #hard_mode_levels do
			local stat_name = QuestSettings.stat_mappings[quest_key][i]

			if statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) <= 0 then
				return false
			end
		end

		return true
	end,
	progress = function (statistics_db, stats_id, quest_key, quest_templates)
		-- function 84
		local count = 0

		for i = 1, #hard_mode_levels do
			local stat_name = QuestSettings.stat_mappings[quest_key][i]

			if statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0 then
				count = count + 1
			end
		end

		return {
			count,
			5
		}
	end,
	requirements = function (statistics_db, stats_id, quest_key, quest_templates, claimed_quests)
		-- function 85
		local reqs = {}

		for i = 1, #hard_mode_levels do
			local level_id = hard_mode_levels[i]
			local stat_name = QuestSettings.stat_mappings[quest_key][i]
			local completed = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0

			reqs[i] = {
				name = LevelSettings[level_id].display_name,
				completed = completed
			}
		end

		return reqs
	end,
	events = {
		"register_completed_level"
	},
	on_event = function (statistics_db, stats_id, template_data, event_name, event_data, quest_key)
		-- function 86
		if Managers.state.game_mode:has_activated_mutator("geheimnisnacht_2021_hard_mode") then
			local stat_id = hard_mode_levels[event_data[2]]
			local stat_name = QuestSettings.stat_mappings[quest_key][stat_id]

			statistics_db:increment_stat(stats_id, "quest_statistics", stat_name)
		end
	end
}
