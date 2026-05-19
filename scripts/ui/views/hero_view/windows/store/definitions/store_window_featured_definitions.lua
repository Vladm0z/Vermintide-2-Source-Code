-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_featured_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = 10
local var_0_2 = {
	screen = var_0_0.screen,
	area = var_0_0.area,
	area_left = var_0_0.area_left,
	area_right = var_0_0.area_right,
	area_divider = var_0_0.area_divider,
	discount_banner = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			800,
			64
		},
		position = {
			0,
			-81,
			0
		}
	},
	slideshow = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			920,
			0
		},
		position = {
			100,
			-160,
			10
		}
	},
	list_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			788,
			0
		},
		position = {
			-100,
			-160,
			10
		}
	},
	item_root = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	fence = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			153
		},
		position = {
			0,
			35,
			UILayer.default + 30
		}
	},
	skull_front_left = {
		vertical_alignment = "center",
		parent = "fence",
		horizontal_alignment = "left",
		size = {
			287,
			258
		},
		position = {
			-1,
			15,
			1
		}
	},
	skull_front_right = {
		vertical_alignment = "center",
		parent = "fence",
		horizontal_alignment = "right",
		size = {
			287,
			258
		},
		position = {
			1,
			15,
			1
		}
	},
	skull_back_left = {
		vertical_alignment = "center",
		parent = "fence",
		horizontal_alignment = "left",
		size = {
			287,
			258
		},
		position = {
			-1,
			15,
			-1
		}
	},
	skull_back_right = {
		vertical_alignment = "center",
		parent = "fence",
		horizontal_alignment = "right",
		size = {
			287,
			258
		},
		position = {
			1,
			15,
			-1
		}
	},
	login_rewards = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			375,
			68
		},
		position = {
			-350,
			120,
			20
		}
	}
}

local function var_0_3(arg_1_0)
	local var_1_0 = var_0_2[arg_1_0].size
	local var_1_1 = UIFrameSettings.button_frame_01_gold
	local var_1_2 = UIFrameSettings.frame_outer_glow_01
	local var_1_3 = var_1_2.texture_sizes.horizontal[2]
	local var_1_4 = "button_detail_09_gold"
	local var_1_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_4).size

	return {
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "bg",
					style_id = "bg",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "bg_fade",
					style_id = "bg_fade",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass",
					pass_type = "texture"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail"
				},
				{
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail"
				},
				{
					style_id = "outer_glow",
					texture_id = "outer_glow",
					pass_type = "texture_frame",
					content_check_function = function(arg_2_0)
						return arg_2_0.is_claimable
					end,
					content_change_function = function(arg_3_0, arg_3_1)
						arg_3_1.color[1] = 150 + 105 * math.sin(5 * Managers.time:time("ui"))
					end
				},
				{
					style_id = "title",
					pass_type = "text",
					text_id = "title"
				},
				{
					style_id = "title_shadow",
					pass_type = "text",
					text_id = "title"
				},
				{
					style_id = "subtitle",
					pass_type = "text",
					text_id = "subtitle"
				}
			}
		},
		content = {
			bg_fade = "button_bg_fade",
			subtitle = "n/a",
			hover_glow = "button_state_default",
			bg = "menu_frame_bg_07",
			title = "store_login_rewards_title",
			glass = "game_options_fg",
			glass_top = "button_glass_01",
			glass_bottom = "button_glass_02",
			button_hotspot = {},
			frame = var_1_1.texture,
			side_detail = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = var_1_4
			},
			outer_glow = var_1_2.texture
		},
		style = {
			bg = {
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
				texture_tiling_size = {
					512,
					256
				}
			},
			bg_fade = {
				color = {
					0,
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
			hover_glow = {
				vertical_alignment = "bottom",
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				},
				texture_size = {
					var_1_0[1],
					math.min(var_1_0[2] - 5, 80)
				}
			},
			glass = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			},
			glass_top = {
				vertical_alignment = "top",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				},
				texture_size = {
					var_1_0[1],
					11
				}
			},
			frame = {
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
				offset = {
					0,
					0,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			side_detail_left = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-55,
					0,
					10
				},
				texture_size = {
					var_1_5[1],
					var_1_5[2]
				}
			},
			side_detail_right = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					55,
					0,
					10
				},
				texture_size = {
					var_1_5[1],
					var_1_5[2]
				}
			},
			outer_glow = {
				frame_margins = {
					-var_1_3,
					-var_1_3
				},
				texture_size = var_1_2.texture_size,
				texture_sizes = var_1_2.texture_sizes,
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			title = {
				horizontal_alignment = "center",
				font_size = 38,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					30,
					0,
					6
				},
				size = {
					var_1_0[1] - 60,
					var_1_0[2]
				}
			},
			title_shadow = {
				horizontal_alignment = "center",
				font_size = 38,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					32,
					-2,
					5
				},
				size = {
					var_1_0[1] - 60,
					var_1_0[2]
				}
			},
			subtitle = {
				vertical_alignment = "center",
				localize = false,
				horizontal_alignment = "center",
				font_size = 25,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-65,
					6
				}
			}
		}
	}
