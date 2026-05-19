-- chunkname: @scripts/ui/gift_popup/gift_popup_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2
local var_0_3 = {
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

local function var_0_4()
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
					content_check_function = function(arg_2_0)
						return arg_2_0.draw_frame
					end
				},
				{
					pass_type = "texture",
					style_id = "selection",
					texture_id = "selection",
					content_check_function = function(arg_3_0)
						return arg_3_0.selected
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

local var_0_5 = {
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
local var_0_6 = {
	hero_icon = UIWidgets.create_simple_texture("hero_icon_medium_dwarf_ranger_yellow", "hero_icon"),
	hero_icon_tooltip = UIWidgets.create_simple_tooltip("", "hero_icon_tooltip", nil, var_0_5),
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
local var_0_7 = {
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
local var_0_8 = {
	chest_unit_spawn = {
		{
			name = "rotation",
			start_progress = 0,
			end_progress = 0.7,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_2.popup_bg.style.texture_id.color[1] = 0

				local var_4_0 = arg_4_3.chest_unit

				arg_4_3.rotation_value = 0
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = arg_5_4.chest_unit

				if var_5_0 and Unit.alive(var_5_0) then
					local var_5_1 = math.easeCubic(arg_5_3) * 720
					local var_5_2 = math.degrees_to_radians(var_5_1)
					local var_5_3 = Quaternion.axis_angle(Vector3(0, 0, 1), var_5_2)

					Unit.set_local_rotation(var_5_0, 0, var_5_3)
				end
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		},
		{
			name = "scale",
			start_progress = 0,
			end_progress = 0.25,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				local var_7_0 = arg_7_3.chest_unit

				if var_7_0 and Unit.alive(var_7_0) then
					local var_7_1, var_7_2 = Unit.box(var_7_0)

					if var_7_2 then
						local var_7_3 = 0.15
						local var_7_4 = 0

						if var_7_4 < var_7_2.x then
							var_7_4 = var_7_2.x
						end

						if var_7_4 < var_7_2.z then
							var_7_4 = var_7_2.z
						end

						if var_7_4 < var_7_2.y then
							var_7_4 = var_7_2.y
						end

						if var_7_3 < var_7_4 then
							local var_7_5 = 1 - (var_7_4 - var_7_3) / var_7_4
							local var_7_6 = Vector3(0, 0, 0)

							Unit.set_local_scale(var_7_0, 0, var_7_6)

							arg_7_3.end_scale_fraction = var_7_5
						end
					end
				end
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = arg_8_4.chest_unit

				if var_8_0 and Unit.alive(var_8_0) then
					local var_8_1 = math.easeCubic(arg_8_3)
					local var_8_2 = (arg_8_4.end_scale_fraction or 0.15) * var_8_1
					local var_8_3 = Vector3(var_8_2, var_8_2, var_8_2)

					if arg_8_3 == 1 then
						print("scale_fraction", var_8_2)
					end

					Unit.set_local_scale(var_8_0, 0, var_8_3)
				end
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		},
		{
			name = "position",
			start_progress = 0.01,
			end_progress = 0.7,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = arg_11_4.chest_unit

				if var_11_0 and Unit.alive(var_11_0) then
					local var_11_1 = math.easeCubic(arg_11_3)
					local var_11_2 = arg_11_4.reward_viewport
					local var_11_3 = ScriptViewport.camera(var_11_2)
					local var_11_4 = ScriptCamera.rotation(var_11_3)
					local var_11_5 = ScriptCamera.position(var_11_3) + Quaternion.forward(var_11_4)

					var_11_5.z = var_11_5.z - 0.3 + 0.29 * var_11_1

					local var_11_6, var_11_7 = Unit.box(var_11_0)
					local var_11_8 = var_11_5 - (Matrix4x4.translation(var_11_6) - Unit.world_position(var_11_0, 0)) * (arg_11_4.end_scale_fraction or 0)

					Unit.set_local_position(var_11_0, 0, var_11_8)
				end
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		},
		{
			name = "bg_fade_in",
			start_progress = 0.6,
			end_progress = 1,
			init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end,
			update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = math.easeInCubic(arg_14_3)
				local var_14_1 = arg_14_2.divider
				local var_14_2 = arg_14_2.popup_bg
				local var_14_3 = arg_14_2.title_text
				local var_14_4 = arg_14_2.description_text
				local var_14_5 = 255 * var_14_0

				var_14_1.style.texture_id.color[1] = var_14_5
				var_14_2.style.texture_id.color[1] = var_14_5
				var_14_3.style.text.text_color[1] = var_14_5
				var_14_4.style.text.text_color[1] = var_14_5
			end,
			on_complete = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		},
		{
			name = "button_fade_in",
			start_progress = 1.4,
			end_progress = 1.71,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = 255 * math.easeInCubic(arg_17_3)
				local var_17_1 = arg_17_2.claim_button

				var_17_1.style.texture.color[1] = var_17_0
				var_17_1.style.text.text_color[1] = var_17_0
				var_17_1.style.text_hover.text_color[1] = var_17_0
				var_17_1.style.text_selected.text_color[1] = var_17_0
				var_17_1.style.text_disabled.text_color[1] = var_17_0
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		},
		{
			name = "animation_fall",
			start_progress = 0.65,
			end_progress = 0.71,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				return
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				local var_21_0 = arg_21_3.chest_unit

				if var_21_0 and Unit.alive(var_21_0) then
					Unit.flow_event(var_21_0, "loot_chest_fall")
				end
			end
		},
		{
			name = "chest_land",
			start_progress = 0.71,
			end_progress = 1,
			init = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end,
			update = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				return
			end,
			on_complete = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				WwiseWorld.trigger_event(arg_24_3.wwise_world, "hud_reward_chest_land")
			end
		},
		{
			name = "animation_fall_xxx",
			start_progress = 0.71,
			end_progress = 1.71,
			init = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end,
			update = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				return
			end,
			on_complete = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end
		}
	},
	chest_unit_open = {
		{
			name = "animation_open",
			start_progress = 0,
			end_progress = 1,
			init = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				local var_28_0 = arg_28_3.chest_unit

				if var_28_0 and Unit.alive(var_28_0) then
					Unit.flow_event(var_28_0, "loot_chest_open")
				end
			end,
			update = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				return
			end,
			on_complete = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end
		},
		{
			name = "scale",
			start_progress = 1.1,
			end_progress = 1.25,
			init = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				local var_31_0 = arg_31_3.chest_unit

				if var_31_0 and Unit.alive(var_31_0) then
					local var_31_1, var_31_2 = Unit.box(var_31_0)

					if var_31_2 then
						local var_31_3 = 0.1
						local var_31_4 = 0

						if var_31_4 < var_31_2.x then
							var_31_4 = var_31_2.x
						end

						if var_31_4 < var_31_2.z then
							var_31_4 = var_31_2.z
						end

						if var_31_4 < var_31_2.y then
							var_31_4 = var_31_2.y
						end

						if var_31_3 < var_31_4 then
							arg_31_3.end_scale_fraction = 1 - (var_31_4 - var_31_3) / var_31_4
						end
					end
				end
			end,
			update = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				local var_32_0 = arg_32_4.chest_unit

				if var_32_0 and Unit.alive(var_32_0) then
					local var_32_1 = 1 - math.easeOutCubic(arg_32_3)
					local var_32_2 = (arg_32_4.end_scale_fraction or 0.1) * var_32_1
					local var_32_3 = Vector3(var_32_2, var_32_2, var_32_2)

					Unit.set_local_scale(var_32_0, 0, var_32_3)
				end
			end,
			on_complete = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				return
			end
		}
	},
	thumbs_fade_in = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 1,
			init = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end,
			update = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				local var_35_0 = arg_35_2.thumb_widgets

				for iter_35_0, iter_35_1 in ipairs(var_35_0) do
					-- block empty
				end
			end,
			on_complete = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				return
			end
		}
	}
}

return {
	widget_definitions = var_0_6,
	scenegraph_definition = var_0_3,
	animation_definitions = var_0_8,
	generic_input_actions = var_0_7,
	create_reward_thumb_widget = var_0_4
}
