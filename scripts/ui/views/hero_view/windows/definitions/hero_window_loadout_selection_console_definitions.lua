-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_selection_console_definitions.lua

local size = UISettings.game_start_windows.size
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	48,
	48
}
local num = 5
local num_2 = 400
local tbl_2 = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
	background = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale = "fit",
		position = {
			0,
			0,
			550
		},
		size = {
			1920,
			1080
		}
	},
	anchor = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		}
	},
	add_loadout_button = {
		vertical_alignment = "bottom",
		parent = "anchor",
		horizontal_alignment = "right",
		position = {
			-180,
			150,
			100
		},
		size = tbl
	},
	button = {
		vertical_alignment = "bottom",
		parent = "add_loadout_button",
		horizontal_alignment = "left",
		position = {
			-tbl[1] - num,
			0,
			-5
		},
		size = tbl,
		offset = {
			0,
			0,
			0
		}
	},
	context_menu = {
		vertical_alignment = "bottom",
		parent = "button",
		horizontal_alignment = "right",
		position = {
			0,
			tbl[2],
			-10
		},
		size = {
			num_2,
			475
		},
		offset = {
			0,
			0,
			0
		}
	},
	context_menu_anchor = {
		vertical_alignment = "top",
		parent = "context_menu",
		horizontal_alignment = "left",
		position = {
			10,
			-10,
			1
		},
		size = {
			0,
			0
		}
	},
	icon = {
		vertical_alignment = "top",
		parent = "context_menu_anchor",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			15
		},
		size = tbl
	},
	header = {
		vertical_alignment = "top",
		parent = "context_menu_anchor",
		horizontal_alignment = "left",
		position = {
			tbl[1] + num,
			-5,
			15
		}
	},
	equipment_header = {
		vertical_alignment = "top",
		parent = "icon",
		horizontal_alignment = "left",
		position = {
			0,
			-55,
			15
		}
	},
	equipment = {
		vertical_alignment = "top",
		parent = "equipment_header",
		horizontal_alignment = "left",
		position = {
			10,
			-45,
			15
		}
	},
	talents_header = {
		vertical_alignment = "top",
		parent = "equipment",
		horizontal_alignment = "left",
		position = {
			-10,
			-70,
			15
		}
	},
	talents = {
		vertical_alignment = "top",
		parent = "talents_header",
		horizontal_alignment = "left",
		position = {
			5,
			-35,
			15
		}
	},
	cosmetics_header = {
		vertical_alignment = "top",
		parent = "talents",
		horizontal_alignment = "left",
		position = {
			0,
			-60,
			15
		}
	},
	cosmetics = {
		vertical_alignment = "top",
		parent = "cosmetics_header",
		horizontal_alignment = "left",
		position = {
			10,
			-40,
			15
		}
	},
	right_divider = {
		vertical_alignment = "bottom",
		parent = "context_menu",
		horizontal_alignment = "right",
		position = {
			0,
			77,
			15
		},
		size = {
			num_2 * 0.5,
			4
		}
	},
	left_divider = {
		vertical_alignment = "bottom",
		parent = "context_menu",
		horizontal_alignment = "left",
		position = {
			0,
			77,
			15
		},
		size = {
			num_2 * 0.5,
			4
		}
	},
	bot_checkbox = {
		vertical_alignment = "bottom",
		parent = "context_menu",
		horizontal_alignment = "left",
		size = {
			200,
			50
		},
		position = {
			10,
			10,
			20
		}
	},
	delete_button = {
		vertical_alignment = "bottom",
		parent = "context_menu",
		horizontal_alignment = "right",
		position = {
			-10,
			10,
			15
		},
		size = {
			180,
			50
		}
	},
	delete_button_bar = {
		vertical_alignment = "bottom",
		parent = "delete_button",
		horizontal_alignment = "left",
		size = {
			180,
			50
		},
		position = {
			0,
			0,
			3
		}
	},
	delete_button_bar_edge = {
		vertical_alignment = "center",
		parent = "delete_button_bar",
		horizontal_alignment = "right",
		size = {
			8,
			50
		},
		position = {
			8,
			0,
			4
		}
	},
	talent_tooltip = {
		vertical_alignment = "center",
		parent = "context_menu",
		horizontal_alignment = "left",
		position = {
			-20 - num_2,
			170,
			15
		}
	},
	weapon_tooltip = {
		vertical_alignment = "center",
		parent = "context_menu",
		horizontal_alignment = "center",
		position = {
			-20,
			40,
			15
		}
	}
}
local tbl_3 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	area_size = {
		400 - tbl[1] - num - 10,
		50
	},
	offset = {
		0,
		0,
		0
	}
}
local tbl_4 = {
	font_size = 26,
	upper_case = false,
	localize = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	area_size = {
		400 - num - 10,
		50
	},
	offset = {
		0,
		0,
		0
	}
}
local tbl_5 = {
	58,
	58
}
local num_3 = 6
local tbl_6 = {
	46.25,
	45.5
}
local tbl_7 = {
	111,
	109.2
}
local num_4 = 32
local tbl_8 = {
	"slot_melee",
	"slot_ranged",
	"slot_necklace",
	"slot_ring",
	"slot_trinket_1"
}
local tbl_9 = {
	"slot_hat",
	"slot_skin",
	"slot_frame",
	"slot_pose"
}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local flag = arg_1_1 or {
		0,
		0,
		0
	}

	for i, v in ipairs(arg_1_2) do
		tbl_2[#tbl_2 + 1] = {
			pass_type = "hotspot",
			style_id = v .. "_hotspot",
			content_id = v,
			content_check_function = function (arg_2_0)
				-- function 2
				return true
			end
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "weapon_frame",
			pass_type = "texture",
			style_id = v .. "_frame"
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "equipment_hover_frame",
			pass_type = "texture",
			style_id = v .. "_frame",
			content_check_function = function (self, arg_3_1)
				-- function 3
				local is_hover = self[v].is_hover

				is_hover = is_hover or self[v].is_selected

				return is_hover
			end
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "icon",
			pass_type = "texture",
			style_id = v .. "_icon",
			content_id = v,
			content_check_function = function (self)
				-- function 4
				local item = self.item

				item = not item and self.icon

				return item
			end
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "mask",
			pass_type = "texture",
			style_id = v .. "_mask"
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "rarity",
			pass_type = "texture",
			style_id = v .. "_mask",
			content_id = v
		}
		tbl_2[#tbl_2 + 1] = {
			style_id = "weapon_tooltip",
			scenegraph_id = "weapon_tooltip",
			pass_type = "item_tooltip",
			item_id = "item",
			content_id = v,
			content_check_function = function (self)
				-- function 5
				local item = self.item

				if not item then
					item = self.is_hover
					item = item or self.is_selected
				end

				return item
			end
		}
		tbl_3[v] = {
			rarity = "icon_bg_default",
			no_equipped_item = true,
			is_selected = false
		}
		tbl_4[v] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = tbl_6,
			texture_size = tbl_6,
			offset = {
				(i - 1) * (tbl_6[1] + num_4),
				0,
				0
			}
		}
		tbl_4[v .. "_hotspot"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = {
				tbl_7[1] * 0.7,
				tbl_7[2] * 0.7
			},
			offset = {
				(i - 1) * (tbl_6[1] + num_4),
				0,
				10
			}
		}
		tbl_4[v .. "_icon"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = true,
			area_size = {
				54,
				54
			},
			texture_size = {
				54,
				54
			},
			offset = {
				(i - 1) * (tbl_6[1] + num_4),
				0,
				2
			}
		}
		tbl_4[v .. "_mask"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = tbl_6,
			texture_size = tbl_6,
			offset = {
				(i - 1) * (tbl_6[1] + num_4),
				0,
				1
			}
		}
		tbl_4[v .. "_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl_7,
			offset = {
				(i - 1) * (tbl_6[1] + num_4),
				0,
				1
			}
		}
		tbl_4[v .. "_hover_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl_7,
			offset = {
				(i - 1) * (tbl_6[1] + num_4),
				0,
				10
			}
		}
	end

	tbl_3.equipment_hover_frame = "loadout_item_slot_glow_console"
	tbl_3.background = "icon_bg_default"
	tbl_3.mask = "mask_rect"
	tbl_3.weapon_frame = "loadout_item_slot_console"
	tbl_4.weapon_tooltip = {
		draw_downwards = false
	}
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = arg_1_0
	tbl.offset = flag

	return tbl
