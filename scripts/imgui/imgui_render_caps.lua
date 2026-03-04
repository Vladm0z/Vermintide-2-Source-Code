-- chunkname: @scripts/imgui/imgui_render_caps.lua

local var_0_0 = {
	"d3d12",
	"dlss_supported",
	"dlss_g_supported",
	"reflex_supported",
	"use_deferred_contexts"
}

ImguiRenderCaps = class(ImguiRenderCaps)

ImguiRenderCaps.init = function (arg_1_0)
	return
end

ImguiRenderCaps.update = function (arg_2_0)
	return
end

local function var_0_1(arg_3_0, arg_3_1, arg_3_2)
	for iter_3_0 = 1, #arg_3_1 do
		arg_3_0[arg_3_1[iter_3_0]] = arg_3_2
	end
end

ImguiRenderCaps.draw = function (arg_4_0)
	local var_4_0 = Imgui.begin_window("Render Caps", "menu_bar")

	if Imgui.begin_menu_bar() then
		local var_4_1 = false

		if Imgui.menu_item("Save") then
			var_4_1 = true
		end

		if Imgui.menu_item("Enable all") then
			var_0_1(RENDER_CAPS_OVERRIDES, var_0_0, true)

			var_4_1 = true
		end

		if Imgui.menu_item("Disable all") then
			var_0_1(RENDER_CAPS_OVERRIDES, var_0_0, false)

			var_4_1 = true
		end

		if Imgui.menu_item("Clear all") then
			table.clear(RENDER_CAPS_OVERRIDES)

			var_4_1 = true
		end

		if var_4_1 then
			Application.set_user_setting("render_caps_overrides", RENDER_CAPS_OVERRIDES)
			Application.save_user_settings()
		end

		Imgui.end_menu_bar()
	end

	Imgui.begin_child_window("Caps", 0, 0, true)

	for iter_4_0 = 1, #var_0_0 do
		local var_4_2 = var_0_0[iter_4_0]

		Imgui.text(var_4_2 .. ":")
		Imgui.same_line()

		local var_4_3 = Application_render_caps(var_4_2)

		if var_4_3 == true then
			Imgui.text_colored("true", 0, 255, 0, 255)
		elseif var_4_3 == false then
			Imgui.text_colored("false", 255, 0, 0, 255)
		elseif var_4_3 == nil then
			Imgui.text_colored("nil", 127, 127, 127, 255)
		end

		Imgui.same_line(360 - Imgui.calculate_text_size(var_4_2 .. ":" .. tostring(var_4_3)))

		local var_4_4 = RENDER_CAPS_OVERRIDES[var_4_2]

		if Imgui.radio_button("false##" .. var_4_2, var_4_4 == false) then
			var_4_4 = false
		end

		Imgui.same_line()

		if Imgui.radio_button("true##" .. var_4_2, var_4_4 == true) then
			var_4_4 = true
		end

		Imgui.same_line(30)

		if Imgui.small_button("Clear##" .. var_4_2) then
			var_4_4 = nil
		end

		RENDER_CAPS_OVERRIDES[var_4_2] = var_4_4
	end

	Imgui.end_child_window()
	Imgui.end_window()

	return var_4_0
end

ImguiRenderCaps.is_persistent = function (arg_5_0)
	return false
end
