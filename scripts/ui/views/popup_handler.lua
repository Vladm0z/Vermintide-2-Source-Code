-- chunkname: @scripts/ui/views/popup_handler.lua

require("scripts/managers/input/mock_input_manager")
require("scripts/settings/ui_settings")
require("scripts/helpers/ui_atlas_helper")
require("scripts/helpers/ui_widget_utils")
require("scripts/helpers/ui_utils")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local tbl = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local str = "menu_frame_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local menu_frame_11 = UIFrameSettings.menu_frame_11
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
	local tbl_3 = {
		timer_field = "",
		title_text = "",
		text_start_offset = 0,
		text_field = "",
		background_fade = "options_window_fade_01",
		background_tint = "gradient_dice_game_reward",
		center_timer_field = "",
		frame = menu_frame_11.texture,
		inner_frame = menu_frame_06.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_1_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
					math.min(arg_1_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
				}
			},
			texture_id = str
		}
	}
	local tbl_4 = {
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
			texture_size = menu_frame_11.texture_size,
			texture_sizes = menu_frame_11.texture_sizes,
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
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_1_0

	return tbl
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local str = "menu_frame_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local menu_frame_11 = UIFrameSettings.menu_frame_11
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local menu_frame_06_2 = UIFrameSettings.menu_frame_06
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self)
				-- function 3
				return not self.active
			end
		},
		{
			texture_id = "status_texture_frame",
			style_id = "status_texture_frame",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 4
				return not self.active
			end
		},
		{
			style_id = "placeholder_input",
			pass_type = "text",
			text_id = "placeholder_input",
			content_check_function = function (self)
				-- function 5
				return self.input == ""
			end
		},
		{
			style_id = "placeholder_input_shadow",
			pass_type = "text",
			text_id = "placeholder_input",
			content_check_function = function (self)
				-- function 6
				return self.input == ""
			end
		},
		{
			style_id = "status_message",
			pass_type = "text",
			text_id = "status_message",
			content_check_function = function (self)
				-- function 7
				local status_message = self.status_message

				status_message = not status_message and not self.error_message

				return status_message
			end
		},
		{
			style_id = "error_message",
			pass_type = "text",
			text_id = "status_message",
			content_check_function = function (self)
				-- function 8
				local status_message = self.status_message

				status_message = not status_message and self.error_message

				return status_message
			end
		},
		{
			style_id = "status_message_shadow",
			pass_type = "text",
			text_id = "status_message",
			content_check_function = function (self)
				-- function 9
				return self.status_message
			end
		},
		{
			style_id = "checkbox_background",
			pass_type = "hotspot",
			content_id = "checkbox_hotspot",
			content_change_function = function (self, arg_10_1)
				-- function 10
				local parent = arg_10_1.parent

				if not self.on_pressed then
					self.is_selected = not self.is_selected

					if not self.is_selected then
						parent.input.replacing_character = nil
						parent.input_shadow.replacing_character = nil
					else
						parent.input.replacing_character = "*"
						parent.input_shadow.replacing_character = "*"
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
			content_check_function = function (self)
				-- function 11
				return self.checkbox_hotspot.is_selected
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
	local tbl_3 = {
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
		checkbox_frame = menu_frame_06_2.texture,
		frame = menu_frame_11.texture,
		inner_frame = menu_frame_06.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_2_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
					math.min(arg_2_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
				}
			},
			texture_id = str
		}
	}
	local tbl_4 = {
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
			texture_size = menu_frame_06_2.texture_size,
			texture_sizes = menu_frame_06_2.texture_sizes,
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
			texture_size = menu_frame_11.texture_size,
			texture_sizes = menu_frame_11.texture_sizes,
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
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_2_0

	return tbl
end

local var_0_3 = fn("popup_root", tbl.popup_root.size)
local var_0_4 = fn_2("popup_root", tbl.popup_root.size)

local function fn_3(arg_12_0, arg_12_1)
	-- function 12
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

PopupHandler.init = function (self, arg_13_1, arg_13_2)
	-- function 13
	fassert(arg_13_2, "Not created by the popoup manager")

	self.ui_renderer = arg_13_1.ui_renderer
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.wwise_world = Managers.world:wwise_world(arg_13_1.world)
	self.debug_num_updates = 0
	self.popup_results = {}
	self.popups = {}
	self.n_popups = 0
	self.popup_ids = 0

	self:create_ui_elements()

	self.gamepad_button_colors = {
		enabled = Colors.get_color_table_with_alpha("white", 255),
		disabled = Colors.get_color_table_with_alpha("gray", 255)
	}
	self.mock_input_manager = MockInputManager:new()
end

PopupHandler.set_input_manager = function (self, arg_14_1)
	-- function 14
	self.input_manager = arg_14_1

	local tbl = {
		popup = true
	}

	arg_14_1:create_input_service("popup", "IngameMenuKeymaps", "IngameMenuFilters", tbl)
	arg_14_1:map_device_to_service("popup", "keyboard")
	arg_14_1:map_device_to_service("popup", "mouse")
	arg_14_1:map_device_to_service("popup", "gamepad")

	if not self:has_popup() then
		self:acquire_input()
	end
end

PopupHandler.get_input_manager = function (self)
	-- function 15
	return self.input_manager
end

PopupHandler.remove_input_manager = function (self, arg_16_1)
	-- function 16
	if not self:has_popup() then
		self:release_input()
	end

	if arg_16_1 or not self:has_popup() then
		local active_popup, var_16_1 = self:active_popup()
		local error = error
		local format = string.format
		local str = "Trying to proceed to next gamestate without handling popup %q: %q"
		local topic = var_16_1.topic

		topic = topic or "nil"

		local text = var_16_1.text

		text = text or "nil"

		error(format(str, topic, text))
	end

	self.input_manager = nil
end

PopupHandler.create_ui_elements = function (self)
	-- function 17
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self._popup_widgets_by_name = {
		default = UIWidget.init(var_0_3),
		password = UIWidget.init(var_0_4)
	}

	local tbl_2 = {
		{},
		{},
		{}
	}
	local tbl_3 = {
		{},
		{},
		{}
	}
	local flag = true
	local var_17_3

	tbl_2[1][1] = UIWidget.init(UIWidgets.create_default_button("button_1_1", tbl.button_1_1.size, "n/a", var_17_3))
	tbl_2[2][1] = UIWidget.init(UIWidgets.create_default_button("button_2_1", tbl.button_2_1.size, "n/a", var_17_3))
	tbl_2[2][2] = UIWidget.init(UIWidgets.create_default_button("button_2_2", tbl.button_2_2.size, "n/a", var_17_3))
	tbl_2[3][1] = UIWidget.init(UIWidgets.create_default_button("button_3_1", tbl.button_3_1.size, "n/a", var_17_3))
	tbl_2[3][2] = UIWidget.init(UIWidgets.create_default_button("button_3_2", tbl.button_3_2.size, "n/a", var_17_3))
	tbl_2[3][3] = UIWidget.init(UIWidgets.create_default_button("button_3_3", tbl.button_3_3.size, "n/a", var_17_3))
	tbl_3[1][1] = UIWidget.init(fn_3("confirm_press", "button_1_1"))
	tbl_3[2][1] = UIWidget.init(fn_3("confirm_press", "button_2_1"))
	tbl_3[2][2] = UIWidget.init(fn_3("back", "button_2_2"))
	tbl_3[3][1] = UIWidget.init(fn_3("confirm_press", "button_3_1"))
	tbl_3[3][2] = UIWidget.init(fn_3("back", "button_3_2"))
	tbl_3[3][3] = UIWidget.init(fn_3("refresh", "button_3_3"))
	self.button_widgets = tbl_2
	self.gamepad_button_widgets = tbl_3
end

PopupHandler.acquire_input = function (self, arg_18_1)
	-- function 18
	local input_manager = self.input_manager

	self:release_input(true)
	input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "popup", "PopupHandler")

	if not arg_18_1 then
		ShowCursorStack.show("PopupHandler")
	end
