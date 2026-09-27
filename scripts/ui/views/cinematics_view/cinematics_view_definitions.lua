-- chunkname: @scripts/ui/views/cinematics_view/cinematics_view_definitions.lua

local tbl = {
	1200,
	350
}
local tbl_2 = {
	1200,
	250
}
local tbl_3 = {
	1920,
	1080
}
local tbl_4 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.options_menu
		},
		size = tbl_3
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
		size = tbl_3
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
			tbl[1],
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
			tbl[1] + 20,
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
			tbl[1] + 20,
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
			tbl[1] + 20,
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
		size = tbl_2
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
local tbl_5 = {
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
local tbl_6 = {
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

local function fn()
	-- function 1
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

local function fn_2(arg_2_0)
	-- function 2
	local var_2_0 = tbl_4.video_area.size[2]
	local num = arg_2_0 * tbl[2]
	local flag

	flag = num <= var_2_0

	local num_2 = var_2_0 / num

	return {
		scenegraph_id = "scrollbar",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot",
					content_change_function = function (self, arg_3_1)
						-- function 3
						local parent = self.parent

						if not parent.scroller_hotspot.selected then
							parent.scrollbar_hover_progress = 0

							return
						end

						local is_hover = self.is_hover
						local time_and_delta, var_3_3 = Managers.time:time_and_delta("main")
						local num = 4
						local scrollbar_hover_progress = parent.scrollbar_hover_progress

						scrollbar_hover_progress = scrollbar_hover_progress or 0

						local clamp = math.clamp
						local num_2 = var_3_3 * num
						local flag

						flag = not is_hover and 1 and -1
						parent.scrollbar_hover_progress = clamp(scrollbar_hover_progress + num_2 * flag, 0, 1)
					end
				},
				{
					style_id = "scroller",
					pass_type = "hotspot",
					content_id = "scroller_hotspot",
					content_change_function = function (self, arg_4_1)
						-- function 4
						local parent = self.parent
						local is_hover = self.is_hover

						is_hover = is_hover or self.selected

						local time_and_delta, var_4_3 = Managers.time:time_and_delta("main")
						local num = 4
						local hover_progress = parent.hover_progress

						hover_progress = hover_progress or 0

						local clamp = math.clamp
						local num_2 = var_4_3 * num
						local flag

						flag = not is_hover and 1 and -1
						parent.hover_progress = clamp(hover_progress + num_2 * flag, 0, 1)
					end
				},
				{
					style_id = "scrollbar_bg",
					pass_type = "rounded_background",
					content_change_function = function (self, arg_5_1)
						-- function 5
						local easeOutCubic = math.easeOutCubic(self.scrollbar_hover_progress)

						arg_5_1.color[2] = math.lerp(30, 60, easeOutCubic)
						arg_5_1.color[3] = math.lerp(30, 60, easeOutCubic)
						arg_5_1.color[4] = math.lerp(30, 60, easeOutCubic)
					end
				},
				{
					pass_type = "rounded_background",
					style_id = "scrollbar_fg"
				},
				{
					style_id = "scroller",
					pass_type = "rounded_background",
					content_change_function = function (self, arg_6_1)
						-- function 6
						local scroller_hotspot = self.scroller_hotspot
						local easeOutCubic = math.easeOutCubic(self.hover_progress)

						arg_6_1.color[2] = math.lerp(30, 128, easeOutCubic)
						arg_6_1.color[3] = math.lerp(30, 128, easeOutCubic)
						arg_6_1.color[4] = math.lerp(30, 128, easeOutCubic)
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
					tbl_4.scrollbar.size[1] - 2,
					tbl_4.scrollbar.size[2] - 2
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
					tbl_4.scrollbar.size[1] - 2,
					(tbl_4.scrollbar.size[2] - 2) * num_2
				},
				area_size = {
					tbl_4.scrollbar.size[1] - 2,
					(tbl_4.scrollbar.size[2] - 2) * num_2
				}
			}
		}
	}
end

