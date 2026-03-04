-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_news_feed.lua

WorldMarkerTemplates = WorldMarkerTemplates or {}

local var_0_0 = "news_feed"
local var_0_1 = WorldMarkerTemplates[var_0_0] or {}

WorldMarkerTemplates[var_0_0] = var_0_1
var_0_1.position_offset = {
	0,
	0,
	2
}
var_0_1.max_distance = nil
var_0_1.screen_clamp = true
var_0_1.screen_margins = {
	down = 150,
	up = 150,
	left = 150,
	right = 150
}

var_0_1.create_widget_definition = function (arg_1_0)
	local var_1_0 = 25

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "icon_pulse",
					texture_id = "icon_pulse"
				},
				{
					pass_type = "texture",
					style_id = "background_pulse_1",
					texture_id = "background_pulse_1"
				},
				{
					pass_type = "texture",
					style_id = "background_pulse_2",
					texture_id = "background_pulse_2"
				},
				{
					pass_type = "rotated_texture",
					style_id = "arrow",
					texture_id = "arrow",
					content_check_function = function (arg_2_0)
						return arg_2_0.is_clamped
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_3_0)
						return arg_3_0.is_clamped or arg_3_0.distance > 5
					end
				}
			}
		},
		content = {
			icon_pulse = "icon_new_star",
			background_pulse_2 = "crosshair_03_large",
			text = "",
			background_pulse_1 = "crosshair_03_large",
			icon = "icon_new_star",
			arrow = "page_button_arrow_glow"
		},
		style = {
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					35,
					35
				},
				default_size = {
					35,
					35
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
			icon_pulse = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					35,
					35
				},
				default_size = {
					35,
					35
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
					4
				}
			},
			background_pulse_1 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					111,
					111
				},
				default_size = {
					111,
					111
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
					1
				}
			},
			background_pulse_2 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					150,
					150
				},
				default_size = {
					150,
					150
				},
				color = {
					255,
					80,
					80,
					80
				},
				offset = {
					0,
					0,
					0
				}
			},
			arrow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 0,
				pivot = {
					21.5 + var_1_0,
					24
				},
				texture_size = {
					43,
					48
				},
				default_size = {
					43,
					48
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_1_0,
					0,
					0
				}
			},
			text = {
				word_wrap = true,
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					100,
					50
				},
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-50,
					-50,
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

var_0_1.on_enter = function (arg_4_0)
	arg_4_0.content.spawn_progress_timer = 0
end

var_0_1.update_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = false
	local var_5_1 = arg_5_1.content
	local var_5_2 = arg_5_1.style
	local var_5_3 = var_5_1.is_inside_frustum
	local var_5_4 = var_5_1.is_under
	local var_5_5 = var_5_1.distance
	local var_5_6 = var_5_1.angle
	local var_5_7 = var_5_1.spawn_progress_timer

	if var_5_7 then
		local var_5_8 = var_5_7 + arg_5_4
		local var_5_9 = 1
		local var_5_10 = math.min(var_5_8 / var_5_9, 1)
		local var_5_11 = math.easeOutCubic(var_5_10)
		local var_5_12 = math.easeInCubic(1 - var_5_10)

		var_5_1.spawn_progress_timer = var_5_10 ~= 1 and var_5_8 or nil

		local var_5_13 = var_5_2.icon_pulse
		local var_5_14 = var_5_13.color
		local var_5_15 = var_5_13.texture_size
		local var_5_16 = var_5_13.default_size

		var_5_15[1] = var_5_16[1] + var_5_16[1] * var_5_12
		var_5_15[2] = var_5_16[1] + var_5_16[2] * var_5_12
		var_5_14[1] = 255 - 255 * var_5_11

		for iter_5_0 = 1, 2 do
			local var_5_17 = var_5_2["background_pulse_" .. iter_5_0]
			local var_5_18 = var_5_17.color
			local var_5_19 = var_5_17.texture_size
			local var_5_20 = var_5_17.default_size

			var_5_19[1] = var_5_20[1] - var_5_20[1] * var_5_12
			var_5_19[2] = var_5_20[1] - var_5_20[2] * var_5_12
			var_5_18[1] = 255 - 255 * var_5_11
		end

		var_5_0 = true
	end

	var_5_2.arrow.angle = var_5_6 + math.pi * 0.5
	var_5_1.text = var_5_5 > 1 and tostring(UIUtils.comma_value(math.floor(var_5_5))) .. "m" or ""

	return var_5_0
end
