-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_handbook.lua

require("scripts/ui/helpers/handbook_logic")
require("scripts/settings/handbook_settings")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_handbook_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.achievement_window_size
local var_0_5 = var_0_0.category_tab_info
local var_0_6 = var_0_0.generic_input_actions
local var_0_7 = var_0_0.console_cursor_definition
local var_0_8 = var_0_4[2]

HeroViewStateHandbook = class(HeroViewStateHandbook)
HeroViewStateHandbook.NAME = "HeroViewStateHandbook"

function HeroViewStateHandbook.on_enter(arg_1_0, arg_1_1)
	print("[HeroViewState] Enter Substate HeroViewStateHandbook")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._render_settings = {
		snap_pixel_positions = false
	}
	arg_1_0._voting_manager = var_1_0.voting_manager
	SaveData.seen_handbook_pages = SaveData.seen_handbook_pages or {}

	local var_1_1 = arg_1_0:input_service()

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(var_1_0, arg_1_0._ui_top_renderer, var_1_1, 5, 100, var_0_6.default)

	arg_1_0._menu_input_description:set_input_description(nil)

	arg_1_0._current_page = 1
	arg_1_0._total_pages = 1

	arg_1_0:play_sound("Play_gui_handbook_open")
	Managers.input:enable_gamepad_cursor()
	arg_1_0:_create_ui_elements(arg_1_1)

	if arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		arg_1_0:_start_transition_animation("on_enter", "on_enter")
	end
end

function HeroViewStateHandbook.on_exit(arg_2_0, arg_2_1)
	print("[HeroViewState] Exit Substate HeroViewStateHandbook")
	arg_2_0._handbook_logic:delete()
	Managers.input:disable_gamepad_cursor()
end

function HeroViewStateHandbook._create_ui_elements(arg_3_0)
	local var_3_0 = #HandbookSettings.outline
	local var_3_1 = var_0_0.create_category_tab_widgets_func(var_3_0)

	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_3_0._console_cursor_widget = UIWidget.init(var_0_7)
	arg_3_0._widgets, arg_3_0._widgets_by_name = UIUtils.create_widgets(var_0_1)
	arg_3_0._category_tab_widgets = UIUtils.create_widgets(var_3_1)

	for iter_3_0, iter_3_1 in pairs(arg_3_0._category_tab_widgets) do
		arg_3_0:_reset_tab(iter_3_1)
	end

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_3)
	arg_3_0._category_scrollbar = ScrollBarLogic:new(arg_3_0._widgets_by_name.category_scrollbar)

	local var_3_2 = {
		scenegraph_id = "achievement_root",
		ui_renderer = arg_3_0._ui_renderer,
		world = arg_3_0._ingame_ui_context.world
	}

	arg_3_0._handbook_logic = HandbookLogic:new(var_3_2, var_0_0.content_blueprints)

	arg_3_0:_setup_layout()

	arg_3_0._widgets_by_name.achievement_scrollbar.content.visible = true
	arg_3_0._widgets_by_name.category_scrollbar.content.visible = true

	arg_3_0:_update_categories_scroll_height(0)

	local var_3_3 = arg_3_0._category_tab_widgets[1]

	arg_3_0:_activate_tab(var_3_3, 1, 1, true)
end

function HeroViewStateHandbook._reset_tabs(arg_4_0)
	for iter_4_0, iter_4_1 in ipairs(arg_4_0._category_tab_widgets) do
		arg_4_0:_reset_tab(iter_4_1)
	end
end

function HeroViewStateHandbook._setup_layout(arg_5_0)
	local var_5_0 = arg_5_0._category_tab_widgets
	local var_5_1 = #var_5_0
	local var_5_2 = HandbookSettings.outline

	for iter_5_0 = 1, var_5_1 do
		local var_5_3 = var_5_0[iter_5_0]

		arg_5_0:_reset_tab(var_5_3)

		local var_5_4 = var_5_2[iter_5_0]

		if var_5_4 then
			arg_5_0:_setup_tab_widget(var_5_3, var_5_4)
		end
	end
end

