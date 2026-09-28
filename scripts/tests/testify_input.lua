-- chunkname: @scripts/tests/testify_input.lua

local TestifyInput = {}

TestifyInput.send = function (inputs)
	-- function 1
	Testify:make_request_to_runner("inputs", inputs)
end

TestifyInput.send_mouse_click = function (button, position, position_unit, speed, context, num_clicks, duration)
	-- function 2
	TestifyInput.send({
		TestifyInput.mouse_click(button, position, position_unit, speed, context, num_clicks, duration)
	})
end

TestifyInput.send_mouse_move = function (position, position_unit, speed, context)
	-- function 3
	TestifyInput.send({
		TestifyInput.mouse_move(position, position_unit, speed, context)
	})
end

TestifyInput.send_keyboard_press_key = function (key, duration)
	-- function 4
	TestifyInput.send({
		TestifyInput.keyboard_press_key(key, duration)
	})
end

TestifyInput.send_keyboard_hold_key = function (key)
	-- function 5
	TestifyInput.send({
		TestifyInput.keyboard_hold_key(key)
	})
end

TestifyInput.send_keyboard_release_key = function (key)
	-- function 6
	TestifyInput.send({
		TestifyInput.keyboard_release_key(key)
	})
end

TestifyInput.send_keyboard_write_text = function (text)
	-- function 7
	TestifyInput.send({
		TestifyInput.keyboard_write_text(text)
	})
end

TestifyInput.mouse_click = function (button, position, position_unit, speed, context, num_clicks, duration)
	-- function 8
	return {
		action = "click",
		type = "mouse",
		button = button,
		position = position,
		position_unit = position_unit,
		speed = speed,
		context = context,
		num_clicks = num_clicks,
		duration = duration
	}
end

TestifyInput.mouse_move = function (position, position_unit, speed, context)
	-- function 9
	return {
		action = "move",
		type = "mouse",
		position = position,
		position_unit = position_unit,
		speed = speed,
		context = context
	}
end

TestifyInput.keyboard_press_key = function (key, duration)
	-- function 10
	return {
		action = "press",
		type = "keyboard",
		key = key,
		duration = duration
	}
end

TestifyInput.keyboard_hold_key = function (key)
	-- function 11
	return {
		action = "hold",
		type = "keyboard",
		key = key
	}
end

TestifyInput.keyboard_release_key = function (key)
	-- function 12
	return {
		action = "release",
		type = "keyboard",
		key = key
	}
end

TestifyInput.keyboard_write_text = function (text)
	-- function 13
	return {
		action = "write_text",
		type = "keyboard",
		text = text
	}
end

return TestifyInput
