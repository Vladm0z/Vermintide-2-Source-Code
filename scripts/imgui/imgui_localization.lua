-- chunkname: @scripts/imgui/imgui_localization.lua

ImguiLocalization = class(ImguiLocalization)

local var_0_0 = {
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

function ImguiLocalization.init(arg_1_0)
	arg_1_0._text = ""
	arg_1_0._cached_localizations = {}
	arg_1_0._action_queue = {
		n = 0
	}
end

function ImguiLocalization.update(arg_2_0)
	local var_2_0 = table.remove(arg_2_0._action_queue)

	if var_2_0 then
		var_2_0()
	end
end

function ImguiLocalization.action_push(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._action_queue

	var_3_0.n = var_3_0.n + 1

	table.insert(var_3_0, 1, arg_3_1)
end

function ImguiLocalization.draw(arg_4_0)
	local var_4_0 = Imgui.begin_window("Localization", "menu_bar")
	local var_4_1 = Managers.localizer:language_id()
	local var_4_2 = #arg_4_0._action_queue
	local var_4_3 = var_4_2 == 0

	if Imgui.begin_menu_bar() then
		if Imgui.menu_item("Save") then
			Managers.localizer:set_locale_override_setting(var_4_1)
		end

		if Imgui.menu_item("Clear") then
			Managers.localizer:set_locale_override_setting(nil)
		end

		Imgui.end_menu_bar()
	end

	for iter_4_0, iter_4_1 in ipairs(var_0_0) do
		local var_4_4 = iter_4_1 == var_4_1

		if Imgui.radio_button(iter_4_1, var_4_4) and var_4_3 then
			Managers.localizer:_set_locale(iter_4_1)
		end

		Imgui.same_line()
	end

	Imgui.same_line(20)
	Imgui.text("Locale override")
	Imgui.separator()

	local var_4_5 = Imgui.input_text("Localize text", arg_4_0._text)

	arg_4_0._text = var_4_5

	local var_4_6 = arg_4_0._action_queue
	local var_4_7 = arg_4_0._cached_localizations

	if Imgui.button("Localize") and var_4_3 then
		var_4_6.n = 0

		local var_4_8 = table.find(var_0_0, var_4_1)

		for iter_4_2, iter_4_3 in ipairs(var_0_0) do
			var_4_7[iter_4_2] = "<>"

			if iter_4_2 ~= var_4_8 then
				arg_4_0:action_push(NOP)
				arg_4_0:action_push(function()
					Managers.localizer:_set_locale(iter_4_3)
				end)
				arg_4_0:action_push(NOP)
				arg_4_0:action_push(function()
					local var_6_0 = Localize(var_4_5)

					arg_4_0._cached_localizations[iter_4_2] = var_6_0
				end)
			end
		end

		arg_4_0:action_push(function()
			Managers.localizer:_set_locale(var_4_1)
		end)
		arg_4_0:action_push(function()
			local var_8_0 = Localize(var_4_5)

			arg_4_0._cached_localizations[var_4_8] = var_8_0
		end)
	end

	Imgui.progress_bar(var_4_6.n > 0 and 1 - var_4_2 / var_4_6.n or 0)

	for iter_4_4, iter_4_5 in ipairs(var_0_0) do
		local var_4_9 = var_4_7[iter_4_4] or ""

		Imgui.text_colored(iter_4_5, 200, 200, 200, 255)
		Imgui.same_line(50 - Imgui.calculate_text_size(iter_4_5))

		if string.sub(var_4_9, 1, 1) == "<" then
			Imgui.text_colored(var_4_9, 255, 200, 200, 255)
		else
			Imgui.text(var_4_9)
		end
	end

	Imgui.separator()

	if UnlocalizedStrings and not table.is_empty(UnlocalizedStrings) then
		Imgui.text("Unlocalized strings encountered so far:")
		Imgui.same_line()

		local var_4_10 = Imgui.button("Copy to clipboard")

		Imgui.begin_child_window("UnlocalizedStrings", 0, 0, true)

		local var_4_11 = table.keys(UnlocalizedStrings)

		table.sort(var_4_11)

		if var_4_10 then
			Clipboard.put(table.concat(var_4_11, "\n"))
		end

		for iter_4_6, iter_4_7 in ipairs(var_4_11) do
			if Imgui.tree_node(iter_4_7) then
				Imgui.text(UnlocalizedStrings[iter_4_7] or "?")
				Imgui.tree_pop()
			end
		end

		Imgui.end_child_window()
	end

	Imgui.end_window()

	return var_4_0
end

function ImguiLocalization.is_persistent(arg_9_0)
	return false
end
