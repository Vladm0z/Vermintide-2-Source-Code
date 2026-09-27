-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mission_selection_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mission_selection_console_definitions")
local widgets = var_0_0.widgets
local act_widgets = var_0_0.act_widgets
local node_widgets = var_0_0.node_widgets
local end_act_widget = var_0_0.end_act_widget
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

local function fn(self, arg_1_1)
	-- function 1
	return self.act_presentation_order < arg_1_1.act_presentation_order
end

local str = "confirm_press"

StartGameWindowMissionSelectionConsole = class(StartGameWindowMissionSelectionConsole)
StartGameWindowMissionSelectionConsole.NAME = "StartGameWindowMissionSelectionConsole"

StartGameWindowMissionSelectionConsole.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[StartGameWindow] Enter Substate StartGameWindowMissionSelectionConsole")

	self._parent = arg_2_1.parent

	local ingame_ui_context = arg_2_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._stats_id = Managers.player:local_player():stats_id()
	self._animations = {}

	self:_create_ui_elements(arg_2_1, arg_2_2)

	local get_selected_area_name = self._parent:get_selected_area_name()

	self:_set_presentation_info()
	self:_setup_levels_by_area(get_selected_area_name)
	self:_setup_grid_navigation()
	self:_start_transition_animation("on_enter")
end

StartGameWindowMissionSelectionConsole._start_transition_animation = function (self, arg_3_1)
	-- function 3
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_3_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_3_1] = start_animation
end

StartGameWindowMissionSelectionConsole._create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self._ui_scenegraph = init_scenegraph
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)
	self._node_widgets, self._node_widgets_by_name = UIUtils.create_widgets(node_widgets)
	self._act_widgets, self._act_widgets_by_name = UIUtils.create_widgets(act_widgets)
	self._end_act_widget = UIWidget.init(end_act_widget)
	self._loot_object_widgets = {}

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end
end

StartGameWindowMissionSelectionConsole._setup_levels_by_area = function (self, arg_5_1)
	-- function 5
	local var_5_0 = AreaSettings[arg_5_1]
	local acts = var_5_0.acts

	self._is_dlc = var_5_0.dlc_name ~= nil

	self:_setup_level_acts(acts)
	self:_present_act_levels()
	self:_update_level_option()
end

