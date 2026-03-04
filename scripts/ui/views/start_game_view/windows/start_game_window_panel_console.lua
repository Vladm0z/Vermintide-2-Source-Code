-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_panel_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_panel_console_definitions")
local var_0_1 = "cycle_next"
local var_0_2 = "cycle_previous"

StartGameWindowPanelConsole = class(StartGameWindowPanelConsole)
StartGameWindowPanelConsole.NAME = "StartGameWindowPanelConsole"

function StartGameWindowPanelConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate StartGameWindowPanelConsole")

	arg_1_0.params = arg_1_1
	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._layout_settings = arg_1_1.layout_settings
	arg_1_0._mechanism_name = arg_1_1.mechanism_name
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_create_ui_elements(var_0_0, arg_1_1, arg_1_2)
	arg_1_0:_setup_text_buttons_width_and_position()
	arg_1_0:_setup_input_buttons()
end

function StartGameWindowPanelConsole._create_ui_elements(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_1.scenegraph_definition
	local var_2_1 = UISceneGraph.init_scenegraph(var_2_0)

	arg_2_0.ui_scenegraph = var_2_1
	arg_2_0._widgets, arg_2_0._widgets_by_name = UIUtils.create_widgets(arg_2_1.widget_definitions)

	local var_2_2 = {}
	local var_2_3 = arg_2_0._layout_settings.window_layouts
	local var_2_4 = arg_2_0.parent

	for iter_2_0 = 1, #var_2_3 do
		local var_2_5 = var_2_3[iter_2_0]

		if var_2_5.panel_sorting and var_2_4:can_add_layout(var_2_5) then
			local var_2_6 = "game_mode_option"
			local var_2_7 = var_2_0[var_2_6].size
			local var_2_8 = var_2_5.display_name or "n/a"
			local var_2_9 = 32
			local var_2_10 = "center"
			local var_2_11 = arg_2_1.create_panel_button(var_2_6, var_2_7, var_2_8, var_2_9, nil, var_2_10)
			local var_2_12 = UIWidget.init(var_2_11)
			local var_2_13 = var_2_5.name

			var_2_12.content.layout_name = var_2_13
			var_2_12.disable_function_name = var_2_5.disable_function_name
			var_2_2[#var_2_2 + 1] = var_2_12
		end
	end

	arg_2_0._title_button_widgets = var_2_2

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(var_2_1, arg_2_1.animation_definitions)

	if arg_2_3 then
		local var_2_14 = var_2_1.window.local_position

		var_2_14[1] = var_2_14[1] + arg_2_3[1]
		var_2_14[2] = var_2_14[2] + arg_2_3[2]
		var_2_14[3] = var_2_14[3] + arg_2_3[3]
	end
end

function StartGameWindowPanelConsole._setup_text_buttons_width_and_position(arg_3_0)
	local var_3_0 = arg_3_0.ui_scenegraph
	local var_3_1 = var_3_0.panel_entry_area.size[1]
	local var_3_2 = arg_3_0._title_button_widgets
	local var_3_3 = #var_3_2
	local var_3_4 = math.floor(var_3_1 / var_3_3)

	var_3_0.game_mode_option.size[1] = var_3_4

	for iter_3_0 = 1, var_3_3 do
		local var_3_5 = var_3_2[iter_3_0]

		arg_3_0:_set_text_button_size(var_3_5, var_3_4)

		local var_3_6 = var_3_4 * (iter_3_0 - 1)

		var_3_5.offset[1] = var_3_6
	end

	arg_3_0._widgets_by_name.panel_input_area_2.offset[1] = var_3_4 * (var_3_3 - 1)
end

function StartGameWindowPanelConsole._set_text_button_size(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_1.style

	var_4_0.selected_texture.texture_size[1] = arg_4_2

	local var_4_1 = 5
	local var_4_2 = arg_4_2 - var_4_1 * 2

	var_4_0.text.size[1] = var_4_2
	var_4_0.text_shadow.size[1] = var_4_2
	var_4_0.text_hover.size[1] = var_4_2
	var_4_0.text_disabled.size[1] = var_4_2
	var_4_0.text.offset[1] = var_4_0.text.default_offset[1] + var_4_1
	var_4_0.text_shadow.offset[1] = var_4_0.text_shadow.default_offset[1] + var_4_1
	var_4_0.text_hover.offset[1] = var_4_0.text_hover.default_offset[1] + var_4_1
	var_4_0.text_disabled.offset[1] = var_4_0.text_disabled.default_offset[1] + var_4_1
end

function StartGameWindowPanelConsole.on_exit(arg_5_0, arg_5_1)
	print("[HeroViewWindow] Exit Substate StartGameWindowPanelConsole")

	arg_5_0.ui_animator = nil
end

function StartGameWindowPanelConsole.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_handle_gamepad_activity()
	arg_6_0:_handle_back_button_visibility()
	arg_6_0:_update_title_buttons_disable_status()
	arg_6_0:_update_selected_option()
	arg_6_0:_update_animations(arg_6_1, arg_6_2)
	arg_6_0:draw(arg_6_1)
end

function StartGameWindowPanelConsole._update_selected_option(arg_7_0)
	local var_7_0 = arg_7_0.parent:get_selected_layout_name()

	if var_7_0 ~= arg_7_0._selected_layout_name then
		arg_7_0:_set_selected_option(var_7_0)
	end
end

function StartGameWindowPanelConsole._update_title_buttons_disable_status(arg_8_0)
	local var_8_0 = arg_8_0._title_button_widgets

	for iter_8_0 = 1, #var_8_0 do
		local var_8_1 = var_8_0[iter_8_0]
		local var_8_2 = var_8_1.disable_function_name

		if var_8_2 then
			local var_8_3 = arg_8_0[var_8_2](arg_8_0)

			var_8_1.content.button_hotspot.disable_button = var_8_3
		else
			var_8_1.content.button_hotspot.disable_button = false
		end
	end
end

function StartGameWindowPanelConsole.post_update(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:_handle_input(arg_9_1, arg_9_2)
end

function StartGameWindowPanelConsole._update_animations(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._ui_animations

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		UIAnimation.update(iter_10_1, arg_10_1)

		if UIAnimation.completed(iter_10_1) then
			var_10_0[iter_10_0] = nil
		end
	end

	local var_10_1 = arg_10_0.ui_animator

	var_10_1:update(arg_10_1)

	local var_10_2 = arg_10_0._animations

	for iter_10_2, iter_10_3 in pairs(var_10_2) do
		if var_10_1:is_animation_completed(iter_10_3) then
			var_10_2[iter_10_2] = nil
		end
	end

	local var_10_3 = arg_10_0._title_button_widgets

	for iter_10_4 = 1, #var_10_3 do
		arg_10_0:_animate_title_entry(var_10_3[iter_10_4], arg_10_1, arg_10_2)
	end

	arg_10_0:_animate_back_button(arg_10_0._widgets_by_name.back_button, arg_10_1)
	arg_10_0:_animate_back_button(arg_10_0._widgets_by_name.close_button, arg_10_1)
end

function StartGameWindowPanelConsole._find_next_layout_name(arg_11_0, arg_11_1)
	local var_11_0 = 1
	local var_11_1 = arg_11_0._selected_layout_name
	local var_11_2 = arg_11_0._title_button_widgets

	for iter_11_0 = 1, #var_11_2 do
		if var_11_2[iter_11_0].content.layout_name == var_11_1 then
			var_11_0 = iter_11_0

			break
		end
	end

	local var_11_3
	local var_11_4 = var_11_0
	local var_11_5 = false

	repeat
		var_11_4 = math.index_wrapper(var_11_4 + arg_11_1, #var_11_2)

		local var_11_6 = var_11_2[var_11_4]

		if var_11_4 == var_11_0 then
			var_11_5 = true
		elseif not var_11_6.content.button_hotspot.disable_button then
			var_11_3 = var_11_6.content.layout_name
			var_11_5 = true
		end
	until var_11_5

	return var_11_3
end

function StartGameWindowPanelConsole._handle_input(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = false
	local var_12_1
	local var_12_2 = arg_12_0._title_button_widgets

	for iter_12_0 = 1, #var_12_2 do
		local var_12_3 = var_12_2[iter_12_0]

		if not UIUtils.is_button_selected(var_12_3) then
			if UIUtils.is_button_hover_enter(var_12_3) then
				arg_12_0:_play_sound("Play_hud_hover")
			end

			if UIUtils.is_button_pressed(var_12_3) then
				var_12_1 = var_12_3.content.layout_name
				var_12_0 = true
			end
		end
	end

	local var_12_4 = arg_12_0._widgets_by_name
	local var_12_5 = var_12_4.close_button
	local var_12_6 = var_12_4.back_button

	if UIUtils.is_button_hover_enter(var_12_6) or UIUtils.is_button_hover_enter(var_12_5) then
		arg_12_0:_play_sound("Play_hud_hover")
	end

	local var_12_7 = arg_12_0.parent

	if not var_12_7:close_on_exit() and not var_12_0 and UIUtils.is_button_pressed(var_12_6) then
		local var_12_8
		local var_12_9 = arg_12_0.params

		if var_12_9 then
			var_12_8 = var_12_9.return_layout_name
			var_12_9.return_layout_name = nil
		end

		var_12_8 = var_12_8 or var_12_7:get_previous_selected_layout_name()

		if var_12_8 then
			arg_12_0:_reset_back_button()

			var_12_1 = var_12_8
			var_12_0 = true
		end
	end

	if not var_12_0 and UIUtils.is_button_pressed(var_12_5) then
		var_12_7:close_menu()

		var_12_0 = true
	end

	if not var_12_0 and not arg_12_0.parent:panel_title_buttons_hidden() then
		local var_12_10 = var_12_7:window_input_service()
		local var_12_11 = var_12_10:get(var_0_2) and -1 or var_12_10:get(var_0_1) and 1

		if var_12_11 then
			var_12_1 = arg_12_0:_find_next_layout_name(var_12_11)
			var_12_0 = true
		end
	end

	if var_12_0 and var_12_1 then
		var_12_7:set_layout_by_name(var_12_1)

		PlayerData.mission_selection.start_layout = var_12_1
	end
end

function StartGameWindowPanelConsole._set_selected_option(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._title_button_widgets

	for iter_13_0 = 1, #var_13_0 do
		local var_13_1 = var_13_0[iter_13_0].content
		local var_13_2 = var_13_1.layout_name

		var_13_1.button_hotspot.is_selected = var_13_2 == arg_13_1
	end

	arg_13_0._selected_layout_name = arg_13_1
end

function StartGameWindowPanelConsole.draw(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.ui_renderer
	local var_14_1 = arg_14_0.ui_scenegraph
	local var_14_2 = arg_14_0.parent:window_input_service()

	UIRenderer.begin_pass(var_14_0, var_14_1, var_14_2, arg_14_1, nil, arg_14_0.render_settings)
	UIRenderer.draw_all_widgets(var_14_0, arg_14_0._widgets)

	if not arg_14_0.parent:panel_title_buttons_hidden() then
		UIRenderer.draw_all_widgets(var_14_0, arg_14_0._title_button_widgets)
	end

	UIRenderer.end_pass(var_14_0)
end

function StartGameWindowPanelConsole._play_sound(arg_15_0, arg_15_1)
	arg_15_0.parent:play_sound(arg_15_1)
end

function StartGameWindowPanelConsole._setup_input_buttons(arg_16_0)
	local var_16_0 = arg_16_0.parent:window_input_service()
	local var_16_1 = arg_16_0._widgets_by_name
	local var_16_2 = var_16_1.panel_input_area_1
	local var_16_3 = var_16_2.style.texture_id
	local var_16_4 = UISettings.get_gamepad_input_texture_data(var_16_0, var_0_2, true)

	var_16_3.horizontal_alignment = "center"
	var_16_3.vertical_alignment = "center"
	var_16_3.texture_size = {
		var_16_4.size[1],
		var_16_4.size[2]
	}
	var_16_2.content.texture_id = var_16_4.texture

	local var_16_5 = var_16_1.panel_input_area_2
	local var_16_6 = var_16_5.style.texture_id
	local var_16_7 = UISettings.get_gamepad_input_texture_data(var_16_0, var_0_1, true)

	var_16_6.horizontal_alignment = "center"
	var_16_6.vertical_alignment = "center"
	var_16_6.texture_size = {
		var_16_7.size[1],
		var_16_7.size[2]
	}
	var_16_5.content.texture_id = var_16_7.texture
end

function StartGameWindowPanelConsole._handle_back_button_visibility(arg_17_0)
	if not arg_17_0.gamepad_active_last_frame then
		local var_17_0 = not arg_17_0.parent:close_on_exit()

		arg_17_0._widgets_by_name.back_button.content.visible = var_17_0
	end
end

function StartGameWindowPanelConsole._reset_back_button(arg_18_0)
	local var_18_0 = arg_18_0._widgets_by_name.back_button.content.button_hotspot

	table.clear(var_18_0)
end

function StartGameWindowPanelConsole._handle_gamepad_activity(arg_19_0)
	local var_19_0

	var_19_0 = arg_19_0.gamepad_active_last_frame == nil

	local var_19_1 = Managers.input:is_device_active("gamepad")
	local var_19_2 = Managers.input:get_most_recent_device()
	local var_19_3 = arg_19_0.gamepad_active_last_frame == nil or var_19_1 and var_19_2 ~= arg_19_0._most_recent_device

	if var_19_1 then
		if not arg_19_0.gamepad_active_last_frame or var_19_3 then
			arg_19_0.gamepad_active_last_frame = true

			if not arg_19_0.parent:panel_title_buttons_hidden() then
				local var_19_4 = arg_19_0._widgets_by_name

				var_19_4.panel_input_area_1.content.visible = true
				var_19_4.panel_input_area_2.content.visible = true
				var_19_4.back_button.content.visible = false
				var_19_4.close_button.content.visible = false
			end

			arg_19_0:_setup_input_buttons()
		end
	elseif arg_19_0.gamepad_active_last_frame or var_19_3 then
		arg_19_0.gamepad_active_last_frame = false

		local var_19_5 = arg_19_0._widgets_by_name

		var_19_5.panel_input_area_1.content.visible = false
		var_19_5.panel_input_area_2.content.visible = false
		var_19_5.close_button.content.visible = true
	end

	arg_19_0._most_recent_device = var_19_2
end

function StartGameWindowPanelConsole._is_in_quickplay_weave_menu(arg_20_0)
	return arg_20_0.parent.parent:on_enter_sub_state() == "weave_quickplay"
end

function StartGameWindowPanelConsole._is_supported_with_twitch(arg_21_0, arg_21_1)
	local var_21_0 = Managers.twitch

	if var_21_0 and (var_21_0:is_connecting() or var_21_0:is_connected()) then
		return var_21_0:game_mode_supported(arg_21_1)
	end

	return true
end

function StartGameWindowPanelConsole._event_disable_function(arg_22_0)
	return arg_22_0:_is_in_quickplay_weave_menu() or not arg_22_0:_is_supported_with_twitch("event")
end

function StartGameWindowPanelConsole._adventure_disable_function(arg_23_0)
	return arg_23_0:_is_in_quickplay_weave_menu() or not arg_23_0:_is_supported_with_twitch("adventure")
end

function StartGameWindowPanelConsole._custom_game_disable_function(arg_24_0)
	return arg_24_0:_is_in_quickplay_weave_menu() or not arg_24_0:_is_supported_with_twitch("custom")
end

function StartGameWindowPanelConsole._heroic_deed_disable_function(arg_25_0)
	return arg_25_0:_is_in_quickplay_weave_menu() or not arg_25_0:_is_supported_with_twitch("deed") or script_data.use_beta_mode
end

function StartGameWindowPanelConsole._lobby_browser_disable_function(arg_26_0)
	return not arg_26_0:_is_supported_with_twitch("lobby_browser")
end

function StartGameWindowPanelConsole._weave_disable_function(arg_27_0)
	return arg_27_0:_is_in_quickplay_weave_menu() or not arg_27_0:_is_supported_with_twitch("weave")
end

function StartGameWindowPanelConsole._deus_quickplay_disable_function(arg_28_0)
	return arg_28_0:_is_in_quickplay_weave_menu() or not arg_28_0:_is_supported_with_twitch("deus_quickplay")
end

function StartGameWindowPanelConsole._deus_custom_disable_function(arg_29_0)
	return arg_29_0:_is_in_quickplay_weave_menu() or not arg_29_0:_is_supported_with_twitch("deus_custom")
end

function StartGameWindowPanelConsole._versus_quickplay_disable_function(arg_30_0)
	return arg_30_0:_is_in_quickplay_weave_menu() or not arg_30_0:_is_supported_with_twitch("versus_quickplay")
end

function StartGameWindowPanelConsole._versus_custom_disable_function(arg_31_0)
	return arg_31_0:_is_in_quickplay_weave_menu() or not arg_31_0:_is_supported_with_twitch("versus_custom")
end

function StartGameWindowPanelConsole._streaming_disable_function(arg_32_0)
	if arg_32_0:_is_in_quickplay_weave_menu() then
		return true
	end

	local var_32_0 = GameSettingsDevelopment.twitch_enabled
	local var_32_1 = Managers.account:offline_mode()

	return not var_32_0 or var_32_1
end

function StartGameWindowPanelConsole._animate_title_entry(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = arg_33_1.content.button_hotspot
	local var_33_1 = var_33_0.is_selected
	local var_33_2 = 20
	local var_33_3 = not var_33_1 and var_33_0.is_clicked and var_33_0.is_clicked == 0
	local var_33_4 = UIUtils.animate_value(var_33_0.input_progress or 0, arg_33_2 * var_33_2, var_33_3)
	local var_33_5 = 8
	local var_33_6 = UIUtils.animate_value(var_33_0.hover_progress or 0, arg_33_2 * var_33_5, var_33_0.is_hover)
	local var_33_7 = UIUtils.animate_value(var_33_0.selection_progress or 0, arg_33_2 * var_33_5, var_33_1)
	local var_33_8 = math.max(var_33_6, var_33_7)
	local var_33_9 = 255 * var_33_8
	local var_33_10 = arg_33_1.style

	var_33_10.selected_texture.color[1] = var_33_9

	local var_33_11 = 4 * var_33_8

	var_33_10.text.offset[2] = 5 - var_33_11
	var_33_10.text_shadow.offset[2] = 3 - var_33_11
	var_33_10.text_hover.offset[2] = 5 - var_33_11
	var_33_10.text_disabled.offset[2] = 5 - var_33_11

	local var_33_12 = 0.5 + math.sin(arg_33_3 * 5) * 0.5

	var_33_10.new_marker.color[1] = 100 + 155 * var_33_12
	var_33_0.hover_progress = var_33_6
	var_33_0.input_progress = var_33_4
	var_33_0.selection_progress = var_33_7
end

function StartGameWindowPanelConsole._animate_back_button(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_1.content
	local var_34_1 = arg_34_1.style
	local var_34_2 = var_34_0.button_hotspot
	local var_34_3 = var_34_2.is_selected
	local var_34_4 = not var_34_3 and var_34_2.is_clicked and var_34_2.is_clicked == 0
	local var_34_5 = 20
	local var_34_6 = UIUtils.animate_value(var_34_2.input_progress or 0, arg_34_2 * var_34_5, var_34_4)
	local var_34_7 = 8
	local var_34_8 = UIUtils.animate_value(var_34_2.hover_progress or 0, var_34_7 * arg_34_2, var_34_2.is_hover)
	local var_34_9 = UIUtils.animate_value(var_34_2.selection_progress or 0, var_34_7 * arg_34_2, var_34_3)
	local var_34_10 = 255 * math.max(var_34_8, var_34_9)

	var_34_1.texture_id.color[1] = 255 - var_34_10
	var_34_1.texture_hover_id.color[1] = var_34_10
	var_34_1.selected_texture.color[1] = var_34_10
	var_34_2.hover_progress = var_34_8
	var_34_2.input_progress = var_34_6
	var_34_2.selection_progress = var_34_9
end
