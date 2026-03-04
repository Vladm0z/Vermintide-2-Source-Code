-- chunkname: @scripts/ui/views/matchmaking_ui.lua

require("scripts/settings/difficulty_settings")

local var_0_0 = local_require("scripts/ui/views/matchmaking_ui_definitions")
local var_0_1 = var_0_0.cancel_input_widgets
local var_0_2 = var_0_0.versus_input_widgets
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.debug_widget_definitions

local function var_0_5(...)
	return
end

local function var_0_6(arg_2_0, arg_2_1)
	local var_2_0 = SPProfiles[arg_2_0].careers[arg_2_1].portrait_image

	return var_2_0 and "small_" .. var_2_0 or "icons_placeholder"
end

local var_0_7 = {
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
local var_0_8 = {}

MatchmakingUI = class(MatchmakingUI)

MatchmakingUI.init = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._parent = arg_3_1
	arg_3_0.network_event_delegate = arg_3_2.network_event_delegate
	arg_3_0.profile_synchronizer = arg_3_2.profile_synchronizer
	arg_3_0.camera_manager = arg_3_2.camera_manager
	arg_3_0.ui_renderer = arg_3_2.ui_renderer
	arg_3_0.ui_top_renderer = arg_3_2.ui_top_renderer
	arg_3_0.ingame_ui = arg_3_2.ingame_ui
	arg_3_0.lobby = arg_3_2.network_lobby
	arg_3_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_3_0.voting_manager = arg_3_2.voting_manager
	arg_3_0._cached_matchmaking_info = {}
	arg_3_0._is_in_inn = arg_3_2.is_in_inn
	arg_3_0.matchmaking_manager = Managers.matchmaking
	arg_3_0.input_manager = arg_3_2.input_manager

	arg_3_0:create_ui_elements()

	arg_3_0.num_players_text = Localize("number_of_players")
	arg_3_0._max_number_of_players = Managers.mechanism:max_instance_members()
	arg_3_0.portrait_index_table = {}
	arg_3_0._my_peer_id = Network.peer_id()

	if Managers.party:is_leader(arg_3_0._my_peer_id) then
		arg_3_0:_update_button_prompts()

		arg_3_0._allow_cancel_matchmaking = true
	end
end

MatchmakingUI.create_ui_elements = function (arg_4_0)
	table.clear(arg_4_0._cached_matchmaking_info)

	arg_4_0.ui_animations = {}
	arg_4_0._widgets, arg_4_0._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)
	arg_4_0._detail_widgets, arg_4_0._detail_widgets_by_name = UIUtils.create_widgets(var_0_0.widget_detail_definitions)
	arg_4_0._widgets_deus, arg_4_0._widgets_deus_by_name = UIUtils.create_widgets(var_0_0.deus_widget_definitions)
	arg_4_0._detail_widgets_deus, arg_4_0._detail_widgets_deus_by_name = UIUtils.create_widgets(var_0_0.deus_widget_detail_definitions)
	arg_4_0._widgets_versus, arg_4_0._widgets_versus_by_name = UIUtils.create_widgets(var_0_0.versus_widget_definitions)
	arg_4_0._detail_widgets_versus, arg_4_0._detail_widgets_versus_by_name = UIUtils.create_widgets(var_0_0.versus_widget_detail_definitions)
	arg_4_0._versus_input_widgets, arg_4_0._versus_input_widgets_by_name = UIUtils.create_widgets(var_0_2)
	arg_4_0._cancel_input_widgets, arg_4_0._cancel_input_widgets_by_name = UIUtils.create_widgets(var_0_1)
	arg_4_0.debug_box_widget = UIWidget.init(var_0_4.debug_box)
	arg_4_0.debug_lobbies_widget = UIWidget.init(var_0_4.debug_lobbies)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)
	arg_4_0.scenegraph_definition = var_0_3
	arg_4_0._input_to_widget_mapping = {}

	local var_4_0 = arg_4_0._cancel_input_widgets_by_name

	arg_4_0._input_to_widget_mapping[#arg_4_0._input_to_widget_mapping + 1] = {
		input_action = "cancel_matchmaking",
		widgets = {
			text_widget = var_4_0.cancel_text_input,
			text_widget_prefix = var_4_0.cancel_text_prefix,
			text_widget_suffix = var_4_0.cancel_text_suffix,
			input_icon_widget = var_4_0.cancel_icon
		}
	}

	local var_4_1 = arg_4_0._versus_input_widgets_by_name

	arg_4_0._input_to_widget_mapping[#arg_4_0._input_to_widget_mapping + 1] = {
		input_action = "cancel_matchmaking",
		widgets = {
			text_widget = var_4_1.versus_cancel_text_input,
			text_widget_prefix = var_4_1.versus_cancel_text_prefix,
			text_widget_suffix = var_4_1.versus_cancel_text_suffix,
			input_icon_widget = var_4_1.versus_cancel_icon
		}
	}

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)
end

MatchmakingUI._get_widget = function (arg_5_0, arg_5_1)
	if arg_5_0._active_mechanism == "deus" then
		return arg_5_0._widgets_deus_by_name[arg_5_1]
	elseif arg_5_0._active_mechanism == "versus" then
		return arg_5_0._widgets_versus_by_name[arg_5_1]
	else
		return arg_5_0._widgets_by_name[arg_5_1]
	end
