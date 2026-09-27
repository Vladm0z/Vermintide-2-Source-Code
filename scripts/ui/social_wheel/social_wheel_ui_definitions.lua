-- chunkname: @scripts/ui/social_wheel/social_wheel_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	root_screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	pivot_console = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			110,
			0
		}
	},
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	social_event_text = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			100,
			0
		}
	},
	icon = {
		vertical_alignment = "bottom",
		parent = "root_screen",
		horizontal_alignment = "left",
		size = {
			128,
			128
		},
		position = {
			0,
			0,
			0
		}
	},
	next_page_input = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			300,
			50
		},
		position = {
			450,
			300,
			0
		}
	}
}

if not IS_WINDOWS then
	tbl.screen.scale = "hud_fit"
end

local function fn(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local size = arg_1_2.size
	local var_1_1 = Vector3(math.cos(arg_1_1), math.sin(arg_1_1), 0)
	local count

	if not arg_1_4 then
		count = #arg_1_2[arg_1_4]

		if not count then
			-- Nothing
		end
	end

	count = #arg_1_2

	::label_1_0::

	local num = arg_1_1 + 2 * math.pi * (1 / count) * 0.5
	local var_1_4 = Vector3(math.cos(num), math.sin(num), 0)
	local num_2 = 1 / count * 360 / 90 * arg_1_2.wedge_adjustment
	local num_3 = 3
	local flag = true

	if self.localize == false then
		flag = false
	end

	local num_4 = size[1] / size[2]
	local tbl = {
		element = {
			passes = {
				{
					style_id = "divider",
					pass_type = "rotated_texture",
					texture_id = "divider_id",
					content_change_function = function (self, arg_2_1)
						-- function 2
						if not self.activated then
							arg_2_1.color[1] = 0
						else
							arg_2_1.texture_size[2] = arg_2_1.base_texture_size[2] * self.size_multiplier
							arg_2_1.pivot[2] = arg_2_1.base_texture_size[2] * self.size_multiplier * 0.5
							arg_2_1.color[1] = math.clamp(255 * self.size_multiplier, 0, 255)
						end

						local settings = self.settings
						local is_valid_func = settings.is_valid_func
						local var_2_2 = arg_1_3()

						if not is_valid_func and not var_2_2 then
							self.is_valid = is_valid_func(settings.data, var_2_2, self, arg_2_1)
						end
					end,
					content_check_function = function (arg_3_0, arg_3_1)
						-- function 3
						return not arg_1_2.individual_bg
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "fade",
					texture_id = "fade_texture_id",
					content_check_function = function (self, arg_4_1)
						-- function 4
						local selected = self.selected

						if not selected then
							selected = self.is_valid
							selected = not selected and not arg_1_2.individual_bg
						end

						return selected
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_bg",
					texture_id = "icon_bg_id",
					content_check_function = function (self, arg_5_1)
						-- function 5
						local individual_bg = arg_1_2.individual_bg

						individual_bg = not individual_bg and self.is_valid

						return individual_bg
					end
				},
				{
					style_id = "icon",
					texture_id = "icon_id",
					pass_type = "texture",
					content_change_function = function (self, arg_6_1)
						-- function 6
						if not self.activated then
							arg_6_1.color[2] = arg_6_1.activated_color[2]
							arg_6_1.color[3] = arg_6_1.activated_color[3]
							arg_6_1.color[4] = arg_6_1.activated_color[4]
						elseif not self.selected and not self.is_valid then
							arg_6_1.color[1] = 255
							arg_6_1.color[2] = 255
							arg_6_1.color[3] = 255
							arg_6_1.color[4] = 255
						else
							arg_6_1.color[1] = 96
							arg_6_1.color[2] = 255
							arg_6_1.color[3] = 255
							arg_6_1.color[4] = 255
						end
					end
				},
				{
					style_id = "icon_shadow",
					texture_id = "icon_id",
					pass_type = "texture",
					content_change_function = function (self, arg_7_1)
						-- function 7
						if not self.activated then
							if not self.selected and not self.is_valid then
								arg_7_1.color[1] = 255
							else
								arg_7_1.color[1] = 96
							end
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_unavailable",
					texture_id = "icon_unavailable_id",
					content_check_function = function (self, arg_8_1)
						-- function 8
						return not self.is_valid
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_glow",
					texture_id = "icon_glow_id",
					content_check_function = function (self, arg_9_1)
						-- function 9
						local selected = self.selected

						selected = not selected and not self.activated

						return selected
					end
				},
				{
					pass_type = "texture",
					style_id = "bg_top_right",
					texture_id = "fade_bg",
					content_check_function = function (arg_10_0, arg_10_1)
						-- function 10
						return not arg_1_2.individual_bg
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id",
					content_check_function = function (self, arg_11_1)
						-- function 11
						if not self.selected then
							arg_11_1.text_color = arg_11_1.selected_color
						else
							arg_11_1.text_color = arg_11_1.base_color
						end

						local IS_WINDOWS = IS_WINDOWS

						IS_WINDOWS = IS_WINDOWS or self.disable_input_text

						return IS_WINDOWS
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_id",
					content_check_function = function (self, arg_12_1)
						-- function 12
						if not self.selected then
							arg_12_1.text_color = arg_12_1.selected_color
						else
							arg_12_1.text_color = arg_12_1.base_color
						end

						local IS_WINDOWS = IS_WINDOWS

						IS_WINDOWS = IS_WINDOWS or self.disable_input_text

						return IS_WINDOWS
					end
				}
			}
		}
	}
	local tbl_2 = {
		fade_texture_id = "radial_chat_wedge",
		divider_id = "radial_chat_bg_line",
		selected = false,
		is_valid = true,
		fade_bg = "radial_chat_bg",
		icon_unavailable_id = "radial_chat_icon_unavailable",
		size_multiplier = 0,
		final_size_multiplier = 1,
		icon_bg_id = "radial_chat_icon_bg"
	}
	local icon = self.icon

	icon = icon or "radial_chat_icon_boss"
	tbl_2.icon_id = icon

	local icon_glow

	if not self.icon then
		icon_glow = self.icon_glow

		if not icon_glow then
			-- Nothing
		end

		icon_glow = self.icon .. "_glow"

		if not icon_glow then
			-- Nothing
		end
	end

	icon_glow = "radial_chat_icon_boss_glow"

	::label_1_1::

	tbl_2.icon_glow_id = icon_glow
	tbl_2.settings = self
	tbl_2.category_settings = arg_1_2
	tbl_2.text_id = self.text
	tbl_2.dir = Vector3Box(var_1_1)
	tbl_2.final_offset = size
	tbl.content = tbl_2

	local tbl_3 = {}
	local tbl_4 = {
		vertical_alignment = "center",
		horizontal_alignment = "center"
	}
	local icon_size = arg_1_2.icon_size

	icon_size = icon_size or {
		128,
		128
	}
	tbl_4.base_texture_size = icon_size

	local icon_size_2 = arg_1_2.icon_size

	icon_size_2 = icon_size_2 or {
		128,
		128
	}
	tbl_4.texture_size = icon_size_2
	tbl_4.activated_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_4.color = Colors.get_color_table_with_alpha("white", 255)
	tbl_4.offset = {
		0,
		0,
		10
	}
	tbl_3.icon = tbl_4

	local tbl_5 = {
		vertical_alignment = "center",
		horizontal_alignment = "center"
	}
	local icon_size_3 = arg_1_2.icon_size

	icon_size_3 = icon_size_3 or {
		128,
		128
	}
	tbl_5.base_texture_size = icon_size_3

	local icon_size_4 = arg_1_2.icon_size

	icon_size_4 = icon_size_4 or {
		128,
		128
	}
	tbl_5.texture_size = icon_size_4
	tbl_5.activated_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_5.color = Colors.get_color_table_with_alpha("black", 255)
	tbl_5.offset = {
		2,
		-2,
		9
	}
	tbl_3.icon_shadow = tbl_5

	local tbl_6 = {
		vertical_alignment = "center",
		horizontal_alignment = "center"
	}
	local icon_size_5 = arg_1_2.icon_size

	icon_size_5 = icon_size_5 or {
		128,
		128
	}
	tbl_6.base_texture_size = icon_size_5

	local icon_size_6 = arg_1_2.icon_size

	icon_size_6 = icon_size_6 or {
		128,
		128
	}
	tbl_6.texture_size = icon_size_6
	tbl_6.color = Colors.get_color_table_with_alpha("black", 125)
	tbl_6.offset = {
		0,
		0,
		8
	}
	tbl_3.icon_bg = tbl_6

	local tbl_7 = {
		vertical_alignment = "center",
		horizontal_alignment = "center"
	}
	local icon_size_7 = arg_1_2.icon_size

	icon_size_7 = icon_size_7 or {
		128,
		128
	}
	tbl_7.base_texture_size = icon_size_7

	local icon_size_8 = arg_1_2.icon_size

	icon_size_8 = icon_size_8 or {
		128,
		128
	}
	tbl_7.texture_size = icon_size_8
	tbl_7.color = {
		255,
		232,
		86,
		14
	}
	tbl_7.offset = {
		0,
		0,
		11
	}
	tbl_3.icon_glow = tbl_7

	local tbl_8 = {
		vertical_alignment = "center",
		horizontal_alignment = "center"
	}
	local icon_size_9 = arg_1_2.icon_size

	icon_size_9 = icon_size_9 or {
		128,
		128
	}
	tbl_8.base_texture_size = icon_size_9

	local icon_size_10 = arg_1_2.icon_size

	icon_size_10 = icon_size_10 or {
		128,
		128
	}
	tbl_8.texture_size = icon_size_10
	tbl_8.color = {
		255,
		128,
		60,
		60
	}
	tbl_8.offset = {
		0,
		0,
		12
	}
	tbl_3.icon_unavailable = tbl_8
	tbl_3.divider = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		base_texture_size = {
			4,
			250
		},
		texture_size = {
			4,
			250
		},
		pivot = {
			2,
			125
		},
		angle = 2 * math.pi - num + math.pi * 0.5,
		color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			-var_1_1[1] * size[1] + var_1_4[1] * 227,
			-var_1_1[2] * size[2] + var_1_4[2] * 227,
			1
		}
	}
	tbl_3.fade = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			389 * num_2 * num_3,
			195 * num_3
		},
		pivot = {
			389 * num_2 * 0.5 * num_3,
			97.5 * num_3
		},
		angle = 2 * math.pi - arg_1_1 + math.pi * 0.5,
		color = Colors.get_color_table_with_alpha("white", 30),
		offset = {
			-var_1_1[1] * size[1] + var_1_1[1] * 195 * 0.5 * num_3,
			-var_1_1[2] * size[2] + var_1_1[2] * 195 * 0.5 * num_3,
			10
		}
	}
	tbl_3.text = {
		word_wrap = false,
		font_size = 32,
		pixel_perfect = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font = true,
		font_type = "hell_shark_header",
		localize = flag,
		selected_color = Colors.get_color_table_with_alpha("font_title", 255),
		base_color = Colors.get_color_table_with_alpha("white", 128),
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			-80,
			2
		}
	}
	tbl_3.text_shadow = {
		word_wrap = false,
		font_size = 32,
		pixel_perfect = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font = true,
		font_type = "hell_shark_header",
		localize = flag,
		selected_color = Colors.get_color_table_with_alpha("black", 255),
		base_color = Colors.get_color_table_with_alpha("black", 128),
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			2,
			-82,
			1
		}
	}
	tbl_3.bg_top_right = {}
	tbl.style = tbl_3
	tbl.offset = {
		var_1_1[1] * size[1],
		var_1_1[2] * size[2],
		1
	}

	local flag_2

	flag_2 = not IS_WINDOWS and "pivot" and "pivot_console"
	tbl.scenegraph_id = flag_2

	return tbl
