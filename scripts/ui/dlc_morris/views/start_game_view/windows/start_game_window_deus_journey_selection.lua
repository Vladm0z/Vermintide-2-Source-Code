-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_journey_selection.lua

require("scripts/settings/dlcs/morris/deus_theme_settings")

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_journey_selection_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.node_widgets
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.journey_widget_settings
local var_0_6 = "confirm_press"

local function var_0_7(arg_1_0, arg_1_1)
	return arg_1_0.remaining_time - (arg_1_1 - arg_1_0.time_of_update) < 0
end

StartGameWindowDeusJourneySelection = class(StartGameWindowDeusJourneySelection)
StartGameWindowDeusJourneySelection.NAME = "StartGameWindowDeusJourneySelection"

StartGameWindowDeusJourneySelection.on_enter = function (arg_2_0, arg_2_1, arg_2_2)
	print("[StartGameWindow] Enter Substate StartGameWindowDeusJourneySelection")

	local var_2_0 = arg_2_1.ingame_ui_context
	local var_2_1 = Managers.player

	arg_2_0._stats_id = var_2_1:local_player():stats_id()
	arg_2_0.player_manager = var_2_1
	arg_2_0.peer_id = var_2_0.peer_id
	arg_2_0.parent = arg_2_1.parent
	arg_2_0.ui_renderer = var_2_0.ui_renderer
	arg_2_0._ui_top_renderer = var_2_0.ui_top_renderer
	arg_2_0.input_manager = var_2_0.input_manager
	arg_2_0.statistics_db = var_2_0.statistics_db
	arg_2_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_2_0._unlocked_journeys = arg_2_0:_get_unlocked_journeys()
	arg_2_0._animations = {}

	arg_2_0:create_ui_elements(arg_2_1, arg_2_2)
	arg_2_0:_set_presentation_info()
	arg_2_0:_setup_journey_widgets()
	arg_2_0:_refresh_journey_cycle()
	arg_2_0:_update_selected_journey()
	arg_2_0:_setup_grid_navigation()
	arg_2_0:_start_transition_animation("on_enter")
end

StartGameWindowDeusJourneySelection._start_transition_animation = function (arg_3_0, arg_3_1)
	local var_3_0 = {
		render_settings = arg_3_0.render_settings
	}
	local var_3_1 = {}
	local var_3_2 = arg_3_0.ui_animator:start_animation(arg_3_1, var_3_1, var_0_3, var_3_0)

	arg_3_0._animations[arg_3_1] = var_3_2
end

