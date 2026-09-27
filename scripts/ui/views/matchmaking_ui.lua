-- chunkname: @scripts/ui/views/matchmaking_ui.lua

require("scripts/settings/difficulty_settings")

local var_0_0 = local_require("scripts/ui/views/matchmaking_ui_definitions")
local cancel_input_widgets = var_0_0.cancel_input_widgets
local versus_input_widgets = var_0_0.versus_input_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local debug_widget_definitions = var_0_0.debug_widget_definitions

local function fn(...)
	-- function 1
	return
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local portrait_image = SPProfiles[arg_2_0].careers[arg_2_1].portrait_image
	local str

	if not portrait_image then
		str = "small_" .. portrait_image

		if not str then
			-- Nothing
		end
	end

	str = "icons_placeholder"

	::label_2_0::

	return str
end

local tbl = {
	default = Colors.get_table("default"),
	life = Colors.get_table("life"),
	metal = Colors.get_table("metal"),
	death = Colors.get_table("death"),
	heavens = Colors.get_table("heavens"),
	light = Colors.get_table("light"),
	beasts = Colors.get_table("beasts"),
	fire = Colors.get_table("fire"),
	shadow = Colors.get_table("shadow")
}
local tbl_2 = {}

MatchmakingUI = class(MatchmakingUI)

MatchmakingUI.init = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._parent = arg_3_1
	self.network_event_delegate = arg_3_2.network_event_delegate
	self.profile_synchronizer = arg_3_2.profile_synchronizer
	self.camera_manager = arg_3_2.camera_manager
	self.ui_renderer = arg_3_2.ui_renderer
	self.ui_top_renderer = arg_3_2.ui_top_renderer
	self.ingame_ui = arg_3_2.ingame_ui
	self.lobby = arg_3_2.network_lobby
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.voting_manager = arg_3_2.voting_manager
	self._cached_matchmaking_info = {}
	self._is_in_inn = arg_3_2.is_in_inn
	self.matchmaking_manager = Managers.matchmaking
	self.input_manager = arg_3_2.input_manager

	self:create_ui_elements()

	self.num_players_text = Localize("number_of_players")
	self._max_number_of_players = Managers.mechanism:max_instance_members()
	self.portrait_index_table = {}
	self._my_peer_id = Network.peer_id()

	if not Managers.party:is_leader(self._my_peer_id) then
		self:_update_button_prompts()

		self._allow_cancel_matchmaking = true
	end
end

MatchmakingUI.create_ui_elements = function (self)
	-- function 4
	table.clear(self._cached_matchmaking_info)

	self.ui_animations = {}
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)
	self._detail_widgets, self._detail_widgets_by_name = UIUtils.create_widgets(var_0_0.widget_detail_definitions)
	self._widgets_deus, self._widgets_deus_by_name = UIUtils.create_widgets(var_0_0.deus_widget_definitions)
	self._detail_widgets_deus, self._detail_widgets_deus_by_name = UIUtils.create_widgets(var_0_0.deus_widget_detail_definitions)
	self._widgets_versus, self._widgets_versus_by_name = UIUtils.create_widgets(var_0_0.versus_widget_definitions)
	self._detail_widgets_versus, self._detail_widgets_versus_by_name = UIUtils.create_widgets(var_0_0.versus_widget_detail_definitions)
	self._versus_input_widgets, self._versus_input_widgets_by_name = UIUtils.create_widgets(versus_input_widgets)
	self._cancel_input_widgets, self._cancel_input_widgets_by_name = UIUtils.create_widgets(cancel_input_widgets)
	self.debug_box_widget = UIWidget.init(debug_widget_definitions.debug_box)
	self.debug_lobbies_widget = UIWidget.init(debug_widget_definitions.debug_lobbies)
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.scenegraph_definition = scenegraph_definition
	self._input_to_widget_mapping = {}

	local _cancel_input_widgets_by_name = self._cancel_input_widgets_by_name

	self._input_to_widget_mapping[#self._input_to_widget_mapping + 1] = {
		input_action = "cancel_matchmaking",
		widgets = {
			text_widget = _cancel_input_widgets_by_name.cancel_text_input,
			text_widget_prefix = _cancel_input_widgets_by_name.cancel_text_prefix,
			text_widget_suffix = _cancel_input_widgets_by_name.cancel_text_suffix,
			input_icon_widget = _cancel_input_widgets_by_name.cancel_icon
		}
	}

	local _versus_input_widgets_by_name = self._versus_input_widgets_by_name

	self._input_to_widget_mapping[#self._input_to_widget_mapping + 1] = {
		input_action = "cancel_matchmaking",
		widgets = {
			text_widget = _versus_input_widgets_by_name.versus_cancel_text_input,
			text_widget_prefix = _versus_input_widgets_by_name.versus_cancel_text_prefix,
			text_widget_suffix = _versus_input_widgets_by_name.versus_cancel_text_suffix,
			input_icon_widget = _versus_input_widgets_by_name.versus_cancel_icon
		}
	}

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

MatchmakingUI._get_widget = function (self, arg_5_1)
	-- function 5
	if self._active_mechanism == "deus" then
		return self._widgets_deus_by_name[arg_5_1]
	elseif self._active_mechanism == "versus" then
		return self._widgets_versus_by_name[arg_5_1]
	else
		return self._widgets_by_name[arg_5_1]
	end
