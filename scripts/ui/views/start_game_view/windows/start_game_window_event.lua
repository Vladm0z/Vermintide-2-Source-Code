-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_event.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_event_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition

StartGameWindowEvent = class(StartGameWindowEvent)
StartGameWindowEvent.NAME = "StartGameWindowEvent"

StartGameWindowEvent.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowEvent")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0._parent:set_play_button_enabled(true)
end

StartGameWindowEvent._create_ui_elements = function (arg_2_0, arg_2_1, arg_2_2)
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

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)

	if arg_2_2 then
		local var_2_4 = var_2_0.window.local_position

		var_2_4[1] = var_2_4[1] + arg_2_2[1]
		var_2_4[2] = var_2_4[2] + arg_2_2[2]
		var_2_4[3] = var_2_4[3] + arg_2_2[3]
	end

	arg_2_0:_setup_content_from_backend()
end

StartGameWindowEvent._setup_content_from_backend = function (arg_3_0)
	local var_3_0 = arg_3_0._widgets_by_name
	local var_3_1 = Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data()
	local var_3_2 = var_3_1.title_text_id

	var_3_0.event_title.content.text = Localize(var_3_2)

	local var_3_3 = var_3_1.description_text_id

	var_3_0.description_text.content.text = Localize(var_3_3)

	local var_3_4 = var_3_1.icon_id
	local var_3_5 = var_3_0.event_texture
	local var_3_6 = "event_mode_texture"
	local var_3_7 = var_3_1.image_id or "event_default_ui_art"
	local var_3_8 = arg_3_0._ui_renderer.gui
	local var_3_9 = arg_3_0._parent:setup_backend_image_material(var_3_8, var_3_6, var_3_7)

	if var_3_9 then
		var_3_5.content.texture_id = var_3_9
	else
		var_3_5.content.texture_id = var_3_4
	end
end

StartGameWindowEvent.on_exit = function (arg_4_0, arg_4_1)
	print("[StartGameWindow] Exit Substate StartGameWindowEvent")
end

StartGameWindowEvent.update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_draw(arg_5_1)
end

StartGameWindowEvent.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	return
end

StartGameWindowEvent._draw = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._ui_renderer
	local var_7_1 = arg_7_0.ui_scenegraph
	local var_7_2 = arg_7_0._parent:window_input_service()
	local var_7_3 = arg_7_0._render_settings

	UIRenderer.begin_pass(var_7_0, var_7_1, var_7_2, arg_7_1, nil, var_7_3)

	local var_7_4 = arg_7_0._widgets

	for iter_7_0 = 1, #var_7_4 do
		local var_7_5 = var_7_4[iter_7_0]

		UIRenderer.draw_widget(var_7_0, var_7_5)
	end

	UIRenderer.end_pass(var_7_0)
end
