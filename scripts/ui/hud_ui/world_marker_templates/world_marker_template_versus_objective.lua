-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_objective.lua

local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

local versus_objective = WorldMarkerTemplates.versus_objective

if not versus_objective then
	versus_objective = {}
	WorldMarkerTemplates.versus_objective = versus_objective
end

versus_objective.position_offset = {
	0,
	0,
	2
}
versus_objective.max_distance = nil
versus_objective.screen_clamp = true
versus_objective.screen_margins = {
	down = 150,
	up = 200,
	left = 150,
	right = 150
}

versus_objective.create_widget_definition = function (arg_1_0)
	-- function 1
	local num = 0.5
	local num_2 = 60 * num

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
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 4
						local is_clamped = self.is_clamped

						is_clamped = is_clamped or self.distance > 5

						return is_clamped
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
					80 * num,
					80 * num
				},
				default_size = {
					80 * num,
					80 * num
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
					100 * num,
					100 * num
				},
				default_size = {
					100 * num,
					100 * num
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
					100 * num,
					100 * num
				},
				default_size = {
					100 * num,
					100 * num
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
					100 * num,
					100 * num
				},
				default_size = {
					100 * num,
					100 * num
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
					11.5 - num_2
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
					num_2,
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

versus_objective.on_enter = function (self)
	-- function 5
	local content = self.content
	local system = Managers.state.entity:system("objective_system")

	self.content.icon = system:current_objective_icon()
	content.just_entered = true
	content.t = 0
end

versus_objective.update_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local content = arg_6_1.content
	local style = arg_6_1.style

	if not content.just_entered then
		content.just_entered = false
		content.enter_timer = arg_6_5
	end

	local clamp = math.clamp(0.5 + (1 - content.forward_dot_dir) * 499.99999999999955, 0, 1)
	local num = arg_6_5 - content.enter_timer
	local num_2 = 255 * math.easeOutCubic(math.min(num, 1)) * clamp
	local num_3 = num_2 * 0.7

	style.icon.color[1] = num_3
	style.background.color[1] = num_3
	style.arrow.color[1] = num_3
	style.text.text_color[1] = num_2
	style.text_shadow.text_color[1] = num_2
	style.arrow.angle = content.angle

	local distance = content.distance
	local str

	if distance > 1 then
		str = UIUtils.comma_value(math.floor(distance)) .. "m"

		if not str then
			-- Nothing
		end
	end

	str = ""

	::label_6_0::

	content.text = str

	local min = math.min(1, 15 / distance)
	local num_4 = content.t + arg_6_4 * min

	content.t = num_4

	for i = 1, 2 do
		local num_5 = 1 - (1 - (num_4 + 0.5 * i) % 1)^2
		local var_6_11 = style["background_pulse_" .. i]
		local texture_size = var_6_11.texture_size
		local default_size = var_6_11.default_size

		texture_size[1] = default_size[1] * (1 + num_5)
		texture_size[2] = default_size[2] * (1 + num_5)
		var_6_11.color[1] = 255 * (1 - num_5) * min * clamp
	end

	return true
end
