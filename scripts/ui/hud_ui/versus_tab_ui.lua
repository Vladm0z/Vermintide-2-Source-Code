-- chunkname: @scripts/ui/hud_ui/versus_tab_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/versus_tab_ui_definitions")
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local create_empty_frame_widget = var_0_0.create_empty_frame_widget
local console_cursor_definition = var_0_0.console_cursor_definition
local custom_game_settings_widgets = var_0_0.custom_game_settings_widgets
local num = 2
local num_2 = 4
local flag = false
local tbl = {}
local tbl_2 = {
	"slot_melee",
	"slot_ranged"
}

VersusTabUI = class(VersusTabUI)

VersusTabUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ui_top_renderer = arg_1_2.ui_top_renderer
	self._input_manager = arg_1_2.input_manager
	self._voip = arg_1_2.voip

	local player = arg_1_2.player

	self._player = player
	self._peer_id = player:network_id()
	self._local_player_id = player:local_player_id()
	self._context = arg_1_2

	local world = arg_1_2.world_manager:world("level_world")

	self._wwise_world = Managers.world:wwise_world(world)

	local _input_manager = self._input_manager

	_input_manager:create_input_service("player_list_input", "IngamePlayerListKeymaps", "IngamePlayerListFilters")
	_input_manager:map_device_to_service("player_list_input", "keyboard")
	_input_manager:map_device_to_service("player_list_input", "mouse")
	_input_manager:map_device_to_service("player_list_input", "gamepad")

	self._animations = {}
	self._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._selected_objective_index = 0
	self._selected_sub_objective_index = 0

	self:_create_ui_elements()

	self._objective_system = Managers.state.entity:system("objective_system")
	self._objectives_initialized = false
	self._win_conditions = Managers.mechanism:game_mechanism():win_conditions()

	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local var_1_4 = LevelSettings[get_current_level_keys]
	local var_1_5 = Localize(var_1_4.display_name)

	self:_set_level_name(var_1_5)
	self:_register_events()

	local flag

	flag = Managers.state.game_mode:game_mode():game_mode_state() ~= "match_running_state" or not true or nil

	if not flag then
		self:_on_round_started()
	end

	self._round_has_started = flag

	local mechanism_try_call, var_1_8, var_1_9 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "round_time_limit")

	if not var_1_9 and not var_1_8 then
		self._custom_round_timer_active = true
	end
end

VersusTabUI._create_ui_elements = function (self)
	-- function 2
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local widget_definitions = var_0_0.widget_definitions

	for k, v in pairs(widget_definitions) do
		local var_2_3 = UIWidget.init(v)

		tbl_2[k] = var_2_3
		tbl[#tbl + 1] = var_2_3
	end

	self._item_tooltip = UIWidget.init(var_0_0.item_tooltip)
	self._console_cursor = UIWidget.init(console_cursor_definition)
	self._widgets_by_name = tbl_2
	self._widgets = tbl
	flag = false

	self:_create_player_slots()

	self._custom_game_settings_widgets, self._custom_game_settings_widgets_by_name = {}, {}

	UIUtils.create_widgets(custom_game_settings_widgets, self._custom_game_settings_widgets, self._custom_game_settings_widgets_by_name)

	local custom_settings_enabled = Managers.mechanism:game_mechanism():custom_settings_enabled()

	if not custom_settings_enabled then
		self:_setup_custom_settings()
	end

	self._custom_settings_enabled = custom_settings_enabled
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

VersusTabUI.destroy = function (self)
	-- function 3
	self._ui_animator = nil

	self:_unregister_events()
end

VersusTabUI.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		self:_create_ui_elements()
	end

	self:_handle_input(arg_4_1, arg_4_2)

	if not self._active then
		local mechanism = Managers.mechanism
		local _get_current_set = self:_get_current_set()
		local get_current_level_key = Managers.level_transition_handler:get_current_level_key()
		local num_sets = VersusObjectiveSettings[get_current_level_key].num_sets

		if _get_current_set ~= self._round_id then
			self._round_id = _get_current_set

			local var_4_4 = Localize("versus_round_count")

			self:_set_sub_title(string.format(var_4_4, _get_current_set, num_sets))
		end

		local party = Managers.party
		local get_party_from_player_id, var_4_7 = party:get_party_from_player_id(self._peer_id, self._local_player_id)
		local _get_opponent_party_id = self:_get_opponent_party_id()

		self:_set_team_name(var_4_7, _get_opponent_party_id)
		self:_set_team_textures(var_4_7, _get_opponent_party_id)
		self:_set_side_text(party, var_4_7, _get_opponent_party_id)

		if not self._party_id then
			self._party_id = var_4_7
			self._opponent_party_id = _get_opponent_party_id
		end

		self:_update_round_start_timer(arg_4_1, arg_4_2)
		self:_update_objectives(arg_4_1, arg_4_2)
		self:_update_score(var_4_7, _get_opponent_party_id)
		self:_update_animations(arg_4_1, arg_4_2)
		self:_update_custom_lobby_slots()
		self:_draw(arg_4_1, arg_4_2)
	end
end

VersusTabUI._update_animations = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_5_1)

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

