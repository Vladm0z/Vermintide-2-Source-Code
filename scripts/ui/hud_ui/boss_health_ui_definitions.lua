-- chunkname: @scripts/ui/hud_ui/boss_health_ui_definitions.lua

local_require("scripts/ui/ui_widgets")

local var_0_0 = false
local var_0_1 = {
	60,
	70
}
local var_0_2 = 440
local var_0_3 = var_0_2 + var_0_1[1]
local var_0_4 = 80
local var_0_5 = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	pivot_parent = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			var_0_3,
			70
		},
		position = {
			0,
			-72,
			0
		}
	},
	pivot = {
		vertical_alignment = "center",
		parent = "pivot_parent",
		horizontal_alignment = "center",
		size = {
			var_0_3,
			14
		},
		position = {
			0,
			0,
			0
		}
	},
	pivot_dragger = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "left",
		size = {
			var_0_3,
			70
		},
		position = {
			0,
			0,
			0
		}
	}
}

if IS_CONSOLE then
	var_0_5.screen.scale = "hud_fit"
end

local function var_0_6(arg_1_0)
	local var_1_0 = var_0_2
	local var_1_1 = var_0_1
	local var_1_2 = 1
	local var_1_3 = {
		255,
		255,
		255,
		255
	}
	local var_1_4 = 3
	local var_1_5 = -16

	if arg_1_0 then
		var_1_0 = var_0_4
		var_1_2 = 0.6
	end

	local var_1_6 = arg_1_0 and 8 or 0
	local var_1_7 = {
		element = {}
	}
	local var_1_8 = {
		{
			pass_type = "texture",
			style_id = "portrait",
			texture_id = "portrait",
			retained_mode = var_0_0
		},
		{
			pass_type = "texture",
			style_id = "marked_portrait_frame",
			texture_id = "marked_portrait_frame",
			retained_mode = var_0_0,
			content_check_function = function(arg_2_0)
				return arg_2_0.attributes[1]
			end
		},
		{
			pass_type = "texture",
			style_id = "portrait_healing",
			texture_id = "portrait_healing",
			retained_mode = var_0_0
		},
		{
			pass_type = "texture",
			style_id = "lower_normal_bg",
			texture_id = "lower_normal_bg",
			retained_mode = var_0_0,
			content_check_function = function(arg_3_0)
				return not arg_3_0.attributes[1] or arg_1_0
			end
		}
	}
	local var_1_9 = {
		lower_normal_bg = "boss_hp_bar_bottom",
		portrait_healing = "boss_portrait_heal",
		portrait = "icons_placeholder",
		marked_portrait_frame = "unit_frame_portrait_enemy_marked",
		bar_length = var_1_0,
		skull_dividers = {}
	}
	local var_1_10 = {}
	local var_1_11 = 0
	local var_1_12 = var_1_1[1] * var_1_2
	local var_1_13 = var_1_1[2] * var_1_2

	var_1_10.portrait = {
		size = {
			var_1_12,
			var_1_13
		},
		offset = {
			var_1_11,
			-(var_1_13 - 20 * var_1_2) - 2,
			6
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_1_10.portrait_healing = {
		size = {
			var_1_12 - 8 * var_1_2,
			var_1_13 - 8 * var_1_2
		},
		offset = {
			var_1_11 + 2,
			-(var_1_13 - 22 * var_1_2),
			7
		},
		color = {
			255,
			0,
			255,
			0
		}
	}
	var_1_10.marked_portrait_frame = {
		size = {
			var_1_12,
			var_1_13
		},
		offset = {
			var_1_11,
			-(var_1_13 - 20 * var_1_2) - 2,
			8
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local var_1_14 = var_1_11 + var_1_12

	var_1_10.lower_normal_bg = {
		size = {
			var_1_0 + 32 * var_1_2,
			arg_1_0 and 20 or 55
		},
		offset = {
			var_1_14 - 23,
			-28 * var_1_2 - (arg_1_0 and 20 or 55) + var_1_6,
			2
		},
		color = {
			arg_1_0 and 230 or 255,
			255,
			255,
			255
		}
	}

	if not arg_1_0 then
		var_1_8[#var_1_8 + 1] = {
			pass_type = "texture",
			style_id = "lower_marked_bg",
			texture_id = "lower_marked_bg",
			retained_mode = var_0_0,
			content_check_function = function(arg_4_0)
				return arg_4_0.attributes[1] and not arg_1_0
			end
		}
		var_1_9.lower_marked_bg = "boss_hp_bar_marked_bg"
		var_1_9.attribute_offset_reference = var_1_14

		local var_1_15 = 0

		for iter_1_0 = 1, 6 do
			local var_1_16 = "attribute_text_" .. iter_1_0

			var_1_8[#var_1_8 + 1] = {
				pass_type = "text",
				text_id = var_1_16,
				style_id = var_1_16,
				retained_mode = var_0_0,
				content_check_function = function(arg_5_0)
					return arg_5_0.attributes[iter_1_0]
				end
			}

			local var_1_17 = math.ceil(iter_1_0 / var_1_4)
			local var_1_18 = -24 + var_1_5 * var_1_17

			var_1_9[var_1_16] = ""
			var_1_9.show_attributes = true
			var_1_10[var_1_16] = {
				vertical_alignment = "top",
				upper_case = false,
				horizontal_alignment = "left",
				font_size = 16,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("orange", 255),
				offset = {
					0,
					var_1_18 + var_1_6,
					7
				}
			}

			if (iter_1_0 - 1) % var_1_4 ~= 0 then
				var_1_15 = var_1_15 + 1

				local var_1_19 = "skull_divider_" .. var_1_15

				var_1_9.skull_dividers[iter_1_0] = var_1_19
				var_1_9[var_1_19] = "skull_divider"
				var_1_8[#var_1_8 + 1] = {
					pass_type = "texture",
					texture_id = var_1_19,
					style_id = var_1_19,
					retained_mode = var_0_0,
					content_check_function = function(arg_6_0)
						return arg_6_0.attributes[iter_1_0]
					end
				}
				var_1_10[var_1_19] = {
					size = {
						22,
						27
					},
					offset = {
						0,
						var_1_17 + var_1_6,
						7
					},
					color = {
						255,
						255,
						255,
						255
					}
				}
			end
		end

		var_1_10.lower_marked_bg = {
			size = {
				var_1_0 + 32,
				55
			},
			offset = {
				var_1_14 - 23,
				-83 * var_1_2 + var_1_6,
				2
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	end

	local var_1_20 = "bar_fg"

	var_1_8[#var_1_8 + 1] = {
		pass_type = "texture",
		texture_id = var_1_20,
		style_id = var_1_20,
		retained_mode = var_0_0
	}

	local var_1_21 = 0.04139433551198257 * var_1_0

	var_1_9[var_1_20] = arg_1_0 and "boss_hp_bar_titleless" or "boss_hp_bar"
	var_1_10[var_1_20] = {
		size = {
			var_1_0 + var_1_21 * var_1_2,
			75 * var_1_2
		},
		offset = {
			var_1_14,
			-35 * var_1_2 + var_1_6,
			5
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local var_1_22 = var_1_14 + 0.013071895424836602 * var_1_0

	var_1_9.attributes = {}

	local var_1_23 = "bar_bg"
	local var_1_24 = -24 * var_1_2 + var_1_6

	var_1_8[#var_1_8 + 1] = {
		pass_type = "texture",
		texture_id = var_1_23,
		style_id = var_1_23,
		retained_mode = var_0_0
	}
	var_1_9[var_1_23] = "boss_hp_bar_bg"
	var_1_10[var_1_23] = {
		color = table.clone(var_1_3),
		offset = {
			var_1_22,
			var_1_24,
			0
		},
		size = {
			var_1_0,
			14 * var_1_2
		}
	}

	local var_1_25 = "bar"

	var_1_8[#var_1_8 + 1] = {
		pass_type = "texture_uv",
		content_id = var_1_25,
		style_id = var_1_25,
		retained_mode = var_0_0
	}
	var_1_10[var_1_25] = {
		color = {
			255,
			255,
			255,
			255
		},
		size = {
			var_1_0,
			14 * var_1_2
		},
		offset = {
			var_1_22,
			var_1_24,
			2
		},
		default_offset = {
			0,
			0,
			2
		},
		default_size = {
			var_1_0,
			14 * var_1_2
		}
	}
	var_1_9[var_1_25] = {
		texture_id = "boss_hp_bar_fill",
		uvs = {
			{
				0,
				0
			},
			{
				1,
				1
			}
		}
	}
	var_1_9.healing_bar_offset_reference = var_1_22

	local var_1_26 = "healing_bar"

	var_1_8[#var_1_8 + 1] = {
		pass_type = "texture_uv",
		content_id = var_1_26,
		style_id = var_1_26,
		retained_mode = var_0_0
	}
	var_1_10[var_1_26] = {
		color = {
			200,
			255,
			255,
			255
		},
		size = {
			var_1_0,
			14 * var_1_2
		},
		offset = {
			var_1_22,
			var_1_24,
			3
		},
		default_offset = {
			0,
			0,
			3
		},
		default_size = {
			var_1_0,
			14 * var_1_2
		}
	}
	var_1_9[var_1_26] = {
		texture_id = "boss_hp_bar_healing",
		uvs = {
			{
				0,
				0
			},
			{
				1,
				1
			}
		}
	}

	local var_1_27 = "healing_bar_flash"

	var_1_8[#var_1_8 + 1] = {
		pass_type = "texture",
		content_id = var_1_27,
		style_id = var_1_27,
		retained_mode = var_0_0
	}

	local var_1_28 = UIFrameSettings.boss_hp_bar_heal_flash.texture_sizes.vertical[1]

	var_1_10[var_1_27] = {
		color = {
			0,
			255,
			255,
			255
		},
		size = {
			var_1_0 + var_1_28 * 2,
			40 * var_1_2
		},
		offset = {
			var_1_22 - var_1_28,
			var_1_24 - var_1_28 * var_1_2,
			5
		},
		default_offset = {
			0,
			0,
			5
		},
		default_size = {
			var_1_0,
			40 * var_1_2
		}
	}
	var_1_9[var_1_27] = {
		texture_id = "boss_hp_bar_heal_flash"
	}
	var_1_9.dead_space_bar_offset_reference = var_1_22

	local var_1_29 = "dead_space_bar"

	var_1_8[#var_1_8 + 1] = {
		pass_type = "texture_uv",
		content_id = var_1_29,
		style_id = var_1_29,
		retained_mode = var_0_0
	}
	var_1_10[var_1_29] = {
		color = {
			255,
			255,
			255,
			255
		},
		size = {
			var_1_0,
			14 * var_1_2
		},
		offset = {
			var_1_22,
			var_1_24,
			1
		},
		default_offset = {
			0,
			0,
			1
		},
		default_size = {
			var_1_0,
			14 * var_1_2
		}
	}
	var_1_9[var_1_29] = {
		texture_id = "boss_hp_bar_dead_space",
		uvs = {
			{
				0,
				0
			},
			{
				1,
				1
			}
		}
	}
	var_1_9.dead_space_bar_divider_offset_reference = var_1_22

	local var_1_30 = "dead_space_bar_divider"

	var_1_8[#var_1_8 + 1] = {
		pass_type = "texture",
		texture_id = var_1_30,
		style_id = var_1_30,
		retained_mode = var_0_0,
		content_check_function = function(arg_7_0)
			return (arg_7_0.max_health_fraction or 1) ~= 1
		end
	}
	var_1_9[var_1_30] = "boss_hp_divider"
	var_1_10[var_1_30] = {
		default_width_offset = 11,
		color = table.clone(var_1_3),
		offset = {
			var_1_22 + var_1_0 - 11,
			var_1_24 - 8,
			7
		},
		size = {
			21,
			29
		}
	}
	var_1_9.bar_edge_reference_offset = var_1_22

	local var_1_31 = "bar_edge"

	var_1_8[#var_1_8 + 1] = {
		pass_type = "texture",
		texture_id = var_1_31,
		style_id = var_1_31,
		retained_mode = var_0_0,
		content_check_function = function(arg_8_0)
			return (arg_8_0.bar_edge_fraction or 1) ~= 1
		end
	}
	var_1_9[var_1_31] = "boss_hp_bar_edge"
	var_1_10[var_1_31] = {
		color = table.clone(var_1_3),
		default_width_offset = 7 * var_1_2,
		offset = {
			0,
			var_1_24,
			4
		},
		size = {
			13 * var_1_2,
			14 * var_1_2
		}
	}

	if not arg_1_0 then
		local var_1_32 = 4
		local var_1_33 = "title_text"

		var_1_8[#var_1_8 + 1] = {
			pass_type = "text",
			text_id = var_1_33,
			style_id = var_1_33,
			retained_mode = var_0_0
		}
		var_1_9[var_1_33] = ""
		var_1_10[var_1_33] = {
			vertical_alignment = "top",
			upper_case = false,
			horizontal_alignment = "left",
			font_size = 24,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				var_1_22 + 4,
				4 + var_1_6,
				7
			}
		}

		local var_1_34 = "title_text_shadow_shadow"

		var_1_8[#var_1_8 + 1] = {
			pass_type = "text",
			text_id = var_1_33,
			style_id = var_1_34,
			retained_mode = var_0_0
		}
		var_1_9[var_1_34] = ""
		var_1_10[var_1_34] = {
			vertical_alignment = "top",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 24,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_1_22 + 6,
				var_1_32 - 2 + var_1_6,
				6
			}
		}
	end

	var_1_7.element.passes = var_1_8
	var_1_7.content = var_1_9
	var_1_7.style = var_1_10
	var_1_7.offset = {
		0,
		0,
		0
	}
	var_1_7.scenegraph_id = "pivot"

	return var_1_7
end

return {
	scenegraph_definition = var_0_5,
	widget_create_func = var_0_6,
	total_bar_length = var_0_3
}
