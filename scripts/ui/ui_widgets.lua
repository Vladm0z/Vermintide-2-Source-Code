-- chunkname: @scripts/ui/ui_widgets.lua

local_require("scripts/ui/ui_widgets_honduras")

local UIWidgets = UIWidgets

UIWidgets = UIWidgets or {}
UIWidgets = UIWidgets

UIWidgets.create_hover_button = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
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

local function fn(arg_2_0)
	-- function 2
	return {
		pass_type = "text",
		text_id = arg_2_0,
		style_id = arg_2_0,
		content_check_function = function (self)
			-- function 3
			return self[arg_2_0]
		end
	}
end

local function fn_2(arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local function fn(self)
		-- function 5
		local var_5_0 = self[arg_4_0]

		var_5_0 = not var_5_0 and not self[arg_4_2]

		return var_5_0
	end

	local function fn_2(self)
		-- function 6
		local var_6_0 = self[arg_4_0]

		var_6_0 = not var_6_0 and self[arg_4_2]

		return var_6_0
	end

	local tbl = {
		pass_type = "text",
		text_id = arg_4_0
	}
	local str

	if not arg_4_1 then
		str = arg_4_0 .. arg_4_1

		if not str then
			-- Nothing
		end
	end

	str = arg_4_0

	::label_4_0::

	tbl.style_id = str
	tbl.content_check_function = not arg_4_1 and fn_2 and fn

	return tbl
end

local function fn_3(arg_7_0, arg_7_1)
	-- function 7
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

UIWidgets.create_gamepad_layout_win32 = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background1",
					texture_id = "background1",
					content_check_function = function (self)
						-- function 9
						return not self.use_texture2_layout
					end
				},
				{
					pass_type = "texture",
					style_id = "background2",
					texture_id = "background2",
					content_check_function = function (self)
						-- function 10
						return self.use_texture2_layout
					end
				},
				fn_2("left_trigger", nil, "use_texture2_layout"),
				fn_2("left_shoulder", nil, "use_texture2_layout"),
				fn_2("right_trigger", nil, "use_texture2_layout"),
				fn_2("right_shoulder", nil, "use_texture2_layout"),
				fn_2("ls", nil, "use_texture2_layout"),
				fn_2("rs", nil, "use_texture2_layout"),
				fn_2("left_thumb", nil, "use_texture2_layout"),
				fn_2("right_thumb", nil, "use_texture2_layout"),
				fn_2("d_up", nil, "use_texture2_layout"),
				fn_2("d_down", nil, "use_texture2_layout"),
				fn_2("d_left", nil, "use_texture2_layout"),
				fn_2("d_right", nil, "use_texture2_layout"),
				fn_2("back", nil, "use_texture2_layout"),
				fn_2("start", nil, "use_texture2_layout"),
				fn_2("x", nil, "use_texture2_layout"),
				fn_2("y", nil, "use_texture2_layout"),
				fn_2("a", nil, "use_texture2_layout"),
				fn_2("b", nil, "use_texture2_layout"),
				fn_2("left_trigger", "_texture2", "use_texture2_layout"),
				fn_2("left_shoulder", "_texture2", "use_texture2_layout"),
				fn_2("right_trigger", "_texture2", "use_texture2_layout"),
				fn_2("right_shoulder", "_texture2", "use_texture2_layout"),
				fn_2("ls", "_texture2", "use_texture2_layout"),
				fn_2("rs", "_texture2", "use_texture2_layout"),
				fn_2("left_thumb", "_texture2", "use_texture2_layout"),
				fn_2("right_thumb", "_texture2", "use_texture2_layout"),
				fn_2("d_up", "_texture2", "use_texture2_layout"),
				fn_2("d_down", "_texture2", "use_texture2_layout"),
				fn_2("d_left", "_texture2", "use_texture2_layout"),
				fn_2("d_right", "_texture2", "use_texture2_layout"),
				fn_2("back", "_texture2", "use_texture2_layout"),
				fn_2("start", "_texture2", "use_texture2_layout"),
				fn_2("x", "_texture2", "use_texture2_layout"),
				fn_2("y", "_texture2", "use_texture2_layout"),
				fn_2("a", "_texture2", "use_texture2_layout"),
				fn_2("b", "_texture2", "use_texture2_layout")
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
			left_trigger = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 40,
				arg_8_4[3] + 16
			}),
			left_shoulder = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 78,
				arg_8_4[3] + 16
			}),
			right_trigger = fn_3("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 40,
				arg_8_4[3] + 16
			}),
			right_shoulder = fn_3("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 78,
				arg_8_4[3] + 16
			}),
			ls = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 176,
				arg_8_4[3] + 16
			}),
			rs = fn_3("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 334,
				arg_8_4[3] + 16
			}),
			left_thumb = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 196,
				arg_8_4[3] + 16
			}),
			right_thumb = fn_3("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 354,
				arg_8_4[3] + 16
			}),
			d_up = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 240,
				arg_8_4[3] + 16
			}),
			d_down = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 318,
				arg_8_4[3] + 16
			}),
			d_left = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 280,
				arg_8_4[3] + 16
			}),
			d_right = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 354,
				arg_8_4[3] + 16
			}),
			back = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 + 2,
				arg_8_4[3] + 16
			}),
			start = fn_3("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 + 2,
				arg_8_4[3] + 16
			}),
			x = fn_3("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 290,
				arg_8_4[3] + 16
			}),
			y = fn_3("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 126,
				arg_8_4[3] + 16
			}),
			a = fn_3("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 244,
				arg_8_4[3] + 16
			}),
			b = fn_3("right", {
				arg_8_4[1] + arg_8_1[1] - 5,
				arg_8_4[2] + 400 - 182,
				arg_8_4[3] + 16
			}),
			left_trigger_texture2 = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 40,
				arg_8_4[3] + 16
			}),
			left_shoulder_texture2 = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 400 - 78,
				arg_8_4[3] + 16
			}),
			right_trigger_texture2 = fn_3("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 400 - 40,
				arg_8_4[3] + 16
			}),
			right_shoulder_texture2 = fn_3("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 400 - 78,
				arg_8_4[3] + 16
			}),
			ls_texture2 = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 346,
				arg_8_4[3] + 16
			}),
			rs_texture2 = fn_3("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 348,
				arg_8_4[3] + 16
			}),
			left_thumb_texture2 = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 366,
				arg_8_4[3] + 16
			}),
			right_thumb_texture2 = fn_3("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 368,
				arg_8_4[3] + 16
			}),
			d_up_texture2 = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 156,
				arg_8_4[3] + 16
			}),
			d_down_texture2 = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 248,
				arg_8_4[3] + 16
			}),
			d_left_texture2 = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 202,
				arg_8_4[3] + 16
			}),
			d_right_texture2 = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 298,
				arg_8_4[3] + 16
			}),
			back_texture2 = fn_3("left", {
				arg_8_4[1] + 5,
				arg_8_4[2] + 440 - 38,
				arg_8_4[3] + 16
			}),
			start_texture2 = fn_3("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 38,
				arg_8_4[3] + 16
			}),
			x_texture2 = fn_3("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 300,
				arg_8_4[3] + 16
			}),
			y_texture2 = fn_3("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 156,
				arg_8_4[3] + 16
			}),
			a_texture2 = fn_3("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 250,
				arg_8_4[3] + 16
			}),
			b_texture2 = fn_3("right", {
				arg_8_4[1] + arg_8_3[1] - 5,
				arg_8_4[2] + 440 - 204,
				arg_8_4[3] + 16
			})
		},
		scenegraph_id = arg_8_5
	}
end

UIWidgets.create_gamepad_layout_xb1 = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				fn("left_trigger"),
				fn("left_shoulder"),
				fn("right_trigger"),
				fn("right_shoulder"),
				fn("ls"),
				fn("rs"),
				fn("left_thumb"),
				fn("right_thumb"),
				fn("d_up"),
				fn("d_down"),
				fn("d_left"),
				fn("d_right"),
				fn("back"),
				fn("start"),
				fn("x"),
				fn("y"),
				fn("a"),
				fn("b")
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
			left_trigger = fn_3("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 40,
				arg_11_2[3] + 16
			}),
			left_shoulder = fn_3("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 78,
				arg_11_2[3] + 16
			}),
			right_trigger = fn_3("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 40,
				arg_11_2[3] + 16
			}),
			right_shoulder = fn_3("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 78,
				arg_11_2[3] + 16
			}),
			ls = fn_3("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 176,
				arg_11_2[3] + 16
			}),
			rs = fn_3("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 334,
				arg_11_2[3] + 16
			}),
			left_thumb = fn_3("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 196,
				arg_11_2[3] + 16
			}),
			right_thumb = fn_3("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 354,
				arg_11_2[3] + 16
			}),
			d_up = fn_3("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 240,
				arg_11_2[3] + 16
			}),
			d_down = fn_3("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 318,
				arg_11_2[3] + 16
			}),
			d_left = fn_3("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 280,
				arg_11_2[3] + 16
			}),
			d_right = fn_3("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 - 354,
				arg_11_2[3] + 16
			}),
			back = fn_3("left", {
				arg_11_2[1] + 5,
				arg_11_2[2] + 400 + 2,
				arg_11_2[3] + 16
			}),
			start = fn_3("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 + 2,
				arg_11_2[3] + 16
			}),
			x = fn_3("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 290,
				arg_11_2[3] + 16
			}),
			y = fn_3("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 126,
				arg_11_2[3] + 16
			}),
			a = fn_3("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 244,
				arg_11_2[3] + 16
			}),
			b = fn_3("right", {
				arg_11_2[1] + arg_11_1[1] - 5,
				arg_11_2[2] + 400 - 182,
				arg_11_2[3] + 16
			})
		},
		scenegraph_id = arg_11_3
	}
end

UIWidgets.create_gamepad_layout_ps4 = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				fn("l2"),
				fn("l1"),
				fn("r2"),
				fn("r1"),
				fn("ls"),
				fn("rs"),
				fn("l3"),
				fn("r3"),
				fn("up"),
				fn("down"),
				fn("left"),
				fn("right"),
				fn("touch"),
				fn("options"),
				fn("square"),
				fn("triangle"),
				fn("cross"),
				fn("circle")
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
			l2 = fn_3("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 400 - 40,
				arg_12_2[3] + 16
			}),
			l1 = fn_3("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 400 - 78,
				arg_12_2[3] + 16
			}),
			r2 = fn_3("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 400 - 40,
				arg_12_2[3] + 16
			}),
			r1 = fn_3("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 400 - 78,
				arg_12_2[3] + 16
			}),
			ls = fn_3("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 346,
				arg_12_2[3] + 16
			}),
			rs = fn_3("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 348,
				arg_12_2[3] + 16
			}),
			l3 = fn_3("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 366,
				arg_12_2[3] + 16
			}),
			r3 = fn_3("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 368,
				arg_12_2[3] + 16
			}),
			up = fn_3("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 156,
				arg_12_2[3] + 16
			}),
			down = fn_3("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 248,
				arg_12_2[3] + 16
			}),
			left = fn_3("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 202,
				arg_12_2[3] + 16
			}),
			right = fn_3("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 298,
				arg_12_2[3] + 16
			}),
			touch = fn_3("left", {
				arg_12_2[1] + 5,
				arg_12_2[2] + 440 - 38,
				arg_12_2[3] + 16
			}),
			options = fn_3("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 38,
				arg_12_2[3] + 16
			}),
			square = fn_3("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 300,
				arg_12_2[3] + 16
			}),
			triangle = fn_3("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 156,
				arg_12_2[3] + 16
			}),
			cross = fn_3("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 250,
				arg_12_2[3] + 16
			}),
			circle = fn_3("right", {
				arg_12_2[1] + arg_12_1[1] - 5,
				arg_12_2[2] + 440 - 204,
				arg_12_2[3] + 16
			})
		},
		scenegraph_id = arg_12_3
	}
end