VersusTabUI._draw = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_manager = self._input_manager
	local get_service = _input_manager:get_service("player_list_input")
	local _render_settings = self._render_settings
	local is_device_active = _input_manager:is_device_active("gamepad")
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 1

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_6_1, nil, _render_settings)

	local _widgets = self._widgets

	if not _widgets then
		for i = 1, #_widgets do
			local var_6_8 = _widgets[i]
			local alpha_multiplier_2 = var_6_8.alpha_multiplier

			alpha_multiplier_2 = alpha_multiplier_2 or alpha_multiplier
			_render_settings.alpha_multiplier = alpha_multiplier_2

			UIRenderer.draw_widget(_ui_top_renderer, var_6_8)
		end
	end

	_render_settings.alpha_multiplier = alpha_multiplier

	local _custom_game_slots = self._custom_game_slots

	if not _custom_game_slots then
		for j = 1, #_custom_game_slots do
			local var_6_11 = _custom_game_slots[j]

			for k = 1, #var_6_11 do
				local var_6_12 = var_6_11[k]
				local empty = var_6_12.empty
				local is_player = var_6_12.is_player
				local peer_id = var_6_12.peer_id
				local empty_widget = var_6_12.empty_widget

				if not empty_widget then
					UIRenderer.draw_widget(_ui_top_renderer, empty_widget)
				end

				if not empty then
					local panel_widget = var_6_12.panel_widget

					if not panel_widget then
						UIRenderer.draw_widget(_ui_top_renderer, panel_widget)
					end

					local portrait_widget = var_6_12.portrait_widget

					if not portrait_widget then
						UIRenderer.draw_widget(_ui_top_renderer, portrait_widget)
					end

					local insignia_widget = var_6_12.insignia_widget

					if not insignia_widget then
						UIRenderer.draw_widget(_ui_top_renderer, insignia_widget)
					end
				end
			end
		end
	end

	local content = self._widgets_by_name.objective_text.content
	local flag

	flag = not self._round_has_started and true and false
	content.visible = flag

	UIRenderer.draw_widget(_ui_top_renderer, self._item_tooltip)

	if not is_device_active then
		UIRenderer.draw_widget(_ui_top_renderer, self._console_cursor)
	end

	if not self._custom_settings_enabled and not self._custom_game_settings_widgets then
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._custom_game_settings_widgets)
	end

	if not self._custom_settings_enabled and not self._settings_widgets then
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._settings_widgets)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not self._scrollbar_ui then
		self._scrollbar_ui:update(arg_6_1, arg_6_2, _ui_top_renderer, get_service, _render_settings)
	end
end

VersusTabUI._set_team_name = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _get_teams_ui_settings, var_7_1 = self:_get_teams_ui_settings(arg_7_1, arg_7_2)

	self._widgets_by_name.team_1_name.content.text = Localize(_get_teams_ui_settings.display_name)
	self._widgets_by_name.team_2_name.content.text = Localize(var_7_1.display_name)
end

VersusTabUI._set_team_textures = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _get_teams_ui_settings, var_8_1 = self:_get_teams_ui_settings(arg_8_1, arg_8_2)

	self._widgets_by_name.team_1_icon.content.texture_id = _get_teams_ui_settings.local_flag_texture
	self._widgets_by_name.team_2_icon.content.texture_id = var_8_1.opponent_flag_texture
end

VersusTabUI._set_side_text = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local carousel = DLCSettings.carousel
	local get_party = arg_9_1:get_party(arg_9_2)

	if not get_party then
		local name = Managers.state.side.side_by_party[get_party]:name()
		local team_1_side_text = self._widgets_by_name.team_1_side_text
		local var_9_4 = carousel.sides_localization_lookup[name]

		team_1_side_text.content.text = Localize(var_9_4)
	end

	local get_party_2 = arg_9_1:get_party(arg_9_3)

	if not get_party_2 then
		local name_2 = Managers.state.side.side_by_party[get_party_2]:name()
		local team_2_side_text = self._widgets_by_name.team_2_side_text
		local var_9_8 = carousel.sides_localization_lookup[name_2]

		team_2_side_text.content.text = Localize(var_9_8)
	end
end

VersusTabUI._update_score = function (self, arg_10_1, arg_10_2)
	-- function 10
	local get_total_score = self._win_conditions:get_total_score(arg_10_1)
	local get_total_score_2 = self._win_conditions:get_total_score(arg_10_2)
	local get_party = Managers.party:get_party(arg_10_1)
	local name = Managers.state.side.side_by_party[get_party]:name()
	local content = self._widgets_by_name.score.content

	content.is_hero = name == "heroes"
	content.team_1_score = get_total_score
	content.team_2_score = get_total_score_2
end

VersusTabUI._get_teams_ui_settings = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_11_1]
	local var_11_1 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_11_2]
	local carousel = DLCSettings.carousel
	local var_11_3 = carousel.teams_ui_assets[var_11_0]
	local var_11_4 = carousel.teams_ui_assets[var_11_1]

	return var_11_3, var_11_4
end

VersusTabUI._set_level_name = function (arg_12_0, arg_12_1)
	-- function 12
	arg_12_0._widgets_by_name.level_name.content.text = arg_12_1
end

VersusTabUI._set_sub_title = function (arg_13_0, arg_13_1)
	-- function 13
	arg_13_0._widgets_by_name.sub_title.content.text = arg_13_1
end

VersusTabUI.input_service = function (self)
	-- function 14
	return self._input_manager:get_service("player_list_input")
end

VersusTabUI.is_focused = function (self)
	-- function 15
	local _active = self._active

	_active = not _active and self.cursor_active

	return _active
end

VersusTabUI.is_active = function (self)
	-- function 16
	return self._active
end

VersusTabUI.set_active = function (self, arg_17_1)
	-- function 17
	local chat_gui = Managers.chat.chat_gui

	if not arg_17_1 then
		local tbl = {
			render_settings = self._render_settings
		}

		self._ui_animator:start_animation("on_enter", self._widgets_by_name, scenegraph_definition, tbl)
		Managers.input:enable_gamepad_cursor()
		self:_create_player_slots()
	else
		chat_gui:hide_chat()
		Managers.input:disable_gamepad_cursor()
	end

	self._active = arg_17_1

	if not arg_17_1 then
		self._fade_in_duration = 0
	end

	self:_deactivate_cursor()
end

VersusTabUI._deactivate_cursor = function (self)
	-- function 18
	if not self.cursor_active then
		ShowCursorStack.hide("VersusSlotStatusUI")

		local _input_manager = self._input_manager

		_input_manager:device_unblock_all_services("keyboard")
		_input_manager:device_unblock_all_services("mouse")
		_input_manager:device_unblock_all_services("gamepad")

		self.cursor_active = false
		self._widgets_by_name.input_description_text.content.visible = true
	end
end

VersusTabUI._activate_cursor = function (self)
	-- function 19
	if not self.cursor_active then
		ShowCursorStack.show("VersusSlotStatusUI")

		local _input_manager = self._input_manager

		_input_manager:block_device_except_service("player_list_input", "keyboard")
		_input_manager:block_device_except_service("player_list_input", "mouse")
		_input_manager:block_device_except_service("player_list_input", "gamepad")

		self.cursor_active = true
		self._widgets_by_name.input_description_text.content.visible = false
	end
end

