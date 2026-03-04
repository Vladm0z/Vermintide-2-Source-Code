-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_player_hosted_lobby.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_player_hosted_lobby_definitions")
local var_0_1 = var_0_0.animation_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")
local var_0_4 = 2
local var_0_5 = 4
local var_0_6 = "gui/1080p/single_textures/generic/transparent_placeholder_texture"
local var_0_7 = true

StartGameWindowVersusPlayerHostedLobby = class(StartGameWindowVersusPlayerHostedLobby)
StartGameWindowVersusPlayerHostedLobby.NAME = "StartGameWindowPlayerHostedLobby"

local var_0_8 = {
	"selection",
	"panel_focus",
	panel_focus = 2,
	[3] = "custom_settings",
	selection = 1,
	custom_settings = 3
}
local var_0_9 = 3
local var_0_10 = {
	4,
	2,
	4
}
local var_0_11 = {
	[2] = {
		[1] = "mission_setting",
		[2] = "toggle_custom_settings_button"
	}
}
local var_0_12 = {
	[1] = 1,
	[3] = 2
}

StartGameWindowVersusPlayerHostedLobby.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._matchmaking_manager = var_1_0.matchmaking_manager
	arg_1_0._is_server = var_1_0.is_server
	arg_1_0._peer_id = var_1_0.peer_id
	arg_1_0._is_loading = true
	arg_1_0._match_handler = Managers.mechanism:network_handler():get_match_handler()
	arg_1_0._options_view = var_1_0.ingame_ui.views.options_view
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.mechanism:game_mechanism()

	arg_1_0._custom_settings_toggled = var_1_1:is_hosting_versus_custom_game() and var_1_1:custom_settings_enabled() or false
	arg_1_0._game_mechanism = var_1_1

	arg_1_0:_create_ui_elements()

	arg_1_0._enter_animation = arg_1_0:_play_animation("on_enter")

	arg_1_0._parent:set_hide_panel_title_butttons(true)
	arg_1_0._parent:set_input_description("versus_player_hosted_lobby")

	arg_1_0._input_focus_mode = var_0_8.selection
	arg_1_0._focus_panel_button_idx = 1

	Managers.state.event:register(arg_1_0, "event_focus_versus_hosted_lobby_input", "focus_versus_hosted_lobby_input")
	Managers.state.event:register(arg_1_0, "lobby_member_game_mode_custom_settings_handler_enabled", "_lobby_member_game_mode_custom_settings_handler_enabled")
end

StartGameWindowVersusPlayerHostedLobby._play_animation = function (arg_2_0, arg_2_1)
	local var_2_0 = {
		render_settings = arg_2_0._render_settings
	}

	return (arg_2_0._ui_animator:start_animation(arg_2_1, arg_2_0._widgets_by_name, var_0_2, var_2_0))
end

StartGameWindowVersusPlayerHostedLobby._create_ui_elements = function (arg_3_0)
	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)
	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_top_renderer)

	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_3_0 = {}
	local var_3_1 = {}
	local var_3_2 = var_0_0.widget_definitions

	UIUtils.create_widgets(var_3_2, var_3_0, var_3_1)

	local var_3_3 = {}
	local var_3_4 = var_0_0.host_widget_definitions

	UIUtils.create_widgets(var_3_4, var_3_3, var_3_1)

	arg_3_0._widgets = var_3_0
	arg_3_0._host_widgets = var_3_3
	arg_3_0._widgets_by_name = var_3_1

	local var_3_5 = Managers.lobby:query_lobby("matchmaking_join_lobby") or Managers.lobby:query_lobby("matchmaking_join_lobby") or Managers.matchmaking.lobby
	local var_3_6 = var_3_5 and var_3_5:lobby_data("custom_server_name") or ""
	local var_3_7 = rawget(_G, "Steam") and Steam.user_name() ~= var_3_6 and var_3_6 ~= "n/a" and var_3_6 ~= ""

	arg_3_0._widgets_by_name.lobby_name.content.input.default_text = var_3_7 and var_3_6 or Localize("start_game_window_custom_lobby_name_hint")
	arg_3_0._widgets_by_name.toggle_custom_settings_button.content.button_hotspot.is_selected = arg_3_0._custom_settings_toggled
	arg_3_0._loading_spinner_widget = UIWidget.init(var_0_0.loading_spinner_definition)
	arg_3_0._console_cursor = UIWidget.init(var_0_0.console_cursor_definition)

	arg_3_0:_create_player_slots()

	arg_3_0._ui_animator = UIAnimator:new(arg_3_0._ui_scenegraph, var_0_1)
end