end

MatchmakingUI._get_detail_widget = function (arg_6_0, arg_6_1)
	if arg_6_0._active_mechanism == "deus" then
		return arg_6_0._detail_widgets_deus_by_name[arg_6_1]
	elseif arg_6_0._active_mechanism == "versus" then
		return arg_6_0._detail_widgets_versus_by_name[arg_6_1]
	else
		return arg_6_0._detail_widgets_by_name[arg_6_1]
	end
end

MatchmakingUI._get_widgets = function (arg_7_0)
	if arg_7_0._active_mechanism == "deus" then
		return arg_7_0._widgets_deus, arg_7_0._detail_widgets_deus
	elseif arg_7_0._active_mechanism == "versus" then
		return arg_7_0._widgets_versus, arg_7_0._detail_widgets_versus
	else
		return arg_7_0._widgets, arg_7_0._detail_widgets
	end
end

MatchmakingUI.is_in_inn = function (arg_8_0)
	return arg_8_0._is_in_inn
end

MatchmakingUI.update = function (arg_9_0, arg_9_1, arg_9_2)
	if RESOLUTION_LOOKUP.modified then
		arg_9_0:_update_button_prompts()
	end

	local var_9_0 = arg_9_0._parent
	local var_9_1 = var_9_0:parent()
	local var_9_2 = var_9_1.menu_active
	local var_9_3 = var_9_1.current_view ~= nil
	local var_9_4 = var_9_0:component("IngamePlayerListUI")
	local var_9_5 = var_9_4 and var_9_4:is_active()
	local var_9_6 = not var_9_2 and not var_9_5 and not var_9_3
	local var_9_7 = false

	if var_9_3 then
		local var_9_8 = var_9_1.views[var_9_1.current_view]
		local var_9_9 = var_9_8 and var_9_8.current_state and var_9_8:current_state()

		var_9_7 = var_9_9 and var_9_9.NAME == "HeroViewStateStore"
	end

	local var_9_10 = var_9_0:component("VersusSlotStatusUI")
	local var_9_11 = var_9_10 and var_9_10:is_active()

	var_9_6 = var_9_6 and not var_9_11

	local var_9_12 = arg_9_0.ui_top_renderer
	local var_9_13 = arg_9_0.input_manager:get_service("ingame_menu")
	local var_9_14 = arg_9_0.matchmaking_manager:is_game_matchmaking() and arg_9_0._is_in_inn
	local var_9_15 = arg_9_0.ingame_ui
	local var_9_16 = var_9_15.ingame_hud:component("LevelCountdownUI")
	local var_9_17 = var_9_16 and var_9_16:is_enter_game()
	local var_9_18 = var_9_15.menu_suspended
	local var_9_19 = arg_9_0.voting_manager
	local var_9_20 = var_9_19:vote_in_progress() and var_9_19:is_mission_vote()

	if var_9_18 and not var_9_17 then
		return
	end

	if var_9_6 ~= arg_9_0._show_detailed_matchmaking_info then
		arg_9_0._show_detailed_matchmaking_info = var_9_6
		arg_9_0._detailed_info_visibility_progress = 0
	end

	if var_9_7 ~= arg_9_0._is_in_store_view then
		arg_9_0._is_in_store_view = var_9_7

		arg_9_0:_set_in_view_ui_visibility(not var_9_7)
	end

	for iter_9_0, iter_9_1 in pairs(arg_9_0.ui_animations) do
		UIAnimation.update(iter_9_1, arg_9_1)

		if UIAnimation.completed(iter_9_1) then
			arg_9_0.ui_animations = nil
		end
	end

	if not var_9_17 and (var_9_14 or var_9_20) then
		arg_9_0:_update_background(var_9_14, var_9_20)
		arg_9_0:_update_portraits(var_9_20)
		arg_9_0:_update_status(arg_9_1)
		arg_9_0:_update_show_timer(var_9_20)

		if var_9_14 then
			arg_9_0:_update_matchmaking_info(arg_9_2)
			arg_9_0:_sync_players_ready_state(arg_9_1)

			if arg_9_0._allow_cancel_matchmaking and not var_9_20 and var_9_13:get("cancel_matchmaking") then
				local var_9_21 = arg_9_0.matchmaking_manager

				var_9_21:cancel_matchmaking()

				if var_9_21:have_game_mode_event_data() then
					var_9_21:clear_game_mode_event_data()
				end

				if Managers.deed:has_deed() then
					Managers.deed:reset()
				end

				if Managers.weave:get_next_weave() then
					Managers.weave:set_next_weave(nil)
				end
			end
		elseif var_9_20 then
			arg_9_0:_update_mission_vote_status()
			arg_9_0:_update_mission_vote_player_status()
			arg_9_0:_update_mission_timer()
		end

		arg_9_0:_handle_gamepad_activity()

		if Managers.mechanism:network_handler():get_match_handler():is_leader(arg_9_0._my_peer_id) then
			arg_9_0._allow_cancel_matchmaking = arg_9_0.matchmaking_manager:allow_cancel_matchmaking() and not var_9_20
		end

		arg_9_0:_draw(var_9_12, var_9_13, var_9_14, arg_9_1)
	end
