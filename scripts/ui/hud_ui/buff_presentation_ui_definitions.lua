-- chunkname: @scripts/ui/hud_ui/buff_presentation_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	screen = {
		scale = "fit",
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
	presentation_widget_parent = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			110,
			100
		},
		size = {
			66,
			66
		}
	},
	presentation_widget = {
		vertical_alignment = "bottom",
		parent = "presentation_widget_parent",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
		},
		size = {
			66,
			66
		}
	},
	presentation_widget_dragger = {
		vertical_alignment = "center",
		parent = "presentation_widget",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			198,
			66
		}
	}
}
local var_0_3 = {
	word_wrap = false,
	font_size = 52,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 0),
	default_text_color = Colors.get_color_table_with_alpha("white", 0),
	offset = {
		0,
		0,
		1
	}
}
local var_0_4 = {
	presentation_widget = {
		scenegraph_id = "presentation_widget",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon"
				},
				{
					pass_type = "texture",
					style_id = "texture_frame",
					texture_id = "texture_frame"
				}
			}
		},
		content = {
			texture_frame = "item_frame",
			texture_icon = "kerillian_waywatcher_movement_speed_on_taking_damage"
		},
		style = {
			texture_icon = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			texture_frame = {
				color = {
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
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
}
local var_0_5 = {
	presentation = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_2.style.texture_icon.color[1] = 0
				arg_1_2.style.texture_frame.color[1] = 0

				local var_1_0 = arg_1_0.presentation_widget.size
				local var_1_1 = arg_1_1.presentation_widget.size

				var_1_0[1] = var_1_1[1]
				var_1_0[2] = var_1_1[2]
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)
				local var_2_1 = math.catmullrom(var_2_0, -2, 0, 1, -5)

				arg_2_2.style.texture_icon.color[1] = var_2_0 * 255
				arg_2_2.style.texture_frame.color[1] = var_2_0 * 255

				local var_2_2 = arg_2_0.presentation_widget.size
				local var_2_3 = arg_2_1.presentation_widget.size

				var_2_2[1] = math.floor(var_2_3[1] * var_2_1)
				var_2_2[2] = math.floor(var_2_3[2] * var_2_1)
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 0.5,
			end_progress = 0.8,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)
				local var_5_1 = math.catmullrom(var_5_0, 5, 0, 1, 1)

				arg_5_2.style.texture_icon.color[1] = (1 - var_5_0) * 255
				arg_5_2.style.texture_frame.color[1] = (1 - var_5_0) * 255

				local var_5_2 = arg_5_0.presentation_widget.size
				local var_5_3 = arg_5_1.presentation_widget.size

				var_5_2[1] = var_5_3[1] - math.floor(20 * var_5_1)
				var_5_2[2] = var_5_3[2] - math.floor(20 * var_5_1)
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_2,
	animation_definitions = var_0_5,
	widget_definitions = var_0_4
}