end

MatchmakingUI._get_detail_widget = function (self, arg_6_1)
	-- function 6
	if self._active_mechanism == "deus" then
		return self._detail_widgets_deus_by_name[arg_6_1]
	elseif self._active_mechanism == "versus" then
		return self._detail_widgets_versus_by_name[arg_6_1]
	else
		return self._detail_widgets_by_name[arg_6_1]
	end
end

MatchmakingUI._get_widgets = function (self)
	-- function 7
	if self._active_mechanism == "deus" then
		return self._widgets_deus, self._detail_widgets_deus
	elseif self._active_mechanism == "versus" then
		return self._widgets_versus, self._detail_widgets_versus
	else
		return self._widgets, self._detail_widgets
	end
end

MatchmakingUI.is_in_inn = function (self)
	-- function 8
	return self._is_in_inn
end

MatchmakingUI.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not RESOLUTION_LOOKUP.modified then
		self:_update_button_prompts()
	end

	local _parent = self._parent
	local parent = _parent:parent()
	local menu_active = parent.menu_active
	local flag = parent.current_view ~= nil
	local component = _parent:component("IngamePlayerListUI")
	local flag_2 = not component and component:is_active()
	local flag_3 = not not menu_active or not not flag_2 or not flag
	local flag_4 = false

	if not flag then
		local var_9_8 = parent.views[parent.current_view]

		if not var_9_8 then
			-- Nothing
		end

		::label_9_0::

		local current_state = var_9_8.current_state

		current_state = not current_state and var_9_8:current_state()

		::label_9_1::

		flag_4 = not current_state and current_state.NAME == "HeroViewStateStore"
	end

	local component_2 = _parent:component("VersusSlotStatusUI")
	local flag_5 = not component_2 and component_2:is_active()

	flag_3 = not flag_3 and not flag_5

	local ui_top_renderer = self.ui_top_renderer
	local get_service = self.input_manager:get_service("ingame_menu")
	local is_game_matchmaking = self.matchmaking_manager:is_game_matchmaking()

	is_game_matchmaking = not is_game_matchmaking and self._is_in_inn

	local ingame_ui = self.ingame_ui
	local component_3 = ingame_ui.ingame_hud:component("LevelCountdownUI")
	local flag_6 = not component_3 and component_3:is_enter_game()
	local menu_suspended = ingame_ui.menu_suspended
	local voting_manager = self.voting_manager
	local vote_in_progress = voting_manager:vote_in_progress()

	vote_in_progress = not vote_in_progress and voting_manager:is_mission_vote()

	if not (not menu_suspended and flag_6) then
		return
	end

	if flag_3 ~= self._show_detailed_matchmaking_info then
		self._show_detailed_matchmaking_info = flag_3
		self._detailed_info_visibility_progress = 0
	end

	if flag_4 ~= self._is_in_store_view then
		self._is_in_store_view = flag_4

		self:_set_in_view_ui_visibility(not flag_4)
	end

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_9_1)

		if not UIAnimation.completed(v) then
			self.ui_animations = nil
		end
	end

	if flag_6 or is_game_matchmaking or not vote_in_progress then
		self:_update_background(is_game_matchmaking, vote_in_progress)
		self:_update_portraits(vote_in_progress)
		self:_update_status(arg_9_1)
		self:_update_show_timer(vote_in_progress)

		if not is_game_matchmaking then
			self:_update_matchmaking_info(arg_9_2)
			self:_sync_players_ready_state(arg_9_1)

			if not self._allow_cancel_matchmaking and vote_in_progress or not get_service:get("cancel_matchmaking") then
				local matchmaking_manager = self.matchmaking_manager

				matchmaking_manager:cancel_matchmaking()

				if not matchmaking_manager:have_game_mode_event_data() then
					matchmaking_manager:clear_game_mode_event_data()
				end

				if not Managers.deed:has_deed() then
					Managers.deed:reset()
				end

				if not Managers.weave:get_next_weave() then
					Managers.weave:set_next_weave(nil)
				end
			end
		elseif not vote_in_progress then
			self:_update_mission_vote_status()
			self:_update_mission_vote_player_status()
			self:_update_mission_timer()
		end

		self:_handle_gamepad_activity()

		if not Managers.mechanism:network_handler():get_match_handler():is_leader(self._my_peer_id) then
			self._allow_cancel_matchmaking = not self.matchmaking_manager:allow_cancel_matchmaking() and not vote_in_progress
		end

		self:_draw(ui_top_renderer, get_service, is_game_matchmaking, arg_9_1)
	end
end

MatchmakingUI._handle_gamepad_activity = function (self)
	-- function 10
	local is_device_active = self.input_manager:is_device_active("gamepad")
	local get_most_recent_device = Managers.input:get_most_recent_device()
	local flag = self.gamepad_active_last_frame == nil or not is_device_active or get_most_recent_device ~= self._most_recent_device

	if not is_device_active then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			self:_update_button_prompts()
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		self:_update_button_prompts()
	end

	self._most_recent_device = get_most_recent_device
end

