-- chunkname: @scripts/ui/views/title_loading_ui.lua

require("scripts/settings/controller_settings")
require("scripts/ui/ui_widgets")
require("scripts/ui/views/cutscene_overlay_ui")

local var_0_0 = local_require("scripts/ui/cutscene_overlay_templates/cutscene_template_trailer")
local var_0_1 = local_require("scripts/ui/cutscene_overlay_templates/cutscene_template_penny_intro")
local var_0_2 = local_require("scripts/ui/cutscene_overlay_templates/cutscene_template_cog_intro")
local var_0_3 = local_require("scripts/ui/cutscene_overlay_templates/cutscene_template_morris_intro")
local var_0_4 = local_require("scripts/ui/cutscene_overlay_templates/cutscene_template_woods_intro")
local var_0_5 = local_require("scripts/ui/cutscene_overlay_templates/cutscene_template_bless_intro")
local var_0_6 = local_require("scripts/ui/cutscene_overlay_templates/cutscene_template_shovel_intro")
local tbl = {
	screen = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale = "fit",
		position = {
			0,
			0,
			0
		},
		size = {
			1920,
			1080
		}
	},
	dead_space_filler = {
		scale = "fit",
		position = {
			0,
			0,
			0
		},
		size = {
			1920,
			1080
		}
	},
	loading_background = {
		vertical_alignment = "center",
		parent = "screen",
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
	skip_input = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			20,
			15,
			500
		}
	},
	skip_input_text_1 = {
		vertical_alignment = "bottom",
		parent = "skip_input",
		horizontal_alignment = "left",
		size = {
			40,
			40
		},
		position = {
			0,
			0,
			5
		}
	},
	skip_input_text_2 = {
		vertical_alignment = "bottom",
		parent = "skip_input",
		horizontal_alignment = "left",
		size = {
			40,
			40
		},
		position = {
			0,
			0,
			5
		}
	},
	skip_input_text_3 = {
		vertical_alignment = "bottom",
		parent = "skip_input",
		horizontal_alignment = "left",
		size = {
			40,
			40
		},
		position = {
			0,
			0,
			5
		}
	},
	skip_input_icon = {
		vertical_alignment = "bottom",
		parent = "skip_input",
		horizontal_alignment = "left",
		size = {
			30,
			30
		},
		position = {
			0,
			10,
			5
		}
	},
	skip_input_icon_bar = {
		vertical_alignment = "center",
		parent = "skip_input_icon",
		horizontal_alignment = "center",
		size = {
			36,
			36
		},
		position = {
			0,
			0,
			-1
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			501
		}
	},
	splash_video = {
		parent = "background",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	gamma_header_text = {
		vertical_alignment = "top",
		parent = "gamma_image",
		horizontal_alignment = "center",
		position = {
			0,
			100,
			10
		},
		size = {
			800,
			40
		}
	},
	gamma_image = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			100,
			-10
		},
		size = {
			285,
			285
		}
	},
	gamma_correction_image = {
		vertical_alignment = "bottom",
		parent = "gamma_image",
		horizontal_alignment = "center",
		position = {
			0,
			-140,
			10
		},
		size = {
			420,
			50
		}
	},
	gamma_stepper = {
		vertical_alignment = "center",
		parent = "gamma_correction_image",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			500,
			50
		}
	},
	gamma_info_text = {
		vertical_alignment = "bottom",
		parent = "gamma_correction_image",
		horizontal_alignment = "center",
		position = {
			0,
			-130,
			10
		},
		size = {
			1300,
			50
		}
	},
	apply_button = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			45,
			10
		},
		size = {
			370,
			70
		}
	},
	sound_presentation_image = {
		vertical_alignment = "center",
		parent = "gamma_image",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			166,
			76
		}
	},
	sound_range_presentation_image = {
		vertical_alignment = "center",
		parent = "sound_presentation_image",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			160,
			160
		}
	},
	sound_panning_option_1 = {
		vertical_alignment = "center",
		parent = "gamma_stepper",
		horizontal_alignment = "center",
		position = {
			-120,
			0,
			10
		},
		size = {
			218,
			203
		}
	},
	sound_panning_option_1_glow = {
		vertical_alignment = "center",
		parent = "sound_panning_option_1",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			218,
			203
		}
	},
	sound_panning_option_2 = {
		vertical_alignment = "center",
		parent = "gamma_stepper",
		horizontal_alignment = "center",
		position = {
			120,
			0,
			10
		},
		size = {
			218,
			203
		}
	},
	sound_panning_option_2_glow = {
		vertical_alignment = "center",
		parent = "sound_panning_option_2",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			218,
			203
		}
	},
	sound_range_option_1 = {
		vertical_alignment = "center",
		parent = "sound_panning_option_1",
		horizontal_alignment = "center",
		position = {
			30,
			0,
			1
		},
		size = {
			300,
			200
		}
	},
	sound_range_option_1_glow = {
		vertical_alignment = "center",
		parent = "sound_range_option_1",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			300,
			200
		}
	},
	sound_range_option_2 = {
		vertical_alignment = "center",
		parent = "sound_panning_option_2",
		horizontal_alignment = "center",
		position = {
			20,
			0,
			1
		},
		size = {
			170,
			170
		}
	},
	sound_range_option_2_glow = {
		vertical_alignment = "center",
		parent = "sound_range_option_2",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			170,
			170
		}
	},
	console_input_text_1 = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "right",
		position = {
			-110,
			85,
			10
		},
		size = {
			300,
			40
		}
	},
	console_input_icon_root_1 = {
		vertical_alignment = "center",
		parent = "console_input_text_1",
		horizontal_alignment = "left",
		position = {
			-25,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	console_input_icon_1 = {
		vertical_alignment = "center",
		parent = "console_input_icon_root_1",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			40,
			40
		}
	},
	console_input_text_2 = {
		vertical_alignment = "center",
		parent = "console_input_text_1",
		horizontal_alignment = "left",
		position = {
			0,
			-50,
			1
		},
		size = {
			300,
			40
		}
	},
	console_input_icon_root_2 = {
		vertical_alignment = "center",
		parent = "console_input_text_2",
		horizontal_alignment = "left",
		position = {
			-25,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	console_input_icon_2 = {
		vertical_alignment = "center",
		parent = "console_input_icon_root_2",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			40,
			40
		}
	}
}

skip_widget = {
	scenegraph_id = "skip_input",
	element = {
		passes = {
			{
				style_id = "input_text_1",
				pass_type = "text",
				text_id = "input_text_1"
			},
			{
				style_id = "input_text_2",
				pass_type = "text",
				text_id = "input_text_2",
				content_check_function = function (self)
					-- function 1
					return not self.input_icon
				end
			},
			{
				style_id = "input_text_3",
				pass_type = "text",
				text_id = "input_text_3"
			},
			{
				pass_type = "texture",
				style_id = "input_icon",
				texture_id = "input_icon",
				content_check_function = function (self)
					-- function 2
					return self.input_icon
				end
			},
			{
				pass_type = "gradient_mask_texture",
				style_id = "input_icon_bar",
				texture_id = "input_icon_bar",
				content_check_function = function (self)
					-- function 3
					return not self.using_keyboard
				end
			},
			{
				style_id = "hold_bar",
				pass_type = "rect",
				content_check_function = function (self)
					-- function 4
					return self.using_keyboard
				end
			},
			{
				style_id = "hold_bar_bg",
				pass_type = "rect",
				content_check_function = function (self)
					-- function 5
					return self.using_keyboard
				end
			}
		}
	},
	content = {
		input_icon_bar = "controller_hold_bar",
		input_text_2 = "",
		input_text_1 = "",
		using_keyboard = true,
		input_text_3 = Localize("to_skip")
	},
	style = {
		hold_bar = {
			scenegraph_id = "skip_input_icon",
			color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				-5,
				-16,
				1
			},
			size = {
				0,
				8
			}
		},
		hold_bar_bg = {
			scenegraph_id = "skip_input_icon",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-5,
				-16,
				0
			},
			size = {
				0,
				8
			}
		},
		input_icon = {
			scenegraph_id = "skip_input_icon",
			color = {
				255,
				255,
				255,
				255
			}
		},
		input_icon_bar = {
			scenegraph_id = "skip_input_icon_bar",
			gradient_threshold = 0,
			color = {
				255,
				255,
				255,
				255
			}
		},
		input_text_1 = {
			scenegraph_id = "skip_input_text_1",
			font_size = 36,
			word_wrap = false,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255)
		},
		input_text_2 = {
			font_size = 36,
			upper_case = true,
			horizontal_alignment = "left",
			word_wrap = false,
			pixel_perfect = true,
			scenegraph_id = "skip_input_text_2",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				0,
				0,
				0
			}
		},
		input_text_3 = {
			scenegraph_id = "skip_input_text_3",
			font_size = 36,
			word_wrap = false,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255)
		}
	}
}

