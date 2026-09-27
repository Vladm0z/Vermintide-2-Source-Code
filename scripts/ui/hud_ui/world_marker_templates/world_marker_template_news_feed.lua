-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_news_feed.lua

local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

local str = "news_feed"
local var_0_2 = WorldMarkerTemplates[str]

var_0_2 = var_0_2 or {}
WorldMarkerTemplates[str] = var_0_2
var_0_2.position_offset = {
	0,
	0,
	2
}
var_0_2.max_distance = nil
var_0_2.screen_clamp = true
var_0_2.screen_margins = {
	down = 150,
	up = 150,
	left = 150,
	right = 150
}

var_0_2.create_widget_definition = function (arg_1_0)
	-- function 1
	local num = 25

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
					content_check_function = function (self)
						-- function 2
						return self.is_clamped
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 3
						local is_clamped = self.is_clamped

						is_clamped = is_clamped or self.distance > 5

						return is_clamped
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
					21.5 + num,
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
					-num,
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

var_0_2.on_enter = function (arg_4_0)
	-- function 4
	arg_4_0.content.spawn_progress_timer = 0
end

var_0_2.update_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local flag = false
	local content = arg_5_1.content
	local style = arg_5_1.style
	local is_inside_frustum = content.is_inside_frustum
	local is_under = content.is_under
	local distance = content.distance
	local angle = content.angle
	local spawn_progress_timer = content.spawn_progress_timer

	if not spawn_progress_timer then
		local num = spawn_progress_timer + arg_5_4
		local num_2 = 1
		local min = math.min(num / num_2, 1)
		local easeOutCubic = math.easeOutCubic(min)
		local easeInCubic = math.easeInCubic(1 - min)

		content.spawn_progress_timer = min == 1 or not num or nil

		local icon_pulse = style.icon_pulse
		local color = icon_pulse.color
		local texture_size = icon_pulse.texture_size
		local default_size = icon_pulse.default_size

		texture_size[1] = default_size[1] + default_size[1] * easeInCubic
		texture_size[2] = default_size[1] + default_size[2] * easeInCubic
		color[1] = 255 - 255 * easeOutCubic

		for i = 1, 2 do
			local var_5_17 = style["background_pulse_" .. i]
			local color_2 = var_5_17.color
			local texture_size_2 = var_5_17.texture_size
			local default_size_2 = var_5_17.default_size

			texture_size_2[1] = default_size_2[1] - default_size_2[1] * easeInCubic
			texture_size_2[2] = default_size_2[1] - default_size_2[2] * easeInCubic
			color_2[1] = 255 - 255 * easeOutCubic
		end

		flag = true
	end

	style.arrow.angle = angle + math.pi * 0.5

	local str

	if distance > 1 then
		str = tostring(UIUtils.comma_value(math.floor(distance))) .. "m"

		if not str then
			-- Nothing
		end
	end

	str = ""

	::label_5_0::

	content.text = str

	return flag
end
