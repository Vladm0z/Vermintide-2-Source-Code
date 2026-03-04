-- chunkname: @scripts/ui/views/pactsworn_video_transition_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local var_0_0 = require("scripts/ui/views/pactsworn_video_transition_view_definitions")

PactswornVideoTransitionView = class(PactswornVideoTransitionView)

PactswornVideoTransitionView.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._video_enabled = false
	arg_1_0._sound_started = false
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_1_0._reference_name = var_0_0.reference_name
end

PactswornVideoTransitionView.play_video = function (arg_2_0, arg_2_1)
	local var_2_0 = var_0_0.pactsworn_video_data[arg_2_1]

	arg_2_0._pactsworn_video_widget = UIWidget.init(UIWidgets.create_splash_video(var_2_0, arg_2_0._reference_name))
	arg_2_0._ui_renderer = UIRenderer.create(arg_2_0._world, "material", var_2_0.video_name)
	arg_2_0._video_data = var_2_0
end

PactswornVideoTransitionView.enable_video = function (arg_3_0, arg_3_1)
	arg_3_0._video_enabled = arg_3_1
end

PactswornVideoTransitionView._draw = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._video_data

	if not arg_4_0._pactsworn_video_widget.content.video_content.video_completed then
		if not arg_4_0._ui_renderer.video_players[arg_4_0._reference_name] then
			UIRenderer.create_video_player(arg_4_0._ui_renderer, arg_4_0._reference_name, arg_4_0._world, var_4_0.video_name, var_4_0.loop)
		else
			if not arg_4_0._sound_started and var_4_0.sound_start then
				Managers.music:trigger_event(var_4_0.sound_start)

				arg_4_0._sound_started = true
			end

			local var_4_1 = Managers.input:get_service("Player")

			UIRenderer.begin_pass(arg_4_0._ui_renderer, arg_4_0._ui_scenegraph, var_4_1, arg_4_1, nil, arg_4_0.render_settings)
			UIRenderer.draw_widget(arg_4_0._ui_renderer, arg_4_0._pactsworn_video_widget)
			UIRenderer.end_pass(arg_4_0._ui_renderer)
		end
	elseif arg_4_0._ui_renderer.video_players[arg_4_0._reference_name] then
		UIRenderer.destroy_video_player(arg_4_0._ui_renderer, arg_4_0._reference_name)

		arg_4_0._sound_started = false

		if var_4_0.sound_stop then
			Managers.music:trigger_event(var_4_0.sound_stop)
		end
	end

	return arg_4_0._pactsworn_video_widget.content.video_content.video_completed
end

PactswornVideoTransitionView.update = function (arg_5_0, arg_5_1)
	if arg_5_0._video_enabled then
		arg_5_0:_draw(arg_5_1)
	end
end

PactswornVideoTransitionView.destroy = function (arg_6_0)
	UIRenderer.destroy(arg_6_0._ui_renderer, arg_6_0._world)
end