MatchmakingUI._draw = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local _detailed_info_visibility_progress = self._detailed_info_visibility_progress

	if not _detailed_info_visibility_progress then
		local min = math.min(_detailed_info_visibility_progress + arg_11_4 * 1.2, 1)
		local easeOutCubic = math.easeOutCubic(min)
		local detailed_info_box = scenegraph_definition.detailed_info_box
		local size = detailed_info_box.size
		local position = detailed_info_box.position

		self.ui_scenegraph.detailed_info_box.local_position[2] = size[2] * (1 - easeOutCubic) + position[2]

		if min == 1 then
			self._detailed_info_visibility_progress = nil
		else
			self._detailed_info_visibility_progress = min
		end
	end

	local _get_widgets, var_11_7 = self:_get_widgets()

	UIRenderer.begin_pass(arg_11_1, self.ui_scenegraph, arg_11_2, arg_11_4, nil, self.render_settings)
	UIRenderer.draw_all_widgets(arg_11_1, _get_widgets)

	if not self._show_detailed_matchmaking_info then
		if self._active_mechanism == "versus" then
			if not Managers.state.voting:cancel_disabled() then
				UIRenderer.draw_all_widgets(arg_11_1, self._versus_input_widgets)
			end
		elseif not self._allow_cancel_matchmaking then
			UIRenderer.draw_all_widgets(arg_11_1, self._cancel_input_widgets)
		end

		UIRenderer.draw_all_widgets(arg_11_1, var_11_7)
	end

	UIRenderer.end_pass(arg_11_1)
end

MatchmakingUI._update_background = function (self, arg_12_1, arg_12_2)
	-- function 12
	local var_12_0

	if not arg_12_1 then
		var_12_0 = "matchmaking_window_01"
	elseif not arg_12_2 then
		var_12_0 = "matchmaking_window_02"
	end

	if not var_12_0 then
		local content = self:_get_detail_widget("detailed_info_box").content
		local background = content.background

		if not (content.no_background_changes or background.texture_id == var_12_0) then
			background.texture_id = var_12_0
		end
	end
end

MatchmakingUI._update_matchmaking_info = function (self, arg_13_1)
	-- function 13
	local matchmaking_manager = self.matchmaking_manager
	local search_info = matchmaking_manager:search_info()
	local _cached_matchmaking_info = self._cached_matchmaking_info

	if not IS_XB1 and not search_info.no_lobby_data then
		self:_get_widget("status_text").content.text = Localize("loading_fetching_matchmaking_data")
		self:_get_detail_widget("title_text").content.text = string.rep(".", 1 + math.floor((arg_13_1 * 5 + 0.5) % 4))
		self:_get_detail_widget("difficulty_text").content.text = ""

		return
	end

	local mechanism = search_info.mechanism

	self._active_mechanism = mechanism

	if mechanism == "weave" then
		if not search_info.quick_game then
			local str = "start_game_window_weave_quickplay_title"

			self:_set_detail_level_text(str, true)

			local difficulty = search_info.difficulty
			local flag = not difficulty and DifficultySettings[difficulty]
			local display_name

			if not flag then
				display_name = flag.display_name

				if not display_name then
					-- Nothing
				end
			end

			display_name = "dlc1_2_difficulty_unavailable"

			::label_13_0::

			self:_set_detail_difficulty_text(display_name, nil, false)
		else
			local mission_id = search_info.mission_id
			local templates = WeaveSettings.templates
			local flag_2 = not mission_id and templates[mission_id]
			local find

			if not flag_2 then
				find = table.find(WeaveSettings.templates_ordered, flag_2)

				if not find then
					-- Nothing
				end
			end

			find = nil

			do
				local str_2
			end

			::label_13_1::

			if not flag_2 then
				str_2 = find .. ". " .. Localize(flag_2.display_name)

				if not str_2 then
					-- Nothing
				end
			end

			str_2 = Localize("level_display_name_unavailable")

			::label_13_2::

			self:_set_detail_level_text(str_2, false)

			local flag_3 = not flag_2 and flag_2.wind
			local flag_4 = not flag_3 and WindSettings[flag_3]
			local display_name_2

			if not flag_4 then
				display_name_2 = flag_4.display_name

				if not display_name_2 then
					-- Nothing
				end
			end

			display_name_2 = ""

			::label_13_3::

			self:_set_detail_difficulty_text(display_name_2, tbl[flag_3])
		end
	elseif mechanism == "deus" then
		local str_3 = "mission_vote_quick_play"

		if not search_info.quick_game then
			local mission_id_2 = search_info.mission_id
			local flag_5 = not mission_id_2 and DeusJourneySettings[mission_id_2]

			str_3 = not flag_5 and flag_5.display_name and "deus_matching"
		end

		self:_set_detail_level_text(str_3, true)

		local difficulty_2 = search_info.difficulty

		if difficulty_2 ~= _cached_matchmaking_info.difficulty then
			_cached_matchmaking_info.difficulty = difficulty_2

			local flag_6 = not difficulty_2 and DifficultySettings[difficulty_2]
			local display_name_3

			if not flag_6 then
				display_name_3 = flag_6.display_name

				if not display_name_3 then
					-- Nothing
				end
			end

			display_name_3 = "dlc1_2_difficulty_unavailable"

			::label_13_4::

			self:_set_detail_difficulty_text(display_name_3)
		end
	elseif mechanism == "versus" then
		local str_4 = "mission_vote_quick_play"
		local str_5 = "vs_ui_versus_tag"

		if not search_info.quick_game then
			local mission_id_3 = search_info.mission_id

			if mission_id_3 == "any" then
				str_4 = "map_screen_quickplay_button"
			else
				local flag_7 = not mission_id_3 and LevelSettings[mission_id_3]

				str_4 = not flag_7 and flag_7.display_name or str_4
			end

			str_5 = "player_hosted_title"
		end

		self:_set_detail_level_text(str_4, true)
		self:_set_detail_difficulty_text(str_5)
	else
		local difficulty_3 = search_info.difficulty

		if difficulty_3 ~= _cached_matchmaking_info.difficulty then
			_cached_matchmaking_info.difficulty = difficulty_3

			local flag_8 = not difficulty_3 and DifficultySettings[difficulty_3]
			local display_name_4

			if not flag_8 then
				display_name_4 = flag_8.display_name

				if not display_name_4 then
					-- Nothing
				end
			end

			display_name_4 = "dlc1_2_difficulty_unavailable"

			::label_13_5::

			self:_set_detail_difficulty_text(display_name_4)
		end

		local quick_game = search_info.quick_game
		local flag_9 = quick_game ~= _cached_matchmaking_info.quick_game
		local mission_id_4 = search_info.mission_id
		local flag_10 = mission_id_4 ~= _cached_matchmaking_info.mission_id

		if flag_9 or not flag_10 then
			_cached_matchmaking_info.quick_game = quick_game
			_cached_matchmaking_info.mission_id = mission_id_4

			local have_game_mode_event_data = matchmaking_manager:have_game_mode_event_data()
			local var_13_34

			if not quick_game then
				var_13_34 = "mission_vote_quick_play"
			elseif not have_game_mode_event_data then
				local flag_11 = not mission_id_4 and mission_id_4 == "n/a" or LevelSettings[mission_id_4]
				local display_name_5

				if not flag_11 then
					display_name_5 = flag_11.display_name

					if not display_name_5 then
						-- Nothing
					end
				end

				display_name_5 = "random_level"

				::label_13_6::

				var_13_34 = display_name_5
			else
				local flag_12 = not mission_id_4 and mission_id_4 == "n/a" or LevelSettings[mission_id_4]
				local display_name_6

				if not flag_12 then
					display_name_6 = flag_12.display_name

					if not display_name_6 then
						-- Nothing
					end
				end

				display_name_6 = "level_display_name_unavailable"

				::label_13_7::

				var_13_34 = display_name_6
			end

			self:_set_detail_level_text(var_13_34, true)
		end
	end

	local status = search_info.status

	if status ~= _cached_matchmaking_info[status] then
		_cached_matchmaking_info.status = status

		self:_set_status_text(status)
	end