end

local function fn_2(arg_6_0, arg_6_1)
	-- function 6
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local flag = arg_6_1 or {
		0,
		0,
		0
	}
	local str = "frame_outer_glow_01"
	local var_6_6 = UIFrameSettings[str]

	for i = 1, MaxTalentPoints do
		local str_2 = "talent_" .. i

		tbl_2[#tbl_2 + 1] = {
			texture_id = "talent_frame",
			pass_type = "texture",
			style_id = str_2 .. "_frame"
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "talent_hover_frame",
			pass_type = "texture_frame",
			style_id = str_2 .. "_hover_frame",
			content_check_function = function (self, arg_7_1)
				-- function 7
				local is_hover = self[str_2].is_hover

				is_hover = is_hover or self[str_2].is_selected

				return is_hover
			end
		}
		tbl_2[#tbl_2 + 1] = {
			pass_type = "hotspot",
			style_id = str_2,
			content_id = str_2,
			content_check_function = function (self)
				-- function 8
				return self.talent
			end
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "icon",
			pass_type = "texture",
			style_id = str_2,
			content_id = str_2,
			content_check_function = function (self)
				-- function 9
				local talent = self.talent

				talent = not talent and self.icon

				return talent
			end
		}
		tbl_2[#tbl_2 + 1] = {
			style_id = "talent_tooltip",
			scenegraph_id = "talent_tooltip",
			pass_type = "talent_tooltip",
			talent_id = "talent",
			content_id = str_2,
			content_check_function = function (self)
				-- function 10
				local talent = self.talent

				if not talent then
					talent = self.is_hover
					talent = talent or self.is_selected
				end

				return talent
			end
		}
		tbl_3[str_2] = {
			is_selected = false
		}
		tbl_4[str_2] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = tbl_5,
			texture_size = tbl_5,
			offset = {
				(i - 1) * (tbl_5[1] + num_3),
				0,
				0
			}
		}
		tbl_4[str_2 .. "_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl_5,
			offset = {
				(i - 1) * (tbl_5[1] + num_3),
				0,
				1
			}
		}
		tbl_4[str_2 .. "_hover_frame"] = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			texture_size = var_6_6.texture_size,
			texture_sizes = var_6_6.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				(i - 1) * (tbl_5[1] + num_3),
				0,
				0
			},
			area_size = {
				tbl_5[1] * 1.55,
				tbl_5[2] * 1.55
			}
		}
	end

	tbl_3.talent_hover_frame = var_6_6.texture
	tbl_3.talent_frame = "talent_frame"
	tbl_4.talent_tooltip = {
		draw_downwards = false
	}
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = arg_6_0
	tbl.offset = flag

	return tbl
