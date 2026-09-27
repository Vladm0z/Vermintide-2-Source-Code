-- chunkname: @scripts/ui/views/tutorial_tooltip_ui_definitions.lua

local flag = true
local num = 4
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

local function fn(arg_1_0)
	-- function 1
	local tbl_2 = {}

	for i = 1, arg_1_0 do
		local str = "input_description_root_" .. i
		local str_2 = "input_description_" .. i
		local str_3 = "input_description_prefix_text_" .. i
		local str_4 = "input_description_suffix_text_" .. i
		local str_5 = "input_description_button_text_" .. i
		local str_6 = "input_description_icon_" .. i

		tbl[str] = {
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
		tbl[str_2] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = str,
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
		tbl[str_5] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = str_6,
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
		tbl[str_6] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str_2,
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
		tbl[str_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str_6,
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
		tbl[str_4] = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			parent = str_6,
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

		local tbl_3 = {
			element = {
				passes = {
					{
						style_id = "prefix_text",
						pass_type = "text",
						text_id = "prefix_text",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 2
							return self.prefix_text ~= ""
						end
					},
					{
						style_id = "suffix_text",
						pass_type = "text",
						text_id = "suffix_text",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 3
							return self.suffix_text ~= ""
						end
					},
					{
						style_id = "button_text",
						pass_type = "text",
						text_id = "button_text",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 4
							return self.button_text ~= ""
						end
					},
					{
						pass_type = "multi_texture",
						style_id = "icon",
						texture_id = "icon",
						content_check_function = function (self)
							-- function 5
							local icon = self.icon

							return not icon and #icon > 0
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
					scenegraph_id = str_3
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
					scenegraph_id = str_4
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
					scenegraph_id = str_5
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
					scenegraph_id = str_6
				}
			},
			scenegraph_id = str_2
		}

		tbl_2[#tbl_2 + 1] = UIWidget.init(tbl_3)
	end

	return tbl_2
end

local tbl_2 = {
	tutorial_tooltip = {
		scenegraph_id = "tutorial_tooltip",
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "rotated_texture",
					retained_mode = flag
				},
				{
					style_id = "description",
					pass_type = "text",
					text_id = "description",
					retained_mode = flag
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
local var_0_5 = fn(num)

return {
	scenegraph = tbl,
	widgets = tbl_2,
	tutorial_tooltip_input_widgets = var_0_5,
	NUMBER_OF_TOOLTIP_INPUT_WIDGETS = num
}