end

MatchmakingUI._update_status = function (self, arg_14_1)
	-- function 14
	local _rotation_progresss = self._rotation_progresss

	_rotation_progresss = _rotation_progresss or 0

	local num = (_rotation_progresss + arg_14_1 * 0.2) % 1

	self._rotation_progresss = num

	local num_2 = math.easeCubic(num) * 360
	local degrees_to_radians = math.degrees_to_radians(num_2)

	self:_get_widget("loading_status_frame").style.texture_id.angle = degrees_to_radians

	local num_3 = arg_14_1 * 200 % 360
	local degrees_to_radians_2 = math.degrees_to_radians(num_3)

	if self._active_mechanism ~= "versus" then
		for i = 1, 4 do
			local str = "party_slot_" .. i
			local _get_detail_widget = self:_get_detail_widget(str)
			local content = _get_detail_widget.content
			local style = _get_detail_widget.style
			local is_connecting = content.is_connecting
			local connecting_icon = style.connecting_icon
			local num_4

			if not is_connecting then
				num_4 = connecting_icon.angle + degrees_to_radians_2

				if not num_4 then
					-- Nothing
				end
			end

			num_4 = 0

			::label_14_0::

			connecting_icon.angle = num_4
		end
	end
end

MatchmakingUI._update_mission_vote_status = function (self)
	-- function 15
	local voting_manager = self.voting_manager
	local vote_in_progress = voting_manager:vote_in_progress()
	local active_vote_data = voting_manager:active_vote_data()
	local difficulty = active_vote_data.difficulty
	local mission_id = active_vote_data.mission_id
	local quick_game = active_vote_data.quick_game
	local event_data = active_vote_data.event_data
	local mechanism = active_vote_data.mechanism
	local switch_mechanism = active_vote_data.switch_mechanism

	self._active_mechanism = mechanism

	if not switch_mechanism then
		local var_15_9 = MechanismSettings[mechanism]
		local level_key = active_vote_data.level_key

		level_key = level_key or "inn_level"

		local var_15_11 = LevelSettings[level_key]

		self:_set_detail_level_text(var_15_9.display_name, true)
		self:_set_detail_difficulty_text(var_15_11.display_name, nil, false)
	elseif mechanism == "weave" then
		if not quick_game then
			local str = "start_game_window_weave_quickplay_title"

			self:_set_detail_level_text(str, true)

			local flag = not difficulty and DifficultySettings[difficulty]
			local display_name

			if not flag then
				display_name = flag.display_name

				if not display_name then
					-- Nothing
				end
			end

			display_name = "dlc1_2_difficulty_unavailable"

			::label_15_0::

			self:_set_detail_difficulty_text(display_name, nil, false)
		else
			local var_15_15 = mission_id
			local templates = WeaveSettings.templates
			local flag_2 = not var_15_15 and templates[var_15_15]
			local find

			if not flag_2 then
				find = table.find(WeaveSettings.templates_ordered, flag_2)

				if not find then
					-- Nothing
				end
			end

			find = nil

			do
				local str_2
			end

			::label_15_1::

			if not flag_2 then
				str_2 = find .. ". " .. Localize(flag_2.display_name)

				if not str_2 then
					-- Nothing
				end
			end

			str_2 = Localize("level_display_name_unavailable")

			::label_15_2::

			self:_set_detail_level_text(str_2, false)

			local flag_3 = not flag_2 and flag_2.wind
			local flag_4 = not flag_3 and WindSettings[flag_3]
			local display_name_2

			if not flag_4 then
				display_name_2 = flag_4.display_name

				if not display_name_2 then
					-- Nothing
				end
			end

			display_name_2 = ""

			::label_15_3::

			self:_set_detail_difficulty_text(display_name_2, tbl[flag_3])
		end
	elseif mechanism == "deus" then
		self:_set_detail_level_text("deus_matching", true)

		local var_15_23 = DifficultySettings[difficulty]
		local flag_5 = not var_15_23 and var_15_23.display_name

		self:_set_detail_difficulty_text(flag_5 or "")
	elseif mechanism == "versus" then
		local str_3 = "mission_vote_quick_play"
		local str_4 = "vs_ui_versus_tag"

		if not quick_game then
			if mission_id == "any" then
				str_3 = "map_screen_quickplay_button"
			else
				local flag_6 = not mission_id and LevelSettings[mission_id]

				str_3 = not flag_6 and flag_6.display_name or str_3
			end

			str_4 = "player_hosted_title"
		end

		self:_set_detail_level_text(str_3, true)
		self:_set_detail_difficulty_text(str_4)
	else
		local var_15_28 = DifficultySettings[difficulty]
		local flag_7 = not var_15_28 and var_15_28.display_name
		local var_15_30
		local flag_8

		flag_8 = not quick_game and "mission_vote_quick_play" and mission_id ~= nil or not "random_level" and LevelSettings[mission_id].display_name

		self:_set_detail_difficulty_text(flag_7 or "")
		self:_set_detail_level_text(flag_8, true)
	end

	local var_15_32 = vote_in_progress

	self:_set_status_text(var_15_32)
