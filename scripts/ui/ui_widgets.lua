-- chunkname: @scripts/ui/ui_widgets.lua

local_require("scripts/ui/ui_widgets_honduras")

UIWidgets = UIWidgets or {}

function UIWidgets.create_hover_button(arg_1_0, arg_1_1, arg_1_2)
	return {
		element = UIElements.SimpleButton,
		content = {
			texture_id = arg_1_1,
			texture_hover_id = arg_1_2,
			button_hotspot = {}
		},
		style = {},
		scenegraph_id = arg_1_0
	}
end

local function var_0_0(arg_2_0)
	return {
		pass_type = "text",
		text_id = arg_2_0,
		style_id = arg_2_0,
		content_check_function = function(arg_3_0)
			return arg_3_0[arg_2_0]
		end
	}
end

local function var_0_1(arg_4_0, arg_4_1, arg_4_2)
	local function var_4_0(arg_5_0)
		return arg_5_0[arg_4_0] and not arg_5_0[arg_4_2]
	end

	local function var_4_1(arg_6_0)
		return arg_6_0[arg_4_0] and arg_6_0[arg_4_2]
	end

	return {
		pass_type = "text",
		text_id = arg_4_0,
		style_id = arg_4_1 and arg_4_0 .. arg_4_1 or arg_4_0,
		content_check_function = arg_4_1 and var_4_1 or var_4_0
	}
end

local function var_0_2(arg_7_0, arg_7_1)
	return {
		vertical_alignment = "center",
		font_size = 18,
		localize = false,
		word_wrap = false,
		font_type = "hell_shark_masked",
		horizontal_alignment = arg_7_0,
		text_color = Colors.get_table("font_default"),
		offset = arg_7_1
	}
end

function UIWidgets.create_gamepad_layout_win32(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background1",
					texture_id = "background1",
					content_check_function = function(arg_9_0)
						return not arg_9_0.use_texture2_layout
					end
				},
				{
					pass_type = "texture",
					style_id = "background2",
					texture_id = "background2",
					content_check_function = function(arg_10_0)
						return arg_10_0.use_texture2_layout
					end
				},
				var_0_1("left_trigger", nil, "use_texture2_layout"),
				var_0_1("left_shoulder", nil, "use_texture2_layout"),
				var_0_1("right_trigger", nil, "use_texture2_layout"),
				var_0_1("right_shoulder", nil, "use_texture2_layout"),
				var_0_1("ls", nil, "use_texture2_layout"),
				var_0_1("rs", nil, "use_texture2_layout"),
				var_0_1("left_thumb", nil, "use_texture2_layout"),
				var_0_1("right_thumb", nil, "use_texture2_layout"),
				var_0_1("d_up", nil, "use_texture2_layout"),
				var_0_1("d_down", nil, "use_texture2_layout"),
				var_0_1("d_left", nil, "use_texture2_layout"),
				var_0_1("d_right", nil, "use_texture2_layout"),
				var_0_1("back", nil, "use_texture2_layout"),
				var_0_1("start", nil, "use_texture2_layout"),
				var_0_1("x", nil, "use_texture2_layout"),
				var_0_1("y", nil, "use_texture2_layout"),
				var_0_1("a", nil, "use_texture2_layout"),
				var_0_1("b", nil, "use_texture2_layout"),
				var_0_1("left_trigger", "_texture2", "use_texture2_layout"),
				var_0_1("left_shoulder", "_texture2", "use_texture2_layout"),
				var_0_1("right_trigger", "_texture2", "use_texture2_layout"),
				var_0_1("right_shoulder", "_texture2", "use_texture2_layout"),
				var_0_1("ls", "_texture2", "use_texture2_layout"),
				var_0_1("rs", "_texture2", "use_texture2_layout"),
				var_0_1("left_thumb", "_texture2", "use_texture2_layout"),
				var_0_1("right_thumb", "_texture2", "use_texture2_layout"),
				var_0_1("d_up", "_texture2", "use_texture2_layout"),
				var_0_1("d_down", "_texture2", "use_texture2_layout"),
				var_0_1("d_left", "_texture2", "use_texture2_layout"),
				var_0_1("d_right", "_texture2", "use_texture2_layout"),
				var_0_1("back", "_texture2", "use_texture2_layout"),
				var_0_1("start", "_texture2", "use_texture2_layout"),
				var_0_1("x", "_texture2", "use_texture2_layout"),
				var_0_1("y", "_texture2", "use_texture2_layout"),
				var_0_1("a", "_texture2", "use_texture2_layout"),
				var_0_1("b", "_texture2", "use_texture2_layout")
			}
		},
		content = {
			background1 = arg_8_0,
			background2 = arg_8_2
		},
		style = {
			use_texture2_layout = false,
			size = arg_8_1,
			offset = arg_8_4,
			background1 = {
				color = {
					255,
					255,
					255,
					255
				},
				size = arg_8_1,
				offset = {
					arg_8_4[1],
					arg_8_4[2],
					arg_8_4[3] + 15
				}
			},
			background2 = {
				color = {
					255,
					255,
					255,
					255
				},
				size = arg_8_3,
				offset = {
					arg_8_4[1],
					arg_8_4[2],
					arg_8_4[3] + 15
				}
			},
			left_trigger = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 40,
				arg_8_4[3] + 16
			}),
			left_shoulder = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 78,
				arg_8_4[3] + 16
			}),
			right_trigger = var_0_2("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 40,
				arg_8_4[3] + 16
			}),
			right_shoulder = var_0_2("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 78,
				arg_8_4[3] + 16
			}),
			ls = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 176,
				arg_8_4[3] + 16
			}),
			rs = var_0_2("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 334,
				arg_8_4[3] + 16
			}),
			left_thumb = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 196,
				arg_8_4[3] + 16
			}),
			right_thumb = var_0_2("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 354,
				arg_8_4[3] + 16
			}),
			d_up = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 240,
				arg_8_4[3] + 16
			}),
			d_down = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 318,
				arg_8_4[3] + 16
			}),
			d_left = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 280,
				arg_8_4[3] + 16
			}),
			d_right = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 354,
				arg_8_4[3] + 16
			}),
			back = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 + 2,
				arg_8_4[3] + 16
			}),
			start = var_0_2("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 + 2,
				arg_8_4[3] + 16
			}),
			x = var_0_2("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 290,
				arg_8_4[3] + 16
			}),
			y = var_0_2("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 126,
				arg_8_4[3] + 16
			}),
			a = var_0_2("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 244,
				arg_8_4[3] + 16
			}),
			b = var_0_2("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 182,
				arg_8_4[3] + 16
			}),
			left_trigger_texture2 = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 40,
				arg_8_4[3] + 16
			}),
			left_shoulder_texture2 = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 78,
				arg_8_4[3] + 16
			}),
			right_trigger_texture2 = var_0_2("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 400 - 40,
				arg_8_4[3] + 16
			}),
			right_shoulder_texture2 = var_0_2("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 400 - 78,
				arg_8_4[3] + 16
			}),
			ls_texture2 = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 346,
				arg_8_4[3] + 16
			}),
			rs_texture2 = var_0_2("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 348,
				arg_8_4[3] + 16
			}),
			left_thumb_texture2 = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 366,
				arg_8_4[3] + 16
			}),
			right_thumb_texture2 = var_0_2("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 368,
				arg_8_4[3] + 16
			}),
			d_up_texture2 = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 156,
				arg_8_4[3] + 16
			}),
			d_down_texture2 = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 248,
				arg_8_4[3] + 16
			}),
			d_left_texture2 = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 202,
				arg_8_4[3] + 16
			}),
			d_right_texture2 = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 298,
				arg_8_4[3] + 16
			}),
			back_texture2 = var_0_2("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 38,
				arg_8_4[3] + 16
			}),
			start_texture2 = var_0_2("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 38,
				arg_8_4[3] + 16
			}),
			x_texture2 = var_0_2("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 300,
				arg_8_4[3] + 16
			}),
			y_texture2 = var_0_2("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 156,
				arg_8_4[3] + 16
			}),
			a_texture2 = var_0_2("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 250,
				arg_8_4[3] + 16
			}),
			b_texture2 = var_0_2("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 204,
				arg_8_4[3] + 16
			})
		},
		scenegraph_id = arg_8_5
	}
end

function UIWidgets.create_gamepad_layout_xb1(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				var_0_0("left_trigger"),
				var_0_0("left_shoulder"),
				var_0_0("right_trigger"),
				var_0_0("right_shoulder"),
				var_0_0("ls"),
				var_0_0("rs"),
				var_0_0("left_thumb"),
				var_0_0("right_thumb"),
				var_0_0("d_up"),
				var_0_0("d_down"),
				var_0_0("d_left"),
				var_0_0("d_right"),
				var_0_0("back"),
				var_0_0("start"),
				var_0_0("x"),
				var_0_0("y"),
				var_0_0("a"),
				var_0_0("b")
			}
		},
		content = {
			background = arg_11_0
		},
		style = {
			size = arg_11_1,
			offset = arg_11_2,
			background = {
				color = {
					255,
					255,
					255,
					255
				},
				size = arg_11_1,
				offset = {
					arg_11_2[1],
					arg_11_2[2],
					arg_11_2[3] + 15
				}
			},
			left_trigger = var_0_2("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 40,
				arg_11_2[3] + 16
			}),
			left_shoulder = var_0_2("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 78,
				arg_11_2[3] + 16
			}),
			right_trigger = var_0_2("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 40,
				arg_11_2[3] + 16
			}),
			right_shoulder = var_0_2("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 78,
				arg_11_2[3] + 16
			}),
			ls = var_0_2("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 176,
				arg_11_2[3] + 16
			}),
			rs = var_0_2("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 334,
				arg_11_2[3] + 16
			}),
			left_thumb = var_0_2("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 196,
				arg_11_2[3] + 16
			}),
			right_thumb = var_0_2("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 354,
				arg_11_2[3] + 16
			}),
			d_up = var_0_2("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 240,
				arg_11_2[3] + 16
			}),
			d_down = var_0_2("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 318,
				arg_11_2[3] + 16
			}),
			d_left = var_0_2("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 280,
				arg_11_2[3] + 16
			}),
			d_right = var_0_2("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 354,
				arg_11_2[3] + 16
			}),
			back = var_0_2("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 + 2,
				arg_11_2[3] + 16
			}),
			start = var_0_2("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 + 2,
				arg_11_2[3] + 16
			}),
			x = var_0_2("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 290,
				arg_11_2[3] + 16
			}),
			y = var_0_2("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 126,
				arg_11_2[3] + 16
			}),
			a = var_0_2("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 244,
				arg_11_2[3] + 16
			}),
			b = var_0_2("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 182,
				arg_11_2[3] + 16
			})
		},
		scenegraph_id = arg_11_3
	}
end

function UIWidgets.create_gamepad_layout_ps4(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				var_0_0("l2"),
				var_0_0("l1"),
				var_0_0("r2"),
				var_0_0("r1"),
				var_0_0("ls"),
				var_0_0("rs"),
				var_0_0("l3"),
				var_0_0("r3"),
				var_0_0("up"),
				var_0_0("down"),
				var_0_0("left"),
				var_0_0("right"),
				var_0_0("touch"),
				var_0_0("options"),
				var_0_0("square"),
				var_0_0("triangle"),
				var_0_0("cross"),
				var_0_0("circle")
			}
		},
		content = {
			options = "toggle_menu",
			down = "down",
			l1 = "l1",
			r3 = "r3",
			triangle = "triangle",
			cross = "cross",
			rs = "look_raw_controller",
			circle = "circle",
			ls = "move_controller",
			up = "up",
			touch = "ingame_player_list_toggle",
			square = "square",
			left = "left",
			l3 = "l3",
			r2 = "r2",
			l2 = "l2",
			r1 = "r1",
			right = "right",
			background = arg_12_0
		},
		style = {
			size = arg_12_1,
			offset = arg_12_2,
			background = {
				color = {
					255,
					255,
					255,
					255
				},
				size = arg_12_1,
				offset = {
					arg_12_2[1],
					arg_12_2[2],
					arg_12_2[3] + 15
				}
			},
			l2 = var_0_2("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 400 - 40,
				arg_12_2[3] + 16
			}),
			l1 = var_0_2("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 400 - 78,
				arg_12_2[3] + 16
			}),
			r2 = var_0_2("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 400 - 40,
				arg_12_2[3] + 16
			}),
			r1 = var_0_2("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 400 - 78,
				arg_12_2[3] + 16
			}),
			ls = var_0_2("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 346,
				arg_12_2[3] + 16
			}),
			rs = var_0_2("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 348,
				arg_12_2[3] + 16
			}),
			l3 = var_0_2("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 366,
				arg_12_2[3] + 16
			}),
			r3 = var_0_2("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 368,
				arg_12_2[3] + 16
			}),
			up = var_0_2("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 156,
				arg_12_2[3] + 16
			}),
			down = var_0_2("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 248,
				arg_12_2[3] + 16
			}),
			left = var_0_2("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 202,
				arg_12_2[3] + 16
			}),
			right = var_0_2("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 298,
				arg_12_2[3] + 16
			}),
			touch = var_0_2("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 38,
				arg_12_2[3] + 16
			}),
			options = var_0_2("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 38,
				arg_12_2[3] + 16
			}),
			square = var_0_2("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 300,
				arg_12_2[3] + 16
			}),
			triangle = var_0_2("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 156,
				arg_12_2[3] + 16
			}),
			cross = var_0_2("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 250,
				arg_12_2[3] + 16
			}),
			circle = var_0_2("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 204,
				arg_12_2[3] + 16
			})
		},
		scenegraph_id = arg_12_3
	}
end

