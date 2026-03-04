-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_adventure_mode.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_adventure_mode_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition

StartGameWindowAdventureMode = class(StartGameWindowAdventureMode)
StartGameWindowAdventureMode.NAME = "StartGameWindowAdventureMode"

StartGameWindowAdventureMode.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowAdventureMode")

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
	arg_1_0.parent:set_play_button_enabled(true)
end

StartGameWindowAdventureMode.create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = UISceneGraph.init_scenegraph(var_0_2)

	arg_2_0.ui_scenegraph = var_2_0

	local var_2_1 = {}
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_3 = UIWidget.init(iter_2_1)

		var_2_1[#var_2_1 + 1] = var_2_3
		var_2_2[iter_2_0] = var_2_3
	end

	arg_2_0._widgets = var_2_1
	arg_2_0._widgets_by_name = var_2_2

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	if arg_2_2 then
		local var_2_4 = var_2_0.window.local_position

		var_2_4[1] = var_2_4[1] + arg_2_2[1]
		var_2_4[2] = var_2_4[2] + arg_2_2[2]
		var_2_4[3] = var_2_4[3] + arg_2_2[3]
	end
end

StartGameWindowAdventureMode.on_exit = function (arg_3_0, arg_3_1)
	print("[StartGameWindow] Exit Substate StartGameWindowAdventureMode")

	arg_3_0.ui_animator = nil
end

StartGameWindowAdventureMode.update = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:draw(arg_4_1)
end

StartGameWindowAdventureMode.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	return
end

StartGameWindowAdventureMode.draw = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.ui_renderer
	local var_6_1 = arg_6_0.ui_scenegraph
	local var_6_2 = arg_6_0.parent:window_input_service()

	UIRenderer.begin_pass(var_6_0, var_6_1, var_6_2, arg_6_1, nil, arg_6_0.render_settings)

	local var_6_3 = arg_6_0._widgets

	for iter_6_0 = 1, #var_6_3 do
		local var_6_4 = var_6_3[iter_6_0]

		UIRenderer.draw_widget(var_6_0, var_6_4)
	end

	UIRenderer.end_pass(var_6_0)
end
