-- chunkname: @scripts/ui/views/lobby_browser_console_ui.lua

require("foundation/scripts/util/local_require")
require("scripts/managers/telemetry/iso_country_names")
require("scripts/settings/level_settings")

local var_0_0 = local_require("scripts/ui/views/lobby_browser_console_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local base_widget_definition = var_0_0.base_widget_definition
local adventure_details_widget_definition = var_0_0.adventure_details_widget_definition
local weave_details_widget_definition = var_0_0.weave_details_widget_definition
local deus_details_widget_definition = var_0_0.deus_details_widget_definition
local versus_details_widget_definition = var_0_0.versus_details_widget_definition
local animation_definitions = var_0_0.animation_definitions

LobbyBrowserConsoleUI = class(LobbyBrowserConsoleUI)

local tbl = {
	deus = "area_selection_morris_name",
	adventure = "area_selection_campaign",
	weave = "menu_weave_area_no_wom_title",
	versus = "area_selection_carousel_name",
	any = "lobby_browser_mission"
}

LobbyBrowserConsoleUI.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	self._ingame_ui_context = arg_1_2
	self._game_mode_data = arg_1_3
	self._show_lobby_data_table = arg_1_4
	self._distance_data_table = arg_1_5
	self._parent = arg_1_1
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._details_type = "adventure"
	self._ui_renderer = arg_1_2.ui_top_renderer
	self._input_manager = arg_1_2.input_manager
	self._world_manager = arg_1_2.world_manager
	self._world = self._world_manager:world("level_world")
	self._wwise_world = Managers.world:wwise_world(self._world)

	self:_create_ui_elements()
	self:_start_transition_animation("on_enter")
end

LobbyBrowserConsoleUI._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

LobbyBrowserConsoleUI._create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets = {}
	self._animations = {}
	self._lobby_entry_widgets = {}
	self._empty_lobby_entry_widgets = {}
	self._details_widgets = {}
	self._dynamic_details_widgets = {}
	self._ui_animations = {}
	self._selected_lobby_index = 1
	self._mouse_selected_index = 1
	self._visible_list_index = 1
	self._hold_up_timer = 0
	self._hold_down_timer = 0
	self._hold_up_list_timer = 0
	self._hold_down_list_timer = 0
	self._wanted_pos = 0
	self._base_pos_y = nil
	self._list_base_pos_y = nil
	self._dot_timer = 0
	self._details_filled = false

	UIUtils.create_widgets(base_widget_definition, false, self._widgets)

	local tbl = {}

	UIUtils.create_widgets(adventure_details_widget_definition, false, tbl)

	self._details_widgets.adventure = tbl
	self._dynamic_details_widgets.adventure = {}

	local tbl_2 = {}

	UIUtils.create_widgets(deus_details_widget_definition, false, tbl_2)

	self._details_widgets.deus = tbl_2
	self._dynamic_details_widgets.deus = {}

	local tbl_3 = {}

	UIUtils.create_widgets(weave_details_widget_definition, false, tbl_3)

	self._details_widgets.weave = tbl_3
	self._dynamic_details_widgets.weave = {}

	local tbl_4 = {}

	UIUtils.create_widgets(versus_details_widget_definition, false, tbl_4)

	self._details_widgets.versus = tbl_4
	self._dynamic_details_widgets.versus = {}

	local var_3_4 = self
	local populate_lobby_list = self.populate_lobby_list
	local _lobbies = self._lobbies

	_lobbies = _lobbies or {}

	populate_lobby_list(var_3_4, _lobbies, false)
	self:_create_filters()
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

LobbyBrowserConsoleUI._create_filters = function (self)
	-- function 4
	self._game_type_filter_widgets = {}
	self._level_filter_widgets = {}
	self._difficulty_filter_widgets = {}
	self._lobby_filter_widgets = {}
	self._distance_filter_widgets = {}
	self._filter_functions = {
		{
			input_function = "_handle_game_type_filter_input",
			render_function = "_render_game_type_filter_list",
			input_function_mouse = "_handle_game_type_filter_input_mouse"
		},
		{
			input_function = "_handle_level_filter_input",
			render_function = "_render_level_filter_list",
			input_function_mouse = "_handle_level_filter_input_mouse"
		},
		{
			input_function = "_handle_difficulty_filter_input",
			render_function = "_render_difficulty_filter_list",
			input_function_mouse = "_handle_difficulty_filter_input_mouse"
		},
		{
			input_function = "_handle_lobby_filter_input",
			render_function = "_render_lobby_filter_list",
			input_function_mouse = "_handle_lobby_filter_input_mouse"
		},
		{
			input_function = "_handle_distance_filter_input",
			render_function = "_render_distance_filter_list",
			input_function_mouse = "_handle_distance_filter_input_mouse"
		}
	}

	self:setup_filter_entries()
end

LobbyBrowserConsoleUI.setup_filter_entries = function (self)
	-- function 5
	table.clear(self._game_type_filter_widgets)
	table.clear(self._level_filter_widgets)
	table.clear(self._difficulty_filter_widgets)
	table.clear(self._lobby_filter_widgets)
	table.clear(self._distance_filter_widgets)

	local _game_mode_data = self._game_mode_data
	local game_modes = _game_mode_data.game_modes
	local get_selected_game_mode_index = self._parent:get_selected_game_mode_index()

	get_selected_game_mode_index = get_selected_game_mode_index or game_modes.adventure

	local var_5_3 = _game_mode_data[get_selected_game_mode_index]
	local game_mode_key = var_5_3.game_mode_key
	local clone

	if not UnlockableLevelsByGameMode[game_mode_key] then
		clone = table.clone(UnlockableLevelsByGameMode[game_mode_key])

		if not clone then
			-- Nothing
		end
	end

	clone = {}

	::label_5_0::

	local levels = var_5_3.levels
	local difficulties = var_5_3.difficulties
	local element_settings = var_0_0.element_settings
	local num = -element_settings.filter_height - element_settings.spacing
	local create_game_type_filter_entry_func = var_0_0.create_game_type_filter_entry_func
	local var_5_11 = create_game_type_filter_entry_func("any", tbl.any, num)

	self._game_type_filter_widgets[#self._game_type_filter_widgets + 1] = UIWidget.init(var_5_11)

	for i, v in ipairs(game_modes) do
		if v ~= "any" then
			num = num - element_settings.filter_height - element_settings.spacing

			local var_5_12 = create_game_type_filter_entry_func(v, tbl[v], num)

			self._game_type_filter_widgets[#self._game_type_filter_widgets + 1] = UIWidget.init(var_5_12)
		end
	end

	local tbl_2 = {}
	local create_level_filter_entry_func = var_0_0.create_level_filter_entry_func

	for k, v_2 in pairs(levels) do
		if v_2 ~= "any" then
			local find = table.find(clone, v_2)

			table.remove(clone, find)

			local var_5_16 = create_level_filter_entry_func(v_2, true)

			tbl_2[#tbl_2 + 1] = UIWidget.init(var_5_16)
		end
	end

	local function fn(self, arg_6_1)
		-- function 6
		return string.gsub(string.lower(self.content.level_name_id), "the ", "") < string.gsub(string.lower(arg_6_1.content.level_name_id), "the ", "")
	end

	table.sort(tbl_2, fn)

	local tbl_3 = {}

	for k_2, v_3 in pairs(clone) do
		if not LevelSettings[v_3].ommit_from_lobby_browser then
			local var_5_19 = create_level_filter_entry_func(v_3, false)

			tbl_3[#tbl_3 + 1] = UIWidget.init(var_5_19)
		end
	end

	table.sort(tbl_3, fn)
	table.append(tbl_2, tbl_3)

	local var_5_20 = create_level_filter_entry_func("any", true)
	local var_5_21 = UIWidget.init(var_5_20)

	table.insert(tbl_2, 1, var_5_21)

	local num_2 = 0

	for i_2, v_4 in ipairs(tbl_2) do
		num_2 = num_2 - element_settings.filter_height - element_settings.spacing
		v_4.offset[2] = num_2
	end

	self._level_filter_widgets = tbl_2
	self._level_filter_scroller = UIWidget.init(var_0_0.create_level_filter_scroller_func(#tbl_2))

	local num_3 = -element_settings.filter_height - element_settings.spacing
	local create_difficulty_filter_entry_func = var_0_0.create_difficulty_filter_entry_func
	local var_5_25 = create_difficulty_filter_entry_func("any", num_3)

	self._difficulty_filter_widgets[#self._difficulty_filter_widgets + 1] = UIWidget.init(var_5_25)

	for k_3, v_5 in pairs(difficulties) do
		if v_5 ~= "any" then
			num_3 = num_3 - element_settings.filter_height - element_settings.spacing

			local var_5_26 = create_difficulty_filter_entry_func(v_5, num_3)

			self._difficulty_filter_widgets[#self._difficulty_filter_widgets + 1] = UIWidget.init(var_5_26)
		end
	end

	local _show_lobby_data_table = self._show_lobby_data_table
	local num_4 = 0
	local create_lobby_filter_entry_func = var_0_0.create_lobby_filter_entry_func

	for i_3, v_6 in ipairs(_show_lobby_data_table) do
		num_4 = num_4 - element_settings.filter_height - element_settings.spacing

		local var_5_30 = create_lobby_filter_entry_func(v_6, num_4)

		self._lobby_filter_widgets[#self._lobby_filter_widgets + 1] = UIWidget.init(var_5_30)
	end

	local _distance_data_table = self._distance_data_table
	local num_5 = 0
	local create_distance_filter_entry_func = var_0_0.create_distance_filter_entry_func

	for i_4, v_7 in ipairs(_distance_data_table) do
		num_5 = num_5 - element_settings.filter_height - element_settings.spacing

		local var_5_34 = create_distance_filter_entry_func(v_7, num_5)

		self._distance_filter_widgets[#self._distance_filter_widgets + 1] = UIWidget.init(var_5_34)
	end

	local content = self._widgets.filter_frame.content

	content.filter_hotspot_1.disable_button = #self._game_type_filter_widgets < 2
	content.filter_hotspot_2.disable_button = #self._level_filter_widgets < 2
	content.filter_hotspot_3.disable_button = #self._difficulty_filter_widgets < 2
	content.filter_hotspot_4.disable_button = #self._lobby_filter_widgets < 2
	content.filter_hotspot_5.disable_button = #self._distance_filter_widgets < 2
end

LobbyBrowserConsoleUI.update = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	self:_update_info_text(arg_7_1, arg_7_2, arg_7_3)
	self:_handle_input(arg_7_1, arg_7_2, arg_7_3)
	self:_handle_mouse_input(arg_7_1, arg_7_2, arg_7_3)
	self:_handle_input_description(arg_7_1, arg_7_2)
	self:_update_animations(arg_7_1, arg_7_2)
	self:_update_lobby_data(arg_7_1, arg_7_2)
	self:_draw(arg_7_1, arg_7_2)
end

LobbyBrowserConsoleUI._update_info_text = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local content = self._widgets.frame.content

	if not arg_8_3 then
		content.info_text_id, self._dot_timer = Localize("start_game_window_lobby_searching") .. string.rep(".", self._dot_timer % 4), self._dot_timer + arg_8_1 * 5
	else
		self._dot_timer = 0
		content.info_text_id = Localize("start_game_window_lobbies_found") .. ": " .. self._num_lobbies
	end
end

LobbyBrowserConsoleUI._update_animations = function (self, arg_9_1, arg_9_2)
	-- function 9
	self._ui_animator:update(arg_9_1)

	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_9_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	UIWidgetUtils.animate_default_button(self._widgets.join_button, arg_9_1)
	UIWidgetUtils.animate_default_button(self._widgets.refresh_button, arg_9_1)
end

local tbl_2 = {}
local tbl_3 = {}

LobbyBrowserConsoleUI._remove_invalid_lobbies = function (arg_10_0, arg_10_1)
	-- function 10
	table.clear(tbl_2)
	table.clear(tbl_3)

	local count = #arg_10_1
	local mission_ids = NetworkLookup.mission_ids
	local flag = false

	for i = 1, count do
		local flag_2 = false
		local var_10_4 = arg_10_1[i]

		if not var_10_4 then
			local selected_mission_id = var_10_4.selected_mission_id

			flag_2 = not selected_mission_id and mission_ids[selected_mission_id] == nil or flag_2

			local mission_id = var_10_4.mission_id

			flag_2 = not mission_id and mission_ids[mission_id] == nil or flag_2

			if not flag_2 then
				tbl_2[#tbl_2 + 1] = var_10_4
				tbl_3[var_10_4.id] = var_10_4
			end
		end
	end

	return tbl_2, tbl_3
end

LobbyBrowserConsoleUI.populate_lobby_list = function (self, arg_11_1, arg_11_2)
	-- function 11
	self._widgets.frame.content.timer = 0

	local _remove_invalid_lobbies, var_11_1 = self:_remove_invalid_lobbies(arg_11_1)
	local element_settings = var_0_0.element_settings
	local num = 0
	local _lobby_entry_widgets = self._lobby_entry_widgets

	table.clear(_lobby_entry_widgets)

	local create_lobby_entry_func = var_0_0.create_lobby_entry_func

	for k, v in pairs(_remove_invalid_lobbies) do
		local is_lobby_joinable, var_11_7 = self._parent:is_lobby_joinable(v)

		num = num - element_settings.height - element_settings.spacing

		local completed_level_difficulty_index = self._parent:completed_level_difficulty_index(v)
		local var_11_9 = create_lobby_entry_func(num, v, #_lobby_entry_widgets + 1, is_lobby_joinable, completed_level_difficulty_index)
		local var_11_10 = UIWidget.init(var_11_9)

		_lobby_entry_widgets[#_lobby_entry_widgets + 1] = var_11_10
	end

	self._lobbies = _remove_invalid_lobbies
	self._num_lobbies = #_lobby_entry_widgets

	self:_select_lobby(nil, self._selected_lobby_index)

	local frame = self._widgets.frame
	local content = frame.content
	local style = frame.style

	content.show_scroller = false

	local _empty_lobby_entry_widgets = self._empty_lobby_entry_widgets

	_empty_lobby_entry_widgets = _empty_lobby_entry_widgets or {}
	self._empty_lobby_entry_widgets = _empty_lobby_entry_widgets

	local _empty_lobby_entry_widgets_2 = self._empty_lobby_entry_widgets

	table.clear(_empty_lobby_entry_widgets_2)

	if self._num_lobbies < element_settings.num_visible_entries then
		local num_2 = element_settings.num_visible_entries - self._num_lobbies
		local create_empty_lobby_entry_func = var_0_0.create_empty_lobby_entry_func

		for k_2 = 1, num_2 do
			num = num - element_settings.height - element_settings.spacing

			local var_11_18 = create_empty_lobby_entry_func(num)
			local var_11_19 = UIWidget.init(var_11_18)

			_empty_lobby_entry_widgets_2[#_empty_lobby_entry_widgets_2 + 1] = var_11_19
		end
	elseif self._num_lobbies > element_settings.num_visible_entries then
		content.show_scroller = true
		style.scroller.texture_size[2] = math.min(-(element_settings.window_height / (self._num_lobbies / element_settings.num_visible_entries)), -30)

		local inner_scroller = style.inner_scroller

		inner_scroller.texture_size[2] = math.min(-(element_settings.window_height / (self._num_lobbies / element_settings.num_visible_entries)), -30) + 4
		style.inner_scroller_hotspot.area_size[2] = -inner_scroller.texture_size[2]
	end
end

LobbyBrowserConsoleUI._handle_input_description = function (self, arg_12_1, arg_12_2)
	-- function 12
	if not self._filter_active then
		self._parent:set_input_description("set_filter")
	elseif not self._selected_lobby_index then
		local var_12_0 = self._lobbies[self._selected_lobby_index]

		if not var_12_0 then
			local is_lobby_joinable, var_12_2 = self._parent:is_lobby_joinable(var_12_0)

			if not is_lobby_joinable then
				self._parent:set_input_description("join_filter")
			else
				self._parent:set_input_description("filter")
			end
		else
			self._parent:set_input_description("filter")
		end
	else
		self._parent:set_input_description("filter")
	end
end

LobbyBrowserConsoleUI._handle_input = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local _input_manager = self._input_manager
	local input_service = self._parent:input_service()

	self:_verify_selected_lobby_index()

	local element_settings = var_0_0.element_settings

	if not self._filter_active then
		if not self._current_active_filter then
			self[self._filter_functions[self._current_active_filter].input_function](self, input_service, element_settings, arg_13_1, arg_13_2)
		else
			self:_handle_filter_input(input_service, element_settings, arg_13_1, arg_13_2)
		end
	else
		self:_handle_browser_input(input_service, element_settings, arg_13_1, arg_13_2)
	end
end

LobbyBrowserConsoleUI._handle_mouse_input = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local _input_manager = self._input_manager
	local input_service = self._parent:input_service()

	self:_verify_selected_lobby_index()

	local element_settings = var_0_0.element_settings

	if not self._filter_active then
		if not self._current_active_filter then
			self[self._filter_functions[self._current_active_filter].input_function_mouse](self, input_service, element_settings, arg_14_1, arg_14_2)
		else
			self._widgets.frame.content.filter_active = false
			self._filter_active = false
			self._current_active_filter = false
			self._current_filter_index = 1
			self._filter_list_index = nil

			local content = self._widgets.filter_frame.content

			content.filter_selection = false
			content.filter_index = self._current_filter_index
		end
	else
		self:_handle_browser_input_mouse(input_service, element_settings, arg_14_1, arg_14_2)
	end
end

LobbyBrowserConsoleUI._verify_selected_lobby_index = function (self)
	-- function 15
	local _selected_lobby_index = self._selected_lobby_index

	self._selected_lobby_index = math.clamp(self._selected_lobby_index, 1, math.max(self._num_lobbies, 1))

	if _selected_lobby_index ~= self._selected_lobby_index then
		local element_settings = var_0_0.element_settings
		local num_visible_entries = element_settings.num_visible_entries
		local num = element_settings.height + element_settings.spacing
		local _base_pos_y = self._base_pos_y

		_base_pos_y = _base_pos_y or scenegraph_definition.lobby_entry_anchor.position[2]
		self._base_pos_y = _base_pos_y
		self._visible_list_index = math.max(math.min(num_visible_entries, self._num_lobbies), 1)

		local _base_pos_y_2 = self._base_pos_y

		if num_visible_entries < self._selected_lobby_index then
			_base_pos_y_2 = self._base_pos_y + self._selected_lobby_index * num
		end

		local _base_pos_y_3 = self._base_pos_y
		local num_2 = self._num_lobbies * num - num_visible_entries * num

		self._wanted_pos = math.clamp(_base_pos_y_2, self._base_pos_y, math.max(self._num_lobbies * num - num_visible_entries * num, 0))
		self._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.lobby_entry_anchor.position, 2, self._ui_scenegraph.lobby_entry_anchor.position[2], self._wanted_pos, 0.3, math.easeOutCubic)

		self:_select_lobby(_selected_lobby_index, self._selected_lobby_index, self._mouse_selected_index)

		local content = self._widgets.frame.content
		local num_3 = self._wanted_pos / (self._num_lobbies * num - num_visible_entries * num)

		num_3 = not self:_is_nan_or_inf(num_3) and 0 and num_3
		self._ui_animations.scrollbar = UIAnimation.init(UIAnimation.function_by_time, content, "scrollbar_progress", content.scrollbar_progress, num_3, 0.3, math.easeOutCubic)
	end
end

LobbyBrowserConsoleUI._handle_browser_input = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local num = 0
	local num_2 = 0
	local _selected_lobby_index = self._selected_lobby_index
	local num_visible_entries = arg_16_2.num_visible_entries
	local num_3 = arg_16_2.height + arg_16_2.spacing
	local _base_pos_y = self._base_pos_y

	_base_pos_y = _base_pos_y or scenegraph_definition.lobby_entry_anchor.position[2]
	self._base_pos_y = _base_pos_y

	local _wanted_pos = self._wanted_pos

	_wanted_pos = _wanted_pos or self._base_pos_y
	self._wanted_pos = _wanted_pos

	if not arg_16_1:get("right_stick_press") then
		self._widgets.frame.content.filter_active = true
		self._filter_active = true
		self._current_active_filter = false
		self._current_filter_index = 1
		self._filter_list_index = nil

		local content = self._widgets.filter_frame.content

		content.filter_selection = true
		content.filter_index = self._current_filter_index

		self._parent:play_sound("Play_hud_hover")

		return
	end

	if not (not arg_16_1:get("refresh") and not (self._num_lobbies > 0)) then
		local lobby_data = self._lobby_entry_widgets[self._selected_lobby_index].content.lobby_data
		local flag = false

		if not lobby_data and not self._parent:is_lobby_joinable(lobby_data) then
			self._parent:play_sound("hud_morris_start_menu_play")
			self._parent:_join(lobby_data)
		end

		return
	elseif not arg_16_1:get("special_1") then
		self._parent:play_sound("hud_morris_start_menu_set")
		self._parent:refresh()

		return
	elseif not arg_16_1:get("left_stick_press") then
		self._parent:play_sound("hud_morris_start_menu_set")
		self._parent:reset_filters()

		return
	end

	if not arg_16_1:get("move_up_hold") then
		num_2 = self._hold_up_timer + arg_16_3
	elseif not arg_16_1:get("move_down_hold") then
		num = self._hold_down_timer + arg_16_3
	end

	self._hold_down_timer = num
	self._hold_up_timer = num_2

	if not (arg_16_1:get("move_down") or not (self._hold_down_timer > 0.5)) then
		if self._hold_down_timer > 0.5 then
			self._hold_down_timer = 0.4
		end

		self._selected_lobby_index = math.clamp(self._selected_lobby_index + 1, 1, self._num_lobbies)
		self._visible_list_index = math.clamp(self._visible_list_index + 1, 1, math.min(num_visible_entries, self._num_lobbies))

		if self._visible_list_index == num_visible_entries then
			local _wanted_pos_2 = self._wanted_pos

			self._wanted_pos = math.clamp(self._wanted_pos + num_3, self._base_pos_y, self._num_lobbies * num_3 - num_visible_entries * num_3)
			self._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.lobby_entry_anchor.position, 2, self._ui_scenegraph.lobby_entry_anchor.position[2], self._wanted_pos, 0.3, math.easeOutCubic)

			if self._wanted_pos ~= _wanted_pos_2 then
				self._visible_list_index = math.clamp(self._visible_list_index - 1, 1, num_visible_entries)
			end
		end
	elseif not (arg_16_1:get("move_up") or not (self._hold_up_timer > 0.5)) then
		if self._hold_up_timer > 0.5 then
			self._hold_up_timer = 0.4
		end

		self._selected_lobby_index = math.clamp(self._selected_lobby_index - 1, 1, self._num_lobbies)
		self._visible_list_index = math.clamp(self._visible_list_index - 1, 1, math.min(num_visible_entries, self._num_lobbies))

		if not (not (self._visible_list_index <= 1) or not (num_visible_entries < self._num_lobbies)) then
			local _wanted_pos_3 = self._wanted_pos

			self._wanted_pos = math.clamp(self._wanted_pos - num_3, self._base_pos_y, self._num_lobbies * num_3 + num_3)
			self._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.lobby_entry_anchor.position, 2, self._ui_scenegraph.lobby_entry_anchor.position[2], self._wanted_pos, 0.3, math.easeOutCubic)

			if self._wanted_pos ~= _wanted_pos_3 then
				self._visible_list_index = math.clamp(self._visible_list_index + 1, 1, num_visible_entries)
			end
		end
	end

	if self._selected_lobby_index ~= _selected_lobby_index then
		self:_select_lobby(_selected_lobby_index, self._selected_lobby_index, self._mouse_selected_index)

		local content_2 = self._widgets.frame.content
		local num_4 = self._wanted_pos / (self._num_lobbies * num_3 - num_visible_entries * num_3)

		num_4 = not self:_is_nan_or_inf(num_4) and 0 and num_4
		self._ui_animations.scrollbar = UIAnimation.init(UIAnimation.function_by_time, content_2, "scrollbar_progress", content_2.scrollbar_progress, num_4, 0.3, math.easeOutCubic)
	end
end

LobbyBrowserConsoleUI._handle_filter_input_mouse = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	return
end

LobbyBrowserConsoleUI._handle_browser_input_mouse = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local _mouse_selected_index = self._mouse_selected_index
	local _selected_lobby_index = self._selected_lobby_index
	local num_visible_entries = arg_18_2.num_visible_entries
	local num = arg_18_2.height + arg_18_2.spacing
	local _base_pos_y = self._base_pos_y

	_base_pos_y = _base_pos_y or scenegraph_definition.lobby_entry_anchor.position[2]
	self._base_pos_y = _base_pos_y

	local _wanted_pos = self._wanted_pos

	_wanted_pos = _wanted_pos or self._base_pos_y
	self._wanted_pos = _wanted_pos

	local get = arg_18_1:get("left_press")
	local filter_frame = self._widgets.filter_frame
	local content = filter_frame.content

	for i = 1, #self._filter_functions do
		local var_18_9 = content["filter_hotspot_" .. i]

		if not var_18_9.on_hover_enter then
			self._parent:play_sound("Play_hud_hover")
		end

		if not var_18_9.is_hover and not get then
			content.filter_active = true
			self._filter_active = true
			self._current_active_filter = i
			self._current_filter_index = i
			self._filter_list_index = nil
			self._mouse_scroll_index = nil

			local content_2 = filter_frame.content

			content_2.filter_selection = true
			content_2.filter_index = self._current_filter_index
			self._widgets.frame.content.filter_active = true

			return
		end
	end

	if not arg_18_1:get("left_press") then
		local _lobby_entry_widgets = self._lobby_entry_widgets

		for i_2, v in ipairs(_lobby_entry_widgets) do
			if not v.content.lobby_hotspot.is_hover then
				self:_select_lobby(_mouse_selected_index, i_2, self._selected_lobby_index)

				self._mouse_selected_index = i_2

				break
			end
		end
	elseif not self._widgets.join_button.content.button_hotspot.on_pressed then
		local var_18_12 = self._lobby_entry_widgets[self._mouse_selected_index]

		if not var_18_12 then
			local lobby_data = var_18_12.content.lobby_data
			local flag = false

			if not lobby_data and not self._parent:is_lobby_joinable(lobby_data) then
				self._parent:_join(lobby_data)
			end
		end

		return
	elseif not self._widgets.refresh_button.content.button_hotspot.on_pressed then
		self._parent:play_sound("hud_morris_start_menu_set")
		self._parent:refresh()

		return
	end

	if num_visible_entries < self._num_lobbies then
		local frame = self._widgets.frame

		if not get then
			if not UIUtils.is_button_hover(frame, "inner_scroller_hotspot") then
				self:_calculate_input_offset(arg_18_2, arg_18_1)
			elseif not UIUtils.is_button_hover(frame, "scrollbar_hotspot") then
				self:_update_scroller_position(num, num_visible_entries, arg_18_2, arg_18_1)

				return
			end
		elseif not arg_18_1:get("left_hold") and not self._progress_diff then
			self:_update_scroller_position(num, num_visible_entries, arg_18_2, arg_18_1)

			return
		else
			self._progress_diff = nil
		end
	else
		self._progress_diff = nil
	end

	local var_18_16 = arg_18_1:get("scroll_axis")[2]
	local frame_2 = self._widgets.frame

	if not UIUtils.is_button_hover(frame_2, "scroller_hotspot") then
		if var_18_16 < 0 then
			self._selected_lobby_index = math.clamp(self._selected_lobby_index + 1, 1, self._num_lobbies)
			self._visible_list_index = math.clamp(self._visible_list_index + 1, 1, math.min(num_visible_entries, self._num_lobbies))

			if num_visible_entries < self._num_lobbies then
				local _wanted_pos_2 = self._wanted_pos

				self._wanted_pos = math.clamp(self._wanted_pos + num, self._base_pos_y, self._num_lobbies * num - num_visible_entries * num)

				if self._wanted_pos ~= _wanted_pos_2 then
					self._visible_list_index = math.clamp(self._visible_list_index - 1, 1, num_visible_entries)
				end

				self._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.lobby_entry_anchor.position, 2, self._ui_scenegraph.lobby_entry_anchor.position[2], self._wanted_pos, 0.3, math.easeOutCubic)
			end
		elseif var_18_16 > 0 then
			self._selected_lobby_index = math.clamp(self._selected_lobby_index - 1, 1, self._num_lobbies)
			self._visible_list_index = math.clamp(self._visible_list_index - 1, 1, math.min(num_visible_entries, self._num_lobbies))

			if num_visible_entries < self._num_lobbies then
				local _wanted_pos_3 = self._wanted_pos

				self._wanted_pos = math.clamp(self._wanted_pos - num, self._base_pos_y, self._num_lobbies * num + num)

				if self._wanted_pos ~= _wanted_pos_3 then
					self._visible_list_index = math.clamp(self._visible_list_index + 1, 1, num_visible_entries)
				end

				self._ui_animations.move = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.lobby_entry_anchor.position, 2, self._ui_scenegraph.lobby_entry_anchor.position[2], self._wanted_pos, 0.3, math.easeOutCubic)
			end
		end
	end

	if self._selected_lobby_index ~= _selected_lobby_index then
		local content_3 = self._widgets.frame.content
		local num_2 = self._wanted_pos / (self._num_lobbies * num - num_visible_entries * num)

		num_2 = not self:_is_nan_or_inf(num_2) and 0 and num_2
		self._ui_animations.scrollbar = UIAnimation.init(UIAnimation.function_by_time, content_3, "scrollbar_progress", content_3.scrollbar_progress, num_2, 0.3, math.easeOutCubic)
	end
end

LobbyBrowserConsoleUI._calculate_input_offset = function (self, arg_19_1, arg_19_2)
	-- function 19
	local frame = self._widgets.frame
	local num = self._ui_scenegraph.lobby_browser_frame.world_position[2] + frame.style.inner_scroller.base_offset[2]
	local num_2 = num - arg_19_1.window_height
	local var_19_3 = frame.style.inner_scroller.texture_size[2]
	local get = arg_19_2:get("cursor")
	local var_19_5 = UIInverseScaleVectorToResolution(get)[2]
	local inv_lerp = math.inv_lerp(num + var_19_3 * 0.5, num_2 - var_19_3 * 0.5, var_19_5)

	self._progress_diff = frame.content.scrollbar_progress - inv_lerp
end

LobbyBrowserConsoleUI._update_scroller_position = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	local frame = self._widgets.frame
	local num = self._ui_scenegraph.lobby_browser_frame.world_position[2] + frame.style.inner_scroller.base_offset[2]
	local num_2 = num - arg_20_3.window_height
	local var_20_3 = frame.style.inner_scroller.texture_size[2]
	local get = arg_20_4:get("cursor")
	local var_20_5 = UIInverseScaleVectorToResolution(get)[2]
	local inv_lerp = math.inv_lerp(num + var_20_3 * 0.5, num_2 - var_20_3 * 0.5, var_20_5)
	local clamp = math.clamp
	local _progress_diff = self._progress_diff

	_progress_diff = _progress_diff or 0

	local var_20_9 = clamp(inv_lerp + _progress_diff, 0, 1)

	frame.content.scrollbar_progress = var_20_9
	self._ui_scenegraph.lobby_entry_anchor.position[2] = var_20_9 * (self._num_lobbies * arg_20_1 - arg_20_2 * arg_20_1)
	self._selected_lobby_index = math.clamp(math.round(var_20_9 * self._num_lobbies), 1, self._num_lobbies)
	self._wanted_pos = math.clamp(self._base_pos_y + arg_20_1 * self._selected_lobby_index - 1, self._base_pos_y, self._num_lobbies * arg_20_1 - arg_20_2 * arg_20_1)
end

LobbyBrowserConsoleUI._is_nan_or_inf = function (arg_21_0, arg_21_1)
	-- function 21
	return type(arg_21_1) ~= "number" or arg_21_1 ~= arg_21_1 or arg_21_1 == math.huge or arg_21_1 == -math.huge
end

LobbyBrowserConsoleUI._handle_filter_input = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local is_device_active = Managers.input:is_device_active("gamepad")

	if arg_22_1:get("right_stick_press") or not arg_22_1:get("back_menu", true) then
		self._widgets.frame.content.filter_active = false
		self._filter_active = false
		self._current_active_filter = false
		self._current_filter_index = 1
		self._filter_list_index = nil

		local content = self._widgets.filter_frame.content

		content.filter_selection = false
		content.filter_index = self._current_filter_index

		return
	end

	local _current_filter_index = self._current_filter_index

	if not arg_22_1:get("confirm") then
		self._widgets.filter_frame.content.filter_selection = false
		self._current_active_filter = self._current_filter_index

		self._parent:play_sound("Play_hud_hover")

		return
	elseif not arg_22_1:get("move_left") then
		_current_filter_index = self:_update_filter_index(-1)
	elseif not arg_22_1:get("move_right") then
		_current_filter_index = self:_update_filter_index(1)
	end

	if self._current_filter_index ~= _current_filter_index then
		self._current_filter_index = _current_filter_index

		self._parent:play_sound("Play_hud_hover")

		self._filter_list_index = nil
		self._widgets.filter_frame.content.filter_index = _current_filter_index
	end
end

LobbyBrowserConsoleUI._update_filter_index = function (self, arg_23_1)
	-- function 23
	local content = self._widgets.filter_frame.content
	local clamp = math.clamp(self._current_filter_index + arg_23_1, 1, #self._filter_functions)
	local count

	if arg_23_1 > 0 then
		count = #self._filter_functions

		if not count then
			-- Nothing
		end
	end

	count = 1

	::label_23_0::

	for i = clamp, count, arg_23_1 do
		if not content["filter_hotspot_" .. i].disable_button then
			return i
		end
	end

	return self._current_filter_index
end

LobbyBrowserConsoleUI._handle_game_type_filter_input = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local _filter_list_index = self._filter_list_index
	local _filter_list_index_2 = self._filter_list_index

	_filter_list_index_2 = _filter_list_index_2 or 1
	self._filter_list_index = _filter_list_index_2

	local num = 0
	local num_2 = 0
	local count = #self._game_type_filter_widgets
	local get = arg_24_1:get("back_menu", true)

	if arg_24_1:get("confirm") or not get then
		local _filter_list_index_3 = self._filter_list_index
		local content = self._game_type_filter_widgets[_filter_list_index_3].content

		content.selected = false
		self._filter_list_index = nil
		self._visible_list_index = 1
		self._hold_up_list_timer = 0
		self._hold_down_list_timer = 0

		if not get then
			self._parent:play_sound("hud_morris_start_menu_set")
			self._parent:set_game_mode(content.game_type)
			self._parent:refresh()
		end

		self._current_active_filter = nil
		self._widgets.filter_frame.content.filter_selection = true

		return
	end

	if not arg_24_1:get("move_up_hold") then
		num_2 = self._hold_up_list_timer + arg_24_3
	elseif not arg_24_1:get("move_down_hold") then
		num = self._hold_down_list_timer + arg_24_3
	end

	self._hold_down_list_timer = num
	self._hold_up_list_timer = num_2

	if not (arg_24_1:get("move_down") or not (self._hold_down_list_timer > 0.5)) then
		if self._hold_down_list_timer > 0.5 then
			self._hold_down_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index + 1, 1, count)
	elseif not (arg_24_1:get("move_up") or not (self._hold_up_list_timer > 0.5)) then
		if self._hold_up_list_timer > 0.5 then
			self._hold_up_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index - 1, 1, count)
	end

	if self._filter_list_index ~= _filter_list_index then
		self._game_type_filter_widgets[self._filter_list_index].content.selected = true

		if not _filter_list_index then
			self._game_type_filter_widgets[_filter_list_index].content.selected = false
		end

		self._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_game_type_filter_input_mouse = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	local num = arg_25_2.window_height + arg_25_2.filter_height
	local ceil = math.ceil(num / (arg_25_2.filter_height + arg_25_2.spacing))
	local num_2 = arg_25_2.filter_height + arg_25_2.spacing
	local _list_base_pos_y = self._list_base_pos_y

	_list_base_pos_y = _list_base_pos_y or scenegraph_definition.filter_game_type_entry_anchor.position[2]
	self._list_base_pos_y = _list_base_pos_y

	local count = #self._game_type_filter_widgets
	local _mouse_scroll_index = self._mouse_scroll_index

	_mouse_scroll_index = _mouse_scroll_index or 1
	self._mouse_scroll_index = _mouse_scroll_index

	local flag = false
	local get = arg_25_1:get("back_menu", true)

	if not arg_25_1:get("left_press") then
		for i, v in ipairs(self._game_type_filter_widgets) do
			if not v.content.button_hotspot.is_hover then
				flag = true

				self._parent:play_sound("hud_morris_start_menu_set")
				self._parent:set_game_mode(v.content.game_type)
				self._parent:refresh()

				get = true

				break
			end
		end

		get = get or not flag
	end

	if not get then
		self._filter_list_index = nil
		self._wanted_list_pos = self._list_base_pos_y
		self._visible_list_index = 1
		self._hold_up_list_timer = 0
		self._hold_down_list_timer = 0
		self._ui_scenegraph.filter_game_type_entry_anchor.position[2] = self._list_base_pos_y
		self._current_active_filter = nil
		self._widgets.filter_frame.content.filter_selection = true

		return
	end
end

LobbyBrowserConsoleUI._handle_level_filter_input = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	local num = 0
	local num_2 = 0
	local _filter_list_index = self._filter_list_index
	local _filter_list_index_2 = self._filter_list_index

	_filter_list_index_2 = _filter_list_index_2 or 1
	self._filter_list_index = _filter_list_index_2

	local num_3 = arg_26_2.window_height + arg_26_2.filter_height
	local ceil = math.ceil(num_3 / (arg_26_2.filter_height + arg_26_2.spacing))
	local num_4 = arg_26_2.filter_height + arg_26_2.spacing
	local _list_base_pos_y = self._list_base_pos_y

	_list_base_pos_y = _list_base_pos_y or scenegraph_definition.filter_level_entry_anchor.position[2]
	self._list_base_pos_y = _list_base_pos_y

	local _wanted_list_pos = self._wanted_list_pos

	_wanted_list_pos = _wanted_list_pos or self._list_base_pos_y
	self._wanted_list_pos = _wanted_list_pos

	local count = #self._level_filter_widgets
	local get = arg_26_1:get("confirm")
	local get_2 = arg_26_1:get("back_menu", true)

	if get or not get_2 then
		local _filter_list_index_3 = self._filter_list_index

		if self._level_filter_widgets[_filter_list_index_3].content.unlocked or not get_2 then
			local content = self._level_filter_widgets[self._filter_list_index].content

			content.selected = false
			self._filter_list_index = nil
			self._wanted_list_pos = self._list_base_pos_y
			self._visible_list_index = 1
			self._hold_up_list_timer = 0
			self._hold_down_list_timer = 0
			self._ui_scenegraph.filter_level_entry_anchor.position[2] = self._list_base_pos_y

			if not get_2 then
				self._parent:play_sound("hud_morris_start_menu_set")
				self._parent:set_level(content.level)
				self._parent:refresh()
			end

			self._current_active_filter = nil
			self._widgets.filter_frame.content.filter_selection = true

			return
		end
	end

	for i = 1, #self._level_filter_widgets do
		if not UIUtils.is_button_hover_enter(self._level_filter_widgets[i]) then
			self._parent:play_sound("Play_hud_hover")

			break
		end
	end

	if not arg_26_1:get("move_up_hold") then
		num_2 = self._hold_up_list_timer + arg_26_3
	elseif not arg_26_1:get("move_down_hold") then
		num = self._hold_down_list_timer + arg_26_3
	end

	self._hold_down_list_timer = num
	self._hold_up_list_timer = num_2

	if not (arg_26_1:get("move_down") or not (self._hold_down_list_timer > 0.5)) then
		if self._hold_down_list_timer > 0.5 then
			self._hold_down_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index + 1, 1, count)
		self._visible_list_index = math.clamp(self._visible_list_index + 1, 1, math.min(ceil, count))

		if self._visible_list_index == ceil then
			local _wanted_list_pos_2 = self._wanted_list_pos

			if count >= self._filter_list_index then
				self._wanted_list_pos = math.clamp(self._wanted_list_pos + num_4, self._list_base_pos_y, count * num_4 - ceil * num_4)
				self._ui_animations.move_list = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.filter_level_entry_anchor.position, 2, self._ui_scenegraph.filter_level_entry_anchor.position[2], self._wanted_list_pos, 0.3, math.easeOutCubic)
			end

			if self._wanted_list_pos ~= _wanted_list_pos_2 then
				self._visible_list_index = math.clamp(self._visible_list_index - 1, 1, ceil)
			end
		end
	elseif not (arg_26_1:get("move_up") or not (self._hold_up_list_timer > 0.5)) then
		if self._hold_up_list_timer > 0.5 then
			self._hold_up_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index - 1, 1, count)
		self._visible_list_index = math.clamp(self._visible_list_index - 1, 1, math.min(ceil, count))

		if not (not (self._visible_list_index <= 1) or not (ceil < count)) then
			local _wanted_list_pos_3 = self._wanted_list_pos

			self._wanted_list_pos = math.clamp(self._wanted_list_pos - num_4, self._list_base_pos_y, self._num_lobbies * num_4 + num_4)
			self._ui_animations.move_list = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.filter_level_entry_anchor.position, 2, self._ui_scenegraph.filter_level_entry_anchor.position[2], self._wanted_list_pos, 0.3, math.easeOutCubic)

			if self._wanted_list_pos ~= _wanted_list_pos_3 then
				self._visible_list_index = math.clamp(self._visible_list_index + 1, 1, ceil)
			end
		end
	end

	if self._filter_list_index ~= _filter_list_index then
		self._level_filter_widgets[self._filter_list_index].content.selected = true

		if not _filter_list_index then
			self._level_filter_widgets[_filter_list_index].content.selected = false
		end

		local content_2 = self._level_filter_scroller.content
		local num_5 = (self._wanted_list_pos - self._list_base_pos_y) / (count * num_4 - ceil * num_4 + num_4)

		num_5 = not self:_is_nan_or_inf(num_5) and 0 and num_5
		self._ui_animations.list_scrollbar = UIAnimation.init(UIAnimation.function_by_time, content_2, "scrollbar_progress", content_2.scrollbar_progress, num_5, 0.3, math.easeOutCubic)

		self._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_level_filter_input_mouse = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	-- function 27
	local num = arg_27_2.window_height + arg_27_2.filter_height
	local ceil = math.ceil(num / (arg_27_2.filter_height + arg_27_2.spacing))
	local num_2 = arg_27_2.filter_height + arg_27_2.spacing
	local _list_base_pos_y = self._list_base_pos_y

	_list_base_pos_y = _list_base_pos_y or scenegraph_definition.filter_level_entry_anchor.position[2]
	self._list_base_pos_y = _list_base_pos_y

	local count = #self._level_filter_widgets
	local _mouse_scroll_index = self._mouse_scroll_index

	_mouse_scroll_index = _mouse_scroll_index or 1
	self._mouse_scroll_index = _mouse_scroll_index

	local _level_filter_scroller = self._level_filter_scroller
	local content = _level_filter_scroller.content
	local style = _level_filter_scroller.style
	local scroller_hotspot = content.scroller_hotspot
	local bar_hotspot = content.bar_hotspot
	local flag = false
	local get = arg_27_1:get("back_menu", true)

	if not arg_27_1:get("left_press") then
		for i, v in ipairs(self._level_filter_widgets) do
			if not v.content.button_hotspot.is_hover then
				flag = true

				if not v.content.unlocked then
					self._parent:play_sound("hud_morris_start_menu_set")
					self._parent:set_level(v.content.level)
					self._parent:refresh()

					get = true

					break
				end
			end
		end

		flag = bar_hotspot.is_hover or flag
		get = get or not flag
	end

	if not get then
		self._filter_list_index = nil
		self._wanted_list_pos = self._list_base_pos_y
		self._visible_list_index = 1
		self._hold_up_list_timer = 0
		self._hold_down_list_timer = 0
		self._ui_scenegraph.filter_level_entry_anchor.position[2] = self._list_base_pos_y
		self._current_active_filter = nil
		self._widgets.filter_frame.content.filter_selection = true
		self._level_filter_scroller.content.scrollbar_progress = 0

		return
	end

	if not scroller_hotspot.on_pressed then
		self._old_mouse_y = arg_27_1:get("cursor")[2]
	elseif not scroller_hotspot.is_held then
		local num_3 = (count - ceil - 3) * arg_27_2.filter_height
		local var_27_14 = arg_27_1:get("cursor")[2]
		local num_4 = var_27_14 - self._old_mouse_y
		local num_5

		if num_3 > 0 then
			num_5 = num_4 / num_3

			if not num_5 then
				-- Nothing
			end
		end

		num_5 = 0

		::label_27_0::

		local clamp = math.clamp(content.scrollbar_progress - num_5, 0, 1)

		content.scrollbar_progress = clamp

		local num_6 = self._list_base_pos_y + (count - ceil + 1) * clamp * num_2

		self._ui_scenegraph.filter_level_entry_anchor.position[2] = num_6
		self._mouse_scroll_index = math.floor((count - ceil + 1) * clamp)
		self._old_mouse_y = var_27_14
	elseif ceil < count then
		local var_27_19 = arg_27_1:get("scroll_axis")[2]

		if math.abs(var_27_19) > 0 then
			self._mouse_scroll_index = math.clamp(self._mouse_scroll_index - math.sign(var_27_19), 1, count - ceil + 2)

			local num_7 = self._mouse_scroll_index - 1
			local num_8 = self._list_base_pos_y + num_7 * num_2

			self._ui_animations.move_list = UIAnimation.init(UIAnimation.function_by_time, self._ui_scenegraph.filter_level_entry_anchor.position, 2, self._ui_scenegraph.filter_level_entry_anchor.position[2], num_8, 0.3, math.easeOutCubic)

			local content_2 = self._level_filter_scroller.content
			local num_9 = num_7 / (count - ceil + 1)

			num_9 = not self:_is_nan_or_inf(num_9) and 0 and num_9
			self._ui_animations.list_scrollbar = UIAnimation.init(UIAnimation.function_by_time, content_2, "scrollbar_progress", content_2.scrollbar_progress, num_9, 0.3, math.easeOutCubic)
		end
	end
end

LobbyBrowserConsoleUI._handle_difficulty_filter_input = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	local _filter_list_index = self._filter_list_index
	local _filter_list_index_2 = self._filter_list_index

	_filter_list_index_2 = _filter_list_index_2 or 1
	self._filter_list_index = _filter_list_index_2

	local num = 0
	local num_2 = 0
	local count = #self._difficulty_filter_widgets
	local get = arg_28_1:get("back_menu", true)

	if arg_28_1:get("confirm") or not get then
		local _filter_list_index_3 = self._filter_list_index
		local content = self._difficulty_filter_widgets[_filter_list_index_3].content

		if content.unlocked or not get then
			content.selected = false
			self._filter_list_index = nil
			self._visible_list_index = 1
			self._hold_up_list_timer = 0
			self._hold_down_list_timer = 0

			if not get then
				self._parent:play_sound("hud_morris_start_menu_set")
				self._parent:set_difficulty(content.difficulty)
				self._parent:refresh()
			end

			self._current_active_filter = nil
			self._widgets.filter_frame.content.filter_selection = true

			return
		end
	end

	if not arg_28_1:get("move_up_hold") then
		num_2 = self._hold_up_list_timer + arg_28_3
	elseif not arg_28_1:get("move_down_hold") then
		num = self._hold_down_list_timer + arg_28_3
	end

	self._hold_down_list_timer = num
	self._hold_up_list_timer = num_2

	if not (arg_28_1:get("move_down") or not (self._hold_down_list_timer > 0.5)) then
		if self._hold_down_list_timer > 0.5 then
			self._hold_down_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index + 1, 1, count)
	elseif not (arg_28_1:get("move_up") or not (self._hold_up_list_timer > 0.5)) then
		if self._hold_up_list_timer > 0.5 then
			self._hold_up_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index - 1, 1, count)
	end

	if self._filter_list_index ~= _filter_list_index then
		self._difficulty_filter_widgets[self._filter_list_index].content.selected = true

		if not _filter_list_index then
			self._difficulty_filter_widgets[_filter_list_index].content.selected = false
		end

		self._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_difficulty_filter_input_mouse = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	-- function 29
	local num = arg_29_2.window_height + arg_29_2.filter_height
	local ceil = math.ceil(num / (arg_29_2.filter_height + arg_29_2.spacing))
	local num_2 = arg_29_2.filter_height + arg_29_2.spacing
	local _list_base_pos_y = self._list_base_pos_y

	_list_base_pos_y = _list_base_pos_y or scenegraph_definition.filter_difficulty_entry_anchor.position[2]
	self._list_base_pos_y = _list_base_pos_y

	local count = #self._difficulty_filter_widgets
	local _mouse_scroll_index = self._mouse_scroll_index

	_mouse_scroll_index = _mouse_scroll_index or 1
	self._mouse_scroll_index = _mouse_scroll_index

	local flag = false
	local get = arg_29_1:get("back_menu", true)

	if not arg_29_1:get("left_press") then
		for i, v in ipairs(self._difficulty_filter_widgets) do
			if not v.content.button_hotspot.is_hover then
				flag = true

				if not v.content.unlocked then
					self._parent:play_sound("hud_morris_start_menu_set")
					self._parent:set_difficulty(v.content.difficulty)
					self._parent:refresh()

					get = true

					break
				end
			end
		end

		get = get or not flag
	end

	if not get then
		self._filter_list_index = nil
		self._wanted_list_pos = self._list_base_pos_y
		self._visible_list_index = 1
		self._hold_up_list_timer = 0
		self._hold_down_list_timer = 0
		self._ui_scenegraph.filter_difficulty_entry_anchor.position[2] = self._list_base_pos_y
		self._current_active_filter = nil
		self._widgets.filter_frame.content.filter_selection = true

		return
	end
end

LobbyBrowserConsoleUI._handle_lobby_filter_input = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	local _filter_list_index = self._filter_list_index
	local _filter_list_index_2 = self._filter_list_index

	_filter_list_index_2 = _filter_list_index_2 or 1
	self._filter_list_index = _filter_list_index_2

	local num = 0
	local num_2 = 0
	local count = #self._lobby_filter_widgets
	local get = arg_30_1:get("back_menu", true)

	if arg_30_1:get("confirm") or not get then
		local _filter_list_index_3 = self._filter_list_index
		local content = self._lobby_filter_widgets[_filter_list_index_3].content

		content.selected = false
		self._filter_list_index = nil
		self._visible_list_index = 1
		self._hold_up_list_timer = 0
		self._hold_down_list_timer = 0

		if not get then
			self._parent:play_sound("hud_morris_start_menu_set")
			self._parent:set_lobby_filter(content.lobby_filter)
			self._parent:refresh()
		end

		self._current_active_filter = nil
		self._widgets.filter_frame.content.filter_selection = true

		return
	end

	if not arg_30_1:get("move_up_hold") then
		num_2 = self._hold_up_list_timer + arg_30_3
	elseif not arg_30_1:get("move_down_hold") then
		num = self._hold_down_list_timer + arg_30_3
	end

	self._hold_down_list_timer = num
	self._hold_up_list_timer = num_2

	if not (arg_30_1:get("move_down") or not (self._hold_down_list_timer > 0.5)) then
		if self._hold_down_list_timer > 0.5 then
			self._hold_down_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index + 1, 1, count)
	elseif not (arg_30_1:get("move_up") or not (self._hold_up_list_timer > 0.5)) then
		if self._hold_up_list_timer > 0.5 then
			self._hold_up_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index - 1, 1, count)
	end

	if self._filter_list_index ~= _filter_list_index then
		self._lobby_filter_widgets[self._filter_list_index].content.selected = true

		if not _filter_list_index then
			self._lobby_filter_widgets[_filter_list_index].content.selected = false
		end

		self._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_lobby_filter_input_mouse = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	-- function 31
	local num = arg_31_2.window_height + arg_31_2.filter_height
	local ceil = math.ceil(num / (arg_31_2.filter_height + arg_31_2.spacing))
	local num_2 = arg_31_2.filter_height + arg_31_2.spacing
	local _list_base_pos_y = self._list_base_pos_y

	_list_base_pos_y = _list_base_pos_y or scenegraph_definition.filter_lobby_entry_anchor.position[2]
	self._list_base_pos_y = _list_base_pos_y

	local count = #self._lobby_filter_widgets
	local _mouse_scroll_index = self._mouse_scroll_index

	_mouse_scroll_index = _mouse_scroll_index or 1
	self._mouse_scroll_index = _mouse_scroll_index

	local flag = false
	local get = arg_31_1:get("back_menu", true)

	if not arg_31_1:get("left_press") then
		for i, v in ipairs(self._lobby_filter_widgets) do
			if not v.content.button_hotspot.is_hover then
				self._parent:play_sound("hud_morris_start_menu_set")
				self._parent:set_lobby_filter(v.content.lobby_filter)
				self._parent:refresh()

				get = true
				flag = true

				break
			end
		end

		get = get or not flag
	end

	if not get then
		self._filter_list_index = nil
		self._wanted_list_pos = self._list_base_pos_y
		self._visible_list_index = 1
		self._hold_up_list_timer = 0
		self._hold_down_list_timer = 0
		self._ui_scenegraph.filter_lobby_entry_anchor.position[2] = self._list_base_pos_y
		self._current_active_filter = nil
		self._widgets.filter_frame.content.filter_selection = true

		return
	end
end

LobbyBrowserConsoleUI._handle_distance_filter_input = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	local _filter_list_index = self._filter_list_index
	local _filter_list_index_2 = self._filter_list_index

	_filter_list_index_2 = _filter_list_index_2 or 1
	self._filter_list_index = _filter_list_index_2

	local num = 0
	local num_2 = 0
	local count = #self._distance_filter_widgets
	local get = arg_32_1:get("back_menu", true)

	if arg_32_1:get("confirm") or not get then
		local _filter_list_index_3 = self._filter_list_index
		local content = self._distance_filter_widgets[_filter_list_index_3].content

		content.selected = false
		self._filter_list_index = nil
		self._visible_list_index = 1
		self._hold_up_list_timer = 0
		self._hold_down_list_timer = 0

		if not get then
			self._parent:play_sound("hud_morris_start_menu_set")
			self._parent:set_distance_filter(content.distance)
			self._parent:refresh()
		end

		self._current_active_filter = nil
		self._widgets.filter_frame.content.filter_selection = true

		return
	end

	if not arg_32_1:get("move_up_hold") then
		num_2 = self._hold_up_list_timer + arg_32_3
	elseif not arg_32_1:get("move_down_hold") then
		num = self._hold_down_list_timer + arg_32_3
	end

	self._hold_down_list_timer = num
	self._hold_up_list_timer = num_2

	if not (arg_32_1:get("move_down") or not (self._hold_down_list_timer > 0.5)) then
		if self._hold_down_list_timer > 0.5 then
			self._hold_down_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index + 1, 1, count)
	elseif not (arg_32_1:get("move_up") or not (self._hold_up_list_timer > 0.5)) then
		if self._hold_up_list_timer > 0.5 then
			self._hold_up_list_timer = 0.4
		end

		self._filter_list_index = math.clamp(self._filter_list_index - 1, 1, count)
	end

	if self._filter_list_index ~= _filter_list_index then
		self._distance_filter_widgets[self._filter_list_index].content.selected = true

		if not _filter_list_index then
			self._distance_filter_widgets[_filter_list_index].content.selected = false
		end

		self._parent:play_sound("Play_hud_hover")
	end