VersusTabUI._handle_input = function (self, arg_20_1)
	-- function 20
	local _input_manager = self._input_manager
	local in_fade_active = Managers.transition:in_fade_active()
	local get_service = _input_manager:get_service("player_list_input")

	if (in_fade_active or get_service:get("ingame_player_list_exit") or get_service:get("ingame_player_list_toggle") or not get_service:get("back") or not self._active) and not self.cursor_active then
		self:set_active(false)
	elseif not self.cursor_active then
		if in_fade_active or not get_service:get("ingame_player_list_toggle") then
			if not self._active then
				self:set_active(true)

				if not self.cursor_active then
					self:_activate_cursor()
				end
			end
		elseif not get_service:get("ingame_player_list_pressed") then
			if not self._active then
				self:set_active(true)
			end
		elseif not (not self._active and get_service:get("ingame_player_list_held")) then
			self:set_active(false)
		end
	end

	if not self._active and not get_service:get("activate_ingame_player_list") then
		self:_activate_cursor()
	end
end

VersusTabUI._create_player_slots = function (self)
	-- function 21
	local _ui_scenegraph = self._ui_scenegraph
	local num_3 = 1
	local tbl = {}

	for i = 1, num do
		local tbl_2 = {}

		tbl[i] = tbl_2

		for j = 1, num_2 do
			local tbl_3 = {}

			tbl_2[j] = tbl_3

			local str = "team_" .. i .. "_player_panel_" .. j
			local str_2 = "talent_tooltip"

			if not _ui_scenegraph[str] then
				local size = _ui_scenegraph[str].size
				local create_player_panel = UIWidgets.create_player_panel(str, str_2, num_3, size)
				local var_21_9 = UIWidget.init(create_player_panel)
				local get_color_table_with_alpha

				if i == 1 then
					get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

					if not get_color_table_with_alpha then
						-- Nothing
					end
				end

				get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

				::label_21_0::

				self:_apply_color_values(var_21_9.style.background.color, get_color_table_with_alpha)

				local var_21_11 = create_empty_frame_widget(str)

				tbl_3.empty_widget, tbl_3.panel_widget = UIWidget.init(var_21_11), var_21_9
				num_3 = num_3 + 1
			end
		end
	end

	self._custom_game_slots = tbl
end

