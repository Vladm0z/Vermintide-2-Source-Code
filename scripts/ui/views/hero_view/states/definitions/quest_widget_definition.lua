-- chunkname: @scripts/ui/views/hero_view/states/definitions/quest_widget_definition.lua

return function (arg_1_0, arg_1_1)
	-- function 1
	local menu_frame_12 = UIFrameSettings.menu_frame_12
	local button_frame_01 = UIFrameSettings.button_frame_01
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_1_3 = frame_outer_glow_01.texture_sizes.corner[1]
	local str = "menu_frame_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local str_2 = "button_bg_01"
	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local str_3 = "button_detail_03"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size
	local flag = true
	local tbl = {
		80,
		80
	}
	local tbl_2 = {
		500,
		42
	}
	local num = 13
	local tbl_3 = {
		800,
		100
	}
	local tbl_4 = {
		tbl_3[1] / 2,
		30
	}
	local num_2 = -(arg_1_1[2] - 10)
	local tbl_5 = {
		allow_multi_hover = true
	}
	local tbl_6 = {}

	for i = 1, 10 do
		tbl_5[i] = {
			text = "n/a",
			checkbox_marker = "matchmaking_checkbox",
			checkbox = "achievement_checkbox",
			button_hotspot = {
				allow_multi_hover = true
			}
		}

		local tbl_7 = {
			list_member_offset = {
				0,
				-tbl_4[2],
				0
			},
			size = tbl_4
		}
		local tbl_8 = {
			vertical_alignment = "center",
			upper_case = false,
			font_size = 22,
			horizontal_alignment = "left",
			word_wrap = true
		}
		local flag_2

		flag_2 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_8.font_type = flag_2
		tbl_8.text_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_8.offset = {
			31,
			0,
			2
		}
		tbl_7.text = tbl_8

		local tbl_9 = {
			vertical_alignment = "center",
			upper_case = false,
			font_size = 22,
			horizontal_alignment = "left",
			word_wrap = true
		}
		local flag_3

		flag_3 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_9.font_type = flag_3
		tbl_9.text_color = Colors.get_color_table_with_alpha("black", 0)
		tbl_9.offset = {
			33,
			-2,
			1
		}
		tbl_7.text_shadow = tbl_9
		tbl_7.checkbox = {
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
		}
		tbl_7.checkbox_marker = {
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
		tbl_6[i] = tbl_7
	end

	local tbl_10 = {
		element = {}
	}
	local tbl_11 = {
		{
			style_id = "button_hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			texture_id = "hover_glow",
			style_id = "hover_glow",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 2
				return self.button_hotspot.is_hover
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
			content_check_function = function (self)
				-- function 3
				return self.can_close
			end
		},
		{
			pass_type = "texture",
			style_id = "close_icon_bg",
			texture_id = "close_icon_bg",
			content_check_function = function (self)
				-- function 4
				return self.can_close
			end
		},
		{
			pass_type = "texture",
			style_id = "close_icon",
			texture_id = "close_icon",
			content_check_function = function (self)
				-- function 5
				local can_close = self.can_close

				can_close = not can_close and not self.close_button_hotspot.is_hover

				return can_close
			end
		},
		{
			pass_type = "texture",
			style_id = "close_icon_hover",
			texture_id = "close_icon_hover",
			content_check_function = function (self)
				-- function 6
				local can_close = self.can_close

				can_close = not can_close and self.close_button_hotspot.is_hover

				return can_close
			end
		},
		{
			style_id = "close_icon",
			pass_type = "hotspot",
			content_id = "close_button_hotspot",
			content_check_function = function (self)
				-- function 7
				return self.parent.can_close
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "expand_background",
			texture_id = "expand_background",
			content_check_function = function (self)
				-- function 8
				return self.expanded
			end
		},
		{
			pass_type = "texture",
			style_id = "expand_background_edge",
			texture_id = "expand_background_edge",
			content_check_function = function (self)
				-- function 9
				return self.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "expand_background_shadow",
			texture_id = "expand_background_shadow",
			content_check_function = function (self)
				-- function 10
				return self.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			texture_id = "arrow",
			content_check_function = function (self)
				-- function 11
				local expandable = self.expandable

				expandable = not expandable and not not self.button_hotspot.is_hover or not self.expanded

				return expandable
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			texture_id = "arrow_hover",
			content_check_function = function (self)
				-- function 12
				local expandable = self.expandable

				if not expandable then
					expandable = self.expanded
					expandable = expandable or self.button_hotspot.is_hover
				end

				return expandable
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "progress_frame",
			texture_id = "progress_frame",
			content_check_function = function (self)
				-- function 13
				local draw_bar = self.draw_bar

				if not draw_bar then
					draw_bar = self.completed
					draw_bar = not draw_bar and not self.claimed
				end

				return draw_bar
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_bar",
			texture_id = "progress_bar",
			content_check_function = function (self)
				-- function 14
				return self.draw_bar
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_bar_bg",
			texture_id = "rect_masked",
			content_check_function = function (self)
				-- function 15
				return self.draw_bar
			end
		},
		{
			style_id = "progress_text",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function (self)
				-- function 16
				return self.draw_bar
			end
		},
		{
			style_id = "progress_text_shadow",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function (self)
				-- function 17
				return self.draw_bar
			end
		},
		{
			style_id = "progress_button_text_hover",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (self)
				-- function 18
				local completed = self.completed

				completed = not completed and not not self.claimed and not not self.draw_bar or self.progress_button_hotspot.is_hover

				return completed
			end
		},
		{
			style_id = "progress_button_text",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (self)
				-- function 19
				local completed = self.completed

				completed = not completed and not not self.claimed and not not self.draw_bar or not self.progress_button_hotspot.is_hover

				return completed
			end
		},
		{
			style_id = "progress_button_text_shadow",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (self)
				-- function 20
				local completed = self.completed

				completed = not completed and not not self.claimed or not self.draw_bar

				return completed
			end
		},
		{
			style_id = "progress_button_background",
			pass_type = "texture_uv",
			content_id = "progress_button_background",
			content_check_function = function (self)
				-- function 21
				local parent = self.parent
				local completed = parent.completed

				completed = not completed and not parent.claimed

				return completed
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_button_background_fade",
			texture_id = "background_fade",
			content_check_function = function (self)
				-- function 22
				local completed = self.completed

				completed = not completed and not self.claimed

				return completed
			end
		},
		{
			style_id = "progress_button_hotspot",
			pass_type = "hotspot",
			content_id = "progress_button_hotspot",
			content_check_function = function (self)
				-- function 23
				local parent = self.parent
				local completed = parent.completed

				completed = not completed and not parent.claimed

				return completed
			end
		},
		{
			texture_id = "glass",
			style_id = "progress_button_glass_top",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 24
				local draw_bar = self.draw_bar

				if not draw_bar then
					draw_bar = self.completed
					draw_bar = not draw_bar and not self.claimed
				end

				return draw_bar
			end
		},
		{
			texture_id = "glass",
			style_id = "progress_button_glass_bottom",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 25
				local draw_bar = self.draw_bar

				if not draw_bar then
					draw_bar = self.completed
					draw_bar = not draw_bar and not self.claimed
				end

				return draw_bar
			end
		},
		{
			texture_id = "hover_glow",
			style_id = "progress_button_hover_glow",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 26
				local completed = self.completed

				completed = not completed and not not self.claimed or self.progress_button_hotspot.is_hover

				return completed
			end
		},
		{
			style_id = "progress_button_claim_glow",
			texture_id = "progress_button_claim_glow",
			pass_type = "texture_frame",
			content_check_function = function (self)
				-- function 27
				local completed = self.completed

				completed = not completed and not not self.claimed or not self.claiming

				return completed
			end,
			content_change_function = function (arg_28_0, arg_28_1)
				-- function 28
				local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_28_1.color[1] = 55 + num * 200
			end
		},
		{
			style_id = "side_detail_right",
			pass_type = "texture_uv",
			content_id = "side_detail",
			content_check_function = function (self)
				-- function 29
				local parent = self.parent
				local draw_bar = parent.draw_bar

				if not draw_bar then
					draw_bar = parent.completed
					draw_bar = not draw_bar and not parent.claimed
				end

				return draw_bar
			end
		},
		{
			texture_id = "texture_id",
			style_id = "side_detail_left",
			pass_type = "texture",
			content_id = "side_detail",
			content_check_function = function (self)
				-- function 30
				local parent = self.parent
				local draw_bar = parent.draw_bar

				if not draw_bar then
					draw_bar = parent.completed
					draw_bar = not draw_bar and not parent.claimed
				end

				return draw_bar
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
			content_check_function = function (self)
				-- function 31
				local reward_button_hotspot = self.reward_button_hotspot
				local is_hover = reward_button_hotspot.is_hover

				is_hover = not is_hover and reward_button_hotspot.draw

				return is_hover
			end
		},
		{
			item_id = "reward_item",
			pass_type = "item_tooltip",
			style_id = "reward_icon",
			content_check_function = function (self)
				-- function 32
				local reward_button_hotspot = self.reward_button_hotspot
				local is_hover = reward_button_hotspot.is_hover

				is_hover = not is_hover and reward_button_hotspot.draw

				return is_hover
			end,
			content_change_function = function (arg_33_0)
				-- function 33
				arg_33_0.reward_button_hotspot.draw = false
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
			content_check_function = function (self)
				-- function 34
				return self.claimed
			end
		},
		{
			style_id = "claimed_text",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function (self)
				-- function 35
				local completed = self.completed

				completed = not completed and self.claimed

				return completed
			end
		},
		{
			style_id = "claimed_text_shadow",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function (self)
				-- function 36
				local completed = self.completed

				completed = not completed and self.claimed

				return completed
			end
		},
		{
			style_id = "locked_text",
			pass_type = "text",
			text_id = "locked_text",
			content_check_function = function (self)
				-- function 37
				return self.locked
			end
		},
		{
			style_id = "locked_text_shadow",
			pass_type = "text",
			text_id = "locked_text",
			content_check_function = function (self)
				-- function 38
				return self.locked
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
			content_check_function = function (self)
				-- function 39
				return self.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 40
						return not self.button_hotspot.is_hover
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
			content_check_function = function (self)
				-- function 41
				return self.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 42
						return not self.button_hotspot.is_hover
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
	local tbl_12 = {
		progress_bar = "chest_upgrade_fill",
		close_icon_bg = "achievement_refresh_off",
		expand_background_edge = "achievement_paper_bottom",
		icon_background_ribbon = "quest_book_ribbon",
		progress_text = "n/a",
		glass = "button_glass_02",
		close_background = "quest_close",
		draw_bar = true,
		expand_background = "achievement_paper_middle",
		icon = "quest_book_skull",
		arrow = "achievement_arrow",
		icon_background = "quest_book_skull",
		reward_hover = "item_icon_hover",
		background_fade = "options_window_fade_01",
		reward_icon = "icons_placeholder",
		reward_icon_claimed = "achievement_banner",
		background = "quests_background",
		arrow_hover = "achievement_arrow_hover",
		expand_background_shadow = "edge_fade_small",
		hover_glow = "button_state_default",
		completed = false,
		title = "n/a",
		claimed = false,
		expanded = false,
		description = "n/a",
		expandable = false,
		close_icon = "achievement_refresh_white",
		title_divider = "divider_01_bottom",
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
		frame = menu_frame_12.texture,
		progress_frame = button_frame_01.texture,
		progress_button_claim_glow = frame_outer_glow_01.texture,
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
		progress_button_background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(tbl_2[1] / get_atlas_settings_by_texture_name_2.size[1], 1),
					math.min(tbl_2[2] / get_atlas_settings_by_texture_name_2.size[2], 1)
				}
			},
			texture_id = str_2
		},
		checklist_1 = table.clone(tbl_5),
		checklist_2 = table.clone(tbl_5)
	}
	local tbl_13 = {
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
			size = tbl_3,
			offset = {
				100,
				-arg_1_1[2] / 2,
				1
			},
			item_styles = table.clone(tbl_6)
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
			size = tbl_3,
			offset = {
				500,
				-arg_1_1[2] / 2,
				1
			},
			item_styles = table.clone(tbl_6)
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
				num_2,
				-1
			},
			texture_size = tbl_3,
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
			area_size = tbl_2,
			texture_size = button_frame_01.texture_size,
			texture_sizes = button_frame_01.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				num,
				10
			}
		},
		progress_bar = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "left",
			default_size = tbl_2,
			texture_size = tbl_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_1_1[1] / 2 - tbl_2[1] / 2,
				num,
				6
			}
		},
		progress_bar_bg = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			default_size = tbl_2,
			texture_size = tbl_2,
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				arg_1_1[1] / 2 - tbl_2[1] / 2,
				num,
				5
			}
		},
		progress_button_background = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				tbl_2[1],
				tbl_2[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				num,
				6
			}
		},
		progress_button_background_fade = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				tbl_2[1] - 10,
				tbl_2[2] - 10
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				num + 5,
				7
			}
		},
		progress_button_glass_top = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				tbl_2[1] - 10,
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
				num + tbl_2[2] - 17,
				8
			}
		},
		progress_button_glass_bottom = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				tbl_2[1] - 10,
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
				num - 3,
				8
			}
		},
		progress_button_hover_glow = {
			vertical_alignment = "bottom",
			masked = true,
			horizontal_alignment = "center",
			texture_size = {
				tbl_2[1] - 10,
				tbl_2[2] - 10
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				num + 5,
				9
			}
		},
		progress_button_hotspot = {
			size = tbl_2,
			offset = {
				arg_1_1[1] / 2 - tbl_2[1] / 2,
				num,
				1
			}
		},
		progress_button_claim_glow = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			masked = true,
			area_size = tbl_2,
			texture_size = frame_outer_glow_01.texture_size,
			texture_sizes = frame_outer_glow_01.texture_sizes,
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
				num,
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
				-(tbl_2[1] / 2 - size[1] / 2) - 9,
				num + tbl_2[2] / 2 - size[2] / 2,
				15
			},
			texture_size = size
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
				tbl_2[1] / 2 - size[1] / 2 + 9,
				num + tbl_2[2] / 2 - size[2] / 2,
				15
			},
			texture_size = size
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
			texture_size = menu_frame_12.texture_size,
			texture_sizes = menu_frame_12.texture_sizes,
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
			size = tbl,
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
		}
	}
	local tbl_14 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_4

	flag_4 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_14.font_type = flag_4
	tbl_14.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_14.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_14.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2,
		num,
		10
	}
	tbl_13.progress_text = tbl_14

	local tbl_15 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_5

	flag_5 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_15.font_type = flag_5
	tbl_15.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_15.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_15.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2 + 2,
		num - 2,
		9
	}
	tbl_13.progress_text_shadow = tbl_15

	local tbl_16 = {
		vertical_alignment = "bottom",
		upper_case = true,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_6

	flag_6 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_16.font_type = flag_6
	tbl_16.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_16.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_16.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2,
		4,
		10
	}
	tbl_13.claimed_text = tbl_16

	local tbl_17 = {
		vertical_alignment = "bottom",
		upper_case = true,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_7

	flag_7 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_17.font_type = flag_7
	tbl_17.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_17.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_17.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2 + 2,
		2,
		9
	}
	tbl_13.claimed_text_shadow = tbl_17

	local tbl_18 = {
		vertical_alignment = "bottom",
		upper_case = true,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_8

	flag_8 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_18.font_type = flag_8
	tbl_18.text_color = Colors.get_color_table_with_alpha("red", 255)
	tbl_18.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_18.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2,
		10,
		10
	}
	tbl_13.locked_text = tbl_18

	local tbl_19 = {
		vertical_alignment = "bottom",
		upper_case = true,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_9

	flag_9 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_19.font_type = flag_9
	tbl_19.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_19.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_19.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2 + 2,
		8,
		9
	}
	tbl_13.locked_text_shadow = tbl_19

	local tbl_20 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_10

	flag_10 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_20.font_type = flag_10
	tbl_20.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_20.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_20.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2,
		num,
		10
	}
	tbl_13.progress_button_text = tbl_20

	local tbl_21 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_11

	flag_11 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_21.font_type = flag_11
	tbl_21.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_21.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_21.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2,
		num,
		10
	}
	tbl_13.progress_button_text_hover = tbl_21

	local tbl_22 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_12

	flag_12 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_22.font_type = flag_12
	tbl_22.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_22.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_22.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2 + 2,
		num - 2,
		9
	}
	tbl_13.progress_button_text_shadow = tbl_22

	local tbl_23 = {
		word_wrap = true,
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center",
		vertical_alignment = "center"
	}
	local flag_13

	flag_13 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_23.font_type = flag_13
	tbl_23.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_23.size = {
		arg_1_1[1] - 300,
		arg_1_1[2]
	}
	tbl_23.offset = {
		150,
		5,
		9
	}
	tbl_13.description = tbl_23

	local tbl_24 = {
		word_wrap = true,
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center",
		vertical_alignment = "center"
	}
	local flag_14

	flag_14 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_24.font_type = flag_14
	tbl_24.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_24.size = {
		arg_1_1[1] - 300,
		arg_1_1[2]
	}
	tbl_24.offset = {
		152,
		3,
		8
	}
	tbl_13.description_shadow = tbl_24

	local tbl_25 = {
		font_size = 28,
		upper_case = true,
		horizontal_alignment = "center",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_15

	flag_15 = not flag and "hell_shark_header_masked" and "hell_shark_header"
	tbl_25.font_type = flag_15
	tbl_25.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_25.offset = {
		arg_1_1[1] / 2 - 200,
		-7,
		9
	}
	tbl_25.size = {
		400,
		arg_1_1[2]
	}
	tbl_13.title = tbl_25

	local tbl_26 = {
		font_size = 28,
		upper_case = true,
		horizontal_alignment = "center",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_16

	flag_16 = not flag and "hell_shark_header_masked" and "hell_shark_header"
	tbl_26.font_type = flag_16
	tbl_26.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_26.offset = {
		arg_1_1[1] / 2 - 200 + 2,
		-9,
		8
	}
	tbl_26.size = {
		400,
		arg_1_1[2]
	}
	tbl_13.title_shadow = tbl_26

	UIWidgets.append_item_frame_pass("reward_frame", tbl_11, tbl_12, tbl_13, tbl, {
		-3,
		3,
		15
	}, flag, nil, {
		horizontal_alignment = "right",
		vertical_alignment = "center"
	}, nil, nil)

	tbl_10.element.passes = tbl_11
	tbl_10.content = tbl_12
	tbl_10.style = tbl_13
	tbl_10.offset = {
		0,
		0,
		0
	}
	tbl_10.scenegraph_id = arg_1_0

	return tbl_10
end
