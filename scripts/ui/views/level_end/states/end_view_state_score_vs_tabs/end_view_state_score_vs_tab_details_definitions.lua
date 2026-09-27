-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_details_definitions.lua

local num = 40
local num_2 = 450
local tbl = {
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
			num * 2
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
			num_2,
			num * 2
		}
	},
	local_pactsworn_score_title = {
		vertical_alignment = "top",
		parent = "local_heroes_score_title",
		horizontal_alignment = "left",
		position = {
			num_2 + 20,
			0,
			10
		},
		size = {
			num_2,
			num * 2
		}
	},
	local_pactsworn_score_edge = {
		vertical_alignment = "top",
		parent = "local_pactsworn_score_title",
		horizontal_alignment = "left",
		position = {
			num_2,
			0,
			10
		},
		size = {
			200,
			num * 2
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
			num
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
			num_2,
			num
		}
	},
	local_pact_anchor = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "left",
		position = {
			num_2 + 20,
			0,
			0
		},
		size = {
			num_2,
			num
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
			num * 5
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
			num * 2
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
			num_2,
			num * 5
		}
	},
	local_heroes_grid = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num * 6
		}
	},
	local_heroes_score_grid = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num * 5
		}
	},
	local_heroes_header_grid = {
		vertical_alignment = "top",
		parent = "local_heroes_score_title",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num
		}
	},
	local_pact_grid = {
		vertical_alignment = "top",
		parent = "local_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num * 6
		}
	},
	local_pact_score_grid = {
		vertical_alignment = "top",
		parent = "local_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num * 5
		}
	},
	local_pact_header_grid = {
		vertical_alignment = "top",
		parent = "local_pactsworn_score_title",
		horizontal_alignment = "left",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num
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
			num * 2
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
			num_2,
			num * 2
		}
	},
	opponent_pactsworn_score_title = {
		vertical_alignment = "top",
		parent = "opponent_heroes_score_title",
		horizontal_alignment = "left",
		position = {
			num_2 + 20,
			0,
			10
		},
		size = {
			num_2,
			num * 2
		}
	},
	opponent_pactsworn_score_edge = {
		vertical_alignment = "top",
		parent = "opponent_pactsworn_score_title",
		horizontal_alignment = "left",
		position = {
			num_2,
			0,
			10
		},
		size = {
			200,
			num * 2
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
			num
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
			num_2,
			num
		}
	},
	opponent_pact_anchor = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "left",
		position = {
			num_2 + 20,
			0,
			0
		},
		size = {
			num_2,
			num
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
			num * 5
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
			num * 2
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
			num_2,
			num * 5
		}
	},
	opponent_heroes_grid = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num * 6
		}
	},
	opponent_heroes_score_grid = {
		vertical_alignment = "top",
		parent = "opponent_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num * 5
		}
	},
	opponent_pact_grid = {
		vertical_alignment = "top",
		parent = "opponent_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num * 6
		}
	},
	opponent_pact_score_grid = {
		vertical_alignment = "top",
		parent = "opponent_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			1
		},
		size = {
			num_2,
			num * 5
		}
	},
	heroes_header_bg = {
		vertical_alignment = "top",
		parent = "local_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			0
		},
		size = {
			num_2,
			num
		}
	},
	pact_header_bg = {
		vertical_alignment = "top",
		parent = "local_pact_anchor",
		horizontal_alignment = "right",
		position = {
			0,
			num,
			0
		},
		size = {
			num_2,
			num
		}
	}
}
local tbl_2 = {
	255,
	24,
	24,
	24
}
local tbl_3 = {
	255,
	226,
	220,
	209
}
local get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team", 255)
local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)
local get_color_table_with_alpha_3 = Colors.get_color_table_with_alpha("local_player_team_darker", 255)
local get_color_table_with_alpha_4 = Colors.get_color_table_with_alpha("opponent_team", 255)
local get_color_table_with_alpha_5 = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
local get_color_table_with_alpha_6 = Colors.get_color_table_with_alpha("opponent_team_darkened", 255)
local get_table = Colors.get_table("local_scoreboard_entry_dark")
local get_table_2 = Colors.get_table("local_scoreboard_entry")
local get_table_3 = Colors.get_table("opponent_scoreboard_entry_dark")
local get_table_4 = Colors.get_table("opponent_scoreboard_entry")

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local flag = arg_1_4 or {
		255,
		10,
		10,
		10
	}
	local size = tbl[arg_1_0].size

	size[2] = arg_1_1 * num

	local tbl_2 = {
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
	local passes = tbl_2.element.passes
	local content = tbl_2.content
	local style = tbl_2.style

	passes[#passes + 1] = {
		pass_type = "rect",
		style_id = "left_border"
	}
	passes[#passes + 1] = {
		pass_type = "rect",
		style_id = "right_border"
	}
	passes[#passes + 1] = {
		pass_type = "rect",
		style_id = "top_border"
	}
	passes[#passes + 1] = {
		pass_type = "rect",
		style_id = "bottom_border"
	}
	style.left_border = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			arg_1_3,
			size[2]
		},
		color = flag
	}
	style.right_border = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		texture_size = {
			arg_1_3,
			size[2]
		},
		color = flag
	}
	style.top_border = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			size[1],
			arg_1_3
		},
		color = flag
	}
	style.bottom_border = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			size[1],
			-arg_1_3
		},
		color = flag,
		offset = {
			0,
			-size[2],
			0
		}
	}

	local num_2 = size[2] / arg_1_1

	for i = 1, arg_1_1 - 1 do
		passes[#passes + 1] = {
			pass_type = "rect",
			style_id = "row_edge_" .. i
		}
		style["row_edge_" .. i] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				size[1],
				arg_1_3
			},
			offset = {
				0,
				-num_2 * i + arg_1_3 * 0.5,
				0
			},
			color = flag
		}
	end

	local num_3 = size[1] / arg_1_2

	for j = 1, arg_1_2 - 1 do
		passes[#passes + 1] = {
			pass_type = "rect",
			style_id = "column_edge_" .. j
		}
		style["column_edge_" .. j] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				arg_1_3,
				size[2]
			},
			offset = {
				num_3 * j,
				0,
				0
			},
			color = flag
		}
	end

	return tbl_2