end

MatchmakingUI._handle_gamepad_activity = function (arg_10_0)
	local var_10_0 = arg_10_0.input_manager:is_device_active("gamepad")
	local var_10_1 = Managers.input:get_most_recent_device()
	local var_10_2 = arg_10_0.gamepad_active_last_frame == nil or var_10_0 and var_10_1 ~= arg_10_0._most_recent_device

	if var_10_0 then
		if not arg_10_0.gamepad_active_last_frame or var_10_2 then
			arg_10_0.gamepad_active_last_frame = true

			arg_10_0:_update_button_prompts()
		end
	elseif arg_10_0.gamepad_active_last_frame or var_10_2 then
		arg_10_0.gamepad_active_last_frame = false

		arg_10_0:_update_button_prompts()
	end

	arg_10_0._most_recent_device = var_10_1
end

MatchmakingUI._draw = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_0._detailed_info_visibility_progress

	if var_11_0 then
		local var_11_1 = math.min(var_11_0 + arg_11_4 * 1.2, 1)
		local var_11_2 = math.easeOutCubic(var_11_1)
		local var_11_3 = var_0_3.detailed_info_box
		local var_11_4 = var_11_3.size
		local var_11_5 = var_11_3.position

		arg_11_0.ui_scenegraph.detailed_info_box.local_position[2] = var_11_4[2] * (1 - var_11_2) + var_11_5[2]

		if var_11_1 == 1 then
			arg_11_0._detailed_info_visibility_progress = nil
		else
			arg_11_0._detailed_info_visibility_progress = var_11_1
		end
	end

	local var_11_6, var_11_7 = arg_11_0:_get_widgets()

	UIRenderer.begin_pass(arg_11_1, arg_11_0.ui_scenegraph, arg_11_2, arg_11_4, nil, arg_11_0.render_settings)
	UIRenderer.draw_all_widgets(arg_11_1, var_11_6)

	if arg_11_0._show_detailed_matchmaking_info then
		if arg_11_0._active_mechanism == "versus" then
			if not Managers.state.voting:cancel_disabled() then
				UIRenderer.draw_all_widgets(arg_11_1, arg_11_0._versus_input_widgets)
			end
		elseif arg_11_0._allow_cancel_matchmaking then
			UIRenderer.draw_all_widgets(arg_11_1, arg_11_0._cancel_input_widgets)
		end

		UIRenderer.draw_all_widgets(arg_11_1, var_11_7)
	end

	UIRenderer.end_pass(arg_11_1)
end

MatchmakingUI._update_background = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0

	if arg_12_1 then
		var_12_0 = "matchmaking_window_01"
	elseif arg_12_2 then
		var_12_0 = "matchmaking_window_02"
	end

	if var_12_0 then
		local var_12_1 = arg_12_0:_get_detail_widget("detailed_info_box").content
		local var_12_2 = var_12_1.background

		if not var_12_1.no_background_changes and var_12_2.texture_id ~= var_12_0 then
			var_12_2.texture_id = var_12_0
		end
	end
end

