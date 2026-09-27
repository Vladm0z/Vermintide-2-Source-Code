-- chunkname: @scripts/ui/views/level_end/level_end_view_versus_definitions.lua

local tbl = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.end_screen
		}
	},
	screen_award = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			500,
			300
		},
		position = {
			50,
			-50,
			0
		}
	},
	portrait_1 = {
		parent = "screen",
		size = {
			100,
			100
		},
		position = {
			0,
			0,
			0
		}
	},
	portrait_2 = {
		parent = "screen",
		size = {
			100,
			100
		},
		position = {
			0,
			0,
			0
		}
	},
	portrait_3 = {
		parent = "screen",
		size = {
			100,
			100
		},
		position = {
			0,
			0,
			0
		}
	},
	portrait_4 = {
		parent = "screen",
		size = {
			100,
			100
		},
		position = {
			0,
			0,
			0
		}
	},
	portrait_5 = {
		parent = "screen",
		size = {
			100,
			100
		},
		position = {
			0,
			0,
			0
		}
	},
	award_1 = {
		vertical_alignment = "bottom",
		parent = "portrait_1",
		horizontal_alignment = "left",
		size = {
			50,
			138
		},
		position = {
			0,
			0,
			0
		}
	},
	award_2 = {
		vertical_alignment = "bottom",
		parent = "portrait_2",
		horizontal_alignment = "left",
		size = {
			50,
			138
		},
		position = {
			0,
			0,
			0
		}
	},
	award_3 = {
		vertical_alignment = "bottom",
		parent = "portrait_3",
		horizontal_alignment = "left",
		size = {
			50,
			138
		},
		position = {
			0,
			0,
			0
		}
	},
	award_4 = {
		vertical_alignment = "bottom",
		parent = "portrait_4",
		horizontal_alignment = "left",
		size = {
			50,
			138
		},
		position = {
			0,
			0,
			0
		}
	},
	award_5 = {
		vertical_alignment = "bottom",
		parent = "portrait_4",
		horizontal_alignment = "left",
		size = {
			50,
			138
		},
		position = {
			0,
			0,
			0
		}
	},
	continue_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			300,
			75
		},
		position = {
			0,
			0,
			0
		}
	}
}
local flag = true
local tbl_2 = {
	continue_button = UIWidgets.create_default_button("continue_button", tbl.continue_button.size, nil, nil, Localize("continue_menu_button_name"), 25, nil, nil, nil, flag)
}
local tbl_3 = {
	animate_continue_button = {
		{
			name = "animate_continue_button",
			start_progress = 2,
			end_progress = 2.25,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				return
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)

				arg_2_2.continue_button.content.visible = true
				arg_2_0.continue_button.local_position[2] = math.lerp(-200, 50, easeOutCubic)
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				arg_3_3.data.cb()
			end
		}
	},
	show_awards = {
		{
			name = "show_all_awards",
			start_progress = 0.5,
			end_progress = 1,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				for k, v in pairs(arg_4_2) do
					v.content.visible = true
				end
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				return
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	},
	hide_awards = {
		{
			name = "hide",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				for k, v in pairs(arg_7_2) do
					v.content.visible = false
				end

				arg_7_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				return
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		}
	}
}
local tbl_4 = {
	default = {
		{
			input_action = "confirm_hold",
			priority = 1,
			description_text = "title_screen_store_skip"
		}
	},
	continue_available = {
		actions = {
			{
				input_action = "refresh",
				priority = 2,
				description_text = "input_description_continue"
			}
		}
	}
}
local tbl_5 = {
	{
		name = "top_down",
		func = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
			-- function 10
			return {
				start_pos = Vector3Box(arg_10_1 + Vector3.up() * 2 - arg_10_5 * arg_10_6 * 0.3),
				end_pos = Vector3Box(arg_10_2 + Vector3.up() * 0.4 - arg_10_5 * arg_10_6 * 0.8),
				neck_pose = Matrix4x4Box(arg_10_0),
				distance = arg_10_6 * 0.3,
				timer = arg_10_7,
				time = arg_10_7
			}
		end
	},
	{
		name = "pan_up",
		func = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
			-- function 11
			return {
				disable_camera_rotation = true,
				start_pos = Vector3Box(arg_11_3 - arg_11_5 * arg_11_6 * 0.5 + Vector3.up() * 0.2),
				end_pos = Vector3Box(arg_11_1 - arg_11_5 * arg_11_6 * 1),
				neck_pose = Matrix4x4Box(arg_11_0),
				distance = arg_11_6 * 0,
				timer = arg_11_7,
				time = arg_11_7
			}
		end
	},
	{
		name = "zoom_in",
		func = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
			-- function 12
			return {
				start_pos = Vector3Box(arg_12_2 - arg_12_5 * arg_12_6 * 2 - arg_12_4 * 0.4),
				end_pos = Vector3Box(arg_12_1 - arg_12_5 * arg_12_6 * 0.75 + Vector3.up() * 0 + arg_12_4 * 0.4),
				neck_pose = Matrix4x4Box(arg_12_0),
				distance = arg_12_6 * 0,
				timer = arg_12_7,
				time = arg_12_7
			}
		end
	},
	{
		name = "zoom_around",
		func = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7)
			-- function 13
			return {
				start_pos = Vector3Box(arg_13_2 + arg_13_4 * arg_13_6 * 0.3 + Vector3.up() * 0 - arg_13_5 * arg_13_6 * 0.6),
				end_pos = Vector3Box(arg_13_1 - arg_13_4 * arg_13_6 * 0.3 + Vector3.up() * 0.1 - arg_13_5 * arg_13_6 * 0.8),
				neck_pose = Matrix4x4Box(arg_13_0),
				distance = arg_13_6 * 0.3,
				timer = arg_13_7,
				time = arg_13_7
			}
		end
	},
	{
		name = "zoom_other_way_around",
		func = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7)
			-- function 14
			return {
				start_pos = Vector3Box(arg_14_2 - arg_14_4 * arg_14_6 * 0.3 + Vector3.up() * 0 - arg_14_5 * arg_14_6 * 0.6),
				end_pos = Vector3Box(arg_14_1 + arg_14_4 * arg_14_6 * 0.3 + Vector3.up() * 0.1 - arg_14_5 * arg_14_6 * 0.8),
				neck_pose = Matrix4x4Box(arg_14_0),
				distance = arg_14_6 * 0.3,
				timer = arg_14_7,
				time = arg_14_7
			}
		end
	}
}

return {
	widget_definitions = tbl_2,
	scenegraph_definitions = tbl,
	animation_definitions = tbl_3,
	generic_input_actions = tbl_4,
	camera_movement_functions = tbl_5
}
