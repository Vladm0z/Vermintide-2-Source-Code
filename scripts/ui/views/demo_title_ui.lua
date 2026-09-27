-- chunkname: @scripts/ui/views/demo_title_ui.lua

require("scripts/ui/views/demo_character_previewer")

local var_0_0 = local_require("scripts/ui/views/demo_title_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widget_definitions = var_0_0.widget_definitions
local career_widget_definitions = var_0_0.career_widget_definitions
local attract_mode_video = var_0_0.attract_mode_video
local dead_space_filler_widget = var_0_0.dead_space_filler_widget
local create_video_func = var_0_0.create_video_func
local start_game_button_widget = var_0_0.start_game_button_widget
local back_button_widget = var_0_0.back_button_widget
local console_cursor_definition = var_0_0.console_cursor_definition
local press_start_widget = var_0_0.press_start_widget
local single_widget_definitions = var_0_0.single_widget_definitions

DemoTitleUI = class(DemoTitleUI)

local num = 1920
local num_2 = 2
local str = "DemoTitleUI"

DemoTitleUI.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1
	self._viewport = arg_1_2
	self._parent = arg_1_3
	self._attract_mode_active = false
	self._character_previewers = {}
	self._fps = 0
	self._fps_cooldown = 0
	self._draw_information_text = false

	self:_setup_gui()
	self:_setup_level()
	self:_collect_cameras()
	self:_position_camera()
	self:_setup_world_gui(arg_1_3)
	self:_create_ui_elements()
	self:_setup_input()
end

DemoTitleUI.menu_input_enabled = function (arg_2_0)
	-- function 2
	return true
end

DemoTitleUI._setup_gui = function (self)
	-- function 3
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._ui_renderer = UIRenderer.create(self._world, "material", "materials/ui/ui_1080p_hud_single_textures", "material", "materials/ui/ui_1080p_title_screen", "material", "materials/ui/ui_1080p_start_screen", "material", "materials/fonts/gw_fonts", "material", "materials/ui/ui_1080p_common", "material", "materials/ui/ui_1080p_versus_available_common", "material", "materials/ui/ui_1080p_hud_atlas_textures", "material", "materials/ui/ui_1080p_chat", "material", attract_mode_video.video_name)

	local tbl = {}

	for k, v in pairs(CareerSettings) do
		local video = v.video

		tbl[#tbl + 1] = "material"
		tbl[#tbl + 1] = video.resource
	end

	self._career_video_ui_renderer = UIRenderer.create(self._world, unpack(tbl))

	UISetupFontHeights(self._ui_renderer.gui)
end

DemoTitleUI._setup_world_gui = function (self)
	-- function 4
	self._world_gui = World.create_world_gui(self._world, Matrix4x4.identity(), num, num, "material", "materials/ui/ui_1080p_demo_textures", "immediate")

	local var_4_0 = self._camera_poses[DemoSettings.starting_camera_name]

	var_4_0 = var_4_0 or Matrix4x4Box(Matrix4x4.identity())

	local translation = Matrix4x4.translation(var_4_0:unbox())
	local rotation = Matrix4x4.rotation(var_4_0:unbox())
	local forward = Quaternion.forward(rotation)
	local from_quaternion_position = Matrix4x4.from_quaternion_position(rotation, translation + forward * 1.5)

	Gui.move(self._world_gui, from_quaternion_position)
end

DemoTitleUI._setup_level = function (self)
	-- function 5
	local level_name = DemoSettings.level_name
	local tbl = {}
	local object_set_names = LevelResource.object_set_names(level_name)

	for i, v in ipairs(object_set_names) do
		if v == "shadow_lights" then
			tbl[#tbl + 1] = v
		elseif string.sub(v, 1, 5) == "flow_" then
			tbl[#tbl + 1] = v
		elseif string.sub(v, 1, 5) == "team_" then
			tbl[#tbl + 1] = v
		end
	end

	local var_5_3
	local var_5_4
	local var_5_5
	local flag = false

	self._level = ScriptWorld.spawn_level(self._world, DemoSettings.level_name, tbl, var_5_3, var_5_4, callback(self, "shading_callback"), var_5_5, flag)

	Level.spawn_background(self._level)
end

DemoTitleUI.shading_callback = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	for k, v in pairs(OutlineSettings.colors) do
		local color = v.color
		local var_6_1 = Vector3(color[2] / 255, color[3] / 255, color[4] / 255)
		local outline_multiplier = v.outline_multiplier

		if not v.pulsate then
			outline_multiplier = v.outline_multiplier * 0.5 + math.sin(Managers.time:time("ui") * v.pulse_multiplier) * v.outline_multiplier * 0.5
		end

		ShadingEnvironment.set_vector3(arg_6_2, v.variable, var_6_1)
		ShadingEnvironment.set_scalar(arg_6_2, v.outline_multiplier_variable, outline_multiplier)
	end
end

DemoTitleUI._collect_cameras = function (self)
	-- function 7
	self._camera_poses = {}

	local unit_indices = LevelResource.unit_indices(DemoSettings.level_name, "units/hub_elements/cutscene_camera/cutscene_camera")

	for k, v in pairs(unit_indices) do
		local unit_data = LevelResource.unit_data(DemoSettings.level_name, v)
		local get = DynamicData.get(unit_data, "name")

		if not (not get and get == "") then
			assert(not self._camera_poses[get], string.format("[StateTitleScreen] There are two cameras with the same name: %s", get))

			local unit_position = LevelResource.unit_position(DemoSettings.level_name, v)
			local unit_rotation = LevelResource.unit_rotation(DemoSettings.level_name, v)
			local from_quaternion_position = Matrix4x4.from_quaternion_position(unit_rotation, unit_position)

			self._camera_poses[get] = Matrix4x4Box(from_quaternion_position)

			print("Found camera: " .. get)
		end
	end
end

DemoTitleUI._position_camera = function (self)
	-- function 8
	local camera = ScriptViewport.camera(self._viewport)
	local starting_camera_name = DemoSettings.starting_camera_name
	local flag = not starting_camera_name and self._camera_poses[starting_camera_name]

	if not flag then
		ScriptCamera.set_local_pose(camera, flag:unbox())
		ScriptCamera.force_update(self._world, camera)
	end

	self._scatter_system = World.scatter_system(self._world)
	self._scatter_system_observer = ScatterSystem.make_observer(self._scatter_system, Matrix4x4.translation(flag:unbox()), Matrix4x4.rotation(flag:unbox()))
end

DemoTitleUI._create_ui_elements = function (self)
	-- function 9
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._attract_video = UIWidget.init(UIWidgets.create_splash_video(attract_mode_video, str))
	self._widgets = {}

	for k, v in pairs(widget_definitions) do
		self._widgets[k] = UIWidget.init(v)
	end

	self._career_widgets = {}

	for k_2, v_2 in pairs(career_widget_definitions) do
		self._career_widgets[k_2] = UIWidget.init(v_2)
	end

	self._dead_space_filler_widget = UIWidget.init(dead_space_filler_widget)
	self._start_game_button_widget = UIWidget.init(start_game_button_widget)
	self._back_button_widget = UIWidget.init(back_button_widget)

	local var_9_0 = DemoSettings.characters[1]

	self:_populate_career_page(var_9_0.profile_name, var_9_0.career_index)

	self._console_cursor = UIWidget.init(var_0_0.console_cursor_definition)
	self._press_start_widget = UIWidget.init(press_start_widget)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	local tbl = {
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

	self._information_text = UIWidget.init(UIWidgets.create_simple_text("n/a", "information_text", nil, nil, tbl))
	self._user_gamertag_widget = UIWidget.init(UIWidgets.create_simple_rect_text("user_gamertag", "Gamertag not assigned"))
	self._change_profile_input_icon_widget = UIWidget.init(UIWidgets.create_simple_texture("xbone_button_icon_x", "change_profile_input_icon"))
	self._change_profile_input_text_widget = UIWidget.init(UIWidgets.create_simple_rect_text("change_profile_input_text", Localize("xb1_switch_profile"), 20))
	self._ui_animations = {}
	self._ui_animation_cb = {}
	self._ui_animations.reset = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.right_side_root.local_position, 1, self._ui_scenegraph.right_side_root.local_position[1], 450, 0, math.easeOutCubic)
end

DemoTitleUI._populate_career_page = function (self, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = FindProfileIndex(arg_10_1)
	local var_10_1 = SPProfiles[var_10_0]
	local var_10_2 = var_10_1.careers[arg_10_2]
	local name = var_10_2.name
	local display_name = var_10_2.display_name
	local description = var_10_2.description
	local icon = var_10_2.icon
	local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(var_10_2)
	local get_ability_data_by_career = CareerUtils.get_ability_data_by_career(var_10_2, 1)
	local display_name_2 = get_passive_ability_by_career.display_name
	local icon_2 = get_passive_ability_by_career.icon
	local display_name_3 = get_ability_data_by_career.display_name
	local icon_3 = get_ability_data_by_career.icon

	self._widgets.info_passive_icon.content.texture_id = icon_2
	self._widgets.info_ability_icon.content.texture_id = icon_3
	self._widgets.info_passive_title.content.text = Localize(display_name_2)
	self._widgets.info_passive_description.content.text = UIUtils.get_ability_description(get_passive_ability_by_career)
	self._widgets.info_ability_title.content.text = Localize(display_name_3)
	self._widgets.info_ability_description.content.text = UIUtils.get_ability_description(get_ability_data_by_career)

	local video = var_10_2.video
	local material_name = video.material_name
	local resource = video.resource

	self:_setup_video_player(material_name, resource)

	self._displayed_profile = arg_10_1

	local portrait_image = var_10_2.portrait_image
	local str = "default"
	local create_portrait_frame = UIWidgets.create_portrait_frame("player_portrait", str, "-", 1, nil, portrait_image)
	local var_10_19 = UIWidget.init(create_portrait_frame, self._ui_renderer)

	self._career_widgets.player_portrait = var_10_19

	local display_name_4 = var_10_2.display_name

	self:_set_career_widget_text("player_career_name", display_name_4)

	local ingame_display_name = var_10_1.ingame_display_name

	self:_set_career_widget_text("player_hero_name", ingame_display_name)
end

DemoTitleUI._set_career_widget_text = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	arg_11_0._career_widgets[arg_11_1].content.text = arg_11_2
end

DemoTitleUI._destroy_career_video_player = function (self)
	-- function 12
	local _career_video_ui_renderer = self._career_video_ui_renderer
	local _video_widget = self._video_widget

	if not _career_video_ui_renderer and not _video_widget then
		UIRenderer.destroy_video_player(_career_video_ui_renderer, str, self._world)
	end

	self._video_created = nil
end

DemoTitleUI._setup_video_player = function (self, arg_13_1, arg_13_2)
	-- function 13
	self:_destroy_career_video_player()
	UIRenderer.create_video_player(self._career_video_ui_renderer, str, self._world, arg_13_2, true)

	local var_13_0 = create_video_func("info_window_video", arg_13_1)

	self._video_widget = UIWidget.init(var_13_0)
	self._video_created = true
	self._video_widget.content.video_player_reference = str
end

DemoTitleUI._setup_input = function (self)
	-- function 14
	self._input_manager = Managers.input

	self._input_manager:create_input_service("main_menu", "TitleScreenKeyMaps", "TitleScreenFilters")
	self._input_manager:map_device_to_service("main_menu", "gamepad")
	self._input_manager:map_device_to_service("main_menu", "keyboard")
	self._input_manager:map_device_to_service("main_menu", "mouse")
end

DemoTitleUI._setup_characters = function (self)
	-- function 15
	self._character_previewers = {}

	local physics_world = World.physics_world(self._world)
	local unbox = self._camera_poses[DemoSettings.camera_end_position]:unbox()
	local translation = Matrix4x4.translation(unbox)
	local rotation = Matrix4x4.rotation(unbox)
	local forward = Quaternion.forward(rotation)
	local flat = Vector3.flat(forward)
	local look = Quaternion.look(-flat, Vector3.up())
	local right = Quaternion.right(rotation)
	local flat_2 = Vector3.flat(right)
	local characters = DemoSettings.characters

	for k, v in pairs(characters) do
		local unbox_2 = v.position_offset:unbox()
		local num = translation + flat_2 * unbox_2[1] + flat * unbox_2[2] + Vector3.up() * unbox_2[3]
		local immediate_raycast, var_15_13, var_15_14, var_15_15 = PhysicsWorld.immediate_raycast(physics_world, num, Vector3(0, 0, -1), 5, "closest", "collision_filter", "filter_ai_mover")

		if not immediate_raycast then
			num[3] = var_15_13[3]

			local var_15_16 = Vector3Box(num)
			local var_15_17 = QuaternionBox(Quaternion.multiply(look, v.rotation:unbox()))
			local zoom_offset = v.zoom_offset
			local profile_name = v.profile_name
			local career_index = v.career_index

			self._character_previewers[profile_name] = DemoCharacterPreviewer:new(self._world, profile_name, career_index, var_15_16, var_15_17, zoom_offset)
		end
	end
end

DemoTitleUI._play_sound = function (arg_16_0, arg_16_1)
	-- function 16
	return Managers.music:trigger_event(arg_16_1)
end

DemoTitleUI.get_ui_renderer = function (self)
	-- function 17
	return self._ui_renderer
end

DemoTitleUI.in_transition = function (self)
	-- function 18
	return self._camera_transition
end

DemoTitleUI._recreate_characters = function (self)
	-- function 19
	for k, v in pairs(self._character_previewers) do
		v:destroy()
	end

	self._character_previewers = {}

	self:_setup_characters()
end

local flag = false

DemoTitleUI.update = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not flag then
		self:_create_ui_elements()
		self:_recreate_characters()

		self._attract_mode_active = false
		flag = false
	end

	if not table.is_empty(self._character_previewers) then
		self:_setup_characters()
	end

	self:_update_scatter(arg_20_1, arg_20_2)
	self:_update_input(arg_20_1, arg_20_2)
	self:_update_camera(arg_20_1, arg_20_2)
	self:_update_career_information(arg_20_1, arg_20_2)
	self:_update_animation(arg_20_1, arg_20_2)
	self:_update_start_game(arg_20_1, arg_20_2)
	self:_update_back(arg_20_1, arg_20_2)
	self:_draw_3d_logo(arg_20_1, arg_20_2)
	self:_draw(arg_20_1, arg_20_2)
	self:_draw_fps(arg_20_1, arg_20_2)
	self:_update_character_previewers(arg_20_1, arg_20_2)
end

DemoTitleUI._update_scatter = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not self._scatter_system then
		local viewport = ScriptWorld.viewport(self._world, "title_screen_viewport")
		local camera = ScriptViewport.camera(viewport)
		local pose = ScriptCamera.pose(camera)

		ScatterSystem.move_observer(self._scatter_system, self._scatter_system_observer, Matrix4x4.translation(pose), Matrix4x4.rotation(pose))
	end
end

DemoTitleUI._update_input = function (self, arg_22_1, arg_22_2)
	-- function 22
	if not (not self._selected_profile and Managers.input:get_service("main_menu"):get("back", true) and not self._back_pressed and self:in_transition()) then
		self._character_previewers[self._selected_profile]:reset_state()
		self:animate_to_camera(DemoSettings.camera_end_position, nil, nil, 0.5)

		self._input_disabled = false
		self._back_pressed = false
	end
end

DemoTitleUI._update_character_previewers = function (self, arg_23_1, arg_23_2)
	-- function 23
	for k, v in pairs(self._character_previewers) do
		local var_23_0 = v
		local update = v.update
		local _ui_activated = self._ui_activated

		_ui_activated = not _ui_activated and not not self._selected_profile or not self._camera_transition

		update(var_23_0, _ui_activated, arg_23_1, arg_23_2)
	end

	if not self._ui_activated then
		return
	end

	if self._start_game_button_widget.content.button_hotspot.is_hover or not self._input_disabled then
		return
	end

	if self._back_button_widget.content.button_hotspot.is_hover or not self._input_disabled then
		return
	end
end

DemoTitleUI._update_start_game = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not self._camera_transition and not self._selected_profile then
		return
	end

	if not self._start_game_button_widget.content.button_hotspot.on_release then
		self._start_pressed = true
		self._input_disabled = true
	end
end

DemoTitleUI._update_back = function (self, arg_25_1, arg_25_2)
	-- function 25
	if not self._camera_transition and not self._selected_profile then
		return
	end

	if not self._back_button_widget.content.button_hotspot.on_release then
		self._back_pressed = true
		self._input_disabled = true
	end
end

DemoTitleUI._update_career_information = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not self._input_disabled then
		return
	end

	local flag = false

	self._selected_profile = nil

	for k, v in pairs(self._character_previewers) do
		if not v:is_pressed() then
			if not self._ui_animations.animate_in then
				self._ui_animations = {}

				local var_26_1 = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.right_side_root.local_position, 1, self._ui_scenegraph.right_side_root.local_position[1], 0, 0.4, math.easeInCubic)

				self._ui_animations.animate_in = var_26_1

				local var_26_2 = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.portrait_base.local_position, 1, self._ui_scenegraph.portrait_base.local_position[1], 0, 0.4, math.easeInCubic)

				self._ui_animations.animate_in_portrait = var_26_2

				local var_26_3 = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.button_root.local_position, 2, self._ui_scenegraph.button_root.local_position[2], 0, 0.4, math.easeInCubic)

				self._ui_animations.animate_in_buttons = var_26_3
			end

			if self._displayed_profile ~= k then
				local profile_information, var_26_5 = v:profile_information()

				self:_populate_career_page(profile_information, var_26_5)
			end

			flag = true
		end

		if not v:is_pressed() then
			if not v:was_pressed_this_frame() then
				local pressed_pose = v:pressed_pose()

				self:animate_to_camera(nil, pressed_pose, callback(v, "cb_on_select_animation_complete"), 0.5)
				v:outline_unit(false)
			end

			self._selected_profile = k
		end
	end

	if not ((flag or not self._selected_profile) and self._displayed_profile == self._selected_profile) then
		local profile_information_2, var_26_8 = self._character_previewers[self._selected_profile]:profile_information()

		self:_populate_career_page(profile_information_2, var_26_8)
	end

	local _ui_animation_cb = self._ui_animation_cb

	_ui_animation_cb = _ui_animation_cb or {}
	self._ui_animation_cb = _ui_animation_cb

	local _ui_animations = self._ui_animations

	_ui_animations = _ui_animations or {}
	self._ui_animations = _ui_animations

	if not (self._ui_animations.animate_out or self._ui_animations.delay or flag or self._selected_profile) then
		local function fn(self)
			-- function 27
			local var_27_0 = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.right_side_root.local_position, 1, self._ui_scenegraph.right_side_root.local_position[1], 450, 0.3, math.easeOutCubic)

			self._ui_animations = {}
			self._ui_animations.animate_out = var_27_0

			local var_27_1 = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.portrait_base.local_position, 1, self._ui_scenegraph.portrait_base.local_position[1], -450, 0.3, math.easeOutCubic)

			self._ui_animations.animate_out_portrait = var_27_1

			local var_27_2 = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.button_root.local_position, 2, self._ui_scenegraph.button_root.local_position[2], -200, 0.3, math.easeInCubic)

			self._ui_animations.animate_out_buttons = var_27_2
		end

		self._ui_animations.delay = UIAnimation.init(UIAnimation.function_by_time, {
			0,
			0,
			0
		}, 1, 0, 0, 0, math.easeInCubic)
		self._ui_animation_cb.delay = fn
	end
end

DemoTitleUI._update_animation = function (self, arg_28_1, arg_28_2)
	-- function 28
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_28_1)

		if not UIAnimation.completed(v) then
			if not self._ui_animation_cb[k] then
				self._ui_animation_cb[k](self)

				self._ui_animation_cb[k] = nil
			end

			self._ui_animations[k] = nil
		end
	end
