-- chunkname: @scripts/ui/views/splash_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_layer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local tbl = {
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

function create_xbox_beta_widget(self)
	-- function 1
	local tbl = {
		element = {
			passes = {
				{
					style_id = "foreground",
					scenegraph_id = "foreground",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 2
						return self.foreground.disable_foreground ~= true
					end
				},
				{
					texture_id = "material_name",
					style_id = "texture_style",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 3
						return self.material_name
					end
				},
				{
					style_id = "input_style",
					pass_type = "texture",
					texture_id = "material_name",
					content_id = "input_texture_content",
					scenegraph_id = self.input_scenegraph_id,
					content_check_function = function (self)
						-- function 4
						return self.material_name
					end,
					content_change_function = function (self, arg_5_1, arg_5_2, arg_5_3)
						-- function 5
						local timer = self.timer

						timer = timer or 0
						self.timer = timer + arg_5_3

						local num = 192 + 63 * math.sin(self.timer * 4)

						arg_5_1.color[2] = num
						arg_5_1.color[3] = num
						arg_5_1.color[4] = num
					end
				}
			}
		},
		content = {
			texture_content = {
				material_name = self.material_name
			},
			input_texture_content = {
				material_name = self.input_material_name
			},
			foreground = {
				disable_foreground = self.disable_foreground
			}
		}
	}
	local tbl_2 = {
		foreground = {
			color = Colors.color_definitions.black
		}
	}
	local tbl_3 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = self.input_texture_size
	}
	local input_texture_offset = self.input_texture_offset

	input_texture_offset = input_texture_offset or {
		0,
		0,
		0
	}
	tbl_3.offset = input_texture_offset
	tbl_3.color = {
		255,
		255,
		255,
		255
	}
	tbl_2.input_style = tbl_3

	local tbl_4 = {
		size = self.texture_size
	}
	local texture_offset = self.texture_offset

	texture_offset = texture_offset or {
		0,
		0,
		0
	}
	tbl_4.offset = texture_offset
	tbl_2.texture_style = tbl_4
	tbl.style = tbl_2
	tbl.scenegraph_id = self.scenegraph_id

	return tbl
end

