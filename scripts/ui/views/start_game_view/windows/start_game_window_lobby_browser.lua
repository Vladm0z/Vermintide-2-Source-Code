-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_lobby_browser.lua

require("scripts/ui/views/lobby_item_list")
require("scripts/network/lobby_aux")

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = 0
local var_0_5 = PLATFORM
local var_0_6 = {
	deus = "area_selection_morris_name",
	deed = "lb_game_type_deed",
	weave = "menu_weave_area_no_wom_title",
	event = "lb_game_type_event",
	custom = "lb_game_type_custom",
	demo = "lb_game_type_none",
	adventure = "area_selection_campaign",
	tutorial = "lb_game_type_prologue",
	versus = "vs_ui_versus_tag",
	["n/a"] = "lb_game_type_none",
	any = "lobby_browser_mission"
}
local var_0_7 = {
	deus = "area_selection_morris_name",
	adventure = "area_selection_campaign",
	weave = "menu_weave_area_no_wom_title",
	versus = "vs_ui_versus_tag",
	any = "lobby_browser_mission"
}

StartGameWindowLobbyBrowser = class(StartGameWindowLobbyBrowser)
StartGameWindowLobbyBrowser.NAME = "StartGameWindowLobbyBrowser"

function StartGameWindowLobbyBrowser.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowLobbyBrowser")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.difficulty_manager = Managers.state.difficulty

	local var_1_1 = Managers.player
	local var_1_2 = var_1_1:local_player()

	arg_1_0._stats_id = var_1_2:stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._profile_name = var_1_2:profile_display_name()
	arg_1_0._career_name = var_1_2:career_name()
	arg_1_0._ui_animations = {}

	local var_1_3 = LobbySetup.network_options()

	arg_1_0.lobby_finder = LobbyFinder:new(var_1_3, MatchmakingSettings.MAX_NUM_LOBBIES, true)

	local var_1_4
	local var_1_5 = Development.parameter("use_lan_backend") or rawget(_G, "Steam") == nil
	local var_1_6 = IS_WINDOWS

	if var_1_5 or not var_1_6 then
		var_1_4 = GameServerFinderLan:new(var_1_3, MatchmakingSettings.MAX_NUM_SERVERS)
	else
		var_1_4 = GameServerFinder:new(var_1_3, MatchmakingSettings.MAX_NUM_SERVERS)
	end

	arg_1_0.game_server_finder = var_1_4
	arg_1_0._game_mode_data = var_0_0.setup_game_mode_data(arg_1_0.statistics_db, arg_1_0._stats_id)

	table.dump(arg_1_0._game_mode_data, "GAME MODE DATA", 3)
	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0._current_lobby_type = "lobbies"

	local var_1_7 = arg_1_0.parent:window_input_service().name
	local var_1_8 = {
		0,
		0,
		0
	}
	local var_1_9 = {
		use_top_renderer = false,
		num_list_items = 15,
		input_service_name = var_1_7,
		offset = var_1_8
	}

	arg_1_0.lobby_list = LobbyItemsList:new(var_1_0, var_1_9)
	arg_1_0.lobby_list_update_timer = MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH
	arg_1_0.show_invalid = false
	arg_1_0.selected_gamepad_widget_index = 1
	arg_1_0._draw_invalid_checkbox = BUILD == "dev" or BUILD == "debug"
	arg_1_0._base_widgets_by_name.invalid_checkbox.content.visible = arg_1_0._draw_invalid_checkbox
	arg_1_0._current_server_name = ""
	arg_1_0._show_widget_type = "adventure"

	Managers.matchmaking:set_active_lobby_browser(arg_1_0)
	arg_1_0:_populate_lobby_list()
end

