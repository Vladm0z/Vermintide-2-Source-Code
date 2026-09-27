-- chunkname: @scripts/imgui/imgui_localization.lua

ImguiLocalization = class(ImguiLocalization)

local tbl = {
	"br-pt",
	"de",
	"en",
	"es",
	"fr",
	"it",
	"pl",
	"ru",
	"zh"
}

ImguiLocalization.init = function (self)
	-- function 1
	self._text = ""
	self._cached_localizations = {}
	self._action_queue = {
		n = 0
	}
end

ImguiLocalization.update = function (self)
	-- function 2
	local remove = table.remove(self._action_queue)

	if not remove then
		remove()
	end
end

ImguiLocalization.action_push = function (self, arg_3_1)
	-- function 3
	local _action_queue = self._action_queue

	_action_queue.n = _action_queue.n + 1

	table.insert(_action_queue, 1, arg_3_1)
end

ImguiLocalization.draw = function (self)
	-- function 4
	local begin_window = Imgui.begin_window("Localization", "menu_bar")
	local language_id = Managers.localizer:language_id()
	local count = #self._action_queue
	local flag = count == 0

	if not Imgui.begin_menu_bar() then
		if not Imgui.menu_item("Save") then
			Managers.localizer:set_locale_override_setting(language_id)
		end

		if not Imgui.menu_item("Clear") then
			Managers.localizer:set_locale_override_setting(nil)
		end

		Imgui.end_menu_bar()
	end

	for i, v in ipairs(tbl) do
		local flag_2 = v == language_id

		if not Imgui.radio_button(v, flag_2) and not flag then
			Managers.localizer:_set_locale(v)
		end

		Imgui.same_line()
	end

	Imgui.same_line(20)
	Imgui.text("Locale override")
	Imgui.separator()

	local input_text = Imgui.input_text("Localize text", self._text)

	self._text = input_text

	local _action_queue = self._action_queue
	local _cached_localizations = self._cached_localizations

	if not Imgui.button("Localize") and not flag then
		_action_queue.n = 0

		local find = table.find(tbl, language_id)

		for i_2, v_2 in ipairs(tbl) do
			_cached_localizations[i_2] = "<>"

			if i_2 ~= find then
				self:action_push(NOP)
				self:action_push(function ()
					-- function 5
					Managers.localizer:_set_locale(v_2)
				end)
				self:action_push(NOP)
				self:action_push(function ()
					-- function 6
					local var_6_0 = Localize(input_text)

					self._cached_localizations[i_2] = var_6_0
				end)
			end
		end

		self:action_push(function ()
			-- function 7
			Managers.localizer:_set_locale(language_id)
		end)
		self:action_push(function ()
			-- function 8
			local var_8_0 = Localize(input_text)

			self._cached_localizations[find] = var_8_0
		end)
	end

	local progress_bar = Imgui.progress_bar
	local num

	if _action_queue.n > 0 then
		num = 1 - count / _action_queue.n

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_4_0::

	progress_bar(num)

	for i_3, v_3 in ipairs(tbl) do
		local var_4_11 = _cached_localizations[i_3]

		var_4_11 = var_4_11 or ""

		Imgui.text_colored(v_3, 200, 200, 200, 255)
		Imgui.same_line(50 - Imgui.calculate_text_size(v_3))

		if string.sub(var_4_11, 1, 1) == "<" then
			Imgui.text_colored(var_4_11, 255, 200, 200, 255)
		else
			Imgui.text(var_4_11)
		end
	end

	Imgui.separator()

	if not (not UnlocalizedStrings and table.is_empty(UnlocalizedStrings)) then
		Imgui.text("Unlocalized strings encountered so far:")
		Imgui.same_line()

		local button = Imgui.button("Copy to clipboard")

		Imgui.begin_child_window("UnlocalizedStrings", 0, 0, true)

		local keys = table.keys(UnlocalizedStrings)

		table.sort(keys)

		if not button then
			Clipboard.put(table.concat(keys, "\n"))
		end

		for i_4, v_4 in ipairs(keys) do
			if not Imgui.tree_node(v_4) then
				local text = Imgui.text
				local var_4_15 = UnlocalizedStrings[v_4]

				var_4_15 = var_4_15 or "?"

				text(var_4_15)
				Imgui.tree_pop()
			end
		end

		Imgui.end_child_window()
	end

	Imgui.end_window()

	return begin_window
end

ImguiLocalization.is_persistent = function (arg_9_0)
	-- function 9
	return false
end