end

DemoTitleUI._update_camera = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not self._camera_transition then
		local _timer = self._timer

		_timer = _timer or 0
		self._timer = _timer

		local current_pose = self._camera_poses.current_pose
		local _target_camera_pose = self._target_camera_pose

		if not self._target_camera_name then
			_target_camera_pose = self._camera_poses[self._target_camera_name]
		end

		if not (not current_pose and _target_camera_pose) then
			self._camera_transition = false
			self._timer = nil

			return
		end

		local _ref_time = self._ref_time

		_ref_time = _ref_time or num_2
		self._timer = math.clamp(self._timer + arg_29_1, 0, _ref_time)

		local smoothstep = math.smoothstep(self._timer / _ref_time, 0, 1)
		local lerp = Matrix4x4.lerp(current_pose:unbox(), _target_camera_pose:unbox(), smoothstep)
		local camera = ScriptViewport.camera(self._viewport)

		ScriptCamera.set_local_pose(camera, lerp)
		ScriptCamera.force_update(self._world, camera)

		if self._timer == _ref_time then
			self._camera_transition = false
			self._timer = 0

			if not self._camera_animation_cb then
				self._camera_animation_cb()

				self._camera_animation_cb = nil
			end
		end
	end

	local resolution, var_29_8 = Gui.resolution()
	local var_29_9 = self._camera_poses[DemoSettings.starting_camera_name]

	var_29_9 = var_29_9 or Matrix4x4Box(Matrix4x4.identity())

	local translation = Matrix4x4.translation(var_29_9:unbox())
	local rotation = Matrix4x4.rotation(var_29_9:unbox())
	local forward = Quaternion.forward(rotation)
	local num = resolution / 1920 * 0.5
	local from_quaternion_position = Matrix4x4.from_quaternion_position(rotation, translation + forward * num)

	Gui.move(self._world_gui, from_quaternion_position)
