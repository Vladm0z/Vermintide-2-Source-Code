-- chunkname: @scripts/ui/views/subtitle_timed_gui.lua

local var_0_0 = {
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
local var_0_1 = {
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
local var_0_2 = false

SubtitleTimedGui = class(SubtitleTimedGui)

local function var_0_3(arg_1_0)
	local var_1_0 = Managers.localizer:language_id() == "zh"
	local var_1_1 = {}
	local var_1_2 = UTF8Utils.string_length(arg_1_0)
	local var_1_3 = 1
	local var_1_4
	local var_1_5 = 50

	for iter_1_0 = 1, var_1_2 do
		local var_1_6 = UTF8Utils.sub_string(arg_1_0, iter_1_0, iter_1_0)

		if var_1_0 then
			if (var_1_6 == " " or var_1_6 == "。" or var_1_6 == "，") and iter_1_0 >= var_1_5 / 2 then
				var_1_4 = iter_1_0
			end

			if var_1_5 < iter_1_0 - var_1_3 and iter_1_0 < var_1_2 then
				if var_1_4 then
					var_1_1[#var_1_1 + 1] = UTF8Utils.sub_string(arg_1_0, var_1_3, var_1_4)
					var_1_3 = var_1_4 + 1
					iter_1_0 = var_1_4
					var_1_4 = nil
				else
					var_1_1[#var_1_1 + 1] = UTF8Utils.sub_string(arg_1_0, var_1_3, iter_1_0)
					var_1_3 = iter_1_0 + 1
				end
			end
		elseif var_1_6 == " " and var_1_5 < iter_1_0 - var_1_3 then
			var_1_1[#var_1_1 + 1] = UTF8Utils.sub_string(arg_1_0, var_1_3, iter_1_0)
			var_1_3 = iter_1_0 + 1
		end
	end

	if var_1_3 < var_1_2 then
		var_1_1[#var_1_1 + 1] = UTF8Utils.sub_string(arg_1_0, var_1_3, var_1_2)
	end

	return var_1_1
end

function SubtitleTimedGui.is_complete(arg_2_0)
	return arg_2_0._complete
end

function SubtitleTimedGui.init(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._num_rows = arg_3_2 or 5
	arg_3_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_3_0 = ""

	if type(arg_3_1) == "table" then
		for iter_3_0, iter_3_1 in ipairs(arg_3_1) do
			var_3_0 = var_3_0 .. Localize(iter_3_1) .. " "
		end
	else
		var_3_0 = arg_3_1 ~= "" and Localize(arg_3_1) or arg_3_1
	end

	arg_3_0.texts = var_0_3(var_3_0)
	arg_3_0.next_text_index = 0
	arg_3_0.text_speed = 20
	arg_3_0.subtitle_timing_name = var_3_0
	var_0_2 = false
end

function SubtitleTimedGui._create_ui_elements(arg_4_0, arg_4_1)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0)

	local var_4_0 = {}

	for iter_4_0 = 1, arg_4_0._num_rows do
		local var_4_1 = UIWidget.init(var_0_1)

		var_4_0[iter_4_0] = var_4_1

		local var_4_2 = -(iter_4_0 - 1) * 50

		var_4_1.start_offset_y = var_4_2
		var_4_1.offset[2] = var_4_2
	end

	arg_4_0._widgets = var_4_0

	UIRenderer.clear_scenegraph_queue(arg_4_1)
end

function SubtitleTimedGui.update(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0._widgets_initialized then
		arg_5_0._widgets_initialized = true

		arg_5_0:_create_ui_elements(arg_5_1)
	end

	local var_5_0 = arg_5_0._widgets

	if var_0_2 then
		var_0_2 = false
		arg_5_0.texts = var_0_3(arg_5_0.subtitle_timing_name)
		arg_5_0.next_text_index = 0

		for iter_5_0 = 1, #var_5_0 do
			local var_5_1 = var_5_0[iter_5_0]

			var_5_1.offset[2] = var_5_1.start_offset_y
		end
	end

	for iter_5_1 = 1, #var_5_0 do
		local var_5_2 = var_5_0[iter_5_1]
		local var_5_3 = var_5_2.offset[2]
		local var_5_4 = var_5_3
		local var_5_5 = var_5_3 + arg_5_2 * arg_5_0.text_speed
		local var_5_6 = var_5_2.style
		local var_5_7 = var_5_6.text
		local var_5_8 = var_5_6.shadow_text

		if var_5_5 > 0 and var_5_4 <= 0 then
			local var_5_9 = arg_5_0.next_text_index + 1

			arg_5_0.next_text_index = var_5_9

			local var_5_10 = arg_5_0.texts[var_5_9]

			var_5_2.content.text = var_5_10 or ""
			var_5_2.content.text_index = var_5_9
		elseif var_5_5 > 200 then
			var_5_5 = var_5_5 - #var_5_0 * 50
			var_5_7.text_color[1] = 0
			var_5_8.text_color[1] = 0

			if var_5_2.content.text_index > #arg_5_0.texts then
				arg_5_0._complete = true
			end
		end

		var_5_2.offset[2] = var_5_5

		if var_5_5 >= 0 and var_5_5 < 50 then
			local var_5_11 = math.lerp(0, 255, var_5_5 / 50)

			var_5_7.text_color[1] = var_5_11
			var_5_8.text_color[1] = var_5_11
		elseif var_5_5 >= 50 and var_5_5 < 150 then
			var_5_7.text_color[1] = 255
			var_5_8.text_color[1] = 255
		elseif var_5_5 >= 150 then
			local var_5_12 = math.lerp(255, 0, (var_5_5 - 150) / 50)

			var_5_7.text_color[1] = var_5_12
			var_5_8.text_color[1] = var_5_12
		end
	end

	arg_5_0:draw(arg_5_1, arg_5_2)
end

function SubtitleTimedGui.draw(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.ui_scenegraph
	local var_6_1 = arg_6_0.render_settings
	local var_6_2 = arg_6_0._widgets

	if not var_6_2 then
		return
	end

	UIRenderer.begin_pass(arg_6_1, var_6_0, FAKE_INPUT_SERVICE, arg_6_2, nil, var_6_1)

	for iter_6_0 = 1, #var_6_2 do
		local var_6_3 = var_6_2[iter_6_0]

		UIRenderer.draw_widget(arg_6_1, var_6_3)
	end

	UIRenderer.end_pass(arg_6_1)
end