StartGameWindowMissionSelectionConsole._setup_level_acts = function (self, arg_6_1)
	-- function 6
	local tbl = {}
	local num = 0

	for k, v in pairs(UnlockableLevels) do
		if not table.find(NoneActLevels, v) then
			local var_6_2 = LevelSettings[v]
			local act = var_6_2.act

			if not table.find(arg_6_1, act) then
				if not tbl[act] then
					tbl[act] = {}
				end

				local var_6_4 = tbl[act]

				var_6_4[#var_6_4 + 1] = var_6_2
				num = num + 1
			end
		end
	end

	for k_2, v_2 in pairs(tbl) do
		table.sort(v_2, fn)
	end

	self._levels_by_act = tbl
end

StartGameWindowMissionSelectionConsole._verify_act = function (arg_7_0, arg_7_1)
	-- function 7
	if not arg_7_1 then
		return false
	end

	for i = 1, #MapPresentationActs do
		if arg_7_1 == MapPresentationActs[i] then
			return true
		end
	end

	return false
end

StartGameWindowMissionSelectionConsole._present_act_levels = function (self, arg_8_1)
	-- function 8
	local _node_widgets = self._node_widgets
	local _statistics_db = self._statistics_db
	local _stats_id = self._stats_id
	local tbl = {}
	local tbl_2 = {}
	local num = 190
	local num_2 = 190
	local num_3 = 4
	local _levels_by_act = self._levels_by_act

	for k, v in pairs(_levels_by_act) do
		if not (not self:_verify_act(k) and not arg_8_1 and arg_8_1 ~= k) then
			local var_8_9 = ActSettings[k]
			local sorting = var_8_9.sorting
			local num_4 = (sorting - 1) % num_3 + 1
			local flag = num_3 < sorting
			local num_5 = 0
			local var_8_14

			if not flag then
				num_5 = -num_2 + (num_3 - num_4) * num_2
				var_8_14 = self._act_widgets[num_4]
			else
				var_8_14 = self._end_act_widget
			end

			tbl_2[#tbl_2 + 1] = var_8_14
			var_8_14.offset[2] = num_5

			local display_name = var_8_9.display_name

			var_8_14.content.background = var_8_9.banner_texture

			local content = var_8_14.content
			local var_8_17

			if not display_name then
				var_8_17 = Localize(display_name)

				if not var_8_17 then
					-- Nothing
				end
			end

			var_8_17 = ""

			::label_8_0::

			content.text = var_8_17

			local get_text_width = UIUtils.get_text_width(self._ui_renderer, var_8_14.style.text, var_8_14.content.text)
			local count = #v
			local num_6 = get_text_width - 50
			local num_7 = 0

			for k_2 = 1, count do
				local var_8_22 = v[k_2]

				if not flag then
					num_6 = num * 4
				end

				local num_8 = #tbl + 1
				local var_8_24 = _node_widgets[num_8]
				local content_2 = var_8_24.content
				local level_id = var_8_22.level_id
				local boss_level = var_8_22.boss_level
				local display_name_2 = var_8_22.display_name

				content_2.text = Localize(display_name_2)

				local level_unlocked = LevelUnlockUtils.level_unlocked(_statistics_db, _stats_id, level_id)
				local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(_statistics_db, _stats_id, level_id)

				content_2.frame = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_level_difficulty_index)
				content_2.locked = not level_unlocked
				content_2.act_key = k
				content_2.level_key = level_id

				local level_image = var_8_22.level_image

				if not level_image then
					content_2.icon = level_image
				else
					content_2.icon = "icons_placeholder"
				end

				content_2.level_data = var_8_22
				content_2.boss_level = boss_level

				local offset = var_8_24.offset

				offset[1] = num_6
				offset[2] = num_5 + num_7
				tbl[num_8] = var_8_24
				num_6 = num_6 + num
			end
		end
	end

	self._active_node_widgets = tbl
	self._active_act_widgets = tbl_2
end

StartGameWindowMissionSelectionConsole._select_level = function (self, arg_9_1)
	-- function 9
	local get_required_completed_levels = LevelUnlockUtils.get_required_completed_levels(self._statistics_db, self._stats_id, arg_9_1)
	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i = 1, #_active_node_widgets do
			local var_9_2 = _active_node_widgets[i]
			local content = var_9_2.content
			local level_data = content.level_data
			local flag = level_data.level_id == arg_9_1

			var_9_2.content.button_hotspot.is_selected = flag
			content.unlock_guidance = get_required_completed_levels[level_data.level_id]
		end
	end

	self._selected_level_id = arg_9_1

	self:_set_presentation_info(arg_9_1)
end

StartGameWindowMissionSelectionConsole._set_presentation_info = function (self, arg_10_1)
	-- function 10
	local str = ""
	local str_2 = ""
	local str_3 = "map_frame_00"
	local flag = false
	local str_4 = ""
	local _widgets_by_name = self._widgets_by_name
	local content = _widgets_by_name.selected_level.content

	if not arg_10_1 then
		local _statistics_db = self._statistics_db
		local _stats_id = self._stats_id
		local var_10_9 = LevelSettings[arg_10_1]
		local level_image = var_10_9.level_image
		local boss_level = var_10_9.boss_level
		local display_name = var_10_9.display_name

		str_2 = var_10_9.description_text

		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(_statistics_db, _stats_id, arg_10_1)

		str_3 = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_level_difficulty_index)

		if not not LevelUnlockUtils.level_unlocked(_statistics_db, _stats_id, arg_10_1) then
			self._parent:set_input_description("select_mission")
		else
			self._parent:set_input_description("select_mission_confirm")
		end

		content.icon = level_image
		content.boss_level = boss_level
		str = Localize(display_name)
		str_2 = Localize(str_2)
		flag = true

		self:_setup_mission_data(var_10_9)
	end

	content.frame = str_3
	content.locked = not flag
	content.visible = flag
	content.button_hotspot.disable_button = true
	_widgets_by_name.helper_text.content.visible = not flag
	_widgets_by_name.level_title.content.text = str
	_widgets_by_name.description_text.content.text = str_2
	_widgets_by_name.locked_text.content.text = str_4
