-- chunkname: @scripts/ui/views/popup_handler.lua

require("scripts/managers/input/mock_input_manager")
require("scripts/settings/ui_settings")
require("scripts/helpers/ui_atlas_helper")
require("scripts/helpers/ui_widget_utils")
require("scripts/helpers/ui_utils")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local var_0_0 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.popup + 1
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
			UILayer.popup
		},
		size = {
			1920,
			1080
		}
	},
	popup_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			100,
			1
		},
		size = {
			800,
			610
		}
	},
	title_box = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "center",
		size = {
			700,
			100
		},
		position = {
			0,
			-20,
			40
		}
	},
	popup_password_box = {
		vertical_alignment = "center",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			600,
			50
		}
	},
	popup_password_input = {
		vertical_alignment = "center",
		parent = "popup_password_box",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			580,
			40
		}
	},
	popup_password_text = {
		vertical_alignment = "bottom",
		parent = "popup_password_box",
		horizontal_alignment = "center",
		position = {
			0,
			50,
			2
		},
		size = {
			520,
			200
		}
	},
	popup_text_box = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			-120,
			1
		},
		size = {
			700,
			340
		}
	},
	popup_text = {
		vertical_alignment = "top",
		parent = "popup_text_box",
		horizontal_alignment = "center",
		position = {
			0,
			-35,
			2
		},
		size = {
			520,
			260
		}
	},
	buttons_root = {
		vertical_alignment = "bottom",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			83,
			1
		},
		size = {
			1,
			1
		}
	},
	button_1_1 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			270,
			70
		}
	},
	button_2_1 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			-170,
			0,
			1
		},
		size = {
			270,
			70
		}
	},
	button_2_2 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			170,
			0,
			1
		},
		size = {
			270,
			70
		}
	},
	button_3_1 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			-200,
			18,
			1
		},
		size = {
			270,
			70
		}
	},
	button_3_2 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			0,
			-15,
			1
		},
		size = {
			270,
			70
		}
	},
	button_3_3 = {
		vertical_alignment = "center",
		parent = "buttons_root",
		horizontal_alignment = "center",
		position = {
			200,
			18,
			1
		},
		size = {
			270,
			70
		}
	},
	timer = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "right"
	},
	center_timer = {
		vertical_alignment = "bottom",
		parent = "popup_text_box",
		horizontal_alignment = "center",
		position = {
			0,
			20,
			1
		},
		size = {
			700,
			30
		}
	}
}

local function var_0_1(arg_1_0, arg_1_1)
	local var_1_0 = "menu_frame_bg_01"
	local var_1_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_0)
	local var_1_2 = UIFrameSettings.menu_frame_11
	local var_1_3 = UIFrameSettings.menu_frame_06
	local var_1_4 = {
		element = {}
	}
	local var_1_5 = {
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "background_fade",
			texture_id = "background_fade"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "rect",
			style_id = "inner_rect"
		},
		{
			pass_type = "texture",
			style_id = "background_tint",
			texture_id = "background_tint"
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
			style_id = "text",
			pass_type = "text",
			text_id = "text_field"
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text_field"
		},
		{
			style_id = "timer",
			pass_type = "text",
			text_id = "timer_field"
		},
		{
			style_id = "timer_shadow",
			pass_type = "text",
			text_id = "timer_field"
		},
		{
			style_id = "center_timer",
			pass_type = "text",
			text_id = "center_timer_field"
		},
		{
			style_id = "center_timer_shadow",
			pass_type = "text",
			text_id = "center_timer_field"
		}
	}
	local var_1_6 = {
		timer_field = "",
		title_text = "",
		text_start_offset = 0,
		text_field = "",
		background_fade = "options_window_fade_01",
		background_tint = "gradient_dice_game_reward",
		center_timer_field = "",
		frame = var_1_2.texture,
		inner_frame = var_1_3.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_1_1[1] / var_1_1.size[1], 1),
					math.min(arg_1_1[2] / var_1_1.size[2], 1)
				}
			},
			texture_id = var_1_0
		}
	}
	local var_1_7 = {
		background = {
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
		},
		background_fade = {
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
			texture_size = var_1_2.texture_size,
			texture_sizes = var_1_2.texture_sizes,
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
		inner_rect = {
			scenegraph_id = "popup_text_box",
			color = {
				200,
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
		inner_frame = {
			scenegraph_id = "popup_text_box",
			texture_size = var_1_3.texture_size,
			texture_sizes = var_1_3.texture_sizes,
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
			}
		},
		background_tint = {
			scenegraph_id = "screen",
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		title_text = {
			word_wrap = false,
			scenegraph_id = "title_box",
			font_size = 50,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				0,
				0,
				6
			}
		},
		title_text_shadow = {
			word_wrap = false,
			scenegraph_id = "title_box",
			font_size = 50,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-2,
				5
			}
		},
		text = {
			word_wrap = true,
			scenegraph_id = "popup_text",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				0,
				6
			}
		},
		text_shadow = {
			word_wrap = true,
			scenegraph_id = "popup_text",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-2,
				5
			}
		},
		timer = {
			font_size = 36,
			scenegraph_id = "timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				320,
				203,
				8
			}
		},
		timer_shadow = {
			font_size = 36,
			scenegraph_id = "timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				322,
				201,
				7
			}
		},
		center_timer = {
			font_size = 44,
			scenegraph_id = "center_timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				0,
				6
			}
		},
		center_timer_shadow = {
			font_size = 44,
			scenegraph_id = "center_timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-2,
				5
			}
		}
	}

	var_1_4.element.passes = var_1_5
	var_1_4.content = var_1_6
	var_1_4.style = var_1_7
	var_1_4.offset = {
		0,
		0,
		0
	}
	var_1_4.scenegraph_id = arg_1_0

	return var_1_4
