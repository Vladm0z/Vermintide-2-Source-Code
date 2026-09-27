-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_gotwf_panel.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_panel_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

HeroWindowGotwfPanel = class(HeroWindowGotwfPanel)
HeroWindowGotwfPanel.NAME = "HeroWindowGotwfPanel"

HeroWindowGotwfPanel.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowGotwfPanel")

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._parent = arg_1_1.parent
	self._ui_renderer = ingame_ui_context.ui_top_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
end

HeroWindowGotwfPanel._create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_2
		tbl_2[k] = var_2_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

HeroWindowGotwfPanel.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroViewWindow] Exit Substate HeroWindowGotwfPanel")

	self._ui_animator = nil
end

HeroWindowGotwfPanel.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_handle_gamepad_activity()
	self:_update_animations(arg_4_1)
	self:_draw(arg_4_1)
end

HeroWindowGotwfPanel.post_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_handle_input(arg_5_1, arg_5_2)
end

HeroWindowGotwfPanel._update_animations = function (self, arg_6_1)
	-- function 6
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_6_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_6_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	self:_animate_button(self._widgets_by_name.close_button, arg_6_1)
end

HeroWindowGotwfPanel._handle_input = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local window_input_service = self._parent:window_input_service()
	local close_button = _widgets_by_name.close_button

	if not UIUtils.is_button_pressed(close_button) then
		_parent:set_layout_by_name("featured")
	end
end

HeroWindowGotwfPanel._draw = function (self, arg_8_1)
	-- function 8
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, window_input_service, arg_8_1, nil, self._render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	UIRenderer.end_pass(_ui_renderer)
end

HeroWindowGotwfPanel._handle_gamepad_activity = function (self)
	-- function 9
	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag = self._gamepad_active_last_frame == nil

	if not is_device_active then
		if not self._gamepad_active_last_frame and not flag then
			self._gamepad_active_last_frame = true
			self._widgets_by_name.close_button.content.visible = false
		end
	elseif self._gamepad_active_last_frame or not flag then
		self._gamepad_active_last_frame = false
		self._widgets_by_name.close_button.content.visible = true
	end
end

HeroWindowGotwfPanel._animate_button = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local content = arg_10_1.content
	local style = arg_10_1.style
	local button_hotspot = content.button_hotspot
	local is_hover = button_hotspot.is_hover
	local is_selected = button_hotspot.is_selected
	local is_clicked

	if not is_selected then
		is_clicked = button_hotspot.is_clicked

		if not is_clicked then
			-- Nothing
		end

		if button_hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_10_1

	::label_10_0::

	is_clicked = true

	::label_10_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_10_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_10_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_10_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_10_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_10_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_10_2 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
	local num_3 = 255 * max

	style.texture_id.color[1] = 255 - num_3
	style.texture_hover_id.color[1] = num_3
	style.selected_texture.color[1] = num_3
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end
