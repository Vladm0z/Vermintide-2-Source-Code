-- chunkname: @scripts/ui/hud_ui/contract_log_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 300
local var_0_3 = true
local var_0_4 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			-var_0_2 - 10,
			-80,
			1
		},
		size = {
			0,
			0
		}
	}
}

local function var_0_5(arg_1_0)
	local var_1_0 = 20
	local var_1_1 = 20

	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon",
					retained_mode = var_0_3
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_bg",
					texture_id = "texture_icon_bg",
					retained_mode = var_0_3
				},
				{
					pass_type = "texture",
					style_id = "texture_fade_bg",
					texture_id = "texture_fade_bg",
					retained_mode = var_0_3
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					retained_mode = var_0_3
				},
				{
					style_id = "task_text",
					pass_type = "text",
					text_id = "task_text",
					retained_mode = var_0_3
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
					var_1_0,
					var_1_1
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_0_2 - 20,
					10,
					4
				}
			},
			texture_icon_bg = {
				size = {
					var_1_0,
					var_1_1
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_0_2 - 20,
					10,
					3
				}
			},
			texture_fade_bg = {
				size = {
					var_0_2 + 60,
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
					var_0_2,
					10
				},
				offset = {
					-5 - (var_1_0 + 3),
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
					var_0_2 * 2,
					20
				},
				offset = {
					-5 - var_0_2,
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

local var_0_6 = {
	title_text = {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					retained_mode = var_0_3
				},
				{
					pass_type = "texture",
					style_id = "texture_fade_bg",
					texture_id = "texture_fade_bg",
					retained_mode = var_0_3
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
					var_0_2,
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
					var_0_2 + 60,
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
local var_0_7 = {}

for iter_0_0 = 1, 3 do
	var_0_7[iter_0_0] = var_0_5(iter_0_0)
end

return {
	scenegraph_definition = var_0_4,
	entry_widget_definitions = var_0_7,
	widget_definitions = var_0_6,
	ENTRY_LENGTH = var_0_2
}
