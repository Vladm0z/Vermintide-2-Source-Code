-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_ping.lua

WorldMarkerTemplates = WorldMarkerTemplates or {}

local var_0_0 = "ping"
local var_0_1 = WorldMarkerTemplates[var_0_0] or {}

WorldMarkerTemplates[var_0_0] = var_0_1
var_0_1.max_distance = 200
var_0_1.screen_clamp = true
var_0_1.life_time = 15
var_0_1.position_offset = {
	0,
	0,
	0.5
}
var_0_1.screen_margins = {
	down = 150,
	up = 150,
	left = 150,
	right = 150
}

local var_0_2 = {
	"world_marker_response_1",
	"world_marker_response_2",
	"world_marker_response_3"
}
local var_0_3 = {
	"world_marker_icon_response_1",
	"world_marker_icon_response_2",
	"world_marker_icon_response_3"
}

var_0_1.create_widget_definition = function (arg_1_0)
	local var_1_0 = 25

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon_bg",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "world_marker_icon_response_1",
					texture_id = "world_marker_icon_response_1",
					content_check_function = function (arg_2_0)
						return arg_2_0.world_marker_response_1.show
					end
				},
				{
					pass_type = "texture",
					style_id = "world_marker_icon_response_2",
					texture_id = "world_marker_icon_response_2",
					content_check_function = function (arg_3_0)
						return arg_3_0.world_marker_response_2.show
					end
				},
				{
					pass_type = "texture",
					style_id = "world_marker_icon_response_3",
					texture_id = "world_marker_icon_response_3",
					content_check_function = function (arg_4_0)
						return arg_4_0.world_marker_response_3.show
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_spawn_pulse",
					texture_id = "icon_pulse"
				},
				{
					pass_type = "rotated_texture",
					style_id = "arrow",
					texture_id = "arrow",
					content_check_function = function (arg_5_0)
						return arg_5_0.is_clamped
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_6_0)
						return Managers.mechanism:current_mechanism_name() ~= "versus"
					end
				},
				{
					style_id = "distance_text",
					pass_type = "text",
					text_id = "distance_text"
				}
			}
		},
		content = {
			icon_pulse = "ping_friendly",
			text = "",
			world_marker_icon_response_2 = "world_marker_ping_response_2",
			world_marker_icon_response_1 = "world_marker_ping_response_1",
			arrow = "console_consumable_icon_arrow_02",
			icon = "ping_friendly",
			distance_text = "",
			world_marker_icon_response_3 = "world_marker_ping_response_3"
		},
		style = {
			icon_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					41,
					41
				},
				default_size = {
					41,
					41
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					1
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					40,
					40
				},
				default_size = {
					40,
					40
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
					2
				}
			},
			icon_spawn_pulse = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					40,
					40
				},
				default_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				default_color = {
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
			world_marker_icon_response_1 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					28,
					36
				},
				default_size = {
					28,
					36
				},
				color = {
					255,
					255,
					255,
					255
				},
				default_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-14,
					18,
					0
				},
				default_offset = {
					-14,
					18,
					0
				}
			},
			world_marker_icon_response_2 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					28,
					36
				},
				default_size = {
					28,
					36
				},
				color = {
					255,
					255,
					255,
					255
				},
				default_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					14,
					18,
					0
				},
				default_offset = {
					14,
					18,
					0
				}
			},
			world_marker_icon_response_3 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					56,
					36
				},
				default_size = {
					56,
					36
				},
				color = {
					255,
					255,
					255,
					255
				},
				default_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-18,
					0
				},
				default_offset = {
					0,
					-18,
					0
				}
			},
			arrow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 0,
				pivot = {
					7 + var_1_0,
					15
				},
				texture_size = {
					14,
					30
				},
				default_size = {
					14,
					30
				},
				color = {
					255,
					160,
					160,
					160
				},
				offset = {
					-var_1_0,
					0,
					0
				}
			},
			text = {
				word_wrap = false,
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					150,
					75
				},
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-75,
					-75,
					2
				}
			},
			distance_text = {
				word_wrap = false,
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					150,
					150
				},
				text_color = {
					255,
					216,
					216,
					216
				},
				offset = {
					-75,
					-102,
					2
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

var_0_1.on_enter = function (arg_7_0)
	local var_7_0 = arg_7_0.content

	var_7_0.spawn_progress_timer = 0
	var_7_0.world_marker_response_1 = {}
	var_7_0.world_marker_response_2 = {}
	var_7_0.world_marker_response_3 = {}
end

local function var_0_4(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0 = arg_8_0 + arg_8_1

	local var_8_0 = math.min(arg_8_0 / 1, 1)
	local var_8_1 = math.easeOutCubic(var_8_0)
	local var_8_2 = arg_8_2.color
	local var_8_3 = arg_8_2.default_color
	local var_8_4 = arg_8_2.texture_size
	local var_8_5 = arg_8_2.default_size

	var_8_4[1] = var_8_5[1] + var_8_5[1] * var_8_1
	var_8_4[2] = var_8_5[2] + var_8_5[2] * var_8_1
	var_8_2[1] = var_8_3[1] - var_8_3[1] * var_8_1

	return var_8_0, var_8_0 ~= 1
end

local function var_0_5(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0 = arg_9_0 + arg_9_1 * 10

	local var_9_0 = math.min(arg_9_0 / 1, 1)
	local var_9_1 = 1 - math.easeOutCubic(var_9_0)
	local var_9_2 = arg_9_2.color
	local var_9_3 = arg_9_2.default_color
	local var_9_4 = arg_9_2.texture_size
	local var_9_5 = arg_9_2.default_size
	local var_9_6 = arg_9_2.offset
	local var_9_7 = arg_9_2.default_offset

	var_9_6[1] = var_9_7[1] + var_9_7[1] * 100 * var_9_1
	var_9_6[2] = var_9_7[2] + var_9_7[2] * 100 * var_9_1
	var_9_4[1] = var_9_5[1] + var_9_5[1] * 2 * var_9_1
	var_9_4[2] = var_9_5[2] + var_9_5[2] * 2 * var_9_1
	var_9_2[1] = var_9_3[1] - var_9_3[1] * var_9_1

	return var_9_0, var_9_0 ~= 1
end

var_0_1.update_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = arg_10_1.content
	local var_10_1 = arg_10_1.style
	local var_10_2 = var_10_0.is_inside_frustum
	local var_10_3 = var_10_0.is_under
	local var_10_4 = var_10_0.distance
	local var_10_5 = var_10_0.angle

	if var_10_0.spawn_progress_timer then
		local var_10_6, var_10_7 = var_0_4(var_10_0.spawn_progress_timer, arg_10_4, var_10_1.icon_spawn_pulse)

		var_10_0.spawn_progress_timer = var_10_7 and var_10_6 or nil
	end

	for iter_10_0 = 1, 3 do
		local var_10_8 = var_0_2[iter_10_0]
		local var_10_9 = var_10_0[var_10_8]

		if var_10_9.timer then
			local var_10_10 = var_0_3[iter_10_0]
			local var_10_11, var_10_12 = var_0_5(var_10_9.timer, arg_10_4, var_10_1[var_10_10])

			var_10_0[var_10_8].timer = var_10_12 and var_10_11 or nil
		end
	end

	var_10_1.arrow.angle = var_10_5 + math.pi * 0.5
	var_10_0.distance_text = var_10_4 > 1 and tostring(UIUtils.comma_value(math.floor(var_10_4))) .. "m" or ""

	local var_10_13 = math.clamp(0.3 + (1 - var_10_0.forward_dot_dir) * 499.99999999999955, 0, 1)

	if var_10_13 ~= 1 then
		local var_10_14 = 255 * var_10_13

		var_10_1.icon.color[1] = var_10_14
		var_10_1.icon_bg.color[1] = var_10_14
		var_10_1.arrow.color[1] = var_10_14
		var_10_1.text.text_color[1] = var_10_14
	end

	return true
end
