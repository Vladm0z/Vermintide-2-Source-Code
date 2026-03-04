-- chunkname: @scripts/ui/views/deus_menu/ui_widgets_deus.lua

UIWidgets = UIWidgets or {}

local var_0_0 = {
	92,
	8
}
local var_0_1 = {
	-(var_0_0[1] / 2),
	-25,
	0
}
local var_0_2 = {
	-15,
	-70
}

local function var_0_3(arg_1_0)
	if not arg_1_0 then
		return 255
	end

	return 195 + 60 * math.sin(5 * Managers.time:time("ui"))
end

UIWidgets.create_deus_player_status_portrait = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "character_portrait",
					texture_id = "character_portrait",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "host_icon",
					texture_id = "host_icon",
					retained_mode = arg_2_3,
					content_check_function = function (arg_3_0)
						return arg_3_0.is_host
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_bg",
					texture_id = "hp_bar_bg",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_fg",
					texture_id = "hp_bar_fg",
					retained_mode = arg_2_3
				},
				{
					style_id = "hp_bar",
					texture_id = "texture_id",
					pass_type = "gradient_mask_texture",
					content_id = "hp_bar",
					content_change_function = function (arg_4_0, arg_4_1)
						local var_4_0 = arg_4_0.bar_value

						arg_4_1.size[1] = var_0_0[1] * var_4_0
					end,
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					retained_mode = arg_2_3,
					content_check_function = function (arg_5_0)
						return arg_5_0.display_portrait_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator",
					texture_id = "talk_indicator",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_glow",
					texture_id = "talk_indicator_glow",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight",
					texture_id = "talk_indicator_highlight",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight_glow",
					texture_id = "talk_indicator_highlight_glow",
					retained_mode = arg_2_3
				},
				{
					pass_type = "rotated_texture",
					style_id = "connecting_icon",
					texture_id = "connecting_icon",
					retained_mode = arg_2_3,
					content_check_function = function (arg_6_0)
						return arg_6_0.connecting
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "ammo_indicator",
					retained_mode = arg_2_3,
					content_check_function = function (arg_7_0)
						local var_7_0 = arg_7_0.ammo_percentage

						return var_7_0 and var_7_0 > 0 and var_7_0 <= 0.33
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "ammo_indicator_empty",
					retained_mode = arg_2_3,
					content_check_function = function (arg_8_0)
						local var_8_0 = arg_8_0.ammo_percentage

						return var_8_0 and var_8_0 <= 0
					end
				},
				{
					pass_type = "texture",
					style_id = "healthkit_slot",
					texture_id = "healthkit_slot",
					retained_mode = arg_2_3,
					content_check_function = function (arg_9_0)
						return arg_9_0.healthkit_slot
					end
				},
				{
					pass_type = "texture",
					style_id = "healthkit_slot_bg",
					texture_id = "healthkit_slot_bg",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "healthkit_slot_frame",
					texture_id = "slot_frame",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "potion_slot",
					texture_id = "potion_slot",
					retained_mode = arg_2_3,
					content_check_function = function (arg_10_0)
						return arg_10_0.potion_slot
					end
				},
				{
					pass_type = "texture",
					style_id = "potion_slot_bg",
					texture_id = "potion_slot_bg",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "potion_slot_frame",
					texture_id = "slot_frame",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "grenade_slot",
					texture_id = "grenade_slot",
					retained_mode = arg_2_3,
					content_check_function = function (arg_11_0)
						return arg_11_0.grenade_slot
					end
				},
				{
					pass_type = "texture",
					style_id = "grenade_slot_bg",
					texture_id = "grenade_slot_bg",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "grenade_slot_frame",
					texture_id = "slot_frame",
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "token_icon",
					texture_id = "token_icon",
					retained_mode = arg_2_3,
					content_check_function = function (arg_12_0)
						return arg_12_0.token_icon and arg_12_0.show_token_icon
					end
				}
			}
		},
		content = {
			talk_indicator_highlight = "voip_wave",
			character_portrait = "unit_frame_portrait_default",
			display_portrait_icon = false,
			ammo_percentage = 1,
			is_host = false,
			portrait_icon = "status_icon_needs_assist",
			host_icon = "host_icon",
			hp_bar_bg = "hud_teammate_hp_bar_bg",
			ammo_indicator_empty = "unit_frame_ammo_empty",
			connecting_icon = "matchmaking_connecting_icon",
			talk_indicator_highlight_glow = "voip_wave_glow",
			hp_bar_fg = "hud_teammate_hp_bar_frame_dark_pact",
			talk_indicator_glow = "voip_speaker_glow",
			grenade_slot_bg = "hud_inventory_slot_bg_small_01",
			connecting = false,
			healthkit_slot_bg = "hud_inventory_slot_bg_small_01",
			bar_start_side = "left",
			slot_frame = "hud_inventory_slot_small",
			display_portrait_overlay = false,
			potion_slot_bg = "hud_inventory_slot_bg_small_01",
			talk_indicator = "voip_speaker",
			ammo_indicator = "unit_frame_ammo_low",
			hp_bar = {
				texture_id = "teammate_hp_bar_color_tint_1",
				bar_value = 1
			},
			ammo_bar = {
				bar_value = 1,
				texture_id = "hud_teammate_ammo_bar_fill",
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
			character_portrait = {
				size = {
					86,
					108
				},
				offset = {
					-43,
					6,
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
					-65,
					-2,
					50
				},
				color = {
					150,
					255,
					255,
					255
				}
			},
			hp_bar_bg = {
				size = {
					100,
					17
				},
				offset = {
					var_0_1[1] + var_0_0[1] / 2 - 50,
					var_0_1[2] + var_0_0[2] / 2 - 6.5,
					var_0_1[3] + 15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar_fg = {
				size = {
					100,
					24
				},
				offset = {
					var_0_1[1] + var_0_0[1] / 2 - 50,
					var_0_1[2] + var_0_0[2] / 2 - 6.5 - 7,
					var_0_1[3] + 20
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar = {
				gradient_threshold = 1,
				size = {
					var_0_0[1],
					var_0_0[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_1[1],
					var_0_1[2],
					var_0_1[3] + 18
				}
			},
			ammo_indicator = {
				size = {
					32,
					32
				},
				offset = {
					60,
					-40,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			talk_indicator = {
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
					3
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			talk_indicator_glow = {
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
					2
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			talk_indicator_highlight = {
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
					3
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			talk_indicator_highlight_glow = {
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
					2
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			connecting_icon = {
				angle = 0,
				size = {
					53,
					53
				},
				offset = {
					-25,
					34,
					15
				},
				color = {
					255,
					255,
					255,
					255
				},
				pivot = {
					27,
					27
				}
			},
			portrait_icon = {
				size = {
					86,
					108
				},
				offset = {
					-43,
					0,
					1
				},
				color = {
					150,
					255,
					255,
					255
				}
			},
			healthkit_slot_bg = {
				size = {
					29,
					29
				},
				offset = {
					var_0_2[1] + -35,
					var_0_2[2] + 0,
					7
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			healthkit_slot_frame = {
				size = {
					29,
					29
				},
				offset = {
					var_0_2[1] + -35,
					var_0_2[2] + 0,
					11
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			healthkit_slot = {
				size = {
					25,
					25
				},
				offset = {
					var_0_2[1] + -35 + 2.5,
					var_0_2[2] + 2,
					8
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			potion_slot_bg = {
				size = {
					29,
					29
				},
				offset = {
					var_0_2[1] + 0,
					var_0_2[2] + 0,
					7
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			potion_slot_frame = {
				size = {
					29,
					29
				},
				offset = {
					var_0_2[1] + 0,
					var_0_2[2] + 0,
					11
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			potion_slot = {
				size = {
					25,
					25
				},
				offset = {
					var_0_2[1] + 2.5,
					var_0_2[2] + 2,
					8
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			grenade_slot_bg = {
				size = {
					29,
					29
				},
				offset = {
					var_0_2[1] + 35,
					var_0_2[2] + 0,
					7
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			grenade_slot_frame = {
				size = {
					29,
					29
				},
				offset = {
					var_0_2[1] + 35,
					var_0_2[2] + 0,
					11
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			grenade_slot = {
				size = {
					25,
					25
				},
				offset = {
					var_0_2[1] + 35 + 2.5,
					var_0_2[2] + 2,
					8
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			token_icon = {
				size = {
					40,
					40
				},
				offset = {
					15,
					83,
					20
				}
			}
		},
		scenegraph_id = arg_2_0
	}
end

UIWidgets.deus_create_player_portraits_frame = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_3
	local var_13_1 = arg_13_0
	local var_13_2 = {
		element = {
			passes = {}
		},
		content = {},
		style = {}
	}
	local var_13_3 = UIPlayerPortraitFrameSettings[arg_13_1]
	local var_13_4 = {
		255,
		255,
		255,
		255
	}
	local var_13_5 = arg_13_4 or {
		0,
		0,
		0
	}

	var_13_2.content.frame_settings_name = arg_13_1

	for iter_13_0, iter_13_1 in ipairs(var_13_3) do
		local var_13_6 = "texture_" .. iter_13_0
		local var_13_7 = iter_13_1.texture or "icons_placeholder"
		local var_13_8

		if UIAtlasHelper.has_atlas_settings_by_texture_name(var_13_7) then
			var_13_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_13_7).size
		else
			var_13_8 = iter_13_1.size
		end

		local var_13_9

		var_13_9 = var_13_8 and table.clone(var_13_8) or {
			0,
			0
		}

		local var_13_10 = {}

		if iter_13_1.offset then
			var_13_10 = table.clone(iter_13_1.offset)
			var_13_10[1] = var_13_5[1] + (-(var_13_9[1] / 2) + var_13_10[1])
			var_13_10[2] = var_13_5[2] + 60 + var_13_10[2]
			var_13_10[3] = iter_13_1.layer or 0
		else
			var_13_10 = table.clone(var_13_5)
			var_13_10[1] = -(var_13_9[1] / 2) + var_13_10[1]
			var_13_10[2] = var_13_10[2]
			var_13_10[3] = iter_13_1.layer or 0
		end

		var_13_2.element.passes[#var_13_2.element.passes + 1] = {
			pass_type = "texture",
			texture_id = var_13_6,
			style_id = var_13_6,
			retained_mode = var_13_0
		}
		var_13_2.content[var_13_6] = var_13_7
		var_13_2.style[var_13_6] = {
			color = iter_13_1.color or var_13_4,
			offset = var_13_10,
			size = var_13_9
		}
	end

	local var_13_11 = {
		86,
		108
	}

	var_13_11[1] = var_13_11[1]
	var_13_11[2] = var_13_11[2]

	local var_13_12 = {
		0,
		8,
		0
	}

	var_13_12[1] = var_13_12[1]
	var_13_12[2] = var_13_12[2]
	var_13_12[3] = 15

	local var_13_13 = "level"

	var_13_2.element.passes[#var_13_2.element.passes + 1] = {
		pass_type = "text",
		text_id = var_13_13,
		style_id = var_13_13,
		retained_mode = var_13_0
	}
	var_13_2.content[var_13_13] = arg_13_2
	var_13_2.style[var_13_13] = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 12,
		horizontal_alignment = "center",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = var_13_12
	}
	var_13_2.scenegraph_id = var_13_1

	return var_13_2
end

UIWidgets.create_info_box = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	local var_14_0 = {
		0,
		130 - arg_14_2[2] / 2,
		0
	}
	local var_14_1 = UIFrameSettings[arg_14_3]
	local var_14_2 = var_14_1.texture_sizes.horizontal[2]
	local var_14_3 = {
		arg_14_2[1] + var_14_2 * 2,
		arg_14_2[2] + var_14_2 * 2
	}
	local var_14_4 = {
		var_14_0[1] - var_14_2,
		var_14_0[2] - var_14_2,
		1
	}
	local var_14_5 = {
		arg_14_2[1] + var_14_2 + 5,
		var_14_0[2] - var_14_2 - 5
	}
	local var_14_6 = {
		font_size = 36,
		dynamic_font_size = true,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			var_14_5[1],
			125,
			0
		},
		size = {
			400 - var_14_5[1],
			36
		}
	}
	local var_14_7 = table.clone(var_14_6)

	var_14_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_14_7.offset = {
		var_14_6.offset[1] + 2,
		var_14_6.offset[2] - 2,
		var_14_6.offset[3] - 1
	}

	local var_14_8 = {
		font_size = 20,
		dynamic_font_size = true,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_14_5[1],
			var_14_0[2],
			0
		},
		size = {
			400 - var_14_5[1],
			20
		}
	}
	local var_14_9 = table.clone(var_14_8)

	var_14_9.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_14_9.offset = {
		var_14_8.offset[1] + 2,
		var_14_8.offset[2] - 2,
		var_14_8.offset[3] - 1
	}

	local var_14_10 = {
		vertical_alignment = "top",
		word_wrap = true,
		dynamic_font_size_word_wrap = true,
		font_size = 20,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			0,
			0,
			0
		},
		size = {
			400,
			var_14_5[2]
		}
	}
	local var_14_11 = table.clone(var_14_10)

	var_14_11.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_14_11.offset = {
		var_14_10.offset[1] + 2,
		var_14_10.offset[2] - 2,
		var_14_10.offset[3] - 1
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (arg_15_0)
						return arg_15_0.icon
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame",
					content_check_function = function (arg_16_0)
						return arg_16_0.icon
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_17_0)
						return arg_17_0.title_text
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_18_0)
						return arg_18_0.title_text
					end
				},
				{
					style_id = "sub_title_text",
					pass_type = "text",
					text_id = "sub_title_text",
					content_check_function = function (arg_19_0)
						return arg_19_0.sub_title_text
					end
				},
				{
					style_id = "sub_title_text_shadow",
					pass_type = "text",
					text_id = "sub_title_text",
					content_check_function = function (arg_20_0)
						return arg_20_0.sub_title_text
					end
				},
				{
					style_id = "info_text",
					pass_type = "text",
					text_id = "info_text",
					content_check_function = function (arg_21_0)
						return arg_21_0.info_text
					end
				},
				{
					style_id = "info_text_shadow",
					pass_type = "text",
					text_id = "info_text",
					content_check_function = function (arg_22_0)
						return arg_22_0.info_text
					end
				}
			}
		},
		content = {
			icon = arg_14_1,
			frame = var_14_1.texture,
			title_text = arg_14_4,
			sub_title_text = arg_14_5,
			info_text = arg_14_6
		},
		style = {
			icon = {
				offset = var_14_0,
				texture_size = arg_14_2 or {
					20,
					20
				}
			},
			frame = {
				size = var_14_3,
				texture_size = var_14_1.texture_size,
				texture_sizes = var_14_1.texture_sizes,
				offset = var_14_4
			},
			title_text = var_14_6,
			title_text_shadow = var_14_7,
			sub_title_text = var_14_8,
			sub_title_text_shadow = var_14_9,
			info_text = var_14_10,
			info_text_shadow = var_14_11
		},
		scenegraph_id = arg_14_0
	}
end

UIWidgets.create_framed_info_box = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9, arg_23_10)
	arg_23_10 = arg_23_10 or {
		340,
		100
	}

	local var_23_0 = UIFrameSettings[arg_23_2]
	local var_23_1 = var_23_0.texture_sizes.horizontal[2]
	local var_23_2 = {
		arg_23_10[1] + var_23_1 * 2,
		arg_23_10[2] + var_23_1 * 2
	}
	local var_23_3 = {
		-var_23_1,
		-var_23_1,
		1
	}
	local var_23_4 = 12
	local var_23_5 = {
		arg_23_10[1],
		arg_23_6[1] + var_23_4 * 2
	}
	local var_23_6 = {
		0,
		arg_23_10[2] + 2.5 - var_23_3[2],
		-2
	}
	local var_23_7 = UIFrameSettings[arg_23_1]
	local var_23_8 = var_23_7.texture_sizes.horizontal[2]
	local var_23_9 = {
		var_23_5[1] + var_23_8 * 2,
		var_23_5[2] + var_23_8 * 2
	}
	local var_23_10 = {
		-var_23_8,
		var_23_6[2] - var_23_8,
		1
	}
	local var_23_11 = 20
	local var_23_12 = {
		arg_23_10[1] - arg_23_6[1],
		var_23_11
	}
	local var_23_13 = {
		arg_23_10[1] / 2 - var_23_12[1] / 2,
		var_23_6[2] + var_23_5[2] + var_23_8 * 2,
		-2
	}
	local var_23_14 = UIFrameSettings[arg_23_3]
	local var_23_15 = var_23_14 and var_23_14.texture_sizes.horizontal[2] or 0
	local var_23_16 = {
		var_23_12[1] + var_23_15 * 2,
		var_23_12[2] + var_23_15 * 2
	}
	local var_23_17 = {
		var_23_13[1] - var_23_15,
		var_23_13[2] - var_23_15,
		1
	}
	local var_23_18 = {
		var_23_4,
		var_23_6[2] + var_23_4,
		0
	}
	local var_23_19 = UIFrameSettings[arg_23_7]
	local var_23_20 = var_23_19.texture_sizes.horizontal[2]
	local var_23_21 = {
		arg_23_6[1] + var_23_20 * 2,
		arg_23_6[2] + var_23_20 * 2
	}
	local var_23_22 = {
		var_23_18[1] - var_23_20,
		var_23_18[2] - var_23_20,
		1
	}
	local var_23_23 = {
		var_23_2[1],
		var_23_2[2] + var_23_9[2]
	}

	if arg_23_3 then
		var_23_23[2] = var_23_23[2] + var_23_16[2]
	end

	local var_23_24 = {
		upper_case = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = var_23_11,
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_23_13[1],
			var_23_13[2] + var_23_12[2] / 2 - var_23_11 / 2,
			0
		},
		size = var_23_12
	}
	local var_23_25 = table.clone(var_23_24)

	var_23_25.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_23_25.offset = {
		var_23_24.offset[1] + 2,
		var_23_24.offset[2] - 2,
		var_23_24.offset[3] - 1
	}

	local var_23_26 = 5
	local var_23_27 = 36
	local var_23_28 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = var_23_27,
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			arg_23_6[1] + var_23_4 + var_23_20 + var_23_26,
			var_23_6[2] + var_23_5[2] / 2 - var_23_27 / 2,
			0
		},
		size = {
			var_23_5[1] - arg_23_6[1] - var_23_4 * 2 - var_23_26 * 2,
			var_23_27
		}
	}
	local var_23_29 = table.clone(var_23_28)

	var_23_29.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_23_29.offset = {
		var_23_28.offset[1] + 2,
		var_23_28.offset[2] - 2,
		var_23_28.offset[3] - 1
	}

	local var_23_30 = {
		15,
		5
	}
	local var_23_31 = {
		vertical_alignment = "top",
		word_wrap = true,
		dynamic_font_size_word_wrap = true,
		font_size = 20,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_23_30[1],
			var_23_30[2],
			0
		},
		size = {
			arg_23_10[1] - var_23_30[1] * 2,
			arg_23_10[2] - var_23_30[2] * 2
		}
	}
	local var_23_32 = table.clone(var_23_31)

	var_23_32.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_23_32.offset = {
		var_23_31.offset[1] + 2,
		var_23_31.offset[2] - 2,
		var_23_31.offset[3] - 1
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "top_frame",
					texture_id = "top_frame",
					content_check_function = function (arg_24_0)
						return arg_24_0.top_text
					end
				},
				{
					style_id = "top_frame_rect",
					pass_type = "rect",
					content_check_function = function (arg_25_0)
						return arg_25_0.top_text
					end
				},
				{
					style_id = "top_text",
					pass_type = "text",
					text_id = "top_text",
					content_check_function = function (arg_26_0)
						return arg_26_0.top_text
					end
				},
				{
					style_id = "top_text_shadow",
					pass_type = "text",
					text_id = "top_text",
					content_check_function = function (arg_27_0)
						return arg_27_0.top_text
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "title_frame",
					texture_id = "title_frame",
					content_check_function = function (arg_28_0)
						return arg_28_0.icon
					end
				},
				{
					pass_type = "rect",
					style_id = "title_frame_rect"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (arg_29_0)
						return arg_29_0.icon
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "icon_frame",
					texture_id = "icon_frame",
					content_check_function = function (arg_30_0)
						return arg_30_0.icon
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_31_0)
						return arg_31_0.title_text
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_32_0)
						return arg_32_0.title_text
					end
				},
				{
					pass_type = "texture",
					style_id = "title_glow",
					texture_id = "title_glow",
					content_check_function = function (arg_33_0)
						return arg_33_0.title_text
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "bottom_frame",
					texture_id = "bottom_frame",
					content_check_function = function (arg_34_0)
						return arg_34_0.info_text
					end
				},
				{
					style_id = "info_text",
					pass_type = "text",
					text_id = "info_text",
					content_check_function = function (arg_35_0)
						return arg_35_0.info_text
					end
				},
				{
					style_id = "info_text_shadow",
					pass_type = "text",
					text_id = "info_text",
					content_check_function = function (arg_36_0)
						return arg_36_0.info_text
					end
				},
				{
					pass_type = "tiled_texture",
					style_id = "bottom_background",
					texture_id = "bottom_background",
					content_check_function = function (arg_37_0)
						return arg_37_0.info_text
					end
				}
			}
		},
		content = {
			bottom_background = "item_tooltip_background",
			title_glow = "tooltip_power_level_header_glow",
			top_frame = var_23_14 and var_23_14.texture,
			title_frame = var_23_7.texture,
			bottom_frame = var_23_0.texture,
			icon = arg_23_5,
			icon_frame = var_23_19.texture,
			title_text = arg_23_8,
			info_text = arg_23_9,
			top_text = arg_23_4,
			total_widget_size = var_23_23
		},
		style = {
			top_frame = {
				size = var_23_16,
				texture_size = var_23_14 and var_23_14.texture_size,
				texture_sizes = var_23_14 and var_23_14.texture_sizes,
				offset = var_23_17
			},
			top_frame_rect = {
				color = {
					255,
					20,
					20,
					20
				},
				offset = var_23_13,
				size = var_23_12
			},
			top_text = var_23_24,
			top_text_shadow = var_23_25,
			title_frame = {
				size = var_23_9,
				texture_size = var_23_7.texture_size,
				texture_sizes = var_23_7.texture_sizes,
				offset = var_23_10
			},
			title_frame_rect = {
				color = Colors.get_table("black"),
				offset = var_23_6,
				size = var_23_5
			},
			icon = {
				offset = var_23_18,
				texture_size = arg_23_6 or {
					20,
					20
				}
			},
			icon_frame = {
				size = var_23_21,
				texture_size = var_23_19.texture_size,
				texture_sizes = var_23_19.texture_sizes,
				offset = var_23_22
			},
			bottom_frame = {
				size = var_23_2,
				texture_size = var_23_0.texture_size,
				texture_sizes = var_23_0.texture_sizes,
				offset = var_23_3
			},
			title_text = var_23_28,
			title_text_shadow = var_23_29,
			title_glow = {
				offset = {
					var_23_6[1],
					var_23_6[2],
					-1
				},
				size = arg_23_10,
				texture_size = {
					var_23_5[1],
					var_23_5[2] / 2
				}
			},
			info_text = var_23_31,
			info_text_shadow = var_23_32,
			bottom_background = {
				offset = {
					0,
					0,
					-1
				},
				size = arg_23_10,
				texture_tiling_size = arg_23_10
			}
		},
		scenegraph_id = arg_23_0
	}
end

UIWidgets.create_icon_info_box = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7, arg_38_8, arg_38_9, arg_38_10, arg_38_11, arg_38_12, arg_38_13, arg_38_14)
	local var_38_0 = {
		arg_38_10,
		arg_38_5[2]
	}
	local var_38_1 = {
		color = {
			255,
			138,
			172,
			235
		},
		offset = arg_38_3,
		texture_size = arg_38_2,
		masked = arg_38_13
	}
	local var_38_2 = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = arg_38_6,
		texture_size = arg_38_5,
		masked = arg_38_13
	}
	local var_38_3 = var_38_2.texture_size[2]
	local var_38_4 = 10
	local var_38_5 = 20
	local var_38_6 = 2
	local var_38_7 = var_38_5 * 2 + var_38_6
	local var_38_8 = {
		var_38_2.texture_size[1] + var_38_4,
		var_38_3 / 2 - var_38_7 / 2,
		0
	}
	local var_38_9 = {
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = var_38_5,
		font_type = arg_38_13 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_38_8[1],
			var_38_8[2],
			0
		},
		size = {
			var_38_0[1] - var_38_8[1],
			var_38_5
		}
	}
	local var_38_10 = table.clone(var_38_9)

	var_38_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_38_10.offset = {
		var_38_9.offset[1] + 2,
		var_38_9.offset[2] - 2,
		var_38_9.offset[3] - 1
	}

	local var_38_11 = {
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = var_38_5,
		font_type = arg_38_13 and "hell_shark_masked" or "hell_shark",
		text_color = arg_38_9 or Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_38_8[1],
			var_38_8[2] + var_38_9.size[2] + var_38_6,
			0
		},
		size = {
			var_38_0[1] - var_38_8[1],
			var_38_5
		}
	}
	local var_38_12 = table.clone(var_38_11)

	var_38_12.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_38_12.offset = {
		var_38_11.offset[1] + 2,
		var_38_11.offset[2] - 2,
		var_38_11.offset[3] - 1
	}

	local var_38_13 = {
		{
			style_id = "icon_hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (arg_39_0, arg_39_1)
				return not arg_39_0.hotspot.is_hover
			end
		},
		{
			style_id = "icon_bg",
			pass_type = "rect",
			content_check_function = function (arg_40_0)
				return not arg_40_0.is_rectangular_icon and not arg_38_13
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_bg",
			texture_id = "rect_masked",
			content_check_function = function (arg_41_0)
				return not arg_41_0.is_rectangular_icon and arg_38_13
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_background",
			texture_id = "icon_background"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_42_0)
				return not arg_42_0.hide_text
			end
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_43_0)
				return not arg_43_0.hide_text
			end
		},
		{
			style_id = "sub_text",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (arg_44_0)
				return not arg_44_0.hide_text
			end
		},
		{
			style_id = "sub_text_shadow",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (arg_45_0)
				return not arg_45_0.hide_text
			end
		}
	}
	local var_38_14 = {
		rect_masked = "rect_masked",
		hotspot = {},
		icon = arg_38_1,
		icon_background = arg_38_4,
		title_text = arg_38_8,
		sub_text = arg_38_7,
		total_widget_size = var_38_0,
		is_rectangular_icon = arg_38_11,
		hide_text = arg_38_12
	}
	local var_38_15 = {
		icon = var_38_1,
		icon_hotspot = arg_38_14 or var_38_1,
		icon_bg = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = {
				58,
				58
			},
			color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				3,
				0,
				0
			}
		},
		icon_background = var_38_2,
		title_text = var_38_11,
		title_text_shadow = var_38_12,
		sub_text = var_38_9,
		sub_text_shadow = var_38_10
	}

	return {
		element = {
			passes = var_38_13
		},
		content = var_38_14,
		style = var_38_15,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_38_0
	}
end

UIWidgets.create_start_game_difficulty_stepper = function (arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = {
		-12.5,
		0,
		0
	}
	local var_46_1 = "morris_arrow_highlight"

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					style_id = "info_hotspot",
					pass_type = "hotspot",
					content_id = "info_hotspot"
				},
				{
					style_id = "left_arrow_hotspot",
					pass_type = "hotspot",
					content_id = "left_arrow_hotspot"
				},
				{
					style_id = "left_arrow",
					pass_type = "texture_uv",
					content_id = "left_arrow"
				},
				{
					style_id = "left_arrow_hover",
					pass_type = "texture_uv",
					content_id = "left_arrow_hover",
					content_check_function = function (arg_47_0)
						return arg_47_0.parent.left_arrow_hotspot.is_hover
					end
				},
				{
					style_id = "left_arrow_gamepad_highlight",
					pass_type = "texture_uv",
					content_id = "left_arrow_gamepad_highlight",
					content_check_function = function (arg_48_0)
						return arg_48_0.parent.left_arrow_pressed
					end
				},
				{
					style_id = "left_arrow_clicked",
					pass_type = "texture_uv",
					content_id = "left_arrow_clicked",
					content_check_function = function (arg_49_0)
						return arg_49_0.parent.left_arrow_hotspot.is_clicked == 0
					end
				},
				{
					style_id = "right_arrow_hotspot",
					pass_type = "hotspot",
					content_id = "right_arrow_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "right_arrow",
					texture_id = "right_arrow"
				},
				{
					pass_type = "texture",
					style_id = "right_arrow_hover",
					texture_id = "right_arrow_hover",
					content_check_function = function (arg_50_0)
						return arg_50_0.right_arrow_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "right_arrow_gamepad_highlight",
					texture_id = "right_arrow_gamepad_highlight",
					content_check_function = function (arg_51_0)
						return arg_51_0.right_arrow_pressed
					end
				},
				{
					pass_type = "texture",
					style_id = "right_arrow_clicked",
					texture_id = "right_arrow_clicked",
					content_check_function = function (arg_52_0)
						return arg_52_0.right_arrow_hotspot.is_clicked == 0
					end
				},
				{
					pass_type = "texture",
					style_id = "difficulty_icon",
					texture_id = "difficulty_icon"
				},
				{
					style_id = "difficulty_text",
					pass_type = "text",
					text_id = "difficulty_text"
				},
				{
					pass_type = "texture",
					style_id = "selected_difficulty_text_bg",
					texture_id = "selected_difficulty_text_bg"
				},
				{
					pass_type = "texture",
					style_id = "selected_difficulty_text_border",
					texture_id = "selected_difficulty_text_border"
				},
				{
					style_id = "selected_difficulty_text_selected",
					texture_id = "selected_difficulty_text_selected",
					pass_type = "texture",
					content_check_function = function (arg_53_0)
						return arg_53_0.right_arrow_hotspot.is_hover or arg_53_0.left_arrow_hotspot.is_hover or not Managers.input:is_device_active("mouse") and arg_53_0.is_selected
					end,
					content_change_function = function (arg_54_0, arg_54_1)
						arg_54_1.color[1] = var_0_3(not Managers.input:is_device_active("mouse"))
					end
				},
				{
					style_id = "selected_difficulty_text",
					pass_type = "text",
					text_id = "selected_difficulty_text"
				}
			}
		},
		content = {
			selected_difficulty_text_border = "morris_difficulty_select_border",
			selected_difficulty_text_bg = "morris_difficulty_select_background",
			right_arrow_pressed = false,
			selected_difficulty_text_selected = "morris_difficulty_select_highlight",
			right_arrow = "morris_arrow_neutral",
			left_arrow_pressed = false,
			background = "morris_difficulty_frame",
			info_hotspot = {},
			left_arrow_hotspot = {},
			left_arrow = {
				texture_id = "morris_arrow_neutral",
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
				texture_id = var_46_1
			},
			left_arrow_gamepad_highlight = {
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
				texture_id = var_46_1
			},
			left_arrow_clicked = {
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
				texture_id = var_46_1
			},
			right_arrow_hover = var_46_1,
			right_arrow_hotspot = {},
			right_arrow_gamepad_highlight = var_46_1,
			right_arrow_clicked = var_46_1,
			difficulty_icon = arg_46_2 or "difficulty_option_1",
			difficulty_text = arg_46_1 or Localize("not_assigned"),
			selected_difficulty_text = Localize("not_assigned")
		},
		style = {
			background = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1],
					var_46_0[2],
					var_46_0[3] + 5
				},
				size = {
					550,
					180
				}
			},
			info_hotspot = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1],
					var_46_0[2],
					var_46_0[3] + 6
				},
				size = {
					600,
					180
				}
			},
			left_arrow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 125,
					var_46_0[2] + 35,
					var_46_0[3] + 6
				},
				size = {
					52,
					71
				}
			},
			left_arrow_hover = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 125,
					var_46_0[2] + 35,
					var_46_0[3] + 6
				},
				size = {
					52,
					71
				}
			},
			left_arrow_gamepad_highlight = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 125,
					var_46_0[2] + 35,
					var_46_0[3] + 6
				},
				size = {
					52,
					71
				}
			},
			left_arrow_hotspot = {
				color = {
					50,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 125,
					var_46_0[2] + 35,
					var_46_0[3] + 7
				},
				size = {
					52,
					71
				}
			},
			left_arrow_clicked = {
				color = {
					150,
					150,
					150,
					150
				},
				offset = {
					var_46_0[1] + 125,
					var_46_0[2] + 35,
					var_46_0[3] + 7
				},
				size = {
					52,
					71
				}
			},
			right_arrow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 475,
					var_46_0[2] + 35,
					var_46_0[3] + 6
				},
				size = {
					52,
					71
				}
			},
			right_arrow_hover = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 475,
					var_46_0[2] + 35,
					var_46_0[3] + 6
				},
				size = {
					52,
					71
				}
			},
			right_arrow_gamepad_highlight = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 475,
					var_46_0[2] + 35,
					var_46_0[3] + 6
				},
				size = {
					52,
					71
				}
			},
			right_arrow_hotspot = {
				color = {
					50,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 475,
					var_46_0[2] + 35,
					var_46_0[3] + 7
				},
				size = {
					52,
					71
				}
			},
			right_arrow_clicked = {
				color = {
					150,
					150,
					150,
					150
				},
				offset = {
					var_46_0[1] + 475,
					var_46_0[2] + 35,
					var_46_0[3] + 7
				},
				size = {
					52,
					71
				}
			},
			difficulty_icon = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 12.5,
					var_46_0[2] + 17.5,
					var_46_0[3] + 6
				},
				size = {
					112.5,
					112.5
				}
			},
			difficulty_text = {
				font_size = 26,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = {
					255,
					193,
					91,
					36
				},
				default_text_color = {
					255,
					193,
					91,
					36
				},
				offset = {
					var_46_0[1] + 180,
					var_46_0[2] + 137.5,
					12
				},
				size = {
					200,
					52
				}
			},
			selected_difficulty_text_bg = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 175,
					var_46_0[2] + 45,
					5
				},
				size = {
					305,
					52
				}
			},
			selected_difficulty_text_border = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 175,
					var_46_0[2] + 45,
					7
				},
				size = {
					305,
					52
				}
			},
			selected_difficulty_text_selected = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_46_0[1] + 175,
					var_46_0[2] + 45,
					6
				},
				size = {
					305,
					52
				}
			},
			selected_difficulty_text = {
				font_size = 26,
				upper_case = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_46_0[1] + 175,
					var_46_0[2] + 45,
					7
				},
				size = {
					305,
					52
				}
			}
		},
		scenegraph_id = arg_46_0,
		offset = var_46_0
	}
