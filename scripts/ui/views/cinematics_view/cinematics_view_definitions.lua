-- chunkname: @scripts/ui/views/cinematics_view/cinematics_view_definitions.lua

local var_0_0 = {
	1200,
	350
}
local var_0_1 = {
	1200,
	250
}
local var_0_2 = {
	1920,
	1080
}
local var_0_3 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.options_menu
		},
		size = var_0_2
	},
	screen = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = var_0_2
	},
	fullscreen_video = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center"
	},
	fade_area_bg = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		scale = "fit_height",
		position = {
			0,
			0,
			UILayer.options_menu
		},
		size = {
			1320,
			1080
		}
	},
	fade_area_edge = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		scale = "fit_height",
		position = {
			-1320,
			0,
			UILayer.options_menu
		},
		size = {
			600,
			1080
		}
	},
	fade_area_edge_hotspot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			-0,
			0,
			0
		},
		size = {
			600,
			1080
		}
	},
	screen_anchor = {
		parent = "screen"
	},
	canvas_hotspot = {
		vertical_alignment = "top",
		parent = "screen_anchor",
		horizontal_alignment = "left",
		position = {
			600,
			0,
			10
		},
		size = {
			1320,
			1080
		}
	},
	canvas = {
		vertical_alignment = "top",
		parent = "screen_anchor",
		horizontal_alignment = "left",
		position = {
			600,
			-180,
			10
		},
		size = {
			var_0_0[1],
			700
		}
	},
	video_area = {
		parent = "canvas",
		position = {
			-10,
			-50,
			0
		},
		size = {
			var_0_0[1] + 20,
			700
		}
	},
	video_area_top = {
		vertical_alignment = "top",
		parent = "video_area",
		position = {
			0,
			50,
			0
		},
		size = {
			var_0_0[1] + 20,
			50
		}
	},
	video_area_bottom = {
		vertical_alignment = "bottom",
		parent = "video_area",
		position = {
			0,
			-50,
			0
		},
		size = {
			var_0_0[1] + 20,
			50
		}
	},
	scrollbar = {
		vertical_alignment = "center",
		parent = "video_area",
		horizontal_alignment = "right",
		position = {
			50,
			0,
			0
		},
		size = {
			13,
			700
		}
	},
	anchor_start = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		position = {
			0,
			-91,
			0
		},
		size = var_0_1
	},
	anchor_point = {
		parent = "anchor_start"
	},
	back_button = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			40,
			-50,
			3
		}
	}
}
local var_0_4 = {
	word_wrap = false,
	upper_case = true,
	localize = true,
	font_size = 56,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		60,
		1
	}
}
local var_0_5 = {
	word_wrap = false,
	upper_case = true,
	localize = true,
	font_size = 56,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = {
		255,
		0,
		0,
		0
	},
	offset = {
		2,
		58,
		0
	}
}

local function var_0_6()
	return {
		scenegraph_id = "video_area",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "texture",
					texture_id = "mask"
				}
			}
		},
		content = {
			mask = "mask_rect",
			hotspot = {}
		},
		style = {}
	}
end

