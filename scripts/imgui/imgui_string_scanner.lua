-- chunkname: @scripts/imgui/imgui_string_scanner.lua

ImguiStringScanner = class(ImguiStringScanner)

ImguiStringScanner.init = function (self)
	-- function 1
	self._results = {}
	self._query = ""
end

ImguiStringScanner.update = function (arg_2_0, arg_2_1)
	-- function 2
	return
end

ImguiStringScanner.draw = function (self)
	-- function 3
	local begin_window = Imgui.begin_window("String Scanner")

	if not rawget(Script, "string_scan") then
		Imgui.text("Required engine functionality is not available.")
		Imgui.end_window()

		return begin_window
	end

	local input_text = Imgui.input_text("Query", self._query)

	self._query = input_text

	local _results = self._results

	if not Imgui.button("Run search") then
		local string_scan = Script.string_scan()

		table.clear(_results)

		local lower = string.lower(input_text)

		for k, v in pairs(string_scan) do
			k = string.lower(k)

			if not string.find(k, lower) then
				_results[#_results + 1] = k .. "\t" .. v
			end
		end

		table.sort(_results)
	end

	Imgui.begin_child_window("strings", 0, 0, true)
	Imgui.columns(2, true)

	for k_2 = 1, #_results do
		local match, var_3_6 = string.match(_results[k_2], "^([^\t]+)\t(.*)$")

		Imgui.text(match)
		Imgui.next_column()
		Imgui.text(var_3_6)
		Imgui.next_column()
	end

	Imgui.columns(1)
	Imgui.end_child_window()
	Imgui.end_window()

	return begin_window
end

ImguiStringScanner.is_persistent = function (arg_4_0)
	-- function 4
	return false
end
