-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_player_hosted_lobby.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_player_hosted_lobby_definitions")
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")
local num = 2
local num_2 = 4
local str = "gui/1080p/single_textures/generic/transparent_placeholder_texture"
local flag = true

StartGameWindowVersusPlayerHostedLobby = class(StartGameWindowVersusPlayerHostedLobby)
StartGameWindowVersusPlayerHostedLobby.NAME = "StartGameWindowPlayerHostedLobby"

local tbl = {
	"selection",
	"panel_focus",
	panel_focus = 2,
	[3] = "custom_settings",
	selection = 1,
	custom_settings = 3
}
local num_3 = 3
local tbl_2 = {
	4,
	2,
	4
}
local tbl_3 = {
	[2] = {
		[1] = "mission_setting",
		[2] = "toggle_custom_settings_button"
	}
}
local tbl_4 = {
	[1] = 1,
	[3] = 2
}

StartGameWindowVersusPlayerHostedLobby.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._matchmaking_manager = ingame_ui_context.matchmaking_manager
	self._is_server = ingame_ui_context.is_server
	self._peer_id = ingame_ui_context.peer_id
	self._is_loading = true
	self._match_handler = Managers.mechanism:network_handler():get_match_handler()
	self._options_view = ingame_ui_context.ingame_ui.views.options_view
	self._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}

	local game_mechanism = Managers.mechanism:game_mechanism()
	local custom_settings_enabled

	if not game_mechanism:is_hosting_versus_custom_game() then
		custom_settings_enabled = game_mechanism:custom_settings_enabled()

		if not custom_settings_enabled then
			-- Nothing
		end
	end

	custom_settings_enabled = false

	::label_1_0::

	self._custom_settings_toggled = custom_settings_enabled
	self._game_mechanism = game_mechanism

	self:_create_ui_elements()

	self._enter_animation = self:_play_animation("on_enter")

	self._parent:set_hide_panel_title_butttons(true)
	self._parent:set_input_description("versus_player_hosted_lobby")

	self._input_focus_mode = tbl.selection
	self._focus_panel_button_idx = 1

	Managers.state.event:register(self, "event_focus_versus_hosted_lobby_input", "focus_versus_hosted_lobby_input")
	Managers.state.event:register(self, "lobby_member_game_mode_custom_settings_handler_enabled", "_lobby_member_game_mode_custom_settings_handler_enabled")
end

StartGameWindowVersusPlayerHostedLobby._play_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}

	return (self._ui_animator:start_animation(arg_2_1, self._widgets_by_name, scenegraph_definition, tbl))
end

StartGameWindowVersusPlayerHostedLobby._create_ui_elements = function (self)
	-- function 3
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local widget_definitions = var_0_0.widget_definitions

	UIUtils.create_widgets(widget_definitions, tbl, tbl_2)

	local tbl_3 = {}
	local host_widget_definitions = var_0_0.host_widget_definitions

	UIUtils.create_widgets(host_widget_definitions, tbl_3, tbl_2)

	self._widgets = tbl
	self._host_widgets = tbl_3
	self._widgets_by_name = tbl_2

	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not query_lobby then
		query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")
		query_lobby = query_lobby or Managers.matchmaking.lobby
	end

	local lobby_data

	if not query_lobby then
		lobby_data = query_lobby:lobby_data("custom_server_name")

		if not lobby_data then
			-- Nothing
		end
	end

	lobby_data = ""

	::label_3_0::

	local var_3_7 = rawget(_G, "Steam")

	var_3_7 = not var_3_7 and Steam.user_name() == lobby_data and lobby_data == "n/a" or lobby_data ~= ""
	self._widgets_by_name.lobby_name.content.input.default_text = not var_3_7 and lobby_data and Localize("start_game_window_custom_lobby_name_hint")
	self._widgets_by_name.toggle_custom_settings_button.content.button_hotspot.is_selected = self._custom_settings_toggled
	self._loading_spinner_widget = UIWidget.init(var_0_0.loading_spinner_definition)
	self._console_cursor = UIWidget.init(var_0_0.console_cursor_definition)

	self:_create_player_slots()

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

StartGameWindowVersusPlayerHostedLobby.on_exit = function (self, arg_4_1)
	-- function 4
	self._ui_animator = nil

	self._parent:play_sound("Play_vs_hud_play_menu_leave_lobby")
	self:_remove_all_players()
	Managers.state.event:unregister("event_focus_versus_hosted_lobby_input", self)
	Managers.state.event:unregister("lobby_member_game_mode_custom_settings_handler_enabled", self)
