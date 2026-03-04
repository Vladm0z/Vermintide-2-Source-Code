-- chunkname: @scripts/ui/views/store_item_purchase_popup.lua

local var_0_0 = {
	800,
	750
}
local var_0_1 = {
	var_0_0[1] - 158,
	var_0_0[2] - 158
}
local var_0_2 = {
	approved = {
		{
			name = "product_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				local var_1_0 = arg_1_3.product_widget
				local var_1_1 = var_1_0.content
				local var_1_2 = var_1_0.style

				var_1_0.alpha_multiplier = 0
				var_1_2.owned_icon.color[1] = 0
				var_1_2.owned_icon_bg.color[1] = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)
				local var_2_1 = arg_2_4.product_widget

				var_2_1.alpha_multiplier = arg_2_3

				local var_2_2 = var_2_1.content.size
				local var_2_3 = var_2_1.style
				local var_2_4 = 25

				var_2_1.offset[2] = var_2_2[2] / 2 + var_2_4 - var_2_4 * var_2_0
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		},
		{
			name = "text_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_2.approved.alpha_multiplier = 0
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)
				local var_5_1 = arg_5_2.approved
				local var_5_2 = 25

				var_5_1.offset[2] = -var_5_2 + var_5_2 * var_5_0
				var_5_1.alpha_multiplier = arg_5_3
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		},
		{
			name = "stamp",
			start_progress = 0.1,
			end_progress = 0.6,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.ease_in_exp(math.ease_exp(arg_8_3))
				local var_8_1 = 255 * arg_8_3
				local var_8_2 = arg_8_4.product_widget
				local var_8_3 = var_8_2.content.size
				local var_8_4 = var_8_2.style

				var_8_4.owned_icon.color[1] = 255 * arg_8_3
				var_8_4.owned_icon_bg.color[1] = 255 * math.ease_in_exp(arg_8_3)

				local var_8_5 = 3
				local var_8_6 = var_8_4.owned_icon

				if var_8_6 then
					local var_8_7 = var_8_6.color
					local var_8_8 = var_8_6.default_texture_size
					local var_8_9 = var_8_6.texture_size
					local var_8_10 = var_8_8[1] * var_8_5 * var_8_0
					local var_8_11 = var_8_8[2] * var_8_5 * var_8_0

					var_8_9[1] = var_8_8[1] * (var_8_5 + 1) - var_8_10
					var_8_9[2] = var_8_8[2] * (var_8_5 + 1) - var_8_11

					local var_8_12 = var_8_6.default_offset
					local var_8_13 = var_8_6.offset

					var_8_13[1] = var_8_12[1] - (var_8_8[1] * var_8_5 - var_8_10) * 0.5
					var_8_13[2] = var_8_12[2] - (var_8_8[2] * var_8_5 - var_8_11) * 0.5
				end

				local var_8_14 = var_8_4.owned_icon_bg

				if var_8_14 then
					local var_8_15 = var_8_14.color
					local var_8_16 = var_8_14.default_texture_size
					local var_8_17 = var_8_14.texture_size
					local var_8_18 = var_8_16[1] * var_8_5 * var_8_0
					local var_8_19 = var_8_16[2] * var_8_5 * var_8_0

					var_8_17[1] = var_8_16[1] * (var_8_5 + 1) - var_8_18
					var_8_17[2] = var_8_16[2] * (var_8_5 + 1) - var_8_19

					local var_8_20 = var_8_14.default_offset
					local var_8_21 = var_8_14.offset

					var_8_21[1] = var_8_20[1] - (var_8_16[1] * var_8_5 - var_8_18) * 0.5
					var_8_21[2] = var_8_20[2] - (var_8_16[2] * var_8_5 - var_8_19) * 0.5
				end
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		},
		{
			name = "frame_glow",
			start_progress = 0.4,
			end_progress = 1.9,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				local var_10_0 = arg_10_2.approved.style.frame_write_mask
				local var_10_1 = var_10_0.texture_size
				local var_10_2 = var_10_0.offset

				var_10_2[1] = -var_10_1[1]
				var_10_2[2] = -var_10_1[2]
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = math.easeOutCubic(arg_11_3)
				local var_11_1 = arg_11_2.approved.style.frame_write_mask
				local var_11_2 = var_11_1.texture_size
				local var_11_3 = var_11_1.offset

				var_11_3[1] = -var_11_2[1] + var_11_2[1] * 2 * var_11_0
				var_11_3[2] = -var_11_2[2] + var_11_2[2] * 2 * var_11_0
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 1.8,
			end_progress = 2.2,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = 1 - math.easeInCubic(arg_14_3)

				arg_14_2.approved.alpha_multiplier = var_14_0

				local var_14_1 = arg_14_4.product_widget

				var_14_1.alpha_multiplier = var_14_0
				var_14_1.style.owned_icon_bg.color[1] = 255 * math.ease_out_quad(1 - arg_14_3)
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		},
		{
			name = "blur_progress_out",
			start_progress = 1.9,
			end_progress = 2.3,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				arg_17_4.blur_progress = 1 - math.easeInCubic(arg_17_3)
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		}
	},
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				arg_19_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = math.easeOutCubic(arg_20_3)

				arg_20_4.render_settings.alpha_multiplier = var_20_0
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end
		}
	}
}
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
			UILayer.default
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
			UILayer.default
		}
	},
	purchase_overlay = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			900
		}
	},
	purchase_background = {
		vertical_alignment = "center",
		parent = "purchase_overlay",
		horizontal_alignment = "center",
		size = var_0_0,
		position = {
			0,
			0,
			1
		}
	},
	purchase_background_fade = {
		vertical_alignment = "center",
		parent = "purchase_background",
		horizontal_alignment = "center",
		size = var_0_1,
		position = {
			0,
			0,
			1
		}
	},
	background_edge_top = {
		vertical_alignment = "top",
		parent = "purchase_background",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			79
		},
		position = {
			0,
			0,
			2
		}
	},
	background_edge_bottom = {
		vertical_alignment = "bottom",
		parent = "purchase_background",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			79
		},
		position = {
			0,
			0,
			2
		}
	},
	background_edge_left = {
		vertical_alignment = "center",
		parent = "purchase_background",
		horizontal_alignment = "left",
		size = {
			79,
			var_0_0[2]
		},
		position = {
			0,
			0,
			2
		}
	},
	background_edge_right = {
		vertical_alignment = "center",
		parent = "purchase_background",
		horizontal_alignment = "right",
		size = {
			79,
			var_0_0[2]
		},
		position = {
			0,
			0,
			2
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "purchase_background",
		horizontal_alignment = "left",
		size = {
			385,
			381
		},
		position = {
			-25,
			-25,
			3
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "purchase_background",
		horizontal_alignment = "right",
		size = {
			385,
			381
		},
		position = {
			29,
			-23,
			3
		}
	},
	corner_top_left = {
		vertical_alignment = "top",
		parent = "purchase_background",
		horizontal_alignment = "left",
		size = {
			385,
			381
		},
		position = {
			-27,
			23,
			3
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "purchase_background",
		horizontal_alignment = "right",
		size = {
			385,
			381
		},
		position = {
			27,
			25,
			3
		}
	},
	purchase_confirmation_approved = {
		vertical_alignment = "center",
		parent = "purchase_overlay",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			100,
			1
		}
	},
	purchase_confirmation_declined = {
		vertical_alignment = "center",
		parent = "purchase_overlay",
		horizontal_alignment = "center",
		size = {
			256,
			512
		},
		position = {
			0,
			0,
			1
		}
	},
	purchase_confirmation_loading = {
		vertical_alignment = "center",
		parent = "purchase_overlay",
		horizontal_alignment = "center",
		size = {
			314,
			33
		},
		position = {
			0,
			0,
			1
		}
	},
	item_name_text = {
		vertical_alignment = "top",
		parent = "purchase_background_fade",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 30,
			60
		},
		position = {
			0,
			-80,
			2
		}
	},
	item_name_text_edge_top = {
		vertical_alignment = "top",
		parent = "item_name_text",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 30,
			4
		},
		position = {
			0,
			4,
			1
		}
	},
	item_name_text_edge_bottom = {
		vertical_alignment = "bottom",
		parent = "item_name_text",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 30,
			4
		},
		position = {
			0,
			-4,
			1
		}
	},
	item_type_text = {
		vertical_alignment = "top",
		parent = "item_name_text",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 30,
			50
		},
		position = {
			0,
			-65,
			2
		}
	},
	purchase_button = {
		vertical_alignment = "bottom",
		parent = "purchase_background_fade",
		horizontal_alignment = "center",
		size = {
			350,
			68
		},
		position = {
			0,
			55,
			10
		}
	},
	currency_background = {
		vertical_alignment = "bottom",
		parent = "purchase_button",
		horizontal_alignment = "center",
		size = {
			250,
			100
		},
		position = {
			0,
			90,
			0
		}
	},
	purchase_item_root = {
		vertical_alignment = "top",
		parent = "item_name_text_edge_bottom",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-290,
			2
		}
	},
	currency_current = {
		vertical_alignment = "top",
		parent = "currency_background",
		horizontal_alignment = "right",
		size = {
			180,
			20
		},
		position = {
			-10,
			-20,
			2
		}
	},
	currency_cost = {
		vertical_alignment = "top",
		parent = "currency_background",
		horizontal_alignment = "right",
		size = {
			180,
			20
		},
		position = {
			-10,
			-50,
			2
		}
	},
	currency_cost_edge = {
		vertical_alignment = "bottom",
		parent = "currency_background",
		horizontal_alignment = "right",
		size = {
			210,
			2
		},
		position = {
			-10,
			40,
			2
		}
	},
	currency_balance = {
		vertical_alignment = "bottom",
		parent = "currency_background",
		horizontal_alignment = "right",
		size = {
			180,
			20
		},
		position = {
			-10,
			10,
			2
		}
	},
	currency_icon = {
		vertical_alignment = "center",
		parent = "currency_cost_edge",
		horizontal_alignment = "left",
		size = {
			64,
			64
		},
		position = {
			-32,
			0,
			1
		}
	},
	close_button = {
		vertical_alignment = "bottom",
		parent = "purchase_background",
		horizontal_alignment = "center",
		size = {
			260,
			42
		},
		position = {
			0,
			-80,
			1
		}
	}
}
local var_0_4 = {
	use_shadow = true,
	upper_case = false,
	localize = true,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_5 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 42,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		2,
		2
	}
}
local var_0_6 = true
local var_0_7 = {
	purchase_overlay = UIWidgets.create_simple_rect("purchase_overlay", {
		50,
		10,
		10,
		10
	})
}
local var_0_8 = {
	popup = {
		item_type_text = UIWidgets.create_simple_text("", "item_type_text", nil, nil, var_0_4),
		item_name_text = UIWidgets.create_simple_text("n/a", "item_name_text", nil, nil, var_0_5),
		item_name_text_background = UIWidgets.create_simple_texture("store_preview_info_text_backdrop", "item_name_text"),
		item_name_text_edge_top = UIWidgets.create_simple_texture("store_preview_info_backdrop_border", "item_name_text_edge_top"),
		item_name_text_edge_bottom = UIWidgets.create_simple_texture("store_preview_info_backdrop_border", "item_name_text_edge_bottom"),
		background_edge_top = UIWidgets.create_tiled_texture("background_edge_top", "store_frame_side_01", {
			128,
			79
		}),
		background_edge_bottom = UIWidgets.create_tiled_texture("background_edge_bottom", "store_frame_side_03", {
			128,
			79
		}),
		background_edge_left = UIWidgets.create_tiled_texture("background_edge_left", "store_frame_side_04", {
			79,
			128
		}),
		background_edge_right = UIWidgets.create_tiled_texture("background_edge_right", "store_frame_side_02", {
			79,
			128
		}),
		purchase_background = UIWidgets.create_tiled_texture("purchase_background", "menu_frame_bg_03", {
			256,
			256
		}),
		purchase_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "purchase_background_fade"),
		corner_bottom_left = UIWidgets.create_simple_rotated_texture("store_frame_corner", 0, {
			192.5,
			190.5
		}, "corner_bottom_left"),
		corner_bottom_right = UIWidgets.create_simple_rotated_texture("store_frame_corner", -math.pi / 2, {
			192.5,
			190.5
		}, "corner_bottom_right"),
		corner_top_left = UIWidgets.create_simple_rotated_texture("store_frame_corner", math.pi / 2, {
			192.5,
			190.5
		}, "corner_top_left"),
		corner_top_right = UIWidgets.create_simple_rotated_texture("store_frame_corner", math.pi, {
			192.5,
			190.5
		}, "corner_top_right"),
		purchase_button = UIWidgets.create_store_purchase_button("purchase_button", var_0_3.purchase_button.size, Localize("menu_store_purchase_button_unlock"), 32, var_0_6),
		close_button = UIWidgets.create_default_button("close_button", var_0_3.close_button.size, "button_frame_01_gold", "menu_frame_bg_06", Localize("interaction_action_close"), 28, nil, "button_detail_03_gold", nil, var_0_6)
	},
	poll_result = {
		loading_icon = {
			scenegraph_id = "purchase_confirmation_loading",
			element = {
				passes = {
					{
						style_id = "background",
						pass_type = "texture",
						texture_id = "background",
						content_change_function = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
							local var_22_0 = ((arg_22_1.progress or 0) + arg_22_3 * 0.5) % 1
							local var_22_1 = math.smoothstep(var_22_0, 0, 1)

							arg_22_1.progress = var_22_0

							local var_22_2 = arg_22_0.fade_out
							local var_22_3 = 255 * math.ease_pulse(var_22_1)

							arg_22_1.color[1] = var_22_2 and math.min(arg_22_1.color[1], var_22_3) or var_22_3
						end
					},
					{
						style_id = "glow",
						pass_type = "texture",
						texture_id = "glow",
						content_change_function = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
							local var_23_0 = ((arg_23_1.progress or 0) + arg_23_3 * 0.5) % 1
							local var_23_1 = math.smoothstep(var_23_0, 0, 1)

							arg_23_1.progress = var_23_0

							local var_23_2 = arg_23_0.fade_out
							local var_23_3 = 255 * math.ease_pulse(var_23_1)

							arg_23_1.color[1] = var_23_2 and math.min(arg_23_1.color[1], var_23_3) or var_23_3
						end
					}
				}
			},
			content = {
				background = "loading_title_divider_background",
				fade_out = false,
				glow = "loading_title_divider"
			},
			style = {
				background = {
					progress = 0,
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
				},
				glow = {
					progress = 0,
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
			offset = {
				0,
				0,
				0
			}
		}
	},
	approved = {
		approved = {
			scenegraph_id = "purchase_confirmation_approved",
			element = {
				passes = {
					{
						style_id = "text",
						pass_type = "text",
						text_id = "text"
					},
					{
						style_id = "text_shadow",
						pass_type = "text",
						text_id = "text"
					},
					{
						style_id = "description_text",
						pass_type = "text",
						text_id = "description_text"
					},
					{
						style_id = "description_text_shadow",
						pass_type = "text",
						text_id = "description_text"
					},
					{
						pass_type = "texture_frame",
						style_id = "frame",
						texture_id = "frame"
					},
					{
						texture_id = "frame_write_mask",
						style_id = "frame_write_mask",
						pass_type = "texture"
					},
					{
						pass_type = "rect",
						style_id = "title_divider"
					}
				}
			},
			content = {
				frame = "menu_frame_16_white",
				frame_write_mask = "diagonal_center_fade_write_mask",
				description_text = "inventory_item_added",
				text = "menu_store_purchase_confirmation_approved"
			},
			style = {
				frame = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					masked = true,
					area_size = {
						260,
						220
					},
					texture_size = UIFrameSettings.menu_frame_16.texture_size,
					texture_sizes = UIFrameSettings.menu_frame_16.texture_sizes,
					frame_margins = {
						0,
						0
					},
					color = {
						100,
						255,
						255,
						255
					},
					offset = {
						0,
						0,
						9
					}
				},
				frame_write_mask = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					texture_size = {
						520,
						440
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
						2
					}
				},
				title_divider = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					texture_size = {
						350,
						2
					},
					color = {
						50,
						255,
						255,
						255
					},
					offset = {
						0,
						-210,
						6
					}
				},
				text = {
					vertical_alignment = "center",
					upper_case = true,
					localize = true,
					horizontal_alignment = "center",
					font_size = 52,
					font_type = "hell_shark_header",
					text_color = Colors.get_color_table_with_alpha("white", 255),
					offset = {
						0,
						-180,
						2
					}
				},
				text_shadow = {
					vertical_alignment = "center",
					upper_case = true,
					localize = true,
					horizontal_alignment = "center",
					font_size = 52,
					font_type = "hell_shark_header",
					text_color = Colors.get_color_table_with_alpha("black", 255),
					offset = {
						2,
						-182,
						1
					}
				},
				description_text = {
					font_size = 20,
					upper_case = true,
					localize = true,
					horizontal_alignment = "center",
					vertical_alignment = "top",
					font_type = "hell_shark",
					text_color = {
						255,
						200,
						200,
						200
					},
					offset = {
						-350,
						-320,
						2
					},
					size = {
						700,
						100
					}
				},
				description_text_shadow = {
					font_size = 20,
					upper_case = true,
					localize = true,
					horizontal_alignment = "center",
					vertical_alignment = "top",
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("black", 255),
					offset = {
						-352,
						-322,
						1
					},
					size = {
						700,
						100
					}
				}
			},
			offset = {
				0,
				0,
				0
			}
		}
	},
	declined = {}
}
local var_0_9 = "gui/1080p/single_textures/generic/transparent_placeholder_texture"

