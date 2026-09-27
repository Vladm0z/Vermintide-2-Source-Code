-- chunkname: @scripts/ui/views/ingame_view.lua

require("scripts/ui/views/ingame_view_definitions")
require("scripts/ui/views/ingame_view_layout_logic")
require("scripts/ui/views/menu_input_description_ui")

local var_0_0 = local_require("scripts/ui/views/ingame_view_menu_layout")
local tbl = {
	{
		input_action = "confirm",
		priority = 2,
		description_text = "input_description_open"
	},
	{
		input_action = "back",
		priority = 3,
		description_text = "input_description_close"
	}
}

IngameView = class(IngameView)

IngameView.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_renderer
	self.ui_top_renderer = arg_1_1.ui_top_renderer
	self.input_manager = arg_1_1.input_manager
	self.menu_active = false
	self.ingame_ui = arg_1_1.ingame_ui
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.ingame_ui_context = arg_1_1
	self.network_lobby = arg_1_1.network_lobby

	local is_in_inn = arg_1_1.is_in_inn

	self.is_server = arg_1_1.is_server
	self.menu_definition = IngameViewDefinitions

	self:create_ui_elements()

	self.ui_animations = {}
	self.controller_grid_index = {
		x = 1,
		y = 1
	}
	self.controller_cooldown = 0

	local get_service = self.input_manager:get_service("ingame_menu")
	local num = 3
	local world = Managers.world:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)
	self._friends_component_ui = FriendsUIComponent:new(arg_1_1)

	local var_1_4 = self.menu_definition.scenegraph_definition.root.position[3]

	self.menu_input_description = MenuInputDescriptionUI:new(arg_1_1, self.ui_top_renderer, get_service, num, var_1_4, tbl)

	self.menu_input_description:set_input_description(nil)
end

local num = 0.3

IngameView.on_enter = function (self, arg_2_1)
	-- function 2
	self.layout_logic = IngameViewLayoutLogic:new(self.ingame_ui_context, arg_2_1, var_0_0.menu_layouts, var_0_0.full_access_layout)
	self.controller_cooldown = 0.2

	self.input_manager:block_device_except_service("ingame_menu", "keyboard", 1)
	self.input_manager:block_device_except_service("ingame_menu", "mouse", 1)
	self.input_manager:block_device_except_service("ingame_menu", "gamepad", 1)

	if not script_data.debug_enabled then
		self.input_manager:device_unblock_service("keyboard", 1, "Debug")
	end

	ShowCursorStack.show("IngameView")
	self:play_sound("Play_hud_button_open")

	local world = self.ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_amount", 0.75)
		ShadingEnvironment.apply(get_data)
	end

	Managers.state.event:trigger("ingame_menu_opened", "interacting")
end

IngameView.on_exit = function (self)
	-- function 3
	if not self._friends_component_ui:is_active() then
		self._friends_component_ui:deactivate_friends_ui()
	end

	ShowCursorStack.hide("IngameView")
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
	self:play_sound("Play_hud_button_close")

	local world = self.ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_enabled", 0)
		ShadingEnvironment.set_scalar(get_data, "fullscreen_blur_amount", 0)
		ShadingEnvironment.apply(get_data)
	end

	Managers.state.event:trigger("ingame_menu_closed")
	self.layout_logic:destroy()

	self.layout_logic = nil
end

IngameView.input_service = function (self)
	-- function 4
	return self.input_manager:get_service("ingame_menu")
end

IngameView.create_ui_elements = function (self)
	-- function 5
	local widgets = self.menu_definition.widgets

	self.stored_buttons = {
		UIWidget.init(widgets.button_1),
		UIWidget.init(widgets.button_2),
		UIWidget.init(widgets.button_3),
		UIWidget.init(widgets.button_4),
		UIWidget.init(widgets.button_5),
		UIWidget.init(widgets.button_6),
		UIWidget.init(widgets.button_7),
		UIWidget.init(widgets.button_8),
		UIWidget.init(widgets.button_9)
	}

	for i, v in ipairs(self.stored_buttons) do
		v.style.title_text.localize = true
		v.style.title_text_disabled.localize = true
		v.style.title_text_shadow.localize = true
	end

	self.static_widgets = {
		UIWidget.init(widgets.background),
		UIWidget.init(widgets.top_panel),
		UIWidget.init(widgets.left_chain_end)
	}
	self.left_chain_widget = UIWidget.init(widgets.left_chain)
	self.right_chain_widget = UIWidget.init(widgets.right_chain)
	self.console_cursor_widget = UIWidget.init(widgets.console_cursor)
	self.ui_scenegraph = UISceneGraph.init_scenegraph(self.menu_definition.scenegraph_definition)
