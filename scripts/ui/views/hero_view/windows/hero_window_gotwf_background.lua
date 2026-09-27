-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_gotwf_background.lua

require("scripts/ui/views/menu_world_previewer")
require("scripts/settings/hero_statistics_template")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_background_definitions")
local widgets = var_0_0.widgets
local viewport_widgets = var_0_0.viewport_widgets
local background_rect = var_0_0.background_rect
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local camera_position_by_character = var_0_0.camera_position_by_character
local loading_overlay_widgets = var_0_0.loading_overlay_widgets

HeroWindowGotwfBackground = class(HeroWindowGotwfBackground)
HeroWindowGotwfBackground.NAME = "HeroWindowGotwfBackground"

HeroWindowGotwfBackground.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowGotwfBackground")

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._params = arg_1_1
	self._parent = arg_1_1.parent
	self._world = ingame_ui_context.world
	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._is_in_inn = ingame_ui_context.is_in_inn
	self._hero_name = arg_1_1.hero_name
	self._career_index = arg_1_1.career_index
	self._skin_sync_id = self._parent.skin_sync_id
	self._camera_move_duration = UISettings.console_menu_camera_move_duration
	self._animations = {}
	self._animation_callbacks = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
end

HeroWindowGotwfBackground._start_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		parent = self._parent,
		render_settings = self._render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self._ui_animator:start_animation(arg_2_1, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowGotwfBackground._create_viewport_definition = function (arg_3_0)
	-- function 3
	return {
		scenegraph_id = "screen",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 2,
				viewport_name = "character_preview_viewport",
				clear_screen_on_create = true,
				level_name = "levels/gifts_of_the_wolf_father/gifts_of_wolf_father",
				enable_sub_gui = false,
				fov = 50,
				world_name = "character_preview",
				world_flags = {
					Application.DISABLE_SOUND,
					Application.DISABLE_ESRAM,
					Application.ENABLE_VOLUMETRICS
				},
				object_sets = LevelResource.object_set_names("levels/gifts_of_the_wolf_father/gifts_of_wolf_father"),
				camera_position = {
					10,
					0,
					0
				},
				camera_lookat = {
					0,
					0,
					0
				}
			}
		},
		content = {
			button_hotspot = {
				allow_multi_hover = true
			}
		}
	}
end

