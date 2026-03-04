-- chunkname: @scripts/ui/views/deus_menu/deus_map_ui_definitions_v2.lua

require("scripts/ui/views/deus_menu/ui_widgets_deus")

local var_0_0 = false
local var_0_1 = true
local var_0_2 = {
	UISettings.INSIGNIA_OFFSET + 20,
	-55,
	1
}
local var_0_3 = {
	-35,
	0,
	1
}
local var_0_4 = {
	0,
	0,
	2
}
local var_0_5 = {
	50 + UISettings.INSIGNIA_OFFSET + 20 + 10,
	20,
	0
}
local var_0_6 = {
	1920,
	1080
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
	screen = {
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
	top_info = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			64
		},
		position = {
			0,
			0,
			1
		}
	},
	general_info = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			700,
			150
		},
		position = {
			0,
			-200,
			1
		}
	},
	console_cursor = {
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
			100
		}
	},
	node_info_pivot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-4000,
			10
		}
	},
	node_info = {
		vertical_alignment = "center",
		parent = "node_info_pivot",
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
	window = {
		parent = "screen"
	},
	player_pivot = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			75,
			-120,
			1
		}
	},
	player_1 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			75,
			150,
			5
		}
	},
	player_1_portrait = {
		vertical_alignment = "center",
		parent = "player_1",
		horizontal_alignment = "center",
		position = var_0_2,
		size = {
			0,
			0
		}
	},
	player_1_insignia = {
		vertical_alignment = "top",
		parent = "player_1",
		horizontal_alignment = "left",
		position = var_0_3,
		size = {
			0,
			0
		}
	},
	player_1_texts = {
		vertical_alignment = "center",
		parent = "player_1",
		horizontal_alignment = "center",
		position = var_0_5,
		size = {
			0,
			0
		}
	},
	player_1_frame = {
		vertical_alignment = "center",
		parent = "player_1",
		horizontal_alignment = "center",
		position = var_0_4,
		size = {
			0,
			0
		}
	},
	player_2 = {
		vertical_alignment = "top",
		parent = "player_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-220 * 0,
			1
		}
	},
	player_2_portrait = {
		vertical_alignment = "center",
		parent = "player_2",
		horizontal_alignment = "center",
		position = var_0_2,
		size = {
			0,
			0
		}
	},
	player_2_insignia = {
		vertical_alignment = "top",
		parent = "player_2",
		horizontal_alignment = "left",
		position = var_0_3,
		size = {
			0,
			0
		}
	},
	player_2_texts = {
		vertical_alignment = "center",
		parent = "player_2",
		horizontal_alignment = "center",
		position = var_0_5,
		size = {
			0,
			0
		}
	},
	player_2_frame = {
		vertical_alignment = "center",
		parent = "player_2",
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
	player_3 = {
		vertical_alignment = "top",
		parent = "player_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-220,
			1
		}
	},
	player_3_portrait = {
		vertical_alignment = "center",
		parent = "player_3",
		horizontal_alignment = "center",
		position = var_0_2,
		size = {
			0,
			0
		}
	},
	player_3_insignia = {
		vertical_alignment = "top",
		parent = "player_3",
		horizontal_alignment = "left",
		position = var_0_3,
		size = {
			0,
			0
		}
	},
	player_3_texts = {
		vertical_alignment = "center",
		parent = "player_3",
		horizontal_alignment = "center",
		position = var_0_5,
		size = {
			0,
			0
		}
	},
	player_3_frame = {
		vertical_alignment = "center",
		parent = "player_3",
		horizontal_alignment = "center",
		position = var_0_4,
		size = {
			0,
			0
		}
	},
	player_4 = {
		vertical_alignment = "top",
		parent = "player_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-440,
			1
		}
	},
	player_4_portrait = {
		vertical_alignment = "center",
		parent = "player_4",
		horizontal_alignment = "center",
		position = var_0_2,
		size = {
			0,
			0
		}
	},
	player_4_insignia = {
		vertical_alignment = "top",
		parent = "player_4",
		horizontal_alignment = "left",
		position = var_0_3,
		size = {
			0,
			0
		}
	},
	player_4_texts = {
		vertical_alignment = "center",
		parent = "player_4",
		horizontal_alignment = "center",
		position = var_0_5,
		size = {
			0,
			0
		}
	},
	player_4_frame = {
		vertical_alignment = "center",
		parent = "player_4",
		horizontal_alignment = "center",
		position = var_0_4,
		size = {
			0,
			0
		}
	},
	boon_root = {
		parent = "window",
		position = {
			-400,
			0,
			0
		}
	},
	options_background_mask_left = {
		vertical_alignment = "center",
		parent = "boon_root",
		horizontal_alignment = "left",
		size = {
			585,
			var_0_6[2]
		},
		position = {
			-225,
			0,
			6
		}
	},
	options_background_left = {
		vertical_alignment = "center",
		parent = "boon_root",
		horizontal_alignment = "left",
		size = {
			350,
			var_0_6[2]
		},
		position = {
			0,
			0,
			1
		}
	},
	options_window_edge_left = {
		vertical_alignment = "center",
		parent = "options_background_left",
		horizontal_alignment = "left",
		size = {
			0,
			var_0_6[2]
		},
		position = {
			-225,
			0,
			6
		}
	},
	options_background_edge_left = {
		vertical_alignment = "center",
		parent = "options_window_edge_left",
		horizontal_alignment = "left",
		size = {
			126,
			var_0_6[2]
		},
		position = {
			443,
			0,
			-5
		}
	},
	top_options_background_left = {
		vertical_alignment = "top",
		parent = "options_window_edge_left",
		horizontal_alignment = "left",
		size = {
			351,
			111
		},
		position = {
			225,
			0,
			10
		}
	},
	boons_text = {
		vertical_alignment = "center",
		parent = "top_options_background_left",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		}
	},
	own_power_up_root = {
		vertical_alignment = "top",
		parent = "boon_root",
		horizontal_alignment = "left",
		size = {
			64,
			64
		},
		position = {
			45,
			-90,
			7
		}
	},
	own_power_up_anchor = {
		parent = "own_power_up_root",
		position = {
			0,
			0,
			0
		}
	},
	scrollbar_anchor = {
		vertical_alignment = "top",
		parent = "boon_root",
		horizontal_alignment = "left",
		position = {
			50,
			-90,
			7
		},
		size = {
			200,
			735
		}
	},
	own_power_up_window = {
		parent = "scrollbar_anchor",
		position = {
			-20,
			0,
			0
		}
	},
	power_up_description_root = {
		size = {
			484,
			194
		},
		position = {
			0,
			0,
			UILayer.end_screen + 200
		}
	},
	input_helper_text = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center"
	}
}
local var_0_8 = {
	use_shadow = true,
	upper_case = true,
	localize = true,
	font_size = 28,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		80,
		15,
		2
	},
	area_size = {
		326,
		135
	}
}
local var_0_9 = {
	font_size = 35,
	upper_case = true,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		50,
		2
	}
}

