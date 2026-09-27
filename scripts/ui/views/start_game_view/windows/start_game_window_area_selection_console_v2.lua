-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_area_selection_console_v2.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_console_v2_definitions")
local widgets = var_0_0.widgets
local area_widgets = var_0_0.area_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = true

StartGameWindowAreaSelectionConsoleV2 = class(StartGameWindowAreaSelectionConsoleV2)
StartGameWindowAreaSelectionConsoleV2.NAME = "StartGameWindowAreaSelectionConsoleV2"

StartGameWindowAreaSelectionConsoleV2.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowAreaSelectionConsoleV2")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.world_manager = ingame_ui_context.world_manager
	self.render_settings = {
		snap_pixel_positions = true
	}
	self._has_exited = false
	self._params = arg_1_1
	self._offset = arg_1_2

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}
	self._ui_animations = {}
	self._ui_animation_callbacks = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self._area_unavailable = true

	self.parent:set_input_description("select_area_confirm")
	self:_setup_area_widgets()
	self:_update_area_option()
end

StartGameWindowAreaSelectionConsoleV2.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_3
		tbl_2[k] = var_2_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	local tbl_3 = {}
	local tbl_4 = {}
	local var_2_6 = UIWidget.init(var_0_0.main_campaign_widget)

	tbl_3[#tbl_3 + 1] = var_2_6
	tbl_4.main_campaign = var_2_6

	for k_2, v_2 in pairs(area_widgets) do
		local var_2_7 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_2_7
		tbl_4[k_2] = var_2_7
	end

	self._area_widgets = tbl_3
	self._area_widgets_by_name = tbl_4
	self._level_image_widgets = {}

	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

StartGameWindowAreaSelectionConsoleV2._setup_area_widgets = function (self)
	-- function 3
	local tbl = {}
	local num = var_0_0.grid_settings[1] * var_0_0.grid_settings[2]

	for k, v in pairs(AreaSettings) do
		if not v.exclude_from_area_selection then
			tbl[#tbl + 1] = v
		end

		if #tbl == num then
			break
		end
	end

	local function fn(self, arg_4_1)
		-- function 4
		return self.sort_order < arg_4_1.sort_order
	end

	table.sort(tbl, fn)

	local count = #tbl
	local var_3_4 = scenegraph_definition.area_root_1.size[1]
	local num_2 = 30
	local num_3 = -705
	local num_4 = 280
	local var_3_8 = num_4
	local grid_settings = var_0_0.grid_settings
	local tbl_2 = {}
	local statistics_db = self.statistics_db
	local _stats_id = self._stats_id
	local tbl_3 = {}

	for k_2 = 1, count do
		local var_3_14 = tbl[k_2]
		local main_campaign

		if k_2 == 1 then
			main_campaign = self._widgets_by_name.main_campaign

			if not main_campaign then
				-- Nothing
			end
		end

		main_campaign = self._area_widgets[k_2]

		::label_3_0::

		tbl_3[k_2] = main_campaign

		local level_image = var_3_14.level_image
		local content = main_campaign.content
		local style = main_campaign.style

		content.icon = level_image

		local flag = true
		local dlc_name = var_3_14.dlc_name

		if not dlc_name then
			flag = Managers.unlock:is_dlc_unlocked(dlc_name)
		end

		content.area_name, content.locked = var_3_14.name, not flag

		local long_description_text = var_3_14.long_description_text

		long_description_text = long_description_text or self:_create_random_desc()
		content.area_desc = long_description_text

		local huge = math.huge
		local acts = var_3_14.acts

		for l = 1, #acts do
			local var_3_24 = acts[l]
			local highest_completed_difficulty_index_by_act = LevelUnlockUtils.highest_completed_difficulty_index_by_act(statistics_db, _stats_id, var_3_24)

			if highest_completed_difficulty_index_by_act < huge then
				huge = highest_completed_difficulty_index_by_act
			end
		end

		content.frame = UIWidgetUtils.get_level_frame_by_difficulty_index(huge)

		local offset = main_campaign.offset

		if k_2 == 1 then
			local floor = math.floor(math.max(0, count - 2) / grid_settings[1])

			offset[1] = num_3
			offset[2] = -floor * (var_3_4 + num_2) * 0.5
			style.divider.texture_size[2] = (floor + 1) * (var_3_4 + num_2)
			tbl_2[k_2] = {}
			tbl_2[k_2][#tbl_2[k_2] + 1] = main_campaign
		else
			local num_5 = (k_2 - 2) % grid_settings[1]
			local floor_2 = math.floor((k_2 - 2) / grid_settings[1])

			offset[1] = num_3 + num_5 * (var_3_4 + num_2) + num_4 * math.sign(k_2 - 1)
			offset[2] = -floor_2 * (var_3_4 + num_2)
			var_3_8 = var_3_8 + var_3_4 + num_2

			local num_6 = 2 + (k_2 - 2) % grid_settings[1]
			local var_3_31 = tbl_2[num_6]

			var_3_31 = var_3_31 or {}
			tbl_2[num_6] = var_3_31
			tbl_2[num_6][#tbl_2[num_6] + 1] = main_campaign
		end
	end

	self._active_area_widgets = tbl_3
	self._selection_grid = tbl_2
	self._selected_grid_index = {
		1,
		1
	}
end

StartGameWindowAreaSelectionConsoleV2._create_random_desc = function (arg_5_0)
	-- function 5
	local num = 1 + Math.random(5)
	local str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut fringilla in nulla eu rutrum. "
	local str_2 = ""

	for i = 1, num do
		str_2 = str_2 .. str
	end

	return str_2
end

StartGameWindowAreaSelectionConsoleV2._select_area_by_name = function (self, arg_6_1)
	-- function 6
	local _selection_grid = self._selection_grid
	local str = " "
	local _selected_grid_index = self._selected_grid_index

	if not _selection_grid then
		for i = 1, #_selection_grid do
			local var_6_3 = _selection_grid[i]

			for j = 1, #var_6_3 do
				local var_6_4 = var_6_3[j]
				local content = var_6_4.content
				local flag = content.area_name == arg_6_1

				var_6_4.content.button_hotspot.is_selected = flag
				_selected_grid_index = not flag and {
					i,
					j
				} and _selected_grid_index
				str = not flag and content.area_desc and str
			end
		end
	end

	self._selected_area_name = arg_6_1
	self._selected_grid_index = _selected_grid_index

	self:_set_area_presentation_info(arg_6_1, str)

	self._area_unavailable = arg_6_1 == nil
end

StartGameWindowAreaSelectionConsoleV2._set_area_presentation_info = function (self, arg_7_1, arg_7_2)
	-- function 7
	local str = ""
	local str_2 = ""
	local str_3 = ""
	local flag_2 = true
	local stats_id = Managers.player:local_player():stats_id()
	local statistics_db = Managers.player:statistics_db()
	local var_7_6 = AreaSettings[arg_7_1]

	if not var_7_6 then
		local dlc_name = var_7_6.dlc_name

		if not dlc_name then
			flag_2 = Managers.unlock:is_dlc_unlocked(dlc_name)
		end

		str = Localize(var_7_6.display_name)

		local var_7_8 = Localize(var_7_6.description_text)

		str_3 = not flag_2 and var_7_6.area_type and (var_7_6.sort_order ~= 1 or not "area_selection_campaign" or "area_selection_side_quest") and "dlc1_2_dlc_level_locked_tooltip"
	end

	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.area_title.content.text = str
	_widgets_by_name.area_desc.content.text = arg_7_2
	_widgets_by_name.area_type.content.text = str_3
	_widgets_by_name.area_type.content.dlc_locked = not flag_2
	_widgets_by_name.area_type.content.locked = not flag_2

	if not flag then
		local style = _widgets_by_name.area_desc.style

		style.text.area_size = {
			1200,
			225
		}
		style.text.vertical_alignment = "top"
		style.text.dynamic_font_size_word_wrap = true
		style.text_shadow.area_size = {
			1200,
			225
		}
		style.text_shadow.vertical_alignment = "top"
		style.text_shadow.dynamic_font_size_word_wrap = true
		_widgets_by_name.area_title.offset[2] = 200
		_widgets_by_name.title_divider.offset[2] = 200
		_widgets_by_name.area_type.offset[2] = 200
	else
		local get_text_height = UIUtils.get_text_height(self.ui_renderer, _widgets_by_name.area_desc.style.text.area_size, _widgets_by_name.area_desc.style.text, arg_7_2)

		_widgets_by_name.area_title.offset[2] = get_text_height
		_widgets_by_name.title_divider.offset[2] = get_text_height
		_widgets_by_name.area_type.offset[2] = get_text_height
	end

	local num = 40
	local num_2 = 5
	local acts = var_7_6.acts
	local num_3 = 0

	table.clear(self._level_image_widgets)

	for i, v in ipairs(acts) do
		local var_7_16 = GameActs[v]

		for i_2, v_2 in ipairs(var_7_16) do
			local var_7_17 = LevelSettings[v_2]
			local level_unlocked = LevelUnlockUtils.level_unlocked(statistics_db, stats_id, var_7_17.level_id)
			local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, stats_id, var_7_17.level_id)
			local init = UIWidget.init
			local create_level_image_func = var_0_0.create_level_image_func
			local small_level_image = var_7_17.small_level_image

			small_level_image = small_level_image or var_7_17.level_id .. "_small_image"

			local var_7_23 = init(create_level_image_func(small_level_image, completed_level_difficulty_index > 0))

			var_7_23.offset[1] = num_3
			num_3 = num_3 + num_2 + var_7_23.style.level_image.texture_size[1]
			var_7_23.style.level_image.saturated = not level_unlocked

			local level_image = var_7_23.style.level_image
			local unlocked_color

			if not level_unlocked then
				unlocked_color = var_7_23.style.level_image.unlocked_color

				if not unlocked_color then
					-- Nothing
				end
			end

			unlocked_color = var_7_23.style.level_image.locked_color

			::label_7_0::

			level_image.color = unlocked_color
			var_7_23.content.completed = completed_level_difficulty_index > 0
			var_7_23.content.boss_level = var_7_17.boss_level
			self._level_image_widgets[#self._level_image_widgets + 1] = var_7_23
		end

		num_3 = num_3 + num
	end

	if not flag_2 then
		self.parent:set_input_description("select_area_buy")
	else
		local flag_3 = true

		if not var_7_6.unlock_requirement_function then
			local stats_id_2 = Managers.player:local_player():stats_id()
			local statistics_db_2 = Managers.player:statistics_db()

			flag_3 = var_7_6.unlock_requirement_function(statistics_db_2, stats_id_2)
		end

		if not flag_3 then
			self.parent:set_input_description("select_area_confirm")

			_widgets_by_name.area_type.content.locked = false
		else
			self.parent:set_input_description("select_area_base")

			_widgets_by_name.area_type.content.text = var_7_6.unlock_requirement_description
			_widgets_by_name.area_type.content.locked = true
		end
	end

	local get_video_player_by_name = self.parent:get_video_player_by_name(arg_7_1)
	local video_settings = var_7_6.video_settings

	if not video_settings then
		local material_name = video_settings.material_name

		self:_assign_video_player(material_name, get_video_player_by_name)
	end

	local menu_sound_event = var_7_6.menu_sound_event

	self:_play_sound(menu_sound_event)
end

StartGameWindowAreaSelectionConsoleV2.on_exit = function (self, arg_8_1)
	-- function 8
	print("[StartGameWindow] Exit Substate StartGameWindowAreaSelectionConsoleV2")

	self.ui_animator = nil

	self.parent:set_input_description(nil)

	self._has_exited = true

	self:_destroy_video_widget()
	self:_play_sound("Stop_hud_menu_area_music")
end

StartGameWindowAreaSelectionConsoleV2.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	self:_update_animations(arg_9_1)
	self:_handle_input(arg_9_1, arg_9_2)
end

StartGameWindowAreaSelectionConsoleV2.post_update = function (self, arg_10_1, arg_10_2)
	-- function 10
	self:draw(arg_10_1)
end

StartGameWindowAreaSelectionConsoleV2._update_animations = function (self, arg_11_1)
	-- function 11
	local ui_animator = self.ui_animator

	ui_animator:update(arg_11_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _active_area_widgets = self._active_area_widgets

	if not _active_area_widgets then
		for k_2 = 1, #_active_area_widgets do
			local var_11_3 = _active_area_widgets[k_2]

			self:_animate_area_widget(var_11_3, arg_11_1)
		end
	end

	local _ui_animations = self._ui_animations
	local _ui_animation_callbacks = self._ui_animation_callbacks

	for k_3, v_2 in pairs(_ui_animations) do
		UIAnimation.update(v_2, arg_11_1)

		if not UIAnimation.completed(v_2) then
			_ui_animations[k_3] = nil

			if not _ui_animation_callbacks[k_3] then
				_ui_animation_callbacks[k_3]()

				_ui_animation_callbacks[k_3] = nil
			end
		end
	end
end

StartGameWindowAreaSelectionConsoleV2._is_button_pressed = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowAreaSelectionConsoleV2._is_button_hovered = function (arg_13_0, arg_13_1)
	-- function 13
	if not arg_13_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

StartGameWindowAreaSelectionConsoleV2._update_area_option = function (self)
	-- function 14
	local get_selected_area_name = self.parent:get_selected_area_name()

	if get_selected_area_name ~= self._selected_area_name then
		self:_select_area_by_name(get_selected_area_name)
	end
end

StartGameWindowAreaSelectionConsoleV2._handle_input = function (self, arg_15_1, arg_15_2)
	-- function 15
	local window_input_service = self.parent:window_input_service()
	local _active_area_widgets = self._active_area_widgets
	local _selection_grid = self._selection_grid
	local is_device_active = Managers.input:is_device_active("mouse")

	if not is_device_active then
		local var_15_4 = self._selected_grid_index[1]
		local var_15_5 = self._selected_grid_index[2]
		local count = #_selection_grid
		local count_2 = #_selection_grid[var_15_4]

		if not window_input_service:get("move_left") then
			local clamp = math.clamp(var_15_4 - 1, 1, count)
			local count_3 = #_selection_grid[clamp]
			local area_name = _selection_grid[clamp][math.min(var_15_5, count_3)].content.area_name

			if self._selected_area_name ~= area_name then
				self:_select_area_by_name(area_name)
			end
		elseif not window_input_service:get("move_right") then
			local clamp_2 = math.clamp(var_15_4 + 1, 1, count)
			local count_4 = #_selection_grid[clamp_2]
			local area_name_2 = _selection_grid[clamp_2][math.min(var_15_5, count_4)].content.area_name

			if self._selected_area_name ~= area_name_2 then
				self:_select_area_by_name(area_name_2)
			end
		elseif not window_input_service:get("move_down") then
			local num = var_15_5 + 1
			local var_15_15 = _selection_grid[var_15_4][num]

			while not (var_15_15 or not (var_15_4 > 1)) do
				var_15_4 = var_15_4 - 1
				var_15_15 = _selection_grid[var_15_4][num]
			end

			local flag = not var_15_15 and var_15_15.content
			local area_name_3

			if not flag then
				area_name_3 = flag.area_name

				if not area_name_3 then
					-- Nothing
				end
			end

			area_name_3 = self._selected_area_name

			::label_15_0::

			if self._selected_area_name ~= area_name_3 then
				self:_select_area_by_name(area_name_3)
			end
		elseif not window_input_service:get("move_up") then
			local clamp_3 = math.clamp(var_15_5 - 1, 1, count_2)
			local area_name_4 = _selection_grid[var_15_4][clamp_3].content.area_name

			if self._selected_area_name ~= area_name_4 then
				self:_select_area_by_name(area_name_4)
			end
		end
	elseif not _active_area_widgets then
		for i = 1, #_active_area_widgets do
			local var_15_20 = _active_area_widgets[i]

			if not self:_is_button_hovered(var_15_20) then
				local area_name_5 = var_15_20.content.area_name

				if self._selected_area_name ~= area_name_5 then
					self:_select_area_by_name(area_name_5)
				end
			end

			if not (not self:_is_button_pressed(var_15_20) and self._area_unavailable) then
				self:_on_select_button_pressed()

				return
			end
		end
	end

	local flag_2 = not not is_device_active or window_input_service:get("confirm_press", true)

	if self._area_unavailable or not flag_2 then
		self:_on_select_button_pressed()
	end
end

StartGameWindowAreaSelectionConsoleV2._on_select_button_pressed = function (self)
	-- function 16
	local _selected_area_name = self._selected_area_name
	local var_16_1 = AreaSettings[_selected_area_name]
	local flag = true
	local dlc_name = var_16_1.dlc_name

	if not dlc_name then
		flag = Managers.unlock:is_dlc_unlocked(dlc_name)
	end

	if not flag then
		local flag_2 = true

		if not var_16_1.unlock_requirement_function then
			local stats_id = Managers.player:local_player():stats_id()
			local statistics_db = Managers.player:statistics_db()

			flag_2 = var_16_1.unlock_requirement_function(statistics_db, stats_id)
		end

		if not flag_2 then
			local parent = self.parent
			local str = "mission_selection"

			parent:set_selected_area_name(_selected_area_name)
			parent:set_layout_by_name(str)
		end
	else
		local store_page_url = var_16_1.store_page_url

		self:_show_storepage(store_page_url, dlc_name)
	end

	self:_play_sound("Play_hud_menu_area_start")
end

StartGameWindowAreaSelectionConsoleV2.draw = function (self, arg_17_1)
	-- function 17
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_17_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_17_4 = _widgets[i]

		UIRenderer.draw_widget(ui_top_renderer, var_17_4)
	end

	local _active_area_widgets = self._active_area_widgets

	if not _active_area_widgets then
		for j = 1, #_active_area_widgets do
			local var_17_6 = _active_area_widgets[j]

			UIRenderer.draw_widget(ui_top_renderer, var_17_6)
		end
	end

	local _level_image_widgets = self._level_image_widgets

	if not _level_image_widgets then
		for k = 1, #_level_image_widgets do
			local var_17_8 = _level_image_widgets[k]

			UIRenderer.draw_widget(ui_top_renderer, var_17_8)
		end
	end

	if not self._draw_video_next_frame then
		if not (not self._video_widget and self._has_exited) then
			if not self._video_created then
				UIRenderer.draw_widget(ui_top_renderer, self._video_widget)
			else
				self._video_created = nil
			end
		end
	elseif not self._draw_video_next_frame then
		self._draw_video_next_frame = nil
	end

	UIRenderer.end_pass(ui_top_renderer)
end

StartGameWindowAreaSelectionConsoleV2._play_sound = function (self, arg_18_1)
	-- function 18
	self.parent:play_sound(arg_18_1)
end

StartGameWindowAreaSelectionConsoleV2._assign_video_player = function (self, arg_19_1, arg_19_2)
	-- function 19
	self:_destroy_video_widget()

	local str = "video"
	local create_fixed_aspect_video = UIWidgets.create_fixed_aspect_video(str, arg_19_1)
	local var_19_2 = UIWidget.init(create_fixed_aspect_video)

	var_19_2.content.video_content.video_player = arg_19_2

	local world = self.ui_top_renderer.world

	World.add_video_player(world, arg_19_2)

	self._video_widget = var_19_2
	self._video_created = true
	self._draw_video_next_frame = true

	local color = self._widgets_by_name.foreground.style.rect.color

	self._ui_animations.fade_in = UIAnimation.init(UIAnimation.function_by_time, color, 1, 255, 0, 0.5, math.easeInCubic)
end

StartGameWindowAreaSelectionConsoleV2._destroy_video_widget = function (self)
	-- function 20
	local _video_widget = self._video_widget

	if not _video_widget then
		local ui_top_renderer = self.ui_top_renderer
		local video_player = _video_widget.content.video_content.video_player
		local world = ui_top_renderer.world

		World.remove_video_player(world, video_player)

		self._video_widget = nil
	end

	self._video_created = nil
end

StartGameWindowAreaSelectionConsoleV2._animate_area_widget = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	local content = arg_21_1.content
	local style = arg_21_1.style
	local button_hotspot = content.button_hotspot
	local num = 20
	local is_selected = button_hotspot.is_selected
	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local is_clicked

	if not is_selected then
		is_clicked = button_hotspot.is_clicked

		if not is_clicked then
			-- Nothing
		end

		if button_hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_21_1

	::label_21_0::

	is_clicked = true

	::label_21_1::

	if not is_clicked then
		input_progress = math.min(input_progress + arg_21_2 * num, 1)
	else
		input_progress = math.max(input_progress - arg_21_2 * num, 0)
	end

	local num_2 = 8
	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	if not button_hotspot.is_hover then
		hover_progress = math.min(hover_progress + arg_21_2 * num_2, 1)
	else
		hover_progress = math.max(hover_progress - arg_21_2 * num_2, 0)
	end

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_21_2 * num_2, 1)
	else
		selection_progress = math.max(selection_progress - arg_21_2 * num_2, 0)
	end

	local num_3 = 255 * math.max(hover_progress, selection_progress)

	style.icon_glow.color[1] = num_3
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

StartGameWindowAreaSelectionConsoleV2._show_storepage = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	local PLATFORM = PLATFORM

	if not IS_WINDOWS and not rawget(_G, "Steam") then
		if not arg_22_1 then
			Steam.open_url(arg_22_1)
		end
	elseif not IS_XB1 then
		local user_id = Managers.account:user_id()

		if not arg_22_2 then
			local dlc_id = Managers.unlock:dlc_id(arg_22_2)

			if not dlc_id then
				XboxLive.show_product_details(user_id, dlc_id)
			else
				Application.error(string.format("[StartGameWindowAreaSelection:_show_storepage] No product_id for dlc: %s", arg_22_2))
			end
		else
			Application.error("[StartGameWindowAreaSelection:_show_storepage] No dlc name")
		end
	elseif not IS_PS4 then
		local user_id_2 = Managers.account:user_id()

		if not arg_22_2 then
			local ps4_dlc_product_label = Managers.unlock:ps4_dlc_product_label(arg_22_2)

			if not ps4_dlc_product_label then
				Managers.system_dialog:open_commerce_dialog(NpCommerceDialog.MODE_PRODUCT, user_id_2, {
					ps4_dlc_product_label
				})
			else
				Application.error(string.format("[StartGameWindowAreaSelection:_show_storepage] No product_id for dlc: %s", arg_22_2))
			end
		else
			Application.error("[StartGameWindowAreaSelection:_show_storepage] No dlc name")
		end
	end
end
