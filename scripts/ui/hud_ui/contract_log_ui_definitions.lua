-- chunkname: @scripts/ui/hud_ui/contract_log_ui_definitions.lua

local num = 1920
local num_2 = 1080
local num_3 = 300
local flag = true
local tbl = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			-num_3 - 10,
			-80,
			1
		},
		size = {
			0,
			0
		}
	}
}

local function fn(arg_1_0)
	-- function 1
	local num = 20
	local num_2 = 20

	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_bg",
					texture_id = "texture_icon_bg",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "texture_fade_bg",
					texture_id = "texture_fade_bg",
					retained_mode = flag
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					retained_mode = flag
				},
				{
					style_id = "task_text",
					pass_type = "text",
					text_id = "task_text",
					retained_mode = flag
				}
			}
		},
		content = {
			texture_fade_bg = "ingame_contract_bg_02",
			title_text = "n/a",
			texture_icon_bg = "hud_quest_icon_01_bg",
			task_text = "n/a",
			texture_icon = "hud_quest_icon_01_fg"
		},
		style = {
			texture_icon = {
				size = {
					num,
					num_2
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					num_3 - 20,
					10,
					4
				}
			},
			texture_icon_bg = {
				size = {
					num,
					num_2
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					num_3 - 20,
					10,
					3
				}
			},
			texture_fade_bg = {
				size = {
					num_3 + 60,
					5
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					-40,
					-15,
					2
				}
			},
			title_text = {
				vertical_alignment = "bottom",
				font_size = 16,
				horizontal_alignment = "right",
				font_type = "hell_shark",
				size = {
					num_3,
					10
				},
				offset = {
					-5 - (num + 3),
					10,
					4
				},
				text_color = {
					170,
					255,
					255,
					255
				}
			},
			task_text = {
				dynamic_height = true,
				font_size = 20,
				word_wrap = true,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				font_type = "hell_shark",
				size = {
					num_3 * 2,
					20
				},
				offset = {
					-5 - num_3,
					10,
					4
				},
				text_color = {
					170,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local tbl_2 = {
	title_text = {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "texture_fade_bg",
					texture_id = "texture_fade_bg",
					retained_mode = flag
				}
			}
		},
		content = {
			texture_fade_bg = "ingame_contract_bg_02",
			title_text = Localize("dlc1_3_1_hud_contract_log_title") .. ":"
		},
		style = {
			title_text = {
				vertical_alignment = "bottom",
				font_size = 24,
				horizontal_alignment = "right",
				font_type = "hell_shark",
				size = {
					num_3,
					50
				},
				offset = {
					-20,
					30,
					5
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 200)
			},
			texture_fade_bg = {
				size = {
					num_3 + 60,
					30
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					-40,
					33,
					4
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
}
local tbl_3 = {}

for i = 1, 3 do
	tbl_3[i] = fn(i)
end

return {
	scenegraph_definition = tbl,
	entry_widget_definitions = tbl_3,
	widget_definitions = tbl_2,
	ENTRY_LENGTH = num_3
}
