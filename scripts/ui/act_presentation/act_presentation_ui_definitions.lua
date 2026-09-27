-- chunkname: @scripts/ui/act_presentation/act_presentation_ui_definitions.lua

local tbl = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.end_screen_banner
		}
	},
	level = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			-200,
			1
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "level",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-120,
			1
		}
	},
	level_title = {
		vertical_alignment = "center",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			1200,
			50
		},
		position = {
			0,
			32,
			1
		}
	},
	difficulty_title = {
		vertical_alignment = "center",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			1200,
			50
		},
		position = {
			0,
			32,
			1
		}
	},
	act_title = {
		vertical_alignment = "center",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			1200,
			50
		},
		position = {
			0,
			-38,
			1
		}
	}
}
local tbl_2 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		1
	}
}
local tbl_3 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_4 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
	level = UIWidgets.create_level_widget("level"),
	act_title = UIWidgets.create_simple_text("ACT IV", "act_title", nil, nil, tbl_2),
	level_title = UIWidgets.create_simple_text("Catacombs", "level_title", nil, nil, tbl_3),
	title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider")
}
local tbl_6 = {
	level = UIWidgets.create_expedition_widget_func("level", nil, DeusJourneySettings.journey_cave, "journey_cave", {
		width = 800,
		spacing_x = 40
	}, 1.2),
	act_title = UIWidgets.create_simple_text("ACT IV", "act_title", nil, nil, tbl_2),
	level_title = UIWidgets.create_simple_text("Catacombs", "level_title", nil, nil, tbl_3),
	title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider")
}
local tbl_7 = {
	enter = {
		{
			name = "frame_change",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				return
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local difficulty_index = arg_2_4.difficulty_index

				arg_2_2.level.content.frame = "map_frame_0" .. difficulty_index
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		},
		{
			name = "entry",
			start_progress = 2,
			end_progress = 2.5,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 0
				arg_4_3.played_entry_sound = false
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				if not arg_5_4.played_entry_sound then
					arg_5_4.played_entry_sound = true

					WwiseWorld.trigger_event(arg_5_4.wwise_world, "play_gui_skullz_show_plate")
				end

				local easeInCubic = math.easeInCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = easeInCubic

				local easeCubic = math.easeCubic(1 - arg_5_3)
				local catmullrom = math.catmullrom(easeCubic, 1.8, 0, 1, -1)
				local style = arg_5_2.level.style
				local num = 3
				local texture_size = style.icon.texture_size

				texture_size[1] = 168 + 168 * num * catmullrom
				texture_size[2] = 168 + 168 * num * catmullrom

				local texture_size_2 = style.frame.texture_size

				texture_size_2[1] = 180 + 180 * num * catmullrom
				texture_size_2[2] = 180 + 180 * num * catmullrom

				local texture_size_3 = style.glass.texture_size

				texture_size_3[1] = 216 + 216 * num * catmullrom
				texture_size_3[2] = 216 + 216 * num * catmullrom
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		},
		{
			name = "text",
			start_progress = 2.4,
			end_progress = 2.6,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				local num = 0
				local text = arg_7_2.level_title.style.text
				local text_shadow = arg_7_2.level_title.style.text_shadow
				local text_2 = arg_7_2.act_title.style.text
				local text_shadow_2 = arg_7_2.act_title.style.text_shadow
				local texture_id = arg_7_2.title_divider.style.texture_id

				text.text_color[1] = num
				text_shadow.text_color[1] = num
				text_2.text_color[1] = num
				text_shadow_2.text_color[1] = num
				texture_id.color[1] = num
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeCubic = math.easeCubic(arg_8_3)
				local ease_in_exp = math.ease_in_exp(1 - arg_8_3)
				local easeCubic_2 = math.easeCubic(1 - arg_8_3)
				local catmullrom = math.catmullrom(easeCubic_2, 1.8, 0, 1, -1)
				local num = 255 * easeCubic
				local text = arg_8_2.level_title.style.text
				local text_shadow = arg_8_2.level_title.style.text_shadow
				local text_2 = arg_8_2.act_title.style.text
				local text_shadow_2 = arg_8_2.act_title.style.text_shadow
				local texture_id = arg_8_2.title_divider.style.texture_id

				text.text_color[1] = num
				text_shadow.text_color[1] = num
				text_2.text_color[1] = num
				text_shadow_2.text_color[1] = num
				texture_id.color[1] = num
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5.7,
			end_progress = 6.2,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local easeInCubic = math.easeInCubic(arg_11_3)

				arg_11_4.render_settings.alpha_multiplier = 1 - easeInCubic
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		}
	},
	enter_first_time = {
		{
			name = "entry",
			start_progress = 2,
			end_progress = 2.5,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				arg_13_3.render_settings.alpha_multiplier = 0
				arg_13_3.played_entry_sound = false
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				if not arg_14_4.played_entry_sound then
					arg_14_4.played_entry_sound = true

					WwiseWorld.trigger_event(arg_14_4.wwise_world, "play_gui_skullz_show_plate")
				end

				local easeInCubic = math.easeInCubic(arg_14_3)

				arg_14_4.render_settings.alpha_multiplier = easeInCubic

				local easeCubic = math.easeCubic(1 - arg_14_3)
				local catmullrom = math.catmullrom(easeCubic, 1.8, 0, 1, -1)
				local style = arg_14_2.level.style
				local num = 3
				local texture_size = style.icon.texture_size

				texture_size[1] = 168 + 168 * num * catmullrom
				texture_size[2] = 168 + 168 * num * catmullrom

				local texture_size_2 = style.frame.texture_size

				texture_size_2[1] = 180 + 180 * num * catmullrom
				texture_size_2[2] = 180 + 180 * num * catmullrom

				local texture_size_3 = style.glass.texture_size

				texture_size_3[1] = 216 + 216 * num * catmullrom
				texture_size_3[2] = 216 + 216 * num * catmullrom
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		},
		{
			name = "text",
			start_progress = 2.4,
			end_progress = 2.8,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				local num = 0
				local text = arg_16_2.level_title.style.text
				local text_shadow = arg_16_2.level_title.style.text_shadow
				local text_2 = arg_16_2.act_title.style.text
				local text_shadow_2 = arg_16_2.act_title.style.text_shadow
				local texture_id = arg_16_2.title_divider.style.texture_id

				text.text_color[1] = num
				text_shadow.text_color[1] = num
				text_2.text_color[1] = num
				text_shadow_2.text_color[1] = num
				texture_id.color[1] = num
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local easeCubic = math.easeCubic(arg_17_3)
				local ease_in_exp = math.ease_in_exp(1 - arg_17_3)
				local easeCubic_2 = math.easeCubic(1 - arg_17_3)
				local catmullrom = math.catmullrom(easeCubic_2, 1.8, 0, 1, -1)
				local num = 255 * easeCubic
				local text = arg_17_2.level_title.style.text
				local text_shadow = arg_17_2.level_title.style.text_shadow
				local text_2 = arg_17_2.act_title.style.text
				local text_shadow_2 = arg_17_2.act_title.style.text_shadow
				local texture_id = arg_17_2.title_divider.style.texture_id

				text.text_color[1] = num
				text_shadow.text_color[1] = num
				text_2.text_color[1] = num
				text_shadow_2.text_color[1] = num
				texture_id.color[1] = num
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end
		},
		{
			name = "glow",
			start_progress = 2.5,
			end_progress = 4.5,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				local num = 0

				arg_19_2.level.style.frame_glow.color[1] = num
				arg_19_3.played_skull_sound = false
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				if not arg_20_4.played_skull_sound then
					arg_20_4.played_skull_sound = true

					local difficulty_index = arg_20_4.difficulty_index

					WwiseWorld.trigger_event(arg_20_4.wwise_world, "play_gui_skullz_tier_0" .. difficulty_index)
				end

				local easeOutCubic = math.easeOutCubic(arg_20_3)
				local num = 255 * math.ease_pulse(easeOutCubic)

				arg_20_2.level.style.frame_glow.color[1] = num
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end
		},
		{
			name = "frame_change",
			start_progress = 3.2,
			end_progress = 3.2,
			init = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				return
			end,
			update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				-- function 23
				local difficulty_index = arg_23_4.difficulty_index

				arg_23_2.level.content.frame = "map_frame_0" .. difficulty_index
			end,
			on_complete = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5.7,
			end_progress = 6.2,
			init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				return
			end,
			update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				-- function 26
				local easeInCubic = math.easeInCubic(arg_26_3)

				arg_26_4.render_settings.alpha_multiplier = 1 - easeInCubic
			end,
			on_complete = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end
		}
	}
}
local tbl_8 = {
	enter = {
		{
			name = "entry",
			start_progress = 2,
			end_progress = 2.5,
			init = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				arg_28_3.render_settings.alpha_multiplier = 0
				arg_28_3.played_entry_sound = false
			end,
			update = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				-- function 29
				if not arg_29_4.played_entry_sound then
					arg_29_4.played_entry_sound = true

					WwiseWorld.trigger_event(arg_29_4.wwise_world, "play_gui_skullz_show_plate")
				end

				local easeInCubic = math.easeInCubic(arg_29_3)

				arg_29_4.render_settings.alpha_multiplier = easeInCubic

				local easeCubic = math.easeCubic(1 - arg_29_3)
				local catmullrom = math.catmullrom(easeCubic, 1.8, 0, 1, -1)
				local style = arg_29_2.level.style
				local num = 3
				local texture_size = style.level_icon.texture_size

				texture_size[1] = 180 + 180 * num * catmullrom
				texture_size[2] = 180 + 180 * num * catmullrom

				local texture_size_2 = style.level_icon_frame.texture_size

				texture_size_2[1] = 200 + 200 * num * catmullrom
				texture_size_2[2] = 200 + 200 * num * catmullrom

				local texture_size_3 = style.level_icon_mask.texture_size

				texture_size_3[1] = 110 + 110 * num * catmullrom
				texture_size_3[2] = 110 + 110 * num * catmullrom

				local texture_size_4 = style.theme_icon.texture_size

				texture_size_4[1] = 40 + 40 * num * catmullrom
				texture_size_4[2] = 40 + 40 * num * catmullrom
			end,
			on_complete = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end
		},
		{
			name = "text",
			start_progress = 2.4,
			end_progress = 2.6,
			init = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				local num = 0
				local text = arg_31_2.level_title.style.text
				local text_shadow = arg_31_2.level_title.style.text_shadow
				local texture_id = arg_31_2.title_divider.style.texture_id

				text.text_color[1] = num
				text_shadow.text_color[1] = num
				texture_id.color[1] = num
			end,
			update = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				-- function 32
				local num = 255 * math.easeCubic(arg_32_3)
				local text = arg_32_2.level_title.style.text
				local text_shadow = arg_32_2.level_title.style.text_shadow
				local texture_id = arg_32_2.title_divider.style.texture_id

				text.text_color[1] = num
				text_shadow.text_color[1] = num
				texture_id.color[1] = num
			end,
			on_complete = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5.7,
			end_progress = 6.2,
			init = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end,
			update = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				-- function 35
				local easeInCubic = math.easeInCubic(arg_35_3)

				arg_35_4.render_settings.alpha_multiplier = 1 - easeInCubic
			end,
			on_complete = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				return
			end
		}
	},
	enter_first_time = {
		{
			name = "entry",
			start_progress = 2,
			end_progress = 2.5,
			init = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				arg_37_3.render_settings.alpha_multiplier = 0
				arg_37_3.played_entry_sound = false
			end,
			update = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				-- function 38
				if not arg_38_4.played_entry_sound then
					arg_38_4.played_entry_sound = true

					WwiseWorld.trigger_event(arg_38_4.wwise_world, "play_gui_skullz_show_plate")
				end

				local easeInCubic = math.easeInCubic(arg_38_3)

				arg_38_4.render_settings.alpha_multiplier = easeInCubic

				local easeCubic = math.easeCubic(1 - arg_38_3)
				local catmullrom = math.catmullrom(easeCubic, 1.8, 0, 1, -1)
				local style = arg_38_2.Enlevel.style
				local num = 3
				local texture_size = style.level_icon.texture_size

				texture_size[1] = 180 + 180 * num * catmullrom
				texture_size[2] = 180 + 180 * num * catmullrom

				local texture_size_2 = style.level_icon_frame.texture_size

				texture_size_2[1] = 200 + 200 * num * catmullrom
				texture_size_2[2] = 200 + 200 * num * catmullrom

				local texture_size_3 = style.level_icon_mask.texture_size

				texture_size_3[1] = 110 + 110 * num * catmullrom
				texture_size_3[2] = 110 + 110 * num * catmullrom

				local texture_size_4 = style.theme_icon.texture_size

				texture_size_4[1] = 40 + 40 * num * catmullrom
				texture_size_4[2] = 40 + 40 * num * catmullrom
			end,
			on_complete = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				-- function 39
				return
			end
		},
		{
			name = "text",
			start_progress = 2.4,
			end_progress = 2.8,
			init = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				local num = 0
				local text = arg_40_2.level_title.style.text
				local text_shadow = arg_40_2.level_title.style.text_shadow
				local texture_id = arg_40_2.title_divider.style.texture_id

				text.text_color[1] = num
				text_shadow.text_color[1] = num
				texture_id.color[1] = num
			end,
			update = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				-- function 41
				local num = 255 * math.easeCubic(arg_41_3)
				local text = arg_41_2.level_title.style.text
				local text_shadow = arg_41_2.level_title.style.text_shadow
				local texture_id = arg_41_2.title_divider.style.texture_id

				text.text_color[1] = num
				text_shadow.text_color[1] = num
				texture_id.color[1] = num
			end,
			on_complete = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
				return
			end
		},
		{
			name = "glow",
			start_progress = 2.5,
			end_progress = 4.5,
			init = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
				local num = 0

				arg_43_2.level.style.icon_glow.color[1] = num
				arg_43_3.played_skull_sound = false
			end,
			update = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				-- function 44
				if not arg_44_4.played_skull_sound then
					arg_44_4.played_skull_sound = true

					local difficulty_index = arg_44_4.difficulty_index

					WwiseWorld.trigger_event(arg_44_4.wwise_world, "play_gui_skullz_tier_0" .. difficulty_index)
				end

				local easeOutCubic = math.easeOutCubic(arg_44_3)
				local num = 255 * math.ease_pulse(easeOutCubic)

				arg_44_2.level.style.icon_glow.color[1] = num
			end,
			on_complete = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5.7,
			end_progress = 6.2,
			init = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				-- function 46
				return
			end,
			update = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				-- function 47
				local easeInCubic = math.easeInCubic(arg_47_3)

				arg_47_4.render_settings.alpha_multiplier = 1 - easeInCubic
			end,
			on_complete = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				-- function 48
				return
			end
		}
	}
}

return {
	animations = tbl_7,
	scenegraph_definition = tbl,
	widgets = tbl_5,
	deus_widgets = tbl_6,
	deus_animations = tbl_8
}
