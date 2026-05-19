-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_summary.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_summary_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition

StartGameWindowMutatorSummary = class(StartGameWindowMutatorSummary)
StartGameWindowMutatorSummary.NAME = "StartGameWindowMutatorSummary"

function StartGameWindowMutatorSummary.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorSummary")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.previous_selected_backend_id = arg_1_0.parent:get_selected_heroic_deed_backend_id()
end

function StartGameWindowMutatorSummary.create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_2 = UIWidget.init(iter_2_1)

		var_2_0[#var_2_0 + 1] = var_2_2
		var_2_1[iter_2_0] = var_2_2
	end

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	if arg_2_2 then
		local var_2_3 = arg_2_0.ui_scenegraph.window.local_position

		var_2_3[1] = var_2_3[1] + arg_2_2[1]
		var_2_3[2] = var_2_3[2] + arg_2_2[2]
		var_2_3[3] = var_2_3[3] + arg_2_2[3]
	end

	var_2_1.confirm_button.content.button_hotspot.disable_button = true
	var_2_1.item_presentation_frame.content.visible = false
	var_2_1.item_presentation_bg.content.visible = false
	var_2_1.game_option_placeholder.content.visible = true
end

function StartGameWindowMutatorSummary.on_exit(arg_3_0, arg_3_1)
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorSummary")

	if not arg_3_0.confirm_button_pressed then
		arg_3_0.parent:set_selected_heroic_deed_backend_id(arg_3_0.previous_selected_backend_id)
	end
end

function StartGameWindowMutatorSummary.update(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_handle_input(arg_4_1, arg_4_2)
	arg_4_0:_update_selected_item_backend_id()
	arg_4_0:draw(arg_4_1)
end

function StartGameWindowMutatorSummary.post_update(arg_5_0, arg_5_1, arg_5_2)
	return
end

function StartGameWindowMutatorSummary._is_button_pressed(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.content.button_hotspot

	if var_6_0.on_release then
		var_6_0.on_release = false

		return true
	end
end

function StartGameWindowMutatorSummary._is_button_hover_enter(arg_7_0, arg_7_1)
	return arg_7_1.content.button_hotspot.on_hover_enter
end

function StartGameWindowMutatorSummary._handle_input(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0._selected_backend_id then
		return
	end

	local var_8_0 = arg_8_0._widgets_by_name.confirm_button

	UIWidgetUtils.animate_default_button(var_8_0, arg_8_1)

	if arg_8_0:_is_button_hover_enter(var_8_0) then
		arg_8_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if arg_8_0:_is_button_pressed(var_8_0) then
		arg_8_0.confirm_button_pressed = true

		arg_8_0.parent:set_layout_by_name("heroic_deeds")
	end
end

function StartGameWindowMutatorSummary._update_selected_item_backend_id(arg_9_0)
	local var_9_0 = arg_9_0.parent:get_selected_heroic_deed_backend_id()

	if var_9_0 ~= arg_9_0._selected_backend_id then
		arg_9_0._selected_backend_id = var_9_0

		arg_9_0:_present_item_by_backend_id(var_9_0)
	end
end

function StartGameWindowMutatorSummary._present_item_by_backend_id(arg_10_0, arg_10_1)
	if not arg_10_1 then
		return
	end

	local var_10_0 = arg_10_0._widgets_by_name

	var_10_0.item_presentation_frame.content.visible = true
	var_10_0.item_presentation_bg.content.visible = true
	var_10_0.game_option_placeholder.content.visible = false

	local var_10_1 = Managers.backend:get_interface("items"):get_item_from_id(arg_10_1)

	var_10_0.item_presentation.content.item = var_10_1
	var_10_0.confirm_button.content.button_hotspot.disable_button = false
end

function StartGameWindowMutatorSummary.draw(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.ui_renderer
	local var_11_1 = arg_11_0.ui_scenegraph
	local var_11_2 = arg_11_0.parent:window_input_service()

	UIRenderer.begin_pass(var_11_0, var_11_1, var_11_2, arg_11_1, nil, arg_11_0.render_settings)

	local var_11_3 = arg_11_0._widgets

	for iter_11_0 = 1, #var_11_3 do
		local var_11_4 = var_11_3[iter_11_0]

		UIRenderer.draw_widget(var_11_0, var_11_4)
	end

	UIRenderer.end_pass(var_11_0)
end

function StartGameWindowMutatorSummary._play_sound(arg_12_0, arg_12_1)
	arg_12_0.parent:play_sound(arg_12_1)
end
