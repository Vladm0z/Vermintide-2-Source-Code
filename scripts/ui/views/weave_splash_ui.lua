-- chunkname: @scripts/ui/views/weave_splash_ui.lua

local var_0_0 = local_require("scripts/ui/views/weave_splash_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widget_definitions = var_0_0.widget_definitions
local create_weave_image_func = var_0_0.create_weave_image_func
local tbl = {
	"weave_loading_screen"
}
local num = 5

WeaveSplashUI = class(WeaveSplashUI)

WeaveSplashUI.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._current_splash_index = 1
	self._current_timer = not (#tbl > 1) or num

	self:_setup_ui()
	self:_create_ui_elements()
end

WeaveSplashUI._setup_ui = function (self)
	-- function 2
	self._render_settings = {
		alpha_multiplier = 1
	}
	self._ui_renderer = UIRenderer.create(self._world, "material", "materials/ui/loading_screens/loading_screen_default")
end

WeaveSplashUI._create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._animations = {}
	self._widgets = {}
	self._weave_splash_widgets = {}

	for k, v in pairs(widget_definitions) do
		self._widgets[k] = UIWidget.init(v)
	end

	local mechanism_setting = Managers.mechanism:mechanism_setting("loading_screen_override")

	mechanism_setting = mechanism_setting or tbl[1]

	local var_3_1 = create_weave_image_func(mechanism_setting, 255)

	self._weave_splash_widgets[#self._weave_splash_widgets + 1] = UIWidget.init(var_3_1)

	local num = 1 + self._current_splash_index % #tbl
	local var_3_3 = tbl[num]
	local var_3_4 = create_weave_image_func(var_3_3, 0)

	self._weave_splash_widgets[#self._weave_splash_widgets + 1] = UIWidget.init(var_3_4)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

WeaveSplashUI.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_update_animations(arg_4_1, arg_4_2)
	self:_draw(arg_4_1, arg_4_2)
	self:_update_current_splash(arg_4_1, arg_4_2)
end

WeaveSplashUI._update_animations = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not UIAnimation.completed(v) then
			UIAnimation.update(v, arg_5_1)
		else
			_animations[k] = nil

			if not table.is_empty(self._animations) then
				self._current_timer = num
			end
		end
	end
end

WeaveSplashUI._update_current_splash = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._current_timer then
		return
	end

	self._current_timer = self._current_timer - arg_6_1

	if self._current_timer <= 0 then
		local _current_splash_index = self._current_splash_index

		self._current_splash_index = 1 + self._current_splash_index % #tbl

		local content = self._weave_splash_widgets[1].content
		local bg_texture = self._weave_splash_widgets[1].style.bg_texture
		local content_2 = self._weave_splash_widgets[2].content
		local bg_texture_2 = self._weave_splash_widgets[2].style.bg_texture

		content.bg_texture = tbl[_current_splash_index]
		content_2.bg_texture = tbl[self._current_splash_index]
		self._animations.splash_image_1 = UIAnimation.init(UIAnimation.function_by_time, bg_texture.color, 1, 255, 0, 0.5, math.easeInCubic)
		self._animations.splash_image_2 = UIAnimation.init(UIAnimation.function_by_time, bg_texture_2.color, 1, 0, 255, 0.5, math.easeInCubic)
		self._current_timer = nil
	end
end

WeaveSplashUI._draw = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, arg_7_1, nil, _render_settings)

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	for i, v_2 in ipairs(self._weave_splash_widgets) do
		UIRenderer.draw_widget(_ui_renderer, v_2)
	end

	UIRenderer.end_pass(_ui_renderer)
end

WeaveSplashUI.destroy = function (self)
	-- function 8
	UIRenderer.destroy(self._ui_renderer, self._world)
end

WeaveSplashUI.clear_user_name = function (arg_9_0)
	-- function 9
	return
end
