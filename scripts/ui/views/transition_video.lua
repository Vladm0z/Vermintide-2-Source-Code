-- chunkname: @scripts/ui/views/transition_video.lua

local var_0_0 = local_require("scripts/ui/views/transition_video_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.background_widget_definitions
local var_0_3 = var_0_0.widget_definitions
local var_0_4 = var_0_0.demo_video
local var_0_5 = "TransitionVideo"

TransitionVideo = class(TransitionVideo)

function TransitionVideo.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._world = arg_1_1
	arg_1_0._platform = PLATFORM
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._video_data_table = arg_1_2 or var_0_4
	arg_1_0._ui_renderer = UIRenderer.create(arg_1_1, "material", arg_1_0._video_data_table.video_name)

	arg_1_0:_create_ui_elements()
end

function TransitionVideo._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_2_0._demo_video = UIWidget.init(UIWidgets.create_splash_video(arg_2_0._video_data_table, var_0_5))
	arg_2_0._widgets = {}

	for iter_2_0, iter_2_1 in pairs(var_0_3) do
		arg_2_0._widgets[iter_2_0] = UIWidget.init(iter_2_1)
	end

	arg_2_0._background_widgets = {}

	for iter_2_2, iter_2_3 in pairs(var_0_2) do
		arg_2_0._background_widgets[iter_2_2] = UIWidget.init(iter_2_3)
	end
end

local var_0_6 = true

function TransitionVideo.activate(arg_3_0, arg_3_1)
	if var_0_6 then
		arg_3_0:_create_ui_elements()

		var_0_6 = false
	end

	arg_3_0._active = arg_3_1

	if not arg_3_1 then
		arg_3_0:_destroy_video()
	end
end

function TransitionVideo._destroy_video(arg_4_0)
	local var_4_0 = arg_4_0._ui_renderer

	if var_4_0.video_players[var_0_5] then
		UIRenderer.destroy_video_player(var_4_0, var_0_5)

		arg_4_0._sound_started = false

		if arg_4_0._video_data_table.sound_stop then
			Managers.music:trigger_event(arg_4_0._video_data_table.sound_stop)
		end
	end
end

function TransitionVideo.update(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._active then
		arg_5_0:_draw(arg_5_1, arg_5_2)
	end
end

function TransitionVideo._draw(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._ui_renderer
	local var_6_1 = arg_6_0._ui_scenegraph

	UIRenderer.begin_pass(var_6_0, var_6_1, FAKE_INPUT_SERVICE, arg_6_1, nil, arg_6_0.render_settings)

	if not arg_6_0._demo_video.content.video_content.video_completed then
		if not var_6_0.video_players[var_0_5] then
			UIRenderer.create_video_player(var_6_0, var_0_5, arg_6_0._world, arg_6_0._video_data_table.video_name, arg_6_0._video_data_table.loop)
		else
			if not arg_6_0._sound_started then
				if arg_6_0._video_data_table.sound_start then
					Managers.music:trigger_event(arg_6_0._video_data_table.sound_start)
				end

				arg_6_0._sound_started = true
			end

			UIRenderer.draw_widget(var_6_0, arg_6_0._demo_video)
		end
	elseif var_6_0.video_players[var_0_5] then
		UIRenderer.destroy_video_player(var_6_0, var_0_5)

		arg_6_0._sound_started = false

		if arg_6_0._video_data_table.sound_stop then
			Managers.music:trigger_event(arg_6_0._video_data_table.sound_stop)
		end

		arg_6_0._active = false
		arg_6_0._demo_video.content.video_content.video_completed = false
	end

	for iter_6_0, iter_6_1 in pairs(arg_6_0._widgets) do
		UIRenderer.draw_widget(var_6_0, iter_6_1)
	end

	for iter_6_2, iter_6_3 in pairs(arg_6_0._background_widgets) do
		UIRenderer.draw_widget(var_6_0, iter_6_3)
	end

	UIRenderer.end_pass(var_6_0)
end

function TransitionVideo.completed(arg_7_0)
	return arg_7_0._demo_video.content.video_content.video_completed
end

function TransitionVideo.is_active(arg_8_0)
	return arg_8_0._active
end

function TransitionVideo.destroy(arg_9_0)
	UIRenderer.destroy(arg_9_0._ui_renderer, arg_9_0._world)
end
