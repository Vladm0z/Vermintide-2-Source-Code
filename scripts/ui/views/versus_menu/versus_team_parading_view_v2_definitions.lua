-- chunkname: @scripts/ui/views/versus_menu/versus_team_parading_view_v2_definitions.lua

local tbl = {
	474,
	46
}
local tbl_2 = {
	screen = {
		0,
		0,
		UILayer.default
	},
	bottom_bar = {
		0,
		0,
		10
	},
	bottom_bar_detail = {
		0,
		0,
		1
	},
	top_bar_detail = {
		0,
		-20,
		1
	},
	center_pivot = {
		0,
		0,
		1
	},
	player_portrait_anchor_1 = {
		528,
		200,
		20
	},
	player_portrait_anchor_2 = {
		816,
		200,
		20
	},
	player_portrait_anchor_3 = {
		1104,
		200,
		20
	},
	player_portrait_anchor_4 = {
		1392,
		200,
		20
	},
	player_insignia_anchor_1 = {
		-523,
		80,
		40
	},
	player_insignia_anchor_2 = {
		-235,
		80,
		40
	},
	player_insignia_anchor_3 = {
		55,
		80,
		40
	},
	player_insignia_anchor_4 = {
		343,
		80,
		40
	}
}
local tbl_3 = {
	screen = {
		1920,
		1080
	},
	bottom_bar = {
		1920,
		250
	},
	bottom_bar_detail = {
		1860,
		14
	},
	top_bar_detail = {
		1860,
		14
	},
	center_pivot = {
		0,
		0
	},
	player_portrait_anchor_1 = player_portrait_anchor_size,
	player_portrait_anchor_2 = player_portrait_anchor_size,
	player_portrait_anchor_3 = player_portrait_anchor_size,
	player_portrait_anchor_4 = player_portrait_anchor_size,
	player_insignia_anchor_1 = player_portrait_anchor_size,
	player_insignia_anchor_2 = player_portrait_anchor_size,
	player_insignia_anchor_3 = player_portrait_anchor_size,
	player_insignia_anchor_4 = player_portrait_anchor_size
}
local tbl_4 = {
	screen = {
		scale = "fit",
		size = tbl_3.screen,
		position = tbl_2.screen
	},
	bottom_bar = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		horizontal_alignment = "center",
		size = tbl_3.bottom_bar,
		position = tbl_2.bottom_bar
	},
	bottom_bar_detail = {
		vertical_alignment = "top",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_3.bottom_bar_detail,
		position = tbl_2.bottom_bar_detail
	},
	top_bar_detail = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl_3.top_bar_detail,
		position = tbl_2.top_bar_detail
	},
	center_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl_3.center_pivot,
		position = tbl_2.center_pivot
	},
	player_portrait_anchor_1 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_3.player_portrait_anchor_1,
		position = tbl_2.player_portrait_anchor_1
	},
	player_portrait_anchor_2 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_3.player_portrait_anchor_2,
		position = tbl_2.player_portrait_anchor_2
	},
	player_portrait_anchor_3 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_3.player_portrait_anchor_3,
		position = tbl_2.player_portrait_anchor_3
	},
	player_portrait_anchor_4 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_3.player_portrait_anchor_4,
		position = tbl_2.player_portrait_anchor_4
	},
	player_insignia_anchor_1 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_3.player_insignia_anchor_1,
		position = tbl_2.player_insignia_anchor_1
	},
	player_insignia_anchor_2 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_3.player_insignia_anchor_2,
		position = tbl_2.player_insignia_anchor_2
	},
	player_insignia_anchor_3 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_3.player_insignia_anchor_3,
		position = tbl_2.player_insignia_anchor_3
	},
	player_insignia_anchor_4 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_3.player_insignia_anchor_4,
		position = tbl_2.player_insignia_anchor_4
	}
}
local tbl_5 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	font_size = 72,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("local_player_team", 0),
	offset = {
		0,
		-10,
		2
	}
}

