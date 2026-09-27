-- chunkname: @scripts/ui/views/tutorial_ui_definitions.lua

local flag = true
local var_0_1 = local_require("scripts/ui/views/tutorial_ui_animation_definitions")
local tbl = {
	500,
	500
}
local tbl_2 = {
	450,
	66
}
local num = 30
local tbl_3 = {
	584,
	138
}
local tbl_4 = {
	450,
	62
}
local num_2 = 20
local num_3 = 4
local num_4 = 10
local num_5 = 6
local tbl_5 = {
	64,
	64
}
local tbl_6 = {
	137,
	7
}
local tbl_7 = {
	147,
	17
}
local tbl_8 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.tutorial
		}
	},
	center_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	screen_fit = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.tutorial
		},
		size = {
			1920,
			1080
		}
	},
	tooltip_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			3,
			3
		}
	},
	tooltip = {
		vertical_alignment = "bottom",
		parent = "tooltip_root",
		position = {
			0,
			-120,
			1
		},
		size = {
			200,
			40
		}
	},
	info_slate_root = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1,
			1
		},
		position = {
			0,
			240,
			2
		}
	},
	info_slate_mission_goal_end = {
		parent = "info_slate_root",
		size = {
			tbl_2[1],
			tbl_2[2] / 2
		},
		position = {
			0,
			tbl_2[2] / 2,
			2
		}
	},
	info_slate_mask = {
		vertical_alignment = "top",
		parent = "info_slate_root",
		size = {
			tbl_2[1] + 30,
			550
		},
		position = {
			0,
			180,
			0
		}
	}
}

for i = 1, 3 do
	local format = string.format("info_slate_slot%d_start", i)
	local format_2 = string.format("info_slate_slot%d_end", i)
	local num_6 = (i - 1) * (tbl_2[2] + num)

	tbl_8[format] = {
		parent = "info_slate_mission_goal_end",
		size = {
			tbl_2[1],
			tbl_2[2]
		},
		position = {
			0,
			-num_6,
			1
		}
	}
	tbl_8[format_2] = {
		parent = "info_slate_mission_goal_end",
		size = {
			tbl_2[1],
			tbl_2[2] / 2
		},
		position = {
			0,
			-num_6,
			2
		}
	}
end

local tbl_9 = {
	tooltip_mission = {
		scenegraph_id = "tooltip",
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					texture_id = "arrow",
					style_id = "arrow",
					pass_type = "rotated_texture",
					content_check_function = function (arg_1_0, arg_1_1)
						-- function 1
						return arg_1_1.color[1] > 0
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 2
						return self.text
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 3
						return self.text
					end
				}
			}
		},
		content = {
			text = "tooltip_text",
			texture_id = "hud_tutorial_icon_info",
			arrow = "indicator"
		},
		style = {
			text = {
				font_size = 30,
				scenegraph_id = "tooltip_mission_text",
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			text_shadow = {
				font_size = 30,
				scenegraph_id = "tooltip_mission_text",
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					0
				}
			},
			texture_id = {
				scenegraph_id = "tooltip_mission_icon",
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			arrow = {
				scenegraph_id = "tooltip_mission_arrow",
				angle = 0,
				pivot = {
					19,
					9
				},
				offset = {
					0,
					0,
					1
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		}
	},
	info_slate_mask = {
		scenegraph_id = "info_slate_mask",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "mask_rect"
		},
		style = {
			color = {
				255,
				255,
				255,
				255
			}
		}
	}
}
local tbl_10 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.tutorial
		}
	},
	screen_fit = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.tutorial
		},
		size = {
			1920,
			1080
		}
	},
	tooltip_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			3,
			3
		}
	},
	tooltip = {
		vertical_alignment = "bottom",
		parent = "tooltip_root",
		position = {
			0,
			-120,
			1
		},
		size = {
			200,
			40
		}
	},
	tooltip_mission_root = {
		parent = "root",
		position = {
			0,
			0,
			0
		},
		size = {
			3,
			3
		}
	},
	tooltip_mission = {
		vertical_alignment = "bottom",
		parent = "tooltip_mission_root",
		position = {
			0,
			0,
			1
		},
		size = {
			1,
			1
		}
	},
	tooltip_mission_text = {
		vertical_alignment = "center",
		parent = "tooltip_mission_icon",
		horizontal_alignment = "right",
		size = {
			400,
			62
		},
		position = {
			403,
			0,
			2
		}
	},
	tooltip_mission_icon = {
		vertical_alignment = "center",
		parent = "tooltip_mission",
		horizontal_alignment = "center",
		size = {
			tbl_5[1],
			tbl_5[2]
		},
		position = {
			0,
			0,
			3
		}
	},
	tooltip_mission_arrow = {
		vertical_alignment = "center",
		parent = "tooltip_mission_icon",
		horizontal_alignment = "center",
		size = {
			38,
			18
		},
		position = {
			0,
			0,
			2
		}
	}
}

