-- chunkname: @scripts/ui/views/store_welcome_popup.lua

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = {
		arg_1_1,
		math.min(arg_1_2, 400)
	}
	local var_1_1 = {
		arg_1_0,
		var_1_0[2] + 350
	}
	local var_1_2 = {
		arg_1_1 - 50,
		50
	}
	local var_1_3 = {
		5,
		var_1_0[2]
	}
	local var_1_4 = DLCSettings.store.currency_ui_settings
	local var_1_5 = var_1_4[arg_1_3] or var_1_4.SM
	local var_1_6 = {
		on_enter = {
			{
				name = "fade_in",
				start_progress = 0,
				end_progress = 0.5,
				init = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_3.render_settings.alpha_multiplier = 0
				end,
				update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
					local var_3_0 = math.easeOutCubic(arg_3_3)

					arg_3_4.render_settings.alpha_multiplier = var_3_0
					arg_3_0.window.position[2] = arg_3_1.window.position[2] + 100 * (1 - var_3_0)
				end,
				on_complete = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
					return
				end
			}
		}
	}
	local var_1_7 = {
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
			size = var_1_1,
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
				var_1_1[1] - 40,
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
				var_1_1[1] + 20,
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
				var_1_1[1] + 20 + 12,
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
			size = var_1_0,
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
			size = var_1_0,
			position = {
				0,
				-var_1_0[2],
				0
			}
		},
		list_scrollbar = {
			vertical_alignment = "center",
			parent = "list_window",
			horizontal_alignment = "right",
			size = var_1_3,
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
	local var_1_8 = {
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
	local var_1_9 = {
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
	local var_1_10 = {
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

	local function var_1_11(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = 10
		local var_5_1 = {
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
		local var_5_2 = {
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
		local var_5_3 = {
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
					arg_5_2[2] + var_5_0 * 2
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-var_5_0,
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
					var_5_0
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
					var_5_0
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-var_5_0,
					0
				},
				angle = math.pi,
				pivot = {
					arg_5_2[1] / 2,
					var_5_0 / 2
				}
			}
		}

		return {
			element = var_5_1,
			content = var_5_2,
			style = var_5_3,
			offset = {
				0,
				0,
				0
			},
			scenegraph_id = arg_5_0
		}
	end

	local var_1_12 = true
	local var_1_13 = "shadow_frame_02"
	local var_1_14 = UIFrameSettings[var_1_13].texture_sizes.horizontal[2]
	local var_1_15 = {
		220,
		10,
		10,
		10
	}
	local var_1_16 = {
		220,
		0,
		0,
		0
	}
	local var_1_17 = var_1_5.icon_big
	local var_1_18
	local var_1_19 = arg_1_4 and "welcome_currency_popup_amount_summary_title" or var_1_5.name
	local var_1_20 = {
		screen_overlay = UIWidgets.create_simple_rect("screen_overlay", {
			50,
			10,
			10,
			10
		}),
		window_background = UIWidgets.create_simple_rect("window", var_1_15),
		window_drop_shadow = UIWidgets.create_frame("window", var_1_7.window.size, var_1_13, 0, var_1_16, {
			-var_1_14,
			-var_1_14
		}),
		window_frame = UIWidgets.create_frame("window", var_1_7.window.size, "menu_frame_12_gold", 1, {
			255,
			255,
			255,
			255
		}),
		window_button = UIWidgets.create_default_button("window_button", var_1_7.window_button.size, "button_frame_02_gold", nil, Localize("welcome_currency_popup_button_claim"), 30, nil, "button_detail_01_gold", nil, var_1_12),
		window_title = UIWidgets.create_simple_text("interact_open_store", "window_title", var_1_7.window_title.size, nil, var_1_8),
		currency_icon = UIWidgets.create_simple_texture(var_1_17, "currency_icon"),
		currency_title = UIWidgets.create_simple_text(Localize(var_1_19), "currency_title", nil, nil, var_1_10),
		currency_text = UIWidgets.create_simple_text("-", "currency_text", nil, nil, var_1_9),
		currency_area = UIWidgets.create_tiled_texture("currency_area", "menu_frame_bg_07", {
			512,
			256
		}, nil, nil, {
			255,
			255,
			255,
			255
		}),
		currency_area_frame = UIWidgets.create_frame("currency_area_frame", var_1_7.currency_area_frame.size, "button_frame_01_gold", 1),
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
		list = var_1_11("list_window", "list", var_1_0, var_1_2),
		list_scrollbar = UIWidgets.create_scrollbar("list_scrollbar", var_1_3, "window", {
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

	return var_1_7, var_1_20, var_1_6
end

local var_0_1 = 10
local var_0_2 = 800

StoreWelcomePopup = class(StoreWelcomePopup)

function StoreWelcomePopup.init(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_0._ingame_ui = arg_6_1
	arg_6_0._top_world = arg_6_1.top_world
	arg_6_0._render_settings = {
		alpha_multiplier = 1
	}
	arg_6_0._animations = {}
	arg_6_0._ui_animations = {}

	arg_6_0:_setup_renderers()

	local var_6_0 = Managers.world:world("level_world")

	arg_6_0._wwise_world = Managers.world:wwise_world(var_6_0)
	arg_6_0._level_world = var_6_0

	local var_6_1 = 700
	local var_6_2 = var_6_1 - 70

	arg_6_0._entry_size = {
		var_6_2 - 50,
		50
	}

	arg_6_0:_setup_list_widgets(arg_6_2)

	arg_6_0._scenegraph_definition, arg_6_0._widget_definitions, arg_6_0._animation_definitions = var_0_0(var_6_1, var_6_2, arg_6_0._total_list_height, arg_6_3, arg_6_5)

	arg_6_0:_create_ui_elements()

	arg_6_0._blur_progress = 1

	arg_6_0:_initialize_scrollbar()

	arg_6_0._list_initialized = true

	arg_6_0:_set_total_amount(arg_6_4)
	arg_6_0:_start_transition_animation("on_enter", "on_enter")
end

function StoreWelcomePopup._setup_renderers(arg_7_0)
	local var_7_0 = "store_welcome_ui_world"
	local var_7_1 = 999

	arg_7_0._welcome_ui_world_viewport_name = "store_welcome_ui_world_viewport"
	arg_7_0._welcome_ui_world = Managers.world:create_world(var_7_0, GameSettingsDevelopment.default_environment, nil, var_7_1, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.create_viewport(arg_7_0._welcome_ui_world, arg_7_0._welcome_ui_world_viewport_name, "overlay", 1)

	arg_7_0._welcome_ui_renderer = arg_7_0._ingame_ui:create_ui_renderer(arg_7_0._welcome_ui_world, false, true)

	local var_7_2 = 998
	local var_7_3 = "store_welcome_ui_blur_world"
	local var_7_4 = "environment/ui_store_default"

	arg_7_0._blur_welcome_ui_world_viewport_name = "store_welcome_ui_blur_world_viewport"
	arg_7_0._blur_welcome_ui_world = Managers.world:create_world(var_7_3, var_7_4, nil, var_7_2, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.create_viewport(arg_7_0._blur_welcome_ui_world, arg_7_0._blur_welcome_ui_world_viewport_name, "overlay", 1)

	arg_7_0._blur_welcome_ui_renderer = arg_7_0._ingame_ui:create_ui_renderer(arg_7_0._blur_welcome_ui_world, false, true)
end

function StoreWelcomePopup._destroy_renderers(arg_8_0)
	UIRenderer.destroy(arg_8_0._welcome_ui_renderer, arg_8_0._welcome_ui_world)
	ScriptWorld.destroy_viewport(arg_8_0._welcome_ui_world, arg_8_0._welcome_ui_world_viewport_name)
	Managers.world:destroy_world(arg_8_0._welcome_ui_world)

	arg_8_0._welcome_ui_world = nil
	arg_8_0._welcome_ui_renderer = nil
	arg_8_0._welcome_ui_world_viewport_name = nil

	UIRenderer.destroy(arg_8_0._blur_welcome_ui_renderer, arg_8_0._blur_welcome_ui_world)
	ScriptWorld.destroy_viewport(arg_8_0._blur_welcome_ui_world, arg_8_0._blur_welcome_ui_world_viewport_name)
	Managers.world:destroy_world(arg_8_0._blur_welcome_ui_world)

	arg_8_0._blur_welcome_ui_world = nil
	arg_8_0._blur_welcome_ui_renderer = nil
	arg_8_0._blur_welcome_ui_world_viewport_name = nil
end

function StoreWelcomePopup._start_transition_animation(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = {
		wwise_world = arg_9_0._wwise_world,
		render_settings = arg_9_0._render_settings
	}
	local var_9_1 = arg_9_3 or arg_9_0._widgets_by_name
	local var_9_2 = arg_9_0._ui_animator:start_animation(arg_9_2, var_9_1, arg_9_0._scenegraph_definition, var_9_0)

	arg_9_0._animations[arg_9_1] = var_9_2

	return var_9_0
end

function StoreWelcomePopup.completed(arg_10_0)
	return arg_10_0._done
end

function StoreWelcomePopup._create_gamepad_input_description(arg_11_0, arg_11_1)
	local var_11_0 = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "welcome_currency_popup_button_claim"
		}
	}

	arg_11_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_11_0._welcome_ui_renderer, arg_11_1, 6, nil, var_11_0, true)

	arg_11_0._menu_input_description:set_input_description(nil)
end

function StoreWelcomePopup._set_fullscreen_effect_enable_state(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = World.get_data(arg_12_3, "shading_environment")

	arg_12_2 = arg_12_2 or arg_12_1 and 1 or 0

	if var_12_0 then
		ShadingEnvironment.set_scalar(var_12_0, "fullscreen_blur_enabled", arg_12_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_12_0, "fullscreen_blur_amount", arg_12_1 and arg_12_2 * 0.8 or 0)
		ShadingEnvironment.apply(var_12_0)
	end

	arg_12_0._fullscreen_effect_enabled = arg_12_1
end

function StoreWelcomePopup.is_complete(arg_13_0)
	return arg_13_0._state == "exit"
end

function StoreWelcomePopup.destroy(arg_14_0)
	if arg_14_0._blur_welcome_ui_world and arg_14_0._fullscreen_effect_enabled then
		arg_14_0:_set_fullscreen_effect_enable_state(false, 0, arg_14_0._blur_welcome_ui_world)
	end

	arg_14_0:_destroy_renderers()
end

function StoreWelcomePopup._create_ui_elements(arg_15_0, arg_15_1)
	arg_15_0._ui_scenegraph = UISceneGraph.init_scenegraph(arg_15_0._scenegraph_definition)

	local var_15_0 = {}
	local var_15_1 = {}
	local var_15_2 = {}

	for iter_15_0, iter_15_1 in pairs(arg_15_0._widget_definitions) do
		local var_15_3 = UIWidget.init(iter_15_1)

		var_15_2[#var_15_2 + 1] = var_15_3
		var_15_0[iter_15_0] = var_15_3
	end

	arg_15_0._widgets = var_15_2
	arg_15_0._widgets_by_name = var_15_0
	arg_15_0._widgets_by_state = var_15_1

	UIRenderer.clear_scenegraph_queue(arg_15_0._welcome_ui_renderer)

	arg_15_0._ui_animator = UIAnimator:new(arg_15_0._ui_scenegraph, arg_15_0._animation_definitions)
end

function StoreWelcomePopup._draw(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._welcome_ui_renderer
	local var_16_1 = arg_16_0._blur_welcome_ui_renderer
	local var_16_2 = arg_16_0._ui_scenegraph
	local var_16_3 = arg_16_0._render_settings
	local var_16_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_16_0, var_16_2, arg_16_1, arg_16_2, nil, var_16_3)

	local var_16_5 = var_16_3.snap_pixel_positions
	local var_16_6 = var_16_3.alpha_multiplier or 1

	for iter_16_0, iter_16_1 in ipairs(arg_16_0._widgets) do
		if iter_16_1.snap_pixel_positions ~= nil then
			var_16_3.snap_pixel_positions = iter_16_1.snap_pixel_positions
		end

		var_16_3.alpha_multiplier = iter_16_1.alpha_multiplier or var_16_6

		UIRenderer.draw_widget(var_16_0, iter_16_1)

		var_16_3.snap_pixel_positions = var_16_5
	end

	if arg_16_0._list_initialized then
		local var_16_7 = arg_16_0._list_widgets

		if var_16_7 then
			arg_16_0:_update_visible_list_entries()

			for iter_16_2, iter_16_3 in ipairs(var_16_7) do
				var_16_3.alpha_multiplier = iter_16_3.alpha_multiplier or var_16_6

				UIRenderer.draw_widget(var_16_0, iter_16_3)
			end
		end
	end

	var_16_3.alpha_multiplier = var_16_6

	UIRenderer.end_pass(var_16_0)

	if var_16_4 then
		arg_16_0._menu_input_description:draw(var_16_0, arg_16_2)
	end
end

function StoreWelcomePopup._handle_input(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = Managers.input:is_device_active("gamepad") and arg_17_1:get("confirm", true)
	local var_17_1 = arg_17_0._widgets_by_name.window_button

	UIWidgetUtils.animate_default_button(var_17_1, arg_17_2)

	if arg_17_0:_is_button_hover_enter(var_17_1) then
		arg_17_0:_play_sound("Play_hud_hover")
	end

	if arg_17_0:_is_button_pressed(var_17_1) or var_17_0 then
		arg_17_0:_play_sound("Play_hud_store_button_buy")

		arg_17_0._done = true
	end
end

function StoreWelcomePopup.update(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if not arg_18_0._menu_input_description then
		arg_18_0:_create_gamepad_input_description(arg_18_1)
	end

	if arg_18_0._list_initialized then
		local var_18_0 = arg_18_0._scrollbar_logic

		if var_18_0 then
			var_18_0:update(arg_18_2, arg_18_3)
			arg_18_0:_update_scroll_position()
		end
	end

	arg_18_0:_handle_input(arg_18_1, arg_18_2, arg_18_3)

	local var_18_1 = arg_18_0._blur_progress or arg_18_0._render_settings.alpha_multiplier

	if var_18_1 then
		arg_18_0:_set_fullscreen_effect_enable_state(true, var_18_1, arg_18_0._blur_welcome_ui_world)
	elseif arg_18_0._fullscreen_effect_enabled then
		arg_18_0:_set_fullscreen_effect_enable_state(false, 0, arg_18_0._blur_welcome_ui_world)
	end

	arg_18_0:_update_animations(arg_18_2)
	arg_18_0:_draw(arg_18_1, arg_18_2)
end

function StoreWelcomePopup._update_animations(arg_19_0, arg_19_1)
	for iter_19_0, iter_19_1 in pairs(arg_19_0._ui_animations) do
		UIAnimation.update(iter_19_1, arg_19_1)

		if UIAnimation.completed(iter_19_1) then
			arg_19_0._ui_animations[iter_19_0] = nil
		end
	end

	local var_19_0 = arg_19_0._animations
	local var_19_1 = arg_19_0._ui_animator

	var_19_1:update(arg_19_1)

	for iter_19_2, iter_19_3 in pairs(var_19_0) do
		if var_19_1:is_animation_completed(iter_19_3) then
			var_19_1:stop_animation(iter_19_3)

			var_19_0[iter_19_2] = nil
		end
	end
end

function StoreWelcomePopup._is_button_hover_enter(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.content

	return (var_20_0.button_hotspot or var_20_0.hotspot).on_hover_enter
end

function StoreWelcomePopup._is_button_pressed(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1.content
	local var_21_1 = var_21_0.button_hotspot or var_21_0.hotspot

	if var_21_1.on_release then
		var_21_1.on_release = false

		return true
	end
end

function StoreWelcomePopup._play_sound(arg_22_0, arg_22_1)
	WwiseWorld.trigger_event(arg_22_0._wwise_world, arg_22_1)
end

function StoreWelcomePopup._setup_list_widgets(arg_23_0, arg_23_1)
	local var_23_0 = {}
	local var_23_1 = "list_root"
	local var_23_2 = true
	local var_23_3 = arg_23_0._entry_size

	for iter_23_0, iter_23_1 in ipairs(arg_23_1) do
		local var_23_4 = iter_23_1.type
		local var_23_5 = iter_23_1.settings
		local var_23_6

		if var_23_4 == "body" then
			local var_23_7 = 5
			local var_23_8 = UIWidgets.create_store_body_text_definition(var_23_1, var_23_3, var_23_2)

			var_23_6 = UIWidget.init(var_23_8)

			arg_23_0:_populate_text_widget(var_23_6, var_23_5, var_23_7)
		elseif var_23_4 == "summary_title" then
			local var_23_9 = 5
			local var_23_10 = UIWidgets.create_store_currency_summary_title_definition(var_23_1, var_23_3, var_23_2)

			var_23_6 = UIWidget.init(var_23_10)

			arg_23_0:_populate_text_widget(var_23_6, var_23_5, var_23_9)
			arg_23_0:_populate_currency_title_widget(var_23_6, var_23_5)
		elseif var_23_4 == "summary_entry" then
			local var_23_11 = UIWidgets.create_store_currency_summary_entry_definition(var_23_1, var_23_3, var_23_2)
			local var_23_12 = -5

			var_23_6 = UIWidget.init(var_23_11)

			arg_23_0:_populate_text_widget(var_23_6, var_23_5, var_23_12)
			arg_23_0:_populate_currency_entry_widget(var_23_6, var_23_5)
		end

		var_23_0[#var_23_0 + 1] = var_23_6
	end

	arg_23_0._list_widgets = var_23_0

	arg_23_0:_align_dlc_widgets()
end

function StoreWelcomePopup._populate_text_widget(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = arg_24_1.content
	local var_24_1 = arg_24_1.style
	local var_24_2 = arg_24_2.text

	if arg_24_2.localize then
		var_24_2 = Localize(var_24_2)
	end

	local var_24_3 = var_24_1.text
	local var_24_4 = var_24_3.size
	local var_24_5 = var_24_3.offset
	local var_24_6 = arg_24_0._welcome_ui_renderer
	local var_24_7 = UIUtils.get_text_height(var_24_6, var_24_4, var_24_3, var_24_2)

	if arg_24_3 then
		var_24_4[2] = var_24_7 + arg_24_3
	else
		var_24_4[2] = var_24_7
	end

	var_24_5[2] = -var_24_4[2]
	var_24_0.size[2] = var_24_4[2]

	local var_24_8 = var_24_1.text_shadow

	var_24_8.size[2] = var_24_4[2]
	var_24_8.offset[2] = -(var_24_4[2] + 2)
	var_24_0.text = var_24_2
end

function StoreWelcomePopup._populate_currency_title_widget(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_1.content
	local var_25_1 = arg_25_1.style
	local var_25_2 = var_25_1.text.size

	var_25_1.divider.offset[2] = -var_25_2[2]
	var_25_1.divider_shadow.offset[2] = -(var_25_2[2] + 2)

	local var_25_3 = var_25_1.text2
	local var_25_4 = var_25_3.size
	local var_25_5 = var_25_3.offset

	var_25_4[2] = var_25_2[2]
	var_25_5[2] = -var_25_2[2]

	local var_25_6 = var_25_1.text2_shadow

	var_25_6.size[2] = var_25_2[2]
	var_25_6.offset[2] = -(var_25_2[2] + 2)

	local var_25_7 = arg_25_2.text2

	if arg_25_2.localize then
		var_25_7 = Localize(var_25_7)
	end

	var_25_0.text2 = var_25_7
end

function StoreWelcomePopup._populate_currency_entry_widget(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_1.content
	local var_26_1 = arg_26_1.style
	local var_26_2 = var_26_1.text.size
	local var_26_3 = var_26_1.text2
	local var_26_4 = var_26_3.size
	local var_26_5 = var_26_3.offset

	var_26_4[2] = var_26_2[2]
	var_26_5[2] = -var_26_2[2]

	local var_26_6 = var_26_1.text2_shadow

	var_26_6.size[2] = var_26_2[2]
	var_26_6.offset[2] = -(var_26_2[2] + 2)

	local var_26_7 = arg_26_2.value

	var_26_0.text2 = UIUtils.comma_value(var_26_7)
end

function StoreWelcomePopup._align_dlc_widgets(arg_27_0)
	local var_27_0 = 0
	local var_27_1 = 0
	local var_27_2 = 0
	local var_27_3 = 1
	local var_27_4 = 1
	local var_27_5 = 0
	local var_27_6 = 0
	local var_27_7 = arg_27_0._list_widgets
	local var_27_8 = #var_27_7

	for iter_27_0, iter_27_1 in ipairs(var_27_7) do
		local var_27_9 = iter_27_1.offset
		local var_27_10 = iter_27_1.content
		local var_27_11 = var_27_10.size
		local var_27_12 = var_27_11[1]
		local var_27_13 = var_27_11[2]

		if var_27_1 + var_27_12 > var_0_2 then
			var_27_4 = 1
			var_27_3 = var_27_3 + 1
			var_27_1 = 0
			var_27_2 = var_27_2 - (var_27_6 + var_0_1)
			var_27_6 = 0
		end

		var_27_9[1] = var_27_1
		var_27_9[2] = var_27_2
		iter_27_1.default_offset = table.clone(var_27_9)
		var_27_10.row = var_27_3
		var_27_10.column = var_27_4
		var_27_1 = var_27_1 + (var_27_12 + var_0_1)

		if iter_27_0 == var_27_8 then
			var_27_0 = math.abs(var_27_2 - var_27_13)
		end

		var_27_4 = var_27_4 + 1

		local var_27_14 = var_27_13

		if var_27_6 < var_27_13 then
			var_27_6 = var_27_13
		end
	end

	arg_27_0._total_list_height = var_27_0
end

function StoreWelcomePopup._initialize_scrollbar(arg_28_0)
	local var_28_0 = arg_28_0._widgets_by_name.list_scrollbar

	arg_28_0._scrollbar_logic = ScrollBarLogic:new(var_28_0)

	local var_28_1 = arg_28_0._scenegraph_definition.list_window.size
	local var_28_2 = arg_28_0._scenegraph_definition.list_scrollbar.size
	local var_28_3 = var_28_1[2]
	local var_28_4 = arg_28_0._total_list_height
	local var_28_5 = var_28_2[2]
	local var_28_6 = 220 + var_0_1 * 1.5
	local var_28_7 = 1
	local var_28_8 = arg_28_0._scrollbar_logic

	var_28_8:set_scrollbar_values(var_28_3, var_28_4, var_28_5, var_28_6, var_28_7)
	var_28_8:set_scroll_percentage(0)

	var_28_0.content.visible = var_28_3 < var_28_4
end

function StoreWelcomePopup._update_scroll_position(arg_29_0)
	local var_29_0 = arg_29_0._scrollbar_logic:get_scrolled_length()

	if var_29_0 ~= arg_29_0._scrolled_length then
		arg_29_0._ui_scenegraph.list.local_position[2] = var_29_0
		arg_29_0._scrolled_length = var_29_0
	end
end

function StoreWelcomePopup._update_visible_list_entries(arg_30_0)
	local var_30_0 = arg_30_0._scrollbar_logic

	if not var_30_0:enabled() then
		return
	end

	local var_30_1 = var_30_0:get_scroll_percentage()
	local var_30_2 = var_30_0:get_scrolled_length()
	local var_30_3 = var_30_0:get_scroll_length()
	local var_30_4 = arg_30_0._scenegraph_definition.list_window.size
	local var_30_5 = var_0_1 * 2
	local var_30_6 = var_30_4[2] + var_30_5
	local var_30_7 = arg_30_0._list_widgets
	local var_30_8 = #var_30_7

	for iter_30_0, iter_30_1 in ipairs(var_30_7) do
		local var_30_9 = iter_30_1.offset
		local var_30_10 = iter_30_1.content
		local var_30_11 = var_30_10.size
		local var_30_12 = math.abs(var_30_9[2]) + var_30_11[2]
		local var_30_13 = false

		if var_30_12 < var_30_2 - var_30_5 then
			var_30_13 = true
		elseif var_30_6 < math.abs(var_30_9[2]) - var_30_2 then
			var_30_13 = true
		end

		var_30_10.visible = not var_30_13
	end
end

function StoreWelcomePopup._set_total_amount(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._widgets_by_name
	local var_31_1 = var_31_0.currency_icon
	local var_31_2 = var_31_0.currency_text
	local var_31_3 = UIUtils.comma_value(tostring(arg_31_1))

	var_31_2.content.text = var_31_3

	local var_31_4 = arg_31_0._welcome_ui_renderer
	local var_31_5 = UIUtils.get_text_width(var_31_4, var_31_2.style.text, var_31_3)
	local var_31_6 = arg_31_0._scenegraph_definition.currency_icon.size[1]
	local var_31_7 = var_31_5 + 5

	arg_31_0._ui_scenegraph[var_31_2.scenegraph_id].size[1] = var_31_7
end
