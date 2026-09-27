-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_summary.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_summary_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition

StartGameWindowMutatorSummary = class(StartGameWindowMutatorSummary)
StartGameWindowMutatorSummary.NAME = "StartGameWindowMutatorSummary"

StartGameWindowMutatorSummary.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorSummary")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id

	self:create_ui_elements(arg_1_1, arg_1_2)

	self.previous_selected_backend_id = self.parent:get_selected_heroic_deed_backend_id()
end

StartGameWindowMutatorSummary.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_2
		tbl_2[k] = var_2_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	if not arg_2_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end

	tbl_2.confirm_button.content.button_hotspot.disable_button = true
	tbl_2.item_presentation_frame.content.visible = false
	tbl_2.item_presentation_bg.content.visible = false
	tbl_2.game_option_placeholder.content.visible = true
end

StartGameWindowMutatorSummary.on_exit = function (self, arg_3_1)
	-- function 3
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorSummary")

	if not self.confirm_button_pressed then
		self.parent:set_selected_heroic_deed_backend_id(self.previous_selected_backend_id)
	end
end

StartGameWindowMutatorSummary.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_handle_input(arg_4_1, arg_4_2)
	self:_update_selected_item_backend_id()
	self:draw(arg_4_1)
end

StartGameWindowMutatorSummary.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

StartGameWindowMutatorSummary._is_button_pressed = function (arg_6_0, arg_6_1)
	-- function 6
	local button_hotspot = arg_6_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowMutatorSummary._is_button_hover_enter = function (arg_7_0, arg_7_1)
	-- function 7
	return arg_7_1.content.button_hotspot.on_hover_enter
end

StartGameWindowMutatorSummary._handle_input = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._selected_backend_id then
		return
	end

	local confirm_button = self._widgets_by_name.confirm_button

	UIWidgetUtils.animate_default_button(confirm_button, arg_8_1)

	if not self:_is_button_hover_enter(confirm_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if not self:_is_button_pressed(confirm_button) then
		self.confirm_button_pressed = true

		self.parent:set_layout_by_name("heroic_deeds")
	end
end

StartGameWindowMutatorSummary._update_selected_item_backend_id = function (self)
	-- function 9
	local get_selected_heroic_deed_backend_id = self.parent:get_selected_heroic_deed_backend_id()

	if get_selected_heroic_deed_backend_id ~= self._selected_backend_id then
		self._selected_backend_id = get_selected_heroic_deed_backend_id

		self:_present_item_by_backend_id(get_selected_heroic_deed_backend_id)
	end
end

StartGameWindowMutatorSummary._present_item_by_backend_id = function (self, arg_10_1)
	-- function 10
	if not arg_10_1 then
		return
	end

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.item_presentation_frame.content.visible = true
	_widgets_by_name.item_presentation_bg.content.visible = true
	_widgets_by_name.game_option_placeholder.content.visible = false

	local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(arg_10_1)

	_widgets_by_name.item_presentation.content.item = get_item_from_id
	_widgets_by_name.confirm_button.content.button_hotspot.disable_button = false
end

StartGameWindowMutatorSummary.draw = function (self, arg_11_1)
	-- function 11
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_11_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_11_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_11_4)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowMutatorSummary._play_sound = function (self, arg_12_1)
	-- function 12
	self.parent:play_sound(arg_12_1)
end