local function var_0_10(arg_1_0)
	local var_1_0 = UIFrameSettings.frame_outer_fade_02.texture_sizes.horizontal[2]
	local var_1_1 = var_0_7[arg_1_0].size

	return {
		element = {
			passes = {
				{
					retained_mode = false,
					style_id = "time",
					pass_type = "text",
					text_id = "time"
				}
			}
		},
		content = {
			time = "00:00"
		},
		style = {
			time = {
				vertical_alignment = "top",
				scenegraph_id = "screen",
				localize = false,
				horizontal_alignment = "center",
				font_size = 64,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-110,
					1
				}
			}
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_11(arg_2_0)
	local var_2_0 = UIFrameSettings.frame_outer_fade_02
	local var_2_1 = var_2_0.texture_sizes.horizontal[2]
	local var_2_2 = var_0_7[arg_2_0].size
	local var_2_3 = {
		var_2_2[1] + var_2_1 * 2,
		var_2_2[2] + var_2_1 * 2
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "rect",
					style_id = "rect"
				},
				{
					style_id = "title",
					pass_type = "text",
					text_id = "title"
				},
				{
					style_id = "journey_name_label",
					pass_type = "text",
					text_id = "journey_name_label"
				}
			}
		},
		content = {
			title = "deus_map_title",
			journey_name_label = "journey_cave_name",
			frame = var_2_0.texture
		},
		style = {
			frame = {
				only_corners = false,
				color = UISettings.console_menu_rect_color,
				size = var_2_3,
				texture_size = var_2_0.texture_size,
				texture_sizes = var_2_0.texture_sizes,
				offset = {
					-var_2_1,
					-var_2_1,
					0
				}
			},
			rect = {
				color = UISettings.console_menu_rect_color,
				offset = {
					0,
					0,
					0
				}
			},
			title = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				localize = true,
				font_size = 32,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					-4,
					0
				}
			},
			journey_name_label = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				localize = true,
				font_size = 32,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-34,
					1
				}
			}
		},
		scenegraph_id = arg_2_0
	}
