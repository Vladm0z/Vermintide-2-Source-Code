-- chunkname: @scripts/ui/views/splash_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_layer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local var_0_0 = {
	root = {
		is_root = true,
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
	screen = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
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
	background = {
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
			99
		}
	},
	background_fit = {
		vertical_alignment = "center",
		scale = "fit",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			99
		}
	},
	disclaimer = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1400,
			700
		},
		position = {
			0,
			0,
			0
		}
	},
	input_background = {
		vertical_alignment = "center",
		parent = "background_fit",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			100
		}
	},
	foreground = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			200
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
			100
		}
	},
	esrb = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1200,
			576
		}
	},
	warhammer = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			774,
			417
		}
	},
	bld_splash_partners = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		}
	},
	autodesk_splash = {
		vertical_alignment = "center",
		parent = "bld_splash_partners",
		horizontal_alignment = "center",
		size = {
			385,
			90
		},
		position = {
			-400,
			300,
			0
		}
	},
	partner_splash_umbra = {
		vertical_alignment = "center",
		parent = "bld_splash_partners",
		horizontal_alignment = "center",
		size = {
			313,
			128
		},
		position = {
			-400,
			0,
			0
		}
	},
	partner_splash_wwise = {
		vertical_alignment = "center",
		parent = "bld_splash_partners",
		horizontal_alignment = "center",
		size = {
			315,
			93
		},
		position = {
			-400,
			-300,
			0
		}
	},
	partner_splash_simplygon = {
		vertical_alignment = "center",
		parent = "bld_splash_partners",
		horizontal_alignment = "center",
		size = {
			150,
			107
		},
		position = {
			400,
			300,
			0
		}
	},
	partner_splash_dobly = {
		vertical_alignment = "center",
		parent = "bld_splash_partners",
		horizontal_alignment = "center",
		size = {
			314,
			80
		},
		position = {
			400,
			0,
			0
		}
	},
	partner_splash_dts = {
		vertical_alignment = "center",
		parent = "bld_splash_partners",
		horizontal_alignment = "center",
		size = {
			234,
			88
		},
		position = {
			400,
			-300,
			0
		}
	},
	partner_splash_pixeldiet = {
		vertical_alignment = "bottom",
		parent = "partner_splash_dts",
		horizontal_alignment = "left",
		size = {
			314,
			57
		},
		position = {
			-450,
			-230,
			0
		}
	},
	partner_splash_nordic_games = {
		vertical_alignment = "bottom",
		parent = "partner_splash_dts",
		horizontal_alignment = "center",
		size = {
			385,
			90
		},
		position = {
			0,
			-240,
			0
		}
	},
	partner_splash_black = {
		vertical_alignment = "center",
		parent = "bld_splash_partners",
		horizontal_alignment = "center",
		size = {
			222,
			139
		},
		position = {
			225,
			-230,
			0
		}
	},
	texts = {
		parent = "background"
	},
	beta_disclaimer = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1600,
			528
		}
	}
}

