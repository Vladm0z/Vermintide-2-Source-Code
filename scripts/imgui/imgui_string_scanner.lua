-- chunkname: @scripts/imgui/imgui_string_scanner.lua

ImguiStringScanner = class(ImguiStringScanner)

ImguiStringScanner.init = function (arg_1_0)
	arg_1_0._results = {}
	arg_1_0._query = ""
end

ImguiStringScanner.update = function (arg_2_0, arg_2_1)
	return
end

ImguiStringScanner.draw = function (arg_3_0)
	local var_3_0 = Imgui.begin_window("String Scanner")

	if not rawget(Script, "string_scan") then
		Imgui.text("Required engine functionality is not available.")
		Imgui.end_window()

		return var_3_0
	end

	local var_3_1 = Imgui.input_text("Query", arg_3_0._query)

	arg_3_0._query = var_3_1

	local var_3_2 = arg_3_0._results

	if Imgui.button("Run search") then
		local var_3_3 = Script.string_scan()

		table.clear(var_3_2)

		local var_3_4 = string.lower(var_3_1)

		for iter_3_0, iter_3_1 in pairs(var_3_3) do
			iter_3_0 = string.lower(iter_3_0)

			if string.find(iter_3_0, var_3_4) then
				var_3_2[#var_3_2 + 1] = iter_3_0 .. "\t" .. iter_3_1
			end
		end

		table.sort(var_3_2)
	end

	Imgui.begin_child_window("strings", 0, 0, true)
	Imgui.columns(2, true)

	for iter_3_2 = 1, #var_3_2 do
		local var_3_5, var_3_6 = string.match(var_3_2[iter_3_2], "^([^\t]+)\t(.*)$")

		Imgui.text(var_3_5)
		Imgui.next_column()
		Imgui.text(var_3_6)
		Imgui.next_column()
	end

	Imgui.columns(1)
	Imgui.end_child_window()
	Imgui.end_window()

	return var_3_0
end

ImguiStringScanner.is_persistent = function (arg_4_0)
	return false
end
