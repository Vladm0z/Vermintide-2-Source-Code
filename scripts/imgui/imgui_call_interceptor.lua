-- chunkname: @scripts/imgui/imgui_call_interceptor.lua

ImguiCallInterceptor = class(ImguiCallInterceptor)

local function var_0_0(...)
	return {
		n = select("#", ...),
		...
	}
end

local var_0_1 = {}

local function var_0_2(arg_2_0, ...)
	arg_2_0.rets = var_0_0(...)

	return ...
end

__INTERCEPT_CALLS__ = setmetatable(__INTERCEPT_CALLS__ or {}, {
	__call = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if type(arg_3_1) == "string" then
			arg_3_3 = arg_3_2

			for iter_3_0 in arg_3_1:gmatch("[^\r\n]+") do
				local var_3_0, var_3_1 = string.match(arg_3_1, "([%w_]+)[%:%.]([%w_]+)")

				arg_3_0(rawget(_G, var_3_0), var_3_1, arg_3_3)
			end

			return
		end

		local var_3_2 = arg_3_1[arg_3_2]
		local var_3_3 = {
			hits = 0,
			buffer = 50,
			enabled = arg_3_3 == nil or not not arg_3_3
		}

		arg_3_1[arg_3_2] = function (...)
			if not var_3_3.enabled then
				return var_3_2(...)
			end

			var_3_3.hits = var_3_3.hits + 1

			local var_4_0 = Application.time_since_launch()
			local var_4_1 = {
				i = var_3_3.hits,
				time = string.format("%d:%.4f", math.floor(var_4_0 / 60), var_4_0 % 60),
				args = var_0_0(...)
			}

			var_3_3[#var_3_3 + 1] = var_4_1

			while #var_3_3 > var_3_3.buffer do
				table.remove(var_3_3, 1)
			end

			return var_0_2(var_4_1, var_3_2(...))
		end
		arg_3_0[string.format("%s.%s", table.find(_G, arg_3_1) or arg_3_1, arg_3_2)] = var_3_3
	end
})

ImguiCallInterceptor.init = function (arg_5_0)
	arg_5_0._is_persistent = false
	arg_5_0._obj_name = ""
	arg_5_0._method_name = ""
end

ImguiCallInterceptor.update = function (arg_6_0)
	return
end

local var_0_3 = "Usage:\n\tfunc = __INTERCEPT_CALLS__[[\n\t\tUtilTable.func\n\t\tClassTable:method\n\t\tinstance_table:method\n\t]]\n\t(Note: there's no difference between `.` or `:`)\n\nDescription:\n\tIntercept calls and show input/output data.\n\nExample:\n\t__INTERCEPT_CALLS__ \"WwiseWorld.trigger_event\"\n"

ImguiCallInterceptor.draw = function (arg_7_0)
	local var_7_0 = Imgui.begin_window("Call Interceptor")

	Imgui.set_window_size(800, 600, "once")

	if Imgui.tree_node("[[ Call Interceptor Options ]]") then
		arg_7_0._is_persistent = Imgui.checkbox("Is persistent", not not arg_7_0._is_persistent)
		arg_7_0._obj_name = Imgui.input_text("Object", arg_7_0._obj_name)
		arg_7_0._method_name = Imgui.input_text("Method", arg_7_0._method_name)

		if Imgui.button("Intercept") and pcall(__INTERCEPT_CALLS__, rawget(_G, arg_7_0._obj_name), arg_7_0._method_name) then
			arg_7_0._obj_name = ""
			arg_7_0._method_name = ""
		end

		for iter_7_0 in string.gmatch(var_0_3, "[^\n\r]+") do
			if string.find(iter_7_0, "^\t") then
				Imgui.text(iter_7_0)
			else
				Imgui.text_colored(iter_7_0, 200, 200, 233, 255)
			end
		end

		Imgui.tree_pop()
	end

	for iter_7_1, iter_7_2 in pairs(__INTERCEPT_CALLS__) do
		if Imgui.tree_node(iter_7_1) then
			iter_7_2.enabled = Imgui.checkbox("Capturing", iter_7_2.enabled)

			Imgui.same_line(50)

			if Imgui.button("Clear log") then
				for iter_7_3 = 1, #iter_7_2 do
					iter_7_2[iter_7_3] = nil
				end
			end

			Imgui.same_line(50)
			Imgui.text("Total calls: " .. iter_7_2.hits)

			iter_7_2.buffer = Imgui.input_int("Buffer size", iter_7_2.buffer)

			for iter_7_4 = #iter_7_2, 1, -1 do
				local var_7_1 = iter_7_2[iter_7_4]

				if Imgui.tree_node(string.format("[Call %3d]", var_7_1.i)) then
					local var_7_2 = var_7_1.args

					if var_7_2.n > 0 and Imgui.tree_node("Arguments", true) then
						for iter_7_5 = 1, var_7_2.n do
							ImguiLuaScratchpad:_inspect_pair(iter_7_5, var_7_2[iter_7_5])
						end

						Imgui.tree_pop()
					end

					local var_7_3 = var_7_1.rets

					if var_7_3.n > 0 and Imgui.tree_node("Returns", true) then
						for iter_7_6 = 1, var_7_3.n do
							ImguiLuaScratchpad:_inspect_pair(iter_7_6, var_7_3[iter_7_6])
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

	return var_7_0
end

ImguiCallInterceptor.is_persistent = function (arg_8_0)
	return arg_8_0._is_persistent
end
