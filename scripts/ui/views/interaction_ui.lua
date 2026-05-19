-- chunkname: @scripts/ui/views/interaction_ui.lua

InteractionUI = class(InteractionUI)

local var_0_0 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.interaction
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.interaction
		},
		size = {
			1920,
			1080
		}
	},
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			1,
			1
		}
	},
	interaction = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "left",
		size = {
			274,
			82
		},
		position = {
			60,
			0,
			10
		}
	},
	text_pivot = {
		vertical_alignment = "center",
		parent = "interaction",
		size = {
			0,
			0
		},
		position = {
			14,
			-22,
			2
		}
	},
	tooltip_icon = {
		vertical_alignment = "center",
		parent = "interaction",
		horizontal_alignment = "left",
		size = {
			62,
			62
		},
		position = {
			14,
			-22,
			1
		}
	},
	title_text_pivot = {
		vertical_alignment = "center",
		parent = "tooltip_icon",
		size = {
			0,
			0
		},
		position = {
			0,
			22,
			2
		}
	},
	interaction_bar = {
		vertical_alignment = "center",
		parent = "interaction",
		horizontal_alignment = "left",
		size = {
			217,
			35
		},
		position = {
			4,
			-1,
			4
		}
	},
	interaction_bar_fill = {
		vertical_alignment = "center",
		parent = "interaction_bar",
		horizontal_alignment = "left",
		size = {
			217,
			35
		},
		position = {
			0,
			0,
			1
		}
	}
}

if not IS_WINDOWS then
	var_0_0.screen.scale = "hud_fit"
end

