-- chunkname: @scripts/ui/views/show_cursor_stack.lua

ShowCursorStack = ShowCursorStack or {
	stack_depth = 0,
	reasons = {}
}

local var_0_0 = Window.set_clip_cursor

function ShowCursorStack.render_cursor(arg_1_0)
	ShowCursorStack.allow_cursor_rendering = arg_1_0

	if ShowCursorStack.stack_depth > 0 then
		local var_1_0 = Application.is_fullscreen and Application.is_fullscreen()

		Window.set_show_cursor(arg_1_0)
		var_0_0(not arg_1_0 or var_1_0)
	end
end

function ShowCursorStack.push(arg_2_0)
	if ShowCursorStack.stack_depth == 0 and ShowCursorStack.allow_cursor_rendering then
		local var_2_0 = Application.is_fullscreen and Application.is_fullscreen()

		Window.set_show_cursor(true)
		var_0_0(var_2_0 or false)
	end

	ShowCursorStack.stack_depth = ShowCursorStack.stack_depth + 1
end

function ShowCursorStack.pop(arg_3_0)
	ShowCursorStack.stack_depth = ShowCursorStack.stack_depth - 1

	if ShowCursorStack.stack_depth < 0 and IS_WINDOWS then
		print("[ShowCursorStack.pop()] Trying to pop a cursor stack that doesn't exist.")
		Crashify.print_exception("ShowCursorStack", "Trying to pop a cursor stack that doesn't exist.")
	end

	if ShowCursorStack.stack_depth == 0 then
		Window.set_show_cursor(false)
		var_0_0(true)
	end

	ShowCursorStack.stack_depth = math.max(ShowCursorStack.stack_depth, 0)
end

function ShowCursorStack.show(arg_4_0)
	local var_4_0 = not table.is_empty(ShowCursorStack.reasons)

	ShowCursorStack.reasons[arg_4_0] = true

	if not var_4_0 then
		ShowCursorStack.push(true)
	end
end

function ShowCursorStack.hide(arg_5_0)
	local var_5_0 = not table.is_empty(ShowCursorStack.reasons)

	ShowCursorStack.reasons[arg_5_0] = nil

	if var_5_0 and table.is_empty(ShowCursorStack.reasons) then
		ShowCursorStack.pop(true)
	end
end

function ShowCursorStack.update_clip_cursor()
	local var_6_0 = Application.is_fullscreen and Application.is_fullscreen()
	local var_6_1 = ShowCursorStack.allow_cursor_rendering

	if ShowCursorStack.stack_depth == 0 and var_6_1 then
		var_0_0(var_6_0 or false)
	elseif ShowCursorStack.stack_depth > 0 then
		var_0_0(var_6_0)
	end
end

function ShowCursorStack.cursor_active()
	return ShowCursorStack.stack_depth > 0
end

function ShowCursorStack.dump()
	local var_8_0 = {}

	table.insert(var_8_0, "Stack size: " .. ShowCursorStack.stack_depth)
	table.insert(var_8_0, "Reasons:" .. (table.is_empty(ShowCursorStack.reasons) and " (none)" or ""))

	for iter_8_0 in pairs(ShowCursorStack.reasons) do
		table.insert(var_8_0, "\t" .. iter_8_0)
	end

	print(table.concat(var_8_0, "\n"))
end
