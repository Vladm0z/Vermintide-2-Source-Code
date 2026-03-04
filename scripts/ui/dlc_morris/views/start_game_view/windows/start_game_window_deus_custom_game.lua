-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_custom_game.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_custom_game_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.selection_widgets
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.selector_input_definitions

StartGameWindowDeusCustomGame = class(StartGameWindowDeusCustomGame)
StartGameWindowDeusCustomGame.NAME = "StartGameWindowDeusCustomGame"

local var_0_6 = "refresh_press"

function StartGameWindowDeusCustomGame.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowDeusCustomGame")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._mechanism_name = Managers.mechanism:current_mechanism_name()
	arg_1_0._stats_id = Managers.player:local_player():stats_id()
	arg_1_0._expeditions_selection_index = 1
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._previous_can_play = nil
	arg_1_0._is_offline = Managers.account:offline_mode()
	arg_1_0._animations = {}
	arg_1_0._dlc_name = nil
	arg_1_0._current_difficulty = arg_1_0._parent:get_difficulty_option(true) or Managers.state.difficulty:get_difficulty()
	arg_1_0._backend_deus = Managers.backend:get_interface("deus")

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_gamepad_selector_input_func(arg_1_1.input_index or 1)
	arg_1_0:_update_expedition_option()
	arg_1_0:_update_difficulty_option(arg_1_0._current_difficulty)
	arg_1_0:_update_can_play()

	if arg_1_0._is_offline then
		arg_1_0._parent:change_generic_actions("default_deus_custom_game_offline")
	else
		arg_1_0._parent:change_generic_actions("default_deus_custom_game")
	end

	arg_1_0:_start_transition_animation("on_enter")
	Managers.state.event:register(arg_1_0, "_update_additional_curse_frame", "_update_additional_curse_frame")
end

function StartGameWindowDeusCustomGame._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

local function var_0_7(arg_3_0, arg_3_1)
	return arg_3_0.remaining_time - (arg_3_1 - arg_3_0.time_of_update) < 0
end

function StartGameWindowDeusCustomGame._create_ui_elements(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = UISceneGraph.init_scenegraph(var_0_1)

	arg_4_0._ui_scenegraph = var_4_0
	arg_4_0._widgets, arg_4_0._widgets_by_name = UIUtils.create_widgets(var_0_2)
	arg_4_0._selection_widgets, arg_4_0._selection_widgets_by_name = UIUtils.create_widgets(var_0_3)

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_top_renderer)

	arg_4_0._ui_animator = UIAnimator:new(var_4_0, var_0_4)

	if arg_4_2 then
		local var_4_1 = var_4_0.window.local_position

		var_4_1[1] = var_4_1[1] + arg_4_2[1]
		var_4_1[2] = var_4_1[2] + arg_4_2[2]
		var_4_1[3] = var_4_1[3] + arg_4_2[3]
	end

	arg_4_0._widgets_by_name.difficulty_info.content.visible = false
	arg_4_0._widgets_by_name.upsell_button.content.visible = false

	arg_4_0:_gather_unlocked_journeys()
	arg_4_0:_setup_journey_widgets()
	arg_4_0:_refresh_journey_cycle()
end

