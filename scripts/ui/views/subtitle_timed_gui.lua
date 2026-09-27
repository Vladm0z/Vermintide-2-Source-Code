-- chunkname: @scripts/ui/views/subtitle_timed_gui.lua

local tbl = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			1
		},
		size = {
			1920,
			1080
		}
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	subtitle_row = {
		vertical_alignment = "bottom",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			600,
			50
		},
		position = {
			0,
			300,
			3
		}
	}
}
local tbl_2 = {
	start_offset_y = 0,
	scenegraph_id = "subtitle_row",
	element = {
		passes = {
			{
				style_id = "text",
				pass_type = "text",
				text_id = "text"
			},
			{
				style_id = "shadow_text",
				pass_type = "text",
				text_id = "text"
			}
		}
	},
	content = {
		text = ""
	},
	style = {
		text = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			word_wrap = false,
			font_size = 36,
			horizontal_alignment = "center",
			text_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				1
			}
		},
		shadow_text = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			word_wrap = false,
			font_size = 36,
			horizontal_alignment = "center",
			text_color = {
				255,
				0,
				0,
				0
			},
			offset = {
				2,
				-2,
				0
			}
		}
	},
	offset = {
		0,
		0,
		0
	}
}
local flag = false

SubtitleTimedGui = class(SubtitleTimedGui)

local function fn(arg_1_0)
	-- function 1
	local flag = Managers.localizer:language_id() == "zh"
	local tbl = {}
	local length = Utf8.length(arg_1_0)
	local num = 1
	local var_1_4
	local num_2 = 50

	for i = 1, length do
		local sub_string = UTF8Utils.sub_string(arg_1_0, i, i)

		if not flag then
			if not (not (sub_string == " " or sub_string == "。" or sub_string == "，") and not (i >= num_2 / 2)) then
				var_1_4 = i
			end

			if not (not (num_2 < i - num) or not (i < length)) then
				if not var_1_4 then
					local sub_string_2 = UTF8Utils.sub_string(arg_1_0, num, var_1_4)

					tbl[#tbl + 1] = sub_string_2
					num = var_1_4 + 1
					i = var_1_4
					var_1_4 = nil
				else
					local sub_string_3 = UTF8Utils.sub_string(arg_1_0, num, i)

					tbl[#tbl + 1] = sub_string_3
					num = i + 1
				end
			end
		elseif not (not (sub_string == " ") and not (num_2 < i - num)) then
			local sub_string_4 = UTF8Utils.sub_string(arg_1_0, num, i)

			tbl[#tbl + 1] = sub_string_4
			num = i + 1
		end
	end

	if num < length then
		local sub_string_5 = UTF8Utils.sub_string(arg_1_0, num, length)

		tbl[#tbl + 1] = sub_string_5
	end

	return tbl
end

SubtitleTimedGui.is_complete = function (self)
	-- function 2
	return self._complete
end

SubtitleTimedGui.init = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._num_rows = arg_3_2 or 5
	self.render_settings = {
		snap_pixel_positions = true
	}

	local str = ""

	if type(arg_3_1) == "table" then
		for i, v in ipairs(arg_3_1) do
			str = str .. Localize(v) .. " "
		end
	else
		str = arg_3_1 == "" or not Localize(arg_3_1) or arg_3_1
	end

	self.texts = fn(str)
	self.next_text_index = 0
	self.text_speed = 20
	self.subtitle_timing_name = str
	flag = false
end

SubtitleTimedGui._create_ui_elements = function (self, arg_4_1)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)

	local tbl_3 = {}

	for i = 1, self._num_rows do
		local var_4_1 = UIWidget.init(tbl_2)

		tbl_3[i] = var_4_1

		local num = -(i - 1) * 50

		var_4_1.start_offset_y = num
		var_4_1.offset[2] = num
	end

	self._widgets = tbl_3

	UIRenderer.clear_scenegraph_queue(arg_4_1)
end

SubtitleTimedGui.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._widgets_initialized then
		self._widgets_initialized = true

		self:_create_ui_elements(arg_5_1)
	end

	local _widgets = self._widgets

	if not flag then
		flag = false
		self.texts = fn(self.subtitle_timing_name)
		self.next_text_index = 0

		for i = 1, #_widgets do
			local var_5_1 = _widgets[i]

			var_5_1.offset[2] = var_5_1.start_offset_y
		end
	end

	for j = 1, #_widgets do
		local var_5_2 = _widgets[j]
		local var_5_3 = var_5_2.offset[2]
		local var_5_4 = var_5_3
		local num = var_5_3 + arg_5_2 * self.text_speed
		local style = var_5_2.style
		local text = style.text
		local shadow_text = style.shadow_text

		if not (not (num > 0) or not (var_5_4 <= 0)) then
			local num_2 = self.next_text_index + 1

			self.next_text_index = num_2

			local var_5_10 = self.texts[num_2]

			var_5_2.content.text = var_5_10 or ""
			var_5_2.content.text_index = num_2
		elseif num > 200 then
			num = num - #_widgets * 50
			text.text_color[1] = 0
			shadow_text.text_color[1] = 0

			if var_5_2.content.text_index > #self.texts then
				self._complete = true
			end
		end

		var_5_2.offset[2] = num

		if not (not (num >= 0) or not (num < 50)) then
			local lerp = math.lerp(0, 255, num / 50)

			text.text_color[1] = lerp
			shadow_text.text_color[1] = lerp
		elseif not (not (num >= 50) or not (num < 150)) then
			text.text_color[1] = 255
			shadow_text.text_color[1] = 255
		elseif num >= 150 then
			local lerp_2 = math.lerp(255, 0, (num - 150) / 50)

			text.text_color[1] = lerp_2
			shadow_text.text_color[1] = lerp_2
		end
	end

	self:draw(arg_5_1, arg_5_2)
end

SubtitleTimedGui.draw = function (self, arg_6_1, arg_6_2)
	-- function 6
	local ui_scenegraph = self.ui_scenegraph
	local render_settings = self.render_settings
	local _widgets = self._widgets

	if not _widgets then
		return
	end

	UIRenderer.begin_pass(arg_6_1, ui_scenegraph, FAKE_INPUT_SERVICE, arg_6_2, nil, render_settings)

	for i = 1, #_widgets do
		local var_6_3 = _widgets[i]

		UIRenderer.draw_widget(arg_6_1, var_6_3)
	end

	UIRenderer.end_pass(arg_6_1)
end