StartGameWindowDeusJourneySelection.create_ui_elements = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = UISceneGraph.init_scenegraph(var_0_3)

	arg_4_0.ui_scenegraph = var_4_0

	local var_4_1 = {}
	local var_4_2 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_3 = UIWidget.init(iter_4_1)

		var_4_1[#var_4_1 + 1] = var_4_3
		var_4_2[iter_4_0] = var_4_3
	end

	arg_4_0._widgets = var_4_1
	arg_4_0._widgets_by_name = var_4_2

	local var_4_4 = {}
	local var_4_5 = {}

	for iter_4_2, iter_4_3 in pairs(var_0_2) do
		local var_4_6 = UIWidget.init(iter_4_3)

		var_4_4[#var_4_4 + 1] = var_4_6
		var_4_5[iter_4_2] = var_4_6
	end

	arg_4_0._node_widgets = var_4_4
	arg_4_0._node_widgets_by_name = var_4_5

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(var_4_0, var_0_4)

	if arg_4_2 then
		local var_4_7 = var_4_0.window.local_position

		var_4_7[1] = var_4_7[1] + arg_4_2[1]
		var_4_7[2] = var_4_7[2] + arg_4_2[2]
		var_4_7[3] = var_4_7[3] + arg_4_2[3]
	end
end

StartGameWindowDeusJourneySelection._get_unlocked_journeys = function (arg_5_0)
	local var_5_0 = {}

	for iter_5_0, iter_5_1 in ipairs(LevelUnlockUtils.unlocked_journeys(arg_5_0.statistics_db, arg_5_0._stats_id)) do
		var_5_0[iter_5_1] = true
	end

	return var_5_0
end

StartGameWindowDeusJourneySelection._setup_journey_widgets = function (arg_6_0)
	local var_6_0 = arg_6_0._node_widgets
	local var_6_1 = arg_6_0.statistics_db
	local var_6_2 = arg_6_0._stats_id
	local var_6_3 = arg_6_0._unlocked_journeys
	local var_6_4 = {}
	local var_6_5 = -365
	local var_6_6 = var_0_5
	local var_6_7 = AvailableJourneyOrder

	for iter_6_0, iter_6_1 in ipairs(var_6_7) do
		local var_6_8 = DeusJourneySettings[iter_6_1]
		local var_6_9 = #var_6_4 + 1
		local var_6_10 = var_6_7[var_6_9 + 1]
		local var_6_11 = var_6_0[var_6_9]
		local var_6_12 = var_6_11.content

		var_6_12.text = Localize(var_6_8.display_name)

		local var_6_13 = var_6_6.width + var_6_6.spacing_x

		var_6_5 = var_6_5 + var_6_13

		local var_6_14 = var_6_11.offset

		var_6_14[1] = var_6_5
		var_6_14[2] = 0

		local var_6_15 = LevelUnlockUtils.completed_journey_difficulty_index(var_6_1, var_6_2, iter_6_1)
		local var_6_16 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_6_15)
		local var_6_17 = var_6_3[iter_6_1]

		var_6_12.icon = var_6_8.level_image
		var_6_12.locked = not var_6_17
		var_6_12.frame = var_6_16
		var_6_12.journey_name = iter_6_1
		var_6_12.draw_path = var_6_10 ~= nil
		var_6_12.draw_path_fill = var_6_3[var_6_10]
		var_6_11.style.path.texture_size[1] = var_6_13
		var_6_11.style.path_glow.texture_size[1] = var_6_13
		var_6_4[var_6_9] = var_6_11
		var_6_5 = var_6_5 + var_6_6.spacing_x
	end

	arg_6_0._active_node_widgets = var_6_4
end

StartGameWindowDeusJourneySelection._get_first_journey_name = function (arg_7_0)
	local var_7_0 = arg_7_0._active_node_widgets

	if var_7_0 then
		return var_7_0[1].content.journey_name
	end
end

StartGameWindowDeusJourneySelection._is_journey_presented = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._active_node_widgets

	if var_8_0 then
		for iter_8_0 = 1, #var_8_0 do
			if var_8_0[iter_8_0].content.journey_name == arg_8_1 then
				return true
			end
		end
	end

	return false
end

StartGameWindowDeusJourneySelection._select_journey = function (arg_9_0, arg_9_1)
	local var_9_0 = DeusJourneySettings[arg_9_1].required_journeys or {}
	local var_9_1 = arg_9_0._active_node_widgets
	local var_9_2 = arg_9_0._unlocked_journeys[arg_9_1]

	if var_9_1 then
		for iter_9_0 = 1, #var_9_1 do
			local var_9_3 = var_9_1[iter_9_0]
			local var_9_4 = var_9_3.content
			local var_9_5 = var_9_4.journey_name == arg_9_1

			var_9_3.content.button_hotspot.is_selected = var_9_5
			var_9_4.unlock_guidance = table.contains(var_9_0, var_9_4.journey_name) and (var_9_4.locked or not var_9_2)
		end
	end

	arg_9_0._selected_journey_name = arg_9_1

	arg_9_0:_set_presentation_info(arg_9_1)
	arg_9_0:_update_modifier_god_info(arg_9_1)
end

StartGameWindowDeusJourneySelection._set_presentation_info = function (arg_10_0, arg_10_1)
	local var_10_0 = ""
	local var_10_1 = ""
	local var_10_2
	local var_10_3 = false
	local var_10_4 = arg_10_0._widgets_by_name
	local var_10_5 = var_10_4.selected_level.content

	if arg_10_1 then
		local var_10_6 = arg_10_0.statistics_db
		local var_10_7 = arg_10_0._stats_id
		local var_10_8 = DeusJourneySettings[arg_10_1]
		local var_10_9 = var_10_8.level_image
		local var_10_10 = var_10_8.display_name

		var_10_1 = var_10_8.description

		local var_10_11 = LevelUnlockUtils.completed_journey_difficulty_index(var_10_6, var_10_7, arg_10_1)

		var_10_2 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_10_11)

		if arg_10_0._unlocked_journeys[arg_10_1] then
			arg_10_0.parent:set_input_description("select_mission_confirm")
		else
			arg_10_0.parent:set_input_description("select_mission")
		end

		var_10_5.icon = var_10_9
		var_10_0 = Localize(var_10_10)
		var_10_1 = Localize(var_10_1)
		var_10_3 = true
	end

	var_10_5.frame = var_10_2
	var_10_5.locked = not var_10_3
	var_10_5.visible = var_10_3
	var_10_5.draw_chaos_symbol = false
	var_10_5.button_hotspot.disable_button = true
	var_10_4.helper_text.content.visible = not var_10_3
	var_10_4.level_title_divider.content.visible = var_10_3
	var_10_4.level_title.content.text = var_10_0
	var_10_4.description_text.content.text = var_10_1
	var_10_4.locked_text.content.text = ""
