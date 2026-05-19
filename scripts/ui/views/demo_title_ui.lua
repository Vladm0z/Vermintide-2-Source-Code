-- chunkname: @scripts/ui/views/demo_title_ui.lua

require("scripts/ui/views/demo_character_previewer")

local var_0_0 = local_require("scripts/ui/views/demo_title_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.widget_definitions
local var_0_3 = var_0_0.career_widget_definitions
local var_0_4 = var_0_0.attract_mode_video
local var_0_5 = var_0_0.dead_space_filler_widget
local var_0_6 = var_0_0.create_video_func
local var_0_7 = var_0_0.start_game_button_widget
local var_0_8 = var_0_0.back_button_widget
local var_0_9 = var_0_0.console_cursor_definition
local var_0_10 = var_0_0.press_start_widget
local var_0_11 = var_0_0.single_widget_definitions

DemoTitleUI = class(DemoTitleUI)

local var_0_12 = 1920
local var_0_13 = 2
local var_0_14 = "DemoTitleUI"

function DemoTitleUI.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1
	arg_1_0._viewport = arg_1_2
	arg_1_0._parent = arg_1_3
	arg_1_0._attract_mode_active = false
	arg_1_0._character_previewers = {}
	arg_1_0._fps = 0
	arg_1_0._fps_cooldown = 0
	arg_1_0._draw_information_text = false

	arg_1_0:_setup_gui()
	arg_1_0:_setup_level()
	arg_1_0:_collect_cameras()
	arg_1_0:_position_camera()
	arg_1_0:_setup_world_gui(arg_1_3)
	arg_1_0:_create_ui_elements()
	arg_1_0:_setup_input()
end

function DemoTitleUI.menu_input_enabled(arg_2_0)
	return true
end

function DemoTitleUI._setup_gui(arg_3_0)
	arg_3_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_3_0._ui_renderer = UIRenderer.create(arg_3_0._world, "material", "materials/ui/ui_1080p_hud_single_textures", "material", "materials/ui/ui_1080p_title_screen", "material", "materials/ui/ui_1080p_start_screen", "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat", "material", var_0_4.video_name)

	local var_3_0 = {}

	for iter_3_0, iter_3_1 in pairs(CareerSettings) do
		local var_3_1 = iter_3_1.video

		var_3_0[#var_3_0 + 1] = "material"
		var_3_0[#var_3_0 + 1] = var_3_1.resource
	end

	arg_3_0._career_video_ui_renderer = UIRenderer.create(arg_3_0._world, unpack(var_3_0))

	UISetupFontHeights(arg_3_0._ui_renderer.gui)
end

function DemoTitleUI._setup_world_gui(arg_4_0)
	arg_4_0._world_gui = World.create_world_gui(arg_4_0._world, Matrix4x4.identity(), var_0_12, var_0_12, "material", "materials/ui/ui_1080p_demo_textures", "immediate")

	local var_4_0 = arg_4_0._camera_poses[DemoSettings.starting_camera_name] or Matrix4x4Box(Matrix4x4.identity())
	local var_4_1 = Matrix4x4.translation(var_4_0:unbox())
	local var_4_2 = Matrix4x4.rotation(var_4_0:unbox())
	local var_4_3 = Quaternion.forward(var_4_2)
	local var_4_4 = Matrix4x4.from_quaternion_position(var_4_2, var_4_1 + var_4_3 * 1.5)

	Gui.move(arg_4_0._world_gui, var_4_4)
end

function DemoTitleUI._setup_level(arg_5_0)
	local var_5_0 = DemoSettings.level_name
	local var_5_1 = {}
	local var_5_2 = LevelResource.object_set_names(var_5_0)

	for iter_5_0, iter_5_1 in ipairs(var_5_2) do
		if iter_5_1 == "shadow_lights" then
			var_5_1[#var_5_1 + 1] = iter_5_1
		elseif string.sub(iter_5_1, 1, 5) == "flow_" then
			var_5_1[#var_5_1 + 1] = iter_5_1
		elseif string.sub(iter_5_1, 1, 5) == "team_" then
			var_5_1[#var_5_1 + 1] = iter_5_1
		end
	end

	local var_5_3
	local var_5_4
	local var_5_5
	local var_5_6 = false

	arg_5_0._level = ScriptWorld.spawn_level(arg_5_0._world, DemoSettings.level_name, var_5_1, var_5_3, var_5_4, callback(arg_5_0, "shading_callback"), var_5_5, var_5_6)

	Level.spawn_background(arg_5_0._level)
end

function DemoTitleUI.shading_callback(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	for iter_6_0, iter_6_1 in pairs(OutlineSettings.colors) do
		local var_6_0 = iter_6_1.color
		local var_6_1 = Vector3(var_6_0[2] / 255, var_6_0[3] / 255, var_6_0[4] / 255)
		local var_6_2 = iter_6_1.outline_multiplier

		if iter_6_1.pulsate then
			var_6_2 = iter_6_1.outline_multiplier * 0.5 + math.sin(Managers.time:time("ui") * iter_6_1.pulse_multiplier) * iter_6_1.outline_multiplier * 0.5
		end

		ShadingEnvironment.set_vector3(arg_6_2, iter_6_1.variable, var_6_1)
		ShadingEnvironment.set_scalar(arg_6_2, iter_6_1.outline_multiplier_variable, var_6_2)
	end
end

function DemoTitleUI._collect_cameras(arg_7_0)
	arg_7_0._camera_poses = {}

	local var_7_0 = LevelResource.unit_indices(DemoSettings.level_name, "units/hub_elements/cutscene_camera/cutscene_camera")

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		local var_7_1 = LevelResource.unit_data(DemoSettings.level_name, iter_7_1)
		local var_7_2 = DynamicData.get(var_7_1, "name")

		if var_7_2 and var_7_2 ~= "" then
			assert(not arg_7_0._camera_poses[var_7_2], string.format("[StateTitleScreen] There are two cameras with the same name: %s", var_7_2))

			local var_7_3 = LevelResource.unit_position(DemoSettings.level_name, iter_7_1)
			local var_7_4 = LevelResource.unit_rotation(DemoSettings.level_name, iter_7_1)
			local var_7_5 = Matrix4x4.from_quaternion_position(var_7_4, var_7_3)

			arg_7_0._camera_poses[var_7_2] = Matrix4x4Box(var_7_5)

			print("Found camera: " .. var_7_2)
		end
	end
end

function DemoTitleUI._position_camera(arg_8_0)
	local var_8_0 = ScriptViewport.camera(arg_8_0._viewport)
	local var_8_1 = DemoSettings.starting_camera_name
	local var_8_2 = var_8_1 and arg_8_0._camera_poses[var_8_1]

	if var_8_2 then
		ScriptCamera.set_local_pose(var_8_0, var_8_2:unbox())
		ScriptCamera.force_update(arg_8_0._world, var_8_0)
	end

	arg_8_0._scatter_system = World.scatter_system(arg_8_0._world)
	arg_8_0._scatter_system_observer = ScatterSystem.make_observer(arg_8_0._scatter_system, Matrix4x4.translation(var_8_2:unbox()), Matrix4x4.rotation(var_8_2:unbox()))
end

function DemoTitleUI._create_ui_elements(arg_9_0)
	arg_9_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_9_0._attract_video = UIWidget.init(UIWidgets.create_splash_video(var_0_4, var_0_14))
	arg_9_0._widgets = {}

	for iter_9_0, iter_9_1 in pairs(var_0_2) do
		arg_9_0._widgets[iter_9_0] = UIWidget.init(iter_9_1)
	end

	arg_9_0._career_widgets = {}

	for iter_9_2, iter_9_3 in pairs(var_0_3) do
		arg_9_0._career_widgets[iter_9_2] = UIWidget.init(iter_9_3)
	end

	arg_9_0._dead_space_filler_widget = UIWidget.init(var_0_5)
	arg_9_0._start_game_button_widget = UIWidget.init(var_0_7)
	arg_9_0._back_button_widget = UIWidget.init(var_0_8)

	local var_9_0 = DemoSettings.characters[1]

	arg_9_0:_populate_career_page(var_9_0.profile_name, var_9_0.career_index)

	arg_9_0._console_cursor = UIWidget.init(var_0_0.console_cursor_definition)
	arg_9_0._press_start_widget = UIWidget.init(var_0_10)

	UIRenderer.clear_scenegraph_queue(arg_9_0._ui_renderer)

	local var_9_1 = {
		vertical_alignment = "center",
		word_wrap = true,
		horizontal_alignment = "center",
		font_size = 18,
		font_type = "hell_shark",
		text_color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			2
		}
	}

	arg_9_0._information_text = UIWidget.init(UIWidgets.create_simple_text("n/a", "information_text", nil, nil, var_9_1))
	arg_9_0._user_gamertag_widget = UIWidget.init(UIWidgets.create_simple_rect_text("user_gamertag", "Gamertag not assigned"))
	arg_9_0._change_profile_input_icon_widget = UIWidget.init(UIWidgets.create_simple_texture("xbone_button_icon_x", "change_profile_input_icon"))
	arg_9_0._change_profile_input_text_widget = UIWidget.init(UIWidgets.create_simple_rect_text("change_profile_input_text", Localize("xb1_switch_profile"), 20))
	arg_9_0._ui_animations = {}
	arg_9_0._ui_animation_cb = {}
	arg_9_0._ui_animations.reset = UIAnimation.init(UIAnimation.function_by_time, arg_9_0._ui_scenegraph.right_side_root.local_position, 1, arg_9_0._ui_scenegraph.right_side_root.local_position[1], 450, 0, math.easeOutCubic)
end

function DemoTitleUI._populate_career_page(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = FindProfileIndex(arg_10_1)
	local var_10_1 = SPProfiles[var_10_0]
	local var_10_2 = var_10_1.careers[arg_10_2]
	local var_10_3 = var_10_2.name
	local var_10_4 = var_10_2.display_name
	local var_10_5 = var_10_2.description
	local var_10_6 = var_10_2.icon
	local var_10_7 = CareerUtils.get_passive_ability_by_career(var_10_2)
	local var_10_8 = CareerUtils.get_ability_data_by_career(var_10_2, 1)
	local var_10_9 = var_10_7.display_name
	local var_10_10 = var_10_7.icon
	local var_10_11 = var_10_8.display_name
	local var_10_12 = var_10_8.icon

	arg_10_0._widgets.info_passive_icon.content.texture_id = var_10_10
	arg_10_0._widgets.info_ability_icon.content.texture_id = var_10_12
	arg_10_0._widgets.info_passive_title.content.text = Localize(var_10_9)
	arg_10_0._widgets.info_passive_description.content.text = UIUtils.get_ability_description(var_10_7)
	arg_10_0._widgets.info_ability_title.content.text = Localize(var_10_11)
	arg_10_0._widgets.info_ability_description.content.text = UIUtils.get_ability_description(var_10_8)

	local var_10_13 = var_10_2.video
	local var_10_14 = var_10_13.material_name
	local var_10_15 = var_10_13.resource

	arg_10_0:_setup_video_player(var_10_14, var_10_15)

	arg_10_0._displayed_profile = arg_10_1

	local var_10_16 = var_10_2.portrait_image
	local var_10_17 = "default"
	local var_10_18 = UIWidgets.create_portrait_frame("player_portrait", var_10_17, "-", 1, nil, var_10_16)
	local var_10_19 = UIWidget.init(var_10_18, arg_10_0._ui_renderer)

	arg_10_0._career_widgets.player_portrait = var_10_19

	local var_10_20 = var_10_2.display_name

	arg_10_0:_set_career_widget_text("player_career_name", var_10_20)

	local var_10_21 = var_10_1.ingame_display_name

	arg_10_0:_set_career_widget_text("player_hero_name", var_10_21)
end

function DemoTitleUI._set_career_widget_text(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._career_widgets[arg_11_1].content.text = arg_11_2
end

function DemoTitleUI._destroy_career_video_player(arg_12_0)
	local var_12_0 = arg_12_0._career_video_ui_renderer
	local var_12_1 = arg_12_0._video_widget

	if var_12_0 and var_12_1 then
		UIRenderer.destroy_video_player(var_12_0, var_0_14, arg_12_0._world)
	end

	arg_12_0._video_created = nil
end

function DemoTitleUI._setup_video_player(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0:_destroy_career_video_player()
	UIRenderer.create_video_player(arg_13_0._career_video_ui_renderer, var_0_14, arg_13_0._world, arg_13_2, true)

	local var_13_0 = var_0_6("info_window_video", arg_13_1)

	arg_13_0._video_widget = UIWidget.init(var_13_0)
	arg_13_0._video_created = true
	arg_13_0._video_widget.content.video_player_reference = var_0_14
end

function DemoTitleUI._setup_input(arg_14_0)
	arg_14_0._input_manager = Managers.input

	arg_14_0._input_manager:create_input_service("main_menu", "TitleScreenKeyMaps", "TitleScreenFilters")
	arg_14_0._input_manager:map_device_to_service("main_menu", "gamepad")
	arg_14_0._input_manager:map_device_to_service("main_menu", "keyboard")
	arg_14_0._input_manager:map_device_to_service("main_menu", "mouse")
end

function DemoTitleUI._setup_characters(arg_15_0)
	arg_15_0._character_previewers = {}

	local var_15_0 = World.physics_world(arg_15_0._world)
	local var_15_1 = arg_15_0._camera_poses[DemoSettings.camera_end_position]:unbox()
	local var_15_2 = Matrix4x4.translation(var_15_1)
	local var_15_3 = Matrix4x4.rotation(var_15_1)
	local var_15_4 = Quaternion.forward(var_15_3)
	local var_15_5 = Vector3.flat(var_15_4)
	local var_15_6 = Quaternion.look(-var_15_5, Vector3.up())
	local var_15_7 = Quaternion.right(var_15_3)
	local var_15_8 = Vector3.flat(var_15_7)
	local var_15_9 = DemoSettings.characters

	for iter_15_0, iter_15_1 in pairs(var_15_9) do
		local var_15_10 = iter_15_1.position_offset:unbox()
		local var_15_11 = var_15_2 + var_15_8 * var_15_10[1] + var_15_5 * var_15_10[2] + Vector3.up() * var_15_10[3]
		local var_15_12, var_15_13, var_15_14, var_15_15 = PhysicsWorld.immediate_raycast(var_15_0, var_15_11, Vector3(0, 0, -1), 5, "closest", "collision_filter", "filter_ai_mover")

		if var_15_12 then
			var_15_11[3] = var_15_13[3]

			local var_15_16 = Vector3Box(var_15_11)
			local var_15_17 = QuaternionBox(Quaternion.multiply(var_15_6, iter_15_1.rotation:unbox()))
			local var_15_18 = iter_15_1.zoom_offset
			local var_15_19 = iter_15_1.profile_name
			local var_15_20 = iter_15_1.career_index

			arg_15_0._character_previewers[var_15_19] = DemoCharacterPreviewer:new(arg_15_0._world, var_15_19, var_15_20, var_15_16, var_15_17, var_15_18)
		end
	end
end

function DemoTitleUI._play_sound(arg_16_0, arg_16_1)
	return Managers.music:trigger_event(arg_16_1)
end

function DemoTitleUI.get_ui_renderer(arg_17_0)
	return arg_17_0._ui_renderer
end

function DemoTitleUI.in_transition(arg_18_0)
	return arg_18_0._camera_transition
end

function DemoTitleUI._recreate_characters(arg_19_0)
	for iter_19_0, iter_19_1 in pairs(arg_19_0._character_previewers) do
		iter_19_1:destroy()
	end

	arg_19_0._character_previewers = {}

	arg_19_0:_setup_characters()
end

local var_0_15 = false

function DemoTitleUI.update(arg_20_0, arg_20_1, arg_20_2)
	if var_0_15 then
		arg_20_0:_create_ui_elements()
		arg_20_0:_recreate_characters()

		arg_20_0._attract_mode_active = false
		var_0_15 = false
	end

	if table.is_empty(arg_20_0._character_previewers) then
		arg_20_0:_setup_characters()
	end

	arg_20_0:_update_scatter(arg_20_1, arg_20_2)
	arg_20_0:_update_input(arg_20_1, arg_20_2)
	arg_20_0:_update_camera(arg_20_1, arg_20_2)
	arg_20_0:_update_career_information(arg_20_1, arg_20_2)
	arg_20_0:_update_animation(arg_20_1, arg_20_2)
	arg_20_0:_update_start_game(arg_20_1, arg_20_2)
	arg_20_0:_update_back(arg_20_1, arg_20_2)
	arg_20_0:_draw_3d_logo(arg_20_1, arg_20_2)
	arg_20_0:_draw(arg_20_1, arg_20_2)
	arg_20_0:_draw_fps(arg_20_1, arg_20_2)
	arg_20_0:_update_character_previewers(arg_20_1, arg_20_2)
end

function DemoTitleUI._update_scatter(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0._scatter_system then
		local var_21_0 = ScriptWorld.viewport(arg_21_0._world, "title_screen_viewport")
		local var_21_1 = ScriptViewport.camera(var_21_0)
		local var_21_2 = ScriptCamera.pose(var_21_1)

		ScatterSystem.move_observer(arg_21_0._scatter_system, arg_21_0._scatter_system_observer, Matrix4x4.translation(var_21_2), Matrix4x4.rotation(var_21_2))
	end
end

function DemoTitleUI._update_input(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_0._selected_profile and (Managers.input:get_service("main_menu"):get("back", true) or arg_22_0._back_pressed) and not arg_22_0:in_transition() then
		arg_22_0._character_previewers[arg_22_0._selected_profile]:reset_state()
		arg_22_0:animate_to_camera(DemoSettings.camera_end_position, nil, nil, 0.5)

		arg_22_0._input_disabled = false
		arg_22_0._back_pressed = false
	end
end

function DemoTitleUI._update_character_previewers(arg_23_0, arg_23_1, arg_23_2)
	for iter_23_0, iter_23_1 in pairs(arg_23_0._character_previewers) do
		iter_23_1:update(arg_23_0._ui_activated and not arg_23_0._selected_profile and not arg_23_0._camera_transition, arg_23_1, arg_23_2)
	end

	if not arg_23_0._ui_activated then
		return
	end

	if arg_23_0._start_game_button_widget.content.button_hotspot.is_hover or arg_23_0._input_disabled then
		return
	end

	if arg_23_0._back_button_widget.content.button_hotspot.is_hover or arg_23_0._input_disabled then
		return
	end
end

function DemoTitleUI._update_start_game(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_0._camera_transition and arg_24_0._selected_profile then
		return
	end

	if arg_24_0._start_game_button_widget.content.button_hotspot.on_release then
		arg_24_0._start_pressed = true
		arg_24_0._input_disabled = true
	end
end

function DemoTitleUI._update_back(arg_25_0, arg_25_1, arg_25_2)
	if arg_25_0._camera_transition and arg_25_0._selected_profile then
		return
	end

	if arg_25_0._back_button_widget.content.button_hotspot.on_release then
		arg_25_0._back_pressed = true
		arg_25_0._input_disabled = true
	end
end

function DemoTitleUI._update_career_information(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_0._input_disabled then
		return
	end

	local var_26_0 = false

	arg_26_0._selected_profile = nil

	for iter_26_0, iter_26_1 in pairs(arg_26_0._character_previewers) do
		if iter_26_1:is_pressed() then
			if not arg_26_0._ui_animations.animate_in then
				arg_26_0._ui_animations = {}

				local var_26_1 = UIAnimation.init(UIAnimation.function_by_time, arg_26_0._ui_scenegraph.right_side_root.local_position, 1, arg_26_0._ui_scenegraph.right_side_root.local_position[1], 0, 0.4, math.easeInCubic)

				arg_26_0._ui_animations.animate_in = var_26_1

				local var_26_2 = UIAnimation.init(UIAnimation.function_by_time, arg_26_0._ui_scenegraph.portrait_base.local_position, 1, arg_26_0._ui_scenegraph.portrait_base.local_position[1], 0, 0.4, math.easeInCubic)

				arg_26_0._ui_animations.animate_in_portrait = var_26_2

				local var_26_3 = UIAnimation.init(UIAnimation.function_by_time, arg_26_0._ui_scenegraph.button_root.local_position, 2, arg_26_0._ui_scenegraph.button_root.local_position[2], 0, 0.4, math.easeInCubic)

				arg_26_0._ui_animations.animate_in_buttons = var_26_3
			end

			if arg_26_0._displayed_profile ~= iter_26_0 then
				local var_26_4, var_26_5 = iter_26_1:profile_information()

				arg_26_0:_populate_career_page(var_26_4, var_26_5)
			end

			var_26_0 = true
		end

		if iter_26_1:is_pressed() then
			if iter_26_1:was_pressed_this_frame() then
				local var_26_6 = iter_26_1:pressed_pose()

				arg_26_0:animate_to_camera(nil, var_26_6, callback(iter_26_1, "cb_on_select_animation_complete"), 0.5)
				iter_26_1:outline_unit(false)
			end

			arg_26_0._selected_profile = iter_26_0
		end
	end

	if not var_26_0 and arg_26_0._selected_profile and arg_26_0._displayed_profile ~= arg_26_0._selected_profile then
		local var_26_7, var_26_8 = arg_26_0._character_previewers[arg_26_0._selected_profile]:profile_information()

		arg_26_0:_populate_career_page(var_26_7, var_26_8)
	end

	arg_26_0._ui_animation_cb = arg_26_0._ui_animation_cb or {}
	arg_26_0._ui_animations = arg_26_0._ui_animations or {}

	if not arg_26_0._ui_animations.animate_out and not arg_26_0._ui_animations.delay and not var_26_0 and not arg_26_0._selected_profile then
		local function var_26_9(arg_27_0)
			local var_27_0 = UIAnimation.init(UIAnimation.function_by_time, arg_27_0._ui_scenegraph.right_side_root.local_position, 1, arg_27_0._ui_scenegraph.right_side_root.local_position[1], 450, 0.3, math.easeOutCubic)

			arg_27_0._ui_animations = {}
			arg_27_0._ui_animations.animate_out = var_27_0

			local var_27_1 = UIAnimation.init(UIAnimation.function_by_time, arg_27_0._ui_scenegraph.portrait_base.local_position, 1, arg_27_0._ui_scenegraph.portrait_base.local_position[1], -450, 0.3, math.easeOutCubic)

			arg_27_0._ui_animations.animate_out_portrait = var_27_1

			local var_27_2 = UIAnimation.init(UIAnimation.function_by_time, arg_27_0._ui_scenegraph.button_root.local_position, 2, arg_27_0._ui_scenegraph.button_root.local_position[2], -200, 0.3, math.easeInCubic)

			arg_27_0._ui_animations.animate_out_buttons = var_27_2
		end

		arg_26_0._ui_animations.delay = UIAnimation.init(UIAnimation.function_by_time, {
			0,
			0,
			0
		}, 1, 0, 0, 0, math.easeInCubic)
		arg_26_0._ui_animation_cb.delay = var_26_9
	end
end

function DemoTitleUI._update_animation(arg_28_0, arg_28_1, arg_28_2)
	for iter_28_0, iter_28_1 in pairs(arg_28_0._ui_animations) do
		UIAnimation.update(iter_28_1, arg_28_1)

		if UIAnimation.completed(iter_28_1) then
			if arg_28_0._ui_animation_cb[iter_28_0] then
				arg_28_0._ui_animation_cb[iter_28_0](arg_28_0)

				arg_28_0._ui_animation_cb[iter_28_0] = nil
			end

			arg_28_0._ui_animations[iter_28_0] = nil
		end
	end
end

function DemoTitleUI._update_camera(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_0._camera_transition then
		arg_29_0._timer = arg_29_0._timer or 0

		local var_29_0 = arg_29_0._camera_poses.current_pose
		local var_29_1 = arg_29_0._target_camera_pose

		if arg_29_0._target_camera_name then
			var_29_1 = arg_29_0._camera_poses[arg_29_0._target_camera_name]
		end

		if not var_29_0 or not var_29_1 then
			arg_29_0._camera_transition = false
			arg_29_0._timer = nil

			return
		end

		local var_29_2 = arg_29_0._ref_time or var_0_13

		arg_29_0._timer = math.clamp(arg_29_0._timer + arg_29_1, 0, var_29_2)

		local var_29_3 = math.smoothstep(arg_29_0._timer / var_29_2, 0, 1)
		local var_29_4 = Matrix4x4.lerp(var_29_0:unbox(), var_29_1:unbox(), var_29_3)
		local var_29_5 = ScriptViewport.camera(arg_29_0._viewport)

		ScriptCamera.set_local_pose(var_29_5, var_29_4)
		ScriptCamera.force_update(arg_29_0._world, var_29_5)

		if arg_29_0._timer == var_29_2 then
			arg_29_0._camera_transition = false
			arg_29_0._timer = 0

			if arg_29_0._camera_animation_cb then
				arg_29_0._camera_animation_cb()

				arg_29_0._camera_animation_cb = nil
			end
		end
	end

	local var_29_6, var_29_7 = Gui.resolution()
	local var_29_8 = arg_29_0._camera_poses[DemoSettings.starting_camera_name] or Matrix4x4Box(Matrix4x4.identity())
	local var_29_9 = Matrix4x4.translation(var_29_8:unbox())
	local var_29_10 = Matrix4x4.rotation(var_29_8:unbox())
	local var_29_11 = Quaternion.forward(var_29_10)
	local var_29_12 = var_29_6 / 1920 * 0.5
	local var_29_13 = Matrix4x4.from_quaternion_position(var_29_10, var_29_9 + var_29_11 * var_29_12)

	Gui.move(arg_29_0._world_gui, var_29_13)
end

function DemoTitleUI._draw_3d_logo(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = Vector2(1920, 1080)
	local var_30_1, var_30_2 = Gui.resolution()

	Gui.bitmap(arg_30_0._world_gui, "vermintide_2_logo_demo", Vector3(-var_30_0[1] * var_30_1 / var_0_12 * 0.5, -var_30_0[2] * var_30_1 / var_0_12 * 0.3, 1), Vector2(var_30_0[1] * var_30_1 / var_0_12, var_30_0[2] * var_30_1 / var_0_12))
end

function DemoTitleUI._draw(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0._ui_renderer
	local var_31_1 = arg_31_0._career_video_ui_renderer
	local var_31_2 = arg_31_0._ui_scenegraph
	local var_31_3 = arg_31_0._input_manager:get_service("main_menu")
	local var_31_4 = arg_31_0._input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(var_31_0, var_31_2, var_31_3, arg_31_1, nil, arg_31_0._render_settings)

	if arg_31_0._destroy_video_player then
		UIRenderer.destroy_video_player(var_31_0, var_0_14)

		arg_31_0._destroy_video_player = nil
	elseif arg_31_0._attract_mode_enabled then
		if not arg_31_0._attract_video.content.video_completed then
			if not var_31_0.video_players[var_0_14] then
				UIRenderer.create_video_player(var_31_0, var_0_14, arg_31_0._world, var_0_4.video_name, var_0_4.loop)
			else
				if not arg_31_0._sound_started then
					if var_0_4.sound_start then
						Managers.music:trigger_event(var_0_4.sound_start)
					end

					arg_31_0._sound_started = true
				end

				UIRenderer.draw_widget(var_31_0, arg_31_0._attract_video)
				UIRenderer.draw_widget(var_31_0, arg_31_0._dead_space_filler_widget)
			end
		elseif var_31_0.video_players[var_0_14] then
			UIRenderer.destroy_video_player(var_31_0, var_0_14)

			arg_31_0._sound_started = false

			if var_0_4.sound_stop then
				Managers.music:trigger_event(var_0_4.sound_stop)
			end
		end
	else
		if arg_31_0._draw_information_text then
			UIRenderer.draw_widget(var_31_0, arg_31_0._information_text)
		end

		if arg_31_0._draw_gamertag then
			UIRenderer.draw_widget(var_31_0, arg_31_0._user_gamertag_widget)

			if not arg_31_0._switch_profile_blocked then
				UIRenderer.draw_widget(var_31_0, arg_31_0._change_profile_input_icon_widget)
				UIRenderer.draw_widget(var_31_0, arg_31_0._change_profile_input_text_widget)
			end
		end
	end

	if arg_31_0._ui_activated then
		if var_31_4 then
			UIRenderer.draw_widget(var_31_0, arg_31_0._console_cursor)
		end

		for iter_31_0, iter_31_1 in pairs(arg_31_0._widgets) do
			UIRenderer.draw_widget(var_31_0, iter_31_1)
		end

		for iter_31_2, iter_31_3 in pairs(arg_31_0._career_widgets) do
			UIRenderer.draw_widget(var_31_0, iter_31_3)
		end

		UIWidgetUtils.animate_default_button(arg_31_0._start_game_button_widget, arg_31_1)
		UIWidgetUtils.animate_default_button(arg_31_0._back_button_widget, arg_31_1)
		UIRenderer.draw_widget(var_31_0, arg_31_0._start_game_button_widget)
		UIRenderer.draw_widget(var_31_0, arg_31_0._back_button_widget)
	elseif not arg_31_0._entering and not arg_31_0:in_transition() then
		UIRenderer.draw_widget(var_31_0, arg_31_0._press_start_widget)
	end

	UIRenderer.end_pass(var_31_0)

	if arg_31_0._video_widget and arg_31_0._ui_activated then
		UIRenderer.begin_pass(var_31_1, var_31_2, var_31_3, arg_31_1, nil, arg_31_0._render_settings)

		if not arg_31_0._video_created then
			UIRenderer.draw_widget(var_31_1, arg_31_0._video_widget)
		end

		arg_31_0._video_created = nil

		UIRenderer.end_pass(var_31_1)
	end
end

local var_0_16 = "arial"
local var_0_17 = "materials/fonts/" .. var_0_16
local var_0_18 = 32
local var_0_19 = {}
local var_0_20 = Colors.color_definitions.white
local var_0_21 = Colors.color_definitions.black
local var_0_22 = Colors.color_definitions.red
local var_0_23 = 0
local var_0_24 = 0

function DemoTitleUI._draw_fps(arg_32_0, arg_32_1, arg_32_2)
	if BUILD == "release" then
		return
	end

	arg_32_0._old_fps = arg_32_0._old_fps or 0
	arg_32_0._fps = arg_32_0._fps or 0
	arg_32_0._fps_cooldown = arg_32_0._fps_cooldown or 0

	local var_32_0 = arg_32_0._ui_renderer
	local var_32_1 = arg_32_0._old_fps

	arg_32_0._fps_cooldown = arg_32_0._fps_cooldown + arg_32_1
	var_0_23 = var_0_23 + 1 / arg_32_1
	var_0_24 = var_0_24 + 1

	if arg_32_0._fps_cooldown > 1 then
		arg_32_0._old_fps = arg_32_0._fps
		arg_32_0._fps = var_0_23 / var_0_24
		var_0_23 = 0
		var_0_24 = 0
		arg_32_0._fps_cooldown = 0
	end

	arg_32_0._old_fps = math.lerp(arg_32_0._old_fps, arg_32_0._fps, arg_32_1 * 0.2)

	local var_32_2 = string.format("%.2f FPS", var_32_1)
	local var_32_3
	local var_32_4 = 30
	local var_32_5 = PLATFORM

	if IS_CONSOLE then
		var_32_4 = 28
	end

	if var_32_1 < var_32_4 then
		var_32_3 = var_0_22
	else
		var_32_3 = var_0_20
	end

	local var_32_6 = RESOLUTION_LOOKUP.inv_scale
	local var_32_7 = RESOLUTION_LOOKUP.res_w
	local var_32_8 = RESOLUTION_LOOKUP.res_h
	local var_32_9 = var_32_7 * var_32_6
	local var_32_10 = var_32_8 * var_32_6
	local var_32_11 = var_0_18
	local var_32_12, var_32_13 = UIRenderer.text_size(var_32_0, var_32_2, var_0_17, var_32_11)
	local var_32_14 = var_32_9 - var_32_12 - (var_0_18 - 16)
	local var_32_15 = var_32_13 + 16

	var_0_19[1] = var_32_14
	var_0_19[2] = var_32_15
	var_0_19[3] = 899

	UIRenderer.draw_text(var_32_0, var_32_2, var_0_17, var_32_11, var_0_16, Vector3(unpack(var_0_19)), var_32_3)

	var_0_19[1] = var_32_14 + 2
	var_0_19[2] = var_32_15 - 2
	var_0_19[3] = 898

	UIRenderer.draw_text(var_32_0, var_32_2, var_0_17, var_32_11, var_0_16, Vector3(unpack(var_0_19)), var_0_21)
end

function DemoTitleUI.activate_career_ui(arg_33_0, arg_33_1)
	arg_33_0._ui_activated = arg_33_1
	arg_33_0._selected_profile = nil
	arg_33_0._ui_animations.reset = UIAnimation.init(UIAnimation.function_by_time, arg_33_0._ui_scenegraph.right_side_root.position, 1, arg_33_0._ui_scenegraph.right_side_root.position[1], 450, 0, math.easeOutCubic)

	if not arg_33_1 then
		for iter_33_0, iter_33_1 in pairs(arg_33_0._character_previewers) do
			iter_33_1:reset_state()
		end
	end
end

function DemoTitleUI.animate_to_camera(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0 = ScriptViewport.camera(arg_34_0._viewport)
	local var_34_1 = ScriptCamera.pose(var_34_0)

	arg_34_0._camera_poses.current_pose = Matrix4x4Box(var_34_1)
	arg_34_0._target_camera_name = arg_34_1
	arg_34_0._target_camera_pose = arg_34_2
	arg_34_0._camera_transition = true
	arg_34_0._camera_animation_cb = arg_34_3
	arg_34_0._ref_time = arg_34_4
end

function DemoTitleUI.enter_attract_mode(arg_35_0)
	arg_35_0._attract_mode_enabled = true
	arg_35_0._sound_started = false
	arg_35_0._attract_video.content.video_content.video_completed = false
end

function DemoTitleUI.exit_attract_mode(arg_36_0)
	arg_36_0._attract_mode_enabled = false
	arg_36_0._destroy_video_player = true
end

function DemoTitleUI.video_completed(arg_37_0)
	return arg_37_0._attract_video.content.video_content.video_completed
end

function DemoTitleUI.attract_mode(arg_38_0)
	return arg_38_0._attract_mode_enabled
end

function DemoTitleUI.is_ready(arg_39_0)
	for iter_39_0, iter_39_1 in pairs(arg_39_0._character_previewers) do
		if not iter_39_1:character_spawned() then
			return false
		end
	end

	return true
end

function DemoTitleUI.should_start(arg_40_0)
	return arg_40_0._start_pressed
end

function DemoTitleUI.selected_profile(arg_41_0)
	return arg_41_0._selected_profile
end

function DemoTitleUI.set_start_pressed(arg_42_0, arg_42_1)
	arg_42_0._entering = arg_42_1
end

function DemoTitleUI.clear_playgo_status(arg_43_0)
	return
end

function DemoTitleUI.set_playgo_status(arg_44_0)
	return
end

function DemoTitleUI.show_menu(arg_45_0)
	return
end

function DemoTitleUI.clear_user_name(arg_46_0)
	return
end

function DemoTitleUI.current_menu_index(arg_47_0)
	return
end

function DemoTitleUI.active_menu_selection(arg_48_0)
	return
end

function DemoTitleUI.set_menu_item_enable_state_by_index(arg_49_0)
	return
end

function DemoTitleUI.destroy(arg_50_0)
	for iter_50_0, iter_50_1 in pairs(arg_50_0._character_previewers) do
		iter_50_1:destroy()
	end

	arg_50_0._character_previewers = {}

	print("destroying demo_ui")
	ScriptWorld.destroy_level_from_reference(arg_50_0._world, arg_50_0._level)
	UIRenderer.destroy(arg_50_0._ui_renderer, arg_50_0._world)
	UIRenderer.destroy(arg_50_0._career_video_ui_renderer, arg_50_0._world)
	World.destroy_gui(arg_50_0._world, arg_50_0._world_gui)
end

function DemoTitleUI.set_information_text(arg_51_0, arg_51_1)
	return
end

function DemoTitleUI.set_user_name(arg_52_0, arg_52_1)
	arg_52_0._draw_gamertag = true
	arg_52_0._user_gamertag_widget.content.text = arg_52_1

	if IS_PS4 then
		arg_52_0._switch_profile_blocked = true
	end
end

function DemoTitleUI.clear_user_name(arg_53_0)
	arg_53_0._draw_gamertag = nil
	arg_53_0._switch_profile_blocked = nil
end

function DemoTitleUI.set_update_offline_data_enabled(arg_54_0, arg_54_1)
	return
end

function DemoTitleUI.disable_input(arg_55_0, arg_55_1)
	return
end

function DemoTitleUI.set_game_type(arg_56_0, arg_56_1)
	return
end