end

UIWidgets.create_deus_panel_with_outer_frame = function (arg_55_0, arg_55_1)
	local var_55_0 = UIFrameSettings.border_tiled
	local var_55_1 = var_55_0.texture_sizes.corner
	local var_55_2 = {
		var_55_1[1] + 1,
		var_55_1[2] + 1
	}

	return {
		scenegraph_id = arg_55_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "tiled_texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture_frame",
					style_id = "border",
					texture_id = "border"
				}
			}
		},
		content = {
			background = "bg_tile",
			border = var_55_0.texture
		},
		style = {
			background = {
				texture_tiling_size = {
					256,
					256
				},
				texture_size = arg_55_1,
				offset = {
					0,
					0,
					1
				},
				color = {
					200,
					255,
					255,
					255
				}
			},
			border = {
				use_tiling = true,
				texture_size = var_55_0.texture_size,
				texture_sizes = var_55_0.texture_sizes,
				size = {
					arg_55_1[1] + 2 * var_55_2[1],
					arg_55_1[2] + 2 * var_55_2[2]
				},
				offset = {
					-var_55_2[1],
					-var_55_2[2],
					2
				},
				color = {
					200,
					0,
					0,
					0
				}
			}
		}
	}
end

UIWidgets.create_start_game_deus_play_button = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	local var_56_0 = "background_tiled_morris"
	local var_56_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_56_0)
	local var_56_2 = var_56_1.size
	local var_56_3 = UIFrameSettings.menu_frame_05_morris
	local var_56_4 = "button_glass_02"
	local var_56_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_56_4).size
	local var_56_6 = var_56_3.texture_sizes.horizontal[2]
	local var_56_7 = "button_detail_01_morris"
	local var_56_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_56_7).size
	local var_56_9 = {
		45,
		4
	}
	local var_56_10 = "button_detail_01_hover_morris"
	local var_56_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_56_10).size

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "tiled_texture"
				},
				{
					style_id = "clicked_rect",
					pass_type = "rect",
					content_check_function = function (arg_57_0)
						local var_57_0 = arg_57_0.button_hotspot.is_clicked

						return not var_57_0 or var_57_0 == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_58_0)
						return arg_58_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (arg_59_0)
						return not arg_59_0.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (arg_60_0)
						return not arg_60_0.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_left_disabled",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (arg_61_0)
						return arg_61_0.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right_disabled",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (arg_62_0)
						return arg_62_0.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_glow_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (arg_63_0)
						return not arg_63_0.parent.button_hotspot.disable_button
					end,
					content_change_function = function (arg_64_0, arg_64_1)
						arg_64_1.color[1] = var_0_3(arg_64_0.parent.is_selected)
					end
				},
				{
					style_id = "side_detail_glow_right",
					pass_type = "texture_uv",
					content_id = "side_detail_glow",
					content_check_function = function (arg_65_0)
						return not arg_65_0.parent.button_hotspot.disable_button
					end,
					content_change_function = function (arg_66_0, arg_66_1)
						arg_66_1.color[1] = var_0_3(arg_66_0.parent.is_selected)
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_67_0)
						return not arg_67_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_68_0)
						return arg_68_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "nop"
				},
				{
					texture_id = "effect",
					style_id = "effect",
					pass_type = "texture",
					content_check_function = function (arg_69_0)
						local var_69_0 = arg_69_0.button_hotspot

						return not var_69_0.disable_button and (var_69_0.is_hover or arg_69_0.is_selected)
					end
				},
				{
					texture_id = "effect",
					style_id = "effect_active",
					pass_type = "texture",
					content_check_function = function (arg_70_0)
						local var_70_0 = arg_70_0.button_hotspot

						return not var_70_0.disable_button and not var_70_0.is_hover
					end
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (arg_71_0)
						local var_71_0 = arg_71_0.button_hotspot

						return not var_71_0.disable_button and (var_71_0.is_hover or arg_71_0.is_selected)
					end
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow_active",
					pass_type = "texture",
					content_check_function = function (arg_72_0)
						local var_72_0 = arg_72_0.button_hotspot

						return not var_72_0.disable_button and not var_72_0.is_hover
					end
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture",
					content_check_function = function (arg_73_0)
						local var_73_0 = arg_73_0.button_hotspot

						return not var_73_0.disable_button and var_73_0.is_hover
					end
				},
				{
					style_id = "fade_right",
					pass_type = "texture",
					content_id = "fade"
				},
				{
					style_id = "fade_left",
					pass_type = "texture_uv",
					content_id = "fade"
				}
			}
		},
		content = {
			effect = "play_button_passive_glow",
			hover_glow = "button_state_hover_green",
			glow = "play_button_glow",
			is_selected = false,
			side_detail_glow = {
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
				texture_id = var_56_10
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
				texture_id = var_56_7
			},
			fade = {
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
			},
			glass = var_56_4,
			button_hotspot = {},
			title_text = arg_56_2 or "n/a",
			frame = var_56_3.texture,
			disable_with_gamepad = arg_56_4,
			background = {
				uvs = {
					{
						0,
						1 - arg_56_1[2] / var_56_1.size[2]
					},
					{
						arg_56_1[1] / var_56_1.size[1],
						1
					}
				},
				texture_id = var_56_0
			},
			background = var_56_0
		},
		style = {
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
				},
				texture_tiling_size = {
					var_56_2[1],
					var_56_2[2]
				},
				texture_size = {
					arg_56_1[1],
					arg_56_1[2]
				}
			},
			clicked_rect = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				},
				size = {
					arg_56_1[1],
					arg_56_1[2]
				}
			},
			disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					7
				},
				size = {
					arg_56_1[1],
					arg_56_1[2]
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_56_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_56_1[1],
					arg_56_1[2]
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_56_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_56_1[1],
					arg_56_1[2]
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_56_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					8
				},
				size = {
					arg_56_1[1],
					arg_56_1[2]
				}
			},
			frame = {
				use_tiling = true,
				texture_size = var_56_3.texture_size,
				texture_sizes = var_56_3.texture_sizes,
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
				},
				size = {
					arg_56_1[1],
					arg_56_1[2]
				}
			},
			hover_glow = {
				color = {
					192,
					255,
					255,
					255
				},
				offset = {
					0,
					var_56_3.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_56_1[1],
					math.min(60, arg_56_1[2] - var_56_3.texture_sizes.horizontal[2] * 2)
				}
			},
			hover_glow_active = {
				color = {
					60,
					255,
					255,
					255
				},
				offset = {
					0,
					var_56_3.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_56_1[1],
					math.min(60, arg_56_1[2] - var_56_3.texture_sizes.horizontal[2] * 2)
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_56_1[2] - var_56_5[2] - var_56_6,
					6
				},
				size = {
					arg_56_1[1],
					var_56_5[2]
				}
			},
			glass_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_56_6 - 8,
					6
				},
				size = {
					arg_56_1[1],
					var_56_5[2]
				}
			},
			glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_56_6 - 1,
					3
				},
				size = {
					arg_56_1[1],
					math.min(60, arg_56_1[2] - var_56_6 * 2)
				}
			},
			effect = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					5
				},
				size = {
					arg_56_1[1],
					arg_56_1[2]
				}
			},
			effect_active = {
				color = {
					128,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					5
				},
				size = {
					arg_56_1[1],
					arg_56_1[2]
				}
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_56_9[1],
					(arg_56_1[2] - var_56_8[2]) / 2 + var_56_9[2],
					9
				},
				size = {
					var_56_8[1],
					var_56_8[2]
				}
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_56_1[1] - var_56_8[1] + var_56_9[1],
					(arg_56_1[2] - var_56_8[2]) / 2 + var_56_9[2],
					9
				},
				size = {
					var_56_8[1],
					var_56_8[2]
				}
			},
			side_detail_left_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					-var_56_9[1],
					(arg_56_1[2] - var_56_8[2]) / 2 + var_56_9[2],
					9
				},
				size = {
					var_56_8[1],
					var_56_8[2]
				}
			},
			side_detail_right_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					arg_56_1[1] - var_56_8[1] + var_56_9[1],
					(arg_56_1[2] - var_56_8[2]) / 2 + var_56_9[2],
					9
				},
				size = {
					var_56_8[1],
					var_56_8[2]
				}
			},
			side_detail_glow_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_56_9[1],
					(arg_56_1[2] - var_56_11[2]) / 2 + var_56_9[2],
					10
				},
				size = {
					var_56_11[1],
					var_56_11[2]
				}
			},
			side_detail_glow_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_56_1[1] - var_56_11[1] + var_56_9[1],
					(arg_56_1[2] - var_56_11[2]) / 2 + var_56_9[2],
					10
				},
				size = {
					var_56_11[1],
					var_56_11[2]
				}
			},
			fade_left = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("black", 255),
				texture_size = {
					100,
					arg_56_1[2]
				},
				offset = {
					0,
					0,
					0
				}
			},
			fade_right = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = Colors.get_color_table_with_alpha("black", 255),
				texture_size = {
					100,
					arg_56_1[2]
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		scenegraph_id = arg_56_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_deus_default_button = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
	local var_74_0 = "button_bg_01"
	local var_74_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_74_0)
	local var_74_2 = "menu_frame_01_morris"
	local var_74_3 = UIFrameSettings[var_74_2]
	local var_74_4 = var_74_3.texture_sizes.corner[1]
	local var_74_5 = var_74_3.texture_sizes.horizontal[2]
	local var_74_6 = "button_detail_02_morris"
	local var_74_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_74_6).size
	local var_74_8 = "button_detail_02_hover_morris"
	local var_74_9 = 30
	local var_74_10 = 5

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function (arg_75_0)
						return arg_75_0.draw_frame
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_76_0)
						return arg_76_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail"
				},
				{
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail"
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail_glow",
					content_check_function = function (arg_77_0)
						local var_77_0 = arg_77_0.parent.button_hotspot

						return not var_77_0.disable_button and var_77_0.is_hover
					end
				},
				{
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (arg_78_0)
						local var_78_0 = arg_78_0.parent.button_hotspot

						return not var_78_0.disable_button and var_78_0.is_hover
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_79_0)
						return not arg_79_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_80_0)
						return arg_80_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			hover_glow = "button_state_default",
			background_fade = "button_bg_fade",
			glass = "button_glass_02",
			draw_frame = true,
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
				texture_id = var_74_6
			},
			side_detail_glow = {
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
				texture_id = var_74_8
			},
			button_hotspot = {},
			title_text = arg_74_2 or "n/a",
			frame = var_74_3.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_74_1[2] / var_74_1.size[2]
					},
					{
						arg_74_1[1] / var_74_1.size[1],
						1
					}
				},
				texture_id = var_74_0
			},
			disable_with_gamepad = arg_74_4
		},
		style = {
			background = {
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_74_4,
					var_74_4 - 2,
					2
				},
				size = {
					arg_74_1[1] - var_74_4 * 2,
					arg_74_1[2] - var_74_4 * 2
				}
			},
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					var_74_4 - 2,
					3
				},
				size = {
					arg_74_1[1],
					math.min(arg_74_1[2] - 5, 80)
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				}
			},
			disabled_rect = {
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_74_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_74_1[1] - 40,
					arg_74_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_74_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_74_1[1] - 40,
					arg_74_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_74_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_74_1[1] - 40,
					arg_74_1[2]
				},
				offset = {
					22,
					-2,
					5
				}
			},
			frame = {
				texture_size = var_74_3.texture_size,
				texture_sizes = var_74_3.texture_sizes,
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
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_74_1[2] - (var_74_5 + 11),
					4
				},
				size = {
					arg_74_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					var_74_5 - 9,
					4
				},
				size = {
					arg_74_1[1],
					11
				}
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_74_9,
					arg_74_1[2] / 2 - var_74_7[2] / 2 + var_74_10,
					9
				},
				size = {
					var_74_7[1],
					var_74_7[2]
				}
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_74_1[1] - var_74_7[1] + var_74_9,
					arg_74_1[2] / 2 - var_74_7[2] / 2 + var_74_10,
					9
				},
				size = {
					var_74_7[1],
					var_74_7[2]
				}
			}
		},
		scenegraph_id = arg_74_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_start_game_deus_journey_stepper = function (arg_81_0)
	return {
		scenegraph_id = arg_81_0,
		offset = {
			0,
			0,
			0
		},
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
				color = {
					255,
					0,
					0,
					255
				}
			}
		}
	}