end

LobbyBrowserConsoleUI._handle_distance_filter_input_mouse = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	-- function 33
	local num = arg_33_2.window_height + arg_33_2.filter_height
	local ceil = math.ceil(num / (arg_33_2.filter_height + arg_33_2.spacing))
	local num_2 = arg_33_2.filter_height + arg_33_2.spacing
	local _list_base_pos_y = self._list_base_pos_y

	_list_base_pos_y = _list_base_pos_y or scenegraph_definition.filter_distance_entry_anchor.position[2]
	self._list_base_pos_y = _list_base_pos_y

	local count = #self._distance_filter_widgets
	local _mouse_scroll_index = self._mouse_scroll_index

	_mouse_scroll_index = _mouse_scroll_index or 1
	self._mouse_scroll_index = _mouse_scroll_index

	local flag = false
	local get = arg_33_1:get("back_menu", true)

	if not arg_33_1:get("left_press") then
		for i, v in ipairs(self._distance_filter_widgets) do
			if not v.content.button_hotspot.is_hover then
				self._parent:play_sound("hud_morris_start_menu_set")
				self._parent:set_distance_filter(v.content.distance)
				self._parent:refresh()

				get = true
				flag = true

				break
			end
		end

		get = get or not flag
	end

	if not get then
		self._filter_list_index = nil
		self._wanted_list_pos = self._list_base_pos_y
		self._visible_list_index = 1
		self._hold_up_list_timer = 0
		self._hold_down_list_timer = 0
		self._ui_scenegraph.filter_distance_entry_anchor.position[2] = self._list_base_pos_y
		self._current_active_filter = nil
		self._widgets.filter_frame.content.filter_selection = true

		return
	end
