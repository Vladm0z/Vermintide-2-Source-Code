-- chunkname: @scripts/imgui/imgui_lua_scratchpad.lua

ImguiLuaScratchpad = class(ImguiLuaScratchpad)

local tbl = {
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
		-- function 1
		return tbl
	end
})

local var_0_1, var_0_2 = pcall(require, "jit.util")
local tbl_2 = {
	__mode = "kv",
	__index = function (self, arg_2_1)
		-- function 2
		local funcinfo = var_0_2.funcinfo(arg_2_1)

		self[arg_2_1] = funcinfo

		return funcinfo
	end
}
local format = string.format

ImguiLuaScratchpad.init = function (self)
	-- function 3
	if not script_data.lua_inspector_config then
		local setting = Development.setting("lua_inspector_config")

		if not setting then
			script_data.lua_inspector_config = {
				expr = "",
				sort_keys = false,
				persistent = false,
				dirty = false
			}
		else
			script_data.lua_inspector_config = setting
		end
	end

	self._thunk, self._error, self._val = nil
	self._func_info_magic = setmetatable({}, tbl_2)
end

ImguiLuaScratchpad.update = function (arg_4_0)
	-- function 4
	return
end

ImguiLuaScratchpad.draw = function (self)
	-- function 5
	local begin_window = Imgui.begin_window("Lua Inspector")

	script_data.lua_inspector_config.persistent = Imgui.checkbox("Is persistent", script_data.lua_inspector_config.persistent)

	Imgui.same_line()

	script_data.lua_inspector_config.sort_keys = Imgui.checkbox("Sort keys (slow)", script_data.lua_inspector_config.sort_keys)

	Imgui.same_line()

	local checkbox = Imgui.checkbox
	local str = "Execute every frame"
	local _exec_every_frame = self._exec_every_frame

	_exec_every_frame = _exec_every_frame or false
	self._exec_every_frame = checkbox(str, _exec_every_frame)

	Imgui.same_line()

	if self._exec_every_frame or not Imgui.button("Execute") or not self:_load_expression() then
		self:_execute_thunk()
	end

	Imgui.same_line()

	if not self._error then
		Imgui.text_colored(self._error, 255, 100, 100, 255)
	else
		Imgui.text_colored("Thunk loaded.", 100, 255, 100, 255)
	end

	local expr = script_data.lua_inspector_config.expr

	script_data.lua_inspector_config.expr = Imgui.input_text_multiline("Input", expr)

	if expr ~= script_data.lua_inspector_config.expr then
		script_data.lua_inspector_config.dirty = true

		self:_load_expression()
	end

	Imgui.begin_child_window("Inspector", 0, 0, true)
	self:_inspect_pair("Output", self._val)
	Imgui.end_child_window()
	Imgui.end_window()

	return begin_window
end

ImguiLuaScratchpad._inspect_pair = function (self, arg_6_1, arg_6_2)
	-- function 6
	arg_6_1 = tostring(arg_6_1)

	local var_6_0 = type(arg_6_2)

	if var_6_0 == "table" then
		return self:_inspect_table(arg_6_1, arg_6_2)
	elseif var_6_0 == "function" then
		return self:_inspect_function(arg_6_1, arg_6_2)
	elseif var_6_0 == "string" then
		arg_6_2 = ("%q"):format(arg_6_2):gsub("\\\n", "\\n")
	end

	Imgui.text(arg_6_1 .. " =")
	Imgui.same_line()
	Imgui.text_colored(tostring(arg_6_2), unpack(self._TYPE_TO_COLOR[var_6_0]))
end

local var_0_5, var_0_6, var_0_7 = pcall(require, "ffi")

if not var_0_5 then
	var_0_5, var_0_7 = pcall(var_0_6.load, "shell32")

	var_0_6.cdef(" void *ShellExecuteA(void*, const char*, const char*, const char*, const char*, int); ")
end