function UIWidgets.create_menu_button(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_14_0)
						return not arg_14_0.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function(arg_15_0)
						local var_15_0 = arg_15_0.button_hotspot

						return not var_15_0.disabled and not var_15_0.is_hover and var_15_0.is_clicked > 0 and not var_15_0.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_16_0)
						local var_16_0 = arg_16_0.button_hotspot

						return not var_16_0.disabled and not var_16_0.is_selected and var_16_0.is_hover and var_16_0.is_clicked > 0
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function(arg_17_0)
						local var_17_0 = arg_17_0.button_hotspot

						return not var_17_0.disabled and var_17_0.is_clicked == 0
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_selected_id",
					content_check_function = function(arg_18_0)
						local var_18_0 = arg_18_0.button_hotspot

						return not var_18_0.disabled and var_18_0.is_selected and var_18_0.is_clicked > 0
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function(arg_19_0)
						return arg_19_0.button_hotspot.disabled
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "left_detail",
					texture_id = "left_texture_id",
					content_check_function = function(arg_20_0)
						return not arg_20_0.disable_side_textures
					end
				},
				{
					pass_type = "texture",
					style_id = "right_detail",
					texture_id = "right_texture_id",
					content_check_function = function(arg_21_0)
						return not arg_21_0.disable_side_textures
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_22_0)
						local var_22_0 = arg_22_0.button_hotspot

						return not var_22_0.disabled and not var_22_0.is_hover and not var_22_0.is_selected and var_22_0.is_clicked > 0
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_23_0)
						local var_23_0 = arg_23_0.button_hotspot

						return not var_23_0.disabled and not var_23_0.is_selected and var_23_0.is_hover and var_23_0.is_clicked > 0
					end
				},
				{
					style_id = "text_click",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_24_0)
						local var_24_0 = arg_24_0.button_hotspot

						return not var_24_0.disabled and var_24_0.is_clicked == 0
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_25_0)
						local var_25_0 = arg_25_0.button_hotspot

						return not var_25_0.disabled and var_25_0.is_selected and var_25_0.is_clicked ~= 0
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_26_0)
						return arg_26_0.button_hotspot.disabled
					end
				}
			}
		},
		content = {
			texture_disabled_id = "medium_button_disabled",
			right_texture_id = "medium_button_selected_detail",
			texture_hover_id = "medium_button_hover",
			disable_side_textures = false,
			texture_click_id = "medium_button_selected",
			texture_id = "medium_button_normal",
			left_texture_id = "medium_button_selected_detail",
			texture_selected_id = "medium_button_hover",
			button_hotspot = {
				is_hover = false,
				is_clicked = 10
			},
			text_field = arg_13_0,
			hover_color = {
				0,
				255,
				255,
				255
			},
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			}
		},
		style = {
			text = {
				horizontal_alignment = "center",
				localize = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				word_wrap = arg_13_3,
				font_size = arg_13_2 or 24,
				size = arg_13_4,
				offset = {
					arg_13_5 or 0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				text_color_enabled = table.clone(Colors.color_definitions.cheeseburger),
				text_color_disabled = table.clone(Colors.color_definitions.gray)
			},
			text_hover = {
				horizontal_alignment = "center",
				localize = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				word_wrap = arg_13_3,
				font_size = arg_13_2 or 24,
				size = arg_13_4,
				offset = {
					arg_13_5 or 0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			text_click = {
				horizontal_alignment = "center",
				localize = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				word_wrap = arg_13_3,
				font_size = arg_13_2 or 24,
				size = arg_13_4,
				offset = {
					arg_13_5 or 0,
					-2,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
			},
			text_selected = {
				horizontal_alignment = "center",
				localize = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				word_wrap = arg_13_3,
				font_size = arg_13_2 or 24,
				size = arg_13_4,
				offset = {
					arg_13_5 or 0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			text_disabled = {
				horizontal_alignment = "center",
				localize = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				word_wrap = arg_13_3,
				font_size = arg_13_2 or 24,
				size = arg_13_4,
				offset = {
					arg_13_5 or 0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("gray", 255)
			},
			right_detail = {
				offset = {
					294,
					12,
					-1
				},
				size = {
					24,
					60
				}
			},
			left_detail = {
				offset = {
					1,
					12,
					-1
				},
				size = {
					24,
					60
				}
			}
		},
		scenegraph_id = arg_13_1
	}
end

function UIWidgets.create_menu_button_medium(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	return {
		element = UIElements.ButtonMenuSteps,
		content = {
			texture_click_id = "medium_button_selected",
			texture_id = "medium_button_normal",
			texture_hover_id = "medium_button_hover",
			texture_selected_id = "medium_button_hover",
			texture_disabled_id = "medium_button_disabled",
			text_field = arg_27_0,
			button_hotspot = {}
		},
		style = {
			texture = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			text = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = not arg_27_2 and true,
				font_size = arg_27_3 or 24,
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				text_color_enabled = table.clone(Colors.color_definitions.cheeseburger),
				text_color_disabled = table.clone(Colors.color_definitions.gray)
			},
			text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				horizontal_alignment = "center",
				localize = not arg_27_2 and true,
				font_size = arg_27_3 or 24,
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				horizontal_alignment = "center",
				localize = not arg_27_2 and true,
				font_size = arg_27_3 or 24,
				offset = {
					0,
					-2,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				horizontal_alignment = "center",
				localize = not arg_27_2 and true,
				font_size = arg_27_3 or 24,
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("gray", 255)
			}
		},
		scenegraph_id = arg_27_1
	}
end

function UIWidgets.create_popup_button_long(arg_28_0, arg_28_1, arg_28_2)
	return {
		element = UIElements.ButtonMenuSteps,
		content = {
			texture_click_id = "popup_button_selected",
			texture_id = "popup_button_normal",
			texture_hover_id = "popup_button_hover",
			texture_selected_id = "popup_button_hover",
			texture_disabled_id = "popup_button_disabled",
			text_field = arg_28_0,
			button_hotspot = {}
		},
		style = {
			texture = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			text = {
				font_size = 32,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = not arg_28_2 and true,
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				text_color_enabled = table.clone(Colors.color_definitions.cheeseburger),
				text_color_disabled = table.clone(Colors.color_definitions.gray)
			},
			text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 32,
				horizontal_alignment = "center",
				localize = not arg_28_2 and true,
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 32,
				horizontal_alignment = "center",
				localize = not arg_28_2 and true,
				offset = {
					0,
					-2,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 32,
				horizontal_alignment = "center",
				localize = not arg_28_2 and true,
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("gray", 255)
			}
		},
		scenegraph_id = arg_28_1
	}
end

function UIWidgets.create_quest_screen_button(arg_29_0, arg_29_1, arg_29_2)
	return {
		element = UIElements.ButtonMenuSteps,
		content = {
			texture_click_id = "quest_screen_button_selected",
			texture_id = "quest_screen_button_normal",
			texture_hover_id = "quest_screen_button_hover",
			texture_selected_id = "quest_screen_button_hover",
			texture_disabled_id = "quest_screen_button_disabled",
			text_field = arg_29_0,
			button_hotspot = {}
		},
		style = {
			texture = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			text = {
				font_size = 24,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = not arg_29_2 and true,
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				text_color_enabled = table.clone(Colors.color_definitions.cheeseburger),
				text_color_disabled = table.clone(Colors.color_definitions.gray)
			},
			text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				localize = not arg_29_2 and true,
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				localize = not arg_29_2 and true,
				offset = {
					0,
					-2,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				localize = not arg_29_2 and true,
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("gray", 255)
			}
		},
		scenegraph_id = arg_29_1
	}
end

function UIWidgets.create_menu_button_small(arg_30_0, arg_30_1)
	return {
		element = UIElements.ButtonMenuSteps,
		content = {
			texture_click_id = "small_button_02_selected",
			texture_id = "small_button_02_normal",
			texture_hover_id = "small_button_02_hover",
			texture_selected_id = "small_button_02_hover",
			texture_disabled_id = "small_button_02_disabled",
			text_field = arg_30_0,
			button_hotspot = {}
		},
		style = {
			texture = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			text = {
				font_size = 24,
				localize = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				text_color_enabled = table.clone(Colors.color_definitions.cheeseburger),
				text_color_disabled = table.clone(Colors.color_definitions.gray)
			},
			text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "center",
				offset = {
					0,
					-2,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("gray", 255)
			}
		},
		scenegraph_id = arg_30_1
	}
end

function UIWidgets.create_octagon_button(arg_31_0, arg_31_1, arg_31_2)
	return {
		element = UIElements.ToggleIconButton,
		content = {
			click_texture = "octagon_button_clicked",
			toggle_hover_texture = "octagon_button_toggled_hover",
			toggle_texture = "octagon_button_toggled",
			hover_texture = "octagon_button_hover",
			normal_texture = "octagon_button_normal",
			icon_texture = arg_31_0[1] or "map_icon_friends_01",
			icon_hover_texture = arg_31_0[2] or "map_icon_friends_02",
			tooltip_text = arg_31_1[1] or "",
			toggled_tooltip_text = arg_31_1[2] or "",
			button_hotspot = {}
		},
		style = {
			normal_texture = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			hover_texture = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			click_texture = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			toggle_texture = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			toggle_hover_texture = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			icon_texture = {
				color = {
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
			},
			icon_hover_texture = {
				color = {
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
			},
			icon_click_texture = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-1,
					1
				}
			},
			tooltip_text = {
				font_size = 24,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				offset = {
					0,
					0,
					20
				}
			}
		},
		scenegraph_id = arg_31_2
	}
end

function UIWidgets.create_menu_button_medium_with_timer(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	return {
		element = UIElements.ButtonMenuStepsWithTimer,
		content = {
			texture_click_id = "medium_button_selected",
			texture_id = "medium_button_normal",
			texture_hover_id = "medium_button_hover",
			texture_selected_id = "medium_button_hover",
			texture_disabled_id = "medium_button_disabled",
			text_field = arg_32_0,
			button_hotspot = {},
			timer_text_field = arg_32_1
		},
		style = {
			text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
			},
			text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "center",
				offset = {
					0,
					-2,
					2
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				text_color = Colors.get_color_table_with_alpha("gray", 255)
			},
			timer_text_field = {
				horizontal_alignment = "right",
				font_size = 18,
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					0,
					0,
					4
				},
				scenegraph_id = arg_32_2
			},
			timer_text_field_hover = {
				horizontal_alignment = "right",
				font_size = 18,
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					4
				},
				scenegraph_id = arg_32_2
			},
			timer_text_field_selected = {
				horizontal_alignment = "right",
				font_size = 18,
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					0,
					-2,
					4
				},
				scenegraph_id = arg_32_2
			},
			timer_text_field_disabled = {
				horizontal_alignment = "right",
				font_size = 18,
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					0,
					4
				},
				scenegraph_id = arg_32_2
			}
		},
		scenegraph_id = arg_32_3
	}
end

function UIWidgets.create_chain_scrollbar(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	local var_33_0
	local var_33_1
	local var_33_2

	if arg_33_3 == "gold" then
		var_33_0 = "_gold"
		var_33_2 = "_blue"
	else
		var_33_0 = ""
		var_33_2 = ""
	end

	local var_33_3 = {
		{
			pass_type = "local_offset",
			content_check_function = function(arg_34_0)
				return arg_34_0.scroll_bar_info.bar_height_percentage < 1
			end,
			offset_function = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				local var_35_0 = arg_35_2.scroll_bar_info
				local var_35_1 = var_35_0.axis
				local var_35_2 = arg_35_1.thumb_middle
				local var_35_3 = arg_35_1.thumb_bottom
				local var_35_4 = arg_35_1.thumb_top.size[var_35_1]
				local var_35_5 = var_35_2.size[var_35_1]
				local var_35_6 = var_35_3.size[var_35_1]
				local var_35_7 = arg_35_1.hotspot
				local var_35_8 = var_35_0.scroll_length
				local var_35_9 = var_35_4 + var_35_6
				local var_35_10 = var_35_9 / var_35_8
				local var_35_11 = var_35_0.bar_height_percentage
				local var_35_12 = math.max(var_35_11, var_35_10)

				var_35_7.size[var_35_1] = var_35_8 * var_35_12
				var_35_2.size[var_35_1] = math.max(math.floor(var_35_8 * var_35_12) - var_35_9, 0)
			end
		},
		{
			style_id = "hotspot",
			pass_type = "held",
			content_id = "scroll_bar_info",
			content_check_function = function(arg_36_0)
				return arg_36_0.bar_height_percentage < 1
			end,
			held_function = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				local var_37_0 = arg_37_2.axis
				local var_37_1 = Managers.input:is_device_active("gamepad")
				local var_37_2 = arg_37_3:get("cursor")
				local var_37_3 = UIInverseScaleVectorToResolution(var_37_2)[var_37_0]

				if IS_XB1 and not var_37_1 then
					var_37_3 = 1080 - var_37_2.y
				end

				local var_37_4 = UISceneGraph.get_world_position(arg_37_0, arg_37_2.scenegraph_id)[var_37_0]
				local var_37_5 = arg_37_2.scroll_length
				local var_37_6 = math.clamp(var_37_3 - var_37_4, 0, var_37_5)
				local var_37_7 = arg_37_1.size[var_37_0]

				if not arg_37_2.input_offset then
					arg_37_2.input_offset = var_37_6 - arg_37_1.offset[var_37_0]
				end

				local var_37_8 = arg_37_2.input_offset
				local var_37_9 = 0
				local var_37_10 = var_37_5 - var_37_7
				local var_37_11 = var_37_6 - var_37_8

				arg_37_2.value = 1 - math.clamp(var_37_11, var_37_9, var_37_10) / var_37_10
			end,
			release_function = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				arg_38_2.input_offset = nil
			end
		},
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "scroll_bar_info"
		},
		{
			pass_type = "local_offset",
			content_id = "scroll_bar_info",
			content_check_function = function(arg_39_0)
				return arg_39_0.bar_height_percentage < 1
			end,
			offset_function = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				local var_40_0 = arg_40_2.axis
				local var_40_1 = arg_40_1.hotspot
				local var_40_2 = 1 - arg_40_2.value
				local var_40_3 = arg_40_2.scroll_length
				local var_40_4 = var_40_1.size[var_40_0]
				local var_40_5 = 0
				local var_40_6 = var_40_3 - var_40_4
				local var_40_7 = var_40_6 * var_40_2
				local var_40_8 = math.clamp(var_40_7, var_40_5, var_40_6)

				var_40_1.offset[var_40_0] = var_40_8

				local var_40_9 = arg_40_1.thumb_middle
				local var_40_10 = arg_40_1.thumb_bottom
				local var_40_11 = arg_40_1.thumb_top
				local var_40_12 = var_40_11.size[var_40_0]
				local var_40_13 = var_40_9.size[var_40_0]
				local var_40_14 = var_40_10.size[var_40_0]

				var_40_10.offset[var_40_0] = var_40_8
				var_40_9.offset[var_40_0] = var_40_8 + var_40_14
				var_40_11.offset[var_40_0] = var_40_8 + var_40_14 + var_40_13
			end
		},
		{
			style_id = "thumb_middle",
			pass_type = "texture",
			texture_id = "thumb_middle",
			content_change_function = function(arg_41_0, arg_41_1)
				local var_41_0 = arg_41_0.scroll_bar_info.is_hover
				local var_41_1 = arg_41_1.color
				local var_41_2 = var_41_0 and 255 or 200

				var_41_1[2] = var_41_2
				var_41_1[3] = var_41_2
				var_41_1[4] = var_41_2
			end,
			content_check_function = function(arg_42_0)
				return arg_42_0.scroll_bar_info.bar_height_percentage < 1
			end
		},
		{
			style_id = "thumb_top",
			pass_type = "texture",
			texture_id = "thumb_top",
			content_change_function = function(arg_43_0, arg_43_1)
				local var_43_0 = arg_43_0.scroll_bar_info.is_hover
				local var_43_1 = arg_43_1.color
				local var_43_2 = var_43_0 and 255 or 200

				var_43_1[2] = var_43_2
				var_43_1[3] = var_43_2
				var_43_1[4] = var_43_2
			end,
			content_check_function = function(arg_44_0)
				return arg_44_0.scroll_bar_info.bar_height_percentage < 1
			end
		},
		{
			style_id = "thumb_bottom",
			pass_type = "texture",
			texture_id = "thumb_bottom",
			content_change_function = function(arg_45_0, arg_45_1)
				local var_45_0 = arg_45_0.scroll_bar_info.is_hover
				local var_45_1 = arg_45_1.color
				local var_45_2 = var_45_0 and 255 or 200

				var_45_1[2] = var_45_2
				var_45_1[3] = var_45_2
				var_45_1[4] = var_45_2
			end,
			content_check_function = function(arg_46_0)
				return arg_46_0.scroll_bar_info.bar_height_percentage < 1
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background",
			content_check_function = function(arg_47_0)
				return not arg_47_0.disable_background
			end
		}
	}
	local var_33_4 = {
		disable_frame = false,
		scroll = {
			allow_multi_hover = true
		},
		disable_background = arg_33_4,
		scroll_bar_info = {
			axis = 2,
			value = 0,
			allow_multi_hover = true,
			scroll_amount = 0,
			button_scroll_step = 0.1,
			bar_height_percentage = 1,
			scenegraph_id = arg_33_0,
			scroll_length = arg_33_2[2],
			gamepad_always_hover = arg_33_5
		},
		background = "chain_link_01" .. (var_33_2 or ""),
		thumb_top = "chain_scrollbutton_top" .. (var_33_0 or ""),
		thumb_bottom = "chain_scrollbutton_bottom" .. (var_33_0 or ""),
		thumb_middle = "chain_scrollbutton_middle" .. (var_33_0 or "")
	}
	local var_33_5 = {
		background = {
			offset = {
				0,
				0,
				0
			},
			texture_tiling_size = {
				16,
				19
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		hotspot = {
			offset = {
				arg_33_2[1] / 2 - 16,
				0,
				2
			},
			size = {
				32,
				arg_33_2[2]
			}
		},
		thumb_top = {
			offset = {
				arg_33_2[1] / 2 - 16,
				0,
				2
			},
			size = {
				32,
				28
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		thumb_bottom = {
			offset = {
				arg_33_2[1] / 2 - 16,
				0,
				2
			},
			size = {
				32,
				27
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		thumb_middle = {
			offset = {
				arg_33_2[1] / 2 - 16,
				0,
				2
			},
			start_offset = {
				arg_33_2[1] / 2 - 16,
				0,
				2
			},
			size = {
				32,
				arg_33_2[2]
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}

	if arg_33_1 then
		var_33_3[#var_33_3 + 1] = {
			style_id = "scroll_area_hotspot",
			pass_type = "scroll",
			content_id = "scroll_area_hotspot",
			scroll_function = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
				local var_48_0 = arg_48_4.y * -1
				local var_48_1 = arg_48_2.parent.scroll_bar_info
				local var_48_2 = var_48_1.gamepad_active
				local var_48_3 = arg_48_4.y * -1 * (var_48_2 and 0.2 or 1)
				local var_48_4 = var_48_1.total_scroll_height
				local var_48_5 = var_48_1.scroll_amount
				local var_48_6 = var_48_2 and var_48_1.gamepad_always_hover

				if var_48_3 ~= 0 and (arg_48_2.is_hover or var_48_6) then
					var_48_1.axis_input = var_48_3
					var_48_1.scroll_add = (var_48_1.scroll_add or 0) + var_48_3 * var_48_5
				else
					local var_48_7 = var_48_1.axis_input
				end

				local var_48_8 = var_48_1.scroll_add

				if var_48_8 then
					local var_48_9 = var_48_8 * (arg_48_5 * (var_48_1.scroll_speed or 5))
					local var_48_10 = var_48_8 - var_48_9

					if math.abs(var_48_10) > var_48_5 / 20 then
						var_48_1.scroll_add = var_48_10
					else
						var_48_1.scroll_add = nil
					end

					local var_48_11 = var_48_1.scroll_value

					if var_48_11 then
						var_48_1.scroll_value = math.clamp(var_48_11 + var_48_9, 0, 1)
					end
				end
			end
		}
		var_33_5.scroll_area_hotspot = {
			offset = {
				0,
				0,
				0
			},
			scenegraph_id = arg_33_1
		}
		var_33_4.scroll_area_hotspot = {}
	end

	return {
		element = {
			passes = var_33_3
		},
		content = var_33_4,
		style = var_33_5,
		scenegraph_id = arg_33_0
	}
end

function UIWidgets.create_horizontal_chain_scrollbar(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	local var_49_0
	local var_49_1
	local var_49_2

	if arg_49_3 == "gold" then
		var_49_0 = "_gold"
		var_49_2 = "_blue"
	else
		var_49_0 = ""
		var_49_2 = ""
	end

	local var_49_3 = {
		{
			pass_type = "local_offset",
			content_check_function = function(arg_50_0)
				return arg_50_0.scroll_bar_info.bar_length_percentage < 1
			end,
			offset_function = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				local var_51_0 = arg_51_2.scroll_bar_info
				local var_51_1 = var_51_0.axis
				local var_51_2 = arg_51_1.thumb_left
				local var_51_3 = arg_51_1.thumb_right
				local var_51_4 = arg_51_1.thumb_middle
				local var_51_5 = var_51_2.size[var_51_1]
				local var_51_6 = var_51_3.size[var_51_1]
				local var_51_7 = var_51_4.size[var_51_1]
				local var_51_8 = arg_51_1.hotspot
				local var_51_9 = var_51_0.scroll_length
				local var_51_10 = var_51_6 + var_51_5
				local var_51_11 = var_51_10 / var_51_9
				local var_51_12 = var_51_0.bar_length_percentage
				local var_51_13 = math.max(var_51_12, var_51_11)

				var_51_8.size[var_51_1] = var_51_9 * var_51_13
				var_51_4.size[var_51_1] = math.max(math.floor(var_51_9 * var_51_13) - var_51_10, 0)
			end
		},
		{
			style_id = "hotspot",
			pass_type = "held",
			content_id = "scroll_bar_info",
			content_check_function = function(arg_52_0)
				return arg_52_0.bar_length_percentage < 1
			end,
			held_function = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
				local var_53_0 = arg_53_2.axis
				local var_53_1 = Managers.input:is_device_active("gamepad")
				local var_53_2 = arg_53_3:get("cursor")
				local var_53_3 = UIInverseScaleVectorToResolution(var_53_2)[var_53_0]

				if IS_XB1 and not var_53_1 then
					var_53_3 = 1080 - var_53_2.y
				end

				local var_53_4 = UISceneGraph.get_world_position(arg_53_0, arg_53_2.scenegraph_id)[var_53_0]
				local var_53_5 = arg_53_2.scroll_length
				local var_53_6 = math.clamp(var_53_3 - var_53_4, 0, var_53_5)
				local var_53_7 = arg_53_1.size[var_53_0]

				if not arg_53_2.input_offset then
					arg_53_2.input_offset = var_53_6 - arg_53_1.offset[var_53_0]
				end

				local var_53_8 = arg_53_2.input_offset
				local var_53_9 = 0
				local var_53_10 = var_53_5 - var_53_7
				local var_53_11 = var_53_6 - var_53_8

				arg_53_2.value = math.clamp(var_53_11, var_53_9, var_53_10) / var_53_10
			end,
			release_function = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				arg_54_2.input_offset = nil
			end
		},
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "scroll_bar_info"
		},
		{
			pass_type = "local_offset",
			content_id = "scroll_bar_info",
			content_check_function = function(arg_55_0)
				return arg_55_0.bar_length_percentage < 1
			end,
			offset_function = function(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				local var_56_0 = arg_56_2.axis
				local var_56_1 = arg_56_1.hotspot
				local var_56_2 = arg_56_2.value
				local var_56_3 = arg_56_2.scroll_length
				local var_56_4 = var_56_1.size[var_56_0]
				local var_56_5 = 0
				local var_56_6 = var_56_3 - var_56_4
				local var_56_7 = var_56_6 * var_56_2
				local var_56_8 = math.clamp(var_56_7, var_56_5, var_56_6)

				var_56_1.offset[var_56_0] = var_56_8

				local var_56_9 = arg_56_1.thumb_left
				local var_56_10 = arg_56_1.thumb_right
				local var_56_11 = arg_56_1.thumb_middle
				local var_56_12 = var_56_9.size[var_56_0]
				local var_56_13 = var_56_10.size[var_56_0]
				local var_56_14 = var_56_11.size[var_56_0]

				var_56_9.offset[var_56_0] = var_56_8
				var_56_11.offset[var_56_0] = var_56_8 + var_56_12
				var_56_10.offset[var_56_0] = var_56_8 + var_56_12 + var_56_14
			end
		},
		{
			style_id = "thumb_middle",
			pass_type = "texture",
			texture_id = "thumb_middle",
			content_change_function = function(arg_57_0, arg_57_1)
				local var_57_0 = arg_57_0.scroll_bar_info.is_hover
				local var_57_1 = arg_57_1.color
				local var_57_2 = var_57_0 and 255 or 200

				var_57_1[2] = var_57_2
				var_57_1[3] = var_57_2
				var_57_1[4] = var_57_2
			end,
			content_check_function = function(arg_58_0)
				return arg_58_0.scroll_bar_info.bar_length_percentage < 1
			end
		},
		{
			style_id = "thumb_left",
			pass_type = "texture",
			texture_id = "thumb_left",
			content_change_function = function(arg_59_0, arg_59_1)
				local var_59_0 = arg_59_0.scroll_bar_info.is_hover
				local var_59_1 = arg_59_1.color
				local var_59_2 = var_59_0 and 255 or 200

				var_59_1[2] = var_59_2
				var_59_1[3] = var_59_2
				var_59_1[4] = var_59_2
			end,
			content_check_function = function(arg_60_0)
				return arg_60_0.scroll_bar_info.bar_length_percentage < 1
			end
		},
		{
			style_id = "thumb_right",
			pass_type = "texture",
			texture_id = "thumb_right",
			content_change_function = function(arg_61_0, arg_61_1)
				local var_61_0 = arg_61_0.scroll_bar_info.is_hover
				local var_61_1 = arg_61_1.color
				local var_61_2 = var_61_0 and 255 or 200

				var_61_1[2] = var_61_2
				var_61_1[3] = var_61_2
				var_61_1[4] = var_61_2
			end,
			content_check_function = function(arg_62_0)
				return arg_62_0.scroll_bar_info.bar_length_percentage < 1
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background",
			content_check_function = function(arg_63_0)
				return not arg_63_0.disable_background
			end
		}
	}
	local var_49_4 = {
		disable_frame = false,
		scroll = {},
		disable_background = arg_49_4,
		scroll_bar_info = {
			button_scroll_step = 0.1,
			axis = 1,
			value = 0,
			bar_length_percentage = 1,
			scenegraph_id = arg_49_0,
			scroll_length = arg_49_2[1]
		},
		background = "chain_link_horizontal_01" .. (var_49_2 or ""),
		thumb_left = "chain_scrollbutton_left" .. (var_49_0 or ""),
		thumb_right = "chain_scrollbutton_right" .. (var_49_0 or ""),
		thumb_middle = "chain_scrollbutton_horizontal_middle" .. (var_49_0 or "")
	}
	local var_49_5 = {
		background = {
			offset = {
				0,
				0,
				0
			},
			texture_tiling_size = {
				19,
				16
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		hotspot = {
			offset = {
				0,
				arg_49_2[2] / 2 - 16,
				2
			},
			size = {
				arg_49_2[1],
				32
			}
		},
		thumb_left = {
			offset = {
				0,
				arg_49_2[2] / 2 - 16,
				2
			},
			size = {
				27,
				32
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		thumb_right = {
			offset = {
				0,
				arg_49_2[2] / 2 - 16,
				20
			},
			size = {
				28,
				32
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		thumb_middle = {
			offset = {
				0,
				arg_49_2[2] / 2 - 16,
				2
			},
			size = {
				arg_49_2[1],
				32
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}

	if arg_49_1 then
		var_49_3[#var_49_3 + 1] = {
			style_id = "scroll_area_hotspot",
			pass_type = "scroll",
			content_id = "scroll_area_hotspot",
			scroll_function = function(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5)
				local var_64_0 = arg_64_4.x * -1
				local var_64_1 = arg_64_2.parent.scroll_bar_info
				local var_64_2 = var_64_1.total_scroll_height

				if var_64_0 ~= 0 and arg_64_2.is_hover then
					var_64_1.axis_input = var_64_0
					var_64_1.scroll_add = var_64_0 * var_64_1.scroll_amount
				else
					local var_64_3 = var_64_1.axis_input
				end

				local var_64_4 = var_64_1.scroll_add

				if var_64_4 then
					local var_64_5 = var_64_4 * (arg_64_5 * 5)
					local var_64_6 = var_64_4 - var_64_5

					if math.abs(var_64_6) > 0 then
						var_64_1.scroll_add = var_64_6
					else
						var_64_1.scroll_add = nil
					end

					local var_64_7 = var_64_1.scroll_value

					var_64_1.scroll_value = math.clamp(var_64_7 + var_64_5, 0, 1)
				end
			end
		}
		var_49_5.scroll_area_hotspot = {
			offset = {
				0,
				0,
				0
			},
			scenegraph_id = arg_49_1
		}
		var_49_4.scroll_area_hotspot = {}
	end

	return {
		element = {
			passes = var_49_3
		},
		content = var_49_4,
		style = var_49_5,
		scenegraph_id = arg_49_0
	}
end

function UIWidgets.create_scrollbar(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6)
	local var_65_0 = {
		{
			pass_type = "local_offset",
			content_check_function = function(arg_66_0)
				return arg_66_0.scroll_bar_info.bar_height_percentage < 1
			end,
			offset_function = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
				local var_67_0 = arg_67_2.scroll_bar_info
				local var_67_1 = var_67_0.axis
				local var_67_2 = arg_67_1.hotspot
				local var_67_3 = arg_67_1.scroll_bar_box
				local var_67_4 = var_67_0.scroll_length
				local var_67_5 = var_67_0.bar_height_percentage

				var_67_2.size[var_67_1] = var_67_4 * var_67_5
				var_67_3.size[var_67_1] = var_67_4 * var_67_5
			end
		},
		{
			style_id = "hotspot",
			pass_type = "held",
			content_id = "scroll_bar_info",
			content_check_function = function(arg_68_0)
				return arg_68_0.bar_height_percentage < 1
			end,
			held_function = function(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
				local var_69_0 = arg_69_2.axis
				local var_69_1 = Managers.input:is_device_active("gamepad")
				local var_69_2 = arg_69_3:get("cursor")
				local var_69_3 = UIInverseScaleVectorToResolution(var_69_2)[var_69_0]

				if IS_XB1 and not var_69_1 then
					var_69_3 = 1080 - var_69_2.y
				end

				local var_69_4 = UISceneGraph.get_world_position(arg_69_0, arg_69_2.scenegraph_id)[var_69_0]
				local var_69_5 = arg_69_2.scroll_length
				local var_69_6 = math.clamp(var_69_3 - var_69_4, 0, var_69_5)
				local var_69_7 = arg_69_1.size[var_69_0]

				if not arg_69_2.input_offset then
					arg_69_2.input_offset = var_69_6 - arg_69_1.offset[var_69_0]
				end

				local var_69_8 = arg_69_2.input_offset
				local var_69_9 = 0
				local var_69_10 = var_69_5 - var_69_7
				local var_69_11 = var_69_6 - var_69_8

				arg_69_2.value = 1 - math.clamp(var_69_11, var_69_9, var_69_10) / var_69_10
			end,
			release_function = function(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
				arg_70_2.input_offset = nil
			end
		},
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "scroll_bar_info"
		},
		{
			pass_type = "local_offset",
			content_id = "scroll_bar_info",
			content_check_function = function(arg_71_0)
				return arg_71_0.bar_height_percentage < 1
			end,
			offset_function = function(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
				local var_72_0 = arg_72_2.axis
				local var_72_1 = arg_72_1.hotspot
				local var_72_2 = 1 - arg_72_2.value
				local var_72_3 = arg_72_2.scroll_length
				local var_72_4 = var_72_1.size[var_72_0]
				local var_72_5 = 0
				local var_72_6 = var_72_3 - var_72_4
				local var_72_7 = var_72_6 * var_72_2
				local var_72_8 = math.clamp(var_72_7, var_72_5, var_72_6)

				var_72_1.offset[var_72_0] = var_72_8
				arg_72_1.scroll_bar_box.offset[var_72_0] = var_72_8
			end
		},
		{
			pass_type = "rounded_background",
			style_id = "background"
		},
		{
			pass_type = "rounded_background",
			style_id = "scroll_bar_box"
		}
	}
	local var_65_1 = {
		disable_frame = false,
		scroll = {},
		scroll_bar_info = {
			button_scroll_step = 0.1,
			axis = 2,
			value = 0,
			bar_height_percentage = 1,
			scenegraph_id = arg_65_0,
			scroll_length = arg_65_1[2]
		},
		button_up_hotspot = {},
		button_down_hotspot = {}
	}
	local var_65_2 = {
		background = {
			corner_radius = arg_65_6 or 2,
			color = arg_65_4 or {
				255,
				5,
				5,
				5
			}
		},
		scroll_bar_box = {
			corner_radius = arg_65_6 or 2,
			offset = {
				arg_65_5 and arg_65_1[1] / 2 - arg_65_5 * 0.5 or 0,
				0,
				1
			},
			size = {
				arg_65_5,
				arg_65_1[2]
			},
			color = arg_65_3 or Colors.get_color_table_with_alpha("font_button_normal", 255)
		},
		hotspot = {
			offset = {
				0,
				0,
				2
			},
			size = {
				arg_65_1[1],
				arg_65_1[2]
			}
		}
	}
	local var_65_3 = {
		element = {
			passes = var_65_0
		},
		content = var_65_1,
		style = var_65_2,
		scenegraph_id = arg_65_0
	}

	if arg_65_2 then
		var_65_0[#var_65_0 + 1] = {
			style_id = "scroll_area_hotspot",
			pass_type = "scroll",
			content_id = "scroll_area_hotspot",
			scroll_function = function(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5)
				local var_73_0 = Managers.input:is_device_active("gamepad")
				local var_73_1 = arg_73_4.y * -1
				local var_73_2 = arg_73_2.parent.scroll_bar_info
				local var_73_3 = var_73_2.total_scroll_height
				local var_73_4 = var_73_2.scroll_amount

				if var_73_1 ~= 0 and (arg_73_2.is_hover or var_73_0) then
					var_73_2.axis_input = var_73_1
					var_73_2.scroll_add = (var_73_2.scroll_add or 0) + var_73_1 * var_73_4
				else
					local var_73_5 = var_73_2.axis_input
				end

				local var_73_6 = var_73_2.scroll_add

				if var_73_6 then
					local var_73_7 = var_73_6 * (arg_73_5 * (var_73_2.scroll_speed or 5))
					local var_73_8 = var_73_6 - var_73_7

					if math.abs(var_73_8) > var_73_4 / 20 then
						var_73_2.scroll_add = var_73_8
					else
						var_73_2.scroll_add = nil
					end

					local var_73_9 = var_73_2.scroll_value

					if var_73_9 then
						var_73_2.scroll_value = math.clamp(var_73_9 + var_73_7, 0, 1)
					end
				end
			end
		}
		var_65_2.scroll_area_hotspot = {
			offset = {
				0,
				0,
				0
			},
			scenegraph_id = arg_65_2
		}
		var_65_1.scroll_area_hotspot = {}
	end

	return var_65_3
end

function UIWidgets.create_lock_icon(arg_74_0, arg_74_1)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "unlock_texture",
					texture_id = "unlock_texture"
				},
				{
					style_id = "level_text",
					pass_type = "text",
					text_id = "level_text"
				}
			}
		},
		content = {
			unlock_texture = "locked_icon_01",
			level_text = tostring(arg_74_1)
		},
		style = {
			unlock_texture = {
				size = {
					30,
					38
				},
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
			level_text = {
				vertical_alignment = "center",
				word_wrap = false,
				horizontal_alignment = "center",
				font_size = 28,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					15,
					-15,
					2
				}
			}
		},
		scenegraph_id = arg_74_0
	}
end

function UIWidgets.create_quest_navigation_button(arg_75_0, arg_75_1, arg_75_2)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_76_0)
						return not arg_76_0.disabled
					end
				},
				{
					pass_type = "hotspot",
					content_id = "tooltip_hotspot",
					content_check_function = function(arg_77_0)
						return not arg_77_0.disabled
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_id = "texture_id",
					content_check_function = function(arg_78_0)
						local var_78_0 = arg_78_0.parent.button_hotspot

						return not var_78_0.is_hover and var_78_0.is_clicked ~= 0 and not var_78_0.disabled
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_id = "texture_hover_id",
					content_check_function = function(arg_79_0)
						local var_79_0 = arg_79_0.parent.button_hotspot

						return var_79_0.is_selected or var_79_0.is_hover and var_79_0.is_clicked ~= 0 and not var_79_0.disabled
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "texture_click_id",
					texture_id = "texture_click_id",
					content_id = "texture_click_id",
					content_check_function = function(arg_80_0)
						return arg_80_0.parent.button_hotspot.is_clicked == 0 and not arg_80_0.parent.button_hotspot.disabled
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "texture_disabled_id",
					texture_id = "texture_disabled_id",
					content_id = "texture_disabled_id",
					content_check_function = function(arg_81_0)
						return arg_81_0.parent.button_hotspot.disabled
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function(arg_82_0)
						return arg_82_0.tooltip_text and arg_82_0.button_hotspot.is_hover and arg_82_0.tooltip_hotspot.is_hover and not arg_82_0.button_hotspot.disabled
					end
				}
			}
		},
		content = {
			texture_id = {
				texture_id = "quest_board_arrow_normal",
				uvs = arg_75_1
			},
			texture_hover_id = {
				texture_hover_id = "quest_board_arrow_hover",
				uvs = arg_75_1
			},
			texture_click_id = {
				texture_click_id = "quest_board_arrow_hover",
				uvs = arg_75_1
			},
			texture_disabled_id = {
				texture_disabled_id = "quest_board_arrow_hover",
				uvs = arg_75_1
			},
			tooltip_text = arg_75_2,
			button_hotspot = {},
			tooltip_hotspot = {}
		},
		style = {
			texture_id = {
				size = {
					42,
					64
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_hover_id = {
				size = {
					42,
					64
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_click_id = {
				size = {
					38,
					58
				},
				offset = {
					2,
					3,
					0
				},
				color = {
					255,
					200,
					200,
					200
				}
			},
			texture_disabled_id = {
				size = {
					42,
					64
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					190,
					120,
					120,
					120
				}
			},
			tooltip_text = {
				font_size = 18,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				offset = {
					0,
					0,
					50
				}
			}
		},
		scenegraph_id = arg_75_0
	}
end

function UIWidgets.create_gold_button_3_state(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function(arg_84_0)
						return not arg_84_0.button_hotspot.is_hover and arg_84_0.button_hotspot.is_clicked > 0
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_85_0)
						return arg_85_0.button_hotspot.is_selected or arg_85_0.button_hotspot.is_hover and arg_85_0.button_hotspot.is_clicked > 0
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function(arg_86_0)
						return arg_86_0.button_hotspot.is_clicked == 0
					end
				},
				{
					localize = true,
					style_id = "text",
					pass_type = "text",
					text_id = "text_field"
				}
			}
		},
		content = {
			texture_id = arg_83_2 or "small_button_gold_normal",
			texture_hover_id = arg_83_3 or "small_button_gold_hover",
			texture_click_id = arg_83_4 or "small_button_gold_selected",
			text_field = Localize(arg_83_0),
			button_hotspot = {}
		},
		style = {
			text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				},
				scenegraph_id = arg_83_1
			}
		},
		scenegraph_id = arg_83_1
	}
end

function UIWidgets.create_gamepad_bar_input_extension(arg_87_0)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "input_bg",
					texture_id = "input_bg",
					content_check_function = function(arg_88_0)
						return arg_88_0.is_gamepad_active
					end
				},
				{
					texture_id = "input_icon",
					style_id = "input_icon",
					pass_type = "texture",
					content_check_function = function(arg_89_0)
						return arg_89_0.is_gamepad_active and arg_89_0.show_input
					end
				},
				{
					texture_id = "input_icon_overlay",
					style_id = "input_icon_overlay",
					pass_type = "texture",
					content_check_function = function(arg_90_0)
						return arg_90_0.is_gamepad_active and arg_90_0.charging
					end
				}
			}
		},
		content = {
			input_bg = "forge_button_gamepad_icon_holder",
			input_icon_overlay = "input_button_icon_overlay_01",
			show_input = false,
			chargring = false,
			input_icon = "xbone_button_icon_y"
		},
		style = {
			input_icon = {
				size = {
					34,
					34
				},
				offset = {
					97,
					42,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			input_icon_overlay = {
				size = {
					34,
					34
				},
				offset = {
					97,
					42,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			input_bg = {
				size = {
					81,
					44
				},
				offset = {
					71,
					36,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_87_0
	}
end

function UIWidgets.create_forge_merge_button(arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_92_0)
						return (not arg_92_0.charging or arg_92_0.show_cancel_text) and not arg_92_0.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function(arg_93_0)
						local var_93_0 = arg_93_0.button_hotspot

						return not arg_93_0.is_gamepad_active and not var_93_0.disabled and not var_93_0.is_hover and (not var_93_0.is_clicked or var_93_0.is_clicked and var_93_0.is_clicked > 0)
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_94_0)
						local var_94_0 = arg_94_0.button_hotspot

						return not arg_94_0.is_gamepad_active and not var_94_0.disabled and var_94_0.is_hover and (not var_94_0.is_clicked or var_94_0.is_clicked and var_94_0.is_clicked > 0)
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function(arg_95_0)
						local var_95_0 = arg_95_0.button_hotspot

						return not arg_95_0.is_gamepad_active and not var_95_0.disabled and var_95_0.is_clicked and var_95_0.is_clicked == 0 or var_95_0.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function(arg_96_0)
						local var_96_0 = arg_96_0.button_hotspot

						return not arg_96_0.is_gamepad_active and var_96_0.disabled
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type",
					pass_type = "texture",
					content_check_function = function(arg_97_0)
						local var_97_0 = arg_97_0.button_hotspot

						return not arg_97_0.charging and not arg_97_0.show_cancel_text and arg_97_0.show_tokens and arg_97_0.texture_token_type and (not var_97_0.is_clicked or var_97_0.is_clicked and var_97_0.is_clicked > 0) and not var_97_0.is_selected
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type_selected",
					pass_type = "texture",
					content_check_function = function(arg_98_0)
						local var_98_0 = arg_98_0.button_hotspot

						return not arg_98_0.charging and not arg_98_0.show_cancel_text and arg_98_0.show_tokens and arg_98_0.texture_token_type and var_98_0.is_clicked == 0 or var_98_0.is_selected
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_99_0)
						local var_99_0 = arg_99_0.button_hotspot

						return not arg_99_0.charging and not arg_99_0.show_cancel_text and not var_99_0.is_hover and arg_99_0.show_tokens and (not var_99_0.is_clicked or var_99_0.is_clicked and var_99_0.is_clicked > 0) and not var_99_0.is_selected
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_100_0)
						local var_100_0 = arg_100_0.button_hotspot

						return var_100_0.is_hover and arg_100_0.show_tokens and (not var_100_0.is_clicked or var_100_0.is_clicked and var_100_0.is_clicked > 0) and not var_100_0.is_selected
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_101_0)
						local var_101_0 = arg_101_0.button_hotspot

						return not arg_101_0.charging and not arg_101_0.show_cancel_text and arg_101_0.show_tokens and var_101_0.is_clicked == 0 or var_101_0.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_102_0)
						return arg_102_0.button_hotspot.disabled and arg_102_0.is_disabled
					end
				},
				{
					style_id = "text_center",
					pass_type = "text",
					text_id = "text_field_center",
					content_check_function = function(arg_103_0)
						local var_103_0 = arg_103_0.button_hotspot

						return not arg_103_0.charging and not arg_103_0.show_cancel_text and not var_103_0.disabled and not var_103_0.is_hover and not var_103_0.is_selected and not arg_103_0.show_tokens
					end
				},
				{
					style_id = "text_hover_center",
					pass_type = "text",
					text_id = "text_field_center",
					content_check_function = function(arg_104_0)
						local var_104_0 = arg_104_0.button_hotspot

						return not arg_104_0.charging and not arg_104_0.show_cancel_text and not var_104_0.disabled and var_104_0.is_hover and var_104_0.is_clicked > 0 and not arg_104_0.show_tokens
					end
				},
				{
					style_id = "text_selected_center",
					pass_type = "text",
					text_id = "text_field_center",
					content_check_function = function(arg_105_0)
						local var_105_0 = arg_105_0.button_hotspot

						return not arg_105_0.charging and not arg_105_0.show_cancel_text and not arg_105_0.is_disabled and (var_105_0.is_clicked == 0 or var_105_0.is_selected) and not arg_105_0.show_tokens
					end
				},
				{
					style_id = "token_text",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function(arg_106_0)
						local var_106_0 = arg_106_0.button_hotspot

						return not arg_106_0.charging and not arg_106_0.show_cancel_text and not var_106_0.is_hover and arg_106_0.show_tokens and (not var_106_0.is_clicked or var_106_0.is_clicked and var_106_0.is_clicked > 0) and not var_106_0.is_selected
					end
				},
				{
					style_id = "token_text_hover",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function(arg_107_0)
						local var_107_0 = arg_107_0.button_hotspot

						return not arg_107_0.charging and not arg_107_0.show_cancel_text and var_107_0.is_hover and arg_107_0.show_tokens and (not var_107_0.is_clicked or var_107_0.is_clicked and var_107_0.is_clicked > 0) and not var_107_0.is_selected
					end
				},
				{
					style_id = "token_text_selected",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function(arg_108_0)
						local var_108_0 = arg_108_0.button_hotspot

						return not arg_108_0.charging and not arg_108_0.show_cancel_text and arg_108_0.show_tokens and var_108_0.is_clicked == 0 or var_108_0.is_selected
					end
				},
				{
					style_id = "text_charge_cancelled",
					pass_type = "text",
					text_id = "text_charge_cancelled",
					content_check_function = function(arg_109_0)
						local var_109_0 = arg_109_0.button_hotspot

						return arg_109_0.is_gamepad_active and arg_109_0.show_cancel_text
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame",
					content_check_function = function(arg_110_0)
						local var_110_0 = arg_110_0.button_hotspot

						return arg_110_0.is_gamepad_active and not var_110_0.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame_disabled",
					content_check_function = function(arg_111_0)
						local var_111_0 = arg_111_0.button_hotspot

						return arg_111_0.is_gamepad_active and var_111_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg",
					content_check_function = function(arg_112_0)
						local var_112_0 = arg_112_0.button_hotspot

						return arg_112_0.is_gamepad_active and not var_112_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg_disabled",
					content_check_function = function(arg_113_0)
						local var_113_0 = arg_113_0.button_hotspot

						return arg_113_0.is_gamepad_active and var_113_0.disabled
					end
				},
				{
					style_id = "progress_fill",
					pass_type = "texture_uv",
					content_id = "progress_fill",
					content_check_function = function(arg_114_0)
						return arg_114_0.parent.is_gamepad_active
					end
				},
				{
					texture_id = "progress_fill_glow",
					style_id = "progress_fill_glow",
					pass_type = "texture",
					content_check_function = function(arg_115_0)
						return arg_115_0.is_gamepad_active
					end
				},
				{
					texture_id = "progress_input_icon",
					style_id = "progress_input_icon",
					pass_type = "texture",
					content_check_function = function(arg_116_0)
						local var_116_0 = arg_116_0.button_hotspot

						return arg_116_0.is_gamepad_active and not var_116_0.disabled
					end
				},
				{
					texture_id = "progress_input_icon_overlay",
					style_id = "progress_input_icon_overlay",
					pass_type = "texture",
					content_check_function = function(arg_117_0)
						local var_117_0 = arg_117_0.button_hotspot

						return arg_117_0.is_gamepad_active and not var_117_0.disabled and arg_117_0.charging
					end
				},
				{
					texture_id = "eye_glow_texture",
					style_id = "eye_glow_texture",
					pass_type = "texture",
					content_check_function = function(arg_118_0)
						local var_118_0 = arg_118_0.button_hotspot

						return not arg_118_0.is_gamepad_active and arg_118_0.use_eye_glow and not var_118_0.disabled
					end
				},
				{
					texture_id = "gamepad_glow_texture",
					style_id = "gamepad_glow_texture",
					pass_type = "texture",
					content_check_function = function(arg_119_0)
						local var_119_0 = arg_119_0.button_hotspot

						return arg_119_0.is_gamepad_active and not var_119_0.disabled
					end
				}
			}
		},
		content = {
			show_tokens = false,
			progress_frame_bg_disabled = "forge_button_gamepad_bg_disabled",
			is_disabled = true,
			show_cancel_text = false,
			progress_fill_glow = "forge_button_gamepad_glow_02",
			progress_frame_bg = "forge_button_gamepad_bg",
			charging = false,
			texture_hover_id = "forge_button_03_hover",
			texture_click_id = "forge_button_03_selected",
			eye_glow_texture = "forge_button_03_glow_effect",
			token_text = "",
			progress_frame_disabled = "forge_button_gamepad_disabled",
			progress_input_icon = "xbone_button_icon_y",
			progress_input_icon_overlay = "input_button_icon_overlay_01",
			progress_frame = "forge_button_gamepad_frame",
			gamepad_glow_texture = "forge_button_gamepad_glow",
			texture_disabled_id = "forge_button_03_disabled",
			texture_id = "forge_button_03_normal",
			use_eye_glow = arg_91_3 and true or false,
			text_field = Localize("merge"),
			text_field_center = Localize("merge"),
			button_hotspot = {},
			text_charge_cancelled = Localize("forge_screen_melt_abort"),
			progress_fill = {
				texture_id = "forge_button_gamepad_fill_02",
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
		},
		style = {
			eye_glow_texture = {
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = arg_91_3
			},
			gamepad_glow_texture = {
				size = {
					304,
					20
				},
				offset = {
					17,
					81,
					4
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			progress_fill = {
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
				scenegraph_id = arg_91_4
			},
			progress_input_icon = {
				size = {
					34,
					34
				},
				offset = {
					152,
					85,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			progress_input_icon_overlay = {
				size = {
					34,
					34
				},
				offset = {
					152,
					85,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			progress_frame_bg = {
				size = {
					305,
					67
				},
				offset = {
					0,
					0,
					-1
				},
				scenegraph_id = arg_91_4
			},
			progress_fill_glow = {
				size = {
					341,
					104
				},
				offset = {
					-17,
					-18,
					5
				},
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = arg_91_4
			},
			text_charge_cancelled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					0,
					-10,
					2
				}
			},
			texture_token_type = {
				color = {
					255,
					255,
					255,
					255
				},
				scenegraph_id = arg_91_2
			},
			texture_token_type_selected = {
				offset = {
					0,
					-2,
					0
				},
				scenegraph_id = arg_91_2
			},
			text = {
				font_size = 24,
				horizontal_alignment = "left",
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					10,
					0,
					2
				},
				scenegraph_id = arg_91_1
			},
			text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					10,
					0,
					2
				},
				scenegraph_id = arg_91_1
			},
			text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					10,
					-2,
					2
				},
				scenegraph_id = arg_91_1
			},
			text_center = {
				vertical_alignment = "center",
				dynamic_font = true,
				horizontal_alignment = "center",
				font_size = 24,
				pixel_perfect = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					0,
					-10,
					2
				}
			},
			text_hover_center = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-10,
					2
				}
			},
			text_selected_center = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					0,
					-10,
					2
				}
			},
			token_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					180,
					0,
					2
				},
				scenegraph_id = arg_91_1
			},
			token_text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					180,
					0,
					2
				},
				scenegraph_id = arg_91_1
			},
			token_text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					180,
					-2,
					2
				},
				scenegraph_id = arg_91_1
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					-10,
					2
				}
			}
		},
		scenegraph_id = arg_91_0
	}