end

LobbyBrowserConsoleUI._select_lobby = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	self._details_filled = false

	if not self._scrollbar_ui then
		self._scrollbar_ui:destroy(self._ui_scenegraph)

		self._scrollbar_ui = nil
	end

	local _lobby_entry_widgets = self._lobby_entry_widgets

	if not arg_34_1 then
		local var_34_1 = _lobby_entry_widgets[arg_34_1]

		if not var_34_1 then
			var_34_1.content.selected = false
		end
	end

	if not arg_34_3 then
		local var_34_2 = _lobby_entry_widgets[arg_34_3]

		if not var_34_2 then
			var_34_2.content.selected = false
		end
	end

	if not arg_34_2 then
		local var_34_3 = _lobby_entry_widgets[arg_34_2]

		if not var_34_3 then
			var_34_3.content.selected = true
		end
	end

	local var_34_4 = self._lobby_entry_widgets[arg_34_2]
	local flag = not var_34_4 and var_34_4.content
	local flag_2 = not flag and flag.lobby_data

	self._selected_lobby_id = not flag_2 and flag_2.id

	local get_lobbies = self._parent:get_lobbies()
	local _remove_invalid_lobbies, var_34_9 = self:_remove_invalid_lobbies(get_lobbies)

	if not var_34_9[self._selected_lobby_id] then
		local flag_3 = true

		self:_update_lobby_details(var_34_9, flag_3)
	end
