-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mission_selection.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mission_selection_definitions")
local widgets = var_0_0.widgets
local large_window_size = var_0_0.large_window_size
local create_level_widget = var_0_0.create_level_widget
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

local function fn(self, arg_1_1)
	-- function 1
	return self.act_presentation_order < arg_1_1.act_presentation_order
end

StartGameWindowMissionSelection = class(StartGameWindowMissionSelection)
StartGameWindowMissionSelection.NAME = "StartGameWindowMissionSelection"

StartGameWindowMissionSelection.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[StartGameWindow] Enter Substate StartGameWindowMissionSelection")

	self.parent = arg_2_1.parent

	local ingame_ui_context = arg_2_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(arg_2_1, arg_2_2)

	self._widgets_by_name.select_button.content.button_hotspot.disable_button = true

	local get_selected_area_name = self.parent:get_selected_area_name()

	self:_set_presentation_info()
	self:_setup_levels_by_area(get_selected_area_name)
	self:_update_level_option()
	self.parent:set_input_description("select_mission")

	arg_2_1.return_layout_name = nil
end

StartGameWindowMissionSelection.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_3
		tbl_2[k] = var_3_3
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end
end

StartGameWindowMissionSelection._setup_levels_by_area = function (self, arg_4_1)
	-- function 4
	local var_4_0 = AreaSettings[arg_4_1]
	local acts = var_4_0.acts

	self._is_dlc = var_4_0.dlc_name ~= nil

	self:_setup_level_acts()
	self:_present_acts(acts)

	local create_mission_background_widget = var_4_0.create_mission_background_widget

	if not create_mission_background_widget then
		local var_4_3 = create_mission_background_widget()

		self._dlc_background_widget = UIWidget.init(var_4_3)
	else
		self._dlc_background_widget = nil
	end
end

StartGameWindowMissionSelection._setup_level_acts = function (self)
	-- function 5
	local tbl = {}
	local num = 0

	for k, v in pairs(UnlockableLevels) do
		if not table.find(NoneActLevels, v) then
			local var_5_2 = LevelSettings[v]
			local act = var_5_2.act

			if not tbl[act] then
				tbl[act] = {}
			end

			local var_5_4 = tbl[act]

			var_5_4[#var_5_4 + 1] = var_5_2
			num = num + 1
		end
	end

	for k_2, v_2 in pairs(tbl) do
		table.sort(v_2, fn)
	end

	self._levels_by_act = tbl
end

StartGameWindowMissionSelection._present_acts = function (self, arg_6_1)
	-- function 6
	local _is_dlc = self._is_dlc

	if not _is_dlc then
		local level_root_node = self.ui_scenegraph.level_root_node
		local var_6_2 = large_window_size[1]

		level_root_node.local_position[1] = var_6_2 / 2
	end

	local statistics_db = self.statistics_db
	local _stats_id = self._stats_id
	local tbl = {}
	local num = 180
	local flag

	flag = not _is_dlc and 80 and 34

	local num_2 = 250
	local num_3 = 3
	local _levels_by_act = self._levels_by_act

	for k, v in pairs(_levels_by_act) do
		if not arg_6_1 and not table.contains(arg_6_1, k) then
			local var_6_11 = ActSettings[k]
			local sorting = var_6_11.sorting
			local num_4 = (sorting - 1) % num_3 + 1
			local count = #v
			local num_5 = 0
			local num_6 = 0
			local num_7 = 0
			local flag_2 = num_3 < sorting

			if not flag_2 then
				if not _is_dlc then
					num_5 = -((num + flag) * count) / 2 + (num + flag) / 2
				else
					num_7 = -num_2 + (num_3 - num_4) * num_2
				end
			end

			for k_2 = 1, #v do
				local var_6_19 = v[k_2]

				if not _is_dlc then
					if not flag_2 then
						num_5 = (num + flag) * 4
					elseif not (num_4 == 2 or k_2 ~= 1) then
						num_5 = num_5 + (num + flag) / 2
					end
				end

				local num_8 = #tbl + 1
				local str = "level_root_" .. num_8
				local mission_selection_offset = var_6_19.mission_selection_offset
				local var_6_23 = create_level_widget(str, mission_selection_offset)
				local var_6_24 = UIWidget.init(var_6_23)
				local content = var_6_24.content
				local style = var_6_24.style
				local level_id = var_6_19.level_id
				local display_name = var_6_19.display_name

				content.text = Localize(display_name)

				local level_unlocked = LevelUnlockUtils.level_unlocked(statistics_db, _stats_id, level_id)
				local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, _stats_id, level_id)

				content.frame = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_level_difficulty_index)
				content.locked = not level_unlocked
				content.act_key = k
				content.level_key = level_id

				local level_image = var_6_19.level_image

				if not level_image then
					content.icon = level_image
				else
					content.icon = "icons_placeholder"
				end

				content.boss_level, content.level_data = var_6_19.boss_level, var_6_19

				if not mission_selection_offset then
					local offset = var_6_24.offset

					offset[1] = num_5
					offset[2] = num_7 + num_6
				end

				if k_2 < count then
					local level_id_2 = v[k_2 + 1].level_id
					local level_unlocked_2 = LevelUnlockUtils.level_unlocked(statistics_db, _stats_id, level_id_2)
					local draw_path = var_6_11.draw_path

					draw_path = draw_path or not _is_dlc
					content.draw_path = draw_path
					content.draw_path_fill = level_unlocked_2
					style.path.texture_size[1] = num + flag
					style.path_glow.texture_size[1] = num + flag
				end

				tbl[num_8] = var_6_24
				num_5 = num_5 + (num + flag)
			end
		end
	end

	self._active_node_widgets = tbl

	self:_setup_required_act_connections()
