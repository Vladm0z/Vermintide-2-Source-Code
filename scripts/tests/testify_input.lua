-- chunkname: @scripts/tests/testify_input.lua

local tbl = {
	send = function (arg_1_0)
		-- function 1
		Testify:make_request_to_runner("inputs", arg_1_0)
	end
}

tbl.send_mouse_click = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	tbl.send({
		tbl.mouse_click(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	})
end

tbl.send_mouse_move = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	tbl.send({
		tbl.mouse_move(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	})
end

tbl.send_keyboard_press_key = function (arg_4_0, arg_4_1)
	-- function 4
	tbl.send({
		tbl.keyboard_press_key(arg_4_0, arg_4_1)
	})
end

tbl.send_keyboard_hold_key = function (arg_5_0)
	-- function 5
	tbl.send({
		tbl.keyboard_hold_key(arg_5_0)
	})
end

tbl.send_keyboard_release_key = function (arg_6_0)
	-- function 6
	tbl.send({
		tbl.keyboard_release_key(arg_6_0)
	})
end

tbl.send_keyboard_write_text = function (arg_7_0)
	-- function 7
	tbl.send({
		tbl.keyboard_write_text(arg_7_0)
	})
end

tbl.mouse_click = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	return {
		action = "click",
		type = "mouse",
		button = arg_8_0,
		position = arg_8_1,
		position_unit = arg_8_2,
		speed = arg_8_3,
		context = arg_8_4,
		num_clicks = arg_8_5,
		duration = arg_8_6
	}
end

tbl.mouse_move = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	return {
		action = "move",
		type = "mouse",
		position = arg_9_0,
		position_unit = arg_9_1,
		speed = arg_9_2,
		context = arg_9_3
	}
end

tbl.keyboard_press_key = function (arg_10_0, arg_10_1)
	-- function 10
	return {
		action = "press",
		type = "keyboard",
		key = arg_10_0,
		duration = arg_10_1
	}
end

tbl.keyboard_hold_key = function (arg_11_0)
	-- function 11
	return {
		action = "hold",
		type = "keyboard",
		key = arg_11_0
	}
end

tbl.keyboard_release_key = function (arg_12_0)
	-- function 12
	return {
		action = "release",
		type = "keyboard",
		key = arg_12_0
	}
end

tbl.keyboard_write_text = function (arg_13_0)
	-- function 13
	return {
		action = "write_text",
		type = "keyboard",
		text = arg_13_0
	}
end

return tbl
