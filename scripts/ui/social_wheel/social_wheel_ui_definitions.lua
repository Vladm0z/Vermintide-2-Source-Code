-- chunkname: @scripts/ui/social_wheel/social_wheel_ui_definitions.lua

local SIZE_X = 1920
local SIZE_Y = 1080
local scenegraph_definition = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			SIZE_X,
			SIZE_Y
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
			SIZE_X,
			SIZE_Y
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
			SIZE_X,
			SIZE_Y
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
	scenegraph_definition.screen.scale = "hud_fit"
end

local function create_social_widget(settings, widget_angle, category_settings, get_active_context_func, page_idx)
	-- function 1
	local size = category_settings.size
	local dir = Vector3(math.cos(widget_angle), math.sin(widget_angle), 0)
	local count

	if page_idx then
		count = #category_settings[page_idx]

		if not count then
			-- Nothing
		end
	end

	count = #category_settings

	local num_wedges = count

	::label_1_0::

	local divider_angle = widget_angle + 2 * math.pi * (1 / num_wedges) * 0.5
	local divider_dir = Vector3(math.cos(divider_angle), math.sin(divider_angle), 0)
	local wedge_size = 1 / num_wedges * 360 / 90 * category_settings.wedge_adjustment
	local scale = 3
	local localize = true

	if settings.localize == false then
		localize = false
	end

	local aspect_ratio = size[1] / size[2]
	local tbl = {
		element = {
			passes = {
				{
					style_id = "divider",
					pass_type = "rotated_texture",
					texture_id = "divider_id",
					content_change_function = function (content, style)
						-- function 2
						if content.activated then
							style.color[1] = 0
						else
							style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
							style.pivot[2] = style.base_texture_size[2] * content.size_multiplier * 0.5
							style.color[1] = math.clamp(255 * content.size_multiplier, 0, 255)
						end

						local settings = content.settings
						local is_valid_func = settings.is_valid_func
						local active_context = get_active_context_func()

						if is_valid_func and active_context then
							content.is_valid = is_valid_func(settings.data, active_context, content, style)
						end
					end,
					content_check_function = function (content, style)
						-- function 3
						return not category_settings.individual_bg
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "fade",
					texture_id = "fade_texture_id",
					content_check_function = function (content, style)
						-- function 4
						local selected = content.selected

						if selected then
							selected = content.is_valid
							selected = not not selected and not not not category_settings.individual_bg
						end

						return selected
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_bg",
					texture_id = "icon_bg_id",
					content_check_function = function (content, style)
						-- function 5
						local individual_bg = category_settings.individual_bg

						individual_bg = not not individual_bg and not not content.is_valid

						return individual_bg
					end
				},
				{
					style_id = "icon",
					texture_id = "icon_id",
					pass_type = "texture",
					content_change_function = function (content, style)
						-- function 6
						if content.activated then
							style.color[2] = style.activated_color[2]
							style.color[3] = style.activated_color[3]
							style.color[4] = style.activated_color[4]
						elseif content.selected and content.is_valid then
							style.color[1] = 255
							style.color[2] = 255
							style.color[3] = 255
							style.color[4] = 255
						else
							style.color[1] = 96
							style.color[2] = 255
							style.color[3] = 255
							style.color[4] = 255
						end
					end
				},
				{
					style_id = "icon_shadow",
					texture_id = "icon_id",
					pass_type = "texture",
					content_change_function = function (content, style)
						-- function 7
						if not content.activated then
							if content.selected and content.is_valid then
								style.color[1] = 255
							else
								style.color[1] = 96
							end
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_unavailable",
					texture_id = "icon_unavailable_id",
					content_check_function = function (content, style)
						-- function 8
						return not content.is_valid
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_glow",
					texture_id = "icon_glow_id",
					content_check_function = function (content, style)
						-- function 9
						local selected = content.selected

						selected = not not selected and not not not content.activated

						return selected
					end
				},
				{
					pass_type = "texture",
					style_id = "bg_top_right",
					texture_id = "fade_bg",
					content_check_function = function (content, style)
						-- function 10
						return not category_settings.individual_bg
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id",
					content_check_function = function (content, style)
						-- function 11
						if content.selected then
							style.text_color = style.selected_color
						else
							style.text_color = style.base_color
						end

						local IS_WINDOWS = IS_WINDOWS

						IS_WINDOWS = not not IS_WINDOWS or not not settings.disable_input_text

						return IS_WINDOWS
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_id",
					content_check_function = function (content, style)
						-- function 12
						if content.selected then
							style.text_color = style.selected_color
						else
							style.text_color = style.base_color
						end

						local IS_WINDOWS = IS_WINDOWS

						IS_WINDOWS = not not IS_WINDOWS or not not settings.disable_input_text

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
	local icon = settings.icon

	icon = not not icon or not not "radial_chat_icon_boss"
	tbl_2.icon_id = icon

	local icon_glow

	if settings.icon then
		icon_glow = settings.icon_glow

		if not icon_glow then
			-- Nothing
		end

		icon_glow = settings.icon .. "_glow"

		if not icon_glow then
			-- Nothing
		end
	end

	icon_glow = "radial_chat_icon_boss_glow"

	::label_1_1::

	tbl_2.icon_glow_id = icon_glow
	tbl_2.settings = settings
	tbl_2.category_settings = category_settings
	tbl_2.text_id = settings.text
	tbl_2.dir = Vector3Box(dir)
	tbl_2.final_offset = size
	tbl.content = tbl_2

	local tbl_3 = {}
	local tbl_4 = {
		vertical_alignment = "center",
		horizontal_alignment = "center"
	}
	local icon_size = category_settings.icon_size

	icon_size = not not icon_size or not not {
		128,
		128
	}
	tbl_4.base_texture_size = icon_size

	local icon_size_2 = category_settings.icon_size

	icon_size_2 = not not icon_size_2 or not not {
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
	local icon_size_3 = category_settings.icon_size

	icon_size_3 = not not icon_size_3 or not not {
		128,
		128
	}
	tbl_5.base_texture_size = icon_size_3

	local icon_size_4 = category_settings.icon_size

	icon_size_4 = not not icon_size_4 or not not {
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
	local icon_size_5 = category_settings.icon_size

	icon_size_5 = not not icon_size_5 or not not {
		128,
		128
	}
	tbl_6.base_texture_size = icon_size_5

	local icon_size_6 = category_settings.icon_size

	icon_size_6 = not not icon_size_6 or not not {
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
	local icon_size_7 = category_settings.icon_size

	icon_size_7 = not not icon_size_7 or not not {
		128,
		128
	}
	tbl_7.base_texture_size = icon_size_7

	local icon_size_8 = category_settings.icon_size

	icon_size_8 = not not icon_size_8 or not not {
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
	local icon_size_9 = category_settings.icon_size

	icon_size_9 = not not icon_size_9 or not not {
		128,
		128
	}
	tbl_8.base_texture_size = icon_size_9

	local icon_size_10 = category_settings.icon_size

	icon_size_10 = not not icon_size_10 or not not {
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
		angle = 2 * math.pi - divider_angle + math.pi * 0.5,
		color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			-dir[1] * size[1] + divider_dir[1] * 227,
			-dir[2] * size[2] + divider_dir[2] * 227,
			1
		}
	}
	tbl_3.fade = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			389 * wedge_size * scale,
			195 * scale
		},
		pivot = {
			389 * wedge_size * 0.5 * scale,
			97.5 * scale
		},
		angle = 2 * math.pi - widget_angle + math.pi * 0.5,
		color = Colors.get_color_table_with_alpha("white", 30),
		offset = {
			-dir[1] * size[1] + dir[1] * 195 * 0.5 * scale,
			-dir[2] * size[2] + dir[2] * 195 * 0.5 * scale,
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
		localize = localize,
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
		localize = localize,
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
		dir[1] * size[1],
		dir[2] * size[2],
		1
	}

	local flag

	flag = (not IS_WINDOWS or not "pivot") and not not "pivot_console"
	tbl.scenegraph_id = flag

	return tbl
end

local function create_bg_widget()
	-- function 13
	local tbl = {
		element = {
			passes = {
				{
					style_id = "bg_top_right",
					texture_id = "fade_bg",
					pass_type = "texture",
					content_change_function = function (content, style)
						-- function 14
						style.texture_size[1] = style.base_texture_size[1] * content.size_multiplier
						style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
					end
				},
				{
					style_id = "bg_top_left",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (content, style)
						-- function 15
						style.texture_size[1] = style.base_texture_size[1] * content.size_multiplier
						style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_right",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (content, style)
						-- function 16
						style.texture_size[1] = style.base_texture_size[1] * content.size_multiplier
						style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_left",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (content, style)
						-- function 17
						style.texture_size[1] = style.base_texture_size[1] * content.size_multiplier
						style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
					end
				},
				{
					style_id = "bg_top_right_masked",
					texture_id = "fade_bg",
					pass_type = "texture",
					content_change_function = function (content, style)
						-- function 18
						style.texture_size[1] = style.base_texture_size[1] * content.size_multiplier
						style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
					end
				},
				{
					style_id = "bg_top_left_masked",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (content, style)
						-- function 19
						style.texture_size[1] = style.base_texture_size[1] * content.size_multiplier
						style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_right_masked",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (content, style)
						-- function 20
						style.texture_size[1] = style.base_texture_size[1] * content.size_multiplier
						style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_left_masked",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function (content, style)
						-- function 21
						style.texture_size[1] = style.base_texture_size[1] * content.size_multiplier
						style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
					end
				},
				{
					style_id = "circle",
					texture_id = "circle_id",
					pass_type = "texture",
					content_change_function = function (content, style)
						-- function 22
						style.texture_size[1] = style.base_texture_size[1] * content.size_multiplier
						style.texture_size[2] = style.base_texture_size[2] * content.size_multiplier
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

	flag = (not IS_WINDOWS or not "pivot") and not not "pivot_console"
	tbl.scenegraph_id = flag

	return tbl
end

local function create_arrow_widget()
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

	flag = (not IS_WINDOWS or not "pivot") and not not "pivot_console"
	tbl.scenegraph_id = flag

	return tbl
end

local function create_page_input_widget()
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

local function create_social_text_event(social_event_setting, texture, text, is_local_player)
	-- function 25
	local color

	if is_local_player then
		color = Colors.get_color_table_with_alpha("medium_purple", 255)
	else
		color = Colors.get_color_table_with_alpha("light_sky_blue", 255)
	end

	color[2] = color[2] * 0.75
	color[3] = color[3] * 0.75
	color[4] = color[4] * 0.75

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
			text_id = text,
			texture_id = texture,
			is_local_player = is_local_player
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
				text_color = color,
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

local function create_social_icon(social_event_setting, peer_id, camera, world, end_time, fade_time)
	-- function 26
	local tbl = {
		scenegraph_id = "icon",
		element = {
			passes = {
				{
					style_id = "texture",
					texture_id = "icon_id",
					pass_type = "texture",
					content_check_function = function (content, style)
						-- function 27
						local player = Managers.player:player_from_peer_id(content.peer_id)
						local player_unit = not not player and not not player.player_unit

						if not Unit.alive(player_unit) then
							content.is_visible = false

							return false
						end

						local camera_pose = Camera.world_pose(content.camera)
						local camera_pos = Matrix4x4.translation(camera_pose)
						local player_pos = Unit.world_position(player_unit, 0)
						local dir = player_pos - camera_pos
						local flat_dir = Vector3.normalize(Vector3.flat(dir))
						local forward = Matrix4x4.forward(camera_pose)
						local flat_forward = Vector3.normalize(Vector3.flat(forward))

						if Vector3.dot(flat_forward, flat_dir) <= 0 then
							content.is_visible = false

							return false
						end

						content.is_visible = true

						return true
					end,
					content_change_function = function (content, style)
						-- function 28
						local player = Managers.player:player_from_peer_id(content.peer_id)
						local player_unit = not not player and not not player.player_unit

						if Unit.alive(player_unit) and Unit.has_node(player_unit, "j_head") then
							local camera_pos = Camera.world_position(content.camera)
							local inv_scale = RESOLUTION_LOOKUP.inv_scale
							local node = Unit.node(player_unit, "j_head")
							local player_pos = Unit.world_position(player_unit, node)
							local distance_sq = Vector3.distance_squared(camera_pos, player_pos)
							local distance_scale = math.lerp(1, 0.5, math.clamp(distance_sq / 49, 0, 1))
							local position = player_pos + Vector3(0, 0, 0.5) + Vector3(0, 0, 0.5) * (1 - distance_scale)
							local pos = Camera.world_to_screen(content.camera, position)
							local time = Managers.time:time("game")
							local scale = math.sin(time * 15) * 0.1

							style.texture_size[1] = style.base_texture_size[1] * distance_scale + style.base_texture_size[1] * distance_scale * scale
							style.texture_size[2] = style.base_texture_size[2] * distance_scale + style.base_texture_size[2] * distance_scale * scale
							style.offset[1] = pos[1] * inv_scale - style.texture_size[1] * 0.5
							style.offset[2] = pos[2] * inv_scale - style.texture_size[1] * 0.5
							content.offset = style.offset
							content.distance_scale = distance_scale
							content.scale = scale

							if time > content.end_time - content.fade_time then
								local value = content.end_time - time

								content.alpha = math.lerp(0, 255, math.clamp(value / content.fade_time, 0, 1))
								style.color[1] = content.alpha
							end
						end
					end
				},
				{
					style_id = "texture_glow",
					texture_id = "icon_glow_id",
					pass_type = "texture",
					content_check_function = function (content, style)
						-- function 29
						return content.is_visible
					end,
					content_change_function = function (content, style)
						-- function 30
						local offset = content.offset
						local distance_scale = content.distance_scale
						local scale = content.scale
						local alpha = content.alpha

						style.offset[1] = offset[1]
						style.offset[2] = offset[2]
						style.texture_size[1] = style.base_texture_size[1] * distance_scale + style.base_texture_size[1] * distance_scale * scale
						style.texture_size[2] = style.base_texture_size[2] * distance_scale + style.base_texture_size[2] * distance_scale * scale
						style.color[1] = alpha
					end
				},
				{
					style_id = "texture_shadow",
					texture_id = "icon_id",
					pass_type = "texture",
					content_check_function = function (content, style)
						-- function 31
						return content.is_visible
					end,
					content_change_function = function (content, style)
						-- function 32
						local offset = content.offset
						local distance_scale = content.distance_scale
						local scale = content.scale
						local alpha = content.alpha

						style.offset[1] = offset[1] + 2
						style.offset[2] = offset[2] - 2
						style.texture_size[1] = style.base_texture_size[1] * distance_scale + style.base_texture_size[1] * distance_scale * scale
						style.texture_size[2] = style.base_texture_size[2] * distance_scale + style.base_texture_size[2] * distance_scale * scale
						style.color[1] = alpha
					end
				}
			}
		}
	}
	local tbl_2 = {
		alpha = 255,
		icon_bg_id = "radial_chat_icon_bg"
	}
	local icon = social_event_setting.icon

	icon = not not icon or not not "radial_chat_icon_boss"
	tbl_2.icon_id = icon

	local str

	if social_event_setting.icon then
		str = social_event_setting.icon .. "_glow"

		if not str then
			-- Nothing
		end
	end

	str = "radial_chat_icon_boss_glow"

	::label_26_0::

	tbl_2.icon_glow_id = str
	tbl_2.peer_id = peer_id
	tbl_2.camera = camera
	tbl_2.world = world
	tbl_2.end_time = not not end_time or not not (Managers.time:time("game") + 5)
	tbl_2.fade_time = not not fade_time or not not 0.5
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
	scenegraph_definition = scenegraph_definition,
	create_social_widget = create_social_widget,
	arrow_widget = create_arrow_widget(),
	create_social_text_event = create_social_text_event,
	create_social_icon = create_social_icon,
	create_bg_widget = create_bg_widget,
	page_input_widget = create_page_input_widget()
}