end

DemoTitleUI._draw_3d_logo = function (self, arg_30_1, arg_30_2)
	-- function 30
	local var_30_0 = Vector2(1920, 1080)
	local resolution, var_30_2 = Gui.resolution()

	Gui.bitmap(self._world_gui, "vermintide_2_logo_demo", Vector3(-var_30_0[1] * resolution / num * 0.5, -var_30_0[2] * resolution / num * 0.3, 1), Vector2(var_30_0[1] * resolution / num, var_30_0[2] * resolution / num))
end

DemoTitleUI._draw = function (self, arg_31_1, arg_31_2)
	-- function 31
	local _ui_renderer = self._ui_renderer
	local _career_video_ui_renderer = self._career_video_ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("main_menu")
	local is_device_active = self._input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_31_1, nil, self._render_settings)

	if not self._destroy_video_player then
		UIRenderer.destroy_video_player(_ui_renderer, str)

		self._destroy_video_player = nil
	elseif not self._attract_mode_enabled then
		if not self._attract_video.content.video_completed then
			if not _ui_renderer.video_players[str] then
				UIRenderer.create_video_player(_ui_renderer, str, self._world, attract_mode_video.video_name, attract_mode_video.loop)
			else
				if not self._sound_started then
					if not attract_mode_video.sound_start then
						Managers.music:trigger_event(attract_mode_video.sound_start)
					end

					self._sound_started = true
				end

				UIRenderer.draw_widget(_ui_renderer, self._attract_video)
				UIRenderer.draw_widget(_ui_renderer, self._dead_space_filler_widget)
			end
		elseif not _ui_renderer.video_players[str] then
			UIRenderer.destroy_video_player(_ui_renderer, str)

			self._sound_started = false

			if not attract_mode_video.sound_stop then
				Managers.music:trigger_event(attract_mode_video.sound_stop)
			end
		end
	else
		if not self._draw_information_text then
			UIRenderer.draw_widget(_ui_renderer, self._information_text)
		end

		if not self._draw_gamertag then
			UIRenderer.draw_widget(_ui_renderer, self._user_gamertag_widget)

			if not self._switch_profile_blocked then
				UIRenderer.draw_widget(_ui_renderer, self._change_profile_input_icon_widget)
				UIRenderer.draw_widget(_ui_renderer, self._change_profile_input_text_widget)
			end
		end
	end

	if not self._ui_activated then
		if not is_device_active then
			UIRenderer.draw_widget(_ui_renderer, self._console_cursor)
		end

		for k, v in pairs(self._widgets) do
			UIRenderer.draw_widget(_ui_renderer, v)
		end

		for k_2, v_2 in pairs(self._career_widgets) do
			UIRenderer.draw_widget(_ui_renderer, v_2)
		end

		UIWidgetUtils.animate_default_button(self._start_game_button_widget, arg_31_1)
		UIWidgetUtils.animate_default_button(self._back_button_widget, arg_31_1)
		UIRenderer.draw_widget(_ui_renderer, self._start_game_button_widget)
		UIRenderer.draw_widget(_ui_renderer, self._back_button_widget)
	elseif not (self._entering or self:in_transition()) then
		UIRenderer.draw_widget(_ui_renderer, self._press_start_widget)
	end

	UIRenderer.end_pass(_ui_renderer)

	if not self._video_widget and not self._ui_activated then
		UIRenderer.begin_pass(_career_video_ui_renderer, _ui_scenegraph, get_service, arg_31_1, nil, self._render_settings)

		if not self._video_created then
			UIRenderer.draw_widget(_career_video_ui_renderer, self._video_widget)
		end

		self._video_created = nil

		UIRenderer.end_pass(_career_video_ui_renderer)
	end