VersusTabUI._setup_custom_settings = function (self)
	-- function 22
	local get_custom_game_settings_handler = Managers.mechanism:game_mechanism():get_custom_game_settings_handler()
	local flag, get_settings = not get_custom_game_settings_handler and get_custom_game_settings_handler:get_settings_template(), get_custom_game_settings_handler:get_settings()
	local custom_game_ui_settings = DLCSettings.carousel.custom_game_ui_settings
	local tbl = {}
	local tbl_2 = {}
	local num = 34

	for i, v in ipairs(get_settings) do
		local var_22_7 = flag[i]
		local setting_name = var_22_7.setting_name
		local values = var_22_7.values
		local var_22_10 = custom_game_ui_settings[setting_name]
		local var_22_11 = var_22_7.values_reverse_lookup[v]
		local default = var_22_7.default
		local var_22_13 = var_22_7.values_reverse_lookup[default]
		local create_settings_widget = var_0_0.create_settings_widget("settings_anchor", var_22_7, var_22_10, v, var_22_11, i)
		local var_22_15 = UIWidget.init(create_settings_widget)

		var_22_15.offset = {
			20,
			-num * i,
			1
		}
		var_22_15.content.default_value = default
		var_22_15.content.default_idx = var_22_13
		tbl[#tbl + 1] = var_22_15
		tbl_2[setting_name] = var_22_15
	end

	self._settings_widgets = tbl
	self._settings_widgets_by_name = tbl_2

	local count = #get_settings

	self:_setup_custom_settings_scrollbar(count, num)

	self._num_settings = count
	self._settings = get_settings
end

VersusTabUI._update_custom_lobby_slots = function (self)
	-- function 23
	local party = Managers.party
	local player = Managers.player
	local _pre_game_logic = self._pre_game_logic
	local human_and_bot_players = player:human_and_bot_players()
	local _custom_game_slots = self._custom_game_slots

	if not _custom_game_slots then
		return
	end

	self._item_tooltip.content.item = nil

	local var_23_5 = _custom_game_slots[1]

	self:_update_party_slots_data(self._party_id, var_23_5, 1, party, player, _pre_game_logic, human_and_bot_players)

	local var_23_6 = _custom_game_slots[2]
	local _get_opponent_party_id = self:_get_opponent_party_id()

	self:_update_party_slots_data(_get_opponent_party_id, var_23_6, 2, party, player, _pre_game_logic, human_and_bot_players)
	self:_update_players_panel_button_widgets()
	self:_handle_players_panel_button_input()
end

VersusTabUI._update_party_slots_data = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7)
	-- function 24
	local get_party = arg_24_4:get_party(arg_24_1)
	local game = Managers.state.network:game()
	local get_match_handler = Managers.mechanism:network_handler():get_match_handler()

	if not get_party then
		local var_24_3 = Managers.state.side.side_by_party[get_party]
		local flag = not var_24_3 and var_24_3:name() == "dark_pact"
		local slots = get_party.slots

		for i = 1, #arg_24_2 do
			local var_24_6 = arg_24_2[i]
			local var_24_7 = slots[i]
			local flag_2 = false
			local flag_3 = false
			local panel_widget = var_24_6.panel_widget
			local content = panel_widget.content
			local style = panel_widget.style
			local content_2 = var_24_6.empty_widget.content

			if var_24_6.unique_id ~= var_24_7.unique_id then
				var_24_6.unique_id = var_24_7.unique_id
				flag_2 = true
			end

			local peer_id = var_24_7.peer_id
			local local_player_id = var_24_7.local_player_id
			local var_24_16
			local flag_4 = false
			local flag_5 = false
			local flag_6 = self._party_id == var_24_7.party_id
			local var_24_20
			local var_24_21

			if not peer_id and not local_player_id then
				var_24_20 = var_24_7.profile_index
				var_24_21 = var_24_7.career_index
				var_24_16 = var_24_7.player
				flag_4 = var_24_7.is_player
				flag_3 = true
			end

			if var_24_6.ready ~= flag_5 then
				var_24_6.ready = flag_5
				content.ready = flag_5
			end

			local flag_7 = false

			if var_24_6.profile_index ~= var_24_20 or var_24_6.career_index ~= var_24_21 or not flag_2 then
				var_24_6.profile_index = var_24_20
				var_24_6.career_index = var_24_21
				flag_7 = true
			end

			local var_24_23
			local var_24_24
			local var_24_25
			local var_24_26
			local flag_8 = false
			local flag_9 = true
			local flag_10 = not var_24_16 and var_24_16:unique_id()
			local flag_11 = not var_24_16 and arg_24_7[flag_10]

			if not flag_11 then
				if not flag_7 then
					local is_player_controlled = var_24_16:is_player_controlled()
					local get_cosmetic_slot = CosmeticUtils.get_cosmetic_slot(var_24_16, "slot_frame")
					local item_name

					if not get_cosmetic_slot then
						item_name = get_cosmetic_slot.item_name

						if not item_name then
							-- Nothing
						end
					end

					item_name = "default"

					::label_24_0::

					if not var_24_16 then
						-- Nothing
					end

					do
						local query_peer_data
					end

					::label_24_1::

					if not is_player_controlled then
						query_peer_data = get_match_handler:query_peer_data(peer_id, "versus_level", true)

						if not query_peer_data then
							-- Nothing
						end
					end

					query_peer_data = UISettings.bots_level_display_text

					::label_24_2::

					local _get_hero_portrait = self:_get_hero_portrait(var_24_20, var_24_21)
					local str = "team_" .. arg_24_3 .. "_player_frame_" .. i

					var_24_6.portrait_widget = self:_create_portrait_frame(str, item_name, query_peer_data, _get_hero_portrait)

					if not is_player_controlled then
						local str_2 = "team_" .. arg_24_3 .. "_player_insignia_" .. i
						local get_versus_player_level = ExperienceSettings.get_versus_player_level(var_24_16)

						get_versus_player_level = get_versus_player_level or 0

						local create_small_insignia = UIWidgets.create_small_insignia(str_2, get_versus_player_level)

						var_24_6.insignia_widget = UIWidget.init(create_small_insignia)
					end
				end

				flag_8 = var_24_16.local_player
				flag_9 = not var_24_16:is_player_controlled()

				local name = var_24_16:name()
				local career_name

				if not flag and not flag_6 then
					career_name = var_24_16:career_name()

					if not career_name then
						-- Nothing
					end
				end

				career_name = "vs_lobby_dark_pact_team_name"

				::label_24_3::

				content.show_host = peer_id ~= Managers.mechanism:network_handler().server_peer_id or not flag_9

				if var_24_6.player_name ~= name then
					var_24_6.player_name = name
					content.name = name
				end

				if not (not career_name and var_24_6.career_name == career_name) then
					var_24_6.career_name = career_name
					content.hero = career_name
				end

				local player_unit = var_24_16.player_unit

				if not ALIVE[player_unit] then
					if not flag then
						local var_24_43 = Managers.player:player_loadouts()[flag_10]

						if not var_24_43 then
							self:_update_player_item_slots(var_24_43, panel_widget)
						end

						self:_update_player_talents(player_unit, var_24_16, panel_widget)
					end

					var_24_23, var_24_24, var_24_25, var_24_26 = self:_update_player_health(player_unit, panel_widget)
				else
					var_24_26 = true
				end

				self:_update_player_status_portrait(var_24_6, var_24_20, var_24_21, flag, flag_6, var_24_23, var_24_24, var_24_25, var_24_26)

				if not flag and not content.respawning and not flag_6 then
					self:_update_player_respawn_counter(var_24_6)
				end

				self:_update_player_talents_tooltip(panel_widget)

				local game_object_id = var_24_16.game_object_id
				local game_object_field

				if not game_object_id then
					game_object_field = GameSession.game_object_field(game, game_object_id, "ping")

					if not game_object_field then
						-- Nothing
					end
				end

				game_object_field = math.huge

				::label_24_4::

				local _get_ping_texture_by_ping_value, var_24_47 = self:_get_ping_texture_by_ping_value(game_object_field)

				content.ping_texture = _get_ping_texture_by_ping_value
				content.ping_text = game_object_field

				local ping_text = panel_widget.style.ping_text

				ping_text.text_color = ping_text[var_24_47]
			end

			content.empty = not flag_3
			content_2.empty = not flag_3
			content.visible = flag_11
			content.is_local_player = not not flag or var_24_16 ~= nil
			content.is_dark_pact = flag
			content.is_build_visible = true
			content.is_in_local_player_party = flag_6
			content.is_wounded = var_24_23
			content.is_knocked_down = var_24_24
			content.needs_help = var_24_25
			content.is_dead = var_24_26
			var_24_6.empty = not flag_3
			var_24_6.is_player = flag_4
			var_24_6.peer_id = peer_id
			var_24_6.is_dark_pact = flag
			var_24_6.is_local_player = flag_8
			var_24_6.is_bot = flag_9
		end
	end
end

VersusTabUI._set_player_custom_panel_loadout_icon = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local content = arg_25_1.content
	local style = arg_25_1.style

	if not arg_25_2 then
		local tbl = {
			data = ItemMasterList[arg_25_2]
		}
		local get_ui_information_from_item, var_25_4, var_25_5 = UIUtils.get_ui_information_from_item(tbl)

		content[arg_25_3] = get_ui_information_from_item
		content[arg_25_3 .. "_item_name"] = arg_25_2
	else
		content[arg_25_3 .. "_item_name"] = nil
	end
end

VersusTabUI._button_pressed = function (arg_26_0, arg_26_1)
	-- function 26
	if not arg_26_1.on_release then
		arg_26_1.on_release = false

		return true
	end

	return false
end

VersusTabUI._get_hero_portrait = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	local str = "eor_empty_player"

	if not (arg_27_1 == nil or arg_27_2 ~= nil) then
		return str
	end

	return SPProfiles[arg_27_1].careers[arg_27_2].portrait_image or str
end

VersusTabUI._create_portrait_frame = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	local flag = arg_28_5 or 1
	local flag_2 = false
	local create_portrait_frame = UIWidgets.create_portrait_frame(arg_28_1, arg_28_2, arg_28_3, flag, flag_2, arg_28_4)
	local var_28_3 = UIWidget.init(create_portrait_frame, self._ui_top_renderer)
	local content = var_28_3.content

	content.frame_settings_name = arg_28_2
	content.level_text = arg_28_3

	return var_28_3
end

VersusTabUI._apply_color_values = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	if not arg_29_3 then
		arg_29_1[1] = arg_29_2[1]
	end

	arg_29_1[2] = arg_29_2[2]
	arg_29_1[3] = arg_29_2[3]
	arg_29_1[4] = arg_29_2[4]
