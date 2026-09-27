-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_pactsworn_ghostmode.lua

local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

local versus_pactsworn_ghostmode = WorldMarkerTemplates.versus_pactsworn_ghostmode

if not versus_pactsworn_ghostmode then
	versus_pactsworn_ghostmode = {}
	WorldMarkerTemplates.versus_pactsworn_ghostmode = versus_pactsworn_ghostmode
end

versus_pactsworn_ghostmode.position_offset = {
	0,
	0,
	2
}
versus_pactsworn_ghostmode.max_distance = 50
versus_pactsworn_ghostmode.screen_clamp = true
versus_pactsworn_ghostmode.only_when_clamped = false
versus_pactsworn_ghostmode.draw_behind = true
versus_pactsworn_ghostmode.screen_margins = {
	down = 150,
	up = 200,
	left = 150,
	right = 150
}

versus_pactsworn_ghostmode.create_widget_definition = function (arg_1_0)
	-- function 1
	local num = 1
	local num_2 = 60 * num

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 2
						return self.is_clamped
					end
				},
				{
					style_id = "ally_name",
					pass_type = "text",
					text_id = "ally_name"
				},
				{
					style_id = "ally_name_shadow",
					pass_type = "text",
					text_id = "ally_name"
				},
				{
					pass_type = "rotated_texture",
					style_id = "arrow",
					texture_id = "arrow",
					content_check_function = function (self)
						-- function 3
						return self.is_clamped
					end
				},
				{
					pass_type = "texture",
					style_id = "checkmark",
					texture_id = "checkmark",
					content_check_function = function (self)
						-- function 4
						return self.countdown_over
					end
				}
			}
		},
		content = {
			checkmark = "matchmaking_checkbox",
			player_name = "player_name",
			ally_name = "ally_name",
			icon = "versus_hud_marker_objective",
			arrow = "versus_world_marker_objective_arrow"
		},
		style = {
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					70 * num,
					90 * num
				},
				default_size = {
					70 * num,
					90 * num
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
			arrow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 0,
				pivot = {
					22,
					11.5 - num_2
				},
				texture_size = {
					44,
					23
				},
				default_size = {
					44,
					23
				},
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
				}
			},
			ally_name = {
				font_type = "hell_shark",
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					200,
					30
				},
				area_size = {
					200,
					30
				},
				text_color = Colors.get_color_table_with_alpha("local_player_team", 255),
				offset = {
					-100,
					60,
					3
				}
			},
			ally_name_shadow = {
				font_type = "hell_shark",
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					200,
					30
				},
				area_size = {
					200,
					30
				},
				text_color = {
					255,
					30,
					30,
					30
				},
				offset = {
					-99,
					59,
					2
				}
			},
			checkmark = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = {
					30,
					25
				},
				offset = {
					0,
					5,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

versus_pactsworn_ghostmode.on_enter = function (self)
	-- function 5
	local content = self.content

	content.just_entered = true
	content.t = 0
end

versus_pactsworn_ghostmode.update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local content = arg_6_1.content
	local style = arg_6_1.style
	local user_setting = Application.user_setting("toggle_pactsworn_overhead_name_ui")

	if not content.just_entered then
		content.just_entered = false
		content.enter_timer = arg_6_5

		local get_text_width = UIUtils.get_text_width(arg_6_0, style.ally_name, content.ally_name)
		local offset = style.checkmark.offset
		local num

		if not user_setting then
			num = -(get_text_width / 2) - 30 - 10

			if not num then
				-- Nothing
			end
		end

		num = 0

		::label_6_0::

		offset[1] = num
	end

	local clamp = math.clamp(0.5 + (1 - content.forward_dot_dir) * 499.99999999999955, 0, 1)
	local num_2 = arg_6_5 - content.enter_timer
	local num_3 = 255 * math.easeOutCubic(math.min(num_2, 1)) * clamp * 0.7

	style.icon.color[1] = num_3
	style.arrow.color[1] = num_3
	style.arrow.angle = content.angle

	local flag

	flag = not content.is_clamped and 60 and 0
	style.ally_name.offset[2] = flag
	style.ally_name_shadow.offset[2] = flag

	local player_name

	if not user_setting then
		player_name = content.player_name

		if not player_name then
			-- Nothing
		end
	end

	player_name = ""

	::label_6_1::

	if Utf8.length(player_name) > 18 then
		player_name = string.sub(player_name, 1, 18) .. "..."
	end

	if not (not content.respawn_timer and content.countdown_over) then
		local num_4 = content.respawn_timer - Managers.time:time("game")
		local flag_2 = num_4 <= 0

		player_name = not flag_2 and player_name and string.format("{#size(20);color(255,255,255)}%d{#reset()}  %s", math.abs(num_4), player_name)
		content.countdown_over = flag_2
	end

	if content.allow_name ~= user_setting then
		local get_text_width_2 = UIUtils.get_text_width(arg_6_0, style.ally_name, player_name)
		local offset_2 = style.checkmark.offset
		local num_5

		if not user_setting then
			num_5 = -(get_text_width_2 / 2) - 30 - 10

			if not num_5 then
				-- Nothing
			end
		end

		num_5 = 0

		::label_6_2::

		offset_2[1] = num_5
		content.allow_name = user_setting
	end

	content.ally_name = player_name

	return true
end
