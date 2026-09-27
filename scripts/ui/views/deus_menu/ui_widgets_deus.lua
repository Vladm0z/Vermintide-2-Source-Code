-- chunkname: @scripts/ui/views/deus_menu/ui_widgets_deus.lua

local UIWidgets = UIWidgets

UIWidgets = UIWidgets or {}
UIWidgets = UIWidgets

local tbl = {
	92,
	8
}
local tbl_2 = {
	-(tbl[1] / 2),
	-25,
	0
}
local tbl_3 = {
	-15,
	-70
}

local function fn(arg_1_0)
	-- function 1
	if not arg_1_0 then
		return 255
	end

	return 195 + 60 * math.sin(5 * Managers.time:time("ui"))
end

UIWidgets.create_deus_player_status_portrait = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
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
					content_check_function = function (self)
						-- function 3
						return self.is_host
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
					content_change_function = function (self, arg_4_1)
						-- function 4
						local bar_value = self.bar_value

						arg_4_1.size[1] = tbl[1] * bar_value
					end,
					retained_mode = arg_2_3
				},
				{
					pass_type = "texture",
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					retained_mode = arg_2_3,
					content_check_function = function (self)
						-- function 5
						return self.display_portrait_icon
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
					content_check_function = function (self)
						-- function 6
						return self.connecting
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "ammo_indicator",
					retained_mode = arg_2_3,
					content_check_function = function (self)
						-- function 7
						local ammo_percentage = self.ammo_percentage

						return not ammo_percentage and not (ammo_percentage > 0) or ammo_percentage <= 0.33
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "ammo_indicator_empty",
					retained_mode = arg_2_3,
					content_check_function = function (self)
						-- function 8
						local ammo_percentage = self.ammo_percentage

						return not ammo_percentage and ammo_percentage <= 0
					end
				},
				{
					pass_type = "texture",
					style_id = "healthkit_slot",
					texture_id = "healthkit_slot",
					retained_mode = arg_2_3,
					content_check_function = function (self)
						-- function 9
						return self.healthkit_slot
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
					content_check_function = function (self)
						-- function 10
						return self.potion_slot
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
					content_check_function = function (self)
						-- function 11
						return self.grenade_slot
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
					content_check_function = function (self)
						-- function 12
						local token_icon = self.token_icon

						token_icon = not token_icon and self.show_token_icon

						return token_icon
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
					tbl_2[1] + tbl[1] / 2 - 50,
					tbl_2[2] + tbl[2] / 2 - 6.5,
					tbl_2[3] + 15
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
					tbl_2[1] + tbl[1] / 2 - 50,
					tbl_2[2] + tbl[2] / 2 - 6.5 - 7,
					tbl_2[3] + 20
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
					tbl[1],
					tbl[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_2[1],
					tbl_2[2],
					tbl_2[3] + 18
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
					tbl_3[1] + -35,
					tbl_3[2] + 0,
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
					tbl_3[1] + -35,
					tbl_3[2] + 0,
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
					tbl_3[1] + -35 + 2.5,
					tbl_3[2] + 2,
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
					tbl_3[1] + 0,
					tbl_3[2] + 0,
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
					tbl_3[1] + 0,
					tbl_3[2] + 0,
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
					tbl_3[1] + 2.5,
					tbl_3[2] + 2,
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
					tbl_3[1] + 35,
					tbl_3[2] + 0,
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
					tbl_3[1] + 35,
					tbl_3[2] + 0,
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
					tbl_3[1] + 35 + 2.5,
					tbl_3[2] + 2,
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
	-- function 13
	local var_13_0 = arg_13_3
	local var_13_1 = arg_13_0
	local tbl = {
		element = {
			passes = {}
		},
		content = {},
		style = {}
	}
	local var_13_3 = UIPlayerPortraitFrameSettings[arg_13_1]
	local tbl_2 = {
		255,
		255,
		255,
		255
	}
	local flag = arg_13_4 or {
		0,
		0,
		0
	}

	tbl.content.frame_settings_name = arg_13_1

	for i, v in ipairs(var_13_3) do
		local str = "texture_" .. i
		local texture = v.texture

		texture = texture or "icons_placeholder"

		local var_13_8

		if not UIAtlasHelper.has_atlas_settings_by_texture_name(texture) then
			var_13_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(texture).size
		else
			var_13_8 = v.size
		end

		local flag_2

		flag_2 = not var_13_8 and table.clone(var_13_8) and {
			0,
			0
		}

		local tbl_3 = {}

		if not v.offset then
			tbl_3 = table.clone(v.offset)
			tbl_3[1] = flag[1] + (-(flag_2[1] / 2) + tbl_3[1])
			tbl_3[2] = flag[2] + 60 + tbl_3[2]

			local layer = v.layer

			layer = layer or 0
			tbl_3[3] = layer
		else
			tbl_3 = table.clone(flag)
			tbl_3[1] = -(flag_2[1] / 2) + tbl_3[1]
			tbl_3[2] = tbl_3[2]

			local layer_2 = v.layer

			layer_2 = layer_2 or 0
			tbl_3[3] = layer_2
		end

		tbl.element.passes[#tbl.element.passes + 1] = {
			pass_type = "texture",
			texture_id = str,
			style_id = str,
			retained_mode = var_13_0
		}
		tbl.content[str] = texture

		local style = tbl.style
		local tbl_4 = {}
		local color = v.color

		color = color or tbl_2
		tbl_4.color = color
		tbl_4.offset = tbl_3
		tbl_4.size = flag_2
		style[str] = tbl_4
	end

	local tbl_5 = {
		86,
		108
	}

	tbl_5[1] = tbl_5[1]
	tbl_5[2] = tbl_5[2]

	local tbl_6 = {
		0,
		8,
		0
	}

	tbl_6[1] = tbl_6[1]
	tbl_6[2] = tbl_6[2]
	tbl_6[3] = 15

	local str_2 = "level"

	tbl.element.passes[#tbl.element.passes + 1] = {
		pass_type = "text",
		text_id = str_2,
		style_id = str_2,
		retained_mode = var_13_0
	}
	tbl.content[str_2] = arg_13_2
	tbl.style[str_2] = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 12,
		horizontal_alignment = "center",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = tbl_6
	}
	tbl.scenegraph_id = var_13_1

	return tbl
end

UIWidgets.create_info_box = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	-- function 14
	local tbl = {
		0,
		130 - arg_14_2[2] / 2,
		0
	}
	local var_14_1 = UIFrameSettings[arg_14_3]
	local var_14_2 = var_14_1.texture_sizes.horizontal[2]
	local tbl_2 = {
		arg_14_2[1] + var_14_2 * 2,
		arg_14_2[2] + var_14_2 * 2
	}
	local tbl_3 = {
		tbl[1] - var_14_2,
		tbl[2] - var_14_2,
		1
	}
	local tbl_4 = {
		arg_14_2[1] + var_14_2 + 5,
		tbl[2] - var_14_2 - 5
	}
	local tbl_5 = {
		font_size = 36,
		dynamic_font_size = true,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			tbl_4[1],
			125,
			0
		},
		size = {
			400 - tbl_4[1],
			36
		}
	}
	local clone = table.clone(tbl_5)

	clone.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone.offset = {
		tbl_5.offset[1] + 2,
		tbl_5.offset[2] - 2,
		tbl_5.offset[3] - 1
	}

	local tbl_6 = {
		font_size = 20,
		dynamic_font_size = true,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			tbl_4[1],
			tbl[2],
			0
		},
		size = {
			400 - tbl_4[1],
			20
		}
	}
	local clone_2 = table.clone(tbl_6)

	clone_2.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_2.offset = {
		tbl_6.offset[1] + 2,
		tbl_6.offset[2] - 2,
		tbl_6.offset[3] - 1
	}

	local tbl_7 = {
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
			tbl_4[2]
		}
	}
	local clone_3 = table.clone(tbl_7)

	clone_3.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_3.offset = {
		tbl_7.offset[1] + 2,
		tbl_7.offset[2] - 2,
		tbl_7.offset[3] - 1
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 15
						return self.icon
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame",
					content_check_function = function (self)
						-- function 16
						return self.icon
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 17
						return self.title_text
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 18
						return self.title_text
					end
				},
				{
					style_id = "sub_title_text",
					pass_type = "text",
					text_id = "sub_title_text",
					content_check_function = function (self)
						-- function 19
						return self.sub_title_text
					end
				},
				{
					style_id = "sub_title_text_shadow",
					pass_type = "text",
					text_id = "sub_title_text",
					content_check_function = function (self)
						-- function 20
						return self.sub_title_text
					end
				},
				{
					style_id = "info_text",
					pass_type = "text",
					text_id = "info_text",
					content_check_function = function (self)
						-- function 21
						return self.info_text
					end
				},
				{
					style_id = "info_text_shadow",
					pass_type = "text",
					text_id = "info_text",
					content_check_function = function (self)
						-- function 22
						return self.info_text
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
				offset = tbl,
				texture_size = arg_14_2 or {
					20,
					20
				}
			},
			frame = {
				size = tbl_2,
				texture_size = var_14_1.texture_size,
				texture_sizes = var_14_1.texture_sizes,
				offset = tbl_3
			},
			title_text = tbl_5,
			title_text_shadow = clone,
			sub_title_text = tbl_6,
			sub_title_text_shadow = clone_2,
			info_text = tbl_7,
			info_text_shadow = clone_3
		},
		scenegraph_id = arg_14_0
	}
