-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_summary_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_summary_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

StartGameWindowMutatorSummaryConsole = class(StartGameWindowMutatorSummaryConsole)
StartGameWindowMutatorSummaryConsole.NAME = "StartGameWindowMutatorSummaryConsole"

function StartGameWindowMutatorSummaryConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorSummaryConsole")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0.previous_selected_backend_id = arg_1_0.parent:get_selected_heroic_deed_backend_id()
end

function StartGameWindowMutatorSummaryConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_2, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function StartGameWindowMutatorSummaryConsole.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(arg_3_0.ui_scenegraph, var_0_3)

	if arg_3_2 then
		local var_3_3 = arg_3_0.ui_scenegraph.window.local_position

		var_3_3[1] = var_3_3[1] + arg_3_2[1]
		var_3_3[2] = var_3_3[2] + arg_3_2[2]
		var_3_3[3] = var_3_3[3] + arg_3_2[3]
	end

	var_3_1.game_option_placeholder.content.visible = true
end

function StartGameWindowMutatorSummaryConsole.on_exit(arg_4_0, arg_4_1)
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorSummaryConsole")

	arg_4_0.ui_animator = nil

	if not arg_4_0.confirm_button_pressed then
		arg_4_0.parent:set_selected_heroic_deed_backend_id(arg_4_0.previous_selected_backend_id)
	end
end

function StartGameWindowMutatorSummaryConsole.update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_update_selected_item_backend_id()
	arg_5_0:draw(arg_5_1)
end

function StartGameWindowMutatorSummaryConsole.post_update(arg_6_0, arg_6_1, arg_6_2)
	return
end

function StartGameWindowMutatorSummaryConsole._update_animations(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.ui_animator

	var_7_0:update(arg_7_1)

	local var_7_1 = arg_7_0._animations

	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if var_7_0:is_animation_completed(iter_7_1) then
			var_7_0:stop_animation(iter_7_1)

			var_7_1[iter_7_0] = nil
		end
	end
end

function StartGameWindowMutatorSummaryConsole._update_selected_item_backend_id(arg_8_0)
	local var_8_0 = arg_8_0.parent:get_selected_heroic_deed_backend_id()

	if var_8_0 ~= arg_8_0._selected_backend_id then
		arg_8_0._selected_backend_id = var_8_0

		arg_8_0:_present_item_by_backend_id(var_8_0)
	end
end

function StartGameWindowMutatorSummaryConsole._present_item_by_backend_id(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._presenting_item

	arg_9_0._presenting_item = false

	if not arg_9_1 then
		return
	end

	local var_9_1 = arg_9_0._widgets_by_name

	var_9_1.game_option_placeholder.content.visible = false

	local var_9_2 = Managers.backend:get_interface("items"):get_item_from_id(arg_9_1)

	var_9_1.item_presentation.content.item = var_9_2
	arg_9_0._presenting_item = true

	local var_9_3 = Managers.input:is_device_active("gamepad")

	if not var_9_0 and (not IS_WINDOWS or var_9_3) then
		arg_9_0:_start_transition_animation("on_enter")
	end
end

function StartGameWindowMutatorSummaryConsole.draw(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._ui_top_renderer
	local var_10_1 = arg_10_0.ui_scenegraph
	local var_10_2 = arg_10_0.parent:window_input_service()

	UIRenderer.begin_pass(var_10_0, var_10_1, var_10_2, arg_10_1, nil, arg_10_0.render_settings)

	if arg_10_0._presenting_item then
		local var_10_3 = arg_10_0._widgets

		for iter_10_0 = 1, #var_10_3 do
			local var_10_4 = var_10_3[iter_10_0]

			UIRenderer.draw_widget(var_10_0, var_10_4)
		end
	end

	UIRenderer.end_pass(var_10_0)
end
