-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_weave_forge_background.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_background_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false

HeroWindowWeaveForgeBackground = class(HeroWindowWeaveForgeBackground)
HeroWindowWeaveForgeBackground.NAME = "HeroWindowWeaveForgeBackground"

HeroWindowWeaveForgeBackground.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowWeaveForgeBackground")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._ingame_ui_context = ingame_ui_context
	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	local hero_name = arg_1_1.hero_name
	local career_index = arg_1_1.career_index
	local profile_index = arg_1_1.profile_index

	self._career_name = SPProfiles[profile_index].careers[career_index].name
	self._hero_name = hero_name
end

HeroWindowWeaveForgeBackground._setup_definitions = function (self)
	-- function 2
	if not self._parent:gamepad_style_active() then
		var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_background_console_definitions")
	else
		var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_background_definitions")
	end

	widgets = var_0_0.widgets
	scenegraph_definition = var_0_0.scenegraph_definition
	animation_definitions = var_0_0.animation_definitions
end

HeroWindowWeaveForgeBackground.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:_setup_definitions()

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

HeroWindowWeaveForgeBackground.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate HeroWindowWeaveForgeBackground")

	self._ui_animator = nil
end

HeroWindowWeaveForgeBackground.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_animations(arg_5_1)
	self:_draw(arg_5_1)
end

HeroWindowWeaveForgeBackground.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

HeroWindowWeaveForgeBackground._update_animations = function (self, arg_7_1)
	-- function 7
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_7_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_7_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

HeroWindowWeaveForgeBackground._draw = function (self, arg_8_1)
	-- function 8
	local get_ui_renderer = self._parent:get_ui_renderer()
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(get_ui_renderer, _ui_scenegraph, window_input_service, arg_8_1, nil, _render_settings)

	local snap_pixel_positions = _render_settings.snap_pixel_positions
	local alpha_multiplier = _render_settings.alpha_multiplier

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(get_ui_renderer, v)
	end

	UIRenderer.end_pass(get_ui_renderer)
end
