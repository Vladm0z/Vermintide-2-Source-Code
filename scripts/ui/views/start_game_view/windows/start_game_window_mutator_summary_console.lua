-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_summary_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_summary_console_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StartGameWindowMutatorSummaryConsole = class(StartGameWindowMutatorSummaryConsole)
StartGameWindowMutatorSummaryConsole.NAME = "StartGameWindowMutatorSummaryConsole"

StartGameWindowMutatorSummaryConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorSummaryConsole")

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

	self.previous_selected_backend_id = self.parent:get_selected_heroic_deed_backend_id()
end

StartGameWindowMutatorSummaryConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StartGameWindowMutatorSummaryConsole.create_ui_elements = function (self, arg_3_1, arg_3_2)
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

	tbl_2.game_option_placeholder.content.visible = true
end

StartGameWindowMutatorSummaryConsole.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorSummaryConsole")

	self.ui_animator = nil

	if not self.confirm_button_pressed then
		self.parent:set_selected_heroic_deed_backend_id(self.previous_selected_backend_id)
	end
end

StartGameWindowMutatorSummaryConsole.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_update_animations(arg_5_1)
	self:_update_selected_item_backend_id()
	self:draw(arg_5_1)
end

StartGameWindowMutatorSummaryConsole.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

StartGameWindowMutatorSummaryConsole._update_animations = function (self, arg_7_1)
	-- function 7
	local ui_animator = self.ui_animator

	ui_animator:update(arg_7_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StartGameWindowMutatorSummaryConsole._update_selected_item_backend_id = function (self)
	-- function 8
	local get_selected_heroic_deed_backend_id = self.parent:get_selected_heroic_deed_backend_id()

	if get_selected_heroic_deed_backend_id ~= self._selected_backend_id then
		self._selected_backend_id = get_selected_heroic_deed_backend_id

		self:_present_item_by_backend_id(get_selected_heroic_deed_backend_id)
	end
end

StartGameWindowMutatorSummaryConsole._present_item_by_backend_id = function (self, arg_9_1)
	-- function 9
	local _presenting_item = self._presenting_item

	self._presenting_item = false

	if not arg_9_1 then
		return
	end

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.game_option_placeholder.content.visible = false

	local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(arg_9_1)

	_widgets_by_name.item_presentation.content.item = get_item_from_id
	self._presenting_item = true

	local is_device_active = Managers.input:is_device_active("gamepad")

	if (_presenting_item or not IS_WINDOWS) and not is_device_active then
		self:_start_transition_animation("on_enter")
	end
end

StartGameWindowMutatorSummaryConsole.draw = function (self, arg_10_1)
	-- function 10
	local _ui_top_renderer = self._ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, ui_scenegraph, window_input_service, arg_10_1, nil, self.render_settings)

	if not self._presenting_item then
		local _widgets = self._widgets

		for i = 1, #_widgets do
			local var_10_4 = _widgets[i]

			UIRenderer.draw_widget(_ui_top_renderer, var_10_4)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
end
