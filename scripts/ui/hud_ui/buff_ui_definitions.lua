-- chunkname: @scripts/ui/hud_ui/buff_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = true
local var_0_3 = {
	root = {
		scale = "hud_scale_fit",
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
	pivot_root = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			150,
			18,
			1
		},
		size = {
			0,
			0
		}
	},
	pivot_parent = {
		vertical_alignment = "bottom",
		parent = "pivot_root",
		horizontal_alignment = "left",
		position = {
			UISettings.INSIGNIA_OFFSET,
			0,
			0
		},
		size = {
			0,
			0
		}
	},
	pivot = {
		vertical_alignment = "bottom",
		parent = "pivot_parent",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			0
		}
	},
	pivot_dragger = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
		},
		size = {
			362,
			214
		}
	},
	buff_pivot = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	}
}

if not IS_WINDOWS then
	var_0_3.root.scale = "hud_fit"
	var_0_3.root.is_root = false
end

local var_0_4 = {
	66,
	66
}
local var_0_5 = 8
local var_0_6 = {
	scenegraph_id = "buff_pivot",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "texture_icon_bg",
				texture_id = "texture_icon",
				retained_mode = var_0_2
			},
			{
				pass_type = "texture",
				style_id = "texture_icon",
				texture_id = "texture_icon",
				retained_mode = var_0_2,
				content_check_function = function(arg_1_0)
					return arg_1_0.is_cooldown
				end
			},
			{
				style_id = "icon_mask",
				texture_id = "icon_mask",
				pass_type = "texture",
				retained_mode = var_0_2,
				content_change_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
					arg_2_1.color[1] = 255 * (1 - arg_2_0.progress)
				end
			},
			{
				pass_type = "texture",
				style_id = "texture_frame",
				texture_id = "texture_frame",
				retained_mode = var_0_2
			},
			{
				style_id = "stack_count",
				pass_type = "text",
				text_id = "stack_count",
				retained_mode = var_0_2,
				content_check_function = function(arg_3_0)
					return arg_3_0.stack_count > 1
				end
			},
			{
				style_id = "stack_count_shadow",
				pass_type = "text",
				text_id = "stack_count",
				retained_mode = var_0_2,
				content_check_function = function(arg_4_0)
					return arg_4_0.stack_count > 1
				end
			},
			{
				style_id = "texture_cooldown",
				texture_id = "texture_cooldown",
				pass_type = "gradient_mask_texture",
				retained_mode = var_0_2,
				content_check_function = function(arg_5_0)
					return arg_5_0.is_cooldown
				end,
				content_change_function = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
					arg_6_1.color[1] = 255 * (1 - arg_6_0.progress)
				end
			},
			{
				style_id = "texture_duration",
				texture_id = "texture_duration",
				pass_type = "gradient_mask_texture",
				retained_mode = var_0_2,
				content_check_function = function(arg_7_0)
					return not arg_7_0.is_cooldown
				end,
				content_change_function = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
					arg_8_1.color[1] = 255 * (1 - arg_8_0.progress)
				end
			}
		}
	},
	content = {
		set_unsaturated = false,
		is_cooldown = false,
		texture_cooldown = "buff_cooldown_gradient",
		progress = 0,
		texture_frame = "buff_frame",
		stack_count = 1,
		texture_icon = "teammate_consumable_icon_medpack",
		last_stack_count = 1,
		texture_duration = "buff_duration_gradient",
		gris = "rect_masked",
		icon_mask = "buff_gradient_mask"
	},
	style = {
		texture_icon_bg = {
			saturated = false,
			size = {
				60,
				60
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				3,
				1
			}
		},
		texture_icon = {
			saturated = false,
			masked = true,
			size = {
				60,
				60
			},
			color = {
				255,
				100,
				100,
				100
			},
			offset = {
				3,
				3,
				2
			}
		},
		icon_mask = {
			size = {
				60,
				60
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				3,
				2
			}
		},
		texture_cooldown = {
			size = {
				60,
				60
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				3,
				3
			}
		},
		texture_frame = {
			size = var_0_4,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				4
			}
		},
		texture_duration = {
			size = {
				70,
				70
			},
			color = {
				150,
				255,
				255,
				255
			},
			offset = {
				-2,
				-2,
				5
			}
		},
		stack_count = {
			word_wrap = true,
			upper_case = true,
			localize = false,
			font_size = 26,
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			font_type = "hell_shark",
			size = {
				60,
				60
			},
			offset = {
				-2,
				2,
				9
			},
			text_color = Colors.get_color_table_with_alpha("white", 255)
		},
		stack_count_shadow = {
			word_wrap = true,
			upper_case = true,
			localize = false,
			font_size = 26,
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			font_type = "hell_shark",
			size = {
				60,
				60
			},
			offset = {
				0,
				0,
				8
			},
			text_color = Colors.get_color_table_with_alpha("black", 255)
		}
	},
	offset = {
		0,
		0,
		0
	}
}
local var_0_7 = 3
local var_0_8 = 5
local var_0_9 = var_0_7 * var_0_8

return {
	BUFF_SIZE = var_0_4,
	BUFF_SPACING = var_0_5,
	MAX_NUMBER_OF_BUFFS = var_0_9,
	MAX_BUFF_ROWS = var_0_7,
	MAX_BUFF_COLUMNS = var_0_8,
	scenegraph_definition = var_0_3,
	buff_widget_definition = var_0_6
}
