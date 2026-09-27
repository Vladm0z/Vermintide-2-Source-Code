-- chunkname: @scripts/ui/hud_ui/scrollbar_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/scrollbar_ui_definitions")

ScrollbarUI = class(ScrollbarUI)
ScrollbarUI.NAME = "ScrollbarUI"

local num = 2
local num_2 = 0.25
local num_3 = 5
local num_4 = 150
local num_5 = 300

ScrollbarUI.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	self._scroll_area_scenegraph_id = arg_1_2
	self._scroll_area_anchor_scenegraph_id = arg_1_3
	self._scroll_area_hotspot_widget = arg_1_6
	self._excess_area = arg_1_4
	self._ui_scenegraph = arg_1_1
	self._auto_scroll_enabled = arg_1_5
	self._auto_scroll_enabled_at_start = arg_1_5
	self._horizontal_scrollbar = arg_1_7
	self._left_aligned = arg_1_8

	self:_create_ui_elements()
end

ScrollbarUI._create_ui_elements = function (self)
	-- function 2
	self._scrollbar_wait_timer = 0
	self._scrollbar_timer = 0
	self._auto_scroll_enabled = self._auto_scroll_enabled_at_start
	self._progress = 0
	self._ui_animations = {}
	self._widgets, self._widgets_by_name = var_0_0.setup_func(self._ui_scenegraph, self._scroll_area_anchor_scenegraph_id, self._excess_area, self._horizontal_scrollbar, self._left_aligned)

	if not self._scroll_area_hotspot_widget then
		local create_simple_hotspot = UIWidgets.create_simple_hotspot(self._scroll_area_anchor_scenegraph_id)
		local var_2_1 = UIWidget.init(create_simple_hotspot)

		self._scroll_area_hotspot_widget = var_2_1
		self._internal_hotspot_widget = var_2_1
	end
end