end

PopupHandler.release_input = function (self, arg_19_1)
	-- function 19
	local input_manager = self.input_manager
	local str = "popup"

	input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "popup", "PopupHandler", str)

	if not arg_19_1 then
		ShowCursorStack.hide("PopupHandler")
	end
end

PopupHandler.update = function (self, arg_20_1, arg_20_2)
	-- function 20
	fassert(arg_20_2, "Update does not come from the popup manager")

	self.debug_num_updates = self.debug_num_updates + 1

	local n_popups = self.n_popups
	local var_20_1 = self.popups[n_popups]

	if not var_20_1 then
		if not var_20_1.initialized then
			self:_initialize_popup(var_20_1)
		end

		local ui_renderer = self.ui_renderer
		local input_manager = self.input_manager

		input_manager = input_manager or self.mock_input_manager

		local get_service = input_manager:get_service("popup")
		local is_device_active = input_manager:is_device_active("gamepad")
		local widget = var_20_1.widget

		widget.style.text.font_size = var_20_1.text_font_size
		widget.style.text_shadow.font_size = var_20_1.text_font_size
		widget.content.text_field = var_20_1.text
		widget.content.title_text = var_20_1.topic

		local var_20_7

		if not var_20_1.timer then
			local format = string.format("%d", math.floor(var_20_1.timer))

			if not var_20_1.timer_format_func then
				format = var_20_1.timer_format_func(format)
			end

			local var_20_9
			local var_20_10
			local var_20_11

			if var_20_1.timer_alignment == "center" then
				widget.content.center_timer_field = format
				var_20_10 = widget.style.center_timer

				local center_timer_shadow = widget.style.center_timer_shadow

				widget.content.timer_field = ""
			else
				widget.content.center_timer_field = ""
				widget.content.timer_field = format
				var_20_10 = widget.style.timer

				local timer_shadow = widget.style.timer_shadow
			end

			if not var_20_1.timer_font_size then
				widget.style.timer.font_size = var_20_1.timer_font_size
				widget.style.center_timer.font_size = var_20_1.timer_font_size
			end

			if not var_20_1.timer_blink then
				var_20_10.text_color = Colors.lerp_color_tables(Colors.get_color_table_with_alpha("white", 255), Colors.get_color_table_with_alpha("cheeseburger", 255), var_20_1.timer % 15 % 1)
			end

			var_20_1.timer = var_20_1.timer - arg_20_1

			if var_20_1.timer <= 0 then
				var_20_7 = var_20_1.default_result
			end
		else
			widget.content.timer_field = ""
			widget.content.center_timer_field = ""
			widget.style.timer.font_size = 36
			widget.style.center_timer.font_size = 44
		end

		UIRenderer.begin_pass(ui_renderer, self.ui_scenegraph, get_service, arg_20_1, nil, self.render_settings)
		UIRenderer.draw_widget(ui_renderer, widget)

		local n_args = var_20_1.n_args

		if not n_args then
			local args = var_20_1.args
			local var_20_16 = self.button_widgets[n_args]
			local var_20_17 = self.gamepad_button_widgets[n_args]

			for i = 1, n_args do
				local str = " " .. args[i * 2]
				local flag = var_20_1.button_enabled_state[i] == true

				if not is_device_active then
					local var_20_20 = var_20_17[i]
					local content = var_20_20.content
					local input_action = content.input_action

					if not content.icon then
						content.icon = self:get_gamepad_input_texture_data(get_service, input_action).texture
					end

					content.text = str

					local style = var_20_20.style
					local text = style.text
					local enabled

					if not flag then
						enabled = self.gamepad_button_colors.enabled

						if not enabled then
							-- Nothing
						end
					end

					enabled = self.gamepad_button_colors.disabled

					::label_20_0::

					text.text_color = enabled

					local var_20_26, var_20_27 = UIFontByResolution(text)
					local text_size, var_20_29, var_20_30 = UIRenderer.text_size(ui_renderer, str, var_20_26[1], var_20_27)

					style.icon.offset[1] = 80 - text_size * 0.5

					UIRenderer.draw_widget(ui_renderer, var_20_20)

					if not get_service:get(input_action, true) then
						var_20_7 = args[i * 2 - 1]

						self:play_sound("Play_hud_select")
					end
				else
					local var_20_31 = var_20_16[i]

					UIWidgetUtils.animate_default_button(var_20_31, arg_20_1)

					var_20_31.content.title_text = str

					local button_hotspot = var_20_31.content.button_hotspot

					button_hotspot.disable_button = not flag

					UIRenderer.draw_widget(ui_renderer, var_20_31)

					if not button_hotspot.on_hover_enter then
						self:play_sound("Play_hud_hover")
					end

					if not button_hotspot.on_release then
						table.clear(var_20_31.content.button_hotspot)

						var_20_7 = args[i * 2 - 1]

						self:play_sound("Play_hud_select")
					end

					var_20_7 = var_20_7 or self:_handle_keyboard_input(var_20_1)
				end
			end
		end

		if not var_20_7 then
			local var_20_33
			local result_param_ids = var_20_1.result_param_ids

			if not result_param_ids then
				var_20_33 = {}

				local content_2 = widget.content

				for i_2, v in ipairs(result_param_ids) do
					var_20_33[v] = content_2[v]
				end
			end

			self.popup_results[var_20_1.popup_id] = {
				var_20_7,
				var_20_33
			}

			local num = n_popups - 1

			self.n_popups = num

			if num == 0 then
				self:release_input()
			end
		end

		UIRenderer.end_pass(ui_renderer)
	end
