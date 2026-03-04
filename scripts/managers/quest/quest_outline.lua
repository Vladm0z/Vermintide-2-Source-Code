-- chunkname: @scripts/managers/quest/quest_outline.lua

local var_0_0 = {
	quest_type = "daily",
	name = "achv_menu_daily_category_title",
	type = "quest",
	max_entry_amount = 3,
	entries = {}
}
local var_0_1 = {
	quest_type = "weekly",
	name = "achv_menu_weekly_category_title",
	type = "quest",
	max_entry_amount = 7,
	entries = {}
}
local var_0_2 = {
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
		var_0_0,
		var_0_1,
		var_0_2
	}
}