UIWidgets.create_menu_button = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 14
						return not self.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 15
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disabled or not not button_hotspot.is_hover or not (button_hotspot.is_clicked > 0) or not button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 16
						local button_hotspot = self.button_hotspot
						local is_hover

						if not (button_hotspot.disabled or button_hotspot.is_selected) then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_hover = false

						goto label_16_1

						::label_16_0::

						is_hover = true

						::label_16_1::

						return is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function (self)
						-- function 17
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disabled or button_hotspot.is_clicked == 0
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_selected_id",
					content_check_function = function (self)
						-- function 18
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disabled then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_selected = false

						goto label_18_1

						::label_18_0::

						is_selected = true

						::label_18_1::

						return is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function (self)
						-- function 19
						return self.button_hotspot.disabled
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "left_detail",
					texture_id = "left_texture_id",
					content_check_function = function (self)
						-- function 20
						return not self.disable_side_textures
					end
				},
				{
					pass_type = "texture",
					style_id = "right_detail",
					texture_id = "right_texture_id",
					content_check_function = function (self)
						-- function 21
						return not self.disable_side_textures
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 22
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disabled or not not button_hotspot.is_hover or not not button_hotspot.is_selected or button_hotspot.is_clicked > 0
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 23
						local button_hotspot = self.button_hotspot
						local is_hover

						if not (button_hotspot.disabled or button_hotspot.is_selected) then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_hover = false

						goto label_23_1

						::label_23_0::

						is_hover = true

						::label_23_1::

						return is_hover
					end
				},
				{
					style_id = "text_click",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 24
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disabled or button_hotspot.is_clicked == 0
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 25
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disabled then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								-- Nothing
							end

							if button_hotspot.is_clicked == 0 then
								-- Nothing
							end
						end

						is_selected = false

						goto label_25_1

						::label_25_0::

						is_selected = true

						::label_25_1::

						return is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 26
						return self.button_hotspot.disabled
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

UIWidgets.create_menu_button_medium = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
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
				localize = not not arg_27_2 or true,
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
				localize = not not arg_27_2 or true,
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
				localize = not not arg_27_2 or true,
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
				localize = not not arg_27_2 or true,
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

UIWidgets.create_popup_button_long = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
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
				localize = not not arg_28_2 or true,
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
				localize = not not arg_28_2 or true,
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
				localize = not not arg_28_2 or true,
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
				localize = not not arg_28_2 or true,
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

UIWidgets.create_quest_screen_button = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
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
				localize = not not arg_29_2 or true,
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
				localize = not not arg_29_2 or true,
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
				localize = not not arg_29_2 or true,
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
				localize = not not arg_29_2 or true,
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

UIWidgets.create_menu_button_small = function (arg_30_0, arg_30_1)
	-- function 30
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

UIWidgets.create_octagon_button = function (self, arg_31_1, arg_31_2)
	-- function 31
	local tbl = {
		element = UIElements.ToggleIconButton
	}
	local tbl_2 = {
		click_texture = "octagon_button_clicked",
		toggle_hover_texture = "octagon_button_toggled_hover",
		toggle_texture = "octagon_button_toggled",
		hover_texture = "octagon_button_hover",
		normal_texture = "octagon_button_normal"
	}
	local var_31_2 = self[1]

	var_31_2 = var_31_2 or "map_icon_friends_01"
	tbl_2.icon_texture = var_31_2

	local var_31_3 = self[2]

	var_31_3 = var_31_3 or "map_icon_friends_02"
	tbl_2.icon_hover_texture = var_31_3

	local var_31_4 = arg_31_1[1]

	var_31_4 = var_31_4 or ""
	tbl_2.tooltip_text = var_31_4

	local var_31_5 = arg_31_1[2]

	var_31_5 = var_31_5 or ""
	tbl_2.toggled_tooltip_text = var_31_5
	tbl_2.button_hotspot = {}
	tbl.content = tbl_2
	tbl.style = {
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
	}
	tbl.scenegraph_id = arg_31_2

	return tbl
end

UIWidgets.create_menu_button_medium_with_timer = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
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

UIWidgets.create_chain_scrollbar = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	-- function 33
	local var_33_0
	local var_33_1
	local str

	if arg_33_3 == "gold" then
		var_33_0 = "_gold"
		str = "_blue"
	else
		var_33_0 = ""
		str = ""
	end

	local tbl = {
		{
			pass_type = "local_offset",
			content_check_function = function (self)
				-- function 34
				return self.scroll_bar_info.bar_height_percentage < 1
			end,
			offset_function = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				local scroll_bar_info = arg_35_2.scroll_bar_info
				local axis = scroll_bar_info.axis
				local thumb_middle = arg_35_1.thumb_middle
				local thumb_bottom = arg_35_1.thumb_bottom
				local var_35_4 = arg_35_1.thumb_top.size[axis]
				local var_35_5 = thumb_middle.size[axis]
				local var_35_6 = thumb_bottom.size[axis]
				local hotspot = arg_35_1.hotspot
				local scroll_length = scroll_bar_info.scroll_length
				local num = var_35_4 + var_35_6
				local num_2 = num / scroll_length
				local bar_height_percentage = scroll_bar_info.bar_height_percentage
				local max = math.max(bar_height_percentage, num_2)

				hotspot.size[axis] = scroll_length * max
				thumb_middle.size[axis] = math.max(math.floor(scroll_length * max) - num, 0)
			end
		},
		{
			style_id = "hotspot",
			pass_type = "held",
			content_id = "scroll_bar_info",
			content_check_function = function (self)
				-- function 36
				return self.bar_height_percentage < 1
			end,
			held_function = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				local axis = arg_37_2.axis
				local is_device_active = Managers.input:is_device_active("gamepad")
				local get = arg_37_3:get("cursor")
				local var_37_3 = UIInverseScaleVectorToResolution(get)[axis]

				if not (not IS_XB1 and is_device_active) then
					var_37_3 = 1080 - get.y
				end

				local var_37_4 = UISceneGraph.get_world_position(arg_37_0, arg_37_2.scenegraph_id)[axis]
				local scroll_length = arg_37_2.scroll_length
				local clamp = math.clamp(var_37_3 - var_37_4, 0, scroll_length)
				local var_37_7 = arg_37_1.size[axis]

				if not arg_37_2.input_offset then
					arg_37_2.input_offset = clamp - arg_37_1.offset[axis]
				end

				local input_offset = arg_37_2.input_offset
				local num = 0
				local num_2 = scroll_length - var_37_7
				local num_3 = clamp - input_offset

				arg_37_2.value = 1 - math.clamp(num_3, num, num_2) / num_2
			end,
			release_function = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
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
			content_check_function = function (self)
				-- function 39
				return self.bar_height_percentage < 1
			end,
			offset_function = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				local axis = arg_40_2.axis
				local hotspot = arg_40_1.hotspot
				local num = 1 - arg_40_2.value
				local scroll_length = arg_40_2.scroll_length
				local var_40_4 = hotspot.size[axis]
				local num_2 = 0
				local num_3 = scroll_length - var_40_4
				local num_4 = num_3 * num
				local clamp = math.clamp(num_4, num_2, num_3)

				hotspot.offset[axis] = clamp

				local thumb_middle = arg_40_1.thumb_middle
				local thumb_bottom = arg_40_1.thumb_bottom
				local thumb_top = arg_40_1.thumb_top
				local var_40_12 = thumb_top.size[axis]
				local var_40_13 = thumb_middle.size[axis]
				local var_40_14 = thumb_bottom.size[axis]

				thumb_bottom.offset[axis] = clamp
				thumb_middle.offset[axis] = clamp + var_40_14
				thumb_top.offset[axis] = clamp + var_40_14 + var_40_13
			end
		},
		{
			style_id = "thumb_middle",
			pass_type = "texture",
			texture_id = "thumb_middle",
			content_change_function = function (self, arg_41_1)
				-- function 41
				local is_hover = self.scroll_bar_info.is_hover
				local color = arg_41_1.color
				local flag

				flag = not is_hover and 255 and 200
				color[2] = flag
				color[3] = flag
				color[4] = flag
			end,
			content_check_function = function (self)
				-- function 42
				return self.scroll_bar_info.bar_height_percentage < 1
			end
		},
		{
			style_id = "thumb_top",
			pass_type = "texture",
			texture_id = "thumb_top",
			content_change_function = function (self, arg_43_1)
				-- function 43
				local is_hover = self.scroll_bar_info.is_hover
				local color = arg_43_1.color
				local flag

				flag = not is_hover and 255 and 200
				color[2] = flag
				color[3] = flag
				color[4] = flag
			end,
			content_check_function = function (self)
				-- function 44
				return self.scroll_bar_info.bar_height_percentage < 1
			end
		},
		{
			style_id = "thumb_bottom",
			pass_type = "texture",
			texture_id = "thumb_bottom",
			content_change_function = function (self, arg_45_1)
				-- function 45
				local is_hover = self.scroll_bar_info.is_hover
				local color = arg_45_1.color
				local flag

				flag = not is_hover and 255 and 200
				color[2] = flag
				color[3] = flag
				color[4] = flag
			end,
			content_check_function = function (self)
				-- function 46
				return self.scroll_bar_info.bar_height_percentage < 1
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background",
			content_check_function = function (self)
				-- function 47
				return not self.disable_background
			end
		}
	}
	local tbl_2 = {
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
		background = "chain_link_01" .. (str or ""),
		thumb_top = "chain_scrollbutton_top" .. (var_33_0 or ""),
		thumb_bottom = "chain_scrollbutton_bottom" .. (var_33_0 or ""),
		thumb_middle = "chain_scrollbutton_middle" .. (var_33_0 or "")
	}
	local tbl_3 = {
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

	if not arg_33_1 then
		tbl[#tbl + 1] = {
			style_id = "scroll_area_hotspot",
			pass_type = "scroll",
			content_id = "scroll_area_hotspot",
			scroll_function = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
				-- function 48
				local num = arg_48_4.y * -1
				local scroll_bar_info = arg_48_2.parent.scroll_bar_info
				local gamepad_active = scroll_bar_info.gamepad_active
				local num_2 = arg_48_4.y * -1
				local flag

				flag = not gamepad_active and 0.2 and 1

				local num_3 = num_2 * flag
				local total_scroll_height = scroll_bar_info.total_scroll_height
				local scroll_amount = scroll_bar_info.scroll_amount
				local flag_2 = not gamepad_active and scroll_bar_info.gamepad_always_hover

				if num_3 == 0 or arg_48_2.is_hover or not flag_2 then
					scroll_bar_info.axis_input = num_3

					local scroll_add = scroll_bar_info.scroll_add

					scroll_add = scroll_add or 0
					scroll_bar_info.scroll_add = scroll_add + num_3 * scroll_amount
				else
					local axis_input = scroll_bar_info.axis_input
				end

				local scroll_add_2 = scroll_bar_info.scroll_add

				if not scroll_add_2 then
					local scroll_speed = scroll_bar_info.scroll_speed

					scroll_speed = scroll_speed or 5

					local num_4 = scroll_add_2 * (arg_48_5 * scroll_speed)
					local num_5 = scroll_add_2 - num_4

					if math.abs(num_5) > scroll_amount / 20 then
						scroll_bar_info.scroll_add = num_5
					else
						scroll_bar_info.scroll_add = nil
					end

					local scroll_value = scroll_bar_info.scroll_value

					if not scroll_value then
						scroll_bar_info.scroll_value = math.clamp(scroll_value + num_4, 0, 1)
					end
				end
			end
		}
		tbl_3.scroll_area_hotspot = {
			offset = {
				0,
				0,
				0
			},
			scenegraph_id = arg_33_1
		}
		tbl_2.scroll_area_hotspot = {}
	end

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_3,
		scenegraph_id = arg_33_0
	}
end

UIWidgets.create_horizontal_chain_scrollbar = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	-- function 49
	local var_49_0
	local var_49_1
	local str

	if arg_49_3 == "gold" then
		var_49_0 = "_gold"
		str = "_blue"
	else
		var_49_0 = ""
		str = ""
	end

	local tbl = {
		{
			pass_type = "local_offset",
			content_check_function = function (self)
				-- function 50
				return self.scroll_bar_info.bar_length_percentage < 1
			end,
			offset_function = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				-- function 51
				local scroll_bar_info = arg_51_2.scroll_bar_info
				local axis = scroll_bar_info.axis
				local thumb_left = arg_51_1.thumb_left
				local thumb_right = arg_51_1.thumb_right
				local thumb_middle = arg_51_1.thumb_middle
				local var_51_5 = thumb_left.size[axis]
				local var_51_6 = thumb_right.size[axis]
				local var_51_7 = thumb_middle.size[axis]
				local hotspot = arg_51_1.hotspot
				local scroll_length = scroll_bar_info.scroll_length
				local num = var_51_6 + var_51_5
				local num_2 = num / scroll_length
				local bar_length_percentage = scroll_bar_info.bar_length_percentage
				local max = math.max(bar_length_percentage, num_2)

				hotspot.size[axis] = scroll_length * max
				thumb_middle.size[axis] = math.max(math.floor(scroll_length * max) - num, 0)
			end
		},
		{
			style_id = "hotspot",
			pass_type = "held",
			content_id = "scroll_bar_info",
			content_check_function = function (self)
				-- function 52
				return self.bar_length_percentage < 1
			end,
			held_function = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
				-- function 53
				local axis = arg_53_2.axis
				local is_device_active = Managers.input:is_device_active("gamepad")
				local get = arg_53_3:get("cursor")
				local var_53_3 = UIInverseScaleVectorToResolution(get)[axis]

				if not (not IS_XB1 and is_device_active) then
					var_53_3 = 1080 - get.y
				end

				local var_53_4 = UISceneGraph.get_world_position(arg_53_0, arg_53_2.scenegraph_id)[axis]
				local scroll_length = arg_53_2.scroll_length
				local clamp = math.clamp(var_53_3 - var_53_4, 0, scroll_length)
				local var_53_7 = arg_53_1.size[axis]

				if not arg_53_2.input_offset then
					arg_53_2.input_offset = clamp - arg_53_1.offset[axis]
				end

				local input_offset = arg_53_2.input_offset
				local num = 0
				local num_2 = scroll_length - var_53_7
				local num_3 = clamp - input_offset

				arg_53_2.value = math.clamp(num_3, num, num_2) / num_2
			end,
			release_function = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				-- function 54
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
			content_check_function = function (self)
				-- function 55
				return self.bar_length_percentage < 1
			end,
			offset_function = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				-- function 56
				local axis = arg_56_2.axis
				local hotspot = arg_56_1.hotspot
				local value = arg_56_2.value
				local scroll_length = arg_56_2.scroll_length
				local var_56_4 = hotspot.size[axis]
				local num = 0
				local num_2 = scroll_length - var_56_4
				local num_3 = num_2 * value
				local clamp = math.clamp(num_3, num, num_2)

				hotspot.offset[axis] = clamp

				local thumb_left = arg_56_1.thumb_left
				local thumb_right = arg_56_1.thumb_right
				local thumb_middle = arg_56_1.thumb_middle
				local var_56_12 = thumb_left.size[axis]
				local var_56_13 = thumb_right.size[axis]
				local var_56_14 = thumb_middle.size[axis]

				thumb_left.offset[axis] = clamp
				thumb_middle.offset[axis] = clamp + var_56_12
				thumb_right.offset[axis] = clamp + var_56_12 + var_56_14
			end
		},
		{
			style_id = "thumb_middle",
			pass_type = "texture",
			texture_id = "thumb_middle",
			content_change_function = function (self, arg_57_1)
				-- function 57
				local is_hover = self.scroll_bar_info.is_hover
				local color = arg_57_1.color
				local flag

				flag = not is_hover and 255 and 200
				color[2] = flag
				color[3] = flag
				color[4] = flag
			end,
			content_check_function = function (self)
				-- function 58
				return self.scroll_bar_info.bar_length_percentage < 1
			end
		},
		{
			style_id = "thumb_left",
			pass_type = "texture",
			texture_id = "thumb_left",
			content_change_function = function (self, arg_59_1)
				-- function 59
				local is_hover = self.scroll_bar_info.is_hover
				local color = arg_59_1.color
				local flag

				flag = not is_hover and 255 and 200
				color[2] = flag
				color[3] = flag
				color[4] = flag
			end,
			content_check_function = function (self)
				-- function 60
				return self.scroll_bar_info.bar_length_percentage < 1
			end
		},
		{
			style_id = "thumb_right",
			pass_type = "texture",
			texture_id = "thumb_right",
			content_change_function = function (self, arg_61_1)
				-- function 61
				local is_hover = self.scroll_bar_info.is_hover
				local color = arg_61_1.color
				local flag

				flag = not is_hover and 255 and 200
				color[2] = flag
				color[3] = flag
				color[4] = flag
			end,
			content_check_function = function (self)
				-- function 62
				return self.scroll_bar_info.bar_length_percentage < 1
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background",
			content_check_function = function (self)
				-- function 63
				return not self.disable_background
			end
		}
	}
	local tbl_2 = {
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
		background = "chain_link_horizontal_01" .. (str or ""),
		thumb_left = "chain_scrollbutton_left" .. (var_49_0 or ""),
		thumb_right = "chain_scrollbutton_right" .. (var_49_0 or ""),
		thumb_middle = "chain_scrollbutton_horizontal_middle" .. (var_49_0 or "")
	}
	local tbl_3 = {
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

	if not arg_49_1 then
		tbl[#tbl + 1] = {
			style_id = "scroll_area_hotspot",
			pass_type = "scroll",
			content_id = "scroll_area_hotspot",
			scroll_function = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5)
				-- function 64
				local num = arg_64_4.x * -1
				local scroll_bar_info = arg_64_2.parent.scroll_bar_info
				local total_scroll_height = scroll_bar_info.total_scroll_height

				if num == 0 or not arg_64_2.is_hover then
					scroll_bar_info.axis_input = num
					scroll_bar_info.scroll_add = num * scroll_bar_info.scroll_amount
				else
					local axis_input = scroll_bar_info.axis_input
				end

				local scroll_add = scroll_bar_info.scroll_add

				if not scroll_add then
					local num_2 = scroll_add * (arg_64_5 * 5)
					local num_3 = scroll_add - num_2

					if math.abs(num_3) > 0 then
						scroll_bar_info.scroll_add = num_3
					else
						scroll_bar_info.scroll_add = nil
					end

					local scroll_value = scroll_bar_info.scroll_value

					scroll_bar_info.scroll_value = math.clamp(scroll_value + num_2, 0, 1)
				end
			end
		}
		tbl_3.scroll_area_hotspot = {
			offset = {
				0,
				0,
				0
			},
			scenegraph_id = arg_49_1
		}
		tbl_2.scroll_area_hotspot = {}
	end

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_3,
		scenegraph_id = arg_49_0
	}
