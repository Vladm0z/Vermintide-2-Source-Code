-- chunkname: @scripts/ui/hud_ui/unit_frames_ui_utils.lua

UnitFramesUiUtils = UnitFramesUiUtils or {}

local var_0_0 = 24
local var_0_1 = 16

function UnitFramesUiUtils.create_damage_widget(arg_1_0, arg_1_1)
	local var_1_0 = {}
	local var_1_1 = arg_1_0 == "team"
	local var_1_2 = var_1_1 and {
		100,
		50,
		0
	} or {
		-15,
		40,
		0
	}
	local var_1_3 = 24
	local var_1_4 = var_1_3 + 16

	for iter_1_0 = 1, arg_1_1 do
		local var_1_5 = var_1_1 and {
			var_1_4,
			20 - iter_1_0 * 20,
			0
		} or {
			var_1_4,
			30 + iter_1_0 * 20,
			0
		}
		local var_1_6 = {
			-var_1_3 - 4,
			var_1_5[2] - var_1_3 * 0.45
		}
		local var_1_7 = {
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
					font_size = var_0_0,
					text_color = Colors.get_table("gray"),
					offset = var_1_5
				},
				text_total_sum = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = var_0_0,
					text_color = Colors.get_table("green"),
					offset = var_1_5
				},
				text_total_sum_decimal_part = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "left",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("white"),
					offset = var_1_5
				},
				text_last_dmg = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				text_last_dmg_2 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				text_last_dmg_3 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				text_last_dmg_4 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				text_last_dmg_5 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				text_last_dmg_6 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				text_last_dmg_7 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				text_last_dmg_8 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					debug_draw_box = true,
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				text_last_dmg_9 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				text_last_dmg_10 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_1,
					text_color = Colors.get_table("yellow"),
					offset = var_1_5
				},
				damage_icon = {
					size = {
						var_1_3,
						var_1_3
					},
					offset = var_1_6,
					color = {
						255,
						199,
						194,
						194
					}
				}
			},
			offset = var_1_2
		}

		var_1_0[#var_1_0 + iter_1_0] = var_1_7
	end

	return var_1_0
end
