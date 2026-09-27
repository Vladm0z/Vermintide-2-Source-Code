-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_ingame_view.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_ingame_view_definitions")
local var_0_1 = local_require("scripts/ui/views/ingame_view_menu_layout_console")
local widgets = var_0_0.widgets
local title_button_definitions = var_0_0.title_button_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local str = "move_down_hold_continuous"
local str_2 = "move_up_hold_continuous"
local flag = false
local tbl = {
	options_menu = function (self)
		-- function 1
		Managers.input:block_device_except_service("options_menu", "gamepad")
		self:_activate_view("options_view")
	end,
	console_friends_menu = function (self)
		-- function 2
		Managers.input:block_device_except_service("console_friends_menu", "gamepad")
		self:_activate_view("console_friends_view")
	end
}

HeroWindowIngameView = class(HeroWindowIngameView)
HeroWindowIngameView.NAME = "HeroWindowIngameView"

HeroWindowIngameView.on_enter = function (self, arg_3_1, arg_3_2)
	-- function 3
	print("[HeroViewWindow] Enter Substate HeroWindowIngameView")

	self._params = arg_3_1
	self.parent = arg_3_1.parent

	local ingame_ui_context = arg_3_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.layout_logic = IngameViewLayoutLogic:new(ingame_ui_context, arg_3_1, var_0_1.menu_layouts, var_0_1.full_access_layout)

	self.layout_logic:update()

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.hero_name = arg_3_1.hero_name
	self.career_index = arg_3_1.career_index
	self.profile_index = arg_3_1.profile_index

	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_3_4 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_3_4].careers[career_index].name

	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_3_1, arg_3_2)

	local flag = true

	self:_on_button_selected(1, flag)
	self:_start_transition_animation("on_enter")
	self:_init_menu_views()
end

HeroWindowIngameView._start_transition_animation = function (self, arg_4_1)
	-- function 4
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_4_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_4_1] = start_animation
end

HeroWindowIngameView._init_menu_views = function (self)
	-- function 5
	local ingame_ui_context = self.ingame_ui_context

	self._views = {
		options_view = ingame_ui_context.ingame_ui.views.options_view,
		console_friends_view = ingame_ui_context.ingame_ui.views.console_friends_view
	}

	for k, v in pairs(self._views) do
		v.old_exit = v.exit

		v.exit = function ()
			-- function 6
			self:exit_current_view()
		end
	end
end

HeroWindowIngameView._reset_menu_views = function (self)
	-- function 7
	for k, v in pairs(self._views) do
		v.exit = v.old_exit
		v.old_exit = nil
	end

	self._views = nil
end

HeroWindowIngameView._activate_view = function (self, arg_8_1)
	-- function 8
	self._active_view = arg_8_1

	local _views = self._views

	assert(_views[arg_8_1])

	if not arg_8_1 and not _views[arg_8_1] and not _views[arg_8_1].on_enter then
		_views[arg_8_1]:on_enter()
	end
end

HeroWindowIngameView.exit_current_view = function (self)
	-- function 9
	local _active_view = self._active_view
	local _views = self._views

	assert(_active_view)

	if not _views[_active_view] and not _views[_active_view].exit_reset_params then
		_views[_active_view]:exit_reset_params()
	end

	if not _views[_active_view] and not _views[_active_view].on_exit then
		_views[_active_view]:on_exit()
	end

	self._active_view = nil

	local name = Managers.input:get_service("hero_view").name
	local input = Managers.input

	input:block_device_except_service(name, "keyboard")
	input:block_device_except_service(name, "mouse")
	input:block_device_except_service(name, "gamepad")
	input:disable_gamepad_cursor()
end

