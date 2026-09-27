-- chunkname: @scripts/ui/views/ingame_player_list_ui_v2_definitions.lua

local tbl = {
	620,
	160
}
local tbl_2 = {
	500,
	36
}
local tbl_3 = {
	450,
	0
}
local tbl_4 = {
	660,
	1080
}
local tbl_5 = {
	660,
	1080
}
local num = (tbl_4[1] - tbl_5[1]) / 2
local tbl_6 = {
	200,
	10,
	10,
	10
}
local tbl_7 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.ingame_player_list
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
			-10
		},
		size = {
			1920,
			1080
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.ingame_player_list
		},
		size = {
			100,
			100
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			1920,
			1080
		}
	},
	banner_left = {
		scale = "fit_height",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = tbl_4
	},
	banner_left_edge = {
		scale = "fit_height",
		horizontal_alignment = "left",
		position = {
			tbl_4[1],
			0,
			1
		},
		size = {
			5,
			tbl_4[2]
		}
	},
	banner_right = {
		scale = "fit_height",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			1
		},
		size = tbl_5
	},
	banner_right_edge = {
		scale = "fit_height",
		horizontal_alignment = "right",
		position = {
			-tbl_4[1],
			0,
			1
		},
		size = {
			5,
			tbl_4[2]
		}
	},
	player_list_input_description = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			num,
			50,
			-1
		},
		size = {
			564,
			30
		}
	},
	node_info = {
		vertical_alignment = "top",
		parent = "banner_right",
		horizontal_alignment = "left",
		position = {
			20,
			-200,
			1
		},
		offset = {
			0,
			0,
			0
		}
	},
	reward_item = {
		vertical_alignment = "top",
		parent = "banner_right",
		horizontal_alignment = "left",
		position = {
			122,
			-750,
			1
		},
		offset = {
			0,
			0,
			0
		}
	},
	reward_divider = {
		vertical_alignment = "top",
		parent = "banner_right",
		horizontal_alignment = "left",
		position = {
			20,
			-700,
			1
		},
		size = {
			264,
			32
		},
		offset = {
			0,
			0,
			0
		}
	},
	loot_objective = {
		vertical_alignment = "top",
		parent = "banner_right",
		horizontal_alignment = "left",
		position = {
			20,
			-990,
			1
		},
		size = {
			200,
			90
		}
	},
	player_portrait = {
		vertical_alignment = "top",
		parent = "banner_left",
		horizontal_alignment = "left",
		position = {
			100 + UISettings.INSIGNIA_OFFSET,
			-100,
			10
		},
		size = {
			0,
			0
		}
	},
	player_insignia = {
		vertical_alignment = "top",
		parent = "banner_left",
		horizontal_alignment = "left",
		position = {
			UISettings.INSIGNIA_OFFSET,
			-100,
			10
		},
		size = {
			0,
			0
		}
	},
	player_career_name = {
		vertical_alignment = "center",
		parent = "player_portrait",
		horizontal_alignment = "left",
		position = {
			80,
			-11,
			1
		},
		size = {
			400,
			0
		}
	},
	player_name_divider = {
		vertical_alignment = "center",
		parent = "player_portrait",
		horizontal_alignment = "left",
		position = {
			80,
			-5,
			1
		},
		size = {
			450,
			4
		}
	},
	mechanism_type_name = {
		vertical_alignment = "top",
		parent = "banner_right",
		horizontal_alignment = "left",
		position = {
			20,
			-140,
			1
		}
	},
	mission_type_name = {
		vertical_alignment = "top",
		parent = "mechanism_type_name",
		horizontal_alignment = "left",
		position = {
			0,
			-30,
			1
		}
	},
	mission_details_divider = {
		vertical_alignment = "top",
		parent = "mission_type_name",
		horizontal_alignment = "left",
		position = {
			0,
			-30,
			1
		},
		size = {
			450,
			4
		}
	},
	level_description = {
		vertical_alignment = "top",
		parent = "mission_details_divider",
		horizontal_alignment = "left",
		position = {
			0,
			-30,
			1
		},
		size = {
			540,
			400
		}
	},
	collectibles_name = {
		vertical_alignment = "top",
		parent = "banner_right",
		horizontal_alignment = "left",
		position = {
			20,
			-850,
			1
		}
	},
	collectibles_divider = {
		vertical_alignment = "top",
		parent = "collectibles_name",
		horizontal_alignment = "left",
		position = {
			0,
			-35,
			1
		},
		size = {
			450,
			4
		}
	},
	player_hero_name = {
		vertical_alignment = "center",
		parent = "player_portrait",
		horizontal_alignment = "left",
		position = {
			80,
			-7,
			1
		},
		size = {
			500,
			0
		}
	},
	player_passive_icon = {
		vertical_alignment = "top",
		parent = "banner_left",
		horizontal_alignment = "left",
		position = {
			350,
			-190,
			1
		},
		size = {
			50,
			50
		}
	},
	player_passive_name = {
		vertical_alignment = "top",
		parent = "player_passive_icon",
		horizontal_alignment = "left",
		position = {
			60,
			0,
			1
		},
		size = {
			500,
			30
		}
	},
	player_passive_title = {
		vertical_alignment = "top",
		parent = "player_passive_name",
		horizontal_alignment = "left",
		position = {
			0,
			-30,
			1
		},
		size = {
			500,
			30
		}
	},
	player_passive_description = {
		vertical_alignment = "top",
		parent = "player_passive_icon",
		horizontal_alignment = "left",
		position = {
			0,
			-60,
			1
		},
		size = {
			300,
			100
		}
	},
	player_ability_icon = {
		vertical_alignment = "top",
		parent = "banner_left",
		horizontal_alignment = "left",
		position = {
			20,
			-190,
			1
		},
		size = {
			50,
			50
		}
	},
	player_ability_name = {
		vertical_alignment = "top",
		parent = "player_ability_icon",
		horizontal_alignment = "left",
		position = {
			60,
			0,
			1
		},
		size = {
			500,
			30
		}
	},
	player_ability_title = {
		vertical_alignment = "top",
		parent = "player_ability_name",
		horizontal_alignment = "left",
		position = {
			0,
			-30,
			1
		},
		size = {
			500,
			30
		}
	},
	player_ability_description = {
		vertical_alignment = "top",
		parent = "player_ability_icon",
		horizontal_alignment = "left",
		position = {
			0,
			-60,
			1
		},
		size = {
			300,
			100
		}
	},
	game_level = {
		vertical_alignment = "top",
		parent = "banner_right",
		horizontal_alignment = "right",
		position = {
			-25,
			-20,
			5
		},
		size = {
			500,
			30
		}
	},
	game_difficulty = {
		vertical_alignment = "top",
		parent = "game_level",
		horizontal_alignment = "right",
		position = {
			0,
			-30,
			5
		},
		size = {
			500,
			30
		}
	},
	mutator_summary1 = {
		vertical_alignment = "top",
		parent = "banner_right",
		horizontal_alignment = "left",
		position = {
			20,
			-200,
			1
		},
		size = tbl_3
	},
	mutator_summary2 = {
		vertical_alignment = "top",
		parent = "mutator_summary1",
		horizontal_alignment = "left",
		position = {
			0,
			-100,
			1
		},
		size = tbl_3
	},
	mutator_summary3 = {
		vertical_alignment = "top",
		parent = "mutator_summary2",
		horizontal_alignment = "left",
		position = {
			0,
			-100,
			1
		},
		size = tbl_3
	},
	mutator_summary4 = {
		vertical_alignment = "top",
		parent = "mutator_summary3",
		horizontal_alignment = "left",
		position = {
			0,
			-100,
			1
		},
		size = tbl_3
	},
	mutator_summary5 = {
		vertical_alignment = "top",
		parent = "mutator_summary4",
		horizontal_alignment = "left",
		position = {
			0,
			-100,
			1
		},
		size = tbl_3
	},
	mutator_summary6 = {
		vertical_alignment = "top",
		parent = "mutator_summary5",
		horizontal_alignment = "left",
		position = {
			0,
			-100,
			1
		},
		size = tbl_3
	},
	weave_objective_header = {
		vertical_alignment = "top",
		parent = "mutator_summary1",
		horizontal_alignment = "left",
		position = {
			0,
			-200,
			1
		},
		size = tbl_3
	},
	weave_objective_divider = {
		vertical_alignment = "top",
		parent = "weave_objective_header",
		horizontal_alignment = "left",
		position = {
			0,
			-35,
			1
		},
		size = {
			450,
			4
		}
	},
	weave_main_objective = {
		vertical_alignment = "top",
		parent = "weave_objective_divider",
		horizontal_alignment = "left",
		position = {
			0,
			-20,
			1
		},
		size = {
			450,
			300
		}
	},
	weave_sub_objective = {
		vertical_alignment = "top",
		parent = "weave_main_objective",
		horizontal_alignment = "left",
		position = {
			0,
			-50,
			1
		},
		size = {
			450,
			300
		}
	},
	player_list = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			0,
			-370,
			1
		},
		offset = {
			20,
			0,
			0
		},
		size = {
			tbl[1],
			tbl[2]
		}
	},
	player_list_portrait = {
		vertical_alignment = "center",
		parent = "player_list",
		horizontal_alignment = "left",
		position = {
			80 + UISettings.INSIGNIA_OFFSET,
			-7,
			1
		},
		size = {
			0,
			0
		}
	},
	player_list_insignia = {
		vertical_alignment = "center",
		parent = "player_list",
		horizontal_alignment = "left",
		position = {
			35,
			-7,
			10
		},
		size = {
			0,
			0
		}
	},
	popup = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			-200,
			10
		},
		size = {
			tbl_2[1],
			tbl_2[2]
		}
	},
	private_checkbox = {
		vertical_alignment = "top",
		parent = "game_difficulty",
		horizontal_alignment = "right",
		size = {
			250,
			40
		},
		position = {
			0,
			-35,
			1
		}
	},
	item_tooltip = {
		vertical_alignment = "bottom",
		parent = "player_list",
		horizontal_alignment = "right",
		position = {
			450,
			0,
			1
		},
		offset = {
			0,
			-5,
			0
		},
		size = {
			400,
			0
		}
	},
	reward_item_tooltip = {
		vertical_alignment = "top",
		parent = "banner_right",
		horizontal_alignment = "right",
		position = {
			0,
			-780,
			1
		},
		offset = {
			-80,
			0,
			0
		},
		size = {
			400,
			0
		}
	},
	talent_tooltip = {
		vertical_alignment = "bottom",
		parent = "player_list",
		horizontal_alignment = "right",
		position = {
			450,
			0,
			1
		},
		offset = {
			0,
			-5,
			0
		},
		size = {
			400,
			0
		}
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local flag

	flag = tbl_7[arg_1_0].horizontal_alignment ~= "right" or not "left" or "right"

	local flag_2

	flag_2 = flag ~= "left" or not -1 or 1

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
				texture_size = {
					arg_1_1[1],
					arg_1_1[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5 * flag_2,
					0,
					6
				},
				texture_tiling_size = {
					5,
					arg_1_1[2]
				},
				horizontal_alignment = flag
			},
			edge_holder_top = {
				vertical_alignment = "top",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					11 * flag_2,
					0,
					10
				},
				texture_size = {
					17,
					9
				},
				horizontal_alignment = flag
			},
			edge_holder_bottom = {
				vertical_alignment = "bottom",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					11 * flag_2,
					0,
					10
				},
				texture_size = {
					17,
					9
				},
				horizontal_alignment = flag
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

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_2_0).size

	arg_2_2 = arg_2_2 or 1

	return {
		scenegraph_id = "loot_objective",
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "counter_text",
					pass_type = "text",
					text_id = "counter_text",
					content_check_function = function (self)
						-- function 3
						return self.amount > 0
					end
				},
				{
					style_id = "counter_text_disabled",
					pass_type = "text",
					text_id = "counter_text",
					content_check_function = function (self)
						-- function 4
						return self.amount == 0
					end
				},
				{
					style_id = "counter_text_shadow",
					pass_type = "text",
					text_id = "counter_text"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 5
						return self.amount > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "background_icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "glow_icon",
					texture_id = "glow_icon"
				}
			}
		},
		content = {
			counter_text = "x9",
			amount = 0,
			text = arg_2_1 or "n/a",
			icon = arg_2_0,
			glow_icon = arg_2_0 .. "_glow"
		},
		style = {
			text = {
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = Colors.get_table("font_title"),
				offset = {
					arg_2_2 * size[1],
					arg_2_2 * size[2] - 50,
					1
				}
			},
			text_shadow = {
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = Colors.get_table("black"),
				offset = {
					arg_2_2 * size[1] + 1,
					arg_2_2 * size[2] - 50 - 1,
					0
				}
			},
			counter_text = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = Colors.get_table("font_default"),
				offset = {
					arg_2_2 * size[1],
					-40,
					1
				}
			},
			counter_text_disabled = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = {
					255,
					130,
					130,
					130
				},
				offset = {
					arg_2_2 * size[1],
					-40,
					1
				}
			},
			counter_text_shadow = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = Colors.get_table("black"),
				offset = {
					arg_2_2 * size[1] + 1,
					-41,
					0
				}
			},
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				},
				texture_size = {
					arg_2_2 * size[1],
					arg_2_2 * size[2]
				}
			},
			background_icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				},
				texture_size = {
					arg_2_2 * size[1],
					arg_2_2 * size[2]
				}
			},
			glow_icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
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
					arg_2_2 * size[1],
					arg_2_2 * size[2]
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