end

local function var_0_2(arg_2_0, arg_2_1)
	local var_2_0 = "menu_frame_bg_01"
	local var_2_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_2_0)
	local var_2_2 = UIFrameSettings.menu_frame_11
	local var_2_3 = UIFrameSettings.menu_frame_06
	local var_2_4 = UIFrameSettings.menu_frame_06
	local var_2_5 = {
		element = {}
	}
	local var_2_6 = {
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "background_fade",
			texture_id = "background_fade"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "rect",
			style_id = "inner_rect"
		},
		{
			pass_type = "texture",
			style_id = "background_tint",
			texture_id = "background_tint"
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
			style_id = "timer",
			pass_type = "text",
			text_id = "timer_field"
		},
		{
			style_id = "timer_shadow",
			pass_type = "text",
			text_id = "timer_field"
		},
		{
			style_id = "center_timer",
			pass_type = "text",
			text_id = "center_timer_field"
		},
		{
			style_id = "center_timer_shadow",
			pass_type = "text",
			text_id = "center_timer_field"
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field"
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text_field"
		},
		{
			pass_type = "keystrokes",
			input_text_id = "input"
		},
		{
			style_id = "input",
			pass_type = "text",
			text_id = "input"
		},
		{
			style_id = "input_shadow",
			pass_type = "text",
			text_id = "input"
		},
		{
			texture_id = "status_texture_glow",
			style_id = "status_texture_glow",
			pass_type = "texture",
			content_check_function = function(arg_3_0)
				return not arg_3_0.active
			end
		},
		{
			texture_id = "status_texture_frame",
			style_id = "status_texture_frame",
			pass_type = "texture",
			content_check_function = function(arg_4_0)
				return not arg_4_0.active
			end
		},
		{
			style_id = "placeholder_input",
			pass_type = "text",
			text_id = "placeholder_input",
			content_check_function = function(arg_5_0)
				return arg_5_0.input == ""
			end
		},
		{
			style_id = "placeholder_input_shadow",
			pass_type = "text",
			text_id = "placeholder_input",
			content_check_function = function(arg_6_0)
				return arg_6_0.input == ""
			end
		},
		{
			style_id = "status_message",
			pass_type = "text",
			text_id = "status_message",
			content_check_function = function(arg_7_0)
				return arg_7_0.status_message and not arg_7_0.error_message
			end
		},
		{
			style_id = "error_message",
			pass_type = "text",
			text_id = "status_message",
			content_check_function = function(arg_8_0)
				return arg_8_0.status_message and arg_8_0.error_message
			end
		},
		{
			style_id = "status_message_shadow",
			pass_type = "text",
			text_id = "status_message",
			content_check_function = function(arg_9_0)
				return arg_9_0.status_message
			end
		},
		{
			style_id = "checkbox_background",
			pass_type = "hotspot",
			content_id = "checkbox_hotspot",
			content_change_function = function(arg_10_0, arg_10_1)
				local var_10_0 = arg_10_1.parent

				if arg_10_0.on_pressed then
					arg_10_0.is_selected = not arg_10_0.is_selected

					if arg_10_0.is_selected then
						var_10_0.input.replacing_character = nil
						var_10_0.input_shadow.replacing_character = nil
					else
						var_10_0.input.replacing_character = "*"
						var_10_0.input_shadow.replacing_character = "*"
					end
				end
			end
		},
		{
			pass_type = "rect",
			style_id = "checkbox_background"
		},
		{
			pass_type = "texture_frame",
			style_id = "checkbox_frame",
			texture_id = "checkbox_frame"
		},
		{
			pass_type = "texture",
			style_id = "checkbox",
			texture_id = "checkbox",
			content_check_function = function(arg_11_0)
				return arg_11_0.checkbox_hotspot.is_selected
			end
		},
		{
			style_id = "checkbox_text",
			pass_type = "text",
			text_id = "checkbox_text"
		},
		{
			style_id = "checkbox_text_shadow",
			pass_type = "text",
			text_id = "checkbox_text"
		}
	}
	local var_2_7 = {
		checkbox_text = "popup_info_show_password",
		input = "",
		background_tint = "gradient_dice_game_reward",
		checkbox = "matchmaking_checkbox",
		text_field = "",
		input_mode = "insert",
		title_text = "",
		timer_field = "",
		text_start_offset = 0,
		text_index = 1,
		center_timer_field = "",
		status_texture_glow = "loading_title_divider",
		status_texture_frame = "loading_title_divider_background",
		background_fade = "options_window_fade_01",
		caret_index = 1,
		placeholder_input = "popup_info_type_password",
		active = true,
		checkbox_hotspot = {
			is_selected = false
		},
		checkbox_frame = var_2_4.texture,
		frame = var_2_2.texture,
		inner_frame = var_2_3.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_2_1[1] / var_2_1.size[1], 1),
					math.min(arg_2_1[2] / var_2_1.size[2], 1)
				}
			},
			texture_id = var_2_0
		}
	}
	local var_2_8 = {
		checkbox = {
			vertical_alignment = "top",
			scenegraph_id = "popup_password_box",
			horizontal_alignment = "right",
			texture_size = {
				22,
				16
			},
			offset = {
				0,
				27,
				6
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		checkbox_frame = {
			scenegraph_id = "popup_password_box",
			horizontal_alignment = "right",
			vertical_alignment = "top",
			area_size = {
				25,
				25
			},
			texture_size = var_2_4.texture_size,
			texture_sizes = var_2_4.texture_sizes,
			offset = {
				0,
				30,
				5
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		checkbox_background = {
			scenegraph_id = "popup_password_box",
			size = {
				25,
				25
			},
			offset = {
				575,
				55,
				5
			},
			color = {
				200,
				10,
				10,
				10
			}
		},
		checkbox_text = {
			word_wrap = true,
			scenegraph_id = "popup_password_box",
			localize = true,
			pixel_perfect = true,
			horizontal_alignment = "right",
			font_size = 18,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				-30,
				45,
				6
			}
		},
		checkbox_text_shadow = {
			word_wrap = true,
			scenegraph_id = "popup_password_box",
			localize = true,
			pixel_perfect = true,
			horizontal_alignment = "right",
			font_size = 18,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				-28,
				43,
				5
			}
		},
		text = {
			word_wrap = true,
			scenegraph_id = "popup_password_text",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				0,
				6
			}
		},
		text_shadow = {
			word_wrap = true,
			scenegraph_id = "popup_password_text",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-2,
				5
			}
		},
		error_message = {
			word_wrap = true,
			scenegraph_id = "popup_password_box",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("red", 255),
			offset = {
				0,
				-55,
				6
			}
		},
		status_message = {
			word_wrap = true,
			scenegraph_id = "popup_password_box",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				-55,
				6
			}
		},
		status_message_shadow = {
			word_wrap = true,
			scenegraph_id = "popup_password_box",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-57,
				5
			}
		},
		status_texture_frame = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				314,
				33
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				160,
				1
			}
		},
		status_texture_glow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				314,
				33
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				160,
				2
			}
		},
		background = {
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
		},
		background_fade = {
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
			texture_size = var_2_2.texture_size,
			texture_sizes = var_2_2.texture_sizes,
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
		inner_rect = {
			scenegraph_id = "popup_password_box",
			color = {
				200,
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
		inner_frame = {
			scenegraph_id = "popup_password_box",
			texture_size = var_2_3.texture_size,
			texture_sizes = var_2_3.texture_sizes,
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
			}
		},
		background_tint = {
			scenegraph_id = "screen",
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		title_text = {
			word_wrap = true,
			scenegraph_id = "title_box",
			font_size = 50,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				0,
				0,
				6
			}
		},
		title_text_shadow = {
			word_wrap = true,
			scenegraph_id = "title_box",
			font_size = 50,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-2,
				5
			}
		},
		placeholder_input = {
			word_wrap = false,
			scenegraph_id = "popup_password_input",
			localize = true,
			pixel_perfect = true,
			horizontal_alignment = "center",
			font_size = 28,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = {
				200,
				40,
				40,
				40
			},
			offset = {
				0,
				0,
				7
			}
		},
		placeholder_input_shadow = {
			word_wrap = false,
			scenegraph_id = "popup_password_input",
			localize = true,
			pixel_perfect = true,
			horizontal_alignment = "center",
			font_size = 28,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 200),
			offset = {
				2,
				-2,
				6
			}
		},
		input = {
			word_wrap = false,
			scenegraph_id = "popup_password_input",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			horizontal_scroll = true,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				10,
				6
			},
			caret_size = {
				3,
				35
			},
			caret_offset = {
				-5,
				-7,
				8
			},
			caret_color = Colors.get_color_table_with_alpha("gray", 255)
		},
		input_shadow = {
			word_wrap = false,
			scenegraph_id = "popup_password_input",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			horizontal_scroll = true,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				8,
				5
			},
			caret_size = {
				3,
				35
			},
			caret_offset = {
				-5,
				-9,
				7
			},
			caret_color = Colors.get_color_table_with_alpha("black", 255)
		},
		timer = {
			font_size = 36,
			scenegraph_id = "timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				320,
				203,
				8
			}
		},
		timer_shadow = {
			font_size = 36,
			scenegraph_id = "timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				322,
				201,
				7
			}
		},
		center_timer = {
			font_size = 44,
			scenegraph_id = "center_timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				0,
				6
			}
		},
		center_timer_shadow = {
			font_size = 44,
			scenegraph_id = "center_timer",
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-2,
				5
			}
		}
	}

	var_2_5.element.passes = var_2_6
	var_2_5.content = var_2_7
	var_2_5.style = var_2_8
	var_2_5.offset = {
		0,
		0,
		0
	}
	var_2_5.scenegraph_id = arg_2_0

	return var_2_5
