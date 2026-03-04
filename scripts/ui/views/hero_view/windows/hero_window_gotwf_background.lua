-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_gotwf_background.lua

require("scripts/ui/views/menu_world_previewer")
require("scripts/settings/hero_statistics_template")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_background_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.viewport_widgets
local var_0_3 = var_0_0.background_rect
local var_0_4 = var_0_0.scenegraph_definition
local var_0_5 = var_0_0.animation_definitions
local var_0_6 = var_0_0.camera_position_by_character
local var_0_7 = var_0_0.loading_overlay_widgets

HeroWindowGotwfBackground = class(HeroWindowGotwfBackground)
HeroWindowGotwfBackground.NAME = "HeroWindowGotwfBackground"

function HeroWindowGotwfBackground.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[HeroViewWindow] Enter Substate HeroWindowGotwfBackground")

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._params = arg_1_1
	arg_1_0._parent = arg_1_1.parent
	arg_1_0._world = var_1_0.world
	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._is_in_inn = var_1_0.is_in_inn
	arg_1_0._hero_name = arg_1_1.hero_name
	arg_1_0._career_index = arg_1_1.career_index
	arg_1_0._skin_sync_id = arg_1_0._parent.skin_sync_id
	arg_1_0._camera_move_duration = UISettings.console_menu_camera_move_duration
	arg_1_0._animations = {}
	arg_1_0._animation_callbacks = {}

	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
end

function HeroWindowGotwfBackground._start_animation(arg_2_0, arg_2_1)
	local var_2_0 = {
		parent = arg_2_0._parent,
		render_settings = arg_2_0._render_settings
	}
	local var_2_1 = arg_2_0._widgets_by_name
	local var_2_2 = arg_2_0._ui_animator:start_animation(arg_2_1, var_2_1, var_0_4, var_2_0)

	arg_2_0._animations[arg_2_1] = var_2_2
end

function HeroWindowGotwfBackground._create_viewport_definition(arg_3_0)
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

function HeroWindowGotwfBackground._create_ui_elements(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._viewport_widget then
		UIWidget.destroy(arg_4_0._ui_renderer, arg_4_0._viewport_widget)

		arg_4_0._viewport_widget = nil
	end

	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_4)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_2) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._viewport_widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1

	local var_4_3 = {}
	local var_4_4 = {}

	for iter_4_2, iter_4_3 in pairs(var_0_7) do
		local var_4_5 = UIWidget.init(iter_4_3)

		var_4_3[#var_4_3 + 1] = var_4_5
		var_4_4[iter_4_2] = var_4_5
	end

	arg_4_0._loading_overlay_widgets = var_4_3
	arg_4_0._loading_overlay_widgets_by_name = var_4_4

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)

	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_5)

	if arg_4_2 then
		local var_4_6 = arg_4_0._ui_scenegraph.window.local_position

		var_4_6[1] = var_4_6[1] + arg_4_2[1]
		var_4_6[2] = var_4_6[2] + arg_4_2[2]
		var_4_6[3] = var_4_6[3] + arg_4_2[3]
	end

	if arg_4_0._is_in_inn then
		local var_4_7 = "resource_packages/dlcs/gotwf_store_resources"
		local var_4_8 = "gotwf_store_resources"
		local var_4_9 = callback(arg_4_0, "_package_loaded")
		local var_4_10 = true
		local var_4_11 = true

		Managers.package:load(var_4_7, var_4_8, var_4_9, var_4_10, var_4_11)

		arg_4_0._package_name = var_4_7
		arg_4_0._package_reference_name = var_4_8
		arg_4_0._show_loading_overlay = true
		arg_4_0._params.loading_package = true
	else
		arg_4_0._background_widget = UIWidget.init(var_0_3)
	end
end

function HeroWindowGotwfBackground._package_loaded(arg_5_0)
	arg_5_0._viewport_widget_definition = arg_5_0:_create_viewport_definition()
	arg_5_0._fadeout_loading_overlay = true
end

function HeroWindowGotwfBackground.on_exit(arg_6_0, arg_6_1)
	print("[HeroViewWindow] Exit Substate HeroWindowGotwfBackground")

	arg_6_0._ui_animator = nil

	if arg_6_0._world_previewer then
		arg_6_0._world_previewer:prepare_exit()
		arg_6_0._world_previewer:on_exit()
		arg_6_0._world_previewer:destroy()
	end

	if arg_6_0._viewport_widget then
		UIWidget.destroy(arg_6_0._ui_renderer, arg_6_0._viewport_widget)

		arg_6_0._viewport_widget = nil
	end

	if arg_6_0._package_reference_name and Managers.package:has_loaded(arg_6_0._package_name, arg_6_0._package_reference_name) then
		Managers.package:unload(arg_6_0._package_name, arg_6_0._package_reference_name)

		arg_6_0._package_name = nil
		arg_6_0._package_reference_name = nil
	end
end

