-- chunkname: @scripts/ui/hud_ui/boss_health_ui_definitions.lua

local_require("scripts/ui/ui_widgets")

local retained_mode = false
local base_portrait_size = {
	60,
	70
}
local base_bar_length = 440
local total_bar_length = base_bar_length + base_portrait_size[1]
local additional_bar_length = 80
local scenegraph_definition = {
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
			total_bar_length,
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
			total_bar_length,
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
			total_bar_length,
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
	scenegraph_definition.screen.scale = "hud_fit"
end

local function create_health_bar_widget(is_additional)
	-- function 1
	local bar_length = base_bar_length
	local portrait_size = base_portrait_size
	local detail_scale = 1
	local default_color = {
		255,
		255,
		255,
		255
	}
	local max_grudge_per_line = 3
	local grudge_line_offset = -16

	if is_additional then
		bar_length = additional_bar_length
		detail_scale = 0.6
	end

	local num

	if is_additional then
		num = 8

		goto label_1_0
	end

	num = 0

	local bar_y_offset = num

	::label_1_0::

	local widget = {
		element = {}
	}
	local passes = {
		{
			pass_type = "texture",
			style_id = "portrait",
			texture_id = "portrait",
			retained_mode = retained_mode
		},
		{
			pass_type = "texture",
			style_id = "marked_portrait_frame",
			texture_id = "marked_portrait_frame",
			retained_mode = retained_mode,
			content_check_function = function (content)
				-- function 2
				local var_2_0 = content.attributes[1]

				var_2_0 = not not var_2_0 or not not content.has_custom_attribute

				return var_2_0
			end
		},
		{
			pass_type = "texture",
			style_id = "portrait_healing",
			texture_id = "portrait_healing",
			retained_mode = retained_mode
		},
		{
			pass_type = "texture",
			style_id = "lower_normal_bg",
			texture_id = "lower_normal_bg",
			retained_mode = retained_mode,
			content_check_function = function (chk_content)
				-- function 3
				return not chk_content.attributes[1] or not not is_additional
			end
		}
	}
	local content = {
		lower_normal_bg = "boss_hp_bar_bottom",
		portrait_healing = "boss_portrait_heal",
		portrait = "icons_placeholder",
		marked_portrait_frame = "unit_frame_portrait_enemy_marked",
		bar_length = bar_length,
		skull_dividers = {}
	}
	local style = {}
	local reference_x = 0
	local portrait_size_x = portrait_size[1] * detail_scale
	local portrait_size_y = portrait_size[2] * detail_scale

	style.portrait = {
		size = {
			portrait_size_x,
			portrait_size_y
		},
		offset = {
			reference_x,
			-(portrait_size_y - 20 * detail_scale) - 2,
			6
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	style.portrait_healing = {
		size = {
			portrait_size_x - 8 * detail_scale,
			portrait_size_y - 8 * detail_scale
		},
		offset = {
			reference_x + 2,
			-(portrait_size_y - 22 * detail_scale),
			7
		},
		color = {
			255,
			0,
			255,
			0
		}
	}
	style.marked_portrait_frame = {
		size = {
			portrait_size_x,
			portrait_size_y
		},
		offset = {
			reference_x,
			-(portrait_size_y - 20 * detail_scale) - 2,
			8
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	reference_x = reference_x + portrait_size_x

	local tbl = {}
	local tbl_2 = {
		bar_length + 32 * detail_scale
	}
	local flag

	flag = (not is_additional or not 20) and not not 55
	tbl_2[2] = flag
	tbl.size = tbl_2

	local tbl_3 = {
		reference_x - 23,
		nil,
		2
	}
	local num_2 = -28 * detail_scale
	local flag_2

	flag_2 = (not is_additional or not 20) and not not 55
	tbl_3[2] = num_2 - flag_2 + bar_y_offset
	tbl.offset = tbl_3

	local tbl_4 = {
		nil,
		255,
		255,
		255
	}
	local flag_3

	flag_3 = (not is_additional or not 230) and not not 255
	tbl_4[1] = flag_3
	tbl.color = tbl_4
	style.lower_normal_bg = tbl

	if not is_additional then
		passes[#passes + 1] = {
			pass_type = "texture",
			style_id = "lower_marked_bg",
			texture_id = "lower_marked_bg",
			retained_mode = retained_mode,
			content_check_function = function (chk_content)
				-- function 4
				local var_4_0 = chk_content.attributes[1]

				var_4_0 = not not var_4_0 and not not not is_additional

				return var_4_0
			end
		}
		content.lower_marked_bg = "boss_hp_bar_marked_bg"
		content.attribute_offset_reference = reference_x

		local num_dividers = 0

		for i = 1, 6 do
			local id = "attribute_text_" .. i

			passes[#passes + 1] = {
				pass_type = "text",
				text_id = id,
				style_id = id,
				retained_mode = retained_mode,
				content_check_function = function (chk_content)
					-- function 5
					return chk_content.attributes[i]
				end
			}

			local line = math.ceil(i / max_grudge_per_line)
			local y_offset = -24 + grudge_line_offset * line

			content[id] = ""
			content.show_attributes = true
			style[id] = {
				vertical_alignment = "top",
				upper_case = false,
				horizontal_alignment = "left",
				font_size = 16,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("orange", 255),
				offset = {
					0,
					y_offset + bar_y_offset,
					7
				}
			}

			if (i - 1) % max_grudge_per_line ~= 0 then
				num_dividers = num_dividers + 1

				local divider_id = "skull_divider_" .. num_dividers

				content.skull_dividers[i] = divider_id
				content[divider_id] = "skull_divider"
				passes[#passes + 1] = {
					pass_type = "texture",
					texture_id = divider_id,
					style_id = divider_id,
					retained_mode = retained_mode,
					content_check_function = function (chk_content)
						-- function 6
						return chk_content.attributes[i]
					end
				}
				style[divider_id] = {
					size = {
						22,
						27
					},
					offset = {
						0,
						line + bar_y_offset,
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

		style.lower_marked_bg = {
			size = {
				bar_length + 32,
				55
			},
			offset = {
				reference_x - 23,
				-83 * detail_scale + bar_y_offset,
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

	local bar_fg_name = "bar_fg"

	passes[#passes + 1] = {
		pass_type = "texture",
		texture_id = bar_fg_name,
		style_id = bar_fg_name,
		retained_mode = retained_mode
	}

	local fg_padding = 0.04139433551198257 * bar_length
	local flag_4

	flag_4 = (not is_additional or not "boss_hp_bar_titleless") and not not "boss_hp_bar"
	content[bar_fg_name] = flag_4
	style[bar_fg_name] = {
		size = {
			bar_length + fg_padding * detail_scale,
			75 * detail_scale
		},
		offset = {
			reference_x,
			-35 * detail_scale + bar_y_offset,
			5
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local edge_size = 0.013071895424836602 * bar_length

	reference_x = reference_x + edge_size
	content.attributes = {}

	local bar_bg_name = "bar_bg"
	local bar_y = -24 * detail_scale + bar_y_offset

	passes[#passes + 1] = {
		pass_type = "texture",
		texture_id = bar_bg_name,
		style_id = bar_bg_name,
		retained_mode = retained_mode
	}
	content[bar_bg_name] = "boss_hp_bar_bg"
	style[bar_bg_name] = {
		color = table.clone(default_color),
		offset = {
			reference_x,
			bar_y,
			0
		},
		size = {
			bar_length,
			14 * detail_scale
		}
	}

	local bar_name = "bar"

	passes[#passes + 1] = {
		pass_type = "texture_uv",
		content_id = bar_name,
		style_id = bar_name,
		retained_mode = retained_mode
	}
	style[bar_name] = {
		color = {
			255,
			255,
			255,
			255
		},
		size = {
			bar_length,
			14 * detail_scale
		},
		offset = {
			reference_x,
			bar_y,
			2
		},
		default_offset = {
			0,
			0,
			2
		},
		default_size = {
			bar_length,
			14 * detail_scale
		}
	}
	content[bar_name] = {
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
	content.healing_bar_offset_reference = reference_x

	local healing_bar_name = "healing_bar"

	passes[#passes + 1] = {
		pass_type = "texture_uv",
		content_id = healing_bar_name,
		style_id = healing_bar_name,
		retained_mode = retained_mode
	}
	style[healing_bar_name] = {
		color = {
			200,
			255,
			255,
			255
		},
		size = {
			bar_length,
			14 * detail_scale
		},
		offset = {
			reference_x,
			bar_y,
			3
		},
		default_offset = {
			0,
			0,
			3
		},
		default_size = {
			bar_length,
			14 * detail_scale
		}
	}
	content[healing_bar_name] = {
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

	local healing_bar_flash = "healing_bar_flash"

	passes[#passes + 1] = {
		pass_type = "texture",
		content_id = healing_bar_flash,
		style_id = healing_bar_flash,
		retained_mode = retained_mode
	}

	local bar_flash_padding = UIFrameSettings.boss_hp_bar_heal_flash.texture_sizes.vertical[1]

	style[healing_bar_flash] = {
		color = {
			0,
			255,
			255,
			255
		},
		size = {
			bar_length + bar_flash_padding * 2,
			40 * detail_scale
		},
		offset = {
			reference_x - bar_flash_padding,
			bar_y - bar_flash_padding * detail_scale,
			5
		},
		default_offset = {
			0,
			0,
			5
		},
		default_size = {
			bar_length,
			40 * detail_scale
		}
	}
	content[healing_bar_flash] = {
		texture_id = "boss_hp_bar_heal_flash"
	}
	content.dead_space_bar_offset_reference = reference_x

	local dead_space_bar_name = "dead_space_bar"

	passes[#passes + 1] = {
		pass_type = "texture_uv",
		content_id = dead_space_bar_name,
		style_id = dead_space_bar_name,
		retained_mode = retained_mode
	}
	style[dead_space_bar_name] = {
		color = {
			255,
			255,
			255,
			255
		},
		size = {
			bar_length,
			14 * detail_scale
		},
		offset = {
			reference_x,
			bar_y,
			1
		},
		default_offset = {
			0,
			0,
			1
		},
		default_size = {
			bar_length,
			14 * detail_scale
		}
	}
	content[dead_space_bar_name] = {
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
	content.dead_space_bar_divider_offset_reference = reference_x

	local dead_space_bar_divider_name = "dead_space_bar_divider"

	passes[#passes + 1] = {
		pass_type = "texture",
		texture_id = dead_space_bar_divider_name,
		style_id = dead_space_bar_divider_name,
		retained_mode = retained_mode,
		content_check_function = function (chk_content)
			-- function 7
			local max_health_fraction_2 = chk_content.max_health_fraction

			if not max_health_fraction_2 then
				-- Nothing
			end

			max_health_fraction_2 = 1

			local max_health_fraction = max_health_fraction_2

			::label_7_0::

			return max_health_fraction ~= 1
		end
	}
	content[dead_space_bar_divider_name] = "boss_hp_divider"
	style[dead_space_bar_divider_name] = {
		default_width_offset = 11,
		color = table.clone(default_color),
		offset = {
			reference_x + bar_length - 11,
			bar_y - 8,
			7
		},
		size = {
			21,
			29
		}
	}
	content.bar_edge_reference_offset = reference_x

	local bar_edge_name = "bar_edge"

	passes[#passes + 1] = {
		pass_type = "texture",
		texture_id = bar_edge_name,
		style_id = bar_edge_name,
		retained_mode = retained_mode,
		content_check_function = function (chk_content)
			-- function 8
			local bar_edge_fraction_2 = chk_content.bar_edge_fraction

			if not bar_edge_fraction_2 then
				-- Nothing
			end

			bar_edge_fraction_2 = 1

			local bar_edge_fraction = bar_edge_fraction_2

			::label_8_0::

			return bar_edge_fraction ~= 1
		end
	}
	content[bar_edge_name] = "boss_hp_bar_edge"
	style[bar_edge_name] = {
		color = table.clone(default_color),
		default_width_offset = 7 * detail_scale,
		offset = {
			0,
			bar_y,
			4
		},
		size = {
			13 * detail_scale,
			14 * detail_scale
		}
	}

	if not is_additional then
		local title_y = 4
		local title_text = "title_text"

		passes[#passes + 1] = {
			pass_type = "text",
			text_id = title_text,
			style_id = title_text,
			retained_mode = retained_mode
		}
		content[title_text] = ""
		style[title_text] = {
			vertical_alignment = "top",
			upper_case = false,
			horizontal_alignment = "left",
			font_size = 24,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				reference_x + 4,
				4 + bar_y_offset,
				7
			}
		}

		local title_text_shadow = "title_text_shadow_shadow"

		passes[#passes + 1] = {
			pass_type = "text",
			text_id = title_text,
			style_id = title_text_shadow,
			retained_mode = retained_mode
		}
		content[title_text_shadow] = ""
		style[title_text_shadow] = {
			vertical_alignment = "top",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 24,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				reference_x + 6,
				title_y - 2 + bar_y_offset,
				6
			}
		}
	end

	widget.element.passes = passes
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = "pivot"

	return widget
end

return {
	scenegraph_definition = scenegraph_definition,
	widget_create_func = create_health_bar_widget,
	total_bar_length = total_bar_length
}