end

local function var_0_4(arg_4_0, arg_4_1)
	local var_4_0 = "menu_frame_16"
	local var_4_1 = UIFrameSettings[var_4_0]
	local var_4_2 = "frame_outer_glow_04"
	local var_4_3 = UIFrameSettings[var_4_2]
	local var_4_4 = var_4_3.texture_sizes.horizontal[2]
	local var_4_5 = "frame_outer_glow_04_big"
	local var_4_6 = UIFrameSettings[var_4_5]
	local var_4_7 = var_4_6.texture_sizes.horizontal[2]
	local var_4_8 = false
	local var_4_9 = {
		element = {}
	}
	local var_4_10 = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			pass_type = "rect",
			style_id = "text_background"
		},
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
			style_id = "description_text",
			pass_type = "text",
			text_id = "description_text"
		},
		{
			style_id = "description_text_shadow",
			pass_type = "text",
			text_id = "description_text"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "pulse_frame",
			texture_id = "pulse_frame"
		},
		{
			pass_type = "texture",
			style_id = "timer_bg",
			texture_id = "timer_bg"
		},
		{
			style_id = "timer_bar",
			pass_type = "texture_uv",
			content_id = "timer_bar"
		},
		{
			style_id = "icon_1",
			pass_type = "texture_uv",
			content_id = "icon_1"
		},
		{
			style_id = "icon_2",
			pass_type = "texture_uv",
			content_id = "icon_2"
		},
		{
			pass_type = "texture",
			style_id = "hourglass_icon",
			texture_id = "hourglass_icon",
			content_check_function = function(arg_5_0)
				return arg_5_0.show_hourglass
			end
		},
		{
			style_id = "list_style",
			pass_type = "list_pass",
			content_id = "list_content",
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				}
			}
		}
	}
	local var_4_11 = {
		hourglass_icon = "icon_store_timer",
		title_text = "n/a",
		rect = "rect_masked",
		wait_time = 3,
		timer_bg = "store_slideshow_bg",
		description_text = "n/a",
		hotspot = {},
		frame = var_4_1.texture,
		hover_frame = var_4_3.texture,
		pulse_frame = var_4_6.texture,
		timer_bar = {
			texture_id = "store_slideshow_fill",
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
		},
		icon_1 = {
			texture_id = "icons_placeholder",
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
		},
		icon_2 = {
			texture_id = "icons_placeholder",
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
		},
		size = arg_4_1,
		list_content = {
			allow_multi_hover = true
		}
	}
	local var_4_12 = var_4_11.list_content

	for iter_4_0 = 1, var_0_1 do
		var_4_12[iter_4_0] = {
			background = "store_slideshow_off",
			icon = "store_slideshow_on",
			button_hotspot = {}
		}
	end

	local var_4_13 = {
		hotspot = {
			size = arg_4_1,
			offset = {
				0,
				-arg_4_1[2],
				0
			}
		},
		title_text = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			font_size = 36,
			font_type = "hell_shark_header",
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			size = {
				arg_4_1[1] * 0.33 - 30,
				110
			},
			area_size = {
				arg_4_1[1] * 0.33 + 25,
				100
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				15,
				-110,
				6
			}
		},
		title_text_shadow = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			font_size = 36,
			font_type = "hell_shark_header",
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			size = {
				arg_4_1[1] * 0.33 - 30,
				110
			},
			area_size = {
				arg_4_1[1] * 0.33 + 25,
				100
			},
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				17,
				-112,
				5
			}
		},
		description_text = {
			font_size = 20,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark",
			size = {
				arg_4_1[1] * 0.33,
				arg_4_1[2] - 120
			},
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				15,
				-arg_4_1[2],
				6
			}
		},
		description_text_shadow = {
			font_size = 20,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark",
			size = {
				arg_4_1[1] * 0.33,
				arg_4_1[2] - 120
			},
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				17,
				-arg_4_1[2] - 2,
				5
			}
		},
		background = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = var_4_8,
			texture_size = arg_4_1,
			color = {
				200,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		text_background = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = var_4_8,
			texture_size = {
				arg_4_1[1] * 0.33 + 30,
				arg_4_1[2]
			},
			color = {
				150,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				3
			}
		},
		timer_bar = {
			vertical_alignment = "bottom",
			texture_width = 144,
			horizontal_alignment = "left",
			size = arg_4_1,
			masked = var_4_8,
			texture_size = {
				0,
				3
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_4_1[1] / 2 - 72,
				-arg_4_1[2] + 10 + 3,
				9
			}
		},
		timer_bg = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			size = arg_4_1,
			masked = var_4_8,
			texture_size = {
				150,
				9
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-arg_4_1[2] + 10,
				8
			}
		},
		icon_1 = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = var_4_8,
			texture_size = arg_4_1,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				2
			}
		},
		icon_2 = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = var_4_8,
			texture_size = arg_4_1,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				2
			}
		},
		frame = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			masked = var_4_8,
			area_size = arg_4_1,
			texture_size = var_4_1.texture_size,
			texture_sizes = var_4_1.texture_sizes,
			frame_margins = {
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				5
			}
		},
		hover_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			masked = var_4_8,
			area_size = arg_4_1,
			texture_size = var_4_3.texture_size,
			texture_sizes = var_4_3.texture_sizes,
			frame_margins = {
				-var_4_4,
				-var_4_4
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			}
		},
		pulse_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			masked = var_4_8,
			area_size = arg_4_1,
			texture_size = var_4_6.texture_size,
			texture_sizes = var_4_6.texture_sizes,
			frame_margins = {
				-var_4_7,
				-var_4_7
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				12
			}
		},
		hourglass_icon = {
			vertical_alignment = "top",
			horizontal_alignment = "right",
			offset = {
				0,
				0,
				10
			},
			texture_size = {
				49.5,
				58.5
			}
		},
		list_style = {
			num_draws = 0,
			start_index = 1,
			offset = {
				0,
				-arg_4_1[2] + 20,
				9
			},
			list_member_offset = {
				0,
				0,
				0
			},
			size = {
				33,
				39
			},
			item_styles = {}
		}
	}
	local var_4_14 = var_4_13.list_style.item_styles

	for iter_4_1 = 1, var_0_1 do
		var_4_14[iter_4_1] = {
			list_member_offset = {
				33,
				0,
				0
			},
			size = {
				33,
				39
			},
			background = {
				masked = var_4_8,
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
			icon = {
				masked = var_4_8,
				color = {
					0,
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
		}
	end

	var_4_9.element.passes = var_4_10
	var_4_9.content = var_4_11
	var_4_9.style = var_4_13
	var_4_9.offset = {
		0,
		0,
		0
	}
	var_4_9.scenegraph_id = arg_4_0

	return var_4_9
end

local function var_0_5(arg_6_0)
	local var_6_0 = var_0_2[arg_6_0].size
	local var_6_1 = "button_frame_03_gold"
	local var_6_2 = UIFrameSettings[var_6_1]
	local var_6_3 = var_6_2.texture_sizes.horizontal[2]

	return {
		scenegraph_id = arg_6_0,
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "rect",
					style_id = "bg",
					texture_id = "bg"
				},
				{
					pass_type = "tiled_texture",
					style_id = "bg_texture",
					texture_id = "bg_texture"
				},
				{
					pass_type = "texture",
					style_id = "glass_top",
					texture_id = "glass_top"
				},
				{
					pass_type = "texture",
					style_id = "glass_bottom",
					texture_id = "glass_bottom"
				},
				{
					pass_type = "texture",
					style_id = "glass",
					texture_id = "glass"
				},
				{
					pass_type = "texture",
					style_id = "glow",
					texture_id = "glow"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_shadow"
				},
				{
					style_id = "icon",
					texture_id = "icon",
					pass_type = "texture",
					content_change_function = function(arg_7_0, arg_7_1)
						local var_7_0 = 0.5 + math.sin(Managers.time:time("ui") * 3) * 0.5

						arg_7_1.color[1] = 215 + 40 * var_7_0
					end
				}
			}
		},
		content = {
			visible = false,
			text_shadow = "n/a",
			text = "n/a",
			bg_texture = "button_bg_01",
			glass = "athanor_panel_front_glass",
			glow = "tab_menu_glow",
			glass_top = "button_glass_01",
			icon = "icon_store_timer",
			glass_bottom = "button_glass_02",
			hotspot = {},
			frame = var_6_2.texture
		},
		style = {
			bg = {
				color = {
					255,
					66,
					0,
					0
				},
				offset = {
					0,
					0,
					1
				}
			},
			bg_texture = {
				color = {
					179,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				},
				texture_tiling_size = {
					480,
					270
				}
			},
			glass_top = {
				vertical_alignment = "top",
				texture_size = {
					var_6_0[1],
					5
				},
				offset = {
					0,
					0,
					3
				}
			},
			glass_bottom = {
				vertical_alignment = "bottom",
				texture_size = {
					var_6_0[1],
					5
				},
				offset = {
					0,
					0,
					3
				}
			},
			glass = {
				offset = {
					0,
					0,
					4
				}
			},
			glow = {
				offset = {
					0,
					0,
					5
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					44,
					46
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					12,
					0,
					6
				}
			},
			text = {
				font_size = 40,
				horizontal_alignment = "center",
				localize = false,
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					50,
					5,
					7
				},
				size = {
					var_6_0[1] - 100,
					var_6_0[2]
				}
			},
			text_shadow = {
				font_size = 40,
				horizontal_alignment = "center",
				localize = false,
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					51,
					4,
					6
				},
				size = {
					var_6_0[1] - 100,
					var_6_0[2]
				}
			},
			frame = {
				texture_size = var_6_2.texture_size,
				texture_sizes = var_6_2.texture_sizes,
				area_size = var_6_0,
				offset = {
					0,
					0,
					8
				}
			}
		}
	}
