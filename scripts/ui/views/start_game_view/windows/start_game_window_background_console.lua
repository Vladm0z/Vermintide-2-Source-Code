-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_background_console.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_background_console_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.animation_definitions
local var_0_3 = var_0_0.camera_position_by_character
local var_0_4 = var_0_0.loading_overlay_widgets

StartGameWindowBackgroundConsole = class(StartGameWindowBackgroundConsole)
StartGameWindowBackgroundConsole.NAME = "StartGameWindowBackgroundConsole"

function StartGameWindowBackgroundConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameViewWindow] Enter Substate StartGameWindowBackgroundConsole")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ingame_ui_context = var_1_0
	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_setup_object_sets()
end

function StartGameWindowBackgroundConsole._get_with_mechanism(arg_2_0, arg_2_1)
	return arg_2_1[arg_2_0.parent:get_mechanism_name()] or arg_2_1.adventure
end

local var_0_5 = {
	versus = "menu_versus",
	adventure = "default",
	deus = "menu_chaos_wastes_01"
}

function StartGameWindowBackgroundConsole._create_viewport_definition(arg_3_0)
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

function StartGameWindowBackgroundConsole.create_ui_elements(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._viewport_widget_definition = arg_4_0:_create_viewport_definition()

	if arg_4_0._viewport_widget then
		UIWidget.destroy(arg_4_0.ui_renderer, arg_4_0._viewport_widget)

		arg_4_0._viewport_widget = nil
	end

	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_4_0._loading_overlay_widgets, arg_4_0._loading_overlay_widgets_by_name = UIUtils.create_widgets(var_0_4)

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_2)

	if arg_4_2 then
		local var_4_0 = arg_4_0.ui_scenegraph.window.local_position

		var_4_0[1] = var_4_0[1] + arg_4_2[1]
		var_4_0[2] = var_4_0[2] + arg_4_2[2]
		var_4_0[3] = var_4_0[3] + arg_4_2[3]
	end
end

function StartGameWindowBackgroundConsole._setup_object_sets(arg_5_0)
	local var_5_0 = arg_5_0._viewport_widget_definition.style.viewport.level_name
	local var_5_1 = LevelResource.object_set_names(var_5_0)

	arg_5_0._object_sets = {}

	for iter_5_0 = 1, #var_5_1 do
		local var_5_2 = var_5_1[iter_5_0]

		arg_5_0._object_sets[var_5_2] = LevelResource.unit_indices_in_object_set(var_5_0, var_5_2)
	end
end

function StartGameWindowBackgroundConsole.on_exit(arg_6_0, arg_6_1)
	print("[StartGameViewWindow] Exit Substate StartGameWindowBackgroundConsole")

	arg_6_0.ui_animator = nil

	if arg_6_0.world_previewer then
		arg_6_0.world_previewer:prepare_exit()
		arg_6_0.world_previewer:on_exit()
		arg_6_0.world_previewer:destroy()
	end

	if arg_6_0._viewport_widget then
		UIWidget.destroy(arg_6_0.ui_renderer, arg_6_0._viewport_widget)

		arg_6_0._viewport_widget = nil
	end
end

