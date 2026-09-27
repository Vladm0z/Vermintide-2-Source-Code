-- chunkname: @scripts/ui/views/hero_view/states/hero_window_layout_console.lua

local tbl = {
	panel = {
		ignore_alignment = true,
		name = "panel",
		class_name = "HeroWindowPanelConsole"
	},
	background = {
		ignore_alignment = true,
		name = "background",
		class_name = "HeroWindowBackgroundConsole"
	},
	crafting_inventory = {
		ignore_alignment = true,
		name = "crafting_inventory",
		class_name = "HeroWindowCraftingInventoryConsole"
	},
	loadout_inventory = {
		ignore_alignment = true,
		name = "loadout_inventory",
		class_name = "HeroWindowLoadoutInventoryConsole"
	},
	loadout = {
		ignore_alignment = true,
		name = "loadout",
		class_name = "HeroWindowLoadoutConsole"
	},
	talents = {
		ignore_alignment = true,
		name = "talents",
		class_name = "HeroWindowTalentsConsole"
	},
	crafting = {
		ignore_alignment = true,
		name = "crafting",
		class_name = "HeroWindowCraftingConsole"
	},
	prestige = {
		ignore_alignment = true,
		name = "prestige",
		class_name = "HeroWindowPrestige"
	},
	cosmetics_loadout = {
		ignore_alignment = true,
		name = "cosmetics_loadout",
		class_name = "HeroWindowCosmeticsLoadoutConsole"
	},
	cosmetics_inventory = {
		ignore_alignment = true,
		name = "cosmetics_inventory",
		class_name = "HeroWindowCosmeticsLoadoutInventoryConsole"
	},
	pose_inventory = {
		ignore_alignment = true,
		name = "pose_inventory",
		class_name = "HeroWindowCosmeticsLoadoutPoseInventoryConsole"
	},
	character_info = {
		ignore_alignment = true,
		name = "character_info",
		class_name = "HeroWindowCharacterInfo"
	},
	crafting_list = {
		ignore_alignment = true,
		name = "crafting_list",
		class_name = "HeroWindowCraftingListConsole"
	},
	hero_power = {
		ignore_alignment = true,
		name = "hero_power",
		class_name = "HeroWindowHeroPowerConsole"
	},
	loadout_selection = {
		ignore_alignment = true,
		name = "loadout_selection",
		class_name = "HeroWindowLoadoutSelectionConsole"
	},
	ingame_view = {
		ignore_alignment = true,
		name = "ingame_view",
		class_name = "HeroWindowIngameView"
	},
	character_selection = {
		ignore_alignment = true,
		name = "character_selection",
		class_name = "HeroWindowCharacterSelectionConsole"
	},
	item_customization = {
		ignore_alignment = true,
		name = "item_customization",
		class_name = "HeroWindowItemCustomization"
	},
	dark_pact_character_selection = {
		ignore_alignment = true,
		name = "dark_pact_character_selection",
		class_name = "HeroWindowDarkPactCharacterSelectionConsole"
	}
}
local tbl_2 = {
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "equipment",
		sound_event_exit = "play_gui_equipment_close",
		close_on_exit = true,
		windows = {
			hero_power = 5,
			loadout_selection = 6,
			background = 2,
			character_info = 3,
			panel = 1,
			loadout = 4
		}
	},
	{
		sound_event_enter = "play_gui_talents_button",
		name = "talents",
		sound_event_exit = "play_gui_talents_close",
		close_on_exit = true,
		windows = {
			loadout_selection = 5,
			background = 2,
			character_info = 3,
			panel = 1,
			talents = 4
		}
	},
	{
		sound_event_enter = "play_gui_craft_button",
		name = "forge",
		sound_event_exit = "play_gui_craft_close",
		close_on_exit = true,
		windows = {
			character_info = 4,
			panel = 1,
			background = 2,
			crafting_list = 3
		},
		can_add_function = function (arg_1_0)
			-- function 1
			return arg_1_0 == "versus" or arg_1_0 ~= "inn_vs"
		end
	},
	{
		sound_event_enter = "play_gui_cosmetics_button",
		name = "cosmetics",
		sound_event_exit = "play_gui_cosmetics_close",
		close_on_exit = true,
		windows = {
			hero_power = 5,
			cosmetics_loadout = 3,
			background = 2,
			loadout_selection = 6,
			character_info = 4,
			panel = 1
		}
	},
	{
		sound_event_enter = "play_gui_craft_button",
		name = "crafting_recipe",
		sound_event_exit = "play_gui_craft_close",
		input_focus_window = "crafting",
		close_on_exit = false,
		windows = {
			crafting_inventory = 4,
			background = 2,
			character_info = 5,
			panel = 1,
			crafting = 3
		}
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "equipment_selection",
		sound_event_exit = "play_gui_equipment_close",
		input_focus_window = "loadout_inventory",
		close_on_exit = false,
		windows = {
			hero_power = 5,
			background = 2,
			character_info = 3,
			panel = 1,
			loadout_inventory = 4
		}
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "cosmetics_selection",
		sound_event_exit = "play_gui_equipment_close",
		input_focus_window = "cosmetics_inventory",
		close_on_exit = false,
		windows = {
			hero_power = 5,
			cosmetics_inventory = 4,
			background = 2,
			character_info = 3,
			panel = 1
		}
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "cosmetics_selection_dark_pact",
		sound_event_exit = "play_gui_equipment_close",
		input_focus_window = "cosmetics_inventory",
		close_on_exit = false,
		windows = {
			character_info = 3,
			panel = 1,
			background = 2,
			cosmetics_inventory = 4
		}
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "pose_selection",
		sound_event_exit = "play_gui_equipment_close",
		input_focus_window = "pose_inventory",
		close_on_exit = false,
		windows = {
			pose_inventory = 4,
			hero_power = 5,
			background = 2,
			character_info = 3,
			panel = 1
		}
	},
	{
		sound_event_enter = "Play_hud_button_open",
		name = "system",
		sound_event_exit = "Play_hud_button_close",
		close_on_exit = true,
		windows = {
			character_info = 3,
			panel = 1,
			background = 2,
			ingame_view = 4
		}
	},
	{
		sound_event_enter = "Play_hud_button_open",
		name = "store",
		sound_event_exit = "Play_hud_button_close",
		close_on_exit = true,
		windows = {
			background = 1
		}
	},
	{
		sound_event_enter = "Play_hud_button_open",
		name = "character_selection",
		sound_event_exit = "Play_hud_button_close",
		close_on_exit = false,
		windows = {
			character_selection = 3,
			panel = 1,
			background = 2
		}
	},
	{
		sound_event_enter = "Play_hud_button_open",
		name = "item_customization",
		sound_event_exit = "Play_hud_button_close",
		close_on_exit = false,
		windows = {
			character_info = 3,
			panel = 1,
			background = 2,
			item_customization = 4
		}
	},
	{
		sound_event_enter = "Play_hud_button_open",
		name = "pactsworn_equipment",
		sound_event_exit = "Play_hud_button_close",
		close_on_exit = true,
		windows = {
			dark_pact_character_selection = 3,
			panel = 1,
			background = 2
		},
		can_add_function = function (arg_2_0)
			-- function 2
			return arg_2_0 == "versus"
		end,
		on_exit = function (self)
			-- function 3
			local local_player = Managers.player:local_player()
			local profile_index = local_player:profile_index()
			local career_index = local_player:career_index()

			self:change_profile(profile_index, career_index)

			local var_3_3 = SPProfiles[profile_index]

			Managers.state.event:trigger("respawn_hero", {
				hero_name = var_3_3.display_name,
				career_index = career_index
			})

			local carousel = DLCSettings.carousel

			carousel = not carousel and DLCSettings.carousel.hero_window_mood_settings

			local default = carousel.default

			default = default or "default"

			self:set_background_mood(default)
		end
	}
}
local num = 6

DLCUtils.map("hero_view_window_layout_console", function (self)
	-- function 4
	local windows = self.windows

	if not windows then
		for k, v in pairs(windows) do
			tbl[k] = v
		end
	end

	local window_layouts = self.window_layouts

	if not window_layouts then
		for k_2 = 1, #window_layouts do
			tbl_2[#tbl_2 + 1] = window_layouts[k_2]
		end
	end
end)
DLCUtils.map("hero_view_window_layout_console", function (self)
	-- function 5
	local windows = self.windows

	if not windows then
		for k, v in pairs(windows) do
			tbl[k] = v
		end
	end

	local window_layouts = self.window_layouts

	if not window_layouts then
		for k_2 = 1, #window_layouts do
			tbl_2[#tbl_2 + 1] = window_layouts[k_2]
		end
	end
end)

return {
	max_active_windows = num,
	windows = tbl,
	window_layouts = tbl_2
}
