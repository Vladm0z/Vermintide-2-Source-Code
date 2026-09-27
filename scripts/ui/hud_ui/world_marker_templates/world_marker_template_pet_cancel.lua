-- chunkname: @scripts/ui/hud_ui/world_marker_templates/world_marker_template_pet_cancel.lua

local str = "pet_cancel"
local WorldMarkerTemplates = WorldMarkerTemplates

WorldMarkerTemplates = WorldMarkerTemplates or {}
WorldMarkerTemplates = WorldMarkerTemplates

local var_0_2 = WorldMarkerTemplates[str]

var_0_2 = var_0_2 or {}
WorldMarkerTemplates[str] = var_0_2
var_0_2.position_offset = {
	0,
	0,
	0.2
}
var_0_2.unit_node = "j_spine"
var_0_2.check_line_of_sight = true
var_0_2.screen_clamp = false

var_0_2.create_widget_definition = function (arg_1_0)
	-- function 1
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
					style_id = "text_bg",
					texture_id = "text_bg",
					content_check_function = function (self)
						-- function 2
						return self.text
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 3
						return self.text
					end
				}
			}
		},
		content = {
			text = "[LEFT] Cancel command",
			text_bg = "tab_menu_bg_03",
			progress = 0.5
		},
		style = {
			text_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					40,
					0,
					-1
				},
				texture_size = {
					200,
					30
				}
			},
			text = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
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
					-15,
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

var_0_2.on_enter = function (arg_4_0)
	-- function 4
	arg_4_0.content.progress = 1
end
