-- chunkname: @scripts/ui/hud_ui/boss_health_ui_definitions.lua

local_require("scripts/ui/ui_widgets")

local flag = false
local tbl = {
	60,
	70
}
local num = 440
local num_2 = num + tbl[1]
local num_3 = 80
local tbl_2 = {
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
			num_2,
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
			num_2,
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
			num_2,
			70
		},
		position = {
			0,
			0,
			0
		}
	}
}

if not IS_CONSOLE then
	tbl_2.screen.scale = "hud_fit"
end

local function fn(arg_1_0)
	-- function 1
	local var_1_0 = num
	local var_1_1 = tbl
	local num_2 = 1
	local tbl_2 = {
		255,
		255,
		255,
		255
	}
	local num_4 = 3
	local num_5 = -16

	if not arg_1_0 then
		var_1_0 = num_3
		num_2 = 0.6
	end

	local flag_2

	flag_2 = not arg_1_0 and 8 and 0

	local tbl_3 = {
		element = {}
	}
	local tbl_4 = {
		{
			pass_type = "texture",
			style_id = "portrait",
			texture_id = "portrait",
			retained_mode = flag
		},
		{
			pass_type = "texture",
			style_id = "marked_portrait_frame",
			texture_id = "marked_portrait_frame",
			retained_mode = flag,
			content_check_function = function (self)
				-- function 2
				local var_2_0 = self.attributes[1]

				var_2_0 = var_2_0 or self.has_custom_attribute

				return var_2_0
			end
		},
		{
			pass_type = "texture",
			style_id = "portrait_healing",
			texture_id = "portrait_healing",
			retained_mode = flag
		},
		{
			pass_type = "texture",
			style_id = "lower_normal_bg",
			texture_id = "lower_normal_bg",
			retained_mode = flag,
			content_check_function = function (self)
				-- function 3
				return not self.attributes[1] and arg_1_0
			end
		}
	}
	local tbl_5 = {
		lower_normal_bg = "boss_hp_bar_bottom",
		portrait_healing = "boss_portrait_heal",
		portrait = "icons_placeholder",
		marked_portrait_frame = "unit_frame_portrait_enemy_marked",
		bar_length = var_1_0,
		skull_dividers = {}
	}
	local tbl_6 = {}
	local num_6 = 0
	local num_7 = var_1_1[1] * num_2
	local num_8 = var_1_1[2] * num_2

	tbl_6.portrait = {
		size = {
			num_7,
			num_8
		},
		offset = {
			num_6,
			-(num_8 - 20 * num_2) - 2,
			6
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_6.portrait_healing = {
		size = {
			num_7 - 8 * num_2,
			num_8 - 8 * num_2
		},
		offset = {
			num_6 + 2,
			-(num_8 - 22 * num_2),
			7
		},
		color = {
			255,
			0,
			255,
			0
		}
	}
	tbl_6.marked_portrait_frame = {
		size = {
			num_7,
			num_8
		},
		offset = {
			num_6,
			-(num_8 - 20 * num_2) - 2,
			8
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local num_9 = num_6 + num_7
	local tbl_7 = {}
	local tbl_8 = {
		var_1_0 + 32 * num_2
	}
	local flag_3

	flag_3 = not arg_1_0 and 20 and 55
	tbl_8[2] = flag_3
	tbl_7.size = tbl_8

	local tbl_9 = {
		num_9 - 23,
		nil,
		2
	}
	local num_10 = -28 * num_2
	local flag_4

	flag_4 = not arg_1_0 and 20 and 55
	tbl_9[2] = num_10 - flag_4 + flag_2
	tbl_7.offset = tbl_9

	local tbl_10 = {
		nil,
		255,
		255,
		255
	}
	local flag_5

	flag_5 = not arg_1_0 and 230 and 255
	tbl_10[1] = flag_5
	tbl_7.color = tbl_10
	tbl_6.lower_normal_bg = tbl_7

	if not arg_1_0 then
		tbl_4[#tbl_4 + 1] = {
			pass_type = "texture",
			style_id = "lower_marked_bg",
			texture_id = "lower_marked_bg",
			retained_mode = flag,
			content_check_function = function (self)
				-- function 4
				local var_4_0 = self.attributes[1]

				var_4_0 = not var_4_0 and not arg_1_0

				return var_4_0
			end
		}
		tbl_5.lower_marked_bg = "boss_hp_bar_marked_bg"
		tbl_5.attribute_offset_reference = num_9

		local num_11 = 0

		for i = 1, 6 do
			local str = "attribute_text_" .. i

			tbl_4[#tbl_4 + 1] = {
				pass_type = "text",
				text_id = str,
				style_id = str,
				retained_mode = flag,
				content_check_function = function (self)
					-- function 5
					return self.attributes[i]
				end
			}

			local ceil = math.ceil(i / num_4)
			local num_12 = -24 + num_5 * ceil

			tbl_5[str] = ""
			tbl_5.show_attributes = true
			tbl_6[str] = {
				vertical_alignment = "top",
				upper_case = false,
				horizontal_alignment = "left",
				font_size = 16,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("orange", 255),
				offset = {
					0,
					num_12 + flag_2,
					7
				}
			}

			if (i - 1) % num_4 ~= 0 then
				num_11 = num_11 + 1

				local str_2 = "skull_divider_" .. num_11

				tbl_5.skull_dividers[i] = str_2
				tbl_5[str_2] = "skull_divider"
				tbl_4[#tbl_4 + 1] = {
					pass_type = "texture",
					texture_id = str_2,
					style_id = str_2,
					retained_mode = flag,
					content_check_function = function (self)
						-- function 6
						return self.attributes[i]
					end
				}
				tbl_6[str_2] = {
					size = {
						22,
						27
					},
					offset = {
						0,
						ceil + flag_2,
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

		tbl_6.lower_marked_bg = {
			size = {
				var_1_0 + 32,
				55
			},
			offset = {
				num_9 - 23,
				-83 * num_2 + flag_2,
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

	local str_3 = "bar_fg"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str_3,
		style_id = str_3,
		retained_mode = flag
	}

	local num_13 = 0.04139433551198257 * var_1_0
	local flag_6

	flag_6 = not arg_1_0 and "boss_hp_bar_titleless" and "boss_hp_bar"
	tbl_5[str_3] = flag_6
	tbl_6[str_3] = {
		size = {
			var_1_0 + num_13 * num_2,
			75 * num_2
		},
		offset = {
			num_9,
			-35 * num_2 + flag_2,
			5
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local num_14 = num_9 + 0.013071895424836602 * var_1_0

	tbl_5.attributes = {}

	local str_4 = "bar_bg"
	local num_15 = -24 * num_2 + flag_2

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str_4,
		style_id = str_4,
		retained_mode = flag
	}
	tbl_5[str_4] = "boss_hp_bar_bg"
	tbl_6[str_4] = {
		color = table.clone(tbl_2),
		offset = {
			num_14,
			num_15,
			0
		},
		size = {
			var_1_0,
			14 * num_2
		}
	}

	local str_5 = "bar"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture_uv",
		content_id = str_5,
		style_id = str_5,
		retained_mode = flag
	}
	tbl_6[str_5] = {
		color = {
			255,
			255,
			255,
			255
		},
		size = {
			var_1_0,
			14 * num_2
		},
		offset = {
			num_14,
			num_15,
			2
		},
		default_offset = {
			0,
			0,
			2
		},
		default_size = {
			var_1_0,
			14 * num_2
		}
	}
	tbl_5[str_5] = {
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
	tbl_5.healing_bar_offset_reference = num_14

	local str_6 = "healing_bar"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture_uv",
		content_id = str_6,
		style_id = str_6,
		retained_mode = flag
	}
	tbl_6[str_6] = {
		color = {
			200,
			255,
			255,
			255
		},
		size = {
			var_1_0,
			14 * num_2
		},
		offset = {
			num_14,
			num_15,
			3
		},
		default_offset = {
			0,
			0,
			3
		},
		default_size = {
			var_1_0,
			14 * num_2
		}
	}
	tbl_5[str_6] = {
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

	local str_7 = "healing_bar_flash"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		content_id = str_7,
		style_id = str_7,
		retained_mode = flag
	}

	local var_1_37 = UIFrameSettings.boss_hp_bar_heal_flash.texture_sizes.vertical[1]

	tbl_6[str_7] = {
		color = {
			0,
			255,
			255,
			255
		},
		size = {
			var_1_0 + var_1_37 * 2,
			40 * num_2
		},
		offset = {
			num_14 - var_1_37,
			num_15 - var_1_37 * num_2,
			5
		},
		default_offset = {
			0,
			0,
			5
		},
		default_size = {
			var_1_0,
			40 * num_2
		}
	}
	tbl_5[str_7] = {
		texture_id = "boss_hp_bar_heal_flash"
	}
	tbl_5.dead_space_bar_offset_reference = num_14

	local str_8 = "dead_space_bar"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture_uv",
		content_id = str_8,
		style_id = str_8,
		retained_mode = flag
	}
	tbl_6[str_8] = {
		color = {
			255,
			255,
			255,
			255
		},
		size = {
			var_1_0,
			14 * num_2
		},
		offset = {
			num_14,
			num_15,
			1
		},
		default_offset = {
			0,
			0,
			1
		},
		default_size = {
			var_1_0,
			14 * num_2
		}
	}
	tbl_5[str_8] = {
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
	tbl_5.dead_space_bar_divider_offset_reference = num_14

	local str_9 = "dead_space_bar_divider"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str_9,
		style_id = str_9,
		retained_mode = flag,
		content_check_function = function (self)
			-- function 7
			local max_health_fraction = self.max_health_fraction

			max_health_fraction = max_health_fraction or 1

			return max_health_fraction ~= 1
		end
	}
	tbl_5[str_9] = "boss_hp_divider"
	tbl_6[str_9] = {
		default_width_offset = 11,
		color = table.clone(tbl_2),
		offset = {
			num_14 + var_1_0 - 11,
			num_15 - 8,
			7
		},
		size = {
			21,
			29
		}
	}
	tbl_5.bar_edge_reference_offset = num_14

	local str_10 = "bar_edge"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str_10,
		style_id = str_10,
		retained_mode = flag,
		content_check_function = function (self)
			-- function 8
			local bar_edge_fraction = self.bar_edge_fraction

			bar_edge_fraction = bar_edge_fraction or 1

			return bar_edge_fraction ~= 1
		end
	}
	tbl_5[str_10] = "boss_hp_bar_edge"
	tbl_6[str_10] = {
		color = table.clone(tbl_2),
		default_width_offset = 7 * num_2,
		offset = {
			0,
			num_15,
			4
		},
		size = {
			13 * num_2,
			14 * num_2
		}
	}

	if not arg_1_0 then
		local num_16 = 4
		local str_11 = "title_text"

		tbl_4[#tbl_4 + 1] = {
			pass_type = "text",
			text_id = str_11,
			style_id = str_11,
			retained_mode = flag
		}
		tbl_5[str_11] = ""
		tbl_6[str_11] = {
			vertical_alignment = "top",
			upper_case = false,
			horizontal_alignment = "left",
			font_size = 24,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				num_14 + 4,
				4 + flag_2,
				7
			}
		}

		local str_12 = "title_text_shadow_shadow"

		tbl_4[#tbl_4 + 1] = {
			pass_type = "text",
			text_id = str_11,
			style_id = str_12,
			retained_mode = flag
		}
		tbl_5[str_12] = ""
		tbl_6[str_12] = {
			vertical_alignment = "top",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 24,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				num_14 + 6,
				num_16 - 2 + flag_2,
				6
			}
		}
	end

	tbl_3.element.passes = tbl_4
	tbl_3.content = tbl_5
	tbl_3.style = tbl_6
	tbl_3.offset = {
		0,
		0,
		0
	}
	tbl_3.scenegraph_id = "pivot"

	return tbl_3
end

return {
	scenegraph_definition = tbl_2,
	widget_create_func = fn,
	total_bar_length = num_2
}
