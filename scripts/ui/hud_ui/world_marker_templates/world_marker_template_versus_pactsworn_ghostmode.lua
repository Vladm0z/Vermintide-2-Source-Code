-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_pactsworn_ghostmode.lua

WorldMarkerTemplates = WorldMarkerTemplates or {}

local var_0_0 = WorldMarkerTemplates.versus_pactsworn_ghostmode

if not var_0_0 then
	var_0_0 = {}
	WorldMarkerTemplates.versus_pactsworn_ghostmode = var_0_0
end

var_0_0.position_offset = {
	0,
	0,
	2
}
var_0_0.max_distance = 50
var_0_0.screen_clamp = true
var_0_0.only_when_clamped = false
var_0_0.draw_behind = true
var_0_0.screen_margins = {
	down = 150,
	up = 200,
	left = 150,
	right = 150
}

var_0_0.create_widget_definition = function (arg_1_0)
	local var_1_0 = 1
	local var_1_1 = 60 * var_1_0

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (arg_2_0)
						return arg_2_0.is_clamped
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
					content_check_function = function (arg_3_0)
						return arg_3_0.is_clamped
					end
				},
				{
					pass_type = "texture",
					style_id = "checkmark",
					texture_id = "checkmark",
					content_check_function = function (arg_4_0)
						return arg_4_0.countdown_over
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
					70 * var_1_0,
					90 * var_1_0
				},
				default_size = {
					70 * var_1_0,
					90 * var_1_0
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
					11.5 - var_1_1
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
					var_1_1,
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

var_0_0.on_enter = function (arg_5_0)
	local var_5_0 = arg_5_0.content

	var_5_0.just_entered = true
	var_5_0.t = 0
end

var_0_0.update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_1.content
	local var_6_1 = arg_6_1.style
	local var_6_2 = Application.user_setting("toggle_pactsworn_overhead_name_ui")

	if var_6_0.just_entered then
		var_6_0.just_entered = false
		var_6_0.enter_timer = arg_6_5

		local var_6_3 = UIUtils.get_text_width(arg_6_0, var_6_1.ally_name, var_6_0.ally_name)

		var_6_1.checkmark.offset[1] = var_6_2 and -(var_6_3 / 2) - 30 - 10 or 0
	end

	local var_6_4 = math.clamp(0.5 + (1 - var_6_0.forward_dot_dir) * 499.99999999999955, 0, 1)
	local var_6_5 = arg_6_5 - var_6_0.enter_timer
	local var_6_6 = 255 * math.easeOutCubic(math.min(var_6_5, 1)) * var_6_4 * 0.7

	var_6_1.icon.color[1] = var_6_6
	var_6_1.arrow.color[1] = var_6_6
	var_6_1.arrow.angle = var_6_0.angle

	local var_6_7 = var_6_0.is_clamped and 60 or 0

	var_6_1.ally_name.offset[2] = var_6_7
	var_6_1.ally_name_shadow.offset[2] = var_6_7

	local var_6_8 = var_6_2 and var_6_0.player_name or ""

	if UTF8Utils.string_length(var_6_8) > 18 then
		var_6_8 = string.sub(var_6_8, 1, 18) .. "..."
	end

	if var_6_0.respawn_timer and not var_6_0.countdown_over then
		local var_6_9 = var_6_0.respawn_timer - Managers.time:time("game")
		local var_6_10 = var_6_9 <= 0

		var_6_8 = var_6_10 and var_6_8 or string.format("{#size(20);color(255,255,255)}%d{#reset()}  %s", math.abs(var_6_9), var_6_8)
		var_6_0.countdown_over = var_6_10
	end

	if var_6_0.allow_name ~= var_6_2 then
		local var_6_11 = UIUtils.get_text_width(arg_6_0, var_6_1.ally_name, var_6_8)

		var_6_1.checkmark.offset[1] = var_6_2 and -(var_6_11 / 2) - 30 - 10 or 0
		var_6_0.allow_name = var_6_2
	end

	var_6_0.ally_name = var_6_8

	return true
end
