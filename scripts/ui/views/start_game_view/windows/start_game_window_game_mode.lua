-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_game_mode.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_game_mode_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

StartGameWindowGameMode = class(StartGameWindowGameMode)
StartGameWindowGameMode.NAME = "StartGameWindowGameMode"

StartGameWindowGameMode.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowGameMode")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._layout_settings = arg_1_1.layout_settings

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
end

StartGameWindowGameMode.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = UISceneGraph.init_scenegraph(var_0_2)

	arg_2_0.ui_scenegraph = var_2_0

	local var_2_1 = {}
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_3 = UIWidget.init(iter_2_1)

		var_2_1[#var_2_1 + 1] = var_2_3
		var_2_2[iter_2_0] = var_2_3
	end

	arg_2_0._widgets = var_2_1
	arg_2_0._widgets_by_name = var_2_2

	local var_2_4 = {}
	local var_2_5 = arg_2_0._layout_settings.window_layouts
	local var_2_6 = 16

	for iter_2_2 = 1, #var_2_5 do
		local var_2_7 = var_2_5[iter_2_2]

		if var_2_7.panel_sorting and arg_2_0.parent:can_add_layout(var_2_7) then
			local var_2_8 = "game_mode_option"
			local var_2_9 = var_0_2[var_2_8].size
			local var_2_10 = var_2_7.display_name or "n/a"

			if var_2_7.localize == nil or var_2_7.localize then
				var_2_10 = Localize(var_2_10)
			end

			local var_2_11 = var_2_7.icon_name
			local var_2_12 = var_2_7.background_icon_name
			local var_2_13 = var_2_7.dynamic_font_size
			local var_2_14 = UIWidgets.create_window_category_button(var_2_8, var_2_9, var_2_10, var_2_11, var_2_12, var_2_13)
			local var_2_15 = UIWidget.init(var_2_14)
			local var_2_16 = #var_2_4 + 1
			local var_2_17 = var_2_7.name

			var_2_15.content.layout_name = var_2_17
			var_2_15.offset[2] = -var_2_6 * var_2_16 - var_2_9[2] * (var_2_16 - 1)

			if var_2_17 == "twitch" then
				var_2_15.content.disabled = not GameSettingsDevelopment.twitch_enabled or Managers.account:offline_mode()
			end

			var_2_4[var_2_16] = var_2_15
		end
	end

	arg_2_0._game_mode_widgets = var_2_4

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(var_2_0, var_0_3)

	if arg_2_2 then
		local var_2_18 = var_2_0.window.local_position

		var_2_18[1] = var_2_18[1] + arg_2_2[1]
		var_2_18[2] = var_2_18[2] + arg_2_2[2]
		var_2_18[3] = var_2_18[3] + arg_2_2[3]
	end
end

StartGameWindowGameMode.on_exit = function (arg_3_0, arg_3_1)
	print("[StartGameWindow] Exit Substate StartGameWindowGameMode")

	arg_3_0.ui_animator = nil
end

StartGameWindowGameMode.update = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_update_selected_option()
	arg_4_0:_update_animations(arg_4_1)
	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:draw(arg_4_1)
end

StartGameWindowGameMode.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	return
end

StartGameWindowGameMode._update_animations = function (arg_6_0, arg_6_1)
	arg_6_0:_update_game_options_hover_effect(arg_6_1)

	local var_6_0 = arg_6_0._ui_animations

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			var_6_0[iter_6_0] = nil
		end
	end

	local var_6_1 = arg_6_0.ui_animator

	var_6_1:update(arg_6_1)

	local var_6_2 = arg_6_0._animations

	for iter_6_2, iter_6_3 in pairs(var_6_2) do
		if var_6_1:is_animation_completed(iter_6_3) then
			var_6_1:stop_animation(iter_6_3)

			var_6_2[iter_6_2] = nil
		end
	end
end

StartGameWindowGameMode._is_button_pressed = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.content.button_hotspot

	if var_7_0.on_release then
		var_7_0.on_release = false

		return true
	end
end

StartGameWindowGameMode._is_button_hover_enter = function (arg_8_0, arg_8_1)
	return arg_8_1.content.button_hotspot.on_hover_enter
end

StartGameWindowGameMode._is_button_selected = function (arg_9_0, arg_9_1)
	return arg_9_1.content.button_hotspot.is_selected
end

StartGameWindowGameMode._handle_input = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._game_mode_widgets

	for iter_10_0 = 1, #var_10_0 do
		local var_10_1 = var_10_0[iter_10_0]

		if arg_10_0:_is_button_pressed(var_10_1) and not arg_10_0:_is_button_selected(var_10_1) then
			local var_10_2 = var_10_1.content.layout_name

			arg_10_0.parent:set_layout_by_name(var_10_2)

			PlayerData.mission_selection.start_layout = var_10_2
		end
	end

	local var_10_3 = arg_10_0._widgets_by_name.lobby_browser_option

	if arg_10_0:_is_button_pressed(var_10_3) then
		arg_10_0.parent:set_layout_by_name("lobby_browser")
	end
end

StartGameWindowGameMode._update_game_options_hover_effect = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._game_mode_widgets

	for iter_11_0 = 1, #var_11_0 do
		local var_11_1 = var_11_0[iter_11_0]

		UIWidgetUtils.animate_option_button(var_11_1, arg_11_1)

		if arg_11_0:_is_button_hover_enter(var_11_1) and not arg_11_0:_is_button_selected(var_11_1) then
			arg_11_0:_play_sound("play_gui_equipment_button_hover")
		end
	end

	local var_11_2 = arg_11_0._widgets_by_name.lobby_browser_option

	if arg_11_0:_is_button_hover_enter(var_11_2) then
		arg_11_0:_play_sound("play_gui_equipment_button_hover")
	end

	UIWidgetUtils.animate_default_button(var_11_2, arg_11_1)
end

StartGameWindowGameMode._set_selected_option = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._game_mode_widgets

	for iter_12_0 = 1, #var_12_0 do
		local var_12_1 = var_12_0[iter_12_0]
		local var_12_2 = var_12_1.content.layout_name == arg_12_1

		var_12_1.content.button_hotspot.is_selected = var_12_2
	end

	arg_12_0._selected_layout_name = arg_12_1
end

StartGameWindowGameMode._update_selected_option = function (arg_13_0)
	local var_13_0 = arg_13_0.parent:get_selected_layout_name()

	if var_13_0 ~= arg_13_0._selected_layout_name then
		arg_13_0:_set_selected_option(var_13_0)
	end
end

StartGameWindowGameMode.draw = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.ui_renderer
	local var_14_1 = arg_14_0.ui_scenegraph
	local var_14_2 = arg_14_0.parent:window_input_service()

	UIRenderer.begin_pass(var_14_0, var_14_1, var_14_2, arg_14_1, nil, arg_14_0.render_settings)

	for iter_14_0, iter_14_1 in pairs(arg_14_0._widgets_by_name) do
		UIRenderer.draw_widget(var_14_0, iter_14_1)
	end

	local var_14_3 = arg_14_0._game_mode_widgets

	for iter_14_2 = 1, #var_14_3 do
		local var_14_4 = var_14_3[iter_14_2]

		if not var_14_4.content.disabled then
			UIRenderer.draw_widget(var_14_0, var_14_4)
		end
	end

	UIRenderer.end_pass(var_14_0)
end

StartGameWindowGameMode._play_sound = function (arg_15_0, arg_15_1)
	arg_15_0.parent:play_sound(arg_15_1)
end