end

function UIWidgets.create_altar_button(arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_121_0)
						return not arg_121_0.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function(arg_122_0)
						local var_122_0 = arg_122_0.button_hotspot

						if arg_122_0.enable_charge and arg_122_0.is_gamepad_active then
							return false
						end

						return not var_122_0.disabled and not var_122_0.is_hover and (not var_122_0.is_clicked or var_122_0.is_clicked and var_122_0.is_clicked > 0)
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_123_0)
						local var_123_0 = arg_123_0.button_hotspot

						if arg_123_0.enable_charge and arg_123_0.is_gamepad_active then
							return false
						end

						return not var_123_0.disabled and var_123_0.is_hover and (not var_123_0.is_clicked or var_123_0.is_clicked and var_123_0.is_clicked > 0)
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function(arg_124_0)
						local var_124_0 = arg_124_0.button_hotspot

						if arg_124_0.enable_charge and arg_124_0.is_gamepad_active then
							return false
						end

						return not var_124_0.disabled and var_124_0.is_clicked and var_124_0.is_clicked == 0 or var_124_0.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function(arg_125_0)
						local var_125_0 = arg_125_0.button_hotspot

						if arg_125_0.enable_charge and arg_125_0.is_gamepad_active then
							return false
						end

						return var_125_0.disabled
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type",
					pass_type = "texture",
					content_check_function = function(arg_126_0)
						local var_126_0 = arg_126_0.button_hotspot

						if arg_126_0.enable_charge and (arg_126_0.charging or arg_126_0.show_cancel_text) then
							return false
						end

						return (not var_126_0.disabled or var_126_0.disabled and arg_126_0.default_text_on_disable) and arg_126_0.texture_token_type and (not var_126_0.is_clicked or var_126_0.is_clicked and var_126_0.is_clicked > 0) and not var_126_0.is_selected
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type_selected",
					pass_type = "texture",
					content_check_function = function(arg_127_0)
						local var_127_0 = arg_127_0.button_hotspot

						if arg_127_0.enable_charge and (arg_127_0.charging or arg_127_0.show_cancel_text) then
							return false
						end

						return not var_127_0.disabled and arg_127_0.texture_token_type and (var_127_0.is_selected or var_127_0.is_clicked and var_127_0.is_clicked == 0)
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_128_0)
						local var_128_0 = arg_128_0.button_hotspot

						if arg_128_0.enable_charge and (arg_128_0.charging or arg_128_0.show_cancel_text) then
							return false
						end

						return (not var_128_0.disabled or var_128_0.disabled and arg_128_0.default_text_on_disable) and not var_128_0.is_hover and (not var_128_0.is_clicked or var_128_0.is_clicked and var_128_0.is_clicked > 0) and not var_128_0.is_selected
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_129_0)
						local var_129_0 = arg_129_0.button_hotspot

						if arg_129_0.enable_charge and (arg_129_0.charging or arg_129_0.show_cancel_text) then
							return false
						end

						return not var_129_0.disabled and var_129_0.is_hover and (not var_129_0.is_clicked or var_129_0.is_clicked and var_129_0.is_clicked > 0) and not var_129_0.is_selected
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_130_0)
						local var_130_0 = arg_130_0.button_hotspot

						if arg_130_0.enable_charge and (arg_130_0.charging or arg_130_0.show_cancel_text) then
							return false
						end

						return not var_130_0.disabled and var_130_0.is_clicked == 0 or var_130_0.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_131_0)
						return arg_131_0.button_hotspot.disabled and not arg_131_0.default_text_on_disable
					end
				},
				{
					style_id = "token_text",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function(arg_132_0)
						local var_132_0 = arg_132_0.button_hotspot

						if arg_132_0.enable_charge and (arg_132_0.charging or arg_132_0.show_cancel_text) then
							return false
						end

						return (not var_132_0.disabled or var_132_0.disabled and arg_132_0.default_text_on_disable) and not var_132_0.is_hover and (not var_132_0.is_clicked or var_132_0.is_clicked and var_132_0.is_clicked > 0) and not var_132_0.is_selected
					end
				},
				{
					style_id = "token_text_hover",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function(arg_133_0)
						local var_133_0 = arg_133_0.button_hotspot

						if arg_133_0.enable_charge and (arg_133_0.charging or arg_133_0.show_cancel_text) then
							return false
						end

						return not var_133_0.disabled and var_133_0.is_hover and (not var_133_0.is_clicked or var_133_0.is_clicked and var_133_0.is_clicked > 0) and not var_133_0.is_selected
					end
				},
				{
					style_id = "token_text_selected",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function(arg_134_0)
						local var_134_0 = arg_134_0.button_hotspot

						return not arg_134_0.charging and not arg_134_0.show_cancel_text and not var_134_0.disabled and var_134_0.is_clicked == 0 or var_134_0.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "button_frame_texture",
					texture_id = "button_frame_texture",
					content_check_function = function(arg_135_0)
						return not arg_135_0.is_gamepad_active and arg_135_0.show_frame
					end
				},
				{
					pass_type = "texture",
					style_id = "button_frame_glow_texture",
					texture_id = "button_frame_glow_texture",
					content_check_function = function(arg_136_0)
						return arg_136_0.show_glow
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame",
					content_check_function = function(arg_137_0)
						local var_137_0 = arg_137_0.button_hotspot

						return arg_137_0.enable_charge and arg_137_0.is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg",
					content_check_function = function(arg_138_0)
						local var_138_0 = arg_138_0.button_hotspot

						return arg_138_0.enable_charge and arg_138_0.is_gamepad_active and not var_138_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg_disabled",
					content_check_function = function(arg_139_0)
						local var_139_0 = arg_139_0.button_hotspot

						return arg_139_0.enable_charge and arg_139_0.is_gamepad_active and var_139_0.disabled
					end
				},
				{
					style_id = "progress_fill",
					pass_type = "texture_uv",
					content_id = "progress_fill",
					content_check_function = function(arg_140_0)
						local var_140_0 = arg_140_0.parent

						return var_140_0.enable_charge and var_140_0.is_gamepad_active
					end
				},
				{
					texture_id = "progress_fill_glow",
					style_id = "progress_fill_glow",
					pass_type = "texture",
					content_check_function = function(arg_141_0)
						return arg_141_0.enable_charge and arg_141_0.is_gamepad_active
					end
				},
				{
					texture_id = "progress_input_icon",
					style_id = "progress_input_icon",
					pass_type = "texture",
					content_check_function = function(arg_142_0)
						local var_142_0 = arg_142_0.button_hotspot

						return not arg_142_0.disable_input_icon and (arg_142_0.enable_input_icon or arg_142_0.enable_charge) and arg_142_0.is_gamepad_active and not var_142_0.disabled
					end
				},
				{
					texture_id = "progress_input_bg",
					style_id = "progress_input_bg",
					pass_type = "texture",
					content_check_function = function(arg_143_0)
						local var_143_0 = arg_143_0.button_hotspot

						return (arg_143_0.enable_input_icon or arg_143_0.enable_charge) and arg_143_0.is_gamepad_active
					end
				},
				{
					texture_id = "progress_input_icon_overlay",
					style_id = "progress_input_icon_overlay",
					pass_type = "texture",
					content_check_function = function(arg_144_0)
						local var_144_0 = arg_144_0.button_hotspot

						return (arg_144_0.enable_input_icon or arg_144_0.enable_charge) and arg_144_0.is_gamepad_active and not var_144_0.disabled and arg_144_0.charging
					end
				},
				{
					style_id = "text_charge_cancelled",
					pass_type = "text",
					text_id = "text_charge_cancelled",
					content_check_function = function(arg_145_0)
						local var_145_0 = arg_145_0.button_hotspot

						return arg_145_0.enable_charge and arg_145_0.is_gamepad_active and arg_145_0.show_cancel_text
					end
				}
			}
		},
		content = {
			enable_input_icon = false,
			enable_charge = false,
			progress_fill_glow = "forge_button_gamepad_glow_03",
			progress_frame_bg = "forge_button_gamepad_bg",
			progress_frame_disabled = "forge_button_gamepad_disabled",
			button_frame_texture = "button_frame_large",
			charging = false,
			progress_input_bg = "forge_button_gamepad_icon_holder",
			texture_click_id = "medium_button_selected",
			progress_input_icon_overlay = "input_button_icon_overlay_01",
			progress_frame = "altar_button_gamepad_frame_02",
			disable_input_icon = false,
			texture_hover_id = "medium_button_hover",
			progress_input_icon = "xbone_button_icon_y",
			button_frame_glow_texture = "reroll_glow_button",
			show_cancel_text = false,
			show_frame = false,
			show_glow = true,
			progress_frame_bg_disabled = "forge_button_gamepad_bg_disabled",
			token_text = "",
			texture_disabled_id = "medium_button_disabled",
			default_text_on_disable = false,
			texture_id = "medium_button_normal",
			text_charge_cancelled = Localize("forge_screen_melt_abort"),
			progress_fill = {
				texture_id = "forge_button_gamepad_fill",
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
			text_field = Localize(arg_120_0),
			button_hotspot = {}
		},
		style = {
			progress_fill = {
				offset = {
					-10,
					9,
					0
				},
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = arg_120_4
			},
			progress_input_icon = {
				size = {
					34,
					34
				},
				offset = {
					142,
					78,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			progress_input_bg = {
				size = {
					81,
					44
				},
				offset = {
					116,
					72,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			progress_input_icon_overlay = {
				size = {
					34,
					34
				},
				offset = {
					142,
					78,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			progress_frame_bg = {
				size = {
					305,
					67
				},
				offset = {
					-9,
					10,
					-1
				},
				scenegraph_id = arg_120_4
			},
			progress_fill_glow = {
				size = {
					341,
					104
				},
				offset = {
					-27,
					-9,
					5
				},
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = arg_120_4
			},
			text_charge_cancelled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					0,
					-4,
					2
				}
			},
			button_frame_texture = {
				size = {
					343,
					106
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-12,
					-15,
					0
				}
			},
			button_frame_glow_texture = {
				size = {
					400,
					140
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-42,
					-29,
					-3
				}
			},
			texture_token_type = {
				color = {
					255,
					255,
					255,
					255
				},
				scenegraph_id = arg_120_3
			},
			texture_token_type_selected = {
				offset = {
					0,
					-2,
					0
				},
				scenegraph_id = arg_120_3
			},
			text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				horizontal_alignment = arg_120_2 and "left" or "center",
				offset = {
					arg_120_2 and 10 or 0,
					0,
					2
				},
				scenegraph_id = arg_120_2
			},
			text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				horizontal_alignment = arg_120_2 and "left" or "center",
				offset = {
					arg_120_2 and 10 or 0,
					0,
					2
				},
				scenegraph_id = arg_120_2
			},
			text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				horizontal_alignment = arg_120_2 and "left" or "center",
				offset = {
					arg_120_2 and 10 or 0,
					-2,
					2
				},
				scenegraph_id = arg_120_2
			},
			token_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					180,
					0,
					2
				},
				scenegraph_id = arg_120_2
			},
			token_text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					180,
					0,
					2
				},
				scenegraph_id = arg_120_2
			},
			token_text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					180,
					-2,
					2
				},
				scenegraph_id = arg_120_2
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					-4,
					2
				}
			}
		},
		scenegraph_id = arg_120_1
	}
