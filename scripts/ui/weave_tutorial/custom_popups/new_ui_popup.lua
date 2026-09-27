-- chunkname: @scripts/ui/weave_tutorial/custom_popups/new_ui_popup.lua

local var_0_0 = local_require("scripts/ui/weave_tutorial/custom_popups/new_ui_popup_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local page_data = var_0_0.page_data
local str = "new_ui_popup"

NewUIPopup = class(NewUIPopup)

NewUIPopup.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._input_manager = arg_1_1.input_manager
	self._world = arg_1_1.world
	self._wwise_world = Managers.world:wwise_world(self.world)
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._parent = arg_1_2
	self._animations = {}

	self:_create_ui_elements()

	local get_service = Managers.input:get_service("weave_tutorial")

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, get_service, 3, 900, generic_input_actions.default)

	self._menu_input_description:set_input_description(nil)
end

NewUIPopup.destroy = function (self)
	-- function 2
	self:_destroy_video()
end

NewUIPopup._create_ui_elements = function (self)
	-- function 3
	self:_destroy_video()

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local base_widget_definitions = var_0_0.base_widget_definitions

	for k, v in pairs(base_widget_definitions) do
		local var_3_5 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_5
		tbl_4[k] = var_3_5
	end

	local page_widget_definitions = var_0_0.page_widget_definitions

	for k_2, v_2 in pairs(page_widget_definitions) do
		local var_3_7 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_3_7
		tbl_4[k_2] = var_3_7
	end

	self._base_widgets = tbl
	self._page_widgets = tbl_3
	self._widgets_by_name = tbl_4
	self._pages_seen = 0

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	self:_change_page(1)
end

NewUIPopup._clear_page_data = function (self)
	-- function 4
	self:_destroy_video()

	self._current_page_widgets = {}
end

