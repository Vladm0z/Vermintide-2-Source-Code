-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_details_definitions.lua

local var_0_0 = 40
local var_0_1 = 450
local var_0_2 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.end_screen
		},
		size = {
			1920,
			1080
		}
	},
	panel = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		size = {
			1800,
			1080
		}
	},
	local_team_anchor = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		position = {
			280,
			-323,
			10
		},
		size = {
			370,
			var_0_0 * 2
		}
	},
	local_heroes_score_title = {
		vertical_alignment = "top",
		parent = "local_team_anchor",
		horizontal_alignment = "left",
		position = {
			390,
			0,
			10
		},
		size = {
			var_0_1,
			var_0_0 * 2
		}
	},
	local_pactsworn_score_title = {
		vertical_alignment = "top",
		parent = "local_heroes_score_title",
		horizontal_alignment = "left",
		position = {
			var_0_1 + 20,
			0,
			10
		},
		size = {
			var_0_1,
			var_0_0 * 2
		}
	},
	local_pactsworn_score_edge = {
		vertical_alignment = "top",
		parent = "local_pactsworn_score_title",
		horizontal_alignment = "left",
		position = {
			var_0_1,
			0,
			10
		},
		size = {
			200,
			var_0_0 * 2
		}
	},
	local_flag = {
		vertical_alignment = "top",
		parent = "local_team_anchor",
		horizontal_alignment = "left",
		position = {
			-140,
			5,
			100
		},
		size = {
			232,
			196
		}
	},
	local_winner_icon = {
		vertical_alignment = "top",
		parent = "local_flag",
		horizontal_alignment = "left",
		position = {
			-20,
			90,
			10
		},
		size = {
			140,
			140
		}
	},
	local_names_anchor = {
		vertical_alignment = "top",
		parent = "local_team_anchor",
		horizontal_alignment = "left",
		position = {
			100,
			-80,
			10
		},
		size = {
			270,
			var_0_0
		}
	},
	local_anchor = {
		vertical_alignment = "top",
		parent = "local_names_anchor",
		horizontal_alignment = "left",
		position = {
			290,
			0,
			10
		},
		size = {
			var_0_1,
			var_0_0
		}
	},
	local_pact_anchor = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "left",
		position = {
			var_0_1 + 20,
			0,
			0
		},
		size = {
			var_0_1,
			var_0_0
		}
	},
	local_color_edge = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "left",
		position = {
			-2,
			0,
			5
		},
		size = {
			4,
			var_0_0 * 5
		}
	},
	local_score_bg = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "left",
		position = {
			-76,
			0,
			-1
		},
		size = {
			76,
			54
		}
	},
	local_score_bg_top = {
		vertical_alignment = "top",
		parent = "local_score_bg",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			-1
		},
		size = {
			76,
			20
		}
	},
	local_score_bg_edge = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "left",
		position = {
			-20,
			0,
			-1
		},
		size = {
			20,
			54
		}
	},
	local_title = {
		vertical_alignment = "bottom",
		parent = "local_team_anchor",
		horizontal_alignment = "left",
		position = {
			100,
			0,
			1
		},
		size = {
			270,
			var_0_0 * 2
		}
	},
	local_names_grid = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 5
		}
	},
	local_heroes_grid = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 6
		}
	},
	local_heroes_score_grid = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 5
		}
	},
	local_heroes_header_grid = {
		vertical_alignment = "top",
		parent = "local_heroes_score_title",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0
		}
	},
	local_pact_grid = {
		vertical_alignment = "top",
		parent = "local_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 6
		}
	},
	local_pact_score_grid = {
		vertical_alignment = "top",
		parent = "local_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 5
		}
	},
	local_pact_header_grid = {
		vertical_alignment = "top",
		parent = "local_pactsworn_score_title",
		horizontal_alignment = "left",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0
		}
	},
	opponent_team_anchor = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		position = {
			280,
			-323,
			10
		},
		size = {
			370,
			var_0_0 * 2
		}
	},
	opponent_heroes_score_title = {
		vertical_alignment = "top",
		parent = "opponent_team_anchor",
		horizontal_alignment = "left",
		position = {
			390,
			0,
			10
		},
		size = {
			var_0_1,
			var_0_0 * 2
		}
	},
	opponent_pactsworn_score_title = {
		vertical_alignment = "top",
		parent = "opponent_heroes_score_title",
		horizontal_alignment = "left",
		position = {
			var_0_1 + 20,
			0,
			10
		},
		size = {
			var_0_1,
			var_0_0 * 2
		}
	},
	opponent_pactsworn_score_edge = {
		vertical_alignment = "top",
		parent = "opponent_pactsworn_score_title",
		horizontal_alignment = "left",
		position = {
			var_0_1,
			0,
			10
		},
		size = {
			200,
			var_0_0 * 2
		}
	},
	opponent_flag = {
		vertical_alignment = "top",
		parent = "opponent_team_anchor",
		horizontal_alignment = "left",
		position = {
			-140,
			5,
			100
		},
		size = {
			232,
			196
		}
	},
	opponent_winner_icon = {
		vertical_alignment = "top",
		parent = "opponent_flag",
		horizontal_alignment = "left",
		position = {
			-20,
			90,
			10
		},
		size = {
			140,
			140
		}
	},
	opponent_names_anchor = {
		vertical_alignment = "top",
		parent = "opponent_team_anchor",
		horizontal_alignment = "left",
		position = {
			100,
			-80,
			10
		},
		size = {
			270,
			var_0_0
		}
	},
	opponent_anchor = {
		vertical_alignment = "top",
		parent = "opponent_names_anchor",
		horizontal_alignment = "left",
		position = {
			290,
			0,
			10
		},
		size = {
			var_0_1,
			var_0_0
		}
	},
	opponent_pact_anchor = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "left",
		position = {
			var_0_1 + 20,
			0,
			0
		},
		size = {
			var_0_1,
			var_0_0
		}
	},
	opponent_color_edge = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "left",
		position = {
			-2,
			0,
			5
		},
		size = {
			4,
			var_0_0 * 5
		}
	},
	opponent_score_bg = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "left",
		position = {
			-76,
			0,
			-1
		},
		size = {
			76,
			54
		}
	},
	opponent_score_bg_top = {
		vertical_alignment = "top",
		parent = "opponent_score_bg",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			-1
		},
		size = {
			76,
			20
		}
	},
	opponent_score_bg_edge = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "left",
		position = {
			-20,
			0,
			-1
		},
		size = {
			20,
			54
		}
	},
	opponent_title = {
		vertical_alignment = "bottom",
		parent = "opponent_team_anchor",
		horizontal_alignment = "left",
		position = {
			100,
			0,
			1
		},
		size = {
			270,
			var_0_0 * 2
		}
	},
	opponent_names_grid = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 5
		}
	},
	opponent_heroes_grid = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 6
		}
	},
	opponent_heroes_score_grid = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 5
		}
	},
	opponent_pact_grid = {
		vertical_alignment = "top",
		parent = "opponent_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 6
		}
	},
	opponent_pact_score_grid = {
		vertical_alignment = "top",
		parent = "opponent_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			1
		},
		size = {
			var_0_1,
			var_0_0 * 5
		}
	},
	heroes_header_bg = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			0
		},
		size = {
			var_0_1,
			var_0_0
		}
	},
	pact_header_bg = {
		vertical_alignment = "top",
		parent = "local_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_0,
			0
		},
		size = {
			var_0_1,
			var_0_0
		}
	}
}
local var_0_3 = {
	255,
	24,
	24,
	24
}
local var_0_4 = {
	255,
	226,
	220,
	209
}
local var_0_5 = Colors.get_color_table_with_alpha("local_player_team", 255)
local var_0_6 = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)
local var_0_7 = Colors.get_color_table_with_alpha("local_player_team_darker", 255)
local var_0_8 = Colors.get_color_table_with_alpha("opponent_team", 255)
local var_0_9 = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
local var_0_10 = Colors.get_color_table_with_alpha("opponent_team_darkened", 255)
local var_0_11 = Colors.get_table("local_scoreboard_entry_dark")
local var_0_12 = Colors.get_table("local_scoreboard_entry")
local var_0_13 = Colors.get_table("opponent_scoreboard_entry_dark")
local var_0_14 = Colors.get_table("opponent_scoreboard_entry")

