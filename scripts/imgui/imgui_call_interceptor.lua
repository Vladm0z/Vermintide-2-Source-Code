-- chunkname: @scripts/imgui/imgui_call_interceptor.lua

ImguiCallInterceptor = class(ImguiCallInterceptor)

local function fn(...)
	-- function 1
	return {
		n = select("#", ...),
		...
	}
end

local tbl = {}

local function fn_2(self, ...)
	-- function 2
	self.rets = fn(...)

	return ...
end

local setmetatable = setmetatable
local __INTERCEPT_CALLS__ = __INTERCEPT_CALLS__

__INTERCEPT_CALLS__ = __INTERCEPT_CALLS__ or {}
__INTERCEPT_CALLS__ = setmetatable(__INTERCEPT_CALLS__, {
	__call = function (self, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		if type(arg_3_1) == "string" then
			arg_3_3 = arg_3_2

			for iter_3_0 in arg_3_1:gmatch("[^\r\n]+") do
				local match, var_3_1 = string.match(arg_3_1, "([%w_]+)[%:%.]([%w_]+)")

				self(rawget(_G, match), var_3_1, arg_3_3)
			end

			return
		end

		local var_3_2 = arg_3_1[arg_3_2]
		local tbl = {
			hits = 0,
			buffer = 50,
			enabled = arg_3_3 == nil or not not arg_3_3
		}

		arg_3_1[arg_3_2] = function (...)
			-- function 4
			if not tbl.enabled then
				return var_3_2(...)
			end

			tbl.hits = tbl.hits + 1

			local time_since_launch = Application.time_since_launch()
			local tbl_2 = {
				i = tbl.hits,
				time = string.format("%d:%.4f", math.floor(time_since_launch / 60), time_since_launch % 60),
				args = fn(...)
			}

			tbl[#tbl + 1] = tbl_2

			while #tbl > tbl.buffer do
				table.remove(tbl, 1)
			end

			return fn_2(tbl_2, var_3_2(...))
		end

		local format = string.format
		local str = "%s.%s"
		local find = table.find(_G, arg_3_1)

		find = find or arg_3_1
		self[format(str, find, arg_3_2)] = tbl
	end
})

ImguiCallInterceptor.init = function (self)
	-- function 5
	self._is_persistent = false
	self._obj_name = ""
	self._method_name = ""
end

ImguiCallInterceptor.update = function (arg_6_0)
	-- function 6
	return
end

local str = "Usage:\n\tfunc = __INTERCEPT_CALLS__[[\n\t\tUtilTable.func\n\t\tClassTable:method\n\t\tinstance_table:method\n\t]]\n\t(Note: there's no difference between `.` or `:`)\n\nDescription:\n\tIntercept calls and show input/output data.\n\nExample:\n\t__INTERCEPT_CALLS__ \"WwiseWorld.trigger_event\"\n"

ImguiCallInterceptor.draw = function (self)
	-- function 7
	local begin_window = Imgui.begin_window("Call Interceptor")

	Imgui.set_window_size(800, 600, "once")

	if not Imgui.tree_node("[[ Call Interceptor Options ]]") then
		self._is_persistent = Imgui.checkbox("Is persistent", not not self._is_persistent)
		self._obj_name = Imgui.input_text("Object", self._obj_name)
		self._method_name = Imgui.input_text("Method", self._method_name)

		if not Imgui.button("Intercept") and not pcall(__INTERCEPT_CALLS__, rawget(_G, self._obj_name), self._method_name) then
			self._obj_name = ""
			self._method_name = ""
		end

		for iter_7_0 in string.gmatch(str, "[^\n\r]+") do
			if not string.find(iter_7_0, "^\t") then
				Imgui.text(iter_7_0)
			else
				Imgui.text_colored(iter_7_0, 200, 200, 233, 255)
			end
		end

		Imgui.tree_pop()
	end

	for k, v in pairs(__INTERCEPT_CALLS__) do
		if not Imgui.tree_node(k) then
			v.enabled = Imgui.checkbox("Capturing", v.enabled)

			Imgui.same_line(50)

			if not Imgui.button("Clear log") then
				for l = 1, #v do
					v[l] = nil
				end
			end

			Imgui.same_line(50)
			Imgui.text("Total calls: " .. v.hits)

			v.buffer = Imgui.input_int("Buffer size", v.buffer)

			for i4 = #v, 1, -1 do
				local var_7_1 = v[i4]

				if not Imgui.tree_node(string.format("[Call %3d]", var_7_1.i)) then
					local args = var_7_1.args

					if not (args.n > 0) or not Imgui.tree_node("Arguments", true) then
						for i5 = 1, args.n do
							ImguiLuaScratchpad:_inspect_pair(i5, args[i5])
						end

						Imgui.tree_pop()
					end

					local rets = var_7_1.rets

					if not (rets.n > 0) or not Imgui.tree_node("Returns", true) then
						for i6 = 1, rets.n do
							ImguiLuaScratchpad:_inspect_pair(i6, rets[i6])
						end

						Imgui.tree_pop()
					end

					Imgui.tree_pop()
				end
			end

			Imgui.tree_pop()
		end
	end

	Imgui.end_window()

	return begin_window
end

ImguiCallInterceptor.is_persistent = function (self)
	-- function 8
	return self._is_persistent
end
