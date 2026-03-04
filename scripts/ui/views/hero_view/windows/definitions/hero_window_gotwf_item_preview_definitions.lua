-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_item_preview_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	800,
	600
}
local var_0_2 = {
	800,
	220
}
local var_0_3 = {
	16,
	var_0_1[2] + 100
}
local var_0_4 = {
	screen = var_0_0.screen,
	background = {
		scale = "fit_height",
		horizontal_alignment = "center",
		size = {
			960,
			1080
		},
		position = {
			0,
			0,
			UILayer.default + 100
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "right",
		size = {
			960,
			740
		},
		position = {
			0,
			-190,
			0
		}
	},
	window = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			960,
			732
		},
		position = {
			0,
			0,
			1
		}
	},
	viewport = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			600,
			500
		},
		position = {
			0,
			-115,
			1
		}
	},
	viewport_mask_top_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			146,
			152
		},
		position = {
			0,
			0,
			100
		}
	},
	viewport_mask_bottom_left = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			146,
			152
		},
		position = {
			0,
			0,
			100
		}
	},
	viewport_mask_top_right = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			146,
			152
		},
		position = {
			0,
			0,
			100
		}
	},
	viewport_mask_bottom_right = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			146,
			152
		},
		position = {
			0,
			0,
			100
		}
	},
	item_texture = {
		vertical_alignment = "center",
		parent = "viewport",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		}
	},
	loading_icon = {
		vertical_alignment = "center",
		parent = "viewport",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			0,
			10
		}
	},
	disclaimer_text = {
		vertical_alignment = "bottom",
		parent = "viewport",
		horizontal_alignment = "center",
		size = {
			700,
			60
		},
		position = {
			0,
			120,
			10
		}
	},
	disclaimer_divider = {
		vertical_alignment = "center",
		parent = "disclaimer_text",
		horizontal_alignment = "center",
		size = {
			13,
			13
		},
		position = {
			0,
			0,
			0
		}
	},
	amount_text = {
		vertical_alignment = "bottom",
		parent = "viewport",
		horizontal_alignment = "center",
		size = {
			260,
			60
		},
		position = {
			0,
			85,
			10
		}
	},
	info_anchor = {
		parent = "window",
		position = {
			0,
			0,
			0
		}
	},
	claimed = {
		vertical_alignment = "top",
		parent = "info_anchor",
		horizontal_alignment = "right",
		size = {
			490,
			60
		},
		position = {
			350,
			-180,
			8
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "claimed",
		horizontal_alignment = "right",
		size = {
			550,
			60
		},
		position = {
			0,
			-60,
			8
		}
	},
	sub_title_text = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			550,
			30
		},
		position = {
			0,
			-45,
			1
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			550,
			30
		},
		position = {
			0,
			-45,
			1
		}
	},
	profile_title_text = {
		vertical_alignment = "bottom",
		parent = "sub_title_text",
		horizontal_alignment = "center",
		size = {
			550,
			30
		},
		position = {
			0,
			-35,
			1
		}
	},
	career_title_text = {
		vertical_alignment = "bottom",
		parent = "profile_title_text",
		horizontal_alignment = "center",
		size = {
			550,
			30
		},
		position = {
			0,
			-35,
			1
		}
	}
}
local var_0_5 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 64,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_6 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_7 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = false,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_8 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_9 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		255,
		255,
		255
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_11 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		255,
		255,
		255
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_12 = {
	loading_icon = {
		scenegraph_id = "loading_icon",
		element = {
			passes = {
				{
					style_id = "texture_id",
					pass_type = "rotated_texture",
					texture_id = "texture_id",
					content_change_function = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
						local var_1_0 = ((arg_1_1.progress or 0) + arg_1_3) % 1

						arg_1_1.angle = math.pow(2, math.smoothstep(var_1_0, 0, 1)) * (math.pi * 2)
						arg_1_1.progress = var_1_0
					end
				}
			}
		},
		content = {
			texture_id = "loot_loading"
		},
		style = {
			texture_id = {
				angle = 0,
				pivot = {
					75,
					75
				},
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

local function var_0_13(arg_2_0)
	local var_2_0 = "menu_frame_08"
	local var_2_1 = UIFrameSettings[var_2_0]
	local var_2_2 = var_2_1.texture_sizes.horizontal[2]
	local var_2_3 = {
		element = {}
	}
	local var_2_4 = {
		{
			style_id = "painting",
			pass_type = "texture_uv",
			content_id = "painting",
			content_check_function = function(arg_3_0)
				return arg_3_0.texture_id
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "painting_frame",
			texture_id = "painting_frame",
			content_check_function = function(arg_4_0)
				return arg_4_0.painting
			end
		}
	}
	local var_2_5 = {
		painting_frame = var_2_1.texture
	}
	local var_2_6 = {
		painting = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				7
			}
		},
		painting_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = var_2_1.texture_size,
			texture_sizes = var_2_1.texture_sizes,
			frame_margins = {
				-var_2_2,
				-var_2_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				12
			}
		}
	}

	var_2_3.element.passes = var_2_4
	var_2_3.content = var_2_5
	var_2_3.style = var_2_6
	var_2_3.offset = {
		0,
		0,
		5
	}
	var_2_3.scenegraph_id = "item_texture"

	return var_2_3
end

local function var_0_14(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = UIFrameSettings.frame_outer_glow_04_big.texture_sizes.horizontal[2]
	local var_5_1 = {
		passes = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				style_id = "list_hotspot",
				pass_type = "hotspot",
				content_id = "list_hotspot"
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture"
			},
			{
				pass_type = "texture",
				style_id = "mask_top",
				texture_id = "mask_edge"
			},
			{
				pass_type = "rotated_texture",
				style_id = "mask_bottom",
				texture_id = "mask_edge"
			}
		}
	}
	local var_5_2 = {
		mask_edge = "mask_rect_edge_fade",
		mask_texture = "mask_rect",
		list_hotspot = {},
		button_hotspot = {},
		scrollbar = {
			scroll_amount = 0.1,
			percentage = 0.1,
			scroll_value = 1
		}
	}
	local var_5_3 = {
		hotspot = {
			size = {
				arg_5_2[1],
				arg_5_2[2]
			},
			offset = {
				0,
				0,
				0
			}
		},
		list_hotspot = {
			size = {
				arg_5_2[1] + var_5_0 * 2,
				arg_5_2[2] + var_5_0 * 2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_5_0,
				-var_5_0,
				0
			}
		},
		mask = {
			size = {
				arg_5_2[1] + var_5_0 * 2,
				arg_5_2[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_5_0,
				0,
				0
			}
		},
		mask_top = {
			size = {
				arg_5_2[1] + var_5_0 * 2,
				var_5_0
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_5_0,
				arg_5_2[2],
				0
			}
		},
		mask_bottom = {
			size = {
				arg_5_2[1] + var_5_0 * 2,
				var_5_0
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_5_0,
				-var_5_0,
				0
			},
			angle = math.pi,
			pivot = {
				(arg_5_2[1] + var_5_0 * 2) / 2,
				var_5_0 / 2
			}
		}
	}

	return {
		element = var_5_1,
		content = var_5_2,
		style = var_5_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_5_0
	}
end

local function var_0_15(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8)
	if type(arg_6_5) ~= "table" then
		arg_6_5 = {
			0,
			0,
			arg_6_5 or 0
		}
	end

	if arg_6_6 == "native" then
		local var_6_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_6_0).size

		arg_6_6 = {
			var_6_0[1],
			var_6_0[2]
		}
	end

	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = arg_6_3,
					content_check_function = function(arg_7_0)
						return arg_7_0.texture_id
					end
				}
			}
		},
		content = {
			texture_id = arg_6_0,
			disable_with_gamepad = arg_6_7
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = arg_6_4 or {
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
				masked = arg_6_2,
				texture_size = arg_6_6,
				viewport_mask = arg_6_8
			}
		},
		offset = arg_6_5,
		scenegraph_id = arg_6_1
	}
