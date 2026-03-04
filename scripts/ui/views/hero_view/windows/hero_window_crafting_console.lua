-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_crafting_console.lua

require("scripts/ui/views/hero_view/craft_pages/craft_page_salvage_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_roll_trait_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_roll_properties_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_craft_item_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_apply_skin_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_upgrade_item_console")
require("scripts/ui/views/hero_view/craft_pages/craft_page_convert_dust_console")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_console_definitions")
local var_0_1, var_0_2, var_0_3 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_4 = var_0_0.widgets
local var_0_5 = var_0_0.category_settings
local var_0_6 = var_0_0.scenegraph_definition
local var_0_7 = var_0_0.animation_definitions
local var_0_8 = var_0_0.generic_input_actions
local var_0_9 = var_0_0.input_actions
local var_0_10 = false
local var_0_11 = {
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "salvage",
		class_name = "CraftPageSalvageConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "craft_random_item",
		class_name = "CraftPageCraftItemConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "reroll_weapon_properties",
		class_name = "CraftPageRollPropertiesConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "reroll_weapon_traits",
		class_name = "CraftPageRollTraitConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "upgrade_item_rarity_common",
		class_name = "CraftPageUpgradeItemConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "apply_weapon_skin",
		class_name = "CraftPageApplySkinConsole",
		sound_event_exit = "play_gui_equipment_close"
	},
	{
		sound_event_enter = "play_gui_equipment_button",
		name = "convert_blue_dust",
		class_name = "CraftPageConvertDustConsole",
		sound_event_exit = "play_gui_equipment_close"
	}
}

HeroWindowCraftingConsole = class(HeroWindowCraftingConsole)
HeroWindowCraftingConsole.NAME = "HeroWindowCraftingConsole"

HeroWindowCraftingConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCraftingConsole")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.crafting_manager = Managers.state.crafting
	arg_1_0.wwise_world = arg_1_1.wwise_world

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_set_crafting_glow_progress(0)

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.profile_index = arg_1_1.profile_index
	arg_1_0._page_params = {
		wwise_world = arg_1_0.wwise_world,
		ingame_ui_context = var_1_0,
		parent = arg_1_0,
		hero_name = arg_1_0.hero_name,
		career_index = arg_1_0.career_index,
		profile_index = arg_1_0.profile_index
	}
	arg_1_0.unblocked_services = {}
	arg_1_0.unblocked_services_n = 0

	local var_1_2 = arg_1_1.recipe_index or 1

	arg_1_0:_change_recipe_page(var_1_2)
	arg_1_0:_start_transition_animation("on_enter")
	arg_1_0:_start_transition_animation("reset_crafting")
end

HeroWindowCraftingConsole._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = arg_2_0._widgets_by_name
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_6, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

HeroWindowCraftingConsole.create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_6)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_4) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	local var_3_3 = Managers.input:get_service("hero_view")
	local var_3_4 = UILayer.default + 300

	arg_3_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_3_0.ui_top_renderer, var_3_3, 7, var_3_4, var_0_8.default, true)

	arg_3_0._menu_input_description:set_input_description(nil)
	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_7)

	if arg_3_2 then
		local var_3_5 = arg_3_0.ui_scenegraph.window.local_position

		var_3_5[1] = var_3_5[1] + arg_3_2[1]
		var_3_5[2] = var_3_5[2] + arg_3_2[2]
		var_3_5[3] = var_3_5[3] + arg_3_2[3]
	end
end