function create_xbox_beta_widget(arg_1_0)
	return {
		element = {
			passes = {
				{
					style_id = "foreground",
					scenegraph_id = "foreground",
					pass_type = "rect",
					content_check_function = function(arg_2_0)
						return arg_2_0.foreground.disable_foreground ~= true
					end
				},
				{
					texture_id = "material_name",
					style_id = "texture_style",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_1_0.scenegraph_id,
					content_check_function = function(arg_3_0)
						return arg_3_0.material_name
					end
				},
				{
					style_id = "input_style",
					pass_type = "texture",
					texture_id = "material_name",
					content_id = "input_texture_content",
					scenegraph_id = arg_1_0.input_scenegraph_id,
					content_check_function = function(arg_4_0)
						return arg_4_0.material_name
					end,
					content_change_function = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
						arg_5_0.timer = (arg_5_0.timer or 0) + arg_5_3

						local var_5_0 = 192 + 63 * math.sin(arg_5_0.timer * 4)

						arg_5_1.color[2] = var_5_0
						arg_5_1.color[3] = var_5_0
						arg_5_1.color[4] = var_5_0
					end
				}
			}
		},
		content = {
			texture_content = {
				material_name = arg_1_0.material_name
			},
			input_texture_content = {
				material_name = arg_1_0.input_material_name
			},
			foreground = {
				disable_foreground = arg_1_0.disable_foreground
			}
		},
		style = {
			foreground = {
				color = Colors.color_definitions.black
			},
			input_style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_1_0.input_texture_size,
				offset = arg_1_0.input_texture_offset or {
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
			texture_style = {
				size = arg_1_0.texture_size,
				offset = arg_1_0.texture_offset or {
					0,
					0,
					0
				}
			}
		},
		scenegraph_id = arg_1_0.scenegraph_id
	}
end

local function var_0_1(arg_6_0)
	return {
		scenegraph_id = "disclaimer",
		element = {
			passes = {
				{
					style_id = "foreground",
					scenegraph_id = "foreground",
					pass_type = "rect"
				},
				{
					pass_type = "rect",
					style_id = "divider"
				},
				{
					texture_id = "texture_id",
					style_id = "texture_style",
					pass_type = "texture"
				},
				{
					style_id = "header",
					pass_type = "text",
					text_id = "header_text"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "continue",
					pass_type = "text",
					text_id = "continue",
					scenegraph_id = "screen",
					content_check_function = function(arg_7_0)
						return arg_7_0.ready
					end,
					content_change_function = function(arg_8_0, arg_8_1)
						local var_8_0 = IS_CONSOLE or Managers.input:is_device_active("gamepad")
						local var_8_1, var_8_2 = Managers.time:time_and_delta("main")

						arg_8_0.timer = arg_8_0.timer + var_8_2 * 2
						arg_8_1.text_color[1] = 128 - math.cos(arg_8_0.timer) * 127
						arg_8_0.continue = var_8_0 and "press_any_button_to_continue" or "press_any_key_to_continue"
					end
				}
			}
		},
		content = {
			continue = "press_any_key_to_continue",
			timer = 0,
			ready = false,
			text = arg_6_0.text,
			header_text = arg_6_0.header_text,
			texture_id = arg_6_0.texture_id
		},
		style = {
			foreground = {
				color = Colors.color_definitions.black
			},
			texture_style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = arg_6_0.texture_size,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					0
				}
			},
			divider = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					1400,
					3
				},
				color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					-180,
					0
				}
			},
			header = {
				word_wrap = false,
				localize = true,
				font_size = 32,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				area_size = {
					1400,
					700
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-210,
					0
				}
			},
			text = {
				font_type = "hell_shark_header",
				font_size = 28,
				localize = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					1400,
					900
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-260,
					0
				}
			},
			continue = {
				vertical_alignment = "bottom",
				word_wrap = false,
				localize = true,
				font_type = "hell_shark",
				font_size = 32,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-50,
					50,
					0
				}
			}
		}
	}
end

