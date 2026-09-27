-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_text_box.lua

local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

local str = "text_box"
local var_0_2 = WorldMarkerTemplates[str]

var_0_2 = var_0_2 or {}
WorldMarkerTemplates[str] = var_0_2
var_0_2.max_distance = 20
var_0_2.screen_clamp = false
var_0_2.screen_margins = nil

var_0_2.create_widget_definition = function (arg_1_0)
	-- function 1
	local str = "shadow_frame_02"
	local var_1_1 = UIFrameSettings[str]
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
					content_check_function = function (self)
						-- function 2
						local scale_progress = self.scale_progress

						return not scale_progress and scale_progress < 1
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
					content_check_function = function (self)
						-- function 3
						local text_progress = self.text_progress

						return not text_progress and text_progress > 0
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

var_0_2.check_widget_visible = function (self, arg_4_1, arg_4_2)
	-- function 4
	local texture_size = self.style.background.texture_size

	if not (not arg_4_2 and not (arg_4_2 > texture_size[1] * 0.5)) then
		return false
	end

	if not (not arg_4_1 and not (arg_4_1 > texture_size[2] * 0.5)) then
		return false
	end

	return true
end

var_0_2.on_enter = function (arg_5_0)
	-- function 5
	arg_5_0.content.spawn_progress_timer = 0
end

var_0_2.update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local flag = false
	local content = arg_6_1.content
	local style = arg_6_1.style
	local is_under = content.is_under
	local distance = content.distance
	local angle = content.angle
	local num = 3
	local scale_progress = content.scale_progress

	scale_progress = scale_progress or 0

	local text_progress = content.text_progress

	text_progress = text_progress or 0

	if distance <= 5 then
		scale_progress = math.min(scale_progress + arg_6_4 * num, 1)
	elseif text_progress == 0 then
		scale_progress = math.max(scale_progress - arg_6_4 * num, 0)
	end

	if not (scale_progress ~= 1 or not (distance <= 5)) then
		text_progress = math.min(text_progress + arg_6_4 * num, 1)
	else
		text_progress = math.max(text_progress - arg_6_4 * num, 0)
	end

	local easeCubic = math.easeCubic(text_progress)
	local easeCubic_2 = math.easeCubic(scale_progress)
	local text = content.text
	local text_2 = style.text
	local size = text_2.size
	local offset = text_2.offset
	local text_color = text_2.text_color
	local text_width = content.text_width
	local text_height = content.text_height

	if not text_width then
		text_width = UIUtils.get_text_width(arg_6_0, text_2, text)
		text_width = math.min(text_width, 600)
		size[1] = text_width
		text_height = UIUtils.get_text_height(arg_6_0, size, text_2, text)
		content.text_width = text_width
		content.text_height = text_height
	end

	text_color[1] = 255 * easeCubic
	style.icon.color[1] = 255 - 255 * scale_progress

	local background = style.background
	local color = background.color
	local texture_size = background.texture_size
	local default_size = background.default_size
	local num_2 = text_width * easeCubic_2
	local num_3 = text_height * easeCubic_2

	texture_size[1] = default_size[1] + num_2
	texture_size[2] = default_size[2] + num_3

	local area_size = style.frame.area_size

	area_size[1] = texture_size[1]
	area_size[2] = texture_size[2]
	size[1] = text_width
	size[2] = text_height
	offset[1] = -text_width / 2
	offset[2] = -text_height / 2

	local flag_2 = scale_progress ~= content.scale_progress or text_progress ~= content.text_progress

	content.scale_progress = scale_progress
	content.text_progress = text_progress

	return flag_2
end