StartGameWindowVersusPlayerHostedLobby.on_exit = function (arg_4_0, arg_4_1)
	arg_4_0._ui_animator = nil

	arg_4_0._parent:play_sound("Play_vs_hud_play_menu_leave_lobby")
	arg_4_0:_remove_all_players()
	Managers.state.event:unregister("event_focus_versus_hosted_lobby_input", arg_4_0)
	Managers.state.event:unregister("lobby_member_game_mode_custom_settings_handler_enabled", arg_4_0)
end

StartGameWindowVersusPlayerHostedLobby._exit_layout = function (arg_5_0)
	local var_5_0 = arg_5_0._match_handler:query_peer_data(arg_5_0._peer_id, "is_match_owner") and "versus_custom_game" or "versus_lobby_browser"
	local var_5_1 = arg_5_0._parent

	var_5_1:set_layout_by_name(var_5_0)
	var_5_1:set_hide_panel_title_butttons(false)
end

StartGameWindowVersusPlayerHostedLobby.on_exit = function (arg_6_0, arg_6_1)
	arg_6_0._ui_animator = nil

	arg_6_0._parent:play_sound("Play_vs_hud_play_menu_leave_lobby")
	arg_6_0:_remove_all_players()

	arg_6_1.return_layout_name = nil
end

StartGameWindowVersusPlayerHostedLobby.update = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Managers.input:is_device_active("gamepad")

	if not arg_7_0._matchmaking_manager:is_game_matchmaking() then
		arg_7_0:_exit_layout()

		return
	end

	if not arg_7_0._is_loading then
		arg_7_0:_update_options_view(arg_7_1, arg_7_2)
		arg_7_0:_update_mission_option()
		arg_7_0:_update_animations(arg_7_1, arg_7_2)
		arg_7_0:_update_can_play()
		arg_7_0:_update_play_button_texture(var_7_0)

		if var_7_0 then
			arg_7_0:_handle_gamepad_input(arg_7_1, arg_7_2)
		else
			arg_7_0:_handle_input(arg_7_2)
		end

		arg_7_0:_update_toggle_settings_button(arg_7_1, arg_7_2, var_7_0)
		arg_7_0:_update_server_name()
		arg_7_0:_update_avatars()
		arg_7_0:_update_custom_lobby_slots()
	end

	arg_7_0:_draw(arg_7_1)

	local var_7_1 = Managers.mechanism:network_handler():get_match_handler():get_match_owner()

	arg_7_0._is_loading = not Managers.mechanism:mechanism_try_call("get_all_reservation_handlers_by_owner", var_7_1) or not arg_7_0._matchmaking_manager:is_in_versus_custom_game_lobby()
end

StartGameWindowVersusPlayerHostedLobby.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	return
end

StartGameWindowVersusPlayerHostedLobby._update_avatars = function (arg_9_0)
	for iter_9_0, iter_9_1 in pairs(arg_9_0._player_slots_by_peer_id) do
		if not iter_9_1.has_avatar then
			local var_9_0, var_9_1 = Friends.get_avatar(iter_9_0)

			if var_9_0 > 0 and var_9_1 then
				local var_9_2 = arg_9_0._ui_top_renderer.gui
				local var_9_3 = Gui.clone_material_from_template(var_9_2, iter_9_0, "template_store_diffuse")

				Material.set_resource(var_9_3, "diffuse_map", var_9_1)

				iter_9_1.panel_widget.content.player_avatar = var_9_3
				iter_9_1.has_avatar = true
			elseif var_9_0 == 0 then
				iter_9_1.has_avatar = true
			end
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._can_play = function (arg_10_0)
	local var_10_0 = true
	local var_10_1 = "tutorial_no_text"

	if arg_10_0._matchmaking_manager:is_player_hosting() then
		local var_10_2 = arg_10_0._match_handler:get_match_owner()
		local var_10_3 = var_10_2 == Network.peer_id()
		local var_10_4 = Managers.mechanism:game_mechanism()
		local var_10_5 = (var_10_4:get_slot_reservation_handler(var_10_2, var_0_3.pending_custom_game) or var_10_4:get_slot_reservation_handler(var_10_2, var_0_3.session)):all_teams_have_members()
		local var_10_6 = Managers.state.network.network_server
		local var_10_7 = var_10_3 and var_10_6:are_all_peers_ingame(nil, true)

		if not var_10_5 and not Development.parameter("allow_versus_force_start_single_player") or not var_10_7 then
			var_10_0 = false
			var_10_1 = "interaction_action_missing_players"
		end
	end

	return var_10_0, var_10_1
end

StartGameWindowVersusPlayerHostedLobby._update_can_play = function (arg_11_0)
	local var_11_0, var_11_1 = arg_11_0:_can_play()
	local var_11_2 = arg_11_0._widgets_by_name

	var_11_2.force_start_button.content.button_hotspot.disable_button = not var_11_0
	var_11_2.locked_reason.content.text = var_11_1
end