local function fn(self)
	-- function 6
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
					content_check_function = function (self)
						-- function 7
						return self.ready
					end,
					content_change_function = function (self, arg_8_1)
						-- function 8
						local IS_CONSOLE = IS_CONSOLE

						IS_CONSOLE = IS_CONSOLE or Managers.input:is_device_active("gamepad")

						local time_and_delta, var_8_2 = Managers.time:time_and_delta("main")

						self.timer = self.timer + var_8_2 * 2
						arg_8_1.text_color[1] = 128 - math.cos(self.timer) * 127

						local flag

						flag = not IS_CONSOLE and "press_any_button_to_continue" and "press_any_key_to_continue"
						self.continue = flag
					end
				}
			}
		},
		content = {
			continue = "press_any_key_to_continue",
			timer = 0,
			ready = false,
			text = self.text,
			header_text = self.header_text,
			texture_id = self.texture_id
		},
		style = {
			foreground = {
				color = Colors.color_definitions.black
			},
			texture_style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = self.texture_size,
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

local tbl_2 = {
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
local tbl_3 = {
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

if Development.parameter("use_beta_mode") or not script_data.settings.use_beta_mode then
	if not IS_XB1 then
		local flag = false
		local console_type = XboxOne.console_type()

		if not (console_type == XboxOne.CONSOLE_TYPE_XBOX_ONE_X_DEVKIT or console_type == XboxOne.CONSOLE_TYPE_XBOX_ONE_X or console_type == XboxOne.CONSOLE_TYPE_XBOX_ANACONDA or console_type ~= XboxOne.CONSOLE_TYPE_XBOX_SERIES_X_DEVKIT) then
			flag = true
		end

		local num = #tbl_3 + 1
		local tbl_4 = {
			input_scenegraph_id = "input_background",
			product_id = "ADAA6515-8206-49E5-B34C-405244800B46",
			type = "beta_end",
			scenegraph_id = "background_fit",
			texts_scenegraph_id = "texts",
			input_material_name = "storepage_button",
			forced = true,
			music_name = "Play_menu_screen_music",
			material_name = "beta_end_overlay"
		}
		local tbl_5

		if not flag then
			tbl_5 = {
				1776,
				346
			}

			if not tbl_5 then
				-- Nothing
			end
		end

		tbl_5 = {
			888,
			173
		}

		::label_0_0::

		tbl_4.input_texture_size = tbl_5

		local tbl_6

		if not flag then
			tbl_6 = {
				550,
				-260
			}

			if not tbl_6 then
				-- Nothing
			end
		end

		tbl_6 = {
			275,
			-130
		}

		::label_0_1::

		tbl_4.input_texture_offset = tbl_6
		tbl_4.time = math.huge
		tbl_3[num] = tbl_4
	elseif not IS_PS4 then
		local is_pro = PS4.is_pro()
		local num_2 = #tbl_3 + 1
		local tbl_7 = {
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
			}
		}
		local flag_2

		flag_2 = not is_pro and 52 and 36
		tbl_7.font_size = flag_2

		local tbl_8 = {
			1920
		}
		local flag_3

		flag_3 = not is_pro and 70 and 50
		tbl_8[2] = flag_3
		tbl_7.size = tbl_8
		tbl_7.offset = {
			0,
			750,
			0
		}
		tbl_3[num_2] = tbl_7
	elseif not IS_WINDOWS then
		local var_0_16 = rawget(_G, "Steam")

		var_0_16 = not var_0_16 and Steam.app_id() == 1085780

		if not var_0_16 then
			tbl_3[#tbl_3 + 1] = {
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
end

local str = "SplashView"

SplashView = class(SplashView)

SplashView.init = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not IS_PS4 then
		PS4.hide_splash_screen()
	end

	self._fram_skip_hack = 0
	self.force_debug_enabled = Development.parameter("force_debug_enabled")
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._world = arg_9_2
	self._current_index = 1
	self.ui_renderer = UIRenderer.create(arg_9_2, "material", "video/fatshark_splash", "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_splash_screen")

	if not arg_9_1 then
		arg_9_1:create_input_service("splash_view", "SplashScreenKeymaps", "SplashScreenFilters")
		arg_9_1:map_device_to_service("splash_view", "keyboard")
		arg_9_1:map_device_to_service("splash_view", "gamepad")
		arg_9_1:map_device_to_service("splash_view", "mouse")

		self.input_manager = arg_9_1
	end

	self:_create_ui_elements()

	if not script_data["-no-rendering"] then
		self._current_index = #tbl_3 + 1
	end

	self:_next_splash(true)
end

SplashView._next_splash = function (self, arg_10_1)
	-- function 10
	if not ((arg_10_1 or not IS_CONSOLE) and self._allow_console_skip) then
		self._update_func = "_wait_for_allow_console_skip"
		self._video_complete = true

		return
	end

	self._update_func = "do_nothing"
	self._current_splash_data = tbl_3[self._current_index]
	self._current_widget = self._splash_widgets[self._current_index]

	if not self._current_splash_data then
		local str = "_update_" .. self._current_splash_data.type

		self._update_func = not self[str] and str and "_update_texture"
		self._current_index = self._current_index + 1
		self._current_splash_data.timer = self._current_splash_data.time
	elseif not Managers.transition:loading_icon_active() then
		Managers.transition:show_loading_icon()
	end
end

SplashView._update_video = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self.ui_renderer.video_players[str] then
		UIRenderer.create_video_player(self.ui_renderer, str, self._world, self._current_splash_data.video_name, false)
		Managers.transition:fade_out(0.5, nil)
	elseif not self._current_widget.content.video_content.video_completed then
		UIRenderer.destroy_video_player(self.ui_renderer, str)

		self._sound_started = false

		if not self._current_splash_data.sound_stop then
			Managers.music:trigger_event(self._current_splash_data.sound_stop)
		end

		self:_next_splash()
	else
		if not self._sound_started then
			if not self._current_splash_data.sound_start then
				Managers.music:trigger_event(self._current_splash_data.sound_start)
			end

			self._sound_started = true
		end

		UIRenderer.draw_widget(self.ui_renderer, self._current_widget)
	end
end

SplashView._update_texture = function (self, arg_12_1, arg_12_2)
	-- function 12
	local resolution, var_12_1 = Gui.resolution()
	local timer = self._current_splash_data.timer
	local texts = self._current_splash_data.texts
	local time = self._current_splash_data.time

	arg_12_2 = math.min(arg_12_2, 0.03333333333333333)

	if timer > time - 0.5 then
		local num = 255 * ((timer - (time - 0.5)) / 0.5)

		self._current_widget.style.foreground.color[1] = num
	elseif timer <= 0.5 then
		local num_2 = 255 * (1 - timer / 0.5)

		self._current_widget.style.foreground.color[1] = num_2
	else
		self._current_widget.style.foreground.color[1] = 0
	end

	UIRenderer.draw_widget(self.ui_renderer, self._current_widget)

	self._current_splash_data.timer = self._current_splash_data.timer - arg_12_2

	if self._current_splash_data.timer <= 0 then
		self:_next_splash()
	end
end

SplashView._update_disclaimer = function (self, arg_13_1, arg_13_2)
	-- function 13
	local resolution, var_13_1 = Gui.resolution()
	local timer = self._current_splash_data.timer
	local texts = self._current_splash_data.texts
	local time = self._current_splash_data.time

	arg_13_2 = math.min(arg_13_2, 0.03333333333333333)

	if not self._current_splash_data.confirmed then
		local num = 255 * (1 - timer / 0.5)

		self._current_widget.style.foreground.color[1] = num
	elseif timer > time - 0.5 then
		local num_2 = 255 * ((timer - (time - 0.5)) / 0.5)

		self._current_widget.style.foreground.color[1] = num_2
	elseif timer <= 0.5 then
		local var_13_7

		if not IS_CONSOLE then
			var_13_7 = script_data.skip_splash or self:_get_console_input()
		else
			local get_service = self.input_manager:get_service("splash_view")

			var_13_7 = script_data.skip_splash or get_service:get("skip_splash")
		end

		if not var_13_7 then
			self._current_splash_data.confirmed = true
		end

		arg_13_2 = 0
		self._current_widget.style.foreground.color[1] = 0
		self._current_widget.content.ready = true
	end

	UIRenderer.draw_widget(self.ui_renderer, self._current_widget)

	self._current_splash_data.timer = self._current_splash_data.timer - arg_13_2

	if self._current_splash_data.timer <= 0 then
		self:_next_splash()
	end
end

SplashView._update_beta_end = function (self, arg_14_1, arg_14_2)
	-- function 14
	local resolution, var_14_1 = Gui.resolution()
	local timer = self._current_splash_data.timer
	local texts = self._current_splash_data.texts
	local time = self._current_splash_data.time

	if not (not self._current_splash_data.music_name and self._sound_started) then
		Managers.music:stop_all_sounds()
		Managers.music:trigger_event(self._current_splash_data.music_name)

		self._sound_started = true
	end

	arg_14_2 = math.min(arg_14_2, 0.03333333333333333)

	if timer <= 0.5 then
		local num = 255 * (1 - timer / 0.5)

		self._current_widget.style.foreground.color[1] = num
	else
		self._current_widget.style.foreground.color[1] = 0
	end

	UIRenderer.draw_widget(self.ui_renderer, self._current_widget)

	self._current_splash_data.timer = self._current_splash_data.timer - arg_14_2

	local str = "Pad"

	for i = 1, 8 do
		local str_2 = str .. tostring(i)
		local var_14_8 = rawget(_G, str_2)

		if not var_14_8 and not var_14_8.pressed(var_14_8.button_index("y")) then
			local user_id = var_14_8.user_id()

			if not user_id then
				XboxLive.show_product_details(user_id, self._current_splash_data.product_id)
			end
		end
	end
end

if not IS_CONSOLE then
	SplashView._wait_for_allow_console_skip = function (self)
		-- function 15
		if not self._allow_console_skip then
			self:_next_splash()
		end
	end
end

SplashView.set_index = function (self, arg_16_1)
	-- function 16
	self._current_index = arg_16_1

	self:_next_splash()
end

SplashView._create_ui_elements = function (self)
	-- function 17
	self._splash_widgets = {}
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.dead_space_filler = UIWidget.init(tbl_2)

	for k, v in pairs(tbl_3) do
		local var_17_0

		if v.type == "video" then
			var_17_0 = UIWidgets.create_splash_video(v, str)
		elseif v.type == "beta_end" then
			var_17_0 = create_xbox_beta_widget(v)
		elseif v.type == "disclaimer" then
			var_17_0 = fn(v)
		elseif not v.partner_splash then
			var_17_0 = UIWidgets.create_partner_splash_widget(v)
		else
			var_17_0 = UIWidgets.create_splash_texture(v)
		end

		self._splash_widgets[#self._splash_widgets + 1] = UIWidget.init(var_17_0)
	end

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

SplashView.update = function (self, arg_18_1)
	-- function 18
	if not (not IS_WINDOWS and not (self._fram_skip_hack < 1)) then
		self._fram_skip_hack = self._fram_skip_hack + 1

		return
	end

	local resolution, var_18_1 = Gui.resolution()
	local ui_renderer = self.ui_renderer
	local get_service

	if not IS_WINDOWS then
		get_service = self.input_manager:get_service("splash_view")

		if not get_service then
			-- Nothing
		end
	end

	get_service = FAKE_INPUT_SERVICE

	::label_18_0::

	UIRenderer.begin_pass(ui_renderer, self.ui_scenegraph, get_service, arg_18_1, nil, self.render_settings)
	UIRenderer.draw_widget(ui_renderer, self.dead_space_filler)

	local var_18_4

	if not IS_CONSOLE then
		var_18_4 = script_data.skip_splash or self:_get_console_input()
	else
		var_18_4 = script_data.skip_splash or get_service:get("skip_splash")
	end

	if not (not var_18_4 and not self._current_splash_data and self._current_splash_data.forced) then
		if not (not self._current_splash_data and self._current_splash_data.type ~= "video") then
			if not ui_renderer.video_players[str] then
				UIRenderer.destroy_video_player(self.ui_renderer, str)
			end

			if not self._current_splash_data.sound_stop then
				Managers.music:trigger_event(self._current_splash_data.sound_stop)
			end

			self._sound_started = false
		end

		self:_next_splash()
	elseif not self[self._update_func] then
		self[self._update_func](self, ui_renderer.gui, arg_18_1)
	end

	UIRenderer.end_pass(ui_renderer)
end

if not IS_CONSOLE then
	SplashView.allow_console_skip = function (self)
		-- function 19
		self._allow_console_skip = true
	end

	SplashView._get_console_input = function (self)
		-- function 20
		if not self._allow_console_skip then
			return
		end

		local str = "Pad"

		for i = 1, 8 do
			local str_2 = str .. tostring(i)
			local var_20_2 = rawget(_G, str_2)

			if not var_20_2 and not var_20_2.any_pressed() then
				return true
			end
		end

		if not IS_XB1 and not GameSettingsDevelopment.allow_keyboard_mouse and Keyboard.any_pressed() and not Mouse.any_pressed() then
			return true
		end
	end
end

SplashView.render = function (arg_21_0)
	-- function 21
	return
end

SplashView.video_complete = function (self)
	-- function 22
	return self._video_complete
end

SplashView.destroy = function (self)
	-- function 23
	Managers.music:stop_all_sounds()
	UIRenderer.destroy(self.ui_renderer, self._world)
end

SplashView.is_completed = function (self)
	-- function 24
	return self._current_splash_data == nil
end
