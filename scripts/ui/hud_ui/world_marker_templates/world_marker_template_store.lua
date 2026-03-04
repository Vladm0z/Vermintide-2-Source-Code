-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_store.lua

local var_0_0 = "store"

WorldMarkerTemplates = WorldMarkerTemplates or {}

local var_0_1 = WorldMarkerTemplates[var_0_0] or {}

WorldMarkerTemplates[var_0_0] = var_0_1
var_0_1.check_line_of_sight = false
var_0_1.position_offset = {
	0.25,
	0.25,
	0.9
}
var_0_1.screen_clamp = true
var_0_1.screen_clamp_method = "tutorial"
var_0_1.distance_from_center = {
	width = 400,
	height = 200
}
var_0_1.scale_settings = {
	end_scale_distance = 100,
	start_scale_distance = 10,
	min_scale = 0.5
}

function var_0_1.create_widget_definition(arg_1_0)
	local var_1_0 = 1

	return {
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "star",
					texture_id = "star",
					content_check_function = function(arg_2_0)
						return arg_2_0.show_star
					end
				},
				{
					texture_id = "arrow",
					style_id = "arrow",
					pass_type = "rotated_texture",
					content_check_function = function(arg_3_0, arg_3_1)
						return arg_3_1.color[1] > 0
					end
				}
			}
		},
		content = {
			arrow = "indicator",
			icon = "hud_store_icon",
			star = "list_item_tag_new",
			show_star = true
		},
		style = {
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					0,
					0
				},
				offset = {
					0,
					0,
					0
				},
				default_size = {
					var_1_0 * 64,
					var_1_0 * 64
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			star = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					126,
					51
				},
				offset = {
					0,
					25,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			arrow = {
				vertical_alignment = "center",
				angle = 0,
				horizontal_alignment = "center",
				texture_size = {
					38,
					18
				},
				pivot = {
					19,
					9
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		}
	}
end

function var_0_1.on_enter(arg_4_0)
	arg_4_0.content.progress = 1
end

local function var_0_2(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = 1.57079633
	local var_5_1 = 0
	local var_5_2 = 0
	local var_5_3 = 0
	local var_5_4 = math.atan2(arg_5_1, arg_5_0)

	if arg_5_4 < -400 and arg_5_0 > 0.6 then
		var_5_2 = -(arg_5_3[2] * 0.5 + arg_5_2[2])
		var_5_0 = var_5_0 * 2
	elseif arg_5_4 > 400 and arg_5_0 > 0.6 then
		var_5_2 = arg_5_3[2] * 0.5 + arg_5_2[2]
		var_5_0 = 0
	elseif var_5_4 >= 0 then
		var_5_1 = arg_5_3[2] * 0.5 + arg_5_2[2]
	elseif var_5_4 < 0 then
		var_5_1 = -(arg_5_3[2] * 0.5 + arg_5_2[2])
		var_5_0 = -var_5_0
	end

	return var_5_0, var_5_1, var_5_2, var_5_3
end

function var_0_1.update_function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_1.content
	local var_6_1 = arg_6_1.style
	local var_6_2 = var_6_1.icon
	local var_6_3 = var_6_1.star
	local var_6_4 = var_6_1.arrow
	local var_6_5 = var_6_0.is_clamped
	local var_6_6 = 100

	var_6_2.color[1] = var_6_5 and 100 or 255
	var_6_3.color[1] = var_6_5 and 100 or 200
	var_6_4.color[1] = var_6_5 and 100 or 0
	var_6_4.angle = var_6_0.angle

	local var_6_7, var_6_8, var_6_9, var_6_10 = var_0_2(var_6_0.forward_dot_flat, var_6_0.right_dot_flat, var_6_4.texture_size, var_6_2.texture_size, arg_6_1.offset[2] - 540)

	var_6_4.angle = var_6_7
	var_6_4.offset[1] = var_6_8
	var_6_4.offset[2] = var_6_9
	var_6_4.offset[3] = var_6_10
	arg_6_1.alpha_multiplier = 1

	if var_6_0.show_star and not ItemHelper.has_unseen_shop_items() then
		var_6_0.show_star = false
	end

	return false
end