end

UIWidgets.create_start_game_deus_gamemode_info_box = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4, arg_82_5)
	local var_82_0 = arg_82_4 and 0 or 255
	local var_82_1 = arg_82_4 and arg_82_1[2] / 2 or arg_82_1[2]
	local var_82_2 = arg_82_4 and arg_82_1[2] / 2 or 0

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					style_id = "info_hotspot",
					pass_type = "hotspot",
					content_id = "info_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "header_box_title_frame",
					texture_id = "header_box_title_frame"
				},
				{
					style_id = "header_text",
					pass_type = "text",
					text_id = "header_text"
				},
				{
					pass_type = "texture",
					style_id = "box_left_detail",
					texture_id = "box_left_detail"
				},
				{
					pass_type = "texture",
					style_id = "box_right_detail",
					texture_id = "box_right_detail"
				},
				{
					style_id = "game_mode_text",
					pass_type = "text",
					text_id = "game_mode_text"
				},
				{
					style_id = "note_text",
					pass_type = "text",
					text_id = "note_text",
					content_check_function = function (arg_83_0)
						return arg_83_0.show_note and not arg_82_5
					end
				},
				{
					style_id = "press_key_text",
					pass_type = "text",
					text_id = "press_key_text",
					content_check_function = function (arg_84_0)
						return not arg_84_0.show_note and not arg_82_5
					end
				}
			}
		},
		content = {
			box_left_detail = "morris_header_end",
			header_box_title_frame = "morris_header_frame",
			is_showing_info = false,
			fade_out_done = false,
			background = "morris_header_background",
			show_note = false,
			box_right_detail = "morris_header_end",
			info_hotspot = {},
			header_text = arg_82_2 or Localize("not_assigned"),
			game_mode_text = arg_82_3 or Localize("not_assigned"),
			note_text = Localize("expedition_info_note") or Localize("not_assigned"),
			press_key_text = string.format(Localize("for_more_info"), "$KEY;start_game_view__show_information:") or Localize("not_assigned"),
			disable_note = arg_82_5
		},
		style = {
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
				},
				size = arg_82_1
			},
			info_hotspot = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_82_2,
					0
				},
				size = {
					arg_82_1[1],
					var_82_1
				}
			},
			header_box_title_frame = {
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					846,
					162
				},
				offset = {
					-125,
					arg_82_1[2] - 30,
					1
				}
			},
			header_text = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				font_size = 50,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = {
					var_82_0,
					193,
					91,
					36
				},
				size = {
					arg_82_1[1],
					40
				},
				area_size = {
					arg_82_1[1] - 200,
					40
				},
				offset = {
					0,
					arg_82_1[2],
					2
				}
			},
			box_left_detail = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					-19,
					arg_82_1[2] - 182,
					0
				},
				size = {
					43,
					arg_82_1[2] - arg_82_1[2] / 5
				}
			},
			box_right_detail = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					arg_82_1[1] - 19,
					arg_82_1[2] - 182,
					0
				},
				size = {
					43,
					arg_82_1[2] - arg_82_1[2] / 5
				}
			},
			game_mode_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					25,
					arg_82_4 and arg_82_1[2] / 2 - 20 or arg_82_1[2] / 2 - 40,
					2
				},
				size = {
					arg_82_1[1] - 50,
					arg_82_4 and arg_82_1[2] / 2 or arg_82_1[2] / 2 + 10
				}
			},
			note_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = {
					255,
					209,
					0,
					28
				},
				offset = {
					25,
					25,
					2
				},
				size = {
					arg_82_1[1] - 50,
					40
				}
			},
			press_key_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					25,
					25,
					2
				},
				size = {
					arg_82_1[1] - 50,
					arg_82_1[2] - 50
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_82_0
	}