end

function UIWidgets.create_dice_game_button(arg_146_0)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_147_0)
						return not arg_147_0.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function(arg_148_0)
						local var_148_0 = arg_148_0.button_hotspot

						return not var_148_0.disabled and not var_148_0.is_hover and var_148_0.is_clicked and var_148_0.is_clicked > 0
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_149_0)
						local var_149_0 = arg_149_0.button_hotspot

						return not var_149_0.disabled and var_149_0.is_hover and var_149_0.is_clicked and var_149_0.is_clicked > 0
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function(arg_150_0)
						local var_150_0 = arg_150_0.button_hotspot

						return not var_150_0.disabled and var_150_0.is_clicked and var_150_0.is_clicked == 0 or var_150_0.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function(arg_151_0)
						return arg_151_0.button_hotspot.disabled
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_152_0)
						local var_152_0 = arg_152_0.button_hotspot

						return not var_152_0.disabled and not var_152_0.is_hover and not var_152_0.is_selected
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_153_0)
						local var_153_0 = arg_153_0.button_hotspot

						return not var_153_0.disabled and var_153_0.is_hover and var_153_0.is_clicked > 0
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_154_0)
						local var_154_0 = arg_154_0.button_hotspot

						return not var_154_0.disabled and var_154_0.is_hover and var_154_0.is_clicked == 0
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_155_0)
						return arg_155_0.button_hotspot.disabled
					end
				}
			}
		},
		content = {
			texture_click_id = "forge_button_03_selected",
			texture_id = "forge_button_03_normal",
			texture_hover_id = "forge_button_03_hover",
			texture_disabled_id = "forge_button_03_disabled",
			text_field = Localize("merge"),
			button_hotspot = {}
		},
		style = {
			text = {
				vertical_alignment = "center",
				dynamic_font = true,
				horizontal_alignment = "center",
				font_size = 24,
				pixel_perfect = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					0,
					-10,
					2
				}
			},
			text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-10,
					2
				}
			},
			text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					0,
					-12,
					2
				}
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					-10,
					2
				}
			}
		},
		scenegraph_id = arg_146_0
	}
end

function UIWidgets.create_altar_craft_reagent_button(arg_156_0, arg_156_1, arg_156_2, arg_156_3, arg_156_4)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_157_0)
						return not arg_157_0.disabled
					end
				},
				{
					style_id = "required_hover_hotspot",
					pass_type = "hotspot",
					content_id = "required_hover_hotspot",
					content_check_function = function(arg_158_0)
						return not arg_158_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function(arg_159_0)
						return arg_159_0.tooltip_text and arg_159_0.button_hotspot.is_hover and arg_159_0.required_hover_hotspot.is_hover
					end
				}
			}
		},
		content = {
			texture_id = arg_156_1,
			button_hotspot = {},
			required_hover_hotspot = {},
			tooltip_text = arg_156_3
		},
		style = {
			required_hover_hotspot = {
				scenegraph_id = arg_156_2
			},
			texture_id = {
				masked = arg_156_4,
				color = {
					255,
					255,
					255,
					255
				}
			},
			tooltip_text = {
				vertical_alignment = "top",
				font_type = "hell_shark",
				horizontal_alignment = "left",
				font_size = 18,
				max_width = 500,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				offset = {
					0,
					0,
					50
				}
			}
		},
		scenegraph_id = arg_156_0
	}
end

function UIWidgets.create_forge_upgrade_button(arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_161_0)
						return (not arg_161_0.charging or arg_161_0.show_cancel_text) and not arg_161_0.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function(arg_162_0)
						local var_162_0 = arg_162_0.button_hotspot

						return not arg_162_0.is_gamepad_active and not var_162_0.disabled and not var_162_0.is_hover and (not var_162_0.is_clicked or var_162_0.is_clicked and var_162_0.is_clicked > 0)
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_163_0)
						local var_163_0 = arg_163_0.button_hotspot

						return not arg_163_0.is_gamepad_active and not var_163_0.disabled and var_163_0.is_hover and (not var_163_0.is_clicked or var_163_0.is_clicked and var_163_0.is_clicked > 0)
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function(arg_164_0)
						local var_164_0 = arg_164_0.button_hotspot

						return not arg_164_0.is_gamepad_active and not var_164_0.disabled and var_164_0.is_clicked and var_164_0.is_clicked == 0 or var_164_0.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function(arg_165_0)
						local var_165_0 = arg_165_0.button_hotspot

						return not arg_165_0.is_gamepad_active and var_165_0.disabled
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type",
					pass_type = "texture",
					content_check_function = function(arg_166_0)
						if arg_166_0.texture_token_type then
							local var_166_0 = arg_166_0.button_hotspot

							return not arg_166_0.charging and not arg_166_0.show_cancel_text and not arg_166_0.show_title and arg_166_0.texture_token_type and (not var_166_0.is_clicked or var_166_0.is_clicked and var_166_0.is_clicked > 0) and not var_166_0.is_selected
						end
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type_selected",
					pass_type = "texture",
					content_check_function = function(arg_167_0)
						if arg_167_0.texture_token_type then
							local var_167_0 = arg_167_0.button_hotspot

							return not arg_167_0.charging and not arg_167_0.show_cancel_text and not arg_167_0.show_title and arg_167_0.texture_token_type and var_167_0.is_selected or var_167_0.is_clicked and var_167_0.is_clicked == 0
						end
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_168_0)
						local var_168_0 = arg_168_0.button_hotspot

						return not arg_168_0.charging and not arg_168_0.show_cancel_text and not var_168_0.is_hover and not arg_168_0.show_title and (not var_168_0.is_clicked or var_168_0.is_clicked and var_168_0.is_clicked > 0) and not var_168_0.is_selected
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_169_0)
						local var_169_0 = arg_169_0.button_hotspot

						return not arg_169_0.charging and not arg_169_0.show_cancel_text and var_169_0.is_hover and not arg_169_0.show_title and (not var_169_0.is_clicked or var_169_0.is_clicked and var_169_0.is_clicked > 0) and not var_169_0.is_selected
					end
				},
				{
					style_id = "token_text",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function(arg_170_0)
						local var_170_0 = arg_170_0.button_hotspot

						return not arg_170_0.charging and not arg_170_0.show_cancel_text and not var_170_0.is_hover and not arg_170_0.show_title and (not var_170_0.is_clicked or var_170_0.is_clicked and var_170_0.is_clicked > 0) and not var_170_0.is_selected
					end
				},
				{
					style_id = "token_text_hover",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function(arg_171_0)
						local var_171_0 = arg_171_0.button_hotspot

						return not arg_171_0.charging and not arg_171_0.show_cancel_text and var_171_0.is_hover and not arg_171_0.show_title and (not var_171_0.is_clicked or var_171_0.is_clicked and var_171_0.is_clicked > 0) and not var_171_0.is_selected
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_172_0)
						local var_172_0 = arg_172_0.button_hotspot

						return not arg_172_0.charging and not arg_172_0.show_cancel_text and not arg_172_0.show_title and var_172_0.is_clicked == 0 or var_172_0.is_selected
					end
				},
				{
					style_id = "token_text_selected",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function(arg_173_0)
						local var_173_0 = arg_173_0.button_hotspot

						return not arg_173_0.charging and not arg_173_0.show_cancel_text and not arg_173_0.show_title and var_173_0.is_clicked == 0 or var_173_0.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_174_0)
						return arg_174_0.button_hotspot.disabled and arg_174_0.show_title
					end
				},
				{
					style_id = "text_charge_cancelled",
					pass_type = "text",
					text_id = "text_charge_cancelled",
					content_check_function = function(arg_175_0)
						local var_175_0 = arg_175_0.button_hotspot

						return arg_175_0.is_gamepad_active and arg_175_0.show_cancel_text
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame",
					content_check_function = function(arg_176_0)
						local var_176_0 = arg_176_0.button_hotspot

						return arg_176_0.is_gamepad_active and not var_176_0.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame_disabled",
					content_check_function = function(arg_177_0)
						local var_177_0 = arg_177_0.button_hotspot

						return arg_177_0.is_gamepad_active and var_177_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg",
					content_check_function = function(arg_178_0)
						local var_178_0 = arg_178_0.button_hotspot

						return arg_178_0.is_gamepad_active and not var_178_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg_disabled",
					content_check_function = function(arg_179_0)
						local var_179_0 = arg_179_0.button_hotspot

						return arg_179_0.is_gamepad_active and var_179_0.disabled
					end
				},
				{
					style_id = "progress_fill",
					pass_type = "texture_uv",
					content_id = "progress_fill",
					content_check_function = function(arg_180_0)
						return arg_180_0.parent.is_gamepad_active
					end
				},
				{
					texture_id = "progress_fill_glow",
					style_id = "progress_fill_glow",
					pass_type = "texture",
					content_check_function = function(arg_181_0)
						return arg_181_0.is_gamepad_active
					end
				},
				{
					texture_id = "progress_input_icon",
					style_id = "progress_input_icon",
					pass_type = "texture",
					content_check_function = function(arg_182_0)
						local var_182_0 = arg_182_0.button_hotspot

						return arg_182_0.is_gamepad_active and not var_182_0.disabled
					end
				},
				{
					texture_id = "progress_input_icon_overlay",
					style_id = "progress_input_icon_overlay",
					pass_type = "texture",
					content_check_function = function(arg_183_0)
						local var_183_0 = arg_183_0.button_hotspot

						return arg_183_0.is_gamepad_active and not var_183_0.disabled and arg_183_0.charging
					end
				},
				{
					texture_id = "eye_glow_texture",
					style_id = "eye_glow_texture",
					pass_type = "texture",
					content_check_function = function(arg_184_0)
						local var_184_0 = arg_184_0.button_hotspot

						return not arg_184_0.is_gamepad_active and arg_184_0.use_eye_glow and not var_184_0.disabled
					end
				},
				{
					texture_id = "gamepad_glow_texture",
					style_id = "gamepad_glow_texture",
					pass_type = "texture",
					content_check_function = function(arg_185_0)
						local var_185_0 = arg_185_0.button_hotspot

						return arg_185_0.is_gamepad_active and not var_185_0.disabled
					end
				}
			}
		},
		content = {
			show_cancel_text = false,
			progress_frame_bg_disabled = "forge_button_gamepad_bg_disabled",
			progress_frame_bg = "forge_button_gamepad_bg",
			progress_fill_glow = "forge_button_gamepad_glow_02",
			show_title = true,
			charging = false,
			texture_click_id = "forge_button_03_selected",
			eye_glow_texture = "forge_button_03_glow_effect",
			progress_frame_disabled = "forge_button_gamepad_disabled",
			token_text = "",
			progress_input_icon_overlay = "input_button_icon_overlay_01",
			progress_input_icon = "xbone_button_icon_y",
			progress_frame = "forge_button_gamepad_frame",
			texture_hover_id = "forge_button_03_hover",
			gamepad_glow_texture = "forge_button_gamepad_glow",
			texture_disabled_id = "forge_button_03_disabled",
			texture_id = "forge_button_03_normal",
			progress_fill = {
				texture_id = "forge_button_gamepad_fill_02",
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
			use_eye_glow = arg_160_3 and true or false,
			text_field = Localize("upgrade"),
			button_hotspot = {},
			text_charge_cancelled = Localize("forge_screen_melt_abort")
		},
		style = {
			eye_glow_texture = {
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = arg_160_3
			},
			gamepad_glow_texture = {
				size = {
					304,
					20
				},
				offset = {
					17,
					81,
					4
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			progress_input_icon = {
				size = {
					34,
					34
				},
				offset = {
					152,
					85,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			progress_input_icon_overlay = {
				size = {
					34,
					34
				},
				offset = {
					152,
					85,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			progress_frame_bg = {
				size = {
					305,
					67
				},
				offset = {
					0,
					0,
					-1
				},
				scenegraph_id = arg_160_4
			},
			progress_fill = {
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
				scenegraph_id = arg_160_4
			},
			progress_fill_glow = {
				size = {
					341,
					104
				},
				offset = {
					-17,
					-18,
					4
				},
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = arg_160_4
			},
			text_charge_cancelled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					0,
					-10,
					2
				}
			},
			texture_token_type = {
				color = {
					255,
					255,
					255,
					255
				},
				scenegraph_id = arg_160_2
			},
			texture_token_type_selected = {
				offset = {
					0,
					-2,
					0
				},
				color = {
					255,
					255,
					255,
					255
				},
				scenegraph_id = arg_160_2
			},
			text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					10,
					0,
					2
				},
				scenegraph_id = arg_160_1
			},
			text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					10,
					0,
					2
				},
				scenegraph_id = arg_160_1
			},
			text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					10,
					-2,
					2
				},
				scenegraph_id = arg_160_1
			},
			token_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					180,
					0,
					2
				},
				scenegraph_id = arg_160_1
			},
			token_text_hover = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					180,
					0,
					2
				},
				scenegraph_id = arg_160_1
			},
			token_text_selected = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					180,
					-2,
					2
				},
				scenegraph_id = arg_160_1
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					-10,
					2
				}
			}
		},
		scenegraph_id = arg_160_0
	}
end