end

StartGameWindowVersusPlayerHostedLobby._exit_layout = function (self)
	-- function 5
	local flag

	flag = not self._match_handler:query_peer_data(self._peer_id, "is_match_owner") and "versus_custom_game" and "versus_lobby_browser"

	local _parent = self._parent

	_parent:set_layout_by_name(flag)
	_parent:set_hide_panel_title_butttons(false)
end

StartGameWindowVersusPlayerHostedLobby.on_exit = function (self, arg_6_1)
	-- function 6
	self._ui_animator = nil

	self._parent:play_sound("Play_vs_hud_play_menu_leave_lobby")
	self:_remove_all_players()

	arg_6_1.return_layout_name = nil
end

StartGameWindowVersusPlayerHostedLobby.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not self._matchmaking_manager:is_game_matchmaking() then
		self:_exit_layout()

		return
	end

	if not self._is_loading then
		self:_update_options_view(arg_7_1, arg_7_2)
		self:_update_mission_option()
		self:_update_animations(arg_7_1, arg_7_2)
		self:_update_can_play()
		self:_update_play_button_texture(is_device_active)

		if not is_device_active then
			self:_handle_gamepad_input(arg_7_1, arg_7_2)
		else
			self:_handle_input(arg_7_2)
		end

		self:_update_toggle_settings_button(arg_7_1, arg_7_2, is_device_active)
		self:_update_server_name()
		self:_update_avatars()
		self:_update_custom_lobby_slots()
	end

	self:_draw(arg_7_1)

	local get_match_owner = Managers.mechanism:network_handler():get_match_handler():get_match_owner()

	self._is_loading = not Managers.mechanism:mechanism_try_call("get_all_reservation_handlers_by_owner", get_match_owner) and not self._matchmaking_manager:is_in_versus_custom_game_lobby()
end

StartGameWindowVersusPlayerHostedLobby.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return
end

StartGameWindowVersusPlayerHostedLobby._update_avatars = function (self)
	-- function 9
	for k, v in pairs(self._player_slots_by_peer_id) do
		if not v.has_avatar then
			local get_avatar, var_9_1 = Friends.get_avatar(k)

			if not (get_avatar > 0) or not var_9_1 then
				local gui = self._ui_top_renderer.gui
				local clone_material_from_template = Gui.clone_material_from_template(gui, k, "template_store_diffuse")

				Material.set_resource(clone_material_from_template, "diffuse_map", var_9_1)

				v.panel_widget.content.player_avatar = clone_material_from_template
				v.has_avatar = true
			elseif get_avatar == 0 then
				v.has_avatar = true
			end
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._can_play = function (self)
	-- function 10
	local flag = true
	local str = "tutorial_no_text"

	if not self._matchmaking_manager:is_player_hosting() then
		local get_match_owner = self._match_handler:get_match_owner()
		local flag_2 = get_match_owner == Network.peer_id()
		local game_mechanism = Managers.mechanism:game_mechanism()
		local get_slot_reservation_handler = game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

		get_slot_reservation_handler = get_slot_reservation_handler or game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

		local all_teams_have_members = get_slot_reservation_handler:all_teams_have_members()
		local network_server = Managers.state.network.network_server
		local flag_3 = not flag_2 and network_server:are_all_peers_ingame(nil, true)

		if not (all_teams_have_members or not Development.parameter("allow_versus_force_start_single_player") or flag_3) then
			flag = false
			str = "interaction_action_missing_players"
		end
	end

	return flag, str
end

StartGameWindowVersusPlayerHostedLobby._update_can_play = function (self)
	-- function 11
	local _can_play, var_11_1 = self:_can_play()
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.force_start_button.content.button_hotspot.disable_button = not _can_play
	_widgets_by_name.locked_reason.content.text = var_11_1
end

StartGameWindowVersusPlayerHostedLobby._update_play_button_texture = function (self, arg_12_1)
	-- function 12
	local _widgets_by_name = self._widgets_by_name

	if self._gamepad_active ~= arg_12_1 then
		self._gamepad_active = arg_12_1

		if not arg_12_1 then
			local window_input_service = self._parent:window_input_service()
			local str = "refresh"
			local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, str, arg_12_1)

			if not get_gamepad_input_texture_data then
				_widgets_by_name.force_start_button.content.texture_icon_id = get_gamepad_input_texture_data.texture
			end
		else
			_widgets_by_name.force_start_button.content.texture_icon_id = "options_button_icon_quickplay"
		end

		_widgets_by_name.force_start_button.content.is_selected = arg_12_1
	end
