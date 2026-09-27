-- chunkname: @scripts/ui/views/store_welcome_popup.lua

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local tbl = {
		arg_1_1,
		math.min(arg_1_2, 400)
	}
	local tbl_2 = {
		arg_1_0,
		tbl[2] + 350
	}
	local tbl_3 = {
		arg_1_1 - 50,
		50
	}
	local tbl_4 = {
		5,
		tbl[2]
	}
	local currency_ui_settings = DLCSettings.store.currency_ui_settings
	local var_1_5 = currency_ui_settings[arg_1_3]

	var_1_5 = var_1_5 or currency_ui_settings.SM

	local tbl_5 = {
		on_enter = {
			{
				name = "fade_in",
				start_progress = 0,
				end_progress = 0.5,
				init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					-- function 2
					arg_2_3.render_settings.alpha_multiplier = 0
				end,
				update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
					-- function 3
					local easeOutCubic = math.easeOutCubic(arg_3_3)

					arg_3_4.render_settings.alpha_multiplier = easeOutCubic
					arg_3_0.window.position[2] = arg_3_1.window.position[2] + 100 * (1 - easeOutCubic)
				end,
				on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					-- function 4
					return
				end
			}
		}
	}
	local tbl_6 = {
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
		screen_overlay = {
			scale = "fit",
			size = {
				1920,
				1080
			},
			position = {
				0,
				0,
				900
			}
		},
		window = {
			vertical_alignment = "center",
			parent = "screen_overlay",
			horizontal_alignment = "center",
			size = tbl_2,
			position = {
				0,
				0,
				1
			}
		},
		window_button = {
			vertical_alignment = "bottom",
			parent = "window",
			horizontal_alignment = "center",
			size = {
				300,
				70
			},
			position = {
				0,
				-32,
				10
			}
		},
		window_title = {
			vertical_alignment = "top",
			parent = "window",
			horizontal_alignment = "center",
			size = {
				tbl_2[1] - 40,
				50
			},
			position = {
				0,
				-40,
				1
			}
		},
		currency_area = {
			vertical_alignment = "bottom",
			parent = "window",
			horizontal_alignment = "center",
			size = {
				tbl_2[1] + 20,
				64
			},
			position = {
				0,
				100,
				3
			}
		},
		currency_area_frame = {
			vertical_alignment = "center",
			parent = "currency_area",
			horizontal_alignment = "center",
			size = {
				tbl_2[1] + 20 + 12,
				76
			},
			position = {
				0,
				0,
				0
			}
		},
		currency_text = {
			vertical_alignment = "center",
			parent = "currency_area",
			horizontal_alignment = "right",
			size = {
				64,
				200
			},
			position = {
				-40,
				-2,
				1
			}
		},
		currency_title = {
			vertical_alignment = "center",
			parent = "currency_area",
			horizontal_alignment = "left",
			size = {
				64,
				200
			},
			position = {
				40,
				-2,
				1
			}
		},
		currency_icon = {
			vertical_alignment = "center",
			parent = "currency_text",
			horizontal_alignment = "left",
			size = {
				64,
				64
			},
			position = {
				-64,
				0,
				1
			}
		},
		currency_area_detail_left = {
			vertical_alignment = "center",
			parent = "currency_area",
			horizontal_alignment = "left",
			size = {
				84,
				112
			},
			position = {
				-40,
				0,
				10
			}
		},
		currency_area_detail_right = {
			vertical_alignment = "center",
			parent = "currency_area",
			horizontal_alignment = "right",
			size = {
				84,
				112
			},
			position = {
				40,
				0,
				10
			}
		},
		list_window = {
			vertical_alignment = "top",
			parent = "window",
			horizontal_alignment = "center",
			size = tbl,
			position = {
				0,
				-115,
				1
			}
		},
		list = {
			vertical_alignment = "top",
			parent = "list_window",
			horizontal_alignment = "right",
			size = tbl,
			position = {
				0,
				-tbl[2],
				0
			}
		},
		list_scrollbar = {
			vertical_alignment = "center",
			parent = "list_window",
			horizontal_alignment = "right",
			size = tbl_4,
			position = {
				-20,
				0,
				1
			}
		},
		list_root = {
			vertical_alignment = "top",
			parent = "list",
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
		}
	}
	local tbl_7 = {
		use_shadow = true,
		upper_case = false,
		localize = true,
		font_size = 52,
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
	local tbl_8 = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		use_shadow = true,
		font_size = 32,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = false,
		font_type = "hell_shark_header",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			2
		}
	}
	local tbl_9 = {
		word_wrap = false,
		upper_case = false,
		localize = false,
		use_shadow = true,
		font_size = 32,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = false,
		font_type = "hell_shark_header",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			2
		}
	}

	local function fn(arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		local num = 10
		local tbl = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "list_hotspot",
					pass_type = "hotspot",
					content_id = "list_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "mask",
					texture_id = "mask_texture"
				},
				{
					pass_type = "texture",
					style_id = "mask_top",
					texture_id = "mask_edge"
				},
				{
					pass_type = "rotated_texture",
					style_id = "mask_bottom",
					texture_id = "mask_edge"
				}
			}
		}
		local tbl_2 = {
			mask_edge = "mask_rect_edge_fade",
			mask_texture = "mask_rect",
			list_hotspot = {},
			button_hotspot = {},
			scrollbar = {
				scroll_amount = 0.1,
				percentage = 0.1,
				scroll_value = 1
			}
		}
		local tbl_3 = {
			hotspot = {
				size = {
					arg_5_2[1],
					arg_5_2[2]
				},
				offset = {
					0,
					0,
					0
				}
			},
			list_hotspot = {
				size = {
					arg_5_2[1],
					arg_5_2[2] + num * 2
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-num,
					0
				}
			},
			mask = {
				size = {
					arg_5_2[1],
					arg_5_2[2]
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
					0
				}
			},
			mask_top = {
				size = {
					arg_5_2[1],
					num
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_5_2[2],
					0
				}
			},
			mask_bottom = {
				size = {
					arg_5_2[1],
					num
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-num,
					0
				},
				angle = math.pi,
				pivot = {
					arg_5_2[1] / 2,
					num / 2
				}
			}
		}

		return {
			element = tbl,
			content = tbl_2,
			style = tbl_3,
			offset = {
				0,
				0,
				0
			},
			scenegraph_id = arg_5_0
		}
	end

	local flag = true
	local str = "shadow_frame_02"
	local var_1_14 = UIFrameSettings[str].texture_sizes.horizontal[2]
	local tbl_10 = {
		220,
		10,
		10,
		10
	}
	local tbl_11 = {
		220,
		0,
		0,
		0
	}
	local icon_big = var_1_5.icon_big
	local var_1_18
	local flag_2

	flag_2 = not arg_1_4 and "welcome_currency_popup_amount_summary_title" and var_1_5.name

	local tbl_12 = {
		screen_overlay = UIWidgets.create_simple_rect("screen_overlay", {
			50,
			10,
			10,
			10
		}),
		window_background = UIWidgets.create_simple_rect("window", tbl_10),
		window_drop_shadow = UIWidgets.create_frame("window", tbl_6.window.size, str, 0, tbl_11, {
			-var_1_14,
			-var_1_14
		}),
		window_frame = UIWidgets.create_frame("window", tbl_6.window.size, "menu_frame_12_gold", 1, {
			255,
			255,
			255,
			255
		}),
		window_button = UIWidgets.create_default_button("window_button", tbl_6.window_button.size, "button_frame_02_gold", nil, Localize("welcome_currency_popup_button_claim"), 30, nil, "button_detail_01_gold", nil, flag),
		window_title = UIWidgets.create_simple_text("interact_open_store", "window_title", tbl_6.window_title.size, nil, tbl_7),
		currency_icon = UIWidgets.create_simple_texture(icon_big, "currency_icon"),
		currency_title = UIWidgets.create_simple_text(Localize(flag_2), "currency_title", nil, nil, tbl_9),
		currency_text = UIWidgets.create_simple_text("-", "currency_text", nil, nil, tbl_8),
		currency_area = UIWidgets.create_tiled_texture("currency_area", "menu_frame_bg_07", {
			512,
			256
		}, nil, nil, {
			255,
			255,
			255,
			255
		}),
		currency_area_frame = UIWidgets.create_frame("currency_area_frame", tbl_6.currency_area_frame.size, "button_frame_01_gold", 1),
		currency_area_detail_left = UIWidgets.create_simple_uv_texture("button_detail_08_gold", {
			{
				0,
				0
			},
			{
				1,
				1
			}
		}, "currency_area_detail_left"),
		currency_area_detail_right = UIWidgets.create_simple_uv_texture("button_detail_08_gold", {
			{
				1,
				0
			},
			{
				0,
				1
			}
		}, "currency_area_detail_right"),
		list = fn("list_window", "list", tbl, tbl_3),
		list_scrollbar = UIWidgets.create_scrollbar("list_scrollbar", tbl_4, "window", {
			255,
			120,
			120,
			120
		}, {
			255,
			30,
			30,
			30
		})
	}

	return tbl_6, tbl_12, tbl_5