MatchmakingUI._update_matchmaking_info = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.matchmaking_manager
	local var_13_1 = var_13_0:search_info()
	local var_13_2 = arg_13_0._cached_matchmaking_info

	if IS_XB1 and var_13_1.no_lobby_data then
		arg_13_0:_get_widget("status_text").content.text = Localize("loading_fetching_matchmaking_data")
		arg_13_0:_get_detail_widget("title_text").content.text = string.rep(".", 1 + math.floor((arg_13_1 * 5 + 0.5) % 4))
		arg_13_0:_get_detail_widget("difficulty_text").content.text = ""

		return
	end

	local var_13_3 = var_13_1.mechanism

	arg_13_0._active_mechanism = var_13_3

	if var_13_3 == "weave" then
		if var_13_1.quick_game then
			local var_13_4 = "start_game_window_weave_quickplay_title"

			arg_13_0:_set_detail_level_text(var_13_4, true)

			local var_13_5 = var_13_1.difficulty
			local var_13_6 = var_13_5 and DifficultySettings[var_13_5]
			local var_13_7 = var_13_6 and var_13_6.display_name or "dlc1_2_difficulty_unavailable"

			arg_13_0:_set_detail_difficulty_text(var_13_7, nil, false)
		else
			local var_13_8 = var_13_1.mission_id
			local var_13_9 = WeaveSettings.templates
			local var_13_10 = var_13_8 and var_13_9[var_13_8]
			local var_13_11 = var_13_10 and table.find(WeaveSettings.templates_ordered, var_13_10) or nil
			local var_13_12 = var_13_10 and var_13_11 .. ". " .. Localize(var_13_10.display_name) or Localize("level_display_name_unavailable")

			arg_13_0:_set_detail_level_text(var_13_12, false)

			local var_13_13 = var_13_10 and var_13_10.wind
			local var_13_14 = var_13_13 and WindSettings[var_13_13]
			local var_13_15 = var_13_14 and var_13_14.display_name or ""

			arg_13_0:_set_detail_difficulty_text(var_13_15, var_0_7[var_13_13])
		end
	elseif var_13_3 == "deus" then
		local var_13_16 = "mission_vote_quick_play"

		if not var_13_1.quick_game then
			local var_13_17 = var_13_1.mission_id
			local var_13_18 = var_13_17 and DeusJourneySettings[var_13_17]

			var_13_16 = var_13_18 and var_13_18.display_name or "deus_matching"
		end

		arg_13_0:_set_detail_level_text(var_13_16, true)

		local var_13_19 = var_13_1.difficulty

		if var_13_19 ~= var_13_2.difficulty then
			var_13_2.difficulty = var_13_19

			local var_13_20 = var_13_19 and DifficultySettings[var_13_19]
			local var_13_21 = var_13_20 and var_13_20.display_name or "dlc1_2_difficulty_unavailable"

			arg_13_0:_set_detail_difficulty_text(var_13_21)
		end
	elseif var_13_3 == "versus" then
		local var_13_22 = "mission_vote_quick_play"
		local var_13_23 = "vs_ui_versus_tag"

		if not var_13_1.quick_game then
			local var_13_24 = var_13_1.mission_id

			if var_13_24 == "any" then
				var_13_22 = "map_screen_quickplay_button"
			else
				local var_13_25 = var_13_24 and LevelSettings[var_13_24]

				var_13_22 = var_13_25 and var_13_25.display_name or var_13_22
			end

			var_13_23 = "player_hosted_title"
		end

		arg_13_0:_set_detail_level_text(var_13_22, true)
		arg_13_0:_set_detail_difficulty_text(var_13_23)
	else
		local var_13_26 = var_13_1.difficulty

		if var_13_26 ~= var_13_2.difficulty then
			var_13_2.difficulty = var_13_26

			local var_13_27 = var_13_26 and DifficultySettings[var_13_26]
			local var_13_28 = var_13_27 and var_13_27.display_name or "dlc1_2_difficulty_unavailable"

			arg_13_0:_set_detail_difficulty_text(var_13_28)
		end

		local var_13_29 = var_13_1.quick_game
		local var_13_30 = var_13_29 ~= var_13_2.quick_game
		local var_13_31 = var_13_1.mission_id
		local var_13_32 = var_13_31 ~= var_13_2.mission_id

		if var_13_30 or var_13_32 then
			var_13_2.quick_game = var_13_29
			var_13_2.mission_id = var_13_31

			local var_13_33 = var_13_0:have_game_mode_event_data()
			local var_13_34

			if var_13_29 then
				var_13_34 = "mission_vote_quick_play"
			elseif var_13_33 then
				local var_13_35 = var_13_31 and var_13_31 ~= "n/a" and LevelSettings[var_13_31]

				var_13_34 = var_13_35 and var_13_35.display_name or "random_level"
			else
				local var_13_36 = var_13_31 and var_13_31 ~= "n/a" and LevelSettings[var_13_31]

				var_13_34 = var_13_36 and var_13_36.display_name or "level_display_name_unavailable"
			end

			arg_13_0:_set_detail_level_text(var_13_34, true)
		end
	end

	local var_13_37 = var_13_1.status

	if var_13_37 ~= var_13_2[var_13_37] then
		var_13_2.status = var_13_37

		arg_13_0:_set_status_text(var_13_37)
	end
end

MatchmakingUI._update_status = function (arg_14_0, arg_14_1)
	local var_14_0 = ((arg_14_0._rotation_progresss or 0) + arg_14_1 * 0.2) % 1

	arg_14_0._rotation_progresss = var_14_0

	local var_14_1 = math.easeCubic(var_14_0) * 360
	local var_14_2 = math.degrees_to_radians(var_14_1)

	arg_14_0:_get_widget("loading_status_frame").style.texture_id.angle = var_14_2

	local var_14_3 = arg_14_1 * 200 % 360
	local var_14_4 = math.degrees_to_radians(var_14_3)

	if arg_14_0._active_mechanism ~= "versus" then
		for iter_14_0 = 1, 4 do
			local var_14_5 = "party_slot_" .. iter_14_0
			local var_14_6 = arg_14_0:_get_detail_widget(var_14_5)
			local var_14_7 = var_14_6.content
			local var_14_8 = var_14_6.style
			local var_14_9 = var_14_7.is_connecting
			local var_14_10 = var_14_8.connecting_icon

			var_14_10.angle = var_14_9 and var_14_10.angle + var_14_4 or 0
		end
	end
end

