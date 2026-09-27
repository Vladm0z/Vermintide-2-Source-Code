-- chunkname: @scripts/ui/views/store_item_purchase_popup.lua

local tbl = {
	800,
	750
}
local tbl_2 = {
	tbl[1] - 158,
	tbl[2] - 158
}
local tbl_3 = {
	approved = {
		{
			name = "product_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				local product_widget = arg_1_3.product_widget
				local content = product_widget.content
				local style = product_widget.style

				product_widget.alpha_multiplier = 0
				style.owned_icon.color[1] = 0
				style.owned_icon_bg.color[1] = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)
				local product_widget = arg_2_4.product_widget

				product_widget.alpha_multiplier = arg_2_3

				local size = product_widget.content.size
				local style = product_widget.style
				local num = 25

				product_widget.offset[2] = size[2] / 2 + num - num * easeOutCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		},
		{
			name = "text_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_2.approved.alpha_multiplier = 0
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)
				local approved = arg_5_2.approved
				local num = 25

				approved.offset[2] = -num + num * easeOutCubic
				approved.alpha_multiplier = arg_5_3
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		},
		{
			name = "stamp",
			start_progress = 0.1,
			end_progress = 0.6,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local ease_in_exp = math.ease_in_exp(math.ease_exp(arg_8_3))
				local num = 255 * arg_8_3
				local product_widget = arg_8_4.product_widget
				local size = product_widget.content.size
				local style = product_widget.style

				style.owned_icon.color[1] = 255 * arg_8_3
				style.owned_icon_bg.color[1] = 255 * math.ease_in_exp(arg_8_3)

				local num_2 = 3
				local owned_icon = style.owned_icon

				if not owned_icon then
					local color = owned_icon.color
					local default_texture_size = owned_icon.default_texture_size
					local texture_size = owned_icon.texture_size
					local num_3 = default_texture_size[1] * num_2 * ease_in_exp
					local num_4 = default_texture_size[2] * num_2 * ease_in_exp

					texture_size[1] = default_texture_size[1] * (num_2 + 1) - num_3
					texture_size[2] = default_texture_size[2] * (num_2 + 1) - num_4

					local default_offset = owned_icon.default_offset
					local offset = owned_icon.offset

					offset[1] = default_offset[1] - (default_texture_size[1] * num_2 - num_3) * 0.5
					offset[2] = default_offset[2] - (default_texture_size[2] * num_2 - num_4) * 0.5
				end

				local owned_icon_bg = style.owned_icon_bg

				if not owned_icon_bg then
					local color_2 = owned_icon_bg.color
					local default_texture_size_2 = owned_icon_bg.default_texture_size
					local texture_size_2 = owned_icon_bg.texture_size
					local num_5 = default_texture_size_2[1] * num_2 * ease_in_exp
					local num_6 = default_texture_size_2[2] * num_2 * ease_in_exp

					texture_size_2[1] = default_texture_size_2[1] * (num_2 + 1) - num_5
					texture_size_2[2] = default_texture_size_2[2] * (num_2 + 1) - num_6

					local default_offset_2 = owned_icon_bg.default_offset
					local offset_2 = owned_icon_bg.offset

					offset_2[1] = default_offset_2[1] - (default_texture_size_2[1] * num_2 - num_5) * 0.5
					offset_2[2] = default_offset_2[2] - (default_texture_size_2[2] * num_2 - num_6) * 0.5
				end
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "frame_glow",
			start_progress = 0.4,
			end_progress = 1.9,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				local frame_write_mask = arg_10_2.approved.style.frame_write_mask
				local texture_size = frame_write_mask.texture_size
				local offset = frame_write_mask.offset

				offset[1] = -texture_size[1]
				offset[2] = -texture_size[2]
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local easeOutCubic = math.easeOutCubic(arg_11_3)
				local frame_write_mask = arg_11_2.approved.style.frame_write_mask
				local texture_size = frame_write_mask.texture_size
				local offset = frame_write_mask.offset

				offset[1] = -texture_size[1] + texture_size[1] * 2 * easeOutCubic
				offset[2] = -texture_size[2] + texture_size[2] * 2 * easeOutCubic
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 1.8,
			end_progress = 2.2,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local num = 1 - math.easeInCubic(arg_14_3)

				arg_14_2.approved.alpha_multiplier = num

				local product_widget = arg_14_4.product_widget

				product_widget.alpha_multiplier = num
				product_widget.style.owned_icon_bg.color[1] = 255 * math.ease_out_quad(1 - arg_14_3)
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		},
		{
			name = "blur_progress_out",
			start_progress = 1.9,
			end_progress = 2.3,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				arg_17_4.blur_progress = 1 - math.easeInCubic(arg_17_3)
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
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
				-- function 19
				arg_19_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				local easeOutCubic = math.easeOutCubic(arg_20_3)

				arg_20_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end
		}
	}
}
local tbl_4 = {
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
		size = tbl,
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
		size = tbl_2,
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
			tbl[1],
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
			tbl[1],
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
			tbl[2]
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
			tbl[2]
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
			tbl_2[1] - 30,
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
			tbl_2[1] - 30,
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
			tbl_2[1] - 30,
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
			tbl_2[1] - 30,
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
local tbl_5 = {
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
local tbl_6 = {
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
local flag = true
local tbl_7 = {
	purchase_overlay = UIWidgets.create_simple_rect("purchase_overlay", {
		50,
		10,
		10,
		10
	})
}
local tbl_8 = {
	popup = {
		item_type_text = UIWidgets.create_simple_text("", "item_type_text", nil, nil, tbl_5),
		item_name_text = UIWidgets.create_simple_text("n/a", "item_name_text", nil, nil, tbl_6),
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
		purchase_button = UIWidgets.create_store_purchase_button("purchase_button", tbl_4.purchase_button.size, Localize("menu_store_purchase_button_unlock"), 32, flag),
		close_button = UIWidgets.create_default_button("close_button", tbl_4.close_button.size, "button_frame_01_gold", "menu_frame_bg_06", Localize("interaction_action_close"), 28, nil, "button_detail_03_gold", nil, flag)
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
						content_change_function = function (self, arg_22_1, arg_22_2, arg_22_3)
							-- function 22
							local progress = arg_22_1.progress

							progress = progress or 0

							local num = (progress + arg_22_3 * 0.5) % 1
							local smoothstep = math.smoothstep(num, 0, 1)

							arg_22_1.progress = num

							local fade_out = self.fade_out
							local num_2 = 255 * math.ease_pulse(smoothstep)
							local color = arg_22_1.color
							local min

							if not fade_out then
								min = math.min(arg_22_1.color[1], num_2)

								if not min then
									-- Nothing
								end
							end

							min = num_2

							::label_22_0::

							color[1] = min
						end
					},
					{
						style_id = "glow",
						pass_type = "texture",
						texture_id = "glow",
						content_change_function = function (self, arg_23_1, arg_23_2, arg_23_3)
							-- function 23
							local progress = arg_23_1.progress

							progress = progress or 0

							local num = (progress + arg_23_3 * 0.5) % 1
							local smoothstep = math.smoothstep(num, 0, 1)

							arg_23_1.progress = num

							local fade_out = self.fade_out
							local num_2 = 255 * math.ease_pulse(smoothstep)
							local color = arg_23_1.color
							local min

							if not fade_out then
								min = math.min(arg_23_1.color[1], num_2)

								if not min then
									-- Nothing
								end
							end

							min = num_2

							::label_23_0::

							color[1] = min
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
local str = "gui/1080p/single_textures/generic/transparent_placeholder_texture"

StoreItemPurchasePopup = class(StoreItemPurchasePopup)

StoreItemPurchasePopup.init = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	self._product = arg_24_2
	self._ingame_ui = arg_24_1
	self._top_world = arg_24_1.top_world
	self._cloned_materials_by_reference = {}
	self._loaded_package_names = {}
	self._render_settings = {
		alpha_multiplier = 1
	}
	self._animations = {}
	self._ui_animations = {}

	self:_setup_renderers()

	local world = Managers.world:world("level_world")

	self._wwise_world = Managers.world:wwise_world(world)
	self._level_world = world

	self:_create_ui_elements()
	self:_change_state(arg_24_3 or "popup")
end

StoreItemPurchasePopup._setup_renderers = function (self)
	-- function 25
	local str = "store_purchase_ui_world"
	local num = 999

	self._purchase_ui_world_viewport_name = "store_purchase_ui_world_viewport"
	self._purchase_ui_world = Managers.world:create_world(str, GameSettingsDevelopment.default_environment, nil, num, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.create_viewport(self._purchase_ui_world, self._purchase_ui_world_viewport_name, "overlay", 1)

	self._purchase_ui_renderer = self._ingame_ui:create_ui_renderer(self._purchase_ui_world, false, true)

	local num_2 = 998
	local str_2 = "store_purchase_ui_blur_world"
	local str_3 = "environment/ui_store_default"

	self._blur_purchase_ui_world_viewport_name = "store_purchase_ui_blur_world_viewport"
	self._blur_purchase_ui_world = Managers.world:create_world(str_2, str_3, nil, num_2, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)

	ScriptWorld.create_viewport(self._blur_purchase_ui_world, self._blur_purchase_ui_world_viewport_name, "overlay", 1)

	self._blur_purchase_ui_renderer = self._ingame_ui:create_ui_renderer(self._blur_purchase_ui_world, false, true)
end

StoreItemPurchasePopup._destroy_renderers = function (self)
	-- function 26
	UIRenderer.destroy(self._purchase_ui_renderer, self._purchase_ui_world)
	ScriptWorld.destroy_viewport(self._purchase_ui_world, self._purchase_ui_world_viewport_name)
	Managers.world:destroy_world(self._purchase_ui_world)

	self._purchase_ui_world = nil
	self._purchase_ui_renderer = nil
	self._purchase_ui_world_viewport_name = nil

	UIRenderer.destroy(self._blur_purchase_ui_renderer, self._blur_purchase_ui_world)
	ScriptWorld.destroy_viewport(self._blur_purchase_ui_world, self._blur_purchase_ui_world_viewport_name)
	Managers.world:destroy_world(self._blur_purchase_ui_world)

	self._blur_purchase_ui_world = nil
	self._blur_purchase_ui_renderer = nil
	self._blur_purchase_ui_world_viewport_name = nil
end

StoreItemPurchasePopup._create_gamepad_input_description = function (self, arg_27_1)
	-- function 27
	local tbl = {
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

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self._purchase_ui_renderer, arg_27_1, 6, nil, tbl, false)

	self._menu_input_description:set_input_description(nil)
end

StoreItemPurchasePopup._change_state = function (self, arg_28_1)
	-- function 28
	if not self._state then
		local str = "_" .. self._state .. "_on_exit"

		if not self[str] then
			self[str](self)
		end
	end

	if not arg_28_1 then
		local str_2 = "_" .. arg_28_1 .. "_on_enter"

		if not self[str_2] then
			self[str_2](self)
		end
	end

	print("[StoreItemPurchasePopup] - New State:", arg_28_1, " Previous State:", self._state)

	self._state = arg_28_1
end

StoreItemPurchasePopup._set_fullscreen_effect_enable_state = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local get_data = World.get_data(arg_29_3, "shading_environment")

	arg_29_2 = arg_29_2 or not arg_29_1 or 1 or 0

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_29_2 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_29_1 and 1 and 0

		set_scalar(var_29_2, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_29_6 = get_data
		local str_2 = "fullscreen_blur_amount"
		local num

		if not arg_29_1 then
			num = arg_29_2 * 0.8

			if not num then
				-- Nothing
			end
		end

		num = 0

		::label_29_0::

		set_scalar_2(var_29_6, str_2, num)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_29_1
end

StoreItemPurchasePopup.is_complete = function (self)
	-- function 30
	return self._state == "exit"
end

StoreItemPurchasePopup.is_aborted = function (self)
	-- function 31
	return self._state == "aborted"
end

StoreItemPurchasePopup.destroy = function (self)
	-- function 32
	if not self._blur_purchase_ui_world and not self._fullscreen_effect_enabled then
		self:_set_fullscreen_effect_enable_state(false, 0, self._blur_purchase_ui_world)
	end

	self:_destroy_renderers()

	self._destroyed = true
end

StoreItemPurchasePopup._create_ui_elements = function (self, arg_33_1)
	-- function 33
	self._ui_scenegraph = UISceneGraph.init_scenegraph(tbl_4)

	local tbl = {}
	local tbl_2 = {}
	local tbl_5 = {}

	for k, v in pairs(tbl_7) do
		local var_33_3 = UIWidget.init(v)

		tbl_5[#tbl_5 + 1] = var_33_3
		tbl[k] = var_33_3
	end

	for k_2, v_2 in pairs(tbl_8) do
		local tbl_6 = {}

		for k_3, v_3 in pairs(v_2) do
			local var_33_5 = UIWidget.init(v_3)

			tbl[k_3] = var_33_5
			tbl_6[#tbl_6 + 1] = var_33_5
		end

		tbl_2[k_2] = tbl_6
	end

	self._static_widgets = tbl_5
	self._widgets_by_name = tbl
	self._widgets_by_state = tbl_2
	tbl.purchase_button.content.button_hotspot.disable_button = GameSettingsDevelopment.read_only_backend

	UIRenderer.clear_scenegraph_queue(self._purchase_ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, tbl_3)
end

StoreItemPurchasePopup._draw = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _purchase_ui_renderer = self._purchase_ui_renderer
	local _blur_purchase_ui_renderer = self._blur_purchase_ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_blur_purchase_ui_renderer, _ui_scenegraph, arg_34_1, arg_34_2, nil, _render_settings)

	local snap_pixel_positions = _render_settings.snap_pixel_positions
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	for i, v in ipairs(self._static_widgets) do
		if v.snap_pixel_positions ~= nil then
			_render_settings.snap_pixel_positions = v.snap_pixel_positions
		end

		local alpha_multiplier_2 = v.alpha_multiplier

		alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
		_render_settings.alpha_multiplier = alpha_multiplier_2

		UIRenderer.draw_widget(_blur_purchase_ui_renderer, v)

		_render_settings.snap_pixel_positions = snap_pixel_positions
	end

	_render_settings.alpha_multiplier = alpha_multiplier

	UIRenderer.end_pass(_blur_purchase_ui_renderer)
	UIRenderer.begin_pass(_purchase_ui_renderer, _ui_scenegraph, arg_34_1, arg_34_2, nil, _render_settings)

	local snap_pixel_positions_2 = _render_settings.snap_pixel_positions
	local alpha_multiplier_3 = _render_settings.alpha_multiplier

	alpha_multiplier_3 = alpha_multiplier_3 or 1

	local _product_widget = self._product_widget

	if not _product_widget then
		local alpha_multiplier_4 = _product_widget.alpha_multiplier

		alpha_multiplier_4 = alpha_multiplier_4 or alpha_multiplier_3
		_render_settings.alpha_multiplier = alpha_multiplier_4

		UIRenderer.draw_widget(_purchase_ui_renderer, _product_widget)
	end

	local _state = self._state

	if not _state then
		local var_34_13 = self._widgets_by_state[_state]

		if not var_34_13 then
			for i_2, v_2 in ipairs(var_34_13) do
				if v_2.snap_pixel_positions ~= nil then
					_render_settings.snap_pixel_positions = v_2.snap_pixel_positions
				end

				local alpha_multiplier_5 = v_2.alpha_multiplier

				alpha_multiplier_5 = alpha_multiplier_5 or alpha_multiplier_3
				_render_settings.alpha_multiplier = alpha_multiplier_5

				UIRenderer.draw_widget(_purchase_ui_renderer, v_2)

				_render_settings.snap_pixel_positions = snap_pixel_positions_2
			end
		end
	end

	_render_settings.alpha_multiplier = alpha_multiplier_3

	UIRenderer.end_pass(_purchase_ui_renderer)

	if not is_device_active then
		self._menu_input_description:draw(_purchase_ui_renderer, arg_34_2)
	end
end

StoreItemPurchasePopup.update = function (self, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	if not self._menu_input_description then
		self:_create_gamepad_input_description(arg_35_1)
	end

	local _state = self._state

	if not _state then
		local str = "_" .. _state .. "_update"

		if not self[str] then
			self[str](self, arg_35_1, arg_35_2, arg_35_3)
		end
	end

	local _blur_progress = self._blur_progress

	_blur_progress = _blur_progress or self._render_settings.alpha_multiplier

	if not _blur_progress then
		self:_set_fullscreen_effect_enable_state(true, _blur_progress, self._blur_purchase_ui_world)
	elseif not self._fullscreen_effect_enabled then
		self:_set_fullscreen_effect_enable_state(false, 0, self._blur_purchase_ui_world)
	end

	self:_update_animations(arg_35_2)
	self:_draw(arg_35_1, arg_35_2)
end

StoreItemPurchasePopup._update_animations = function (self, arg_36_1)
	-- function 36
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_36_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_36_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

StoreItemPurchasePopup._is_button_hover_enter = function (arg_37_0, arg_37_1)
	-- function 37
	local content = arg_37_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	return button_hotspot.on_hover_enter
end

StoreItemPurchasePopup._is_button_pressed = function (arg_38_0, arg_38_1)
	-- function 38
	local content = arg_38_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StoreItemPurchasePopup._play_sound = function (self, arg_39_1)
	-- function 39
	WwiseWorld.trigger_event(self._wwise_world, arg_39_1)
end

StoreItemPurchasePopup._destroy_product_widget = function (self, arg_40_1, arg_40_2)
	-- function 40
	local reference_name = arg_40_1.content.reference_name

	if not reference_name then
		local product_id = arg_40_2.product_id
		local type = arg_40_2.type

		if type == "item" then
			self:_unload_texture_by_reference(reference_name)
		elseif type == "dlc" then
			self:_unload_texture_by_reference(reference_name)
		end
	end
end

StoreItemPurchasePopup._create_material_instance = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	arg_41_0._cloned_materials_by_reference[arg_41_4] = arg_41_2

	return Gui.clone_material_from_template(arg_41_1, arg_41_2, arg_41_3)
end

StoreItemPurchasePopup._set_material_diffuse = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local material = Gui.material(arg_42_1, arg_42_2)

	if not material then
		Material.set_texture(material, "diffuse_map", arg_42_3)
	end
end

StoreItemPurchasePopup._load_texture_package = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	local flag = true
	local flag_2 = true

	Managers.package:load(arg_43_1, arg_43_2, arg_43_3, flag, flag_2)

	arg_43_0._loaded_package_names[arg_43_2] = arg_43_1
end

StoreItemPurchasePopup._is_unique_reference_to_material = function (self, arg_44_1)
	-- function 44
	local _cloned_materials_by_reference = self._cloned_materials_by_reference
	local var_44_1 = _cloned_materials_by_reference[arg_44_1]

	fassert(var_44_1, "[StoreItemPurchasePopup] - Could not find a used material for reference name: (%s)", arg_44_1)

	for k, v in pairs(_cloned_materials_by_reference) do
		if not (var_44_1 ~= v or arg_44_1 == k) then
			return false
		end
	end

	return true
end

StoreItemPurchasePopup._unload_texture_by_reference = function (self, arg_45_1)
	-- function 45
	local _loaded_package_names = self._loaded_package_names
	local _cloned_materials_by_reference = self._cloned_materials_by_reference
	local var_45_2 = _loaded_package_names[arg_45_1]

	fassert(var_45_2, "[StoreItemPurchasePopup] - Could not find a package to unload for reference name: (%s)", arg_45_1)
	Managers.package:unload(var_45_2, arg_45_1)

	_loaded_package_names[arg_45_1] = nil

	if not self:_is_unique_reference_to_material(arg_45_1) then
		local var_45_3 = _cloned_materials_by_reference[arg_45_1]
		local gui = self._purchase_ui_renderer.gui

		self:_set_material_diffuse(gui, var_45_3, str)
	end

	_cloned_materials_by_reference[arg_45_1] = nil
end

StoreItemPurchasePopup._unload_all_textures = function (self)
	-- function 46
	local _loaded_package_names = self._loaded_package_names

	for k, v in pairs(_loaded_package_names) do
		self:_unload_texture_by_reference(k)
	end
end

StoreItemPurchasePopup._calculate_discount_textures = function (arg_47_0, arg_47_1, arg_47_2)
	-- function 47
	local content = arg_47_1.content
	local discont_number_icons = arg_47_1.style.discont_number_icons
	local discont_number_icons_2 = content.discont_number_icons
	local texture_sizes = discont_number_icons.texture_sizes
	local texture_offsets = discont_number_icons.texture_offsets
	local num = 0
	local num_2 = 9
	local var_47_7 = tostring(math.abs(math.floor(arg_47_2)))
	local len = string.len(var_47_7)

	local function fn(arg_48_0)
		-- function 48
		local str = "store_number_" .. arg_48_0
		local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
		local tbl = {
			get_atlas_settings_by_texture_name.size[1],
			get_atlas_settings_by_texture_name.size[2]
		}
		local num_3 = #texture_offsets + 1

		discont_number_icons_2[num_3] = str
		texture_sizes[num_3] = tbl

		local num_4 = -(num * 0.5 + num_2 * 0.5 * num_3)
		local num_5 = num_2 * num_3

		texture_offsets[num_3] = {
			num_4,
			num_5,
			0
		}
		num = num + tbl[1]
	end

	if arg_47_2 > 0 then
		fn("minus")
	end

	for i = 1, len do
		local sub = string.sub(var_47_7, i, i)

		fn(sub)
	end

	fn("percent")

	content.discount = true
end

StoreItemPurchasePopup._start_transition_animation = function (self, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings,
		product_widget = self._product_widget
	}
	local flag = arg_49_3 or self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_49_2, flag, tbl_4, tbl)

	self._animations[arg_49_1] = start_animation

	return tbl
end

StoreItemPurchasePopup._popup_on_enter = function (self)
	-- function 50
	local _product = self._product
	local product_item = _product.product_item

	product_item = product_item or _product.item

	local data = product_item.data
	local rarity = data.rarity
	local item_type = data.item_type
	local _widgets_by_name = self._widgets_by_name
	local get_ui_information_from_item, var_50_7 = UIUtils.get_ui_information_from_item(product_item)
	local item_name_text = _widgets_by_name.item_name_text

	item_name_text.content.text = Localize(var_50_7)

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(rarity, 255)

	item_name_text.style.text.text_color = get_color_table_with_alpha

	local str = "purchase_item_root"
	local _create_popup_widget = self:_create_popup_widget(_product, str)

	self._product_widget = _create_popup_widget

	local size = _create_popup_widget.content.size

	_create_popup_widget.offset[1] = -size[1] / 2
	_create_popup_widget.offset[2] = size[2]

	local purchase_button = self._widgets_by_name.purchase_button

	if not purchase_button then
		purchase_button.content.present_currency = false

		local style = purchase_button.style

		style.title_text.offset[1] = 0
		style.title_text.horizontal_alignment = "center"
		style.title_text_disabled.horizontal_alignment = "center"
		style.title_text_disabled.offset[1] = 0
		style.title_text_write_mask.offset[1] = 0
		style.title_text_write_mask.horizontal_alignment = "center"
		style.title_text_shadow.offset[1] = 2
		style.title_text_shadow.horizontal_alignment = "center"
	end

	local item_type_text = self._widgets_by_name.item_type_text

	if not item_type_text then
		item_type_text.content.text = item_type
	end

	local str_2 = "on_enter"

	self:_start_transition_animation(str_2, str_2, self._widgets_by_name)
end

StoreItemPurchasePopup._create_popup_widget = function (self, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	local _product = self._product
	local product_id = _product.product_id
	local product_item = _product.product_item

	product_item = product_item or _product.item

	local flag = false
	local tbl = {
		260,
		220
	}
	local create_store_item_definition = UIWidgets.create_store_item_definition(arg_51_2, tbl, flag, _product)
	local var_51_6 = UIWidget.init(create_store_item_definition)

	self:_populate_item_widget(var_51_6, product_item, product_id, arg_51_3)

	return var_51_6
end

StoreItemPurchasePopup._popup_update = function (self, arg_52_1, arg_52_2, arg_52_3)
	-- function 52
	local get = arg_52_1:get("toggle_menu", true)
	local get_2 = arg_52_1:get("back_menu", true)
	local get_3 = arg_52_1:get("confirm_press", true)
	local _widgets_by_name = self._widgets_by_name
	local purchase_button = _widgets_by_name.purchase_button
	local close_button = _widgets_by_name.close_button

	UIWidgetUtils.animate_default_button(purchase_button, arg_52_2)
	UIWidgetUtils.animate_default_button(close_button, arg_52_2)

	if get_2 or get or not self:_is_button_pressed(close_button) then
		self:_play_sound("Play_hud_select")
		self:_change_state("aborted")
	else
		if self:_is_button_hover_enter(purchase_button) or not self:_is_button_hover_enter(close_button) then
			self:_play_sound("Play_hud_hover")
		end

		if self:_is_button_pressed(purchase_button) or not get_3 then
			self:_play_sound("Play_hud_store_button_buy")
			self:_change_state("poll_result")
		end
	end
end

StoreItemPurchasePopup._popup_on_exit = function (self)
	-- function 53
	self:_destroy_product_widget(self._product_widget, self._product)

	self._product_widget = nil
	self._blur_progress = nil
end

StoreItemPurchasePopup._poll_result_on_enter = function (self)
	-- function 54
	local currency_ui_settings = DLCSettings.store.currency_ui_settings
	local _product = self._product
	local product_item = _product.product_item

	product_item = product_item or _product.item

	local key = product_item.key
	local regular_prices = product_item.regular_prices
	local current_prices = product_item.current_prices
	local str = "SM"

	if regular_prices or not current_prices then
		for k, v in pairs(currency_ui_settings) do
			local var_54_7 = regular_prices[k]
			local var_54_8 = current_prices[k]

			if not var_54_7 and not var_54_8 then
				str = k

				break
			end
		end
	end

	local var_54_9 = current_prices[str]

	var_54_9 = var_54_9 or regular_prices[str]

	local var_54_10 = var_54_9
	local var_54_11 = callback(self, "_backend_result_callback")

	Managers.backend:get_interface("peddler"):exchange_chips(key, str, var_54_10, var_54_11)
end

StoreItemPurchasePopup._backend_result_callback = function (self, arg_55_1, arg_55_2)
	-- function 55
	if not self._destroyed then
		return
	end

	print("_backend_result_callback", arg_55_1)

	if not arg_55_1 then
		Managers.telemetry_events:store_product_purchased(self._product)
		self:_change_state("approved")
	else
		self:_change_state("exit")
	end
end

local tbl_9 = {
	common = "store_thumbnail_bg_common",
	promo = "store_thumbnail_bg_promo",
	plentiful = "store_thumbnail_bg_plentiful",
	rare = "store_thumbnail_bg_rare",
	exotic = "store_thumbnail_bg_exotic",
	magic = "store_thumbnail_bg_magic",
	unique = "store_thumbnail_bg_unique"
}

StoreItemPurchasePopup._populate_item_widget = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	-- function 56
	local item_rarity_textures = UISettings.item_rarity_textures
	local item_type_store_icons = UISettings.item_type_store_icons
	local currency_ui_settings = DLCSettings.store.currency_ui_settings
	local data = arg_56_2.data
	local var_56_4
	local flag = false
	local var_56_6
	local var_56_7
	local var_56_8
	local var_56_9

	if not arg_56_2.data and not arg_56_2.data.parent then
		local var_56_10 = ItemMasterList[arg_56_2.data.parent]

		var_56_6 = var_56_10.inventory_icon

		local display_name = var_56_10.display_name
		local description = var_56_10.description

		var_56_9 = var_56_10.rarity
		var_56_4 = arg_56_2.data.parent
		flag = true
	else
		local var_56_13, var_56_14

		var_56_6, var_56_13, var_56_14 = UIUtils.get_ui_information_from_item(arg_56_2)
		var_56_9 = arg_56_2.rarity or data.rarity
	end

	local item_type = data.item_type
	local content = arg_56_1.content
	local style = arg_56_1.style
	local masked = style.icon.masked

	content.background = tbl_9[var_56_9]

	local var_56_19 = style.overlay.offset[3]
	local var_56_20 = style.icon.offset[3]

	style.icon.offset[3] = var_56_19
	style.overlay.offset[3] = var_56_20

	local str = "SM"
	local regular_prices = arg_56_2.regular_prices
	local current_prices = arg_56_2.current_prices

	if regular_prices or not current_prices then
		for k, v in pairs(currency_ui_settings) do
			local var_56_24 = regular_prices[k]
			local var_56_25 = current_prices[k]

			if not var_56_24 and not var_56_25 then
				str = k

				break
			end
		end

		local var_56_26 = regular_prices[str]
		local var_56_27 = current_prices[str]

		if var_56_27 ~= var_56_26 then
			local num = 1 - var_56_27 / var_56_26

			self:_calculate_discount_textures(arg_56_1, math.round(100 * num))
		end

		local flag_2 = false
		local comma_value = UIUtils.comma_value(tostring(var_56_27))

		self:_set_product_price_text(arg_56_1, comma_value, flag_2)

		content.price_icon = currency_ui_settings[str].icon_small
	end

	local get_interface = Managers.backend:get_interface("items")
	local key = arg_56_2.key
	local has_item = get_interface:has_item(key)
	local data_2 = arg_56_2.data
	local item_type_2 = data_2.item_type

	content.owned = arg_56_4 or has_item

	local allowed_store_item_types = DLCSettings.store.allowed_store_item_types
	local var_56_37

	if not allowed_store_item_types[item_type_2] then
		var_56_37 = item_type_store_icons[item_type_2]

		if not (not var_56_9 and var_56_9 == "default") then
			var_56_37 = var_56_37 .. "_" .. var_56_9
		end
	else
		var_56_37 = item_type_store_icons[item_type_2] or item_type_store_icons.default
	end

	content.type_tag_icon = var_56_37

	local gui = self._purchase_ui_renderer.gui
	local store_icon_override_key = data_2.store_icon_override_key
	local _reference_id = self._reference_id

	_reference_id = _reference_id or 0
	self._reference_id = _reference_id + 1

	local str_2 = "StoreItemPurchasePopup_" .. arg_56_3 .. "_" .. self._reference_id
	local flag_3 = not flag and not var_56_4 and var_56_4 and store_icon_override_key or arg_56_3
	local str_3 = "store_item_icon_" .. flag_3
	local str_4 = "resource_packages/store/item_icons/" .. str_3

	if not Application.can_get("package", str_4) then
		content.reference_name = str_2

		local str_5

		if not masked then
			str_5 = str_3 .. "_masked"

			if not str_5 then
				-- Nothing
			end
		end

		str_5 = str_3

		do
			local flag_4
		end

		::label_56_0::

		flag_4 = not masked and "template_store_diffuse_masked" and "template_store_diffuse"

		self:_create_material_instance(gui, str_5, flag_4, str_2)

		local function fn()
			-- function 57
			if not self._destroyed then
				return
			end

			local str = "gui/1080p/single_textures/store_item_icons/" .. str_3 .. "/" .. str_3

			self:_set_material_diffuse(gui, str_5, str)

			content.icon = str_5
		end

		self:_load_texture_package(str_4, str_2, fn)
	else
		content.icon = var_56_6

		Application.warning("Icon package not accessable for product_id: (%s) and texture_name: (%s)", arg_56_3, str_3)
	end
end

StoreItemPurchasePopup._set_product_price_text = function (self, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	local content = arg_58_1.content
	local style = arg_58_1.style
	local var_58_2
	local num = 0
	local num_2

	if not arg_58_3 then
		var_58_2 = style.price_text
		var_58_2.offset[1] = 23
		content.price_text = arg_58_2
		content.draw_price_icon = false
		num_2 = -20
	else
		var_58_2 = style.price_text
		var_58_2.offset[1] = 50
		content.price_text = arg_58_2
		content.draw_price_icon = true
		num_2 = 5
	end

	local get_text_width = UIUtils.get_text_width(self._purchase_ui_renderer, var_58_2, arg_58_2)
	local background_price_right = style.background_price_right
	local var_58_7 = background_price_right.default_size[1]
	local max = math.max(math.ceil(get_text_width - var_58_7) + num_2, 0)

	style.background_price_center.texture_size[1] = max
	background_price_right.offset[1] = background_price_right.default_offset[1] + max
end

StoreItemPurchasePopup._approved_on_enter = function (self)
	-- function 59
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, tbl_3)

	local _product = self._product
	local flag = true
	local str = "purchase_confirmation_approved"
	local _create_popup_widget = self:_create_popup_widget(_product, str, flag)

	self._product_widget = _create_popup_widget

	local size = _create_popup_widget.content.size

	_create_popup_widget.offset[1] = -size[1] / 2
	_create_popup_widget.offset[2] = -size[2] / 2

	self:_create_ui_elements()

	local str_2 = "approved"

	self._approved_anim_params = self:_start_transition_animation(str_2, str_2, self._widgets_by_name)
	self._widgets_by_name.approved.content.visible = true
	self._purchase_confirmation_anim_duration = 0
	self._widgets_by_name.approved.content.visible = true
end

StoreItemPurchasePopup._approved_update = function (self, arg_60_1, arg_60_2, arg_60_3)
	-- function 60
	local _purchase_confirmation_anim_duration = self._purchase_confirmation_anim_duration

	if not _purchase_confirmation_anim_duration then
		return
	end

	local num = _purchase_confirmation_anim_duration + arg_60_2
	local min = math.min(num / 3, 1)
	local easeOutCubic = math.easeOutCubic(min)
	local _widgets_by_name = self._widgets_by_name
	local approved = _widgets_by_name.approved

	if min == 1 then
		_widgets_by_name.loading_icon.content.fade_out = false
		self._purchase_confirmation_anim_duration = nil
		self._approved_anim_params = nil

		self:_change_state("exit")
	else
		local blur_progress = self._approved_anim_params.blur_progress

		if not blur_progress then
			self._blur_progress = blur_progress
		end

		self._purchase_confirmation_anim_duration = num
	end
end