function HeroViewStateHandbook._setup_tab_widget(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.children
	local var_6_1 = arg_6_1.content

	var_6_1.title_text = Localize(arg_6_2.display_name)
	var_6_1.children = arg_6_2.children
	var_6_1.new = false

	if var_6_0 then
		local var_6_2 = var_6_1.list_content
		local var_6_3 = var_0_5.tab_list_entry_size
		local var_6_4 = #var_6_0

		var_6_1.tabs_height = var_6_3[2] * var_6_4

		for iter_6_0 = 1, var_6_4 do
			local var_6_5 = var_6_0[iter_6_0]
			local var_6_6 = var_6_5[1]
			local var_6_7 = HandbookSettings.pages[var_6_6]
			local var_6_8 = not SaveData.seen_handbook_pages[var_6_6]

			if var_6_8 then
				var_6_1.new = true
			end

			local var_6_9 = var_6_2[iter_6_0]

			var_6_9.text = Localize(var_6_7.display_name)
			var_6_9.new = var_6_8
			var_6_9.pages = var_6_5
		end

		arg_6_1.style.list_style.num_draws = var_6_4
	end

	arg_6_1.content.visible = true
end

function HeroViewStateHandbook._reset_tab(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content
	local var_7_1 = arg_7_1.style.list_style

	var_7_0.active = false
	var_7_0.list_content.active = false
	var_7_0.button_hotspot.is_selected = false
	var_7_0.visible = false
	var_7_0.new = false
	var_7_1.num_draws = 0

	local var_7_2 = var_7_1.scenegraph_id

	arg_7_0._ui_scenegraph[var_7_2].size[2] = 0
	arg_7_1.alpha_multiplier = 0
	arg_7_1.alpha_fade_in_delay = nil
	arg_7_1.alpha_fade_multipler = 5
end

function HeroViewStateHandbook._update_categories_scroll_height(arg_8_0, arg_8_1)
	local var_8_0 = var_0_2.category_window_mask.size
	local var_8_1 = var_0_2.category_scrollbar.size
	local var_8_2 = arg_8_0._category_scrollbar
	local var_8_3 = var_8_0[2]
	local var_8_4 = arg_8_0:_get_category_entries_height()
	local var_8_5 = var_8_1[2]
	local var_8_6 = 220
	local var_8_7 = 1

	var_8_2:set_scrollbar_values(var_8_3, var_8_4, var_8_5, var_8_6, var_8_7)

	if arg_8_1 then
		var_8_2:set_scroll_percentage(arg_8_1)
	end
end

function HeroViewStateHandbook._get_category_entries_height(arg_9_0)
	local var_9_0 = #arg_9_0._category_tab_widgets
	local var_9_1 = var_0_5.tab_size
	local var_9_2 = var_0_5.tab_list_entry_spacing

	return math.max(var_9_1[2] * var_9_0 + var_9_2 * (var_9_0 - 1), 0) + arg_9_0:_get_active_tabs_height()
end

function HeroViewStateHandbook._get_active_tabs_height(arg_10_0)
	local var_10_0 = arg_10_0._active_tab
	local var_10_1 = var_10_0 and var_10_0.style.list_style.num_draws or 0
	local var_10_2 = var_0_5.tab_list_entry_size
	local var_10_3 = var_0_5.tab_list_entry_spacing

	return (math.max(var_10_2[2] * var_10_1 + var_10_3 * (var_10_1 - 1), 0))
end

function HeroViewStateHandbook._get_active_category_height(arg_11_0)
	local var_11_0 = (arg_11_0._active_tab_index or 1) - 1
	local var_11_1 = var_0_5.tab_size
	local var_11_2 = var_0_5.tab_list_entry_spacing
	local var_11_3 = math.max(var_11_1[2] * var_11_0 + var_11_2 * (var_11_0 - 1), 0)
	local var_11_4 = arg_11_0:_get_active_tabs_height()

	return var_11_3, var_11_1[2] + var_11_2 + var_11_4
end

function HeroViewStateHandbook._setup_scrollbar(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._widgets_by_name.achievement_scrollbar
	local var_12_1 = var_12_0.scenegraph_id
	local var_12_2 = arg_12_0._ui_scenegraph[var_12_1].size[2]
	local var_12_3 = math.min(var_12_2 / arg_12_1, 1)

	var_12_0.content.scroll_bar_info.bar_height_percentage = var_12_3

	arg_12_0:_set_scrollbar_value(arg_12_2 or 0)

	local var_12_4 = 2
	local var_12_5 = math.max(110 / arg_12_0._total_scroll_height, 0) * var_12_4

	arg_12_0._widgets_by_name.achievement_window.content.scroll_amount = var_12_5
end

function HeroViewStateHandbook._update_mouse_scroll_input(arg_13_0)
	local var_13_0 = true

	if var_13_0 then
		local var_13_1 = arg_13_0._widgets_by_name
		local var_13_2 = var_13_1.achievement_scrollbar
		local var_13_3 = var_13_1.achievement_window

		if var_13_2.content.scroll_bar_info.on_pressed then
			var_13_3.content.scroll_add = nil
		end

		local var_13_4 = var_13_3.content.scroll_value

		if not var_13_4 then
			return
		end

		local var_13_5 = var_13_2.content.scroll_bar_info.value
		local var_13_6 = arg_13_0._scroll_value

		if var_13_6 ~= var_13_4 then
			arg_13_0:_set_scrollbar_value(var_13_4)
		elseif var_13_6 ~= var_13_5 then
			arg_13_0:_set_scrollbar_value(var_13_5)
		end
	end
end

function HeroViewStateHandbook._set_scrollbar_value(arg_14_0, arg_14_1)
	if arg_14_1 then
		local var_14_0 = arg_14_0._widgets_by_name

		var_14_0.achievement_scrollbar.content.scroll_bar_info.value = arg_14_1
		var_14_0.achievement_window.content.scroll_value = arg_14_1

		local var_14_1 = arg_14_0._total_scroll_height * arg_14_1

		arg_14_0._ui_scenegraph.achievement_root.position[2] = math.floor(var_14_1)
		arg_14_0._scroll_value = arg_14_1
	end
end

function HeroViewStateHandbook._update_achievement_read_index(arg_15_0, arg_15_1)
	return
end

function HeroViewStateHandbook._update_category_scroll_position(arg_16_0)
	local var_16_0 = arg_16_0._category_scrollbar:get_scrolled_length()

	if var_16_0 ~= arg_16_0._category_scrolled_length then
		arg_16_0._ui_scenegraph.category_root.local_position[2] = math.round(var_16_0)
		arg_16_0._category_scrolled_length = var_16_0
	end
end

function HeroViewStateHandbook._setup_achievement_entries_animations(arg_17_0)
	local var_17_0 = 0.05
	local var_17_1 = 0
	local var_17_2 = 4
	local var_17_3 = arg_17_0._achievement_widgets

	for iter_17_0, iter_17_1 in ipairs(var_17_3) do
		iter_17_1.alpha_multiplier = 0
		iter_17_1.alpha_fade_in_delay = var_17_1
		iter_17_1.alpha_fade_multipler = var_17_2
		var_17_1 = var_17_1 + var_17_0
	end
end

function HeroViewStateHandbook.transitioning(arg_18_0)
	return not not arg_18_0._exiting
end

function HeroViewStateHandbook._update_transition_timer(arg_19_0, arg_19_1)
	if not arg_19_0._transition_timer then
		return
	end

	if arg_19_0._transition_timer == 0 then
		arg_19_0._transition_timer = nil
	else
		arg_19_0._transition_timer = math.max(arg_19_0._transition_timer - arg_19_1, 0)
	end
end

function HeroViewStateHandbook.input_service(arg_20_0)
	return arg_20_0.parent:input_service()
end

function HeroViewStateHandbook.update(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._input_blocked and FAKE_INPUT_SERVICE or arg_21_0:input_service()
	local var_21_1 = Managers.input:is_device_active("gamepad")

	arg_21_0._ui_animator:update(arg_21_1)

	local var_21_2 = arg_21_0._widgets_by_name.exit_button

	UIWidgetUtils.animate_default_button(var_21_2, arg_21_1)

	local var_21_3 = arg_21_0.parent
	local var_21_4 = var_21_3:transitioning()
	local var_21_5 = var_21_3:wanted_state()

	if not arg_21_0._transition_timer then
		if not var_21_4 then
			if arg_21_0:_has_active_level_vote() then
				local var_21_6 = true

				arg_21_0:close_menu(var_21_6)
			else
				arg_21_0:_handle_input(var_21_0, var_21_1, arg_21_1, arg_21_2)
			end
		end

		local var_21_7 = var_21_5 or arg_21_0._new_state

		if var_21_7 then
			var_21_3:clear_wanted_state()

			return var_21_7
		end
	end

	if arg_21_0._exiting then
		return
	end

	arg_21_0:draw(var_21_0, var_21_1, arg_21_1)
end

function HeroViewStateHandbook._has_active_level_vote(arg_22_0)
	local var_22_0 = arg_22_0._voting_manager

	return var_22_0:vote_in_progress() and var_22_0:is_mission_vote() and not var_22_0:has_voted(Network.peer_id())
end

function HeroViewStateHandbook._handle_input(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = arg_23_0._widgets_by_name
	local var_23_1 = var_23_0.exit_button
	local var_23_2 = arg_23_1:get("toggle_menu")
	local var_23_3 = arg_23_2 and arg_23_1:get("back")

	if var_23_2 or UIUtils.is_button_pressed(var_23_1) or var_23_3 then
		arg_23_0:play_sound("Play_hud_hover")
		arg_23_0:close_menu()

		arg_23_0._exiting = true

		return
	end

	if UIUtils.is_button_hover_enter(var_23_1) then
		arg_23_0:play_sound("play_gui_equipment_button_hover")
	end

	arg_23_0._category_scrollbar:update(arg_23_3, arg_23_4, false)
	arg_23_0:_update_category_scroll_position()

	for iter_23_0, iter_23_1 in ipairs(arg_23_0._category_tab_widgets) do
		if iter_23_1.content.visible then
			UIWidgetUtils.animate_default_button(iter_23_1, arg_23_3)

			if UIUtils.is_button_hover_enter(iter_23_1) then
				arg_23_0:play_sound("Play_gui_achivements_menu_hover_category")
			end

			if UIUtils.is_button_pressed(iter_23_1) then
				arg_23_0:_tab_pressed(iter_23_1, iter_23_0)
			end
		end
	end

	local var_23_4 = arg_23_0._active_tab

	if var_23_4 then
		local var_23_5 = var_23_4.content.list_content
		local var_23_6 = var_23_4.style.list_style.num_draws
		local var_23_7 = arg_23_0._active_list_index

		for iter_23_2 = 1, var_23_6 do
			local var_23_8 = var_23_5[iter_23_2]
			local var_23_9 = var_23_8.button_hotspot or var_23_8.hotspot

			if var_23_9.on_hover_enter then
				arg_23_0:play_sound("Play_gui_achivements_menu_hover_category")
			end

			if var_23_9.on_release then
				var_23_9.on_release = false

				arg_23_0:_on_tab_list_pressed(iter_23_2, var_23_8, var_23_8.pages)
			end

			var_23_9.is_selected = var_23_7 == iter_23_2
		end
	end

	if arg_23_0._achievement_widgets then
		arg_23_0:_update_mouse_scroll_input()
	end

	local var_23_10 = var_23_0.page_button_next
	local var_23_11 = var_23_0.page_button_previous

	arg_23_0:_set_gamepad_input_buttons_visibility(arg_23_2)
	UIWidgetUtils.animate_arrow_button(var_23_10, arg_23_3)
	UIWidgetUtils.animate_arrow_button(var_23_11, arg_23_3)

	if UIUtils.is_button_hover_enter(var_23_10) or UIUtils.is_button_hover_enter(var_23_11) then
		arg_23_0:play_sound("play_gui_inventory_next_hover")
	end

	if UIUtils.is_button_pressed(var_23_10) or arg_23_1:get("cycle_next") then
		local var_23_12 = arg_23_0._current_page + 1

		if var_23_12 <= arg_23_0._total_pages then
			arg_23_0:_go_to_page(var_23_12)
			arg_23_0:play_sound("play_gui_cosmetics_inventory_next_click")
		end
	elseif UIUtils.is_button_pressed(var_23_11) or arg_23_1:get("cycle_previous") then
		local var_23_13 = arg_23_0._current_page - 1

		if var_23_13 >= 1 then
			arg_23_0:_go_to_page(var_23_13)
			arg_23_0:play_sound("play_gui_cosmetics_inventory_next_click")
		end
	end
end

function HeroViewStateHandbook._go_to_page(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._active_pages[arg_24_1]
	local var_24_1 = HandbookSettings.pages[var_24_0]

	if not var_24_1 then
		return
	end

	local var_24_2, var_24_3 = arg_24_0._handbook_logic:create_entry_widgets(var_24_1)
	local var_24_4 = var_24_3 + 150

	arg_24_0._achievement_widgets = var_24_2
	arg_24_0._total_scroll_height = math.max(var_24_4 - var_0_8, 0)
	arg_24_0._scroll_value = nil

	arg_24_0:_setup_scrollbar(var_24_4)
	arg_24_0:_setup_achievement_entries_animations()

	arg_24_0._current_page = arg_24_1

	arg_24_0:_update_page_info()
end

function HeroViewStateHandbook._on_tab_list_pressed(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	if arg_25_1 == arg_25_0._active_list_index then
		return
	end

	arg_25_0._active_pages = arg_25_3
	arg_25_0._active_list_index = arg_25_1
	arg_25_0._total_pages = #arg_25_3

	arg_25_0:_go_to_page(1)

	if arg_25_2.new then
		arg_25_2.new = false

		local var_25_0 = arg_25_3[1]

		SaveData.seen_handbook_pages[var_25_0] = true

		local var_25_1 = false

		for iter_25_0, iter_25_1 in ipairs(arg_25_2.parent.list_content) do
			if iter_25_1.new then
				var_25_1 = true

				break
			end
		end

		arg_25_2.parent.new = var_25_1
	end

	if not arg_25_4 then
		arg_25_0:play_sound("Play_gui_handbook_click")
	end
end

function HeroViewStateHandbook._tab_pressed(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = arg_26_0._active_tab == arg_26_1

	arg_26_0:_deactivate_active_tab()

	if not var_26_0 then
		arg_26_0:_activate_tab(arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	end
end

function HeroViewStateHandbook._activate_tab(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	arg_27_0._active_tab = arg_27_1
	arg_27_0._active_tab_index = arg_27_2

	local var_27_0 = arg_27_1.content
	local var_27_1 = arg_27_1.style.list_style
	local var_27_2 = var_27_1.num_draws
	local var_27_3 = var_27_1.scenegraph_id
	local var_27_4 = arg_27_0._ui_scenegraph[var_27_3]
	local var_27_5 = var_0_5.tab_active_size
	local var_27_6 = var_0_5.tab_list_entry_size
	local var_27_7 = var_0_5.tab_list_entry_spacing
	local var_27_8 = math.max(var_27_6[2] * var_27_2 + var_27_7 * (var_27_2 - 1), 0)

	var_27_4.size[1] = var_27_5[1]
	var_27_4.size[2] = var_27_8
	var_27_0.button_hotspot.is_selected = true
	var_27_0.active = true
	var_27_0.list_content.active = true
	arg_27_0._active_list_index = nil
	arg_27_3 = arg_27_3 or 1

	if arg_27_3 then
		local var_27_9 = var_27_0.children[arg_27_3]
		local var_27_10 = var_27_0.list_content[arg_27_3]

		var_27_10.parent = var_27_0

		arg_27_0:_on_tab_list_pressed(arg_27_3, var_27_10, var_27_9, true)

		if not arg_27_4 then
			arg_27_0:play_sound("Play_gui_achivements_menu_select_category")
		end
	else
		arg_27_0._active_list_index = nil

		if not arg_27_4 then
			arg_27_0:play_sound("Play_gui_achivements_menu_expand_category")
		end
	end

	arg_27_0:_update_categories_scroll_height()
end

function HeroViewStateHandbook._deactivate_active_tab(arg_28_0)
	local var_28_0 = arg_28_0._active_tab

	if not var_28_0 then
		return
	end

	arg_28_0._active_tab = nil
	arg_28_0._active_tab_index = nil

	local var_28_1 = var_28_0.content
	local var_28_2 = var_28_0.style.list_style.scenegraph_id
	local var_28_3 = arg_28_0._ui_scenegraph[var_28_2]
	local var_28_4 = var_0_5.tab_size

	var_28_3.size[1] = var_28_4[1]
	var_28_3.size[2] = 0
	var_28_1.active = false
	var_28_1.list_content.active = false
	var_28_1.button_hotspot.is_selected = false
end

function HeroViewStateHandbook.close_menu(arg_29_0, arg_29_1)
	if not arg_29_1 then
		arg_29_0:play_sound("Play_gui_achivements_menu_close")
	end

	arg_29_1 = true

	local var_29_0 = true

	arg_29_0.parent:close_menu(nil, arg_29_1, var_29_0)
end

function HeroViewStateHandbook._update_page_info(arg_30_0)
	local var_30_0 = arg_30_0._widgets_by_name
	local var_30_1 = arg_30_0._current_page
	local var_30_2 = arg_30_0._total_pages

	var_30_0.page_text_left.content.text = tostring(var_30_1)
	var_30_0.page_text_right.content.text = tostring(var_30_2)
	var_30_0.page_button_next.content.hotspot.disable_button = var_30_1 == var_30_2
	var_30_0.page_button_previous.content.hotspot.disable_button = var_30_1 == 1

	local var_30_3 = var_30_2 > 1

	var_30_0.page_button_next.content.visible = var_30_3
	var_30_0.page_button_previous.content.visible = var_30_3
	var_30_0.input_icon_next.content.visible = var_30_3
	var_30_0.input_icon_previous.content.visible = var_30_3
	var_30_0.input_arrow_next.content.visible = var_30_3
	var_30_0.input_arrow_previous.content.visible = var_30_3
	var_30_0.page_text_center.content.visible = var_30_3
	var_30_0.page_text_left.content.visible = var_30_3
	var_30_0.page_text_right.content.visible = var_30_3
	var_30_0.page_text_area.content.visible = var_30_3

	arg_30_0._menu_input_description:set_input_description(var_30_3 and var_0_6.has_pages or nil)
end

function HeroViewStateHandbook._set_gamepad_input_buttons_visibility(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._widgets_by_name
	local var_31_1 = arg_31_0._total_pages > 1

	arg_31_1 = arg_31_1 and var_31_1

	local var_31_2 = var_31_0.input_icon_next
	local var_31_3 = var_31_0.input_icon_previous
	local var_31_4 = var_31_0.input_arrow_next
	local var_31_5 = var_31_0.input_arrow_previous

	var_31_2.content.visible = arg_31_1
	var_31_3.content.visible = arg_31_1
	var_31_4.content.visible = arg_31_1
	var_31_5.content.visible = arg_31_1
end

function HeroViewStateHandbook.draw(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = arg_32_0._ui_renderer
	local var_32_1 = arg_32_0._ui_top_renderer
	local var_32_2 = arg_32_0._ui_scenegraph
	local var_32_3 = arg_32_0._render_settings

	UIRenderer.begin_pass(var_32_0, var_32_2, arg_32_1, arg_32_3, nil, var_32_3)

	local var_32_4 = var_32_3.snap_pixel_positions
	local var_32_5 = var_32_3.alpha_multiplier or 1

	for iter_32_0, iter_32_1 in ipairs(arg_32_0._widgets) do
		if iter_32_1.snap_pixel_positions ~= nil then
			var_32_3.snap_pixel_positions = iter_32_1.snap_pixel_positions
		end

		var_32_3.alpha_multiplier = iter_32_1.alpha_multiplier or var_32_5

		UIRenderer.draw_widget(var_32_0, iter_32_1)

		var_32_3.snap_pixel_positions = var_32_4
	end

	local var_32_6 = arg_32_0._achievement_widgets

	if var_32_6 then
		for iter_32_2 = 1, #var_32_6 do
			local var_32_7 = var_32_6[iter_32_2]

			if var_32_7.snap_pixel_positions ~= nil then
				var_32_3.snap_pixel_positions = var_32_7.snap_pixel_positions
			end

			local var_32_8 = var_32_7.alpha_multiplier
			local var_32_9 = var_32_7.alpha_fade_in_delay

			if var_32_9 then
				local var_32_10 = math.max(var_32_9 - arg_32_3, 0)

				if var_32_10 > 0 then
					var_32_7.alpha_fade_in_delay = var_32_10
				else
					var_32_7.alpha_fade_in_delay = nil
				end

				var_32_3.alpha_multiplier = 0
			elseif var_32_8 then
				local var_32_11 = var_32_7.alpha_fade_multipler or 1
				local var_32_12 = math.min(var_32_8 + arg_32_3 * var_32_11, 1)

				var_32_3.alpha_multiplier = math.easeInCubic(var_32_12)
				var_32_7.alpha_multiplier = var_32_12
				var_32_7.offset[1] = -40 * (1 - var_32_12)
			end

			UIRenderer.draw_widget(var_32_0, var_32_7)

			var_32_3.snap_pixel_positions = var_32_4
		end
	end

	for iter_32_3, iter_32_4 in ipairs(arg_32_0._category_tab_widgets) do
		if iter_32_4.snap_pixel_positions ~= nil then
			var_32_3.snap_pixel_positions = iter_32_4.snap_pixel_positions
		end

		local var_32_13 = iter_32_4.alpha_multiplier
		local var_32_14 = iter_32_4.alpha_fade_in_delay

		if var_32_14 then
			local var_32_15 = math.max(var_32_14 - arg_32_3, 0)

			if var_32_15 > 0 then
				iter_32_4.alpha_fade_in_delay = var_32_15
			else
				iter_32_4.alpha_fade_in_delay = nil
			end

			var_32_3.alpha_multiplier = 0
		elseif var_32_13 then
			local var_32_16 = iter_32_4.alpha_fade_multipler or 1
			local var_32_17 = math.min(var_32_13 + arg_32_3 * var_32_16, 1)

			var_32_3.alpha_multiplier = math.easeInCubic(var_32_17)
			iter_32_4.alpha_multiplier = var_32_17
		end

		UIRenderer.draw_widget(var_32_0, iter_32_4)

		var_32_3.snap_pixel_positions = var_32_4
	end

	UIRenderer.end_pass(var_32_0)

	var_32_3.alpha_multiplier = var_32_5

	if arg_32_2 then
		arg_32_0._menu_input_description:draw(var_32_1, arg_32_3)
		UIRenderer.begin_pass(var_32_1, var_32_2, arg_32_1, arg_32_3)
		UIRenderer.draw_widget(var_32_1, arg_32_0._console_cursor_widget)
		UIRenderer.end_pass(var_32_1)
	end
end

function HeroViewStateHandbook.play_sound(arg_33_0, arg_33_1)
	arg_33_0.parent:play_sound(arg_33_1)
end

function HeroViewStateHandbook._start_transition_animation(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = {
		wwise_world = arg_34_0._ingame_ui_context.wwise_world,
		render_settings = arg_34_0._render_settings
	}
	local var_34_1

	arg_34_0._ui_animator:start_animation(arg_34_2, var_34_1, var_0_2, var_34_0)
end

function HeroViewStateHandbook.block_input(arg_35_0)
	arg_35_0._input_blocked = true
end

function HeroViewStateHandbook.unblock_input(arg_36_0)
	arg_36_0._input_blocked = false
end

function HeroViewStateHandbook.input_blocked(arg_37_0)
	return arg_37_0._input_blocked
end