end

StartGameWindowMissionSelectionConsole._setup_mission_data = function (self, arg_11_1)
	-- function 11
	local loot_objectives = arg_11_1.loot_objectives
	local _widgets_by_name = self._widgets_by_name
	local flag = not not loot_objectives

	_widgets_by_name.hero_tabs.content.visible = flag
	_widgets_by_name.heros_completed_text.content.visible = flag

	if not loot_objectives then
		return
	end

	local _ui_renderer = self._ui_renderer
	local create_loot_widget = var_0_0.create_loot_widget
	local _loot_object_widgets = self._loot_object_widgets
	local tbl = {}

	table.clear(_loot_object_widgets)

	local num = 2
	local num_2 = 150
	local num_3 = 25
	local num_4 = 0
	local num_5 = 0
	local num_6 = 0
	local num_7 = 0
	local mission_settings = var_0_0.mission_settings

	for i, v in ipairs(mission_settings) do
		local key = v.key
		local var_11_16

		if not v.total_amount_func then
			var_11_16 = self[v.total_amount_func](self, arg_11_1)

			if not var_11_16 then
				-- Nothing
			end
		end

		var_11_16 = loot_objectives[key]

		::label_11_0::

		if not var_11_16 then
			local stat_name = v.stat_name
			local widget_name = v.widget_name
			local texture = v.texture
			local var_11_20 = Localize(v.title_text)
			local var_11_21 = create_loot_widget(texture, var_11_20)
			local var_11_22 = UIWidget.init(var_11_21)
			local tbl_2 = {
				name = key,
				total_amount = not (var_11_16 > 0) or var_11_16,
				stat_name = stat_name,
				widget = var_11_22
			}
			local size = UIAtlasHelper.get_atlas_settings_by_texture_name(texture).size
			local text = var_11_22.style.text
			local floor = math.floor(num_7 / num)

			if num_7 % num > 0 then
				num_4 = num_4 + (size[1] + num_2 + num_3)
			else
				num_4 = 0
			end

			local offset = var_11_22.offset

			offset[1] = num_4
			offset[2] = -(floor - 1) * size[2]
			tbl[key] = tbl_2
			_loot_object_widgets[widget_name] = var_11_22
			num_7 = num_7 + 1
		end
	end

	if num_7 > 0 then
		self:_sync_missions(tbl, arg_11_1)
	end

	self:_sync_completed_difficulty(num_7, num_2 + num_3, arg_11_1)
	self:_sync_hero_completion(arg_11_1)
end

local tbl = {}

StartGameWindowMissionSelectionConsole._sync_completed_difficulty = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local level_id = arg_12_3.level_id
	local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(self._statistics_db, self._stats_id, level_id)

	if completed_level_difficulty_index == 0 then
		return
	end

	local var_12_2 = DefaultDifficulties[completed_level_difficulty_index]
	local var_12_3 = DifficultySettings[var_12_2]
	local display_name = var_12_3.display_name
	local var_12_5 = Localize("map_difficulty_setting")
	local display_image = var_12_3.display_image
	local create_difficulty_widget = var_0_0.create_difficulty_widget(display_image, var_12_5, display_name)
	local var_12_8 = UIWidget.init(create_difficulty_widget)
	local text = var_12_8.style.text
	local num = UIUtils.get_text_width(self._ui_renderer, text, var_12_5) + 20
	local tbl = {
		80,
		90
	}
	local num_2 = 0
	local num_3 = 0
	local num_4 = 2
	local num_5 = 20
	local floor = math.floor(arg_12_1 / num_4)

	if arg_12_1 % num_4 > 0 then
		num_5 = num_5 + (tbl[1] + arg_12_2 - 20)
	else
		num_5 = 0
	end

	var_12_8.content.completed_difficulty_index = completed_level_difficulty_index

	local offset = var_12_8.offset

	offset[1] = num_5
	offset[2] = -(floor - 1) * tbl[2]
	self._loot_object_widgets.difficulty = var_12_8