StartGameWindowVersusPlayerHostedLobby._update_play_button_texture = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._widgets_by_name

	if arg_12_0._gamepad_active ~= arg_12_1 then
		arg_12_0._gamepad_active = arg_12_1

		if arg_12_1 then
			local var_12_1 = arg_12_0._parent:window_input_service()
			local var_12_2 = "refresh"
			local var_12_3 = UISettings.get_gamepad_input_texture_data(var_12_1, var_12_2, arg_12_1)

			if var_12_3 then
				var_12_0.force_start_button.content.texture_icon_id = var_12_3.texture
			end
		else
			var_12_0.force_start_button.content.texture_icon_id = "options_button_icon_quickplay"
		end

		var_12_0.force_start_button.content.is_selected = arg_12_1
	end
end

StartGameWindowVersusPlayerHostedLobby._update_animations = function (arg_13_0, arg_13_1, arg_13_2)
	arg_13_0._ui_animator:update(arg_13_1)

	local var_13_0 = arg_13_0._widgets_by_name.force_start_button

	if not var_13_0.content.button_hotspot.disable_button then
		UIWidgetUtils.animate_play_button(var_13_0, arg_13_1)
	end

	UIWidgetUtils.animate_start_game_console_setting_button(arg_13_0._widgets_by_name.mission_setting, arg_13_1)

	local var_13_1 = arg_13_0._widgets_by_name.leave_game_button

	UIWidgetUtils.animate_default_button(var_13_1, arg_13_1)
end

StartGameWindowVersusPlayerHostedLobby._draw = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._ui_top_renderer
	local var_14_1 = arg_14_0._ui_scenegraph
	local var_14_2 = arg_14_0._parent:window_input_service()
	local var_14_3 = arg_14_0._render_settings

	UIRenderer.begin_pass(var_14_0, var_14_1, var_14_2, arg_14_1, nil, var_14_3)

	if arg_14_0._is_loading then
		UIRenderer.draw_widget(var_14_0, arg_14_0._loading_spinner_widget)
	else
		UIRenderer.draw_all_widgets(var_14_0, arg_14_0._widgets)
		UIRenderer.draw_all_widgets(var_14_0, arg_14_0._panel_widgets)

		if arg_14_0._matchmaking_manager:is_player_hosting() then
			UIRenderer.draw_all_widgets(var_14_0, arg_14_0._host_widgets)
		end
	end

	UIRenderer.end_pass(var_14_0)
end

StartGameWindowVersusPlayerHostedLobby._handle_input = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._parent:window_input_service()
	local var_15_1 = arg_15_0._matchmaking_manager
	local var_15_2 = arg_15_0._widgets_by_name.force_start_button

	if arg_15_0:_can_play() and (UIUtils.is_button_pressed(var_15_2) or var_15_0:get("force_start")) then
		var_15_1:force_start_game()
		arg_15_0._parent:play_sound("versus_hud_player_lobby_searching_for_match")
	end

	if UIUtils.is_button_hover_enter(var_15_2) then
		arg_15_0._parent:play_sound("Play_hud_hover")
	end

	local var_15_3 = arg_15_0._widgets_by_name.leave_game_button
	local var_15_4 = Managers.state.network.is_server

	var_15_3.content.button_hotspot.disable_button = not var_15_4

	if var_15_4 and (UIUtils.is_button_pressed(var_15_3) or var_15_0:get("cancel_matchmaking")) then
		var_15_1:cancel_matchmaking()
		var_15_1:pause_matchmaking_for_seconds(2)
		arg_15_0:_exit_layout()

		return
	end

	local var_15_5 = arg_15_0._widgets_by_name.mission_setting

	var_15_5.style.bg_effect.color[1] = arg_15_0._is_match_host and 255 or 0

	if arg_15_0._is_match_host then
		var_15_5.content.is_selected = UIUtils.is_button_hover(var_15_5)

		if UIUtils.is_button_pressed(var_15_5) then
			local var_15_6 = arg_15_0._parent
			local var_15_7 = Managers.mechanism:current_mechanism_name()
			local var_15_8 = var_15_6:get_custom_game_settings(var_15_7)

			var_15_6:set_layout_by_name(var_15_8.layout_name)
		end
	end

	for iter_15_0, iter_15_1 in pairs(arg_15_0._panel_widgets) do
		local var_15_9 = iter_15_1.content

		if var_15_9.empty then
			if UIUtils.is_button_pressed(iter_15_1) then
				local var_15_10 = var_15_9.team_index
				local var_15_11 = arg_15_0._match_handler:get_match_owner()
				local var_15_12 = Managers.mechanism:game_mechanism()

				;(var_15_12:get_slot_reservation_handler(var_15_11, var_0_3.pending_custom_game) or var_15_12:get_slot_reservation_handler(var_15_11, var_0_3.session)):request_party_change(var_15_10)
				arg_15_0._parent:play_sound("versus_hud_player_lobby_switch_slot")
			end
		else
			if UIUtils.is_button_pressed(iter_15_1, "profile_button_hotspot") then
				Managers.account:show_player_profile(var_15_9.peer_id)
			end

			if UIUtils.is_button_pressed(iter_15_1, "kick_button_hotspot") then
				local var_15_13 = Managers.party:server_get_friend_party_from_peer(var_15_9.peer_id)

				arg_15_0._matchmaking_manager:cancel_matchmaking_for_peer(var_15_13.leader)
			end

			if UIUtils.is_button_pressed(iter_15_1, "chat_button_hotspot") then
				local var_15_14 = var_15_9.peer_id
				local var_15_15 = Managers.chat:ignoring_peer_id(var_15_14)

				if var_15_15 then
					Managers.chat:remove_ignore_peer_id(var_15_14)
				else
					Managers.chat:ignore_peer_id(var_15_14)
				end

				var_15_9.chat_button_hotspot.is_selected = var_15_15
			end
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._update_toggle_settings_button = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0._widgets_by_name.toggle_custom_settings_button

	UIWidgetUtils.animate_default_checkbox_button_console(var_16_0, arg_16_1)

	var_16_0.content.button_hotspot.disable_button = not arg_16_0._game_mechanism:is_hosting_versus_custom_game()

	if UIUtils.is_button_hover_enter(var_16_0) then
		arg_16_0._parent:play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if arg_16_0._game_mechanism:is_hosting_versus_custom_game() then
		local var_16_1 = arg_16_0:_is_other_option_button_selected(var_16_0, arg_16_0._custom_settings_toggled)

		if var_16_1 ~= nil then
			arg_16_0._custom_settings_toggled = var_16_1
			var_16_0.content.button_hotspot.is_selected = var_16_1

			Managers.state.event:trigger("event_focus_custom_game_settings_input", var_16_1)
			arg_16_0:_enable_custom_game_settings(var_16_1)
		end
	else
		local var_16_2 = arg_16_0._game_mechanism:custom_settings_enabled()

		if arg_16_0._custom_settings_toggled ~= var_16_2 then
			var_16_0.content.button_hotspot.is_selected = var_16_2
			arg_16_0._custom_settings_toggled = var_16_2
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._enable_custom_game_settings = function (arg_17_0, arg_17_1)
	Managers.mechanism:game_mechanism():get_custom_game_settings_handler():set_enabled(arg_17_1, true)
	Managers.state.event:trigger("event_reset_host_settings", not arg_17_1)
