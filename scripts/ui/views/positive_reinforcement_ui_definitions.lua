-- chunkname: @scripts/ui/views/positive_reinforcement_ui_definitions.lua

local_require("scripts/ui/ui_widgets")

local num = 18
local num_2 = 5
local tbl = {
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
	tbl.root.scale = "hud_fit"
	tbl.root.is_root = false
end

local tbl_2 = {
	message_animated = {
		scenegraph_id = "message_animated",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon_1",
					texture_id = "icon_1",
					content_check_function = function (self)
						-- function 1
						if not self.icon_1 then
							return false
						end

						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_2",
					texture_id = "icon_2",
					content_check_function = function (self)
						-- function 2
						if not self.icon_2 then
							return false
						end

						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_3",
					texture_id = "icon_3",
					content_check_function = function (self)
						-- function 3
						if not self.icon_3 then
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
				font_size = num,
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

local function fn(arg_4_0)
	-- function 4
	local tbl = {}

	for i = 1, arg_4_0 do
		tbl[i] = {
			scenegraph_id = "message_animated",
			element = {
				passes = {
					{
						pass_type = "texture",
						style_id = "icon_1",
						texture_id = "icon_1",
						content_check_function = function (self)
							-- function 5
							if not self.icon_1 then
								return false
							end

							return true
						end
					},
					{
						pass_type = "texture",
						style_id = "icon_2",
						texture_id = "icon_2",
						content_check_function = function (self)
							-- function 6
							if not self.icon_2 then
								return false
							end

							return true
						end
					},
					{
						pass_type = "texture",
						style_id = "icon_3",
						texture_id = "icon_3",
						content_check_function = function (self)
							-- function 7
							if not self.icon_3 then
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
					font_size = num,
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

	return tbl
end

local function fn_2(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	arg_8_2 = arg_8_2 or 1

	local var_8_0 = UIPlayerPortraitFrameSettings[arg_8_1]
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
		0,
		0,
		0
	}
	local tbl_3 = {
		element = {}
	}
	local tbl_4 = {}
	local tbl_5 = {
		scale = arg_8_2,
		frame_settings_name = arg_8_1
	}
	local tbl_6 = {}
	local tbl_7 = {}
	local num = 150
	local str = "icon"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str,
		style_id = str,
		retained_mode = arg_8_3
	}
	tbl_5[str] = "icons_placeholder"
	tbl_6[str] = {
		color = table.clone(tbl),
		offset = {
			num / 2 - 20 - 8,
			-20,
			2
		},
		size = {
			40,
			40
		}
	}
	tbl_7[#tbl_7 + 1] = str

	local str_2 = "background"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str_2,
		style_id = str_2,
		retained_mode = arg_8_3
	}
	tbl_5[str_2] = "reinforcement_background"
	tbl_6[str_2] = {
		color = table.clone(tbl),
		offset = {
			num / 2 - 116,
			-34,
			0
		},
		size = {
			232,
			68
		}
	}
	tbl_7[#tbl_7 + 1] = str_2

	local str_3 = "arrow"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str_3,
		style_id = str_3,
		retained_mode = arg_8_3
	}
	tbl_5[str_3] = "reinforcement_arrow"
	tbl_6[str_3] = {
		color = table.clone(tbl),
		offset = {
			num / 2 - 8,
			-13,
			1
		},
		size = {
			35,
			26
		}
	}
	tbl_7[#tbl_7 + 1] = str_3

	for i = 1, 2 do
		local tbl_8 = {
			(i - 1) * num,
			0,
			3
		}
		local str_4 = "icons_placeholder"
		local tbl_9 = {
			86,
			108
		}

		tbl_9[1] = tbl_9[1] * arg_8_2
		tbl_9[2] = tbl_9[2] * arg_8_2

		local clone = table.clone(tbl_2)

		clone[1] = tbl_8[1] - tbl_9[1] / 2 + clone[1] * arg_8_2
		clone[2] = tbl_8[2] - tbl_9[2] / 2 + clone[2] * arg_8_2
		clone[3] = tbl_8[3]

		local str_5 = "portrait_" .. i

		tbl_4[#tbl_4 + 1] = {
			pass_type = "texture_uv",
			content_id = str_5,
			style_id = str_5,
			retained_mode = arg_8_3
		}

		local tbl_10

		if i == 1 then
			tbl_10 = {
				{
					0,
					0
				},
				{
					1,
					1
				}
			}

			if not tbl_10 then
				-- Nothing
			end
		end

		tbl_10 = {
			{
				1,
				0
			},
			{
				0,
				1
			}
		}

		::label_8_0::

		tbl_5[str_5] = {
			texture_id = str_4,
			uvs = tbl_10
		}
		tbl_6[str_5] = {
			color = tbl,
			offset = clone,
			size = tbl_9,
			portrait_offset = tbl_8
		}
		tbl_7[#tbl_7 + 1] = str_5
	end

	tbl_4[#tbl_4 + 1] = {
		style_id = "count_text",
		pass_type = "text",
		text_id = "count_text",
		content_check_function = function (self)
			-- function 9
			return self.count_text
		end
	}
	tbl_4[#tbl_4 + 1] = {
		style_id = "count_text_shadow",
		pass_type = "text",
		text_id = "count_text",
		content_check_function = function (self)
			-- function 10
			return self.count_text
		end
	}
	tbl_5.count = nil
	tbl_5.count_text = nil
	tbl_6.count_text = {
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
	tbl_6.count_text_shadow = {
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
	tbl_6.count_text.color = tbl_6.count_text.text_color
	tbl_6.count_text_shadow.color = tbl_6.count_text.text_color
	tbl_7[#tbl_7 + 1] = "count_text"
	tbl_7[#tbl_7 + 1] = "count_text_shadow"
	tbl_5.texte_style_ids = tbl_7
	tbl_3.element.passes = tbl_4
	tbl_3.content = tbl_5
	tbl_3.style = tbl_6
	tbl_3.offset = {
		0,
		0,
		0
	}
	tbl_3.scenegraph_id = arg_8_0

	return tbl_3
end

local tbl_3 = {}

for i = 1, num_2 do
	tbl_3[i] = fn_2("message_animated", "positive_reinforcement", 1)
end

return {
	scenegraph_definition = tbl,
	animated_message_widget = tbl_2.message_animated,
	message_widgets = tbl_3,
	MAX_NUMBER_OF_MESSAGES = num_2
}
