-- chunkname: @scripts/ui/hud_ui/news_feed_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	420,
	120
}
local num_3 = 5
local num_4 = 10
local tbl_2 = {
	root = {
		scale = "hud_scale_fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			-20,
			-300,
			1
		},
		size = {
			0,
			0
		}
	}
}

if not IS_WINDOWS then
	tbl_2.root.scale = "hud_fit"
	tbl_2.root.is_root = false
end

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local var_1_0 = arg_1_1

	if not var_1_0 then
		var_1_0 = "news_pivot_" .. arg_1_0
		tbl_2[var_1_0] = {
			vertical_alignment = "top",
			parent = "pivot",
			horizontal_alignment = "right",
			size = {
				tbl[1],
				tbl[2]
			},
			position = {
				0,
				0,
				1
			}
		}
	end

	return {
		element = {
			passes = {
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self, arg_2_1)
						-- function 2
						return self.icon ~= nil
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "rotated_texture",
					style_id = "effect",
					texture_id = "effect"
				}
			}
		},
		content = {
			text = "text \n text \n text",
			effect = "sparkle_effect",
			background = "news_feed_background",
			title_text = "title_text"
		},
		style = {
			title_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 24,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark",
				offset = {
					-12,
					-8,
					2
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255)
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 24,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark",
				offset = {
					-10,
					-10,
					1
				},
				text_color = Colors.get_color_table_with_alpha("black", 255)
			},
			text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				font_type = "hell_shark",
				offset = {
					-12,
					-34,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				font_type = "hell_shark",
				offset = {
					-10,
					-36,
					1
				},
				text_color = Colors.get_color_table_with_alpha("black", 255)
			},
			icon = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			background = {
				offset = {
					0,
					0,
					0
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			effect = {
				vertical_alignment = "top",
				angle = 0,
				horizontal_alignment = "right",
				offset = {
					120,
					120,
					4
				},
				pivot = {
					128,
					128
				},
				texture_size = {
					256,
					256
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = var_1_0
	}
end

local tbl_3 = {}

for i = 1, num_3 do
	tbl_3[i] = fn(i)
end

return {
	WIDGET_SIZE = tbl,
	NEWS_SPACING = num_4,
	MAX_NUMBER_OF_NEWS = num_3,
	scenegraph_definition = tbl_2,
	buff_widget_definitions = tbl_3
}
