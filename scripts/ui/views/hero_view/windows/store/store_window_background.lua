-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_background.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_background_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StoreWindowBackground = class(StoreWindowBackground)
StoreWindowBackground.NAME = "StoreWindowBackground"

StoreWindowBackground.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate StoreWindowBackground")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local get_renderers, var_1_1 = self._parent:get_renderers()

	self._ui_renderer = get_renderers
	self._ui_top_renderer = var_1_1
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._layout_settings = arg_1_1.layout_settings
	self._animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
end

StoreWindowBackground._create_viewport_definition = function (arg_2_0)
	-- function 2
	return {
		scenegraph_id = "screen",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 960,
				viewport_name = "store_background_viewport",
				clear_screen_on_create = true,
				level_name = "levels/ui_keep_menu/world",
				enable_sub_gui = false,
				fov = 50,
				world_name = "store_background",
				world_flags = {
					Application.DISABLE_SOUND,
					Application.DISABLE_ESRAM,
					Application.ENABLE_VOLUMETRICS
				},
				object_sets = LevelResource.object_set_names("levels/ui_keep_menu/world"),
				camera_position = {
					0,
					2.8,
					0.9
				},
				camera_lookat = {
					0,
					-2.8,
					0.9
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

StoreWindowBackground._create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end

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
	self._viewport_widget_definition = self:_create_viewport_definition()

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end
end

StoreWindowBackground.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate StoreWindowBackground")

	self._ui_animator = nil

	if not self._viewport_widget then
		UIWidget.destroy(self.ui_renderer, self._viewport_widget)

		self._viewport_widget = nil
	end
end

StoreWindowBackground.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_update_animations(arg_5_1, arg_5_2)
	self:_draw(arg_5_1)
end

StoreWindowBackground.post_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if self._viewport_widget or not self._viewport_widget_definition then
		self._viewport_widget = UIWidget.init(self._viewport_widget_definition)

		self:_hide_object_sets()
	end
end

StoreWindowBackground._hide_object_sets = function (self)
	-- function 7
	local var_7_0 = self._viewport_widget.element.pass_data[1]
	local level_name = self._viewport_widget_definition.style.viewport.level_name
	local level = var_7_0.level
	local object_set_names = LevelResource.object_set_names(level_name)

	for i, v in ipairs(object_set_names) do
		local unit_indices_in_object_set = LevelResource.unit_indices_in_object_set(level_name, v)

		for k, v_2 in pairs(unit_indices_in_object_set) do
			local unit_by_index = Level.unit_by_index(level, v_2)

			if not Unit.alive(unit_by_index) then
				Unit.set_unit_visibility(unit_by_index, false)
				Unit.flow_event(unit_by_index, "unit_object_set_disabled")
			end
		end
	end
end

StoreWindowBackground._update_animations = function (self, arg_8_1, arg_8_2)
	-- function 8
	self._ui_animator:update(arg_8_1)

	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StoreWindowBackground._is_button_pressed = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StoreWindowBackground._is_stepper_button_pressed = function (arg_10_0, arg_10_1)
	-- function 10
	local content = arg_10_1.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if not button_hotspot_left.on_release then
		button_hotspot_left.on_release = false

		return true, -1
	elseif not button_hotspot_right.on_release then
		button_hotspot_right.on_release = false

		return true, 1
	end
end

StoreWindowBackground._draw = function (self, arg_11_1)
	-- function 11
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_11_1, nil, self._render_settings)
	UIRenderer.end_pass(_ui_top_renderer)
	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, window_input_service, arg_11_1, nil, self._render_settings)

	if not self._viewport_widget then
		UIRenderer.draw_widget(_ui_renderer, self._viewport_widget)
	end

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	UIRenderer.end_pass(_ui_renderer)
end

StoreWindowBackground._play_sound = function (self, arg_12_1)
	-- function 12
	self._parent:play_sound(arg_12_1)
end
