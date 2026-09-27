-- chunkname: @scripts/imgui/imgui_ui_tool.lua

ImguiUITool = class(ImguiUITool)

local Gui = Gui
local Imgui = Imgui
local format = string.format

local function fn(self)
	-- function 1
	return Vector2(self[1], self[2])
end

local function fn_2(self)
	-- function 2
	return Color(self[1], self[2], self[3], self[4])
end

local function fn_3(self, arg_3_1, arg_3_2)
	-- function 3
	self[1] = arg_3_1
	self[2] = arg_3_2

	return self
end

local select = select
local find = string.find

local function fn_4(arg_4_0, ...)
	-- function 4
	for i = 1, select("#", ...) do
		local var_4_0, var_4_1, var_4_2 = pcall(find, select(i, ...), arg_4_0)

		if not var_4_0 then
			return false
		elseif not var_4_1 then
			return var_4_1, var_4_2
		end
	end
end

ImguiUITool.init = function (self)
	-- function 5
	self._active = false
	self._draw_ruler = false
	self._draw_canvas = false
	self._ruler_color = {
		64,
		255,
		0,
		0
	}
	self._highlight_textures = true
	self._drawing_rect = false
	self._hide_ui = false
	self._disable_localization = not not script_data.disable_localization
	self._rect_x, self._rect_y = 0, 0
	self._data_buffer = {}
	self._data_back_buffer = {}
	self._search = ""
	self._cursor = {
		0,
		0,
		0
	}
	self._scale = 1
	self._offset = {
		0,
		0
	}
	self._tabs = {
		"Render objects",
		"Scenegraph",
		"Atlas browser",
		"Settings",
		"Help"
	}
	self._selected_tab = self._tabs[1]
end

local flag = true

ImguiUITool.update = function (self)
	-- function 6
	if not flag then
		self:init()
		self:on_hide()
		self:on_show()

		flag = false
	end

	if not self._active then
		self._data_buffer, self._data_back_buffer = self._data_back_buffer, self._data_buffer

		table.clear(self._data_back_buffer)
	end

	local axis = Mouse.axis(Mouse.axis_id("cursor"))
	local num = 1920
	local num_2 = 1080
	local resolution, var_6_4 = Gui.resolution()
	local min = math.min(resolution / num, var_6_4 / num_2)
	local num_3 = 0.5 * (resolution - num * min)
	local num_4 = 0.5 * (var_6_4 - num_2 * min)
	local var_6_8 = fn_3(self._cursor, axis[1], axis[2])

	self._scale = min

	fn_3(self._offset, num_3, num_4)

	local get_gui = self:get_gui()

	if not get_gui then
		return
	end

	if not self._draw_canvas then
		local var_6_10 = Color(32, 255, 0, 255)

		Gui.rect(get_gui, Vector3(0, 0, 999), Vector2(num_3, var_6_4), var_6_10)
		Gui.rect(get_gui, Vector3(resolution, 0, 999), Vector2(-num_3, var_6_4), var_6_10)
		Gui.rect(get_gui, Vector3(num_3, 0, 999), Vector2(resolution - num_3, num_4), var_6_10)
		Gui.rect(get_gui, Vector3(num_3, var_6_4, 999), Vector2(resolution - num_3, -num_4), var_6_10)
	end

	if self._selected_tab ~= "Atlas browser" then
		if not self._draw_ruler then
			Gui.rect(get_gui, Vector3(var_6_8[1], 0, 1000), Vector2(1, var_6_4))
			Gui.rect(get_gui, Vector3(0, var_6_8[2], 1000), Vector2(resolution, 1))
		end

		local button_index = Mouse.button_index("right")

		if not Mouse.pressed(button_index) then
			self._drawing_rect = true
			self._rect_x, self._rect_y = var_6_8[1], var_6_8[2]
		elseif not Mouse.released(button_index) then
			self._drawing_rect = false
		end

		if not self._drawing_rect then
			Gui.rect(get_gui, Vector3(self._rect_x, self._rect_y, 1000), Vector2(var_6_8[1] - self._rect_x, var_6_8[2] - self._rect_y), fn_2(self._ruler_color))
		end
	end
end

local tbl = {
	255,
	255,
	255,
	255
}
local num = 2

