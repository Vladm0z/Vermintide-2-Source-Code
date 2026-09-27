-- chunkname: @scripts/ui/views/interaction_ui.lua

InteractionUI = class(InteractionUI)

local tbl = {
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
	tbl.screen.scale = "hud_fit"
end

local tbl_2 = {
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
					content_check_function = function (self)
						-- function 1
						return self.text ~= ""
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 2
						return self.text ~= ""
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 3
						local text = self.text

						text = not text and self.text ~= ""

						return text
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 4
						local text = self.text

						text = not text and self.text ~= ""

						return text
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 5
						return self.title_text
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 6
						return self.title_text
					end
				},
				{
					style_id = "hotkey_text",
					pass_type = "text",
					text_id = "hotkey_text",
					content_check_function = function (self)
						-- function 7
						local has_hotkey = self.has_hotkey

						has_hotkey = not has_hotkey and not self.gamepad_active

						return has_hotkey
					end
				},
				{
					style_id = "hotkey_text_shadow",
					pass_type = "text",
					text_id = "hotkey_text",
					content_check_function = function (self)
						-- function 8
						local has_hotkey = self.has_hotkey

						has_hotkey = not has_hotkey and not self.gamepad_active

						return has_hotkey
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
					dynamic_function = function (self, arg_9_1, arg_9_2, arg_9_3)
						-- function 9
						local bar_value = self.bar_value
						local uv_start_pixels = arg_9_1.uv_start_pixels
						local uv_scale_pixels = arg_9_1.uv_scale_pixels
						local num = uv_start_pixels + uv_scale_pixels * bar_value
						local uvs = arg_9_1.uvs
						local scale_axis = arg_9_1.scale_axis
						local offset_scale = arg_9_1.offset_scale
						local offset = arg_9_1.offset

						uvs[2][scale_axis] = num / (uv_start_pixels + uv_scale_pixels)
						arg_9_2[scale_axis] = num

						return self.color, uvs, arg_9_2, offset
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
local tbl_3 = {}

for k, v in pairs(DLCSettings) do
	local interaction_ui_components = v.interaction_ui_components

	if not interaction_ui_components then
		for k_2, v_2 in pairs(interaction_ui_components) do
			fassert(not tbl_3[k_2], "[InternactionUi] There is already a component with the name %q", k_2)
			local_require(v_2.filename)

			tbl_3[k_2] = v_2.class_name
		end
	end
end

local function fn(arg_10_0, arg_10_1)
	-- function 10
	for k, v in pairs(arg_10_0) do
		if k == arg_10_1 then
			return true
		end
	end

	return false
end

InteractionUI.init = function (self, arg_11_1, arg_11_2)
	-- function 11
	self._parent = arg_11_1
	self.ui_renderer = arg_11_2.ui_renderer
	self.input_manager = arg_11_2.input_manager
	self.player_manager = arg_11_2.player_manager
	self.peer_id = arg_11_2.peer_id
	self.profile_synchronizer = arg_11_2.profile_synchronizer
	self.world = arg_11_2.world
	self._ingame_ui_context = arg_11_2
	self.platform = PLATFORM
	self.interaction_animations = {}

	self:create_ui_elements()

	self.localized_texts = {
		hold = Localize("interaction_prefix_hold"),
		press = Localize("interaction_prefix_press"),
		to = Localize("interaction_to")
	}
end

InteractionUI.create_ui_elements = function (self)
	-- function 12
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.interaction_widget = UIWidget.init(tbl_2.tooltip)
	self.interaction_bar_widget = UIWidget.init(tbl_2.interaction_bar)
	self._components = {}

	for k, v in pairs(tbl_3) do
		local var_12_0 = rawget(_G, v)

		self._components[k] = var_12_0:new(self, self._ingame_ui_context)
	end
end

InteractionUI.destroy = function (self)
	-- function 13
	GarbageLeakDetector.register_object(self, "interaction_gui")

	for k, v in pairs(self._components) do
		v:destroy()
	end
end

InteractionUI.button_texture_data_by_input_action = function (self, arg_14_1)
	-- function 14
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("Player")
	local is_device_active = input_manager:is_device_active("gamepad")

	return UISettings.get_gamepad_input_texture_data(get_service, arg_14_1, is_device_active)
end

InteractionUI._animate_in_progress_bar = function (self)
	-- function 15
	local content = self.interaction_bar_widget.content
	local style = self.interaction_bar_widget.style
	local fade_in = UISettings.interaction.bar.fade_in

	self.interaction_animations.interaction_bar_glow_fade = UIAnimation.init(UIAnimation.function_by_time, style.glow.color, 1, 0, 255, 0.3, math.easeInCubic)
	self.interaction_animations.interaction_bar_fill_fade = UIAnimation.init(UIAnimation.function_by_time, style.bar.color, 1, 0, 255, fade_in, math.easeInCubic)
end

InteractionUI._animate_out_progress_bar = function (self)
	-- function 16
	local fade_out = UISettings.interaction.bar.fade_out
	local style = self.interaction_bar_widget.style

	self.interaction_animations.interaction_bar_glow_fade = UIAnimation.init(UIAnimation.function_by_time, style.glow.color, 1, style.glow.color[1], 0, fade_out, math.easeInCubic)
	self.interaction_animations.interaction_bar_fill_fade = UIAnimation.init(UIAnimation.function_by_time, style.bar.color, 1, style.bar.color[1], 0, fade_out, math.easeInCubic)
end

InteractionUI._handle_interaction_progress = function (self, arg_17_1)
	-- function 17
	if not (not arg_17_1 and arg_17_1 == 0) then
		local content = self.interaction_bar_widget.content
		local style = self.interaction_bar_widget.style

		if not self.draw_interaction_bar then
			self.draw_interaction_bar = true

			self:_animate_in_progress_bar()
		end

		content.bar.bar_value = arg_17_1

		local glow = style.glow
		local size = glow.size

		glow.offset[1] = -(size[1] / 2) + 217 * arg_17_1

		return true
	end
end

local tbl_4 = {
	root_scenegraph_id = "pivot",
	label = "Interact",
	registry_key = "interact",
	drag_scenegraph_id = "interaction"
}
local flag = false
local tbl_5 = {
	0,
	0,
	0
}

InteractionUI.update = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	if not flag then
		self:create_ui_elements()
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")
	local is_device_active = self.input_manager:is_device_active("gamepad")
	local player_unit = arg_18_3.player_unit

	if not player_unit then
		return
	end

	tbl_4.registry_key = InteractionHelper.interaction_action_names(arg_18_3.player_unit)

	HudCustomizer.run(self.ui_renderer, self.ui_scenegraph, tbl_4)

	for k, v in pairs(self.interaction_animations) do
		UIAnimation.update(v, arg_18_1)

		if not UIAnimation.completed(v) then
			self.interaction_animations[k] = nil
		end
	end

	local extension = ScriptUnit.extension(player_unit, "interactor_system")
	local flag_2 = false
	local var_18_7
	local var_18_8
	local var_18_9
	local var_18_10
	local var_18_11
	local var_18_12
	local var_18_13
	local var_18_14
	local is_interacting = extension:is_interacting()
	local is_waiting_for_interaction_approval = extension:is_waiting_for_interaction_approval()

	if not (not is_interacting and not not is_waiting_for_interaction_approval or not extension:is_aborting_interaction()) then
		local time = Managers.time:time("game")
		local get_progress = extension:get_progress(time)

		flag_2 = self:_handle_interaction_progress(get_progress)

		if not flag_2 then
			var_18_11 = true
		end
	end

	local _get_interaction_text, var_18_20, var_18_21, var_18_22, var_18_23, var_18_24, var_18_25 = self:_get_interaction_text(player_unit, var_18_11)

	if not var_18_20 then
		local flag_3

		flag_3 = not _get_interaction_text and Localize(_get_interaction_text) and ""

		if not (var_18_22 == "ammo_blocked" or var_18_22 ~= "throwing_axe") then
			local flag_4

			flag_4 = not Managers.input:is_device_active("gamepad") and "$KEY;Player__weapon_reload_hold_input:" and "$KEY;Player__weapon_reload_hold:"
			var_18_20 = not var_18_20 and TextToUpper(Localize(var_18_20)) .. flag_4 and ""
		else
			var_18_20 = not var_18_20 and Localize(var_18_20) and ""
		end

		self:_assign_button_info(var_18_21, var_18_22, var_18_11, var_18_23)

		local style = self.interaction_widget.style
		local content = self.interaction_widget.content

		content.gamepad_active = is_device_active
		content.text = var_18_20
		content.title_text = flag_3

		local can_interact, var_18_31, var_18_32 = extension:can_interact()
		local flag_5 = not not UISettings.interaction_hotkey_lookup[var_18_32]

		self:_update_interaction_widget_size(flag_5, is_device_active)

		content.hotkey_text = var_18_25

		if not self.draw_interaction_tooltip then
			local icon_styles = style.icon_styles
			local button_text = style.button_text
			local button_text_shadow = style.button_text_shadow
			local text = style.text
			local text_shadow = style.text_shadow
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local background = style.background
			local hotkey_text = style.hotkey_text
			local hotkey_text_shadow = style.hotkey_text_shadow
			local background_interaction_bar = style.background_interaction_bar
			local num = 0.1
			local num_2 = 255

			self.interaction_animations.tooltip_icon_fade = UIAnimation.init(UIAnimation.function_by_time, icon_styles.color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.tooltip_button_text_fade = UIAnimation.init(UIAnimation.function_by_time, button_text.text_color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.tooltip_button_text_shadow_fade = UIAnimation.init(UIAnimation.function_by_time, button_text_shadow.text_color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.tooltip_text_fade = UIAnimation.init(UIAnimation.function_by_time, text.text_color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.tooltip_text_shadow_fade = UIAnimation.init(UIAnimation.function_by_time, text_shadow.text_color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.tooltip_title_text_fade = UIAnimation.init(UIAnimation.function_by_time, title_text.text_color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.tooltip_title_text_shadow_fade = UIAnimation.init(UIAnimation.function_by_time, title_text_shadow.text_color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.tooltip_background_fade = UIAnimation.init(UIAnimation.function_by_time, background.color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.hotkey_text_fade = UIAnimation.init(UIAnimation.function_by_time, hotkey_text.text_color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.hotkey_text_shadow_fade = UIAnimation.init(UIAnimation.function_by_time, hotkey_text_shadow.text_color, 1, 0, num_2, num, math.easeInCubic)
			self.interaction_animations.background_interaction_bar_fade = UIAnimation.init(UIAnimation.function_by_time, background_interaction_bar.color, 1, 0, num_2, num, math.easeInCubic)
		end

		self.draw_interaction_tooltip = true
	elseif not self.draw_interaction_tooltip then
		self.draw_interaction_tooltip = nil
	end

	if flag_2 or not self.draw_interaction_bar then
		self.draw_interaction_bar = nil

		self:_animate_out_progress_bar()
	end

	local var_18_47 = self._components[var_18_24]

	if not var_18_47 then
		local update = var_18_47:update(player_unit, arg_18_1, arg_18_2)

		ui_scenegraph.pivot.local_position = update or tbl_5
	end

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_18_1)

	if self.draw_interaction_bar or not self.interaction_animations.interaction_bar_bg_fade then
		UIRenderer.draw_widget(ui_renderer, self.interaction_bar_widget)
	end

	if not self.draw_interaction_tooltip then
		UIRenderer.draw_widget(ui_renderer, self.interaction_widget)
	end

	UIRenderer.end_pass(ui_renderer)

	ui_scenegraph.pivot.local_position = tbl_5
end

InteractionUI._update_interaction_widget_size = function (self, arg_19_1, arg_19_2)
	-- function 19
	local interaction_widget = self.interaction_widget

	interaction_widget.content.has_hotkey = arg_19_1

	local style = interaction_widget.style

	if not (not arg_19_1 and arg_19_2) then
		style.background.size[2] = 112
		style.background.offset[2] = -32.5
	else
		style.background.size[2] = 82
		style.background.offset[2] = -5
	end
end

InteractionUI._get_interaction_text = function (self, arg_20_1, arg_20_2)
	-- function 20
	local extension = ScriptUnit.extension(arg_20_1, "interactor_system")
	local interactable_unit = extension:interactable_unit()
	local var_20_2
	local var_20_3
	local var_20_4
	local var_20_5
	local var_20_6
	local var_20_7
	local can_interact, var_20_9, var_20_10 = extension:can_interact()
	local is_interacting, var_20_12 = extension:is_interacting()

	var_20_10 = var_20_10 or var_20_12

	if not (not (can_interact or arg_20_2 or var_20_9) and var_20_10 == "heal" or var_20_10 == "give_item") then
		if not (not var_20_2 and not var_20_3 and var_20_4) then
			if not can_interact then
				var_20_4 = InteractionHelper.interaction_action_names(arg_20_1, interactable_unit)
			end

			if can_interact or not is_interacting then
				var_20_2, var_20_3, var_20_5 = extension:interaction_description()
			elseif not var_20_9 then
				var_20_2, var_20_3, var_20_5 = extension:interaction_description(var_20_9)
			end
		end
	else
		var_20_2, var_20_3, var_20_4, var_20_6, var_20_5 = self:_get_wielded_interaction_text(arg_20_1)
	end

	if not not not UISettings.interaction_hotkey_lookup[var_20_10] then
		local var_20_13 = UISettings.interaction_hotkey_lookup[var_20_10]
		local format = string.format("$KEY;ingame_menu__%s:", var_20_13)

		var_20_7 = TextToUpper(Localize("hotkey_reminder")) .. format
	end

	if not GameSettingsDevelopment.disabled_interactions[var_20_10] then
		var_20_2 = "Currently Disabled"
	end

	return var_20_2, var_20_3, var_20_4, var_20_9, var_20_6, var_20_5, var_20_7
end

InteractionUI._get_wielded_interaction_text = function (self, arg_21_1)
	-- function 21
	local _get_wielded_item_data = self:_get_wielded_item_data(arg_21_1)

	if not _get_wielded_item_data then
		return
	end

	local var_21_1
	local var_21_2
	local var_21_3
	local var_21_4
	local var_21_5
	local num = 0
	local var_21_7
	local var_21_8
	local extension = ScriptUnit.extension(arg_21_1, "interactor_system")
	local is_interacting, var_21_11 = extension:is_interacting()
	local get_item_template = BackendUtils.get_item_template(_get_wielded_item_data)

	for k, v in pairs(get_item_template.actions) do
		for k_2, v_2 in pairs(v) do
			local interaction_priority = v_2.interaction_priority

			interaction_priority = interaction_priority or -1000

			if not (v_2.interaction_type == nil or not (num < interaction_priority)) then
				local show_interaction_ui = v_2.show_interaction_ui

				show_interaction_ui = not show_interaction_ui and v_2.show_interaction_ui(arg_21_1)

				if not ((show_interaction_ui or v_2.condition_func(arg_21_1) or not is_interacting) and v_2.interaction_type ~= var_21_11) then
					local var_21_15 = self
					local button_texture_data_by_input_action = self.button_texture_data_by_input_action
					local hold_input = v_2.hold_input

					hold_input = hold_input or k

					if not button_texture_data_by_input_action(var_21_15, hold_input) then
						num = v_2.interaction_priority
						var_21_7 = k
						var_21_8 = k_2
					end
				end
			end
		end
	end

	if not var_21_7 then
		local var_21_18 = get_item_template.actions[var_21_7][var_21_8]
		local interaction_type = var_21_18.interaction_type
		local var_21_20 = InteractionDefinitions[interaction_type]
		local interactable_unit = extension:interactable_unit()
		local data = extension.interaction_context.data

		if not Unit.alive(interactable_unit) then
			if not var_21_20.client.can_interact(arg_21_1, interactable_unit, data, var_21_20.config, self.world) then
				var_21_1, var_21_2, var_21_4, var_21_5 = var_21_20.client.hud_description(interactable_unit, data, var_21_20.config, nil, arg_21_1)
			else
				var_21_1, var_21_2, var_21_4, var_21_5 = var_21_20.client.hud_description(nil, data, var_21_20.config, nil, arg_21_1)
			end
		else
			var_21_1, var_21_2, var_21_4, var_21_5 = var_21_20.client.hud_description(nil, data, var_21_20.config, nil, arg_21_1)
		end

		var_21_3 = var_21_18.hold_input or var_21_7
	end

	return var_21_1, var_21_2, var_21_3, var_21_4, var_21_5
end

InteractionUI._get_wielded_item_data = function (arg_22_0, arg_22_1)
	-- function 22
	return ScriptUnit.extension(arg_22_1, "inventory_system"):equipment().wielded
end

InteractionUI._assign_button_info = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local style = self.interaction_widget.style
	local content = self.interaction_widget.content
	local num = 0
	local num_2 = 0
	local text_color = style.text.text_color
	local var_23_7

	if not (not arg_23_1 and arg_23_2 or arg_23_3) then
		local button_texture_data_by_input_action, var_23_9 = self:button_texture_data_by_input_action(arg_23_1)

		if not button_texture_data_by_input_action and not button_texture_data_by_input_action.texture then
			content.button_text = ""
			content.icon_textures[1] = button_texture_data_by_input_action.texture

			local tbl_2 = {
				button_texture_data_by_input_action.size[1] / button_texture_data_by_input_action.size[2] * button_texture_data_by_input_action.size[1],
				button_texture_data_by_input_action.size[1]
			}

			style.icon_styles.texture_sizes[1] = tbl_2
			style.icon_styles.draw_count = 1
			num = button_texture_data_by_input_action.size[1]
			num_2 = button_texture_data_by_input_action.size[2]
		else
			local str = "[" .. TextToUpper(var_23_9) .. "]"
			local button_text = style.button_text
			local var_23_13, var_23_14 = UIFontByResolution(button_text)
			local text_size, var_23_16, var_23_17 = UIRenderer.text_size(ui_renderer, str, var_23_13[1], var_23_14)

			num = text_size
			num_2 = -8
			content.button_text = str
			style.icon_styles.draw_count = 0
		end

		ui_scenegraph.text_pivot.local_position[1] = tbl.text_pivot.position[1] + num
		ui_scenegraph.tooltip_icon.size[1] = num
		ui_scenegraph.tooltip_icon.size[2] = num_2
		var_23_7 = style.text.default_text_color
	else
		style.icon_styles.draw_count = 0
		content.button_text = ""
		ui_scenegraph.tooltip_icon.size[1] = 0
		ui_scenegraph.text_pivot.local_position[1] = tbl.text_pivot.position[1]

		if not arg_23_2 then
			var_23_7 = style.text.disabled_text_color
		elseif not arg_23_3 then
			var_23_7 = style.text.disabled_text_color
		else
			var_23_7 = style.text.default_text_color
		end
	end

	if not arg_23_4 then
		var_23_7 = arg_23_4
	end

	text_color[2] = var_23_7[2]
	text_color[3] = var_23_7[3]
	text_color[4] = var_23_7[4]
end

InteractionUI.external_interact_ui_description = function (arg_24_0, arg_24_1)
	-- function 24
	local extension = ScriptUnit.extension(arg_24_1, "overcharge_system")

	if not (not extension:is_above_critical_limit() and extension:are_you_exploding()) then
		return "interaction_overheat", "interaction_action_vent", "weapon_reload"
	end
end