local var_0_1 = {
	tooltip = {
		scenegraph_id = "interaction",
		element = {
			passes = {
				{
					texture_id = "icon_textures",
					style_id = "icon_styles",
					pass_type = "multi_texture"
				},
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					pass_type = "texture",
					style_id = "background_interaction_bar",
					texture_id = "background_interaction_bar"
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function(arg_1_0)
						return arg_1_0.text ~= ""
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function(arg_2_0)
						return arg_2_0.text ~= ""
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_3_0)
						return arg_3_0.text and arg_3_0.text ~= ""
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_4_0)
						return arg_4_0.text and arg_4_0.text ~= ""
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_5_0)
						return arg_5_0.title_text
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_6_0)
						return arg_6_0.title_text
					end
				},
				{
					style_id = "hotkey_text",
					pass_type = "text",
					text_id = "hotkey_text",
					content_check_function = function(arg_7_0)
						return arg_7_0.has_hotkey and not arg_7_0.gamepad_active
					end
				},
				{
					style_id = "hotkey_text_shadow",
					pass_type = "text",
					text_id = "hotkey_text",
					content_check_function = function(arg_8_0)
						return arg_8_0.has_hotkey and not arg_8_0.gamepad_active
					end
				}
			}
		},
		content = {
			background_interaction_bar = "interaction_pop_up_bar_border",
			title_text = "title_text",
			has_hotkey = false,
			hotkey_text = " ",
			button_text = "",
			text = "tooltip_text",
			background = "interaction_pop_up",
			gamepad_active = false,
			icon_textures = {}
		},
		style = {
			background = {
				offset = {
					0,
					-5,
					-1
				},
				size = {
					274,
					82
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			background_interaction_bar = {
				scenegraph_id = "interaction_bar",
				offset = {
					10,
					12,
					0
				},
				size = {
					212,
					10
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			title_text = {
				vertical_alignment = "bottom",
				upper_case = true,
				horizontal_alignment = "left",
				font_size = 20,
				font_type = "hell_shark",
				scenegraph_id = "title_text_pivot",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			},
			title_text_shadow = {
				vertical_alignment = "bottom",
				upper_case = true,
				horizontal_alignment = "left",
				font_size = 20,
				font_type = "hell_shark",
				scenegraph_id = "title_text_pivot",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					1
				}
			},
			text = {
				font_size = 30,
				upper_case = true,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				scenegraph_id = "text_pivot",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				disabled_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text_shadow = {
				upper_case = true,
				horizontal_alignment = "left",
				font_size = 30,
				pixel_perfect = true,
				scenegraph_id = "text_pivot",
				vertical_alignment = "center",
				dynamic_font = true,
				skip_button_rendering = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					1
				}
			},
			hotkey_text = {
				font_size = 20,
				upper_case = true,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				scenegraph_id = "text_pivot",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				disabled_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					-30,
					-30,
					2
				}
			},
			hotkey_text_shadow = {
				upper_case = true,
				horizontal_alignment = "left",
				font_size = 20,
				pixel_perfect = true,
				scenegraph_id = "text_pivot",
				vertical_alignment = "center",
				dynamic_font = true,
				skip_button_rendering = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-32,
					-32,
					1
				}
			},
			button_text = {
				font_size = 30,
				scenegraph_id = "tooltip_icon",
				horizontal_alignment = "left",
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					0,
					2
				}
			},
			button_text_shadow = {
				font_size = 30,
				scenegraph_id = "tooltip_icon",
				horizontal_alignment = "left",
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					1
				}
			},
			icon_styles = {
				scenegraph_id = "tooltip_icon",
				draw_count = 0,
				texture_sizes = {
					{
						20,
						36
					}
				},
				offset = {
					0,
					3,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	},
	interaction_bar = {
		scenegraph_id = "interaction_bar",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "glow",
					texture_id = "glow"
				},
				{
					style_id = "bar",
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					content_id = "bar",
					dynamic_function = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
						local var_9_0 = arg_9_0.bar_value
						local var_9_1 = arg_9_1.uv_start_pixels
						local var_9_2 = arg_9_1.uv_scale_pixels
						local var_9_3 = var_9_1 + var_9_2 * var_9_0
						local var_9_4 = arg_9_1.uvs
						local var_9_5 = arg_9_1.scale_axis
						local var_9_6 = arg_9_1.offset_scale
						local var_9_7 = arg_9_1.offset

						var_9_4[2][var_9_5] = var_9_3 / (var_9_1 + var_9_2)
						arg_9_2[var_9_5] = var_9_3

						return arg_9_0.color, var_9_4, arg_9_2, var_9_7
					end
				}
			}
		},
		content = {
			glow = "interaction_pop_up_glow_2",
			bar = {
				texture_id = "interaction_pop_up_glow_1",
				bar_value = 1
			}
		},
		style = {
			glow = {
				scenegraph_id = "interaction_bar_fill",
				size = {
					57,
					111
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-35.5,
					1
				}
			},
			bar = {
				uv_start_pixels = 0,
				scenegraph_id = "interaction_bar_fill",
				uv_scale_pixels = 217,
				offset_scale = 1,
				scale_axis = 1,
				offset = {
					0,
					0,
					0
				},
				color = {
					0,
					255,
					255,
					255
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		}
	}
}
local var_0_2 = {}

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_3 = iter_0_1.interaction_ui_components

	if var_0_3 then
		for iter_0_2, iter_0_3 in pairs(var_0_3) do
			fassert(not var_0_2[iter_0_2], "[InternactionUi] There is already a component with the name %q", iter_0_2)
			local_require(iter_0_3.filename)

			var_0_2[iter_0_2] = iter_0_3.class_name
		end
	end
end

local function var_0_4(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0) do
		if iter_10_0 == arg_10_1 then
			return true
		end
	end

	return false
end

function InteractionUI.init(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._parent = arg_11_1
	arg_11_0.ui_renderer = arg_11_2.ui_renderer
	arg_11_0.input_manager = arg_11_2.input_manager
	arg_11_0.player_manager = arg_11_2.player_manager
	arg_11_0.peer_id = arg_11_2.peer_id
	arg_11_0.profile_synchronizer = arg_11_2.profile_synchronizer
	arg_11_0.world = arg_11_2.world
	arg_11_0._ingame_ui_context = arg_11_2
	arg_11_0.platform = PLATFORM
	arg_11_0.interaction_animations = {}

	arg_11_0:create_ui_elements()

	arg_11_0.localized_texts = {
		hold = Localize("interaction_prefix_hold"),
		press = Localize("interaction_prefix_press"),
		to = Localize("interaction_to")
	}
end

function InteractionUI.create_ui_elements(arg_12_0)
	UIRenderer.clear_scenegraph_queue(arg_12_0.ui_renderer)

	arg_12_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0)
	arg_12_0.interaction_widget = UIWidget.init(var_0_1.tooltip)
	arg_12_0.interaction_bar_widget = UIWidget.init(var_0_1.interaction_bar)
	arg_12_0._components = {}

	for iter_12_0, iter_12_1 in pairs(var_0_2) do
		local var_12_0 = rawget(_G, iter_12_1)

		arg_12_0._components[iter_12_0] = var_12_0:new(arg_12_0, arg_12_0._ingame_ui_context)
	end