end

UIWidgets.create_expedition_widget_func = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4, arg_85_5)
	local var_85_0 = arg_85_4 or {
		width = 72,
		spacing_x = 40
	}
	local var_85_1 = {
		180,
		180
	}
	local var_85_2 = arg_85_5 or 1
	local var_85_3 = {
		element = {}
	}
	local var_85_4 = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (arg_86_0)
				return not arg_86_0.parent.locked
			end
		},
		{
			style_id = "level_icon",
			pass_type = "level_tooltip",
			level_id = "level_data",
			content_check_function = function (arg_87_0)
				return arg_87_0.button_hotspot.is_hover or arg_87_0.gamepad_selected
			end
		},
		{
			style_id = "icon_glow",
			texture_id = "icon_glow",
			pass_type = "texture",
			content_check_function = function (arg_88_0)
				local var_88_0 = Managers.input:is_device_active("mouse")

				return (arg_88_0.button_hotspot.is_hover or arg_88_0.gamepad_selected and not var_88_0) and not arg_88_0.button_hotspot.is_selected
			end,
			content_change_function = function (arg_89_0, arg_89_1)
				arg_89_1.color[1] = var_0_3(arg_89_0.gamepad_selected)
			end
		},
		{
			pass_type = "texture",
			style_id = "level_icon",
			texture_id = "level_icon",
			content_check_function = function (arg_90_0, arg_90_1)
				return not arg_90_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "level_icon_locked",
			texture_id = "level_icon",
			content_check_function = function (arg_91_0)
				return arg_91_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (arg_92_0)
				return arg_92_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_fade",
			texture_id = "lock_fade",
			content_check_function = function (arg_93_0)
				return arg_93_0.locked
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "path",
			texture_id = "path",
			content_check_function = function (arg_94_0)
				return arg_94_0.draw_path and not arg_94_0.draw_path_fill
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "path_glow",
			texture_id = "path_glow",
			content_check_function = function (arg_95_0)
				return arg_95_0.draw_path and arg_95_0.draw_path_fill and not arg_95_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "theme_icon",
			texture_id = "theme_icon",
			content_check_function = function (arg_96_0)
				return arg_96_0.theme_icon ~= nil
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "level_icon_mask",
			texture_id = "level_icon_mask",
			content_check_function = function (arg_97_0)
				return true
			end
		},
		{
			pass_type = "texture",
			style_id = "level_icon_frame",
			texture_id = "level_icon_frame",
			content_check_function = function (arg_98_0, arg_98_1)
				return not arg_98_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "purple_glow",
			texture_id = "purple_glow"
		},
		{
			pass_type = "texture",
			style_id = "name_frame",
			texture_id = "name_frame",
			content_check_function = function (arg_99_0, arg_99_1)
				if Managers.input:is_device_active("gamepad") then
					return arg_99_0.gamepad_selected
				else
					return arg_99_0.button_hotspot.is_selected
				end
			end
		},
		{
			style_id = "journey_name",
			pass_type = "text",
			text_id = "journey_name_text",
			content_check_function = function (arg_100_0, arg_100_1)
				if Managers.input:is_device_active("gamepad") then
					return arg_100_0.gamepad_selected
				else
					return arg_100_0.button_hotspot.is_selected
				end
			end
		}
	}
	local var_85_5 = {
		level_icon = "level_icon_01",
		draw_path = false,
		level_icon_frame = "morris_expedition_select_border",
		chaos_symbol = "map_frame_chaos_slot_01",
		path = "mission_select_screen_trail",
		lock_fade = "map_frame_fade",
		name_frame = "morris_expedition_name_frame",
		locked = true,
		level_icon_mask = "mask_rect",
		purple_glow = "morris_expedition_glow",
		lock = "morris_expedition_locked",
		icon_glow = "morris_expedition_hover",
		path_glow = "mission_select_screen_trail_fill",
		draw_path_fill = false,
		gamepad_selected = false,
		draw_chaos_symbol = true,
		button_hotspot = {},
		journey_data = arg_85_2,
		journey_name = arg_85_3,
		journey_name_text = arg_85_2.display_name
	}
	local var_85_6 = {
		hotspot = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = {
				150 * var_85_2,
				150 * var_85_2
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
				3
			}
		},
		path = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			angle = 0,
			pivot = {
				0,
				6.5
			},
			texture_size = {
				var_85_0.spacing_x,
				10
			},
			offset = {
				(var_85_0.width + var_85_0.spacing_x) * 0.5,
				-2,
				2
			},
			color = {
				255,
				255,
				0,
				0
			}
		},
		path_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			angle = 0,
			pivot = {
				0,
				21.5
			},
			texture_size = {
				var_85_0.spacing_x,
				30
			},
			offset = {
				(var_85_0.width + var_85_0.spacing_x) * 0.5,
				-2,
				2
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				160 * var_85_2,
				160 * var_85_2
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
		lock_fade = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				180 * var_85_2,
				180 * var_85_2
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
		},
		level_icon_mask = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				90 * var_85_2,
				90 * var_85_2
			},
			angle = math.degrees_to_radians(45),
			pivot = {
				90 * var_85_2 * 0.5,
				90 * var_85_2 * 0.5
			}
		},
		level_icon_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				160 * var_85_2,
				160 * var_85_2
			},
			offset = {
				0,
				0,
				5
			}
		},
		level_icon = {
			vertical_alignment = "center",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				160 * var_85_2,
				160 * var_85_2
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
				3
			}
		},
		level_icon_locked = {
			vertical_alignment = "center",
			saturated = true,
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				168 * var_85_2,
				168 * var_85_2
			},
			color = {
				255,
				100,
				100,
				100
			},
			offset = {
				0,
				0,
				3
			}
		},
		purple_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				240 * var_85_2 * 0.9,
				330 * var_85_2 * 0.9
			},
			offset = {
				0,
				45 * var_85_2,
				4
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				187 * var_85_2 + 6,
				170 * var_85_2 + 6
			},
			offset = {
				-1,
				-12,
				4
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		chaos_symbol = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				80 * var_85_2,
				80 * var_85_2
			},
			offset = {
				0,
				80 * var_85_2,
				8
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		theme_icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				40 * var_85_2,
				40 * var_85_2
			},
			offset = {
				0,
				65 * var_85_2,
				8
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		name_frame = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				294 * var_85_2,
				100 * var_85_2
			},
			offset = {
				5,
				-130,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		journey_name = {
			font_size = 28,
			localize = true,
			word_wrap = false,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			area_size = {
				250,
				80
			},
			offset = {
				0,
				-120,
				2
			},
			text_color = Colors.get_color_table_with_alpha("font_default", 255)
		}
	}

	var_85_3.element.passes = var_85_4
	var_85_3.content = var_85_5
	var_85_3.style = var_85_6
	var_85_3.offset = {
		0,
		0,
		0
	}
	var_85_3.scenegraph_id = arg_85_0

	return var_85_3
