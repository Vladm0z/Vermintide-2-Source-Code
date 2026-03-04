-- chunkname: @scripts/ui/views/start_game_view/states/start_game_state_weave_leaderboard.lua

require("scripts/helpers/weave_utils")

local var_0_0 = local_require("scripts/ui/views/start_game_view/states/definitions/start_game_state_weave_leaderboard_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.console_cursor_definition
local var_0_5 = var_0_0.generic_input_actions
local var_0_6 = false
local var_0_7 = 20
local var_0_8 = 4
local var_0_9 = 800
local var_0_10 = 12
local var_0_11 = 0.3
local var_0_12 = 1.5
local var_0_13 = {
	Localize("menu_weave_leaderboard_tier_3_title"),
	Localize("menu_weave_leaderboard_tier_2_title"),
	Localize("menu_weave_leaderboard_tier_1_title")
}
local var_0_14 = {
	Localize("menu_weave_leaderboard_tier_tooltip_bronze"),
	Localize("menu_weave_leaderboard_tier_tooltip_silver"),
	Localize("menu_weave_leaderboard_tier_tooltip_gold")
}
local var_0_15 = {
	Localize("menu_weave_leaderboard_button_refresh_2"),
	Localize("menu_weave_leaderboard_button_refresh_1")
}

StartGameStateWeaveLeaderboard = class(StartGameStateWeaveLeaderboard)
StartGameStateWeaveLeaderboard.NAME = "StartGameStateWeaveLeaderboard"

function StartGameStateWeaveLeaderboard.on_enter(arg_1_0, arg_1_1)
	print("[StartGameState] Enter Substate StartGameStateWeaveLeaderboard")

	arg_1_0.parent = arg_1_1.parent
	arg_1_0._gamepad_style_active = false
	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0._hero_name = arg_1_1.hero_name

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._network_lobby = var_1_0.network_lobby
	arg_1_0._stats_id = Managers.player:local_player():stats_id()
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._is_open = true
	arg_1_0._close_on_exit = true

	arg_1_0:_create_ui_elements(arg_1_1)

	if arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		arg_1_0:_start_transition_animation("on_enter", "on_enter")
	end

	if arg_1_0._gamepad_style_active then
		arg_1_0:disable_player_world()
	end

	local var_1_1 = {
		{
			value = "friends",
			text = Localize("menu_weave_leaderboard_filter_option_friends")
		},
		{
			value = "global",
			text = Localize("menu_weave_leaderboard_filter_option_global")
		}
	}
	local var_1_2 = {
		{
			value = "personal",
			text = Localize("menu_weave_leaderboard_filter_option_you")
		},
		{
			value = "top",
			text = Localize("menu_weave_leaderboard_filter_option_top")
		}
	}
	local var_1_3 = {
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
	local var_1_4 = {}
	local var_1_5 = {}
	local var_1_6 = ""
	local var_1_7 = Localize("menu_weave_leaderboard_filter_sesason")

	arg_1_0._current_season_id = ScorpionSeasonalSettings.current_season_id

	for iter_1_0 = 1, arg_1_0._current_season_id do
		var_1_4[iter_1_0] = {
			ScorpionSeasonalSettings.get_leaderboard_stat_for_season(iter_1_0, 1),
			ScorpionSeasonalSettings.get_leaderboard_stat_for_season(iter_1_0, 2),
			ScorpionSeasonalSettings.get_leaderboard_stat_for_season(iter_1_0, 3),
			ScorpionSeasonalSettings.get_leaderboard_stat_for_season(iter_1_0, 4)
		}

		if iter_1_0 == arg_1_0._current_season_id then
			var_1_6 = Localize("menu_weave_leaderboard_current_season")
		else
			var_1_6 = string.format(var_1_7, iter_1_0)
		end

		var_1_5[iter_1_0] = {
			text = var_1_6,
			value = iter_1_0
		}
	end

	arg_1_0._season_data = var_1_5
	arg_1_0._season_stat_data = var_1_4
	arg_1_0._team_size_data = var_1_3
	arg_1_0._filter_data = var_1_2
	arg_1_0._leaderboard_tab_data = var_1_1

	arg_1_0:_setup_tab_widget(var_1_1)
	arg_1_0:_select_tab_by_index(1)
	arg_1_0:_initialize_stepper(1, Localize("menu_weave_leaderboard_filter_title_position"), var_1_2)
	arg_1_0:_initialize_stepper(2, Localize("menu_weave_leaderboard_filter_title_team_size"), var_1_3, #var_1_3)

	if not IS_WINDOWS then
		arg_1_0:_initialize_stepper(3, Localize("menu_weave_leaderboard_filter_season"), var_1_5, #var_1_5)
	end

	arg_1_0:_restart_poll_queue(Managers.time:time("ui"))
	arg_1_0:_update_leaderboard_presentation()
	Managers.input:enable_gamepad_cursor()
	arg_1_0:play_sound("menu_leaderboard_open")
end

function StartGameStateWeaveLeaderboard._setup_poll_queue(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._poll_queues = {}

	for iter_2_0, iter_2_1 in ipairs(arg_2_1) do
		local var_2_0 = iter_2_1.value

		for iter_2_2, iter_2_3 in ipairs(arg_2_2) do
			local var_2_1 = iter_2_3.value

			for iter_2_4 = #arg_2_3, 1, -1 do
				local var_2_2 = iter_2_4
				local var_2_3 = arg_2_3[iter_2_4]

				for iter_2_5 = #var_2_3, 1, -1 do
					local var_2_4 = var_2_3[iter_2_5]

					arg_2_0:_add_poll_queue(var_2_1, var_2_0, var_2_4, var_2_2)
				end
			end
		end
	end
end

function StartGameStateWeaveLeaderboard._restart_poll_queue(arg_3_0, arg_3_1)
	arg_3_0._cashed_list_season_data = {}

	arg_3_0:_setup_poll_queue(arg_3_0._leaderboard_tab_data, arg_3_0._filter_data, arg_3_0._season_stat_data)
	arg_3_0:_handle_next_poll_request(arg_3_1)
end

function StartGameStateWeaveLeaderboard._add_poll_queue(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if IS_WINDOWS and arg_4_4 ~= arg_4_0._current_season_id then
		return
	end

	local var_4_0 = arg_4_0._leaderboard_tab_data
	local var_4_1

	for iter_4_0 = 1, #var_4_0 do
		if var_4_0[iter_4_0].value == arg_4_2 then
			var_4_1 = iter_4_0

			break
		end
	end

	if var_4_1 then
		local var_4_2 = arg_4_0._poll_queues
		local var_4_3 = var_4_2[var_4_1] or {}

		var_4_2[var_4_1] = var_4_3
		var_4_3[#var_4_3 + 1] = {
			filter_value = arg_4_1,
			leaderboard_type = arg_4_2,
			stat_name = arg_4_3,
			season_id = arg_4_4
		}
	end

	arg_4_0._polling_done = false
end

function StartGameStateWeaveLeaderboard._handle_next_poll_request(arg_5_0, arg_5_1)
	if arg_5_0._polling_done then
		return true
	end

	local var_5_0 = arg_5_0._poll_queues
	local var_5_1 = arg_5_0._selected_option_tab_index or 1
	local var_5_2

	if var_5_1 and #var_5_0[var_5_1] > 0 then
		local var_5_3 = var_5_0[var_5_1]
		local var_5_4

		for iter_5_0 = 1, #var_5_3 do
			local var_5_5 = var_5_3[iter_5_0]
			local var_5_6 = var_5_5.leaderboard_type
			local var_5_7 = var_5_5.filter_value
			local var_5_8 = var_5_5.stat_name

			if arg_5_0._stat_name == var_5_8 and arg_5_0._filter_value == var_5_7 and arg_5_0._leaderboard_type == var_5_6 then
				var_5_4 = iter_5_0

				break
			else
				var_5_4 = var_5_4 or iter_5_0
			end
		end

		var_5_2 = table.remove(var_5_3, var_5_4)
	else
		for iter_5_1 = 1, #var_5_0 do
			local var_5_9 = var_5_0[iter_5_1]

			if #var_5_9 > 0 then
				var_5_2 = table.remove(var_5_9, 1)

				break
			end
		end
	end

	if not var_5_2 then
		arg_5_0._polling_done = true

		return
	end

	local var_5_10 = var_5_2.filter_value
	local var_5_11 = var_5_2.leaderboard_type
	local var_5_12 = var_5_2.stat_name
	local var_5_13 = var_5_2.season_id
	local var_5_14 = Managers.backend:get_interface("weaves")

	if var_5_10 == "top" then
		local var_5_15 = 0

		var_5_14:request_leaderboard(var_5_12, var_5_15, var_5_11)
	elseif var_5_10 == "personal" then
		local var_5_16 = 100

		var_5_14:request_leaderboard_around_player(var_5_12, var_5_11, var_5_16)
	end

	arg_5_0._polling_callback = callback(arg_5_0, "_cb_cashe_list_data", var_5_10, var_5_11, var_5_12, var_5_13)
	arg_5_0._min_poll_time = Managers.time:time("ui") + var_0_12
end

function StartGameStateWeaveLeaderboard._update_leaderboard_presentation(arg_6_0)
	local var_6_0
	local var_6_1
	local var_6_2
	local var_6_3
	local var_6_4 = arg_6_0._stepper_settings

	if var_6_4 then
		for iter_6_0 = 1, #var_6_4 do
			local var_6_5 = var_6_4[iter_6_0]
			local var_6_6 = var_6_5.content
			local var_6_7 = var_6_5.read_index
			local var_6_8 = var_6_5.stepper_name
			local var_6_9 = var_6_6[var_6_7].value

			if var_6_8 == "setting_stepper_1" then
				var_6_1 = var_6_9
			end

			if var_6_8 == "setting_stepper_2" then
				var_6_0 = var_6_9
			end

			if var_6_8 == "setting_stepper_3" then
				var_6_2 = var_6_9
			end
		end
	end

	local var_6_10 = arg_6_0._selected_option_tab_index
	local var_6_11 = arg_6_0._leaderboard_tab_data[var_6_10].value

	arg_6_0._filter_value = var_6_1
	arg_6_0._current_season_id = var_6_2 or arg_6_0._current_season_id
	arg_6_0._stat_name = arg_6_0._season_stat_data[arg_6_0._current_season_id][var_6_0]
	arg_6_0._leaderboard_type = var_6_11

	local var_6_12 = arg_6_0:_get_cashed_list_data(var_6_1, var_6_11, arg_6_0._stat_name, arg_6_0._current_season_id)
	local var_6_13 = var_6_12 == nil
	local var_6_14 = arg_6_0._widgets_by_name

	var_6_14.loading_icon.content.visible = var_6_13
	var_6_14.refresh_button.content.button_hotspot.disable_button = var_6_13

	if not var_6_13 then
		local var_6_15 = var_6_12[1]
		local var_6_16 = var_6_12[2]
		local var_6_17 = false

		if var_6_1 == "personal" then
			var_6_17 = not arg_6_0:_list_including_local_player(var_6_15)
		end

		if var_6_17 then
			arg_6_0:_populate_list(nil, var_6_17)
		else
			arg_6_0:_populate_list(var_6_15, var_6_17)
		end

		arg_6_0:_set_refresh_time(var_6_16)
	else
		arg_6_0:_set_refresh_time(nil)
	end

	arg_6_0._waiting_for_list = var_6_13
end

function StartGameStateWeaveLeaderboard._list_including_local_player(arg_7_0, arg_7_1)
	if arg_7_1 then
		for iter_7_0 = 1, #arg_7_1 do
			if arg_7_1[iter_7_0].local_player then
				return true
			end
		end
	end

	return false
end

function StartGameStateWeaveLeaderboard._get_cashed_list_data(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_0._cashed_list_season_data[arg_8_4]

	if not var_8_0 or not var_8_0[arg_8_1] or not var_8_0[arg_8_1][arg_8_2] then
		return nil
	end

	return var_8_0[arg_8_1][arg_8_2][arg_8_3]
end

function StartGameStateWeaveLeaderboard._cb_cashe_list_data(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	if arg_9_6 then
		arg_9_0:_add_poll_queue(arg_9_1, arg_9_2, arg_9_3)

		return
	end

	local var_9_0 = arg_9_0._cashed_list_season_data

	if not var_9_0[arg_9_4] then
		var_9_0[arg_9_4] = {}
	end

	local var_9_1 = var_9_0[arg_9_4]

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

	if arg_9_2 == "global" and arg_9_1 == "personal" then
		local var_9_2

		for iter_9_0 = 1, #arg_9_5 do
			local var_9_3 = arg_9_5[iter_9_0]

			if var_9_3.local_player then
				local var_9_4 = table.clone(var_9_3)

				break
			end
		end
	end

	if arg_9_0._waiting_for_list then
		local var_9_5 = arg_9_0._stat_name == arg_9_3
		local var_9_6 = arg_9_0._leaderboard_type == arg_9_2
		local var_9_7 = arg_9_0._filter_value == arg_9_1

		if var_9_5 and var_9_6 and var_9_7 then
			arg_9_0:_update_leaderboard_presentation()
		end
	end
end

function StartGameStateWeaveLeaderboard._poll_list(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Managers.backend:get_interface("weaves")

	if arg_10_0._polling_callback then
		if var_10_0:is_requesting_leaderboard() then
			return
		elseif arg_10_2 < arg_10_0._min_poll_time then
			return
		end
	else
		return
	end

	local var_10_1 = var_10_0:has_leaderboard_request_failed()
	local var_10_2 = var_10_0:get_leaderboard_entries()
	local var_10_3 = arg_10_0:_create_list_entries(var_10_2)

	if arg_10_0._polling_callback then
		arg_10_0._polling_callback(var_10_3, var_10_1)

		arg_10_0._polling_callback = nil
	end

	arg_10_0:_handle_next_poll_request(arg_10_2)
end

function StartGameStateWeaveLeaderboard._set_refresh_time(arg_11_0, arg_11_1)
	arg_11_0._refreshed_at_time = arg_11_1

	arg_11_0:_update_refresh_time(arg_11_1)
end

function StartGameStateWeaveLeaderboard._update_refresh_time(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._refreshed_at_time
	local var_12_1 = arg_12_0._widgets_by_name.refresh_text.content

	var_12_1.visible = var_12_0 ~= nil

	if var_12_0 then
		local var_12_2 = arg_12_1 - var_12_0
		local var_12_3 = math.max(var_12_2, 0)
		local var_12_4 = math.max(var_12_3, 0)
		local var_12_5 = math.floor(var_12_4 / 60)
		local var_12_6 = math.floor(var_12_5 / 60)
		local var_12_7 = math.floor(var_12_6 / 24)
		local var_12_8

		if var_12_5 > 0 then
			var_12_8 = string.format(var_0_15[1], var_12_5)
		else
			var_12_8 = var_0_15[2]
		end

		var_12_1.text = var_12_8
	end
end

function StartGameStateWeaveLeaderboard._initialize_stepper(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	arg_13_0._stepper_settings = arg_13_0._stepper_settings or {}

	local var_13_0 = arg_13_0._stepper_settings
	local var_13_1 = "setting_stepper_" .. arg_13_1
	local var_13_2 = arg_13_0._widgets_by_name[var_13_1]

	arg_13_4 = arg_13_4 or 1
	var_13_0[arg_13_1] = {
		stepper_name = var_13_1,
		title_text = arg_13_2,
		content = arg_13_3,
		read_index = arg_13_4,
		widget = var_13_2
	}
	var_13_2.content.title_text = arg_13_2

	arg_13_0:_set_stepper_read_index(arg_13_1, arg_13_4)
end

function StartGameStateWeaveLeaderboard._set_stepper_read_index(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._stepper_settings[arg_14_1]
	local var_14_1 = var_14_0.content

	var_14_0.read_index = arg_14_2

	local var_14_2 = var_14_1[arg_14_2]

	var_14_0.widget.content.setting_text = var_14_2.text
end

function StartGameStateWeaveLeaderboard._on_stepper_pressed(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.content
	local var_15_1 = var_15_0.button_hotspot_left
	local var_15_2 = var_15_0.button_hotspot_right

	if var_15_1.on_pressed or var_15_1.on_double_click then
		return -1
	elseif var_15_2.on_pressed or var_15_2.on_double_click then
		return 1
	end
end

function StartGameStateWeaveLeaderboard._create_ui_elements(arg_16_0, arg_16_1)
	arg_16_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_16_0._console_cursor_widget = UIWidget.init(var_0_4)

	local var_16_0 = {}
	local var_16_1 = {}

	for iter_16_0, iter_16_1 in pairs(var_0_1) do
		if iter_16_1 then
			local var_16_2 = UIWidget.init(iter_16_1)

			var_16_0[#var_16_0 + 1] = var_16_2
			var_16_1[iter_16_0] = var_16_2
		end
	end

	arg_16_0._widgets = var_16_0
	arg_16_0._widgets_by_name = var_16_1
	var_16_1.loading_icon.content.visible = false

	arg_16_0:_setup_list_widget()
	UIRenderer.clear_scenegraph_queue(arg_16_0._ui_renderer)

	arg_16_0.ui_animator = UIAnimator:new(arg_16_0._ui_scenegraph, var_0_3)

	local var_16_3 = arg_16_0._widgets_by_name.list_scrollbar

	arg_16_0._scrollbar_logic = ScrollBarLogic:new(var_16_3)

	local var_16_4 = UILayer.default + 30
	local var_16_5 = arg_16_0:input_service()
	local var_16_6 = arg_16_0._gamepad_style_active

	arg_16_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_16_0._ui_top_renderer, var_16_5, 6, var_16_4, var_0_5.default, var_16_6)

	arg_16_0._menu_input_description:set_input_description(nil)

	arg_16_0._widgets_by_name.no_placement_text.content.visible = false
end

function StartGameStateWeaveLeaderboard._setup_tab_widget(arg_17_0, arg_17_1)
	local var_17_0 = #arg_17_1
	local var_17_1 = arg_17_0._widgets
	local var_17_2 = arg_17_0._widgets_by_name
	local var_17_3 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_vertical", {
		5,
		35
	}, "option_tabs_segments", var_17_0 - 1))
	local var_17_4 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_top", {
		17,
		9
	}, "option_tabs_segments_top", var_17_0 - 1))
	local var_17_5 = UIWidget.init(UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_bottom", {
		17,
		9
	}, "option_tabs_segments_bottom", var_17_0 - 1))

	var_17_2.option_tabs_segments = var_17_3
	var_17_2.option_tabs_segments_top = var_17_4
	var_17_2.option_tabs_segments_bottom = var_17_5
	var_17_1[#var_17_1 + 1] = var_17_3
	var_17_1[#var_17_1 + 1] = var_17_4
	var_17_1[#var_17_1 + 1] = var_17_5

	local var_17_6 = "option_tabs"
	local var_17_7 = var_0_2.option_tabs.size
	local var_17_8 = UIWidgets.create_default_text_tabs(var_17_6, var_17_7, var_17_0)
	local var_17_9 = UIWidget.init(var_17_8)

	var_17_2[var_17_6] = var_17_9
	var_17_1[#var_17_1 + 1] = var_17_9

	local var_17_10 = var_17_9.content

	for iter_17_0, iter_17_1 in ipairs(arg_17_1) do
		local var_17_11 = "_" .. tostring(iter_17_0)
		local var_17_12 = "hotspot" .. var_17_11
		local var_17_13 = "text" .. var_17_11
		local var_17_14 = var_17_10[var_17_12]
		local var_17_15

		var_17_14[var_17_13], var_17_15 = iter_17_1.text, iter_17_1.value
		var_17_14.index = iter_17_0
		var_17_14.value = var_17_15
	end
end

function StartGameStateWeaveLeaderboard.disable_player_world(arg_18_0)
	if not arg_18_0._player_world_disabled then
		arg_18_0._player_world_disabled = true

		local var_18_0 = "player_1"
		local var_18_1 = Managers.world:world("level_world")
		local var_18_2 = ScriptWorld.viewport(var_18_1, var_18_0)

		ScriptWorld.deactivate_viewport(var_18_1, var_18_2)
	end
end

function StartGameStateWeaveLeaderboard.enable_player_world(arg_19_0)
	if arg_19_0._player_world_disabled then
		arg_19_0._player_world_disabled = false

		local var_19_0 = "player_1"
		local var_19_1 = Managers.world:world("level_world")
		local var_19_2 = ScriptWorld.viewport(var_19_1, var_19_0)

		ScriptWorld.activate_viewport(var_19_1, var_19_2)
	end
end

function StartGameStateWeaveLeaderboard.close_on_exit(arg_20_0)
	return arg_20_0._close_on_exit
end

function StartGameStateWeaveLeaderboard.transitioning(arg_21_0)
	if arg_21_0.exiting then
		return true
	else
		return false
	end
end

function StartGameStateWeaveLeaderboard._wanted_state(arg_22_0)
	return (arg_22_0.parent:wanted_state())
end

function StartGameStateWeaveLeaderboard.wanted_menu_state(arg_23_0)
	return arg_23_0._wanted_menu_state
end

function StartGameStateWeaveLeaderboard.clear_wanted_menu_state(arg_24_0)
	arg_24_0._wanted_menu_state = nil
end

function StartGameStateWeaveLeaderboard.hotkey_allowed(arg_25_0)
	return true
end

function StartGameStateWeaveLeaderboard.on_exit(arg_26_0, arg_26_1)
	print("[StartGameState] Exit Substate StartGameStateWeaveLeaderboard")

	arg_26_0.ui_animator = nil
	arg_26_0._is_open = false

	if arg_26_0._fullscreen_effect_enabled then
		arg_26_0:set_fullscreen_effect_enable_state(false)
	end

	if arg_26_0._gamepad_style_active then
		arg_26_0:enable_player_world()
	end

	Managers.input:disable_gamepad_cursor()
	arg_26_0:play_sound("menu_leaderboard_close")

	arg_26_0._polling_callback = nil
end

function StartGameStateWeaveLeaderboard._update_transition_timer(arg_27_0, arg_27_1)
	if not arg_27_0._transition_timer then
		return
	end

	if arg_27_0._transition_timer == 0 then
		arg_27_0._transition_timer = nil
	else
		arg_27_0._transition_timer = math.max(arg_27_0._transition_timer - arg_27_1, 0)
	end
end

function StartGameStateWeaveLeaderboard.input_service(arg_28_0)
	return arg_28_0.parent:input_service()
end

function StartGameStateWeaveLeaderboard.update(arg_29_0, arg_29_1, arg_29_2)
	if var_0_6 then
		var_0_6 = false

		arg_29_0:_create_ui_elements()
	end

	local var_29_0 = arg_29_0._input_manager
	local var_29_1 = arg_29_0.parent:input_service()

	arg_29_0:_poll_list(arg_29_1, arg_29_2)
	arg_29_0:_update_transition_timer(arg_29_1)
	arg_29_0:_update_scroll_position(arg_29_1)
	arg_29_0:_update_visible_list_entries()
	arg_29_0._scrollbar_logic:update(arg_29_1, arg_29_2)
	arg_29_0:_update_refresh_time(arg_29_2)
	arg_29_0:draw(var_29_1, arg_29_1)

	local var_29_2 = arg_29_0:_wanted_state()

	if not arg_29_0._transition_timer and (var_29_2 or arg_29_0._new_state) then
		arg_29_0.parent:clear_wanted_state()

		return var_29_2 or arg_29_0._new_state
	end
end

function StartGameStateWeaveLeaderboard.post_update(arg_30_0, arg_30_1, arg_30_2)
	arg_30_0.ui_animator:update(arg_30_1)
	arg_30_0:_update_animations(arg_30_1)

	if not arg_30_0.parent:transitioning() and not arg_30_0._transition_timer then
		arg_30_0:_handle_input(arg_30_1, arg_30_2)
	end
end

function StartGameStateWeaveLeaderboard._update_animations(arg_31_0, arg_31_1)
	for iter_31_0, iter_31_1 in pairs(arg_31_0._ui_animations) do
		UIAnimation.update(iter_31_1, arg_31_1)

		if UIAnimation.completed(iter_31_1) then
			arg_31_0._ui_animations[iter_31_0] = nil
		end
	end

	local var_31_0 = arg_31_0._animations
	local var_31_1 = arg_31_0.ui_animator

	for iter_31_2, iter_31_3 in pairs(var_31_0) do
		if var_31_1:is_animation_completed(iter_31_3) then
			var_31_1:stop_animation(iter_31_3)

			var_31_0[iter_31_2] = nil
		end
	end

	local var_31_2 = arg_31_0._widgets_by_name
	local var_31_3 = var_31_2.exit_button
	local var_31_4 = var_31_2.refresh_button

	UIWidgetUtils.animate_default_button(var_31_3, arg_31_1)

	local var_31_5 = var_31_2.option_tabs

	UIWidgetUtils.animate_default_text_tabs(var_31_5, arg_31_1)
end

function StartGameStateWeaveLeaderboard._is_button_hover_enter(arg_32_0, arg_32_1)
	return arg_32_1.content.button_hotspot.on_hover_enter
end

function StartGameStateWeaveLeaderboard._is_inventory_tab_pressed(arg_33_0)
	local var_33_0 = arg_33_0._widgets_by_name.option_tabs.content
	local var_33_1 = var_33_0.amount

	for iter_33_0 = 1, var_33_1 do
		local var_33_2 = "_" .. tostring(iter_33_0)
		local var_33_3 = var_33_0["hotspot" .. var_33_2]

		if var_33_3.on_release and not var_33_3.is_selected then
			return iter_33_0
		end
	end
end

function StartGameStateWeaveLeaderboard._select_tab_by_index(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._widgets_by_name.option_tabs.content
	local var_34_1 = var_34_0.amount

	for iter_34_0 = 1, var_34_1 do
		local var_34_2 = "_" .. tostring(iter_34_0)

		var_34_0["hotspot" .. var_34_2].is_selected = arg_34_1 == iter_34_0
	end

	arg_34_0._selected_option_tab_index = arg_34_1
end

function StartGameStateWeaveLeaderboard._handle_input(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0._widgets_by_name
	local var_35_1 = arg_35_0.parent:input_service()
	local var_35_2 = var_35_1:get("toggle_menu", true)
	local var_35_3 = Managers.input:is_device_active("gamepad") and var_35_1:get("back_menu", true)
	local var_35_4 = arg_35_0._close_on_exit
	local var_35_5 = var_35_0.exit_button
	local var_35_6 = var_35_0.refresh_button

	if arg_35_0:_is_button_hover_enter(var_35_5) or arg_35_0:_is_button_hover_enter(var_35_6) then
		arg_35_0:play_sound("Play_hud_hover")
	end

	local var_35_7 = arg_35_0:_is_inventory_tab_pressed()
	local var_35_8 = false

	if var_35_7 and var_35_7 ~= arg_35_0._selected_option_tab_index then
		arg_35_0:_select_tab_by_index(var_35_7)
		arg_35_0:play_sound("Play_hud_hover")

		var_35_8 = true
	end

	local var_35_9 = arg_35_0._stepper_settings

	if var_35_9 then
		for iter_35_0 = 1, #var_35_9 do
			local var_35_10 = var_35_9[iter_35_0]
			local var_35_11 = var_35_10.widget
			local var_35_12 = arg_35_0:_on_stepper_pressed(var_35_11)

			if var_35_12 then
				local var_35_13 = var_35_10.read_index
				local var_35_14 = var_35_10.content
				local var_35_15 = math.index_wrapper(var_35_13 + var_35_12, #var_35_14)

				arg_35_0:_set_stepper_read_index(iter_35_0, var_35_15)
				arg_35_0:play_sound("Play_hud_hover")

				var_35_8 = true
			end
		end
	end

	if arg_35_0:_is_button_pressed(var_35_6) or var_35_1:get("special_1") then
		arg_35_0:play_sound("Play_hud_select")
		arg_35_0:_restart_poll_queue(arg_35_2)

		var_35_8 = true
	elseif var_35_4 and (var_35_3 or var_35_2 or arg_35_0:_is_button_pressed(var_35_5)) then
		arg_35_0:close_menu()

		return
	end

	if var_35_8 then
		arg_35_0:_update_leaderboard_presentation()
	end
end

function StartGameStateWeaveLeaderboard.close_menu(arg_36_0, arg_36_1)
	arg_36_0.parent:close_menu(nil, arg_36_1)
end

function StartGameStateWeaveLeaderboard.set_input_description(arg_37_0, arg_37_1)
	if not arg_37_0._menu_input_description then
		return
	end

	fassert(not arg_37_1 or arg_37_0._generic_input_actions[arg_37_1], "[StartGameStateWeaveLeaderboard:set_input_description] There is no such input_description (%s)", arg_37_1)
	arg_37_0._menu_input_description:set_input_description(arg_37_0._generic_input_actions[arg_37_1])
end

function StartGameStateWeaveLeaderboard.change_generic_actions(arg_38_0, arg_38_1)
	if not arg_38_0._menu_input_description then
		return
	end

	fassert(arg_38_0._generic_input_actions[arg_38_1], "[StartGameStateWeaveLeaderboard:set_input_description] There is no such input_description (%s)", arg_38_1)
	arg_38_0._menu_input_description:change_generic_actions(arg_38_0._generic_input_actions[arg_38_1])
end

function StartGameStateWeaveLeaderboard.draw(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0._ui_renderer
	local var_39_1 = arg_39_0._ui_top_renderer
	local var_39_2 = arg_39_0._ui_scenegraph
	local var_39_3 = arg_39_0._input_manager
	local var_39_4 = arg_39_0._render_settings
	local var_39_5 = var_39_3:is_device_active("gamepad")
	local var_39_6

	if not arg_39_0._gamepad_style_active then
		UIRenderer.begin_pass(var_39_0, var_39_2, arg_39_1, arg_39_2, nil, var_39_4)

		local var_39_7 = var_39_4.snap_pixel_positions
		local var_39_8 = var_39_4.alpha_multiplier

		for iter_39_0, iter_39_1 in ipairs(arg_39_0._widgets) do
			if iter_39_1.snap_pixel_positions ~= nil then
				var_39_4.snap_pixel_positions = iter_39_1.snap_pixel_positions
			end

			var_39_4.alpha_multiplier = iter_39_1.alpha_multiplier or var_39_8

			UIRenderer.draw_widget(var_39_0, iter_39_1)

			var_39_4.snap_pixel_positions = var_39_7
		end

		var_39_4.alpha_multiplier = var_39_8

		local var_39_9 = arg_39_0._list_entries

		if var_39_9 then
			local var_39_10 = arg_39_0._list_widget
			local var_39_11 = arg_39_0._list_draw_index
			local var_39_12 = arg_39_0._list_fade_in_time
			local var_39_13

			if var_39_12 then
				local var_39_14 = math.max(var_39_12 - arg_39_2, 0)

				if var_39_14 == 0 then
					arg_39_0._list_fade_in_time = nil
				else
					arg_39_0._list_fade_in_time = var_39_14
				end

				var_39_13 = 1 - var_39_14 / var_0_11
			end

			if var_39_9 and var_39_10 and var_39_11 then
				local var_39_15 = var_39_11
				local var_39_16 = math.min(var_39_11 + var_0_10 + 1, #var_39_9)
				local var_39_17 = 0

				for iter_39_2 = var_39_15, var_39_16 do
					var_39_17 = var_39_17 + 1

					local var_39_18 = var_39_10.content
					local var_39_19 = var_39_10.style
					local var_39_20 = var_39_10.offset
					local var_39_21 = var_39_18.size[2]

					var_39_20[2] = -(var_0_7 + (var_39_21 + var_0_8) * (iter_39_2 - 1))

					local var_39_22 = var_39_9[iter_39_2]
					local var_39_23 = var_39_22.name
					local var_39_24 = var_39_22.weave
					local var_39_25 = var_39_22.score
					local var_39_26 = var_39_22.ranking
					local var_39_27 = var_39_22.career_icon
					local var_39_28 = var_39_22.real_ranking
					local var_39_29 = var_39_22.local_player
					local var_39_30 = var_39_22.platform_user_id

					var_39_18.name = var_39_23
					var_39_18.score = var_39_25
					var_39_18.weave = var_39_24
					var_39_18.ranking = var_39_26
					var_39_18.real_ranking = var_39_28
					var_39_18.career_icon = var_39_27
					var_39_18.local_player = var_39_29

					if var_39_10.snap_pixel_positions ~= nil then
						var_39_4.snap_pixel_positions = var_39_10.snap_pixel_positions
					end

					if var_39_13 then
						local var_39_31 = math.easeInCubic(math.min(var_39_13 + (var_39_16 - iter_39_2) * 0.05, 1))

						var_39_4.alpha_multiplier = var_39_31
						var_39_20[1] = -30 * (1 - var_39_31)
					end

					UIRenderer.draw_widget(var_39_0, var_39_10)

					var_39_4.snap_pixel_positions = var_39_7
					var_39_4.alpha_multiplier = var_39_8

					if not IS_WINDOWS and var_39_18.button_hotspot.is_hover then
						var_39_6 = var_0_5.open_profile

						if arg_39_1:get("refresh_press") then
							arg_39_0:_open_profile(var_39_30)
						end
					end
				end
			end
		end

		UIRenderer.end_pass(var_39_0)
	end

	if var_39_5 then
		UIRenderer.begin_pass(var_39_1, var_39_2, arg_39_1, arg_39_2)
		UIRenderer.draw_widget(var_39_1, arg_39_0._console_cursor_widget)
		UIRenderer.end_pass(var_39_1)

		if arg_39_0._menu_input_description and not arg_39_0.parent:active_view() then
			arg_39_0._menu_input_description:set_input_description(var_39_6)
			arg_39_0._menu_input_description:draw(var_39_1, arg_39_2)
		end
	end
end

function StartGameStateWeaveLeaderboard._open_profile(arg_40_0, arg_40_1)
	if not arg_40_1 then
		return
	end

	if IS_XB1 then
		XboxLive.show_gamercard(Managers.account:user_id(), arg_40_1)
	elseif IS_PS4 then
		Managers.account:show_player_profile_with_account_id(arg_40_1)
	end
end

function StartGameStateWeaveLeaderboard._is_button_pressed(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_1.content
	local var_41_1 = var_41_0.button_hotspot or var_41_0.hotspot

	if var_41_1.on_release then
		var_41_1.on_release = false

		return true
	end
end

function StartGameStateWeaveLeaderboard.play_sound(arg_42_0, arg_42_1)
	arg_42_0.parent:play_sound(arg_42_1)
end

function StartGameStateWeaveLeaderboard._start_transition_animation(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = {
		wwise_world = arg_43_0._wwise_world,
		render_settings = arg_43_0._render_settings
	}
	local var_43_1 = {}
	local var_43_2 = arg_43_0.ui_animator:start_animation(arg_43_2, var_43_1, var_0_2, var_43_0)

	arg_43_0._animations[arg_43_1] = var_43_2
end

function StartGameStateWeaveLeaderboard.set_fullscreen_effect_enable_state(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._ui_renderer.world
	local var_44_1 = World.get_data(var_44_0, "shading_environment")

	if var_44_1 then
		ShadingEnvironment.set_scalar(var_44_1, "fullscreen_blur_enabled", arg_44_1 and 1 or 0)
		ShadingEnvironment.set_scalar(var_44_1, "fullscreen_blur_amount", arg_44_1 and 0.75 or 0)
		ShadingEnvironment.apply(var_44_1)
	end

	arg_44_0._fullscreen_effect_enabled = arg_44_1
end

function StartGameStateWeaveLeaderboard._setup_list_widget(arg_45_0)
	local var_45_0 = true
	local var_45_1 = "list_entry"
	local var_45_2 = var_0_2[var_45_1].size
	local var_45_3 = UIWidgets.create_leaderboard_entry_definition(var_45_1, var_45_2, var_45_0)

	arg_45_0._list_widget = UIWidget.init(var_45_3)
end

function StartGameStateWeaveLeaderboard._create_list_entries(arg_46_0, arg_46_1)
	local var_46_0 = {}
	local var_46_1 = #arg_46_1

	for iter_46_0 = 1, var_46_1 do
		local var_46_2 = arg_46_1[iter_46_0]
		local var_46_3 = var_46_2.career_name
		local var_46_4 = CareerSettings[var_46_3]
		local var_46_5 = var_46_4 and var_46_4.portrait_thumbnail or "icons_placeholder"

		var_46_0[iter_46_0] = {
			alpha_fade_in_delay = 0.4,
			name = var_46_2.name or "UNKNOWN",
			weave = tostring(var_46_2.weave),
			score = UIUtils.comma_value(var_46_2.score),
			ranking = UIUtils.comma_value(var_46_2.ranking),
			career_name = var_46_3,
			career_icon = var_46_5,
			local_player = var_46_2.local_player,
			real_ranking = var_46_2.real_ranking,
			platform_user_id = var_46_2.platform_user_id
		}
	end

	return var_46_0
end

function StartGameStateWeaveLeaderboard._populate_list(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_1 and #arg_47_1 or 0

	arg_47_0._list_entries = arg_47_1

	arg_47_0:_calculate_list_height(var_47_0)
	arg_47_0:_initialize_scrollbar()

	arg_47_0._list_draw_index = 1
	arg_47_0._list_fade_in_time = var_0_11
	arg_47_0._widgets_by_name.no_placement_text.content.visible = arg_47_2
end

function StartGameStateWeaveLeaderboard._calculate_list_height(arg_48_0, arg_48_1)
	local var_48_0 = var_0_7
	local var_48_1 = arg_48_0._list_widget.content.size

	for iter_48_0 = 1, arg_48_1 do
		var_48_0 = var_48_0 + var_48_1[2]

		if iter_48_0 ~= arg_48_1 then
			var_48_0 = var_48_0 + var_0_8
		end
	end

	arg_48_0._total_list_height = var_48_0 + var_0_7
end

function StartGameStateWeaveLeaderboard._initialize_scrollbar(arg_49_0)
	local var_49_0 = var_0_2.list_mask.size
	local var_49_1 = var_0_2.list_scrollbar.size
	local var_49_2 = var_49_0[2]
	local var_49_3 = arg_49_0._total_list_height
	local var_49_4 = var_49_1[2]
	local var_49_5 = 220 + var_0_8 * 1.5
	local var_49_6 = 1
	local var_49_7 = arg_49_0._scrollbar_logic

	var_49_7:set_scrollbar_values(var_49_2, var_49_3, var_49_4, var_49_5, var_49_6)
	var_49_7:set_scroll_percentage(0)

	arg_49_0._widgets_by_name.list_scrollbar.content.visible = var_49_2 < var_49_3
end

function StartGameStateWeaveLeaderboard._update_scroll_position(arg_50_0)
	local var_50_0 = arg_50_0._scrollbar_logic:get_scrolled_length()

	if var_50_0 ~= arg_50_0._scrolled_length then
		arg_50_0._ui_scenegraph.list_scroll_root.local_position[2] = math.round(var_50_0)
		arg_50_0._scrolled_length = var_50_0
	end
end

function StartGameStateWeaveLeaderboard._update_visible_list_entries(arg_51_0)
	local var_51_0 = arg_51_0._scrollbar_logic

	if not var_51_0:enabled() then
		return
	end

	local var_51_1 = var_51_0:get_scroll_percentage()
	local var_51_2 = var_51_0:get_scrolled_length()
	local var_51_3 = var_51_0:get_scroll_length()
	local var_51_4 = var_0_2.list_window.size
	local var_51_5 = var_0_8 * 2
	local var_51_6 = var_51_4[2] + var_51_5
	local var_51_7 = arg_51_0._list_entries
	local var_51_8 = arg_51_0._list_widget.content.size[2]
	local var_51_9 = 1
	local var_51_10 = #var_51_7

	for iter_51_0 = 1, var_51_10 do
		local var_51_11 = var_0_7 + (var_51_8 + var_0_8) * (iter_51_0 - 1)
		local var_51_12 = var_51_11 + var_51_8
		local var_51_13 = false

		if var_51_12 < var_51_2 - var_51_5 then
			var_51_13 = true
		elseif var_51_6 < var_51_11 - var_51_2 then
			var_51_13 = true
		end

		if not var_51_13 then
			var_51_9 = iter_51_0

			break
		end
	end

	arg_51_0._list_draw_index = var_51_9
end

function StartGameStateWeaveLeaderboard._get_scrollbar_percentage_by_index(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0._scrollbar_logic

	if var_52_0:enabled() then
		local var_52_1 = var_52_0:get_scroll_percentage()
		local var_52_2 = var_52_0:get_scrolled_length()
		local var_52_3 = var_52_0:get_scroll_length()
		local var_52_4 = var_0_2.list_window.size[2]
		local var_52_5 = var_52_2
		local var_52_6 = var_52_5 + var_52_4

		if arg_52_0._list_entries then
			local var_52_7 = arg_52_0._list_widget.content.size[2]
			local var_52_8 = var_0_7 * 2 + (var_52_7 + var_0_8) * (arg_52_1 - 1)
			local var_52_9 = var_52_8
			local var_52_10 = var_52_8 + var_52_7
			local var_52_11 = 0

			if var_52_6 < var_52_10 then
				local var_52_12 = var_52_10 - var_52_6

				var_52_11 = math.clamp(var_52_12 / var_52_3, 0, 1)
			elseif var_52_9 < var_52_5 then
				local var_52_13 = var_52_5 - var_52_9

				var_52_11 = -math.clamp(var_52_13 / var_52_3, 0, 1)
			end

			if var_52_11 then
				return (math.clamp(var_52_1 + var_52_11, 0, 1))
			end
		end
	end

	return 0
end

function StartGameStateWeaveLeaderboard._animate_element_by_time(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5, math.ease_out_quad))
end

function StartGameStateWeaveLeaderboard._animate_element_by_catmullrom(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8))
end
