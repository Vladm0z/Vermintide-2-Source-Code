-- chunkname: @scripts/ui/views/ingame_player_list_ui_v2.lua

require("scripts/ui/views/character_inspect_ui")

local var_0_0 = local_require("scripts/ui/views/ingame_player_list_ui_v2_definitions")
local var_0_1 = var_0_0.console_cursor_definition
local var_0_2 = var_0_0.PLAYER_LIST_SIZE
local var_0_3 = 16
local var_0_4 = 60
local var_0_5 = {}
local var_0_6 = {
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

function IngamePlayerListUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_2.ui_top_renderer
	arg_1_0._ingame_ui = arg_1_2.ingame_ui
	arg_1_0._wwise_world = arg_1_2.dialogue_system.wwise_world
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._player_manager = arg_1_2.player_manager
	arg_1_0._profile_synchronizer = arg_1_2.profile_synchronizer
	arg_1_0._is_in_inn = arg_1_2.is_in_inn
	arg_1_0._voip = arg_1_2.voip
	arg_1_0._is_server = arg_1_2.is_server
	arg_1_0._network_server = arg_1_2.network_server
	arg_1_0._network_lobby = arg_1_2.network_lobby
	arg_1_0._local_player = arg_1_0._player_manager:local_player()
	arg_1_0._map_save_data = PlayerData.map_view_data or {}
	arg_1_0._platform = PLATFORM
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._active = false
	arg_1_0._mission_system = Managers.state.entity:system("mission_system")

	local var_1_0 = arg_1_0._input_manager

	var_1_0:create_input_service("player_list_input", "IngamePlayerListKeymaps", "IngamePlayerListFilters")
	var_1_0:map_device_to_service("player_list_input", "keyboard")
	var_1_0:map_device_to_service("player_list_input", "mouse")
	var_1_0:map_device_to_service("player_list_input", "gamepad")
	arg_1_0:_create_ui_elements()

	local var_1_1 = Managers.state.game_mode:settings()

	arg_1_0._private_setting_enabled = not var_1_1.private_only and not arg_1_0._is_in_inn and arg_1_0._local_player.is_server and arg_1_0._platform ~= "xb1"

	local var_1_2 = Managers.state.network.network_transmit

	arg_1_0._host_peer_id = var_1_2.server_peer_id or var_1_2.peer_id
	arg_1_0._show_difficulty = not var_1_1.hide_difficulty

	if not arg_1_0._show_difficulty then
		arg_1_0:_set_difficulty_name("")
	end

	arg_1_0._kick_vote_cooldown = nil

	arg_1_0:_setup_weave_display_info()
	Managers.state.event:register(arg_1_0, "weave_objective_synced", "event_weave_objective_synced")
end

function IngamePlayerListUI._create_ui_elements(arg_2_0)
	arg_2_0._num_players = 0
	arg_2_0._num_rewards = 0
	arg_2_0._mission_count = 0
	arg_2_0._num_mutators = 0
	arg_2_0._players = {}
	arg_2_0._current_difficulty_name = nil
	arg_2_0._reward_widgets = {}

	local var_2_0 = var_0_0.scenegraph_definition

	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_2_0)

	local var_2_1 = var_0_0.static_widget_definitions
	local var_2_2 = {}
	local var_2_3 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		local var_2_4 = UIWidget.init(iter_2_1)

		var_2_2[#var_2_2 + 1] = var_2_4
		var_2_3[iter_2_0] = var_2_4
	end

	arg_2_0._static_widgets = var_2_2
	arg_2_0._static_widgets_by_name = var_2_3

	local var_2_5 = var_0_0.widget_definitions
	local var_2_6 = {}
	local var_2_7 = {}

	for iter_2_2, iter_2_3 in pairs(var_2_5) do
		local var_2_8 = UIWidget.init(iter_2_3)

		var_2_6[#var_2_6 + 1] = var_2_8
		var_2_7[iter_2_2] = var_2_8
	end

	arg_2_0._widgets = var_2_6
	arg_2_0._widgets_by_name = var_2_7
	var_2_7.mutator_summary1.content.item = {
		mutators = {}
	}
	var_2_7.mutator_summary2.content.item = {
		mutators = {}
	}
	var_2_7.mutator_summary3.content.item = {
		mutators = {}
	}
	var_2_7.mutator_summary4.content.item = {
		mutators = {}
	}
	var_2_7.mutator_summary5.content.item = {
		mutators = {}
	}
	var_2_7.mutator_summary6.content.item = {
		mutators = {}
	}

	local var_2_9 = var_0_0.specific_widget_definitions

	arg_2_0._input_description_text_widget = UIWidget.init(var_2_9.input_description_text)
	arg_2_0._reward_header_widget = UIWidget.init(var_2_9.reward_header)
	arg_2_0._reward_divider_widget = UIWidget.init(var_2_9.reward_divider)
	arg_2_0._collectibles_name = UIWidget.init(var_2_9.collectibles_name)
	arg_2_0._collectibles_divider = UIWidget.init(var_2_9.collectibles_divider)
	arg_2_0._level_description_widget = UIWidget.init(var_2_9.level_description)
	arg_2_0._private_checkbox_widget = UIWidget.init(var_2_9.private_checkbox)
	arg_2_0._private_checkbox_disabled_reasons = {}
	arg_2_0._node_info_widget = nil

	local var_2_10 = Managers.twitch and (Managers.twitch:is_connected() or Managers.twitch:is_activated())

	if Managers.state.game_mode:game_mode_key() == "weave" or var_2_10 then
		arg_2_0._private_checkbox_disabled_reasons.weave_or_twitch = true
	end

	local var_2_11 = {}

	for iter_2_4 = 1, 8 do
		var_2_11[iter_2_4] = UIWidget.init(var_0_0.player_widget_definition(iter_2_4))
	end

	arg_2_0._player_list_widgets = var_2_11
	arg_2_0._popup_list = UIWidget.init(var_0_0.popup_widget_definition)
	arg_2_0._console_cursor = UIWidget.init(var_0_1)
	arg_2_0._item_tooltip = UIWidget.init(var_0_0.item_tooltip)

	local var_2_12 = Managers.level_transition_handler:get_current_level_keys()
	local var_2_13 = LevelSettings[var_2_12]

	arg_2_0:_set_level_name(Localize(var_2_13.display_name))
	arg_2_0:_setup_mission_data(var_2_13)

	if var_2_13.description_text then
		arg_2_0._level_description_widget.content.text = Localize(var_2_13.description_text)
	end
end

local var_0_7 = 1
local var_0_8 = 6
local var_0_9 = var_0_7 * var_0_8

function IngamePlayerListUI._setup_mutator_data(arg_3_0)
	local var_3_0 = LevelHelper:current_level_settings()
	local var_3_1

	if var_3_0.hub_level then
		var_3_1 = Managers.deed:mutators()
		var_3_1 = var_3_1 and table.set(var_3_1)
	else
		var_3_1 = Managers.state.game_mode:activated_mutators()
	end

	local var_3_2 = arg_3_0._widgets_by_name
	local var_3_3 = var_3_2.mutator_summary1.content.item.mutators

	table.clear(var_3_3)

	local var_3_4 = var_3_2.mutator_summary2.content.item.mutators

	table.clear(var_3_4)

	local var_3_5 = var_3_2.mutator_summary3.content.item.mutators

	table.clear(var_3_5)

	local var_3_6 = var_3_2.mutator_summary4.content.item.mutators

	table.clear(var_3_6)

	local var_3_7 = var_3_2.mutator_summary5.content.item.mutators

	table.clear(var_3_7)

	local var_3_8 = var_3_2.mutator_summary6.content.item.mutators

	table.clear(var_3_8)

	local var_3_9 = {
		var_3_3,
		var_3_4,
		var_3_5,
		var_3_6,
		var_3_7,
		var_3_8
	}

	if var_3_1 then
		local var_3_10 = 0
		local var_3_11 = 1

		for iter_3_0, iter_3_1 in pairs(var_3_1) do
			if not (type(iter_3_1) == "table" and iter_3_1.activated_by_twitch) and not MutatorTemplates[iter_3_0].hide_from_player_ui then
				local var_3_12 = 1 + math.floor((var_3_11 - 1) / var_0_7) % var_0_8

				if var_3_11 > var_0_9 then
					break
				end

				local var_3_13 = var_3_9[var_3_12]

				var_3_13[#var_3_13 + 1] = iter_3_0
				var_3_11 = var_3_11 + 1
				var_3_10 = var_3_10 + 1
			end
		end

		arg_3_0._num_mutators = var_3_10
	end
end

function IngamePlayerListUI._get_deus_current_node(arg_4_0)
	if Managers.state.game_mode:game_mode_key() ~= "deus" then
		return
	end

	if Managers.mechanism:current_mechanism_name() ~= "deus" then
		return
	end

	local var_4_0 = Managers.mechanism:game_mechanism()

	return (var_4_0 and var_4_0:get_deus_run_controller()):get_current_node()
end

function IngamePlayerListUI._setup_chaos_wastes_info(arg_5_0)
	local var_5_0 = arg_5_0:_get_deus_current_node()

	if not var_5_0 then
		return
	end

	local var_5_1 = var_5_0.theme
	local var_5_2 = var_5_0.minor_modifier_group
	local var_5_3 = var_5_0.terror_event_power_up
	local var_5_4 = var_5_0.conflict_settings
	local var_5_5, var_5_6 = arg_5_0._profile_synchronizer:profile_by_peer(Network.peer_id(), 1)
	local var_5_7 = UIWidget.init(var_0_0.create_node_info_widget())

	var_5_7.content.visible = true

	local var_5_8 = var_5_7.content.node_info
	local var_5_9 = Managers.level_transition_handler:get_current_level_keys()
	local var_5_10 = LevelSettings[var_5_9]

	if not var_5_1 or var_5_1 == "wastes" then
		var_5_8.curse_text = ""
	else
		var_5_8.curse_text = Localize("deus_map_node_info_god_" .. var_5_1)
		var_5_8.curse_icon = "deus_icons_map_" .. var_5_1
		var_5_7.style.node_info.curse_section.curse_icon.color = Colors.get_color_table_with_alpha(var_5_1, 255)
		var_5_7.style.node_info.curse_section.curse_text.text_color = Colors.get_color_table_with_alpha(var_5_1, 255)
	end

	if var_5_2 then
		var_5_8.minor_modifier_1_section.text = var_5_2[1] and Localize("mutator_" .. var_5_2[1] .. "_name") or ""
		var_5_8.minor_modifier_2_section.text = var_5_2[2] and Localize("mutator_" .. var_5_2[2] .. "_name") or ""
		var_5_8.minor_modifier_3_section.text = var_5_2[3] and Localize("mutator_" .. var_5_2[3] .. "_name") or ""
	else
		var_5_8.minor_modifier_1_section.text = ""
		var_5_8.minor_modifier_2_section.text = ""
		var_5_8.minor_modifier_3_section.text = ""
	end

	if var_5_3 then
		local var_5_11 = DeusPowerUpTemplates[var_5_3]
		local var_5_12 = DeusPowerUpUtils.get_power_up_name_text(var_5_3, var_5_11.talent_index, var_5_11.talent_tier, var_5_5, var_5_6)
		local var_5_13 = Localize("terror_event_power_up_prefix_suffix")
		local var_5_14 = string.format(var_5_13, var_5_12)

		var_5_7.content.node_info.terror_event_power_up_text = var_5_14
		var_5_7.content.node_info.terror_event_power_up_icon = var_5_11.icon
	else
		var_5_8.terror_event_power_up_text = ""
	end

	local var_5_15 = ConflictDirectors[var_5_4]
	local var_5_16 = var_5_15 and var_5_15.description

	if var_5_16 then
		var_5_8.breed_text = Localize(var_5_16) or ""
	else
		var_5_8.breed_text = ""
	end

	arg_5_0._node_info_widget = var_5_7

	local var_5_17 = 30

	if var_5_10.description_text and arg_5_0._num_mutators == 0 then
		local var_5_18 = arg_5_0._level_description_widget
		local var_5_19 = var_5_18.content
		local var_5_20 = var_5_18.style
		local var_5_21 = var_5_20.level_description_text
		local var_5_22, var_5_23 = UIFontByResolution(var_5_21)
		local var_5_24, var_5_25 = UIRenderer.text_size(arg_5_0._ui_renderer, var_5_19.description_text, var_5_22[1], var_5_23)
		local var_5_26 = var_5_20.level_description_text
		local var_5_27, var_5_28 = UIFontByResolution(var_5_26)
		local var_5_29 = UIRenderer.word_wrap(arg_5_0._ui_renderer, var_5_19.text, var_5_27[1], var_5_26.font_size, var_5_26.area_size[1])
		local var_5_30 = var_5_25

		for iter_5_0 = 1, #var_5_29 do
			local var_5_31, var_5_32 = UIRenderer.text_size(arg_5_0._ui_renderer, var_5_29[iter_5_0], var_5_27[1], var_5_28)

			var_5_30 = var_5_30 + var_5_32
		end

		local var_5_33 = 60

		var_5_7.offset[2] = -var_5_30 - var_5_33 - var_5_17
	else
		var_5_7.offset[2] = arg_5_0._num_mutators * -100 - var_5_17
	end
end

function IngamePlayerListUI._setup_deed_reward_data(arg_6_0, arg_6_1)
	table.clear(arg_6_0._reward_widgets)

	arg_6_0._num_rewards = 0

	local var_6_0 = Managers.deed:rewards()

	if not var_6_0 then
		return
	end

	local var_6_1 = 60
	local var_6_2 = 20
	local var_6_3 = 0

	for iter_6_0 = 1, #var_6_0 do
		local var_6_4 = var_6_0[iter_6_0]
		local var_6_5 = ItemMasterList[var_6_4]
		local var_6_6 = {
			data = var_6_5
		}
		local var_6_7 = UIWidget.init(var_0_0.create_reward_item(var_6_3, var_6_6))

		arg_6_0._reward_widgets[#arg_6_0._reward_widgets + 1] = var_6_7
		var_6_3 = var_6_3 + var_6_1 + var_6_2
	end

	local var_6_8 = #var_6_0
	local var_6_9 = ((var_6_8 - 1) * var_6_1 + var_6_2 * (var_6_8 - 1)) * -0.5

	arg_6_0._ui_scenegraph.reward_item.offset[1] = var_6_9
	arg_6_0._num_rewards = var_6_8
end

function IngamePlayerListUI._setup_mission_data(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.loot_objectives

	if not var_7_0 then
		return
	end

	local var_7_1 = arg_7_0._ui_renderer
	local var_7_2 = var_0_0.create_loot_widget
	local var_7_3 = arg_7_0._widgets
	local var_7_4 = arg_7_0._widgets_by_name
	local var_7_5 = {}
	local var_7_6 = 2
	local var_7_7 = 0
	local var_7_8 = 0
	local var_7_9 = 0
	local var_7_10 = 0
	local var_7_11 = 0

	for iter_7_0, iter_7_1 in ipairs(var_0_6) do
		local var_7_12 = iter_7_1.key
		local var_7_13 = var_7_0[var_7_12]

		if var_7_13 then
			local var_7_14 = iter_7_1.mission_name
			local var_7_15 = iter_7_1.widget_name
			local var_7_16 = iter_7_1.texture
			local var_7_17 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_7_16).size
			local var_7_18 = var_7_17[1]
			local var_7_19 = var_7_17[2]
			local var_7_20 = 1
			local var_7_21 = Localize(iter_7_1.title_text)
			local var_7_22 = var_7_2(var_7_16, var_7_21, var_7_20)
			local var_7_23 = UIWidget.init(var_7_22)
			local var_7_24 = {
				name = var_7_12,
				total_amount = var_7_13 > 0 and var_7_13,
				mission_name = var_7_14,
				widget = var_7_23
			}
			local var_7_25 = var_7_18 * var_7_20
			local var_7_26 = var_7_19 * var_7_20
			local var_7_27 = var_7_23.style.text
			local var_7_28 = UIUtils.get_text_width(var_7_1, var_7_27, var_7_21) + 20

			if var_7_7 < var_7_28 then
				var_7_7 = var_7_28
			end

			local var_7_29 = math.floor(var_7_11 / var_7_6)

			if var_7_11 % var_7_6 > 0 then
				var_7_8 = var_7_8 + (var_7_25 + var_7_7)
				var_7_7 = 0
			else
				var_7_8 = 0
			end

			local var_7_30 = var_7_23.offset

			var_7_30[1] = var_7_8
			var_7_30[2] = -(var_7_29 - 1) * var_7_26
			var_7_5[var_7_12] = var_7_24
			var_7_4[var_7_15] = var_7_23
			var_7_3[#var_7_3 + 1] = var_7_23
			var_7_11 = var_7_11 + 1
		end
	end

	if var_7_11 > 0 then
		arg_7_0._mission_settings_data = var_7_5

		arg_7_0:_sync_missions()
	end

	arg_7_0._mission_count = var_7_11
end

function IngamePlayerListUI._sync_missions(arg_8_0)
	local var_8_0 = arg_8_0._mission_settings_data

	if not var_8_0 then
		return
	end

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		local var_8_1 = iter_8_1.mission_name
		local var_8_2 = arg_8_0:_get_item_amount_by_mission_name(var_8_1) or 0
		local var_8_3 = iter_8_1.amount
		local var_8_4 = iter_8_1.total_amount
		local var_8_5 = iter_8_1.widget

		if var_8_3 ~= var_8_2 then
			iter_8_1.previous_amount = var_8_3 or 0
			iter_8_1.amount = var_8_2

			local var_8_6 = var_8_5.content

			var_8_6.amount = var_8_2

			if var_8_4 then
				var_8_6.counter_text = tostring(var_8_2) .. "/" .. tostring(var_8_4)
			else
				var_8_6.counter_text = "x" .. tostring(var_8_2)
			end
		end
	end
end

function IngamePlayerListUI._get_item_amount_by_mission_name(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._mission_system:get_level_end_mission_data(arg_9_1)

	return var_9_0 and var_9_0.current_amount
end

function IngamePlayerListUI._create_player_portrait(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = UIWidgets.create_portrait_frame("player_portrait", arg_10_1, arg_10_3, 1, nil, arg_10_2)

	arg_10_0._player_portrait_widget = UIWidget.init(var_10_0, arg_10_0._ui_top_renderer)
end

function IngamePlayerListUI._create_player_insignia(arg_11_0, arg_11_1)
	if arg_11_1.is_bot_player then
		return
	end

	local var_11_0 = arg_11_1.player
	local var_11_1 = ExperienceSettings.get_versus_player_level(var_11_0)
	local var_11_2 = UIWidgets.create_small_insignia("player_insignia", var_11_1)

	arg_11_0._player_insignia_widget = UIWidget.init(var_11_2)
end

function IngamePlayerListUI._setup_weave_display_info(arg_12_0)
	if Managers.state.game_mode:game_mode_key() == "weave" then
		local var_12_0 = Managers.state.network:lobby()
		local var_12_1 = var_12_0 and var_12_0:lobby_data("weave_quick_game")
		local var_12_2 = Managers.weave

		if var_12_2 then
			local var_12_3 = var_12_2:get_active_weave_template()

			if var_12_3 then
				local var_12_4

				if var_12_1 == "true" then
					var_12_4 = Localize(var_12_3.display_name)
				else
					var_12_4 = var_12_3.tier .. ". " .. Localize(var_12_3.display_name)
				end

				local var_12_5 = var_12_3.wind
				local var_12_6 = WindSettings[var_12_5].display_name

				arg_12_0:_set_level_name(var_12_4)
				arg_12_0:_set_difficulty_name(Localize(var_12_6))
				arg_12_0:_setup_weave_objectives(var_12_3)
			else
				arg_12_0:_set_level_name("")
				arg_12_0:_set_difficulty_name("")
			end
		end
	end
end

function IngamePlayerListUI._setup_weave_objectives(arg_13_0, arg_13_1)
	arg_13_0._weave_objective_widgets = {}
	arg_13_0._weave_objective_widgets_by_name = {}

	for iter_13_0, iter_13_1 in pairs(var_0_0.weave_objective_widgets) do
		local var_13_0 = UIWidget.init(iter_13_1)

		arg_13_0._weave_objective_widgets[#arg_13_0._weave_objective_widgets + 1] = var_13_0
		arg_13_0._weave_objective_widgets_by_name[iter_13_0] = var_13_0
	end

	local var_13_1 = 10
	local var_13_2 = 0
	local var_13_3 = var_0_0.scenegraph_definition
	local var_13_4 = "weave_sub_objective"
	local var_13_5 = var_13_3[var_13_4].size
	local var_13_6 = arg_13_1.objectives

	for iter_13_2 = 1, #var_13_6 do
		local var_13_7 = var_0_0.create_weave_sub_objective_widget(var_13_4, var_13_5)
		local var_13_8 = UIWidget.init(var_13_7)

		arg_13_0._weave_objective_widgets[#arg_13_0._weave_objective_widgets + 1] = var_13_8
		arg_13_0._weave_objective_widgets_by_name["weave_sub_objective_" .. iter_13_2] = var_13_8

		local var_13_9 = var_13_6[iter_13_2]
		local var_13_10 = var_13_9.conflict_settings == "weave_disabled"
		local var_13_11 = var_13_10 and "menu_weave_play_next_end_event_title" or "menu_weave_play_main_objective_title"
		local var_13_12 = var_13_9.display_name
		local var_13_13 = var_13_10 and "objective_icon_boss" or "objective_icon_general"
		local var_13_14 = arg_13_0:_assign_objective(var_13_8, var_13_11, var_13_12, var_13_13, var_13_1)

		var_13_8.offset[2] = -var_13_2
		var_13_2 = var_13_2 + var_13_14 + var_13_1
	end
end

function IngamePlayerListUI._assign_objective(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = arg_14_1.scenegraph_id
	local var_14_1 = arg_14_1.content
	local var_14_2 = arg_14_1.style
	local var_14_3 = var_0_0.scenegraph_definition[var_14_0].size

	var_14_1.icon = arg_14_4 or "trial_gem"
	var_14_1.title_text = arg_14_2 or "-"
	var_14_1.text = arg_14_3 or "-"

	local var_14_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_14_1.icon).size
	local var_14_5 = var_14_2.icon
	local var_14_6 = var_14_5.texture_size
	local var_14_7 = var_14_5.default_offset
	local var_14_8 = var_14_5.offset

	var_14_6[1] = var_14_4[1]
	var_14_6[2] = var_14_4[2]
	var_14_8[1] = var_14_7[1] - var_14_6[1] / 2
	var_14_8[2] = var_14_7[2]

	local var_14_9 = var_14_2.text
	local var_14_10 = arg_14_0._ui_renderer
	local var_14_11 = UIUtils.get_text_width(var_14_10, var_14_9, var_14_1.text)
	local var_14_12 = UIUtils.get_text_height(var_14_10, var_14_3, var_14_9, var_14_1.text)

	arg_14_5 = arg_14_5 or 0

	return math.max(var_14_12, 50) + arg_14_5
end

function IngamePlayerListUI.destroy(arg_15_0)
	if arg_15_0._cursor_active then
		ShowCursorStack.hide("IngamePlayerListUI")

		local var_15_0 = arg_15_0._input_manager

		var_15_0:device_unblock_all_services("keyboard")
		var_15_0:device_unblock_all_services("mouse")
		var_15_0:device_unblock_all_services("gamepad")

		arg_15_0._cursor_active = false
	end

	Managers.state.event:unregister("weave_objective_synced", arg_15_0)
	print("[IngamePlayerListUI] - Destroy")
end

function IngamePlayerListUI._set_level_name(arg_16_0, arg_16_1)
	arg_16_0:_set_widget_text("game_level", arg_16_1)
end

function IngamePlayerListUI._set_difficulty_name(arg_17_0, arg_17_1)
	arg_17_0:_set_widget_text("game_difficulty", arg_17_1)
end

function IngamePlayerListUI._set_widget_text(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0._widgets_by_name[arg_18_1].content.text = arg_18_2
end

function IngamePlayerListUI._set_simple_widget_texture(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0._widgets_by_name[arg_19_1].content.texture_id = arg_19_2
end

function IngamePlayerListUI._add_player(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.local_player
	local var_20_1 = arg_20_1.bot_player or not arg_20_1:is_player_controlled()
	local var_20_2 = arg_20_1:ui_id()
	local var_20_3 = ExperienceSettings.get_player_level(arg_20_1)
	local var_20_4 = arg_20_1:network_id()
	local var_20_5 = arg_20_0._host_peer_id == var_20_4
	local var_20_6 = {
		unit_spawned = false,
		is_local_player = var_20_0,
		is_bot_player = var_20_1,
		peer_id = var_20_4,
		ui_id = var_20_2,
		local_player_id = arg_20_1:local_player_id(),
		player = arg_20_1,
		player_name = arg_20_1:name(),
		level = var_20_3 or "n/a",
		resync_player_level = not var_20_3,
		is_server = var_20_5,
		unit_equipment = {}
	}

	arg_20_0._num_players = arg_20_0._num_players + 1
	arg_20_0._players[arg_20_0._num_players] = var_20_6

	local var_20_7
	local var_20_8 = {}
	local var_20_9 = {}
	local var_20_10 = {}

	for iter_20_0, iter_20_1 in pairs(arg_20_0._players) do
		if iter_20_1.is_server and not iter_20_1.is_bot_player then
			var_20_7 = iter_20_1
		elseif iter_20_1.is_bot_player then
			var_20_9[#var_20_9 + 1] = iter_20_1
		else
			var_20_8[#var_20_8 + 1] = iter_20_1
		end
	end

	local function var_20_11(arg_21_0, arg_21_1)
		return arg_21_0.peer_id > arg_21_1.peer_id
	end

	table.sort(var_20_8, var_20_11)

	local function var_20_12(arg_22_0, arg_22_1)
		return arg_22_0.local_player_id > arg_22_1.local_player_id
	end

	table.sort(var_20_9, var_20_12)

	var_20_10[#var_20_10 + 1] = var_20_7

	table.append(var_20_10, var_20_8)
	table.append(var_20_10, var_20_9)

	arg_20_0._players = var_20_10
end

function IngamePlayerListUI._update_widgets(arg_23_0)
	local var_23_0 = arg_23_0._players
	local var_23_1 = arg_23_0._num_players
	local var_23_2 = Managers.state.voting:vote_kick_enabled()
	local var_23_3 = Managers.party:leader()

	for iter_23_0 = 1, var_23_1 do
		local var_23_4 = var_23_0[iter_23_0]
		local var_23_5 = var_23_4.peer_id
		local var_23_6 = var_23_4.is_local_player
		local var_23_7 = var_23_4.is_bot_player
		local var_23_8 = var_23_5 == var_23_3 and not var_23_7
		local var_23_9 = var_23_4.is_server
		local var_23_10 = var_23_2 and arg_23_0:kick_player_available(var_23_4)
		local var_23_11 = not var_23_8 and not var_23_9 and (var_23_10 or arg_23_0:_can_host_solo_kick())
		local var_23_12 = arg_23_0._player_list_widgets[iter_23_0]
		local var_23_13 = var_23_12.content

		var_23_13.show_host = var_23_8
		var_23_13.is_local_player = var_23_6
		var_23_13.is_bot_player = var_23_7

		if var_23_6 or var_23_7 then
			var_23_13.show_chat_button = false
			var_23_13.show_kick_button = false
			var_23_13.show_voice_button = false
			var_23_13.show_profile_button = var_23_6 and not var_23_7
			var_23_13.show_ping = not var_23_9 and not var_23_7
			var_23_13.chat_button_hotspot.disable_button = true
			var_23_13.kick_button_hotspot.disable_button = true
			var_23_13.voice_button_hotspot.disable_button = true
			var_23_13.profile_button_hotspot.disable_button = var_23_7
		else
			if var_23_11 then
				var_23_13.show_kick_button = true
				var_23_13.kick_button_hotspot.disable_button = false
			else
				var_23_13.show_kick_button = false
				var_23_13.kick_button_hotspot.disable_button = true
			end

			var_23_13.show_profile_button = true
			var_23_13.show_chat_button = not IS_PS4
			var_23_13.show_voice_button = true
			var_23_13.show_ping = not var_23_9
			var_23_13.profile_button_hotspot.disable_button = false
			var_23_13.chat_button_hotspot.disable_button = IS_PS4
			var_23_13.voice_button_hotspot.disable_button = false
			var_23_13.chat_button_hotspot.is_selected = arg_23_0:_ignoring_chat_peer_id(var_23_5)
			var_23_13.voice_button_hotspot.is_selected = arg_23_0:_muted_peer_id(var_23_5)
		end

		local var_23_14 = var_23_4.player_name

		var_23_4.player_name = UTF8Utils.string_length(var_23_14) > var_0_3 and UIRenderer.crop_text_width(arg_23_0._ui_top_renderer, var_23_14, 370, var_23_12.style.name) or var_23_14
		var_23_4.widget = var_23_12
	end
end

local var_0_10 = {
	slot_ranged = "slot_melee",
	slot_melee = "slot_ranged"
}

function IngamePlayerListUI._update_player_information(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = SPProfiles
	local var_24_1 = arg_24_0._profile_synchronizer
	local var_24_2 = arg_24_0._players
	local var_24_3 = arg_24_0._num_players
	local var_24_4 = 20
	local var_24_5 = (var_24_3 - 1) * var_24_4
	local var_24_6 = var_0_2[2]
	local var_24_7 = var_24_6 * var_24_3 + var_24_5
	local var_24_8 = Managers.state.entity:system("cosmetic_system")

	for iter_24_0 = 1, var_24_3 do
		local var_24_9 = var_24_2[iter_24_0]
		local var_24_10 = var_24_9.player
		local var_24_11 = var_24_9.widget
		local var_24_12 = var_24_11.offset

		var_24_12[2] = -(var_24_6 * (iter_24_0 - 1) + var_24_4 * (iter_24_0 - 1))

		local var_24_13 = var_24_10:profile_index()
		local var_24_14 = var_24_10:career_index()
		local var_24_15 = var_24_0[var_24_13]
		local var_24_16 = var_24_15 and var_24_15.display_name or "unspawned"
		local var_24_17 = var_24_15 and var_24_15.ingame_display_name or "unspawned"
		local var_24_18 = var_24_11.style.name

		var_24_11.content.name = UIRenderer.crop_text_width(arg_24_0._ui_renderer, var_24_9.player_name, var_24_18.size[1], var_24_18)

		if var_24_9.resync_player_level then
			local var_24_19 = ExperienceSettings.get_player_level(var_24_10)

			if var_24_19 then
				var_24_9.level = var_24_19
				var_24_9.resync_player_level = nil
			end
		end

		local var_24_20 = var_24_15 and var_24_15.careers[var_24_14]

		if var_24_20 then
			local var_24_21 = var_24_20.name
			local var_24_22 = var_24_20.portrait_image
			local var_24_23 = var_24_9.is_bot_player and "BOT" or var_24_9.level and tostring(var_24_9.level) or "-"
			local var_24_24
			local var_24_25
			local var_24_26 = var_24_9.player
			local var_24_27 = var_24_26.player_unit

			if ALIVE[var_24_27] and var_24_9.is_bot_player then
				var_24_25 = Managers.state.entity:system("cosmetic_system"):get_equipped_frame(var_24_27)
			else
				var_24_24 = CosmeticUtils.get_cosmetic_slot(var_24_26, "slot_frame")
			end

			local var_24_28 = var_24_25 or var_24_24 and var_24_24.item_name or "default"
			local var_24_29 = var_24_9.portrait_frame and var_24_9.portrait_frame.item_name

			if var_24_9.career_index ~= var_24_14 or var_24_16 ~= var_24_9.hero_name or var_24_23 ~= var_24_9.player_level_text or var_24_28 ~= var_24_29 then
				var_24_9.career_index = var_24_14

				local var_24_30 = arg_24_0:_create_portrait_frame_widget(var_24_28, var_24_22, var_24_23)
				local var_24_31 = arg_24_0:_create_insignia_widget(var_24_9)
				local var_24_32 = var_24_11.style.background.color
				local var_24_33 = Colors.color_definitions[var_24_21]

				var_24_32[2] = var_24_33[2]
				var_24_32[3] = var_24_33[3]
				var_24_32[4] = var_24_33[4]
				var_24_9.player_level_text = var_24_23
				var_24_9.portrait_widget = var_24_30
				var_24_9.hero_name = var_24_16
				var_24_9.portrait_frame = var_24_24
				var_24_9.insignia_widget = var_24_31

				if var_24_9.is_local_player then
					var_24_9.sync_local_player_info = true
				end
			end

			local var_24_34 = var_24_9.portrait_widget

			if var_24_34 then
				var_24_34.offset[2] = var_24_12[2]
			end

			local var_24_35 = var_24_9.insignia_widget

			if var_24_35 then
				var_24_35.offset[2] = var_24_12[2]
			end

			local var_24_36 = var_24_20.display_name

			var_24_11.content.hero = var_24_36

			if var_24_9.sync_local_player_info then
				var_24_9.sync_local_player_info = nil

				local var_24_37 = CareerUtils.get_passive_ability_by_career(var_24_20)
				local var_24_38 = CareerUtils.get_ability_data_by_career(var_24_20, 1)
				local var_24_39 = var_24_38.display_name
				local var_24_40 = var_24_38.icon

				arg_24_0:_set_widget_text("player_ability_name", Localize(var_24_39))
				arg_24_0:_set_widget_text("player_ability_description", UIUtils.get_ability_description(var_24_38))
				arg_24_0:_set_simple_widget_texture("player_ability_icon", var_24_40)

				local var_24_41 = var_24_37.display_name
				local var_24_42 = var_24_37.icon

				arg_24_0:_set_widget_text("player_passive_name", Localize(var_24_41))
				arg_24_0:_set_widget_text("player_passive_description", UIUtils.get_ability_description(var_24_37))
				arg_24_0:_set_simple_widget_texture("player_passive_icon", var_24_42)
				arg_24_0:_set_widget_text("player_career_name", Localize(var_24_36))
				arg_24_0:_create_player_portrait(var_24_28, var_24_22, var_24_23)
				arg_24_0:_create_player_insignia(var_24_9)
				arg_24_0:_set_widget_text("player_hero_name", Localize(var_24_17))
			end
		end
	end

	arg_24_0:_update_dynamic_widget_information(arg_24_1, arg_24_2)
end

function IngamePlayerListUI._create_portrait_frame_widget(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = UIWidgets.create_portrait_frame("player_list_portrait", arg_25_1, arg_25_3, 1, nil, arg_25_2)
	local var_25_1 = UIWidget.init(var_25_0, arg_25_0._ui_top_renderer)

	var_25_1.content.frame_settings_name = arg_25_1

	return var_25_1
end

function IngamePlayerListUI._create_insignia_widget(arg_26_0, arg_26_1)
	if arg_26_1.is_bot_player then
		return
	end

	local var_26_0 = arg_26_1.player
	local var_26_1 = ExperienceSettings.get_versus_player_level(var_26_0)
	local var_26_2 = UIWidgets.create_small_insignia("player_list_insignia", var_26_1)

	return (UIWidget.init(var_26_2))
end

function IngamePlayerListUI._get_ping_texture_by_ping_value(arg_27_0, arg_27_1)
	if arg_27_1 <= 125 then
		return "ping_icon_01", "low_ping_color"
	elseif arg_27_1 > 125 and arg_27_1 <= 175 then
		return "ping_icon_02", "medium_ping_color"
	elseif arg_27_1 > 175 then
		return "ping_icon_03", "high_ping_color"
	end
end

function IngamePlayerListUI._ignoring_chat_peer_id(arg_28_0, arg_28_1)
	if IS_WINDOWS then
		return Managers.chat.chat_gui:ignoring_peer_id(arg_28_1)
	elseif IS_XB1 then
		return Managers.chat:ignoring_peer_id(arg_28_1)
	end
end

function IngamePlayerListUI._ignore_chat_message_from_peer_id(arg_29_0, arg_29_1)
	if IS_WINDOWS then
		Managers.chat.chat_gui:ignore_peer_id(arg_29_1)
	elseif IS_XB1 then
		Managers.chat:ignore_peer_id(arg_29_1)
	end
end

function IngamePlayerListUI._remove_ignore_chat_message_from_peer_id(arg_30_0, arg_30_1)
	if IS_WINDOWS then
		Managers.chat.chat_gui:remove_ignore_peer_id(arg_30_1)
	elseif IS_XB1 then
		Managers.chat:remove_ignore_peer_id(arg_30_1)
	end
end

function IngamePlayerListUI._muted_peer_id(arg_31_0, arg_31_1)
	if IS_XB1 then
		if Managers.voice_chat then
			return Managers.voice_chat:is_peer_muted(arg_31_1)
		else
			return false
		end
	else
		return arg_31_0._voip:peer_muted(arg_31_1)
	end
end

function IngamePlayerListUI._ignore_voice_message_from_peer_id(arg_32_0, arg_32_1)
	if IS_XB1 then
		if Managers.voice_chat then
			Managers.voice_chat:mute_peer(arg_32_1)
		end
	else
		arg_32_0._voip:mute_member(arg_32_1)
	end
end

function IngamePlayerListUI._remove_ignore_voice_message_from_peer_id(arg_33_0, arg_33_1)
	if IS_XB1 then
		if Managers.voice_chat then
			Managers.voice_chat:unmute_peer(arg_33_1)
		end
	else
		arg_33_0._voip:unmute_member(arg_33_1)
	end
end

function IngamePlayerListUI.post_update(arg_34_0, arg_34_1)
	return
end

function IngamePlayerListUI.update(arg_35_0, arg_35_1, arg_35_2)
	if RESOLUTION_LOOKUP.modified then
		arg_35_0:_on_resolution_changed()
	end

	local var_35_0 = arg_35_0._input_manager
	local var_35_1 = Managers.transition:in_fade_active()
	local var_35_2 = var_35_0:get_service("player_list_input")
	local var_35_3 = arg_35_0._is_in_inn and Managers.matchmaking:is_game_matchmaking()

	if not var_35_1 and (var_35_2:get("ingame_player_list_exit") or var_35_2:get("ingame_player_list_toggle") or var_35_2:get("back")) and arg_35_0._active and arg_35_0._cursor_active then
		arg_35_0:_set_active(false)
	elseif not arg_35_0._cursor_active then
		if not var_35_1 and var_35_2:get("ingame_player_list_toggle") and not var_35_3 then
			if not arg_35_0._active then
				arg_35_0:_set_active(true)

				if not arg_35_0._cursor_active then
					ShowCursorStack.show("IngamePlayerListUI")
					var_35_0:capture_input({
						"keyboard",
						"gamepad",
						"mouse"
					}, 1, "player_list_input", "IngamePlayerListUI")

					arg_35_0._cursor_active = true
				end
			end
		elseif var_35_2:get("ingame_player_list_pressed") and not arg_35_0:_is_in_deus_map_view() then
			if not arg_35_0._active then
				arg_35_0:_set_active(true)
			end
		elseif arg_35_0._active and not var_35_2:get("ingame_player_list_held") then
			arg_35_0:_set_active(false)
		end
	end

	if arg_35_0._active then
		if var_35_2:get("activate_ingame_player_list") and not arg_35_0._cursor_active then
			ShowCursorStack.show("IngamePlayerListUI")
			var_35_0:capture_input({
				"keyboard",
				"gamepad",
				"mouse"
			}, 1, "player_list_input", "IngamePlayerListUI")

			arg_35_0._cursor_active = true
		end

		arg_35_0:_update_player_list(arg_35_1, arg_35_2)

		if arg_35_0._show_difficulty then
			arg_35_0:_update_difficulty()
		end

		arg_35_0:_update_private_checkbox()
		arg_35_0:_sync_missions()
		arg_35_0:_update_fade_in_duration(arg_35_1)
		arg_35_0:_draw(arg_35_1)
	end
end

function IngamePlayerListUI._on_resolution_changed(arg_36_0)
	local var_36_0 = arg_36_0._static_widgets_by_name.banner_right_edge
	local var_36_1 = arg_36_0._static_widgets_by_name.banner_left_edge
	local var_36_2 = RESOLUTION_LOOKUP.inv_scale

	var_36_0.style.edge.texture_size[2] = var_36_2 * RESOLUTION_LOOKUP.res_h
	var_36_1.style.edge.texture_size[2] = var_36_2 * RESOLUTION_LOOKUP.res_h
end

function IngamePlayerListUI._set_privacy_enabled(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = "map_screen_private_button"
	local var_37_1 = arg_37_0._private_checkbox_widget

	var_37_1.content.checked = arg_37_1
	var_37_1.content.setting_text = var_37_0

	if arg_37_2 then
		arg_37_0._private_timer = 0
	end
end

function IngamePlayerListUI.on_save_ended_callback(arg_38_0)
	print("[IngamePlayerWiew] - settings saved")
end

function IngamePlayerListUI.is_active(arg_39_0)
	return arg_39_0._active
end

function IngamePlayerListUI.is_focused(arg_40_0)
	return arg_40_0._active and arg_40_0._cursor_active
end

function IngamePlayerListUI.input_service(arg_41_0)
	return arg_41_0._input_manager:get_service("player_list_input")
end

function IngamePlayerListUI.set_visible(arg_42_0, arg_42_1)
	if arg_42_0._active and not arg_42_1 then
		arg_42_0:_set_active(false)
	end
end

function IngamePlayerListUI._set_active(arg_43_0, arg_43_1)
	local var_43_0 = Managers.chat.chat_gui

	if arg_43_1 then
		arg_43_0:_on_resolution_changed()

		if arg_43_0._local_player.is_server and not arg_43_0._is_in_inn then
			local var_43_1 = Managers.matchmaking:is_game_private()

			arg_43_0:_set_privacy_enabled(var_43_1)
		end

		local var_43_2 = {
			deus = "area_selection_morris_name",
			deed = "start_game_window_mutator_title",
			tutorial = "lb_game_type_prologue",
			event = "start_game_window_event_title",
			["n/a"] = "lb_game_type_none",
			custom = "lb_game_type_custom"
		}
		local var_43_3 = Managers.mechanism:current_mechanism_name()
		local var_43_4 = Managers.matchmaking:active_game_mode()
		local var_43_5 = Managers.state.network:lobby()
		local var_43_6 = var_43_5 and var_43_5:lobby_data("weave_quick_game") == "true" or Managers.venture.quickplay:is_quick_game()
		local var_43_7 = arg_43_0._static_widgets_by_name.mechanism_type_name
		local var_43_8 = arg_43_0._static_widgets_by_name.mission_type_name

		if var_43_3 == "weave" then
			var_43_4 = var_43_6 and "lb_game_type_weave_quick_play" or "lb_game_type_custom"
			var_43_7.content.text = Utf8.upper(Localize("lb_game_type_weave"))
			var_43_8.content.text = Localize(var_43_4)
		else
			local var_43_9 = MechanismSettings[var_43_3]

			var_43_7.content.text = Utf8.upper(Localize(var_43_9.display_name))

			if var_43_6 then
				var_43_8.content.text = Localize("lb_game_type_quick_play")
			else
				var_43_8.content.text = Localize(var_43_2[var_43_4] or var_43_2["n/a"])
			end
		end

		arg_43_0:_setup_mutator_data()
		arg_43_0:_setup_deed_reward_data()
		arg_43_0:_setup_chaos_wastes_info()
		Managers.input:enable_gamepad_cursor()
	else
		var_43_0:hide_chat()
		Managers.input:disable_gamepad_cursor()
	end

	arg_43_0._active = arg_43_1

	if arg_43_1 then
		arg_43_0._fade_in_duration = 0
	end

	if arg_43_0._cursor_active then
		ShowCursorStack.hide("IngamePlayerListUI")

		local var_43_10 = arg_43_0._input_manager

		var_43_10:release_input({
			"keyboard",
			"gamepad",
			"mouse"
		}, 1, "player_list_input", "IngamePlayerListUI", true)
		var_43_10:device_unblock_service("keyboard", 1, "player_list_input")
		var_43_10:device_unblock_service("gamepad", 1, "player_list_input")
		var_43_10:device_unblock_service("mouse", 1, "player_list_input")

		arg_43_0._cursor_active = false
	end

	Managers.state.event:trigger("ingame_player_list_enabled", arg_43_1, true)
end

function IngamePlayerListUI._update_fade_in_duration(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._fade_in_duration

	if not var_44_0 then
		return
	end

	local var_44_1 = var_44_0 + arg_44_1
	local var_44_2 = math.min(var_44_1 / 0.2, 1)
	local var_44_3 = math.easeOutCubic(var_44_2)
	local var_44_4 = arg_44_0._render_settings
	local var_44_5 = arg_44_0._ui_scenegraph

	var_44_4.alpha_multiplier = var_44_2
	var_44_5.player_list.local_position[1] = -800 * (1 - var_44_3)
	var_44_5.banner_left.local_position[1] = -800 * (1 - var_44_3)
	var_44_5.banner_right.local_position[1] = 800 * (1 - var_44_3)

	if var_44_2 == 1 then
		arg_44_0._fade_in_duration = nil
	else
		arg_44_0._fade_in_duration = var_44_1
	end
end

local var_0_11 = {}
local var_0_12 = {}

function IngamePlayerListUI._update_player_list(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = Managers.state.network:game()

	table.clear(var_0_11)
	table.clear(var_0_12)

	local var_45_1 = Managers.player:human_and_bot_players()

	for iter_45_0, iter_45_1 in pairs(var_45_1) do
		var_0_12[iter_45_1:ui_id()] = iter_45_1
	end

	local var_45_2 = false
	local var_45_3 = arg_45_0._players
	local var_45_4 = arg_45_0._num_players
	local var_45_5 = false

	for iter_45_2 = var_45_4, 1, -1 do
		local var_45_6 = var_45_3[iter_45_2]
		local var_45_7 = var_45_6.peer_id
		local var_45_8 = var_45_6.ui_id
		local var_45_9 = var_0_12[var_45_8]

		if not var_45_9 then
			table.remove(var_45_3, iter_45_2)

			var_45_2 = true
			var_45_4 = var_45_4 - 1
		else
			local var_45_10 = var_45_6.is_local_player
			local var_45_11 = var_45_6.is_bot_player
			local var_45_12 = var_45_6.is_server
			local var_45_13 = var_45_6.widget
			local var_45_14 = var_45_9.game_object_id

			var_0_11[var_45_8] = true

			if not var_45_12 and not var_45_11 and var_45_0 and var_45_14 then
				local var_45_15 = GameSession.game_object_field(var_45_0, var_45_14, "ping")
				local var_45_16, var_45_17 = arg_45_0:_get_ping_texture_by_ping_value(var_45_15)

				var_45_13.content.ping_texture = var_45_16
				var_45_13.content.ping_text = var_45_15

				local var_45_18 = var_45_13.style.ping_text

				var_45_18.text_color = var_45_18[var_45_17]
			end

			if not var_45_11 then
				local var_45_19 = var_45_13.content.profile_button_hotspot

				if var_45_19.on_pressed then
					var_45_19.on_pressed = nil

					arg_45_0:_show_profile_by_peer_id(var_45_7)
				end
			end

			if not var_45_10 then
				local var_45_20 = var_45_13.content.chat_button_hotspot

				if var_45_20.on_pressed then
					var_45_20.on_pressed = nil

					if var_45_20.is_selected then
						arg_45_0:_remove_ignore_chat_message_from_peer_id(var_45_7)

						var_45_20.is_selected = nil
					else
						arg_45_0:_ignore_chat_message_from_peer_id(var_45_7)

						var_45_20.is_selected = true
					end
				end

				local var_45_21 = var_45_13.content.voice_button_hotspot

				if var_45_21.on_pressed then
					var_45_21.on_pressed = nil

					if var_45_21.is_selected then
						arg_45_0:_remove_ignore_voice_message_from_peer_id(var_45_7)

						var_45_21.is_selected = nil
					else
						arg_45_0:_ignore_voice_message_from_peer_id(var_45_7)

						var_45_21.is_selected = true
					end
				end

				local var_45_22 = var_45_13.content.kick_button_hotspot

				if not var_45_12 and var_45_22.on_pressed then
					var_45_22.on_pressed = nil

					arg_45_0:kick_player(var_45_6.player, arg_45_2)
				end
			end
		end

		if arg_45_0._kick_vote_cooldown then
			if arg_45_2 >= arg_45_0._kick_vote_cooldown + var_0_4 then
				var_45_5 = true
			end

			for iter_45_3 = var_45_4, 1, -1 do
				local var_45_23 = var_45_3[iter_45_3]
				local var_45_24 = var_45_23.widget
				local var_45_25 = var_45_23.is_local_player
				local var_45_26 = var_45_23.is_bot_player
				local var_45_27 = var_45_23.is_server

				if not var_45_25 and not var_45_27 and not var_45_26 then
					var_45_24.content.kick_button_hotspot.disable_button = not var_45_5
					var_45_24.content.show_kick_button = var_45_5
				end
			end

			if var_45_5 then
				arg_45_0._kick_vote_cooldown = nil
			end
		end
	end

	arg_45_0._num_players = var_45_4

	local var_45_28 = Managers.state.game_mode:game_mode_key()
	local var_45_29 = GameModeSettings[var_45_28]

	for iter_45_4, iter_45_5 in pairs(var_45_1) do
		local var_45_30 = iter_45_5.player_unit

		if (var_45_29.allow_unspawned_players_in_tab_menu or ALIVE[var_45_30]) and not var_0_11[iter_45_5:ui_id()] then
			arg_45_0:_add_player(iter_45_5)

			var_45_2 = true
		end
	end

	if var_45_2 then
		arg_45_0:_update_widgets()
	end

	arg_45_0:_update_player_information(arg_45_1, arg_45_2)
end

local var_0_13 = {}

function IngamePlayerListUI._update_dynamic_widget_information(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = Managers.state.network:game()

	arg_46_0._item_tooltip.content.item = nil

	local var_46_1 = arg_46_0._players
	local var_46_2 = arg_46_0._profile_synchronizer
	local var_46_3 = SPProfiles
	local var_46_4 = arg_46_0._ui_scenegraph
	local var_46_5 = Managers.player:player_loadouts()

	for iter_46_0, iter_46_1 in ipairs(var_46_1) do
		local var_46_6 = iter_46_1.player
		local var_46_7 = var_46_6.player_unit

		if ALIVE[var_46_7] then
			local var_46_8 = Managers.state.unit_storage:go_id(var_46_7)
			local var_46_9 = ScriptUnit.extension(var_46_7, "health_system")
			local var_46_10 = ScriptUnit.extension(var_46_7, "status_system")
			local var_46_11 = ScriptUnit.extension(var_46_7, "buff_system")
			local var_46_12 = ScriptUnit.extension(var_46_7, "inventory_system")
			local var_46_13 = var_46_9:get_max_health()
			local var_46_14

			var_46_14 = var_46_10:is_dead() and 0 or var_46_9:current_health()

			local var_46_15 = var_46_10:is_dead() and 0 or var_46_9:current_health_percent()
			local var_46_16 = var_46_10:is_dead() and 0 or var_46_9:current_permanent_health_percent()

			if var_46_10:is_knocked_down() or var_46_10:get_is_ledge_hanging() then
				local var_46_17

				var_46_17 = var_46_15 > 0
			end

			local var_46_18 = var_46_10:is_ready_for_assisted_respawn()

			if not var_46_10:is_grabbed_by_pack_master() and not var_46_10:is_hanging_from_hook() and not var_46_10:is_pounced_down() and not var_46_10:is_grabbed_by_corruptor() and not var_46_10:is_in_vortex() then
				local var_46_19 = var_46_10:is_grabbed_by_chaos_spawn()
			end

			local var_46_20 = var_46_11:num_buff_perk("skaven_grimoire")
			local var_46_21 = var_46_11:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
			local var_46_22 = var_46_11:num_buff_perk("twitch_grimoire")
			local var_46_23 = var_46_11:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
			local var_46_24 = var_46_11:num_buff_perk("slayer_curse")
			local var_46_25 = var_46_11:apply_buffs_to_value(PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF, "curse_protection")
			local var_46_26 = var_46_11:num_buff_perk("mutator_curse")
			local var_46_27 = WindSettings.light.curse_settings.value
			local var_46_28 = Managers.state.difficulty:get_difficulty_value_from_table(var_46_27)
			local var_46_29 = var_46_11:apply_buffs_to_value(var_46_28, "curse_protection")
			local var_46_30 = var_46_11:apply_buffs_to_value(0, "health_curse")
			local var_46_31 = var_46_11:apply_buffs_to_value(var_46_30, "curse_protection")
			local var_46_32 = 1 + var_46_20 * var_46_21 + var_46_22 * var_46_23 + var_46_24 * var_46_25 + var_46_26 * var_46_29 + var_46_31
			local var_46_33 = arg_46_0._player_list_widgets[iter_46_0]
			local var_46_34 = var_46_33.style
			local var_46_35 = var_46_33.content
			local var_46_36 = var_46_34.health_bar
			local var_46_37 = var_46_34.total_health_bar
			local var_46_38 = var_46_34.grimoire_bar
			local var_46_39 = var_46_34.grimoire_debuff_divider
			local var_46_40 = var_46_35.ability_bar

			if var_46_0 and var_46_8 then
				var_46_40.bar_value = 1 - (GameSession.game_object_field(var_46_0, var_46_8, "ability_percentage") or 0)
			end

			var_46_36.gradient_threshold = var_46_16 * var_46_32
			var_46_37.gradient_threshold = var_46_15 * var_46_32
			var_46_38.grimoire_debuff = 1 - var_46_32
			var_46_39.grimoire_debuff = 1 - var_46_32

			local var_46_41 = var_46_6:unique_id()
			local var_46_42, var_46_43 = var_46_2:profile_by_peer(iter_46_1.peer_id, iter_46_1.local_player_id)
			local var_46_44 = var_46_3[var_46_42]
			local var_46_45 = var_46_5[var_46_41] or var_0_13
			local var_46_46 = var_46_12:equipment()
			local var_46_47 = true

			if var_46_6.local_player or var_46_6.bot_player and var_46_6.is_server then
				var_46_47 = true
			else
				local var_46_48 = var_46_6:get_data("playerlist_build_privacy")

				if var_46_48 == PrivacyLevels.friends then
					local var_46_49 = rawget(_G, "Friends")

					var_46_47 = var_46_49 and var_46_49.in_category(iter_46_1.peer_id, var_46_49.FRIEND_FLAG)
				elseif var_46_48 == PrivacyLevels.private then
					var_46_47 = false
				end
			end

			var_46_35.is_build_visible = var_46_47

			for iter_46_2, iter_46_3 in pairs(var_46_45) do
				local var_46_50 = iter_46_3.rarity or iter_46_3.data and iter_46_3.data.rarity or "plentiful"
				local var_46_51 = UIUtils.get_ui_information_from_item(iter_46_3)

				if not var_46_47 then
					var_46_50, var_46_51 = nil
				end

				var_46_35[iter_46_2] = var_46_51
				var_46_35[iter_46_2 .. "_rarity_texture"] = var_46_50 and UISettings.item_rarity_textures[var_46_50]

				if UIUtils.is_button_hover(var_46_33, iter_46_2 .. "_hotspot") then
					arg_46_0:_update_item_tooltip_widget(iter_46_3, var_46_33.offset)
				end
			end

			local var_46_52 = ScriptUnit.has_extension(var_46_7, "talent_system")

			if var_46_52 then
				local var_46_53 = var_46_52:get_talent_ids()
				local var_46_54 = var_46_6:profile_display_name()

				for iter_46_4 = 1, 6 do
					local var_46_55 = var_46_53[iter_46_4]
					local var_46_56 = TalentUtils.get_talent_by_id(var_46_54, var_46_55)
					local var_46_57 = var_46_56 and var_46_56.icon
					local var_46_58 = var_46_35["talent_" .. iter_46_4]

					if not var_46_47 or not var_46_57 then
						var_46_56 = nil
					end

					var_46_58.talent = var_46_56
					var_46_58.icon = var_46_57 or "icons_placeholder"

					if var_46_58.is_hover then
						var_46_4.talent_tooltip.local_position[2] = var_46_33.offset[2]
					end
				end
			end
		end
	end
end

local var_0_14 = {
	alpha_multiplier = 0
}

function IngamePlayerListUI._update_item_tooltip_widget(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._ui_scenegraph
	local var_47_1 = arg_47_0._ui_renderer
	local var_47_2 = arg_47_0._item_tooltip
	local var_47_3 = var_47_2.style

	var_47_2.content.item = arg_47_1

	UIRenderer.begin_pass(var_47_1, var_47_0, FAKE_INPUT_SERVICE, 0, nil, var_0_14)
	UIRenderer.draw_widget(var_47_1, var_47_2)
	UIRenderer.end_pass(var_47_1)

	local var_47_4 = var_47_3.item.item_presentation_height - 100
	local var_47_5 = 1080 - var_47_4

	var_47_0.item_tooltip.local_position[2] = math.min(arg_47_2[2] + var_47_4, var_47_5)
end

function IngamePlayerListUI._update_difficulty(arg_48_0)
	local var_48_0 = Managers.state.difficulty:get_difficulty_settings().display_name

	if var_48_0 ~= arg_48_0._current_difficulty_name then
		arg_48_0:_set_difficulty_name(Localize(var_48_0))

		arg_48_0._current_difficulty_name = var_48_0
	end
end

function IngamePlayerListUI._update_private_checkbox(arg_49_0)
	local var_49_0 = Managers.state.difficulty:get_difficulty()
	local var_49_1 = Managers.player:human_players()
	local var_49_2 = DifficultyManager.players_below_required_power_level(var_49_0, var_49_1)

	arg_49_0._private_checkbox_disabled_reasons.power_level = not table.is_empty(var_49_2) or nil

	local var_49_3 = arg_49_0._private_checkbox_widget.content

	var_49_3.is_disabled = not table.is_empty(arg_49_0._private_checkbox_disabled_reasons)

	if arg_49_0._local_player.is_server and not arg_49_0._is_in_inn and not var_49_3.is_disabled then
		local var_49_4 = var_49_3.button_hotspot

		if var_49_4.on_hover_enter then
			WwiseWorld.trigger_event(arg_49_0._wwise_world, "Play_hud_hover")
		end

		if arg_49_0._private_setting_enabled and var_49_4.on_release then
			local var_49_5 = Managers.matchmaking:is_game_private()
			local var_49_6 = arg_49_0._map_save_data

			var_49_6.private_enabled = not var_49_5

			WwiseWorld.trigger_event(arg_49_0._wwise_world, "Play_hud_select")
			arg_49_0:_set_privacy_enabled(var_49_6.private_enabled, true)

			PlayerData.map_view_data = var_49_6

			Managers.save:auto_save(SaveFileName, SaveData, callback(arg_49_0, "on_save_ended_callback"))
			Managers.matchmaking:set_in_progress_game_privacy(var_49_6.private_enabled)
		end
	end
end

function IngamePlayerListUI._draw(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0._ui_renderer
	local var_50_1 = arg_50_0._ui_top_renderer
	local var_50_2 = arg_50_0._ui_scenegraph
	local var_50_3 = arg_50_0._input_manager
	local var_50_4 = var_50_3:get_service("player_list_input")
	local var_50_5 = var_50_3:is_device_active("gamepad")
	local var_50_6 = arg_50_0._render_settings

	UIRenderer.begin_pass(var_50_1, var_50_2, var_50_4, arg_50_1, nil, var_50_6)

	if not var_50_5 and not arg_50_0._cursor_active then
		UIRenderer.draw_widget(var_50_1, arg_50_0._input_description_text_widget)
	end

	if arg_50_0._num_rewards > 0 then
		UIRenderer.draw_widget(var_50_1, arg_50_0._reward_header_widget)
		UIRenderer.draw_widget(var_50_1, arg_50_0._reward_divider_widget)
	end

	if arg_50_0._mission_count > 0 then
		UIRenderer.draw_widget(var_50_1, arg_50_0._collectibles_name)
		UIRenderer.draw_widget(var_50_1, arg_50_0._collectibles_divider)
	end

	if arg_50_0._num_mutators == 0 then
		UIRenderer.draw_widget(var_50_1, arg_50_0._level_description_widget)
	end

	if arg_50_0._node_info_widget then
		UIRenderer.draw_widget(var_50_1, arg_50_0._node_info_widget)
	end

	for iter_50_0, iter_50_1 in ipairs(arg_50_0._reward_widgets) do
		UIRenderer.draw_widget(var_50_1, iter_50_1)
	end

	local var_50_7 = arg_50_0._weave_objective_widgets

	if var_50_7 then
		for iter_50_2 = 1, #var_50_7 do
			local var_50_8 = var_50_7[iter_50_2]

			UIRenderer.draw_widget(var_50_1, var_50_8)
		end
	end

	local var_50_9 = arg_50_0._player_portrait_widget

	if var_50_9 then
		UIRenderer.draw_widget(var_50_1, var_50_9)
	end

	local var_50_10 = arg_50_0._player_insignia_widget

	if var_50_10 then
		UIRenderer.draw_widget(var_50_1, var_50_10)
	end

	local var_50_11 = arg_50_0._static_widgets

	if var_50_11 then
		for iter_50_3 = 1, #var_50_11 do
			local var_50_12 = var_50_11[iter_50_3]

			UIRenderer.draw_widget(var_50_1, var_50_12)
		end
	end

	local var_50_13 = arg_50_0._widgets

	if var_50_13 then
		for iter_50_4 = 1, #var_50_13 do
			local var_50_14 = var_50_13[iter_50_4]

			UIRenderer.draw_widget(var_50_1, var_50_14)
		end
	end

	UIRenderer.draw_widget(var_50_1, arg_50_0._item_tooltip)

	if arg_50_0._private_setting_enabled then
		UIRenderer.draw_widget(var_50_1, arg_50_0._private_checkbox_widget)
	end

	if var_50_5 then
		UIRenderer.draw_widget(var_50_1, arg_50_0._console_cursor)
	end

	local var_50_15 = arg_50_0._players
	local var_50_16 = arg_50_0._num_players

	for iter_50_5 = 1, var_50_16 do
		local var_50_17 = var_50_15[iter_50_5]
		local var_50_18 = var_50_17.widget

		UIRenderer.draw_widget(var_50_1, var_50_18)

		local var_50_19 = var_50_17.portrait_widget

		if var_50_19 then
			UIRenderer.draw_widget(var_50_1, var_50_19)
		end

		local var_50_20 = Managers.mechanism:current_mechanism_name() == "versus"
		local var_50_21 = var_50_17.insignia_widget

		if var_50_21 and (var_50_20 or Application.user_setting("toggle_versus_level_in_all_game_modes")) then
			UIRenderer.draw_widget(var_50_1, var_50_21)
		end
	end

	UIRenderer.end_pass(var_50_1)
end

function IngamePlayerListUI._can_host_solo_kick(arg_51_0)
	return arg_51_0._is_server and Managers.player:num_human_players() == 2
end

function IngamePlayerListUI.kick_player(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_1.peer_id

	if arg_52_0:_can_host_solo_kick() then
		arg_52_0._network_server:kick_peer(var_52_0)
	else
		local var_52_1 = {
			kick_peer_id = var_52_0
		}

		Managers.state.voting:request_vote("kick_player", var_52_1, Network.peer_id())

		arg_52_0._kick_vote_cooldown = arg_52_2

		arg_52_0:_set_active(false)
	end
end

function IngamePlayerListUI.kick_player_available(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_1.peer_id

	if not var_53_0 or var_53_0 == Network.peer_id() then
		return false
	end

	var_0_5.kick_peer_id = var_53_0

	if not Managers.state.voting:can_start_vote("kick_player", var_0_5) then
		return false
	end

	return true
end

function IngamePlayerListUI._show_profile_by_peer_id(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0._platform

	if IS_WINDOWS and rawget(_G, "Steam") then
		local var_54_1 = Steam.id_hex_to_dec(arg_54_1)
		local var_54_2 = "http://steamcommunity.com/profiles/" .. var_54_1

		Steam.open_url(var_54_2)
	elseif IS_XB1 then
		local var_54_3 = arg_54_0._network_lobby:xuid(arg_54_1)

		if var_54_3 then
			XboxLive.show_gamercard(Managers.account:user_id(), var_54_3)
		end
	elseif IS_PS4 then
		Managers.account:show_player_profile_with_account_id(arg_54_1)
	end
end

function IngamePlayerListUI.event_weave_objective_synced(arg_55_0)
	arg_55_0:_setup_weave_display_info()
end

function IngamePlayerListUI._is_in_deus_map_view(arg_56_0)
	if Managers.mechanism:current_mechanism_name() ~= "deus" then
		return false
	end

	return Managers.mechanism:get_state() == "map_deus"
end