end

local function fn_3(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14)
	-- function 11
	arg_11_3 = arg_11_3 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_11_3)
	local var_11_1

	if not arg_11_2 then
		var_11_1 = UIFrameSettings[arg_11_2]

		if not var_11_1 then
			-- Nothing
		end
	end

	var_11_1 = UIFrameSettings.button_frame_01

	::label_11_0::

	local var_11_2 = var_11_1.texture_sizes.corner[1]
	local flag = arg_11_7 or "button_detail_01"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(flag).size
	local var_11_5
	local var_11_6

	if not arg_11_8 then
		if type(arg_11_8) == "table" then
			var_11_5 = arg_11_8[1]
			var_11_6 = arg_11_8[2]
		else
			var_11_5 = arg_11_8
		end
	end

	local tbl = {
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
						-- function 12
						return self.draw_frame
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "rect",
					style_id = "background_rect"
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
						-- function 13
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 14
						return not self.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 15
						return not self.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 16
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 17
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
					texture_id = "bot_equipped_icon",
					style_id = "bot_equipped_icon",
					pass_type = "texture",
					content_check_function = function (self, arg_18_1)
						-- function 18
						local game_mode_key = Managers.state.game_mode:game_mode_key()

						if not InventorySettings.bot_loadout_allowed_game_modes[game_mode_key] then
							return false
						end

						local career_name = self.career_name

						return PlayerData.loadout_selection.bot_equipment[career_name] == self.loadout_index
					end
				}
			}
		}
	}
	local tbl_2 = {
		draw_frame = true,
		hover_glow = "button_state_default",
		background_fade = "button_bg_fade",
		glass = "button_glass_02",
		bot_equipped_icon = "bot_selected_icon",
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
			texture_id = flag,
			skip_side_detail = arg_11_10
		},
		button_hotspot = {},
		title_text = arg_11_4 or "n/a",
		frame = var_11_1.texture
	}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {
		0
	}
	local flag_2

	flag_2 = not arg_11_13 and 1 and arg_11_1[2] / get_atlas_settings_by_texture_name.size[2]
	tbl_5[2] = 1 - flag_2
	tbl_4[1] = tbl_5

	local tbl_6 = {
		nil,
		1
	}
	local flag_3

	flag_3 = not arg_11_13 and 1 and arg_11_1[1] / get_atlas_settings_by_texture_name.size[1]
	tbl_6[1] = flag_3
	tbl_4[2] = tbl_6
	tbl_3.uvs = tbl_4
	tbl_3.texture_id = arg_11_3
	tbl_2.background = tbl_3
	tbl_2.disable_with_gamepad = arg_11_9
	tbl.content = tbl_2

	local tbl_7 = {}
	local tbl_8 = {
		vertical_alignment = "center",
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
			1
		},
		masked = arg_11_11
	}
	local tbl_9

	if not arg_11_13 then
		tbl_9 = {
			arg_11_1[1] * 0.7,
			arg_11_1[2] * 0.7
		}

		if not tbl_9 then
			-- Nothing
		end
	end

	tbl_9 = nil

	::label_11_1::

	tbl_8.texture_size = tbl_9
	tbl_7.background = tbl_8
	tbl_7.background_rect = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
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
		},
		masked = arg_11_11,
		texture_size = arg_11_1
	}
	tbl_7.background_fade = {
		color = {
			200,
			255,
			255,
			255
		},
		offset = {
			var_11_2,
			var_11_2 - 2,
			2
		},
		size = {
			arg_11_1[1] - var_11_2 * 2,
			arg_11_1[2] - var_11_2 * 2
		},
		masked = arg_11_11
	}
	tbl_7.hover_glow = {
		color = {
			0,
			255,
			255,
			255
		},
		offset = {
			0,
			var_11_2 - 2,
			3
		},
		size = {
			arg_11_1[1],
			math.min(arg_11_1[2] - 5, 80)
		},
		masked = arg_11_11
	}
	tbl_7.clicked_rect = {
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
	}
	tbl_7.disabled_rect = {
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
	}

	local tbl_10 = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = arg_11_5 or 24
	}
	local flag_4

	flag_4 = not arg_11_11 and "hell_shark_masked" and "hell_shark"
	tbl_10.font_type = flag_4
	tbl_10.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_10.default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_10.select_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_10.size = {
		arg_11_1[1] - 40,
		arg_11_1[2]
	}
	tbl_10.area_size = arg_11_14
	tbl_10.offset = {
		20,
		0,
		6
	}
	tbl_7.title_text = tbl_10

	local tbl_11 = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = arg_11_5 or 24
	}
	local flag_5

	flag_5 = not arg_11_11 and "hell_shark_masked" and "hell_shark"
	tbl_11.font_type = flag_5
	tbl_11.text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_11.default_text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_11.size = {
		arg_11_1[1] - 40,
		arg_11_1[2]
	}
	tbl_11.area_size = arg_11_14
	tbl_11.offset = {
		20,
		0,
		6
	}
	tbl_7.title_text_disabled = tbl_11

	local tbl_12 = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = arg_11_5 or 24
	}
	local flag_6

	flag_6 = not arg_11_11 and "hell_shark_masked" and "hell_shark"
	tbl_12.font_type = flag_6
	tbl_12.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_12.default_text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_12.size = {
		arg_11_1[1] - 40,
		arg_11_1[2]
	}
	tbl_12.area_size = arg_11_14
	tbl_12.offset = {
		22,
		-2,
		5
	}
	tbl_7.title_text_shadow = tbl_12
	tbl_7.frame = {
		texture_size = var_11_1.texture_size,
		texture_sizes = var_11_1.texture_sizes,
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
		masked = arg_11_11
	}
	tbl_7.glass_top = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			arg_11_1[2] - (var_11_2 + 11),
			4
		},
		size = {
			arg_11_1[1],
			11
		},
		masked = arg_11_11
	}
	tbl_7.glass_bottom = {
		color = {
			100,
			255,
			255,
			255
		},
		offset = {
			0,
			var_11_2 - 9,
			4
		},
		size = {
			arg_11_1[1],
			11
		},
		masked = arg_11_11
	}

	local tbl_13 = {
		color = {
			255,
			255,
			255,
			255
		}
	}
	local tbl_14 = {
		nil,
		nil,
		9
	}
	local num

	if not var_11_5 then
		num = -var_11_5

		if not num then
			-- Nothing
		end
	end

	num = -9

	::label_11_2::

	tbl_14[1] = num
	tbl_14[2] = arg_11_1[2] / 2 - size[2] / 2 + (var_11_6 or 0)
	tbl_13.offset = tbl_14
	tbl_13.size = {
		size[1],
		size[2]
	}
	tbl_13.masked = arg_11_11
	tbl_7.side_detail_left = tbl_13
	tbl_7.side_detail_right = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			arg_11_1[1] - size[1] + (var_11_5 or 9),
			arg_11_1[2] / 2 - size[2] / 2 + (var_11_6 or 0),
			9
		},
		size = {
			size[1],
			size[2]
		},
		masked = arg_11_11
	}
	tbl_7.bot_equipped_icon = {
		vertical_alignment = "bottom",
		horizontal_alignment = "right",
		texture_size = {
			20,
			20
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
			10
		}
	}
	tbl.style = tbl_7
	tbl.scenegraph_id = arg_11_0
	tbl.offset = arg_11_12 or {
		0,
		0,
		0
	}

	return tbl
