-- chunkname: @scripts/ui/views/hover_ui.lua

local var_0_0 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.hover
		}
	},
	hover_root = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "left",
		size = {
			1,
			1
		},
		position = {
			0,
			0,
			1
		}
	},
	default_hover_widget = {
		vertical_alignment = "center",
		parent = "hover_root",
		horizontal_alignment = "center",
		size = {
			1,
			1
		},
		position = {
			10,
			10,
			1
		}
	}
}
local var_0_1 = {
	default_hover_widget = {
		scenegraph_id = "default_hover_widget",
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "rounded_background"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			text = "description"
		},
		style = {
			text = {
				font_size = 28,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			background = {
				corner_radius = 2,
				color = Colors.get_color_table_with_alpha("black", 200)
			}
		}
	}
}

HoverUI = class(HoverUI)

local var_0_2 = 1.1

function HoverUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.ui_renderer = arg_1_1.ui_top_renderer
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.input_service = arg_1_2
	arg_1_0.ui_animations = {}

	arg_1_0:create_ui_elements()
end

function HoverUI.create_ui_elements(arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0)
	arg_2_0.default_widget = UIWidget.init(var_0_1.default_hover_widget)

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)
end

function HoverUI.update_animations(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.ui_scenegraph

	for iter_3_0, iter_3_1 in pairs(arg_3_0.ui_animations) do
		UIAnimation.update(iter_3_1, arg_3_1)

		if UIAnimation.completed(iter_3_1) then
			arg_3_0.ui_animations[iter_3_0] = nil
		end
	end
end

function HoverUI.update(arg_4_0, arg_4_1)
	if not arg_4_0.show_ui then
		return
	end

	local var_4_0 = arg_4_0.input_service or FAKE_INPUT_SERVICE
	local var_4_1 = arg_4_0.ui_scenegraph

	arg_4_0:update_widget_pivot_position(var_4_1, var_4_0)
	arg_4_0:draw(arg_4_1, var_4_1, var_4_0)
end

function HoverUI.draw(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0.ui_renderer

	UIRenderer.begin_pass(var_5_0, arg_5_2, arg_5_3, arg_5_1)

	local var_5_1 = arg_5_0.active_tooltip_widget

	if var_5_1 then
		UIRenderer.draw_widget(var_5_0, var_5_1)
	end

	UIRenderer.end_pass(var_5_0)
end

function HoverUI.update_objects(arg_6_0)
	for iter_6_0, iter_6_1 in ipairs(arg_6_0._registered_hover_object) do
		local var_6_0 = iter_6_1.hover_content

		if var_6_0 then
			if var_6_0.disabled then
				return
			end

			if var_6_0.is_hover then
				local var_6_1 = iter_6_1.name
				local var_6_2 = iter_6_1.type
				local var_6_3 = iter_6_1.content
				local var_6_4 = iter_6_1.style

				arg_6_0:display_object(var_6_1, var_6_2, var_6_3, var_6_4)
			end
		end
	end
end

function HoverUI.display_object(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_0.display_object_name == arg_7_1 then
		return
	end

	arg_7_0.display_object_name = arg_7_1
	arg_7_0.active_tooltip_widget = arg_7_0.default_widget
end

function HoverUI.stop_display_object(arg_8_0)
	return
end

function HoverUI.destroy(arg_9_0, arg_9_1)
	return
end

function HoverUI.register_widget(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = {
		name = arg_10_1,
		type = arg_10_2,
		style = arg_10_5,
		content = display_data,
		hover_content = arg_10_3
	}
	local var_10_1 = #arg_10_0._registered_hover_object + 1

	arg_10_0._registered_hover_index_by_name[arg_10_1] = var_10_1
	arg_10_0._registered_hover_object[var_10_1] = var_10_0
end

function HoverUI.unregister_widget(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._registered_hover_index_by_name[arg_11_1]

	if var_11_0 then
		arg_11_0._registered_hover_object[var_11_0] = nil
		arg_11_0._registered_hover_index_by_name[arg_11_1] = nil
	end
end

function HoverUI.get_text_size(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2.font_size
	local var_12_1, var_12_2 = UIFontByResolution(arg_12_2)
	local var_12_3, var_12_4, var_12_5 = UIRenderer.text_size(arg_12_0.ui_renderer, arg_12_1, var_12_1[1], var_12_2)

	return var_12_3, var_12_4
end

function HoverUI.animate_default_widget(arg_13_0)
	return
end

function HoverUI.set_default_widget_text(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.ui_scenegraph
	local var_14_1 = arg_14_0.default_widget.style.text

	arg_14_1 = Localize(arg_14_1)
	arg_14_0.default_widget.content.text = arg_14_1
end

function HoverUI.update_widget_pivot_position(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.active_tooltip_widget

	if var_15_0 then
		local var_15_1 = arg_15_1.hover_root.position
		local var_15_2 = UIRenderer.scaled_cursor_position_by_scenegraph(arg_15_2, arg_15_1, "root")

		var_15_1[1] = var_15_2.x
		var_15_1[2] = var_15_2.y

		local var_15_3 = var_15_0.style.text
		local var_15_4 = var_15_0.content.text
		local var_15_5, var_15_6 = arg_15_0:get_text_size(var_15_4, var_15_3)
		local var_15_7 = arg_15_1.default_hover_widget

		var_15_7.size[1] = var_15_5 * var_0_2
		var_15_7.size[2] = var_15_6 * var_0_2
	end
end
