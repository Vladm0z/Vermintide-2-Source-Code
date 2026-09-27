-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_event.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_event_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition

StartGameWindowEvent = class(StartGameWindowEvent)
StartGameWindowEvent.NAME = "StartGameWindowEvent"

StartGameWindowEvent.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowEvent")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self._parent:set_play_button_enabled(true)
end

StartGameWindowEvent._create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_3
		tbl_2[k] = var_2_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	if not arg_2_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end

	self:_setup_content_from_backend()
end

StartGameWindowEvent._setup_content_from_backend = function (self)
	-- function 3
	local _widgets_by_name = self._widgets_by_name
	local get_weekly_events_game_mode_data = Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data()
	local title_text_id = get_weekly_events_game_mode_data.title_text_id

	_widgets_by_name.event_title.content.text = Localize(title_text_id)

	local description_text_id = get_weekly_events_game_mode_data.description_text_id

	_widgets_by_name.description_text.content.text = Localize(description_text_id)

	local icon_id = get_weekly_events_game_mode_data.icon_id
	local event_texture = _widgets_by_name.event_texture
	local str = "event_mode_texture"
	local image_id = get_weekly_events_game_mode_data.image_id

	image_id = image_id or "event_default_ui_art"

	local gui = self._ui_renderer.gui
	local setup_backend_image_material = self._parent:setup_backend_image_material(gui, str, image_id)

	if not setup_backend_image_material then
		event_texture.content.texture_id = setup_backend_image_material
	else
		event_texture.content.texture_id = icon_id
	end
end

StartGameWindowEvent.on_exit = function (arg_4_0, arg_4_1)
	-- function 4
	print("[StartGameWindow] Exit Substate StartGameWindowEvent")
end

StartGameWindowEvent.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_draw(arg_5_1)
end

StartGameWindowEvent.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

StartGameWindowEvent._draw = function (self, arg_7_1)
	-- function 7
	local _ui_renderer = self._ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_renderer, ui_scenegraph, window_input_service, arg_7_1, nil, _render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_7_5 = _widgets[i]

		UIRenderer.draw_widget(_ui_renderer, var_7_5)
	end

	UIRenderer.end_pass(_ui_renderer)
end
