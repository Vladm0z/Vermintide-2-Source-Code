-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_mission_selection.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_mission_selection_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local widget_functions = var_0_0.widget_functions
local grid_settings = var_0_0.grid_settings
local str = "confirm_press"

StartGameWindowVersusMissionSelection = class(StartGameWindowVersusMissionSelection)
StartGameWindowVersusMissionSelection.NAME = "StartGameWindowVersusMissionSelection"

StartGameWindowVersusMissionSelection.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowVersusMissionSelection")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self._player_manager = player
	self._peer_id = ingame_ui_context.peer_id
	self._selected_grid_index = {
		1,
		1
	}
	self._animations = {}
	self._ui_animations = {}

	self:_gather_level_information()
	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_handle_input_desc()

	local get_selected_layout_name = self._parent:get_selected_layout_name()

	get_selected_layout_name = get_selected_layout_name or "versus_custom_game"
	self._return_layout_name = get_selected_layout_name

	self:_start_transition_animation("on_enter")
end

local function fn(self, arg_2_1)
	-- function 2
	return self.act_presentation_order < arg_2_1.act_presentation_order
end

StartGameWindowVersusMissionSelection._gather_level_information = function (self)
	-- function 3
	local versus = UnlockableLevelsByGameMode.versus
	local tbl = {}

	for i = 1, #versus do
		local var_3_2 = versus[i]

		tbl[i] = LevelSettings[var_3_2]
	end

	table.sort(tbl, fn)

	tbl.act_name = "act_versus"
	self._sorted_level_data = {
		{
			area_display_name = "area_selection_carousel_name",
			levels_by_act = {
				tbl
			}
		},
		{
			area_display_name = "random_level",
			levels_by_act = {
				{
					DummyAnyLevel,
					act_name = "act_versus"
				}
			}
		}
	}
end

StartGameWindowVersusMissionSelection._start_transition_animation = function (self, arg_4_1)
	-- function 4
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_4_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_4_1] = start_animation
end