local function var_0_7(arg_2_0)
	local var_2_0 = var_0_3.video_area.size[2]
	local var_2_1 = arg_2_0 * var_0_0[2]
	local var_2_2

	var_2_2 = var_2_1 <= var_2_0

	local var_2_3 = var_2_0 / var_2_1

	return {
		scenegraph_id = "scrollbar",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content_change_function = function (arg_3_0, arg_3_1)
						local var_3_0 = arg_3_0.parent

						if var_3_0.scroller_hotspot.selected then
							var_3_0.scrollbar_hover_progress = 0

							return
						end

						local var_3_1 = arg_3_0.is_hover
						local var_3_2, var_3_3 = Managers.time:time_and_delta("main")
						local var_3_4 = 4
						local var_3_5 = var_3_0.scrollbar_hover_progress or 0

						var_3_0.scrollbar_hover_progress = math.clamp(var_3_5 + var_3_3 * var_3_4 * (var_3_1 and 1 or -1), 0, 1)
					end
				},
				{
					style_id = "scroller",
					pass_type = "hotspot",
					content_id = "scroller_hotspot",
					content_change_function = function (arg_4_0, arg_4_1)
						local var_4_0 = arg_4_0.parent
						local var_4_1 = arg_4_0.is_hover or arg_4_0.selected
						local var_4_2, var_4_3 = Managers.time:time_and_delta("main")
						local var_4_4 = 4
						local var_4_5 = var_4_0.hover_progress or 0

						var_4_0.hover_progress = math.clamp(var_4_5 + var_4_3 * var_4_4 * (var_4_1 and 1 or -1), 0, 1)
					end
				},
				{
					style_id = "scrollbar_bg",
					pass_type = "rounded_background",
					content_change_function = function (arg_5_0, arg_5_1)
						local var_5_0 = math.easeOutCubic(arg_5_0.scrollbar_hover_progress)

						arg_5_1.color[2] = math.lerp(30, 60, var_5_0)
						arg_5_1.color[3] = math.lerp(30, 60, var_5_0)
						arg_5_1.color[4] = math.lerp(30, 60, var_5_0)
					end
				},
				{
					pass_type = "rounded_background",
					style_id = "scrollbar_fg"
				},
				{
					style_id = "scroller",
					pass_type = "rounded_background",
					content_change_function = function (arg_6_0, arg_6_1)
						local var_6_0 = arg_6_0.scroller_hotspot
						local var_6_1 = math.easeOutCubic(arg_6_0.hover_progress)

						arg_6_1.color[2] = math.lerp(30, 128, var_6_1)
						arg_6_1.color[3] = math.lerp(30, 128, var_6_1)
						arg_6_1.color[4] = math.lerp(30, 128, var_6_1)
					end
				}
			}
		},
		content = {
			mask = "mask_rect",
			hotspot = {},
			scroller_hotspot = {},
			num_elements = arg_2_0
		},
		style = {
			scrollbar_bg = {
				corner_radius = 6,
				color = {
					255,
					30,
					30,
					30
				}
			},
			scrollbar_fg = {
				corner_radius = 6,
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					1,
					1,
					1
				},
				size = {
					var_0_3.scrollbar.size[1] - 2,
					var_0_3.scrollbar.size[2] - 2
				}
			},
			scroller = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				corner_radius = 6,
				color = {
					255,
					30,
					30,
					30
				},
				offset = {
					1,
					0,
					2
				},
				rect_size = {
					var_0_3.scrollbar.size[1] - 2,
					(var_0_3.scrollbar.size[2] - 2) * var_2_3
				},
				area_size = {
					var_0_3.scrollbar.size[1] - 2,
					(var_0_3.scrollbar.size[2] - 2) * var_2_3
				}
			}
		}
	}
end

local var_0_8 = {
	fade_edge = UIWidgets.create_simple_texture("horizontal_gradient", "fade_area_edge", nil, nil, {
		235,
		0,
		0,
		0
	}),
	canvas_hotspot = UIWidgets.create_simple_hotspot("canvas_hotspot"),
	fade_background = UIWidgets.create_simple_rect("fade_area_bg", {
		235,
		0,
		0,
		0
	}),
	title_text = UIWidgets.create_simple_text("start_menu_cinematics", "canvas", nil, nil, var_0_4),
	title_text_shadow = UIWidgets.create_simple_text("start_menu_cinematics", "canvas", nil, nil, var_0_5),
	video_area = var_0_6(),
	video_area_top = UIWidgets.create_simple_texture("vertical_gradient_write_mask", "video_area_top"),
	video_area_bottom = UIWidgets.create_simple_uv_texture("vertical_gradient_write_mask", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "video_area_bottom")
}
local var_0_9 = {
	back_button = UIWidgets.create_layout_button("back_button", "layout_button_back", "layout_button_back_glow")
}

