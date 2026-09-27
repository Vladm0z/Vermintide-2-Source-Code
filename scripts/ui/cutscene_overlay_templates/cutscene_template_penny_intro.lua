-- chunkname: @scripts/ui/cutscene_overlay_templates/cutscene_template_penny_intro.lua

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
			text = "drachenfels_intro_video_1",
			start_timestamp = "00:02:30",
			fade_in_duration = 0.3,
			end_timestamp = "00:10:73",
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
			text = "drachenfels_intro_video_2",
			start_timestamp = "00:11:85",
			fade_in_duration = 0.3,
			end_timestamp = "00:20:09",
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
			text = "drachenfels_intro_video_3",
			start_timestamp = "00:22:79",
			fade_in_duration = 0.3,
			end_timestamp = "00:33:53",
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
			text = "drachenfels_intro_video_4",
			start_timestamp = "00:35:50",
			fade_in_duration = 0.3,
			end_timestamp = "00:36:89",
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