end

MatchmakingUI._update_mission_vote_player_status = function (self)
	-- function 16
	local get_current_voters = self.voting_manager:get_current_voters()

	for k, v in pairs(get_current_voters) do
		local _get_portrait_index = self:_get_portrait_index(k)

		if _get_portrait_index ~= nil then
			if v == 1 then
				self:_set_player_voted_yes(_get_portrait_index, true)
			elseif v == "undecided" then
				self:_set_player_voted_yes(_get_portrait_index, false)
			end
		end
	end
end

MatchmakingUI._update_mission_timer = function (self)
	-- function 17
	local voting_manager = self.voting_manager
	local duration = voting_manager:active_vote_template().duration
	local vote_time_left = voting_manager:vote_time_left()
	local max = math.max(vote_time_left / duration, 0)

	self:_set_vote_time_progress(max)
end

MatchmakingUI._update_show_timer = function (self, arg_18_1)
	-- function 18
	local var_18_0
	local flag

	flag = not arg_18_1 and 255 and 0

	local _get_detail_widget = self:_get_detail_widget("timer_bg")
	local _get_detail_widget_2 = self:_get_detail_widget("timer_fg")
	local _get_detail_widget_3 = self:_get_detail_widget("timer_glow")

	_get_detail_widget.style.texture_id.color[1] = flag
	_get_detail_widget_2.style.texture_id.color[1] = flag
	_get_detail_widget_3.style.texture_id.color[1] = flag
end

MatchmakingUI.update_debug = function (arg_19_0)
	-- function 19
	if not Managers.matchmaking:active_lobby() then
		return
	end

	local str = ""
	local str_2 = "\nStatename: "
	local statename = Managers.matchmaking.debug.statename

	statename = statename or "-"

	local str_3 = (((str .. str_2 .. statename) .. "\nState: " .. Managers.matchmaking.debug.state) .. "\nInfo: " .. Managers.matchmaking.debug.text or "matchmaking debug") .. "\n"
	local str_4 = "\nDistance: "
	local distance = Managers.matchmaking.debug.distance

	distance = distance or "?/" .. MatchmakingSettings.max_distance_filter

	local str_5 = (((((str_3 .. str_4 .. distance) .. "\nLevel: " .. Managers.matchmaking.debug.level) .. "\nDifficulty: " .. Managers.matchmaking.debug.difficulty) .. "\nHero: " .. Managers.matchmaking.debug.hero) .. "\nProgression: " .. Managers.matchmaking.debug.progression) .. "\n"

	arg_19_0.debug_box_widget.content.debug_text = str_5