end

StartGameWindowMissionSelection._setup_required_act_connections = function (self)
	-- function 7
	local statistics_db = self.statistics_db
	local _stats_id = self._stats_id
	local ui_scenegraph = self.ui_scenegraph
	local _active_node_widgets = self._active_node_widgets

	for i = 1, #_active_node_widgets do
		local var_7_4 = _active_node_widgets[i]
		local required_acts = LevelSettings[var_7_4.content.level_key].required_acts

		if not required_acts then
			local world_position = ui_scenegraph[var_7_4.scenegraph_id].world_position
			local offset = var_7_4.offset
			local num = world_position[1] + offset[1]
			local num_2 = world_position[2] + offset[2]

			for j = 1, #required_acts do
				local var_7_10 = required_acts[j]
				local _get_last_level_in_act = self:_get_last_level_in_act(var_7_10)

				for k = 1, #_active_node_widgets do
					local var_7_12 = _active_node_widgets[k]

					if var_7_12.content.level_key == _get_last_level_in_act then
						local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, _stats_id, _get_last_level_in_act)
						local flag = not completed_level_difficulty_index and completed_level_difficulty_index > 0
						local world_position_2 = ui_scenegraph[var_7_12.scenegraph_id].world_position
						local path = var_7_12.style.path
						local path_glow = var_7_12.style.path_glow
						local offset_2 = var_7_12.offset
						local num_3 = world_position_2[1] + offset_2[1]
						local num_4 = world_position_2[2] + offset_2[2]
						local distance_2d = math.distance_2d(num_3, num_4, num, num_2)
						local angle = math.angle(num_3, num_4, num, num_2)

						angle = not (num_2 < num_4) or not math.abs(angle) or -angle
						path.angle = angle
						path.texture_size[1] = distance_2d
						path_glow.texture_size[1] = distance_2d
						path_glow.angle = angle
						var_7_12.content.draw_path = true
						var_7_12.content.draw_path_fill = flag
					end
				end
			end

			return
		end
	end
end

StartGameWindowMissionSelection._get_last_level_in_act = function (arg_8_0, arg_8_1)
	-- function 8
	local var_8_0 = GameActs[arg_8_1]
	local var_8_1
	local num = 0

	for i = 1, #var_8_0 do
		local var_8_3 = var_8_0[i]
		local act_presentation_order = LevelSettings[var_8_3].act_presentation_order

		if num < act_presentation_order then
			num = act_presentation_order
			var_8_1 = var_8_3
		end
	end

	return var_8_1, num
end

StartGameWindowMissionSelection._get_first_level_id = function (self)
	-- function 9
	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		return _active_node_widgets[1].content.level_data.level_id
	end
end

StartGameWindowMissionSelection._is_level_presented = function (self, arg_10_1)
	-- function 10
	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i = 1, #_active_node_widgets do
			if _active_node_widgets[i].content.level_data.level_id == arg_10_1 then
				return true
			end
		end
	end

	return false
end

StartGameWindowMissionSelection._select_level = function (self, arg_11_1)
	-- function 11
	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i = 1, #_active_node_widgets do
			local var_11_1 = _active_node_widgets[i]
			local flag = var_11_1.content.level_data.level_id == arg_11_1

			var_11_1.content.button_hotspot.is_selected = flag
		end
	end

	self._selected_level_id = arg_11_1

	self:_set_presentation_info(arg_11_1)

	self._widgets_by_name.select_button.content.button_hotspot.disable_button = arg_11_1 == nil