MatchmakingUI._update_mission_vote_status = function (arg_15_0)
	local var_15_0 = arg_15_0.voting_manager
	local var_15_1 = var_15_0:vote_in_progress()
	local var_15_2 = var_15_0:active_vote_data()
	local var_15_3 = var_15_2.difficulty
	local var_15_4 = var_15_2.mission_id
	local var_15_5 = var_15_2.quick_game
	local var_15_6 = var_15_2.event_data
	local var_15_7 = var_15_2.mechanism
	local var_15_8 = var_15_2.switch_mechanism

	arg_15_0._active_mechanism = var_15_7

	if var_15_8 then
		local var_15_9 = MechanismSettings[var_15_7]
		local var_15_10 = var_15_2.level_key or "inn_level"
		local var_15_11 = LevelSettings[var_15_10]

		arg_15_0:_set_detail_level_text(var_15_9.display_name, true)
		arg_15_0:_set_detail_difficulty_text(var_15_11.display_name, nil, false)
	elseif var_15_7 == "weave" then
		if var_15_5 then
			local var_15_12 = "start_game_window_weave_quickplay_title"

			arg_15_0:_set_detail_level_text(var_15_12, true)

			local var_15_13 = var_15_3 and DifficultySettings[var_15_3]
			local var_15_14 = var_15_13 and var_15_13.display_name or "dlc1_2_difficulty_unavailable"

			arg_15_0:_set_detail_difficulty_text(var_15_14, nil, false)
		else
			local var_15_15 = var_15_4
			local var_15_16 = WeaveSettings.templates
			local var_15_17 = var_15_15 and var_15_16[var_15_15]
			local var_15_18 = var_15_17 and table.find(WeaveSettings.templates_ordered, var_15_17) or nil
			local var_15_19 = var_15_17 and var_15_18 .. ". " .. Localize(var_15_17.display_name) or Localize("level_display_name_unavailable")

			arg_15_0:_set_detail_level_text(var_15_19, false)

			local var_15_20 = var_15_17 and var_15_17.wind
			local var_15_21 = var_15_20 and WindSettings[var_15_20]
			local var_15_22 = var_15_21 and var_15_21.display_name or ""

			arg_15_0:_set_detail_difficulty_text(var_15_22, var_0_7[var_15_20])
		end
	elseif var_15_7 == "deus" then
		arg_15_0:_set_detail_level_text("deus_matching", true)

		local var_15_23 = DifficultySettings[var_15_3]
		local var_15_24 = var_15_23 and var_15_23.display_name

		arg_15_0:_set_detail_difficulty_text(var_15_24 or "")
	elseif var_15_7 == "versus" then
		local var_15_25 = "mission_vote_quick_play"
		local var_15_26 = "vs_ui_versus_tag"

		if not var_15_5 then
			if var_15_4 == "any" then
				var_15_25 = "map_screen_quickplay_button"
			else
				local var_15_27 = var_15_4 and LevelSettings[var_15_4]

				var_15_25 = var_15_27 and var_15_27.display_name or var_15_25
			end

			var_15_26 = "player_hosted_title"
		end

		arg_15_0:_set_detail_level_text(var_15_25, true)
		arg_15_0:_set_detail_difficulty_text(var_15_26)
	else
		local var_15_28 = DifficultySettings[var_15_3]
		local var_15_29 = var_15_28 and var_15_28.display_name
		local var_15_30
		local var_15_31 = var_15_5 and "mission_vote_quick_play" or var_15_4 == nil and "random_level" or LevelSettings[var_15_4].display_name

		arg_15_0:_set_detail_difficulty_text(var_15_29 or "")
		arg_15_0:_set_detail_level_text(var_15_31, true)
	end

	local var_15_32 = var_15_1

	arg_15_0:_set_status_text(var_15_32)
end

MatchmakingUI._update_mission_vote_player_status = function (arg_16_0)
	local var_16_0 = arg_16_0.voting_manager:get_current_voters()

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		local var_16_1 = arg_16_0:_get_portrait_index(iter_16_0)

		if var_16_1 ~= nil then
			if iter_16_1 == 1 then
				arg_16_0:_set_player_voted_yes(var_16_1, true)
			elseif iter_16_1 == "undecided" then
				arg_16_0:_set_player_voted_yes(var_16_1, false)
			end
		end
	end
end

MatchmakingUI._update_mission_timer = function (arg_17_0)
	local var_17_0 = arg_17_0.voting_manager
	local var_17_1 = var_17_0:active_vote_template().duration
	local var_17_2 = var_17_0:vote_time_left()
	local var_17_3 = math.max(var_17_2 / var_17_1, 0)

	arg_17_0:_set_vote_time_progress(var_17_3)
end

MatchmakingUI._update_show_timer = function (arg_18_0, arg_18_1)
	local var_18_0
	local var_18_1 = arg_18_1 and 255 or 0
	local var_18_2 = arg_18_0:_get_detail_widget("timer_bg")
	local var_18_3 = arg_18_0:_get_detail_widget("timer_fg")
	local var_18_4 = arg_18_0:_get_detail_widget("timer_glow")

	var_18_2.style.texture_id.color[1] = var_18_1
	var_18_3.style.texture_id.color[1] = var_18_1
	var_18_4.style.texture_id.color[1] = var_18_1
end

