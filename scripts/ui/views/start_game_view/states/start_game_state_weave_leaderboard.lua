-- chunkname: @scripts/ui/views/start_game_view/states/start_game_state_weave_leaderboard.lua

require("scripts/helpers/weave_utils")

local var_0_0 = local_require("scripts/ui/views/start_game_view/states/definitions/start_game_state_weave_leaderboard_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local console_cursor_definition = var_0_0.console_cursor_definition
local generic_input_actions = var_0_0.generic_input_actions
local flag = false
local num = 20
local num_2 = 4
local num_3 = 800
local num_4 = 12
local num_5 = 0.3
local num_6 = 1.5
local tbl = {
	Localize("menu_weave_leaderboard_tier_3_title"),
	Localize("menu_weave_leaderboard_tier_2_title"),
	Localize("menu_weave_leaderboard_tier_1_title")
}
local tbl_2 = {
	Localize("menu_weave_leaderboard_tier_tooltip_bronze"),
	Localize("menu_weave_leaderboard_tier_tooltip_silver"),
	Localize("menu_weave_leaderboard_tier_tooltip_gold")
}
local tbl_3 = {
	Localize("menu_weave_leaderboard_button_refresh_2"),
	Localize("menu_weave_leaderboard_button_refresh_1")
}

StartGameStateWeaveLeaderboard = class(StartGameStateWeaveLeaderboard)
StartGameStateWeaveLeaderboard.NAME = "StartGameStateWeaveLeaderboard"

StartGameStateWeaveLeaderboard.on_enter = function (self, arg_1_1)
	-- function 1
	print("[StartGameState] Enter Substate StartGameStateWeaveLeaderboard")

	self.parent = arg_1_1.parent
	self._gamepad_style_active = false
	self._wwise_world = arg_1_1.wwise_world
	self._hero_name = arg_1_1.hero_name

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	self._network_lobby = ingame_ui_context.network_lobby
	self._stats_id = Managers.player:local_player():stats_id()
	self._animations = {}
	self._ui_animations = {}
	self._is_open = true
	self._close_on_exit = true

	self:_create_ui_elements(arg_1_1)

	if not arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		self:_start_transition_animation("on_enter", "on_enter")
	end

	if not self._gamepad_style_active then
		self:disable_player_world()
	end

	local tbl = {
		{
			value = "friends",
			text = Localize("menu_weave_leaderboard_filter_option_friends")
		},
		{
			value = "global",
			text = Localize("menu_weave_leaderboard_filter_option_global")
		}
	}
	local tbl_2 = {
		{
			value = "personal",
			text = Localize("menu_weave_leaderboard_filter_option_you")
		},
		{
			value = "top",
			text = Localize("menu_weave_leaderboard_filter_option_top")
		}
	}
	local tbl_3 = {
		{
			value = 1,
			text = Localize("menu_weave_leaderboard_filter_option_players_1")
		},
		{
			value = 2,
			text = Localize("menu_weave_leaderboard_filter_option_players_2")
		},
		{
			value = 3,
			text = Localize("menu_weave_leaderboard_filter_option_players_3")
		},
		{
			value = 4,
			text = Localize("menu_weave_leaderboard_filter_option_players_4")
		}
	}
	local tbl_4 = {}
	local tbl_5 = {}
	local str = ""
	local var_1_7 = Localize("menu_weave_leaderboard_filter_sesason")

	self._current_season_id = ScorpionSeasonalSettings.current_season_id

	for i = 1, self._current_season_id do
		tbl_4[i] = {
			ScorpionSeasonalSettings.get_leaderboard_stat_for_season(i, 1),
			ScorpionSeasonalSettings.get_leaderboard_stat_for_season(i, 2),
			ScorpionSeasonalSettings.get_leaderboard_stat_for_season(i, 3),
			ScorpionSeasonalSettings.get_leaderboard_stat_for_season(i, 4)
		}

		if i == self._current_season_id then
			str = Localize("menu_weave_leaderboard_current_season")
		else
			str = string.format(var_1_7, i)
		end

		tbl_5[i] = {
			text = str,
			value = i
		}
	end

	self._season_data = tbl_5
	self._season_stat_data = tbl_4
	self._team_size_data = tbl_3
	self._filter_data = tbl_2
	self._leaderboard_tab_data = tbl

	self:_setup_tab_widget(tbl)
	self:_select_tab_by_index(1)
	self:_initialize_stepper(1, Localize("menu_weave_leaderboard_filter_title_position"), tbl_2)
	self:_initialize_stepper(2, Localize("menu_weave_leaderboard_filter_title_team_size"), tbl_3, #tbl_3)

	if not IS_WINDOWS then
		self:_initialize_stepper(3, Localize("menu_weave_leaderboard_filter_season"), tbl_5, #tbl_5)
	end

	self:_restart_poll_queue(Managers.time:time("ui"))
	self:_update_leaderboard_presentation()
	Managers.input:enable_gamepad_cursor()
	self:play_sound("menu_leaderboard_open")
end

StartGameStateWeaveLeaderboard._setup_poll_queue = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self._poll_queues = {}

	for i, v in ipairs(arg_2_1) do
		local value = v.value

		for i_2, v_2 in ipairs(arg_2_2) do
			local value_2 = v_2.value

			for i4 = #arg_2_3, 1, -1 do
				local var_2_2 = i4
				local var_2_3 = arg_2_3[i4]

				for i5 = #var_2_3, 1, -1 do
					local var_2_4 = var_2_3[i5]

					self:_add_poll_queue(value_2, value, var_2_4, var_2_2)
				end
			end
		end
	end
end

StartGameStateWeaveLeaderboard._restart_poll_queue = function (self, arg_3_1)
	-- function 3
	self._cashed_list_season_data = {}

	self:_setup_poll_queue(self._leaderboard_tab_data, self._filter_data, self._season_stat_data)
	self:_handle_next_poll_request(arg_3_1)
end

StartGameStateWeaveLeaderboard._add_poll_queue = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not (not IS_WINDOWS and arg_4_4 == self._current_season_id) then
		return
	end

	local _leaderboard_tab_data = self._leaderboard_tab_data
	local var_4_1

	for i = 1, #_leaderboard_tab_data do
		if _leaderboard_tab_data[i].value == arg_4_2 then
			var_4_1 = i

			break
		end
	end

	if not var_4_1 then
		local _poll_queues = self._poll_queues
		local var_4_3 = _poll_queues[var_4_1]

		var_4_3 = var_4_3 or {}
		_poll_queues[var_4_1] = var_4_3
		var_4_3[#var_4_3 + 1] = {
			filter_value = arg_4_1,
			leaderboard_type = arg_4_2,
			stat_name = arg_4_3,
			season_id = arg_4_4
		}
	end

	self._polling_done = false
end

StartGameStateWeaveLeaderboard._handle_next_poll_request = function (self, arg_5_1)
	-- function 5
	if not self._polling_done then
		return true
	end

	local _poll_queues = self._poll_queues
	local _selected_option_tab_index = self._selected_option_tab_index

	_selected_option_tab_index = _selected_option_tab_index or 1

	local var_5_2

	if not (not _selected_option_tab_index and not (#_poll_queues[_selected_option_tab_index] > 0)) then
		local var_5_3 = _poll_queues[_selected_option_tab_index]
		local var_5_4

		for i = 1, #var_5_3 do
			local var_5_5 = var_5_3[i]
			local leaderboard_type = var_5_5.leaderboard_type
			local filter_value = var_5_5.filter_value
			local stat_name = var_5_5.stat_name

			if not (self._stat_name ~= stat_name or self._filter_value ~= filter_value or self._leaderboard_type ~= leaderboard_type) then
				var_5_4 = i

				break
			else
				var_5_4 = var_5_4 or i
			end
		end

		var_5_2 = table.remove(var_5_3, var_5_4)
	else
		for j = 1, #_poll_queues do
			local var_5_9 = _poll_queues[j]

			if #var_5_9 > 0 then
				var_5_2 = table.remove(var_5_9, 1)

				break
			end
		end
	end

	if not var_5_2 then
		self._polling_done = true

		return
	end

	local filter_value_2 = var_5_2.filter_value
	local leaderboard_type_2 = var_5_2.leaderboard_type
	local stat_name_2 = var_5_2.stat_name
	local season_id = var_5_2.season_id
	local get_interface = Managers.backend:get_interface("weaves")

	if filter_value_2 == "top" then
		local num = 0

		get_interface:request_leaderboard(stat_name_2, num, leaderboard_type_2)
	elseif filter_value_2 == "personal" then
		local num_2 = 100

		get_interface:request_leaderboard_around_player(stat_name_2, leaderboard_type_2, num_2)
	end

	self._polling_callback = callback(self, "_cb_cashe_list_data", filter_value_2, leaderboard_type_2, stat_name_2, season_id)
	self._min_poll_time = Managers.time:time("ui") + num_6
end

StartGameStateWeaveLeaderboard._update_leaderboard_presentation = function (self)
	-- function 6
	local var_6_0
	local var_6_1
	local var_6_2
	local var_6_3
	local _stepper_settings = self._stepper_settings

	if not _stepper_settings then
		for i = 1, #_stepper_settings do
			local var_6_5 = _stepper_settings[i]
			local content = var_6_5.content
			local read_index = var_6_5.read_index
			local stepper_name = var_6_5.stepper_name
			local value = content[read_index].value

			if stepper_name == "setting_stepper_1" then
				var_6_1 = value
			end

			if stepper_name == "setting_stepper_2" then
				var_6_0 = value
			end

			if stepper_name == "setting_stepper_3" then
				var_6_2 = value
			end
		end
	end

	local _selected_option_tab_index = self._selected_option_tab_index
	local value_2 = self._leaderboard_tab_data[_selected_option_tab_index].value

	self._filter_value = var_6_1
	self._current_season_id = var_6_2 or self._current_season_id
	self._stat_name = self._season_stat_data[self._current_season_id][var_6_0]
	self._leaderboard_type = value_2

	local _get_cashed_list_data = self:_get_cashed_list_data(var_6_1, value_2, self._stat_name, self._current_season_id)
	local flag = _get_cashed_list_data == nil
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.loading_icon.content.visible = flag
	_widgets_by_name.refresh_button.content.button_hotspot.disable_button = flag

	if not flag then
		local var_6_15 = _get_cashed_list_data[1]
		local var_6_16 = _get_cashed_list_data[2]
		local flag_2 = false

		if var_6_1 == "personal" then
			flag_2 = not self:_list_including_local_player(var_6_15)
		end

		if not flag_2 then
			self:_populate_list(nil, flag_2)
		else
			self:_populate_list(var_6_15, flag_2)
		end

		self:_set_refresh_time(var_6_16)
	else
		self:_set_refresh_time(nil)
	end

	self._waiting_for_list = flag
end

StartGameStateWeaveLeaderboard._list_including_local_player = function (arg_7_0, arg_7_1)
	-- function 7
	if not arg_7_1 then
		for i = 1, #arg_7_1 do
			if not arg_7_1[i].local_player then
				return true
			end
		end
	end

	return false
end

StartGameStateWeaveLeaderboard._get_cashed_list_data = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local var_8_0 = self._cashed_list_season_data[arg_8_4]

	if not (not var_8_0 and not var_8_0[arg_8_1] and var_8_0[arg_8_1][arg_8_2]) then
		return nil
	end

	return var_8_0[arg_8_1][arg_8_2][arg_8_3]
end

StartGameStateWeaveLeaderboard._cb_cashe_list_data = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	-- function 9
	if not arg_9_6 then
		self:_add_poll_queue(arg_9_1, arg_9_2, arg_9_3)

		return
	end

	local _cashed_list_season_data = self._cashed_list_season_data

	if not _cashed_list_season_data[arg_9_4] then
		_cashed_list_season_data[arg_9_4] = {}
	end

	local var_9_1 = _cashed_list_season_data[arg_9_4]

	if not var_9_1[arg_9_1] then
		var_9_1[arg_9_1] = {}
	end

	if not var_9_1[arg_9_1][arg_9_2] then
		var_9_1[arg_9_1][arg_9_2] = {}
	end

	if not var_9_1[arg_9_1][arg_9_2][arg_9_3] then
		var_9_1[arg_9_1][arg_9_2][arg_9_3] = {}
	end

	var_9_1[arg_9_1][arg_9_2][arg_9_3] = {
		arg_9_5,
		Managers.time:time("ui")
	}

	if not (arg_9_2 ~= "global" or arg_9_1 ~= "personal") then
		local var_9_2

		for i = 1, #arg_9_5 do
			local var_9_3 = arg_9_5[i]

			if not var_9_3.local_player then
				local clone = table.clone(var_9_3)

				break
			end
		end
	end

	if not self._waiting_for_list then
		local flag = self._stat_name == arg_9_3
		local flag_2 = self._leaderboard_type == arg_9_2
		local flag_3 = self._filter_value == arg_9_1

		if not flag and not flag_2 and not flag_3 then
			self:_update_leaderboard_presentation()
		end
	end
end

StartGameStateWeaveLeaderboard._poll_list = function (self, arg_10_1, arg_10_2)
	-- function 10
	local get_interface = Managers.backend:get_interface("weaves")

	if not self._polling_callback then
		if not get_interface:is_requesting_leaderboard() then
			return
		elseif arg_10_2 < self._min_poll_time then
			return
		end
	else
		return
	end

	local has_leaderboard_request_failed = get_interface:has_leaderboard_request_failed()
	local get_leaderboard_entries = get_interface:get_leaderboard_entries()
	local _create_list_entries = self:_create_list_entries(get_leaderboard_entries)

	if not self._polling_callback then
		self._polling_callback(_create_list_entries, has_leaderboard_request_failed)

		self._polling_callback = nil
	end

	self:_handle_next_poll_request(arg_10_2)
end

StartGameStateWeaveLeaderboard._set_refresh_time = function (self, arg_11_1)
	-- function 11
	self._refreshed_at_time = arg_11_1

	self:_update_refresh_time(arg_11_1)
end

StartGameStateWeaveLeaderboard._update_refresh_time = function (self, arg_12_1)
	-- function 12
	local _refreshed_at_time = self._refreshed_at_time
	local content = self._widgets_by_name.refresh_text.content

	content.visible = _refreshed_at_time ~= nil

	if not _refreshed_at_time then
		local num = arg_12_1 - _refreshed_at_time
		local max = math.max(num, 0)
		local max_2 = math.max(max, 0)
		local floor = math.floor(max_2 / 60)
		local floor_2 = math.floor(floor / 60)
		local floor_3 = math.floor(floor_2 / 24)
		local var_12_8

		if floor > 0 then
			var_12_8 = string.format(tbl_3[1], floor)
		else
			var_12_8 = tbl_3[2]
		end

		content.text = var_12_8
	end
end

StartGameStateWeaveLeaderboard._initialize_stepper = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local _stepper_settings = self._stepper_settings

	_stepper_settings = _stepper_settings or {}
	self._stepper_settings = _stepper_settings

	local _stepper_settings_2 = self._stepper_settings
	local str = "setting_stepper_" .. arg_13_1
	local var_13_3 = self._widgets_by_name[str]

	arg_13_4 = arg_13_4 or 1
	_stepper_settings_2[arg_13_1] = {
		stepper_name = str,
		title_text = arg_13_2,
		content = arg_13_3,
		read_index = arg_13_4,
		widget = var_13_3
	}
	var_13_3.content.title_text = arg_13_2

	self:_set_stepper_read_index(arg_13_1, arg_13_4)
end

StartGameStateWeaveLeaderboard._set_stepper_read_index = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0 = self._stepper_settings[arg_14_1]
	local content = var_14_0.content

	var_14_0.read_index = arg_14_2

	local var_14_2 = content[arg_14_2]

	var_14_0.widget.content.setting_text = var_14_2.text
end

StartGameStateWeaveLeaderboard._on_stepper_pressed = function (arg_15_0, arg_15_1)
	-- function 15
	local content = arg_15_1.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if button_hotspot_left.on_pressed or not button_hotspot_left.on_double_click then
		return -1
	elseif button_hotspot_right.on_pressed or not button_hotspot_right.on_double_click then
		return 1
	end
end

StartGameStateWeaveLeaderboard._create_ui_elements = function (self, arg_16_1)
	-- function 16
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._console_cursor_widget = UIWidget.init(console_cursor_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		if not v then
			local var_16_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_16_2
			tbl_2[k] = var_16_2
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	tbl_2.loading_icon.content.visible = false

	self:_setup_list_widget()
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local list_scrollbar = self._widgets_by_name.list_scrollbar

	self._scrollbar_logic = ScrollBarLogic:new(list_scrollbar)

	local num = UILayer.default + 30
	local input_service = self:input_service()
	local _gamepad_style_active = self._gamepad_style_active

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, input_service, 6, num, generic_input_actions.default, _gamepad_style_active)

	self._menu_input_description:set_input_description(nil)

	self._widgets_by_name.no_placement_text.content.visible = false
end

StartGameStateWeaveLeaderboard._setup_tab_widget = function (self, arg_17_1)
	-- function 17
	local count = #arg_17_1
	local _widgets = self._widgets
	local _widgets_by_name = self._widgets_by_name
	local var_17_3 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_vertical", {
		5,
		35
	}, "option_tabs_segments", count - 1))
	local var_17_4 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_top", {
		17,
		9
	}, "option_tabs_segments_top", count - 1))
	local var_17_5 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_bottom", {
		17,
		9
	}, "option_tabs_segments_bottom", count - 1))

	_widgets_by_name.option_tabs_segments = var_17_3
	_widgets_by_name.option_tabs_segments_top = var_17_4
	_widgets_by_name.option_tabs_segments_bottom = var_17_5
	_widgets[#_widgets + 1] = var_17_3
	_widgets[#_widgets + 1] = var_17_4
	_widgets[#_widgets + 1] = var_17_5

	local str = "option_tabs"
	local size = scenegraph_definition.option_tabs.size
	local create_default_text_tabs = UIWidgets.create_default_text_tabs(str, size, count)
	local var_17_9 = UIWidget.init(create_default_text_tabs)

	_widgets_by_name[str] = var_17_9
	_widgets[#_widgets + 1] = var_17_9

	local content = var_17_9.content

	for i, v in ipairs(arg_17_1) do
		local str_2 = "_" .. tostring(i)
		local str_3 = "hotspot" .. str_2
		local str_4 = "text" .. str_2
		local var_17_14 = content[str_3]
		local value

		var_17_14[str_4], value = v.text, v.value
		var_17_14.index = i
		var_17_14.value = value
	end
end

StartGameStateWeaveLeaderboard.disable_player_world = function (self)
	-- function 18
	if not self._player_world_disabled then
		self._player_world_disabled = true

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.deactivate_viewport(world, viewport)
	end
end

StartGameStateWeaveLeaderboard.enable_player_world = function (self)
	-- function 19
	if not self._player_world_disabled then
		self._player_world_disabled = false

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.activate_viewport(world, viewport)
	end
end

StartGameStateWeaveLeaderboard.close_on_exit = function (self)
	-- function 20
	return self._close_on_exit
end

StartGameStateWeaveLeaderboard.transitioning = function (self)
	-- function 21
	if not self.exiting then
		return true
	else
		return false
	end
end

StartGameStateWeaveLeaderboard._wanted_state = function (self)
	-- function 22
	return (self.parent:wanted_state())
end

StartGameStateWeaveLeaderboard.wanted_menu_state = function (self)
	-- function 23
	return self._wanted_menu_state
end

StartGameStateWeaveLeaderboard.clear_wanted_menu_state = function (self)
	-- function 24
	self._wanted_menu_state = nil
end

StartGameStateWeaveLeaderboard.hotkey_allowed = function (arg_25_0)
	-- function 25
	return true
end

StartGameStateWeaveLeaderboard.on_exit = function (self, arg_26_1)
	-- function 26
	print("[StartGameState] Exit Substate StartGameStateWeaveLeaderboard")

	self.ui_animator = nil
	self._is_open = false

	if not self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false)
	end

	if not self._gamepad_style_active then
		self:enable_player_world()
	end

	Managers.input:disable_gamepad_cursor()
	self:play_sound("menu_leaderboard_close")

	self._polling_callback = nil
end

StartGameStateWeaveLeaderboard._update_transition_timer = function (self, arg_27_1)
	-- function 27
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_27_1, 0)
	end
end

StartGameStateWeaveLeaderboard.input_service = function (self)
	-- function 28
	return self.parent:input_service()
end

StartGameStateWeaveLeaderboard.update = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	local _input_manager = self._input_manager
	local input_service = self.parent:input_service()

	self:_poll_list(arg_29_1, arg_29_2)
	self:_update_transition_timer(arg_29_1)
	self:_update_scroll_position(arg_29_1)
	self:_update_visible_list_entries()
	self._scrollbar_logic:update(arg_29_1, arg_29_2)
	self:_update_refresh_time(arg_29_2)
	self:draw(input_service, arg_29_1)

	local _wanted_state = self:_wanted_state()

	if self._transition_timer or _wanted_state or not self._new_state then
		self.parent:clear_wanted_state()

		return _wanted_state or self._new_state
	end
end

StartGameStateWeaveLeaderboard.post_update = function (self, arg_30_1, arg_30_2)
	-- function 30
	self.ui_animator:update(arg_30_1)
	self:_update_animations(arg_30_1)

	if not (self.parent:transitioning() or self._transition_timer) then
		self:_handle_input(arg_30_1, arg_30_2)
	end
end

StartGameStateWeaveLeaderboard._update_animations = function (self, arg_31_1)
	-- function 31
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_31_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name
	local exit_button = _widgets_by_name.exit_button
	local refresh_button = _widgets_by_name.refresh_button

	UIWidgetUtils.animate_default_button(exit_button, arg_31_1)

	local option_tabs = _widgets_by_name.option_tabs

	UIWidgetUtils.animate_default_text_tabs(option_tabs, arg_31_1)
end

StartGameStateWeaveLeaderboard._is_button_hover_enter = function (arg_32_0, arg_32_1)
	-- function 32
	return arg_32_1.content.button_hotspot.on_hover_enter
end

StartGameStateWeaveLeaderboard._is_inventory_tab_pressed = function (self)
	-- function 33
	local content = self._widgets_by_name.option_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)
		local var_33_3 = content["hotspot" .. str]

		if not (not var_33_3.on_release and var_33_3.is_selected) then
			return i
		end
	end
end

StartGameStateWeaveLeaderboard._select_tab_by_index = function (self, arg_34_1)
	-- function 34
	local content = self._widgets_by_name.option_tabs.content
	local amount = content.amount

	for i = 1, amount do
		local str = "_" .. tostring(i)

		content["hotspot" .. str].is_selected = arg_34_1 == i
	end

	self._selected_option_tab_index = arg_34_1
end

StartGameStateWeaveLeaderboard._handle_input = function (self, arg_35_1, arg_35_2)
	-- function 35
	local _widgets_by_name = self._widgets_by_name
	local input_service = self.parent:input_service()
	local get = input_service:get("toggle_menu", true)
	local flag = not Managers.input:is_device_active("gamepad") and input_service:get("back_menu", true)
	local _close_on_exit = self._close_on_exit
	local exit_button = _widgets_by_name.exit_button
	local refresh_button = _widgets_by_name.refresh_button

	if self:_is_button_hover_enter(exit_button) or not self:_is_button_hover_enter(refresh_button) then
		self:play_sound("Play_hud_hover")
	end

	local _is_inventory_tab_pressed = self:_is_inventory_tab_pressed()
	local flag_2 = false

	if not (not _is_inventory_tab_pressed and _is_inventory_tab_pressed == self._selected_option_tab_index) then
		self:_select_tab_by_index(_is_inventory_tab_pressed)
		self:play_sound("Play_hud_hover")

		flag_2 = true
	end

	local _stepper_settings = self._stepper_settings

	if not _stepper_settings then
		for i = 1, #_stepper_settings do
			local var_35_10 = _stepper_settings[i]
			local widget = var_35_10.widget
			local _on_stepper_pressed = self:_on_stepper_pressed(widget)

			if not _on_stepper_pressed then
				local read_index = var_35_10.read_index
				local content = var_35_10.content
				local index_wrapper = math.index_wrapper(read_index + _on_stepper_pressed, #content)

				self:_set_stepper_read_index(i, index_wrapper)
				self:play_sound("Play_hud_hover")

				flag_2 = true
			end
		end
	end

	if self:_is_button_pressed(refresh_button) or not input_service:get("special_1") then
		self:play_sound("Play_hud_select")
		self:_restart_poll_queue(arg_35_2)

		flag_2 = true
	elseif not _close_on_exit and flag and get and not self:_is_button_pressed(exit_button) then
		self:close_menu()

		return
	end

	if not flag_2 then
		self:_update_leaderboard_presentation()
	end
end

StartGameStateWeaveLeaderboard.close_menu = function (self, arg_36_1)
	-- function 36
	self.parent:close_menu(nil, arg_36_1)
end

StartGameStateWeaveLeaderboard.set_input_description = function (self, arg_37_1)
	-- function 37
	if not self._menu_input_description then
		return
	end

	fassert(not arg_37_1 and self._generic_input_actions[arg_37_1], "[StartGameStateWeaveLeaderboard:set_input_description] There is no such input_description (%s)", arg_37_1)
	self._menu_input_description:set_input_description(self._generic_input_actions[arg_37_1])
end

StartGameStateWeaveLeaderboard.change_generic_actions = function (self, arg_38_1)
	-- function 38
	if not self._menu_input_description then
		return
	end

	fassert(self._generic_input_actions[arg_38_1], "[StartGameStateWeaveLeaderboard:set_input_description] There is no such input_description (%s)", arg_38_1)
	self._menu_input_description:change_generic_actions(self._generic_input_actions[arg_38_1])
end

StartGameStateWeaveLeaderboard.draw = function (self, arg_39_1, arg_39_2)
	-- function 39
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_manager = self._input_manager
	local _render_settings = self._render_settings
	local is_device_active = _input_manager:is_device_active("gamepad")
	local var_39_6

	if not self._gamepad_style_active then
		UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, arg_39_1, arg_39_2, nil, _render_settings)

		local snap_pixel_positions = _render_settings.snap_pixel_positions
		local alpha_multiplier = _render_settings.alpha_multiplier

		for i, v in ipairs(self._widgets) do
			if v.snap_pixel_positions ~= nil then
				_render_settings.snap_pixel_positions = v.snap_pixel_positions
			end

			local alpha_multiplier_2 = v.alpha_multiplier

			alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_2

			UIRenderer.draw_widget(_ui_renderer, v)

			_render_settings.snap_pixel_positions = snap_pixel_positions
		end

		_render_settings.alpha_multiplier = alpha_multiplier

		local _list_entries = self._list_entries

		if not _list_entries then
			local _list_widget = self._list_widget
			local _list_draw_index = self._list_draw_index
			local _list_fade_in_time = self._list_fade_in_time
			local var_39_14

			if not _list_fade_in_time then
				local max = math.max(_list_fade_in_time - arg_39_2, 0)

				if max == 0 then
					self._list_fade_in_time = nil
				else
					self._list_fade_in_time = max
				end

				var_39_14 = 1 - max / num_5
			end

			if not _list_entries and not _list_widget and not _list_draw_index then
				local var_39_16 = _list_draw_index
				local min = math.min(_list_draw_index + num_4 + 1, #_list_entries)
				local num_3 = 0

				for k = var_39_16, min do
					num_3 = num_3 + 1

					local content = _list_widget.content
					local style = _list_widget.style
					local offset = _list_widget.offset
					local var_39_22 = content.size[2]

					offset[2] = -(num + (var_39_22 + num_2) * (k - 1))

					local var_39_23 = _list_entries[k]
					local name = var_39_23.name
					local weave = var_39_23.weave
					local score = var_39_23.score
					local ranking = var_39_23.ranking
					local career_icon = var_39_23.career_icon
					local real_ranking = var_39_23.real_ranking
					local local_player = var_39_23.local_player
					local platform_user_id = var_39_23.platform_user_id

					content.name = name
					content.score = score
					content.weave = weave
					content.ranking = ranking
					content.real_ranking = real_ranking
					content.career_icon = career_icon
					content.local_player = local_player

					if _list_widget.snap_pixel_positions ~= nil then
						_render_settings.snap_pixel_positions = _list_widget.snap_pixel_positions
					end

					if not var_39_14 then
						local easeInCubic = math.easeInCubic(math.min(var_39_14 + (min - k) * 0.05, 1))

						_render_settings.alpha_multiplier = easeInCubic
						offset[1] = -30 * (1 - easeInCubic)
					end

					UIRenderer.draw_widget(_ui_renderer, _list_widget)

					_render_settings.snap_pixel_positions = snap_pixel_positions
					_render_settings.alpha_multiplier = alpha_multiplier

					if IS_WINDOWS or not content.button_hotspot.is_hover then
						var_39_6 = generic_input_actions.open_profile

						if not arg_39_1:get("refresh_press") then
							self:_open_profile(platform_user_id)
						end
					end
				end
			end
		end

		UIRenderer.end_pass(_ui_renderer)
	end

	if not is_device_active then
		UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, arg_39_1, arg_39_2)
		UIRenderer.draw_widget(_ui_top_renderer, self._console_cursor_widget)
		UIRenderer.end_pass(_ui_top_renderer)

		if not (not self._menu_input_description and self.parent:active_view()) then
			self._menu_input_description:set_input_description(var_39_6)
			self._menu_input_description:draw(_ui_top_renderer, arg_39_2)
		end
	end
end

StartGameStateWeaveLeaderboard._open_profile = function (arg_40_0, arg_40_1)
	-- function 40
	if not arg_40_1 then
		return
	end

	if not IS_XB1 then
		XboxLive.show_gamercard(Managers.account:user_id(), arg_40_1)
	elseif not IS_PS4 then
		Managers.account:show_player_profile_with_account_id(arg_40_1)
	end
end

StartGameStateWeaveLeaderboard._is_button_pressed = function (arg_41_0, arg_41_1)
	-- function 41
	local content = arg_41_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameStateWeaveLeaderboard.play_sound = function (self, arg_42_1)
	-- function 42
	self.parent:play_sound(arg_42_1)
end

StartGameStateWeaveLeaderboard._start_transition_animation = function (self, arg_43_1, arg_43_2)
	-- function 43
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_43_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_43_1] = start_animation
end