HeroWindowGotwfBackground._create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._viewport_widget then
		UIWidget.destroy(self._ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(viewport_widgets) do
		local var_4_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_2
		tbl_2[k] = var_4_2
	end

	self._viewport_widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(loading_overlay_widgets) do
		local var_4_5 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_4_5
		tbl_4[k_2] = var_4_5
	end

	self._loading_overlay_widgets = tbl_3
	self._loading_overlay_widgets_by_name = tbl_4

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end

	if not self._is_in_inn then
		local str = "resource_packages/dlcs/gotwf_store_resources"
		local str_2 = "gotwf_store_resources"
		local var_4_9 = callback(self, "_package_loaded")
		local flag = true
		local flag_2 = true

		Managers.package:load(str, str_2, var_4_9, flag, flag_2)

		self._package_name = str
		self._package_reference_name = str_2
		self._show_loading_overlay = true
		self._params.loading_package = true
	else
		self._background_widget = UIWidget.init(background_rect)
	end
end

HeroWindowGotwfBackground._package_loaded = function (self)
	-- function 5
	self._viewport_widget_definition = self:_create_viewport_definition()
	self._fadeout_loading_overlay = true
end

HeroWindowGotwfBackground.on_exit = function (self, arg_6_1)
	-- function 6
	print("[HeroViewWindow] Exit Substate HeroWindowGotwfBackground")

	self._ui_animator = nil

	if not self._world_previewer then
		self._world_previewer:prepare_exit()
		self._world_previewer:on_exit()
		self._world_previewer:destroy()
	end

	if not self._viewport_widget then
		UIWidget.destroy(self._ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	if not self._package_reference_name and not Managers.package:has_loaded(self._package_name, self._package_reference_name) then
		Managers.package:unload(self._package_name, self._package_reference_name)

		self._package_name = nil
		self._package_reference_name = nil
	end
end

HeroWindowGotwfBackground.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:_update_pan(arg_7_1, arg_7_2)
	self:_update_animations(arg_7_1, arg_7_2)
	self:_draw(arg_7_1, arg_7_2)
end

HeroWindowGotwfBackground._update_pan = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self._world_previewer then
		return
	end

	local _start_t = self._start_t

	_start_t = _start_t or 0
	self._start_t = _start_t

	local num = 0.0025
	local num_2 = 38
	local num_3 = 1
	local num_4 = 1 / num

	self._start_t = self._start_t + arg_8_1 * num

	local num_5 = self._start_t * num_2 % num_2

	self._world_previewer:set_default_position({
		z = 53,
		y = 266,
		x = -62 + num_5
	})
	self._world_previewer:set_lookat_target(Vector3Box(num_5, 0, 53))

	local flag = true

	self._world_previewer:update(arg_8_1, arg_8_2, flag)

	local background_fade = self._widgets_by_name.background_fade

	background_fade.content.progress = num_5 / num_2
	background_fade.content.fade_start = (num_4 - num_3) / num_4
end

HeroWindowGotwfBackground.post_update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not (not self._viewport_widget_definition and self._viewport_widget) then
		self._viewport_widget = UIWidget.init(self._viewport_widget_definition)

		local world = Managers.world:world("character_preview")
		local flag = false
		local _is_in_inn = self._is_in_inn
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local get_layout_name = self._parent:get_layout_name()

		self._parent:create_layout_renderer(get_layout_name, world, flag, _is_in_inn, current_mechanism_name)
	end

	self:_update_loading_overlay_fadeout_animation(arg_9_1)

	if self._initialized or not self._viewport_widget then
		local var_9_5 = MenuWorldPreviewer:new(self._ingame_ui_context, camera_position_by_character, "HeroWindowGotwfBackground")

		var_9_5:on_enter(self._viewport_widget, self._hero_name)
		var_9_5:set_default_position({
			z = 53,
			x = -62,
			y = 266
		})
		var_9_5:set_lookat_target(Vector3Box(0, 0, 53))

		self._world_previewer = var_9_5
		self._initialized = true
	end

	if not self._world_previewer then
		self._world_previewer:post_update(arg_9_1, arg_9_2)
	end
end

HeroWindowGotwfBackground._update_animations = function (self, arg_10_1)
	-- function 10
	self._ui_animator:update(arg_10_1)

	local _animations = self._animations
	local _animation_callbacks = self._animation_callbacks
	local _ui_animator = self._ui_animator

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil

			local var_10_3 = _animation_callbacks[k]

			if not var_10_3 then
				var_10_3()

				_animation_callbacks[k] = nil
			end
		end
	end
end

HeroWindowGotwfBackground._draw = function (self, arg_11_1)
	-- function 11
	local _ui_renderer = self._ui_renderer
	local get_layout_renderer = self._parent:get_layout_renderer()
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_11_1, nil, self._render_settings)

	if not self._show_loading_overlay then
		for i, v in ipairs(self._loading_overlay_widgets) do
			UIRenderer.draw_widget(_ui_top_renderer, v)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not self._viewport_widget then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, window_input_service, arg_11_1, nil, self._render_settings)
		UIRenderer.draw_widget(_ui_renderer, self._viewport_widget)
		UIRenderer.end_pass(_ui_renderer)
	elseif not self._background_widget then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, window_input_service, arg_11_1, nil, self._render_settings)
		UIRenderer.draw_widget(_ui_renderer, self._background_widget)
		UIRenderer.end_pass(_ui_renderer)
	end

	if not get_layout_renderer then
		UIRenderer.begin_pass(get_layout_renderer, _ui_scenegraph, window_input_service, arg_11_1, nil, self._render_settings)

		for i_2, v_2 in ipairs(self._viewport_widgets) do
			UIRenderer.draw_widget(get_layout_renderer, v_2)
		end

		UIRenderer.end_pass(get_layout_renderer)
	end
end

HeroWindowGotwfBackground._update_loading_overlay_fadeout_animation = function (self, arg_12_1)
	-- function 12
	if not self._fadeout_loading_overlay then
		return
	end

	local _loading_overlay_widgets_by_name = self._loading_overlay_widgets_by_name
	local num = 255
	local num_2 = 0
	local num_3 = 2
	local min = math.min
	local num_4 = 1
	local _fadeout_progress = self._fadeout_progress

	_fadeout_progress = _fadeout_progress or 0

	local var_12_7 = min(num_4, _fadeout_progress + num_3 * arg_12_1)
	local lerp = math.lerp(num, num_2, math.easeInCubic(var_12_7))
	local loading_overlay = _loading_overlay_widgets_by_name.loading_overlay
	local loading_overlay_loading_glow = _loading_overlay_widgets_by_name.loading_overlay_loading_glow
	local loading_overlay_loading_frame = _loading_overlay_widgets_by_name.loading_overlay_loading_frame

	loading_overlay.style.rect.color[1] = lerp
	loading_overlay_loading_glow.style.texture_id.color[1] = lerp
	loading_overlay_loading_frame.style.texture_id.color[1] = lerp
	self._fadeout_progress = var_12_7

	if var_12_7 == 1 then
		self._fadeout_loading_overlay = nil
		self._fadeout_progress = nil
		self._show_loading_overlay = false
		self._params.loading_package = false
	end
end