function create_rotated_texture(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	-- function 1
	return {
		alpha_multiplier = 0,
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "rotated_texture"
				}
			}
		},
		content = {
			texture_id = arg_1_0
		},
		style = {
			texture_id = {
				angle = arg_1_1,
				pivot = arg_1_3,
				color = arg_1_5 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					arg_1_6 or 0
				},
				texture_size = arg_1_2
			}
		},
		offset = arg_1_7 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_4
	}
end

function create_player_name_career_text(arg_2_0)
	-- function 2
	return {
		element = {
			passes = {
				{
					style_id = "player_name",
					pass_type = "text",
					text_id = "player_name"
				},
				{
					style_id = "career_name",
					pass_type = "text",
					text_id = "career_name"
				}
			}
		},
		content = {
			career_name = "n/a",
			player_name = "n/a"
		},
		style = {
			player_name = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 28,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("local_player_team_lighter", 255),
				offset = {
					0,
					0,
					2
				}
			},
			career_name = {
				word_wrap = true,
				upper_case = false,
				localize = true,
				font_size = 24,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-30,
					2
				}
			}
		},
		scenegraph_id = arg_2_0,
		offset = {
			-960,
			0,
			10
		}
	}
end

local tbl_6 = {
	bottom_background = UIWidgets.create_simple_rect("bottom_bar", Colors.get_color_table_with_alpha("black", 100)),
	bottom_background_detail = UIWidgets.create_parading_screen_divider("bottom_bar_detail", tbl_4.bottom_bar_detail.size)
}
local tbl_7 = {
	top_background_detail = UIWidgets.create_parading_screen_divider("top_bar_detail", tbl_4.top_bar_detail.size),
	team_flag = UIWidgets.create_simple_texture("banner_hammers_local_long", "top_bar_detail", nil, nil, {
		255,
		255,
		255,
		255
	}, {
		50,
		-252,
		0
	}, {
		232,
		484
	})
}
local tbl_8 = {
	512,
	512
}
local tbl_9 = {
	-tbl_8[1] / 2,
	-tbl_8[1] / 2,
	0
}
local tbl_10 = {
	2300,
	50
}
local tbl_11 = {
	2300,
	500
}
local tbl_12 = {
	-1160,
	250,
	0
}
local tbl_13 = {
	-1160,
	-300,
	0
}
local tbl_14 = {
	background = UIWidgets.create_simple_rect("screen", Colors.get_color_table_with_alpha("black", 255))
}
local tbl_15 = {
	level_name = "levels/carousel_podium/world"
}
local tbl_16 = {
	on_enter_local_player = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				local self = arg_3_3.self
				local _bottom_widgets = self._bottom_widgets
				local _team_portrait_frame_widgets = self._team_portrait_frame_widgets
				local _top_widgets = self._top_widgets
				local _player_name_widgets = self._player_name_widgets
				local _team_insignia_widgets = self._team_insignia_widgets

				for i, v in ipairs(_bottom_widgets) do
					v.alpha_multiplier = 0
				end

				for i_2, v_2 in ipairs(_team_portrait_frame_widgets) do
					v_2.alpha_multiplier = 0
				end

				for i_3, v_3 in ipairs(_team_insignia_widgets) do
					v_3.alpha_multiplier = 0
				end

				for i_4, v_4 in ipairs(_top_widgets) do
					v_4.alpha_multiplier = 0
				end

				for i_5, v_5 in ipairs(_top_widgets) do
					v_5.alpha_multiplier = 0
				end
			end,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				-- function 4
				local easeOutCubic = math.easeOutCubic(arg_4_3)
				local self = arg_4_4.self
				local _bottom_widgets = self._bottom_widgets
				local _team_portrait_frame_widgets = self._team_portrait_frame_widgets
				local _top_widgets = self._top_widgets
				local _team_insignia_widgets = self._team_insignia_widgets

				for i, v in ipairs(_bottom_widgets) do
					v.alpha_multiplier = easeOutCubic
				end

				for i_2, v_2 in ipairs(_team_portrait_frame_widgets) do
					v_2.alpha_multiplier = easeOutCubic
				end

				for i_3, v_3 in ipairs(_team_insignia_widgets) do
					v_3.alpha_multiplier = easeOutCubic
				end

				for i_4, v_4 in ipairs(_top_widgets) do
					v_4.alpha_multiplier = easeOutCubic
				end

				for i_5, v_5 in ipairs(_top_widgets) do
					v_5.alpha_multiplier = easeOutCubic
				end
			end,
			on_complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				local _transition_widgets = arg_5_3.self._transition_widgets

				for i, v in ipairs(_transition_widgets) do
					v.alpha_multiplier = 0
				end
			end
		},
		{
			name = "slide_up_bottom_widgets",
			start_progress = 0,
			end_progress = 0.8,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				local easeOutCubic = math.easeOutCubic(arg_7_3)
				local self = arg_7_4.self
				local _bottom_widgets = self._bottom_widgets
				local _team_portrait_frame_widgets = self._team_portrait_frame_widgets
				local _team_insignia_widgets = self._team_insignia_widgets
				local _player_name_widgets = self._player_name_widgets

				for i, v in ipairs(_bottom_widgets) do
					local num = -250 + 250 * easeOutCubic

					v.offset[2] = num
				end

				for i_2, v_2 in ipairs(_team_portrait_frame_widgets) do
					local num_2 = -200 + 200 * easeOutCubic

					v_2.offset[2] = num_2
				end

				for i_3, v_3 in ipairs(_team_insignia_widgets) do
					local num_3 = -200 + 200 * easeOutCubic

					v_3.offset[2] = num_3
				end

				for i_4, v_4 in ipairs(_player_name_widgets) do
					local num_4 = -270 + 50 * easeOutCubic

					v_4.offset[2] = num_4
				end
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end
		},
		{
			name = "slide_in_top_widgets",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				-- function 10
				local easeOutCubic = math.easeOutCubic(arg_10_3)
				local ease_out_quad = math.ease_out_quad(arg_10_3)
				local self = arg_10_4.self
				local top_background_detail = self._widgets_by_name.top_background_detail
				local team_flag = self._widgets_by_name.team_flag
				local num = 1920 - 1920 * easeOutCubic

				top_background_detail.offset[1] = num

				local num_2 = -480 + 480 * (1 - easeOutCubic)

				team_flag.offset[2] = num_2
			end,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				return
			end
		}
	},
	team_transition_fade_in = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				local self = arg_12_3.self
				local _bottom_widgets = self._bottom_widgets
				local _transition_widgets = self._transition_widgets
				local _top_widgets = self._top_widgets

				for i, v in ipairs(_bottom_widgets) do
					v.alpha_multiplier = 0
				end

				for i_2, v_2 in ipairs(_transition_widgets) do
					v_2.alpha_multiplier = 0
				end

				for i_3, v_3 in ipairs(_top_widgets) do
					v_3.alpha_multiplier = 0
				end
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				-- function 13
				local easeOutCubic = math.easeOutCubic(arg_13_3)
				local _transition_widgets = arg_13_4.self._transition_widgets

				for i, v in ipairs(_transition_widgets) do
					v.alpha_multiplier = easeOutCubic
				end
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end
		},
		{
			name = "slide_in",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				-- function 16
				return
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				local self = arg_17_3.self
				local _opponents_party_data = self._opponents_party_data

				self:_change_team_info(_opponents_party_data)
			end
		}
	},
	on_enter_opponent_team = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				local self = arg_18_3.self
				local _bottom_widgets = self._bottom_widgets
				local _team_portrait_frame_widgets = self._team_portrait_frame_widgets
				local _player_name_widgets = self._player_name_widgets
				local _team_insignia_widgets = self._team_insignia_widgets

				for i, v in ipairs(_bottom_widgets) do
					v.alpha_multiplier = 0
				end

				for i_2, v_2 in ipairs(_team_portrait_frame_widgets) do
					v_2.alpha_multiplier = 0
				end

				for i_3, v_3 in ipairs(_team_insignia_widgets) do
					v_3.alpha_multiplier = 0
				end

				for i_4, v_4 in ipairs(_player_name_widgets) do
					v_4.alpha_multiplier = 0
				end
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				-- function 19
				local easeOutCubic = math.easeOutCubic(arg_19_3)
				local self = arg_19_4.self
				local self_2 = arg_19_4.self
				local _bottom_widgets = self_2._bottom_widgets
				local _team_portrait_frame_widgets = self_2._team_portrait_frame_widgets
				local _top_widgets = self_2._top_widgets
				local _player_name_widgets = self_2._player_name_widgets
				local _team_insignia_widgets = self_2._team_insignia_widgets

				for i, v in ipairs(_bottom_widgets) do
					v.alpha_multiplier = easeOutCubic
				end

				for i_2, v_2 in ipairs(_team_portrait_frame_widgets) do
					v_2.alpha_multiplier = easeOutCubic
				end

				for i_3, v_3 in ipairs(_team_insignia_widgets) do
					v_3.alpha_multiplier = easeOutCubic
				end

				for i_4, v_4 in ipairs(_top_widgets) do
					v_4.alpha_multiplier = easeOutCubic
				end

				for i_5, v_5 in ipairs(_player_name_widgets) do
					v_5.alpha_multiplier = easeOutCubic
				end
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end
		},
		{
			name = "slide_up_bottom_widgets",
			start_progress = 0,
			end_progress = 0.8,
			init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end,
			update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				-- function 22
				local easeOutCubic = math.easeOutCubic(arg_22_3)
				local self = arg_22_4.self
				local _bottom_widgets = self._bottom_widgets
				local _team_portrait_frame_widgets = self._team_portrait_frame_widgets
				local _player_name_widgets = self._player_name_widgets
				local _team_insignia_widgets = self._team_insignia_widgets

				for i, v in ipairs(_bottom_widgets) do
					local num = -250 + 250 * easeOutCubic

					v.offset[2] = num
				end

				for i_2, v_2 in ipairs(_team_portrait_frame_widgets) do
					local num_2 = -200 + 200 * easeOutCubic

					v_2.offset[2] = num_2
				end

				for i_3, v_3 in ipairs(_team_insignia_widgets) do
					local num_3 = -200 + 200 * easeOutCubic

					v_3.offset[2] = num_3
				end

				for i_4, v_4 in ipairs(_player_name_widgets) do
					local num_4 = -270 + 50 * easeOutCubic

					v_4.offset[2] = num_4
				end
			end,
			on_complete = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				return
			end
		},
		{
			name = "slide_in_top_widgets",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				return
			end,
			update = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				-- function 25
				local easeOutCubic = math.easeOutCubic(arg_25_3)
				local ease_out_quad = math.ease_out_quad(arg_25_3)
				local self = arg_25_4.self
				local top_background_detail = self._widgets_by_name.top_background_detail
				local team_flag = self._widgets_by_name.team_flag
				local _ui_top_renderer = self._ui_top_renderer
				local num = 0 + -3840 * (1 - easeOutCubic)

				top_background_detail.offset[1] = num

				local num_2 = -480 + 480 * (1 - easeOutCubic)

				team_flag.offset[2] = num_2
			end,
			on_complete = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				return
			end
		}
	},
	team_transition_fade_out = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end,
			update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				-- function 28
				local easeOutCubic = math.easeOutCubic(arg_28_3)
				local _transition_widgets = arg_28_4.self._transition_widgets

				for i, v in ipairs(_transition_widgets) do
					v.alpha_multiplier = 1 - easeOutCubic
				end
			end,
			on_complete = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				arg_30_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				-- function 31
				local easeOutCubic = math.easeOutCubic(arg_31_3)

				arg_31_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				return
			end
		}
	}
}

return {
	scenegraph_definition = tbl_4,
	bottom_widgets_definitions = tbl_6,
	top_widgets_definitions = tbl_7,
	animation_definitions = tbl_16,
	transition_widget_definitions = tbl_14,
	create_player_name_career_text = create_player_name_career_text,
	view_settings = tbl_15
}
