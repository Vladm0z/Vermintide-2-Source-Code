-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_heroic_deed_overview_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_heroic_deed_overview_console_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widgets = var_0_0.widgets
local animation_definitions = var_0_0.animation_definitions
local selector_input_definition = var_0_0.selector_input_definition
local str = "refresh_press"
local str_2 = "confirm_press"

StartGameWindowHeroicDeedOverviewConsole = class(StartGameWindowHeroicDeedOverviewConsole)
StartGameWindowHeroicDeedOverviewConsole.NAME = "StartGameWindowHeroicDeedOverviewConsole"

StartGameWindowHeroicDeedOverviewConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameViewWindow] Enter Substate StartGameWindowHeroicDeedOverviewConsole")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._stats_id = Managers.player:local_player():stats_id()
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)

	local input_index = arg_1_1.input_index

	input_index = input_index or 1
	self._input_index = input_index

	self:_handle_new_selection(self._input_index)

	self._is_focused = false
	self._play_button_pressed = false
	self._show_additional_settings = false
	self._previous_can_play = nil

	self._parent:change_generic_actions("default")
	self:_start_transition_animation("on_enter")
end

StartGameWindowHeroicDeedOverviewConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StartGameWindowHeroicDeedOverviewConsole._create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end
end

StartGameWindowHeroicDeedOverviewConsole.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameViewWindow] Exit Substate StartGameWindowHeroicDeedOverviewConsole")

	self._ui_animator = nil

	if not self._play_button_pressed then
		arg_4_1.input_index = nil
	else
		arg_4_1.input_index = self._input_index
	end
end

StartGameWindowHeroicDeedOverviewConsole.set_focus = function (self, arg_5_1)
	-- function 5
	self._is_focused = arg_5_1
end

StartGameWindowHeroicDeedOverviewConsole.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_heroic_deed_selection()
	self:_update_can_play()
	self:_update_animations(arg_6_1)
	self:_handle_input(arg_6_1, arg_6_2)
	self:_draw(arg_6_1)
end

StartGameWindowHeroicDeedOverviewConsole.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

StartGameWindowHeroicDeedOverviewConsole._present_heroic_deed = function (self, arg_8_1)
	-- function 8
	local get_interface = Managers.backend:get_interface("items")
	local flag = not arg_8_1 and get_interface:get_item_masterlist_data(arg_8_1)
	local heroic_deed_setting = self._widgets_by_name.heroic_deed_setting
	local content = heroic_deed_setting.content
	local var_8_4

	if not flag then
		var_8_4 = Localize(flag.display_name)

		if not var_8_4 then
			-- Nothing
		end
	end

	var_8_4 = Localize("not_assigned")

	::label_8_0::

	content.input_text = var_8_4

	local content_2 = heroic_deed_setting.content
	local inventory_icon

	if not flag then
		inventory_icon = flag.inventory_icon

		if not inventory_icon then
			-- Nothing
		end
	end

	inventory_icon = nil

	::label_8_1::

	content_2.icon_texture = inventory_icon
end

StartGameWindowHeroicDeedOverviewConsole._update_heroic_deed_selection = function (self)
	-- function 9
	local get_selected_heroic_deed_backend_id = self._parent:get_selected_heroic_deed_backend_id()

	if get_selected_heroic_deed_backend_id ~= self._selected_backend_id then
		self._selected_backend_id = get_selected_heroic_deed_backend_id

		if get_selected_heroic_deed_backend_id ~= nil then
			self:_present_heroic_deed(get_selected_heroic_deed_backend_id)
		end
	end
end

StartGameWindowHeroicDeedOverviewConsole._update_can_play = function (self)
	-- function 10
	local _can_play = self:_can_play()

	if self._previous_can_play ~= _can_play then
		self._previous_can_play = _can_play

		local play_button = self._widgets_by_name.play_button

		play_button.content.button_hotspot.disable_button = not _can_play
		play_button.content.disabled = not _can_play

		if not _can_play then
			self._parent:set_input_description("play_available")
		else
			self._parent:set_input_description(nil)
		end
	end
end

StartGameWindowHeroicDeedOverviewConsole._is_button_hover_enter = function (arg_11_0, arg_11_1)
	-- function 11
	return arg_11_1.content.button_hotspot.on_hover_enter
end

StartGameWindowHeroicDeedOverviewConsole._is_button_pressed = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowHeroicDeedOverviewConsole._handle_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _parent = self._parent
	local window_input_service = _parent:window_input_service()

	if not window_input_service:get(str_2) then
		self:_option_selected(self._input_index, arg_13_2)
	end

	local _input_index = self._input_index

	if not window_input_service:get("move_down") then
		_input_index = _input_index + 1
	elseif not window_input_service:get("move_up") then
		_input_index = _input_index - 1
	end

	if _input_index ~= self._input_index then
		self:_handle_new_selection(_input_index)
	end

	local _widgets_by_name = self._widgets_by_name

	for i = 1, #selector_input_definition do
		local var_13_4 = _widgets_by_name[selector_input_definition[i]]

		if var_13_4.content.is_selected or not self:_is_button_hover_enter(var_13_4) then
			self:_handle_new_selection(i)
		end

		if not self:_is_button_pressed(var_13_4) then
			self:_option_selected(self._input_index, arg_13_2)
		end
	end

	if not self:_can_play() then
		if not self:_is_button_hover_enter(_widgets_by_name.play_button) then
			self._parent:play_sound("Play_hud_hover")
		end

		if window_input_service:get(str) or not self:_is_button_pressed(_widgets_by_name.play_button) then
			self._play_button_pressed = true

			_parent:play(arg_13_2, "deed")
		end
	end
end

StartGameWindowHeroicDeedOverviewConsole._can_play = function (self)
	-- function 14
	if not Managers.backend:get_interface("items"):get_item_from_id(self._selected_backend_id) then
		self._selected_backend_id = nil
	end

	if not self._parent:get_selected_heroic_deed_backend_id() then
		return false
	end

	return self._selected_backend_id ~= nil
end

StartGameWindowHeroicDeedOverviewConsole._option_selected = function (self, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0 = selector_input_definition[arg_15_1]

	if var_15_0 == "heroic_deed_setting" then
		self._parent:set_layout_by_name("heroic_deed_selection")
	elseif var_15_0 == "play_button" then
		if not self:_can_play() then
			self._play_button_pressed = true

			self._parent:play(arg_15_2, "deed")
		end
	else
		ferror("Unknown selector_input_definition: %s", var_15_0)
	end
end

StartGameWindowHeroicDeedOverviewConsole._handle_new_selection = function (self, arg_16_1)
	-- function 16
	local _widgets_by_name = self._widgets_by_name
	local count = #selector_input_definition

	arg_16_1 = math.clamp(arg_16_1, 1, count)

	if not _widgets_by_name[selector_input_definition[arg_16_1]].content.disabled then
		return
	end

	for i = 1, #selector_input_definition do
		local var_16_2 = _widgets_by_name[selector_input_definition[i]]
		local flag = i == arg_16_1

		var_16_2.content.is_selected = flag
	end

	self._input_index = arg_16_1
end

StartGameWindowHeroicDeedOverviewConsole._update_animations = function (self, arg_17_1)
	-- function 17
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_17_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_start_game_console_setting_button(_widgets_by_name.heroic_deed_setting, arg_17_1)
	UIWidgetUtils.animate_play_button(_widgets_by_name.play_button, arg_17_1)
end

StartGameWindowHeroicDeedOverviewConsole._draw = function (self, arg_18_1)
	-- function 18
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local var_18_4

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_18_1, var_18_4, _render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_18_6 = _widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_18_6)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end