end

StartGameWindowVersusPlayerHostedLobby._update_animations = function (self, arg_13_1, arg_13_2)
	-- function 13
	self._ui_animator:update(arg_13_1)

	local force_start_button = self._widgets_by_name.force_start_button

	if not force_start_button.content.button_hotspot.disable_button then
		UIWidgetUtils.animate_play_button(force_start_button, arg_13_1)
	end

	UIWidgetUtils.animate_start_game_console_setting_button(self._widgets_by_name.mission_setting, arg_13_1)

	local leave_game_button = self._widgets_by_name.leave_game_button

	UIWidgetUtils.animate_default_button(leave_game_button, arg_13_1)
end

StartGameWindowVersusPlayerHostedLobby._draw = function (self, arg_14_1)
	-- function 14
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_14_1, nil, _render_settings)

	if not self._is_loading then
		UIRenderer.draw_widget(_ui_top_renderer, self._loading_spinner_widget)
	else
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._panel_widgets)

		if not self._matchmaking_manager:is_player_hosting() then
			UIRenderer.draw_all_widgets(_ui_top_renderer, self._host_widgets)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowVersusPlayerHostedLobby._handle_input = function (self, arg_15_1)
	-- function 15
	local window_input_service = self._parent:window_input_service()
	local _matchmaking_manager = self._matchmaking_manager
	local force_start_button = self._widgets_by_name.force_start_button

	if not self:_can_play() and UIUtils.is_button_pressed(force_start_button) and not window_input_service:get("force_start") then
		_matchmaking_manager:force_start_game()
		self._parent:play_sound("versus_hud_player_lobby_searching_for_match")
	end

	if not UIUtils.is_button_hover_enter(force_start_button) then
		self._parent:play_sound("Play_hud_hover")
	end

	local leave_game_button = self._widgets_by_name.leave_game_button
	local is_server = Managers.state.network.is_server

	leave_game_button.content.button_hotspot.disable_button = not is_server

	if not is_server and UIUtils.is_button_pressed(leave_game_button) and not window_input_service:get("cancel_matchmaking") then
		_matchmaking_manager:cancel_matchmaking()
		_matchmaking_manager:pause_matchmaking_for_seconds(2)
		self:_exit_layout()

		return
	end

	local mission_setting = self._widgets_by_name.mission_setting
	local color = mission_setting.style.bg_effect.color
	local flag

	flag = not self._is_match_host and 255 and 0
	color[1] = flag

	if not self._is_match_host then
		mission_setting.content.is_selected = UIUtils.is_button_hover(mission_setting)

		if not UIUtils.is_button_pressed(mission_setting) then
			local _parent = self._parent
			local current_mechanism_name = Managers.mechanism:current_mechanism_name()
			local get_custom_game_settings = _parent:get_custom_game_settings(current_mechanism_name)

			_parent:set_layout_by_name(get_custom_game_settings.layout_name)
		end
	end

	for k, v in pairs(self._panel_widgets) do
		local content = v.content

		if not content.empty then
			if not UIUtils.is_button_pressed(v) then
				local team_index = content.team_index
				local get_match_owner = self._match_handler:get_match_owner()
				local game_mechanism = Managers.mechanism:game_mechanism()
				local get_slot_reservation_handler = game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

				get_slot_reservation_handler = get_slot_reservation_handler or game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

				get_slot_reservation_handler:request_party_change(team_index)
				self._parent:play_sound("versus_hud_player_lobby_switch_slot")
			end
		else
			if not UIUtils.is_button_pressed(v, "profile_button_hotspot") then
				Managers.account:show_player_profile(content.peer_id)
			end

			if not UIUtils.is_button_pressed(v, "kick_button_hotspot") then
				local server_get_friend_party_from_peer = Managers.party:server_get_friend_party_from_peer(content.peer_id)

				self._matchmaking_manager:cancel_matchmaking_for_peer(server_get_friend_party_from_peer.leader)
			end

			if not UIUtils.is_button_pressed(v, "chat_button_hotspot") then
				local peer_id = content.peer_id
				local ignoring_peer_id = Managers.chat:ignoring_peer_id(peer_id)

				if not ignoring_peer_id then
					Managers.chat:remove_ignore_peer_id(peer_id)
				else
					Managers.chat:ignore_peer_id(peer_id)
				end

				content.chat_button_hotspot.is_selected = ignoring_peer_id
			end
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._update_toggle_settings_button = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local toggle_custom_settings_button = self._widgets_by_name.toggle_custom_settings_button

	UIWidgetUtils.animate_default_checkbox_button_console(toggle_custom_settings_button, arg_16_1)

	toggle_custom_settings_button.content.button_hotspot.disable_button = not self._game_mechanism:is_hosting_versus_custom_game()

	if not UIUtils.is_button_hover_enter(toggle_custom_settings_button) then
		self._parent:play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if not self._game_mechanism:is_hosting_versus_custom_game() then
		local _is_other_option_button_selected = self:_is_other_option_button_selected(toggle_custom_settings_button, self._custom_settings_toggled)

		if _is_other_option_button_selected ~= nil then
			self._custom_settings_toggled = _is_other_option_button_selected
			toggle_custom_settings_button.content.button_hotspot.is_selected = _is_other_option_button_selected

			Managers.state.event:trigger("event_focus_custom_game_settings_input", _is_other_option_button_selected)
			self:_enable_custom_game_settings(_is_other_option_button_selected)
		end
	else
		local custom_settings_enabled = self._game_mechanism:custom_settings_enabled()

		if self._custom_settings_toggled ~= custom_settings_enabled then
			toggle_custom_settings_button.content.button_hotspot.is_selected = custom_settings_enabled
			self._custom_settings_toggled = custom_settings_enabled
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._enable_custom_game_settings = function (arg_17_0, arg_17_1)
	-- function 17
	Managers.mechanism:game_mechanism():get_custom_game_settings_handler():set_enabled(arg_17_1, true)
	Managers.state.event:trigger("event_reset_host_settings", not arg_17_1)
