-- chunkname: @scripts/ui/views/twitch_icon_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local var_0_0 = require("scripts/ui/views/twitch_icon_view_definitions")

TwitchIconView = class(TwitchIconView)

TwitchIconView.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_loading")
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:_create_ui_elements()
end

TwitchIconView._create_ui_elements = function (arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0._twitch_icon_widget = UIWidget.init(var_0_0.twitch_icon_widget)

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
end

TwitchIconView.update = function (arg_3_0, arg_3_1)
	local var_3_0 = false

	if Managers.state.network then
		var_3_0 = Managers.state.network:lobby():lobby_data("twitch_enabled") == "true"
	end

	if var_3_0 or Managers.twitch and (Managers.twitch:is_connected() or Managers.twitch:is_activated()) then
		arg_3_0:_draw(arg_3_1)
	end
end

TwitchIconView._draw = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._ui_renderer
	local var_4_1 = arg_4_0._ui_scenegraph

	UIRenderer.begin_pass(var_4_0, var_4_1, FAKE_INPUT_SERVICE, arg_4_1, nil, arg_4_0._render_settings)
	UIRenderer.draw_widget(var_4_0, arg_4_0._twitch_icon_widget)
	UIRenderer.end_pass(var_4_0)
end

TwitchIconView.destroy = function (arg_5_0)
	UIRenderer.destroy(arg_5_0._ui_renderer, arg_5_0._world)
end
