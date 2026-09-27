-- chunkname: @scripts/ui/hud_ui/versus_tab_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	620,
	160
}
local tbl_2 = {}
local tbl_3 = {
	position = {
		0,
		0,
		UILayer.hud
	},
	size = {
		num,
		num_2
	}
}
local flag

flag = IS_WINDOWS or not "hud_fit" or "fit"
tbl_3.scale = flag
tbl_2.screen = tbl_3
tbl_2.level_name = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		400,
		60
	},
	position = {
		0,
		-200,
		10
	}
}
tbl_2.title_divider = {
	vertical_alignment = "center",
	parent = "level_name",
	horizontal_alignment = "center",
	size = {
		264,
		21
	},
	position = {
		0,
		-40,
		0
	}
}
tbl_2.sub_title = {
	vertical_alignment = "center",
	parent = "title_divider",
	horizontal_alignment = "center",
	size = {
		1600,
		60
	},
	position = {
		0,
		-40,
		0
	}
}
tbl_2.privacy_text = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "right",
	size = {
		1900,
		30
	},
	position = {
		-10,
		-10,
		10
	}
}
tbl_2.player_list_input_description = {
	vertical_alignment = "bottom",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		1900,
		60
	},
	position = {
		0,
		60,
		10
	}
}
tbl_2.vs_text = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		500,
		50
	},
	position = {
		0,
		0,
		10
	}
}
tbl_2.talent_tooltip = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		400,
		0
	},
	position = {
		0,
		0,
		20
	}
}
tbl_2.item_tooltip = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		400,
		0
	},
	position = {
		0,
		0,
		20
	}
}
tbl_2.objective = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		544,
		55
	},
	position = {
		0,
		-4,
		2
	}
}
tbl_2.score = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		302.4,
		117.6
	},
	position = {
		0,
		-60,
		10
	}
}
tbl_2.console_cursor = {
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
		-10
	}
}
tbl_2.team_1 = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		20,
		210,
		10
	}
}
tbl_2.team_1_icon = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		232,
		196
	},
	position = {
		-320,
		0,
		20
	}
}
tbl_2.team_1_name = {
	vertical_alignment = "top",
	parent = "team_1",
	horizontal_alignment = "left",
	size = {
		500,
		50
	},
	position = {
		28,
		105,
		3
	}
}
tbl_2.team_1_text = {
	vertical_alignment = "top",
	parent = "team_1",
	horizontal_alignment = "left",
	size = {
		500,
		40
	},
	position = {
		28,
		160,
		3
	}
}
tbl_2.team_1_side_text = {
	vertical_alignment = "top",
	parent = "team_1",
	horizontal_alignment = "left",
	size = {
		500,
		40
	},
	position = {
		28,
		40,
		3
	}
}
tbl_2.team_1_score = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		200,
		120
	},
	position = {
		-320,
		-60,
		3
	}
}
tbl_2.team_1_player_panel_1 = {
	vertical_alignment = "top",
	parent = "team_1",
	horizontal_alignment = "left",
	size = tbl,
	position = {
		0,
		0,
		10
	}
}
tbl_2.team_1_player_panel_2 = {
	vertical_alignment = "top",
	parent = "team_1",
	horizontal_alignment = "left",
	size = tbl,
	position = {
		0,
		-170,
		10
	}
}
tbl_2.team_1_player_panel_3 = {
	vertical_alignment = "top",
	parent = "team_1",
	horizontal_alignment = "left",
	size = tbl,
	position = {
		0,
		-340,
		10
	}
}
tbl_2.team_1_player_panel_4 = {
	vertical_alignment = "top",
	parent = "team_1",
	horizontal_alignment = "left",
	size = tbl,
	position = {
		0,
		-510,
		10
	}
}
tbl_2.team_1_player_frame_1 = {
	vertical_alignment = "bottom",
	parent = "team_1_player_panel_1",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		128,
		69,
		3
	}
}
tbl_2.team_1_player_frame_2 = {
	vertical_alignment = "bottom",
	parent = "team_1_player_panel_2",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		128,
		69,
		3
	}
}
tbl_2.team_1_player_frame_3 = {
	vertical_alignment = "bottom",
	parent = "team_1_player_panel_3",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		128,
		69,
		3
	}
}
tbl_2.team_1_player_frame_4 = {
	vertical_alignment = "bottom",
	parent = "team_1_player_panel_4",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		128,
		69,
		3
	}
}
tbl_2.team_1_player_insignia_1 = {
	vertical_alignment = "bottom",
	parent = "team_1_player_panel_1",
	horizontal_alignment = "left",
	position = {
		-275,
		0,
		3
	}
}
tbl_2.team_1_player_insignia_2 = {
	vertical_alignment = "bottom",
	parent = "team_1_player_panel_2",
	horizontal_alignment = "left",
	position = {
		-275,
		0,
		3
	}
}
tbl_2.team_1_player_insignia_3 = {
	vertical_alignment = "bottom",
	parent = "team_1_player_panel_3",
	horizontal_alignment = "left",
	position = {
		-275,
		0,
		3
	}
}
tbl_2.team_1_player_insignia_4 = {
	vertical_alignment = "bottom",
	parent = "team_1_player_panel_4",
	horizontal_alignment = "left",
	position = {
		-275,
		0,
		3
	}
}
tbl_2.team_1_player_ready_1 = {
	vertical_alignment = "center",
	parent = "team_1_player_panel_1",
	horizontal_alignment = "left",
	size = {
		50,
		55
	},
	position = {
		-80,
		0,
		1
	}
}
tbl_2.team_1_player_ready_2 = {
	vertical_alignment = "center",
	parent = "team_1_player_panel_2",
	horizontal_alignment = "left",
	size = {
		50,
		55
	},
	position = {
		-80,
		0,
		1
	}
}
tbl_2.team_1_player_ready_3 = {
	vertical_alignment = "center",
	parent = "team_1_player_panel_3",
	horizontal_alignment = "left",
	size = {
		50,
		55
	},
	position = {
		-80,
		0,
		1
	}
}
tbl_2.team_1_player_ready_4 = {
	vertical_alignment = "center",
	parent = "team_1_player_panel_4",
	horizontal_alignment = "left",
	size = {
		50,
		55
	},
	position = {
		-80,
		0,
		1
	}
}
tbl_2.team_2 = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "right",
	size = {
		0,
		0
	},
	position = {
		-20,
		210,
		10
	}
}
tbl_2.team_2_icon = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		232,
		196
	},
	position = {
		320,
		0,
		20
	}
}
tbl_2.team_2_name = {
	vertical_alignment = "top",
	parent = "team_2",
	horizontal_alignment = "right",
	size = {
		500,
		50
	},
	position = {
		-28,
		105,
		3
	}
}
tbl_2.team_2_text = {
	vertical_alignment = "top",
	parent = "team_2",
	horizontal_alignment = "right",
	size = {
		500,
		40
	},
	position = {
		-28,
		160,
		3
	}
}
tbl_2.team_2_side_text = {
	vertical_alignment = "top",
	parent = "team_2",
	horizontal_alignment = "right",
	size = {
		500,
		40
	},
	position = {
		-28,
		40,
		3
	}
}
tbl_2.team_2_score = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		200,
		120
	},
	position = {
		320,
		-60,
		3
	}
}
tbl_2.team_2_player_panel_1 = {
	vertical_alignment = "top",
	parent = "team_2",
	horizontal_alignment = "right",
	size = tbl,
	position = {
		0,
		0,
		10
	}
}
tbl_2.team_2_player_panel_2 = {
	vertical_alignment = "top",
	parent = "team_2",
	horizontal_alignment = "right",
	size = tbl,
	position = {
		0,
		-170,
		10
	}
}
tbl_2.team_2_player_panel_3 = {
	vertical_alignment = "top",
	parent = "team_2",
	horizontal_alignment = "right",
	size = tbl,
	position = {
		0,
		-340,
		10
	}
}
tbl_2.team_2_player_panel_4 = {
	vertical_alignment = "top",
	parent = "team_2",
	horizontal_alignment = "right",
	size = tbl,
	position = {
		0,
		-510,
		10
	}
}
tbl_2.team_2_player_frame_1 = {
	vertical_alignment = "bottom",
	parent = "team_2_player_panel_1",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		128,
		69,
		3
	}
}
tbl_2.team_2_player_frame_2 = {
	vertical_alignment = "bottom",
	parent = "team_2_player_panel_2",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		128,
		69,
		3
	}
}
tbl_2.team_2_player_frame_3 = {
	vertical_alignment = "bottom",
	parent = "team_2_player_panel_3",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		128,
		69,
		3
	}
}
tbl_2.team_2_player_frame_4 = {
	vertical_alignment = "bottom",
	parent = "team_2_player_panel_4",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		128,
		69,
		3
	}
}
tbl_2.team_2_player_insignia_1 = {
	vertical_alignment = "bottom",
	parent = "team_2_player_panel_1",
	horizontal_alignment = "left",
	position = {
		-275,
		0,
		3
	}
}
tbl_2.team_2_player_insignia_2 = {
	vertical_alignment = "bottom",
	parent = "team_2_player_panel_2",
	horizontal_alignment = "left",
	position = {
		-275,
		0,
		3
	}
}
tbl_2.team_2_player_insignia_3 = {
	vertical_alignment = "bottom",
	parent = "team_2_player_panel_3",
	horizontal_alignment = "left",
	position = {
		-275,
		0,
		3
	}
}
tbl_2.team_2_player_insignia_4 = {
	vertical_alignment = "bottom",
	parent = "team_2_player_panel_4",
	horizontal_alignment = "left",
	position = {
		-275,
		0,
		3
	}
}
tbl_2.team_2_player_ready_1 = {
	vertical_alignment = "center",
	parent = "team_2_player_panel_1",
	horizontal_alignment = "right",
	size = {
		50,
		55
	},
	position = {
		80,
		0,
		1
	}
}
tbl_2.team_2_player_ready_2 = {
	vertical_alignment = "center",
	parent = "team_2_player_panel_2",
	horizontal_alignment = "right",
	size = {
		50,
		55
	},
	position = {
		80,
		0,
		1
	}
}
tbl_2.team_2_player_ready_3 = {
	vertical_alignment = "center",
	parent = "team_2_player_panel_3",
	horizontal_alignment = "right",
	size = {
		50,
		55
	},
	position = {
		80,
		0,
		1
	}
}
tbl_2.team_2_player_ready_4 = {
	vertical_alignment = "center",
	parent = "team_2_player_panel_4",
	horizontal_alignment = "right",
	size = {
		50,
		55
	},
	position = {
		80,
		0,
		1
	}
}
tbl_2.settings_container = {
	vertical_alignment = "center",
	parent = "screen",
	horizontal_alignment = "center",
	size = {
		480,
		560
	},
	position = {
		0,
		-140,
		10
	}
}
tbl_2.settings_anchor = {
	vertical_alignment = "top",
	parent = "settings_container",
	horizontal_alignment = "left",
	size = {
		0,
		0
	},
	position = {
		0,
		-10,
		100
	}
}
tbl_2.custom_ruleset_text = {
	vertical_alignment = "top",
	parent = "settings_container",
	horizontal_alignment = "center",
	size = {
		480,
		30
	},
	position = {
		0,
		40,
		1
	}
}