end

local var_0_3 = var_0_1("popup_root", var_0_0.popup_root.size)
local var_0_4 = var_0_2("popup_root", var_0_0.popup_root.size)

local function var_0_5(arg_12_0, arg_12_1)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				}
			}
		},
		content = {
			text = "",
			input_action = arg_12_0
		},
		style = {
			text = {
				vertical_alignment = "center",
				font_size = 24,
				font_type = "hell_shark",
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				},
				scenegraph_id = arg_12_1
			},
			icon = {
				size = {
					34,
					34
				},
				offset = {
					0,
					15,
					1
				},
				scenegraph_id = arg_12_1
			}
		},
		scenegraph_id = arg_12_1
	}
end

PopupHandler = class(PopupHandler)

function PopupHandler.init(arg_13_0, arg_13_1, arg_13_2)
	fassert(arg_13_2, "Not created by the popoup manager")

	arg_13_0.ui_renderer = arg_13_1.ui_renderer
	arg_13_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_13_0.wwise_world = Managers.world:wwise_world(arg_13_1.world)
	arg_13_0.debug_num_updates = 0
	arg_13_0.popup_results = {}
	arg_13_0.popups = {}
	arg_13_0.n_popups = 0
	arg_13_0.popup_ids = 0

	arg_13_0:create_ui_elements()

	arg_13_0.gamepad_button_colors = {
		enabled = Colors.get_color_table_with_alpha("white", 255),
		disabled = Colors.get_color_table_with_alpha("gray", 255)
	}
	arg_13_0.mock_input_manager = MockInputManager:new()