end

LobbyBrowserConsoleUI._update_lobby_data = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not self._parent:dirty() then
		return
	end

	local get_lobbies = self._parent:get_lobbies()
	local _remove_invalid_lobbies, var_35_2 = self:_remove_invalid_lobbies(get_lobbies)

	self:_update_lobby_details(var_35_2)
	self:_update_lobby_list(var_35_2, arg_35_1, arg_35_2)
end

LobbyBrowserConsoleUI._update_lobby_details = function (self, arg_36_1, arg_36_2)
	-- function 36
	local _selected_lobby_id = self._selected_lobby_id

	if not _selected_lobby_id then
		self._details_filled = false
	end

	local var_36_1 = arg_36_1[_selected_lobby_id]

	if not var_36_1 then
		local mechanism = var_36_1.mechanism
		local selected_mission_id = var_36_1.selected_mission_id

		if mechanism ~= "weave" or not WeaveSettings.templates[selected_mission_id] then
			self:_fill_weave_details(var_36_1)
		elseif mechanism ~= "deus" or not DeusJourneySettings[selected_mission_id] then
			self:_fill_deus_details(var_36_1)
		elseif mechanism == "versus" then
			self:_fill_versus_details(var_36_1, arg_36_2)
		else
			self:_fill_details(var_36_1)
		end
	else
		self._details_filled = false
	end
