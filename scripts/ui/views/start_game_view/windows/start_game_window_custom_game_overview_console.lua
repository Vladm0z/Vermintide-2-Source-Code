-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_custom_game_overview_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_custom_game_overview_console_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.selector_input_definition
local var_0_5 = "refresh_press"
local var_0_6 = "confirm_press"

StartGameWindowCustomGameOverviewConsole = class(StartGameWindowCustomGameOverviewConsole)
StartGameWindowCustomGameOverviewConsole.NAME = "StartGameWindowCustomGameOverviewConsole"

function StartGameWindowCustomGameOverviewConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowCustomGameOverviewConsole")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._mechanism_name = Managers.mechanism:current_mechanism_name()
	arg_1_0._stats_id = Managers.player:local_player():stats_id()
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0._input_index = arg_1_1.input_index or 1

	arg_1_0:_handle_new_selection(arg_1_0._input_index)
	arg_1_0:_update_mission_option()
	arg_1_0:_update_difficulty_option()

	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._previous_can_play = nil

	local var_1_1 = not Managers.account:offline_mode()

	arg_1_0._is_online = var_1_1

	if var_1_1 then
		arg_1_0._parent:change_generic_actions("default_custom_game")
	else
		arg_1_0._parent:change_generic_actions("offline_custom_game")
	end

	arg_1_0:_start_transition_animation("on_enter")
end

function StartGameWindowCustomGameOverviewConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function StartGameWindowCustomGameOverviewConsole._create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = UISceneGraph.init_scenegraph(var_0_1)

	arg_3_0._ui_scenegraph = var_3_0

	local var_3_1 = {}
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_2) do
		local var_3_3 = UIWidget.init(iter_3_1)

		var_3_1[#var_3_1 + 1] = var_3_3
		var_3_2[iter_3_0] = var_3_3
	end

	arg_3_0._widgets = var_3_1
	arg_3_0._widgets_by_name = var_3_2

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(var_3_0, var_0_3)

	if arg_3_2 then
		local var_3_4 = arg_3_0._ui_scenegraph.window.local_position

		var_3_4[1] = var_3_4[1] + arg_3_2[1]
		var_3_4[2] = var_3_4[2] + arg_3_2[2]
		var_3_4[3] = var_3_4[3] + arg_3_2[3]
	end
end

function StartGameWindowCustomGameOverviewConsole.on_exit(arg_4_0, arg_4_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowCustomGameOverviewConsole")

	arg_4_0._ui_animator = nil

	if arg_4_0._play_button_pressed then
		arg_4_1.input_index = nil
	else
		arg_4_1.input_index = arg_4_0._input_index
	end
end

function StartGameWindowCustomGameOverviewConsole.set_focus(arg_5_0, arg_5_1)
	arg_5_0._is_focused = arg_5_1
end

function StartGameWindowCustomGameOverviewConsole.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_can_play()
	arg_6_0:_update_animations(arg_6_1)

	if arg_6_0._is_focused then
		arg_6_0:_handle_input(arg_6_1, arg_6_2)
	end

	arg_6_0:_draw(arg_6_1)
end

function StartGameWindowCustomGameOverviewConsole.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function StartGameWindowCustomGameOverviewConsole._update_can_play(arg_8_0)
	local var_8_0 = arg_8_0:_can_play()

	if arg_8_0._previous_can_play ~= var_8_0 then
		arg_8_0._previous_can_play = var_8_0

		local var_8_1 = arg_8_0._widgets_by_name.play_button

		var_8_1.content.button_hotspot.disable_button = not var_8_0
		var_8_1.content.disabled = not var_8_0

		if var_8_0 then
			arg_8_0._parent:set_input_description("play_available")
		else
			arg_8_0._parent:set_input_description(nil)
		end
	end
end

function StartGameWindowCustomGameOverviewConsole._is_button_hover_enter(arg_9_0, arg_9_1)
	return arg_9_1.content.button_hotspot.on_hover_enter
end

function StartGameWindowCustomGameOverviewConsole._is_button_pressed(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content.button_hotspot

	if var_10_0.on_release then
		var_10_0.on_release = false

		return true
	end
end

function StartGameWindowCustomGameOverviewConsole._handle_input(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._parent
	local var_11_1 = var_11_0:window_input_service()

	if var_11_1:get(var_0_6) then
		arg_11_0:_option_selected(arg_11_0._input_index, arg_11_2)
	end

	local var_11_2 = arg_11_0._input_index

	if var_11_1:get("move_down") then
		var_11_2 = var_11_2 + 1
	elseif var_11_1:get("move_up") then
		var_11_2 = var_11_2 - 1
	end

	if var_11_2 ~= arg_11_0._input_index then
		arg_11_0:_handle_new_selection(var_11_2)
	end

	local var_11_3 = arg_11_0._widgets_by_name

	for iter_11_0 = 1, #var_0_4 do
		local var_11_4 = var_11_3[var_0_4[iter_11_0]]

		if not var_11_4.content.is_selected and arg_11_0:_is_button_hover_enter(var_11_4) then
			arg_11_0:_handle_new_selection(iter_11_0)
		end

		if arg_11_0:_is_button_pressed(var_11_4) then
			arg_11_0:_option_selected(arg_11_0._input_index, arg_11_2)
		end
	end

	if arg_11_0:_can_play() then
		if arg_11_0:_is_button_hover_enter(var_11_3.play_button) then
			arg_11_0._parent:play_sound("Play_hud_hover")
		end

		if var_11_1:get(var_0_5) or arg_11_0:_is_button_pressed(var_11_3.play_button) then
			arg_11_0._play_button_pressed = true

			local var_11_5 = var_11_0:get_custom_game_settings(arg_11_0._mechanism_name) or var_11_0:get_custom_game_settings("adventure")

			var_11_0:play(arg_11_2, var_11_5.game_mode_type)
		end
	end

	local var_11_6 = true

	if var_11_1:get("right_stick_press", var_11_6) and arg_11_0._is_online then
		var_11_0:set_window_input_focus("additional_settings")
	end
end

function StartGameWindowCustomGameOverviewConsole._can_play(arg_12_0)
	local var_12_0 = arg_12_0._parent
	local var_12_1 = var_12_0:get_selected_level_id()
	local var_12_2 = var_12_0:get_difficulty_option()

	return var_12_1 ~= nil and var_12_2 ~= nil
end

function StartGameWindowCustomGameOverviewConsole._update_mission_option(arg_13_0)
	local var_13_0 = arg_13_0._parent:get_selected_level_id()

	if not var_13_0 then
		return
	end

	local var_13_1 = LevelSettings[var_13_0]
	local var_13_2 = var_13_1.display_name
	local var_13_3 = var_13_1.level_image
	local var_13_4 = arg_13_0._parent:get_completed_level_difficulty_index(arg_13_0._statistics_db, arg_13_0._stats_id, var_13_0)
	local var_13_5 = arg_13_0._widgets_by_name.mission_setting

	var_13_5.content.input_text = Localize(var_13_2)
	var_13_5.content.icon_texture = var_13_3
	var_13_5.content.icon_frame_texture = UIWidgetUtils.get_level_frame_by_difficulty_index(var_13_4)
end

function StartGameWindowCustomGameOverviewConsole._update_difficulty_option(arg_14_0)
	local var_14_0 = arg_14_0._parent:get_difficulty_option()

	if var_14_0 then
		local var_14_1 = DifficultySettings[var_14_0]
		local var_14_2 = arg_14_0._widgets_by_name.difficulty_setting

		var_14_2.content.input_text = Localize(var_14_1.display_name)

		local var_14_3 = var_14_1.display_image

		var_14_2.content.icon_texture = var_14_3

		local var_14_4 = var_14_1.completed_frame_texture

		var_14_2.content.icon_frame_texture = var_14_4
	end
end

function StartGameWindowCustomGameOverviewConsole._option_selected(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._parent
	local var_15_1 = var_15_0:get_custom_game_settings(arg_15_0._mechanism_name) or var_15_0:get_custom_game_settings("adventure")
	local var_15_2 = var_0_4[arg_15_1]

	if var_15_2 == "mission_setting" then
		arg_15_0._parent:set_layout_by_name(var_15_1.layout_name)
	elseif var_15_2 == "difficulty_setting" then
		arg_15_0._parent:set_layout_by_name("difficulty_selection_custom")
	elseif var_15_2 == "play_button" then
		arg_15_0._play_button_pressed = true

		arg_15_0._parent:play(arg_15_2, var_15_1.game_mode_type)
	else
		ferror("Unknown selector_input_definition: %s", var_15_2)
	end
end

function StartGameWindowCustomGameOverviewConsole._handle_new_selection(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._widgets_by_name
	local var_16_1 = #var_0_4

	arg_16_1 = math.clamp(arg_16_1, 1, var_16_1)

	if var_16_0[var_0_4[arg_16_1]].content.disabled then
		return
	end

	for iter_16_0 = 1, #var_0_4 do
		local var_16_2 = var_16_0[var_0_4[iter_16_0]]
		local var_16_3 = iter_16_0 == arg_16_1

		var_16_2.content.is_selected = var_16_3
	end

	if arg_16_0._input_index ~= arg_16_1 then
		arg_16_0._parent:play_sound("play_gui_lobby_button_02_mission_act_click")
	end

	arg_16_0._input_index = arg_16_1
end

function StartGameWindowCustomGameOverviewConsole._update_animations(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._ui_animator

	var_17_0:update(arg_17_1)

	local var_17_1 = arg_17_0._animations

	for iter_17_0, iter_17_1 in pairs(var_17_1) do
		if var_17_0:is_animation_completed(iter_17_1) then
			var_17_0:stop_animation(iter_17_1)

			var_17_1[iter_17_0] = nil
		end
	end

	local var_17_2 = arg_17_0._widgets_by_name

	UIWidgetUtils.animate_start_game_console_setting_button(var_17_2.mission_setting, arg_17_1)
	UIWidgetUtils.animate_start_game_console_setting_button(var_17_2.difficulty_setting, arg_17_1)
	UIWidgetUtils.animate_play_button(var_17_2.play_button, arg_17_1)
end

function StartGameWindowCustomGameOverviewConsole._draw(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._ui_top_renderer
	local var_18_1 = arg_18_0._ui_scenegraph
	local var_18_2 = arg_18_0._parent:window_input_service()
	local var_18_3 = arg_18_0._render_settings
	local var_18_4

	UIRenderer.begin_pass(var_18_0, var_18_1, var_18_2, arg_18_1, var_18_4, var_18_3)

	local var_18_5 = arg_18_0._widgets

	for iter_18_0 = 1, #var_18_5 do
		local var_18_6 = var_18_5[iter_18_0]

		UIRenderer.draw_widget(var_18_0, var_18_6)
	end

	UIRenderer.end_pass(var_18_0)
end