end

function PopupHandler.set_input_manager(arg_14_0, arg_14_1)
	arg_14_0.input_manager = arg_14_1

	local var_14_0 = {
		popup = true
	}

	arg_14_1:create_input_service("popup", "IngameMenuKeymaps", "IngameMenuFilters", var_14_0)
	arg_14_1:map_device_to_service("popup", "keyboard")
	arg_14_1:map_device_to_service("popup", "mouse")
	arg_14_1:map_device_to_service("popup", "gamepad")

	if arg_14_0:has_popup() then
		arg_14_0:acquire_input()
	end
end

function PopupHandler.get_input_manager(arg_15_0)
	return arg_15_0.input_manager
end

function PopupHandler.remove_input_manager(arg_16_0, arg_16_1)
	if arg_16_0:has_popup() then
		arg_16_0:release_input()
	end

	if not arg_16_1 and arg_16_0:has_popup() then
		local var_16_0, var_16_1 = arg_16_0:active_popup()

		error(string.format("Trying to proceed to next gamestate without handling popup %q: %q", var_16_1.topic or "nil", var_16_1.text or "nil"))
	end

	arg_16_0.input_manager = nil
end

function PopupHandler.create_ui_elements(arg_17_0)
	arg_17_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0)
	arg_17_0._popup_widgets_by_name = {
		default = UIWidget.init(var_0_3),
		password = UIWidget.init(var_0_4)
	}

	local var_17_0 = {
		{},
		{},
		{}
	}
	local var_17_1 = {
		{},
		{},
		{}
	}
	local var_17_2 = true
	local var_17_3

	var_17_0[1][1] = UIWidget.init(UIWidgets.create_default_button("button_1_1", var_0_0.button_1_1.size, "n/a", var_17_3))
	var_17_0[2][1] = UIWidget.init(UIWidgets.create_default_button("button_2_1", var_0_0.button_2_1.size, "n/a", var_17_3))
	var_17_0[2][2] = UIWidget.init(UIWidgets.create_default_button("button_2_2", var_0_0.button_2_2.size, "n/a", var_17_3))
	var_17_0[3][1] = UIWidget.init(UIWidgets.create_default_button("button_3_1", var_0_0.button_3_1.size, "n/a", var_17_3))
	var_17_0[3][2] = UIWidget.init(UIWidgets.create_default_button("button_3_2", var_0_0.button_3_2.size, "n/a", var_17_3))
	var_17_0[3][3] = UIWidget.init(UIWidgets.create_default_button("button_3_3", var_0_0.button_3_3.size, "n/a", var_17_3))
	var_17_1[1][1] = UIWidget.init(var_0_5("confirm_press", "button_1_1"))
	var_17_1[2][1] = UIWidget.init(var_0_5("confirm_press", "button_2_1"))
	var_17_1[2][2] = UIWidget.init(var_0_5("back", "button_2_2"))
	var_17_1[3][1] = UIWidget.init(var_0_5("confirm_press", "button_3_1"))
	var_17_1[3][2] = UIWidget.init(var_0_5("back", "button_3_2"))
	var_17_1[3][3] = UIWidget.init(var_0_5("refresh", "button_3_3"))
	arg_17_0.button_widgets = var_17_0
	arg_17_0.gamepad_button_widgets = var_17_1