local function var_0_10(arg_7_0)
	return {
		scenegraph_id = "fullscreen_video",
		element = {
			passes = {
				{
					scenegraph_id = "fullscreen_video",
					style_id = "video_style",
					pass_type = "video",
					content_id = "video_content",
					content_check_function = function (arg_8_0, arg_8_1)
						return arg_7_0:is_video_active(arg_8_0.video_player_reference)
					end
				},
				{
					style_id = "video_fade",
					pass_type = "rect",
					scenegraph_id = "fullscreen_video",
					content_check_function = function (arg_9_0, arg_9_1)
						local var_9_0 = arg_7_0:is_video_active(arg_9_0.video_content.video_player_reference)

						arg_9_0.fade_progress = var_9_0 and arg_9_0.fade_progress or 0

						return var_9_0
					end,
					content_change_function = function (arg_10_0, arg_10_1)
						local var_10_0 = arg_10_0.fade_progress
						local var_10_1 = math.easeInCubic(var_10_0)

						arg_10_1.color[1] = (1 - var_10_1) * 255

						local var_10_2, var_10_3 = Managers.time:time_and_delta("main")

						arg_10_0.fade_progress = math.min(var_10_0 + var_10_3 * 0.5, 1)
					end
				},
				{
					scenegraph_id = "root",
					style_id = "video_background",
					pass_type = "rect",
					content_check_function = function (arg_11_0)
						if not arg_7_0:is_video_active(arg_11_0.video_content.video_player_reference) then
							return false
						end

						local var_11_0, var_11_1 = Gui.resolution()
						local var_11_2 = var_11_0 / var_11_1
						local var_11_3 = 1.7777777777777777
						local var_11_4 = var_11_1
						local var_11_5 = var_11_0

						if math.abs(var_11_2 - var_11_3) > 0.005 then
							return true
						end
					end
				}
			}
		},
		content = {
			fade_progress = 0
		},
		style = {
			video_style = {
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					1920,
					1080
				},
				offset = {
					0,
					0,
					100
				}
			},
			video_fade = {
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					101
				}
			},
			video_background = {
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					99
				}
			}
		}
	}
end

