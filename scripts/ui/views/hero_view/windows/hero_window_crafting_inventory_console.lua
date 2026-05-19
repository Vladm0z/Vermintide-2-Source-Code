-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_crafting_inventory_console.lua

local var_0_0, var_0_1, var_0_2 = dofile("scripts/settings/crafting/crafting_recipes")
local var_0_3 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_inventory_console_definitions")
local var_0_4 = var_0_3.widgets
local var_0_5 = var_0_3.scenegraph_definition
local var_0_6 = var_0_3.animation_definitions
local var_0_7 = var_0_3.pc_filter_widgets
local var_0_8 = var_0_3.create_search_input_widget
local var_0_9 = var_0_3.create_search_filters_widget
local var_0_10 = false
local var_0_11 = "trigger_cycle_next"
local var_0_12 = "trigger_cycle_previous"

HeroWindowCraftingInventoryConsole = class(HeroWindowCraftingInventoryConsole)
HeroWindowCraftingInventoryConsole.NAME = "HeroWindowCraftingInventoryConsole"

function HeroWindowCraftingInventoryConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowCraftingInventoryConsole")

	arg_1_0.params = arg_1_1
	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.hero_name = arg_1_1.hero_name
	arg_1_0.career_index = arg_1_1.career_index
	arg_1_0.profile_index = arg_1_1.profile_index
	arg_1_1 = {
		profile_index = arg_1_0.profile_index,
		career_index = arg_1_0.career_index
	}

	arg_1_0:_setup_input_buttons()

	local var_1_2 = ItemGridUI:new(var_0_0, arg_1_0._widgets_by_name.item_grid, arg_1_0.hero_name, arg_1_0.career_index, arg_1_1)

	arg_1_0._item_grid = var_1_2

	var_1_2:mark_equipped_items(true)
	var_1_2:mark_locked_items(true)
	var_1_2:disable_locked_items(false)
	var_1_2:disable_item_drag()

	arg_1_0._inventory_sync_id = arg_1_0.parent.inventory_sync_id

	arg_1_0:_start_transition_animation("on_enter")
	arg_1_0.parent:set_inventory_grid(var_1_2)
end

function HeroWindowCraftingInventoryConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		wwise_world = arg_2_0.wwise_world,
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_5, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function HeroWindowCraftingInventoryConsole.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_5)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_4) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	local var_3_3 = var_0_8(arg_3_0)
	local var_3_4 = UIWidget.init(var_3_3)

	var_3_0[#var_3_0 + 1] = var_3_4
	var_3_1.input = var_3_4
	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	local var_3_5 = var_0_9("search_filters", arg_3_0.ui_top_renderer, arg_3_0, UISettings.inventory_filter_definitions)

	arg_3_0._filter_widget = UIWidget.init(var_3_5)

	local var_3_6 = {}
	local var_3_7 = {}

	for iter_3_2, iter_3_3 in pairs(var_0_7) do
		local var_3_8 = UIWidget.init(iter_3_3)

		var_3_6[#var_3_6 + 1] = var_3_8
		var_3_7[iter_3_2] = var_3_8
	end

	arg_3_0._pc_filter_widgets = var_3_6
	arg_3_0._pc_filter_widgets_by_name = var_3_7

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_6)

	if arg_3_2 then
		local var_3_9 = arg_3_0.ui_scenegraph.window.local_position

		var_3_9[1] = var_3_9[1] + arg_3_2[1]
		var_3_9[2] = var_3_9[2] + arg_3_2[2]
		var_3_9[3] = var_3_9[3] + arg_3_2[3]
	end

	var_3_1.item_tooltip.content.profile_index = arg_3_0.params.profile_index
	var_3_1.item_tooltip.content.career_index = arg_3_0.params.career_index

	arg_3_0:_set_input_blocked(false)
end

function HeroWindowCraftingInventoryConsole.on_exit(arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate HeroWindowCraftingInventoryConsole")

	arg_4_0.ui_animator = nil

	arg_4_0._item_grid:destroy()

	arg_4_0._item_grid = nil

	arg_4_0.parent:set_filter_selected(false)
	arg_4_0.parent:set_filter_active(false)
end

function HeroWindowCraftingInventoryConsole._input_service(arg_5_0)
	local var_5_0 = arg_5_0.parent

	if var_5_0:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return var_5_0:window_input_service()
end

function HeroWindowCraftingInventoryConsole.update(arg_6_0, arg_6_1, arg_6_2)
	if var_0_10 then
		var_0_10 = false

		arg_6_0:create_ui_elements()
	end

	arg_6_0._item_grid:update(arg_6_1, arg_6_2)
	arg_6_0:_update_filter_status()
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_handle_gamepad_input(arg_6_1, arg_6_2)
	arg_6_0:_update_inventory_items()
	arg_6_0:_update_disabled_item_icon()
	arg_6_0:_update_disabled_backend_ids()
	arg_6_0:_update_page_info()
	arg_6_0:_handle_gamepad_activity()
	arg_6_0:_update_selected_item_tooltip()
	arg_6_0:_update_filter_reset()
	arg_6_0:_handle_filer_widgets_sounds()
	arg_6_0:draw(arg_6_1)

	if arg_6_0._do_delayed_search then
		local var_6_0 = arg_6_0._filter_widget.content
		local var_6_1 = arg_6_0._widgets_by_name.input.content

		arg_6_0:_do_search(var_6_1.search_query, var_6_0.query)

		arg_6_0._do_delayed_search = false
	end
end

function HeroWindowCraftingInventoryConsole._update_filter_status(arg_7_0)
	local var_7_0, var_7_1 = arg_7_0.parent:filter_search_disabled()
	local var_7_2 = arg_7_0._widgets_by_name.input.content

	var_7_2.hotspot.disable_button = var_7_1
	var_7_2.clear_hotspot.disable_button = var_7_1
	var_7_2.search_filters_hotspot.disable_button = var_7_0
end

function HeroWindowCraftingInventoryConsole._update_filter_reset(arg_8_0, arg_8_1)
	if arg_8_0.parent:filter_reset() or arg_8_1 then
		local var_8_0 = arg_8_0._filter_widget.content

		table.clear(var_8_0.query.sort)
		table.clear(var_8_0.query.filter)

		var_8_0.query.only_new = nil

		local var_8_1 = arg_8_0._widgets_by_name.input.content

		var_8_1.search_query, var_8_1.caret_index, var_8_1.text_index = "", 1, 1

		arg_8_0:_do_search(var_8_1.search_query, var_8_0.query)
		arg_8_0:_set_filter_selected(false)
	end
end

function HeroWindowCraftingInventoryConsole.post_update(arg_9_0, arg_9_1, arg_9_2)
	return
end

function HeroWindowCraftingInventoryConsole._update_animations(arg_10_0, arg_10_1)
	arg_10_0.ui_animator:update(arg_10_1)

	local var_10_0 = arg_10_0._animations
	local var_10_1 = arg_10_0.ui_animator

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if var_10_1:is_animation_completed(iter_10_1) then
			var_10_1:stop_animation(iter_10_1)

			var_10_0[iter_10_0] = nil
		end
	end

	local var_10_2 = arg_10_0._widgets_by_name
	local var_10_3 = var_10_2.page_button_next
	local var_10_4 = var_10_2.page_button_previous

	UIWidgetUtils.animate_arrow_button(var_10_3, arg_10_1)
	UIWidgetUtils.animate_arrow_button(var_10_4, arg_10_1)
	UIWidgetUtils.animate_default_button(arg_10_0._pc_filter_widgets_by_name.apply_button, arg_10_1)
end

function HeroWindowCraftingInventoryConsole._is_button_pressed(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content
	local var_11_1 = var_11_0.button_hotspot or var_11_0.hotspot

	if var_11_1.on_release then
		var_11_1.on_release = false

		return true
	end
end

function HeroWindowCraftingInventoryConsole._is_button_hovered(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content

	if (var_12_0.button_hotspot or var_12_0.hotspot).on_hover_enter then
		return true
	end
end

function HeroWindowCraftingInventoryConsole._handle_filter_input(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not arg_13_0.parent:filter_active() then
		return false
	end

	if arg_13_1:get("toggle_menu", true) then
		arg_13_0.parent:set_filter_active(false)

		return false
	end

	local var_13_0 = arg_13_0._filter_widget.content

	if var_13_0.close_filter_hotspot.on_pressed then
		arg_13_0.parent:set_filter_active(false)

		return false
	elseif not var_13_0.area_hotspot.is_hover and arg_13_1:get("left_press", true) then
		local var_13_1 = arg_13_0._widgets_by_name.input.content

		arg_13_0:_do_search(var_13_1.search_query, var_13_0.query)
		arg_13_0.parent:set_filter_active(false)

		return false
	end

	if UIUtils.is_button_pressed(arg_13_0._pc_filter_widgets_by_name.apply_button) then
		local var_13_2 = arg_13_0._widgets_by_name.input.content

		arg_13_0:_do_search(var_13_2.search_query, var_13_0.query)
		arg_13_0.parent:set_filter_active(false)

		return false
	end
end

function HeroWindowCraftingInventoryConsole._handle_filer_widgets_sounds(arg_14_0)
	local var_14_0 = arg_14_0._filter_widget
	local var_14_1 = arg_14_0._widgets_by_name.input

	if var_14_1 and UIUtils.is_button_hover_enter(var_14_1, "search_filters_hotspot") then
		arg_14_0:_play_sound("play_gui_filter_tab_hover")
	end

	if var_14_0 then
		if UIUtils.is_button_pressed(var_14_0, "reset_filter_hotspot") then
			arg_14_0:_play_sound("play_gui_filter_reset")
		end

		local var_14_2 = {
			[1] = "rarity",
			[2] = "power_level"
		}

		for iter_14_0 = 1, #var_14_2 do
			local var_14_3 = var_14_2[iter_14_0]

			if UIUtils.is_button_hover_enter(var_14_0, "sort_items_" .. var_14_3 .. "_hotspot") then
				arg_14_0:_play_sound("play_gui_filter_sort_type_hover")
			end

			if UIUtils.is_button_pressed(var_14_0, "sort_items_" .. var_14_3 .. "_hotspot") then
				arg_14_0:_play_sound("play_gui_filter_sort_type")
			end
		end

		for iter_14_1, iter_14_2 in pairs(RaritySettings) do
			if UIUtils.is_button_hover_enter(var_14_0, iter_14_1 .. "_hotspot") then
				arg_14_0:_play_sound("play_gui_filter_rarity_hover")
			end

			if UIUtils.is_button_pressed(var_14_0, iter_14_1 .. "_hotspot") then
				arg_14_0:_play_sound("play_gui_filter_rarity_click")
			end
		end

		if UIUtils.is_button_hover_enter(var_14_0, "checkbox_hotspot") then
			arg_14_0:_play_sound("play_gui_filter_rarity_hover")
		end

		if UIUtils.is_button_pressed(var_14_0, "checkbox_hotspot") then
			arg_14_0:_play_sound("play_gui_filter_rarity_click")
		end
	end
end

function HeroWindowCraftingInventoryConsole._handle_gamepad_filter_input(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0.parent:filter_active()
	local var_15_1 = arg_15_0.parent:filter_selected()

	if var_15_0 then
		arg_15_1:get("back_menu", true)

		local var_15_2 = arg_15_0._filter_widget.content
		local var_15_3 = var_15_2.current_gamepad_index or {
			1,
			1
		}
		local var_15_4 = var_15_2.gamepad_input_matrix
		local var_15_5 = #var_15_4
		local var_15_6 = #var_15_4[var_15_3[1]]

		if arg_15_1:get("move_down_hold_continuous") then
			var_15_3[1] = math.clamp(var_15_3[1] + 1, 1, var_15_5)

			local var_15_7 = #var_15_4[var_15_3[1]]

			var_15_3[2] = math.clamp(var_15_3[2], 1, var_15_7)
		elseif arg_15_1:get("move_up_hold_continuous") then
			var_15_3[1] = math.clamp(var_15_3[1] - 1, 1, var_15_5)

			local var_15_8 = #var_15_4[var_15_3[1]]

			var_15_3[2] = math.clamp(var_15_3[2], 1, var_15_8)
		elseif arg_15_1:get("move_right_hold_continuous") then
			var_15_3[2] = math.clamp(var_15_3[2] + 1, 1, var_15_6)
		elseif arg_15_1:get("move_left_hold_continuous") then
			var_15_3[2] = math.clamp(var_15_3[2] - 1, 1, var_15_6)
		end

		if arg_15_1:get("confirm", true) then
			local var_15_9 = var_15_3[1]
			local var_15_10 = var_15_3[2]

			var_15_2[var_15_4[var_15_9][var_15_10]].gamepad_pressed = true
			arg_15_0._do_delayed_search = true
		elseif arg_15_1:get("special_1", true) then
			arg_15_0:_update_filter_reset(true)
		elseif arg_15_1:get("back", true) then
			var_15_2.current_gamepad_index[1] = 1
			var_15_2.current_gamepad_index[2] = 1

			local var_15_11 = arg_15_0._widgets_by_name.input.content

			arg_15_0:_do_search(var_15_11.search_query, var_15_2.query)
			arg_15_0.parent:set_filter_active(false)
			arg_15_0:_set_filter_selected(true)
		end
	elseif var_15_1 then
		if arg_15_0._item_grid:get_item_in_slot(1, 1) and arg_15_1:get("move_down_hold_continuous") then
			arg_15_0:_set_filter_selected(false)
		elseif arg_15_1:get("special_1", true) then
			arg_15_0:_update_filter_reset(true)
		elseif arg_15_1:get("confirm") then
			arg_15_0.parent:set_filter_active(true)
			arg_15_0.parent:set_filter_selected(false)
		end
	elseif not arg_15_0.parent:filter_search_disabled() and arg_15_0._item_grid:get_selected_item_grid_slot() == 1 and arg_15_1:get("move_up_hold_continuous") then
		arg_15_0:_set_filter_selected(true)

		return true
	end

	return var_15_0 or var_15_1
end

function HeroWindowCraftingInventoryConsole.filter_selected(arg_16_0)
	return arg_16_0.parent:filter_selected()
end

function HeroWindowCraftingInventoryConsole.filter_active(arg_17_0)
	return arg_17_0.parent:filter_active()
end

function HeroWindowCraftingInventoryConsole._set_filter_selected(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._item_grid
	local var_18_1 = Managers.input:is_device_active("gamepad")

	if arg_18_1 then
		var_18_0:set_item_selected(nil)
	elseif var_18_1 then
		local var_18_2 = var_18_0:get_item_in_slot(1, 1)

		var_18_0:set_item_selected(var_18_2)
	end

	arg_18_0.parent:set_filter_selected(arg_18_1)
end

function HeroWindowCraftingInventoryConsole._handle_input(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0:_input_service()

	if not Managers.input:is_device_active("gamepad") then
		if arg_19_0:_handle_search_input(arg_19_1, arg_19_2) then
			return
		end

		if arg_19_0:_handle_filter_input(var_19_0, arg_19_1, arg_19_2) then
			return
		end

		local var_19_1 = arg_19_0._widgets_by_name
		local var_19_2 = arg_19_0.parent
		local var_19_3 = arg_19_0._item_grid
		local var_19_4 = false
		local var_19_5 = var_19_3:is_item_pressed(var_19_4)

		if var_19_3:is_item_hovered() then
			arg_19_0:_play_sound("play_gui_inventory_item_hover")
		end

		if arg_19_0._pressed_backend_id and var_19_2:get_pressed_item_backend_id() == arg_19_0._pressed_backend_id then
			var_19_2:set_pressed_item_backend_id(nil)

			arg_19_0._pressed_backend_id = nil
		end

		if var_19_5 then
			local var_19_6 = var_19_5.backend_id

			arg_19_0._pressed_backend_id = var_19_6

			local var_19_7 = false

			var_19_2:set_pressed_item_backend_id(var_19_6, var_19_7)
		end

		local var_19_8 = var_19_1.page_button_next
		local var_19_9 = var_19_1.page_button_previous

		if arg_19_0:_is_button_hovered(var_19_8) or arg_19_0:_is_button_hovered(var_19_9) then
			arg_19_0:_play_sound("play_gui_inventory_next_hover")
		end

		if arg_19_0:_is_button_pressed(var_19_8) then
			local var_19_10 = arg_19_0._current_page + 1

			var_19_3:set_item_page(var_19_10)
			arg_19_0:_play_sound("play_gui_craft_inventory_next")
		elseif arg_19_0:_is_button_pressed(var_19_9) then
			local var_19_11 = arg_19_0._current_page - 1

			var_19_3:set_item_page(var_19_11)
			arg_19_0:_play_sound("play_gui_craft_inventory_next")
		end
	end

	arg_19_0:_handle_recipe_inputs(arg_19_1, arg_19_2)
end

function HeroWindowCraftingInventoryConsole._handle_gamepad_input(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0.parent
	local var_20_1 = arg_20_0:_input_service()
	local var_20_2 = arg_20_0._item_grid

	if Managers.input:is_device_active("mouse") or arg_20_0.parent.parent:input_blocked() then
		return
	end

	if IS_CONSOLE and arg_20_0:_handle_search_input(arg_20_1, arg_20_2) then
		return
	end

	if arg_20_0:_handle_gamepad_filter_input(var_20_1, arg_20_1, arg_20_2) then
		return
	end

	if var_20_1:get("confirm", true) then
		local var_20_3 = var_20_2:selected_item()

		if var_20_3 then
			local var_20_4 = var_20_3.backend_id

			arg_20_0._pressed_backend_id = var_20_4

			local var_20_5 = false

			var_20_0:set_pressed_item_backend_id(var_20_4, var_20_5)
		end
	elseif arg_20_0._pressed_backend_id and var_20_0:get_pressed_item_backend_id() == arg_20_0._pressed_backend_id then
		var_20_0:set_pressed_item_backend_id(nil)

		arg_20_0._pressed_backend_id = nil
	elseif var_20_2:handle_gamepad_selection(var_20_1) then
		arg_20_0:_play_sound("play_gui_craft_forge_hover")
	end

	local var_20_6 = arg_20_0._current_page
	local var_20_7 = arg_20_0._total_pages

	if var_20_6 and var_20_7 then
		if var_20_6 < var_20_7 and var_20_1:get(var_0_11) then
			var_20_2:set_item_page(var_20_6 + 1)
			arg_20_0:_play_sound("play_gui_craft_inventory_next")

			local var_20_8 = var_20_2:get_item_in_slot(1, 1)

			var_20_2:set_item_selected(var_20_8)
		elseif var_20_6 > 1 and var_20_1:get(var_0_12) then
			var_20_2:set_item_page(var_20_6 - 1)
			arg_20_0:_play_sound("play_gui_craft_inventory_next")

			local var_20_9 = var_20_2:get_item_in_slot(1, 1)

			var_20_2:set_item_selected(var_20_9)
		end
	end
end

function HeroWindowCraftingInventoryConsole._set_input_blocked(arg_21_0, arg_21_1)
	local var_21_0 = Managers.input

	if arg_21_1 then
		var_21_0:block_device_except_service("hero_view", "keyboard", 1, "search")
		var_21_0:block_device_except_service("hero_view", "mouse", 1, "search")
		var_21_0:block_device_except_service("hero_view", "gamepad", 1, "search")
	else
		var_21_0:device_unblock_all_services("keyboard")
		var_21_0:device_unblock_all_services("mouse")
		var_21_0:device_unblock_all_services("gamepad")
		var_21_0:block_device_except_service("hero_view", "keyboard", 1)
		var_21_0:block_device_except_service("hero_view", "mouse", 1)
		var_21_0:block_device_except_service("hero_view", "gamepad", 1)
	end

	arg_21_0.parent.parent:set_input_blocked(arg_21_1)
end

function HeroWindowCraftingInventoryConsole._handle_search_input(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = Managers.input:is_device_active("gamepad")
	local var_22_1 = arg_22_0:_input_service()
	local var_22_2 = arg_22_0._widgets_by_name.input.content

	if not var_22_0 then
		if var_22_2.clear_hotspot.on_pressed then
			var_22_2.search_query, var_22_2.caret_index, var_22_2.text_index = "", 1, 1

			arg_22_0:_do_search(var_22_2.search_query)

			return true
		elseif var_22_2.search_filters_hotspot.on_pressed then
			arg_22_0:_play_sound("play_gui_filter_tab_click")

			var_22_2.input_active = false
			arg_22_0._keyboard_id = nil

			arg_22_0:_set_input_blocked(false)
			arg_22_0.parent:set_filter_active(true)

			return true
		end
	end

	if not arg_22_0._keyboard_id then
		var_22_2.input_active = false

		local var_22_3 = arg_22_0.parent:filter_selected()
		local var_22_4 = var_22_0 and var_22_3 and var_22_1:get("refresh") and not IS_WINDOWS

		if var_22_2.hotspot.on_pressed or var_22_4 then
			var_22_2.input_active = true

			if IS_WINDOWS then
				arg_22_0:_set_input_blocked(true)

				arg_22_0._keyboard_id = true
			elseif IS_XB1 then
				local var_22_5 = Localize("lb_search")

				XboxInterface.show_virtual_keyboard(arg_22_0._search_query, var_22_5)

				arg_22_0._keyboard_id = true
			elseif IS_PS4 then
				local var_22_6 = Managers.account:user_id()
				local var_22_7 = Localize("lb_search")
				local var_22_8 = var_0_3.virtual_keyboard_anchor_point

				arg_22_0._keyboard_id = Managers.system_dialog:open_virtual_keyboard(var_22_6, var_22_7, arg_22_0._search_query, var_22_8)
			end

			return true
		end

		return false
	end

	local var_22_9 = Managers.input:is_device_active("gamepad")

	Managers.chat:block_chat_input_for_one_frame()

	if IS_WINDOWS then
		local var_22_10 = Keyboard.keystrokes()

		var_22_2.search_query, var_22_2.caret_index = KeystrokeHelper.parse_strokes(var_22_2.search_query, var_22_2.caret_index, "insert", var_22_10)

		if var_22_1:get("execute_chat_input", true) then
			arg_22_0:_do_search(var_22_2.search_query)

			var_22_2.input_active = false
			arg_22_0._keyboard_id = nil

			arg_22_0:_set_input_blocked(false)
		elseif var_22_1:get("toggle_menu", true) then
			var_22_2.input_active = false
			arg_22_0._keyboard_id = nil

			arg_22_0:_set_input_blocked(false)
		end
	elseif IS_XB1 then
		if not XboxInterface.interface_active() then
			local var_22_11 = XboxInterface.get_keyboard_result()

			var_22_2.caret_index = var_22_9 and 1 or #var_22_11

			arg_22_0:_do_search(var_22_11)

			arg_22_0._keyboard_id = nil

			local var_22_12 = arg_22_0._item_grid:get_item_in_slot(1, 1)

			arg_22_0:_set_filter_selected(var_22_12 == nil)
		end
	elseif IS_PS4 then
		local var_22_13, var_22_14, var_22_15 = Managers.system_dialog:poll_virtual_keyboard(arg_22_0._keyboard_id)

		if var_22_13 then
			if var_22_14 then
				var_22_2.caret_index = var_22_9 and 1 or #var_22_15

				arg_22_0:_do_search(var_22_15)
			end

			arg_22_0._keyboard_id = nil

			local var_22_16 = arg_22_0._item_grid:get_item_in_slot(1, 1)

			arg_22_0:_set_filter_selected(var_22_16 == nil)
		end
	end

	if var_22_2.hotspot.on_pressed then
		return true
	end

	return arg_22_0._keyboard_id
end

local var_0_13 = {}

function HeroWindowCraftingInventoryConsole._do_search(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0._search_query = arg_23_1
	arg_23_0._filter_query = arg_23_2 or arg_23_0._filter_query or var_0_13
	arg_23_0._widgets_by_name.input.content.search_query = arg_23_1

	local var_23_0 = var_0_1[arg_23_0._selected_craft_page_name]
	local var_23_1 = var_23_0.item_filter
	local var_23_2 = var_23_0.hero_specific_filter
	local var_23_3 = var_23_0.career_specific_filter

	if var_23_2 then
		local var_23_4 = var_23_1 and "and " .. var_23_1 or ""

		var_23_1 = "can_wield_by_current_hero " .. var_23_4
	end

	if arg_23_0._filter_query.filter then
		for iter_23_0, iter_23_1 in pairs(arg_23_0._filter_query.filter) do
			if iter_23_1 then
				var_23_1 = var_23_1 .. " and not is_" .. iter_23_0
			end
		end
	end

	if arg_23_0._filter_query.only_new then
		var_23_1 = var_23_1 .. " and is_new"
	end

	arg_23_0:change_item_filter(var_23_1, true, arg_23_1)

	if arg_23_0._filter_query.sort then
		local var_23_5

		for iter_23_2, iter_23_3 in pairs(arg_23_0._filter_query.sort) do
			local var_23_6 = iter_23_2 .. "_" .. iter_23_3

			var_23_5 = UIUtils[var_23_6]

			break
		end

		local var_23_7 = arg_23_0._item_grid:items()

		if var_23_5 and #var_23_7 > 1 then
			table.sort(var_23_7, var_23_5)
		end

		arg_23_0._item_grid:set_item_page(1)
	end

	arg_23_0:_play_sound("Play_hud_select")
end

function HeroWindowCraftingInventoryConsole._handle_recipe_inputs(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0:_input_service()
	local var_24_1 = var_0_1[arg_24_0._selected_craft_page_name]

	if var_24_1 and var_24_1.input_func then
		var_24_1.input_func(arg_24_0, var_24_0)
	end
end

function HeroWindowCraftingInventoryConsole._update_page_info(arg_25_0)
	local var_25_0, var_25_1 = arg_25_0._item_grid:get_page_info()

	if var_25_0 ~= arg_25_0._current_page or var_25_1 ~= arg_25_0._total_pages then
		arg_25_0._total_pages = var_25_1
		arg_25_0._current_page = var_25_0
		var_25_0 = var_25_0 or 1
		var_25_1 = var_25_1 or 1

		local var_25_2 = arg_25_0._widgets_by_name

		var_25_2.page_text_left.content.text = tostring(var_25_0)
		var_25_2.page_text_right.content.text = tostring(var_25_1)
		var_25_2.page_button_next.content.hotspot.disable_button = var_25_0 == var_25_1
		var_25_2.page_button_previous.content.hotspot.disable_button = var_25_0 == 1
	end
end

function HeroWindowCraftingInventoryConsole._update_crafting_material_panel(arg_26_0)
	local var_26_0 = Managers.backend:get_interface("items")
	local var_26_1 = UISettings.crafting_material_icons_small
	local var_26_2 = UISettings.crafting_material_order
	local var_26_3 = arg_26_0._widgets_by_name
	local var_26_4 = 1

	for iter_26_0, iter_26_1 in ipairs(var_26_2) do
		local var_26_5 = var_26_1[iter_26_1]
		local var_26_6 = "item_key == " .. iter_26_1
		local var_26_7 = var_26_0:get_filtered_items(var_26_6)
		local var_26_8 = var_26_7 and var_26_7[1]
		local var_26_9 = var_26_8 and var_26_8.backend_id
		local var_26_10 = var_26_9 and var_26_0:get_item_amount(var_26_9) or 0
		local var_26_11 = var_26_3["material_text_" .. iter_26_0].content
		local var_26_12

		if var_26_10 < 10000 then
			var_26_12 = tostring(var_26_10)
		elseif var_26_10 < 100000 then
			var_26_12 = string.format("%.1fk", var_26_10 * 0.001)
		else
			var_26_12 = "+99k"
		end

		var_26_11.text = var_26_12
		var_26_11.icon = var_26_5

		if not var_26_11.item then
			var_26_11.item = var_26_8 or {
				data = table.clone(ItemMasterList[iter_26_1])
			}
		end
	end
end

function HeroWindowCraftingInventoryConsole._update_inventory_items(arg_27_0)
	local var_27_0 = arg_27_0._item_grid
	local var_27_1 = arg_27_0.parent
	local var_27_2 = var_27_1.inventory_sync_id
	local var_27_3 = var_27_1:get_selected_craft_page()
	local var_27_4 = var_27_1:get_craft_optional_item_filter()

	if var_27_2 ~= arg_27_0._inventory_sync_id or var_27_3 ~= arg_27_0._selected_craft_page_name or arg_27_0._optional_craft_item_filter ~= var_27_4 then
		if var_27_3 ~= arg_27_0._selected_craft_page_name then
			arg_27_0._selected_craft_page_name = var_27_3

			arg_27_0:_change_category_by_name(var_27_3)
		elseif var_27_4 then
			arg_27_0:change_item_filter(var_27_4, true)
			arg_27_0:_handle_gamepad_activity(true)
			arg_27_0:_update_selected_item_tooltip(true)
		else
			arg_27_0:_change_category_by_index(nil, true)
		end

		arg_27_0._inventory_sync_id = var_27_2
		arg_27_0._optional_craft_item_filter = var_27_4

		arg_27_0:_update_crafting_material_panel()
	end
end

function HeroWindowCraftingInventoryConsole._update_disabled_item_icon(arg_28_0)
	local var_28_0 = arg_28_0._item_grid
	local var_28_1 = arg_28_0.parent:disabled_item_icon()

	if var_28_1 ~= arg_28_0._disabled_item_icon then
		arg_28_0._disabled_item_icon = var_28_1

		var_28_0:set_locked_items_icon(var_28_1)
	end
end

function HeroWindowCraftingInventoryConsole._update_disabled_backend_ids(arg_29_0)
	local var_29_0 = arg_29_0._item_grid
	local var_29_1 = arg_29_0.parent.disabled_backend_ids_sync_id

	if var_29_1 ~= arg_29_0._disabled_backend_ids_sync_id then
		arg_29_0._disabled_backend_ids_sync_id = var_29_1

		var_29_0:clear_locked_items()

		local var_29_2 = arg_29_0.parent:get_disabled_backend_ids()

		for iter_29_0, iter_29_1 in pairs(var_29_2) do
			var_29_0:lock_item_by_id(iter_29_0, true)
		end

		var_29_0:update_items_status()
	end
end

function HeroWindowCraftingInventoryConsole._exit(arg_30_0, arg_30_1)
	arg_30_0.exit = true
	arg_30_0.exit_level_id = arg_30_1
end

function HeroWindowCraftingInventoryConsole.draw(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.ui_renderer
	local var_31_1 = arg_31_0.ui_top_renderer
	local var_31_2 = arg_31_0.ui_scenegraph
	local var_31_3 = arg_31_0:_input_service()
	local var_31_4 = Managers.input:is_device_active("gamepad")
	local var_31_5 = arg_31_0.parent:filter_active()

	if var_31_5 then
		UIRenderer.begin_pass(var_31_1, var_31_2, var_31_3, arg_31_1, nil, arg_31_0.render_settings)
		UIRenderer.draw_widget(var_31_1, arg_31_0._filter_widget)

		if not var_31_4 then
			for iter_31_0, iter_31_1 in ipairs(arg_31_0._pc_filter_widgets) do
				UIRenderer.draw_widget(var_31_1, iter_31_1)
			end
		end

		UIRenderer.end_pass(var_31_1)
	end

	var_31_3 = var_31_5 and FAKE_INPUT_SERVICE or var_31_3

	UIRenderer.begin_pass(var_31_1, var_31_2, var_31_3, arg_31_1, nil, arg_31_0.render_settings)

	for iter_31_2, iter_31_3 in ipairs(arg_31_0._widgets) do
		UIRenderer.draw_widget(var_31_1, iter_31_3)
	end

	UIRenderer.end_pass(var_31_1)
end

function HeroWindowCraftingInventoryConsole._play_sound(arg_32_0, arg_32_1)
	arg_32_0.parent:play_sound(arg_32_1)
end

function HeroWindowCraftingInventoryConsole._change_category_by_name(arg_33_0, arg_33_1)
	for iter_33_0, iter_33_1 in ipairs(var_0_0) do
		if iter_33_1.name == arg_33_1 then
			arg_33_0:_change_category_by_index(iter_33_0)

			break
		end
	end
end

function HeroWindowCraftingInventoryConsole._change_category_by_index(arg_34_0, arg_34_1, arg_34_2)
	if arg_34_2 then
		arg_34_1 = arg_34_0._current_category_index or 1
	end

	if arg_34_0._current_category_index == arg_34_1 and not arg_34_2 then
		return
	end

	arg_34_0._current_category_index = arg_34_1

	local var_34_0 = arg_34_0._item_grid
	local var_34_1 = var_0_0[arg_34_1]
	local var_34_2 = var_34_1.name
	local var_34_3 = var_34_1.item_sort_func

	if var_34_3 then
		var_34_0:apply_item_sorting_function(var_34_3)
	end

	var_34_0:change_category(var_34_2, arg_34_2)

	local var_34_4 = arg_34_0._filter_widget
	local var_34_5 = arg_34_0._widgets_by_name.input
	local var_34_6 = var_34_4.content
	local var_34_7 = var_34_5.content.search_query
	local var_34_8 = var_34_6.query

	if var_34_7 ~= "" or not table.is_empty(var_34_8.sort) or not table.is_empty(var_34_8.filter) or var_34_8.only_new then
		arg_34_0:_do_search(var_34_7, var_34_8)
	end

	arg_34_0:_handle_gamepad_activity(true)
	arg_34_0:_update_selected_item_tooltip(true)

	return true
end

function HeroWindowCraftingInventoryConsole.change_item_filter(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_2 = arg_35_2 or arg_35_2 == nil

	arg_35_0._item_grid:change_item_filter(arg_35_1, arg_35_2, arg_35_3)
end

function HeroWindowCraftingInventoryConsole._update_selected_item_tooltip(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._item_grid:selected_item()
	local var_36_1 = var_36_0 and var_36_0.backend_id

	if var_36_1 ~= arg_36_0._selected_backend_id or arg_36_1 then
		arg_36_0._widgets_by_name.item_tooltip.content.item = var_36_0
	end

	arg_36_0._selected_backend_id = var_36_1
end

function HeroWindowCraftingInventoryConsole._setup_input_buttons(arg_37_0)
	local var_37_0 = arg_37_0.parent:window_input_service()
	local var_37_1 = UISettings.get_gamepad_input_texture_data(var_37_0, var_0_11, true)
	local var_37_2 = UISettings.get_gamepad_input_texture_data(var_37_0, var_0_12, true)
	local var_37_3 = arg_37_0._widgets_by_name
	local var_37_4 = var_37_3.input_icon_next
	local var_37_5 = var_37_3.input_icon_previous
	local var_37_6 = var_37_4.style.texture_id

	var_37_6.horizontal_alignment = "center"
	var_37_6.vertical_alignment = "center"
	var_37_6.texture_size = {
		var_37_1.size[1],
		var_37_1.size[2]
	}
	var_37_4.content.texture_id = var_37_1.texture

	local var_37_7 = var_37_5.style.texture_id

	var_37_7.horizontal_alignment = "center"
	var_37_7.vertical_alignment = "center"
	var_37_7.texture_size = {
		var_37_2.size[1],
		var_37_2.size[2]
	}
	var_37_5.content.texture_id = var_37_2.texture
end

function HeroWindowCraftingInventoryConsole._set_gamepad_input_buttons_visibility(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._widgets_by_name
	local var_38_1 = var_38_0.input_icon_next
	local var_38_2 = var_38_0.input_icon_previous
	local var_38_3 = var_38_0.input_arrow_next
	local var_38_4 = var_38_0.input_arrow_previous

	var_38_1.content.visible = arg_38_1
	var_38_2.content.visible = arg_38_1
	var_38_3.content.visible = arg_38_1
	var_38_4.content.visible = arg_38_1
end

function HeroWindowCraftingInventoryConsole._handle_gamepad_activity(arg_39_0, arg_39_1)
	if arg_39_0.parent.parent:input_blocked() then
		return
	end

	local var_39_0 = Managers.input:is_device_active("mouse")

	arg_39_1 = arg_39_1 or arg_39_0.gamepad_active_last_frame == nil

	if not var_39_0 then
		if not arg_39_0.gamepad_active_last_frame or arg_39_1 then
			arg_39_0.gamepad_active_last_frame = true

			local var_39_1 = arg_39_0._item_grid
			local var_39_2
			local var_39_3 = var_39_1:selected_item()

			if var_39_3 and var_39_1:has_item(var_39_3) then
				var_39_2 = var_39_3.backend_id
			else
				local var_39_4 = var_39_1:get_item_in_slot(1, 1)

				var_39_2 = var_39_4 and var_39_4.backend_id
			end

			if var_39_2 then
				var_39_1:set_backend_id_selected(var_39_2)
			else
				var_39_1:set_item_selected(nil)
			end

			arg_39_0:_set_gamepad_input_buttons_visibility(true)
		end
	elseif arg_39_0.gamepad_active_last_frame or arg_39_1 then
		arg_39_0.gamepad_active_last_frame = false

		arg_39_0._item_grid:set_item_selected(nil)
		arg_39_0:_set_gamepad_input_buttons_visibility(false)
	end
end
