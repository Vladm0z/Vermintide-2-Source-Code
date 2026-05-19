-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_pet_nameplate.lua

local var_0_0 = "pet_nameplate"

WorldMarkerTemplates = WorldMarkerTemplates or {}

local var_0_1 = WorldMarkerTemplates[var_0_0] or {}

WorldMarkerTemplates[var_0_0] = var_0_1
var_0_1.position_offset = {
	0,
	0,
	1.9
}
var_0_1.check_line_of_sight = true
var_0_1.screen_clamp = false

function var_0_1.create_widget_definition(arg_1_0)
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
					pass_type = "rect",
					style_id = "progress_background"
				},
				{
					style_id = "progress_foreground",
					pass_type = "rect",
					content_change_function = function(arg_2_0, arg_2_1)
						arg_2_1.texture_size[1] = arg_2_0.progress * arg_2_1.max_width
					end
				},
				{
					pass_type = "texture",
					style_id = "text_bg",
					texture_id = "text_bg",
					content_check_function = function(arg_3_0)
						return arg_3_0.text
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_4_0)
						return arg_4_0.text
					end
				}
			}
		},
		content = {
			text_bg = "tab_menu_bg_03",
			progress = 0.5
		},
		style = {
			progress_background = {
				vertical_alignment = "top",
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					25,
					0,
					0
				},
				texture_size = {
					50,
					10
				}
			},
			progress_foreground = {
				vertical_alignment = "top",
				max_width = 46,
				color = {
					255,
					87,
					161,
					34
				},
				offset = {
					27,
					-2,
					1
				},
				texture_size = {
					0,
					6
				}
			},
			text_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					40,
					10,
					-1
				},
				texture_size = {
					200,
					30
				},
				color = {
					155,
					255,
					255,
					255
				}
			},
			text = {
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = 16,
				horizontal_alignment = "center",
				text_color = {
					255,
					215,
					215,
					215
				},
				offset = {
					0,
					10,
					3
				},
				size = {
					100,
					10
				}
			}
		}
	}
end

function var_0_1.on_enter(arg_5_0)
	arg_5_0.content.progress = 1
end
