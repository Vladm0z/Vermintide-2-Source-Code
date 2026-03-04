-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_background.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_background_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions

StoreWindowBackground = class(StoreWindowBackground)
StoreWindowBackground.NAME = "StoreWindowBackground"

StoreWindowBackground.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate StoreWindowBackground")

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent

	local var_1_0, var_1_1 = arg_1_0._parent:get_renderers()

	arg_1_0._ui_renderer = var_1_0
	arg_1_0._ui_top_renderer = var_1_1
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._layout_settings = arg_1_1.layout_settings
	arg_1_0._animations = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
end

StoreWindowBackground._create_viewport_definition = function (arg_2_0)
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

StoreWindowBackground._create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0._viewport_widget then
		UIWidget.destroy(arg_3_0.ui_renderer, arg_3_0._viewport_widget)

		arg_3_0._viewport_widget = nil
	end

	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_2 = UIWidget.init(iter_3_1)

		var_3_0[#var_3_0 + 1] = var_3_2
		var_3_1[iter_3_0] = var_3_2
	end

	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1
	arg_3_0._viewport_widget_definition = arg_3_0:_create_viewport_definition()

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_3)

	if arg_3_2 then
		local var_3_3 = arg_3_0._ui_scenegraph.window.local_position

		var_3_3[1] = var_3_3[1] + arg_3_2[1]
		var_3_3[2] = var_3_3[2] + arg_3_2[2]
		var_3_3[3] = var_3_3[3] + arg_3_2[3]
	end
end

StoreWindowBackground.on_exit = function (arg_4_0, arg_4_1)
	print("[HeroViewWindow] Exit Substate StoreWindowBackground")

	arg_4_0._ui_animator = nil

	if arg_4_0._viewport_widget then
		UIWidget.destroy(arg_4_0.ui_renderer, arg_4_0._viewport_widget)

		arg_4_0._viewport_widget = nil
	end
end

StoreWindowBackground.update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_update_animations(arg_5_1, arg_5_2)
	arg_5_0:_draw(arg_5_1)
end

StoreWindowBackground.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0._viewport_widget and arg_6_0._viewport_widget_definition then
		arg_6_0._viewport_widget = UIWidget.init(arg_6_0._viewport_widget_definition)

		arg_6_0:_hide_object_sets()
	end
end

StoreWindowBackground._hide_object_sets = function (arg_7_0)
	local var_7_0 = arg_7_0._viewport_widget.element.pass_data[1]
	local var_7_1 = arg_7_0._viewport_widget_definition.style.viewport.level_name
	local var_7_2 = var_7_0.level
	local var_7_3 = LevelResource.object_set_names(var_7_1)

	for iter_7_0, iter_7_1 in ipairs(var_7_3) do
		local var_7_4 = LevelResource.unit_indices_in_object_set(var_7_1, iter_7_1)

		for iter_7_2, iter_7_3 in pairs(var_7_4) do
			local var_7_5 = Level.unit_by_index(var_7_2, iter_7_3)

			if Unit.alive(var_7_5) then
				Unit.set_unit_visibility(var_7_5, false)
				Unit.flow_event(var_7_5, "unit_object_set_disabled")
			end
		end
	end
end

StoreWindowBackground._update_animations = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0._ui_animator:update(arg_8_1)

	local var_8_0 = arg_8_0._animations
	local var_8_1 = arg_8_0._ui_animator

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if var_8_1:is_animation_completed(iter_8_1) then
			var_8_1:stop_animation(iter_8_1)

			var_8_0[iter_8_0] = nil
		end
	end
end

StoreWindowBackground._is_button_pressed = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1.content.button_hotspot

	if var_9_0.on_release then
		var_9_0.on_release = false

		return true
	end
end

StoreWindowBackground._is_stepper_button_pressed = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.content
	local var_10_1 = var_10_0.button_hotspot_left
	local var_10_2 = var_10_0.button_hotspot_right

	if var_10_1.on_release then
		var_10_1.on_release = false

		return true, -1
	elseif var_10_2.on_release then
		var_10_2.on_release = false

		return true, 1
	end
end

StoreWindowBackground._draw = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._ui_renderer
	local var_11_1 = arg_11_0._ui_top_renderer
	local var_11_2 = arg_11_0._ui_scenegraph
	local var_11_3 = arg_11_0._parent:window_input_service()

	UIRenderer.begin_pass(var_11_1, var_11_2, var_11_3, arg_11_1, nil, arg_11_0._render_settings)
	UIRenderer.end_pass(var_11_1)
	UIRenderer.begin_pass(var_11_0, var_11_2, var_11_3, arg_11_1, nil, arg_11_0._render_settings)

	if arg_11_0._viewport_widget then
		UIRenderer.draw_widget(var_11_0, arg_11_0._viewport_widget)
	end

	for iter_11_0, iter_11_1 in ipairs(arg_11_0._widgets) do
		UIRenderer.draw_widget(var_11_0, iter_11_1)
	end

	UIRenderer.end_pass(var_11_0)
end

StoreWindowBackground._play_sound = function (arg_12_0, arg_12_1)
	arg_12_0._parent:play_sound(arg_12_1)
end
