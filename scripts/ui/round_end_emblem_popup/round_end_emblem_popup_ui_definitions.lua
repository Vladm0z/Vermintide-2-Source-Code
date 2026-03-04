-- chunkname: @scripts/ui/round_end_emblem_popup/round_end_emblem_popup_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = "emblem_gold_back"
local var_0_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_2).size
local var_0_4 = "emblem_gold_left_arm_inner"
local var_0_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_4).size
local var_0_6 = "emblem_gold_right_arm_inner"
local var_0_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_6).size
local var_0_8 = "emblem_gold_left_arm_outer"
local var_0_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_8).size
local var_0_10 = "emblem_gold_right_arm_outer"
local var_0_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_10).size
local var_0_12 = "emblem_gold_left_inner"
local var_0_13 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_12).size
local var_0_14 = "emblem_gold_right_inner"
local var_0_15 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_14).size
local var_0_16 = "emblem_gold_left_outer"
local var_0_17 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_16).size
local var_0_18 = "emblem_gold_right_outer"
local var_0_19 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_18).size
local var_0_20 = "emblem_gold_middle"
local var_0_21 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_20).size
local var_0_22 = "emblem_gold_top"
local var_0_23 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_22).size
local var_0_24 = "emblem_smoke_big"
local var_0_25 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_24).size
local var_0_26 = "emblem_smoke_middle"
local var_0_27 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_26).size
local var_0_28 = "emblem_smoke_side"
local var_0_29 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_0_28).size
local var_0_30 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.end_screen_banner
		},
		size = {
			var_0_0,
			var_0_1
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
		size = var_0_3
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
		size = var_0_25
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
		size = var_0_5
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
		size = var_0_7
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
		size = var_0_29
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
		size = var_0_29
	},
	arm_outer_left = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "right",
		position = {
			-(var_0_9[1] - 24),
			var_0_9[2] + 25,
			5
		},
		size = var_0_9
	},
	arm_outer_right = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "left",
		position = {
			var_0_11[1] - 24,
			var_0_11[2] + 25,
			5
		},
		size = var_0_11
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
		size = var_0_13
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
		size = var_0_15
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
		size = var_0_17
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
		size = var_0_19
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
		size = var_0_21
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
		size = var_0_27
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
		size = var_0_23
	}
}
local var_0_31 = {
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
local var_0_32 = {
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

local function var_0_33(arg_1_0)
	local var_1_0 = "emblem_" .. arg_1_0 .. "_back"
	local var_1_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_0).size
	local var_1_2 = "emblem_" .. arg_1_0 .. "_left_arm_inner"
	local var_1_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_2).size
	local var_1_4 = "emblem_" .. arg_1_0 .. "_right_arm_inner"
	local var_1_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_4).size
	local var_1_6 = "emblem_" .. arg_1_0 .. "_left_arm_outer"
	local var_1_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_6).size
	local var_1_8 = "emblem_" .. arg_1_0 .. "_right_arm_outer"
	local var_1_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_8).size
	local var_1_10 = "emblem_" .. arg_1_0 .. "_left_inner"
	local var_1_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_10).size
	local var_1_12 = "emblem_" .. arg_1_0 .. "_right_inner"
	local var_1_13 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_12).size
	local var_1_14 = "emblem_" .. arg_1_0 .. "_left_outer"
	local var_1_15 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_14).size
	local var_1_16 = "emblem_" .. arg_1_0 .. "_right_outer"
	local var_1_17 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_16).size
	local var_1_18 = "emblem_" .. arg_1_0 .. "_middle"
	local var_1_19 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_18).size
	local var_1_20 = "emblem_" .. arg_1_0 .. "_top"
	local var_1_21 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_20).size
	local var_1_22 = "emblem_smoke_big"
	local var_1_23 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_22).size
	local var_1_24 = "emblem_smoke_middle"
	local var_1_25 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_24).size
	local var_1_26 = "emblem_smoke_side"
	local var_1_27 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_26).size

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
			skull = var_1_18,
			medalion = var_1_20,
			background = var_1_0,
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
				texture_id = var_1_26
			},
			smoke_skull = var_1_24,
			smoke_background = var_1_22,
			outer_left = var_1_14,
			outer_right = var_1_16,
			inner_left = var_1_10,
			inner_right = var_1_12,
			arm_inner_left = var_1_2,
			arm_inner_right = var_1_4,
			arm_outer_left = var_1_6,
			arm_outer_right = var_1_8
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
					var_1_15[1],
					var_1_15[2]
				},
				texture_size = var_1_15,
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
					var_1_17[2]
				},
				texture_size = var_1_17,
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
					var_1_11[1],
					0
				},
				texture_size = var_1_11,
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
				texture_size = var_1_13,
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
					var_1_3[1],
					0
				},
				texture_size = var_1_3,
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
				texture_size = var_1_5,
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
				texture_size = var_1_7,
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
					var_1_9[1] - 123,
					31
				},
				texture_size = var_1_9,
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

