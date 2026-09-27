-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_background_console.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_background_console_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local camera_position_by_character = var_0_0.camera_position_by_character
local loading_overlay_widgets = var_0_0.loading_overlay_widgets

StartGameWindowBackgroundConsole = class(StartGameWindowBackgroundConsole)
StartGameWindowBackgroundConsole.NAME = "StartGameWindowBackgroundConsole"

StartGameWindowBackgroundConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameViewWindow] Enter Substate StartGameWindowBackgroundConsole")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
	self:_setup_object_sets()
end

StartGameWindowBackgroundConsole._get_with_mechanism = function (self, arg_2_1)
	-- function 2
	local var_2_0 = arg_2_1[self.parent:get_mechanism_name()]

	var_2_0 = var_2_0 or arg_2_1.adventure

	return var_2_0
end

local tbl = {
	versus = "menu_versus",
	adventure = "default",
	deus = "menu_chaos_wastes_01"
}

StartGameWindowBackgroundConsole._create_viewport_definition = function (arg_3_0)
	-- function 3
	return {
		scenegraph_id = "root_fit",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 990,
				viewport_name = "character_preview_viewport",
				shading_environment = "environment/ui_end_screen",
				clear_screen_on_create = true,
				mood_setting = "default",
				level_name = "levels/ui_keep_menu/world",
				enable_sub_gui = false,
				fov = 50,
				world_name = "character_preview",
				world_flags = {
					Application.DISABLE_SOUND,
					Application.DISABLE_ESRAM,
					Application.ENABLE_VOLUMETRICS
				},
				object_sets = LevelResource.object_set_names("levels/ui_keep_menu/world"),
				camera_position = {
					0,
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

StartGameWindowBackgroundConsole.create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._viewport_widget_definition = self:_create_viewport_definition()

	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._loading_overlay_widgets, self._loading_overlay_widgets_by_name = UIUtils.create_widgets(loading_overlay_widgets)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end
end

StartGameWindowBackgroundConsole._setup_object_sets = function (self)
	-- function 5
	local level_name = self._viewport_widget_definition.style.viewport.level_name
	local object_set_names = LevelResource.object_set_names(level_name)

	self._object_sets = {}

	for i = 1, #object_set_names do
		local var_5_2 = object_set_names[i]

		self._object_sets[var_5_2] = LevelResource.unit_indices_in_object_set(level_name, var_5_2)
	end
end

StartGameWindowBackgroundConsole.on_exit = function (self, arg_6_1)
	-- function 6
	print("[StartGameViewWindow] Exit Substate StartGameWindowBackgroundConsole")

	self.ui_animator = nil

	if not self.world_previewer then
		self.world_previewer:prepare_exit()
		self.world_previewer:on_exit()
		self.world_previewer:destroy()
	end

	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end
end

StartGameWindowBackgroundConsole.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:_update_animations(arg_7_1)
	self:draw(arg_7_1)

	if not self.world_previewer then
		local flag = true

		self.world_previewer:update(arg_7_1, arg_7_2, flag)

		local get_selected_layout_name = self.parent:get_selected_layout_name()

		if get_selected_layout_name ~= self._current_layout_name then
			self._current_layout_name = get_selected_layout_name

			self:_update_object_sets(get_selected_layout_name)
		end
	end
end

StartGameWindowBackgroundConsole._update_object_sets = function (self, arg_8_1)
	-- function 8
	local get_layout_setting_by_name = self.parent:get_layout_setting_by_name(arg_8_1)
	local background_object_set = get_layout_setting_by_name.background_object_set
	local background_flow_event = get_layout_setting_by_name.background_flow_event
	local world_previewer = self.world_previewer

	for k, v in pairs(self._object_sets) do
		local flag = k == background_object_set

		world_previewer:show_level_units(v, flag)
	end

	if not background_flow_event then
		world_previewer:trigger_level_flow_event(background_flow_event)
	end
end

StartGameWindowBackgroundConsole.post_update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not self._viewport_widget then
		self._viewport_widget = UIWidget.init(self._viewport_widget_definition)
		self._fadeout_loading_overlay = true
	end

	self:_update_loading_overlay_fadeout_animation(arg_9_1)

	if self.initialized or not self._viewport_widget then
		local var_9_0 = MenuWorldPreviewer:new(self.ingame_ui_context, camera_position_by_character, "StartGameWindowBackgroundConsole")
		local var_9_1

		var_9_0:on_enter(self._viewport_widget, var_9_1)

		self.world_previewer = var_9_0
		self.initialized = true
	end

	if not self.world_previewer then
		self.world_previewer:post_update(arg_9_1, arg_9_2)
	end
end

StartGameWindowBackgroundConsole._update_animations = function (self, arg_10_1)
	-- function 10
	local ui_animator = self.ui_animator

	self.ui_animator:update(arg_10_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			_animations[k] = nil
		end
	end
end

StartGameWindowBackgroundConsole.draw = function (self, arg_11_1)
	-- function 11
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	if not self._show_loading_overlay then
		UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_11_1, nil, self.render_settings)
		UIRenderer.draw_all_widgets(ui_top_renderer, self._loading_overlay_widgets)
		UIRenderer.end_pass(ui_top_renderer)
	end

	if not self._viewport_widget then
		local ui_renderer = self.ui_renderer

		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_11_1, nil, self.render_settings)
		UIRenderer.draw_widget(ui_renderer, self._viewport_widget)
		UIRenderer.end_pass(ui_renderer)
	end
end

StartGameWindowBackgroundConsole._update_loading_overlay_fadeout_animation = function (self, arg_12_1)
	-- function 12
	if not self._fadeout_loading_overlay then
		return
	end

	local num = 255
	local num_2 = 0
	local num_3 = 9
	local min = math.min
	local num_4 = 1
	local _fadeout_progress = self._fadeout_progress

	_fadeout_progress = _fadeout_progress or 0

	local var_12_6 = min(num_4, _fadeout_progress + num_3 * arg_12_1)
	local lerp = math.lerp(num, num_2, math.easeInCubic(var_12_6))
	local _loading_overlay_widgets_by_name = self._loading_overlay_widgets_by_name
	local loading_overlay = _loading_overlay_widgets_by_name.loading_overlay
	local loading_overlay_loading_glow = _loading_overlay_widgets_by_name.loading_overlay_loading_glow
	local loading_overlay_loading_frame = _loading_overlay_widgets_by_name.loading_overlay_loading_frame

	loading_overlay.style.rect.color[1] = lerp
	loading_overlay_loading_glow.style.texture_id.color[1] = lerp
	loading_overlay_loading_frame.style.texture_id.color[1] = lerp
	self._fadeout_progress = var_12_6

	if var_12_6 == 1 then
		self._fadeout_loading_overlay = nil
		self._fadeout_progress = nil
		self._show_loading_overlay = false
	end
end
