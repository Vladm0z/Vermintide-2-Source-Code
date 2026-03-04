-- chunkname: @scripts/imgui/imgui_lua_scratchpad.lua

ImguiLuaScratchpad = class(ImguiLuaScratchpad)

local var_0_0 = {
	199,
	206,
	234,
	255
}

ImguiLuaScratchpad._TYPE_TO_COLOR = setmetatable({
	["function"] = {
		181,
		234,
		215,
		255
	},
	string = {
		226,
		240,
		203,
		255
	},
	number = {
		255,
		218,
		193,
		255
	},
	boolean = {
		255,
		183,
		178,
		255
	},
	userdata = {
		255,
		154,
		162,
		255
	},
	table = {
		255,
		247,
		154,
		255
	}
}, {
	__index = function ()
		return var_0_0
	end
})

local var_0_1, var_0_2 = pcall(require, "jit.util")
local var_0_3 = {
	__mode = "kv",
	__index = function (arg_2_0, arg_2_1)
		local var_2_0 = var_0_2.funcinfo(arg_2_1)

		arg_2_0[arg_2_1] = var_2_0

		return var_2_0
	end
}
local var_0_4 = string.format

ImguiLuaScratchpad.init = function (arg_3_0)
	if not script_data.lua_inspector_config then
		local var_3_0 = Development.setting("lua_inspector_config")

		if not var_3_0 then
			script_data.lua_inspector_config = {
				expr = "",
				sort_keys = false,
				persistent = false,
				dirty = false
			}
		else
			script_data.lua_inspector_config = var_3_0
		end
	end

	arg_3_0._thunk, arg_3_0._error, arg_3_0._val = nil
	arg_3_0._func_info_magic = setmetatable({}, var_0_3)
end

ImguiLuaScratchpad.update = function (arg_4_0)
	return
end

ImguiLuaScratchpad.draw = function (arg_5_0)
	local var_5_0 = Imgui.begin_window("Lua Inspector")

	script_data.lua_inspector_config.persistent = Imgui.checkbox("Is persistent", script_data.lua_inspector_config.persistent)

	Imgui.same_line()

	script_data.lua_inspector_config.sort_keys = Imgui.checkbox("Sort keys (slow)", script_data.lua_inspector_config.sort_keys)

	Imgui.same_line()

	arg_5_0._exec_every_frame = Imgui.checkbox("Execute every frame", arg_5_0._exec_every_frame or false)

	Imgui.same_line()

	if (arg_5_0._exec_every_frame or Imgui.button("Execute")) and arg_5_0:_load_expression() then
		arg_5_0:_execute_thunk()
	end

	Imgui.same_line()

	if arg_5_0._error then
		Imgui.text_colored(arg_5_0._error, 255, 100, 100, 255)
	else
		Imgui.text_colored("Thunk loaded.", 100, 255, 100, 255)
	end

	local var_5_1 = script_data.lua_inspector_config.expr

	script_data.lua_inspector_config.expr = Imgui.input_text_multiline("Input", var_5_1)

	if var_5_1 ~= script_data.lua_inspector_config.expr then
		script_data.lua_inspector_config.dirty = true

		arg_5_0:_load_expression()
	end

	Imgui.begin_child_window("Inspector", 0, 0, true)
	arg_5_0:_inspect_pair("Output", arg_5_0._val)
	Imgui.end_child_window()
	Imgui.end_window()

	return var_5_0
end

ImguiLuaScratchpad._inspect_pair = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_1 = tostring(arg_6_1)

	local var_6_0 = type(arg_6_2)

	if var_6_0 == "table" then
		return arg_6_0:_inspect_table(arg_6_1, arg_6_2)
	elseif var_6_0 == "function" then
		return arg_6_0:_inspect_function(arg_6_1, arg_6_2)
	elseif var_6_0 == "string" then
		arg_6_2 = ("%q"):format(arg_6_2):gsub("\\\n", "\\n")
	end

	Imgui.text(arg_6_1 .. " =")
	Imgui.same_line()
	Imgui.text_colored(tostring(arg_6_2), unpack(arg_6_0._TYPE_TO_COLOR[var_6_0]))
end

local var_0_5, var_0_6, var_0_7 = pcall(require, "ffi")

if var_0_5 then
	var_0_5, var_0_7 = pcall(var_0_6.load, "shell32")

	var_0_6.cdef(" void *ShellExecuteA(void*, const char*, const char*, const char*, const char*, int); ")
end

