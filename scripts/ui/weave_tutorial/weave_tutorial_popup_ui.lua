-- chunkname: @scripts/ui/weave_tutorial/weave_tutorial_popup_ui.lua

local var_0_0 = local_require("scripts/ui/weave_tutorial/weave_tutorial_popup_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local body_definitions = var_0_0.body_definitions
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions

WeaveTutorialPopupUI = class(WeaveTutorialPopupUI)

local num = 40

WeaveTutorialPopupUI.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_renderer
	self.ui_top_renderer = arg_1_1.ui_top_renderer
	self.input_manager = arg_1_1.input_manager
	self.world = arg_1_1.world
	self.wwise_world = Managers.world:wwise_world(self.world)
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.ui_context = arg_1_1
	self.body_paragraphs = {}
	self.body_paragraph_heights = {}
	self._animations = {}

	self:_create_ui_elements()
	self:_setup_input()

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, Managers.input:get_service("weave_tutorial"), 3, 900, generic_input_actions.default)

	self._menu_input_description:set_input_description(nil)
end

WeaveTutorialPopupUI._setup_input = function (self)
	-- function 2
	self.input_manager:create_input_service("weave_tutorial", "IngameMenuKeymaps", "IngameMenuFilters")
	self.input_manager:map_device_to_service("weave_tutorial", "keyboard")
	self.input_manager:map_device_to_service("weave_tutorial", "mouse")
	self.input_manager:map_device_to_service("weave_tutorial", "gamepad")
end

WeaveTutorialPopupUI._create_ui_elements = function (self)
	-- function 3
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local widget_definitions = var_0_0.widget_definitions

	self.widgets = {}

	local tbl = {}

	for k, v in pairs(widget_definitions) do
		local var_3_2 = UIWidget.init(v)

		self.widgets[#self.widgets + 1] = var_3_2
		tbl[k] = var_3_2
	end

	self.widgets_by_name = tbl
	self.button_1 = tbl.button_1
	self.button_2 = tbl.button_2
	self.title_text = tbl.title_text
	self.sub_title_text = tbl.sub_title_text
	self.body_text = UIWidget.init(body_definitions.body_text)
	self.body_text_divider = UIWidget.init(body_definitions.paragraph_divider)

	local ui_scenegraph = self.ui_scenegraph

	self.title_start_y = UISceneGraph.get_world_position(ui_scenegraph, "title")[2]
	self.sub_title_start_y = UISceneGraph.get_world_position(ui_scenegraph, "sub_title")[2]
	self.body_start_y = UISceneGraph.get_world_position(ui_scenegraph, "body")[2]
	self.button_height = scenegraph_definition.button_1.position[2] + scenegraph_definition.button_1.size[2]

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
end

WeaveTutorialPopupUI.show = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8)
	-- function 4
	if not self.is_visible then
		print("WeaveTutorialPopupUI is already visible")

		return
	end

	self._optional_button_2_func = arg_4_5

	self._menu_input_description:set_input_description(arg_4_6)
	self:start_transition_animation("on_show", "transition_enter")
	self:populate_message(arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_7, arg_4_8)

	self.is_visible = true

	self:_acquire_input()
end

WeaveTutorialPopupUI.show_custom_popup = function (self, arg_5_1)
	-- function 5
	local custom_popup = arg_5_1.custom_popup

	self._custom_popup = rawget(_G, custom_popup):new(self.ui_context, self)
	self.is_visible = true

	self:_acquire_input()
end

WeaveTutorialPopupUI.hide = function (self)
	-- function 6
	if not self.is_visible then
		return
	end

	self.is_visible = false

	self:_release_input()
	self:_destroy_custom_popup()
end

WeaveTutorialPopupUI._destroy_custom_popup = function (self)
	-- function 7
	if not self._custom_popup then
		self._custom_popup:destroy()

		self._custom_popup = nil
	end
end

WeaveTutorialPopupUI.destroy = function (self)
	-- function 8
	self:hide()

	self.widgets = nil
	self.widgets_by_name = nil
	self.button_1 = nil
	self.button_2 = nil
	self.title_text = nil
	self.sub_title_text = nil
	self.body_text = nil
	self.ui_animator = nil
end

WeaveTutorialPopupUI.update = function (self, arg_9_1)
	-- function 9
	if not self.is_visible then
		return
	end

	local get_service = self.input_manager:get_service("weave_tutorial")

	if not self._custom_popup then
		self._custom_popup:update(arg_9_1, get_service)
	else
		if UIUtils.is_button_pressed(self.button_1) or get_service:get("toggle_menu", true) or not get_service:get("confirm_press", true) then
			self:hide()

			return
		end

		if not self._optional_button_2_func and UIUtils.is_button_pressed(self.button_2) and not get_service:get("special_1_press", true) then
			self._optional_button_2_func(self)
			self:hide()

			return
		end

		self:_update_animations(arg_9_1)
		self:_draw(arg_9_1, get_service)
	end
end

