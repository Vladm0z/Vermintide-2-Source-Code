-- chunkname: @scripts/ui/views/hero_view/states/definitions/achievement_widget_definition.lua

local function create_achievement_entry(scenegraph_id, size)
	-- function 1
	local frame_settings = UIFrameSettings.menu_frame_12
	local progress_frame_settings = UIFrameSettings.button_frame_01
	local hover_frame_settings = UIFrameSettings.frame_outer_glow_01
	local hover_frame_width = hover_frame_settings.texture_sizes.corner[1]
	local background_texture = "menu_frame_bg_01"
	local background_texture_settings = UIAtlasHelper.get_atlas_settings_by_texture_name(background_texture)
	local button_background_texture = "button_bg_01"
	local button_background_texture_settings = UIAtlasHelper.get_atlas_settings_by_texture_name(button_background_texture)
	local side_detail_texture = "button_detail_03"
	local side_detail_texture_settings = UIAtlasHelper.get_atlas_settings_by_texture_name(side_detail_texture)
	local side_detail_texture_size = side_detail_texture_settings.size
	local masked = true
	local texture_size = {
		80,
		80
	}
	local progress_bar_size = {
		500,
		42
	}
	local progress_bar_height_offset = 13
	local expand_size = {
		800,
		100
	}
	local checklist_entry_size = {
		expand_size[1] / 2,
		30
	}
	local expand_height_offset = -(size[2] - 10)
	local checklist_content = {
		allow_multi_hover = true
	}
	local checklist_item_styles = {}
	local checklist_max_items = 15

	for i = 1, checklist_max_items do
		checklist_content[i] = {
			text = "n/a",
			checkbox_marker = "matchmaking_checkbox",
			checkbox = "achievement_checkbox",
			button_hotspot = {}
		}

		local tbl = {
			list_member_offset = {
				0,
				-checklist_entry_size[2],
				0
			},
			size = checklist_entry_size
		}
		local tbl_2 = {
			word_wrap = true,
			upper_case = false,
			font_size = 22,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true
		}
		local flag

		flag = (not masked or not "hell_shark_masked") and not not "hell_shark"
		tbl_2.font_type = flag
		tbl_2.text_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_2.offset = {
			31,
			0,
			2
		}
		tbl_2.size = {
			300,
			100
		}
		tbl.text = tbl_2

		local tbl_3 = {
			vertical_alignment = "center",
			upper_case = false,
			font_size = 22,
			horizontal_alignment = "left",
			word_wrap = true
		}
		local flag_2

		flag_2 = (not masked or not "hell_shark_masked") and not not "hell_shark"
		tbl_3.font_type = flag_2
		tbl_3.text_color = Colors.get_color_table_with_alpha("black", 0)
		tbl_3.offset = {
			33,
			-2,
			1
		}
		tbl.text_shadow = tbl_3
		tbl.checkbox = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = masked,
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
		tbl.checkbox_marker = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = masked,
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
		checklist_item_styles[i] = tbl
	end

	local widget = {
		element = {}
	}
	local passes = {
		{
			style_id = "button_hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			texture_id = "hover_glow",
			style_id = "hover_glow",
			pass_type = "texture",
			content_check_function = function (content)
				-- function 2
				return content.button_hotspot.is_hover
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
			content_check_function = function (content)
				-- function 3
				return content.expanded
			end
		},
		{
			pass_type = "texture",
			style_id = "expand_background_edge",
			texture_id = "expand_background_edge",
			content_check_function = function (content)
				-- function 4
				return content.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "expand_background_shadow",
			texture_id = "expand_background_shadow",
			content_check_function = function (content)
				-- function 5
				return content.expanded
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			texture_id = "arrow",
			content_check_function = function (content)
				-- function 6
				local expandable = content.expandable

				expandable = not not expandable and not content.button_hotspot.is_hover and not not not content.expanded

				return expandable
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			texture_id = "arrow_hover",
			content_check_function = function (content)
				-- function 7
				local expandable = content.expandable

				if expandable then
					expandable = content.expanded
					expandable = not not expandable or not not content.button_hotspot.is_hover
				end

				return expandable
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "progress_frame",
			texture_id = "progress_frame",
			content_check_function = function (content)
				-- function 8
				local draw_bar = content.draw_bar

				if not draw_bar then
					draw_bar = content.completed
					draw_bar = not not draw_bar and not not not content.claimed
				end

				return draw_bar
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_bar",
			texture_id = "progress_bar",
			content_check_function = function (content)
				-- function 9
				return content.draw_bar
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_bar_bg",
			texture_id = "rect_masked",
			content_check_function = function (content)
				-- function 10
				return content.draw_bar
			end
		},
		{
			style_id = "progress_text",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function (content)
				-- function 11
				return content.draw_bar
			end
		},
		{
			style_id = "progress_text_shadow",
			pass_type = "text",
			text_id = "progress_text",
			content_check_function = function (content)
				-- function 12
				return content.draw_bar
			end
		},
		{
			style_id = "progress_button_text_hover",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (content)
				-- function 13
				local completed = content.completed

				if completed then
					if not content.claimed and not content.draw_bar then
						completed = content.progress_button_hotspot.is_hover

						if completed then
							completed = not content.locked
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
			content_check_function = function (content)
				-- function 14
				local completed = content.completed

				completed = not not completed and not content.claimed and not content.draw_bar and not content.progress_button_hotspot.is_hover and not not not content.locked

				return completed
			end
		},
		{
			style_id = "progress_button_text_shadow",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (content)
				-- function 15
				local completed = content.completed

				completed = not not completed and not content.claimed and not not not content.draw_bar

				return completed
			end
		},
		{
			style_id = "progress_button_text_disabled",
			pass_type = "text",
			text_id = "progress_button_text",
			content_check_function = function (content)
				-- function 16
				local completed = content.completed

				completed = not not completed and not content.claimed and not content.draw_bar and not not content.locked

				return completed
			end
		},
		{
			style_id = "progress_button_background",
			pass_type = "texture_uv",
			content_id = "progress_button_background",
			content_check_function = function (content)
				-- function 17
				local parent = content.parent
				local completed = parent.completed

				completed = not not completed and not not not parent.claimed

				return completed
			end
		},
		{
			pass_type = "texture",
			style_id = "progress_button_background_fade",
			texture_id = "background_fade",
			content_check_function = function (content)
				-- function 18
				local completed = content.completed

				completed = not not completed and not not not content.claimed

				return completed
			end
		},
		{
			style_id = "progress_button_hotspot",
			pass_type = "hotspot",
			content_id = "progress_button_hotspot",
			content_check_function = function (content)
				-- function 19
				local parent = content.parent
				local completed = parent.completed

				completed = not not completed and not not not parent.claimed

				return completed
			end
		},
		{
			texture_id = "glass",
			style_id = "progress_button_glass_top",
			pass_type = "texture",
			content_check_function = function (content)
				-- function 20
				local draw_bar = content.draw_bar

				if not draw_bar then
					draw_bar = content.completed
					draw_bar = not not draw_bar and not not not content.claimed
				end

				return draw_bar
			end
		},
		{
			texture_id = "glass",
			style_id = "progress_button_glass_bottom",
			pass_type = "texture",
			content_check_function = function (content)
				-- function 21
				local draw_bar = content.draw_bar

				if not draw_bar then
					draw_bar = content.completed
					draw_bar = not not draw_bar and not not not content.claimed
				end

				return draw_bar
			end
		},
		{
			texture_id = "hover_glow",
			style_id = "progress_button_hover_glow",
			pass_type = "texture",
			content_check_function = function (content)
				-- function 22
				local completed = content.completed

				if completed then
					if not content.claimed then
						completed = content.progress_button_hotspot.is_hover

						if completed then
							completed = not content.locked
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
			content_check_function = function (content)
				-- function 23
				local completed = content.completed

				completed = not not completed and not content.claimed and not not not content.claiming

				return completed
			end,
			content_change_function = function (content, style)
				-- function 24
				local progress = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				style.color[1] = 55 + progress * 200
			end
		},
		{
			style_id = "side_detail_right",
			pass_type = "texture_uv",
			content_id = "side_detail",
			content_check_function = function (content)
				-- function 25
				local parent_content = content.parent
				local draw_bar = parent_content.draw_bar

				if not draw_bar then
					draw_bar = parent_content.completed
					draw_bar = not not draw_bar and not not not parent_content.claimed
				end

				return draw_bar
			end
		},
		{
			texture_id = "texture_id",
			style_id = "side_detail_left",
			pass_type = "texture",
			content_id = "side_detail",
			content_check_function = function (content)
				-- function 26
				local parent_content = content.parent
				local draw_bar = parent_content.draw_bar

				if not draw_bar then
					draw_bar = parent_content.completed
					draw_bar = not not draw_bar and not not not parent_content.claimed
				end

				return draw_bar
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background",
			content_check_function = function (content)
				-- function 27
				return not content.claimed
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background_completed",
			texture_id = "background_completed",
			content_check_function = function (content)
				-- function 28
				return content.claimed
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
			content_check_function = function (content)
				-- function 29
				local should_draw = content.draw

				content.draw = false
				content.is_hover = false

				return should_draw
			end
		},
		{
			style_id = "dlc_lock",
			texture_id = "dlc_lock",
			pass_type = "rotated_texture",
			content_check_function = function (content)
				-- function 30
				return content.locked
			end,
			content_change_function = function (content, style, _, dt)
				-- function 31
				if content.dlc_on_claim == true then
					content.dlc_lock_t = 1
					content.dlc_lock_dir = -content.dlc_lock_dir
					content.dlc_on_claim = false
				else
					local t = content.dlc_lock_t

					if t then
						local math = math

						t = t - dt
						style.angle = 0.1 * math.pi * math.min(1, t * t) * math.sin(3 * math.pi * t * content.dlc_lock_dir)
						content.dlc_lock_t = t > 0 and not not t
					end
				end
			end
		},
		{
			style_id = "dlc_lock_glow",
			texture_id = "dlc_lock_glow",
			pass_type = "texture",
			content_check_function = function (content)
				-- function 32
				return content.locked
			end,
			content_change_function = function (content, style, _, dt)
				-- function 33
				local t = content.dlc_lock_t
				local alpha_mult = content.dlc_lock_glow_alpha_multiplier

				if content.dlc_lock_hotspot.is_hover then
					alpha_mult = alpha_mult + 3 * dt
				elseif t and t > 0 then
					alpha_mult = math.sin(0.5 * math.pi * t)
				else
					alpha_mult = alpha_mult - 2 * dt
				end

				alpha_mult = math.clamp(alpha_mult, 0, 1)
				style.color[1] = 255 * alpha_mult
				content.dlc_lock_glow_alpha_multiplier = alpha_mult
			end
		},
		{
			style_id = "locked_text",
			pass_type = "tooltip_text",
			text_id = "locked_text",
			content_check_function = function (content)
				-- function 34
				local locked = content.locked

				locked = not not locked and not not content.dlc_lock_hotspot.is_hover

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
			content_check_function = function (content)
				-- function 35
				return content.reward_icon_background ~= nil
			end
		},
		{
			pass_type = "texture",
			style_id = "reward_hover",
			texture_id = "reward_hover",
			content_check_function = function (content)
				-- function 36
				local reward_button_hotspot = content.reward_button_hotspot
				local is_hover = reward_button_hotspot.is_hover

				is_hover = not not is_hover and not not reward_button_hotspot.draw

				return is_hover
			end
		},
		{
			item_id = "reward_item",
			pass_type = "item_tooltip",
			style_id = "reward_icon",
			content_check_function = function (content)
				-- function 37
				local reward_button_hotspot = content.reward_button_hotspot
				local is_hover = reward_button_hotspot.is_hover

				is_hover = not not is_hover and not not reward_button_hotspot.draw

				return is_hover
			end,
			content_change_function = function (content)
				-- function 38
				content.reward_button_hotspot.draw = false
			end
		},
		{
			pass_type = "texture",
			style_id = "reward_illusion_frame",
			texture_id = "reward_illusion_frame",
			content_check_function = function (content)
				-- function 39
				return content.is_illusion
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
			content_check_function = function (content)
				-- function 40
				return content.claimed
			end
		},
		{
			style_id = "claimed_text",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function (content)
				-- function 41
				return content.claimed
			end
		},
		{
			style_id = "claimed_text_shadow",
			pass_type = "text",
			text_id = "claimed_text",
			content_check_function = function (content)
				-- function 42
				return content.claimed
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
			content_check_function = function (content)
				-- function 43
				return content.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (content)
						-- function 44
						return not content.button_hotspot.is_hover
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
			content_check_function = function (content)
				-- function 45
				return content.parent.expanded
			end,
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (content)
						-- function 46
						return not content.button_hotspot.is_hover
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
	local tbl_4 = {
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
	local flag_3

	flag_3 = (not (math.random() < 0.5) or not 1) and not not -1
	tbl_4.dlc_lock_dir = flag_3
	tbl_4.dlc_lock_hotspot = {}
	tbl_4.button_hotspot = {
		allow_multi_hover = true
	}
	tbl_4.progress_button_hotspot = {}
	tbl_4.reward_button_hotspot = {}
	tbl_4.claimed_text = Localize("achv_menu_reward_claimed")
	tbl_4.progress_button_text = Localize("loot_screen_claim_reward")
	tbl_4.swirl_texture = {
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
	tbl_4.side_detail = {
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
		texture_id = side_detail_texture
	}
	tbl_4.frame = frame_settings.texture
	tbl_4.progress_frame = progress_frame_settings.texture
	tbl_4.progress_button_claim_glow = hover_frame_settings.texture
	tbl_4.progress_button_background = {
		uvs = {
			{
				0,
				0
			},
			{
				math.min(progress_bar_size[1] / button_background_texture_settings.size[1], 1),
				math.min(progress_bar_size[2] / button_background_texture_settings.size[2], 1)
			}
		},
		texture_id = button_background_texture
	}
	tbl_4.checklist_1 = table.clone(checklist_content)
	tbl_4.checklist_2 = table.clone(checklist_content)

	local content = tbl_4
	local tbl_5 = {
		button_hotspot = {
			size = {
				size[1] + 100,
				size[2]
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
			size = expand_size,
			offset = {
				100,
				-size[2] / 2,
				1
			},
			item_styles = table.clone(checklist_item_styles)
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
			size = expand_size,
			offset = {
				500,
				-size[2] / 2,
				1
			},
			item_styles = table.clone(checklist_item_styles)
		},
		expand_background = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			masked = masked,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				expand_height_offset,
				-1
			},
			texture_size = expand_size,
			texture_tiling_size = {
				800,
				100
			}
		},
		expand_background_edge = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			masked = masked,
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
			masked = masked,
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
			masked = masked,
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
			masked = masked,
			area_size = progress_bar_size,
			texture_size = progress_frame_settings.texture_size,
			texture_sizes = progress_frame_settings.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				progress_bar_height_offset,
				10
			}
		},
		progress_bar = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = masked,
			default_size = progress_bar_size,
			texture_size = progress_bar_size,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				size[1] / 2 - progress_bar_size[1] / 2,
				progress_bar_height_offset,
				6
			}
		},
		progress_bar_bg = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			default_size = progress_bar_size,
			texture_size = progress_bar_size,
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				size[1] / 2 - progress_bar_size[1] / 2,
				progress_bar_height_offset,
				5
			}
		},
		progress_button_background = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			masked = masked,
			texture_size = {
				progress_bar_size[1],
				progress_bar_size[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				progress_bar_height_offset,
				6
			}
		},
		progress_button_background_fade = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			masked = masked,
			texture_size = {
				progress_bar_size[1] - 10,
				progress_bar_size[2] - 10
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				progress_bar_height_offset + 5,
				7
			}
		},
		progress_button_glass_top = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			masked = masked,
			texture_size = {
				progress_bar_size[1] - 10,
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
				progress_bar_height_offset + progress_bar_size[2] - 17,
				8
			}
		},
		progress_button_glass_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			masked = masked,
			texture_size = {
				progress_bar_size[1] - 10,
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
				progress_bar_height_offset - 3,
				8
			}
		},
		progress_button_hover_glow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			masked = masked,
			texture_size = {
				progress_bar_size[1] - 10,
				progress_bar_size[2] - 10
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				progress_bar_height_offset + 5,
				9
			}
		},
		progress_button_hotspot = {
			size = progress_bar_size,
			offset = {
				size[1] / 2 - progress_bar_size[1] / 2,
				progress_bar_height_offset,
				1
			}
		},
		progress_button_claim_glow = {
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			area_size = progress_bar_size,
			masked = masked,
			texture_size = hover_frame_settings.texture_size,
			texture_sizes = hover_frame_settings.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			frame_margins = {
				-(hover_frame_width - 1),
				-(hover_frame_width - 1)
			},
			offset = {
				0,
				progress_bar_height_offset,
				14
			}
		},
		side_detail_left = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			masked = masked,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-(progress_bar_size[1] / 2 - side_detail_texture_size[1] / 2) - 9,
				progress_bar_height_offset + progress_bar_size[2] / 2 - side_detail_texture_size[2] / 2,
				15
			},
			texture_size = side_detail_texture_size
		},
		side_detail_right = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			masked = masked,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				progress_bar_size[1] / 2 - side_detail_texture_size[1] / 2 + 9,
				progress_bar_height_offset + progress_bar_size[2] / 2 - side_detail_texture_size[2] / 2,
				15
			},
			texture_size = side_detail_texture_size
		},
		hover_glow = {
			masked = masked,
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
			masked = masked,
			texture_size = frame_settings.texture_size,
			texture_sizes = frame_settings.texture_sizes,
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
			masked = masked,
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
			texture_size = size,
			texture_tiling_size = {
				128,
				153
			}
		},
		background_completed = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = masked,
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
			texture_size = size,
			texture_tiling_size = {
				50,
				156
			}
		},
		background_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = masked,
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
			texture_size = size
		},
		title_divider = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			masked = masked,
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
			masked = masked,
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
			masked = masked,
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
			masked = masked,
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
				size[1] - 130 + 25,
				-10,
				11
			}
		},
		dlc_lock = {
			vertical_alignment = "center",
			angle = 0,
			horizontal_alignment = "right",
			masked = masked,
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
			masked = masked,
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
			masked = masked,
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
			masked = masked,
			size = texture_size,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				size[1] - 80 - 2,
				size[2] / 2 - 40,
				12
			}
		},
		reward_icon_background = {
			saturated = false,
			masked = masked,
			size = texture_size,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				size[1] - 80 - 2,
				size[2] / 2 - 40,
				11
			}
		},
		reward_illusion_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = masked,
			texture_size = texture_size,
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
			masked = masked,
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
			masked = masked,
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
	local tbl_6 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_4

	flag_4 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_6.size = {
		progress_bar_size[1],
		progress_bar_size[2]
	}
	tbl_6.offset = {
		size[1] / 2 - progress_bar_size[1] / 2,
		progress_bar_height_offset,
		10
	}
	tbl_5.progress_text = tbl_6

	local tbl_7 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_5

	flag_5 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_7.font_type = flag_5
	tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_7.size = {
		progress_bar_size[1],
		progress_bar_size[2]
	}
	tbl_7.offset = {
		size[1] / 2 - progress_bar_size[1] / 2 + 2,
		progress_bar_height_offset - 2,
		9
	}
	tbl_5.progress_text_shadow = tbl_7

	local tbl_8 = {
		vertical_alignment = "bottom",
		upper_case = true,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_6

	flag_6 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_8.font_type = flag_6
	tbl_8.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_8.size = {
		progress_bar_size[1],
		progress_bar_size[2]
	}
	tbl_8.offset = {
		size[1] / 2 - progress_bar_size[1] / 2,
		4,
		12
	}
	tbl_5.claimed_text = tbl_8

	local tbl_9 = {
		vertical_alignment = "bottom",
		upper_case = true,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_7

	flag_7 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_9.font_type = flag_7
	tbl_9.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_9.size = {
		progress_bar_size[1],
		progress_bar_size[2]
	}
	tbl_9.offset = {
		size[1] / 2 - progress_bar_size[1] / 2 + 2,
		2,
		11
	}
	tbl_5.claimed_text_shadow = tbl_9

	local tbl_10 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_8

	flag_8 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_10.font_type = flag_8
	tbl_10.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_10.size = {
		progress_bar_size[1],
		progress_bar_size[2]
	}
	tbl_10.offset = {
		size[1] / 2 - progress_bar_size[1] / 2,
		progress_bar_height_offset,
		10
	}
	tbl_5.progress_button_text = tbl_10

	local tbl_11 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_9

	flag_9 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_11.font_type = flag_9
	tbl_11.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_11.size = {
		progress_bar_size[1],
		progress_bar_size[2]
	}
	tbl_11.offset = {
		size[1] / 2 - progress_bar_size[1] / 2,
		progress_bar_height_offset,
		10
	}
	tbl_5.progress_button_text_hover = tbl_11

	local tbl_12 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_10

	flag_10 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_12.font_type = flag_10
	tbl_12.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_12.size = {
		progress_bar_size[1],
		progress_bar_size[2]
	}
	tbl_12.offset = {
		size[1] / 2 - progress_bar_size[1] / 2 + 2,
		progress_bar_height_offset - 2,
		9
	}
	tbl_5.progress_button_text_shadow = tbl_12

	local tbl_13 = {
		vertical_alignment = "center",
		upper_case = false,
		font_size = 18,
		horizontal_alignment = "center"
	}
	local flag_11

	flag_11 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_13.font_type = flag_11
	tbl_13.text_color = {
		255,
		155,
		155,
		155
	}
	tbl_13.size = {
		progress_bar_size[1],
		progress_bar_size[2]
	}
	tbl_13.offset = {
		size[1] / 2 - progress_bar_size[1] / 2,
		progress_bar_height_offset,
		10
	}
	tbl_5.progress_button_text_disabled = tbl_13

	local tbl_14 = {
		word_wrap = true,
		upper_case = false,
		font_size = 18,
		font_height_multiplier = 0.9,
		horizontal_alignment = "center",
		vertical_alignment = "center"
	}
	local flag_12

	flag_12 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_14.font_type = flag_12
	tbl_14.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_14.size = {
		size[1] - 300,
		size[2]
	}
	tbl_14.offset = {
		150,
		5,
		12
	}
	tbl_5.description = tbl_14

	local tbl_15 = {
		word_wrap = true,
		upper_case = false,
		font_size = 18,
		font_height_multiplier = 0.9,
		horizontal_alignment = "center",
		vertical_alignment = "center"
	}
	local flag_13

	flag_13 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_15.font_type = flag_13
	tbl_15.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_15.size = {
		size[1] - 300,
		size[2]
	}
	tbl_15.offset = {
		152,
		3,
		11
	}
	tbl_5.description_shadow = tbl_15

	local tbl_16 = {
		font_size = 28,
		upper_case = true,
		horizontal_alignment = "center",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_14

	flag_14 = (not masked or not "hell_shark_header_masked") and not not "hell_shark_header"
	tbl_16.font_type = flag_14
	tbl_16.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_16.offset = {
		size[1] / 2 - 200,
		-7,
		9
	}
	tbl_16.size = {
		400,
		size[2]
	}
	tbl_5.title = tbl_16

	local tbl_17 = {
		font_size = 28,
		upper_case = true,
		horizontal_alignment = "center",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_15

	flag_15 = (not masked or not "hell_shark_header_masked") and not not "hell_shark_header"
	tbl_17.font_type = flag_15
	tbl_17.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_17.offset = {
		size[1] / 2 - 200 + 2,
		-9,
		8
	}
	tbl_17.size = {
		400,
		size[2]
	}
	tbl_5.title_shadow = tbl_17

	local style = tbl_5

	UIWidgets.append_item_frame_pass("reward_frame", passes, content, style, texture_size, {
		-2,
		0,
		15
	}, masked, nil, {
		horizontal_alignment = "right",
		vertical_alignment = "center"
	}, nil, nil)

	widget.element.passes = passes
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget
end

return create_achievement_entry