HeroWindowCraftingConsole.on_exit = function (arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCraftingConsole")

	arg_4_0.ui_animator = nil

	if arg_4_0._active_page then
		local var_4_0 = arg_4_0._page_params

		arg_4_0._active_page:on_exit(var_4_0)
	end
end

HeroWindowCraftingConsole.set_input_description = function (arg_5_0, arg_5_1)
	if not arg_5_1 or var_0_9[arg_5_1] then
		arg_5_0._current_input_desc_name = arg_5_1

		if not arg_5_0.parent:filter_selected() then
			arg_5_0._menu_input_description:set_input_description(arg_5_1 and var_0_9[arg_5_1])
		end
	else
		Application.warning("[HeroWindowCraftingConsole:set_input_description] Could not set input desc: " .. tostring(arg_5_1))
	end
end

HeroWindowCraftingConsole.update = function (arg_6_0, arg_6_1, arg_6_2)
	if var_0_10 then
		var_0_10 = false

		arg_6_0:create_ui_elements()
	end

	local var_6_0 = arg_6_0._current_craft_id
	local var_6_1 = arg_6_0._animations

	if var_6_0 then
		local var_6_2 = Managers.backend:get_interface("crafting")

		if var_6_2:is_craft_complete(var_6_0) then
			local var_6_3 = var_6_2:get_craft_result(var_6_0)

			arg_6_0:craft_complete(var_6_3)

			arg_6_0._current_craft_id = nil
		end
	end

	if arg_6_0._can_start_craft_exit_animation and not var_6_1.craft_enter then
		arg_6_0:_start_transition_animation("craft_exit")

		arg_6_0._can_start_craft_exit_animation = nil

		if arg_6_0._active_page then
			arg_6_0._active_page:on_craft_completed()
		end
	end

	if arg_6_0._active_page then
		arg_6_0._active_page:update(arg_6_1, arg_6_2)
	end

	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_update_input_desc()
	arg_6_0:draw(arg_6_1)
end

HeroWindowCraftingConsole._update_input_desc = function (arg_7_0)
	local var_7_0 = arg_7_0.parent:filter_selected()
	local var_7_1 = arg_7_0.parent:filter_active()

	if var_7_0 == arg_7_0._filter_selected and var_7_1 == arg_7_0._filter_active then
		return
	end

	arg_7_0._menu_input_description:set_input_description(nil)

	if var_7_0 then
		arg_7_0._menu_input_description:change_generic_actions(var_0_8.filter_selected)
	elseif var_7_1 then
		arg_7_0._menu_input_description:change_generic_actions(var_0_8.filter_active)
	else
		local var_7_2 = arg_7_0._current_input_desc_name

		arg_7_0._menu_input_description:change_generic_actions(var_0_8.default)
		arg_7_0._menu_input_description:set_input_description(var_7_2 and var_0_9[var_7_2])
	end

	arg_7_0._filter_selected = var_7_0
end

HeroWindowCraftingConsole.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	if arg_8_0._active_page and arg_8_0._active_page.post_update then
		arg_8_0._active_page:post_update(arg_8_1, arg_8_2)
	end
end

HeroWindowCraftingConsole._update_animations = function (arg_9_0, arg_9_1)
	arg_9_0.ui_animator:update(arg_9_1)

	local var_9_0 = arg_9_0._animations
	local var_9_1 = arg_9_0.ui_animator

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if var_9_1:is_animation_completed(iter_9_1) then
			var_9_1:stop_animation(iter_9_1)

			var_9_0[iter_9_0] = nil

			if iter_9_0 == "craft_exit" then
				arg_9_0:on_craft_ended()
			end
		end
	end
end

HeroWindowCraftingConsole._is_button_pressed = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.on_release then
		var_10_0.on_release = false

		return true
	end
end

HeroWindowCraftingConsole._is_button_hovered = function (arg_11_0, arg_11_1)
	if arg_11_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

HeroWindowCraftingConsole._is_button_held = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	if var_12_0.is_clicked then
		return var_12_0.is_clicked
	end
end

HeroWindowCraftingConsole.set_focus = function (arg_13_0, arg_13_1)
	arg_13_0._focused = arg_13_1
end

HeroWindowCraftingConsole._handle_input = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.parent:window_input_service()
	local var_14_1 = arg_14_0.parent:filter_active()

	if var_14_0:get("back") and not var_14_1 then
		arg_14_0.parent:set_layout_by_name("forge")
	end

	arg_14_0:_handle_tooltip_skip_input(var_14_0)
end

HeroWindowCraftingConsole._exit = function (arg_15_0, arg_15_1)
	arg_15_0.exit = true
	arg_15_0.exit_level_id = arg_15_1
end

HeroWindowCraftingConsole.draw = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.ui_renderer
	local var_16_1 = arg_16_0.ui_top_renderer
	local var_16_2 = arg_16_0.ui_scenegraph
	local var_16_3 = arg_16_0.parent:window_input_service()
	local var_16_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_16_1, var_16_2, var_16_3, arg_16_1, nil, arg_16_0.render_settings)

	for iter_16_0, iter_16_1 in ipairs(arg_16_0._widgets) do
		UIRenderer.draw_widget(var_16_1, iter_16_1)
	end

	local var_16_5 = arg_16_0._active_node_widgets

	if var_16_5 then
		for iter_16_2, iter_16_3 in ipairs(var_16_5) do
			UIRenderer.draw_widget(var_16_1, iter_16_3)
		end
	end

	UIRenderer.end_pass(var_16_1)

	if var_16_4 then
		arg_16_0._menu_input_description:draw(var_16_1, arg_16_1)
	end
end

HeroWindowCraftingConsole._play_sound = function (arg_17_0, arg_17_1)
	arg_17_0.parent:play_sound(arg_17_1)
end

HeroWindowCraftingConsole._change_recipe_page = function (arg_18_0, arg_18_1)
	local var_18_0 = #var_0_11
	local var_18_1 = var_0_11[arg_18_1].name
	local var_18_2 = var_0_2[var_18_1]
	local var_18_3 = var_18_2.ingredients
	local var_18_4 = arg_18_0._widgets_by_name

	var_18_4.title_text.content.text = Localize(var_18_2.display_name)
	var_18_4.description_text.content.text = Localize(var_18_2.description_text)

	if arg_18_1 ~= arg_18_0._current_page or var_18_0 ~= arg_18_0._total_pages then
		arg_18_0._total_pages = var_18_0
		arg_18_0._current_page = arg_18_1
		arg_18_1 = arg_18_1 or 1

		arg_18_0:_set_page_index(arg_18_1)
	end

	arg_18_0._selected_page_index = arg_18_1
end

HeroWindowCraftingConsole.window_input_service = function (arg_19_0)
	return
end