end

VersusTabUI._show_profile_by_peer_id = function (self, arg_30_1)
	-- function 30
	if not IS_WINDOWS and not rawget(_G, "Steam") then
		local id_hex_to_dec = Steam.id_hex_to_dec(arg_30_1)
		local str = "http://steamcommunity.com/profiles/" .. id_hex_to_dec

		Steam.open_url(str)
	elseif not IS_XB1 then
		local xuid = self.network_lobby:xuid(arg_30_1)

		if not xuid then
			XboxLive.show_gamercard(Managers.account:user_id(), xuid)
		end
	elseif not IS_PS4 then
		Managers.account:show_player_profile_with_account_id(arg_30_1)
	end
end

VersusTabUI._muted_peer_id = function (self, arg_31_1)
	-- function 31
	if not IS_XB1 then
		if not Managers.voice_chat then
			return Managers.voice_chat:is_peer_muted(arg_31_1)
		else
			return false
		end
	else
		return self._voip:peer_muted(arg_31_1)
	end
end

VersusTabUI._ignore_voice_message_from_peer_id = function (self, arg_32_1)
	-- function 32
	if not IS_XB1 then
		if not Managers.voice_chat then
			Managers.voice_chat:mute_peer(arg_32_1)
		end
	else
		self._voip:mute_member(arg_32_1)
	end
end

VersusTabUI._remove_ignore_voice_message_from_peer_id = function (self, arg_33_1)
	-- function 33
	if not IS_XB1 then
		if not Managers.voice_chat then
			Managers.voice_chat:unmute_peer(arg_33_1)
		end
	else
		self._voip:unmute_member(arg_33_1)
	end
end

VersusTabUI._ignoring_chat_peer_id = function (arg_34_0, arg_34_1)
	-- function 34
	if not IS_WINDOWS then
		return Managers.chat.chat_gui:ignoring_peer_id(arg_34_1)
	elseif not IS_XB1 then
		return Managers.chat:ignoring_peer_id(arg_34_1)
	end
end

VersusTabUI._ignore_chat_message_from_peer_id = function (arg_35_0, arg_35_1)
	-- function 35
	if not IS_WINDOWS then
		Managers.chat.chat_gui:ignore_peer_id(arg_35_1)
	elseif not IS_XB1 then
		Managers.chat:ignore_peer_id(arg_35_1)
	end
end

VersusTabUI._can_host_solo_kick = function (self)
	-- function 36
	local _is_server = self._is_server

	_is_server = not _is_server and Managers.player:num_human_players() == 2

	return _is_server
end

VersusTabUI._can_kick_player = function (self, arg_37_1)
	-- function 37
	local _is_in_local_player_party = self:_is_in_local_player_party(arg_37_1)

	if not arg_37_1 and not _is_in_local_player_party then
		tbl.kick_peer_id = arg_37_1

		local is_leader = Managers.party:is_leader(arg_37_1)

		if not (not Managers.state.voting:can_start_vote("kick_player", tbl) and arg_37_1 == Network.peer_id() or is_leader or not (Managers.player:num_human_players() > 2)) then
			return true
		end
	end

	return false
end

VersusTabUI._kick_player_attempt = function (self, arg_38_1)
	-- function 38
	if not self:_can_kick_player(arg_38_1) then
		local tbl = {
			kick_peer_id = arg_38_1
		}

		Managers.state.voting:request_vote("kick_player", tbl, Network.peer_id())
		self:set_active(false)
	end
end

VersusTabUI._update_players_panel_button_widgets = function (self)
	-- function 39
	local vote_kick_enabled = Managers.state.voting:vote_kick_enabled()
	local _custom_game_slots = self._custom_game_slots

	if not _custom_game_slots then
		for i = 1, #_custom_game_slots do
			local var_39_2 = _custom_game_slots[i]

			for j = 1, #var_39_2 do
				local var_39_3 = var_39_2[j]
				local panel_widget = var_39_3.panel_widget
				local content = panel_widget.content
				local style = panel_widget.style
				local empty = var_39_3.empty
				local is_player = var_39_3.is_player
				local peer_id = var_39_3.peer_id
				local is_local_player = var_39_3.is_local_player
				local is_bot = var_39_3.is_bot
				local flag = not vote_kick_enabled and self:_can_kick_player(peer_id)

				if empty or not is_player then
					if is_local_player or not is_bot then
						content.show_chat_button = false
						content.show_kick_button = false
						content.show_voice_button = false
						content.show_profile_button = not is_local_player and not is_bot
						content.show_ping = not not is_local_player or not is_bot
						content.chat_button_hotspot.disable_button = true
						content.kick_button_hotspot.disable_button = true
						content.voice_button_hotspot.disable_button = true
						content.profile_button_hotspot.disable_button = is_bot
					else
						if not flag then
							content.show_kick_button = true
							content.kick_button_hotspot.disable_button = false
						else
							content.show_kick_button = false
							content.kick_button_hotspot.disable_button = true
						end

						content.show_profile_button = true
						content.show_chat_button = not IS_PS4
						content.show_voice_button = true
						content.show_ping = true
						content.profile_button_hotspot.disable_button = false
						content.chat_button_hotspot.disable_button = IS_PS4
						content.voice_button_hotspot.disable_button = false
						content.chat_button_hotspot.is_selected = self:_ignoring_chat_peer_id(peer_id)
						content.voice_button_hotspot.is_selected = self:_muted_peer_id(peer_id)
					end
				end
			end
		end
	end
end

