-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_character_preview_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_4 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_4 * 2 + 60)
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
			UILayer.default
		}
	},
	root_fit = {
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
	menu_root = {
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
			0
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = size,
		position = {
			0,
			0,
			1
		}
	},
	preview = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1],
			size[2] - 120
		},
		position = {
			0,
			0,
			8
		}
	},
	disclaimer_text_background = {
		vertical_alignment = "bottom",
		parent = "preview",
		horizontal_alignment = "center",
		size = {
			size[1] - 40,
			70
		},
		position = {
			0,
			10,
			9
		}
	},
	disclaimer_text = {
		vertical_alignment = "bottom",
		parent = "preview",
		horizontal_alignment = "center",
		size = {
			size[1] - 40,
			50
		},
		position = {
			0,
			20,
			10
		}
	},
	detailed_button = {
		vertical_alignment = "top",
		parent = "preview",
		horizontal_alignment = "right",
		size = {
			50,
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	detailed_list = {
		vertical_alignment = "top",
		parent = "detailed_button",
		horizontal_alignment = "right",
		size = {
			size[1],
			size[2] - 120 - 50
		},
		position = {
			0,
			-40,
			1
		}
	},
	loading_overlay = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			314,
			33
		},
		position = {
			0,
			0,
			40
		}
	}
}
local tbl_2 = {
	vertical_alignment = "bottom",
	upper_case = true,
	localize = false,
	horizontal_alignment = "center",
	font_size = 42,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_3 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	font_size = 36,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_4 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
	vertical_alignment = "bottom",
	font_size = 18,
	localize = false,
	horizontal_alignment = "center",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_6 = {
	vertical_alignment = "bottom",
	font_size = 20,
	localize = false,
	horizontal_alignment = "center",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_7 = {
	scenegraph_id = "preview",
	element = UIElements.Viewport,
	style = {
		viewport = {
			layer = 990,
			shading_environment = "environment/ui_inventory_preview",
			viewport_name = "character_preview_viewport",
			clear_screen_on_create = true,
			level_name = "levels/ui_inventory_preview/world",
			level_package_name = "resource_packages/levels/ui_inventory_preview",
			enable_sub_gui = false,
			world_name = "character_preview",
			world_flags = {
				Application.DISABLE_SOUND,
				Application.DISABLE_ESRAM
			},
			camera_position = {
				0,
				0,
				0
			},
			camera_lookat = {
				0,
				0,
				0
			}
		}
	},
	content = {
		button_hotspot = {
			allow_multi_hover = true
		}
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local str = "menu_frame_bg_02"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local size

	if not get_atlas_settings_by_texture_name then
		size = get_atlas_settings_by_texture_name.size

		if not size then
			-- Nothing
		end
	end

	size = arg_1_1

	::label_1_0::

	local flag = true
	local num = 50
	local tbl = {
		arg_1_3[1],
		30
	}
	local tbl_2 = {
		arg_1_3[1],
		arg_1_3[2] + arg_1_1[2]
	}
	local tbl_3 = {
		passes = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				pass_type = "rotated_texture",
				style_id = "drop_down_arrow",
				texture_id = "drop_down_arrow"
			},
			{
				pass_type = "tiled_texture",
				style_id = "drop_down_edge",
				texture_id = "drop_down_edge",
				content_check_function = function (self)
					-- function 2
					return self.active
				end
			},
			{
				style_id = "title",
				pass_type = "text",
				text_id = "title",
				content_check_function = function (self)
					-- function 3
					return self.active
				end
			},
			{
				style_id = "title_shadow",
				pass_type = "text",
				text_id = "title",
				content_check_function = function (self)
					-- function 4
					return self.active
				end
			},
			{
				style_id = "title_rect",
				pass_type = "rect",
				content_check_function = function (self)
					-- function 5
					return self.active
				end
			},
			{
				style_id = "scrollbar",
				pass_type = "scrollbar_hotspot",
				content_id = "scrollbar",
				content_check_function = function (self)
					-- function 6
					return self.active
				end
			},
			{
				style_id = "scrollbar",
				pass_type = "scrollbar",
				content_id = "scrollbar",
				content_check_function = function (self)
					-- function 7
					return self.active
				end
			},
			{
				style_id = "mask",
				pass_type = "hotspot",
				content_id = "list_hotspot"
			},
			{
				style_id = "list_background",
				pass_type = "texture_uv",
				content_id = "list_background",
				content_check_function = function (self)
					-- function 8
					return self.parent.active
				end
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture",
				content_check_function = function (self)
					-- function 9
					return self.active
				end
			},
			{
				style_id = "list_background",
				pass_type = "scroll",
				content_id = "scrollbar",
				scroll_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
					-- function 10
					local y = arg_10_4.y
					local list_hotspot = arg_10_2.parent.list_hotspot

					if y == 0 or not list_hotspot.is_hover then
						arg_10_2.axis_input = y

						local scroll_value = arg_10_2.scroll_value
						local clamp = math.clamp(arg_10_2.scroll_value + y * arg_10_2.scroll_amount, 0, 1)

						arg_10_2.scroll_add = y * arg_10_2.scroll_amount
					else
						local axis_input = arg_10_2.axis_input
					end

					local scroll_add = arg_10_2.scroll_add

					if not scroll_add then
						local num = scroll_add * (arg_10_5 * 5)
						local num_2 = scroll_add - num

						if math.abs(num_2) > 0 then
							arg_10_2.scroll_add = num_2
						else
							arg_10_2.scroll_add = nil
						end

						local scroll_value_2 = arg_10_2.scroll_value

						arg_10_2.scroll_value = math.clamp(scroll_value_2 + num, 0, 1)
					end
				end
			},
			{
				style_id = "list_style",
				pass_type = "list_pass",
				content_id = "list_content",
				content_check_function = function (self)
					-- function 11
					return self.active
				end,
				passes = {
					{
						style_id = "hotspot",
						pass_type = "hotspot",
						content_id = "hotspot"
					},
					{
						style_id = "tooltip",
						additional_option_id = "tooltip",
						pass_type = "additional_option_tooltip",
						content_check_function = function (self)
							-- function 12
							if not self.parent.list_hotspot.is_hover then
								return self.name == "" or self.hotspot.is_hover
							end

							return false
						end
					},
					{
						pass_type = "texture",
						style_id = "hover_texture",
						texture_id = "hover_texture",
						content_check_function = function (self)
							-- function 13
							if not self.parent.list_hotspot.is_hover then
								return self.name == "" or self.hotspot.is_hover
							end

							return false
						end
					},
					{
						style_id = "title",
						pass_type = "text",
						text_id = "title"
					},
					{
						style_id = "title_shadow",
						pass_type = "text",
						text_id = "title"
					},
					{
						style_id = "name",
						pass_type = "text",
						text_id = "name"
					},
					{
						style_id = "name_shadow",
						pass_type = "text",
						text_id = "name"
					},
					{
						style_id = "value",
						pass_type = "text",
						text_id = "value"
					},
					{
						style_id = "value_shadow",
						pass_type = "text",
						text_id = "value"
					},
					{
						pass_type = "texture",
						style_id = "title_divider",
						texture_id = "title_divider",
						content_check_function = function (self)
							-- function 14
							return self.title ~= ""
						end
					}
				}
			}
		}
	}
	local tbl_4 = {
		drop_down_arrow = "drop_down_menu_arrow",
		title = "n/a",
		drop_down_edge = "menu_frame_09_divider",
		active = false,
		mask_texture = "mask_rect",
		list_hotspot = {},
		button_hotspot = {},
		list_background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(tbl_2[1] / size[1], 1),
					math.min(tbl_2[2] / size[2], 1)
				}
			},
			texture_id = str
		},
		scrollbar = {
			scroll_amount = 0.1,
			percentage = 0.1,
			scroll_value = 1
		},
		list_content = {
			active = false,
			allow_multi_hover = true
		}
	}
	local list_content = tbl_4.list_content

	for i = 1, num do
		list_content[i] = {
			name = "",
			hover_texture = "playerlist_hover",
			value = "",
			title = "",
			title_divider = "game_option_divider",
			hotspot = {},
			tooltip = {
				description = "n/a",
				title = "n/a"
			}
		}
	end

	local tbl_5 = {
		drop_down_edge = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
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
			},
			texture_size = {
				tbl_2[1],
				5
			},
			texture_tiling_size = {
				tbl_2[1],
				5
			}
		},
		title_rect = {
			vertical_alignment = "top",
			horizontal_alignment = "right",
			color = {
				220,
				5,
				5,
				5
			},
			offset = {
				0,
				0,
				1
			},
			texture_size = {
				tbl_2[1],
				arg_1_1[2]
			}
		},
		title = {
			word_wrap = true,
			upper_case = true,
			localize = false,
			font_size = 30,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			normal_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				-(tbl_2[1] - arg_1_1[1]) + 10,
				0,
				3
			},
			size = {
				tbl_2[1],
				arg_1_1[2]
			}
		},
		title_shadow = {
			word_wrap = true,
			upper_case = true,
			localize = false,
			font_size = 30,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			normal_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				-(tbl_2[1] - arg_1_1[1]) + 12,
				-2,
				2
			},
			size = {
				tbl_2[1],
				arg_1_1[2]
			}
		},
		hotspot = {
			size = {
				arg_1_1[1],
				arg_1_1[2]
			},
			offset = {
				0,
				0,
				0
			}
		},
		drop_down_arrow = {
			vertical_alignment = "top",
			horizontal_alignment = "right",
			angle = 0,
			texture_size = {
				31,
				15
			},
			pivot = {
				15.5,
				7.5
			},
			offset = {
				-12,
				-14,
				3
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		scrollbar = {
			hotspot_width_modifier = 5,
			min_scrollbar_height = 30,
			size = {
				4,
				arg_1_3[2] - 20
			},
			offset = {
				arg_1_1[1] - 20,
				-arg_1_3[2] + 12,
				100
			},
			background_color = Colors.get_color_table_with_alpha("very_dark_gray", 255),
			scrollbar_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			scroll_area_size = {
				arg_1_1[1],
				arg_1_3[2]
			},
			scroll_area_offset = {
				-arg_1_1[1] + 19,
				-10,
				0
			}
		},
		mask = {
			size = {
				arg_1_3[1],
				arg_1_3[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-(arg_1_3[1] - arg_1_1[1]),
				-arg_1_3[2],
				0
			}
		},
		list_background = {
			size = tbl_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-(arg_1_3[1] - arg_1_1[1]),
				-arg_1_3[2],
				0
			}
		},
		list_style = {
			vertical_alignment = "top",
			num_draws = 0,
			start_index = 1,
			horizontal_alignment = "center",
			list_member_offset = {
				0,
				tbl[2],
				0
			},
			size = {
				tbl[1],
				tbl[2]
			},
			scenegraph_id = arg_1_2,
			item_styles = {}
		}
	}
	local item_styles = tbl_5.list_style.item_styles

	for j = 1, num do
		local tbl_6 = {
			list_member_offset = {
				0,
				-tbl[2],
				0
			},
			size = {
				tbl[1],
				tbl[2]
			}
		}
		local tbl_7 = {
			word_wrap = true,
			upper_case = true,
			localize = false,
			font_size = 26,
			horizontal_alignment = "left",
			vertical_alignment = "center"
		}
		local flag_2

		flag_2 = not flag and "hell_shark_header_masked" and "hell_shark_header"
		tbl_7.font_type = flag_2
		tbl_7.text_color = Colors.get_color_table_with_alpha("font_title", 255)
		tbl_7.normal_color = Colors.get_color_table_with_alpha("font_title", 255)
		tbl_7.offset = {
			10,
			5,
			2
		}
		tbl_6.title = tbl_7

		local tbl_8 = {
			word_wrap = true,
			upper_case = true,
			localize = false,
			font_size = 26,
			horizontal_alignment = "left",
			vertical_alignment = "center"
		}
		local flag_3

		flag_3 = not flag and "hell_shark_header_masked" and "hell_shark_header"
		tbl_8.font_type = flag_3
		tbl_8.text_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_8.normal_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_8.offset = {
			12,
			3,
			1
		}
		tbl_6.title_shadow = tbl_8

		local tbl_9 = {
			word_wrap = true,
			font_size = 22,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center"
		}
		local flag_4

		flag_4 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_9.font_type = flag_4
		tbl_9.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
		tbl_9.normal_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
		tbl_9.offset = {
			10,
			0,
			2
		}
		tbl_6.name = tbl_9

		local tbl_10 = {
			word_wrap = true,
			font_size = 22,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center"
		}
		local flag_5

		flag_5 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_10.font_type = flag_5
		tbl_10.text_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_10.normal_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_10.offset = {
			12,
			-2,
			1
		}
		tbl_6.name_shadow = tbl_10

		local tbl_11 = {
			word_wrap = true,
			font_size = 22,
			localize = false,
			horizontal_alignment = "right",
			vertical_alignment = "center"
		}
		local flag_6

		flag_6 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_11.font_type = flag_6
		tbl_11.text_color = Colors.get_color_table_with_alpha("font_default", 255)
		tbl_11.normal_color = Colors.get_color_table_with_alpha("font_default", 255)
		tbl_11.offset = {
			-40,
			0,
			2
		}
		tbl_6.value = tbl_11

		local tbl_12 = {
			word_wrap = true,
			font_size = 22,
			localize = false,
			horizontal_alignment = "right",
			vertical_alignment = "center"
		}
		local flag_7

		flag_7 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_12.font_type = flag_7
		tbl_12.text_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_12.normal_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_12.offset = {
			-38,
			-2,
			1
		}
		tbl_6.value_shadow = tbl_12
		tbl_6.hover_texture = {
			masked = true,
			size = {
				tbl[1],
				tbl[2]
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
		}
		tbl_6.title_divider = {
			masked = true,
			size = {
				500,
				5
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
				2
			}
		}
		tbl_6.rect = {
			size = {
				tbl[1],
				tbl[2]
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
				100
			}
		}
		tbl_6.tooltip = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				0
			}
		}
		item_styles[j] = tbl_6
	end

	return {
		element = tbl_3,
		content = tbl_4,
		style = tbl_5,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local tbl_8 = {
	loading_overlay = UIWidgets.create_simple_rect("window", {
		255,
		12,
		12,
		12
	}),
	loading_overlay_loading_glow = UIWidgets.create_simple_texture("loading_title_divider", "loading_overlay", nil, nil, nil, 1),
	loading_overlay_loading_frame = UIWidgets.create_simple_texture("loading_title_divider_background", "loading_overlay")
}
local tbl_9 = {
	witch_hunter = {
		z = 0.4,
		x = 0,
		y = -0.4
	},
	bright_wizard = {
		z = 0.2,
		x = 0,
		y = -0.7
	},
	dwarf_ranger = {
		z = 0,
		x = 0,
		y = -0.6
	},
	wood_elf = {
		z = 0.16,
		x = 0,
		y = -0.5
	},
	empire_soldier = {
		z = 0.2,
		x = 0,
		y = -0.6
	},
	empire_soldier_tutorial = {
		z = 0.2,
		x = 0,
		y = -0.6
	}
}
local tbl_10 = {
	window = UIWidgets.create_frame("window", size, frame, 15),
	detailed = fn("detailed_button", tbl.detailed_button.size, "detailed_list", tbl.detailed_list.size),
	disclaimer_text_background = UIWidgets.create_rect_with_outer_frame("disclaimer_text_background", tbl.disclaimer_text_background.size, "frame_outer_fade_02", nil, Colors.get_color_table_with_alpha("black", 175)),
	disclaimer_text = UIWidgets.create_simple_text(Localize("inventory_morris_note"), "disclaimer_text", tbl.preview.size, nil, tbl_6)
}
local tbl_11 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				arg_15_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				-- function 16
				local easeOutCubic = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				arg_18_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				-- function 19
				local easeOutCubic = math.easeOutCubic(arg_19_3)

				arg_19_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end
		}
	}
}

return {
	widgets = tbl_10,
	node_widgets = node_widgets,
	viewport_widget = tbl_7,
	scenegraph_definition = tbl,
	animation_definitions = tbl_11,
	camera_position_by_character = tbl_9,
	loading_overlay_widgets = tbl_8
}
