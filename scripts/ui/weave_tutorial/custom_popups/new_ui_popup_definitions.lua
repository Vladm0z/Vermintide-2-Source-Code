-- chunkname: @scripts/ui/weave_tutorial/custom_popups/new_ui_popup_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 50
local var_0_3 = 1200
local var_0_4 = var_0_3 - var_0_2 * 2
local var_0_5 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.item_display_popup
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
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
	window = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			var_0_3,
			650
		}
	},
	video = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			100,
			0
		},
		size = {
			640,
			360
		}
	},
	expanded_video = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			200
		},
		size = {
			1920,
			1080
		}
	},
	window_top_detail = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			30
		},
		size = {
			45,
			12
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-30,
			1
		},
		size = {
			var_0_4,
			60
		}
	},
	sub_title = {
		vertical_alignment = "top",
		parent = "title",
		horizontal_alignment = "center",
		position = {
			0,
			-40,
			0
		},
		size = {
			var_0_4,
			50
		}
	},
	body = {
		vertical_alignment = "top",
		parent = "sub_title",
		horizontal_alignment = "center",
		position = {
			0,
			-60,
			0
		},
		size = {
			var_0_4,
			380
		}
	},
	perks = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-325,
			0
		},
		size = {
			var_0_4,
			380
		}
	},
	perk_list = {
		vertical_alignment = "top",
		parent = "perks",
		horizontal_alignment = "center",
		position = {
			100,
			-50,
			0
		},
		size = {
			700,
			380
		}
	},
	use_legacy = {
		vertical_alignment = "top",
		parent = "sub_title",
		horizontal_alignment = "center",
		position = {
			0,
			-20,
			0
		},
		size = {
			var_0_4,
			380
		}
	},
	use_legacy_option = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			70,
			0
		},
		size = {
			var_0_4,
			380
		}
	},
	paragraph_divider = {
		vertical_alignment = "top",
		parent = "body",
		horizontal_alignment = "center",
		position = {
			0,
			-150,
			0
		},
		size = {
			400,
			8
		}
	},
	next_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-20,
			10
		},
		size = {
			160,
			50
		}
	},
	prev_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			-100,
			-20,
			10
		},
		size = {
			160,
			50
		}
	},
	ok_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			100,
			-20,
			10
		},
		size = {
			160,
			50
		}
	}
}
local var_0_6 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 64,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("orange", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_7 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_8 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_9 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("orange", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 40,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_11 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_12 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_13 = true

local function var_0_14(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = UIWidgets.create_default_button(arg_1_0, arg_1_1, "button_detail_03_gold", "button_bg_01", arg_1_2, nil, nil, "button_detail_03_gold", nil, var_0_13)

	var_1_0.content.draw_frame = false

	local var_1_1 = var_1_0.style

	var_1_1.background.size = {
		arg_1_1[1],
		arg_1_1[2] - 8
	}
	var_1_1.background.offset = {
		0,
		4,
		0
	}
	var_1_1.background_fade.offset = {
		0,
		4,
		2
	}
	var_1_1.background_fade.size = {
		arg_1_1[1],
		arg_1_1[2] - 8
	}
	var_1_1.hover_glow.offset = {
		0,
		5,
		3
	}
	var_1_1.clicked_rect.offset = {
		0,
		4,
		7
	}
	var_1_1.clicked_rect.size = {
		arg_1_1[1],
		arg_1_1[2] - 8
	}
	var_1_1.glass_top.offset = {
		0,
		arg_1_1[2] - 16,
		4
	}
	var_1_1.glass_bottom.offset = {
		0,
		-4,
		4
	}

	return var_1_0
end

local function var_0_15()
	local var_2_0 = "video"

	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "icon",
					texture_id = "icon",
					pass_type = "texture",
					content_change_function = function(arg_3_0, arg_3_1)
						local var_3_0 = arg_3_0.button_hotspot.is_hover and 1 or -1
						local var_3_1 = Managers.time:mean_dt()
						local var_3_2 = arg_3_1.progress
						local var_3_3 = math.clamp(var_3_2 + var_3_1 * var_3_0 * 2, 0, 1)

						if var_3_0 then
							arg_3_1.color[1] = math.easeOutCubic(var_3_3) * 255
						else
							arg_3_1.color[1] = math.easeInCubic(var_3_3) * 255
						end

						arg_3_1.progress = var_3_3
					end
				}
			}
		},
		content = {
			icon = "expand_video_icon",
			button_hotspot = {}
		},
		style = {
			button_hotspot = {},
			icon = {
				vertical_alignment = "center",
				progress = 0,
				horizontal_alignment = "center",
				texture_size = {
					85,
					84
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
					1
				}
			}
		},
		scenegraph_id = var_2_0
	}