function UIWidgets.create_menu_selection_bar(arg_186_0, arg_186_1, arg_186_2, arg_186_3, arg_186_4, arg_186_5, arg_186_6, arg_186_7)
	local var_186_0 = {}
	local var_186_1 = {
		passes = var_186_0
	}
	local var_186_2 = {}
	local var_186_3 = {}

	assert(arg_186_1.texture_hover_id, "missing texture")
	assert(arg_186_1.texture_click_id, "missing texture")

	local var_186_4 = {
		style = var_186_2,
		content = var_186_3,
		element = var_186_1,
		scenegraph_id = arg_186_5
	}
	local var_186_5 = #arg_186_2

	for iter_186_0 = 1, var_186_5 do
		local var_186_6 = iter_186_0
		local var_186_7 = "tooltip_text_" .. iter_186_0
		local var_186_8 = string.format("button_style_%d", iter_186_0)
		local var_186_9 = string.format("button_click_style_%d", iter_186_0)
		local var_186_10 = string.format("icon_%d", iter_186_0)
		local var_186_11 = string.format("icon_click_%d", iter_186_0)
		local var_186_12 = string.format("disabled_overlay_%d", iter_186_0)

		table.append_varargs(var_186_0, {
			pass_type = "hotspot",
			content_id = var_186_6,
			style_id = var_186_6
		}, {
			pass_type = "texture",
			texture_id = var_186_9,
			style_id = var_186_9
		}, {
			pass_type = "texture",
			texture_id = var_186_8,
			style_id = var_186_8
		}, {
			pass_type = "texture",
			texture_id = var_186_10,
			style_id = var_186_10
		}, {
			pass_type = "texture",
			texture_id = var_186_11,
			style_id = var_186_11
		}, {
			pass_type = "tooltip_text",
			text_id = var_186_7,
			style_id = var_186_7,
			content_check_function = function(arg_187_0)
				return arg_187_0[var_186_6].is_hover
			end
		}, {
			pass_type = "rect",
			style_id = var_186_12,
			content_check_function = function(arg_188_0)
				return arg_188_0[var_186_6].disable_button
			end
		})

		local var_186_13 = string.format("%s_%d", arg_186_5, iter_186_0)

		arg_186_0[var_186_13] = {
			parent = iter_186_0 == 1 and arg_186_5 or string.format("%s_%d", arg_186_5, iter_186_0 - 1),
			size = arg_186_6,
			offset = iter_186_0 ~= 1 and arg_186_4 or nil
		}

		local var_186_14 = string.format("%s_icon_%d", arg_186_5, iter_186_0)

		arg_186_0[var_186_14] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = var_186_13,
			size = arg_186_7,
			offset = {
				0,
				0,
				5
			}
		}
		var_186_3[var_186_6] = {}
		var_186_3[var_186_7] = arg_186_3[iter_186_0]
		var_186_3[var_186_8] = arg_186_1.texture_hover_id
		var_186_3[var_186_10] = arg_186_2[iter_186_0].texture_hover_id
		var_186_3[var_186_9] = arg_186_1.texture_click_id
		var_186_3[var_186_11] = arg_186_2[iter_186_0].texture_click_id
		var_186_2[var_186_7] = {
			font_size = 24,
			max_width = 500,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			line_colors = {},
			offset = {
				0,
				0,
				250
			}
		}
		var_186_2[var_186_12] = {
			scenegraph_id = var_186_13,
			size = {
				arg_186_6[1] - 12,
				arg_186_6[2] - 12
			},
			offset = {
				6,
				6,
				5
			},
			color = {
				178,
				0,
				0,
				0
			}
		}
		var_186_2[var_186_6] = {
			scenegraph_id = var_186_13,
			size = {
				arg_186_6[1] - 12,
				arg_186_6[2] - 12
			},
			offset = {
				6,
				6,
				0
			}
		}
		var_186_2[var_186_8] = {
			scenegraph_id = var_186_13,
			color = {
				178.5,
				255,
				255,
				255
			},
			size = arg_186_6
		}
		var_186_2[var_186_10] = {
			scenegraph_id = var_186_14,
			color = {
				178.5,
				255,
				255,
				255
			},
			size = arg_186_7
		}
		var_186_2[var_186_9] = {
			scenegraph_id = var_186_13,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				1
			},
			size = arg_186_6
		}
		var_186_2[var_186_11] = {
			scenegraph_id = var_186_14,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				2
			},
			size = arg_186_7
		}
	end

	return var_186_4
end

function UIWidgets.create_tiled_texture(arg_189_0, arg_189_1, arg_189_2, arg_189_3, arg_189_4, arg_189_5)
	return {
		element = {
			passes = {
				{
					pass_type = "tiled_texture",
					style_id = "tiling_texture",
					texture_id = "tiling_texture"
				}
			}
		},
		content = {
			tiling_texture = arg_189_1
		},
		style = {
			tiling_texture = {
				masked = arg_189_4,
				offset = arg_189_3 or {
					0,
					0,
					0
				},
				texture_tiling_size = arg_189_2,
				color = arg_189_5 or {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_189_0
	}
end

function UIWidgets.create_shader_tiled_texture(arg_190_0, arg_190_1, arg_190_2, arg_190_3, arg_190_4, arg_190_5)
	return {
		element = {
			passes = {
				{
					pass_type = "shader_tiled_texture",
					style_id = "tiling_texture",
					texture_id = "tiling_texture"
				}
			}
		},
		content = {
			tiling_texture = arg_190_1
		},
		style = {
			tiling_texture = {
				masked = arg_190_4,
				offset = arg_190_3 or {
					0,
					0,
					0
				},
				tile_size = arg_190_2,
				color = arg_190_5 or {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_190_0
	}
end

function UIWidgets.create_texture_with_text(arg_191_0, arg_191_1, arg_191_2, arg_191_3, arg_191_4)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			texture_id = arg_191_0,
			text = arg_191_1
		},
		style = {
			text = arg_191_4 or {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 20,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				scenegraph_id = arg_191_3
			},
			texture_id = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_191_2
	}
end

function UIWidgets.create_texture_with_text_and_tooltip(arg_192_0, arg_192_1, arg_192_2, arg_192_3, arg_192_4, arg_192_5, arg_192_6)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "hotspot",
					content_id = "tooltip_hotspot",
					content_check_function = function(arg_193_0)
						return not arg_193_0.disabled
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function(arg_194_0)
						return arg_194_0.tooltip_hotspot.is_hover
					end
				}
			}
		},
		content = {
			tooltip_hotspot = {},
			texture_id = arg_192_0,
			tooltip_text = arg_192_2,
			text = arg_192_1
		},
		style = {
			text = arg_192_5 or {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 20,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				scenegraph_id = arg_192_4
			},
			tooltip_text = arg_192_6 or {
				font_size = 24,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				offset = {
					0,
					0,
					50
				}
			},
			texture_id = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_192_3
	}
end

function UIWidgets.create_simple_tooltip(arg_195_0, arg_195_1, arg_195_2, arg_195_3)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "tooltip_hotspot"
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function(arg_196_0)
						return arg_196_0.tooltip_hotspot.is_hover
					end
				}
			}
		},
		content = {
			tooltip_text = arg_195_0,
			tooltip_hotspot = {}
		},
		style = {
			tooltip_text = arg_195_3 or {
				font_size = 24,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				max_width = arg_195_2,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				offset = {
					0,
					0,
					3
				}
			}
		},
		scenegraph_id = arg_195_1
	}
end

function UIWidgets.create_additional_option_tooltip(arg_197_0, arg_197_1, arg_197_2, arg_197_3, arg_197_4, arg_197_5, arg_197_6, arg_197_7, arg_197_8)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "tooltip",
					additional_option_id = "tooltip",
					pass_type = "additional_option_tooltip",
					content_passes = arg_197_2 or {
						"additional_option_info"
					},
					content_check_function = function(arg_198_0)
						return arg_198_0.tooltip and arg_198_0.button_hotspot.is_hover
					end
				}
			}
		},
		content = {
			tooltip = arg_197_3 or nil,
			button_hotspot = {
				allow_multi_hover = true
			}
		},
		style = {
			tooltip = {
				grow_downwards = arg_197_7,
				max_width = arg_197_4 or 300,
				horizontal_alignment = arg_197_5 or "center",
				vertical_alignment = arg_197_6 or "bottom",
				offset = arg_197_8 or {
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
		},
		scenegraph_id = arg_197_0
	}
end

function UIWidgets.create_simple_hotspot(arg_199_0, arg_199_1)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				}
			}
		},
		content = {
			hotspot = {
				allow_multi_hover = arg_199_1
			}
		},
		style = {},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_199_0
	}
end

function UIWidgets.create_simple_two_state_button(arg_200_0, arg_200_1, arg_200_2)
	return {
		element = UIElements.SimpleButton,
		content = {
			texture_id = arg_200_1,
			texture_hover_id = arg_200_2,
			button_hotspot = {}
		},
		style = {},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_200_0
	}
end

function UIWidgets.create_simple_rect(arg_201_0, arg_201_1, arg_201_2, arg_201_3, arg_201_4)
	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "rect"
				}
			}
		},
		content = {},
		style = {
			rect = {
				vertical_alignment = "top",
				color = arg_201_1 or {
					255,
					255,
					255,
					255
				},
				offset = arg_201_3 or {
					0,
					0,
					arg_201_2 or 0
				},
				texture_size = arg_201_4
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_201_0
	}
end

function UIWidgets.create_simple_rounded_rect(arg_202_0, arg_202_1, arg_202_2)
	return {
		element = {
			passes = {
				{
					pass_type = "rounded_background",
					style_id = "rect"
				}
			}
		},
		content = {},
		style = {
			rect = {
				color = arg_202_2 or {
					255,
					255,
					255,
					255
				},
				corner_radius = arg_202_1 or 0,
				offset = {
					0,
					0,
					0
				}
			}
		},
		scenegraph_id = arg_202_0
	}
end

function UIWidgets.create_simple_texture(arg_203_0, arg_203_1, arg_203_2, arg_203_3, arg_203_4, arg_203_5, arg_203_6, arg_203_7, arg_203_8)
	if type(arg_203_5) ~= "table" then
		arg_203_5 = {
			0,
			0,
			arg_203_5 or 0
		}
	end

	if arg_203_6 == "native" then
		local var_203_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_203_0).size

		arg_203_6 = {
			var_203_0[1],
			var_203_0[2]
		}
	end

	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = arg_203_3
				}
			}
		},
		content = {
			texture_id = arg_203_0,
			disable_with_gamepad = arg_203_7
		},
		style = {
			texture_id = {
				color = arg_203_4 or {
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
				masked = arg_203_2,
				texture_size = arg_203_6,
				viewport_mask = arg_203_8
			}
		},
		offset = arg_203_5,
		scenegraph_id = arg_203_1
	}
end

function UIWidgets.create_aligned_texture(arg_204_0, arg_204_1, arg_204_2, arg_204_3, arg_204_4, arg_204_5, arg_204_6, arg_204_7, arg_204_8, arg_204_9)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = arg_204_6
				}
			}
		},
		content = {
			texture_id = arg_204_0
		},
		style = {
			texture_id = {
				vertical_alignment = arg_204_3,
				horizontal_alignment = arg_204_2,
				texture_size = arg_204_1,
				color = arg_204_7 or {
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
				masked = arg_204_5
			}
		},
		offset = arg_204_9 and arg_204_9 or {
			0,
			0,
			arg_204_8 or 0
		},
		scenegraph_id = arg_204_4
	}
end

function UIWidgets.create_simple_centered_texture_amount(arg_205_0, arg_205_1, arg_205_2, arg_205_3, arg_205_4, arg_205_5)
	local var_205_0 = {}
	local var_205_1 = {}

	for iter_205_0 = 1, arg_205_3 do
		var_205_0[iter_205_0] = arg_205_0
		var_205_1[iter_205_0] = arg_205_5 or {
			255,
			255,
			255,
			255
		}
	end

	return {
		element = {
			passes = {
				{
					pass_type = "centered_texture_amount",
					style_id = "texture_id",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			texture_id = var_205_0
		},
		style = {
			texture_id = {
				texture_axis = 1,
				spacing = 8,
				texture_size = arg_205_1,
				texture_amount = arg_205_3,
				color = arg_205_5 or {
					255,
					255,
					255,
					255
				},
				texture_colors = var_205_1,
				offset = {
					0,
					0,
					0
				},
				masked = arg_205_4
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_205_2
	}
end

function UIWidgets.create_simple_multi_texture(arg_206_0, arg_206_1, arg_206_2, arg_206_3, arg_206_4, arg_206_5, arg_206_6, arg_206_7)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "multi_texture",
					retained_mode = arg_206_7
				}
			}
		},
		content = {
			texture_id = arg_206_0 or {}
		},
		style = {
			texture_id = {
				draw_count = arg_206_0 and #arg_206_0 or 0,
				axis = arg_206_2 or 1,
				spacing = arg_206_4 or {
					0,
					0
				},
				direction = arg_206_3 or 1,
				texture_sizes = arg_206_1 or {},
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
				masked = arg_206_6
			}
		},
		scenegraph_id = arg_206_5
	}
end

function UIWidgets.create_texture_with_style(arg_207_0, arg_207_1, arg_207_2)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				}
			}
		},
		content = {
			texture_id = arg_207_0
		},
		style = {
			texture_id = arg_207_2
		},
		scenegraph_id = arg_207_1
	}
end

function UIWidgets.create_simple_gradient_mask_texture(arg_208_0, arg_208_1, arg_208_2)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "gradient_mask_texture"
				}
			}
		},
		content = {
			texture_id = arg_208_0
		},
		style = {
			texture_id = {
				gradient_threshold = 0,
				offset = {
					0,
					0,
					0
				},
				color = arg_208_2 or {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_208_1
	}
end

function UIWidgets.create_simple_rotated_texture(arg_209_0, arg_209_1, arg_209_2, arg_209_3, arg_209_4, arg_209_5, arg_209_6, arg_209_7, arg_209_8)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "rotated_texture",
					retained_mode = arg_209_5
				}
			}
		},
		content = {
			texture_id = arg_209_0
		},
		style = {
			texture_id = {
				masked = arg_209_4,
				angle = arg_209_1,
				pivot = arg_209_2,
				color = arg_209_6 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					arg_209_7 or 0
				}
			}
		},
		offset = arg_209_8 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_209_3
	}
end

function UIWidgets.create_simple_uv_rotated_texture(arg_210_0, arg_210_1, arg_210_2, arg_210_3, arg_210_4, arg_210_5, arg_210_6, arg_210_7, arg_210_8, arg_210_9)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "rotated_texture",
					retained_mode = arg_210_6
				}
			}
		},
		content = {
			texture_id = arg_210_0
		},
		style = {
			texture_id = {
				masked = arg_210_5,
				angle = arg_210_2,
				pivot = arg_210_3,
				uvs = arg_210_1,
				color = arg_210_7 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					arg_210_8 or 0
				}
			}
		},
		offset = arg_210_9 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_210_4
	}
end

function UIWidgets.create_simple_uv_texture(arg_211_0, arg_211_1, arg_211_2, arg_211_3, arg_211_4, arg_211_5, arg_211_6, arg_211_7, arg_211_8)
	if type(arg_211_6) ~= "table" then
		arg_211_6 = {
			0,
			0,
			arg_211_6 or 0
		}
	end

	if arg_211_8 == "native" then
		local var_211_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_211_0).size

		arg_211_8 = {
			var_211_0[1],
			var_211_0[2]
		}
	end

	return {
		element = {
			passes = {
				{
					style_id = "texture_id",
					pass_type = "texture_uv",
					content_id = "texture_id",
					retained_mode = arg_211_4
				}
			}
		},
		content = {
			texture_id = {
				uvs = arg_211_1,
				texture_id = arg_211_0
			},
			disable_with_gamepad = arg_211_7
		},
		style = {
			texture_id = {
				texture_size = arg_211_8,
				masked = arg_211_3,
				offset = {
					0,
					0,
					0
				},
				color = arg_211_5 or {
					255,
					255,
					255,
					255
				}
			}
		},
		offset = arg_211_6,
		scenegraph_id = arg_211_2
	}
end

function UIWidgets.create_simple_frame(arg_212_0, arg_212_1, arg_212_2, arg_212_3, arg_212_4, arg_212_5, arg_212_6)
	local var_212_0 = arg_212_6 or {
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

	var_212_0.texture_size = arg_212_1
	var_212_0.texture_sizes = {
		corner = arg_212_2,
		vertical = arg_212_3,
		horizontal = arg_212_4
	}

	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture_frame"
				}
			}
		},
		content = {
			texture_id = arg_212_0
		},
		style = {
			texture_id = var_212_0
		},
		scenegraph_id = arg_212_5
	}
end

function UIWidgets.create_uv_texture_with_style(arg_213_0, arg_213_1, arg_213_2, arg_213_3)
	return {
		element = {
			passes = {
				{
					style_id = "texture_id",
					pass_type = "texture_uv",
					content_id = "texture_id"
				}
			}
		},
		content = {
			texture_id = {
				uvs = arg_213_1,
				texture_id = arg_213_0
			}
		},
		style = {
			texture_id = arg_213_3
		},
		scenegraph_id = arg_213_2
	}
end

function UIWidgets.create_simple_text(arg_214_0, arg_214_1, arg_214_2, arg_214_3, arg_214_4, arg_214_5, arg_214_6, arg_214_7)
	local var_214_0 = arg_214_4 and arg_214_4.offset or {
		0,
		0,
		2
	}
	local var_214_1 = arg_214_4 and arg_214_4.text_color or arg_214_3 or {
		255,
		255,
		255,
		255
	}

	arg_214_4 = arg_214_4 or {
		vertical_alignment = "center",
		localize = true,
		horizontal_alignment = "center",
		word_wrap = true,
		font_size = arg_214_2,
		font_type = arg_214_5 or "hell_shark",
		text_color = var_214_1,
		offset = var_214_0
	}

	local var_214_2 = table.clone(arg_214_4)
	local var_214_3 = arg_214_4.shadow_color or {
		255,
		0,
		0,
		0
	}
	local var_214_4 = arg_214_4.shadow_offset or {
		2,
		2,
		0
	}

	var_214_3[1] = var_214_1[1]
	var_214_2.text_color = var_214_3
	var_214_2.offset = {
		var_214_0[1] + var_214_4[1],
		var_214_0[2] - var_214_4[2],
		var_214_0[3] - 1
	}
	var_214_2.skip_button_rendering = true

	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					retained_mode = arg_214_6
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_215_0)
						return arg_215_0.use_shadow
					end,
					retained_mode = arg_214_6
				}
			}
		},
		content = {
			text = arg_214_0,
			original_text = arg_214_0,
			color = var_214_1,
			use_shadow = arg_214_4 and arg_214_4.use_shadow or false,
			disable_with_gamepad = arg_214_7
		},
		style = {
			text = arg_214_4,
			text_shadow = var_214_2
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_214_1
	}
end

function UIWidgets.create_simple_text_tooltip(arg_216_0, arg_216_1, arg_216_2, arg_216_3, arg_216_4, arg_216_5, arg_216_6)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "hotspot",
					content_id = "tooltip_hotspot"
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function(arg_217_0)
						return arg_217_0.tooltip_hotspot.is_hover
					end
				}
			}
		},
		content = {
			text = arg_216_0,
			tooltip_text = arg_216_1,
			tooltip_hotspot = {},
			color = arg_216_5 and arg_216_5.text_color or arg_216_4
		},
		style = {
			text = arg_216_5 or {
				vertical_alignment = "center",
				localize = true,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				font_size = arg_216_3,
				text_color = arg_216_4,
				offset = {
					0,
					0,
					2
				}
			},
			tooltip_text = arg_216_6 or {
				font_size = 24,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				offset = {
					0,
					0,
					50
				}
			}
		},
		scenegraph_id = arg_216_2
	}
end

function UIWidgets.create_simple_rect_text(arg_218_0, arg_218_1, arg_218_2, arg_218_3, arg_218_4, arg_218_5)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "rect_text",
					text_id = "text"
				}
			}
		},
		content = {
			text = arg_218_1
		},
		style = {
			text = arg_218_5 or {
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = arg_218_2 or 24,
				text_color = arg_218_3 or Colors.get_color_table_with_alpha("white", 255),
				rect_color = arg_218_4 or Colors.get_color_table_with_alpha("black", 150),
				line_colors = {},
				offset = {
					0,
					0,
					50
				}
			}
		},
		scenegraph_id = arg_218_0
	}
end

function UIWidgets.create_forge_toggle_button(arg_219_0, arg_219_1, arg_219_2, arg_219_3, arg_219_4, arg_219_5)
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function(arg_220_0)
						return not arg_220_0.is_selected and not arg_220_0.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_221_0)
						return not arg_221_0.is_selected and arg_221_0.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_selected_id",
					content_check_function = function(arg_222_0)
						return arg_222_0.is_selected and not arg_222_0.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_selected_hover_id",
					content_check_function = function(arg_223_0)
						return arg_223_0.is_selected and arg_223_0.button_hotspot.is_hover
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			texture_id = arg_219_0,
			texture_hover_id = arg_219_1,
			texture_selected_id = arg_219_2,
			texture_selected_hover_id = arg_219_3
		},
		style = {
			button_hotspot = {
				scenegraph_id = arg_219_5
			}
		},
		scenegraph_id = arg_219_4
	}
end

function UIWidgets.create_button_2_state(arg_224_0, arg_224_1, arg_224_2, arg_224_3)
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function(arg_225_0)
						return not arg_225_0.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_selected_id",
					content_check_function = function(arg_226_0)
						return arg_226_0.is_selected
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			texture_id = arg_224_0,
			texture_selected_id = arg_224_1
		},
		style = {
			button_hotspot = {
				scenegraph_id = arg_224_3
			}
		},
		scenegraph_id = arg_224_2
	}
end

function UIWidgets.create_title_text(arg_227_0, arg_227_1)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			text = arg_227_0
		},
		style = {
			text = {
				font_size = 36,
				localize = true,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_table("cheeseburger"),
				offset = {
					0,
					0,
					2
				}
			}
		},
		scenegraph_id = arg_227_1
	}
end