local function var_0_15(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = arg_1_4 or {
		255,
		10,
		10,
		10
	}
	local var_1_1 = var_0_2[arg_1_0].size

	var_1_1[2] = arg_1_1 * var_0_0

	local var_1_2 = {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
	local var_1_3 = var_1_2.element.passes
	local var_1_4 = var_1_2.content
	local var_1_5 = var_1_2.style

	var_1_3[#var_1_3 + 1] = {
		pass_type = "rect",
		style_id = "left_border"
	}
	var_1_3[#var_1_3 + 1] = {
		pass_type = "rect",
		style_id = "right_border"
	}
	var_1_3[#var_1_3 + 1] = {
		pass_type = "rect",
		style_id = "top_border"
	}
	var_1_3[#var_1_3 + 1] = {
		pass_type = "rect",
		style_id = "bottom_border"
	}
	var_1_5.left_border = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			arg_1_3,
			var_1_1[2]
		},
		color = var_1_0
	}
	var_1_5.right_border = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		texture_size = {
			arg_1_3,
			var_1_1[2]
		},
		color = var_1_0
	}
	var_1_5.top_border = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			var_1_1[1],
			arg_1_3
		},
		color = var_1_0
	}
	var_1_5.bottom_border = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			var_1_1[1],
			-arg_1_3
		},
		color = var_1_0,
		offset = {
			0,
			-var_1_1[2],
			0
		}
	}

	local var_1_6 = var_1_1[2] / arg_1_1

	for iter_1_0 = 1, arg_1_1 - 1 do
		var_1_3[#var_1_3 + 1] = {
			pass_type = "rect",
			style_id = "row_edge_" .. iter_1_0
		}
		var_1_5["row_edge_" .. iter_1_0] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				var_1_1[1],
				arg_1_3
			},
			offset = {
				0,
				-var_1_6 * iter_1_0 + arg_1_3 * 0.5,
				0
			},
			color = var_1_0
		}
	end

	local var_1_7 = var_1_1[1] / arg_1_2

	for iter_1_1 = 1, arg_1_2 - 1 do
		var_1_3[#var_1_3 + 1] = {
			pass_type = "rect",
			style_id = "column_edge_" .. iter_1_1
		}
		var_1_5["column_edge_" .. iter_1_1] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				arg_1_3,
				var_1_1[2]
			},
			offset = {
				var_1_7 * iter_1_1,
				0,
				0
			},
			color = var_1_0
		}
	end

	return var_1_2
