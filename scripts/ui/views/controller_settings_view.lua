-- chunkname: @scripts/ui/views/controller_settings_view.lua

ControllerSettingsView = class(ControllerSettingsView)

ControllerSettingsView.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_renderer
	self.input_manager = arg_1_1.input_manager
	self.ingame_ui = arg_1_1.ingame_ui
end

local tbl = {
	{
		"Player",
		PlayerControllerKeymaps
	},
	{
		"ingame_menu",
		IngameMenuKeymaps
	},
	{
		"chat_input",
		ChatControllerSettings
	}
}
local tbl_2 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.default
		},
		size = {
			1920,
			1080
		}
	},
	widget_start = {
		vertical_alignment = "top",
		parent = "root"
	}
}

UIElements.KeyBindElement = {
	passes = {
		{
			pass_type = "hover",
			content_id = "button_hotspot"
		},
		{
			pass_type = "click",
			content_id = "button_hotspot"
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 2
				return self.button_hotspot.is_hover
			end
		},
		{
			style_id = "hover_text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 3
				return self.button_hotspot.is_hover
			end
		}
	}
}

local tbl_3 = {
	scenegraph_id = "",
	element = UIElements.KeyBindElement,
	content = {
		text_field = "TEST",
		button_hotspot = {}
	},
	style = {
		text = {
			font_size = 14,
			font_type = "hell_shark",
			horizontal_alignment = "center",
			text_color = Colors.color_definitions.white
		},
		hover_text = {
			font_size = 14,
			font_type = "hell_shark",
			horizontal_alignment = "center",
			text_color = Colors.color_definitions.green
		}
	}
}

local function fn(self, arg_4_1)
	-- function 4
	local var_4_0 = arg_4_1[1]
	local var_4_1 = self.mapped_devices[var_4_0][1]
	local var_4_2 = arg_4_1[3]
	local var_4_3 = arg_4_1[2]
	local var_4_4

	if var_4_2 == "axis" then
		var_4_4 = var_4_1.axis_name(var_4_3)
	else
		var_4_4 = var_4_1.button_name(var_4_3)
	end

	return var_4_4
end

ControllerSettingsView.create_ui_elements = function (self)
	-- function 5
	local tbl_4 = {}
	local num = 0
	local var_5_2 = tbl_2
	local var_5_3 = tbl_3
	local input_manager = self.input_manager

	for i, v in ipairs(tbl) do
		local var_5_5 = v[1]

		num = num + 1
		var_5_3.content[var_5_5] = var_5_5
		UIElements.KeyBindElement.passes[3].text_id = var_5_5
		UIElements.KeyBindElement.passes[4].text_id = var_5_5
		var_5_3.scenegraph_id = var_5_5
		var_5_2[var_5_5] = {
			parent = "widget_start",
			offset = {
				0,
				-num * 16,
				1
			},
			size = {
				1920,
				16
			}
		}
		tbl_4[num] = UIWidget.init(var_5_3)

		local get_service = input_manager:get_service(var_5_5)

		for k, v_2 in pairs(v[2]) do
			num = num + 1

			local get_keymapping = get_service:get_keymapping(k)
			local var_5_8 = get_keymapping.input_mappings[1]
			local var_5_9 = get_keymapping.input_mappings[2]
			local str = "-"
			local str_2 = "-"

			if not var_5_8 then
				str = fn(get_service, var_5_8)
			end

			if not var_5_9 then
				str_2 = fn(get_service, var_5_9)
			end

			local str_3 = "index_" .. tostring(num)
			local format = string.format("%s: %20s | %-20s", k, str, str_2)

			var_5_3.content[str_3] = format
			UIElements.KeyBindElement.passes[3].text_id = str_3
			UIElements.KeyBindElement.passes[4].text_id = str_3
			var_5_3.scenegraph_id = str_3
			var_5_2[str_3] = {
				parent = "widget_start",
				offset = {
					0,
					-num * 16,
					1
				},
				size = {
					1920,
					16
				}
			}
			tbl_4[num] = UIWidget.init(var_5_3)
		end
	end

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_5_2)
	self.ui_widgets = tbl_4
end

ControllerSettingsView.on_enter = function (self)
	-- function 6
	self:create_ui_elements()
end

ControllerSettingsView.destroy = function (arg_7_0)
	-- function 7
	return
end

ControllerSettingsView.update = function (self, arg_8_1)
	-- function 8
	local ui_renderer = self.ui_renderer
	local get_service = self.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(ui_renderer, self.ui_scenegraph, get_service, arg_8_1)

	for i, v in ipairs(self.ui_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	UIRenderer.end_pass(ui_renderer)

	if get_service:get("toggle_menu") or not get_service:get("back") then
		self.ingame_ui:handle_transition("ingame_menu", "OptionsMenu")
	end
end