end

local num = 10
local num_2 = 800

StoreWelcomePopup = class(StoreWelcomePopup)

StoreWelcomePopup.init = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	self._ingame_ui = arg_6_1
	self._top_world = arg_6_1.top_world
	self._render_settings = {
		alpha_multiplier = 1
	}
	self._animations = {}
	self._ui_animations = {}

	self:_setup_renderers()

	local world = Managers.world:world("level_world")

	self._wwise_world = Managers.world:wwise_world(world)
	self._level_world = world

	local num = 700
	local num_2 = num - 70

	self._entry_size = {
		num_2 - 50,
		50
	}

	self:_setup_list_widgets(arg_6_2)

	self._scenegraph_definition, self._widget_definitions, self._animation_definitions = fn(num, num_2, self._total_list_height, arg_6_3, arg_6_5)

	self:_create_ui_elements()

	self._blur_progress = 1

	self:_initialize_scrollbar()

	self._list_initialized = true

	self:_set_total_amount(arg_6_4)
	self:_start_transition_animation("on_enter", "on_enter")
end

StoreWelcomePopup._setup_renderers = function (self)
	-- function 7
	local str = "store_welcome_ui_world"
	local num = 999

	self._welcome_ui_world_viewport_name = "store_welcome_ui_world_viewport"
	self._welcome_ui_world = Managers.world:create_world(str, GameSettingsDevelopment.default_environment, nil, num, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.create_viewport(self._welcome_ui_world, self._welcome_ui_world_viewport_name, "overlay", 1)

	self._welcome_ui_renderer = self._ingame_ui:create_ui_renderer(self._welcome_ui_world, false, true)

	local num_2 = 998
	local str_2 = "store_welcome_ui_blur_world"
	local str_3 = "environment/ui_store_default"

	self._blur_welcome_ui_world_viewport_name = "store_welcome_ui_blur_world_viewport"
	self._blur_welcome_ui_world = Managers.world:create_world(str_2, str_3, nil, num_2, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.create_viewport(self._blur_welcome_ui_world, self._blur_welcome_ui_world_viewport_name, "overlay", 1)

	self._blur_welcome_ui_renderer = self._ingame_ui:create_ui_renderer(self._blur_welcome_ui_world, false, true)
end

StoreWelcomePopup._destroy_renderers = function (self)
	-- function 8
	UIRenderer.destroy(self._welcome_ui_renderer, self._welcome_ui_world)
	ScriptWorld.destroy_viewport(self._welcome_ui_world, self._welcome_ui_world_viewport_name)
	Managers.world:destroy_world(self._welcome_ui_world)

	self._welcome_ui_world = nil
	self._welcome_ui_renderer = nil
	self._welcome_ui_world_viewport_name = nil

	UIRenderer.destroy(self._blur_welcome_ui_renderer, self._blur_welcome_ui_world)
	ScriptWorld.destroy_viewport(self._blur_welcome_ui_world, self._blur_welcome_ui_world_viewport_name)
	Managers.world:destroy_world(self._blur_welcome_ui_world)

	self._blur_welcome_ui_world = nil
	self._blur_welcome_ui_renderer = nil
	self._blur_welcome_ui_world_viewport_name = nil
end

StoreWelcomePopup._start_transition_animation = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local flag = arg_9_3 or self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_9_2, flag, self._scenegraph_definition, tbl)

	self._animations[arg_9_1] = start_animation

	return tbl
end

StoreWelcomePopup.completed = function (self)
	-- function 10
	return self._done
end

StoreWelcomePopup._create_gamepad_input_description = function (self, arg_11_1)
	-- function 11
	local tbl = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "welcome_currency_popup_button_claim"
		}
	}

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self._welcome_ui_renderer, arg_11_1, 6, nil, tbl, true)

	self._menu_input_description:set_input_description(nil)
