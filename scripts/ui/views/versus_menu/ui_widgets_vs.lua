-- chunkname: @scripts/ui/views/versus_menu/ui_widgets_vs.lua

UIWidgets = UIWidgets or {}

function UIWidgets.create_new_widget_definition(arg_1_0, arg_1_1)
	return {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		offset = arg_1_1 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

function UIWidgets.add_portrait_frame(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	local var_2_0 = arg_2_0.element.passes
	local var_2_1 = {}
	local var_2_2 = arg_2_0.style
	local var_2_3 = "portrait_frame"

	arg_2_0.content[var_2_3] = var_2_1
	arg_2_4 = arg_2_4 or 1

	local var_2_4 = UIPlayerPortraitFrameSettings[arg_2_2]
	local var_2_5 = {
		255,
		255,
		255,
		255
	}
	local var_2_6 = {
		0,
		-60,
		0
	}

	for iter_2_0, iter_2_1 in ipairs(var_2_4) do
		local var_2_7 = "frame_texture_" .. iter_2_0
		local var_2_8 = iter_2_1.texture or "icons_placeholder"
		local var_2_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_2_8)
		local var_2_10 = iter_2_1.size or var_2_9.size
		local var_2_11

		var_2_11 = var_2_10 and table.clone(var_2_10) or {
			0,
			0
		}
		var_2_11[1] = var_2_11[1] * arg_2_4
		var_2_11[2] = var_2_11[2] * arg_2_4

		local var_2_12 = table.clone(iter_2_1.offset or var_2_6)

		var_2_12[1] = -(var_2_11[1] / 2) + var_2_12[1] * arg_2_4
		var_2_12[2] = var_2_12[2] * arg_2_4
		var_2_12[3] = iter_2_1.layer or 0
		var_2_0[#var_2_0 + 1] = {
			pass_type = "texture",
			texture_id = var_2_7,
			style_id = var_2_7,
			content_id = var_2_3,
			retained_mode = arg_2_5
		}
		var_2_1[var_2_7] = var_2_8
		var_2_2[var_2_7] = {
			color = iter_2_1.color or var_2_5,
			offset = var_2_12,
			size = var_2_11,
			scenegraph_id = arg_2_1
		}
	end

	local var_2_13 = {
		86,
		108
	}

	var_2_13[1] = var_2_13[1] * arg_2_4
	var_2_13[2] = var_2_13[2] * arg_2_4

	if arg_2_6 then
		local var_2_14 = {
			0,
			0,
			0
		}

		var_2_14[1] = -(var_2_13[1] / 2) + var_2_14[1] * arg_2_4
		var_2_14[2] = -(var_2_13[2] / 2) + var_2_14[2] * arg_2_4
		var_2_14[3] = 1

		local var_2_15 = "portrait"

		var_2_0[#var_2_0 + 1] = {
			pass_type = "texture",
			texture_id = var_2_15,
			style_id = var_2_15,
			content_id = var_2_3,
			retained_mode = arg_2_5
		}
		var_2_1[var_2_15] = arg_2_6
		var_2_2[var_2_15] = {
			color = var_2_5,
			offset = var_2_14,
			size = var_2_13,
			scenegraph_id = arg_2_1
		}
	end

	local var_2_16 = {
		22,
		15
	}
	local var_2_17 = {
		0,
		0,
		0
	}

	var_2_17[1] = var_2_17[1] * arg_2_4 - var_2_16[1] / 2 - 1
	var_2_17[2] = -(var_2_13[2] / 2) + var_2_17[2] * arg_2_4 - 4
	var_2_17[3] = 15

	local var_2_18 = "level"

	var_2_0[#var_2_0 + 1] = {
		pass_type = "text",
		text_id = var_2_18,
		style_id = var_2_18,
		content_id = var_2_3,
		retained_mode = arg_2_5
	}
	var_2_1[var_2_18] = arg_2_3
	var_2_2[var_2_18] = {
		vertical_alignment = "center",
		font_size = 12,
		horizontal_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = var_2_17,
		size = var_2_16,
		scenegraph_id = arg_2_1
	}
end

function UIWidgets.add_hotspot(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.element.passes
	local var_3_1 = {}
	local var_3_2 = arg_3_0.style

	arg_3_0.content[arg_3_1] = var_3_1
	var_3_0[#var_3_0 + 1] = {
		pass_type = "hotspot",
		content_id = arg_3_1,
		style_id = arg_3_2
	}
end

function UIWidgets.add_hover_glow(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0.element.passes
	local var_4_1 = arg_4_0.content
	local var_4_2 = arg_4_0.style

	var_4_0[#var_4_0 + 1] = {
		pass_type = "texture",
		texture_id = arg_4_2,
		style_id = arg_4_4,
		content_check_function = function(arg_5_0)
			return arg_5_0[arg_4_3].is_hover or arg_5_0.force_hover
		end
	}
	var_4_1[arg_4_2] = arg_4_1
end

function UIWidgets.add_simple_text(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8)
	local var_6_0 = arg_6_0.element.passes
	local var_6_1 = arg_6_0.content
	local var_6_2 = arg_6_0.style

	var_6_0[#var_6_0 + 1] = {
		pass_type = "text",
		text_id = arg_6_1,
		style_id = arg_6_1,
		retained_mode = arg_6_8,
		content_check_function = function(arg_7_0)
			return arg_7_0[arg_6_1]
		end
	}
	var_6_0[#var_6_0 + 1] = {
		pass_type = "text",
		text_id = arg_6_1,
		style_id = arg_6_1,
		retained_mode = arg_6_8,
		content_check_function = function(arg_8_0)
			return arg_8_0[arg_6_1]
		end
	}
	var_6_1[arg_6_1] = arg_6_3

	local var_6_3 = arg_6_6 and arg_6_6.offset or {
		0,
		0,
		0
	}
	local var_6_4 = arg_6_6 and arg_6_6.text_color or arg_6_5 or {
		255,
		255,
		255,
		255
	}

	arg_6_6 = arg_6_6 or {
		vertical_alignment = "center",
		localize = true,
		horizontal_alignment = "center",
		word_wrap = true,
		font_size = arg_6_4,
		font_type = arg_6_7 or "hell_shark",
		text_color = var_6_4,
		offset = var_6_3
	}
	arg_6_6.scenegraph_id = arg_6_2

	local var_6_5 = table.clone(arg_6_6)
	local var_6_6 = arg_6_6.shadow_color or {
		255,
		0,
		0,
		0
	}

	var_6_6[1] = var_6_4[1]
	var_6_5.text_color = var_6_6
	var_6_5.offset = {
		var_6_3[1] + 2,
		var_6_3[2] - 2,
		var_6_3[3] - 1
	}
	var_6_2[arg_6_1] = arg_6_6
	var_6_2[arg_6_1 .. "_shadow"] = var_6_5
end

function UIWidgets.add_ready_icon(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.element.passes
	local var_9_1 = {}
	local var_9_2 = arg_9_0.style

	arg_9_0.content[arg_9_1] = var_9_1
	var_9_1.ready = false
	var_9_1.ready_texture = "matchmaking_checkbox"

	local var_9_3 = {
		37,
		31
	}
	local var_9_4 = "not_ready"

	var_9_0[#var_9_0 + 1] = {
		texture_id = "ready_texture",
		pass_type = "texture",
		content_id = arg_9_1,
		style_id = var_9_4,
		content_check_function = function(arg_10_0)
			return arg_10_0.slot_taken and not arg_10_0.ready
		end
	}
	var_9_2[var_9_4] = {
		size = table.clone(var_9_3),
		offset = arg_9_3 or {
			0,
			0,
			0
		},
		color = {
			255,
			255,
			0,
			0
		},
		scenegraph_id = arg_9_2
	}

	local var_9_5 = "ready"

	var_9_0[#var_9_0 + 1] = {
		texture_id = "ready_texture",
		pass_type = "texture",
		content_id = arg_9_1,
		style_id = var_9_5,
		content_check_function = function(arg_11_0)
			return arg_11_0.slot_taken and arg_11_0.ready
		end
	}
	var_9_2[var_9_5] = {
		size = table.clone(var_9_3),
		offset = arg_9_3 or {
			0,
			0,
			0
		},
		color = {
			255,
			0,
			255,
			0
		},
		scenegraph_id = arg_9_2
	}
end

function UIWidgets.add_loadout_grid(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	local var_12_0 = arg_12_0.element.passes
	local var_12_1 = arg_12_0.content
	local var_12_2 = arg_12_0.style
	local var_12_3 = {
		255,
		255,
		255,
		255
	}
	local var_12_4 = {
		255,
		255,
		255,
		255
	}
	local var_12_5 = Colors.get_color_table_with_alpha("dim_gray", 40)
	local var_12_6 = Colors.get_color_table_with_alpha("white", 150)
	local var_12_7 = {
		60,
		60
	}
	local var_12_8 = {
		60,
		60
	}
	local var_12_9 = 1

	if arg_12_6 then
		var_12_9 = arg_12_4
		arg_12_4 = 1
	end

	local var_12_10 = arg_12_5 or 30
	local var_12_11 = arg_12_5 or 30
	local var_12_12 = arg_12_3[1]
	local var_12_13 = arg_12_3[2]

	var_12_1.rows = arg_12_4
	var_12_1.columns = var_12_9
	var_12_1.slots = arg_12_4 * var_12_9

	local var_12_14 = var_12_12 - (var_12_9 * var_12_8[1] + var_12_10 * (var_12_9 - 1))
	local var_12_15 = var_12_13 - (arg_12_4 * var_12_8[2] + var_12_11 * (arg_12_4 - 1))
	local var_12_16 = {
		arg_12_6 and var_12_14 / 2 or var_12_14 / 2,
		var_12_13 - var_12_15 / 2 - var_12_8[2]
	}

	arg_12_7 = arg_12_7 or {
		0,
		0,
		0
	}

	local var_12_17 = 0

	for iter_12_0 = 1, arg_12_4 do
		for iter_12_1 = 1, var_12_9 do
			local var_12_18 = "_" .. tostring(iter_12_0) .. "_" .. tostring(iter_12_1)
			local var_12_19 = iter_12_0 - 1
			local var_12_20 = iter_12_1 - 1
			local var_12_21 = arg_12_1 .. var_12_18
			local var_12_22 = {}

			arg_12_0.content[var_12_21] = var_12_22

			local var_12_23 = {
				arg_12_7[1] + var_12_16[1] + var_12_20 * (var_12_8[1] + var_12_10),
				arg_12_7[2] + var_12_16[2] - var_12_19 * (var_12_8[2] + var_12_11),
				arg_12_7[3] + var_12_17
			}
			local var_12_24 = arg_12_1 .. "_hotspot" .. var_12_18

			var_12_0[#var_12_0 + 1] = {
				pass_type = "hotspot",
				content_id = var_12_21,
				style_id = var_12_24
			}
			var_12_2[var_12_24] = {
				size = var_12_8,
				offset = var_12_23,
				scenegraph_id = arg_12_2
			}
			var_12_22.drag_texture_size = var_12_8

			local var_12_25 = "item_icon" .. var_12_18

			var_12_0[#var_12_0 + 1] = {
				pass_type = "texture",
				content_id = var_12_21,
				texture_id = var_12_25,
				style_id = var_12_25,
				content_check_function = function(arg_13_0)
					return arg_13_0[var_12_25]
				end
			}
			var_12_2[var_12_25] = {
				size = var_12_7,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_12_23[1],
					var_12_23[2],
					3
				},
				scenegraph_id = arg_12_2
			}

			local var_12_26 = "item_frame" .. var_12_18

			var_12_0[#var_12_0 + 1] = {
				pass_type = "texture",
				content_id = var_12_21,
				texture_id = var_12_26,
				style_id = var_12_26,
				content_check_function = function(arg_14_0)
					return arg_14_0[var_12_25]
				end
			}
			var_12_2[var_12_26] = {
				size = var_12_7,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_12_23[1],
					var_12_23[2],
					4
				},
				scenegraph_id = arg_12_2
			}
			var_12_22[var_12_26] = "item_frame"

			local var_12_27 = "rarity_texture" .. var_12_18

			var_12_0[#var_12_0 + 1] = {
				pass_type = "texture",
				content_id = var_12_21,
				texture_id = var_12_27,
				style_id = var_12_27,
				content_check_function = function(arg_15_0)
					return arg_15_0[var_12_25]
				end
			}
			var_12_2[var_12_27] = {
				size = var_12_7,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_12_23[1],
					var_12_23[2],
					0
				},
				scenegraph_id = arg_12_2
			}
			var_12_22[var_12_27] = "icon_bg_default"

			local var_12_28 = "slot" .. var_12_18

			var_12_0[#var_12_0 + 1] = {
				pass_type = "texture",
				content_id = var_12_21,
				texture_id = var_12_28,
				style_id = var_12_28,
				content_check_function = function(arg_16_0)
					return not arg_16_0[var_12_25]
				end
			}
			var_12_2[var_12_28] = {
				size = var_12_8,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_12_23[1],
					var_12_23[2],
					0
				},
				scenegraph_id = arg_12_2
			}
			var_12_22[var_12_28] = "menu_slot_frame_01"

			local var_12_29 = "slot_icon" .. var_12_18

			var_12_0[#var_12_0 + 1] = {
				pass_type = "texture",
				content_id = var_12_21,
				texture_id = var_12_29,
				style_id = var_12_29,
				content_check_function = function(arg_17_0)
					return not arg_17_0[var_12_25]
				end
			}
			var_12_2[var_12_29] = {
				size = {
					34,
					34
				},
				color = {
					200,
					100,
					100,
					100
				},
				offset = {
					var_12_23[1] + (var_12_8[1] - 34) / 2,
					var_12_23[2] + (var_12_8[2] - 34) - (var_12_8[1] - 34) / 2,
					2
				},
				scenegraph_id = arg_12_2
			}
			var_12_22[var_12_29] = "tabs_icon_all_selected"

			local var_12_30 = "slot_hover" .. var_12_18

			var_12_0[#var_12_0 + 1] = {
				pass_type = "texture",
				content_id = var_12_21,
				texture_id = var_12_30,
				style_id = var_12_30,
				content_check_function = function(arg_18_0)
					return arg_18_0.highlight or arg_18_0.is_hover
				end
			}
			var_12_2[var_12_30] = {
				size = {
					96,
					96
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_12_23[1] - (96 - var_12_8[1]) / 2,
					var_12_23[2] - (96 - var_12_8[2]) / 2,
					0
				},
				scenegraph_id = arg_12_2
			}
			var_12_22[var_12_30] = "item_icon_hover"

			local var_12_31 = "slot_selected" .. var_12_18

			var_12_0[#var_12_0 + 1] = {
				pass_type = "texture",
				content_id = var_12_21,
				texture_id = var_12_31,
				style_id = var_12_31,
				content_check_function = function(arg_19_0)
					return arg_19_0.is_selected
				end
			}
			var_12_2[var_12_31] = {
				size = {
					80,
					80
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_12_23[1] - (80 - var_12_8[1]) / 2,
					var_12_23[2] - (80 - var_12_8[2]) / 2,
					8
				},
				scenegraph_id = arg_12_2
			}
			var_12_22[var_12_31] = "item_icon_selection"
		end
	end
end

function UIWidgets.create_player_panel_widget(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = "talent_tree_bg_01"
	local var_20_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_20_0)
	local var_20_2 = "button_frame_02"
	local var_20_3 = UIFrameSettings[var_20_2]
	local var_20_4 = "shadow_frame_02"
	local var_20_5 = UIFrameSettings[var_20_4]
	local var_20_6 = "frame_outer_glow_04"
	local var_20_7 = UIFrameSettings[var_20_6]
	local var_20_8 = "frame_outer_glow_01"
	local var_20_9 = UIFrameSettings[var_20_8]
	local var_20_10 = "frame_bevel_01"
	local var_20_11 = UIFrameSettings[var_20_10]
	local var_20_12 = 5
	local var_20_13 = 4
	local var_20_14 = {
		arg_20_1[2] / 2 - var_20_13,
		arg_20_1[2] / 2 - var_20_13
	}
	local var_20_15 = {
		arg_20_2 and arg_20_1[1] + var_20_12 or -(var_20_14[1] + var_20_12),
		arg_20_1[2] - var_20_14[2],
		0
	}
	local var_20_16 = {
		arg_20_2 and arg_20_1[1] + var_20_12 or -(var_20_14[1] + var_20_12),
		0,
		0
	}
	local var_20_17 = {
		element = {}
	}
	local var_20_18 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background",
			content_check_function = function(arg_21_0)
				return not arg_21_0.parent.empty
			end
		},
		{
			pass_type = "texture",
			style_id = "ready_texture",
			texture_id = "ready_texture",
			content_check_function = function(arg_22_0)
				return arg_22_0.ready
			end
		},
		{
			pass_type = "texture",
			style_id = "unready_texture",
			texture_id = "unready_texture",
			content_check_function = function(arg_23_0)
				return not arg_23_0.ready and not arg_23_0.empty
			end
		},
		{
			style_id = "empty_background",
			pass_type = "rect",
			content_check_function = function(arg_24_0)
				return arg_24_0.empty
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame",
			content_check_function = function(arg_25_0)
				local var_25_0 = arg_25_0.button_hotspot

				return not arg_25_0.empty and arg_25_0.is_local_player and var_25_0.is_hover
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "empty_hover_frame",
			texture_id = "empty_hover_frame",
			content_check_function = function(arg_26_0)
				local var_26_0 = arg_26_0.button_hotspot

				return arg_26_0.empty and var_26_0.is_hover
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "empty_frame",
			texture_id = "empty_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame",
			content_check_function = function(arg_27_0)
				return not arg_27_0.empty
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "shadow_frame",
			texture_id = "shadow_frame",
			content_check_function = function(arg_28_0)
				return not arg_28_0.empty
			end
		},
		{
			style_id = "open_slot_text",
			pass_type = "text",
			text_id = "open_slot_text",
			content_check_function = function(arg_29_0)
				return arg_29_0.empty
			end
		},
		{
			style_id = "open_slot_text_shadow",
			pass_type = "text",
			text_id = "open_slot_text",
			content_check_function = function(arg_30_0)
				return arg_30_0.empty
			end
		},
		{
			style_id = "player_name",
			pass_type = "text",
			text_id = "player_name",
			content_check_function = function(arg_31_0)
				return not arg_31_0.empty
			end
		},
		{
			style_id = "career_name",
			pass_type = "text",
			text_id = "career_name",
			content_check_function = function(arg_32_0)
				return not arg_32_0.empty
			end
		},
		{
			style_id = "item_slot_bg_1",
			pass_type = "hotspot",
			content_id = "item_hotspot_1",
			content_check_function = function(arg_33_0)
				return arg_33_0.parent.is_local_player
			end
		},
		{
			style_id = "item_slot_bg_2",
			pass_type = "hotspot",
			content_id = "item_hotspot_2",
			content_check_function = function(arg_34_0)
				return arg_34_0.parent.is_local_player
			end
		},
		{
			style_id = "item_slot_bg_1",
			pass_type = "rect",
			content_check_function = function(arg_35_0)
				return arg_35_0.is_local_player
			end
		},
		{
			pass_type = "texture",
			style_id = "item_icon_1",
			texture_id = "item_icon_1",
			content_check_function = function(arg_36_0)
				return arg_36_0.is_local_player
			end
		},
		{
			pass_type = "texture",
			style_id = "item_icon_2",
			texture_id = "item_icon_2",
			content_check_function = function(arg_37_0)
				return arg_37_0.is_local_player
			end
		},
		{
			style_id = "item_slot_bg_2",
			pass_type = "rect",
			content_check_function = function(arg_38_0)
				return arg_38_0.is_local_player
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "item_slot_hover_1",
			texture_id = "hover_frame",
			content_check_function = function(arg_39_0)
				local var_39_0 = arg_39_0.item_hotspot_1

				return arg_39_0.is_local_player and var_39_0.is_hover
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "item_slot_hover_2",
			texture_id = "hover_frame",
			content_check_function = function(arg_40_0)
				local var_40_0 = arg_40_0.item_hotspot_2

				return arg_40_0.is_local_player and var_40_0.is_hover
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "item_slot_frame_1",
			texture_id = "frame",
			content_check_function = function(arg_41_0)
				return arg_41_0.is_local_player
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "item_slot_frame_2",
			texture_id = "frame",
			content_check_function = function(arg_42_0)
				return arg_42_0.is_local_player
			end
		}
	}
	local var_20_19 = {
		unready_texture = "ping_icon_03",
		item_icon_2 = "ping_icon_01",
		empty = true,
		player_name = "player_name",
		is_local_player = false,
		ready_texture = "ping_icon_01",
		item_icon_1 = "ping_icon_01",
		career_name = "career_name",
		button_hotspot = {},
		item_hotspot_1 = {},
		item_hotspot_2 = {},
		frame = var_20_3.texture,
		shadow_frame = var_20_5.texture,
		hover_frame = var_20_7.texture,
		empty_hover_frame = var_20_9.texture,
		empty_frame = var_20_11.texture,
		background = {
			uvs = {
				{
					0.5,
					1
				},
				{
					0.5 - math.min(arg_20_1[1] / var_20_1.size[1], 1),
					1 - math.min(arg_20_1[2] / var_20_1.size[2], 1)
				}
			},
			texture_id = var_20_0
		},
		open_slot_text = Localize("vs_lobby_slot_available")
	}
	local var_20_20 = {
		empty_background = {
			color = {
				80,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		item_icon_1 = {
			color = {
				255,
				255,
				255,
				255
			},
			size = var_20_14,
			offset = {
				var_20_15[1],
				var_20_15[2],
				1
			}
		},
		item_icon_2 = {
			color = {
				255,
				255,
				255,
				255
			},
			size = var_20_14,
			offset = {
				var_20_16[1],
				var_20_16[2],
				1
			}
		},
		item_slot_bg_1 = {
			color = {
				80,
				0,
				0,
				0
			},
			size = var_20_14,
			offset = var_20_15
		},
		item_slot_bg_2 = {
			color = {
				80,
				0,
				0,
				0
			},
			size = var_20_14,
			offset = var_20_16
		},
		item_slot_hover_1 = {
			size = var_20_14,
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_3.texture_size,
			texture_sizes = var_20_3.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_20_15[1],
				var_20_15[2],
				2
			}
		},
		item_slot_hover_2 = {
			size = var_20_14,
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_3.texture_size,
			texture_sizes = var_20_3.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_20_16[1],
				var_20_16[2],
				2
			}
		},
		item_slot_frame_1 = {
			size = var_20_14,
			texture_size = var_20_11.texture_size,
			texture_sizes = var_20_11.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_20_16[1],
				var_20_15[2],
				4
			}
		},
		item_slot_frame_2 = {
			size = var_20_14,
			texture_size = var_20_11.texture_size,
			texture_sizes = var_20_11.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_20_16[1],
				var_20_16[2],
				4
			}
		},
		frame = {
			texture_size = var_20_3.texture_size,
			texture_sizes = var_20_3.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				3
			}
		},
		empty_frame = {
			texture_size = var_20_11.texture_size,
			texture_sizes = var_20_11.texture_sizes,
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
		shadow_frame = {
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_5.texture_size,
			texture_sizes = var_20_5.texture_sizes,
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		hover_frame = {
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_7.texture_size,
			texture_sizes = var_20_7.texture_sizes,
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
		empty_hover_frame = {
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_9.texture_size,
			texture_sizes = var_20_9.texture_sizes,
			color = {
				255,
				100,
				100,
				100
			},
			offset = {
				0,
				0,
				2
			}
		},
		ready_texture = {
			vertical_alignment = "center",
			texture_size = {
				54,
				50
			},
			horizontal_alignment = arg_20_2 and "left" or "right",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_20_2 and -55 or 55,
				0,
				1
			}
		},
		unready_texture = {
			vertical_alignment = "center",
			texture_size = {
				54,
				50
			},
			horizontal_alignment = arg_20_2 and "left" or "right",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_20_2 and -55 or 55,
				0,
				1
			}
		},
		background = {
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
		open_slot_text = {
			word_wrap = true,
			upper_case = true,
			font_size = 24,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			size = {
				arg_20_1[1],
				arg_20_1[2]
			},
			text_color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				2
			}
		},
		open_slot_text_shadow = {
			word_wrap = true,
			upper_case = true,
			font_size = 24,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			size = {
				arg_20_1[1],
				arg_20_1[2]
			},
			text_color = {
				255,
				0,
				0,
				0
			},
			offset = {
				2,
				-2,
				1
			}
		},
		career_name = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			font_size = 36,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			size = {
				arg_20_1[1] - 138,
				arg_20_1[2]
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				130,
				15,
				2
			}
		},
		player_name = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "arial",
			size = {
				arg_20_1[1] - 138,
				arg_20_1[2]
			},
			text_color = {
				255,
				160,
				160,
				160
			},
			offset = {
				130,
				-20,
				2
			}
		}
	}

	var_20_17.element.passes = var_20_18
	var_20_17.content = var_20_19
	var_20_17.style = var_20_20
	var_20_17.offset = {
		0,
		0,
		0
	}
	var_20_17.scenegraph_id = arg_20_0

	return var_20_17