local function fn(arg_4_0)
	-- function 4
	local tbl = {}

	for i = 1, arg_4_0 do
		local str = "health_bar_" .. i

		tbl_10[str] = {
			parent = "screen_fit",
			position = {
				0,
				0,
				1
			},
			size = tbl_6
		}
		tbl[i] = {
			element = {
				passes = {
					{
						texture_id = "texture_bg",
						style_id = "texture_bg",
						pass_type = "texture"
					},
					{
						texture_id = "texture_fg",
						style_id = "texture_fg",
						pass_type = "texture"
					}
				}
			},
			content = {
				texture_fg = "objective_hp_bar_fg_2",
				texture_bg = "objective_hp_bar_bg_2"
			},
			style = {
				texture_bg = {
					size = tbl_7,
					offset = {
						-tbl_7[1] / 2,
						0,
						1
					},
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = str
				},
				texture_fg = {
					size = tbl_6,
					offset = {
						-tbl_6[1] / 2,
						5,
						1
					},
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = str
				}
			},
			scenegraph_id = str
		}
	end

	return tbl
end

local function fn_2(arg_5_0)
	-- function 5
	local tbl = {}

	for i = 1, arg_5_0 do
		local str = "info_slate_entry_anchor" .. i
		local str_2 = "info_slate_entry_root" .. i
		local str_3 = str_2 .. "_text"
		local str_4 = str_2 .. "_icon_root"
		local str_5 = str_2 .. "_icon"
		local str_6 = str_2 .. "_top_frame"
		local str_7 = str_2 .. "_bottom_frame"
		local str_8 = str_2 .. "_frame_details"
		local str_9 = str_2 .. "_frame_glow_top"
		local str_10 = str_2 .. "_frame_glow_bottom"

		tbl_8[str_2] = {
			parent = "info_slate_root",
			position = {
				-tbl_2[1],
				0,
				1
			},
			size = {
				tbl_2[1],
				tbl_2[2]
			}
		}
		tbl_8[str_4] = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			parent = str_2,
			position = {
				-tbl_2[1] / 2 + 30,
				0,
				0
			},
			size = {
				62,
				62
			}
		}
		tbl_8[str_5] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = str_4,
			position = {
				0,
				0,
				1
			},
			size = {
				62,
				62
			}
		}
		tbl_8[str_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str_2,
			position = {
				2,
				0,
				1
			},
			size = {
				tbl_2[1] - 62,
				tbl_2[2]
			}
		}
		tbl_8[str_6] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			parent = str_2,
			position = {
				0,
				0,
				2
			},
			size = {
				450,
				4
			}
		}
		tbl_8[str_7] = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			parent = str_2,
			position = {
				0,
				0,
				2
			},
			size = {
				450,
				4
			}
		}
		tbl_8[str_9] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			parent = str_2,
			position = {
				-105,
				108,
				5
			},
			size = {
				tbl_3[1],
				tbl_3[2]
			}
		}
		tbl_8[str_10] = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			parent = str_2,
			position = {
				-105,
				-108,
				5
			},
			size = {
				tbl_3[1],
				tbl_3[2]
			}
		}

		local tbl_4 = {
			0,
			0,
			0
		}
		local tbl_5 = {
			element = {
				passes = {
					{
						style_id = "background_texture",
						pass_type = "texture_uv_dynamic_color_uvs_size_offset",
						content_id = "background_texture",
						dynamic_function = function (self, arg_6_1, arg_6_2, arg_6_3)
							-- function 6
							local fraction = self.fraction
							local num = arg_6_1.uv_start_pixels + arg_6_1.uv_scale_pixels * fraction
							local uvs = arg_6_1.uvs
							local scale_axis = arg_6_1.scale_axis
							local offset_scale = arg_6_1.offset_scale

							uvs[1][scale_axis] = 1 - fraction
							arg_6_2[scale_axis] = num

							return arg_6_1.color, uvs, arg_6_2, tbl_4
						end
					},
					{
						style_id = "icon_texture",
						pass_type = "texture_uv_dynamic_color_uvs_size_offset",
						content_id = "icon_texture",
						dynamic_function = function (self, arg_7_1, arg_7_2, arg_7_3)
							-- function 7
							local fraction = self.fraction
							local color = arg_7_1.color
							local uv_start_pixels = arg_7_1.uv_start_pixels
							local uv_scale_pixels = arg_7_1.uv_scale_pixels
							local num = uv_start_pixels + uv_scale_pixels * fraction
							local uvs = arg_7_1.uvs
							local scale_axis = arg_7_1.scale_axis
							local num_2 = (1 - num / (uv_start_pixels + uv_scale_pixels)) * 0.5

							uvs[1][scale_axis] = num_2
							uvs[2][scale_axis] = 1 - num_2

							return color, uvs, arg_7_2, arg_7_1.offset
						end
					},
					{
						style_id = "description_text",
						pass_type = "text",
						text_id = "description_text",
						retained_mode = false,
						content_check_function = function (self, arg_8_1)
							-- function 8
							if not self.icon_texture then
								arg_8_1.offset[1] = 78
							else
								arg_8_1.offset[1] = 0
							end

							return true
						end
					},
					{
						pass_type = "texture",
						style_id = "top_frame_texture",
						texture_id = "top_frame_texture",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 9
							return self.top_frame_texture
						end
					},
					{
						pass_type = "texture",
						style_id = "bottom_frame_texture",
						texture_id = "bottom_frame_texture",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 10
							return self.bottom_frame_texture
						end
					},
					{
						pass_type = "texture",
						style_id = "frame_glow_top_texture",
						texture_id = "frame_glow_top_texture",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 11
							return self.frame_glow_top_texture
						end
					},
					{
						pass_type = "texture",
						style_id = "frame_glow_bottom_texture",
						texture_id = "frame_glow_bottom_texture",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 12
							return self.frame_glow_bottom_texture
						end
					}
				}
			},
			content = {
				frame_details_texture = "infoslate_frame_detail",
				frame_glow_top_texture = "infoslate_glow_top",
				top_frame_texture = "infoslate_frame_horizontal",
				frame_glow_bottom_texture = "infoslate_glow_bottom",
				bottom_frame_texture = "infoslate_frame_horizontal",
				description_text = "",
				background_texture = {
					texture_id = "infoslate_bg_white",
					fraction = 0.5
				},
				frame_glow_uv_texture = {
					fraction = 0
				},
				icon_texture = {
					texture_id = "hud_tutorial_icon_info",
					fraction = 0
				}
			},
			style = {
				icon_texture = {
					masked = true,
					uv_scale_pixels = 62,
					uv_start_pixels = 0,
					offset_scale = 1,
					scale_axis = 2,
					scenegraph_id = str_5,
					color = {
						255,
						255,
						255,
						255
					},
					offset = {
						0,
						0,
						0
					},
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
				},
				description_text = {
					font_size = 24,
					word_wrap = true,
					pixel_perfect = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark_masked",
					offset = {
						0,
						0,
						0
					},
					text_color = Colors.get_color_table_with_alpha("white", 255),
					scenegraph_id = str_3
				},
				background_texture = {
					masked = true,
					background_component = true,
					uv_start_pixels = 0,
					offset_scale = 1,
					scale_axis = 1,
					offset = {
						0,
						0,
						0
					},
					scenegraph_id = str_2,
					color = {
						255,
						66,
						31,
						17
					},
					uv_scale_pixels = tbl_2[1],
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
				},
				top_frame_texture = {
					background_component = true,
					masked = true,
					offset = {
						-3,
						0,
						1
					},
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = str_6
				},
				bottom_frame_texture = {
					background_component = true,
					masked = true,
					offset = {
						-3,
						0,
						1
					},
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = str_7
				},
				frame_glow_top_texture = {
					masked = true,
					offset = {
						0,
						0,
						0
					},
					color = {
						0,
						255,
						255,
						255
					},
					scenegraph_id = str_9
				},
				frame_glow_bottom_texture = {
					masked = true,
					offset = {
						0,
						0,
						0
					},
					color = {
						0,
						255,
						255,
						255
					},
					scenegraph_id = str_10
				}
			},
			scenegraph_id = str_2
		}

		for k, v in pairs(tbl_5.style) do
			if not v.color then
				v.default_alpha = v.color[1]
			end
		end

		tbl[#tbl + 1] = tbl_5
	end

	return tbl
end

local function fn_3(arg_13_0)
	-- function 13
	local tbl = {}

	for i = 1, arg_13_0 do
		local str = "objective_tooltip_root_" .. i
		local str_2 = "objective_tooltip_" .. i
		local str_3 = "objective_tooltip_text" .. i
		local str_4 = "objective_tooltip_icon" .. i
		local str_5 = "objective_tooltip_arrow" .. i

		tbl_10[str] = {
			parent = "root",
			position = {
				0,
				0,
				0
			},
			size = {
				3,
				3
			}
		}
		tbl_10[str_2] = {
			vertical_alignment = "bottom",
			parent = str,
			position = {
				0,
				0,
				1
			},
			size = {
				1,
				1
			}
		}
		tbl_10[str_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			parent = str_4,
			size = {
				400,
				62
			},
			position = {
				403,
				0,
				2
			}
		}
		tbl_10[str_4] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = str_2,
			size = {
				62,
				62
			},
			position = {
				0,
				0,
				3
			}
		}
		tbl_10[str_5] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = str_4,
			size = {
				38,
				18
			},
			position = {
				0,
				0,
				2
			}
		}
		tbl[i] = {
			element = {
				passes = {
					{
						texture_id = "texture_id",
						style_id = "texture_id",
						pass_type = "texture"
					},
					{
						texture_id = "arrow",
						style_id = "arrow",
						pass_type = "rotated_texture",
						content_check_function = function (arg_14_0, arg_14_1)
							-- function 14
							return arg_14_1.color[1] > 0
						end
					},
					{
						style_id = "text",
						pass_type = "text",
						text_id = "text",
						content_check_function = function (self)
							-- function 15
							return self.text
						end
					},
					{
						style_id = "text_shadow",
						pass_type = "text",
						text_id = "text",
						content_check_function = function (self)
							-- function 16
							return self.text
						end
					}
				}
			},
			content = {
				text = "tooltip_text",
				texture_id = "hud_tutorial_icon_info",
				arrow = "indicator"
			},
			style = {
				text = {
					font_size = 30,
					pixel_perfect = false,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = false,
					allow_fractions = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", 255),
					offset = {
						0,
						0,
						1
					},
					scenegraph_id = str_3
				},
				text_shadow = {
					font_size = 30,
					pixel_perfect = false,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = false,
					allow_fractions = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("black", 255),
					offset = {
						2,
						-2,
						0
					},
					scenegraph_id = str_3
				},
				texture_id = {
					offset = {
						0,
						0,
						1
					},
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = str_4,
					size = tbl_5
				},
				arrow = {
					angle = 0,
					pivot = {
						19,
						9
					},
					offset = {
						0,
						0,
						1
					},
					color = {
						0,
						255,
						255,
						255
					},
					scenegraph_id = str_5
				}
			},
			scenegraph_id = str_2
		}
	end

	return tbl
end

local var_0_23 = fn_2(num_3)
local var_0_24 = fn(num_4)
local var_0_25 = fn_3(num_5)

return {
	scenegraph = tbl_8,
	floating_icons_scene_graph = tbl_10,
	widgets = tbl_9,
	INFO_SLATE_SIZE = tbl,
	INFO_SLATE_ENTRY_SIZE = tbl_2,
	INFO_SLATE_ENTRY_SPACING = num,
	INFO_SLATE_ENTRY_HEIGHT_SPACING = num_2,
	NUMBER_OF_INFO_SLATE_ENTRIES = num_3,
	tutorial_icons = tutorial_icons,
	info_slate_entries = var_0_23,
	health_bar_definitions = var_0_24,
	NUMBER_OF_HEALTH_BARS = num_4,
	objective_tooltips = var_0_25,
	NUMBER_OF_OBJECTIVE_TOOLTIPS = num_5,
	FLOATING_ICON_SIZE = tbl_5,
	animations = var_0_1
}
