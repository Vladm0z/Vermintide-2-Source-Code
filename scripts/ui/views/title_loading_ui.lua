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
local var_0_7 = {
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
				content_check_function = function(arg_1_0)
					return not arg_1_0.input_icon
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
				content_check_function = function(arg_2_0)
					return arg_2_0.input_icon
				end
			},
			{
				pass_type = "gradient_mask_texture",
				style_id = "input_icon_bar",
				texture_id = "input_icon_bar",
				content_check_function = function(arg_3_0)
					return not arg_3_0.using_keyboard
				end
			},
			{
				style_id = "hold_bar",
				pass_type = "rect",
				content_check_function = function(arg_4_0)
					return arg_4_0.using_keyboard
				end
			},
			{
				style_id = "hold_bar_bg",
				pass_type = "rect",
				content_check_function = function(arg_5_0)
					return arg_5_0.using_keyboard
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

local var_0_8 = {
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

local function var_0_9()
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
					content_check_function = function(arg_7_0)
						return arg_7_0.gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "gamepad_accept_icon",
					texture_id = "gamepad_accept_icon",
					content_check_function = function(arg_8_0)
						return arg_8_0.gamepad_active
					end
				},
				{
					style_id = "gamepad_navigation_text",
					pass_type = "text",
					text_id = "gamepad_navigation_text",
					content_check_function = function(arg_9_0)
						return arg_9_0.gamepad_active
					end
				},
				{
					style_id = "gamepad_accept_text",
					pass_type = "text",
					text_id = "gamepad_accept_text",
					content_check_function = function(arg_10_0)
						return arg_10_0.gamepad_active
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

local var_0_10 = {
	vertical_alignment = "center",
	upper_case = true,
	localize = true,
	horizontal_alignment = "center",
	font_size = 42,
	font_type = "hell_shark_header",
	scenegraph_id = "gamma_header_text",
	text_color = Colors.get_color_table_with_alpha("font_title", 255)
}
local var_0_11 = {
	vertical_alignment = "center",
	scenegraph_id = "gamma_info_text",
	localize = true,
	horizontal_alignment = "center",
	font_size = 24,
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255)
}
local var_0_12 = Colors.get_color_table_with_alpha("font_button_normal", 255)
local var_0_13 = {
	gamma_adjuster = var_0_9(),
	gamma_image = UIWidgets.create_background_with_frame("gamma_image", var_0_7.gamma_image.size, "gamma_settings_image_01", "button_frame_01"),
	gamma_correction_image = UIWidgets.create_background_with_frame("gamma_correction_image", var_0_7.gamma_correction_image.size, "gamma_settings_image_02", "button_frame_01"),
	gamma_stepper = UIWidgets.create_default_stepper("gamma_stepper", var_0_7.gamma_stepper.size),
	gamma_image_corners = UIWidgets.create_frame("gamma_image", var_0_7.gamma_image.size, "frame_corner_detail_01", 10)
}
local var_0_14 = {
	stepper = UIWidgets.create_default_stepper("gamma_stepper", var_0_7.gamma_stepper.size),
	sound_presentation_image = UIWidgets.create_simple_texture("sound_setting_icon_01", "sound_presentation_image", nil, nil, var_0_12),
	sound_option_1 = UIWidgets.create_simple_texture("sound_setting_icon_03", "sound_panning_option_1"),
	sound_option_1_glow = UIWidgets.create_simple_texture("sound_setting_icon_03_glow", "sound_panning_option_1_glow"),
	sound_option_button_1 = UIWidgets.create_simple_hotspot("sound_panning_option_1"),
	sound_option_2 = UIWidgets.create_simple_texture("sound_setting_icon_04", "sound_panning_option_2"),
	sound_option_2_glow = UIWidgets.create_simple_texture("sound_setting_icon_04_glow", "sound_panning_option_2_glow"),
	sound_option_button_2 = UIWidgets.create_simple_hotspot("sound_panning_option_2"),
	header = UIWidgets.create_simple_text("startup_settings_panning_rule_header", "gamma_header_text", nil, nil, var_0_10),
	description = UIWidgets.create_simple_text("startup_settings_panning_rule_desc", "gamma_info_text", nil, nil, var_0_11)
}
local var_0_15 = {
	stepper = UIWidgets.create_default_stepper("gamma_stepper", var_0_7.gamma_stepper.size),
	sound_presentation_image = UIWidgets.create_simple_texture("sound_setting_icon_05", "sound_range_presentation_image", nil, nil, var_0_12),
	header = UIWidgets.create_simple_text("startup_settings_dynamic_range_header", "gamma_header_text", nil, nil, var_0_10),
	description = UIWidgets.create_simple_text("startup_settings_dynamic_range_desc", "gamma_info_text", nil, nil, var_0_11)
}
local var_0_16 = UIWidgets.create_default_button("apply_button", var_0_7.apply_button.size, nil, nil, Localize("input_description_confirm"))
local var_0_17 = {
	video_name = "video/vermintide_2_prologue_intro",
	sound_start = "vermintide_2_prologue_intro",
	scenegraph_id = "splash_video",
	material_name = "vermintide_2_prologue_intro",
	sound_stop = "Stop_vermintide_2_prologue_intro",
	subtitle_template_settings = var_0_0
}
local var_0_18 = {
	video_name = "video/vermintide_2_shovel_intro",
	sound_start = "Play_vermintide_2_shovel_intro",
	scenegraph_id = "splash_video",
	material_name = "vermintide_2_shovel_intro",
	sound_stop = "Stop_vermintide_2_shovel_intro",
	subtitle_template_settings = var_0_6
}
local var_0_19 = var_0_18

local function var_0_20(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1 - arg_11_0

	return (math.clamp(arg_11_2, arg_11_0, arg_11_1) - arg_11_0) / var_11_0
end

local var_0_21 = {
	start_value = 2.2,
	min = 1.5,
	num_decimals = 1,
	max = 5
}
local var_0_22 = {
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
local var_0_23 = {
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
local var_0_24 = {
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
local var_0_25 = "TitleLoadingUI"

TitleLoadingUI = class(TitleLoadingUI)

function TitleLoadingUI.init(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	Framerate.set_low_power()

	var_0_19 = var_0_18

	local var_12_0 = Managers.backend:get_title_settings()

	if var_12_0 and var_12_0.video_override then
		var_0_19 = var_12_0.video_override

		if var_0_19.subtitle_template_settings_path and Application.can_get("lua", var_0_19.subtitle_template_settings_path) then
			var_0_19.subtitle_template_settings = local_require(var_0_19.subtitle_template_settings_path)
		end
	end

	if arg_12_2.is_prologue then
		var_0_19 = var_0_17
	end

	arg_12_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_12_0._world = arg_12_1
	arg_12_0._done = false
	arg_12_0._force_done = arg_12_3
	arg_12_0._startup_settings_done = false
	arg_12_0._settings_index = 1
	arg_12_0._needs_cursor_pop = false
	arg_12_0._current_inputs = {}
	arg_12_0._display_startup_settings = arg_12_2.gamma
	arg_12_0._trailer = arg_12_2.trailer

	if not arg_12_0._trailer and not arg_12_0._display_startup_settings then
		arg_12_0._done = true
	end

	Managers.input:create_input_service("title_loading_ui", "TitleLoadingKeyMaps", "TitleLoadingFilters")
	Managers.input:map_device_to_service("title_loading_ui", "keyboard")
	Managers.input:map_device_to_service("title_loading_ui", "mouse")
	Managers.input:map_device_to_service("title_loading_ui", "gamepad")

	if var_0_19 then
		Managers.package:load("resource_packages/videos/" .. var_0_19.material_name, "intro_cinematic", callback(arg_12_0, "cb_cinematic_package_loaded"), true)

		arg_12_0._loading_packages = true
	else
		arg_12_0:_setup_gui()
	end
end

function TitleLoadingUI.cb_cinematic_package_loaded(arg_13_0)
	arg_13_0._cinematic_package_loaded = true

	arg_13_0:_setup_gui()
end

function TitleLoadingUI.is_loading_packages(arg_14_0)
	return arg_14_0._loading_packages
end

function TitleLoadingUI._setup_gui(arg_15_0)
	arg_15_0._ui_renderer = UIRenderer.create(arg_15_0._world, "material", "materials/ui/ui_1080p_title_screen", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_menu_atlas_textures", "material", var_0_19.video_name, "material", "materials/fonts/gw_fonts")

	arg_15_0:_create_elements()

	arg_15_0._loading_packages = nil

	if Managers.transition:loading_icon_active() then
		Managers.transition:hide_loading_icon()
	end
end

function TitleLoadingUI._create_elements(arg_16_0)
	arg_16_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_7)
	arg_16_0._video_widget = UIWidget.init(UIWidgets.create_splash_video(var_0_19, var_0_25))
	arg_16_0._skip_widget = UIWidget.init(skip_widget)
	arg_16_0._dead_space_filler_widget = UIWidget.init(var_0_8)
	arg_16_0._done_button = UIWidget.init(var_0_16)

	if arg_16_0._display_startup_settings then
		ShowCursorStack.show("TitleLoadingUI")

		arg_16_0._needs_cursor_pop = true

		local var_16_0 = {}
		local var_16_1 = {}

		for iter_16_0, iter_16_1 in pairs(var_0_13) do
			local var_16_2 = UIWidget.init(iter_16_1)

			var_16_0[#var_16_0 + 1] = var_16_2
			var_16_1[iter_16_0] = var_16_2
		end

		arg_16_0._gamma_widgets = var_16_0
		arg_16_0._gamma_widgets_by_name = var_16_1

		local var_16_3 = {}
		local var_16_4 = {}

		for iter_16_2, iter_16_3 in pairs(var_0_14) do
			local var_16_5 = UIWidget.init(iter_16_3)

			var_16_3[#var_16_3 + 1] = var_16_5
			var_16_4[iter_16_2] = var_16_5
		end

		arg_16_0._panning_widgets = var_16_3
		arg_16_0._panning_widgets_by_name = var_16_4

		local var_16_6 = {}
		local var_16_7 = {}

		for iter_16_4, iter_16_5 in pairs(var_0_15) do
			local var_16_8 = UIWidget.init(iter_16_5)

			var_16_6[#var_16_6 + 1] = var_16_8
			var_16_7[iter_16_4] = var_16_8
		end

		arg_16_0._dynamic_range_widgets = var_16_6
		arg_16_0._dynamic_range_widgets_by_name = var_16_7

		arg_16_0:setup_gamma_menu()
		arg_16_0:setup_sound_panning_menu()
		arg_16_0:setup_sound_dynamic_range_menu()

		local var_16_9 = arg_16_0._gamma_widgets_by_name.gamma_adjuster
		local var_16_10, var_16_11 = arg_16_0:_get_input_gamepad_texture_data("confirm")

		var_16_9.content.gamepad_accept_icon = var_16_10.texture
		arg_16_0._ui_scenegraph.console_input_icon_2.size[1] = var_16_10.size[1]
		arg_16_0._ui_scenegraph.console_input_icon_2.size[2] = var_16_10.size[2]

		local var_16_12 = PLATFORM
		local var_16_13, var_16_14 = ButtonTextureByName("d_horizontal", IS_WINDOWS and "xb1" or var_16_12)

		var_16_9.content.gamepad_navigation_icon = var_16_13.texture
		arg_16_0._ui_scenegraph.console_input_icon_1.size[1] = var_16_13.size[1]
		arg_16_0._ui_scenegraph.console_input_icon_1.size[2] = var_16_13.size[2]

		local var_16_15 = Managers.input:get_service("title_loading_ui")

		arg_16_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_16_0._ui_renderer, var_16_15, 5, 10, var_0_24.default)

		arg_16_0._menu_input_description:set_input_description(nil)
	else
		arg_16_0._startup_settings_done = true
	end

	DO_RELOAD = false
end

DO_RELOAD = true

function TitleLoadingUI.setup_gamma_menu(arg_17_0)
	local var_17_0 = arg_17_0._gamma_widgets_by_name.gamma_stepper
	local var_17_1 = arg_17_0._gamma_widgets_by_name.gamma_adjuster
	local var_17_2 = var_0_21.min
	local var_17_3 = var_0_21.max
	local var_17_4 = var_0_21.start_value
	local var_17_5 = Application.user_setting("render_settings", "gamma") or var_17_4

	var_17_0.content.setting_text = ""
	var_17_0.content.value = var_17_5

	local var_17_6 = var_0_20(var_17_2, var_17_3, var_17_5)

	var_17_0.content.internal_value = var_17_6
	var_17_1.content.value_text = string.format("%.1f", var_17_5)
end

function TitleLoadingUI.setup_sound_panning_menu(arg_18_0)
	local var_18_0 = arg_18_0._panning_widgets_by_name.stepper
	local var_18_1 = var_0_22.min
	local var_18_2 = var_0_22.max
	local var_18_3 = var_0_22.start_value
	local var_18_4 = var_0_22.options
	local var_18_5 = var_0_22.option_index_by_key
	local var_18_6 = DefaultUserSettings.get("user_settings", "sound_panning_rule")
	local var_18_7 = Application.user_setting("sound_panning_rule") or var_18_6

	var_18_0.content.setting_text = ""
	var_18_0.content.value = var_18_7
	var_18_0.content.internal_value = var_18_3

	arg_18_0:_change_sound_panning_display_by_value(var_18_3)
end

function TitleLoadingUI.setup_sound_dynamic_range_menu(arg_19_0)
	local var_19_0 = arg_19_0._dynamic_range_widgets_by_name.stepper
	local var_19_1 = var_0_23.min
	local var_19_2 = var_0_23.max
	local var_19_3 = var_0_23.start_value
	local var_19_4 = var_0_23.options
	local var_19_5 = var_0_23.option_index_by_key
	local var_19_6 = DefaultUserSettings.get("user_settings", "dynamic_range_sound")
	local var_19_7 = Application.user_setting("dynamic_range_sound") or var_19_6

	var_19_0.content.setting_text = ""
	var_19_0.content.value = var_19_7
	var_19_0.content.internal_value = var_19_3

	arg_19_0:_change_sound_dynamic_range_display_by_value(var_19_3)
end

function TitleLoadingUI.update(arg_20_0, arg_20_1, arg_20_2)
	if DO_RELOAD then
		arg_20_0:_create_elements()
	end

	if not arg_20_0._ui_renderer then
		return
	end

	if not arg_20_0._startup_settings_done then
		local var_20_0 = Managers.input:is_device_active("gamepad")
		local var_20_1 = arg_20_0._settings_index

		if var_20_1 == 1 then
			local var_20_2 = arg_20_0._gamma_widgets_by_name.gamma_stepper

			if arg_20_0:_handle_stepper_input(var_20_2, var_0_21, var_20_0, arg_20_1) then
				local var_20_3 = var_0_21.min
				local var_20_4 = var_0_21.max
				local var_20_5 = var_0_21.num_decimals
				local var_20_6 = var_20_2.content.internal_value
				local var_20_7 = math.round_with_precision(var_20_3 + (var_20_4 - var_20_3) * var_20_6, var_20_5 or 0)

				var_20_2.content.value = var_20_7
				arg_20_0._gamma_widgets_by_name.gamma_adjuster.content.value_text = string.format("%.1f", var_20_7)

				Application.set_render_setting("gamma", var_20_7)
			end
		elseif var_20_1 == 2 then
			local var_20_8 = arg_20_0._panning_widgets_by_name
			local var_20_9 = var_20_8.stepper

			if arg_20_0:_handle_stepper_input(var_20_9, var_0_22, var_20_0, arg_20_1) then
				local var_20_10 = var_0_22.min
				local var_20_11 = var_0_22.max
				local var_20_12 = var_0_22.num_decimals
				local var_20_13 = var_20_9.content.internal_value
				local var_20_14 = math.round_with_precision(var_20_10 + (var_20_11 - var_20_10) * var_20_13, var_20_12 or 0)
				local var_20_15 = var_0_22.options[var_20_14]

				var_20_9.content.value = var_20_15.value

				arg_20_0:_change_sound_panning_display_by_value(var_20_14)
			else
				for iter_20_0 = 1, 2 do
					local var_20_16 = var_20_8["sound_option_button_" .. iter_20_0].content.hotspot

					if var_20_16.on_release and not var_20_16.is_selected then
						var_20_16.on_release = false

						arg_20_0:_change_sound_panning_display_by_value(iter_20_0)

						break
					end
				end
			end
		elseif var_20_1 == 3 then
			local var_20_17 = arg_20_0._dynamic_range_widgets_by_name.stepper

			if arg_20_0:_handle_stepper_input(var_20_17, var_0_23, var_20_0, arg_20_1) then
				local var_20_18 = var_0_23.min
				local var_20_19 = var_0_23.max
				local var_20_20 = var_0_23.num_decimals
				local var_20_21 = var_20_17.content.internal_value
				local var_20_22 = math.round_with_precision(var_20_18 + (var_20_19 - var_20_18) * var_20_21, var_20_20 or 0)
				local var_20_23 = var_0_23.options[var_20_22]

				var_20_17.content.value = var_20_23.value

				arg_20_0:_change_sound_dynamic_range_display_by_value(var_20_22)
			end
		end

		arg_20_0:_update_continue_button(var_20_0, arg_20_1)
	else
		arg_20_0:_update_input_text(arg_20_1)
		arg_20_0:_update_input(arg_20_1)
	end

	arg_20_0:_render(arg_20_1)

	if arg_20_0.cutscene_overlay_ui then
		arg_20_0.cutscene_overlay_ui:update(arg_20_1)
	end
end

function TitleLoadingUI._change_sound_panning_display_by_value(arg_21_0, arg_21_1)
	local var_21_0 = var_0_22.min
	local var_21_1 = var_0_22.max
	local var_21_2 = var_0_20(var_21_0, var_21_1, arg_21_1)
	local var_21_3 = var_0_22.options[arg_21_1].value
	local var_21_4 = arg_21_0._panning_widgets_by_name
	local var_21_5 = var_21_4.stepper

	var_21_5.content.value = var_21_3
	var_21_5.content.internal_value = var_21_2

	for iter_21_0 = 1, 2 do
		var_21_4[("sound_option_" .. iter_21_0) .. "_glow"].content.visible = arg_21_1 == iter_21_0
		var_21_4["sound_option_button_" .. iter_21_0].content.hotspot.is_selected = iter_21_0 == arg_21_1
	end

	var_21_4.sound_presentation_image.content.texture_id = "sound_setting_icon_0" .. arg_21_1
end

function TitleLoadingUI._change_sound_dynamic_range_display_by_value(arg_22_0, arg_22_1)
	local var_22_0 = var_0_23.min
	local var_22_1 = var_0_23.max
	local var_22_2 = var_0_20(var_22_0, var_22_1, arg_22_1)
	local var_22_3 = var_0_23.options[arg_22_1]
	local var_22_4 = var_22_3.value
	local var_22_5 = var_22_3.text
	local var_22_6 = arg_22_0._dynamic_range_widgets_by_name
	local var_22_7 = var_22_6.stepper

	var_22_7.content.setting_text = var_22_5
	var_22_7.content.value = var_22_4
	var_22_7.content.internal_value = var_22_2
	var_22_6.sound_presentation_image.content.texture_id = "sound_setting_icon_0" .. arg_22_1 + 4
end

function TitleLoadingUI._update_continue_button(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0:_animate_button(arg_23_0._done_button, arg_23_2)

	local var_23_0 = Managers.input:get_service("title_loading_ui")

	if arg_23_1 and var_23_0:get("confirm") or arg_23_0._done_button.content.button_hotspot.on_release then
		arg_23_0._done_button.content.button_hotspot.on_release = nil

		local var_23_1 = arg_23_0._settings_index

		if var_23_1 == 1 then
			local var_23_2 = arg_23_0._gamma_widgets_by_name.gamma_stepper.content.value

			Application.set_user_setting("render_settings", "gamma", var_23_2)
		elseif var_23_1 == 2 then
			local var_23_3 = arg_23_0._panning_widgets_by_name.stepper.content.value

			Application.set_user_setting("sound_panning_rule", var_23_3)
		elseif var_23_1 == 3 then
			local var_23_4 = arg_23_0._dynamic_range_widgets_by_name.stepper.content.value

			Application.set_user_setting("dynamic_range_sound", var_23_4)
		end

		if var_23_1 == 3 then
			SaveData.gamma_corrected = true

			Managers.save:auto_save(SaveFileName, SaveData)

			if IS_WINDOWS then
				Application.save_user_settings()
			end

			arg_23_0._startup_settings_done = true
			arg_23_0._needs_cursor_pop = false

			ShowCursorStack.hide("TitleLoadingUI")
		else
			arg_23_0._settings_index = var_23_1 + 1
		end
	end
end

function TitleLoadingUI._animate_button(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0.ui_renderer
	local var_24_1 = arg_24_1.scenegraph_id
	local var_24_2 = arg_24_1.content
	local var_24_3 = arg_24_1.style
	local var_24_4 = var_24_2.button_hotspot
	local var_24_5 = var_24_4.is_hover
	local var_24_6 = var_24_4.is_selected
	local var_24_7 = var_24_4.is_clicked and var_24_4.is_clicked == 0
	local var_24_8 = var_24_4.input_progress or 0
	local var_24_9 = var_24_4.hover_progress or 0
	local var_24_10 = var_24_4.selection_progress or 0
	local var_24_11 = 8
	local var_24_12 = 20

	if var_24_7 then
		var_24_8 = math.min(var_24_8 + arg_24_2 * var_24_12, 1)
	else
		var_24_8 = math.max(var_24_8 - arg_24_2 * var_24_12, 0)
	end

	local var_24_13 = math.easeOutCubic(var_24_8)
	local var_24_14 = math.easeInCubic(var_24_8)

	if var_24_5 then
		var_24_9 = math.min(var_24_9 + arg_24_2 * var_24_11, 1)
	else
		var_24_9 = math.max(var_24_9 - arg_24_2 * var_24_11, 0)
	end

	local var_24_15 = math.easeOutCubic(var_24_9)
	local var_24_16 = math.easeInCubic(var_24_9)

	if var_24_6 then
		var_24_10 = math.min(var_24_10 + arg_24_2 * var_24_11, 1)
	else
		var_24_10 = math.max(var_24_10 - arg_24_2 * var_24_11, 0)
	end

	local var_24_17 = math.easeOutCubic(var_24_10)
	local var_24_18 = math.easeInCubic(var_24_10)
	local var_24_19 = math.max(var_24_9, var_24_10)
	local var_24_20 = math.max(var_24_17, var_24_15)
	local var_24_21 = math.max(var_24_16, var_24_18)
	local var_24_22 = 255 * var_24_8

	var_24_3.clicked_rect.color[1] = 100 * var_24_8

	local var_24_23 = 255 * var_24_9

	var_24_3.hover_glow.color[1] = var_24_23

	local var_24_24 = 255 * var_24_10
	local var_24_25 = var_24_3.title_text_disabled
	local var_24_26 = var_24_25.default_text_color
	local var_24_27 = var_24_25.text_color

	var_24_27[2] = var_24_26[2] * 0.4
	var_24_27[3] = var_24_26[3] * 0.4
	var_24_27[4] = var_24_26[4] * 0.4
	var_24_4.hover_progress = var_24_9
	var_24_4.input_progress = var_24_8
	var_24_4.selection_progress = var_24_10

	local var_24_28 = var_24_3.title_text
	local var_24_29 = var_24_28.text_color
	local var_24_30 = var_24_28.default_text_color
	local var_24_31 = var_24_28.select_text_color

	Colors.lerp_color_tables(var_24_30, var_24_31, var_24_19, var_24_29)
end

function TitleLoadingUI._handle_stepper_input(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = Managers.input:get_service("title_loading_ui")
	local var_25_1 = arg_25_1.content
	local var_25_2 = var_25_1.left_hotspot
	local var_25_3 = var_25_1.right_hotspot

	if var_25_2.on_hover_enter then
		arg_25_0:_on_stepper_arrow_hover(arg_25_1, "left_arrow_hover")
	elseif var_25_2.on_hover_exit then
		arg_25_0:_on_stepper_arrow_dehover(arg_25_1, "left_arrow_hover")
	end

	if var_25_3.on_hover_enter then
		arg_25_0:_on_stepper_arrow_hover(arg_25_1, "right_arrow_hover")
	elseif var_25_3.on_hover_exit then
		arg_25_0:_on_stepper_arrow_dehover(arg_25_1, "right_arrow_hover")
	end

	local var_25_4 = var_25_1.input_cooldown
	local var_25_5 = var_25_1.input_cooldown_multiplier
	local var_25_6 = false

	if var_25_4 then
		var_25_6 = true

		local var_25_7 = math.max(var_25_4 - arg_25_4, 0)

		var_25_4 = var_25_7 > 0 and var_25_7 or nil
		var_25_1.input_cooldown = var_25_4
	end

	local var_25_8 = var_25_1.internal_value
	local var_25_9 = arg_25_2.num_decimals
	local var_25_10 = arg_25_2.min
	local var_25_11 = (arg_25_2.max - var_25_10) * 10^var_25_9
	local var_25_12 = 1 / var_25_11
	local var_25_13 = arg_25_3 and var_25_0:get("analog_input")
	local var_25_14 = 0.01
	local var_25_15 = Managers.time:time("main")
	local var_25_16 = false

	if var_25_2.is_clicked == 0 or arg_25_3 and var_25_0:get("move_left_hold") then
		if not var_25_4 then
			var_25_8 = math.clamp(var_25_8 - var_25_12, 0, 1)
			var_25_16 = true
		end
	elseif var_25_3.is_clicked == 0 or arg_25_3 and var_25_0:get("move_right_hold") then
		if not var_25_4 then
			var_25_8 = math.clamp(var_25_8 + var_25_12, 0, 1)
			var_25_16 = true
		end
	elseif var_25_13 and math.abs(var_25_13.x) > 0 and not var_25_4 then
		local var_25_17 = math.max(math.abs(math.pow(var_25_13.x, 2) * var_25_11 * arg_25_4 * var_25_14), var_25_12)

		var_25_8 = math.clamp(var_25_8 + var_25_17 * math.sign(var_25_13.x), 0, 1)
		var_25_16 = true
	end

	local var_25_18 = false

	if var_25_1.internal_value ~= var_25_8 then
		var_25_18 = true
		var_25_1.internal_value = var_25_8
	end

	if var_25_16 then
		if var_25_6 then
			local var_25_19 = math.max(var_25_5 - 0.1, 0.1)

			var_25_1.input_cooldown = 0.2 * math.ease_in_exp(var_25_19)
			var_25_1.input_cooldown_multiplier = var_25_19
		else
			local var_25_20 = 1

			var_25_1.input_cooldown = 0.2 * math.ease_in_exp(var_25_20)
			var_25_1.input_cooldown_multiplier = var_25_20
		end
	end

	return var_25_18
end

function TitleLoadingUI._on_stepper_arrow_hover(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_1.animations
	local var_26_1 = arg_26_1.style[arg_26_2]
	local var_26_2 = var_26_1.color[1]
	local var_26_3 = 255
	local var_26_4 = 0.2
	local var_26_5 = (1 - var_26_2 / var_26_3) * var_26_4

	if var_26_5 > 0 then
		local var_26_6 = "stepper_widget_arrow_hover_" .. arg_26_2

		var_26_0[arg_26_0:_animate_element_by_time(var_26_1.color, 1, var_26_2, var_26_3, var_26_5)] = var_26_6
	else
		var_26_1.color[1] = var_26_3
	end
end

function TitleLoadingUI._on_stepper_arrow_dehover(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_1.animations
	local var_27_1 = arg_27_1.style[arg_27_2]
	local var_27_2 = var_27_1.color[1]
	local var_27_3 = 0
	local var_27_4 = 0.2
	local var_27_5 = var_27_2 / 255 * var_27_4

	if var_27_5 > 0 then
		local var_27_6 = "stepper_widget_arrow_hover_" .. arg_27_2

		var_27_0[arg_27_0:_animate_element_by_time(var_27_1.color, 1, var_27_2, var_27_3, var_27_5)] = var_27_6
	else
		var_27_1.color[1] = var_27_3
	end
end

function TitleLoadingUI._on_stepper_arrow_pressed(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_1.animations
	local var_28_1 = arg_28_1.style[arg_28_2]
	local var_28_2 = var_28_1.default_size
	local var_28_3 = var_28_1.color[1]
	local var_28_4 = 255
	local var_28_5 = 0.2

	if var_28_5 > 0 then
		local var_28_6 = "stepper_widget_arrow_hover_" .. arg_28_2
		local var_28_7 = "stepper_widget_arrow_width_" .. arg_28_2
		local var_28_8 = "stepper_widget_arrow_height_" .. arg_28_2

		var_28_0[arg_28_0:_animate_element_by_time(var_28_1.color, 1, var_28_3, var_28_4, var_28_5)] = var_28_6
		var_28_0[arg_28_0:_animate_element_by_catmullrom(var_28_1.size, 1, var_28_2[1], 0.7, 1, 1, 0.7, var_28_5)] = var_28_7
		var_28_0[arg_28_0:_animate_element_by_catmullrom(var_28_1.size, 2, var_28_2[2], 0.7, 1, 1, 0.7, var_28_5)] = var_28_8
	else
		var_28_1.color[1] = var_28_4
	end
end

function TitleLoadingUI._animate_element_by_catmullrom(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8))
end

function TitleLoadingUI._animate_element_by_time(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, math.ease_out_quad))
end

function TitleLoadingUI._get_input_texture_data(arg_31_0, arg_31_1)
	local var_31_0 = Managers.input:get_service("title_loading_ui")

	if (Managers.input:is_device_active("keyboard") or Managers.input:is_device_active("mouse")) and IS_WINDOWS then
		local var_31_1 = PLATFORM
		local var_31_2 = var_31_0:get_keymapping(arg_31_1, var_31_1)
		local var_31_3 = var_31_2[1]
		local var_31_4 = var_31_2[2]
		local var_31_5 = var_31_2[3]
		local var_31_6 = var_31_4 == UNASSIGNED_KEY

		return nil, var_31_6 and "" or Keyboard.button_locale_name(var_31_4)
	elseif Managers.input:is_device_active("gamepad") or not IS_WINDOWS then
		return UISettings.get_gamepad_input_texture_data(var_31_0, arg_31_1, true)
	end
end

function TitleLoadingUI._get_input_gamepad_texture_data(arg_32_0, arg_32_1)
	local var_32_0 = Managers.input:get_service("title_loading_ui")

	return UISettings.get_gamepad_input_texture_data(var_32_0, arg_32_1, true)
end

function TitleLoadingUI._update_input_text(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0._skip_widget.content
	local var_33_1 = arg_33_0._skip_widget.style
	local var_33_2 = arg_33_0._ui_scenegraph
	local var_33_3, var_33_4 = arg_33_0:_get_input_texture_data("cancel_video_1")

	if not var_33_3 then
		if var_33_0.input_text ~= var_33_4 then
			var_33_0.input_text_1 = Localize("input_hold")
			var_33_0.input_text_2 = " [" .. Localize("any_key") .. "] "
			var_33_0.input_icon = nil
		end
	elseif var_33_3.texture ~= var_33_0.input_icon then
		var_33_0.input_text_1 = Localize("input_hold")
		var_33_2.skip_input_icon.size = var_33_3.size
		var_33_0.input_icon = var_33_3.texture
		var_33_0.input_text_2 = ""
	end

	local var_33_5 = 10
	local var_33_6 = not var_33_3 and true or false

	var_33_0.using_keyboard = IS_WINDOWS and var_33_6

	local var_33_7, var_33_8 = UIFontByResolution(var_33_1.input_text_1)
	local var_33_9, var_33_10, var_33_11 = UIRenderer.text_size(arg_33_0._ui_renderer, var_33_0.input_text_1, var_33_7[1], var_33_8)

	var_33_2.skip_input_text_1.size[1] = var_33_9
	var_33_2.skip_input_icon.position[1] = var_33_2.skip_input_text_1.position[1] + var_33_9 + var_33_5
	var_33_2.skip_input_text_2.position[1] = var_33_9

	if var_33_3 then
		var_33_2.skip_input_text_3.position[1] = var_33_2.skip_input_icon.position[1] + var_33_2.skip_input_icon.size[1] + var_33_5
	else
		local var_33_12, var_33_13 = UIFontByResolution(var_33_1.input_text_2)
		local var_33_14 = TextToUpper(var_33_0.input_text_2)
		local var_33_15, var_33_16, var_33_17 = UIRenderer.text_size(arg_33_0._ui_renderer, var_33_14, var_33_12[1], var_33_13)

		var_33_2.skip_input_text_2.size[1] = var_33_15
		var_33_2.skip_input_text_3.position[1] = var_33_2.skip_input_text_2.position[1] + var_33_15
		arg_33_0.hold_bar_max_length = var_33_15
		arg_33_0._skip_widget.style.hold_bar_bg.size[1] = arg_33_0.hold_bar_max_length
	end

	arg_33_0._can_draw_input_widget = true
end

INPUTS_TO_REMOVE = {}

function TitleLoadingUI._update_any_held(arg_34_0)
	local var_34_0 = false

	for iter_34_0, iter_34_1 in pairs(arg_34_0._current_inputs) do
		if iter_34_1.button(iter_34_0) < 1 then
			INPUTS_TO_REMOVE[#INPUTS_TO_REMOVE + 1] = iter_34_0
		else
			var_34_0 = true
		end
	end

	for iter_34_2, iter_34_3 in ipairs(INPUTS_TO_REMOVE) do
		arg_34_0._current_inputs[iter_34_3] = nil
	end

	table.clear(INPUTS_TO_REMOVE)

	if IS_WINDOWS or GameSettingsDevelopment.allow_keyboard_mouse then
		local var_34_1 = Keyboard.any_pressed()

		if var_34_1 then
			arg_34_0._current_inputs[var_34_1] = Keyboard
		end

		local var_34_2 = Mouse.any_pressed()

		if var_34_2 then
			arg_34_0._current_inputs[var_34_2] = Mouse
		end
	end

	local var_34_3 = InputAux.input_device_mapping.gamepad

	for iter_34_4 = 1, #var_34_3 do
		local var_34_4 = var_34_3[iter_34_4]
		local var_34_5 = var_34_4.any_pressed()

		if var_34_5 then
			arg_34_0._current_inputs[var_34_5] = var_34_4
		end
	end

	return var_34_0
end

function TitleLoadingUI._update_input(arg_35_0, arg_35_1)
	if arg_35_0._force_done then
		arg_35_0:_handle_skip_fade(0)

		return
	end

	local var_35_0 = 1
	local var_35_1 = 1

	arg_35_0._fade_timer = math.clamp((arg_35_0._fade_timer or 0) - arg_35_1, 0, var_35_1)

	local var_35_2 = Managers.input:get_service("title_loading_ui"):get("cancel_video")

	if arg_35_0:_update_any_held() then
		arg_35_0._fade_timer = var_35_1
		arg_35_0._cancel_timer = (arg_35_0._cancel_timer or 0) + arg_35_1
	else
		arg_35_0._cancel_timer = (arg_35_0._cancel_timer or 0) - arg_35_1 * 3
	end

	arg_35_0:_handle_skip_fade(arg_35_0._fade_timer / var_35_1 * 255)

	arg_35_0._cancel_timer = math.clamp(arg_35_0._cancel_timer, 0, var_35_0)

	local var_35_3 = arg_35_0._cancel_timer / var_35_0

	if var_35_3 >= 1 or var_35_2 and arg_35_0._cancel_video then
		arg_35_0._cancel_timer = nil
		arg_35_0._force_done = true
		arg_35_0._done = true

		if not Managers.transition:loading_icon_active() then
			Managers.transition:show_loading_icon()
		end

		arg_35_0._skip_widget.style.input_icon_bar.gradient_threshold = 0
		arg_35_0._skip_widget.style.hold_bar.size[1] = 0

		if arg_35_0._sound_started then
			if var_0_19.sound_stop then
				Managers.music:trigger_event(var_0_19.sound_stop)
			end

			arg_35_0._sound_started = false
		end

		if arg_35_0._cinematic_package_loaded then
			Managers.package:unload("resource_packages/videos/" .. var_0_19.material_name, "intro_cinematic")

			arg_35_0._cinematic_package_loaded = false
		end
	else
		local var_35_4 = math.clamp(var_35_3, 0, 1)

		arg_35_0._skip_widget.style.input_icon_bar.gradient_threshold = var_35_4

		local var_35_5 = arg_35_0.hold_bar_max_length

		if var_35_5 then
			local var_35_6 = var_35_5 * var_35_4

			arg_35_0._skip_widget.style.hold_bar.size[1] = var_35_6
		end
	end

	arg_35_0._cancel_video = arg_35_0._cancel_video or var_35_2
end

function TitleLoadingUI._handle_skip_fade(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._skip_widget.style

	var_36_0.input_text_1.text_color[1] = arg_36_1
	var_36_0.input_text_2.text_color[1] = arg_36_1
	var_36_0.input_text_3.text_color[1] = arg_36_1
	var_36_0.input_icon.color[1] = arg_36_1
	var_36_0.input_icon_bar.color[1] = arg_36_1
	var_36_0.hold_bar_bg.color[1] = arg_36_1
end

function TitleLoadingUI._render(arg_37_0, arg_37_1)
	local var_37_0 = Managers.input
	local var_37_1 = var_37_0:get_service("title_loading_ui")
	local var_37_2 = var_37_0:is_device_active("gamepad")

	UIRenderer.begin_pass(arg_37_0._ui_renderer, arg_37_0._ui_scenegraph, var_37_1, arg_37_1, nil, arg_37_0.render_settings)

	if not arg_37_0._startup_settings_done then
		local var_37_3 = arg_37_0._settings_index

		if var_37_3 == 1 then
			for iter_37_0, iter_37_1 in ipairs(arg_37_0._gamma_widgets) do
				UIRenderer.draw_widget(arg_37_0._ui_renderer, iter_37_1)
			end
		elseif var_37_3 == 2 then
			for iter_37_2, iter_37_3 in ipairs(arg_37_0._panning_widgets) do
				UIRenderer.draw_widget(arg_37_0._ui_renderer, iter_37_3)
			end
		elseif var_37_3 == 3 then
			for iter_37_4, iter_37_5 in ipairs(arg_37_0._dynamic_range_widgets) do
				UIRenderer.draw_widget(arg_37_0._ui_renderer, iter_37_5)
			end
		end

		if not var_37_2 then
			UIRenderer.draw_widget(arg_37_0._ui_renderer, arg_37_0._done_button)
		end
	else
		arg_37_0:_render_video(arg_37_1)

		if arg_37_0._can_draw_input_widget then
			UIRenderer.draw_widget(arg_37_0._ui_renderer, arg_37_0._skip_widget)
		end
	end

	UIRenderer.draw_widget(arg_37_0._ui_renderer, arg_37_0._dead_space_filler_widget)
	UIRenderer.end_pass(arg_37_0._ui_renderer)

	if arg_37_0._start_subtitles then
		local var_37_4 = var_0_19.subtitle_template_settings

		if var_37_4 then
			arg_37_0:_start_subtitles_by_template(var_37_4)
		end

		arg_37_0._start_subtitles = false
	end

	if var_37_2 and not arg_37_0._startup_settings_done then
		arg_37_0._menu_input_description:draw(arg_37_0._ui_renderer, arg_37_1)
	end

	if arg_37_0._done and arg_37_0:_has_active_subtitles() then
		arg_37_0:_stop_subtitles()
	end
end

function TitleLoadingUI._render_video(arg_38_0, arg_38_1)
	if not arg_38_0._trailer then
		return
	end

	if arg_38_0._done then
		return
	end

	if not arg_38_0._ui_renderer.video_players[var_0_25] then
		UIRenderer.create_video_player(arg_38_0._ui_renderer, var_0_25, arg_38_0._world, var_0_19.video_name, false)
	elseif arg_38_0._video_widget.content.video_content.video_completed then
		UIRenderer.destroy_video_player(arg_38_0._ui_renderer, var_0_25)

		arg_38_0._sound_started = false

		if var_0_19.sound_stop then
			Managers.music:trigger_event(var_0_19.sound_stop)
		end

		arg_38_0._done = true

		if not Managers.transition:loading_icon_active() then
			Managers.transition:show_loading_icon()
		end

		if arg_38_0._cinematic_package_loaded then
			Managers.package:unload("resource_packages/videos/" .. var_0_19.material_name, "intro_cinematic")

			arg_38_0._cinematic_package_loaded = false
		end
	else
		if not arg_38_0._sound_started then
			if var_0_19.sound_start then
				Managers.music:trigger_event(var_0_19.sound_start)
			end

			arg_38_0._sound_started = true
			arg_38_0._start_subtitles = true
		end

		UIRenderer.draw_widget(arg_38_0._ui_renderer, arg_38_0._video_widget)
	end
end

function TitleLoadingUI.destroy(arg_39_0)
	arg_39_0:_stop_subtitles()

	if arg_39_0._ui_renderer then
		UIRenderer.destroy(arg_39_0._ui_renderer, arg_39_0._world)

		arg_39_0._ui_renderer = nil
	end

	if arg_39_0._sound_started and var_0_19.sound_stop then
		Managers.music:trigger_event(var_0_19.sound_stop)
	end

	Framerate.set_playing()

	if arg_39_0._needs_cursor_pop then
		ShowCursorStack.hide("TitleLoadingUI")

		arg_39_0._needs_cursor_pop = false
	end
end

function TitleLoadingUI.is_done(arg_40_0)
	return arg_40_0._startup_settings_done and (arg_40_0._force_done or arg_40_0._done)
end

function TitleLoadingUI.force_done(arg_41_0)
	arg_41_0._force_done = true
	arg_41_0._cancel_timer = nil

	if not Managers.transition:loading_icon_active() then
		Managers.transition:show_loading_icon()
	end

	arg_41_0._skip_widget.style.input_icon_bar.gradient_threshold = 0
end

function TitleLoadingUI._start_subtitles_by_template(arg_42_0, arg_42_1)
	if not Application.user_setting("use_subtitles") then
		return
	end

	if arg_42_0.cutscene_overlay_ui then
		arg_42_0.cutscene_overlay_ui:destroy()
	end

	local var_42_0 = {
		ui_renderer = arg_42_0._ui_renderer
	}

	arg_42_0.cutscene_overlay_ui = CutsceneOverlayUI:new(arg_42_0, var_42_0)

	arg_42_0.cutscene_overlay_ui:force_unregister_event_listener()
	arg_42_0.cutscene_overlay_ui:start(arg_42_1)
end

function TitleLoadingUI._stop_subtitles(arg_43_0)
	if arg_43_0.cutscene_overlay_ui then
		arg_43_0.cutscene_overlay_ui:destroy()
	end
end

function TitleLoadingUI._has_active_subtitles(arg_44_0)
	return arg_44_0.cutscene_overlay_ui ~= nil
end