local function var_0_11(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_1.header
	local var_12_1 = arg_12_1.description
	local var_12_2 = arg_12_1.time
	local var_12_3 = arg_12_1.release_date
	local var_12_4 = arg_12_3
	local var_12_5 = arg_12_1.video_data
	local var_12_6 = var_12_5.resource
	local var_12_7 = arg_12_1.thumbnail
	local var_12_8 = arg_12_1.header .. " " .. Application.guid()
	local var_12_9 = false

	if not arg_12_0.video_players[var_12_8] then
		if var_12_5.set_loop ~= nil then
			var_12_9 = var_12_5.set_loop
		end

		UIRenderer.create_video_player(arg_12_0, var_12_8, arg_12_0.world, var_12_6, var_12_9)
	end

	local var_12_10 = arg_12_0.video_players[var_12_8]
	local var_12_11 = VideoPlayer.number_of_frames(var_12_10) / (var_12_5.frames_per_second or 30)
	local var_12_12 = UIUtils.format_time(var_12_11)

	UIRenderer.destroy_video_player(arg_12_0, var_12_8, arg_12_0.world)

	return {
		scenegraph_id = "anchor_point",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "bg_background_top",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "bg_background_bottom",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "bg_background_left",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "bg_background_right",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "fg_background",
					texture_id = "rect_masked"
				},
				{
					style_id = "header",
					pass_type = "text",
					text_id = "header"
				},
				{
					style_id = "header_shadow",
					pass_type = "text",
					text_id = "header"
				},
				{
					pass_type = "texture",
					style_id = "divider",
					texture_id = "rect_masked"
				},
				{
					style_id = "play_icon",
					texture_id = "play_icon",
					pass_type = "texture",
					content_check_function = function (arg_13_0, arg_13_1)
						return not arg_12_4:is_video_active(arg_13_0.video_content.video_player_reference)
					end,
					content_change_function = function (arg_14_0, arg_14_1)
						if Managers.input:is_device_active("gamepad") or Managers.input:is_device_active("keyboard") then
							if arg_12_2 == arg_12_4:current_gamepad_selection() then
								arg_14_1.color[1] = 255
							else
								arg_14_1.color[1] = 63
							end
						else
							local var_14_0 = arg_14_0.hover_progress
							local var_14_1 = math.easeOutCubic(var_14_0)

							arg_14_1.color[1] = 63 + 192 * var_14_1
						end
					end
				},
				{
					style_id = "description",
					pass_type = "text",
					text_id = "description"
				},
				{
					style_id = "time",
					pass_type = "text",
					text_id = "time"
				},
				{
					style_id = "release_date",
					pass_type = "text",
					text_id = "release_date"
				},
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot",
					content_check_function = function (arg_15_0, arg_15_1)
						local var_15_0 = arg_15_0.parent

						return not arg_12_4:is_video_active(var_15_0.video_content.video_player_reference)
					end,
					content_change_function = function (arg_16_0, arg_16_1)
						local var_16_0 = arg_16_0.parent

						if arg_16_0.on_pressed then
							local var_16_1 = var_16_0.video_content

							arg_12_4:activate_video(var_16_1, arg_12_2)
						elseif arg_16_0.on_hover_enter then
							arg_12_4:_play_sound("play_gui_start_menu_button_hover")
						end

						local var_16_2, var_16_3 = Managers.time:time_and_delta("main")
						local var_16_4 = 4
						local var_16_5 = var_16_0.hover_progress

						var_16_0.hover_progress = math.clamp(var_16_5 + var_16_3 * var_16_4 * (arg_16_0.is_hover and 1 or -1), 0, 1)
					end
				},
				{
					pass_type = "texture",
					style_id = "bg_video_left",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "bg_video_right",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "bg_video_top",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "bg_video_bottom",
					texture_id = "rect_masked"
				},
				{
					style_id = "thumbnail",
					texture_id = "thumbnail",
					pass_type = "texture",
					content_check_function = function (arg_17_0)
						return arg_17_0.thumbnail
					end,
					content_change_function = function (arg_18_0, arg_18_1)
						if Managers.input:is_device_active("gamepad") or Managers.input:is_device_active("keyboard") then
							if arg_12_2 == arg_12_4:current_gamepad_selection() then
								arg_18_1.color[1] = 255
							else
								arg_18_1.color[1] = 63
							end
						else
							local var_18_0 = arg_18_0.hover_progress
							local var_18_1 = math.easeOutCubic(var_18_0)

							arg_18_1.color[1] = 127 + 128 * var_18_1
						end
					end
				}
			}
		},
		content = {
			hover_progress = 0,
			rect_masked = "rect_masked",
			play_icon = "play_icon_masked",
			hotspot = {},
			fullscreen_hotspot = {},
			header = var_12_0,
			description = var_12_1,
			time = var_12_12,
			release_date = var_12_3,
			reference_name = var_12_8,
			thumbnail = var_12_7,
			video_content = {
				video_completed = false,
				material_name = "video_default",
				video_player_reference = var_12_8,
				video_data = var_12_5
			}
		},
		style = {
			bg_background_top = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					56,
					43,
					34
				},
				offset = {
					-2,
					2,
					1
				},
				texture_size = {
					var_0_1[1] + 4,
					2
				}
			},
			bg_background_bottom = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				color = {
					255,
					56,
					43,
					34
				},
				offset = {
					-2,
					-2,
					1
				},
				texture_size = {
					var_0_1[1] + 4,
					2
				}
			},
			bg_background_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					56,
					43,
					34
				},
				offset = {
					-2,
					2,
					1
				},
				texture_size = {
					2,
					var_0_1[2] + 4
				}
			},
			bg_background_right = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				color = {
					255,
					56,
					43,
					34
				},
				offset = {
					2,
					2,
					1
				},
				texture_size = {
					2,
					var_0_1[2] + 4
				}
			},
			fg_background = {
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
					2
				},
				texture_size = var_0_1
			},
			header = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				font_size = 36,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header_masked",
				text_color = {
					255,
					140,
					128,
					90
				},
				offset = {
					0,
					41,
					3
				}
			},
			header_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				font_size = 36,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header_masked",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					2,
					39,
					2
				}
			},
			description = {
				word_wrap = true,
				font_type = "hell_shark_masked",
				localize = true,
				dynamic_font_size_word_wrap = true,
				font_size = 21,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					var_0_1[1] * 0.62,
					var_0_1[2] * 0.55
				},
				text_color = {
					255,
					118,
					118,
					118
				},
				offset = {
					var_0_1[1] * 0.35,
					-10,
					3
				}
			},
			time = {
				vertical_alignment = "bottom",
				font_size = 26,
				localize = false,
				horizontal_alignment = "left",
				word_wrap = false,
				font_type = "hell_shark_header_masked",
				text_color = {
					255,
					118,
					118,
					118
				},
				offset = {
					var_0_1[1] * 0.35,
					35,
					3
				}
			},
			release_date = {
				vertical_alignment = "bottom",
				font_size = 26,
				localize = false,
				horizontal_alignment = "left",
				word_wrap = false,
				font_type = "hell_shark_header_masked",
				text_color = {
					255,
					118,
					118,
					118
				},
				offset = {
					var_0_1[1] * 0.35,
					5,
					3
				}
			},
			divider = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					var_0_0[1] * 0.63,
					2
				},
				offset = {
					var_0_1[1] * 0.35,
					-35,
					3
				},
				color = {
					255,
					118,
					118,
					118
				}
			},
			hotspot = {
				size = {
					393.59999999999997,
					221.39999999999998
				},
				offset = {
					10,
					13,
					13
				}
			},
			play_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					76,
					76
				},
				offset = {
					168.79999999999998,
					0,
					14
				}
			},
			bg_video_left = {
				color = {
					255,
					118,
					118,
					118
				},
				texture_size = {
					2,
					225.39999999999998
				},
				offset = {
					8,
					11,
					10
				}
			},
			bg_video_right = {
				color = {
					255,
					118,
					118,
					118
				},
				texture_size = {
					2,
					225.39999999999998
				},
				offset = {
					403.59999999999997,
					11,
					10
				}
			},
			bg_video_top = {
				color = {
					255,
					118,
					118,
					118
				},
				texture_size = {
					397.59999999999997,
					2
				},
				offset = {
					8,
					236.39999999999998,
					10
				}
			},
			bg_video_bottom = {
				color = {
					255,
					118,
					118,
					118
				},
				texture_size = {
					397.59999999999997,
					2
				},
				offset = {
					8,
					11,
					10
				}
			},
			thumbnail = {
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					393.59999999999997,
					221.39999999999998
				},
				offset = {
					10,
					13,
					11
				}
			}
		},
		offset = {
			0,
			-(arg_12_2 - 1) * var_0_0[2],
			0
		}
	}