end

local str_2 = "arial"
local str_3 = "materials/fonts/" .. str_2
local num_3 = 32
local tbl = {}
local white = Colors.color_definitions.white
local black = Colors.color_definitions.black
local red = Colors.color_definitions.red
local num_4 = 0
local num_5 = 0

DemoTitleUI._draw_fps = function (self, arg_32_1, arg_32_2)
	-- function 32
	if BUILD == "release" then
		return
	end

	local _old_fps = self._old_fps

	_old_fps = _old_fps or 0
	self._old_fps = _old_fps

	local _fps = self._fps

	_fps = _fps or 0
	self._fps = _fps

	local _fps_cooldown = self._fps_cooldown

	_fps_cooldown = _fps_cooldown or 0
	self._fps_cooldown = _fps_cooldown

	local _ui_renderer = self._ui_renderer
	local _old_fps_2 = self._old_fps

	self._fps_cooldown = self._fps_cooldown + arg_32_1
	num_4 = num_4 + 1 / arg_32_1
	num_5 = num_5 + 1

	if self._fps_cooldown > 1 then
		self._old_fps = self._fps
		self._fps = num_4 / num_5
		num_4 = 0
		num_5 = 0
		self._fps_cooldown = 0
	end

	self._old_fps = math.lerp(self._old_fps, self._fps, arg_32_1 * 0.2)

	local format = string.format("%.2f FPS", _old_fps_2)
	local var_32_6
	local num = 30
	local PLATFORM = PLATFORM

	if not IS_CONSOLE then
		num = 28
	end

	if _old_fps_2 < num then
		var_32_6 = red
	else
		var_32_6 = white
	end

	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_2 = res_w * inv_scale
	local num_6 = res_h * inv_scale
	local var_32_14 = num_3
	local text_size, var_32_16 = UIRenderer.text_size(_ui_renderer, format, str_3, var_32_14)
	local num_7 = num_2 - text_size - (num_3 - 16)
	local num_8 = var_32_16 + 16

	tbl[1] = num_7
	tbl[2] = num_8
	tbl[3] = 899

	UIRenderer.draw_text(_ui_renderer, format, str_3, var_32_14, str_2, Vector3(unpack(tbl)), var_32_6)

	tbl[1] = num_7 + 2
	tbl[2] = num_8 - 2
	tbl[3] = 898

	UIRenderer.draw_text(_ui_renderer, format, str_3, var_32_14, str_2, Vector3(unpack(tbl)), black)