function UIWidgets.create_matchmaking_portrait(arg_228_0, arg_228_1)
	return {
		element = {
			passes = {
				{
					texture_id = "slot_bg",
					style_id = "slot_bg",
					pass_type = "texture"
				},
				{
					texture_id = "portrait",
					style_id = "portrait",
					pass_type = "texture",
					content_check_function = function(arg_229_0)
						return not arg_229_0.is_connecting and arg_229_0.is_connected
					end
				},
				{
					texture_id = "ready_icon",
					style_id = "ready_icon",
					pass_type = "texture",
					content_check_function = function(arg_230_0)
						return not arg_230_0.is_connecting and arg_230_0.is_connected and arg_230_0.is_ready
					end
				},
				{
					texture_id = "voted_yes_icon",
					style_id = "voted_yes_icon",
					pass_type = "texture",
					content_check_function = function(arg_231_0)
						return not arg_231_0.is_connecting and arg_231_0.is_connected and arg_231_0.is_voting and arg_231_0.voted_yes
					end
				},
				{
					texture_id = "waiting_for_vote",
					style_id = "waiting_for_vote",
					pass_type = "texture",
					content_check_function = function(arg_232_0)
						return not arg_232_0.is_connecting and arg_232_0.is_connected and arg_232_0.is_voting and not arg_232_0.voted_yes
					end
				},
				{
					texture_id = "connecting_icon",
					style_id = "connecting_icon",
					pass_type = "rotated_texture",
					content_check_function = function(arg_233_0)
						return arg_233_0.is_connecting
					end
				}
			}
		},
		content = {
			portrait = "small_unit_frame_portrait_default",
			is_connecting = false,
			is_connected = false,
			slot_bg = "small_unit_frame_portrait_default",
			waiting_for_vote = "matchmaking_checkbox",
			connecting_icon = "journal_icon_02",
			ready_icon = "matchmaking_checkbox",
			voted_yes_icon = "matchmaking_checkbox",
			is_ready = false
		},
		style = {
			slot_bg = {
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			portrait = {
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
			ready_icon = {
				size = {
					37,
					31
				},
				offset = {
					arg_228_0[1] / 2 - 18.5,
					arg_228_0[2] / 2 - 15.5,
					3
				},
				color = {
					255,
					0,
					255,
					0
				}
			},
			voted_yes_icon = {
				size = {
					37,
					31
				},
				offset = {
					arg_228_0[1] / 2 - 18.5,
					arg_228_0[2] / 2 - 15.5,
					3
				},
				color = {
					255,
					0,
					255,
					0
				}
			},
			waiting_for_vote = {
				size = {
					37,
					31
				},
				offset = {
					arg_228_0[1] / 2 - 18.5,
					arg_228_0[2] / 2 - 15.5,
					3
				},
				color = {
					255,
					255,
					168,
					0
				}
			},
			connecting_icon = {
				angle = 0,
				size = {
					30,
					30
				},
				pivot = {
					15,
					15
				},
				offset = {
					arg_228_0[1] / 2 - 15,
					arg_228_0[2] / 2 - 15,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_228_1
	}
end

function UIWidgets.create_small_trait_button(arg_234_0, arg_234_1, arg_234_2)
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_235_0)
						return not arg_235_0.disabled and not arg_235_0.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_bg_id",
					texture_id = "texture_bg_id",
					content_check_function = function(arg_236_0)
						return arg_236_0.use_background
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function(arg_237_0)
						return arg_237_0.texture_id
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_238_0)
						local var_238_0 = arg_238_0.button_hotspot

						return var_238_0.is_hover and not var_238_0.is_selected and not var_238_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_id",
					texture_id = "texture_selected_id",
					content_check_function = function(arg_239_0)
						local var_239_0 = arg_239_0.button_hotspot

						return var_239_0.is_selected and not var_239_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_lock_id",
					texture_id = "texture_lock_id",
					content_check_function = function(arg_240_0)
						local var_240_0 = arg_240_0.button_hotspot

						return var_240_0.locked and not var_240_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_glow_id",
					texture_id = "texture_glow_id",
					content_check_function = function(arg_241_0)
						return arg_241_0.use_glow
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_trait_cover_id",
					texture_id = "texture_trait_cover_id",
					content_check_function = function(arg_242_0)
						return arg_242_0.button_hotspot.disabled and arg_242_0.use_trait_cover and arg_242_0.texture_id
					end
				}
			}
		},
		content = {
			use_glow = true,
			texture_lock_id = "trait_icon_selected_frame_locked",
			use_trait_cover = false,
			texture_glow_id = "item_slot_glow_03",
			texture_hover_id = "trait_icon_mouseover_frame",
			texture_selected_id = "trait_icon_selected_frame",
			use_background = true,
			texture_bg_id = "trait_slot",
			texture_id = "trait_icon_empty",
			texture_trait_cover_id = "trait_slot_cover",
			button_hotspot = {
				disabled = false,
				locked = false
			}
		},
		style = {
			button_hotspot = {
				scenegraph_id = arg_234_1
			},
			texture_bg_id = {
				masked = arg_234_2,
				size = {
					54,
					58
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-7,
					-10,
					-1
				}
			},
			texture_id = {
				masked = arg_234_2,
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_hover_id = {
				masked = arg_234_2,
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
			texture_selected_id = {
				masked = arg_234_2,
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_lock_id = {
				masked = arg_234_2,
				offset = {
					0,
					0,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_glow_id = {
				masked = arg_234_2,
				size = {
					104,
					104
				},
				offset = {
					-32,
					-32,
					4
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			texture_trait_cover_id = {
				masked = arg_234_2,
				size = {
					40,
					41
				},
				offset = {
					0,
					0,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_234_0
	}
end

function UIWidgets.create_small_reroll_trait_button(arg_243_0, arg_243_1)
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_244_0)
						return not arg_244_0.disabled and not arg_244_0.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_bg_id",
					texture_id = "texture_bg_id",
					content_check_function = function(arg_245_0)
						return arg_245_0.use_background
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_slot_id",
					texture_id = "texture_slot_id",
					content_check_function = function(arg_246_0)
						return arg_246_0.use_background
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function(arg_247_0)
						return arg_247_0.texture_id
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_248_0)
						local var_248_0 = arg_248_0.button_hotspot

						return var_248_0.is_hover and not var_248_0.is_selected and not var_248_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_id",
					texture_id = "texture_selected_id",
					content_check_function = function(arg_249_0)
						local var_249_0 = arg_249_0.button_hotspot

						return var_249_0.is_selected and not var_249_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_lock_id",
					texture_id = "texture_lock_id",
					content_check_function = function(arg_250_0)
						return arg_250_0.button_hotspot.locked and arg_250_0.texture_id
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_glow_id",
					texture_id = "texture_glow_id",
					content_check_function = function(arg_251_0)
						return arg_251_0.use_glow
					end
				}
			}
		},
		content = {
			use_glow = true,
			texture_slot_id = "reroll_trait_slot_01",
			texture_glow_id = "reroll_glow_small",
			texture_hover_id = "trait_icon_mouseover_frame",
			use_background = true,
			texture_bg_id = "reroll_trait_slot_01_bg",
			texture_id = "trait_icon_empty",
			texture_selected_id = "trait_icon_selected_frame",
			texture_lock_id = "trait_icon_selected_frame_locked",
			button_hotspot = {
				disabled = false,
				locked = false
			}
		},
		style = {
			button_hotspot = {
				scenegraph_id = arg_243_1
			},
			texture_bg_id = {
				size = {
					68,
					68
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-14,
					-15,
					-1
				}
			},
			texture_slot_id = {
				size = {
					58,
					58
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-9,
					-9,
					0
				}
			},
			texture_id = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_hover_id = {
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_selected_id = {
				offset = {
					0,
					0,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_lock_id = {
				offset = {
					0,
					0,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_glow_id = {
				size = {
					140,
					140
				},
				offset = {
					-50,
					-50,
					5
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_243_0
	}
end

function UIWidgets.create_attach_icon_button(arg_252_0, arg_252_1, arg_252_2, arg_252_3, arg_252_4, arg_252_5, arg_252_6)
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_253_0)
						return not arg_253_0.disable_interaction
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function(arg_254_0)
						return arg_254_0.icon_texture_id and arg_254_0.tooltip_enabled and arg_254_0.button_hotspot.is_hover and not arg_254_0.button_hotspot.disable_interaction
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text_no_item",
					content_check_function = function(arg_255_0)
						return not arg_255_0.icon_texture_id and arg_255_0.tooltip_enabled and arg_255_0.button_hotspot.is_hover and not arg_255_0.button_hotspot.disable_interaction
					end
				},
				{
					texture_id = "background_texture_id",
					style_id = "background_texture_id",
					pass_type = "texture",
					content_check_function = function(arg_256_0)
						return arg_256_0.background_texture_id
					end
				},
				{
					texture_id = "bg_overlay_texture_id",
					style_id = "bg_overlay_texture_id",
					pass_type = "texture",
					content_check_function = function(arg_257_0)
						return arg_257_0.bg_overlay_texture_id
					end
				},
				{
					texture_id = "icon_texture_id",
					style_id = "icon_texture_id",
					pass_type = "texture",
					content_check_function = function(arg_258_0)
						return arg_258_0.icon_texture_id
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_frame_texture_id",
					texture_id = "icon_frame_texture_id",
					content_check_function = function(arg_259_0)
						return arg_259_0.icon_texture_id or arg_259_0.bg_overlay_texture_id
					end
				},
				{
					texture_id = "glow_animation",
					style_id = "glow_animation",
					pass_type = "texture"
				},
				{
					texture_id = "icon_texture_id",
					style_id = "background_texture_id",
					pass_type = "drag",
					content_check_function = function(arg_260_0)
						return not arg_260_0.button_hotspot.disable_interaction
					end
				},
				{
					pass_type = "texture",
					style_id = "hover_texture",
					texture_id = "hover_texture",
					content_check_function = function(arg_261_0)
						return arg_261_0.button_hotspot.is_hover and arg_261_0.icon_texture_id and not arg_261_0.is_dragging
					end
				},
				{
					pass_type = "texture",
					style_id = "drag_select_frame",
					texture_id = "drag_select_frame"
				}
			}
		},
		content = {
			tooltip_enabled = true,
			drag_select_frame = "item_slot_drag",
			tooltip_text_no_item = "forge_screen_merge_empy_slot_tooltip",
			hover_texture = "item_slot_hover",
			icon_frame_texture_id = "frame_01",
			tooltip_text = "forge_screen_merge_full_slot_tooltip",
			drag_texture_size = arg_252_3,
			button_hotspot = {
				disable_interaction = arg_252_6
			},
			background_texture_id = arg_252_0,
			glow_animation = arg_252_5 or "icons_placeholder"
		},
		style = {
			background_texture_id = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			bg_overlay_texture_id = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			icon_texture_id = {
				color = {
					255,
					255,
					255,
					255
				},
				scenegraph_id = arg_252_2
			},
			icon_frame_texture_id = {
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
				scenegraph_id = arg_252_2
			},
			glow_animation = {
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = arg_252_4
			},
			hover_texture = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				}
			},
			drag_select_frame = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					-24.5,
					-24,
					3
				},
				size = {
					127,
					127
				}
			},
			tooltip_text = {
				font_size = 24,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				offset = {
					0,
					0,
					250
				}
			}
		},
		scenegraph_id = arg_252_1
	}
end

function UIWidgets.create_input_description_widgets(arg_262_0, arg_262_1, arg_262_2)
	local var_262_0 = {}

	for iter_262_0 = 1, arg_262_2 do
		local var_262_1 = "input_description_root_" .. iter_262_0
		local var_262_2 = "input_description_" .. iter_262_0
		local var_262_3 = "input_description_icon_" .. iter_262_0
		local var_262_4 = "input_description_text_" .. iter_262_0

		arg_262_0[var_262_1] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = arg_262_1,
			size = {
				1,
				1
			},
			postion = {
				0,
				0,
				1
			}
		}
		arg_262_0[var_262_2] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_262_1,
			size = {
				200,
				40
			},
			postion = {
				0,
				0,
				1
			}
		}
		arg_262_0[var_262_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_262_2,
			size = {
				40,
				40
			},
			postion = {
				0,
				0,
				1
			}
		}
		arg_262_0[var_262_4] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_262_3,
			size = {
				160,
				40
			},
			postion = {
				40,
				0,
				1
			}
		}

		local var_262_5 = {
			element = {
				passes = {
					{
						style_id = "text",
						pass_type = "text",
						text_id = "text"
					},
					{
						pass_type = "texture",
						style_id = "icon",
						texture_id = "icon"
					}
				}
			},
			content = {
				text = "",
				icon = "xbone_button_icon_a"
			},
			style = {
				text = {
					font_size = 24,
					word_wrap = true,
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
					},
					scenegraph_id = var_262_4
				},
				icon = {
					scenegraph_id = var_262_3
				}
			},
			scenegraph_id = var_262_2
		}

		var_262_0[#var_262_0 + 1] = UIWidget.init(var_262_5)
	end

	return var_262_0
end

function UIWidgets.create_hero_button(arg_263_0, arg_263_1, arg_263_2)
	local var_263_0 = "tabs_class_icon_" .. arg_263_0 .. "_normal"
	local var_263_1 = "tabs_class_icon_" .. arg_263_0 .. "_hover"
	local var_263_2 = "tabs_class_icon_" .. arg_263_0 .. "_selected"
	local var_263_3

	if arg_263_0 == "all_heroes" then
		var_263_0 = nil
		var_263_1 = nil
		var_263_2 = nil
		var_263_3 = "ALL"
	end

	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function(arg_264_0)
						return not arg_264_0.button_hotspot.is_hover and not arg_264_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "texture_hover_id",
					style_id = "texture_hover_id",
					pass_type = "texture",
					content_check_function = function(arg_265_0)
						return arg_265_0.button_hotspot.is_hover and not arg_265_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "texture_selected_id",
					style_id = "texture_selected_id",
					pass_type = "texture",
					content_check_function = function(arg_266_0)
						return arg_266_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "hero_texture_normal_id",
					style_id = "hero_texture_normal_id",
					pass_type = "texture",
					content_check_function = function(arg_267_0)
						local var_267_0 = arg_267_0.button_hotspot

						return arg_267_0.hero_texture_normal_id and not var_267_0.is_hover and not var_267_0.is_selected
					end
				},
				{
					texture_id = "hero_texture_hover_id",
					style_id = "hero_texture_hover_id",
					pass_type = "texture",
					content_check_function = function(arg_268_0)
						return arg_268_0.hero_texture_hover_id and arg_268_0.button_hotspot.is_hover
					end
				},
				{
					texture_id = "hero_texture_selected_id",
					style_id = "hero_texture_selected_id",
					pass_type = "texture",
					content_check_function = function(arg_269_0)
						return arg_269_0.hero_texture_selected_id and arg_269_0.button_hotspot.is_selected
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_270_0)
						return arg_270_0.text
					end
				}
			}
		},
		content = {
			texture_id = "tab_normal",
			texture_hover_id = "tab_hover",
			texture_selected_id = "tab_selected",
			button_hotspot = {},
			hero_texture_normal_id = var_263_0,
			hero_texture_hover_id = var_263_1,
			hero_texture_selected_id = var_263_2,
			text = var_263_3
		},
		style = {
			texture_id = {},
			texture_hover_id = {},
			texture_selected_id = {},
			hero_texture_normal_id = {
				scenegraph_id = arg_263_2
			},
			hero_texture_hover_id = {
				scenegraph_id = arg_263_2
			},
			hero_texture_selected_id = {
				scenegraph_id = arg_263_2
			},
			text = {
				font_size = 24,
				localize = true,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_table("cheeseburger"),
				offset = {
					0,
					0,
					2
				}
			}
		},
		scenegraph_id = arg_263_1
	}
end

function UIWidgets.create_trait_button(arg_271_0, arg_271_1, arg_271_2, arg_271_3, arg_271_4)
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "trait_owned_normal",
					style_id = "trait_owned_normal",
					pass_type = "texture",
					content_check_function = function(arg_272_0)
						return arg_272_0.owned and not arg_272_0.button_hotspot.is_hover and not arg_272_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "trait_owned_hover",
					style_id = "trait_owned_hover",
					pass_type = "texture",
					content_check_function = function(arg_273_0)
						return arg_273_0.owned and arg_273_0.button_hotspot.is_hover and not arg_273_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "trait_owned_selected",
					style_id = "trait_owned_selected",
					pass_type = "texture",
					content_check_function = function(arg_274_0)
						return arg_274_0.owned and arg_274_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "trait_purchase_normal",
					style_id = "trait_purchase_normal",
					pass_type = "texture",
					content_check_function = function(arg_275_0)
						return not arg_275_0.button_hotspot.is_hover and not arg_275_0.button_hotspot.is_selected and not arg_275_0.owned and not arg_275_0.locked
					end
				},
				{
					texture_id = "trait_purchase_hover",
					style_id = "trait_purchase_hover",
					pass_type = "texture",
					content_check_function = function(arg_276_0)
						return arg_276_0.button_hotspot.is_hover and not arg_276_0.button_hotspot.is_selected and not arg_276_0.owned and not arg_276_0.locked
					end
				},
				{
					texture_id = "trait_purchase_selected",
					style_id = "trait_purchase_selected",
					pass_type = "texture",
					content_check_function = function(arg_277_0)
						return arg_277_0.button_hotspot.is_selected and not arg_277_0.owned and not arg_277_0.locked
					end
				},
				{
					texture_id = "trait_locked_normal",
					style_id = "trait_locked_normal",
					pass_type = "texture",
					content_check_function = function(arg_278_0)
						return arg_278_0.locked and not arg_278_0.button_hotspot.is_hover and not arg_278_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "trait_locked_hover",
					style_id = "trait_locked_hover",
					pass_type = "texture",
					content_check_function = function(arg_279_0)
						return arg_279_0.locked and arg_279_0.button_hotspot.is_hover and not arg_279_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "trait_locked_selected",
					style_id = "trait_locked_selected",
					pass_type = "texture",
					content_check_function = function(arg_280_0)
						return arg_280_0.locked and arg_280_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "trait_icon",
					style_id = "trait_icon",
					pass_type = "texture"
				},
				{
					texture_id = "trait_unlock_animation",
					style_id = "trait_unlock_animation",
					pass_type = "texture"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			trait_purchase_normal = "forge_item_box_rock_normal",
			trait_purchase_hover = "forge_item_box_rock_hover",
			trait_locked_normal = "forge_item_box_locked_normal",
			trait_icon = "icons_placeholder",
			trait_unlock_animation = "forge_item_box_glow_effect",
			trait_owned_normal = "forge_item_box_gold_normal",
			trait_locked_hover = "forge_item_box_locked_hover",
			trait_owned_hover = "forge_item_box_gold_hover",
			owned = false,
			trait_locked_selected = "forge_item_box_locked_selected",
			locked = false,
			description_text = "description",
			trait_owned_selected = "forge_item_box_gold_selected",
			trait_purchase_selected = "forge_item_box_rock_selected",
			button_hotspot = {},
			title_text = arg_271_0
		},
		style = {
			trait_owned_selected = {},
			trait_owned_hover = {},
			trait_owned_normal = {},
			trait_purchase_selected = {},
			trait_purchase_hover = {},
			trait_purchase_normal = {},
			trait_locked_selected = {},
			trait_locked_hover = {},
			trait_locked_normal = {},
			trait_icon = {
				scenegraph_id = arg_271_3
			},
			title_text = {
				vertical_alignment = "center",
				dynamic_font = true,
				horizontal_alignment = "right",
				font_size = 32,
				pixel_perfect = true,
				font_type = "hell_shark",
				text_color = Colors.get_table("white"),
				scenegraph_id = arg_271_2
			},
			description_text = {
				font_size = 16,
				pixel_perfect = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_table("white"),
				scenegraph_id = arg_271_2,
				offset = {
					0,
					-20,
					0
				}
			},
			trait_unlock_animation = {
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = arg_271_4
			}
		},
		scenegraph_id = arg_271_1
	}
end

function UIWidgets.create_scoreboard_topic_widget(arg_281_0)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "on_click",
					click_check_content_id = "button_hotspot",
					click_function = function(arg_282_0, arg_282_1, arg_282_2, arg_282_3)
						arg_282_2.button_hotspot.is_selected = true
					end
				},
				{
					texture_id = "texture_hover_id",
					style_id = "background_hover",
					pass_type = "texture",
					content_check_function = function(arg_283_0)
						return not arg_283_0.disabled
					end
				},
				{
					texture_id = "texture_select_id",
					style_id = "background_select",
					pass_type = "texture",
					content_check_function = function(arg_284_0)
						return not arg_284_0.disabled
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					content_id = "background",
					dynamic_function = function(arg_285_0, arg_285_1, arg_285_2, arg_285_3)
						local var_285_0 = arg_285_0.fraction
						local var_285_1 = arg_285_0.direction
						local var_285_2 = arg_285_1.color
						local var_285_3 = arg_285_1.uv_start_pixels
						local var_285_4 = arg_285_1.uv_scale_pixels
						local var_285_5 = var_285_3 + var_285_4 * var_285_0
						local var_285_6 = arg_285_1.uvs
						local var_285_7 = arg_285_1.scale_axis

						if var_285_1 == 1 then
							var_285_6[1][var_285_7] = 0
							var_285_6[2][var_285_7] = var_285_5 / (var_285_3 + var_285_4)
							arg_285_2[var_285_7] = var_285_5
							compact_topic_offset[var_285_7] = 0
						else
							var_285_6[2][var_285_7] = 1
							var_285_6[1][var_285_7] = 1 - var_285_5 / (var_285_3 + var_285_4)
							arg_285_2[var_285_7] = var_285_5
							compact_topic_offset[var_285_7] = -(var_285_5 - (var_285_3 + var_285_4))
						end

						return arg_285_1.color, var_285_6, arg_285_2, compact_topic_offset
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "player_name",
					pass_type = "text",
					text_id = "player_name"
				},
				{
					style_id = "score_text",
					pass_type = "text",
					text_id = "score_text"
				}
			}
		},
		content = {
			score_text = "score_text",
			title_text = "title_text",
			player_name = "player_name",
			texture_hover_id = "scoreboard_topic_button_hover",
			texture_select_id = "scoreboard_topic_button_highlight",
			background = {
				texture_id = "scoreboard_topic_button_normal",
				direction = 1,
				fraction = 1
			},
			button_hotspot = {}
		},
		style = {
			background_hover = {
				scenegraph_id = "compact_preview_background_1",
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			},
			background_select = {
				scenegraph_id = "compact_preview_background_1",
				size = {
					350,
					260
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					-23,
					-23,
					-1
				}
			},
			background = {
				uv_start_pixels = 0,
				scenegraph_id = "compact_preview_background_1",
				uv_scale_pixels = 304,
				offset_scale = 1,
				scale_axis = 1,
				color = {
					255,
					255,
					255,
					255
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
			score_text = {
				font_size = 56,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					5,
					5
				}
			},
			title_text = {
				font_size = 36,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					0,
					-30,
					5
				}
			},
			player_name = {
				font_size = 24,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					50,
					5
				}
			}
		},
		scenegraph_id = arg_281_0
	}
