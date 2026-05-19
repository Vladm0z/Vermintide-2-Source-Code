-- chunkname: @scripts/ui/views/tutorial_input_ui_definitions.lua

local var_0_0 = false
local var_0_1 = 5
local var_0_2 = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.tutorial
		}
	},
	center_root = {
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
			0
		}
	},
	tutorial_tooltip_root = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			0
		}
	},
	tutorial_tooltip = {
		vertical_alignment = "center",
		parent = "tutorial_tooltip_root",
		horizontal_alignment = "center",
		position = {
			0,
			-270,
			10
		},
		size = {
			0,
			0
		}
	},
	tutorial_tooltip_background = {
		vertical_alignment = "center",
		parent = "tutorial_tooltip",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			680,
			160
		}
	},
	tutorial_tooltip_description = {
		vertical_alignment = "top",
		parent = "tutorial_tooltip_background",
		horizontal_alignment = "center",
		position = {
			0,
			-46,
			1
		},
		size = {
			1200,
			0
		}
	},
	tutorial_tooltip_sub_description = {
		vertical_alignment = "center",
		parent = "tutorial_tooltip_background",
		horizontal_alignment = "center",
		position = {
			0,
			-32,
			1
		},
		size = {
			1200,
			0
		}
	},
	tutorial_tooltip_input_field = {
		vertical_alignment = "center",
		parent = "tutorial_tooltip_background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	tutorial_tooltip_unassigned = {
		vertical_alignment = "top",
		parent = "tutorial_tooltip_background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	}
}
local var_0_3 = 0

