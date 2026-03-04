-- chunkname: @scripts/imgui/imgui_ui_tool.lua

ImguiUITool = class(ImguiUITool)

local var_0_0 = Gui
local var_0_1 = Imgui
local var_0_2 = string.format

local function var_0_3(arg_1_0)
	return Vector2(arg_1_0[1], arg_1_0[2])
end

local function var_0_4(arg_2_0)
	return Color(arg_2_0[1], arg_2_0[2], arg_2_0[3], arg_2_0[4])
end

local function var_0_5(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0[1] = arg_3_1
	arg_3_0[2] = arg_3_2

	return arg_3_0
end

local var_0_6 = select
local var_0_7 = string.find

local function var_0_8(arg_4_0, ...)
	for iter_4_0 = 1, var_0_6("#", ...) do
		local var_4_0, var_4_1, var_4_2 = pcall(var_0_7, var_0_6(iter_4_0, ...), arg_4_0)

		if not var_4_0 then
			return false
		elseif var_4_1 then
			return var_4_1, var_4_2
		end
	end
end

ImguiUITool.init = function (arg_5_0)
	arg_5_0._active = false
	arg_5_0._draw_ruler = false
	arg_5_0._draw_canvas = false
	arg_5_0._ruler_color = {
		64,
		255,
		0,
		0
	}
	arg_5_0._highlight_textures = true
	arg_5_0._drawing_rect = false
	arg_5_0._hide_ui = false
	arg_5_0._disable_localization = not not script_data.disable_localization
	arg_5_0._rect_x, arg_5_0._rect_y = 0, 0
	arg_5_0._data_buffer = {}
	arg_5_0._data_back_buffer = {}
	arg_5_0._search = ""
	arg_5_0._cursor = {
		0,
		0,
		0
	}
	arg_5_0._scale = 1
	arg_5_0._offset = {
		0,
		0
	}
	arg_5_0._tabs = {
		"Render objects",
		"Scenegraph",
		"Atlas browser",
		"Settings",
		"Help"
	}
	arg_5_0._selected_tab = arg_5_0._tabs[1]
end

local var_0_9 = true

ImguiUITool.update = function (arg_6_0)
	if var_0_9 then
		arg_6_0:init()
		arg_6_0:on_hide()
		arg_6_0:on_show()

		var_0_9 = false
	end

	if arg_6_0._active then
		arg_6_0._data_buffer, arg_6_0._data_back_buffer = arg_6_0._data_back_buffer, arg_6_0._data_buffer

		table.clear(arg_6_0._data_back_buffer)
	end

	local var_6_0 = Mouse.axis(Mouse.axis_id("cursor"))
	local var_6_1 = 1920
	local var_6_2 = 1080
	local var_6_3, var_6_4 = var_0_0.resolution()
	local var_6_5 = math.min(var_6_3 / var_6_1, var_6_4 / var_6_2)
	local var_6_6 = 0.5 * (var_6_3 - var_6_1 * var_6_5)
	local var_6_7 = 0.5 * (var_6_4 - var_6_2 * var_6_5)
	local var_6_8 = var_0_5(arg_6_0._cursor, var_6_0[1], var_6_0[2])

	arg_6_0._scale = var_6_5

	var_0_5(arg_6_0._offset, var_6_6, var_6_7)

	local var_6_9 = arg_6_0:get_gui()

	if not var_6_9 then
		return
	end

	if arg_6_0._draw_canvas then
		local var_6_10 = Color(32, 255, 0, 255)

		var_0_0.rect(var_6_9, Vector3(0, 0, 999), Vector2(var_6_6, var_6_4), var_6_10)
		var_0_0.rect(var_6_9, Vector3(var_6_3, 0, 999), Vector2(-var_6_6, var_6_4), var_6_10)
		var_0_0.rect(var_6_9, Vector3(var_6_6, 0, 999), Vector2(var_6_3 - var_6_6, var_6_7), var_6_10)
		var_0_0.rect(var_6_9, Vector3(var_6_6, var_6_4, 999), Vector2(var_6_3 - var_6_6, -var_6_7), var_6_10)
	end

	if arg_6_0._selected_tab ~= "Atlas browser" then
		if arg_6_0._draw_ruler then
			var_0_0.rect(var_6_9, Vector3(var_6_8[1], 0, 1000), Vector2(1, var_6_4))
			var_0_0.rect(var_6_9, Vector3(0, var_6_8[2], 1000), Vector2(var_6_3, 1))
		end

		local var_6_11 = Mouse.button_index("right")

		if Mouse.pressed(var_6_11) then
			arg_6_0._drawing_rect = true
			arg_6_0._rect_x, arg_6_0._rect_y = var_6_8[1], var_6_8[2]
		elseif Mouse.released(var_6_11) then
			arg_6_0._drawing_rect = false
		end

		if arg_6_0._drawing_rect then
			var_0_0.rect(var_6_9, Vector3(arg_6_0._rect_x, arg_6_0._rect_y, 1000), Vector2(var_6_8[1] - arg_6_0._rect_x, var_6_8[2] - arg_6_0._rect_y), var_0_4(arg_6_0._ruler_color))
		end
	end
end

local var_0_10 = {
	255,
	255,
	255,
	255
}
local var_0_11 = 2

local function var_0_12(arg_7_0, arg_7_1, arg_7_2)
	return arg_7_1[1] - var_0_11 <= arg_7_0[1] and arg_7_0[1] <= arg_7_1[1] + arg_7_2[1] + var_0_11 and arg_7_1[2] - var_0_11 <= arg_7_0[2] and arg_7_0[2] <= arg_7_1[2] + arg_7_2[2] + var_0_11
end

local function var_0_13(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_2[1]
	local var_8_1 = arg_8_2[2] - 2 * var_0_11

	var_0_0.rect(arg_8_0, Vector3(arg_8_1[1], arg_8_1[2], arg_8_1[3]), Vector2(var_8_0, arg_8_3), arg_8_4)
	var_0_0.rect(arg_8_0, Vector3(arg_8_1[1], arg_8_1[2] + arg_8_2[2] - arg_8_3, arg_8_1[3]), Vector2(var_8_0, arg_8_3), arg_8_4)
	var_0_0.rect(arg_8_0, Vector3(arg_8_1[1], arg_8_1[2] + arg_8_3, arg_8_1[3]), Vector2(arg_8_3, var_8_1), arg_8_4)
	var_0_0.rect(arg_8_0, Vector3(arg_8_1[1] + arg_8_2[1] - arg_8_3, arg_8_1[2] + arg_8_3, arg_8_1[3]), Vector2(arg_8_3, var_8_1), arg_8_4)
end

ImguiUITool.draw_border = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_0:get_gui()

	if not var_9_0 or not arg_9_0._highlight_textures then
		return
	end

	arg_9_1 = arg_9_1 + Vector3(0, 0, 1)

	return var_0_13(var_9_0, arg_9_1, arg_9_2, var_0_11, arg_9_3)
end

ImguiUITool.draw_label = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0:get_gui()

	if not var_10_0 or not arg_10_0._highlight_textures then
		return
	end

	var_0_0.text(var_10_0, arg_10_1, "materials/fonts/arial", 16, nil, arg_10_2 + Vector2(var_0_11 + 2, var_0_11 + 2), arg_10_3)
end

ImguiUITool.texture = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	if not var_0_8(arg_11_0._search, arg_11_1, arg_11_2) then
		return
	end

	local var_11_0 = var_0_12(arg_11_0._cursor, arg_11_3, arg_11_4)

	if var_11_0 then
		arg_11_5 = arg_11_5 or var_0_10

		local var_11_1 = arg_11_0._data_back_buffer
		local var_11_2 = UIAtlasHelper._ui_atlas_settings[arg_11_2]

		var_11_1[#var_11_1 + 1] = arg_11_1
		var_11_1[#var_11_1 + 1] = tostring(arg_11_2)
		var_11_1[#var_11_1 + 1] = var_11_2 and var_11_2.material_name or "n/a"
		var_11_1[#var_11_1 + 1] = var_0_2("Vector3(%d, %d, %d)", arg_11_3[1], arg_11_3[2], arg_11_3[3])
		var_11_1[#var_11_1 + 1] = var_0_2("Vector2(%d, %d)", arg_11_4[1], arg_11_4[2])
		var_11_1[#var_11_1 + 1] = var_0_2("Color(%d, %d, %d, %d)", arg_11_5[1], arg_11_5[2], arg_11_5[3], arg_11_5[4])
	end

	local var_11_3
	local var_11_4 = var_11_0 and 200 or 30

	if arg_11_1 == "rect" or arg_11_1 == "rounded_rect" then
		var_11_3 = Color(var_11_4, 0, 255, 0)
	elseif arg_11_1 == "bitmap" then
		var_11_3 = Color(var_11_4, 255, 0, 0)
	elseif arg_11_1 == "bitmap_uv" then
		var_11_3 = Color(var_11_4, 255, 0, 155)
	end

	arg_11_0:draw_border(Vector3(arg_11_3[1], arg_11_3[2], 999), Vector2(arg_11_4[1], arg_11_4[2]), var_11_3)
end

ImguiUITool.text = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	if not var_0_8(arg_12_0._search, arg_12_2, arg_12_3) then
		return
	end

	local var_12_0, var_12_1, var_12_2 = var_0_0.text_extents(arg_12_1.gui, arg_12_2, arg_12_3, arg_12_4)
	local var_12_3 = var_12_1 - var_12_0

	arg_12_5 = arg_12_5 + var_12_0

	local var_12_4 = var_0_12(arg_12_0._cursor, arg_12_5, var_12_3)

	if var_12_4 then
		arg_12_6 = arg_12_6 or var_0_10

		local var_12_5 = arg_12_0._data_back_buffer

		var_12_5[#var_12_5 + 1] = "text"
		var_12_5[#var_12_5 + 1] = var_0_2("%10q", arg_12_2)
		var_12_5[#var_12_5 + 1] = arg_12_3
		var_12_5[#var_12_5 + 1] = var_0_2("Vector3(%d, %d, %d)", arg_12_5[1], arg_12_5[2], arg_12_5[3])
		var_12_5[#var_12_5 + 1] = var_0_2("%d / Vector2(%d, %d)", arg_12_4, var_12_3[1], var_12_3[2])
		var_12_5[#var_12_5 + 1] = var_0_2("Color(%d, %d, %d, %d)", arg_12_6[1], arg_12_6[2], arg_12_6[3], arg_12_6[4])
	end

	arg_12_0:draw_border(Vector3(arg_12_5[1], arg_12_5[2], 999), Vector2(var_12_3[1], var_12_3[2]), Color(var_12_4 and 200 or 30, 0, 100, 255))
end

ImguiUITool.node = function (arg_13_0, arg_13_1, arg_13_2)
	if not var_0_8(arg_13_0._search, arg_13_1.name or "n/a", arg_13_2) then
		return
	end

	local var_13_0 = arg_13_0._scale
	local var_13_1 = arg_13_1.world_position
	local var_13_2 = arg_13_1.size
	local var_13_3 = Vector3(var_13_1[1] * var_13_0, var_13_1[2] * var_13_0, var_13_1[3] * var_13_0)
	local var_13_4 = Vector2(var_13_2[1] * var_13_0, var_13_2[2] * var_13_0)
	local var_13_5 = var_0_12(arg_13_0._cursor, var_13_3, var_13_4)

	if var_13_5 then
		local var_13_6 = arg_13_0._data_back_buffer

		var_13_6[#var_13_6 + 1] = arg_13_2 or "n/a"
		var_13_6[#var_13_6 + 1] = arg_13_1.name

		if arg_13_1.parent then
			var_13_6[#var_13_6 + 1] = arg_13_1.parent
			var_13_6[#var_13_6 + 1] = var_0_2("%s / %s", arg_13_1.horizontal_alignment or "left", arg_13_1.vertical_alignment or "bottom")
		else
			var_13_6[#var_13_6 + 1] = "n/a"
			var_13_6[#var_13_6 + 1] = "n/a"
		end

		var_13_6[#var_13_6 + 1] = var_0_2("Vector3(%d, %d, %d)", var_13_1[1], var_13_1[2], var_13_1[3])
		var_13_6[#var_13_6 + 1] = var_0_2("Vector2(%d, %d)", var_13_2[1], var_13_2[2])

		arg_13_0:draw_label(arg_13_1.name, Vector3(var_13_3[1], var_13_3[2], 999), Color(var_13_5 and 200 or 55, 100, 100, 255))
	end

	arg_13_0:draw_border(Vector3(var_13_3[1], var_13_3[2], 999), var_13_4, Color(var_13_5 and 200 or 55, 100, 100, 255))

	return var_13_5
end

ImguiUITool.scenegraph = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_2 or arg_14_3 then
		return
	end

	local var_14_0 = debug.getinfo(4, "S")
	local var_14_1 = var_14_0 and var_14_0.short_src and string.match(var_14_0.short_src, "/([^/]+)%.lua$")
	local var_14_2 = false

	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		if type(iter_14_0) ~= "number" and arg_14_0:node(iter_14_1, var_14_1) then
			var_14_2 = true
		end
	end

	if var_14_2 then
		table.insert(arg_14_0._data_back_buffer, false)
	end
end

ImguiUITool.on_show = function (arg_15_0)
	Debug.hook(UIRenderer, "script_draw_bitmap", function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
		if arg_15_0._active and arg_15_0._selected_tab == "Render objects" then
			arg_15_0:texture("bitmap", arg_16_3, arg_16_4, arg_16_5, arg_16_6)
		end

		if arg_15_0._hide_ui then
			return
		end

		return arg_16_0(arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	end)
	Debug.hook(UIRenderer, "script_draw_bitmap_uv", function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
		if arg_15_0._active and arg_15_0._selected_tab == "Render objects" then
			arg_15_0:texture("bitmap_uv", arg_17_3, arg_17_5, arg_17_6, arg_17_7)
		end

		if arg_15_0._hide_ui then
			return
		end

		return arg_17_0(arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
	end)
	Debug.hook(UIRenderer, "draw_rect", function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
		if arg_15_0._active and arg_15_0._selected_tab == "Render objects" then
			arg_15_0:texture("rect", "n/a", UIScaleVectorToResolution(arg_18_2), UIScaleVectorToResolution(arg_18_3), arg_18_4)
		end

		if arg_15_0._hide_ui then
			return
		end

		return arg_18_0(arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	end)
	Debug.hook(UIRenderer, "draw_rounded_rect", function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
		if arg_15_0._active and arg_15_0._selected_tab == "Render objects" then
			arg_15_0:texture("rounded_rect", "n/a", UIScaleVectorToResolution(arg_19_2), UIScaleVectorToResolution(arg_19_3), arg_19_5)
		end

		if arg_15_0._hide_ui then
			return
		end

		return arg_19_0(arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	end)
	Debug.hook(UIRenderer, "draw_text", function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
		if arg_15_0._active and arg_15_0._selected_tab == "Render objects" then
			arg_15_0:text(arg_20_1, arg_20_2, arg_20_3, arg_20_4, UIScaleVectorToResolution(arg_20_6), arg_20_7)
		end

		if arg_15_0._hide_ui then
			return
		end

		return arg_20_0(arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
	end)
	Debug.hook(UISceneGraph, "update_scenegraph", function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		if arg_15_0._active and arg_15_0._selected_tab == "Scenegraph" then
			arg_15_0:scenegraph(arg_21_1, arg_21_2, arg_21_3)
		end

		return arg_21_0(arg_21_1, arg_21_2, arg_21_3)
	end)

	arg_15_0._active = true
end

ImguiUITool.on_hide = function (arg_22_0)
	Debug.unhook(UIRenderer, "script_draw_bitmap", true)
	Debug.unhook(UIRenderer, "script_draw_bitmap_uv", true)
	Debug.unhook(UIRenderer, "draw_rect", true)
	Debug.unhook(UIRenderer, "draw_text", true)

	arg_22_0._active = false
end

ImguiUITool.get_gui = function (arg_23_0)
	if arg_23_0._gui then
		return arg_23_0._gui
	end

	if not Managers.world then
		return
	end

	local var_23_0 = Managers.world:world("top_ingame_view")

	if not var_23_0 then
		return
	end

	arg_23_0._gui = World.create_screen_gui(var_23_0, "immediate")
end

ImguiUITool._set_columns = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	var_0_1.columns(arg_24_1, not not arg_24_2)

	if not arg_24_3 then
		return
	end

	if type(arg_24_3) == "table" then
		for iter_24_0, iter_24_1 in ipairs(arg_24_3) do
			var_0_1.set_column_width(iter_24_1, iter_24_0 - 1)
		end
	else
		for iter_24_2 = 0, arg_24_1 - 1 do
			var_0_1.set_column_width(arg_24_3, iter_24_2)
		end
	end
end

ImguiUITool.do_render_objects = function (arg_25_0)
	arg_25_0:_set_columns(6, true)
	var_0_1.text("Type")
	var_0_1.next_column()
	var_0_1.text("Texture/String")
	var_0_1.next_column()
	var_0_1.text("Material/Font")
	var_0_1.next_column()
	var_0_1.text("Position")
	var_0_1.next_column()
	var_0_1.text("(Font) size")
	var_0_1.next_column()
	var_0_1.text("Color")
	var_0_1.next_column()
	var_0_1.separator()

	local var_25_0 = arg_25_0._data_buffer

	for iter_25_0 = 1, #var_25_0 do
		local var_25_1 = var_25_0[iter_25_0]
		local var_25_2 = iter_25_0 % 6

		if var_25_2 == 1 then
			if var_25_1 == "rect" or var_25_1 == "rounded_rect" then
				var_0_1.text_colored(var_25_1, 0, 255, 0, 255)
			elseif var_25_1 == "bitmap" then
				var_0_1.text_colored(var_25_1, 255, 0, 0, 255)
			elseif var_25_1 == "bitmap_uv" then
				var_0_1.text_colored(var_25_1, 255, 0, 155, 255)
			elseif var_25_1 == "text" then
				var_0_1.text_colored(var_25_1, 0, 100, 255, 255)
			else
				var_0_1.text(var_25_1)
			end
		elseif var_25_2 == 0 then
			local var_25_3, var_25_4, var_25_5, var_25_6 = string.match(var_25_1, "(%d+), (%d+), (%d+), (%d+)")

			var_0_1.color_edit_4("##" .. iter_25_0, var_25_4 / 255, var_25_5 / 255, var_25_6 / 255, var_25_3 / 255)
		else
			var_0_1.text(var_25_1)
		end

		var_0_1.next_column()
	end

	arg_25_0:_set_columns(1)
end

ImguiUITool.do_scenegraph = function (arg_26_0)
	arg_26_0:_set_columns(6, true)
	var_0_1.text("File")
	var_0_1.next_column()
	var_0_1.text("Name")
	var_0_1.next_column()
	var_0_1.text("Parent")
	var_0_1.next_column()
	var_0_1.text("Alignment")
	var_0_1.next_column()
	var_0_1.text("Position")
	var_0_1.next_column()
	var_0_1.text("Size")
	var_0_1.next_column()
	var_0_1.separator()

	local var_26_0 = arg_26_0._data_buffer

	for iter_26_0 = 1, #var_26_0 do
		local var_26_1 = var_26_0[iter_26_0]

		if var_26_1 ~= false then
			var_0_1.text(var_26_1)
			var_0_1.next_column()
		else
			var_0_1.separator()
		end
	end

	arg_26_0:_set_columns(1)
end

local function var_0_14(arg_27_0)
	return arg_27_0.texture_name
end

local function var_0_15(arg_28_0)
	return arg_28_0.material_name
end

local function var_0_16(arg_29_0)
	local var_29_0 = arg_29_0.size

	return var_29_0[1] * var_29_0[2]
end

local function var_0_17(arg_30_0, arg_30_1, arg_30_2)
	var_0_1.same_line()

	if var_0_1.small_button("^##ASC_" .. arg_30_2) then
		table.sort(arg_30_0, function (arg_31_0, arg_31_1)
			return arg_30_1(arg_31_0) < arg_30_1(arg_31_1)
		end)
		printf("[ImguiUITool] Sorted by %s in ASC order", arg_30_2)
	end

	var_0_1.same_line()

	if var_0_1.small_button("v##DESC_" .. arg_30_2) then
		table.sort(arg_30_0, function (arg_32_0, arg_32_1)
			return arg_30_1(arg_32_0) > arg_30_1(arg_32_1)
		end)
		printf("[ImguiUITool] Sorted by %s in DESC order", arg_30_2)
	end
end

ImguiUITool.do_asset_browser = function (arg_33_0)
	local var_33_0 = arg_33_0._texture_registry

	if not var_33_0 then
		var_33_0 = table.values(UIAtlasHelper._ui_atlas_settings)
		arg_33_0._texture_registry = var_33_0
		arg_33_0._asset_browser_offset = 0
	end

	arg_33_0:_set_columns(3, true)
	var_0_1.text("Texture")
	var_0_17(var_33_0, var_0_14, "1")
	var_0_1.next_column()
	var_0_1.text("Material")
	var_0_17(var_33_0, var_0_15, "2")
	var_0_1.next_column()
	var_0_1.text("Size")
	var_0_17(var_33_0, var_0_16, "3")
	var_0_1.next_column()
	var_0_1.separator()

	local var_33_1 = Vector2(50, 50)
	local var_33_2 = arg_33_0._cursor
	local var_33_3, var_33_4 = var_0_0.resolution()
	local var_33_5 = math.floor(var_33_3 / var_33_1[1])
	local var_33_6 = arg_33_0._search
	local var_33_7 = 50
	local var_33_8 = Mouse.axis_index("wheel")

	if Vector3.y(Mouse.axis(var_33_8)) > 0 then
		arg_33_0._asset_browser_offset = math.min(var_33_1[2], arg_33_0._asset_browser_offset + var_33_7)
	elseif Vector3.y(Mouse.axis(var_33_8)) < 0 then
		arg_33_0._asset_browser_offset = arg_33_0._asset_browser_offset - var_33_7
	elseif Mouse.button(Mouse.button_index("middle")) > 0.5 then
		arg_33_0._scroll_hold_pos = arg_33_0._scroll_hold_pos or Vector3Box(Vector3Aux.unbox(var_33_2))
		arg_33_0._asset_browser_offset = arg_33_0._asset_browser_offset + (Vector3Aux.unbox(var_33_2)[2] - arg_33_0._scroll_hold_pos:unbox()[2])
		arg_33_0._asset_browser_offset = math.clamp(arg_33_0._asset_browser_offset, var_33_1[2] * (-math.ceil(#table.select_array(var_33_0, function (arg_34_0, arg_34_1)
			return var_0_8(var_33_6, arg_34_1.texture_name, arg_34_1.material_name)
		end) / var_33_5) - 1) + var_33_4, var_33_1[2])
	elseif arg_33_0._scroll_hold_pos then
		arg_33_0._scroll_hold_pos = nil
	end

	local var_33_9 = Managers.ui._ingame_ui
	local var_33_10 = var_33_9 and var_33_9.ui_top_renderer.gui
	local var_33_11 = 0

	for iter_33_0 = 1, #var_33_0 do
		local var_33_12 = var_33_0[iter_33_0]
		local var_33_13 = var_33_12.texture_name
		local var_33_14 = var_33_12.material_name

		if var_0_8(var_33_6, var_33_13, var_33_14) then
			local var_33_15 = var_33_12.size
			local var_33_16 = false

			if var_33_10 then
				var_33_11 = var_33_11 + 1

				local var_33_17 = var_33_5 - 1 - var_33_11 % var_33_5
				local var_33_18 = math.ceil(var_33_11 / var_33_5)
				local var_33_19 = Vector3(var_33_1[1] * var_33_17, var_33_4 - var_33_1[2] * var_33_18 - arg_33_0._asset_browser_offset, 950)

				var_33_16 = math.point_is_inside_2d_box(var_33_2, var_33_19, var_33_1)

				if var_0_0.material(var_33_10, var_33_14) then
					local var_33_20 = math.min(var_33_1[1] / var_33_15[1], var_33_1[2] / var_33_15[2], 1)
					local var_33_21 = Vector2(var_33_15[1] * var_33_20, var_33_15[2] * var_33_20)
					local var_33_22 = var_33_19 + 0.5 * (var_33_1 - var_33_21)

					var_0_0.rect(var_33_10, var_33_19, var_33_1, Color(127, 127, 127))
					var_0_0.bitmap_uv(var_33_10, var_33_14, var_0_3(var_33_12.uv00), var_0_3(var_33_12.uv11), var_33_22, var_33_21)

					if var_33_16 then
						var_0_13(var_33_10, var_33_19 + Vector3(0, 0, 1), var_33_1, var_0_11, Color(255, 0, 0))
					end
				else
					var_0_0.rect(var_33_10, var_33_19, var_33_1, Color(255, 192, 203))
					var_0_0.text(var_33_10, "No material", "materials/fonts/arial", 7.5, nil, var_33_19 + Vector2(0, 0.5 * (var_33_1[2] - 18)), var_33_1, Color(0, 0, 0))
				end
			end

			if var_33_16 then
				var_0_1.text_colored(var_33_13, 255, 0, 0, 255)
				var_0_1.set_scroll_here()

				local var_33_23 = math.min((var_33_4 - var_33_15[2]) * 0.5, 100)

				if var_33_2[2] < var_33_4 * 0.25 then
					var_33_23 = math.max((var_33_4 - var_33_15[2]) * 0.5, var_33_4 - var_33_15[2] - 100)
				end

				local var_33_24 = Vector3((var_33_3 - var_33_15[1]) * 0.5, var_33_23, 960)
				local var_33_25 = var_0_3(var_33_15)
				local var_33_26 = Vector2(10, 10)

				var_0_0.bitmap(var_33_10, "marching_ants", var_33_24 - var_33_26 - Vector3(0, 0, 1), var_33_25 + 2 * var_33_26, Color(255, 0, 0))
				var_0_0.rect(var_33_10, var_33_24 - var_33_26 - Vector3(0, 0, 2), var_33_25 + 2 * var_33_26, Color(0, 0, 0))
				var_0_0.rect(var_33_10, var_33_24, var_33_25, Color(127, 127, 127))

				if var_0_0.material(var_33_10, var_33_14) then
					var_0_0.bitmap_uv(var_33_10, var_33_14, var_0_3(var_33_12.uv00), var_0_3(var_33_12.uv11), var_33_24, var_33_25)
				else
					var_0_0.rect(var_33_10, var_33_24, var_33_25, Color(255, 192, 203))
					var_0_0.text(var_33_10, "No material", "materials/fonts/arial", 7.5, nil, var_33_24 + Vector2(0, 0.5 * (var_33_25[2] - 18)), var_33_25, Color(0, 0, 0))
				end

				local var_33_27 = var_33_13
				local var_33_28 = Managers.time:time("main")

				if var_33_28 < (arg_33_0._copied_t or 0) and arg_33_0._copied_text == var_33_13 then
					var_33_27 = var_33_27 .. " (Copied!)           "
				else
					var_33_27 = var_33_27 .. " (Left click to copy)"
				end

				local var_33_29 = var_0_1.calculate_text_size(var_33_27)
				local var_33_30 = var_33_24 - Vector3(var_33_29 * 0.5 - var_33_15[1] * 0.5, 25, 0)

				var_0_0.rect(var_33_10, var_33_30 - Vector2(5, 7), Vector2(var_33_29, 22), Color(0, 0, 0))
				var_0_0.text(var_33_10, var_33_27, "materials/fonts/arial", 14, nil, var_33_30, Color(255, 255, 255, 255))

				if Mouse.pressed(Mouse.button_index("left")) then
					printf("[ImguiUITool] Copied %s to clipboard", var_33_13)
					Clipboard.put(var_33_13)

					arg_33_0._copied_t = var_33_28 + 1.5
					arg_33_0._copied_text = var_33_13
				end
			end

			var_0_1.next_column()
			var_0_1.text(var_33_14)
			var_0_1.next_column()
			var_0_1.text(var_0_2("%4d x %4d", var_33_15[1], var_33_15[2]))
			var_0_1.next_column()
		end
	end

	arg_33_0:_set_columns(1)
end

ImguiUITool._setting_checkbox = function (arg_35_0, arg_35_1, arg_35_2)
	if var_0_8(arg_35_0._search, arg_35_2) then
		arg_35_0[arg_35_1] = var_0_1.checkbox(arg_35_2, arg_35_0[arg_35_1] or false)
	end
end

ImguiUITool._setting_color = function (arg_36_0, arg_36_1, arg_36_2)
	if var_0_8(arg_36_0._search, arg_36_2) then
		local var_36_0 = arg_36_0[arg_36_1] or {
			255,
			255,
			255,
			255
		}

		Colors.set(var_36_0, ImguiX.color_edit_4(arg_36_2, unpack(var_36_0)))

		arg_36_0[arg_36_1] = var_36_0
	end
end

ImguiUITool.do_settings = function (arg_37_0)
	var_0_1.text("Settings")
	var_0_1.separator()
	arg_37_0:_setting_checkbox("_draw_ruler", "Draw ruler crosshair")
	arg_37_0:_setting_checkbox("_draw_canvas", "Draw canvas margins")
	arg_37_0:_setting_checkbox("_disable_localization", "Disable localization")
	arg_37_0:_setting_checkbox("_hide_ui", "Hide immediate-mode UIs")
	arg_37_0:_setting_checkbox("_highlight_textures", "Highlight matching objects")
	arg_37_0:_setting_color("_ruler_color", "Measurement tool color")

	script_data.disable_localization = arg_37_0._disable_localization
end

local var_0_18 = "UITOOL(1)                    General Tools Manual                    UITOOL(1)\n \nNAME\n\tUI Tool - a suite of utilities to make UI development a wee bit easier\n \nINTRODUCTION\n\tThe UI tool is a collection of disjoint utilities that facilitate examining\n\tvarious UI systems at run time. It is comprised of the following tools:\n\t\tSome common elements.\n\t\tA render object inspector.\n\t\tA scenegraph inspector.\n\t\tAn atlas texture browser.\n\nCOMMON ELEMENTS\n\tThese elements are shared between all tools.\n \n\tThe current cursor position is shown both in screen and canvas coordinates.\n\tMeasurements can be taken by dragging with the RIGHT mouse button.\n \n\tThe search bar can be used to apply filters on any tab, including this one\n\t(try it!). All searches are CASE SENSITIVE and accept Lua string patterns.\n \nRENDER OBJECT INSPECTOR\n\tRender objects are pseudo-objects constructed when Lua code sends draw\n\trequests to the engine. That is to say that there's a 1-to-1 correspondence\n\tbetween render objects and calls to Gui.bitmap, Gui.rect, etc.\n\tRender objects are disposed of once they have been processed by the Gui.\n\tIt is currently not possible to inspect render objects that exist inside a\n\tGui object that was created in retained mode.\n \n\tRender objects are color coded according to the following table:\n\t\tred         Bitmaps\n\t\tpurple      Bitmap UV\n\t\tgreen       Rect\n\t\tblue        Text\n\t\n\tOther types of render objects are not supported at this time.\n \nSCENEGRAPH INSPECTOR\n\tThe scenegraph is a structure to help layout UI elements on the screen.\n\tInternally it is stored as a forest where every node is associated to a\n\tquad region on the screen.\n\tThis tool can be useful to identify the internal name of a UI.\n \nATLAS TEXTURE BROWSER\n\tTextures are packed into atlas to reduce the overhead of loading many\n\tsmall textures from disk to the GPU. For example, it would not be cost\n\teffective applying texture block compression methods on tiny textures, but\n\tby packing them together a reduction in total size can be achieved.\n \n\tThis tool provides a quick way of searching and visualizing all such\n\tatlased textures that are available to the UI systems. Results can be\n\tsorted by texture name, material name or area size with the little ^ and v\n\tbuttons on the header row.\n\tHolding right-click over a texture preview will render it at native size\n\tand scroll the listing results to that point.\n \n\tNOTE: The ruler is disabled while this mode is active.\n"

ImguiUITool.do_help = function (arg_38_0)
	local var_38_0 = arg_38_0._search
	local var_38_1 = string.find
	local var_38_2 = string.sub
	local var_38_3 = arg_38_0._search ~= arg_38_0._help_cached_search

	arg_38_0._help_cached_search = arg_38_0._search

	for iter_38_0 in string.gmatch(var_0_18, "[^\n]+") do
		local var_38_4, var_38_5 = var_0_8(var_38_0, iter_38_0)

		if not var_38_4 or var_38_5 == 0 then
			var_0_1.text(iter_38_0)
		else
			var_0_1.text(var_38_2(iter_38_0, 1, var_38_4 - 1))
			var_0_1.same_line(0)
			var_0_1.text_colored(var_38_2(iter_38_0, var_38_4, var_38_5), 255, 0, 0, 255)
			var_0_1.same_line(0)
			var_0_1.text(var_38_2(iter_38_0, var_38_5 + 1))

			if var_38_3 then
				var_0_1.set_scroll_here()

				var_38_3 = false
			end
		end
	end
end

ImguiUITool.draw = function (arg_39_0)
	local var_39_0, var_39_1 = var_0_1.begin_window("UI Inspector", "menu_bar")

	if not var_39_1 then
		return var_39_0
	end

	if var_0_1.begin_menu_bar() then
		for iter_39_0, iter_39_1 in ipairs(arg_39_0._tabs) do
			local var_39_2 = arg_39_0._selected_tab ~= iter_39_1 and " " .. iter_39_1 .. " " or "[" .. iter_39_1 .. "]"

			if var_0_1.menu_item(var_39_2) then
				arg_39_0._selected_tab = iter_39_1

				table.clear(arg_39_0._data_buffer)
				table.clear(arg_39_0._data_back_buffer)
			end
		end

		var_0_1.end_menu_bar()
	end

	local var_39_3 = arg_39_0._cursor
	local var_39_4 = arg_39_0._scale
	local var_39_5 = arg_39_0._offset

	ImguiX.heading("Screen cursor", "(%4d, %4d)", var_39_3[1], var_39_3[2])
	var_0_1.same_line()

	if arg_39_0._drawing_rect then
		var_0_1.text(var_0_2("+ [%4dx%4d]", var_39_3[1] - arg_39_0._rect_x, var_39_3[2] - arg_39_0._rect_y))
	else
		var_0_1.text(string.rep(" ", 13))
	end

	var_0_1.same_line()
	ImguiX.heading("Scale", "x%f", var_39_4)
	ImguiX.heading("Canvas cursor", "(%4d, %4d)", (var_39_3[1] - var_39_5[1]) / var_39_4, (var_39_3[2] - var_39_5[2]) / var_39_4)
	var_0_1.same_line()

	if arg_39_0._drawing_rect then
		var_0_1.text(var_0_2("+ [%4dx%4d]", (var_39_3[1] - arg_39_0._rect_x) / var_39_4, (var_39_3[2] - arg_39_0._rect_y) / var_39_4))
	else
		var_0_1.text(string.rep(" ", 13))
	end

	var_0_1.same_line()
	ImguiX.heading("Offset", "Vector2(%f, %f)", var_39_5[1], var_39_5[2])

	arg_39_0._search = var_0_1.input_text("Search", arg_39_0._search)

	var_0_1.begin_child_window("child_window", 0, 0, true)

	if arg_39_0._selected_tab == "Render objects" then
		arg_39_0:do_render_objects()
	elseif arg_39_0._selected_tab == "Scenegraph" then
		arg_39_0:do_scenegraph()
	elseif arg_39_0._selected_tab == "Atlas browser" then
		arg_39_0:do_asset_browser()
	elseif arg_39_0._selected_tab == "Settings" then
		arg_39_0:do_settings()
	elseif arg_39_0._selected_tab == "Help" then
		arg_39_0:do_help()
	end

	var_0_1.end_child_window()
	var_0_1.end_window()

	return var_39_0
end

ImguiUITool.is_persistent = function (arg_40_0)
	return true
end