end

UIWidgets.create_framed_info_box = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9, arg_23_10)
	-- function 23
	arg_23_10 = arg_23_10 or {
		340,
		100
	}

	local var_23_0 = UIFrameSettings[arg_23_2]
	local var_23_1 = var_23_0.texture_sizes.horizontal[2]
	local tbl = {
		arg_23_10[1] + var_23_1 * 2,
		arg_23_10[2] + var_23_1 * 2
	}
	local tbl_2 = {
		-var_23_1,
		-var_23_1,
		1
	}
	local num = 12
	local tbl_3 = {
		arg_23_10[1],
		arg_23_6[1] + num * 2
	}
	local tbl_4 = {
		0,
		arg_23_10[2] + 2.5 - tbl_2[2],
		-2
	}
	local var_23_7 = UIFrameSettings[arg_23_1]
	local var_23_8 = var_23_7.texture_sizes.horizontal[2]
	local tbl_5 = {
		tbl_3[1] + var_23_8 * 2,
		tbl_3[2] + var_23_8 * 2
	}
	local tbl_6 = {
		-var_23_8,
		tbl_4[2] - var_23_8,
		1
	}
	local num_2 = 20
	local tbl_7 = {
		arg_23_10[1] - arg_23_6[1],
		num_2
	}
	local tbl_8 = {
		arg_23_10[1] / 2 - tbl_7[1] / 2,
		tbl_4[2] + tbl_3[2] + var_23_8 * 2,
		-2
	}
	local var_23_14 = UIFrameSettings[arg_23_3]
	local var_23_15

	if not var_23_14 then
		var_23_15 = var_23_14.texture_sizes.horizontal[2]

		if not var_23_15 then
			-- Nothing
		end
	end

	var_23_15 = 0

	::label_23_0::

	local tbl_9 = {
		tbl_7[1] + var_23_15 * 2,
		tbl_7[2] + var_23_15 * 2
	}
	local tbl_10 = {
		tbl_8[1] - var_23_15,
		tbl_8[2] - var_23_15,
		1
	}
	local tbl_11 = {
		num,
		tbl_4[2] + num,
		0
	}
	local var_23_19 = UIFrameSettings[arg_23_7]
	local var_23_20 = var_23_19.texture_sizes.horizontal[2]
	local tbl_12 = {
		arg_23_6[1] + var_23_20 * 2,
		arg_23_6[2] + var_23_20 * 2
	}
	local tbl_13 = {
		tbl_11[1] - var_23_20,
		tbl_11[2] - var_23_20,
		1
	}
	local tbl_14 = {
		tbl[1],
		tbl[2] + tbl_5[2]
	}

	if not arg_23_3 then
		tbl_14[2] = tbl_14[2] + tbl_9[2]
	end

	local tbl_15 = {
		upper_case = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = num_2,
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			tbl_8[1],
			tbl_8[2] + tbl_7[2] / 2 - num_2 / 2,
			0
		},
		size = tbl_7
	}
	local clone = table.clone(tbl_15)

	clone.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone.offset = {
		tbl_15.offset[1] + 2,
		tbl_15.offset[2] - 2,
		tbl_15.offset[3] - 1
	}

	local num_3 = 5
	local num_4 = 36
	local tbl_16 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = num_4,
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			arg_23_6[1] + num + var_23_20 + num_3,
			tbl_4[2] + tbl_3[2] / 2 - num_4 / 2,
			0
		},
		size = {
			tbl_3[1] - arg_23_6[1] - num * 2 - num_3 * 2,
			num_4
		}
	}
	local clone_2 = table.clone(tbl_16)

	clone_2.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_2.offset = {
		tbl_16.offset[1] + 2,
		tbl_16.offset[2] - 2,
		tbl_16.offset[3] - 1
	}

	local tbl_17 = {
		15,
		5
	}
	local tbl_18 = {
		vertical_alignment = "top",
		word_wrap = true,
		dynamic_font_size_word_wrap = true,
		font_size = 20,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			tbl_17[1],
			tbl_17[2],
			0
		},
		size = {
			arg_23_10[1] - tbl_17[1] * 2,
			arg_23_10[2] - tbl_17[2] * 2
		}
	}
	local clone_3 = table.clone(tbl_18)

	clone_3.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_3.offset = {
		tbl_18.offset[1] + 2,
		tbl_18.offset[2] - 2,
		tbl_18.offset[3] - 1
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "top_frame",
					texture_id = "top_frame",
					content_check_function = function (self)
						-- function 24
						return self.top_text
					end
				},
				{
					style_id = "top_frame_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 25
						return self.top_text
					end
				},
				{
					style_id = "top_text",
					pass_type = "text",
					text_id = "top_text",
					content_check_function = function (self)
						-- function 26
						return self.top_text
					end
				},
				{
					style_id = "top_text_shadow",
					pass_type = "text",
					text_id = "top_text",
					content_check_function = function (self)
						-- function 27
						return self.top_text
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "title_frame",
					texture_id = "title_frame",
					content_check_function = function (self)
						-- function 28
						return self.icon
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
					content_check_function = function (self)
						-- function 29
						return self.icon
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "icon_frame",
					texture_id = "icon_frame",
					content_check_function = function (self)
						-- function 30
						return self.icon
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 31
						return self.title_text
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 32
						return self.title_text
					end
				},
				{
					pass_type = "texture",
					style_id = "title_glow",
					texture_id = "title_glow",
					content_check_function = function (self)
						-- function 33
						return self.title_text
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "bottom_frame",
					texture_id = "bottom_frame",
					content_check_function = function (self)
						-- function 34
						return self.info_text
					end
				},
				{
					style_id = "info_text",
					pass_type = "text",
					text_id = "info_text",
					content_check_function = function (self)
						-- function 35
						return self.info_text
					end
				},
				{
					style_id = "info_text_shadow",
					pass_type = "text",
					text_id = "info_text",
					content_check_function = function (self)
						-- function 36
						return self.info_text
					end
				},
				{
					pass_type = "tiled_texture",
					style_id = "bottom_background",
					texture_id = "bottom_background",
					content_check_function = function (self)
						-- function 37
						return self.info_text
					end
				}
			}
		},
		content = {
			bottom_background = "item_tooltip_background",
			title_glow = "tooltip_power_level_header_glow",
			top_frame = not var_23_14 and var_23_14.texture,
			title_frame = var_23_7.texture,
			bottom_frame = var_23_0.texture,
			icon = arg_23_5,
			icon_frame = var_23_19.texture,
			title_text = arg_23_8,
			info_text = arg_23_9,
			top_text = arg_23_4,
			total_widget_size = tbl_14
		},
		style = {
			top_frame = {
				size = tbl_9,
				texture_size = not var_23_14 and var_23_14.texture_size,
				texture_sizes = not var_23_14 and var_23_14.texture_sizes,
				offset = tbl_10
			},
			top_frame_rect = {
				color = {
					255,
					20,
					20,
					20
				},
				offset = tbl_8,
				size = tbl_7
			},
			top_text = tbl_15,
			top_text_shadow = clone,
			title_frame = {
				size = tbl_5,
				texture_size = var_23_7.texture_size,
				texture_sizes = var_23_7.texture_sizes,
				offset = tbl_6
			},
			title_frame_rect = {
				color = Colors.get_table("black"),
				offset = tbl_4,
				size = tbl_3
			},
			icon = {
				offset = tbl_11,
				texture_size = arg_23_6 or {
					20,
					20
				}
			},
			icon_frame = {
				size = tbl_12,
				texture_size = var_23_19.texture_size,
				texture_sizes = var_23_19.texture_sizes,
				offset = tbl_13
			},
			bottom_frame = {
				size = tbl,
				texture_size = var_23_0.texture_size,
				texture_sizes = var_23_0.texture_sizes,
				offset = tbl_2
			},
			title_text = tbl_16,
			title_text_shadow = clone_2,
			title_glow = {
				offset = {
					tbl_4[1],
					tbl_4[2],
					-1
				},
				size = arg_23_10,
				texture_size = {
					tbl_3[1],
					tbl_3[2] / 2
				}
			},
			info_text = tbl_18,
			info_text_shadow = clone_3,
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
	-- function 38
	local tbl = {
		arg_38_10,
		arg_38_5[2]
	}
	local tbl_2 = {
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
	local tbl_3 = {
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
	local var_38_3 = tbl_3.texture_size[2]
	local num = 10
	local num_2 = 20
	local num_3 = 2
	local num_4 = num_2 * 2 + num_3
	local tbl_4 = {
		tbl_3.texture_size[1] + num,
		var_38_3 / 2 - num_4 / 2,
		0
	}
	local tbl_5 = {
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = num_2
	}
	local flag

	flag = not arg_38_13 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		tbl_4[1],
		tbl_4[2],
		0
	}
	tbl_5.size = {
		tbl[1] - tbl_4[1],
		num_2
	}

	local clone = table.clone(tbl_5)

	clone.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone.offset = {
		tbl_5.offset[1] + 2,
		tbl_5.offset[2] - 2,
		tbl_5.offset[3] - 1
	}

	local tbl_6 = {
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = num_2
	}
	local flag_2

	flag_2 = not arg_38_13 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_2
	tbl_6.text_color = arg_38_9 or Colors.get_color_table_with_alpha("font_default", 255)
	tbl_6.offset = {
		tbl_4[1],
		tbl_4[2] + tbl_5.size[2] + num_3,
		0
	}
	tbl_6.size = {
		tbl[1] - tbl_4[1],
		num_2
	}

	local clone_2 = table.clone(tbl_6)

	clone_2.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_2.offset = {
		tbl_6.offset[1] + 2,
		tbl_6.offset[2] - 2,
		tbl_6.offset[3] - 1
	}

	local tbl_7 = {
		{
			style_id = "icon_hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (self, arg_39_1)
				-- function 39
				return not self.hotspot.is_hover
			end
		},
		{
			style_id = "icon_bg",
			pass_type = "rect",
			content_check_function = function (self)
				-- function 40
				return not not self.is_rectangular_icon or not arg_38_13
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_bg",
			texture_id = "rect_masked",
			content_check_function = function (self)
				-- function 41
				return not not self.is_rectangular_icon or arg_38_13
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
			content_check_function = function (self)
				-- function 42
				return not self.hide_text
			end
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (self)
				-- function 43
				return not self.hide_text
			end
		},
		{
			style_id = "sub_text",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (self)
				-- function 44
				return not self.hide_text
			end
		},
		{
			style_id = "sub_text_shadow",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (self)
				-- function 45
				return not self.hide_text
			end
		}
	}
	local tbl_8 = {
		rect_masked = "rect_masked",
		hotspot = {},
		icon = arg_38_1,
		icon_background = arg_38_4,
		title_text = arg_38_8,
		sub_text = arg_38_7,
		total_widget_size = tbl,
		is_rectangular_icon = arg_38_11,
		hide_text = arg_38_12
	}
	local tbl_9 = {
		icon = tbl_2,
		icon_hotspot = arg_38_14 or tbl_2,
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
		icon_background = tbl_3,
		title_text = tbl_6,
		title_text_shadow = clone_2,
		sub_text = tbl_5,
		sub_text_shadow = clone
	}

	return {
		element = {
			passes = tbl_7
		},
		content = tbl_8,
		style = tbl_9,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_38_0
	}
end

UIWidgets.create_start_game_difficulty_stepper = function (arg_46_0, arg_46_1, arg_46_2)
	-- function 46
	local tbl = {
		-12.5,
		0,
		0
	}
	local str = "morris_arrow_highlight"

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
					content_check_function = function (self)
						-- function 47
						return self.parent.left_arrow_hotspot.is_hover
					end
				},
				{
					style_id = "left_arrow_gamepad_highlight",
					pass_type = "texture_uv",
					content_id = "left_arrow_gamepad_highlight",
					content_check_function = function (self)
						-- function 48
						return self.parent.left_arrow_pressed
					end
				},
				{
					style_id = "left_arrow_clicked",
					pass_type = "texture_uv",
					content_id = "left_arrow_clicked",
					content_check_function = function (self)
						-- function 49
						return self.parent.left_arrow_hotspot.is_clicked == 0
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
					content_check_function = function (self)
						-- function 50
						return self.right_arrow_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "right_arrow_gamepad_highlight",
					texture_id = "right_arrow_gamepad_highlight",
					content_check_function = function (self)
						-- function 51
						return self.right_arrow_pressed
					end
				},
				{
					pass_type = "texture",
					style_id = "right_arrow_clicked",
					texture_id = "right_arrow_clicked",
					content_check_function = function (self)
						-- function 52
						return self.right_arrow_hotspot.is_clicked == 0
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
					content_check_function = function (self)
						-- function 53
						local is_hover = self.right_arrow_hotspot.is_hover

						if not is_hover then
							is_hover = self.left_arrow_hotspot.is_hover
							is_hover = is_hover or not not Managers.input:is_device_active("mouse") or self.is_selected
						end

						return is_hover
					end,
					content_change_function = function (arg_54_0, arg_54_1)
						-- function 54
						arg_54_1.color[1] = fn(not Managers.input:is_device_active("mouse"))
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
				texture_id = str
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
				texture_id = str
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
				texture_id = str
			},
			right_arrow_hover = str,
			right_arrow_hotspot = {},
			right_arrow_gamepad_highlight = str,
			right_arrow_clicked = str,
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
					tbl[1],
					tbl[2],
					tbl[3] + 5
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
					tbl[1],
					tbl[2],
					tbl[3] + 6
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
					tbl[1] + 125,
					tbl[2] + 35,
					tbl[3] + 6
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
					tbl[1] + 125,
					tbl[2] + 35,
					tbl[3] + 6
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
					tbl[1] + 125,
					tbl[2] + 35,
					tbl[3] + 6
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
					tbl[1] + 125,
					tbl[2] + 35,
					tbl[3] + 7
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
					tbl[1] + 125,
					tbl[2] + 35,
					tbl[3] + 7
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
					tbl[1] + 475,
					tbl[2] + 35,
					tbl[3] + 6
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
					tbl[1] + 475,
					tbl[2] + 35,
					tbl[3] + 6
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
					tbl[1] + 475,
					tbl[2] + 35,
					tbl[3] + 6
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
					tbl[1] + 475,
					tbl[2] + 35,
					tbl[3] + 7
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
					tbl[1] + 475,
					tbl[2] + 35,
					tbl[3] + 7
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
					tbl[1] + 12.5,
					tbl[2] + 17.5,
					tbl[3] + 6
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
					tbl[1] + 180,
					tbl[2] + 137.5,
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
					tbl[1] + 175,
					tbl[2] + 45,
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
					tbl[1] + 175,
					tbl[2] + 45,
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
					tbl[1] + 175,
					tbl[2] + 45,
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
					tbl[1] + 175,
					tbl[2] + 45,
					7
				},
				size = {
					305,
					52
				}
			}
		},
		scenegraph_id = arg_46_0,
		offset = tbl
	}
