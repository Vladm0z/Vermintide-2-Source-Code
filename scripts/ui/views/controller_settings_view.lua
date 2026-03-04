-- chunkname: @scripts/ui/views/controller_settings_view.lua

ControllerSettingsView = class(ControllerSettingsView)

function ControllerSettingsView.init(arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
end

local var_0_0 = {
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
local var_0_1 = {
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
			content_check_function = function(arg_2_0)
				return arg_2_0.button_hotspot.is_hover
			end
		},
		{
			style_id = "hover_text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function(arg_3_0)
				return arg_3_0.button_hotspot.is_hover
			end
		}
	}
}

local var_0_2 = {
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

local function var_0_3(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1[1]
	local var_4_1 = arg_4_0.mapped_devices[var_4_0][1]
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

function ControllerSettingsView.create_ui_elements(arg_5_0)
	local var_5_0 = {}
	local var_5_1 = 0
	local var_5_2 = var_0_1
	local var_5_3 = var_0_2
	local var_5_4 = arg_5_0.input_manager

	for iter_5_0, iter_5_1 in ipairs(var_0_0) do
		local var_5_5 = iter_5_1[1]

		var_5_1 = var_5_1 + 1
		var_5_3.content[var_5_5] = var_5_5
		UIElements.KeyBindElement.passes[3].text_id = var_5_5
		UIElements.KeyBindElement.passes[4].text_id = var_5_5
		var_5_3.scenegraph_id = var_5_5
		var_5_2[var_5_5] = {
			parent = "widget_start",
			offset = {
				0,
				-var_5_1 * 16,
				1
			},
			size = {
				1920,
				16
			}
		}
		var_5_0[var_5_1] = UIWidget.init(var_5_3)

		local var_5_6 = var_5_4:get_service(var_5_5)

		for iter_5_2, iter_5_3 in pairs(iter_5_1[2]) do
			var_5_1 = var_5_1 + 1

			local var_5_7 = var_5_6:get_keymapping(iter_5_2)
			local var_5_8 = var_5_7.input_mappings[1]
			local var_5_9 = var_5_7.input_mappings[2]
			local var_5_10 = "-"
			local var_5_11 = "-"

			if var_5_8 then
				var_5_10 = var_0_3(var_5_6, var_5_8)
			end

			if var_5_9 then
				var_5_11 = var_0_3(var_5_6, var_5_9)
			end

			local var_5_12 = "index_" .. tostring(var_5_1)
			local var_5_13 = string.format("%s: %20s | %-20s", iter_5_2, var_5_10, var_5_11)

			var_5_3.content[var_5_12] = var_5_13
			UIElements.KeyBindElement.passes[3].text_id = var_5_12
			UIElements.KeyBindElement.passes[4].text_id = var_5_12
			var_5_3.scenegraph_id = var_5_12
			var_5_2[var_5_12] = {
				parent = "widget_start",
				offset = {
					0,
					-var_5_1 * 16,
					1
				},
				size = {
					1920,
					16
				}
			}
			var_5_0[var_5_1] = UIWidget.init(var_5_3)
		end
	end

	arg_5_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_5_2)
	arg_5_0.ui_widgets = var_5_0
end

function ControllerSettingsView.on_enter(arg_6_0)
	arg_6_0:create_ui_elements()
end

function ControllerSettingsView.destroy(arg_7_0)
	return
end

function ControllerSettingsView.update(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.ui_renderer
	local var_8_1 = arg_8_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_8_0, arg_8_0.ui_scenegraph, var_8_1, arg_8_1)

	for iter_8_0, iter_8_1 in ipairs(arg_8_0.ui_widgets) do
		UIRenderer.draw_widget(var_8_0, iter_8_1)
	end

	UIRenderer.end_pass(var_8_0)

	if var_8_1:get("toggle_menu") or var_8_1:get("back") then
		arg_8_0.ingame_ui:handle_transition("ingame_menu", "OptionsMenu")
	end
end