end

local var_0_16 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		-2,
		10
	}
}
local var_0_17 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = var_0_4,
	offset = {
		0,
		-2,
		1
	},
	size = {
		0,
		0
	}
}
local var_0_18 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	font_size = 20,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		-2,
		1
	},
	size = {
		0,
		0
	}
}
local var_0_19 = {
	word_wrap = false,
	upper_case = true,
	localize = true,
	font_size = 36,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		12,
		-12,
		1
	},
	size = {
		0,
		0
	}
}
local var_0_20 = {
	word_wrap = false,
	upper_case = false,
	localize = true,
	font_size = 20,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = var_0_4,
	offset = {
		12,
		18,
		1
	},
	size = {
		0,
		0
	}
}
local var_0_21 = {
	word_wrap = false,
	upper_case = true,
	localize = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = var_0_4,
	offset = {
		0,
		-2,
		1
	},
	size = {
		0,
		0
	}
}

local function var_0_22(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = var_0_2[arg_2_0]
	local var_2_1 = table.clone(var_2_0.size)
	local var_2_2 = table.clone(var_0_21)

	var_2_2.text_color = arg_2_2
	var_2_2.size = var_2_1

	local var_2_3 = {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		scenegraph_id = arg_2_0,
		offset = {
			0,
			27,
			0
		}
	}
	local var_2_4 = var_2_3.element.passes
	local var_2_5 = var_2_3.content
	local var_2_6 = var_2_3.style

	var_2_4[#var_2_4 + 1] = {
		style_id = "title",
		pass_type = "text",
		text_id = "title"
	}
	var_2_4[#var_2_4 + 1] = {
		style_id = "title_shadow",
		pass_type = "text",
		text_id = "title"
	}
	var_2_5.title = tostring(arg_2_1)
	var_2_6.title = var_2_2
	var_2_6.title_shadow = table.clone(var_2_2)
	var_2_6.title_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	var_2_6.title_shadow.offset = {
		2,
		-3,
		-1
	}
	var_2_6.underline = {
		vertical_alignment = "bottom",
		horizontal_alignment = "center",
		color = arg_2_2,
		texture_size = {
			var_2_1[1],
			4
		}
	}
	var_2_5.gradient = {
		texture_id = "vertical_gradient",
		uvs = {
			{
				0,
				1
			},
			{
				1,
				0
			}
		}
	}
	var_2_6.left_gradient = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		color = arg_2_2,
		texture_size = {
			4,
			8
		},
		offset = {
			0,
			-8,
			0
		}
	}
	var_2_6.right_gradient = {
		vertical_alignment = "bottom",
		horizontal_alignment = "right",
		color = arg_2_2,
		texture_size = {
			4,
			10
		},
		offset = {
			0,
			-10,
			0
		}
	}

	return var_2_3