end

IngameView._update_presentation = function (self)
	-- function 6
	local count = #self.layout_logic:layout_data()

	if count ~= self._num_entries then
		local controller_selection_index = self.controller_selection_index

		if not (not controller_selection_index and not (count < controller_selection_index)) then
			self:controller_select_button_index(count, true)
		end

		self:set_background_height(count)

		self._num_entries = count
	end
end

IngameView.destroy = function (self)
	-- function 7
	self.menu_input_description:destroy()

	self.menu_input_description = nil
end

IngameView.set_background_height = function (self, arg_8_1)
	-- function 8
	local MENU_BUTTON_SPACING = self.menu_definition.MENU_BUTTON_SPACING
	local num = arg_8_1 * (self.menu_definition.MENU_BUTTON_SIZE[2] + MENU_BUTTON_SPACING)
	local ui_scenegraph = self.ui_scenegraph

	ui_scenegraph.window.size[2] = num
	ui_scenegraph[self.left_chain_widget.scenegraph_id].size[2] = num + 40
	ui_scenegraph[self.right_chain_widget.scenegraph_id].size[2] = num + 100
end

IngameView.update = function (self, arg_9_1)
	-- function 9
	local layout_logic = self.layout_logic

	layout_logic:update(arg_9_1)
	self:_update_presentation()

	if not self._reinit_menu_input_description_next_update then
		self._reinit_menu_input_description_next_update = nil

		self.menu_input_description:set_input_description(tbl)
	end

	local ui_top_renderer = self.ui_top_renderer
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("ingame_menu")
	local is_device_active = input_manager:is_device_active("gamepad")

	if not Managers.account:is_online() then
		self._friends_component_ui:update(arg_9_1, get_service)
	end

	local ui_animations = self.ui_animations

	for k, v in pairs(ui_animations) do
		UIAnimation.update(v, arg_9_1)
	end

	local ui_scenegraph = self.ui_scenegraph

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, get_service, arg_9_1, nil, self.render_settings)
	UIRenderer.draw_widget(ui_top_renderer, self.left_chain_widget)
	UIRenderer.draw_widget(ui_top_renderer, self.right_chain_widget)

	for i, v_2 in ipairs(self.static_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_2)
	end

	if not is_device_active then
		UIRenderer.draw_widget(ui_top_renderer, self.console_cursor_widget)
	end

	local layout_data = layout_logic:layout_data()
	local ingame_ui = self.ingame_ui

	if not layout_data then
		local stored_buttons = self.stored_buttons

		for i_2, v_3 in ipairs(layout_data) do
			local var_9_10 = stored_buttons[i_2]
			local content = var_9_10.content

			content.button_hotspot.disable_button = v_3.disabled
			content.title_text = v_3.display_name

			UIWidgetUtils.animate_default_button(var_9_10, arg_9_1)
			UIRenderer.draw_widget(ui_top_renderer, var_9_10)

			if not var_9_10.content.button_hotspot.on_hover_enter then
				self:play_sound("Play_hud_hover")
			end

			if not ingame_ui:pending_transition() then
				local on_release = var_9_10.content.button_hotspot.on_release
				local flag = not (self.controller_cooldown < 0) or self.controller_selection_index ~= i_2 or get_service:get("confirm", true)

				if on_release or not flag then
					var_9_10.content.button_hotspot.on_release = nil

					self:play_sound("Play_hud_select")
					layout_logic:execute_layout_option(i_2)

					self._reinit_menu_input_description_next_update = true
					self.controller_cooldown = GamepadSettings.menu_cooldown
				end
			end
		end
	end

	UIRenderer.end_pass(ui_top_renderer)

	self.gamepad_active_last_frame = is_device_active

	local join_lobby_data = self._friends_component_ui:join_lobby_data()

	if not join_lobby_data and not Managers.matchmaking:allowed_to_initiate_join_lobby() then
		Managers.matchmaking:request_join_lobby(join_lobby_data)
		ingame_ui:handle_transition("exit_menu")
	end

	if not ((get_service:get("toggle_menu", true) or not get_service:get("back", true)) and ingame_ui:pending_transition()) then
		ingame_ui:handle_transition("exit_menu")
	end