end

StartGameWindowMissionSelectionConsole._calculate_paint_scrap_amount = function (arg_13_0, arg_13_1)
	-- function 13
	local GameModeSettings = GameModeSettings
	local game_mode = arg_13_1.game_mode

	game_mode = game_mode or "adventure"

	if not GameModeSettings[game_mode].has_art_scraps then
		return 0
	end

	local level_id = arg_13_1.level_id

	table.clear(tbl)

	local get_entries_from_category = Managers.state.achievement:get_entries_from_category("achv_menu_levels_gecko_category_title")
	local count = #QuestSettings.scrap_count_level
	local num = 0

	for i = 1, count do
		local str = "gecko_scraps_" .. level_id .. "_" .. i

		if not table.find(get_entries_from_category, str) then
			num = QuestSettings.scrap_count_level[i]
		end
	end

	return num
end

local tbl_2 = {}

StartGameWindowMissionSelectionConsole._sync_hero_completion = function (self, arg_14_1)
	-- function 14
	local level_id = arg_14_1.level_id
	local hero_tabs = self._widgets_by_name.hero_tabs
	local content = hero_tabs.content
	local style = hero_tabs.style

	for i = 1, #ProfilePriority do
		local var_14_4 = ProfilePriority[i]
		local var_14_5 = SPProfiles[var_14_4]
		local display_name = var_14_5.display_name
		local get_persistent_stat = self._statistics_db:get_persistent_stat(self._stats_id, "completed_levels_" .. display_name, level_id)

		if not var_0_0.use_career_completion then
			local _profile_difficulty_index_completed, var_14_9 = self:_profile_difficulty_index_completed(var_14_5, level_id)
			local str = "icon_data_" .. i
			local str_2 = "icon_" .. i
			local str_3 = str_2 .. "_disabled"
			local str_4 = "frame_" .. i

			content[str][str_4] = "map_frame_0" .. _profile_difficulty_index_completed
			content[str][str_2] = var_14_9.picking_image
			content[str][str_3] = var_14_9.picking_image
			content[str].icon_disabled = not (get_persistent_stat > 0)

			local var_14_14 = style[str_3]
			local default_color

			if get_persistent_stat > 0 then
				default_color = var_14_14.default_color

				if not default_color then
					-- Nothing
				end
			end

			default_color = var_14_14.disabled_color

			::label_14_0::

			var_14_14.color = default_color
		else
			content["hotspot_" .. i].disable_button = not (get_persistent_stat > 0)

			local var_14_16 = style["icon_" .. i .. "_saturated"]
			local default_color_2

			if get_persistent_stat > 0 then
				default_color_2 = var_14_16.default_color

				if not default_color_2 then
					-- Nothing
				end
			end

			default_color_2 = var_14_16.disabled_color

			::label_14_1::

			var_14_16.color = default_color_2
		end
	end
end

StartGameWindowMissionSelectionConsole._profile_difficulty_index_completed = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _statistics_db = self._statistics_db
	local _stats_id = self._stats_id
	local careers = arg_15_1.careers
	local var_15_3 = careers[1]
	local num = 0

	for i = #DefaultDifficulties, 1, -1 do
		local var_15_5 = DefaultDifficulties[i]

		for j = 1, #careers do
			local display_name = careers[j].display_name

			if _statistics_db:get_persistent_stat(_stats_id, "completed_career_levels", display_name, arg_15_2, var_15_5) > 0 then
				return i, CareerSettings[display_name]
			end
		end
	end

	return num, var_15_3
end

