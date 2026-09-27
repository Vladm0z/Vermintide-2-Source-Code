-- chunkname: @scripts/managers/quest/quest_outline.lua

local tbl = {
	quest_type = "daily",
	name = "achv_menu_daily_category_title",
	type = "quest",
	max_entry_amount = 3,
	entries = {}
}
local tbl_2 = {
	quest_type = "weekly",
	name = "achv_menu_weekly_category_title",
	type = "quest",
	max_entry_amount = 7,
	entries = {}
}
local tbl_3 = {
	quest_type = "event",
	name = "achv_menu_event_category_title",
	type = "quest",
	max_entry_amount = 1,
	entries = {}
}

return {
	name = "achv_menu_quests_category_title",
	type = "quest",
	categories = {
		tbl,
		tbl_2,
		tbl_3
	}
}
