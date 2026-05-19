-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_event_summary_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_event_summary_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

StartGameWindowEventSummaryConsole = class(StartGameWindowEventSummaryConsole)
StartGameWindowEventSummaryConsole.NAME = "StartGameWindowEventSummaryConsole"

function StartGameWindowEventSummaryConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowEventSummaryConsole")

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
end

function StartGameWindowEventSummaryConsole._start_transition_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0.render_settings
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.ui_animator:start_animation(arg_2_1, var_2_1, var_0_2, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function StartGameWindowEventSummaryConsole.create_ui_elements(arg_3_0, arg_3_1, arg_3_2)
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

	arg_3_0:_setup_content_from_backend()
end

function StartGameWindowEventSummaryConsole._setup_content_from_backend(arg_4_0)
	local var_4_0 = Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data()
	local var_4_1 = arg_4_0._widgets_by_name.event_summary
	local var_4_2 = var_4_0.level_key
	local var_4_3 = var_4_0.mutators

	var_4_1.content.item = {
		level_key = var_4_2,
		mutators = var_4_3
	}
end

function StartGameWindowEventSummaryConsole.on_exit(arg_5_0, arg_5_1)
	print("[StartGameWindow] Exit Substate StartGameWindowEventSummaryConsole")

	arg_5_0.ui_animator = nil
end

function StartGameWindowEventSummaryConsole.update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_update_animations(arg_6_1)
	arg_6_0:draw(arg_6_1)
end

function StartGameWindowEventSummaryConsole.post_update(arg_7_0, arg_7_1, arg_7_2)
	return
end

function StartGameWindowEventSummaryConsole._update_animations(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.ui_animator

	var_8_0:update(arg_8_1)

	local var_8_1 = arg_8_0._animations

	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		if var_8_0:is_animation_completed(iter_8_1) then
			var_8_0:stop_animation(iter_8_1)

			var_8_1[iter_8_0] = nil
		end
	end
end

function StartGameWindowEventSummaryConsole.draw(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._ui_top_renderer
	local var_9_1 = arg_9_0.ui_scenegraph
	local var_9_2 = arg_9_0.parent:window_input_service()

	UIRenderer.begin_pass(var_9_0, var_9_1, var_9_2, arg_9_1, nil, arg_9_0.render_settings)

	local var_9_3 = arg_9_0._widgets

	for iter_9_0 = 1, #var_9_3 do
		local var_9_4 = var_9_3[iter_9_0]

		UIRenderer.draw_widget(var_9_0, var_9_4)
	end

	UIRenderer.end_pass(var_9_0)
end
