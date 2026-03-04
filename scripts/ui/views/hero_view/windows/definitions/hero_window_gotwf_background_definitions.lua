-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_background_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_6 = var_0_3[1] - (var_0_4 * 2 + 60)
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
	viewport = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			800,
			500
		},
		position = {
			0,
			-115,
			1
		}
	},
	loading_overlay = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default + 100
		}
	},
	loading_detail = {
		vertical_alignment = "center",
		parent = "loading_overlay",
		horizontal_alignment = "center",
		size = {
			314,
			33
		},
		position = {
			0,
			0,
			1
		}
	}
}
local var_0_8 = {
	loading_overlay = UIWidgets.create_simple_rect("loading_overlay", {
		255,
		12,
		12,
		12
	}),
	loading_overlay_loading_glow = UIWidgets.create_simple_texture("loading_title_divider", "loading_detail", nil, nil, nil, 2),
	loading_overlay_loading_frame = UIWidgets.create_simple_texture("loading_title_divider_background", "loading_detail", nil, nil, nil, 1)
}

local function var_0_9(arg_1_0)
	return {
		element = {
			passes = {
				{
					style_id = "rect",
					pass_type = "rect",
					content_check_function = function(arg_2_0)
						local var_2_0 = arg_2_0.fade_start

						return var_2_0 <= arg_2_0.progress or arg_2_0.progress <= 1 - var_2_0
					end,
					content_change_function = function(arg_3_0, arg_3_1)
						local var_3_0 = arg_3_0.fade_start

						if var_3_0 < arg_3_0.progress then
							local var_3_1 = (arg_3_0.progress - var_3_0) / (1 - var_3_0)

							arg_3_1.color[1] = var_3_1 * 255
						else
							local var_3_2 = 1 - arg_3_0.progress / (1 - var_3_0)

							arg_3_1.color[1] = var_3_2 * 255
						end
					end
				}
			}
		},
		content = {
			fade_start = 0.99,
			progress = 0
		},
		style = {
			rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					-1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_10 = {
	background_fade = var_0_9("screen")
}
local var_0_11 = UIWidgets.create_simple_texture("gradient_dice_game_reward", "screen", nil, nil, {
	80,
	255,
	255,
	255
})
local var_0_12 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = var_5_0
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeOutCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = 1 - var_8_0
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		}
	}
}

return {
	viewport_widgets = var_0_10,
	background_rect = var_0_11,
	scenegraph_definition = var_0_7,
	animation_definitions = var_0_12,
	loading_overlay_widgets = var_0_8
}