end

function InteractionUI.destroy(arg_13_0)
	GarbageLeakDetector.register_object(arg_13_0, "interaction_gui")

	for iter_13_0, iter_13_1 in pairs(arg_13_0._components) do
		iter_13_1:destroy()
	end
end

function InteractionUI.button_texture_data_by_input_action(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.input_manager
	local var_14_1 = var_14_0:get_service("Player")
	local var_14_2 = var_14_0:is_device_active("gamepad")

	return UISettings.get_gamepad_input_texture_data(var_14_1, arg_14_1, var_14_2)
end

function InteractionUI._animate_in_progress_bar(arg_15_0)
	local var_15_0 = arg_15_0.interaction_bar_widget.content
	local var_15_1 = arg_15_0.interaction_bar_widget.style
	local var_15_2 = UISettings.interaction.bar.fade_in

	arg_15_0.interaction_animations.interaction_bar_glow_fade = UIAnimation.init(UIAnimation.function_by_time, var_15_1.glow.color, 1, 0, 255, 0.3, math.easeInCubic)
	arg_15_0.interaction_animations.interaction_bar_fill_fade = UIAnimation.init(UIAnimation.function_by_time, var_15_1.bar.color, 1, 0, 255, var_15_2, math.easeInCubic)
end

function InteractionUI._animate_out_progress_bar(arg_16_0)
	local var_16_0 = UISettings.interaction.bar.fade_out
	local var_16_1 = arg_16_0.interaction_bar_widget.style

	arg_16_0.interaction_animations.interaction_bar_glow_fade = UIAnimation.init(UIAnimation.function_by_time, var_16_1.glow.color, 1, var_16_1.glow.color[1], 0, var_16_0, math.easeInCubic)
	arg_16_0.interaction_animations.interaction_bar_fill_fade = UIAnimation.init(UIAnimation.function_by_time, var_16_1.bar.color, 1, var_16_1.bar.color[1], 0, var_16_0, math.easeInCubic)
end

function InteractionUI._handle_interaction_progress(arg_17_0, arg_17_1)
	if arg_17_1 and arg_17_1 ~= 0 then
		local var_17_0 = arg_17_0.interaction_bar_widget.content
		local var_17_1 = arg_17_0.interaction_bar_widget.style

		if not arg_17_0.draw_interaction_bar then
			arg_17_0.draw_interaction_bar = true

			arg_17_0:_animate_in_progress_bar()
		end

		var_17_0.bar.bar_value = arg_17_1

		local var_17_2 = var_17_1.glow
		local var_17_3 = var_17_2.size

		var_17_2.offset[1] = -(var_17_3[1] / 2) + 217 * arg_17_1

		return true
	end
end

local var_0_5 = {
	root_scenegraph_id = "pivot",
	label = "Interact",
	registry_key = "interact",
	drag_scenegraph_id = "interaction"
}
local var_0_6 = false
local var_0_7 = {
	0,
	0,
	0
}

function InteractionUI.update(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if var_0_6 then
		arg_18_0:create_ui_elements()
	end

	local var_18_0 = arg_18_0.ui_renderer
	local var_18_1 = arg_18_0.ui_scenegraph
	local var_18_2 = arg_18_0.input_manager:get_service("Player")
	local var_18_3 = arg_18_0.input_manager:is_device_active("gamepad")
	local var_18_4 = arg_18_3.player_unit

	if not var_18_4 then
		return
	end

	var_0_5.registry_key = InteractionHelper.interaction_action_names(arg_18_3.player_unit)

	HudCustomizer.run(arg_18_0.ui_renderer, arg_18_0.ui_scenegraph, var_0_5)

	for iter_18_0, iter_18_1 in pairs(arg_18_0.interaction_animations) do
		UIAnimation.update(iter_18_1, arg_18_1)

		if UIAnimation.completed(iter_18_1) then
			arg_18_0.interaction_animations[iter_18_0] = nil
		end
	end

	local var_18_5 = ScriptUnit.extension(var_18_4, "interactor_system")
	local var_18_6 = false
	local var_18_7
	local var_18_8
	local var_18_9
	local var_18_10
	local var_18_11
	local var_18_12
	local var_18_13
	local var_18_14
	local var_18_15 = var_18_5:is_interacting()
	local var_18_16 = var_18_5:is_waiting_for_interaction_approval()

	if var_18_15 and not var_18_16 and not var_18_5:is_aborting_interaction() then
		local var_18_17 = Managers.time:time("game")
		local var_18_18 = var_18_5:get_progress(var_18_17)

		var_18_6 = arg_18_0:_handle_interaction_progress(var_18_18)

		if var_18_6 then
			var_18_11 = true
		end
	end

	local var_18_19, var_18_20, var_18_21, var_18_22, var_18_23, var_18_24, var_18_25 = arg_18_0:_get_interaction_text(var_18_4, var_18_11)

	if var_18_20 then
		local var_18_26

		var_18_26 = var_18_19 and Localize(var_18_19) or ""

		if var_18_22 == "ammo_blocked" or var_18_22 == "throwing_axe" then
			local var_18_27 = Managers.input:is_device_active("gamepad") and "$KEY;Player__weapon_reload_hold_input:" or "$KEY;Player__weapon_reload_hold:"

			var_18_20 = var_18_20 and TextToUpper(Localize(var_18_20)) .. var_18_27 or ""
		else
			var_18_20 = var_18_20 and Localize(var_18_20) or ""
		end

		arg_18_0:_assign_button_info(var_18_21, var_18_22, var_18_11, var_18_23)

		local var_18_28 = arg_18_0.interaction_widget.style
		local var_18_29 = arg_18_0.interaction_widget.content

		var_18_29.gamepad_active = var_18_3
		var_18_29.text = var_18_20
		var_18_29.title_text = var_18_26

		local var_18_30, var_18_31, var_18_32 = var_18_5:can_interact()
		local var_18_33 = not not UISettings.interaction_hotkey_lookup[var_18_32]

		arg_18_0:_update_interaction_widget_size(var_18_33, var_18_3)

		var_18_29.hotkey_text = var_18_25

		if not arg_18_0.draw_interaction_tooltip then
			local var_18_34 = var_18_28.icon_styles
			local var_18_35 = var_18_28.button_text
			local var_18_36 = var_18_28.button_text_shadow
			local var_18_37 = var_18_28.text
			local var_18_38 = var_18_28.text_shadow
			local var_18_39 = var_18_28.title_text
			local var_18_40 = var_18_28.title_text_shadow
			local var_18_41 = var_18_28.background
			local var_18_42 = var_18_28.hotkey_text
			local var_18_43 = var_18_28.hotkey_text_shadow
			local var_18_44 = var_18_28.background_interaction_bar
			local var_18_45 = 0.1
			local var_18_46 = 255

			arg_18_0.interaction_animations.tooltip_icon_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_34.color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.tooltip_button_text_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_35.text_color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.tooltip_button_text_shadow_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_36.text_color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.tooltip_text_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_37.text_color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.tooltip_text_shadow_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_38.text_color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.tooltip_title_text_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_39.text_color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.tooltip_title_text_shadow_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_40.text_color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.tooltip_background_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_41.color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.hotkey_text_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_42.text_color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.hotkey_text_shadow_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_43.text_color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
			arg_18_0.interaction_animations.background_interaction_bar_fade = UIAnimation.init(UIAnimation.function_by_time, var_18_44.color, 1, 0, var_18_46, var_18_45, math.easeInCubic)
		end

		arg_18_0.draw_interaction_tooltip = true
	elseif arg_18_0.draw_interaction_tooltip then
		arg_18_0.draw_interaction_tooltip = nil
	end

	if not var_18_6 and arg_18_0.draw_interaction_bar then
		arg_18_0.draw_interaction_bar = nil

		arg_18_0:_animate_out_progress_bar()
	end

	local var_18_47 = arg_18_0._components[var_18_24]

	if var_18_47 then
		local var_18_48 = var_18_47:update(var_18_4, arg_18_1, arg_18_2)

		var_18_1.pivot.local_position = var_18_48 or var_0_7
	end

	UIRenderer.begin_pass(var_18_0, var_18_1, var_18_2, arg_18_1)

	if arg_18_0.draw_interaction_bar or arg_18_0.interaction_animations.interaction_bar_bg_fade then
		UIRenderer.draw_widget(var_18_0, arg_18_0.interaction_bar_widget)
	end

	if arg_18_0.draw_interaction_tooltip then
		UIRenderer.draw_widget(var_18_0, arg_18_0.interaction_widget)
	end

	UIRenderer.end_pass(var_18_0)

	var_18_1.pivot.local_position = var_0_7
end

function InteractionUI._update_interaction_widget_size(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.interaction_widget

	var_19_0.content.has_hotkey = arg_19_1

	local var_19_1 = var_19_0.style

	if arg_19_1 and not arg_19_2 then
		var_19_1.background.size[2] = 112
		var_19_1.background.offset[2] = -32.5
	else
		var_19_1.background.size[2] = 82
		var_19_1.background.offset[2] = -5
	end
end

function InteractionUI._get_interaction_text(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = ScriptUnit.extension(arg_20_1, "interactor_system")
	local var_20_1 = var_20_0:interactable_unit()
	local var_20_2
	local var_20_3
	local var_20_4
	local var_20_5
	local var_20_6
	local var_20_7
	local var_20_8, var_20_9, var_20_10 = var_20_0:can_interact()
	local var_20_11, var_20_12 = var_20_0:is_interacting()

	var_20_10 = var_20_10 or var_20_12

	if (var_20_8 or arg_20_2 or var_20_9) and var_20_10 ~= "heal" and var_20_10 ~= "give_item" then
		if not var_20_2 or not var_20_3 or not var_20_4 then
			if var_20_8 then
				var_20_4 = InteractionHelper.interaction_action_names(arg_20_1, var_20_1)
			end

			if var_20_8 or var_20_11 then
				var_20_2, var_20_3, var_20_5 = var_20_0:interaction_description()
			elseif var_20_9 then
				var_20_2, var_20_3, var_20_5 = var_20_0:interaction_description(var_20_9)
			end
		end
	else
		var_20_2, var_20_3, var_20_4, var_20_6, var_20_5 = arg_20_0:_get_wielded_interaction_text(arg_20_1)
	end

	if not not UISettings.interaction_hotkey_lookup[var_20_10] then
		local var_20_13 = UISettings.interaction_hotkey_lookup[var_20_10]
		local var_20_14 = string.format("$KEY;ingame_menu__%s:", var_20_13)

		var_20_7 = TextToUpper(Localize("hotkey_reminder")) .. var_20_14
	end

	if GameSettingsDevelopment.disabled_interactions[var_20_10] then
		var_20_2 = "Currently Disabled"
	end

	return var_20_2, var_20_3, var_20_4, var_20_9, var_20_6, var_20_5, var_20_7
end

function InteractionUI._get_wielded_interaction_text(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0:_get_wielded_item_data(arg_21_1)

	if not var_21_0 then
		return
	end

	local var_21_1
	local var_21_2
	local var_21_3
	local var_21_4
	local var_21_5
	local var_21_6 = 0
	local var_21_7
	local var_21_8
	local var_21_9 = ScriptUnit.extension(arg_21_1, "interactor_system")
	local var_21_10, var_21_11 = var_21_9:is_interacting()
	local var_21_12 = BackendUtils.get_item_template(var_21_0)

	for iter_21_0, iter_21_1 in pairs(var_21_12.actions) do
		for iter_21_2, iter_21_3 in pairs(iter_21_1) do
			local var_21_13 = iter_21_3.interaction_priority or -1000

			if iter_21_3.interaction_type ~= nil and var_21_6 < var_21_13 and (iter_21_3.show_interaction_ui and iter_21_3.show_interaction_ui(arg_21_1) or iter_21_3.condition_func(arg_21_1) or var_21_10 and iter_21_3.interaction_type == var_21_11) and arg_21_0:button_texture_data_by_input_action(iter_21_3.hold_input or iter_21_0) then
				var_21_6 = iter_21_3.interaction_priority
				var_21_7 = iter_21_0
				var_21_8 = iter_21_2
			end
		end
	end

	if var_21_7 then
		local var_21_14 = var_21_12.actions[var_21_7][var_21_8]
		local var_21_15 = var_21_14.interaction_type
		local var_21_16 = InteractionDefinitions[var_21_15]
		local var_21_17 = var_21_9:interactable_unit()
		local var_21_18 = var_21_9.interaction_context.data

		if Unit.alive(var_21_17) then
			if var_21_16.client.can_interact(arg_21_1, var_21_17, var_21_18, var_21_16.config, arg_21_0.world) then
				var_21_1, var_21_2, var_21_4, var_21_5 = var_21_16.client.hud_description(var_21_17, var_21_18, var_21_16.config, nil, arg_21_1)
			else
				var_21_1, var_21_2, var_21_4, var_21_5 = var_21_16.client.hud_description(nil, var_21_18, var_21_16.config, nil, arg_21_1)
			end
		else
			var_21_1, var_21_2, var_21_4, var_21_5 = var_21_16.client.hud_description(nil, var_21_18, var_21_16.config, nil, arg_21_1)
		end

		var_21_3 = var_21_14.hold_input or var_21_7
	end

	return var_21_1, var_21_2, var_21_3, var_21_4, var_21_5
end

function InteractionUI._get_wielded_item_data(arg_22_0, arg_22_1)
	return ScriptUnit.extension(arg_22_1, "inventory_system"):equipment().wielded
end

function InteractionUI._assign_button_info(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = arg_23_0.ui_renderer
	local var_23_1 = arg_23_0.ui_scenegraph
	local var_23_2 = arg_23_0.interaction_widget.style
	local var_23_3 = arg_23_0.interaction_widget.content
	local var_23_4 = 0
	local var_23_5 = 0
	local var_23_6 = var_23_2.text.text_color
	local var_23_7

	if arg_23_1 and not arg_23_2 and not arg_23_3 then
		local var_23_8, var_23_9 = arg_23_0:button_texture_data_by_input_action(arg_23_1)

		if var_23_8 and var_23_8.texture then
			var_23_3.button_text = ""
			var_23_3.icon_textures[1] = var_23_8.texture

			local var_23_10 = {
				var_23_8.size[1] / var_23_8.size[2] * var_23_8.size[1],
				var_23_8.size[1]
			}

			var_23_2.icon_styles.texture_sizes[1] = var_23_10
			var_23_2.icon_styles.draw_count = 1
			var_23_4 = var_23_8.size[1]
			var_23_5 = var_23_8.size[2]
		else
			local var_23_11 = "[" .. TextToUpper(var_23_9) .. "]"
			local var_23_12 = var_23_2.button_text
			local var_23_13, var_23_14 = UIFontByResolution(var_23_12)
			local var_23_15, var_23_16, var_23_17 = UIRenderer.text_size(var_23_0, var_23_11, var_23_13[1], var_23_14)

			var_23_4 = var_23_15
			var_23_5 = -8
			var_23_3.button_text = var_23_11
			var_23_2.icon_styles.draw_count = 0
		end

		var_23_1.text_pivot.local_position[1] = var_0_0.text_pivot.position[1] + var_23_4
		var_23_1.tooltip_icon.size[1] = var_23_4
		var_23_1.tooltip_icon.size[2] = var_23_5
		var_23_7 = var_23_2.text.default_text_color
	else
		var_23_2.icon_styles.draw_count = 0
		var_23_3.button_text = ""
		var_23_1.tooltip_icon.size[1] = 0
		var_23_1.text_pivot.local_position[1] = var_0_0.text_pivot.position[1]

		if arg_23_2 then
			var_23_7 = var_23_2.text.disabled_text_color
		elseif arg_23_3 then
			var_23_7 = var_23_2.text.disabled_text_color
		else
			var_23_7 = var_23_2.text.default_text_color
		end
	end

	if arg_23_4 then
		var_23_7 = arg_23_4
	end

	var_23_6[2] = var_23_7[2]
	var_23_6[3] = var_23_7[3]
	var_23_6[4] = var_23_7[4]
end

function InteractionUI.external_interact_ui_description(arg_24_0, arg_24_1)
	local var_24_0 = ScriptUnit.extension(arg_24_1, "overcharge_system")

	if var_24_0:is_above_critical_limit() and not var_24_0:are_you_exploding() then
		return "interaction_overheat", "interaction_action_vent", "weapon_reload"
	end
end