end

local var_0_16 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	font_size = 32,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		255,
		255,
		255,
		255
	},
	offset = {
		0,
		0,
		1
	}
}
local var_0_17 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	font_size = 32,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		255,
		0,
		0,
		0
	},
	offset = {
		2,
		-2,
		0
	}
}

local function var_0_18(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2 = arg_8_2 or 1

	local var_8_0 = arg_8_1 or "default"
	local var_8_1 = UIPlayerPortraitFrameSettings[var_8_0]
	local var_8_2 = {
		255,
		255,
		255,
		255
	}
	local var_8_3 = {
		0,
		0,
		0
	}
	local var_8_4 = {
		element = {}
	}
	local var_8_5 = {}
	local var_8_6 = {
		scale = arg_8_2,
		frame_settings_name = var_8_0
	}
	local var_8_7 = {}

	for iter_8_0, iter_8_1 in ipairs(var_8_1) do
		local var_8_8 = "texture_" .. iter_8_0
		local var_8_9 = iter_8_1.texture or "icons_placeholder"
		local var_8_10 = iter_8_1.size

		if UIAtlasHelper.has_atlas_settings_by_texture_name(var_8_9) then
			var_8_10 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_8_9).size
		else
			var_8_10 = iter_8_1.size
		end

		local var_8_11

		var_8_11 = var_8_10 and table.clone(var_8_10) or {
			0,
			0
		}
		var_8_11[1] = var_8_11[1] * arg_8_2
		var_8_11[2] = var_8_11[2] * arg_8_2

		local var_8_12 = table.clone(iter_8_1.offset or var_8_3)

		var_8_12[1] = var_8_12[1] * arg_8_2
		var_8_12[2] = var_8_12[2] * arg_8_2
		var_8_12[3] = iter_8_1.layer or 0
		var_8_5[#var_8_5 + 1] = {
			pass_type = "texture",
			texture_id = var_8_8,
			style_id = var_8_8
		}
		var_8_6[var_8_8] = var_8_9
		var_8_7[var_8_8] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = iter_8_1.color or var_8_2,
			offset = var_8_12,
			texture_size = var_8_11
		}
	end

	var_8_4.element.passes = var_8_5
	var_8_4.content = var_8_6
	var_8_4.style = var_8_7
	var_8_4.offset = {
		0,
		0,
		0
	}
	var_8_4.scenegraph_id = arg_8_0

	return var_8_4
