-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_objective.lua

WorldMarkerTemplates = WorldMarkerTemplates or {}

local var_0_0 = WorldMarkerTemplates.versus_objective

if not var_0_0 then
	var_0_0 = {}
	WorldMarkerTemplates.versus_objective = var_0_0
end

var_0_0.position_offset = {
	0,
	0,
	2
}
var_0_0.max_distance = nil
var_0_0.screen_clamp = true
var_0_0.screen_margins = {
	down = 150,
	up = 200,
	left = 150,
	right = 150
}

function var_0_0.create_widget_definition(arg_1_0)
	local var_1_0 = 0.5
	local var_1_1 = 60 * var_1_0

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
					style_id = "background_pulse_1",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "background_pulse_2",
					texture_id = "background"
				},
				{
					pass_type = "rotated_texture",
					style_id = "arrow",
					texture_id = "arrow",
					content_check_function = function(arg_2_0)
						return arg_2_0.is_clamped
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_3_0)
						return arg_3_0.is_clamped or arg_3_0.distance > 5
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_4_0)
						return arg_4_0.is_clamped or arg_4_0.distance > 5
					end
				}
			}
		},
		content = {
			text = "",
			background = "versus_world_marker_objective_border",
			value = "2",
			icon = "versus_hud_marker_objective",
			arrow = "versus_world_marker_objective_arrow"
		},
		style = {
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					80 * var_1_0,
					80 * var_1_0
				},
				default_size = {
					80 * var_1_0,
					80 * var_1_0
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
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					100 * var_1_0,
					100 * var_1_0
				},
				default_size = {
					100 * var_1_0,
					100 * var_1_0
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
			background_pulse_1 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					100 * var_1_0,
					100 * var_1_0
				},
				default_size = {
					100 * var_1_0,
					100 * var_1_0
				},
				color = {
					200,
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
					100 * var_1_0,
					100 * var_1_0
				},
				default_size = {
					100 * var_1_0,
					100 * var_1_0
				},
				color = {
					200,
					255,
					255,
					255
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
					170,
					170,
					170
				},
				offset = {
					-50,
					-55,
					3
				}
			},
			text_shadow = {
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
					0,
					0,
					0
				},
				offset = {
					-49,
					-56,
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

function var_0_0.on_enter(arg_5_0)
	local var_5_0 = arg_5_0.content
	local var_5_1 = Managers.state.entity:system("objective_system")

	arg_5_0.content.icon = var_5_1:current_objective_icon()
	var_5_0.just_entered = true
	var_5_0.t = 0
end

function var_0_0.update_function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_1.content
	local var_6_1 = arg_6_1.style

	if var_6_0.just_entered then
		var_6_0.just_entered = false
		var_6_0.enter_timer = arg_6_5
	end

	local var_6_2 = math.clamp(0.5 + (1 - var_6_0.forward_dot_dir) * 499.99999999999955, 0, 1)
	local var_6_3 = arg_6_5 - var_6_0.enter_timer
	local var_6_4 = 255 * math.easeOutCubic(math.min(var_6_3, 1)) * var_6_2
	local var_6_5 = var_6_4 * 0.7

	var_6_1.icon.color[1] = var_6_5
	var_6_1.background.color[1] = var_6_5
	var_6_1.arrow.color[1] = var_6_5
	var_6_1.text.text_color[1] = var_6_4
	var_6_1.text_shadow.text_color[1] = var_6_4
	var_6_1.arrow.angle = var_6_0.angle

	local var_6_6 = var_6_0.distance

	var_6_0.text = var_6_6 > 1 and UIUtils.comma_value(math.floor(var_6_6)) .. "m" or ""

	local var_6_7 = math.min(1, 15 / var_6_6)
	local var_6_8 = var_6_0.t + arg_6_4 * var_6_7

	var_6_0.t = var_6_8

	for iter_6_0 = 1, 2 do
		local var_6_9 = 1 - (1 - (var_6_8 + 0.5 * iter_6_0) % 1)^2
		local var_6_10 = var_6_1["background_pulse_" .. iter_6_0]
		local var_6_11 = var_6_10.texture_size
		local var_6_12 = var_6_10.default_size

		var_6_11[1] = var_6_12[1] * (1 + var_6_9)
		var_6_11[2] = var_6_12[2] * (1 + var_6_9)
		var_6_10.color[1] = 255 * (1 - var_6_9) * var_6_7 * var_6_2
	end

	return true
end
