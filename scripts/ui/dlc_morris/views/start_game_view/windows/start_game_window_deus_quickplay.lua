-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_quickplay.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_quickplay_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.selector_input_definitions
local var_0_5 = "refresh_press"
local var_0_6 = "confirm_press"

StartGameWindowDeusQuickplay = class(StartGameWindowDeusQuickplay)
StartGameWindowDeusQuickplay.NAME = "StartGameWindowDeusQuickplay"

function StartGameWindowDeusQuickplay.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowDeusQuickplay")

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

	arg_1_0._current_difficulty = arg_1_0._parent:get_difficulty_option(true) or Managers.state.difficulty:get_difficulty()
	arg_1_0._dlc_name = nil

	arg_1_0:_update_difficulty_option(arg_1_0._current_difficulty)

	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._show_additional_settings = false
	arg_1_0._previous_can_play = nil

	arg_1_0._parent:change_generic_actions("deus_default")
	arg_1_0:_start_transition_animation("on_enter")
end

function StartGameWindowDeusQuickplay._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function StartGameWindowDeusQuickplay._create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
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

	arg_3_0._widgets_by_name.difficulty_info.content.visible = false
end

function StartGameWindowDeusQuickplay.on_exit(arg_4_0, arg_4_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowDeusQuickplay")

	arg_4_0._ui_animator = nil

	if arg_4_0._play_button_pressed then
		arg_4_1.input_index = nil
	else
		arg_4_1.input_index = arg_4_0._input_index
	end

	arg_4_0._parent:set_difficulty_option(arg_4_0._current_difficulty)
end

function StartGameWindowDeusQuickplay.set_focus(arg_5_0, arg_5_1)
	arg_5_0._is_focused = arg_5_1
end

function StartGameWindowDeusQuickplay.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_can_play()
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_handle_gamepad_activity()
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_draw(arg_6_1)
end

function StartGameWindowDeusQuickplay.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function StartGameWindowDeusQuickplay._handle_gamepad_activity(arg_8_0)
	local var_8_0 = arg_8_0.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not arg_8_0.gamepad_active_last_frame or var_8_0 then
			arg_8_0.gamepad_active_last_frame = true
			arg_8_0._input_index = 1

			local var_8_1 = var_0_4[arg_8_0._input_index]

			if var_8_1 and var_8_1.enter_requirements(arg_8_0) then
				var_8_1.on_enter(arg_8_0)
			end
		end
	elseif arg_8_0.gamepad_active_last_frame or var_8_0 then
		arg_8_0.gamepad_active_last_frame = false

		var_0_4[arg_8_0._input_index].on_exit(arg_8_0)
	end
end

function StartGameWindowDeusQuickplay._update_can_play(arg_9_0)
	local var_9_0 = arg_9_0:_can_play()

	arg_9_0._widgets_by_name.play_button.content.button_hotspot.disable_button = not var_9_0

	local var_9_1 = "deus_default"

	if var_9_0 then
		var_9_1 = "deus_default_play"
	elseif arg_9_0._dlc_locked then
		var_9_1 = "deus_default_buy"
	end

	if var_9_1 ~= arg_9_0._prev_input_desc then
		arg_9_0._parent:set_input_description(var_9_1)

		arg_9_0._prev_input_desc = var_9_1
	end
end

function StartGameWindowDeusQuickplay._handle_input(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._parent
	local var_10_1 = var_10_0:window_input_service()
	local var_10_2 = Managers.input:is_device_active("mouse")

	if not var_10_2 then
		local var_10_3 = arg_10_0._input_index
		local var_10_4

		if var_10_1:get("move_down") then
			var_10_3 = var_10_3 + 1
			var_10_4 = 1
		elseif var_10_1:get("move_up") then
			var_10_3 = var_10_3 - 1
			var_10_4 = -1
		else
			var_0_4[var_10_3].update(arg_10_0, var_10_1, arg_10_1, arg_10_2)
		end

		if var_10_3 ~= arg_10_0._input_index then
			arg_10_0:_gamepad_selector_input_func(var_10_3, var_10_4)
		end

		if var_10_1:get(var_0_6, true) and arg_10_0._dlc_locked then
			Managers.unlock:open_dlc_page(arg_10_0._dlc_name)
		end

		if arg_10_0:_can_play() and var_10_1:get(var_0_5) then
			local var_10_5 = (arg_10_0._parent:get_quickplay_settings(arg_10_0._mechanism_name) or arg_10_0._parent:get_quickplay_settings("adventure")).game_mode_type

			arg_10_0._parent:set_difficulty_option(arg_10_0._current_difficulty)

			arg_10_0._play_button_pressed = true

			arg_10_0._parent:play(arg_10_2, var_10_5)
		end
	else
		local var_10_6 = arg_10_0._widgets_by_name

		for iter_10_0 = 1, #var_0_4 do
			local var_10_7 = var_0_4[iter_10_0].widget_name
			local var_10_8 = var_10_6[var_10_7]
			local var_10_9 = var_10_8.content.is_selected

			if var_10_7 == "difficulty_stepper" then
				if not var_10_9 and UIUtils.is_button_hover_enter(var_10_8, "left_arrow_hotspot") then
					arg_10_0:_handle_new_selection(iter_10_0)
					arg_10_0:_play_sound("Play_hud_hover")
				end

				if not var_10_9 and UIUtils.is_button_hover_enter(var_10_8, "right_arrow_hotspot") then
					arg_10_0:_handle_new_selection(iter_10_0)
					arg_10_0:_play_sound("Play_hud_hover")
				end

				if UIUtils.is_button_hover(var_10_8, "info_hotspot") or UIUtils.is_button_hover(arg_10_0._widgets_by_name.difficulty_info, "widget_hotspot") or not var_10_2 and var_10_9 then
					local var_10_10 = {
						difficulty_info = arg_10_0._widgets_by_name.difficulty_info,
						upsell_button = arg_10_0._widgets_by_name.upsell_button
					}

					if not arg_10_0._diff_info_anim_played then
						arg_10_0._diff_anim_id = arg_10_0._ui_animator:start_animation("difficulty_info_enter", var_10_10, var_0_1)
						arg_10_0._diff_info_anim_played = true
					end

					arg_10_0:_handle_difficulty_info(true)
				else
					if arg_10_0._diff_anim_id then
						arg_10_0._ui_animator:stop_animation(arg_10_0._diff_anim_id)
					end

					arg_10_0._diff_info_anim_played = false
					arg_10_0._widgets_by_name.upsell_button.content.visible = false
					arg_10_0._widgets_by_name.difficulty_info.content.visible = false

					arg_10_0:_handle_difficulty_info(false)
				end

				if UIUtils.is_button_pressed(var_10_8, "left_arrow_hotspot") or var_10_1:get("move_left") then
					arg_10_0:_option_selected(var_10_7, "left_arrow", arg_10_2)
				elseif UIUtils.is_button_pressed(var_10_8, "right_arrow_hotspot") or var_10_1:get("move_right") then
					arg_10_0:_option_selected(var_10_7, "right_arrow", arg_10_2)
				end
			elseif var_10_7 == "play_button" and arg_10_0:_can_play() then
				if not var_10_9 and UIUtils.is_button_hover_enter(var_10_6.play_button) then
					arg_10_0:_handle_new_selection(iter_10_0)
					arg_10_0:_play_sound("Play_hud_hover")
				end

				if UIUtils.is_button_pressed(var_10_6.play_button) then
					arg_10_0:_option_selected(var_10_7, "play_button", arg_10_2)
				end
			end
		end

		local var_10_11 = arg_10_0._widgets_by_name.upsell_button

		if UIUtils.is_button_pressed(var_10_11) then
			Managers.unlock:open_dlc_page(arg_10_0._dlc_name)
		end
	end

	arg_10_0:_update_gamemode_info_text(var_10_1)

	local var_10_12 = true

	if DLCSettings.quick_play_preferences and var_10_1:get("right_stick_press", var_10_12) then
		var_10_0:set_layout_by_name("adventure_level_preferences")
	end
end

function StartGameWindowDeusQuickplay._play_sound(arg_11_0, arg_11_1)
	return arg_11_0._parent:play_sound(arg_11_1)
end

function StartGameWindowDeusQuickplay._can_play(arg_12_0)
	return arg_12_0._current_difficulty ~= nil and not arg_12_0._dlc_locked
end

function StartGameWindowDeusQuickplay._set_info_window(arg_13_0, arg_13_1)
	local var_13_0 = DifficultySettings[arg_13_1]
	local var_13_1 = var_13_0.description
	local var_13_2 = var_13_0.max_chest_power_level
	local var_13_3 = arg_13_0._widgets_by_name.difficulty_info

	var_13_3.content.difficulty_description = Localize(var_13_1)
	var_13_3.content.highest_obtainable_level = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(var_13_2)
end

function StartGameWindowDeusQuickplay._update_difficulty_option(arg_14_0, arg_14_1)
	if arg_14_1 then
		local var_14_0 = DifficultySettings[arg_14_1]
		local var_14_1 = arg_14_0._widgets_by_name.difficulty_stepper

		var_14_1.content.selected_difficulty_text = Localize(var_14_0.display_name)

		local var_14_2 = var_14_0.display_image

		var_14_1.content.difficulty_icon = var_14_2

		arg_14_0:_set_info_window(arg_14_1)

		arg_14_0._current_difficulty = arg_14_1
	end
end

function StartGameWindowDeusQuickplay._option_selected(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if arg_15_1 == "difficulty_stepper" then
		local var_15_0 = arg_15_0._current_difficulty
		local var_15_1 = GameModeSettings.deus.difficulties
		local var_15_2 = table.find(var_15_1, var_15_0) or 1
		local var_15_3 = 0

		if arg_15_2 == "left_arrow" then
			if var_15_2 - 1 >= 1 then
				var_15_3 = var_15_2 - 1

				arg_15_0._parent:play_sound("hud_morris_start_menu_set")
			end
		elseif arg_15_2 == "right_arrow" and var_15_2 + 1 <= #var_15_1 then
			var_15_3 = var_15_2 + 1

			arg_15_0._parent:play_sound("hud_morris_start_menu_set")
		end

		arg_15_0:_update_difficulty_option(var_15_1[var_15_3])
	elseif arg_15_1 == "play_button" then
		local var_15_4 = (arg_15_0._parent:get_quickplay_settings(arg_15_0._mechanism_name) or arg_15_0._parent:get_quickplay_settings("adventure")).game_mode_type

		arg_15_0._parent:set_difficulty_option(arg_15_0._current_difficulty)

		arg_15_0._play_button_pressed = true

		arg_15_0._parent:play(arg_15_3, var_15_4)
	else
		ferror("Unknown selector_input_definition: %s", arg_15_1)
	end
end

function StartGameWindowDeusQuickplay._verify_selection_index(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._input_index
	local var_16_1 = #var_0_4

	arg_16_1 = math.clamp(arg_16_1, 1, var_16_1)

	if not arg_16_2 then
		return arg_16_1
	end

	local var_16_2 = var_0_4[arg_16_1]

	while var_16_2 and arg_16_1 < var_16_1 and not var_16_2.enter_requirements() do
		arg_16_1 = arg_16_1 + arg_16_2
		var_16_2 = var_0_4[arg_16_1]
	end

	if var_16_2 and var_16_2.enter_requirements() then
		var_16_0 = arg_16_1
	end

	return var_16_0
end

function StartGameWindowDeusQuickplay._gamepad_selector_input_func(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = Managers.input:is_device_active("mouse")

	arg_17_1 = arg_17_0:_verify_selection_index(arg_17_1, arg_17_2)

	if arg_17_0._input_index ~= arg_17_1 and not var_17_0 then
		arg_17_0._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if arg_17_0._input_index then
			var_0_4[arg_17_0._input_index].on_exit(arg_17_0)
		end

		var_0_4[arg_17_1].on_enter(arg_17_0)
	end

	arg_17_0._input_index = arg_17_1
end

function StartGameWindowDeusQuickplay._handle_new_selection(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = #var_0_4

	arg_18_1 = math.clamp(arg_18_1, 1, var_18_0)

	local var_18_1 = arg_18_0._widgets_by_name

	for iter_18_0 = 1, #var_0_4 do
		local var_18_2 = var_18_1[var_0_4[iter_18_0].widget_name]
		local var_18_3 = iter_18_0 == arg_18_1

		var_18_2.content.is_selected = var_18_3
	end

	arg_18_0._input_index = arg_18_1
end

function StartGameWindowDeusQuickplay._update_animations(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._ui_animator

	var_19_0:update(arg_19_1)

	if not Managers.input:is_device_active("gamepad") then
		arg_19_0:_update_button_animations(arg_19_1)
	end

	local var_19_1 = arg_19_0._animations

	for iter_19_0, iter_19_1 in pairs(var_19_1) do
		if var_19_0:is_animation_completed(iter_19_1) then
			var_19_0:stop_animation(iter_19_1)

			var_19_1[iter_19_0] = nil
		end
	end
end

function StartGameWindowDeusQuickplay._update_button_animations(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_20_0.upsell_button, arg_20_1)
end

function StartGameWindowDeusQuickplay._draw(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._ui_top_renderer
	local var_21_1 = arg_21_0._ui_scenegraph
	local var_21_2 = arg_21_0._parent:window_input_service()
	local var_21_3 = arg_21_0._render_settings
	local var_21_4

	UIRenderer.begin_pass(var_21_0, var_21_1, var_21_2, arg_21_1, var_21_4, var_21_3)
	UIRenderer.draw_all_widgets(var_21_0, arg_21_0._widgets)
	UIRenderer.end_pass(var_21_0)
end

function StartGameWindowDeusQuickplay._update_difficulty_lock(arg_22_0)
	local var_22_0 = arg_22_0._current_difficulty
	local var_22_1 = arg_22_0._widgets_by_name.difficulty_info
	local var_22_2 = arg_22_0._widgets_by_name.upsell_button

	if var_22_0 then
		local var_22_3, var_22_4, var_22_5, var_22_6 = arg_22_0._parent:is_difficulty_approved(var_22_0)

		if not var_22_3 then
			if var_22_4 then
				var_22_1.content.should_show_diff_lock_text = true
				var_22_1.content.difficulty_lock_text = var_22_4 and Localize(var_22_4) or ""
			else
				var_22_1.content.should_show_diff_lock_text = false
			end

			if var_22_5 then
				var_22_1.content.should_show_dlc_lock = true
				arg_22_0._dlc_locked = var_22_5
				arg_22_0._dlc_name = var_22_5
				var_22_2.content.visible = true
			else
				var_22_1.content.should_show_dlc_lock = false
				var_22_2.content.visible = false
				arg_22_0._dlc_locked = nil
				arg_22_0._dlc_name = nil
			end
		else
			var_22_1.content.should_show_dlc_lock = false
			var_22_1.content.should_show_diff_lock_text = false
			var_22_1.content.should_resize = false
			var_22_2.content.visible = false
			arg_22_0._dlc_locked = nil
			arg_22_0._dlc_name = nil
		end

		arg_22_0._difficulty_approved = var_22_3
	else
		var_22_1.content.should_show_dlc_lock = false
		var_22_2.content.visible = false
	end

	local var_22_7 = arg_22_0:_calculate_difficulty_info_widget_size(var_22_1)
	local var_22_8 = (math.floor(var_22_7) - var_0_1.difficulty_info.size[2]) / 2

	arg_22_0:_resize_difficulty_info({
		math.floor(var_0_1.difficulty_info.size[1]),
		math.floor(var_22_7)
	}, {
		0,
		-var_22_8,
		1
	})

	var_22_2.offset[2] = -math.floor(var_22_7) / 2 + 24
end

function StartGameWindowDeusQuickplay._handle_difficulty_info(arg_23_0, arg_23_1)
	if arg_23_1 then
		arg_23_0:_update_difficulty_lock()
	end
end

function StartGameWindowDeusQuickplay._calculate_difficulty_info_widget_size(arg_24_0, arg_24_1)
	local var_24_0 = 20
	local var_24_1 = arg_24_1.style.difficulty_description
	local var_24_2 = arg_24_1.content.difficulty_description
	local var_24_3 = UIUtils.get_text_height(arg_24_0._ui_renderer, var_24_1.size, var_24_1, var_24_2)

	arg_24_1.content.difficulty_description_text_size = var_24_3

	local var_24_4 = arg_24_1.style.highest_obtainable_level
	local var_24_5 = arg_24_1.content.highest_obtainable_level
	local var_24_6 = UIUtils.get_text_height(arg_24_0._ui_renderer, var_24_4.size, var_24_4, var_24_5) + var_24_0
	local var_24_7 = arg_24_1.style.difficulty_lock_text
	local var_24_8 = arg_24_1.content.difficulty_lock_text
	local var_24_9 = 0

	if arg_24_1.content.should_show_diff_lock_text then
		var_24_9 = UIUtils.get_text_height(arg_24_0._ui_renderer, var_24_7.size, var_24_7, var_24_8) + var_24_0
		arg_24_1.content.difficulty_lock_text_height = var_24_9
	end

	local var_24_10 = arg_24_1.style.dlc_lock_text
	local var_24_11 = arg_24_1.content.dlc_lock_text
	local var_24_12 = 0

	if arg_24_1.content.should_show_dlc_lock then
		var_24_12 = UIUtils.get_text_height(arg_24_0._ui_renderer, var_24_10.size, var_24_10, var_24_11) + var_24_0
	end

	return var_24_6 + var_24_3 + var_24_9 + var_24_12 + 50
end

function StartGameWindowDeusQuickplay._resize_difficulty_info(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._widgets_by_name.difficulty_info

	var_25_0.content.should_resize = true
	var_25_0.content.resize_size = arg_25_1
	var_25_0.content.resize_offset = arg_25_2
	var_25_0.style.widget_hotspot.size = arg_25_1
	var_25_0.style.widget_hotspot.offset = arg_25_2
end

function StartGameWindowDeusQuickplay._update_gamemode_info_text(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0._widgets_by_name.quickplay_gamemode_info_box

	if arg_26_1:get("trigger_cycle_next") and not var_26_0.content.is_showing_info then
		arg_26_0._ui_animator:start_animation("gamemode_text_swap", var_26_0, var_0_1)

		var_26_0.content.is_showing_info = true
	elseif arg_26_1:get("trigger_cycle_next") and var_26_0.content.is_showing_info then
		arg_26_0._ui_animator:start_animation("gamemode_text_swap", var_26_0, var_0_1)

		var_26_0.content.is_showing_info = false
	end

	if UIUtils.is_button_pressed(var_26_0, "info_hotspot") then
		if not var_26_0.content.is_showing_info then
			arg_26_0._ui_animator:start_animation("gamemode_text_swap", var_26_0, var_0_1)

			var_26_0.content.is_showing_info = true
		else
			arg_26_0._ui_animator:start_animation("gamemode_text_swap", var_26_0, var_0_1)

			var_26_0.content.is_showing_info = false
		end
	end
end

function StartGameWindowDeusQuickplay._handle_difficulty_stepper_gamepad(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = {}

	if arg_27_2:get("move_left") and arg_27_1.content.is_selected then
		arg_27_0:_option_selected(arg_27_0._input_index, "left_arrow", arg_27_3)

		arg_27_1.content.left_arrow_pressed = true
		var_27_0.left_key = arg_27_1.style.left_arrow_gamepad_highlight

		if arg_27_0._arrow_anim_id then
			arg_27_0._ui_animator:stop_animation(arg_27_0._arrow_anim_id)

			arg_27_1.style.right_arrow_gamepad_highlight.color[1] = 0
		end

		arg_27_0._arrow_anim_id = arg_27_0._ui_animator:start_animation("left_arrow_flick", arg_27_1, var_0_1, var_27_0)
	elseif arg_27_2:get("move_right") and arg_27_1.content.is_selected then
		arg_27_0:_option_selected(arg_27_0._input_index, "right_arrow", arg_27_3)

		arg_27_1.content.right_arrow_pressed = true
		var_27_0.right_key = arg_27_1.style.right_arrow_gamepad_highlight

		if arg_27_0._arrow_anim_id then
			arg_27_0._ui_animator:stop_animation(arg_27_0._arrow_anim_id)

			arg_27_1.style.left_arrow_gamepad_highlight.color[1] = 0
		end

		arg_27_0._arrow_anim_id = arg_27_0._ui_animator:start_animation("right_arrow_flick", arg_27_1, var_0_1, var_27_0)
	end
end
