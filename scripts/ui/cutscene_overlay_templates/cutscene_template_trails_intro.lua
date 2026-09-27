-- chunkname: @scripts/ui/cutscene_overlay_templates/cutscene_template_trails_intro.lua

local scripts_ui_cutscene_overlay_templates_cutscene_utils = require("scripts/ui/cutscene_overlay_templates/cutscene_utils")
local num = 700
local tbl = {
	template_1 = {
		{
			fade_out_duration = 0.3,
			font_size = 30,
			localize = true,
			vertical_alignment = "bottom",
			word_wrap = true,
			font_upper_case = false,
			horizontal_alignment = "center",
			text = "trails_intro_subtitle_01",
			start_timestamp = "00:06:00",
			fade_in_duration = 0.3,
			end_timestamp = "00:11:00",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				num
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
			text = "trails_intro_subtitle_02",
			start_timestamp = "00:14:00",
			fade_in_duration = 0.3,
			end_timestamp = "00:20:00",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				num
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
			text = "trails_intro_subtitle_03",
			start_timestamp = "00:20:00",
			fade_in_duration = 0.3,
			end_timestamp = "00:25:00",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				num
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
			text = "trails_intro_subtitle_04",
			start_timestamp = "00:28:00",
			fade_in_duration = 0.3,
			end_timestamp = "00:30:00",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				num
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
			text = "trails_intro_subtitle_05",
			start_timestamp = "00:30:00",
			fade_in_duration = 0.3,
			end_timestamp = "00:35:00",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				num
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
			text = "trails_intro_subtitle_06",
			start_timestamp = "00:41:00",
			fade_in_duration = 0.3,
			end_timestamp = "00:43:00",
			font_type = "hell_shark",
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				20,
				num
			}
		}
	}
}

scripts_ui_cutscene_overlay_templates_cutscene_utils.convert_string_timestamps_to_seconds(tbl)

return {
	templates = tbl
}