local tbl_7 = {
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
	title_text = UIWidgets.create_simple_text("start_menu_cinematics", "canvas", nil, nil, tbl_5),
	title_text_shadow = UIWidgets.create_simple_text("start_menu_cinematics", "canvas", nil, nil, tbl_6),
	video_area = fn(),
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
local tbl_8 = {
	back_button = UIWidgets.create_layout_button("back_button", "layout_button_back", "layout_button_back_glow")
}

local function fn_3(arg_7_0)
	-- function 7
	return {
		scenegraph_id = "fullscreen_video",
		element = {
			passes = {
				{
					scenegraph_id = "fullscreen_video",
					style_id = "video_style",
					pass_type = "video",
					content_id = "video_content",
					content_check_function = function (self, arg_8_1)
						-- function 8
						return arg_7_0:is_video_active(self.video_player_reference)
					end
				},
				{
					style_id = "video_fade",
					pass_type = "rect",
					scenegraph_id = "fullscreen_video",
					content_check_function = function (self, arg_9_1)
						-- function 9
						local is_video_active = arg_7_0:is_video_active(self.video_content.video_player_reference)
						local fade_progress

						if not is_video_active then
							fade_progress = self.fade_progress

							if not fade_progress then
								-- Nothing
							end
						end

						fade_progress = 0

						::label_9_0::

						self.fade_progress = fade_progress

						return is_video_active
					end,
					content_change_function = function (self, arg_10_1)
						-- function 10
						local fade_progress = self.fade_progress
						local easeInCubic = math.easeInCubic(fade_progress)

						arg_10_1.color[1] = (1 - easeInCubic) * 255

						local time_and_delta, var_10_3 = Managers.time:time_and_delta("main")

						self.fade_progress = math.min(fade_progress + var_10_3 * 0.5, 1)
					end
				},
				{
					scenegraph_id = "root",
					style_id = "video_background",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 11
						if not arg_7_0:is_video_active(self.video_content.video_player_reference) then
							return false
						end

						local resolution, var_11_1 = Gui.resolution()
						local num = resolution / var_11_1
						local num_2 = 1.7777777777777777
						local var_11_4 = var_11_1
						local var_11_5 = resolution

						if math.abs(num - num_2) > 0.005 then
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

local function fn_4(self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local header = arg_12_1.header
	local description = arg_12_1.description
	local time = arg_12_1.time
	local release_date = arg_12_1.release_date
	local var_12_4 = arg_12_3
	local video_data = arg_12_1.video_data
	local resource = video_data.resource
	local thumbnail = arg_12_1.thumbnail
	local str = arg_12_1.header .. " " .. Application.guid()
	local flag = false

	if not self.video_players[str] then
		if video_data.set_loop ~= nil then
			flag = video_data.set_loop
		end

		UIRenderer.create_video_player(self, str, self.world, resource, flag)
	end

	local var_12_10 = self.video_players[str]
	local number_of_frames = VideoPlayer.number_of_frames(var_12_10)
	local frames_per_second = video_data.frames_per_second

	frames_per_second = frames_per_second or 30

	local num = number_of_frames / frames_per_second
	local format_time = UIUtils.format_time(num)

	UIRenderer.destroy_video_player(self, str, self.world)

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
					content_check_function = function (self, arg_13_1)
						-- function 13
						return not arg_12_4:is_video_active(self.video_content.video_player_reference)
					end,
					content_change_function = function (self, arg_14_1)
						-- function 14
						local is_device_active = Managers.input:is_device_active("gamepad")

						is_device_active = is_device_active or Managers.input:is_device_active("keyboard")

						if not is_device_active then
							if arg_12_2 == arg_12_4:current_gamepad_selection() then
								arg_14_1.color[1] = 255
							else
								arg_14_1.color[1] = 63
							end
						else
							local hover_progress = self.hover_progress
							local easeOutCubic = math.easeOutCubic(hover_progress)

							arg_14_1.color[1] = 63 + 192 * easeOutCubic
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
					content_check_function = function (self, arg_15_1)
						-- function 15
						local parent = self.parent

						return not arg_12_4:is_video_active(parent.video_content.video_player_reference)
					end,
					content_change_function = function (self, arg_16_1)
						-- function 16
						local parent = self.parent

						if not self.on_pressed then
							local video_content = parent.video_content

							arg_12_4:activate_video(video_content, arg_12_2)
						elseif not self.on_hover_enter then
							arg_12_4:_play_sound("play_gui_start_menu_button_hover")
						end

						local time_and_delta, var_16_3 = Managers.time:time_and_delta("main")
						local num = 4
						local hover_progress = parent.hover_progress
						local clamp = math.clamp
						local num_2 = var_16_3 * num
						local flag

						flag = not self.is_hover and 1 and -1
						parent.hover_progress = clamp(hover_progress + num_2 * flag, 0, 1)
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
					content_check_function = function (self)
						-- function 17
						return self.thumbnail
					end,
					content_change_function = function (self, arg_18_1)
						-- function 18
						local is_device_active = Managers.input:is_device_active("gamepad")

						is_device_active = is_device_active or Managers.input:is_device_active("keyboard")

						if not is_device_active then
							if arg_12_2 == arg_12_4:current_gamepad_selection() then
								arg_18_1.color[1] = 255
							else
								arg_18_1.color[1] = 63
							end
						else
							local hover_progress = self.hover_progress
							local easeOutCubic = math.easeOutCubic(hover_progress)

							arg_18_1.color[1] = 127 + 128 * easeOutCubic
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
			header = header,
			description = description,
			time = format_time,
			release_date = release_date,
			reference_name = str,
			thumbnail = thumbnail,
			video_content = {
				video_completed = false,
				material_name = "video_default",
				video_player_reference = str,
				video_data = video_data
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
					tbl_2[1] + 4,
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
					tbl_2[1] + 4,
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
					tbl_2[2] + 4
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
					tbl_2[2] + 4
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
				texture_size = tbl_2
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
					tbl_2[1] * 0.62,
					tbl_2[2] * 0.55
				},
				text_color = {
					255,
					118,
					118,
					118
				},
				offset = {
					tbl_2[1] * 0.35,
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
					tbl_2[1] * 0.35,
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
					tbl_2[1] * 0.35,
					5,
					3
				}
			},
			divider = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					tbl[1] * 0.63,
					2
				},
				offset = {
					tbl_2[1] * 0.35,
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
			-(arg_12_2 - 1) * tbl[2],
			0
		}
	}
end

local tbl_9 = {
	on_enter = {
		{
			name = "slide_and_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				arg_19_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				local easeOutCubic = math.easeOutCubic(arg_20_3)

				arg_20_0.screen_anchor.local_position[1] = math.lerp(1920, 0, easeOutCubic)
				arg_20_0.fade_area_bg.local_position[1] = math.lerp(1920 + tbl_4.fade_area_bg.position[1], tbl_4.fade_area_bg.position[1], easeOutCubic)
				arg_20_0.fade_area_edge.local_position[1] = math.lerp(1920 + tbl_4.fade_area_edge.position[1], tbl_4.fade_area_edge.position[1], easeOutCubic)
				arg_20_4.render_settings.alpha_multiplier = easeOutCubic * easeOutCubic * easeOutCubic
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
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
				-- function 22
				arg_22_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				-- function 23
				local easeOutCubic = math.easeOutCubic(arg_23_3)

				arg_23_0.screen_anchor.local_position[1] = math.lerp(0, 1920, easeOutCubic)
				arg_23_0.fade_area_bg.local_position[1] = math.lerp(tbl_4.fade_area_bg.position[1], 1920 + tbl_4.fade_area_bg.position[1], easeOutCubic)
				arg_23_0.fade_area_edge.local_position[1] = math.lerp(tbl_4.fade_area_edge.position[1], 1920 + tbl_4.fade_area_edge.position[1], easeOutCubic)
				arg_23_4.render_settings.alpha_multiplier = 1 - easeOutCubic * easeOutCubic * easeOutCubic
			end,
			on_complete = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				arg_24_3.render_settings.alpha_multiplier = 0
			end
		}
	}
}
local tbl_10 = {
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
	create_video_entry = fn_3,
	create_cinematic_entry = fn_4,
	scenegraph_definition = tbl_4,
	widget_definitions = tbl_7,
	button_widget_definitions = tbl_8,
	entry_size = tbl,
	create_scrollbar = fn_2,
	animation_definitions = tbl_9,
	generic_input_actions = tbl_10
}
