-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_list.lua

local var_0_0
local var_0_1
local var_0_2
local var_0_3
local var_0_4
local var_0_5
local var_0_6
local var_0_7
local var_0_8 = true

StartGameWindowWeaveList = class(StartGameWindowWeaveList)
StartGameWindowWeaveList.NAME = "StartGameWindowWeaveList"

function StartGameWindowWeaveList.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowWeaveList")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._is_server = var_1_0.is_server
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._current_index = 0
	arg_1_0._hold_down_timer = 0
	arg_1_0._hold_up_timer = 0
	arg_1_0._current_scroll_value = 0
	arg_1_0._wanted_scrollbar_value = 0
	arg_1_0._start_index = 0
	arg_1_0._play_button_pressed = false
	arg_1_0._animations = {}

	arg_1_0:_setup_definitions(arg_1_1)
	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_populate_list()

	local var_1_1 = true

	arg_1_0:_on_weave_widget_pressed(arg_1_0._next_weave_widget, var_1_1)
	Managers.state.event:trigger("weave_list_entered")
	arg_1_0:_start_transition_animation("on_enter")
	arg_1_0._parent:change_generic_actions("default_weave")
end

function StartGameWindowWeaveList._setup_definitions(arg_2_0, arg_2_1)
	if arg_2_1.use_gamepad_layout or not IS_WINDOWS then
		var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_list_console_definitions")
	else
		var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_list_definitions")
	end

	var_0_1 = var_0_0.widgets
	var_0_2 = var_0_0.scenegraph_definition
	var_0_3 = var_0_0.animation_definitions
	var_0_4 = var_0_0.create_weave_entry_func
	var_0_5 = var_0_0.entry_size
	var_0_6 = var_0_0.entry_spacing
	var_0_7 = var_0_0.num_visible_weave_entries
end

function StartGameWindowWeaveList._start_transition_animation(arg_3_0, arg_3_1)
	local var_3_0 = {
		render_settings = arg_3_0._render_settings
	}
	local var_3_1 = arg_3_0._widgets_by_name
	local var_3_2 = arg_3_0._ui_animator:start_animation(arg_3_1, var_3_1, var_0_2, var_3_0)

	arg_3_0._animations[arg_3_1] = var_3_2
end

function StartGameWindowWeaveList._create_ui_elements(arg_4_0, arg_4_1, arg_4_2)
	var_0_8 = false
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1
	arg_4_0._weave_entry_widgets = {}
	arg_4_0._weave_entry_widgets_by_name = {}

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_top_renderer)

	arg_4_0._ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_3)
end

function StartGameWindowWeaveList.on_exit(arg_5_0, arg_5_1)
	print("[StartGameWindow] Exit Substate StartGameWindowWeaveList")

	arg_5_0._ui_animator = nil
	arg_5_0._params.selected_weave_template = nil
end

function StartGameWindowWeaveList.update(arg_6_0, arg_6_1, arg_6_2)
	if var_0_8 then
		arg_6_0:_setup_definitions(arg_6_0._params)
		arg_6_0:_create_ui_elements()
	end

	arg_6_0:_update_can_play(arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)

	if not arg_6_0._play_button_pressed then
		arg_6_0:_handle_input(arg_6_1, arg_6_2)
		arg_6_0:_handle_gamepad_input(arg_6_1, arg_6_2)
	end

	arg_6_0:_draw(arg_6_1)
end

function StartGameWindowWeaveList._can_play(arg_7_0)
	if not (arg_7_0._selected_weave_name ~= nil) then
		return false
	end

	local var_7_0 = arg_7_0._weave_entry_widgets[arg_7_0._current_index]

	return not var_7_0 or not var_7_0.content.locked
end

function StartGameWindowWeaveList._can_set_next_weave(arg_8_0)
	local var_8_0 = arg_8_0._next_weave_widget.content.weave_template_name

	return arg_8_0._selected_weave_name ~= var_8_0
end

