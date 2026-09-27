-- chunkname: @scripts/imgui/imgui_render_caps.lua

local tbl = {
	"d3d12",
	"dlss_supported",
	"dlss_g_supported",
	"reflex_supported",
	"use_deferred_contexts"
}

ImguiRenderCaps = class(ImguiRenderCaps)

ImguiRenderCaps.init = function (arg_1_0)
	-- function 1
	return
end

ImguiRenderCaps.update = function (arg_2_0)
	-- function 2
	return
end

local function fn(self, arg_3_1, arg_3_2)
	-- function 3
	for i = 1, #arg_3_1 do
		self[arg_3_1[i]] = arg_3_2
	end
end

ImguiRenderCaps.draw = function (arg_4_0)
	-- function 4
	local begin_window = Imgui.begin_window("Render Caps", "menu_bar")

	if not Imgui.begin_menu_bar() then
		local flag = false

		if not Imgui.menu_item("Save") then
			flag = true
		end

		if not Imgui.menu_item("Enable all") then
			fn(RENDER_CAPS_OVERRIDES, tbl, true)

			flag = true
		end

		if not Imgui.menu_item("Disable all") then
			fn(RENDER_CAPS_OVERRIDES, tbl, false)

			flag = true
		end

		if not Imgui.menu_item("Clear all") then
			table.clear(RENDER_CAPS_OVERRIDES)

			flag = true
		end

		if not flag then
			Application.set_user_setting("render_caps_overrides", RENDER_CAPS_OVERRIDES)
			Application.save_user_settings()
		end

		Imgui.end_menu_bar()
	end

	Imgui.begin_child_window("Caps", 0, 0, true)

	for i = 1, #tbl do
		local var_4_2 = tbl[i]

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

		if not Imgui.radio_button("false##" .. var_4_2, var_4_4 == false) then
			var_4_4 = false
		end

		Imgui.same_line()

		if not Imgui.radio_button("true##" .. var_4_2, var_4_4 == true) then
			var_4_4 = true
		end

		Imgui.same_line(30)

		if not Imgui.small_button("Clear##" .. var_4_2) then
			var_4_4 = nil
		end

		RENDER_CAPS_OVERRIDES[var_4_2] = var_4_4
	end

	Imgui.end_child_window()
	Imgui.end_window()

	return begin_window
end

ImguiRenderCaps.is_persistent = function (arg_5_0)
	-- function 5
	return false
end