end

UIWidgets.create_scrollbar = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6)
	-- function 65
	local tbl = {
		{
			pass_type = "local_offset",
			content_check_function = function (self)
				-- function 66
				return self.scroll_bar_info.bar_height_percentage < 1
			end,
			offset_function = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
				-- function 67
				local scroll_bar_info = arg_67_2.scroll_bar_info
				local axis = scroll_bar_info.axis
				local hotspot = arg_67_1.hotspot
				local scroll_bar_box = arg_67_1.scroll_bar_box
				local scroll_length = scroll_bar_info.scroll_length
				local bar_height_percentage = scroll_bar_info.bar_height_percentage

				hotspot.size[axis] = scroll_length * bar_height_percentage
				scroll_bar_box.size[axis] = scroll_length * bar_height_percentage
			end
		},
		{
			style_id = "hotspot",
			pass_type = "held",
			content_id = "scroll_bar_info",
			content_check_function = function (self)
				-- function 68
				return self.bar_height_percentage < 1
			end,
			held_function = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
				-- function 69
				local axis = arg_69_2.axis
				local is_device_active = Managers.input:is_device_active("gamepad")
				local get = arg_69_3:get("cursor")
				local var_69_3 = UIInverseScaleVectorToResolution(get)[axis]

				if not (not IS_XB1 and is_device_active) then
					var_69_3 = 1080 - get.y
				end

				local var_69_4 = UISceneGraph.get_world_position(arg_69_0, arg_69_2.scenegraph_id)[axis]
				local scroll_length = arg_69_2.scroll_length
				local clamp = math.clamp(var_69_3 - var_69_4, 0, scroll_length)
				local var_69_7 = arg_69_1.size[axis]

				if not arg_69_2.input_offset then
					arg_69_2.input_offset = clamp - arg_69_1.offset[axis]
				end

				local input_offset = arg_69_2.input_offset
				local num = 0
				local num_2 = scroll_length - var_69_7
				local num_3 = clamp - input_offset

				arg_69_2.value = 1 - math.clamp(num_3, num, num_2) / num_2
			end,
			release_function = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
				-- function 70
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
			content_check_function = function (self)
				-- function 71
				return self.bar_height_percentage < 1
			end,
			offset_function = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
				-- function 72
				local axis = arg_72_2.axis
				local hotspot = arg_72_1.hotspot
				local num = 1 - arg_72_2.value
				local scroll_length = arg_72_2.scroll_length
				local var_72_4 = hotspot.size[axis]
				local num_2 = 0
				local num_3 = scroll_length - var_72_4
				local num_4 = num_3 * num
				local clamp = math.clamp(num_4, num_2, num_3)

				hotspot.offset[axis] = clamp
				arg_72_1.scroll_bar_box.offset[axis] = clamp
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
	local tbl_2 = {
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
	local tbl_3 = {
		background = {
			corner_radius = arg_65_6 or 2,
			color = arg_65_4 or {
				255,
				5,
				5,
				5
			}
		}
	}
	local tbl_4 = {
		corner_radius = arg_65_6 or 2
	}
	local tbl_5 = {
		nil,
		0,
		1
	}
	local num

	if not arg_65_5 then
		num = arg_65_1[1] / 2 - arg_65_5 * 0.5

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_65_0::

	tbl_5[1] = num
	tbl_4.offset = tbl_5
	tbl_4.size = {
		arg_65_5,
		arg_65_1[2]
	}
	tbl_4.color = arg_65_3 or Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_3.scroll_bar_box = tbl_4
	tbl_3.hotspot = {
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

	local tbl_6 = {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_3,
		scenegraph_id = arg_65_0
	}

	if not arg_65_2 then
		tbl[#tbl + 1] = {
			style_id = "scroll_area_hotspot",
			pass_type = "scroll",
			content_id = "scroll_area_hotspot",
			scroll_function = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5)
				-- function 73
				local is_device_active = Managers.input:is_device_active("gamepad")
				local num = arg_73_4.y * -1
				local scroll_bar_info = arg_73_2.parent.scroll_bar_info
				local total_scroll_height = scroll_bar_info.total_scroll_height
				local scroll_amount = scroll_bar_info.scroll_amount

				if num == 0 or arg_73_2.is_hover or not is_device_active then
					scroll_bar_info.axis_input = num

					local scroll_add = scroll_bar_info.scroll_add

					scroll_add = scroll_add or 0
					scroll_bar_info.scroll_add = scroll_add + num * scroll_amount
				else
					local axis_input = scroll_bar_info.axis_input
				end

				local scroll_add_2 = scroll_bar_info.scroll_add

				if not scroll_add_2 then
					local scroll_speed = scroll_bar_info.scroll_speed

					scroll_speed = scroll_speed or 5

					local num_2 = scroll_add_2 * (arg_73_5 * scroll_speed)
					local num_3 = scroll_add_2 - num_2

					if math.abs(num_3) > scroll_amount / 20 then
						scroll_bar_info.scroll_add = num_3
					else
						scroll_bar_info.scroll_add = nil
					end

					local scroll_value = scroll_bar_info.scroll_value

					if not scroll_value then
						scroll_bar_info.scroll_value = math.clamp(scroll_value + num_2, 0, 1)
					end
				end
			end
		}
		tbl_3.scroll_area_hotspot = {
			offset = {
				0,
				0,
				0
			},
			scenegraph_id = arg_65_2
		}
		tbl_2.scroll_area_hotspot = {}
	end

	return tbl_6
end

UIWidgets.create_lock_icon = function (arg_74_0, arg_74_1)
	-- function 74
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

UIWidgets.create_quest_navigation_button = function (arg_75_0, arg_75_1, arg_75_2)
	-- function 75
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 76
						return not self.disabled
					end
				},
				{
					pass_type = "hotspot",
					content_id = "tooltip_hotspot",
					content_check_function = function (self)
						-- function 77
						return not self.disabled
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_id = "texture_id",
					content_check_function = function (self)
						-- function 78
						local button_hotspot = self.parent.button_hotspot

						return not not button_hotspot.is_hover or button_hotspot.is_clicked == 0 or not button_hotspot.disabled
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 79
						local button_hotspot = self.parent.button_hotspot
						local is_selected = button_hotspot.is_selected

						if not is_selected then
							is_selected = button_hotspot.is_hover
							is_selected = not is_selected and button_hotspot.is_clicked == 0 or not button_hotspot.disabled
						end

						return is_selected
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "texture_click_id",
					texture_id = "texture_click_id",
					content_id = "texture_click_id",
					content_check_function = function (self)
						-- function 80
						return self.parent.button_hotspot.is_clicked ~= 0 or not self.parent.button_hotspot.disabled
					end
				},
				{
					pass_type = "texture_uv",
					style_id = "texture_disabled_id",
					texture_id = "texture_disabled_id",
					content_id = "texture_disabled_id",
					content_check_function = function (self)
						-- function 81
						return self.parent.button_hotspot.disabled
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function (self)
						-- function 82
						local tooltip_text = self.tooltip_text

						if not tooltip_text then
							tooltip_text = self.button_hotspot.is_hover

							if not tooltip_text then
								tooltip_text = self.tooltip_hotspot.is_hover
								tooltip_text = not tooltip_text and not self.button_hotspot.disabled
							end
						end

						return tooltip_text
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

UIWidgets.create_gold_button_3_state = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	-- function 83
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
					content_check_function = function (self)
						-- function 84
						return not not self.button_hotspot.is_hover or self.button_hotspot.is_clicked > 0
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 85
						local is_selected = self.button_hotspot.is_selected

						if not is_selected then
							is_selected = self.button_hotspot.is_hover
							is_selected = not is_selected and self.button_hotspot.is_clicked > 0
						end

						return is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function (self)
						-- function 86
						return self.button_hotspot.is_clicked == 0
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

UIWidgets.create_gamepad_bar_input_extension = function (arg_87_0)
	-- function 87
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "input_bg",
					texture_id = "input_bg",
					content_check_function = function (self)
						-- function 88
						return self.is_gamepad_active
					end
				},
				{
					texture_id = "input_icon",
					style_id = "input_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 89
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and self.show_input

						return is_gamepad_active
					end
				},
				{
					texture_id = "input_icon_overlay",
					style_id = "input_icon_overlay",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 90
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and self.charging

						return is_gamepad_active
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

UIWidgets.create_forge_merge_button = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4)
	-- function 91
	local tbl = {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 92
						local show_cancel_text

						if not self.charging then
							show_cancel_text = self.show_cancel_text

							if not show_cancel_text then
								-- Nothing
							end
						end

						show_cancel_text = not self.disabled

						::label_92_0::

						return show_cancel_text
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 93
						local button_hotspot = self.button_hotspot
						local is_clicked

						if not (self.is_gamepad_active or button_hotspot.disabled or button_hotspot.is_hover) then
							if not button_hotspot.is_clicked then
								-- Nothing
							end

							is_clicked = button_hotspot.is_clicked

							if not is_clicked then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_clicked = false

						goto label_93_1

						::label_93_0::

						is_clicked = true

						::label_93_1::

						return is_clicked
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 94
						local button_hotspot = self.button_hotspot
						local is_hover

						if not (self.is_gamepad_active or button_hotspot.disabled) then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if not button_hotspot.is_clicked then
								-- Nothing
							end

							is_hover = button_hotspot.is_clicked

							if not is_hover then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_hover = false

						goto label_94_1

						::label_94_0::

						is_hover = true

						::label_94_1::

						return is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function (self)
						-- function 95
						local button_hotspot = self.button_hotspot

						return (self.is_gamepad_active or button_hotspot.disabled or button_hotspot.is_clicked or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function (self)
						-- function 96
						local button_hotspot = self.button_hotspot

						return not not self.is_gamepad_active or button_hotspot.disabled
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 97
						local button_hotspot = self.button_hotspot
						local show_tokens

						if not (self.charging or self.show_cancel_text) then
							show_tokens = self.show_tokens

							if not show_tokens then
								show_tokens = self.texture_token_type

								if not show_tokens then
									if not button_hotspot.is_clicked then
										show_tokens = button_hotspot.is_clicked

										if not show_tokens then
											-- Nothing
										end

										if button_hotspot.is_clicked > 0 then
											-- Nothing
										end
									end

									show_tokens = not button_hotspot.is_selected
								end
							end

							goto label_97_1
						end

						::label_97_0::

						show_tokens = false

						if false then
							show_tokens = true
						end

						::label_97_1::

						return show_tokens
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type_selected",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 98
						local button_hotspot = self.button_hotspot

						return (self.charging or self.show_cancel_text or self.show_tokens or self.texture_token_type or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 99
						local button_hotspot = self.button_hotspot
						local show_tokens

						if not (self.charging or self.show_cancel_text or button_hotspot.is_hover) then
							show_tokens = self.show_tokens

							if not show_tokens then
								if not button_hotspot.is_clicked then
									show_tokens = button_hotspot.is_clicked

									if not show_tokens then
										-- Nothing
									end

									if button_hotspot.is_clicked > 0 then
										-- Nothing
									end
								end

								show_tokens = not button_hotspot.is_selected
							end

							goto label_99_1
						end

						::label_99_0::

						show_tokens = false

						if false then
							show_tokens = true
						end

						::label_99_1::

						return show_tokens
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 100
						local button_hotspot = self.button_hotspot
						local is_hover = button_hotspot.is_hover

						if not is_hover then
							is_hover = self.show_tokens

							if not is_hover then
								if not button_hotspot.is_clicked then
									is_hover = button_hotspot.is_clicked

									if not is_hover then
										-- Nothing
									end

									if button_hotspot.is_clicked > 0 then
										-- Nothing
									end
								end

								is_hover = not button_hotspot.is_selected
							end
						end

						if false then
							::label_100_0::

							is_hover = false
						end

						if false then
							is_hover = true
						end

						::label_100_1::

						return is_hover
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 101
						local button_hotspot = self.button_hotspot

						return (self.charging or self.show_cancel_text or self.show_tokens or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 102
						local disabled = self.button_hotspot.disabled

						disabled = not disabled and self.is_disabled

						return disabled
					end
				},
				{
					style_id = "text_center",
					pass_type = "text",
					text_id = "text_field_center",
					content_check_function = function (self)
						-- function 103
						local button_hotspot = self.button_hotspot

						return not not self.charging or not not self.show_cancel_text or not not button_hotspot.disabled or not not button_hotspot.is_hover or not not button_hotspot.is_selected or not self.show_tokens
					end
				},
				{
					style_id = "text_hover_center",
					pass_type = "text",
					text_id = "text_field_center",
					content_check_function = function (self)
						-- function 104
						local button_hotspot = self.button_hotspot
						local is_hover

						if not (self.charging or self.show_cancel_text or button_hotspot.disabled) then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if button_hotspot.is_clicked > 0 then
								is_hover = not self.show_tokens

								goto label_104_0
							end
						end

						is_hover = false

						if false then
							is_hover = true
						end

						::label_104_0::

						return is_hover
					end
				},
				{
					style_id = "text_selected_center",
					pass_type = "text",
					text_id = "text_field_center",
					content_check_function = function (self)
						-- function 105
						local button_hotspot = self.button_hotspot
						local is_selected

						if not (self.charging or self.show_cancel_text or self.is_disabled) then
							if button_hotspot.is_clicked ~= 0 then
								is_selected = button_hotspot.is_selected

								if not is_selected then
									-- Nothing
								end
							end

							is_selected = not self.show_tokens
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						::label_105_0::

						return is_selected
					end
				},
				{
					style_id = "token_text",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function (self)
						-- function 106
						local button_hotspot = self.button_hotspot
						local show_tokens

						if not (self.charging or self.show_cancel_text or button_hotspot.is_hover) then
							show_tokens = self.show_tokens

							if not show_tokens then
								if not button_hotspot.is_clicked then
									show_tokens = button_hotspot.is_clicked

									if not show_tokens then
										-- Nothing
									end

									if button_hotspot.is_clicked > 0 then
										-- Nothing
									end
								end

								show_tokens = not button_hotspot.is_selected
							end

							goto label_106_1
						end

						::label_106_0::

						show_tokens = false

						if false then
							show_tokens = true
						end

						::label_106_1::

						return show_tokens
					end
				},
				{
					style_id = "token_text_hover",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function (self)
						-- function 107
						local button_hotspot = self.button_hotspot
						local is_hover

						if not (self.charging or self.show_cancel_text) then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								is_hover = self.show_tokens

								if not is_hover then
									if not button_hotspot.is_clicked then
										is_hover = button_hotspot.is_clicked

										if not is_hover then
											-- Nothing
										end

										if button_hotspot.is_clicked > 0 then
											-- Nothing
										end
									end

									is_hover = not button_hotspot.is_selected
								end
							end

							goto label_107_1
						end

						::label_107_0::

						is_hover = false

						if false then
							is_hover = true
						end

						::label_107_1::

						return is_hover
					end
				},
				{
					style_id = "token_text_selected",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function (self)
						-- function 108
						local button_hotspot = self.button_hotspot

						return (self.charging or self.show_cancel_text or self.show_tokens or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					style_id = "text_charge_cancelled",
					pass_type = "text",
					text_id = "text_charge_cancelled",
					content_check_function = function (self)
						-- function 109
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and self.show_cancel_text

						return is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame",
					content_check_function = function (self)
						-- function 110
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame_disabled",
					content_check_function = function (self)
						-- function 111
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg",
					content_check_function = function (self)
						-- function 112
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg_disabled",
					content_check_function = function (self)
						-- function 113
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					style_id = "progress_fill",
					pass_type = "texture_uv",
					content_id = "progress_fill",
					content_check_function = function (self)
						-- function 114
						return self.parent.is_gamepad_active
					end
				},
				{
					texture_id = "progress_fill_glow",
					style_id = "progress_fill_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 115
						return self.is_gamepad_active
					end
				},
				{
					texture_id = "progress_input_icon",
					style_id = "progress_input_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 116
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					texture_id = "progress_input_icon_overlay",
					style_id = "progress_input_icon_overlay",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 117
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not not button_hotspot.disabled or self.charging

						return is_gamepad_active
					end
				},
				{
					texture_id = "eye_glow_texture",
					style_id = "eye_glow_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 118
						local button_hotspot = self.button_hotspot
						local use_eye_glow

						if not self.is_gamepad_active then
							use_eye_glow = self.use_eye_glow

							if not use_eye_glow then
								use_eye_glow = not button_hotspot.disabled
							end
						else
							use_eye_glow = false
						end

						if false then
							use_eye_glow = true
						end

						return use_eye_glow
					end
				},
				{
					texture_id = "gamepad_glow_texture",
					style_id = "gamepad_glow_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 119
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not button_hotspot.disabled

						return is_gamepad_active
					end
				}
			}
		}
	}
	local tbl_2 = {
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
		texture_id = "forge_button_03_normal"
	}
	local flag

	flag = not arg_91_3 and true and false
	tbl_2.use_eye_glow = flag
	tbl_2.text_field = Localize("merge")
	tbl_2.text_field_center = Localize("merge")
	tbl_2.button_hotspot = {}
	tbl_2.text_charge_cancelled = Localize("forge_screen_melt_abort")
	tbl_2.progress_fill = {
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
	tbl.content = tbl_2
	tbl.style = {
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
	}
	tbl.scenegraph_id = arg_91_0

	return tbl
end

UIWidgets.create_altar_button = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4)
	-- function 120
	local tbl = {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 121
						return not self.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 122
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and not self.is_gamepad_active then
							return false
						end

						local is_clicked

						if not (button_hotspot.disabled or button_hotspot.is_hover) then
							if not button_hotspot.is_clicked then
								-- Nothing
							end

							is_clicked = button_hotspot.is_clicked

							if not is_clicked then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_clicked = false

						goto label_122_1

						::label_122_0::

						is_clicked = true

						::label_122_1::

						return is_clicked
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 123
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and not self.is_gamepad_active then
							return false
						end

						local is_hover

						if not button_hotspot.disabled then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if not button_hotspot.is_clicked then
								-- Nothing
							end

							is_hover = button_hotspot.is_clicked

							if not is_hover then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_hover = false

						goto label_123_1

						::label_123_0::

						is_hover = true

						::label_123_1::

						return is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function (self)
						-- function 124
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and not self.is_gamepad_active then
							return false
						end

						return (button_hotspot.disabled or button_hotspot.is_clicked or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function (self)
						-- function 125
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and not self.is_gamepad_active then
							return false
						end

						return button_hotspot.disabled
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 126
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and self.charging and not self.show_cancel_text then
							return false
						end

						local disabled

						if not button_hotspot.disabled then
							disabled = button_hotspot.disabled

							if not disabled then
								-- Nothing
							end

							disabled = self.default_text_on_disable

							if not disabled then
								-- Nothing
							end
						end

						disabled = self.texture_token_type

						if not disabled then
							if not button_hotspot.is_clicked then
								disabled = button_hotspot.is_clicked

								if not disabled then
									-- Nothing
								end

								if button_hotspot.is_clicked > 0 then
									-- Nothing
								end
							end

							disabled = not button_hotspot.is_selected
						end

						if false then
							::label_126_0::

							disabled = false
						end

						if false then
							disabled = true
						end

						::label_126_1::

						return disabled
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type_selected",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 127
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and self.charging and not self.show_cancel_text then
							return false
						end

						local texture_token_type

						if not button_hotspot.disabled then
							texture_token_type = self.texture_token_type

							if not texture_token_type then
								-- Nothing
							end

							texture_token_type = button_hotspot.is_selected

							if not texture_token_type then
								-- Nothing
							end

							texture_token_type = button_hotspot.is_clicked

							if not texture_token_type then
								-- Nothing
							end

							if button_hotspot.is_clicked ~= 0 then
								-- Nothing
							end
						end

						texture_token_type = false

						goto label_127_1

						::label_127_0::

						texture_token_type = true

						::label_127_1::

						return texture_token_type
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 128
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and self.charging and not self.show_cancel_text then
							return false
						end

						local disabled

						if not button_hotspot.disabled then
							disabled = button_hotspot.disabled

							if not disabled then
								-- Nothing
							end

							disabled = self.default_text_on_disable

							if not disabled then
								-- Nothing
							end
						end

						if not button_hotspot.is_hover then
							if not button_hotspot.is_clicked then
								disabled = button_hotspot.is_clicked

								if not disabled then
									-- Nothing
								end

								if button_hotspot.is_clicked > 0 then
									-- Nothing
								end
							end

							disabled = not button_hotspot.is_selected

							goto label_128_1
						end

						::label_128_0::

						disabled = false

						if false then
							disabled = true
						end

						::label_128_1::

						return disabled
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 129
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and self.charging and not self.show_cancel_text then
							return false
						end

						local is_hover

						if not button_hotspot.disabled then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								if not button_hotspot.is_clicked then
									is_hover = button_hotspot.is_clicked

									if not is_hover then
										-- Nothing
									end

									if button_hotspot.is_clicked > 0 then
										-- Nothing
									end
								end

								is_hover = not button_hotspot.is_selected
							end

							goto label_129_1
						end

						::label_129_0::

						is_hover = false

						if false then
							is_hover = true
						end

						::label_129_1::

						return is_hover
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 130
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and self.charging and not self.show_cancel_text then
							return false
						end

						return (button_hotspot.disabled or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 131
						local disabled = self.button_hotspot.disabled

						disabled = not disabled and not self.default_text_on_disable

						return disabled
					end
				},
				{
					style_id = "token_text",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function (self)
						-- function 132
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and self.charging and not self.show_cancel_text then
							return false
						end

						local disabled

						if not button_hotspot.disabled then
							disabled = button_hotspot.disabled

							if not disabled then
								-- Nothing
							end

							disabled = self.default_text_on_disable

							if not disabled then
								-- Nothing
							end
						end

						if not button_hotspot.is_hover then
							if not button_hotspot.is_clicked then
								disabled = button_hotspot.is_clicked

								if not disabled then
									-- Nothing
								end

								if button_hotspot.is_clicked > 0 then
									-- Nothing
								end
							end

							disabled = not button_hotspot.is_selected

							goto label_132_1
						end

						::label_132_0::

						disabled = false

						if false then
							disabled = true
						end

						::label_132_1::

						return disabled
					end
				},
				{
					style_id = "token_text_hover",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function (self)
						-- function 133
						local button_hotspot = self.button_hotspot

						if not self.enable_charge and self.charging and not self.show_cancel_text then
							return false
						end

						local is_hover

						if not button_hotspot.disabled then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								if not button_hotspot.is_clicked then
									is_hover = button_hotspot.is_clicked

									if not is_hover then
										-- Nothing
									end

									if button_hotspot.is_clicked > 0 then
										-- Nothing
									end
								end

								is_hover = not button_hotspot.is_selected
							end

							goto label_133_1
						end

						::label_133_0::

						is_hover = false

						if false then
							is_hover = true
						end

						::label_133_1::

						return is_hover
					end
				},
				{
					style_id = "token_text_selected",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function (self)
						-- function 134
						local button_hotspot = self.button_hotspot

						return (self.charging or self.show_cancel_text or button_hotspot.disabled or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "button_frame_texture",
					texture_id = "button_frame_texture",
					content_check_function = function (self)
						-- function 135
						return not not self.is_gamepad_active or self.show_frame
					end
				},
				{
					pass_type = "texture",
					style_id = "button_frame_glow_texture",
					texture_id = "button_frame_glow_texture",
					content_check_function = function (self)
						-- function 136
						return self.show_glow
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame",
					content_check_function = function (self)
						-- function 137
						local button_hotspot = self.button_hotspot
						local enable_charge = self.enable_charge

						enable_charge = not enable_charge and self.is_gamepad_active

						return enable_charge
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg",
					content_check_function = function (self)
						-- function 138
						local button_hotspot = self.button_hotspot
						local enable_charge = self.enable_charge

						if not enable_charge then
							enable_charge = self.is_gamepad_active
							enable_charge = not enable_charge and not button_hotspot.disabled
						end

						return enable_charge
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg_disabled",
					content_check_function = function (self)
						-- function 139
						local button_hotspot = self.button_hotspot
						local enable_charge = self.enable_charge

						if not enable_charge then
							enable_charge = self.is_gamepad_active
							enable_charge = not enable_charge and button_hotspot.disabled
						end

						return enable_charge
					end
				},
				{
					style_id = "progress_fill",
					pass_type = "texture_uv",
					content_id = "progress_fill",
					content_check_function = function (self)
						-- function 140
						local parent = self.parent
						local enable_charge = parent.enable_charge

						enable_charge = not enable_charge and parent.is_gamepad_active

						return enable_charge
					end
				},
				{
					texture_id = "progress_fill_glow",
					style_id = "progress_fill_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 141
						local enable_charge = self.enable_charge

						enable_charge = not enable_charge and self.is_gamepad_active

						return enable_charge
					end
				},
				{
					texture_id = "progress_input_icon",
					style_id = "progress_input_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 142
						local button_hotspot = self.button_hotspot
						local enable_charge

						if not self.disable_input_icon then
							if not self.enable_input_icon then
								enable_charge = self.enable_charge

								if not enable_charge then
									-- Nothing
								end
							end

							enable_charge = self.is_gamepad_active

							if not enable_charge then
								enable_charge = not button_hotspot.disabled
							end
						else
							enable_charge = false
						end

						if false then
							enable_charge = true
						end

						::label_142_0::

						return enable_charge
					end
				},
				{
					texture_id = "progress_input_bg",
					style_id = "progress_input_bg",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 143
						local button_hotspot = self.button_hotspot
						local enable_charge

						if not self.enable_input_icon then
							enable_charge = self.enable_charge

							if not enable_charge then
								-- Nothing
							end
						end

						enable_charge = self.is_gamepad_active

						::label_143_0::

						return enable_charge
					end
				},
				{
					texture_id = "progress_input_icon_overlay",
					style_id = "progress_input_icon_overlay",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 144
						local button_hotspot = self.button_hotspot
						local enable_charge

						if not self.enable_input_icon then
							enable_charge = self.enable_charge

							if not enable_charge then
								-- Nothing
							end
						end

						enable_charge = self.is_gamepad_active
						enable_charge = not enable_charge and not not button_hotspot.disabled or self.charging

						::label_144_0::

						return enable_charge
					end
				},
				{
					style_id = "text_charge_cancelled",
					pass_type = "text",
					text_id = "text_charge_cancelled",
					content_check_function = function (self)
						-- function 145
						local button_hotspot = self.button_hotspot
						local enable_charge = self.enable_charge

						if not enable_charge then
							enable_charge = self.is_gamepad_active
							enable_charge = not enable_charge and self.show_cancel_text
						end

						return enable_charge
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
		}
	}
	local tbl_2 = {
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
		}
	}
	local tbl_3 = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 24,
		text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
	}
	local flag

	flag = not arg_120_2 and "left" and "center"
	tbl_3.horizontal_alignment = flag

	local tbl_4 = {
		nil,
		0,
		2
	}
	local flag_2

	flag_2 = not arg_120_2 and 10 and 0
	tbl_4[1] = flag_2
	tbl_3.offset = tbl_4
	tbl_3.scenegraph_id = arg_120_2
	tbl_2.text = tbl_3

	local tbl_5 = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 24,
		text_color = Colors.get_color_table_with_alpha("white", 255)
	}
	local flag_3

	flag_3 = not arg_120_2 and "left" and "center"
	tbl_5.horizontal_alignment = flag_3

	local tbl_6 = {
		nil,
		0,
		2
	}
	local flag_4

	flag_4 = not arg_120_2 and 10 and 0
	tbl_6[1] = flag_4
	tbl_5.offset = tbl_6
	tbl_5.scenegraph_id = arg_120_2
	tbl_2.text_hover = tbl_5

	local tbl_7 = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 24,
		text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
	}
	local flag_5

	flag_5 = not arg_120_2 and "left" and "center"
	tbl_7.horizontal_alignment = flag_5

	local tbl_8 = {
		nil,
		-2,
		2
	}
	local flag_6

	flag_6 = not arg_120_2 and 10 and 0
	tbl_8[1] = flag_6
	tbl_7.offset = tbl_8
	tbl_7.scenegraph_id = arg_120_2
	tbl_2.text_selected = tbl_7
	tbl_2.token_text = {
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
	}
	tbl_2.token_text_hover = {
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
	}
	tbl_2.token_text_selected = {
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
	}
	tbl_2.text_disabled = {
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
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_120_1

	return tbl
end

UIWidgets.create_dice_game_button = function (arg_146_0)
	-- function 146
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 147
						return not self.disabled
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 148
						local button_hotspot = self.button_hotspot
						local is_clicked

						if not (button_hotspot.disabled or button_hotspot.is_hover) then
							is_clicked = button_hotspot.is_clicked

							if not is_clicked then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_clicked = false

						goto label_148_1

						::label_148_0::

						is_clicked = true

						::label_148_1::

						return is_clicked
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 149
						local button_hotspot = self.button_hotspot
						local is_hover

						if not button_hotspot.disabled then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							is_hover = button_hotspot.is_clicked

							if not is_hover then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_hover = false

						goto label_149_1

						::label_149_0::

						is_hover = true

						::label_149_1::

						return is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function (self)
						-- function 150
						local button_hotspot = self.button_hotspot

						return (button_hotspot.disabled or button_hotspot.is_clicked or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function (self)
						-- function 151
						return self.button_hotspot.disabled
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 152
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disabled or not not button_hotspot.is_hover or not button_hotspot.is_selected
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 153
						local button_hotspot = self.button_hotspot
						local is_hover

						if not button_hotspot.disabled then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_hover = false

						goto label_153_1

						::label_153_0::

						is_hover = true

						::label_153_1::

						return is_hover
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 154
						local button_hotspot = self.button_hotspot
						local is_hover

						if not button_hotspot.disabled then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if button_hotspot.is_clicked ~= 0 then
								-- Nothing
							end
						end

						is_hover = false

						goto label_154_1

						::label_154_0::

						is_hover = true

						::label_154_1::

						return is_hover
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 155
						return self.button_hotspot.disabled
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

UIWidgets.create_altar_craft_reagent_button = function (arg_156_0, arg_156_1, arg_156_2, arg_156_3, arg_156_4)
	-- function 156
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 157
						return not self.disabled
					end
				},
				{
					style_id = "required_hover_hotspot",
					pass_type = "hotspot",
					content_id = "required_hover_hotspot",
					content_check_function = function (self)
						-- function 158
						return not self.disabled
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
					content_check_function = function (self)
						-- function 159
						local tooltip_text = self.tooltip_text

						if not tooltip_text then
							tooltip_text = self.button_hotspot.is_hover
							tooltip_text = not tooltip_text and self.required_hover_hotspot.is_hover
						end

						return tooltip_text
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

UIWidgets.create_forge_upgrade_button = function (arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4)
	-- function 160
	local tbl = {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 161
						local show_cancel_text

						if not self.charging then
							show_cancel_text = self.show_cancel_text

							if not show_cancel_text then
								-- Nothing
							end
						end

						show_cancel_text = not self.disabled

						::label_161_0::

						return show_cancel_text
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 162
						local button_hotspot = self.button_hotspot
						local is_clicked

						if not (self.is_gamepad_active or button_hotspot.disabled or button_hotspot.is_hover) then
							if not button_hotspot.is_clicked then
								-- Nothing
							end

							is_clicked = button_hotspot.is_clicked

							if not is_clicked then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_clicked = false

						goto label_162_1

						::label_162_0::

						is_clicked = true

						::label_162_1::

						return is_clicked
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 163
						local button_hotspot = self.button_hotspot
						local is_hover

						if not (self.is_gamepad_active or button_hotspot.disabled) then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if not button_hotspot.is_clicked then
								-- Nothing
							end

							is_hover = button_hotspot.is_clicked

							if not is_hover then
								-- Nothing
							end

							if not (button_hotspot.is_clicked > 0) then
								-- Nothing
							end
						end

						is_hover = false

						goto label_163_1

						::label_163_0::

						is_hover = true

						::label_163_1::

						return is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_click_id",
					content_check_function = function (self)
						-- function 164
						local button_hotspot = self.button_hotspot

						return (self.is_gamepad_active or button_hotspot.disabled or button_hotspot.is_clicked or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_disabled_id",
					content_check_function = function (self)
						-- function 165
						local button_hotspot = self.button_hotspot

						return not not self.is_gamepad_active or button_hotspot.disabled
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 166
						if not self.texture_token_type then
							local button_hotspot = self.button_hotspot
							local texture_token_type

							if not (self.charging or self.show_cancel_text or self.show_title) then
								texture_token_type = self.texture_token_type

								if not texture_token_type then
									if not button_hotspot.is_clicked then
										texture_token_type = button_hotspot.is_clicked

										if not texture_token_type then
											-- Nothing
										end

										if button_hotspot.is_clicked > 0 then
											-- Nothing
										end
									end

									texture_token_type = not button_hotspot.is_selected
								end

								goto label_166_1
							end

							::label_166_0::

							texture_token_type = false

							if false then
								texture_token_type = true
							end

							::label_166_1::

							return texture_token_type
						end
					end
				},
				{
					texture_id = "texture_token_type",
					style_id = "texture_token_type_selected",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 167
						if not self.texture_token_type then
							local button_hotspot = self.button_hotspot
							local is_selected

							if self.charging or self.show_cancel_text or self.show_title or not self.texture_token_type then
								is_selected = button_hotspot.is_selected

								if not is_selected then
									-- Nothing
								end
							end

							is_selected = button_hotspot.is_clicked
							is_selected = not is_selected and button_hotspot.is_clicked == 0

							::label_167_0::

							return is_selected
						end
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 168
						local button_hotspot = self.button_hotspot
						local is_clicked

						if not (self.charging or self.show_cancel_text or button_hotspot.is_hover or self.show_title) then
							if not button_hotspot.is_clicked then
								is_clicked = button_hotspot.is_clicked

								if not is_clicked then
									-- Nothing
								end

								if button_hotspot.is_clicked > 0 then
									-- Nothing
								end
							end

							is_clicked = not button_hotspot.is_selected

							goto label_168_1
						end

						::label_168_0::

						is_clicked = false

						if false then
							is_clicked = true
						end

						::label_168_1::

						return is_clicked
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 169
						local button_hotspot = self.button_hotspot
						local is_hover

						if not (self.charging or self.show_cancel_text) then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if not self.show_title then
								if not button_hotspot.is_clicked then
									is_hover = button_hotspot.is_clicked

									if not is_hover then
										-- Nothing
									end

									if button_hotspot.is_clicked > 0 then
										-- Nothing
									end
								end

								is_hover = not button_hotspot.is_selected

								goto label_169_1
							end
						end

						::label_169_0::

						is_hover = false

						if false then
							is_hover = true
						end

						::label_169_1::

						return is_hover
					end
				},
				{
					style_id = "token_text",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function (self)
						-- function 170
						local button_hotspot = self.button_hotspot
						local is_clicked

						if not (self.charging or self.show_cancel_text or button_hotspot.is_hover or self.show_title) then
							if not button_hotspot.is_clicked then
								is_clicked = button_hotspot.is_clicked

								if not is_clicked then
									-- Nothing
								end

								if button_hotspot.is_clicked > 0 then
									-- Nothing
								end
							end

							is_clicked = not button_hotspot.is_selected

							goto label_170_1
						end

						::label_170_0::

						is_clicked = false

						if false then
							is_clicked = true
						end

						::label_170_1::

						return is_clicked
					end
				},
				{
					style_id = "token_text_hover",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function (self)
						-- function 171
						local button_hotspot = self.button_hotspot
						local is_hover

						if not (self.charging or self.show_cancel_text) then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if not self.show_title then
								if not button_hotspot.is_clicked then
									is_hover = button_hotspot.is_clicked

									if not is_hover then
										-- Nothing
									end

									if button_hotspot.is_clicked > 0 then
										-- Nothing
									end
								end

								is_hover = not button_hotspot.is_selected

								goto label_171_1
							end
						end

						::label_171_0::

						is_hover = false

						if false then
							is_hover = true
						end

						::label_171_1::

						return is_hover
					end
				},
				{
					style_id = "text_selected",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 172
						local button_hotspot = self.button_hotspot

						return (self.charging or self.show_cancel_text or self.show_title or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					style_id = "token_text_selected",
					pass_type = "text",
					text_id = "token_text",
					content_check_function = function (self)
						-- function 173
						local button_hotspot = self.button_hotspot

						return (self.charging or self.show_cancel_text or self.show_title or button_hotspot.is_clicked ~= 0) and button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 174
						local disabled = self.button_hotspot.disabled

						disabled = not disabled and self.show_title

						return disabled
					end
				},
				{
					style_id = "text_charge_cancelled",
					pass_type = "text",
					text_id = "text_charge_cancelled",
					content_check_function = function (self)
						-- function 175
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and self.show_cancel_text

						return is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame",
					content_check_function = function (self)
						-- function 176
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					texture_id = "progress_frame_disabled",
					content_check_function = function (self)
						-- function 177
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg",
					content_check_function = function (self)
						-- function 178
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "progress_frame_bg",
					texture_id = "progress_frame_bg_disabled",
					content_check_function = function (self)
						-- function 179
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					style_id = "progress_fill",
					pass_type = "texture_uv",
					content_id = "progress_fill",
					content_check_function = function (self)
						-- function 180
						return self.parent.is_gamepad_active
					end
				},
				{
					texture_id = "progress_fill_glow",
					style_id = "progress_fill_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 181
						return self.is_gamepad_active
					end
				},
				{
					texture_id = "progress_input_icon",
					style_id = "progress_input_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 182
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not button_hotspot.disabled

						return is_gamepad_active
					end
				},
				{
					texture_id = "progress_input_icon_overlay",
					style_id = "progress_input_icon_overlay",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 183
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not not button_hotspot.disabled or self.charging

						return is_gamepad_active
					end
				},
				{
					texture_id = "eye_glow_texture",
					style_id = "eye_glow_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 184
						local button_hotspot = self.button_hotspot
						local use_eye_glow

						if not self.is_gamepad_active then
							use_eye_glow = self.use_eye_glow

							if not use_eye_glow then
								use_eye_glow = not button_hotspot.disabled
							end
						else
							use_eye_glow = false
						end

						if false then
							use_eye_glow = true
						end

						return use_eye_glow
					end
				},
				{
					texture_id = "gamepad_glow_texture",
					style_id = "gamepad_glow_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 185
						local button_hotspot = self.button_hotspot
						local is_gamepad_active = self.is_gamepad_active

						is_gamepad_active = not is_gamepad_active and not button_hotspot.disabled

						return is_gamepad_active
					end
				}
			}
		}
	}
	local tbl_2 = {
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
		}
	}
	local flag

	flag = not arg_160_3 and true and false
	tbl_2.use_eye_glow = flag
	tbl_2.text_field = Localize("upgrade")
	tbl_2.button_hotspot = {}
	tbl_2.text_charge_cancelled = Localize("forge_screen_melt_abort")
	tbl.content = tbl_2
	tbl.style = {
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
	}
	tbl.scenegraph_id = arg_160_0

	return tbl
end

UIWidgets.create_menu_selection_bar = function (self, arg_186_1, arg_186_2, arg_186_3, arg_186_4, arg_186_5, arg_186_6, arg_186_7)
	-- function 186
	local tbl = {}
	local tbl_2 = {
		passes = tbl
	}
	local tbl_3 = {}
	local tbl_4 = {}

	assert(arg_186_1.texture_hover_id, "missing texture")
	assert(arg_186_1.texture_click_id, "missing texture")

	local tbl_5 = {
		style = tbl_3,
		content = tbl_4,
		element = tbl_2,
		scenegraph_id = arg_186_5
	}
	local count = #arg_186_2

	for i = 1, count do
		local var_186_6 = i
		local str = "tooltip_text_" .. i
		local format = string.format("button_style_%d", i)
		local format_2 = string.format("button_click_style_%d", i)
		local format_3 = string.format("icon_%d", i)
		local format_4 = string.format("icon_click_%d", i)
		local format_5 = string.format("disabled_overlay_%d", i)

		table.append_varargs(tbl, {
			pass_type = "hotspot",
			content_id = var_186_6,
			style_id = var_186_6
		}, {
			pass_type = "texture",
			texture_id = format_2,
			style_id = format_2
		}, {
			pass_type = "texture",
			texture_id = format,
			style_id = format
		}, {
			pass_type = "texture",
			texture_id = format_3,
			style_id = format_3
		}, {
			pass_type = "texture",
			texture_id = format_4,
			style_id = format_4
		}, {
			pass_type = "tooltip_text",
			text_id = str,
			style_id = str,
			content_check_function = function (self)
				-- function 187
				return self[var_186_6].is_hover
			end
		}, {
			pass_type = "rect",
			style_id = format_5,
			content_check_function = function (self)
				-- function 188
				return self[var_186_6].disable_button
			end
		})

		local format_6 = string.format("%s_%d", arg_186_5, i)

		self[format_6] = {
			parent = i ~= 1 or not arg_186_5 or string.format("%s_%d", arg_186_5, i - 1),
			size = arg_186_6,
			offset = i == 1 or not arg_186_4 or nil
		}

		local format_7 = string.format("%s_icon_%d", arg_186_5, i)

		self[format_7] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = format_6,
			size = arg_186_7,
			offset = {
				0,
				0,
				5
			}
		}
		tbl_4[var_186_6] = {}
		tbl_4[str] = arg_186_3[i]
		tbl_4[format] = arg_186_1.texture_hover_id
		tbl_4[format_3] = arg_186_2[i].texture_hover_id
		tbl_4[format_2] = arg_186_1.texture_click_id
		tbl_4[format_4] = arg_186_2[i].texture_click_id
		tbl_3[str] = {
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
		tbl_3[format_5] = {
			scenegraph_id = format_6,
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
		tbl_3[var_186_6] = {
			scenegraph_id = format_6,
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
		tbl_3[format] = {
			scenegraph_id = format_6,
			color = {
				178.5,
				255,
				255,
				255
			},
			size = arg_186_6
		}
		tbl_3[format_3] = {
			scenegraph_id = format_7,
			color = {
				178.5,
				255,
				255,
				255
			},
			size = arg_186_7
		}
		tbl_3[format_2] = {
			scenegraph_id = format_6,
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
		tbl_3[format_4] = {
			scenegraph_id = format_7,
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

	return tbl_5
end

UIWidgets.create_tiled_texture = function (arg_189_0, arg_189_1, arg_189_2, arg_189_3, arg_189_4, arg_189_5)
	-- function 189
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

UIWidgets.create_shader_tiled_texture = function (arg_190_0, arg_190_1, arg_190_2, arg_190_3, arg_190_4, arg_190_5)
	-- function 190
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

UIWidgets.create_texture_with_text = function (arg_191_0, arg_191_1, arg_191_2, arg_191_3, arg_191_4)
	-- function 191
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

UIWidgets.create_texture_with_text_and_tooltip = function (arg_192_0, arg_192_1, arg_192_2, arg_192_3, arg_192_4, arg_192_5, arg_192_6)
	-- function 192
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
					content_check_function = function (self)
						-- function 193
						return not self.disabled
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function (self)
						-- function 194
						return self.tooltip_hotspot.is_hover
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

UIWidgets.create_simple_tooltip = function (arg_195_0, arg_195_1, arg_195_2, arg_195_3)
	-- function 195
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
					content_check_function = function (self)
						-- function 196
						return self.tooltip_hotspot.is_hover
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

UIWidgets.create_additional_option_tooltip = function (arg_197_0, arg_197_1, arg_197_2, arg_197_3, arg_197_4, arg_197_5, arg_197_6, arg_197_7, arg_197_8)
	-- function 197
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
					content_check_function = function (self)
						-- function 198
						local tooltip = self.tooltip

						tooltip = not tooltip and self.button_hotspot.is_hover

						return tooltip
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

UIWidgets.create_simple_hotspot = function (arg_199_0, arg_199_1)
	-- function 199
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

UIWidgets.create_simple_two_state_button = function (arg_200_0, arg_200_1, arg_200_2)
	-- function 200
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

UIWidgets.create_simple_rect = function (arg_201_0, arg_201_1, arg_201_2, arg_201_3, arg_201_4)
	-- function 201
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

UIWidgets.create_simple_rounded_rect = function (arg_202_0, arg_202_1, arg_202_2)
	-- function 202
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

UIWidgets.create_simple_texture = function (arg_203_0, arg_203_1, arg_203_2, arg_203_3, arg_203_4, arg_203_5, arg_203_6, arg_203_7, arg_203_8)
	-- function 203
	if type(arg_203_5) ~= "table" then
		arg_203_5 = {
			0,
			0,
			arg_203_5 or 0
		}
	end

	if arg_203_6 == "native" then
		local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_203_0).size

		arg_203_6 = {
			size[1],
			size[2]
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

UIWidgets.create_aligned_texture = function (arg_204_0, arg_204_1, arg_204_2, arg_204_3, arg_204_4, arg_204_5, arg_204_6, arg_204_7, arg_204_8, arg_204_9)
	-- function 204
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
		offset = not arg_204_9 and arg_204_9 and {
			0,
			0,
			arg_204_8 or 0
		},
		scenegraph_id = arg_204_4
	}
end

UIWidgets.create_simple_centered_texture_amount = function (arg_205_0, arg_205_1, arg_205_2, arg_205_3, arg_205_4, arg_205_5)
	-- function 205
	local tbl = {}
	local tbl_2 = {}

	for i = 1, arg_205_3 do
		tbl[i] = arg_205_0
		tbl_2[i] = arg_205_5 or {
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
			texture_id = tbl
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
				texture_colors = tbl_2,
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

UIWidgets.create_simple_multi_texture = function (arg_206_0, arg_206_1, arg_206_2, arg_206_3, arg_206_4, arg_206_5, arg_206_6, arg_206_7)
	-- function 206
	local tbl = {
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
		}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local count

	if not arg_206_0 then
		count = #arg_206_0

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_206_0::

	tbl_3.draw_count = count
	tbl_3.axis = arg_206_2 or 1
	tbl_3.spacing = arg_206_4 or {
		0,
		0
	}
	tbl_3.direction = arg_206_3 or 1
	tbl_3.texture_sizes = arg_206_1 or {}
	tbl_3.color = {
		255,
		255,
		255,
		255
	}
	tbl_3.offset = {
		0,
		0,
		0
	}
	tbl_3.masked = arg_206_6
	tbl_2.texture_id = tbl_3
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_206_5

	return tbl
end

UIWidgets.create_texture_with_style = function (arg_207_0, arg_207_1, arg_207_2)
	-- function 207
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

UIWidgets.create_simple_gradient_mask_texture = function (arg_208_0, arg_208_1, arg_208_2)
	-- function 208
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

UIWidgets.create_simple_rotated_texture = function (arg_209_0, arg_209_1, arg_209_2, arg_209_3, arg_209_4, arg_209_5, arg_209_6, arg_209_7, arg_209_8)
	-- function 209
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

UIWidgets.create_simple_uv_rotated_texture = function (arg_210_0, arg_210_1, arg_210_2, arg_210_3, arg_210_4, arg_210_5, arg_210_6, arg_210_7, arg_210_8, arg_210_9)
	-- function 210
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

UIWidgets.create_simple_uv_texture = function (arg_211_0, arg_211_1, arg_211_2, arg_211_3, arg_211_4, arg_211_5, arg_211_6, arg_211_7, arg_211_8)
	-- function 211
	if type(arg_211_6) ~= "table" then
		arg_211_6 = {
			0,
			0,
			arg_211_6 or 0
		}
	end

	if arg_211_8 == "native" then
		local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_211_0).size

		arg_211_8 = {
			size[1],
			size[2]
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

UIWidgets.create_simple_frame = function (arg_212_0, arg_212_1, arg_212_2, arg_212_3, arg_212_4, arg_212_5, arg_212_6)
	-- function 212
	local flag = arg_212_6 or {
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

	flag.texture_size = arg_212_1
	flag.texture_sizes = {
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
			texture_id = flag
		},
		scenegraph_id = arg_212_5
	}
end

UIWidgets.create_uv_texture_with_style = function (arg_213_0, arg_213_1, arg_213_2, arg_213_3)
	-- function 213
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

UIWidgets.create_simple_text = function (arg_214_0, arg_214_1, arg_214_2, arg_214_3, arg_214_4, arg_214_5, arg_214_6, arg_214_7)
	-- function 214
	local offset

	if not arg_214_4 then
		offset = arg_214_4.offset

		if not offset then
			-- Nothing
		end
	end

	offset = {
		0,
		0,
		2
	}

	do
		local text_color
	end

	::label_214_0::

	if not arg_214_4 then
		text_color = arg_214_4.text_color

		if not text_color then
			-- Nothing
		end
	end

	text_color = arg_214_3 or {
		255,
		255,
		255,
		255
	}

	::label_214_1::

	arg_214_4 = arg_214_4 or {
		vertical_alignment = "center",
		localize = true,
		horizontal_alignment = "center",
		word_wrap = true,
		font_size = arg_214_2,
		font_type = arg_214_5 or "hell_shark",
		text_color = text_color,
		offset = offset
	}

	local clone = table.clone(arg_214_4)
	local shadow_color = arg_214_4.shadow_color

	shadow_color = shadow_color or {
		255,
		0,
		0,
		0
	}

	local shadow_offset = arg_214_4.shadow_offset

	shadow_offset = shadow_offset or {
		2,
		2,
		0
	}
	shadow_color[1] = text_color[1]
	clone.text_color = shadow_color
	clone.offset = {
		offset[1] + shadow_offset[1],
		offset[2] - shadow_offset[2],
		offset[3] - 1
	}
	clone.skip_button_rendering = true

	local tbl = {
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
					content_check_function = function (self)
						-- function 215
						return self.use_shadow
					end,
					retained_mode = arg_214_6
				}
			}
		}
	}
	local tbl_2 = {
		text = arg_214_0,
		original_text = arg_214_0,
		color = text_color
	}
	local use_shadow

	if not arg_214_4 then
		use_shadow = arg_214_4.use_shadow

		if not use_shadow then
			-- Nothing
		end
	end

	use_shadow = false

	::label_214_2::

	tbl_2.use_shadow = use_shadow
	tbl_2.disable_with_gamepad = arg_214_7
	tbl.content = tbl_2
	tbl.style = {
		text = arg_214_4,
		text_shadow = clone
	}
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_214_1

	return tbl
end

UIWidgets.create_simple_text_tooltip = function (arg_216_0, arg_216_1, arg_216_2, arg_216_3, arg_216_4, arg_216_5, arg_216_6)
	-- function 216
	local tbl = {
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
					content_check_function = function (self)
						-- function 217
						return self.tooltip_hotspot.is_hover
					end
				}
			}
		}
	}
	local tbl_2 = {
		text = arg_216_0,
		tooltip_text = arg_216_1,
		tooltip_hotspot = {}
	}
	local text_color

	if not arg_216_5 then
		text_color = arg_216_5.text_color

		if not text_color then
			-- Nothing
		end
	end

	text_color = arg_216_4

	::label_216_0::

	tbl_2.color = text_color
	tbl.content = tbl_2
	tbl.style = {
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
	}
	tbl.scenegraph_id = arg_216_2

	return tbl
