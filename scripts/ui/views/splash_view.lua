-- chunkname: @scripts/ui/views/splash_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_layer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local scenegraph_definition = {
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

function create_xbox_beta_widget(input)
	-- function 1
	local tbl = {
		element = {
			passes = {
				{
					style_id = "foreground",
					scenegraph_id = "foreground",
					pass_type = "rect",
					content_check_function = function (content)
						-- function 2
						return content.foreground.disable_foreground ~= true
					end
				},
				{
					texture_id = "material_name",
					style_id = "texture_style",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = input.scenegraph_id,
					content_check_function = function (content)
						-- function 3
						return content.material_name
					end
				},
				{
					style_id = "input_style",
					pass_type = "texture",
					texture_id = "material_name",
					content_id = "input_texture_content",
					scenegraph_id = input.input_scenegraph_id,
					content_check_function = function (content)
						-- function 4
						return content.material_name
					end,
					content_change_function = function (content, style, ui_animations, dt)
						-- function 5
						local timer = content.timer

						timer = not not timer or not not 0
						content.timer = timer + dt

						local intensity = 192 + 63 * math.sin(content.timer * 4)

						style.color[2] = intensity
						style.color[3] = intensity
						style.color[4] = intensity
					end
				}
			}
		},
		content = {
			texture_content = {
				material_name = input.material_name
			},
			input_texture_content = {
				material_name = input.input_material_name
			},
			foreground = {
				disable_foreground = input.disable_foreground
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
		texture_size = input.input_texture_size
	}
	local input_texture_offset = input.input_texture_offset

	input_texture_offset = not not input_texture_offset or not not {
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
		size = input.texture_size
	}
	local texture_offset = input.texture_offset

	texture_offset = not not texture_offset or not not {
		0,
		0,
		0
	}
	tbl_4.offset = texture_offset
	tbl_2.texture_style = tbl_4
	tbl.style = tbl_2
	tbl.scenegraph_id = input.scenegraph_id

	return tbl
end

local function create_disclaimer_widget(input)
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
					content_check_function = function (content)
						-- function 7
						return content.ready
					end,
					content_change_function = function (content, style)
						-- function 8
						local IS_CONSOLE = IS_CONSOLE

						if not IS_CONSOLE then
							-- Nothing
						end

						IS_CONSOLE = Managers.input:is_device_active("gamepad")

						local gamepad_active = IS_CONSOLE

						::label_8_0::

						local time, dt = Managers.time:time_and_delta("main")

						content.timer = content.timer + dt * 2
						style.text_color[1] = 128 - math.cos(content.timer) * 127

						local flag

						flag = (not gamepad_active or not "press_any_button_to_continue") and not not "press_any_key_to_continue"
						content.continue = flag
					end
				}
			}
		},
		content = {
			continue = "press_any_key_to_continue",
			timer = 0,
			ready = false,
			text = input.text,
			header_text = input.header_text,
			texture_id = input.texture_id
		},
		style = {
			foreground = {
				color = Colors.color_definitions.black
			},
			texture_style = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = input.texture_size,
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

local dead_space_filler = {
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
local splash_content = {
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
		local is_xbox_one_x = false
		local console_type = XboxOne.console_type()

		if console_type == XboxOne.CONSOLE_TYPE_XBOX_ONE_X_DEVKIT or console_type == XboxOne.CONSOLE_TYPE_XBOX_ONE_X or console_type == XboxOne.CONSOLE_TYPE_XBOX_ANACONDA or console_type == XboxOne.CONSOLE_TYPE_XBOX_SERIES_X_DEVKIT then
			is_xbox_one_x = true
		end

		local num = #splash_content + 1
		local tbl = {
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
		local tbl_2

		if is_xbox_one_x then
			tbl_2 = {
				1776,
				346
			}

			if not tbl_2 then
				-- Nothing
			end
		end

		tbl_2 = {
			888,
			173
		}

		::label_0_0::

		tbl.input_texture_size = tbl_2

		local tbl_3

		if is_xbox_one_x then
			tbl_3 = {
				550,
				-260
			}

			if not tbl_3 then
				-- Nothing
			end
		end

		tbl_3 = {
			275,
			-130
		}

		::label_0_1::

		tbl.input_texture_offset = tbl_3
		tbl.time = math.huge
		splash_content[num] = tbl
	elseif IS_PS4 then
		local is_pro = PS4.is_pro()
		local num_2 = #splash_content + 1
		local tbl_4 = {
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
		local flag

		flag = (not is_pro or not 52) and not not 36
		tbl_4.font_size = flag

		local tbl_5 = {
			1920
		}
		local flag_2

		flag_2 = (not is_pro or not 70) and not not 50
		tbl_5[2] = flag_2
		tbl_4.size = tbl_5
		tbl_4.offset = {
			0,
			750,
			0
		}
		splash_content[num_2] = tbl_4
	elseif IS_WINDOWS then
		local var_0_9 = rawget(_G, "Steam")

		if var_0_9 then
			-- Nothing
		end

		if Steam.app_id() ~= 1085780 then
			var_0_9 = false

			goto label_0_2
		end

		var_0_9 = true

		local is_beta = var_0_9

		::label_0_2::

		if is_beta then
			splash_content[#splash_content + 1] = {
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

local VIDEO_REFERENCE_NAME = "SplashView"

SplashView = class(SplashView)

SplashView.init = function (self, input_manager, world)
	-- function 9
	if IS_PS4 then
		PS4.hide_splash_screen()
	end

	self._fram_skip_hack = 0
	self.force_debug_enabled = Development.parameter("force_debug_enabled")
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._world = world
	self._current_index = 1
	self.ui_renderer = UIRenderer.create(world, "material", "video/fatshark_splash", "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_splash_screen")

	if input_manager then
		input_manager:create_input_service("splash_view", "SplashScreenKeymaps", "SplashScreenFilters")
		input_manager:map_device_to_service("splash_view", "keyboard")
		input_manager:map_device_to_service("splash_view", "gamepad")
		input_manager:map_device_to_service("splash_view", "mouse")

		self.input_manager = input_manager
	end

	self:_create_ui_elements()

	if script_data["-no-rendering"] then
		self._current_index = #splash_content + 1
	end

	self:_next_splash(true)
end

SplashView._next_splash = function (self, override_skip)
	-- function 10
	if not override_skip and IS_CONSOLE and not self._allow_console_skip then
		self._update_func = "_wait_for_allow_console_skip"
		self._video_complete = true

		return
	end

	self._update_func = "do_nothing"
	self._current_splash_data = splash_content[self._current_index]
	self._current_widget = self._splash_widgets[self._current_index]

	if self._current_splash_data then
		local update_func = "_update_" .. self._current_splash_data.type

		self._update_func = (not self[update_func] or not update_func) and not not "_update_texture"
		self._current_index = self._current_index + 1
		self._current_splash_data.timer = self._current_splash_data.time
	elseif not Managers.transition:loading_icon_active() then
		Managers.transition:show_loading_icon()
	end
end

SplashView._update_video = function (self, gui, dt)
	-- function 11
	if not self.ui_renderer.video_players[VIDEO_REFERENCE_NAME] then
		UIRenderer.create_video_player(self.ui_renderer, VIDEO_REFERENCE_NAME, self._world, self._current_splash_data.video_name, false)
		Managers.transition:fade_out(0.5, nil)
	else
		local video_complete = self._current_widget.content.video_content.video_completed

		if video_complete then
			UIRenderer.destroy_video_player(self.ui_renderer, VIDEO_REFERENCE_NAME)

			self._sound_started = false

			if self._current_splash_data.sound_stop then
				Managers.music:trigger_event(self._current_splash_data.sound_stop)
			end

			self:_next_splash()
		else
			if not self._sound_started then
				if self._current_splash_data.sound_start then
					Managers.music:trigger_event(self._current_splash_data.sound_start)
				end

				self._sound_started = true
			end

			UIRenderer.draw_widget(self.ui_renderer, self._current_widget)
		end
	end
end

SplashView._update_texture = function (self, gui, dt)
	-- function 12
	local w, h = Gui.resolution()
	local timer = self._current_splash_data.timer
	local texts = self._current_splash_data.texts
	local total_time = self._current_splash_data.time

	dt = math.min(dt, 0.03333333333333333)

	if timer > total_time - 0.5 then
		local value = 255 * ((timer - (total_time - 0.5)) / 0.5)

		self._current_widget.style.foreground.color[1] = value
	elseif timer <= 0.5 then
		local value = 255 * (1 - timer / 0.5)

		self._current_widget.style.foreground.color[1] = value
	else
		self._current_widget.style.foreground.color[1] = 0
	end

	UIRenderer.draw_widget(self.ui_renderer, self._current_widget)

	self._current_splash_data.timer = self._current_splash_data.timer - dt

	if self._current_splash_data.timer <= 0 then
		self:_next_splash()
	end
end

SplashView._update_disclaimer = function (self, gui, dt)
	-- function 13
	local w, h = Gui.resolution()
	local timer = self._current_splash_data.timer
	local texts = self._current_splash_data.texts
	local total_time = self._current_splash_data.time

	dt = math.min(dt, 0.03333333333333333)

	if self._current_splash_data.confirmed then
		local value = 255 * (1 - timer / 0.5)

		self._current_widget.style.foreground.color[1] = value
	elseif timer > total_time - 0.5 then
		local value = 255 * ((timer - (total_time - 0.5)) / 0.5)

		self._current_widget.style.foreground.color[1] = value
	elseif timer <= 0.5 then
		local skip

		if IS_CONSOLE then
			skip = not not script_data.skip_splash or not not self:_get_console_input()
		else
			local input_service = self.input_manager:get_service("splash_view")

			skip = not not script_data.skip_splash or not not input_service:get("skip_splash")
		end

		if skip then
			self._current_splash_data.confirmed = true
		end

		dt = 0
		self._current_widget.style.foreground.color[1] = 0
		self._current_widget.content.ready = true
	end

	UIRenderer.draw_widget(self.ui_renderer, self._current_widget)

	self._current_splash_data.timer = self._current_splash_data.timer - dt

	if self._current_splash_data.timer <= 0 then
		self:_next_splash()
	end
end

SplashView._update_beta_end = function (self, gui, dt)
	-- function 14
	local w, h = Gui.resolution()
	local timer = self._current_splash_data.timer
	local texts = self._current_splash_data.texts
	local total_time = self._current_splash_data.time

	if self._current_splash_data.music_name and not self._sound_started then
		Managers.music:stop_all_sounds()
		Managers.music:trigger_event(self._current_splash_data.music_name)

		self._sound_started = true
	end

	dt = math.min(dt, 0.03333333333333333)

	if timer <= 0.5 then
		local value = 255 * (1 - timer / 0.5)

		self._current_widget.style.foreground.color[1] = value
	else
		self._current_widget.style.foreground.color[1] = 0
	end

	UIRenderer.draw_widget(self.ui_renderer, self._current_widget)

	self._current_splash_data.timer = self._current_splash_data.timer - dt

	local pad = "Pad"

	for i = 1, 8 do
		local pad_name = pad .. tostring(i)
		local pad_controller = rawget(_G, pad_name)

		if pad_controller and pad_controller.pressed(pad_controller.button_index("y")) then
			local user_id = pad_controller.user_id()

			if user_id then
				XboxLive.show_product_details(user_id, self._current_splash_data.product_id)
			end
		end
	end
end

if IS_CONSOLE then
	SplashView._wait_for_allow_console_skip = function (self)
		-- function 15
		if self._allow_console_skip then
			self:_next_splash()
		end
	end
end

SplashView.set_index = function (self, index)
	-- function 16
	self._current_index = index

	self:_next_splash()
end

SplashView._create_ui_elements = function (self)
	-- function 17
	self._splash_widgets = {}
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.dead_space_filler = UIWidget.init(dead_space_filler)

	for _, splash in pairs(splash_content) do
		local widget

		if splash.type == "video" then
			widget = UIWidgets.create_splash_video(splash, VIDEO_REFERENCE_NAME)
		elseif splash.type == "beta_end" then
			widget = create_xbox_beta_widget(splash)
		elseif splash.type == "disclaimer" then
			widget = create_disclaimer_widget(splash)
		elseif splash.partner_splash then
			widget = UIWidgets.create_partner_splash_widget(splash)
		else
			widget = UIWidgets.create_splash_texture(splash)
		end

		self._splash_widgets[#self._splash_widgets + 1] = UIWidget.init(widget)
	end

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

SplashView.update = function (self, dt)
	-- function 18
	if IS_WINDOWS and self._fram_skip_hack < 1 then
		self._fram_skip_hack = self._fram_skip_hack + 1

		return
	end

	local w, h = Gui.resolution()
	local ui_renderer = self.ui_renderer
	local get_service

	if IS_WINDOWS then
		get_service = self.input_manager:get_service("splash_view")

		if not get_service then
			-- Nothing
		end
	end

	get_service = FAKE_INPUT_SERVICE

	local input_service = get_service

	::label_18_0::

	UIRenderer.begin_pass(ui_renderer, self.ui_scenegraph, input_service, dt, nil, self.render_settings)
	UIRenderer.draw_widget(ui_renderer, self.dead_space_filler)

	local skip

	if IS_CONSOLE then
		skip = not not script_data.skip_splash or not not self:_get_console_input()
	else
		skip = not not script_data.skip_splash or not not input_service:get("skip_splash")
	end

	if skip and (not self._current_splash_data or not self._current_splash_data.forced) then
		if self._current_splash_data and self._current_splash_data.type == "video" then
			if ui_renderer.video_players[VIDEO_REFERENCE_NAME] then
				UIRenderer.destroy_video_player(self.ui_renderer, VIDEO_REFERENCE_NAME)
			end

			if self._current_splash_data.sound_stop then
				Managers.music:trigger_event(self._current_splash_data.sound_stop)
			end

			self._sound_started = false
		end

		self:_next_splash()
	elseif self[self._update_func] then
		self[self._update_func](self, ui_renderer.gui, dt)
	end

	UIRenderer.end_pass(ui_renderer)
end

if IS_CONSOLE then
	SplashView.allow_console_skip = function (self)
		-- function 19
		self._allow_console_skip = true
	end

	SplashView._get_console_input = function (self)
		-- function 20
		if not self._allow_console_skip then
			return
		end

		local pad = "Pad"

		for i = 1, 8 do
			local pad_name = pad .. tostring(i)
			local pad_controller = rawget(_G, pad_name)

			if pad_controller and pad_controller.any_pressed() then
				return true
			end
		end

		if IS_XB1 and GameSettingsDevelopment.allow_keyboard_mouse and (Keyboard.any_pressed() or Mouse.any_pressed()) then
			return true
		end
	end
end

SplashView.render = function (self)
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
