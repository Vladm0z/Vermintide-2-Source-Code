-- chunkname: @scripts/ui/views/demo_end_ui.lua

local var_0_0 = local_require("scripts/ui/views/demo_end_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local background_widget_definitions = var_0_0.background_widget_definitions
local widget_definitions = var_0_0.widget_definitions
local demo_video = var_0_0.demo_video
local flag = false
local str = "DemoEndUI"

DemoEndUI = class(DemoEndUI)

DemoEndUI.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self.platform = PLATFORM
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._ui_renderer = UIRenderer.create(arg_1_1, "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", demo_video.video_name)

	UISetupFontHeights(self._ui_renderer.gui)

	self.input_manager = Managers.input

	self.input_manager:create_input_service("demo", "DemoUIKeyMaps", "DemoUIFilters")
	self.input_manager:map_device_to_service("demo", "gamepad")
	self.input_manager:map_device_to_service("demo", "keyboard")
	self.input_manager:map_device_to_service("demo", "mouse")
	self:_create_ui_elements()
end

DemoEndUI._create_ui_elements = function (self)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._demo_video = UIWidget.init(UIWidgets.create_splash_video(demo_video, str))
	self._widgets = {}

	for k, v in pairs(widget_definitions) do
		self._widgets[k] = UIWidget.init(v)
	end

	self._background_widgets = {}

	for k_2, v_2 in pairs(background_widget_definitions) do
		self._background_widgets[k_2] = UIWidget.init(v_2)
	end
end

DemoEndUI.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:_draw(arg_3_1, arg_3_2)
end

DemoEndUI._draw = function (self, arg_4_1, arg_4_2)
	-- function 4
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self.input_manager:get_service("demo")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_4_1, nil, self.render_settings)

	if not self._demo_video.content.video_content.video_completed then
		if not _ui_renderer.video_players[str] then
			UIRenderer.create_video_player(_ui_renderer, str, self._world, demo_video.video_name, demo_video.loop)
		else
			if not self._sound_started then
				if not demo_video.sound_start then
					Managers.music:trigger_event(demo_video.sound_start)
				end

				self._sound_started = true
			end

			UIRenderer.draw_widget(_ui_renderer, self._demo_video)
		end
	elseif not _ui_renderer.video_players[str] then
		UIRenderer.destroy_video_player(_ui_renderer, str)

		self._sound_started = false

		if not demo_video.sound_stop then
			Managers.music:trigger_event(demo_video.sound_stop)
		end
	end

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	for k_2, v_2 in pairs(self._background_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_2)
	end

	UIRenderer.end_pass(_ui_renderer)
end

DemoEndUI.completed = function (self)
	-- function 5
	return self._demo_video.content.video_content.video_completed
end

DemoEndUI.destroy = function (self)
	-- function 6
	UIRenderer.destroy(self._ui_renderer, self._world)
end