end

PopupHandler._handle_keyboard_input = function (self, arg_21_1)
	-- function 21
	local n_args = arg_21_1.n_args
	local var_21_1 = self.button_widgets[n_args]

	if not Managers.input:is_device_active("mouse") then
		for k, v in pairs(var_21_1) do
			v.content.button_hotspot.is_selected = false
		end

		arg_21_1.button_index = nil

		return
	end

	local button_index = arg_21_1.button_index

	button_index = button_index or 1

	local get_service = Managers.input:get_service("popup")

	if not get_service:get("move_right_hold_continuous") then
		button_index = math.clamp(button_index + 1, 1, n_args)
	elseif not get_service:get("move_left_hold_continuous") then
		button_index = math.clamp(button_index - 1, 1, n_args)
	elseif not get_service:get("confirm_press") and not arg_21_1.button_enabled_state[button_index] then
		local args = arg_21_1.args

		self:play_sound("Play_hud_select")
		print("Popup Choice:", args[button_index * 2 - 1])

		arg_21_1.button_index = nil

		return args[button_index * 2 - 1]
	end

	if button_index ~= arg_21_1.button_index then
		for i, v_2 in ipairs(var_21_1) do
			v_2.content.button_hotspot.is_selected = button_index == i
		end

		arg_21_1.button_index = button_index

		self:play_sound("Play_hud_hover")
	end