end

local var_0_12 = {
	offset = {
		10,
		-30,
		0
	},
	texture_size = {
		20,
		20
	}
}

local function var_0_13(arg_3_0)
	local var_3_0 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		dynamic_font_size = true,
		font_size = 24,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			10,
			0,
			0
		},
		size = {
			180,
			24
		}
	}
	local var_3_1 = table.clone(var_3_0)

	var_3_1.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_3_1.offset = {
		var_3_0.offset[1] + 2,
		var_3_0.offset[2] - 2,
		var_3_0.offset[3] - 1
	}

	local var_3_2 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		dynamic_font_size = true,
		font_size = 26,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_0_12.offset[1] + var_0_12.texture_size[1] + 5,
			var_0_12.offset[2] - 1,
			var_0_12.offset[3]
		},
		size = {
			100,
			20
		}
	}
	local var_3_3 = table.clone(var_3_2)

	var_3_3.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_3_3.offset = {
		var_3_2.offset[1] + 2,
		var_3_2.offset[2] - 2,
		var_3_2.offset[3] - 1
	}

	return {
		element = {
			passes = {
				{
					style_id = "name_text",
					pass_type = "text",
					text_id = "name_text",
					content_check_function = function(arg_4_0)
						return arg_4_0.visible
					end
				},
				{
					style_id = "name_text_shadow",
					pass_type = "text",
					text_id = "name_text",
					content_check_function = function(arg_5_0)
						return arg_5_0.visible
					end
				},
				{
					style_id = "coins_text",
					pass_type = "text",
					text_id = "coins_text",
					content_check_function = function(arg_6_0)
						return arg_6_0.visible
					end
				},
				{
					style_id = "coins_text_shadow",
					pass_type = "text",
					text_id = "coins_text",
					content_check_function = function(arg_7_0)
						return arg_7_0.visible
					end
				},
				{
					pass_type = "texture",
					style_id = "coins_icon",
					texture_id = "coins_icon",
					content_check_function = function(arg_8_0)
						return arg_8_0.visible
					end
				}
			}
		},
		content = {
			visible = true,
			coins_text = "0",
			name_text = "",
			coins_icon = "deus_icons_coin"
		},
		style = {
			name_text = var_3_0,
			name_text_shadow = var_3_1,
			coins_text = var_3_2,
			coins_text_shadow = var_3_3,
			coins_icon = var_0_12
		},
		scenegraph_id = arg_3_0
	}
end