StartGameStateWeaveLeaderboard.set_fullscreen_effect_enable_state = function (self, arg_44_1)
	-- function 44
	local world = self._ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_44_3 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_44_1 and 1 and 0

		set_scalar(var_44_3, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_44_7 = get_data
		local str_2 = "fullscreen_blur_amount"
		local flag_2

		flag_2 = not arg_44_1 and 0.75 and 0

		set_scalar_2(var_44_7, str_2, flag_2)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_44_1
end

StartGameStateWeaveLeaderboard._setup_list_widget = function (self)
	-- function 45
	local flag = true
	local str = "list_entry"
	local size = scenegraph_definition[str].size
	local create_leaderboard_entry_definition = UIWidgets.create_leaderboard_entry_definition(str, size, flag)

	self._list_widget = UIWidget.init(create_leaderboard_entry_definition)
end

StartGameStateWeaveLeaderboard._create_list_entries = function (arg_46_0, arg_46_1)
	-- function 46
	local tbl = {}
	local count = #arg_46_1

	for i = 1, count do
		local var_46_2 = arg_46_1[i]
		local career_name = var_46_2.career_name
		local var_46_4 = CareerSettings[career_name]
		local portrait_thumbnail

		if not var_46_4 then
			portrait_thumbnail = var_46_4.portrait_thumbnail

			if not portrait_thumbnail then
				-- Nothing
			end
		end

		portrait_thumbnail = "icons_placeholder"

		::label_46_0::

		local tbl_2 = {
			alpha_fade_in_delay = 0.4
		}
		local name = var_46_2.name

		name = name or "UNKNOWN"
		tbl_2.name = name
		tbl_2.weave = tostring(var_46_2.weave)
		tbl_2.score = UIUtils.comma_value(var_46_2.score)
		tbl_2.ranking = UIUtils.comma_value(var_46_2.ranking)
		tbl_2.career_name = career_name
		tbl_2.career_icon = portrait_thumbnail
		tbl_2.local_player = var_46_2.local_player
		tbl_2.real_ranking = var_46_2.real_ranking
		tbl_2.platform_user_id = var_46_2.platform_user_id
		tbl[i] = tbl_2
	end

	return tbl
end

StartGameStateWeaveLeaderboard._populate_list = function (self, arg_47_1, arg_47_2)
	-- function 47
	local count

	if not arg_47_1 then
		count = #arg_47_1

		if not count then
			-- Nothing
		end
	end

	count = 0

	::label_47_0::

	self._list_entries = arg_47_1

	self:_calculate_list_height(count)
	self:_initialize_scrollbar()

	self._list_draw_index = 1
	self._list_fade_in_time = num_5
	self._widgets_by_name.no_placement_text.content.visible = arg_47_2
end

StartGameStateWeaveLeaderboard._calculate_list_height = function (self, arg_48_1)
	-- function 48
	local var_48_0 = num
	local size = self._list_widget.content.size

	for i = 1, arg_48_1 do
		var_48_0 = var_48_0 + size[2]

		if i ~= arg_48_1 then
			var_48_0 = var_48_0 + num_2
		end
	end

	self._total_list_height = var_48_0 + num
end

StartGameStateWeaveLeaderboard._initialize_scrollbar = function (self)
	-- function 49
	local size = scenegraph_definition.list_mask.size
	local size_2 = scenegraph_definition.list_scrollbar.size
	local var_49_2 = size[2]
	local _total_list_height = self._total_list_height
	local var_49_4 = size_2[2]
	local num = 220 + num_2 * 1.5
	local num_3 = 1
	local _scrollbar_logic = self._scrollbar_logic

	_scrollbar_logic:set_scrollbar_values(var_49_2, _total_list_height, var_49_4, num, num_3)
	_scrollbar_logic:set_scroll_percentage(0)

	self._widgets_by_name.list_scrollbar.content.visible = var_49_2 < _total_list_height
end

StartGameStateWeaveLeaderboard._update_scroll_position = function (self)
	-- function 50
	local get_scrolled_length = self._scrollbar_logic:get_scrolled_length()

	if get_scrolled_length ~= self._scrolled_length then
		self._ui_scenegraph.list_scroll_root.local_position[2] = math.round(get_scrolled_length)
		self._scrolled_length = get_scrolled_length
	end
end

StartGameStateWeaveLeaderboard._update_visible_list_entries = function (self)
	-- function 51
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		return
	end

	local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
	local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
	local get_scroll_length = _scrollbar_logic:get_scroll_length()
	local size = scenegraph_definition.list_window.size
	local num_3 = num_2 * 2
	local num_4 = size[2] + num_3
	local _list_entries = self._list_entries
	local var_51_8 = self._list_widget.content.size[2]
	local num_5 = 1
	local count = #_list_entries

	for i = 1, count do
		local num_6 = num + (var_51_8 + num_2) * (i - 1)
		local num_7 = num_6 + var_51_8
		local flag = false

		if num_7 < get_scrolled_length - num_3 then
			flag = true
		elseif num_4 < num_6 - get_scrolled_length then
			flag = true
		end

		if not flag then
			num_5 = i

			break
		end
	end

	self._list_draw_index = num_5
end

StartGameStateWeaveLeaderboard._get_scrollbar_percentage_by_index = function (self, arg_52_1)
	-- function 52
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
		local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
		local get_scroll_length = _scrollbar_logic:get_scroll_length()
		local var_52_4 = scenegraph_definition.list_window.size[2]
		local var_52_5 = get_scrolled_length
		local num_3 = var_52_5 + var_52_4

		if not self._list_entries then
			local var_52_7 = self._list_widget.content.size[2]
			local num_4 = num * 2 + (var_52_7 + num_2) * (arg_52_1 - 1)
			local var_52_9 = num_4
			local num_5 = num_4 + var_52_7
			local num_6 = 0

			if num_3 < num_5 then
				local num_7 = num_5 - num_3

				num_6 = math.clamp(num_7 / get_scroll_length, 0, 1)
			elseif var_52_9 < var_52_5 then
				local num_8 = var_52_5 - var_52_9

				num_6 = -math.clamp(num_8 / get_scroll_length, 0, 1)
			end

			if not num_6 then
				return (math.clamp(get_scroll_percentage + num_6, 0, 1))
			end
		end
	end

	return 0
end

StartGameStateWeaveLeaderboard._animate_element_by_time = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	-- function 53
	return (UIAnimation.init(UIAnimation.function_by_time, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5, math.ease_out_quad))
end

StartGameStateWeaveLeaderboard._animate_element_by_catmullrom = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8)
	-- function 54
	return (UIAnimation.init(UIAnimation.catmullrom, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8))
end
