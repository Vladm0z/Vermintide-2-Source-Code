-- chunkname: @scripts/ui/act_presentation/act_presentation_ui_definitions.lua

local var_0_0 = {
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
local var_0_1 = {
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
local var_0_2 = {
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
local var_0_3 = {
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
local var_0_4 = {
	level = UIWidgets.create_level_widget("level"),
	act_title = UIWidgets.create_simple_text("ACT IV", "act_title", nil, nil, var_0_1),
	level_title = UIWidgets.create_simple_text("Catacombs", "level_title", nil, nil, var_0_2),
	title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider")
}
local var_0_5 = {
	level = UIWidgets.create_expedition_widget_func("level", nil, DeusJourneySettings.journey_cave, "journey_cave", {
		width = 800,
		spacing_x = 40
	}, 1.2),
	act_title = UIWidgets.create_simple_text("ACT IV", "act_title", nil, nil, var_0_1),
	level_title = UIWidgets.create_simple_text("Catacombs", "level_title", nil, nil, var_0_2),
	title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider")
}
local var_0_6 = {
	enter = {
		{
			name = "frame_change",
			start_progress = 0,
			end_progress = 0,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				return
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = arg_2_4.difficulty_index

				arg_2_2.level.content.frame = "map_frame_0" .. var_2_0
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		},
		{
			name = "entry",
			start_progress = 2,
			end_progress = 2.5,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 0
				arg_4_3.played_entry_sound = false
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				if not arg_5_4.played_entry_sound then
					arg_5_4.played_entry_sound = true

					WwiseWorld.trigger_event(arg_5_4.wwise_world, "play_gui_skullz_show_plate")
				end

				local var_5_0 = math.easeInCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = var_5_0

				local var_5_1 = math.easeCubic(1 - arg_5_3)
				local var_5_2 = math.catmullrom(var_5_1, 1.8, 0, 1, -1)
				local var_5_3 = arg_5_2.level.style
				local var_5_4 = 3
				local var_5_5 = var_5_3.icon.texture_size

				var_5_5[1] = 168 + 168 * var_5_4 * var_5_2
				var_5_5[2] = 168 + 168 * var_5_4 * var_5_2

				local var_5_6 = var_5_3.frame.texture_size

				var_5_6[1] = 180 + 180 * var_5_4 * var_5_2
				var_5_6[2] = 180 + 180 * var_5_4 * var_5_2

				local var_5_7 = var_5_3.glass.texture_size

				var_5_7[1] = 216 + 216 * var_5_4 * var_5_2
				var_5_7[2] = 216 + 216 * var_5_4 * var_5_2
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		},
		{
			name = "text",
			start_progress = 2.4,
			end_progress = 2.6,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				local var_7_0 = 0
				local var_7_1 = arg_7_2.level_title.style.text
				local var_7_2 = arg_7_2.level_title.style.text_shadow
				local var_7_3 = arg_7_2.act_title.style.text
				local var_7_4 = arg_7_2.act_title.style.text_shadow
				local var_7_5 = arg_7_2.title_divider.style.texture_id

				var_7_1.text_color[1] = var_7_0
				var_7_2.text_color[1] = var_7_0
				var_7_3.text_color[1] = var_7_0
				var_7_4.text_color[1] = var_7_0
				var_7_5.color[1] = var_7_0
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeCubic(arg_8_3)
				local var_8_1 = math.ease_in_exp(1 - arg_8_3)
				local var_8_2 = math.easeCubic(1 - arg_8_3)
				local var_8_3 = math.catmullrom(var_8_2, 1.8, 0, 1, -1)
				local var_8_4 = 255 * var_8_0
				local var_8_5 = arg_8_2.level_title.style.text
				local var_8_6 = arg_8_2.level_title.style.text_shadow
				local var_8_7 = arg_8_2.act_title.style.text
				local var_8_8 = arg_8_2.act_title.style.text_shadow
				local var_8_9 = arg_8_2.title_divider.style.texture_id

				var_8_5.text_color[1] = var_8_4
				var_8_6.text_color[1] = var_8_4
				var_8_7.text_color[1] = var_8_4
				var_8_8.text_color[1] = var_8_4
				var_8_9.color[1] = var_8_4
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5.7,
			end_progress = 6.2,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = math.easeInCubic(arg_11_3)

				arg_11_4.render_settings.alpha_multiplier = 1 - var_11_0
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		}
	},
	enter_first_time = {
		{
			name = "entry",
			start_progress = 2,
			end_progress = 2.5,
			init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				arg_13_3.render_settings.alpha_multiplier = 0
				arg_13_3.played_entry_sound = false
			end,
			update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				if not arg_14_4.played_entry_sound then
					arg_14_4.played_entry_sound = true

					WwiseWorld.trigger_event(arg_14_4.wwise_world, "play_gui_skullz_show_plate")
				end

				local var_14_0 = math.easeInCubic(arg_14_3)

				arg_14_4.render_settings.alpha_multiplier = var_14_0

				local var_14_1 = math.easeCubic(1 - arg_14_3)
				local var_14_2 = math.catmullrom(var_14_1, 1.8, 0, 1, -1)
				local var_14_3 = arg_14_2.level.style
				local var_14_4 = 3
				local var_14_5 = var_14_3.icon.texture_size

				var_14_5[1] = 168 + 168 * var_14_4 * var_14_2
				var_14_5[2] = 168 + 168 * var_14_4 * var_14_2

				local var_14_6 = var_14_3.frame.texture_size

				var_14_6[1] = 180 + 180 * var_14_4 * var_14_2
				var_14_6[2] = 180 + 180 * var_14_4 * var_14_2

				local var_14_7 = var_14_3.glass.texture_size

				var_14_7[1] = 216 + 216 * var_14_4 * var_14_2
				var_14_7[2] = 216 + 216 * var_14_4 * var_14_2
			end,
			on_complete = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		},
		{
			name = "text",
			start_progress = 2.4,
			end_progress = 2.8,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				local var_16_0 = 0
				local var_16_1 = arg_16_2.level_title.style.text
				local var_16_2 = arg_16_2.level_title.style.text_shadow
				local var_16_3 = arg_16_2.act_title.style.text
				local var_16_4 = arg_16_2.act_title.style.text_shadow
				local var_16_5 = arg_16_2.title_divider.style.texture_id

				var_16_1.text_color[1] = var_16_0
				var_16_2.text_color[1] = var_16_0
				var_16_3.text_color[1] = var_16_0
				var_16_4.text_color[1] = var_16_0
				var_16_5.color[1] = var_16_0
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = math.easeCubic(arg_17_3)
				local var_17_1 = math.ease_in_exp(1 - arg_17_3)
				local var_17_2 = math.easeCubic(1 - arg_17_3)
				local var_17_3 = math.catmullrom(var_17_2, 1.8, 0, 1, -1)
				local var_17_4 = 255 * var_17_0
				local var_17_5 = arg_17_2.level_title.style.text
				local var_17_6 = arg_17_2.level_title.style.text_shadow
				local var_17_7 = arg_17_2.act_title.style.text
				local var_17_8 = arg_17_2.act_title.style.text_shadow
				local var_17_9 = arg_17_2.title_divider.style.texture_id

				var_17_5.text_color[1] = var_17_4
				var_17_6.text_color[1] = var_17_4
				var_17_7.text_color[1] = var_17_4
				var_17_8.text_color[1] = var_17_4
				var_17_9.color[1] = var_17_4
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		},
		{
			name = "glow",
			start_progress = 2.5,
			end_progress = 4.5,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				local var_19_0 = 0

				arg_19_2.level.style.frame_glow.color[1] = var_19_0
				arg_19_3.played_skull_sound = false
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				if not arg_20_4.played_skull_sound then
					arg_20_4.played_skull_sound = true

					local var_20_0 = arg_20_4.difficulty_index

					WwiseWorld.trigger_event(arg_20_4.wwise_world, "play_gui_skullz_tier_0" .. var_20_0)
				end

				local var_20_1 = math.easeOutCubic(arg_20_3)
				local var_20_2 = 255 * math.ease_pulse(var_20_1)

				arg_20_2.level.style.frame_glow.color[1] = var_20_2
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end
		},
		{
			name = "frame_change",
			start_progress = 3.2,
			end_progress = 3.2,
			init = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end,
			update = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				local var_23_0 = arg_23_4.difficulty_index

				arg_23_2.level.content.frame = "map_frame_0" .. var_23_0
			end,
			on_complete = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5.7,
			end_progress = 6.2,
			init = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end,
			update = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				local var_26_0 = math.easeInCubic(arg_26_3)

				arg_26_4.render_settings.alpha_multiplier = 1 - var_26_0
			end,
			on_complete = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end
		}
	}
}
local var_0_7 = {
	enter = {
		{
			name = "entry",
			start_progress = 2,
			end_progress = 2.5,
			init = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				arg_28_3.render_settings.alpha_multiplier = 0
				arg_28_3.played_entry_sound = false
			end,
			update = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				if not arg_29_4.played_entry_sound then
					arg_29_4.played_entry_sound = true

					WwiseWorld.trigger_event(arg_29_4.wwise_world, "play_gui_skullz_show_plate")
				end

				local var_29_0 = math.easeInCubic(arg_29_3)

				arg_29_4.render_settings.alpha_multiplier = var_29_0

				local var_29_1 = math.easeCubic(1 - arg_29_3)
				local var_29_2 = math.catmullrom(var_29_1, 1.8, 0, 1, -1)
				local var_29_3 = arg_29_2.level.style
				local var_29_4 = 3
				local var_29_5 = var_29_3.level_icon.texture_size

				var_29_5[1] = 180 + 180 * var_29_4 * var_29_2
				var_29_5[2] = 180 + 180 * var_29_4 * var_29_2

				local var_29_6 = var_29_3.level_icon_frame.texture_size

				var_29_6[1] = 200 + 200 * var_29_4 * var_29_2
				var_29_6[2] = 200 + 200 * var_29_4 * var_29_2

				local var_29_7 = var_29_3.level_icon_mask.texture_size

				var_29_7[1] = 110 + 110 * var_29_4 * var_29_2
				var_29_7[2] = 110 + 110 * var_29_4 * var_29_2

				local var_29_8 = var_29_3.theme_icon.texture_size

				var_29_8[1] = 40 + 40 * var_29_4 * var_29_2
				var_29_8[2] = 40 + 40 * var_29_4 * var_29_2
			end,
			on_complete = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end
		},
		{
			name = "text",
			start_progress = 2.4,
			end_progress = 2.6,
			init = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				local var_31_0 = 0
				local var_31_1 = arg_31_2.level_title.style.text
				local var_31_2 = arg_31_2.level_title.style.text_shadow
				local var_31_3 = arg_31_2.title_divider.style.texture_id

				var_31_1.text_color[1] = var_31_0
				var_31_2.text_color[1] = var_31_0
				var_31_3.color[1] = var_31_0
			end,
			update = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				local var_32_0 = 255 * math.easeCubic(arg_32_3)
				local var_32_1 = arg_32_2.level_title.style.text
				local var_32_2 = arg_32_2.level_title.style.text_shadow
				local var_32_3 = arg_32_2.title_divider.style.texture_id

				var_32_1.text_color[1] = var_32_0
				var_32_2.text_color[1] = var_32_0
				var_32_3.color[1] = var_32_0
			end,
			on_complete = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5.7,
			end_progress = 6.2,
			init = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end,
			update = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				local var_35_0 = math.easeInCubic(arg_35_3)

				arg_35_4.render_settings.alpha_multiplier = 1 - var_35_0
			end,
			on_complete = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				return
			end
		}
	},
	enter_first_time = {
		{
			name = "entry",
			start_progress = 2,
			end_progress = 2.5,
			init = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				arg_37_3.render_settings.alpha_multiplier = 0
				arg_37_3.played_entry_sound = false
			end,
			update = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				if not arg_38_4.played_entry_sound then
					arg_38_4.played_entry_sound = true

					WwiseWorld.trigger_event(arg_38_4.wwise_world, "play_gui_skullz_show_plate")
				end

				local var_38_0 = math.easeInCubic(arg_38_3)

				arg_38_4.render_settings.alpha_multiplier = var_38_0

				local var_38_1 = math.easeCubic(1 - arg_38_3)
				local var_38_2 = math.catmullrom(var_38_1, 1.8, 0, 1, -1)
				local var_38_3 = arg_38_2.Enlevel.style
				local var_38_4 = 3
				local var_38_5 = var_38_3.level_icon.texture_size

				var_38_5[1] = 180 + 180 * var_38_4 * var_38_2
				var_38_5[2] = 180 + 180 * var_38_4 * var_38_2

				local var_38_6 = var_38_3.level_icon_frame.texture_size

				var_38_6[1] = 200 + 200 * var_38_4 * var_38_2
				var_38_6[2] = 200 + 200 * var_38_4 * var_38_2

				local var_38_7 = var_38_3.level_icon_mask.texture_size

				var_38_7[1] = 110 + 110 * var_38_4 * var_38_2
				var_38_7[2] = 110 + 110 * var_38_4 * var_38_2

				local var_38_8 = var_38_3.theme_icon.texture_size

				var_38_8[1] = 40 + 40 * var_38_4 * var_38_2
				var_38_8[2] = 40 + 40 * var_38_4 * var_38_2
			end,
			on_complete = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				return
			end
		},
		{
			name = "text",
			start_progress = 2.4,
			end_progress = 2.8,
			init = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				local var_40_0 = 0
				local var_40_1 = arg_40_2.level_title.style.text
				local var_40_2 = arg_40_2.level_title.style.text_shadow
				local var_40_3 = arg_40_2.title_divider.style.texture_id

				var_40_1.text_color[1] = var_40_0
				var_40_2.text_color[1] = var_40_0
				var_40_3.color[1] = var_40_0
			end,
			update = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				local var_41_0 = 255 * math.easeCubic(arg_41_3)
				local var_41_1 = arg_41_2.level_title.style.text
				local var_41_2 = arg_41_2.level_title.style.text_shadow
				local var_41_3 = arg_41_2.title_divider.style.texture_id

				var_41_1.text_color[1] = var_41_0
				var_41_2.text_color[1] = var_41_0
				var_41_3.color[1] = var_41_0
			end,
			on_complete = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				return
			end
		},
		{
			name = "glow",
			start_progress = 2.5,
			end_progress = 4.5,
			init = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				local var_43_0 = 0

				arg_43_2.level.style.icon_glow.color[1] = var_43_0
				arg_43_3.played_skull_sound = false
			end,
			update = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				if not arg_44_4.played_skull_sound then
					arg_44_4.played_skull_sound = true

					local var_44_0 = arg_44_4.difficulty_index

					WwiseWorld.trigger_event(arg_44_4.wwise_world, "play_gui_skullz_tier_0" .. var_44_0)
				end

				local var_44_1 = math.easeOutCubic(arg_44_3)
				local var_44_2 = 255 * math.ease_pulse(var_44_1)

				arg_44_2.level.style.icon_glow.color[1] = var_44_2
			end,
			on_complete = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5.7,
			end_progress = 6.2,
			init = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				return
			end,
			update = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				local var_47_0 = math.easeInCubic(arg_47_3)

				arg_47_4.render_settings.alpha_multiplier = 1 - var_47_0
			end,
			on_complete = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				return
			end
		}
	}
}

return {
	animations = var_0_6,
	scenegraph_definition = var_0_0,
	widgets = var_0_4,
	deus_widgets = var_0_5,
	deus_animations = var_0_7
}