end

function UIWidgets.create_splash_video(arg_286_0, arg_286_1)
	return {
		element = {
			passes = {
				{
					style_id = "background",
					scenegraph_id = "background",
					pass_type = "rect",
					content_check_function = function(arg_287_0)
						local var_287_0, var_287_1 = Gui.resolution()
						local var_287_2 = var_287_0 / var_287_1
						local var_287_3 = 1.7777777777777777
						local var_287_4 = var_287_1
						local var_287_5 = var_287_0

						if math.abs(var_287_2 - var_287_3) > 0.005 then
							return true
						end
					end
				},
				{
					style_id = "video_style",
					pass_type = "splash_video",
					content_id = "video_content"
				}
			}
		},
		content = {
			video_content = {
				video_completed = false,
				video_player_reference = arg_286_1,
				material_name = arg_286_0.material_name
			}
		},
		style = {
			background = {
				color = Colors.color_definitions.black
			},
			video_style = {
				color = Colors.color_definitions.white
			}
		},
		scenegraph_id = arg_286_0.scenegraph_id
	}
end

function UIWidgets.create_video(arg_288_0, arg_288_1, arg_288_2)
	return {
		element = {
			passes = {
				{
					style_id = "video_style",
					pass_type = "video",
					content_id = "video_content"
				}
			}
		},
		content = {
			video_content = {
				video_completed = false,
				video_player_reference = arg_288_2,
				material_name = arg_288_1
			}
		},
		style = {
			video_style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_288_0
	}
end

function UIWidgets.create_fixed_aspect_video(arg_289_0, arg_289_1, arg_289_2)
	return {
		element = {
			passes = {
				{
					style_id = "background",
					scenegraph_id = "background",
					pass_type = "rect",
					content_check_function = function(arg_290_0)
						local var_290_0, var_290_1 = Gui.resolution()
						local var_290_2 = var_290_0 / var_290_1
						local var_290_3 = 1.7777777777777777
						local var_290_4 = var_290_1
						local var_290_5 = var_290_0

						if math.abs(var_290_2 - var_290_3) > 0.005 then
							return true
						end
					end
				},
				{
					style_id = "video_style",
					pass_type = "splash_video",
					content_id = "video_content"
				}
			}
		},
		content = {
			video_content = {
				video_completed = false,
				video_player_reference = arg_289_2,
				material_name = arg_289_1
			}
		},
		style = {
			background = {
				color = Colors.color_definitions.black
			},
			video_style = {
				color = {
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
		},
		scenegraph_id = arg_289_0
	}
end

function UIWidgets.create_splash_texture(arg_291_0)
	return {
		element = {
			passes = {
				{
					style_id = "foreground",
					scenegraph_id = "foreground",
					pass_type = "rect",
					content_check_function = function(arg_292_0)
						return arg_292_0.foreground.disable_foreground ~= true
					end
				},
				{
					style_id = "background",
					scenegraph_id = "background",
					pass_type = "rect",
					content_check_function = function(arg_293_0)
						return arg_293_0.foreground.disable_background ~= true
					end
				},
				{
					texture_id = "material_name",
					style_id = "texture_style",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_291_0.scenegraph_id,
					content_check_function = function(arg_294_0)
						return arg_294_0.material_name
					end
				},
				{
					style_id = "texts_style",
					pass_type = "multiple_texts",
					texts_id = "texts",
					scenegraph_id = arg_291_0.texts_scenegraph_id,
					content_check_function = function(arg_295_0)
						return arg_295_0.texts.texts ~= nil
					end
				}
			}
		},
		content = {
			texture_content = {
				material_name = arg_291_0.material_name
			},
			texts = {
				texts = arg_291_0.texts
			},
			foreground = {
				disable_foreground = arg_291_0.disable_foreground
			}
		},
		style = {
			foreground = {
				color = Colors.color_definitions.black
			},
			background = {
				color = Colors.color_definitions.black
			},
			texture_style = {
				size = arg_291_0.texture_size,
				offset = arg_291_0.texture_offset or {
					0,
					0,
					0
				}
			},
			texts_style = {
				scenegraph_id = "texts",
				text_color = Colors.color_definitions.white,
				font_size = arg_291_0.font_size,
				dynamic_font = arg_291_0.dynamic_font,
				pixel_perfect = arg_291_0.pixel_perfect,
				font_type = arg_291_0.font_type,
				localize = arg_291_0.localize,
				horizontal_alignment = arg_291_0.text_horizontal_alignment,
				vertical_alignment = arg_291_0.text_vertical_alignment,
				spacing = arg_291_0.spacing,
				size = arg_291_0.size,
				axis = arg_291_0.axis,
				direction = arg_291_0.direction,
				offset = arg_291_0.offset
			}
		},
		scenegraph_id = arg_291_0.scenegraph_id
	}
end

function UIWidgets.create_loader_icon(arg_296_0)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "loader_icon",
					texture_id = "loader_icon"
				},
				{
					pass_type = "rotated_texture",
					style_id = "loader_part_1",
					texture_id = "loader_part_1"
				},
				{
					pass_type = "rotated_texture",
					style_id = "loader_part_2",
					texture_id = "loader_part_2"
				}
			}
		},
		content = {
			loader_part_1 = "matchmaking_loading_icon_part_01",
			loader_part_2 = "matchmaking_loading_icon_part_02",
			loader_icon = "matchmaking_loading_icon_part_03"
		},
		style = {
			loader_icon = {
				offset = {
					10,
					10,
					3
				},
				size = {
					52,
					52
				}
			},
			loader_part_1 = {
				angle = 0,
				offset = {
					10,
					10,
					1
				},
				size = {
					52,
					52
				},
				pivot = {
					26,
					26
				}
			},
			loader_part_2 = {
				angle = 0,
				offset = {
					10,
					10,
					2
				},
				size = {
					52,
					52
				},
				pivot = {
					26,
					26
				}
			}
		},
		scenegraph_id = arg_296_0
	}
end

function UIWidgets.create_partner_splash_widget(arg_297_0)
	return {
		element = {
			passes = {
				{
					style_id = "foreground",
					scenegraph_id = "foreground",
					pass_type = "rect",
					content_check_function = function(arg_298_0)
						return arg_298_0.foreground.disable_foreground ~= true
					end
				},
				{
					style_id = "background",
					scenegraph_id = "background",
					pass_type = "rect"
				},
				{
					style_id = "texts_style",
					pass_type = "multiple_texts",
					texts_id = "texts",
					scenegraph_id = arg_297_0.texts_scenegraph_id,
					content_check_function = function(arg_299_0)
						return arg_299_0.texts.texts ~= nil
					end
				},
				{
					texture_id = "material_name_1",
					style_id = "texture_style_1",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_297_0.scenegraph_id,
					content_check_function = function(arg_300_0)
						return arg_300_0.material_name_1
					end
				},
				{
					texture_id = "material_name_2",
					style_id = "texture_style_2",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_297_0.scenegraph_id,
					content_check_function = function(arg_301_0)
						return arg_301_0.material_name_2
					end
				},
				{
					texture_id = "material_name_3",
					style_id = "texture_style_3",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_297_0.scenegraph_id,
					content_check_function = function(arg_302_0)
						return arg_302_0.material_name_3
					end
				},
				{
					texture_id = "material_name_4",
					style_id = "texture_style_4",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_297_0.scenegraph_id,
					content_check_function = function(arg_303_0)
						return arg_303_0.material_name_4
					end
				},
				{
					texture_id = "material_name_5",
					style_id = "texture_style_5",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_297_0.scenegraph_id,
					content_check_function = function(arg_304_0)
						return arg_304_0.material_name_5
					end
				},
				{
					texture_id = "material_name_6",
					style_id = "texture_style_6",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_297_0.scenegraph_id,
					content_check_function = function(arg_305_0)
						return arg_305_0.material_name_6
					end
				},
				{
					texture_id = "material_name_7",
					style_id = "texture_style_7",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_297_0.scenegraph_id,
					content_check_function = function(arg_306_0)
						return arg_306_0.material_name_7
					end
				},
				{
					texture_id = "material_name_8",
					style_id = "texture_style_8",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = arg_297_0.scenegraph_id,
					content_check_function = function(arg_307_0)
						return arg_307_0.material_name_8
					end
				}
			}
		},
		content = {
			texture_content = {
				material_name_1 = arg_297_0.texture_materials[1],
				material_name_2 = arg_297_0.texture_materials[2],
				material_name_3 = arg_297_0.texture_materials[3],
				material_name_4 = arg_297_0.texture_materials[4],
				material_name_5 = arg_297_0.texture_materials[5],
				material_name_6 = arg_297_0.texture_materials[6],
				material_name_7 = arg_297_0.texture_materials[7],
				material_name_8 = arg_297_0.texture_materials[8]
			},
			texts = {
				texts = arg_297_0.texts
			},
			foreground = {
				disable_foreground = arg_297_0.disable_foreground
			}
		},
		style = {
			foreground = {
				color = Colors.color_definitions.black
			},
			background = {
				color = Colors.color_definitions.black
			},
			texture_style_1 = {
				scenegraph_id = arg_297_0.texture_scenegraph_ids[1]
			},
			texture_style_2 = {
				scenegraph_id = arg_297_0.texture_scenegraph_ids[2]
			},
			texture_style_3 = {
				scenegraph_id = arg_297_0.texture_scenegraph_ids[3]
			},
			texture_style_4 = {
				scenegraph_id = arg_297_0.texture_scenegraph_ids[4]
			},
			texture_style_5 = {
				scenegraph_id = arg_297_0.texture_scenegraph_ids[5]
			},
			texture_style_6 = {
				scenegraph_id = arg_297_0.texture_scenegraph_ids[6]
			},
			texture_style_7 = {
				scenegraph_id = arg_297_0.texture_scenegraph_ids[7]
			},
			texture_style_8 = {
				scenegraph_id = arg_297_0.texture_scenegraph_ids[8]
			},
			texts_style = {
				scenegraph_id = "texts",
				text_color = Colors.color_definitions.white,
				font_size = arg_297_0.font_size,
				dynamic_font = arg_297_0.dynamic_font,
				pixel_perfect = arg_297_0.pixel_perfect,
				font_type = arg_297_0.font_type,
				localize = arg_297_0.localize,
				horizontal_alignment = arg_297_0.text_horizontal_alignment,
				vertical_alignment = arg_297_0.text_vertical_alignment,
				spacing = arg_297_0.spacing,
				size = arg_297_0.size,
				axis = arg_297_0.axis,
				direction = arg_297_0.direction,
				offset = arg_297_0.offset
			}
		},
		scenegraph_id = arg_297_0.scenegraph_id
	}
end

function UIWidgets.create_map_player_entry(arg_308_0, arg_308_1)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "hero_icon",
					pass_type = "hotspot",
					content_id = "hero_icon_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "host_icon",
					texture_id = "host_icon_texture",
					content_check_function = function(arg_309_0)
						return arg_309_0.is_host
					end
				},
				{
					pass_type = "texture",
					style_id = "hero_icon",
					texture_id = "hero_icon_texture"
				},
				{
					style_id = "hero_icon_tooltip_text",
					pass_type = "tooltip_text",
					text_id = "hero_icon_tooltip_text",
					content_check_function = function(arg_310_0)
						return arg_310_0.hero_icon_hotspot.is_hover
					end
				},
				{
					style_id = "kick_button_texture",
					pass_type = "hotspot",
					content_id = "kick_button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "kick_button_texture",
					texture_id = "kick_button_texture",
					content_check_function = function(arg_311_0)
						return not arg_311_0.is_host and (arg_311_0.always_show_icons or arg_311_0.kick_enabled and arg_311_0.button_hotspot.is_hover and not arg_311_0.kick_button_hotspot.is_hover)
					end
				},
				{
					pass_type = "texture",
					style_id = "kick_button_texture_hover",
					texture_id = "kick_button_texture",
					content_check_function = function(arg_312_0)
						return arg_312_0.kick_enabled and arg_312_0.button_hotspot.is_hover and arg_312_0.kick_button_hotspot.is_hover
					end
				},
				{
					style_id = "kick_button_tooltip_text",
					pass_type = "tooltip_text",
					text_id = "kick_button_tooltip_text",
					content_check_function = function(arg_313_0)
						return arg_313_0.kick_enabled and arg_313_0.kick_button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "hover_texture",
					texture_id = "hover_texture",
					content_check_function = function(arg_314_0)
						if not arg_314_0.on_console then
							return arg_314_0.button_hotspot.is_selected or arg_314_0.button_hotspot.is_hover
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "console_hover_texture",
					texture_id = "console_hover_texture",
					content_check_function = function(arg_315_0)
						if arg_315_0.on_console then
							return arg_315_0.button_hotspot.is_selected or arg_315_0.button_hotspot.is_hover
						end
					end
				}
			}
		},
		content = {
			kick_button_tooltip_text = "map_setting_kick_player",
			always_show_icons = false,
			on_console = false,
			hero_icon_tooltip_text = "hero_icon",
			kick_enabled = false,
			is_host = false,
			hero_icon_texture = "tabs_class_icon_dwarf_ranger_normal",
			hover_texture = "map_setting_bg_fade",
			text = "n/a",
			console_hover_texture = "party_selection_glow",
			host_icon_texture = "host_icon",
			kick_button_texture = "kick_player_icon",
			button_hotspot = {},
			hero_icon_hotspot = {},
			kick_button_hotspot = {}
		},
		style = {
			gamepad_selection = arg_308_1 and {
				texture_size = {
					30,
					30
				},
				scenegraph_id = arg_308_1
			} or nil,
			text = {
				vertical_alignment = "center",
				font_size = 24,
				localize = false,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_table("white"),
				offset = {
					40,
					0,
					2
				}
			},
			hero_icon = {
				size = {
					34,
					34
				},
				offset = {
					0,
					3,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			host_icon = {
				size = {
					40,
					40
				},
				offset = {
					328,
					1,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hero_icon_tooltip_text = {
				font_size = 24,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				size = {
					34,
					34
				},
				offset = {
					0,
					3,
					4
				}
			},
			console_hover_texture = {
				size = {
					446,
					37
				},
				offset = {
					-1,
					1,
					-1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hover_texture = {
				size = {
					308,
					28
				},
				offset = {
					26,
					6,
					-1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			kick_button_texture = {
				size = {
					34,
					34
				},
				offset = {
					336,
					6,
					1
				},
				color = {
					180,
					255,
					255,
					255
				}
			},
			kick_button_texture_hover = {
				size = {
					34,
					34
				},
				offset = {
					336,
					6,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			kick_button_tooltip_text = {
				font_size = 24,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				size = {
					26,
					26
				},
				offset = {
					344,
					0,
					4
				}
			}
		},
		scenegraph_id = arg_308_0
	}
end

function UIWidgets.create_map_settings_stepper(arg_316_0, arg_316_1)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "hover_texture",
					texture_id = "hover_texture",
					content_check_function = function(arg_317_0)
						local var_317_0 = arg_317_0.button_hotspot

						return not var_317_0.gamepad_active and var_317_0.is_selected or var_317_0.is_hover
					end
				},
				{
					style_id = "left_button_texture",
					pass_type = "hotspot",
					content_id = "left_button_hotspot"
				},
				{
					style_id = "right_button_texture",
					pass_type = "hotspot",
					content_id = "right_button_hotspot"
				},
				{
					style_id = "setting_text",
					pass_type = "text",
					text_id = "setting_text"
				},
				{
					pass_type = "texture",
					style_id = "left_button_texture",
					texture_id = "left_button_texture",
					content_check_function = function(arg_318_0)
						local var_318_0 = arg_318_0.button_hotspot

						if var_318_0.gamepad_active then
							return var_318_0.is_selected
						else
							return true
						end
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "right_button_texture",
					texture_id = "right_button_texture",
					content_check_function = function(arg_319_0)
						local var_319_0 = arg_319_0.button_hotspot

						if var_319_0.gamepad_active then
							return var_319_0.is_selected
						else
							return true
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "left_button_texture_clicked",
					texture_id = "left_button_texture_clicked",
					content_check_function = function(arg_320_0)
						local var_320_0 = arg_320_0.button_hotspot

						if var_320_0.gamepad_active then
							return var_320_0.is_selected
						else
							return true
						end
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "right_button_texture_clicked",
					texture_id = "right_button_texture_clicked",
					content_check_function = function(arg_321_0)
						local var_321_0 = arg_321_0.button_hotspot

						if var_321_0.gamepad_active then
							return var_321_0.is_selected
						else
							return true
						end
					end
				}
			}
		},
		content = {
			left_button_texture = "settings_arrow_normal",
			hover_texture = "map_setting_bg_fade",
			setting_text = "test_text",
			right_button_texture_clicked = "settings_arrow_clicked",
			right_button_texture = "settings_arrow_normal",
			left_button_texture_clicked = "settings_arrow_clicked",
			button_hotspot = {},
			left_button_hotspot = {},
			right_button_hotspot = {}
		},
		style = {
			gamepad_selection = arg_316_1 and {
				texture_size = {
					40,
					40
				},
				scenegraph_id = arg_316_1
			} or nil,
			hover_texture = {
				size = {
					410,
					50
				},
				offset = {
					-55,
					-8,
					0
				}
			},
			left_button_texture = {
				size = {
					28,
					34
				},
				offset = {
					-40,
					-3,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			right_button_texture = {
				angle = 3.1415926499999998,
				pivot = {
					14,
					17
				},
				size = {
					28,
					34
				},
				offset = {
					315,
					-3,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			left_button_texture_clicked = {
				color = {
					0,
					255,
					255,
					255
				},
				size = {
					28,
					34
				},
				offset = {
					-40,
					-3,
					1
				}
			},
			right_button_texture_clicked = {
				angle = 3.1415926499999998,
				color = {
					0,
					255,
					255,
					255
				},
				pivot = {
					14,
					17
				},
				size = {
					28,
					34
				},
				offset = {
					315,
					-3,
					1
				}
			},
			setting_text = {
				font_size = 28,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					4
				}
			}
		},
		scenegraph_id = arg_316_0
	}
end

function UIWidgets.create_default_stepper(arg_322_0, arg_322_1)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "setting_text",
					pass_type = "text",
					text_id = "setting_text"
				},
				{
					style_id = "left_arrow",
					pass_type = "hotspot",
					content_id = "left_hotspot"
				},
				{
					style_id = "right_arrow",
					pass_type = "hotspot",
					content_id = "right_hotspot"
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow",
					pass_type = "texture",
					content_id = "arrow"
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow",
					pass_type = "texture_uv",
					content_id = "arrow"
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow_hover",
					pass_type = "texture",
					content_id = "arrow_hover"
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow_hover",
					pass_type = "texture_uv",
					content_id = "arrow_hover"
				}
			}
		},
		content = {
			hover_texture = "map_setting_bg_fade",
			setting_text = "",
			arrow = {
				texture_id = "settings_arrow_normal",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			},
			arrow_hover = {
				texture_id = "settings_arrow_clicked",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			},
			button_hotspot = {},
			left_hotspot = {},
			right_hotspot = {}
		},
		style = {
			field = {
				size = {
					arg_322_1[1] - 70,
					arg_322_1[2]
				},
				offset = {
					35,
					0,
					0
				},
				color = {
					255,
					5,
					5,
					5
				}
			},
			field_top = {
				size = {
					arg_322_1[1] - 70 - 2,
					arg_322_1[2] - 2
				},
				offset = {
					37,
					0,
					0
				},
				color = {
					255,
					15,
					15,
					15
				}
			},
			left_arrow = {
				size = {
					19,
					27
				},
				default_size = {
					19,
					27
				},
				offset = {
					0,
					arg_322_1[2] / 2 - 13.5,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			left_arrow_hover = {
				size = {
					30,
					35
				},
				offset = {
					6,
					arg_322_1[2] / 2 - 17.5,
					1
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			right_arrow = {
				size = {
					19,
					27
				},
				default_size = {
					19,
					27
				},
				offset = {
					arg_322_1[1] - 19,
					arg_322_1[2] / 2 - 13.5,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			right_arrow_hover = {
				size = {
					30,
					35
				},
				offset = {
					arg_322_1[1] - 36,
					arg_322_1[2] / 2 - 17.5,
					1
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			setting_text = {
				vertical_alignment = "center",
				upper_case = true,
				localize = false,
				horizontal_alignment = "center",
				font_size = 28,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					2
				}
			}
		},
		scenegraph_id = arg_322_0
	}
end

function UIWidgets.create_checkbox_widget(arg_323_0, arg_323_1, arg_323_2, arg_323_3, arg_323_4, arg_323_5)
	local var_323_0 = UIFrameSettings.menu_frame_06

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function(arg_324_0)
						return arg_324_0.button_hotspot.is_hover and arg_324_0.tooltip_text ~= "" and not arg_324_0.is_disabled
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text_disabled",
					content_check_function = function(arg_325_0)
						return arg_325_0.button_hotspot.is_hover and arg_325_0.tooltip_text_disabled ~= "" and arg_325_0.is_disabled
					end
				},
				{
					style_id = "setting_text",
					pass_type = "text",
					text_id = "setting_text",
					content_check_function = function(arg_326_0)
						return not arg_326_0.button_hotspot.is_hover and not arg_326_0.is_disabled
					end
				},
				{
					style_id = "setting_text_disabled",
					pass_type = "text",
					text_id = "setting_text",
					content_check_function = function(arg_327_0)
						return arg_327_0.is_disabled
					end
				},
				{
					style_id = "setting_text_hover",
					pass_type = "text",
					text_id = "setting_text",
					content_check_function = function(arg_328_0)
						return arg_328_0.button_hotspot.is_hover and not arg_328_0.is_disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "checkbox_marker",
					texture_id = "checkbox_marker",
					content_check_function = function(arg_329_0)
						return arg_329_0.checked and not arg_329_0.is_disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "checkbox_marker_disabled",
					texture_id = "checkbox_marker",
					content_check_function = function(arg_330_0)
						return arg_330_0.checked and arg_330_0.is_disabled
					end
				},
				{
					pass_type = "rect",
					style_id = "checkbox_background"
				},
				{
					pass_type = "texture_frame",
					style_id = "checkbox_frame",
					texture_id = "checkbox_frame",
					content_check_function = function(arg_331_0)
						return not arg_331_0.is_disabled
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "checkbox_frame_disabled",
					texture_id = "checkbox_frame",
					content_check_function = function(arg_332_0)
						return arg_332_0.is_disabled
					end
				}
			}
		},
		content = {
			checked = false,
			checkbox_marker = "matchmaking_checkbox",
			button_hotspot = {},
			tooltip_text = arg_323_1,
			setting_text = arg_323_0,
			tooltip_text_disabled = arg_323_5 or "",
			checkbox_frame = var_323_0.texture
		},
		style = {
			checkbox_style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					arg_323_3,
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
			checkbox_style_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					arg_323_3,
					0,
					1
				},
				color = {
					96,
					255,
					255,
					255
				}
			},
			checkbox_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					arg_323_3,
					0,
					0
				},
				color = {
					255,
					0,
					0,
					0
				}
			},
			checkbox_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				area_size = {
					40,
					40
				},
				texture_size = var_323_0.texture_size,
				texture_sizes = var_323_0.texture_sizes,
				offset = {
					arg_323_3,
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
			checkbox_frame_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				area_size = {
					40,
					40
				},
				texture_size = var_323_0.texture_size,
				texture_sizes = var_323_0.texture_sizes,
				offset = {
					arg_323_3,
					0,
					1
				},
				color = {
					96,
					255,
					255,
					255
				}
			},
			checkbox_marker = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					37,
					31
				},
				offset = {
					arg_323_3 + 4,
					6,
					1
				},
				color = Colors.get_color_table_with_alpha("font_title", 255)
			},
			checkbox_marker_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					37,
					31
				},
				offset = {
					arg_323_3 + 4,
					6,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 96)
			},
			setting_text = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "right",
				font_size = 24,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = arg_323_4 or {
					-50,
					0,
					4
				}
			},
			setting_text_disabled = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "right",
				font_size = 24,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 96),
				offset = arg_323_4 or {
					-50,
					0,
					4
				}
			},
			setting_text_hover = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "right",
				font_size = 24,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = arg_323_4 or {
					-50,
					0,
					4
				}
			},
			tooltip_text = {
				font_size = 24,
				max_width = 500,
				localize = true,
				cursor_side = "left",
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				offset = {
					0,
					0,
					50
				},
				cursor_offset = {
					-10,
					-27
				}
			}
		},
		scenegraph_id = arg_323_2
	}