end

StartGameWindowVersusPlayerHostedLobby._create_player_slots = function (arg_18_0)
	local var_18_0 = {}
	local var_18_1 = {}

	for iter_18_0 = 1, var_0_4 do
		local var_18_2 = {}

		var_18_1[iter_18_0] = var_18_2

		for iter_18_1 = 1, var_0_5 do
			local var_18_3 = {}

			var_18_2[iter_18_1] = var_18_3

			local var_18_4 = var_0_0.create_player_panel_widget(iter_18_0, iter_18_1)
			local var_18_5 = UIWidget.init(var_18_4)

			var_18_5.content.empty = true
			var_18_5.content.team_index = iter_18_0
			var_18_5.content.player_index = iter_18_1
			var_18_3.panel_widget = var_18_5
			var_18_0[#var_18_0 + 1] = var_18_5
		end
	end

	arg_18_0._num_players_by_team = {}
	arg_18_0._player_slots_by_team = var_18_1
	arg_18_0._player_slots_by_peer_id = {}
	arg_18_0._panel_widgets = var_18_0
end

StartGameWindowVersusPlayerHostedLobby._find_first_available_slot = function (arg_19_0, arg_19_1, arg_19_2)
	assert(arg_19_1)

	local var_19_0 = arg_19_0._player_slots_by_team[arg_19_1]
	local var_19_1 = var_19_0[arg_19_2]

	if var_19_1 and var_19_1.panel_widget.content.empty then
		return var_19_1
	end

	for iter_19_0 = 1, var_0_5 do
		local var_19_2 = var_19_0[iter_19_0]

		if var_19_2.panel_widget.content.empty then
			return var_19_2
		end
	end

	fassert(false, "No available slots!")
end

StartGameWindowVersusPlayerHostedLobby._remove_all_players = function (arg_20_0)
	for iter_20_0, iter_20_1 in pairs(arg_20_0._player_slots_by_peer_id) do
		arg_20_0:_remove_player(iter_20_1)
	end
end

StartGameWindowVersusPlayerHostedLobby._remove_player = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1.panel_widget
	local var_21_1 = arg_21_1.peer_id

	var_21_0.content.empty = true
	var_21_0.content.show_profile_button = false
	var_21_0.content.show_kick_button = false
	var_21_0.content.show_chat_button = false
	var_21_0.content.chat_button_hotspot.is_selected = false
	arg_21_1.slot_id = nil

	local var_21_2 = var_21_0.content.player_avatar

	if var_21_2 then
		Material.set_texture(var_21_2, "diffuse_map", var_0_6)

		var_21_0.content.player_avatar = nil
	end

	if var_0_7 then
		Friends.delete_avatar(var_21_1)
	end

	arg_21_0._player_slots_by_peer_id[var_21_1] = nil
end

StartGameWindowVersusPlayerHostedLobby._update_custom_lobby_slots = function (arg_22_0)
	local var_22_0 = false
	local var_22_1 = arg_22_0._match_handler
	local var_22_2 = var_22_1:get_match_owner()
	local var_22_3 = Managers.mechanism:game_mechanism()
	local var_22_4 = var_22_3:get_slot_reservation_handler(var_22_2, var_0_3.pending_custom_game) or var_22_3:get_slot_reservation_handler(var_22_2, var_0_3.session)
	local var_22_5 = false

	for iter_22_0, iter_22_1 in pairs(arg_22_0._player_slots_by_peer_id) do
		if var_22_1:query_peer_data(iter_22_0, "is_synced") then
			local var_22_6, var_22_7 = var_22_4:get_peer_reserved_indices(iter_22_0)

			if var_22_6 ~= iter_22_1.party_id or var_22_7 ~= iter_22_1.slot_id then
				arg_22_0:_remove_all_players()

				var_22_5 = true
				var_22_0 = true

				break
			end
		else
			arg_22_0._parent:play_sound("versus_hud_player_lobby_friend_leaves_lobby")
			arg_22_0:_remove_player(iter_22_1)

			var_22_0 = true
		end
	end

	if not arg_22_0._matchmaking_manager:is_in_versus_custom_game_lobby() then
		return
	end

	local var_22_8 = var_22_1:get_match_owner()
	local var_22_9 = var_22_1:query_peer_data(arg_22_0._peer_id, "is_match_owner")
	local var_22_10 = var_22_4:get_peer_reserved_indices(arg_22_0._peer_id)
	local var_22_11 = "local_player_team_lighter"
	local var_22_12 = "opponent_team_lighter"

	if var_22_10 ~= 1 then
		var_22_11, var_22_12 = var_22_12, var_22_11
	end

	arg_22_0._is_match_host = var_22_9
	arg_22_0._widgets_by_name.leave_game_button.content.title_text = var_22_9 and Localize("vs_ui_cancel_hosting") or Localize("leave_game_menu_button_name")

	local var_22_13 = var_22_4:peers()

	for iter_22_2 = 1, #var_22_13 do
		local var_22_14 = var_22_13[iter_22_2]

		if arg_22_0._player_slots_by_peer_id[var_22_14] then
			-- Nothing
		elseif not var_22_1:query_peer_data(var_22_14, "is_synced") then
			-- Nothing
		else
			local var_22_15, var_22_16 = var_22_4:get_peer_reserved_indices(var_22_14)

			if not var_22_15 then
				-- Nothing
			else
				if not var_22_5 then
					arg_22_0._parent:play_sound("versus_hud_player_lobby_friend_joins_lobby")
				end

				local var_22_17 = arg_22_0:_find_first_available_slot(var_22_15, var_22_16)

				arg_22_0._player_slots_by_peer_id[var_22_14] = var_22_17
				var_22_17.peer_id = var_22_14
				var_22_17.party_id = var_22_15
				var_22_17.slot_id = var_22_17.panel_widget.content.player_index

				local var_22_18 = var_22_17.panel_widget
				local var_22_19 = var_22_14 == var_22_8

				var_22_18.content.show_host = var_22_19
				var_22_18.content.empty = false
				var_22_18.content.peer_id = var_22_14

				local var_22_20 = var_22_1:query_peer_data(var_22_14, "player_name")

				if not var_22_20 or var_22_20 == "" then
					var_22_20 = PlayerUtils.player_name(var_22_14, nil)
				end

				var_22_18.content.player_name = UIRenderer.crop_text(var_22_20, 18)
				var_22_17.has_avatar = not var_0_7

				arg_22_0:_apply_team_color(var_22_18, var_22_15 == 1 and var_22_11 or var_22_12)

				if var_22_14 == arg_22_0._peer_id then
					arg_22_0:_apply_team_color(arg_22_0._widgets_by_name.team_1, var_22_11)
					arg_22_0:_apply_team_color(arg_22_0._widgets_by_name.team_2, var_22_12)
				end

				var_22_18.content.show_profile_button = true
				var_22_18.content.show_chat_button = var_22_14 ~= arg_22_0._peer_id
				var_22_18.content.chat_button_hotspot.is_selected = Managers.chat:ignoring_peer_id(var_22_14)

				local var_22_21 = var_22_9 and var_22_1:query_peer_data(var_22_14, "leader_peer_id") == arg_22_0._peer_id

				var_22_18.content.show_kick_button = var_22_9 and not var_22_19 and not var_22_21

				local var_22_22 = var_22_1:query_peer_data(var_22_14, "versus_level")

				var_22_18.content.player_level = string.format(Localize("versus_level"), var_22_22)

				local var_22_23, var_22_24 = UIAtlasHelper.get_insignia_texture_settings_from_level(var_22_22)

				var_22_18.content.insignia_main.uvs = var_22_23
				var_22_18.content.insignia_addon.uvs = var_22_24

				local var_22_25 = Managers.party:get_friend_party_id_from_peer(var_22_14) or 1

				var_22_18.style.party_color.color = Colors.get_categorical_color(var_22_25 - 1)
				var_22_0 = true
			end
		end
	end

	if var_22_0 then
		for iter_22_3 = 1, var_0_4 do
			local var_22_26 = 0

			for iter_22_4, iter_22_5 in pairs(arg_22_0._player_slots_by_team[iter_22_3]) do
				if not iter_22_5.panel_widget.content.empty then
					var_22_26 = var_22_26 + 1
				end
			end

			local var_22_27 = arg_22_0._widgets_by_name["team_" .. iter_22_3]

			if var_22_27 then
				local var_22_28 = string.format("%s %d/%d", Localize("lb_players"), var_22_26, var_0_5)

				var_22_27.content.player_count = var_22_28
			end
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._apply_team_color = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = Colors.color_definitions[arg_23_2]
	local var_23_1 = arg_23_1.style

	for iter_23_0, iter_23_1 in pairs(arg_23_1.content.styles_with_team_color) do
		local var_23_2 = var_23_1[iter_23_1]
		local var_23_3 = var_23_2.color or var_23_2.text_color

		if var_23_3 then
			Colors.copy_no_alpha_to(var_23_3, var_23_0)
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._update_options_view = function (arg_24_0, arg_24_1, arg_24_2)
	if arg_24_0._is_options_view_active then
		arg_24_0._options_view:update(arg_24_1, arg_24_2)
	end
end

StartGameWindowVersusPlayerHostedLobby._update_mission_option = function (arg_25_0)
	local var_25_0 = arg_25_0._match_handler:query_peer_data(arg_25_0._peer_id, "is_match_owner")
	local var_25_1

	if var_25_0 then
		var_25_1 = arg_25_0._parent:get_selected_level_id()
	else
		local var_25_2 = Managers.lobby:query_lobby("matchmaking_join_lobby") or Managers.lobby:query_lobby("matchmaking_join_lobby") or Managers.matchmaking.lobby

		var_25_1 = var_25_2 and var_25_2:lobby_data("selected_mission_id")
	end

	var_25_1 = var_25_1 or "any"

	if var_25_1 == arg_25_0._selected_level_id then
		return
	end

	arg_25_0._selected_level_id = var_25_1

	local var_25_3 = var_25_1 and var_25_1 ~= "any" and LevelSettings[var_25_1] or DummyAnyLevel
	local var_25_4 = var_25_3.display_name
	local var_25_5 = var_25_3.level_image
	local var_25_6 = 0
	local var_25_7 = arg_25_0._widgets_by_name.mission_setting

	var_25_7.content.input_text = Localize(var_25_4)
	var_25_7.content.icon_texture = var_25_5
	var_25_7.content.icon_frame_texture = UIWidgetUtils.get_level_frame_by_difficulty_index(var_25_6)
end

StartGameWindowVersusPlayerHostedLobby._handle_gamepad_input = function (arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0._player_slots_by_team then
		return
	end

	if not arg_26_0._ui_animator:is_animation_completed(arg_26_0._enter_animation) then
		return
	end

	local var_26_0 = arg_26_0._parent
	local var_26_1 = var_26_0:window_input_service()
	local var_26_2 = Managers.mechanism:game_mechanism()
	local var_26_3 = arg_26_0._match_handler:get_match_owner()
	local var_26_4 = var_26_2:get_slot_reservation_handler(var_26_3, var_0_3.pending_custom_game) or var_26_2:get_slot_reservation_handler(var_26_3, var_0_3.session)
	local var_26_5 = arg_26_0._selected_row or 1
	local var_26_6 = arg_26_0._selected_column or 1
	local var_26_7 = arg_26_0._widgets_by_name.mission_setting.content
	local var_26_8 = arg_26_0._widgets_by_name.toggle_custom_settings_button.content

	if arg_26_0._input_focus_mode == var_0_8.selection then
		if var_26_5 > var_0_10[var_26_6] then
			var_26_5 = 1
		end

		if var_26_1:get("move_up") then
			if var_26_5 - 1 >= 1 then
				var_26_5 = var_26_5 - 1
			else
				var_26_5 = var_0_10[var_26_6]
			end
		elseif var_26_1:get("move_down") then
			if var_26_5 + 1 <= var_0_10[var_26_6] then
				var_26_5 = var_26_5 + 1
			else
				var_26_5 = 1
			end
		end

		if var_26_1:get("move_right") then
			if var_26_6 + 1 <= var_0_9 then
				var_26_6 = var_26_6 + 1
			else
				var_26_6 = 1
			end
		elseif var_26_1:get("move_left") then
			if var_26_6 - 1 >= 1 then
				var_26_6 = var_26_6 - 1
			else
				var_26_6 = var_0_9
			end
		end

		if arg_26_0._selected_row ~= var_26_5 or arg_26_0._selected_column ~= var_26_6 then
			arg_26_0._selected_row = var_26_5
			arg_26_0._selected_column = var_26_6
		end

		for iter_26_0 = 1, var_0_9 do
			local var_26_9 = var_0_12[iter_26_0]
			local var_26_10 = var_0_10[iter_26_0]

			if var_26_9 then
				local var_26_11 = arg_26_0._player_slots_by_team[var_26_9]

				for iter_26_1 = 1, var_26_10 do
					var_26_11[iter_26_1].panel_widget.content.is_selected = var_26_5 == iter_26_1 and var_0_12[var_26_6] == var_26_9
				end
			else
				local var_26_12 = var_0_10[iter_26_0]
				local var_26_13 = var_0_11[iter_26_0]

				if var_26_13 then
					for iter_26_2 = 1, var_26_12 do
						local var_26_14 = var_26_13[iter_26_2]

						if var_26_14 then
							local var_26_15 = arg_26_0._widgets_by_name[var_26_14]
							local var_26_16 = var_26_6 == iter_26_0 and var_26_5 == iter_26_2

							var_26_15.content.is_selected = var_26_16
							var_26_15.content.button_hotspot.is_hover = var_26_16
						end
					end
				end
			end

			if var_26_6 ~= var_26_4:get_peer_reserved_indices(arg_26_0._peer_id) and var_0_12[var_26_6] then
				var_26_0:set_input_description("versus_player_hosted_lobby_change_team")
			elseif not var_0_12[var_26_6] then
				var_26_0:set_input_description("versus_player_hosted_lobby_select_mission")
			else
				var_26_0:set_input_description("versus_player_hosted_lobby")
			end
		end

		if var_26_1:get("confirm") and var_0_12[arg_26_0._selected_column] then
			local var_26_17 = arg_26_0._selected_row
			local var_26_18 = arg_26_0._selected_column
			local var_26_19 = var_0_12[var_26_18]
			local var_26_20 = arg_26_0._player_slots_by_team[var_26_19][var_26_17].panel_widget.content

			if var_26_20.empty then
				local var_26_21 = var_26_20.team_index

				var_26_4:request_party_change(var_26_21)
				var_26_0:play_sound("versus_hud_player_lobby_switch_slot")
			else
				arg_26_0._input_focus_mode = var_0_8.panel_focus

				var_26_0:pause_input(true)
				arg_26_0:_set_player_panel_focused(var_26_18, var_26_17, true)
				var_26_0:set_input_description("versus_player_hosted_lobby_player_panel_focused")
			end
		elseif var_26_1:get("confirm") and var_26_7.is_selected then
			local var_26_22 = Managers.mechanism:current_mechanism_name()
			local var_26_23 = var_26_0:get_custom_game_settings(var_26_22)

			var_26_0:set_layout_by_name(var_26_23.layout_name)
		elseif var_26_8.is_selected and arg_26_0._is_server and arg_26_0._game_mechanism:is_hosting_versus_custom_game() and var_26_1:get("confirm") then
			local var_26_24 = not arg_26_0._custom_settings_toggled

			var_26_8.button_hotspot.is_selected = var_26_24

			arg_26_0:_enable_custom_game_settings(var_26_24)

			arg_26_0._custom_settings_toggled = var_26_24
		end

		if var_26_1:get("right_stick_press") and arg_26_0._custom_settings_toggled then
			Managers.state.event:trigger("event_focus_custom_game_settings_input", true)

			arg_26_0._input_focus_mode = var_0_8.custom_settings
		end
	elseif arg_26_0._input_focus_mode == var_0_8.panel_focus then
		local var_26_25 = arg_26_0:_get_player_panel_widget(arg_26_0._selected_column, arg_26_0._selected_row)

		if var_26_25 then
			local var_26_26 = var_26_25.content

			if var_26_26.show_profile_button and var_26_1:get("toggle_menu") then
				Managers.account:show_player_profile(var_26_26.peer_id)
			end

			if var_26_26.show_kick_button and var_26_1:get("refresh_press") then
				local var_26_27 = Managers.party:server_get_friend_party_from_peer(var_26_26.peer_id)

				arg_26_0._matchmaking_manager:cancel_matchmaking_for_peer(var_26_27.leader)
			end

			if var_26_26.show_chat_button and var_26_1:get("special_1_press") then
				local var_26_28 = var_26_26.peer_id
				local var_26_29 = Managers.chat:ignoring_peer_id(var_26_28)

				if var_26_29 then
					Managers.chat:remove_ignore_peer_id(var_26_28)
				else
					Managers.chat:ignore_peer_id(var_26_28)
				end

				var_26_26.chat_button_hotspot.is_selected = var_26_29
			end
		end

		if var_26_1:get("back") then
			arg_26_0._input_focus_mode = var_0_8.selection

			var_26_0:pause_input(false)
			arg_26_0:_set_player_panel_focused(arg_26_0._selected_column, arg_26_0._selected_row, false)
			var_26_0:set_input_description("versus_player_hosted_lobby")
		end
	end
end

StartGameWindowVersusPlayerHostedLobby._update_server_name = function (arg_27_0)
	local var_27_0 = arg_27_0._widgets_by_name.lobby_name
	local var_27_1 = var_27_0.content.input
	local var_27_2 = Managers.lobby:query_lobby("matchmaking_join_lobby") or Managers.lobby:query_lobby("matchmaking_join_lobby") or Managers.matchmaking.lobby

	if not arg_27_0._match_handler:query_peer_data(arg_27_0._peer_id, "is_match_owner") then
		local var_27_3 = var_27_2 and var_27_2:lobby_data("custom_server_name") or ""

		if var_27_3 == "n/a" then
			var_27_3 = Localize("lb_game_type_versus_custom_game")
		end

		var_27_1.text = var_27_3
		var_27_1.default_text = ""

		return
	end

	if var_27_1.active then
		local var_27_4 = arg_27_0._parent:window_input_service()
		local var_27_5 = var_27_4:get("toggle_menu", true) or var_27_4:get("back", true)
		local var_27_6 = var_27_4:get("execute_chat_input", true)

		if var_27_5 or var_27_6 then
			local var_27_7 = var_27_2:get_stored_lobby_data()

			var_27_1.text = cjson.decode(cjson.encode(var_27_1.text))

			if not string.find(var_27_1.text, "%S") then
				var_27_1.text = ""
			end

			var_27_7.custom_server_name = var_27_1.text

			var_27_2:set_lobby_data(var_27_7)

			var_27_1.active = false

			arg_27_0._parent.parent:set_input_blocked(false)
		end
	elseif UIUtils.is_button_pressed(var_27_0) then
		var_27_1.caret_index = 1 + UTF8Utils.string_length(var_27_1.text)
		var_27_1.active = true

		arg_27_0._parent.parent:set_input_blocked(true)
	end
end

StartGameWindowVersusPlayerHostedLobby._set_player_panel_focused = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = var_0_12[arg_28_1]

	if var_28_0 then
		arg_28_0._player_slots_by_team[var_28_0][arg_28_2].panel_widget.content.focused = arg_28_3
	end
end

StartGameWindowVersusPlayerHostedLobby._get_player_panel_widget = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = var_0_12[arg_29_1]

	if var_29_0 then
		return arg_29_0._player_slots_by_team[var_29_0][arg_29_2].panel_widget
	end

	return nil
end

StartGameWindowVersusPlayerHostedLobby.focus_versus_hosted_lobby_input = function (arg_30_0)
	arg_30_0._input_focus_mode = var_0_8.selection

	arg_30_0._parent:set_input_description("versus_player_hosted_lobby")

	local var_30_0 = Managers.mechanism:game_mechanism():get_custom_game_settings_handler()
end

StartGameWindowVersusPlayerHostedLobby._is_other_option_button_selected = function (arg_31_0, arg_31_1, arg_31_2)
	if arg_31_0._is_server and arg_31_0._game_mechanism:is_hosting_versus_custom_game() and UIUtils.is_button_pressed(arg_31_1) then
		local var_31_0 = not arg_31_2

		if var_31_0 then
			arg_31_0._parent:play_sound("play_gui_lobby_button_03_private")
		else
			arg_31_0._parent:play_sound("play_gui_lobby_button_03_public")
		end

		return var_31_0
	end

	return nil
end

StartGameWindowVersusPlayerHostedLobby._lobby_member_game_mode_custom_settings_handler_enabled = function (arg_32_0, arg_32_1)
	if not arg_32_0._is_server and not arg_32_0._game_mechanism:is_hosting_versus_custom_game() then
		local var_32_0 = arg_32_0._widgets_by_name.toggle_custom_settings_button

		arg_32_0._custom_settings_toggled = arg_32_1
		var_32_0.content.button_hotspot.is_selected = arg_32_1

		if not (Managers.input and Managers.input:is_device_active("gamepad")) then
			Managers.state.event:trigger("event_focus_custom_game_settings_input", arg_32_1)
		end
	end
end