end

local function var_0_23(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = var_0_2[arg_3_0].size
	local var_3_1 = 12
	local var_3_2 = {
		var_3_0[1] / #arg_3_1,
		var_3_0[2]
	}
	local var_3_3 = table.clone(var_0_17)

	var_3_3.font_size = arg_3_2 or var_3_3.font_size
	var_3_3.text_color = arg_3_4 and {
		255,
		177,
		144,
		31
	} or var_3_3.text_color

	if arg_3_7 then
		var_3_3.text_color = arg_3_7 == "local_team" and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	end

	local var_3_4 = {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		scenegraph_id = arg_3_0,
		offset = arg_3_3 or {
			0,
			0,
			0
		}
	}
	local var_3_5 = var_3_4.element.passes
	local var_3_6 = var_3_4.content
	local var_3_7 = var_3_4.style

	for iter_3_0 = 1, #arg_3_1 do
		local var_3_8 = "stat_" .. iter_3_0

		var_3_5[#var_3_5 + 1] = {
			pass_type = "text",
			text_id = var_3_8,
			style_id = var_3_8
		}

		if not arg_3_5 then
			var_3_5[#var_3_5 + 1] = {
				pass_type = "texture",
				texture_id = "highscore_marker",
				style_id = var_3_8 .. "_highscore_marker",
				content_check_function = function (arg_4_0, arg_4_1)
					return arg_4_0[var_3_8 .. "_is_highscore"]
				end
			}
			var_3_5[#var_3_5 + 1] = {
				pass_type = "texture",
				texture_id = "highscore_marker",
				style_id = var_3_8 .. "_highscore_marker_shadow",
				content_check_function = function (arg_5_0, arg_5_1)
					return arg_5_0[var_3_8 .. "_is_highscore"]
				end
			}
		end

		var_3_5[#var_3_5 + 1] = {
			pass_type = "text",
			text_id = var_3_8,
			style_id = var_3_8 .. "_shadow"
		}

		local var_3_9 = arg_3_1[iter_3_0]

		if type(var_3_9) == "number" then
			var_3_9 = math.round(var_3_9)
		end

		var_3_6[var_3_8] = tostring(var_3_9)
		var_3_6.highscore_marker = "scoreboard_marker"
		var_3_6.offset = arg_3_3
		var_3_6[var_3_8 .. "_is_highscore"] = not arg_3_5 and arg_3_6 and arg_3_6[iter_3_0] == var_3_9 and var_3_9 > 0 or false
		var_3_7[var_3_8] = table.clone(var_3_3)
		var_3_7[var_3_8].offset[1] = (iter_3_0 - 1) * var_3_2[1] + var_3_1
		var_3_7[var_3_8].size = {
			var_3_2[1] - var_3_1 * 2,
			var_3_2[2]
		}
		var_3_7[var_3_8 .. "_shadow"] = table.clone(var_3_3)
		var_3_7[var_3_8 .. "_shadow"].offset = {
			(iter_3_0 - 1) * var_3_2[1] + 2 + var_3_1,
			-3,
			-1
		}
		var_3_7[var_3_8 .. "_shadow"].size = {
			var_3_2[1] - var_3_1 * 2,
			var_3_2[2]
		}
		var_3_7[var_3_8 .. "_shadow"].text_color = {
			255,
			0,
			0,
			0
		}
		var_3_7[var_3_8 .. "_highscore_marker"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				71,
				39
			},
			offset = {
				(iter_3_0 - 1) * var_3_2[1],
				0,
				5
			},
			size = {
				var_3_2[1],
				var_3_2[2]
			}
		}
		var_3_7[var_3_8 .. "_highscore_marker_shadow"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				71,
				39
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				(iter_3_0 - 1) * var_3_2[1] + 1,
				-1,
				4
			},
			size = {
				var_3_2[1],
				var_3_2[2]
			}
		}
	end

	return var_3_4
end

