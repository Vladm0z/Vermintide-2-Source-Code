-- chunkname: @scripts/ui/views/transition_video.lua

local var_0_0 = local_require("scripts/ui/views/transition_video_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local background_widget_definitions = var_0_0.background_widget_definitions
local widget_definitions = var_0_0.widget_definitions
local demo_video = var_0_0.demo_video
local str = "TransitionVideo"

TransitionVideo = class(TransitionVideo)

TransitionVideo.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._world = arg_1_1
	self._platform = PLATFORM
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._video_data_table = arg_1_2 or demo_video
	self._ui_renderer = UIRenderer.create(arg_1_1, "material", self._video_data_table.video_name)

	self:_create_ui_elements()
end

TransitionVideo._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._demo_video = UIWidget.init(UIWidgets.create_splash_video(self._video_data_table, str))
	self._widgets = {}

	for k, v in pairs(widget_definitions) do
		self._widgets[k] = UIWidget.init(v)
	end

	self._background_widgets = {}

	for k_2, v_2 in pairs(background_widget_definitions) do
		self._background_widgets[k_2] = UIWidget.init(v_2)
	end
end

local flag = true

TransitionVideo.activate = function (self, arg_3_1)
	-- function 3
	if not flag then
		self:_create_ui_elements()

		flag = false
	end

	self._active = arg_3_1

	if not arg_3_1 then
		self:_destroy_video()
	end
end

TransitionVideo._destroy_video = function (self)
	-- function 4
	local _ui_renderer = self._ui_renderer

	if not _ui_renderer.video_players[str] then
		UIRenderer.destroy_video_player(_ui_renderer, str)

		self._sound_started = false

		if not self._video_data_table.sound_stop then
			Managers.music:trigger_event(self._video_data_table.sound_stop)
		end
	end
end

TransitionVideo.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._active then
		self:_draw(arg_5_1, arg_5_2)
	end
end

TransitionVideo._draw = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, arg_6_1, nil, self.render_settings)

	if not self._demo_video.content.video_content.video_completed then
		if not _ui_renderer.video_players[str] then
			UIRenderer.create_video_player(_ui_renderer, str, self._world, self._video_data_table.video_name, self._video_data_table.loop)
		else
			if not self._sound_started then
				if not self._video_data_table.sound_start then
					Managers.music:trigger_event(self._video_data_table.sound_start)
				end

				self._sound_started = true
			end

			UIRenderer.draw_widget(_ui_renderer, self._demo_video)
		end
	elseif not _ui_renderer.video_players[str] then
		UIRenderer.destroy_video_player(_ui_renderer, str)

		self._sound_started = false

		if not self._video_data_table.sound_stop then
			Managers.music:trigger_event(self._video_data_table.sound_stop)
		end

		self._active = false
		self._demo_video.content.video_content.video_completed = false
	end

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	for k_2, v_2 in pairs(self._background_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_2)
	end

	UIRenderer.end_pass(_ui_renderer)
end

TransitionVideo.completed = function (self)
	-- function 7
	return self._demo_video.content.video_content.video_completed
end

TransitionVideo.is_active = function (self)
	-- function 8
	return self._active
end

TransitionVideo.destroy = function (self)
	-- function 9
	UIRenderer.destroy(self._ui_renderer, self._world)
end
