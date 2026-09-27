-- chunkname: @scripts/ui/hud_ui/unit_frames_ui_utils.lua

local UnitFramesUiUtils = UnitFramesUiUtils

UnitFramesUiUtils = UnitFramesUiUtils or {}
UnitFramesUiUtils = UnitFramesUiUtils

local num = 24
local num_2 = 16

UnitFramesUiUtils.create_damage_widget = function (arg_1_0, arg_1_1)
	-- function 1
	local tbl = {}
	local flag = arg_1_0 == "team"
	local tbl_2

	if not flag then
		tbl_2 = {
			100,
			50,
			0
		}

		if not tbl_2 then
			-- Nothing
		end
	end

	tbl_2 = {
		-15,
		40,
		0
	}

	::label_1_0::

	local num_3 = 24
	local num_4 = num_3 + 16

	for i = 1, arg_1_1 do
		local tbl_3

		if not flag then
			tbl_3 = {
				num_4,
				20 - i * 20,
				0
			}

			if not tbl_3 then
				-- Nothing
			end
		end

		tbl_3 = {
			num_4,
			30 + i * 20,
			0
		}

		::label_1_1::

		local tbl_4 = {
			-num_3 - 4,
			tbl_3[2] - num_3 * 0.45
		}
		local tbl_5 = {
			scenegraph_id = "portrait_pivot",
			element = {
				passes = {
					{
						style_id = "text",
						pass_type = "text",
						text_id = "text"
					},
					{
						style_id = "text_total_sum",
						pass_type = "text",
						text_id = "text_total_sum"
					},
					{
						style_id = "text_total_sum_decimal_part",
						pass_type = "text",
						text_id = "text_total_sum_decimal_part"
					},
					{
						style_id = "text_last_dmg",
						pass_type = "text",
						text_id = "text_last_dmg"
					},
					{
						style_id = "text_last_dmg_2",
						pass_type = "text",
						text_id = "text_last_dmg_2"
					},
					{
						style_id = "text_last_dmg_3",
						pass_type = "text",
						text_id = "text_last_dmg_3"
					},
					{
						style_id = "text_last_dmg_4",
						pass_type = "text",
						text_id = "text_last_dmg_4"
					},
					{
						style_id = "text_last_dmg_5",
						pass_type = "text",
						text_id = "text_last_dmg_5"
					},
					{
						style_id = "text_last_dmg_6",
						pass_type = "text",
						text_id = "text_last_dmg_6"
					},
					{
						style_id = "text_last_dmg_7",
						pass_type = "text",
						text_id = "text_last_dmg_7"
					},
					{
						style_id = "text_last_dmg_8",
						pass_type = "text",
						text_id = "text_last_dmg_8"
					},
					{
						style_id = "text_last_dmg_9",
						pass_type = "text",
						text_id = "text_last_dmg_9"
					},
					{
						style_id = "text_last_dmg_10",
						pass_type = "text",
						text_id = "text_last_dmg_10"
					},
					{
						pass_type = "texture",
						style_id = "damage_icon",
						texture_id = "damage_icon"
					}
				}
			},
			content = {
				text_last_dmg_7 = "",
				text_last_dmg_2 = "",
				text_last_dmg = "",
				text_total_sum = "",
				text_last_dmg_5 = "",
				text_last_dmg_8 = "",
				text_last_dmg_4 = "",
				text_last_dmg_10 = "",
				text_last_dmg_3 = "",
				text = "",
				text_last_dmg_6 = "",
				text_last_dmg_9 = "",
				damage_icon = "icon_damage",
				visible = false,
				text_total_sum_decimal_part = ""
			},
			style = {
				text = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = num,
					text_color = Colors.get_table("gray"),
					offset = tbl_3
				},
				text_total_sum = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = num,
					text_color = Colors.get_table("green"),
					offset = tbl_3
				},
				text_total_sum_decimal_part = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "left",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("white"),
					offset = tbl_3
				},
				text_last_dmg = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				text_last_dmg_2 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				text_last_dmg_3 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				text_last_dmg_4 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				text_last_dmg_5 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				text_last_dmg_6 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				text_last_dmg_7 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				text_last_dmg_8 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				text_last_dmg_9 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				text_last_dmg_10 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = num_2,
					text_color = Colors.get_table("yellow"),
					offset = tbl_3
				},
				damage_icon = {
					size = {
						num_3,
						num_3
					},
					offset = tbl_4,
					color = {
						255,
						199,
						194,
						194
					}
				}
			},
			offset = tbl_2
		}

		tbl[#tbl + i] = tbl_5
	end

	return tbl
end
