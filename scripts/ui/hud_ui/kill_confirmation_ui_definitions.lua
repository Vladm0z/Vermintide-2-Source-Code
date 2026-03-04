-- chunkname: @scripts/ui/hud_ui/kill_confirmation_ui_definitions.lua

local var_0_0 = {
	1920,
	1080
}
local var_0_1 = {
	96,
	96
}
local var_0_2 = {
	0,
	-100,
	0
}
local var_0_3 = 24
local var_0_4 = {
	var_0_0[1] / 2,
	var_0_3 + 20
}
local var_0_5 = {
	0,
	50,
	0
}
local var_0_6 = {
	0.703125 * var_0_1[1],
	0.703125 * var_0_1[2]
}
local var_0_7 = {
	0,
	0.1015625 * var_0_1[1],
	0
}
local var_0_8 = {
	root = {
		is_root = true,
		size = var_0_0,
		position = {
			0,
			0,
			UILayer.hud
		}
	},
	screen = {
		size = var_0_0,
		position = {
			0,
			0,
			UILayer.hud
		},
		scale = IS_WINDOWS and "fit" or "hud_fit"
	},
	pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			var_0_1[1]
		},
		position = {
			0,
			-86,
			UILayer.hud
		}
	},
	badge_placement = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		size = var_0_1,
		position = var_0_2
	},
	text_background_placement = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			var_0_5[1] + var_0_2[1],
			var_0_2[2] - var_0_5[2],
			0
		}
	},
	text_placement = {
		vertical_alignment = "center",
		parent = "text_background_placement",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			0,
			0,
			1
		}
	}
}
local var_0_9 = {
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
				texture_id = "text_bg_texture_id",
				style_id = "text_bg_texture_id",
				pass_type = "texture"
			}
		}
	},
	content = {
		frame = "badge_frame_pactsworn",
		text_name = "placeholder_text_name",
		text_bg_texture_id = "bg_center_fade",
		frame_impact = "badge_frame_pactsworn_impact",
		frame_glow = "badge_frame_pactsworn_glow",
		icon = "versus_badge_icon",
		frame_smoke = "badge_frame_pactsworn_smoke",
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
			texture_size = var_0_6,
			offset = var_0_7,
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
			texture_size = var_0_6,
			offset = var_0_7,
			color = {
				255,
				255,
				0,
				255
			}
		},
		text_name = {
			vertical_alignment = "center",
			scenegraph_id = "text_placement",
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			font_size = var_0_3,
			text_color = Colors.get_color_table_with_alpha("white", 255)
		},
		text_bg_texture_id = {
			visible = false,
			scenegraph_id = "text_background_placement"
		}
	}
}
local var_0_10 = {
	on_enter = {
		{
			name = "fade_in_scale_down",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
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
				arg_1_2.style.icon.texture_size = {
					var_0_6[1] - 40,
					var_0_6[2] - 40
				}
				arg_1_2.style.icon_glow.texture_size = {
					var_0_6[1] - 40,
					var_0_6[2] - 40
				}
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0

				local var_2_1 = arg_2_1.badge_placement.size[1] * 1.3
				local var_2_2 = arg_2_1.badge_placement.size[2] * 1.3
				local var_2_3 = var_0_6

				arg_2_4.ui_scenegraph.badge_placement.size = {
					var_2_1 * var_2_0,
					var_2_2 * var_2_0
				}
				arg_2_2.style.icon.texture_size = {
					var_0_6[1] - 40 + 60 * var_2_0,
					var_0_6[2] - 40 + 60 * var_2_0
				}
				arg_2_2.style.icon_glow.texture_size = {
					var_0_6[1] - 40 + 60 * var_2_0,
					var_0_6[2] - 40 + 60 * var_2_0
				}
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				arg_3_3.start_size = {
					arg_3_3.ui_scenegraph.badge_placement.size[1],
					arg_3_3.ui_scenegraph.badge_placement.size[2]
				}
				arg_3_2.style.icon.texture_size = var_0_6
				arg_3_2.style.icon_glow.texture_size = var_0_6
			end
		},
		{
			name = "scale_down",
			start_progress = 0.5,
			end_progress = 0.62,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.ui_scenegraph.text_background_placement.size = {
					0,
					0
				}
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = arg_5_4.start_size[1]
				local var_5_1 = arg_5_4.start_size[2]
				local var_5_2 = arg_5_1.badge_placement.size[1]
				local var_5_3 = arg_5_1.badge_placement.size[2]
				local var_5_4 = var_5_0 - var_5_2
				local var_5_5 = var_5_1 - var_5_3

				arg_5_4.ui_scenegraph.badge_placement.size = {
					var_5_0 - var_5_4 * arg_5_3,
					var_5_1 - var_5_5 * arg_5_3
				}
				arg_5_4.ui_scenegraph.text_background_placement.size = {
					arg_5_1.text_background_placement.size[1] * arg_5_3,
					arg_5_1.text_background_placement.size[2]
				}

				local var_5_6 = 255 * arg_5_3

				arg_5_2.style.text_name.text_color = {
					var_5_6,
					var_5_6,
					var_5_6,
					var_5_6
				}
				arg_5_2.style.icon.texture_size = {
					var_0_6[1] + 20 - 20 * arg_5_3,
					var_0_6[2] + 20 - 20 * arg_5_3
				}
				arg_5_2.style.icon_glow.texture_size = {
					var_0_6[1] + 20 - 20 * arg_5_3,
					var_0_6[2] + 20 - 20 * arg_5_3
				}
			end,
			on_complete = NOP
		},
		{
			name = "fade_out_everything",
			start_progress = 1.4,
			end_progress = 1.8,
			init = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				arg_6_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				arg_7_4.render_settings.alpha_multiplier = 1 - arg_7_3
			end,
			on_complete = NOP
		}
	}
}

return {
	scenegraph_definition = var_0_8,
	badge_widget_definition = var_0_9,
	animation_definitions = var_0_10
}