end

function PopupHandler.acquire_input(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.input_manager

	arg_18_0:release_input(true)
	var_18_0:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "popup", "PopupHandler")

	if not arg_18_1 then
		ShowCursorStack.show("PopupHandler")
	end
end

function PopupHandler.release_input(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.input_manager
	local var_19_1 = "popup"

	var_19_0:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "popup", "PopupHandler", var_19_1)

	if not arg_19_1 then
		ShowCursorStack.hide("PopupHandler")
	end
end

function PopupHandler.update(arg_20_0, arg_20_1, arg_20_2)
	fassert(arg_20_2, "Update does not come from the popup manager")

	arg_20_0.debug_num_updates = arg_20_0.debug_num_updates + 1

	local var_20_0 = arg_20_0.n_popups
	local var_20_1 = arg_20_0.popups[var_20_0]

	if var_20_1 then
		if not var_20_1.initialized then
			arg_20_0:_initialize_popup(var_20_1)
		end

		local var_20_2 = arg_20_0.ui_renderer
		local var_20_3 = arg_20_0.input_manager or arg_20_0.mock_input_manager
		local var_20_4 = var_20_3:get_service("popup")
		local var_20_5 = var_20_3:is_device_active("gamepad")
		local var_20_6 = var_20_1.widget

		var_20_6.style.text.font_size = var_20_1.text_font_size
		var_20_6.style.text_shadow.font_size = var_20_1.text_font_size
		var_20_6.content.text_field = var_20_1.text
		var_20_6.content.title_text = var_20_1.topic

		local var_20_7

		if var_20_1.timer then
			local var_20_8 = string.format("%d", math.floor(var_20_1.timer))

			if var_20_1.timer_format_func then
				var_20_8 = var_20_1.timer_format_func(var_20_8)
			end

			local var_20_9
			local var_20_10
			local var_20_11

			if var_20_1.timer_alignment == "center" then
				var_20_6.content.center_timer_field = var_20_8
				var_20_10 = var_20_6.style.center_timer

				local var_20_12 = var_20_6.style.center_timer_shadow

				var_20_6.content.timer_field = ""
			else
				var_20_6.content.center_timer_field = ""
				var_20_6.content.timer_field = var_20_8
				var_20_10 = var_20_6.style.timer

				local var_20_13 = var_20_6.style.timer_shadow
			end

			if var_20_1.timer_font_size then
				var_20_6.style.timer.font_size = var_20_1.timer_font_size
				var_20_6.style.center_timer.font_size = var_20_1.timer_font_size
			end

			if var_20_1.timer_blink then
				var_20_10.text_color = Colors.lerp_color_tables(Colors.get_color_table_with_alpha("white", 255), Colors.get_color_table_with_alpha("cheeseburger", 255), var_20_1.timer % 15 % 1)
			end

			var_20_1.timer = var_20_1.timer - arg_20_1

			if var_20_1.timer <= 0 then
				var_20_7 = var_20_1.default_result
			end
		else
			var_20_6.content.timer_field = ""
			var_20_6.content.center_timer_field = ""
			var_20_6.style.timer.font_size = 36
			var_20_6.style.center_timer.font_size = 44
		end

		UIRenderer.begin_pass(var_20_2, arg_20_0.ui_scenegraph, var_20_4, arg_20_1, nil, arg_20_0.render_settings)
		UIRenderer.draw_widget(var_20_2, var_20_6)

		local var_20_14 = var_20_1.n_args

		if var_20_14 then
			local var_20_15 = var_20_1.args
			local var_20_16 = arg_20_0.button_widgets[var_20_14]
			local var_20_17 = arg_20_0.gamepad_button_widgets[var_20_14]

			for iter_20_0 = 1, var_20_14 do
				local var_20_18 = " " .. var_20_15[iter_20_0 * 2]
				local var_20_19 = var_20_1.button_enabled_state[iter_20_0] == true

				if var_20_5 then
					local var_20_20 = var_20_17[iter_20_0]
					local var_20_21 = var_20_20.content
					local var_20_22 = var_20_21.input_action

					if not var_20_21.icon then
						var_20_21.icon = arg_20_0:get_gamepad_input_texture_data(var_20_4, var_20_22).texture
					end

					var_20_21.text = var_20_18

					local var_20_23 = var_20_20.style
					local var_20_24 = var_20_23.text

					var_20_24.text_color = var_20_19 and arg_20_0.gamepad_button_colors.enabled or arg_20_0.gamepad_button_colors.disabled

					local var_20_25, var_20_26 = UIFontByResolution(var_20_24)
					local var_20_27, var_20_28, var_20_29 = UIRenderer.text_size(var_20_2, var_20_18, var_20_25[1], var_20_26)

					var_20_23.icon.offset[1] = 80 - var_20_27 * 0.5

					UIRenderer.draw_widget(var_20_2, var_20_20)

					if var_20_4:get(var_20_22, true) then
						var_20_7 = var_20_15[iter_20_0 * 2 - 1]

						arg_20_0:play_sound("Play_hud_select")
					end
				else
					local var_20_30 = var_20_16[iter_20_0]

					UIWidgetUtils.animate_default_button(var_20_30, arg_20_1)

					var_20_30.content.title_text = var_20_18

					local var_20_31 = var_20_30.content.button_hotspot

					var_20_31.disable_button = not var_20_19

					UIRenderer.draw_widget(var_20_2, var_20_30)

					if var_20_31.on_hover_enter then
						arg_20_0:play_sound("Play_hud_hover")
					end

					if var_20_31.on_release then
						table.clear(var_20_30.content.button_hotspot)

						var_20_7 = var_20_15[iter_20_0 * 2 - 1]

						arg_20_0:play_sound("Play_hud_select")
					end

					var_20_7 = var_20_7 or arg_20_0:_handle_keyboard_input(var_20_1)
				end
			end
		end

		if var_20_7 then
			local var_20_32
			local var_20_33 = var_20_1.result_param_ids

			if var_20_33 then
				var_20_32 = {}

				local var_20_34 = var_20_6.content

				for iter_20_1, iter_20_2 in ipairs(var_20_33) do
					var_20_32[iter_20_2] = var_20_34[iter_20_2]
				end
			end

			arg_20_0.popup_results[var_20_1.popup_id] = {
				var_20_7,
				var_20_32
			}

			local var_20_35 = var_20_0 - 1

			arg_20_0.n_popups = var_20_35

			if var_20_35 == 0 then
				arg_20_0:release_input()
			end
		end

		UIRenderer.end_pass(var_20_2)
	end
