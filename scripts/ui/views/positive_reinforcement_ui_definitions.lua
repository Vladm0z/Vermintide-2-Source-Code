-- chunkname: @scripts/ui/views/positive_reinforcement_ui_definitions.lua

local_require("scripts/ui/ui_widgets")

local var_0_0 = 18
local var_0_1 = 5
local var_0_2 = {
	root = {
		scale = "hud_scale_fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			1920,
			1080
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "right",
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
		parent = "message_animated",
		horizontal_alignment = "left",
		size = {
			232,
			68
		},
		position = {
			-41,
			-34,
			0
		}
	},
	message_animated = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		position = {
			-190,
			-60,
			1
		},
		size = {
			0,
			0
		}
	},
	message_animated_base = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		position = {
			-190,
			-60,
			1
		},
		size = {
			0,
			0
		}
	},
	message_animated_offset = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		position = {
			-465,
			-60,
			1
		},
		size = {
			0,
			0
		}
	}
}

if platform ~= "win32" then
	var_0_2.root.scale = "hud_fit"
	var_0_2.root.is_root = false
end

local var_0_3 = {
	message_animated = {
		scenegraph_id = "message_animated",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon_1",
					texture_id = "icon_1",
					content_check_function = function(arg_1_0)
						if not arg_1_0.icon_1 then
							return false
						end

						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_2",
					texture_id = "icon_2",
					content_check_function = function(arg_2_0)
						if not arg_2_0.icon_2 then
							return false
						end

						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_3",
					texture_id = "icon_3",
					content_check_function = function(arg_3_0)
						if not arg_3_0.icon_3 then
							return false
						end

						return true
					end
				}
			}
		},
		content = {
			text = "",
			icon_texture = "",
			message_tables = {}
		},
		style = {
			text = {
				vertical_alignment = "bottom",
				dynamic_font = true,
				horizontal_alignment = "right",
				font_type = "hell_shark",
				font_size = var_0_0,
				text_color = Colors.get_table("white"),
				offset = {
					0,
					-25,
					0
				}
			},
			icon_1 = {
				size = {
					50,
					50
				},
				offset = {
					0,
					0,
					0
				},
				color = Colors.get_table("white")
			},
			icon_2 = {
				size = {
					50,
					50
				},
				offset = {
					75,
					0,
					0
				},
				color = Colors.get_table("white")
			},
			icon_3 = {
				size = {
					50,
					50
				},
				offset = {
					150,
					0,
					0
				},
				color = Colors.get_table("white")
			}
		}
	}
}

local function var_0_4(arg_4_0)
	local var_4_0 = {}

	for iter_4_0 = 1, arg_4_0 do
		var_4_0[iter_4_0] = {
			scenegraph_id = "message_animated",
			element = {
				passes = {
					{
						pass_type = "texture",
						style_id = "icon_1",
						texture_id = "icon_1",
						content_check_function = function(arg_5_0)
							if not arg_5_0.icon_1 then
								return false
							end

							return true
						end
					},
					{
						pass_type = "texture",
						style_id = "icon_2",
						texture_id = "icon_2",
						content_check_function = function(arg_6_0)
							if not arg_6_0.icon_2 then
								return false
							end

							return true
						end
					},
					{
						pass_type = "texture",
						style_id = "icon_3",
						texture_id = "icon_3",
						content_check_function = function(arg_7_0)
							if not arg_7_0.icon_3 then
								return false
							end

							return true
						end
					}
				}
			},
			content = {
				text = "",
				icon_texture = "hud_tutorial_icon_info",
				message_tables = {}
			},
			style = {
				text = {
					vertical_alignment = "bottom",
					dynamic_font = true,
					horizontal_alignment = "right",
					font_type = "hell_shark",
					font_size = var_0_0,
					text_color = Colors.get_table("white"),
					offset = {
						0,
						-25,
						0
					}
				},
				icon_1 = {
					size = {
						50,
						50
					},
					offset = {
						0,
						0,
						0
					},
					color = Colors.get_table("white")
				},
				icon_2 = {
					size = {
						50,
						50
					},
					offset = {
						75,
						0,
						0
					},
					color = Colors.get_table("white")
				},
				icon_3 = {
					size = {
						50,
						50
					},
					offset = {
						150,
						0,
						0
					},
					color = Colors.get_table("white")
				}
			},
			offset = {
				0,
				0,
				0
			}
		}
	end

	return var_4_0
end

