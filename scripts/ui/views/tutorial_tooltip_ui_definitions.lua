-- chunkname: @scripts/ui/views/tutorial_tooltip_ui_definitions.lua

local var_0_0 = true
local var_0_1 = 4
local var_0_2 = {
	root = {
		is_root = true,
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
	screen_fit = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.tutorial
		},
		size = {
			1920,
			1080
		}
	},
	tutorial_tooltip_root = {
		vertical_alignment = "center",
		parent = "root",
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
			-330,
			10
		},
		size = {
			0,
			0
		}
	},
	tutorial_tooltip_description = {
		vertical_alignment = "bottom",
		parent = "tutorial_tooltip",
		horizontal_alignment = "center",
		position = {
			0,
			25,
			1
		},
		size = {
			400,
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
			482,
			80
		}
	},
	tutorial_tooltip_input_field = {
		vertical_alignment = "top",
		parent = "tutorial_tooltip",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			1920,
			0
		}
	}
}

local function var_0_3(arg_1_0)
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
				0,
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
						content_check_function = function (arg_2_0)
							return arg_2_0.prefix_text ~= ""
						end
					},
					{
						style_id = "suffix_text",
						pass_type = "text",
						text_id = "suffix_text",
						retained_mode = var_0_0,
						content_check_function = function (arg_3_0)
							return arg_3_0.suffix_text ~= ""
						end
					},
					{
						style_id = "button_text",
						pass_type = "text",
						text_id = "button_text",
						retained_mode = var_0_0,
						content_check_function = function (arg_4_0)
							return arg_4_0.button_text ~= ""
						end
					},
					{
						pass_type = "multi_texture",
						style_id = "icon",
						texture_id = "icon",
						content_check_function = function (arg_5_0)
							local var_5_0 = arg_5_0.icon

							return var_5_0 and #var_5_0 > 0
						end
					}
				}
			},
			content = {
				prefix_text = "",
				suffix_text = "",
				button_text = "",
				icon = {
					"pc_button_icon_left"
				}
			},
			style = {
				prefix_text = {
					word_wrap = false,
					localize = false,
					font_size = 24,
					pixel_perfect = true,
					horizontal_alignment = "right",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", 255),
					offset = {
						0,
						0,
						1
					},
					scenegraph_id = var_1_3
				},
				suffix_text = {
					word_wrap = false,
					localize = false,
					font_size = 24,
					pixel_perfect = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", 255),
					offset = {
						0,
						0,
						1
					},
					scenegraph_id = var_1_4
				},
				button_text = {
					word_wrap = false,
					localize = false,
					font_size = 24,
					pixel_perfect = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", 255),
					offset = {
						0,
						0,
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
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = var_1_6
				}
			},
			scenegraph_id = var_1_2
		}

		var_1_0[#var_1_0 + 1] = UIWidget.init(var_1_7)
	end

	return var_1_0
end

local var_0_4 = {
	tutorial_tooltip = {
		scenegraph_id = "tutorial_tooltip",
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "rotated_texture",
					retained_mode = var_0_0
				},
				{
					style_id = "description",
					pass_type = "text",
					text_id = "description",
					retained_mode = var_0_0
				}
			}
		},
		content = {
			background = "hud_difficulty_unlocked_bg",
			description = "tutorial_tooltip_advanced_enemy_armor"
		},
		style = {
			background = {
				scenegraph_id = "tutorial_tooltip_background",
				offset = {
					0,
					0,
					1
				},
				pivot = {
					241,
					40
				},
				angle = math.pi,
				color = {
					255,
					255,
					255,
					255
				}
			},
			description = {
				scenegraph_id = "tutorial_tooltip_description",
				localize = true,
				horizontal_alignment = "center",
				word_wrap = false,
				pixel_perfect = true,
				font_size = 24,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			}
		}
	}
}
local var_0_5 = var_0_3(var_0_1)

return {
	scenegraph = var_0_2,
	widgets = var_0_4,
	tutorial_tooltip_input_widgets = var_0_5,
	NUMBER_OF_TOOLTIP_INPUT_WIDGETS = var_0_1
}
