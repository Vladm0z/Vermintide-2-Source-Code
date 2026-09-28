-- chunkname: @scripts/ui/views/pactsworn_video_transition_view.lua

require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widgets")

local definitions = require("scripts/ui/views/pactsworn_video_transition_view_definitions")

PactswornVideoTransitionView = class(PactswornVideoTransitionView)

PactswornVideoTransitionView.init = function (self, world)
	-- function 1
	self._world = world
	self._video_enabled = false
	self._sound_started = false
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._ui_scenegraph = UISceneGraph.init_scenegraph(definitions.scenegraph_definition)
	self._reference_name = definitions.reference_name
end

PactswornVideoTransitionView.play_video = function (self, index)
	-- function 2
	local video_data = definitions.pactsworn_video_data[index]

	self._pactsworn_video_widget = UIWidget.init(UIWidgets.create_splash_video(video_data, self._reference_name))
	self._ui_renderer = UIRenderer.create(self._world, "material", video_data.video_name)
	self._video_data = video_data
end

PactswornVideoTransitionView.enable_video = function (self, enable)
	-- function 3
	self._video_enabled = enable
end

PactswornVideoTransitionView._draw = function (self, dt)
	-- function 4
	local video_data = self._video_data

	if not self._pactsworn_video_widget.content.video_content.video_completed then
		if not self._ui_renderer.video_players[self._reference_name] then
			UIRenderer.create_video_player(self._ui_renderer, self._reference_name, self._world, video_data.video_name, video_data.loop)
		else
			if not self._sound_started and video_data.sound_start then
				Managers.music:trigger_event(video_data.sound_start)

				self._sound_started = true
			end

			local input_service = Managers.input:get_service("Player")

			UIRenderer.begin_pass(self._ui_renderer, self._ui_scenegraph, input_service, dt, nil, self.render_settings)
			UIRenderer.draw_widget(self._ui_renderer, self._pactsworn_video_widget)
			UIRenderer.end_pass(self._ui_renderer)
		end
	elseif self._ui_renderer.video_players[self._reference_name] then
		UIRenderer.destroy_video_player(self._ui_renderer, self._reference_name)

		self._sound_started = false

		if video_data.sound_stop then
			Managers.music:trigger_event(video_data.sound_stop)
		end
	end

	return self._pactsworn_video_widget.content.video_content.video_completed
end

PactswornVideoTransitionView.update = function (self, dt)
	-- function 5
	if self._video_enabled then
		self:_draw(dt)
	end
end

PactswornVideoTransitionView.destroy = function (self)
	-- function 6
	UIRenderer.destroy(self._ui_renderer, self._world)
end