end

function UIWidgets.create_round_end_score_widget(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_1 or {
		500,
		80
	}
	local var_43_1 = {
		350,
		20
	}
	local var_43_2 = UIFrameSettings.frame_inner_glow_03
	local var_43_3 = UIFrameSettings.button_frame_02_gold

	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					pass_type = "texture_frame",
					style_id = "highlight_glow",
					texture_id = "highlight_glow",
					content_check_function = function(arg_44_0)
						return arg_44_0.highlight
					end
				},
				{
					pass_type = "rect",
					style_id = "progress_bar_bg"
				},
				{
					pass_type = "texture_frame",
					style_id = "progress_bar_frame",
					texture_id = "progress_bar_frame"
				},
				{
					style_id = "score_progress_bar",
					pass_type = "texture_uv",
					content_id = "score_progress_bar",
					content_change_function = function(arg_45_0, arg_45_1)
						local var_45_0 = arg_45_0.parent.score_progress
						local var_45_1 = arg_45_0.parent.progress_bar_max_size
						local var_45_2 = math.min(var_45_1 * var_45_0 / var_45_1, 1)

						arg_45_0.uvs = {
							{
								0,
								0
							},
							{
								var_45_2,
								1
							}
						}
						arg_45_1.texture_size[1] = var_45_1 * var_45_2
					end,
					content_check_function = function(arg_46_0)
						return arg_46_0.parent.score_progress ~= 0
					end
				},
				{
					pass_type = "texture",
					style_id = "current_score_icon",
					texture_id = "current_score_icon"
				},
				{
					style_id = "current_score_text",
					pass_type = "text",
					text_id = "current_score_text"
				},
				{
					style_id = "round_text",
					pass_type = "text",
					text_id = "round_text"
				},
				{
					pass_type = "rect",
					style_id = "max_points"
				},
				{
					style_id = "max_points_text",
					pass_type = "text",
					text_id = "max_points_text"
				},
				{
					pass_type = "rect",
					style_id = "top_detail_rect"
				}
			}
		},
		content = {
			round_text = "Round 1",
			current_score_icon = "round_end_score_bar_slider",
			current_score_text = "0",
			current_score = 0,
			highlight = false,
			max_score = 0,
			unclaimed_points = 0,
			score_progress = 0,
			max_points_text = "0",
			highlight_glow = var_43_2.texture,
			progress_bar_frame = var_43_3.texture,
			progress_bar_max_size = var_43_1[1],
			score_progress_bar = {
				texture_id = "score_bar_fill",
				uvs = {
					{
						0,
						0
					},
					{
						0,
						1
					}
				}
			}
		},
		style = {
			background = {
				size = var_43_0,
				color = {
					255,
					90,
					90,
					90
				},
				offset = {
					0,
					0,
					1
				}
			},
			highlight_glow = {
				frame_margins = {
					2,
					2
				},
				texture_size = var_43_2.texture_size,
				texture_sizes = var_43_2.texture_sizes,
				color = Colors.get_color_table_with_alpha("gold", 255),
				offset = {
					0,
					0,
					15
				}
			},
			progress_bar_bg = {
				size = var_43_1,
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					75,
					15,
					3
				}
			},
			score_progress_bar = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					350,
					20
				},
				offset = {
					75,
					15,
					6
				}
			},
			progress_bar_frame = {
				size = {
					var_43_1[1] + 4,
					var_43_1[2] + 4
				},
				default_size = var_43_1,
				texture_size = var_43_3.texture_size,
				texture_sizes = var_43_3.texture_sizes,
				frame_margins = {
					0,
					0
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					73,
					13,
					7
				},
				default_offset = {
					73,
					13,
					20
				}
			},
			max_points = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					34,
					30
				},
				color = {
					255,
					58,
					58,
					58
				},
				offset = {
					var_43_0[1] - 75,
					10,
					10
				}
			},
			current_score_icon = {
				horizontal_alignment = "left",
				size = {
					32,
					24
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					43,
					13,
					10
				}
			},
			round_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				use_shadow = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				size = {
					var_43_0[1] - 90,
					var_43_0[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					70,
					-5,
					4
				}
			},
			current_score_text = {
				font_size = 24,
				upper_case = false,
				localize = false,
				use_shadow = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				size = {
					32,
					24
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					43,
					15,
					11
				}
			},
			max_points_text = {
				font_size = 24,
				upper_case = true,
				localize = false,
				use_shadow = true,
				word_wrap = false,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					15,
					30
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_43_0[1] - 72,
					8,
					11
				}
			},
			top_detail_rect = {
				size = {
					var_43_0[1],
					4
				},
				color = {
					255,
					145,
					145,
					145
				},
				offset = {
					0,
					var_43_0[2] - 4,
					12
				}
			}
		},
		scenegraph_id = arg_43_0,
		offset = arg_43_2 or {
			0,
			0,
			10
		}
	}
end