function StartGameWindowBackgroundConsole.update(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:_update_animations(arg_7_1)
	arg_7_0:draw(arg_7_1)

	if arg_7_0.world_previewer then
		local var_7_0 = true

		arg_7_0.world_previewer:update(arg_7_1, arg_7_2, var_7_0)

		local var_7_1 = arg_7_0.parent:get_selected_layout_name()

		if var_7_1 ~= arg_7_0._current_layout_name then
			arg_7_0._current_layout_name = var_7_1

			arg_7_0:_update_object_sets(var_7_1)
		end
	end
end

function StartGameWindowBackgroundConsole._update_object_sets(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.parent:get_layout_setting_by_name(arg_8_1)
	local var_8_1 = var_8_0.background_object_set
	local var_8_2 = var_8_0.background_flow_event
	local var_8_3 = arg_8_0.world_previewer

	for iter_8_0, iter_8_1 in pairs(arg_8_0._object_sets) do
		local var_8_4 = iter_8_0 == var_8_1

		var_8_3:show_level_units(iter_8_1, var_8_4)
	end

	if var_8_2 then
		var_8_3:trigger_level_flow_event(var_8_2)
	end
end

function StartGameWindowBackgroundConsole.post_update(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0._viewport_widget then
		arg_9_0._viewport_widget = UIWidget.init(arg_9_0._viewport_widget_definition)
		arg_9_0._fadeout_loading_overlay = true
	end

	arg_9_0:_update_loading_overlay_fadeout_animation(arg_9_1)

	if not arg_9_0.initialized and arg_9_0._viewport_widget then
		local var_9_0 = MenuWorldPreviewer:new(arg_9_0.ingame_ui_context, var_0_3, "StartGameWindowBackgroundConsole")
		local var_9_1

		var_9_0:on_enter(arg_9_0._viewport_widget, var_9_1)

		arg_9_0.world_previewer = var_9_0
		arg_9_0.initialized = true
	end

	if arg_9_0.world_previewer then
		arg_9_0.world_previewer:post_update(arg_9_1, arg_9_2)
	end
end

function StartGameWindowBackgroundConsole._update_animations(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.ui_animator

	arg_10_0.ui_animator:update(arg_10_1)

	local var_10_1 = arg_10_0._animations

	for iter_10_0, iter_10_1 in pairs(var_10_1) do
		if var_10_0:is_animation_completed(iter_10_1) then
			var_10_1[iter_10_0] = nil
		end
	end
end

function StartGameWindowBackgroundConsole.draw(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.ui_top_renderer
	local var_11_1 = arg_11_0.ui_scenegraph
	local var_11_2 = arg_11_0.parent:window_input_service()

	if arg_11_0._show_loading_overlay then
		UIRenderer.begin_pass(var_11_0, var_11_1, var_11_2, arg_11_1, nil, arg_11_0.render_settings)
		UIRenderer.draw_all_widgets(var_11_0, arg_11_0._loading_overlay_widgets)
		UIRenderer.end_pass(var_11_0)
	end

	if arg_11_0._viewport_widget then
		local var_11_3 = arg_11_0.ui_renderer

		UIRenderer.begin_pass(var_11_3, var_11_1, var_11_2, arg_11_1, nil, arg_11_0.render_settings)
		UIRenderer.draw_widget(var_11_3, arg_11_0._viewport_widget)
		UIRenderer.end_pass(var_11_3)
	end
end

function StartGameWindowBackgroundConsole._update_loading_overlay_fadeout_animation(arg_12_0, arg_12_1)
	if not arg_12_0._fadeout_loading_overlay then
		return
	end

	local var_12_0 = 255
	local var_12_1 = 0
	local var_12_2 = 9
	local var_12_3 = math.min(1, (arg_12_0._fadeout_progress or 0) + var_12_2 * arg_12_1)
	local var_12_4 = math.lerp(var_12_0, var_12_1, math.easeInCubic(var_12_3))
	local var_12_5 = arg_12_0._loading_overlay_widgets_by_name
	local var_12_6 = var_12_5.loading_overlay
	local var_12_7 = var_12_5.loading_overlay_loading_glow
	local var_12_8 = var_12_5.loading_overlay_loading_frame

	var_12_6.style.rect.color[1] = var_12_4
	var_12_7.style.texture_id.color[1] = var_12_4
	var_12_8.style.texture_id.color[1] = var_12_4
	arg_12_0._fadeout_progress = var_12_3

	if var_12_3 == 1 then
		arg_12_0._fadeout_loading_overlay = nil
		arg_12_0._fadeout_progress = nil
		arg_12_0._show_loading_overlay = false
	end
end