local var_0_2 = {
	scenegraph_id = "dead_space_filler",
	element = {
		passes = {
			{
				pass_type = "rect",
				style_id = "rect"
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
		}
	}
}
local var_0_3 = {
	{
		video_name = "video/fatshark_splash",
		sound_start = "Play_fatshark_logo",
		scenegraph_id = "splash_video",
		type = "video",
		material_name = "fatshark_splash",
		sound_stop = "Stop_fatshark_logo"
	},
	{
		scenegraph_id = "warhammer",
		type = "texture",
		axis = 2,
		time = 3,
		text_vertical_alignment = "bottom",
		spacing = 5,
		text_horizontal_alignment = "center",
		pixel_perfect = false,
		dynamic_font = false,
		direction = 1,
		texts_scenegraph_id = "texts",
		font_type = "hell_shark",
		localize = true,
		font_size = 13,
		material_name = "warhammer",
		texts = {
			"gw_legal_1",
			"gw_legal_2",
			"gw_legal_3",
			"gw_legal_4"
		},
		size = {
			1920,
			13
		},
		offset = {
			0,
			110,
			0
		}
	},
	{
		texts_scenegraph_id = "texts",
		scenegraph_id = "bld_splash_partners",
		time = 3,
		type = "texture",
		font_size = 13,
		pixel_perfect = false,
		partner_splash = true,
		text_horizontal_alignment = "center",
		dynamic_font = false,
		spacing = 5,
		text_vertical_alignment = "bottom",
		font_type = "hell_shark",
		localize = true,
		texture_materials = {
			"autodesk_splash",
			"umbra",
			"wwise",
			"simplygon",
			"dolby",
			"dts"
		},
		offset = {
			0,
			110,
			0
		},
		texture_scenegraph_ids = {
			"autodesk_splash",
			"partner_splash_umbra",
			"partner_splash_wwise",
			"partner_splash_simplygon",
			"partner_splash_dobly",
			"partner_splash_dts"
		}
	},
	{
		text = "splash_seizure_disclaimer",
		forced = true,
		texture_id = "vermintide_2_logo",
		type = "disclaimer",
		time = 3,
		header_text = "splash_seizure_disclaimer_header",
		texture_size = {
			300,
			168
		}
	}
}

if Development.parameter("use_beta_mode") or script_data.settings.use_beta_mode then
	if IS_XB1 then
		local var_0_4 = false
		local var_0_5 = XboxOne.console_type()

		if var_0_5 == XboxOne.CONSOLE_TYPE_XBOX_ONE_X_DEVKIT or var_0_5 == XboxOne.CONSOLE_TYPE_XBOX_ONE_X or var_0_5 == XboxOne.CONSOLE_TYPE_XBOX_ANACONDA or var_0_5 == XboxOne.CONSOLE_TYPE_XBOX_SERIES_X_DEVKIT then
			var_0_4 = true
		end

		var_0_3[#var_0_3 + 1] = {
			input_scenegraph_id = "input_background",
			product_id = "ADAA6515-8206-49E5-B34C-405244800B46",
			type = "beta_end",
			scenegraph_id = "background_fit",
			texts_scenegraph_id = "texts",
			input_material_name = "storepage_button",
			forced = true,
			music_name = "Play_menu_screen_music",
			material_name = "beta_end_overlay",
			input_texture_size = var_0_4 and {
				1776,
				346
			} or {
				888,
				173
			},
			input_texture_offset = var_0_4 and {
				550,
				-260
			} or {
				275,
				-130
			},
			time = math.huge
		}
	elseif IS_PS4 then
		local var_0_6 = PS4.is_pro()

		var_0_3[#var_0_3 + 1] = {
			scenegraph_id = "background",
			type = "texture",
			axis = 2,
			time = 10,
			text_vertical_alignment = "center",
			forced = true,
			text_horizontal_alignment = "center",
			spacing = 5,
			dynamic_font = false,
			direction = 1,
			pixel_perfect = false,
			texts_scenegraph_id = "texts",
			font_type = "hell_shark",
			localize = false,
			texts = {
				"PRE-RELEASE SOFTWARE",
				"***",
				"This game is in a pre-release stage of development. This means ",
				"that some parts of the game, including online features",
				"(like chat and multiplayer), might not function as expected (or might",
				"not function at all). The game might even crash. Because this is",
				"a pre-release game, Fatshark does not commit",
				"to providing customer support for the game."
			},
			font_size = var_0_6 and 52 or 36,
			size = {
				1920,
				var_0_6 and 70 or 50
			},
			offset = {
				0,
				750,
				0
			}
		}
	elseif IS_WINDOWS and rawget(_G, "Steam") and Steam.app_id() == 1085780 then
		var_0_3[#var_0_3 + 1] = {
			scenegraph_id = "background",
			type = "texture",
			axis = 2,
			time = 10,
			text_vertical_alignment = "center",
			forced = true,
			text_horizontal_alignment = "center",
			spacing = 5,
			dynamic_font = false,
			direction = 1,
			pixel_perfect = false,
			texts_scenegraph_id = "texts",
			font_type = "hell_shark",
			localize = false,
			font_size = 36,
			texts = {
				"PRE-RELEASE SOFTWARE",
				"***",
				"This game is in a pre-release stage of development. This means ",
				"that some parts of the game, including online features",
				"(like chat and multiplayer), might not function as expected (or might",
				"not function at all). The game might even crash. Because this is",
				"a pre-release game, Fatshark does not commit",
				"to providing customer support for the game."
			},
			size = {
				1920,
				50
			},
			offset = {
				0,
				750,
				0
			}
		}
	end
end

local var_0_7 = "SplashView"

SplashView = class(SplashView)

function SplashView.init(arg_9_0, arg_9_1, arg_9_2)
	if IS_PS4 then
		PS4.hide_splash_screen()
	end

	arg_9_0._fram_skip_hack = 0
	arg_9_0.force_debug_enabled = Development.parameter("force_debug_enabled")
	arg_9_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_9_0._world = arg_9_2
	arg_9_0._current_index = 1
	arg_9_0.ui_renderer = UIRenderer.create(arg_9_2, "material", "video/fatshark_splash", "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_splash_screen")

	if arg_9_1 then
		arg_9_1:create_input_service("splash_view", "SplashScreenKeymaps", "SplashScreenFilters")
		arg_9_1:map_device_to_service("splash_view", "keyboard")
		arg_9_1:map_device_to_service("splash_view", "gamepad")
		arg_9_1:map_device_to_service("splash_view", "mouse")

		arg_9_0.input_manager = arg_9_1
	end

	arg_9_0:_create_ui_elements()

	if script_data["-no-rendering"] then
		arg_9_0._current_index = #var_0_3 + 1
	end

	arg_9_0:_next_splash(true)
end

function SplashView._next_splash(arg_10_0, arg_10_1)
	if not arg_10_1 and IS_CONSOLE and not arg_10_0._allow_console_skip then
		arg_10_0._update_func = "_wait_for_allow_console_skip"
		arg_10_0._video_complete = true

		return
	end

	arg_10_0._update_func = "do_nothing"
	arg_10_0._current_splash_data = var_0_3[arg_10_0._current_index]
	arg_10_0._current_widget = arg_10_0._splash_widgets[arg_10_0._current_index]

	if arg_10_0._current_splash_data then
		local var_10_0 = "_update_" .. arg_10_0._current_splash_data.type

		arg_10_0._update_func = arg_10_0[var_10_0] and var_10_0 or "_update_texture"
		arg_10_0._current_index = arg_10_0._current_index + 1
		arg_10_0._current_splash_data.timer = arg_10_0._current_splash_data.time
	elseif not Managers.transition:loading_icon_active() then
		Managers.transition:show_loading_icon()
	end
end

function SplashView._update_video(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0.ui_renderer.video_players[var_0_7] then
		UIRenderer.create_video_player(arg_11_0.ui_renderer, var_0_7, arg_11_0._world, arg_11_0._current_splash_data.video_name, false)
		Managers.transition:fade_out(0.5, nil)
	elseif arg_11_0._current_widget.content.video_content.video_completed then
		UIRenderer.destroy_video_player(arg_11_0.ui_renderer, var_0_7)

		arg_11_0._sound_started = false

		if arg_11_0._current_splash_data.sound_stop then
			Managers.music:trigger_event(arg_11_0._current_splash_data.sound_stop)
		end

		arg_11_0:_next_splash()
	else
		if not arg_11_0._sound_started then
			if arg_11_0._current_splash_data.sound_start then
				Managers.music:trigger_event(arg_11_0._current_splash_data.sound_start)
			end

			arg_11_0._sound_started = true
		end

		UIRenderer.draw_widget(arg_11_0.ui_renderer, arg_11_0._current_widget)
	end
end

function SplashView._update_texture(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0, var_12_1 = Gui.resolution()
	local var_12_2 = arg_12_0._current_splash_data.timer
	local var_12_3 = arg_12_0._current_splash_data.texts
	local var_12_4 = arg_12_0._current_splash_data.time

	arg_12_2 = math.min(arg_12_2, 0.03333333333333333)

	if var_12_2 > var_12_4 - 0.5 then
		local var_12_5 = 255 * ((var_12_2 - (var_12_4 - 0.5)) / 0.5)

		arg_12_0._current_widget.style.foreground.color[1] = var_12_5
	elseif var_12_2 <= 0.5 then
		local var_12_6 = 255 * (1 - var_12_2 / 0.5)

		arg_12_0._current_widget.style.foreground.color[1] = var_12_6
	else
		arg_12_0._current_widget.style.foreground.color[1] = 0
	end

	UIRenderer.draw_widget(arg_12_0.ui_renderer, arg_12_0._current_widget)

	arg_12_0._current_splash_data.timer = arg_12_0._current_splash_data.timer - arg_12_2

	if arg_12_0._current_splash_data.timer <= 0 then
		arg_12_0:_next_splash()
	end
end

function SplashView._update_disclaimer(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0, var_13_1 = Gui.resolution()
	local var_13_2 = arg_13_0._current_splash_data.timer
	local var_13_3 = arg_13_0._current_splash_data.texts
	local var_13_4 = arg_13_0._current_splash_data.time

	arg_13_2 = math.min(arg_13_2, 0.03333333333333333)

	if arg_13_0._current_splash_data.confirmed then
		local var_13_5 = 255 * (1 - var_13_2 / 0.5)

		arg_13_0._current_widget.style.foreground.color[1] = var_13_5
	elseif var_13_2 > var_13_4 - 0.5 then
		local var_13_6 = 255 * ((var_13_2 - (var_13_4 - 0.5)) / 0.5)

		arg_13_0._current_widget.style.foreground.color[1] = var_13_6
	elseif var_13_2 <= 0.5 then
		local var_13_7

		if IS_CONSOLE then
			var_13_7 = script_data.skip_splash or arg_13_0:_get_console_input()
		else
			local var_13_8 = arg_13_0.input_manager:get_service("splash_view")

			var_13_7 = script_data.skip_splash or var_13_8:get("skip_splash")
		end

		if var_13_7 then
			arg_13_0._current_splash_data.confirmed = true
		end

		arg_13_2 = 0
		arg_13_0._current_widget.style.foreground.color[1] = 0
		arg_13_0._current_widget.content.ready = true
	end

	UIRenderer.draw_widget(arg_13_0.ui_renderer, arg_13_0._current_widget)

	arg_13_0._current_splash_data.timer = arg_13_0._current_splash_data.timer - arg_13_2

	if arg_13_0._current_splash_data.timer <= 0 then
		arg_13_0:_next_splash()
	end
end

function SplashView._update_beta_end(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0, var_14_1 = Gui.resolution()
	local var_14_2 = arg_14_0._current_splash_data.timer
	local var_14_3 = arg_14_0._current_splash_data.texts
	local var_14_4 = arg_14_0._current_splash_data.time

	if arg_14_0._current_splash_data.music_name and not arg_14_0._sound_started then
		Managers.music:stop_all_sounds()
		Managers.music:trigger_event(arg_14_0._current_splash_data.music_name)

		arg_14_0._sound_started = true
	end

	arg_14_2 = math.min(arg_14_2, 0.03333333333333333)

	if var_14_2 <= 0.5 then
		local var_14_5 = 255 * (1 - var_14_2 / 0.5)

		arg_14_0._current_widget.style.foreground.color[1] = var_14_5
	else
		arg_14_0._current_widget.style.foreground.color[1] = 0
	end

	UIRenderer.draw_widget(arg_14_0.ui_renderer, arg_14_0._current_widget)

	arg_14_0._current_splash_data.timer = arg_14_0._current_splash_data.timer - arg_14_2

	local var_14_6 = "Pad"

	for iter_14_0 = 1, 8 do
		local var_14_7 = var_14_6 .. tostring(iter_14_0)
		local var_14_8 = rawget(_G, var_14_7)

		if var_14_8 and var_14_8.pressed(var_14_8.button_index("y")) then
			local var_14_9 = var_14_8.user_id()

			if var_14_9 then
				XboxLive.show_product_details(var_14_9, arg_14_0._current_splash_data.product_id)
			end
		end
	end
end

if IS_CONSOLE then
	function SplashView._wait_for_allow_console_skip(arg_15_0)
		if arg_15_0._allow_console_skip then
			arg_15_0:_next_splash()
		end
	end
end

function SplashView.set_index(arg_16_0, arg_16_1)
	arg_16_0._current_index = arg_16_1

	arg_16_0:_next_splash()
end

function SplashView._create_ui_elements(arg_17_0)
	arg_17_0._splash_widgets = {}
	arg_17_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0)
	arg_17_0.dead_space_filler = UIWidget.init(var_0_2)

	for iter_17_0, iter_17_1 in pairs(var_0_3) do
		local var_17_0

		if iter_17_1.type == "video" then
			var_17_0 = UIWidgets.create_splash_video(iter_17_1, var_0_7)
		elseif iter_17_1.type == "beta_end" then
			var_17_0 = create_xbox_beta_widget(iter_17_1)
		elseif iter_17_1.type == "disclaimer" then
			var_17_0 = var_0_1(iter_17_1)
		elseif iter_17_1.partner_splash then
			var_17_0 = UIWidgets.create_partner_splash_widget(iter_17_1)
		else
			var_17_0 = UIWidgets.create_splash_texture(iter_17_1)
		end

		arg_17_0._splash_widgets[#arg_17_0._splash_widgets + 1] = UIWidget.init(var_17_0)
	end

	UIRenderer.clear_scenegraph_queue(arg_17_0.ui_renderer)
end

function SplashView.update(arg_18_0, arg_18_1)
	if IS_WINDOWS and arg_18_0._fram_skip_hack < 1 then
		arg_18_0._fram_skip_hack = arg_18_0._fram_skip_hack + 1

		return
	end

	local var_18_0, var_18_1 = Gui.resolution()
	local var_18_2 = arg_18_0.ui_renderer
	local var_18_3 = IS_WINDOWS and arg_18_0.input_manager:get_service("splash_view") or FAKE_INPUT_SERVICE

	UIRenderer.begin_pass(var_18_2, arg_18_0.ui_scenegraph, var_18_3, arg_18_1, nil, arg_18_0.render_settings)
	UIRenderer.draw_widget(var_18_2, arg_18_0.dead_space_filler)

	local var_18_4

	if IS_CONSOLE then
		var_18_4 = script_data.skip_splash or arg_18_0:_get_console_input()
	else
		var_18_4 = script_data.skip_splash or var_18_3:get("skip_splash")
	end

	if var_18_4 and (not arg_18_0._current_splash_data or not arg_18_0._current_splash_data.forced) then
		if arg_18_0._current_splash_data and arg_18_0._current_splash_data.type == "video" then
			if var_18_2.video_players[var_0_7] then
				UIRenderer.destroy_video_player(arg_18_0.ui_renderer, var_0_7)
			end

			if arg_18_0._current_splash_data.sound_stop then
				Managers.music:trigger_event(arg_18_0._current_splash_data.sound_stop)
			end

			arg_18_0._sound_started = false
		end

		arg_18_0:_next_splash()
	elseif arg_18_0[arg_18_0._update_func] then
		arg_18_0[arg_18_0._update_func](arg_18_0, var_18_2.gui, arg_18_1)
	end

	UIRenderer.end_pass(var_18_2)
end

if IS_CONSOLE then
	function SplashView.allow_console_skip(arg_19_0)
		arg_19_0._allow_console_skip = true
	end

	function SplashView._get_console_input(arg_20_0)
		if not arg_20_0._allow_console_skip then
			return
		end

		local var_20_0 = "Pad"

		for iter_20_0 = 1, 8 do
			local var_20_1 = var_20_0 .. tostring(iter_20_0)
			local var_20_2 = rawget(_G, var_20_1)

			if var_20_2 and var_20_2.any_pressed() then
				return true
			end
		end

		if IS_XB1 and GameSettingsDevelopment.allow_keyboard_mouse and (Keyboard.any_pressed() or Mouse.any_pressed()) then
			return true
		end
	end
end

function SplashView.render(arg_21_0)
	return
end

function SplashView.video_complete(arg_22_0)
	return arg_22_0._video_complete
end

function SplashView.destroy(arg_23_0)
	Managers.music:stop_all_sounds()
	UIRenderer.destroy(arg_23_0.ui_renderer, arg_23_0._world)
end

function SplashView.is_completed(arg_24_0)
	return arg_24_0._current_splash_data == nil
end
