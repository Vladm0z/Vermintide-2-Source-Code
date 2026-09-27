-- chunkname: @scripts/ui/hud_ui/emote_photomode_ui_definitions.lua

local num = 1920
local num_2 = 1080
local num_3 = 45
local tbl = {
	325,
	num_3 * 2
}
local tbl_2 = {
	325,
	num_3 * 4
}
local tbl_3 = {
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
	controls_pc = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			0,
			-20,
			0
		},
		size = tbl
	},
	controls_gamepad = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			0,
			-20,
			0
		},
		size = tbl_2
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_id"
				}
			}
		},
		content = {
			text_id = Localize(arg_1_1) .. ": $KEY;Player__" .. arg_1_2 .. ":"
		},
		style = {
			text = {
				word_wrap = false,
				localize = false,
				font_size = 32,
				pixel_perfect = true,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text_shadow = {
				font_size = 32,
				font_type = "hell_shark_header",
				localize = false,
				word_wrap = false,
				pixel_perfect = true,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				dynamic_font_size = true,
				skip_button_rendering = true,
				text_color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					2,
					-2,
					1
				}
			}
		},
		offset = {
			0,
			-arg_1_3 * num_3,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	return {
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "mask_vertical",
					texture_id = "mask_id"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background_id"
				}
			}
		},
		content = {
			mask_id = "horizontal_gradient_mask",
			background_id = {
				texture_id = "subtitles_bg",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		},
		style = {
			test = {
				vertical_alignment = "right",
				horizontal_alignment = "bottom",
				color = arg_2_1 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					-5
				},
				texture_size = {
					tbl_3[arg_2_0].size[1],
					tbl_3[arg_2_0].size[2] + num_3
				}
			},
			mask_vertical = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = -math.pi * 0.5,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					50,
					0
				},
				pivot = {
					(tbl_3[arg_2_0].size[2] + num_3 + 50) * 0.5,
					tbl_3[arg_2_0].size[1] * 0.5
				},
				texture_size = {
					tbl_3[arg_2_0].size[2] + num_3 + 50,
					tbl_3[arg_2_0].size[1]
				}
			},
			background = {
				vertical_alignment = "right",
				masked = true,
				horizontal_alignment = "bottom",
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
				},
				texture_size = {
					tbl_3[arg_2_0].size[1],
					tbl_3[arg_2_0].size[2] + num_3
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_2_0
	}
end

local tbl_4 = {}
local num_4 = 2
local tbl_5 = {
	rect = fn_2("controls_pc", {
		70,
		0,
		0,
		0
	}, num_4),
	hide_hud = fn("controls_pc", "photomode_hide_hud", "emote_toggle_hud_visibility", 0),
	zoom_mouse = fn("controls_pc", "photomode_camera_zoom", "emote_camera_zoom", 1)
}
local num_5 = 4
local tbl_6 = {
	rect = fn_2("controls_gamepad", {
		255,
		255,
		255,
		255
	}, num_5),
	hide_hud = fn("controls_gamepad", "photomode_hide_hud", "emote_toggle_hud_visibility", 0),
	zoom_in_gamepad = fn("controls_gamepad", "photomode_camera_zoom_in", "emote_camera_zoom_in", 1),
	zoom_out_gamepad = fn("controls_gamepad", "photomode_camera_zoom_out", "emote_camera_zoom_out", 2),
	exit_gamepad = fn("controls_gamepad", "exit", "crouch", 3)
}

return {
	scenegraph_definition = tbl_3,
	widgets = tbl_4,
	widgets_pc = tbl_5,
	widgets_gamepad = tbl_6
}