function StartGameWindowLobbyBrowser.create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = UISceneGraph.init_scenegraph(var_0_2)

	arg_2_0.ui_scenegraph = var_2_0

	local var_2_1 = false

	arg_2_0._current_weave = LevelUnlockUtils.current_weave(arg_2_0.statistics_db, arg_2_0._stats_id, var_2_1)

	local var_2_2 = {}
	local var_2_3 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1.base) do
		local var_2_4 = UIWidget.init(iter_2_1)

		var_2_2[#var_2_2 + 1] = var_2_4
		var_2_3[iter_2_0] = var_2_4
	end

	arg_2_0._base_widgets = var_2_2
	arg_2_0._base_widgets_by_name = var_2_3

	local var_2_5 = {}
	local var_2_6 = {}

	for iter_2_2, iter_2_3 in pairs(var_0_1.lobbies) do
		local var_2_7 = UIWidget.init(iter_2_3)

		var_2_5[#var_2_5 + 1] = var_2_7
		var_2_6[iter_2_2] = var_2_7
	end

	arg_2_0._lobbies_widgets = var_2_5
	arg_2_0._lobbies_widgets_by_name = var_2_6

	local var_2_8 = {}
	local var_2_9 = {}

	for iter_2_4, iter_2_5 in pairs(var_0_1.servers) do
		local var_2_10 = UIWidget.init(iter_2_5)

		var_2_8[#var_2_8 + 1] = var_2_10
		var_2_9[iter_2_4] = var_2_10
	end

	arg_2_0._server_widgets = var_2_8
	arg_2_0._server_widgets_by_name = var_2_9

	local var_2_11 = {}
	local var_2_12 = {}

	for iter_2_6, iter_2_7 in pairs(var_0_1.lobby_info_box_base) do
		local var_2_13 = UIWidget.init(iter_2_7)

		var_2_11[#var_2_11 + 1] = var_2_13
		var_2_12[iter_2_6] = var_2_13
	end

	arg_2_0._lobby_info_box_base_widgets = var_2_11
	arg_2_0._lobby_info_box_base_widgets_by_name = var_2_12

	local var_2_14 = {}
	local var_2_15 = {}

	for iter_2_8, iter_2_9 in pairs(var_0_1.lobby_info_box_weaves) do
		local var_2_16 = UIWidget.init(iter_2_9)

		var_2_14[#var_2_14 + 1] = var_2_16
		var_2_15[iter_2_8] = var_2_16
	end

	arg_2_0._lobby_info_box_weaves_widgets = var_2_14
	arg_2_0._lobby_info_box_weaves_widgets_by_name = var_2_15

	local var_2_17 = {}
	local var_2_18 = {}

	for iter_2_10, iter_2_11 in pairs(var_0_1.lobby_info_box_lobbies_weaves) do
		local var_2_19 = UIWidget.init(iter_2_11)

		var_2_17[#var_2_17 + 1] = var_2_19
		var_2_18[iter_2_10] = var_2_19
	end

	arg_2_0._lobby_info_box_lobbies_weaves_widgets = var_2_17
	arg_2_0._lobby_info_box_lobbies_weaves_widgets_by_name = var_2_18

	local var_2_20 = {}
	local var_2_21 = {}

	for iter_2_12, iter_2_13 in pairs(var_0_1.lobby_info_box_deus) do
		local var_2_22 = UIWidget.init(iter_2_13)

		var_2_20[#var_2_20 + 1] = var_2_22
		var_2_21[iter_2_12] = var_2_22
	end

	arg_2_0._lobby_info_box_deus_widgets = var_2_20
	arg_2_0._lobby_info_box_deus_widgets_by_name = var_2_21

	local var_2_23 = {}
	local var_2_24 = {}

	for iter_2_14, iter_2_15 in pairs(var_0_1.lobby_info_box_lobbies_deus) do
		local var_2_25 = UIWidget.init(iter_2_15)

		var_2_23[#var_2_23 + 1] = var_2_25
		var_2_24[iter_2_14] = var_2_25
	end

	arg_2_0._lobby_info_box_lobbies_deus_widgets = var_2_23
	arg_2_0._lobby_info_box_lobbies_deus_widgets_by_name = var_2_24

	local var_2_26 = {}
	local var_2_27 = {}

	for iter_2_16, iter_2_17 in pairs(var_0_1.lobby_info_box_lobbies) do
		local var_2_28 = UIWidget.init(iter_2_17)

		var_2_26[#var_2_26 + 1] = var_2_28
		var_2_27[iter_2_16] = var_2_28
	end

	arg_2_0._lobby_info_box_lobbies_widgets = var_2_26
	arg_2_0._lobby_info_box_lobbies_widgets_by_name = var_2_27

	local var_2_29 = {}
	local var_2_30 = {}

	for iter_2_18, iter_2_19 in pairs(var_0_1.lobby_info_box_servers) do
		local var_2_31 = UIWidget.init(iter_2_19)

		var_2_29[#var_2_29 + 1] = var_2_31
		var_2_30[iter_2_18] = var_2_31
	end

	arg_2_0._lobby_info_box_servers_widgets = var_2_29
	arg_2_0._lobby_info_box_servers_widgets_by_name = var_2_30

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(var_2_0, var_0_3)

	if arg_2_2 then
		local var_2_32 = var_2_0.window.local_position

		var_2_32[1] = var_2_32[1] + arg_2_2[1]
		var_2_32[2] = var_2_32[2] + arg_2_2[2]
		var_2_32[3] = var_2_32[3] + arg_2_2[3]
	end

	arg_2_0:_assign_hero_portraits()
	arg_2_0:_reset_filters()
end

function StartGameWindowLobbyBrowser._assign_hero_portraits(arg_3_0)
	local var_3_0 = arg_3_0._lobby_info_box_base_widgets_by_name.hero_tabs.content

	for iter_3_0 = 1, #ProfilePriority do
		local var_3_1 = ProfilePriority[iter_3_0]
		local var_3_2 = "_" .. tostring(iter_3_0)
		local var_3_3 = var_3_0["hotspot" .. var_3_2]
		local var_3_4 = "icon" .. var_3_2
		local var_3_5 = "icon" .. var_3_2 .. "_saturated"
		local var_3_6 = SPProfiles[var_3_1].ui_portrait

		var_3_3[var_3_4] = var_3_6
		var_3_3[var_3_5] = var_3_6 .. "_saturated"
	end

	local var_3_7 = arg_3_0._lobby_info_box_deus_widgets_by_name.hero_tabs.content

	for iter_3_1 = 1, #ProfilePriority do
		local var_3_8 = ProfilePriority[iter_3_1]
		local var_3_9 = "_" .. tostring(iter_3_1)
		local var_3_10 = var_3_7["hotspot" .. var_3_9]
		local var_3_11 = "icon" .. var_3_9
		local var_3_12 = "icon" .. var_3_9 .. "_saturated"
		local var_3_13 = SPProfiles[var_3_8].ui_portrait

		var_3_10[var_3_11] = var_3_13
		var_3_10[var_3_12] = var_3_13 .. "_saturated"
	end
end

function StartGameWindowLobbyBrowser.on_exit(arg_4_0, arg_4_1)
	print("[StartGameWindow] Exit Substate StartGameWindowLobbyBrowser")

	arg_4_0.ui_animator = nil

	Managers.matchmaking:set_active_lobby_browser(nil)
	arg_4_0.lobby_finder:destroy()

	arg_4_0.lobby_finder = nil

	arg_4_0.game_server_finder:destroy()

	arg_4_0.game_server_finder = nil
end

function StartGameWindowLobbyBrowser.update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.lobby_finder:update(arg_5_1)
	arg_5_0.game_server_finder:update(arg_5_1)

	local var_5_0 = arg_5_0:_is_refreshing()

	if arg_5_0._searching and not var_5_0 then
		arg_5_0._searching = false

		arg_5_0:_populate_lobby_list()
	end

	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:draw(arg_5_1)
	arg_5_0:_update_auto_refresh(arg_5_1)

	local var_5_1 = arg_5_0._searching
	local var_5_2 = arg_5_0.lobby_list

	var_5_2:update(arg_5_1, var_5_1)
	var_5_2:draw(arg_5_1)

	local var_5_3 = var_5_2.lobby_list_index_changed

	if var_5_3 then
		var_5_2:on_lobby_selected(var_5_3)

		local var_5_4 = var_5_2:selected_lobby()

		arg_5_0:_setup_lobby_info_box(var_5_4)
	end

	local var_5_5 = var_5_2:selected_lobby()

	arg_5_0:_update_join_button(var_5_5)

	if arg_5_0._draw_invalid_checkbox then
		local var_5_6 = arg_5_0._base_widgets_by_name.invalid_checkbox.content
		local var_5_7 = var_5_6.button_hotspot

		if var_5_7.on_hover_enter then
			arg_5_0:_play_sound("Play_hud_hover")
		end

		if var_5_7.on_release then
			var_5_6.checked = not var_5_6.checked
			arg_5_0.search_timer = var_0_4

			arg_5_0:_play_sound("Play_hud_select")
		end
	end

	local var_5_8 = arg_5_0._base_widgets_by_name
	local var_5_9 = var_5_8.join_button.content.button_hotspot
	local var_5_10 = var_5_8.search_button.content.button_hotspot
	local var_5_11 = var_5_8.reset_button.content.button_hotspot
	local var_5_12 = var_5_8.lobby_type_button.content.button_hotspot

	if var_5_10.on_hover_enter or var_5_9.on_hover_enter or var_5_11.on_hover_enter or var_5_12.on_hover_enter then
		arg_5_0:_play_sound("Play_hud_hover")
	end

	if not var_5_9.disable_button then
		local var_5_13 = arg_5_0.join_lobby_data_id

		if var_5_9.on_release and not var_5_13 and var_5_5 then
			arg_5_0:_play_sound("Play_hud_select")
			arg_5_0:_join(var_5_5)
		end
	end

	if var_5_12.on_release then
		arg_5_0:_play_sound("Play_hud_select")

		var_5_12.on_release = nil

		local var_5_14 = arg_5_0._current_lobby_type
		local var_5_15 = "lobbies"

		if var_5_14 == "lobbies" then
			var_5_15 = "servers"
		end

		arg_5_0:_switch_lobby_type(var_5_15)
	end

	if var_5_10.on_release then
		arg_5_0:_play_sound("Play_hud_select")

		var_5_10.on_release = nil

		arg_5_0:_search()
	end

	if var_5_11.on_release then
		arg_5_0:_play_sound("Play_hud_select")

		var_5_11.on_release = nil

		arg_5_0:_reset_filters()
	end

	if arg_5_0.search_timer then
		arg_5_0.search_timer = arg_5_0.search_timer - arg_5_1

		if arg_5_0.search_timer < 0 then
			arg_5_0:_search()

			arg_5_0.search_timer = nil
		end
	end
end

function StartGameWindowLobbyBrowser.post_update(arg_6_0, arg_6_1, arg_6_2)
	return
end

function StartGameWindowLobbyBrowser._handle_weave_data(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._lobby_info_box_weaves_widgets_by_name
	local var_7_1 = arg_7_0._lobby_info_box_base_widgets_by_name
	local var_7_2 = arg_7_0._lobby_info_box_lobbies_weaves_widgets_by_name
	local var_7_3 = var_7_0.weave_name

	var_7_3.content.text = Localize("tutorial_no_text")

	local var_7_4 = var_7_0.wind_name

	var_7_4.content.text = Localize("tutorial_no_text")

	local var_7_5 = var_7_1.level_image_frame

	var_7_5.content.texture_id = "map_frame_00"
	var_7_5.style.texture_id.color = Colors.get_color_table_with_alpha("white", 255)

	local var_7_6 = var_7_0.wind_icon

	var_7_6.style.texture_id.color[1] = 0

	local var_7_7 = var_7_0.wind_icon_glow

	var_7_7.style.texture_id.color[1] = 0

	local var_7_8 = var_7_0.wind_icon_bg

	var_7_8.style.texture_id.color[1] = 0

	local var_7_9 = var_7_0.wind_icon_slot

	var_7_9.style.texture_id.color[1] = 0

	local var_7_10 = var_7_0.mutator_icon

	var_7_10.style.texture_id.color[1] = 0

	local var_7_11 = var_7_0.mutator_icon_frame

	var_7_11.style.texture_id.color[1] = 0

	local var_7_12 = var_7_0.mutator_title_divider

	var_7_12.style.texture_id.color[1] = 0

	local var_7_13 = var_7_0.mutator_title_text

	var_7_13.content.text = "tutorial_no_text"

	local var_7_14 = var_7_0.mutator_description_text

	var_7_14.content.text = "tutorial_no_text"

	local var_7_15 = var_7_0.objective_title_bg

	var_7_15.style.texture_id.color[1] = 0

	local var_7_16 = var_7_0.objective_title

	var_7_16.content.text = "tutorial_no_text"
	var_7_0.objective_1.content.text = "tutorial_no_text"
	var_7_0.objective_2.content.text = "tutorial_no_text"

	local var_7_17 = arg_7_1.selected_mission_id
	local var_7_18 = WeaveSettings.templates[var_7_17]
	local var_7_19 = Localize("lb_unknown")

	if var_7_17 ~= "false" then
		local var_7_20 = string.split_deprecated(var_7_17, "_")
		local var_7_21 = "Weave " .. var_7_20[2]

		if var_7_18 then
			var_7_3.content.text = ""

			local var_7_22 = var_7_18.wind
			local var_7_23 = WindSettings[var_7_22]

			var_7_4.content.text = Localize(var_7_23.display_name)
			var_7_5.content.texture_id = "map_frame_weaves"

			local var_7_24 = Colors.get_color_table_with_alpha(var_7_22, 255)

			var_7_5.style.texture_id.color = var_7_24
			var_7_4.style.text.text_color = var_7_24

			local var_7_25 = var_7_23.thumbnail_icon
			local var_7_26 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_7_25).size

			var_7_7.style.texture_id.color = var_7_24
			var_7_8.style.texture_id.color = var_7_24
			var_7_6.content.texture_id = var_7_23.thumbnail_icon

			local var_7_27 = var_7_6.style.texture_id

			var_7_27.texture_size = {
				var_7_26[1] * 0.8,
				var_7_26[2] * 0.8
			}
			var_7_27.horizontal_alignment = "center"
			var_7_27.vertical_alignment = "center"

			local var_7_28 = var_7_23.mutator
			local var_7_29 = MutatorTemplates[var_7_28]

			var_7_10.content.texture_id = var_7_29.icon
			var_7_13.content.text = var_7_29.display_name
			var_7_14.content.text = var_7_29.description
			var_7_16.content.text = "weave_objective_title"

			local var_7_30 = var_7_18.objectives
			local var_7_31 = 10
			local var_7_32 = 0

			for iter_7_0 = 1, #var_7_30 do
				local var_7_33 = var_7_30[iter_7_0]
				local var_7_34 = var_7_33.display_name
				local var_7_35 = var_7_33.icon

				arg_7_0:_assign_objective(iter_7_0, var_7_34, var_7_35, var_7_31)
			end

			var_7_6.style.texture_id.color[1] = 255
			var_7_9.style.texture_id.color[1] = 255
			var_7_10.style.texture_id.color[1] = 255
			var_7_11.style.texture_id.color[1] = 255
			var_7_12.style.texture_id.color[1] = 255
			var_7_15.style.texture_id.color[1] = 255
		end
	end

	local var_7_36 = "level_image_any"
	local var_7_37 = "lb_unknown"
	local var_7_38 = arg_7_1.mission_id or arg_7_1.selected_mission_id

	if var_7_38 and var_7_38 ~= "n/a" then
		local var_7_39 = var_7_18 and var_7_18.objectives[1].level_id or var_7_38
		local var_7_40 = LevelSettings[var_7_39]

		var_7_36 = var_7_40.level_image

		local var_7_41 = var_7_40.display_name
	end

	var_7_1.level_image.content.texture_id = var_7_36
	var_7_1.level_name.content.text = var_7_18 and var_7_18.display_name and Localize(var_7_18.display_name) or ""

	local var_7_42 = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_7_1.mechanism)
	local var_7_43 = "n/a"
	local var_7_44 = arg_7_1.num_players

	if var_7_44 then
		var_7_43 = string.format("%s/%s", var_7_44, tostring(var_7_42.MAX_NUMBER_OF_PLAYERS))
	end

	var_7_2.info_frame_players_text.content.text = var_7_43

	local var_7_45 = LobbyItemsList.lobby_status_text(arg_7_1)

	var_7_2.info_frame_status_text.content.text = var_7_45

	local var_7_46 = arg_7_1.server_name or arg_7_1.unique_server_name or arg_7_1.name or arg_7_1.host

	var_7_2.info_frame_host_text.content.text = var_7_46 or Localize("lb_unknown")
	arg_7_0._show_widget_type = "weave"
end

function StartGameWindowLobbyBrowser._handle_lobby_data(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._lobby_info_box_base_widgets_by_name
	local var_8_1 = arg_8_0._lobby_info_box_lobbies_widgets_by_name
	local var_8_2 = arg_8_0._lobby_info_box_servers_widgets_by_name

	var_8_1.info_frame_game_type_text.content.text = Localize(arg_8_1)
	var_8_2.info_frame_game_type_text.content.text = Localize(arg_8_1)

	local var_8_3 = "level_image_any"
	local var_8_4 = "lb_unknown"
	local var_8_5 = arg_8_2.selected_mission_id or arg_8_2.mission_id

	if var_8_5 == "any" then
		var_8_3 = "level_image_any"
		var_8_4 = "map_screen_quickplay_button"
	elseif var_8_5 and var_8_5 ~= "n/a" then
		local var_8_6 = LevelSettings[var_8_5]

		var_8_3 = var_8_6.level_image
		var_8_4 = var_8_6.display_name
	end

	local var_8_7 = var_8_0.level_image_frame

	var_8_7.content.texture_id = "map_frame_00"
	var_8_7.style.texture_id.color = Colors.get_color_table_with_alpha("white", 255)
	var_8_0.level_image.content.texture_id = var_8_3
	var_8_0.level_name.content.text = Localize(var_8_4)
	var_8_1.info_frame_level_name_text.content.text = Localize(var_8_4)
	var_8_2.info_frame_level_name_text.content.text = Localize(var_8_4)

	local var_8_8 = var_8_1.info_frame_difficulty_title
	local var_8_9 = var_8_1.info_frame_difficulty_text
	local var_8_10 = "lb_difficulty_unknown"
	local var_8_11 = arg_8_2.difficulty

	if var_8_11 then
		var_8_10 = DifficultySettings[var_8_11].display_name
	end

	var_8_1.info_frame_difficulty_text.content.text = Localize(var_8_10)
	var_8_2.info_frame_difficulty_text.content.text = Localize(var_8_10)

	local var_8_12 = "n/a"
	local var_8_13 = arg_8_2.num_players
	local var_8_14 = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_8_2.mechanism)

	if var_8_13 then
		var_8_12 = string.format("%s/%s", var_8_13, tostring(var_8_14.MAX_NUMBER_OF_PLAYERS))
	end

	var_8_1.info_frame_players_text.content.text = var_8_12
	var_8_2.info_frame_players_text.content.text = var_8_12

	local var_8_15 = LobbyItemsList.lobby_status_text(arg_8_2)

	var_8_1.info_frame_status_text.content.text = var_8_15
	var_8_2.info_frame_status_text.content.text = var_8_15

	local var_8_16 = to_boolean(arg_8_2.twitch_enabled)

	var_8_1.info_frame_twitch_logo.content.visible = var_8_16

	local var_8_17 = arg_8_2.server_info

	if not (var_8_17 ~= nil) then
		local var_8_18 = arg_8_2.server_name or arg_8_2.unique_server_name or arg_8_2.name or arg_8_2.host

		var_8_1.info_frame_host_text.content.text = var_8_18 or Localize("lb_unknown")
	else
		local var_8_19 = var_8_17.name

		var_8_2.info_frame_name_text.content.text = var_8_19 or Localize("lb_unknown")

		local var_8_20 = var_8_17.ip_address

		var_8_2.info_frame_ip_adress_text.content.text = var_8_20 or Localize("lb_unknown")

		local var_8_21 = var_8_17.password
		local var_8_22 = var_8_21 == true and "lb_yes" or var_8_21 == false and "lb_no" or "lb_unknown"

		var_8_2.info_frame_password_protected_text.content.text = Localize(var_8_22)

		local var_8_23 = var_8_17.ping

		var_8_2.info_frame_ping_text.content.text = var_8_23 and tostring(var_8_23) or Localize("lb_unknown")

		local var_8_24 = var_8_17.favorite

		var_8_2.info_frame_favorite_text.content.text = var_8_24 and Localize("lb_yes") or Localize("lb_no")
		var_8_2.add_to_favorites_button.content.button_text = var_8_24 and Localize("lb_remove_from_favorites") or Localize("lb_add_to_favorites")
	end

	arg_8_0._show_widget_type = "adventure"
end

function StartGameWindowLobbyBrowser._gather_unlocked_journeys(arg_9_0)
	local var_9_0 = {}
	local var_9_1 = Managers.player:statistics_db()
	local var_9_2 = Managers.player:local_player():stats_id()

	for iter_9_0, iter_9_1 in ipairs(LevelUnlockUtils.unlocked_journeys(var_9_1, var_9_2)) do
		var_9_0[iter_9_1] = true
	end

	return var_9_0
end

function StartGameWindowLobbyBrowser._handle_deus_data(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:_gather_unlocked_journeys()
	local var_10_1 = arg_10_0._lobby_info_box_deus_widgets_by_name
	local var_10_2 = arg_10_0._lobby_info_box_lobbies_deus_widgets_by_name

	var_10_2.info_frame_game_type_text.content.text = Localize("area_selection_morris_name")

	local var_10_3 = {}
	local var_10_4 = #SPProfiles

	for iter_10_0 = 1, var_10_4 do
		if not ProfileSynchronizer.is_free_in_lobby(iter_10_0, arg_10_1) then
			var_10_3[iter_10_0] = true
		end
	end

	local var_10_5 = var_10_1.hero_tabs.content

	for iter_10_1 = 1, #ProfilePriority do
		local var_10_6 = ProfilePriority[iter_10_1]
		local var_10_7 = "_" .. tostring(iter_10_1)
		local var_10_8 = var_10_5["hotspot" .. var_10_7]

		if var_10_3[var_10_6] then
			var_10_8.disable_button = true
		else
			var_10_8.disable_button = false
		end
	end

	local var_10_9 = var_10_1.expedition_icon
	local var_10_10 = Managers.backend:get_interface("deus"):get_journey_cycle()
	local var_10_11 = arg_10_1.selected_mission_id
	local var_10_12 = DeusJourneySettings[var_10_11]
	local var_10_13 = var_10_12.display_name
	local var_10_14 = var_10_10.journey_data[var_10_11].dominant_god
	local var_10_15 = DeusThemeSettings[var_10_14]

	var_10_9.content.theme_icon = var_10_15.icon
	var_10_9.content.level_icon = var_10_12.level_image
	var_10_9.content.locked = not var_10_0[var_10_11]
	var_10_1.level_name.content.text = Localize(var_10_13)
	var_10_2.info_frame_level_name_text.content.text = Localize(var_10_13)

	local var_10_16 = var_10_2.info_frame_difficulty_title
	local var_10_17 = var_10_2.info_frame_difficulty_text
	local var_10_18 = "lb_difficulty_unknown"
	local var_10_19 = arg_10_1.difficulty

	if var_10_19 then
		var_10_18 = DifficultySettings[var_10_19].display_name
	end

	var_10_2.info_frame_difficulty_text.content.text = Localize(var_10_18)

	local var_10_20 = "n/a"
	local var_10_21 = arg_10_1.num_players

	if var_10_21 then
		var_10_20 = string.format("%s/%s", var_10_21, tostring(MatchmakingSettings.MAX_NUMBER_OF_PLAYERS))
	end

	var_10_2.info_frame_players_text.content.text = var_10_20

	local var_10_22 = LobbyItemsList.lobby_status_text(arg_10_1)

	var_10_2.info_frame_status_text.content.text = var_10_22

	local var_10_23 = to_boolean(arg_10_1.twitch_enabled)

	var_10_2.info_frame_twitch_logo.content.visible = var_10_23

	local var_10_24 = arg_10_1.server_name or arg_10_1.unique_server_name or arg_10_1.name or arg_10_1.host

	var_10_2.info_frame_host_text.content.text = var_10_24 or Localize("lb_unknown")
	arg_10_0._show_widget_type = "deus"
end

function StartGameWindowLobbyBrowser._assign_objective(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_0._lobby_info_box_weaves_widgets_by_name["objective_" .. arg_11_1]
	local var_11_1 = var_11_0.content
	local var_11_2 = var_11_0.style

	var_11_1.icon = arg_11_3 or "trial_gem"
	var_11_1.text = arg_11_2 or "-"
end

function StartGameWindowLobbyBrowser._setup_lobby_info_box(arg_12_0, arg_12_1)
	local var_12_0 = "lb_unknown"
	local var_12_1 = arg_12_1.mechanism
	local var_12_2 = arg_12_1.matchmaking_type
	local var_12_3 = arg_12_1.selected_mission_id
	local var_12_4 = ""

	if var_12_2 then
		local var_12_5 = table.clone(NetworkLookup.matchmaking_types, true)[tonumber(var_12_2)]

		var_12_0 = var_0_6[var_12_5] or var_12_0
	end

	local var_12_6 = {}
	local var_12_7 = #SPProfiles

	for iter_12_0 = 1, var_12_7 do
		if not ProfileSynchronizer.is_free_in_lobby(iter_12_0, arg_12_1) then
			var_12_6[iter_12_0] = true
		end
	end

	local var_12_8 = arg_12_0._lobby_info_box_base_widgets_by_name.hero_tabs.content

	for iter_12_1 = 1, #ProfilePriority do
		local var_12_9 = ProfilePriority[iter_12_1]
		local var_12_10 = "_" .. tostring(iter_12_1)
		local var_12_11 = var_12_8["hotspot" .. var_12_10]

		if var_12_6[var_12_9] then
			var_12_11.disable_button = true
		else
			var_12_11.disable_button = false
		end
	end

	if var_12_1 == "weave" then
		arg_12_0:_handle_weave_data(arg_12_1)
	elseif var_12_1 == "deus" and DeusJourneySettings[var_12_3] then
		arg_12_0:_handle_deus_data(arg_12_1)
	else
		arg_12_0:_handle_lobby_data(var_12_0, arg_12_1)
	end
end

function StartGameWindowLobbyBrowser._update_animations(arg_13_0, arg_13_1)
	arg_13_0.ui_animator:update(arg_13_1)

	local var_13_0 = arg_13_0._ui_animations

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		UIAnimation.update(iter_13_1, arg_13_1)

		if UIAnimation.completed(iter_13_1) then
			arg_13_0._ui_animations[iter_13_0] = nil
		end
	end
end

function StartGameWindowLobbyBrowser._is_refreshing(arg_14_0)
	local var_14_0 = arg_14_0._current_lobby_type

	if var_14_0 == "lobbies" then
		return arg_14_0.lobby_finder:is_refreshing()
	elseif var_14_0 == "servers" then
		return arg_14_0.game_server_finder:is_refreshing()
	else
		ferror("Unknown lobby types (%s)", var_14_0)
	end
end

function StartGameWindowLobbyBrowser._handle_input(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._lobbies_widgets_by_name

	arg_15_0:_handle_stepper_input("game_type_stepper", var_15_0.game_type_stepper, callback(arg_15_0, "_on_game_type_stepper_input"))
	arg_15_0:_handle_stepper_input("level_stepper", var_15_0.level_stepper, callback(arg_15_0, "_on_level_stepper_input"))
	arg_15_0:_handle_stepper_input("difficulty_stepper", var_15_0.difficulty_stepper, callback(arg_15_0, "_on_difficulty_stepper_input"))
	arg_15_0:_handle_stepper_input("show_lobbies_stepper", var_15_0.show_lobbies_stepper, callback(arg_15_0, "_on_show_lobbies_stepper_input"))
	arg_15_0:_handle_stepper_input("distance_stepper", var_15_0.distance_stepper, callback(arg_15_0, "_on_distance_stepper_input"))

	local var_15_1 = arg_15_0._server_widgets_by_name

	arg_15_0:_handle_stepper_input("search_type_stepper", var_15_1.search_type_stepper, callback(arg_15_0, "_on_search_type_stepper_input"))
	arg_15_0:_handle_name_input_box(arg_15_1, arg_15_2)
	arg_15_0:_handle_selected_lobby_input()
end

function StartGameWindowLobbyBrowser._handle_name_input_box(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.parent:window_input_service()
	local var_16_1 = arg_16_0._server_widgets_by_name.name_input_box.content

	if var_16_1.on_release then
		var_16_1.active = true
	elseif var_16_0:get("left_release") then
		var_16_1.active = false
	end

	local var_16_2 = var_16_1.input

	if var_16_2 ~= arg_16_0._current_server_name then
		arg_16_0._current_server_name = var_16_2

		arg_16_0:_populate_lobby_list()
	end
end

function StartGameWindowLobbyBrowser._handle_selected_lobby_input(arg_17_0)
	local var_17_0 = arg_17_0.lobby_list:selected_lobby()

	if not var_17_0 then
		return
	end

	if arg_17_0._current_lobby_type == "servers" and arg_17_0._lobby_info_box_servers_widgets_by_name.add_to_favorites_button.content.button_hotspot.on_release then
		if var_17_0.server_info.favorite then
			arg_17_0:_remove_server_from_favorites(var_17_0)
		else
			arg_17_0:_add_server_to_favorites(var_17_0)
		end
	end
end

function StartGameWindowLobbyBrowser._add_server_to_favorites(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.server_info
	local var_18_1 = var_18_0.ip_address
	local var_18_2 = var_18_0.connection_port
	local var_18_3 = var_18_0.query_port

	arg_18_0.game_server_finder:add_to_favorites(var_18_1, var_18_2, var_18_3)
end

function StartGameWindowLobbyBrowser._remove_server_from_favorites(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.server_info
	local var_19_1 = var_19_0.ip_address
	local var_19_2 = var_19_0.connection_port
	local var_19_3 = var_19_0.query_port

	arg_19_0.game_server_finder:remove_from_favorites(var_19_1, var_19_2, var_19_3)
end

function StartGameWindowLobbyBrowser.draw(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.ui_renderer
	local var_20_1 = arg_20_0.ui_scenegraph
	local var_20_2 = arg_20_0.parent:window_input_service()

	UIRenderer.begin_pass(var_20_0, var_20_1, var_20_2, arg_20_1, nil, arg_20_0.render_settings)

	local var_20_3 = arg_20_0.lobby_list_update_timer ~= nil
	local var_20_4 = arg_20_0.join_lobby_data_id

	arg_20_0._base_widgets_by_name.search_button.content.button_hotspot.disable_button = var_20_4 or var_20_3

	local var_20_5 = arg_20_0._base_widgets

	for iter_20_0 = 1, #var_20_5 do
		local var_20_6 = var_20_5[iter_20_0]

		UIRenderer.draw_widget(var_20_0, var_20_6)
	end

	local var_20_7 = arg_20_0._current_lobby_type

	if arg_20_0.lobby_list:selected_lobby() then
		if arg_20_0._show_widget_type == "weave" then
			local var_20_8 = arg_20_0._lobby_info_box_base_widgets

			for iter_20_1 = 1, #var_20_8 do
				local var_20_9 = var_20_8[iter_20_1]

				UIRenderer.draw_widget(var_20_0, var_20_9)
			end

			local var_20_10 = arg_20_0._lobby_info_box_weaves_widgets

			for iter_20_2 = 1, #var_20_10 do
				local var_20_11 = var_20_10[iter_20_2]

				UIRenderer.draw_widget(var_20_0, var_20_11)
			end

			local var_20_12 = arg_20_0._lobby_info_box_lobbies_weaves_widgets

			for iter_20_3 = 1, #var_20_12 do
				local var_20_13 = var_20_12[iter_20_3]

				UIRenderer.draw_widget(var_20_0, var_20_13)
			end
		elseif arg_20_0._show_widget_type == "deus" then
			local var_20_14 = arg_20_0._lobby_info_box_deus_widgets

			for iter_20_4 = 1, #var_20_14 do
				local var_20_15 = var_20_14[iter_20_4]

				UIRenderer.draw_widget(var_20_0, var_20_15)
			end

			local var_20_16 = arg_20_0._lobby_info_box_lobbies_deus_widgets

			for iter_20_5 = 1, #var_20_16 do
				local var_20_17 = var_20_16[iter_20_5]

				UIRenderer.draw_widget(var_20_0, var_20_17)
			end
		else
			local var_20_18 = arg_20_0._lobby_info_box_base_widgets

			for iter_20_6 = 1, #var_20_18 do
				local var_20_19 = var_20_18[iter_20_6]

				UIRenderer.draw_widget(var_20_0, var_20_19)
			end

			if var_20_7 == "lobbies" then
				local var_20_20 = arg_20_0._lobby_info_box_lobbies_widgets

				for iter_20_7 = 1, #var_20_20 do
					local var_20_21 = var_20_20[iter_20_7]

					UIRenderer.draw_widget(var_20_0, var_20_21)
				end
			elseif var_20_7 == "servers" then
				local var_20_22 = arg_20_0._lobby_info_box_servers_widgets

				for iter_20_8 = 1, #var_20_22 do
					local var_20_23 = var_20_22[iter_20_8]

					UIRenderer.draw_widget(var_20_0, var_20_23)
				end
			end
		end
	end

	if var_20_7 == "lobbies" then
		local var_20_24 = arg_20_0._lobbies_widgets

		for iter_20_9 = 1, #var_20_24 do
			local var_20_25 = var_20_24[iter_20_9]

			UIRenderer.draw_widget(var_20_0, var_20_25)
		end
	elseif var_20_7 == "servers" then
		local var_20_26 = arg_20_0._server_widgets

		for iter_20_10 = 1, #var_20_26 do
			local var_20_27 = var_20_26[iter_20_10]

			UIRenderer.draw_widget(var_20_0, var_20_27)
		end
	else
		ferror("Unknown lobby type (%s)", var_20_7)
	end

	UIRenderer.end_pass(var_20_0)
end

function StartGameWindowLobbyBrowser._play_sound(arg_21_0, arg_21_1)
	arg_21_0.parent:play_sound(arg_21_1)
end

function StartGameWindowLobbyBrowser.cancel_join_lobby(arg_22_0, arg_22_1)
	arg_22_0.join_lobby_data_id = nil
end

function StartGameWindowLobbyBrowser._populate_lobby_list(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.lobby_list:selected_lobby()
	local var_23_1 = arg_23_0:_get_lobbies()
	local var_23_2 = true
	local var_23_3 = arg_23_0.selected_show_lobbies_index == 2 and true or false
	local var_23_4 = {}
	local var_23_5 = 0

	for iter_23_0, iter_23_1 in pairs(var_23_1) do
		if var_23_3 or arg_23_0:_valid_lobby(iter_23_1) then
			var_23_5 = var_23_5 + 1
			var_23_4[var_23_5] = iter_23_1
		end
	end

	local var_23_6 = false

	if arg_23_1 and var_23_6 and arg_23_0.lobby_list_update_timer then
		arg_23_0.lobby_list:animate_loading_text()
	end

	arg_23_0.lobby_list_update_timer = var_23_6 and MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH or nil

	arg_23_0.lobby_list:populate_lobby_list(var_23_4, var_23_2)

	if var_23_0 then
		arg_23_0.lobby_list:set_selected_lobby(var_23_0)
	end
end

local var_0_8 = {}

function StartGameWindowLobbyBrowser._get_lobbies(arg_24_0)
	local var_24_0 = arg_24_0._current_lobby_type

	if var_24_0 == "lobbies" then
		return arg_24_0.lobby_finder:lobbies() or var_0_8
	elseif var_24_0 == "servers" then
		return arg_24_0.game_server_finder:servers() or var_0_8
	else
		ferror("Unknown lobby type (%s)", var_24_0)
	end
end

function StartGameWindowLobbyBrowser._valid_lobby(arg_25_0, arg_25_1)
	if not arg_25_1.valid then
		return false
	end

	local var_25_0 = arg_25_1.selected_mission_id or arg_25_1.mission_id
	local var_25_1 = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_25_1.mechanism)
	local var_25_2 = tonumber(arg_25_1.num_players)

	if not var_25_0 or var_25_2 == var_25_1.MAX_NUMBER_OF_PLAYERS then
		return false
	end

	if arg_25_1.server_info ~= nil then
		local var_25_3 = arg_25_0._current_server_name

		if var_25_3 ~= "" and string.find(arg_25_1.server_info.name, var_25_3) == nil then
			return false
		end
	else
		local var_25_4 = {}
		local var_25_5 = arg_25_0.statistics_db
		local var_25_6 = arg_25_0._stats_id
		local var_25_7 = arg_25_1.difficulty

		if var_25_7 then
			local var_25_8 = DifficultySettings[var_25_7]

			if var_25_8.extra_requirement_name then
				local var_25_9 = ExtraDifficultyRequirements[var_25_8.extra_requirement_name]

				if not Development.parameter("unlock_all_difficulties") and not var_25_9.requirement_function() then
					return false
				end
			end

			if var_25_8.dlc_requirement then
				var_25_4[var_25_8.dlc_requirement] = true
			end
		end

		local var_25_10 = arg_25_1.weave_quick_game == "true"
		local var_25_11 = arg_25_1.mechanism
		local var_25_12 = MechanismSettings[var_25_11]

		if var_25_12 and var_25_12.required_dlc then
			var_25_4[var_25_12.required_dlc] = true
		end

		for iter_25_0, iter_25_1 in pairs(var_25_4) do
			if not Managers.unlock:is_dlc_unlocked(iter_25_0) then
				return false
			end
		end

		if var_25_12 and var_25_12.extra_requirements_function and not var_25_12.extra_requirements_function() then
			return false
		end

		if var_25_11 == "weave" then
			local var_25_13 = var_25_0

			if var_25_13 ~= "false" and not var_25_10 then
				if LevelUnlockUtils.weave_disabled(var_25_13) then
					return false, "weave_disabled"
				end

				local var_25_14 = false

				if not (LevelUnlockUtils.weave_unlocked(var_25_5, var_25_6, var_25_13, var_25_14) or var_25_13 == arg_25_0._current_weave) then
					return false
				end
			end
		else
			if not LevelUnlockUtils.level_unlocked(var_25_5, var_25_6, var_25_0) then
				return false
			end

			if not MatchmakingManager.is_lobby_private(arg_25_1) and not Managers.matchmaking:has_required_power_level(arg_25_1, arg_25_0._profile_name, arg_25_0._career_name) then
				return false
			end
		end

		if not (arg_25_1.matchmaking and arg_25_1.matchmaking ~= "false") or not var_25_7 or var_25_0 == "n/a" then
			return false
		end
	end

	return true
end

function StartGameWindowLobbyBrowser._update_auto_refresh(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.lobby_list_update_timer

	if var_26_0 then
		local var_26_1 = var_26_0 - arg_26_1

		if var_26_1 < 0 then
			arg_26_0:_populate_lobby_list(true)
		else
			arg_26_0.lobby_list_update_timer = var_26_1
		end
	end
end

function StartGameWindowLobbyBrowser._update_join_button(arg_27_0, arg_27_1)
	local var_27_0 = Managers.matchmaking:is_game_matchmaking()
	local var_27_1 = arg_27_0._base_widgets_by_name.join_button

	if arg_27_1 and not var_27_0 then
		if arg_27_0:_valid_lobby(arg_27_1) then
			var_27_1.content.button_hotspot.disable_button = false
		else
			var_27_1.content.button_hotspot.disable_button = true
		end
	else
		var_27_1.content.button_hotspot.disable_button = true
	end
end

function StartGameWindowLobbyBrowser._reset_filters(arg_28_0)
	local var_28_0 = arg_28_0._game_mode_data
	local var_28_1 = arg_28_0._game_mode_data.game_modes.any

	arg_28_0:_on_game_type_stepper_input(0, var_28_1)
	arg_28_0:_on_show_lobbies_stepper_input(0, 1)
	arg_28_0:_on_distance_stepper_input(0, 2)
end

function StartGameWindowLobbyBrowser._reset_level_filter(arg_29_0)
	local var_29_0 = #arg_29_0:_get_levels()

	arg_29_0:_on_level_stepper_input(0, var_29_0)
end

function StartGameWindowLobbyBrowser._reset_difficulty_filter(arg_30_0)
	local var_30_0 = #arg_30_0:_get_difficulties()

	arg_30_0:_on_difficulty_stepper_input(0, var_30_0)
end

function StartGameWindowLobbyBrowser._switch_lobby_type(arg_31_0, arg_31_1)
	arg_31_0._current_lobby_type = arg_31_1
	arg_31_0._base_widgets_by_name.lobby_type_button.content.button_text = arg_31_1 == "lobbies" and Localize("lb_lobby_type_lobbies") or Localize("lb_lobby_type_servers")

	if arg_31_1 == "lobbies" then
		-- block empty
	elseif arg_31_1 == "servers" then
		arg_31_0:_on_search_type_stepper_input(0, 1)
	else
		ferror("Unknown lobby type (%s)", arg_31_1)
	end

	arg_31_0:_search()
end

function StartGameWindowLobbyBrowser._create_filter_requirements(arg_32_0)
	local var_32_0 = arg_32_0.lobby_finder
	local var_32_1 = arg_32_0.selected_game_mode_index
	local var_32_2 = arg_32_0._game_mode_data.game_modes[var_32_1] or "any"
	local var_32_3 = arg_32_0.selected_level_index
	local var_32_4 = arg_32_0:_get_levels()[var_32_3]
	local var_32_5 = arg_32_0.selected_difficulty_index
	local var_32_6 = arg_32_0:_get_difficulties()[var_32_5]
	local var_32_7 = not script_data.show_invalid_lobbies and not arg_32_0._base_widgets_by_name.invalid_checkbox.content.checked
	local var_32_8 = arg_32_0.selected_distance_index
	local var_32_9 = LobbyAux.map_lobby_distance_filter[var_32_8]
	local var_32_10 = not (arg_32_0.selected_show_lobbies_index == 2 and true or false)
	local var_32_11 = 1
	local var_32_12 = {
		filters = {},
		near_filters = {}
	}
	local var_32_13 = arg_32_0._current_lobby_type

	if var_32_13 == "lobbies" then
		var_32_12.free_slots = var_32_11
		var_32_12.distance_filter = var_0_5 ~= "ps4" and var_32_9
	end

	if IS_PS4 then
		local var_32_14 = Managers.account:region()

		if var_32_9 == "close" then
			var_32_12.filters.primary_region = {
				comparison = "equal",
				value = MatchmakingRegionLookup.primary[var_32_14]
			}
		elseif var_32_9 == "medium" then
			var_32_12.filters.secondary_region = {
				comparison = "equal",
				value = MatchmakingRegionLookup.secondary[var_32_14]
			}
		end
	end

	local var_32_15 = Managers.eac:is_trusted()

	var_32_12.filters.eac_authorized = {
		comparison = "equal",
		value = var_32_15 and "true" or "false"
	}

	if var_32_6 ~= "any" and var_32_6 then
		var_32_12.filters.difficulty = {
			comparison = "equal",
			value = var_32_6
		}
	end

	if var_32_4 ~= "any" and var_32_4 then
		var_32_12.filters.selected_mission_id = {
			comparison = "equal",
			value = var_32_4
		}
	end

	if var_32_2 ~= "any" then
		var_32_12.filters.mechanism = {
			comparison = "equal",
			value = var_32_2
		}
	end

	if var_32_7 then
		var_32_12.filters.network_hash = {
			comparison = "equal",
			value = var_32_0:network_hash()
		}
	end

	if var_32_10 and var_32_13 == "lobbies" then
		var_32_12.filters.matchmaking = {
			value = "false",
			comparison = "not_equal"
		}
	end

	return var_32_12
end

function StartGameWindowLobbyBrowser._join(arg_33_0, arg_33_1, arg_33_2)
	Managers.matchmaking:request_join_lobby(arg_33_1, arg_33_2)

	arg_33_0.join_lobby_data_id = arg_33_1.id
end

function StartGameWindowLobbyBrowser._search(arg_34_0)
	local var_34_0 = arg_34_0:_create_filter_requirements()

	if arg_34_0._current_lobby_type == "lobbies" then
		local var_34_1 = arg_34_0.lobby_finder
		local var_34_2 = var_34_1:get_lobby_browser()

		LobbyInternal.clear_filter_requirements(var_34_2)

		local var_34_3 = true

		var_34_1:add_filter_requirements(var_34_0, var_34_3)
	elseif arg_34_0._current_lobby_type == "servers" then
		local var_34_4 = arg_34_0.game_server_finder
		local var_34_5 = {
			server_browser_filters = {
				dedicated = "valuenotused",
				full = "valuenotused",
				gamedir = Managers.mechanism:server_universe()
			},
			matchmaking_filters = var_34_0.filters
		}
		local var_34_6 = true

		var_34_4:add_filter_requirements(var_34_5, var_34_6)
		var_34_4:refresh()
	else
		ferror("Unknown lobby type (%s)", arg_34_0._current_lobby_type)
	end

	arg_34_0._searching = true

	arg_34_0:_populate_lobby_list()
end

function StartGameWindowLobbyBrowser._get_levels(arg_35_0)
	local var_35_0 = arg_35_0._game_mode_data
	local var_35_1 = var_35_0.game_modes
	local var_35_2 = var_35_0[arg_35_0.selected_game_mode_index or var_35_1.any]

	return var_35_2 and var_35_2.levels or {
		"any"
	}
end

function StartGameWindowLobbyBrowser._get_difficulties(arg_36_0)
	local var_36_0 = arg_36_0._game_mode_data
	local var_36_1 = var_36_0.game_modes
	local var_36_2 = var_36_0[arg_36_0.selected_game_mode_index or var_36_1.any]

	return var_36_2 and var_36_2.difficulties or {
		"any"
	}
end

function StartGameWindowLobbyBrowser._on_game_type_stepper_input(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0._lobbies_widgets_by_name.game_type_stepper
	local var_37_1 = arg_37_0._game_mode_data.game_modes
	local var_37_2 = arg_37_0.selected_game_mode_index or var_37_1.any
	local var_37_3 = arg_37_0:_on_stepper_input(var_37_0, var_37_1, var_37_2, arg_37_1, arg_37_2)
	local var_37_4 = "lobby_browser_mission"
	local var_37_5 = var_37_1[var_37_3]

	var_37_0.content.setting_text = Localize(var_0_7[var_37_5] or "")
	arg_37_0.selected_game_mode_index = var_37_3
	arg_37_0.search_timer = var_0_4
	arg_37_0.selected_level_index = 1
	arg_37_0.selected_difficulty_index = 1

	local var_37_6 = arg_37_0.selected_level_index
	local var_37_7 = arg_37_0:_get_levels()
	local var_37_8 = var_37_7[var_37_6]
	local var_37_9 = arg_37_0._lobbies_widgets_by_name.level_banner_widget.content
	local var_37_10 = arg_37_0._lobbies_widgets_by_name.level_stepper.content

	if not var_37_8 or #var_37_7 == 1 then
		var_37_9.disabled = true
		var_37_10.button_hotspot_left.disable_button = true
		var_37_10.button_hotspot_right.disable_button = true
	else
		var_37_9.disabled = false
		var_37_10.button_hotspot_left.disable_button = false
		var_37_10.button_hotspot_right.disable_button = false
	end

	local var_37_11 = arg_37_0.selected_difficulty_index
	local var_37_12 = arg_37_0:_get_difficulties()[var_37_11]
	local var_37_13 = arg_37_0._lobbies_widgets_by_name.difficulty_banner_widget.content
	local var_37_14 = arg_37_0._lobbies_widgets_by_name.difficulty_stepper.content

	if not var_37_12 or #var_37_7 == 1 then
		var_37_13.disabled = true
		var_37_14.button_hotspot_left.disable_button = true
		var_37_14.button_hotspot_right.disable_button = true
	else
		var_37_13.disabled = false
		var_37_14.button_hotspot_left.disable_button = false
		var_37_14.button_hotspot_right.disable_button = false
	end

	arg_37_0:_reset_level_filter()
	arg_37_0:_reset_difficulty_filter()
end

function StartGameWindowLobbyBrowser._on_level_stepper_input(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0._lobbies_widgets_by_name.level_stepper
	local var_38_1 = arg_38_0:_get_levels()
	local var_38_2 = arg_38_0.selected_level_index or 1
	local var_38_3 = arg_38_0:_on_stepper_input(var_38_0, var_38_1, var_38_2, arg_38_1, arg_38_2)
	local var_38_4 = "lobby_browser_mission"
	local var_38_5 = var_38_1[var_38_3]

	if var_38_5 ~= "any" then
		var_38_4 = LevelSettings[var_38_5].display_name
	end

	var_38_0.content.setting_text = Localize(var_38_4)
	arg_38_0.selected_level_index = var_38_3
	arg_38_0.search_timer = var_0_4
end

function StartGameWindowLobbyBrowser._on_difficulty_stepper_input(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0._lobbies_widgets_by_name.difficulty_stepper
	local var_39_1 = arg_39_0:_get_difficulties()
	local var_39_2 = arg_39_0.selected_difficulty_index or 1
	local var_39_3 = arg_39_0:_on_stepper_input(var_39_0, var_39_1, var_39_2, arg_39_1, arg_39_2)
	local var_39_4 = "lobby_browser_difficulty"
	local var_39_5 = var_39_1[var_39_3]

	if var_39_5 ~= "any" then
		var_39_4 = DifficultySettings[var_39_5].display_name
	end

	var_39_0.content.setting_text = Localize(var_39_4)
	arg_39_0.selected_difficulty_index = var_39_3
	arg_39_0.search_timer = var_0_4
end

function StartGameWindowLobbyBrowser._on_show_lobbies_stepper_input(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0._lobbies_widgets_by_name.show_lobbies_stepper
	local var_40_1 = var_0_0.show_lobbies_table
	local var_40_2 = arg_40_0.selected_show_lobbies_index or 1
	local var_40_3 = arg_40_0:_on_stepper_input(var_40_0, var_40_1, var_40_2, arg_40_1, arg_40_2)
	local var_40_4 = var_40_1[var_40_3]

	var_40_0.content.setting_text = Localize(var_40_4)
	arg_40_0.selected_show_lobbies_index = var_40_3
	arg_40_0.search_timer = var_0_4
end

function StartGameWindowLobbyBrowser._on_distance_stepper_input(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0._lobbies_widgets_by_name.distance_stepper
	local var_41_1 = var_0_0.distance_table
	local var_41_2 = arg_41_0.selected_distance_index or 1
	local var_41_3 = arg_41_0:_on_stepper_input(var_41_0, var_41_1, var_41_2, arg_41_1, arg_41_2)
	local var_41_4 = var_41_1[var_41_3]

	var_41_0.content.setting_text = Localize(var_41_4)
	arg_41_0.selected_distance_index = var_41_3
	arg_41_0.search_timer = var_0_4
end

function StartGameWindowLobbyBrowser._on_search_type_stepper_input(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_0._server_widgets_by_name.search_type_stepper
	local var_42_1 = var_0_0.search_type_text_table
	local var_42_2 = arg_42_0.selected_search_type_index or 1
	local var_42_3 = arg_42_0:_on_stepper_input(var_42_0, var_42_1, var_42_2, arg_42_1, arg_42_2)
	local var_42_4 = var_42_1[var_42_3]

	var_42_0.content.setting_text = Localize(var_42_4)
	arg_42_0.selected_search_type_index = var_42_3
	arg_42_0.search_timer = var_0_4

	local var_42_5 = var_0_0.search_type_table[var_42_3]

	arg_42_0.game_server_finder:set_search_type(var_42_5)
end

function StartGameWindowLobbyBrowser._on_stepper_input(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	local var_43_0 = #arg_43_2

	if arg_43_5 then
		fassert(arg_43_5 > 0 and arg_43_5 <= var_43_0, "stepper_index out of range")

		return arg_43_5
	end

	local var_43_1 = arg_43_3 + arg_43_4

	if var_43_1 < 1 then
		var_43_1 = var_43_0
	elseif var_43_0 < var_43_1 then
		var_43_1 = 1
	end

	return var_43_1
end

function StartGameWindowLobbyBrowser._handle_stepper_input(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = arg_44_2
	local var_44_1 = var_44_0.content
	local var_44_2 = var_44_1.button_hotspot_left
	local var_44_3 = var_44_1.button_hotspot_right

	if var_44_2.on_hover_enter then
		arg_44_0:_on_stepper_arrow_hover(var_44_0, arg_44_1, "left_button_icon_clicked")
	elseif var_44_3.on_hover_enter then
		arg_44_0:_on_stepper_arrow_hover(var_44_0, arg_44_1, "right_button_icon_clicked")
	end

	if var_44_2.on_hover_exit then
		arg_44_0:_on_stepper_arrow_dehover(var_44_0, arg_44_1, "left_button_icon_clicked")
	elseif var_44_3.on_hover_exit then
		arg_44_0:_on_stepper_arrow_dehover(var_44_0, arg_44_1, "right_button_icon_clicked")
	end

	if var_44_2.on_hover_enter or var_44_3.on_hover_enter then
		arg_44_0:_play_sound("Play_hud_hover")
	end

	if var_44_2.on_release then
		var_44_2.on_release = nil

		arg_44_3(-1)
		arg_44_0:_play_sound("Play_hud_select")
		arg_44_0:_on_stepper_arrow_pressed(var_44_0, arg_44_1, "left_button_icon")
		arg_44_0:_on_stepper_arrow_pressed(var_44_0, arg_44_1, "left_button_icon_clicked")
	elseif var_44_3.on_release then
		var_44_3.on_release = nil

		arg_44_3(1)
		arg_44_0:_play_sound("Play_hud_select")
		arg_44_0:_on_stepper_arrow_pressed(var_44_0, arg_44_1, "right_button_icon")
		arg_44_0:_on_stepper_arrow_pressed(var_44_0, arg_44_1, "right_button_icon_clicked")
	end
end

function StartGameWindowLobbyBrowser._on_stepper_arrow_pressed(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = arg_45_0._ui_animations
	local var_45_1 = "stepper_widget_arrow_" .. arg_45_2 .. arg_45_3
	local var_45_2 = arg_45_1.style[arg_45_3]
	local var_45_3 = {
		28,
		34
	}
	local var_45_4 = var_45_2.color[1]
	local var_45_5 = 255
	local var_45_6 = UISettings.scoreboard.topic_hover_duration

	if var_45_6 > 0 then
		var_45_0[var_45_1 .. "_hover"] = arg_45_0:_animate_element_by_time(var_45_2.color, 1, var_45_4, var_45_5, var_45_6)
		var_45_0[var_45_1 .. "_selected_size_width"] = arg_45_0:_animate_element_by_catmullrom(var_45_2.size, 1, var_45_3[1], 0.7, 1, 1, 0.7, var_45_6)
		var_45_0[var_45_1 .. "_selected_size_height"] = arg_45_0:_animate_element_by_catmullrom(var_45_2.size, 2, var_45_3[2], 0.7, 1, 1, 0.7, var_45_6)
	else
		var_45_2.color[1] = var_45_5
	end
end

function StartGameWindowLobbyBrowser._on_stepper_arrow_hover(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = arg_46_0._ui_animations
	local var_46_1 = "stepper_widget_arrow_" .. arg_46_2 .. arg_46_3
	local var_46_2 = arg_46_1.style[arg_46_3]
	local var_46_3 = var_46_2.color[1]
	local var_46_4 = 255
	local var_46_5 = UISettings.scoreboard.topic_hover_duration
	local var_46_6 = (1 - var_46_3 / var_46_4) * var_46_5

	if var_46_6 > 0 then
		var_46_0[var_46_1 .. "_hover"] = arg_46_0:_animate_element_by_time(var_46_2.color, 1, var_46_3, var_46_4, var_46_6)
	else
		var_46_2.color[1] = var_46_4
	end

	arg_46_0:_play_sound("Play_hud_hover")
end

function StartGameWindowLobbyBrowser._on_stepper_arrow_dehover(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = arg_47_0._ui_animations
	local var_47_1 = "stepper_widget_arrow_" .. arg_47_2 .. arg_47_3
	local var_47_2 = arg_47_1.style[arg_47_3]
	local var_47_3 = var_47_2.color[1]
	local var_47_4 = 0
	local var_47_5 = UISettings.scoreboard.topic_hover_duration
	local var_47_6 = var_47_3 / 255 * var_47_5

	if var_47_6 > 0 then
		var_47_0[var_47_1 .. "_hover"] = arg_47_0:_animate_element_by_time(var_47_2.color, 1, var_47_3, var_47_4, var_47_6)
	else
		var_47_2.color[1] = var_47_4
	end
end

function StartGameWindowLobbyBrowser._animate_element_by_time(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5, math.ease_out_quad))
end

function StartGameWindowLobbyBrowser._animate_element_by_catmullrom(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6, arg_49_7, arg_49_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6, arg_49_7, arg_49_8))
end