StartGameWindowMissionSelectionConsole._sync_missions = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not arg_16_1 then
		return
	end

	local level_id = arg_16_2.level_id

	for k, v in pairs(arg_16_1) do
		local stat_name = v.stat_name
		local get_persistent_stat = self._statistics_db:get_persistent_stat(self._stats_id, stat_name, level_id)
		local amount = v.amount
		local total_amount = v.total_amount
		local widget = v.widget

		if amount ~= get_persistent_stat then
			v.previous_amount = amount or 0
			v.amount = get_persistent_stat

			local content = widget.content
			local counter_text = widget.style.counter_text

			content.amount = get_persistent_stat
			content.total_amount = total_amount or 0

			if not total_amount then
				content.counter_text = tostring(get_persistent_stat) .. "/" .. tostring(total_amount)

				local completed_color

				if total_amount <= get_persistent_stat then
					completed_color = counter_text.completed_color

					if not completed_color then
						-- Nothing
					end
				end

				completed_color = counter_text.default_color

				::label_16_0::

				counter_text.text_color = completed_color
			else
				content.counter_text = "x" .. tostring(get_persistent_stat)
				counter_text.text_color = counter_text.completed_color
			end
		end
	end
end

StartGameWindowMissionSelectionConsole._setup_grid_navigation = function (self)
	-- function 17
	local tbl = {}
	local _levels_by_act = self._levels_by_act

	for k, v in pairs(_levels_by_act) do
		if not k then
			local tbl_2 = {}

			for k_2 = 1, #v do
				tbl_2[k_2] = v[k_2].level_id
			end

			tbl[ActSettings[k].sorting] = tbl_2
		end
	end

	self._navigation_grid = tbl

	local _find_level_location_in_grid, var_17_4 = self:_find_level_location_in_grid(self._selected_level_id)

	self._current_row = _find_level_location_in_grid
	self._current_column = var_17_4
end

StartGameWindowMissionSelectionConsole._find_level_location_in_grid = function (self, arg_18_1)
	-- function 18
	local _navigation_grid = self._navigation_grid
	local num = 0

	for k, v in pairs(_navigation_grid) do
		if num < k then
			num = k
		end
	end

	local var_18_2
	local var_18_3

	if not arg_18_1 then
		for k_2 = 1, num do
			local var_18_4 = _navigation_grid[k_2]

			if not var_18_4 then
				local count = #var_18_4

				for l = 1, count do
					if var_18_4[l] == arg_18_1 then
						var_18_2 = k_2
						var_18_3 = l

						break
					end
				end

				if not var_18_2 and not var_18_3 then
					break
				end
			end
		end
	else
		var_18_2, var_18_3 = 1, 1
	end

	if not IS_XB1 then
		-- Nothing
	end

	if not (not var_18_2 and var_18_3) then
		for i4 = 1, num do
			if not _navigation_grid[i4] then
				var_18_2 = i4
				var_18_3 = 1

				break
			end
		end

		self._selected_level_id = nil
	end

	fassert(not var_18_2 and var_18_3, "level_id %s does not exist in navigation grid", arg_18_1)

	return var_18_2, var_18_3
end

StartGameWindowMissionSelectionConsole.on_exit = function (self, arg_19_1)
	-- function 19
	print("[StartGameWindow] Exit Substate StartGameWindowMissionSelectionConsole")

	self._ui_animator = nil

	self._parent:set_input_description(nil)
end

StartGameWindowMissionSelectionConsole.update = function (self, arg_20_1, arg_20_2)
	-- function 20
	self:_update_animations(arg_20_1)
	self:_handle_input(arg_20_1, arg_20_2)
	self:_draw(arg_20_1)
end

StartGameWindowMissionSelectionConsole.post_update = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	return
end

StartGameWindowMissionSelectionConsole._update_animations = function (self, arg_22_1)
	-- function 22
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_22_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _node_widgets = self._node_widgets

	for k_2 = 1, #_node_widgets do
		local var_22_3 = _node_widgets[k_2]

		self:_animate_node_widget(var_22_3, arg_22_1)
	end
end