StoreItemPurchasePopup = class(StoreItemPurchasePopup)

StoreItemPurchasePopup.init = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_0._product = arg_24_2
	arg_24_0._ingame_ui = arg_24_1
	arg_24_0._top_world = arg_24_1.top_world
	arg_24_0._cloned_materials_by_reference = {}
	arg_24_0._loaded_package_names = {}
	arg_24_0._render_settings = {
		alpha_multiplier = 1
	}
	arg_24_0._animations = {}
	arg_24_0._ui_animations = {}

	arg_24_0:_setup_renderers()

	local var_24_0 = Managers.world:world("level_world")

	arg_24_0._wwise_world = Managers.world:wwise_world(var_24_0)
	arg_24_0._level_world = var_24_0

	arg_24_0:_create_ui_elements()
	arg_24_0:_change_state(arg_24_3 or "popup")
end

StoreItemPurchasePopup._setup_renderers = function (arg_25_0)
	local var_25_0 = "store_purchase_ui_world"
	local var_25_1 = 999

	arg_25_0._purchase_ui_world_viewport_name = "store_purchase_ui_world_viewport"
	arg_25_0._purchase_ui_world = Managers.world:create_world(var_25_0, GameSettingsDevelopment.default_environment, nil, var_25_1, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.create_viewport(arg_25_0._purchase_ui_world, arg_25_0._purchase_ui_world_viewport_name, "overlay", 1)

	arg_25_0._purchase_ui_renderer = arg_25_0._ingame_ui:create_ui_renderer(arg_25_0._purchase_ui_world, false, true)

	local var_25_2 = 998
	local var_25_3 = "store_purchase_ui_blur_world"
	local var_25_4 = "environment/ui_store_default"

	arg_25_0._blur_purchase_ui_world_viewport_name = "store_purchase_ui_blur_world_viewport"
	arg_25_0._blur_purchase_ui_world = Managers.world:create_world(var_25_3, var_25_4, nil, var_25_2, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.create_viewport(arg_25_0._blur_purchase_ui_world, arg_25_0._blur_purchase_ui_world_viewport_name, "overlay", 1)

	arg_25_0._blur_purchase_ui_renderer = arg_25_0._ingame_ui:create_ui_renderer(arg_25_0._blur_purchase_ui_world, false, true)
end

StoreItemPurchasePopup._destroy_renderers = function (arg_26_0)
	UIRenderer.destroy(arg_26_0._purchase_ui_renderer, arg_26_0._purchase_ui_world)
	ScriptWorld.destroy_viewport(arg_26_0._purchase_ui_world, arg_26_0._purchase_ui_world_viewport_name)
	Managers.world:destroy_world(arg_26_0._purchase_ui_world)

	arg_26_0._purchase_ui_world = nil
	arg_26_0._purchase_ui_renderer = nil
	arg_26_0._purchase_ui_world_viewport_name = nil

	UIRenderer.destroy(arg_26_0._blur_purchase_ui_renderer, arg_26_0._blur_purchase_ui_world)
	ScriptWorld.destroy_viewport(arg_26_0._blur_purchase_ui_world, arg_26_0._blur_purchase_ui_world_viewport_name)
	Managers.world:destroy_world(arg_26_0._blur_purchase_ui_world)

	arg_26_0._blur_purchase_ui_world = nil
	arg_26_0._blur_purchase_ui_renderer = nil
	arg_26_0._blur_purchase_ui_world_viewport_name = nil
end

StoreItemPurchasePopup._create_gamepad_input_description = function (arg_27_0, arg_27_1)
	local var_27_0 = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "menu_store_purchase_button_unlock"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	}

	arg_27_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_27_0._purchase_ui_renderer, arg_27_1, 6, nil, var_27_0, false)

	arg_27_0._menu_input_description:set_input_description(nil)