end

PopupHandler.get_gamepad_input_texture_data = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local PLATFORM = PLATFORM

	if not IS_WINDOWS then
		PLATFORM = "xb1"
	end

	if not arg_22_3 then
		return ButtonTextureByName(arg_22_2, PLATFORM)
	else
		return UISettings.get_gamepad_input_texture_data(arg_22_1, arg_22_2, true)
	end
end

PopupHandler.set_button_enabled = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local var_23_0

	for i = 1, self.n_popups do
		local var_23_1 = self.popups[i]

		if var_23_1.popup_id == arg_23_1 then
			var_23_0 = var_23_1
		end
	end

	var_23_0.button_enabled_state[arg_23_2] = arg_23_3
end

PopupHandler.active_popup = function (self)
	-- function 24
	local var_24_0 = self.popups[self.n_popups]

	if not var_24_0 then
		return var_24_0.popup_id, var_24_0
	end
end

PopupHandler.queue_popup = function (self, arg_25_1, arg_25_2, arg_25_3, ...)
	-- function 25
	local n_popups = self.n_popups
	local popups = self.popups
	local num = n_popups + 1

	self.n_popups = num

	local var_25_3 = popups[num]

	var_25_3 = var_25_3 or {
		args = {}
	}
	self.popup_ids = self.popup_ids + 1

	local var_25_4 = tostring(self.popup_ids)

	var_25_3.popup_id = var_25_4

	local var_25_5 = self._popup_widgets_by_name[arg_25_1]
	local text = var_25_5.style.text
	local var_25_7 = UIScaleVectorToResolution(tbl.popup_text.size)
	local flag

	flag = not (self:get_number_of_rows(arg_25_2, text, var_25_7[1]) >= 7) or not 20 or 28
	var_25_3.text_font_size = flag
	var_25_3.text = arg_25_2
	var_25_3.topic = arg_25_3
	var_25_3.widget = var_25_5
	var_25_3.type = arg_25_1

	local var_25_9 = select("#", ...)

	assert(math.floor(var_25_9 / 2) * 2 == var_25_9, "Need one action for each button text")
	assert(var_25_9 > 0, "Need at least one button...")

	var_25_3.n_args = var_25_9 / 2
	var_25_3.button_enabled_state = {}

	for i = 1, var_25_3.n_args do
		var_25_3.button_enabled_state[i] = true
	end

	var_25_3.timer = nil
	var_25_3.default_result = nil

	pack_index[var_25_9](var_25_3.args, 1, ...)

	local flag_2 = num > 1

	if not self.input_manager then
		self:acquire_input(flag_2)
	end

	popups[num] = var_25_3

	self:_reset_popup_initialized()

	return var_25_4
