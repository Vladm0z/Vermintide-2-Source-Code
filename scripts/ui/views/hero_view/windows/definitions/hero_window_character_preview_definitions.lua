-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_character_preview_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_6 = var_0_3[1] - (var_0_4 * 2 + 60)
local var_0_7 = {
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
		size = var_0_3,
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
			var_0_3[1],
			var_0_3[2] - 120
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
			var_0_3[1] - 40,
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
			var_0_3[1] - 40,
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
			var_0_3[1],
			var_0_3[2] - 120 - 50
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
local var_0_8 = {
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
local var_0_9 = {
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
local var_0_10 = {
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
local var_0_11 = {
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
local var_0_12 = {
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
local var_0_13 = {
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

local function var_0_14(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = "menu_frame_bg_02"
	local var_1_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_0)
	local var_1_2 = var_1_1 and var_1_1.size or arg_1_1
	local var_1_3 = true
	local var_1_4 = 50
	local var_1_5 = {
		arg_1_3[1],
		30
	}
	local var_1_6 = {
		arg_1_3[1],
		arg_1_3[2] + arg_1_1[2]
	}
	local var_1_7 = {
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
				content_check_function = function(arg_2_0)
					return arg_2_0.active
				end
			},
			{
				style_id = "title",
				pass_type = "text",
				text_id = "title",
				content_check_function = function(arg_3_0)
					return arg_3_0.active
				end
			},
			{
				style_id = "title_shadow",
				pass_type = "text",
				text_id = "title",
				content_check_function = function(arg_4_0)
					return arg_4_0.active
				end
			},
			{
				style_id = "title_rect",
				pass_type = "rect",
				content_check_function = function(arg_5_0)
					return arg_5_0.active
				end
			},
			{
				style_id = "scrollbar",
				pass_type = "scrollbar_hotspot",
				content_id = "scrollbar",
				content_check_function = function(arg_6_0)
					return arg_6_0.active
				end
			},
			{
				style_id = "scrollbar",
				pass_type = "scrollbar",
				content_id = "scrollbar",
				content_check_function = function(arg_7_0)
					return arg_7_0.active
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
				content_check_function = function(arg_8_0)
					return arg_8_0.parent.active
				end
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture",
				content_check_function = function(arg_9_0)
					return arg_9_0.active
				end
			},
			{
				style_id = "list_background",
				pass_type = "scroll",
				content_id = "scrollbar",
				scroll_function = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
					local var_10_0 = arg_10_4.y
					local var_10_1 = arg_10_2.parent.list_hotspot

					if var_10_0 ~= 0 and var_10_1.is_hover then
						arg_10_2.axis_input = var_10_0

						local var_10_2 = arg_10_2.scroll_value
						local var_10_3 = math.clamp(arg_10_2.scroll_value + var_10_0 * arg_10_2.scroll_amount, 0, 1)

						arg_10_2.scroll_add = var_10_0 * arg_10_2.scroll_amount
					else
						local var_10_4 = arg_10_2.axis_input
					end

					local var_10_5 = arg_10_2.scroll_add

					if var_10_5 then
						local var_10_6 = var_10_5 * (arg_10_5 * 5)
						local var_10_7 = var_10_5 - var_10_6

						if math.abs(var_10_7) > 0 then
							arg_10_2.scroll_add = var_10_7
						else
							arg_10_2.scroll_add = nil
						end

						local var_10_8 = arg_10_2.scroll_value

						arg_10_2.scroll_value = math.clamp(var_10_8 + var_10_6, 0, 1)
					end
				end
			},
			{
				style_id = "list_style",
				pass_type = "list_pass",
				content_id = "list_content",
				content_check_function = function(arg_11_0)
					return arg_11_0.active
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
						content_check_function = function(arg_12_0)
							if arg_12_0.parent.list_hotspot.is_hover then
								return arg_12_0.name ~= "" and arg_12_0.hotspot.is_hover
							end

							return false
						end
					},
					{
						pass_type = "texture",
						style_id = "hover_texture",
						texture_id = "hover_texture",
						content_check_function = function(arg_13_0)
							if arg_13_0.parent.list_hotspot.is_hover then
								return arg_13_0.name ~= "" and arg_13_0.hotspot.is_hover
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
						content_check_function = function(arg_14_0)
							return arg_14_0.title ~= ""
						end
					}
				}
			}
		}
	}
	local var_1_8 = {
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
					math.min(var_1_6[1] / var_1_2[1], 1),
					math.min(var_1_6[2] / var_1_2[2], 1)
				}
			},
			texture_id = var_1_0
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
	local var_1_9 = var_1_8.list_content

	for iter_1_0 = 1, var_1_4 do
		var_1_9[iter_1_0] = {
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

	local var_1_10 = {
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
				var_1_6[1],
				5
			},
			texture_tiling_size = {
				var_1_6[1],
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
				var_1_6[1],
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
				-(var_1_6[1] - arg_1_1[1]) + 10,
				0,
				3
			},
			size = {
				var_1_6[1],
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
				-(var_1_6[1] - arg_1_1[1]) + 12,
				-2,
				2
			},
			size = {
				var_1_6[1],
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
			size = var_1_6,
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
				var_1_5[2],
				0
			},
			size = {
				var_1_5[1],
				var_1_5[2]
			},
			scenegraph_id = arg_1_2,
			item_styles = {}
		}
	}
	local var_1_11 = var_1_10.list_style.item_styles

	for iter_1_1 = 1, var_1_4 do
		var_1_11[iter_1_1] = {
			list_member_offset = {
				0,
				-var_1_5[2],
				0
			},
			size = {
				var_1_5[1],
				var_1_5[2]
			},
			title = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_3 and "hell_shark_header_masked" or "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				normal_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					10,
					5,
					2
				}
			},
			title_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_3 and "hell_shark_header_masked" or "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				normal_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					12,
					3,
					1
				}
			},
			name = {
				word_wrap = true,
				font_size = 22,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_3 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				normal_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					10,
					0,
					2
				}
			},
			name_shadow = {
				word_wrap = true,
				font_size = 22,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_3 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				normal_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					12,
					-2,
					1
				}
			},
			value = {
				word_wrap = true,
				font_size = 22,
				localize = false,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = var_1_3 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				normal_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-40,
					0,
					2
				}
			},
			value_shadow = {
				word_wrap = true,
				font_size = 22,
				localize = false,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = var_1_3 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				normal_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-38,
					-2,
					1
				}
			},
			hover_texture = {
				masked = true,
				size = {
					var_1_5[1],
					var_1_5[2]
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
			title_divider = {
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
			},
			rect = {
				size = {
					var_1_5[1],
					var_1_5[2]
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
			},
			tooltip = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				}
			}
		}
	end

	return {
		element = var_1_7,
		content = var_1_8,
		style = var_1_10,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_15 = {
	loading_overlay = UIWidgets.create_simple_rect("window", {
		255,
		12,
		12,
		12
	}),
	loading_overlay_loading_glow = UIWidgets.create_simple_texture("loading_title_divider", "loading_overlay", nil, nil, nil, 1),
	loading_overlay_loading_frame = UIWidgets.create_simple_texture("loading_title_divider_background", "loading_overlay")
}
local var_0_16 = {
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
local var_0_17 = {
	window = UIWidgets.create_frame("window", var_0_3, var_0_2, 15),
	detailed = var_0_14("detailed_button", var_0_7.detailed_button.size, "detailed_list", var_0_7.detailed_list.size),
	disclaimer_text_background = UIWidgets.create_rect_with_outer_frame("disclaimer_text_background", var_0_7.disclaimer_text_background.size, "frame_outer_fade_02", nil, Colors.get_color_table_with_alpha("black", 175)),
	disclaimer_text = UIWidgets.create_simple_text(Localize("inventory_morris_note"), "disclaimer_text", var_0_7.preview.size, nil, var_0_12)
}
local var_0_18 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				arg_15_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				local var_16_0 = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = var_16_0
			end,
			on_complete = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = math.easeOutCubic(arg_19_3)

				arg_19_4.render_settings.alpha_multiplier = 1 - var_19_0
			end,
			on_complete = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_17,
	node_widgets = node_widgets,
	viewport_widget = var_0_13,
	scenegraph_definition = var_0_7,
	animation_definitions = var_0_18,
	camera_position_by_character = var_0_16,
	loading_overlay_widgets = var_0_15
}