end

IngameView.setup_controller_selection = function (self)
	-- function 10
	local num = 1

	self:controller_select_button_index(num, true)
end

IngameView.controller_select_button_index = function (self, arg_11_1, arg_11_2)
	-- function 11
	local flag = false
	local layout_logic = self.layout_logic
	local stored_buttons = self.stored_buttons
	local layout_data = layout_logic:layout_data()
	local var_11_4 = stored_buttons[arg_11_1]

	if not layout_data[arg_11_1] and not var_11_4.content.button_hotspot.disable_button then
		return flag
	end

	local scenegraph_id = self.gamepad_button_selection_widget.scenegraph_id
	local position = self.menu_definition.scenegraph_definition[scenegraph_id].position
	local local_position = self.ui_scenegraph[scenegraph_id].local_position

	for i, v in ipairs(layout_data) do
		local var_11_8 = stored_buttons[i]
		local flag_2 = i == arg_11_1

		var_11_8.content.button_hotspot.is_selected = flag_2

		if not flag_2 then
			local scenegraph_id_2 = var_11_8.scenegraph_id
			local local_position_2 = self.ui_scenegraph[scenegraph_id_2].local_position

			local_position[2] = position[2] - i * 84
		end
	end

	if not (arg_11_2 or arg_11_1 == self.controller_selection_index) then
		self:play_sound("Play_hud_hover")
	end

	self.controller_selection_index = arg_11_1

	return true
end

IngameView.clear_controller_selection = function (self)
	-- function 12
	local layout_logic = self.layout_logic
	local stored_buttons = self.stored_buttons
	local layout_data = layout_logic:layout_data()

	for i, v in ipairs(layout_data) do
		stored_buttons[i].content.button_hotspot.is_selected = false
	end
end

IngameView.update_controller_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	local count = #self.layout_logic:layout_data()

	if self.controller_cooldown > 0 then
		self.controller_cooldown = self.controller_cooldown - arg_13_2

		local speed_multiplier = self.speed_multiplier

		speed_multiplier = speed_multiplier or 1

		local menu_speed_multiplier_frame_decrease = GamepadSettings.menu_speed_multiplier_frame_decrease
		local menu_min_speed_multiplier = GamepadSettings.menu_min_speed_multiplier

		self.speed_multiplier = math.max(speed_multiplier - menu_speed_multiplier_frame_decrease, menu_min_speed_multiplier)

		return
	else
		local speed_multiplier_2 = self.speed_multiplier

		speed_multiplier_2 = speed_multiplier_2 or 1

		repeat
			local get = arg_13_1:get("move_up")
			local get_2 = arg_13_1:get("move_up_hold")
			local controller_selection_index = self.controller_selection_index

			controller_selection_index = controller_selection_index or 0

			if get or not get_2 then
				local max = math.max(controller_selection_index - 1, 1)
				local controller_select_button_index = self:controller_select_button_index(max)

				while not controller_select_button_index do
					max = math.max(max - 1, 1)
					controller_select_button_index = self:controller_select_button_index(max)
				end

				self.controller_cooldown = GamepadSettings.menu_cooldown * speed_multiplier_2

				return
			end

			local get_3 = arg_13_1:get("move_down")
			local get_4 = arg_13_1:get("move_down_hold")

			if get_3 or not get_4 then
				local min = math.min(controller_selection_index + 1, count)
				local controller_select_button_index_2 = self:controller_select_button_index(min)

				while not controller_select_button_index_2 do
					min = math.min(min + 1, count)
					controller_select_button_index_2 = self:controller_select_button_index(min)
				end

				self.controller_cooldown = GamepadSettings.menu_cooldown * speed_multiplier_2

				return
			end
		until true
	end

	self.speed_multiplier = 1
end

IngameView.get_transition = function (self)
	-- function 14
	if not self.leave_game then
		return "leave_game"
	end
end

IngameView.play_sound = function (self, arg_15_1)
	-- function 15
	WwiseWorld.trigger_event(self.wwise_world, arg_15_1)
end