ImguiLuaScratchpad._inspect_function = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Imgui.tree_node(arg_7_1, false)

	Imgui.same_line()
	Imgui.text_colored(var_0_4("[%s]", arg_7_2), unpack(arg_7_0._TYPE_TO_COLOR["function"]))

	if var_0_1 and var_7_0 then
		local var_7_1 = arg_7_0._func_info_magic[arg_7_2]
		local var_7_2 = var_7_1.source and not string.find(var_7_1.source, "\n")
		local var_7_3 = var_7_2 and var_0_4("%s:%s", var_7_1.source, var_7_1.linedefined) or var_7_1.addr and var_0_4("0x%012x", var_7_1.addr) or "<unknown origin>"

		Imgui.text_colored(var_7_3, unpack(var_0_0))

		if var_0_5 and var_7_2 then
			Imgui.same_line()

			if Imgui.small_button("Open##" .. var_7_1.source) then
				local var_7_4 = script_data.source_dir
				local var_7_5 = var_7_4 .. var_7_1.source:gsub("^@", "\\"):gsub("/", "\\")

				printf("Opening %q", var_7_5)
				print(var_0_7.ShellExecuteA(nil, "open", var_7_5, nil, var_7_4, 10))
			end
		end

		arg_7_0:_inspect_table("[info]", var_7_1)

		local var_7_6 = var_7_1.upvalues

		if var_7_6 > 0 and Imgui.tree_node("[upvalues]", false) then
			for iter_7_0 = 1, var_7_6 do
				local var_7_7, var_7_8 = debug.getupvalue(arg_7_2, iter_7_0)

				arg_7_0:_inspect_pair(iter_7_0 .. " (" .. var_7_7 .. ")", var_7_8)
			end

			Imgui.tree_pop()
		end

		if var_0_1 and var_7_1.nconsts and var_7_1.nconsts ~= 0 and var_7_1.gcconsts ~= 0 and Imgui.tree_node("[consts]", false) then
			for iter_7_1 = -var_7_1.gcconsts, var_7_1.nconsts - 1 do
				arg_7_0:_inspect_pair(iter_7_1, var_0_2.funck(arg_7_2, iter_7_1))
			end

			Imgui.tree_pop()
		end

		Imgui.tree_pop()
	end
end

local function var_0_8(arg_8_0, arg_8_1)
	local var_8_0 = type(arg_8_0)
	local var_8_1 = type(arg_8_1)

	if var_8_0 ~= var_8_1 then
		return var_8_0 < var_8_1
	elseif var_8_0 == "string" or var_8_0 == "number" then
		return arg_8_0 < arg_8_1
	else
		return tostring(arg_8_0) < tostring(arg_8_1)
	end
end

ImguiLuaScratchpad._inspect_table = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = Imgui.tree_node(arg_9_1, false)
	local var_9_1 = getmetatable(arg_9_2)
	local var_9_2 = rawget(arg_9_2, "___is_class_metatable___") and "class" or var_9_1 and var_9_1 ~= true and var_9_1.___is_class_metatable___ and table.find(_G, var_9_1) or "table"

	Imgui.same_line()
	Imgui.text_colored(var_0_4("[%s: %p]", var_9_2, arg_9_2), unpack(arg_9_0._TYPE_TO_COLOR.table))

	if var_9_0 then
		if script_data.lua_inspector_config.sort_keys then
			local var_9_3 = table.keys(arg_9_2)

			table.sort(var_9_3, var_0_8)

			for iter_9_0, iter_9_1 in pairs(var_9_3) do
				arg_9_0:_inspect_pair(iter_9_1, arg_9_2[iter_9_1])
			end
		else
			for iter_9_2, iter_9_3 in pairs(arg_9_2) do
				arg_9_0:_inspect_pair(iter_9_2, iter_9_3)
			end
		end

		if var_9_1 then
			arg_9_0:_inspect_table("[metatable]", var_9_1)
		end

		Imgui.tree_pop()
	end
end

ImguiLuaScratchpad._load_expression = function (arg_10_0)
	arg_10_0._thunk, arg_10_0._error = loadstring("return " .. script_data.lua_inspector_config.expr, "Input")

	if not arg_10_0._thunk then
		arg_10_0._thunk, arg_10_0._error = loadstring(script_data.lua_inspector_config.expr, "Input")
	end

	return arg_10_0._thunk ~= nil
end

local function var_0_9(arg_11_0)
	local var_11_0 = {}

	for iter_11_0 = 2, 9999 do
		local var_11_1 = debug.getinfo(iter_11_0, "nSluf")

		if not var_11_1 then
			break
		end

		local var_11_2 = {}
		local var_11_3 = {}

		for iter_11_1 = 1, 9999 do
			local var_11_4, var_11_5 = debug.getlocal(iter_11_0, iter_11_1)

			if not var_11_4 then
				break
			end

			var_11_2[var_11_4] = var_11_5
		end

		for iter_11_2 = 1, var_11_1.nups or 0 do
			local var_11_6, var_11_7 = debug.getupvalue(var_11_1.func, iter_11_2)

			if not var_11_6 then
				break
			end

			var_11_3[var_11_6] = var_11_7
		end

		var_11_0[iter_11_0 - 1] = {
			name = var_11_1.name,
			info = var_11_1,
			slots = var_11_2,
			ups = var_11_3
		}
	end

	return {
		error = arg_11_0 or "?",
		stack = var_11_0
	}
end

ImguiLuaScratchpad._execute_thunk = function (arg_12_0)
	local var_12_0, var_12_1 = xpcall(arg_12_0._thunk, var_0_9)

	if var_12_0 then
		arg_12_0._val, arg_12_0._error = var_12_1

		if script_data.lua_inspector_config.dirty then
			script_data.lua_inspector_config.dirty = false

			Development.set_setting("lua_inspector_config", script_data.lua_inspector_config)
			Application.save_user_settings()
		end
	else
		arg_12_0._val, arg_12_0._error = var_12_1, "Runtime error"
	end
end

ImguiLuaScratchpad.is_persistent = function (arg_13_0)
	return script_data.lua_inspector_config.persistent
end