end

PopupHandler._initialize_popup = function (self, arg_26_1)
	-- function 26
	if arg_26_1.type == "password" then
		self:_initialize_password_popup(arg_26_1)
	end

	arg_26_1.initialized = true
end

PopupHandler._initialize_password_popup = function (self, arg_27_1)
	-- function 27
	local widget = arg_27_1.widget
	local content = widget.content
	local style = widget.style

	content.input = ""
	content.active = true
	content.text_index = 1
	content.caret_index = 1
	content.input_mode = "insert"
	content.status_message = nil
	content.error_message = nil

	table.clear(content.checkbox_hotspot)

	style.input.replacing_character = "*"
	style.input_shadow.replacing_character = "*"
	style.input.input_color = Colors.get_color_table_with_alpha("font_default", 255)

	local animations = widget.animations
	local _animate_element_pulse = self:_animate_element_pulse(style.input.caret_color, 1, 60, 255, 2)
	local _animate_element_pulse_2 = self:_animate_element_pulse(style.input_shadow.caret_color, 1, 60, 255, 2)

	animations[_animate_element_pulse] = true
	animations[_animate_element_pulse_2] = true
	arg_27_1.result_param_ids = {
		"input"
	}
	arg_27_1.initialized = true
end

PopupHandler.set_popup_verifying_password = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local active_popup, var_28_1 = self:active_popup()

	if active_popup ~= arg_28_1 then
		return
	end

	local widget = var_28_1.widget
	local content = widget.content

	content.status_message = arg_28_4 or arg_28_3
	content.error_message = arg_28_4
	content.active = not arg_28_2

	local animations = widget.animations

	table.clear(animations)

	local caret_color = widget.style.input.caret_color
	local caret_color_2 = widget.style.input_shadow.caret_color
	local text_color = widget.style.input.text_color

	if not arg_28_2 then
		caret_color[1] = 0
		caret_color_2[1] = 0
		text_color[1] = 200
		text_color[2] = 40
		text_color[3] = 40
		text_color[4] = 40
	else
		local _animate_element_pulse = self:_animate_element_pulse(caret_color, 1, 60, 255, 2)
		local _animate_element_pulse_2 = self:_animate_element_pulse(caret_color_2, 1, 60, 255, 2)

		animations[_animate_element_pulse] = true
		animations[_animate_element_pulse_2] = true

		local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_default", 255)

		text_color[1] = get_color_table_with_alpha[1]
		text_color[2] = get_color_table_with_alpha[2]
		text_color[3] = get_color_table_with_alpha[3]
		text_color[4] = get_color_table_with_alpha[4]
	end

	local n_args = var_28_1.n_args

	for i = 1, n_args do
		self:set_button_enabled(arg_28_1, i, not arg_28_2)
	end
