-- chunkname: @scripts/ui/views/hero_view/states/definitions/achievement_widget_definition.lua

return function(arg_1_0, arg_1_1)
	local var_1_0 = UIFrameSettings.menu_frame_12
	local var_1_1 = UIFrameSettings.button_frame_01
	local var_1_2 = UIFrameSettings.frame_outer_glow_01
	local var_1_3 = var_1_2.texture_sizes.corner[1]
	local var_1_4 = "menu_frame_bg_01"
	local var_1_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_4)
	local var_1_6 = "button_bg_01"
	local var_1_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_6)
	local var_1_8 = "button_detail_03"
	local var_1_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_8).size
	local var_1_10 = true
	local var_1_11 = {
		500,
		42
	}
	local var_1_12 = 13
	local var_1_13 = {
		800,
		100
	}
	local var_1_14 = {
		var_1_13[1] / 2,
		30
	}
	local var_1_15 = -(arg_1_1[2] - 10)
	local var_1_16 = {
		allow_multi_hover = true
	}
	local var_1_17 = {}
	local var_1_18 = 15

	for iter_1_0 = 1, var_1_18 do
		var_1_16[iter_1_0] = {
			text = "n/a",
			checkbox_marker = "matchmaking_checkbox",
			checkbox = "achievement_checkbox",
			button_hotspot = {}
		}
		var_1_17[iter_1_0] = {
			list_member_offset = {
				0,
				-var_1_14[2],
				0
			},
			size = var_1_14,
			text = {
				word_wrap = true,
				upper_case = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					31,
					0,
					2
				},
				size = {
					300,
					100
				}
			},
			text_shadow = {
				vertical_alignment = "center",
				upper_case = false,
				font_size = 22,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 0),
				offset = {
					33,
					-2,
					1
				}
			},
			checkbox = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "left",
				texture_size = {
					25,
					25
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					-2,
					1
				}
			},
			checkbox_marker = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "left",
				texture_size = {
					37,
					31
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					1,
					2
				}
			}
		}
	end

	local var_1_19 = {
		element = {}
	}
	local var_1_20 = {
		{
			style_id = "button_hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			texture_id = "hover_glow",
			style_id = "hover_glow",
			pass_type = "texture",
			content_check_function = function(arg_2_0)
				return arg_2_0.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "tiled_texture",
			style_id = "expand_background",
			texture_id = "expand_background",
			content_check_function = function(arg_3_0)
				return arg_3_0.expanded
			end
		},
		{
			pass_type = "texture",
			style_id = "expand_background_edge",
			texture_id = "expand_background_edge",
			content_check_function = function(arg_4_0)
				return arg_4_0.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "expand_background_shadow",
			texture_id = "expand_background_shadow",
			content_check_function = function(arg_5_0)
				return arg_5_0.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			texture_id = "arrow",
			content_check_function = function(arg_6_0)
				return arg_6_0.expandable and not arg_6_0.button_hotspot.is_hover and not arg_6_0.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			texture_id = "arrow_hover",
			content_check_function = function(arg_7_0)
				return arg_7_0.expandable and (arg_7_0.expanded or arg_7_0.button_hotspot.is_hover)
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "progress_frame",
			texture_id = "progress_frame",
			content_check_function = function(arg_8_0)
				return arg_8_0.draw_bar or arg_8_0.completed and not arg_8_0.claimed
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_bar",
			texture_id = "progress_bar",
			content_check_function = function(arg_9_0)
				return arg_9_0.draw_bar
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_bar_bg",
			texture_id = "rect_masked",
			content_check_function = function(arg_10_0)
				return arg_10_0.draw_bar
			end
		},
		{
			style_id = "progress_text",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function(arg_11_0)
				return arg_11_0.draw_bar
			end
		},
		{
			style_id = "progress_text_shadow",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function(arg_12_0)
				return arg_12_0.draw_bar
			end
		},
		{
			style_id = "progress_button_text_hover",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function(arg_13_0)
				return arg_13_0.completed and not arg_13_0.claimed and not arg_13_0.draw_bar and arg_13_0.progress_button_hotspot.is_hover and not arg_13_0.locked
			end
		},
		{
			style_id = "progress_button_text",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function(arg_14_0)
				return arg_14_0.completed and not arg_14_0.claimed and not arg_14_0.draw_bar and not arg_14_0.progress_button_hotspot.is_hover and not arg_14_0.locked
			end
		},
		{
			style_id = "progress_button_text_shadow",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function(arg_15_0)
				return arg_15_0.completed and not arg_15_0.claimed and not arg_15_0.draw_bar
			end
		},
		{
			style_id = "progress_button_text_disabled",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function(arg_16_0)
				return arg_16_0.completed and not arg_16_0.claimed and not arg_16_0.draw_bar and arg_16_0.locked
			end
		},
		{
			style_id = "progress_button_background",
			pass_type = "texture_uv",
			content_id = "progress_button_background",
			content_check_function = function(arg_17_0)
				local var_17_0 = arg_17_0.parent

				return var_17_0.completed and not var_17_0.claimed
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_button_background_fade",
			texture_id = "background_fade",
			content_check_function = function(arg_18_0)
				return arg_18_0.completed and not arg_18_0.claimed
			end
		},
		{
			style_id = "progress_button_hotspot",
			pass_type = "hotspot",
			content_id = "progress_button_hotspot",
			content_check_function = function(arg_19_0)
				local var_19_0 = arg_19_0.parent

				return var_19_0.completed and not var_19_0.claimed
			end
		},
		{
			texture_id = "glass",
			style_id = "progress_button_glass_top",
			pass_type = "texture",
			content_check_function = function(arg_20_0)
				return arg_20_0.draw_bar or arg_20_0.completed and not arg_20_0.claimed
			end
		},
		{
			texture_id = "glass",
			style_id = "progress_button_glass_bottom",
			pass_type = "texture",
			content_check_function = function(arg_21_0)
				return arg_21_0.draw_bar or arg_21_0.completed and not arg_21_0.claimed
			end
		},
		{
			texture_id = "hover_glow",
			style_id = "progress_button_hover_glow",
			pass_type = "texture",
			content_check_function = function(arg_22_0)
				return arg_22_0.completed and not arg_22_0.claimed and arg_22_0.progress_button_hotspot.is_hover and not arg_22_0.locked
			end
		},
		{
			style_id = "progress_button_claim_glow",
			texture_id = "progress_button_claim_glow",
			pass_type = "texture_frame",
			content_check_function = function(arg_23_0)
				return arg_23_0.completed and not arg_23_0.claimed and not arg_23_0.claiming
			end,
			content_change_function = function(arg_24_0, arg_24_1)
				local var_24_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_24_1.color[1] = 55 + var_24_0 * 200
			end
		},
		{
			style_id = "side_detail_right",
			pass_type = "texture_uv",
			content_id = "side_detail",
			content_check_function = function(arg_25_0)
				local var_25_0 = arg_25_0.parent

				return var_25_0.draw_bar or var_25_0.completed and not var_25_0.claimed
			end
		},
		{
			texture_id = "texture_id",
			style_id = "side_detail_left",
			pass_type = "texture",
			content_id = "side_detail",
			content_check_function = function(arg_26_0)
				local var_26_0 = arg_26_0.parent

				return var_26_0.draw_bar or var_26_0.completed and not var_26_0.claimed
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background",
			content_check_function = function(arg_27_0)
				return not arg_27_0.claimed
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background_completed",
			texture_id = "background_completed",
			content_check_function = function(arg_28_0)
				return arg_28_0.claimed
			end
		},
		{
			pass_type = "texture",
			style_id = "background_fade",
			texture_id = "background_fade"
		},
		{
			pass_type = "texture",
			style_id = "title_divider",
			texture_id = "title_divider"
		},
		{
			pass_type = "texture",
			style_id = "icon_background",
			texture_id = "icon_background"
		},
		{
			texture_id = "texture_id",
			style_id = "icon_swirl",
			pass_type = "texture",
			content_id = "swirl_texture"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon"
		},
		{
			style_id = "dlc_lock_hotspot",
			pass_type = "hotspot",
			content_id = "dlc_lock_hotspot",
			content_check_function = function(arg_29_0)
				local var_29_0 = arg_29_0.draw

				arg_29_0.draw = false
				arg_29_0.is_hover = false

				return var_29_0
			end
		},
		{
			style_id = "dlc_lock",
			texture_id = "dlc_lock",
			pass_type = "rotated_texture",
			content_check_function = function(arg_30_0)
				return arg_30_0.locked
			end,
			content_change_function = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				if arg_31_0.dlc_on_claim == true then
					arg_31_0.dlc_lock_t = 1
					arg_31_0.dlc_lock_dir = -arg_31_0.dlc_lock_dir
					arg_31_0.dlc_on_claim = false
				else
					local var_31_0 = arg_31_0.dlc_lock_t

					if var_31_0 then
						local var_31_1 = math
						local var_31_2 = var_31_0 - arg_31_3

						arg_31_1.angle = 0.1 * var_31_1.pi * var_31_1.min(1, var_31_2 * var_31_2) * var_31_1.sin(3 * var_31_1.pi * var_31_2 * arg_31_0.dlc_lock_dir)
						arg_31_0.dlc_lock_t = var_31_2 > 0 and var_31_2
					end
				end
			end
		},
		{
			style_id = "dlc_lock_glow",
			texture_id = "dlc_lock_glow",
			pass_type = "texture",
			content_check_function = function(arg_32_0)
				return arg_32_0.locked
			end,
			content_change_function = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				local var_33_0 = arg_33_0.dlc_lock_t
				local var_33_1 = arg_33_0.dlc_lock_glow_alpha_multiplier

				if arg_33_0.dlc_lock_hotspot.is_hover then
					var_33_1 = var_33_1 + 3 * arg_33_3
				elseif var_33_0 and var_33_0 > 0 then
					var_33_1 = math.sin(0.5 * math.pi * var_33_0)
				else
					var_33_1 = var_33_1 - 2 * arg_33_3
				end

				local var_33_2 = math.clamp(var_33_1, 0, 1)

				arg_33_1.color[1] = 255 * var_33_2
				arg_33_0.dlc_lock_glow_alpha_multiplier = var_33_2
			end
		},
		{
			style_id = "locked_text",
			pass_type = "tooltip_text",
			text_id = "locked_text",
			content_check_function = function(arg_34_0)
				return arg_34_0.locked and arg_34_0.dlc_lock_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "reward_background",
			texture_id = "reward_background"
		},
		{
			style_id = "reward_swirl",
			pass_type = "texture_uv",
			content_id = "swirl_texture"
		},
		{
			pass_type = "texture",
			style_id = "reward_icon",
			texture_id = "reward_icon"
		},
		{
			pass_type = "texture",
			style_id = "reward_icon_background",
			texture_id = "reward_icon_background",
			content_check_function = function(arg_35_0)
				return arg_35_0.reward_icon_background ~= nil
			end
		},
		{
			pass_type = "texture",
			style_id = "reward_hover",
			texture_id = "reward_hover",
			content_check_function = function(arg_36_0)
				local var_36_0 = arg_36_0.reward_button_hotspot

				return var_36_0.is_hover and var_36_0.draw
			end
		},
		{
			item_id = "reward_item",
			pass_type = "item_tooltip",
			style_id = "reward_icon",
			content_check_function = function(arg_37_0)
				local var_37_0 = arg_37_0.reward_button_hotspot

				return var_37_0.is_hover and var_37_0.draw
			end,
			content_change_function = function(arg_38_0)
				arg_38_0.reward_button_hotspot.draw = false
			end
		},
		{
			pass_type = "texture",
			style_id = "reward_frame",
			texture_id = "reward_frame"
		},
		{
			pass_type = "texture",
			style_id = "reward_illusion_frame",
			texture_id = "reward_illusion_frame",
			content_check_function = function(arg_39_0)
				return arg_39_0.is_illusion
			end
		},
		{
			style_id = "reward_icon",
			pass_type = "hotspot",
			content_id = "reward_button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "reward_icon_claimed",
			texture_id = "reward_icon_claimed",
			content_check_function = function(arg_40_0)
				return arg_40_0.claimed
			end
		},
		{
			style_id = "claimed_text",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function(arg_41_0)
				return arg_41_0.claimed
			end
		},
		{
			style_id = "claimed_text_shadow",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function(arg_42_0)
				return arg_42_0.claimed
			end
		},
		{
			style_id = "title",
			pass_type = "text",
			text_id = "title"
		},
		{
			style_id = "title_shadow",
			pass_type = "text",
			text_id = "title"
		},
		{
			style_id = "description",
			pass_type = "text",
			text_id = "description"
		},
		{
			style_id = "description_shadow",
			pass_type = "text",
			text_id = "description"
		},
		{
			style_id = "checklist_1",
			pass_type = "list_pass",
			content_id = "checklist_1",
			content_check_function = function(arg_43_0)
				return arg_43_0.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_44_0)
						return not arg_44_0.button_hotspot.is_hover
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "texture",
					style_id = "checkbox",
					texture_id = "checkbox"
				},
				{
					pass_type = "texture",
					style_id = "checkbox_marker",
					texture_id = "checkbox_marker"
				}
			}
		},
		{
			style_id = "checklist_2",
			pass_type = "list_pass",
			content_id = "checklist_2",
			content_check_function = function(arg_45_0)
				return arg_45_0.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_46_0)
						return not arg_46_0.button_hotspot.is_hover
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "texture",
					style_id = "checkbox",
					texture_id = "checkbox"
				},
				{
					pass_type = "texture",
					style_id = "checkbox_marker",
					texture_id = "checkbox_marker"
				}
			}
		}
	}
	local var_1_21 = {
		icon_background = "achievement_left",
		expand_background_edge = "achievement_paper_bottom",
		reward_icon = "icons_placeholder",
		progress_text = "n/a",
		glass = "button_glass_02",
		dlc_lock = "hero_icon_locked_gold",
		draw_bar = true,
		reward_illusion_frame = "item_frame_illusion",
		icon = "achievement_trophy_01",
		arrow = "achievement_arrow",
		progress_bar = "experience_bar_fill",
		dlc_lock_glow_alpha_multiplier = 0,
		locked_text = "n/a",
		is_illusion = false,
		expand_background = "achievement_paper_middle",
		reward_icon_claimed = "achievement_banner",
		background_completed = "achievement_background",
		background = "achievement_background_dark",
		title_divider = "divider_01_bottom",
		arrow_hover = "achievement_arrow_hover",
		background_fade = "options_window_fade_01",
		dlc_lock_glow = "circular_gradient_masked",
		expand_background_shadow = "edge_fade_small",
		hover_glow = "button_state_default",
		completed = false,
		title = "n/a",
		claimed = false,
		expanded = false,
		description = "n/a",
		expandable = false,
		reward_frame = "item_frame",
		rect_masked = "rect_masked",
		claiming = false,
		reward_background = "achievement_right",
		dlc_on_claim = false,
		reward_hover = "item_icon_hover",
		dlc_lock_dir = math.random() < 0.5 and 1 or -1,
		dlc_lock_hotspot = {},
		button_hotspot = {
			allow_multi_hover = true
		},
		progress_button_hotspot = {},
		reward_button_hotspot = {},
		claimed_text = Localize("achv_menu_reward_claimed"),
		progress_button_text = Localize("loot_screen_claim_reward"),
		swirl_texture = {
			texture_id = "achievement_swirl",
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
		side_detail = {
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			},
			texture_id = var_1_8
		},
		frame = var_1_0.texture,
		progress_frame = var_1_1.texture,
		progress_button_claim_glow = var_1_2.texture,
		progress_button_background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(var_1_11[1] / var_1_7.size[1], 1),
					math.min(var_1_11[2] / var_1_7.size[2], 1)
				}
			},
			texture_id = var_1_6
		},
		checklist_1 = table.clone(var_1_16),
		checklist_2 = table.clone(var_1_16)
	}
	local var_1_22 = {
		button_hotspot = {
			size = {
				arg_1_1[1] + 100,
				arg_1_1[2]
			},
			offset = {
				-50,
				0,
				0
			}
		},
		checklist_1 = {
			vertical_alignment = "center",
			num_draws = 0,
			start_index = 1,
			horizontal_alignment = "center",
			list_member_offset = {
				0,
				0,
				0
			},
			size = var_1_13,
			offset = {
				100,
				-arg_1_1[2] / 2,
				1
			},
			item_styles = table.clone(var_1_17)
		},
		checklist_2 = {
			vertical_alignment = "center",
			num_draws = 0,
			start_index = 1,
			horizontal_alignment = "center",
			list_member_offset = {
				0,
				0,
				0
			},
			size = var_1_13,
			offset = {
				500,
				-arg_1_1[2] / 2,
				1
			},
			item_styles = table.clone(var_1_17)
		},
		expand_background = {
			vertical_alignment = "top",
			masked = true,
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_15,
				-1
			},
			texture_size = var_1_13,
			texture_tiling_size = {
				800,
				100
			}
		},
		expand_background_edge = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				-1
			},
			texture_size = {
				800,
				100
			}
		},
		expand_background_shadow = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			angle = math.pi,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-14,
				0
			},
			texture_size = {
				800,
				20
			},
			pivot = {
				400,
				10
			}
		},
		arrow = {
			vertical_alignment = "bottom",
			angle = 0,
			masked = true,
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-22,
				1
			},
			texture_size = {
				59,
				31
			},
			pivot = {
				29.5,
				15.5
			}
		},
		progress_frame = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			masked = true,
			area_size = var_1_11,
			texture_size = var_1_1.texture_size,
			texture_sizes = var_1_1.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_12,
				10
			}
		},
		progress_bar = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "left",
			default_size = var_1_11,
			texture_size = var_1_11,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2,
				var_1_12,
				6
			}
		},
		progress_bar_bg = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			default_size = var_1_11,
			texture_size = var_1_11,
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2,
				var_1_12,
				5
			}
		},
		progress_button_background = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				var_1_11[1],
				var_1_11[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_12,
				6
			}
		},
		progress_button_background_fade = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				var_1_11[1] - 10,
				var_1_11[2] - 10
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_12 + 5,
				7
			}
		},
		progress_button_glass_top = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				var_1_11[1] - 10,
				11
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_12 + var_1_11[2] - 17,
				8
			}
		},
		progress_button_glass_bottom = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				var_1_11[1] - 10,
				11
			},
			color = {
				100,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_12 - 3,
				8
			}
		},
		progress_button_hover_glow = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				var_1_11[1] - 10,
				var_1_11[2] - 10
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_12 + 5,
				9
			}
		},
		progress_button_hotspot = {
			size = var_1_11,
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2,
				var_1_12,
				1
			}
		},
		progress_button_claim_glow = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			masked = true,
			area_size = var_1_11,
			texture_size = var_1_2.texture_size,
			texture_sizes = var_1_2.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			frame_margins = {
				-(var_1_3 - 1),
				-(var_1_3 - 1)
			},
			offset = {
				0,
				var_1_12,
				14
			}
		},
		side_detail_left = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-(var_1_11[1] / 2 - var_1_9[1] / 2) - 9,
				var_1_12 + var_1_11[2] / 2 - var_1_9[2] / 2,
				15
			},
			texture_size = var_1_9
		},
		side_detail_right = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_1_11[1] / 2 - var_1_9[1] / 2 + 9,
				var_1_12 + var_1_11[2] / 2 - var_1_9[2] / 2,
				15
			},
			texture_size = var_1_9
		},
		hover_glow = {
			masked = true,
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
		frame = {
			masked = true,
			texture_size = var_1_0.texture_size,
			texture_sizes = var_1_0.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				8
			}
		},
		background = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "center",
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
			},
			texture_size = arg_1_1,
			texture_tiling_size = {
				128,
				153
			}
		},
		background_completed = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "center",
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
			},
			texture_size = arg_1_1,
			texture_tiling_size = {
				50,
				156
			}
		},
		background_fade = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "center",
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
			},
			texture_size = arg_1_1
		},
		title_divider = {
			vertical_alignment = "top",
			masked = true,
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-24,
				10
			},
			texture_size = {
				264,
				21
			}
		},
		icon_background = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "left",
			texture_size = {
				172,
				181
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-50,
				0,
				10
			}
		},
		icon_swirl = {
			vertical_alignment = "top",
			masked = true,
			horizontal_alignment = "left",
			texture_size = {
				111,
				45
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				114,
				-4,
				10
			}
		},
		icon = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "left",
			texture_size = {
				130,
				131
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-23,
				-2,
				11
			}
		},
		dlc_lock_hotspot = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			size = {
				130,
				50
			},
			offset = {
				arg_1_1[1] - 130 + 25,
				-10,
				11
			}
		},
		dlc_lock = {
			vertical_alignment = "center",
			masked = true,
			angle = 0,
			horizontal_alignment = "right",
			texture_size = {
				45.6,
				52.199999999999996
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-17,
				-55,
				20
			},
			pivot = {
				22.8,
				31.199999999999996
			}
		},
		dlc_lock_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			texture_size = {
				76.8,
				76.8
			},
			color = {
				255,
				242,
				193,
				50
			},
			offset = {
				-2,
				-56,
				11
			}
		},
		locked_text = {
			font_size = 18,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			cursor_side = "left",
			vertical_alignment = "top",
			max_width = 500,
			text_color = Colors.get_table("white"),
			line_colors = {
				Colors.get_table("orange_red")
			},
			offset = {
				-200,
				0,
				50
			},
			cursor_offset = {
				-20,
				-27
			}
		},
		reward_background = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "right",
			texture_size = {
				172,
				181
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				50,
				0,
				10
			}
		},
		reward_swirl = {
			vertical_alignment = "top",
			masked = true,
			horizontal_alignment = "right",
			texture_size = {
				111,
				45
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-114,
				-4,
				10
			}
		},
		reward_icon = {
			saturated = false,
			masked = true,
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
				arg_1_1[1] - 80 - 2,
				arg_1_1[2] / 2 - 40,
				12
			}
		},
		reward_icon_background = {
			saturated = false,
			masked = true,
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
				arg_1_1[1] - 80 - 2,
				arg_1_1[2] / 2 - 40,
				11
			}
		},
		reward_illusion_frame = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "right",
			texture_size = {
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
				-2,
				0,
				14
			}
		},
		reward_frame = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "right",
			texture_size = {
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
				-2,
				0,
				15
			}
		},
		reward_hover = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "right",
			texture_size = {
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
				23,
				0,
				15
			}
		},
		reward_icon_claimed = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				438,
				54
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				-13,
				9
			}
		},
		progress_text = {
			vertical_alignment = "center",
			upper_case = false,
			font_size = 18,
			horizontal_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				var_1_11[1],
				var_1_11[2]
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2,
				var_1_12,
				10
			}
		},
		progress_text_shadow = {
			vertical_alignment = "center",
			upper_case = false,
			font_size = 18,
			horizontal_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				var_1_11[1],
				var_1_11[2]
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2 + 2,
				var_1_12 - 2,
				9
			}
		},
		claimed_text = {
			vertical_alignment = "bottom",
			upper_case = true,
			font_size = 18,
			horizontal_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				var_1_11[1],
				var_1_11[2]
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2,
				4,
				12
			}
		},
		claimed_text_shadow = {
			vertical_alignment = "bottom",
			upper_case = true,
			font_size = 18,
			horizontal_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				var_1_11[1],
				var_1_11[2]
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2 + 2,
				2,
				11
			}
		},
		progress_button_text = {
			vertical_alignment = "center",
			upper_case = false,
			font_size = 18,
			horizontal_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			size = {
				var_1_11[1],
				var_1_11[2]
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2,
				var_1_12,
				10
			}
		},
		progress_button_text_hover = {
			vertical_alignment = "center",
			upper_case = false,
			font_size = 18,
			horizontal_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				var_1_11[1],
				var_1_11[2]
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2,
				var_1_12,
				10
			}
		},
		progress_button_text_shadow = {
			vertical_alignment = "center",
			upper_case = false,
			font_size = 18,
			horizontal_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				var_1_11[1],
				var_1_11[2]
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2 + 2,
				var_1_12 - 2,
				9
			}
		},
		progress_button_text_disabled = {
			vertical_alignment = "center",
			upper_case = false,
			font_size = 18,
			horizontal_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				155,
				155,
				155
			},
			size = {
				var_1_11[1],
				var_1_11[2]
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2,
				var_1_12,
				10
			}
		},
		description = {
			word_wrap = true,
			upper_case = false,
			font_size = 18,
			font_height_multiplier = 0.9,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				arg_1_1[1] - 300,
				arg_1_1[2]
			},
			offset = {
				150,
				5,
				12
			}
		},
		description_shadow = {
			word_wrap = true,
			upper_case = false,
			font_size = 18,
			font_height_multiplier = 0.9,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				arg_1_1[1] - 300,
				arg_1_1[2]
			},
			offset = {
				152,
				3,
				11
			}
		},
		title = {
			font_size = 28,
			upper_case = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = var_1_10 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				arg_1_1[1] / 2 - 200,
				-7,
				9
			},
			size = {
				400,
				arg_1_1[2]
			}
		},
		title_shadow = {
			font_size = 28,
			upper_case = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = var_1_10 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				arg_1_1[1] / 2 - 200 + 2,
				-9,
				8
			},
			size = {
				400,
				arg_1_1[2]
			}
		}
	}

	var_1_19.element.passes = var_1_20
	var_1_19.content = var_1_21
	var_1_19.style = var_1_22
	var_1_19.offset = {
		0,
		0,
		0
	}
	var_1_19.scenegraph_id = arg_1_0

	return var_1_19
end
