-- chunkname: @scripts/ui/hud_ui/news_feed_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	420,
	120
}
local var_0_3 = 5
local var_0_4 = 10
local var_0_5 = {
	root = {
		scale = "hud_scale_fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
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
	var_0_5.root.scale = "hud_fit"
	var_0_5.root.is_root = false
end

local function var_0_6(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1

	if not var_1_0 then
		var_1_0 = "news_pivot_" .. arg_1_0
		var_0_5[var_1_0] = {
			vertical_alignment = "top",
			parent = "pivot",
			horizontal_alignment = "right",
			size = {
				var_0_2[1],
				var_0_2[2]
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
					content_check_function = function(arg_2_0, arg_2_1)
						return arg_2_0.icon ~= nil
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

local var_0_7 = {}

for iter_0_0 = 1, var_0_3 do
	var_0_7[iter_0_0] = var_0_6(iter_0_0)
end

return {
	WIDGET_SIZE = var_0_2,
	NEWS_SPACING = var_0_4,
	MAX_NUMBER_OF_NEWS = var_0_3,
	scenegraph_definition = var_0_5,
	buff_widget_definitions = var_0_7
}