function UIWidgets.create_round_end_total_score_widget(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_1 or {
		1180,
		120
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background_left",
					texture_id = "background_left"
				},
				{
					style_id = "background_right",
					pass_type = "texture_uv",
					content_id = "background_right"
				},
				{
					pass_type = "texture",
					style_id = "left_detail",
					texture_id = "left_detail"
				},
				{
					style_id = "right_detail",
					pass_type = "texture_uv",
					content_id = "right_detail"
				},
				{
					pass_type = "texture",
					style_id = "team_1_frame",
					texture_id = "team_1_frame"
				},
				{
					pass_type = "texture",
					style_id = "team_1_icon",
					texture_id = "team_1_icon"
				},
				{
					pass_type = "texture",
					style_id = "team_2_frame",
					texture_id = "team_2_frame"
				},
				{
					pass_type = "texture",
					style_id = "team_2_icon",
					texture_id = "team_2_icon"
				}
			}
		},
		content = {
			team_2_frame = "team_icon_background",
			team_1_frame = "team_icon_background",
			team_1_icon = "team_icon_hammers",
			team_2_icon = "team_icon_skulls",
			left_detail = "button_detail_12",
			background_left = "headline_bg_60",
			background_right = {
				texture_id = "headline_bg_60",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			},
			right_detail = {
				texture_id = "button_detail_12",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			background_left = {
				size = {
					var_47_0[1] * 0.5,
					var_47_0[2]
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
					1
				}
			},
			background_right = {
				size = {
					var_47_0[1] * 0.5,
					var_47_0[2]
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					var_47_0[1] * 0.5,
					0,
					1
				}
			},
			left_detail = {
				size = {
					40,
					180
				},
				offset = {
					-10,
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
			right_detail = {
				size = {
					40,
					180
				},
				offset = {
					var_47_0[1] - 30,
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
			team_1_frame = {
				size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("local_player_team_lighter", 255),
				offset = {
					30,
					90,
					2
				}
			},
			team_1_icon = {
				size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("local_player_team_lighter", 255),
				offset = {
					30,
					90,
					3
				}
			},
			team_2_frame = {
				size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("opponent_team_lighter", 255),
				offset = {
					30,
					10,
					2
				}
			},
			team_2_icon = {
				size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("opponent_team_lighter", 255),
				offset = {
					30,
					10,
					3
				}
			}
		},
		offset = arg_47_2 or {
			0,
			0,
			1
		},
		scenegraph_id = arg_47_0
	}
end

function UIWidgets.create_player_panel(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	fassert(arg_48_1, "[UIWidgets.create_player_panel], A talent tooltip scenegraph id must be provided")

	local var_48_0 = arg_48_3 or {
		620,
		160
	}
	local var_48_1 = UIFrameSettings.menu_frame_09
	local var_48_2 = "talent_tree_bg_01"
	local var_48_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_48_2)
	local var_48_4 = UISettings.INSIGNIA_OFFSET

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "host_texture",
					texture_id = "host_texture",
					content_check_function = function(arg_49_0)
						return arg_49_0.show_host
					end
				},
				{
					pass_type = "texture",
					style_id = "ping_texture",
					texture_id = "ping_texture",
					content_check_function = function(arg_50_0)
						return arg_50_0.show_ping
					end
				},
				{
					style_id = "ping_text",
					pass_type = "text",
					text_id = "ping_text",
					content_check_function = function(arg_51_0, arg_51_1)
						return arg_51_0.show_ping and Application.user_setting("show_numerical_latency")
					end
				},
				{
					style_id = "build_private_text",
					pass_type = "text",
					text_id = "build_private_text",
					content_check_function = function(arg_52_0, arg_52_1)
						return not arg_52_0.is_build_visible
					end
				},
				{
					pass_type = "rect",
					style_id = "chat_button_background",
					texture_id = "chat_button_texture"
				},
				{
					texture_id = "button_frame",
					style_id = "chat_button_frame",
					pass_type = "texture"
				},
				{
					style_id = "chat_button_hotspot",
					texture_id = "chat_button_texture",
					pass_type = "texture",
					content_change_function = function(arg_53_0, arg_53_1)
						arg_53_1.color[1] = arg_53_0.show_chat_button and 255 or 60
					end
				},
				{
					pass_type = "texture",
					style_id = "chat_button_disabled",
					texture_id = "disabled_texture",
					content_check_function = function(arg_54_0)
						return arg_54_0.show_chat_button and arg_54_0.chat_button_hotspot.is_selected
					end
				},
				{
					style_id = "chat_button_hotspot",
					pass_type = "hotspot",
					content_id = "chat_button_hotspot",
					content_check_function = function(arg_55_0)
						return not arg_55_0.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "chat_tooltip_text_mute",
					content_check_function = function(arg_56_0)
						return arg_56_0.show_chat_button and not arg_56_0.chat_button_hotspot.is_selected and arg_56_0.chat_button_hotspot.is_hover
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "chat_tooltip_text_unmute",
					content_check_function = function(arg_57_0)
						return arg_57_0.show_chat_button and arg_57_0.chat_button_hotspot.is_selected and arg_57_0.chat_button_hotspot.is_hover
					end
				},
				{
					pass_type = "rect",
					style_id = "voice_button_background",
					texture_id = "voice_button_texture"
				},
				{
					texture_id = "button_frame",
					style_id = "voice_chat_button_frame",
					pass_type = "texture"
				},
				{
					style_id = "voice_button_hotspot",
					texture_id = "voice_button_texture",
					pass_type = "texture",
					content_change_function = function(arg_58_0, arg_58_1)
						arg_58_1.color[1] = arg_58_0.show_voice_button and 255 or 60
					end
				},
				{
					pass_type = "texture",
					style_id = "voice_button_disabled",
					texture_id = "disabled_texture",
					content_check_function = function(arg_59_0)
						return arg_59_0.show_voice_button and arg_59_0.voice_button_hotspot.is_selected
					end
				},
				{
					style_id = "voice_button_hotspot",
					pass_type = "hotspot",
					content_id = "voice_button_hotspot",
					content_check_function = function(arg_60_0)
						return not arg_60_0.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "voice_tooltip_text_mute",
					content_check_function = function(arg_61_0)
						return arg_61_0.show_voice_button and not arg_61_0.voice_button_hotspot.is_selected and arg_61_0.voice_button_hotspot.is_hover
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "voice_tooltip_text_unmute",
					content_check_function = function(arg_62_0)
						return arg_62_0.show_voice_button and arg_62_0.voice_button_hotspot.is_selected and arg_62_0.voice_button_hotspot.is_hover
					end
				},
				{
					pass_type = "rect",
					style_id = "kick_button_background",
					texture_id = "kick_button_texture"
				},
				{
					pass_type = "texture",
					style_id = "kick_button_frame",
					texture_id = "button_frame"
				},
				{
					style_id = "kick_button_hotspot",
					texture_id = "kick_button_texture",
					pass_type = "texture",
					content_change_function = function(arg_63_0, arg_63_1)
						arg_63_1.color[1] = arg_63_0.show_kick_button and 255 or 60
					end
				},
				{
					style_id = "kick_button_hotspot",
					pass_type = "hotspot",
					content_id = "kick_button_hotspot",
					content_check_function = function(arg_64_0)
						return not arg_64_0.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "kick_tooltip_text",
					content_check_function = function(arg_65_0)
						return arg_65_0.show_kick_button and arg_65_0.kick_button_hotspot.is_hover
					end
				},
				{
					pass_type = "rect",
					style_id = "profile_button_background",
					texture_id = "profile_button_texture"
				},
				{
					pass_type = "texture",
					style_id = "profile_button_frame",
					texture_id = "button_frame"
				},
				{
					style_id = "profile_button_hotspot",
					texture_id = "profile_button_texture",
					pass_type = "texture",
					content_change_function = function(arg_66_0, arg_66_1)
						arg_66_1.color[1] = arg_66_0.show_profile_button and 255 or 60
					end
				},
				{
					style_id = "profile_button_hotspot",
					pass_type = "hotspot",
					content_id = "profile_button_hotspot",
					content_check_function = function(arg_67_0)
						return not arg_67_0.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "profile_tooltip_text",
					content_check_function = function(arg_68_0)
						return arg_68_0.show_profile_button and arg_68_0.profile_button_hotspot.is_hover
					end
				},
				{
					style_id = "name",
					pass_type = "text",
					text_id = "name",
					content_check_function = function(arg_69_0, arg_69_1)
						if arg_69_0.button_hotspot.is_selected or arg_69_0.controller_button_hotspot.is_hover then
							arg_69_1.text_color = arg_69_1.hover_color
						else
							arg_69_1.text_color = arg_69_1.color
						end

						return true
					end
				},
				{
					style_id = "name_shadow",
					pass_type = "text",
					text_id = "name"
				},
				{
					style_id = "hero",
					pass_type = "text",
					text_id = "hero",
					content_check_function = function(arg_70_0, arg_70_1)
						if arg_70_0.button_hotspot.is_selected or arg_70_0.controller_button_hotspot.is_hover then
							arg_70_1.text_color = arg_70_1.hover_color
						else
							arg_70_1.text_color = arg_70_1.color
						end

						return true
					end
				},
				{
					style_id = "hero_shadow",
					pass_type = "text",
					text_id = "hero"
				},
				{
					style_id = "hp_bar_bg",
					pass_type = "rect",
					content_check_function = function(arg_71_0)
						return not arg_71_0.is_dark_pact or arg_71_0.is_in_local_player_party
					end
				},
				{
					style_id = "hp_bar_fg_start",
					pass_type = "texture_uv",
					content_id = "hp_bar_fg_start",
					content_check_function = function(arg_72_0)
						return not arg_72_0.parent.is_dark_pact or arg_72_0.parent.is_in_local_player_party
					end
				},
				{
					style_id = "hp_bar_fg_middle",
					pass_type = "texture_uv",
					content_id = "hp_bar_fg_middle",
					content_check_function = function(arg_73_0)
						return not arg_73_0.parent.is_dark_pact or arg_73_0.parent.is_in_local_player_party
					end
				},
				{
					style_id = "hp_bar_fg_end",
					pass_type = "texture_uv",
					content_id = "hp_bar_fg_end",
					content_check_function = function(arg_74_0)
						return not arg_74_0.parent.is_dark_pact or arg_74_0.parent.is_in_local_player_party
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "health_bar",
					texture_id = "texture_id",
					content_id = "health_bar",
					content_check_function = function(arg_75_0)
						return not arg_75_0.parent.is_dark_pact or arg_75_0.parent.is_in_local_player_party
					end
				},
				{
					style_id = "total_health_bar",
					texture_id = "texture_id",
					pass_type = "gradient_mask_texture",
					content_id = "total_health_bar",
					content_change_function = function(arg_76_0, arg_76_1)
						if arg_76_0.parent.is_knocked_down then
							arg_76_1.color = Colors.get_color_table_with_alpha("red", 255)
						else
							arg_76_1.color = Colors.get_color_table_with_alpha("white", 255)
						end
					end,
					content_check_function = function(arg_77_0)
						return arg_77_0.parent.is_local_player and not arg_77_0.parent.is_dark_pact and arg_77_0.parent.is_in_local_player_party
					end
				},
				{
					style_id = "ability_bar",
					pass_type = "texture_uv",
					content_id = "ability_bar",
					content_change_function = function(arg_78_0, arg_78_1)
						local var_78_0 = arg_78_0.bar_value
						local var_78_1 = arg_78_1.texture_size
						local var_78_2 = arg_78_0.uvs
						local var_78_3 = arg_78_1.full_size[1]

						var_78_2[2][2] = var_78_0
						var_78_1[1] = var_78_3 * var_78_0
					end,
					content_check_function = function(arg_79_0)
						return arg_79_0.parent.is_local_player and not arg_79_0.parent.is_dark_pact and arg_79_0.parent.is_in_local_player_party
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_melee",
					texture_id = "slot_melee",
					content_check_function = function(arg_80_0)
						return arg_80_0.slot_melee
					end
				},
				{
					style_id = "slot_melee",
					pass_type = "hotspot",
					content_id = "slot_melee_hotspot",
					content_check_function = function(arg_81_0)
						return arg_81_0.parent.slot_melee
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_melee_frame",
					texture_id = "slot_melee_frame",
					content_check_function = function(arg_82_0)
						return arg_82_0.slot_melee
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_melee_rarity_texture",
					texture_id = "slot_melee_rarity_texture",
					content_check_function = function(arg_83_0)
						return arg_83_0.slot_melee
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_ranged",
					texture_id = "slot_ranged",
					content_check_function = function(arg_84_0)
						return arg_84_0.slot_ranged
					end
				},
				{
					style_id = "slot_ranged",
					pass_type = "hotspot",
					content_id = "slot_ranged_hotspot",
					content_check_function = function(arg_85_0)
						return arg_85_0.parent.slot_ranged
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_ranged_frame",
					texture_id = "slot_ranged_frame",
					content_check_function = function(arg_86_0)
						return arg_86_0.slot_ranged
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_ranged_rarity_texture",
					texture_id = "slot_ranged_rarity_texture",
					content_check_function = function(arg_87_0)
						return arg_87_0.slot_ranged
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_1_frame",
					texture_id = "talent_frame",
					content_check_function = function(arg_88_0)
						return arg_88_0.talent_1.talent
					end
				},
				{
					style_id = "talent_1",
					pass_type = "hotspot",
					content_id = "talent_1"
				},
				{
					texture_id = "icon",
					style_id = "talent_1",
					pass_type = "texture",
					content_id = "talent_1",
					content_check_function = function(arg_89_0)
						return arg_89_0.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_1",
					scenegraph_id = arg_48_1,
					content_check_function = function(arg_90_0)
						return arg_90_0.talent and arg_90_0.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_2_frame",
					texture_id = "talent_frame",
					content_check_function = function(arg_91_0)
						return arg_91_0.talent_2.talent
					end
				},
				{
					style_id = "talent_2",
					pass_type = "hotspot",
					content_id = "talent_2"
				},
				{
					texture_id = "icon",
					style_id = "talent_2",
					pass_type = "texture",
					content_id = "talent_2",
					content_check_function = function(arg_92_0)
						return arg_92_0.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_2",
					scenegraph_id = arg_48_1,
					content_check_function = function(arg_93_0)
						return arg_93_0.talent and arg_93_0.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_3_frame",
					texture_id = "talent_frame",
					content_check_function = function(arg_94_0)
						return arg_94_0.talent_3.talent
					end
				},
				{
					style_id = "talent_3",
					pass_type = "hotspot",
					content_id = "talent_3"
				},
				{
					texture_id = "icon",
					style_id = "talent_3",
					pass_type = "texture",
					content_id = "talent_3",
					content_check_function = function(arg_95_0)
						return arg_95_0.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_3",
					scenegraph_id = arg_48_1,
					content_check_function = function(arg_96_0)
						return arg_96_0.talent and arg_96_0.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_4_frame",
					texture_id = "talent_frame",
					content_check_function = function(arg_97_0)
						return arg_97_0.talent_4.talent
					end
				},
				{
					style_id = "talent_4",
					pass_type = "hotspot",
					content_id = "talent_4"
				},
				{
					texture_id = "icon",
					style_id = "talent_4",
					pass_type = "texture",
					content_id = "talent_4",
					content_check_function = function(arg_98_0)
						return arg_98_0.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_4",
					scenegraph_id = arg_48_1,
					content_check_function = function(arg_99_0)
						return arg_99_0.talent and arg_99_0.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_5_frame",
					texture_id = "talent_frame",
					content_check_function = function(arg_100_0)
						return arg_100_0.talent_5.talent
					end
				},
				{
					style_id = "talent_5",
					pass_type = "hotspot",
					content_id = "talent_5"
				},
				{
					texture_id = "icon",
					style_id = "talent_5",
					pass_type = "texture",
					content_id = "talent_5",
					content_check_function = function(arg_101_0)
						return arg_101_0.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_5",
					scenegraph_id = arg_48_1,
					content_check_function = function(arg_102_0)
						return arg_102_0.talent and arg_102_0.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_6_frame",
					texture_id = "talent_frame",
					content_check_function = function(arg_103_0)
						return arg_103_0.talent_6.talent
					end
				},
				{
					style_id = "talent_6",
					pass_type = "hotspot",
					content_id = "talent_6"
				},
				{
					texture_id = "icon",
					style_id = "talent_6",
					pass_type = "texture",
					content_id = "talent_6",
					content_check_function = function(arg_104_0)
						return arg_104_0.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_6",
					scenegraph_id = arg_48_1,
					content_check_function = function(arg_105_0)
						return arg_105_0.talent and arg_105_0.is_hover
					end
				},
				{
					style_id = "respawn_text",
					pass_type = "text",
					text_id = "respawn_text",
					content_check_function = function(arg_106_0)
						return arg_106_0.is_dark_pact and arg_106_0.respawning
					end
				},
				content_id = "slot_ranged_hotspot"
			}
		},
		content = {
			name = "n/a",
			show_chat_button = false,
			profile_button_texture = "tab_menu_icon_05",
			show_kick_button = false,
			voice_button_texture = "tab_menu_icon_01",
			hero = "wh_captain",
			host_texture = "host_icon",
			slot_melee_frame = "reward_pop_up_item_frame",
			ping_texture = "ping_icon_03",
			disabled_texture = "tab_menu_icon_03",
			kick_tooltip_text = "input_description_vote_kick_player",
			voice_tooltip_text_unmute = "input_description_unmute_voice",
			talent_frame = "talent_frame",
			profile_tooltip_text = "input_description_show_profile",
			voice_tooltip_text_mute = "input_description_mute_voice",
			chat_button_texture = "tab_menu_icon_02",
			build_private_text = "visibility_private",
			button_frame = "reward_pop_up_item_frame",
			chat_tooltip_text_unmute = "input_description_unmute_chat",
			ping_text = "150",
			slot_melee_rarity_texture = "icon_bg_plentiful",
			chat_tooltip_text_mute = "input_description_mute_chat",
			show_ping = false,
			respawn_text = "0",
			hp_bar_bg = "hud_teammate_hp_bar_bg",
			kick_button_texture = "tab_menu_icon_04",
			show_profile_button = false,
			show_voice_button = false,
			slot_ranged_rarity_texture = "icon_bg_plentiful",
			slot_ranged_frame = "reward_pop_up_item_frame",
			frame = var_48_1.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						math.min(var_48_0[1] / var_48_3.size[1], 1),
						math.min((var_48_0[2] - 50) / var_48_3.size[2], 1)
					}
				},
				texture_id = var_48_2
			},
			button_hotspot = {
				allow_multi_hover = true
			},
			chat_button_hotspot = {},
			kick_button_hotspot = {},
			voice_button_hotspot = {},
			profile_button_hotspot = {},
			controller_button_hotspot = {},
			hp_bar_fg_start = {
				texture_id = "hud_teammate_hp_bar_frame",
				uvs = {
					{
						0,
						0
					},
					{
						0.2,
						1
					}
				}
			},
			hp_bar_fg_middle = {
				texture_id = "hud_teammate_hp_bar_frame",
				uvs = {
					{
						0.2,
						0
					},
					{
						0.8,
						1
					}
				}
			},
			hp_bar_fg_end = {
				texture_id = "hud_teammate_hp_bar_frame",
				uvs = {
					{
						0.8,
						0
					},
					{
						1,
						1
					}
				}
			},
			health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				draw_health_bar = true,
				texture_id = "teammate_hp_bar_color_tint_" .. math.min(arg_48_2, 8)
			},
			total_health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				draw_health_bar = true,
				texture_id = "teammate_hp_bar_" .. math.min(arg_48_2, 8)
			},
			ability_bar = {
				bar_value = 1,
				texture_id = "hud_teammate_ability_bar_fill",
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
			slot_melee_hotspot = {},
			slot_ranged_hotspot = {},
			talent_1 = {
				is_selected = true
			},
			talent_2 = {
				is_selected = true
			},
			talent_3 = {
				is_selected = true
			},
			talent_4 = {
				is_selected = true
			},
			talent_5 = {
				is_selected = true
			},
			talent_6 = {
				is_selected = true
			}
		},
		style = {
			slot_melee = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
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
					-215,
					-10,
					1
				}
			},
			slot_melee_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
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
					-215,
					-10,
					2
				}
			},
			slot_melee_rarity_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
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
					-215,
					-10,
					0
				}
			},
			slot_ranged = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
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
					-165,
					-10,
					1
				}
			},
			slot_ranged_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
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
					-165,
					-10,
					2
				}
			},
			slot_ranged_rarity_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
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
					-165,
					-10,
					0
				}
			},
			talent_tooltip = {
				draw_downwards = false
			},
			talent_1 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-215,
					-60,
					1
				}
			},
			talent_1_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-215,
					-60,
					2
				}
			},
			talent_2 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-175,
					-60,
					1
				}
			},
			talent_2_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-175,
					-60,
					2
				}
			},
			talent_3 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-135,
					-60,
					1
				}
			},
			talent_3_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-135,
					-60,
					2
				}
			},
			talent_4 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-95,
					-60,
					1
				}
			},
			talent_4_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-95,
					-60,
					2
				}
			},
			talent_5 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-55,
					-60,
					1
				}
			},
			talent_5_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-55,
					-60,
					2
				}
			},
			talent_6 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-15 + 0 * -40,
					-60,
					1
				}
			},
			talent_6_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-15 + 0 * -40,
					-60,
					2
				}
			},
			health_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				gradient_threshold = 1,
				texture_size = {
					200 - var_48_4,
					18
				},
				color = {
					255,
					0,
					255,
					0
				},
				offset = {
					150 + var_48_4,
					-82,
					14
				}
			},
			total_health_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				gradient_threshold = 1,
				texture_size = {
					200 - var_48_4,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					150 + var_48_4,
					-82,
					13
				}
			},
			ability_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				full_size = {
					194 - var_48_4,
					10
				},
				texture_size = {
					200,
					12
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					153 + var_48_4,
					-100,
					13
				}
			},
			hp_bar_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_tiling_size = {
					100,
					20
				},
				texture_size = {
					200 - var_48_4,
					30
				},
				tile_offset = {
					true,
					false
				},
				offset = {
					150 + var_48_4,
					-82,
					10
				},
				color = {
					255,
					30,
					30,
					30
				}
			},
			hp_bar_fg_start = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					20,
					35
				},
				offset = {
					150 + var_48_4,
					-80,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar_fg_middle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					160 - var_48_4,
					35
				},
				offset = {
					170 + var_48_4,
					-80,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar_fg_end = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					20,
					35
				},
				offset = {
					330,
					-80,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			frame = {
				texture_size = var_48_1.texture_size,
				texture_sizes = var_48_1.texture_sizes,
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
			background = {
				size = {
					var_48_0[1],
					var_48_0[2]
				},
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
				}
			},
			tooltip_text = {
				vertical_alignment = "top",
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				font_size = 18,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			profile_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-170,
					10,
					1
				}
			},
			profile_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-170,
					10,
					3
				}
			},
			profile_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
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
					-170,
					10,
					2
				}
			},
			voice_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-120,
					10,
					3
				}
			},
			voice_chat_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-120,
					10,
					6
				}
			},
			voice_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
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
					-120,
					10,
					4
				}
			},
			voice_button_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					0,
					0
				},
				offset = {
					-120,
					10,
					5
				}
			},
			chat_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-70,
					10,
					1
				}
			},
			chat_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-70,
					10,
					6
				}
			},
			chat_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
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
					-70,
					10,
					4
				}
			},
			chat_button_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					0,
					0
				},
				offset = {
					-70,
					10,
					5
				}
			},
			kick_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-20 + 0 * -50,
					10,
					3
				}
			},
			kick_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-20 + 0 * -50,
					10,
					6
				}
			},
			kick_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
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
					-20 + 0 * -50,
					10,
					4
				}
			},
			ping_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					54,
					50
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-210,
					5,
					5
				}
			},
			ping_text = {
				horizontal_alignment = "right",
				font_size = 20,
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "arial",
				offset = {
					-255,
					13,
					3
				},
				text_color = Colors.get_table("font_default"),
				high_ping_color = Colors.get_table("crimson"),
				medium_ping_color = Colors.get_table("gold"),
				low_ping_color = Colors.get_table("lime_green")
			},
			build_private_text = {
				vertical_alignment = "top",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_type = "hell_shark_header",
				font_size = 24,
				offset = {
					200,
					-20,
					1
				},
				text_color = {
					255,
					128,
					128,
					128
				}
			},
			host_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-509,
					1,
					14
				},
				texture_size = {
					40,
					40
				}
			},
			name = {
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "arial",
				size = {
					210 - var_48_4,
					30
				},
				offset = {
					150 + var_48_4,
					121,
					3
				},
				color = Colors.get_table("font_default"),
				hover_color = Colors.get_table("font_default"),
				text_color = Colors.get_table("font_default")
			},
			name_shadow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				font_type = "arial",
				dynamic_font_size = true,
				font_size = 20,
				size = {
					210 - var_48_4,
					30
				},
				offset = {
					152 + var_48_4,
					119,
					2
				},
				text_color = Colors.get_table("black")
			},
			hero = {
				upper_case = true,
				localize = true,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					210 - var_48_4,
					30
				},
				offset = {
					150 + var_48_4,
					90,
					3
				},
				color = Colors.get_table("font_title"),
				hover_color = Colors.get_table("font_title"),
				text_color = Colors.get_table("font_title")
			},
			hero_shadow = {
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				font_size = 28,
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					210 - var_48_4,
					30
				},
				offset = {
					152 + var_48_4,
					88,
					2
				},
				text_color = Colors.get_table("black")
			},
			respawn_text = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				localize = false,
				font_size = 80,
				font_type = "hell_shark_header",
				size = {
					100,
					120
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					14,
					0,
					20
				}
			}
		},
		scenegraph_id = arg_48_0,
		offset = arg_48_4 or {
			0,
			0,
			0
		}
	}
end