function StartGameWindowDeusCustomGame.on_exit(arg_5_0, arg_5_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowDeusCustomGame")

	arg_5_0._ui_animator = nil

	if arg_5_0._play_button_pressed then
		arg_5_1.input_index = nil
	else
		arg_5_1.input_index = arg_5_0._input_index
	end

	arg_5_0._parent:set_difficulty_option(arg_5_0._current_difficulty)
	Managers.state.event:unregister("_update_additional_curse_frame", arg_5_0)
end

function StartGameWindowDeusCustomGame.set_focus(arg_6_0, arg_6_1)
	arg_6_0._is_focused = arg_6_1
end

function StartGameWindowDeusCustomGame.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function StartGameWindowDeusCustomGame._can_play(arg_8_0)
	local var_8_0 = arg_8_0._parent:get_selected_level_id()

	if not (var_8_0 ~= nil and not arg_8_0._dlc_locked) then
		return false
	end

	if LevelUnlockUtils.is_journey_disabled(var_8_0) then
		return false
	end

	local var_8_1 = arg_8_0._journey_cycle.journey_data[var_8_0].dominant_god

	return not LevelUnlockUtils.is_chaos_waste_god_disabled(var_8_1)
end

function StartGameWindowDeusCustomGame._update_can_play(arg_9_0)
	local var_9_0 = arg_9_0:_can_play()

	arg_9_0._selection_widgets_by_name.play_button.content.button_hotspot.disable_button = not var_9_0

	local var_9_1 = arg_9_0._is_offline and "default_deus_custom_game_offline" or "default_deus_custom_game"

	if var_9_0 then
		var_9_1 = arg_9_0._is_offline and "default_deus_custom_game_offline_play" or "default_deus_custom_game_play"
	elseif arg_9_0._dlc_locked then
		var_9_1 = arg_9_0._is_offline and "default_deus_custom_game_offline_buy" or "default_deus_custom_game_buy"
	end

	if var_9_1 ~= arg_9_0._prev_input_desc then
		arg_9_0._parent:set_input_description(var_9_1)

		arg_9_0._prev_input_desc = var_9_1
	end
end

function StartGameWindowDeusCustomGame._gather_unlocked_journeys(arg_10_0)
	local var_10_0 = {}

	for iter_10_0, iter_10_1 in ipairs(LevelUnlockUtils.unlocked_journeys(arg_10_0._statistics_db, arg_10_0._stats_id)) do
		var_10_0[iter_10_1] = true
	end

	local var_10_1 = arg_10_0._backend_deus:get_journey_cycle().journey_data

	for iter_10_2, iter_10_3 in pairs(var_10_0) do
		if LevelUnlockUtils.is_chaos_waste_god_disabled(var_10_1[iter_10_2].dominant_god) then
			var_10_0[iter_10_2] = nil
		end
	end

	arg_10_0._unlocked_journeys = var_10_0
end

function StartGameWindowDeusCustomGame._setup_journey_widgets(arg_11_0)
	local var_11_0 = arg_11_0._node_widgets
	local var_11_1 = arg_11_0._statistics_db
	local var_11_2 = arg_11_0._stats_id
	local var_11_3 = arg_11_0._unlocked_journeys
	local var_11_4 = {}
	local var_11_5 = -365
	local var_11_6 = var_0_0.journey_widget_settings
	local var_11_7 = AvailableJourneyOrder

	for iter_11_0 = 1, #var_11_7 do
		local var_11_8 = AvailableJourneyOrder[iter_11_0]
		local var_11_9 = arg_11_0._backend_deus:deus_journey_with_belakor(var_11_8)
		local var_11_10 = DeusJourneySettings[var_11_8]
		local var_11_11 = #var_11_4 + 1
		local var_11_12 = var_11_7[var_11_11 + 1]
		local var_11_13 = UIWidgets.create_expedition_widget_func("level_root_node", var_11_11, var_11_10, var_11_8)
		local var_11_14 = UIWidget.init(var_11_13)
		local var_11_15 = var_11_14.content

		var_11_15.text = Localize(var_11_10.display_name)
		var_11_5 = var_11_5 + (var_11_6.width + var_11_6.spacing_x)

		local var_11_16 = var_11_14.offset

		var_11_16[1] = var_11_5
		var_11_16[2] = 0

		local var_11_17 = LevelUnlockUtils.completed_journey_difficulty_index(var_11_1, var_11_2, var_11_8)
		local var_11_18 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_11_17)
		local var_11_19 = var_11_3[var_11_8]

		var_11_15.level_icon = var_11_10.level_image
		var_11_15.locked = not var_11_19
		var_11_15.frame = var_11_18
		var_11_15.journey_name = var_11_8
		var_11_15.level_icon_frame = var_11_9 and "morris_expedition_select_border_belakor" or "morris_expedition_select_border"
		var_11_15.draw_path = var_11_12 ~= nil
		var_11_15.draw_path_fill = var_11_3[var_11_12]
		var_11_14.style.path.texture_size[1] = var_11_6.spacing_x
		var_11_14.style.path_glow.texture_size[1] = var_11_6.spacing_x
		var_11_4[var_11_11] = var_11_14
		var_11_5 = var_11_5 + var_11_6.spacing_x
	end

	arg_11_0._expedition_widgets = var_11_4
end