function HeroWindowGotwfBackground.update(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:_update_pan(arg_7_1, arg_7_2)
	arg_7_0:_update_animations(arg_7_1, arg_7_2)
	arg_7_0:_draw(arg_7_1, arg_7_2)
end

function HeroWindowGotwfBackground._update_pan(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0._world_previewer then
		return
	end

	arg_8_0._start_t = arg_8_0._start_t or 0

	local var_8_0 = 0.0025
	local var_8_1 = 38
	local var_8_2 = 1
	local var_8_3 = 1 / var_8_0

	arg_8_0._start_t = arg_8_0._start_t + arg_8_1 * var_8_0

	local var_8_4 = arg_8_0._start_t * var_8_1 % var_8_1

	arg_8_0._world_previewer:set_default_position({
		z = 53,
		y = 266,
		x = -62 + var_8_4
	})
	arg_8_0._world_previewer:set_lookat_target(Vector3Box(var_8_4, 0, 53))

	local var_8_5 = true

	arg_8_0._world_previewer:update(arg_8_1, arg_8_2, var_8_5)

	local var_8_6 = arg_8_0._widgets_by_name.background_fade

	var_8_6.content.progress = var_8_4 / var_8_1
	var_8_6.content.fade_start = (var_8_3 - var_8_2) / var_8_3
end

function HeroWindowGotwfBackground.post_update(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0._viewport_widget_definition and not arg_9_0._viewport_widget then
		arg_9_0._viewport_widget = UIWidget.init(arg_9_0._viewport_widget_definition)

		local var_9_0 = Managers.world:world("character_preview")
		local var_9_1 = false
		local var_9_2 = arg_9_0._is_in_inn
		local var_9_3 = Managers.mechanism:current_mechanism_name()
		local var_9_4 = arg_9_0._parent:get_layout_name()

		arg_9_0._parent:create_layout_renderer(var_9_4, var_9_0, var_9_1, var_9_2, var_9_3)
	end

	arg_9_0:_update_loading_overlay_fadeout_animation(arg_9_1)

	if not arg_9_0._initialized and arg_9_0._viewport_widget then
		local var_9_5 = MenuWorldPreviewer:new(arg_9_0._ingame_ui_context, var_0_6, "HeroWindowGotwfBackground")

		var_9_5:on_enter(arg_9_0._viewport_widget, arg_9_0._hero_name)
		var_9_5:set_default_position({
			z = 53,
			x = -62,
			y = 266
		})
		var_9_5:set_lookat_target(Vector3Box(0, 0, 53))

		arg_9_0._world_previewer = var_9_5
		arg_9_0._initialized = true
	end

	if arg_9_0._world_previewer then
		arg_9_0._world_previewer:post_update(arg_9_1, arg_9_2)
	end
end

function HeroWindowGotwfBackground._update_animations(arg_10_0, arg_10_1)
	arg_10_0._ui_animator:update(arg_10_1)

	local var_10_0 = arg_10_0._animations
	local var_10_1 = arg_10_0._animation_callbacks
	local var_10_2 = arg_10_0._ui_animator

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if var_10_2:is_animation_completed(iter_10_1) then
			var_10_2:stop_animation(iter_10_1)

			var_10_0[iter_10_0] = nil

			local var_10_3 = var_10_1[iter_10_0]

			if var_10_3 then
				var_10_3()

				var_10_1[iter_10_0] = nil
			end
		end
	end
end

function HeroWindowGotwfBackground._draw(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._ui_renderer
	local var_11_1 = arg_11_0._parent:get_layout_renderer()
	local var_11_2 = arg_11_0._ui_top_renderer
	local var_11_3 = arg_11_0._ui_scenegraph
	local var_11_4 = arg_11_0._parent:window_input_service()

	UIRenderer.begin_pass(var_11_2, var_11_3, var_11_4, arg_11_1, nil, arg_11_0._render_settings)

	if arg_11_0._show_loading_overlay then
		for iter_11_0, iter_11_1 in ipairs(arg_11_0._loading_overlay_widgets) do
			UIRenderer.draw_widget(var_11_2, iter_11_1)
		end
	end

	UIRenderer.end_pass(var_11_2)

	if arg_11_0._viewport_widget then
		UIRenderer.begin_pass(var_11_0, var_11_3, var_11_4, arg_11_1, nil, arg_11_0._render_settings)
		UIRenderer.draw_widget(var_11_0, arg_11_0._viewport_widget)
		UIRenderer.end_pass(var_11_0)
	elseif arg_11_0._background_widget then
		UIRenderer.begin_pass(var_11_0, var_11_3, var_11_4, arg_11_1, nil, arg_11_0._render_settings)
		UIRenderer.draw_widget(var_11_0, arg_11_0._background_widget)
		UIRenderer.end_pass(var_11_0)
	end

	if var_11_1 then
		UIRenderer.begin_pass(var_11_1, var_11_3, var_11_4, arg_11_1, nil, arg_11_0._render_settings)

		for iter_11_2, iter_11_3 in ipairs(arg_11_0._viewport_widgets) do
			UIRenderer.draw_widget(var_11_1, iter_11_3)
		end

		UIRenderer.end_pass(var_11_1)
	end
end

function HeroWindowGotwfBackground._update_loading_overlay_fadeout_animation(arg_12_0, arg_12_1)
	if not arg_12_0._fadeout_loading_overlay then
		return
	end

	local var_12_0 = arg_12_0._loading_overlay_widgets_by_name
	local var_12_1 = 255
	local var_12_2 = 0
	local var_12_3 = 2
	local var_12_4 = math.min(1, (arg_12_0._fadeout_progress or 0) + var_12_3 * arg_12_1)
	local var_12_5 = math.lerp(var_12_1, var_12_2, math.easeInCubic(var_12_4))
	local var_12_6 = var_12_0.loading_overlay
	local var_12_7 = var_12_0.loading_overlay_loading_glow
	local var_12_8 = var_12_0.loading_overlay_loading_frame

	var_12_6.style.rect.color[1] = var_12_5
	var_12_7.style.texture_id.color[1] = var_12_5
	var_12_8.style.texture_id.color[1] = var_12_5
	arg_12_0._fadeout_progress = var_12_4

	if var_12_4 == 1 then
		arg_12_0._fadeout_loading_overlay = nil
		arg_12_0._fadeout_progress = nil
		arg_12_0._show_loading_overlay = false
		arg_12_0._params.loading_package = false
	end
end