MatchmakingUI.update_debug = function (arg_19_0)
	if not Managers.matchmaking:active_lobby() then
		return
	end

	local var_19_0 = ((((((((("" .. "\nStatename: " .. (Managers.matchmaking.debug.statename or "-")) .. "\nState: " .. Managers.matchmaking.debug.state) .. "\nInfo: " .. Managers.matchmaking.debug.text or "matchmaking debug") .. "\n") .. "\nDistance: " .. (Managers.matchmaking.debug.distance or "?/" .. MatchmakingSettings.max_distance_filter)) .. "\nLevel: " .. Managers.matchmaking.debug.level) .. "\nDifficulty: " .. Managers.matchmaking.debug.difficulty) .. "\nHero: " .. Managers.matchmaking.debug.hero) .. "\nProgression: " .. Managers.matchmaking.debug.progression) .. "\n"

	arg_19_0.debug_box_widget.content.debug_text = var_19_0
end

MatchmakingUI.destroy = function (arg_20_0)
	return
end

MatchmakingUI.get_input_texture_data = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.input_manager
	local var_21_1 = var_21_0:get_service("ingame_menu")
	local var_21_2 = var_21_0:is_device_active("gamepad")
	local var_21_3 = var_21_0:get_most_recent_device()
	local var_21_4 = PLATFORM

	if IS_XB1 and GameSettingsDevelopment.allow_keyboard_mouse and not var_21_2 then
		var_21_4 = "win32"
	elseif IS_WINDOWS and var_21_2 then
		var_21_4 = "xb1"
		var_21_4 = var_21_3.type() == "sce_pad" and "ps_pad" or var_21_4
	end

	local var_21_5 = var_21_1:get_keymapping(arg_21_1, var_21_4)
	local var_21_6 = var_21_5[1]
	local var_21_7 = var_21_5[2]
	local var_21_8 = var_21_5[3]
	local var_21_9

	if var_21_8 == "held" then
		var_21_9 = "matchmaking_prefix_hold"
	end

	if var_21_6 == "keyboard" then
		return nil, Keyboard.button_locale_name(var_21_7) or Keyboard.button_name(var_21_7), var_21_9
	elseif var_21_6 == "mouse" then
		return nil, Mouse.button_name(var_21_7), var_21_9
	elseif var_21_6 == "gamepad" or var_21_6 == "ps_pad" then
		local var_21_10 = var_21_3.button_name(var_21_7)

		return ButtonTextureByName(var_21_10, var_21_4), var_21_10, var_21_9
	end

	return nil, ""
end

MatchmakingUI._update_button_prompts = function (arg_22_0)
	local var_22_0 = Managers.input:is_device_active("gamepad")
	local var_22_1 = arg_22_0.ui_scenegraph

	for iter_22_0, iter_22_1 in ipairs(arg_22_0._input_to_widget_mapping) do
		local var_22_2 = iter_22_1.widgets
		local var_22_3 = var_22_2.text_widget
		local var_22_4 = var_22_2.text_widget_prefix
		local var_22_5 = var_22_2.text_widget_suffix
		local var_22_6 = var_22_2.input_icon_widget
		local var_22_7 = iter_22_1.input_action
		local var_22_8, var_22_9, var_22_10 = arg_22_0:get_input_texture_data(var_22_7)

		var_22_4.content.text = var_22_10 and Localize(var_22_10) or ""

		if not var_22_8 then
			var_22_3.content.text = "[" .. var_22_9 .. "] "
			var_22_6.content.texture_id = nil
			var_22_6.content.visible = false
		elseif var_22_8.texture then
			var_22_3.content.text = ""
			var_22_6.content.texture_id = var_22_8.texture
			var_22_6.content.visible = true
		end

		local var_22_11 = var_22_3.content.text
		local var_22_12 = var_22_4.content.text
		local var_22_13 = var_22_5.content.text
		local var_22_14, var_22_15 = UIFontByResolution(var_22_3.style.text)
		local var_22_16, var_22_17 = UIFontByResolution(var_22_4.style.text)
		local var_22_18, var_22_19 = UIFontByResolution(var_22_5.style.text)
		local var_22_20 = UIRenderer.text_size(arg_22_0.ui_renderer, var_22_11, var_22_14[1], var_22_15)
		local var_22_21 = UIRenderer.text_size(arg_22_0.ui_renderer, var_22_12, var_22_16[1], var_22_17)
		local var_22_22 = UIRenderer.text_size(arg_22_0.ui_renderer, var_22_13, var_22_18[1], var_22_19)

		if var_22_8 then
			local var_22_23 = var_22_8.size
			local var_22_24 = var_22_1[var_22_6.scenegraph_id]

			var_22_20 = var_22_23[1]
			var_22_24.size[1] = var_22_20
			var_22_24.size[2] = var_22_23[2]
		end

		local var_22_25 = -((var_22_20 + var_22_21 + var_22_22) * 0.5)

		if not var_22_8 then
			var_22_4.style.text.offset[1] = var_22_25
			var_22_4.style.text_shadow.offset[1] = var_22_25 + 2
			var_22_3.style.text.offset[1] = var_22_25 + var_22_21
			var_22_3.style.text_shadow.offset[1] = var_22_25 + var_22_21 + 2
			var_22_5.style.text.offset[1] = var_22_25 + (var_22_21 + var_22_20)
			var_22_5.style.text_shadow.offset[1] = var_22_25 + (var_22_21 + var_22_20) + 2
		else
			var_22_6.style.texture_id.offset[1] = var_22_25
			var_22_4.style.text.offset[1] = var_22_25
			var_22_4.style.text_shadow.offset[1] = var_22_25 + 2
			var_22_5.style.text.offset[1] = var_22_25 + (var_22_21 + var_22_20)
			var_22_5.style.text_shadow.offset[1] = var_22_25 + (var_22_21 + var_22_20) + 2
		end
	end