local function var_0_5(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_2 = arg_8_2 or 1

	local var_8_0 = UIPlayerPortraitFrameSettings[arg_8_1]
	local var_8_1 = {
		255,
		255,
		255,
		255
	}
	local var_8_2 = {
		0,
		0,
		0
	}
	local var_8_3 = {
		element = {}
	}
	local var_8_4 = {}
	local var_8_5 = {
		scale = arg_8_2,
		frame_settings_name = arg_8_1
	}
	local var_8_6 = {}
	local var_8_7 = {}
	local var_8_8 = 150
	local var_8_9 = "icon"

	var_8_4[#var_8_4 + 1] = {
		pass_type = "texture",
		texture_id = var_8_9,
		style_id = var_8_9,
		retained_mode = arg_8_3
	}
	var_8_5[var_8_9] = "icons_placeholder"
	var_8_6[var_8_9] = {
		color = table.clone(var_8_1),
		offset = {
			var_8_8 / 2 - 20 - 8,
			-20,
			2
		},
		size = {
			40,
			40
		}
	}
	var_8_7[#var_8_7 + 1] = var_8_9

	local var_8_10 = "background"

	var_8_4[#var_8_4 + 1] = {
		pass_type = "texture",
		texture_id = var_8_10,
		style_id = var_8_10,
		retained_mode = arg_8_3
	}
	var_8_5[var_8_10] = "reinforcement_background"
	var_8_6[var_8_10] = {
		color = table.clone(var_8_1),
		offset = {
			var_8_8 / 2 - 116,
			-34,
			0
		},
		size = {
			232,
			68
		}
	}
	var_8_7[#var_8_7 + 1] = var_8_10

	local var_8_11 = "arrow"

	var_8_4[#var_8_4 + 1] = {
		pass_type = "texture",
		texture_id = var_8_11,
		style_id = var_8_11,
		retained_mode = arg_8_3
	}
	var_8_5[var_8_11] = "reinforcement_arrow"
	var_8_6[var_8_11] = {
		color = table.clone(var_8_1),
		offset = {
			var_8_8 / 2 - 8,
			-13,
			1
		},
		size = {
			35,
			26
		}
	}
	var_8_7[#var_8_7 + 1] = var_8_11

	for iter_8_0 = 1, 2 do
		local var_8_12 = {
			(iter_8_0 - 1) * var_8_8,
			0,
			3
		}
		local var_8_13 = "icons_placeholder"
		local var_8_14 = {
			86,
			108
		}

		var_8_14[1] = var_8_14[1] * arg_8_2
		var_8_14[2] = var_8_14[2] * arg_8_2

		local var_8_15 = table.clone(var_8_2)

		var_8_15[1] = var_8_12[1] - var_8_14[1] / 2 + var_8_15[1] * arg_8_2
		var_8_15[2] = var_8_12[2] - var_8_14[2] / 2 + var_8_15[2] * arg_8_2
		var_8_15[3] = var_8_12[3]

		local var_8_16 = "portrait_" .. iter_8_0

		var_8_4[#var_8_4 + 1] = {
			pass_type = "texture_uv",
			content_id = var_8_16,
			style_id = var_8_16,
			retained_mode = arg_8_3
		}

		local var_8_17 = iter_8_0 == 1 and {
			{
				0,
				0
			},
			{
				1,
				1
			}
		} or {
			{
				1,
				0
			},
			{
				0,
				1
			}
		}

		var_8_5[var_8_16] = {
			texture_id = var_8_13,
			uvs = var_8_17
		}
		var_8_6[var_8_16] = {
			color = var_8_1,
			offset = var_8_15,
			size = var_8_14,
			portrait_offset = var_8_12
		}
		var_8_7[#var_8_7 + 1] = var_8_16
	end

	var_8_4[#var_8_4 + 1] = {
		style_id = "count_text",
		pass_type = "text",
		text_id = "count_text",
		content_check_function = function(arg_9_0)
			return arg_9_0.count_text
		end
	}
	var_8_4[#var_8_4 + 1] = {
		style_id = "count_text_shadow",
		pass_type = "text",
		text_id = "count_text",
		content_check_function = function(arg_10_0)
			return arg_10_0.count_text
		end
	}
	var_8_5.count = nil
	var_8_5.count_text = nil
	var_8_6.count_text = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		use_shadow = true,
		font_size = 26,
		horizontal_alignment = "right",
		text_color = Colors.get_table("white"),
		offset = {
			-37,
			0,
			1
		}
	}
	var_8_6.count_text_shadow = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		use_shadow = true,
		font_size = 26,
		horizontal_alignment = "right",
		text_color = Colors.get_table("black"),
		offset = {
			-35.5,
			-1.5,
			0
		}
	}
	var_8_6.count_text.color = var_8_6.count_text.text_color
	var_8_6.count_text_shadow.color = var_8_6.count_text.text_color
	var_8_7[#var_8_7 + 1] = "count_text"
	var_8_7[#var_8_7 + 1] = "count_text_shadow"
	var_8_5.texte_style_ids = var_8_7
	var_8_3.element.passes = var_8_4
	var_8_3.content = var_8_5
	var_8_3.style = var_8_6
	var_8_3.offset = {
		0,
		0,
		0
	}
	var_8_3.scenegraph_id = arg_8_0

	return var_8_3
end

local var_0_6 = {}

for iter_0_0 = 1, var_0_1 do
	var_0_6[iter_0_0] = var_0_5("message_animated", "positive_reinforcement", 1)
end

return {
	scenegraph_definition = var_0_2,
	animated_message_widget = var_0_3.message_animated,
	message_widgets = var_0_6,
	MAX_NUMBER_OF_MESSAGES = var_0_1
}
