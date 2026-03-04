-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_grid_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = var_0_0.spacing
local var_0_4 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_5 = var_0_2[1] - (var_0_4 * 2 + 60)
local var_0_6 = {
	var_0_2[1] * 2 + var_0_3,
	var_0_2[2]
}
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
		size = var_0_2,
		position = {
			0,
			0,
			1
		}
	},
	actual_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = var_0_6,
		position = {
			0,
			0,
			1
		}
	},
	item_grid = {
		vertical_alignment = "center",
		parent = "actual_window",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			0,
			20,
			3
		}
	},
	title_text_detail = {
		vertical_alignment = "top",
		parent = "actual_window",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			21,
			10
		}
	},
	title_text_detail_glow = {
		vertical_alignment = "top",
		parent = "title_text_detail",
		horizontal_alignment = "center",
		size = {
			544,
			16
		},
		position = {
			0,
			5,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title_text_detail",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			50
		},
		position = {
			0,
			25,
			1
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			var_0_2[2] / 2
		},
		position = {
			0,
			0,
			1
		}
	},
	page_button_next = {
		vertical_alignment = "bottom",
		parent = "actual_window",
		horizontal_alignment = "right",
		size = {
			var_0_6[1] * 0.4,
			42
		},
		position = {
			0,
			0,
			1
		}
	},
	page_button_edge_right = {
		vertical_alignment = "center",
		parent = "page_button_next",
		horizontal_alignment = "left",
		size = {
			0,
			42
		},
		position = {
			0,
			0,
			10
		}
	},
	page_button_previous = {
		vertical_alignment = "bottom",
		parent = "actual_window",
		horizontal_alignment = "left",
		size = {
			var_0_6[1] * 0.4,
			42
		},
		position = {
			0,
			0,
			1
		}
	},
	page_button_edge_left = {
		vertical_alignment = "center",
		parent = "page_button_previous",
		horizontal_alignment = "right",
		size = {
			0,
			42
		},
		position = {
			0,
			0,
			10
		}
	},
	page_button_divider = {
		vertical_alignment = "bottom",
		parent = "actual_window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1],
			0
		},
		position = {
			0,
			42,
			14
		}
	},
	page_text_area = {
		vertical_alignment = "bottom",
		parent = "actual_window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1] * 0.2,
			42
		},
		position = {
			0,
			0,
			3
		}
	}
}
local var_0_8 = {
	vertical_alignment = "center",
	font_size = 20,
	localize = false,
	horizontal_alignment = "right",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-(var_0_6[1] * 0.1 + 5),
		4,
		2
	}
}
local var_0_9 = {
	vertical_alignment = "center",
	font_size = 20,
	localize = false,
	horizontal_alignment = "left",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		var_0_6[1] * 0.1 + 4,
		4,
		2
	}
}
local var_0_10 = {
	vertical_alignment = "center",
	font_size = 20,
	localize = false,
	horizontal_alignment = "center",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		4,
		2
	}
}

local function var_0_11(arg_1_0, arg_1_1)
	return {
		element = {
			passes = {
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge_holder_right = "menu_frame_09_divider_right",
			edge_holder_left = "menu_frame_09_divider_left",
			bottom_edge = "menu_frame_09_divider"
		},
		style = {
			bottom_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					0,
					6
				},
				size = {
					arg_1_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_1_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			edge_holder_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
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

local function var_0_12(arg_2_0, arg_2_1)
	return {
		element = {
			passes = {
				{
					texture_id = "edge",
					style_id = "edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_top",
					style_id = "edge_holder_top",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_bottom",
					style_id = "edge_holder_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge = "menu_frame_09_divider_vertical",
			edge_holder_top = "menu_frame_09_divider_top",
			edge_holder_bottom = "menu_frame_09_divider_bottom"
		},
		style = {
			edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					6,
					6
				},
				size = {
					5,
					arg_2_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_2_1[2] - 9
				}
			},
			edge_holder_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					arg_2_1[2] - 7,
					10
				},
				size = {
					17,
					9
				}
			},
			edge_holder_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					3,
					10
				},
				size = {
					17,
					9
				}
			}
		},
		scenegraph_id = arg_2_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_13 = {
	item_grid = UIWidgets.create_grid("item_grid", var_0_7.item_grid.size, 8, 11, 12, 12, true),
	window_frame = UIWidgets.create_frame("actual_window", var_0_6, var_0_1, 10),
	window = UIWidgets.create_tiled_texture("actual_window", "background_leather_02", {
		520,
		820
	}, nil, nil, {
		255,
		255,
		255,
		255
	}),
	window_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "actual_window", nil, nil, nil, 1),
	page_button_next = UIWidgets.create_simple_window_button("page_button_next", var_0_7.page_button_next.size, Localize("menu_next"), 16),
	page_button_previous = UIWidgets.create_simple_window_button("page_button_previous", var_0_7.page_button_previous.size, Localize("menu_previous"), 16),
	page_button_divider = var_0_11("page_button_divider", var_0_7.page_button_divider.size),
	page_button_edge_left = var_0_12("page_button_edge_left", var_0_7.page_button_edge_left.size),
	page_button_edge_right = var_0_12("page_button_edge_right", var_0_7.page_button_edge_right.size),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, var_0_10),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_8),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_9),
	page_text_area = UIWidgets.create_simple_rect("page_text_area", {
		255,
		0,
		0,
		0
	})
}

return {
	widgets = var_0_13,
	scenegraph_definition = var_0_7
}