StartGameWindowVersusMissionSelection._create_ui_elements = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {
		0,
		0,
		0
	}
	local num = 1

	for i = 1, #self._sorted_level_data do
		tbl_5[1] = 0

		local var_5_6 = self._sorted_level_data[i]
		local area_name = var_5_6.area_name
		local var_5_8 = UIWidget.init(widget_functions.create_area_entry(var_5_6, tbl_5))

		tbl[#tbl + 1] = var_5_8

		local var_5_9 = tbl_5[2]
		local background = var_5_8.style.background
		local frame = var_5_8.style.frame

		tbl_5[1] = tbl_5[1] + grid_settings.area_spacing[1]
		tbl_5[2] = tbl_5[2] + grid_settings.area_spacing[2]
		tbl_5[3] = tbl_5[3] + grid_settings.area_spacing[3]

		local tbl_6 = {
			0,
			tbl_5[2],
			tbl_5[3]
		}
		local levels_by_act = var_5_6.levels_by_act
		local flag = #levels_by_act > 1

		for j = 1, #levels_by_act do
			tbl_6[1] = grid_settings.margin
			tbl_5[1] = grid_settings.margin

			local var_5_15 = levels_by_act[j]
			local act_name = var_5_15.act_name

			if not flag then
				local var_5_17 = UIWidget.init(widget_functions.create_act_entry(act_name .. "_display_name", tbl_6))

				tbl_6[1] = tbl_6[1] + grid_settings.act_spacing[1]
				tbl_6[2] = tbl_6[2] + grid_settings.act_spacing[2]
				tbl_6[3] = tbl_6[3] + grid_settings.act_spacing[3]
				tbl_2[#tbl_2 + 1] = var_5_17

				local var_5_18 = UIWidget.init(widget_functions.create_act_entry(act_name .. "_display_name", tbl_5))

				tbl_5[1] = tbl_5[1] + grid_settings.act_spacing[1]
				tbl_5[2] = tbl_5[2] + grid_settings.act_spacing[2]
				tbl_5[3] = tbl_5[3] + grid_settings.act_spacing[3]
				tbl[#tbl + 1] = var_5_18
			end

			local count = #var_5_15

			for k = 1, count do
				local clone = table.clone(tbl_6)
				local num_2 = k - 1
				local var_5_22 = var_5_15[math.min(k, #var_5_15)]
				local flag_2 = false
				local var_5_24

				if var_5_22.level_id ~= "any" then
					local dlc_name = var_5_22.dlc_name

					if not (not dlc_name and Managers.unlock:is_dlc_unlocked(dlc_name)) then
						flag_2 = true
						var_5_24 = "dlc"
					end

					local versus_map_pool = script_data.versus_map_pool

					versus_map_pool = versus_map_pool or Managers.mechanism:mechanism_setting_for_title("map_pool")

					if not (not versus_map_pool and table.find(versus_map_pool, var_5_22.level_id)) then
						flag_2 = true
						var_5_24 = "map_pool"
					end
				end

				clone[1] = clone[1] + grid_settings.level_spacing[1] * (num_2 % grid_settings.columns)
				clone[2] = clone[2] + grid_settings.level_spacing[2] * math.floor(num_2 / grid_settings.columns)
				clone[3] = clone[3] + grid_settings.level_spacing[3]

				local num_3 = math.floor(num_2 / grid_settings.columns) + 1
				local num_4 = num_2 % grid_settings.columns + 1
				local var_5_29 = UIWidget.init(widget_functions.create_level_entry(var_5_22, clone, self._selected_grid_index, {
					num_3,
					num_4
				}, flag_2, var_5_24, self._level_preferences))
				local num_5 = math.floor(num_2 / grid_settings.columns) + 1
				local num_6 = num_2 % grid_settings.columns + 1
				local var_5_32 = tbl_4[num_5]

				var_5_32 = var_5_32 or {}
				tbl_4[num_5] = var_5_32

				local var_5_33 = tbl_4[num_5]
				local var_5_34 = tbl_4[num_5][num_6]

				var_5_34 = var_5_34 or {}
				var_5_33[num_6] = var_5_34
				tbl_4[num_5][num_6] = var_5_29
				tbl_2[#tbl_2 + 1] = var_5_29

				local clone_2 = table.clone(tbl_5)

				clone_2[1] = clone_2[1] + grid_settings.level_spacing[1] * (num_2 % grid_settings.columns)
				clone_2[2] = clone_2[2] + grid_settings.level_spacing[2] * math.floor(num_2 / grid_settings.columns)
				clone_2[3] = clone_2[3] + grid_settings.level_spacing[3]

				local num_7 = num - 1 + num_5
				local var_5_37 = UIWidget.init(widget_functions.create_level_entry(var_5_22, clone_2, self._selected_grid_index, {
					num_7,
					num_6
				}, flag_2, var_5_24, self._level_preferences))
				local var_5_38 = tbl_3[num_7]

				var_5_38 = var_5_38 or {}
				tbl_3[num_7] = var_5_38

				local var_5_39 = tbl_3[num_7]
				local var_5_40 = tbl_3[num_7][num_6]

				var_5_40 = var_5_40 or {}
				var_5_39[num_6] = var_5_40
				tbl_3[num_7][num_6] = var_5_37
				tbl[#tbl + 1] = var_5_37
				var_5_37.content.selected_index = self._selected_grid_index
				var_5_37.content.preferred_levels = self._level_preferences
			end

			local num_8 = 1 + math.floor((count - 1) / grid_settings.columns)

			tbl_6[2] = tbl_6[2] + grid_settings.level_spacing[2] * num_8
			tbl_5[2] = tbl_5[2] + grid_settings.level_spacing[2] * num_8
			num = num + num_8
		end

		background.texture_size[2] = tbl_5[2] - var_5_9 + grid_settings.section_spacing[2] * 0.5
		frame.area_size[2] = -background.texture_size[2] + frame.edge_height * 2
		background.offset[2] = tbl_5[2] - var_5_9 + grid_settings.section_spacing[2] * 0.5
		tbl_6[2] = tbl_6[2] + grid_settings.section_spacing[2]
		tbl_5[2] = tbl_5[2] + grid_settings.section_spacing[2]
	end

	self._total_length = tbl_5[2]
	self._scroll_multiplier = (UISettings.game_start_windows.size[2] + 20) / math.abs(self._total_length)

	local scroller = self._widgets_by_name.scroller

	scroller.style.scroller.texture_size[2] = (UISettings.game_start_windows.size[2] + 20) * self._scroll_multiplier - 6
	scroller.content.visible = false
	self._current_entries = tbl
	self._current_grid_entries = tbl_3
	self._global_entries = tbl
	self._area_entries = tbl_2
	self._global_grid_entries = tbl_3
	self._area_grid_entries = tbl_4

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_5_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_5_2[1]
		local_position[2] = local_position[2] + arg_5_2[2]
		local_position[3] = local_position[3] + arg_5_2[3]
	end

	self:_populate_description()
end

StartGameWindowVersusMissionSelection.on_exit = function (self, arg_6_1)
	-- function 6
	print("[StartGameWindow] Exit Substate StartGameWindowVersusMissionSelection")

	self._ui_animator = nil

	self._parent:set_input_description(nil)
end

StartGameWindowVersusMissionSelection.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self:_update_animations(arg_7_1)
	self:_handle_input(arg_7_1, arg_7_2)
	self:_update_gamepad_scroller(arg_7_1, arg_7_2)
	self:_update_scroller(arg_7_1, arg_7_2)
	self:_draw(arg_7_1)
end

StartGameWindowVersusMissionSelection._update_gamepad_scroller = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not Managers.input:is_device_active("gamepad") then
		return
	end

	local num = UISettings.game_start_windows.size[2] + 20
	local num_2 = self._total_length + UISettings.game_start_windows.size[2] + 20
	local var_8_2 = self._ui_scenegraph.grid_anchor.local_position[2]
	local _current_grid_entries = self._current_grid_entries
	local _selected_grid_index = self._selected_grid_index
	local _old_grid_y_selection = self._old_grid_y_selection

	_old_grid_y_selection = _old_grid_y_selection or 0

	local var_8_6 = _selected_grid_index[1]
	local var_8_7 = _selected_grid_index[2]

	if var_8_6 == _old_grid_y_selection then
		return
	end

	local var_8_8 = _current_grid_entries[var_8_6][var_8_7].offset[2]
	local num_3 = -var_8_2 - var_8_8
	local clamp = math.clamp(var_8_2 + (num_3 - num / 2), 0, math.abs(num_2))

	self._ui_animations.scroll = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.grid_anchor.position, 2, self._ui_scenegraph.grid_anchor.position[2], clamp, 0.3, math.easeOutCubic)

	local scroller = self._widgets_by_name.scroller.style.scroller
	local num_4 = 3 + (UISettings.game_start_windows.size[2] - 6) * (1 - self._scroll_multiplier) * (clamp / math.abs(num_2))

	self._ui_animations.scroller = UIAnimation.init(UIAnimation.function_by_time, scroller.offset, 2, scroller.offset[2], -num_4, 0.3, math.easeOutCubic)
	self._old_grid_y_selection = var_8_6
end

StartGameWindowVersusMissionSelection._update_scroller = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	if not Managers.input:is_device_active("gamepad") then
		return
	end
end

StartGameWindowVersusMissionSelection.post_update = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	return
end

StartGameWindowVersusMissionSelection._update_animations = function (self, arg_11_1)
	-- function 11
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_11_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _ui_animations = self._ui_animations

	for k_2, v_2 in pairs(_ui_animations) do
		UIAnimation.update(v_2, arg_11_1)

		if not UIAnimation.completed(v_2) then
			_ui_animations[k_2] = nil
		end
	end
end

StartGameWindowVersusMissionSelection._handle_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local window_input_service = self._parent:window_input_service()

	if not window_input_service:get("move_right_hold_continuous") then
		self:_update_selection(0, 1)
	elseif not window_input_service:get("move_left_hold_continuous") then
		self:_update_selection(0, -1)
	end

	if not window_input_service:get("move_up_hold_continuous") then
		self:_update_selection(-1, 0)
	elseif not window_input_service:get("move_down_hold_continuous") then
		self:_update_selection(1, 0)
	end

	if not window_input_service:get("confirm_press", true) then
		local _current_grid_entries = self._current_grid_entries
		local _selected_grid_index = self._selected_grid_index
		local var_12_3 = _selected_grid_index[1]
		local var_12_4 = _selected_grid_index[2]
		local var_12_5 = _current_grid_entries[var_12_3][var_12_4]

		if not var_12_5.content.is_disabled then
			local level_id = var_12_5.content.level_settings.level_id

			self._parent:set_selected_level_id(level_id)
			self._parent:set_layout_by_name(self._return_layout_name)

			local matchmaking = Managers.matchmaking

			if not matchmaking:is_in_versus_custom_game_lobby() then
				matchmaking:set_selected_level(level_id)
			end

			return
		end
	end

	for k, v in pairs(self._current_entries) do
		local level_settings = v.content.level_settings

		if not level_settings then
			if not UIUtils.is_button_hover_enter(v) then
				local index = v.content.index

				self:_set_selection(index[1], index[2])
			elseif not UIUtils.is_button_pressed(v) then
				local level_id_2 = level_settings.level_id

				self._parent:set_selected_level_id(level_id_2)
				self._parent:set_layout_by_name(self._return_layout_name)

				local matchmaking_2 = Managers.matchmaking

				if not matchmaking_2:is_in_versus_custom_game_lobby() then
					matchmaking_2:set_selected_level(level_id_2)
				end

				break
			end
		end
	end
end

StartGameWindowVersusMissionSelection._set_selection = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _selected_grid_index = self._selected_grid_index

	_selected_grid_index[1] = arg_13_1
	_selected_grid_index[2] = arg_13_2

	self:_populate_description()
end

StartGameWindowVersusMissionSelection._update_selection = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _current_grid_entries = self._current_grid_entries
	local _selected_grid_index = self._selected_grid_index

	if math.abs(arg_14_1) > 0 then
		local clamp = math.clamp(_selected_grid_index[1] + arg_14_1, 1, table.size(_current_grid_entries))
		local size = table.size(_current_grid_entries[clamp])

		_selected_grid_index[2], _selected_grid_index[1] = math.min(_selected_grid_index[2], size), clamp
	elseif math.abs(arg_14_2) > 0 then
		local var_14_4 = _selected_grid_index[1]

		_selected_grid_index[2] = math.clamp(_selected_grid_index[2] + arg_14_2, 1, table.size(_current_grid_entries[var_14_4]))
	end

	self:_handle_input_desc()
	self:_populate_description()
end

StartGameWindowVersusMissionSelection._handle_input_desc = function (self)
	-- function 15
	local _current_grid_entries = self._current_grid_entries
	local _selected_grid_index = self._selected_grid_index
	local var_15_2 = _selected_grid_index[1]
	local var_15_3 = _selected_grid_index[2]
	local var_15_4 = _current_grid_entries[var_15_2][var_15_3]

	if not var_15_4.content.dlc_is_locked then
		self._parent:set_input_description(nil)

		return
	end

	local level_id = var_15_4.content.level_settings.level_id

	do return end

	if self._level_preferences[1][level_id] or not self._level_preferences[2][level_id] then
		-- Nothing
	end
end

StartGameWindowVersusMissionSelection._populate_description = function (self)
	-- function 16
	local _selected_grid_index = self._selected_grid_index
	local var_16_1 = _selected_grid_index[1]
	local var_16_2 = _selected_grid_index[2]
	local var_16_3 = self._current_grid_entries[var_16_1][var_16_2]
	local level_settings = var_16_3.content.level_settings
	local str = ""
	local str_2 = ""
	local str_3 = "map_frame_00"
	local flag = false
	local flag_2 = true
	local str_4 = ""
	local _widgets_by_name = self._widgets_by_name
	local content = _widgets_by_name.selected_level.content

	if not level_settings then
		local _statistics_db = self._statistics_db
		local _stats_id = self._stats_id
		local level_id = level_settings.level_id
		local level_image = level_settings.level_image
		local boss_level = level_settings.boss_level
		local display_name = level_settings.display_name

		str_2 = level_settings.description_text

		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(_statistics_db, _stats_id, level_id)

		str_3 = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_level_difficulty_index)
		flag_2 = var_16_3.content.is_disabled or level_id == "any" or not LevelUnlockUtils.level_unlocked(_statistics_db, _stats_id, level_id)

		if not flag_2 then
			local dlc_name = level_settings.dlc_name

			if not (not dlc_name and Managers.unlock:is_dlc_unlocked(dlc_name)) then
				str_4 = Localize("dlc1_2_dlc_level_locked_tooltip")
			end
		end

		content.icon = level_image
		content.boss_level = boss_level
		str = Localize(display_name)
		str_2 = not str_2 and Localize(str_2)
		flag = true
	end

	content.frame = str_3
	content.locked = flag_2
	content.visible = flag
	content.button_hotspot.disable_button = true
	_widgets_by_name.helper_text.content.visible = not flag
	_widgets_by_name.level_title_divider.content.visible = flag
	_widgets_by_name.level_title.content.text = str
	_widgets_by_name.description_text.content.text = str_2
	_widgets_by_name.description_text.content.visible = not not str_2
	_widgets_by_name.locked_text.content.text = str_4
end

StartGameWindowVersusMissionSelection._draw = function (self, arg_17_1)
	-- function 17
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_17_1, nil, self._render_settings)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._global_entries)
	UIRenderer.end_pass(_ui_top_renderer)
end
