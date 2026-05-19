-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_event_overview_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_event_overview_console_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.selector_input_definition
local var_0_5 = "refresh_press"
local var_0_6 = "confirm_press"

StartGameWindowEventOverviewConsole = class(StartGameWindowEventOverviewConsole)
StartGameWindowEventOverviewConsole.NAME = "StartGameWindowEventOverviewConsole"

function StartGameWindowEventOverviewConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowEventOverviewConsole")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._stats_id = Managers.player:local_player():stats_id()
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0._input_index = arg_1_1.input_index or 1

	arg_1_0:_handle_new_selection(arg_1_0._input_index)
	arg_1_0:_update_difficulty_option()

	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._show_additional_settings = false
	arg_1_0._previous_can_play = nil

	arg_1_0._parent:change_generic_actions("default")
	arg_1_0:_start_transition_animation("on_enter")
end

function StartGameWindowEventOverviewConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function StartGameWindowEventOverviewConsole._create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_2) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_3)

	if arg_3_2 then
		local var_3_3 = arg_3_0._ui_scenegraph.window.local_position

		var_3_3[1] = var_3_3[1] + arg_3_2[1]
		var_3_3[2] = var_3_3[2] + arg_3_2[2]
		var_3_3[3] = var_3_3[3] + arg_3_2[3]
	end

	arg_3_0:_setup_content_from_backend()
end

function StartGameWindowEventOverviewConsole._setup_content_from_backend(arg_4_0)
	local var_4_0 = arg_4_0._widgets_by_name
	local var_4_1 = Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data()
	local var_4_2 = var_4_1.title_text_id

	var_4_0.event_title.content.text = Localize(var_4_2)

	local var_4_3 = var_4_1.description_text_id

	var_4_0.event_description.content.text = Localize(var_4_3)
end

