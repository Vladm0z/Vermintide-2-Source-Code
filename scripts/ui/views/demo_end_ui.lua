-- chunkname: @scripts/ui/views/demo_end_ui.lua

local var_0_0 = local_require("scripts/ui/views/demo_end_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.background_widget_definitions
local var_0_3 = var_0_0.widget_definitions
local var_0_4 = var_0_0.demo_video
local var_0_5 = false
local var_0_6 = "DemoEndUI"

DemoEndUI = class(DemoEndUI)

function DemoEndUI.init(arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0.platform = PLATFORM
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", var_0_4.video_name)

	UISetupFontHeights(arg_1_0._ui_renderer.gui)

	arg_1_0.input_manager = Managers.input

	arg_1_0.input_manager:create_input_service("demo", "DemoUIKeyMaps", "DemoUIFilters")
	arg_1_0.input_manager:map_device_to_service("demo", "gamepad")
	arg_1_0.input_manager:map_device_to_service("demo", "keyboard")
	arg_1_0.input_manager:map_device_to_service("demo", "mouse")
	arg_1_0:_create_ui_elements()
end

function DemoEndUI._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_2_0._demo_video = UIWidget.init(UIWidgets.create_splash_video(var_0_4, var_0_6))
	arg_2_0._widgets = {}

	for iter_2_0, iter_2_1 in pairs(var_0_3) do
		arg_2_0._widgets[iter_2_0] = UIWidget.init(iter_2_1)
	end

	arg_2_0._background_widgets = {}

	for iter_2_2, iter_2_3 in pairs(var_0_2) do
		arg_2_0._background_widgets[iter_2_2] = UIWidget.init(iter_2_3)
	end
end

function DemoEndUI.update(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:_draw(arg_3_1, arg_3_2)
end

function DemoEndUI._draw(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0._ui_renderer
	local var_4_1 = arg_4_0._ui_scenegraph
	local var_4_2 = arg_4_0.input_manager:get_service("demo")

	UIRenderer.begin_pass(var_4_0, var_4_1, var_4_2, arg_4_1, nil, arg_4_0.render_settings)

	if not arg_4_0._demo_video.content.video_content.video_completed then
		if not var_4_0.video_players[var_0_6] then
			UIRenderer.create_video_player(var_4_0, var_0_6, arg_4_0._world, var_0_4.video_name, var_0_4.loop)
		else
			if not arg_4_0._sound_started then
				if var_0_4.sound_start then
					Managers.music:trigger_event(var_0_4.sound_start)
				end

				arg_4_0._sound_started = true
			end

			UIRenderer.draw_widget(var_4_0, arg_4_0._demo_video)
		end
	elseif var_4_0.video_players[var_0_6] then
		UIRenderer.destroy_video_player(var_4_0, var_0_6)

		arg_4_0._sound_started = false

		if var_0_4.sound_stop then
			Managers.music:trigger_event(var_0_4.sound_stop)
		end
	end

	for iter_4_0, iter_4_1 in pairs(arg_4_0._widgets) do
		UIRenderer.draw_widget(var_4_0, iter_4_1)
	end

	for iter_4_2, iter_4_3 in pairs(arg_4_0._background_widgets) do
		UIRenderer.draw_widget(var_4_0, iter_4_3)
	end

	UIRenderer.end_pass(var_4_0)
end

function DemoEndUI.completed(arg_5_0)
	return arg_5_0._demo_video.content.video_content.video_completed
end

function DemoEndUI.destroy(arg_6_0)
	UIRenderer.destroy(arg_6_0._ui_renderer, arg_6_0._world)
end