end

MatchmakingUI._update_portraits = function (arg_23_0, arg_23_1)
	if arg_23_0._active_mechanism == "versus" then
		return
	end

	local var_23_0 = arg_23_0.profile_synchronizer
	local var_23_1 = Managers.player
	local var_23_2 = arg_23_0.lobby:members()
	local var_23_3 = var_23_2 and var_23_2:members_map()

	if var_23_3 then
		local var_23_4 = arg_23_0.portrait_index_table

		for iter_23_0 = 1, arg_23_0._max_number_of_players do
			local var_23_5 = var_23_4[iter_23_0]

			if var_23_5 and not var_23_3[var_23_5] then
				var_23_4[iter_23_0] = nil

				arg_23_0:large_window_set_player_portrait(iter_23_0, nil)
				arg_23_0:large_window_set_player_connecting(iter_23_0, false)
				arg_23_0:_set_player_is_voting(iter_23_0, false)
				arg_23_0:_set_player_voted_yes(iter_23_0, false)
			end
		end

		for iter_23_1, iter_23_2 in pairs(var_23_3) do
			local var_23_6 = arg_23_0:_get_portrait_index(iter_23_1)

			if not var_23_6 then
				var_23_6 = arg_23_0:_get_first_free_portrait_index()

				if not var_23_6 then
					goto label_23_0
				end

				var_23_4[var_23_6] = iter_23_1
			end

			if arg_23_1 then
				arg_23_0:_set_player_is_voting(var_23_6, true)
			else
				arg_23_0:_set_player_is_voting(var_23_6, false)
			end

			if var_23_0:profile_by_peer(iter_23_1, 1) then
				arg_23_0:large_window_set_player_portrait(var_23_6, iter_23_1)

				if var_23_1:player_from_peer_id(iter_23_1) then
					arg_23_0:large_window_set_player_connecting(var_23_6, false)
				end
			else
				arg_23_0:large_window_set_player_connecting(var_23_6, true)
			end

			::label_23_0::
		end
	end
end

MatchmakingUI._get_portrait_index = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.portrait_index_table

	for iter_24_0 = 1, arg_24_0._max_number_of_players do
		if var_24_0[iter_24_0] == arg_24_1 then
			return iter_24_0
		end
	end
end

MatchmakingUI._get_first_free_portrait_index = function (arg_25_0)
	local var_25_0 = arg_25_0.portrait_index_table

	for iter_25_0 = 1, arg_25_0._max_number_of_players do
		if var_25_0[iter_25_0] == nil then
			return iter_25_0
		end
	end
end

MatchmakingUI.large_window_set_title = function (arg_26_0, arg_26_1)
	arg_26_0:_get_detail_widget("title_text").content.text = Localize(arg_26_1)
end

MatchmakingUI.large_window_set_status_message = function (arg_27_0, arg_27_1)
	fassert(arg_27_1 ~= " ", "tried to pass empty status message to matchmaking ui")

	arg_27_0:_get_widget("status_text").content.text = Localize(arg_27_1)
end

MatchmakingUI.large_window_set_difficulty = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_1 and DifficultySettings[arg_28_1]
	local var_28_1 = var_28_0 and var_28_0.display_name or "dlc1_2_difficulty_unavailable"

	arg_28_0:_get_detail_widget("difficulty_text").content.text = Localize(var_28_1)
end

MatchmakingUI.large_window_set_player_portrait = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0:_get_detail_widget("party_slot_" .. arg_29_1)
	local var_29_1 = arg_29_0:_get_widget("player_status_" .. arg_29_1)
	local var_29_2 = var_29_0.content
	local var_29_3

	if arg_29_2 then
		local var_29_4 = Managers.player:player(arg_29_2, 1)
		local var_29_5 = var_29_4 and var_29_4.player_unit

		if Unit.alive(var_29_5) then
			local var_29_6 = var_29_4:career_index()
			local var_29_7 = var_29_4:profile_index()

			if var_29_6 and var_29_7 then
				var_29_3 = var_0_6(var_29_7, var_29_6)
			end
		end
	end

	var_29_2.is_connected = var_29_3 ~= nil
	var_29_2.peer_id = arg_29_2
	var_29_1.content.is_connected = var_29_3 ~= nil
	var_29_3 = var_29_3 or "small_unit_frame_portrait_default"
	var_29_2.portrait = var_29_3
end

MatchmakingUI._get_party_slot_index_by_peer_id = function (arg_30_0, arg_30_1)
	for iter_30_0 = 1, arg_30_0._max_number_of_players do
		local var_30_0 = "party_slot_" .. iter_30_0

		if arg_30_0:_get_detail_widget(var_30_0).content.peer_id == arg_30_1 then
			return iter_30_0
		end
	end
end