StartGameWindowMissionSelectionConsole._update_level_option = function (self)
	-- function 23
	local get_selected_level_id = self._parent:get_selected_level_id()

	if not (get_selected_level_id ~= self._selected_level_id or get_selected_level_id) then
		if not get_selected_level_id and not self:_is_level_presented(get_selected_level_id) then
			self:_select_level(get_selected_level_id)
		elseif not self._selected_level_id then
			local _get_first_level_id = self:_get_first_level_id()

			self:_select_level(_get_first_level_id)
		end
	end
end

StartGameWindowMissionSelectionConsole._is_level_presented = function (self, arg_24_1)
	-- function 24
	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i = 1, #_active_node_widgets do
			if _active_node_widgets[i].content.level_data.level_id == arg_24_1 then
				return true
			end
		end
	end

	return false
end

StartGameWindowMissionSelectionConsole._get_first_level_id = function (self)
	-- function 25
	local get_selected_area_name = self._parent:get_selected_area_name()
	local var_25_1 = AreaSettings[get_selected_area_name].acts[1]

	return self._levels_by_act[var_25_1][1].level_id
end

StartGameWindowMissionSelectionConsole._update_selection_from_grid = function (self)
	-- function 26
	local _current_row = self._current_row
	local _current_column = self._current_column
	local var_26_2 = self._navigation_grid[_current_row][_current_column]

	fassert(var_26_2, "No level id at %s-%s", tostring(_current_row), tostring(_current_column))
	self:_select_level(var_26_2)
	self:_play_sound("play_gui_lobby_button_02_mission_act_click")
end

StartGameWindowMissionSelectionConsole._update_grid_row = function (self, arg_27_1)
	-- function 27
	local count = #self._navigation_grid

	self._current_row = math.clamp(arg_27_1, 1, count)

	self:_update_grid_column(self._current_column)
	self:_update_selection_from_grid()
end

StartGameWindowMissionSelectionConsole._update_grid_column = function (self, arg_28_1)
	-- function 28
	local count = #self._navigation_grid[self._current_row]

	self._current_column = math.clamp(arg_28_1, 1, count)

	self:_update_selection_from_grid()
end

StartGameWindowMissionSelectionConsole._update_grid_navigation = function (self, arg_29_1, arg_29_2)
	-- function 29
	local _find_row = self:_find_row(arg_29_1)

	if _find_row ~= self._current_row then
		self:_update_grid_row(_find_row)
	end

	local _find_column = self:_find_column(arg_29_2)

	if _find_column ~= self._current_column then
		self:_update_grid_column(_find_column)
	end
end

StartGameWindowMissionSelectionConsole._find_row = function (self, arg_30_1)
	-- function 30
	if arg_30_1 == 0 then
		return self._current_row
	end

	local _current_row = self._current_row
	local _current_row_2 = self._current_row
	local _navigation_grid = self._navigation_grid

	if arg_30_1 < 0 then
		for k, v in pairs(_navigation_grid) do
			if k < _current_row_2 then
				_current_row = k
			else
				break
			end
		end
	else
		for k_2, v_2 in pairs(_navigation_grid) do
			if _current_row_2 < k_2 then
				_current_row = k_2

				break
			end
		end
	end

	return _current_row
end

StartGameWindowMissionSelectionConsole._find_column = function (self, arg_31_1)
	-- function 31
	if arg_31_1 == 0 then
		return self._current_column
	end

	local _current_column = self._current_column
	local _current_column_2 = self._current_column
	local var_31_2 = self._navigation_grid[self._current_row]

	if arg_31_1 < 0 then
		for k, v in pairs(var_31_2) do
			if k < _current_column_2 then
				_current_column = k
			else
				break
			end
		end
	else
		for k_2, v_2 in pairs(var_31_2) do
			if _current_column_2 < k_2 then
				_current_column = k_2

				break
			end
		end
	end

	return _current_column
end