local function fn_3()
	-- function 6
	return {
		scenegraph_id = "node_info",
		element = {
			passes = {
				{
					texture_id = "divider_id",
					style_id = "divider",
					pass_type = "texture"
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
				},
				{
					style_id = "node_info",
					pass_type = "auto_layout",
					content_id = "node_info",
					sub_passes = {
						{
							style_id = "curse_section",
							pass_type = "auto_layout",
							content_check_function = function (self)
								-- function 7
								return self.curse_text ~= ""
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
							content_check_function = function (self)
								-- function 8
								return self.breed_text ~= ""
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
							content_check_function = function (self)
								-- function 9
								return self.text ~= ""
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
							content_check_function = function (self)
								-- function 10
								return self.text ~= ""
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
							content_check_function = function (self)
								-- function 11
								return self.text ~= ""
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
							content_check_function = function (self)
								-- function 12
								return self.terror_event_power_up_text ~= ""
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
					}
				}
			}
		},
		content = {
			divider_id = "infoslate_frame_02_horizontal",
			text_id = Utf8.upper(Localize("hero_view_prestige_information")),
			node_info = {
				terror_event_power_up_text = "terror_event_power_up_text",
				curse_icon = "deus_icons_map_khorne",
				curse_text = "curse_text",
				breed_text = "breed_text",
				terror_event_power_up_icon = "mutator_icon_elite_run",
				breed_icon = "mutator_icon_elite_run",
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
			divider = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					450,
					4
				},
				offset = {
					0,
					-30,
					0
				}
			},
			text = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 26,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					0,
					1
				}
			},
			text_shadow = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 26,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					0
				}
			},
			node_info = {
				layout_delta_x = 0,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				layout_delta_y = -1,
				offset = {
					10,
					-50,
					0
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
							40,
							40
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
							40,
							40
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
							40,
							40
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
							40,
							40
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
							40,
							40
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
							40,
							40
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
							40,
							40
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
							40,
							40
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

local function fn_4(arg_13_0, arg_13_1)
	-- function 13
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			text = "-",
			title_text = "title_text",
			background = "chest_upgrade_fill_glow",
			icon = "trial_gem"
		},
		style = {
			background = {
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
				}
			},
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					49,
					44
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				default_offset = {
					-25,
					-2,
					1
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				word_wrap = true,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					arg_13_1[1] - 50,
					arg_13_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					2
				}
			},
			title_text_shadow = {
				word_wrap = true,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					arg_13_1[1] - 50,
					arg_13_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					1
				}
			},
			text = {
				word_wrap = true,
				font_size = 26,
				localize = true,
				dynamic_font_size_word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-30,
					2
				}
			},
			text_shadow = {
				word_wrap = true,
				font_size = 26,
				localize = true,
				dynamic_font_size_word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-32,
					1
				}
			}
		},
		offset = {
			50,
			0,
			0
		},
		scenegraph_id = arg_13_0
	}