end

local function fn_2()
	-- function 13
	local tbl = {
		element = {
			passes = {
				{
					style_id = "bg_top_right",
					texture_id = "fade_bg",
					pass_type = "texture",
					content_change_function = function (self, arg_14_1)
						-- function 14
						arg_14_1.texture_size[1] = arg_14_1.base_texture_size[1] * self.size_multiplier
						arg_14_1.texture_size[2] = arg_14_1.base_texture_size[2] * self.size_multiplier
					end
				},
				{
					style_id = "bg_top_left",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (self, arg_15_1)
						-- function 15
						arg_15_1.texture_size[1] = arg_15_1.base_texture_size[1] * self.size_multiplier
						arg_15_1.texture_size[2] = arg_15_1.base_texture_size[2] * self.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_right",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (self, arg_16_1)
						-- function 16
						arg_16_1.texture_size[1] = arg_16_1.base_texture_size[1] * self.size_multiplier
						arg_16_1.texture_size[2] = arg_16_1.base_texture_size[2] * self.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_left",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (self, arg_17_1)
						-- function 17
						arg_17_1.texture_size[1] = arg_17_1.base_texture_size[1] * self.size_multiplier
						arg_17_1.texture_size[2] = arg_17_1.base_texture_size[2] * self.size_multiplier
					end
				},
				{
					style_id = "bg_top_right_masked",
					texture_id = "fade_bg",
					pass_type = "texture",
					content_change_function = function (self, arg_18_1)
						-- function 18
						arg_18_1.texture_size[1] = arg_18_1.base_texture_size[1] * self.size_multiplier
						arg_18_1.texture_size[2] = arg_18_1.base_texture_size[2] * self.size_multiplier
					end
				},
				{
					style_id = "bg_top_left_masked",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (self, arg_19_1)
						-- function 19
						arg_19_1.texture_size[1] = arg_19_1.base_texture_size[1] * self.size_multiplier
						arg_19_1.texture_size[2] = arg_19_1.base_texture_size[2] * self.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_right_masked",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (self, arg_20_1)
						-- function 20
						arg_20_1.texture_size[1] = arg_20_1.base_texture_size[1] * self.size_multiplier
						arg_20_1.texture_size[2] = arg_20_1.base_texture_size[2] * self.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_left_masked",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (self, arg_21_1)
						-- function 21
						arg_21_1.texture_size[1] = arg_21_1.base_texture_size[1] * self.size_multiplier
						arg_21_1.texture_size[2] = arg_21_1.base_texture_size[2] * self.size_multiplier
					end
				},
				{
					style_id = "circle",
					texture_id = "circle_id",
					pass_type = "texture",
					content_change_function = function (self, arg_22_1)
						-- function 22
						arg_22_1.texture_size[1] = arg_22_1.base_texture_size[1] * self.size_multiplier
						arg_22_1.texture_size[2] = arg_22_1.base_texture_size[2] * self.size_multiplier
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_id"
				}
			}
		},
		content = {
			fade_bg = "radial_chat_bg",
			final_size_multiplier = 1,
			size_multiplier = 0,
			circle_id = "radial_chat_bg_ring",
			text_id = Localize("tutorial_no_text")
		},
		style = {
			bg_top_right = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				color = Colors.get_color_table_with_alpha("black", 60)
			},
			bg_top_left = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.75,
				color = Colors.get_color_table_with_alpha("black", 60)
			},
			bg_bottom_right = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.25,
				color = Colors.get_color_table_with_alpha("black", 60)
			},
			bg_bottom_left = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.5,
				color = Colors.get_color_table_with_alpha("black", 60)
			},
			bg_top_right_masked = {
				vertical_alignment = "bottom",
				masked = true,
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				color = Colors.get_color_table_with_alpha("white", 60),
				offset = {
					0,
					0,
					1
				}
			},
			bg_top_left_masked = {
				masked = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.75,
				color = Colors.get_color_table_with_alpha("white", 60),
				offset = {
					0,
					0,
					1
				}
			},
			bg_bottom_right_masked = {
				masked = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.25,
				color = Colors.get_color_table_with_alpha("white", 60),
				offset = {
					0,
					0,
					1
				}
			},
			bg_bottom_left_masked = {
				masked = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.5,
				color = Colors.get_color_table_with_alpha("white", 60),
				offset = {
					0,
					0,
					1
				}
			},
			circle = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				base_texture_size = {
					205,
					205
				},
				texture_size = {
					205,
					205
				},
				color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text = {
				word_wrap = false,
				localize = false,
				font_size = 56,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-385,
					2
				}
			},
			text_shadow = {
				word_wrap = false,
				localize = false,
				font_size = 56,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					2,
					-387,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
	local flag

	flag = not IS_WINDOWS and "pivot" and "pivot_console"
	tbl.scenegraph_id = flag

	return tbl
end

local function fn_3()
	-- function 23
	local tbl = {
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "arrow",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "cursor",
					texture_id = "dot_texture_id"
				}
			}
		},
		content = {
			dot_texture_id = "crosshair_01_center",
			texture_id = "radial_chat_cursor_arrow",
			pointing_point = Vector3Box(0, 0, 0)
		},
		style = {
			cursor = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				pivot = {
					4,
					4
				},
				texture_size = {
					8,
					8
				}
			},
			arrow = {
				vertical_alignment = "center",
				angle = 0,
				horizontal_alignment = "center",
				pivot = {
					14.25,
					27
				},
				texture_size = {
					28.5,
					54
				},
				color = {
					192,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = {
			0,
			0,
			10
		}
	}
	local flag

	flag = not IS_WINDOWS and "pivot" and "pivot_console"
	tbl.scenegraph_id = flag

	return tbl
end

local function fn_4()
	-- function 24
	return {
		scenegraph_id = "next_page_input",
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				}
			}
		},
		content = {
			background = "hud_brushstroke",
			text_id = Localize("input_description_next_page") .. ": $KEY;Player__social_wheel_page:"
		},
		style = {
			text = {
				word_wrap = false,
				localize = false,
				font_size = 32,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text_shadow = {
				font_size = 32,
				font_type = "hell_shark_header",
				localize = false,
				word_wrap = false,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				skip_button_rendering = true,
				text_color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					2,
					-2,
					1
				}
			},
			background = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					150,
					100,
					100,
					100
				},
				offset = {
					-20,
					0,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_5(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local var_25_0

	if not arg_25_3 then
		var_25_0 = Colors.get_color_table_with_alpha("medium_purple", 255)
	else
		var_25_0 = Colors.get_color_table_with_alpha("light_sky_blue", 255)
	end

	var_25_0[2] = var_25_0[2] * 0.75
	var_25_0[3] = var_25_0[3] * 0.75
	var_25_0[4] = var_25_0[4] * 0.75

	return {
		scenegraph_id = "social_event_text",
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					pass_type = "texture",
					style_id = "texture",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			spacing = 60,
			text_id = arg_25_2,
			texture_id = arg_25_1,
			is_local_player = arg_25_3
		},
		style = {
			text = {
				word_wrap = false,
				localize = false,
				font_size = 32,
				pixel_perfect = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = var_25_0,
				offset = {
					0,
					0,
					2
				}
			},
			texture = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					45,
					52.5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_6(self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	local tbl = {
		scenegraph_id = "icon",
		element = {
			passes = {
				{
					style_id = "texture",
					texture_id = "icon_id",
					pass_type = "texture",
					content_check_function = function (self, arg_27_1)
						-- function 27
						local player_from_peer_id = Managers.player:player_from_peer_id(self.peer_id)
						local flag = not player_from_peer_id and player_from_peer_id.player_unit

						if not Unit.alive(flag) then
							self.is_visible = false

							return false
						end

						local world_pose = Camera.world_pose(self.camera)
						local translation = Matrix4x4.translation(world_pose)
						local num = Unit.world_position(flag, 0) - translation
						local normalize = Vector3.normalize(Vector3.flat(num))
						local forward = Matrix4x4.forward(world_pose)
						local normalize_2 = Vector3.normalize(Vector3.flat(forward))

						if Vector3.dot(normalize_2, normalize) <= 0 then
							self.is_visible = false

							return false
						end

						self.is_visible = true

						return true
					end,
					content_change_function = function (self, arg_28_1)
						-- function 28
						local player_from_peer_id = Managers.player:player_from_peer_id(self.peer_id)
						local flag = not player_from_peer_id and player_from_peer_id.player_unit

						if not Unit.alive(flag) and not Unit.has_node(flag, "j_head") then
							local world_position = Camera.world_position(self.camera)
							local inv_scale = RESOLUTION_LOOKUP.inv_scale
							local node = Unit.node(flag, "j_head")
							local world_position_2 = Unit.world_position(flag, node)
							local distance_squared = Vector3.distance_squared(world_position, world_position_2)
							local lerp = math.lerp(1, 0.5, math.clamp(distance_squared / 49, 0, 1))
							local num = world_position_2 + Vector3(0, 0, 0.5) + Vector3(0, 0, 0.5) * (1 - lerp)
							local world_to_screen = Camera.world_to_screen(self.camera, num)
							local time = Managers.time:time("game")
							local num_2 = math.sin(time * 15) * 0.1

							arg_28_1.texture_size[1] = arg_28_1.base_texture_size[1] * lerp + arg_28_1.base_texture_size[1] * lerp * num_2
							arg_28_1.texture_size[2] = arg_28_1.base_texture_size[2] * lerp + arg_28_1.base_texture_size[2] * lerp * num_2
							arg_28_1.offset[1] = world_to_screen[1] * inv_scale - arg_28_1.texture_size[1] * 0.5
							arg_28_1.offset[2] = world_to_screen[2] * inv_scale - arg_28_1.texture_size[1] * 0.5
							self.offset = arg_28_1.offset
							self.distance_scale = lerp
							self.scale = num_2

							if time > self.end_time - self.fade_time then
								local num_3 = self.end_time - time

								self.alpha = math.lerp(0, 255, math.clamp(num_3 / self.fade_time, 0, 1))
								arg_28_1.color[1] = self.alpha
							end
						end
					end
				},
				{
					style_id = "texture_glow",
					texture_id = "icon_glow_id",
					pass_type = "texture",
					content_check_function = function (self, arg_29_1)
						-- function 29
						return self.is_visible
					end,
					content_change_function = function (self, arg_30_1)
						-- function 30
						local offset = self.offset
						local distance_scale = self.distance_scale
						local scale = self.scale
						local alpha = self.alpha

						arg_30_1.offset[1] = offset[1]
						arg_30_1.offset[2] = offset[2]
						arg_30_1.texture_size[1] = arg_30_1.base_texture_size[1] * distance_scale + arg_30_1.base_texture_size[1] * distance_scale * scale
						arg_30_1.texture_size[2] = arg_30_1.base_texture_size[2] * distance_scale + arg_30_1.base_texture_size[2] * distance_scale * scale
						arg_30_1.color[1] = alpha
					end
				},
				{
					style_id = "texture_shadow",
					texture_id = "icon_id",
					pass_type = "texture",
					content_check_function = function (self, arg_31_1)
						-- function 31
						return self.is_visible
					end,
					content_change_function = function (self, arg_32_1)
						-- function 32
						local offset = self.offset
						local distance_scale = self.distance_scale
						local scale = self.scale
						local alpha = self.alpha

						arg_32_1.offset[1] = offset[1] + 2
						arg_32_1.offset[2] = offset[2] - 2
						arg_32_1.texture_size[1] = arg_32_1.base_texture_size[1] * distance_scale + arg_32_1.base_texture_size[1] * distance_scale * scale
						arg_32_1.texture_size[2] = arg_32_1.base_texture_size[2] * distance_scale + arg_32_1.base_texture_size[2] * distance_scale * scale
						arg_32_1.color[1] = alpha
					end
				}
			}
		}
	}
	local tbl_2 = {
		alpha = 255,
		icon_bg_id = "radial_chat_icon_bg"
	}
	local icon = self.icon

	icon = icon or "radial_chat_icon_boss"
	tbl_2.icon_id = icon

	local str

	if not self.icon then
		str = self.icon .. "_glow"

		if not str then
			-- Nothing
		end
	end

	str = "radial_chat_icon_boss_glow"

	::label_26_0::

	tbl_2.icon_glow_id = str
	tbl_2.peer_id = arg_26_1
	tbl_2.camera = arg_26_2
	tbl_2.world = arg_26_3
	tbl_2.end_time = arg_26_4 or Managers.time:time("game") + 5
	tbl_2.fade_time = arg_26_5 or 0.5
	tbl.content = tbl_2
	tbl.style = {
		texture = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			base_texture_size = {
				128,
				128
			},
			texture_size = {
				128,
				128
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
				10
			}
		},
		texture_glow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				128,
				128
			},
			base_texture_size = {
				128,
				128
			},
			color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				0,
				0,
				10
			}
		},
		texture_shadow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			base_texture_size = {
				128,
				128
			},
			texture_size = {
				128,
				128
			},
			color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-2,
				0
			}
		}
	}
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

return {
	scenegraph_definition = tbl,
	create_social_widget = fn,
	arrow_widget = fn_3(),
	create_social_text_event = fn_5,
	create_social_icon = fn_6,
	create_bg_widget = fn_2,
	page_input_widget = fn_4()
}
