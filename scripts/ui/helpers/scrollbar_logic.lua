-- chunkname: @scripts/ui/helpers/scrollbar_logic.lua

ScrollBarLogic = class(ScrollBarLogic)

ScrollBarLogic.init = function (self, arg_1_1)
	-- function 1
	self._scrollbar_widget = arg_1_1
	self._scroll_value = 0
	self._draw_length = 0
end

ScrollBarLogic.update = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	if not self._scrollbar_enabled then
		return
	end

	local _get_scrollbar_info = self:_get_scrollbar_info()

	if not _get_scrollbar_info.on_pressed then
		_get_scrollbar_info.scroll_add = nil
	end

	local scroll_value = _get_scrollbar_info.scroll_value

	if not scroll_value and not arg_2_3 then
		return
	end

	local value = _get_scrollbar_info.value
	local _scroll_value = self._scroll_value

	if _scroll_value ~= scroll_value then
		self:_set_scrollbar_value(scroll_value)
	elseif _scroll_value ~= value then
		self:_set_scrollbar_value(value)
	end
end

ScrollBarLogic.set_scrollbar_values = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local min = math.min(arg_3_3 / arg_3_2, 1)

	self:_set_thumb_scale(min)

	local max = math.max(arg_3_2 - arg_3_1, 0)

	self:_set_scroll_length(max)

	arg_3_5 = arg_3_5 or 2

	local num = math.max(arg_3_4 / max, 0) * arg_3_5

	self:_set_scroll_amount(num)

	self._scrollbar_enabled = max > 0
	self._draw_length = arg_3_1
	self._initialized = true
end

ScrollBarLogic.set_scroll_percentage = function (self, arg_4_1)
	-- function 4
	self:_set_scrollbar_value(arg_4_1 or 0)
end

ScrollBarLogic.set_scroll_distance = function (self, arg_5_1)
	-- function 5
	local num = arg_5_1 / self:get_scroll_length()

	self:set_scroll_percentage(num)
end

ScrollBarLogic.scroll_to_fit = function (self, arg_6_1, arg_6_2)
	-- function 6
	local get_scrolled_length = self:get_scrolled_length()
	local _draw_length = self._draw_length

	if arg_6_1 < get_scrolled_length then
		self:set_scroll_distance(arg_6_1)
	elseif arg_6_1 + arg_6_2 > get_scrolled_length + _draw_length then
		self:set_scroll_distance(arg_6_1 + _draw_length - arg_6_2)
	end
end

ScrollBarLogic.get_scroll_percentage = function (self)
	-- function 7
	return self._scroll_value
end

ScrollBarLogic.get_scrolled_length = function (self)
	-- function 8
	local _scroll_value = self._scroll_value

	return self:get_scroll_length() * _scroll_value
end

ScrollBarLogic.get_scroll_length = function (self)
	-- function 9
	return self:_get_scrollbar_info().total_scroll_length or 0
end

ScrollBarLogic.enabled = function (self)
	-- function 10
	return self._scrollbar_enabled
end

ScrollBarLogic.is_scrolling = function (self)
	-- function 11
	return self:_get_scrollbar_info().scroll_add ~= nil
end

ScrollBarLogic._get_scrollbar_info = function (self)
	-- function 12
	return self._scrollbar_widget.content.scroll_bar_info
end

ScrollBarLogic._set_thumb_scale = function (arg_13_0, arg_13_1)
	-- function 13
	arg_13_0:_get_scrollbar_info().bar_height_percentage = arg_13_1
end

ScrollBarLogic._set_scroll_amount = function (arg_14_0, arg_14_1)
	-- function 14
	arg_14_0:_get_scrollbar_info().scroll_amount = arg_14_1
end

ScrollBarLogic._set_scroll_length = function (arg_15_0, arg_15_1)
	-- function 15
	arg_15_0:_get_scrollbar_info().total_scroll_length = arg_15_1
end

ScrollBarLogic._set_scrollbar_value = function (self, arg_16_1)
	-- function 16
	if not arg_16_1 then
		local _get_scrollbar_info = self:_get_scrollbar_info()

		_get_scrollbar_info.value = arg_16_1
		_get_scrollbar_info.scroll_value = arg_16_1
		self._scroll_value = arg_16_1
	end
end