HeroWindowIngameView.create_ui_elements = function (self, arg_10_1, arg_10_2)
	-- function 10
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_10_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_10_2
		tbl_2[k] = var_10_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}

	for k_2, v_2 in pairs(title_button_definitions) do
		local var_10_4 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_10_4
	end

	self._title_button_widgets = tbl_3

	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_10_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_10_2[1]
		local_position[2] = local_position[2] + arg_10_2[2]
		local_position[3] = local_position[3] + arg_10_2[3]
	end

	local get_service = Managers.input:get_service("hero_view")
	local num = UILayer.default + 300

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, get_service, 3, num, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
end

HeroWindowIngameView.on_exit = function (self, arg_11_1)
	-- function 11
	print("[HeroViewWindow] Exit Substate HeroWindowIngameView")

	self.ui_animator = nil

	self._menu_input_description:destroy()

	self._menu_input_description = nil

	local layout_logic = self.layout_logic

	if not layout_logic then
		layout_logic:destroy()

		self.layout_logic = nil
	end

	self:_reset_menu_views()
end

HeroWindowIngameView.update = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	local layout_logic = self.layout_logic

	if not layout_logic then
		layout_logic:update(arg_12_1)
		self:_update_presentation()
	end

	local _active_view = self._active_view

	if not _active_view then
		self._views[_active_view]:update(arg_12_1, arg_12_2)
	else
		self:_handle_input(arg_12_1, arg_12_2)
	end

	self:_update_animations(arg_12_1)
	self:draw(arg_12_1)
end

HeroWindowIngameView.post_update = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	return
end

HeroWindowIngameView._update_animations = function (self, arg_14_1)
	-- function 14
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_14_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	ui_animator:update(arg_14_1)

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

HeroWindowIngameView._is_button_pressed = function (arg_15_0, arg_15_1)
	-- function 15
	local content = arg_15_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.button_text

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowIngameView._is_stepper_button_pressed = function (arg_16_0, arg_16_1)
	-- function 16
	local content = arg_16_1.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if not button_hotspot_left.on_release then
		button_hotspot_left.on_release = false

		return true, -1
	elseif not button_hotspot_right.on_release then
		button_hotspot_right.on_release = false

		return true, 1
	end
end

HeroWindowIngameView._is_button_hover_enter = function (arg_17_0, arg_17_1)
	-- function 17
	local button_hotspot = arg_17_1.content.button_hotspot
	local on_hover_enter = button_hotspot.on_hover_enter

	on_hover_enter = not on_hover_enter and not button_hotspot.is_selected

	return on_hover_enter
end

HeroWindowIngameView._is_button_hover_exit = function (arg_18_0, arg_18_1)
	-- function 18
	local button_hotspot = arg_18_1.content.button_hotspot
	local on_hover_exit = button_hotspot.on_hover_exit

	on_hover_exit = not on_hover_exit and not button_hotspot.is_selected

	return on_hover_exit
end

HeroWindowIngameView._is_button_selected = function (arg_19_0, arg_19_1)
	-- function 19
	return arg_19_1.content.button_hotspot.is_selected
end

HeroWindowIngameView._handle_input = function (self, arg_20_1, arg_20_2)
	-- function 20
	local parent = self.parent
	local _widgets_by_name = self._widgets_by_name
	local window_input_service = parent:window_input_service()
	local layout_logic = self.layout_logic

	if not layout_logic then
		local layout_data = layout_logic:layout_data()
		local count = #layout_data
		local _selected_button_index = self._selected_button_index

		_selected_button_index = _selected_button_index or 1

		local flag = false
		local _title_button_widgets = self._title_button_widgets

		for i, v in ipairs(layout_data) do
			local var_20_9 = _title_button_widgets[i]
			local disabled = v.disabled

			if not ((i == _selected_button_index or not self:_is_button_hover_enter(var_20_9)) and disabled) then
				self:_on_button_selected(i)

				flag = true
			end

			if not (not self:_is_button_pressed(var_20_9) and disabled) then
				flag = true

				self:_on_button_pressed(i, v)
			end
		end

		if not window_input_service:get("confirm_press", true) and not layout_data[_selected_button_index] then
			local var_20_11 = layout_data[_selected_button_index]

			if not var_20_11.disabled then
				self:_on_button_pressed(_selected_button_index, var_20_11)

				flag = true
			end
		end

		if not flag then
			local var_20_12 = _selected_button_index

			if not window_input_service:get(str_2) then
				var_20_12 = self:_get_previous_available_index(_selected_button_index)
			elseif not window_input_service:get(str) then
				var_20_12 = self:_get_next_available_index(_selected_button_index)
			end

			if var_20_12 ~= _selected_button_index then
				self:_on_button_selected(var_20_12)
			end
		end
	end
