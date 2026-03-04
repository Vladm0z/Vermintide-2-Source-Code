-- chunkname: @foundation/scripts/util/patches.lua

require("foundation/scripts/util/misc_util")

local function var_0_0(arg_1_0)
	local var_1_0 = rawget(_G, arg_1_0) or {}

	assert(getmetatable(var_1_0) == nil, "It's not safe auto-patching methods on a table that already has a metatable. Set them to NOP manually.")

	return rawset(_G, arg_1_0, setmetatable(var_1_0, {
		__index = function (arg_2_0, arg_2_1)
			if not script_data.disable_auto_patch_missing_methods then
				Application.error("Missing method key autovivified with NOP: %s.%s\n%s", arg_1_0, arg_2_1, Script.callstack())

				arg_2_0[arg_2_1] = NOP

				return NOP
			end
		end
	}))
end

MockClass = MockClass or {}

MockClass.new = function ()
	return MockClass
end

local var_0_1 = {
	__index = function (arg_4_0, arg_4_1)
		return NOP
	end,
	update = NOP
}

setmetatable(MockClass, var_0_1)

if not _G.FOUNDATION_patches_applied and (IS_CONSOLE or DEDICATED_SERVER) then
	_G.FOUNDATION_patches_applied = true

	if not Wwise then
		var_0_0("Wwise")
	end

	if not WwiseWorld then
		var_0_0("WwiseWorld")
	end

	if not TerrainDecoration then
		var_0_0("TerrainDecoration")
	end

	if not LandscapeDecoration then
		var_0_0("LandscapeDecoration")
	end

	var_0_0("Application")

	Application.apply_user_settings = NOP
	Application.enum_display_modes = TNEW
	Application.open_url_in_browser = NOP
	Application.process_id = CONST(4919)
	Application.restart_file_log = NOP
	Application.save_render_target = NOP
	Application.set_max_frame_stacking = NOP
	Application.user_settings_load_error = NOP

	var_0_0("Window")

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

	var_0_0("DisplayAdapter")

	DisplayAdapter.num_adapters = CONST(0)
	DisplayAdapter.name = CONST("function patched out")
	DisplayAdapter.num_outputs = CONST(0)
	DisplayAdapter.num_modes = CONST(0)

	DisplayAdapter.mode = function ()
		return 1, 1
	end

	if not DEDICATED_SERVER then
		var_0_0("CommandWindow")

		CommandWindow.close = NOP
		CommandWindow.open = NOP
		CommandWindow.print = NOP
		CommandWindow.read_line = NOP
		CommandWindow.title = CONST("function patched out")
		CommandWindow.update = NOP
	end
end

if not Clipboard then
	var_0_0("Clipboard")

	Clipboard.get = CONST("")
	Clipboard.put = NOP
end

if not Presence then
	var_0_0("Presence")

	Presence.set_presence = NOP
end

ColorBox = QuaternionBox
__STRING_FORMAT = __STRING_FORMAT or nil

if not __STRING_FORMAT then
	local var_0_2 = {}
	local var_0_3 = {}

	__STRING_FORMAT = __STRING_FORMAT or string.format
	string._format = string.format

	string.format = function (arg_6_0, ...)
		if var_0_2[arg_6_0] then
			return __STRING_FORMAT(arg_6_0, ...)
		end

		if var_0_3[arg_6_0] then
			return "<Invalid string format>"
		end

		local var_6_0, var_6_1 = pcall(__STRING_FORMAT, arg_6_0, ...)

		if not var_6_0 then
			var_0_3[arg_6_0] = true

			Crashify.print_exception("string.format", "Invalid string format for string %q", arg_6_0)

			return "<Invalid string format>"
		else
			var_0_2[arg_6_0] = true

			return var_6_1
		end
	end
end
