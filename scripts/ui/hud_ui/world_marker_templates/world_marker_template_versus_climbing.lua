-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_versus_climbing.lua

local var_0_0 = "climbing"

WorldMarkerTemplates = WorldMarkerTemplates or {}

local var_0_1 = WorldMarkerTemplates[var_0_0] or {}

WorldMarkerTemplates[var_0_0] = var_0_1
var_0_1.check_line_of_sight = true
var_0_1.position_offset = {
	0,
	0,
	0
}
var_0_1.screen_clamp = false
var_0_1.max_distance = 15
var_0_1.fade_distance = 3
var_0_1.scale_settings = {
	end_scale_distance = 4,
	start_scale_distance = 2,
	min_scale = 0.25
}

var_0_1.create_widget_definition = function (arg_1_0)
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

var_0_1.on_enter = function (arg_2_0)
	arg_2_0.content.progress = 0
end

var_0_1.update_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_1.content
	local var_3_1 = arg_3_1.style
	local var_3_2 = var_3_1.icon
	local var_3_3 = var_3_0.distance
	local var_3_4 = var_3_0.progress
	local var_3_5 = arg_3_2.unit
	local var_3_6 = ScriptUnit.extension(var_3_5, "interactable_system"):is_enabled()
	local var_3_7 = Managers.input:get_service("Player"):get("action_one_hold")

	if var_3_3 <= 3 and not arg_3_2.raycast_result and not var_3_7 and var_3_6 then
		var_3_4 = math.min(1, var_3_4 + arg_3_4 * 3.5)
	else
		var_3_4 = math.max(0, var_3_4 - arg_3_4 * 15)
	end

	var_3_0.progress = var_3_4
	var_3_1.background.color[1] = 175 * var_3_4

	if not var_3_6 then
		Colors.copy_to(var_3_2.color, var_3_2.color_disabled)
	elseif arg_3_2.raycast_result or var_3_7 or not var_3_6 then
		Colors.copy_to(var_3_2.color, var_3_2.color_occluded)
	else
		Colors.lerp_color_tables(var_3_2.color_inactive, var_3_2.color_active, var_3_4, var_3_2.color)
	end

	local var_3_8 = (arg_3_3.max_distance - var_3_3) / arg_3_3.fade_distance

	if var_3_8 < 1 then
		var_3_2.color[1] = var_3_2.color[1] * var_3_8
	end

	return false
end
