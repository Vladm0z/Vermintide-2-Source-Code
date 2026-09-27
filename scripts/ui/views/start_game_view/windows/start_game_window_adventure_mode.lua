-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_adventure_mode.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_adventure_mode_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition

StartGameWindowAdventureMode = class(StartGameWindowAdventureMode)
StartGameWindowAdventureMode.NAME = "StartGameWindowAdventureMode"

StartGameWindowAdventureMode.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowAdventureMode")

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
	self.parent:set_play_button_enabled(true)
end

StartGameWindowAdventureMode.create_ui_elements = function (self, arg_2_1, arg_2_2)
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

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	if not arg_2_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

StartGameWindowAdventureMode.on_exit = function (self, arg_3_1)
	-- function 3
	print("[StartGameWindow] Exit Substate StartGameWindowAdventureMode")

	self.ui_animator = nil
end

StartGameWindowAdventureMode.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:draw(arg_4_1)
end

StartGameWindowAdventureMode.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

StartGameWindowAdventureMode.draw = function (self, arg_6_1)
	-- function 6
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_6_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_6_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_6_4)
	end

	UIRenderer.end_pass(ui_renderer)
end