VersusTabUI._handle_players_panel_button_input = function (self)
	-- function 40
	local _custom_game_slots = self._custom_game_slots

	if not _custom_game_slots then
		for i = 1, #_custom_game_slots do
			local var_40_1 = _custom_game_slots[i]

			for j = 1, #var_40_1 do
				local var_40_2 = var_40_1[j]
				local panel_widget = var_40_2.panel_widget
				local content = panel_widget.content
				local style = panel_widget.style
				local empty = var_40_2.empty
				local is_player = var_40_2.is_player
				local peer_id = var_40_2.peer_id
				local is_local_player = var_40_2.is_local_player
				local is_bot = var_40_2.is_bot

				if not empty then
					if not is_player then
						if not is_bot then
							local profile_button_hotspot = content.profile_button_hotspot

							if not profile_button_hotspot.on_pressed then
								profile_button_hotspot.on_pressed = nil

								self:_show_profile_by_peer_id(peer_id)
							end
						end

						if not is_local_player then
							local chat_button_hotspot = content.chat_button_hotspot

							if not chat_button_hotspot.on_pressed then
								chat_button_hotspot.on_pressed = nil

								if not chat_button_hotspot.is_selected then
									self:_remove_ignore_chat_message_from_peer_id(peer_id)

									chat_button_hotspot.is_selected = nil
								else
									self:_ignore_chat_message_from_peer_id(peer_id)

									chat_button_hotspot.is_selected = true
								end
							end

							local voice_button_hotspot = content.voice_button_hotspot

							if not voice_button_hotspot.on_pressed then
								voice_button_hotspot.on_pressed = nil

								if not voice_button_hotspot.is_selected then
									self:_remove_ignore_voice_message_from_peer_id(peer_id)

									voice_button_hotspot.is_selected = nil
								else
									self:_ignore_voice_message_from_peer_id(peer_id)

									voice_button_hotspot.is_selected = true
								end
							end

							local kick_button_hotspot = content.kick_button_hotspot

							if not kick_button_hotspot.on_pressed then
								kick_button_hotspot.on_pressed = nil

								self:_kick_player_attempt(peer_id)
							end
						end
					end

					for k = 1, #tbl_2 do
						local var_40_15 = tbl_2[k]

						if not UIUtils.is_button_hover(panel_widget, var_40_15 .. "_hotspot") then
							local var_40_16 = panel_widget.content[var_40_15 .. "_item_name"]

							self:_update_item_slots_tooltip(var_40_16, panel_widget)
						end
					end
				end
			end
		end
	end
end

VersusTabUI._update_player_item_slots = function (self, arg_41_1, arg_41_2)
	-- function 41
	for i = 1, #tbl_2 do
		local var_41_0 = tbl_2[i]
		local name = arg_41_1[var_41_0].data.name

		if arg_41_2.content[var_41_0 .. "_item_name"] ~= name then
			self:_set_player_custom_panel_loadout_icon(arg_41_2, name, var_41_0)
		end
	end
end

local tbl_3 = {
	alpha_multiplier = 0
}

VersusTabUI._update_item_slots_tooltip = function (self, arg_42_1, arg_42_2)
	-- function 42
	local _ui_scenegraph = self._ui_scenegraph
	local _ui_top_renderer = self._ui_top_renderer
	local _item_tooltip = self._item_tooltip
	local style = _item_tooltip.style

	_item_tooltip.content.item = {
		data = ItemMasterList[arg_42_1]
	}

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, 0, nil, tbl_3)
	UIRenderer.draw_widget(_ui_top_renderer, _item_tooltip)
	UIRenderer.end_pass(_ui_top_renderer)

	local item_tooltip = _ui_scenegraph.item_tooltip
	local num = style.item.item_presentation_height - 100
	local num_2 = 1080 - num
	local var_42_7 = _ui_scenegraph[arg_42_2.scenegraph_id]
	local position = var_42_7.position

	if not (var_42_7.horizontal_alignment == "left") then
		item_tooltip.horizontal_alignment = "left"
		item_tooltip.local_position[1] = 20 + var_42_7.size[1] + 50
		item_tooltip.local_position[2] = math.min(position[2] + num, num_2) + 50
	else
		item_tooltip.horizontal_alignment = "right"
		item_tooltip.local_position[1] = -20 - var_42_7.size[1] - 50
		item_tooltip.local_position[2] = math.min(position[2] + num, num_2) + 50
	end
end

VersusTabUI._update_player_talents = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	local content = arg_43_3.content
	local has_extension = ScriptUnit.has_extension(arg_43_1, "talent_system")

	if not has_extension then
		local get_talent_ids = has_extension:get_talent_ids()
		local profile_display_name = arg_43_2:profile_display_name()

		for i = 1, 6 do
			local var_43_4 = get_talent_ids[i]
			local get_talent_by_id = TalentUtils.get_talent_by_id(profile_display_name, var_43_4)
			local flag = not get_talent_by_id and get_talent_by_id.icon
			local var_43_7 = content["talent_" .. i]

			if not flag then
				get_talent_by_id = nil
			end

			var_43_7.talent = get_talent_by_id
			var_43_7.icon = flag or "icons_placeholder"
		end
	end
end

VersusTabUI._update_player_talents_tooltip = function (self, arg_44_1)
	-- function 44
	local content = arg_44_1.content

	for i = 1, 6 do
		local var_44_1 = content["talent_" .. i]

		if not var_44_1.talent and not var_44_1.is_hover then
			local scenegraph_id = arg_44_1.scenegraph_id
			local var_44_3 = self._ui_scenegraph[scenegraph_id]
			local position = var_44_3.position
			local flag = var_44_3.horizontal_alignment == "left"
			local talent_tooltip = self._ui_scenegraph.talent_tooltip

			if not flag then
				talent_tooltip.horizontal_alignment = "left"
				talent_tooltip.local_position[1] = 20 + var_44_3.size[1] + 50
				talent_tooltip.local_position[2] = var_44_3.position[2] + 50
			else
				talent_tooltip.horizontal_alignment = "right"
				talent_tooltip.local_position[1] = -20 - var_44_3.size[1] - 50
				talent_tooltip.local_position[2] = var_44_3.position[2] + 50
			end
		end
	end
end

