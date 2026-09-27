-- chunkname: @scripts/ui/views/twitch_icon_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local scripts_ui_views_twitch_icon_view_definitions = require("scripts/ui/views/twitch_icon_view_definitions")

TwitchIconView = class(TwitchIconView)

TwitchIconView.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/ui/ui_1080p_loading")
	self._render_settings = {
		snap_pixel_positions = true
	}

	self:_create_ui_elements()
end

TwitchIconView._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scripts_ui_views_twitch_icon_view_definitions.scenegraph_definition)
	self._twitch_icon_widget = UIWidget.init(scripts_ui_views_twitch_icon_view_definitions.twitch_icon_widget)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

TwitchIconView.update = function (self, arg_3_1)
	-- function 3
	local flag = false

	if not Managers.state.network then
		flag = Managers.state.network:lobby():lobby_data("twitch_enabled") == "true"
	end

	if flag or not Managers.twitch and Managers.twitch:is_connected() and not Managers.twitch:is_activated() then
		self:_draw(arg_3_1)
	end
end

TwitchIconView._draw = function (self, arg_4_1)
	-- function 4
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, arg_4_1, nil, self._render_settings)
	UIRenderer.draw_widget(_ui_renderer, self._twitch_icon_widget)
	UIRenderer.end_pass(_ui_renderer)
end

TwitchIconView.destroy = function (self)
	-- function 5
	UIRenderer.destroy(self._ui_renderer, self._world)
end
