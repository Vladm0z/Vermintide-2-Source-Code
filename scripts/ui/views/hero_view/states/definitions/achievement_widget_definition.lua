-- chunkname: @scripts/ui/views/hero_view/states/definitions/achievement_widget_definition.lua

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
	local num_3 = 15

	for i = 1, num_3 do
		tbl_5[i] = {
			text = "n/a",
			checkbox_marker = "matchmaking_checkbox",
			checkbox = "achievement_checkbox",
			button_hotspot = {}
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
			word_wrap = true,
			upper_case = false,
			font_size = 22,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true
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
		tbl_8.size = {
			300,
			100
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
			horizontal_alignment = "left",
			masked = flag,
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
			horizontal_alignment = "left",
			masked = flag,
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
			pass_type = "tiled_texture",
			style_id = "expand_background",
			texture_id = "expand_background",
			content_check_function = function (self)
				-- function 3
				return self.expanded
			end
		},
		{
			pass_type = "texture",
			style_id = "expand_background_edge",
			texture_id = "expand_background_edge",
			content_check_function = function (self)
				-- function 4
				return self.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "expand_background_shadow",
			texture_id = "expand_background_shadow",
			content_check_function = function (self)
				-- function 5
				return self.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			texture_id = "arrow",
			content_check_function = function (self)
				-- function 6
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
				-- function 7
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
				-- function 8
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
				-- function 9
				return self.draw_bar
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_bar_bg",
			texture_id = "rect_masked",
			content_check_function = function (self)
				-- function 10
				return self.draw_bar
			end
		},
		{
			style_id = "progress_text",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function (self)
				-- function 11
				return self.draw_bar
			end
		},
		{
			style_id = "progress_text_shadow",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function (self)
				-- function 12
				return self.draw_bar
			end
		},
		{
			style_id = "progress_button_text_hover",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (self)
				-- function 13
				local completed = self.completed

				if not completed then
					if not (self.claimed or self.draw_bar) then
						completed = self.progress_button_hotspot.is_hover

						if not completed then
							completed = not self.locked
						end
					else
						completed = false
					end
				end

				if false then
					completed = true
				end

				return completed
			end
		},
		{
			style_id = "progress_button_text",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (self)
				-- function 14
				local completed = self.completed

				completed = not completed and not not self.claimed and not not self.draw_bar and not not self.progress_button_hotspot.is_hover or not self.locked

				return completed
			end
		},
		{
			style_id = "progress_button_text_shadow",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (self)
				-- function 15
				local completed = self.completed

				completed = not completed and not not self.claimed or not self.draw_bar

				return completed
			end
		},
		{
			style_id = "progress_button_text_disabled",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (self)
				-- function 16
				local completed = self.completed

				completed = not completed and not not self.claimed and not not self.draw_bar or self.locked

				return completed
			end
		},
		{
			style_id = "progress_button_background",
			pass_type = "texture_uv",
			content_id = "progress_button_background",
			content_check_function = function (self)
				-- function 17
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
				-- function 18
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
				-- function 19
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
				-- function 20
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
				-- function 21
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
				-- function 22
				local completed = self.completed

				if not completed then
					if not self.claimed then
						completed = self.progress_button_hotspot.is_hover

						if not completed then
							completed = not self.locked
						end
					else
						completed = false
					end
				end

				if false then
					completed = true
				end

				return completed
			end
		},
		{
			style_id = "progress_button_claim_glow",
			texture_id = "progress_button_claim_glow",
			pass_type = "texture_frame",
			content_check_function = function (self)
				-- function 23
				local completed = self.completed

				completed = not completed and not not self.claimed or not self.claiming

				return completed
			end,
			content_change_function = function (arg_24_0, arg_24_1)
				-- function 24
				local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_24_1.color[1] = 55 + num * 200
			end
		},
		{
			style_id = "side_detail_right",
			pass_type = "texture_uv",
			content_id = "side_detail",
			content_check_function = function (self)
				-- function 25
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
				-- function 26
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
			texture_id = "background",
			content_check_function = function (self)
				-- function 27
				return not self.claimed
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background_completed",
			texture_id = "background_completed",
			content_check_function = function (self)
				-- function 28
				return self.claimed
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
			content_check_function = function (self)
				-- function 29
				local draw = self.draw

				self.draw = false
				self.is_hover = false

				return draw
			end
		},
		{
			style_id = "dlc_lock",
			texture_id = "dlc_lock",
			pass_type = "rotated_texture",
			content_check_function = function (self)
				-- function 30
				return self.locked
			end,
			content_change_function = function (self, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				if self.dlc_on_claim == true then
					self.dlc_lock_t = 1
					self.dlc_lock_dir = -self.dlc_lock_dir
					self.dlc_on_claim = false
				else
					local dlc_lock_t = self.dlc_lock_t

					if not dlc_lock_t then
						local math = math
						local num = dlc_lock_t - arg_31_3

						arg_31_1.angle = 0.1 * math.pi * math.min(1, num * num) * math.sin(3 * math.pi * num * self.dlc_lock_dir)
						self.dlc_lock_t = not (num > 0) or num
					end
				end
			end
		},
		{
			style_id = "dlc_lock_glow",
			texture_id = "dlc_lock_glow",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 32
				return self.locked
			end,
			content_change_function = function (self, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				local dlc_lock_t = self.dlc_lock_t
				local dlc_lock_glow_alpha_multiplier = self.dlc_lock_glow_alpha_multiplier

				if not self.dlc_lock_hotspot.is_hover then
					dlc_lock_glow_alpha_multiplier = dlc_lock_glow_alpha_multiplier + 3 * arg_33_3
				elseif not (not dlc_lock_t and not (dlc_lock_t > 0)) then
					dlc_lock_glow_alpha_multiplier = math.sin(0.5 * math.pi * dlc_lock_t)
				else
					dlc_lock_glow_alpha_multiplier = dlc_lock_glow_alpha_multiplier - 2 * arg_33_3
				end

				local clamp = math.clamp(dlc_lock_glow_alpha_multiplier, 0, 1)

				arg_33_1.color[1] = 255 * clamp
				self.dlc_lock_glow_alpha_multiplier = clamp
			end
		},
		{
			style_id = "locked_text",
			pass_type = "tooltip_text",
			text_id = "locked_text",
			content_check_function = function (self)
				-- function 34
				local locked = self.locked

				locked = not locked and self.dlc_lock_hotspot.is_hover

				return locked
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
			content_check_function = function (self)
				-- function 35
				return self.reward_icon_background ~= nil
			end
		},
		{
			pass_type = "texture",
			style_id = "reward_hover",
			texture_id = "reward_hover",
			content_check_function = function (self)
				-- function 36
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
				-- function 37
				local reward_button_hotspot = self.reward_button_hotspot
				local is_hover = reward_button_hotspot.is_hover

				is_hover = not is_hover and reward_button_hotspot.draw

				return is_hover
			end,
			content_change_function = function (arg_38_0)
				-- function 38
				arg_38_0.reward_button_hotspot.draw = false
			end
		},
		{
			pass_type = "texture",
			style_id = "reward_illusion_frame",
			texture_id = "reward_illusion_frame",
			content_check_function = function (self)
				-- function 39
				return self.is_illusion
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
				-- function 40
				return self.claimed
			end
		},
		{
			style_id = "claimed_text",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function (self)
				-- function 41
				return self.claimed
			end
		},
		{
			style_id = "claimed_text_shadow",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function (self)
				-- function 42
				return self.claimed
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
				-- function 43
				return self.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 44
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
				-- function 45
				return self.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 46
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
		reward_illusion_frame = "item_frame_illusion",
		expand_background_edge = "achievement_paper_bottom",
		progress_text = "n/a",
		glass = "button_glass_02",
		dlc_lock = "hero_icon_locked_gold",
		draw_bar = true,
		icon_background = "achievement_left",
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
		arrow_hover = "achievement_arrow_hover",
		reward_icon = "icons_placeholder",
		dlc_lock_glow = "circular_gradient_masked",
		expand_background_shadow = "edge_fade_small",
		hover_glow = "button_state_default",
		completed = false,
		title = "n/a",
		background_fade = "options_window_fade_01",
		claimed = false,
		expanded = false,
		description = "n/a",
		expandable = false,
		title_divider = "divider_01_bottom",
		rect_masked = "rect_masked",
		claiming = false,
		reward_background = "achievement_right",
		dlc_on_claim = false,
		reward_hover = "item_icon_hover"
	}
	local flag_4

	flag_4 = not (math.random() < 0.5) or not 1 or -1
	tbl_12.dlc_lock_dir = flag_4
	tbl_12.dlc_lock_hotspot = {}
	tbl_12.button_hotspot = {
		allow_multi_hover = true
	}
	tbl_12.progress_button_hotspot = {}
	tbl_12.reward_button_hotspot = {}
	tbl_12.claimed_text = Localize("achv_menu_reward_claimed")
	tbl_12.progress_button_text = Localize("loot_screen_claim_reward")
	tbl_12.swirl_texture = {
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
	}
	tbl_12.side_detail = {
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
	}
	tbl_12.frame = menu_frame_12.texture
	tbl_12.progress_frame = button_frame_01.texture
	tbl_12.progress_button_claim_glow = frame_outer_glow_01.texture
	tbl_12.progress_button_background = {
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
	}
	tbl_12.checklist_1 = table.clone(tbl_5)
	tbl_12.checklist_2 = table.clone(tbl_5)

	local tbl_13 = {
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			angle = math.pi,
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			masked = flag,
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
			horizontal_alignment = "left",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			area_size = tbl_2,
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			masked = flag,
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
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
			horizontal_alignment = "left",
			masked = flag,
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
			horizontal_alignment = "left",
			masked = flag,
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
			horizontal_alignment = "left",
			masked = flag,
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
			angle = 0,
			horizontal_alignment = "right",
			masked = flag,
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
			horizontal_alignment = "right",
			masked = flag,
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
			horizontal_alignment = "right",
			masked = flag,
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
			masked = flag,
			size = tbl,
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
			masked = flag,
			size = tbl,
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
			horizontal_alignment = "right",
			masked = flag,
			texture_size = tbl,
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
		reward_hover = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = flag,
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
			horizontal_alignment = "center",
			masked = flag,
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
		}
	}
	local tbl_14 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_5

	flag_5 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_14.font_type = flag_5
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
	local flag_6

	flag_6 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_15.font_type = flag_6
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
	local flag_7

	flag_7 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_16.font_type = flag_7
	tbl_16.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_16.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_16.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2,
		4,
		12
	}
	tbl_13.claimed_text = tbl_16

	local tbl_17 = {
		vertical_alignment = "bottom",
		upper_case = true,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_8

	flag_8 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_17.font_type = flag_8
	tbl_17.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_17.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_17.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2 + 2,
		2,
		11
	}
	tbl_13.claimed_text_shadow = tbl_17

	local tbl_18 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_9

	flag_9 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_18.font_type = flag_9
	tbl_18.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_18.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_18.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2,
		num,
		10
	}
	tbl_13.progress_button_text = tbl_18

	local tbl_19 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_10

	flag_10 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_19.font_type = flag_10
	tbl_19.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_19.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_19.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2,
		num,
		10
	}
	tbl_13.progress_button_text_hover = tbl_19

	local tbl_20 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_11

	flag_11 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_20.font_type = flag_11
	tbl_20.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_20.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_20.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2 + 2,
		num - 2,
		9
	}
	tbl_13.progress_button_text_shadow = tbl_20

	local tbl_21 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_12

	flag_12 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_21.font_type = flag_12
	tbl_21.text_color = {
		255,
		155,
		155,
		155
	}
	tbl_21.size = {
		tbl_2[1],
		tbl_2[2]
	}
	tbl_21.offset = {
		arg_1_1[1] / 2 - tbl_2[1] / 2,
		num,
		10
	}
	tbl_13.progress_button_text_disabled = tbl_21

	local tbl_22 = {
		word_wrap = true,
		upper_case = false,
		font_size = 18,
		font_height_multiplier = 0.9,
		horizontal_alignment = "center",
		vertical_alignment = "center"
	}
	local flag_13

	flag_13 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_22.font_type = flag_13
	tbl_22.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_22.size = {
		arg_1_1[1] - 300,
		arg_1_1[2]
	}
	tbl_22.offset = {
		150,
		5,
		12
	}
	tbl_13.description = tbl_22

	local tbl_23 = {
		word_wrap = true,
		upper_case = false,
		font_size = 18,
		font_height_multiplier = 0.9,
		horizontal_alignment = "center",
		vertical_alignment = "center"
	}
	local flag_14

	flag_14 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_23.font_type = flag_14
	tbl_23.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_23.size = {
		arg_1_1[1] - 300,
		arg_1_1[2]
	}
	tbl_23.offset = {
		152,
		3,
		11
	}
	tbl_13.description_shadow = tbl_23

	local tbl_24 = {
		font_size = 28,
		upper_case = true,
		horizontal_alignment = "center",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_15

	flag_15 = not flag and "hell_shark_header_masked" and "hell_shark_header"
	tbl_24.font_type = flag_15
	tbl_24.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_24.offset = {
		arg_1_1[1] / 2 - 200,
		-7,
		9
	}
	tbl_24.size = {
		400,
		arg_1_1[2]
	}
	tbl_13.title = tbl_24

	local tbl_25 = {
		font_size = 28,
		upper_case = true,
		horizontal_alignment = "center",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_16

	flag_16 = not flag and "hell_shark_header_masked" and "hell_shark_header"
	tbl_25.font_type = flag_16
	tbl_25.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_25.offset = {
		arg_1_1[1] / 2 - 200 + 2,
		-9,
		8
	}
	tbl_25.size = {
		400,
		arg_1_1[2]
	}
	tbl_13.title_shadow = tbl_25

	UIWidgets.append_item_frame_pass("reward_frame", tbl_11, tbl_12, tbl_13, tbl, {
		-2,
		0,
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