VersusTabUI._update_player_health = function (arg_45_0, arg_45_1, arg_45_2)
	-- function 45
	local game = Managers.state.network:game()
	local go_id = Managers.state.unit_storage:go_id(arg_45_1)
	local extension = ScriptUnit.extension(arg_45_1, "health_system")
	local extension_2 = ScriptUnit.extension(arg_45_1, "status_system")
	local extension_3 = ScriptUnit.extension(arg_45_1, "buff_system")
	local extension_4 = ScriptUnit.extension(arg_45_1, "inventory_system")
	local get_max_health = extension:get_max_health()
	local is_dead = extension_2:is_dead()
	local flag

	flag = not is_dead and 0 and extension:current_health()

	local flag_2

	flag_2 = not is_dead and 0 and extension:current_health_percent()

	local flag_3

	flag_3 = not is_dead and 0 and extension:current_permanent_health_percent()

	local is_wounded = extension_2:is_wounded()
	local get_is_ledge_hanging

	if not extension_2:is_knocked_down() then
		get_is_ledge_hanging = extension_2:get_is_ledge_hanging()

		if not get_is_ledge_hanging then
			-- Nothing
		end
	end

	get_is_ledge_hanging = flag_2 > 0

	::label_45_0::

	local is_ready_for_assisted_respawn = extension_2:is_ready_for_assisted_respawn()
	local is_grabbed_by_pack_master = extension_2:is_grabbed_by_pack_master()

	if not is_grabbed_by_pack_master then
		is_grabbed_by_pack_master = extension_2:is_hanging_from_hook()

		if not is_grabbed_by_pack_master then
			is_grabbed_by_pack_master = extension_2:is_pounced_down()

			if not is_grabbed_by_pack_master then
				is_grabbed_by_pack_master = extension_2:is_grabbed_by_corruptor()

				if not is_grabbed_by_pack_master then
					is_grabbed_by_pack_master = extension_2:is_in_vortex()
					is_grabbed_by_pack_master = is_grabbed_by_pack_master or extension_2:is_grabbed_by_chaos_spawn()
				end
			end
		end
	end

	local num_buff_perk = extension_3:num_buff_perk("skaven_grimoire")
	local apply_buffs_to_value = extension_3:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
	local num_buff_perk_2 = extension_3:num_buff_perk("twitch_grimoire")
	local apply_buffs_to_value_2 = extension_3:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
	local num_buff_perk_3 = extension_3:num_buff_perk("slayer_curse")
	local apply_buffs_to_value_3 = extension_3:apply_buffs_to_value(PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF, "curse_protection")
	local num_buff_perk_4 = extension_3:num_buff_perk("mutator_curse")
	local value = WindSettings.light.curse_settings.value
	local get_difficulty_value_from_table = Managers.state.difficulty:get_difficulty_value_from_table(value)
	local apply_buffs_to_value_4 = extension_3:apply_buffs_to_value(get_difficulty_value_from_table, "curse_protection")
	local apply_buffs_to_value_5 = extension_3:apply_buffs_to_value(0, "health_curse")
	local apply_buffs_to_value_6 = extension_3:apply_buffs_to_value(apply_buffs_to_value_5, "curse_protection")
	local num = 1 + num_buff_perk * apply_buffs_to_value + num_buff_perk_2 * apply_buffs_to_value_2 + num_buff_perk_3 * apply_buffs_to_value_3 + num_buff_perk_4 * apply_buffs_to_value_4 + apply_buffs_to_value_6
	local style = arg_45_2.style
	local content = arg_45_2.content
	local health_bar = style.health_bar
	local total_health_bar = style.total_health_bar
	local ability_bar = content.ability_bar

	if not game and not go_id then
		local game_object_field = GameSession.game_object_field(game, go_id, "ability_percentage")

		game_object_field = game_object_field or 0
		ability_bar.bar_value = 1 - game_object_field
	end

	health_bar.gradient_threshold = flag_3 * num
	total_health_bar.gradient_threshold = flag_2 * num

	return is_wounded, get_is_ledge_hanging, is_grabbed_by_pack_master, is_dead
end

VersusTabUI._is_in_local_player_party = function (arg_46_0, arg_46_1)
	-- function 46
	local get_local_player_party = Managers.party:get_local_player_party()

	if not get_local_player_party then
		local occupied_slots = get_local_player_party.occupied_slots

		for i = 1, #occupied_slots do
			if arg_46_1 == occupied_slots[i].peer_id then
				return true
			end
		end
	end

	return false
end

VersusTabUI._get_opponent_party_id = function (self)
	-- function 47
	local flag

	flag = self._party_id ~= 1 or not 2 or 1

	return flag
end

VersusTabUI._remove_ignore_chat_message_from_peer_id = function (arg_48_0, arg_48_1)
	-- function 48
	if not IS_WINDOWS then
		Managers.chat.chat_gui:remove_ignore_peer_id(arg_48_1)
	elseif not IS_XB1 then
		Managers.chat:remove_ignore_peer_id(arg_48_1)
	end
end