StartGameWindowMissionSelectionConsole._level_is_unlocked = function (self, arg_32_1)
	-- function 32
	local _statistics_db = self._statistics_db
	local _stats_id = self._stats_id

	return LevelUnlockUtils.level_unlocked(_statistics_db, _stats_id, arg_32_1)
end

StartGameWindowMissionSelectionConsole._handle_input = function (self, arg_33_1, arg_33_2)
	-- function 33
	local _parent = self._parent
	local window_input_service = _parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("mouse")

	if not is_device_active then
		if not window_input_service:get("move_down_hold_continuous") then
			self:_update_grid_navigation(1, 0)
		elseif not window_input_service:get("move_up_hold_continuous") then
			self:_update_grid_navigation(-1, 0)
		elseif not window_input_service:get("move_right_hold_continuous") then
			self:_update_grid_navigation(0, 1)
		elseif not window_input_service:get("move_left_hold_continuous") then
			self:_update_grid_navigation(0, -1)
		end
	end

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i = 1, #_active_node_widgets do
			local var_33_4 = _active_node_widgets[i]
			local level_id = var_33_4.content.level_data.level_id

			if not (not UIUtils.is_button_hover_enter(var_33_4) and self._selected_level_id == level_id) then
				self:_play_sound("play_gui_lobby_button_02_mission_act_click")
				self:_select_level(level_id)
			end

			if not UIUtils.is_button_pressed(var_33_4) then
				_parent:set_selected_level_id(level_id)

				local get_selected_game_mode_layout_name = _parent:get_selected_game_mode_layout_name()

				_parent:set_layout_by_name(get_selected_game_mode_layout_name)

				return
			end
		end
	end

	if not (not not is_device_active or window_input_service:get(str, true)) and not self:_level_is_unlocked(self._selected_level_id) then
		self:_play_sound("play_gui_lobby_button_02_mission_select")
		_parent:set_selected_level_id(self._selected_level_id)

		local get_selected_game_mode_layout_name_2 = _parent:get_selected_game_mode_layout_name()

		_parent:set_layout_by_name(get_selected_game_mode_layout_name_2)
	end
end

StartGameWindowMissionSelectionConsole._draw = function (self, arg_34_1)
	-- function 34
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_34_1, nil, self._render_settings)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._loot_object_widgets)

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		UIRenderer.draw_all_widgets(_ui_top_renderer, _active_node_widgets)
	end

	local _active_act_widgets = self._active_act_widgets

	if not _active_act_widgets then
		UIRenderer.draw_all_widgets(_ui_top_renderer, _active_act_widgets)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowMissionSelectionConsole._play_sound = function (self, arg_35_1)
	-- function 35
	self._parent:play_sound(arg_35_1)
end

StartGameWindowMissionSelectionConsole._animate_node_widget = function (arg_36_0, arg_36_1, arg_36_2)
	-- function 36
	local content = arg_36_1.content
	local button_hotspot = content.button_hotspot
	local is_selected = button_hotspot.is_selected
	local selected_progress = button_hotspot.selected_progress

	selected_progress = selected_progress or 0

	local num = 9

	if not is_selected then
		selected_progress = math.min(selected_progress + num * arg_36_2, 1)
	else
		selected_progress = math.max(selected_progress - num * arg_36_2, 0)
	end

	local unlock_guidance = content.unlock_guidance
	local unlock_guidance_progress = content.unlock_guidance_progress

	unlock_guidance_progress = unlock_guidance_progress or 0

	local num_2 = 2

	if not unlock_guidance then
		unlock_guidance_progress = math.min(unlock_guidance_progress + arg_36_2 * num_2, 1)
	else
		unlock_guidance_progress = math.max(unlock_guidance_progress - arg_36_2 * num_2, 0)
	end

	local style = arg_36_1.style

	style.icon_glow.color[1] = 255 * selected_progress

	local max = math.max(math.lerp(-2.5, 1, unlock_guidance_progress), 0)

	style.icon_unlock_guidance_glow.color[1] = 255 * max
	button_hotspot.selected_progress = selected_progress
	content.unlock_guidance_progress = unlock_guidance_progress
end
