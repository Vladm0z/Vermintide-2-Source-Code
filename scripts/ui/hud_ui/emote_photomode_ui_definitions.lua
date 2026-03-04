-- chunkname: @scripts/ui/hud_ui/emote_photomode_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 45
local var_0_3 = {
	325,
	var_0_2 * 2
}
local var_0_4 = {
	325,
	var_0_2 * 4
}
local var_0_5 = {
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
	controls_pc = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			0,
			-20,
			0
		},
		size = var_0_3
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
		size = var_0_4
	}
}

local function var_0_6(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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
			-arg_1_3 * var_0_2,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_7(arg_2_0, arg_2_1)
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
					var_0_5[arg_2_0].size[1],
					var_0_5[arg_2_0].size[2] + var_0_2
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
					(var_0_5[arg_2_0].size[2] + var_0_2 + 50) * 0.5,
					var_0_5[arg_2_0].size[1] * 0.5
				},
				texture_size = {
					var_0_5[arg_2_0].size[2] + var_0_2 + 50,
					var_0_5[arg_2_0].size[1]
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
					var_0_5[arg_2_0].size[1],
					var_0_5[arg_2_0].size[2] + var_0_2
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

local var_0_8 = {}
local var_0_9 = 2
local var_0_10 = {
	rect = var_0_7("controls_pc", {
		70,
		0,
		0,
		0
	}, var_0_9),
	hide_hud = var_0_6("controls_pc", "photomode_hide_hud", "emote_toggle_hud_visibility", 0),
	zoom_mouse = var_0_6("controls_pc", "photomode_camera_zoom", "emote_camera_zoom", 1)
}
local var_0_11 = 4
local var_0_12 = {
	rect = var_0_7("controls_gamepad", {
		255,
		255,
		255,
		255
	}, var_0_11),
	hide_hud = var_0_6("controls_gamepad", "photomode_hide_hud", "emote_toggle_hud_visibility", 0),
	zoom_in_gamepad = var_0_6("controls_gamepad", "photomode_camera_zoom_in", "emote_camera_zoom_in", 1),
	zoom_out_gamepad = var_0_6("controls_gamepad", "photomode_camera_zoom_out", "emote_camera_zoom_out", 2),
	exit_gamepad = var_0_6("controls_gamepad", "exit", "crouch", 3)
}

return {
	scenegraph_definition = var_0_5,
	widgets = var_0_8,
	widgets_pc = var_0_10,
	widgets_gamepad = var_0_12
}