end

StartGameWindowDeusJourneySelection._setup_grid_navigation = function (arg_11_0)
	local var_11_0 = {}

	for iter_11_0, iter_11_1 in pairs(arg_11_0._active_node_widgets) do
		local var_11_1 = iter_11_1.content

		table.insert(var_11_0, var_11_1.journey_name)
	end

	arg_11_0._navigation_grid = var_11_0
	arg_11_0._current_column = arg_11_0:_find_journey_location_in_grid(arg_11_0._selected_journey_name)
end

StartGameWindowDeusJourneySelection._find_journey_location_in_grid = function (arg_12_0, arg_12_1)
	if not arg_12_1 then
		return 1
	end

	local var_12_0 = arg_12_0._navigation_grid
	local var_12_1 = 1

	if var_12_0 then
		for iter_12_0, iter_12_1 in ipairs(var_12_0) do
			if iter_12_1 == arg_12_1 then
				var_12_1 = iter_12_0

				break
			end
		end
	end

	fassert(var_12_1, "journey %s does not exist in navigation grid", arg_12_1)

	return var_12_1
end

StartGameWindowDeusJourneySelection.on_exit = function (arg_13_0, arg_13_1)
	print("[StartGameWindow] Exit Substate StartGameWindowDeusJourneySelection")

	arg_13_0.ui_animator = nil

	arg_13_0.parent:set_input_description(nil)
end

StartGameWindowDeusJourneySelection.update = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = Managers.time:time("main")

	arg_14_0:_update_modifiers(var_14_0)
	arg_14_0:_update_animations(arg_14_1)
	arg_14_0:_handle_input(arg_14_1, arg_14_2)
	arg_14_0:draw(arg_14_1)
end

StartGameWindowDeusJourneySelection.post_update = function (arg_15_0, arg_15_1, arg_15_2)
	return
end

StartGameWindowDeusJourneySelection._update_modifiers = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._journey_cycle

	if not var_16_0 or var_0_7(var_16_0, arg_16_1) then
		arg_16_0:_refresh_journey_cycle()
	end

	arg_16_0:_update_modifier_timer(arg_16_1)
end

StartGameWindowDeusJourneySelection._refresh_journey_cycle = function (arg_17_0)
	arg_17_0._journey_cycle = Managers.backend:get_interface("deus"):get_journey_cycle()

	arg_17_0:_on_new_journey_cycle()
end

StartGameWindowDeusJourneySelection._update_modifier_timer = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._journey_cycle
	local var_18_1 = var_18_0.remaining_time - (arg_18_1 - var_18_0.time_of_update)

	if var_18_1 < 0 then
		var_18_1 = 0
	end

	local var_18_2 = math.floor
	local var_18_3 = var_18_2(var_18_1 / 86400)
	local var_18_4 = var_18_2(var_18_1 / 3600)
	local var_18_5 = var_18_2(var_18_1 / 60) % 60
	local var_18_6 = arg_18_0._widgets_by_name.modifier_timer.content

	if var_18_5 > 0 then
		local var_18_7 = Localize("deus_start_game_mod_timer")

		var_18_6.time_text = string.format(var_18_7, var_18_3, var_18_4, var_18_5)
	else
		local var_18_8 = var_18_2(var_18_1)
		local var_18_9 = Localize("deus_start_game_mod_timer_seconds")

		var_18_6.time_text = string.format(var_18_9, var_18_8)
	end
end