end

LobbyBrowserConsoleUI._update_lobby_list = function (self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	for i, v in ipairs(self._lobby_entry_widgets) do
		local content = v.content
		local lobby_data = content.lobby_data
		local selected = content.selected
		local var_37_3 = v.offset[2]

		self:_update_lobby_entry(i, var_37_3, selected, lobby_data, arg_37_1, arg_37_2, arg_37_3)
	end
end

LobbyBrowserConsoleUI._update_lobby_entry = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7)
	-- function 38
	local var_38_0 = arg_38_5[not arg_38_4 and arg_38_4.id]

	if not var_38_0 then
		local create_lobby_entry_func = var_0_0.create_lobby_entry_func
		local is_lobby_joinable, var_38_3 = self._parent:is_lobby_joinable(var_38_0)
		local completed_level_difficulty_index = self._parent:completed_level_difficulty_index(var_38_0)
		local var_38_5 = create_lobby_entry_func(arg_38_2, var_38_0, arg_38_1, is_lobby_joinable, completed_level_difficulty_index)
		local var_38_6 = UIWidget.init(var_38_5)

		var_38_6.content.selected = arg_38_3
		self._lobby_entry_widgets[arg_38_1] = var_38_6
	else
		local create_unavailable_lobby_entry_func = var_0_0.create_unavailable_lobby_entry_func(arg_38_2)
		local var_38_8 = UIWidget.init(create_unavailable_lobby_entry_func)

		var_38_8.content.selected = arg_38_3
		self._lobby_entry_widgets[arg_38_1] = var_38_8
	end