end

DemoTitleUI.activate_career_ui = function (self, arg_33_1)
	-- function 33
	self._ui_activated = arg_33_1
	self._selected_profile = nil
	self._ui_animations.reset = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.right_side_root.position, 1, self._ui_scenegraph.right_side_root.position[1], 450, 0, math.easeOutCubic)

	if not arg_33_1 then
		for k, v in pairs(self._character_previewers) do
			v:reset_state()
		end
	end
end

DemoTitleUI.animate_to_camera = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	-- function 34
	local camera = ScriptViewport.camera(self._viewport)
	local pose = ScriptCamera.pose(camera)

	self._camera_poses.current_pose = Matrix4x4Box(pose)
	self._target_camera_name = arg_34_1
	self._target_camera_pose = arg_34_2
	self._camera_transition = true
	self._camera_animation_cb = arg_34_3
	self._ref_time = arg_34_4
end

DemoTitleUI.enter_attract_mode = function (self)
	-- function 35
	self._attract_mode_enabled = true
	self._sound_started = false
	self._attract_video.content.video_content.video_completed = false
end

DemoTitleUI.exit_attract_mode = function (self)
	-- function 36
	self._attract_mode_enabled = false
	self._destroy_video_player = true
end

DemoTitleUI.video_completed = function (self)
	-- function 37
	return self._attract_video.content.video_content.video_completed
