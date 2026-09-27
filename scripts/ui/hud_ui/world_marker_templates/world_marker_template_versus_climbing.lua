-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_climbing.lua

local str = "climbing"
local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

local var_0_2 = WorldMarkerTemplates[str]

var_0_2 = var_0_2 or {}
WorldMarkerTemplates[str] = var_0_2
var_0_2.check_line_of_sight = true
var_0_2.position_offset = {
	0,
	0,
	0
}
var_0_2.screen_clamp = false
var_0_2.max_distance = 15
var_0_2.fade_distance = 3
var_0_2.scale_settings = {
	end_scale_distance = 4,
	start_scale_distance = 2,
	min_scale = 0.25
}

var_0_2.create_widget_definition = function (arg_1_0)
	-- function 1
	return {
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			-5
		},
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				}
			}
		},
		content = {
			background = "world_marker_versus_pactsworn_background",
			icon = "world_marker_versus_pactsworn_interact_climbing"
		},
		style = {
			icon = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				texture_size = {
					0,
					0
				},
				offset = {
					0,
					0,
					1
				},
				default_size = {
					100,
					100
				},
				color = {
					255,
					255,
					255,
					255
				},
				color_disabled = {
					10,
					190,
					190,
					190
				},
				color_occluded = {
					100,
					190,
					190,
					190
				},
				color_inactive = {
					200,
					255,
					255,
					255
				},
				color_active = {
					200,
					128,
					255,
					36
				}
			},
			background = {
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
					96,
					192
				},
				default_offset = {
					-2,
					4,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}
end

var_0_2.on_enter = function (arg_2_0)
	-- function 2
	arg_2_0.content.progress = 0
end

var_0_2.update_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local content = arg_3_1.content
	local style = arg_3_1.style
	local icon = style.icon
	local distance = content.distance
	local progress = content.progress
	local unit = arg_3_2.unit
	local is_enabled = ScriptUnit.extension(unit, "interactable_system"):is_enabled()
	local get = Managers.input:get_service("Player"):get("action_one_hold")

	if not (distance <= 3) or arg_3_2.raycast_result or get or not is_enabled then
		progress = math.min(1, progress + arg_3_4 * 3.5)
	else
		progress = math.max(0, progress - arg_3_4 * 15)
	end

	content.progress = progress
	style.background.color[1] = 175 * progress

	if not is_enabled then
		Colors.copy_to(icon.color, icon.color_disabled)
	elseif not (arg_3_2.raycast_result or get or is_enabled) then
		Colors.copy_to(icon.color, icon.color_occluded)
	else
		Colors.lerp_color_tables(icon.color_inactive, icon.color_active, progress, icon.color)
	end

	local num = (arg_3_3.max_distance - distance) / arg_3_3.fade_distance

	if num < 1 then
		icon.color[1] = icon.color[1] * num
	end

	return false
end