function StartGameWindowWeaveList._update_can_play(arg_9_0)
	local var_9_0 = Managers.matchmaking:is_game_matchmaking()
	local var_9_1 = arg_9_0:_can_play()
	local var_9_2 = arg_9_0:_can_set_next_weave()

	if arg_9_0._previous_can_play ~= var_9_1 or arg_9_0._previous_set_next_weave ~= var_9_2 or var_9_0 ~= arg_9_0._was_matchmaking then
		arg_9_0._previous_can_play = var_9_1
		arg_9_0._previous_set_next_weave = var_9_2
		arg_9_0._was_matchmaking = var_9_0

		if var_9_0 then
			if arg_9_0._is_server then
				if var_9_2 then
					arg_9_0._parent:set_input_description("cancel_available_set_next_weave_available_lock")
				else
					arg_9_0._parent:set_input_description("cancel_matchmaking_lock")
				end
			elseif var_9_2 then
				arg_9_0._parent:set_input_description("set_next_weave_available_lock")
			else
				arg_9_0._parent:set_input_description(nil)
			end
		elseif var_9_1 then
			if var_9_2 then
				arg_9_0._parent:set_input_description("play_available_set_next_weave_available_lock")
			else
				arg_9_0._parent:set_input_description("play_available_lock")
			end
		elseif var_9_2 then
			arg_9_0._parent:set_input_description("set_next_weave_available_lock")
		else
			arg_9_0._parent:set_input_description(nil)
		end
	end
end

function StartGameWindowWeaveList.post_update(arg_10_0, arg_10_1, arg_10_2)
	return
end