end

local var_0_16 = {
	window_background = UIWidgets.create_tiled_texture("window", "menu_frame_bg_02", {
		1065,
		770
	}),
	window_top_detail = UIWidgets.create_simple_texture("tab_selection_01_bottom", "window_top_detail"),
	window_frame = UIWidgets.create_frame("window", var_0_5.window.size, "menu_frame_12_gold", 5),
	screen_background = UIWidgets.create_simple_rect("screen", {
		150,
		0,
		0,
		0
	})
}
local var_0_17 = {
	title_text = UIWidgets.create_simple_text(Localize("new_ui_popup_title"), "title", nil, nil, var_0_6),
	paragraph_divider = UIWidgets.create_simple_texture("popup_divider", "paragraph_divider"),
	info_text = UIWidgets.create_simple_text(Localize("new_ui_popup_info"), "body", nil, nil, var_0_7),
	perk_text = UIWidgets.create_simple_text(Localize("new_ui_popup_perks"), "perks", nil, nil, var_0_8),
	perk_list = UIWidgets.create_simple_text(Localize("new_ui_popup_perk_list"), "perk_list", nil, nil, var_0_9),
	use_legacy_title_text = UIWidgets.create_simple_text(Localize("new_ui_popup_legacy_title"), "title", nil, nil, var_0_10),
	use_legacy_text = UIWidgets.create_simple_text(Localize("new_ui_popup_legacy_text"), "use_legacy", nil, nil, var_0_11),
	use_legacy_option = UIWidgets.create_simple_text(Localize("new_ui_popup_legacy_option"), "use_legacy_option", nil, nil, var_0_12),
	video_frame = UIWidgets.create_frame("video", var_0_5.video.size, "menu_frame_12_gold", 10, {
		255,
		0,
		0,
		0
	}),
	video_hover = var_0_15(),
	prev_button = var_0_14("prev_button", var_0_5.prev_button.size, Localize("input_description_prev_page")),
	next_button = var_0_14("next_button", var_0_5.next_button.size, Localize("input_description_next_page")),
	ok_button = var_0_14("ok_button", var_0_5.ok_button.size, Localize("menu_weave_tutorial_popup_confirm_button"))
}
local var_0_18 = {
	{
		widgets = {
			"title_text",
			"info_text",
			"paragraph_divider",
			"perk_text",
			"perk_list"
		}
	},
	{
		widgets = {
			"use_legacy_title_text",
			"use_legacy_text",
			"use_legacy_option",
			"video_frame",
			"video_hover"
		},
		video = {
			video_name = "video/ui_option",
			loop = true,
			material_name = "ui_option"
		}
	}
}
local var_0_19 = {
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.2,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 0

				local var_4_0 = arg_4_3.page_data

				for iter_4_0, iter_4_1 in ipairs(var_4_0.widgets) do
					arg_4_2[iter_4_1].content.visible = false
				end
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = var_5_0
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	},
	page_1 = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				arg_7_3.render_settings.alpha_multiplier = 0

				local var_7_0 = arg_7_3.page_data

				for iter_7_0, iter_7_1 in ipairs(var_7_0.widgets) do
					arg_7_2[iter_7_1].content.visible = false
				end

				arg_7_2.next_button.content.visible = false
				arg_7_2.prev_button.content.visible = false
				arg_7_2.ok_button.content.visible = false
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeOutCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = var_8_0
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				arg_9_2.title_text.content.visible = true
			end
		},
		{
			name = "header",
			start_progress = 0.5,
			end_progress = 0.8,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = math.easeOutCubic(arg_11_3)
				local var_11_1 = arg_11_2.title_text

				var_11_1.style.text.text_color[1] = var_11_0 * 255
				var_11_1.style.text_shadow.text_color[1] = var_11_0 * 255
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				arg_12_2.info_text.content.visible = true
				arg_12_2.paragraph_divider.content.visible = true
			end
		},
		{
			name = "info",
			start_progress = 0.8,
			end_progress = 2.8,
			init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end,
			update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = math.easeOutCubic(arg_14_3)
				local var_14_1 = arg_14_2.info_text

				var_14_1.style.text.text_color[1] = var_14_0 * 255
				var_14_1.style.text_shadow.text_color[1] = var_14_0 * 255
				arg_14_2.paragraph_divider.style.texture_id.color[1] = var_14_0 * 255
			end,
			on_complete = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		},
		{
			name = "perks",
			start_progress = 3.5,
			end_progress = 4,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = math.easeOutCubic(arg_17_3)
				local var_17_1 = arg_17_2.perk_text

				var_17_1.content.visible = true
				var_17_1.style.text.text_color[1] = var_17_0 * 255
				var_17_1.style.text_shadow.text_color[1] = var_17_0 * 255
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_2.perk_list.content.visible = true
			end
		},
		{
			name = "perk_list",
			start_progress = 4,
			end_progress = 5,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = math.easeOutCubic(arg_20_3)
				local var_20_1 = arg_20_2.perk_list

				var_20_1.style.text.text_color[1] = var_20_0 * 255
				var_20_1.style.text_shadow.text_color[1] = var_20_0 * 255
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				arg_21_2.next_button.content.visible = true
			end
		}
	},
	page_2 = {
		{
			name = "header",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				local var_22_0 = arg_22_3.page_data

				for iter_22_0, iter_22_1 in ipairs(var_22_0.widgets) do
					arg_22_2[iter_22_1].content.visible = false
				end

				arg_22_2.prev_button.content.visible = false
				arg_22_2.ok_button.content.visible = false
				arg_22_3.video_widget.content.visible = false
				arg_22_2.use_legacy_title_text.content.visible = true
			end,
			update = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				local var_23_0 = math.easeOutCubic(arg_23_3)
				local var_23_1 = arg_23_2.use_legacy_title_text

				var_23_1.style.text.text_color[1] = var_23_0 * 255
				var_23_1.style.text_shadow.text_color[1] = var_23_0 * 255
			end,
			on_complete = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				arg_24_2.use_legacy_text.content.visible = true
			end
		},
		{
			name = "info",
			start_progress = 0.5,
			end_progress = 1.8,
			init = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end,
			update = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				local var_26_0 = math.easeOutCubic(arg_26_3)
				local var_26_1 = arg_26_2.use_legacy_text

				var_26_1.style.text.text_color[1] = var_26_0 * 255
				var_26_1.style.text_shadow.text_color[1] = var_26_0 * 255
			end,
			on_complete = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				arg_27_2.use_legacy_option.content.visible = true
				arg_27_2.video_frame.content.visible = true
				arg_27_2.video_hover.content.visible = true
				arg_27_3.video_widget.content.visible = true
			end
		},
		{
			name = "video",
			start_progress = 1.8,
			end_progress = 3.5,
			init = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end,
			update = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				local var_29_0 = math.easeOutCubic(arg_29_3)

				arg_29_2.video_frame.style.frame.color[1] = var_29_0 * 255

				local var_29_1 = arg_29_2.use_legacy_option

				var_29_1.style.text.text_color[1] = var_29_0 * 255
				var_29_1.style.text_shadow.text_color[1] = var_29_0 * 255
				arg_29_4.video_widget.style.video_style.color[1] = var_29_0 * 255
			end,
			on_complete = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				arg_30_2.prev_button.content.visible = true
				arg_30_2.ok_button.content.visible = true
			end
		}
	}
}
local var_0_20 = {
	default = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "button_ok"
		}
	}
}

return {
	create_video = create_video,
	page_data = var_0_18,
	generic_input_actions = var_0_20,
	scenegraph_definition = var_0_5,
	base_widget_definitions = var_0_16,
	page_widget_definitions = var_0_17,
	animation_definitions = var_0_19
}
