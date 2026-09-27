-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_background_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_4 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_4 * 2 + 60)
local tbl = {
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
local tbl_2 = {
	loading_overlay = UIWidgets.create_simple_rect("loading_overlay", {
		255,
		12,
		12,
		12
	}),
	loading_overlay_loading_glow = UIWidgets.create_simple_texture("loading_title_divider", "loading_detail", nil, nil, nil, 2),
	loading_overlay_loading_frame = UIWidgets.create_simple_texture("loading_title_divider_background", "loading_detail", nil, nil, nil, 1)
}

local function fn(arg_1_0)
	-- function 1
	return {
		element = {
			passes = {
				{
					style_id = "rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 2
						local fade_start = self.fade_start

						return fade_start <= self.progress or self.progress <= 1 - fade_start
					end,
					content_change_function = function (self, arg_3_1)
						-- function 3
						local fade_start = self.fade_start

						if fade_start < self.progress then
							local num = (self.progress - fade_start) / (1 - fade_start)

							arg_3_1.color[1] = num * 255
						else
							local num_2 = 1 - self.progress / (1 - fade_start)

							arg_3_1.color[1] = num_2 * 255
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

local tbl_3 = {
	background_fade = fn("screen")
}
local create_simple_texture = UIWidgets.create_simple_texture("gradient_dice_game_reward", "screen", nil, nil, {
	80,
	255,
	255,
	255
})
local tbl_4 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeOutCubic = math.easeOutCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		}
	}
}

return {
	viewport_widgets = tbl_3,
	background_rect = create_simple_texture,
	scenegraph_definition = tbl,
	animation_definitions = tbl_4,
	loading_overlay_widgets = tbl_2
}