local function var_0_4(arg_1_0, arg_1_1)
	local var_1_0 = {}

	for iter_1_0 = 1, arg_1_0 do
		local var_1_1 = "input_description_root_" .. iter_1_0
		local var_1_2 = "input_description_" .. iter_1_0
		local var_1_3 = "input_description_prefix_text_" .. iter_1_0
		local var_1_4 = "input_description_suffix_text_" .. iter_1_0
		local var_1_5 = "input_description_button_text_" .. iter_1_0
		local var_1_6 = "input_description_icon_" .. iter_1_0

		var_0_2[var_1_1] = {
			vertical_alignment = "center",
			parent = "tutorial_tooltip_input_field",
			horizontal_alignment = "top",
			size = {
				0,
				0
			},
			position = {
				0,
				-20,
				1
			}
		}
		var_0_2[var_1_2] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = var_1_1,
			size = {
				0,
				0
			},
			position = {
				0,
				-15,
				1
			}
		}
		var_0_2[var_1_5] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = var_1_6,
			size = {
				0,
				40
			},
			position = {
				0,
				0,
				2
			}
		}
		var_0_2[var_1_6] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_1_2,
			size = {
				0,
				40
			},
			position = {
				0,
				0,
				1
			}
		}
		var_0_2[var_1_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_1_6,
			size = {
				0,
				40
			},
			position = {
				0,
				0,
				1
			}
		}
		var_0_2[var_1_4] = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			parent = var_1_6,
			size = {
				0,
				40
			},
			position = {
				0,
				0,
				1
			}
		}

		local var_1_7 = {
			element = {
				passes = {
					{
						style_id = "prefix_text",
						pass_type = "text",
						text_id = "prefix_text",
						retained_mode = var_0_0,
						content_check_function = function(arg_2_0)
							return arg_2_0.prefix_text ~= ""
						end
					},
					{
						style_id = "prefix_text_shadow",
						pass_type = "text",
						text_id = "prefix_text",
						retained_mode = var_0_0,
						content_check_function = function(arg_3_0)
							return arg_3_0.prefix_text ~= ""
						end
					},
					{
						style_id = "suffix_text",
						pass_type = "text",
						text_id = "suffix_text",
						retained_mode = var_0_0,
						content_check_function = function(arg_4_0)
							return arg_4_0.suffix_text ~= ""
						end
					},
					{
						style_id = "suffix_text_shadow",
						pass_type = "text",
						text_id = "suffix_text",
						retained_mode = var_0_0,
						content_check_function = function(arg_5_0)
							return arg_5_0.suffix_text ~= ""
						end
					},
					{
						style_id = "button_text",
						pass_type = "text",
						text_id = "button_text",
						retained_mode = var_0_0,
						content_check_function = function(arg_6_0)
							return arg_6_0.button_text ~= ""
						end
					},
					{
						style_id = "button_text_shadow",
						pass_type = "text",
						text_id = "button_text",
						retained_mode = var_0_0,
						content_check_function = function(arg_7_0)
							return arg_7_0.button_text ~= ""
						end
					},
					{
						pass_type = "multi_texture",
						style_id = "icon",
						texture_id = "icon",
						content_check_function = function(arg_8_0)
							local var_8_0 = arg_8_0.icon

							return var_8_0 and #var_8_0 > 0
						end
					}
				}
			},
			content = {
				prefix_text = "",
				suffix_text = "",
				button_text = ""
			},
			style = {
				prefix_text = {
					word_wrap = false,
					localize = false,
					font_size = 42,
					pixel_perfect = true,
					horizontal_alignment = "right",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", var_0_3),
					offset = {
						0,
						0,
						2
					},
					scenegraph_id = var_1_3
				},
				prefix_text_shadow = {
					word_wrap = false,
					localize = false,
					font_size = 42,
					pixel_perfect = true,
					horizontal_alignment = "right",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("black", var_0_3),
					offset = {
						2,
						-2,
						1
					},
					scenegraph_id = var_1_3
				},
				suffix_text = {
					word_wrap = false,
					localize = false,
					font_size = 42,
					pixel_perfect = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", var_0_3),
					offset = {
						0,
						0,
						2
					},
					scenegraph_id = var_1_4
				},
				suffix_text_shadow = {
					word_wrap = false,
					localize = false,
					font_size = 42,
					pixel_perfect = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("black", var_0_3),
					offset = {
						2,
						-2,
						1
					},
					scenegraph_id = var_1_4
				},
				button_text = {
					word_wrap = false,
					localize = false,
					font_size = 42,
					pixel_perfect = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("font_title", var_0_3),
					offset = {
						0,
						0,
						2
					},
					scenegraph_id = var_1_5
				},
				button_text_shadow = {
					word_wrap = false,
					localize = false,
					font_size = 42,
					pixel_perfect = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("black", var_0_3),
					offset = {
						2,
						-2,
						1
					},
					scenegraph_id = var_1_5
				},
				icon = {
					texture_sizes = {
						{
							20,
							36
						}
					},
					offset = {
						0,
						0,
						1
					},
					color = Colors.get_color_table_with_alpha("white", var_0_3),
					scenegraph_id = var_1_6
				}
			},
			scenegraph_id = var_1_2
		}

		var_1_0[#var_1_0 + 1] = UIWidget.init(var_1_7)
	end

	return var_1_0
end

local var_0_5 = {
	tutorial_tooltip = {
		scenegraph_id = "tutorial_tooltip",
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "divider",
					style_id = "divider",
					pass_type = "texture"
				},
				{
					texture_id = "completed_texture",
					style_id = "completed_texture",
					pass_type = "texture",
					content_check_function = function(arg_9_0)
						return arg_9_0.completed
					end
				},
				{
					texture_id = "completed_texture",
					style_id = "completed_texture_shadow",
					pass_type = "texture",
					content_check_function = function(arg_10_0)
						return arg_10_0.completed
					end
				},
				{
					style_id = "description",
					pass_type = "text",
					text_id = "description"
				},
				{
					style_id = "description_shadow",
					pass_type = "text",
					text_id = "description"
				},
				{
					style_id = "sub_description",
					pass_type = "text",
					text_id = "sub_description"
				},
				{
					style_id = "sub_description_shadow",
					pass_type = "text",
					text_id = "sub_description"
				},
				{
					style_id = "unassigned",
					pass_type = "text",
					text_id = "unassigned_id",
					content_check_function = function(arg_11_0)
						return arg_11_0.unassigned
					end
				},
				{
					style_id = "unassigned_shadow",
					pass_type = "text",
					text_id = "unassigned_id",
					content_check_function = function(arg_12_0)
						return arg_12_0.unassigned
					end
				},
				{
					texture_id = "background",
					style_id = "unassigned_background",
					pass_type = "texture",
					content_check_function = function(arg_13_0)
						return arg_13_0.unassigned
					end
				}
			}
		},
		content = {
			completed_texture = "tutorial_input_completed",
			description = "tutorial_tooltip_advanced_enemy_armor",
			background = "tab_menu_bg_02",
			unassigned_id = "unassigned_keymap",
			completed = false,
			sub_description = "",
			unassigned = false,
			divider = "divider_01_top"
		},
		style = {
			background = {
				scenegraph_id = "tutorial_tooltip_background",
				offset = {
					0,
					0,
					0
				},
				color = {
					var_0_3,
					255,
					255,
					255
				}
			},
			divider = {
				vertical_alignment = "center",
				scenegraph_id = "tutorial_tooltip_background",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				texture_size = {
					264,
					32
				},
				color = {
					var_0_3,
					255,
					255,
					255
				}
			},
			completed_texture = {
				vertical_alignment = "center",
				scenegraph_id = "tutorial_tooltip_background",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					21
				},
				texture_size = {
					408,
					179
				},
				color = Colors.get_color_table_with_alpha("font_title", var_0_3)
			},
			completed_texture_shadow = {
				vertical_alignment = "center",
				scenegraph_id = "tutorial_tooltip_background",
				horizontal_alignment = "center",
				offset = {
					2,
					-2,
					20
				},
				texture_size = {
					408,
					179
				},
				color = Colors.get_color_table_with_alpha("black", var_0_3)
			},
			description = {
				scenegraph_id = "tutorial_tooltip_description",
				localize = true,
				horizontal_alignment = "center",
				word_wrap = false,
				pixel_perfect = true,
				font_size = 52,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", var_0_3),
				offset = {
					0,
					0,
					2
				}
			},
			description_shadow = {
				scenegraph_id = "tutorial_tooltip_description",
				localize = true,
				horizontal_alignment = "center",
				word_wrap = false,
				pixel_perfect = true,
				font_size = 52,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", var_0_3),
				offset = {
					2,
					-2,
					1
				}
			},
			sub_description = {
				scenegraph_id = "tutorial_tooltip_sub_description",
				localize = false,
				horizontal_alignment = "center",
				word_wrap = false,
				pixel_perfect = true,
				font_size = 36,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", var_0_3),
				offset = {
					0,
					0,
					2
				}
			},
			sub_description_shadow = {
				scenegraph_id = "tutorial_tooltip_sub_description",
				localize = false,
				horizontal_alignment = "center",
				word_wrap = false,
				pixel_perfect = true,
				font_size = 36,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", var_0_3),
				offset = {
					2,
					-2,
					1
				}
			},
			unassigned = {
				scenegraph_id = "tutorial_tooltip_unassigned",
				localize = true,
				horizontal_alignment = "center",
				word_wrap = false,
				pixel_perfect = true,
				font_size = 20,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("red", var_0_3),
				offset = {
					0,
					15,
					1
				}
			},
			unassigned_shadow = {
				scenegraph_id = "tutorial_tooltip_unassigned",
				localize = true,
				horizontal_alignment = "center",
				word_wrap = false,
				pixel_perfect = true,
				font_size = 20,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", var_0_3),
				offset = {
					2,
					13,
					0
				}
			},
			unassigned_background = {
				vertical_alignment = "center",
				scenegraph_id = "tutorial_tooltip_unassigned",
				horizontal_alignment = "center",
				offset = {
					0,
					15,
					0
				},
				texture_size = {
					308.25,
					45.75
				},
				color = {
					var_0_3,
					255,
					255,
					255
				}
			}
		}
	}
}
local var_0_6 = var_0_4(var_0_1)

return {
	scenegraph = var_0_2,
	widgets = var_0_5,
	tutorial_tooltip_input_widgets = var_0_6,
	NUMBER_OF_TOOLTIP_INPUT_WIDGETS = var_0_1
}
