-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_panel.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_panel_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = "cycle_next"
local var_0_5 = "cycle_previous"

StoreWindowPanel = class(StoreWindowPanel)
StoreWindowPanel.NAME = "StoreWindowPanel"

function StoreWindowPanel.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate StoreWindowPanel")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0, var_1_1 = arg_1_0._parent:get_renderers()

	arg_1_0._ui_renderer = var_1_0
	arg_1_0._ui_top_renderer = var_1_1
	arg_1_0._layout_settings = arg_1_1.layout_settings
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._currency_types = DLCSettings.store.currency_types
	arg_1_0._currency_ui_settings = DLCSettings.store.currency_ui_settings
	arg_1_0._currencies = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_setup_input_buttons()
end

function StoreWindowPanel._create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0._currency_types
	local var_2_1 = arg_2_0._currency_ui_settings
	local var_2_2 = {}

	for iter_2_0 = 1, #var_2_0 do
		local var_2_3 = var_2_0[iter_2_0]
		local var_2_4 = "currency_node_" .. var_2_3
		local var_2_5 = {}

		var_2_5.parent = "panel"
		var_2_5.size = {
			200,
			70
		}
		var_2_5.position = {
			-92 - 200 * (iter_2_0 - 1),
			0,
			20
		}
		var_2_5.horizontal_alignment = "right"
		var_2_5.vertical_alignment = "bottom"
		var_0_2[var_2_4] = var_2_5

		local var_2_6 = var_2_1[var_2_3]
		local var_2_7 = var_2_6.background_ui_settings

		var_2_2["currency_panel_widget_" .. var_2_3] = UIWidgets.create_store_panel_currency_widget(var_2_4, var_2_6.frame, var_2_6.icon_big, var_2_7.texture, var_2_7.size)
		var_2_2["currency_text_tooltip_" .. var_2_3] = UIWidgets.create_additional_option_tooltip(var_2_4, {
			200,
			70
		}, {
			"weave_progression_slot_titles"
		}, {
			title = Localize(var_2_6.tooltip_title),
			description = Localize(var_2_6.tooltip_description),
			input = Localize(var_2_6.tooltip_input)
		}, 400, "right", "bottom", true, {
			0,
			-22,
			0
		})
	end

	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_2_0._widgets, arg_2_0._widgets_by_name = UIUtils.create_widgets(var_0_1)
	arg_2_0._top_widgets, arg_2_0._top_widgets_by_name = UIUtils.create_widgets(var_2_2)

	local var_2_8 = {}
	local var_2_9 = arg_2_0._layout_settings.window_layouts
	local var_2_10 = StoreLayoutConfig.pages
	local var_2_11 = StoreLayoutConfig.menu_options
	local var_2_12 = "game_option"
	local var_2_13 = var_0_2[var_2_12].size
	local var_2_14 = 28
	local var_2_15 = "center"
	local var_2_16 = {
		upper_case = true,
		localize = true,
		dynamic_font_size = true,
		word_wrap = false,
		font_type = "hell_shark_header",
		font_size = var_2_14
	}
	local var_2_17 = arg_2_0._parent.tab_cat

	ItemHelper.create_tab_unseen_item_stars(var_2_17)

	local var_2_18 = 0

	for iter_2_1, iter_2_2 in ipairs(var_2_11) do
		local var_2_19 = var_2_10[iter_2_2].display_name or "n/a"
		local var_2_20 = arg_2_0:_get_text_width(var_2_16, var_2_19)
		local var_2_21 = {
			math.min(var_2_20 + 40, 400),
			var_2_13[2]
		}
		local var_2_22 = {
			var_2_18,
			0,
			0
		}
		local var_2_23 = UIWidgets.create_store_panel_button(var_2_12, var_2_21, var_2_19, var_2_14, var_2_22, var_2_15)

		var_2_18 = var_2_18 + var_2_21[1]

		local var_2_24 = UIWidget.init(var_2_23)

		arg_2_0:_set_text_button_size(var_2_24, var_2_21[1])

		local var_2_25 = var_2_24.content

		var_2_25.page_name = iter_2_2

		if var_2_17[iter_2_2] > 0 then
			var_2_25.new = true
		end

		var_2_8[#var_2_8 + 1] = var_2_24
	end

	arg_2_0.tab_cat = var_2_17
	arg_2_0._ui_scenegraph.panel_entry_area.size[1] = var_2_18
	arg_2_0._title_button_widgets = var_2_8

	local var_2_26 = arg_2_0._widgets_by_name.mark_all_seen_button

	var_2_26.content.new = true
	var_2_26.style.new_marker.offset = {
		-80,
		8,
		10
	}

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)

	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_3)

	if arg_2_2 then
		local var_2_27 = arg_2_0._ui_scenegraph.window.local_position

		var_2_27[1] = var_2_27[1] + arg_2_2[1]
		var_2_27[2] = var_2_27[2] + arg_2_2[2]
		var_2_27[3] = var_2_27[3] + arg_2_2[3]
	end
