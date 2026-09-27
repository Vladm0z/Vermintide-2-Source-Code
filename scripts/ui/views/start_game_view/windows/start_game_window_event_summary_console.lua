-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_event_summary_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_event_summary_console_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StartGameWindowEventSummaryConsole = class(StartGameWindowEventSummaryConsole)
StartGameWindowEventSummaryConsole.NAME = "StartGameWindowEventSummaryConsole"

StartGameWindowEventSummaryConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowEventSummaryConsole")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
end

StartGameWindowEventSummaryConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StartGameWindowEventSummaryConsole.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	self:_setup_content_from_backend()
end

StartGameWindowEventSummaryConsole._setup_content_from_backend = function (self)
	-- function 4
	local get_weekly_events_game_mode_data = Managers.backend:get_interface("live_events"):get_weekly_events_game_mode_data()
	local event_summary = self._widgets_by_name.event_summary
	local level_key = get_weekly_events_game_mode_data.level_key
	local mutators = get_weekly_events_game_mode_data.mutators

	event_summary.content.item = {
		level_key = level_key,
		mutators = mutators
	}
end

StartGameWindowEventSummaryConsole.on_exit = function (self, arg_5_1)
	-- function 5
	print("[StartGameWindow] Exit Substate StartGameWindowEventSummaryConsole")

	self.ui_animator = nil
end

StartGameWindowEventSummaryConsole.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_animations(arg_6_1)
	self:draw(arg_6_1)
end

StartGameWindowEventSummaryConsole.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

StartGameWindowEventSummaryConsole._update_animations = function (self, arg_8_1)
	-- function 8
	local ui_animator = self.ui_animator

	ui_animator:update(arg_8_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StartGameWindowEventSummaryConsole.draw = function (self, arg_9_1)
	-- function 9
	local _ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, ui_scenegraph, window_input_service, arg_9_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_9_4 = _widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_9_4)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end