end

UIWidgets.create_start_game_deus_difficulty_info_box = function (arg_101_0, arg_101_1)
	local var_101_0 = UIFrameSettings.border_tiled
	local var_101_1 = var_101_0.texture_sizes.corner
	local var_101_2 = {
		var_101_1[1] + 1,
		var_101_1[2] + 1
	}

	return {
		element = {
			passes = {
				{
					style_id = "background",
					texture_id = "background",
					pass_type = "tiled_texture",
					content_change_function = function (arg_102_0, arg_102_1)
						local var_102_0 = {
							0 + arg_102_0.resize_offset[1],
							0 + arg_102_0.resize_offset[2],
							1
						}

						if arg_102_0.should_resize then
							arg_102_1.texture_size = arg_102_0.resize_size
							arg_102_1.offset = var_102_0
						end
					end
				},
				{
					style_id = "border",
					texture_id = "border",
					pass_type = "texture_frame",
					content_change_function = function (arg_103_0, arg_103_1)
						local var_103_0 = {
							-var_101_2[1] + arg_103_0.resize_offset[1],
							-var_101_2[2] + arg_103_0.resize_offset[2],
							2
						}
						local var_103_1 = arg_103_0.resize_size

						if arg_103_0.should_resize then
							arg_103_1.size = {
								var_103_1[1] + 2 * var_101_2[1],
								var_103_1[2] + 2 * var_101_2[2]
							}
							arg_103_1.offset = var_103_0
						end
					end
				},
				{
					style_id = "difficulty_description",
					pass_type = "text",
					text_id = "difficulty_description",
					content_change_function = function (arg_104_0, arg_104_1)
						local var_104_0 = {
							25 + arg_104_0.resize_offset[1],
							160 - arg_104_0.resize_offset[2],
							2
						}

						if arg_104_0.should_resize then
							arg_104_1.offset = var_104_0
							arg_104_1.offset = var_104_0
						end
					end
				},
				{
					style_id = "highest_obtainable_level",
					pass_type = "text",
					text_id = "highest_obtainable_level",
					content_change_function = function (arg_105_0, arg_105_1)
						local var_105_0 = {
							25 + arg_105_0.resize_offset[1],
							140 - arg_105_0.difficulty_description_text_size - arg_105_0.resize_offset[2],
							2
						}

						if arg_105_0.should_resize then
							arg_105_1.offset = var_105_0
						end
					end
				},
				{
					style_id = "difficulty_separator",
					texture_id = "difficulty_separator",
					pass_type = "texture",
					content_change_function = function (arg_106_0, arg_106_1)
						local var_106_0 = {
							arg_101_1[1] / 4 + arg_106_0.resize_offset[1],
							120 - arg_106_0.difficulty_description_text_size - arg_106_0.resize_offset[2],
							2
						}

						if arg_106_0.should_resize then
							arg_106_1.offset = var_106_0
						end
					end
				},
				{
					style_id = "widget_hotspot",
					pass_type = "hotspot",
					content_id = "widget_hotspot"
				},
				{
					style_id = "difficulty_lock_text",
					pass_type = "text",
					text_id = "difficulty_lock_text",
					content_check_function = function (arg_107_0)
						return arg_107_0.should_show_diff_lock_text
					end,
					content_change_function = function (arg_108_0, arg_108_1)
						local var_108_0 = {
							7.5 + arg_108_0.resize_offset[1],
							-arg_108_0.difficulty_description_text_size - arg_108_0.resize_offset[2] + 90,
							2
						}

						if arg_108_0.should_resize then
							arg_108_1.offset = var_108_0
						end
					end
				},
				{
					style_id = "dlc_lock_text",
					pass_type = "text",
					text_id = "dlc_lock_text",
					content_check_function = function (arg_109_0)
						return arg_109_0.should_show_dlc_lock
					end,
					content_change_function = function (arg_110_0, arg_110_1)
						local var_110_0 = {
							2.5 + arg_110_0.resize_offset[1],
							-arg_110_0.difficulty_description_text_size - arg_110_0.resize_offset[2] + 70 - arg_110_0.difficulty_lock_text_height,
							2
						}

						if arg_110_0.should_resize then
							arg_110_1.offset = var_110_0
						end
					end
				}
			}
		},
		content = {
			should_show_diff_lock_text = false,
			difficulty_description = "difficulty description",
			should_show_dlc_lock = false,
			highest_obtainable_level = "highest obtainable level",
			should_resize = false,
			background = "bg_tile",
			difficulty_separator = "divider_01_bottom",
			difficulty_description_text_size = 0,
			difficulty_lock_text_height = 0,
			border = var_101_0.texture,
			widget_hotspot = {},
			difficulty_lock_text = Localize("required_power_level"),
			dlc_lock_text = Localize("cataclysm_no_wom"),
			resize_offset = {
				0,
				0,
				0
			},
			resize_size = {
				0,
				0
			}
		},
		style = {
			background = {
				texture_tiling_size = {
					256,
					256
				},
				texture_size = arg_101_1,
				offset = {
					0,
					0,
					1
				},
				color = {
					200,
					255,
					255,
					255
				}
			},
			border = {
				use_tiling = true,
				texture_size = var_101_0.texture_size,
				texture_sizes = var_101_0.texture_sizes,
				size = {
					arg_101_1[1] + 2 * var_101_2[1],
					arg_101_1[2] + 2 * var_101_2[2]
				},
				offset = {
					-var_101_2[1],
					-var_101_2[2],
					2
				},
				color = {
					200,
					0,
					0,
					0
				}
			},
			difficulty_description = {
				font_size = 20,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					25,
					-75,
					2
				},
				size = {
					450,
					20
				}
			},
			highest_obtainable_level = {
				font_size = 22,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = {
					255,
					250,
					250,
					250
				},
				offset = {
					25,
					0,
					2
				},
				size = {
					450,
					20
				}
			},
			difficulty_separator = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_101_1[1] / 4,
					0,
					2
				},
				size = {
					264,
					21
				}
			},
			widget_hotspot = {
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
				},
				size = arg_101_1
			},
			difficulty_lock_text = {
				font_size = 20,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = {
					255,
					199,
					199,
					199
				},
				offset = {
					7.5,
					0,
					1
				},
				size = {
					485,
					20
				}
			},
			dlc_lock_text = {
				font_size = 20,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = {
					255,
					220,
					148,
					64
				},
				offset = {
					2.5,
					0,
					1
				},
				size = {
					485,
					20
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_101_0
	}
end

UIWidgets.create_ability_charges_widget = function (arg_111_0, arg_111_1, arg_111_2)
	local var_111_0 = arg_111_1 or {
		20,
		20
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "ability_charge_bg",
					texture_id = "ability_charge_bg"
				},
				{
					pass_type = "texture",
					style_id = "ability_charge_active",
					texture_id = "ability_charge_active",
					content_check_function = function (arg_112_0, arg_112_1)
						return arg_112_0.ready
					end
				}
			}
		},
		content = {
			ability_charge_bg = "hud_career_ability_charge_bg",
			ready = false,
			ability_charge_active = "hud_career_ability_charge_active"
		},
		style = {
			ability_charge_bg = {
				texture_size = var_111_0,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			ability_charge_active = {
				texture_size = {
					var_111_0[1] - 4,
					var_111_0[2] - 4
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					2,
					2,
					2
				}
			}
		},
		scenegraph_id = arg_111_0,
		offset = arg_111_2 or {
			0,
			0,
			1
		}
	}