end

DemoTitleUI.attract_mode = function (self)
	-- function 38
	return self._attract_mode_enabled
end

DemoTitleUI.is_ready = function (self)
	-- function 39
	for k, v in pairs(self._character_previewers) do
		if not v:character_spawned() then
			return false
		end
	end

	return true
end

DemoTitleUI.should_start = function (self)
	-- function 40
	return self._start_pressed
end

DemoTitleUI.selected_profile = function (self)
	-- function 41
	return self._selected_profile
end

DemoTitleUI.set_start_pressed = function (self, arg_42_1)
	-- function 42
	self._entering = arg_42_1
end

DemoTitleUI.clear_playgo_status = function (arg_43_0)
	-- function 43
	return
end

DemoTitleUI.set_playgo_status = function (arg_44_0)
	-- function 44
	return
end

DemoTitleUI.show_menu = function (arg_45_0)
	-- function 45
	return
end

DemoTitleUI.clear_user_name = function (arg_46_0)
	-- function 46
	return
end

DemoTitleUI.current_menu_index = function (arg_47_0)
	-- function 47
	return
end

DemoTitleUI.active_menu_selection = function (arg_48_0)
	-- function 48
	return
end

DemoTitleUI.set_menu_item_enable_state_by_index = function (arg_49_0)
	-- function 49
	return