end

HeroWindowIngameView._get_next_available_index = function (self, arg_21_1)
	-- function 21
	local layout_logic = self.layout_logic

	if not layout_logic then
		local layout_data = layout_logic:layout_data()
		local count = #layout_data
		local num = arg_21_1 % count + 1

		while num ~= arg_21_1 do
			if not layout_data[num].disabled then
				return num
			end

			num = num % count + 1
		end
	end

	return arg_21_1
end

HeroWindowIngameView._get_previous_available_index = function (self, arg_22_1)
	-- function 22
	local layout_logic = self.layout_logic

	if not layout_logic then
		local layout_data = layout_logic:layout_data()
		local count = #layout_data
		local num

		if arg_22_1 > 1 then
			num = arg_22_1 - 1

			if not num then
				-- Nothing
			end
		end

		num = count

		::label_22_0::

		while num ~= arg_22_1 do
			if not layout_data[num].disabled then
				return num
			end

			num = not (num > 1) or not (num - 1) or count
		end
	end

	return arg_22_1
end

HeroWindowIngameView._on_button_pressed = function (self, arg_23_1, arg_23_2)
	-- function 23
	self:_play_sound("play_gui_start_menu_button_click")

	local transition = arg_23_2.transition

	if not tbl[transition] then
		tbl[transition](self)
	else
		self.layout_logic:execute_layout_option(arg_23_1)
	end
end

HeroWindowIngameView._on_button_selected = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _title_button_widgets = self._title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		v.content.button_hotspot.is_selected = i == arg_24_1
	end

	if not arg_24_2 then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	self._selected_button_index = arg_24_1
end

HeroWindowIngameView.draw = function (self, arg_25_1)
	-- function 25
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")
	local layout_logic = self.layout_logic

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_25_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	if not layout_logic then
		local layout_data = layout_logic:layout_data()
		local _title_button_widgets = self._title_button_widgets

		for i_2, v_2 in ipairs(layout_data) do
			local var_25_8 = _title_button_widgets[i_2]
			local content = var_25_8.content

			content.button_hotspot.disable_button = v_2.disabled

			local display_name_func

			if not v_2.display_name_func then
				display_name_func = v_2.display_name_func()

				if not display_name_func then
					-- Nothing
				end
			end

			display_name_func = v_2.display_name

			::label_25_0::

			content.text_field = display_name_func

			UIRenderer.draw_widget(ui_top_renderer, var_25_8)
		end
	end

	UIRenderer.end_pass(ui_top_renderer)

	if not (not is_device_active and not self._menu_input_description and self._active_view) then
		self._menu_input_description:draw(ui_top_renderer, arg_25_1)
	end
end

HeroWindowIngameView._play_sound = function (self, arg_26_1)
	-- function 26
	self.parent:play_sound(arg_26_1)
end

HeroWindowIngameView._update_presentation = function (self)
	-- function 27
	local count = #self.layout_logic:layout_data()

	if count ~= self._num_entries then
		local _title_button_widgets = self._title_button_widgets
		local num = 60
		local num_2 = 0

		for i = 1, count do
			_title_button_widgets[i].offset[2] = -(num * i - 1)
			num_2 = num_2 + num
		end

		local scenegraph_id = self._widgets_by_name.background.scenegraph_id

		self.ui_scenegraph[scenegraph_id].size[2] = num_2 + 90
	end
end
