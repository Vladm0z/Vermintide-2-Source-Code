-- chunkname: @scripts/ui/round_end_emblem_popup/round_end_emblem_popup_ui.lua

local var_0_0 = local_require("scripts/ui/round_end_emblem_popup/round_end_emblem_popup_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local create_emblem_widget = var_0_0.create_emblem_widget
local animations = var_0_0.animations

RoundEndEmblemPopupUI = class(RoundEndEmblemPopupUI)

local flag = false

RoundEndEmblemPopupUI.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._input_manager = arg_1_1.input_manager
	self._world = arg_1_1.world
	self._wwise_world = arg_1_1.wwise_world or Managers.world:wwise_world(self._world)
	self._render_settings = {
		alpha_multiplier = 0,
		blur_progress = 0,
		snap_pixel_positions = true
	}
	self._viewport_world = arg_1_2

	self:_create_ui_elements()
	self:_set_title_text(arg_1_3 or "")
	self:_set_sub_title_text(arg_1_4 or "")
end

RoundEndEmblemPopupUI._set_title_text = function (arg_2_0, arg_2_1)
	-- function 2
	arg_2_0._title_title_widget.content.text = arg_2_1
end

RoundEndEmblemPopupUI._set_sub_title_text = function (arg_3_0, arg_3_1)
	-- function 3
	arg_3_0._sub_title_text_widget.content.text = arg_3_1
end

RoundEndEmblemPopupUI._create_ui_elements = function (self)
	-- function 4
	local str = "silver"

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local widget_definitions = var_0_0.widget_definitions

	self._title_title_widget = UIWidget.init(widget_definitions.title_title)
	self._sub_title_text_widget = UIWidget.init(widget_definitions.sub_title_text)
	self._emblem_widget = UIWidget.init(create_emblem_widget(str))

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animations)
	self._animations = {}

	local str_2 = "present_entry"

	self._animation_key = self:start_presentation_animation(str_2)
end

RoundEndEmblemPopupUI.set_input_manager = function (self, arg_5_1)
	-- function 5
	self._input_manager = arg_5_1
end

RoundEndEmblemPopupUI.destroy = function (self)
	-- function 6
	self._ui_animator = nil

	if not self._viewport_world and not self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false, 0, self._viewport_world)
	end
end

RoundEndEmblemPopupUI.update = function (self, arg_7_1)
	-- function 7
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	self._animations_running = self:_update_animations(arg_7_1)

	self:_draw(arg_7_1)
end

RoundEndEmblemPopupUI._update_animations = function (self, arg_8_1)
	-- function 8
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_8_1)

	if not self._animation_key and not _animations[self._animation_key] and not self._viewport_world then
		local blur_progress = self._render_settings.blur_progress

		blur_progress = blur_progress or 0

		self:set_fullscreen_effect_enable_state(true, blur_progress, self._viewport_world)
	end

	local flag = false

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil

			if not self._viewport_world and not self._fullscreen_effect_enabled then
				self:set_fullscreen_effect_enable_state(false, 0, self._viewport_world)
			end
		end

		flag = true
	end

	return flag
end

RoundEndEmblemPopupUI._draw = function (self, arg_9_1)
	-- function 9
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("end_of_level")
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_9_1, nil, _render_settings)

	local alpha_multiplier_2 = self._emblem_widget.alpha_multiplier

	alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
	_render_settings.alpha_multiplier = alpha_multiplier_2

	UIRenderer.draw_widget(_ui_top_renderer, self._emblem_widget)

	local alpha_multiplier_3 = self._title_title_widget.alpha_multiplier

	alpha_multiplier_3 = alpha_multiplier_3 or alpha_multiplier
	_render_settings.alpha_multiplier = alpha_multiplier_3

	UIRenderer.draw_widget(_ui_top_renderer, self._title_title_widget)

	local alpha_multiplier_4 = self._sub_title_text_widget.alpha_multiplier

	alpha_multiplier_4 = alpha_multiplier_4 or alpha_multiplier
	_render_settings.alpha_multiplier = alpha_multiplier_4

	UIRenderer.draw_widget(_ui_top_renderer, self._sub_title_text_widget)
	UIRenderer.end_pass(_ui_top_renderer)

	_render_settings.alpha_multiplier = alpha_multiplier
	_render_settings.alpha_multiplier = alpha_multiplier
end

RoundEndEmblemPopupUI.is_presentation_complete = function (self)
	-- function 10
	return not self._animations_running
end

RoundEndEmblemPopupUI.start_presentation_animation = function (self, arg_11_1, arg_11_2)
	-- function 11
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local flag = arg_11_2 or {
		title_title = self._title_title_widget,
		sub_title_text = self._sub_title_text_widget,
		emblem = self._emblem_widget
	}
	local start_animation = self._ui_animator:start_animation(arg_11_1, flag, scenegraph_definition, tbl)
	local str = arg_11_1 .. start_animation

	self._animations[str] = start_animation
	self._animation_params = tbl

	return str
end

RoundEndEmblemPopupUI.set_fullscreen_effect_enable_state = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local get_data = World.get_data(arg_12_3, "shading_environment")

	arg_12_2 = arg_12_2 or not arg_12_1 or 1 or 0

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_12_2 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_12_1 and 1 and 0

		set_scalar(var_12_2, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_12_6 = get_data
		local str_2 = "fullscreen_blur_amount"
		local num

		if not arg_12_1 then
			num = arg_12_2 * 0.75

			if not num then
				-- Nothing
			end
		end

		num = 0

		::label_12_0::

		set_scalar_2(var_12_6, str_2, num)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_12_1
end
