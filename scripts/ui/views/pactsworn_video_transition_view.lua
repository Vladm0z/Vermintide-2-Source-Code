-- chunkname: @scripts/ui/views/pactsworn_video_transition_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local scripts_ui_views_pactsworn_video_transition_view_definitions = require("scripts/ui/views/pactsworn_video_transition_view_definitions")

PactswornVideoTransitionView = class(PactswornVideoTransitionView)

PactswornVideoTransitionView.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._video_enabled = false
	self._sound_started = false
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scripts_ui_views_pactsworn_video_transition_view_definitions.scenegraph_definition)
	self._reference_name = scripts_ui_views_pactsworn_video_transition_view_definitions.reference_name
end

PactswornVideoTransitionView.play_video = function (self, arg_2_1)
	-- function 2
	local var_2_0 = scripts_ui_views_pactsworn_video_transition_view_definitions.pactsworn_video_data[arg_2_1]

	self._pactsworn_video_widget = UIWidget.init(UIWidgets.create_splash_video(var_2_0, self._reference_name))
	self._ui_renderer = UIRenderer.create(self._world, "material", var_2_0.video_name)
	self._video_data = var_2_0
end

PactswornVideoTransitionView.enable_video = function (self, arg_3_1)
	-- function 3
	self._video_enabled = arg_3_1
end

PactswornVideoTransitionView._draw = function (self, arg_4_1)
	-- function 4
	local _video_data = self._video_data

	if not self._pactsworn_video_widget.content.video_content.video_completed then
		if not self._ui_renderer.video_players[self._reference_name] then
			UIRenderer.create_video_player(self._ui_renderer, self._reference_name, self._world, _video_data.video_name, _video_data.loop)
		else
			if self._sound_started or not _video_data.sound_start then
				Managers.music:trigger_event(_video_data.sound_start)

				self._sound_started = true
			end

			local get_service = Managers.input:get_service("Player")

			UIRenderer.begin_pass(self._ui_renderer, self._ui_scenegraph, get_service, arg_4_1, nil, self.render_settings)
			UIRenderer.draw_widget(self._ui_renderer, self._pactsworn_video_widget)
			UIRenderer.end_pass(self._ui_renderer)
		end
	elseif not self._ui_renderer.video_players[self._reference_name] then
		UIRenderer.destroy_video_player(self._ui_renderer, self._reference_name)

		self._sound_started = false

		if not _video_data.sound_stop then
			Managers.music:trigger_event(_video_data.sound_stop)
		end
	end

	return self._pactsworn_video_widget.content.video_content.video_completed
end

PactswornVideoTransitionView.update = function (self, arg_5_1)
	-- function 5
	if not self._video_enabled then
		self:_draw(arg_5_1)
	end
end

PactswornVideoTransitionView.destroy = function (self)
	-- function 6
	UIRenderer.destroy(self._ui_renderer, self._world)
end
