-- chunkname: @scripts/ui/round_end_emblem_popup/round_end_emblem_popup_ui_definitions.lua

local num = 1920
local num_2 = 1080
local str = "emblem_gold_back"
local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str).size
local str_2 = "emblem_gold_left_arm_inner"
local size_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2).size
local str_3 = "emblem_gold_right_arm_inner"
local size_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size
local str_4 = "emblem_gold_left_arm_outer"
local size_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_4).size
local str_5 = "emblem_gold_right_arm_outer"
local size_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_5).size
local str_6 = "emblem_gold_left_inner"
local size_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_6).size
local str_7 = "emblem_gold_right_inner"
local size_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_7).size
local str_8 = "emblem_gold_left_outer"
local size_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_8).size
local str_9 = "emblem_gold_right_outer"
local size_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_9).size
local str_10 = "emblem_gold_middle"
local size_10 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_10).size
local str_11 = "emblem_gold_top"
local size_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_11).size
local str_12 = "emblem_smoke_big"
local size_12 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_12).size
local str_13 = "emblem_smoke_middle"
local size_13 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_13).size
local str_14 = "emblem_smoke_side"
local size_14 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_14).size
local tbl = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.end_screen_banner
		},
		size = {
			num,
			num_2
		}
	},
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			30,
			1
		},
		size = {
			0,
			0
		}
	},
	title_title = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			-210,
			1
		},
		size = {
			1200,
			50
		}
	},
	sub_title_text = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			-255,
			1
		},
		size = {
			1200,
			50
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = size
	},
	smoke_background = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = size_12
	},
	arm_inner_left = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "right",
		position = {
			-46,
			-7,
			4
		},
		size = size_2
	},
	arm_inner_right = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "left",
		position = {
			46,
			-7,
			4
		},
		size = size_3
	},
	smoke_wing_left = {
		vertical_alignment = "top",
		parent = "arm_inner_left",
		horizontal_alignment = "right",
		position = {
			-10,
			0,
			-1
		},
		size = size_14
	},
	smoke_wing_right = {
		vertical_alignment = "top",
		parent = "arm_inner_right",
		horizontal_alignment = "left",
		position = {
			10,
			0,
			-1
		},
		size = size_14
	},
	arm_outer_left = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "right",
		position = {
			-(size_4[1] - 24),
			size_4[2] + 25,
			5
		},
		size = size_4
	},
	arm_outer_right = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "left",
		position = {
			size_5[1] - 24,
			size_5[2] + 25,
			5
		},
		size = size_5
	},
	inner_left = {
		vertical_alignment = "top",
		parent = "arm_inner_left",
		horizontal_alignment = "right",
		position = {
			-23,
			-26,
			-3
		},
		size = size_6
	},
	inner_right = {
		vertical_alignment = "top",
		parent = "arm_inner_right",
		horizontal_alignment = "left",
		position = {
			23,
			-26,
			-3
		},
		size = size_7
	},
	outer_left = {
		vertical_alignment = "top",
		parent = "arm_outer_left",
		horizontal_alignment = "right",
		position = {
			-2,
			-28,
			-3
		},
		size = size_8
	},
	outer_right = {
		vertical_alignment = "top",
		parent = "arm_outer_right",
		horizontal_alignment = "left",
		position = {
			2,
			-28,
			-3
		},
		size = size_9
	},
	skull = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			12,
			8
		},
		size = size_10
	},
	smoke_skull = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			7
		},
		size = size_13
	},
	medalion = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			86,
			9
		},
		size = size_11
	}
}
local tbl_2 = {
	word_wrap = true,
	font_size = 52,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_3 = {
	font_size = 24,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}

local function fn(arg_1_0)
	-- function 1
	local str = "emblem_" .. arg_1_0 .. "_back"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str).size
	local str_2 = "emblem_" .. arg_1_0 .. "_left_arm_inner"
	local size_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2).size
	local str_3 = "emblem_" .. arg_1_0 .. "_right_arm_inner"
	local size_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size
	local str_4 = "emblem_" .. arg_1_0 .. "_left_arm_outer"
	local size_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_4).size
	local str_5 = "emblem_" .. arg_1_0 .. "_right_arm_outer"
	local size_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_5).size
	local str_6 = "emblem_" .. arg_1_0 .. "_left_inner"
	local size_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_6).size
	local str_7 = "emblem_" .. arg_1_0 .. "_right_inner"
	local size_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_7).size
	local str_8 = "emblem_" .. arg_1_0 .. "_left_outer"
	local size_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_8).size
	local str_9 = "emblem_" .. arg_1_0 .. "_right_outer"
	local size_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_9).size
	local str_10 = "emblem_" .. arg_1_0 .. "_middle"
	local size_10 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_10).size
	local str_11 = "emblem_" .. arg_1_0 .. "_top"
	local size_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_11).size
	local str_12 = "emblem_smoke_big"
	local size_12 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_12).size
	local str_13 = "emblem_smoke_middle"
	local size_13 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_13).size
	local str_14 = "emblem_smoke_side"
	local size_14 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_14).size

	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "arm_inner_left",
					style_id = "arm_inner_left",
					pass_type = "rotated_texture"
				},
				{
					texture_id = "arm_inner_right",
					style_id = "arm_inner_right",
					pass_type = "rotated_texture"
				},
				{
					texture_id = "arm_outer_left",
					style_id = "arm_outer_left",
					pass_type = "rotated_texture"
				},
				{
					texture_id = "arm_outer_right",
					style_id = "arm_outer_right",
					pass_type = "rotated_texture"
				},
				{
					texture_id = "inner_left",
					style_id = "inner_left",
					pass_type = "rotated_texture"
				},
				{
					texture_id = "inner_right",
					style_id = "inner_right",
					pass_type = "rotated_texture"
				},
				{
					texture_id = "outer_left",
					style_id = "outer_left",
					pass_type = "rotated_texture"
				},
				{
					texture_id = "outer_right",
					style_id = "outer_right",
					pass_type = "rotated_texture"
				},
				{
					texture_id = "skull",
					style_id = "skull",
					pass_type = "texture"
				},
				{
					texture_id = "medalion",
					style_id = "medalion",
					pass_type = "texture"
				},
				{
					texture_id = "smoke_background",
					style_id = "smoke_background",
					pass_type = "texture"
				},
				{
					texture_id = "smoke_skull",
					style_id = "smoke_skull",
					pass_type = "texture"
				},
				{
					texture_id = "texture_id",
					style_id = "smoke_wing_left",
					pass_type = "texture_uv",
					content_id = "smoke_wing"
				},
				{
					texture_id = "texture_id",
					style_id = "smoke_wing_right",
					pass_type = "texture",
					content_id = "smoke_wing"
				}
			}
		},
		content = {
			skull = str_10,
			medalion = str_11,
			background = str,
			smoke_wing = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = str_14
			},
			smoke_skull = str_13,
			smoke_background = str_12,
			outer_left = str_8,
			outer_right = str_9,
			inner_left = str_6,
			inner_right = str_7,
			arm_inner_left = str_2,
			arm_inner_right = str_3,
			arm_outer_left = str_4,
			arm_outer_right = str_5
		},
		style = {
			smoke_background = {
				scenegraph_id = "smoke_background",
				offset = {
					0,
					0,
					0
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			smoke_skull = {
				scenegraph_id = "smoke_skull",
				offset = {
					0,
					0,
					0
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			smoke_wing_left = {
				scenegraph_id = "smoke_wing_left",
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			smoke_wing_right = {
				scenegraph_id = "smoke_wing_right",
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			skull = {
				scenegraph_id = "skull",
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			medalion = {
				scenegraph_id = "medalion",
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			background = {
				scenegraph_id = "background",
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			outer_left = {
				vertical_alignment = "top",
				scenegraph_id = "outer_left",
				horizontal_alignment = "right",
				angle = 0,
				offset = {
					0,
					0,
					1
				},
				pivot = {
					size_8[1],
					size_8[2]
				},
				texture_size = size_8,
				color = {
					255,
					255,
					255,
					255
				}
			},
			outer_right = {
				vertical_alignment = "top",
				scenegraph_id = "outer_right",
				horizontal_alignment = "left",
				angle = 0,
				offset = {
					0,
					0,
					1
				},
				pivot = {
					0,
					size_9[2]
				},
				texture_size = size_9,
				color = {
					255,
					255,
					255,
					255
				}
			},
			inner_left = {
				vertical_alignment = "bottom",
				scenegraph_id = "inner_left",
				horizontal_alignment = "right",
				angle = 0,
				offset = {
					0,
					0,
					1
				},
				pivot = {
					size_6[1],
					0
				},
				texture_size = size_6,
				color = {
					255,
					255,
					255,
					255
				}
			},
			inner_right = {
				vertical_alignment = "bottom",
				scenegraph_id = "inner_right",
				horizontal_alignment = "left",
				angle = 0,
				offset = {
					0,
					0,
					1
				},
				pivot = {
					0,
					0
				},
				texture_size = size_7,
				color = {
					255,
					255,
					255,
					255
				}
			},
			arm_inner_left = {
				vertical_alignment = "bottom",
				scenegraph_id = "arm_inner_left",
				horizontal_alignment = "right",
				angle = 0,
				offset = {
					0,
					0,
					1
				},
				pivot = {
					size_2[1],
					0
				},
				texture_size = size_2,
				color = {
					255,
					255,
					255,
					255
				}
			},
			arm_inner_right = {
				vertical_alignment = "bottom",
				scenegraph_id = "arm_inner_right",
				horizontal_alignment = "left",
				angle = 0,
				offset = {
					0,
					0,
					1
				},
				pivot = {
					0,
					0
				},
				texture_size = size_3,
				color = {
					255,
					255,
					255,
					255
				}
			},
			arm_outer_left = {
				vertical_alignment = "bottom",
				scenegraph_id = "arm_outer_left",
				horizontal_alignment = "right",
				angle = 0,
				offset = {
					0,
					0,
					1
				},
				pivot = {
					123,
					31
				},
				texture_size = size_4,
				color = {
					255,
					255,
					255,
					255
				}
			},
			arm_outer_right = {
				vertical_alignment = "bottom",
				scenegraph_id = "arm_outer_right",
				horizontal_alignment = "left",
				angle = 0,
				offset = {
					0,
					0,
					1
				},
				pivot = {
					size_5[1] - 123,
					31
				},
				texture_size = size_5,
				color = {
					255,
					255,
					255,
					255
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

local tbl_4 = {
	title_title = UIWidgets.create_simple_text("", "title_title", nil, nil, tbl_2),
	sub_title_text = UIWidgets.create_simple_text(Localize("interaction_weave_leaderboard"), "sub_title_text", nil, nil, tbl_3)
}

local function fn_2(arg_2_0)
	-- function 2
	local num = 1.70158
	local num_2 = 0
	local num_3 = 1

	if arg_2_0 == 0 then
		return 0
	end

	if arg_2_0 == 1 then
		return 1
	end

	if num_2 == 0 then
		num_2 = 0.3
	end

	if num_3 < 1 then
		num_3 = 1
		num = num_2 / 4
	else
		num = num_2 / (2 * math.pi) * math.asin(1 / num_3)
	end

	return num_3 * math.pow(2, -40 * arg_2_0) * math.sin((arg_2_0 * 1 - num) * (2 * math.pi) / num_2) + 1
end

local tbl_5 = {
	present_entry = {
		{
			name = "init",
			start_progress = 0,
			end_progress = 0.1,
			init = function (self, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				local style = arg_3_2.emblem.style
				local num = 40
				local num_2 = -100
				local num_3 = 50
				local arm_inner_left = style.arm_inner_left

				if not arm_inner_left then
					local scenegraph_id = arm_inner_left.scenegraph_id
					local local_position = self[scenegraph_id].local_position
					local position = arg_3_1[scenegraph_id].position

					local_position[1] = position[1]
					local_position[2] = position[2] + num_2
					arm_inner_left.angle = math.degrees_to_radians(num_3)
					arm_inner_left.color[1] = 0
				end

				local arm_inner_right = style.arm_inner_right

				if not arm_inner_right then
					local scenegraph_id_2 = arm_inner_right.scenegraph_id
					local local_position_2 = self[scenegraph_id_2].local_position
					local position_2 = arg_3_1[scenegraph_id_2].position

					local_position_2[1] = position_2[1]
					local_position_2[2] = position_2[2] + num_2
					arm_inner_right.angle = math.degrees_to_radians(-num_3)
					arm_inner_right.color[1] = 0
				end

				local arm_outer_left = style.arm_outer_left

				if not arm_outer_left then
					local scenegraph_id_3 = arm_outer_left.scenegraph_id
					local local_position_3 = self[scenegraph_id_3].local_position
					local position_3 = arg_3_1[scenegraph_id_3].position

					local_position_3[1] = position_3[1] + 130
					local_position_3[2] = position_3[2] + num_2 + 40
					arm_outer_left.angle = math.degrees_to_radians(-num_3)
					arm_outer_left.color[1] = 0
				end

				local arm_outer_right = style.arm_outer_right

				if not arm_outer_right then
					local scenegraph_id_4 = arm_outer_right.scenegraph_id
					local local_position_4 = self[scenegraph_id_4].local_position
					local position_4 = arg_3_1[scenegraph_id_4].position

					local_position_4[1] = position_4[1] - 130
					local_position_4[2] = position_4[2] + num_2 + 40
					arm_outer_right.angle = math.degrees_to_radians(num_3)
					arm_outer_right.color[1] = 0
				end

				local inner_left = style.inner_left

				if not inner_left then
					local scenegraph_id_5 = inner_left.scenegraph_id
					local local_position_5 = self[scenegraph_id_5].local_position
					local position_5 = arg_3_1[scenegraph_id_5].position

					inner_left.angle = math.degrees_to_radians(num_3 - 15)
					inner_left.color[1] = 0
				end

				local inner_right = style.inner_right

				if not inner_right then
					local scenegraph_id_6 = inner_right.scenegraph_id
					local local_position_6 = self[scenegraph_id_6].local_position
					local position_6 = arg_3_1[scenegraph_id_6].position

					inner_right.angle = math.degrees_to_radians(-(num_3 - 15))
					inner_right.color[1] = 0
				end

				local outer_left = style.outer_left

				if not outer_left then
					local scenegraph_id_7 = outer_left.scenegraph_id
					local local_position_7 = self[scenegraph_id_7].local_position
					local position_7 = arg_3_1[scenegraph_id_7].position

					outer_left.angle = math.degrees_to_radians(-(num_3 - 15))
					outer_left.color[1] = 0
				end

				local outer_right = style.outer_right

				if not outer_right then
					local scenegraph_id_8 = outer_right.scenegraph_id
					local local_position_8 = self[scenegraph_id_8].local_position
					local position_8 = arg_3_1[scenegraph_id_8].position

					outer_right.angle = math.degrees_to_radians(num_3 - 15)
					outer_right.color[1] = 0
				end

				local medalion = style.medalion

				if not medalion then
					medalion.color[1] = 0
				end

				local skull = style.skull

				if not skull then
					skull.color[1] = 0
				end

				local background = style.background

				if not background then
					background.color[1] = 0
				end

				local smoke_background = style.smoke_background

				if not smoke_background then
					smoke_background.color[1] = 0
				end

				local smoke_skull = style.smoke_skull

				if not smoke_skull then
					smoke_skull.color[1] = 0
				end

				local smoke_wing_left = style.smoke_wing_left

				if not smoke_wing_left then
					smoke_wing_left.color[1] = 0
				end

				local smoke_wing_right = style.smoke_wing_right

				if not smoke_wing_right then
					smoke_wing_right.color[1] = 0
				end
			end,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				-- function 4
				return
			end,
			on_complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				return
			end
		},
		{
			name = "init_title_text",
			start_progress = 0,
			end_progress = 0.1,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				local title_title = arg_6_2.title_title
				local sub_title_text = arg_6_2.sub_title_text

				title_title.alpha_multiplier = 0
				sub_title_text.alpha_multiplier = 0
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				return
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end
		},
		{
			name = "overall_alpha_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				arg_9_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				-- function 10
				local easeOutCubic = math.easeOutCubic(arg_10_3)

				arg_10_4.render_settings.alpha_multiplier = easeOutCubic
				arg_10_4.render_settings.blur_progress = easeOutCubic
			end,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				WwiseWorld.trigger_event(arg_11_3.wwise_world, "versus_round_end_coin_bird_finnish")
			end
		},
		{
			name = "background_entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end,
			update = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				-- function 13
				local easeInCubic = math.easeInCubic(arg_13_3)
				local easeOutCubic = math.easeOutCubic(1 - easeInCubic)
				local easeInCubic_2 = math.easeInCubic(easeInCubic)
				local style = arg_13_2.emblem.style
				local num = 0.5
				local num_2 = 255 * easeInCubic_2
				local background = style.background

				if not background then
					local scenegraph_id = background.scenegraph_id
					local size = self[scenegraph_id].size
					local size_2 = arg_13_1[scenegraph_id].size

					size[1] = size_2[1] + size_2[1] * num * easeOutCubic
					size[2] = size_2[2] + size_2[2] * num * easeOutCubic
					background.color[1] = num_2
				end

				local skull = style.skull

				if not skull then
					local scenegraph_id_2 = skull.scenegraph_id
					local size_3 = self[scenegraph_id_2].size
					local size_4 = arg_13_1[scenegraph_id_2].size

					size_3[1] = size_4[1] + size_4[1] * num * easeOutCubic
					size_3[2] = size_4[2] + size_4[2] * num * easeOutCubic
					skull.color[1] = num_2
				end
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end
		},
		{
			name = "background_smoke",
			start_progress = 0.5,
			end_progress = 1,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end,
			update = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				-- function 16
				local num = 1 - math.easeOutCubic(arg_16_3)
				local style = arg_16_2.emblem.style
				local num_2 = 1
				local num_3 = 255 * num
				local smoke_background = style.smoke_background

				if not smoke_background then
					local scenegraph_id = smoke_background.scenegraph_id
					local size = self[scenegraph_id].size
					local size_2 = arg_16_1[scenegraph_id].size

					size[1] = size_2[1] + size_2[1] * num_2 * arg_16_3
					size[2] = size_2[2] + size_2[2] * num_2 * arg_16_3
					smoke_background.color[1] = num_3
				end
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				return
			end
		},
		{
			name = "skull_bounce",
			start_progress = 0.45,
			end_progress = 0.75,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end,
			update = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				-- function 19
				local ease_pulse = math.ease_pulse(math.easeCubic(arg_19_3))
				local style = arg_19_2.emblem.style
				local num = 0.03
				local skull = style.skull

				if not skull then
					local scenegraph_id = skull.scenegraph_id
					local size = self[scenegraph_id].size
					local size_2 = arg_19_1[scenegraph_id].size

					size[1] = size_2[1] + size_2[1] * num * ease_pulse
					size[2] = size_2[2] + size_2[1] * num * ease_pulse
				end
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end
		},
		{
			name = "fade_in_arms",
			start_progress = 0.8,
			end_progress = 0.9,
			init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end,
			update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				-- function 22
				local easeInCubic = math.easeInCubic(arg_22_3)
				local style = arg_22_2.emblem.style
				local num = 255 * easeInCubic
				local arm_inner_left = style.arm_inner_left

				if not arm_inner_left then
					arm_inner_left.color[1] = num
				end

				local arm_inner_right = style.arm_inner_right

				if not arm_inner_right then
					arm_inner_right.color[1] = num
				end

				local arm_outer_left = style.arm_outer_left

				if not arm_outer_left then
					arm_outer_left.color[1] = num
				end

				local arm_outer_right = style.arm_outer_right

				if not arm_outer_right then
					arm_outer_right.color[1] = num
				end
			end,
			on_complete = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				return
			end
		},
		{
			name = "move_up",
			start_progress = 0.8,
			end_progress = 1.2,
			init = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				return
			end,
			update = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				-- function 25
				local num = 1 - math.easeCubic(arg_25_3)
				local style = arg_25_2.emblem.style
				local num_2 = 40
				local num_3 = -100
				local num_4 = 50
				local arm_inner_left = style.arm_inner_left

				if not arm_inner_left then
					local scenegraph_id = arm_inner_left.scenegraph_id
					local local_position = self[scenegraph_id].local_position
					local position = arg_25_1[scenegraph_id].position

					local_position[1] = position[1]
					local_position[2] = position[2] + num_3 * num
				end

				local arm_inner_right = style.arm_inner_right

				if not arm_inner_right then
					local scenegraph_id_2 = arm_inner_right.scenegraph_id
					local local_position_2 = self[scenegraph_id_2].local_position
					local position_2 = arg_25_1[scenegraph_id_2].position

					local_position_2[1] = position_2[1]
					local_position_2[2] = position_2[2] + num_3 * num
				end

				local arm_outer_left = style.arm_outer_left

				if not arm_outer_left then
					local scenegraph_id_3 = arm_outer_left.scenegraph_id

					self[scenegraph_id_3].local_position[2] = arg_25_1[scenegraph_id_3].position[2] + num_3 * num + 40
				end

				local arm_outer_right = style.arm_outer_right

				if not arm_outer_right then
					local scenegraph_id_4 = arm_outer_right.scenegraph_id

					self[scenegraph_id_4].local_position[2] = arg_25_1[scenegraph_id_4].position[2] + num_3 * num + 40
				end
			end,
			on_complete = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				return
			end
		},
		{
			name = "fade_in_wings",
			start_progress = 1.15,
			end_progress = 1.25,
			init = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end,
			update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				-- function 28
				local easeInCubic = math.easeInCubic(arg_28_3)
				local style = arg_28_2.emblem.style
				local num = 255 * easeInCubic
				local inner_left = style.inner_left

				if not inner_left then
					inner_left.color[1] = num
				end

				local inner_right = style.inner_right

				if not inner_right then
					inner_right.color[1] = num
				end

				local outer_left = style.outer_left

				if not outer_left then
					outer_left.color[1] = num
				end

				local outer_right = style.outer_right

				if not outer_right then
					outer_right.color[1] = num
				end
			end,
			on_complete = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				return
			end
		},
		{
			name = "fade_in_medalion",
			start_progress = 1,
			end_progress = 1.1,
			init = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end,
			update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				-- function 31
				local ease_out_exp = math.ease_out_exp(arg_31_3)
				local style = arg_31_2.emblem.style
				local num = 255 * ease_out_exp
				local medalion = style.medalion

				if not medalion then
					medalion.color[1] = num
				end
			end,
			on_complete = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				return
			end
		},
		{
			name = "move_medalion",
			start_progress = 1,
			end_progress = 1.3,
			init = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				return
			end,
			update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				-- function 34
				local num = 1 - math.ease_out_exp(arg_34_3)
				local style = arg_34_2.emblem.style
				local num_2 = 200 * num
				local medalion = style.medalion

				if not medalion then
					local scenegraph_id = medalion.scenegraph_id

					arg_34_0[scenegraph_id].local_position[2] = arg_34_1[scenegraph_id].position[2] + num_2
				end
			end,
			on_complete = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				return
			end
		},
		{
			name = "skull_bounce_down",
			start_progress = 1.15,
			end_progress = 1.55,
			init = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				return
			end,
			update = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
				-- function 37
				local ease_pulse = math.ease_pulse(math.easeOutCubic(arg_37_3))
				local style = arg_37_2.emblem.style
				local num = 0.03
				local skull = style.skull

				if not skull then
					local scenegraph_id = skull.scenegraph_id

					arg_37_0[scenegraph_id].local_position[2] = arg_37_1[scenegraph_id].position[2] - 5 * ease_pulse
				end
			end,
			on_complete = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
				return
			end
		},
		{
			name = "smoke_skull",
			start_progress = 1.15,
			end_progress = 2.15,
			init = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				-- function 39
				return
			end,
			update = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
				-- function 40
				local num = 1 - math.easeOutCubic(arg_40_3)
				local easeOutCubic = math.easeOutCubic(arg_40_3)
				local style = arg_40_2.emblem.style
				local num_2 = 0.6
				local num_3 = 255 * num
				local smoke_skull = style.smoke_skull

				if not smoke_skull then
					local scenegraph_id = smoke_skull.scenegraph_id
					local size = self[scenegraph_id].size
					local size_2 = arg_40_1[scenegraph_id].size

					size[2] = size_2[2] / 2 + size_2[2] * num_2 * easeOutCubic
					smoke_skull.color[1] = num_3
				end
			end,
			on_complete = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				-- function 41
				return
			end
		},
		{
			name = "smoke_wings",
			start_progress = 1.3,
			end_progress = 2.6,
			init = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
				return
			end,
			update = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
				-- function 43
				local num = 1 - math.easeOutCubic(arg_43_3)
				local easeOutCubic = math.easeOutCubic(arg_43_3)
				local style = arg_43_2.emblem.style
				local num_2 = 0.6
				local num_3 = 255 * num
				local smoke_wing_left = style.smoke_wing_left

				if not smoke_wing_left then
					local scenegraph_id = smoke_wing_left.scenegraph_id
					local size = self[scenegraph_id].size
					local size_2 = arg_43_1[scenegraph_id].size

					size[2] = size_2[2] + size_2[2] * num_2 * easeOutCubic
					smoke_wing_left.color[1] = num_3
				end

				local smoke_wing_right = style.smoke_wing_right

				if not smoke_wing_right then
					local scenegraph_id_2 = smoke_wing_right.scenegraph_id
					local size_3 = self[scenegraph_id_2].size
					local size_4 = arg_43_1[scenegraph_id_2].size

					size_3[2] = size_4[2] + size_4[2] * num_2 * easeOutCubic
					smoke_wing_right.color[1] = num_3
				end
			end,
			on_complete = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				-- function 44
				return
			end
		},
		{
			name = "fold_out",
			start_progress = 1.1,
			end_progress = 3.1,
			init = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				return
			end,
			update = function (self, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
				-- function 46
				local var_46_0 = fn_2(arg_46_3)
				local num = 1 - math.easeInCubic(var_46_0)
				local style = arg_46_2.emblem.style
				local num_2 = 40
				local num_3 = 0
				local num_4 = 50
				local arm_inner_left = style.arm_inner_left

				if not arm_inner_left then
					local scenegraph_id = arm_inner_left.scenegraph_id

					self[scenegraph_id].local_position[1] = arg_46_1[scenegraph_id].position[1]
					arm_inner_left.angle = math.degrees_to_radians(num_4 * num)
				end

				local arm_inner_right = style.arm_inner_right

				if not arm_inner_right then
					local scenegraph_id_2 = arm_inner_right.scenegraph_id

					self[scenegraph_id_2].local_position[1] = arg_46_1[scenegraph_id_2].position[1]
					arm_inner_right.angle = math.degrees_to_radians(-num_4 * num)
				end

				local arm_outer_left = style.arm_outer_left

				if not arm_outer_left then
					local scenegraph_id_3 = arm_outer_left.scenegraph_id
					local local_position = self[scenegraph_id_3].local_position
					local position = arg_46_1[scenegraph_id_3].position

					local_position[1] = position[1] + 130 * num
					local_position[2] = position[2] + num_3 + 40 * num
					arm_outer_left.angle = math.degrees_to_radians(-num_4 * num)
				end

				local arm_outer_right = style.arm_outer_right

				if not arm_outer_right then
					local scenegraph_id_4 = arm_outer_right.scenegraph_id
					local local_position_2 = self[scenegraph_id_4].local_position
					local position_2 = arg_46_1[scenegraph_id_4].position

					local_position_2[1] = position_2[1] - 130 * num
					local_position_2[2] = position_2[2] + num_3 + 40 * num
					arm_outer_right.angle = math.degrees_to_radians(num_4 * num)
				end

				local inner_left = style.inner_left

				if not inner_left then
					local scenegraph_id_5 = inner_left.scenegraph_id
					local local_position_3 = self[scenegraph_id_5].local_position
					local position_3 = arg_46_1[scenegraph_id_5].position

					inner_left.angle = math.degrees_to_radians((num_4 - 15) * num)
				end

				local inner_right = style.inner_right

				if not inner_right then
					local scenegraph_id_6 = inner_right.scenegraph_id
					local local_position_4 = self[scenegraph_id_6].local_position
					local position_4 = arg_46_1[scenegraph_id_6].position

					inner_right.angle = math.degrees_to_radians(-(num_4 - 15) * num)
				end

				local outer_left = style.outer_left

				if not outer_left then
					local scenegraph_id_7 = outer_left.scenegraph_id
					local local_position_5 = self[scenegraph_id_7].local_position
					local position_5 = arg_46_1[scenegraph_id_7].position

					outer_left.angle = math.degrees_to_radians(-(num_4 - 15) * num)
				end

				local outer_right = style.outer_right

				if not outer_right then
					local scenegraph_id_8 = outer_right.scenegraph_id
					local local_position_6 = self[scenegraph_id_8].local_position
					local position_6 = arg_46_1[scenegraph_id_8].position

					outer_right.angle = math.degrees_to_radians((num_4 - 15) * num)
				end
			end,
			on_complete = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				-- function 47
				return
			end
		},
		{
			name = "fade_in_title_text",
			start_progress = 1.1,
			end_progress = 1.6,
			init = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				-- function 48
				return
			end,
			update = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
				-- function 49
				local easeOutCubic = math.easeOutCubic(arg_49_3)
				local title_title = arg_49_2.title_title
				local sub_title_text = arg_49_2.sub_title_text

				title_title.alpha_multiplier = easeOutCubic
				sub_title_text.alpha_multiplier = easeOutCubic

				local num = 20

				title_title.offset[2] = num - num * easeOutCubic
				sub_title_text.offset[2] = -num + num * easeOutCubic
			end,
			on_complete = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				-- function 50
				return
			end
		},
		{
			name = "overall_alpha_out",
			start_progress = 7.1,
			end_progress = 7.6,
			init = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				-- function 51
				return
			end,
			update = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
				-- function 52
				local num = 1 - math.easeOutCubic(arg_52_3)

				arg_52_4.render_settings.alpha_multiplier = num
				arg_52_4.render_settings.blur_progress = num
			end,
			on_complete = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
				-- function 53
				return
			end
		},
		{
			name = "fade_out_title_text",
			start_progress = 6.1,
			end_progress = 6.6,
			init = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				-- function 54
				return
			end,
			update = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
				-- function 55
				local num = 1 - math.easeOutCubic(arg_55_3)
				local title_title = arg_55_2.title_title
				local sub_title_text = arg_55_2.sub_title_text

				title_title.alpha_multiplier = num
				sub_title_text.alpha_multiplier = num
			end,
			on_complete = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				-- function 56
				return
			end
		}
	}
}

return {
	animations = tbl_5,
	create_emblem_widget = fn,
	scenegraph_definition = tbl,
	widget_definitions = tbl_4
}
