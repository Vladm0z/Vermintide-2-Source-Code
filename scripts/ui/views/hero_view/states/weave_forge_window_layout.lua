-- chunkname: @scripts/ui/views/hero_view/states/weave_forge_window_layout.lua

local var_0_0 = {
	overview = {
		alignment_index = 2,
		name = "overview",
		class_name = "HeroWindowWeaveForgeOverview"
	},
	weapon_select = {
		alignment_index = 2,
		name = "weapon_select",
		class_name = "HeroWindowWeaveForgeWeapons"
	},
	properties = {
		alignment_index = 2,
		name = "properties",
		class_name = "HeroWindowWeaveProperties"
	},
	background = {
		alignment_index = 2,
		name = "background",
		class_name = "HeroWindowWeaveForgeBackground"
	},
	panel = {
		alignment_index = 2,
		name = "panel",
		class_name = "HeroWindowWeaveForgePanel"
	}
}
local var_0_1 = {
	{
		sound_event_enter = "menu_magic_forge_overview_menu",
		name = "weave_overview",
		sound_event_exit = "play_gui_equipment_close",
		close_on_exit = true,
		windows = {
			overview = 2,
			panel = 3,
			background = 1
		}
	},
	{
		sound_event_enter = "menu_magic_forge_enter_weapon_switch_menu",
		name = "weave_weapon_select",
		sound_event_exit = "play_gui_equipment_close",
		close_on_exit = false,
		windows = {
			weapon_select = 2,
			panel = 3,
			background = 1
		}
	},
	{
		close_on_exit = false,
		name = "weave_properties",
		sound_event_exit = "play_gui_equipment_close",
		windows = {
			properties = 2,
			panel = 3,
			background = 1
		}
	}
}
local var_0_2 = 5

return {
	max_active_windows = var_0_2,
	windows = var_0_0,
	window_layouts = var_0_1
}