end

local function fn_5(arg_14_0, arg_14_1)
	-- function 14
	return {
		element = {
			passes = {
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (self)
						-- function 15
						return self.text ~= ""
					end
				},
				{
					style_id = "level_description_text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "level_description_text_shadow",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			text = arg_14_0,
			description_text = Localize("lb_mission")
		},
		style = {
			description_text = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 28,
				horizontal_alignment = "left",
				text_color = Colors.get_table("font_title"),
				offset = {
					0,
					0,
					1
				}
			},
			level_description_text = {
				font_size = 24,
				word_wrap = true,
				font_type = "hell_shark",
				dynamic_font_size_word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					620,
					220
				},
				text_color = Colors.get_table("white"),
				offset = {
					0,
					-30,
					1
				}
			},
			level_description_text_shadow = {
				font_size = 24,
				word_wrap = true,
				font_type = "hell_shark",
				dynamic_font_size_word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					620,
					220
				},
				text_color = Colors.get_table("black"),
				offset = {
					2,
					-32,
					0
				}
			}
		},
		scenegraph_id = arg_14_1,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_6(arg_16_0, arg_16_1)
	-- function 16
	local tbl = {
		60,
		60
	}
	local tbl_2 = {
		scenegraph_id = "reward_item",
		element = {
			passes = {
				{
					style_id = "icon",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					texture_id = "icon_id",
					style_id = "icon",
					pass_type = "texture"
				},
				{
					scenegraph_id = "reward_item_tooltip",
					item_id = "item",
					pass_type = "item_tooltip",
					content_check_function = function (self)
						-- function 17
						local is_hover = self.hotspot.is_hover

						is_hover = not is_hover and self.item

						return is_hover
					end
				}
			}
		},
		content = {
			hotspot = {},
			icon_id = arg_16_1.data.inventory_icon,
			item = arg_16_1
		},
		style = {
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = tbl,
				area_size = tbl,
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = {
			arg_16_0,
			0,
			0
		}
	}

	UIWidgets.append_item_frame_pass("frame_id", tbl_2.element.passes, tbl_2.content, tbl_2.style, tbl, {
		0,
		0,
		1
	}, false, nil, {
		horizontal_alignment = "left",
		vertical_alignment = "top"
	}, nil, nil)

	return tbl_2
end

local function fn_7(arg_18_0)
	-- function 18
	local str = "player_list"
	local size = tbl_7[str].size
	local menu_frame_09 = UIFrameSettings.menu_frame_09
	local str_2 = "talent_tree_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local num = 0
	local INSIGNIA_OFFSET = UISettings.INSIGNIA_OFFSET

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "host_texture",
					texture_id = "host_texture",
					content_check_function = function (self)
						-- function 19
						return self.show_host
					end
				},
				{
					pass_type = "texture",
					style_id = "ping_texture",
					texture_id = "ping_texture",
					content_check_function = function (self)
						-- function 20
						return self.show_ping
					end
				},
				{
					style_id = "ping_text",
					pass_type = "text",
					text_id = "ping_text",
					content_check_function = function (self, arg_21_1)
						-- function 21
						local show_ping = self.show_ping

						show_ping = not show_ping and Application.user_setting("show_numerical_latency")

						return show_ping
					end
				},
				{
					style_id = "build_private_text",
					pass_type = "text",
					text_id = "build_private_text",
					content_check_function = function (self, arg_22_1)
						-- function 22
						return not self.is_build_visible
					end
				},
				{
					pass_type = "rect",
					style_id = "chat_button_background",
					texture_id = "chat_button_texture"
				},
				{
					texture_id = "button_frame",
					style_id = "chat_button_frame",
					pass_type = "texture"
				},
				{
					style_id = "chat_button_hotspot",
					texture_id = "chat_button_texture",
					pass_type = "texture",
					content_change_function = function (self, arg_23_1)
						-- function 23
						local color = arg_23_1.color
						local flag

						flag = not self.show_chat_button and 255 and 60
						color[1] = flag
					end
				},
				{
					pass_type = "texture",
					style_id = "chat_button_disabled",
					texture_id = "disabled_texture",
					content_check_function = function (self)
						-- function 24
						local show_chat_button = self.show_chat_button

						show_chat_button = not show_chat_button and self.chat_button_hotspot.is_selected

						return show_chat_button
					end
				},
				{
					style_id = "chat_button_hotspot",
					pass_type = "hotspot",
					content_id = "chat_button_hotspot",
					content_check_function = function (self)
						-- function 25
						return not self.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "chat_tooltip_text_mute",
					content_check_function = function (self)
						-- function 26
						local show_chat_button = self.show_chat_button

						show_chat_button = not show_chat_button and not not self.chat_button_hotspot.is_selected or self.chat_button_hotspot.is_hover

						return show_chat_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "chat_tooltip_text_unmute",
					content_check_function = function (self)
						-- function 27
						local show_chat_button = self.show_chat_button

						if not show_chat_button then
							show_chat_button = self.chat_button_hotspot.is_selected
							show_chat_button = not show_chat_button and self.chat_button_hotspot.is_hover
						end

						return show_chat_button
					end
				},
				{
					pass_type = "rect",
					style_id = "voice_button_background",
					texture_id = "voice_button_texture"
				},
				{
					texture_id = "button_frame",
					style_id = "voice_chat_button_frame",
					pass_type = "texture"
				},
				{
					style_id = "voice_button_hotspot",
					texture_id = "voice_button_texture",
					pass_type = "texture",
					content_change_function = function (self, arg_28_1)
						-- function 28
						local color = arg_28_1.color
						local flag

						flag = not self.show_voice_button and 255 and 60
						color[1] = flag
					end
				},
				{
					pass_type = "texture",
					style_id = "voice_button_disabled",
					texture_id = "disabled_texture",
					content_check_function = function (self)
						-- function 29
						local show_voice_button = self.show_voice_button

						show_voice_button = not show_voice_button and self.voice_button_hotspot.is_selected

						return show_voice_button
					end
				},
				{
					style_id = "voice_button_hotspot",
					pass_type = "hotspot",
					content_id = "voice_button_hotspot",
					content_check_function = function (self)
						-- function 30
						return not self.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "voice_tooltip_text_mute",
					content_check_function = function (self)
						-- function 31
						local show_voice_button = self.show_voice_button

						show_voice_button = not show_voice_button and not not self.voice_button_hotspot.is_selected or self.voice_button_hotspot.is_hover

						return show_voice_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "voice_tooltip_text_unmute",
					content_check_function = function (self)
						-- function 32
						local show_voice_button = self.show_voice_button

						if not show_voice_button then
							show_voice_button = self.voice_button_hotspot.is_selected
							show_voice_button = not show_voice_button and self.voice_button_hotspot.is_hover
						end

						return show_voice_button
					end
				},
				{
					pass_type = "rect",
					style_id = "kick_button_background",
					texture_id = "kick_button_texture"
				},
				{
					texture_id = "button_frame",
					style_id = "kick_button_frame",
					pass_type = "texture"
				},
				{
					style_id = "kick_button_hotspot",
					texture_id = "kick_button_texture",
					pass_type = "texture",
					content_change_function = function (self, arg_33_1)
						-- function 33
						local color = arg_33_1.color
						local flag

						flag = not self.show_kick_button and 255 and 60
						color[1] = flag
					end
				},
				{
					style_id = "kick_button_hotspot",
					pass_type = "hotspot",
					content_id = "kick_button_hotspot",
					content_check_function = function (self)
						-- function 34
						return not self.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "kick_tooltip_text",
					content_check_function = function (self)
						-- function 35
						local show_kick_button = self.show_kick_button

						show_kick_button = not show_kick_button and self.kick_button_hotspot.is_hover

						return show_kick_button
					end
				},
				{
					pass_type = "rect",
					style_id = "profile_button_background",
					texture_id = "profile_button_texture"
				},
				{
					texture_id = "button_frame",
					style_id = "profile_button_frame",
					pass_type = "texture"
				},
				{
					style_id = "profile_button_hotspot",
					texture_id = "profile_button_texture",
					pass_type = "texture",
					content_change_function = function (self, arg_36_1)
						-- function 36
						local color = arg_36_1.color
						local flag

						flag = not self.show_profile_button and 255 and 60
						color[1] = flag
					end
				},
				{
					style_id = "profile_button_hotspot",
					pass_type = "hotspot",
					content_id = "profile_button_hotspot",
					content_check_function = function (self)
						-- function 37
						return not self.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "profile_tooltip_text",
					content_check_function = function (self)
						-- function 38
						local show_profile_button = self.show_profile_button

						show_profile_button = not show_profile_button and self.profile_button_hotspot.is_hover

						return show_profile_button
					end
				},
				{
					style_id = "name",
					pass_type = "text",
					text_id = "name",
					content_check_function = function (self, arg_39_1)
						-- function 39
						if self.button_hotspot.is_selected or not self.controller_button_hotspot.is_hover then
							arg_39_1.text_color = arg_39_1.hover_color
						else
							arg_39_1.text_color = arg_39_1.color
						end

						return true
					end
				},
				{
					style_id = "name_shadow",
					pass_type = "text",
					text_id = "name"
				},
				{
					style_id = "hero",
					pass_type = "text",
					text_id = "hero",
					content_check_function = function (self, arg_40_1)
						-- function 40
						if self.button_hotspot.is_selected or not self.controller_button_hotspot.is_hover then
							arg_40_1.text_color = arg_40_1.hover_color
						else
							arg_40_1.text_color = arg_40_1.color
						end

						return true
					end
				},
				{
					style_id = "hero_shadow",
					pass_type = "text",
					text_id = "hero"
				},
				{
					pass_type = "rect",
					style_id = "hp_bar_bg"
				},
				{
					style_id = "hp_bar_fg_start",
					pass_type = "texture_uv",
					content_id = "hp_bar_fg_start"
				},
				{
					style_id = "hp_bar_fg_middle",
					pass_type = "texture_uv",
					content_id = "hp_bar_fg_middle"
				},
				{
					style_id = "hp_bar_fg_end",
					pass_type = "texture_uv",
					content_id = "hp_bar_fg_end"
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "health_bar",
					texture_id = "texture_id",
					content_id = "health_bar"
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "total_health_bar",
					texture_id = "texture_id",
					content_id = "total_health_bar"
				},
				{
					style_id = "ability_bar",
					pass_type = "texture_uv",
					content_id = "ability_bar",
					content_change_function = function (self, arg_41_1)
						-- function 41
						local bar_value = self.bar_value
						local texture_size = arg_41_1.texture_size
						local uvs = self.uvs
						local var_41_3 = arg_41_1.full_size[1]

						uvs[2][2] = bar_value
						texture_size[1] = var_41_3 * bar_value
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					content_change_function = function (arg_42_0, arg_42_1)
						-- function 42
						arg_42_1.texture_size[1] = (200 - INSIGNIA_OFFSET) * arg_42_1.grimoire_debuff
						arg_42_0.uvs[1][1] = 1 - arg_42_1.grimoire_debuff
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					content_change_function = function (arg_43_0, arg_43_1)
						-- function 43
						local grimoire_debuff = arg_43_1.grimoire_debuff

						arg_43_1.offset[1] = arg_43_1.base_offset[1] - (200 - INSIGNIA_OFFSET) * grimoire_debuff
					end
				},
				{
					texture_id = "slot_melee",
					style_id = "slot_melee",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 44
						return self.slot_melee
					end
				},
				{
					style_id = "slot_melee",
					pass_type = "hotspot",
					content_id = "slot_melee_hotspot",
					content_check_function = function (self)
						-- function 45
						return self.parent.slot_melee
					end
				},
				{
					texture_id = "slot_melee_frame",
					style_id = "slot_melee_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 46
						return self.slot_melee
					end
				},
				{
					texture_id = "slot_melee_rarity_texture",
					style_id = "slot_melee_rarity_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 47
						return self.slot_melee
					end
				},
				{
					texture_id = "slot_ranged",
					style_id = "slot_ranged",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 48
						return self.slot_ranged
					end
				},
				{
					style_id = "slot_ranged",
					pass_type = "hotspot",
					content_id = "slot_ranged_hotspot",
					content_check_function = function (self)
						-- function 49
						return self.parent.slot_ranged
					end
				},
				{
					texture_id = "slot_ranged_frame",
					style_id = "slot_ranged_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 50
						return self.slot_ranged
					end
				},
				{
					texture_id = "slot_ranged_rarity_texture",
					style_id = "slot_ranged_rarity_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 51
						return self.slot_ranged
					end
				},
				{
					texture_id = "slot_necklace",
					style_id = "slot_necklace",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 52
						return self.slot_necklace
					end
				},
				{
					style_id = "slot_necklace",
					pass_type = "hotspot",
					content_id = "slot_necklace_hotspot",
					content_check_function = function (self)
						-- function 53
						return self.parent.slot_necklace
					end
				},
				{
					texture_id = "slot_necklace_frame",
					style_id = "slot_necklace_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 54
						return self.slot_necklace
					end
				},
				{
					texture_id = "slot_necklace_rarity_texture",
					style_id = "slot_necklace_rarity_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 55
						return self.slot_necklace
					end
				},
				{
					texture_id = "slot_ring",
					style_id = "slot_ring",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 56
						return self.slot_ring
					end
				},
				{
					style_id = "slot_ring",
					pass_type = "hotspot",
					content_id = "slot_ring_hotspot",
					content_check_function = function (self)
						-- function 57
						return self.parent.slot_ring
					end
				},
				{
					texture_id = "slot_ring_frame",
					style_id = "slot_ring_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 58
						return self.slot_ring
					end
				},
				{
					texture_id = "slot_ring_rarity_texture",
					style_id = "slot_ring_rarity_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 59
						return self.slot_ring
					end
				},
				{
					texture_id = "slot_trinket_1",
					style_id = "slot_trinket_1",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 60
						return self.slot_trinket_1
					end
				},
				{
					style_id = "slot_trinket_1",
					pass_type = "hotspot",
					content_id = "slot_trinket_1_hotspot",
					content_check_function = function (self)
						-- function 61
						return self.parent.slot_trinket_1
					end
				},
				{
					texture_id = "slot_trinket_1_frame",
					style_id = "slot_trinket_1_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 62
						return self.slot_trinket_1
					end
				},
				{
					texture_id = "slot_trinket_1_rarity_texture",
					style_id = "slot_trinket_1_rarity_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 63
						return self.slot_trinket_1
					end
				},
				{
					texture_id = "talent_frame",
					style_id = "talent_1_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 64
						return self.talent_1.talent
					end
				},
				{
					style_id = "talent_1",
					pass_type = "hotspot",
					content_id = "talent_1"
				},
				{
					texture_id = "icon",
					style_id = "talent_1",
					pass_type = "texture",
					content_id = "talent_1",
					content_check_function = function (self)
						-- function 65
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					scenegraph_id = "talent_tooltip",
					pass_type = "talent_tooltip",
					talent_id = "talent",
					content_id = "talent_1",
					content_check_function = function (self)
						-- function 66
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					texture_id = "talent_frame",
					style_id = "talent_2_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 67
						return self.talent_2.talent
					end
				},
				{
					style_id = "talent_2",
					pass_type = "hotspot",
					content_id = "talent_2"
				},
				{
					texture_id = "icon",
					style_id = "talent_2",
					pass_type = "texture",
					content_id = "talent_2",
					content_check_function = function (self)
						-- function 68
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					scenegraph_id = "talent_tooltip",
					pass_type = "talent_tooltip",
					talent_id = "talent",
					content_id = "talent_2",
					content_check_function = function (self)
						-- function 69
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					texture_id = "talent_frame",
					style_id = "talent_3_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 70
						return self.talent_3.talent
					end
				},
				{
					style_id = "talent_3",
					pass_type = "hotspot",
					content_id = "talent_3"
				},
				{
					texture_id = "icon",
					style_id = "talent_3",
					pass_type = "texture",
					content_id = "talent_3",
					content_check_function = function (self)
						-- function 71
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					scenegraph_id = "talent_tooltip",
					pass_type = "talent_tooltip",
					talent_id = "talent",
					content_id = "talent_3",
					content_check_function = function (self)
						-- function 72
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					texture_id = "talent_frame",
					style_id = "talent_4_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 73
						return self.talent_4.talent
					end
				},
				{
					style_id = "talent_4",
					pass_type = "hotspot",
					content_id = "talent_4"
				},
				{
					texture_id = "icon",
					style_id = "talent_4",
					pass_type = "texture",
					content_id = "talent_4",
					content_check_function = function (self)
						-- function 74
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					scenegraph_id = "talent_tooltip",
					pass_type = "talent_tooltip",
					talent_id = "talent",
					content_id = "talent_4",
					content_check_function = function (self)
						-- function 75
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					texture_id = "talent_frame",
					style_id = "talent_5_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 76
						return self.talent_5.talent
					end
				},
				{
					style_id = "talent_5",
					pass_type = "hotspot",
					content_id = "talent_5"
				},
				{
					texture_id = "icon",
					style_id = "talent_5",
					pass_type = "texture",
					content_id = "talent_5",
					content_check_function = function (self)
						-- function 77
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					scenegraph_id = "talent_tooltip",
					pass_type = "talent_tooltip",
					talent_id = "talent",
					content_id = "talent_5",
					content_check_function = function (self)
						-- function 78
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					texture_id = "talent_frame",
					style_id = "talent_6_frame",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 79
						return self.talent_6.talent
					end
				},
				{
					style_id = "talent_6",
					pass_type = "hotspot",
					content_id = "talent_6"
				},
				{
					texture_id = "icon",
					style_id = "talent_6",
					pass_type = "texture",
					content_id = "talent_6",
					content_check_function = function (self)
						-- function 80
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					scenegraph_id = "talent_tooltip",
					pass_type = "talent_tooltip",
					talent_id = "talent",
					content_id = "talent_6",
					content_check_function = function (self)
						-- function 81
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				}
			}
		},
		content = {
			name = "n/a",
			show_chat_button = false,
			disabled_texture = "tab_menu_icon_03",
			grimoire_debuff_divider = "hud_player_hp_bar_grim_divider",
			profile_tooltip_text = "input_description_show_profile",
			slot_melee_frame = "reward_pop_up_item_frame",
			slot_trinket_1_rarity_texture = "icon_bg_plentiful",
			chat_tooltip_text_unmute = "input_description_unmute_chat",
			voice_tooltip_text_unmute = "input_description_unmute_voice",
			talent_frame = "talent_frame",
			kick_tooltip_text = "input_description_vote_kick_player",
			slot_trinket_1_frame = "reward_pop_up_item_frame",
			slot_ring_rarity_texture = "icon_bg_plentiful",
			chat_button_texture = "tab_menu_icon_02",
			build_private_text = "visibility_private",
			button_frame = "reward_pop_up_item_frame",
			voice_tooltip_text_mute = "input_description_mute_voice",
			host_texture = "host_icon",
			slot_necklace_rarity_texture = "icon_bg_plentiful",
			hero = "wh_captain",
			voice_button_texture = "tab_menu_icon_01",
			ping_text = "150",
			slot_melee_rarity_texture = "icon_bg_plentiful",
			show_kick_button = false,
			chat_tooltip_text_mute = "input_description_mute_chat",
			show_ping = false,
			profile_button_texture = "tab_menu_icon_05",
			kick_button_texture = "tab_menu_icon_04",
			slot_necklace_frame = "reward_pop_up_item_frame",
			hp_bar_bg = "hud_teammate_hp_bar_bg",
			show_profile_button = false,
			ping_texture = "ping_icon_03",
			show_voice_button = false,
			slot_ranged_rarity_texture = "icon_bg_plentiful",
			slot_ranged_frame = "reward_pop_up_item_frame",
			slot_ring_frame = "reward_pop_up_item_frame",
			frame = menu_frame_09.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						math.min(size[1] / get_atlas_settings_by_texture_name.size[1], 1),
						math.min((size[2] - 50) / get_atlas_settings_by_texture_name.size[2], 1)
					}
				},
				texture_id = str_2
			},
			button_hotspot = {
				allow_multi_hover = true
			},
			chat_button_hotspot = {},
			kick_button_hotspot = {},
			voice_button_hotspot = {},
			profile_button_hotspot = {},
			controller_button_hotspot = {},
			hp_bar_fg_start = {
				texture_id = "hud_teammate_hp_bar_frame",
				uvs = {
					{
						0,
						0
					},
					{
						0.2,
						1
					}
				}
			},
			hp_bar_fg_middle = {
				texture_id = "hud_teammate_hp_bar_frame",
				uvs = {
					{
						0.2,
						0
					},
					{
						0.8,
						1
					}
				}
			},
			hp_bar_fg_end = {
				texture_id = "hud_teammate_hp_bar_frame",
				uvs = {
					{
						0.8,
						0
					},
					{
						1,
						1
					}
				}
			},
			health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				draw_health_bar = true,
				texture_id = "teammate_hp_bar_color_tint_" .. math.min(arg_18_0, 4)
			},
			total_health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				draw_health_bar = true,
				texture_id = "teammate_hp_bar_" .. math.min(arg_18_0, 4)
			},
			grimoire_bar = {
				texture_id = "hud_panel_hp_bar_bg_grimoire",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			},
			ability_bar = {
				bar_value = 1,
				texture_id = "hud_teammate_ability_bar_fill",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			},
			slot_melee_hotspot = {},
			slot_ranged_hotspot = {},
			slot_necklace_hotspot = {},
			slot_ring_hotspot = {},
			slot_trinket_1_hotspot = {},
			talent_1 = {
				is_selected = true
			},
			talent_2 = {
				is_selected = true
			},
			talent_3 = {
				is_selected = true
			},
			talent_4 = {
				is_selected = true
			},
			talent_5 = {
				is_selected = true
			},
			talent_6 = {
				is_selected = true
			}
		},
		style = {
			slot_melee = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-215,
					-10,
					1
				}
			},
			slot_melee_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-215,
					-10,
					2
				}
			},
			slot_melee_rarity_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-215,
					-10,
					0
				}
			},
			slot_ranged = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-165,
					-10,
					1
				}
			},
			slot_ranged_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-165,
					-10,
					2
				}
			},
			slot_ranged_rarity_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-165,
					-10,
					0
				}
			},
			slot_necklace = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-115,
					-10,
					1
				}
			},
			slot_necklace_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-115,
					-10,
					2
				}
			},
			slot_necklace_rarity_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-115,
					-10,
					0
				}
			},
			slot_ring = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-65,
					-10,
					1
				}
			},
			slot_ring_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-65,
					-10,
					2
				}
			},
			slot_ring_rarity_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-65,
					-10,
					0
				}
			},
			slot_trinket_1 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-15 + 0 * -50,
					-10,
					1
				}
			},
			slot_trinket_1_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-15 + 0 * -50,
					-10,
					2
				}
			},
			slot_trinket_1_rarity_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-15 + 0 * -50,
					-10,
					0
				}
			},
			talent_tooltip = {
				draw_downwards = false
			},
			talent_1 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-215,
					-60,
					0
				}
			},
			talent_1_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-215,
					-60,
					1
				}
			},
			talent_2 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-175,
					-60,
					0
				}
			},
			talent_2_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-175,
					-60,
					1
				}
			},
			talent_3 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-135,
					-60,
					0
				}
			},
			talent_3_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-135,
					-60,
					1
				}
			},
			talent_4 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-95,
					-60,
					0
				}
			},
			talent_4_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-95,
					-60,
					1
				}
			},
			talent_5 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-55,
					-60,
					0
				}
			},
			talent_5_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-55,
					-60,
					1
				}
			},
			talent_6 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-15 + 0 * -40,
					-60,
					0
				}
			},
			talent_6_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-15 + 0 * -40,
					-60,
					1
				}
			},
			health_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				gradient_threshold = 1,
				texture_size = {
					200 - INSIGNIA_OFFSET,
					18
				},
				color = {
					255,
					0,
					255,
					0
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					-82,
					14
				}
			},
			total_health_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				gradient_threshold = 1,
				texture_size = {
					200 - INSIGNIA_OFFSET,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					-82,
					13
				}
			},
			ability_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				full_size = {
					194 - INSIGNIA_OFFSET,
					10
				},
				texture_size = {
					200 - INSIGNIA_OFFSET,
					12
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					153 + INSIGNIA_OFFSET,
					-100,
					13
				}
			},
			grimoire_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				grimoire_debuff = 0,
				texture_size = {
					200 - INSIGNIA_OFFSET,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-tbl[1] + 150 + 200,
					-82,
					13
				}
			},
			grimoire_debuff_divider = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				grimoire_debuff = 0,
				texture_size = {
					5,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				base_offset = {
					-tbl[1] + 150 + 200 + 1.5,
					-84,
					20
				},
				offset = {
					-tbl[1] + 150 + 200,
					-82,
					20
				}
			},
			hp_bar_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_tiling_size = {
					100,
					20
				},
				texture_size = {
					200 - INSIGNIA_OFFSET,
					30
				},
				tile_offset = {
					true,
					false
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					-82,
					10
				},
				color = {
					255,
					30,
					30,
					30
				}
			},
			hp_bar_fg_start = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					20,
					35
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					-80,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar_fg_middle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					160 - INSIGNIA_OFFSET,
					35
				},
				offset = {
					170 + INSIGNIA_OFFSET,
					-80,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar_fg_end = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					20,
					35
				},
				offset = {
					330,
					-80,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			frame = {
				texture_size = menu_frame_09.texture_size,
				texture_sizes = menu_frame_09.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			},
			background = {
				size = {
					size[1],
					size[2]
				},
				color = {
					tbl_6[1],
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
			tooltip_text = {
				vertical_alignment = "top",
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				font_size = 18,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			profile_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-165,
					10,
					1
				}
			},
			profile_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-165,
					10,
					3
				}
			},
			profile_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-165,
					10,
					2
				}
			},
			voice_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-115,
					10,
					3
				}
			},
			voice_chat_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-115,
					10,
					6
				}
			},
			voice_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-115,
					10,
					4
				}
			},
			voice_button_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					0,
					0
				},
				offset = {
					-115,
					10,
					5
				}
			},
			chat_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-65,
					10,
					1
				}
			},
			chat_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-65,
					10,
					6
				}
			},
			chat_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-65,
					10,
					4
				}
			},
			chat_button_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					0,
					0
				},
				offset = {
					-65,
					10,
					5
				}
			},
			kick_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-15 + 0 * -50,
					10,
					3
				}
			},
			kick_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-15 + 0 * -50,
					10,
					6
				}
			},
			kick_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-15 + 0 * -50,
					10,
					4
				}
			},
			ping_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					54,
					50
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-210,
					5,
					5
				}
			},
			ping_text = {
				horizontal_alignment = "right",
				font_size = 20,
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "arial",
				offset = {
					-255,
					13,
					3
				},
				text_color = Colors.get_table("font_default"),
				high_ping_color = Colors.get_table("crimson"),
				medium_ping_color = Colors.get_table("gold"),
				low_ping_color = Colors.get_table("lime_green")
			},
			build_private_text = {
				vertical_alignment = "top",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_type = "hell_shark_header",
				font_size = 24,
				offset = {
					200,
					-20,
					1
				},
				text_color = {
					255,
					128,
					128,
					128
				}
			},
			host_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-215,
					10,
					3
				},
				texture_size = {
					40,
					40
				}
			},
			name = {
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "arial",
				size = {
					210 - INSIGNIA_OFFSET,
					30
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					121,
					3
				},
				color = Colors.get_table("font_default"),
				hover_color = Colors.get_table("font_default"),
				text_color = Colors.get_table("font_default")
			},
			name_shadow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				font_type = "arial",
				dynamic_font_size = true,
				font_size = 20,
				size = {
					210 - INSIGNIA_OFFSET,
					30
				},
				offset = {
					152 + INSIGNIA_OFFSET,
					119,
					2
				},
				text_color = Colors.get_table("black")
			},
			hero = {
				upper_case = true,
				localize = true,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					210 - INSIGNIA_OFFSET,
					30
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					90,
					3
				},
				color = Colors.get_table("font_title"),
				hover_color = Colors.get_table("font_title"),
				text_color = Colors.get_table("font_title")
			},
			hero_shadow = {
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				font_size = 28,
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					210 - INSIGNIA_OFFSET,
					30
				},
				offset = {
					152 + INSIGNIA_OFFSET,
					88,
					2
				},
				text_color = Colors.get_table("black")
			}
		},
		scenegraph_id = str,
		offset = {
			0,
			0,
			0
		}
	}