local function var_0_14(arg_9_0)
	return {
		element = {
			passes = {
				{
					style_id = "node_info",
					pass_type = "auto_layout",
					content_id = "node_info",
					sub_passes = {
						{
							style_id = "none_modifier_info",
							pass_type = "auto_layout",
							text_id = "none_modifier_info",
							content_id = "none_modifier_info",
							sub_passes = {
								{
									style_id = "title",
									pass_type = "text",
									text_id = "title"
								},
								{
									style_id = "click_to_vote",
									pass_type = "text",
									text_id = "click_to_vote",
									content_check_function = function(arg_10_0)
										return arg_10_0.click_to_vote ~= ""
									end
								},
								{
									pass_type = "texture",
									style_id = "pre_description_divider",
									texture_id = "pre_description_divider"
								},
								{
									style_id = "description",
									pass_type = "text",
									text_id = "description"
								},
								{
									pass_type = "texture",
									style_id = "post_description_divider",
									texture_id = "post_description_divider"
								}
							}
						},
						{
							style_id = "curse_section",
							pass_type = "auto_layout",
							content_check_function = function(arg_11_0)
								return arg_11_0.curse_text ~= ""
							end,
							sub_passes = {
								{
									texture_id = "curse_icon",
									style_id = "curse_icon",
									pass_type = "texture"
								},
								{
									style_id = "curse_text",
									pass_type = "text",
									text_id = "curse_text"
								}
							}
						},
						{
							style_id = "breed_section",
							pass_type = "auto_layout",
							content_check_function = function(arg_12_0)
								return arg_12_0.breed_text ~= ""
							end,
							sub_passes = {
								{
									texture_id = "breed_icon",
									style_id = "breed_icon",
									pass_type = "texture"
								},
								{
									style_id = "breed_text",
									pass_type = "text",
									text_id = "breed_text"
								}
							}
						},
						{
							style_id = "minor_modifier_section",
							pass_type = "auto_layout",
							content_id = "minor_modifier_1_section",
							content_check_function = function(arg_13_0)
								return arg_13_0.text ~= ""
							end,
							sub_passes = {
								{
									texture_id = "icon",
									style_id = "icon",
									pass_type = "texture"
								},
								{
									style_id = "text",
									pass_type = "text",
									text_id = "text"
								}
							}
						},
						{
							style_id = "minor_modifier_section",
							pass_type = "auto_layout",
							content_id = "minor_modifier_2_section",
							content_check_function = function(arg_14_0)
								return arg_14_0.text ~= ""
							end,
							sub_passes = {
								{
									texture_id = "icon",
									style_id = "icon",
									pass_type = "texture"
								},
								{
									style_id = "text",
									pass_type = "text",
									text_id = "text"
								}
							}
						},
						{
							style_id = "minor_modifier_section",
							pass_type = "auto_layout",
							content_id = "minor_modifier_3_section",
							content_check_function = function(arg_15_0)
								return arg_15_0.text ~= ""
							end,
							sub_passes = {
								{
									texture_id = "icon",
									style_id = "icon",
									pass_type = "texture"
								},
								{
									style_id = "text",
									pass_type = "text",
									text_id = "text"
								}
							}
						},
						{
							style_id = "terror_event_power_up_section",
							pass_type = "auto_layout",
							content_check_function = function(arg_16_0)
								return arg_16_0.terror_event_power_up_text ~= ""
							end,
							sub_passes = {
								{
									texture_id = "terror_event_power_up_icon",
									style_id = "terror_event_power_up_icon",
									pass_type = "texture"
								},
								{
									style_id = "terror_event_power_up_text",
									pass_type = "text",
									text_id = "terror_event_power_up_text"
								}
							}
						}
					},
					background_passes = {
						{
							style_id = "frame",
							pass_type = "texture_frame",
							texture_id = "frame",
							content_change_function = function(arg_17_0, arg_17_1)
								arg_17_0.frame = UIFrameSettings[arg_17_0.frame_settings_name].texture
								arg_17_1.texture_size = UIFrameSettings[arg_17_0.frame_settings_name].texture_size
								arg_17_1.texture_sizes = UIFrameSettings[arg_17_0.frame_settings_name].texture_sizes
							end
						},
						{
							pass_type = "rect",
							style_id = "bg"
						}
					}
				}
			}
		},
		content = {
			node_info = {
				terror_event_power_up_text = "terror_event_power_up_text",
				curse_icon = "deus_icons_map_khorne",
				frame_settings_name = "menu_frame_12",
				breed_text = "breed_text",
				curse_text = "curse_text",
				terror_event_power_up_icon = "mutator_icon_elite_run",
				breed_icon = "mutator_icon_elite_run",
				none_modifier_info = {
					description = "description",
					post_description_divider = "weave_forge_slot_divider_tooltip",
					pre_description_divider = "weave_forge_slot_divider_tooltip",
					title = "title",
					click_to_vote = "click_to_vote"
				},
				minor_modifier_1_section = {
					text = "minor_modifier_text",
					icon = "trinket_increase_grenade_radius"
				},
				minor_modifier_2_section = {
					text = "minor_modifier_text",
					icon = "trinket_increase_grenade_radius"
				},
				minor_modifier_3_section = {
					text = "minor_modifier_text",
					icon = "trinket_increase_grenade_radius"
				}
			}
		},
		style = {
			node_info = {
				layout_delta_x = 0,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				layout_delta_y = -1,
				offset = {
					-50,
					50,
					0
				},
				screen_padding = {
					top = 50,
					left = 50,
					right = 50
				},
				none_modifier_info = {
					layout_delta_y = -1,
					layout_delta_x = 0,
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					dynamic_size = true,
					title = {
						font_size = 28,
						horizontal_alignment = "center",
						localize = false,
						word_wrap = true,
						vertical_alignment = "bottom",
						dynamic_size = true,
						font_type = "hell_shark_header",
						text_color = Colors.get_color_table_with_alpha("font_title", 255),
						offset = {
							0,
							0,
							0
						},
						size = {
							300,
							0
						}
					},
					click_to_vote = {
						font_size = 18,
						horizontal_alignment = "center",
						localize = true,
						word_wrap = true,
						vertical_alignment = "bottom",
						dynamic_size = true,
						font_type = "hell_shark",
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						offset = {
							0,
							0,
							0
						},
						size = {
							300,
							0
						}
					},
					pre_description_divider = {
						layout_bottom_padding = 4,
						layout_top_padding = 4,
						horizontal_alignment = "center",
						height_margin = 5,
						vertical_alignment = "bottom",
						texture_size = {
							200,
							3
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
						},
						size = {
							300,
							3
						}
					},
					description = {
						font_size = 18,
						horizontal_alignment = "center",
						localize = false,
						word_wrap = true,
						vertical_alignment = "center",
						dynamic_size = true,
						font_type = "hell_shark",
						text_color = {
							255,
							120,
							120,
							120
						},
						offset = {
							0,
							0,
							0
						},
						size = {
							300,
							0
						}
					},
					post_description_divider = {
						layout_bottom_padding = 4,
						layout_top_padding = 4,
						horizontal_alignment = "center",
						height_margin = 5,
						vertical_alignment = "center",
						texture_size = {
							200,
							3
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
						},
						size = {
							300,
							3
						}
					}
				},
				curse_section = {
					dynamic_size = true,
					layout_delta_y = 0,
					layout_delta_x = 1,
					curse_icon = {
						layout_left_padding = 4,
						layout_right_padding = 4,
						horizontal_alignment = "left",
						height_margin = 0,
						vertical_alignment = "center",
						texture_size = {
							30,
							30
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
						},
						size = {
							30,
							30
						}
					},
					curse_text = {
						font_size = 20,
						word_wrap = false,
						localize = false,
						dynamic_width = true,
						horizontal_alignment = "left",
						vertical_alignment = "center",
						font_type = "hell_shark",
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						offset = {
							0,
							0,
							0
						},
						size = {
							250,
							30
						}
					}
				},
				minor_modifier_section = {
					layout_delta_y = 0,
					dynamic_size = true,
					layout_delta_x = 1,
					icon = {
						layout_left_padding = 4,
						layout_right_padding = 4,
						horizontal_alignment = "left",
						height_margin = 0,
						vertical_alignment = "center",
						texture_size = {
							30,
							30
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
						},
						size = {
							30,
							30
						}
					},
					text = {
						font_size = 20,
						word_wrap = false,
						localize = false,
						dynamic_width = true,
						horizontal_alignment = "left",
						vertical_alignment = "center",
						font_type = "hell_shark",
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						offset = {
							0,
							0,
							0
						},
						size = {
							250,
							30
						}
					}
				},
				breed_section = {
					dynamic_size = true,
					layout_delta_y = 0,
					layout_delta_x = 1,
					breed_icon = {
						layout_left_padding = 4,
						layout_right_padding = 4,
						horizontal_alignment = "left",
						height_margin = 0,
						vertical_alignment = "center",
						texture_size = {
							30,
							30
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
						},
						size = {
							30,
							30
						}
					},
					breed_text = {
						font_size = 20,
						word_wrap = false,
						localize = false,
						dynamic_width = true,
						horizontal_alignment = "left",
						vertical_alignment = "center",
						font_type = "hell_shark",
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						offset = {
							0,
							0,
							0
						},
						size = {
							250,
							30
						}
					}
				},
				terror_event_power_up_section = {
					layout_delta_y = 0,
					dynamic_size = true,
					layout_delta_x = 1,
					terror_event_power_up_icon = {
						layout_left_padding = 4,
						layout_right_padding = 4,
						horizontal_alignment = "left",
						height_margin = 0,
						vertical_alignment = "center",
						texture_size = {
							30,
							30
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
						},
						size = {
							30,
							30
						}
					},
					terror_event_power_up_text = {
						font_size = 20,
						word_wrap = false,
						localize = false,
						dynamic_width = true,
						horizontal_alignment = "left",
						vertical_alignment = "center",
						font_type = "hell_shark",
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						offset = {
							0,
							0,
							0
						},
						size = {
							250,
							30
						}
					}
				},
				bg = {
					layout_left_padding = 10,
					layout_top_padding = 10,
					layout_right_padding = 10,
					layout_bottom_padding = 10,
					color = {
						255,
						3,
						3,
						3
					},
					offset = {
						0,
						0,
						-5
					}
				},
				frame = {
					layout_left_padding = 10,
					layout_top_padding = 10,
					layout_right_padding = 10,
					layout_bottom_padding = 10,
					offset = {
						0,
						0,
						-3
					}
				}
			}
		},
		scenegraph_id = arg_9_0
	}