local tbl_4 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 50,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 36,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_6 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	font_size = 98,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("local_player_team_lighter", 255),
	offset = {
		0,
		0,
		0
	}
}
local clone = table.clone(tbl_6)

clone.horizontal_alignment = "right"
clone.text_color = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

local tbl_7 = {
	font_size = 24,
	upper_case = true,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_table("white"),
	offset = {
		0,
		0,
		1
	}
}
local tbl_8 = {
	word_wrap = true,
	font_size = 82,
	localize = false,
	vertical_alignment = "center",
	horizontal_alignment = "center",
	use_shadow = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_9 = {
	word_wrap = true,
	font_size = 32,
	localize = false,
	vertical_alignment = "center",
	horizontal_alignment = "left",
	use_shadow = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("local_player_picking", 255),
	offset = {
		0,
		0,
		2
	}
}
local clone_2 = table.clone(tbl_9)

clone_2.horizontal_alignment = "right"
clone_2.text_color = Colors.get_color_table_with_alpha("opponent_team", 255)

local tbl_10 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	font_size = 38,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local clone_3 = table.clone(tbl_10)

clone_3.horizontal_alignment = "right"

local function fn(arg_1_0)
	-- function 1
	local str = "shadow_frame_02"
	local var_1_1 = UIFrameSettings[str]
	local str_2 = "frame_outer_glow_04"
	local var_1_3 = UIFrameSettings[str_2]
	local str_3 = "frame_outer_glow_01"
	local var_1_5 = UIFrameSettings[str_3]
	local str_4 = "frame_bevel_01"
	local var_1_7 = UIFrameSettings[str_4]

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "texture_frame",
					style_id = "shadow_frame",
					texture_id = "shadow_frame",
					content_check_function = function (self)
						-- function 2
						return self.empty
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame",
					content_check_function = function (self)
						-- function 3
						return not not self.empty or self.hotspot.is_hover
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "empty_hover",
					texture_id = "empty_hover",
					content_check_function = function (self)
						-- function 4
						local empty = self.empty

						empty = not empty and self.hotspot.is_hover

						return empty
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "empty_frame",
					texture_id = "empty_frame",
					content_check_function = function (self)
						-- function 5
						return self.empty
					end
				}
			}
		},
		content = {
			empty = false,
			hotspot = {
				allow_multi_hover = true
			},
			shadow_frame = var_1_1.texture,
			hover_frame = var_1_3.texture,
			empty_hover = var_1_5.texture,
			empty_frame = var_1_7.texture
		},
		style = {
			empty_frame = {
				texture_size = var_1_7.texture_size,
				texture_sizes = var_1_7.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				}
			},
			shadow_frame = {
				frame_margins = {
					-14,
					-14
				},
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
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
			hover_frame = {
				frame_margins = {
					-14,
					-14
				},
				texture_size = var_1_3.texture_size,
				texture_sizes = var_1_3.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				}
			},
			empty_hover = {
				frame_margins = {
					-14,
					-14
				},
				texture_size = var_1_5.texture_size,
				texture_sizes = var_1_5.texture_sizes,
				color = {
					255,
					151,
					151,
					151
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_2(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	-- function 6
	local values = arg_6_1.values

	values = values or {}

	local count = #values

	count = count or 0

	local str = "menu_settings_" .. arg_6_1.setting_name
	local str_2 = "tooltip_" .. arg_6_1.setting_name

	local function fn(self, arg_7_1, arg_7_2)
		-- function 7
		local parent = self.parent
		local hover_progress = self.hover_progress

		hover_progress = hover_progress or 0

		local num = 15

		if not self.is_hover then
			hover_progress = math.min(hover_progress + arg_7_2 * num, 1)
		else
			hover_progress = math.max(hover_progress - arg_7_2 * num, 0)
		end

		self.hover_progress = hover_progress

		local press_progress = self.press_progress

		press_progress = press_progress or 1

		local num_2 = 25

		if not self.is_held then
			press_progress = math.max(press_progress - arg_7_2 * num_2, 0.5)
		else
			press_progress = math.min(press_progress + arg_7_2 * num_2, 1)
		end

		self.press_progress = press_progress
	end

	local function fn_2(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		-- function 8
		local hover_progress = arg_8_2.hover_progress

		hover_progress = hover_progress or 0

		local press_progress = arg_8_2.press_progress

		press_progress = press_progress or 1
		arg_8_1.color[1] = 255 * hover_progress

		if not arg_8_2.is_hover then
			arg_8_1.color[1] = 255 * press_progress
		end
	end

	return {
		element = {
			passes = {
				{
					style_id = "setting_name",
					pass_type = "text",
					text_id = "setting_name"
				},
				{
					pass_type = "texture",
					style_id = "setting_value_bg",
					texture_id = "setting_value_bg"
				},
				{
					style_id = "setting_value",
					pass_type = "text",
					text_id = "setting_value",
					content_change_function = function (self, arg_9_1, arg_9_2, arg_9_3)
						-- function 9
						local values = self.data.values
						local ui_data = self.ui_data
						local var_9_2 = values[self.setting_idx]

						if self.value ~= var_9_2 then
							self.value = var_9_2

							local flag = not ui_data and ui_data.localization_options
							local str = ""

							if not flag and not flag[var_9_2] then
								local var_9_5 = flag[var_9_2]

								str = Localize(var_9_5)
							elseif not ((type(self.value) ~= "number" or not ui_data) and ui_data.setting_type ~= "multiplier") then
								str = string.format("%.2f", self.value)
							else
								str = string.format("%s", self.value)
							end

							if (not flag and flag[var_9_2] or not ui_data) and not ui_data.setting_type then
								local carousel = DLCSettings.carousel

								carousel = not carousel and DLCSettings.carousel.custom_game_settigns_values_suffix

								if not ui_data and not carousel and not carousel[ui_data.setting_type] then
									str = str .. carousel[ui_data.setting_type]
								end
							end

							self.setting_value = str
						end

						if self.value ~= self.default_value then
							arg_9_1.text_color = arg_9_1.modified_color
						else
							arg_9_1.text_color = arg_9_1.default_color
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "divider",
					texture_id = "divider"
				},
				{
					style_id = "setting_highlight_hotspot",
					pass_type = "hotspot",
					content_id = "setting_highlight_hotspot",
					content_change_function = function (self, arg_10_1, arg_10_2, arg_10_3)
						-- function 10
						local hover_progress = self.hover_progress

						hover_progress = hover_progress or 0

						local num = 15

						if self.is_hover or not self.parent.is_gamepad_active or not self.parent.focused or not self.parent.is_selected then
							hover_progress = math.min(hover_progress + arg_10_3 * num, 1)
						else
							hover_progress = math.max(hover_progress - arg_10_3 * num, 0)
						end

						self.hover_progress = hover_progress
					end
				},
				{
					style_id = "setting_highlight",
					texture_id = "setting_highlight",
					pass_type = "texture",
					content_change_function = function (self, arg_11_1, arg_11_2, arg_11_3)
						-- function 11
						local hover_progress = self.setting_highlight_hotspot.hover_progress

						hover_progress = hover_progress or 0
						arg_11_1.color[1] = 255 * hover_progress
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function (self, arg_12_1)
						-- function 12
						return self.setting_highlight_hotspot.is_hover
					end
				}
			}
		},
		content = {
			default_idx = 1,
			setting_highlight = "party_selection_glow",
			default_value = 0,
			setting_value_bg = "rect_masked",
			divider = "rect_masked",
			data = arg_6_1,
			ui_data = arg_6_2,
			id = arg_6_5,
			name = arg_6_1.setting_name,
			on_setting_changed_cb = arg_6_6,
			settings = values,
			num_settings = count,
			setting_idx = arg_6_4,
			setting_value = tostring(arg_6_3),
			setting_name = str,
			setting_highlight_hotspot = {
				allow_multi_hover = true
			},
			tooltip_text = str_2
		},
		style = {
			setting_name = {
				upper_case = false,
				localize = true,
				vertical_alignment = "center",
				font_size = 20,
				horizontal_alignment = "left",
				use_shadow = true,
				masked = true,
				font_type = "hell_shark_masked",
				size = {
					380,
					30
				},
				area_size = {
					380,
					30
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					3
				}
			},
			setting_value_bg = {
				masked = true,
				size = {
					128,
					30
				},
				offset = {
					320,
					0,
					4
				},
				color = Colors.get_color_table_with_alpha("black", 120)
			},
			setting_value = {
				masked = true,
				upper_case = false,
				localize = false,
				font_type = "hell_shark_masked",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					128,
					30
				},
				area_size = {
					128,
					30
				},
				modified_color = Colors.get_color_table_with_alpha("pale_golden_rod", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 180),
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					320,
					0,
					5
				}
			},
			divider = {
				masked = true,
				size = {
					440,
					2
				},
				offset = {
					0,
					-2,
					1
				},
				color = Colors.get_color_table_with_alpha("gray", 100)
			},
			setting_highlight_hotspot = {
				size = {
					440,
					34
				},
				offset = {
					0,
					0,
					1
				}
			},
			setting_highlight = {
				masked = true,
				texture_size = {
					440,
					34
				},
				offset = {
					0,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			tooltip_text = {
				font_type = "hell_shark_masked",
				upper_case = false,
				localize = true,
				use_shadow = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					180,
					30
				},
				area_size = {
					180,
					30
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			1
		},
		scenegraph_id = arg_6_0
	}
end

local tbl_11 = {
	level_name = UIWidgets.create_simple_text("level_name", "level_name", nil, nil, tbl_4),
	sub_title = UIWidgets.create_simple_text("sub_title", "sub_title", nil, nil, tbl_5),
	background = UIWidgets.create_simple_rect("screen", {
		176,
		0,
		0,
		0
	}),
	title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider"),
	objective_text = UIWidgets.create_mission_objective_text_widget_still("objective"),
	score = UIWidgets.create_objective_score_widget("score", tbl_2.score.size),
	team_1_name = UIWidgets.create_simple_text("", "team_1_name", nil, nil, tbl_6),
	team_1_icon = UIWidgets.create_simple_texture("banner_hammers_local", "team_1_icon"),
	team_1_text = UIWidgets.create_simple_text(Localize("vs_lobby_your_team"), "team_1_text", nil, nil, tbl_9),
	team_1_side_text = UIWidgets.create_simple_text("", "team_1_side_text", nil, nil, tbl_10),
	team_2_name = UIWidgets.create_simple_text("", "team_2_name", nil, nil, clone),
	team_2_icon = UIWidgets.create_simple_texture("banner_skulls_opponent", "team_2_icon"),
	team_2_text = UIWidgets.create_simple_text(Localize("vs_lobby_enemy_team"), "team_2_text", nil, nil, clone_2),
	team_2_side_text = UIWidgets.create_simple_text("", "team_2_side_text", nil, nil, clone_3),
	input_description_text = UIWidgets.create_simple_text("player_list_show_mouse_description", "player_list_input_description", nil, nil, tbl_7)
}
local tbl_12 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_13 = {
	settings_background = UIWidgets.create_rect_with_outer_frame("settings_container", tbl_2.settings_container.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color, Colors.get_color_table_with_alpha("font_default", 125)),
	settings_mask = UIWidgets.create_simple_texture("mask_rect", "settings_container"),
	custom_ruleset_text = UIWidgets.create_simple_text(Localize("versus_custom_game_custom_ruleset"), "custom_ruleset_text", nil, nil, tbl_12)
}
local tbl_14 = {
	on_enter = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				arg_13_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local easeCubic = math.easeCubic(arg_14_3)

				arg_14_4.render_settings.alpha_multiplier = easeCubic
				arg_14_0.team_1.position[1] = arg_14_1.team_1.position[1] - (1 - easeCubic) * 100
				arg_14_0.team_2.position[1] = arg_14_1.team_2.position[1] + (1 - easeCubic) * 100
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		}
	}
}

return {
	create_empty_frame_widget = fn,
	animation_definitions = tbl_14,
	scenegraph_definition = tbl_2,
	widget_definitions = tbl_11,
	custom_game_settings_widgets = tbl_13,
	create_settings_widget = fn_2,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", UISettings.console_tooltip_pass_definitions)
}