local function var_0_24(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = var_0_2[arg_6_0]
	local var_6_1 = table.clone(var_6_0.size)

	var_6_1[1] = 170

	local var_6_2 = var_0_4
	local var_6_3 = table.clone(var_0_18)

	var_6_3.font_size = arg_6_2 or var_6_3.font_size
	var_6_3.text_color = arg_6_4 and {
		255,
		177,
		144,
		31
	} or var_6_2
	var_6_3.size = var_6_1

	local var_6_4 = {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		scenegraph_id = arg_6_0,
		offset = arg_6_3 or {
			0,
			0,
			0
		}
	}
	local var_6_5 = var_6_4.element.passes
	local var_6_6 = var_6_4.content
	local var_6_7 = var_6_4.style

	var_6_5[#var_6_5 + 1] = {
		style_id = "title",
		pass_type = "text",
		text_id = "title"
	}
	var_6_5[#var_6_5 + 1] = {
		style_id = "title_shadow",
		pass_type = "text",
		text_id = "title"
	}
	var_6_6.title = tostring(arg_6_1)
	var_6_7.title = var_6_3
	var_6_7.title_shadow = table.clone(var_6_3)
	var_6_7.title_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	var_6_7.title_shadow.offset = {
		2,
		-3,
		-1
	}

	return var_6_4
end

local function var_0_25(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0 == "local_team"
	local var_7_1 = var_7_0 and "local_title" or "opponent_title"
	local var_7_2 = var_0_2[var_7_1]
	local var_7_3 = table.clone(var_7_2.size)
	local var_7_4 = var_7_0 and arg_7_1 or arg_7_2
	local var_7_5 = UISettings.teams_ui_assets[var_7_4]

	if not var_7_0 or not var_0_5 then
		local var_7_6 = var_0_8
	end

	if not var_7_0 or not var_0_6 then
		local var_7_7 = var_0_9
	end

	if not var_7_0 or not var_0_7 then
		local var_7_8 = var_0_10
	end

	local var_7_9 = var_7_0 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	local var_7_10 = table.clone(var_0_19)

	var_7_10.size = var_7_3
	var_7_10.text_color = var_7_9

	local var_7_11 = {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		scenegraph_id = var_7_1,
		offset = {
			0,
			0,
			0
		}
	}
	local var_7_12 = var_7_11.element.passes
	local var_7_13 = var_7_11.content
	local var_7_14 = var_7_11.style

	var_7_12[#var_7_12 + 1] = {
		style_id = "title",
		pass_type = "text",
		text_id = "title"
	}
	var_7_12[#var_7_12 + 1] = {
		style_id = "title_shadow",
		pass_type = "text",
		text_id = "title"
	}
	var_7_13.title = var_7_5.display_name
	var_7_14.title = var_7_10
	var_7_14.title_shadow = table.clone(var_7_10)
	var_7_14.title_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	var_7_14.title_shadow.offset[1] = var_7_14.title_shadow.offset[1] + 2
	var_7_14.title_shadow.offset[2] = var_7_14.title_shadow.offset[2] - 2
	var_7_14.title_shadow.offset[3] = var_7_14.title_shadow.offset[3] - 1
	var_7_12[#var_7_12 + 1] = {
		style_id = "team_type",
		pass_type = "text",
		text_id = "team_type"
	}
	var_7_12[#var_7_12 + 1] = {
		style_id = "team_type_shadow",
		pass_type = "text",
		text_id = "team_type"
	}
	var_7_13.team_type = var_7_0 and "vs_lobby_your_team" or "vs_lobby_enemy_team"

	local var_7_15 = table.clone(var_0_20)

	var_7_15.size = var_7_3
	var_7_14.team_type = var_7_15
	var_7_14.team_type_shadow = table.clone(var_7_15)
	var_7_14.team_type_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	var_7_14.team_type_shadow.offset[1] = var_7_14.team_type_shadow.offset[1] + 2
	var_7_14.team_type_shadow.offset[2] = var_7_14.team_type_shadow.offset[2] - 2
	var_7_14.team_type_shadow.offset[3] = var_7_14.team_type_shadow.offset[3] - 1

	return var_7_11
end

local var_0_26 = {
	background = UIWidgets.create_simple_rect("screen", {
		128,
		0,
		0,
		0
	}),
	heroes_side_title = var_0_22("local_heroes_header_grid", "vs_as_heroes", var_0_4),
	pactsworn_side_title = var_0_22("local_pact_header_grid", "vs_as_pactsworn", var_0_4),
	local_gradient = UIWidgets.create_simple_uv_texture("horizontal_gradient", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "local_pactsworn_score_edge", nil, nil, {
		200,
		0,
		0,
		0
	}),
	opponent_gradient = UIWidgets.create_simple_uv_texture("horizontal_gradient", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "opponent_pactsworn_score_edge", nil, nil, {
		200,
		0,
		0,
		0
	})
}

local function var_0_27(arg_8_0)
	local var_8_0 = arg_8_0 == "local_team" and "local_winner_icon" or "opponent_winner_icon"

	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
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
				}
			}
		},
		content = {
			texture_id = "winner_icon",
			text_id = "WINNER"
		},
		style = {
			texture_id = {
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
			text = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				font_size = 32,
				horizontal_alignment = "center",
				vertical_alignment = "right",
				dynamic_font_size = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("local_player_picking", 255),
				offset = {
					90,
					46,
					1
				}
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				font_size = 32,
				horizontal_alignment = "center",
				vertical_alignment = "right",
				dynamic_font_size = false,
				font_type = "hell_shark",
				text_color = {
					0,
					0,
					0,
					0
				},
				offset = {
					92,
					44,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = var_8_0
	}
end

local function var_0_28(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = "icons_placeholder"
	local var_9_1 = ""
	local var_9_2

	if arg_9_0 == "local_team" then
		var_9_0 = UISettings.teams_ui_assets[arg_9_1].local_flag_texture or var_9_0
		var_9_2 = "local_flag"
	else
		var_9_0 = UISettings.teams_ui_assets[arg_9_2].opponent_flag_texture or var_9_0
		var_9_2 = "opponent_flag"
	end

	return UIWidgets.create_simple_texture(var_9_0, var_9_2)
end

local function var_0_29(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = var_0_2[arg_10_0].size

	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "rect"
				}
			}
		},
		content = {},
		style = {
			rect = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = arg_10_1 or {
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
				texture_size = {
					var_10_0[1],
					arg_10_2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_10_0
	}
end

local function var_0_30(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = var_0_2[arg_11_0].size

	for iter_11_0 = 1, arg_11_1 do
		local var_11_1 = {
			0,
			(iter_11_0 - 1) * -var_11_0[2]
		}
		local var_11_2 = iter_11_0 % 2 == 0 and arg_11_4 or arg_11_5 or {
			128,
			0,
			0,
			0
		}

		arg_11_3[arg_11_2 .. "_" .. iter_11_0] = UIWidgets.create_simple_rect(arg_11_0, var_11_2, nil, var_11_1)
	end
end

local function var_0_31(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = {}

	if arg_12_0 == "local_team" then
		var_0_30("local_team_anchor", 1, "local_team", var_12_0)
		var_0_30("local_heroes_score_title", 1, "local_team_heroes", var_12_0)
		var_0_30("local_pactsworn_score_title", 1, "local_team_pactsworn", var_12_0)
		var_0_30("local_names_anchor", arg_12_1, "local_names", var_12_0, var_0_11, var_0_12)
		var_0_30("local_anchor", arg_12_1, "local_heroes", var_12_0, var_0_11, var_0_12)
		var_0_30("local_pact_anchor", arg_12_1, "local_pact", var_12_0, var_0_11, var_0_12)

		arg_12_2.opponent_team_anchor.local_position[2] = var_0_2.local_team_anchor.position[2] - 5 * var_0_0 - var_0_2.local_team_anchor.size[2]
	else
		var_0_30("opponent_team_anchor", 1, "opponent_team", var_12_0)
		var_0_30("opponent_heroes_score_title", 1, "opponent_team_heroes", var_12_0)
		var_0_30("opponent_pactsworn_score_title", 1, "opponent_team_pactsworn", var_12_0)
		var_0_30("opponent_names_anchor", arg_12_1, "opponent_names", var_12_0, var_0_13, var_0_14)
		var_0_30("opponent_anchor", arg_12_1, "opponent_heroes", var_12_0, var_0_13, var_0_14)
		var_0_30("opponent_pact_anchor", arg_12_1, "opponent_pact", var_12_0, var_0_13, var_0_14)
	end

	return var_12_0
end

local var_0_32 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				arg_13_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = math.easeOutCubic(arg_14_3)

				arg_14_4.render_settings.alpha_multiplier = var_14_0
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				arg_16_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = math.easeOutCubic(arg_17_3)

				arg_17_4.render_settings.alpha_multiplier = 1 - var_17_0
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_2,
	widget_definitions = var_0_26,
	animation_definitions = var_0_32,
	create_stats_func = var_0_23,
	create_title_func = var_0_24,
	create_team_grid_fields_func = var_0_31,
	create_team_title_func = var_0_25,
	create_flag_func = var_0_28,
	create_winner_icon_func = var_0_27
}
