-- chunkname: @scripts/ui/hud_ui/item_received_feedback_ui_definitions.lua

local_require("scripts/ui/ui_widgets")

local num = 18
local num_2 = 1
local tbl = {
	root = {
		is_root = true,
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
	message_animated_parent = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-300,
			0,
			0
		}
	},
	message_animated = {
		parent = "message_animated_parent",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	message_animated_dragger = {
		parent = "message_animated",
		size = {
			200,
			50
		},
		position = {
			0,
			0,
			0
		}
	}
}
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

local function fn_2(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	arg_8_3 = arg_8_3 or 1

	local var_8_0 = UIPlayerPortraitFrameSettings[arg_8_2]
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
		scale = arg_8_3,
		frame_settings_name = arg_8_2
	}
	local tbl_6 = {}
	local tbl_7 = {}
	local num = 150
	local str = "icon"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str,
		style_id = str,
		retained_mode = arg_8_4
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

	local str_2 = "arrow"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str_2,
		style_id = str_2,
		retained_mode = arg_8_4
	}
	tbl_5[str_2] = "reinforcement_arrow"
	tbl_6[str_2] = {
		color = table.clone(tbl),
		offset = {
			0,
			-13,
			1
		},
		size = {
			35,
			26
		}
	}
	tbl_7[#tbl_7 + 1] = str_2

	for i = 1, 1 do
		local tbl_8 = {
			0,
			0,
			3
		}
		local str_3 = "icons_placeholder"
		local tbl_9 = {
			86,
			108
		}

		tbl_9[1] = tbl_9[1] * arg_8_3
		tbl_9[2] = tbl_9[2] * arg_8_3

		local clone = table.clone(tbl_2)

		clone[1] = tbl_8[1] - tbl_9[1] / 2 + clone[1] * arg_8_3
		clone[2] = tbl_8[2] - tbl_9[2] / 2 + clone[2] * arg_8_3
		clone[3] = tbl_8[3]

		local str_4 = "portrait_" .. i

		tbl_4[#tbl_4 + 1] = {
			pass_type = "texture_uv",
			content_id = str_4,
			style_id = str_4,
			retained_mode = arg_8_4
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

		tbl_5[str_4] = {
			texture_id = str_3,
			uvs = tbl_10
		}
		tbl_6[str_4] = {
			color = tbl,
			offset = clone,
			size = tbl_9,
			portrait_offset = tbl_8
		}
		tbl_7[#tbl_7 + 1] = str_4
	end

	tbl_5.text_style_ids = tbl_7
	tbl_3.element.passes = tbl_4
	tbl_3.content = tbl_5
	tbl_3.style = tbl_6
	tbl_3.offset = {
		0,
		0,
		(arg_8_0 - 1) * 10
	}
	tbl_3.scenegraph_id = arg_8_1

	return tbl_3
end

local tbl_3 = {}

for i = 1, num_2 do
	tbl_3[i] = fn_2(i, "message_animated", "positive_reinforcement", 1)
end

return {
	scenegraph_definition = tbl,
	animated_message_widget = tbl_2.message_animated,
	message_widgets = tbl_3,
	MAX_NUMBER_OF_MESSAGES = num_2
}
