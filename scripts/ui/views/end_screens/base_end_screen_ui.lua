-- chunkname: @scripts/ui/views/end_screens/base_end_screen_ui.lua

require("scripts/ui/hud_ui/rewards_popup_ui")

BaseEndScreenUI = class(BaseEndScreenUI)

BaseEndScreenUI.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._ui_renderer = arg_1_1.ui_top_renderer
	self._ingame_ui_context = arg_1_1
	self._params = arg_1_4

	local world_manager = arg_1_1.world_manager
	local world = world_manager:world("level_world")

	self._wwise_world = world_manager:wwise_world(world)
	self._input_service = arg_1_2
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._draw_flags = {
		alpha_multiplier = 0
	}
	self._started = false
	self._completed = false
	self._rewards_popup = RewardsPopupUI:new(nil, arg_1_1)

	self:_setup_rewards(arg_1_4)
	self:_create_ui_elements(arg_1_3)
end

BaseEndScreenUI._setup_rewards = function (self, arg_2_1)
	-- function 2
	local flag = not arg_2_1 and arg_2_1.rewards

	if not flag then
		self._rewards_popup:present_rewards(flag)
	end
end

BaseEndScreenUI.destroy = function (self)
	-- function 3
	self._rewards_popup:destroy()
	self:_destroy()
end

BaseEndScreenUI.on_fade_in = function (self)
	-- function 4
	self:_on_fade_in()
end

BaseEndScreenUI._on_fade_in = function (arg_5_0)
	-- function 5
	return
end

BaseEndScreenUI._start = function (arg_6_0)
	-- function 6
	return
end

BaseEndScreenUI._update = function (arg_7_0, arg_7_1)
	-- function 7
	return
end

BaseEndScreenUI._destroy = function (arg_8_0)
	-- function 8
	return
end

BaseEndScreenUI._draw_widgets = function (arg_9_0, arg_9_1)
	-- function 9
	return
end

BaseEndScreenUI._on_completed = function (self)
	-- function 10
	self._completed = true
end

BaseEndScreenUI.completed = function (self)
	-- function 11
	local _completed = self._completed

	_completed = not _completed and self._rewards_popup:all_presentations_done()

	return _completed
end

BaseEndScreenUI._play_sound = function (self, arg_12_1)
	-- function 12
	WwiseWorld.trigger_event(self._wwise_world, arg_12_1)
end

BaseEndScreenUI._create_ui_elements = function (self, arg_13_1)
	-- function 13
	self._ui_scenegraph = UISceneGraph.init_scenegraph(arg_13_1.scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(arg_13_1.widget_definitions)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, arg_13_1.animation_definitions)
end

BaseEndScreenUI.start = function (self)
	-- function 14
	self._started = true

	self:_start()
end

BaseEndScreenUI.started = function (self)
	-- function 15
	return self._started
end

BaseEndScreenUI.update = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not self._started then
		return
	end

	self._ui_animator:update(arg_16_1, arg_16_2)
	self._rewards_popup:update(arg_16_1, arg_16_2)
	self:_update(arg_16_1)
end

BaseEndScreenUI.draw = function (self, arg_17_1)
	-- function 17
	if not self._started then
		return
	end

	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_service = self._input_service
	local _render_settings = self._render_settings
	local alpha_multiplier = self._draw_flags.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 0
	_render_settings.alpha_multiplier = alpha_multiplier

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, _input_service, arg_17_1, nil, _render_settings)
	UIRenderer.draw_all_widgets(_ui_renderer, self._widgets)
	self:_draw_widgets(_ui_renderer, _render_settings)
	UIRenderer.end_pass(_ui_renderer)
end
