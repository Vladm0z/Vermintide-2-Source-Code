-- chunkname: @scripts/ui/cutscene_overlay_templates/cutscene_template_shovel_intro.lua

local var_0_0 = require("scripts/ui/cutscene_overlay_templates/cutscene_utils")
local var_0_1 = 700
local var_0_2 = "sofia_necromancer"
local var_0_3 = DialogueSettings.speaker_color_lookup[var_0_2]
local var_0_4 = Localize("subtitle_name_sofia_fuegonasus_01")
local var_0_5 = string.format("{#color(%d,%d,%d, %%d)}[%s] {#reset()}", var_0_3[2], var_0_3[3], var_0_3[4], var_0_4)
local var_0_6 = "bright_wizard"
local var_0_7 = DialogueSettings.speaker_color_lookup[var_0_6]
local var_0_8 = Localize("subtitle_name_" .. var_0_6)
local var_0_9 = string.format("{#color(%d,%d,%d, %%d)}[%s] {#reset()}", var_0_7[2], var_0_7[3], var_0_7[4], var_0_8)
local var_0_10 = {
	template_1 = {
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = false,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			use_shadow = false,
			start_timestamp = "00:18:00",
			inject_alpha = true,
			fade_in_duration = 0.3,
			end_timestamp = "00:20:80",
			font_type = "hell_shark",
			text = var_0_5 .. Localize("shovel_intro_subtitle_01"),
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = true,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			text = "shovel_intro_subtitle_02",
			start_timestamp = "00:22:15",
			fade_in_duration = 0.3,
			end_timestamp = "00:24:00",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = true,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			text = "shovel_intro_subtitle_03",
			start_timestamp = "00:25:40",
			fade_in_duration = 0.3,
			end_timestamp = "00:26:90",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = true,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			text = "shovel_intro_subtitle_04",
			start_timestamp = "00:27:80",
			fade_in_duration = 0.3,
			end_timestamp = "00:30:20",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = true,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			text = "shovel_intro_subtitle_05",
			start_timestamp = "00:30:70",
			fade_in_duration = 0.3,
			end_timestamp = "00:34:30",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = false,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			inject_alpha = true,
			start_timestamp = "01:00:90",
			fade_in_duration = 0.3,
			end_timestamp = "01:02:90",
			font_type = "hell_shark",
			text = var_0_9 .. Localize("shovel_intro_subtitle_06"),
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = false,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			inject_alpha = true,
			start_timestamp = "01:18:80",
			fade_in_duration = 0.3,
			end_timestamp = "01:21:90",
			font_type = "hell_shark",
			text = var_0_5 .. Localize("shovel_intro_subtitle_07"),
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = false,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			inject_alpha = true,
			start_timestamp = "01:33:50",
			fade_in_duration = 0.3,
			end_timestamp = "01:35:40",
			font_type = "hell_shark",
			text = var_0_9 .. Localize("shovel_intro_subtitle_08"),
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = false,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			inject_alpha = true,
			start_timestamp = "01:35:70",
			fade_in_duration = 0.3,
			end_timestamp = "01:38:85",
			font_type = "hell_shark",
			text = var_0_5 .. Localize("shovel_intro_subtitle_09"),
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = false,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			inject_alpha = true,
			start_timestamp = "01:39:00",
			fade_in_duration = 0.3,
			end_timestamp = "01:39:85",
			font_type = "hell_shark",
			text = var_0_9 .. Localize("shovel_intro_subtitle_10"),
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = false,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			inject_alpha = true,
			start_timestamp = "01:48:50",
			fade_in_duration = 0.3,
			end_timestamp = "01:53:70",
			font_type = "hell_shark",
			text = var_0_9 .. Localize("shovel_intro_subtitle_11"),
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		},
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = true,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			text = "shovel_intro_subtitle_12",
			start_timestamp = "01:58:50",
			fade_in_duration = 0.3,
			end_timestamp = "02:03:70",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				var_0_1
			}
		}
	}
}

var_0_0.convert_string_timestamps_to_seconds(var_0_10)

return {
	templates = var_0_10
}
