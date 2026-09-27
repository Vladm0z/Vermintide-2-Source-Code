-- chunkname: @scripts/ui/views/show_cursor_stack.lua

local ShowCursorStack = ShowCursorStack

ShowCursorStack = ShowCursorStack or {
	stack_depth = 0,
	reasons = {}
}
ShowCursorStack = ShowCursorStack

local set_clip_cursor = Window.set_clip_cursor

ShowCursorStack.render_cursor = function (arg_1_0)
	-- function 1
	ShowCursorStack.allow_cursor_rendering = arg_1_0

	if ShowCursorStack.stack_depth > 0 then
		local is_fullscreen = Application.is_fullscreen

		is_fullscreen = not is_fullscreen and Application.is_fullscreen()

		Window.set_show_cursor(arg_1_0)
		set_clip_cursor(not arg_1_0 and is_fullscreen)
	end
end

ShowCursorStack.push = function (arg_2_0)
	-- function 2
	if ShowCursorStack.stack_depth ~= 0 or not ShowCursorStack.allow_cursor_rendering then
		local is_fullscreen = Application.is_fullscreen

		is_fullscreen = not is_fullscreen and Application.is_fullscreen()

		Window.set_show_cursor(true)
		set_clip_cursor(is_fullscreen or false)
	end

	ShowCursorStack.stack_depth = ShowCursorStack.stack_depth + 1
end

ShowCursorStack.pop = function (arg_3_0)
	-- function 3
	ShowCursorStack.stack_depth = ShowCursorStack.stack_depth - 1

	if not (ShowCursorStack.stack_depth < 0) or not IS_WINDOWS then
		print("[ShowCursorStack.pop()] Trying to pop a cursor stack that doesn't exist.")
		Crashify.print_exception("ShowCursorStack", "Trying to pop a cursor stack that doesn't exist.")
	end

	if ShowCursorStack.stack_depth == 0 then
		Window.set_show_cursor(false)
		set_clip_cursor(true)
	end

	ShowCursorStack.stack_depth = math.max(ShowCursorStack.stack_depth, 0)
end

ShowCursorStack.show = function (arg_4_0)
	-- function 4
	local flag = not table.is_empty(ShowCursorStack.reasons)

	ShowCursorStack.reasons[arg_4_0] = true

	if not flag then
		ShowCursorStack.push(true)
	end
end

ShowCursorStack.hide = function (arg_5_0)
	-- function 5
	local flag = not table.is_empty(ShowCursorStack.reasons)

	ShowCursorStack.reasons[arg_5_0] = nil

	if not flag and not table.is_empty(ShowCursorStack.reasons) then
		ShowCursorStack.pop(true)
	end
end

ShowCursorStack.update_clip_cursor = function ()
	-- function 6
	local is_fullscreen = Application.is_fullscreen

	is_fullscreen = not is_fullscreen and Application.is_fullscreen()

	local allow_cursor_rendering = ShowCursorStack.allow_cursor_rendering

	if ShowCursorStack.stack_depth ~= 0 or not allow_cursor_rendering then
		set_clip_cursor(is_fullscreen or false)
	elseif ShowCursorStack.stack_depth > 0 then
		set_clip_cursor(is_fullscreen)
	end
end

ShowCursorStack.cursor_active = function ()
	-- function 7
	return ShowCursorStack.stack_depth > 0
end

ShowCursorStack.dump = function ()
	-- function 8
	local tbl = {}

	table.insert(tbl, "Stack size: " .. ShowCursorStack.stack_depth)

	local insert = table.insert
	local var_8_2 = tbl
	local str = "Reasons:"
	local flag

	flag = not table.is_empty(ShowCursorStack.reasons) and " (none)" and ""

	insert(var_8_2, str .. flag)

	for k in pairs(ShowCursorStack.reasons) do
		table.insert(tbl, "\t" .. k)
	end

	print(table.concat(tbl, "\n"))
end