end

local function var_0_19(arg_9_0)
	local var_9_0 = string.gsub(Localize("search_filter_claimed"), "^%l", string.upper)
	local var_9_1 = 32
	local var_9_2 = "hell_shark_header"
	local var_9_3, var_9_4 = UIFontByResolution(var_0_16)
	local var_9_5, var_9_6, var_9_7 = UIRenderer.text_size(arg_9_0, var_9_0, var_9_3[1], var_9_4)
	local var_9_8 = Localize("event_gotwf_already_owned")
	local var_9_9, var_9_10, var_9_11 = UIRenderer.text_size(arg_9_0, var_9_8, var_9_3[1], var_9_4)
	local var_9_12 = var_0_4.claimed.size[1]
	local var_9_13 = math.min(var_9_5, var_9_12)
	local var_9_14 = math.min(var_9_9, var_9_12)

	return {
		scenegraph_id = "claimed",
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_10_0)
						return not arg_10_0.already_owned
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_11_0)
						return not arg_11_0.already_owned
					end
				},
				{
					style_id = "background",
					pass_type = "rect",
					content_check_function = function(arg_12_0)
						return not arg_12_0.already_owned
					end
				},
				{
					texture_id = "sigil",
					style_id = "sigil",
					pass_type = "texture",
					content_check_function = function(arg_13_0)
						return not arg_13_0.already_owned
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "owned_text",
					content_check_function = function(arg_14_0)
						return arg_14_0.already_owned
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "owned_text",
					content_check_function = function(arg_15_0)
						return arg_15_0.already_owned
					end
				},
				{
					style_id = "background_owned",
					pass_type = "rect",
					content_check_function = function(arg_16_0)
						return arg_16_0.already_owned
					end
				},
				{
					pass_type = "texture",
					style_id = "sigil_owned",
					texture_id = "sigil",
					content_check_function = function(arg_17_0)
						return arg_17_0.already_owned
					end
				}
			}
		},
		content = {
			already_owned = true,
			sigil = "store_owned_sigil",
			text = var_9_0,
			owned_text = var_9_8
		},
		style = {
			text = var_0_16,
			text_shadow = var_0_17,
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					var_9_13 + 35,
					35
				},
				color = {
					192,
					0,
					0,
					0
				},
				offset = {
					10,
					2,
					0
				}
			},
			sigil = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					53,
					53
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_9_13,
					0,
					5
				}
			},
			background_owned = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					var_9_14 + 35,
					35
				},
				color = {
					192,
					0,
					0,
					0
				},
				offset = {
					10,
					2,
					0
				}
			},
			sigil_owned = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					53,
					53
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_9_14,
					0,
					5
				}
			}
		},
		offset = {
			-10,
			0,
			0
		}
	}
