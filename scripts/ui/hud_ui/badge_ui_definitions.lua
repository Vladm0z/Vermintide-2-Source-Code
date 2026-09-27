-- chunkname: @scripts/ui/hud_ui/badge_ui_definitions.lua

local tbl = {
	1920,
	1080
}
local tbl_2 = {
	128,
	128
}
local tbl_3 = {
	0,
	-150,
	0
}
local num = 28
local tbl_4 = {
	tbl[1] / 2,
	num + 20
}
local tbl_5 = {
	0,
	100,
	0
}
local tbl_6 = {
	0.703125 * tbl_2[1],
	0.703125 * tbl_2[2]
}
local tbl_7 = {
	0,
	0.1015625 * tbl_2[1],
	0
}
local tbl_8 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = tbl
	}
}
local tbl_9 = {}
local flag

flag = not IS_WINDOWS and "fit" and "hud_fit"
tbl_9.scale = flag
tbl_9.position = {
	0,
	0,
	UILayer.hud
}
tbl_9.size = tbl
tbl_8.screen = tbl_9
tbl_8.pivot = {
	vertical_alignment = "top",
	parent = "screen",
	horizontal_alignment = "left",
	size = {
		tbl[1],
		tbl_2[1]
	},
	position = {
		0,
		-130,
		UILayer.hud
	}
}
tbl_8.badge_placement = {
	vertical_alignment = "center",
	parent = "pivot",
	horizontal_alignment = "center",
	size = tbl_2,
	position = tbl_3
}
tbl_8.text_background_placement = {
	vertical_alignment = "center",
	parent = "pivot",
	horizontal_alignment = "center",
	size = tbl_4,
	position = {
		tbl_5[1] + tbl_3[1],
		tbl_3[2] + tbl_5[2],
		0
	}
}
tbl_8.text_placement = {
	vertical_alignment = "center",
	parent = "text_background_placement",
	horizontal_alignment = "center",
	size = tbl_4,
	position = {
		0,
		0,
		1
	}
}

local tbl_10 = {
	scenegraph_id = "badge_placement",
	element = {
		passes = {
			{
				texture_id = "frame_smoke",
				style_id = "frame_smoke",
				pass_type = "texture"
			},
			{
				texture_id = "frame_impact",
				style_id = "frame_impact",
				pass_type = "texture"
			},
			{
				texture_id = "frame",
				style_id = "frame",
				pass_type = "texture"
			},
			{
				texture_id = "frame_glow",
				style_id = "frame_glow",
				pass_type = "texture"
			},
			{
				texture_id = "icon_glow",
				style_id = "icon_glow",
				pass_type = "texture"
			},
			{
				texture_id = "icon",
				style_id = "icon",
				pass_type = "texture"
			},
			{
				style_id = "text_name",
				pass_type = "text",
				text_id = "text_name"
			},
			{
				style_id = "text_desc",
				pass_type = "text",
				text_id = "text_desc"
			},
			{
				texture_id = "text_bg_texture_id",
				style_id = "text_bg_texture_id",
				pass_type = "texture"
			}
		}
	},
	content = {
		text_desc = "placeholder_text_desc",
		frame = "badge_frame_pactsworn",
		text_bg_texture_id = "bg_center_fade",
		text_name = "placeholder_text_name",
		frame_smoke = "badge_frame_pactsworn_smoke",
		frame_impact = "badge_frame_pactsworn_impact",
		frame_glow = "badge_frame_pactsworn_glow",
		icon = "versus_badge_icon",
		icon_glow = "versus_badge_glow"
	},
	style = {
		frame_smoke = {
			color = {
				255,
				0,
				0,
				0
			}
		},
		frame_impact = {
			color = {
				255,
				127,
				127,
				127
			}
		},
		frame_glow = {
			color = {
				255,
				255,
				0,
				255
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl_6,
			offset = tbl_7,
			color = {
				255,
				255,
				255,
				255
			}
		},
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl_6,
			offset = tbl_7,
			color = {
				255,
				255,
				0,
				255
			}
		},
		text = {
			vertical_alignment = "center",
			scenegraph_id = "text_placement",
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			font_size = num,
			text_color = Colors.get_color_table_with_alpha("white", 255)
		},
		text_name = {
			vertical_alignment = "center",
			scenegraph_id = "text_placement",
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			font_size = num,
			text_color = Colors.get_color_table_with_alpha("white", 255)
		},
		text_desc = {
			vertical_alignment = "center",
			scenegraph_id = "text_placement",
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			font_size = num,
			text_color = Colors.get_color_table_with_alpha("white", 255)
		},
		text_bg_texture_id = {
			visible = false,
			scenegraph_id = "text_background_placement"
		}
	}
}
local tbl_11 = {
	on_enter = {
		{
			name = "fade_in_scale_down",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 0

				WwiseWorld.trigger_event(arg_1_3.wwise_world, "play_gui_mission_summary_chest_upgrade")

				arg_1_3.ui_scenegraph.badge_placement.size = {
					0,
					0
				}
				arg_1_2.style.text_name.text_color = {
					0,
					0,
					0,
					0
				}
				arg_1_2.style.text_desc.text_color = {
					0,
					0,
					0,
					0
				}
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = easeOutCubic

				local num = arg_2_1.badge_placement.size[1] * 1.5
				local num_2 = arg_2_1.badge_placement.size[2] * 1.5

				arg_2_4.ui_scenegraph.badge_placement.size = {
					num * easeOutCubic,
					num_2 * easeOutCubic
				}
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				arg_3_3.start_size = {
					arg_3_3.ui_scenegraph.badge_placement.size[1],
					arg_3_3.ui_scenegraph.badge_placement.size[2]
				}
			end
		},
		{
			name = "scale_down",
			start_progress = 0.5,
			end_progress = 0.6,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.ui_scenegraph.text_background_placement.size = {
					0,
					0
				}
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local var_5_0 = arg_5_4.start_size[1]
				local var_5_1 = arg_5_4.start_size[2]
				local var_5_2 = arg_5_1.badge_placement.size[1]
				local var_5_3 = arg_5_1.badge_placement.size[2]
				local num = var_5_0 - var_5_2
				local num_2 = var_5_1 - var_5_3

				arg_5_4.ui_scenegraph.badge_placement.size = {
					var_5_0 - num * arg_5_3,
					var_5_1 - num_2 * arg_5_3
				}
				arg_5_4.ui_scenegraph.text_background_placement.size = {
					arg_5_1.text_background_placement.size[1] * arg_5_3,
					arg_5_1.text_background_placement.size[2]
				}

				local num_3 = 255 * arg_5_3

				arg_5_2.style.text_name.text_color = {
					num_3,
					num_3,
					num_3,
					num_3
				}
			end,
			on_complete = NOP
		},
		{
			name = "fade_out_name",
			start_progress = 3.6,
			end_progress = 3.7,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				local num = 255 * (1 - arg_7_3)

				arg_7_2.style.text_name.text_color = {
					num,
					num,
					num,
					num
				}
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_description",
			start_progress = 3.7,
			end_progress = 3.8,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				local num = 255 * arg_9_3

				arg_9_2.style.text_desc.text_color = {
					num,
					num,
					num,
					num
				}
			end,
			on_complete = NOP
		},
		{
			name = "fade_out_everything",
			start_progress = 4.8,
			end_progress = 5.3,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				arg_10_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				arg_11_4.render_settings.alpha_multiplier = 1 - arg_11_3
			end,
			on_complete = NOP
		}
	}
}

return {
	scenegraph_definition = tbl_8,
	badge_widget_definition = tbl_10,
	animation_definitions = tbl_11
}