MatchmakingUI._sync_players_ready_state = function (arg_31_0, arg_31_1)
	if arg_31_0._active_mechanism == "versus" then
		return
	end

	local var_31_0 = Managers.player:human_players()

	for iter_31_0, iter_31_1 in pairs(var_31_0) do
		local var_31_1 = iter_31_1.player_unit

		if Unit.alive(var_31_1) then
			local var_31_2 = ScriptUnit.extension(var_31_1, "status_system"):is_in_end_zone()
			local var_31_3 = iter_31_1.peer_id
			local var_31_4 = arg_31_0:_get_party_slot_index_by_peer_id(var_31_3)

			if var_31_4 then
				arg_31_0:_set_player_ready_state(var_31_4, var_31_2)
			end
		end
	end
end

MatchmakingUI._set_player_ready_state = function (arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0:_get_detail_widget("party_slot_" .. arg_32_1)
	local var_32_1 = arg_32_0:_get_widget("player_status_" .. arg_32_1)

	var_32_0.content.is_ready = arg_32_2
	var_32_1.content.is_ready = arg_32_2
	var_32_1.content.texture_id = arg_32_2 and "matchmaking_light_01" or "matchmaking_light_02"
end

MatchmakingUI.large_window_set_player_connecting = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0:_get_detail_widget("party_slot_" .. arg_33_1)
	local var_33_1 = arg_33_0:_get_widget("player_status_" .. arg_33_1)

	var_33_0.content.is_connecting = arg_33_2
	var_33_1.content.is_connecting = arg_33_2
end

MatchmakingUI._set_player_is_voting = function (arg_34_0, arg_34_1, arg_34_2)
	arg_34_0:_get_detail_widget("party_slot_" .. arg_34_1).content.is_voting = arg_34_2
end

MatchmakingUI._set_player_voted_yes = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0:_get_detail_widget("party_slot_" .. arg_35_1)

	if not var_35_0 then
		return
	end

	var_35_0.content.voted_yes = arg_35_2
end

MatchmakingUI._set_detail_difficulty_text = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = arg_36_0:_get_detail_widget("difficulty_text")

	var_36_0.content.text = arg_36_3 and arg_36_1 or Localize(arg_36_1)
	var_36_0.style.text.text_color = arg_36_2 or var_36_0.style.text.default_color or var_0_7.default
end

MatchmakingUI._set_detail_level_text = function (arg_37_0, arg_37_1, arg_37_2)
	arg_37_0:_get_detail_widget("title_text").content.text = arg_37_2 and Localize(arg_37_1) or arg_37_1
end

MatchmakingUI._set_status_text = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0:_get_widget("status_text")

	arg_38_1 = var_0_8[arg_38_1] or arg_38_1
	var_38_0.content.text = Localize(arg_38_1)
end

MatchmakingUI._set_vote_time_progress = function (arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0:_get_detail_widget("timer_fg")
	local var_39_1 = var_39_0.content.texture_id.uvs
	local var_39_2 = var_39_0.scenegraph_id
	local var_39_3 = arg_39_0.scenegraph_definition[var_39_2].size

	arg_39_0.ui_scenegraph[var_39_2].size[1] = var_39_3[1] * arg_39_1
	var_39_1[2][1] = arg_39_1
end

MatchmakingUI._set_in_view_ui_visibility = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0._widgets_by_name.window
	local var_40_1 = arg_40_0._widgets_by_name.status_text
	local var_40_2 = arg_40_0._widgets_deus_by_name.window
	local var_40_3 = arg_40_0._widgets_deus_by_name.status_text
	local var_40_4 = arg_40_0._widgets_versus_by_name.window
	local var_40_5 = arg_40_0._widgets_versus_by_name.status_text
	local var_40_6 = arg_40_1 and 0 or 0.765
	local var_40_7 = arg_40_1 and 506 or 118.91
	local var_40_8 = arg_40_1 and "left" or "right"

	var_40_0.content.texture_id.uvs[1][1] = var_40_6
	var_40_0.style.texture_id.texture_size[1] = var_40_7
	var_40_0.style.texture_id.horizontal_alignment = var_40_8
	var_40_1.content.visible = arg_40_1
	var_40_2.content.texture_id.uvs[1][1] = var_40_6
	var_40_2.style.texture_id.texture_size[1] = var_40_7
	var_40_2.style.texture_id.horizontal_alignment = var_40_8
	var_40_3.content.visible = arg_40_1
	var_40_4.content.texture_id.uvs[1][1] = var_40_6
	var_40_4.style.texture_id.texture_size[1] = var_40_7
	var_40_4.style.texture_id.horizontal_alignment = var_40_8
	var_40_5.content.visible = arg_40_1
end

MatchmakingUI.on_matchmaking_num_players_in_matchmaking = function (arg_41_0, arg_41_1, arg_41_2)
	if not (arg_41_0.matchmaking_manager:is_game_matchmaking() and arg_41_0._is_in_inn) then
		return
	end

	local var_41_0 = arg_41_0:_get_detail_widget("num_players_matchmaking")

	if not var_41_0 then
		return
	end

	var_41_0.content.text = string.format("%d Players in Queue", arg_41_2)
end
