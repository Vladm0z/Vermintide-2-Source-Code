-- chunkname: @scripts/ui/gift_popup/gift_popup_ui_definitions.lua

local num = 1920
local num_2 = 1080
local var_0_2
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
			UILayer.item_display_popup
		}
	},
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.item_display_popup
		}
	},
	menu_root = {
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
	popup_bg_parent = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			715,
			958
		},
		position = {
			0,
			60,
			2
		}
	},
	popup_bg = {
		vertical_alignment = "center",
		parent = "popup_bg_parent",
		horizontal_alignment = "center",
		size = {
			715,
			958
		},
		position = {
			0,
			-10,
			0
		}
	},
	claim_button = {
		vertical_alignment = "bottom",
		parent = "popup_bg_parent",
		horizontal_alignment = "center",
		size = {
			454,
			83
		},
		position = {
			0,
			45,
			2
		}
	},
	button_glow = {
		vertical_alignment = "center",
		parent = "claim_button",
		horizontal_alignment = "center",
		size = {
			454,
			83
		},
		position = {
			0,
			0,
			8
		}
	},
	thumb_widgets_pivot = {
		vertical_alignment = "center",
		parent = "claim_button",
		horizontal_alignment = "center",
		size = {
			64,
			64
		},
		position = {
			0,
			85,
			2
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "popup_bg_parent",
		horizontal_alignment = "center",
		size = {
			560,
			80
		},
		position = {
			0,
			-120,
			0
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "popup_bg_parent",
		horizontal_alignment = "center",
		size = {
			560,
			80
		},
		position = {
			0,
			-155,
			0
		}
	},
	reward_name_text = {
		vertical_alignment = "bottom",
		parent = "popup_bg_parent",
		horizontal_alignment = "center",
		size = {
			560,
			50
		},
		position = {
			0,
			260,
			1
		}
	},
	reward_type_text = {
		vertical_alignment = "bottom",
		parent = "popup_bg_parent",
		horizontal_alignment = "center",
		size = {
			560,
			50
		},
		position = {
			0,
			230,
			3
		}
	},
	divider = {
		vertical_alignment = "bottom",
		parent = "popup_bg_parent",
		horizontal_alignment = "center",
		size = {
			379,
			8
		},
		position = {
			0,
			200,
			1
		}
	},
	hero_icon = {
		vertical_alignment = "center",
		parent = "reward_type_text",
		horizontal_alignment = "center",
		size = {
			46,
			46
		},
		position = {
			0,
			-30,
			-1
		}
	},
	hero_icon_tooltip = {
		vertical_alignment = "center",
		parent = "reward_type_text",
		horizontal_alignment = "center",
		size = {
			46,
			46
		},
		position = {
			0,
			-30,
			-1
		}
	}
}

local function fn()
	-- function 1
	return {
		scenegraph_id = "thumb_widgets_pivot",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "icon_glow",
					texture_id = "icon_glow"
				},
				{
					pass_type = "texture",
					style_id = "icon_frame",
					texture_id = "icon_frame",
					content_check_function = function (self)
						-- function 2
						return self.draw_frame
					end
				},
				{
					pass_type = "texture",
					style_id = "selection",
					texture_id = "selection",
					content_check_function = function (self)
						-- function 3
						return self.selected
					end
				}
			}
		},
		content = {
			first_time = true,
			selection = "popup_icon_selection",
			icon_frame = "frame_01",
			selected = false,
			icon = "icons_placeholder",
			draw_frame = true,
			icon_glow = "popup_icon_glow",
			button_hotspot = {}
		},
		style = {
			icon_glow = {
				size = {
					128,
					128
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-33.5,
					-33.5,
					0
				}
			},
			icon = {
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
			icon_frame = {
				color = {
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
			},
			selection = {
				size = {
					128,
					128
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-33.5,
					-33.5,
					3
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local tbl_2 = {
	font_size = 24,
	max_width = 500,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	line_colors = {},
	offset = {
		0,
		0,
		3
	}
}
local tbl_3 = {
	hero_icon = UIWidgets.create_simple_texture("hero_icon_medium_dwarf_ranger_yellow", "hero_icon"),
	hero_icon_tooltip = UIWidgets.create_simple_tooltip("", "hero_icon_tooltip", nil, tbl_2),
	title_text = UIWidgets.create_simple_text("Summer Solstice!", "title_text", 56, Colors.get_color_table_with_alpha("cheeseburger", 255), nil, "hell_shark_header"),
	description_text = UIWidgets.create_simple_text("Holiday Bonus Rewards", "description_text", 28, Colors.get_color_table_with_alpha("white", 255), nil, "hell_shark_header"),
	reward_name_text = UIWidgets.create_simple_text("", "reward_name_text", 28, Colors.get_color_table_with_alpha("cheeseburger", 255)),
	reward_type_text = UIWidgets.create_simple_text("", "reward_type_text", 24, Colors.get_color_table_with_alpha("white", 255)),
	button_glow = UIWidgets.create_simple_texture("popup_button_glow", "button_glow"),
	divider = UIWidgets.create_simple_texture("popup_divider", "divider"),
	popup_bg = UIWidgets.create_simple_texture("reward_popup_bg", "popup_bg"),
	claim_button = UIWidgets.create_popup_button_long("gift_popup_button_text", "claim_button"),
	close_button = UIWidgets.create_popup_button_long("close", "claim_button"),
	background = UIWidgets.create_simple_rect("screen", {
		255,
		0,
		0,
		0
	})
}
local tbl_4 = {
	default = {
		{
			input_action = "confirm",
			priority = 4,
			description_text = "input_description_select"
		}
	},
	selection = {
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_close"
		}
	}
}
local tbl_5 = {
	chest_unit_spawn = {
		{
			name = "rotation",
			start_progress = 0,
			end_progress = 0.7,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_2.popup_bg.style.texture_id.color[1] = 0

				local chest_unit = arg_4_3.chest_unit

				arg_4_3.rotation_value = 0
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local chest_unit = arg_5_4.chest_unit

				if not chest_unit and not Unit.alive(chest_unit) then
					local num = math.easeCubic(arg_5_3) * 720
					local degrees_to_radians = math.degrees_to_radians(num)
					local axis_angle = Quaternion.axis_angle(Vector3(0, 0, 1), degrees_to_radians)

					Unit.set_local_rotation(chest_unit, 0, axis_angle)
				end
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		},
		{
			name = "scale",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				local chest_unit = arg_7_3.chest_unit

				if not chest_unit and not Unit.alive(chest_unit) then
					local box, var_7_2 = Unit.box(chest_unit)

					if not var_7_2 then
						local num = 0.15
						local num_2 = 0

						if num_2 < var_7_2.x then
							num_2 = var_7_2.x
						end

						if num_2 < var_7_2.z then
							num_2 = var_7_2.z
						end

						if num_2 < var_7_2.y then
							num_2 = var_7_2.y
						end

						if num < num_2 then
							local num_3 = 1 - (num_2 - num) / num_2
							local var_7_6 = Vector3(0, 0, 0)

							Unit.set_local_scale(chest_unit, 0, var_7_6)

							arg_7_3.end_scale_fraction = num_3
						end
					end
				end
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local chest_unit = arg_8_4.chest_unit

				if not chest_unit and not Unit.alive(chest_unit) then
					local easeCubic = math.easeCubic(arg_8_3)
					local end_scale_fraction = arg_8_4.end_scale_fraction

					end_scale_fraction = end_scale_fraction or 0.15

					local num = end_scale_fraction * easeCubic
					local var_8_4 = Vector3(num, num, num)

					if arg_8_3 == 1 then
						print("scale_fraction", num)
					end

					Unit.set_local_scale(chest_unit, 0, var_8_4)
				end
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "position",
			start_progress = 0.01,
			end_progress = 0.7,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local chest_unit = arg_11_4.chest_unit

				if not chest_unit and not Unit.alive(chest_unit) then
					local easeCubic = math.easeCubic(arg_11_3)
					local reward_viewport = arg_11_4.reward_viewport
					local camera = ScriptViewport.camera(reward_viewport)
					local rotation = ScriptCamera.rotation(camera)
					local num = ScriptCamera.position(camera) + Quaternion.forward(rotation)

					num.z = num.z - 0.3 + 0.29 * easeCubic

					local box, var_11_7 = Unit.box(chest_unit)
					local num_2 = Matrix4x4.translation(box) - Unit.world_position(chest_unit, 0)
					local end_scale_fraction = arg_11_4.end_scale_fraction

					end_scale_fraction = end_scale_fraction or 0

					local num_3 = num - num_2 * end_scale_fraction

					Unit.set_local_position(chest_unit, 0, num_3)
				end
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		},
		{
			name = "bg_fade_in",
			start_progress = 0.6,
			end_progress = 1,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local easeInCubic = math.easeInCubic(arg_14_3)
				local divider = arg_14_2.divider
				local popup_bg = arg_14_2.popup_bg
				local title_text = arg_14_2.title_text
				local description_text = arg_14_2.description_text
				local num = 255 * easeInCubic

				divider.style.texture_id.color[1] = num
				popup_bg.style.texture_id.color[1] = num
				title_text.style.text.text_color[1] = num
				description_text.style.text.text_color[1] = num
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		},
		{
			name = "button_fade_in",
			start_progress = 1.4,
			end_progress = 1.71,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local num = 255 * math.easeInCubic(arg_17_3)
				local claim_button = arg_17_2.claim_button

				claim_button.style.texture.color[1] = num
				claim_button.style.text.text_color[1] = num
				claim_button.style.text_hover.text_color[1] = num
				claim_button.style.text_selected.text_color[1] = num
				claim_button.style.text_disabled.text_color[1] = num
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end
		},
		{
			name = "animation_fall",
			start_progress = 0.65,
			end_progress = 0.71,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				return
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				local chest_unit = arg_21_3.chest_unit

				if not chest_unit and not Unit.alive(chest_unit) then
					Unit.flow_event(chest_unit, "loot_chest_fall")
				end
			end
		},
		{
			name = "chest_land",
			start_progress = 0.71,
			end_progress = 1,
			init = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				return
			end,
			update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				-- function 23
				return
			end,
			on_complete = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				WwiseWorld.trigger_event(arg_24_3.wwise_world, "hud_reward_chest_land")
			end
		},
		{
			name = "animation_fall_xxx",
			start_progress = 0.71,
			end_progress = 1.71,
			init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				return
			end,
			update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				-- function 26
				return
			end,
			on_complete = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end
		}
	},
	chest_unit_open = {
		{
			name = "animation_open",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				local chest_unit = arg_28_3.chest_unit

				if not chest_unit and not Unit.alive(chest_unit) then
					Unit.flow_event(chest_unit, "loot_chest_open")
				end
			end,
			update = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				-- function 29
				return
			end,
			on_complete = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end
		},
		{
			name = "scale",
			start_progress = 1.1,
			end_progress = 1.25,
			init = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				local chest_unit = arg_31_3.chest_unit

				if not chest_unit and not Unit.alive(chest_unit) then
					local box, var_31_2 = Unit.box(chest_unit)

					if not var_31_2 then
						local num = 0.1
						local num_2 = 0

						if num_2 < var_31_2.x then
							num_2 = var_31_2.x
						end

						if num_2 < var_31_2.z then
							num_2 = var_31_2.z
						end

						if num_2 < var_31_2.y then
							num_2 = var_31_2.y
						end

						if num < num_2 then
							arg_31_3.end_scale_fraction = 1 - (num_2 - num) / num_2
						end
					end
				end
			end,
			update = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				-- function 32
				local chest_unit = arg_32_4.chest_unit

				if not chest_unit and not Unit.alive(chest_unit) then
					local num = 1 - math.easeOutCubic(arg_32_3)
					local end_scale_fraction = arg_32_4.end_scale_fraction

					end_scale_fraction = end_scale_fraction or 0.1

					local num_2 = end_scale_fraction * num
					local var_32_4 = Vector3(num_2, num_2, num_2)

					Unit.set_local_scale(chest_unit, 0, var_32_4)
				end
			end,
			on_complete = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				return
			end
		}
	},
	thumbs_fade_in = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end,
			update = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				-- function 35
				local thumb_widgets = arg_35_2.thumb_widgets

				for i, v in ipairs(thumb_widgets) do
					-- Nothing
				end
			end,
			on_complete = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				return
			end
		}
	}
}

return {
	widget_definitions = tbl_3,
	scenegraph_definition = tbl,
	animation_definitions = tbl_5,
	generic_input_actions = tbl_4,
	create_reward_thumb_widget = fn
}
