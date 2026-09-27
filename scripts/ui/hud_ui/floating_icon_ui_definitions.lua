-- chunkname: @scripts/ui/hud_ui/floating_icon_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	screen = {
		scale = "fit",
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
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	bar_pivot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					pass_type = "rect",
					style_id = "foreground"
				}
			}
		},
		content = {},
		style = {
			background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = arg_1_1,
				color = {
					200,
					30,
					30,
					30
				},
				offset = {
					0,
					0,
					0
				}
			},
			foreground = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					arg_1_1[1] - 4,
					arg_1_1[2] - 4
				},
				default_size = {
					arg_1_1[1] - 4,
					arg_1_1[2] - 4
				},
				color = {
					255,
					255,
					0,
					0
				},
				offset = {
					2,
					2,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local tbl_2 = {
	default = {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					texture_id = "arrow",
					style_id = "arrow",
					pass_type = "rotated_texture",
					content_check_function = function (arg_2_0, arg_2_1)
						-- function 2
						return arg_2_1.color[1] > 0
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 3
						return self.text
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 4
						return self.text
					end
				}
			}
		},
		content = {
			text = "tooltip_text",
			texture_id = "hud_tutorial_icon_info",
			arrow = "indicator"
		},
		style = {
			text = {
				vertical_alignment = "center",
				font_size = 30,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					34,
					0,
					1
				}
			},
			text_shadow = {
				vertical_alignment = "center",
				font_size = 30,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					36,
					-2,
					0
				}
			},
			texture_id = {
				size = {
					64,
					64
				},
				offset = {
					-30,
					-30,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			arrow = {
				angle = 0,
				size = {
					38,
					18
				},
				pivot = {
					19,
					9
				},
				offset = {
					-19,
					-9,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	progress_bar = fn("bar_pivot", {
		300,
		50
	})
}
local tbl_3 = {}

return {
	animation_definitions = tbl_3,
	scenegraph_definition = tbl,
	widget_definitions = tbl_2
}
