-- chunkname: @scripts/ui/views/tutorial_ui_definitions.lua

local var_0_0 = true
local var_0_1 = local_require("scripts/ui/views/tutorial_ui_animation_definitions")
local var_0_2 = {
	500,
	500
}
local var_0_3 = {
	450,
	66
}
local var_0_4 = 30
local var_0_5 = {
	584,
	138
}
local var_0_6 = {
	450,
	62
}
local var_0_7 = 20
local var_0_8 = 4
local var_0_9 = 10
local var_0_10 = 6
local var_0_11 = {
	64,
	64
}
local var_0_12 = {
	137,
	7
}
local var_0_13 = {
	147,
	17
}
local var_0_14 = {
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
			var_0_3[1],
			var_0_3[2] / 2
		},
		position = {
			0,
			var_0_3[2] / 2,
			2
		}
	},
	info_slate_mask = {
		vertical_alignment = "top",
		parent = "info_slate_root",
		size = {
			var_0_3[1] + 30,
			550
		},
		position = {
			0,
			180,
			0
		}
	}
}

for iter_0_0 = 1, 3 do
	local var_0_15 = string.format("info_slate_slot%d_start", iter_0_0)
	local var_0_16 = string.format("info_slate_slot%d_end", iter_0_0)
	local var_0_17 = (iter_0_0 - 1) * (var_0_3[2] + var_0_4)

	var_0_14[var_0_15] = {
		parent = "info_slate_mission_goal_end",
		size = {
			var_0_3[1],
			var_0_3[2]
		},
		position = {
			0,
			-var_0_17,
			1
		}
	}
	var_0_14[var_0_16] = {
		parent = "info_slate_mission_goal_end",
		size = {
			var_0_3[1],
			var_0_3[2] / 2
		},
		position = {
			0,
			-var_0_17,
			2
		}
	}
end

local var_0_18 = {
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
						return arg_1_1.color[1] > 0
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_2_0)
						return arg_2_0.text
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_3_0)
						return arg_3_0.text
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
local var_0_19 = {
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
			var_0_11[1],
			var_0_11[2]
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

local function var_0_20(arg_4_0)
	local var_4_0 = {}

	for iter_4_0 = 1, arg_4_0 do
		local var_4_1 = "health_bar_" .. iter_4_0

		var_0_19[var_4_1] = {
			parent = "screen_fit",
			position = {
				0,
				0,
				1
			},
			size = var_0_12
		}
		var_4_0[iter_4_0] = {
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
					size = var_0_13,
					offset = {
						-var_0_13[1] / 2,
						0,
						1
					},
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = var_4_1
				},
				texture_fg = {
					size = var_0_12,
					offset = {
						-var_0_12[1] / 2,
						5,
						1
					},
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = var_4_1
				}
			},
			scenegraph_id = var_4_1
		}
	end

	return var_4_0
end