StartGameWindowDeusJourneySelection._update_modifier_god_info = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._journey_cycle
	local var_19_1 = arg_19_0._widgets_by_name.modifier_info_god
	local var_19_2 = var_19_1.content
	local var_19_3 = var_19_0.journey_data[arg_19_1].dominant_god
	local var_19_4 = DeusThemeSettings[var_19_3]

	var_19_2.icon = var_19_4.text_icon
	var_19_2.title = var_19_4.journey_title
	var_19_2.description = Localize(var_19_4.journey_description)

	local var_19_5 = var_19_4.color
	local var_19_6 = var_19_1.style

	var_19_6.icon.color = var_19_5
	var_19_6.title.text_color = var_19_5
end

StartGameWindowDeusJourneySelection._update_journey_god_icons = function (arg_20_0)
	local var_20_0 = arg_20_0._journey_cycle

	for iter_20_0, iter_20_1 in ipairs(arg_20_0._active_node_widgets) do
		local var_20_1 = iter_20_1.content
		local var_20_2 = var_20_0.journey_data[var_20_1.journey_name].dominant_god

		var_20_1.theme_icon = DeusThemeSettings[var_20_2].icon
	end
end

StartGameWindowDeusJourneySelection._on_new_journey_cycle = function (arg_21_0)
	local var_21_0 = arg_21_0._selected_journey_name

	if var_21_0 then
		arg_21_0:_update_modifier_god_info(var_21_0)
	end

	arg_21_0:_update_journey_god_icons()
end

StartGameWindowDeusJourneySelection._update_animations = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.ui_animator

	var_22_0:update(arg_22_1)

	local var_22_1 = arg_22_0._animations

	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		if var_22_0:is_animation_completed(iter_22_1) then
			var_22_0:stop_animation(iter_22_1)

			var_22_1[iter_22_0] = nil
		end
	end

	local var_22_2 = arg_22_0._node_widgets

	for iter_22_2 = 1, #var_22_2 do
		local var_22_3 = var_22_2[iter_22_2]

		arg_22_0:_animate_node_widget(var_22_3, arg_22_1)
	end
end

StartGameWindowDeusJourneySelection._is_button_pressed = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1.content.button_hotspot

	if var_23_0.on_release then
		var_23_0.on_release = false

		return true
	end
end

StartGameWindowDeusJourneySelection._is_button_hovered = function (arg_24_0, arg_24_1)
	if arg_24_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

StartGameWindowDeusJourneySelection._update_selected_journey = function (arg_25_0)
	local var_25_0 = arg_25_0.parent:get_selected_level_id()

	if var_25_0 ~= arg_25_0._selected_journey_name or not var_25_0 then
		if arg_25_0:_is_journey_presented(var_25_0) then
			arg_25_0:_select_journey(var_25_0)
		elseif not arg_25_0._selected_journey_name then
			local var_25_1 = arg_25_0:_get_first_journey_name()

			arg_25_0:_select_journey(var_25_1)
		end
	end
end

StartGameWindowDeusJourneySelection._update_selection_from_grid = function (arg_26_0)
	local var_26_0 = arg_26_0._current_column
	local var_26_1 = arg_26_0._navigation_grid[var_26_0]

	fassert(var_26_1, "No journey_name at column %s", tostring(var_26_0))
	arg_26_0:_select_journey(var_26_1)
	arg_26_0:_play_sound("play_gui_lobby_button_02_mission_act_click")
end

StartGameWindowDeusJourneySelection._update_grid_column = function (arg_27_0, arg_27_1)
	local var_27_0 = #arg_27_0._navigation_grid

	arg_27_0._current_column = math.clamp(arg_27_1, 1, var_27_0)

	arg_27_0:_update_selection_from_grid()
end

StartGameWindowDeusJourneySelection._update_grid_navigation = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0:_find_column(arg_28_1)

	if var_28_0 ~= arg_28_0._current_column then
		arg_28_0:_update_grid_column(var_28_0)
	end
end

StartGameWindowDeusJourneySelection._find_column = function (arg_29_0, arg_29_1)
	if arg_29_1 == 0 then
		return arg_29_0._current_column
	end

	local var_29_0 = arg_29_0._current_column
	local var_29_1 = arg_29_0._current_column
	local var_29_2 = arg_29_0._navigation_grid

	if arg_29_1 < 0 then
		for iter_29_0, iter_29_1 in pairs(var_29_2) do
			if iter_29_0 < var_29_1 then
				var_29_0 = iter_29_0
			else
				break
			end
		end
	else
		for iter_29_2, iter_29_3 in pairs(var_29_2) do
			if var_29_1 < iter_29_2 then
				var_29_0 = iter_29_2

				break
			end
		end
	end

	return var_29_0