end

local tbl_4 = {
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
local tbl_5 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = tbl_3,
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
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
	word_wrap = false,
	upper_case = false,
	localize = true,
	font_size = 20,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = tbl_3,
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
local tbl_9 = {
	word_wrap = false,
	upper_case = true,
	localize = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = tbl_3,
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

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = tbl[arg_2_0]
	local clone = table.clone(var_2_0.size)
	local clone_2 = table.clone(tbl_9)

	clone_2.text_color = arg_2_2
	clone_2.size = clone

	local tbl_2 = {
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
	local passes = tbl_2.element.passes
	local content = tbl_2.content
	local style = tbl_2.style

	passes[#passes + 1] = {
		style_id = "title",
		pass_type = "text",
		text_id = "title"
	}
	passes[#passes + 1] = {
		style_id = "title_shadow",
		pass_type = "text",
		text_id = "title"
	}
	content.title = tostring(arg_2_1)
	style.title = clone_2
	style.title_shadow = table.clone(clone_2)
	style.title_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	style.title_shadow.offset = {
		2,
		-3,
		-1
	}
	style.underline = {
		vertical_alignment = "bottom",
		horizontal_alignment = "center",
		color = arg_2_2,
		texture_size = {
			clone[1],
			4
		}
	}
	content.gradient = {
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
	style.left_gradient = {
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
	style.right_gradient = {
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

	return tbl_2
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local size = tbl[arg_3_0].size
	local num = 12
	local tbl_2 = {
		size[1] / #arg_3_1,
		size[2]
	}
	local clone = table.clone(tbl_5)

	clone.font_size = arg_3_2 or clone.font_size

	local tbl_3

	if not arg_3_4 then
		tbl_3 = {
			255,
			177,
			144,
			31
		}

		if not tbl_3 then
			-- Nothing
		end
	end

	tbl_3 = clone.text_color

	::label_3_0::

	clone.text_color = tbl_3

	if not arg_3_7 then
		local get_color_table_with_alpha

		if arg_3_7 == "local_team" then
			get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

			if not get_color_table_with_alpha then
				-- Nothing
			end
		end

		get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

		::label_3_1::

		clone.text_color = get_color_table_with_alpha
	end

	local tbl_4 = {
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
	local passes = tbl_4.element.passes
	local content = tbl_4.content
	local style = tbl_4.style

	for i = 1, #arg_3_1 do
		local str = "stat_" .. i

		passes[#passes + 1] = {
			pass_type = "text",
			text_id = str,
			style_id = str
		}

		if not arg_3_5 then
			passes[#passes + 1] = {
				pass_type = "texture",
				texture_id = "highscore_marker",
				style_id = str .. "_highscore_marker",
				content_check_function = function (self, arg_4_1)
					-- function 4
					return self[str .. "_is_highscore"]
				end
			}
			passes[#passes + 1] = {
				pass_type = "texture",
				texture_id = "highscore_marker",
				style_id = str .. "_highscore_marker_shadow",
				content_check_function = function (self, arg_5_1)
					-- function 5
					return self[str .. "_is_highscore"]
				end
			}
		end

		passes[#passes + 1] = {
			pass_type = "text",
			text_id = str,
			style_id = str .. "_shadow"
		}

		local var_3_11 = arg_3_1[i]

		if type(var_3_11) == "number" then
			var_3_11 = math.round(var_3_11)
		end

		content[str] = tostring(var_3_11)
		content.highscore_marker = "scoreboard_marker"
		content.offset = arg_3_3
		content[str .. "_is_highscore"] = (arg_3_5 or arg_3_6 or arg_3_6[i] ~= var_3_11 or not (var_3_11 > 0)) and false
		style[str] = table.clone(clone)
		style[str].offset[1] = (i - 1) * tbl_2[1] + num
		style[str].size = {
			tbl_2[1] - num * 2,
			tbl_2[2]
		}
		style[str .. "_shadow"] = table.clone(clone)
		style[str .. "_shadow"].offset = {
			(i - 1) * tbl_2[1] + 2 + num,
			-3,
			-1
		}
		style[str .. "_shadow"].size = {
			tbl_2[1] - num * 2,
			tbl_2[2]
		}
		style[str .. "_shadow"].text_color = {
			255,
			0,
			0,
			0
		}
		style[str .. "_highscore_marker"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				71,
				39
			},
			offset = {
				(i - 1) * tbl_2[1],
				0,
				5
			},
			size = {
				tbl_2[1],
				tbl_2[2]
			}
		}
		style[str .. "_highscore_marker_shadow"] = {
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
				(i - 1) * tbl_2[1] + 1,
				-1,
				4
			},
			size = {
				tbl_2[1],
				tbl_2[2]
			}
		}
	end

	return tbl_4
end

local function fn_4(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local var_6_0 = tbl[arg_6_0]
	local clone = table.clone(var_6_0.size)

	clone[1] = 170

	local var_6_2 = tbl_3
	local clone_2 = table.clone(tbl_6)

	clone_2.font_size = arg_6_2 or clone_2.font_size

	local tbl_2

	if not arg_6_4 then
		tbl_2 = {
			255,
			177,
			144,
			31
		}

		if not tbl_2 then
			-- Nothing
		end
	end

	tbl_2 = var_6_2

	::label_6_0::

	clone_2.text_color = tbl_2
	clone_2.size = clone

	local tbl_4 = {
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
	local passes = tbl_4.element.passes
	local content = tbl_4.content
	local style = tbl_4.style

	passes[#passes + 1] = {
		style_id = "title",
		pass_type = "text",
		text_id = "title"
	}
	passes[#passes + 1] = {
		style_id = "title_shadow",
		pass_type = "text",
		text_id = "title"
	}
	content.title = tostring(arg_6_1)
	style.title = clone_2
	style.title_shadow = table.clone(clone_2)
	style.title_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	style.title_shadow.offset = {
		2,
		-3,
		-1
	}

	return tbl_4
end

local function fn_5(arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local flag = arg_7_0 == "local_team"
	local flag_2

	flag_2 = not flag and "local_title" and "opponent_title"

	local var_7_2 = tbl[flag_2]
	local clone = table.clone(var_7_2.size)
	local flag_3 = not flag and arg_7_1 and arg_7_2
	local var_7_5 = UISettings.teams_ui_assets[flag_3]

	if not (not flag and get_color_table_with_alpha) then
		local var_7_6 = get_color_table_with_alpha_4
	end

	if not (not flag and get_color_table_with_alpha_2) then
		local var_7_7 = get_color_table_with_alpha_5
	end

	if not (not flag and get_color_table_with_alpha_3) then
		local var_7_8 = get_color_table_with_alpha_6
	end

	local get_color_table_with_alpha_7

	if not flag then
		get_color_table_with_alpha_7 = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

		if not get_color_table_with_alpha_7 then
			-- Nothing
		end
	end

	get_color_table_with_alpha_7 = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

	::label_7_0::

	local clone_2 = table.clone(tbl_7)

	clone_2.size = clone
	clone_2.text_color = get_color_table_with_alpha_7

	local tbl_2 = {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		scenegraph_id = flag_2,
		offset = {
			0,
			0,
			0
		}
	}
	local passes = tbl_2.element.passes
	local content = tbl_2.content
	local style = tbl_2.style

	passes[#passes + 1] = {
		style_id = "title",
		pass_type = "text",
		text_id = "title"
	}
	passes[#passes + 1] = {
		style_id = "title_shadow",
		pass_type = "text",
		text_id = "title"
	}
	content.title = var_7_5.display_name
	style.title = clone_2
	style.title_shadow = table.clone(clone_2)
	style.title_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	style.title_shadow.offset[1] = style.title_shadow.offset[1] + 2
	style.title_shadow.offset[2] = style.title_shadow.offset[2] - 2
	style.title_shadow.offset[3] = style.title_shadow.offset[3] - 1
	passes[#passes + 1] = {
		style_id = "team_type",
		pass_type = "text",
		text_id = "team_type"
	}
	passes[#passes + 1] = {
		style_id = "team_type_shadow",
		pass_type = "text",
		text_id = "team_type"
	}

	local flag_4

	flag_4 = not flag and "vs_lobby_your_team" and "vs_lobby_enemy_team"
	content.team_type = flag_4

	local clone_3 = table.clone(tbl_8)

	clone_3.size = clone
	style.team_type = clone_3
	style.team_type_shadow = table.clone(clone_3)
	style.team_type_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	style.team_type_shadow.offset[1] = style.team_type_shadow.offset[1] + 2
	style.team_type_shadow.offset[2] = style.team_type_shadow.offset[2] - 2
	style.team_type_shadow.offset[3] = style.team_type_shadow.offset[3] - 1

	return tbl_2
end

local tbl_10 = {
	background = UIWidgets.create_simple_rect("screen", {
		128,
		0,
		0,
		0
	}),
	heroes_side_title = fn_2("local_heroes_header_grid", "vs_as_heroes", tbl_3),
	pactsworn_side_title = fn_2("local_pact_header_grid", "vs_as_pactsworn", tbl_3),
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

local function fn_6(arg_8_0)
	-- function 8
	local flag

	flag = arg_8_0 ~= "local_team" or not "local_winner_icon" or "opponent_winner_icon"

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
		scenegraph_id = flag
	}
end

local function fn_7(arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local str = "icons_placeholder"
	local str_2 = ""
	local str_3

	if arg_9_0 == "local_team" then
		str = UISettings.teams_ui_assets[arg_9_1].local_flag_texture or str
		str_3 = "local_flag"
	else
		str = UISettings.teams_ui_assets[arg_9_2].opponent_flag_texture or str
		str_3 = "opponent_flag"
	end

	return UIWidgets.create_simple_texture(str, str_3)
end

local function fn_8(arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local size = tbl[arg_10_0].size

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
					size[1],
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

local function fn_9(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local size = tbl[arg_11_0].size

	for i = 1, arg_11_1 do
		local tbl_2 = {
			0,
			(i - 1) * -size[2]
		}
		local flag = (i % 2 ~= 0 or not arg_11_4 or arg_11_5) and {
			128,
			0,
			0,
			0
		}

		arg_11_3[arg_11_2 .. "_" .. i] = UIWidgets.create_simple_rect(arg_11_0, flag, nil, tbl_2)
	end
end

local function fn_10(arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local tbl_2 = {}

	if arg_12_0 == "local_team" then
		fn_9("local_team_anchor", 1, "local_team", tbl_2)
		fn_9("local_heroes_score_title", 1, "local_team_heroes", tbl_2)
		fn_9("local_pactsworn_score_title", 1, "local_team_pactsworn", tbl_2)
		fn_9("local_names_anchor", arg_12_1, "local_names", tbl_2, get_table, get_table_2)
		fn_9("local_anchor", arg_12_1, "local_heroes", tbl_2, get_table, get_table_2)
		fn_9("local_pact_anchor", arg_12_1, "local_pact", tbl_2, get_table, get_table_2)

		arg_12_2.opponent_team_anchor.local_position[2] = tbl.local_team_anchor.position[2] - 5 * num - tbl.local_team_anchor.size[2]
	else
		fn_9("opponent_team_anchor", 1, "opponent_team", tbl_2)
		fn_9("opponent_heroes_score_title", 1, "opponent_team_heroes", tbl_2)
		fn_9("opponent_pactsworn_score_title", 1, "opponent_team_pactsworn", tbl_2)
		fn_9("opponent_names_anchor", arg_12_1, "opponent_names", tbl_2, get_table_3, get_table_4)
		fn_9("opponent_anchor", arg_12_1, "opponent_heroes", tbl_2, get_table_3, get_table_4)
		fn_9("opponent_pact_anchor", arg_12_1, "opponent_pact", tbl_2, get_table_3, get_table_4)
	end

	return tbl_2
end

local tbl_11 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				arg_13_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local easeOutCubic = math.easeOutCubic(arg_14_3)

				arg_14_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
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
				-- function 16
				arg_16_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local easeOutCubic = math.easeOutCubic(arg_17_3)

				arg_17_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end
		}
	}
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_10,
	animation_definitions = tbl_11,
	create_stats_func = fn_3,
	create_title_func = fn_4,
	create_team_grid_fields_func = fn_10,
	create_team_title_func = fn_5,
	create_flag_func = fn_7,
	create_winner_icon_func = fn_6
}
