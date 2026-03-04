-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_quickplay.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_quickplay_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.selector_input_definitions
local var_0_5 = "refresh_press"
local var_0_6 = "confirm_press"

StartGameWindowVersusQuickplay = class(StartGameWindowVersusQuickplay)
StartGameWindowVersusQuickplay.NAME = "StartGameWindowVersusQuickplay"

StartGameWindowVersusQuickplay.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowVersusQuickplay")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0._input_index = arg_1_1.input_index or 1

	arg_1_0:_handle_new_selection(arg_1_0._input_index)

	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._previous_can_play = nil

	arg_1_0._parent:change_generic_actions("versus_quickplay_default")
	arg_1_0:_start_transition_animation("on_enter")
end

StartGameWindowVersusQuickplay._start_transition_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

StartGameWindowVersusQuickplay._create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_3_0._widgets, arg_3_0._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_3)

	if arg_3_2 then
		local var_3_0 = arg_3_0._ui_scenegraph.window.local_position

		var_3_0[1] = var_3_0[1] + arg_3_2[1]
		var_3_0[2] = var_3_0[2] + arg_3_2[2]
		var_3_0[3] = var_3_0[3] + arg_3_2[3]
	end
end

StartGameWindowVersusQuickplay.on_exit = function (arg_4_0, arg_4_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowVersusQuickplay")

	arg_4_0._ui_animator = nil

	if arg_4_0._play_button_pressed then
		arg_4_1.input_index = nil
	else
		arg_4_1.input_index = arg_4_0._input_index
	end
end

StartGameWindowVersusQuickplay.set_focus = function (arg_5_0, arg_5_1)
	arg_5_0._is_focused = arg_5_1
end

StartGameWindowVersusQuickplay.update = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.input:is_device_active("gamepad")

	arg_6_0:_update_can_play()
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_handle_gamepad_activity()
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_update_play_button_texture(var_6_0)
	arg_6_0:_draw(arg_6_1)
end

StartGameWindowVersusQuickplay.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

StartGameWindowVersusQuickplay._handle_gamepad_activity = function (arg_8_0)
	local var_8_0 = arg_8_0.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not arg_8_0.gamepad_active_last_frame or var_8_0 then
			arg_8_0._input_index = 1

			local var_8_1 = var_0_4[arg_8_0._input_index]

			if var_8_1 and var_8_1.enter_requirements(arg_8_0) then
				var_8_1.on_enter(arg_8_0)
			end

			arg_8_0.gamepad_active_last_frame = true
		end
	elseif arg_8_0.gamepad_active_last_frame or var_8_0 then
		arg_8_0.gamepad_active_last_frame = false

		var_0_4[arg_8_0._input_index].on_exit(arg_8_0)
	end
end

StartGameWindowVersusQuickplay._update_can_play = function (arg_9_0)
	local var_9_0, var_9_1 = arg_9_0:_can_play()

	arg_9_0._widgets_by_name.play_button.content.button_hotspot.disable_button = not var_9_0

	local var_9_2 = arg_9_0._widgets_by_name.quickplay_disabled_disclaimer

	var_9_2.content.visible = not var_9_0
	var_9_2.content.text = var_9_1

	if var_9_1 then
		local var_9_3 = Managers.localizer:exists(var_9_1)

		var_9_2.style.text.localize = var_9_3
		var_9_2.style.text_shadow.localize = var_9_3
	end

	local var_9_4 = "versus_quickplay_default"

	if var_9_0 then
		var_9_4 = "versus_quickplay_play"
	end

	if var_9_4 ~= arg_9_0._prev_input_desc then
		arg_9_0._parent:set_input_description(var_9_4)

		arg_9_0._prev_input_desc = var_9_4
	end
end

StartGameWindowVersusQuickplay._handle_input = function (arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._is_focused then
		return
	end

	local var_10_0 = arg_10_0._parent
	local var_10_1 = var_10_0:window_input_service()
	local var_10_2 = Managers.input:is_device_active("mouse")
	local var_10_3 = arg_10_0:_can_play()

	if not var_10_2 then
		local var_10_4 = arg_10_0._input_index
		local var_10_5

		if var_10_1:get("move_down") then
			var_10_4 = var_10_4 + 1
			var_10_5 = 1
		elseif var_10_1:get("move_up") then
			var_10_4 = var_10_4 - 1
			var_10_5 = -1
		else
			var_0_4[var_10_4].update(arg_10_0, var_10_1, var_10_3, arg_10_1, arg_10_2)
		end

		if var_10_4 ~= arg_10_0._input_index then
			arg_10_0:_gamepad_selector_input_func(var_10_4, var_10_5)
		end

		if var_10_3 and var_10_1:get(var_0_5) then
			arg_10_0._parent:play(arg_10_2, "versus_quickplay")
		end
	else
		local var_10_6 = arg_10_0._widgets_by_name

		for iter_10_0 = 1, #var_0_4 do
			local var_10_7 = var_0_4[iter_10_0].widget_name
			local var_10_8 = var_10_6[var_10_7].content.is_selected

			if var_10_7 == "play_button" and arg_10_0:_can_play() then
				if not var_10_8 and UIUtils.is_button_hover_enter(var_10_6.play_button) then
					arg_10_0:_handle_new_selection(iter_10_0)
					arg_10_0:_play_sound("Play_hud_hover")
				end

				if UIUtils.is_button_pressed(var_10_6.play_button) then
					arg_10_0:_option_selected(var_10_7, "play_button", arg_10_2)
				end
			end
		end
	end

	local var_10_9 = true

	if var_10_1:get("right_stick_press", var_10_9) then
		var_10_0:set_window_input_focus("versus_additional_quickplay_settings")
	end
end

StartGameWindowVersusQuickplay._play_sound = function (arg_11_0, arg_11_1)
	return arg_11_0._parent:play_sound(arg_11_1)
end

StartGameWindowVersusQuickplay._can_play = function (arg_12_0)
	if script_data["eac-untrusted"] then
		return false, "versus_disabled_in_modded_realm_disclaimer"
	end

	local var_12_0, var_12_1 = Managers.backend:get_interface("versus"):matchmaking_enabled("quickplay")

	if not var_12_0 then
		var_12_1 = var_12_1 or "Temporarily disabled"

		return false, var_12_1
	end

	return true
end

StartGameWindowVersusQuickplay._option_selected = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_1 == "play_button" then
		arg_13_0._parent:play(arg_13_3, "versus_quickplay")
	else
		ferror("Unknown selector_input_definition: %s", arg_13_1)
	end
end

StartGameWindowVersusQuickplay._verify_selection_index = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._input_index
	local var_14_1 = #var_0_4

	arg_14_1 = math.clamp(arg_14_1, 1, var_14_1)

	if not arg_14_2 then
		return arg_14_1
	end

	local var_14_2 = var_0_4[arg_14_1]

	while var_14_2 and arg_14_1 < var_14_1 and not var_14_2.enter_requirements(arg_14_0) do
		arg_14_1 = arg_14_1 + arg_14_2
		var_14_2 = var_0_4[arg_14_1]
	end

	if var_14_2 and var_14_2.enter_requirements(arg_14_0) then
		var_14_0 = arg_14_1
	end

	return var_14_0
end

StartGameWindowVersusQuickplay._gamepad_selector_input_func = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = Managers.input:is_device_active("mouse")

	arg_15_1 = arg_15_0:_verify_selection_index(arg_15_1, arg_15_2)

	if arg_15_0._input_index ~= arg_15_1 and not var_15_0 then
		arg_15_0._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if arg_15_0._input_index then
			var_0_4[arg_15_0._input_index].on_exit(arg_15_0)
		end

		var_0_4[arg_15_1].on_enter(arg_15_0)
	end

	arg_15_0._input_index = arg_15_1
end

StartGameWindowVersusQuickplay._handle_new_selection = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = #var_0_4

	arg_16_1 = math.clamp(arg_16_1, 1, var_16_0)

	local var_16_1 = arg_16_0._widgets_by_name

	for iter_16_0 = 1, #var_0_4 do
		local var_16_2 = var_16_1[var_0_4[iter_16_0].widget_name]
		local var_16_3 = iter_16_0 == arg_16_1 and arg_16_0._gamepad_active

		var_16_2.content.is_selected = var_16_3
	end

	arg_16_0._input_index = arg_16_1
end

StartGameWindowVersusQuickplay._update_animations = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._ui_animator

	var_17_0:update(arg_17_1)

	if not Managers.input:is_device_active("gamepad") then
		arg_17_0:_update_button_animations(arg_17_1)
	end

	local var_17_1 = arg_17_0._animations

	for iter_17_0, iter_17_1 in pairs(var_17_1) do
		if var_17_0:is_animation_completed(iter_17_1) then
			var_17_0:stop_animation(iter_17_1)

			var_17_1[iter_17_0] = nil
		end
	end

	local var_17_2 = arg_17_0._widgets_by_name

	UIWidgetUtils.animate_play_button(var_17_2.play_button, arg_17_1)
end

StartGameWindowVersusQuickplay._update_button_animations = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._widgets_by_name
end

StartGameWindowVersusQuickplay._draw = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._ui_top_renderer
	local var_19_1 = arg_19_0._ui_scenegraph
	local var_19_2 = arg_19_0._parent:window_input_service()
	local var_19_3 = arg_19_0._render_settings
	local var_19_4

	UIRenderer.begin_pass(var_19_0, var_19_1, var_19_2, arg_19_1, var_19_4, var_19_3)
	UIRenderer.draw_all_widgets(var_19_0, arg_19_0._widgets)
	UIRenderer.end_pass(var_19_0)
end

StartGameWindowVersusQuickplay._update_play_button_texture = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._widgets_by_name

	if arg_20_0._gamepad_active ~= arg_20_1 then
		arg_20_0._gamepad_active = arg_20_1

		if arg_20_1 then
			local var_20_1 = arg_20_0._parent:window_input_service()
			local var_20_2 = "refresh"
			local var_20_3 = UISettings.get_gamepad_input_texture_data(var_20_1, var_20_2, arg_20_1)

			if var_20_3 then
				var_20_0.play_button.content.texture_icon_id = var_20_3.texture
			end
		else
			var_20_0.play_button.content.texture_icon_id = "options_button_icon_quickplay"
		end

		arg_20_0:_handle_new_selection(arg_20_0._input_index)
	end
end