end

StartGameWindowDeusJourneySelection._handle_input = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.parent
	local var_30_1 = var_30_0:window_input_service()
	local var_30_2 = Managers.input:is_device_active("gamepad")

	if var_30_2 then
		if var_30_1:get("move_right_hold_continuous") then
			arg_30_0:_update_grid_navigation(1)
		elseif var_30_1:get("move_left_hold_continuous") then
			arg_30_0:_update_grid_navigation(-1)
		end
	end

	local var_30_3 = arg_30_0._active_node_widgets

	if var_30_2 and var_30_1:get(var_0_6, true) and arg_30_0._unlocked_journeys[arg_30_0._selected_journey_name] then
		arg_30_0:_play_sound("play_gui_lobby_button_02_mission_select")

		local var_30_4 = var_30_0:get_selected_game_mode_layout_name()

		var_30_0:set_selected_level_id(arg_30_0._selected_journey_name)
		var_30_0:set_layout_by_name(var_30_4)
	elseif var_30_3 then
		for iter_30_0 = 1, #var_30_3 do
			local var_30_5 = var_30_3[iter_30_0]
			local var_30_6 = var_30_5.content.journey_name

			if arg_30_0:_is_button_hovered(var_30_5) and arg_30_0._selected_journey_name ~= var_30_6 then
				arg_30_0:_play_sound("play_gui_lobby_button_02_mission_act_click")
				arg_30_0:_select_journey(var_30_6)
			end

			if arg_30_0:_is_button_pressed(var_30_5) then
				arg_30_0:_play_sound("play_gui_lobby_button_02_mission_select")

				local var_30_7 = var_30_0:get_selected_game_mode_layout_name()

				var_30_0:set_selected_level_id(var_30_6)
				var_30_0:set_layout_by_name(var_30_7)
			end
		end
	end
end

StartGameWindowDeusJourneySelection.draw = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._ui_top_renderer
	local var_31_1 = arg_31_0.ui_scenegraph
	local var_31_2 = arg_31_0.parent:window_input_service()

	UIRenderer.begin_pass(var_31_0, var_31_1, var_31_2, arg_31_1, nil, arg_31_0.render_settings)

	local var_31_3 = arg_31_0._widgets

	for iter_31_0 = 1, #var_31_3 do
		local var_31_4 = var_31_3[iter_31_0]

		UIRenderer.draw_widget(var_31_0, var_31_4)
	end

	local var_31_5 = arg_31_0._active_node_widgets

	if var_31_5 then
		for iter_31_1 = 1, #var_31_5 do
			local var_31_6 = var_31_5[iter_31_1]

			UIRenderer.draw_widget(var_31_0, var_31_6)
		end
	end

	UIRenderer.end_pass(var_31_0)
end

StartGameWindowDeusJourneySelection._play_sound = function (arg_32_0, arg_32_1)
	arg_32_0.parent:play_sound(arg_32_1)
end

StartGameWindowDeusJourneySelection._animate_node_widget = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_1.content
	local var_33_1 = var_33_0.button_hotspot
	local var_33_2 = var_33_1.is_selected
	local var_33_3 = var_33_1.selected_progress or 0
	local var_33_4 = 9

	if var_33_2 then
		var_33_3 = math.min(var_33_3 + var_33_4 * arg_33_2, 1)
	else
		var_33_3 = math.max(var_33_3 - var_33_4 * arg_33_2, 0)
	end

	local var_33_5 = var_33_0.unlock_guidance
	local var_33_6 = var_33_0.unlock_guidance_progress or 0
	local var_33_7 = 2

	if var_33_5 then
		var_33_6 = math.min(var_33_6 + arg_33_2 * var_33_7, 1)
	else
		var_33_6 = math.max(var_33_6 - arg_33_2 * var_33_7, 0)
	end

	local var_33_8 = arg_33_1.style

	var_33_8.icon_glow.color[1] = 255 * var_33_3

	local var_33_9 = math.max(math.lerp(-2.5, 1, var_33_6), 0)

	var_33_8.icon_unlock_guidance_glow.color[1] = 255 * var_33_9
	var_33_1.selected_progress = var_33_3
	var_33_0.unlock_guidance_progress = var_33_6
end