end

local tbl_8 = {
	{
		text = "player_list_kick_player",
		func_name = "kick_player",
		availability_func = "kick_player_available"
	},
	{
		text = "player_list_mute_player",
		func_name = "popup_test_func"
	}
}
local tbl_9 = {
	scenegraph_id = "popup",
	element = {
		passes = {
			{
				style_id = "list_style",
				pass_type = "list_pass",
				content_id = "list_content",
				passes = {
					{
						pass_type = "hotspot",
						content_id = "button_hotspot",
						content_check_function = function (self, arg_82_1)
							-- function 82
							return self.button_hotspot.disable_button ~= true
						end
					},
					{
						style_id = "button_text",
						pass_type = "text",
						text_id = "button_text",
						content_check_function = function (self, arg_83_1)
							-- function 83
							if self.button_hotspot.disable_button ~= true then
								if not self.button_hotspot.is_hover then
									arg_83_1.button_text.text_color = arg_83_1.button_text.hover_color
								else
									arg_83_1.button_text.text_color = arg_83_1.button_text.base_color
								end
							end

							return true
						end
					}
				}
			}
		}
	},
	content = {
		list_content = {
			allow_multi_hover = true
		}
	},
	style = {
		list_style = {
			start_index = 1,
			num_draws = 0,
			item_styles = {}
		}
	}
}
local count = #tbl_8

