-- chunkname: @scripts/tests/testify_input.lua

local var_0_0 = {
	send = function(arg_1_0)
		Testify:make_request_to_runner("inputs", arg_1_0)
	end
}

function var_0_0.send_mouse_click(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	var_0_0.send({
		var_0_0.mouse_click(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	})
end

function var_0_0.send_mouse_move(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	var_0_0.send({
		var_0_0.mouse_move(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	})
end

function var_0_0.send_keyboard_press_key(arg_4_0, arg_4_1)
	var_0_0.send({
		var_0_0.keyboard_press_key(arg_4_0, arg_4_1)
	})
end

function var_0_0.send_keyboard_hold_key(arg_5_0)
	var_0_0.send({
		var_0_0.keyboard_hold_key(arg_5_0)
	})
end

function var_0_0.send_keyboard_release_key(arg_6_0)
	var_0_0.send({
		var_0_0.keyboard_release_key(arg_6_0)
	})
end

function var_0_0.send_keyboard_write_text(arg_7_0)
	var_0_0.send({
		var_0_0.keyboard_write_text(arg_7_0)
	})
end

function var_0_0.mouse_click(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
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

function var_0_0.mouse_move(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	return {
		action = "move",
		type = "mouse",
		position = arg_9_0,
		position_unit = arg_9_1,
		speed = arg_9_2,
		context = arg_9_3
	}
end

function var_0_0.keyboard_press_key(arg_10_0, arg_10_1)
	return {
		action = "press",
		type = "keyboard",
		key = arg_10_0,
		duration = arg_10_1
	}
end

function var_0_0.keyboard_hold_key(arg_11_0)
	return {
		action = "hold",
		type = "keyboard",
		key = arg_11_0
	}
end

function var_0_0.keyboard_release_key(arg_12_0)
	return {
		action = "release",
		type = "keyboard",
		key = arg_12_0
	}
end

function var_0_0.keyboard_write_text(arg_13_0)
	return {
		action = "write_text",
		type = "keyboard",
		text = arg_13_0
	}
end

return var_0_0
