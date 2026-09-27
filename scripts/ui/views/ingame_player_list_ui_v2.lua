-- chunkname: @scripts/ui/views/ingame_player_list_ui_v2.lua

require("scripts/ui/views/character_inspect_ui")

local var_0_0 = local_require("scripts/ui/views/ingame_player_list_ui_v2_definitions")
local console_cursor_definition = var_0_0.console_cursor_definition
local PLAYER_LIST_SIZE = var_0_0.PLAYER_LIST_SIZE
local num = 16
local num_2 = 60
local tbl = {}
local tbl_2 = {
	{
		texture = "loot_objective_icon_02",
		mission_name = "tome_bonus_mission",
		key = "tome",
		widget_name = "tome_counter",
		title_text = "dlc1_3_1_tomes"
	},
	{
		texture = "loot_objective_icon_01",
		mission_name = "grimoire_hidden_mission",
		key = "grimoire",
		widget_name = "grimoire_counter",
		title_text = "dlc1_3_1_grimoires"
	},
	{
		texture = "loot_mutator_icon_05",
		mission_name = "bonus_dice_hidden_mission",
		key = "loot_die",
		widget_name = "loot_dice",
		title_text = "interaction_loot_dice"
	}
}

IngamePlayerListUI = class(IngamePlayerListUI)

IngamePlayerListUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ui_top_renderer = arg_1_2.ui_top_renderer
	self._ingame_ui = arg_1_2.ingame_ui
	self._wwise_world = arg_1_2.dialogue_system.wwise_world
	self._input_manager = arg_1_2.input_manager
	self._player_manager = arg_1_2.player_manager
	self._profile_synchronizer = arg_1_2.profile_synchronizer
	self._is_in_inn = arg_1_2.is_in_inn
	self._voip = arg_1_2.voip
	self._is_server = arg_1_2.is_server
	self._network_server = arg_1_2.network_server
	self._network_lobby = arg_1_2.network_lobby
	self._local_player = self._player_manager:local_player()

	local map_view_data = PlayerData.map_view_data

	map_view_data = map_view_data or {}
	self._map_save_data = map_view_data
	self._platform = PLATFORM
	self._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._active = false
	self._mission_system = Managers.state.entity:system("mission_system")

	local _input_manager = self._input_manager

	_input_manager:create_input_service("player_list_input", "IngamePlayerListKeymaps", "IngamePlayerListFilters")
	_input_manager:map_device_to_service("player_list_input", "keyboard")
	_input_manager:map_device_to_service("player_list_input", "mouse")
	_input_manager:map_device_to_service("player_list_input", "gamepad")
	self:_create_ui_elements()

	local settings = Managers.state.game_mode:settings()
	local is_server

	if not (settings.private_only or self._is_in_inn) then
		is_server = self._local_player.is_server

		if not is_server then
			-- Nothing
		end

		if self._platform == "xb1" then
			-- Nothing
		end
	end

	is_server = false

	goto label_1_1

	::label_1_0::

	is_server = true

	::label_1_1::

	self._private_setting_enabled = is_server

	local network_transmit = Managers.state.network.network_transmit

	self._host_peer_id = network_transmit.server_peer_id or network_transmit.peer_id
	self._show_difficulty = not settings.hide_difficulty

	if not self._show_difficulty then
		self:_set_difficulty_name("")
	end

	self._kick_vote_cooldown = nil

	self:_setup_weave_display_info()
	Managers.state.event:register(self, "weave_objective_synced", "event_weave_objective_synced")
end

IngamePlayerListUI._create_ui_elements = function (self)
	-- function 2
	self._num_players = 0
	self._num_rewards = 0
	self._mission_count = 0
	self._num_mutators = 0
	self._players = {}
	self._current_difficulty_name = nil
	self._reward_widgets = {}

	local scenegraph_definition = var_0_0.scenegraph_definition

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local static_widget_definitions = var_0_0.static_widget_definitions
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(static_widget_definitions) do
		local var_2_4 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_4
		tbl_2[k] = var_2_4
	end

	self._static_widgets = tbl
	self._static_widgets_by_name = tbl_2

	local widget_definitions = var_0_0.widget_definitions
	local tbl_3 = {}
	local tbl_4 = {}

	for k_2, v_2 in pairs(widget_definitions) do
		local var_2_8 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_2_8
		tbl_4[k_2] = var_2_8
	end

	self._widgets = tbl_3
	self._widgets_by_name = tbl_4
	tbl_4.mutator_summary1.content.item = {
		mutators = {}
	}
	tbl_4.mutator_summary2.content.item = {
		mutators = {}
	}
	tbl_4.mutator_summary3.content.item = {
		mutators = {}
	}
	tbl_4.mutator_summary4.content.item = {
		mutators = {}
	}
	tbl_4.mutator_summary5.content.item = {
		mutators = {}
	}
	tbl_4.mutator_summary6.content.item = {
		mutators = {}
	}

	local specific_widget_definitions = var_0_0.specific_widget_definitions

	self._input_description_text_widget = UIWidget.init(specific_widget_definitions.input_description_text)
	self._reward_header_widget = UIWidget.init(specific_widget_definitions.reward_header)
	self._reward_divider_widget = UIWidget.init(specific_widget_definitions.reward_divider)
	self._collectibles_name = UIWidget.init(specific_widget_definitions.collectibles_name)
	self._collectibles_divider = UIWidget.init(specific_widget_definitions.collectibles_divider)
	self._level_description_widget = UIWidget.init(specific_widget_definitions.level_description)
	self._private_checkbox_widget = UIWidget.init(specific_widget_definitions.private_checkbox)
	self._private_checkbox_disabled_reasons = {}
	self._node_info_widget = nil

	local twitch = Managers.twitch

	if not twitch then
		twitch = Managers.twitch:is_connected()
		twitch = twitch or Managers.twitch:is_activated()
	end

	if Managers.state.game_mode:game_mode_key() == "weave" or not twitch then
		self._private_checkbox_disabled_reasons.weave_or_twitch = true
	end

	local tbl_5 = {}

	for i4 = 1, 8 do
		tbl_5[i4] = UIWidget.init(var_0_0.player_widget_definition(i4))
	end

	self._player_list_widgets = tbl_5
	self._popup_list = UIWidget.init(var_0_0.popup_widget_definition)
	self._console_cursor = UIWidget.init(console_cursor_definition)
	self._item_tooltip = UIWidget.init(var_0_0.item_tooltip)

	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local var_2_13 = LevelSettings[get_current_level_keys]

	self:_set_level_name(Localize(var_2_13.display_name))
	self:_setup_mission_data(var_2_13)

	if not var_2_13.description_text then
		self._level_description_widget.content.text = Localize(var_2_13.description_text)
	end
end

local num_3 = 1
local num_4 = 6
local num_5 = num_3 * num_4