end

UIWidgets.create_deus_panel_with_outer_frame = function (arg_55_0, arg_55_1)
	-- function 55
	local border_tiled = UIFrameSettings.border_tiled
	local corner = border_tiled.texture_sizes.corner
	local tbl = {
		corner[1] + 1,
		corner[2] + 1
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
			border = border_tiled.texture
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
				texture_size = border_tiled.texture_size,
				texture_sizes = border_tiled.texture_sizes,
				size = {
					arg_55_1[1] + 2 * tbl[1],
					arg_55_1[2] + 2 * tbl[2]
				},
				offset = {
					-tbl[1],
					-tbl[2],
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
	-- function 56
	local str = "background_tiled_morris"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local size = get_atlas_settings_by_texture_name.size
	local menu_frame_05_morris = UIFrameSettings.menu_frame_05_morris
	local str_2 = "button_glass_02"
	local size_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2).size
	local var_56_6 = menu_frame_05_morris.texture_sizes.horizontal[2]
	local str_3 = "button_detail_01_morris"
	local size_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size
	local tbl = {
		45,
		4
	}
	local str_4 = "button_detail_01_hover_morris"
	local size_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_4).size

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
					content_check_function = function (self)
						-- function 57
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 58
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 59
						return not self.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 60
						return not self.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_left_disabled",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 61
						return self.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right_disabled",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 62
						return self.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_glow_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (self)
						-- function 63
						return not self.parent.button_hotspot.disable_button
					end,
					content_change_function = function (self, arg_64_1)
						-- function 64
						arg_64_1.color[1] = fn(self.parent.is_selected)
					end
				},
				{
					style_id = "side_detail_glow_right",
					pass_type = "texture_uv",
					content_id = "side_detail_glow",
					content_check_function = function (self)
						-- function 65
						return not self.parent.button_hotspot.disable_button
					end,
					content_change_function = function (self, arg_66_1)
						-- function 66
						arg_66_1.color[1] = fn(self.parent.is_selected)
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 67
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 68
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 69
						local button_hotspot = self.button_hotspot
						local is_hover

						if not button_hotspot.disable_button then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								is_hover = self.is_selected
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
					texture_id = "effect",
					style_id = "effect_active",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 70
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disable_button or not button_hotspot.is_hover
					end
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 71
						local button_hotspot = self.button_hotspot
						local is_hover

						if not button_hotspot.disable_button then
							is_hover = button_hotspot.is_hover

							if not is_hover then
								is_hover = self.is_selected
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
					texture_id = "hover_glow",
					style_id = "hover_glow_active",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 72
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disable_button or not button_hotspot.is_hover
					end
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 73
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.disable_button or button_hotspot.is_hover
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
				texture_id = str_4
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
				texture_id = str_3
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
			glass = str_2,
			button_hotspot = {},
			title_text = arg_56_2 or "n/a",
			frame = menu_frame_05_morris.texture,
			disable_with_gamepad = arg_56_4,
			background = {
				uvs = {
					{
						0,
						1 - arg_56_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_56_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = str
			},
			background = str
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
					size[1],
					size[2]
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
				texture_size = menu_frame_05_morris.texture_size,
				texture_sizes = menu_frame_05_morris.texture_sizes,
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
					menu_frame_05_morris.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_56_1[1],
					math.min(60, arg_56_1[2] - menu_frame_05_morris.texture_sizes.horizontal[2] * 2)
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
					menu_frame_05_morris.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_56_1[1],
					math.min(60, arg_56_1[2] - menu_frame_05_morris.texture_sizes.horizontal[2] * 2)
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
					arg_56_1[2] - size_2[2] - var_56_6,
					6
				},
				size = {
					arg_56_1[1],
					size_2[2]
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
					size_2[2]
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
					-tbl[1],
					(arg_56_1[2] - size_3[2]) / 2 + tbl[2],
					9
				},
				size = {
					size_3[1],
					size_3[2]
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
					arg_56_1[1] - size_3[1] + tbl[1],
					(arg_56_1[2] - size_3[2]) / 2 + tbl[2],
					9
				},
				size = {
					size_3[1],
					size_3[2]
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
					-tbl[1],
					(arg_56_1[2] - size_3[2]) / 2 + tbl[2],
					9
				},
				size = {
					size_3[1],
					size_3[2]
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
					arg_56_1[1] - size_3[1] + tbl[1],
					(arg_56_1[2] - size_3[2]) / 2 + tbl[2],
					9
				},
				size = {
					size_3[1],
					size_3[2]
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
					-tbl[1],
					(arg_56_1[2] - size_4[2]) / 2 + tbl[2],
					10
				},
				size = {
					size_4[1],
					size_4[2]
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
					arg_56_1[1] - size_4[1] + tbl[1],
					(arg_56_1[2] - size_4[2]) / 2 + tbl[2],
					10
				},
				size = {
					size_4[1],
					size_4[2]
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
	-- function 74
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local str_2 = "menu_frame_01_morris"
	local var_74_3 = UIFrameSettings[str_2]
	local var_74_4 = var_74_3.texture_sizes.corner[1]
	local var_74_5 = var_74_3.texture_sizes.horizontal[2]
	local str_3 = "button_detail_02_morris"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size
	local str_4 = "button_detail_02_hover_morris"
	local num = 30
	local num_2 = 5

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
					content_check_function = function (self)
						-- function 75
						return self.draw_frame
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
					content_check_function = function (self)
						-- function 76
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 77
						local button_hotspot = self.parent.button_hotspot

						return not not button_hotspot.disable_button or button_hotspot.is_hover
					end
				},
				{
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (self)
						-- function 78
						local button_hotspot = self.parent.button_hotspot

						return not not button_hotspot.disable_button or button_hotspot.is_hover
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 79
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 80
						return self.button_hotspot.disable_button
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
				texture_id = str_3
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
				texture_id = str_4
			},
			button_hotspot = {},
			title_text = arg_74_2 or "n/a",
			frame = var_74_3.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_74_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_74_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = str
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
					-num,
					arg_74_1[2] / 2 - size[2] / 2 + num_2,
					9
				},
				size = {
					size[1],
					size[2]
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
					arg_74_1[1] - size[1] + num,
					arg_74_1[2] / 2 - size[2] / 2 + num_2,
					9
				},
				size = {
					size[1],
					size[2]
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
	-- function 81
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
	-- function 82
	local flag

	flag = not arg_82_4 and 0 and 255

	local num

	if not arg_82_4 then
		num = arg_82_1[2] / 2

		if not num then
			-- Nothing
		end
	end

	num = arg_82_1[2]

	do
		local num_2
	end

	::label_82_0::

	if not arg_82_4 then
		num_2 = arg_82_1[2] / 2

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = 0

	::label_82_1::

	local tbl = {
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
					content_check_function = function (self)
						-- function 83
						local show_note = self.show_note

						show_note = not show_note and not arg_82_5

						return show_note
					end
				},
				{
					style_id = "press_key_text",
					pass_type = "text",
					text_id = "press_key_text",
					content_check_function = function (self)
						-- function 84
						return not not self.show_note or not arg_82_5
					end
				}
			}
		}
	}
	local tbl_2 = {
		box_left_detail = "morris_header_end",
		header_box_title_frame = "morris_header_frame",
		is_showing_info = false,
		fade_out_done = false,
		background = "morris_header_background",
		show_note = false,
		box_right_detail = "morris_header_end",
		info_hotspot = {},
		header_text = arg_82_2 or Localize("not_assigned"),
		game_mode_text = arg_82_3 or Localize("not_assigned")
	}
	local var_82_5 = Localize("expedition_info_note")

	var_82_5 = var_82_5 or Localize("not_assigned")
	tbl_2.note_text = var_82_5

	local format = string.format(Localize("for_more_info"), "$KEY;start_game_view__show_information:")

	format = format or Localize("not_assigned")
	tbl_2.press_key_text = format
	tbl_2.disable_note = arg_82_5
	tbl.content = tbl_2

	local tbl_3 = {
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
				num_2,
				0
			},
			size = {
				arg_82_1[1],
				num
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
				flag,
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
		}
	}
	local tbl_4 = {
		word_wrap = true,
		upper_case = false,
		localize = false,
		dynamic_font_size_word_wrap = true,
		font_size = 28,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = "hell_shark_header",
		text_color = Colors.get_color_table_with_alpha("font_default", 255)
	}
	local tbl_5 = {
		25,
		nil,
		2
	}
	local num_3

	if not arg_82_4 then
		num_3 = arg_82_1[2] / 2 - 20

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = arg_82_1[2] / 2 - 40

	::label_82_2::

	tbl_5[2] = num_3
	tbl_4.offset = tbl_5

	local tbl_6 = {
		arg_82_1[1] - 50
	}
	local num_4

	if not arg_82_4 then
		num_4 = arg_82_1[2] / 2

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = arg_82_1[2] / 2 + 10

	::label_82_3::

	tbl_6[2] = num_4
	tbl_4.size = tbl_6
	tbl_3.game_mode_text = tbl_4
	tbl_3.note_text = {
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
	}
	tbl_3.press_key_text = {
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
	tbl.style = tbl_3
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_82_0

	return tbl
end

UIWidgets.create_expedition_widget_func = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4, arg_85_5)
	-- function 85
	local flag = arg_85_4 or {
		width = 72,
		spacing_x = 40
	}
	local tbl = {
		180,
		180
	}
	local flag_2 = arg_85_5 or 1
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (self)
				-- function 86
				return not self.parent.locked
			end
		},
		{
			style_id = "level_icon",
			pass_type = "level_tooltip",
			level_id = "level_data",
			content_check_function = function (self)
				-- function 87
				local is_hover = self.button_hotspot.is_hover

				is_hover = is_hover or self.gamepad_selected

				return is_hover
			end
		},
		{
			style_id = "icon_glow",
			texture_id = "icon_glow",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 88
				local is_device_active = Managers.input:is_device_active("mouse")
				local gamepad_selected

				if not self.button_hotspot.is_hover then
					gamepad_selected = self.gamepad_selected

					if not gamepad_selected then
						-- Nothing
					end

					if not is_device_active then
						-- Nothing
					end
				end

				gamepad_selected = not self.button_hotspot.is_selected

				if false then
					::label_88_0::

					gamepad_selected = false
				end

				if false then
					gamepad_selected = true
				end

				::label_88_1::

				return gamepad_selected
			end,
			content_change_function = function (self, arg_89_1)
				-- function 89
				arg_89_1.color[1] = fn(self.gamepad_selected)
			end
		},
		{
			pass_type = "texture",
			style_id = "level_icon",
			texture_id = "level_icon",
			content_check_function = function (self, arg_90_1)
				-- function 90
				return not self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "level_icon_locked",
			texture_id = "level_icon",
			content_check_function = function (self)
				-- function 91
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (self)
				-- function 92
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_fade",
			texture_id = "lock_fade",
			content_check_function = function (self)
				-- function 93
				return self.locked
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "path",
			texture_id = "path",
			content_check_function = function (self)
				-- function 94
				local draw_path = self.draw_path

				draw_path = not draw_path and not self.draw_path_fill

				return draw_path
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "path_glow",
			texture_id = "path_glow",
			content_check_function = function (self)
				-- function 95
				local draw_path = self.draw_path

				if not draw_path then
					draw_path = self.draw_path_fill
					draw_path = not draw_path and not self.locked
				end

				return draw_path
			end
		},
		{
			pass_type = "texture",
			style_id = "theme_icon",
			texture_id = "theme_icon",
			content_check_function = function (self)
				-- function 96
				return self.theme_icon ~= nil
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "level_icon_mask",
			texture_id = "level_icon_mask",
			content_check_function = function (arg_97_0)
				-- function 97
				return true
			end
		},
		{
			pass_type = "texture",
			style_id = "level_icon_frame",
			texture_id = "level_icon_frame",
			content_check_function = function (self, arg_98_1)
				-- function 98
				return not self.locked
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
			content_check_function = function (self, arg_99_1)
				-- function 99
				if not Managers.input:is_device_active("gamepad") then
					return self.gamepad_selected
				else
					return self.button_hotspot.is_selected
				end
			end
		},
		{
			style_id = "journey_name",
			pass_type = "text",
			text_id = "journey_name_text",
			content_check_function = function (self, arg_100_1)
				-- function 100
				if not Managers.input:is_device_active("gamepad") then
					return self.gamepad_selected
				else
					return self.button_hotspot.is_selected
				end
			end
		}
	}
	local tbl_4 = {
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
	local tbl_5 = {
		hotspot = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = {
				150 * flag_2,
				150 * flag_2
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
				flag.spacing_x,
				10
			},
			offset = {
				(flag.width + flag.spacing_x) * 0.5,
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
				flag.spacing_x,
				30
			},
			offset = {
				(flag.width + flag.spacing_x) * 0.5,
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
				160 * flag_2,
				160 * flag_2
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
				180 * flag_2,
				180 * flag_2
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
				90 * flag_2,
				90 * flag_2
			},
			angle = math.degrees_to_radians(45),
			pivot = {
				90 * flag_2 * 0.5,
				90 * flag_2 * 0.5
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
				160 * flag_2,
				160 * flag_2
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
				160 * flag_2,
				160 * flag_2
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
				168 * flag_2,
				168 * flag_2
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
				240 * flag_2 * 0.9,
				330 * flag_2 * 0.9
			},
			offset = {
				0,
				45 * flag_2,
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
				187 * flag_2 + 6,
				170 * flag_2 + 6
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
				80 * flag_2,
				80 * flag_2
			},
			offset = {
				0,
				80 * flag_2,
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
				40 * flag_2,
				40 * flag_2
			},
			offset = {
				0,
				65 * flag_2,
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
				294 * flag_2,
				100 * flag_2
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

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_85_0

	return tbl_2
end

UIWidgets.create_start_game_deus_difficulty_info_box = function (arg_101_0, arg_101_1)
	-- function 101
	local border_tiled = UIFrameSettings.border_tiled
	local corner = border_tiled.texture_sizes.corner
	local tbl = {
		corner[1] + 1,
		corner[2] + 1
	}

	return {
		element = {
			passes = {
				{
					style_id = "background",
					texture_id = "background",
					pass_type = "tiled_texture",
					content_change_function = function (self, arg_102_1)
						-- function 102
						local tbl = {
							0 + self.resize_offset[1],
							0 + self.resize_offset[2],
							1
						}

						if not self.should_resize then
							arg_102_1.texture_size = self.resize_size
							arg_102_1.offset = tbl
						end
					end
				},
				{
					style_id = "border",
					texture_id = "border",
					pass_type = "texture_frame",
					content_change_function = function (self, arg_103_1)
						-- function 103
						local tbl_2 = {
							-tbl[1] + self.resize_offset[1],
							-tbl[2] + self.resize_offset[2],
							2
						}
						local resize_size = self.resize_size

						if not self.should_resize then
							arg_103_1.size = {
								resize_size[1] + 2 * tbl[1],
								resize_size[2] + 2 * tbl[2]
							}
							arg_103_1.offset = tbl_2
						end
					end
				},
				{
					style_id = "difficulty_description",
					pass_type = "text",
					text_id = "difficulty_description",
					content_change_function = function (self, arg_104_1)
						-- function 104
						local tbl = {
							25 + self.resize_offset[1],
							160 - self.resize_offset[2],
							2
						}

						if not self.should_resize then
							arg_104_1.offset = tbl
							arg_104_1.offset = tbl
						end
					end
				},
				{
					style_id = "highest_obtainable_level",
					pass_type = "text",
					text_id = "highest_obtainable_level",
					content_change_function = function (self, arg_105_1)
						-- function 105
						local tbl = {
							25 + self.resize_offset[1],
							140 - self.difficulty_description_text_size - self.resize_offset[2],
							2
						}

						if not self.should_resize then
							arg_105_1.offset = tbl
						end
					end
				},
				{
					style_id = "difficulty_separator",
					texture_id = "difficulty_separator",
					pass_type = "texture",
					content_change_function = function (self, arg_106_1)
						-- function 106
						local tbl = {
							arg_101_1[1] / 4 + self.resize_offset[1],
							120 - self.difficulty_description_text_size - self.resize_offset[2],
							2
						}

						if not self.should_resize then
							arg_106_1.offset = tbl
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
					content_check_function = function (self)
						-- function 107
						return self.should_show_diff_lock_text
					end,
					content_change_function = function (self, arg_108_1)
						-- function 108
						local tbl = {
							7.5 + self.resize_offset[1],
							-self.difficulty_description_text_size - self.resize_offset[2] + 90,
							2
						}

						if not self.should_resize then
							arg_108_1.offset = tbl
						end
					end
				},
				{
					style_id = "dlc_lock_text",
					pass_type = "text",
					text_id = "dlc_lock_text",
					content_check_function = function (self)
						-- function 109
						return self.should_show_dlc_lock
					end,
					content_change_function = function (self, arg_110_1)
						-- function 110
						local tbl = {
							2.5 + self.resize_offset[1],
							-self.difficulty_description_text_size - self.resize_offset[2] + 70 - self.difficulty_lock_text_height,
							2
						}

						if not self.should_resize then
							arg_110_1.offset = tbl
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
			border = border_tiled.texture,
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
				texture_size = border_tiled.texture_size,
				texture_sizes = border_tiled.texture_sizes,
				size = {
					arg_101_1[1] + 2 * tbl[1],
					arg_101_1[2] + 2 * tbl[2]
				},
				offset = {
					-tbl[1],
					-tbl[2],
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
	-- function 111
	local flag = arg_111_1 or {
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
					content_check_function = function (self, arg_112_1)
						-- function 112
						return self.ready
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
				texture_size = flag,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			ability_charge_active = {
				texture_size = {
					flag[1] - 4,
					flag[2] - 4
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
	-- function 113
	local flag = true

	if not arg_113_2 then
		flag = false
	end

	return {
		element = {
			passes = {
				{
					texture_id = "shrine_bg",
					style_id = "shrine_bg",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 114
						return not self.extend_left
					end
				},
				{
					texture_id = "shrine_bg",
					style_id = "shrine_bg_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 115
						return self.extend_left
					end
				},
				{
					style_id = "shrine_bg_frame_left",
					pass_type = "texture_uv",
					content_id = "shrine_bg_frame_left",
					content_check_function = function (self)
						-- function 116
						return not self.parent.extend_left
					end
				},
				{
					style_id = "shrine_bg_frame_right",
					pass_type = "texture_uv",
					content_id = "shrine_bg_frame_right",
					content_check_function = function (self)
						-- function 117
						return self.parent.extend_left
					end
				},
				{
					texture_id = "icon",
					style_id = "round_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 118
						local icon = self.icon

						icon = not icon and not self.is_rectangular_icon

						return icon
					end
				},
				{
					texture_id = "round_icon_bg",
					style_id = "round_icon_bg",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 119
						local icon = self.icon

						icon = not icon and not not self.is_rectangular_icon or false

						return icon
					end
				},
				{
					texture_id = "icon",
					style_id = "rectangular_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 120
						local icon = self.icon

						icon = not icon and self.is_rectangular_icon

						return icon
					end
				},
				{
					style_id = "rectangular_bg",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 121
						local icon = self.icon

						icon = not icon and not self.is_rectangular_icon

						return icon
					end
				},
				{
					texture_id = "rectangular_icon_bg",
					style_id = "rectangular_icon_bg",
					pass_type = "texture",
					content_check_function = function (arg_122_0)
						-- function 122
						return true
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 123
						return not self.extend_left
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 124
						return not self.extend_left
					end
				},
				{
					style_id = "rarity_text",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function (self)
						-- function 125
						return not self.extend_left
					end
				},
				{
					style_id = "rarity_text_shadow",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function (self)
						-- function 126
						return not self.extend_left
					end
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (self)
						-- function 127
						return not self.extend_left
					end
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (self)
						-- function 128
						return not self.extend_left
					end
				},
				{
					style_id = "title_text_left",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 129
						return self.extend_left
					end
				},
				{
					style_id = "title_text_shadow_left",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 130
						return self.extend_left
					end
				},
				{
					style_id = "rarity_text_left",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function (self)
						-- function 131
						return self.extend_left
					end
				},
				{
					style_id = "rarity_text_shadow_left",
					pass_type = "text",
					text_id = "rarity_text",
					content_check_function = function (self)
						-- function 132
						return self.extend_left
					end
				},
				{
					style_id = "description_text_left",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (self)
						-- function 133
						return self.extend_left
					end
				},
				{
					style_id = "description_text_shadow_left",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (self)
						-- function 134
						return self.extend_left
					end
				},
				{
					style_id = "set_progression",
					pass_type = "text",
					text_id = "set_progression",
					content_check_function = function (self)
						-- function 135
						local is_part_of_set = self.is_part_of_set

						is_part_of_set = not is_part_of_set and not self.extend_left

						return is_part_of_set
					end
				},
				{
					style_id = "set_progression_left",
					pass_type = "text",
					text_id = "set_progression",
					content_check_function = function (self)
						-- function 136
						local is_part_of_set = self.is_part_of_set

						is_part_of_set = not is_part_of_set and self.extend_left

						return is_part_of_set
					end
				},
				{
					style_id = "remove_tooltip_left",
					pass_type = "text",
					text_id = "remove_tooltip",
					content_check_function = function (self)
						-- function 137
						local extend_left

						if not self.locked then
							extend_left = self.extend_left

							if not extend_left then
								extend_left = arg_113_3
							end
						else
							extend_left = false
						end

						if false then
							extend_left = true
						end

						return extend_left
					end,
					content_change_function = function (self, arg_138_1, arg_138_2, arg_138_3)
						-- function 138
						local var_138_0 = Localize(self.remove_tooltip_key)
						local input_service_name = self.input_service_name
						local str = "$KEY;%s__%s:"
						local mouse_action = self.mouse_action
						local gamepad_action = self.gamepad_action
						local flag = not Managers.input:is_device_active("gamepad") and gamepad_action and mouse_action
						local format = string.format(str, input_service_name, flag)

						self.remove_tooltip = string.format(var_138_0, format)
					end
				},
				{
					style_id = "remove_tooltip",
					pass_type = "text",
					text_id = "remove_tooltip",
					content_check_function = function (self)
						-- function 139
						return not not self.locked or not not self.extend_left or arg_113_3
					end,
					content_change_function = function (self, arg_140_1, arg_140_2, arg_140_3)
						-- function 140
						local var_140_0 = Localize(self.remove_tooltip_key)
						local input_service_name = self.input_service_name
						local str = "$KEY;%s__%s:"
						local mouse_action = self.mouse_action
						local gamepad_action = self.gamepad_action
						local flag = not Managers.input:is_device_active("gamepad") and gamepad_action and mouse_action
						local format = string.format(str, input_service_name, flag)

						self.remove_tooltip = string.format(var_140_0, format)
					end
				},
				{
					style_id = "locked_left",
					pass_type = "text",
					text_id = "locked_text_id",
					content_check_function = function (self)
						-- function 141
						local locked = self.locked

						if not locked then
							locked = self.extend_left
							locked = not locked and arg_113_3
						end

						return locked
					end
				},
				{
					style_id = "locked_left_shadow",
					pass_type = "text",
					text_id = "locked_text_id",
					content_check_function = function (self)
						-- function 142
						local locked = self.locked

						if not locked then
							locked = self.extend_left
							locked = not locked and arg_113_3
						end

						return locked
					end
				},
				{
					style_id = "locked",
					pass_type = "text",
					text_id = "locked_text_id",
					content_check_function = function (self)
						-- function 143
						local locked = self.locked

						locked = not locked and not not self.extend_left or arg_113_3

						return locked
					end
				},
				{
					style_id = "locked_shadow",
					pass_type = "text",
					text_id = "locked_text_id",
					content_check_function = function (self)
						-- function 144
						local locked = self.locked

						locked = not locked and not not self.extend_left or arg_113_3

						return locked
					end
				},
				{
					pass_type = "texture",
					style_id = "remove_frame",
					texture_id = "remove_frame",
					content_check_function = function (self, arg_145_1)
						-- function 145
						local input_made = self.input_made

						input_made = not input_made and not not self.locked or arg_113_3

						return input_made
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
				masked = flag
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
				masked = flag
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
