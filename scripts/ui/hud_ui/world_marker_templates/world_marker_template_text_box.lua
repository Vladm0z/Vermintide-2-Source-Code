-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_text_box.lua

WorldMarkerTemplates = WorldMarkerTemplates or {}

local var_0_0 = "text_box"
local var_0_1 = WorldMarkerTemplates[var_0_0] or {}

WorldMarkerTemplates[var_0_0] = var_0_1
var_0_1.max_distance = 20
var_0_1.screen_clamp = false
var_0_1.screen_margins = nil

function var_0_1.create_widget_definition(arg_1_0)
	local var_1_0 = "shadow_frame_02"
	local var_1_1 = UIFrameSettings[var_1_0]
	local var_1_2 = var_1_1.texture_sizes.horizontal[2]

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function(arg_2_0)
						local var_2_0 = arg_2_0.scale_progress

						return var_2_0 and var_2_0 < 1
					end
				},
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_3_0)
						local var_3_0 = arg_3_0.text_progress

						return var_3_0 and var_3_0 > 0
					end
				}
			}
		},
		content = {
			icon = "icon_property_stamina",
			text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
			icon_pulse = "icon_property_stamina",
			frame = var_1_1.texture
		},
		style = {
			text = {
				word_wrap = true,
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					200,
					200
				},
				text_color = {
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
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				default_size = {
					50,
					50
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
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				default_size = {
					50,
					50
				},
				color = {
					150,
					10,
					10,
					10
				},
				offset = {
					0,
					0,
					0
				}
			},
			frame = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				area_size = {
					50,
					50
				},
				default_size = {
					50,
					50
				},
				frame_margins = {
					-var_1_2,
					-var_1_2
				},
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
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

function var_0_1.check_widget_visible(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.style.background.texture_size

	if arg_4_2 and arg_4_2 > var_4_0[1] * 0.5 then
		return false
	end

	if arg_4_1 and arg_4_1 > var_4_0[2] * 0.5 then
		return false
	end

	return true
end

function var_0_1.on_enter(arg_5_0)
	arg_5_0.content.spawn_progress_timer = 0
end

function var_0_1.update_function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = false
	local var_6_1 = arg_6_1.content
	local var_6_2 = arg_6_1.style
	local var_6_3 = var_6_1.is_under
	local var_6_4 = var_6_1.distance
	local var_6_5 = var_6_1.angle
	local var_6_6 = 3
	local var_6_7 = var_6_1.scale_progress or 0
	local var_6_8 = var_6_1.text_progress or 0

	if var_6_4 <= 5 then
		var_6_7 = math.min(var_6_7 + arg_6_4 * var_6_6, 1)
	elseif var_6_8 == 0 then
		var_6_7 = math.max(var_6_7 - arg_6_4 * var_6_6, 0)
	end

	if var_6_7 == 1 and var_6_4 <= 5 then
		var_6_8 = math.min(var_6_8 + arg_6_4 * var_6_6, 1)
	else
		var_6_8 = math.max(var_6_8 - arg_6_4 * var_6_6, 0)
	end

	local var_6_9 = math.easeCubic(var_6_8)
	local var_6_10 = math.easeCubic(var_6_7)
	local var_6_11 = var_6_1.text
	local var_6_12 = var_6_2.text
	local var_6_13 = var_6_12.size
	local var_6_14 = var_6_12.offset
	local var_6_15 = var_6_12.text_color
	local var_6_16 = var_6_1.text_width
	local var_6_17 = var_6_1.text_height

	if not var_6_16 then
		var_6_16 = UIUtils.get_text_width(arg_6_0, var_6_12, var_6_11)
		var_6_16 = math.min(var_6_16, 600)
		var_6_13[1] = var_6_16
		var_6_17 = UIUtils.get_text_height(arg_6_0, var_6_13, var_6_12, var_6_11)
		var_6_1.text_width = var_6_16
		var_6_1.text_height = var_6_17
	end

	var_6_15[1] = 255 * var_6_9
	var_6_2.icon.color[1] = 255 - 255 * var_6_7

	local var_6_18 = var_6_2.background
	local var_6_19 = var_6_18.color
	local var_6_20 = var_6_18.texture_size
	local var_6_21 = var_6_18.default_size
	local var_6_22 = var_6_16 * var_6_10
	local var_6_23 = var_6_17 * var_6_10

	var_6_20[1] = var_6_21[1] + var_6_22
	var_6_20[2] = var_6_21[2] + var_6_23

	local var_6_24 = var_6_2.frame.area_size

	var_6_24[1] = var_6_20[1]
	var_6_24[2] = var_6_20[2]
	var_6_13[1] = var_6_16
	var_6_13[2] = var_6_17
	var_6_14[1] = -var_6_16 / 2
	var_6_14[2] = -var_6_17 / 2

	local var_6_25 = var_6_7 ~= var_6_1.scale_progress or var_6_8 ~= var_6_1.text_progress

	var_6_1.scale_progress = var_6_7
	var_6_1.text_progress = var_6_8

	return var_6_25
end