end

LobbyBrowserConsoleUI._fill_versus_details = function (self, arg_39_1, arg_39_2)
	-- function 39
	local versus = self._details_widgets.versus
	local versus_2 = self._dynamic_details_widgets.versus
	local str = "level_image_any"
	local str_2 = "random_level"

	if not arg_39_1 then
		-- Nothing
	end

	::label_39_0::

	local selected_mission_id = arg_39_1.selected_mission_id

	selected_mission_id = selected_mission_id or arg_39_1.mission_id

	::label_39_1::

	local flag = not arg_39_1 and arg_39_1.matchmaking_type
	local flag_2 = not flag and NetworkLookup.matchmaking_types[tonumber(flag)]

	if not (not selected_mission_id and selected_mission_id == "any") then
		local var_39_7 = selected_mission_id
		local var_39_8 = LevelSettings[var_39_7]

		str_2 = var_39_8.display_name or "lb_unknown"
		str = var_39_8.level_image or str
	end

	local level_image = versus.level_image

	level_image.content.texture_id = str

	local level_name = versus.level_name

	level_name.content.text = Localize(str_2)

	local content = versus.level_image_frame.content

	content.texture_id = "map_frame_00"

	local custom_level_image = versus.custom_level_image

	custom_level_image.content.texture_id = str

	local custom_level_name = versus.custom_level_name

	custom_level_name.content.text = Localize(str_2)

	local content_2 = versus.custom_level_image_frame.content

	content_2.texture_id = "map_frame_00"

	local button_hotspot = self._widgets.join_button.content.button_hotspot
	local content_3 = versus.locked_reason.content

	if not arg_39_1 then
		local is_lobby_joinable, var_39_18 = self._parent:is_lobby_joinable(arg_39_1)

		content_3.text = var_39_18 or "tutorial_no_text"
		button_hotspot.disable_button = not is_lobby_joinable
	else
		content_3.text = "tutorial_no_text"
		button_hotspot.disable_button = true
	end

	local content_4 = versus.details_information.content

	if not arg_39_1 then
		local tbl = {
			custom = "map_host_setting",
			["n/a"] = "lb_game_type_none",
			standard = "lb_game_type_quick_play"
		}
		local mission_id = arg_39_1.mission_id
		local var_39_22 = LevelSettings[mission_id]
		local var_39_23

		if not flag_2 then
			var_39_23 = tbl[flag_2]

			if not var_39_23 then
				-- Nothing
			end
		end

		var_39_23 = "lb_game_type_none"

		::label_39_2::

		content_4.game_type_id = var_39_23

		local flag_3

		flag_3 = not var_39_22.hub_level and "lb_in_inn" and "lb_playing"
		content_4.status_id = flag_3
	else
		content_4.game_type_id = "lb_unknown"
		content_4.status_id = "lb_unknown"
	end

	local players = versus.players
	local flag_4 = true
	local deserialize_lobby_reservation_data = LobbyAux.deserialize_lobby_reservation_data(arg_39_1, flag_4)

	for i = 1, 2 do
		local var_39_28 = deserialize_lobby_reservation_data[i]

		for j = 1, 4 do
			local flag_5 = not var_39_28 and var_39_28[j]
			local flag_6 = not flag_5 and flag_5.peer_id
			local str_3 = "---"

			if not flag_6 then
				str_3 = PlayerUtils.player_name(flag_6, nil)
				str_3 = UIRenderer.crop_text(str_3, 18)
			end

			local format = string.format("player_%d_%d", i, j)

			players.content[format] = str_3

			local flag_7

			flag_7 = not flag_6 and not LobbyInternal.is_friend(flag_6) and "pale_green" and "font_default"

			local var_39_34 = Colors.color_definitions[flag_7]

			Colors.copy_no_alpha_to(players.style[format].text_color, var_39_34)
		end
	end

	if not arg_39_2 then
		local custom_game_settings = arg_39_1.custom_game_settings
		local flag_8 = not custom_game_settings and custom_game_settings ~= "n/a" or false

		table.clear(versus_2)

		self._scrollbar_ui = nil

		if not flag_8 then
			local parse_packed_custom_settings = GameModeCustomSettingsHandlerUtility.parse_packed_custom_settings(custom_game_settings, "versus")
			local num = 0

			for k = 1, #parse_packed_custom_settings do
				local var_39_39 = parse_packed_custom_settings[k]
				local create_custom_setting_func = var_0_0.create_custom_setting_func(var_39_39.name, var_39_39.value, var_39_39.template, num)

				versus_2[#versus_2 + 1] = UIWidget.init(create_custom_setting_func)
				num = num - 30
			end

			local str_4 = "custom_settings_window"
			local str_5 = "custom_settings_anchor"
			local var_39_43 = self._ui_scenegraph[str_4].size[2]
			local num_2 = math.abs(num) - var_39_43
			local var_39_45
			local flag_9 = true

			if num_2 > 0 then
				self._scrollbar_ui = ScrollbarUI:new(self._ui_scenegraph, str_4, str_5, num_2, flag_9, var_39_45)
			end

			level_image.content.visible = false
			level_name.content.visible = false
			content.visible = false
			custom_level_image.content.visible = true
			custom_level_name.content.visible = true
			content_2.visible = true
			self._ui_scenegraph.details_players.position[2] = 180
			versus.custom_settings.content.visible = true
			versus.custom_settings_label.content.visible = true
			versus.custom_settings_icon.content.visible = true
		else
			self._ui_scenegraph.details_players.position[2] = 0
			level_image.content.visible = true
			level_name.content.visible = true
			content.visible = true
			custom_level_image.content.visible = false
			custom_level_name.content.visible = false
			content_2.visible = false
			versus.custom_settings.content.visible = false
			versus.custom_settings_label.content.visible = false
			versus.custom_settings_icon.content.visible = false
		end
	end

	self._details_type = "versus"
	self._details_filled = true
end

LobbyBrowserConsoleUI._fill_details = function (self, arg_40_1)
	-- function 40
	local adventure = self._details_widgets.adventure
	local str = "level_image_any"
	local var_40_2

	if not arg_40_1 then
		-- Nothing
	end

	::label_40_0::

	local selected_mission_id = arg_40_1.selected_mission_id

	selected_mission_id = selected_mission_id or arg_40_1.mission_id

	::label_40_1::

	local flag = not arg_40_1 and arg_40_1.matchmaking_type
	local flag_2 = not flag and not IS_PS4 and flag and NetworkLookup.matchmaking_types[tonumber(flag)]
	local flag_3 = not arg_40_1 and arg_40_1.mechanism

	if not selected_mission_id then
		if selected_mission_id == "default_start_level" then
			selected_mission_id = LevelSettingsDefaultStartLevel
		end

		local var_40_7 = selected_mission_id

		if flag_3 == "weave" then
			local var_40_8 = WeaveSettings.templates[selected_mission_id]

			if not var_40_8 then
				var_40_7 = var_40_8.objectives[1].level_id
			end
		end

		local var_40_9 = LevelSettings[var_40_7]

		var_40_2 = var_40_9.display_name
		str = var_40_9.level_image or str
	end

	adventure.level_image.content.texture_id = str

	local content = adventure.level_name.content
	local var_40_11

	if not var_40_2 then
		var_40_11 = Localize(var_40_2)

		if not var_40_11 then
			-- Nothing
		end
	end

	var_40_11 = " "

	::label_40_2::

	content.text = var_40_11

	local tbl = {}

	if not arg_40_1 then
		local count = #SPProfiles

		for i = 1, count do
			if not ProfileSynchronizer.is_free_in_lobby(i, arg_40_1) then
				tbl[i] = true
			end
		end
	end

	local content_2 = adventure.hero_tabs.content

	for j = 1, #ProfilePriority do
		local var_40_15 = ProfilePriority[j]
		local str_2 = "_" .. tostring(j)
		local var_40_17 = content_2["hotspot" .. str_2]

		if not tbl[var_40_15] then
			var_40_17.disable_button = true
		else
			var_40_17.disable_button = false
		end
	end

	local content_3 = adventure.level_image_frame.content
	local str_3 = "map_frame_00"

	if not arg_40_1 then
		local completed_level_difficulty_index = self._parent:completed_level_difficulty_index(arg_40_1)

		if completed_level_difficulty_index > 0 then
			local var_40_21 = DefaultDifficulties[completed_level_difficulty_index]

			str_3 = DifficultySettings[var_40_21].completed_frame_texture
		end
	end

	content_3.texture_id = str_3

	local button_hotspot = self._widgets.join_button.content.button_hotspot
	local content_4 = adventure.locked_reason.content

	if not arg_40_1 then
		local is_lobby_joinable, var_40_25 = self._parent:is_lobby_joinable(arg_40_1)

		content_4.text = var_40_25 or "tutorial_no_text"
		button_hotspot.disable_button = not is_lobby_joinable
	else
		content_4.text = "tutorial_no_text"
		button_hotspot.disable_button = true
	end

	local content_5 = adventure.details_information.content

	if not arg_40_1 then
		local tbl_2 = {
			tutorial = "lb_game_type_prologue",
			deed = "lb_game_type_deed",
			weave = "lb_game_type_weave",
			event = "lb_game_type_event",
			deus_weekly = "cw_weekly_expedition_name_long",
			custom = "lb_game_type_custom",
			standard = "lb_game_type_quick_play",
			weave_quick_play = "lb_game_type_weave_quick_play",
			["n/a"] = "lb_game_type_none",
			deus = "area_selection_morris_name"
		}
		local mission_id = arg_40_1.mission_id
		local var_40_29 = mission_id

		if flag_3 == "weave" then
			local var_40_30 = WeaveSettings.templates[mission_id]

			if not var_40_30 then
				var_40_29 = var_40_30.objectives[1].level_id
			end

			if arg_40_1.weave_quick_game == "true" then
				flag_2 = "weave_quick_play"
			else
				flag_2 = "weave"
			end
		elseif flag_3 == "deus" then
			flag_2 = flag_2 ~= "event" or not "deus_weekly" or "deus"
		end

		local var_40_31 = LevelSettings[var_40_29]
		local var_40_32

		if not flag_2 then
			var_40_32 = tbl_2[flag_2]

			if not var_40_32 then
				var_40_32 = "lb_unknown"
			end
		else
			var_40_32 = "lb_game_type_none"
		end

		content_5.game_type_id = var_40_32

		local flag_4

		flag_4 = not var_40_31.hub_level and "lb_in_inn" and "lb_playing"
		content_5.status_id = flag_4
	else
		content_5.game_type_id = "lb_unknown"
		content_5.status_id = "lb_unknown"
	end

	adventure.twitch_logo.content.visible = to_boolean(not arg_40_1 and arg_40_1.twitch_enabled)
	self._details_type = "adventure"
	self._details_filled = true
end

LobbyBrowserConsoleUI._fill_weave_details = function (self, arg_41_1)
	-- function 41
	local weave = self._details_widgets.weave
	local selected_mission_id = arg_41_1.selected_mission_id
	local var_41_2 = WeaveSettings.templates[selected_mission_id]
	local find = table.find(WeaveSettings.templates_ordered, var_41_2)
	local wind = var_41_2.wind
	local var_41_5 = WindSettings[wind]
	local var_41_6 = Localize(var_41_5.display_name)
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(wind, 255)
	local thumbnail_icon = var_41_5.thumbnail_icon
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(thumbnail_icon).size
	local wind_icon = weave.wind_icon
	local content = wind_icon.content
	local texture_id = wind_icon.style.texture_id

	content.texture_id = thumbnail_icon
	texture_id.texture_size = {
		size[1] * 0.6,
		size[2] * 0.6
	}
	texture_id.horizontal_alignment = "center"
	texture_id.vertical_alignment = "center"
	weave.wind_icon_glow.style.texture_id.color = get_color_table_with_alpha
	weave.wind_icon_bg.style.texture_id.color = get_color_table_with_alpha

	local wind_name = weave.wind_name

	wind_name.content.text = var_41_6
	wind_name.style.text.text_color = get_color_table_with_alpha

	local mutator = var_41_5.mutator
	local var_41_15 = MutatorTemplates[mutator]
	local wind_mutator_icon = weave.wind_mutator_icon
	local wind_mutator_title_text = weave.wind_mutator_title_text
	local wind_mutator_description_text = weave.wind_mutator_description_text

	wind_mutator_icon.content.texture_id = var_41_15.icon
	wind_mutator_title_text.content.text = var_41_15.display_name
	wind_mutator_description_text.content.text = var_41_15.description

	local objectives = var_41_2.objectives
	local num = 10
	local num_2 = 0

	for i = 1, #objectives do
		local var_41_22 = objectives[i]
		local display_name = var_41_22.display_name
		local icon = var_41_22.icon

		self:_assign_objective(i, display_name, icon, num)
	end

	local str = "level_image_any"
	local display_name_2 = var_41_2.display_name

	if not arg_41_1 then
		-- Nothing
	end

	::label_41_0::

	local selected_mission_id_2 = arg_41_1.selected_mission_id

	selected_mission_id_2 = selected_mission_id_2 or arg_41_1.mission_id

	::label_41_1::

	local mechanism = arg_41_1.mechanism

	if not selected_mission_id_2 then
		local var_41_29 = selected_mission_id_2

		if mechanism == "weave" then
			local var_41_30 = WeaveSettings.templates[selected_mission_id_2]

			if not var_41_30 then
				var_41_29 = var_41_30.objectives[1].level_id
			end
		end

		if var_41_29 == "default_start_level" then
			var_41_29 = LevelSettingsDefaultStartLevel
		end

		str = LevelSettings[var_41_29].level_image or str
	end

	weave.level_image.content.texture_id = str

	local level_name = weave.level_name

	if arg_41_1.weave_quick_game == "true" then
		level_name.content.text = Localize(display_name_2)
	else
		level_name.content.text = find .. ". " .. Localize(display_name_2)
	end

	local tbl = {}

	if not arg_41_1 then
		local count = #SPProfiles

		for j = 1, count do
			if not ProfileSynchronizer.is_free_in_lobby(j, arg_41_1) then
				tbl[j] = true
			end
		end
	end

	local content_2 = weave.hero_tabs.content

	for k = 1, #ProfilePriority do
		local var_41_35 = ProfilePriority[k]
		local str_2 = "_" .. tostring(k)
		local var_41_37 = content_2["hotspot" .. str_2]

		if not tbl[var_41_35] then
			var_41_37.disable_button = true
		else
			var_41_37.disable_button = false
		end
	end

	local level_image_frame = weave.level_image_frame

	level_image_frame.content.texture_id = "map_frame_weaves"
	level_image_frame.style.texture_id.color = get_color_table_with_alpha

	local button_hotspot = self._widgets.join_button.content.button_hotspot
	local content_3 = weave.locked_reason.content

	if not arg_41_1 then
		local is_lobby_joinable, var_41_42 = self._parent:is_lobby_joinable(arg_41_1)

		content_3.text = var_41_42 or "tutorial_no_text"
		button_hotspot.disable_button = not is_lobby_joinable
	else
		content_3.text = "tutorial_no_text"
		button_hotspot.disable_button = true
	end

	local content_4 = weave.details_information.content

	if not arg_41_1 then
		local tbl_2 = {
			event = "lb_game_type_event",
			deed = "lb_game_type_deed",
			tutorial = "lb_game_type_prologue",
			weave = "lb_game_type_weave",
			custom = "lb_game_type_custom",
			standard = "lb_game_type_quick_play",
			weave_quick_play = "lb_game_type_weave_quick_play",
			["n/a"] = "lb_game_type_none",
			deus = "area_selection_morris_name"
		}
		local mechanism_2 = arg_41_1.mechanism
		local matchmaking_type = arg_41_1.matchmaking_type
		local flag = not IS_PS4 and matchmaking_type and NetworkLookup.matchmaking_types[tonumber(matchmaking_type)]
		local mission_id = arg_41_1.mission_id
		local var_41_49 = mission_id

		if mechanism_2 == "weave" then
			local var_41_50 = WeaveSettings.templates[mission_id]

			if not var_41_50 then
				var_41_49 = var_41_50.objectives[1].level_id
			end

			if arg_41_1.weave_quick_game == "true" then
				flag = "weave_quick_play"
			end
		elseif mechanism_2 == "deus" then
			flag = "deus"
		end

		local var_41_51 = LevelSettings[var_41_49]
		local var_41_52

		if not flag then
			var_41_52 = tbl_2[flag]

			if not var_41_52 then
				var_41_52 = "lb_unknown"
			end
		else
			var_41_52 = "lb_game_type_none"
		end

		content_4.game_type_id = var_41_52

		local flag_2

		flag_2 = not var_41_51.hub_level and "lb_in_inn" and "lb_playing"
		content_4.status_id = flag_2
	else
		content_4.game_type_id = "lb_unknown"
		content_4.status_id = "lb_unknown"
	end

	self._details_type = "weave"
	self._details_filled = true
end

LobbyBrowserConsoleUI._gather_unlocked_journeys = function (arg_42_0)
	-- function 42
	local tbl = {}
	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()

	for i, v in ipairs(LevelUnlockUtils.unlocked_journeys(statistics_db, stats_id)) do
		tbl[v] = true
	end

	return tbl
end

LobbyBrowserConsoleUI._fill_deus_details = function (self, arg_43_1)
	-- function 43
	local _gather_unlocked_journeys, var_43_1 = self:_gather_unlocked_journeys()
	local deus = self._details_widgets.deus
	local str = "level_image_any"
	local var_43_4

	if not arg_43_1 then
		-- Nothing
	end

	::label_43_0::

	local selected_mission_id = arg_43_1.selected_mission_id

	selected_mission_id = selected_mission_id or arg_43_1.mission_id

	::label_43_1::

	local flag = not arg_43_1 and arg_43_1.matchmaking_type
	local flag_2 = not flag and not IS_PS4 and flag and NetworkLookup.matchmaking_types[tonumber(flag)]
	local flag_3 = not arg_43_1 and arg_43_1.mechanism
	local var_43_9 = selected_mission_id
	local var_43_10 = DeusJourneySettings[var_43_9]
	local content = deus.expedition_icon.content

	content.level_icon = var_43_10.level_image
	content.locked = not _gather_unlocked_journeys[var_43_9]

	local dominant_god = Managers.backend:get_interface("deus"):get_journey_cycle().journey_data[var_43_9].dominant_god

	content.theme_icon = DeusThemeSettings[dominant_god].icon
	deus.level_name.content.text = Localize(var_43_10.display_name)

	local tbl = {}

	if not arg_43_1 then
		local count = #SPProfiles

		for i = 1, count do
			if not ProfileSynchronizer.is_free_in_lobby(i, arg_43_1) then
				tbl[i] = true
			end
		end
	end

	local content_2 = deus.hero_tabs.content

	for j = 1, #ProfilePriority do
		local var_43_16 = ProfilePriority[j]
		local str_2 = "_" .. tostring(j)
		local var_43_18 = content_2["hotspot" .. str_2]

		if not tbl[var_43_16] then
			var_43_18.disable_button = true
		else
			var_43_18.disable_button = false
		end
	end

	local button_hotspot = self._widgets.join_button.content.button_hotspot
	local content_3 = deus.locked_reason.content

	if not arg_43_1 then
		local is_lobby_joinable, var_43_22 = self._parent:is_lobby_joinable(arg_43_1)

		content_3.text = var_43_22 or "tutorial_no_text"
		button_hotspot.disable_button = not is_lobby_joinable
	else
		content_3.text = "tutorial_no_text"
		button_hotspot.disable_button = true
	end

	local content_4 = deus.details_information.content

	if not arg_43_1 then
		local tbl_2 = {
			event = "lb_game_type_event",
			deed = "lb_game_type_deed",
			tutorial = "lb_game_type_prologue",
			weave = "lb_game_type_weave",
			deus_weekly = "cw_weekly_expedition_name_long",
			custom = "lb_game_type_custom",
			standard = "lb_game_type_quick_play",
			weave_quick_play = "lb_game_type_weave_quick_play",
			["n/a"] = "lb_game_type_none",
			deus = "area_selection_morris_name"
		}
		local mission_id = arg_43_1.mission_id
		local var_43_26 = mission_id

		if flag_3 == "weave" then
			local var_43_27 = WeaveSettings.templates[mission_id]

			if not var_43_27 then
				var_43_26 = var_43_27.objectives[1].level_id
			end

			if arg_43_1.weave_quick_game == "true" then
				flag_2 = "weave_quick_play"
			else
				flag_2 = "weave"
			end
		elseif flag_3 == "deus" then
			flag_2 = flag_2 ~= "event" or not "deus_weekly" or "deus"
		end

		local var_43_28 = LevelSettings[var_43_26]
		local var_43_29

		if not flag_2 then
			var_43_29 = tbl_2[flag_2]

			if not var_43_29 then
				var_43_29 = "lb_unknown"
			end
		else
			var_43_29 = "lb_game_type_none"
		end

		content_4.game_type_id = var_43_29

		local flag_4

		flag_4 = not var_43_28.hub_level and "lb_in_inn" and "lb_playing"
		content_4.status_id = flag_4
	else
		content_4.game_type_id = "lb_unknown"
		content_4.status_id = "lb_unknown"
	end

	deus.twitch_logo.content.visible = to_boolean(not arg_43_1 and arg_43_1.twitch_enabled)
	self._details_type = "deus"
	self._details_filled = true
end

LobbyBrowserConsoleUI._assign_objective = function (self, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	-- function 44
	local str = "objective_" .. arg_44_1
	local var_44_1 = self._details_widgets.weave[str]
	local content = var_44_1.content
	local style = var_44_1.style

	content.icon = arg_44_3 or "trial_gem"
	content.text = arg_44_2 or "-"
end

LobbyBrowserConsoleUI.set_game_type_filter = function (arg_45_0, arg_45_1)
	-- function 45
	arg_45_0._widgets.filter_frame.content.game_type_name = arg_45_1
end

LobbyBrowserConsoleUI.set_level_filter = function (arg_46_0, arg_46_1)
	-- function 46
	arg_46_0._widgets.filter_frame.content.mission_name = arg_46_1
end

LobbyBrowserConsoleUI.set_difficulty_filter = function (arg_47_0, arg_47_1)
	-- function 47
	arg_47_0._widgets.filter_frame.content.difficulty_name = arg_47_1
end

LobbyBrowserConsoleUI.set_show_lobbies_filter = function (arg_48_0, arg_48_1)
	-- function 48
	arg_48_0._widgets.filter_frame.content.show_lobbies_name = arg_48_1
end

LobbyBrowserConsoleUI.set_distance_filter = function (arg_49_0, arg_49_1)
	-- function 49
	arg_49_0._widgets.filter_frame.content.distance_name = arg_49_1
end

LobbyBrowserConsoleUI._draw = function (self, arg_50_1, arg_50_2)
	-- function 50
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_manager = self._input_manager
	local _render_settings = self._render_settings
	local input_service = self._parent:input_service()
	local var_50_5

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, input_service, arg_50_1, nil, _render_settings)

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	if not self._filter_active then
		self:_render_filter(_ui_renderer, _ui_scenegraph, input_service, arg_50_1, arg_50_2)
	end

	self:_render_lobby_browser(_ui_renderer, _ui_scenegraph, input_service, arg_50_1)
	UIRenderer.end_pass(_ui_renderer)

	if not self._scrollbar_ui then
		self._scrollbar_ui:update(arg_50_1, arg_50_2, _ui_renderer, input_service, _render_settings)
	end
end

LobbyBrowserConsoleUI._render_filter = function (self, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	-- function 51
	if not self._current_active_filter then
		self[self._filter_functions[self._current_active_filter].render_function](self, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	end
end

LobbyBrowserConsoleUI._render_game_type_filter_list = function (self, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	-- function 52
	for i, v in ipairs(self._game_type_filter_widgets) do
		UIRenderer.draw_widget(arg_52_1, v)
	end
end

LobbyBrowserConsoleUI._render_level_filter_list = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	-- function 53
	for i, v in ipairs(self._level_filter_widgets) do
		UIRenderer.draw_widget(arg_53_1, v)
	end

	UIRenderer.draw_widget(arg_53_1, self._level_filter_scroller)
end

LobbyBrowserConsoleUI._render_difficulty_filter_list = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	-- function 54
	for i, v in ipairs(self._difficulty_filter_widgets) do
		UIRenderer.draw_widget(arg_54_1, v)
	end
end

LobbyBrowserConsoleUI._render_lobby_filter_list = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5)
	-- function 55
	for i, v in ipairs(self._lobby_filter_widgets) do
		UIRenderer.draw_widget(arg_55_1, v)
	end
end

LobbyBrowserConsoleUI._render_distance_filter_list = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5)
	-- function 56
	for i, v in ipairs(self._distance_filter_widgets) do
		UIRenderer.draw_widget(arg_56_1, v)
	end
end

LobbyBrowserConsoleUI._render_lobby_browser = function (self, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5)
	-- function 57
	local element_settings = var_0_0.element_settings

	for i, v in ipairs(self._lobby_entry_widgets) do
		if not self:_is_inside(v, element_settings, i) then
			UIRenderer.draw_widget(arg_57_1, v)
		end
	end

	if not self._details_filled then
		local var_57_1 = self._details_widgets[self._details_type]

		for k, v_2 in pairs(var_57_1) do
			UIRenderer.draw_widget(arg_57_1, v_2)
		end

		local var_57_2 = self._dynamic_details_widgets[self._details_type]

		for k_2, v_3 in pairs(var_57_2) do
			UIRenderer.draw_widget(arg_57_1, v_3)
		end
	end

	for i_2, v_4 in ipairs(self._empty_lobby_entry_widgets) do
		UIRenderer.draw_widget(arg_57_1, v_4)
	end
end

LobbyBrowserConsoleUI._is_inside = function (self, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	local height = arg_58_2.height
	local window_height = arg_58_2.window_height
	local num = self._ui_scenegraph.lobby_entry_anchor.position[2] + arg_58_1.offset[2]
	local num_2 = num + height
	local num_3 = 0
	local num_4 = -window_height

	return not (num < num_3) or num_4 < num_2
end

LobbyBrowserConsoleUI.destroy = function (arg_59_0)
	-- function 59
	return
end