for i = 1, count do
	local var_0_18 = tbl_8[i]
	local tbl_10 = {
		button_hotspot = {},
		button_text = var_0_18.text,
		button_func_name = var_0_18.func_name,
		button_availability_func_name = var_0_18.availability_func
	}
	local tbl_11 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = {
			tbl_2[1],
			tbl_2[2]
		},
		list_member_offset = {
			0,
			-tbl_2[2],
			0
		},
		button_text = {
			font_size = 28,
			localize = true,
			horizontal_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			base_color = Colors.get_table("dark_gray"),
			hover_color = Colors.get_table("white"),
			disabled_color = Colors.get_table("dim_gray"),
			text_color = Colors.get_table("dark_gray")
		}
	}

	tbl_9.content.list_content[i] = tbl_10
	tbl_9.style.list_style.item_styles[i] = tbl_11
end

tbl_9.style.list_style.num_draws = count

local tbl_12 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 32,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_table("font_title"),
	offset = {
		0,
		0,
		2
	}
}
local tbl_13 = {
	use_shadow = true,
	vertical_alignment = "top",
	horizontal_alignment = "right",
	dynamic_font_size = true,
	font_size = 28,
	font_type = "hell_shark",
	text_color = Colors.get_table("font_default"),
	offset = {
		0,
		0,
		2
	}
}
local tbl_14 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 36,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_table("font_title"),
	offset = {
		0,
		0,
		0
	}
}
local tbl_15 = {
	use_shadow = true,
	vertical_alignment = "top",
	localize = false,
	horizontal_alignment = "left",
	font_size = 24,
	font_type = "hell_shark",
	text_color = Colors.get_table("font_default"),
	offset = {
		0,
		0,
		0
	}
}
local tbl_16 = {
	vertical_alignment = "top",
	use_shadow = true,
	horizontal_alignment = "left",
	font_size = 18,
	font_type = "hell_shark",
	text_color = Colors.get_table("font_default"),
	offset = {
		0,
		0,
		0
	}
}
local tbl_17 = {
	vertical_alignment = "top",
	use_shadow = true,
	horizontal_alignment = "left",
	font_size = 28,
	font_type = "hell_shark_header",
	text_color = Colors.get_table("font_title"),
	offset = {
		0,
		0,
		0
	}
}
local tbl_18 = {
	vertical_alignment = "top",
	use_shadow = true,
	horizontal_alignment = "left",
	font_size = 28,
	font_type = "hell_shark_header",
	text_color = Colors.get_table("white"),
	offset = {
		0,
		0,
		0
	}
}
local tbl_19 = {
	vertical_alignment = "top",
	use_shadow = true,
	horizontal_alignment = "left",
	font_size = 22,
	font_type = "hell_shark",
	text_color = Colors.get_table("white"),
	offset = {
		0,
		0,
		0
	}
}
local tbl_20 = {
	vertical_alignment = "top",
	use_shadow = true,
	horizontal_alignment = "center",
	font_size = 22,
	font_type = "hell_shark",
	text_color = Colors.get_table("font_title"),
	offset = {
		0,
		30,
		0
	}
}
local tbl_21 = {
	font_type = "hell_shark_header",
	use_shadow = true,
	localize = false,
	font_size = 28,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	area_size = {
		260,
		100
	},
	text_color = Colors.get_table("font_title"),
	offset = {
		0,
		0,
		0
	}
}
local tbl_22 = {
	font_type = "hell_shark",
	font_size = 24,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	area_size = {
		300,
		100
	},
	text_color = Colors.get_table("font_default"),
	offset = {
		0,
		0,
		0
	}
}
local tbl_23 = {
	font_size = 24,
	upper_case = true,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_table("white"),
	offset = {
		0,
		0,
		1
	}
}
local tbl_24 = {
	mutators = {
		text = {
			font_size = 26,
			word_wrap = true,
			font_type = "hell_shark",
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			area_size = {
				540,
				90
			},
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			line_colors = {
				Colors.get_color_table_with_alpha("font_title", 255),
				Colors.get_color_table_with_alpha("font_default", 255)
			}
		},
		text_shadow = {
			word_wrap = true,
			font_size = 26,
			font_type = "hell_shark",
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			area_size = {
				540,
				90
			},
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				1,
				-1,
				-1
			}
		}
	}
}
local tbl_25 = {
	banner_left = UIWidgets.create_simple_rect("banner_left", tbl_6),
	banner_right = UIWidgets.create_simple_rect("banner_right", tbl_6),
	banner_left_edge = fn("banner_left", {
		5,
		tbl_7.banner_left.size[2]
	}),
	banner_right_edge = fn("banner_right", {
		5,
		tbl_7.banner_right.size[2]
	}),
	player_name_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "player_name_divider"),
	mission_details_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "mission_details_divider"),
	mechanism_type_name = UIWidgets.create_simple_text(string.upper(Localize("not_assigned")), "mechanism_type_name", 22, nil, tbl_17),
	mission_type_name = UIWidgets.create_simple_text(string.upper(Localize("not_assigned")), "mission_type_name", 22, nil, tbl_19),
	player_ability_title = UIWidgets.create_simple_text(Localize("hero_view_activated_ability"), "player_ability_title", 22, nil, tbl_16),
	player_passive_title = UIWidgets.create_simple_text(Localize("hero_view_passive_ability"), "player_passive_title", 22, nil, tbl_16)
}
local num_2 = 0
local tbl_26 = {
	player_ability_name = UIWidgets.create_simple_text("n/a", "player_ability_name", 22, nil, tbl_21),
	player_ability_description = UIWidgets.create_simple_text("n/a", "player_ability_description", 22, nil, tbl_22),
	player_ability_icon = UIWidgets.create_simple_texture("icons_placeholder", "player_ability_icon"),
	player_passive_name = UIWidgets.create_simple_text("n/a", "player_passive_name", 22, nil, tbl_21),
	player_passive_description = UIWidgets.create_simple_text("n/a", "player_passive_description", 22, nil, tbl_22),
	player_passive_icon = UIWidgets.create_simple_texture("icons_placeholder", "player_passive_icon"),
	game_level = UIWidgets.create_simple_text("n/a", "game_level", 22, nil, tbl_12),
	game_difficulty = UIWidgets.create_simple_text("n/a", "game_difficulty", 22, nil, tbl_13),
	player_career_name = UIWidgets.create_simple_text("n/a", "player_career_name", 22, nil, tbl_14),
	player_hero_name = UIWidgets.create_simple_text("n/a", "player_hero_name", 22, nil, tbl_15),
	mutator_summary1 = UIWidgets.create_simple_item_presentation("mutator_summary1", {
		"mutators"
	}, nil, tbl_24),
	mutator_summary2 = UIWidgets.create_simple_item_presentation("mutator_summary2", {
		"mutators"
	}, nil, tbl_24),
	mutator_summary3 = UIWidgets.create_simple_item_presentation("mutator_summary3", {
		"mutators"
	}, nil, tbl_24),
	mutator_summary4 = UIWidgets.create_simple_item_presentation("mutator_summary4", {
		"mutators"
	}, nil, tbl_24),
	mutator_summary5 = UIWidgets.create_simple_item_presentation("mutator_summary5", {
		"mutators"
	}, nil, tbl_24),
	mutator_summary6 = UIWidgets.create_simple_item_presentation("mutator_summary6", {
		"mutators"
	}, nil, tbl_24)
}
local tbl_27 = {
	weave_objective_header = UIWidgets.create_simple_text(Utf8.upper(Localize("menu_weave_play_objective_title")), "weave_objective_header", 22, nil, tbl_17),
	weave_objective_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "weave_objective_divider"),
	main_objective_text = UIWidgets.create_simple_text(Localize("menu_weave_play_objective_sub_title"), "weave_main_objective", 22, nil, tbl_18)
}
local tbl_28 = {
	reward_header = UIWidgets.create_simple_text(Localize("deed_reward_title"), "reward_divider", 22, nil, tbl_20),
	reward_divider = UIWidgets.create_simple_texture("divider_01_top", "reward_divider"),
	collectibles_name = UIWidgets.create_simple_text(Utf8.upper(Localize("collectibles_name")), "collectibles_name", 22, nil, tbl_17),
	collectibles_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "collectibles_divider"),
	level_description = fn_5("", "level_description"),
	input_description_text = UIWidgets.create_simple_text("player_list_show_mouse_description", "player_list_input_description", nil, nil, tbl_23),
	private_checkbox = UIWidgets.create_checkbox_widget("start_game_window_private_game", "", "private_checkbox", num_2, nil)
}
local flag = true

return {
	PLAYER_LIST_SIZE = tbl,
	scenegraph_definition = tbl_7,
	widget_definitions = tbl_26,
	specific_widget_definitions = tbl_28,
	static_widget_definitions = tbl_25,
	player_widget_definition = fn_7,
	weave_objective_widgets = tbl_27,
	create_weave_sub_objective_widget = fn_4,
	popup_widget_definition = tbl_9,
	create_loot_widget = fn_2,
	create_reward_item = fn_6,
	create_node_info_widget = fn_3,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", UISettings.console_tooltip_pass_definitions, nil, nil, flag)
}
