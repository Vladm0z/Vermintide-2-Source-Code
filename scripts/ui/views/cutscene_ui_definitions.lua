-- chunkname: @scripts/ui/views/cutscene_ui_definitions.lua

local var_0_0 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.cutscene
		},
		size = {
			1920,
			1080
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.cutscene
		},
		size = {
			1920,
			1080
		}
	},
	letterbox_top_bar = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			UISettings.cutscene_ui.letterbox.bar_height
		},
		position = {
			0,
			0,
			1
		}
	},
	letterbox_bottom_bar = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			UISettings.cutscene_ui.letterbox.bar_height
		},
		position = {
			0,
			0,
			1
		}
	},
	checkbox_pivot = {
		vertical_alignment = "center",
		parent = "letterbox_bottom_bar",
		horizontal_alignment = "left",
		size = {
			40,
			40
		},
		position = {
			-20,
			0,
			1
		}
	},
	fx_fade_rect = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "left",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			2
		}
	},
	fx_text_popup = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			200
		},
		position = {
			0,
			140,
			2
		}
	}
}

local function var_0_1(arg_1_0)
	local var_1_0 = UIFrameSettings.menu_frame_06

	return {
		scenegraph_id = "checkbox_pivot",
		offset = {
			arg_1_0 * 50,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "check",
					texture_id = "check",
					content_check_function = function (arg_2_0)
						return arg_2_0.checked
					end
				},
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				}
			}
		},
		content = {
			check = "matchmaking_checkbox",
			frame = var_1_0.texture
		},
		style = {
			background = {
				color = {
					100,
					8,
					8,
					8
				}
			},
			frame = {
				area_size = {
					40,
					40
				},
				texture_size = var_1_0.texture_size,
				texture_sizes = var_1_0.texture_sizes,
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			check = {
				texture_size = {
					37,
					31
				},
				offset = {
					4,
					6,
					2
				},
				color = Colors.get_color_table_with_alpha("dark_olive_green", 255)
			}
		}
	}
end

local var_0_2 = {
	checkbox_1 = var_0_1(1),
	checkbox_2 = var_0_1(2),
	checkbox_3 = var_0_1(3),
	checkbox_4 = var_0_1(4),
	letterbox = {
		scenegraph_id = "screen",
		element = {
			passes = {
				{
					scenegraph_id = "letterbox_top_bar",
					style_id = "letterbox_top_bar",
					pass_type = "rect"
				},
				{
					scenegraph_id = "letterbox_bottom_bar",
					style_id = "letterbox_bottom_bar",
					pass_type = "rect"
				}
			}
		},
		content = {},
		style = {
			letterbox_top_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = {
					255,
					0,
					0,
					0
				}
			},
			letterbox_bottom_bar = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	},
	fx_fade = {
		scenegraph_id = "screen",
		element = {
			passes = {
				{
					scenegraph_id = "screen",
					style_id = "fx_fade_rect",
					pass_type = "rect",
					content_check_function = function (arg_3_0, arg_3_1)
						if not arg_3_0 or not arg_3_1 then
							return
						end

						local var_3_0 = arg_3_0.fx_fade_alpha * 255

						arg_3_1.color[1] = var_3_0

						return var_3_0 > 0
					end
				}
			}
		},
		content = {
			fx_fade_alpha = 0
		},
		style = {
			fx_fade_rect = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					0,
					0,
					0,
					0
				}
			}
		}
	},
	fx_text_popup = {
		scenegraph_id = "fx_text_popup",
		element = {
			passes = {
				{
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_4_0, arg_4_1)
						if not arg_4_0 or not arg_4_1 then
							return
						end

						local var_4_0 = arg_4_0.fx_text_popup_alpha * 255

						arg_4_1.text_color[1] = var_4_0

						return var_4_0 > 0
					end
				}
			}
		},
		content = {
			fx_text_popup_alpha = 0,
			text = ""
		},
		style = {
			vertical_alignment = "top",
			dynamic_font = true,
			localize = true,
			word_wrap = true,
			font_size = 50,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			text_color = {
				0,
				255,
				255,
				255
			}
		}
	}
}

return {
	scenegraph = var_0_0,
	widgets = var_0_2
}
