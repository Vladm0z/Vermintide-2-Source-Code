-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_store.lua

local str = "store"
local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

local var_0_2 = WorldMarkerTemplates[str]

var_0_2 = var_0_2 or {}
WorldMarkerTemplates[str] = var_0_2
var_0_2.check_line_of_sight = false
var_0_2.position_offset = {
	0.25,
	0.25,
	0.9
}
var_0_2.screen_clamp = true
var_0_2.screen_clamp_method = "tutorial"
var_0_2.distance_from_center = {
	width = 400,
	height = 200
}
var_0_2.scale_settings = {
	end_scale_distance = 100,
	start_scale_distance = 10,
	min_scale = 0.5
}

var_0_2.create_widget_definition = function (arg_1_0)
	-- function 1
	local num = 1

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
					content_check_function = function (self)
						-- function 2
						return self.show_star
					end
				},
				{
					texture_id = "arrow",
					style_id = "arrow",
					pass_type = "rotated_texture",
					content_check_function = function (arg_3_0, arg_3_1)
						-- function 3
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
					num * 64,
					num * 64
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

var_0_2.on_enter = function (arg_4_0)
	-- function 4
	arg_4_0.content.progress = 1
end

local function fn(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local num = 1.57079633
	local num_2 = 0
	local num_3 = 0
	local num_4 = 0
	local atan2 = math.atan2(arg_5_1, arg_5_0)

	if not (not (arg_5_4 < -400) or not (arg_5_0 > 0.6)) then
		num_3 = -(arg_5_3[2] * 0.5 + arg_5_2[2])
		num = num * 2
	elseif not (not (arg_5_4 > 400) or not (arg_5_0 > 0.6)) then
		num_3 = arg_5_3[2] * 0.5 + arg_5_2[2]
		num = 0
	elseif atan2 >= 0 then
		num_2 = arg_5_3[2] * 0.5 + arg_5_2[2]
	elseif atan2 < 0 then
		num_2 = -(arg_5_3[2] * 0.5 + arg_5_2[2])
		num = -num
	end

	return num, num_2, num_3, num_4
end

var_0_2.update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local content = arg_6_1.content
	local style = arg_6_1.style
	local icon = style.icon
	local star = style.star
	local arrow = style.arrow
	local is_clamped = content.is_clamped
	local num = 100
	local color = icon.color
	local flag

	flag = not is_clamped and 100 and 255
	color[1] = flag

	local color_2 = star.color
	local flag_2

	flag_2 = not is_clamped and 100 and 200
	color_2[1] = flag_2

	local color_3 = arrow.color
	local flag_3

	flag_3 = not is_clamped and 100 and 0
	color_3[1] = flag_3
	arrow.angle = content.angle

	local var_6_13, var_6_14, var_6_15, var_6_16 = fn(content.forward_dot_flat, content.right_dot_flat, arrow.texture_size, icon.texture_size, arg_6_1.offset[2] - 540)

	arrow.angle = var_6_13
	arrow.offset[1] = var_6_14
	arrow.offset[2] = var_6_15
	arrow.offset[3] = var_6_16
	arg_6_1.alpha_multiplier = 1

	if not (not content.show_star and ItemHelper.has_unseen_shop_items()) then
		content.show_star = false
	end

	return false
end