end

local var_0_12 = {
	on_enter = {
		{
			name = "slide_and_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				arg_19_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = math.easeOutCubic(arg_20_3)

				arg_20_0.screen_anchor.local_position[1] = math.lerp(1920, 0, var_20_0)
				arg_20_0.fade_area_bg.local_position[1] = math.lerp(1920 + var_0_3.fade_area_bg.position[1], var_0_3.fade_area_bg.position[1], var_20_0)
				arg_20_0.fade_area_edge.local_position[1] = math.lerp(1920 + var_0_3.fade_area_edge.position[1], var_0_3.fade_area_edge.position[1], var_20_0)
				arg_20_4.render_settings.alpha_multiplier = var_20_0 * var_20_0 * var_20_0
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				arg_21_3.render_settings.alpha_multiplier = 1
			end
		}
	},
	on_exit = {
		{
			name = "slide_and_fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				arg_22_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				local var_23_0 = math.easeOutCubic(arg_23_3)

				arg_23_0.screen_anchor.local_position[1] = math.lerp(0, 1920, var_23_0)
				arg_23_0.fade_area_bg.local_position[1] = math.lerp(var_0_3.fade_area_bg.position[1], 1920 + var_0_3.fade_area_bg.position[1], var_23_0)
				arg_23_0.fade_area_edge.local_position[1] = math.lerp(var_0_3.fade_area_edge.position[1], 1920 + var_0_3.fade_area_edge.position[1], var_23_0)
				arg_23_4.render_settings.alpha_multiplier = 1 - var_23_0 * var_23_0 * var_23_0
			end,
			on_complete = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				arg_24_3.render_settings.alpha_multiplier = 0
			end
		}
	}
}
local var_0_13 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_play"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	}
}

return {
	create_video_entry = var_0_10,
	create_cinematic_entry = var_0_11,
	scenegraph_definition = var_0_3,
	widget_definitions = var_0_8,
	button_widget_definitions = var_0_9,
	entry_size = var_0_0,
	create_scrollbar = var_0_7,
	animation_definitions = var_0_12,
	generic_input_actions = var_0_13
}