end

local var_0_18
local var_0_19
local var_0_20
local var_0_21
local var_0_22
local flag = false
local flag_2 = true
local flag_3 = false
local flag_4 = true
local flag_5 = false
local tbl_10 = {}

for i, v in ipairs(InventorySettings.loadouts) do
	if v.loadout_type == "custom" then
		tbl_10[#tbl_10 + 1] = fn_3("button", tbl, var_0_18, v.loadout_icon, "", var_0_19, var_0_20, var_0_21, var_0_22, flag, flag_2, flag_3, {
			(tbl[1] + num) * (v.loadout_index - 1),
			0,
			0
		}, flag_4)
	end
end

local tbl_11 = {
	loadout_frame = UIWidgets.create_rect_with_outer_frame("button", tbl, "frame_outer_glow_01", nil, {
		0,
		255,
		255,
		255
	}, {
		220,
		255,
		255,
		255
	}),
	hover_loadout_frame = UIWidgets.create_rect_with_outer_frame("button", tbl, "frame_outer_glow_01_white", nil, {
		0,
		255,
		255,
		255
	}, {
		220,
		255,
		255,
		255
	}),
	add_loadout_button = UIWidgets.create_default_button("add_loadout_button", tbl, var_0_18, nil, "+", 32, var_0_20, var_0_21, var_0_22, flag, flag_2, nil, nil, nil, tbl)
}
local tbl_12 = {
	context_menu_hotspot = UIWidgets.create_simple_hotspot("context_menu"),
	context_menu_background = UIWidgets.create_simple_texture("button_bg_01", "context_menu", nil, nil, {
		255,
		128,
		128,
		128
	}, {
		0,
		0,
		1
	}),
	context_menu_bg = UIWidgets.create_rect_with_outer_frame("context_menu", tbl_2.context_menu.size, "frame_outer_glow_01", -10, {
		255,
		0,
		0,
		0
	}, {
		220,
		255,
		255,
		255
	}, -20),
	context_menu_bg_white = UIWidgets.create_rect_with_outer_frame("context_menu", tbl_2.context_menu.size, "frame_outer_glow_01_white", -10, {
		255,
		0,
		0,
		0
	}, {
		220,
		255,
		255,
		255
	}, -20),
	icon = UIWidgets.create_simple_texture("icons_placeholder", "icon"),
	header = UIWidgets.create_simple_text("", "header", nil, nil, tbl_3),
	equipment_header = UIWidgets.create_simple_text("hero_window_equipment", "equipment_header", nil, nil, tbl_4),
	equipment = fn("equipment", nil, tbl_8),
	talents_header = UIWidgets.create_simple_text("hero_window_talents", "talents_header", nil, nil, tbl_4),
	talents = fn_2("talents", nil),
	cosmetics_header = UIWidgets.create_simple_text("hero_window_cosmetics", "cosmetics_header", nil, nil, tbl_4),
	cosmetics = fn("cosmetics", nil, tbl_9),
	right_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "right_divider"),
	left_divider = UIWidgets.create_simple_uv_texture("infoslate_frame_02_horizontal", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "left_divider"),
	bot_checkbox = UIWidgets.create_default_checkbox_button_console("bot_checkbox", tbl_2.bot_checkbox.size, Localize("input_description_equip_for_bot"), 16, {
		description = "This is a descirption",
		title = Localize("input_description_equip_for_bot")
	}, "menu_frame_03_morris", true),
	delete_button = UIWidgets.create_default_button("delete_button", tbl_2.delete_button.size, nil, nil, Localize("input_description_delete_loadout"), nil, nil, nil, nil, flag_5, flag_2),
	delete_button_bar_edge = UIWidgets.create_simple_texture("experience_bar_edge_glow", "delete_button_bar_edge"),
	delete_button_bar = UIWidgets.create_simple_uv_texture("experience_bar_fill", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "delete_button_bar")
}
local tbl_13 = {
	background = UIWidgets.create_simple_rect("background", {
		128,
		0,
		0,
		0
	})
}
local tbl_14 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				arg_19_3.render_settings.alpha_multiplier = 0
				arg_19_0.anchor.position[1] = 50
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				local easeOutCubic = math.easeOutCubic(arg_20_3)

				arg_20_4.render_settings.alpha_multiplier = easeOutCubic * easeOutCubic
				arg_20_0.anchor.position[1] = 50 - 50 * easeOutCubic
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end
		}
	}
}
local tbl_15 = {
	default = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "special_1",
			priority = 2,
			description_text = "input_description_toggle_loadout_details"
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "input_description_select"
		},
		{
			input_action = "refresh",
			priority = 4,
			description_text = "input_description_delete_loadout"
		},
		{
			input_action = "left_stick_press",
			priority = 5,
			description_text = "input_description_equip_for_bot",
			content_check_function = function ()
				-- function 22
				local game_mode_key = Managers.state.game_mode:game_mode_key()

				return InventorySettings.bot_loadout_allowed_game_modes[game_mode_key]
			end
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_close"
		}
	},
	default_no_delete = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "special_1",
			priority = 2,
			description_text = "input_description_toggle_loadout_details"
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "input_description_select"
		},
		{
			input_action = "left_stick_press",
			priority = 4,
			description_text = "input_description_equip_for_bot",
			content_check_function = function ()
				-- function 23
				local game_mode_key = Managers.state.game_mode:game_mode_key()

				return InventorySettings.bot_loadout_allowed_game_modes[game_mode_key]
			end
		},
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_close"
		}
	},
	details = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "refresh",
			priority = 2,
			description_text = "input_description_delete_loadout"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "menu_back"
		}
	},
	add_loadout = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_add_loadout"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "menu_back"
		}
	},
	add_loadout_no_add = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "menu_back"
		}
	}
}

return {
	widgets = tbl_11,
	loadout_button_widgets = tbl_10,
	gamepad_specific_widgets = tbl_13,
	context_menu_widgets = tbl_12,
	scenegraph_definition = tbl_2,
	animation_definitions = tbl_14,
	button_size = tbl,
	button_spacing = num,
	equipment_slots = tbl_8,
	cosmetic_slots = tbl_9,
	generic_input_actions = tbl_15
}
