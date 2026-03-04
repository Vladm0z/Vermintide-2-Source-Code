-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_heroic_deed_overview_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_heroic_deed_overview_console_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.selector_input_definition
local var_0_5 = "refresh_press"
local var_0_6 = "confirm_press"

StartGameWindowHeroicDeedOverviewConsole = class(StartGameWindowHeroicDeedOverviewConsole)
StartGameWindowHeroicDeedOverviewConsole.NAME = "StartGameWindowHeroicDeedOverviewConsole"

function StartGameWindowHeroicDeedOverviewConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowHeroicDeedOverviewConsole")

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

	arg_1_0._is_focused = false
	arg_1_0._play_button_pressed = false
	arg_1_0._show_additional_settings = false
	arg_1_0._previous_can_play = nil

	arg_1_0._parent:change_generic_actions("default")
	arg_1_0:_start_transition_animation("on_enter")
end

function StartGameWindowHeroicDeedOverviewConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_1, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function StartGameWindowHeroicDeedOverviewConsole._create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
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
end

function StartGameWindowHeroicDeedOverviewConsole.on_exit(arg_4_0, arg_4_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowHeroicDeedOverviewConsole")

	arg_4_0._ui_animator = nil

	if arg_4_0._play_button_pressed then
		arg_4_1.input_index = nil
	else
		arg_4_1.input_index = arg_4_0._input_index
	end
end

function StartGameWindowHeroicDeedOverviewConsole.set_focus(arg_5_0, arg_5_1)
	arg_5_0._is_focused = arg_5_1
end

function StartGameWindowHeroicDeedOverviewConsole.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_heroic_deed_selection()
	arg_6_0:_update_can_play()
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:_handle_input(arg_6_1, arg_6_2)
	arg_6_0:_draw(arg_6_1)
end

function StartGameWindowHeroicDeedOverviewConsole.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function StartGameWindowHeroicDeedOverviewConsole._present_heroic_deed(arg_8_0, arg_8_1)
	local var_8_0 = Managers.backend:get_interface("items")
	local var_8_1 = arg_8_1 and var_8_0:get_item_masterlist_data(arg_8_1)
	local var_8_2 = arg_8_0._widgets_by_name.heroic_deed_setting

	var_8_2.content.input_text = var_8_1 and Localize(var_8_1.display_name) or Localize("not_assigned")
	var_8_2.content.icon_texture = var_8_1 and var_8_1.inventory_icon or nil
end

function StartGameWindowHeroicDeedOverviewConsole._update_heroic_deed_selection(arg_9_0)
	local var_9_0 = arg_9_0._parent:get_selected_heroic_deed_backend_id()

	if var_9_0 ~= arg_9_0._selected_backend_id then
		arg_9_0._selected_backend_id = var_9_0

		if var_9_0 ~= nil then
			arg_9_0:_present_heroic_deed(var_9_0)
		end
	end
end

function StartGameWindowHeroicDeedOverviewConsole._update_can_play(arg_10_0)
	local var_10_0 = arg_10_0:_can_play()

	if arg_10_0._previous_can_play ~= var_10_0 then
		arg_10_0._previous_can_play = var_10_0

		local var_10_1 = arg_10_0._widgets_by_name.play_button

		var_10_1.content.button_hotspot.disable_button = not var_10_0
		var_10_1.content.disabled = not var_10_0

		if var_10_0 then
			arg_10_0._parent:set_input_description("play_available")
		else
			arg_10_0._parent:set_input_description(nil)
		end
	end
end

function StartGameWindowHeroicDeedOverviewConsole._is_button_hover_enter(arg_11_0, arg_11_1)
	return arg_11_1.content.button_hotspot.on_hover_enter
end

function StartGameWindowHeroicDeedOverviewConsole._is_button_pressed(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	if var_12_0.on_release then
		var_12_0.on_release = false

		return true
	end
end

function StartGameWindowHeroicDeedOverviewConsole._handle_input(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._parent
	local var_13_1 = var_13_0:window_input_service()

	if var_13_1:get(var_0_6) then
		arg_13_0:_option_selected(arg_13_0._input_index, arg_13_2)
	end

	local var_13_2 = arg_13_0._input_index

	if var_13_1:get("move_down") then
		var_13_2 = var_13_2 + 1
	elseif var_13_1:get("move_up") then
		var_13_2 = var_13_2 - 1
	end

	if var_13_2 ~= arg_13_0._input_index then
		arg_13_0:_handle_new_selection(var_13_2)
	end

	local var_13_3 = arg_13_0._widgets_by_name

	for iter_13_0 = 1, #var_0_4 do
		local var_13_4 = var_13_3[var_0_4[iter_13_0]]

		if not var_13_4.content.is_selected and arg_13_0:_is_button_hover_enter(var_13_4) then
			arg_13_0:_handle_new_selection(iter_13_0)
		end

		if arg_13_0:_is_button_pressed(var_13_4) then
			arg_13_0:_option_selected(arg_13_0._input_index, arg_13_2)
		end
	end

	if arg_13_0:_can_play() then
		if arg_13_0:_is_button_hover_enter(var_13_3.play_button) then
			arg_13_0._parent:play_sound("Play_hud_hover")
		end

		if var_13_1:get(var_0_5) or arg_13_0:_is_button_pressed(var_13_3.play_button) then
			arg_13_0._play_button_pressed = true

			var_13_0:play(arg_13_2, "deed")
		end
	end
end

function StartGameWindowHeroicDeedOverviewConsole._can_play(arg_14_0)
	if not Managers.backend:get_interface("items"):get_item_from_id(arg_14_0._selected_backend_id) then
		arg_14_0._selected_backend_id = nil
	end

	if not arg_14_0._parent:get_selected_heroic_deed_backend_id() then
		return false
	end

	return arg_14_0._selected_backend_id ~= nil
end

function StartGameWindowHeroicDeedOverviewConsole._option_selected(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = var_0_4[arg_15_1]

	if var_15_0 == "heroic_deed_setting" then
		arg_15_0._parent:set_layout_by_name("heroic_deed_selection")
	elseif var_15_0 == "play_button" then
		if arg_15_0:_can_play() then
			arg_15_0._play_button_pressed = true

			arg_15_0._parent:play(arg_15_2, "deed")
		end
	else
		ferror("Unknown selector_input_definition: %s", var_15_0)
	end
end

function StartGameWindowHeroicDeedOverviewConsole._handle_new_selection(arg_16_0, arg_16_1)
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

	arg_16_0._input_index = arg_16_1
end

function StartGameWindowHeroicDeedOverviewConsole._update_animations(arg_17_0, arg_17_1)
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

	UIWidgetUtils.animate_start_game_console_setting_button(var_17_2.heroic_deed_setting, arg_17_1)
	UIWidgetUtils.animate_play_button(var_17_2.play_button, arg_17_1)
end

function StartGameWindowHeroicDeedOverviewConsole._draw(arg_18_0, arg_18_1)
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