end

StoreWelcomePopup._set_fullscreen_effect_enable_state = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local get_data = World.get_data(arg_12_3, "shading_environment")

	arg_12_2 = arg_12_2 or not arg_12_1 or 1 or 0

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_12_2 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_12_1 and 1 and 0

		set_scalar(var_12_2, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_12_6 = get_data
		local str_2 = "fullscreen_blur_amount"
		local num

		if not arg_12_1 then
			num = arg_12_2 * 0.8

			if not num then
				-- Nothing
			end
		end

		num = 0

		::label_12_0::

		set_scalar_2(var_12_6, str_2, num)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_12_1
end

StoreWelcomePopup.is_complete = function (self)
	-- function 13
	return self._state == "exit"
end

StoreWelcomePopup.destroy = function (self)
	-- function 14
	if not self._blur_welcome_ui_world and not self._fullscreen_effect_enabled then
		self:_set_fullscreen_effect_enable_state(false, 0, self._blur_welcome_ui_world)
	end

	self:_destroy_renderers()
end

StoreWelcomePopup._create_ui_elements = function (self, arg_15_1)
	-- function 15
	self._ui_scenegraph = UISceneGraph.init_scenegraph(self._scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}

	for k, v in pairs(self._widget_definitions) do
		local var_15_3 = UIWidget.init(v)

		tbl_3[#tbl_3 + 1] = var_15_3
		tbl[k] = var_15_3
	end

	self._widgets = tbl_3
	self._widgets_by_name = tbl
	self._widgets_by_state = tbl_2

	UIRenderer.clear_scenegraph_queue(self._welcome_ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, self._animation_definitions)
end

StoreWelcomePopup._draw = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _welcome_ui_renderer = self._welcome_ui_renderer
	local _blur_welcome_ui_renderer = self._blur_welcome_ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_welcome_ui_renderer, _ui_scenegraph, arg_16_1, arg_16_2, nil, _render_settings)

	local snap_pixel_positions = _render_settings.snap_pixel_positions
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	for i, v in ipairs(self._widgets) do
		if v.snap_pixel_positions ~= nil then
			_render_settings.snap_pixel_positions = v.snap_pixel_positions
		end

		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(_welcome_ui_renderer, v)

		_render_settings.snap_pixel_positions = snap_pixel_positions
	end

	if not self._list_initialized then
		local _list_widgets = self._list_widgets

		if not _list_widgets then
			self:_update_visible_list_entries()

			for i_2, v_2 in ipairs(_list_widgets) do
				local alpha_multiplier_3 = v_2.alpha_multiplier

				alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
				_render_settings.alpha_multiplier = alpha_multiplier_3

				UIRenderer.draw_widget(_welcome_ui_renderer, v_2)
			end
		end
	end

	_render_settings.alpha_multiplier = alpha_multiplier

	UIRenderer.end_pass(_welcome_ui_renderer)

	if not is_device_active then
		self._menu_input_description:draw(_welcome_ui_renderer, arg_16_2)
	end
end

StoreWelcomePopup._handle_input = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local flag = not Managers.input:is_device_active("gamepad") and arg_17_1:get("confirm", true)
	local window_button = self._widgets_by_name.window_button

	UIWidgetUtils.animate_default_button(window_button, arg_17_2)

	if not self:_is_button_hover_enter(window_button) then
		self:_play_sound("Play_hud_hover")
	end

	if self:_is_button_pressed(window_button) or not flag then
		self:_play_sound("Play_hud_store_button_buy")

		self._done = true
	end
end

StoreWelcomePopup.update = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	if not self._menu_input_description then
		self:_create_gamepad_input_description(arg_18_1)
	end

	if not self._list_initialized then
		local _scrollbar_logic = self._scrollbar_logic

		if not _scrollbar_logic then
			_scrollbar_logic:update(arg_18_2, arg_18_3)
			self:_update_scroll_position()
		end
	end

	self:_handle_input(arg_18_1, arg_18_2, arg_18_3)

	local _blur_progress = self._blur_progress

	_blur_progress = _blur_progress or self._render_settings.alpha_multiplier

	if not _blur_progress then
		self:_set_fullscreen_effect_enable_state(true, _blur_progress, self._blur_welcome_ui_world)
	elseif not self._fullscreen_effect_enabled then
		self:_set_fullscreen_effect_enable_state(false, 0, self._blur_welcome_ui_world)
	end

	self:_update_animations(arg_18_2)
	self:_draw(arg_18_1, arg_18_2)
end

StoreWelcomePopup._update_animations = function (self, arg_19_1)
	-- function 19
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_19_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_19_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

StoreWelcomePopup._is_button_hover_enter = function (arg_20_0, arg_20_1)
	-- function 20
	local content = arg_20_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	return button_hotspot.on_hover_enter
end

StoreWelcomePopup._is_button_pressed = function (arg_21_0, arg_21_1)
	-- function 21
	local content = arg_21_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StoreWelcomePopup._play_sound = function (self, arg_22_1)
	-- function 22
	WwiseWorld.trigger_event(self._wwise_world, arg_22_1)
end

StoreWelcomePopup._setup_list_widgets = function (self, arg_23_1)
	-- function 23
	local tbl = {}
	local str = "list_root"
	local flag = true
	local _entry_size = self._entry_size

	for i, v in ipairs(arg_23_1) do
		local type = v.type
		local settings = v.settings
		local var_23_6

		if type == "body" then
			local num = 5
			local create_store_body_text_definition = UIWidgets.create_store_body_text_definition(str, _entry_size, flag)

			var_23_6 = UIWidget.init(create_store_body_text_definition)

			self:_populate_text_widget(var_23_6, settings, num)
		elseif type == "summary_title" then
			local num_2 = 5
			local create_store_currency_summary_title_definition = UIWidgets.create_store_currency_summary_title_definition(str, _entry_size, flag)

			var_23_6 = UIWidget.init(create_store_currency_summary_title_definition)

			self:_populate_text_widget(var_23_6, settings, num_2)
			self:_populate_currency_title_widget(var_23_6, settings)
		elseif type == "summary_entry" then
			local create_store_currency_summary_entry_definition = UIWidgets.create_store_currency_summary_entry_definition(str, _entry_size, flag)
			local num_3 = -5

			var_23_6 = UIWidget.init(create_store_currency_summary_entry_definition)

			self:_populate_text_widget(var_23_6, settings, num_3)
			self:_populate_currency_entry_widget(var_23_6, settings)
		end

		tbl[#tbl + 1] = var_23_6
	end

	self._list_widgets = tbl

	self:_align_dlc_widgets()
end

StoreWelcomePopup._populate_text_widget = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local content = arg_24_1.content
	local style = arg_24_1.style
	local text = arg_24_2.text

	if not arg_24_2.localize then
		text = Localize(text)
	end

	local text_2 = style.text
	local size = text_2.size
	local offset = text_2.offset
	local _welcome_ui_renderer = self._welcome_ui_renderer
	local get_text_height = UIUtils.get_text_height(_welcome_ui_renderer, size, text_2, text)

	if not arg_24_3 then
		size[2] = get_text_height + arg_24_3
	else
		size[2] = get_text_height
	end

	offset[2] = -size[2]
	content.size[2] = size[2]

	local text_shadow = style.text_shadow

	text_shadow.size[2] = size[2]
	text_shadow.offset[2] = -(size[2] + 2)
	content.text = text
end

StoreWelcomePopup._populate_currency_title_widget = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local content = arg_25_1.content
	local style = arg_25_1.style
	local size = style.text.size

	style.divider.offset[2] = -size[2]
	style.divider_shadow.offset[2] = -(size[2] + 2)

	local text2 = style.text2
	local size_2 = text2.size
	local offset = text2.offset

	size_2[2] = size[2]
	offset[2] = -size[2]

	local text2_shadow = style.text2_shadow

	text2_shadow.size[2] = size[2]
	text2_shadow.offset[2] = -(size[2] + 2)

	local text2_2 = arg_25_2.text2

	if not arg_25_2.localize then
		text2_2 = Localize(text2_2)
	end

	content.text2 = text2_2
end

StoreWelcomePopup._populate_currency_entry_widget = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local content = arg_26_1.content
	local style = arg_26_1.style
	local size = style.text.size
	local text2 = style.text2
	local size_2 = text2.size
	local offset = text2.offset

	size_2[2] = size[2]
	offset[2] = -size[2]

	local text2_shadow = style.text2_shadow

	text2_shadow.size[2] = size[2]
	text2_shadow.offset[2] = -(size[2] + 2)

	local value = arg_26_2.value

	content.text2 = UIUtils.comma_value(value)
end

StoreWelcomePopup._align_dlc_widgets = function (self)
	-- function 27
	local num_3 = 0
	local num_4 = 0
	local num_5 = 0
	local num_6 = 1
	local num_7 = 1
	local num_8 = 0
	local num_9 = 0
	local _list_widgets = self._list_widgets
	local count = #_list_widgets

	for i, v in ipairs(_list_widgets) do
		local offset = v.offset
		local content = v.content
		local size = content.size
		local var_27_12 = size[1]
		local var_27_13 = size[2]

		if not (num_4 + var_27_12 > num_2) then
			num_7 = 1
			num_6 = num_6 + 1
			num_4 = 0
			num_5 = num_5 - (num_9 + num)
			num_9 = 0
		end

		offset[1] = num_4
		offset[2] = num_5
		v.default_offset = table.clone(offset)
		content.row = num_6
		content.column = num_7
		num_4 = num_4 + (var_27_12 + num)

		if i == count then
			num_3 = math.abs(num_5 - var_27_13)
		end

		num_7 = num_7 + 1

		local var_27_14 = var_27_13

		if num_9 < var_27_13 then
			num_9 = var_27_13
		end
	end

	self._total_list_height = num_3
end

StoreWelcomePopup._initialize_scrollbar = function (self)
	-- function 28
	local list_scrollbar = self._widgets_by_name.list_scrollbar

	self._scrollbar_logic = ScrollBarLogic:new(list_scrollbar)

	local size = self._scenegraph_definition.list_window.size
	local size_2 = self._scenegraph_definition.list_scrollbar.size
	local var_28_3 = size[2]
	local _total_list_height = self._total_list_height
	local var_28_5 = size_2[2]
	local num_2 = 220 + num * 1.5
	local num_3 = 1
	local _scrollbar_logic = self._scrollbar_logic

	_scrollbar_logic:set_scrollbar_values(var_28_3, _total_list_height, var_28_5, num_2, num_3)
	_scrollbar_logic:set_scroll_percentage(0)

	list_scrollbar.content.visible = var_28_3 < _total_list_height
end

StoreWelcomePopup._update_scroll_position = function (self)
	-- function 29
	local get_scrolled_length = self._scrollbar_logic:get_scrolled_length()

	if get_scrolled_length ~= self._scrolled_length then
		self._ui_scenegraph.list.local_position[2] = get_scrolled_length
		self._scrolled_length = get_scrolled_length
	end
end

StoreWelcomePopup._update_visible_list_entries = function (self)
	-- function 30
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		return
	end

	local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
	local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
	local get_scroll_length = _scrollbar_logic:get_scroll_length()
	local size = self._scenegraph_definition.list_window.size
	local num_2 = num * 2
	local num_3 = size[2] + num_2
	local _list_widgets = self._list_widgets
	local count = #_list_widgets

	for i, v in ipairs(_list_widgets) do
		local offset = v.offset
		local content = v.content
		local size_2 = content.size
		local num_4 = math.abs(offset[2]) + size_2[2]
		local flag = false

		if num_4 < get_scrolled_length - num_2 then
			flag = true
		elseif num_3 < math.abs(offset[2]) - get_scrolled_length then
			flag = true
		end

		content.visible = not flag
	end
end

StoreWelcomePopup._set_total_amount = function (self, arg_31_1)
	-- function 31
	local _widgets_by_name = self._widgets_by_name
	local currency_icon = _widgets_by_name.currency_icon
	local currency_text = _widgets_by_name.currency_text
	local comma_value = UIUtils.comma_value(tostring(arg_31_1))

	currency_text.content.text = comma_value

	local _welcome_ui_renderer = self._welcome_ui_renderer
	local get_text_width = UIUtils.get_text_width(_welcome_ui_renderer, currency_text.style.text, comma_value)
	local var_31_6 = self._scenegraph_definition.currency_icon.size[1]
	local num = get_text_width + 5

	self._ui_scenegraph[currency_text.scenegraph_id].size[1] = num
end