end

StoreItemPurchasePopup._change_state = function (arg_28_0, arg_28_1)
	if arg_28_0._state then
		local var_28_0 = "_" .. arg_28_0._state .. "_on_exit"

		if arg_28_0[var_28_0] then
			arg_28_0[var_28_0](arg_28_0)
		end
	end

	if arg_28_1 then
		local var_28_1 = "_" .. arg_28_1 .. "_on_enter"

		if arg_28_0[var_28_1] then
			arg_28_0[var_28_1](arg_28_0)
		end
	end

	print("[StoreItemPurchasePopup] - New State:", arg_28_1, " Previous State:", arg_28_0._state)

	arg_28_0._state = arg_28_1
end

StoreItemPurchasePopup._set_fullscreen_effect_enable_state = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = World.get_data(arg_29_3, "shading_environment")

	arg_29_2 = arg_29_2 or arg_29_1 and 1 or 0

	if var_29_0 then
		ShadingEnvironment.set_scalar(var_29_0, "fullscreen_blur_enabled", arg_29_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_29_0, "fullscreen_blur_amount", arg_29_1 and arg_29_2 * 0.8 or 0)
		ShadingEnvironment.apply(var_29_0)
	end

	arg_29_0._fullscreen_effect_enabled = arg_29_1
end