end

UIWidgets.create_simple_rect_text = function (arg_218_0, arg_218_1, arg_218_2, arg_218_3, arg_218_4, arg_218_5)
	-- function 218
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

UIWidgets.create_forge_toggle_button = function (arg_219_0, arg_219_1, arg_219_2, arg_219_3, arg_219_4, arg_219_5)
	-- function 219
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
					content_check_function = function (self)
						-- function 220
						return not not self.is_selected or not self.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 221
						return not not self.is_selected or self.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_selected_id",
					content_check_function = function (self)
						-- function 222
						local is_selected = self.is_selected

						is_selected = not is_selected and not self.button_hotspot.is_hover

						return is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_selected_hover_id",
					content_check_function = function (self)
						-- function 223
						local is_selected = self.is_selected

						is_selected = not is_selected and self.button_hotspot.is_hover

						return is_selected
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

UIWidgets.create_button_2_state = function (arg_224_0, arg_224_1, arg_224_2, arg_224_3)
	-- function 224
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
					content_check_function = function (self)
						-- function 225
						return not self.is_selected
					end
				},
				{
					pass_type = "texture",
					texture_id = "texture_selected_id",
					content_check_function = function (self)
						-- function 226
						return self.is_selected
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

UIWidgets.create_title_text = function (arg_227_0, arg_227_1)
	-- function 227
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

UIWidgets.create_matchmaking_portrait = function (self, arg_228_1)
	-- function 228
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
					content_check_function = function (self)
						-- function 229
						return not not self.is_connecting or self.is_connected
					end
				},
				{
					texture_id = "ready_icon",
					style_id = "ready_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 230
						local is_connected

						if not self.is_connecting then
							is_connected = self.is_connected

							if not is_connected then
								is_connected = self.is_ready
							end
						else
							is_connected = false
						end

						if false then
							is_connected = true
						end

						return is_connected
					end
				},
				{
					texture_id = "voted_yes_icon",
					style_id = "voted_yes_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 231
						local is_connected

						if not self.is_connecting then
							is_connected = self.is_connected

							if not is_connected then
								is_connected = self.is_voting

								if not is_connected then
									is_connected = self.voted_yes
								end
							end
						else
							is_connected = false
						end

						if false then
							is_connected = true
						end

						return is_connected
					end
				},
				{
					texture_id = "waiting_for_vote",
					style_id = "waiting_for_vote",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 232
						local is_connected

						if not self.is_connecting then
							is_connected = self.is_connected

							if not is_connected then
								is_connected = self.is_voting

								if not is_connected then
									is_connected = not self.voted_yes
								end
							end
						else
							is_connected = false
						end

						if false then
							is_connected = true
						end

						return is_connected
					end
				},
				{
					texture_id = "connecting_icon",
					style_id = "connecting_icon",
					pass_type = "rotated_texture",
					content_check_function = function (self)
						-- function 233
						return self.is_connecting
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
					self[1] / 2 - 18.5,
					self[2] / 2 - 15.5,
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
					self[1] / 2 - 18.5,
					self[2] / 2 - 15.5,
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
					self[1] / 2 - 18.5,
					self[2] / 2 - 15.5,
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
					self[1] / 2 - 15,
					self[2] / 2 - 15,
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

UIWidgets.create_small_trait_button = function (arg_234_0, arg_234_1, arg_234_2)
	-- function 234
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 235
						return not not self.disabled or not self.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_bg_id",
					texture_id = "texture_bg_id",
					content_check_function = function (self)
						-- function 236
						return self.use_background
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 237
						return self.texture_id
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 238
						local button_hotspot = self.button_hotspot
						local is_hover = button_hotspot.is_hover

						is_hover = not is_hover and not not button_hotspot.is_selected or not button_hotspot.disabled

						return is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_id",
					texture_id = "texture_selected_id",
					content_check_function = function (self)
						-- function 239
						local button_hotspot = self.button_hotspot
						local is_selected = button_hotspot.is_selected

						is_selected = not is_selected and not button_hotspot.disabled

						return is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_lock_id",
					texture_id = "texture_lock_id",
					content_check_function = function (self)
						-- function 240
						local button_hotspot = self.button_hotspot
						local locked = button_hotspot.locked

						locked = not locked and not button_hotspot.disabled

						return locked
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_glow_id",
					texture_id = "texture_glow_id",
					content_check_function = function (self)
						-- function 241
						return self.use_glow
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_trait_cover_id",
					texture_id = "texture_trait_cover_id",
					content_check_function = function (self)
						-- function 242
						local disabled = self.button_hotspot.disabled

						if not disabled then
							disabled = self.use_trait_cover
							disabled = not disabled and self.texture_id
						end

						return disabled
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

UIWidgets.create_small_reroll_trait_button = function (arg_243_0, arg_243_1)
	-- function 243
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 244
						return not not self.disabled or not self.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_bg_id",
					texture_id = "texture_bg_id",
					content_check_function = function (self)
						-- function 245
						return self.use_background
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_slot_id",
					texture_id = "texture_slot_id",
					content_check_function = function (self)
						-- function 246
						return self.use_background
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 247
						return self.texture_id
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 248
						local button_hotspot = self.button_hotspot
						local is_hover = button_hotspot.is_hover

						is_hover = not is_hover and not not button_hotspot.is_selected or not button_hotspot.disabled

						return is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_id",
					texture_id = "texture_selected_id",
					content_check_function = function (self)
						-- function 249
						local button_hotspot = self.button_hotspot
						local is_selected = button_hotspot.is_selected

						is_selected = not is_selected and not button_hotspot.disabled

						return is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_lock_id",
					texture_id = "texture_lock_id",
					content_check_function = function (self)
						-- function 250
						local locked = self.button_hotspot.locked

						locked = not locked and self.texture_id

						return locked
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_glow_id",
					texture_id = "texture_glow_id",
					content_check_function = function (self)
						-- function 251
						return self.use_glow
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

UIWidgets.create_attach_icon_button = function (arg_252_0, arg_252_1, arg_252_2, arg_252_3, arg_252_4, arg_252_5, arg_252_6)
	-- function 252
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 253
						return not self.disable_interaction
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function (self)
						-- function 254
						local icon_texture_id = self.icon_texture_id

						if not icon_texture_id then
							icon_texture_id = self.tooltip_enabled

							if not icon_texture_id then
								icon_texture_id = self.button_hotspot.is_hover
								icon_texture_id = not icon_texture_id and not self.button_hotspot.disable_interaction
							end
						end

						return icon_texture_id
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text_no_item",
					content_check_function = function (self)
						-- function 255
						local tooltip_enabled

						if not self.icon_texture_id then
							tooltip_enabled = self.tooltip_enabled

							if not tooltip_enabled then
								tooltip_enabled = self.button_hotspot.is_hover

								if not tooltip_enabled then
									tooltip_enabled = not self.button_hotspot.disable_interaction
								end
							end
						else
							tooltip_enabled = false
						end

						if false then
							tooltip_enabled = true
						end

						return tooltip_enabled
					end
				},
				{
					texture_id = "background_texture_id",
					style_id = "background_texture_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 256
						return self.background_texture_id
					end
				},
				{
					texture_id = "bg_overlay_texture_id",
					style_id = "bg_overlay_texture_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 257
						return self.bg_overlay_texture_id
					end
				},
				{
					texture_id = "icon_texture_id",
					style_id = "icon_texture_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 258
						return self.icon_texture_id
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_frame_texture_id",
					texture_id = "icon_frame_texture_id",
					content_check_function = function (self)
						-- function 259
						local icon_texture_id = self.icon_texture_id

						icon_texture_id = icon_texture_id or self.bg_overlay_texture_id

						return icon_texture_id
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
					content_check_function = function (self)
						-- function 260
						return not self.button_hotspot.disable_interaction
					end
				},
				{
					pass_type = "texture",
					style_id = "hover_texture",
					texture_id = "hover_texture",
					content_check_function = function (self)
						-- function 261
						local is_hover = self.button_hotspot.is_hover

						if not is_hover then
							is_hover = self.icon_texture_id
							is_hover = not is_hover and not self.is_dragging
						end

						return is_hover
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

UIWidgets.create_input_description_widgets = function (self, arg_262_1, arg_262_2)
	-- function 262
	local tbl = {}

	for i = 1, arg_262_2 do
		local str = "input_description_root_" .. i
		local str_2 = "input_description_" .. i
		local str_3 = "input_description_icon_" .. i
		local str_4 = "input_description_text_" .. i

		self[str] = {
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
		self[str_2] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str,
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
		self[str_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str_2,
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
		self[str_4] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str_3,
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

		local tbl_2 = {
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
					scenegraph_id = str_4
				},
				icon = {
					scenegraph_id = str_3
				}
			},
			scenegraph_id = str_2
		}

		tbl[#tbl + 1] = UIWidget.init(tbl_2)
	end

	return tbl
end

UIWidgets.create_hero_button = function (arg_263_0, arg_263_1, arg_263_2)
	-- function 263
	local str = "tabs_class_icon_" .. arg_263_0 .. "_normal"
	local str_2 = "tabs_class_icon_" .. arg_263_0 .. "_hover"
	local str_3 = "tabs_class_icon_" .. arg_263_0 .. "_selected"
	local var_263_3

	if arg_263_0 == "all_heroes" then
		str = nil
		str_2 = nil
		str_3 = nil
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
					content_check_function = function (self)
						-- function 264
						return not not self.button_hotspot.is_hover or not self.button_hotspot.is_selected
					end
				},
				{
					texture_id = "texture_hover_id",
					style_id = "texture_hover_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 265
						local is_hover = self.button_hotspot.is_hover

						is_hover = not is_hover and not self.button_hotspot.is_selected

						return is_hover
					end
				},
				{
					texture_id = "texture_selected_id",
					style_id = "texture_selected_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 266
						return self.button_hotspot.is_selected
					end
				},
				{
					texture_id = "hero_texture_normal_id",
					style_id = "hero_texture_normal_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 267
						local button_hotspot = self.button_hotspot
						local hero_texture_normal_id = self.hero_texture_normal_id

						hero_texture_normal_id = not hero_texture_normal_id and not not button_hotspot.is_hover or not button_hotspot.is_selected

						return hero_texture_normal_id
					end
				},
				{
					texture_id = "hero_texture_hover_id",
					style_id = "hero_texture_hover_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 268
						local hero_texture_hover_id = self.hero_texture_hover_id

						hero_texture_hover_id = not hero_texture_hover_id and self.button_hotspot.is_hover

						return hero_texture_hover_id
					end
				},
				{
					texture_id = "hero_texture_selected_id",
					style_id = "hero_texture_selected_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 269
						local hero_texture_selected_id = self.hero_texture_selected_id

						hero_texture_selected_id = not hero_texture_selected_id and self.button_hotspot.is_selected

						return hero_texture_selected_id
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 270
						return self.text
					end
				}
			}
		},
		content = {
			texture_id = "tab_normal",
			texture_hover_id = "tab_hover",
			texture_selected_id = "tab_selected",
			button_hotspot = {},
			hero_texture_normal_id = str,
			hero_texture_hover_id = str_2,
			hero_texture_selected_id = str_3,
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

UIWidgets.create_trait_button = function (arg_271_0, arg_271_1, arg_271_2, arg_271_3, arg_271_4)
	-- function 271
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
					content_check_function = function (self)
						-- function 272
						local owned = self.owned

						owned = not owned and not not self.button_hotspot.is_hover or not self.button_hotspot.is_selected

						return owned
					end
				},
				{
					texture_id = "trait_owned_hover",
					style_id = "trait_owned_hover",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 273
						local owned = self.owned

						if not owned then
							owned = self.button_hotspot.is_hover
							owned = not owned and not self.button_hotspot.is_selected
						end

						return owned
					end
				},
				{
					texture_id = "trait_owned_selected",
					style_id = "trait_owned_selected",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 274
						local owned = self.owned

						owned = not owned and self.button_hotspot.is_selected

						return owned
					end
				},
				{
					texture_id = "trait_purchase_normal",
					style_id = "trait_purchase_normal",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 275
						return not not self.button_hotspot.is_hover or not not self.button_hotspot.is_selected or not not self.owned or not self.locked
					end
				},
				{
					texture_id = "trait_purchase_hover",
					style_id = "trait_purchase_hover",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 276
						local is_hover = self.button_hotspot.is_hover

						is_hover = not is_hover and not not self.button_hotspot.is_selected and not not self.owned or not self.locked

						return is_hover
					end
				},
				{
					texture_id = "trait_purchase_selected",
					style_id = "trait_purchase_selected",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 277
						local is_selected = self.button_hotspot.is_selected

						is_selected = not is_selected and not not self.owned or not self.locked

						return is_selected
					end
				},
				{
					texture_id = "trait_locked_normal",
					style_id = "trait_locked_normal",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 278
						local locked = self.locked

						locked = not locked and not not self.button_hotspot.is_hover or not self.button_hotspot.is_selected

						return locked
					end
				},
				{
					texture_id = "trait_locked_hover",
					style_id = "trait_locked_hover",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 279
						local locked = self.locked

						if not locked then
							locked = self.button_hotspot.is_hover
							locked = not locked and not self.button_hotspot.is_selected
						end

						return locked
					end
				},
				{
					texture_id = "trait_locked_selected",
					style_id = "trait_locked_selected",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 280
						local locked = self.locked

						locked = not locked and self.button_hotspot.is_selected

						return locked
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

UIWidgets.create_scoreboard_topic_widget = function (arg_281_0)
	-- function 281
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
					click_function = function (arg_282_0, arg_282_1, arg_282_2, arg_282_3)
						-- function 282
						arg_282_2.button_hotspot.is_selected = true
					end
				},
				{
					texture_id = "texture_hover_id",
					style_id = "background_hover",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 283
						return not self.disabled
					end
				},
				{
					texture_id = "texture_select_id",
					style_id = "background_select",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 284
						return not self.disabled
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					content_id = "background",
					dynamic_function = function (self, arg_285_1, arg_285_2, arg_285_3)
						-- function 285
						local fraction = self.fraction
						local direction = self.direction
						local color = arg_285_1.color
						local uv_start_pixels = arg_285_1.uv_start_pixels
						local uv_scale_pixels = arg_285_1.uv_scale_pixels
						local num = uv_start_pixels + uv_scale_pixels * fraction
						local uvs = arg_285_1.uvs
						local scale_axis = arg_285_1.scale_axis

						if direction == 1 then
							uvs[1][scale_axis] = 0
							uvs[2][scale_axis] = num / (uv_start_pixels + uv_scale_pixels)
							arg_285_2[scale_axis] = num
							compact_topic_offset[scale_axis] = 0
						else
							uvs[2][scale_axis] = 1
							uvs[1][scale_axis] = 1 - num / (uv_start_pixels + uv_scale_pixels)
							arg_285_2[scale_axis] = num
							compact_topic_offset[scale_axis] = -(num - (uv_start_pixels + uv_scale_pixels))
						end

						return arg_285_1.color, uvs, arg_285_2, compact_topic_offset
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

UIWidgets.create_splash_video = function (self, arg_286_1)
	-- function 286
	return {
		element = {
			passes = {
				{
					style_id = "background",
					scenegraph_id = "background",
					pass_type = "rect",
					content_check_function = function (arg_287_0)
						-- function 287
						local resolution, var_287_1 = Gui.resolution()
						local num = resolution / var_287_1
						local num_2 = 1.7777777777777777
						local var_287_4 = var_287_1
						local var_287_5 = resolution

						if math.abs(num - num_2) > 0.005 then
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
				material_name = self.material_name
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
		scenegraph_id = self.scenegraph_id
	}
end

UIWidgets.create_video = function (arg_288_0, arg_288_1, arg_288_2)
	-- function 288
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

UIWidgets.create_fixed_aspect_video = function (arg_289_0, arg_289_1, arg_289_2)
	-- function 289
	return {
		element = {
			passes = {
				{
					style_id = "background",
					scenegraph_id = "background",
					pass_type = "rect",
					content_check_function = function (arg_290_0)
						-- function 290
						local resolution, var_290_1 = Gui.resolution()
						local num = resolution / var_290_1
						local num_2 = 1.7777777777777777
						local var_290_4 = var_290_1
						local var_290_5 = resolution

						if math.abs(num - num_2) > 0.005 then
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

UIWidgets.create_splash_texture = function (self)
	-- function 291
	local tbl = {
		element = {
			passes = {
				{
					style_id = "foreground",
					scenegraph_id = "foreground",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 292
						return self.foreground.disable_foreground ~= true
					end
				},
				{
					style_id = "background",
					scenegraph_id = "background",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 293
						return self.foreground.disable_background ~= true
					end
				},
				{
					texture_id = "material_name",
					style_id = "texture_style",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 294
						return self.material_name
					end
				},
				{
					style_id = "texts_style",
					pass_type = "multiple_texts",
					texts_id = "texts",
					scenegraph_id = self.texts_scenegraph_id,
					content_check_function = function (self)
						-- function 295
						return self.texts.texts ~= nil
					end
				}
			}
		},
		content = {
			texture_content = {
				material_name = self.material_name
			},
			texts = {
				texts = self.texts
			},
			foreground = {
				disable_foreground = self.disable_foreground
			}
		}
	}
	local tbl_2 = {
		foreground = {
			color = Colors.color_definitions.black
		},
		background = {
			color = Colors.color_definitions.black
		}
	}
	local tbl_3 = {
		size = self.texture_size
	}
	local texture_offset = self.texture_offset

	texture_offset = texture_offset or {
		0,
		0,
		0
	}
	tbl_3.offset = texture_offset
	tbl_2.texture_style = tbl_3
	tbl_2.texts_style = {
		scenegraph_id = "texts",
		text_color = Colors.color_definitions.white,
		font_size = self.font_size,
		dynamic_font = self.dynamic_font,
		pixel_perfect = self.pixel_perfect,
		font_type = self.font_type,
		localize = self.localize,
		horizontal_alignment = self.text_horizontal_alignment,
		vertical_alignment = self.text_vertical_alignment,
		spacing = self.spacing,
		size = self.size,
		axis = self.axis,
		direction = self.direction,
		offset = self.offset
	}
	tbl.style = tbl_2
	tbl.scenegraph_id = self.scenegraph_id

	return tbl
end

UIWidgets.create_loader_icon = function (arg_296_0)
	-- function 296
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

UIWidgets.create_partner_splash_widget = function (self)
	-- function 297
	return {
		element = {
			passes = {
				{
					style_id = "foreground",
					scenegraph_id = "foreground",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 298
						return self.foreground.disable_foreground ~= true
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
					scenegraph_id = self.texts_scenegraph_id,
					content_check_function = function (self)
						-- function 299
						return self.texts.texts ~= nil
					end
				},
				{
					texture_id = "material_name_1",
					style_id = "texture_style_1",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 300
						return self.material_name_1
					end
				},
				{
					texture_id = "material_name_2",
					style_id = "texture_style_2",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 301
						return self.material_name_2
					end
				},
				{
					texture_id = "material_name_3",
					style_id = "texture_style_3",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 302
						return self.material_name_3
					end
				},
				{
					texture_id = "material_name_4",
					style_id = "texture_style_4",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 303
						return self.material_name_4
					end
				},
				{
					texture_id = "material_name_5",
					style_id = "texture_style_5",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 304
						return self.material_name_5
					end
				},
				{
					texture_id = "material_name_6",
					style_id = "texture_style_6",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 305
						return self.material_name_6
					end
				},
				{
					texture_id = "material_name_7",
					style_id = "texture_style_7",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 306
						return self.material_name_7
					end
				},
				{
					texture_id = "material_name_8",
					style_id = "texture_style_8",
					pass_type = "texture",
					content_id = "texture_content",
					scenegraph_id = self.scenegraph_id,
					content_check_function = function (self)
						-- function 307
						return self.material_name_8
					end
				}
			}
		},
		content = {
			texture_content = {
				material_name_1 = self.texture_materials[1],
				material_name_2 = self.texture_materials[2],
				material_name_3 = self.texture_materials[3],
				material_name_4 = self.texture_materials[4],
				material_name_5 = self.texture_materials[5],
				material_name_6 = self.texture_materials[6],
				material_name_7 = self.texture_materials[7],
				material_name_8 = self.texture_materials[8]
			},
			texts = {
				texts = self.texts
			},
			foreground = {
				disable_foreground = self.disable_foreground
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
				scenegraph_id = self.texture_scenegraph_ids[1]
			},
			texture_style_2 = {
				scenegraph_id = self.texture_scenegraph_ids[2]
			},
			texture_style_3 = {
				scenegraph_id = self.texture_scenegraph_ids[3]
			},
			texture_style_4 = {
				scenegraph_id = self.texture_scenegraph_ids[4]
			},
			texture_style_5 = {
				scenegraph_id = self.texture_scenegraph_ids[5]
			},
			texture_style_6 = {
				scenegraph_id = self.texture_scenegraph_ids[6]
			},
			texture_style_7 = {
				scenegraph_id = self.texture_scenegraph_ids[7]
			},
			texture_style_8 = {
				scenegraph_id = self.texture_scenegraph_ids[8]
			},
			texts_style = {
				scenegraph_id = "texts",
				text_color = Colors.color_definitions.white,
				font_size = self.font_size,
				dynamic_font = self.dynamic_font,
				pixel_perfect = self.pixel_perfect,
				font_type = self.font_type,
				localize = self.localize,
				horizontal_alignment = self.text_horizontal_alignment,
				vertical_alignment = self.text_vertical_alignment,
				spacing = self.spacing,
				size = self.size,
				axis = self.axis,
				direction = self.direction,
				offset = self.offset
			}
		},
		scenegraph_id = self.scenegraph_id
	}
end

UIWidgets.create_map_player_entry = function (arg_308_0, arg_308_1)
	-- function 308
	local tbl = {
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
					content_check_function = function (self)
						-- function 309
						return self.is_host
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
					content_check_function = function (self)
						-- function 310
						return self.hero_icon_hotspot.is_hover
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
					content_check_function = function (self)
						-- function 311
						local always_show_icons

						if not self.is_host then
							always_show_icons = self.always_show_icons

							if not always_show_icons then
								always_show_icons = self.kick_enabled

								if not always_show_icons then
									always_show_icons = self.button_hotspot.is_hover

									if not always_show_icons then
										always_show_icons = not self.kick_button_hotspot.is_hover
									end
								end
							end
						else
							always_show_icons = false
						end

						if false then
							always_show_icons = true
						end

						return always_show_icons
					end
				},
				{
					pass_type = "texture",
					style_id = "kick_button_texture_hover",
					texture_id = "kick_button_texture",
					content_check_function = function (self)
						-- function 312
						local kick_enabled = self.kick_enabled

						if not kick_enabled then
							kick_enabled = self.button_hotspot.is_hover
							kick_enabled = not kick_enabled and self.kick_button_hotspot.is_hover
						end

						return kick_enabled
					end
				},
				{
					style_id = "kick_button_tooltip_text",
					pass_type = "tooltip_text",
					text_id = "kick_button_tooltip_text",
					content_check_function = function (self)
						-- function 313
						local kick_enabled = self.kick_enabled

						kick_enabled = not kick_enabled and self.kick_button_hotspot.is_hover

						return kick_enabled
					end
				},
				{
					pass_type = "texture",
					style_id = "hover_texture",
					texture_id = "hover_texture",
					content_check_function = function (self)
						-- function 314
						if not self.on_console then
							local is_selected = self.button_hotspot.is_selected

							is_selected = is_selected or self.button_hotspot.is_hover

							return is_selected
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "console_hover_texture",
					texture_id = "console_hover_texture",
					content_check_function = function (self)
						-- function 315
						if not self.on_console then
							local is_selected = self.button_hotspot.is_selected

							is_selected = is_selected or self.button_hotspot.is_hover

							return is_selected
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
		}
	}
	local tbl_2 = {}
	local tbl_3

	if not arg_308_1 then
		tbl_3 = {
			texture_size = {
				30,
				30
			},
			scenegraph_id = arg_308_1
		}

		if not tbl_3 then
			-- Nothing
		end
	end

	tbl_3 = nil

	::label_308_0::

	tbl_2.gamepad_selection = tbl_3
	tbl_2.text = {
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
	}
	tbl_2.hero_icon = {
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
	}
	tbl_2.host_icon = {
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
	}
	tbl_2.hero_icon_tooltip_text = {
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
	}
	tbl_2.console_hover_texture = {
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
	}
	tbl_2.hover_texture = {
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
	}
	tbl_2.kick_button_texture = {
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
	}
	tbl_2.kick_button_texture_hover = {
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
	}
	tbl_2.kick_button_tooltip_text = {
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
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_308_0

	return tbl
end

UIWidgets.create_map_settings_stepper = function (arg_316_0, arg_316_1)
	-- function 316
	local tbl = {
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
					content_check_function = function (self)
						-- function 317
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.gamepad_active then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								-- Nothing
							end
						end

						is_selected = button_hotspot.is_hover

						::label_317_0::

						return is_selected
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
					content_check_function = function (self)
						-- function 318
						local button_hotspot = self.button_hotspot

						if not button_hotspot.gamepad_active then
							return button_hotspot.is_selected
						else
							return true
						end
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "right_button_texture",
					texture_id = "right_button_texture",
					content_check_function = function (self)
						-- function 319
						local button_hotspot = self.button_hotspot

						if not button_hotspot.gamepad_active then
							return button_hotspot.is_selected
						else
							return true
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "left_button_texture_clicked",
					texture_id = "left_button_texture_clicked",
					content_check_function = function (self)
						-- function 320
						local button_hotspot = self.button_hotspot

						if not button_hotspot.gamepad_active then
							return button_hotspot.is_selected
						else
							return true
						end
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "right_button_texture_clicked",
					texture_id = "right_button_texture_clicked",
					content_check_function = function (self)
						-- function 321
						local button_hotspot = self.button_hotspot

						if not button_hotspot.gamepad_active then
							return button_hotspot.is_selected
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
		}
	}
	local tbl_2 = {}
	local tbl_3

	if not arg_316_1 then
		tbl_3 = {
			texture_size = {
				40,
				40
			},
			scenegraph_id = arg_316_1
		}

		if not tbl_3 then
			-- Nothing
		end
	end

	tbl_3 = nil

	::label_316_0::

	tbl_2.gamepad_selection = tbl_3
	tbl_2.hover_texture = {
		size = {
			410,
			50
		},
		offset = {
			-55,
			-8,
			0
		}
	}
	tbl_2.left_button_texture = {
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
	}
	tbl_2.right_button_texture = {
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
	}
	tbl_2.left_button_texture_clicked = {
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
	}
	tbl_2.right_button_texture_clicked = {
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
	}
	tbl_2.setting_text = {
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
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_316_0

	return tbl
end

UIWidgets.create_default_stepper = function (arg_322_0, arg_322_1)
	-- function 322
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

UIWidgets.create_checkbox_widget = function (arg_323_0, arg_323_1, arg_323_2, arg_323_3, arg_323_4, arg_323_5)
	-- function 323
	local menu_frame_06 = UIFrameSettings.menu_frame_06

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
					content_check_function = function (self)
						-- function 324
						local is_hover = self.button_hotspot.is_hover

						is_hover = not is_hover and self.tooltip_text == "" or not self.is_disabled

						return is_hover
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text_disabled",
					content_check_function = function (self)
						-- function 325
						local is_hover = self.button_hotspot.is_hover

						is_hover = not is_hover and self.tooltip_text_disabled == "" or self.is_disabled

						return is_hover
					end
				},
				{
					style_id = "setting_text",
					pass_type = "text",
					text_id = "setting_text",
					content_check_function = function (self)
						-- function 326
						return not not self.button_hotspot.is_hover or not self.is_disabled
					end
				},
				{
					style_id = "setting_text_disabled",
					pass_type = "text",
					text_id = "setting_text",
					content_check_function = function (self)
						-- function 327
						return self.is_disabled
					end
				},
				{
					style_id = "setting_text_hover",
					pass_type = "text",
					text_id = "setting_text",
					content_check_function = function (self)
						-- function 328
						local is_hover = self.button_hotspot.is_hover

						is_hover = not is_hover and not self.is_disabled

						return is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "checkbox_marker",
					texture_id = "checkbox_marker",
					content_check_function = function (self)
						-- function 329
						local checked = self.checked

						checked = not checked and not self.is_disabled

						return checked
					end
				},
				{
					pass_type = "texture",
					style_id = "checkbox_marker_disabled",
					texture_id = "checkbox_marker",
					content_check_function = function (self)
						-- function 330
						local checked = self.checked

						checked = not checked and self.is_disabled

						return checked
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
					content_check_function = function (self)
						-- function 331
						return not self.is_disabled
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "checkbox_frame_disabled",
					texture_id = "checkbox_frame",
					content_check_function = function (self)
						-- function 332
						return self.is_disabled
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
			checkbox_frame = menu_frame_06.texture
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
				texture_size = menu_frame_06.texture_size,
				texture_sizes = menu_frame_06.texture_sizes,
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
				texture_size = menu_frame_06.texture_size,
				texture_sizes = menu_frame_06.texture_sizes,
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

UIWidgets.create_story_level_map_widget = function (arg_333_0, arg_333_1, arg_333_2)
	-- function 333
	local show_debug_levels = UISettings.map.show_debug_levels
	local tbl = {}
	local num = 0
	local tbl_2 = {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "on_click",
					click_check_content_id = "button_hotspot",
					click_function = function (arg_334_0, arg_334_1, arg_334_2, arg_334_3)
						-- function 334
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
		widget = UIWidget.init(tbl_2)
	}
end

UIWidgets.create_text_button = function (arg_335_0, arg_335_1, arg_335_2, arg_335_3, arg_335_4, arg_335_5)
	-- function 335
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
					content_check_function = function (self)
						-- function 336
						local is_hover

						if not self.button_text.disable_button then
							is_hover = self.button_text.is_hover

							if not is_hover then
								is_hover = self.button_text.is_selected
							end
						else
							is_hover = false
						end

						if false then
							is_hover = true
						end

						return is_hover
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 337
						return not not self.button_text.disable_button or not not self.button_text.is_hover or not self.button_text.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 338
						return self.button_text.disable_button
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

UIWidgets.create_console_panel_button = function (arg_339_0, arg_339_1, arg_339_2, arg_339_3, arg_339_4, arg_339_5, arg_339_6)
	-- function 339
	local tbl = {
		-19,
		-25,
		10
	}
	local tbl_2 = {
		0,
		0,
		1
	}
	local tbl_3 = {
		0,
		-4,
		0
	}
	local tbl_4 = {
		2,
		3,
		3
	}

	if not arg_339_4 then
		tbl_4[1] = tbl_4[1] + arg_339_4[1]
		tbl_4[2] = tbl_4[2] + arg_339_4[2]
		tbl_4[3] = arg_339_4[3] - 1
		tbl_3[1] = tbl_3[1] + arg_339_4[1]
		tbl_3[2] = tbl_3[2] + arg_339_4[2]
		tbl_3[3] = arg_339_4[3] - 3
		tbl_2[1] = tbl_2[1] + arg_339_4[1]
		tbl_2[2] = tbl_2[2] + arg_339_4[2]
		tbl_2[3] = arg_339_4[3] - 2
		tbl[1] = tbl[1] + arg_339_4[1]
		tbl[2] = tbl[2] + arg_339_4[2]
		tbl[3] = arg_339_4[3] - 2
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
					content_check_function = function (self)
						-- function 340
						local is_hover

						if not self.button_hotspot.disable_button then
							is_hover = self.button_hotspot.is_hover

							if not is_hover then
								is_hover = self.button_hotspot.is_selected
							end
						else
							is_hover = false
						end

						if false then
							is_hover = true
						end

						return is_hover
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 341
						return not not self.button_hotspot.disable_button or not not self.button_hotspot.is_hover or not self.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 342
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "selected_texture",
					style_id = "selected_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 343
						return not self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 344
						return self.new
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
				default_offset = tbl_4,
				offset = tbl_4,
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
				offset = tbl_3
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
					tbl_2[1] - 27.5,
					tbl_2[2],
					tbl_2[3]
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
					tbl_2[1] + 27.5,
					tbl_2[2],
					tbl_2[3]
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
					tbl[1],
					tbl[2],
					tbl[3]
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

UIWidgets.create_compare_menu_trait_widget = function (arg_345_0, arg_345_1, arg_345_2, arg_345_3)
	-- function 345
	local tbl = {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_bg_id",
					texture_id = "texture_bg_id",
					content_check_function = function (self)
						-- function 346
						return self.use_background
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 347
						return self.texture_id
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_lock_id",
					texture_id = "texture_lock_id",
					content_check_function = function (self)
						-- function 348
						local locked = self.locked

						locked = not locked and not self.disabled

						return locked
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_glow_id",
					texture_id = "texture_glow_id",
					content_check_function = function (self)
						-- function 349
						return self.use_glow
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
					content_check_function = function (self)
						-- function 350
						return self.use_divider
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
		}
	}
	local tbl_2 = {
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
		}
	}
	local tbl_3 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		localize = false,
		font_size = 20
	}
	local flag

	flag = not arg_345_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
	tbl_3.offset = {
		55,
		0,
		1
	}
	tbl_2.title_text = tbl_3

	local tbl_4 = {
		word_wrap = true,
		localize = false,
		font_size = 18,
		horizontal_alignment = "left",
		vertical_alignment = "top"
	}
	local flag_2

	flag_2 = not arg_345_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_4.offset = {
		0,
		0,
		0
	}
	tbl_4.scenegraph_id = arg_345_1
	tbl_2.description_text = tbl_4
	tbl_2.texture_bg_id = {
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
	}
	tbl_2.texture_id = {
		masked = arg_345_2,
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_2.texture_lock_id = {
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
	}
	tbl_2.texture_glow_id = {
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
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_345_0

	return tbl
end

UIWidgets.create_journal_tab = function (arg_351_0, arg_351_1, arg_351_2)
	-- function 351
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
					content_check_function = function (self)
						-- function 352
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disabled or button_hotspot.is_hover
					end
				},
				{
					texture_id = "texture_selected_id",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 353
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disabled or button_hotspot.is_clicked == 0 or button_hotspot.is_selected
					end
				},
				{
					texture_id = "new_texture_id",
					style_id = "new_texture_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 354
						return self.new
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

UIWidgets.create_journal_page_arrow_button = function (arg_355_0, arg_355_1, arg_355_2)
	-- function 355
	local var_355_0
	local tbl = {
		texture_hover_id = "journal_arrow_01",
		texture_selected_id = "journal_arrow_01_clicked",
		texture_id = "journal_arrow_01",
		button_hotspot = {}
	}

	if not arg_355_1 then
		var_355_0 = {
			{
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				texture_id = "texture_id",
				style_id = "texture_id",
				pass_type = "texture_uv",
				content_check_function = function (self)
					-- function 356
					local button_hotspot = self.button_hotspot

					return (not not button_hotspot.disabled or not not button_hotspot.is_hover or not button_hotspot.is_clicked) and button_hotspot.is_clicked ~= 0
				end
			},
			{
				texture_id = "texture_hover_id",
				style_id = "texture_hover_id",
				pass_type = "texture_uv",
				content_check_function = function (self)
					-- function 357
					local button_hotspot = self.button_hotspot
					local is_hover

					if not button_hotspot.disabled then
						is_hover = button_hotspot.is_hover

						if not is_hover then
							-- Nothing
						end

						if not (not button_hotspot.is_clicked and button_hotspot.is_clicked ~= 0) then
							-- Nothing
						end
					end

					is_hover = false

					goto label_357_1

					::label_357_0::

					is_hover = true

					::label_357_1::

					return is_hover
				end
			},
			{
				texture_id = "texture_selected_id",
				style_id = "texture_selected_id",
				pass_type = "texture_uv",
				content_check_function = function (self)
					-- function 358
					local button_hotspot = self.button_hotspot

					return not not button_hotspot.disabled or button_hotspot.is_clicked == 0 or button_hotspot.is_selected
				end
			}
		}
		tbl.uvs = arg_355_1
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
				content_check_function = function (self)
					-- function 359
					local button_hotspot = self.button_hotspot

					return (not not button_hotspot.disabled or not not button_hotspot.is_hover or not button_hotspot.is_clicked) and button_hotspot.is_clicked ~= 0
				end
			},
			{
				texture_id = "texture_hover_id",
				style_id = "texture_hover_id",
				pass_type = "texture",
				content_check_function = function (self)
					-- function 360
					local button_hotspot = self.button_hotspot
					local is_hover

					if not button_hotspot.disabled then
						is_hover = button_hotspot.is_hover

						if not is_hover then
							-- Nothing
						end

						if not (not button_hotspot.is_clicked and button_hotspot.is_clicked ~= 0) then
							-- Nothing
						end
					end

					is_hover = false

					goto label_360_1

					::label_360_0::

					is_hover = true

					::label_360_1::

					return is_hover
				end
			},
			{
				texture_id = "texture_selected_id",
				style_id = "texture_selected_id",
				pass_type = "texture",
				content_check_function = function (self)
					-- function 361
					local button_hotspot = self.button_hotspot

					return not not button_hotspot.disabled or button_hotspot.is_clicked == 0 or button_hotspot.is_selected
				end
			}
		}
	end

	return {
		element = {
			passes = var_355_0
		},
		content = tbl,
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

UIWidgets.create_journal_back_arrow_button = function (arg_362_0, arg_362_1)
	-- function 362
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
					content_check_function = function (self)
						-- function 363
						local button_hotspot = self.button_hotspot

						return (not not button_hotspot.disabled or not not button_hotspot.is_hover or not button_hotspot.is_clicked) and button_hotspot.is_clicked ~= 0
					end
				},
				{
					texture_id = "texture_hover_id",
					style_id = "texture_hover_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 364
						local button_hotspot = self.button_hotspot
						local is_hover

						if not button_hotspot.disabled then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								-- Nothing
							end

							if not (not button_hotspot.is_clicked and button_hotspot.is_clicked ~= 0) then
								-- Nothing
							end
						end

						is_hover = false

						goto label_364_1

						::label_364_0::

						is_hover = true

						::label_364_1::

						return is_hover
					end
				},
				{
					texture_id = "texture_selected_id",
					style_id = "texture_selected_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 365
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disabled or button_hotspot.is_clicked == 0 or button_hotspot.is_selected
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

UIWidgets.create_journal_reveal_mask = function (self, arg_366_1, arg_366_2)
	-- function 366
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local count = #self

	for i = 1, count + 1 do
		if not (i == count + 1) then
			local str = "cover_rect"

			tbl[i] = {
				pass_type = "texture",
				texture_id = str,
				style_id = str
			}
			tbl_2[str] = "mask_rect"
			tbl_3[str] = {
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
			local str_2 = "texture_" .. i
			local var_366_6 = arg_366_1[i]

			tbl[i] = {
				pass_type = "texture",
				style_id = str_2,
				texture_id = str_2
			}
			tbl_3[str_2] = {
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
			tbl_2[str_2] = self[i]
		end
	end

	tbl_2.num_textures = count

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_3,
		scenegraph_id = arg_366_2
	}
end

UIWidgets.create_gamepad_selection = function (arg_367_0, arg_367_1, arg_367_2, arg_367_3)
	-- function 367
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

UIWidgets.create_simple_atlas_texture = function (arg_368_0, arg_368_1, arg_368_2, arg_368_3, arg_368_4, arg_368_5, arg_368_6, arg_368_7)
	-- function 368
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_368_0)

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
				texture_size = get_atlas_settings_by_texture_name.size,
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