end

function StoreWindowPanel.on_exit(arg_3_0, arg_3_1)
	print("[HeroViewWindow] Exit Substate StoreWindowPanel")

	arg_3_0._ui_animator = nil
end

function StoreWindowPanel.update(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_handle_gamepad_activity()
	arg_4_0:_handle_back_button_visibility()
	arg_4_0:_sync_player_wallet()
	arg_4_0:_sync_wallet_matchmaking_location()
	arg_4_0:_update_selected_option()
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_draw(arg_4_1)
end

function StoreWindowPanel.post_update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
end

function StoreWindowPanel._update_animations(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._ui_animations
	local var_6_1 = arg_6_0._animations
	local var_6_2 = arg_6_0._ui_animator

	for iter_6_0, iter_6_1 in pairs(arg_6_0._ui_animations) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			arg_6_0._ui_animations[iter_6_0] = nil
		end
	end

	var_6_2:update(arg_6_1)

	for iter_6_2, iter_6_3 in pairs(var_6_1) do
		if var_6_2:is_animation_completed(iter_6_3) then
			var_6_2:stop_animation(iter_6_3)

			var_6_1[iter_6_2] = nil
		end
	end

	local var_6_3 = arg_6_0._parent.tab_cat
	local var_6_4 = arg_6_0._title_button_widgets
	local var_6_5 = 0

	for iter_6_4, iter_6_5 in ipairs(var_6_4) do
		arg_6_0:_animate_title_entry(iter_6_5, arg_6_1)

		local var_6_6 = iter_6_5.content
		local var_6_7 = var_6_6.page_name
		local var_6_8 = StoreLayoutConfig.pages[var_6_7].rotation_timestamp

		var_6_6.timer = var_6_8 and var_6_8 > os.time()

		local var_6_9 = var_6_3[var_6_7]

		var_6_6.new = var_6_9 > 0
		var_6_5 = var_6_5 + var_6_9
	end

	local var_6_10 = Managers.input:is_device_active("gamepad")
	local var_6_11 = arg_6_0._widgets_by_name.mark_all_seen_button
	local var_6_12 = var_6_5 > 0

	var_6_11.content.visible = not var_6_10 and var_6_12
	var_6_11.content.enabled = not var_6_10 and var_6_12

	local var_6_13 = arg_6_0._widgets_by_name
	local var_6_14 = var_6_13.back_button
	local var_6_15 = var_6_13.close_button

	arg_6_0:_animate_back_button(var_6_14, arg_6_1)
	arg_6_0:_animate_back_button(var_6_15, arg_6_1)
	arg_6_0:_update_panel_selection_animation(arg_6_1)
end

function StoreWindowPanel._is_stepper_button_pressed(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content
	local var_7_1 = var_7_0.button_hotspot_left
	local var_7_2 = var_7_0.button_hotspot_right

	if var_7_1.on_release then
		var_7_1.on_release = false

		return true, -1
	elseif var_7_2.on_release then
		var_7_2.on_release = false

		return true, 1
	end
end

function StoreWindowPanel._handle_input(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._parent
	local var_8_1 = arg_8_0._widgets_by_name
	local var_8_2 = arg_8_0._parent:window_input_service()
	local var_8_3 = false
	local var_8_4 = var_8_1.close_button
	local var_8_5 = var_8_1.back_button
	local var_8_6 = var_8_1.mark_all_seen_button

	if UIUtils.is_button_hover_enter(var_8_5) or UIUtils.is_button_hover_enter(var_8_4) then
		arg_8_0:_play_sound("Play_hud_hover")
	end

	if not var_8_3 and UIUtils.is_button_pressed(var_8_4) then
		var_8_0:close_menu()

		var_8_3 = true
	end

	if not var_8_3 and UIUtils.is_button_pressed(var_8_6) then
		var_8_6.content.new = false

		ItemHelper.set_all_shop_item_seen(arg_8_0._parent.tab_cat)

		var_8_3 = true
	end

	local var_8_7 = #var_8_0:get_store_path()
	local var_8_8 = arg_8_0._title_button_widgets
	local var_8_9 = #var_8_8

	for iter_8_0, iter_8_1 in ipairs(var_8_8) do
		if not iter_8_1.content.button_hotspot.is_selected or var_8_7 > 1 then
			if UIUtils.is_button_hover_enter(iter_8_1) then
				arg_8_0:_play_sound("Play_hud_store_button_hover_category")
			end

			if UIUtils.is_button_pressed(iter_8_1) then
				arg_8_0:_on_panel_button_selected(iter_8_0)

				var_8_3 = true
			end
		end
	end

	if not var_8_3 then
		local var_8_10 = arg_8_0._selected_index or 1
		local var_8_11 = #var_8_8

		if var_8_2:get(var_0_5) then
			local var_8_12 = var_8_10 > 1 and var_8_10 - 1 or var_8_11

			arg_8_0:_on_panel_button_selected(var_8_12)
		elseif var_8_2:get(var_0_4) then
			local var_8_13 = var_8_10 % var_8_11 + 1

			arg_8_0:_on_panel_button_selected(var_8_13)
		end
	end
end

function StoreWindowPanel._on_panel_button_selected(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._parent
	local var_9_1 = arg_9_0._title_button_widgets[arg_9_1].content.page_name
	local var_9_2 = {
		var_9_1
	}

	var_9_0:go_to_store_path(var_9_2)
end

function StoreWindowPanel._set_selected_option(arg_10_0, arg_10_1)
	arg_10_0:_start_panel_selection_animation(arg_10_0._selected_index, arg_10_1)

	local var_10_0 = arg_10_0._title_button_widgets

	for iter_10_0, iter_10_1 in ipairs(var_10_0) do
		iter_10_1.content.button_hotspot.is_selected = iter_10_0 == arg_10_1
	end
end

function StoreWindowPanel._update_selected_option(arg_11_0)
	local var_11_0 = arg_11_0._parent:get_store_path()

	if var_11_0 then
		local var_11_1 = var_11_0[1]
		local var_11_2 = arg_11_0._title_button_widgets

		for iter_11_0, iter_11_1 in ipairs(var_11_2) do
			if iter_11_1.content.page_name == var_11_1 and iter_11_0 ~= arg_11_0._selected_index then
				arg_11_0:_set_selected_option(iter_11_0)

				arg_11_0._selected_index = iter_11_0
			end
		end
	end
end

function StoreWindowPanel._draw(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._ui_renderer
	local var_12_1 = arg_12_0._ui_top_renderer
	local var_12_2 = arg_12_0._ui_scenegraph
	local var_12_3 = arg_12_0._parent:window_input_service()
	local var_12_4 = arg_12_0._render_settings

	UIRenderer.begin_pass(var_12_0, var_12_2, var_12_3, arg_12_1, nil, var_12_4)
	UIRenderer.draw_all_widgets(var_12_0, arg_12_0._widgets)
	UIRenderer.draw_all_widgets(var_12_0, arg_12_0._title_button_widgets)
	UIRenderer.end_pass(var_12_0)
	UIRenderer.begin_pass(var_12_1, var_12_2, var_12_3, arg_12_1, nil, var_12_4)
	UIRenderer.draw_all_widgets(var_12_1, arg_12_0._top_widgets)
	UIRenderer.end_pass(var_12_1)
end

function StoreWindowPanel._play_sound(arg_13_0, arg_13_1)
	return arg_13_0._parent:play_sound(arg_13_1)
end

function StoreWindowPanel._setup_input_buttons(arg_14_0)
	local var_14_0 = true
	local var_14_1 = arg_14_0._parent:window_input_service(var_14_0)
	local var_14_2 = UISettings.get_gamepad_input_texture_data(var_14_1, var_0_5, true)
	local var_14_3 = UISettings.get_gamepad_input_texture_data(var_14_1, var_0_4, true)
	local var_14_4 = arg_14_0._widgets_by_name
	local var_14_5 = var_14_4.panel_input_area_1
	local var_14_6 = var_14_4.panel_input_area_2
	local var_14_7 = var_14_5.style.texture_id

	var_14_7.horizontal_alignment = "center"
	var_14_7.vertical_alignment = "center"
	var_14_7.texture_size = {
		var_14_2.size[1],
		var_14_2.size[2]
	}
	var_14_5.content.texture_id = var_14_2.texture

	local var_14_8 = var_14_6.style.texture_id

	var_14_8.horizontal_alignment = "center"
	var_14_8.vertical_alignment = "center"
	var_14_8.texture_size = {
		var_14_3.size[1],
		var_14_3.size[2]
	}
	var_14_6.content.texture_id = var_14_3.texture
end

function StoreWindowPanel._handle_back_button_visibility(arg_15_0)
	if not arg_15_0.gamepad_active_last_frame then
		local var_15_0 = arg_15_0._parent:close_on_exit()
		local var_15_1 = arg_15_0._widgets_by_name.back_button
		local var_15_2 = not var_15_0

		var_15_1.content.visible = var_15_2
	end
end

function StoreWindowPanel._reset_back_button(arg_16_0)
	local var_16_0 = arg_16_0._widgets_by_name.back_button.content.button_hotspot

	table.clear(var_16_0)
end

function StoreWindowPanel._handle_gamepad_activity(arg_17_0)
	local var_17_0 = Managers.input:is_device_active("gamepad")
	local var_17_1 = Managers.input:get_most_recent_device()
	local var_17_2 = arg_17_0.gamepad_active_last_frame == nil or var_17_0 and var_17_1 ~= arg_17_0._most_recent_device

	if var_17_0 then
		if not arg_17_0.gamepad_active_last_frame or var_17_2 then
			arg_17_0.gamepad_active_last_frame = true

			local var_17_3 = arg_17_0._widgets_by_name

			var_17_3.panel_input_area_1.content.visible = true
			var_17_3.panel_input_area_2.content.visible = true
			var_17_3.back_button.content.visible = false
			var_17_3.close_button.content.visible = false

			arg_17_0:_setup_input_buttons()
		end
	elseif arg_17_0.gamepad_active_last_frame or var_17_2 then
		arg_17_0.gamepad_active_last_frame = false

		local var_17_4 = arg_17_0._widgets_by_name

		var_17_4.panel_input_area_1.content.visible = false
		var_17_4.panel_input_area_2.content.visible = false
		var_17_4.close_button.content.visible = true
	end

	arg_17_0._most_recent_device = var_17_1
end

function StoreWindowPanel._set_text_button_size(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0._ui_scenegraph[arg_18_1.scenegraph_id].size[1] = arg_18_2

	local var_18_0 = arg_18_1.style
	local var_18_1 = 5
	local var_18_2 = arg_18_2 - var_18_1 * 2

	var_18_0.text.size[1] = var_18_2
	var_18_0.text_shadow.size[1] = var_18_2
	var_18_0.text_hover.size[1] = var_18_2
	var_18_0.text_disabled.size[1] = var_18_2
	var_18_0.text.offset[1] = var_18_0.text.default_offset[1] + var_18_1
	var_18_0.text_shadow.offset[1] = var_18_0.text_shadow.default_offset[1] + var_18_1
	var_18_0.text_hover.offset[1] = var_18_0.text_hover.default_offset[1] + var_18_1
	var_18_0.text_disabled.offset[1] = var_18_0.text_disabled.default_offset[1] + var_18_1
end

function StoreWindowPanel._get_text_width(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_1.localize then
		arg_19_2 = Localize(arg_19_2)
	end

	if arg_19_1.upper_case then
		arg_19_2 = TextToUpper(arg_19_2)
	end

	local var_19_0 = arg_19_0._ui_renderer
	local var_19_1, var_19_2 = UIFontByResolution(arg_19_1)

	return (UIRenderer.text_size(var_19_0, arg_19_2, var_19_1[1], var_19_2))
end

function StoreWindowPanel._set_text_button_horizontal_position(arg_20_0, arg_20_1, arg_20_2)
	arg_20_1.offset[1] = arg_20_2
end

function StoreWindowPanel._animate_title_entry(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_1.content
	local var_21_1 = arg_21_1.style
	local var_21_2 = var_21_0.button_hotspot
	local var_21_3 = var_21_2.is_hover
	local var_21_4 = var_21_2.is_selected
	local var_21_5 = not var_21_4 and var_21_2.is_clicked and var_21_2.is_clicked == 0
	local var_21_6 = var_21_2.input_progress or 0
	local var_21_7 = var_21_2.hover_progress or 0
	local var_21_8 = var_21_2.selection_progress or 0
	local var_21_9 = 8
	local var_21_10 = 20
	local var_21_11 = UIUtils.animate_value(var_21_6, arg_21_2 * var_21_10, var_21_5)
	local var_21_12 = UIUtils.animate_value(var_21_7, arg_21_2 * var_21_9, var_21_3)
	local var_21_13 = UIUtils.animate_value(var_21_8, arg_21_2 * var_21_9, var_21_4)
	local var_21_14 = math.easeOutCubic(var_21_12)
	local var_21_15 = math.easeInCubic(var_21_12)
	local var_21_16 = math.easeOutCubic(var_21_13)
	local var_21_17 = math.easeInCubic(var_21_13)
	local var_21_18 = math.max(var_21_12, var_21_13)
	local var_21_19 = math.max(var_21_16, var_21_14)
	local var_21_20 = math.max(var_21_15, var_21_17)
	local var_21_21 = 255 * var_21_18

	if var_21_1.text then
		local var_21_22 = 1 * var_21_18

		var_21_1.text.offset[2] = -(2 + var_21_22)
		var_21_1.text_shadow.offset[2] = -(4 + var_21_22)
		var_21_1.text_hover.offset[2] = -(2 + var_21_22)
		var_21_1.text_disabled.offset[2] = -(2 + var_21_22)
	end

	if var_21_1.new_marker then
		local var_21_23 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

		var_21_1.new_marker.color[1] = 100 + 155 * var_21_23
	end

	var_21_2.hover_progress = var_21_12
	var_21_2.input_progress = var_21_11
	var_21_2.selection_progress = var_21_13
end

function StoreWindowPanel._animate_back_button(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_1.content
	local var_22_1 = arg_22_1.style
	local var_22_2 = var_22_0.button_hotspot
	local var_22_3 = var_22_2.is_hover
	local var_22_4 = var_22_2.is_selected
	local var_22_5 = not var_22_4 and var_22_2.is_clicked and var_22_2.is_clicked == 0
	local var_22_6 = var_22_2.input_progress or 0
	local var_22_7 = var_22_2.hover_progress or 0
	local var_22_8 = var_22_2.selection_progress or 0
	local var_22_9 = 8
	local var_22_10 = 20
	local var_22_11 = UIUtils.animate_value(var_22_6, arg_22_2 * var_22_10, var_22_5)
	local var_22_12 = UIUtils.animate_value(var_22_7, arg_22_2 * var_22_9, var_22_3)
	local var_22_13 = UIUtils.animate_value(var_22_8, arg_22_2 * var_22_9, var_22_4)
	local var_22_14 = math.easeOutCubic(var_22_12)
	local var_22_15 = math.easeInCubic(var_22_12)
	local var_22_16 = math.easeOutCubic(var_22_13)
	local var_22_17 = math.easeInCubic(var_22_13)
	local var_22_18 = math.max(var_22_12, var_22_13)
	local var_22_19 = math.max(var_22_16, var_22_14)
	local var_22_20 = math.max(var_22_15, var_22_17)
	local var_22_21 = 255 * var_22_18

	var_22_1.texture_id.color[1] = 255 - var_22_21
	var_22_1.texture_hover_id.color[1] = var_22_21
	var_22_1.selected_texture.color[1] = var_22_21
	var_22_2.hover_progress = var_22_12
	var_22_2.input_progress = var_22_11
	var_22_2.selection_progress = var_22_13
end

function StoreWindowPanel._sync_wallet_matchmaking_location(arg_23_0)
	local var_23_0 = Managers.matchmaking:is_game_matchmaking()

	if var_23_0 ~= arg_23_0._is_game_matchmaking then
		arg_23_0._is_game_matchmaking = var_23_0

		local var_23_1 = arg_23_0._ui_scenegraph
		local var_23_2 = var_23_0 and 26 or 0
		local var_23_3 = arg_23_0._currency_types

		for iter_23_0 = 1, #var_23_3 do
			local var_23_4 = var_23_3[iter_23_0]
			local var_23_5 = "currency_node_" .. var_23_4

			var_23_1[var_23_5].position[1] = var_0_2[var_23_5].position[1] - var_23_2
		end
	end
end

function StoreWindowPanel._sync_player_wallet(arg_24_0)
	local var_24_0 = arg_24_0._currency_types
	local var_24_1 = 0
	local var_24_2 = false

	for iter_24_0 = 1, #var_24_0 do
		local var_24_3 = var_24_0[iter_24_0]
		local var_24_4 = Managers.backend:get_interface("peddler"):get_chips(var_24_3)

		if var_24_4 ~= arg_24_0._currencies[var_24_3] then
			arg_24_0._currencies[var_24_3] = var_24_4
			var_24_2 = true
		end
	end

	if var_24_2 then
		for iter_24_1 = 1, #var_24_0 do
			local var_24_5 = var_24_0[iter_24_1]
			local var_24_6 = arg_24_0._currencies[var_24_5]
			local var_24_7 = arg_24_0._top_widgets_by_name["currency_panel_widget_" .. var_24_5]
			local var_24_8 = var_24_7.content
			local var_24_9 = var_24_7.style
			local var_24_10 = arg_24_0._currency_ui_settings[var_24_5]
			local var_24_11 = UIUtils.comma_value(tostring(var_24_6))

			if var_24_10.max_amount then
				var_24_11 = string.format("%s/{#size(20)}%s{#reset()}", var_24_11, tostring(var_24_10.max_amount))
			end

			var_24_8.currency_text = var_24_11

			local var_24_12 = arg_24_0._ui_renderer
			local var_24_13 = UIUtils.get_text_width(var_24_12, var_24_9.currency_text, var_24_11)
			local var_24_14 = var_24_9.currency_icon.texture_size[1]
			local var_24_15 = 10
			local var_24_16 = var_24_14 + var_24_13 + var_24_15 * 2
			local var_24_17 = arg_24_0._ui_scenegraph
			local var_24_18 = var_24_16 + 60

			var_24_17["currency_node_" .. var_24_5].size[1] = var_24_18
			var_0_2["currency_node_" .. var_24_5].position[1] = -92 - var_24_1

			local var_24_19 = Managers.matchmaking:is_game_matchmaking() and 26 or 0

			var_24_17["currency_node_" .. var_24_5].position[1] = var_0_2["currency_node_" .. var_24_5].position[1] - var_24_19
			var_24_1 = var_24_1 + var_24_18
		end
	end
end

function StoreWindowPanel._start_panel_selection_animation(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._widgets_by_name.entry_panel_selection
	local var_25_1 = var_25_0.offset
	local var_25_2 = var_25_0.content.size
	local var_25_3 = arg_25_0._panel_selection_animation or {}

	arg_25_0._panel_selection_animation = var_25_3

	local var_25_4 = var_25_1[1]
	local var_25_5 = var_25_2[1]
	local var_25_6 = arg_25_0._title_button_widgets[arg_25_2].offset[1]
	local var_25_7 = arg_25_0._title_button_widgets[arg_25_2].content.size[1]
	local var_25_8 = 0.3

	var_25_3.duration = var_25_8
	var_25_3.total_duration = var_25_8
	var_25_3.target_offset = var_25_6
	var_25_3.start_offset = var_25_4
	var_25_3.target_width = var_25_7
	var_25_3.start_width = var_25_5
end

function StoreWindowPanel._update_panel_selection_animation(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._panel_selection_animation

	if not var_26_0 then
		return
	end

	local var_26_1 = var_26_0.duration

	if not var_26_1 then
		return
	end

	local var_26_2 = math.max(var_26_1 - arg_26_1, 0)
	local var_26_3 = var_26_0.start_offset
	local var_26_4 = var_26_0.target_offset
	local var_26_5 = var_26_0.start_width
	local var_26_6 = var_26_0.target_width
	local var_26_7 = 1 - var_26_2 / var_26_0.total_duration
	local var_26_8 = math.easeOutCubic(var_26_7)
	local var_26_9 = var_26_5 + (var_26_6 - var_26_5) * var_26_8
	local var_26_10 = var_26_3 + (var_26_4 - var_26_3) * var_26_8
	local var_26_11 = arg_26_0._widgets_by_name.entry_panel_selection
	local var_26_12 = var_26_11.style.write_mask.texture_size
	local var_26_13 = var_26_11.content.size
	local var_26_14 = var_26_11.scenegraph_id

	var_26_13[1] = var_26_9
	var_26_12[1] = var_26_9 * 1.5
	arg_26_0._ui_scenegraph[var_26_14].size[1] = var_26_9
	var_26_11.offset[1] = var_26_10

	if var_26_2 == 0 then
		var_26_0.duration = nil
	else
		var_26_0.duration = var_26_2
	end
end
