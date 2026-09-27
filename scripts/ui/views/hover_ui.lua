-- chunkname: @scripts/ui/views/hover_ui.lua

local tbl = {
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
local tbl_2 = {
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

local num = 1.1

HoverUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.ui_renderer = arg_1_1.ui_top_renderer
	self.ingame_ui = arg_1_1.ingame_ui
	self.input_service = arg_1_2
	self.ui_animations = {}

	self:create_ui_elements()
end

HoverUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.default_widget = UIWidget.init(tbl_2.default_hover_widget)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

HoverUI.update_animations = function (self, arg_3_1)
	-- function 3
	local ui_scenegraph = self.ui_scenegraph

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_3_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end
end

HoverUI.update = function (self, arg_4_1)
	-- function 4
	if not self.show_ui then
		return
	end

	local input_service = self.input_service

	input_service = input_service or FAKE_INPUT_SERVICE

	local ui_scenegraph = self.ui_scenegraph

	self:update_widget_pivot_position(ui_scenegraph, input_service)
	self:draw(arg_4_1, ui_scenegraph, input_service)
end

HoverUI.draw = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local ui_renderer = self.ui_renderer

	UIRenderer.begin_pass(ui_renderer, arg_5_2, arg_5_3, arg_5_1)

	local active_tooltip_widget = self.active_tooltip_widget

	if not active_tooltip_widget then
		UIRenderer.draw_widget(ui_renderer, active_tooltip_widget)
	end

	UIRenderer.end_pass(ui_renderer)
end

HoverUI.update_objects = function (self)
	-- function 6
	for i, v in ipairs(self._registered_hover_object) do
		local hover_content = v.hover_content

		if not hover_content then
			if not hover_content.disabled then
				return
			end

			if not hover_content.is_hover then
				local name = v.name
				local type = v.type
				local content = v.content
				local style = v.style

				self:display_object(name, type, content, style)
			end
		end
	end
end

HoverUI.display_object = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if self.display_object_name == arg_7_1 then
		return
	end

	self.display_object_name = arg_7_1
	self.active_tooltip_widget = self.default_widget
end

HoverUI.stop_display_object = function (arg_8_0)
	-- function 8
	return
end

HoverUI.destroy = function (arg_9_0, arg_9_1)
	-- function 9
	return
end

HoverUI.register_widget = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local tbl = {
		name = arg_10_1,
		type = arg_10_2,
		style = arg_10_5,
		content = display_data,
		hover_content = arg_10_3
	}
	local num = #self._registered_hover_object + 1

	self._registered_hover_index_by_name[arg_10_1] = num
	self._registered_hover_object[num] = tbl
end

HoverUI.unregister_widget = function (self, arg_11_1)
	-- function 11
	local var_11_0 = self._registered_hover_index_by_name[arg_11_1]

	if not var_11_0 then
		self._registered_hover_object[var_11_0] = nil
		self._registered_hover_index_by_name[arg_11_1] = nil
	end
end

HoverUI.get_text_size = function (self, arg_12_1, arg_12_2)
	-- function 12
	local font_size = arg_12_2.font_size
	local var_12_1, var_12_2 = UIFontByResolution(arg_12_2)
	local text_size, var_12_4, var_12_5 = UIRenderer.text_size(self.ui_renderer, arg_12_1, var_12_1[1], var_12_2)

	return text_size, var_12_4
end

HoverUI.animate_default_widget = function (arg_13_0)
	-- function 13
	return
end

HoverUI.set_default_widget_text = function (self, arg_14_1)
	-- function 14
	local ui_scenegraph = self.ui_scenegraph
	local text = self.default_widget.style.text

	arg_14_1 = Localize(arg_14_1)
	self.default_widget.content.text = arg_14_1
end

HoverUI.update_widget_pivot_position = function (self, arg_15_1, arg_15_2)
	-- function 15
	local active_tooltip_widget = self.active_tooltip_widget

	if not active_tooltip_widget then
		local position = arg_15_1.hover_root.position
		local scaled_cursor_position_by_scenegraph = UIRenderer.scaled_cursor_position_by_scenegraph(arg_15_2, arg_15_1, "root")

		position[1] = scaled_cursor_position_by_scenegraph.x
		position[2] = scaled_cursor_position_by_scenegraph.y

		local text = active_tooltip_widget.style.text
		local text_2 = active_tooltip_widget.content.text
		local get_text_size, var_15_6 = self:get_text_size(text_2, text)
		local default_hover_widget = arg_15_1.default_hover_widget

		default_hover_widget.size[1] = get_text_size * num
		default_hover_widget.size[2] = var_15_6 * num
	end
end