end

local var_0_20 = false
local var_0_21 = {
	disclaimer_divider = UIWidgets.create_simple_texture("tooltip_marker_gold", "disclaimer_divider"),
	disclaimer_text = UIWidgets.create_simple_text(Localize("menu_store_product_hero_skin_disclaimer_desc"), "disclaimer_text", nil, nil, var_0_10),
	amount_text = UIWidgets.create_simple_text("", "amount_text", nil, nil, var_0_11),
	title_text = UIWidgets.create_simple_text("", "title_text", nil, nil, var_0_5),
	type_title_text = UIWidgets.create_simple_text("", "sub_title_text", nil, nil, var_0_8),
	sub_title_text = UIWidgets.create_simple_text("", "profile_title_text", nil, nil, var_0_6),
	description_text = UIWidgets.create_simple_text("", "profile_title_text", nil, nil, var_0_7),
	career_title_text = UIWidgets.create_simple_text("", "career_title_text", nil, nil, var_0_9),
	viewport_button = UIWidgets.create_simple_hotspot("viewport")
}
local var_0_22 = {
	on_enter = {
		{
			name = "delay",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end,
			update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				return
			end,
			on_complete = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				arg_21_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				local var_22_0 = math.easeOutCubic(arg_22_3)

				arg_22_4.render_settings.alpha_multiplier = var_22_0
			end,
			on_complete = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end
		}
	},
	info_animation = {
		{
			name = "animate_in",
			start_progress = 0.3,
			end_progress = 0.8,
			init = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				arg_24_2.claimed.alpha_multiplier = 0
				arg_24_2.title_text.alpha_multiplier = 0
				arg_24_2.type_title_text.alpha_multiplier = 0
				arg_24_2.sub_title_text.alpha_multiplier = 0
				arg_24_2.career_title_text.alpha_multiplier = 0
				arg_24_2.description_text.alpha_multiplier = 0
				arg_24_0.info_anchor.local_position[1] = arg_24_1.info_anchor.position[1] + 50
			end,
			update = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				local var_25_0 = math.easeOutCubic(arg_25_3)

				arg_25_0.info_anchor.local_position[1] = math.lerp(arg_25_1.info_anchor.position[1] + 50, arg_25_1.info_anchor.position[1], var_25_0)
				arg_25_2.claimed.alpha_multiplier = var_25_0
				arg_25_2.title_text.alpha_multiplier = var_25_0
				arg_25_2.type_title_text.alpha_multiplier = var_25_0
				arg_25_2.sub_title_text.alpha_multiplier = var_25_0
				arg_25_2.career_title_text.alpha_multiplier = var_25_0
				arg_25_2.description_text.alpha_multiplier = var_25_0
			end,
			on_complete = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end
		}
	}
}

return {
	top_widgets = var_0_21,
	loading_widgets = var_0_12,
	create_claimed_widget = var_0_19,
	create_painting_widget = var_0_13,
	create_texture_widget = var_0_15,
	generic_input_actions = generic_input_actions,
	scenegraph_definition = var_0_4,
	animation_definitions = var_0_22
}