end

function UIWidgets.create_story_level_map_widget(arg_333_0, arg_333_1, arg_333_2)
	local var_333_0 = UISettings.map.show_debug_levels
	local var_333_1 = {}
	local var_333_2 = 0
	local var_333_3 = {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "on_click",
					click_check_content_id = "button_hotspot",
					click_function = function(arg_334_0, arg_334_1, arg_334_2, arg_334_3)
						arg_334_2.button_hotspot.is_selected = true
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "selected",
					texture_id = "selected"
				},
				{
					pass_type = "texture",
					style_id = "hover",
					texture_id = "hover"
				},
				{
					pass_type = "tiled_texture",
					style_id = "text_background_center",
					texture_id = "text_background_center"
				},
				{
					pass_type = "texture",
					style_id = "text_background_left",
					texture_id = "text_background_left"
				},
				{
					pass_type = "texture",
					style_id = "text_background_right",
					texture_id = "text_background_right"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					pass_type = "texture",
					style_id = "difficulty_icon_1",
					texture_id = "difficulty_icon_1"
				},
				{
					pass_type = "texture",
					style_id = "difficulty_icon_2",
					texture_id = "difficulty_icon_2"
				},
				{
					pass_type = "texture",
					style_id = "difficulty_icon_3",
					texture_id = "difficulty_icon_3"
				},
				{
					pass_type = "texture",
					style_id = "difficulty_icon_4",
					texture_id = "difficulty_icon_4"
				},
				{
					pass_type = "texture",
					style_id = "difficulty_icon_5",
					texture_id = "difficulty_icon_5"
				},
				{
					pass_type = "texture",
					style_id = "new_flag",
					texture_id = "new_flag"
				}
			}
		},
		content = {
			text_background_center = "level_title_banner_middle",
			hover = "level_location_long_icon_hover",
			text_background_right = "level_title_banner_right",
			selected = "level_location_long_icon_selected",
			unlocked = "menu_map_level_unlocked_icon",
			difficulty_icon_3 = "difficulty_icon_small_02",
			difficulty_icon_2 = "difficulty_icon_small_02",
			difficulty_icon_4 = "difficulty_icon_small_02",
			difficulty_icon_1 = "difficulty_icon_small_02",
			background = "level_location_icon_01",
			difficulty_icon_5 = "difficulty_icon_small_02",
			new_flag = "list_item_tag_new",
			text_background_left = "level_title_banner_left",
			button_hotspot = {},
			title_text = arg_333_1
		},
		style = {
			new_flag = {
				size = {
					126,
					51
				},
				offset = {
					-21,
					-25,
					10
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			difficulty_icon_1 = {
				size = {
					15,
					21
				},
				offset = {
					-5,
					54,
					4
				}
			},
			difficulty_icon_2 = {
				size = {
					15,
					21
				},
				offset = {
					10,
					66,
					4
				}
			},
			difficulty_icon_3 = {
				size = {
					15,
					21
				},
				offset = {
					29,
					69,
					4
				}
			},
			difficulty_icon_4 = {
				size = {
					15,
					21
				},
				offset = {
					48,
					66,
					4
				}
			},
			difficulty_icon_5 = {
				size = {
					15,
					21
				},
				offset = {
					63,
					54,
					4
				}
			},
			background = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			selected = {
				color = {
					0,
					255,
					255,
					255
				}
			},
			hover = {
				color = {
					0,
					255,
					255,
					255
				}
			},
			unlocked = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			text_background_left = {},
			text_background_right = {},
			text_background_center = {
				offset = {
					0,
					0,
					0
				},
				texture_tiling_size = {
					26,
					35
				}
			},
			title_text = {
				localize = false,
				font_size = 28,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					0,
					0,
					1
				}
			},
			title_text_highlight = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				localize = false,
				font_size = 28,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("yellow", 255),
				offset = {
					0,
					-35,
					5
				}
			}
		},
		scenegraph_id = arg_333_0
	}

	return {
		game_type = "long",
		level_key = arg_333_1,
		widget = UIWidget.init(var_333_3)
	}
end

function UIWidgets.create_text_button(arg_335_0, arg_335_1, arg_335_2, arg_335_3, arg_335_4, arg_335_5)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_text"
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_336_0)
						return not arg_336_0.button_text.disable_button and (arg_336_0.button_text.is_hover or arg_336_0.button_text.is_selected)
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_337_0)
						return not arg_337_0.button_text.disable_button and not arg_337_0.button_text.is_hover and not arg_337_0.button_text.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_338_0)
						return arg_338_0.button_text.disable_button
					end
				}
			}
		},
		content = {
			button_text = {},
			text_field = arg_335_1,
			default_font_size = arg_335_2
		},
		style = {
			text = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_335_2,
				horizontal_alignment = arg_335_4 or "left",
				text_color = Colors.get_color_table_with_alpha(arg_335_5 or "font_button_normal", 255),
				offset = arg_335_3 or {
					0,
					0,
					4
				}
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_335_2,
				horizontal_alignment = arg_335_4 or "left",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = arg_335_3 or {
					0,
					0,
					4
				}
			},
			text_disabled = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_335_2,
				horizontal_alignment = arg_335_4 or "left",
				text_color = Colors.get_color_table_with_alpha("gray", 50),
				offset = arg_335_3 or {
					0,
					0,
					4
				}
			}
		},
		scenegraph_id = arg_335_0
	}
end

function UIWidgets.create_console_panel_button(arg_339_0, arg_339_1, arg_339_2, arg_339_3, arg_339_4, arg_339_5, arg_339_6)
	local var_339_0 = {
		-19,
		-25,
		10
	}
	local var_339_1 = {
		0,
		0,
		1
	}
	local var_339_2 = {
		0,
		-4,
		0
	}
	local var_339_3 = {
		2,
		3,
		3
	}

	if arg_339_4 then
		var_339_3[1] = var_339_3[1] + arg_339_4[1]
		var_339_3[2] = var_339_3[2] + arg_339_4[2]
		var_339_3[3] = arg_339_4[3] - 1
		var_339_2[1] = var_339_2[1] + arg_339_4[1]
		var_339_2[2] = var_339_2[2] + arg_339_4[2]
		var_339_2[3] = arg_339_4[3] - 3
		var_339_1[1] = var_339_1[1] + arg_339_4[1]
		var_339_1[2] = var_339_1[2] + arg_339_4[2]
		var_339_1[3] = arg_339_4[3] - 2
		var_339_0[1] = var_339_0[1] + arg_339_4[1]
		var_339_0[2] = var_339_0[2] + arg_339_4[2]
		var_339_0[3] = arg_339_4[3] - 2
	end

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_field"
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_340_0)
						return not arg_340_0.button_hotspot.disable_button and (arg_340_0.button_hotspot.is_hover or arg_340_0.button_hotspot.is_selected)
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_341_0)
						return not arg_341_0.button_hotspot.disable_button and not arg_341_0.button_hotspot.is_hover and not arg_341_0.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_342_0)
						return arg_342_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "selected_texture",
					style_id = "selected_texture",
					pass_type = "texture",
					content_check_function = function(arg_343_0)
						return not arg_343_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "marker",
					style_id = "marker_left",
					pass_type = "texture"
				},
				{
					texture_id = "marker",
					style_id = "marker_right",
					pass_type = "texture"
				},
				{
					texture_id = "new_marker",
					style_id = "new_marker",
					pass_type = "texture",
					content_check_function = function(arg_344_0)
						return arg_344_0.new
					end
				}
			}
		},
		content = {
			marker = "frame_detail_04",
			new_marker = "list_item_tag_new",
			selected_texture = "hero_panel_selection_glow",
			button_hotspot = {},
			text_field = arg_339_2,
			default_font_size = arg_339_3 or 32
		},
		style = {
			text = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_339_3 or 32,
				horizontal_alignment = arg_339_5 or "center",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_offset = arg_339_4 or {
					0,
					10,
					4
				},
				offset = arg_339_4 or {
					0,
					5,
					4
				},
				size = arg_339_1
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_339_3 or 32,
				horizontal_alignment = arg_339_5 or "center",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_offset = var_339_3,
				offset = var_339_3,
				size = arg_339_1
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_339_3 or 32,
				horizontal_alignment = arg_339_5 or "center",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_offset = arg_339_4 or {
					0,
					10,
					4
				},
				offset = arg_339_4 or {
					0,
					5,
					4
				},
				size = arg_339_1
			},
			text_disabled = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_339_3 or 32,
				horizontal_alignment = arg_339_5 or "center",
				text_color = Colors.get_color_table_with_alpha("gray", 50),
				default_offset = arg_339_4 or {
					0,
					10,
					4
				},
				offset = arg_339_4 or {
					0,
					5,
					4
				},
				size = arg_339_1
			},
			selected_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					169,
					35
				},
				color = arg_339_6 or Colors.get_color_table_with_alpha("font_title", 255),
				offset = var_339_2
			},
			marker_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					55,
					28
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_339_1[1] - 27.5,
					var_339_1[2],
					var_339_1[3]
				}
			},
			marker_right = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					55,
					28
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_339_1[1] + 27.5,
					var_339_1[2],
					var_339_1[3]
				}
			},
			new_marker = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					math.floor(88.19999999999999),
					math.floor(35.699999999999996)
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_339_0[1],
					var_339_0[2],
					var_339_0[3]
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_339_0
	}
end

function UIWidgets.create_compare_menu_trait_widget(arg_345_0, arg_345_1, arg_345_2, arg_345_3)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_bg_id",
					texture_id = "texture_bg_id",
					content_check_function = function(arg_346_0)
						return arg_346_0.use_background
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function(arg_347_0)
						return arg_347_0.texture_id
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_lock_id",
					texture_id = "texture_lock_id",
					content_check_function = function(arg_348_0)
						return arg_348_0.locked and not arg_348_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_glow_id",
					texture_id = "texture_glow_id",
					content_check_function = function(arg_349_0)
						return arg_349_0.use_glow
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					pass_type = "texture",
					style_id = "text_divider_texture",
					texture_id = "text_divider_texture",
					content_check_function = function(arg_350_0)
						return arg_350_0.use_divider
					end
				}
			}
		},
		content = {
			use_glow = true,
			locked = false,
			texture_lock_id = "trait_icon_selected_frame_locked",
			texture_glow_id = "item_slot_glow_03",
			title_text = "test_title_text",
			use_background = true,
			texture_bg_id = "trait_slot",
			texture_id = "trait_icon_empty",
			disabled = false,
			description_text = "test_description_text",
			text_divider_texture = "summary_screen_line_breaker",
			use_divider = arg_345_3
		},
		style = {
			text_divider_texture = {
				masked = arg_345_2,
				size = {
					386,
					22
				},
				offset = {
					40,
					60,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			title_text = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_size = 20,
				font_type = arg_345_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					55,
					0,
					1
				}
			},
			description_text = {
				word_wrap = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = arg_345_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					0
				},
				scenegraph_id = arg_345_1
			},
			texture_bg_id = {
				masked = arg_345_2,
				size = {
					54,
					58
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-7,
					-10,
					-1
				}
			},
			texture_id = {
				masked = arg_345_2,
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_lock_id = {
				masked = arg_345_2,
				offset = {
					0,
					0,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			texture_glow_id = {
				masked = arg_345_2,
				size = {
					104,
					104
				},
				offset = {
					-32,
					-32,
					4
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_345_0
	}
end

function UIWidgets.create_journal_tab(arg_351_0, arg_351_1, arg_351_2)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					texture_id = "texture_hover_id",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function(arg_352_0)
						local var_352_0 = arg_352_0.button_hotspot

						return not var_352_0.disabled and var_352_0.is_hover
					end
				},
				{
					texture_id = "texture_selected_id",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function(arg_353_0)
						local var_353_0 = arg_353_0.button_hotspot

						return not var_353_0.disabled and (var_353_0.is_clicked == 0 or var_353_0.is_selected)
					end
				},
				{
					texture_id = "new_texture_id",
					style_id = "new_texture_id",
					pass_type = "texture",
					content_check_function = function(arg_354_0)
						return arg_354_0.new
					end
				}
			}
		},
		content = {
			new = false,
			new_texture_id = "journal_icon_02",
			button_hotspot = {},
			texture_id = arg_351_1,
			texture_hover_id = arg_351_1 .. "_selected",
			texture_selected_id = arg_351_1 .. "_hover"
		},
		style = {
			texture_id = {
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
				masked = arg_351_2
			},
			new_texture_id = {
				size = {
					30,
					30
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					105,
					1
				},
				masked = arg_351_2
			}
		},
		scenegraph_id = arg_351_0
	}
end

function UIWidgets.create_journal_page_arrow_button(arg_355_0, arg_355_1, arg_355_2)
	local var_355_0
	local var_355_1 = {
		texture_hover_id = "journal_arrow_01",
		texture_selected_id = "journal_arrow_01_clicked",
		texture_id = "journal_arrow_01",
		button_hotspot = {}
	}

	if arg_355_1 then
		var_355_0 = {
			{
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				texture_id = "texture_id",
				style_id = "texture_id",
				pass_type = "texture_uv",
				content_check_function = function(arg_356_0)
					local var_356_0 = arg_356_0.button_hotspot

					return not var_356_0.disabled and not var_356_0.is_hover and (not var_356_0.is_clicked or var_356_0.is_clicked ~= 0)
				end
			},
			{
				texture_id = "texture_hover_id",
				style_id = "texture_hover_id",
				pass_type = "texture_uv",
				content_check_function = function(arg_357_0)
					local var_357_0 = arg_357_0.button_hotspot

					return not var_357_0.disabled and var_357_0.is_hover and (not var_357_0.is_clicked or var_357_0.is_clicked ~= 0)
				end
			},
			{
				texture_id = "texture_selected_id",
				style_id = "texture_selected_id",
				pass_type = "texture_uv",
				content_check_function = function(arg_358_0)
					local var_358_0 = arg_358_0.button_hotspot

					return not var_358_0.disabled and (var_358_0.is_clicked == 0 or var_358_0.is_selected)
				end
			}
		}
		var_355_1.uvs = arg_355_1
	else
		var_355_0 = {
			{
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				texture_id = "texture_id",
				style_id = "texture_id",
				pass_type = "texture",
				content_check_function = function(arg_359_0)
					local var_359_0 = arg_359_0.button_hotspot

					return not var_359_0.disabled and not var_359_0.is_hover and (not var_359_0.is_clicked or var_359_0.is_clicked ~= 0)
				end
			},
			{
				texture_id = "texture_hover_id",
				style_id = "texture_hover_id",
				pass_type = "texture",
				content_check_function = function(arg_360_0)
					local var_360_0 = arg_360_0.button_hotspot

					return not var_360_0.disabled and var_360_0.is_hover and (not var_360_0.is_clicked or var_360_0.is_clicked ~= 0)
				end
			},
			{
				texture_id = "texture_selected_id",
				style_id = "texture_selected_id",
				pass_type = "texture",
				content_check_function = function(arg_361_0)
					local var_361_0 = arg_361_0.button_hotspot

					return not var_361_0.disabled and (var_361_0.is_clicked == 0 or var_361_0.is_selected)
				end
			}
		}
	end

	return {
		element = {
			passes = var_355_0
		},
		content = var_355_1,
		style = {
			texture_id = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				masked = arg_355_2
			},
			texture_hover_id = {
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
				masked = arg_355_2
			},
			texture_selected_id = {
				size = {
					41,
					33
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-4,
					-5,
					0
				},
				masked = arg_355_2
			}
		},
		scenegraph_id = arg_355_0
	}
end

function UIWidgets.create_journal_back_arrow_button(arg_362_0, arg_362_1)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function(arg_363_0)
						local var_363_0 = arg_363_0.button_hotspot

						return not var_363_0.disabled and not var_363_0.is_hover and (not var_363_0.is_clicked or var_363_0.is_clicked ~= 0)
					end
				},
				{
					texture_id = "texture_hover_id",
					style_id = "texture_hover_id",
					pass_type = "texture",
					content_check_function = function(arg_364_0)
						local var_364_0 = arg_364_0.button_hotspot

						return not var_364_0.disabled and var_364_0.is_hover and (not var_364_0.is_clicked or var_364_0.is_clicked ~= 0)
					end
				},
				{
					texture_id = "texture_selected_id",
					style_id = "texture_selected_id",
					pass_type = "texture",
					content_check_function = function(arg_365_0)
						local var_365_0 = arg_365_0.button_hotspot

						return not var_365_0.disabled and (var_365_0.is_clicked == 0 or var_365_0.is_selected)
					end
				}
			}
		},
		content = {
			texture_hover_id = "journal_arrow_02",
			texture_selected_id = "journal_arrow_02_clicked",
			texture_id = "journal_arrow_02",
			button_hotspot = {}
		},
		style = {
			texture_id = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				masked = arg_362_1
			},
			texture_hover_id = {
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
				masked = arg_362_1
			},
			texture_selected_id = {
				size = {
					100,
					100
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-25,
					-25,
					0
				},
				masked = arg_362_1
			}
		},
		scenegraph_id = arg_362_0
	}
end

function UIWidgets.create_journal_reveal_mask(arg_366_0, arg_366_1, arg_366_2)
	local var_366_0 = {}
	local var_366_1 = {}
	local var_366_2 = {}
	local var_366_3 = #arg_366_0

	for iter_366_0 = 1, var_366_3 + 1 do
		if iter_366_0 == var_366_3 + 1 then
			local var_366_4 = "cover_rect"

			var_366_0[iter_366_0] = {
				pass_type = "texture",
				texture_id = var_366_4,
				style_id = var_366_4
			}
			var_366_1[var_366_4] = "mask_rect"
			var_366_2[var_366_4] = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			}
		else
			local var_366_5 = "texture_" .. iter_366_0
			local var_366_6 = arg_366_1[iter_366_0]

			var_366_0[iter_366_0] = {
				pass_type = "texture",
				style_id = var_366_5,
				texture_id = var_366_5
			}
			var_366_2[var_366_5] = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				scenegraph_id = var_366_6
			}
			var_366_1[var_366_5] = arg_366_0[iter_366_0]
		end
	end

	var_366_1.num_textures = var_366_3

	return {
		element = {
			passes = var_366_0
		},
		content = var_366_1,
		style = var_366_2,
		scenegraph_id = arg_366_2
	}
end

function UIWidgets.create_gamepad_selection(arg_367_0, arg_367_1, arg_367_2, arg_367_3)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_top_left",
					style_id = "texture_top_left",
					pass_type = "texture",
					retained_mode = arg_367_1
				},
				{
					texture_id = "texture_top_right",
					style_id = "texture_top_right",
					pass_type = "texture",
					retained_mode = arg_367_1
				},
				{
					texture_id = "texture_bottom_left",
					style_id = "texture_bottom_left",
					pass_type = "texture",
					retained_mode = arg_367_1
				},
				{
					texture_id = "texture_bottom_right",
					style_id = "texture_bottom_right",
					pass_type = "texture",
					retained_mode = arg_367_1
				}
			}
		},
		content = {
			texture_bottom_left = "gold_frame_01_lower_left_corner",
			texture_bottom_right = "gold_frame_01_lower_right_corner",
			texture_top_left = "gold_frame_01_upper_left_corner",
			texture_top_right = "gold_frame_01_upper_right_corner"
		},
		style = {
			texture_top_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = arg_367_3 or {
					40,
					40
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
				},
				masked = arg_367_2
			},
			texture_top_right = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = arg_367_3 or {
					40,
					40
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
				},
				masked = arg_367_2
			},
			texture_bottom_left = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = arg_367_3 or {
					40,
					40
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
				},
				masked = arg_367_2
			},
			texture_bottom_right = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = arg_367_3 or {
					40,
					40
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
				},
				masked = arg_367_2
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_367_0
	}
end

function UIWidgets.create_simple_atlas_texture(arg_368_0, arg_368_1, arg_368_2, arg_368_3, arg_368_4, arg_368_5, arg_368_6, arg_368_7)
	local var_368_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_368_0)

	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = arg_368_3
				}
			}
		},
		content = {
			texture_id = arg_368_0
		},
		style = {
			texture_id = {
				texture_size = var_368_0.size,
				color = arg_368_4 or {
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
				masked = arg_368_2,
				horizontal_alignment = arg_368_6,
				vertical_alignment = arg_368_7
			}
		},
		offset = {
			0,
			0,
			arg_368_5 or 0
		},
		scenegraph_id = arg_368_1
	}
end