local tbl_2 = {
	scenegraph_id = "dead_space_filler",
	element = {
		passes = {
			{
				pass_type = "rect"
			}
		}
	},
	content = {},
	style = {
		color = {
			255,
			0,
			0,
			0
		}
	}
}

local function fn()
	-- function 6
	return {
		scenegraph_id = "gamma_image",
		element = {
			passes = {
				{
					style_id = "value_text",
					pass_type = "text",
					text_id = "value_text"
				},
				{
					style_id = "gamma_header_text",
					pass_type = "text",
					text_id = "gamma_header_text"
				},
				{
					style_id = "gamma_info_text",
					pass_type = "text",
					text_id = "gamma_info_text"
				},
				{
					pass_type = "texture",
					style_id = "gamepad_navigation_icon",
					texture_id = "gamepad_navigation_icon",
					content_check_function = function (self)
						-- function 7
						return self.gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "gamepad_accept_icon",
					texture_id = "gamepad_accept_icon",
					content_check_function = function (self)
						-- function 8
						return self.gamepad_active
					end
				},
				{
					style_id = "gamepad_navigation_text",
					pass_type = "text",
					text_id = "gamepad_navigation_text",
					content_check_function = function (self)
						-- function 9
						return self.gamepad_active
					end
				},
				{
					style_id = "gamepad_accept_text",
					pass_type = "text",
					text_id = "gamepad_accept_text",
					content_check_function = function (self)
						-- function 10
						return self.gamepad_active
					end
				}
			}
		},
		content = {
			gamma_header_text = "startup_settings_gamma_header",
			gamma_info_text = "startup_settings_gamma_desc",
			value_text = 0,
			gamepad_navigation_icon = "xbone_button_icon_a",
			gamepad_accept_icon = "xbone_button_icon_a",
			gamepad_accept_text = "- " .. Localize("input_description_confirm"),
			gamepad_navigation_text = "- " .. Localize("input_description_change")
		},
		style = {
			gamepad_accept_icon = {
				scenegraph_id = "console_input_icon_2"
			},
			gamepad_navigation_icon = {
				scenegraph_id = "console_input_icon_1"
			},
			gamepad_navigation_text = {
				vertical_alignment = "center",
				scenegraph_id = "console_input_text_1",
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			gamepad_accept_text = {
				vertical_alignment = "center",
				scenegraph_id = "console_input_text_2",
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			value_text = {
				vertical_alignment = "bottom",
				localize = false,
				horizontal_alignment = "left",
				font_size = 32,
				dynamic_font = true,
				font_type = "hell_shark_header",
				offset = {
					120.5,
					-70,
					0
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
			},
			gamma_header_text = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_size = 42,
				font_type = "hell_shark_header",
				scenegraph_id = "gamma_header_text",
				text_color = Colors.get_color_table_with_alpha("font_title", 255)
			},
			gamma_info_text = {
				vertical_alignment = "center",
				scenegraph_id = "gamma_info_text",
				localize = true,
				horizontal_alignment = "center",
				font_size = 24,
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255)
			}
		}
	}
end

local tbl_3 = {
	vertical_alignment = "center",
	upper_case = true,
	localize = true,
	horizontal_alignment = "center",
	font_size = 42,
	font_type = "hell_shark_header",
	scenegraph_id = "gamma_header_text",
	text_color = Colors.get_color_table_with_alpha("font_title", 255)
}
local tbl_4 = {
	vertical_alignment = "center",
	scenegraph_id = "gamma_info_text",
	localize = true,
	horizontal_alignment = "center",
	font_size = 24,
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255)
}
local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_button_normal", 255)
local tbl_5 = {
	gamma_adjuster = fn(),
	gamma_image = UIWidgets.create_background_with_frame("gamma_image", tbl.gamma_image.size, "gamma_settings_image_01", "button_frame_01"),
	gamma_correction_image = UIWidgets.create_background_with_frame("gamma_correction_image", tbl.gamma_correction_image.size, "gamma_settings_image_02", "button_frame_01"),
	gamma_stepper = UIWidgets.create_default_stepper("gamma_stepper", tbl.gamma_stepper.size),
	gamma_image_corners = UIWidgets.create_frame("gamma_image", tbl.gamma_image.size, "frame_corner_detail_01", 10)
}
local tbl_6 = {
	stepper = UIWidgets.create_default_stepper("gamma_stepper", tbl.gamma_stepper.size),
	sound_presentation_image = UIWidgets.create_simple_texture("sound_setting_icon_01", "sound_presentation_image", nil, nil, get_color_table_with_alpha),
	sound_option_1 = UIWidgets.create_simple_texture("sound_setting_icon_03", "sound_panning_option_1"),
	sound_option_1_glow = UIWidgets.create_simple_texture("sound_setting_icon_03_glow", "sound_panning_option_1_glow"),
	sound_option_button_1 = UIWidgets.create_simple_hotspot("sound_panning_option_1"),
	sound_option_2 = UIWidgets.create_simple_texture("sound_setting_icon_04", "sound_panning_option_2"),
	sound_option_2_glow = UIWidgets.create_simple_texture("sound_setting_icon_04_glow", "sound_panning_option_2_glow"),
	sound_option_button_2 = UIWidgets.create_simple_hotspot("sound_panning_option_2"),
	header = UIWidgets.create_simple_text("startup_settings_panning_rule_header", "gamma_header_text", nil, nil, tbl_3),
	description = UIWidgets.create_simple_text("startup_settings_panning_rule_desc", "gamma_info_text", nil, nil, tbl_4)
}
local tbl_7 = {
	stepper = UIWidgets.create_default_stepper("gamma_stepper", tbl.gamma_stepper.size),
	sound_presentation_image = UIWidgets.create_simple_texture("sound_setting_icon_05", "sound_range_presentation_image", nil, nil, get_color_table_with_alpha),
	header = UIWidgets.create_simple_text("startup_settings_dynamic_range_header", "gamma_header_text", nil, nil, tbl_3),
	description = UIWidgets.create_simple_text("startup_settings_dynamic_range_desc", "gamma_info_text", nil, nil, tbl_4)
}
local create_default_button = UIWidgets.create_default_button("apply_button", tbl.apply_button.size, nil, nil, Localize("input_description_confirm"))
local tbl_8 = {
	video_name = "video/vermintide_2_prologue_intro",
	sound_start = "vermintide_2_prologue_intro",
	scenegraph_id = "splash_video",
	material_name = "vermintide_2_prologue_intro",
	sound_stop = "Stop_vermintide_2_prologue_intro",
	subtitle_template_settings = var_0_0
}
local tbl_9 = {
	video_name = "video/vermintide_2_shovel_intro",
	sound_start = "Play_vermintide_2_shovel_intro",
	scenegraph_id = "splash_video",
	material_name = "vermintide_2_shovel_intro",
	sound_stop = "Stop_vermintide_2_shovel_intro",
	subtitle_template_settings = var_0_6
}
local var_0_19 = tbl_9

