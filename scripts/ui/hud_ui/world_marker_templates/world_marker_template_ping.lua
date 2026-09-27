-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_ping.lua

local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

local str = "ping"
local var_0_2 = WorldMarkerTemplates[str]

var_0_2 = var_0_2 or {}
WorldMarkerTemplates[str] = var_0_2
var_0_2.max_distance = 200
var_0_2.screen_clamp = true
var_0_2.life_time = 15
var_0_2.position_offset = {
	0,
	0,
	0.5
}
var_0_2.screen_margins = {
	down = 150,
	up = 150,
	left = 150,
	right = 150
}

local tbl = {
	"world_marker_response_1",
	"world_marker_response_2",
	"world_marker_response_3"
}
local tbl_2 = {
	"world_marker_icon_response_1",
	"world_marker_icon_response_2",
	"world_marker_icon_response_3"
}

var_0_2.create_widget_definition = function (arg_1_0)
	-- function 1
	local num = 25

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
					content_check_function = function (self)
						-- function 2
						return self.world_marker_response_1.show
					end
				},
				{
					pass_type = "texture",
					style_id = "world_marker_icon_response_2",
					texture_id = "world_marker_icon_response_2",
					content_check_function = function (self)
						-- function 3
						return self.world_marker_response_2.show
					end
				},
				{
					pass_type = "texture",
					style_id = "world_marker_icon_response_3",
					texture_id = "world_marker_icon_response_3",
					content_check_function = function (self)
						-- function 4
						return self.world_marker_response_3.show
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
					content_check_function = function (self)
						-- function 5
						return self.is_clamped
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_6_0)
						-- function 6
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
					7 + num,
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
					-num,
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

var_0_2.on_enter = function (self)
	-- function 7
	local content = self.content

	content.spawn_progress_timer = 0
	content.world_marker_response_1 = {}
	content.world_marker_response_2 = {}
	content.world_marker_response_3 = {}
end

local function fn(arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	arg_8_0 = arg_8_0 + arg_8_1

	local min = math.min(arg_8_0 / 1, 1)
	local easeOutCubic = math.easeOutCubic(min)
	local color = arg_8_2.color
	local default_color = arg_8_2.default_color
	local texture_size = arg_8_2.texture_size
	local default_size = arg_8_2.default_size

	texture_size[1] = default_size[1] + default_size[1] * easeOutCubic
	texture_size[2] = default_size[2] + default_size[2] * easeOutCubic
	color[1] = default_color[1] - default_color[1] * easeOutCubic

	return min, min ~= 1
end

local function fn_2(arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	arg_9_0 = arg_9_0 + arg_9_1 * 10

	local min = math.min(arg_9_0 / 1, 1)
	local num = 1 - math.easeOutCubic(min)
	local color = arg_9_2.color
	local default_color = arg_9_2.default_color
	local texture_size = arg_9_2.texture_size
	local default_size = arg_9_2.default_size
	local offset = arg_9_2.offset
	local default_offset = arg_9_2.default_offset

	offset[1] = default_offset[1] + default_offset[1] * 100 * num
	offset[2] = default_offset[2] + default_offset[2] * 100 * num
	texture_size[1] = default_size[1] + default_size[1] * 2 * num
	texture_size[2] = default_size[2] + default_size[2] * 2 * num
	color[1] = default_color[1] - default_color[1] * num

	return min, min ~= 1
end

var_0_2.update_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local content = arg_10_1.content
	local style = arg_10_1.style
	local is_inside_frustum = content.is_inside_frustum
	local is_under = content.is_under
	local distance = content.distance
	local angle = content.angle

	if not content.spawn_progress_timer then
		local var_10_6, var_10_7 = fn(content.spawn_progress_timer, arg_10_4, style.icon_spawn_pulse)

		content.spawn_progress_timer = not var_10_7 and var_10_6 and nil
	end

	for i = 1, 3 do
		local var_10_8 = tbl[i]
		local var_10_9 = content[var_10_8]

		if not var_10_9.timer then
			local var_10_10 = tbl_2[i]
			local var_10_11, var_10_12 = fn_2(var_10_9.timer, arg_10_4, style[var_10_10])

			content[var_10_8].timer = not var_10_12 and var_10_11 and nil
		end
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

	::label_10_0::

	content.distance_text = str

	local clamp = math.clamp(0.3 + (1 - content.forward_dot_dir) * 499.99999999999955, 0, 1)

	if clamp ~= 1 then
		local num = 255 * clamp

		style.icon.color[1] = num
		style.icon_bg.color[1] = num
		style.arrow.color[1] = num
		style.text.text_color[1] = num
	end

	return true
end