function UIWidgets.create_objective_score_widget(arg_107_0, arg_107_1, arg_107_2)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "progress_background",
					texture_id = "progress_background"
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "progress_bar",
					texture_id = "progress_bar"
				},
				{
					style_id = "team_1_score",
					pass_type = "text",
					text_id = "team_1_score",
					content_change_function = function(arg_108_0, arg_108_1)
						if arg_108_0.is_hero then
							arg_108_1.text_color = Colors.get_color_table_with_alpha("white_smoke", 255)
						else
							arg_108_1.text_color = Colors.get_color_table_with_alpha("very_dark_gray", 255)
						end
					end
				},
				{
					style_id = "team_2_score",
					pass_type = "text",
					text_id = "team_2_score",
					content_change_function = function(arg_109_0, arg_109_1)
						if arg_109_0.is_hero then
							arg_109_1.text_color = Colors.get_color_table_with_alpha("very_dark_gray", 255)
						else
							arg_109_1.text_color = Colors.get_color_table_with_alpha("white_smoke", 255)
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "objective_icon",
					texture_id = "objective_icon",
					content_check_function = function(arg_110_0)
						return arg_110_0.pre_round_timer_done
					end
				},
				{
					style_id = "pre_round_timer",
					pass_type = "text",
					text_id = "pre_round_timer",
					content_check_function = function(arg_111_0)
						return not arg_111_0.pre_round_timer_done
					end
				}
			}
		},
		content = {
			progress_bar = "versus_objective_progress_bar",
			background = "frame_front",
			progress_background = "frame_back",
			pre_round_timer = " ",
			team_2_score = " ",
			team_1_score = " ",
			objective_icon = "icons_placeholder",
			pre_round_timer_done = false
		},
		style = {
			background = {
				texture_size = arg_107_1,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					3
				}
			},
			progress_background = {
				texture_size = arg_107_1,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			progress_bar = {
				vertical_alignment = "center",
				gradient_threshold = 0,
				horizontal_alignment = "center",
				texture_size = {
					128,
					128
				},
				offset = {
					0,
					0,
					2
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			objective_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					64,
					64
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					6
				}
			},
			team_1_score = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				vertical_alignment = "center",
				font_size = 46,
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					100,
					50
				},
				text_color = Colors.get_color_table_with_alpha("white_smoke", 255),
				shadow_offset = {
					1,
					1,
					4
				},
				offset = {
					8,
					50,
					4
				}
			},
			team_2_score = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				vertical_alignment = "center",
				font_size = 46,
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					100,
					50
				},
				text_color = Colors.get_color_table_with_alpha("white_smoke", 255),
				shadow_offset = {
					1,
					1,
					4
				},
				offset = {
					195,
					50,
					4
				}
			},
			pre_round_timer = {
				font_size = 50,
				upper_case = false,
				localize = false,
				use_shadow = true,
				word_wrap = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				size = {
					54,
					50
				},
				text_color = Colors.get_color_table_with_alpha("white_smoke", 255),
				shadow_offset = {
					1,
					1,
					4
				},
				offset = {
					arg_107_1[1] * 0.5 - 27,
					arg_107_1[2] * 0.25 + 4 - 2,
					5
				}
			}
		},
		scenegraph_id = arg_107_0,
		offset = arg_107_2 or {
			0,
			0,
			0
		}
	}
end