end

DemoTitleUI.destroy = function (self)
	-- function 50
	for k, v in pairs(self._character_previewers) do
		v:destroy()
	end

	self._character_previewers = {}

	print("destroying demo_ui")
	ScriptWorld.destroy_level_from_reference(self._world, self._level)
	UIRenderer.destroy(self._ui_renderer, self._world)
	UIRenderer.destroy(self._career_video_ui_renderer, self._world)
	World.destroy_gui(self._world, self._world_gui)
end

DemoTitleUI.set_information_text = function (arg_51_0, arg_51_1)
	-- function 51
	return
end

DemoTitleUI.set_user_name = function (self, arg_52_1)
	-- function 52
	self._draw_gamertag = true
	self._user_gamertag_widget.content.text = arg_52_1

	if not IS_PS4 then
		self._switch_profile_blocked = true
	end
end

DemoTitleUI.clear_user_name = function (self)
	-- function 53
	self._draw_gamertag = nil
	self._switch_profile_blocked = nil
end

DemoTitleUI.set_update_offline_data_enabled = function (arg_54_0, arg_54_1)
	-- function 54
	return
end

DemoTitleUI.disable_input = function (arg_55_0, arg_55_1)
	-- function 55
	return
end

DemoTitleUI.set_game_type = function (arg_56_0, arg_56_1)
	-- function 56
	return
end
