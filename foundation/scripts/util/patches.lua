-- chunkname: @foundation/scripts/util/patches.lua

require("foundation/scripts/util/misc_util")

local function fn(arg_1_0)
	-- function 1
	local var_1_0 = rawget(_G, arg_1_0)

	var_1_0 = var_1_0 or {}

	assert(getmetatable(var_1_0) == nil, "It's not safe auto-patching methods on a table that already has a metatable. Set them to NOP manually.")

	return rawset(_G, arg_1_0, setmetatable(var_1_0, {
		__index = function (self, arg_2_1)
			-- function 2
			if not script_data.disable_auto_patch_missing_methods then
				Application.error("Missing method key autovivified with NOP: %s.%s\n%s", arg_1_0, arg_2_1, Script.callstack())

				self[arg_2_1] = NOP

				return NOP
			end
		end
	}))
end

local MockClass = MockClass

MockClass = MockClass or {}
MockClass = MockClass

MockClass.new = function ()
	-- function 3
	return MockClass
end

local tbl = {
	__index = function (arg_4_0, arg_4_1)
		-- function 4
		return NOP
	end,
	update = NOP
}

setmetatable(MockClass, tbl)

if _G.FOUNDATION_patches_applied or IS_CONSOLE or not DEDICATED_SERVER then
	_G.FOUNDATION_patches_applied = true

	if not Wwise then
		fn("Wwise")
	end

	if not WwiseWorld then
		fn("WwiseWorld")
	end

	if not TerrainDecoration then
		fn("TerrainDecoration")
	end

	if not LandscapeDecoration then
		fn("LandscapeDecoration")
	end

	fn("Application")

	Application.apply_user_settings = NOP
	Application.enum_display_modes = TNEW
	Application.open_url_in_browser = NOP
	Application.process_id = CONST(4919)
	Application.restart_file_log = NOP
	Application.save_render_target = NOP
	Application.set_max_frame_stacking = NOP
	Application.user_settings_load_error = NOP

	fn("Window")

	Window.KEYSTROKE_ALT_ENTER = 0
	Window.KEYSTROKE_ALT_F4 = 0
	Window.KEYSTROKE_ALT_TAB = 0
	Window.KEYSTROKE_WINDOWS = 0
	Window.clip_cursor = NOP
	Window.close = NOP
	Window.has_focus = NOP
	Window.is_closing = NOP
	Window.is_resizable = NOP
	Window.is_minimized = NOP
	Window.minimize = NOP
	Window.mouse_focus = NOP
	Window.open = NOP
	Window.set_clip_cursor = NOP
	Window.set_cursor = NOP
	Window.set_focus = NOP
	Window.set_ime_enabled = NOP
	Window.set_keystroke_enabled = NOP
	Window.set_mouse_focus = NOP
	Window.set_resizable = NOP
	Window.set_show_cursor = NOP
	Window.set_title = NOP
	Window.show_cursor = NOP

	fn("DisplayAdapter")

	DisplayAdapter.num_adapters = CONST(0)
	DisplayAdapter.name = CONST("function patched out")
	DisplayAdapter.num_outputs = CONST(0)
	DisplayAdapter.num_modes = CONST(0)

	DisplayAdapter.mode = function ()
		-- function 5
		return 1, 1
	end

	if not DEDICATED_SERVER then
		fn("CommandWindow")

		CommandWindow.close = NOP
		CommandWindow.open = NOP
		CommandWindow.print = NOP
		CommandWindow.read_line = NOP
		CommandWindow.title = CONST("function patched out")
		CommandWindow.update = NOP
	end
end

if not Clipboard then
	fn("Clipboard")

	Clipboard.get = CONST("")
	Clipboard.put = NOP
end

if not Presence then
	fn("Presence")

	Presence.set_presence = NOP
end

ColorBox = QuaternionBox

local __STRING_FORMAT = __STRING_FORMAT

__STRING_FORMAT = __STRING_FORMAT or nil
__STRING_FORMAT = __STRING_FORMAT

if not __STRING_FORMAT then
	local tbl_2 = {}
	local tbl_3 = {}
	local __STRING_FORMAT_2 = __STRING_FORMAT

	__STRING_FORMAT_2 = __STRING_FORMAT_2 or string.format
	__STRING_FORMAT = __STRING_FORMAT_2
	string._format = string.format

	string.format = function (arg_6_0, ...)
		-- function 6
		if not tbl_2[arg_6_0] then
			return __STRING_FORMAT(arg_6_0, ...)
		end

		if not tbl_3[arg_6_0] then
			return "<Invalid string format>"
		end

		local var_6_0, var_6_1 = pcall(__STRING_FORMAT, arg_6_0, ...)

		if not var_6_0 then
			tbl_3[arg_6_0] = true

			Crashify.print_exception("string.format", "Invalid string format for string %q", arg_6_0)

			return "<Invalid string format>"
		else
			tbl_2[arg_6_0] = true

			return var_6_1
		end
	end
end