VersusTabUI.add_respawn_counter_event = function (self, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	-- function 49
	local peer_id = arg_49_1.peer_id
	local _get_player_slot_by_peer_id = self:_get_player_slot_by_peer_id(peer_id)

	if not (not _get_player_slot_by_peer_id and not (arg_49_3 > 0)) then
		local content = _get_player_slot_by_peer_id.panel_widget.content

		content.respawning = true
		content.spawn_timer = arg_49_3
	end
end

VersusTabUI._update_player_respawn_counter = function (arg_50_0, arg_50_1)
	-- function 50
	local portrait_widget = arg_50_1.portrait_widget

	if not portrait_widget then
		return
	end

	local panel_widget = arg_50_1.panel_widget

	if not panel_widget.content.respawning then
		local time_and_delta, var_50_3 = Managers.time:time_and_delta("game")
		local num = panel_widget.content.spawn_timer - time_and_delta

		if num <= 0 then
			panel_widget.content.respawning = false
		end

		panel_widget.content.respawn_text = string.format("%d", math.abs(num))
	end

	portrait_widget.style.portrait.saturated = panel_widget.content.respawning
end

VersusTabUI._update_player_status_portrait = function (self, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9)
	-- function 51
	local portrait_widget = arg_51_1.portrait_widget

	if not portrait_widget then
		return
	end

	local panel_widget = arg_51_1.panel_widget
	local content = panel_widget.content

	if not (not arg_51_4 and arg_51_5) then
		portrait_widget.content.portrait = "eor_empty_player"
		portrait_widget.style.portrait.color[1] = 255
	elseif not (content.is_wounded ~= arg_51_6 or content.is_knocked_down ~= arg_51_7 or content.needs_help ~= arg_51_8 or content.is_dead == arg_51_9) then
		local style = panel_widget.style

		if arg_51_7 or not arg_51_8 then
			portrait_widget.content.portrait = "status_icon_needs_assist"
			portrait_widget.style.portrait.color[1] = 150
		elseif not (not arg_51_9 and content.respawning) then
			portrait_widget.content.portrait = "status_icon_dead"
			portrait_widget.style.portrait.color[1] = 255
		else
			local _get_hero_portrait = self:_get_hero_portrait(arg_51_2, arg_51_3)

			portrait_widget.content.portrait = _get_hero_portrait
			portrait_widget.style.portrait.color[1] = 255
		end
	end
end

VersusTabUI._get_player_slot_by_peer_id = function (self, arg_52_1)
	-- function 52
	local _custom_game_slots = self._custom_game_slots

	if not _custom_game_slots then
		for i = 1, #_custom_game_slots do
			local var_52_1 = _custom_game_slots[i]

			for j = 1, #var_52_1 do
				local var_52_2 = var_52_1[j]

				if var_52_2.peer_id == arg_52_1 then
					return var_52_2
				end
			end
		end
	end
end

VersusTabUI._get_ping_texture_by_ping_value = function (arg_53_0, arg_53_1)
	-- function 53
	if arg_53_1 <= 125 then
		return "ping_icon_01", "low_ping_color"
	elseif not (not (arg_53_1 > 125) or not (arg_53_1 <= 175)) then
		return "ping_icon_02", "medium_ping_color"
	elseif arg_53_1 > 175 then
		return "ping_icon_03", "high_ping_color"
	end
end

VersusTabUI._update_objectives = function (self, arg_54_1, arg_54_2)
	-- function 54
	if not self._objective_system:is_active() then
		return
	end

	if not self._objectives_initialized then
		local flag = not self:_is_dark_pact()

		self:_set_active_scoring_side_color(flag)

		self._num_main_objective = self._objective_system:num_main_objectives()
		self._objectives_initialized = true
	end

	local current_objective_index = self._objective_system:current_objective_index()
	local num_completed_main_objectives = self._objective_system:num_completed_main_objectives()

	if current_objective_index > self._selected_objective_index then
		self._selected_objective_index = current_objective_index

		self:_update_current_objective(current_objective_index)

		local str = "n/a"

		if not self:_is_dark_pact() then
			str = Localize("level_objective_pactsworn")
		else
			str = self._objective_system:first_active_objective_description()
		end

		self:_set_objective_text(str)
	end

	self:_update_objective_progress()
end

VersusTabUI._update_current_objective = function (self)
	-- function 55
	local score = self._widgets_by_name.score
	local current_objective_icon = self._objective_system:current_objective_icon()

	score.content.objective_icon = current_objective_icon
end

VersusTabUI._update_objective_progress = function (self)
	-- function 56
	local current_objective_progress = self._objective_system:current_objective_progress()

	current_objective_progress = current_objective_progress or 0

	local num = 0
	local num_2 = 360 - num * 2
	local num_3 = 255 * math.min(current_objective_progress * 2, 1)
	local num_4 = (num + num_2 * current_objective_progress) / 360

	self._widgets_by_name.score.style.progress_bar.gradient_threshold = num_4

	if current_objective_progress == 1 then
		return true
	end
end

VersusTabUI._update_round_start_timer = function (self, arg_57_1, arg_57_2)
	-- function 57
	if not self._round_has_started then
		return
	end

	if not (not self._countdown_timer and not (self._countdown_timer <= 0)) then
		self:_on_round_started()
	end
end

VersusTabUI._set_pre_round_timer = function (self, arg_58_1)
	-- function 58
	self._widgets_by_name.score.content.pre_round_timer = arg_58_1
	self._countdown_timer = arg_58_1
end

VersusTabUI._set_round_starting_text = function (arg_59_0)
	-- function 59
	arg_59_0._widgets_by_name.round_starting_text.content.text = "Round Starting..."
end

VersusTabUI._set_objective_text = function (self, arg_60_1)
	-- function 60
	local objective_text = self._widgets_by_name.objective_text
	local content = objective_text.content
	local style = objective_text.style

	content.area_text_content = arg_60_1
end

VersusTabUI._register_events = function (arg_61_0)
	-- function 61
	local event = Managers.state.event

	if not event then
		event:register(arg_61_0, "add_respawn_counter_event", "add_respawn_counter_event")
		event:register(arg_61_0, "ui_tab_update_start_round_counter", "update_start_round_counter")
		event:register(arg_61_0, "ui_tab_round_started", "round_started")
	end
end

VersusTabUI._unregister_events = function (arg_62_0)
	-- function 62
	local event = Managers.state.event

	if not event then
		event:unregister("add_respawn_counter_event", arg_62_0)
		event:unregister("ui_tab_update_start_round_counter", arg_62_0)
		event:unregister("ui_tab_round_started", arg_62_0)
	end
end

VersusTabUI.update_start_round_counter = function (self, arg_63_1)
	-- function 63
	self:_set_pre_round_timer(arg_63_1)
end

VersusTabUI._on_round_started = function (self)
	-- function 64
	self._round_has_started = true

	local content = self._widgets_by_name.score.content

	if not self._custom_round_timer_active then
		-- Nothing
	end

	content.pre_round_timer_done = true
end

VersusTabUI.round_started = function (self)
	-- function 65
	self:_on_round_started()
end

VersusTabUI._set_active_scoring_side_color = function (self, arg_66_1)
	-- function 66
	local get_color_table_with_alpha

	if not arg_66_1 then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

	::label_66_0::

	local score = self._widgets_by_name.score

	score.content.is_hero = arg_66_1
	score.style.progress_bar.color = get_color_table_with_alpha
	score.style.objective_icon.color = get_color_table_with_alpha
end

VersusTabUI._is_dark_pact = function (self)
	-- function 67
	local _party_id = self._party_id
	local get_party = Managers.party:get_party(_party_id)
	local var_67_2 = Managers.state.side.side_by_party[get_party]

	return not var_67_2 and var_67_2:name() == "dark_pact"
end

VersusTabUI._get_current_set = function (self)
	-- function 68
	local get_current_round = self._win_conditions:get_current_round()

	return math.round(get_current_round / 2)
end

VersusTabUI._setup_custom_settings_scrollbar = function (self, arg_69_1, arg_69_2)
	-- function 69
	local num = arg_69_1 * arg_69_2 - var_0_0.scenegraph_definition.settings_container.size[2]

	if num > 0 then
		local _ui_scenegraph = self._ui_scenegraph
		local str = "settings_anchor"
		local str_2 = "settings_container"
		local flag = false
		local var_69_5
		local var_69_6

		self._scrollbar_ui = ScrollbarUI:new(_ui_scenegraph, str, str_2, num, flag, var_69_5, var_69_6)
	end
end
