-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_lobby_browser.lua

require("scripts/ui/views/lobby_item_list")
require("scripts/network/lobby_aux")

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local num = 0
local PLATFORM = PLATFORM
local tbl = {
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
local tbl_2 = {
	deus = "area_selection_morris_name",
	adventure = "area_selection_campaign",
	weave = "menu_weave_area_no_wom_title",
	versus = "vs_ui_versus_tag",
	any = "lobby_browser_mission"
}

StartGameWindowLobbyBrowser = class(StartGameWindowLobbyBrowser)
StartGameWindowLobbyBrowser.NAME = "StartGameWindowLobbyBrowser"

StartGameWindowLobbyBrowser.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowLobbyBrowser")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.difficulty_manager = Managers.state.difficulty

	local player = Managers.player
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._profile_name = local_player:profile_display_name()
	self._career_name = local_player:career_name()
	self._ui_animations = {}

	local network_options = LobbySetup.network_options()

	self.lobby_finder = LobbyFinder:new(network_options, MatchmakingSettings.MAX_NUM_LOBBIES, true)

	local var_1_4
	local parameter = Development.parameter("use_lan_backend")

	parameter = parameter or rawget(_G, "Steam") == nil

	local IS_WINDOWS = IS_WINDOWS

	if not (parameter or IS_WINDOWS) then
		var_1_4 = GameServerFinderLan:new(network_options, MatchmakingSettings.MAX_NUM_SERVERS)
	else
		var_1_4 = GameServerFinder:new(network_options, MatchmakingSettings.MAX_NUM_SERVERS)
	end

	self.game_server_finder = var_1_4
	self._game_mode_data = var_0_0.setup_game_mode_data(self.statistics_db, self._stats_id)

	table.dump(self._game_mode_data, "GAME MODE DATA", 3)
	self:create_ui_elements(arg_1_1, arg_1_2)

	self._current_lobby_type = "lobbies"

	local name = self.parent:window_input_service().name
	local tbl = {
		0,
		0,
		0
	}
	local tbl_2 = {
		use_top_renderer = false,
		num_list_items = 15,
		input_service_name = name,
		offset = tbl
	}

	self.lobby_list = LobbyItemsList:new(ingame_ui_context, tbl_2)
	self.lobby_list_update_timer = MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH
	self.show_invalid = false
	self.selected_gamepad_widget_index = 1
	self._draw_invalid_checkbox = BUILD == "dev" or BUILD == "debug"
	self._base_widgets_by_name.invalid_checkbox.content.visible = self._draw_invalid_checkbox
	self._current_server_name = ""
	self._show_widget_type = "adventure"

	Managers.matchmaking:set_active_lobby_browser(self)
	self:_populate_lobby_list()
end

StartGameWindowLobbyBrowser.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self.ui_scenegraph = init_scenegraph

	local flag = false

	self._current_weave = LevelUnlockUtils.current_weave(self.statistics_db, self._stats_id, flag)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets.base) do
		local var_2_4 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_4
		tbl_2[k] = var_2_4
	end

	self._base_widgets = tbl
	self._base_widgets_by_name = tbl_2

	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(widgets.lobbies) do
		local var_2_7 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_2_7
		tbl_4[k_2] = var_2_7
	end

	self._lobbies_widgets = tbl_3
	self._lobbies_widgets_by_name = tbl_4

	local tbl_5 = {}
	local tbl_6 = {}

	for k_3, v_3 in pairs(widgets.servers) do
		local var_2_10 = UIWidget.init(v_3)

		tbl_5[#tbl_5 + 1] = var_2_10
		tbl_6[k_3] = var_2_10
	end

	self._server_widgets = tbl_5
	self._server_widgets_by_name = tbl_6

	local tbl_7 = {}
	local tbl_8 = {}

	for k_4, v_4 in pairs(widgets.lobby_info_box_base) do
		local var_2_13 = UIWidget.init(v_4)

		tbl_7[#tbl_7 + 1] = var_2_13
		tbl_8[k_4] = var_2_13
	end

	self._lobby_info_box_base_widgets = tbl_7
	self._lobby_info_box_base_widgets_by_name = tbl_8

	local tbl_9 = {}
	local tbl_10 = {}

	for k_5, v_5 in pairs(widgets.lobby_info_box_weaves) do
		local var_2_16 = UIWidget.init(v_5)

		tbl_9[#tbl_9 + 1] = var_2_16
		tbl_10[k_5] = var_2_16
	end

	self._lobby_info_box_weaves_widgets = tbl_9
	self._lobby_info_box_weaves_widgets_by_name = tbl_10

	local tbl_11 = {}
	local tbl_12 = {}

	for k_6, v_6 in pairs(widgets.lobby_info_box_lobbies_weaves) do
		local var_2_19 = UIWidget.init(v_6)

		tbl_11[#tbl_11 + 1] = var_2_19
		tbl_12[k_6] = var_2_19
	end

	self._lobby_info_box_lobbies_weaves_widgets = tbl_11
	self._lobby_info_box_lobbies_weaves_widgets_by_name = tbl_12

	local tbl_13 = {}
	local tbl_14 = {}

	for k_7, v_7 in pairs(widgets.lobby_info_box_deus) do
		local var_2_22 = UIWidget.init(v_7)

		tbl_13[#tbl_13 + 1] = var_2_22
		tbl_14[k_7] = var_2_22
	end

	self._lobby_info_box_deus_widgets = tbl_13
	self._lobby_info_box_deus_widgets_by_name = tbl_14

	local tbl_15 = {}
	local tbl_16 = {}

	for k_8, v_8 in pairs(widgets.lobby_info_box_lobbies_deus) do
		local var_2_25 = UIWidget.init(v_8)

		tbl_15[#tbl_15 + 1] = var_2_25
		tbl_16[k_8] = var_2_25
	end

	self._lobby_info_box_lobbies_deus_widgets = tbl_15
	self._lobby_info_box_lobbies_deus_widgets_by_name = tbl_16

	local tbl_17 = {}
	local tbl_18 = {}

	for k_9, v_9 in pairs(widgets.lobby_info_box_lobbies) do
		local var_2_28 = UIWidget.init(v_9)

		tbl_17[#tbl_17 + 1] = var_2_28
		tbl_18[k_9] = var_2_28
	end

	self._lobby_info_box_lobbies_widgets = tbl_17
	self._lobby_info_box_lobbies_widgets_by_name = tbl_18

	local tbl_19 = {}
	local tbl_20 = {}

	for k_10, v_10 in pairs(widgets.lobby_info_box_servers) do
		local var_2_31 = UIWidget.init(v_10)

		tbl_19[#tbl_19 + 1] = var_2_31
		tbl_20[k_10] = var_2_31
	end

	self._lobby_info_box_servers_widgets = tbl_19
	self._lobby_info_box_servers_widgets_by_name = tbl_20

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end

	self:_assign_hero_portraits()
	self:_reset_filters()
end

StartGameWindowLobbyBrowser._assign_hero_portraits = function (self)
	-- function 3
	local content = self._lobby_info_box_base_widgets_by_name.hero_tabs.content

	for i = 1, #ProfilePriority do
		local var_3_1 = ProfilePriority[i]
		local str = "_" .. tostring(i)
		local var_3_3 = content["hotspot" .. str]
		local str_2 = "icon" .. str
		local str_3 = "icon" .. str .. "_saturated"
		local ui_portrait = SPProfiles[var_3_1].ui_portrait

		var_3_3[str_2] = ui_portrait
		var_3_3[str_3] = ui_portrait .. "_saturated"
	end

	local content_2 = self._lobby_info_box_deus_widgets_by_name.hero_tabs.content

	for j = 1, #ProfilePriority do
		local var_3_8 = ProfilePriority[j]
		local str_4 = "_" .. tostring(j)
		local var_3_10 = content_2["hotspot" .. str_4]
		local str_5 = "icon" .. str_4
		local str_6 = "icon" .. str_4 .. "_saturated"
		local ui_portrait_2 = SPProfiles[var_3_8].ui_portrait

		var_3_10[str_5] = ui_portrait_2
		var_3_10[str_6] = ui_portrait_2 .. "_saturated"
	end
end

StartGameWindowLobbyBrowser.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameWindow] Exit Substate StartGameWindowLobbyBrowser")

	self.ui_animator = nil

	Managers.matchmaking:set_active_lobby_browser(nil)
	self.lobby_finder:destroy()

	self.lobby_finder = nil

	self.game_server_finder:destroy()

	self.game_server_finder = nil
end

StartGameWindowLobbyBrowser.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self.lobby_finder:update(arg_5_1)
	self.game_server_finder:update(arg_5_1)

	local _is_refreshing = self:_is_refreshing()

	if not (not self._searching and _is_refreshing) then
		self._searching = false

		self:_populate_lobby_list()
	end

	self:_update_animations(arg_5_1)
	self:_handle_input(arg_5_1, arg_5_2)
	self:draw(arg_5_1)
	self:_update_auto_refresh(arg_5_1)

	local _searching = self._searching
	local lobby_list = self.lobby_list

	lobby_list:update(arg_5_1, _searching)
	lobby_list:draw(arg_5_1)

	local lobby_list_index_changed = lobby_list.lobby_list_index_changed

	if not lobby_list_index_changed then
		lobby_list:on_lobby_selected(lobby_list_index_changed)

		local selected_lobby = lobby_list:selected_lobby()

		self:_setup_lobby_info_box(selected_lobby)
	end

	local selected_lobby_2 = lobby_list:selected_lobby()

	self:_update_join_button(selected_lobby_2)

	if not self._draw_invalid_checkbox then
		local content = self._base_widgets_by_name.invalid_checkbox.content
		local button_hotspot = content.button_hotspot

		if not button_hotspot.on_hover_enter then
			self:_play_sound("Play_hud_hover")
		end

		if not button_hotspot.on_release then
			content.checked = not content.checked
			self.search_timer = num

			self:_play_sound("Play_hud_select")
		end
	end

	local _base_widgets_by_name = self._base_widgets_by_name
	local button_hotspot_2 = _base_widgets_by_name.join_button.content.button_hotspot
	local button_hotspot_3 = _base_widgets_by_name.search_button.content.button_hotspot
	local button_hotspot_4 = _base_widgets_by_name.reset_button.content.button_hotspot
	local button_hotspot_5 = _base_widgets_by_name.lobby_type_button.content.button_hotspot

	if button_hotspot_3.on_hover_enter or button_hotspot_2.on_hover_enter or button_hotspot_4.on_hover_enter or not button_hotspot_5.on_hover_enter then
		self:_play_sound("Play_hud_hover")
	end

	if not button_hotspot_2.disable_button then
		local join_lobby_data_id = self.join_lobby_data_id

		if not button_hotspot_2.on_release and join_lobby_data_id or not selected_lobby_2 then
			self:_play_sound("Play_hud_select")
			self:_join(selected_lobby_2)
		end
	end

	if not button_hotspot_5.on_release then
		self:_play_sound("Play_hud_select")

		button_hotspot_5.on_release = nil

		local _current_lobby_type = self._current_lobby_type
		local str = "lobbies"

		if _current_lobby_type == "lobbies" then
			str = "servers"
		end

		self:_switch_lobby_type(str)
	end

	if not button_hotspot_3.on_release then
		self:_play_sound("Play_hud_select")

		button_hotspot_3.on_release = nil

		self:_search()
	end

	if not button_hotspot_4.on_release then
		self:_play_sound("Play_hud_select")

		button_hotspot_4.on_release = nil

		self:_reset_filters()
	end

	if not self.search_timer then
		self.search_timer = self.search_timer - arg_5_1

		if self.search_timer < 0 then
			self:_search()

			self.search_timer = nil
		end
	end
end

StartGameWindowLobbyBrowser.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

StartGameWindowLobbyBrowser._handle_weave_data = function (self, arg_7_1)
	-- function 7
	local _lobby_info_box_weaves_widgets_by_name = self._lobby_info_box_weaves_widgets_by_name
	local _lobby_info_box_base_widgets_by_name = self._lobby_info_box_base_widgets_by_name
	local _lobby_info_box_lobbies_weaves_widgets_by_name = self._lobby_info_box_lobbies_weaves_widgets_by_name
	local weave_name = _lobby_info_box_weaves_widgets_by_name.weave_name

	weave_name.content.text = Localize("tutorial_no_text")

	local wind_name = _lobby_info_box_weaves_widgets_by_name.wind_name

	wind_name.content.text = Localize("tutorial_no_text")

	local level_image_frame = _lobby_info_box_base_widgets_by_name.level_image_frame

	level_image_frame.content.texture_id = "map_frame_00"
	level_image_frame.style.texture_id.color = Colors.get_color_table_with_alpha("white", 255)

	local wind_icon = _lobby_info_box_weaves_widgets_by_name.wind_icon

	wind_icon.style.texture_id.color[1] = 0

	local wind_icon_glow = _lobby_info_box_weaves_widgets_by_name.wind_icon_glow

	wind_icon_glow.style.texture_id.color[1] = 0

	local wind_icon_bg = _lobby_info_box_weaves_widgets_by_name.wind_icon_bg

	wind_icon_bg.style.texture_id.color[1] = 0

	local wind_icon_slot = _lobby_info_box_weaves_widgets_by_name.wind_icon_slot

	wind_icon_slot.style.texture_id.color[1] = 0

	local mutator_icon = _lobby_info_box_weaves_widgets_by_name.mutator_icon

	mutator_icon.style.texture_id.color[1] = 0

	local mutator_icon_frame = _lobby_info_box_weaves_widgets_by_name.mutator_icon_frame

	mutator_icon_frame.style.texture_id.color[1] = 0

	local mutator_title_divider = _lobby_info_box_weaves_widgets_by_name.mutator_title_divider

	mutator_title_divider.style.texture_id.color[1] = 0

	local mutator_title_text = _lobby_info_box_weaves_widgets_by_name.mutator_title_text

	mutator_title_text.content.text = "tutorial_no_text"

	local mutator_description_text = _lobby_info_box_weaves_widgets_by_name.mutator_description_text

	mutator_description_text.content.text = "tutorial_no_text"

	local objective_title_bg = _lobby_info_box_weaves_widgets_by_name.objective_title_bg

	objective_title_bg.style.texture_id.color[1] = 0

	local objective_title = _lobby_info_box_weaves_widgets_by_name.objective_title

	objective_title.content.text = "tutorial_no_text"
	_lobby_info_box_weaves_widgets_by_name.objective_1.content.text = "tutorial_no_text"
	_lobby_info_box_weaves_widgets_by_name.objective_2.content.text = "tutorial_no_text"

	local selected_mission_id = arg_7_1.selected_mission_id
	local var_7_18 = WeaveSettings.templates[selected_mission_id]
	local var_7_19 = Localize("lb_unknown")

	if selected_mission_id ~= "false" then
		local split_deprecated = string.split_deprecated(selected_mission_id, "_")
		local str = "Weave " .. split_deprecated[2]

		if not var_7_18 then
			weave_name.content.text = ""

			local wind = var_7_18.wind
			local var_7_23 = WindSettings[wind]

			wind_name.content.text = Localize(var_7_23.display_name)
			level_image_frame.content.texture_id = "map_frame_weaves"

			local get_color_table_with_alpha = Colors.get_color_table_with_alpha(wind, 255)

			level_image_frame.style.texture_id.color = get_color_table_with_alpha
			wind_name.style.text.text_color = get_color_table_with_alpha

			local thumbnail_icon = var_7_23.thumbnail_icon
			local size = UIAtlasHelper.get_atlas_settings_by_texture_name(thumbnail_icon).size

			wind_icon_glow.style.texture_id.color = get_color_table_with_alpha
			wind_icon_bg.style.texture_id.color = get_color_table_with_alpha
			wind_icon.content.texture_id = var_7_23.thumbnail_icon

			local texture_id = wind_icon.style.texture_id

			texture_id.texture_size = {
				size[1] * 0.8,
				size[2] * 0.8
			}
			texture_id.horizontal_alignment = "center"
			texture_id.vertical_alignment = "center"

			local mutator = var_7_23.mutator
			local var_7_29 = MutatorTemplates[mutator]

			mutator_icon.content.texture_id = var_7_29.icon
			mutator_title_text.content.text = var_7_29.display_name
			mutator_description_text.content.text = var_7_29.description
			objective_title.content.text = "weave_objective_title"

			local objectives = var_7_18.objectives
			local num = 10
			local num_2 = 0

			for i = 1, #objectives do
				local var_7_33 = objectives[i]
				local display_name = var_7_33.display_name
				local icon = var_7_33.icon

				self:_assign_objective(i, display_name, icon, num)
			end

			wind_icon.style.texture_id.color[1] = 255
			wind_icon_slot.style.texture_id.color[1] = 255
			mutator_icon.style.texture_id.color[1] = 255
			mutator_icon_frame.style.texture_id.color[1] = 255
			mutator_title_divider.style.texture_id.color[1] = 255
			objective_title_bg.style.texture_id.color[1] = 255
		end
	end

	local str_2 = "level_image_any"
	local str_3 = "lb_unknown"
	local mission_id = arg_7_1.mission_id

	mission_id = mission_id or arg_7_1.selected_mission_id

	if not (not mission_id and mission_id == "n/a") then
		local level_id

		if not var_7_18 then
			level_id = var_7_18.objectives[1].level_id

			if not level_id then
				-- Nothing
			end
		end

		level_id = mission_id

		::label_7_0::

		local var_7_40 = LevelSettings[level_id]

		str_2 = var_7_40.level_image

		local display_name_2 = var_7_40.display_name
	end

	_lobby_info_box_base_widgets_by_name.level_image.content.texture_id = str_2

	local content = _lobby_info_box_base_widgets_by_name.level_name.content
	local var_7_43

	if not var_7_18 and not var_7_18.display_name then
		var_7_43 = Localize(var_7_18.display_name)

		if not var_7_43 then
			-- Nothing
		end
	end

	var_7_43 = ""

	::label_7_1::

	content.text = var_7_43

	local get_matchmaking_settings_for_mechanism = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_7_1.mechanism)
	local str_4 = "n/a"
	local num_players = arg_7_1.num_players

	if not num_players then
		str_4 = string.format("%s/%s", num_players, tostring(get_matchmaking_settings_for_mechanism.MAX_NUMBER_OF_PLAYERS))
	end

	_lobby_info_box_lobbies_weaves_widgets_by_name.info_frame_players_text.content.text = str_4

	local lobby_status_text = LobbyItemsList.lobby_status_text(arg_7_1)

	_lobby_info_box_lobbies_weaves_widgets_by_name.info_frame_status_text.content.text = lobby_status_text

	local server_name = arg_7_1.server_name

	if not server_name then
		server_name = arg_7_1.unique_server_name

		if not server_name then
			server_name = arg_7_1.name
			server_name = server_name or arg_7_1.host
		end
	end

	_lobby_info_box_lobbies_weaves_widgets_by_name.info_frame_host_text.content.text = server_name or Localize("lb_unknown")
	self._show_widget_type = "weave"
end

StartGameWindowLobbyBrowser._handle_lobby_data = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _lobby_info_box_base_widgets_by_name = self._lobby_info_box_base_widgets_by_name
	local _lobby_info_box_lobbies_widgets_by_name = self._lobby_info_box_lobbies_widgets_by_name
	local _lobby_info_box_servers_widgets_by_name = self._lobby_info_box_servers_widgets_by_name

	_lobby_info_box_lobbies_widgets_by_name.info_frame_game_type_text.content.text = Localize(arg_8_1)
	_lobby_info_box_servers_widgets_by_name.info_frame_game_type_text.content.text = Localize(arg_8_1)

	local str = "level_image_any"
	local str_2 = "lb_unknown"
	local selected_mission_id = arg_8_2.selected_mission_id

	selected_mission_id = selected_mission_id or arg_8_2.mission_id

	if selected_mission_id == "any" then
		str = "level_image_any"
		str_2 = "map_screen_quickplay_button"
	elseif not (not selected_mission_id and selected_mission_id == "n/a") then
		local var_8_6 = LevelSettings[selected_mission_id]

		str = var_8_6.level_image
		str_2 = var_8_6.display_name
	end

	local level_image_frame = _lobby_info_box_base_widgets_by_name.level_image_frame

	level_image_frame.content.texture_id = "map_frame_00"
	level_image_frame.style.texture_id.color = Colors.get_color_table_with_alpha("white", 255)
	_lobby_info_box_base_widgets_by_name.level_image.content.texture_id = str
	_lobby_info_box_base_widgets_by_name.level_name.content.text = Localize(str_2)
	_lobby_info_box_lobbies_widgets_by_name.info_frame_level_name_text.content.text = Localize(str_2)
	_lobby_info_box_servers_widgets_by_name.info_frame_level_name_text.content.text = Localize(str_2)

	local info_frame_difficulty_title = _lobby_info_box_lobbies_widgets_by_name.info_frame_difficulty_title
	local info_frame_difficulty_text = _lobby_info_box_lobbies_widgets_by_name.info_frame_difficulty_text
	local str_3 = "lb_difficulty_unknown"
	local difficulty = arg_8_2.difficulty

	if not difficulty then
		str_3 = DifficultySettings[difficulty].display_name
	end

	_lobby_info_box_lobbies_widgets_by_name.info_frame_difficulty_text.content.text = Localize(str_3)
	_lobby_info_box_servers_widgets_by_name.info_frame_difficulty_text.content.text = Localize(str_3)

	local str_4 = "n/a"
	local num_players = arg_8_2.num_players
	local get_matchmaking_settings_for_mechanism = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_8_2.mechanism)

	if not num_players then
		str_4 = string.format("%s/%s", num_players, tostring(get_matchmaking_settings_for_mechanism.MAX_NUMBER_OF_PLAYERS))
	end

	_lobby_info_box_lobbies_widgets_by_name.info_frame_players_text.content.text = str_4
	_lobby_info_box_servers_widgets_by_name.info_frame_players_text.content.text = str_4

	local lobby_status_text = LobbyItemsList.lobby_status_text(arg_8_2)

	_lobby_info_box_lobbies_widgets_by_name.info_frame_status_text.content.text = lobby_status_text
	_lobby_info_box_servers_widgets_by_name.info_frame_status_text.content.text = lobby_status_text

	local var_8_16 = to_boolean(arg_8_2.twitch_enabled)

	_lobby_info_box_lobbies_widgets_by_name.info_frame_twitch_logo.content.visible = var_8_16

	local server_info = arg_8_2.server_info

	if not (server_info ~= nil) then
		local server_name = arg_8_2.server_name

		if not server_name then
			server_name = arg_8_2.unique_server_name

			if not server_name then
				server_name = arg_8_2.name
				server_name = server_name or arg_8_2.host
			end
		end

		_lobby_info_box_lobbies_widgets_by_name.info_frame_host_text.content.text = server_name or Localize("lb_unknown")
	else
		local name = server_info.name

		_lobby_info_box_servers_widgets_by_name.info_frame_name_text.content.text = name or Localize("lb_unknown")

		local ip_address = server_info.ip_address

		_lobby_info_box_servers_widgets_by_name.info_frame_ip_adress_text.content.text = ip_address or Localize("lb_unknown")

		local password = server_info.password
		local flag

		flag = (password ~= true or not "lb_yes" or password ~= false) and (not "lb_no" or "lb_unknown")
		_lobby_info_box_servers_widgets_by_name.info_frame_password_protected_text.content.text = Localize(flag)

		local ping = server_info.ping
		local content = _lobby_info_box_servers_widgets_by_name.info_frame_ping_text.content
		local var_8_25

		if not ping then
			var_8_25 = tostring(ping)

			if not var_8_25 then
				-- Nothing
			end
		end

		var_8_25 = Localize("lb_unknown")

		::label_8_0::

		content.text = var_8_25

		local favorite = server_info.favorite
		local content_2 = _lobby_info_box_servers_widgets_by_name.info_frame_favorite_text.content
		local var_8_28

		if not favorite then
			var_8_28 = Localize("lb_yes")

			if not var_8_28 then
				-- Nothing
			end
		end

		var_8_28 = Localize("lb_no")

		::label_8_1::

		content_2.text = var_8_28

		local content_3 = _lobby_info_box_servers_widgets_by_name.add_to_favorites_button.content
		local var_8_30

		if not favorite then
			var_8_30 = Localize("lb_remove_from_favorites")

			if not var_8_30 then
				-- Nothing
			end
		end

		var_8_30 = Localize("lb_add_to_favorites")

		::label_8_2::

		content_3.button_text = var_8_30
	end

	self._show_widget_type = "adventure"
end

StartGameWindowLobbyBrowser._gather_unlocked_journeys = function (arg_9_0)
	-- function 9
	local tbl = {}
	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()

	for i, v in ipairs(LevelUnlockUtils.unlocked_journeys(statistics_db, stats_id)) do
		tbl[v] = true
	end

	return tbl
end

StartGameWindowLobbyBrowser._handle_deus_data = function (self, arg_10_1)
	-- function 10
	local _gather_unlocked_journeys = self:_gather_unlocked_journeys()
	local _lobby_info_box_deus_widgets_by_name = self._lobby_info_box_deus_widgets_by_name
	local _lobby_info_box_lobbies_deus_widgets_by_name = self._lobby_info_box_lobbies_deus_widgets_by_name

	_lobby_info_box_lobbies_deus_widgets_by_name.info_frame_game_type_text.content.text = Localize("area_selection_morris_name")

	local tbl = {}
	local count = #SPProfiles

	for i = 1, count do
		if not ProfileSynchronizer.is_free_in_lobby(i, arg_10_1) then
			tbl[i] = true
		end
	end

	local content = _lobby_info_box_deus_widgets_by_name.hero_tabs.content

	for j = 1, #ProfilePriority do
		local var_10_6 = ProfilePriority[j]
		local str = "_" .. tostring(j)
		local var_10_8 = content["hotspot" .. str]

		if not tbl[var_10_6] then
			var_10_8.disable_button = true
		else
			var_10_8.disable_button = false
		end
	end

	local expedition_icon = _lobby_info_box_deus_widgets_by_name.expedition_icon
	local get_journey_cycle = Managers.backend:get_interface("deus"):get_journey_cycle()
	local selected_mission_id = arg_10_1.selected_mission_id
	local var_10_12 = DeusJourneySettings[selected_mission_id]
	local display_name = var_10_12.display_name
	local dominant_god = get_journey_cycle.journey_data[selected_mission_id].dominant_god
	local var_10_15 = DeusThemeSettings[dominant_god]

	expedition_icon.content.theme_icon = var_10_15.icon
	expedition_icon.content.level_icon = var_10_12.level_image
	expedition_icon.content.locked = not _gather_unlocked_journeys[selected_mission_id]
	_lobby_info_box_deus_widgets_by_name.level_name.content.text = Localize(display_name)
	_lobby_info_box_lobbies_deus_widgets_by_name.info_frame_level_name_text.content.text = Localize(display_name)

	local info_frame_difficulty_title = _lobby_info_box_lobbies_deus_widgets_by_name.info_frame_difficulty_title
	local info_frame_difficulty_text = _lobby_info_box_lobbies_deus_widgets_by_name.info_frame_difficulty_text
	local str_2 = "lb_difficulty_unknown"
	local difficulty = arg_10_1.difficulty

	if not difficulty then
		str_2 = DifficultySettings[difficulty].display_name
	end

	_lobby_info_box_lobbies_deus_widgets_by_name.info_frame_difficulty_text.content.text = Localize(str_2)

	local str_3 = "n/a"
	local num_players = arg_10_1.num_players

	if not num_players then
		str_3 = string.format("%s/%s", num_players, tostring(MatchmakingSettings.MAX_NUMBER_OF_PLAYERS))
	end

	_lobby_info_box_lobbies_deus_widgets_by_name.info_frame_players_text.content.text = str_3

	local lobby_status_text = LobbyItemsList.lobby_status_text(arg_10_1)

	_lobby_info_box_lobbies_deus_widgets_by_name.info_frame_status_text.content.text = lobby_status_text

	local var_10_23 = to_boolean(arg_10_1.twitch_enabled)

	_lobby_info_box_lobbies_deus_widgets_by_name.info_frame_twitch_logo.content.visible = var_10_23

	local server_name = arg_10_1.server_name

	if not server_name then
		server_name = arg_10_1.unique_server_name

		if not server_name then
			server_name = arg_10_1.name
			server_name = server_name or arg_10_1.host
		end
	end

	_lobby_info_box_lobbies_deus_widgets_by_name.info_frame_host_text.content.text = server_name or Localize("lb_unknown")
	self._show_widget_type = "deus"
end

StartGameWindowLobbyBrowser._assign_objective = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local var_11_0 = self._lobby_info_box_weaves_widgets_by_name["objective_" .. arg_11_1]
	local content = var_11_0.content
	local style = var_11_0.style

	content.icon = arg_11_3 or "trial_gem"
	content.text = arg_11_2 or "-"
end

StartGameWindowLobbyBrowser._setup_lobby_info_box = function (self, arg_12_1)
	-- function 12
	local str = "lb_unknown"
	local mechanism = arg_12_1.mechanism
	local matchmaking_type = arg_12_1.matchmaking_type
	local selected_mission_id = arg_12_1.selected_mission_id
	local str_2 = ""

	if not matchmaking_type then
		local var_12_5 = table.clone(NetworkLookup.matchmaking_types, true)[tonumber(matchmaking_type)]

		str = tbl[var_12_5] or str
	end

	local tbl_2 = {}
	local count = #SPProfiles

	for i = 1, count do
		if not ProfileSynchronizer.is_free_in_lobby(i, arg_12_1) then
			tbl_2[i] = true
		end
	end

	local content = self._lobby_info_box_base_widgets_by_name.hero_tabs.content

	for j = 1, #ProfilePriority do
		local var_12_9 = ProfilePriority[j]
		local str_3 = "_" .. tostring(j)
		local var_12_11 = content["hotspot" .. str_3]

		if not tbl_2[var_12_9] then
			var_12_11.disable_button = true
		else
			var_12_11.disable_button = false
		end
	end

	if mechanism == "weave" then
		self:_handle_weave_data(arg_12_1)
	elseif mechanism ~= "deus" or not DeusJourneySettings[selected_mission_id] then
		self:_handle_deus_data(arg_12_1)
	else
		self:_handle_lobby_data(str, arg_12_1)
	end
end

StartGameWindowLobbyBrowser._update_animations = function (self, arg_13_1)
	-- function 13
	self.ui_animator:update(arg_13_1)

	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_13_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end
end

StartGameWindowLobbyBrowser._is_refreshing = function (self)
	-- function 14
	local _current_lobby_type = self._current_lobby_type

	if _current_lobby_type == "lobbies" then
		return self.lobby_finder:is_refreshing()
	elseif _current_lobby_type == "servers" then
		return self.game_server_finder:is_refreshing()
	else
		ferror("Unknown lobby types (%s)", _current_lobby_type)
	end
end

StartGameWindowLobbyBrowser._handle_input = function (self, arg_15_1, arg_15_2)
	-- function 15
	local _lobbies_widgets_by_name = self._lobbies_widgets_by_name

	self:_handle_stepper_input("game_type_stepper", _lobbies_widgets_by_name.game_type_stepper, callback(self, "_on_game_type_stepper_input"))
	self:_handle_stepper_input("level_stepper", _lobbies_widgets_by_name.level_stepper, callback(self, "_on_level_stepper_input"))
	self:_handle_stepper_input("difficulty_stepper", _lobbies_widgets_by_name.difficulty_stepper, callback(self, "_on_difficulty_stepper_input"))
	self:_handle_stepper_input("show_lobbies_stepper", _lobbies_widgets_by_name.show_lobbies_stepper, callback(self, "_on_show_lobbies_stepper_input"))
	self:_handle_stepper_input("distance_stepper", _lobbies_widgets_by_name.distance_stepper, callback(self, "_on_distance_stepper_input"))

	local _server_widgets_by_name = self._server_widgets_by_name

	self:_handle_stepper_input("search_type_stepper", _server_widgets_by_name.search_type_stepper, callback(self, "_on_search_type_stepper_input"))
	self:_handle_name_input_box(arg_15_1, arg_15_2)
	self:_handle_selected_lobby_input()
end

StartGameWindowLobbyBrowser._handle_name_input_box = function (self, arg_16_1, arg_16_2)
	-- function 16
	local window_input_service = self.parent:window_input_service()
	local content = self._server_widgets_by_name.name_input_box.content

	if not content.on_release then
		content.active = true
	elseif not window_input_service:get("left_release") then
		content.active = false
	end

	local input = content.input

	if input ~= self._current_server_name then
		self._current_server_name = input

		self:_populate_lobby_list()
	end
end

StartGameWindowLobbyBrowser._handle_selected_lobby_input = function (self)
	-- function 17
	local selected_lobby = self.lobby_list:selected_lobby()

	if not selected_lobby then
		return
	end

	if self._current_lobby_type ~= "servers" or not self._lobby_info_box_servers_widgets_by_name.add_to_favorites_button.content.button_hotspot.on_release then
		if not selected_lobby.server_info.favorite then
			self:_remove_server_from_favorites(selected_lobby)
		else
			self:_add_server_to_favorites(selected_lobby)
		end
	end
end

StartGameWindowLobbyBrowser._add_server_to_favorites = function (self, arg_18_1)
	-- function 18
	local server_info = arg_18_1.server_info
	local ip_address = server_info.ip_address
	local connection_port = server_info.connection_port
	local query_port = server_info.query_port

	self.game_server_finder:add_to_favorites(ip_address, connection_port, query_port)
end

StartGameWindowLobbyBrowser._remove_server_from_favorites = function (self, arg_19_1)
	-- function 19
	local server_info = arg_19_1.server_info
	local ip_address = server_info.ip_address
	local connection_port = server_info.connection_port
	local query_port = server_info.query_port

	self.game_server_finder:remove_from_favorites(ip_address, connection_port, query_port)
end

StartGameWindowLobbyBrowser.draw = function (self, arg_20_1)
	-- function 20
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_20_1, nil, self.render_settings)

	local flag = self.lobby_list_update_timer ~= nil
	local join_lobby_data_id = self.join_lobby_data_id

	self._base_widgets_by_name.search_button.content.button_hotspot.disable_button = join_lobby_data_id or flag

	local _base_widgets = self._base_widgets

	for i = 1, #_base_widgets do
		local var_20_6 = _base_widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_20_6)
	end

	local _current_lobby_type = self._current_lobby_type

	if not self.lobby_list:selected_lobby() then
		if self._show_widget_type == "weave" then
			local _lobby_info_box_base_widgets = self._lobby_info_box_base_widgets

			for j = 1, #_lobby_info_box_base_widgets do
				local var_20_9 = _lobby_info_box_base_widgets[j]

				UIRenderer.draw_widget(ui_renderer, var_20_9)
			end

			local _lobby_info_box_weaves_widgets = self._lobby_info_box_weaves_widgets

			for k = 1, #_lobby_info_box_weaves_widgets do
				local var_20_11 = _lobby_info_box_weaves_widgets[k]

				UIRenderer.draw_widget(ui_renderer, var_20_11)
			end

			local _lobby_info_box_lobbies_weaves_widgets = self._lobby_info_box_lobbies_weaves_widgets

			for l = 1, #_lobby_info_box_lobbies_weaves_widgets do
				local var_20_13 = _lobby_info_box_lobbies_weaves_widgets[l]

				UIRenderer.draw_widget(ui_renderer, var_20_13)
			end
		elseif self._show_widget_type == "deus" then
			local _lobby_info_box_deus_widgets = self._lobby_info_box_deus_widgets

			for i4 = 1, #_lobby_info_box_deus_widgets do
				local var_20_15 = _lobby_info_box_deus_widgets[i4]

				UIRenderer.draw_widget(ui_renderer, var_20_15)
			end

			local _lobby_info_box_lobbies_deus_widgets = self._lobby_info_box_lobbies_deus_widgets

			for i5 = 1, #_lobby_info_box_lobbies_deus_widgets do
				local var_20_17 = _lobby_info_box_lobbies_deus_widgets[i5]

				UIRenderer.draw_widget(ui_renderer, var_20_17)
			end
		else
			local _lobby_info_box_base_widgets_2 = self._lobby_info_box_base_widgets

			for i6 = 1, #_lobby_info_box_base_widgets_2 do
				local var_20_19 = _lobby_info_box_base_widgets_2[i6]

				UIRenderer.draw_widget(ui_renderer, var_20_19)
			end

			if _current_lobby_type == "lobbies" then
				local _lobby_info_box_lobbies_widgets = self._lobby_info_box_lobbies_widgets

				for i7 = 1, #_lobby_info_box_lobbies_widgets do
					local var_20_21 = _lobby_info_box_lobbies_widgets[i7]

					UIRenderer.draw_widget(ui_renderer, var_20_21)
				end
			elseif _current_lobby_type == "servers" then
				local _lobby_info_box_servers_widgets = self._lobby_info_box_servers_widgets

				for i8 = 1, #_lobby_info_box_servers_widgets do
					local var_20_23 = _lobby_info_box_servers_widgets[i8]

					UIRenderer.draw_widget(ui_renderer, var_20_23)
				end
			end
		end
	end

	if _current_lobby_type == "lobbies" then
		local _lobbies_widgets = self._lobbies_widgets

		for i9 = 1, #_lobbies_widgets do
			local var_20_25 = _lobbies_widgets[i9]

			UIRenderer.draw_widget(ui_renderer, var_20_25)
		end
	elseif _current_lobby_type == "servers" then
		local _server_widgets = self._server_widgets

		for i10 = 1, #_server_widgets do
			local var_20_27 = _server_widgets[i10]

			UIRenderer.draw_widget(ui_renderer, var_20_27)
		end
	else
		ferror("Unknown lobby type (%s)", _current_lobby_type)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowLobbyBrowser._play_sound = function (self, arg_21_1)
	-- function 21
	self.parent:play_sound(arg_21_1)
end

StartGameWindowLobbyBrowser.cancel_join_lobby = function (self, arg_22_1)
	-- function 22
	self.join_lobby_data_id = nil
end

StartGameWindowLobbyBrowser._populate_lobby_list = function (self, arg_23_1)
	-- function 23
	local selected_lobby = self.lobby_list:selected_lobby()
	local _get_lobbies = self:_get_lobbies()
	local flag = true
	local flag_2

	flag_2 = self.selected_show_lobbies_index ~= 2 or not true or false

	local tbl = {}
	local num = 0

	for k, v in pairs(_get_lobbies) do
		if flag_2 or not self:_valid_lobby(v) then
			num = num + 1
			tbl[num] = v
		end
	end

	local flag_3 = false

	if not arg_23_1 and not flag_3 and not self.lobby_list_update_timer then
		self.lobby_list:animate_loading_text()
	end

	local TIME_BETWEEN_EACH_SEARCH

	if not flag_3 then
		TIME_BETWEEN_EACH_SEARCH = MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH

		if not TIME_BETWEEN_EACH_SEARCH then
			-- Nothing
		end
	end

	TIME_BETWEEN_EACH_SEARCH = nil

	::label_23_0::

	self.lobby_list_update_timer = TIME_BETWEEN_EACH_SEARCH

	self.lobby_list:populate_lobby_list(tbl, flag)

	if not selected_lobby then
		self.lobby_list:set_selected_lobby(selected_lobby)
	end
end

local tbl_3 = {}

StartGameWindowLobbyBrowser._get_lobbies = function (self)
	-- function 24
	local _current_lobby_type = self._current_lobby_type

	if _current_lobby_type == "lobbies" then
		local lobbies = self.lobby_finder:lobbies()

		lobbies = lobbies or tbl_3

		return lobbies
	elseif _current_lobby_type == "servers" then
		local servers = self.game_server_finder:servers()

		servers = servers or tbl_3

		return servers
	else
		ferror("Unknown lobby type (%s)", _current_lobby_type)
	end
end

StartGameWindowLobbyBrowser._valid_lobby = function (self, arg_25_1)
	-- function 25
	if not arg_25_1.valid then
		return false
	end

	local selected_mission_id = arg_25_1.selected_mission_id

	selected_mission_id = selected_mission_id or arg_25_1.mission_id

	local get_matchmaking_settings_for_mechanism = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_25_1.mechanism)
	local var_25_2 = tonumber(arg_25_1.num_players)

	if not (not selected_mission_id and var_25_2 ~= get_matchmaking_settings_for_mechanism.MAX_NUMBER_OF_PLAYERS) then
		return false
	end

	if not (arg_25_1.server_info ~= nil) then
		local _current_server_name = self._current_server_name

		if not (_current_server_name == "" or string.find(arg_25_1.server_info.name, _current_server_name) ~= nil) then
			return false
		end
	else
		local tbl = {}
		local statistics_db = self.statistics_db
		local _stats_id = self._stats_id
		local difficulty = arg_25_1.difficulty

		if not difficulty then
			local var_25_8 = DifficultySettings[difficulty]

			if not var_25_8.extra_requirement_name then
				local var_25_9 = ExtraDifficultyRequirements[var_25_8.extra_requirement_name]

				if not (Development.parameter("unlock_all_difficulties") or var_25_9.requirement_function()) then
					return false
				end
			end

			if not var_25_8.dlc_requirement then
				tbl[var_25_8.dlc_requirement] = true
			end
		end

		local flag = arg_25_1.weave_quick_game == "true"
		local mechanism = arg_25_1.mechanism
		local var_25_12 = MechanismSettings[mechanism]

		if not var_25_12 and not var_25_12.required_dlc then
			tbl[var_25_12.required_dlc] = true
		end

		for k, v in pairs(tbl) do
			if not Managers.unlock:is_dlc_unlocked(k) then
				return false
			end
		end

		if not (not var_25_12 and not var_25_12.extra_requirements_function and var_25_12.extra_requirements_function()) then
			return false
		end

		if mechanism == "weave" then
			local var_25_13 = selected_mission_id

			if not (var_25_13 == "false" or flag) then
				if not LevelUnlockUtils.weave_disabled(var_25_13) then
					return false, "weave_disabled"
				end

				local flag_2 = false
				local weave_unlocked = LevelUnlockUtils.weave_unlocked(statistics_db, _stats_id, var_25_13, flag_2)

				weave_unlocked = weave_unlocked or var_25_13 == self._current_weave

				if not weave_unlocked then
					return false
				end
			end
		else
			if not LevelUnlockUtils.level_unlocked(statistics_db, _stats_id, selected_mission_id) then
				return false
			end

			if not (MatchmakingManager.is_lobby_private(arg_25_1) or Managers.matchmaking:has_required_power_level(arg_25_1, self._profile_name, self._career_name)) then
				return false
			end
		end

		local matchmaking = arg_25_1.matchmaking

		matchmaking = not matchmaking and arg_25_1.matchmaking ~= "false"

		if not (not matchmaking and not difficulty and selected_mission_id ~= "n/a") then
			return false
		end
	end

	return true
end

StartGameWindowLobbyBrowser._update_auto_refresh = function (self, arg_26_1)
	-- function 26
	local lobby_list_update_timer = self.lobby_list_update_timer

	if not lobby_list_update_timer then
		local num = lobby_list_update_timer - arg_26_1

		if num < 0 then
			self:_populate_lobby_list(true)
		else
			self.lobby_list_update_timer = num
		end
	end
end

StartGameWindowLobbyBrowser._update_join_button = function (self, arg_27_1)
	-- function 27
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local join_button = self._base_widgets_by_name.join_button

	if not (not arg_27_1 and is_game_matchmaking) then
		if not self:_valid_lobby(arg_27_1) then
			join_button.content.button_hotspot.disable_button = false
		else
			join_button.content.button_hotspot.disable_button = true
		end
	else
		join_button.content.button_hotspot.disable_button = true
	end
end

StartGameWindowLobbyBrowser._reset_filters = function (self)
	-- function 28
	local _game_mode_data = self._game_mode_data
	local any = self._game_mode_data.game_modes.any

	self:_on_game_type_stepper_input(0, any)
	self:_on_show_lobbies_stepper_input(0, 1)
	self:_on_distance_stepper_input(0, 2)
end

StartGameWindowLobbyBrowser._reset_level_filter = function (self)
	-- function 29
	local count = #self:_get_levels()

	self:_on_level_stepper_input(0, count)
end

StartGameWindowLobbyBrowser._reset_difficulty_filter = function (self)
	-- function 30
	local count = #self:_get_difficulties()

	self:_on_difficulty_stepper_input(0, count)
end

StartGameWindowLobbyBrowser._switch_lobby_type = function (self, arg_31_1)
	-- function 31
	self._current_lobby_type = arg_31_1

	local content = self._base_widgets_by_name.lobby_type_button.content
	local var_31_1

	if arg_31_1 == "lobbies" then
		var_31_1 = Localize("lb_lobby_type_lobbies")

		if not var_31_1 then
			-- Nothing
		end
	end

	var_31_1 = Localize("lb_lobby_type_servers")

	::label_31_0::

	content.button_text = var_31_1

	if arg_31_1 == "lobbies" then
		-- Nothing
	elseif arg_31_1 == "servers" then
		self:_on_search_type_stepper_input(0, 1)
	else
		ferror("Unknown lobby type (%s)", arg_31_1)
	end

	self:_search()
end

StartGameWindowLobbyBrowser._create_filter_requirements = function (self)
	-- function 32
	local lobby_finder = self.lobby_finder
	local selected_game_mode_index = self.selected_game_mode_index
	local var_32_2 = self._game_mode_data.game_modes[selected_game_mode_index]

	var_32_2 = var_32_2 or "any"

	local selected_level_index = self.selected_level_index
	local var_32_4 = self:_get_levels()[selected_level_index]
	local selected_difficulty_index = self.selected_difficulty_index
	local var_32_6 = self:_get_difficulties()[selected_difficulty_index]
	local flag = not not script_data.show_invalid_lobbies or not self._base_widgets_by_name.invalid_checkbox.content.checked
	local selected_distance_index = self.selected_distance_index
	local var_32_9 = LobbyAux.map_lobby_distance_filter[selected_distance_index]
	local flag_2

	flag_2 = self.selected_show_lobbies_index ~= 2 or not true or false

	local flag_3 = not flag_2
	local num = 1
	local tbl = {
		filters = {},
		near_filters = {}
	}
	local _current_lobby_type = self._current_lobby_type

	if _current_lobby_type == "lobbies" then
		tbl.free_slots = num
		tbl.distance_filter = PLATFORM == "ps4" or var_32_9
	end

	if not IS_PS4 then
		local region = Managers.account:region()

		if var_32_9 == "close" then
			tbl.filters.primary_region = {
				comparison = "equal",
				value = MatchmakingRegionLookup.primary[region]
			}
		elseif var_32_9 == "medium" then
			tbl.filters.secondary_region = {
				comparison = "equal",
				value = MatchmakingRegionLookup.secondary[region]
			}
		end
	end

	local is_trusted = Managers.eac:is_trusted()
	local filters = tbl.filters
	local tbl_2 = {
		comparison = "equal"
	}
	local flag_4

	flag_4 = not is_trusted and "true" and "false"
	tbl_2.value = flag_4
	filters.eac_authorized = tbl_2

	if var_32_6 == "any" or not var_32_6 then
		tbl.filters.difficulty = {
			comparison = "equal",
			value = var_32_6
		}
	end

	if var_32_4 == "any" or not var_32_4 then
		tbl.filters.selected_mission_id = {
			comparison = "equal",
			value = var_32_4
		}
	end

	if var_32_2 ~= "any" then
		tbl.filters.mechanism = {
			comparison = "equal",
			value = var_32_2
		}
	end

	if not flag then
		tbl.filters.network_hash = {
			comparison = "equal",
			value = lobby_finder:network_hash()
		}
	end

	if not (not flag_3 and _current_lobby_type ~= "lobbies") then
		tbl.filters.matchmaking = {
			value = "false",
			comparison = "not_equal"
		}
	end

	return tbl
end

StartGameWindowLobbyBrowser._join = function (self, arg_33_1, arg_33_2)
	-- function 33
	Managers.matchmaking:request_join_lobby(arg_33_1, arg_33_2)

	self.join_lobby_data_id = arg_33_1.id
end

StartGameWindowLobbyBrowser._search = function (self)
	-- function 34
	local _create_filter_requirements = self:_create_filter_requirements()

	if self._current_lobby_type == "lobbies" then
		local lobby_finder = self.lobby_finder
		local get_lobby_browser = lobby_finder:get_lobby_browser()

		LobbyInternal.clear_filter_requirements(get_lobby_browser)

		local flag = true

		lobby_finder:add_filter_requirements(_create_filter_requirements, flag)
	elseif self._current_lobby_type == "servers" then
		local game_server_finder = self.game_server_finder
		local tbl = {
			server_browser_filters = {
				dedicated = "valuenotused",
				full = "valuenotused",
				gamedir = Managers.mechanism:server_universe()
			},
			matchmaking_filters = _create_filter_requirements.filters
		}
		local flag_2 = true

		game_server_finder:add_filter_requirements(tbl, flag_2)
		game_server_finder:refresh()
	else
		ferror("Unknown lobby type (%s)", self._current_lobby_type)
	end

	self._searching = true

	self:_populate_lobby_list()
end

StartGameWindowLobbyBrowser._get_levels = function (self)
	-- function 35
	local _game_mode_data = self._game_mode_data
	local game_modes = _game_mode_data.game_modes
	local selected_game_mode_index = self.selected_game_mode_index

	selected_game_mode_index = selected_game_mode_index or game_modes.any

	local var_35_3 = _game_mode_data[selected_game_mode_index]
	local levels

	if not var_35_3 then
		levels = var_35_3.levels

		if not levels then
			-- Nothing
		end
	end

	levels = {
		"any"
	}

	::label_35_0::

	return levels
end

StartGameWindowLobbyBrowser._get_difficulties = function (self)
	-- function 36
	local _game_mode_data = self._game_mode_data
	local game_modes = _game_mode_data.game_modes
	local selected_game_mode_index = self.selected_game_mode_index

	selected_game_mode_index = selected_game_mode_index or game_modes.any

	local var_36_3 = _game_mode_data[selected_game_mode_index]
	local difficulties

	if not var_36_3 then
		difficulties = var_36_3.difficulties

		if not difficulties then
			-- Nothing
		end
	end

	difficulties = {
		"any"
	}

	::label_36_0::

	return difficulties
end

StartGameWindowLobbyBrowser._on_game_type_stepper_input = function (self, arg_37_1, arg_37_2)
	-- function 37
	local game_type_stepper = self._lobbies_widgets_by_name.game_type_stepper
	local game_modes = self._game_mode_data.game_modes
	local selected_game_mode_index = self.selected_game_mode_index

	selected_game_mode_index = selected_game_mode_index or game_modes.any

	local _on_stepper_input = self:_on_stepper_input(game_type_stepper, game_modes, selected_game_mode_index, arg_37_1, arg_37_2)
	local str = "lobby_browser_mission"
	local var_37_5 = game_modes[_on_stepper_input]
	local content = game_type_stepper.content
	local Localize = Localize
	local var_37_8 = tbl_2[var_37_5]

	var_37_8 = var_37_8 or ""
	content.setting_text = Localize(var_37_8)
	self.selected_game_mode_index = _on_stepper_input
	self.search_timer = num
	self.selected_level_index = 1
	self.selected_difficulty_index = 1

	local selected_level_index = self.selected_level_index
	local _get_levels = self:_get_levels()
	local var_37_11 = _get_levels[selected_level_index]
	local content_2 = self._lobbies_widgets_by_name.level_banner_widget.content
	local content_3 = self._lobbies_widgets_by_name.level_stepper.content

	if not (not var_37_11 and #_get_levels ~= 1) then
		content_2.disabled = true
		content_3.button_hotspot_left.disable_button = true
		content_3.button_hotspot_right.disable_button = true
	else
		content_2.disabled = false
		content_3.button_hotspot_left.disable_button = false
		content_3.button_hotspot_right.disable_button = false
	end

	local selected_difficulty_index = self.selected_difficulty_index
	local var_37_15 = self:_get_difficulties()[selected_difficulty_index]
	local content_4 = self._lobbies_widgets_by_name.difficulty_banner_widget.content
	local content_5 = self._lobbies_widgets_by_name.difficulty_stepper.content

	if not (not var_37_15 and #_get_levels ~= 1) then
		content_4.disabled = true
		content_5.button_hotspot_left.disable_button = true
		content_5.button_hotspot_right.disable_button = true
	else
		content_4.disabled = false
		content_5.button_hotspot_left.disable_button = false
		content_5.button_hotspot_right.disable_button = false
	end

	self:_reset_level_filter()
	self:_reset_difficulty_filter()
end

StartGameWindowLobbyBrowser._on_level_stepper_input = function (self, arg_38_1, arg_38_2)
	-- function 38
	local level_stepper = self._lobbies_widgets_by_name.level_stepper
	local _get_levels = self:_get_levels()
	local selected_level_index = self.selected_level_index

	selected_level_index = selected_level_index or 1

	local _on_stepper_input = self:_on_stepper_input(level_stepper, _get_levels, selected_level_index, arg_38_1, arg_38_2)
	local str = "lobby_browser_mission"
	local var_38_5 = _get_levels[_on_stepper_input]

	if var_38_5 ~= "any" then
		str = LevelSettings[var_38_5].display_name
	end

	level_stepper.content.setting_text = Localize(str)
	self.selected_level_index = _on_stepper_input
	self.search_timer = num
end

StartGameWindowLobbyBrowser._on_difficulty_stepper_input = function (self, arg_39_1, arg_39_2)
	-- function 39
	local difficulty_stepper = self._lobbies_widgets_by_name.difficulty_stepper
	local _get_difficulties = self:_get_difficulties()
	local selected_difficulty_index = self.selected_difficulty_index

	selected_difficulty_index = selected_difficulty_index or 1

	local _on_stepper_input = self:_on_stepper_input(difficulty_stepper, _get_difficulties, selected_difficulty_index, arg_39_1, arg_39_2)
	local str = "lobby_browser_difficulty"
	local var_39_5 = _get_difficulties[_on_stepper_input]

	if var_39_5 ~= "any" then
		str = DifficultySettings[var_39_5].display_name
	end

	difficulty_stepper.content.setting_text = Localize(str)
	self.selected_difficulty_index = _on_stepper_input
	self.search_timer = num
end

StartGameWindowLobbyBrowser._on_show_lobbies_stepper_input = function (self, arg_40_1, arg_40_2)
	-- function 40
	local show_lobbies_stepper = self._lobbies_widgets_by_name.show_lobbies_stepper
	local show_lobbies_table = var_0_0.show_lobbies_table
	local selected_show_lobbies_index = self.selected_show_lobbies_index

	selected_show_lobbies_index = selected_show_lobbies_index or 1

	local _on_stepper_input = self:_on_stepper_input(show_lobbies_stepper, show_lobbies_table, selected_show_lobbies_index, arg_40_1, arg_40_2)
	local var_40_4 = show_lobbies_table[_on_stepper_input]

	show_lobbies_stepper.content.setting_text = Localize(var_40_4)
	self.selected_show_lobbies_index = _on_stepper_input
	self.search_timer = num
end

StartGameWindowLobbyBrowser._on_distance_stepper_input = function (self, arg_41_1, arg_41_2)
	-- function 41
	local distance_stepper = self._lobbies_widgets_by_name.distance_stepper
	local distance_table = var_0_0.distance_table
	local selected_distance_index = self.selected_distance_index

	selected_distance_index = selected_distance_index or 1

	local _on_stepper_input = self:_on_stepper_input(distance_stepper, distance_table, selected_distance_index, arg_41_1, arg_41_2)
	local var_41_4 = distance_table[_on_stepper_input]

	distance_stepper.content.setting_text = Localize(var_41_4)
	self.selected_distance_index = _on_stepper_input
	self.search_timer = num
end

StartGameWindowLobbyBrowser._on_search_type_stepper_input = function (self, arg_42_1, arg_42_2)
	-- function 42
	local search_type_stepper = self._server_widgets_by_name.search_type_stepper
	local search_type_text_table = var_0_0.search_type_text_table
	local selected_search_type_index = self.selected_search_type_index

	selected_search_type_index = selected_search_type_index or 1

	local _on_stepper_input = self:_on_stepper_input(search_type_stepper, search_type_text_table, selected_search_type_index, arg_42_1, arg_42_2)
	local var_42_4 = search_type_text_table[_on_stepper_input]

	search_type_stepper.content.setting_text = Localize(var_42_4)
	self.selected_search_type_index = _on_stepper_input
	self.search_timer = num

	local var_42_5 = var_0_0.search_type_table[_on_stepper_input]

	self.game_server_finder:set_search_type(var_42_5)
end

StartGameWindowLobbyBrowser._on_stepper_input = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	-- function 43
	local count = #arg_43_2

	if not arg_43_5 then
		fassert(not (arg_43_5 > 0) or arg_43_5 <= count, "stepper_index out of range")

		return arg_43_5
	end

	local num = arg_43_3 + arg_43_4

	if num < 1 then
		num = count
	elseif count < num then
		num = 1
	end

	return num
end

StartGameWindowLobbyBrowser._handle_stepper_input = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local var_44_0 = arg_44_2
	local content = var_44_0.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if not button_hotspot_left.on_hover_enter then
		self:_on_stepper_arrow_hover(var_44_0, arg_44_1, "left_button_icon_clicked")
	elseif not button_hotspot_right.on_hover_enter then
		self:_on_stepper_arrow_hover(var_44_0, arg_44_1, "right_button_icon_clicked")
	end

	if not button_hotspot_left.on_hover_exit then
		self:_on_stepper_arrow_dehover(var_44_0, arg_44_1, "left_button_icon_clicked")
	elseif not button_hotspot_right.on_hover_exit then
		self:_on_stepper_arrow_dehover(var_44_0, arg_44_1, "right_button_icon_clicked")
	end

	if button_hotspot_left.on_hover_enter or not button_hotspot_right.on_hover_enter then
		self:_play_sound("Play_hud_hover")
	end

	if not button_hotspot_left.on_release then
		button_hotspot_left.on_release = nil

		arg_44_3(-1)
		self:_play_sound("Play_hud_select")
		self:_on_stepper_arrow_pressed(var_44_0, arg_44_1, "left_button_icon")
		self:_on_stepper_arrow_pressed(var_44_0, arg_44_1, "left_button_icon_clicked")
	elseif not button_hotspot_right.on_release then
		button_hotspot_right.on_release = nil

		arg_44_3(1)
		self:_play_sound("Play_hud_select")
		self:_on_stepper_arrow_pressed(var_44_0, arg_44_1, "right_button_icon")
		self:_on_stepper_arrow_pressed(var_44_0, arg_44_1, "right_button_icon_clicked")
	end
end

StartGameWindowLobbyBrowser._on_stepper_arrow_pressed = function (self, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	local _ui_animations = self._ui_animations
	local str = "stepper_widget_arrow_" .. arg_45_2 .. arg_45_3
	local var_45_2 = arg_45_1.style[arg_45_3]
	local tbl = {
		28,
		34
	}
	local var_45_4 = var_45_2.color[1]
	local num = 255
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration

	if topic_hover_duration > 0 then
		_ui_animations[str .. "_hover"] = self:_animate_element_by_time(var_45_2.color, 1, var_45_4, num, topic_hover_duration)
		_ui_animations[str .. "_selected_size_width"] = self:_animate_element_by_catmullrom(var_45_2.size, 1, tbl[1], 0.7, 1, 1, 0.7, topic_hover_duration)
		_ui_animations[str .. "_selected_size_height"] = self:_animate_element_by_catmullrom(var_45_2.size, 2, tbl[2], 0.7, 1, 1, 0.7, topic_hover_duration)
	else
		var_45_2.color[1] = num
	end
end

StartGameWindowLobbyBrowser._on_stepper_arrow_hover = function (self, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local _ui_animations = self._ui_animations
	local str = "stepper_widget_arrow_" .. arg_46_2 .. arg_46_3
	local var_46_2 = arg_46_1.style[arg_46_3]
	local var_46_3 = var_46_2.color[1]
	local num = 255
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration
	local num_2 = (1 - var_46_3 / num) * topic_hover_duration

	if num_2 > 0 then
		_ui_animations[str .. "_hover"] = self:_animate_element_by_time(var_46_2.color, 1, var_46_3, num, num_2)
	else
		var_46_2.color[1] = num
	end

	self:_play_sound("Play_hud_hover")
end

StartGameWindowLobbyBrowser._on_stepper_arrow_dehover = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	local _ui_animations = self._ui_animations
	local str = "stepper_widget_arrow_" .. arg_47_2 .. arg_47_3
	local var_47_2 = arg_47_1.style[arg_47_3]
	local var_47_3 = var_47_2.color[1]
	local num = 0
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration
	local num_2 = var_47_3 / 255 * topic_hover_duration

	if num_2 > 0 then
		_ui_animations[str .. "_hover"] = self:_animate_element_by_time(var_47_2.color, 1, var_47_3, num, num_2)
	else
		var_47_2.color[1] = num
	end
end

StartGameWindowLobbyBrowser._animate_element_by_time = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	-- function 48
	return (UIAnimation.init(UIAnimation.function_by_time, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5, math.ease_out_quad))
end

StartGameWindowLobbyBrowser._animate_element_by_catmullrom = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6, arg_49_7, arg_49_8)
	-- function 49
	return (UIAnimation.init(UIAnimation.catmullrom, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6, arg_49_7, arg_49_8))
end