function UIWidgets.create_mission_objective_text_widget_still(arg_112_0)
	local var_112_0 = 55

	return {
		alpha_multiplier = 1,
		element = {
			passes = {
				{
					style_id = "area_text_style",
					pass_type = "text",
					text_id = "area_text_content"
				},
				{
					style_id = "area_text_shadow_style",
					pass_type = "text",
					text_id = "area_text_content"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "top_center",
					texture_id = "top_center"
				},
				{
					style_id = "top_edge_glow",
					pass_type = "texture_uv",
					content_id = "top_edge_glow"
				},
				{
					pass_type = "texture",
					style_id = "top_detail",
					texture_id = "top_detail"
				},
				{
					pass_type = "texture",
					style_id = "top_detail_glow",
					texture_id = "top_detail_glow"
				},
				{
					pass_type = "texture",
					style_id = "top",
					texture_id = "top"
				},
				{
					pass_type = "texture",
					style_id = "bottom",
					texture_id = "top"
				},
				{
					pass_type = "texture",
					style_id = "bottom_center",
					texture_id = "bottom_center"
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge_glow",
					texture_id = "bottom_edge_glow"
				}
			}
		},
		content = {
			bottom_edge_glow = "mission_objective_glow_01",
			area_text_content = "n/a",
			top = "mission_objective_05",
			top_center = "mission_objective_04",
			fraction = 1,
			top_detail_glow = "mission_objective_glow_02",
			bottom_center = "mission_objective_02",
			top_detail = "mission_objective_01",
			background = {
				texture_id = "mission_objective_bg",
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
			top_edge_glow = {
				texture_id = "mission_objective_glow_01",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			}
		},
		style = {
			background = {
				size = {
					544,
					var_112_0
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					100,
					255,
					255,
					255
				}
			},
			top_center = {
				size = {
					54,
					22
				},
				offset = {
					245,
					var_112_0 - 11 - 3,
					11
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top_edge_glow = {
				size = {
					544,
					16
				},
				default_size = {
					544,
					16
				},
				offset = {
					0,
					var_112_0 - 16 - 3,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top_detail = {
				size = {
					54,
					22
				},
				offset = {
					245,
					var_112_0 - 11 - 3,
					12
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top_detail_glow = {
				horizontal_alignment = "center",
				size = {
					54,
					22
				},
				offset = {
					245,
					var_112_0 - 11 - 3,
					13
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top = {
				size = {
					544,
					5
				},
				offset = {
					0,
					var_112_0 - 5,
					10
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			bottom = {
				size = {
					544,
					5
				},
				offset = {
					0,
					0,
					10
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			bottom_center = {
				size = {
					54,
					22
				},
				offset = {
					245,
					-6,
					11
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			bottom_edge_glow = {
				size = {
					544,
					16
				},
				default_size = {
					544,
					16
				},
				offset = {
					0,
					3,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			area_text_style = {
				min_font_size = 20,
				upper_case = true,
				localize = false,
				font_size = 20,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-1,
					11
				}
			},
			area_text_shadow_style = {
				min_font_size = 20,
				upper_case = true,
				localize = false,
				font_size = 20,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-3,
					10
				}
			},
			duration_text_style = {
				min_font_size = 20,
				upper_case = false,
				localize = false,
				font_size = 20,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-1,
					11
				}
			},
			duration_text_shadow_style = {
				min_font_size = 20,
				upper_case = false,
				localize = false,
				font_size = 20,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-3,
					10
				}
			}
		},
		scenegraph_id = arg_112_0
	}
end

function UIWidgets.create_total_score_progress_bar(arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4)
	local var_113_0 = 1.5
	local var_113_1 = {
		130,
		60
	}
	local var_113_2 = {
		50,
		30
	}
	local var_113_3 = "bar_frame_01_back"
	local var_113_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_113_3)
	local var_113_5 = UIFrameSettings.bar_frame_01
	local var_113_6 = UIFrameSettings.bar_frame_01
	local var_113_7 = UIFrameSettings.button_frame_02_gold
	local var_113_8 = UIFrameSettings.button_frame_01
	local var_113_9 = {}
	local var_113_10 = {}

	local function var_113_11(arg_114_0, arg_114_1)
		if arg_114_0.parent then
			return arg_114_0.parent.is_winning
		else
			return arg_114_0.is_winning
		end
	end

	local function var_113_12(arg_115_0, arg_115_1)
		if arg_115_0.parent then
			return not arg_115_0.parent.is_winning
		else
			return not arg_115_0.is_winning
		end
	end

	local var_113_13 = arg_113_2 / 25
	local var_113_14 = arg_113_1[1] / var_113_13
	local var_113_15 = "bar_frame_01_divider"
	local var_113_16 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_113_15).size
	local var_113_17 = var_113_16[1] * var_113_13
	local var_113_18 = var_113_14 * (var_113_13 - 1)
	local var_113_19 = {}
	local var_113_20 = {}
	local var_113_21 = {}

	for iter_113_0 = 1, var_113_13 - 1 do
		var_113_19[iter_113_0] = var_113_15
		var_113_20[iter_113_0] = var_113_16
		var_113_21[iter_113_0] = {
			255,
			255,
			255,
			255
		}
	end

	var_113_10.passes = {
		{
			pass_type = "tiled_texture",
			style_id = "bar_background",
			texture_id = "bar_background"
		},
		{
			pass_type = "texture_frame",
			style_id = "bar_frame",
			texture_id = "bar_frame"
		},
		{
			style_id = "bar_fill",
			texture_id = "bar_fill",
			pass_type = "gradient_mask_texture",
			content_change_function = function(arg_116_0, arg_116_1)
				arg_116_1.gradient_threshold = arg_116_0.current_bar_fil_threshold
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "max_score_detail_frame",
			texture_id = "max_score_detail_frame"
		},
		{
			style_id = "max_score",
			pass_type = "text",
			text_id = "max_score"
		},
		{
			pass_type = "tiled_texture",
			style_id = "current_score_background",
			texture_id = "current_score_background"
		},
		{
			pass_type = "texture_frame",
			style_id = "gold_frame",
			texture_id = "gold_frame",
			content_check_function = var_113_11
		},
		{
			pass_type = "texture",
			style_id = "left_detail_w",
			texture_id = "left_detail_w",
			content_check_function = var_113_11
		},
		{
			style_id = "right_detail_w",
			pass_type = "texture_uv",
			content_id = "right_detail_w",
			content_check_function = var_113_11
		},
		{
			pass_type = "texture_frame",
			style_id = "bronze_frame",
			texture_id = "bronze_frame",
			content_check_function = var_113_12
		},
		{
			pass_type = "texture",
			style_id = "left_detail_l",
			texture_id = "left_detail_l",
			content_check_function = var_113_12
		},
		{
			style_id = "right_detail_l",
			pass_type = "texture_uv",
			content_id = "right_detail_l",
			content_check_function = var_113_12
		},
		{
			style_id = "current_score",
			pass_type = "text",
			text_id = "current_score_text"
		},
		{
			pass_type = "multi_texture",
			style_id = "score_separators",
			texture_id = "score_separators"
		}
	}

	local var_113_22 = {
		current_score_background = "bar_frame_01_back",
		bar_fill_threashold = 0,
		current_score_text = "0",
		left_detail_w = "button_detail_01_gold",
		is_winning = true,
		current_bar_fil_threshold = 0,
		left_detail_l = "button_detail_01",
		bar_size = arg_113_1,
		current_score_size = var_113_1,
		local_player_team = arg_113_4,
		bar_background = var_113_3,
		bar_frame = var_113_5.texture,
		bar_fill = arg_113_4 and "local_player_score_bar" or "opponent_score_bar",
		max_score_detail_frame = var_113_6.texture,
		max_score = arg_113_2,
		gold_frame = var_113_7.texture,
		right_detail_w = {
			texture_id = "button_detail_01_gold",
			uvs = {
				{
					1,
					1
				},
				{
					0,
					0
				}
			}
		},
		bronze_frame = var_113_8.texture,
		right_detail_l = {
			texture_id = "button_detail_01",
			uvs = {
				{
					1,
					1
				},
				{
					0,
					0
				}
			}
		},
		current_score = arg_113_3,
		score_separators = var_113_19
	}
	local var_113_23 = {
		bar_background = {
			texture_size = arg_113_1,
			texture_tiling_size = var_113_4.size,
			color = {
				255,
				255,
				255,
				255
			},
			default_offset = {
				0,
				0,
				1
			},
			offset = {
				0,
				0,
				1
			}
		},
		bar_frame = {
			size = {
				arg_113_1[1] + 4,
				arg_113_1[2] + 4
			},
			texture_size = var_113_5.texture_size,
			texture_sizes = var_113_5.texture_sizes,
			default_offset = {
				0,
				-2,
				10
			},
			offset = {
				0,
				-2,
				10
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		bar_fill = {
			gradient_threshold = 0.3,
			size = {
				arg_113_1[1] - var_113_2[1] + 4,
				arg_113_1[2]
			},
			default_offset = {
				0,
				0,
				9
			},
			offset = {
				0,
				0,
				9
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		max_score_detail_frame = {
			size = {
				var_113_2[1] + 4,
				var_113_2[2] + 4
			},
			texture_size = var_113_6.texture_size,
			texture_sizes = var_113_6.texture_sizes,
			default_offset = {
				arg_113_1[1] - 50,
				-2,
				10
			},
			offset = {
				arg_113_1[1] - 50,
				-2,
				10
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		max_score = {
			font_size = 20,
			upper_case = false,
			localize = false,
			use_shadow = true,
			word_wrap = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			size = {
				var_113_2[1] - 10,
				arg_113_1[2]
			},
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_offset = {
				arg_113_1[1] - 40,
				0,
				5
			},
			offset = {
				arg_113_1[1] - 40,
				0,
				5
			}
		},
		current_score_background = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = var_113_1,
			texture_tiling_size = {
				128,
				128
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_offset = {
				20,
				0,
				11
			},
			offset = {
				20,
				0,
				11
			}
		},
		gold_frame = {
			size = var_113_1,
			texture_size = var_113_7.texture_size,
			texture_sizes = var_113_7.texture_sizes,
			default_offset = {
				20,
				-15,
				12
			},
			offset = {
				20,
				-15,
				12
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		left_detail_w = {
			size = {
				40,
				var_113_1[2]
			},
			default_offset = {
				10,
				-15,
				13
			},
			offset = {
				10,
				-15,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		right_detail_w = {
			size = {
				40,
				var_113_1[2]
			},
			default_offset = {
				var_113_1[1] - 10,
				-15,
				13
			},
			offset = {
				var_113_1[1] - 10,
				-15,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		bronze_frame = {
			size = var_113_1,
			texture_size = var_113_8.texture_size,
			texture_sizes = var_113_8.texture_sizes,
			default_offset = {
				20,
				-15,
				12
			},
			offset = {
				20,
				-15,
				12
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		left_detail_l = {
			size = {
				40,
				var_113_1[2]
			},
			default_offset = {
				10,
				-15,
				13
			},
			offset = {
				10,
				-15,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		right_detail_l = {
			size = {
				40,
				var_113_1[2]
			},
			default_offset = {
				var_113_1[1] - 10,
				-15,
				13
			},
			offset = {
				var_113_1[1] - 10,
				-15,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		current_score = {
			font_size = 50,
			upper_case = false,
			localize = false,
			use_shadow = true,
			word_wrap = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			size = var_113_1,
			text_color = arg_113_4 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255),
			default_offset = {
				20,
				-20,
				13
			},
			offset = {
				20,
				-20,
				13
			}
		},
		score_separators = {
			direction = 1,
			axis = 1,
			size = arg_113_1,
			spacing = {
				var_113_14 - 1,
				0
			},
			texture_sizes = var_113_20,
			texture_colors = var_113_21,
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				5,
				3
			},
			draw_count = var_113_13 - 1
		}
	}

	var_113_9.element = var_113_10
	var_113_9.content = var_113_22
	var_113_9.style = var_113_23
	var_113_9.scenegraph_id = arg_113_0
	var_113_9.offset = {
		0,
		0,
		0
	}

	return var_113_9
end

function UIWidgets.create_team_banner_info(arg_117_0, arg_117_1)
	local var_117_0 = arg_117_1 and "left" or "right"
	local var_117_1 = arg_117_1 and {
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
			1
		},
		{
			0,
			0
		}
	}
	local var_117_2 = arg_117_1 and 45 or -45

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "team_side",
					pass_type = "text",
					text_id = "team_side"
				},
				{
					style_id = "team_name",
					pass_type = "text",
					text_id = "team_name"
				}
			}
		},
		content = {
			team_name = "**Hammers",
			background = {
				texture_id = "headline_bg_40",
				uvs = var_117_1
			},
			team_side = arg_117_1 and "**Your Team" or "**Enemy"
		},
		style = {
			background = {
				color = {
					100,
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
			team_side = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				use_shadow = true,
				font_size = 22,
				vertical_alignment = "top",
				font_type = "hell_shark",
				horizontal_alignment = var_117_0,
				text_color = arg_117_1 and Colors.get_color_table_with_alpha("font_button_normal", 255) or Colors.get_color_table_with_alpha("opponent_team", 255),
				offset = {
					var_117_2,
					-5,
					4
				}
			},
			team_name = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				use_shadow = true,
				font_size = 60,
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				horizontal_alignment = var_117_0,
				text_color = arg_117_1 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255),
				offset = {
					var_117_2,
					-5,
					5
				}
			}
		},
		scenegraph_id = arg_117_0,
		offset = {
			0,
			0,
			0
		}
	}
end

function UIWidgets.create_round_score_progress_bar(arg_118_0, arg_118_1, arg_118_2, arg_118_3, arg_118_4, arg_118_5)
	local var_118_0 = "bar_frame_01_back"
	local var_118_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_118_0)
	local var_118_2 = UIFrameSettings.bar_frame_01
	local var_118_3 = UIFrameSettings.bar_frame_01
	local var_118_4 = UIFrameSettings.bar_frame_01
	local var_118_5 = {
		50,
		30
	}

	return {
		element = {
			passes = {
				{
					pass_type = "tiled_texture",
					style_id = "bar_background",
					texture_id = "bar_background"
				},
				{
					pass_type = "texture_frame",
					style_id = "bar_frame",
					texture_id = "bar_frame"
				},
				{
					pass_type = "texture_frame",
					style_id = "current_score_frame",
					texture_id = "current_score_frame"
				},
				{
					pass_type = "tiled_texture",
					style_id = "current_score_bg",
					texture_id = "current_score_bg"
				},
				{
					pass_type = "texture_frame",
					style_id = "max_score_frame",
					texture_id = "max_score_frame"
				},
				{
					pass_type = "tiled_texture",
					style_id = "max_score_bg",
					texture_id = "max_score_bg"
				},
				{
					style_id = "bar_fill",
					pass_type = "gradient_mask_texture",
					texture_id = "bar_fill",
					clone = true,
					content_change_function = function(arg_119_0, arg_119_1)
						arg_119_1.gradient_threshold = arg_119_0.current_bar_fil_threshold
					end
				},
				{
					style_id = "current_score",
					pass_type = "text",
					text_id = "current_score"
				},
				{
					style_id = "max_score",
					pass_type = "text",
					text_id = "max_score"
				}
			}
		},
		content = {
			bar_fill_threashold = 0,
			current_bar_fil_threshold = 0,
			bar_size = arg_118_1,
			score_size = var_118_5,
			local_player_team = arg_118_3,
			bar_background = var_118_0,
			bar_frame = var_118_2.texture,
			bar_fill = arg_118_3 and "local_player_score_bar" or "opponent_score_bar",
			max_score_detail_frame = var_118_3.texture,
			current_score = arg_118_5,
			max_score = arg_118_4,
			current_score_frame = var_118_3.texture,
			current_score_bg = var_118_0,
			max_score_frame = var_118_3.texture,
			max_score_bg = var_118_0
		},
		style = {
			bar_background = {
				texture_size = arg_118_1,
				texture_tiling_size = var_118_1.size,
				color = {
					255,
					255,
					255,
					255
				},
				default_offset = {
					0,
					0,
					1
				},
				offset = {
					0,
					0,
					1
				}
			},
			bar_frame = {
				size = {
					arg_118_1[1] + 4,
					arg_118_1[2] + 4
				},
				texture_size = var_118_3.texture_size,
				texture_sizes = var_118_3.texture_sizes,
				default_offset = {
					0,
					-2,
					10
				},
				offset = {
					0,
					-2,
					10
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			bar_fill = {
				gradient_threshold = 0.3,
				size = {
					arg_118_1[1] - 50,
					arg_118_1[2]
				},
				default_offset = {
					0,
					0,
					9
				},
				offset = {
					0,
					0,
					9
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			current_score_frame = {
				size = {
					var_118_5[1] + 4,
					var_118_5[2] + 4
				},
				texture_size = var_118_3.texture_size,
				texture_sizes = var_118_3.texture_sizes,
				default_offset = {
					0,
					-10,
					13
				},
				offset = {
					0,
					-10,
					13
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			current_score_bg = {
				texture_size = var_118_5,
				texture_tiling_size = var_118_1.size,
				color = {
					255,
					255,
					255,
					255
				},
				default_offset = {
					0,
					-10,
					11
				},
				offset = {
					0,
					-10,
					11
				}
			},
			max_score_frame = {
				size = {
					var_118_5[1] + 4,
					var_118_5[2] + 4
				},
				texture_size = var_118_3.texture_size,
				texture_sizes = var_118_3.texture_sizes,
				default_offset = {
					arg_118_1[1] - 50,
					-10,
					13
				},
				offset = {
					arg_118_1[1] - 50,
					-10,
					13
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			max_score_bg = {
				texture_size = var_118_5,
				texture_tiling_size = var_118_1.size,
				color = {
					255,
					255,
					255,
					255
				},
				default_offset = {
					arg_118_1[1] - 50,
					-10,
					10
				},
				offset = {
					arg_118_1[1] - 50,
					-10,
					10
				}
			},
			max_score = {
				font_size = 20,
				upper_case = false,
				localize = false,
				use_shadow = true,
				word_wrap = false,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					var_118_5[1],
					var_118_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_offset = {
					arg_118_1[1] - 40,
					-10,
					12
				},
				offset = {
					arg_118_1[1] - 40,
					-10,
					12
				}
			},
			current_score = {
				font_size = 20,
				upper_case = false,
				localize = false,
				use_shadow = true,
				word_wrap = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					var_118_5[1],
					var_118_5[2]
				},
				text_color = arg_118_3 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255),
				default_offset = {
					0,
					-10,
					12
				},
				offset = {
					0,
					-10,
					12
				}
			}
		},
		scenegraph_id = arg_118_0,
		offset = {
			0,
			0,
			0
		}
	}
end

function UIWidgets.create_round_end_round_score_bg_widget(arg_120_0, arg_120_1, arg_120_2)
	local var_120_0 = arg_120_1 or {
		920,
		100
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background_left",
					texture_id = "background_left"
				},
				{
					style_id = "background_right",
					pass_type = "texture_uv",
					content_id = "background_right"
				},
				{
					pass_type = "texture",
					style_id = "left_detail",
					texture_id = "left_detail"
				},
				{
					style_id = "right_detail",
					pass_type = "texture_uv",
					content_id = "right_detail"
				}
			}
		},
		content = {
			left_detail = "button_detail_12",
			background_left = "headline_bg_40",
			background_right = {
				texture_id = "headline_bg_40",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			},
			right_detail = {
				texture_id = "button_detail_12",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			background_left = {
				size = {
					var_120_0[1] * 0.5,
					var_120_0[2]
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
					1
				}
			},
			background_right = {
				size = {
					var_120_0[1] * 0.5,
					var_120_0[2]
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					var_120_0[1] * 0.5,
					0,
					1
				}
			},
			left_detail = {
				size = {
					40,
					100
				},
				offset = {
					-10,
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
			right_detail = {
				size = {
					40,
					100
				},
				offset = {
					var_120_0[1] - 30,
					0,
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
		offset = arg_120_2 or {
			0,
			0,
			1
		},
		scenegraph_id = arg_120_0
	}
end

function UIWidgets.create_parading_screen_divider(arg_121_0, arg_121_1, arg_121_2)
	local var_121_0 = "divider_horizontal_hero_middle_blue"
	local var_121_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_121_0)

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "divider_edge_left",
					texture_id = "divider_edge_left"
				},
				{
					pass_type = "tiled_texture",
					style_id = "divider_mid",
					texture_id = "divider_mid"
				},
				{
					style_id = "divider_edge_right",
					pass_type = "texture_uv",
					content_id = "divider_edge_right"
				}
			}
		},
		content = {
			divider_edge_left = "divider_horizontal_hero_end_blue",
			divider_mid = var_121_0,
			divider_edge_right = {
				texture_id = "divider_horizontal_hero_end_blue",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			divider_edge_left = {
				vertical_alignment = "center",
				size = {
					22,
					28
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-22,
					-7,
					1
				}
			},
			divider_mid = {
				vertical_alignment = "center",
				texture_size = arg_121_1,
				texture_tiling_size = var_121_1.size,
				color = Colors.get_color_table_with_alpha("white", 255),
				default_offset = {
					0,
					0,
					1
				},
				offset = {
					0,
					0,
					1
				}
			},
			divider_edge_right = {
				vertical_alignment = "center",
				size = {
					22,
					28
				},
				offset = {
					arg_121_1[1],
					-7,
					2
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			}
		},
		scenegraph_id = arg_121_0,
		offset = arg_121_2 or {
			0,
			0,
			1
		}
	}
end

function UIWidgets.create_dark_pact_onboarding_tutorial_widget(arg_122_0, arg_122_1, arg_122_2)
	local var_122_0 = arg_122_1 or {
		400,
		300
	}

	return {
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "top_detail",
					texture_id = "detail"
				},
				{
					pass_type = "rotated_texture",
					style_id = "bottom_detail",
					texture_id = "detail"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "hero_text",
					pass_type = "text",
					text_id = "hero_text"
				},
				{
					style_id = "description",
					pass_type = "text",
					text_id = "description"
				},
				{
					style_id = "abilities_tooltip",
					pass_type = "text",
					text_id = "abilities_tooltip"
				}
			}
		},
		content = {
			description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
			abilities_tooltip = "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
			hero_text = "RATLING GUNNER",
			detail = "radial_chat_bg_line",
			background = {
				texture_id = "headline_bg_60",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			top_detail = {
				angle = math.degrees_to_radians(-90),
				offset = {
					200,
					60,
					4
				},
				pivot = {
					2,
					200
				},
				texture_size = {
					4,
					400
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			bottom_detail = {
				angle = math.degrees_to_radians(-90),
				offset = {
					200,
					-var_122_0[2] + 60,
					4
				},
				pivot = {
					2,
					200
				},
				texture_size = {
					4,
					400
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			background = {
				vertical_alignment = "center",
				size = {
					var_122_0[1] + 20,
					var_122_0[2]
				},
				offset = {
					-20,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			hero_text = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				use_shadow = false,
				font_size = 40,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-10,
					4
				}
			},
			description = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 18,
				vertical_alignment = "top",
				horizontal_alignment = "left",
				use_shadow = false,
				font_type = "hell_shark",
				size = {
					380,
					120
				},
				text_color = Colors.get_color_table_with_alpha("light_gray", 255),
				offset = {
					0,
					92,
					4
				}
			},
			abilities_tooltip = {
				font_size = 20,
				word_wrap = true,
				dynamic_font_size_word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					380,
					120
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					8,
					4
				}
			}
		},
		scenegraph_id = arg_122_0,
		offset = arg_122_2 or {
			0,
			0,
			1
		}
	}
end

function UIWidgets.create_hero_onboarding_tutorial_widget(arg_123_0, arg_123_1, arg_123_2)
	local var_123_0 = arg_123_1 or {
		400,
		300
	}
	local var_123_1 = 1.25

	return {
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "top_detail",
					texture_id = "detail"
				},
				{
					pass_type = "rotated_texture",
					style_id = "bottom_detail",
					texture_id = "detail"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "hero_text",
					pass_type = "text",
					text_id = "hero_text"
				},
				{
					pass_type = "texture",
					style_id = "career_icon",
					texture_id = "career_icon"
				},
				{
					pass_type = "texture",
					style_id = "ability_1_icon",
					texture_id = "ability_1_icon"
				},
				{
					pass_type = "texture",
					style_id = "ability_1_icon_frame",
					texture_id = "icon_frame"
				},
				{
					style_id = "ability_1_name",
					pass_type = "text",
					text_id = "ability_1_name"
				},
				{
					style_id = "ability_1_description",
					pass_type = "text",
					text_id = "ability_1_description"
				},
				{
					pass_type = "texture",
					style_id = "ability_2_icon",
					texture_id = "ability_2_icon"
				},
				{
					pass_type = "texture",
					style_id = "ability_2_icon_frame",
					texture_id = "icon_frame"
				},
				{
					style_id = "ability_2_name",
					pass_type = "text",
					text_id = "ability_2_name"
				},
				{
					style_id = "ability_2_description",
					pass_type = "text",
					text_id = "ability_2_description"
				}
			}
		},
		content = {
			career_icon = "simple_rect_texture",
			icon_frame = "icon_talent_frame",
			ability_2_icon = "icons_placeholder",
			ability_1_description = "n/a",
			ability_2_name = "n/a",
			ability_2_description = "n/a",
			ability_1_name = "n/a",
			ability_1_icon = "icons_placeholder",
			hero_text = "HERO_TEXT",
			detail = "radial_chat_bg_line",
			background = {
				texture_id = "headline_bg_60",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			top_detail = {
				angle = math.degrees_to_radians(-90),
				offset = {
					200,
					160,
					4
				},
				pivot = {
					2,
					200
				},
				texture_size = {
					4,
					400
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			bottom_detail = {
				angle = math.degrees_to_radians(-90),
				offset = {
					200,
					-var_123_0[2] + 160,
					4
				},
				pivot = {
					2,
					200
				},
				texture_size = {
					4,
					400
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			background = {
				vertical_alignment = "center",
				size = {
					var_123_0[1] + 20,
					var_123_0[2]
				},
				offset = {
					-20,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			hero_text = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				font_size = 40,
				horizontal_alignment = "right",
				use_shadow = false,
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_123_0[1],
					50
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-25,
					var_123_0[2] - 65,
					4
				}
			},
			career_icon = {
				size = {
					64,
					64
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					var_123_0[2] - 70,
					5
				}
			},
			ability_1_icon = {
				size = {
					64 * var_123_1,
					64 * var_123_1
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_123_0[1] - (64 * var_123_1 + 20),
					var_123_0[2] - (64 * var_123_1 + 80),
					5
				}
			},
			ability_1_icon_frame = {
				size = {
					64 * var_123_1,
					64 * var_123_1
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_123_0[1] - (64 * var_123_1 + 20),
					var_123_0[2] - (64 * var_123_1 + 80),
					6
				}
			},
			ability_1_name = {
				font_size = 24,
				upper_case = true,
				localize = false,
				word_wrap = false,
				use_shadow = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					var_123_0[1] - (64 * var_123_1 + 25),
					25
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					-10,
					var_123_0[2] - 110,
					2
				}
			},
			ability_1_description = {
				font_size = 20,
				localize = false,
				dynamic_font_size_word_wrap = true,
				word_wrap = true,
				use_shadow = true,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				font_type = "hell_shark",
				size = {
					var_123_0[1] - (64 * var_123_1 + 25),
					80
				},
				text_color = Colors.get_color_table_with_alpha("light_gray", 255),
				offset = {
					-10,
					var_123_0[2] - (64 * var_123_1 + 60 + 50),
					2
				}
			},
			ability_2_icon = {
				size = {
					64 * var_123_1,
					64 * var_123_1
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_123_0[1] - (64 * var_123_1 + 20),
					var_123_0[2] - (64 * var_123_1 + 220),
					5
				}
			},
			ability_2_icon_frame = {
				size = {
					64 * var_123_1,
					64 * var_123_1
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_123_0[1] - (64 * var_123_1 + 20),
					var_123_0[2] - (64 * var_123_1 + 220),
					6
				}
			},
			ability_2_name = {
				font_size = 24,
				upper_case = true,
				localize = false,
				word_wrap = false,
				use_shadow = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					var_123_0[1] - (64 * var_123_1 + 25),
					25
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					-10,
					var_123_0[2] - 245,
					2
				}
			},
			ability_2_description = {
				font_size = 20,
				localize = false,
				dynamic_font_size_word_wrap = true,
				word_wrap = true,
				use_shadow = true,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				font_type = "hell_shark",
				size = {
					var_123_0[1] - (64 * var_123_1 + 25),
					80
				},
				text_color = Colors.get_color_table_with_alpha("light_gray", 255),
				offset = {
					-10,
					30,
					2
				}
			}
		},
		scenegraph_id = arg_123_0,
		offset = arg_123_2 or {
			0,
			0,
			1
		}
	}
end

function UIWidgets.create_dark_pact_overcharge_bar_widget(arg_124_0, arg_124_1, arg_124_2, arg_124_3, arg_124_4, arg_124_5, arg_124_6)
	local var_124_0 = arg_124_5 or {
		250,
		56
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "icon_shadow",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "bar_fg",
					texture_id = "bar_fg"
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "bar_1",
					texture_id = "bar_1"
				}
			}
		},
		content = {
			icon = arg_124_4 or "tabs_icon_all_selected",
			bar_1 = arg_124_1 or "dark_pact_overcharge_bar",
			bar_fg = arg_124_2 or "circular_bar_background",
			size = {
				var_124_0[1] - 6,
				var_124_0[2]
			}
		},
		style = {
			bar_1 = {
				gradient_threshold = 0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					-1,
					4
				},
				size = {
					var_124_0[1],
					var_124_0[2]
				}
			},
			icon = {
				size = {
					0,
					0
				},
				offset = {
					var_124_0[1],
					var_124_0[2] / 2,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			icon_shadow = {
				size = {
					0,
					0
				},
				offset = {
					var_124_0[1] + 2,
					var_124_0[2] / 2 - 2,
					5
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			bar_fg = {
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
				},
				size = var_124_0
			}
		},
		offset = arg_124_6 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_124_0
	}
end

function UIWidgets.create_versus_gameplay_hint_widget(arg_125_0, arg_125_1, arg_125_2, arg_125_3)
	local var_125_0 = arg_125_1.close_input
	local var_125_1 = arg_125_3 or {
		400,
		360
	}
	local var_125_2 = arg_125_1.input_data
	local var_125_3

	if arg_125_1.foot_text then
		if var_125_2 then
			local var_125_4 = "$KEY;" .. var_125_2.input_service_name .. "__" .. var_125_2.input_action .. ":"

			var_125_3 = string.format(Localize(arg_125_1.foot_text), var_125_4)
		else
			var_125_3 = Localize(arg_125_1.foot_text)
		end
	end

	local var_125_5 = Localize(arg_125_1.title_text)
	local var_125_6 = Localize(arg_125_1.body_text)
	local var_125_7 = {
		passes = {
			{
				pass_type = "texture",
				style_id = "detail_bottom",
				texture_id = "detail"
			},
			{
				style_id = "detail_top",
				texture_id = "detail",
				pass_type = "texture",
				content_change_function = function(arg_126_0, arg_126_1)
					arg_126_1.offset[2] = arg_126_0.size[2] - 4
				end
			},
			{
				style_id = "background",
				texture_id = "background",
				pass_type = "texture",
				content_change_function = function(arg_127_0, arg_127_1)
					arg_127_1.size[2] = arg_127_0.size[2]
				end
			},
			{
				style_id = "title_text",
				pass_type = "text",
				text_id = "title_text",
				content_change_function = function(arg_128_0, arg_128_1)
					arg_128_1.offset[2] = arg_128_0.size[2] - 40 - 12
				end
			},
			{
				style_id = "body_text",
				pass_type = "text",
				text_id = "body_text",
				content_change_function = function(arg_129_0, arg_129_1)
					arg_129_1.size = {
						arg_129_0.size[1] - 20,
						arg_129_0.size[2]
					}
					arg_129_1.area_size = {
						arg_129_0.size[1] - 24,
						arg_129_0.size[2]
					}
				end
			}
		}
	}
	local var_125_8 = {
		background = "simple_rect_texture",
		detail = "radial_chat_bg_line_horz",
		title_text = var_125_5,
		body_text = var_125_6,
		size = var_125_1
	}
	local var_125_9 = {
		detail_top = {
			offset = {
				0,
				var_125_1[2] - 4,
				4
			},
			texture_size = {
				400,
				4
			},
			color = Colors.get_color_table_with_alpha("black", 255)
		},
		detail_bottom = {
			offset = {
				0,
				0,
				4
			},
			texture_size = {
				400,
				4
			},
			color = Colors.get_color_table_with_alpha("black", 255)
		},
		background = {
			size = var_125_1,
			offset = {
				0,
				0,
				1
			},
			color = Colors.get_color_table_with_alpha("black", 165)
		},
		title_text = {
			word_wrap = false,
			upper_case = true,
			localize = false,
			use_shadow = false,
			font_size = 40,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				var_125_1[1] - 20,
				40
			},
			offset = {
				20,
				var_125_1[2] - 40 - 12,
				4
			}
		},
		body_text = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			font_size = 18,
			font_type = "hell_shark",
			horizontal_alignment = "left",
			vertical_alignment = "top",
			use_shadow = false,
			size = {
				var_125_1[1] - 20,
				var_125_1[2]
			},
			area_size = {
				var_125_1[1] - 20,
				var_125_1[2]
			},
			text_color = Colors.get_color_table_with_alpha("light_gray", 255),
			offset = {
				20,
				-52,
				4
			}
		}
	}

	if arg_125_1.duration then
		local var_125_10 = "duration_bar"
		local var_125_11 = {
			pass_type = "texture_uv",
			content_id = var_125_10,
			style_id = var_125_10
		}
		local var_125_12 = {
			texture_id = "crafting_bar",
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
		local var_125_13 = {
			vertical_alignment = "left",
			offset = {
				0,
				6,
				8
			},
			texture_size = {
				400,
				8
			},
			color = Colors.get_color_table_with_alpha("local_player_picking", 255)
		}

		var_125_7.passes[#var_125_7.passes + 1] = var_125_11
		var_125_8[var_125_10] = var_125_12
		var_125_9[var_125_10] = var_125_13
	end

	if arg_125_1.foot_text then
		local var_125_14 = "foot_text"
		local var_125_15 = {
			pass_type = "text",
			text_id = var_125_14,
			style_id = var_125_14
		}
		local var_125_16 = var_125_3
		local var_125_17 = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			font_size = 20,
			font_type = "hell_shark",
			horizontal_alignment = "left",
			vertical_alignment = "center",
			use_shadow = false,
			size = {
				var_125_1[1] - 88,
				48
			},
			area_size = {
				var_125_1[1] - 88,
				48
			},
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				88,
				30,
				4
			}
		}

		var_125_7.passes[#var_125_7.passes + 1] = var_125_15
		var_125_8[var_125_14] = var_125_16
		var_125_9[var_125_14] = var_125_17
	end

	if arg_125_1.icon then
		local var_125_18 = "foot_icon"
		local var_125_19 = {
			pass_type = "texture",
			texture_id = var_125_18,
			style_id = var_125_18
		}
		local var_125_20 = arg_125_1.icon
		local var_125_21 = {
			vertical_alignment = "left",
			offset = {
				20,
				20,
				8
			},
			texture_size = {
				60,
				60
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		}

		var_125_7.passes[#var_125_7.passes + 1] = var_125_19
		var_125_8[var_125_18] = var_125_20
		var_125_9[var_125_18] = var_125_21
	end

	return {
		element = var_125_7,
		content = var_125_8,
		style = var_125_9,
		scenegraph_id = arg_125_0,
		offset = arg_125_2 or {
			0,
			0,
			0
		}
	}
end

function UIWidgets.create_large_insignia(arg_130_0, arg_130_1, arg_130_2, arg_130_3, arg_130_4, arg_130_5, arg_130_6)
	local var_130_0 = {}
	local var_130_1 = {
		passes = {}
	}
	local var_130_2 = var_130_1.passes
	local var_130_3 = {}
	local var_130_4 = {}
	local var_130_5 = arg_130_1 or ExperienceSettings.get_versus_level()
	local var_130_6, var_130_7 = UIAtlasHelper.get_insignia_texture_settings_from_level(var_130_5)
	local var_130_8 = arg_130_4 or {
		100,
		276
	}

	var_130_2[#var_130_2 + 1] = {
		style_id = "insignia_main",
		pass_type = "texture_uv",
		content_id = "insignia_main",
		retained_mode = arg_130_6
	}
	var_130_2[#var_130_2 + 1] = {
		style_id = "insignia_addon",
		pass_type = "texture_uv",
		content_id = "insignia_addon",
		content_check_function = function(arg_131_0, arg_131_1)
			return arg_131_0.uvs
		end,
		retained_mode = arg_130_6
	}
	var_130_4.insignia_main = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_130_8,
		color = arg_130_3,
		offset = {
			0,
			0,
			1
		},
		retained_mode = arg_130_6
	}
	var_130_4.insignia_addon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_130_8,
		color = arg_130_3,
		retained_mode = arg_130_6
	}
	var_130_3.insignia_main = {
		uvs = var_130_6,
		texture_id = arg_130_2 and "insignias_main_masked" or "insignias_main"
	}
	var_130_3.insignia_addon = {
		uvs = var_130_7,
		texture_id = arg_130_2 and "insignias_addon_masked" or "insignias_addon"
	}
	var_130_3.level = var_130_5
	var_130_0.element = var_130_1
	var_130_0.content = var_130_3
	var_130_0.style = var_130_4
	var_130_0.scenegraph_id = arg_130_0
	var_130_0.offset = arg_130_5 or {
		0,
		0,
		0
	}

	return var_130_0
end

function UIWidgets.create_small_insignia(arg_132_0, arg_132_1, arg_132_2, arg_132_3, arg_132_4, arg_132_5)
	local var_132_0 = {}
	local var_132_1 = {
		passes = {}
	}
	local var_132_2 = var_132_1.passes
	local var_132_3 = {}
	local var_132_4 = {}
	local var_132_5 = arg_132_1 or ExperienceSettings.get_versus_level()
	local var_132_6, var_132_7 = UIAtlasHelper.get_insignia_texture_settings_from_level(var_132_5)
	local var_132_8 = {
		50,
		138
	}

	var_132_2[#var_132_2 + 1] = {
		style_id = "insignia_main",
		pass_type = "texture_uv",
		content_id = "insignia_main",
		retained_mode = arg_132_5
	}
	var_132_2[#var_132_2 + 1] = {
		style_id = "insignia_addon",
		pass_type = "texture_uv",
		content_id = "insignia_addon",
		content_check_function = function(arg_133_0, arg_133_1)
			return arg_133_0.uvs
		end,
		retained_mode = arg_132_5
	}
	var_132_4.insignia_main = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_132_8,
		color = arg_132_3 or {
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
	var_132_4.insignia_addon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_132_8,
		color = arg_132_3 or {
			255,
			255,
			255,
			255
		}
	}
	var_132_3.insignia_main = {
		uvs = var_132_6,
		texture_id = arg_132_2 and "insignias_main_small_masked" or "insignias_main_small"
	}
	var_132_3.insignia_addon = {
		uvs = var_132_7,
		texture_id = arg_132_2 and "insignias_addon_small_masked" or "insignias_addon_small"
	}
	var_132_3.level = var_132_5
	var_132_3.visible = var_132_5 > 0
	var_132_0.element = var_132_1
	var_132_0.content = var_132_3
	var_132_0.style = var_132_4
	var_132_0.scenegraph_id = arg_132_0
	var_132_0.offset = arg_132_4 or {
		0,
		0,
		0
	}

	return var_132_0
end

function UIWidgets.create_ceremony_award(arg_134_0, arg_134_1, arg_134_2)
	local var_134_0 = {}
	local var_134_1 = {
		passes = {}
	}
	local var_134_2 = var_134_1.passes
	local var_134_3 = {}
	local var_134_4 = {}
	local var_134_5 = arg_134_1.player_name
	local var_134_6 = arg_134_1.level
	local var_134_7 = arg_134_1.peer_id == Network.peer_id()
	local var_134_8 = arg_134_1.is_mvp
	local var_134_9 = arg_134_1.header
	local var_134_10 = arg_134_1.sub_header
	local var_134_11 = arg_134_1.team_color
	local var_134_12, var_134_13 = UIAtlasHelper.get_insignia_texture_settings_from_level(var_134_6)
	local var_134_14 = {
		50,
		138
	}

	var_134_2[#var_134_2 + 1] = {
		style_id = "mvp",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function(arg_135_0, arg_135_1)
			return arg_135_0.is_mvp
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "mvp_masked",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function(arg_136_0, arg_136_1)
			return arg_136_0.is_mvp
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "shine",
		texture_id = "shine",
		pass_type = "texture",
		content_check_function = function(arg_137_0, arg_137_1)
			return arg_137_0.is_mvp
		end,
		content_change_function = function(arg_138_0, arg_138_1)
			local var_138_0 = Application.time_since_launch() % 2 / 2

			arg_138_1.offset[1] = math.lerp(-393, 393, var_138_0)
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "mvp_shadow",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function(arg_139_0, arg_139_1)
			return arg_139_0.is_mvp
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "sparkle",
		pass_type = "rotated_texture",
		texture_id = "sparkle",
		content_check_function = function(arg_140_0, arg_140_1)
			return arg_140_0.is_mvp
		end,
		content_change_function = function(arg_141_0, arg_141_1)
			local var_141_0 = Application.time_since_launch() % 2 / 2

			arg_141_1.angle = math.pi * 2 * var_141_0
			arg_141_1.color[1] = math.sin(var_141_0 * math.pi) * 255
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "sparkle_2",
		pass_type = "rotated_texture",
		texture_id = "sparkle",
		content_check_function = function(arg_142_0, arg_142_1)
			return arg_142_0.is_mvp
		end,
		content_change_function = function(arg_143_0, arg_143_1)
			local var_143_0 = (Application.time_since_launch() + 1.5) % 2 / 2

			arg_143_1.angle = math.pi * 2 * var_143_0
			arg_143_1.color[1] = math.sin(var_143_0 * math.pi) * 255
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "header",
		pass_type = "text",
		text_id = "header",
		content_check_function = function(arg_144_0, arg_144_1)
			return not arg_144_0.is_mvp
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "header_shadow",
		pass_type = "text",
		text_id = "header",
		content_check_function = function(arg_145_0, arg_145_1)
			return not arg_145_0.is_mvp
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "sub_header",
		pass_type = "text",
		text_id = "sub_header",
		content_check_function = function(arg_146_0, arg_146_1)
			return not arg_146_0.is_mvp
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "sub_header_shadow",
		pass_type = "text",
		text_id = "sub_header",
		content_check_function = function(arg_147_0, arg_147_1)
			return not arg_147_0.is_mvp
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "player_name",
		pass_type = "text",
		text_id = "player_name",
		content_change_function = function(arg_148_0)
			local var_148_0 = arg_148_0.widget_offset

			if not var_148_0 then
				return
			end

			local var_148_1 = arg_134_1.camera
			local var_148_2 = arg_134_1.world_pos
			local var_148_3 = Camera.world_to_screen(var_148_1, Vector3(var_148_2[1], var_148_2[2], var_148_2[3]))

			var_148_0[1] = UIInverseScaleVectorToResolution(var_148_3, true)[1] - 145
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "player_name_shadow",
		pass_type = "text",
		text_id = "player_name_shadow",
		content_change_function = function(arg_149_0)
			local var_149_0 = arg_149_0.widget_offset

			if not var_149_0 then
				return
			end

			local var_149_1 = arg_134_1.camera
			local var_149_2 = arg_134_1.world_pos
			local var_149_3 = Camera.world_to_screen(var_149_1, Vector3(var_149_2[1], var_149_2[2], var_149_2[3]))

			var_149_0[1] = UIInverseScaleVectorToResolution(var_149_3, true)[1] - 145
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "insignia_main",
		pass_type = "texture_uv",
		content_id = "insignia_main",
		content_check_function = function(arg_150_0, arg_150_1)
			return arg_150_0.parent.level > 0
		end
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "divider",
		pass_type = "texture_uv",
		content_id = "divider"
	}
	var_134_2[#var_134_2 + 1] = {
		style_id = "insignia_addon",
		pass_type = "texture_uv",
		content_id = "insignia_addon",
		content_check_function = function(arg_151_0, arg_151_1)
			return arg_151_0.uvs and arg_151_0.parent.level > 0
		end
	}
	var_134_4.mvp = {
		upper_case = true,
		localize = false,
		font_size = 80,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("dark_golden_rod", 255),
		offset = {
			60,
			-25,
			1
		}
	}
	var_134_4.mvp_masked = {
		upper_case = true,
		localize = false,
		font_size = 80,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header_masked",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			60,
			-25,
			2
		}
	}
	var_134_4.mvp_shadow = {
		upper_case = true,
		localize = false,
		font_size = 80,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			62,
			-27,
			0
		}
	}
	var_134_4.shine = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			393,
			256
		},
		offset = {
			-393,
			0,
			10
		}
	}
	var_134_4.sparkle = {
		vertical_alignment = "bottom",
		angle = 0,
		horizontal_alignment = "left",
		texture_size = {
			128,
			128
		},
		pivot = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			-10,
			5
		}
	}
	var_134_4.sparkle_2 = {
		vertical_alignment = "bottom",
		angle = 0,
		horizontal_alignment = "left",
		texture_size = {
			128,
			128
		},
		pivot = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			130,
			15,
			5
		}
	}
	var_134_4.header = {
		upper_case = true,
		localize = false,
		font_size = 48,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			60,
			-25,
			1
		}
	}
	var_134_4.header_shadow = {
		upper_case = true,
		localize = false,
		font_size = 48,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			62,
			-27,
			0
		}
	}
	var_134_4.sub_header = {
		font_size = 22,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			60,
			45,
			1
		}
	}
	var_134_4.sub_header_shadow = {
		font_size = 22,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			62,
			43,
			0
		}
	}
	var_134_4.player_name = {
		font_size = 26,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			200,
			100
		},
		text_color = {
			255,
			255,
			255,
			255
		},
		offset = {
			60,
			5,
			1
		}
	}
	var_134_4.player_name_shadow = {
		font_size = 26,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			200,
			100
		},
		text_color = {
			255,
			0,
			0,
			0
		},
		offset = {
			62,
			3,
			0
		}
	}
	var_134_4.insignia_main = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_134_14,
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
	var_134_4.divider = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		texture_size = {
			152,
			2
		},
		color = var_134_11 or {
			255,
			255,
			255,
			255
		},
		offset = {
			60,
			40,
			1
		}
	}
	var_134_4.insignia_addon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_134_14,
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_134_3.insignia_main = {
		texture_id = "insignias_main_small",
		uvs = var_134_12
	}
	var_134_3.insignia_addon = {
		texture_id = "insignias_addon_small",
		uvs = var_134_13
	}
	var_134_3.level = var_134_6
	var_134_3.award_data = arg_134_1
	var_134_3.divider = {
		texture_id = "horizontal_gradient",
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
	}
	var_134_3.is_mvp = var_134_8
	var_134_3.mvp = Localize("vs_award_mvp_name")
	var_134_3.header = var_134_9
	var_134_3.sub_header = var_134_10
	var_134_3.player_name = (var_134_7 and "{#color(255,255,255)}(" .. Localize("versus_hero_selection_view_you") .. ") {#reset()}" or "") .. string.format("{#color(%d,%d,%d)}%s{#reset()}", var_134_11[2], var_134_11[3], var_134_11[4], UIRenderer.crop_text(var_134_5, var_134_7 and 10 or 17))
	var_134_3.player_name_shadow = (var_134_7 and "(" .. Localize("versus_hero_selection_view_you") .. ") " or "") .. string.format("%s", UIRenderer.crop_text(var_134_5, var_134_7 and 10 or 17))
	var_134_3.shine = "diagonal_shine"
	var_134_3.sparkle = "sparkle_effect"
	var_134_0.element = var_134_1
	var_134_0.content = var_134_3
	var_134_0.style = var_134_4
	var_134_0.scenegraph_id = arg_134_0
	var_134_0.offset = arg_134_2 or {
		0,
		0,
		0
	}

	return var_134_0
end

local var_0_0 = {
	upper_case = true,
	localize = false,
	font_size = 130,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	area_size = {
		500,
		200
	},
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		20,
		-130,
		1
	}
}

function UIWidgets.create_screen_ceremony_award(arg_152_0, arg_152_1, arg_152_2, arg_152_3)
	local var_152_0 = {}
	local var_152_1 = {
		passes = {}
	}
	local var_152_2 = var_152_1.passes
	local var_152_3 = {}
	local var_152_4 = {}
	local var_152_5 = arg_152_1.player_name
	local var_152_6 = arg_152_1.level
	local var_152_7 = arg_152_1.amount
	local var_152_8 = arg_152_1.peer_id == Network.peer_id()
	local var_152_9 = arg_152_1.is_mvp
	local var_152_10 = arg_152_1.is_local
	local var_152_11 = arg_152_1.header
	local var_152_12 = arg_152_1.award_material or "circle"
	local var_152_13 = arg_152_1.award_mask_material or nil
	local var_152_14 = var_152_9 and Localize("vs_award_mvp_sub_header") or arg_152_1.sub_header
	local var_152_15 = arg_152_1.team_color
	local var_152_16, var_152_17 = UIAtlasHelper.get_insignia_texture_settings_from_level(var_152_6)
	local var_152_18 = {
		50,
		138
	}
	local var_152_19 = UIUtils.get_text_width(arg_152_3, var_0_0, var_152_7)

	var_152_2[#var_152_2 + 1] = {
		style_id = "mvp",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function(arg_153_0, arg_153_1)
			return arg_153_0.is_mvp
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "mvp_masked",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function(arg_154_0, arg_154_1)
			return arg_154_0.is_mvp
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "shine",
		texture_id = "shine",
		pass_type = "texture",
		content_check_function = function(arg_155_0, arg_155_1)
			return arg_155_0.is_mvp
		end,
		content_change_function = function(arg_156_0, arg_156_1)
			local var_156_0 = arg_156_0.shine_timer % 2 / 2

			arg_156_1.offset[1] = math.lerp(-393, 393, var_156_0)
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "mvp_shadow",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function(arg_157_0, arg_157_1)
			return arg_157_0.is_mvp
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "sparkle",
		pass_type = "rotated_texture",
		texture_id = "sparkle",
		content_check_function = function(arg_158_0, arg_158_1)
			return arg_158_0.is_mvp
		end,
		content_change_function = function(arg_159_0, arg_159_1)
			local var_159_0 = Application.time_since_launch() % 2 / 2

			arg_159_1.angle = math.pi * 2 * var_159_0
			arg_159_1.color[1] = math.sin(var_159_0 * math.pi) * 255
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "sparkle_2",
		pass_type = "rotated_texture",
		texture_id = "sparkle",
		content_check_function = function(arg_160_0, arg_160_1)
			return arg_160_0.is_mvp
		end,
		content_change_function = function(arg_161_0, arg_161_1)
			local var_161_0 = (Application.time_since_launch() + 1) % 2 / 2

			arg_161_1.angle = math.pi * 2 * var_161_0
			arg_161_1.color[1] = math.sin(var_161_0 * math.pi) * 255
		end
	}
	var_152_2[#var_152_2 + 1] = {
		pass_type = "texture",
		style_id = "background",
		texture_id = "background"
	}
	var_152_2[#var_152_2 + 1] = {
		pass_type = "texture",
		style_id = "award",
		texture_id = "award_texture"
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "award_shine_mask",
		texture_id = "award_shine_mask",
		pass_type = "texture",
		content_change_function = function(arg_162_0, arg_162_1)
			local var_162_0 = arg_162_0.shine_timer % 2 / 2

			arg_162_1.offset[1] = math.lerp(-393, 393, var_162_0)

			local var_162_1, var_162_2 = Managers.time:time_and_delta("main")

			arg_162_0.shine_timer = arg_162_0.shine_timer + var_162_2
		end
	}
	var_152_2[#var_152_2 + 1] = {
		pass_type = "texture",
		style_id = "award_shine",
		texture_id = "award_shine",
		content_check_function = function(arg_163_0)
			return arg_163_0.award_shine
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "team_bg",
		pass_type = "texture_uv",
		content_id = "team_bg"
	}
	var_152_2[#var_152_2 + 1] = {
		pass_type = "texture",
		style_id = "frame_top",
		texture_id = "frame"
	}
	var_152_2[#var_152_2 + 1] = {
		pass_type = "texture",
		style_id = "frame_bottom",
		texture_id = "frame"
	}
	var_152_2[#var_152_2 + 1] = {
		pass_type = "rotated_texture",
		style_id = "frame_right",
		texture_id = "frame"
	}
	var_152_2[#var_152_2 + 1] = {
		pass_type = "texture",
		style_id = "frame_middle",
		texture_id = "frame"
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "insignia_main",
		pass_type = "texture_uv",
		content_id = "insignia_main",
		content_check_function = function(arg_164_0, arg_164_1)
			return arg_164_0.parent.level > 0
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "insignia_addon",
		pass_type = "texture_uv",
		content_id = "insignia_addon",
		content_check_function = function(arg_165_0, arg_165_1)
			return arg_165_0.uvs and arg_165_0.parent.level > 0
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "header",
		pass_type = "text",
		text_id = "header",
		content_check_function = function(arg_166_0, arg_166_1)
			return not arg_166_0.is_mvp
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "header_shadow",
		pass_type = "text",
		text_id = "header",
		content_check_function = function(arg_167_0, arg_167_1)
			return not arg_167_0.is_mvp
		end
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "sub_header",
		pass_type = "text",
		text_id = "sub_header"
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "sub_header_shadow",
		pass_type = "text",
		text_id = "sub_header"
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "player_name",
		pass_type = "text",
		text_id = "player_name"
	}
	var_152_2[#var_152_2 + 1] = {
		style_id = "player_name_shadow",
		pass_type = "text",
		text_id = "player_name_shadow"
	}
	var_152_4.mvp = {
		upper_case = true,
		localize = false,
		font_size = 100,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		font_type = "hell_shark_header",
		area_size = {
			500,
			200
		},
		text_color = Colors.get_color_table_with_alpha("dark_golden_rod", 255),
		offset = {
			210,
			-70,
			1
		}
	}
	var_152_4.mvp_masked = {
		upper_case = true,
		localize = false,
		font_size = 100,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		font_type = "hell_shark_header_masked",
		area_size = {
			500,
			200
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			210,
			-70,
			2
		}
	}
	var_152_4.mvp_shadow = {
		upper_case = true,
		localize = false,
		font_size = 100,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		font_type = "hell_shark_header",
		area_size = {
			500,
			200
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			212,
			-72,
			0
		}
	}
	var_152_4.shine = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			393,
			256
		},
		offset = {
			-183,
			-70,
			10
		}
	}
	var_152_4.sparkle = {
		vertical_alignment = "bottom",
		angle = 0,
		horizontal_alignment = "left",
		texture_size = {
			128,
			128
		},
		pivot = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			160,
			95,
			5
		}
	}
	var_152_4.sparkle_2 = {
		vertical_alignment = "top",
		angle = 0,
		horizontal_alignment = "left",
		texture_size = {
			128,
			128
		},
		pivot = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			310,
			-20,
			5
		}
	}
	var_152_4.background = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			450,
			160
		},
		offset = {
			110,
			-70,
			0
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_152_4.award = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			225,
			230
		},
		offset = {
			-15,
			-35,
			10
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_152_4.award_shine = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			225,
			230
		},
		offset = {
			-15,
			-35,
			11
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_152_4.award_shine_mask = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			393,
			256
		},
		offset = {
			-15,
			-22,
			12
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_152_4.team_bg = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			450,
			50
		},
		offset = {
			110,
			-180,
			1
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local var_152_20 = 20

	var_152_4.frame_top = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			450,
			var_152_20
		},
		offset = {
			110,
			-70 + var_152_20,
			3
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_152_4.frame_bottom = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			450,
			var_152_20
		},
		offset = {
			110,
			-230 + var_152_20,
			3
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_152_4.frame_right = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			156,
			var_152_20
		},
		offset = {
			404,
			-70 + var_152_20,
			4
		},
		angle = -math.pi * 0.5,
		pivot = {
			156,
			0
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_152_4.frame_middle = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			446,
			var_152_20
		},
		offset = {
			110,
			-180 + var_152_20,
			3
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_152_4.insignia_main = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		texture_size = {
			50,
			138
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			50,
			-70,
			10
		}
	}
	var_152_4.insignia_addon = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		texture_size = {
			50,
			138
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			50,
			-70,
			9
		}
	}

	local var_152_21 = UTF8Utils.string_length(var_152_11) > 10 and 15 or 0

	var_152_4.header = {
		upper_case = true,
		localize = false,
		font_size = 65,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			255,
			200
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			215,
			140 + var_152_21,
			3
		}
	}
	var_152_4.header_shadow = {
		upper_case = true,
		localize = false,
		font_size = 65,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			255,
			200
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			213,
			138 + var_152_21,
			2
		}
	}
	var_152_4.sub_header = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_type = "hell_shark_header",
		font_size = 30,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		area_size = {
			255,
			200
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			220,
			120 + var_152_21 * 0.5,
			3
		}
	}
	var_152_4.sub_header_shadow = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_type = "hell_shark_header",
		font_size = 30,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		area_size = {
			255,
			200
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			222,
			118 + var_152_21 * 0.5,
			2
		}
	}
	var_152_4.player_name = {
		font_size = 30,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			500,
			100
		},
		text_color = {
			255,
			255,
			255,
			255
		},
		offset = {
			220,
			80,
			3
		}
	}
	var_152_4.player_name_shadow = {
		font_size = 30,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			500,
			200
		},
		text_color = {
			255,
			0,
			0,
			0
		},
		offset = {
			222,
			78,
			2
		}
	}
	var_152_3.insignia_main = {
		texture_id = "insignias_main_small",
		uvs = var_152_16
	}
	var_152_3.insignia_addon = {
		texture_id = "insignias_addon_small",
		uvs = var_152_17
	}
	var_152_3.level = var_152_6
	var_152_3.award_data = arg_152_1
	var_152_3.divider = {
		texture_id = "horizontal_gradient",
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
	}
	var_152_3.is_mvp = var_152_9
	var_152_3.mvp = Localize("vs_award_mvp_name")
	var_152_3.header = var_152_11
	var_152_3.sub_header = var_152_14
	var_152_3.player_name = (var_152_8 and "{#color(128,128,128)}(" .. Localize("versus_hero_selection_view_you") .. ") {#reset()}" or "") .. string.format("{#color(%d,%d,%d)}%s{#reset()}", var_152_15[2], var_152_15[3], var_152_15[4], UIRenderer.crop_text(var_152_5, var_152_8 and 10 or 17))
	var_152_3.player_name_shadow = (var_152_8 and "(" .. Localize("versus_hero_selection_view_you") .. ") " or "") .. string.format("%s", UIRenderer.crop_text(var_152_5, var_152_8 and 10 or 17))
	var_152_3.shine = "diagonal_shine"
	var_152_3.award_shine_mask = "diagonal_shine_write_mask"
	var_152_3.award_shine = var_152_13
	var_152_3.amount = var_152_7
	var_152_3.sparkle = "sparkle_effect"
	var_152_3.shine_timer = 0
	var_152_3.background = "award_bg"
	var_152_3.award_texture = var_152_12
	var_152_3.team_bg = {
		uvs = {
			{
				0,
				0.3125
			},
			{
				0.9,
				1
			}
		},
		texture_id = var_152_10 and "award_bg_local_team" or "award_bg_opponent_team"
	}
	var_152_3.frame = "divider_01_bottom"
	var_152_0.element = var_152_1
	var_152_0.content = var_152_3
	var_152_0.style = var_152_4
	var_152_0.scenegraph_id = arg_152_0
	var_152_0.offset = arg_152_2 or {
		0,
		0,
		0
	}

	return var_152_0