end

UIWidgets.create_power_up = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3)
	local var_113_0 = true

	if arg_113_2 then
		var_113_0 = false
	end

	return {
		element = {
			passes = {
				{
					texture_id = "shrine_bg",
					style_id = "shrine_bg",
					pass_type = "texture",
					content_check_function = function (arg_114_0)
						return not arg_114_0.extend_left
					end
				},
				{
					texture_id = "shrine_bg",
					style_id = "shrine_bg_left",
					pass_type = "texture",
					content_check_function = function (arg_115_0)
						return arg_115_0.extend_left
					end
				},
				{
					style_id = "shrine_bg_frame_left",
					pass_type = "texture_uv",
					content_id = "shrine_bg_frame_left",
					content_check_function = function (arg_116_0)
						return not arg_116_0.parent.extend_left
					end
				},
				{
					style_id = "shrine_bg_frame_right",
					pass_type = "texture_uv",
					content_id = "shrine_bg_frame_right",
					content_check_function = function (arg_117_0)
						return arg_117_0.parent.extend_left
					end
				},
				{
					texture_id = "icon",
					style_id = "round_icon",
					pass_type = "texture",
					content_check_function = function (arg_118_0)
						return arg_118_0.icon and not arg_118_0.is_rectangular_icon
					end
				},
				{
					texture_id = "round_icon_bg",
					style_id = "round_icon_bg",
					pass_type = "texture",
					content_check_function = function (arg_119_0)
						return arg_119_0.icon and not arg_119_0.is_rectangular_icon and false
					end
				},
				{
					texture_id = "icon",
					style_id = "rectangular_icon",
					pass_type = "texture",
					content_check_function = function (arg_120_0)
						return arg_120_0.icon and arg_120_0.is_rectangular_icon
					end
				},
				{
					style_id = "rectangular_bg",
					pass_type = "rect",
					content_check_function = function (arg_121_0)
						return arg_121_0.icon and not arg_121_0.is_rectangular_icon
					end
				},
				{
					texture_id = "rectangular_icon_bg",
					style_id = "rectangular_icon_bg",
					pass_type = "texture",
					content_check_function = function (arg_122_0)
						return true
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_123_0)
						return not arg_123_0.extend_left
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_124_0)
						return not arg_124_0.extend_left
					end
				},
				{
					style_id = "rarity_text",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function (arg_125_0)
						return not arg_125_0.extend_left
					end
				},
				{
					style_id = "rarity_text_shadow",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function (arg_126_0)
						return not arg_126_0.extend_left
					end
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (arg_127_0)
						return not arg_127_0.extend_left
					end
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (arg_128_0)
						return not arg_128_0.extend_left
					end
				},
				{
					style_id = "title_text_left",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_129_0)
						return arg_129_0.extend_left
					end
				},
				{
					style_id = "title_text_shadow_left",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_130_0)
						return arg_130_0.extend_left
					end
				},
				{
					style_id = "rarity_text_left",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function (arg_131_0)
						return arg_131_0.extend_left
					end
				},
				{
					style_id = "rarity_text_shadow_left",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function (arg_132_0)
						return arg_132_0.extend_left
					end
				},
				{
					style_id = "description_text_left",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (arg_133_0)
						return arg_133_0.extend_left
					end
				},
				{
					style_id = "description_text_shadow_left",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (arg_134_0)
						return arg_134_0.extend_left
					end
				},
				{
					style_id = "set_progression",
					pass_type = "text",
					text_id = "set_progression",
					content_check_function = function (arg_135_0)
						return arg_135_0.is_part_of_set and not arg_135_0.extend_left
					end
				},
				{
					style_id = "set_progression_left",
					pass_type = "text",
					text_id = "set_progression",
					content_check_function = function (arg_136_0)
						return arg_136_0.is_part_of_set and arg_136_0.extend_left
					end
				},
				{
					style_id = "remove_tooltip_left",
					pass_type = "text",
					text_id = "remove_tooltip",
					content_check_function = function (arg_137_0)
						return not arg_137_0.locked and arg_137_0.extend_left and arg_113_3
					end,
					content_change_function = function (arg_138_0, arg_138_1, arg_138_2, arg_138_3)
						local var_138_0 = Localize(arg_138_0.remove_tooltip_key)
						local var_138_1 = arg_138_0.input_service_name
						local var_138_2 = "$KEY;%s__%s:"
						local var_138_3 = arg_138_0.mouse_action
						local var_138_4 = arg_138_0.gamepad_action
						local var_138_5 = Managers.input:is_device_active("gamepad") and var_138_4 or var_138_3
						local var_138_6 = string.format(var_138_2, var_138_1, var_138_5)

						arg_138_0.remove_tooltip = string.format(var_138_0, var_138_6)
					end
				},
				{
					style_id = "remove_tooltip",
					pass_type = "text",
					text_id = "remove_tooltip",
					content_check_function = function (arg_139_0)
						return not arg_139_0.locked and not arg_139_0.extend_left and arg_113_3
					end,
					content_change_function = function (arg_140_0, arg_140_1, arg_140_2, arg_140_3)
						local var_140_0 = Localize(arg_140_0.remove_tooltip_key)
						local var_140_1 = arg_140_0.input_service_name
						local var_140_2 = "$KEY;%s__%s:"
						local var_140_3 = arg_140_0.mouse_action
						local var_140_4 = arg_140_0.gamepad_action
						local var_140_5 = Managers.input:is_device_active("gamepad") and var_140_4 or var_140_3
						local var_140_6 = string.format(var_140_2, var_140_1, var_140_5)

						arg_140_0.remove_tooltip = string.format(var_140_0, var_140_6)
					end
				},
				{
					style_id = "locked_left",
					pass_type = "text",
					text_id = "locked_text_id",
					content_check_function = function (arg_141_0)
						return arg_141_0.locked and arg_141_0.extend_left and arg_113_3
					end
				},
				{
					style_id = "locked_left_shadow",
					pass_type = "text",
					text_id = "locked_text_id",
					content_check_function = function (arg_142_0)
						return arg_142_0.locked and arg_142_0.extend_left and arg_113_3
					end
				},
				{
					style_id = "locked",
					pass_type = "text",
					text_id = "locked_text_id",
					content_check_function = function (arg_143_0)
						return arg_143_0.locked and not arg_143_0.extend_left and arg_113_3
					end
				},
				{
					style_id = "locked_shadow",
					pass_type = "text",
					text_id = "locked_text_id",
					content_check_function = function (arg_144_0)
						return arg_144_0.locked and not arg_144_0.extend_left and arg_113_3
					end
				},
				{
					pass_type = "texture",
					style_id = "remove_frame",
					texture_id = "remove_frame",
					content_check_function = function (arg_145_0, arg_145_1)
						return arg_145_0.input_made and not arg_145_0.locked and arg_113_3
					end
				}
			}
		},
		content = {
			round_icon_bg = "button_round_bg",
			title_text = "header",
			remove_tooltip = "",
			rectangular_icon_bg = "button_frame_01",
			visible = false,
			input_service_name = "ingame_menu",
			shrine_bg = "shrine_blessing_bg_hover",
			locked = false,
			remove_frame = "deus_shop_square_gradient",
			is_rectangular_icon = false,
			remove_interaction_duration = 1,
			description_text = "description_text",
			set_progression = "%d/%d",
			extend_left = false,
			rarity_text = "rarity",
			remove_tooltip_key = "remove_boon_tooltip",
			mouse_action = "mouse_middle_press",
			locked_text_id = "party_locked",
			gamepad_action = "special_1",
			shrine_bg_frame_left = {
				texture_id = "shrine_blessing_frame",
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
			shrine_bg_frame_right = {
				texture_id = "shrine_blessing_frame",
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
			shrine_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					50,
					0,
					0
				},
				texture_size = {
					484,
					194
				}
			},
			shrine_bg_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-384,
					0,
					0
				},
				texture_size = {
					484,
					194
				}
			},
			shrine_bg_frame_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					arg_113_1[1],
					arg_113_1[2]
				},
				offset = {
					0,
					0,
					1
				}
			},
			shrine_bg_frame_right = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					arg_113_1[1],
					arg_113_1[2]
				},
				offset = {
					-384,
					0,
					1
				}
			},
			round_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					28,
					0,
					10
				},
				texture_size = {
					40,
					40
				},
				masked = var_113_0
			},
			rectangular_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					17,
					0,
					10
				},
				texture_size = {
					63,
					63
				},
				masked = var_113_0
			},
			rectangular_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					15,
					0,
					9
				},
				texture_size = {
					63,
					63
				}
			},
			round_icon_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					0,
					9
				},
				texture_size = {
					74,
					74
				}
			},
			rectangular_icon_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					0,
					9
				},
				texture_size = {
					75,
					75
				}
			},
			title_text = {
				font_type = "hell_shark_header",
				upper_case = true,
				localize = false,
				word_wrap = false,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				area_size = {
					250,
					arg_113_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					100,
					52,
					3
				}
			},
			rarity_text = {
				vertical_alignment = "top",
				font_size = 22,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-60,
					-30,
					3
				}
			},
			description_text = {
				word_wrap = true,
				font_type = "hell_shark",
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					320,
					75
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					100,
					-60,
					3
				}
			},
			title_text_shadow = {
				font_type = "hell_shark_header",
				upper_case = true,
				localize = false,
				word_wrap = false,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				area_size = {
					250,
					arg_113_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					102,
					50,
					2
				}
			},
			rarity_text_shadow = {
				vertical_alignment = "top",
				font_size = 22,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-58,
					-32,
					2
				}
			},
			description_text_shadow = {
				word_wrap = true,
				font_type = "hell_shark",
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					320,
					75
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					102,
					-62,
					2
				}
			},
			title_text_left = {
				font_type = "hell_shark_header",
				upper_case = true,
				localize = false,
				word_wrap = false,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				area_size = {
					250,
					arg_113_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					-320,
					52,
					3
				}
			},
			rarity_text_left = {
				vertical_alignment = "top",
				font_size = 22,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-480,
					-30,
					3
				}
			},
			description_text_left = {
				word_wrap = true,
				font_type = "hell_shark",
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					320,
					75
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-320,
					-60,
					3
				}
			},
			title_text_shadow_left = {
				font_type = "hell_shark_header",
				upper_case = true,
				localize = false,
				word_wrap = false,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				area_size = {
					250,
					arg_113_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-318,
					50,
					2
				}
			},
			rarity_text_shadow_left = {
				vertical_alignment = "top",
				font_size = 22,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-478,
					-32,
					2
				}
			},
			description_text_shadow_left = {
				word_wrap = true,
				font_type = "hell_shark",
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					320,
					75
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-318,
					-62,
					2
				}
			},
			set_progression = {
				word_wrap = false,
				upper_case = false,
				font_size = 20,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				progression_colors = {
					incomplete = Colors.get_color_table_with_alpha("font_default", 255),
					complete = Colors.get_color_table_with_alpha("lime_green", 255)
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-60,
					18,
					10
				}
			},
			set_progression_left = {
				word_wrap = false,
				upper_case = false,
				font_size = 20,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				progression_colors = {
					incomplete = Colors.get_color_table_with_alpha("font_default", 255),
					complete = Colors.get_color_table_with_alpha("lime_green", 255)
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-488,
					18,
					10
				}
			},
			remove_tooltip = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_type = "hell_shark_header",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "left",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					250,
					30
				},
				area_size = {
					250,
					30
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					100,
					18,
					1
				}
			},
			remove_tooltip_left = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_type = "hell_shark_header",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "left",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					250,
					30
				},
				area_size = {
					250,
					30
				},
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					-320,
					18,
					1
				}
			},
			locked = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_type = "hell_shark_header",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "left",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					250,
					30
				},
				area_size = {
					250,
					30
				},
				text_color = Colors.get_color_table_with_alpha("firebrick", 255),
				offset = {
					100,
					18,
					2
				}
			},
			locked_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_type = "hell_shark_header",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "left",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					250,
					30
				},
				area_size = {
					250,
					30
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					102,
					16,
					1
				}
			},
			locked_left = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_type = "hell_shark_header",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "left",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					250,
					30
				},
				area_size = {
					250,
					30
				},
				text_color = Colors.get_color_table_with_alpha("firebrick", 255),
				offset = {
					-320,
					18,
					2
				}
			},
			locked_left_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_type = "hell_shark_header",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "left",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					250,
					30
				},
				area_size = {
					250,
					30
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-318,
					16,
					1
				}
			},
			remove_frame = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					9,
					0,
					11
				},
				texture_size = {
					80,
					80
				}
			}
		},
		offset = {
			-15,
			-65,
			50
		},
		scenegraph_id = arg_113_0
	}
end