end

local var_0_6 = {
	slideshow = var_0_4("slideshow", {
		920,
		680
	})
}
local var_0_7 = {
	discount_banner = var_0_5("discount_banner"),
	skull_front_right = UIWidgets.create_simple_uv_texture("store_fence_skulls_front", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "skull_front_right"),
	skull_front_left = UIWidgets.create_simple_uv_texture("store_fence_skulls_front", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "skull_front_left"),
	skull_back_right = UIWidgets.create_simple_uv_texture("store_fence_skulls_back", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "skull_back_right"),
	skull_back_left = UIWidgets.create_simple_uv_texture("store_fence_skulls_back", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "skull_back_left"),
	login_rewards_button = var_0_3("login_rewards"),
	gotwf_rewards_button = var_0_3("login_rewards")
}
local var_0_8 = {
	on_enter = {
		{
			name = "fence_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				arg_8_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeOutCubic(arg_9_3)

				arg_9_4.render_settings.alpha_multiplier = var_9_0
			end,
			on_complete = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0.2,
			end_progress = 0.5,
			init = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				arg_11_3.render_settings.content_alpha_multiplier = 0
			end,
			update = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.content_alpha_multiplier = var_12_0
			end,
			on_complete = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				arg_14_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = math.easeOutCubic(arg_15_3)

				arg_15_4.render_settings.alpha_multiplier = 1 - var_15_0
			end,
			on_complete = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		}
	}
}
local var_0_9 = {
	default = {
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
	},
	featured = {
		{
			input_action = "trigger_cycle_previous",
			priority = 1,
			description_text = "input_description_previous"
		},
		{
			input_action = "trigger_cycle_next",
			priority = 2,
			description_text = "input_description_next"
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "buy_now"
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		},
		{
			input_action = "special_1",
			priority = 5,
			description_text = "store_login_claim_reward_title"
		}
	}
}

return {
	generic_input_actions = var_0_9,
	max_slideshow_items = var_0_1,
	widgets = var_0_7,
	content_widgets = var_0_6,
	scenegraph_definition = var_0_2,
	animation_definitions = var_0_8
}