end

function UIWidgets.create_dark_pact_hud_ability_icon_widget(arg_168_0, arg_168_1)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_icon_bg",
					texture_id = "texture_icon"
				},
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon",
					content_check_function = function(arg_169_0)
						return arg_169_0.is_cooldown
					end
				},
				{
					style_id = "icon_mask",
					texture_id = "icon_mask",
					pass_type = "texture",
					content_change_function = function(arg_170_0, arg_170_1, arg_170_2, arg_170_3)
						arg_170_1.color[1] = 255 * math.abs(math.sin(Managers.time:time("ui") * 2.5))
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_frame",
					texture_id = "texture_frame"
				},
				{
					style_id = "texture_cooldown",
					texture_id = "texture_cooldown",
					pass_type = "gradient_mask_texture",
					content_check_function = function(arg_171_0)
						return arg_171_0.is_cooldown
					end,
					content_change_function = function(arg_172_0, arg_172_1, arg_172_2, arg_172_3)
						arg_172_1.color[1] = 255 * math.abs(math.sin(Managers.time:time("ui") * 2.5))
					end
				},
				{
					style_id = "input",
					pass_type = "text",
					text_id = "input",
					content_change_function = function(arg_173_0, arg_173_1)
						local var_173_0 = Managers.input:is_device_active("gamepad")
						local var_173_1 = var_173_0 and arg_173_0.settings.gamepad_input or arg_173_0.settings.input_action

						if arg_173_0.current_input_action ~= var_173_1 then
							arg_173_0.current_input_action = var_173_1

							local var_173_2 = Managers.input:get_service("Player")
							local var_173_3, var_173_4, var_173_5 = UISettings.get_gamepad_input_texture_data(var_173_2, var_173_1, var_173_0)

							if var_173_5 and var_173_5[1] == "mouse" or var_173_0 then
								arg_173_0.input = string.format("$KEY;Player__%s:", var_173_1)
								arg_173_1.offset[1] = 68
							else
								arg_173_0.input = var_173_4
								arg_173_1.offset[1] = 40
							end
						end
					end
				}
			}
		},
		content = {
			set_unsaturated = false,
			is_cooldown = false,
			texture_cooldown = "dark_pact_ability_icon_cooldown_gradient",
			progress = 0,
			texture_frame = "health_bar_ability_icon_frame",
			gris = "rect_masked",
			icon_mask = "dark_pact_ability_icon_gradient_mask",
			input = "n/a",
			texture_icon = arg_168_1 and arg_168_1.icon or "icons_placeholder",
			settings = arg_168_1 or {}
		},
		style = {
			texture_icon_bg = {
				saturated = false,
				size = {
					56,
					56
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					12,
					14,
					1
				}
			},
			texture_icon = {
				saturated = false,
				masked = true,
				size = {
					56,
					56
				},
				color = {
					255,
					100,
					100,
					100
				},
				offset = {
					12,
					14,
					2
				}
			},
			icon_mask = {
				size = {
					56,
					56
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					12,
					14,
					2
				}
			},
			texture_cooldown = {
				size = {
					56,
					56
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					12,
					14,
					3
				}
			},
			texture_frame = {
				size = {
					80,
					80
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
					4
				}
			},
			input = {
				font_type = "hell_shark",
				upper_case = false,
				localize = false,
				use_shadow = true,
				font_size = 26,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					0,
					0
				},
				area_size = {
					20,
					20
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					68,
					100,
					6
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_168_0
	}
end

function UIWidgets.create_dark_pact_selection_widget(arg_174_0)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "portrait_frame",
					texture_id = "portrait_frame"
				},
				{
					pass_type = "texture",
					style_id = "portrait",
					texture_id = "portrait"
				},
				{
					pass_type = "texture",
					style_id = "portrait_frame_selected",
					texture_id = "portrait_frame_selected"
				},
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				}
			}
		},
		content = {
			portrait = "icons_placeholder",
			portrait_frame_selected = "pactsworn_frame_highlight",
			portrait_frame = "pactsworn_frame_iron",
			selected = false,
			hotspot = {}
		},
		style = {
			portrait = {
				texture_size = {
					140,
					140
				},
				default_size = {
					140,
					140
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					3
				},
				default_offset = {
					0,
					0,
					3
				}
			},
			portrait_frame = {
				texture_size = {
					140,
					140
				},
				default_size = {
					140,
					140
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					5
				},
				default_offset = {
					0,
					0,
					5
				}
			},
			hotspot = {
				size = {
					140,
					140
				},
				default_size = {
					140,
					140
				},
				offset = {
					0,
					0,
					3
				},
				default_offset = {
					0,
					0,
					3
				}
			},
			portrait_frame_selected = {
				texture_size = {
					168,
					168
				},
				default_size = {
					168,
					168
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-14,
					-14,
					10
				},
				default_offset = {
					-14,
					-14,
					10
				}
			}
		},
		scenegraph_id = arg_174_0,
		offset = {
			0,
			0,
			1
		}
	}
