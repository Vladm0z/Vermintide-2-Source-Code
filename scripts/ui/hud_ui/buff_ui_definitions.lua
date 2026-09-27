-- chunkname: @scripts/ui/hud_ui/buff_ui_definitions.lua

local num = 1920
local num_2 = 1080
local flag = true
local tbl = {
	root = {
		scale = "hud_scale_fit",
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
	tbl.root.scale = "hud_fit"
	tbl.root.is_root = false
end

local tbl_2 = {
	66,
	66
}
local num_3 = 8
local tbl_3 = {
	scenegraph_id = "buff_pivot",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "texture_icon_bg",
				texture_id = "texture_icon",
				retained_mode = flag
			},
			{
				pass_type = "texture",
				style_id = "texture_icon",
				texture_id = "texture_icon",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 1
					return self.is_cooldown
				end
			},
			{
				style_id = "icon_mask",
				texture_id = "icon_mask",
				pass_type = "texture",
				retained_mode = flag,
				content_change_function = function (self, arg_2_1, arg_2_2, arg_2_3)
					-- function 2
					arg_2_1.color[1] = 255 * (1 - self.progress)
				end
			},
			{
				pass_type = "texture",
				style_id = "texture_frame",
				texture_id = "texture_frame",
				retained_mode = flag
			},
			{
				style_id = "stack_count",
				pass_type = "text",
				text_id = "stack_count",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 3
					return self.stack_count > 1
				end
			},
			{
				style_id = "stack_count_shadow",
				pass_type = "text",
				text_id = "stack_count",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 4
					return self.stack_count > 1
				end
			},
			{
				style_id = "texture_cooldown",
				texture_id = "texture_cooldown",
				pass_type = "gradient_mask_texture",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 5
					return self.is_cooldown
				end,
				content_change_function = function (self, arg_6_1, arg_6_2, arg_6_3)
					-- function 6
					arg_6_1.color[1] = 255 * (1 - self.progress)
				end
			},
			{
				style_id = "texture_duration",
				texture_id = "texture_duration",
				pass_type = "gradient_mask_texture",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 7
					return not self.is_cooldown
				end,
				content_change_function = function (self, arg_8_1, arg_8_2, arg_8_3)
					-- function 8
					arg_8_1.color[1] = 255 * (1 - self.progress)
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
			size = tbl_2,
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
local num_4 = 3
local num_5 = 5
local num_6 = num_4 * num_5

return {
	BUFF_SIZE = tbl_2,
	BUFF_SPACING = num_3,
	MAX_NUMBER_OF_BUFFS = num_6,
	MAX_BUFF_ROWS = num_4,
	MAX_BUFF_COLUMNS = num_5,
	scenegraph_definition = tbl,
	buff_widget_definition = tbl_3
}