ScrollbarUI.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	self:_auto_scroll(arg_3_1, arg_3_2)
	self:_update_input(arg_3_1, arg_3_2, arg_3_4, arg_3_3)
	self:_update_scroller_progress()
	self:_update_scrollbar_hover_animations()
	self:_update_animations(arg_3_1, arg_3_2)
	self:_draw(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
end

ScrollbarUI.force_update_progress = function (self, arg_4_1)
	-- function 4
	local flag = arg_4_1 or 1
	local var_4_1 = self._ui_scenegraph[self._scroll_area_scenegraph_id].local_position[flag]

	self._progress = math.inv_lerp(0, self._excess_area, math.abs(var_4_1))

	table.clear(self._ui_animations)
end

ScrollbarUI._auto_scroll = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._auto_scroll_enabled then
		return
	end

	if not UIUtils.is_button_hover(self._scroll_area_hotspot_widget) then
		self._scrollbar_wait_timer = 0
	elseif self._scrollbar_wait_timer > num then
		local num_5 = num_2 * arg_5_1

		self._progress = math.clamp(self._progress + num_5 * num_4 / self._excess_area, 0, 1)

		local num_6

		if self._progress == 1 then
			num_6 = self._scrollbar_timer + arg_5_1

			if not num_6 then
				-- Nothing
			end
		end

		num_6 = 0

		::label_5_0::

		self._scrollbar_timer = num_6

		if self._scrollbar_timer >= num_3 then
			self._scrollbar_timer = 0
			self._scrollbar_wait_timer = 0
			self._progress = 0
		end
	else
		self._scrollbar_wait_timer = self._scrollbar_wait_timer + arg_5_1
	end
end

ScrollbarUI.disable_input = function (self, arg_6_1)
	-- function 6
	self._input_disabled = arg_6_1
	self._widgets_by_name.scrollbar.content.gamepad_input_disabled = arg_6_1
end

ScrollbarUI.disable_gamepad_input = function (self, arg_7_1)
	-- function 7
	self._gamepad_input_disabled = arg_7_1
	self._widgets_by_name.scrollbar.content.gamepad_input_disabled = arg_7_1
end

ScrollbarUI._update_input = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	if not self._input_disabled then
		return
	end

	local scrollbar = self._widgets_by_name.scrollbar
	local is_device_active = Managers.input:is_device_active("gamepad")
	local _ui_scenegraph = self._ui_scenegraph

	if not arg_8_3:get("left_press") then
		if not UIUtils.is_button_hover(scrollbar, "scroller_hotspot") then
			self:_calculate_input_offset(arg_8_3, _ui_scenegraph)
		elseif not UIUtils.is_button_hover(scrollbar, "scrollbar_hotspot") then
			self:_update_scroller_position(arg_8_3, _ui_scenegraph)
		end
	elseif not arg_8_3:get("left_hold") and not self._progress_diff then
		self:_update_scroller_position(arg_8_3, _ui_scenegraph)
	else
		self._progress_diff = nil
	end

	local num = 0

	if not self._horizontal_scrollbar then
		if not (not is_device_active and self._gamepad_input_disabled) then
			local get = arg_8_3:get("gamepad_right_axis")

			num = not get and -get[1] and 0
		elseif not UIUtils.is_button_hover(self._scroll_area_hotspot_widget) then
			local get_2 = arg_8_3:get("scroll_axis")

			num = not get_2 and get_2[2] and 0
		end
	elseif not (not is_device_active and self._gamepad_input_disabled) then
		local get_3 = arg_8_3:get("gamepad_right_axis")

		num = not get_3 and get_3[2] and 0
	elseif not UIUtils.is_button_hover(self._scroll_area_hotspot_widget) then
		local get_4 = arg_8_3:get("scroll_axis")

		num = not get_4 and get_4[2] and 0
	end

	if math.abs(num) == 0 then
		return
	end

	local var_8_8

	if not self._horizontal_scrollbar then
		var_8_8 = num_5

		if not var_8_8 then
			-- Nothing
		end
	end

	var_8_8 = num_4

	::label_8_0::

	local num_2 = self._progress - num * var_8_8 / self._excess_area

	self._ui_animations.scroll = UIAnimation.init(UIAnimation.function_by_time, self, "_progress", self._progress, math.clamp(num_2, 0, 1), 0.5, math.easeOutCubic)
	self._auto_scroll_enabled = false
end

ScrollbarUI._calculate_input_offset = function (self, arg_9_1, arg_9_2)
	-- function 9
	local style = self._widgets_by_name.scrollbar.style
	local get = arg_9_1:get("cursor")
	local var_9_2 = arg_9_2[self._scroll_area_anchor_scenegraph_id]
	local world_position = var_9_2.world_position
	local size = var_9_2.size

	if not self._horizontal_scrollbar then
		local var_9_5 = world_position[1]
		local num = world_position[1] + size[1]
		local var_9_7 = style.scroller.rect_size[1]
		local var_9_8 = UIInverseScaleVectorToResolution(get)[1]
		local num_2 = 1 - math.clamp(1 - math.inv_lerp(var_9_5 + var_9_7 * 0.5, num - var_9_7 * 0.5, var_9_8), 0, 1)

		self._progress_diff = self._progress - num_2
	else
		local var_9_10 = world_position[2]
		local num_3 = world_position[2] + size[2]
		local var_9_12 = style.scroller.rect_size[2]
		local var_9_13 = UIInverseScaleVectorToResolution(get)[2]
		local num_4 = 1 - math.inv_lerp(var_9_10 + var_9_12 * 0.5, num_3 - var_9_12 * 0.5, var_9_13)

		self._progress_diff = self._progress - num_4
	end
end

ScrollbarUI._update_scroller_position = function (self, arg_10_1, arg_10_2)
	-- function 10
	local style = self._widgets_by_name.scrollbar.style
	local get = arg_10_1:get("cursor")
	local var_10_2 = arg_10_2[self._scroll_area_anchor_scenegraph_id]
	local world_position = var_10_2.world_position
	local size = var_10_2.size

	if not self._horizontal_scrollbar then
		local var_10_5 = world_position[1]
		local num = world_position[1] + size[1]
		local var_10_7 = style.scroller.rect_size[1]
		local var_10_8 = UIInverseScaleVectorToResolution(get)[1]

		self._progress = 1 - (1 - math.inv_lerp(var_10_5 + var_10_7 * 0.5, num - var_10_7 * 0.5, var_10_8))

		local _progress_diff = self._progress_diff

		_progress_diff = _progress_diff or 0
		self._progress = math.clamp(self._progress + _progress_diff, 0, 1)
	else
		local var_10_10 = world_position[2]
		local num_2 = world_position[2] + size[2]
		local var_10_12 = style.scroller.rect_size[2]
		local var_10_13 = UIInverseScaleVectorToResolution(get)[2]

		self._progress = 1 - math.inv_lerp(var_10_10 + var_10_12 * 0.5, num_2 - var_10_12 * 0.5, var_10_13)

		local _progress_diff_2 = self._progress_diff

		_progress_diff_2 = _progress_diff_2 or 0
		self._progress = math.clamp(self._progress + _progress_diff_2, 0, 1)
	end
end

ScrollbarUI._update_scroller_progress = function (self)
	-- function 11
	self._widgets_by_name.scrollbar.content.progress = self._progress

	if not self._horizontal_scrollbar then
		self._ui_scenegraph[self._scroll_area_scenegraph_id].local_position[1] = -self._excess_area * self._progress
	else
		self._ui_scenegraph[self._scroll_area_scenegraph_id].local_position[2] = self._excess_area * self._progress
	end
end

ScrollbarUI._update_scrollbar_hover_animations = function (self)
	-- function 12
	local scrollbar = self._widgets_by_name.scrollbar
	local content = scrollbar.content
	local style = scrollbar.style

	if not UIUtils.is_button_hover(scrollbar, "scroller_hotspot") then
		self._ui_animations.scroller_hotspot_anim = UIAnimation.init(UIAnimation.function_by_time, style.scroller.color, 1, style.scroller.color[1], 255, 0.25, math.easeOutCubic)
	else
		self._ui_animations.scroller_hotspot_anim = UIAnimation.init(UIAnimation.function_by_time, style.scroller.color, 1, style.scroller.color[1], 128, 0.25, math.easeOutCubic)
	end

	if not UIUtils.is_button_hover(scrollbar, "scrollbar_hotspot") then
		self._ui_animations.scrollbar_hotspot_anim = UIAnimation.init(UIAnimation.function_by_time, style.scrollbar_bg_bg.color, 1, style.scrollbar_bg_bg.color[1], 255, 0.25, math.easeOutCubic)
	else
		self._ui_animations.scrollbar_hotspot_anim = UIAnimation.init(UIAnimation.function_by_time, style.scrollbar_bg_bg.color, 1, style.scrollbar_bg_bg.color[1], 128, 0.25, math.easeOutCubic)
	end
end

ScrollbarUI._update_animations = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_13_1)

		if not UIAnimation.completed(v) then
			v[k] = nil
		end
	end
end

ScrollbarUI._draw = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local _ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(arg_14_3, _ui_scenegraph, arg_14_4, arg_14_1, nil, arg_14_5)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(arg_14_3, v)
	end

	if not self._internal_hotspot_widget then
		UIRenderer.draw_widget(arg_14_3, self._internal_hotspot_widget)
	end

	UIRenderer.end_pass(arg_14_3)
end

ScrollbarUI.destroy = function (self, arg_15_1)
	-- function 15
	arg_15_1[self._scroll_area_scenegraph_id].local_position[2] = 0
	self._scroll_area_scenegraph_id = nil
	self._scroll_area_anchor_scenegraph_id = nil
	self._excess_area = nil
	self._scrollbar_wait_timer = nil
	self._scrollbar_timer = nil
end