end

local var_0_15 = {
	switch_to_portraits = {
		{
			name = "animate_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end,
			update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = math.easeOutCubic(arg_19_3)

				arg_19_0.boon_root.local_position[1] = math.lerp(arg_19_0.boon_root.local_position[1], arg_19_1.boon_root.position[1], var_19_0)
			end,
			on_complete = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		},
		{
			name = "animate_in",
			start_progress = 0.1,
			end_progress = 0.3,
			init = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end,
			update = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				local var_22_0 = math.easeOutCubic(arg_22_3)

				for iter_22_0 = 2, 4 do
					local var_22_1 = "player_" .. iter_22_0

					arg_22_0[var_22_1].local_position[1] = math.lerp(arg_22_0[var_22_1].local_position[1], arg_22_1[var_22_1].position[1], var_22_0)
				end
			end,
			on_complete = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				local var_23_0 = 0
			end
		}
	},
	switch_to_boons = {
		{
			name = "animate_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				return
			end,
			update = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				local var_25_0 = math.easeOutCubic(arg_25_3)

				for iter_25_0 = 2, 4 do
					local var_25_1 = "player_" .. iter_25_0

					arg_25_0[var_25_1].local_position[1] = math.lerp(arg_25_0[var_25_1].local_position[1], arg_25_1[var_25_1].position[1] - 400, var_25_0)
				end
			end,
			on_complete = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				local var_26_0 = 0
			end
		},
		{
			name = "animate_in",
			start_progress = 0.1,
			end_progress = 0.3,
			init = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end,
			update = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				local var_28_0 = math.easeOutCubic(arg_28_3)

				arg_28_0.boon_root.local_position[1] = math.lerp(arg_28_0.boon_root.local_position[1], arg_28_1.boon_root.position[1] + 400, var_28_0)
			end,
			on_complete = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				return
			end
		}
	}
}
local var_0_16 = {
	console_cursor = UIWidgets.create_console_cursor("console_cursor"),
	top_info = var_0_11("top_info"),
	general_info = var_0_10("general_info"),
	node_info = var_0_14("node_info"),
	player_1_portrait = UIWidgets.create_deus_player_status_portrait("player_1_portrait", "default", "-"),
	player_1_texts = var_0_13("player_1_texts"),
	player_2_portrait = UIWidgets.create_deus_player_status_portrait("player_2_portrait", "default", "-"),
	player_2_texts = var_0_13("player_2_texts"),
	player_3_portrait = UIWidgets.create_deus_player_status_portrait("player_3_portrait", "default", "-"),
	player_3_texts = var_0_13("player_3_texts"),
	player_4_portrait = UIWidgets.create_deus_player_status_portrait("player_4_portrait", "default", "-"),
	player_4_texts = var_0_13("player_4_texts"),
	top_options_background_left = UIWidgets.create_simple_uv_texture("athanor_decoration_headline", {
		{
			0.609375,
			0
		},
		{
			0,
			1
		}
	}, "top_options_background_left", nil, nil, nil, nil, nil, var_0_7.top_options_background_left.size),
	options_background_edge_left = UIWidgets.create_simple_uv_texture("shrine_sidebar_background", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "options_background_edge_left"),
	options_background_left = UIWidgets.create_tiled_texture("options_background_left", "menu_frame_bg_01_mask2", {
		960,
		1080
	}, nil, true, {
		255,
		128,
		128,
		128
	}),
	options_background_mask_left = UIWidgets.create_simple_uv_texture("shrine_sidebar_write_mask2", {
		{
			1,
			0
		},
		{
			0.35,
			1
		}
	}, "options_background_mask_left"),
	power_up_mask = UIWidgets.create_simple_texture("mask_rect", "own_power_up_window"),
	boons_text = UIWidgets.create_simple_text("menu_weave_forge_options_sub_title_properties_utility", "boons_text", nil, nil, var_0_8),
	power_up_description = UIWidgets.create_power_up("power_up_description_root", var_0_7.power_up_description_root.size, true, var_0_1),
	portrait_input_helper_text = UIWidgets.create_simple_text("menu_description_show_team", "input_helper_text", nil, nil, var_0_9),
	boon_input_helper_text = UIWidgets.create_simple_text("menu_description_show_boons", "input_helper_text", nil, nil, var_0_9)
}
local var_0_17 = {
	64,
	64
}
local var_0_18 = {
	20,
	10
}
local var_0_19 = {
	background_icon = "button_frame_01",
	width = var_0_17[1],
	icon_size = {
		35,
		35
	},
	icon_offset = {
		15.5,
		14,
		1
	},
	background_icon_size = {
		65,
		65
	},
	background_icon_offset = {
		0,
		0,
		-1
	}
}
local var_0_20 = {
	background_icon = "button_frame_01",
	width = var_0_17[1],
	icon_size = {
		58,
		58
	},
	icon_offset = {
		5,
		5,
		0
	},
	background_icon_size = {
		65,
		65
	},
	background_icon_offset = {
		0,
		0,
		1
	}
}

return {
	widget_definitions = var_0_16,
	scenegraph_definition = var_0_7,
	animations_definitions = var_0_15,
	round_power_up_widget_data = var_0_19,
	rectangular_power_up_widget_data = var_0_20,
	power_up_widget_size = var_0_17,
	power_up_widget_spacing = var_0_18,
	allow_boon_removal = var_0_1
}