function StartGameWindowEventOverviewConsole.on_exit(arg_5_0, arg_5_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowEventOverviewConsole")

	arg_5_0._ui_animator = nil

	if arg_5_0._play_button_pressed then
		arg_5_1.input_index = nil
	else
		arg_5_1.input_index = arg_5_0._input_index
	end
end

function StartGameWindowEventOverviewConsole.set_focus(arg_6_0, arg_6_1)
	arg_6_0._is_focused = arg_6_1
end

function StartGameWindowEventOverviewConsole.update(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:_update_can_play()
	arg_7_0:_update_animations(arg_7_1)
	arg_7_0:_handle_input(arg_7_1, arg_7_2)
	arg_7_0:_draw(arg_7_1)
end

function StartGameWindowEventOverviewConsole.post_update(arg_8_0, arg_8_1, arg_8_2)
	return
end

function StartGameWindowEventOverviewConsole._update_can_play(arg_9_0)
	local var_9_0 = arg_9_0:_can_play()

	if arg_9_0._previous_can_play ~= var_9_0 then
		arg_9_0._previous_can_play = var_9_0

		local var_9_1 = arg_9_0._widgets_by_name.play_button

		var_9_1.content.button_hotspot.disable_button = not var_9_0
		var_9_1.content.disabled = not var_9_0

		if var_9_0 then
			arg_9_0._parent:set_input_description("play_available")
		else
			arg_9_0._parent:set_input_description(nil)
		end
	end
end

function StartGameWindowEventOverviewConsole._is_button_hover_enter(arg_10_0, arg_10_1)
	return arg_10_1.content.button_hotspot.on_hover_enter
end

function StartGameWindowEventOverviewConsole._is_button_pressed(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	if var_11_0.on_release then
		var_11_0.on_release = false

		return true
	end
end

function StartGameWindowEventOverviewConsole._handle_input(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._parent
	local var_12_1 = var_12_0:window_input_service()

	if var_12_1:get(var_0_6) then
		arg_12_0:_option_selected(arg_12_0._input_index, arg_12_2)
	end

	local var_12_2 = arg_12_0._input_index

	if var_12_1:get("move_down") then
		var_12_2 = var_12_2 + 1
	elseif var_12_1:get("move_up") then
		var_12_2 = var_12_2 - 1
	end

	if var_12_2 ~= arg_12_0._input_index then
		arg_12_0:_handle_new_selection(var_12_2)
	end

	local var_12_3 = arg_12_0._widgets_by_name

	for iter_12_0 = 1, #var_0_4 do
		local var_12_4 = var_12_3[var_0_4[iter_12_0]]

		if not var_12_4.content.is_selected and arg_12_0:_is_button_hover_enter(var_12_4) then
			arg_12_0:_handle_new_selection(iter_12_0)
		end

		if arg_12_0:_is_button_pressed(var_12_4) then
			arg_12_0:_option_selected(arg_12_0._input_index, arg_12_2)
		end
	end

	if arg_12_0:_can_play() then
		if arg_12_0:_is_button_hover_enter(var_12_3.play_button) then
			arg_12_0:_play_sound("Play_hud_hover")
		end

		if var_12_1:get(var_0_5) or arg_12_0:_is_button_pressed(var_12_3.play_button) then
			arg_12_0._play_button_pressed = true

			var_12_0:play(arg_12_2, "event")
		end
	end
end

function StartGameWindowEventOverviewConsole._play_sound(arg_13_0, arg_13_1)
	arg_13_0._parent:play_sound(arg_13_1)
end

function StartGameWindowEventOverviewConsole._can_play(arg_14_0)
	return arg_14_0._parent:get_difficulty_option() ~= nil
end

function StartGameWindowEventOverviewConsole._update_difficulty_option(arg_15_0)
	local var_15_0 = arg_15_0._parent:get_difficulty_option()

	if var_15_0 then
		local var_15_1 = DifficultySettings[var_15_0]
		local var_15_2 = arg_15_0._widgets_by_name.difficulty_setting

		var_15_2.content.input_text = Localize(var_15_1.display_name)

		local var_15_3 = var_15_1.display_image

		var_15_2.content.icon_texture = var_15_3

		local var_15_4 = var_15_1.completed_frame_texture

		var_15_2.content.icon_frame_texture = var_15_4
	end
end

function StartGameWindowEventOverviewConsole._option_selected(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = var_0_4[arg_16_1]

	if var_16_0 == "difficulty_setting" then
		arg_16_0._parent:set_layout_by_name("difficulty_selection_event")
	elseif var_16_0 == "play_button" then
		arg_16_0._play_button_pressed = true

		arg_16_0._parent:play(arg_16_2, "event")
	else
		ferror("Unknown selector_input_definition: %s", var_16_0)
	end
end

function StartGameWindowEventOverviewConsole._handle_new_selection(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._widgets_by_name
	local var_17_1 = #var_0_4

	arg_17_1 = math.clamp(arg_17_1, 1, var_17_1)

	if var_17_0[var_0_4[arg_17_1]].content.disabled then
		return
	end

	for iter_17_0 = 1, #var_0_4 do
		local var_17_2 = var_17_0[var_0_4[iter_17_0]]
		local var_17_3 = iter_17_0 == arg_17_1

		var_17_2.content.is_selected = var_17_3
	end

	arg_17_0._input_index = arg_17_1
end

function StartGameWindowEventOverviewConsole._update_animations(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._ui_animator

	var_18_0:update(arg_18_1)

	local var_18_1 = arg_18_0._animations

	for iter_18_0, iter_18_1 in pairs(var_18_1) do
		if var_18_0:is_animation_completed(iter_18_1) then
			var_18_0:stop_animation(iter_18_1)

			var_18_1[iter_18_0] = nil
		end
	end

	local var_18_2 = arg_18_0._widgets_by_name

	UIWidgetUtils.animate_start_game_console_setting_button(var_18_2.difficulty_setting, arg_18_1)
	UIWidgetUtils.animate_play_button(var_18_2.play_button, arg_18_1)
end

function StartGameWindowEventOverviewConsole._draw(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._ui_top_renderer
	local var_19_1 = arg_19_0._ui_scenegraph
	local var_19_2 = arg_19_0._parent:window_input_service()
	local var_19_3 = arg_19_0._render_settings
	local var_19_4

	UIRenderer.begin_pass(var_19_0, var_19_1, var_19_2, arg_19_1, var_19_4, var_19_3)

	local var_19_5 = arg_19_0._widgets

	for iter_19_0 = 1, #var_19_5 do
		local var_19_6 = var_19_5[iter_19_0]

		UIRenderer.draw_widget(var_19_0, var_19_6)
	end

	UIRenderer.end_pass(var_19_0)
end