IngamePlayerListUI._setup_mutator_data = function (self)
	-- function 3
	local current_level_settings = LevelHelper:current_level_settings()
	local var_3_1

	if not current_level_settings.hub_level then
		var_3_1 = Managers.deed:mutators()
		var_3_1 = not var_3_1 and table.set(var_3_1)
	else
		var_3_1 = Managers.state.game_mode:activated_mutators()
	end

	local _widgets_by_name = self._widgets_by_name
	local mutators = _widgets_by_name.mutator_summary1.content.item.mutators

	table.clear(mutators)

	local mutators_2 = _widgets_by_name.mutator_summary2.content.item.mutators

	table.clear(mutators_2)

	local mutators_3 = _widgets_by_name.mutator_summary3.content.item.mutators

	table.clear(mutators_3)

	local mutators_4 = _widgets_by_name.mutator_summary4.content.item.mutators

	table.clear(mutators_4)

	local mutators_5 = _widgets_by_name.mutator_summary5.content.item.mutators

	table.clear(mutators_5)

	local mutators_6 = _widgets_by_name.mutator_summary6.content.item.mutators

	table.clear(mutators_6)

	local tbl = {
		mutators,
		mutators_2,
		mutators_3,
		mutators_4,
		mutators_5,
		mutators_6
	}

	if not var_3_1 then
		local num = 0
		local num_2 = 1

		for k, v in pairs(var_3_1) do
			if not (type(v) ~= "table" or v.activated_by_twitch or MutatorTemplates[k].hide_from_player_ui) then
				local num_6 = 1 + math.floor((num_2 - 1) / num_3) % num_4

				if num_2 > num_5 then
					break
				end

				local var_3_13 = tbl[num_6]

				var_3_13[#var_3_13 + 1] = k
				num_2 = num_2 + 1
				num = num + 1
			end
		end

		self._num_mutators = num
	end
end

IngamePlayerListUI._get_deus_current_node = function (arg_4_0)
	-- function 4
	if Managers.state.game_mode:game_mode_key() ~= "deus" then
		return
	end

	if Managers.mechanism:current_mechanism_name() ~= "deus" then
		return
	end

	local game_mechanism = Managers.mechanism:game_mechanism()

	return (not game_mechanism and game_mechanism:get_deus_run_controller()):get_current_node()
end

IngamePlayerListUI._setup_chaos_wastes_info = function (self)
	-- function 5
	local _get_deus_current_node = self:_get_deus_current_node()

	if not _get_deus_current_node then
		return
	end

	local theme = _get_deus_current_node.theme
	local minor_modifier_group = _get_deus_current_node.minor_modifier_group
	local terror_event_power_up = _get_deus_current_node.terror_event_power_up
	local conflict_settings = _get_deus_current_node.conflict_settings
	local profile_by_peer, var_5_6 = self._profile_synchronizer:profile_by_peer(Network.peer_id(), 1)
	local var_5_7 = UIWidget.init(var_0_0.create_node_info_widget())

	var_5_7.content.visible = true

	local node_info = var_5_7.content.node_info
	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local var_5_10 = LevelSettings[get_current_level_keys]

	if not (not theme and theme ~= "wastes") then
		node_info.curse_text = ""
	else
		node_info.curse_text = Localize("deus_map_node_info_god_" .. theme)
		node_info.curse_icon = "deus_icons_map_" .. theme
		var_5_7.style.node_info.curse_section.curse_icon.color = Colors.get_color_table_with_alpha(theme, 255)
		var_5_7.style.node_info.curse_section.curse_text.text_color = Colors.get_color_table_with_alpha(theme, 255)
	end

	if not minor_modifier_group then
		local minor_modifier_1_section = node_info.minor_modifier_1_section
		local var_5_12

		if not minor_modifier_group[1] then
			var_5_12 = Localize("mutator_" .. minor_modifier_group[1] .. "_name")

			if not var_5_12 then
				-- Nothing
			end
		end

		var_5_12 = ""

		::label_5_0::

		minor_modifier_1_section.text = var_5_12

		local minor_modifier_2_section = node_info.minor_modifier_2_section
		local var_5_14

		if not minor_modifier_group[2] then
			var_5_14 = Localize("mutator_" .. minor_modifier_group[2] .. "_name")

			if not var_5_14 then
				-- Nothing
			end
		end

		var_5_14 = ""

		::label_5_1::

		minor_modifier_2_section.text = var_5_14

		local minor_modifier_3_section = node_info.minor_modifier_3_section
		local var_5_16

		if not minor_modifier_group[3] then
			var_5_16 = Localize("mutator_" .. minor_modifier_group[3] .. "_name")

			if not var_5_16 then
				-- Nothing
			end
		end

		var_5_16 = ""

		::label_5_2::

		minor_modifier_3_section.text = var_5_16
	else
		node_info.minor_modifier_1_section.text = ""
		node_info.minor_modifier_2_section.text = ""
		node_info.minor_modifier_3_section.text = ""
	end

	if not terror_event_power_up then
		local var_5_17 = DeusPowerUpTemplates[terror_event_power_up]
		local get_power_up_name_text = DeusPowerUpUtils.get_power_up_name_text(terror_event_power_up, var_5_17.talent_index, var_5_17.talent_tier, profile_by_peer, var_5_6)
		local var_5_19 = Localize("terror_event_power_up_prefix_suffix")
		local format = string.format(var_5_19, get_power_up_name_text)

		var_5_7.content.node_info.terror_event_power_up_text = format
		var_5_7.content.node_info.terror_event_power_up_icon = var_5_17.icon
	else
		node_info.terror_event_power_up_text = ""
	end

	local var_5_21 = ConflictDirectors[conflict_settings]
	local flag = not var_5_21 and var_5_21.description

	if not flag then
		local var_5_23 = Localize(flag)

		var_5_23 = var_5_23 or ""
		node_info.breed_text = var_5_23
	else
		node_info.breed_text = ""
	end

	self._node_info_widget = var_5_7

	local num = 30

	if not (not var_5_10.description_text and self._num_mutators ~= 0) then
		local _level_description_widget = self._level_description_widget
		local content = _level_description_widget.content
		local style = _level_description_widget.style
		local level_description_text = style.level_description_text
		local var_5_29, var_5_30 = UIFontByResolution(level_description_text)
		local text_size, var_5_32 = UIRenderer.text_size(self._ui_renderer, content.description_text, var_5_29[1], var_5_30)
		local level_description_text_2 = style.level_description_text
		local var_5_34, var_5_35 = UIFontByResolution(level_description_text_2)
		local word_wrap = UIRenderer.word_wrap(self._ui_renderer, content.text, var_5_34[1], level_description_text_2.font_size, level_description_text_2.area_size[1])
		local var_5_37 = var_5_32

		for i = 1, #word_wrap do
			local text_size_2, var_5_39 = UIRenderer.text_size(self._ui_renderer, word_wrap[i], var_5_34[1], var_5_35)

			var_5_37 = var_5_37 + var_5_39
		end

		local num_2 = 60

		var_5_7.offset[2] = -var_5_37 - num_2 - num
	else
		var_5_7.offset[2] = self._num_mutators * -100 - num
	end
end

IngamePlayerListUI._setup_deed_reward_data = function (self, arg_6_1)
	-- function 6
	table.clear(self._reward_widgets)

	self._num_rewards = 0

	local rewards = Managers.deed:rewards()

	if not rewards then
		return
	end

	local num = 60
	local num_2 = 20
	local num_3 = 0

	for i = 1, #rewards do
		local var_6_4 = rewards[i]
		local var_6_5 = ItemMasterList[var_6_4]
		local tbl = {
			data = var_6_5
		}
		local var_6_7 = UIWidget.init(var_0_0.create_reward_item(num_3, tbl))

		self._reward_widgets[#self._reward_widgets + 1] = var_6_7
		num_3 = num_3 + num + num_2
	end

	local count = #rewards
	local num_4 = ((count - 1) * num + num_2 * (count - 1)) * -0.5

	self._ui_scenegraph.reward_item.offset[1] = num_4
	self._num_rewards = count
end

IngamePlayerListUI._setup_mission_data = function (self, arg_7_1)
	-- function 7
	local loot_objectives = arg_7_1.loot_objectives

	if not loot_objectives then
		return
	end

	local _ui_renderer = self._ui_renderer
	local create_loot_widget = var_0_0.create_loot_widget
	local _widgets = self._widgets
	local _widgets_by_name = self._widgets_by_name
	local tbl = {}
	local num = 2
	local num_2 = 0
	local num_3 = 0
	local num_4 = 0
	local num_5 = 0
	local num_6 = 0

	for i, v in ipairs(tbl_2) do
		local key = v.key
		local var_7_13 = loot_objectives[key]

		if not var_7_13 then
			local mission_name = v.mission_name
			local widget_name = v.widget_name
			local texture = v.texture
			local size = UIAtlasHelper.get_atlas_settings_by_texture_name(texture).size
			local var_7_18 = size[1]
			local var_7_19 = size[2]
			local num_7 = 1
			local var_7_21 = Localize(v.title_text)
			local var_7_22 = create_loot_widget(texture, var_7_21, num_7)
			local var_7_23 = UIWidget.init(var_7_22)
			local tbl_3 = {
				name = key,
				total_amount = not (var_7_13 > 0) or var_7_13,
				mission_name = mission_name,
				widget = var_7_23
			}
			local num_8 = var_7_18 * num_7
			local num_9 = var_7_19 * num_7
			local text = var_7_23.style.text
			local num_10 = UIUtils.get_text_width(_ui_renderer, text, var_7_21) + 20

			if num_2 < num_10 then
				num_2 = num_10
			end

			local floor = math.floor(num_6 / num)

			if num_6 % num > 0 then
				num_3 = num_3 + (num_8 + num_2)
				num_2 = 0
			else
				num_3 = 0
			end

			local offset = var_7_23.offset

			offset[1] = num_3
			offset[2] = -(floor - 1) * num_9
			tbl[key] = tbl_3
			_widgets_by_name[widget_name] = var_7_23
			_widgets[#_widgets + 1] = var_7_23
			num_6 = num_6 + 1
		end
	end

	if num_6 > 0 then
		self._mission_settings_data = tbl

		self:_sync_missions()
	end

	self._mission_count = num_6
end

IngamePlayerListUI._sync_missions = function (self)
	-- function 8
	local _mission_settings_data = self._mission_settings_data

	if not _mission_settings_data then
		return
	end

	for k, v in pairs(_mission_settings_data) do
		local mission_name = v.mission_name
		local _get_item_amount_by_mission_name = self:_get_item_amount_by_mission_name(mission_name)

		_get_item_amount_by_mission_name = _get_item_amount_by_mission_name or 0

		local amount = v.amount
		local total_amount = v.total_amount
		local widget = v.widget

		if amount ~= _get_item_amount_by_mission_name then
			v.previous_amount = amount or 0
			v.amount = _get_item_amount_by_mission_name

			local content = widget.content

			content.amount = _get_item_amount_by_mission_name

			if not total_amount then
				content.counter_text = tostring(_get_item_amount_by_mission_name) .. "/" .. tostring(total_amount)
			else
				content.counter_text = "x" .. tostring(_get_item_amount_by_mission_name)
			end
		end
	end
end

IngamePlayerListUI._get_item_amount_by_mission_name = function (self, arg_9_1)
	-- function 9
	local get_level_end_mission_data = self._mission_system:get_level_end_mission_data(arg_9_1)

	return not get_level_end_mission_data and get_level_end_mission_data.current_amount
end

IngamePlayerListUI._create_player_portrait = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local create_portrait_frame = UIWidgets.create_portrait_frame("player_portrait", arg_10_1, arg_10_3, 1, nil, arg_10_2)

	self._player_portrait_widget = UIWidget.init(create_portrait_frame, self._ui_top_renderer)
end

IngamePlayerListUI._create_player_insignia = function (self, arg_11_1)
	-- function 11
	if not arg_11_1.is_bot_player then
		return
	end

	local player = arg_11_1.player
	local get_versus_player_level = ExperienceSettings.get_versus_player_level(player)
	local create_small_insignia = UIWidgets.create_small_insignia("player_insignia", get_versus_player_level)

	self._player_insignia_widget = UIWidget.init(create_small_insignia)
end

IngamePlayerListUI._setup_weave_display_info = function (self)
	-- function 12
	if Managers.state.game_mode:game_mode_key() == "weave" then
		local lobby = Managers.state.network:lobby()
		local flag = not lobby and lobby:lobby_data("weave_quick_game")
		local weave = Managers.weave

		if not weave then
			local get_active_weave_template = weave:get_active_weave_template()

			if not get_active_weave_template then
				local var_12_4

				if flag == "true" then
					var_12_4 = Localize(get_active_weave_template.display_name)
				else
					var_12_4 = get_active_weave_template.tier .. ". " .. Localize(get_active_weave_template.display_name)
				end

				local wind = get_active_weave_template.wind
				local display_name = WindSettings[wind].display_name

				self:_set_level_name(var_12_4)
				self:_set_difficulty_name(Localize(display_name))
				self:_setup_weave_objectives(get_active_weave_template)
			else
				self:_set_level_name("")
				self:_set_difficulty_name("")
			end
		end
	end
end

IngamePlayerListUI._setup_weave_objectives = function (self, arg_13_1)
	-- function 13
	self._weave_objective_widgets = {}
	self._weave_objective_widgets_by_name = {}

	for k, v in pairs(var_0_0.weave_objective_widgets) do
		local var_13_0 = UIWidget.init(v)

		self._weave_objective_widgets[#self._weave_objective_widgets + 1] = var_13_0
		self._weave_objective_widgets_by_name[k] = var_13_0
	end

	local num = 10
	local num_2 = 0
	local scenegraph_definition = var_0_0.scenegraph_definition
	local str = "weave_sub_objective"
	local size = scenegraph_definition[str].size
	local objectives = arg_13_1.objectives

	for k_2 = 1, #objectives do
		local create_weave_sub_objective_widget = var_0_0.create_weave_sub_objective_widget(str, size)
		local var_13_8 = UIWidget.init(create_weave_sub_objective_widget)

		self._weave_objective_widgets[#self._weave_objective_widgets + 1] = var_13_8
		self._weave_objective_widgets_by_name["weave_sub_objective_" .. k_2] = var_13_8

		local var_13_9 = objectives[k_2]
		local flag = var_13_9.conflict_settings == "weave_disabled"
		local flag_2

		flag_2 = not flag and "menu_weave_play_next_end_event_title" and "menu_weave_play_main_objective_title"

		local display_name = var_13_9.display_name
		local flag_3

		flag_3 = not flag and "objective_icon_boss" and "objective_icon_general"

		local _assign_objective = self:_assign_objective(var_13_8, flag_2, display_name, flag_3, num)

		var_13_8.offset[2] = -num_2
		num_2 = num_2 + _assign_objective + num
	end
end

IngamePlayerListUI._assign_objective = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local scenegraph_id = arg_14_1.scenegraph_id
	local content = arg_14_1.content
	local style = arg_14_1.style
	local size = var_0_0.scenegraph_definition[scenegraph_id].size

	content.icon = arg_14_4 or "trial_gem"
	content.title_text = arg_14_2 or "-"
	content.text = arg_14_3 or "-"

	local size_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(content.icon).size
	local icon = style.icon
	local texture_size = icon.texture_size
	local default_offset = icon.default_offset
	local offset = icon.offset

	texture_size[1] = size_2[1]
	texture_size[2] = size_2[2]
	offset[1] = default_offset[1] - texture_size[1] / 2
	offset[2] = default_offset[2]

	local text = style.text
	local _ui_renderer = self._ui_renderer
	local get_text_width = UIUtils.get_text_width(_ui_renderer, text, content.text)
	local get_text_height = UIUtils.get_text_height(_ui_renderer, size, text, content.text)

	arg_14_5 = arg_14_5 or 0

	return math.max(get_text_height, 50) + arg_14_5
end

IngamePlayerListUI.destroy = function (self)
	-- function 15
	if not self._cursor_active then
		ShowCursorStack.hide("IngamePlayerListUI")

		local _input_manager = self._input_manager

		_input_manager:device_unblock_all_services("keyboard")
		_input_manager:device_unblock_all_services("mouse")
		_input_manager:device_unblock_all_services("gamepad")

		self._cursor_active = false
	end

	Managers.state.event:unregister("weave_objective_synced", self)
	print("[IngamePlayerListUI] - Destroy")
end

IngamePlayerListUI._set_level_name = function (self, arg_16_1)
	-- function 16
	self:_set_widget_text("game_level", arg_16_1)
end

IngamePlayerListUI._set_difficulty_name = function (self, arg_17_1)
	-- function 17
	self:_set_widget_text("game_difficulty", arg_17_1)
end

IngamePlayerListUI._set_widget_text = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	arg_18_0._widgets_by_name[arg_18_1].content.text = arg_18_2
end

IngamePlayerListUI._set_simple_widget_texture = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	arg_19_0._widgets_by_name[arg_19_1].content.texture_id = arg_19_2
end

IngamePlayerListUI._add_player = function (self, arg_20_1)
	-- function 20
	local local_player = arg_20_1.local_player
	local bot_player = arg_20_1.bot_player

	bot_player = bot_player or not arg_20_1:is_player_controlled()

	local ui_id = arg_20_1:ui_id()
	local get_player_level = ExperienceSettings.get_player_level(arg_20_1)
	local network_id = arg_20_1:network_id()
	local flag = self._host_peer_id == network_id
	local tbl = {
		unit_spawned = false,
		is_local_player = local_player,
		is_bot_player = bot_player,
		peer_id = network_id,
		ui_id = ui_id,
		local_player_id = arg_20_1:local_player_id(),
		player = arg_20_1,
		player_name = arg_20_1:name(),
		level = get_player_level or "n/a",
		resync_player_level = not get_player_level,
		is_server = flag,
		unit_equipment = {}
	}

	self._num_players = self._num_players + 1
	self._players[self._num_players] = tbl

	local var_20_7
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}

	for k, v in pairs(self._players) do
		if not (not v.is_server and v.is_bot_player) then
			var_20_7 = v
		elseif not v.is_bot_player then
			tbl_3[#tbl_3 + 1] = v
		else
			tbl_2[#tbl_2 + 1] = v
		end
	end

	local function fn(self, arg_21_1)
		-- function 21
		return self.peer_id > arg_21_1.peer_id
	end

	table.sort(tbl_2, fn)

	local function fn_2(self, arg_22_1)
		-- function 22
		return self.local_player_id > arg_22_1.local_player_id
	end

	table.sort(tbl_3, fn_2)

	tbl_4[#tbl_4 + 1] = var_20_7

	table.append(tbl_4, tbl_2)
	table.append(tbl_4, tbl_3)

	self._players = tbl_4
end

IngamePlayerListUI._update_widgets = function (self)
	-- function 23
	local _players = self._players
	local _num_players = self._num_players
	local vote_kick_enabled = Managers.state.voting:vote_kick_enabled()
	local leader = Managers.party:leader()

	for i = 1, _num_players do
		local var_23_4 = _players[i]
		local peer_id = var_23_4.peer_id
		local is_local_player = var_23_4.is_local_player
		local is_bot_player = var_23_4.is_bot_player
		local flag = peer_id ~= leader or not is_bot_player
		local is_server = var_23_4.is_server
		local flag_2 = not vote_kick_enabled and self:kick_player_available(var_23_4)
		local flag_3 = not not flag or not not is_server or flag_2 or self:_can_host_solo_kick()
		local var_23_12 = self._player_list_widgets[i]
		local content = var_23_12.content

		content.show_host = flag
		content.is_local_player = is_local_player
		content.is_bot_player = is_bot_player

		if is_local_player or not is_bot_player then
			content.show_chat_button = false
			content.show_kick_button = false
			content.show_voice_button = false
			content.show_profile_button = not is_local_player and not is_bot_player
			content.show_ping = not not is_server or not is_bot_player
			content.chat_button_hotspot.disable_button = true
			content.kick_button_hotspot.disable_button = true
			content.voice_button_hotspot.disable_button = true
			content.profile_button_hotspot.disable_button = is_bot_player
		else
			if not flag_3 then
				content.show_kick_button = true
				content.kick_button_hotspot.disable_button = false
			else
				content.show_kick_button = false
				content.kick_button_hotspot.disable_button = true
			end

			content.show_profile_button = true
			content.show_chat_button = not IS_PS4
			content.show_voice_button = true
			content.show_ping = not is_server
			content.profile_button_hotspot.disable_button = false
			content.chat_button_hotspot.disable_button = IS_PS4
			content.voice_button_hotspot.disable_button = false
			content.chat_button_hotspot.is_selected = self:_ignoring_chat_peer_id(peer_id)
			content.voice_button_hotspot.is_selected = self:_muted_peer_id(peer_id)
		end

		local player_name = var_23_4.player_name
		local crop_text_width

		if Utf8.length(player_name) > num then
			crop_text_width = UIRenderer.crop_text_width(self._ui_top_renderer, player_name, 370, var_23_12.style.name)

			if not crop_text_width then
				-- Nothing
			end
		end

		crop_text_width = player_name

		::label_23_0::

		var_23_4.player_name = crop_text_width
		var_23_4.widget = var_23_12
	end
end

local tbl_3 = {
	slot_ranged = "slot_melee",
	slot_melee = "slot_ranged"
}

IngamePlayerListUI._update_player_information = function (self, arg_24_1, arg_24_2)
	-- function 24
	local SPProfiles = SPProfiles
	local _profile_synchronizer = self._profile_synchronizer
	local _players = self._players
	local _num_players = self._num_players
	local num = 20
	local num_2 = (_num_players - 1) * num
	local var_24_6 = PLAYER_LIST_SIZE[2]
	local num_3 = var_24_6 * _num_players + num_2
	local system = Managers.state.entity:system("cosmetic_system")

	for i = 1, _num_players do
		local var_24_9 = _players[i]
		local player = var_24_9.player
		local widget = var_24_9.widget
		local offset = widget.offset

		offset[2] = -(var_24_6 * (i - 1) + num * (i - 1))

		local profile_index = player:profile_index()
		local career_index = player:career_index()
		local var_24_15 = SPProfiles[profile_index]
		local display_name

		if not var_24_15 then
			display_name = var_24_15.display_name

			if not display_name then
				-- Nothing
			end
		end

		display_name = "unspawned"

		do
			local ingame_display_name
		end

		::label_24_0::

		if not var_24_15 then
			ingame_display_name = var_24_15.ingame_display_name

			if not ingame_display_name then
				-- Nothing
			end
		end

		ingame_display_name = "unspawned"

		::label_24_1::

		local name = widget.style.name

		widget.content.name = UIRenderer.crop_text_width(self._ui_renderer, var_24_9.player_name, name.size[1], name)

		if not var_24_9.resync_player_level then
			local get_player_level = ExperienceSettings.get_player_level(player)

			if not get_player_level then
				var_24_9.level = get_player_level
				var_24_9.resync_player_level = nil
			end
		end

		local flag = not var_24_15 and var_24_15.careers[career_index]

		if not flag then
			local name_2 = flag.name
			local portrait_image = flag.portrait_image
			local str

			if not var_24_9.is_bot_player then
				str = "BOT"
			else
				if not var_24_9.level then
					str = tostring(var_24_9.level)

					if not str then
						-- Nothing
					end
				end

				str = "-"
			end

			::label_24_2::

			local var_24_24
			local var_24_25
			local player_2 = var_24_9.player
			local player_unit = player_2.player_unit

			if not ALIVE[player_unit] and not var_24_9.is_bot_player then
				var_24_25 = Managers.state.entity:system("cosmetic_system"):get_equipped_frame(player_unit)
			else
				var_24_24 = CosmeticUtils.get_cosmetic_slot(player_2, "slot_frame")
			end

			if not var_24_25 then
				-- Nothing
			end

			do
				local item_name
			end

			::label_24_3::

			if not var_24_24 then
				item_name = var_24_24.item_name

				if not item_name then
					-- Nothing
				end
			end

			item_name = "default"

			::label_24_4::

			local portrait_frame = var_24_9.portrait_frame

			portrait_frame = not portrait_frame and var_24_9.portrait_frame.item_name

			if not (var_24_9.career_index ~= career_index or display_name ~= var_24_9.hero_name or str ~= var_24_9.player_level_text or item_name == portrait_frame) then
				var_24_9.career_index = career_index

				local _create_portrait_frame_widget = self:_create_portrait_frame_widget(item_name, portrait_image, str)
				local _create_insignia_widget = self:_create_insignia_widget(var_24_9)
				local color = widget.style.background.color
				local var_24_33 = Colors.color_definitions[name_2]

				color[2] = var_24_33[2]
				color[3] = var_24_33[3]
				color[4] = var_24_33[4]
				var_24_9.player_level_text = str
				var_24_9.portrait_widget = _create_portrait_frame_widget
				var_24_9.hero_name = display_name
				var_24_9.portrait_frame = var_24_24
				var_24_9.insignia_widget = _create_insignia_widget

				if not var_24_9.is_local_player then
					var_24_9.sync_local_player_info = true
				end
			end

			local portrait_widget = var_24_9.portrait_widget

			if not portrait_widget then
				portrait_widget.offset[2] = offset[2]
			end

			local insignia_widget = var_24_9.insignia_widget

			if not insignia_widget then
				insignia_widget.offset[2] = offset[2]
			end

			local display_name_2 = flag.display_name

			widget.content.hero = display_name_2

			if not var_24_9.sync_local_player_info then
				var_24_9.sync_local_player_info = nil

				local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(flag)
				local get_ability_data_by_career = CareerUtils.get_ability_data_by_career(flag, 1)
				local display_name_3 = get_ability_data_by_career.display_name
				local icon = get_ability_data_by_career.icon

				self:_set_widget_text("player_ability_name", Localize(display_name_3))
				self:_set_widget_text("player_ability_description", UIUtils.get_ability_description(get_ability_data_by_career))
				self:_set_simple_widget_texture("player_ability_icon", icon)

				local display_name_4 = get_passive_ability_by_career.display_name
				local icon_2 = get_passive_ability_by_career.icon

				self:_set_widget_text("player_passive_name", Localize(display_name_4))
				self:_set_widget_text("player_passive_description", UIUtils.get_ability_description(get_passive_ability_by_career))
				self:_set_simple_widget_texture("player_passive_icon", icon_2)
				self:_set_widget_text("player_career_name", Localize(display_name_2))
				self:_create_player_portrait(item_name, portrait_image, str)
				self:_create_player_insignia(var_24_9)
				self:_set_widget_text("player_hero_name", Localize(ingame_display_name))
			end
		end
	end

	self:_update_dynamic_widget_information(arg_24_1, arg_24_2)
end

IngamePlayerListUI._create_portrait_frame_widget = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local create_portrait_frame = UIWidgets.create_portrait_frame("player_list_portrait", arg_25_1, arg_25_3, 1, nil, arg_25_2)
	local var_25_1 = UIWidget.init(create_portrait_frame, self._ui_top_renderer)

	var_25_1.content.frame_settings_name = arg_25_1

	return var_25_1
end

IngamePlayerListUI._create_insignia_widget = function (arg_26_0, arg_26_1)
	-- function 26
	if not arg_26_1.is_bot_player then
		return
	end

	local player = arg_26_1.player
	local get_versus_player_level = ExperienceSettings.get_versus_player_level(player)
	local create_small_insignia = UIWidgets.create_small_insignia("player_list_insignia", get_versus_player_level)

	return (UIWidget.init(create_small_insignia))
end

IngamePlayerListUI._get_ping_texture_by_ping_value = function (arg_27_0, arg_27_1)
	-- function 27
	if arg_27_1 <= 125 then
		return "ping_icon_01", "low_ping_color"
	elseif not (not (arg_27_1 > 125) or not (arg_27_1 <= 175)) then
		return "ping_icon_02", "medium_ping_color"
	elseif arg_27_1 > 175 then
		return "ping_icon_03", "high_ping_color"
	end
end

IngamePlayerListUI._ignoring_chat_peer_id = function (arg_28_0, arg_28_1)
	-- function 28
	if not IS_WINDOWS then
		return Managers.chat.chat_gui:ignoring_peer_id(arg_28_1)
	elseif not IS_XB1 then
		return Managers.chat:ignoring_peer_id(arg_28_1)
	end
end

IngamePlayerListUI._ignore_chat_message_from_peer_id = function (arg_29_0, arg_29_1)
	-- function 29
	if not IS_WINDOWS then
		Managers.chat.chat_gui:ignore_peer_id(arg_29_1)
	elseif not IS_XB1 then
		Managers.chat:ignore_peer_id(arg_29_1)
	end
end

IngamePlayerListUI._remove_ignore_chat_message_from_peer_id = function (arg_30_0, arg_30_1)
	-- function 30
	if not IS_WINDOWS then
		Managers.chat.chat_gui:remove_ignore_peer_id(arg_30_1)
	elseif not IS_XB1 then
		Managers.chat:remove_ignore_peer_id(arg_30_1)
	end
end

IngamePlayerListUI._muted_peer_id = function (self, arg_31_1)
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

IngamePlayerListUI._ignore_voice_message_from_peer_id = function (self, arg_32_1)
	-- function 32
	if not IS_XB1 then
		if not Managers.voice_chat then
			Managers.voice_chat:mute_peer(arg_32_1)
		end
	else
		self._voip:mute_member(arg_32_1)
	end
end

IngamePlayerListUI._remove_ignore_voice_message_from_peer_id = function (self, arg_33_1)
	-- function 33
	if not IS_XB1 then
		if not Managers.voice_chat then
			Managers.voice_chat:unmute_peer(arg_33_1)
		end
	else
		self._voip:unmute_member(arg_33_1)
	end
end

IngamePlayerListUI.post_update = function (arg_34_0, arg_34_1)
	-- function 34
	return
end

IngamePlayerListUI.update = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not RESOLUTION_LOOKUP.modified then
		self:_on_resolution_changed()
	end

	local _input_manager = self._input_manager
	local in_fade_active = Managers.transition:in_fade_active()
	local get_service = _input_manager:get_service("player_list_input")
	local _is_in_inn = self._is_in_inn

	_is_in_inn = not _is_in_inn and Managers.matchmaking:is_game_matchmaking()

	if (in_fade_active or get_service:get("ingame_player_list_exit") or get_service:get("ingame_player_list_toggle") or not get_service:get("back") or not self._active) and not self._cursor_active then
		self:_set_active(false)
	elseif not self._cursor_active then
		if not ((in_fade_active or not get_service:get("ingame_player_list_toggle")) and _is_in_inn) then
			if not self._active then
				self:_set_active(true)

				if not self._cursor_active then
					ShowCursorStack.show("IngamePlayerListUI")
					_input_manager:capture_input({
						"keyboard",
						"gamepad",
						"mouse"
					}, 1, "player_list_input", "IngamePlayerListUI")

					self._cursor_active = true
				end
			end
		elseif not (not get_service:get("ingame_player_list_pressed") and self:_is_in_deus_map_view()) then
			if not self._active then
				self:_set_active(true)
			end
		elseif not (not self._active and get_service:get("ingame_player_list_held")) then
			self:_set_active(false)
		end
	end

	if not self._active then
		if not (not get_service:get("activate_ingame_player_list") and self._cursor_active) then
			ShowCursorStack.show("IngamePlayerListUI")
			_input_manager:capture_input({
				"keyboard",
				"gamepad",
				"mouse"
			}, 1, "player_list_input", "IngamePlayerListUI")

			self._cursor_active = true
		end

		self:_update_player_list(arg_35_1, arg_35_2)

		if not self._show_difficulty then
			self:_update_difficulty()
		end

		self:_update_private_checkbox()
		self:_sync_missions()
		self:_update_fade_in_duration(arg_35_1)
		self:_draw(arg_35_1)
	end
end

IngamePlayerListUI._on_resolution_changed = function (self)
	-- function 36
	local banner_right_edge = self._static_widgets_by_name.banner_right_edge
	local banner_left_edge = self._static_widgets_by_name.banner_left_edge
	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	banner_right_edge.style.edge.texture_size[2] = inv_scale * RESOLUTION_LOOKUP.res_h
	banner_left_edge.style.edge.texture_size[2] = inv_scale * RESOLUTION_LOOKUP.res_h
end

IngamePlayerListUI._set_privacy_enabled = function (self, arg_37_1, arg_37_2)
	-- function 37
	local str = "map_screen_private_button"
	local _private_checkbox_widget = self._private_checkbox_widget

	_private_checkbox_widget.content.checked = arg_37_1
	_private_checkbox_widget.content.setting_text = str

	if not arg_37_2 then
		self._private_timer = 0
	end
end

IngamePlayerListUI.on_save_ended_callback = function (arg_38_0)
	-- function 38
	print("[IngamePlayerWiew] - settings saved")
end

IngamePlayerListUI.is_active = function (self)
	-- function 39
	return self._active
end

IngamePlayerListUI.is_focused = function (self)
	-- function 40
	local _active = self._active

	_active = not _active and self._cursor_active

	return _active
end

IngamePlayerListUI.input_service = function (self)
	-- function 41
	return self._input_manager:get_service("player_list_input")
end

IngamePlayerListUI.set_visible = function (self, arg_42_1)
	-- function 42
	if not (not self._active and arg_42_1) then
		self:_set_active(false)
	end
end

IngamePlayerListUI._set_active = function (self, arg_43_1)
	-- function 43
	local chat_gui = Managers.chat.chat_gui

	if not arg_43_1 then
		self:_on_resolution_changed()

		if not (not self._local_player.is_server and self._is_in_inn) then
			local is_game_private = Managers.matchmaking:is_game_private()

			self:_set_privacy_enabled(is_game_private)
		end

		local tbl = {
			deus = "area_selection_morris_name",
			deed = "start_game_window_mutator_title",
			tutorial = "lb_game_type_prologue",
			event = "start_game_window_event_title",
			["n/a"] = "lb_game_type_none",
			custom = "lb_game_type_custom"
		}
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local active_game_mode = Managers.matchmaking:active_game_mode()
		local lobby = Managers.state.network:lobby()
		local flag = not lobby and lobby:lobby_data("weave_quick_game") == "true" or Managers.venture.quickplay:is_quick_game()
		local mechanism_type_name = self._static_widgets_by_name.mechanism_type_name
		local mission_type_name = self._static_widgets_by_name.mission_type_name

		if current_mechanism_name == "weave" then
			active_game_mode = not flag and "lb_game_type_weave_quick_play" and "lb_game_type_custom"
			mechanism_type_name.content.text = Utf8.upper(Localize("lb_game_type_weave"))
			mission_type_name.content.text = Localize(active_game_mode)
		else
			local var_43_9 = MechanismSettings[current_mechanism_name]

			mechanism_type_name.content.text = Utf8.upper(Localize(var_43_9.display_name))

			if not flag then
				mission_type_name.content.text = Localize("lb_game_type_quick_play")
			else
				local content = mission_type_name.content
				local Localize = Localize
				local var_43_12 = tbl[active_game_mode]

				var_43_12 = var_43_12 or tbl["n/a"]
				content.text = Localize(var_43_12)
			end
		end

		self:_setup_mutator_data()
		self:_setup_deed_reward_data()
		self:_setup_chaos_wastes_info()
		Managers.input:enable_gamepad_cursor()
	else
		chat_gui:hide_chat()
		Managers.input:disable_gamepad_cursor()
	end

	self._active = arg_43_1

	if not arg_43_1 then
		self._fade_in_duration = 0
	end

	if not self._cursor_active then
		ShowCursorStack.hide("IngamePlayerListUI")

		local _input_manager = self._input_manager

		_input_manager:release_input({
			"keyboard",
			"gamepad",
			"mouse"
		}, 1, "player_list_input", "IngamePlayerListUI", true)
		_input_manager:device_unblock_service("keyboard", 1, "player_list_input")
		_input_manager:device_unblock_service("gamepad", 1, "player_list_input")
		_input_manager:device_unblock_service("mouse", 1, "player_list_input")

		self._cursor_active = false
	end

	Managers.state.event:trigger("ingame_player_list_enabled", arg_43_1, true)
end

IngamePlayerListUI._update_fade_in_duration = function (self, arg_44_1)
	-- function 44
	local _fade_in_duration = self._fade_in_duration

	if not _fade_in_duration then
		return
	end

	local num = _fade_in_duration + arg_44_1
	local min = math.min(num / 0.2, 1)
	local easeOutCubic = math.easeOutCubic(min)
	local _render_settings = self._render_settings
	local _ui_scenegraph = self._ui_scenegraph

	_render_settings.alpha_multiplier = min
	_ui_scenegraph.player_list.local_position[1] = -800 * (1 - easeOutCubic)
	_ui_scenegraph.banner_left.local_position[1] = -800 * (1 - easeOutCubic)
	_ui_scenegraph.banner_right.local_position[1] = 800 * (1 - easeOutCubic)

	if min == 1 then
		self._fade_in_duration = nil
	else
		self._fade_in_duration = num
	end
end

local tbl_4 = {}
local tbl_5 = {}

IngamePlayerListUI._update_player_list = function (self, arg_45_1, arg_45_2)
	-- function 45
	local game = Managers.state.network:game()

	table.clear(tbl_4)
	table.clear(tbl_5)

	local human_and_bot_players = Managers.player:human_and_bot_players()

	for k, v in pairs(human_and_bot_players) do
		tbl_5[v:ui_id()] = v
	end

	local flag = false
	local _players = self._players
	local _num_players = self._num_players
	local flag_2 = false

	for k_2 = _num_players, 1, -1 do
		local var_45_6 = _players[k_2]
		local peer_id = var_45_6.peer_id
		local ui_id = var_45_6.ui_id
		local var_45_9 = tbl_5[ui_id]

		if not var_45_9 then
			table.remove(_players, k_2)

			flag = true
			_num_players = _num_players - 1
		else
			local is_local_player = var_45_6.is_local_player
			local is_bot_player = var_45_6.is_bot_player
			local is_server = var_45_6.is_server
			local widget = var_45_6.widget
			local game_object_id = var_45_9.game_object_id

			tbl_4[ui_id] = true

			if (is_server or is_bot_player or not game) and not game_object_id then
				local game_object_field = GameSession.game_object_field(game, game_object_id, "ping")
				local _get_ping_texture_by_ping_value, var_45_17 = self:_get_ping_texture_by_ping_value(game_object_field)

				widget.content.ping_texture = _get_ping_texture_by_ping_value
				widget.content.ping_text = game_object_field

				local ping_text = widget.style.ping_text

				ping_text.text_color = ping_text[var_45_17]
			end

			if not is_bot_player then
				local profile_button_hotspot = widget.content.profile_button_hotspot

				if not profile_button_hotspot.on_pressed then
					profile_button_hotspot.on_pressed = nil

					self:_show_profile_by_peer_id(peer_id)
				end
			end

			if not is_local_player then
				local chat_button_hotspot = widget.content.chat_button_hotspot

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

				local voice_button_hotspot = widget.content.voice_button_hotspot

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

				local kick_button_hotspot = widget.content.kick_button_hotspot

				if is_server or not kick_button_hotspot.on_pressed then
					kick_button_hotspot.on_pressed = nil

					self:kick_player(var_45_6.player, arg_45_2)
				end
			end
		end

		if not self._kick_vote_cooldown then
			if arg_45_2 >= self._kick_vote_cooldown + num_2 then
				flag_2 = true
			end

			for l = _num_players, 1, -1 do
				local var_45_23 = _players[l]
				local widget_2 = var_45_23.widget
				local is_local_player_2 = var_45_23.is_local_player
				local is_bot_player_2 = var_45_23.is_bot_player
				local is_server_2 = var_45_23.is_server

				if not (is_local_player_2 or is_server_2 or is_bot_player_2) then
					widget_2.content.kick_button_hotspot.disable_button = not flag_2
					widget_2.content.show_kick_button = flag_2
				end
			end

			if not flag_2 then
				self._kick_vote_cooldown = nil
			end
		end
	end

	self._num_players = _num_players

	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local var_45_29 = GameModeSettings[game_mode_key]

	for k_3, v_2 in pairs(human_and_bot_players) do
		local player_unit = v_2.player_unit
		local allow_unspawned_players_in_tab_menu = var_45_29.allow_unspawned_players_in_tab_menu

		allow_unspawned_players_in_tab_menu = allow_unspawned_players_in_tab_menu or ALIVE[player_unit]

		if not (not allow_unspawned_players_in_tab_menu and tbl_4[v_2:ui_id()]) then
			self:_add_player(v_2)

			flag = true
		end
	end

	if not flag then
		self:_update_widgets()
	end

	self:_update_player_information(arg_45_1, arg_45_2)
end

local tbl_6 = {}

IngamePlayerListUI._update_dynamic_widget_information = function (self, arg_46_1, arg_46_2)
	-- function 46
	local game = Managers.state.network:game()

	self._item_tooltip.content.item = nil

	local _players = self._players
	local _profile_synchronizer = self._profile_synchronizer
	local SPProfiles = SPProfiles
	local _ui_scenegraph = self._ui_scenegraph
	local player_loadouts = Managers.player:player_loadouts()

	for i, v in ipairs(_players) do
		local player = v.player
		local player_unit = player.player_unit

		if not ALIVE[player_unit] then
			local go_id = Managers.state.unit_storage:go_id(player_unit)
			local extension = ScriptUnit.extension(player_unit, "health_system")
			local extension_2 = ScriptUnit.extension(player_unit, "status_system")
			local extension_3 = ScriptUnit.extension(player_unit, "buff_system")
			local extension_4 = ScriptUnit.extension(player_unit, "inventory_system")
			local get_max_health = extension:get_max_health()
			local flag

			flag = not extension_2:is_dead() and 0 and extension:current_health()

			local flag_2

			flag_2 = not extension_2:is_dead() and 0 and extension:current_health_percent()

			local flag_3

			flag_3 = not extension_2:is_dead() and 0 and extension:current_permanent_health_percent()

			if extension_2:is_knocked_down() or not extension_2:get_is_ledge_hanging() then
				local flag_4

				flag_4 = flag_2 > 0
			end

			local is_ready_for_assisted_respawn = extension_2:is_ready_for_assisted_respawn()

			if not (extension_2:is_grabbed_by_pack_master() or extension_2:is_hanging_from_hook() or extension_2:is_pounced_down() or extension_2:is_grabbed_by_corruptor() or extension_2:is_in_vortex()) then
				local is_grabbed_by_chaos_spawn = extension_2:is_grabbed_by_chaos_spawn()
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
			local var_46_33 = self._player_list_widgets[i]
			local style = var_46_33.style
			local content = var_46_33.content
			local health_bar = style.health_bar
			local total_health_bar = style.total_health_bar
			local grimoire_bar = style.grimoire_bar
			local grimoire_debuff_divider = style.grimoire_debuff_divider
			local ability_bar = content.ability_bar

			if not game and not go_id then
				local game_object_field = GameSession.game_object_field(game, go_id, "ability_percentage")

				game_object_field = game_object_field or 0
				ability_bar.bar_value = 1 - game_object_field
			end

			health_bar.gradient_threshold = flag_3 * num
			total_health_bar.gradient_threshold = flag_2 * num
			grimoire_bar.grimoire_debuff = 1 - num
			grimoire_debuff_divider.grimoire_debuff = 1 - num

			local unique_id = player:unique_id()
			local profile_by_peer, var_46_44 = _profile_synchronizer:profile_by_peer(v.peer_id, v.local_player_id)
			local var_46_45 = SPProfiles[profile_by_peer]
			local var_46_46 = player_loadouts[unique_id]

			var_46_46 = var_46_46 or tbl_6

			local equipment = extension_4:equipment()
			local flag_5 = true

			if player.local_player or not player.bot_player or not player.is_server then
				flag_5 = true
			else
				local get_data = player:get_data("playerlist_build_privacy")

				if get_data == PrivacyLevels.friends then
					local var_46_50 = rawget(_G, "Friends")

					flag_5 = not var_46_50 and var_46_50.in_category(v.peer_id, var_46_50.FRIEND_FLAG)
				elseif get_data == PrivacyLevels.private then
					flag_5 = false
				end
			end

			content.is_build_visible = flag_5

			for k, v_2 in pairs(var_46_46) do
				local rarity = v_2.rarity

				if not rarity then
					if not v_2.data then
						rarity = v_2.data.rarity

						if not rarity then
							-- Nothing
						end
					end

					rarity = "plentiful"
				end

				::label_46_0::

				local get_ui_information_from_item = UIUtils.get_ui_information_from_item(v_2)

				if not flag_5 then
					rarity, get_ui_information_from_item = nil
				end

				content[k] = get_ui_information_from_item
				content[k .. "_rarity_texture"] = not rarity and UISettings.item_rarity_textures[rarity]

				if not UIUtils.is_button_hover(var_46_33, k .. "_hotspot") then
					self:_update_item_tooltip_widget(v_2, var_46_33.offset)
				end
			end

			local has_extension = ScriptUnit.has_extension(player_unit, "talent_system")

			if not has_extension then
				local get_talent_ids = has_extension:get_talent_ids()
				local profile_display_name = player:profile_display_name()

				for i4 = 1, 6 do
					local var_46_56 = get_talent_ids[i4]
					local get_talent_by_id = TalentUtils.get_talent_by_id(profile_display_name, var_46_56)
					local flag_6 = not get_talent_by_id and get_talent_by_id.icon
					local var_46_59 = content["talent_" .. i4]

					if not (not flag_5 and flag_6) then
						get_talent_by_id = nil
					end

					var_46_59.talent = get_talent_by_id
					var_46_59.icon = flag_6 or "icons_placeholder"

					if not var_46_59.is_hover then
						_ui_scenegraph.talent_tooltip.local_position[2] = var_46_33.offset[2]
					end
				end
			end
		end
	end
end

local tbl_7 = {
	alpha_multiplier = 0
}

IngamePlayerListUI._update_item_tooltip_widget = function (self, arg_47_1, arg_47_2)
	-- function 47
	local _ui_scenegraph = self._ui_scenegraph
	local _ui_renderer = self._ui_renderer
	local _item_tooltip = self._item_tooltip
	local style = _item_tooltip.style

	_item_tooltip.content.item = arg_47_1

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, FAKE_INPUT_SERVICE, 0, nil, tbl_7)
	UIRenderer.draw_widget(_ui_renderer, _item_tooltip)
	UIRenderer.end_pass(_ui_renderer)

	local num = style.item.item_presentation_height - 100
	local num_2 = 1080 - num

	_ui_scenegraph.item_tooltip.local_position[2] = math.min(arg_47_2[2] + num, num_2)
end

IngamePlayerListUI._update_difficulty = function (self)
	-- function 48
	local display_name = Managers.state.difficulty:get_difficulty_settings().display_name

	if display_name ~= self._current_difficulty_name then
		self:_set_difficulty_name(Localize(display_name))

		self._current_difficulty_name = display_name
	end
end

IngamePlayerListUI._update_private_checkbox = function (self)
	-- function 49
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local human_players = Managers.player:human_players()
	local players_below_required_power_level = DifficultyManager.players_below_required_power_level(get_difficulty, human_players)

	self._private_checkbox_disabled_reasons.power_level = not table.is_empty(players_below_required_power_level) and nil

	local content = self._private_checkbox_widget.content

	content.is_disabled = not table.is_empty(self._private_checkbox_disabled_reasons)

	if not (not self._local_player.is_server and self._is_in_inn or content.is_disabled) then
		local button_hotspot = content.button_hotspot

		if not button_hotspot.on_hover_enter then
			WwiseWorld.trigger_event(self._wwise_world, "Play_hud_hover")
		end

		if not self._private_setting_enabled and not button_hotspot.on_release then
			local is_game_private = Managers.matchmaking:is_game_private()
			local _map_save_data = self._map_save_data

			_map_save_data.private_enabled = not is_game_private

			WwiseWorld.trigger_event(self._wwise_world, "Play_hud_select")
			self:_set_privacy_enabled(_map_save_data.private_enabled, true)

			PlayerData.map_view_data = _map_save_data

			Managers.save:auto_save(SaveFileName, SaveData, callback(self, "on_save_ended_callback"))
			Managers.matchmaking:set_in_progress_game_privacy(_map_save_data.private_enabled)
		end
	end
end

IngamePlayerListUI._draw = function (self, arg_50_1)
	-- function 50
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_manager = self._input_manager
	local get_service = _input_manager:get_service("player_list_input")
	local is_device_active = _input_manager:is_device_active("gamepad")
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_50_1, nil, _render_settings)

	if not (is_device_active or self._cursor_active) then
		UIRenderer.draw_widget(_ui_top_renderer, self._input_description_text_widget)
	end

	if self._num_rewards > 0 then
		UIRenderer.draw_widget(_ui_top_renderer, self._reward_header_widget)
		UIRenderer.draw_widget(_ui_top_renderer, self._reward_divider_widget)
	end

	if self._mission_count > 0 then
		UIRenderer.draw_widget(_ui_top_renderer, self._collectibles_name)
		UIRenderer.draw_widget(_ui_top_renderer, self._collectibles_divider)
	end

	if self._num_mutators == 0 then
		UIRenderer.draw_widget(_ui_top_renderer, self._level_description_widget)
	end

	if not self._node_info_widget then
		UIRenderer.draw_widget(_ui_top_renderer, self._node_info_widget)
	end

	for i, v in ipairs(self._reward_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	local _weave_objective_widgets = self._weave_objective_widgets

	if not _weave_objective_widgets then
		for k = 1, #_weave_objective_widgets do
			local var_50_8 = _weave_objective_widgets[k]

			UIRenderer.draw_widget(_ui_top_renderer, var_50_8)
		end
	end

	local _player_portrait_widget = self._player_portrait_widget

	if not _player_portrait_widget then
		UIRenderer.draw_widget(_ui_top_renderer, _player_portrait_widget)
	end

	local _player_insignia_widget = self._player_insignia_widget

	if not _player_insignia_widget then
		UIRenderer.draw_widget(_ui_top_renderer, _player_insignia_widget)
	end

	local _static_widgets = self._static_widgets

	if not _static_widgets then
		for l = 1, #_static_widgets do
			local var_50_12 = _static_widgets[l]

			UIRenderer.draw_widget(_ui_top_renderer, var_50_12)
		end
	end

	local _widgets = self._widgets

	if not _widgets then
		for i4 = 1, #_widgets do
			local var_50_14 = _widgets[i4]

			UIRenderer.draw_widget(_ui_top_renderer, var_50_14)
		end
	end

	UIRenderer.draw_widget(_ui_top_renderer, self._item_tooltip)

	if not self._private_setting_enabled then
		UIRenderer.draw_widget(_ui_top_renderer, self._private_checkbox_widget)
	end

	if not is_device_active then
		UIRenderer.draw_widget(_ui_top_renderer, self._console_cursor)
	end

	local _players = self._players
	local _num_players = self._num_players

	for i5 = 1, _num_players do
		local var_50_17 = _players[i5]
		local widget = var_50_17.widget

		UIRenderer.draw_widget(_ui_top_renderer, widget)

		local portrait_widget = var_50_17.portrait_widget

		if not portrait_widget then
			UIRenderer.draw_widget(_ui_top_renderer, portrait_widget)
		end

		local flag = Managers.mechanism:current_mechanism_name() == "versus"
		local insignia_widget = var_50_17.insignia_widget

		if not insignia_widget and flag and not Application.user_setting("toggle_versus_level_in_all_game_modes") then
			UIRenderer.draw_widget(_ui_top_renderer, insignia_widget)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

IngamePlayerListUI._can_host_solo_kick = function (self)
	-- function 51
	local _is_server = self._is_server

	_is_server = not _is_server and Managers.player:num_human_players() == 2

	return _is_server
end

IngamePlayerListUI.kick_player = function (self, arg_52_1, arg_52_2)
	-- function 52
	local peer_id = arg_52_1.peer_id

	if not self:_can_host_solo_kick() then
		self._network_server:kick_peer(peer_id)
	else
		local tbl = {
			kick_peer_id = peer_id
		}

		Managers.state.voting:request_vote("kick_player", tbl, Network.peer_id())

		self._kick_vote_cooldown = arg_52_2

		self:_set_active(false)
	end
end

IngamePlayerListUI.kick_player_available = function (arg_53_0, arg_53_1)
	-- function 53
	local peer_id = arg_53_1.peer_id

	if not (not peer_id and peer_id ~= Network.peer_id()) then
		return false
	end

	tbl.kick_peer_id = peer_id

	if not Managers.state.voting:can_start_vote("kick_player", tbl) then
		return false
	end

	return true
end

IngamePlayerListUI._show_profile_by_peer_id = function (self, arg_54_1)
	-- function 54
	local _platform = self._platform

	if not IS_WINDOWS and not rawget(_G, "Steam") then
		local id_hex_to_dec = Steam.id_hex_to_dec(arg_54_1)
		local str = "http://steamcommunity.com/profiles/" .. id_hex_to_dec

		Steam.open_url(str)
	elseif not IS_XB1 then
		local xuid = self._network_lobby:xuid(arg_54_1)

		if not xuid then
			XboxLive.show_gamercard(Managers.account:user_id(), xuid)
		end
	elseif not IS_PS4 then
		Managers.account:show_player_profile_with_account_id(arg_54_1)
	end
end

IngamePlayerListUI.event_weave_objective_synced = function (self)
	-- function 55
	self:_setup_weave_display_info()
end

IngamePlayerListUI._is_in_deus_map_view = function (arg_56_0)
	-- function 56
	if Managers.mechanism:current_mechanism_name() ~= "deus" then
		return false
	end

	return Managers.mechanism:get_state() == "map_deus"
end