end

MatchmakingUI.destroy = function (arg_20_0)
	-- function 20
	return
end

MatchmakingUI.get_input_texture_data = function (self, arg_21_1)
	-- function 21
	local input_manager = self.input_manager
	local get_service = input_manager:get_service("ingame_menu")
	local is_device_active = input_manager:is_device_active("gamepad")
	local get_most_recent_device = input_manager:get_most_recent_device()
	local PLATFORM = PLATFORM

	if not (not IS_XB1 and not GameSettingsDevelopment.allow_keyboard_mouse and is_device_active) then
		PLATFORM = "win32"
	elseif not IS_WINDOWS and not is_device_active then
		PLATFORM = "xb1"
		PLATFORM = get_most_recent_device.type() ~= "sce_pad" or not "ps_pad" or PLATFORM
	end

	local get_keymapping = get_service:get_keymapping(arg_21_1, PLATFORM)
	local var_21_6 = get_keymapping[1]
	local var_21_7 = get_keymapping[2]
	local var_21_8 = get_keymapping[3]
	local var_21_9

	if var_21_8 == "held" then
		var_21_9 = "matchmaking_prefix_hold"
	end

	if var_21_6 == "keyboard" then
		local var_21_10
		local button_locale_name = Keyboard.button_locale_name(var_21_7)

		button_locale_name = button_locale_name or Keyboard.button_name(var_21_7)

		return var_21_10, button_locale_name, var_21_9
	elseif var_21_6 == "mouse" then
		return nil, Mouse.button_name(var_21_7), var_21_9
	elseif not (var_21_6 == "gamepad" or var_21_6 ~= "ps_pad") then
		local button_name = get_most_recent_device.button_name(var_21_7)

		return ButtonTextureByName(button_name, PLATFORM), button_name, var_21_9
	end

	return nil, ""
end

MatchmakingUI._update_button_prompts = function (self)
	-- function 22
	local is_device_active = Managers.input:is_device_active("gamepad")
	local ui_scenegraph = self.ui_scenegraph

	for i, v in ipairs(self._input_to_widget_mapping) do
		local widgets = v.widgets
		local text_widget = widgets.text_widget
		local text_widget_prefix = widgets.text_widget_prefix
		local text_widget_suffix = widgets.text_widget_suffix
		local input_icon_widget = widgets.input_icon_widget
		local input_action = v.input_action
		local get_input_texture_data, var_22_9, var_22_10 = self:get_input_texture_data(input_action)
		local content = text_widget_prefix.content
		local var_22_12

		if not var_22_10 then
			var_22_12 = Localize(var_22_10)

			if not var_22_12 then
				-- Nothing
			end
		end

		var_22_12 = ""

		::label_22_0::

		content.text = var_22_12

		if not get_input_texture_data then
			text_widget.content.text = "[" .. var_22_9 .. "] "
			input_icon_widget.content.texture_id = nil
			input_icon_widget.content.visible = false
		elseif not get_input_texture_data.texture then
			text_widget.content.text = ""
			input_icon_widget.content.texture_id = get_input_texture_data.texture
			input_icon_widget.content.visible = true
		end

		local text = text_widget.content.text
		local text_2 = text_widget_prefix.content.text
		local text_3 = text_widget_suffix.content.text
		local var_22_16, var_22_17 = UIFontByResolution(text_widget.style.text)
		local var_22_18, var_22_19 = UIFontByResolution(text_widget_prefix.style.text)
		local var_22_20, var_22_21 = UIFontByResolution(text_widget_suffix.style.text)
		local text_size = UIRenderer.text_size(self.ui_renderer, text, var_22_16[1], var_22_17)
		local text_size_2 = UIRenderer.text_size(self.ui_renderer, text_2, var_22_18[1], var_22_19)
		local text_size_3 = UIRenderer.text_size(self.ui_renderer, text_3, var_22_20[1], var_22_21)

		if not get_input_texture_data then
			local size = get_input_texture_data.size
			local var_22_26 = ui_scenegraph[input_icon_widget.scenegraph_id]

			text_size = size[1]
			var_22_26.size[1] = text_size
			var_22_26.size[2] = size[2]
		end

		local num = -((text_size + text_size_2 + text_size_3) * 0.5)

		if not get_input_texture_data then
			text_widget_prefix.style.text.offset[1] = num
			text_widget_prefix.style.text_shadow.offset[1] = num + 2
			text_widget.style.text.offset[1] = num + text_size_2
			text_widget.style.text_shadow.offset[1] = num + text_size_2 + 2
			text_widget_suffix.style.text.offset[1] = num + (text_size_2 + text_size)
			text_widget_suffix.style.text_shadow.offset[1] = num + (text_size_2 + text_size) + 2
		else
			input_icon_widget.style.texture_id.offset[1] = num
			text_widget_prefix.style.text.offset[1] = num
			text_widget_prefix.style.text_shadow.offset[1] = num + 2
			text_widget_suffix.style.text.offset[1] = num + (text_size_2 + text_size)
			text_widget_suffix.style.text_shadow.offset[1] = num + (text_size_2 + text_size) + 2
		end
	end
