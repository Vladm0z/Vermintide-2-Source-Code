-- chunkname: @scripts/ui/views/hero_view/states/definitions/quest_widget_definition.lua

return function (arg_1_0, arg_1_1)
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

	for iter_1_0 = 1, 10 do
		var_1_16[iter_1_0] = {
			text = "n/a",
			checkbox_marker = "matchmaking_checkbox",
			checkbox = "achievement_checkbox",
			button_hotspot = {
				allow_multi_hover = true
			}
		}
		var_1_17[iter_1_0] = {
			list_member_offset = {
				0,
				-var_1_14[2],
				0
			},
			size = var_1_14,
			text = {
				vertical_alignment = "center",
				upper_case = false,
				font_size = 22,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					31,
					0,
					2
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

	local var_1_18 = {
		element = {}
	}
	local var_1_19 = {
		{
			style_id = "button_hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			texture_id = "hover_glow",
			style_id = "hover_glow",
			pass_type = "texture",
			content_check_function = function (arg_2_0)
				return arg_2_0.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "close_background",
			texture_id = "close_background",
			content_check_function = function (arg_3_0)
				return arg_3_0.can_close
			end
		},
		{
			pass_type = "texture",
			style_id = "close_icon_bg",
			texture_id = "close_icon_bg",
			content_check_function = function (arg_4_0)
				return arg_4_0.can_close
			end
		},
		{
			pass_type = "texture",
			style_id = "close_icon",
			texture_id = "close_icon",
			content_check_function = function (arg_5_0)
				return arg_5_0.can_close and not arg_5_0.close_button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "close_icon_hover",
			texture_id = "close_icon_hover",
			content_check_function = function (arg_6_0)
				return arg_6_0.can_close and arg_6_0.close_button_hotspot.is_hover
			end
		},
		{
			style_id = "close_icon",
			pass_type = "hotspot",
			content_id = "close_button_hotspot",
			content_check_function = function (arg_7_0)
				return arg_7_0.parent.can_close
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "expand_background",
			texture_id = "expand_background",
			content_check_function = function (arg_8_0)
				return arg_8_0.expanded
			end
		},
		{
			pass_type = "texture",
			style_id = "expand_background_edge",
			texture_id = "expand_background_edge",
			content_check_function = function (arg_9_0)
				return arg_9_0.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "expand_background_shadow",
			texture_id = "expand_background_shadow",
			content_check_function = function (arg_10_0)
				return arg_10_0.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			texture_id = "arrow",
			content_check_function = function (arg_11_0)
				return arg_11_0.expandable and not arg_11_0.button_hotspot.is_hover and not arg_11_0.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			texture_id = "arrow_hover",
			content_check_function = function (arg_12_0)
				return arg_12_0.expandable and (arg_12_0.expanded or arg_12_0.button_hotspot.is_hover)
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "progress_frame",
			texture_id = "progress_frame",
			content_check_function = function (arg_13_0)
				return arg_13_0.draw_bar or arg_13_0.completed and not arg_13_0.claimed
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_bar",
			texture_id = "progress_bar",
			content_check_function = function (arg_14_0)
				return arg_14_0.draw_bar
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_bar_bg",
			texture_id = "rect_masked",
			content_check_function = function (arg_15_0)
				return arg_15_0.draw_bar
			end
		},
		{
			style_id = "progress_text",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function (arg_16_0)
				return arg_16_0.draw_bar
			end
		},
		{
			style_id = "progress_text_shadow",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function (arg_17_0)
				return arg_17_0.draw_bar
			end
		},
		{
			style_id = "progress_button_text_hover",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (arg_18_0)
				return arg_18_0.completed and not arg_18_0.claimed and not arg_18_0.draw_bar and arg_18_0.progress_button_hotspot.is_hover
			end
		},
		{
			style_id = "progress_button_text",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (arg_19_0)
				return arg_19_0.completed and not arg_19_0.claimed and not arg_19_0.draw_bar and not arg_19_0.progress_button_hotspot.is_hover
			end
		},
		{
			style_id = "progress_button_text_shadow",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (arg_20_0)
				return arg_20_0.completed and not arg_20_0.claimed and not arg_20_0.draw_bar
			end
		},
		{
			style_id = "progress_button_background",
			pass_type = "texture_uv",
			content_id = "progress_button_background",
			content_check_function = function (arg_21_0)
				local var_21_0 = arg_21_0.parent

				return var_21_0.completed and not var_21_0.claimed
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_button_background_fade",
			texture_id = "background_fade",
			content_check_function = function (arg_22_0)
				return arg_22_0.completed and not arg_22_0.claimed
			end
		},
		{
			style_id = "progress_button_hotspot",
			pass_type = "hotspot",
			content_id = "progress_button_hotspot",
			content_check_function = function (arg_23_0)
				local var_23_0 = arg_23_0.parent

				return var_23_0.completed and not var_23_0.claimed
			end
		},
		{
			texture_id = "glass",
			style_id = "progress_button_glass_top",
			pass_type = "texture",
			content_check_function = function (arg_24_0)
				return arg_24_0.draw_bar or arg_24_0.completed and not arg_24_0.claimed
			end
		},
		{
			texture_id = "glass",
			style_id = "progress_button_glass_bottom",
			pass_type = "texture",
			content_check_function = function (arg_25_0)
				return arg_25_0.draw_bar or arg_25_0.completed and not arg_25_0.claimed
			end
		},
		{
			texture_id = "hover_glow",
			style_id = "progress_button_hover_glow",
			pass_type = "texture",
			content_check_function = function (arg_26_0)
				return arg_26_0.completed and not arg_26_0.claimed and arg_26_0.progress_button_hotspot.is_hover
			end
		},
		{
			style_id = "progress_button_claim_glow",
			texture_id = "progress_button_claim_glow",
			pass_type = "texture_frame",
			content_check_function = function (arg_27_0)
				return arg_27_0.completed and not arg_27_0.claimed and not arg_27_0.claiming
			end,
			content_change_function = function (arg_28_0, arg_28_1)
				local var_28_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_28_1.color[1] = 55 + var_28_0 * 200
			end
		},
		{
			style_id = "side_detail_right",
			pass_type = "texture_uv",
			content_id = "side_detail",
			content_check_function = function (arg_29_0)
				local var_29_0 = arg_29_0.parent

				return var_29_0.draw_bar or var_29_0.completed and not var_29_0.claimed
			end
		},
		{
			texture_id = "texture_id",
			style_id = "side_detail_left",
			pass_type = "texture",
			content_id = "side_detail",
			content_check_function = function (arg_30_0)
				local var_30_0 = arg_30_0.parent

				return var_30_0.draw_bar or var_30_0.completed and not var_30_0.claimed
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background"
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
			style_id = "icon_background_ribbon",
			texture_id = "icon_background_ribbon"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon"
		},
		{
			pass_type = "texture",
			style_id = "reward_background",
			texture_id = "reward_background"
		},
		{
			pass_type = "texture",
			style_id = "reward_icon",
			texture_id = "reward_icon"
		},
		{
			pass_type = "texture",
			style_id = "reward_hover",
			texture_id = "reward_hover",
			content_check_function = function (arg_31_0)
				local var_31_0 = arg_31_0.reward_button_hotspot

				return var_31_0.is_hover and var_31_0.draw
			end
		},
		{
			item_id = "reward_item",
			pass_type = "item_tooltip",
			style_id = "reward_icon",
			content_check_function = function (arg_32_0)
				local var_32_0 = arg_32_0.reward_button_hotspot

				return var_32_0.is_hover and var_32_0.draw
			end,
			content_change_function = function (arg_33_0)
				arg_33_0.reward_button_hotspot.draw = false
			end
		},
		{
			pass_type = "texture",
			style_id = "reward_frame",
			texture_id = "reward_frame"
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
			content_check_function = function (arg_34_0)
				return arg_34_0.claimed
			end
		},
		{
			style_id = "claimed_text",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function (arg_35_0)
				return arg_35_0.completed and arg_35_0.claimed
			end
		},
		{
			style_id = "claimed_text_shadow",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function (arg_36_0)
				return arg_36_0.completed and arg_36_0.claimed
			end
		},
		{
			style_id = "locked_text",
			pass_type = "text",
			text_id = "locked_text",
			content_check_function = function (arg_37_0)
				return arg_37_0.locked
			end
		},
		{
			style_id = "locked_text_shadow",
			pass_type = "text",
			text_id = "locked_text",
			content_check_function = function (arg_38_0)
				return arg_38_0.locked
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
			content_check_function = function (arg_39_0)
				return arg_39_0.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_40_0)
						return not arg_40_0.button_hotspot.is_hover
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
			content_check_function = function (arg_41_0)
				return arg_41_0.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_42_0)
						return not arg_42_0.button_hotspot.is_hover
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
	local var_1_20 = {
		reward_hover = "item_icon_hover",
		close_background = "quest_close",
		reward_icon = "icons_placeholder",
		expand_background_edge = "achievement_paper_bottom",
		progress_text = "n/a",
		glass = "button_glass_02",
		draw_bar = true,
		progress_bar = "chest_upgrade_fill",
		icon = "quest_book_skull",
		arrow = "achievement_arrow",
		expand_background = "achievement_paper_middle",
		close_icon_bg = "achievement_refresh_off",
		completed = false,
		title_divider = "divider_01_bottom",
		reward_icon_claimed = "achievement_banner",
		background_fade = "options_window_fade_01",
		background = "quests_background",
		icon_background = "quest_book_skull",
		arrow_hover = "achievement_arrow_hover",
		expand_background_shadow = "edge_fade_small",
		hover_glow = "button_state_default",
		icon_background_ribbon = "quest_book_ribbon",
		title = "n/a",
		claimed = false,
		expanded = false,
		description = "n/a",
		expandable = false,
		close_icon = "achievement_refresh_white",
		reward_frame = "item_frame",
		rect_masked = "rect_masked",
		can_close = false,
		claiming = false,
		reward_background = "quest_right",
		locked_text = "n/a",
		close_icon_hover = "achievement_refresh_on",
		button_hotspot = {
			allow_multi_hover = true
		},
		progress_button_hotspot = {},
		reward_button_hotspot = {},
		claimed_text = Localize("achv_menu_reward_claimed"),
		progress_button_text = Localize("loot_screen_claim_reward"),
		close_button_hotspot = {},
		frame = var_1_0.texture,
		progress_frame = var_1_1.texture,
		progress_button_claim_glow = var_1_2.texture,
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
	local var_1_21 = {
		close_icon = {
			masked = true,
			size = {
				25,
				25
			},
			offset = {
				arg_1_1[1] + 50 - 31,
				arg_1_1[2] - 25,
				13
			},
			color = {
				255,
				200,
				200,
				200
			}
		},
		close_icon_hover = {
			masked = true,
			size = {
				25,
				25
			},
			offset = {
				arg_1_1[1] + 50 - 31,
				arg_1_1[2] - 25,
				12
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		close_icon_bg = {
			masked = true,
			size = {
				25,
				25
			},
			offset = {
				arg_1_1[1] + 50 - 31,
				arg_1_1[2] - 25,
				12
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		},
		close_background = {
			vertical_alignment = "top",
			masked = true,
			horizontal_alignment = "right",
			texture_size = {
				42,
				48
			},
			offset = {
				50,
				10,
				11
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
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
				165,
				163
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
		icon_background_ribbon = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "left",
			texture_size = {
				154,
				169
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				110,
				11,
				9
			}
		},
		icon = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "left",
			texture_size = {
				165,
				163
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
				11
			}
		},
		reward_background = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "right",
			texture_size = {
				314,
				178
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				50,
				8,
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
				arg_1_1[1] - 80 - 3,
				arg_1_1[2] / 2 - 40 + 3,
				11
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
				-3,
				3,
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
				21,
				3,
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
				8
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
				10
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
				9
			}
		},
		locked_text = {
			vertical_alignment = "bottom",
			upper_case = true,
			font_size = 18,
			horizontal_alignment = "center",
			font_type = var_1_10 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("red", 255),
			size = {
				var_1_11[1],
				var_1_11[2]
			},
			offset = {
				arg_1_1[1] / 2 - var_1_11[1] / 2,
				10,
				10
			}
		},
		locked_text_shadow = {
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
				8,
				9
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
		description = {
			word_wrap = true,
			upper_case = false,
			font_size = 18,
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
				9
			}
		},
		description_shadow = {
			word_wrap = true,
			upper_case = false,
			font_size = 18,
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
				8
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

	var_1_18.element.passes = var_1_19
	var_1_18.content = var_1_20
	var_1_18.style = var_1_21
	var_1_18.offset = {
		0,
		0,
		0
	}
	var_1_18.scenegraph_id = arg_1_0

	return var_1_18
end