function StartGameWindowDeusCustomGame._set_info_window(arg_12_0, arg_12_1)
	local var_12_0 = DifficultySettings[arg_12_1]
	local var_12_1 = var_12_0.description
	local var_12_2 = var_12_0.max_chest_power_level
	local var_12_3 = arg_12_0._widgets_by_name.difficulty_info

	var_12_3.content.difficulty_description = Localize(var_12_1)
	var_12_3.content.highest_obtainable_level = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(var_12_2)
end

function StartGameWindowDeusCustomGame._update_difficulty_option(arg_13_0, arg_13_1)
	if arg_13_1 then
		local var_13_0 = DifficultySettings[arg_13_1]
		local var_13_1 = arg_13_0._selection_widgets_by_name.difficulty_stepper

		var_13_1.content.selected_difficulty_text = Localize(var_13_0.display_name)

		local var_13_2 = var_13_0.display_image

		var_13_1.content.difficulty_icon = var_13_2

		arg_13_0:_set_info_window(arg_13_1)

		arg_13_0._current_difficulty = arg_13_1
	end
end

function StartGameWindowDeusCustomGame._option_selected(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0._parent
	local var_14_1 = var_14_0:get_custom_game_settings(arg_14_0._mechanism_name) or var_14_0:get_custom_game_settings("adventure")

	if arg_14_1 == "difficulty_stepper" then
		local var_14_2 = arg_14_0._current_difficulty
		local var_14_3 = GameModeSettings.deus.difficulties
		local var_14_4 = table.find(var_14_3, var_14_2)
		local var_14_5 = 0

		if arg_14_2 == "left_arrow" then
			if var_14_4 - 1 >= 1 then
				var_14_5 = var_14_4 - 1

				arg_14_0._parent:play_sound("hud_morris_start_menu_set")
			end
		elseif arg_14_2 == "right_arrow" and var_14_4 + 1 <= #var_14_3 then
			var_14_5 = var_14_4 + 1

			arg_14_0._parent:play_sound("hud_morris_start_menu_set")
		end

		arg_14_0:_update_difficulty_option(var_14_3[var_14_5])
	elseif arg_14_1 == "play_button" then
		arg_14_0._play_button_pressed = true

		arg_14_0._parent:set_difficulty_option(arg_14_0._current_difficulty)
		arg_14_0._parent:play(arg_14_3, var_14_1.game_mode_type)
	end
end

function StartGameWindowDeusCustomGame._update_modifiers(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._journey_cycle

	if not var_15_0 or var_0_7(var_15_0, arg_15_1) then
		arg_15_0:_refresh_journey_cycle()
	end
end

function StartGameWindowDeusCustomGame._update_modifier_timer(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._journey_cycle
	local var_16_1 = var_16_0.remaining_time - (arg_16_1 - var_16_0.time_of_update)

	if var_16_1 < 0 then
		var_16_1 = 0
	end

	local var_16_2 = math.floor
	local var_16_3 = var_16_2(var_16_1 / 86400)
	local var_16_4 = var_16_2(var_16_1 / 3600)
	local var_16_5 = var_16_2(var_16_1 / 60) % 60
	local var_16_6 = arg_16_0._widgets_by_name.modifier_timer.content

	if var_16_5 > 0 then
		local var_16_7 = Localize("deus_start_game_mod_timer")

		var_16_6.time_text = string.format(var_16_7, var_16_3, var_16_4, var_16_5)
	else
		local var_16_8 = var_16_2(var_16_1)
		local var_16_9 = Localize("deus_start_game_mod_timer_seconds")

		var_16_6.time_text = string.format(var_16_9, var_16_8)
	end
end

function StartGameWindowDeusCustomGame._refresh_journey_cycle(arg_17_0)
	arg_17_0._journey_cycle = arg_17_0._backend_deus:get_journey_cycle()

	arg_17_0:_update_journey_god_icons()
end

function StartGameWindowDeusCustomGame._update_additional_curse_frame(arg_18_0, arg_18_1)
	for iter_18_0, iter_18_1 in ipairs(arg_18_0._expedition_widgets) do
		local var_18_0 = iter_18_1.content

		var_18_0.level_icon_frame = var_18_0.journey_name == arg_18_1 and "morris_expedition_select_border_belakor" or "morris_expedition_select_border"
	end
end

function StartGameWindowDeusCustomGame._update_journey_god_icons(arg_19_0)
	local var_19_0 = arg_19_0._journey_cycle

	for iter_19_0, iter_19_1 in ipairs(arg_19_0._expedition_widgets) do
		local var_19_1 = iter_19_1.content
		local var_19_2 = var_19_0.journey_data[var_19_1.journey_name].dominant_god

		var_19_1.theme_icon = DeusThemeSettings[var_19_2].text_icon
	end
end

function StartGameWindowDeusCustomGame.update(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = Managers.time:time("main")

	arg_20_0:_update_modifiers(var_20_0)
	arg_20_0:_update_can_play()
	arg_20_0:_update_animations(arg_20_1, arg_20_2)
	arg_20_0:_handle_gamepad_activity()

	if arg_20_0._is_focused then
		arg_20_0:_handle_input(arg_20_1, arg_20_2)
	end

	arg_20_0:_draw(arg_20_1)
end

function StartGameWindowDeusCustomGame._verify_selection_index(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._input_index
	local var_21_1 = #var_0_5

	arg_21_1 = math.clamp(arg_21_1, 1, var_21_1)

	if not arg_21_2 then
		return arg_21_1
	end

	local var_21_2 = var_0_5[arg_21_1]

	while var_21_2 and arg_21_1 < var_21_1 and not var_21_2.enter_requirements(arg_21_0) do
		arg_21_1 = arg_21_1 + arg_21_2
		var_21_2 = var_0_5[arg_21_1]
	end

	if var_21_2 and var_21_2.enter_requirements(arg_21_0) then
		var_21_0 = arg_21_1
	end

	return var_21_0
end

function StartGameWindowDeusCustomGame._gamepad_selector_input_func(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = Managers.input:is_device_active("mouse")

	arg_22_1 = arg_22_0:_verify_selection_index(arg_22_1, arg_22_2)

	if arg_22_0._input_index ~= arg_22_1 and not var_22_0 then
		arg_22_0._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if arg_22_0._input_index then
			var_0_5[arg_22_0._input_index].on_exit(arg_22_0)
		end

		var_0_5[arg_22_1].on_enter(arg_22_0)
	end

	arg_22_0._input_index = arg_22_1
end

function StartGameWindowDeusCustomGame._update_animations(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0._ui_animator

	var_23_0:update(arg_23_1)

	local var_23_1 = arg_23_0._animations

	for iter_23_0, iter_23_1 in pairs(var_23_1) do
		if var_23_0:is_animation_completed(iter_23_1) then
			var_23_0:stop_animation(iter_23_1)

			var_23_1[iter_23_0] = nil
		end
	end

	local var_23_2 = arg_23_0._selection_widgets_by_name
	local var_23_3 = arg_23_0._expedition_widgets

	for iter_23_2 = 1, #var_23_3 do
		local var_23_4 = var_23_3[iter_23_2]

		arg_23_0:_animate_expedition_widget(var_23_4, arg_23_1)
	end
end

function StartGameWindowDeusCustomGame._draw(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._ui_top_renderer
	local var_24_1 = arg_24_0._ui_scenegraph
	local var_24_2 = arg_24_0._parent:window_input_service()
	local var_24_3 = arg_24_0._render_settings
	local var_24_4

	UIRenderer.begin_pass(var_24_0, var_24_1, var_24_2, arg_24_1, var_24_4, var_24_3)

	local var_24_5 = arg_24_0._widgets

	for iter_24_0 = 1, #var_24_5 do
		local var_24_6 = var_24_5[iter_24_0]

		UIRenderer.draw_widget(var_24_0, var_24_6)
	end

	local var_24_7 = arg_24_0._expedition_widgets

	for iter_24_1 = 1, #var_24_7 do
		local var_24_8 = var_24_7[iter_24_1]

		UIRenderer.draw_widget(var_24_0, var_24_8)
	end

	local var_24_9 = arg_24_0._selection_widgets

	for iter_24_2 = 1, #var_24_9 do
		local var_24_10 = var_24_9[iter_24_2]

		UIRenderer.draw_widget(var_24_0, var_24_10)
	end

	UIRenderer.end_pass(var_24_0)
end

function StartGameWindowDeusCustomGame._animate_expedition_widget(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_1.content.button_hotspot
	local var_25_1 = var_25_0.is_selected
	local var_25_2 = var_25_0.selected_progress or 0
	local var_25_3 = 1.5

	if var_25_1 then
		var_25_2 = math.min(var_25_2 + var_25_3 * arg_25_2, 1)
	else
		var_25_2 = math.max(var_25_2 - var_25_3 * arg_25_2, 0)
	end

	arg_25_1.style.purple_glow.color[1] = 255 * var_25_2
	var_25_0.selected_progress = var_25_2
end

function StartGameWindowDeusCustomGame._handle_input(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._parent
	local var_26_1 = var_26_0:window_input_service()

	if not Managers.input:is_device_active("mouse") then
		local var_26_2 = arg_26_0._input_index
		local var_26_3

		if var_26_1:get("move_down") then
			var_26_2 = var_26_2 + 1
			var_26_3 = 1
		elseif var_26_1:get("move_up") then
			var_26_2 = var_26_2 - 1
			var_26_3 = -1
		else
			var_0_5[var_26_2].update(arg_26_0, var_26_1, arg_26_1, arg_26_2)
		end

		if var_26_2 ~= arg_26_0._input_index then
			arg_26_0:_gamepad_selector_input_func(var_26_2, var_26_3)
		end

		local var_26_4 = true

		if var_26_1:get("right_stick_press", var_26_4) and not arg_26_0._is_offline then
			var_26_0:set_window_input_focus("deus_additional_settings")
		end
	else
		local var_26_5 = arg_26_0._selection_widgets_by_name

		for iter_26_0, iter_26_1 in pairs(var_26_5) do
			if iter_26_0 == "difficulty_stepper" then
				if UIUtils.is_button_pressed(iter_26_1, "left_arrow_hotspot") then
					arg_26_0:_option_selected(iter_26_0, "left_arrow", arg_26_2)
				elseif UIUtils.is_button_pressed(iter_26_1, "right_arrow_hotspot") then
					arg_26_0:_option_selected(iter_26_0, "right_arrow", arg_26_2)
				end

				if UIUtils.is_button_hover(iter_26_1, "info_hotspot") or UIUtils.is_button_hover(arg_26_0._widgets_by_name.difficulty_info, "widget_hotspot") then
					local var_26_6 = {
						difficulty_info = arg_26_0._widgets_by_name.difficulty_info,
						upsell_button = arg_26_0._widgets_by_name.upsell_button
					}

					if not arg_26_0.diff_info_anim_played then
						arg_26_0._diff_anim_id = arg_26_0._ui_animator:start_animation("difficulty_info_enter", var_26_6, var_0_1)
						arg_26_0.diff_info_anim_played = true
					end

					arg_26_0:_update_difficulty_lock()
				else
					if arg_26_0._diff_anim_id then
						arg_26_0._ui_animator:stop_animation(arg_26_0._diff_anim_id)
					end

					arg_26_0.diff_info_anim_played = false
					arg_26_0._widgets_by_name.upsell_button.content.visible = false
					arg_26_0._widgets_by_name.difficulty_info.content.visible = false
				end
			elseif UIUtils.is_button_pressed(iter_26_1) then
				arg_26_0:_option_selected(iter_26_0, nil, arg_26_2)
			end

			if iter_26_0 == "difficulty_stepper" then
				iter_26_1.content.is_selected = UIUtils.is_button_hover(iter_26_1, "left_arrow_hotspot") or UIUtils.is_button_hover(iter_26_1, "right_arrow_hotspot")
			else
				iter_26_1.content.is_selected = UIUtils.is_button_hover(iter_26_1)
			end
		end

		local var_26_7 = arg_26_0._expedition_widgets[arg_26_0._expeditions_selection_index]

		for iter_26_2 = 1, #arg_26_0._expedition_widgets do
			local var_26_8 = arg_26_0._expedition_widgets[iter_26_2]

			if UIUtils.is_button_pressed(var_26_8) then
				if var_26_7 then
					var_26_7.content.button_hotspot.is_selected = nil
				end

				var_26_8.content.button_hotspot.is_selected = true

				local var_26_9 = var_26_8.content.journey_name

				var_26_0:set_selected_level_id(var_26_9)

				arg_26_0._expeditions_selection_index = iter_26_2

				arg_26_0:_play_sound("play_gui_lobby_button_01_difficulty_select_normal")
			end

			if UIUtils.is_button_hover_enter(var_26_8) then
				arg_26_0._parent:play_sound("Play_hud_hover")
			end
		end
	end

	arg_26_0:_update_gamemode_info_text(var_26_1)

	local var_26_10 = arg_26_0._widgets_by_name.upsell_button

	if UIUtils.is_button_pressed(var_26_10) then
		Managers.unlock:open_dlc_page(arg_26_0._dlc_name)
	end

	if arg_26_0:_can_play() then
		local var_26_11 = arg_26_0._selection_widgets_by_name.play_button

		if UIUtils.is_button_hover_enter(var_26_11) then
			arg_26_0._parent:play_sound("Play_hud_hover")
		end

		if var_26_1:get(var_0_6) or UIUtils.is_button_pressed(var_26_11) then
			arg_26_0._play_button_pressed = true

			local var_26_12 = var_26_0:get_custom_game_settings(arg_26_0._mechanism_name) or var_26_0:get_custom_game_settings("adventure")

			arg_26_0._parent:set_difficulty_option(arg_26_0._current_difficulty)
			var_26_0:play(arg_26_2, var_26_12.game_mode_type)
		end
	end
end

function StartGameWindowDeusCustomGame.handle_expedition_input(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	return
end

function StartGameWindowDeusCustomGame.handle_difficulty_input(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	return
end

function StartGameWindowDeusCustomGame._play_sound(arg_29_0, arg_29_1)
	arg_29_0._parent:play_sound(arg_29_1)
end

function StartGameWindowDeusCustomGame._update_expedition_option(arg_30_0)
	local var_30_0 = arg_30_0._parent:get_selected_level_id()

	if not var_30_0 then
		return
	end

	local var_30_1 = LevelSettings[var_30_0]
	local var_30_2 = var_30_1.display_name
	local var_30_3 = var_30_1.level_image
	local var_30_4 = arg_30_0._parent:get_completed_level_difficulty_index(arg_30_0._statistics_db, arg_30_0._stats_id, var_30_0)

	for iter_30_0 = 1, #arg_30_0._expedition_widgets do
		local var_30_5 = arg_30_0._expedition_widgets[iter_30_0].content

		if var_30_0 == var_30_5.journey_name then
			var_30_5.button_hotspot.is_selected = true
			arg_30_0._expeditions_selection_index = iter_30_0

			break
		end
	end
end

function StartGameWindowDeusCustomGame._handle_gamepad_activity(arg_31_0)
	local var_31_0 = arg_31_0.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not arg_31_0.gamepad_active_last_frame or var_31_0 then
			arg_31_0.gamepad_active_last_frame = true
			arg_31_0._input_index = 1

			local var_31_1 = var_0_5[arg_31_0._input_index]

			if var_31_1 and var_31_1.enter_requirements(arg_31_0) then
				var_31_1.on_enter(arg_31_0)
			end
		end
	elseif arg_31_0.gamepad_active_last_frame or var_31_0 then
		arg_31_0.gamepad_active_last_frame = false

		var_0_5[arg_31_0._input_index].on_exit(arg_31_0)
	end
end

function StartGameWindowDeusCustomGame._update_gamemode_info_text(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._widgets_by_name.custom_gamemode_info_box

	if arg_32_1:get("trigger_cycle_next") and not var_32_0.content.is_showing_info then
		arg_32_0._ui_animator:start_animation("gamemode_text_swap", var_32_0, var_0_1)

		var_32_0.content.is_showing_info = true
	elseif arg_32_1:get("trigger_cycle_next") and var_32_0.content.is_showing_info then
		arg_32_0._ui_animator:start_animation("gamemode_text_swap", var_32_0, var_0_1)

		var_32_0.content.is_showing_info = false
	end

	if UIUtils.is_button_pressed(var_32_0, "info_hotspot") then
		if not var_32_0.content.is_showing_info then
			arg_32_0._ui_animator:start_animation("gamemode_text_swap", var_32_0, var_0_1)

			var_32_0.content.is_showing_info = true
		else
			arg_32_0._ui_animator:start_animation("gamemode_text_swap", var_32_0, var_0_1)

			var_32_0.content.is_showing_info = false
		end
	end
end

function StartGameWindowDeusCustomGame._update_difficulty_lock(arg_33_0)
	local var_33_0 = arg_33_0._current_difficulty
	local var_33_1 = arg_33_0._widgets_by_name.difficulty_info
	local var_33_2 = arg_33_0._widgets_by_name.upsell_button

	if var_33_0 then
		local var_33_3, var_33_4, var_33_5, var_33_6 = arg_33_0._parent:is_difficulty_approved(var_33_0)

		if not var_33_3 then
			if var_33_4 then
				var_33_1.content.should_show_diff_lock_text = true
				var_33_1.content.difficulty_lock_text = var_33_4 and Localize(var_33_4) or ""
			else
				var_33_1.content.should_show_diff_lock_text = false
			end

			if var_33_5 then
				var_33_1.content.should_show_dlc_lock = true
				arg_33_0._dlc_locked = var_33_5
				arg_33_0._dlc_name = var_33_5
				var_33_2.content.visible = true
			else
				var_33_1.content.should_show_dlc_lock = false
				var_33_2.content.visible = false
				arg_33_0._dlc_locked = nil
				arg_33_0._dlc_name = nil
			end
		else
			var_33_1.content.should_show_dlc_lock = false
			var_33_1.content.should_show_diff_lock_text = false
			var_33_1.content.should_resize = false
			var_33_2.content.visible = false
			arg_33_0._dlc_locked = nil
			arg_33_0._dlc_name = nil
		end

		arg_33_0._difficulty_approved = var_33_3
	else
		var_33_1.content.should_show_dlc_lock = false
		var_33_2.content.visible = false
	end

	local var_33_7 = arg_33_0:_calculate_difficulty_info_widget_size(var_33_1)
	local var_33_8 = (math.floor(var_33_7) - var_0_1.difficulty_info.size[2]) / 2

	arg_33_0:_resize_difficulty_info({
		math.floor(var_0_1.difficulty_info.size[1]),
		math.floor(var_33_7)
	}, {
		0,
		-var_33_8,
		1
	})

	var_33_2.offset[2] = -math.floor(var_33_7) / 2 + 24
end

function StartGameWindowDeusCustomGame._calculate_difficulty_info_widget_size(arg_34_0, arg_34_1)
	local var_34_0 = 20
	local var_34_1 = arg_34_1.style.difficulty_description
	local var_34_2 = arg_34_1.content.difficulty_description
	local var_34_3 = UIUtils.get_text_height(arg_34_0._ui_renderer, var_34_1.size, var_34_1, var_34_2)

	arg_34_1.content.difficulty_description_text_size = var_34_3

	local var_34_4 = arg_34_1.style.highest_obtainable_level
	local var_34_5 = arg_34_1.content.highest_obtainable_level
	local var_34_6 = UIUtils.get_text_height(arg_34_0._ui_renderer, var_34_4.size, var_34_4, var_34_5) + var_34_0
	local var_34_7 = arg_34_1.style.difficulty_lock_text
	local var_34_8 = arg_34_1.content.difficulty_lock_text
	local var_34_9 = 0

	if arg_34_1.content.should_show_diff_lock_text then
		var_34_9 = UIUtils.get_text_height(arg_34_0._ui_renderer, var_34_7.size, var_34_7, var_34_8) + var_34_0
		arg_34_1.content.difficulty_lock_text_height = var_34_9
	end

	local var_34_10 = arg_34_1.style.dlc_lock_text
	local var_34_11 = arg_34_1.content.dlc_lock_text
	local var_34_12 = 0

	if arg_34_1.content.should_show_dlc_lock then
		var_34_12 = UIUtils.get_text_height(arg_34_0._ui_renderer, var_34_10.size, var_34_10, var_34_11) + var_34_0
	end

	return var_34_6 + var_34_3 + var_34_9 + var_34_12 + 50
end

function StartGameWindowDeusCustomGame._resize_difficulty_info(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0._widgets_by_name.difficulty_info

	var_35_0.content.should_resize = true
	var_35_0.content.resize_size = arg_35_1
	var_35_0.content.resize_offset = arg_35_2
	var_35_0.style.widget_hotspot.size = arg_35_1
	var_35_0.style.widget_hotspot.offset = arg_35_2
end