ImguiLuaScratchpad._inspect_function = function (self, arg_7_1, arg_7_2)
	-- function 7
	local tree_node = Imgui.tree_node(arg_7_1, false)

	Imgui.same_line()
	Imgui.text_colored(format("[%s]", arg_7_2), unpack(self._TYPE_TO_COLOR["function"]))

	if not var_0_1 and not tree_node then
		local var_7_1 = self._func_info_magic[arg_7_2]
		local source = var_7_1.source

		source = not source and not string.find(var_7_1.source, "\n")

		local var_7_3

		if not source then
			var_7_3 = format("%s:%s", var_7_1.source, var_7_1.linedefined)

			if not var_7_3 then
				-- Nothing
			end
		end

		if not var_7_1.addr then
			var_7_3 = format("0x%012x", var_7_1.addr)

			if not var_7_3 then
				-- Nothing
			end
		end

		var_7_3 = "<unknown origin>"

		::label_7_0::

		Imgui.text_colored(var_7_3, unpack(tbl))

		if not var_0_5 and not source then
			Imgui.same_line()

			if not Imgui.small_button("Open##" .. var_7_1.source) then
				local source_dir = script_data.source_dir
				local str = source_dir .. var_7_1.source:gsub("^@", "\\"):gsub("/", "\\")

				printf("Opening %q", str)
				print(var_0_7.ShellExecuteA(nil, "open", str, nil, source_dir, 10))
			end
		end

		self:_inspect_table("[info]", var_7_1)

		local upvalues = var_7_1.upvalues

		if not (upvalues > 0) or not Imgui.tree_node("[upvalues]", false) then
			for i = 1, upvalues do
				local getupvalue, var_7_8 = debug.getupvalue(arg_7_2, i)

				self:_inspect_pair(i .. " (" .. getupvalue .. ")", var_7_8)
			end

			Imgui.tree_pop()
		end

		if not var_0_1 and not var_7_1.nconsts and var_7_1.nconsts == 0 and var_7_1.gcconsts == 0 or not Imgui.tree_node("[consts]", false) then
			for j = -var_7_1.gcconsts, var_7_1.nconsts - 1 do
				self:_inspect_pair(j, var_0_2.funck(arg_7_2, j))
			end

			Imgui.tree_pop()
		end

		Imgui.tree_pop()
	end
end

local function fn(arg_8_0, arg_8_1)
	-- function 8
	local var_8_0 = type(arg_8_0)
	local var_8_1 = type(arg_8_1)

	if var_8_0 ~= var_8_1 then
		return var_8_0 < var_8_1
	elseif not (var_8_0 == "string" or var_8_0 ~= "number") then
		return arg_8_0 < arg_8_1
	else
		return tostring(arg_8_0) < tostring(arg_8_1)
	end
end

ImguiLuaScratchpad._inspect_table = function (self, arg_9_1, arg_9_2)
	-- function 9
	local tree_node = Imgui.tree_node(arg_9_1, false)
	local var_9_1 = getmetatable(arg_9_2)
	local str

	if not rawget(arg_9_2, "___is_class_metatable___") then
		str = "class"
	else
		if not var_9_1 and var_9_1 == true or not var_9_1.___is_class_metatable___ then
			str = table.find(_G, var_9_1)

			if not str then
				-- Nothing
			end
		end

		str = "table"
	end

	::label_9_0::

	Imgui.same_line()
	Imgui.text_colored(format("[%s: %p]", str, arg_9_2), unpack(self._TYPE_TO_COLOR.table))

	if not tree_node then
		if not script_data.lua_inspector_config.sort_keys then
			local keys = table.keys(arg_9_2)

			table.sort(keys, fn)

			for k, v in pairs(keys) do
				self:_inspect_pair(v, arg_9_2[v])
			end
		else
			for k_2, v_2 in pairs(arg_9_2) do
				self:_inspect_pair(k_2, v_2)
			end
		end

		if not var_9_1 then
			self:_inspect_table("[metatable]", var_9_1)
		end

		Imgui.tree_pop()
	end
end

ImguiLuaScratchpad._load_expression = function (self)
	-- function 10
	self._thunk, self._error = loadstring("return " .. script_data.lua_inspector_config.expr, "Input")

	if not self._thunk then
		self._thunk, self._error = loadstring(script_data.lua_inspector_config.expr, "Input")
	end

	return self._thunk ~= nil
end

local function fn_2(arg_11_0)
	-- function 11
	local tbl = {}

	for i = 2, 9999 do
		local getinfo = debug.getinfo(i, "nSluf")

		if not getinfo then
			break
		end

		local tbl_2 = {}
		local tbl_3 = {}

		for j = 1, 9999 do
			local getlocal, var_11_5 = debug.getlocal(i, j)

			if not getlocal then
				break
			end

			tbl_2[getlocal] = var_11_5
		end

		local num = 1
		local nups = getinfo.nups

		nups = nups or 0

		for k = num, nups do
			local getupvalue, var_11_9 = debug.getupvalue(getinfo.func, k)

			if not getupvalue then
				break
			end

			tbl_3[getupvalue] = var_11_9
		end

		tbl[i - 1] = {
			name = getinfo.name,
			info = getinfo,
			slots = tbl_2,
			ups = tbl_3
		}
	end

	return {
		error = arg_11_0 or "?",
		stack = tbl
	}
end

ImguiLuaScratchpad._execute_thunk = function (self)
	-- function 12
	local var_12_0, var_12_1 = xpcall(self._thunk, fn_2)

	if not var_12_0 then
		self._val, self._error = var_12_1

		if not script_data.lua_inspector_config.dirty then
			script_data.lua_inspector_config.dirty = false

			Development.set_setting("lua_inspector_config", script_data.lua_inspector_config)
			Application.save_user_settings()
		end
	else
		self._val, self._error = var_12_1, "Runtime error"
	end
end

ImguiLuaScratchpad.is_persistent = function (arg_13_0)
	-- function 13
	return script_data.lua_inspector_config.persistent
end