StoreItemPurchasePopup.is_complete = function (arg_30_0)
	return arg_30_0._state == "exit"
end

StoreItemPurchasePopup.is_aborted = function (arg_31_0)
	return arg_31_0._state == "aborted"
end

StoreItemPurchasePopup.destroy = function (arg_32_0)
	if arg_32_0._blur_purchase_ui_world and arg_32_0._fullscreen_effect_enabled then
		arg_32_0:_set_fullscreen_effect_enable_state(false, 0, arg_32_0._blur_purchase_ui_world)
	end

	arg_32_0:_destroy_renderers()

	arg_32_0._destroyed = true
end

StoreItemPurchasePopup._create_ui_elements = function (arg_33_0, arg_33_1)
	arg_33_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_33_0 = {}
	local var_33_1 = {}
	local var_33_2 = {}

	for iter_33_0, iter_33_1 in pairs(var_0_7) do
		local var_33_3 = UIWidget.init(iter_33_1)

		var_33_2[#var_33_2 + 1] = var_33_3
		var_33_0[iter_33_0] = var_33_3
	end

	for iter_33_2, iter_33_3 in pairs(var_0_8) do
		local var_33_4 = {}

		for iter_33_4, iter_33_5 in pairs(iter_33_3) do
			local var_33_5 = UIWidget.init(iter_33_5)

			var_33_0[iter_33_4] = var_33_5
			var_33_4[#var_33_4 + 1] = var_33_5
		end

		var_33_1[iter_33_2] = var_33_4
	end

	arg_33_0._static_widgets = var_33_2
	arg_33_0._widgets_by_name = var_33_0
	arg_33_0._widgets_by_state = var_33_1
	var_33_0.purchase_button.content.button_hotspot.disable_button = script_data["eac-untrusted"]

	UIRenderer.clear_scenegraph_queue(arg_33_0._purchase_ui_renderer)

	arg_33_0._ui_animator = UIAnimator:new(arg_33_0._ui_scenegraph, var_0_2)
end

StoreItemPurchasePopup._draw = function (arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._purchase_ui_renderer
	local var_34_1 = arg_34_0._blur_purchase_ui_renderer
	local var_34_2 = arg_34_0._ui_scenegraph
	local var_34_3 = arg_34_0._render_settings
	local var_34_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_34_1, var_34_2, arg_34_1, arg_34_2, nil, var_34_3)

	local var_34_5 = var_34_3.snap_pixel_positions
	local var_34_6 = var_34_3.alpha_multiplier or 1

	for iter_34_0, iter_34_1 in ipairs(arg_34_0._static_widgets) do
		if iter_34_1.snap_pixel_positions ~= nil then
			var_34_3.snap_pixel_positions = iter_34_1.snap_pixel_positions
		end

		var_34_3.alpha_multiplier = iter_34_1.alpha_multiplier or var_34_6

		UIRenderer.draw_widget(var_34_1, iter_34_1)

		var_34_3.snap_pixel_positions = var_34_5
	end

	var_34_3.alpha_multiplier = var_34_6

	UIRenderer.end_pass(var_34_1)
	UIRenderer.begin_pass(var_34_0, var_34_2, arg_34_1, arg_34_2, nil, var_34_3)

	local var_34_7 = var_34_3.snap_pixel_positions
	local var_34_8 = var_34_3.alpha_multiplier or 1
	local var_34_9 = arg_34_0._product_widget

	if var_34_9 then
		var_34_3.alpha_multiplier = var_34_9.alpha_multiplier or var_34_8

		UIRenderer.draw_widget(var_34_0, var_34_9)
	end

	local var_34_10 = arg_34_0._state

	if var_34_10 then
		local var_34_11 = arg_34_0._widgets_by_state[var_34_10]

		if var_34_11 then
			for iter_34_2, iter_34_3 in ipairs(var_34_11) do
				if iter_34_3.snap_pixel_positions ~= nil then
					var_34_3.snap_pixel_positions = iter_34_3.snap_pixel_positions
				end

				var_34_3.alpha_multiplier = iter_34_3.alpha_multiplier or var_34_8

				UIRenderer.draw_widget(var_34_0, iter_34_3)

				var_34_3.snap_pixel_positions = var_34_7
			end
		end
	end

	var_34_3.alpha_multiplier = var_34_8

	UIRenderer.end_pass(var_34_0)

	if var_34_4 then
		arg_34_0._menu_input_description:draw(var_34_0, arg_34_2)
	end
end

StoreItemPurchasePopup.update = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	if not arg_35_0._menu_input_description then
		arg_35_0:_create_gamepad_input_description(arg_35_1)
	end

	local var_35_0 = arg_35_0._state

	if var_35_0 then
		local var_35_1 = "_" .. var_35_0 .. "_update"

		if arg_35_0[var_35_1] then
			arg_35_0[var_35_1](arg_35_0, arg_35_1, arg_35_2, arg_35_3)
		end
	end

	local var_35_2 = arg_35_0._blur_progress or arg_35_0._render_settings.alpha_multiplier

	if var_35_2 then
		arg_35_0:_set_fullscreen_effect_enable_state(true, var_35_2, arg_35_0._blur_purchase_ui_world)
	elseif arg_35_0._fullscreen_effect_enabled then
		arg_35_0:_set_fullscreen_effect_enable_state(false, 0, arg_35_0._blur_purchase_ui_world)
	end

	arg_35_0:_update_animations(arg_35_2)
	arg_35_0:_draw(arg_35_1, arg_35_2)
end

StoreItemPurchasePopup._update_animations = function (arg_36_0, arg_36_1)
	for iter_36_0, iter_36_1 in pairs(arg_36_0._ui_animations) do
		UIAnimation.update(iter_36_1, arg_36_1)

		if UIAnimation.completed(iter_36_1) then
			arg_36_0._ui_animations[iter_36_0] = nil
		end
	end

	local var_36_0 = arg_36_0._animations
	local var_36_1 = arg_36_0._ui_animator

	var_36_1:update(arg_36_1)

	for iter_36_2, iter_36_3 in pairs(var_36_0) do
		if var_36_1:is_animation_completed(iter_36_3) then
			var_36_1:stop_animation(iter_36_3)

			var_36_0[iter_36_2] = nil
		end
	end
end

StoreItemPurchasePopup._is_button_hover_enter = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_1.content

	return (var_37_0.button_hotspot or var_37_0.hotspot).on_hover_enter
end

StoreItemPurchasePopup._is_button_pressed = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_1.content
	local var_38_1 = var_38_0.button_hotspot or var_38_0.hotspot

	if var_38_1.on_release then
		var_38_1.on_release = false

		return true
	end
end

StoreItemPurchasePopup._play_sound = function (arg_39_0, arg_39_1)
	WwiseWorld.trigger_event(arg_39_0._wwise_world, arg_39_1)
end

StoreItemPurchasePopup._destroy_product_widget = function (arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_1.content.reference_name

	if var_40_0 then
		local var_40_1 = arg_40_2.product_id
		local var_40_2 = arg_40_2.type

		if var_40_2 == "item" then
			arg_40_0:_unload_texture_by_reference(var_40_0)
		elseif var_40_2 == "dlc" then
			arg_40_0:_unload_texture_by_reference(var_40_0)
		end
	end
end

StoreItemPurchasePopup._create_material_instance = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	arg_41_0._cloned_materials_by_reference[arg_41_4] = arg_41_2

	return Gui.clone_material_from_template(arg_41_1, arg_41_2, arg_41_3)
end

StoreItemPurchasePopup._set_material_diffuse = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = Gui.material(arg_42_1, arg_42_2)

	if var_42_0 then
		Material.set_texture(var_42_0, "diffuse_map", arg_42_3)
	end
end

StoreItemPurchasePopup._load_texture_package = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = true
	local var_43_1 = true

	Managers.package:load(arg_43_1, arg_43_2, arg_43_3, var_43_0, var_43_1)

	arg_43_0._loaded_package_names[arg_43_2] = arg_43_1
end

StoreItemPurchasePopup._is_unique_reference_to_material = function (arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._cloned_materials_by_reference
	local var_44_1 = var_44_0[arg_44_1]

	fassert(var_44_1, "[StoreItemPurchasePopup] - Could not find a used material for reference name: (%s)", arg_44_1)

	for iter_44_0, iter_44_1 in pairs(var_44_0) do
		if var_44_1 == iter_44_1 and arg_44_1 ~= iter_44_0 then
			return false
		end
	end

	return true
end

StoreItemPurchasePopup._unload_texture_by_reference = function (arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0._loaded_package_names
	local var_45_1 = arg_45_0._cloned_materials_by_reference
	local var_45_2 = var_45_0[arg_45_1]

	fassert(var_45_2, "[StoreItemPurchasePopup] - Could not find a package to unload for reference name: (%s)", arg_45_1)
	Managers.package:unload(var_45_2, arg_45_1)

	var_45_0[arg_45_1] = nil

	if arg_45_0:_is_unique_reference_to_material(arg_45_1) then
		local var_45_3 = var_45_1[arg_45_1]
		local var_45_4 = arg_45_0._purchase_ui_renderer.gui

		arg_45_0:_set_material_diffuse(var_45_4, var_45_3, var_0_9)
	end

	var_45_1[arg_45_1] = nil
end

StoreItemPurchasePopup._unload_all_textures = function (arg_46_0)
	local var_46_0 = arg_46_0._loaded_package_names

	for iter_46_0, iter_46_1 in pairs(var_46_0) do
		arg_46_0:_unload_texture_by_reference(iter_46_0)
	end
end

StoreItemPurchasePopup._calculate_discount_textures = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_1.content
	local var_47_1 = arg_47_1.style.discont_number_icons
	local var_47_2 = var_47_0.discont_number_icons
	local var_47_3 = var_47_1.texture_sizes
	local var_47_4 = var_47_1.texture_offsets
	local var_47_5 = 0
	local var_47_6 = 9
	local var_47_7 = tostring(math.abs(math.floor(arg_47_2)))
	local var_47_8 = string.len(var_47_7)

	local function var_47_9(arg_48_0)
		local var_48_0 = "store_number_" .. arg_48_0
		local var_48_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_48_0)
		local var_48_2 = {
			var_48_1.size[1],
			var_48_1.size[2]
		}
		local var_48_3 = #var_47_4 + 1

		var_47_2[var_48_3] = var_48_0
		var_47_3[var_48_3] = var_48_2

		local var_48_4 = -(var_47_5 * 0.5 + var_47_6 * 0.5 * var_48_3)
		local var_48_5 = var_47_6 * var_48_3

		var_47_4[var_48_3] = {
			var_48_4,
			var_48_5,
			0
		}
		var_47_5 = var_47_5 + var_48_2[1]
	end

	if arg_47_2 > 0 then
		var_47_9("minus")
	end

	for iter_47_0 = 1, var_47_8 do
		local var_47_10 = string.sub(var_47_7, iter_47_0, iter_47_0)

		var_47_9(var_47_10)
	end

	var_47_9("percent")

	var_47_0.discount = true
end

StoreItemPurchasePopup._start_transition_animation = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = {
		wwise_world = arg_49_0._wwise_world,
		render_settings = arg_49_0._render_settings,
		product_widget = arg_49_0._product_widget
	}
	local var_49_1 = arg_49_3 or arg_49_0._widgets_by_name
	local var_49_2 = arg_49_0._ui_animator:start_animation(arg_49_2, var_49_1, var_0_3, var_49_0)

	arg_49_0._animations[arg_49_1] = var_49_2

	return var_49_0
end

StoreItemPurchasePopup._popup_on_enter = function (arg_50_0)
	local var_50_0 = arg_50_0._product
	local var_50_1 = var_50_0.product_item or var_50_0.item
	local var_50_2 = var_50_1.data
	local var_50_3 = var_50_2.rarity
	local var_50_4 = var_50_2.item_type
	local var_50_5 = arg_50_0._widgets_by_name
	local var_50_6, var_50_7 = UIUtils.get_ui_information_from_item(var_50_1)
	local var_50_8 = var_50_5.item_name_text

	var_50_8.content.text = Localize(var_50_7)

	local var_50_9 = Colors.get_color_table_with_alpha(var_50_3, 255)

	var_50_8.style.text.text_color = var_50_9

	local var_50_10 = "purchase_item_root"
	local var_50_11 = arg_50_0:_create_popup_widget(var_50_0, var_50_10)

	arg_50_0._product_widget = var_50_11

	local var_50_12 = var_50_11.content.size

	var_50_11.offset[1] = -var_50_12[1] / 2
	var_50_11.offset[2] = var_50_12[2]

	local var_50_13 = arg_50_0._widgets_by_name.purchase_button

	if var_50_13 then
		var_50_13.content.present_currency = false

		local var_50_14 = var_50_13.style

		var_50_14.title_text.offset[1] = 0
		var_50_14.title_text.horizontal_alignment = "center"
		var_50_14.title_text_disabled.horizontal_alignment = "center"
		var_50_14.title_text_disabled.offset[1] = 0
		var_50_14.title_text_write_mask.offset[1] = 0
		var_50_14.title_text_write_mask.horizontal_alignment = "center"
		var_50_14.title_text_shadow.offset[1] = 2
		var_50_14.title_text_shadow.horizontal_alignment = "center"
	end

	local var_50_15 = arg_50_0._widgets_by_name.item_type_text

	if var_50_15 then
		var_50_15.content.text = var_50_4
	end

	local var_50_16 = "on_enter"

	arg_50_0:_start_transition_animation(var_50_16, var_50_16, arg_50_0._widgets_by_name)
end

StoreItemPurchasePopup._create_popup_widget = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = arg_51_0._product
	local var_51_1 = var_51_0.product_id
	local var_51_2 = var_51_0.product_item or var_51_0.item
	local var_51_3 = false
	local var_51_4 = {
		260,
		220
	}
	local var_51_5 = UIWidgets.create_store_item_definition(arg_51_2, var_51_4, var_51_3, var_51_0)
	local var_51_6 = UIWidget.init(var_51_5)

	arg_51_0:_populate_item_widget(var_51_6, var_51_2, var_51_1, arg_51_3)

	return var_51_6
end

StoreItemPurchasePopup._popup_update = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	local var_52_0 = arg_52_1:get("toggle_menu", true)
	local var_52_1 = arg_52_1:get("back_menu", true)
	local var_52_2 = arg_52_1:get("confirm_press", true)
	local var_52_3 = arg_52_0._widgets_by_name
	local var_52_4 = var_52_3.purchase_button
	local var_52_5 = var_52_3.close_button

	UIWidgetUtils.animate_default_button(var_52_4, arg_52_2)
	UIWidgetUtils.animate_default_button(var_52_5, arg_52_2)

	if var_52_1 or var_52_0 or arg_52_0:_is_button_pressed(var_52_5) then
		arg_52_0:_play_sound("Play_hud_select")
		arg_52_0:_change_state("aborted")
	else
		if arg_52_0:_is_button_hover_enter(var_52_4) or arg_52_0:_is_button_hover_enter(var_52_5) then
			arg_52_0:_play_sound("Play_hud_hover")
		end

		if arg_52_0:_is_button_pressed(var_52_4) or var_52_2 then
			arg_52_0:_play_sound("Play_hud_store_button_buy")
			arg_52_0:_change_state("poll_result")
		end
	end
end

StoreItemPurchasePopup._popup_on_exit = function (arg_53_0)
	arg_53_0:_destroy_product_widget(arg_53_0._product_widget, arg_53_0._product)

	arg_53_0._product_widget = nil
	arg_53_0._blur_progress = nil
end

StoreItemPurchasePopup._poll_result_on_enter = function (arg_54_0)
	local var_54_0 = DLCSettings.store.currency_ui_settings
	local var_54_1 = arg_54_0._product
	local var_54_2 = var_54_1.product_item or var_54_1.item
	local var_54_3 = var_54_2.key
	local var_54_4 = var_54_2.regular_prices
	local var_54_5 = var_54_2.current_prices
	local var_54_6 = "SM"

	if var_54_4 or var_54_5 then
		for iter_54_0, iter_54_1 in pairs(var_54_0) do
			local var_54_7 = var_54_4[iter_54_0]
			local var_54_8 = var_54_5[iter_54_0]

			if var_54_7 and var_54_8 then
				var_54_6 = iter_54_0

				break
			end
		end
	end

	local var_54_9 = var_54_5[var_54_6] or var_54_4[var_54_6]
	local var_54_10 = callback(arg_54_0, "_backend_result_callback")

	Managers.backend:get_interface("peddler"):exchange_chips(var_54_3, var_54_6, var_54_9, var_54_10)
end

StoreItemPurchasePopup._backend_result_callback = function (arg_55_0, arg_55_1, arg_55_2)
	if arg_55_0._destroyed then
		return
	end

	print("_backend_result_callback", arg_55_1)

	if arg_55_1 then
		Managers.telemetry_events:store_product_purchased(arg_55_0._product)
		arg_55_0:_change_state("approved")
	else
		arg_55_0:_change_state("exit")
	end
end

local var_0_10 = {
	common = "store_thumbnail_bg_common",
	promo = "store_thumbnail_bg_promo",
	plentiful = "store_thumbnail_bg_plentiful",
	rare = "store_thumbnail_bg_rare",
	exotic = "store_thumbnail_bg_exotic",
	magic = "store_thumbnail_bg_magic",
	unique = "store_thumbnail_bg_unique"
}

StoreItemPurchasePopup._populate_item_widget = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	local var_56_0 = UISettings.item_rarity_textures
	local var_56_1 = UISettings.item_type_store_icons
	local var_56_2 = DLCSettings.store.currency_ui_settings
	local var_56_3 = arg_56_2.data
	local var_56_4
	local var_56_5 = false
	local var_56_6
	local var_56_7
	local var_56_8
	local var_56_9

	if arg_56_2.data and arg_56_2.data.parent then
		local var_56_10 = ItemMasterList[arg_56_2.data.parent]

		var_56_6 = var_56_10.inventory_icon

		local var_56_11 = var_56_10.display_name
		local var_56_12 = var_56_10.description

		var_56_9 = var_56_10.rarity
		var_56_4 = arg_56_2.data.parent
		var_56_5 = true
	else
		local var_56_13, var_56_14

		var_56_6, var_56_13, var_56_14 = UIUtils.get_ui_information_from_item(arg_56_2)
		var_56_9 = arg_56_2.rarity or var_56_3.rarity
	end

	local var_56_15 = var_56_3.item_type
	local var_56_16 = arg_56_1.content
	local var_56_17 = arg_56_1.style
	local var_56_18 = var_56_17.icon.masked

	var_56_16.background = var_0_10[var_56_9]

	local var_56_19 = var_56_17.overlay.offset[3]
	local var_56_20 = var_56_17.icon.offset[3]

	var_56_17.icon.offset[3] = var_56_19
	var_56_17.overlay.offset[3] = var_56_20

	local var_56_21 = "SM"
	local var_56_22 = arg_56_2.regular_prices
	local var_56_23 = arg_56_2.current_prices

	if var_56_22 or var_56_23 then
		for iter_56_0, iter_56_1 in pairs(var_56_2) do
			local var_56_24 = var_56_22[iter_56_0]
			local var_56_25 = var_56_23[iter_56_0]

			if var_56_24 and var_56_25 then
				var_56_21 = iter_56_0

				break
			end
		end

		local var_56_26 = var_56_22[var_56_21]
		local var_56_27 = var_56_23[var_56_21]

		if var_56_27 ~= var_56_26 then
			local var_56_28 = 1 - var_56_27 / var_56_26

			arg_56_0:_calculate_discount_textures(arg_56_1, math.round(100 * var_56_28))
		end

		local var_56_29 = false
		local var_56_30 = UIUtils.comma_value(tostring(var_56_27))

		arg_56_0:_set_product_price_text(arg_56_1, var_56_30, var_56_29)

		var_56_16.price_icon = var_56_2[var_56_21].icon_small
	end

	local var_56_31 = Managers.backend:get_interface("items")
	local var_56_32 = arg_56_2.key
	local var_56_33 = var_56_31:has_item(var_56_32)
	local var_56_34 = arg_56_2.data
	local var_56_35 = var_56_34.item_type

	var_56_16.owned = arg_56_4 or var_56_33

	local var_56_36 = DLCSettings.store.allowed_store_item_types
	local var_56_37

	if var_56_36[var_56_35] then
		var_56_37 = var_56_1[var_56_35]

		if var_56_9 and var_56_9 ~= "default" then
			var_56_37 = var_56_37 .. "_" .. var_56_9
		end
	else
		var_56_37 = var_56_1[var_56_35] or var_56_1.default
	end

	var_56_16.type_tag_icon = var_56_37

	local var_56_38 = arg_56_0._purchase_ui_renderer.gui
	local var_56_39 = var_56_34.store_icon_override_key

	arg_56_0._reference_id = (arg_56_0._reference_id or 0) + 1

	local var_56_40 = "StoreItemPurchasePopup_" .. arg_56_3 .. "_" .. arg_56_0._reference_id
	local var_56_41 = var_56_5 and var_56_4 and var_56_4 or var_56_39 or arg_56_3
	local var_56_42 = "store_item_icon_" .. var_56_41
	local var_56_43 = "resource_packages/store/item_icons/" .. var_56_42

	if Application.can_get("package", var_56_43) then
		var_56_16.reference_name = var_56_40

		local var_56_44 = var_56_18 and var_56_42 .. "_masked" or var_56_42
		local var_56_45 = var_56_18 and "template_store_diffuse_masked" or "template_store_diffuse"

		arg_56_0:_create_material_instance(var_56_38, var_56_44, var_56_45, var_56_40)

		local function var_56_46()
			if arg_56_0._destroyed then
				return
			end

			local var_57_0 = "gui/1080p/single_textures/store_item_icons/" .. var_56_42 .. "/" .. var_56_42

			arg_56_0:_set_material_diffuse(var_56_38, var_56_44, var_57_0)

			var_56_16.icon = var_56_44
		end

		arg_56_0:_load_texture_package(var_56_43, var_56_40, var_56_46)
	else
		var_56_16.icon = var_56_6

		Application.warning("Icon package not accessable for product_id: (%s) and texture_name: (%s)", arg_56_3, var_56_42)
	end
end

StoreItemPurchasePopup._set_product_price_text = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0 = arg_58_1.content
	local var_58_1 = arg_58_1.style
	local var_58_2
	local var_58_3 = 0
	local var_58_4

	if arg_58_3 then
		var_58_2 = var_58_1.price_text
		var_58_2.offset[1] = 23
		var_58_0.price_text = arg_58_2
		var_58_0.draw_price_icon = false
		var_58_4 = -20
	else
		var_58_2 = var_58_1.price_text
		var_58_2.offset[1] = 50
		var_58_0.price_text = arg_58_2
		var_58_0.draw_price_icon = true
		var_58_4 = 5
	end

	local var_58_5 = UIUtils.get_text_width(arg_58_0._purchase_ui_renderer, var_58_2, arg_58_2)
	local var_58_6 = var_58_1.background_price_right
	local var_58_7 = var_58_6.default_size[1]
	local var_58_8 = math.max(math.ceil(var_58_5 - var_58_7) + var_58_4, 0)

	var_58_1.background_price_center.texture_size[1] = var_58_8
	var_58_6.offset[1] = var_58_6.default_offset[1] + var_58_8
end

StoreItemPurchasePopup._approved_on_enter = function (arg_59_0)
	arg_59_0._ui_animator = UIAnimator:new(arg_59_0._ui_scenegraph, var_0_2)

	local var_59_0 = arg_59_0._product
	local var_59_1 = true
	local var_59_2 = "purchase_confirmation_approved"
	local var_59_3 = arg_59_0:_create_popup_widget(var_59_0, var_59_2, var_59_1)

	arg_59_0._product_widget = var_59_3

	local var_59_4 = var_59_3.content.size

	var_59_3.offset[1] = -var_59_4[1] / 2
	var_59_3.offset[2] = -var_59_4[2] / 2

	arg_59_0:_create_ui_elements()

	local var_59_5 = "approved"

	arg_59_0._approved_anim_params = arg_59_0:_start_transition_animation(var_59_5, var_59_5, arg_59_0._widgets_by_name)
	arg_59_0._widgets_by_name.approved.content.visible = true
	arg_59_0._purchase_confirmation_anim_duration = 0
	arg_59_0._widgets_by_name.approved.content.visible = true
end

StoreItemPurchasePopup._approved_update = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	local var_60_0 = arg_60_0._purchase_confirmation_anim_duration

	if not var_60_0 then
		return
	end

	local var_60_1 = var_60_0 + arg_60_2
	local var_60_2 = math.min(var_60_1 / 3, 1)
	local var_60_3 = math.easeOutCubic(var_60_2)
	local var_60_4 = arg_60_0._widgets_by_name
	local var_60_5 = var_60_4.approved

	if var_60_2 == 1 then
		var_60_4.loading_icon.content.fade_out = false
		arg_60_0._purchase_confirmation_anim_duration = nil
		arg_60_0._approved_anim_params = nil

		arg_60_0:_change_state("exit")
	else
		local var_60_6 = arg_60_0._approved_anim_params.blur_progress

		if var_60_6 then
			arg_60_0._blur_progress = var_60_6
		end

		arg_60_0._purchase_confirmation_anim_duration = var_60_1
	end
end