end

MatchmakingUI._update_portraits = function (self, arg_23_1)
	-- function 23
	if self._active_mechanism == "versus" then
		return
	end

	local profile_synchronizer = self.profile_synchronizer
	local player = Managers.player
	local members = self.lobby:members()
	local flag = not members and members:members_map()

	if not flag then
		local portrait_index_table = self.portrait_index_table

		for i = 1, self._max_number_of_players do
			local var_23_5 = portrait_index_table[i]

			if not (not var_23_5 and flag[var_23_5]) then
				portrait_index_table[i] = nil

				self:large_window_set_player_portrait(i, nil)
				self:large_window_set_player_connecting(i, false)
				self:_set_player_is_voting(i, false)
				self:_set_player_voted_yes(i, false)
			end
		end

		for k, v in pairs(flag) do
			local _get_portrait_index = self:_get_portrait_index(k)

			if not _get_portrait_index then
				_get_portrait_index = self:_get_first_free_portrait_index()

				if not _get_portrait_index then
					goto label_23_0
				end

				portrait_index_table[_get_portrait_index] = k
			end

			if not arg_23_1 then
				self:_set_player_is_voting(_get_portrait_index, true)
			else
				self:_set_player_is_voting(_get_portrait_index, false)
			end

			if not profile_synchronizer:profile_by_peer(k, 1) then
				self:large_window_set_player_portrait(_get_portrait_index, k)

				if not player:player_from_peer_id(k) then
					self:large_window_set_player_connecting(_get_portrait_index, false)
				end
			else
				self:large_window_set_player_connecting(_get_portrait_index, true)
			end

			::label_23_0::
		end
	end
end

MatchmakingUI._get_portrait_index = function (self, arg_24_1)
	-- function 24
	local portrait_index_table = self.portrait_index_table

	for i = 1, self._max_number_of_players do
		if portrait_index_table[i] == arg_24_1 then
			return i
		end
	end
end

MatchmakingUI._get_first_free_portrait_index = function (self)
	-- function 25
	local portrait_index_table = self.portrait_index_table

	for i = 1, self._max_number_of_players do
		if portrait_index_table[i] == nil then
			return i
		end
	end
end

MatchmakingUI.large_window_set_title = function (arg_26_0, arg_26_1)
	-- function 26
	arg_26_0:_get_detail_widget("title_text").content.text = Localize(arg_26_1)
end

MatchmakingUI.large_window_set_status_message = function (arg_27_0, arg_27_1)
	-- function 27
	fassert(arg_27_1 ~= " ", "tried to pass empty status message to matchmaking ui")

	arg_27_0:_get_widget("status_text").content.text = Localize(arg_27_1)
end

MatchmakingUI.large_window_set_difficulty = function (arg_28_0, arg_28_1)
	-- function 28
	local flag = not arg_28_1 and DifficultySettings[arg_28_1]
	local display_name

	if not flag then
		display_name = flag.display_name

		if not display_name then
			-- Nothing
		end
	end

	display_name = "dlc1_2_difficulty_unavailable"

	::label_28_0::

	arg_28_0:_get_detail_widget("difficulty_text").content.text = Localize(display_name)
end

MatchmakingUI.large_window_set_player_portrait = function (self, arg_29_1, arg_29_2)
	-- function 29
	local _get_detail_widget = self:_get_detail_widget("party_slot_" .. arg_29_1)
	local _get_widget = self:_get_widget("player_status_" .. arg_29_1)
	local content = _get_detail_widget.content
	local var_29_3

	if not arg_29_2 then
		local player = Managers.player:player(arg_29_2, 1)
		local flag = not player and player.player_unit

		if not Unit.alive(flag) then
			local career_index = player:career_index()
			local profile_index = player:profile_index()

			if not career_index and not profile_index then
				var_29_3 = fn_2(profile_index, career_index)
			end
		end
	end

	content.is_connected = var_29_3 ~= nil
	content.peer_id = arg_29_2
	_get_widget.content.is_connected = var_29_3 ~= nil
	var_29_3 = var_29_3 or "small_unit_frame_portrait_default"
	content.portrait = var_29_3
end

MatchmakingUI._get_party_slot_index_by_peer_id = function (self, arg_30_1)
	-- function 30
	for i = 1, self._max_number_of_players do
		local str = "party_slot_" .. i

		if self:_get_detail_widget(str).content.peer_id == arg_30_1 then
			return i
		end
	end
end

MatchmakingUI._sync_players_ready_state = function (self, arg_31_1)
	-- function 31
	if self._active_mechanism == "versus" then
		return
	end

	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		local player_unit = v.player_unit

		if not Unit.alive(player_unit) then
			local is_in_end_zone = ScriptUnit.extension(player_unit, "status_system"):is_in_end_zone()
			local peer_id = v.peer_id
			local _get_party_slot_index_by_peer_id = self:_get_party_slot_index_by_peer_id(peer_id)

			if not _get_party_slot_index_by_peer_id then
				self:_set_player_ready_state(_get_party_slot_index_by_peer_id, is_in_end_zone)
			end
		end
	end
