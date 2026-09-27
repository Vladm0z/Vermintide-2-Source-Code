-- chunkname: @scripts/ui/help_screen/help_screen_ui.lua

local var_0_0 = dofile("scripts/ui/help_screen/help_screen_definitions")

require("scripts/ui/help_screen/help_screen_settings")

HelpScreenUI = class(HelpScreenUI)

HelpScreenUI.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1.world
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._ingame_ui = arg_1_1.ingame_ui
	self._world_manager = arg_1_1.world_manager

	local world = self._world_manager:world("level_world")

	self._wwise_world = Managers.world:wwise_world(world)

	local input_manager = arg_1_1.input_manager

	self._input_manager = input_manager

	input_manager:create_input_service("help_screen_view", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("help_screen_view", "keyboard")
	input_manager:map_device_to_service("help_screen_view", "mouse")
	input_manager:map_device_to_service("help_screen_view", "gamepad")

	self._input_service = self._input_manager:get_service("help_screen_view")
	self._ingame_ui_context = arg_1_1
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._current_view = nil
	self._current_index = 1
end

HelpScreenUI._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	self:_set_page(self._current_index)

	DO_RELOAD = false
end

DO_RELOAD = true

HelpScreenUI.update = function (self, arg_3_1)
	-- function 3
	if not self._current_view then
		return
	end

	if not DO_RELOAD then
		self:_create_ui_elements()
	end

	self:_update_input(arg_3_1)
	self:_draw(arg_3_1)
end

HelpScreenUI.show_help = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not arg_4_3 then
		-- Nothing
	end

	if not HelpScreens[arg_4_1] then
		self._current_view = arg_4_1
		self._current_index = 1

		self:_create_ui_elements()

		if not arg_4_2 then
			Managers.input:device_block_service("gamepad", 1, arg_4_2)
			Managers.input:device_block_service("keyboard", 1, arg_4_2)
			Managers.input:device_block_service("mouse", 1, arg_4_2)

			self._disabled_input_service_name = arg_4_2
		end

		Managers.input:device_unblock_service("gamepad", 1, "help_screen_view")
		Managers.input:device_unblock_service("keyboard", 1, "help_screen_view")
		Managers.input:device_unblock_service("mouse", 1, "help_screen_view")
		self:_set_page(self._current_index)
	else
		Application.warning(string.format("HelpScreenUI] Help screen not available (%s)", arg_4_1))
	end
end

HelpScreenUI.hide_help = function (self)
	-- function 5
	self:_close_help()
end

HelpScreenUI._set_page = function (self, arg_6_1)
	-- function 6
	local var_6_0 = HelpScreens[self._current_view][arg_6_1]

	self._help_screen_widget = UIWidget.init(var_0_0.help_screen_widget_func(#HelpScreens[self._current_view], arg_6_1))

	for k, v in pairs(var_6_0) do
		self._help_screen_widget.content[k] = v
	end
end

HelpScreenUI._draw = function (self, arg_7_1)
	-- function 7
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_service = self._input_service
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, _input_service, arg_7_1, nil, _render_settings)
	UIRenderer.draw_widget(_ui_top_renderer, self._help_screen_widget)
	UIRenderer.end_pass(_ui_top_renderer)
end

HelpScreenUI._update_input = function (self, arg_8_1)
	-- function 8
	if not self._input_service:get("move_left", true) then
		self._current_index = math.max(self._current_index - 1, 1)

		self:_set_page(self._current_index)
	elseif not self._input_service:get("move_right", true) then
		self._current_index = self._current_index + 1

		if self._current_index > #HelpScreens[self._current_view] then
			self:_close_help()
		else
			self:_set_page(self._current_index)
		end
	elseif self._input_service:get("back", true) or not self._input_service:get("show_gamercard", true) then
		self:_close_help()
	end
end

HelpScreenUI._close_help = function (self)
	-- function 9
	if not self._disabled_input_service_name then
		Managers.input:device_unblock_service("gamepad", 1, self._disabled_input_service_name)
		Managers.input:device_unblock_service("keyboard", 1, self._disabled_input_service_name)
		Managers.input:device_unblock_service("mouse", 1, self._disabled_input_service_name)
	end

	self._current_view = nil
	self._current_index = 1
	self._disabled_input_service_name = nil
end

HelpScreenUI.destroy = function (arg_10_0)
	-- function 10
	return
end
