-- chunkname: @scripts/ui/views/menu_input_description_ui.lua

local tbl = {
	screen = {
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
			UILayer.controller_description
		}
	},
	input_description_field = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			1800,
			70
		}
	},
	background = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center"
	},
	fullscreen_background = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			79
		},
		position = {
			0,
			0,
			UILayer.default + 1
		}
	}
}

if not IS_WINDOWS then
	tbl.screen.scale = "hud_fit"
end

local function fn(self, arg_1_1)
	-- function 1
	return self.priority < arg_1_1.priority
end

local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name("tab_menu_bg_02")

local function fn_2(arg_2_0)
	-- function 2
	return {
		scenegraph_id = "background",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background_id"
				}
			}
		},
		content = {
			background_id = "tab_menu_bg_02"
		},
		style = {
			background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					get_atlas_settings_by_texture_name.size[1] * arg_2_0,
					get_atlas_settings_by_texture_name.size[2] * 1.2
				}
			}
		}
	}
end

local function fn_3()
	-- function 3
	return UIWidgets.create_simple_uv_texture("menu_panel_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "fullscreen_background", nil, nil, {
		200,
		10,
		10,
		10
	})
end

local function fn_4(arg_4_0)
	-- function 4
	local tbl_2 = {}

	for i = 1, arg_4_0 do
		local str = "input_description_root_" .. i
		local str_2 = "input_description_" .. i
		local str_3 = "input_description_icon_" .. i
		local str_4 = "input_description_text_" .. i

		tbl[str] = {
			vertical_alignment = "center",
			parent = "input_description_field",
			horizontal_alignment = "left",
			size = {
				1,
				1
			},
			position = {
				0,
				0,
				1
			}
		}
		tbl[str_2] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str,
			size = {
				200,
				40
			},
			position = {
				0,
				0,
				1
			}
		}
		tbl[str_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str_2,
			size = {
				40,
				40
			},
			position = {
				0,
				0,
				1
			}
		}
		tbl[str_4] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str_3,
			size = {
				500,
				40
			},
			position = {
				40,
				1,
				1
			}
		}

		local tbl_3 = {
			element = {
				passes = {
					{
						style_id = "text",
						pass_type = "text",
						text_id = "text"
					},
					{
						style_id = "text_shadow",
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
				icon = "xbone_button_icon_a"
			},
			style = {
				text = {
					font_size = 24,
					word_wrap = true,
					pixel_perfect = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", 255),
					offset = {
						0,
						0,
						2
					},
					scenegraph_id = str_4
				},
				text_shadow = {
					font_size = 24,
					word_wrap = true,
					pixel_perfect = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("black", 255),
					offset = {
						2,
						-2,
						1
					},
					scenegraph_id = str_4
				},
				icon = {
					scenegraph_id = str_3
				}
			},
			scenegraph_id = str_2
		}

		tbl_2[#tbl_2 + 1] = UIWidget.init(tbl_3)
	end

	return tbl_2
end

MenuInputDescriptionUI = class(MenuInputDescriptionUI)

MenuInputDescriptionUI.init = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	-- function 5
	self:clear_input_descriptions()

	self.input_service = arg_5_3
	self.ui_renderer = arg_5_2
	self.generic_actions = arg_5_6
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._max_width = arg_5_8 or math.huge
	self._use_fullscreen_layout = arg_5_7

	local position = tbl.screen.position
	local num

	if not arg_5_5 then
		num = arg_5_5 + 10

		if not num then
			-- Nothing
		end
	end

	num = UILayer.controller_description

	::label_5_0::

	position[3] = num

	self:create_ui_elements(arg_5_2, arg_5_4, arg_5_7)
end

MenuInputDescriptionUI.create_ui_elements = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	self.console_input_description_widgets = fn_4(arg_6_2 or 5)

	if not arg_6_3 then
		self.background_widget = nil
	else
		self.background_widget = UIWidget.init(fn_2(arg_6_2 or 3))
	end

	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)

	UIRenderer.clear_scenegraph_queue(arg_6_1)
end

MenuInputDescriptionUI._verify_input = function (self)
	-- function 7
	if Managers.input:get_most_recent_device() ~= self._most_recent_device then
		self:set_input_description(self.current_console_selection_data)
	end
end

MenuInputDescriptionUI.draw = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:_verify_input()

	local ui_scenegraph = self.ui_scenegraph
	local input_service = self.input_service
	local ui_renderer = self.ui_renderer

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, arg_8_2, nil, self.render_settings)

	local number_of_descriptions_in_use = self.number_of_descriptions_in_use
	local console_input_description_widgets = self.console_input_description_widgets

	if not number_of_descriptions_in_use then
		for i = 1, number_of_descriptions_in_use do
			UIRenderer.draw_widget(ui_renderer, console_input_description_widgets[i])
		end

		if not self.background_widget then
			UIRenderer.draw_widget(ui_renderer, self.background_widget)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

MenuInputDescriptionUI.destroy = function (arg_9_0)
	-- function 9
	return
end

MenuInputDescriptionUI.change_generic_actions = function (self, arg_10_1)
	-- function 10
	self.generic_actions = arg_10_1

	self:set_input_description(self.current_console_selection_data)
end

MenuInputDescriptionUI.setup_console_widget_selections = function (self)
	-- function 11
	local steppers = self.steppers

	return {
		{
			name = "difficulty",
			gamepad_support = true,
			widget = steppers.difficulty.widget,
			actions = {
				{
					hotspot_id = "left_button_hotspot",
					input_action = "move_left",
					description_text = "input_description_previous"
				},
				{
					hotspot_id = "right_button_hotspot",
					input_action = "move_right",
					description_text = "input_description_next"
				}
			}
		},
		{
			name = "privacy",
			gamepad_support = true,
			widget = steppers.privacy.widget,
			actions = {
				{
					hotspot_id = "left_button_hotspot",
					input_action = "move_left",
					description_text = "input_description_previous"
				},
				{
					hotspot_id = "right_button_hotspot",
					input_action = "move_right",
					description_text = "input_description_next"
				}
			}
		},
		{
			name = "level",
			gamepad_support = true,
			widget = steppers.level.widget,
			actions = {
				{
					hotspot_id = "left_button_hotspot",
					input_action = "move_left",
					description_text = "input_description_previous"
				},
				{
					hotspot_id = "right_button_hotspot",
					input_action = "move_right",
					description_text = "input_description_next"
				}
			}
		},
		{
			name = "play_button",
			gamepad_support = false,
			widget = self.play_button_console_widget,
			actions = {
				{
					hotspot_id = "button_hotspot",
					input_action = "confirm",
					description_text = "input_description_confirm"
				}
			}
		},
		{
			name = "quickmatch_button",
			gamepad_support = false,
			widget = self.quickmatch_button_console_widget,
			actions = {
				{
					hotspot_id = "button_hotspot",
					input_action = "confirm",
					description_text = "input_description_confirm"
				}
			}
		}
	}
end

MenuInputDescriptionUI.set_input_description = function (self, arg_12_1, arg_12_2)
	-- function 12
	self:clear_input_descriptions()

	local flag = arg_12_2 or 1
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local console_input_description_widgets = self.console_input_description_widgets
	local num = 30 * flag
	local tbl = {}
	local num_2 = 0
	local num_3 = 0

	self.current_console_selection_data = arg_12_1

	local clone

	if not arg_12_1 and not arg_12_1.actions then
		clone = table.clone(arg_12_1.actions)

		if not clone then
			-- Nothing
		end
	end

	clone = {}

	::label_12_0::

	local flag_2 = not arg_12_1 and arg_12_1.ignore_generic_actions
	local tbl_2 = {}

	if not flag_2 then
		local generic_actions = self.generic_actions

		if not generic_actions then
			for i, v in ipairs(generic_actions) do
				if not v.content_check_function and not v.content_check_function() then
					tbl_2[#tbl_2 + 1] = v
				end
			end
		end
	end

	for k, v_2 in pairs(clone) do
		if not v_2.content_check_function and not v_2.content_check_function() then
			tbl_2[#tbl_2 + 1] = v_2
		end
	end

	table.sort(tbl_2, fn)

	for k_2, v_3 in pairs(tbl_2) do
		local input_action = v_3.input_action
		local description_text = v_3.description_text
		local ignore_keybinding = v_3.ignore_keybinding

		if not description_text then
			num_3 = num_3 + 1
			description_text = not v_3.ignore_localization and description_text and Localize(description_text)

			local get_gamepad_input_texture_data = self:get_gamepad_input_texture_data(input_action, ignore_keybinding)
			local var_12_16 = console_input_description_widgets[num_3]
			local content = var_12_16.content
			local style = var_12_16.style
			local str = "input_description_" .. num_3
			local str_2 = "input_description_icon_" .. num_3
			local str_3 = "input_description_text_" .. num_3
			local shallow_copy = table.shallow_copy(get_gamepad_input_texture_data.size)

			shallow_copy[1] = shallow_copy[1] * flag
			shallow_copy[2] = shallow_copy[2] * flag
			ui_scenegraph[str_2].size = shallow_copy
			ui_scenegraph[str_3].local_position[1] = shallow_copy[1]
			content.icon = get_gamepad_input_texture_data.texture

			local str_4 = " " .. description_text

			content.text = str_4

			local text = style.text
			local _original_font_size = text._original_font_size

			_original_font_size = _original_font_size or text.font_size
			text._original_font_size = _original_font_size
			text.font_size = text._original_font_size * flag

			local var_12_26, var_12_27 = UIFontByResolution(text)
			local text_size = UIRenderer.text_size(ui_renderer, str_4, var_12_26[1], var_12_27)
			local num_4 = shallow_copy[1] + text_size

			if not self._use_fullscreen_layout then
				ui_scenegraph[str].local_position[1] = 0
			else
				ui_scenegraph[str].local_position[1] = -num_4 / 2
			end

			style.text_shadow.font_size = text._original_font_size * flag
			num_2 = num_2 + num_4 + num
			tbl[num_3] = num_4
		end
	end

	if not (arg_12_2 or not (num_2 > self._max_width)) then
		return self:set_input_description(arg_12_1, self._max_width / num_2)
	end

	self.number_of_descriptions_in_use = num_3 == 0 or not num_3 or nil

	self:_align_inputs(num_2, num, tbl)

	self._most_recent_device = Managers.input:get_most_recent_device()
end

MenuInputDescriptionUI.clear_input_descriptions = function (self)
	-- function 13
	self.number_of_descriptions_in_use = nil
end

MenuInputDescriptionUI.get_gamepad_input_texture_data = function (self, arg_14_1, arg_14_2)
	-- function 14
	local PLATFORM = PLATFORM

	if not IS_WINDOWS then
		PLATFORM = "xb1"
	end

	if not arg_14_2 then
		return ButtonTextureByName(arg_14_1, PLATFORM)
	else
		local input_service = self.input_service

		return UISettings.get_gamepad_input_texture_data(input_service, arg_14_1, true)
	end
end

MenuInputDescriptionUI._align_inputs = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local ui_scenegraph = self.ui_scenegraph

	arg_15_1 = arg_15_1 - arg_15_2

	local var_15_1 = ui_scenegraph.input_description_field.size[1]
	local number_of_descriptions_in_use = self.number_of_descriptions_in_use

	if not number_of_descriptions_in_use then
		if not self._use_fullscreen_layout then
			local num = 50
			local min = math.min(self._max_width, var_15_1)
			local clamp = math.clamp(min - (arg_15_1 + num * 2), 0, num)

			for i = 1, number_of_descriptions_in_use do
				local var_15_6 = arg_15_3[i]

				ui_scenegraph["input_description_root_" .. i].local_position[1] = clamp
				clamp = clamp + var_15_6 + arg_15_2
			end
		else
			local num_2 = var_15_1 / 2 - arg_15_1 / 2

			for j = 1, number_of_descriptions_in_use do
				local var_15_8 = arg_15_3[j]
				local num_3 = num_2 + var_15_8 / 2

				ui_scenegraph["input_description_root_" .. j].local_position[1] = num_3
				num_2 = num_3 + var_15_8 / 2 + arg_15_2
			end
		end
	end
end
