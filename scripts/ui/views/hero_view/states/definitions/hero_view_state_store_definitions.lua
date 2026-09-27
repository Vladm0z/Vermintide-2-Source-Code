-- chunkname: @scripts/ui/views/hero_view/states/definitions/hero_view_state_store_definitions.lua

local tbl = {
	800,
	700
}
local tbl_2 = {
	16,
	tbl[2]
}
local tbl_3 = {
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
		size = tbl,
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
		size = tbl,
		position = {
			0,
			-tbl[2],
			0
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = tbl_2,
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
local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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
					content_change_function = function (self, arg_1_1, arg_1_2, arg_1_3)
						-- function 1
						local progress = self.progress

						if not progress then
							return
						end

						local min = math.min(progress + arg_1_3, 1)
						local num = 255 - 255 * math.smoothstep(min, 0, 1)

						arg_1_1.color[1] = num

						if min == 1 then
							self.progress = nil
						else
							self.progress = min
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
local tbl_7 = {
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
local tbl_8 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				local easeOutCubic = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
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
				-- function 5
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeOutCubic = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
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
				-- function 8
				return
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				local easeOutCubic = math.easeOutCubic(arg_9_3)
				local list_detail_top_left = arg_9_2.list_detail_top_left
				local list_detail_top_right = arg_9_2.list_detail_top_right
				local list_detail_bottom_left = arg_9_2.list_detail_bottom_left
				local list_detail_bottom_center = arg_9_2.list_detail_bottom_center
				local list_detail_top_center = arg_9_2.list_detail_top_center
				local list_detail_bottom_right = arg_9_2.list_detail_bottom_right
				local chain = arg_9_2.chain
				local num = 255 * easeOutCubic

				chain.style.tiling_texture.color[1] = num
				list_detail_top_center.style.tiling_texture.color[1] = num
				list_detail_bottom_center.style.tiling_texture.color[1] = num
				list_detail_top_left.style.texture_id.color[1] = num
				list_detail_bottom_left.style.texture_id.color[1] = num
				list_detail_top_right.style.texture_id.color[1] = num
				list_detail_bottom_right.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end
		}
	}
}
local tbl_9 = {
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
	widgets = tbl_6,
	generic_input_actions = tbl_9,
	list_detail_widgets = tbl_7,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_8
}
