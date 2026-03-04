-- chunkname: @scripts/ui/views/hero_view/states/definitions/hero_view_state_store_definitions.lua

local var_0_0 = {
	800,
	700
}
local var_0_1 = {
	16,
	var_0_0[2]
}
local var_0_2 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
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
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	video_fullscreen_background = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			998
		}
	},
	video_fullscreen = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale = "aspect_ratio",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			999
		}
	},
	video_fullscreen_fade = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			1000
		}
	},
	list_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = var_0_0,
		position = {
			130,
			-215,
			10
		}
	},
	list = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = var_0_0,
		position = {
			0,
			-var_0_0[2],
			0
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = var_0_1,
		position = {
			-58,
			0,
			10
		}
	},
	list_detail_top_left = {
		vertical_alignment = "top",
		parent = "list_scrollbar",
		horizontal_alignment = "left",
		size = {
			157,
			97
		},
		position = {
			-45,
			60,
			2
		}
	},
	list_detail_bottom_left = {
		vertical_alignment = "bottom",
		parent = "list_scrollbar",
		horizontal_alignment = "left",
		size = {
			157,
			97
		},
		position = {
			-45,
			-60,
			2
		}
	},
	list_detail_top_center = {
		vertical_alignment = "top",
		parent = "list_detail_top_left",
		horizontal_alignment = "left",
		size = {
			64,
			97
		},
		position = {
			157,
			0,
			0
		}
	},
	list_detail_bottom_center = {
		vertical_alignment = "bottom",
		parent = "list_detail_bottom_left",
		horizontal_alignment = "left",
		size = {
			200,
			97
		},
		position = {
			157,
			0,
			0
		}
	},
	list_detail_top_right = {
		vertical_alignment = "top",
		parent = "list_detail_top_center",
		horizontal_alignment = "right",
		size = {
			23,
			97
		},
		position = {
			23,
			0,
			0
		}
	},
	list_detail_bottom_right = {
		vertical_alignment = "bottom",
		parent = "list_detail_bottom_center",
		horizontal_alignment = "right",
		size = {
			23,
			97
		},
		position = {
			23,
			0,
			0
		}
	}
}
local var_0_3 = {
	use_shadow = true,
	upper_case = false,
	localize = true,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_4 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 42,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		2,
		2
	}
}
local var_0_5 = {
	video_fullscreen_fade = {
		scenegraph_id = "video_fullscreen_fade",
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					style_id = "rect",
					pass_type = "rect",
					content_change_function = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
						local var_1_0 = arg_1_0.progress

						if not var_1_0 then
							return
						end

						local var_1_1 = math.min(var_1_0 + arg_1_3, 1)
						local var_1_2 = 255 - 255 * math.smoothstep(var_1_1, 0, 1)

						arg_1_1.color[1] = var_1_2

						if var_1_1 == 1 then
							arg_1_0.progress = nil
						else
							arg_1_0.progress = var_1_1
						end
					end
				}
			}
		},
		content = {},
		style = {
			rect = {
				color = {
					255,
					0,
					0,
					0
				}
			},
			background = {
				scenegraph_id = "video_fullscreen_background",
				color = {
					255,
					0,
					0,
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
}
local var_0_6 = {
	list_detail_top_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "list_detail_top_left"),
	list_detail_bottom_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "list_detail_bottom_left"),
	list_detail_top_center = UIWidgets.create_tiled_texture("list_detail_top_center", "divider_skull_middle", {
		64,
		97
	}),
	list_detail_bottom_center = UIWidgets.create_tiled_texture("list_detail_bottom_center", "divider_skull_middle_down", {
		64,
		97
	}),
	list_detail_top_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "list_detail_top_right"),
	list_detail_bottom_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "list_detail_bottom_right"),
	chain = UIWidgets.create_tiled_texture("list_scrollbar", "chain_link_01_blue", {
		16,
		19
	})
}
local var_0_7 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	},
	list_detail_on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeOutCubic(arg_9_3)
				local var_9_1 = arg_9_2.list_detail_top_left
				local var_9_2 = arg_9_2.list_detail_top_right
				local var_9_3 = arg_9_2.list_detail_bottom_left
				local var_9_4 = arg_9_2.list_detail_bottom_center
				local var_9_5 = arg_9_2.list_detail_top_center
				local var_9_6 = arg_9_2.list_detail_bottom_right
				local var_9_7 = arg_9_2.chain
				local var_9_8 = 255 * var_9_0

				var_9_7.style.tiling_texture.color[1] = var_9_8
				var_9_5.style.tiling_texture.color[1] = var_9_8
				var_9_4.style.tiling_texture.color[1] = var_9_8
				var_9_1.style.texture_id.color[1] = var_9_8
				var_9_3.style.texture_id.color[1] = var_9_8
				var_9_2.style.texture_id.color[1] = var_9_8
				var_9_6.style.texture_id.color[1] = var_9_8
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		}
	}
}
local var_0_8 = {
	{
		input_action = "confirm",
		priority = 2,
		description_text = "input_description_select"
	},
	{
		input_action = "back",
		priority = 3,
		description_text = "input_description_close"
	}
}

return {
	widgets = var_0_5,
	generic_input_actions = var_0_8,
	list_detail_widgets = var_0_6,
	scenegraph_definition = var_0_2,
	animation_definitions = var_0_7
}