end

function PopupHandler._handle_keyboard_input(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1.n_args
	local var_21_1 = arg_21_0.button_widgets[var_21_0]

	if Managers.input:is_device_active("mouse") then
		for iter_21_0, iter_21_1 in pairs(var_21_1) do
			iter_21_1.content.button_hotspot.is_selected = false
		end

		arg_21_1.button_index = nil

		return
	end

	local var_21_2 = arg_21_1.button_index or 1
	local var_21_3 = Managers.input:get_service("popup")

	if var_21_3:get("move_right_hold_continuous") then
		var_21_2 = math.clamp(var_21_2 + 1, 1, var_21_0)
	elseif var_21_3:get("move_left_hold_continuous") then
		var_21_2 = math.clamp(var_21_2 - 1, 1, var_21_0)
	elseif var_21_3:get("confirm_press") and arg_21_1.button_enabled_state[var_21_2] then
		local var_21_4 = arg_21_1.args

		arg_21_0:play_sound("Play_hud_select")
		print("Popup Choice:", var_21_4[var_21_2 * 2 - 1])

		arg_21_1.button_index = nil

		return var_21_4[var_21_2 * 2 - 1]
	end

	if var_21_2 ~= arg_21_1.button_index then
		for iter_21_2, iter_21_3 in ipairs(var_21_1) do
			iter_21_3.content.button_hotspot.is_selected = var_21_2 == iter_21_2
		end

		arg_21_1.button_index = var_21_2

		arg_21_0:play_sound("Play_hud_hover")
	end
end

function PopupHandler.get_gamepad_input_texture_data(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = PLATFORM

	if IS_WINDOWS then
		var_22_0 = "xb1"
	end

	if arg_22_3 then
		return ButtonTextureByName(arg_22_2, var_22_0)
	else
		return UISettings.get_gamepad_input_texture_data(arg_22_1, arg_22_2, true)
	end
end

function PopupHandler.set_button_enabled(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0

	for iter_23_0 = 1, arg_23_0.n_popups do
		local var_23_1 = arg_23_0.popups[iter_23_0]

		if var_23_1.popup_id == arg_23_1 then
			var_23_0 = var_23_1
		end
	end

	var_23_0.button_enabled_state[arg_23_2] = arg_23_3
end

function PopupHandler.active_popup(arg_24_0)
	local var_24_0 = arg_24_0.popups[arg_24_0.n_popups]

	if var_24_0 then
		return var_24_0.popup_id, var_24_0
	end
end

function PopupHandler.queue_popup(arg_25_0, arg_25_1, arg_25_2, arg_25_3, ...)
	local var_25_0 = arg_25_0.n_popups
	local var_25_1 = arg_25_0.popups
	local var_25_2 = var_25_0 + 1

	arg_25_0.n_popups = var_25_2

	local var_25_3 = var_25_1[var_25_2] or {
		args = {}
	}

	arg_25_0.popup_ids = arg_25_0.popup_ids + 1

	local var_25_4 = tostring(arg_25_0.popup_ids)

	var_25_3.popup_id = var_25_4

	local var_25_5 = arg_25_0._popup_widgets_by_name[arg_25_1]
	local var_25_6 = var_25_5.style.text
	local var_25_7 = UIScaleVectorToResolution(var_0_0.popup_text.size)

	var_25_3.text_font_size = arg_25_0:get_number_of_rows(arg_25_2, var_25_6, var_25_7[1]) >= 7 and 20 or 28
	var_25_3.text = arg_25_2
	var_25_3.topic = arg_25_3
	var_25_3.widget = var_25_5
	var_25_3.type = arg_25_1

	local var_25_8 = select("#", ...)

	assert(math.floor(var_25_8 / 2) * 2 == var_25_8, "Need one action for each button text")
	assert(var_25_8 > 0, "Need at least one button...")

	var_25_3.n_args = var_25_8 / 2
	var_25_3.button_enabled_state = {}

	for iter_25_0 = 1, var_25_3.n_args do
		var_25_3.button_enabled_state[iter_25_0] = true
	end

	var_25_3.timer = nil
	var_25_3.default_result = nil

	pack_index[var_25_8](var_25_3.args, 1, ...)

	local var_25_9 = var_25_2 > 1

	if arg_25_0.input_manager then
		arg_25_0:acquire_input(var_25_9)
	end

	var_25_1[var_25_2] = var_25_3

	arg_25_0:_reset_popup_initialized()

	return var_25_4
end

function PopupHandler._initialize_popup(arg_26_0, arg_26_1)
	if arg_26_1.type == "password" then
		arg_26_0:_initialize_password_popup(arg_26_1)
	end

	arg_26_1.initialized = true
end

function PopupHandler._initialize_password_popup(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_1.widget
	local var_27_1 = var_27_0.content
	local var_27_2 = var_27_0.style

	var_27_1.input = ""
	var_27_1.active = true
	var_27_1.text_index = 1
	var_27_1.caret_index = 1
	var_27_1.input_mode = "insert"
	var_27_1.status_message = nil
	var_27_1.error_message = nil

	table.clear(var_27_1.checkbox_hotspot)

	var_27_2.input.replacing_character = "*"
	var_27_2.input_shadow.replacing_character = "*"
	var_27_2.input.input_color = Colors.get_color_table_with_alpha("font_default", 255)

	local var_27_3 = var_27_0.animations
	local var_27_4 = arg_27_0:_animate_element_pulse(var_27_2.input.caret_color, 1, 60, 255, 2)
	local var_27_5 = arg_27_0:_animate_element_pulse(var_27_2.input_shadow.caret_color, 1, 60, 255, 2)

	var_27_3[var_27_4] = true
	var_27_3[var_27_5] = true
	arg_27_1.result_param_ids = {
		"input"
	}
	arg_27_1.initialized = true
end

function PopupHandler.set_popup_verifying_password(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	local var_28_0, var_28_1 = arg_28_0:active_popup()

	if var_28_0 ~= arg_28_1 then
		return
	end

	local var_28_2 = var_28_1.widget
	local var_28_3 = var_28_2.content

	var_28_3.status_message = arg_28_4 or arg_28_3
	var_28_3.error_message = arg_28_4
	var_28_3.active = not arg_28_2

	local var_28_4 = var_28_2.animations

	table.clear(var_28_4)

	local var_28_5 = var_28_2.style.input.caret_color
	local var_28_6 = var_28_2.style.input_shadow.caret_color
	local var_28_7 = var_28_2.style.input.text_color

	if arg_28_2 then
		var_28_5[1] = 0
		var_28_6[1] = 0
		var_28_7[1] = 200
		var_28_7[2] = 40
		var_28_7[3] = 40
		var_28_7[4] = 40
	else
		local var_28_8 = arg_28_0:_animate_element_pulse(var_28_5, 1, 60, 255, 2)
		local var_28_9 = arg_28_0:_animate_element_pulse(var_28_6, 1, 60, 255, 2)

		var_28_4[var_28_8] = true
		var_28_4[var_28_9] = true

		local var_28_10 = Colors.get_color_table_with_alpha("font_default", 255)

		var_28_7[1] = var_28_10[1]
		var_28_7[2] = var_28_10[2]
		var_28_7[3] = var_28_10[3]
		var_28_7[4] = var_28_10[4]
	end

	local var_28_11 = var_28_1.n_args

	for iter_28_0 = 1, var_28_11 do
		arg_28_0:set_button_enabled(arg_28_1, iter_28_0, not arg_28_2)
	end
end

function PopupHandler._animate_element_pulse(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5))
end

function PopupHandler.activate_timer(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7)
	local var_30_0 = arg_30_0.n_popups
	local var_30_1 = arg_30_0.popups
	local var_30_2

	for iter_30_0 = 1, var_30_0 do
		local var_30_3 = var_30_1[iter_30_0]

		if var_30_3.popup_id == arg_30_1 then
			var_30_2 = var_30_3
		end
	end

	assert(var_30_2, string.format("[PopupHandler:activate_timer] There is no popup with id %s", arg_30_1))

	local var_30_4

	for iter_30_1, iter_30_2 in ipairs(var_30_2.args) do
		if iter_30_2 == arg_30_3 then
			var_30_4 = iter_30_1

			break
		end
	end

	if arg_30_3 == "timeout" then
		var_30_4 = 1
	end

	assert(var_30_4, string.format("[PopupHandler:activate_timer] There is no result named %s in popup declaration %s", arg_30_3, var_30_2.topic))
	assert(var_30_4 % 2 == 1, string.format("[PopupHandler:activate_timer] You need to pass the result - not the text %s in popup declaration %s", arg_30_3, var_30_2.topic))

	var_30_2.timer = arg_30_2
	var_30_2.default_result = arg_30_3
	var_30_2.timer_alignment = arg_30_4 or "right"
	var_30_2.timer_blink = arg_30_5 == nil and true or arg_30_5
	var_30_2.timer_format_func = arg_30_6
	var_30_2.timer_font_size = arg_30_7
end

function PopupHandler.has_popup(arg_31_0)
	return arg_31_0.n_popups > 0
end

function PopupHandler.has_popup_with_id(arg_32_0, arg_32_1)
	for iter_32_0, iter_32_1 in pairs(arg_32_0.popups) do
		if iter_32_1.popup_id == arg_32_1 then
			return true
		end
	end

	return false
end

function PopupHandler._reset_popup_initialized(arg_33_0)
	for iter_33_0, iter_33_1 in pairs(arg_33_0.popups) do
		iter_33_1.initialized = false
	end
end

function PopupHandler.cancel_popup(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.n_popups
	local var_34_1 = arg_34_0.popups

	for iter_34_0 = 1, var_34_0 do
		local var_34_2 = var_34_1[iter_34_0]

		if var_34_2.popup_id == arg_34_1 then
			var_34_1[iter_34_0], var_34_1[var_34_0] = var_34_1[var_34_0], var_34_2
			arg_34_0.n_popups = var_34_0 - 1

			if arg_34_0.n_popups == 0 then
				arg_34_0:release_input()
			end

			return
		end
	end
end

function PopupHandler.cancel_all_popups(arg_35_0)
	local var_35_0 = arg_35_0.n_popups
	local var_35_1 = arg_35_0.popups

	for iter_35_0 = 1, var_35_0 do
		var_35_1[iter_35_0] = nil
	end

	if var_35_0 > 0 then
		arg_35_0:release_input()
	end

	arg_35_0.n_popups = 0
end

function PopupHandler.query_result(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0.popup_results[arg_36_1]

	arg_36_0.popup_results[arg_36_1] = nil

	if var_36_0 then
		return unpack(var_36_0)
	end
end

function PopupHandler.play_sound(arg_37_0, arg_37_1)
	WwiseWorld.trigger_event(arg_37_0.wwise_world, arg_37_1)
end

function PopupHandler.fit_text_width_to_popup(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._popup_widgets_by_name.default

	return UIRenderer.crop_text_width(arg_38_0.ui_renderer, arg_38_1, 500, var_38_0.style.text)
end

function PopupHandler.get_number_of_rows(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0, var_39_1 = UIFontByResolution(arg_39_2)

	return #UIRenderer.word_wrap(arg_39_0.ui_renderer, arg_39_1, var_39_0[1], var_39_1, arg_39_3)
end