end

function UIWidgets.create_settings_stepper_widget(arg_175_0, arg_175_1, arg_175_2, arg_175_3, arg_175_4, arg_175_5, arg_175_6)
	local var_175_0 = arg_175_1.values or {}
	local var_175_1 = #var_175_0 or 0
	local var_175_2 = "menu_settings_" .. arg_175_1.setting_name
	local var_175_3 = "tooltip_" .. arg_175_1.setting_name
	local var_175_4 = {
		24,
		24
	}
	local var_175_5 = {
		32,
		32
	}

	local function var_175_6(arg_176_0, arg_176_1, arg_176_2)
		local var_176_0 = arg_176_0.parent
		local var_176_1 = arg_176_0.hover_progress or 0
		local var_176_2 = 15

		if var_176_0.can_hover and arg_176_0.is_hover then
			var_176_1 = math.min(var_176_1 + arg_176_2 * var_176_2, 1)
		else
			var_176_1 = math.max(var_176_1 - arg_176_2 * var_176_2, 0)
		end

		arg_176_0.hover_progress = var_176_1

		local var_176_3 = arg_176_0.press_progress or 1
		local var_176_4 = 25

		if var_176_0.can_hover and arg_176_0.is_held then
			var_176_3 = math.max(var_176_3 - arg_176_2 * var_176_4, 0.5)
		else
			var_176_3 = math.min(var_176_3 + arg_176_2 * var_176_4, 1)
		end

		arg_176_0.press_progress = var_176_3
	end

	local function var_175_7(arg_177_0, arg_177_1, arg_177_2, arg_177_3)
		local var_177_0 = arg_177_2.hover_progress or 0
		local var_177_1 = arg_177_2.press_progress or 1

		arg_177_1.color[1] = 255 * var_177_0

		if arg_177_0.can_hover and arg_177_2.is_hover then
			arg_177_1.color[1] = 255 * var_177_1
		end
	end

	return {
		element = {
			passes = {
				{
					style_id = "setting_name",
					pass_type = "text",
					text_id = "setting_name",
					content_change_function = function(arg_178_0, arg_178_1, arg_178_2, arg_178_3)
						local var_178_0 = arg_178_0.fade_progress or 0

						arg_178_1.text_color[1] = 100 + 155 * var_178_0
					end
				},
				{
					style_id = "left_arrow",
					pass_type = "texture_uv",
					content_id = "left_arrow",
					content_change_function = function(arg_179_0, arg_179_1, arg_179_2, arg_179_3)
						local var_179_0 = arg_179_0.parent.fade_progress or 0

						arg_179_1.color[1] = 100 + 155 * var_179_0
					end
				},
				{
					style_id = "left_arrow_hover",
					pass_type = "texture_uv",
					content_id = "left_arrow_hover",
					content_check_function = function(arg_180_0, arg_180_1)
						return arg_180_0.parent.is_server
					end,
					content_change_function = function(arg_181_0, arg_181_1, arg_181_2, arg_181_3)
						local var_181_0 = arg_181_0.parent.left_arrow_hotspot

						var_175_7(arg_181_0, arg_181_1, var_181_0)
					end
				},
				{
					style_id = "left_arrow_hotspot",
					pass_type = "hotspot",
					content_id = "left_arrow_hotspot",
					content_check_function = function(arg_182_0, arg_182_1)
						return arg_182_0.parent.is_server and arg_182_0.parent.focused
					end,
					content_change_function = function(arg_183_0, arg_183_1, arg_183_2, arg_183_3)
						local var_183_0 = arg_183_0.parent

						var_175_6(arg_183_0, arg_183_1, arg_183_3)
					end
				},
				{
					pass_type = "texture",
					style_id = "setting_value_bg",
					texture_id = "setting_value_bg"
				},
				{
					style_id = "setting_value",
					pass_type = "text",
					text_id = "setting_value",
					content_change_function = function(arg_184_0, arg_184_1, arg_184_2, arg_184_3)
						local var_184_0 = arg_184_0.data.values
						local var_184_1 = arg_184_0.ui_data
						local var_184_2 = var_184_0[arg_184_0.setting_idx]

						if arg_184_0.value ~= var_184_2 then
							arg_184_0.value = var_184_2

							local var_184_3 = var_184_1 and var_184_1.localization_options
							local var_184_4 = ""

							if var_184_3 and var_184_3[var_184_2] then
								local var_184_5 = var_184_3[var_184_2]

								var_184_4 = Localize(var_184_5)
							else
								var_184_4 = string.format("%s", arg_184_0.value)
							end

							if (not var_184_3 or not var_184_3[var_184_2]) and var_184_1 and var_184_1.setting_type then
								local var_184_6 = DLCSettings.carousel and DLCSettings.carousel.custom_game_settigns_values_suffix

								if var_184_6 and var_184_6[var_184_1.setting_type] then
									var_184_4 = var_184_4 .. var_184_6[var_184_1.setting_type]
								end
							end

							arg_184_0.setting_value = var_184_4
						end

						if arg_184_0.value ~= arg_184_0.default_value then
							arg_184_1.text_color = arg_184_1.modified_color
						else
							arg_184_1.text_color = arg_184_1.default_color
						end

						local var_184_7 = arg_184_0.fade_progress or 0

						arg_184_1.text_color[1] = 100 + 155 * var_184_7
					end
				},
				{
					style_id = "right_arrow",
					texture_id = "right_arrow",
					pass_type = "texture",
					content_change_function = function(arg_185_0, arg_185_1, arg_185_2, arg_185_3)
						local var_185_0 = arg_185_0.fade_progress or 0

						arg_185_1.color[1] = 100 + 155 * var_185_0
					end
				},
				{
					style_id = "right_arrow_hover",
					texture_id = "right_arrow_hover",
					pass_type = "texture",
					content_check_function = function(arg_186_0, arg_186_1)
						return arg_186_0.is_server
					end,
					content_change_function = function(arg_187_0, arg_187_1, arg_187_2, arg_187_3)
						local var_187_0 = arg_187_0.right_arrow_hotspot

						var_175_7(arg_187_0, arg_187_1, var_187_0)
					end
				},
				{
					style_id = "right_arrow_hotspot",
					pass_type = "hotspot",
					content_id = "right_arrow_hotspot",
					content_check_function = function(arg_188_0, arg_188_1)
						return arg_188_0.parent.is_server and arg_188_0.parent.focused
					end,
					content_change_function = function(arg_189_0, arg_189_1, arg_189_2, arg_189_3)
						local var_189_0 = arg_189_0.parent

						var_175_6(arg_189_0, arg_189_1, arg_189_3)
					end
				},
				{
					pass_type = "texture",
					style_id = "divider",
					texture_id = "divider"
				},
				{
					style_id = "setting_highlight_hotspot",
					pass_type = "hotspot",
					content_id = "setting_highlight_hotspot",
					content_change_function = function(arg_190_0, arg_190_1, arg_190_2, arg_190_3)
						local var_190_0 = arg_190_0.hover_progress or 0
						local var_190_1 = 15

						if arg_190_0.parent.can_hover and arg_190_0.is_hover or arg_190_0.parent.is_gamepad_active and arg_190_0.parent.focused and arg_190_0.parent.is_selected then
							var_190_0 = math.min(var_190_0 + arg_190_3 * var_190_1, 1)
						else
							var_190_0 = math.max(var_190_0 - arg_190_3 * var_190_1, 0)
						end

						arg_190_0.hover_progress = var_190_0
					end
				},
				{
					style_id = "setting_highlight",
					texture_id = "setting_highlight",
					pass_type = "texture",
					content_change_function = function(arg_191_0, arg_191_1, arg_191_2, arg_191_3)
						local var_191_0 = arg_191_0.setting_highlight_hotspot.hover_progress or 0

						arg_191_1.color[1] = 255 * var_191_0
					end
				},
				{
					pass_type = "texture",
					style_id = "reset_setting_button",
					texture_id = "reset_setting_button",
					content_check_function = function(arg_192_0, arg_192_1)
						local var_192_0 = arg_192_0.data.values
						local var_192_1 = arg_192_0.ui_data

						return arg_192_0.value ~= arg_192_0.default_value and arg_192_0.is_server and not arg_192_0.is_gamepad_active
					end
				},
				{
					style_id = "reset_setting_button_hovered",
					texture_id = "reset_setting_button_hovered",
					pass_type = "texture",
					content_check_function = function(arg_193_0, arg_193_1)
						local var_193_0 = arg_193_0.data.values
						local var_193_1 = arg_193_0.ui_data

						return arg_193_0.value ~= arg_193_0.default_value and arg_193_0.is_server and not arg_193_0.is_gamepad_active and arg_193_0.focused
					end,
					content_change_function = function(arg_194_0, arg_194_1, arg_194_2, arg_194_3)
						local var_194_0 = arg_194_0.reset_setting_button_hotspot

						var_175_7(arg_194_0, arg_194_1, var_194_0)
					end
				},
				{
					style_id = "reset_setting_button_hotspot",
					pass_type = "hotspot",
					content_id = "reset_setting_button_hotspot",
					content_check_function = function(arg_195_0, arg_195_1)
						local var_195_0 = arg_195_0.parent
						local var_195_1 = var_195_0.data.values
						local var_195_2 = var_195_0.ui_data
						local var_195_3 = var_195_0.setting_idx
						local var_195_4 = var_195_0.default_idx

						return var_195_0.value ~= var_195_0.default_value and var_195_0.is_server and not var_195_0.is_gamepad_active
					end,
					content_change_function = function(arg_196_0, arg_196_1, arg_196_2, arg_196_3)
						local var_196_0 = arg_196_0.parent

						var_175_6(arg_196_0, arg_196_1, arg_196_3)
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function(arg_197_0, arg_197_1)
						return arg_197_0.can_hover and arg_197_0.setting_highlight_hotspot.is_hover
					end
				}
			}
		},
		content = {
			reset_setting_button_hovered = "achievement_refresh_on",
			right_arrow_hover = "arrow_on",
			default_idx = 1,
			default_value = 0,
			setting_highlight = "party_selection_glow",
			reset_setting_button = "achievement_refresh_off",
			setting_value_bg = "rect_masked",
			right_arrow = "arrow_off_01",
			divider = "rect_masked",
			data = arg_175_1,
			ui_data = arg_175_2,
			id = arg_175_5,
			name = arg_175_1.setting_name,
			on_setting_changed_cb = arg_175_6,
			settings = var_175_0,
			num_settings = var_175_1,
			setting_idx = arg_175_4,
			setting_value = tostring(arg_175_3),
			setting_name = var_175_2,
			left_arrow = {
				texture_id = "arrow_off_01",
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
			left_arrow_hover = {
				texture_id = "arrow_on",
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
			left_arrow_hotspot = {
				allow_multi_hover = true
			},
			right_arrow_hotspot = {
				allow_multi_hover = true
			},
			setting_highlight_hotspot = {
				allow_multi_hover = true
			},
			reset_setting_button_hotspot = {
				allow_multi_hover = true
			},
			tooltip_text = var_175_3
		},
		style = {
			setting_name = {
				upper_case = false,
				localize = true,
				vertical_alignment = "center",
				font_size = 20,
				horizontal_alignment = "left",
				use_shadow = true,
				masked = true,
				font_type = "hell_shark_masked",
				size = {
					380,
					30
				},
				area_size = {
					380,
					30
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					3
				}
			},
			left_arrow = {
				masked = true,
				texture_size = var_175_5,
				offset = {
					398,
					0,
					3
				},
				color = Colors.get_color_table_with_alpha("white", 120)
			},
			left_arrow_hover = {
				masked = true,
				texture_size = var_175_5,
				offset = {
					398,
					0,
					5
				},
				color = Colors.get_color_table_with_alpha("white", 120)
			},
			left_arrow_hotspot = {
				size = var_175_5,
				offset = {
					398,
					0,
					3
				}
			},
			setting_value_bg = {
				masked = true,
				size = {
					128,
					30
				},
				offset = {
					430,
					0,
					4
				},
				color = Colors.get_color_table_with_alpha("black", 120)
			},
			setting_value = {
				masked = true,
				upper_case = false,
				localize = false,
				font_type = "hell_shark_masked",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					128,
					30
				},
				area_size = {
					128,
					30
				},
				modified_color = Colors.get_color_table_with_alpha("pale_golden_rod", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 180),
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					430,
					0,
					5
				}
			},
			right_arrow = {
				masked = true,
				texture_size = var_175_5,
				offset = {
					560,
					0,
					3
				},
				color = Colors.get_color_table_with_alpha("white", 120)
			},
			right_arrow_hover = {
				masked = true,
				texture_size = var_175_5,
				offset = {
					560,
					0,
					4
				},
				color = Colors.get_color_table_with_alpha("white", 120)
			},
			right_arrow_hotspot = {
				size = var_175_5,
				offset = {
					560,
					0,
					3
				}
			},
			divider = {
				masked = true,
				size = {
					620,
					2
				},
				offset = {
					0,
					-2,
					1
				},
				color = Colors.get_color_table_with_alpha("gray", 100)
			},
			setting_highlight_hotspot = {
				size = {
					640,
					34
				},
				offset = {
					0,
					0,
					1
				}
			},
			setting_highlight = {
				masked = true,
				texture_size = {
					640,
					34
				},
				offset = {
					0,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button = {
				masked = true,
				texture_size = var_175_4,
				offset = {
					594,
					4,
					3
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button_hovered = {
				masked = true,
				texture_size = var_175_4,
				offset = {
					594,
					4,
					4
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button_hotspot = {
				size = var_175_4,
				offset = {
					594,
					4,
					1
				}
			},
			tooltip_text = {
				font_type = "hell_shark_masked",
				upper_case = false,
				localize = true,
				use_shadow = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					180,
					30
				},
				area_size = {
					180,
					30
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
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
			1
		},
		scenegraph_id = arg_175_0
	}
end

function UIWidgets.create_settings_slider_widget(arg_198_0, arg_198_1, arg_198_2, arg_198_3, arg_198_4, arg_198_5, arg_198_6)
	local var_198_0 = arg_198_1.values or {}
	local var_198_1 = #var_198_0 or 1
	local var_198_2 = "menu_settings_" .. arg_198_1.setting_name
	local var_198_3 = "tooltip_" .. arg_198_1.setting_name
	local var_198_4 = {
		24,
		24
	}
	local var_198_5 = {
		100,
		30
	}
	local var_198_6 = {
		200,
		8
	}
	local var_198_7 = 640 - var_198_6[1] - 138 + 8
	local var_198_8 = var_198_7 + var_198_6[1]
	local var_198_9 = UIFrameSettings.button_frame_02
	local var_198_10 = {
		11.9,
		22.95
	}
	local var_198_11 = {
		28.9,
		21.25
	}
	local var_198_12 = arg_198_4
	local var_198_13 = math.clamp(var_198_12 / var_198_1, 0, 1)

	local function var_198_14(arg_199_0, arg_199_1, arg_199_2)
		local var_199_0 = arg_199_0.parent
		local var_199_1 = arg_199_0.hover_progress or 0
		local var_199_2 = 15

		if var_199_0.can_hover and arg_199_0.is_hover then
			var_199_1 = math.min(var_199_1 + arg_199_2 * var_199_2, 1)
		else
			var_199_1 = math.max(var_199_1 - arg_199_2 * var_199_2, 0)
		end

		arg_199_0.hover_progress = var_199_1

		local var_199_3 = arg_199_0.press_progress or 1
		local var_199_4 = 25

		if var_199_0.can_hover and arg_199_0.is_held then
			var_199_3 = math.max(var_199_3 - arg_199_2 * var_199_4, 0.5)
		else
			var_199_3 = math.min(var_199_3 + arg_199_2 * var_199_4, 1)
		end

		arg_199_0.press_progress = var_199_3
	end

	local function var_198_15(arg_200_0, arg_200_1, arg_200_2, arg_200_3)
		local var_200_0 = arg_200_2.hover_progress or 0
		local var_200_1 = arg_200_2.press_progress or 1

		arg_200_1.color[1] = 255 * var_200_0

		if arg_200_0.can_hover and arg_200_2.is_hover then
			arg_200_1.color[1] = 255 * var_200_1
		end
	end

	return {
		element = {
			passes = {
				{
					style_id = "setting_name",
					pass_type = "text",
					text_id = "setting_name",
					content_change_function = function(arg_201_0, arg_201_1, arg_201_2, arg_201_3)
						local var_201_0 = arg_201_0.fade_progress or 0

						arg_201_1.text_color[1] = 100 + 155 * var_201_0
					end
				},
				{
					pass_type = "texture",
					style_id = "setting_value_bg",
					texture_id = "setting_value_bg"
				},
				{
					style_id = "setting_value",
					pass_type = "text",
					text_id = "setting_value",
					content_change_function = function(arg_202_0, arg_202_1, arg_202_2, arg_202_3)
						local var_202_0 = arg_202_0.data.values
						local var_202_1 = arg_202_0.ui_data
						local var_202_2 = var_202_0[arg_202_0.setting_idx]

						if arg_202_0.value ~= var_202_2 then
							arg_202_0.value = var_202_2

							local var_202_3 = var_202_1 and var_202_1.localization_options
							local var_202_4 = ""

							if var_202_3 and var_202_3[var_202_2] then
								local var_202_5 = var_202_3[var_202_2]

								var_202_4 = Localize(var_202_5)
							elseif type(arg_202_0.value) == "number" and var_202_1 and var_202_1.setting_type == "multiplier" then
								var_202_4 = string.format("%.2f", arg_202_0.value)
							else
								var_202_4 = string.format("%s", arg_202_0.value)
							end

							if (not var_202_3 or not var_202_3[var_202_2]) and var_202_1 and var_202_1.setting_type then
								local var_202_6 = DLCSettings.carousel and DLCSettings.carousel.custom_game_settigns_values_suffix

								if var_202_6 and var_202_6[var_202_1.setting_type] then
									var_202_4 = var_202_4 .. var_202_6[var_202_1.setting_type]
								end
							end

							arg_202_0.setting_value = var_202_4
						end

						if arg_202_0.value ~= arg_202_0.default_value then
							arg_202_1.text_color = arg_202_1.modified_color
						else
							arg_202_1.text_color = arg_202_1.default_color
						end

						local var_202_7 = arg_202_0.fade_progress or 0

						arg_202_1.text_color[1] = 100 + 155 * var_202_7
					end
				},
				{
					pass_type = "texture",
					style_id = "divider",
					texture_id = "divider"
				},
				{
					style_id = "setting_highlight_hotspot",
					pass_type = "hotspot",
					content_id = "setting_highlight_hotspot",
					content_change_function = function(arg_203_0, arg_203_1, arg_203_2, arg_203_3)
						local var_203_0 = arg_203_0.hover_progress or 0
						local var_203_1 = 15

						if arg_203_0.parent.can_hover and arg_203_0.is_hover or arg_203_0.parent.is_gamepad_active and arg_203_0.parent.focused and arg_203_0.parent.is_selected then
							var_203_0 = math.min(var_203_0 + arg_203_3 * var_203_1, 1)
						else
							var_203_0 = math.max(var_203_0 - arg_203_3 * var_203_1, 0)
						end

						arg_203_0.hover_progress = var_203_0
					end
				},
				{
					style_id = "setting_highlight",
					texture_id = "setting_highlight",
					pass_type = "texture",
					content_change_function = function(arg_204_0, arg_204_1, arg_204_2, arg_204_3)
						local var_204_0 = arg_204_0.setting_highlight_hotspot.hover_progress or 0

						arg_204_1.color[1] = 255 * var_204_0
					end
				},
				{
					pass_type = "texture",
					style_id = "reset_setting_button",
					texture_id = "reset_setting_button",
					content_check_function = function(arg_205_0, arg_205_1)
						local var_205_0 = arg_205_0.data.values
						local var_205_1 = arg_205_0.ui_data

						return arg_205_0.value ~= arg_205_0.default_value and arg_205_0.is_server and not arg_205_0.is_gamepad_active
					end
				},
				{
					style_id = "reset_setting_button_hovered",
					texture_id = "reset_setting_button_hovered",
					pass_type = "texture",
					content_check_function = function(arg_206_0, arg_206_1)
						local var_206_0 = arg_206_0.data.values
						local var_206_1 = arg_206_0.ui_data

						return arg_206_0.value ~= arg_206_0.default_value and arg_206_0.is_server and not arg_206_0.is_gamepad_active and arg_206_0.focused
					end,
					content_change_function = function(arg_207_0, arg_207_1, arg_207_2, arg_207_3)
						local var_207_0 = arg_207_0.reset_setting_button_hotspot

						var_198_15(arg_207_0, arg_207_1, var_207_0)
					end
				},
				{
					style_id = "reset_setting_button_hotspot",
					pass_type = "hotspot",
					content_id = "reset_setting_button_hotspot",
					content_check_function = function(arg_208_0, arg_208_1)
						local var_208_0 = arg_208_0.parent
						local var_208_1 = var_208_0.data.values
						local var_208_2 = var_208_0.ui_data
						local var_208_3 = var_208_0.setting_idx
						local var_208_4 = var_208_0.default_idx

						return var_208_0.value ~= var_208_0.default_value and var_208_0.is_server and not var_208_0.is_gamepad_active
					end,
					content_change_function = function(arg_209_0, arg_209_1, arg_209_2, arg_209_3)
						local var_209_0 = arg_209_0.parent

						var_198_14(arg_209_0, arg_209_1, arg_209_3)
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function(arg_210_0, arg_210_1)
						return arg_210_0.can_hover and arg_210_0.setting_highlight_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "slider_background",
					texture_id = "slider_background"
				},
				{
					pass_type = "texture_frame",
					style_id = "background_frame",
					texture_id = "background_frame"
				},
				{
					pass_type = "texture",
					style_id = "slider_button",
					texture_id = "slider_button",
					content_check_function = function(arg_211_0, arg_211_1)
						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "slider_button_hovered",
					texture_id = "slider_button_hovered",
					content_check_function = function(arg_212_0, arg_212_1)
						return arg_212_0.can_hover and arg_212_0.slider_button_hotspot.is_hover
					end
				},
				{
					content_check_hover = "slider_button_hotspot",
					pass_type = "held",
					style_id = "slider_background",
					held_function = function(arg_213_0, arg_213_1, arg_213_2, arg_213_3)
						if Managers.input:is_device_active("gamepad") then
							return
						end

						if not arg_213_2.can_hover then
							return
						end

						local var_213_0 = UIInverseScaleVectorToResolution(arg_213_3:get("cursor"))
						local var_213_1 = arg_213_2.scenegraph_id
						local var_213_2 = UISceneGraph.get_world_position(arg_213_0, var_213_1)
						local var_213_3 = arg_213_1.size[1]
						local var_213_4 = var_213_0[1] - (var_213_2[1] + arg_213_1.offset[1] + 20)

						arg_213_2.current_slider_value = math.clamp(var_213_4 / var_213_3, 0, 1)
					end,
					release_function = function(arg_214_0, arg_214_1, arg_214_2, arg_214_3)
						local var_214_0 = arg_214_2.id
						local var_214_1 = arg_214_2.setting_idx

						arg_214_2.on_setting_changed_cb(var_214_0, var_214_1)
					end
				},
				{
					style_id = "slider_button_hotspot",
					pass_type = "hotspot",
					content_id = "slider_button_hotspot",
					content_check_function = function(arg_215_0, arg_215_1)
						return arg_215_0.parent.can_hover and arg_215_0.parent.is_server and arg_215_0.parent.focused
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function(arg_216_0, arg_216_1, arg_216_2)
						local var_216_0 = arg_216_2.current_slider_value
						local var_216_1 = 1
						local var_216_2 = arg_216_2.num_settings

						if not arg_216_2.is_gamepad_active then
							arg_216_2.setting_idx = math.clamp(math.round(var_216_2 * var_216_0), var_216_1, var_216_2)
						end

						local var_216_3 = arg_216_1.slider_background
						local var_216_4 = var_216_3.size
						local var_216_5 = var_216_3.offset[1]
						local var_216_6 = var_216_4[1] * var_216_0
						local var_216_7 = arg_216_1.slider_button
						local var_216_8 = arg_216_1.slider_button_hovered
						local var_216_9 = arg_216_1.slider_button_hotspot
						local var_216_10 = var_216_7.offset
						local var_216_11 = var_216_7.texture_size
						local var_216_12 = math.max(0, math.min(var_216_6 - var_216_11[1], var_216_4[1] - var_216_11[1]))

						var_216_7.offset[1] = var_216_5 + var_216_6 - var_216_11[1] / 2
						var_216_8.offset[1] = var_216_7.offset[1] + var_216_11[1] / 2 - var_216_8.texture_size[1] / 2
						var_216_9.offset[1] = var_216_7.offset[1] + var_216_11[1] / 2 - var_216_9.size[1] / 2
					end
				}
			}
		},
		content = {
			reset_setting_button_hovered = "achievement_refresh_on",
			reset_setting_button = "achievement_refresh_off",
			setting_highlight = "party_selection_glow",
			default_value = 0,
			slider_button = "slider_thumb",
			slider_background = "rect_masked",
			setting_value_bg = "rect_masked",
			divider = "rect_masked",
			slider_button_hovered = "slider_thumb_hover",
			default_idx = 1,
			data = arg_198_1,
			ui_data = arg_198_2,
			id = arg_198_5,
			name = arg_198_1.setting_name,
			on_setting_changed_cb = arg_198_6,
			settings = var_198_0,
			num_settings = var_198_1,
			setting_idx = arg_198_4,
			setting_value = tostring(arg_198_3),
			setting_name = var_198_2,
			setting_highlight_hotspot = {
				allow_multi_hover = true
			},
			reset_setting_button_hotspot = {
				allow_multi_hover = true
			},
			tooltip_text = var_198_3,
			background_frame = var_198_9.texture,
			slider_button_hotspot = {
				allow_multi_hover = true
			},
			current_slider_value = var_198_13,
			min_offset = var_198_7,
			max_offset = var_198_8,
			scenegraph_id = arg_198_0
		},
		style = {
			setting_name = {
				masked = true,
				upper_case = false,
				localize = true,
				font_type = "hell_shark_masked",
				font_size = 20,
				vertical_alignment = "center",
				horizontal_alignment = "left",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					300,
					30
				},
				area_size = {
					300,
					30
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					2,
					3
				}
			},
			setting_value_bg = {
				masked = true,
				size = {
					var_198_5[1] - 32,
					var_198_5[2]
				},
				offset = {
					640 - var_198_5[1] - 20,
					2,
					4
				},
				color = Colors.get_color_table_with_alpha("black", 120)
			},
			setting_value = {
				masked = true,
				upper_case = false,
				localize = false,
				font_type = "hell_shark_masked",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					var_198_5[1] - 32,
					var_198_5[2]
				},
				area_size = {
					var_198_5[1] - 36,
					var_198_5[2]
				},
				modified_color = Colors.get_color_table_with_alpha("pale_golden_rod", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 180),
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					640 - var_198_5[1] - 20,
					2,
					5
				}
			},
			divider = {
				masked = true,
				size = {
					620,
					2
				},
				offset = {
					0,
					-2,
					1
				},
				color = Colors.get_color_table_with_alpha("gray", 100)
			},
			setting_highlight_hotspot = {
				size = {
					640,
					34
				},
				offset = {
					0,
					0,
					1
				}
			},
			setting_highlight = {
				masked = true,
				texture_size = {
					640,
					34
				},
				offset = {
					0,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button = {
				masked = true,
				texture_size = var_198_4,
				offset = {
					594,
					4,
					3
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button_hovered = {
				masked = true,
				texture_size = var_198_4,
				offset = {
					594,
					4,
					4
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button_hotspot = {
				size = var_198_4,
				offset = {
					594,
					4,
					1
				}
			},
			tooltip_text = {
				font_type = "hell_shark_masked",
				upper_case = false,
				localize = true,
				use_shadow = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					180,
					30
				},
				area_size = {
					180,
					30
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					4,
					1
				}
			},
			slider_background = {
				masked = true,
				size = var_198_6,
				offset = {
					var_198_7,
					8,
					5
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			background_frame = {
				masked = true,
				frame_margins = {
					-3,
					-3
				},
				size = var_198_6,
				texture_size = var_198_9.texture_size,
				texture_sizes = var_198_9.texture_sizes,
				offset = {
					var_198_7,
					8,
					6
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			slider_button = {
				masked = true,
				texture_size = var_198_10,
				offset = {
					0,
					2,
					7
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			slider_button_hovered = {
				masked = true,
				texture_size = var_198_11,
				offset = {
					0,
					2,
					8
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			slider_button_hotspot = {
				size = var_198_11,
				offset = {
					0,
					2,
					9
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			}
		},
		offset = {
			0,
			0,
			1
		},
		scenegraph_id = arg_198_0
	}
end
