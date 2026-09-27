-- chunkname: @scripts/ui/views/ingame_view_definitions.lua

local create_menu_button = UIWidgets.create_menu_button
local create_simple_texture = UIWidgets.create_simple_texture
local create_simple_uv_texture = UIWidgets.create_simple_uv_texture
local num = 18
local tbl = {
	370,
	70
}
local tbl_2 = {
	300,
	70
}
local tbl_3 = {
	0,
	-(70 + num),
	1
}
local num_2 = 24
local str = "menu_frame_03"
local str_2 = "menu_frame_bg_02"

IngameViewDefinitions = {
	MENU_BUTTON_SPACING = num,
	MENU_BUTTON_SIZE = tbl,
	scenegraph_definition = {
		root = {
			is_root = true,
			position = {
				0,
				0,
				UILayer.main_menu
			},
			size = {
				1920,
				1080
			}
		},
		console_cursor = {
			vertical_alignment = "center",
			parent = "root",
			horizontal_alignment = "center",
			position = {
				0,
				0,
				-UILayer.main_menu
			},
			size = {
				1920,
				1080
			}
		},
		screen = {
			vertical_alignment = "center",
			parent = "root",
			horizontal_alignment = "center",
			position = {
				0,
				0,
				0
			},
			size = {
				1920,
				1080
			}
		},
		window = {
			vertical_alignment = "center",
			parent = "screen",
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				1
			},
			size = {
				tbl[1] + 20,
				tbl[2]
			}
		},
		top_panel = {
			vertical_alignment = "top",
			parent = "window",
			horizontal_alignment = "center",
			position = {
				0,
				110,
				-1
			},
			size = {
				260,
				103
			}
		},
		right_chain = {
			vertical_alignment = "top",
			parent = "top_panel",
			horizontal_alignment = "center",
			position = {
				100,
				-90,
				-1
			},
			size = {
				16,
				0
			}
		},
		left_chain = {
			vertical_alignment = "top",
			parent = "top_panel",
			horizontal_alignment = "center",
			position = {
				-100,
				-90,
				-1
			},
			size = {
				16,
				0
			}
		},
		left_chain_end = {
			vertical_alignment = "bottom",
			parent = "left_chain",
			horizontal_alignment = "center",
			position = {
				-1,
				-20,
				1
			},
			size = {
				19,
				20
			}
		},
		button_gamepad_selection = {
			vertical_alignment = "bottom",
			parent = "button_1",
			horizontal_alignment = "center",
			position = {
				0,
				62,
				10
			},
			size = {
				369,
				127
			}
		},
		dead_space_filler = {
			scale = "fit",
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
		logo = {
			vertical_alignment = "top",
			parent = "screen",
			horizontal_alignment = "left",
			size = {
				390,
				197
			},
			position = {
				45,
				-45,
				1
			}
		},
		button_1 = {
			vertical_alignment = "top",
			parent = "window",
			horizontal_alignment = "center",
			size = tbl,
			position = {
				0,
				-10,
				1
			}
		},
		button_2 = {
			vertical_alignment = "bottom",
			parent = "button_1",
			horizontal_alignment = "center",
			size = tbl,
			position = tbl_3
		},
		button_3 = {
			vertical_alignment = "bottom",
			parent = "button_2",
			horizontal_alignment = "center",
			size = tbl,
			position = tbl_3
		},
		button_4 = {
			vertical_alignment = "bottom",
			parent = "button_3",
			horizontal_alignment = "center",
			size = tbl,
			position = tbl_3
		},
		button_5 = {
			vertical_alignment = "bottom",
			parent = "button_4",
			horizontal_alignment = "center",
			size = tbl,
			position = tbl_3
		},
		button_6 = {
			vertical_alignment = "bottom",
			parent = "button_5",
			horizontal_alignment = "center",
			size = tbl,
			position = tbl_3
		},
		button_7 = {
			vertical_alignment = "bottom",
			parent = "button_6",
			horizontal_alignment = "center",
			size = tbl,
			position = tbl_3
		},
		button_8 = {
			vertical_alignment = "bottom",
			parent = "button_7",
			horizontal_alignment = "center",
			size = tbl,
			position = tbl_3
		},
		button_9 = {
			vertical_alignment = "bottom",
			parent = "button_8",
			horizontal_alignment = "center",
			size = tbl,
			position = tbl_3
		}
	},
	widgets = {
		logo = UIWidgets.create_simple_texture("hero_view_home_logo", "logo"),
		background = {
			scenegraph_id = "dead_space_filler",
			element = UIElements.SimpleTexture,
			content = {
				texture_id = "gradient_dice_game_reward"
			},
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		button_1 = UIWidgets.create_default_button("button_1", tbl, nil, nil, "n/a", num_2),
		button_2 = UIWidgets.create_default_button("button_2", tbl, nil, nil, "n/a", num_2),
		button_3 = UIWidgets.create_default_button("button_3", tbl, nil, nil, "n/a", num_2),
		button_4 = UIWidgets.create_default_button("button_4", tbl, nil, nil, "n/a", num_2),
		button_5 = UIWidgets.create_default_button("button_5", tbl, nil, nil, "n/a", num_2),
		button_6 = UIWidgets.create_default_button("button_6", tbl, nil, nil, "n/a", num_2),
		button_7 = UIWidgets.create_default_button("button_7", tbl, nil, nil, "n/a", num_2),
		button_8 = UIWidgets.create_default_button("button_8", tbl, nil, nil, "n/a", num_2),
		button_9 = UIWidgets.create_default_button("button_9", tbl, nil, nil, "n/a", num_2),
		gamepad_button_selection = UIWidgets.create_gamepad_selection("button_gamepad_selection", nil, nil, {
			70,
			70
		}),
		console_cursor = UIWidgets.create_console_cursor("console_cursor"),
		top_panel = UIWidgets.create_simple_texture("esc_menu_top", "top_panel"),
		left_chain_end = UIWidgets.create_simple_texture("chain_link_02", "left_chain_end"),
		left_chain = UIWidgets.create_tiled_texture("left_chain", "chain_link_01", {
			16,
			19
		}),
		right_chain = UIWidgets.create_tiled_texture("right_chain", "chain_link_01", {
			16,
			19
		})
	}
}