local function fn_2(arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local num = arg_11_1 - arg_11_0

	return (math.clamp(arg_11_2, arg_11_0, arg_11_1) - arg_11_0) / num
end

local tbl_10 = {
	start_value = 2.2,
	min = 1.5,
	num_decimals = 1,
	max = 5
}
local tbl_11 = {
	min = 1,
	num_decimals = 0,
	start_value = 1,
	max = 2,
	options = {
		{
			value = "speakers",
			text = Localize("menu_settings_speakers")
		},
		{
			value = "headphones",
			text = Localize("menu_settings_headphones")
		}
	},
	option_index_by_key = {
		headphones = 2,
		speakers = 1
	}
}
local tbl_12 = {
	min = 1,
	num_decimals = 0,
	start_value = 3,
	max = 3,
	options = {
		{
			value = "low",
			text = Localize("menu_settings_low")
		},
		{
			value = "medium",
			text = Localize("menu_settings_medium")
		},
		{
			value = "high",
			text = Localize("menu_settings_high")
		}
	},
	option_index_by_key = {
		high = 3,
		medium = 2,
		low = 1
	}
}
local tbl_13 = {
	default = {
		{
			input_action = "analog_input",
			priority = 1,
			description_text = "scoreboard_navigation"
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_confirm"
		}
	}
}
local str = "TitleLoadingUI"

TitleLoadingUI = class(TitleLoadingUI)

TitleLoadingUI.init = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	Framerate.set_low_power()

	var_0_19 = tbl_9

	local get_title_settings = Managers.backend:get_title_settings()

	if not get_title_settings and not get_title_settings.video_override then
		var_0_19 = get_title_settings.video_override

		if not var_0_19.subtitle_template_settings_path and not Application.can_get("lua", var_0_19.subtitle_template_settings_path) then
			var_0_19.subtitle_template_settings = local_require(var_0_19.subtitle_template_settings_path)
		end
	end

	if not arg_12_2.is_prologue then
		var_0_19 = tbl_8
	end

	self.render_settings = {
		snap_pixel_positions = true
	}
	self._world = arg_12_1
	self._done = false
	self._force_done = arg_12_3
	self._startup_settings_done = false
	self._settings_index = 1
	self._needs_cursor_pop = false
	self._current_inputs = {}
	self._display_startup_settings = arg_12_2.gamma
	self._trailer = arg_12_2.trailer

	if not (self._trailer or self._display_startup_settings) then
		self._done = true
	end

	Managers.input:create_input_service("title_loading_ui", "TitleLoadingKeyMaps", "TitleLoadingFilters")
	Managers.input:map_device_to_service("title_loading_ui", "keyboard")
	Managers.input:map_device_to_service("title_loading_ui", "mouse")
	Managers.input:map_device_to_service("title_loading_ui", "gamepad")

	if not var_0_19 then
		Managers.package:load("resource_packages/videos/" .. var_0_19.material_name, "intro_cinematic", callback(self, "cb_cinematic_package_loaded"), true)

		self._loading_packages = true
	else
		self:_setup_gui()
	end
end

TitleLoadingUI.cb_cinematic_package_loaded = function (self)
	-- function 13
	self._cinematic_package_loaded = true

	self:_setup_gui()
end

TitleLoadingUI.is_loading_packages = function (self)
	-- function 14
	return self._loading_packages
end

TitleLoadingUI._setup_gui = function (self)
	-- function 15
	self._ui_renderer = UIRenderer.create(self._world, "material", "materials/ui/ui_1080p_title_screen", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_menu_atlas_textures", "material", var_0_19.video_name, "material", "materials/fonts/gw_fonts")

	self:_create_elements()

	self._loading_packages = nil

	if not Managers.transition:loading_icon_active() then
		Managers.transition:hide_loading_icon()
	end
end

TitleLoadingUI._create_elements = function (self)
	-- function 16
	self._ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self._video_widget = UIWidget.init(UIWidgets.create_splash_video(var_0_19, str))
	self._skip_widget = UIWidget.init(skip_widget)
	self._dead_space_filler_widget = UIWidget.init(tbl_2)
	self._done_button = UIWidget.init(create_default_button)

	if not self._display_startup_settings then
		ShowCursorStack.show("TitleLoadingUI")

		self._needs_cursor_pop = true

		local tbl_3 = {}
		local tbl_4 = {}

		for k, v in pairs(tbl_5) do
			local var_16_2 = UIWidget.init(v)

			tbl_3[#tbl_3 + 1] = var_16_2
			tbl_4[k] = var_16_2
		end

		self._gamma_widgets = tbl_3
		self._gamma_widgets_by_name = tbl_4

		local tbl_8 = {}
		local tbl_9 = {}

		for k_2, v_2 in pairs(tbl_6) do
			local var_16_5 = UIWidget.init(v_2)

			tbl_8[#tbl_8 + 1] = var_16_5
			tbl_9[k_2] = var_16_5
		end

		self._panning_widgets = tbl_8
		self._panning_widgets_by_name = tbl_9

		local tbl_10 = {}
		local tbl_11 = {}

		for k_3, v_3 in pairs(tbl_7) do
			local var_16_8 = UIWidget.init(v_3)

			tbl_10[#tbl_10 + 1] = var_16_8
			tbl_11[k_3] = var_16_8
		end

		self._dynamic_range_widgets = tbl_10
		self._dynamic_range_widgets_by_name = tbl_11

		self:setup_gamma_menu()
		self:setup_sound_panning_menu()
		self:setup_sound_dynamic_range_menu()

		local gamma_adjuster = self._gamma_widgets_by_name.gamma_adjuster
		local _get_input_gamepad_texture_data, var_16_11 = self:_get_input_gamepad_texture_data("confirm")

		gamma_adjuster.content.gamepad_accept_icon = _get_input_gamepad_texture_data.texture
		self._ui_scenegraph.console_input_icon_2.size[1] = _get_input_gamepad_texture_data.size[1]
		self._ui_scenegraph.console_input_icon_2.size[2] = _get_input_gamepad_texture_data.size[2]

		local PLATFORM = PLATFORM
		local ButtonTextureByName = ButtonTextureByName
		local str_2 = "d_horizontal"
		local flag

		flag = not IS_WINDOWS and "xb1" and PLATFORM

		local var_16_16, var_16_17 = ButtonTextureByName(str_2, flag)

		gamma_adjuster.content.gamepad_navigation_icon = var_16_16.texture
		self._ui_scenegraph.console_input_icon_1.size[1] = var_16_16.size[1]
		self._ui_scenegraph.console_input_icon_1.size[2] = var_16_16.size[2]

		local get_service = Managers.input:get_service("title_loading_ui")

		self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_renderer, get_service, 5, 10, tbl_13.default)

		self._menu_input_description:set_input_description(nil)
	else
		self._startup_settings_done = true
	end

	DO_RELOAD = false
end

DO_RELOAD = true

TitleLoadingUI.setup_gamma_menu = function (self)
	-- function 17
	local gamma_stepper = self._gamma_widgets_by_name.gamma_stepper
	local gamma_adjuster = self._gamma_widgets_by_name.gamma_adjuster
	local min = tbl_10.min
	local max = tbl_10.max
	local start_value = tbl_10.start_value
	local user_setting = Application.user_setting("render_settings", "gamma")

	user_setting = user_setting or start_value
	gamma_stepper.content.setting_text = ""
	gamma_stepper.content.value = user_setting

	local var_17_6 = fn_2(min, max, user_setting)

	gamma_stepper.content.internal_value = var_17_6
	gamma_adjuster.content.value_text = string.format("%.1f", user_setting)
end

TitleLoadingUI.setup_sound_panning_menu = function (self)
	-- function 18
	local stepper = self._panning_widgets_by_name.stepper
	local min = tbl_11.min
	local max = tbl_11.max
	local start_value = tbl_11.start_value
	local options = tbl_11.options
	local option_index_by_key = tbl_11.option_index_by_key
	local get = DefaultUserSettings.get("user_settings", "sound_panning_rule")
	local user_setting = Application.user_setting("sound_panning_rule")

	user_setting = user_setting or get
	stepper.content.setting_text = ""
	stepper.content.value = user_setting
	stepper.content.internal_value = start_value

	self:_change_sound_panning_display_by_value(start_value)
end

TitleLoadingUI.setup_sound_dynamic_range_menu = function (self)
	-- function 19
	local stepper = self._dynamic_range_widgets_by_name.stepper
	local min = tbl_12.min
	local max = tbl_12.max
	local start_value = tbl_12.start_value
	local options = tbl_12.options
	local option_index_by_key = tbl_12.option_index_by_key
	local get = DefaultUserSettings.get("user_settings", "dynamic_range_sound")
	local user_setting = Application.user_setting("dynamic_range_sound")

	user_setting = user_setting or get
	stepper.content.setting_text = ""
	stepper.content.value = user_setting
	stepper.content.internal_value = start_value

	self:_change_sound_dynamic_range_display_by_value(start_value)
end

TitleLoadingUI.update = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not DO_RELOAD then
		self:_create_elements()
	end

	if not self._ui_renderer then
		return
	end

	if not self._startup_settings_done then
		local is_device_active = Managers.input:is_device_active("gamepad")
		local _settings_index = self._settings_index

		if _settings_index == 1 then
			local gamma_stepper = self._gamma_widgets_by_name.gamma_stepper

			if not self:_handle_stepper_input(gamma_stepper, tbl_10, is_device_active, arg_20_1) then
				local min = tbl_10.min
				local max = tbl_10.max
				local num_decimals = tbl_10.num_decimals
				local internal_value = gamma_stepper.content.internal_value
				local round_with_precision = math.round_with_precision(min + (max - min) * internal_value, num_decimals or 0)

				gamma_stepper.content.value = round_with_precision
				self._gamma_widgets_by_name.gamma_adjuster.content.value_text = string.format("%.1f", round_with_precision)

				Application.set_render_setting("gamma", round_with_precision)
			end
		elseif _settings_index == 2 then
			local _panning_widgets_by_name = self._panning_widgets_by_name
			local stepper = _panning_widgets_by_name.stepper

			if not self:_handle_stepper_input(stepper, tbl_11, is_device_active, arg_20_1) then
				local min_2 = tbl_11.min
				local max_2 = tbl_11.max
				local num_decimals_2 = tbl_11.num_decimals
				local internal_value_2 = stepper.content.internal_value
				local round_with_precision_2 = math.round_with_precision(min_2 + (max_2 - min_2) * internal_value_2, num_decimals_2 or 0)
				local var_20_15 = tbl_11.options[round_with_precision_2]

				stepper.content.value = var_20_15.value

				self:_change_sound_panning_display_by_value(round_with_precision_2)
			else
				for i = 1, 2 do
					local hotspot = _panning_widgets_by_name["sound_option_button_" .. i].content.hotspot

					if not (not hotspot.on_release and hotspot.is_selected) then
						hotspot.on_release = false

						self:_change_sound_panning_display_by_value(i)

						break
					end
				end
			end
		elseif _settings_index == 3 then
			local stepper_2 = self._dynamic_range_widgets_by_name.stepper

			if not self:_handle_stepper_input(stepper_2, tbl_12, is_device_active, arg_20_1) then
				local min_3 = tbl_12.min
				local max_3 = tbl_12.max
				local num_decimals_3 = tbl_12.num_decimals
				local internal_value_3 = stepper_2.content.internal_value
				local round_with_precision_3 = math.round_with_precision(min_3 + (max_3 - min_3) * internal_value_3, num_decimals_3 or 0)
				local var_20_23 = tbl_12.options[round_with_precision_3]

				stepper_2.content.value = var_20_23.value

				self:_change_sound_dynamic_range_display_by_value(round_with_precision_3)
			end
		end

		self:_update_continue_button(is_device_active, arg_20_1)
	else
		self:_update_input_text(arg_20_1)
		self:_update_input(arg_20_1)
	end

	self:_render(arg_20_1)

	if not self.cutscene_overlay_ui then
		self.cutscene_overlay_ui:update(arg_20_1)
	end
end

TitleLoadingUI._change_sound_panning_display_by_value = function (self, arg_21_1)
	-- function 21
	local min = tbl_11.min
	local max = tbl_11.max
	local var_21_2 = fn_2(min, max, arg_21_1)
	local value = tbl_11.options[arg_21_1].value
	local _panning_widgets_by_name = self._panning_widgets_by_name
	local stepper = _panning_widgets_by_name.stepper

	stepper.content.value = value
	stepper.content.internal_value = var_21_2

	for i = 1, 2 do
		_panning_widgets_by_name[("sound_option_" .. i) .. "_glow"].content.visible = arg_21_1 == i
		_panning_widgets_by_name["sound_option_button_" .. i].content.hotspot.is_selected = i == arg_21_1
	end

	_panning_widgets_by_name.sound_presentation_image.content.texture_id = "sound_setting_icon_0" .. arg_21_1
end

TitleLoadingUI._change_sound_dynamic_range_display_by_value = function (self, arg_22_1)
	-- function 22
	local min = tbl_12.min
	local max = tbl_12.max
	local var_22_2 = fn_2(min, max, arg_22_1)
	local var_22_3 = tbl_12.options[arg_22_1]
	local value = var_22_3.value
	local text = var_22_3.text
	local _dynamic_range_widgets_by_name = self._dynamic_range_widgets_by_name
	local stepper = _dynamic_range_widgets_by_name.stepper

	stepper.content.setting_text = text
	stepper.content.value = value
	stepper.content.internal_value = var_22_2
	_dynamic_range_widgets_by_name.sound_presentation_image.content.texture_id = "sound_setting_icon_0" .. arg_22_1 + 4
end

TitleLoadingUI._update_continue_button = function (self, arg_23_1, arg_23_2)
	-- function 23
	self:_animate_button(self._done_button, arg_23_2)

	local get_service = Managers.input:get_service("title_loading_ui")

	if not arg_23_1 and get_service:get("confirm") and not self._done_button.content.button_hotspot.on_release then
		self._done_button.content.button_hotspot.on_release = nil

		local _settings_index = self._settings_index

		if _settings_index == 1 then
			local value = self._gamma_widgets_by_name.gamma_stepper.content.value

			Application.set_user_setting("render_settings", "gamma", value)
		elseif _settings_index == 2 then
			local value_2 = self._panning_widgets_by_name.stepper.content.value

			Application.set_user_setting("sound_panning_rule", value_2)
		elseif _settings_index == 3 then
			local value_3 = self._dynamic_range_widgets_by_name.stepper.content.value

			Application.set_user_setting("dynamic_range_sound", value_3)
		end

		if _settings_index == 3 then
			SaveData.gamma_corrected = true

			Managers.save:auto_save(SaveFileName, SaveData)

			if not IS_WINDOWS then
				Application.save_user_settings()
			end

			self._startup_settings_done = true
			self._needs_cursor_pop = false

			ShowCursorStack.hide("TitleLoadingUI")
		else
			self._settings_index = _settings_index + 1
		end
	end
end

TitleLoadingUI._animate_button = function (self, arg_24_1, arg_24_2)
	-- function 24
	local ui_renderer = self.ui_renderer
	local scenegraph_id = arg_24_1.scenegraph_id
	local content = arg_24_1.content
	local style = arg_24_1.style
	local button_hotspot = content.button_hotspot
	local is_hover = button_hotspot.is_hover
	local is_selected = button_hotspot.is_selected
	local is_clicked = button_hotspot.is_clicked

	is_clicked = not is_clicked and button_hotspot.is_clicked == 0

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_24_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_24_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_24_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_24_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_24_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_24_2 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
	local num_3 = 255 * input_progress

	style.clicked_rect.color[1] = 100 * input_progress

	local num_4 = 255 * hover_progress

	style.hover_glow.color[1] = num_4

	local num_5 = 255 * selection_progress
	local title_text_disabled = style.title_text_disabled
	local default_text_color = title_text_disabled.default_text_color
	local text_color = title_text_disabled.text_color

	text_color[2] = default_text_color[2] * 0.4
	text_color[3] = default_text_color[3] * 0.4
	text_color[4] = default_text_color[4] * 0.4
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress

	local title_text = style.title_text
	local text_color_2 = title_text.text_color
	local default_text_color_2 = title_text.default_text_color
	local select_text_color = title_text.select_text_color

	Colors.lerp_color_tables(default_text_color_2, select_text_color, max, text_color_2)
end

TitleLoadingUI._handle_stepper_input = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	local get_service = Managers.input:get_service("title_loading_ui")
	local content = arg_25_1.content
	local left_hotspot = content.left_hotspot
	local right_hotspot = content.right_hotspot

	if not left_hotspot.on_hover_enter then
		self:_on_stepper_arrow_hover(arg_25_1, "left_arrow_hover")
	elseif not left_hotspot.on_hover_exit then
		self:_on_stepper_arrow_dehover(arg_25_1, "left_arrow_hover")
	end

	if not right_hotspot.on_hover_enter then
		self:_on_stepper_arrow_hover(arg_25_1, "right_arrow_hover")
	elseif not right_hotspot.on_hover_exit then
		self:_on_stepper_arrow_dehover(arg_25_1, "right_arrow_hover")
	end

	local input_cooldown = content.input_cooldown
	local input_cooldown_multiplier = content.input_cooldown_multiplier
	local flag = false

	if not input_cooldown then
		flag = true

		local max = math.max(input_cooldown - arg_25_4, 0)

		input_cooldown = not (max > 0) or not max or nil
		content.input_cooldown = input_cooldown
	end

	local internal_value = content.internal_value
	local num_decimals = arg_25_2.num_decimals
	local min = arg_25_2.min
	local num = (arg_25_2.max - min) * 10^num_decimals
	local num_2 = 1 / num
	local flag_2 = not arg_25_3 and get_service:get("analog_input")
	local num_3 = 0.01
	local time = Managers.time:time("main")
	local flag_3 = false

	if left_hotspot.is_clicked == 0 or not arg_25_3 or not get_service:get("move_left_hold") then
		if not input_cooldown then
			internal_value = math.clamp(internal_value - num_2, 0, 1)
			flag_3 = true
		end
	elseif right_hotspot.is_clicked == 0 or not arg_25_3 or not get_service:get("move_right_hold") then
		if not input_cooldown then
			internal_value = math.clamp(internal_value + num_2, 0, 1)
			flag_3 = true
		end
	elseif not (not flag_2 and not (math.abs(flag_2.x) > 0) or input_cooldown) then
		local max_2 = math.max(math.abs(math.pow(flag_2.x, 2) * num * arg_25_4 * num_3), num_2)

		internal_value = math.clamp(internal_value + max_2 * math.sign(flag_2.x), 0, 1)
		flag_3 = true
	end

	local flag_4 = false

	if content.internal_value ~= internal_value then
		flag_4 = true
		content.internal_value = internal_value
	end

	if not flag_3 then
		if not flag then
			local max_3 = math.max(input_cooldown_multiplier - 0.1, 0.1)

			content.input_cooldown = 0.2 * math.ease_in_exp(max_3)
			content.input_cooldown_multiplier = max_3
		else
			local num_4 = 1

			content.input_cooldown = 0.2 * math.ease_in_exp(num_4)
			content.input_cooldown_multiplier = num_4
		end
	end

	return flag_4
end

TitleLoadingUI._on_stepper_arrow_hover = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local animations = arg_26_1.animations
	local var_26_1 = arg_26_1.style[arg_26_2]
	local var_26_2 = var_26_1.color[1]
	local num = 255
	local num_2 = 0.2
	local num_3 = (1 - var_26_2 / num) * num_2

	if num_3 > 0 then
		local str = "stepper_widget_arrow_hover_" .. arg_26_2

		animations[arg_26_0:_animate_element_by_time(var_26_1.color, 1, var_26_2, num, num_3)] = str
	else
		var_26_1.color[1] = num
	end
end

TitleLoadingUI._on_stepper_arrow_dehover = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	local animations = arg_27_1.animations
	local var_27_1 = arg_27_1.style[arg_27_2]
	local var_27_2 = var_27_1.color[1]
	local num = 0
	local num_2 = 0.2
	local num_3 = var_27_2 / 255 * num_2

	if num_3 > 0 then
		local str = "stepper_widget_arrow_hover_" .. arg_27_2

		animations[arg_27_0:_animate_element_by_time(var_27_1.color, 1, var_27_2, num, num_3)] = str
	else
		var_27_1.color[1] = num
	end
end

TitleLoadingUI._on_stepper_arrow_pressed = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local animations = arg_28_1.animations
	local var_28_1 = arg_28_1.style[arg_28_2]
	local default_size = var_28_1.default_size
	local var_28_3 = var_28_1.color[1]
	local num = 255
	local num_2 = 0.2

	if num_2 > 0 then
		local str = "stepper_widget_arrow_hover_" .. arg_28_2
		local str_2 = "stepper_widget_arrow_width_" .. arg_28_2
		local str_3 = "stepper_widget_arrow_height_" .. arg_28_2

		animations[arg_28_0:_animate_element_by_time(var_28_1.color, 1, var_28_3, num, num_2)] = str
		animations[arg_28_0:_animate_element_by_catmullrom(var_28_1.size, 1, default_size[1], 0.7, 1, 1, 0.7, num_2)] = str_2
		animations[arg_28_0:_animate_element_by_catmullrom(var_28_1.size, 2, default_size[2], 0.7, 1, 1, 0.7, num_2)] = str_3
	else
		var_28_1.color[1] = num
	end
end

TitleLoadingUI._animate_element_by_catmullrom = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8)
	-- function 29
	return (UIAnimation.init(UIAnimation.catmullrom, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8))
end

TitleLoadingUI._animate_element_by_time = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	-- function 30
	return (UIAnimation.init(UIAnimation.function_by_time, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, math.ease_out_quad))
end

TitleLoadingUI._get_input_texture_data = function (arg_31_0, arg_31_1)
	-- function 31
	local get_service = Managers.input:get_service("title_loading_ui")

	if Managers.input:is_device_active("keyboard") or not Managers.input:is_device_active("mouse") or not IS_WINDOWS then
		local PLATFORM = PLATFORM
		local get_keymapping = get_service:get_keymapping(arg_31_1, PLATFORM)
		local var_31_3 = get_keymapping[1]
		local var_31_4 = get_keymapping[2]
		local var_31_5 = get_keymapping[3]
		local flag = var_31_4 == UNASSIGNED_KEY
		local var_31_7
		local flag_2

		flag_2 = not flag and "" and Keyboard.button_locale_name(var_31_4)

		return var_31_7, flag_2
	elseif not (Managers.input:is_device_active("gamepad") or IS_WINDOWS) then
		return UISettings.get_gamepad_input_texture_data(get_service, arg_31_1, true)
	end
end

TitleLoadingUI._get_input_gamepad_texture_data = function (arg_32_0, arg_32_1)
	-- function 32
	local get_service = Managers.input:get_service("title_loading_ui")

	return UISettings.get_gamepad_input_texture_data(get_service, arg_32_1, true)
end

TitleLoadingUI._update_input_text = function (self, arg_33_1)
	-- function 33
	local content = self._skip_widget.content
	local style = self._skip_widget.style
	local _ui_scenegraph = self._ui_scenegraph
	local _get_input_texture_data, var_33_4 = self:_get_input_texture_data("cancel_video_1")

	if not _get_input_texture_data then
		if content.input_text ~= var_33_4 then
			content.input_text_1 = Localize("input_hold")
			content.input_text_2 = " [" .. Localize("any_key") .. "] "
			content.input_icon = nil
		end
	elseif _get_input_texture_data.texture ~= content.input_icon then
		content.input_text_1 = Localize("input_hold")
		_ui_scenegraph.skip_input_icon.size = _get_input_texture_data.size
		content.input_icon = _get_input_texture_data.texture
		content.input_text_2 = ""
	end

	local num = 10
	local flag

	flag = _get_input_texture_data or not true or false

	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and flag
	content.using_keyboard = IS_WINDOWS

	local var_33_8, var_33_9 = UIFontByResolution(style.input_text_1)
	local text_size, var_33_11, var_33_12 = UIRenderer.text_size(self._ui_renderer, content.input_text_1, var_33_8[1], var_33_9)

	_ui_scenegraph.skip_input_text_1.size[1] = text_size
	_ui_scenegraph.skip_input_icon.position[1] = _ui_scenegraph.skip_input_text_1.position[1] + text_size + num
	_ui_scenegraph.skip_input_text_2.position[1] = text_size

	if not _get_input_texture_data then
		_ui_scenegraph.skip_input_text_3.position[1] = _ui_scenegraph.skip_input_icon.position[1] + _ui_scenegraph.skip_input_icon.size[1] + num
	else
		local var_33_13, var_33_14 = UIFontByResolution(style.input_text_2)
		local var_33_15 = TextToUpper(content.input_text_2)
		local text_size_2, var_33_17, var_33_18 = UIRenderer.text_size(self._ui_renderer, var_33_15, var_33_13[1], var_33_14)

		_ui_scenegraph.skip_input_text_2.size[1] = text_size_2
		_ui_scenegraph.skip_input_text_3.position[1] = _ui_scenegraph.skip_input_text_2.position[1] + text_size_2
		self.hold_bar_max_length = text_size_2
		self._skip_widget.style.hold_bar_bg.size[1] = self.hold_bar_max_length
	end

	self._can_draw_input_widget = true
end

INPUTS_TO_REMOVE = {}

TitleLoadingUI._update_any_held = function (self)
	-- function 34
	local flag = false

	for k, v in pairs(self._current_inputs) do
		if v.button(k) < 1 then
			INPUTS_TO_REMOVE[#INPUTS_TO_REMOVE + 1] = k
		else
			flag = true
		end
	end

	for i, v_2 in ipairs(INPUTS_TO_REMOVE) do
		self._current_inputs[v_2] = nil
	end

	table.clear(INPUTS_TO_REMOVE)

	if IS_WINDOWS or not GameSettingsDevelopment.allow_keyboard_mouse then
		local any_pressed = Keyboard.any_pressed()

		if not any_pressed then
			self._current_inputs[any_pressed] = Keyboard
		end

		local any_pressed_2 = Mouse.any_pressed()

		if not any_pressed_2 then
			self._current_inputs[any_pressed_2] = Mouse
		end
	end

	local gamepad = InputAux.input_device_mapping.gamepad

	for i4 = 1, #gamepad do
		local var_34_4 = gamepad[i4]
		local any_pressed_3 = var_34_4.any_pressed()

		if not any_pressed_3 then
			self._current_inputs[any_pressed_3] = var_34_4
		end
	end

	return flag
end

TitleLoadingUI._update_input = function (self, arg_35_1)
	-- function 35
	if not self._force_done then
		self:_handle_skip_fade(0)

		return
	end

	local num = 1
	local num_2 = 1
	local clamp = math.clamp
	local _fade_timer = self._fade_timer

	_fade_timer = _fade_timer or 0
	self._fade_timer = clamp(_fade_timer - arg_35_1, 0, num_2)

	local get = Managers.input:get_service("title_loading_ui"):get("cancel_video")

	if not self:_update_any_held() then
		self._fade_timer = num_2

		local _cancel_timer = self._cancel_timer

		_cancel_timer = _cancel_timer or 0
		self._cancel_timer = _cancel_timer + arg_35_1
	else
		local _cancel_timer_2 = self._cancel_timer

		_cancel_timer_2 = _cancel_timer_2 or 0
		self._cancel_timer = _cancel_timer_2 - arg_35_1 * 3
	end

	self:_handle_skip_fade(self._fade_timer / num_2 * 255)

	self._cancel_timer = math.clamp(self._cancel_timer, 0, num)

	local num_3 = self._cancel_timer / num

	if num_3 >= 1 or not get or not self._cancel_video then
		self._cancel_timer = nil
		self._force_done = true
		self._done = true

		if not Managers.transition:loading_icon_active() then
			Managers.transition:show_loading_icon()
		end

		self._skip_widget.style.input_icon_bar.gradient_threshold = 0
		self._skip_widget.style.hold_bar.size[1] = 0

		if not self._sound_started then
			if not var_0_19.sound_stop then
				Managers.music:trigger_event(var_0_19.sound_stop)
			end

			self._sound_started = false
		end

		if not self._cinematic_package_loaded then
			Managers.package:unload("resource_packages/videos/" .. var_0_19.material_name, "intro_cinematic")

			self._cinematic_package_loaded = false
		end
	else
		local clamp_2 = math.clamp(num_3, 0, 1)

		self._skip_widget.style.input_icon_bar.gradient_threshold = clamp_2

		local hold_bar_max_length = self.hold_bar_max_length

		if not hold_bar_max_length then
			local num_4 = hold_bar_max_length * clamp_2

			self._skip_widget.style.hold_bar.size[1] = num_4
		end
	end

	local _cancel_video = self._cancel_video

	_cancel_video = _cancel_video or get
	self._cancel_video = _cancel_video
end

TitleLoadingUI._handle_skip_fade = function (self, arg_36_1)
	-- function 36
	local style = self._skip_widget.style

	style.input_text_1.text_color[1] = arg_36_1
	style.input_text_2.text_color[1] = arg_36_1
	style.input_text_3.text_color[1] = arg_36_1
	style.input_icon.color[1] = arg_36_1
	style.input_icon_bar.color[1] = arg_36_1
	style.hold_bar_bg.color[1] = arg_36_1
end

TitleLoadingUI._render = function (self, arg_37_1)
	-- function 37
	local input = Managers.input
	local get_service = input:get_service("title_loading_ui")
	local is_device_active = input:is_device_active("gamepad")

	UIRenderer.begin_pass(self._ui_renderer, self._ui_scenegraph, get_service, arg_37_1, nil, self.render_settings)

	if not self._startup_settings_done then
		local _settings_index = self._settings_index

		if _settings_index == 1 then
			for i, v in ipairs(self._gamma_widgets) do
				UIRenderer.draw_widget(self._ui_renderer, v)
			end
		elseif _settings_index == 2 then
			for i_2, v_2 in ipairs(self._panning_widgets) do
				UIRenderer.draw_widget(self._ui_renderer, v_2)
			end
		elseif _settings_index == 3 then
			for i_3, v_3 in ipairs(self._dynamic_range_widgets) do
				UIRenderer.draw_widget(self._ui_renderer, v_3)
			end
		end

		if not is_device_active then
			UIRenderer.draw_widget(self._ui_renderer, self._done_button)
		end
	else
		self:_render_video(arg_37_1)

		if not self._can_draw_input_widget then
			UIRenderer.draw_widget(self._ui_renderer, self._skip_widget)
		end
	end

	UIRenderer.draw_widget(self._ui_renderer, self._dead_space_filler_widget)
	UIRenderer.end_pass(self._ui_renderer)

	if not self._start_subtitles then
		local subtitle_template_settings = var_0_19.subtitle_template_settings

		if not subtitle_template_settings then
			self:_start_subtitles_by_template(subtitle_template_settings)
		end

		self._start_subtitles = false
	end

	if not (not is_device_active and self._startup_settings_done) then
		self._menu_input_description:draw(self._ui_renderer, arg_37_1)
	end

	if not self._done and not self:_has_active_subtitles() then
		self:_stop_subtitles()
	end
end

TitleLoadingUI._render_video = function (self, arg_38_1)
	-- function 38
	if not self._trailer then
		return
	end

	if not self._done then
		return
	end

	if not self._ui_renderer.video_players[str] then
		UIRenderer.create_video_player(self._ui_renderer, str, self._world, var_0_19.video_name, false)
	elseif not self._video_widget.content.video_content.video_completed then
		UIRenderer.destroy_video_player(self._ui_renderer, str)

		self._sound_started = false

		if not var_0_19.sound_stop then
			Managers.music:trigger_event(var_0_19.sound_stop)
		end

		self._done = true

		if not Managers.transition:loading_icon_active() then
			Managers.transition:show_loading_icon()
		end

		if not self._cinematic_package_loaded then
			Managers.package:unload("resource_packages/videos/" .. var_0_19.material_name, "intro_cinematic")

			self._cinematic_package_loaded = false
		end
	else
		if not self._sound_started then
			if not var_0_19.sound_start then
				Managers.music:trigger_event(var_0_19.sound_start)
			end

			self._sound_started = true
			self._start_subtitles = true
		end

		UIRenderer.draw_widget(self._ui_renderer, self._video_widget)
	end
end

TitleLoadingUI.destroy = function (self)
	-- function 39
	self:_stop_subtitles()

	if not self._ui_renderer then
		UIRenderer.destroy(self._ui_renderer, self._world)

		self._ui_renderer = nil
	end

	if not self._sound_started and not var_0_19.sound_stop then
		Managers.music:trigger_event(var_0_19.sound_stop)
	end

	Framerate.set_playing()

	if not self._needs_cursor_pop then
		ShowCursorStack.hide("TitleLoadingUI")

		self._needs_cursor_pop = false
	end
end

TitleLoadingUI.is_done = function (self)
	-- function 40
	local _startup_settings_done = self._startup_settings_done

	if not _startup_settings_done then
		_startup_settings_done = self._force_done
		_startup_settings_done = _startup_settings_done or self._done
	end

	return _startup_settings_done
end

TitleLoadingUI.force_done = function (self)
	-- function 41
	self._force_done = true
	self._cancel_timer = nil

	if not Managers.transition:loading_icon_active() then
		Managers.transition:show_loading_icon()
	end

	self._skip_widget.style.input_icon_bar.gradient_threshold = 0
end

TitleLoadingUI._start_subtitles_by_template = function (self, arg_42_1)
	-- function 42
	if not Application.user_setting("use_subtitles") then
		return
	end

	if not self.cutscene_overlay_ui then
		self.cutscene_overlay_ui:destroy()
	end

	local tbl = {
		ui_renderer = self._ui_renderer
	}

	self.cutscene_overlay_ui = CutsceneOverlayUI:new(self, tbl)

	self.cutscene_overlay_ui:force_unregister_event_listener()
	self.cutscene_overlay_ui:start(arg_42_1)
end

TitleLoadingUI._stop_subtitles = function (self)
	-- function 43
	if not self.cutscene_overlay_ui then
		self.cutscene_overlay_ui:destroy()
	end
end

TitleLoadingUI._has_active_subtitles = function (self)
	-- function 44
	return self.cutscene_overlay_ui ~= nil
end