NewUIPopup._change_page = function (self, arg_5_1)
	-- function 5
	self:_clear_page_data()

	local var_5_0 = page_data[arg_5_1]
	local widgets = var_5_0.widgets
	local _widgets_by_name = self._widgets_by_name

	for k, v in pairs(widgets) do
		self._current_page_widgets[#self._current_page_widgets + 1] = _widgets_by_name[v]
	end

	self:_create_video(var_5_0.video)

	if arg_5_1 < #page_data then
		self._current_page_widgets[#self._current_page_widgets + 1] = self._widgets_by_name.next_button
	else
		self._current_page_widgets[#self._current_page_widgets + 1] = self._widgets_by_name.ok_button
	end

	if arg_5_1 > 1 then
		self._current_page_widgets[#self._current_page_widgets + 1] = self._widgets_by_name.prev_button
	end

	self._page_index = arg_5_1
	self._button_index = nil

	if arg_5_1 > self._pages_seen then
		self:start_transition_animation("page_enter", "page_" .. arg_5_1)

		self._pages_seen = arg_5_1
	end
end

NewUIPopup._create_video = function (self, arg_6_1)
	-- function 6
	if not arg_6_1 then
		return
	end

	self._video_data = arg_6_1
	self._video_widget = UIWidget.init(UIWidgets.create_video("video", self._video_data.material_name, str))
end

NewUIPopup._destroy_video = function (self)
	-- function 7
	local _ui_top_renderer = self._ui_top_renderer

	self._video_data = nil

	if not self._video_widget then
		UIWidget.destroy(_ui_top_renderer, self._video_widget)

		self._video_widget = nil
	end

	if not _ui_top_renderer.video_players[str] then
		UIRenderer.destroy_video_player(_ui_top_renderer, str, self._world)
	end
end

NewUIPopup.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:_update_animations(arg_8_1)
	self:_handle_input(arg_8_1, arg_8_2)
	self:_draw(arg_8_1, arg_8_2)
end

NewUIPopup._update_animations = function (self, arg_9_1)
	-- function 9
	self._ui_animator:update(arg_9_1)

	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	if #page_data > self._page_index then
		UIWidgetUtils.animate_default_button(self._widgets_by_name.next_button, arg_9_1)
	else
		UIWidgetUtils.animate_default_button(self._widgets_by_name.ok_button, arg_9_1)
	end

	if self._page_index > 1 then
		UIWidgetUtils.animate_default_button(self._widgets_by_name.prev_button, arg_9_1)
	end
end

NewUIPopup._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._video_exanded then
		self:_handle_keyboard_input(arg_10_1, arg_10_2)

		local get = arg_10_2:get("confirm", true)
		local _page_index = self._page_index
		local count = #page_data

		if count > self._page_index then
			if not self._widgets_by_name.next_button.content.visible and not UIUtils.is_button_pressed(self._widgets_by_name.next_button, nil, get) then
				_page_index = math.min(_page_index + 1, count)
			end
		elseif not self._widgets_by_name.ok_button.content.visible and not UIUtils.is_button_pressed(self._widgets_by_name.ok_button, nil, get) then
			self._parent:hide()
		end

		if (not (self._page_index > 1) or not self._widgets_by_name.prev_button.content.visible) and not UIUtils.is_button_pressed(self._widgets_by_name.prev_button, nil, get) then
			_page_index = math.max(_page_index - 1, 1)
		end

		if _page_index ~= self._page_index then
			self:_change_page(_page_index)
		end
	end

	self:_handle_expand_video(arg_10_2)
end

NewUIPopup._handle_keyboard_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	local tbl = {}
	local _widgets_by_name = self._widgets_by_name
	local _page_index = self._page_index
	local count = #page_data

	if self._page_index > 1 then
		tbl[#tbl + 1] = _widgets_by_name.prev_button
	end

	if count > self._page_index then
		tbl[#tbl + 1] = _widgets_by_name.next_button
	else
		tbl[#tbl + 1] = _widgets_by_name.ok_button
	end

	if not Managers.input:is_device_active("mouse") then
		for k, v in pairs(tbl) do
			v.content.button_hotspot.is_selected = false
		end

		self._button_index = nil

		return
	end

	local count_2 = #tbl
	local _button_index = self._button_index

	_button_index = _button_index or count_2

	local get_service = Managers.input:get_service("popup")

	if not get_service:get("move_right_hold_continuous") then
		_button_index = math.clamp(_button_index + 1, 1, count_2)
	elseif not get_service:get("move_left_hold_continuous") then
		_button_index = math.clamp(_button_index - 1, 1, count_2)
	end

	if _button_index ~= self._button_index then
		for i, v_2 in ipairs(tbl) do
			v_2.content.button_hotspot.is_selected = _button_index == i
		end

		self._button_index = _button_index

		self:_play_sound("Play_hud_hover")
	end
end

NewUIPopup._draw = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, arg_12_2, arg_12_1, nil, _render_settings)

	for i, v in ipairs(self._base_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	for i_2, v_2 in ipairs(self._current_page_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v_2)
	end

	self:_draw_video(_ui_top_renderer)
	UIRenderer.end_pass(_ui_top_renderer)

	if not is_device_active then
		self._menu_input_description:draw(_ui_top_renderer, arg_12_1)
	end
end

NewUIPopup._draw_video = function (self, arg_13_1)
	-- function 13
	if not self._video_data then
		return
	end

	if not arg_13_1.video_players[str] then
		UIRenderer.create_video_player(arg_13_1, str, self._world, self._video_data.video_name, self._video_data.loop)
	elseif not (not self._video_widget.content.video_content.video_completed and self._video_data.loop) then
		UIRenderer.destroy_video_player(arg_13_1, str)

		self._video_data.sound_started = false

		if not self._video_data.sound_stop then
			Managers.music:trigger_event(self._video_data.sound_stop)
		end

		if not Managers.transition:loading_icon_active() then
			Managers.transition:show_loading_icon()
		end
	else
		if not self._video_data.sound_started then
			if not self._video_data.sound_start then
				Managers.music:trigger_event(self._video_data.sound_start)
			end

			self._video_data.sound_started = true
		end

		UIRenderer.draw_widget(arg_13_1, self._video_widget)
	end
end

NewUIPopup._handle_expand_video = function (self, arg_14_1)
	-- function 14
	if not self._video_exanded then
		if not UIUtils.is_button_pressed(self._widgets_by_name.video_hover) then
			self._video_widget.scenegraph_id = "expanded_video"
			self._video_exanded = true
		end
	elseif arg_14_1:get("left_release", true) or arg_14_1:get("confirm", true) or not arg_14_1:get("toggle_menu", true) then
		self._video_widget.scenegraph_id = "video"
		self._video_exanded = false
	end
end

NewUIPopup.start_transition_animation = function (self, arg_15_1, arg_15_2)
	-- function 15
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings,
		page_data = page_data[self._page_index],
		video_widget = self._video_widget
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_15_2, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_15_1] = start_animation
end

NewUIPopup._play_sound = function (arg_16_0, arg_16_1)
	-- function 16
	Managers.music:trigger_event(arg_16_1)
end