WeaveTutorialPopupUI._update_animations = function (self, arg_10_1)
	-- function 10
	self.ui_animator:update(arg_10_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	UIWidgetUtils.animate_default_button(self.button_1, arg_10_1)
	UIWidgetUtils.animate_default_button(self.button_2, arg_10_1)
end

WeaveTutorialPopupUI._draw = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self._custom_popup then
		return
	end

	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local render_settings = self.render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, arg_11_2, arg_11_1, nil, render_settings)

	for i, v in ipairs(self.widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	self:draw_body(ui_top_renderer)
	UIRenderer.end_pass(ui_top_renderer)

	if not is_device_active then
		self._menu_input_description:draw(ui_top_renderer, arg_11_1)
	end
end

WeaveTutorialPopupUI.populate_message = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local content = self.title_text.content

	content.text = arg_12_1 or ""
	content.visible = arg_12_1 ~= nil

	local content_2 = self.sub_title_text.content

	content_2.text = arg_12_2 or ""
	content_2.visible = arg_12_2 ~= nil

	local button_2 = self.button_2

	if not arg_12_4 then
		button_2.content.visible = true
		button_2.content.title_text = Localize(arg_12_4)
	else
		button_2.content.visible = false
	end

	local flag = not arg_12_5 and arg_12_3 and Localize(arg_12_3)

	self.body_paragraphs = UIRenderer.break_paragraphs(flag, {})

	self:resize_to_fit()

	local widgets = self.widgets

	for i = 1, #widgets do
		widgets[i].element.dirty = true
	end
end

WeaveTutorialPopupUI.resize_to_fit = function (self)
	-- function 13
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local sub_title = ui_scenegraph.sub_title
	local body = ui_scenegraph.body
	local window = ui_scenegraph.window
	local size = body.size
	local text = self.body_text.style.text
	local num_2 = 0

	self.body_paragraph_heights = {}

	local body_paragraphs = self.body_paragraphs
	local count = #body_paragraphs

	for i = 1, count do
		local get_text_height = UIUtils.get_text_height(ui_top_renderer, size, text, body_paragraphs[i])

		self.body_paragraph_heights[i] = get_text_height
		num_2 = num_2 + get_text_height

		if i < count then
			num_2 = num_2 + num
		end
	end

	body.size[2] = num_2

	local visible = self.title_text.content.visible
	local position = scenegraph_definition.sub_title.position
	local position_2 = sub_title.position
	local var_13_14

	if not visible then
		var_13_14 = position[2]

		if not var_13_14 then
			-- Nothing
		end
	end

	var_13_14 = 0

	::label_13_0::

	position_2[2] = var_13_14

	local visible_2 = self.sub_title_text.content.visible
	local position_3 = scenegraph_definition.body.position
	local position_4 = body.position
	local var_13_18

	if not visible_2 then
		var_13_18 = position_3[2]

		if not var_13_18 then
			-- Nothing
		end
	end

	var_13_18 = position[2]

	::label_13_1::

	position_4[2] = var_13_18

	local calculate_base_window_height = self:calculate_base_window_height()

	window.size[2] = num_2 + calculate_base_window_height

	local button_1 = self.button_1
	local button_2 = self.button_2

	if not button_2.content.visible then
		local num_3 = 20
		local size_2 = scenegraph_definition.button_1.size

		button_1.offset[1] = size_2[1] * 0.5 + num_3
		button_2.offset[1] = -size_2[1] * 0.5 - num_3
	else
		button_1.offset[1] = 0
	end
end

WeaveTutorialPopupUI.calculate_base_window_height = function (self)
	-- function 14
	local num = self.title_start_y - self.sub_title_start_y
	local flag

	flag = not self.title_text.content.visible and 0 and num

	local num_2 = self.sub_title_start_y - self.body_start_y
	local flag_2

	flag_2 = not self.sub_title_text.content.visible and 0 and num_2

	return self.button_height - self.body_start_y - flag + 50
end

WeaveTutorialPopupUI.draw_body = function (self, arg_15_1)
	-- function 15
	local body_text = self.body_text
	local body_text_divider = self.body_text_divider
	local offset = body_text.offset
	local offset_2 = body_text_divider.offset
	local num_2 = 0
	local body_paragraphs = self.body_paragraphs
	local body_paragraph_heights = self.body_paragraph_heights
	local count = #body_paragraphs

	for i = 1, count do
		offset[2] = -num_2
		body_text.content.text = body_paragraphs[i]

		UIRenderer.draw_widget(arg_15_1, body_text)

		num_2 = num_2 + body_paragraph_heights[i]

		if i < count then
			offset_2[2] = -(num_2 + num / 2)

			UIRenderer.draw_widget(arg_15_1, body_text_divider)

			num_2 = num_2 + num
		end
	end
end

WeaveTutorialPopupUI.start_transition_animation = function (self, arg_16_1, arg_16_2)
	-- function 16
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings,
		text_highlight_widget = self.widgets_by_name.result_text_bg
	}
	local tbl_2 = {
		self.widgets_by_name.screen_background
	}
	local start_animation = self.ui_animator:start_animation(arg_16_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_16_1] = start_animation
end

WeaveTutorialPopupUI._acquire_input = function (self)
	-- function 17
	self.input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "weave_tutorial", "WeaveTutorialPopupUI")
	ShowCursorStack.show("WeaveTutorialPopupUI")
end

WeaveTutorialPopupUI._release_input = function (self)
	-- function 18
	self.input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "weave_tutorial", "WeaveTutorialPopupUI")
	ShowCursorStack.hide("WeaveTutorialPopupUI")
end
