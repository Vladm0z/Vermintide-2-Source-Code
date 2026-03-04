-- chunkname: @scripts/ui/helpers/scrollbar_logic.lua

ScrollBarLogic = class(ScrollBarLogic)

ScrollBarLogic.init = function (arg_1_0, arg_1_1)
	arg_1_0._scrollbar_widget = arg_1_1
	arg_1_0._scroll_value = 0
	arg_1_0._draw_length = 0
end

ScrollBarLogic.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if not arg_2_0._scrollbar_enabled then
		return
	end

	local var_2_0 = arg_2_0:_get_scrollbar_info()

	if var_2_0.on_pressed then
		var_2_0.scroll_add = nil
	end

	local var_2_1 = var_2_0.scroll_value

	if not var_2_1 or arg_2_3 then
		return
	end

	local var_2_2 = var_2_0.value
	local var_2_3 = arg_2_0._scroll_value

	if var_2_3 ~= var_2_1 then
		arg_2_0:_set_scrollbar_value(var_2_1)
	elseif var_2_3 ~= var_2_2 then
		arg_2_0:_set_scrollbar_value(var_2_2)
	end
end

ScrollBarLogic.set_scrollbar_values = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = math.min(arg_3_3 / arg_3_2, 1)

	arg_3_0:_set_thumb_scale(var_3_0)

	local var_3_1 = math.max(arg_3_2 - arg_3_1, 0)

	arg_3_0:_set_scroll_length(var_3_1)

	arg_3_5 = arg_3_5 or 2

	local var_3_2 = math.max(arg_3_4 / var_3_1, 0) * arg_3_5

	arg_3_0:_set_scroll_amount(var_3_2)

	arg_3_0._scrollbar_enabled = var_3_1 > 0
	arg_3_0._draw_length = arg_3_1
	arg_3_0._initialized = true
end

ScrollBarLogic.set_scroll_percentage = function (arg_4_0, arg_4_1)
	arg_4_0:_set_scrollbar_value(arg_4_1 or 0)
end

ScrollBarLogic.set_scroll_distance = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1 / arg_5_0:get_scroll_length()

	arg_5_0:set_scroll_percentage(var_5_0)
end

ScrollBarLogic.scroll_to_fit = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0:get_scrolled_length()
	local var_6_1 = arg_6_0._draw_length

	if arg_6_1 < var_6_0 then
		arg_6_0:set_scroll_distance(arg_6_1)
	elseif arg_6_1 + arg_6_2 > var_6_0 + var_6_1 then
		arg_6_0:set_scroll_distance(arg_6_1 + var_6_1 - arg_6_2)
	end
end

ScrollBarLogic.get_scroll_percentage = function (arg_7_0)
	return arg_7_0._scroll_value
end

ScrollBarLogic.get_scrolled_length = function (arg_8_0)
	local var_8_0 = arg_8_0._scroll_value

	return arg_8_0:get_scroll_length() * var_8_0
end

ScrollBarLogic.get_scroll_length = function (arg_9_0)
	return arg_9_0:_get_scrollbar_info().total_scroll_length or 0
end

ScrollBarLogic.enabled = function (arg_10_0)
	return arg_10_0._scrollbar_enabled
end

ScrollBarLogic.is_scrolling = function (arg_11_0)
	return arg_11_0:_get_scrollbar_info().scroll_add ~= nil
end

ScrollBarLogic._get_scrollbar_info = function (arg_12_0)
	return arg_12_0._scrollbar_widget.content.scroll_bar_info
end

ScrollBarLogic._set_thumb_scale = function (arg_13_0, arg_13_1)
	arg_13_0:_get_scrollbar_info().bar_height_percentage = arg_13_1
end

ScrollBarLogic._set_scroll_amount = function (arg_14_0, arg_14_1)
	arg_14_0:_get_scrollbar_info().scroll_amount = arg_14_1
end

ScrollBarLogic._set_scroll_length = function (arg_15_0, arg_15_1)
	arg_15_0:_get_scrollbar_info().total_scroll_length = arg_15_1
end

ScrollBarLogic._set_scrollbar_value = function (arg_16_0, arg_16_1)
	if arg_16_1 then
		local var_16_0 = arg_16_0:_get_scrollbar_info()

		var_16_0.value = arg_16_1
		var_16_0.scroll_value = arg_16_1
		arg_16_0._scroll_value = arg_16_1
	end
end