end

StartGameWindowMissionSelection._set_presentation_info = function (self, arg_12_1)
	-- function 12
	local str = ""
	local str_2 = ""
	local str_3 = "map_frame_00"
	local flag = false
	local _widgets_by_name = self._widgets_by_name
	local content = _widgets_by_name.selected_level.content

	if not arg_12_1 then
		local statistics_db = self.statistics_db
		local _stats_id = self._stats_id
		local var_12_8 = LevelSettings[arg_12_1]
		local level_image = var_12_8.level_image
		local boss_level = var_12_8.boss_level
		local display_name = var_12_8.display_name

		str_2 = var_12_8.description_text

		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, _stats_id, arg_12_1)

		str_3 = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_level_difficulty_index)
		content.icon = level_image
		content.boss_level = boss_level
		str = Localize(display_name)
		str_2 = Localize(str_2)
		flag = true
	end

	content.frame = str_3
	content.locked = not flag
	content.visible = flag
	content.button_hotspot.disable_button = true
	_widgets_by_name.helper_text.content.visible = not flag
	_widgets_by_name.level_title_divider.content.visible = flag
	_widgets_by_name.level_title.content.text = str
	_widgets_by_name.description_text.content.text = str_2
end

StartGameWindowMissionSelection.on_exit = function (self, arg_13_1)
	-- function 13
	print("[StartGameWindow] Exit Substate StartGameWindowMissionSelection")

	self.ui_animator = nil

	self.parent:set_input_description(nil)
end

StartGameWindowMissionSelection.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	self:_update_animations(arg_14_1)
	self:draw(arg_14_1)
end

StartGameWindowMissionSelection.post_update = function (self, arg_15_1, arg_15_2)
	-- function 15
	self:_handle_input(arg_15_1, arg_15_2)
end

StartGameWindowMissionSelection._update_animations = function (self, arg_16_1)
	-- function 16
	local ui_animator = self.ui_animator

	ui_animator:update(arg_16_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StartGameWindowMissionSelection._is_button_pressed = function (arg_17_0, arg_17_1)
	-- function 17
	local button_hotspot = arg_17_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowMissionSelection._is_button_hovered = function (arg_18_0, arg_18_1)
	-- function 18
	if not arg_18_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

StartGameWindowMissionSelection._update_level_option = function (self)
	-- function 19
	local get_selected_level_id = self.parent:get_selected_level_id()

	if get_selected_level_id ~= self._selected_level_id then
		if not self:_is_level_presented(get_selected_level_id) then
			self:_select_level(get_selected_level_id)
		elseif not self._selected_level_id then
			local _get_first_level_id = self:_get_first_level_id()

			self:_select_level(_get_first_level_id)
		end
	end
end

StartGameWindowMissionSelection._handle_input = function (self, arg_20_1, arg_20_2)
	-- function 20
	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i = 1, #_active_node_widgets do
			local var_20_1 = _active_node_widgets[i]

			if not self:_is_button_hovered(var_20_1) then
				self:_play_sound("play_gui_lobby_button_02_mission_act_hover")
			end

			if not self:_is_button_pressed(var_20_1) then
				local level_id = var_20_1.content.level_data.level_id

				if self._selected_level_id ~= level_id then
					self:_play_sound("play_gui_lobby_button_02_mission_act_click")
					self:_select_level(level_id)
				end

				return
			end
		end
	end

	local select_button = self._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(select_button, arg_20_1)

	if not self:_is_button_hovered(select_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if not self:_is_button_pressed(select_button) then
		self:_play_sound("play_gui_lobby_button_02_mission_select")

		local parent = self.parent
		local get_selected_game_mode_layout_name = parent:get_selected_game_mode_layout_name()

		parent:set_layout_by_name(get_selected_game_mode_layout_name)
		parent:set_selected_level_id(self._selected_level_id)
	end
end

StartGameWindowMissionSelection.draw = function (self, arg_21_1)
	-- function 21
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_21_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_21_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_21_4)
	end

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for j = 1, #_active_node_widgets do
			local var_21_6 = _active_node_widgets[j]

			UIRenderer.draw_widget(ui_renderer, var_21_6)
		end
	end

	local _dlc_background_widget = self._dlc_background_widget

	if not _dlc_background_widget then
		UIRenderer.draw_widget(ui_renderer, _dlc_background_widget)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowMissionSelection._play_sound = function (self, arg_22_1)
	-- function 22
	self.parent:play_sound(arg_22_1)
end