local var_0_34 = {
	title_title = UIWidgets.create_simple_text("", "title_title", nil, nil, var_0_31),
	sub_title_text = UIWidgets.create_simple_text(Localize("interaction_weave_leaderboard"), "sub_title_text", nil, nil, var_0_32)
}

local function var_0_35(arg_2_0)
	local var_2_0 = 1.70158
	local var_2_1 = 0
	local var_2_2 = 1

	if arg_2_0 == 0 then
		return 0
	end

	if arg_2_0 == 1 then
		return 1
	end

	if var_2_1 == 0 then
		var_2_1 = 0.3
	end

	if var_2_2 < 1 then
		var_2_2 = 1
		var_2_0 = var_2_1 / 4
	else
		var_2_0 = var_2_1 / (2 * math.pi) * math.asin(1 / var_2_2)
	end

	return var_2_2 * math.pow(2, -40 * arg_2_0) * math.sin((arg_2_0 * 1 - var_2_0) * (2 * math.pi) / var_2_1) + 1
end

local var_0_36 = {
	present_entry = {
		{
			name = "init",
			start_progress = 0,
			end_progress = 0.1,
			init = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				local var_3_0 = arg_3_2.emblem.style
				local var_3_1 = 40
				local var_3_2 = -100
				local var_3_3 = 50
				local var_3_4 = var_3_0.arm_inner_left

				if var_3_4 then
					local var_3_5 = var_3_4.scenegraph_id
					local var_3_6 = arg_3_0[var_3_5].local_position
					local var_3_7 = arg_3_1[var_3_5].position

					var_3_6[1] = var_3_7[1]
					var_3_6[2] = var_3_7[2] + var_3_2
					var_3_4.angle = math.degrees_to_radians(var_3_3)
					var_3_4.color[1] = 0
				end

				local var_3_8 = var_3_0.arm_inner_right

				if var_3_8 then
					local var_3_9 = var_3_8.scenegraph_id
					local var_3_10 = arg_3_0[var_3_9].local_position
					local var_3_11 = arg_3_1[var_3_9].position

					var_3_10[1] = var_3_11[1]
					var_3_10[2] = var_3_11[2] + var_3_2
					var_3_8.angle = math.degrees_to_radians(-var_3_3)
					var_3_8.color[1] = 0
				end

				local var_3_12 = var_3_0.arm_outer_left

				if var_3_12 then
					local var_3_13 = var_3_12.scenegraph_id
					local var_3_14 = arg_3_0[var_3_13].local_position
					local var_3_15 = arg_3_1[var_3_13].position

					var_3_14[1] = var_3_15[1] + 130
					var_3_14[2] = var_3_15[2] + var_3_2 + 40
					var_3_12.angle = math.degrees_to_radians(-var_3_3)
					var_3_12.color[1] = 0
				end

				local var_3_16 = var_3_0.arm_outer_right

				if var_3_16 then
					local var_3_17 = var_3_16.scenegraph_id
					local var_3_18 = arg_3_0[var_3_17].local_position
					local var_3_19 = arg_3_1[var_3_17].position

					var_3_18[1] = var_3_19[1] - 130
					var_3_18[2] = var_3_19[2] + var_3_2 + 40
					var_3_16.angle = math.degrees_to_radians(var_3_3)
					var_3_16.color[1] = 0
				end

				local var_3_20 = var_3_0.inner_left

				if var_3_20 then
					local var_3_21 = var_3_20.scenegraph_id
					local var_3_22 = arg_3_0[var_3_21].local_position
					local var_3_23 = arg_3_1[var_3_21].position

					var_3_20.angle = math.degrees_to_radians(var_3_3 - 15)
					var_3_20.color[1] = 0
				end

				local var_3_24 = var_3_0.inner_right

				if var_3_24 then
					local var_3_25 = var_3_24.scenegraph_id
					local var_3_26 = arg_3_0[var_3_25].local_position
					local var_3_27 = arg_3_1[var_3_25].position

					var_3_24.angle = math.degrees_to_radians(-(var_3_3 - 15))
					var_3_24.color[1] = 0
				end

				local var_3_28 = var_3_0.outer_left

				if var_3_28 then
					local var_3_29 = var_3_28.scenegraph_id
					local var_3_30 = arg_3_0[var_3_29].local_position
					local var_3_31 = arg_3_1[var_3_29].position

					var_3_28.angle = math.degrees_to_radians(-(var_3_3 - 15))
					var_3_28.color[1] = 0
				end

				local var_3_32 = var_3_0.outer_right

				if var_3_32 then
					local var_3_33 = var_3_32.scenegraph_id
					local var_3_34 = arg_3_0[var_3_33].local_position
					local var_3_35 = arg_3_1[var_3_33].position

					var_3_32.angle = math.degrees_to_radians(var_3_3 - 15)
					var_3_32.color[1] = 0
				end

				local var_3_36 = var_3_0.medalion

				if var_3_36 then
					var_3_36.color[1] = 0
				end

				local var_3_37 = var_3_0.skull

				if var_3_37 then
					var_3_37.color[1] = 0
				end

				local var_3_38 = var_3_0.background

				if var_3_38 then
					var_3_38.color[1] = 0
				end

				local var_3_39 = var_3_0.smoke_background

				if var_3_39 then
					var_3_39.color[1] = 0
				end

				local var_3_40 = var_3_0.smoke_skull

				if var_3_40 then
					var_3_40.color[1] = 0
				end

				local var_3_41 = var_3_0.smoke_wing_left

				if var_3_41 then
					var_3_41.color[1] = 0
				end

				local var_3_42 = var_3_0.smoke_wing_right

				if var_3_42 then
					var_3_42.color[1] = 0
				end
			end,
			update = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				return
			end,
			on_complete = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				return
			end
		},
		{
			name = "init_title_text",
			start_progress = 0,
			end_progress = 0.1,
			init = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				local var_6_0 = arg_6_2.title_title
				local var_6_1 = arg_6_2.sub_title_text

				var_6_0.alpha_multiplier = 0
				var_6_1.alpha_multiplier = 0
			end,
			update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				return
			end,
			on_complete = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end
		},
		{
			name = "overall_alpha_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				arg_9_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				local var_10_0 = math.easeOutCubic(arg_10_3)

				arg_10_4.render_settings.alpha_multiplier = var_10_0
				arg_10_4.render_settings.blur_progress = var_10_0
			end,
			on_complete = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				WwiseWorld.trigger_event(arg_11_3.wwise_world, "versus_round_end_coin_bird_finnish")
			end
		},
		{
			name = "background_entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end,
			update = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				local var_13_0 = math.easeInCubic(arg_13_3)
				local var_13_1 = math.easeOutCubic(1 - var_13_0)
				local var_13_2 = math.easeInCubic(var_13_0)
				local var_13_3 = arg_13_2.emblem.style
				local var_13_4 = 0.5
				local var_13_5 = 255 * var_13_2
				local var_13_6 = var_13_3.background

				if var_13_6 then
					local var_13_7 = var_13_6.scenegraph_id
					local var_13_8 = arg_13_0[var_13_7].size
					local var_13_9 = arg_13_1[var_13_7].size

					var_13_8[1] = var_13_9[1] + var_13_9[1] * var_13_4 * var_13_1
					var_13_8[2] = var_13_9[2] + var_13_9[2] * var_13_4 * var_13_1
					var_13_6.color[1] = var_13_5
				end

				local var_13_10 = var_13_3.skull

				if var_13_10 then
					local var_13_11 = var_13_10.scenegraph_id
					local var_13_12 = arg_13_0[var_13_11].size
					local var_13_13 = arg_13_1[var_13_11].size

					var_13_12[1] = var_13_13[1] + var_13_13[1] * var_13_4 * var_13_1
					var_13_12[2] = var_13_13[2] + var_13_13[2] * var_13_4 * var_13_1
					var_13_10.color[1] = var_13_5
				end
			end,
			on_complete = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end
		},
		{
			name = "background_smoke",
			start_progress = 0.5,
			end_progress = 1,
			init = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end,
			update = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				local var_16_0 = 1 - math.easeOutCubic(arg_16_3)
				local var_16_1 = arg_16_2.emblem.style
				local var_16_2 = 1
				local var_16_3 = 255 * var_16_0
				local var_16_4 = var_16_1.smoke_background

				if var_16_4 then
					local var_16_5 = var_16_4.scenegraph_id
					local var_16_6 = arg_16_0[var_16_5].size
					local var_16_7 = arg_16_1[var_16_5].size

					var_16_6[1] = var_16_7[1] + var_16_7[1] * var_16_2 * arg_16_3
					var_16_6[2] = var_16_7[2] + var_16_7[2] * var_16_2 * arg_16_3
					var_16_4.color[1] = var_16_3
				end
			end,
			on_complete = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end
		},
		{
			name = "skull_bounce",
			start_progress = 0.45,
			end_progress = 0.75,
			init = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end,
			update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = math.ease_pulse(math.easeCubic(arg_19_3))
				local var_19_1 = arg_19_2.emblem.style
				local var_19_2 = 0.03
				local var_19_3 = var_19_1.skull

				if var_19_3 then
					local var_19_4 = var_19_3.scenegraph_id
					local var_19_5 = arg_19_0[var_19_4].size
					local var_19_6 = arg_19_1[var_19_4].size

					var_19_5[1] = var_19_6[1] + var_19_6[1] * var_19_2 * var_19_0
					var_19_5[2] = var_19_6[2] + var_19_6[1] * var_19_2 * var_19_0
				end
			end,
			on_complete = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		},
		{
			name = "fade_in_arms",
			start_progress = 0.8,
			end_progress = 0.9,
			init = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end,
			update = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				local var_22_0 = math.easeInCubic(arg_22_3)
				local var_22_1 = arg_22_2.emblem.style
				local var_22_2 = 255 * var_22_0
				local var_22_3 = var_22_1.arm_inner_left

				if var_22_3 then
					var_22_3.color[1] = var_22_2
				end

				local var_22_4 = var_22_1.arm_inner_right

				if var_22_4 then
					var_22_4.color[1] = var_22_2
				end

				local var_22_5 = var_22_1.arm_outer_left

				if var_22_5 then
					var_22_5.color[1] = var_22_2
				end

				local var_22_6 = var_22_1.arm_outer_right

				if var_22_6 then
					var_22_6.color[1] = var_22_2
				end
			end,
			on_complete = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end
		},
		{
			name = "move_up",
			start_progress = 0.8,
			end_progress = 1.2,
			init = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				return
			end,
			update = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				local var_25_0 = 1 - math.easeCubic(arg_25_3)
				local var_25_1 = arg_25_2.emblem.style
				local var_25_2 = 40
				local var_25_3 = -100
				local var_25_4 = 50
				local var_25_5 = var_25_1.arm_inner_left

				if var_25_5 then
					local var_25_6 = var_25_5.scenegraph_id
					local var_25_7 = arg_25_0[var_25_6].local_position
					local var_25_8 = arg_25_1[var_25_6].position

					var_25_7[1] = var_25_8[1]
					var_25_7[2] = var_25_8[2] + var_25_3 * var_25_0
				end

				local var_25_9 = var_25_1.arm_inner_right

				if var_25_9 then
					local var_25_10 = var_25_9.scenegraph_id
					local var_25_11 = arg_25_0[var_25_10].local_position
					local var_25_12 = arg_25_1[var_25_10].position

					var_25_11[1] = var_25_12[1]
					var_25_11[2] = var_25_12[2] + var_25_3 * var_25_0
				end

				local var_25_13 = var_25_1.arm_outer_left

				if var_25_13 then
					local var_25_14 = var_25_13.scenegraph_id

					arg_25_0[var_25_14].local_position[2] = arg_25_1[var_25_14].position[2] + var_25_3 * var_25_0 + 40
				end

				local var_25_15 = var_25_1.arm_outer_right

				if var_25_15 then
					local var_25_16 = var_25_15.scenegraph_id

					arg_25_0[var_25_16].local_position[2] = arg_25_1[var_25_16].position[2] + var_25_3 * var_25_0 + 40
				end
			end,
			on_complete = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end
		},
		{
			name = "fade_in_wings",
			start_progress = 1.15,
			end_progress = 1.25,
			init = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end,
			update = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				local var_28_0 = math.easeInCubic(arg_28_3)
				local var_28_1 = arg_28_2.emblem.style
				local var_28_2 = 255 * var_28_0
				local var_28_3 = var_28_1.inner_left

				if var_28_3 then
					var_28_3.color[1] = var_28_2
				end

				local var_28_4 = var_28_1.inner_right

				if var_28_4 then
					var_28_4.color[1] = var_28_2
				end

				local var_28_5 = var_28_1.outer_left

				if var_28_5 then
					var_28_5.color[1] = var_28_2
				end

				local var_28_6 = var_28_1.outer_right

				if var_28_6 then
					var_28_6.color[1] = var_28_2
				end
			end,
			on_complete = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				return
			end
		},
		{
			name = "fade_in_medalion",
			start_progress = 1,
			end_progress = 1.1,
			init = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end,
			update = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				local var_31_0 = math.ease_out_exp(arg_31_3)
				local var_31_1 = arg_31_2.emblem.style
				local var_31_2 = 255 * var_31_0
				local var_31_3 = var_31_1.medalion

				if var_31_3 then
					var_31_3.color[1] = var_31_2
				end
			end,
			on_complete = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				return
			end
		},
		{
			name = "move_medalion",
			start_progress = 1,
			end_progress = 1.3,
			init = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				return
			end,
			update = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				local var_34_0 = 1 - math.ease_out_exp(arg_34_3)
				local var_34_1 = arg_34_2.emblem.style
				local var_34_2 = 200 * var_34_0
				local var_34_3 = var_34_1.medalion

				if var_34_3 then
					local var_34_4 = var_34_3.scenegraph_id

					arg_34_0[var_34_4].local_position[2] = arg_34_1[var_34_4].position[2] + var_34_2
				end
			end,
			on_complete = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end
		},
		{
			name = "skull_bounce_down",
			start_progress = 1.15,
			end_progress = 1.55,
			init = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				return
			end,
			update = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
				local var_37_0 = math.ease_pulse(math.easeOutCubic(arg_37_3))
				local var_37_1 = arg_37_2.emblem.style
				local var_37_2 = 0.03
				local var_37_3 = var_37_1.skull

				if var_37_3 then
					local var_37_4 = var_37_3.scenegraph_id

					arg_37_0[var_37_4].local_position[2] = arg_37_1[var_37_4].position[2] - 5 * var_37_0
				end
			end,
			on_complete = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end
		},
		{
			name = "smoke_skull",
			start_progress = 1.15,
			end_progress = 2.15,
			init = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				return
			end,
			update = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
				local var_40_0 = 1 - math.easeOutCubic(arg_40_3)
				local var_40_1 = math.easeOutCubic(arg_40_3)
				local var_40_2 = arg_40_2.emblem.style
				local var_40_3 = 0.6
				local var_40_4 = 255 * var_40_0
				local var_40_5 = var_40_2.smoke_skull

				if var_40_5 then
					local var_40_6 = var_40_5.scenegraph_id
					local var_40_7 = arg_40_0[var_40_6].size
					local var_40_8 = arg_40_1[var_40_6].size

					var_40_7[2] = var_40_8[2] / 2 + var_40_8[2] * var_40_3 * var_40_1
					var_40_5.color[1] = var_40_4
				end
			end,
			on_complete = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				return
			end
		},
		{
			name = "smoke_wings",
			start_progress = 1.3,
			end_progress = 2.6,
			init = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				return
			end,
			update = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
				local var_43_0 = 1 - math.easeOutCubic(arg_43_3)
				local var_43_1 = math.easeOutCubic(arg_43_3)
				local var_43_2 = arg_43_2.emblem.style
				local var_43_3 = 0.6
				local var_43_4 = 255 * var_43_0
				local var_43_5 = var_43_2.smoke_wing_left

				if var_43_5 then
					local var_43_6 = var_43_5.scenegraph_id
					local var_43_7 = arg_43_0[var_43_6].size
					local var_43_8 = arg_43_1[var_43_6].size

					var_43_7[2] = var_43_8[2] + var_43_8[2] * var_43_3 * var_43_1
					var_43_5.color[1] = var_43_4
				end

				local var_43_9 = var_43_2.smoke_wing_right

				if var_43_9 then
					local var_43_10 = var_43_9.scenegraph_id
					local var_43_11 = arg_43_0[var_43_10].size
					local var_43_12 = arg_43_1[var_43_10].size

					var_43_11[2] = var_43_12[2] + var_43_12[2] * var_43_3 * var_43_1
					var_43_9.color[1] = var_43_4
				end
			end,
			on_complete = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				return
			end
		},
		{
			name = "fold_out",
			start_progress = 1.1,
			end_progress = 3.1,
			init = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				return
			end,
			update = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
				local var_46_0 = var_0_35(arg_46_3)
				local var_46_1 = 1 - math.easeInCubic(var_46_0)
				local var_46_2 = arg_46_2.emblem.style
				local var_46_3 = 40
				local var_46_4 = 0
				local var_46_5 = 50
				local var_46_6 = var_46_2.arm_inner_left

				if var_46_6 then
					local var_46_7 = var_46_6.scenegraph_id

					arg_46_0[var_46_7].local_position[1] = arg_46_1[var_46_7].position[1]
					var_46_6.angle = math.degrees_to_radians(var_46_5 * var_46_1)
				end

				local var_46_8 = var_46_2.arm_inner_right

				if var_46_8 then
					local var_46_9 = var_46_8.scenegraph_id

					arg_46_0[var_46_9].local_position[1] = arg_46_1[var_46_9].position[1]
					var_46_8.angle = math.degrees_to_radians(-var_46_5 * var_46_1)
				end

				local var_46_10 = var_46_2.arm_outer_left

				if var_46_10 then
					local var_46_11 = var_46_10.scenegraph_id
					local var_46_12 = arg_46_0[var_46_11].local_position
					local var_46_13 = arg_46_1[var_46_11].position

					var_46_12[1] = var_46_13[1] + 130 * var_46_1
					var_46_12[2] = var_46_13[2] + var_46_4 + 40 * var_46_1
					var_46_10.angle = math.degrees_to_radians(-var_46_5 * var_46_1)
				end

				local var_46_14 = var_46_2.arm_outer_right

				if var_46_14 then
					local var_46_15 = var_46_14.scenegraph_id
					local var_46_16 = arg_46_0[var_46_15].local_position
					local var_46_17 = arg_46_1[var_46_15].position

					var_46_16[1] = var_46_17[1] - 130 * var_46_1
					var_46_16[2] = var_46_17[2] + var_46_4 + 40 * var_46_1
					var_46_14.angle = math.degrees_to_radians(var_46_5 * var_46_1)
				end

				local var_46_18 = var_46_2.inner_left

				if var_46_18 then
					local var_46_19 = var_46_18.scenegraph_id
					local var_46_20 = arg_46_0[var_46_19].local_position
					local var_46_21 = arg_46_1[var_46_19].position

					var_46_18.angle = math.degrees_to_radians((var_46_5 - 15) * var_46_1)
				end

				local var_46_22 = var_46_2.inner_right

				if var_46_22 then
					local var_46_23 = var_46_22.scenegraph_id
					local var_46_24 = arg_46_0[var_46_23].local_position
					local var_46_25 = arg_46_1[var_46_23].position

					var_46_22.angle = math.degrees_to_radians(-(var_46_5 - 15) * var_46_1)
				end

				local var_46_26 = var_46_2.outer_left

				if var_46_26 then
					local var_46_27 = var_46_26.scenegraph_id
					local var_46_28 = arg_46_0[var_46_27].local_position
					local var_46_29 = arg_46_1[var_46_27].position

					var_46_26.angle = math.degrees_to_radians(-(var_46_5 - 15) * var_46_1)
				end

				local var_46_30 = var_46_2.outer_right

				if var_46_30 then
					local var_46_31 = var_46_30.scenegraph_id
					local var_46_32 = arg_46_0[var_46_31].local_position
					local var_46_33 = arg_46_1[var_46_31].position

					var_46_30.angle = math.degrees_to_radians((var_46_5 - 15) * var_46_1)
				end
			end,
			on_complete = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				return
			end
		},
		{
			name = "fade_in_title_text",
			start_progress = 1.1,
			end_progress = 1.6,
			init = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				return
			end,
			update = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
				local var_49_0 = math.easeOutCubic(arg_49_3)
				local var_49_1 = arg_49_2.title_title
				local var_49_2 = arg_49_2.sub_title_text

				var_49_1.alpha_multiplier = var_49_0
				var_49_2.alpha_multiplier = var_49_0

				local var_49_3 = 20

				var_49_1.offset[2] = var_49_3 - var_49_3 * var_49_0
				var_49_2.offset[2] = -var_49_3 + var_49_3 * var_49_0
			end,
			on_complete = function(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				return
			end
		},
		{
			name = "overall_alpha_out",
			start_progress = 7.1,
			end_progress = 7.6,
			init = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				return
			end,
			update = function(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
				local var_52_0 = 1 - math.easeOutCubic(arg_52_3)

				arg_52_4.render_settings.alpha_multiplier = var_52_0
				arg_52_4.render_settings.blur_progress = var_52_0
			end,
			on_complete = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
				return
			end
		},
		{
			name = "fade_out_title_text",
			start_progress = 6.1,
			end_progress = 6.6,
			init = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				return
			end,
			update = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
				local var_55_0 = 1 - math.easeOutCubic(arg_55_3)
				local var_55_1 = arg_55_2.title_title
				local var_55_2 = arg_55_2.sub_title_text

				var_55_1.alpha_multiplier = var_55_0
				var_55_2.alpha_multiplier = var_55_0
			end,
			on_complete = function(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				return
			end
		}
	}
}

return {
	animations = var_0_36,
	create_emblem_widget = var_0_33,
	scenegraph_definition = var_0_30,
	widget_definitions = var_0_34
}