local function var_0_21(arg_5_0)
	local var_5_0 = {}

	for iter_5_0 = 1, arg_5_0 do
		local var_5_1 = "info_slate_entry_anchor" .. iter_5_0
		local var_5_2 = "info_slate_entry_root" .. iter_5_0
		local var_5_3 = var_5_2 .. "_text"
		local var_5_4 = var_5_2 .. "_icon_root"
		local var_5_5 = var_5_2 .. "_icon"
		local var_5_6 = var_5_2 .. "_top_frame"
		local var_5_7 = var_5_2 .. "_bottom_frame"
		local var_5_8 = var_5_2 .. "_frame_details"
		local var_5_9 = var_5_2 .. "_frame_glow_top"
		local var_5_10 = var_5_2 .. "_frame_glow_bottom"

		var_0_14[var_5_2] = {
			parent = "info_slate_root",
			position = {
				-var_0_3[1],
				0,
				1
			},
			size = {
				var_0_3[1],
				var_0_3[2]
			}
		}
		var_0_14[var_5_4] = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			parent = var_5_2,
			position = {
				-var_0_3[1] / 2 + 30,
				0,
				0
			},
			size = {
				62,
				62
			}
		}
		var_0_14[var_5_5] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = var_5_4,
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
		var_0_14[var_5_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_5_2,
			position = {
				2,
				0,
				1
			},
			size = {
				var_0_3[1] - 62,
				var_0_3[2]
			}
		}
		var_0_14[var_5_6] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			parent = var_5_2,
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
		var_0_14[var_5_7] = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			parent = var_5_2,
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
		var_0_14[var_5_9] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			parent = var_5_2,
			position = {
				-105,
				108,
				5
			},
			size = {
				var_0_5[1],
				var_0_5[2]
			}
		}
		var_0_14[var_5_10] = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			parent = var_5_2,
			position = {
				-105,
				-108,
				5
			},
			size = {
				var_0_5[1],
				var_0_5[2]
			}
		}

		local var_5_11 = {
			0,
			0,
			0
		}
		local var_5_12 = {
			element = {
				passes = {
					{
						style_id = "background_texture",
						pass_type = "texture_uv_dynamic_color_uvs_size_offset",
						content_id = "background_texture",
						dynamic_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
							local var_6_0 = arg_6_0.fraction
							local var_6_1 = arg_6_1.uv_start_pixels + arg_6_1.uv_scale_pixels * var_6_0
							local var_6_2 = arg_6_1.uvs
							local var_6_3 = arg_6_1.scale_axis
							local var_6_4 = arg_6_1.offset_scale

							var_6_2[1][var_6_3] = 1 - var_6_0
							arg_6_2[var_6_3] = var_6_1

							return arg_6_1.color, var_6_2, arg_6_2, var_5_11
						end
					},
					{
						style_id = "icon_texture",
						pass_type = "texture_uv_dynamic_color_uvs_size_offset",
						content_id = "icon_texture",
						dynamic_function = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
							local var_7_0 = arg_7_0.fraction
							local var_7_1 = arg_7_1.color
							local var_7_2 = arg_7_1.uv_start_pixels
							local var_7_3 = arg_7_1.uv_scale_pixels
							local var_7_4 = var_7_2 + var_7_3 * var_7_0
							local var_7_5 = arg_7_1.uvs
							local var_7_6 = arg_7_1.scale_axis
							local var_7_7 = (1 - var_7_4 / (var_7_2 + var_7_3)) * 0.5

							var_7_5[1][var_7_6] = var_7_7
							var_7_5[2][var_7_6] = 1 - var_7_7

							return var_7_1, var_7_5, arg_7_2, arg_7_1.offset
						end
					},
					{
						style_id = "description_text",
						pass_type = "text",
						text_id = "description_text",
						retained_mode = false,
						content_check_function = function (arg_8_0, arg_8_1)
							if arg_8_0.icon_texture then
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
						retained_mode = var_0_0,
						content_check_function = function (arg_9_0)
							return arg_9_0.top_frame_texture
						end
					},
					{
						pass_type = "texture",
						style_id = "bottom_frame_texture",
						texture_id = "bottom_frame_texture",
						retained_mode = var_0_0,
						content_check_function = function (arg_10_0)
							return arg_10_0.bottom_frame_texture
						end
					},
					{
						pass_type = "texture",
						style_id = "frame_glow_top_texture",
						texture_id = "frame_glow_top_texture",
						retained_mode = var_0_0,
						content_check_function = function (arg_11_0)
							return arg_11_0.frame_glow_top_texture
						end
					},
					{
						pass_type = "texture",
						style_id = "frame_glow_bottom_texture",
						texture_id = "frame_glow_bottom_texture",
						retained_mode = var_0_0,
						content_check_function = function (arg_12_0)
							return arg_12_0.frame_glow_bottom_texture
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
					scenegraph_id = var_5_5,
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
					scenegraph_id = var_5_3
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
					scenegraph_id = var_5_2,
					color = {
						255,
						66,
						31,
						17
					},
					uv_scale_pixels = var_0_3[1],
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
					scenegraph_id = var_5_6
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
					scenegraph_id = var_5_7
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
					scenegraph_id = var_5_9
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
					scenegraph_id = var_5_10
				}
			},
			scenegraph_id = var_5_2
		}

		for iter_5_1, iter_5_2 in pairs(var_5_12.style) do
			if iter_5_2.color then
				iter_5_2.default_alpha = iter_5_2.color[1]
			end
		end

		var_5_0[#var_5_0 + 1] = var_5_12
	end

	return var_5_0
end

local function var_0_22(arg_13_0)
	local var_13_0 = {}

	for iter_13_0 = 1, arg_13_0 do
		local var_13_1 = "objective_tooltip_root_" .. iter_13_0
		local var_13_2 = "objective_tooltip_" .. iter_13_0
		local var_13_3 = "objective_tooltip_text" .. iter_13_0
		local var_13_4 = "objective_tooltip_icon" .. iter_13_0
		local var_13_5 = "objective_tooltip_arrow" .. iter_13_0

		var_0_19[var_13_1] = {
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
		var_0_19[var_13_2] = {
			vertical_alignment = "bottom",
			parent = var_13_1,
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
		var_0_19[var_13_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			parent = var_13_4,
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
		var_0_19[var_13_4] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = var_13_2,
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
		var_0_19[var_13_5] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = var_13_4,
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
		var_13_0[iter_13_0] = {
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
							return arg_14_1.color[1] > 0
						end
					},
					{
						style_id = "text",
						pass_type = "text",
						text_id = "text",
						content_check_function = function (arg_15_0)
							return arg_15_0.text
						end
					},
					{
						style_id = "text_shadow",
						pass_type = "text",
						text_id = "text",
						content_check_function = function (arg_16_0)
							return arg_16_0.text
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
					scenegraph_id = var_13_3
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
					scenegraph_id = var_13_3
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
					scenegraph_id = var_13_4,
					size = var_0_11
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
					scenegraph_id = var_13_5
				}
			},
			scenegraph_id = var_13_2
		}
	end

	return var_13_0
end

local var_0_23 = var_0_21(var_0_8)
local var_0_24 = var_0_20(var_0_9)
local var_0_25 = var_0_22(var_0_10)

return {
	scenegraph = var_0_14,
	floating_icons_scene_graph = var_0_19,
	widgets = var_0_18,
	INFO_SLATE_SIZE = var_0_2,
	INFO_SLATE_ENTRY_SIZE = var_0_3,
	INFO_SLATE_ENTRY_SPACING = var_0_4,
	INFO_SLATE_ENTRY_HEIGHT_SPACING = var_0_7,
	NUMBER_OF_INFO_SLATE_ENTRIES = var_0_8,
	tutorial_icons = tutorial_icons,
	info_slate_entries = var_0_23,
	health_bar_definitions = var_0_24,
	NUMBER_OF_HEALTH_BARS = var_0_9,
	objective_tooltips = var_0_25,
	NUMBER_OF_OBJECTIVE_TOOLTIPS = var_0_10,
	FLOATING_ICON_SIZE = var_0_11,
	animations = var_0_1
}