HeroWindowCraftingConsole._set_page_index = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._active_page
	local var_20_1 = arg_20_0._page_params
	local var_20_2 = var_0_11[arg_20_1]
	local var_20_3 = var_20_2.name
	local var_20_4 = var_20_2.class_name

	if var_20_0 then
		if var_20_0.NAME == var_20_4 then
			return
		end

		if var_20_0.on_exit then
			var_20_0:on_exit(var_20_1)
		end
	end

	local var_20_5 = rawget(_G, var_20_4):new()

	arg_20_0.parent:set_selected_craft_page(var_20_3)

	if var_20_5.on_enter then
		var_20_5:on_enter(var_20_1, var_20_2)
	end

	arg_20_0._active_page = var_20_5
end

HeroWindowCraftingConsole._set_crafting_glow_progress = function (arg_21_0, arg_21_1)
	arg_21_0._widgets_by_name.crafting_glow.style.texture_id.color[1] = 255 * arg_21_1
end

HeroWindowCraftingConsole.on_craft_ended = function (arg_22_0)
	local var_22_0 = arg_22_0._active_page

	if var_22_0 and var_22_0.present_results then
		var_22_0:present_results()
	end

	arg_22_0:unlock_input()
end

HeroWindowCraftingConsole.craft = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.crafting_manager:craft(arg_23_1, arg_23_2)

	if var_23_0 then
		arg_23_0._waiting_for_craft = true

		arg_23_0:_start_transition_animation("craft_enter")
		arg_23_0:lock_input()

		arg_23_0._current_craft_id = var_23_0

		return true
	end

	return false
end

HeroWindowCraftingConsole.craft_complete = function (arg_24_0, arg_24_1)
	arg_24_0._waiting_for_craft = false
	arg_24_0._can_start_craft_exit_animation = true

	if arg_24_0._active_page then
		arg_24_0._active_page:craft_result(arg_24_1)
	end
end

HeroWindowCraftingConsole.waiting_for_craft = function (arg_25_0)
	return arg_25_0._waiting_for_craft
end

HeroWindowCraftingConsole.lock_input = function (arg_26_0)
	local var_26_0 = arg_26_0.input_manager

	arg_26_0:unlock_input(true)

	arg_26_0.unblocked_services_n = var_26_0:get_unblocked_services(nil, nil, arg_26_0.unblocked_services)

	var_26_0:device_block_services("keyboard", 1, arg_26_0.unblocked_services, arg_26_0.unblocked_services_n, "crafting")
	var_26_0:device_block_services("gamepad", 1, arg_26_0.unblocked_services, arg_26_0.unblocked_services_n, "crafting")
	var_26_0:device_block_services("mouse", 1, arg_26_0.unblocked_services, arg_26_0.unblocked_services_n, "crafting")
end

HeroWindowCraftingConsole.unlock_input = function (arg_27_0)
	local var_27_0 = arg_27_0.input_manager

	var_27_0:device_unblock_services("keyboard", 1, arg_27_0.unblocked_services, arg_27_0.unblocked_services_n)
	var_27_0:device_unblock_services("gamepad", 1, arg_27_0.unblocked_services, arg_27_0.unblocked_services_n)
	var_27_0:device_unblock_services("mouse", 1, arg_27_0.unblocked_services, arg_27_0.unblocked_services_n)
	table.clear(arg_27_0.unblocked_services)

	arg_27_0.unblocked_services_n = 0
end

HeroWindowCraftingConsole._set_input_progress = function (arg_28_0, arg_28_1)
	local var_28_0 = 43
	local var_28_1 = 360 - var_28_0 * 2
	local var_28_2 = 255 * math.min(arg_28_1 * 2, 1)
	local var_28_3 = (var_28_0 + var_28_1 * arg_28_1) / 360
	local var_28_4 = -math.degrees_to_radians(var_28_0 + var_28_1 * arg_28_1)
	local var_28_5 = arg_28_0._widgets_by_name.craft_bar

	var_28_5.style.texture_id.gradient_threshold = var_28_3
	var_28_5.style.texture_id.color[1] = 255

	if arg_28_1 == 1 then
		return true
	end
end

HeroWindowCraftingConsole.set_reward_tooltip_item = function (arg_29_0, arg_29_1)
	arg_29_0._widgets_by_name.item_tooltip.content.item = arg_29_1
	arg_29_0._tooltip_item_id = arg_29_1
end

HeroWindowCraftingConsole.has_active_reward_tooltip = function (arg_30_0)
	return arg_30_0._tooltip_item_id
end

local var_0_12 = {
	"confirm_press",
	"refresh_press",
	"special_1_press",
	"back_menu",
	"move_up",
	"move_down",
	"move_left",
	"move_right"
}

HeroWindowCraftingConsole._handle_tooltip_skip_input = function (arg_31_0, arg_31_1)
	if arg_31_0:has_active_reward_tooltip() then
		local var_31_0 = false

		for iter_31_0, iter_31_1 in ipairs(var_0_12) do
			if arg_31_1:get(iter_31_1) then
				var_31_0 = true

				break
			end
		end

		if var_31_0 then
			arg_31_0:set_reward_tooltip_item(nil)
		end
	end
end