end

PopupHandler._animate_element_pulse = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	-- function 29
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5))
end

PopupHandler.activate_timer = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7)
	-- function 30
	local n_popups = self.n_popups
	local popups = self.popups
	local var_30_2

	for i = 1, n_popups do
		local var_30_3 = popups[i]

		if var_30_3.popup_id == arg_30_1 then
			var_30_2 = var_30_3
		end
	end

	assert(var_30_2, string.format("[PopupHandler:activate_timer] There is no popup with id %s", arg_30_1))

	local var_30_4

	for i_2, v in ipairs(var_30_2.args) do
		if v == arg_30_3 then
			var_30_4 = i_2

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

	local flag

	flag = arg_30_5 ~= nil or not true or arg_30_5
	var_30_2.timer_blink = flag
	var_30_2.timer_format_func = arg_30_6
	var_30_2.timer_font_size = arg_30_7
end

PopupHandler.has_popup = function (self)
	-- function 31
	return self.n_popups > 0
end

PopupHandler.has_popup_with_id = function (self, arg_32_1)
	-- function 32
	for k, v in pairs(self.popups) do
		if v.popup_id == arg_32_1 then
			return true
		end
	end

	return false
end

PopupHandler._reset_popup_initialized = function (self)
	-- function 33
	for k, v in pairs(self.popups) do
		v.initialized = false
	end
end

PopupHandler.cancel_popup = function (self, arg_34_1)
	-- function 34
	local n_popups = self.n_popups
	local popups = self.popups

	for i = 1, n_popups do
		local var_34_2 = popups[i]

		if var_34_2.popup_id == arg_34_1 then
			popups[i], popups[n_popups] = popups[n_popups], var_34_2
			self.n_popups = n_popups - 1

			if self.n_popups == 0 then
				self:release_input()
			end

			return
		end
	end
end

PopupHandler.cancel_all_popups = function (self)
	-- function 35
	local n_popups = self.n_popups
	local popups = self.popups

	for i = 1, n_popups do
		popups[i] = nil
	end

	if n_popups > 0 then
		self:release_input()
	end

	self.n_popups = 0
end

PopupHandler.query_result = function (self, arg_36_1)
	-- function 36
	local var_36_0 = self.popup_results[arg_36_1]

	self.popup_results[arg_36_1] = nil

	if not var_36_0 then
		return unpack(var_36_0)
	end
end

PopupHandler.play_sound = function (self, arg_37_1)
	-- function 37
	WwiseWorld.trigger_event(self.wwise_world, arg_37_1)
end

PopupHandler.fit_text_width_to_popup = function (self, arg_38_1)
	-- function 38
	local default = self._popup_widgets_by_name.default

	return UIRenderer.crop_text_width(self.ui_renderer, arg_38_1, 500, default.style.text)
end

PopupHandler.get_number_of_rows = function (self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local var_39_0, var_39_1 = UIFontByResolution(arg_39_2)

	return #UIRenderer.word_wrap(self.ui_renderer, arg_39_1, var_39_0[1], var_39_1, arg_39_3)
end