local function fn_5(self, arg_7_1, arg_7_2)
	-- function 7
	return not (arg_7_1[1] - num <= self[1]) or not (self[1] <= arg_7_1[1] + arg_7_2[1] + num) or not (arg_7_1[2] - num <= self[2]) or self[2] <= arg_7_1[2] + arg_7_2[2] + num
end

local function fn_6(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local var_8_0 = arg_8_2[1]
	local num_2 = arg_8_2[2] - 2 * num

	Gui.rect(arg_8_0, Vector3(arg_8_1[1], arg_8_1[2], arg_8_1[3]), Vector2(var_8_0, arg_8_3), arg_8_4)
	Gui.rect(arg_8_0, Vector3(arg_8_1[1], arg_8_1[2] + arg_8_2[2] - arg_8_3, arg_8_1[3]), Vector2(var_8_0, arg_8_3), arg_8_4)
	Gui.rect(arg_8_0, Vector3(arg_8_1[1], arg_8_1[2] + arg_8_3, arg_8_1[3]), Vector2(arg_8_3, num_2), arg_8_4)
	Gui.rect(arg_8_0, Vector3(arg_8_1[1] + arg_8_2[1] - arg_8_3, arg_8_1[2] + arg_8_3, arg_8_1[3]), Vector2(arg_8_3, num_2), arg_8_4)
end

ImguiUITool.draw_border = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local get_gui = self:get_gui()

	if not (not get_gui and self._highlight_textures) then
		return
	end

	arg_9_1 = arg_9_1 + Vector3(0, 0, 1)

	return fn_6(get_gui, arg_9_1, arg_9_2, num, arg_9_3)
end

ImguiUITool.draw_label = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local get_gui = self:get_gui()

	if not (not get_gui and self._highlight_textures) then
		return
	end

	Gui.text(get_gui, arg_10_1, "materials/fonts/arial", 16, nil, arg_10_2 + Vector2(num + 2, num + 2), arg_10_3)
end

ImguiUITool.texture = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	if not fn_4(self._search, arg_11_1, arg_11_2) then
		return
	end

	local var_11_0 = fn_5(self._cursor, arg_11_3, arg_11_4)

	if not var_11_0 then
		arg_11_5 = arg_11_5 or tbl

		local _data_back_buffer = self._data_back_buffer
		local var_11_2 = UIAtlasHelper._ui_atlas_settings[arg_11_2]

		_data_back_buffer[#_data_back_buffer + 1] = arg_11_1
		_data_back_buffer[#_data_back_buffer + 1] = tostring(arg_11_2)

		local num = #_data_back_buffer + 1
		local material_name

		if not var_11_2 then
			material_name = var_11_2.material_name

			if not material_name then
				-- Nothing
			end
		end

		material_name = "n/a"

		::label_11_0::

		_data_back_buffer[num] = material_name
		_data_back_buffer[#_data_back_buffer + 1] = format("Vector3(%d, %d, %d)", arg_11_3[1], arg_11_3[2], arg_11_3[3])
		_data_back_buffer[#_data_back_buffer + 1] = format("Vector2(%d, %d)", arg_11_4[1], arg_11_4[2])
		_data_back_buffer[#_data_back_buffer + 1] = format("Color(%d, %d, %d, %d)", arg_11_5[1], arg_11_5[2], arg_11_5[3], arg_11_5[4])
	end

	local var_11_5
	local flag

	flag = not var_11_0 and 200 and 30

	if not (arg_11_1 == "rect" or arg_11_1 ~= "rounded_rect") then
		var_11_5 = Color(flag, 0, 255, 0)
	elseif arg_11_1 == "bitmap" then
		var_11_5 = Color(flag, 255, 0, 0)
	elseif arg_11_1 == "bitmap_uv" then
		var_11_5 = Color(flag, 255, 0, 155)
	end

	self:draw_border(Vector3(arg_11_3[1], arg_11_3[2], 999), Vector2(arg_11_4[1], arg_11_4[2]), var_11_5)
end

ImguiUITool.text = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	if not fn_4(self._search, arg_12_2, arg_12_3) then
		return
	end

	local text_extents, var_12_1, var_12_2 = Gui.text_extents(arg_12_1.gui, arg_12_2, arg_12_3, arg_12_4)
	local num = var_12_1 - text_extents

	arg_12_5 = arg_12_5 + text_extents

	local var_12_4 = fn_5(self._cursor, arg_12_5, num)

	if not var_12_4 then
		arg_12_6 = arg_12_6 or tbl

		local _data_back_buffer = self._data_back_buffer

		_data_back_buffer[#_data_back_buffer + 1] = "text"
		_data_back_buffer[#_data_back_buffer + 1] = format("%10q", arg_12_2)
		_data_back_buffer[#_data_back_buffer + 1] = arg_12_3
		_data_back_buffer[#_data_back_buffer + 1] = format("Vector3(%d, %d, %d)", arg_12_5[1], arg_12_5[2], arg_12_5[3])
		_data_back_buffer[#_data_back_buffer + 1] = format("%d / Vector2(%d, %d)", arg_12_4, num[1], num[2])
		_data_back_buffer[#_data_back_buffer + 1] = format("Color(%d, %d, %d, %d)", arg_12_6[1], arg_12_6[2], arg_12_6[3], arg_12_6[4])
	end

	local var_12_6 = self
	local draw_border = self.draw_border
	local var_12_8 = Vector3(arg_12_5[1], arg_12_5[2], 999)
	local var_12_9 = Vector2(num[1], num[2])
	local Color = Color
	local flag

	flag = not var_12_4 and 200 and 30

	draw_border(var_12_6, var_12_8, var_12_9, Color(flag, 0, 100, 255))
end

ImguiUITool.node = function (self, arg_13_1, arg_13_2)
	-- function 13
	local var_13_0 = fn_4
	local _search = self._search
	local name = arg_13_1.name

	name = name or "n/a"

	if not var_13_0(_search, name, arg_13_2) then
		return
	end

	local _scale = self._scale
	local world_position = arg_13_1.world_position
	local size = arg_13_1.size
	local var_13_6 = Vector3(world_position[1] * _scale, world_position[2] * _scale, world_position[3] * _scale)
	local var_13_7 = Vector2(size[1] * _scale, size[2] * _scale)
	local var_13_8 = fn_5(self._cursor, var_13_6, var_13_7)

	if not var_13_8 then
		local _data_back_buffer = self._data_back_buffer

		_data_back_buffer[#_data_back_buffer + 1] = arg_13_2 or "n/a"
		_data_back_buffer[#_data_back_buffer + 1] = arg_13_1.name

		if not arg_13_1.parent then
			_data_back_buffer[#_data_back_buffer + 1] = arg_13_1.parent

			local num = #_data_back_buffer + 1
			local var_13_11 = format
			local str = "%s / %s"
			local horizontal_alignment = arg_13_1.horizontal_alignment

			horizontal_alignment = horizontal_alignment or "left"

			local vertical_alignment = arg_13_1.vertical_alignment

			vertical_alignment = vertical_alignment or "bottom"
			_data_back_buffer[num] = var_13_11(str, horizontal_alignment, vertical_alignment)
		else
			_data_back_buffer[#_data_back_buffer + 1] = "n/a"
			_data_back_buffer[#_data_back_buffer + 1] = "n/a"
		end

		_data_back_buffer[#_data_back_buffer + 1] = format("Vector3(%d, %d, %d)", world_position[1], world_position[2], world_position[3])
		_data_back_buffer[#_data_back_buffer + 1] = format("Vector2(%d, %d)", size[1], size[2])

		local var_13_15 = self
		local draw_label = self.draw_label
		local name_2 = arg_13_1.name
		local var_13_18 = Vector3(var_13_6[1], var_13_6[2], 999)
		local Color = Color
		local flag

		flag = not var_13_8 and 200 and 55

		draw_label(var_13_15, name_2, var_13_18, Color(flag, 100, 100, 255))
	end

	local var_13_21 = self
	local draw_border = self.draw_border
	local var_13_23 = Vector3(var_13_6[1], var_13_6[2], 999)
	local var_13_24 = var_13_7
	local Color_2 = Color
	local flag_2

	flag_2 = not var_13_8 and 200 and 55

	draw_border(var_13_21, var_13_23, var_13_24, Color_2(flag_2, 100, 100, 255))

	return var_13_8
end

ImguiUITool.scenegraph = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if arg_14_2 or not arg_14_3 then
		return
	end

	local getinfo = debug.getinfo(4, "S")

	if not getinfo then
		-- Nothing
	end

	::label_14_0::

	local short_src = getinfo.short_src

	short_src = not short_src and string.match(getinfo.short_src, "/([^/]+)%.lua$")

	::label_14_1::

	local flag = false

	for k, v in pairs(arg_14_1) do
		if type(k) == "number" or not self:node(v, short_src) then
			flag = true
		end
	end

	if not flag then
		table.insert(self._data_back_buffer, false)
	end
end

ImguiUITool.on_show = function (self)
	-- function 15
	Debug.hook(UIRenderer, "script_draw_bitmap", function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
		-- function 16
		if not (not self._active and self._selected_tab ~= "Render objects") then
			self:texture("bitmap", arg_16_3, arg_16_4, arg_16_5, arg_16_6)
		end

		if not self._hide_ui then
			return
		end

		return arg_16_0(arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	end)
	Debug.hook(UIRenderer, "script_draw_bitmap_uv", function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
		-- function 17
		if not (not self._active and self._selected_tab ~= "Render objects") then
			self:texture("bitmap_uv", arg_17_3, arg_17_5, arg_17_6, arg_17_7)
		end

		if not self._hide_ui then
			return
		end

		return arg_17_0(arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10)
	end)
	Debug.hook(UIRenderer, "draw_rect", function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
		-- function 18
		if not (not self._active and self._selected_tab ~= "Render objects") then
			self:texture("rect", "n/a", UIScaleVectorToResolution(arg_18_2), UIScaleVectorToResolution(arg_18_3), arg_18_4)
		end

		if not self._hide_ui then
			return
		end

		return arg_18_0(arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	end)
	Debug.hook(UIRenderer, "draw_rounded_rect", function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
		-- function 19
		if not (not self._active and self._selected_tab ~= "Render objects") then
			self:texture("rounded_rect", "n/a", UIScaleVectorToResolution(arg_19_2), UIScaleVectorToResolution(arg_19_3), arg_19_5)
		end

		if not self._hide_ui then
			return
		end

		return arg_19_0(arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	end)
	Debug.hook(UIRenderer, "draw_text", function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
		-- function 20
		if not (not self._active and self._selected_tab ~= "Render objects") then
			self:text(arg_20_1, arg_20_2, arg_20_3, arg_20_4, UIScaleVectorToResolution(arg_20_6), arg_20_7)
		end

		if not self._hide_ui then
			return
		end

		return arg_20_0(arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8, arg_20_9)
	end)
	Debug.hook(UISceneGraph, "update_scenegraph", function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		-- function 21
		if not (not self._active and self._selected_tab ~= "Scenegraph") then
			self:scenegraph(arg_21_1, arg_21_2, arg_21_3)
		end

		return arg_21_0(arg_21_1, arg_21_2, arg_21_3)
	end)

	self._active = true
end

ImguiUITool.on_hide = function (self)
	-- function 22
	Debug.unhook(UIRenderer, "script_draw_bitmap", true)
	Debug.unhook(UIRenderer, "script_draw_bitmap_uv", true)
	Debug.unhook(UIRenderer, "draw_rect", true)
	Debug.unhook(UIRenderer, "draw_text", true)

	self._active = false
end

ImguiUITool.get_gui = function (self)
	-- function 23
	if not self._gui then
		return self._gui
	end

	if not Managers.world then
		return
	end

	local world = Managers.world:world("top_ingame_view")

	if not world then
		return
	end

	self._gui = World.create_screen_gui(world, "immediate")
end

ImguiUITool._set_columns = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	Imgui.columns(arg_24_1, not not arg_24_2)

	if not arg_24_3 then
		return
	end

	if type(arg_24_3) == "table" then
		for i, v in ipairs(arg_24_3) do
			Imgui.set_column_width(v, i - 1)
		end
	else
		for k = 0, arg_24_1 - 1 do
			Imgui.set_column_width(arg_24_3, k)
		end
	end
end

ImguiUITool.do_render_objects = function (self)
	-- function 25
	self:_set_columns(6, true)
	Imgui.text("Type")
	Imgui.next_column()
	Imgui.text("Texture/String")
	Imgui.next_column()
	Imgui.text("Material/Font")
	Imgui.next_column()
	Imgui.text("Position")
	Imgui.next_column()
	Imgui.text("(Font) size")
	Imgui.next_column()
	Imgui.text("Color")
	Imgui.next_column()
	Imgui.separator()

	local _data_buffer = self._data_buffer

	for i = 1, #_data_buffer do
		local var_25_1 = _data_buffer[i]
		local num = i % 6

		if num == 1 then
			if not (var_25_1 == "rect" or var_25_1 ~= "rounded_rect") then
				Imgui.text_colored(var_25_1, 0, 255, 0, 255)
			elseif var_25_1 == "bitmap" then
				Imgui.text_colored(var_25_1, 255, 0, 0, 255)
			elseif var_25_1 == "bitmap_uv" then
				Imgui.text_colored(var_25_1, 255, 0, 155, 255)
			elseif var_25_1 == "text" then
				Imgui.text_colored(var_25_1, 0, 100, 255, 255)
			else
				Imgui.text(var_25_1)
			end
		elseif num == 0 then
			local match, var_25_4, var_25_5, var_25_6 = string.match(var_25_1, "(%d+), (%d+), (%d+), (%d+)")

			Imgui.color_edit_4("##" .. i, var_25_4 / 255, var_25_5 / 255, var_25_6 / 255, match / 255)
		else
			Imgui.text(var_25_1)
		end

		Imgui.next_column()
	end

	self:_set_columns(1)
end

ImguiUITool.do_scenegraph = function (self)
	-- function 26
	self:_set_columns(6, true)
	Imgui.text("File")
	Imgui.next_column()
	Imgui.text("Name")
	Imgui.next_column()
	Imgui.text("Parent")
	Imgui.next_column()
	Imgui.text("Alignment")
	Imgui.next_column()
	Imgui.text("Position")
	Imgui.next_column()
	Imgui.text("Size")
	Imgui.next_column()
	Imgui.separator()

	local _data_buffer = self._data_buffer

	for i = 1, #_data_buffer do
		local var_26_1 = _data_buffer[i]

		if var_26_1 ~= false then
			Imgui.text(var_26_1)
			Imgui.next_column()
		else
			Imgui.separator()
		end
	end

	self:_set_columns(1)
end

local function fn_7(self)
	-- function 27
	return self.texture_name
end

local function fn_8(self)
	-- function 28
	return self.material_name
end

local function fn_9(self)
	-- function 29
	local size = self.size

	return size[1] * size[2]
end

local function fn_10(arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	Imgui.same_line()

	if not Imgui.small_button("^##ASC_" .. arg_30_2) then
		table.sort(arg_30_0, function (arg_31_0, arg_31_1)
			-- function 31
			return arg_30_1(arg_31_0) < arg_30_1(arg_31_1)
		end)
		printf("[ImguiUITool] Sorted by %s in ASC order", arg_30_2)
	end

	Imgui.same_line()

	if not Imgui.small_button("v##DESC_" .. arg_30_2) then
		table.sort(arg_30_0, function (arg_32_0, arg_32_1)
			-- function 32
			return arg_30_1(arg_32_0) > arg_30_1(arg_32_1)
		end)
		printf("[ImguiUITool] Sorted by %s in DESC order", arg_30_2)
	end
end

ImguiUITool.do_asset_browser = function (self)
	-- function 33
	local _texture_registry = self._texture_registry

	if not _texture_registry then
		_texture_registry = table.values(UIAtlasHelper._ui_atlas_settings)
		self._texture_registry = _texture_registry
		self._asset_browser_offset = 0
	end

	self:_set_columns(3, true)
	Imgui.text("Texture")
	fn_10(_texture_registry, fn_7, "1")
	Imgui.next_column()
	Imgui.text("Material")
	fn_10(_texture_registry, fn_8, "2")
	Imgui.next_column()
	Imgui.text("Size")
	fn_10(_texture_registry, fn_9, "3")
	Imgui.next_column()
	Imgui.separator()

	local var_33_1 = Vector2(50, 50)
	local _cursor = self._cursor
	local resolution, var_33_4 = Gui.resolution()
	local floor = math.floor(resolution / var_33_1[1])
	local _search = self._search
	local num_2 = 50
	local axis_index = Mouse.axis_index("wheel")

	if Vector3.y(Mouse.axis(axis_index)) > 0 then
		self._asset_browser_offset = math.min(var_33_1[2], self._asset_browser_offset + num_2)
	elseif Vector3.y(Mouse.axis(axis_index)) < 0 then
		self._asset_browser_offset = self._asset_browser_offset - num_2
	elseif Mouse.button(Mouse.button_index("middle")) > 0.5 then
		local _scroll_hold_pos = self._scroll_hold_pos

		_scroll_hold_pos = _scroll_hold_pos or Vector3Box(Vector3Aux.unbox(_cursor))
		self._scroll_hold_pos = _scroll_hold_pos
		self._asset_browser_offset = self._asset_browser_offset + (Vector3Aux.unbox(_cursor)[2] - self._scroll_hold_pos:unbox()[2])
		self._asset_browser_offset = math.clamp(self._asset_browser_offset, var_33_1[2] * (-math.ceil(#table.select_array(_texture_registry, function (arg_34_0, arg_34_1)
			-- function 34
			return fn_4(_search, arg_34_1.texture_name, arg_34_1.material_name)
		end) / floor) - 1) + var_33_4, var_33_1[2])
	elseif not self._scroll_hold_pos then
		self._scroll_hold_pos = nil
	end

	local _ingame_ui = Managers.ui._ingame_ui
	local flag = not _ingame_ui and _ingame_ui.ui_top_renderer.gui
	local num_3 = 0

	for i = 1, #_texture_registry do
		local var_33_13 = _texture_registry[i]
		local texture_name = var_33_13.texture_name
		local material_name = var_33_13.material_name

		if not fn_4(_search, texture_name, material_name) then
			local size = var_33_13.size
			local flag_2 = false

			if not flag then
				num_3 = num_3 + 1

				local num_4 = floor - 1 - num_3 % floor
				local ceil = math.ceil(num_3 / floor)
				local var_33_20 = Vector3(var_33_1[1] * num_4, var_33_4 - var_33_1[2] * ceil - self._asset_browser_offset, 950)

				flag_2 = math.point_is_inside_2d_box(_cursor, var_33_20, var_33_1)

				if not Gui.material(flag, material_name) then
					local min = math.min(var_33_1[1] / size[1], var_33_1[2] / size[2], 1)
					local var_33_22 = Vector2(size[1] * min, size[2] * min)
					local num_5 = var_33_20 + 0.5 * (var_33_1 - var_33_22)

					Gui.rect(flag, var_33_20, var_33_1, Color(127, 127, 127))
					Gui.bitmap_uv(flag, material_name, fn(var_33_13.uv00), fn(var_33_13.uv11), num_5, var_33_22)

					if not flag_2 then
						fn_6(flag, var_33_20 + Vector3(0, 0, 1), var_33_1, num, Color(255, 0, 0))
					end
				else
					Gui.rect(flag, var_33_20, var_33_1, Color(255, 192, 203))
					Gui.text(flag, "No material", "materials/fonts/arial", 7.5, nil, var_33_20 + Vector2(0, 0.5 * (var_33_1[2] - 18)), var_33_1, Color(0, 0, 0))
				end
			end

			if not flag_2 then
				Imgui.text_colored(texture_name, 255, 0, 0, 255)
				Imgui.set_scroll_here()

				local min_2 = math.min((var_33_4 - size[2]) * 0.5, 100)

				if _cursor[2] < var_33_4 * 0.25 then
					min_2 = math.max((var_33_4 - size[2]) * 0.5, var_33_4 - size[2] - 100)
				end

				local var_33_25 = Vector3((resolution - size[1]) * 0.5, min_2, 960)
				local var_33_26 = fn(size)
				local var_33_27 = Vector2(10, 10)

				Gui.bitmap(flag, "marching_ants", var_33_25 - var_33_27 - Vector3(0, 0, 1), var_33_26 + 2 * var_33_27, Color(255, 0, 0))
				Gui.rect(flag, var_33_25 - var_33_27 - Vector3(0, 0, 2), var_33_26 + 2 * var_33_27, Color(0, 0, 0))
				Gui.rect(flag, var_33_25, var_33_26, Color(127, 127, 127))

				if not Gui.material(flag, material_name) then
					Gui.bitmap_uv(flag, material_name, fn(var_33_13.uv00), fn(var_33_13.uv11), var_33_25, var_33_26)
				else
					Gui.rect(flag, var_33_25, var_33_26, Color(255, 192, 203))
					Gui.text(flag, "No material", "materials/fonts/arial", 7.5, nil, var_33_25 + Vector2(0, 0.5 * (var_33_26[2] - 18)), var_33_26, Color(0, 0, 0))
				end

				local var_33_28 = texture_name
				local time = Managers.time:time("main")
				local _copied_t = self._copied_t

				_copied_t = _copied_t or 0

				if not (not (time < _copied_t) or self._copied_text ~= texture_name) then
					var_33_28 = var_33_28 .. " (Copied!)           "
				else
					var_33_28 = var_33_28 .. " (Left click to copy)"
				end

				local calculate_text_size = Imgui.calculate_text_size(var_33_28)
				local num_6 = var_33_25 - Vector3(calculate_text_size * 0.5 - size[1] * 0.5, 25, 0)

				Gui.rect(flag, num_6 - Vector2(5, 7), Vector2(calculate_text_size, 22), Color(0, 0, 0))
				Gui.text(flag, var_33_28, "materials/fonts/arial", 14, nil, num_6, Color(255, 255, 255, 255))

				if not Mouse.pressed(Mouse.button_index("left")) then
					printf("[ImguiUITool] Copied %s to clipboard", texture_name)
					Clipboard.put(texture_name)

					self._copied_t = time + 1.5
					self._copied_text = texture_name
				end
			end

			Imgui.next_column()
			Imgui.text(material_name)
			Imgui.next_column()
			Imgui.text(format("%4d x %4d", size[1], size[2]))
			Imgui.next_column()
		end
	end

	self:_set_columns(1)
end

ImguiUITool._setting_checkbox = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not fn_4(self._search, arg_35_2) then
		local checkbox = Imgui.checkbox
		local var_35_1 = arg_35_2
		local var_35_2 = self[arg_35_1]

		var_35_2 = var_35_2 or false
		self[arg_35_1] = checkbox(var_35_1, var_35_2)
	end
end

ImguiUITool._setting_color = function (self, arg_36_1, arg_36_2)
	-- function 36
	if not fn_4(self._search, arg_36_2) then
		local var_36_0 = self[arg_36_1]

		var_36_0 = var_36_0 or {
			255,
			255,
			255,
			255
		}

		Colors.set(var_36_0, ImguiX.color_edit_4(arg_36_2, unpack(var_36_0)))

		self[arg_36_1] = var_36_0
	end
end

ImguiUITool.do_settings = function (self)
	-- function 37
	Imgui.text("Settings")
	Imgui.separator()
	self:_setting_checkbox("_draw_ruler", "Draw ruler crosshair")
	self:_setting_checkbox("_draw_canvas", "Draw canvas margins")
	self:_setting_checkbox("_disable_localization", "Disable localization")
	self:_setting_checkbox("_hide_ui", "Hide immediate-mode UIs")
	self:_setting_checkbox("_highlight_textures", "Highlight matching objects")
	self:_setting_color("_ruler_color", "Measurement tool color")

	script_data.disable_localization = self._disable_localization
end

local str = "UITOOL(1)                    General Tools Manual                    UITOOL(1)\n \nNAME\n\tUI Tool - a suite of utilities to make UI development a wee bit easier\n \nINTRODUCTION\n\tThe UI tool is a collection of disjoint utilities that facilitate examining\n\tvarious UI systems at run time. It is comprised of the following tools:\n\t\tSome common elements.\n\t\tA render object inspector.\n\t\tA scenegraph inspector.\n\t\tAn atlas texture browser.\n\nCOMMON ELEMENTS\n\tThese elements are shared between all tools.\n \n\tThe current cursor position is shown both in screen and canvas coordinates.\n\tMeasurements can be taken by dragging with the RIGHT mouse button.\n \n\tThe search bar can be used to apply filters on any tab, including this one\n\t(try it!). All searches are CASE SENSITIVE and accept Lua string patterns.\n \nRENDER OBJECT INSPECTOR\n\tRender objects are pseudo-objects constructed when Lua code sends draw\n\trequests to the engine. That is to say that there's a 1-to-1 correspondence\n\tbetween render objects and calls to Gui.bitmap, Gui.rect, etc.\n\tRender objects are disposed of once they have been processed by the Gui.\n\tIt is currently not possible to inspect render objects that exist inside a\n\tGui object that was created in retained mode.\n \n\tRender objects are color coded according to the following table:\n\t\tred         Bitmaps\n\t\tpurple      Bitmap UV\n\t\tgreen       Rect\n\t\tblue        Text\n\t\n\tOther types of render objects are not supported at this time.\n \nSCENEGRAPH INSPECTOR\n\tThe scenegraph is a structure to help layout UI elements on the screen.\n\tInternally it is stored as a forest where every node is associated to a\n\tquad region on the screen.\n\tThis tool can be useful to identify the internal name of a UI.\n \nATLAS TEXTURE BROWSER\n\tTextures are packed into atlas to reduce the overhead of loading many\n\tsmall textures from disk to the GPU. For example, it would not be cost\n\teffective applying texture block compression methods on tiny textures, but\n\tby packing them together a reduction in total size can be achieved.\n \n\tThis tool provides a quick way of searching and visualizing all such\n\tatlased textures that are available to the UI systems. Results can be\n\tsorted by texture name, material name or area size with the little ^ and v\n\tbuttons on the header row.\n\tHolding right-click over a texture preview will render it at native size\n\tand scroll the listing results to that point.\n \n\tNOTE: The ruler is disabled while this mode is active.\n"

ImguiUITool.do_help = function (self)
	-- function 38
	local _search = self._search
	local find = string.find
	local sub = string.sub
	local flag = self._search ~= self._help_cached_search

	self._help_cached_search = self._search

	for iter_38_0 in string.gmatch(str, "[^\n]+") do
		local var_38_4, var_38_5 = fn_4(_search, iter_38_0)

		if not (not var_38_4 and var_38_5 ~= 0) then
			Imgui.text(iter_38_0)
		else
			Imgui.text(sub(iter_38_0, 1, var_38_4 - 1))
			Imgui.same_line(0)
			Imgui.text_colored(sub(iter_38_0, var_38_4, var_38_5), 255, 0, 0, 255)
			Imgui.same_line(0)
			Imgui.text(sub(iter_38_0, var_38_5 + 1))

			if not flag then
				Imgui.set_scroll_here()

				flag = false
			end
		end
	end
end

ImguiUITool.draw = function (self)
	-- function 39
	local begin_window, var_39_1 = Imgui.begin_window("UI Inspector", "menu_bar")

	if not var_39_1 then
		return begin_window
	end

	if not Imgui.begin_menu_bar() then
		for i, v in ipairs(self._tabs) do
			local str

			if self._selected_tab ~= v then
				str = " " .. v .. " "

				if not str then
					-- Nothing
				end
			end

			str = "[" .. v .. "]"

			::label_39_0::

			if not Imgui.menu_item(str) then
				self._selected_tab = v

				table.clear(self._data_buffer)
				table.clear(self._data_back_buffer)
			end
		end

		Imgui.end_menu_bar()
	end

	local _cursor = self._cursor
	local _scale = self._scale
	local _offset = self._offset

	ImguiX.heading("Screen cursor", "(%4d, %4d)", _cursor[1], _cursor[2])
	Imgui.same_line()

	if not self._drawing_rect then
		Imgui.text(format("+ [%4dx%4d]", _cursor[1] - self._rect_x, _cursor[2] - self._rect_y))
	else
		Imgui.text(string.rep(" ", 13))
	end

	Imgui.same_line()
	ImguiX.heading("Scale", "x%f", _scale)
	ImguiX.heading("Canvas cursor", "(%4d, %4d)", (_cursor[1] - _offset[1]) / _scale, (_cursor[2] - _offset[2]) / _scale)
	Imgui.same_line()

	if not self._drawing_rect then
		Imgui.text(format("+ [%4dx%4d]", (_cursor[1] - self._rect_x) / _scale, (_cursor[2] - self._rect_y) / _scale))
	else
		Imgui.text(string.rep(" ", 13))
	end

	Imgui.same_line()
	ImguiX.heading("Offset", "Vector2(%f, %f)", _offset[1], _offset[2])

	self._search = Imgui.input_text("Search", self._search)

	Imgui.begin_child_window("child_window", 0, 0, true)

	if self._selected_tab == "Render objects" then
		self:do_render_objects()
	elseif self._selected_tab == "Scenegraph" then
		self:do_scenegraph()
	elseif self._selected_tab == "Atlas browser" then
		self:do_asset_browser()
	elseif self._selected_tab == "Settings" then
		self:do_settings()
	elseif self._selected_tab == "Help" then
		self:do_help()
	end

	Imgui.end_child_window()
	Imgui.end_window()

	return begin_window
end

ImguiUITool.is_persistent = function (arg_40_0)
	-- function 40
	return true
end