end

StartGameWindowVersusPlayerHostedLobby._create_player_slots = function (self)
	-- function 18
	local tbl = {}
	local tbl_2 = {}

	for i = 1, num do
		local tbl_3 = {}

		tbl_2[i] = tbl_3

		for j = 1, num_2 do
			local tbl_4 = {}

			tbl_3[j] = tbl_4

			local create_player_panel_widget = var_0_0.create_player_panel_widget(i, j)
			local var_18_5 = UIWidget.init(create_player_panel_widget)

			var_18_5.content.empty = true
			var_18_5.content.team_index = i
			var_18_5.content.player_index = j
			tbl_4.panel_widget = var_18_5
			tbl[#tbl + 1] = var_18_5
		end
	end

	self._num_players_by_team = {}
	self._player_slots_by_team = tbl_2
	self._player_slots_by_peer_id = {}
	self._panel_widgets = tbl
end

StartGameWindowVersusPlayerHostedLobby._find_first_available_slot = function (self, arg_19_1, arg_19_2)
	-- function 19
	assert(arg_19_1)

	local var_19_0 = self._player_slots_by_team[arg_19_1]
	local var_19_1 = var_19_0[arg_19_2]

	if not var_19_1 and not var_19_1.panel_widget.content.empty then
		return var_19_1
	end

	for i = 1, num_2 do
		local var_19_2 = var_19_0[i]

		if not var_19_2.panel_widget.content.empty then
			return var_19_2
		end
	end

	fassert(false, "No available slots!")
end

StartGameWindowVersusPlayerHostedLobby._remove_all_players = function (self)
	-- function 20
	for k, v in pairs(self._player_slots_by_peer_id) do
		self:_remove_player(v)
	end
end

StartGameWindowVersusPlayerHostedLobby._remove_player = function (arg_21_0, arg_21_1)
	-- function 21
	local panel_widget = arg_21_1.panel_widget
	local peer_id = arg_21_1.peer_id

	panel_widget.content.empty = true
	panel_widget.content.show_profile_button = false
	panel_widget.content.show_kick_button = false
	panel_widget.content.show_chat_button = false
	panel_widget.content.chat_button_hotspot.is_selected = false
	arg_21_1.slot_id = nil

	local player_avatar = panel_widget.content.player_avatar

	if not player_avatar then
		Material.set_texture(player_avatar, "diffuse_map", str)

		panel_widget.content.player_avatar = nil
	end

	if not flag then
		Friends.delete_avatar(peer_id)
	end

	arg_21_0._player_slots_by_peer_id[peer_id] = nil
end

StartGameWindowVersusPlayerHostedLobby._update_custom_lobby_slots = function (self)
	-- function 22
	local flag_2 = false
	local _match_handler = self._match_handler
	local get_match_owner = _match_handler:get_match_owner()
	local game_mechanism = Managers.mechanism:game_mechanism()
	local get_slot_reservation_handler = game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

	get_slot_reservation_handler = get_slot_reservation_handler or game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

	local flag_3 = false

	for k, v in pairs(self._player_slots_by_peer_id) do
		if not _match_handler:query_peer_data(k, "is_synced") then
			local get_peer_reserved_indices, var_22_7 = get_slot_reservation_handler:get_peer_reserved_indices(k)

			if not (get_peer_reserved_indices ~= v.party_id or var_22_7 == v.slot_id) then
				self:_remove_all_players()

				flag_3 = true
				flag_2 = true

				break
			end
		else
			self._parent:play_sound("versus_hud_player_lobby_friend_leaves_lobby")
			self:_remove_player(v)

			flag_2 = true
		end
	end

	if not self._matchmaking_manager:is_in_versus_custom_game_lobby() then
		return
	end

	local get_match_owner_2 = _match_handler:get_match_owner()
	local query_peer_data = _match_handler:query_peer_data(self._peer_id, "is_match_owner")
	local get_peer_reserved_indices_2 = get_slot_reservation_handler:get_peer_reserved_indices(self._peer_id)
	local str = "local_player_team_lighter"
	local str_2 = "opponent_team_lighter"

	if get_peer_reserved_indices_2 ~= 1 then
		str, str_2 = str_2, str
	end

	self._is_match_host = query_peer_data

	local content = self._widgets_by_name.leave_game_button.content
	local var_22_14

	if not query_peer_data then
		var_22_14 = Localize("vs_ui_cancel_hosting")

		if not var_22_14 then
			-- Nothing
		end
	end

	var_22_14 = Localize("leave_game_menu_button_name")

	::label_22_0::

	content.title_text = var_22_14

	local peers = get_slot_reservation_handler:peers()

	for k_2 = 1, #peers do
		local var_22_16 = peers[k_2]

		if not self._player_slots_by_peer_id[var_22_16] then
			-- Nothing
		elseif not _match_handler:query_peer_data(var_22_16, "is_synced") then
			-- Nothing
		else
			local get_peer_reserved_indices_3, var_22_18 = get_slot_reservation_handler:get_peer_reserved_indices(var_22_16)

			if not get_peer_reserved_indices_3 then
				-- Nothing
			else
				if not flag_3 then
					self._parent:play_sound("versus_hud_player_lobby_friend_joins_lobby")
				end

				local _find_first_available_slot = self:_find_first_available_slot(get_peer_reserved_indices_3, var_22_18)

				self._player_slots_by_peer_id[var_22_16] = _find_first_available_slot
				_find_first_available_slot.peer_id = var_22_16
				_find_first_available_slot.party_id = get_peer_reserved_indices_3
				_find_first_available_slot.slot_id = _find_first_available_slot.panel_widget.content.player_index

				local panel_widget = _find_first_available_slot.panel_widget
				local flag_4 = var_22_16 == get_match_owner_2

				panel_widget.content.show_host = flag_4
				panel_widget.content.empty = false
				panel_widget.content.peer_id = var_22_16

				local query_peer_data_2 = _match_handler:query_peer_data(var_22_16, "player_name")

				if not (not query_peer_data_2 and query_peer_data_2 ~= "") then
					query_peer_data_2 = PlayerUtils.player_name(var_22_16, nil)
				end

				panel_widget.content.player_name = UIRenderer.crop_text(query_peer_data_2, 18)
				_find_first_available_slot.has_avatar = not flag

				self:_apply_team_color(panel_widget, get_peer_reserved_indices_3 ~= 1 or not str or str_2)

				if var_22_16 == self._peer_id then
					self:_apply_team_color(self._widgets_by_name.team_1, str)
					self:_apply_team_color(self._widgets_by_name.team_2, str_2)
				end

				panel_widget.content.show_profile_button = true
				panel_widget.content.show_chat_button = var_22_16 ~= self._peer_id
				panel_widget.content.chat_button_hotspot.is_selected = Managers.chat:ignoring_peer_id(var_22_16)

				local flag_5 = not query_peer_data and _match_handler:query_peer_data(var_22_16, "leader_peer_id") == self._peer_id

				panel_widget.content.show_kick_button = not query_peer_data and not not flag_4 or not flag_5

				local query_peer_data_3 = _match_handler:query_peer_data(var_22_16, "versus_level")

				panel_widget.content.player_level = string.format(Localize("versus_level"), query_peer_data_3)

				local get_insignia_texture_settings_from_level, var_22_26 = UIAtlasHelper.get_insignia_texture_settings_from_level(query_peer_data_3)

				panel_widget.content.insignia_main.uvs = get_insignia_texture_settings_from_level
				panel_widget.content.insignia_addon.uvs = var_22_26

				local get_friend_party_id_from_peer = Managers.party:get_friend_party_id_from_peer(var_22_16)

				get_friend_party_id_from_peer = get_friend_party_id_from_peer or 1
				panel_widget.style.party_color.color = Colors.get_categorical_color(get_friend_party_id_from_peer - 1)
				flag_2 = true
			end
		end
	end

	if not flag_2 then
		for l = 1, num do
			local num_3 = 0

			for k_3, v_2 in pairs(self._player_slots_by_team[l]) do
				if not v_2.panel_widget.content.empty then
					num_3 = num_3 + 1
				end
			end

			local var_22_29 = self._widgets_by_name["team_" .. l]

			if not var_22_29 then
				local format = string.format("%s %d/%d", Localize("lb_players"), num_3, num_2)

				var_22_29.content.player_count = format
			end
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._apply_team_color = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	local var_23_0 = Colors.color_definitions[arg_23_2]
	local style = arg_23_1.style

	for k, v in pairs(arg_23_1.content.styles_with_team_color) do
		local var_23_2 = style[v]
		local color = var_23_2.color

		color = color or var_23_2.text_color

		if not color then
			Colors.copy_no_alpha_to(color, var_23_0)
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._update_options_view = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not self._is_options_view_active then
		self._options_view:update(arg_24_1, arg_24_2)
	end
end

StartGameWindowVersusPlayerHostedLobby._update_mission_option = function (self)
	-- function 25
	local query_peer_data = self._match_handler:query_peer_data(self._peer_id, "is_match_owner")
	local var_25_1

	if not query_peer_data then
		var_25_1 = self._parent:get_selected_level_id()
	else
		local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

		if not query_lobby then
			query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")
			query_lobby = query_lobby or Managers.matchmaking.lobby
		end

		var_25_1 = not query_lobby and query_lobby:lobby_data("selected_mission_id")
	end

	var_25_1 = var_25_1 or "any"

	if var_25_1 == self._selected_level_id then
		return
	end

	self._selected_level_id = var_25_1

	local var_25_3

	if not (not var_25_1 and var_25_1 == "any") then
		var_25_3 = LevelSettings[var_25_1]

		if not var_25_3 then
			-- Nothing
		end
	end

	var_25_3 = DummyAnyLevel

	::label_25_0::

	local display_name = var_25_3.display_name
	local level_image = var_25_3.level_image
	local num = 0
	local mission_setting = self._widgets_by_name.mission_setting

	mission_setting.content.input_text = Localize(display_name)
	mission_setting.content.icon_texture = level_image
	mission_setting.content.icon_frame_texture = UIWidgetUtils.get_level_frame_by_difficulty_index(num)
end

StartGameWindowVersusPlayerHostedLobby._handle_gamepad_input = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not self._player_slots_by_team then
		return
	end

	if not self._ui_animator:is_animation_completed(self._enter_animation) then
		return
	end

	local _parent = self._parent
	local window_input_service = _parent:window_input_service()
	local game_mechanism = Managers.mechanism:game_mechanism()
	local get_match_owner = self._match_handler:get_match_owner()
	local get_slot_reservation_handler = game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

	get_slot_reservation_handler = get_slot_reservation_handler or game_mechanism:get_slot_reservation_handler(get_match_owner, scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

	local _selected_row = self._selected_row

	_selected_row = _selected_row or 1

	local _selected_column = self._selected_column

	_selected_column = _selected_column or 1

	local content = self._widgets_by_name.mission_setting.content
	local content_2 = self._widgets_by_name.toggle_custom_settings_button.content

	if self._input_focus_mode == tbl.selection then
		if _selected_row > tbl_2[_selected_column] then
			_selected_row = 1
		end

		if not window_input_service:get("move_up") then
			if _selected_row - 1 >= 1 then
				_selected_row = _selected_row - 1
			else
				_selected_row = tbl_2[_selected_column]
			end
		elseif not window_input_service:get("move_down") then
			if _selected_row + 1 <= tbl_2[_selected_column] then
				_selected_row = _selected_row + 1
			else
				_selected_row = 1
			end
		end

		if not window_input_service:get("move_right") then
			if _selected_column + 1 <= num_3 then
				_selected_column = _selected_column + 1
			else
				_selected_column = 1
			end
		elseif not window_input_service:get("move_left") then
			if _selected_column - 1 >= 1 then
				_selected_column = _selected_column - 1
			else
				_selected_column = num_3
			end
		end

		if not (self._selected_row ~= _selected_row or self._selected_column == _selected_column) then
			self._selected_row = _selected_row
			self._selected_column = _selected_column
		end

		for i = 1, num_3 do
			local var_26_9 = tbl_4[i]
			local var_26_10 = tbl_2[i]

			if not var_26_9 then
				local var_26_11 = self._player_slots_by_team[var_26_9]

				for j = 1, var_26_10 do
					var_26_11[j].panel_widget.content.is_selected = _selected_row ~= j or tbl_4[_selected_column] == var_26_9
				end
			else
				local var_26_12 = tbl_2[i]
				local var_26_13 = tbl_3[i]

				if not var_26_13 then
					for k = 1, var_26_12 do
						local var_26_14 = var_26_13[k]

						if not var_26_14 then
							local var_26_15 = self._widgets_by_name[var_26_14]
							local flag = _selected_column ~= i or _selected_row == k

							var_26_15.content.is_selected = flag
							var_26_15.content.button_hotspot.is_hover = flag
						end
					end
				end
			end

			if _selected_column == get_slot_reservation_handler:get_peer_reserved_indices(self._peer_id) or not tbl_4[_selected_column] then
				_parent:set_input_description("versus_player_hosted_lobby_change_team")
			elseif not tbl_4[_selected_column] then
				_parent:set_input_description("versus_player_hosted_lobby_select_mission")
			else
				_parent:set_input_description("versus_player_hosted_lobby")
			end
		end

		if not window_input_service:get("confirm") and not tbl_4[self._selected_column] then
			local _selected_row_2 = self._selected_row
			local _selected_column_2 = self._selected_column
			local var_26_19 = tbl_4[_selected_column_2]
			local content_3 = self._player_slots_by_team[var_26_19][_selected_row_2].panel_widget.content

			if not content_3.empty then
				local team_index = content_3.team_index

				get_slot_reservation_handler:request_party_change(team_index)
				_parent:play_sound("versus_hud_player_lobby_switch_slot")
			else
				self._input_focus_mode = tbl.panel_focus

				_parent:pause_input(true)
				self:_set_player_panel_focused(_selected_column_2, _selected_row_2, true)
				_parent:set_input_description("versus_player_hosted_lobby_player_panel_focused")
			end
		elseif not window_input_service:get("confirm") and not content.is_selected then
			local current_mechanism_name = Managers.mechanism:current_mechanism_name()
			local get_custom_game_settings = _parent:get_custom_game_settings(current_mechanism_name)

			_parent:set_layout_by_name(get_custom_game_settings.layout_name)
		elseif not content_2.is_selected and not self._is_server and not self._game_mechanism:is_hosting_versus_custom_game() and not window_input_service:get("confirm") then
			local flag_2 = not self._custom_settings_toggled

			content_2.button_hotspot.is_selected = flag_2

			self:_enable_custom_game_settings(flag_2)

			self._custom_settings_toggled = flag_2
		end

		if not window_input_service:get("right_stick_press") and not self._custom_settings_toggled then
			Managers.state.event:trigger("event_focus_custom_game_settings_input", true)

			self._input_focus_mode = tbl.custom_settings
		end
	elseif self._input_focus_mode == tbl.panel_focus then
		local _get_player_panel_widget = self:_get_player_panel_widget(self._selected_column, self._selected_row)

		if not _get_player_panel_widget then
			local content_4 = _get_player_panel_widget.content

			if not content_4.show_profile_button and not window_input_service:get("toggle_menu") then
				Managers.account:show_player_profile(content_4.peer_id)
			end

			if not content_4.show_kick_button and not window_input_service:get("refresh_press") then
				local server_get_friend_party_from_peer = Managers.party:server_get_friend_party_from_peer(content_4.peer_id)

				self._matchmaking_manager:cancel_matchmaking_for_peer(server_get_friend_party_from_peer.leader)
			end

			if not content_4.show_chat_button and not window_input_service:get("special_1_press") then
				local peer_id = content_4.peer_id
				local ignoring_peer_id = Managers.chat:ignoring_peer_id(peer_id)

				if not ignoring_peer_id then
					Managers.chat:remove_ignore_peer_id(peer_id)
				else
					Managers.chat:ignore_peer_id(peer_id)
				end

				content_4.chat_button_hotspot.is_selected = ignoring_peer_id
			end
		end

		if not window_input_service:get("back") then
			self._input_focus_mode = tbl.selection

			_parent:pause_input(false)
			self:_set_player_panel_focused(self._selected_column, self._selected_row, false)
			_parent:set_input_description("versus_player_hosted_lobby")
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._update_server_name = function (self)
	-- function 27
	local lobby_name = self._widgets_by_name.lobby_name
	local input = lobby_name.content.input
	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not query_lobby then
		query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")
		query_lobby = query_lobby or Managers.matchmaking.lobby
	end

	if not self._match_handler:query_peer_data(self._peer_id, "is_match_owner") then
		local lobby_data

		if not query_lobby then
			lobby_data = query_lobby:lobby_data("custom_server_name")

			if not lobby_data then
				-- Nothing
			end
		end

		lobby_data = ""

		::label_27_0::

		if lobby_data == "n/a" then
			lobby_data = Localize("lb_game_type_versus_custom_game")
		end

		input.text = lobby_data
		input.default_text = ""

		return
	end

	if not input.active then
		local window_input_service = self._parent:window_input_service()
		local get = window_input_service:get("toggle_menu", true)

		get = get or window_input_service:get("back", true)

		local get_2 = window_input_service:get("execute_chat_input", true)

		if get or not get_2 then
			local get_stored_lobby_data = query_lobby:get_stored_lobby_data()

			input.text = cjson.decode(cjson.encode(input.text))

			if not string.find(input.text, "%S") then
				input.text = ""
			end

			get_stored_lobby_data.custom_server_name = input.text

			query_lobby:set_lobby_data(get_stored_lobby_data)

			input.active = false

			self._parent.parent:set_input_blocked(false)
		end
	elseif not UIUtils.is_button_pressed(lobby_name) then
		input.caret_index = 1 + Utf8.length(input.text)
		input.active = true

		self._parent.parent:set_input_blocked(true)
	end
end

StartGameWindowVersusPlayerHostedLobby._set_player_panel_focused = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local var_28_0 = tbl_4[arg_28_1]

	if not var_28_0 then
		arg_28_0._player_slots_by_team[var_28_0][arg_28_2].panel_widget.content.focused = arg_28_3
	end
end

StartGameWindowVersusPlayerHostedLobby._get_player_panel_widget = function (self, arg_29_1, arg_29_2)
	-- function 29
	local var_29_0 = tbl_4[arg_29_1]

	if not var_29_0 then
		return self._player_slots_by_team[var_29_0][arg_29_2].panel_widget
	end

	return nil
end

StartGameWindowVersusPlayerHostedLobby.focus_versus_hosted_lobby_input = function (self)
	-- function 30
	self._input_focus_mode = tbl.selection

	self._parent:set_input_description("versus_player_hosted_lobby")

	local get_custom_game_settings_handler = Managers.mechanism:game_mechanism():get_custom_game_settings_handler()
end

StartGameWindowVersusPlayerHostedLobby._is_other_option_button_selected = function (self, arg_31_1, arg_31_2)
	-- function 31
	if not self._is_server and not self._game_mechanism:is_hosting_versus_custom_game() and not UIUtils.is_button_pressed(arg_31_1) then
		local flag = not arg_31_2

		if not flag then
			self._parent:play_sound("play_gui_lobby_button_03_private")
		else
			self._parent:play_sound("play_gui_lobby_button_03_public")
		end

		return flag
	end

	return nil
end

StartGameWindowVersusPlayerHostedLobby._lobby_member_game_mode_custom_settings_handler_enabled = function (self, arg_32_1)
	-- function 32
	if not (self._is_server or self._game_mechanism:is_hosting_versus_custom_game()) then
		local toggle_custom_settings_button = self._widgets_by_name.toggle_custom_settings_button

		self._custom_settings_toggled = arg_32_1
		toggle_custom_settings_button.content.button_hotspot.is_selected = arg_32_1

		local input = Managers.input

		input = not input and Managers.input:is_device_active("gamepad")

		if not input then
			Managers.state.event:trigger("event_focus_custom_game_settings_input", arg_32_1)
		end
	end
end