end

MatchmakingUI._set_player_ready_state = function (self, arg_32_1, arg_32_2)
	-- function 32
	local _get_detail_widget = self:_get_detail_widget("party_slot_" .. arg_32_1)
	local _get_widget = self:_get_widget("player_status_" .. arg_32_1)

	_get_detail_widget.content.is_ready = arg_32_2
	_get_widget.content.is_ready = arg_32_2

	local content = _get_widget.content
	local flag

	flag = not arg_32_2 and "matchmaking_light_01" and "matchmaking_light_02"
	content.texture_id = flag
end

MatchmakingUI.large_window_set_player_connecting = function (self, arg_33_1, arg_33_2)
	-- function 33
	local _get_detail_widget = self:_get_detail_widget("party_slot_" .. arg_33_1)
	local _get_widget = self:_get_widget("player_status_" .. arg_33_1)

	_get_detail_widget.content.is_connecting = arg_33_2
	_get_widget.content.is_connecting = arg_33_2
end

MatchmakingUI._set_player_is_voting = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	arg_34_0:_get_detail_widget("party_slot_" .. arg_34_1).content.is_voting = arg_34_2
end

MatchmakingUI._set_player_voted_yes = function (self, arg_35_1, arg_35_2)
	-- function 35
	local _get_detail_widget = self:_get_detail_widget("party_slot_" .. arg_35_1)

	if not _get_detail_widget then
		return
	end

	_get_detail_widget.content.voted_yes = arg_35_2
end

MatchmakingUI._set_detail_difficulty_text = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	local _get_detail_widget = self:_get_detail_widget("difficulty_text")

	_get_detail_widget.content.text = not arg_36_3 and arg_36_1 and Localize(arg_36_1)

	local text = _get_detail_widget.style.text

	if not arg_36_2 then
		-- Nothing
	end

	::label_36_0::

	local default_color = _get_detail_widget.style.text.default_color

	default_color = default_color or tbl.default

	::label_36_1::

	text.text_color = default_color
end

MatchmakingUI._set_detail_level_text = function (self, arg_37_1, arg_37_2)
	-- function 37
	local content = self:_get_detail_widget("title_text").content
	local var_37_1

	if not arg_37_2 then
		var_37_1 = Localize(arg_37_1)

		if not var_37_1 then
			-- Nothing
		end
	end

	var_37_1 = arg_37_1

	::label_37_0::

	content.text = var_37_1
end

MatchmakingUI._set_status_text = function (self, arg_38_1)
	-- function 38
	local _get_widget = self:_get_widget("status_text")

	arg_38_1 = tbl_2[arg_38_1] or arg_38_1
	_get_widget.content.text = Localize(arg_38_1)
end

MatchmakingUI._set_vote_time_progress = function (self, arg_39_1)
	-- function 39
	local _get_detail_widget = self:_get_detail_widget("timer_fg")
	local uvs = _get_detail_widget.content.texture_id.uvs
	local scenegraph_id = _get_detail_widget.scenegraph_id
	local size = self.scenegraph_definition[scenegraph_id].size

	self.ui_scenegraph[scenegraph_id].size[1] = size[1] * arg_39_1
	uvs[2][1] = arg_39_1
end

MatchmakingUI._set_in_view_ui_visibility = function (self, arg_40_1)
	-- function 40
	local window = self._widgets_by_name.window
	local status_text = self._widgets_by_name.status_text
	local window_2 = self._widgets_deus_by_name.window
	local status_text_2 = self._widgets_deus_by_name.status_text
	local window_3 = self._widgets_versus_by_name.window
	local status_text_3 = self._widgets_versus_by_name.status_text
	local flag

	flag = not arg_40_1 and 0 and 0.765

	local flag_2

	flag_2 = not arg_40_1 and 506 and 118.91

	local flag_3

	flag_3 = not arg_40_1 and "left" and "right"
	window.content.texture_id.uvs[1][1] = flag
	window.style.texture_id.texture_size[1] = flag_2
	window.style.texture_id.horizontal_alignment = flag_3
	status_text.content.visible = arg_40_1
	window_2.content.texture_id.uvs[1][1] = flag
	window_2.style.texture_id.texture_size[1] = flag_2
	window_2.style.texture_id.horizontal_alignment = flag_3
	status_text_2.content.visible = arg_40_1
	window_3.content.texture_id.uvs[1][1] = flag
	window_3.style.texture_id.texture_size[1] = flag_2
	window_3.style.texture_id.horizontal_alignment = flag_3
	status_text_3.content.visible = arg_40_1
end

MatchmakingUI.on_matchmaking_num_players_in_matchmaking = function (self, arg_41_1, arg_41_2)
	-- function 41
	local is_game_matchmaking = self.matchmaking_manager:is_game_matchmaking()

	is_game_matchmaking = not is_game_matchmaking and self._is_in_inn

	if not is_game_matchmaking then
		return
	end

	local _get_detail_widget = self:_get_detail_widget("num_players_matchmaking")

	if not _get_detail_widget then
		return
	end

	_get_detail_widget.content.text = string.format("%d Players in Queue", arg_41_2)
end