function StartGameWindowWeaveList._update_animations(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._animations
	local var_11_1 = arg_11_0._ui_animator

	var_11_1:update(arg_11_1)

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		if var_11_1:is_animation_completed(iter_11_1) then
			var_11_1:stop_animation(iter_11_1)

			var_11_0[iter_11_0] = nil
		end
	end
end

function StartGameWindowWeaveList._on_list_index_selected(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._weave_entry_widgets
	local var_12_1 = var_12_0[arg_12_1]

	if not var_12_1 then
		return
	end

	local var_12_2 = var_12_1.content.template_id

	for iter_12_0, iter_12_1 in ipairs(var_12_0) do
		local var_12_3 = iter_12_1.content.button_hotspot
		local var_12_4 = iter_12_0 == arg_12_1

		if var_12_3 then
			var_12_3.is_selected = var_12_4
			var_12_3.has_focus = var_12_4
		end
	end

	if var_12_0[arg_12_1] then
		local var_12_5 = arg_12_0._next_weave_widget.content

		var_12_5.button_hotspot.is_selected = false
		var_12_5.button_hotspot.has_focus = false
	end

	local var_12_6 = WeaveSettings.templates_ordered[var_12_2]

	arg_12_0._params.selected_weave_template = var_12_6
	arg_12_0._current_index = arg_12_1

	local var_12_7 = var_12_6.name

	arg_12_0._selected_weave_name = var_12_7

	arg_12_0._parent:set_selected_weave_id(var_12_7)
	arg_12_0._parent:set_selected_weave_objective_index(1)
	arg_12_0:_play_sound("menu_wind_level_select")
end

function StartGameWindowWeaveList._handle_gamepad_input(arg_13_0, arg_13_1, arg_13_2)
	if Managers.input:is_device_active("mouse") then
		return
	end

	local var_13_0 = #arg_13_0._weave_entry_widgets
	local var_13_1 = arg_13_0._parent:window_input_service()
	local var_13_2 = Managers.matchmaking:is_game_matchmaking()

	if var_13_1:get("move_up_hold") then
		arg_13_0._hold_up_timer = arg_13_0._hold_up_timer + arg_13_1
		arg_13_0._hold_down_timer = 0
	elseif var_13_1:get("move_down_hold") then
		arg_13_0._hold_down_timer = arg_13_0._hold_down_timer + arg_13_1
		arg_13_0._hold_up_timer = 0
	else
		arg_13_0._hold_up_timer = 0
		arg_13_0._hold_down_timer = 0
	end

	if var_13_1:get("move_up") or arg_13_0._hold_up_timer > 0.5 then
		if arg_13_0._hold_up_timer > 0.5 then
			arg_13_0._hold_up_timer = 0.45
		end

		local var_13_3 = arg_13_0._current_index
		local var_13_4 = var_13_3 - 1

		if var_13_4 < 1 then
			var_13_4 = var_13_0
		end

		if var_13_4 ~= var_13_3 then
			arg_13_0:_on_list_index_selected(var_13_4)
		end
	elseif var_13_1:get("move_down") or arg_13_0._hold_down_timer > 0.5 then
		if arg_13_0._hold_down_timer > 0.5 then
			arg_13_0._hold_down_timer = 0.45
		end

		local var_13_5 = WeaveSettings.templates_ordered
		local var_13_6 = arg_13_0._current_index
		local var_13_7 = 1 + var_13_6 % var_13_0

		if var_13_7 ~= var_13_6 then
			arg_13_0:_on_list_index_selected(var_13_7)
		end
	else
		if var_13_2 then
			if arg_13_0._is_server and (var_13_1:get("refresh_press") or var_13_1:get("skip_pressed")) then
				arg_13_0._parent:play_sound("Play_hud_hover")
				Managers.matchmaking:cancel_matchmaking()
			end
		elseif arg_13_0:_can_play() and (var_13_1:get("refresh_press") or var_13_1:get("skip_pressed")) then
			arg_13_0._play_button_pressed = true

			local var_13_8 = true

			arg_13_0._parent:play(arg_13_2, "weave", var_13_8)
		end

		if var_13_1:get("special_1") then
			arg_13_0._current_index = 0
			arg_13_0._hold_down_timer = 0
			arg_13_0._hold_up_timer = 0
			arg_13_0._current_scroll_value = 0
			arg_13_0._wanted_scrollbar_value = 0
			arg_13_0._start_index = 0

			arg_13_0:_on_weave_widget_pressed(arg_13_0._next_weave_widget)
		elseif var_13_1:get("trigger_cycle_next") then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.ranked_weave_desc)
		end
	end

	arg_13_0:_handle_gamepad_scrollbar(arg_13_1, arg_13_2)
	arg_13_0:_animate_list_entries(false, arg_13_1)
end

function StartGameWindowWeaveList._handle_gamepad_scrollbar(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = #arg_14_0._weave_entry_widgets

	if var_14_0 <= var_0_7 then
		return
	end

	local var_14_1 = arg_14_0._start_index
	local var_14_2 = 1 / (var_14_0 - var_0_7 + 1)
	local var_14_3 = arg_14_0._current_index
	local var_14_4 = arg_14_0._current_index - (var_14_1 - 1)

	if var_14_4 > var_0_7 - 3 then
		local var_14_5 = var_14_4 - (var_0_7 - 3)

		arg_14_0._start_index = math.min(var_14_1 + var_14_5, var_14_0 - var_0_7 + 3)
		arg_14_0._current_scroll_value = arg_14_0._wanted_scrollbar_value
		arg_14_0._wanted_scrollbar_value = math.min(arg_14_0._wanted_scrollbar_value + var_14_2 * var_14_5, 1)
	elseif arg_14_0._current_index < var_14_1 + 2 then
		local var_14_6 = var_14_1 + 2 - arg_14_0._current_index

		arg_14_0._start_index = math.max(var_14_1 - var_14_6, 1)
		arg_14_0._current_scroll_value = arg_14_0._wanted_scrollbar_value
		arg_14_0._wanted_scrollbar_value = math.max(arg_14_0._wanted_scrollbar_value - var_14_2 * var_14_6, 0)
	end

	arg_14_0._current_scroll_value = math.lerp(arg_14_0._current_scroll_value, arg_14_0._wanted_scrollbar_value, arg_14_1 * 7)

	arg_14_0:_set_scrollbar_value(arg_14_0._current_scroll_value)
end

function StartGameWindowWeaveList._handle_input(arg_15_0, arg_15_1, arg_15_2)
	if Managers.input:is_device_active("gamepad") then
		return
	end

	local var_15_0 = arg_15_0._parent
	local var_15_1 = arg_15_0._widgets_by_name
	local var_15_2 = arg_15_0._parent:window_input_service()
	local var_15_3 = arg_15_0:_is_list_hovered()

	if arg_15_0:_next_weave_widget_hover_enter() then
		arg_15_0:_play_sound("play_gui_lobby_button_02_mission_act_hover")
	end

	local var_15_4 = arg_15_0:_next_weave_widget_pressed()

	if var_15_4 then
		arg_15_0:_on_weave_widget_pressed(var_15_4)
		arg_15_0:_play_sound("play_gui_lobby_button_02_mission_select")
	elseif var_15_3 then
		if arg_15_0:_weave_widget_hover_enter() then
			arg_15_0:_play_sound("play_gui_lobby_button_02_mission_act_hover")
		end

		local var_15_5 = arg_15_0:_weave_widget_pressed()

		if var_15_5 then
			arg_15_0:_on_weave_widget_pressed(var_15_5)
			arg_15_0:_play_sound("play_gui_lobby_button_02_mission_select")
		end
	end

	arg_15_0:_update_mouse_scroll_input()
	arg_15_0:_animate_list_entries(var_15_3, arg_15_1)
end

function StartGameWindowWeaveList._is_list_hovered(arg_16_0)
	return arg_16_0._widgets_by_name.list_hotspot.content.hotspot.is_hover == true
end

function StartGameWindowWeaveList._on_weave_widget_pressed(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._weave_entry_widgets
	local var_17_1 = arg_17_1

	if var_17_1.content.locked then
		return
	end

	local var_17_2 = var_17_1.content.template_id

	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		local var_17_3 = iter_17_1.content
		local var_17_4 = var_17_3.button_hotspot
		local var_17_5 = var_17_3.template_id == var_17_2 and iter_17_1 == var_17_1

		if var_17_4 then
			var_17_4.is_selected = var_17_5
			var_17_4.has_focus = var_17_5
		end
	end

	local var_17_6 = arg_17_0._next_weave_widget.content

	var_17_6.button_hotspot.is_selected = arg_17_1 == arg_17_0._next_weave_widget
	var_17_6.button_hotspot.has_focus = arg_17_1 == arg_17_0._next_weave_widget

	local var_17_7 = WeaveSettings.templates_ordered[var_17_2]

	arg_17_0._params.selected_weave_template = var_17_7

	local var_17_8 = var_17_7.name

	arg_17_0._selected_weave_name = var_17_8

	arg_17_0._parent:set_selected_weave_id(var_17_8)
	arg_17_0._parent:set_selected_weave_objective_index(1)

	if not arg_17_2 then
		arg_17_0:_play_sound("menu_wind_level_select")
	end
end

function StartGameWindowWeaveList._draw(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._ui_top_renderer
	local var_18_1 = arg_18_0.ui_scenegraph
	local var_18_2 = arg_18_0._parent:window_input_service()
	local var_18_3 = arg_18_0._render_settings
	local var_18_4 = var_18_3.alpha_multiplier or 0

	UIRenderer.begin_pass(var_18_0, var_18_1, var_18_2, arg_18_1, nil, var_18_3)

	for iter_18_0, iter_18_1 in pairs(arg_18_0._widgets_by_name) do
		var_18_3.alpha_multiplier = iter_18_1.alpha_multiplier or var_18_4

		UIRenderer.draw_widget(var_18_0, iter_18_1)
	end

	local var_18_5 = arg_18_0:_calculate_first_widget_to_draw()

	for iter_18_2 = var_18_5, var_18_5 + var_0_7 - 1 do
		local var_18_6 = arg_18_0._weave_entry_widgets[iter_18_2]

		if var_18_6 then
			var_18_3.alpha_multiplier = var_18_6.alpha_multiplier or var_18_4

			UIRenderer.draw_widget(var_18_0, var_18_6)
		end
	end

	var_18_3.alpha_multiplier = var_18_4

	UIRenderer.draw_widget(var_18_0, arg_18_0._next_weave_widget)
	UIRenderer.end_pass(var_18_0)
end

function StartGameWindowWeaveList._calculate_first_widget_to_draw(arg_19_0)
	local var_19_0 = arg_19_0._total_scroll_height
	local var_19_1 = #arg_19_0._weave_entry_widgets
	local var_19_2 = arg_19_0._scroll_value
	local var_19_3 = var_19_1 - var_0_7 + 2

	return (math.floor(math.lerp(1, var_19_3, var_19_2)))
end

function StartGameWindowWeaveList._play_sound(arg_20_0, arg_20_1)
	arg_20_0._parent:play_sound(arg_20_1)
end

function StartGameWindowWeaveList._populate_list(arg_21_0)
	local var_21_0 = false
	local var_21_1 = arg_21_0._widgets_by_name.list
	local var_21_2 = WeaveSettings.templates_ordered
	local var_21_3 = #var_21_2
	local var_21_4 = Managers.player:statistics_db()
	local var_21_5 = Managers.player:local_player():stats_id()
	local var_21_6 = {}
	local var_21_7 = 1
	local var_21_8 = false

	for iter_21_0 = 1, var_21_3 do
		local var_21_9 = var_21_2[iter_21_0]
		local var_21_10 = LevelUnlockUtils.weave_unlocked(var_21_4, var_21_5, var_21_9.name, var_21_0)

		if var_21_10 or var_21_7 == iter_21_0 then
			var_21_6[iter_21_0] = true

			if var_21_10 and not var_21_8 or LevelUnlockUtils.weave_disabled(var_21_9.name) then
				if var_21_2[iter_21_0 + 1] then
					var_21_7 = iter_21_0 + 1
				end
			else
				var_21_8 = true
			end
		end
	end

	for iter_21_1 = var_21_3, 1, -1 do
		if var_21_6[iter_21_1] and iter_21_1 ~= var_21_7 then
			local var_21_11 = var_21_2[iter_21_1]
			local var_21_12 = var_0_4(#arg_21_0._weave_entry_widgets + 1, iter_21_1, var_21_11, true)
			local var_21_13 = UIWidget.init(var_21_12)

			if LevelUnlockUtils.weave_disabled(var_21_11.name) then
				var_21_13.content.locked = true
			end

			arg_21_0._weave_entry_widgets[#arg_21_0._weave_entry_widgets + 1] = var_21_13
			arg_21_0._weave_entry_widgets_by_name[var_21_11.name] = var_21_13
		end
	end

	local var_21_14 = var_21_2[var_21_7]
	local var_21_15 = var_0_4(1, var_21_7, var_21_14, false, "next_weave")
	local var_21_16 = UIWidget.init(var_21_15)

	if LevelUnlockUtils.weave_disabled(var_21_14.name) then
		var_21_16.content.locked = true
	end

	arg_21_0._next_weave_widget = var_21_16

	arg_21_0:_setup_scrollbar()
end

function StartGameWindowWeaveList._setup_scrollbar(arg_22_0)
	local var_22_0 = #arg_22_0._weave_entry_widgets

	arg_22_0._total_scroll_height = var_22_0 * var_0_5[2] + (var_22_0 + 1) * var_0_6

	local var_22_1 = arg_22_0._widgets_by_name.list_scrollbar
	local var_22_2 = var_22_1.scenegraph_id
	local var_22_3 = arg_22_0.ui_scenegraph[var_22_2].size[2]
	local var_22_4

	var_22_4.bar_height_percentage, var_22_4 = math.min(var_22_3 / arg_22_0._total_scroll_height, 1), var_22_1.content.scroll_bar_info

	arg_22_0:_set_scrollbar_value(0)

	local var_22_5 = var_0_2.list_window.size

	if arg_22_0._total_scroll_height > var_22_5[2] then
		local var_22_6 = var_22_0 * var_0_5[2]
		local var_22_7 = var_0_5[2]

		var_22_4.scroll_amount = math.max(var_22_7 / var_22_6, 0)
	else
		var_22_4.scroll_amount = 0
	end
end

function StartGameWindowWeaveList._next_weave_widget_pressed(arg_23_0)
	local var_23_0 = arg_23_0._next_weave_widget.content.button_hotspot

	if var_23_0 and var_23_0.on_release then
		var_23_0.on_release = false

		return arg_23_0._next_weave_widget
	end
end

function StartGameWindowWeaveList._next_weave_widget_hover_enter(arg_24_0)
	local var_24_0 = arg_24_0._next_weave_widget.content.button_hotspot

	if var_24_0 and var_24_0.on_hover_enter then
		var_24_0.on_hover_enter = false

		return arg_24_0._next_weave_widget
	end
end

function StartGameWindowWeaveList._weave_widget_pressed(arg_25_0)
	local var_25_0 = arg_25_0._weave_entry_widgets

	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		local var_25_1 = iter_25_1.content

		if var_25_1 then
			local var_25_2 = var_25_1.button_hotspot

			if var_25_2 and var_25_2.on_release then
				var_25_2.on_release = false

				return iter_25_1
			end
		end
	end
end

function StartGameWindowWeaveList._weave_widget_hover_enter(arg_26_0)
	local var_26_0 = arg_26_0._weave_entry_widgets

	for iter_26_0, iter_26_1 in pairs(var_26_0) do
		local var_26_1 = iter_26_1.content

		if var_26_1 then
			local var_26_2 = var_26_1.button_hotspot

			if var_26_2 and var_26_2.on_hover_enter then
				var_26_2.on_hover_enter = false

				return iter_26_1
			end
		end
	end
end

function StartGameWindowWeaveList._update_mouse_scroll_input(arg_27_0)
	local var_27_0 = arg_27_0._widgets_by_name.list_scrollbar.content.scroll_bar_info

	if var_27_0.on_pressed then
		var_27_0.scroll_add = nil
	end

	local var_27_1 = var_27_0.scroll_value

	if not var_27_1 then
		return
	end

	local var_27_2 = var_27_0.value
	local var_27_3 = arg_27_0._scroll_value

	if var_27_3 ~= var_27_1 then
		arg_27_0:_set_scrollbar_value(var_27_1)
	elseif var_27_3 ~= var_27_2 then
		arg_27_0:_set_scrollbar_value(var_27_2)
	end
end

function StartGameWindowWeaveList._set_scrollbar_value(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._scroll_value

	if arg_28_1 then
		local var_28_1 = arg_28_0._widgets_by_name.list_scrollbar.content.scroll_bar_info

		var_28_1.value = arg_28_1
		var_28_1.scroll_value = arg_28_1

		local var_28_2 = arg_28_0.ui_scenegraph.list_anchor.local_position
		local var_28_3 = var_0_2.list_window.size

		var_28_2[2] = math.floor((arg_28_0._total_scroll_height - var_28_3[2]) * arg_28_1)
		arg_28_0._scroll_value = arg_28_1
	end
end

function StartGameWindowWeaveList._animate_list_entries(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0._weave_entry_widgets

	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		local var_29_1 = iter_29_1.content
		local var_29_2 = iter_29_1.style

		if var_29_1 then
			arg_29_0:_animate_list_entry(var_29_1, var_29_2, arg_29_2, arg_29_1)
		end
	end

	local var_29_3 = arg_29_0._next_weave_widget.content
	local var_29_4 = arg_29_0._next_weave_widget.style

	arg_29_0:_animate_list_entry(var_29_3, var_29_4, arg_29_2, true)
end

function StartGameWindowWeaveList._animate_list_entry(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	local var_30_0 = Managers.input:is_device_active("mouse")
	local var_30_1 = arg_30_1.button_hotspot or arg_30_1.hotspot
	local var_30_2 = (var_30_1.is_hover or not var_30_0) and var_30_1.has_focus
	local var_30_3 = var_30_1.is_selected
	local var_30_4 = var_30_1.on_hover_enter

	if var_30_0 and arg_30_4 ~= nil and not arg_30_4 then
		var_30_2 = false

		local var_30_5 = false
	end

	local var_30_6 = not var_30_3 and var_30_1.is_clicked and var_30_1.is_clicked == 0
	local var_30_7 = var_30_1.input_progress or 0
	local var_30_8 = var_30_1.hover_progress or 0
	local var_30_9 = var_30_1.selection_progress or 0
	local var_30_10 = 14
	local var_30_11 = 20

	if var_30_6 then
		var_30_7 = math.min(var_30_7 + arg_30_3 * var_30_11, 1)
	else
		var_30_7 = math.max(var_30_7 - arg_30_3 * var_30_11, 0)
	end

	local var_30_12 = math.easeOutCubic(var_30_7)
	local var_30_13 = math.easeInCubic(var_30_7)

	if var_30_2 then
		var_30_8 = math.min(var_30_8 + arg_30_3 * var_30_10, 1)
	else
		var_30_8 = math.max(var_30_8 - arg_30_3 * var_30_10, 0)
	end

	local var_30_14 = math.easeOutCubic(var_30_8)
	local var_30_15 = math.easeInCubic(var_30_8)

	if var_30_3 then
		var_30_9 = math.min(var_30_9 + arg_30_3 * var_30_10, 1)
	else
		var_30_9 = math.max(var_30_9 - arg_30_3 * var_30_10, 0)
	end

	local var_30_16 = math.easeOutCubic(var_30_9)
	local var_30_17 = math.easeInCubic(var_30_9)
	local var_30_18 = math.max(var_30_8, var_30_9)
	local var_30_19 = math.max(var_30_16, var_30_14)
	local var_30_20 = math.max(var_30_15, var_30_17)
	local var_30_21 = 255 * var_30_8
	local var_30_22 = 255 * var_30_18

	arg_30_2.hover_frame.color[1] = var_30_21
	arg_30_2.symbol_bg_glow.color[1] = 64 + 64 * var_30_18
	arg_30_2.wind_symbol.color[1] = 70 + 185 * var_30_18
	arg_30_2.background_effect.color[1] = 255 * var_30_9

	local var_30_23 = 20
	local var_30_24 = arg_30_2.symbol_frame_selected
	local var_30_25 = var_30_24.texture_size
	local var_30_26 = var_30_24.default_size
	local var_30_27 = var_30_24.offset
	local var_30_28 = var_30_24.default_offset

	var_30_25[1] = var_30_26[1] - var_30_23 + var_30_23 * var_30_9
	var_30_25[2] = var_30_26[2] - var_30_23 + var_30_23 * var_30_9
	var_30_27[1] = var_30_28[1] + var_30_23 / 2 - var_30_23 / 2 * var_30_9

	local var_30_29 = arg_30_2.symbol_frame_selected_glow
	local var_30_30 = var_30_29.texture_size
	local var_30_31 = var_30_29.default_size
	local var_30_32 = var_30_29.offset
	local var_30_33 = var_30_29.default_offset
	local var_30_34 = 20

	var_30_30[1] = var_30_31[1] - var_30_34 + var_30_34 * var_30_9
	var_30_30[2] = var_30_31[2] - var_30_34 + var_30_34 * var_30_9
	var_30_32[1] = var_30_33[1] + var_30_34 / 2 - var_30_34 / 2 * var_30_9

	local var_30_35 = arg_30_2.level_name
	local var_30_36 = var_30_35.text_color
	local var_30_37 = var_30_35.default_text_color
	local var_30_38 = var_30_35.select_text_color

	Colors.lerp_color_tables(var_30_37, var_30_38, var_30_18, var_30_36)

	local var_30_39 = arg_30_2.title
	local var_30_40 = var_30_39.text_color
	local var_30_41 = var_30_39.default_text_color
	local var_30_42 = var_30_39.select_text_color

	Colors.lerp_color_tables(var_30_41, var_30_42, var_30_18, var_30_40)

	var_30_1.hover_progress = var_30_8
	var_30_1.input_progress = var_30_7
	var_30_1.selection_progress = var_30_9
end
