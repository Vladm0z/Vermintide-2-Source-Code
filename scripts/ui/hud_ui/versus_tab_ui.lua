-- chunkname: @scripts/ui/hud_ui/versus_tab_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/versus_tab_ui_definitions")
local var_0_1 = var_0_0.animation_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.create_empty_frame_widget
local var_0_4 = var_0_0.console_cursor_definition
local var_0_5 = var_0_0.custom_game_settings_widgets
local var_0_6 = 2
local var_0_7 = 4
local var_0_8 = false
local var_0_9 = {}
local var_0_10 = {
	"slot_melee",
	"slot_ranged"
}

VersusTabUI = class(VersusTabUI)

function VersusTabUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_2.ui_top_renderer
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._voip = arg_1_2.voip

	local var_1_0 = arg_1_2.player

	arg_1_0._player = var_1_0
	arg_1_0._peer_id = var_1_0:network_id()
	arg_1_0._local_player_id = var_1_0:local_player_id()
	arg_1_0._context = arg_1_2

	local var_1_1 = arg_1_2.world_manager:world("level_world")

	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_1)

	local var_1_2 = arg_1_0._input_manager

	var_1_2:create_input_service("player_list_input", "IngamePlayerListKeymaps", "IngamePlayerListFilters")
	var_1_2:map_device_to_service("player_list_input", "keyboard")
	var_1_2:map_device_to_service("player_list_input", "mouse")
	var_1_2:map_device_to_service("player_list_input", "gamepad")

	arg_1_0._animations = {}
	arg_1_0._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_1_0._selected_objective_index = 0
	arg_1_0._selected_sub_objective_index = 0

	arg_1_0:_create_ui_elements()

	arg_1_0._objective_system = Managers.state.entity:system("objective_system")
	arg_1_0._objectives_initialized = false
	arg_1_0._win_conditions = Managers.mechanism:game_mechanism():win_conditions()

	local var_1_3 = Managers.level_transition_handler:get_current_level_keys()
	local var_1_4 = LevelSettings[var_1_3]
	local var_1_5 = Localize(var_1_4.display_name)

	arg_1_0:_set_level_name(var_1_5)
	arg_1_0:_register_events()

	local var_1_6 = Managers.state.game_mode:game_mode():game_mode_state() == "match_running_state" and true or nil

	if var_1_6 then
		arg_1_0:_on_round_started()
	end

	arg_1_0._round_has_started = var_1_6

	local var_1_7, var_1_8, var_1_9 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "round_time_limit")

	if var_1_9 and var_1_8 then
		arg_1_0._custom_round_timer_active = true
	end
end

function VersusTabUI._create_ui_elements(arg_2_0)
	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_top_renderer)

	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_2_0 = {}
	local var_2_1 = {}
	local var_2_2 = var_0_0.widget_definitions

	for iter_2_0, iter_2_1 in pairs(var_2_2) do
		local var_2_3 = UIWidget.init(iter_2_1)

		var_2_1[iter_2_0] = var_2_3
		var_2_0[#var_2_0 + 1] = var_2_3
	end

	arg_2_0._item_tooltip = UIWidget.init(var_0_0.item_tooltip)
	arg_2_0._console_cursor = UIWidget.init(var_0_4)
	arg_2_0._widgets_by_name = var_2_1
	arg_2_0._widgets = var_2_0
	var_0_8 = false

	arg_2_0:_create_player_slots()

	arg_2_0._custom_game_settings_widgets, arg_2_0._custom_game_settings_widgets_by_name = {}, {}

	UIUtils.create_widgets(var_0_5, arg_2_0._custom_game_settings_widgets, arg_2_0._custom_game_settings_widgets_by_name)

	local var_2_4 = Managers.mechanism:game_mechanism():custom_settings_enabled()

	if var_2_4 then
		arg_2_0:_setup_custom_settings()
	end

	arg_2_0._custom_settings_enabled = var_2_4
	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_1)
end

function VersusTabUI.destroy(arg_3_0)
	arg_3_0._ui_animator = nil

	arg_3_0:_unregister_events()
end

function VersusTabUI.update(arg_4_0, arg_4_1, arg_4_2)
	if var_0_8 then
		arg_4_0:_create_ui_elements()
	end

	arg_4_0:_handle_input(arg_4_1, arg_4_2)

	if arg_4_0._active then
		local var_4_0 = Managers.mechanism
		local var_4_1 = arg_4_0:_get_current_set()
		local var_4_2 = Managers.level_transition_handler:get_current_level_key()
		local var_4_3 = VersusObjectiveSettings[var_4_2].num_sets

		if var_4_1 ~= arg_4_0._round_id then
			arg_4_0._round_id = var_4_1

			local var_4_4 = Localize("versus_round_count")

			arg_4_0:_set_sub_title(string.format(var_4_4, var_4_1, var_4_3))
		end

		local var_4_5 = Managers.party
		local var_4_6, var_4_7 = var_4_5:get_party_from_player_id(arg_4_0._peer_id, arg_4_0._local_player_id)
		local var_4_8 = arg_4_0:_get_opponent_party_id()

		arg_4_0:_set_team_name(var_4_7, var_4_8)
		arg_4_0:_set_team_textures(var_4_7, var_4_8)
		arg_4_0:_set_side_text(var_4_5, var_4_7, var_4_8)

		if not arg_4_0._party_id then
			arg_4_0._party_id = var_4_7
			arg_4_0._opponent_party_id = var_4_8
		end

		arg_4_0:_update_round_start_timer(arg_4_1, arg_4_2)
		arg_4_0:_update_objectives(arg_4_1, arg_4_2)
		arg_4_0:_update_score(var_4_7, var_4_8)
		arg_4_0:_update_animations(arg_4_1, arg_4_2)
		arg_4_0:_update_custom_lobby_slots()
		arg_4_0:_draw(arg_4_1, arg_4_2)
	end
end

function VersusTabUI._update_animations(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._animations
	local var_5_1 = arg_5_0._ui_animator

	var_5_1:update(arg_5_1)

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if var_5_1:is_animation_completed(iter_5_1) then
			var_5_1:stop_animation(iter_5_1)

			var_5_0[iter_5_0] = nil
		end
	end
end

function VersusTabUI._draw(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._ui_top_renderer
	local var_6_1 = arg_6_0._ui_scenegraph
	local var_6_2 = arg_6_0._input_manager
	local var_6_3 = var_6_2:get_service("player_list_input")
	local var_6_4 = arg_6_0._render_settings
	local var_6_5 = var_6_2:is_device_active("gamepad")
	local var_6_6 = var_6_4.alpha_multiplier or 1

	UIRenderer.begin_pass(var_6_0, var_6_1, var_6_3, arg_6_1, nil, var_6_4)

	local var_6_7 = arg_6_0._widgets

	if var_6_7 then
		for iter_6_0 = 1, #var_6_7 do
			local var_6_8 = var_6_7[iter_6_0]

			var_6_4.alpha_multiplier = var_6_8.alpha_multiplier or var_6_6

			UIRenderer.draw_widget(var_6_0, var_6_8)
		end
	end

	var_6_4.alpha_multiplier = var_6_6

	local var_6_9 = arg_6_0._custom_game_slots

	if var_6_9 then
		for iter_6_1 = 1, #var_6_9 do
			local var_6_10 = var_6_9[iter_6_1]

			for iter_6_2 = 1, #var_6_10 do
				local var_6_11 = var_6_10[iter_6_2]
				local var_6_12 = var_6_11.empty
				local var_6_13 = var_6_11.is_player
				local var_6_14 = var_6_11.peer_id
				local var_6_15 = var_6_11.empty_widget

				if var_6_15 then
					UIRenderer.draw_widget(var_6_0, var_6_15)
				end

				if not var_6_12 then
					local var_6_16 = var_6_11.panel_widget

					if var_6_16 then
						UIRenderer.draw_widget(var_6_0, var_6_16)
					end

					local var_6_17 = var_6_11.portrait_widget

					if var_6_17 then
						UIRenderer.draw_widget(var_6_0, var_6_17)
					end

					local var_6_18 = var_6_11.insignia_widget

					if var_6_18 then
						UIRenderer.draw_widget(var_6_0, var_6_18)
					end
				end
			end
		end
	end

	arg_6_0._widgets_by_name.objective_text.content.visible = arg_6_0._round_has_started and true or false

	UIRenderer.draw_widget(var_6_0, arg_6_0._item_tooltip)

	if var_6_5 then
		UIRenderer.draw_widget(var_6_0, arg_6_0._console_cursor)
	end

	if arg_6_0._custom_settings_enabled and arg_6_0._custom_game_settings_widgets then
		UIRenderer.draw_all_widgets(var_6_0, arg_6_0._custom_game_settings_widgets)
	end

	if arg_6_0._custom_settings_enabled and arg_6_0._settings_widgets then
		UIRenderer.draw_all_widgets(var_6_0, arg_6_0._settings_widgets)
	end

	UIRenderer.end_pass(var_6_0)

	if arg_6_0._scrollbar_ui then
		arg_6_0._scrollbar_ui:update(arg_6_1, arg_6_2, var_6_0, var_6_3, var_6_4)
	end
end

function VersusTabUI._set_team_name(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0, var_7_1 = arg_7_0:_get_teams_ui_settings(arg_7_1, arg_7_2)

	arg_7_0._widgets_by_name.team_1_name.content.text = Localize(var_7_0.display_name)
	arg_7_0._widgets_by_name.team_2_name.content.text = Localize(var_7_1.display_name)
end

function VersusTabUI._set_team_textures(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0, var_8_1 = arg_8_0:_get_teams_ui_settings(arg_8_1, arg_8_2)

	arg_8_0._widgets_by_name.team_1_icon.content.texture_id = var_8_0.local_flag_texture
	arg_8_0._widgets_by_name.team_2_icon.content.texture_id = var_8_1.opponent_flag_texture
end

function VersusTabUI._set_side_text(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = DLCSettings.carousel
	local var_9_1 = arg_9_1:get_party(arg_9_2)

	if var_9_1 then
		local var_9_2 = Managers.state.side.side_by_party[var_9_1]:name()
		local var_9_3 = arg_9_0._widgets_by_name.team_1_side_text
		local var_9_4 = var_9_0.sides_localization_lookup[var_9_2]

		var_9_3.content.text = Localize(var_9_4)
	end

	local var_9_5 = arg_9_1:get_party(arg_9_3)

	if var_9_5 then
		local var_9_6 = Managers.state.side.side_by_party[var_9_5]:name()
		local var_9_7 = arg_9_0._widgets_by_name.team_2_side_text
		local var_9_8 = var_9_0.sides_localization_lookup[var_9_6]

		var_9_7.content.text = Localize(var_9_8)
	end
end

function VersusTabUI._update_score(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._win_conditions:get_total_score(arg_10_1)
	local var_10_1 = arg_10_0._win_conditions:get_total_score(arg_10_2)
	local var_10_2 = Managers.party:get_party(arg_10_1)
	local var_10_3 = Managers.state.side.side_by_party[var_10_2]:name()
	local var_10_4 = arg_10_0._widgets_by_name.score.content

	var_10_4.is_hero = var_10_3 == "heroes"
	var_10_4.team_1_score = var_10_0
	var_10_4.team_2_score = var_10_1
end

function VersusTabUI._get_teams_ui_settings(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_11_1]
	local var_11_1 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_11_2]
	local var_11_2 = DLCSettings.carousel
	local var_11_3 = var_11_2.teams_ui_assets[var_11_0]
	local var_11_4 = var_11_2.teams_ui_assets[var_11_1]

	return var_11_3, var_11_4
end

function VersusTabUI._set_level_name(arg_12_0, arg_12_1)
	arg_12_0._widgets_by_name.level_name.content.text = arg_12_1
end

function VersusTabUI._set_sub_title(arg_13_0, arg_13_1)
	arg_13_0._widgets_by_name.sub_title.content.text = arg_13_1
end

function VersusTabUI.input_service(arg_14_0)
	return arg_14_0._input_manager:get_service("player_list_input")
end

function VersusTabUI.is_focused(arg_15_0)
	return arg_15_0._active and arg_15_0.cursor_active
end

function VersusTabUI.is_active(arg_16_0)
	return arg_16_0._active
end

function VersusTabUI.set_active(arg_17_0, arg_17_1)
	local var_17_0 = Managers.chat.chat_gui

	if arg_17_1 then
		local var_17_1 = {
			render_settings = arg_17_0._render_settings
		}

		arg_17_0._ui_animator:start_animation("on_enter", arg_17_0._widgets_by_name, var_0_2, var_17_1)
		Managers.input:enable_gamepad_cursor()
		arg_17_0:_create_player_slots()
	else
		var_17_0:hide_chat()
		Managers.input:disable_gamepad_cursor()
	end

	arg_17_0._active = arg_17_1

	if arg_17_1 then
		arg_17_0._fade_in_duration = 0
	end

	arg_17_0:_deactivate_cursor()
end

function VersusTabUI._deactivate_cursor(arg_18_0)
	if arg_18_0.cursor_active then
		ShowCursorStack.hide("VersusSlotStatusUI")

		local var_18_0 = arg_18_0._input_manager

		var_18_0:device_unblock_all_services("keyboard")
		var_18_0:device_unblock_all_services("mouse")
		var_18_0:device_unblock_all_services("gamepad")

		arg_18_0.cursor_active = false
		arg_18_0._widgets_by_name.input_description_text.content.visible = true
	end
end

function VersusTabUI._activate_cursor(arg_19_0)
	if not arg_19_0.cursor_active then
		ShowCursorStack.show("VersusSlotStatusUI")

		local var_19_0 = arg_19_0._input_manager

		var_19_0:block_device_except_service("player_list_input", "keyboard")
		var_19_0:block_device_except_service("player_list_input", "mouse")
		var_19_0:block_device_except_service("player_list_input", "gamepad")

		arg_19_0.cursor_active = true
		arg_19_0._widgets_by_name.input_description_text.content.visible = false
	end
end

function VersusTabUI._handle_input(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._input_manager
	local var_20_1 = Managers.transition:in_fade_active()
	local var_20_2 = var_20_0:get_service("player_list_input")

	if not var_20_1 and (var_20_2:get("ingame_player_list_exit") or var_20_2:get("ingame_player_list_toggle") or var_20_2:get("back")) and arg_20_0._active and arg_20_0.cursor_active then
		arg_20_0:set_active(false)
	elseif not arg_20_0.cursor_active then
		if not var_20_1 and var_20_2:get("ingame_player_list_toggle") then
			if not arg_20_0._active then
				arg_20_0:set_active(true)

				if not arg_20_0.cursor_active then
					arg_20_0:_activate_cursor()
				end
			end
		elseif var_20_2:get("ingame_player_list_pressed") then
			if not arg_20_0._active then
				arg_20_0:set_active(true)
			end
		elseif arg_20_0._active and not var_20_2:get("ingame_player_list_held") then
			arg_20_0:set_active(false)
		end
	end

	if arg_20_0._active and var_20_2:get("activate_ingame_player_list") then
		arg_20_0:_activate_cursor()
	end
end

function VersusTabUI._create_player_slots(arg_21_0)
	local var_21_0 = arg_21_0._ui_scenegraph
	local var_21_1 = 1
	local var_21_2 = {}

	for iter_21_0 = 1, var_0_6 do
		local var_21_3 = {}

		var_21_2[iter_21_0] = var_21_3

		for iter_21_1 = 1, var_0_7 do
			local var_21_4 = {}

			var_21_3[iter_21_1] = var_21_4

			local var_21_5 = "team_" .. iter_21_0 .. "_player_panel_" .. iter_21_1
			local var_21_6 = "talent_tooltip"

			if var_21_0[var_21_5] then
				local var_21_7 = var_21_0[var_21_5].size
				local var_21_8 = UIWidgets.create_player_panel(var_21_5, var_21_6, var_21_1, var_21_7)
				local var_21_9 = UIWidget.init(var_21_8)
				local var_21_10 = iter_21_0 == 1 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

				arg_21_0:_apply_color_values(var_21_9.style.background.color, var_21_10)

				local var_21_11 = var_0_3(var_21_5)

				var_21_4.empty_widget, var_21_4.panel_widget = UIWidget.init(var_21_11), var_21_9
				var_21_1 = var_21_1 + 1
			end
		end
	end

	arg_21_0._custom_game_slots = var_21_2
end

function VersusTabUI._setup_custom_settings(arg_22_0)
	local var_22_0 = Managers.mechanism:game_mechanism():get_custom_game_settings_handler()
	local var_22_1, var_22_2 = var_22_0 and var_22_0:get_settings_template(), var_22_0:get_settings()
	local var_22_3 = DLCSettings.carousel.custom_game_ui_settings
	local var_22_4 = {}
	local var_22_5 = {}
	local var_22_6 = 34

	for iter_22_0, iter_22_1 in ipairs(var_22_2) do
		local var_22_7 = var_22_1[iter_22_0]
		local var_22_8 = var_22_7.setting_name
		local var_22_9 = var_22_7.values
		local var_22_10 = var_22_3[var_22_8]
		local var_22_11 = var_22_7.values_reverse_lookup[iter_22_1]
		local var_22_12 = var_22_7.default
		local var_22_13 = var_22_7.values_reverse_lookup[var_22_12]
		local var_22_14 = var_0_0.create_settings_widget("settings_anchor", var_22_7, var_22_10, iter_22_1, var_22_11, iter_22_0)
		local var_22_15 = UIWidget.init(var_22_14)

		var_22_15.offset = {
			20,
			-var_22_6 * iter_22_0,
			1
		}
		var_22_15.content.default_value = var_22_12
		var_22_15.content.default_idx = var_22_13
		var_22_4[#var_22_4 + 1] = var_22_15
		var_22_5[var_22_8] = var_22_15
	end

	arg_22_0._settings_widgets = var_22_4
	arg_22_0._settings_widgets_by_name = var_22_5

	local var_22_16 = #var_22_2

	arg_22_0:_setup_custom_settings_scrollbar(var_22_16, var_22_6)

	arg_22_0._num_settings = var_22_16
	arg_22_0._settings = var_22_2
end

function VersusTabUI._update_custom_lobby_slots(arg_23_0)
	local var_23_0 = Managers.party
	local var_23_1 = Managers.player
	local var_23_2 = arg_23_0._pre_game_logic
	local var_23_3 = var_23_1:human_and_bot_players()
	local var_23_4 = arg_23_0._custom_game_slots

	if not var_23_4 then
		return
	end

	arg_23_0._item_tooltip.content.item = nil

	local var_23_5 = var_23_4[1]

	arg_23_0:_update_party_slots_data(arg_23_0._party_id, var_23_5, 1, var_23_0, var_23_1, var_23_2, var_23_3)

	local var_23_6 = var_23_4[2]
	local var_23_7 = arg_23_0:_get_opponent_party_id()

	arg_23_0:_update_party_slots_data(var_23_7, var_23_6, 2, var_23_0, var_23_1, var_23_2, var_23_3)
	arg_23_0:_update_players_panel_button_widgets()
	arg_23_0:_handle_players_panel_button_input()
end

function VersusTabUI._update_party_slots_data(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7)
	local var_24_0 = arg_24_4:get_party(arg_24_1)
	local var_24_1 = Managers.state.network:game()
	local var_24_2 = Managers.mechanism:network_handler():get_match_handler()

	if var_24_0 then
		local var_24_3 = Managers.state.side.side_by_party[var_24_0]
		local var_24_4 = var_24_3 and var_24_3:name() == "dark_pact"
		local var_24_5 = var_24_0.slots

		for iter_24_0 = 1, #arg_24_2 do
			local var_24_6 = arg_24_2[iter_24_0]
			local var_24_7 = var_24_5[iter_24_0]
			local var_24_8 = false
			local var_24_9 = false
			local var_24_10 = var_24_6.panel_widget
			local var_24_11 = var_24_10.content
			local var_24_12 = var_24_10.style
			local var_24_13 = var_24_6.empty_widget.content

			if var_24_6.unique_id ~= var_24_7.unique_id then
				var_24_6.unique_id = var_24_7.unique_id
				var_24_8 = true
			end

			local var_24_14 = var_24_7.peer_id
			local var_24_15 = var_24_7.local_player_id
			local var_24_16
			local var_24_17 = false
			local var_24_18 = false
			local var_24_19 = arg_24_0._party_id == var_24_7.party_id
			local var_24_20
			local var_24_21

			if var_24_14 and var_24_15 then
				var_24_20 = var_24_7.profile_index
				var_24_21 = var_24_7.career_index
				var_24_16 = var_24_7.player
				var_24_17 = var_24_7.is_player
				var_24_9 = true
			end

			if var_24_6.ready ~= var_24_18 then
				var_24_6.ready = var_24_18
				var_24_11.ready = var_24_18
			end

			local var_24_22 = false

			if var_24_6.profile_index ~= var_24_20 or var_24_6.career_index ~= var_24_21 or var_24_8 then
				var_24_6.profile_index = var_24_20
				var_24_6.career_index = var_24_21
				var_24_22 = true
			end

			local var_24_23
			local var_24_24
			local var_24_25
			local var_24_26
			local var_24_27 = false
			local var_24_28 = true
			local var_24_29 = var_24_16 and var_24_16:unique_id()
			local var_24_30 = var_24_16 and arg_24_7[var_24_29]

			if var_24_30 then
				if var_24_22 then
					local var_24_31 = var_24_16:is_player_controlled()
					local var_24_32 = CosmeticUtils.get_cosmetic_slot(var_24_16, "slot_frame")
					local var_24_33 = var_24_32 and var_24_32.item_name or "default"
					local var_24_34 = var_24_16 and (var_24_31 and var_24_2:query_peer_data(var_24_14, "versus_level", true) or UISettings.bots_level_display_text)
					local var_24_35 = arg_24_0:_get_hero_portrait(var_24_20, var_24_21)
					local var_24_36 = "team_" .. arg_24_3 .. "_player_frame_" .. iter_24_0

					var_24_6.portrait_widget = arg_24_0:_create_portrait_frame(var_24_36, var_24_33, var_24_34, var_24_35)

					if var_24_31 then
						local var_24_37 = "team_" .. arg_24_3 .. "_player_insignia_" .. iter_24_0
						local var_24_38 = ExperienceSettings.get_versus_player_level(var_24_16) or 0
						local var_24_39 = UIWidgets.create_small_insignia(var_24_37, var_24_38)

						var_24_6.insignia_widget = UIWidget.init(var_24_39)
					end
				end

				var_24_27 = var_24_16.local_player
				var_24_28 = not var_24_16:is_player_controlled()

				local var_24_40 = var_24_16:name()
				local var_24_41 = (not var_24_4 or var_24_19) and var_24_16:career_name() or "vs_lobby_dark_pact_team_name"

				var_24_11.show_host = var_24_14 == Managers.mechanism:network_handler().server_peer_id and not var_24_28

				if var_24_6.player_name ~= var_24_40 then
					var_24_6.player_name = var_24_40
					var_24_11.name = var_24_40
				end

				if var_24_41 and var_24_6.career_name ~= var_24_41 then
					var_24_6.career_name = var_24_41
					var_24_11.hero = var_24_41
				end

				local var_24_42 = var_24_16.player_unit

				if ALIVE[var_24_42] then
					if not var_24_4 then
						local var_24_43 = Managers.player:player_loadouts()[var_24_29]

						if var_24_43 then
							arg_24_0:_update_player_item_slots(var_24_43, var_24_10)
						end

						arg_24_0:_update_player_talents(var_24_42, var_24_16, var_24_10)
					end

					var_24_23, var_24_24, var_24_25, var_24_26 = arg_24_0:_update_player_health(var_24_42, var_24_10)
				else
					var_24_26 = true
				end

				arg_24_0:_update_player_status_portrait(var_24_6, var_24_20, var_24_21, var_24_4, var_24_19, var_24_23, var_24_24, var_24_25, var_24_26)

				if var_24_4 and var_24_11.respawning and var_24_19 then
					arg_24_0:_update_player_respawn_counter(var_24_6)
				end

				arg_24_0:_update_player_talents_tooltip(var_24_10)

				local var_24_44 = var_24_16.game_object_id
				local var_24_45 = var_24_44 and GameSession.game_object_field(var_24_1, var_24_44, "ping") or math.huge
				local var_24_46, var_24_47 = arg_24_0:_get_ping_texture_by_ping_value(var_24_45)

				var_24_11.ping_texture = var_24_46
				var_24_11.ping_text = var_24_45

				local var_24_48 = var_24_10.style.ping_text

				var_24_48.text_color = var_24_48[var_24_47]
			end

			var_24_11.empty = not var_24_9
			var_24_13.empty = not var_24_9
			var_24_11.visible = var_24_30
			var_24_11.is_local_player = not var_24_4 and var_24_16 ~= nil
			var_24_11.is_dark_pact = var_24_4
			var_24_11.is_build_visible = true
			var_24_11.is_in_local_player_party = var_24_19
			var_24_11.is_wounded = var_24_23
			var_24_11.is_knocked_down = var_24_24
			var_24_11.needs_help = var_24_25
			var_24_11.is_dead = var_24_26
			var_24_6.empty = not var_24_9
			var_24_6.is_player = var_24_17
			var_24_6.peer_id = var_24_14
			var_24_6.is_dark_pact = var_24_4
			var_24_6.is_local_player = var_24_27
			var_24_6.is_bot = var_24_28
		end
	end
end

function VersusTabUI._set_player_custom_panel_loadout_icon(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_1.content
	local var_25_1 = arg_25_1.style

	if arg_25_2 then
		local var_25_2 = {
			data = ItemMasterList[arg_25_2]
		}
		local var_25_3, var_25_4, var_25_5 = UIUtils.get_ui_information_from_item(var_25_2)

		var_25_0[arg_25_3] = var_25_3
		var_25_0[arg_25_3 .. "_item_name"] = arg_25_2
	else
		var_25_0[arg_25_3 .. "_item_name"] = nil
	end
end

function VersusTabUI._button_pressed(arg_26_0, arg_26_1)
	if arg_26_1.on_release then
		arg_26_1.on_release = false

		return true
	end

	return false
end

function VersusTabUI._get_hero_portrait(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = "eor_empty_player"

	if arg_27_1 == nil or arg_27_2 == nil then
		return var_27_0
	end

	return SPProfiles[arg_27_1].careers[arg_27_2].portrait_image or var_27_0
end

function VersusTabUI._create_portrait_frame(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	local var_28_0 = arg_28_5 or 1
	local var_28_1 = false
	local var_28_2 = UIWidgets.create_portrait_frame(arg_28_1, arg_28_2, arg_28_3, var_28_0, var_28_1, arg_28_4)
	local var_28_3 = UIWidget.init(var_28_2, arg_28_0._ui_top_renderer)
	local var_28_4 = var_28_3.content

	var_28_4.frame_settings_name = arg_28_2
	var_28_4.level_text = arg_28_3

	return var_28_3
end

function VersusTabUI._apply_color_values(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if arg_29_3 then
		arg_29_1[1] = arg_29_2[1]
	end

	arg_29_1[2] = arg_29_2[2]
	arg_29_1[3] = arg_29_2[3]
	arg_29_1[4] = arg_29_2[4]
end

function VersusTabUI._show_profile_by_peer_id(arg_30_0, arg_30_1)
	if IS_WINDOWS and rawget(_G, "Steam") then
		local var_30_0 = Steam.id_hex_to_dec(arg_30_1)
		local var_30_1 = "http://steamcommunity.com/profiles/" .. var_30_0

		Steam.open_url(var_30_1)
	elseif IS_XB1 then
		local var_30_2 = arg_30_0.network_lobby:xuid(arg_30_1)

		if var_30_2 then
			XboxLive.show_gamercard(Managers.account:user_id(), var_30_2)
		end
	elseif IS_PS4 then
		Managers.account:show_player_profile_with_account_id(arg_30_1)
	end
end

function VersusTabUI._muted_peer_id(arg_31_0, arg_31_1)
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

function VersusTabUI._ignore_voice_message_from_peer_id(arg_32_0, arg_32_1)
	if IS_XB1 then
		if Managers.voice_chat then
			Managers.voice_chat:mute_peer(arg_32_1)
		end
	else
		arg_32_0._voip:mute_member(arg_32_1)
	end
end

function VersusTabUI._remove_ignore_voice_message_from_peer_id(arg_33_0, arg_33_1)
	if IS_XB1 then
		if Managers.voice_chat then
			Managers.voice_chat:unmute_peer(arg_33_1)
		end
	else
		arg_33_0._voip:unmute_member(arg_33_1)
	end
end

function VersusTabUI._ignoring_chat_peer_id(arg_34_0, arg_34_1)
	if IS_WINDOWS then
		return Managers.chat.chat_gui:ignoring_peer_id(arg_34_1)
	elseif IS_XB1 then
		return Managers.chat:ignoring_peer_id(arg_34_1)
	end
end

function VersusTabUI._ignore_chat_message_from_peer_id(arg_35_0, arg_35_1)
	if IS_WINDOWS then
		Managers.chat.chat_gui:ignore_peer_id(arg_35_1)
	elseif IS_XB1 then
		Managers.chat:ignore_peer_id(arg_35_1)
	end
end

function VersusTabUI._can_host_solo_kick(arg_36_0)
	return arg_36_0._is_server and Managers.player:num_human_players() == 2
end

function VersusTabUI._can_kick_player(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0:_is_in_local_player_party(arg_37_1)

	if arg_37_1 and var_37_0 then
		var_0_9.kick_peer_id = arg_37_1

		local var_37_1 = Managers.party:is_leader(arg_37_1)

		if Managers.state.voting:can_start_vote("kick_player", var_0_9) and arg_37_1 ~= Network.peer_id() and not var_37_1 and Managers.player:num_human_players() > 2 then
			return true
		end
	end

	return false
end

function VersusTabUI._kick_player_attempt(arg_38_0, arg_38_1)
	if arg_38_0:_can_kick_player(arg_38_1) then
		local var_38_0 = {
			kick_peer_id = arg_38_1
		}

		Managers.state.voting:request_vote("kick_player", var_38_0, Network.peer_id())
		arg_38_0:set_active(false)
	end
end

function VersusTabUI._update_players_panel_button_widgets(arg_39_0)
	local var_39_0 = Managers.state.voting:vote_kick_enabled()
	local var_39_1 = arg_39_0._custom_game_slots

	if var_39_1 then
		for iter_39_0 = 1, #var_39_1 do
			local var_39_2 = var_39_1[iter_39_0]

			for iter_39_1 = 1, #var_39_2 do
				local var_39_3 = var_39_2[iter_39_1]
				local var_39_4 = var_39_3.panel_widget
				local var_39_5 = var_39_4.content
				local var_39_6 = var_39_4.style
				local var_39_7 = var_39_3.empty
				local var_39_8 = var_39_3.is_player
				local var_39_9 = var_39_3.peer_id
				local var_39_10 = var_39_3.is_local_player
				local var_39_11 = var_39_3.is_bot
				local var_39_12 = var_39_0 and arg_39_0:_can_kick_player(var_39_9)

				if not var_39_7 and var_39_8 then
					if var_39_10 or var_39_11 then
						var_39_5.show_chat_button = false
						var_39_5.show_kick_button = false
						var_39_5.show_voice_button = false
						var_39_5.show_profile_button = var_39_10 and not var_39_11
						var_39_5.show_ping = not var_39_10 and not var_39_11
						var_39_5.chat_button_hotspot.disable_button = true
						var_39_5.kick_button_hotspot.disable_button = true
						var_39_5.voice_button_hotspot.disable_button = true
						var_39_5.profile_button_hotspot.disable_button = var_39_11
					else
						if var_39_12 then
							var_39_5.show_kick_button = true
							var_39_5.kick_button_hotspot.disable_button = false
						else
							var_39_5.show_kick_button = false
							var_39_5.kick_button_hotspot.disable_button = true
						end

						var_39_5.show_profile_button = true
						var_39_5.show_chat_button = not IS_PS4
						var_39_5.show_voice_button = true
						var_39_5.show_ping = true
						var_39_5.profile_button_hotspot.disable_button = false
						var_39_5.chat_button_hotspot.disable_button = IS_PS4
						var_39_5.voice_button_hotspot.disable_button = false
						var_39_5.chat_button_hotspot.is_selected = arg_39_0:_ignoring_chat_peer_id(var_39_9)
						var_39_5.voice_button_hotspot.is_selected = arg_39_0:_muted_peer_id(var_39_9)
					end
				end
			end
		end
	end
end

function VersusTabUI._handle_players_panel_button_input(arg_40_0)
	local var_40_0 = arg_40_0._custom_game_slots

	if var_40_0 then
		for iter_40_0 = 1, #var_40_0 do
			local var_40_1 = var_40_0[iter_40_0]

			for iter_40_1 = 1, #var_40_1 do
				local var_40_2 = var_40_1[iter_40_1]
				local var_40_3 = var_40_2.panel_widget
				local var_40_4 = var_40_3.content
				local var_40_5 = var_40_3.style
				local var_40_6 = var_40_2.empty
				local var_40_7 = var_40_2.is_player
				local var_40_8 = var_40_2.peer_id
				local var_40_9 = var_40_2.is_local_player
				local var_40_10 = var_40_2.is_bot

				if not var_40_6 then
					if var_40_7 then
						if not var_40_10 then
							local var_40_11 = var_40_4.profile_button_hotspot

							if var_40_11.on_pressed then
								var_40_11.on_pressed = nil

								arg_40_0:_show_profile_by_peer_id(var_40_8)
							end
						end

						if not var_40_9 then
							local var_40_12 = var_40_4.chat_button_hotspot

							if var_40_12.on_pressed then
								var_40_12.on_pressed = nil

								if var_40_12.is_selected then
									arg_40_0:_remove_ignore_chat_message_from_peer_id(var_40_8)

									var_40_12.is_selected = nil
								else
									arg_40_0:_ignore_chat_message_from_peer_id(var_40_8)

									var_40_12.is_selected = true
								end
							end

							local var_40_13 = var_40_4.voice_button_hotspot

							if var_40_13.on_pressed then
								var_40_13.on_pressed = nil

								if var_40_13.is_selected then
									arg_40_0:_remove_ignore_voice_message_from_peer_id(var_40_8)

									var_40_13.is_selected = nil
								else
									arg_40_0:_ignore_voice_message_from_peer_id(var_40_8)

									var_40_13.is_selected = true
								end
							end

							local var_40_14 = var_40_4.kick_button_hotspot

							if var_40_14.on_pressed then
								var_40_14.on_pressed = nil

								arg_40_0:_kick_player_attempt(var_40_8)
							end
						end
					end

					for iter_40_2 = 1, #var_0_10 do
						local var_40_15 = var_0_10[iter_40_2]

						if UIUtils.is_button_hover(var_40_3, var_40_15 .. "_hotspot") then
							local var_40_16 = var_40_3.content[var_40_15 .. "_item_name"]

							arg_40_0:_update_item_slots_tooltip(var_40_16, var_40_3)
						end
					end
				end
			end
		end
	end
end

function VersusTabUI._update_player_item_slots(arg_41_0, arg_41_1, arg_41_2)
	for iter_41_0 = 1, #var_0_10 do
		local var_41_0 = var_0_10[iter_41_0]
		local var_41_1 = arg_41_1[var_41_0].data.name

		if arg_41_2.content[var_41_0 .. "_item_name"] ~= var_41_1 then
			arg_41_0:_set_player_custom_panel_loadout_icon(arg_41_2, var_41_1, var_41_0)
		end
	end
end

local var_0_11 = {
	alpha_multiplier = 0
}

function VersusTabUI._update_item_slots_tooltip(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_0._ui_scenegraph
	local var_42_1 = arg_42_0._ui_top_renderer
	local var_42_2 = arg_42_0._item_tooltip
	local var_42_3 = var_42_2.style

	var_42_2.content.item = {
		data = ItemMasterList[arg_42_1]
	}

	UIRenderer.begin_pass(var_42_1, var_42_0, FAKE_INPUT_SERVICE, 0, nil, var_0_11)
	UIRenderer.draw_widget(var_42_1, var_42_2)
	UIRenderer.end_pass(var_42_1)

	local var_42_4 = var_42_0.item_tooltip
	local var_42_5 = var_42_3.item.item_presentation_height - 100
	local var_42_6 = 1080 - var_42_5
	local var_42_7 = var_42_0[arg_42_2.scenegraph_id]
	local var_42_8 = var_42_7.position

	if var_42_7.horizontal_alignment == "left" then
		var_42_4.horizontal_alignment = "left"
		var_42_4.local_position[1] = 20 + var_42_7.size[1] + 50
		var_42_4.local_position[2] = math.min(var_42_8[2] + var_42_5, var_42_6) + 50
	else
		var_42_4.horizontal_alignment = "right"
		var_42_4.local_position[1] = -20 - var_42_7.size[1] - 50
		var_42_4.local_position[2] = math.min(var_42_8[2] + var_42_5, var_42_6) + 50
	end
end

function VersusTabUI._update_player_talents(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = arg_43_3.content
	local var_43_1 = ScriptUnit.has_extension(arg_43_1, "talent_system")

	if var_43_1 then
		local var_43_2 = var_43_1:get_talent_ids()
		local var_43_3 = arg_43_2:profile_display_name()

		for iter_43_0 = 1, 6 do
			local var_43_4 = var_43_2[iter_43_0]
			local var_43_5 = TalentUtils.get_talent_by_id(var_43_3, var_43_4)
			local var_43_6 = var_43_5 and var_43_5.icon
			local var_43_7 = var_43_0["talent_" .. iter_43_0]

			if not var_43_6 then
				var_43_5 = nil
			end

			var_43_7.talent = var_43_5
			var_43_7.icon = var_43_6 or "icons_placeholder"
		end
	end
end

function VersusTabUI._update_player_talents_tooltip(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_1.content

	for iter_44_0 = 1, 6 do
		local var_44_1 = var_44_0["talent_" .. iter_44_0]

		if var_44_1.talent and var_44_1.is_hover then
			local var_44_2 = arg_44_1.scenegraph_id
			local var_44_3 = arg_44_0._ui_scenegraph[var_44_2]
			local var_44_4 = var_44_3.position
			local var_44_5 = var_44_3.horizontal_alignment == "left"
			local var_44_6 = arg_44_0._ui_scenegraph.talent_tooltip

			if var_44_5 then
				var_44_6.horizontal_alignment = "left"
				var_44_6.local_position[1] = 20 + var_44_3.size[1] + 50
				var_44_6.local_position[2] = var_44_3.position[2] + 50
			else
				var_44_6.horizontal_alignment = "right"
				var_44_6.local_position[1] = -20 - var_44_3.size[1] - 50
				var_44_6.local_position[2] = var_44_3.position[2] + 50
			end
		end
	end
end

function VersusTabUI._update_player_health(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = Managers.state.network:game()
	local var_45_1 = Managers.state.unit_storage:go_id(arg_45_1)
	local var_45_2 = ScriptUnit.extension(arg_45_1, "health_system")
	local var_45_3 = ScriptUnit.extension(arg_45_1, "status_system")
	local var_45_4 = ScriptUnit.extension(arg_45_1, "buff_system")
	local var_45_5 = ScriptUnit.extension(arg_45_1, "inventory_system")
	local var_45_6 = var_45_2:get_max_health()
	local var_45_7 = var_45_3:is_dead()
	local var_45_8

	var_45_8 = var_45_7 and 0 or var_45_2:current_health()

	local var_45_9 = var_45_7 and 0 or var_45_2:current_health_percent()
	local var_45_10 = var_45_7 and 0 or var_45_2:current_permanent_health_percent()
	local var_45_11 = var_45_3:is_wounded()
	local var_45_12 = (var_45_3:is_knocked_down() or var_45_3:get_is_ledge_hanging()) and var_45_9 > 0
	local var_45_13 = var_45_3:is_ready_for_assisted_respawn()
	local var_45_14 = var_45_3:is_grabbed_by_pack_master() or var_45_3:is_hanging_from_hook() or var_45_3:is_pounced_down() or var_45_3:is_grabbed_by_corruptor() or var_45_3:is_in_vortex() or var_45_3:is_grabbed_by_chaos_spawn()
	local var_45_15 = var_45_4:num_buff_perk("skaven_grimoire")
	local var_45_16 = var_45_4:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
	local var_45_17 = var_45_4:num_buff_perk("twitch_grimoire")
	local var_45_18 = var_45_4:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
	local var_45_19 = var_45_4:num_buff_perk("slayer_curse")
	local var_45_20 = var_45_4:apply_buffs_to_value(PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF, "curse_protection")
	local var_45_21 = var_45_4:num_buff_perk("mutator_curse")
	local var_45_22 = WindSettings.light.curse_settings.value
	local var_45_23 = Managers.state.difficulty:get_difficulty_value_from_table(var_45_22)
	local var_45_24 = var_45_4:apply_buffs_to_value(var_45_23, "curse_protection")
	local var_45_25 = var_45_4:apply_buffs_to_value(0, "health_curse")
	local var_45_26 = var_45_4:apply_buffs_to_value(var_45_25, "curse_protection")
	local var_45_27 = 1 + var_45_15 * var_45_16 + var_45_17 * var_45_18 + var_45_19 * var_45_20 + var_45_21 * var_45_24 + var_45_26
	local var_45_28 = arg_45_2.style
	local var_45_29 = arg_45_2.content
	local var_45_30 = var_45_28.health_bar
	local var_45_31 = var_45_28.total_health_bar
	local var_45_32 = var_45_29.ability_bar

	if var_45_0 and var_45_1 then
		var_45_32.bar_value = 1 - (GameSession.game_object_field(var_45_0, var_45_1, "ability_percentage") or 0)
	end

	var_45_30.gradient_threshold = var_45_10 * var_45_27
	var_45_31.gradient_threshold = var_45_9 * var_45_27

	return var_45_11, var_45_12, var_45_14, var_45_7
end

function VersusTabUI._is_in_local_player_party(arg_46_0, arg_46_1)
	local var_46_0 = Managers.party:get_local_player_party()

	if var_46_0 then
		local var_46_1 = var_46_0.occupied_slots

		for iter_46_0 = 1, #var_46_1 do
			if arg_46_1 == var_46_1[iter_46_0].peer_id then
				return true
			end
		end
	end

	return false
end

function VersusTabUI._get_opponent_party_id(arg_47_0)
	return arg_47_0._party_id == 1 and 2 or 1
end

function VersusTabUI._remove_ignore_chat_message_from_peer_id(arg_48_0, arg_48_1)
	if IS_WINDOWS then
		Managers.chat.chat_gui:remove_ignore_peer_id(arg_48_1)
	elseif IS_XB1 then
		Managers.chat:remove_ignore_peer_id(arg_48_1)
	end
end

function VersusTabUI.add_respawn_counter_event(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	local var_49_0 = arg_49_1.peer_id
	local var_49_1 = arg_49_0:_get_player_slot_by_peer_id(var_49_0)

	if var_49_1 and arg_49_3 > 0 then
		local var_49_2 = var_49_1.panel_widget.content

		var_49_2.respawning = true
		var_49_2.spawn_timer = arg_49_3
	end
end

function VersusTabUI._update_player_respawn_counter(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_1.portrait_widget

	if not var_50_0 then
		return
	end

	local var_50_1 = arg_50_1.panel_widget

	if var_50_1.content.respawning then
		local var_50_2, var_50_3 = Managers.time:time_and_delta("game")
		local var_50_4 = var_50_1.content.spawn_timer - var_50_2

		if var_50_4 <= 0 then
			var_50_1.content.respawning = false
		end

		var_50_1.content.respawn_text = string.format("%d", math.abs(var_50_4))
	end

	var_50_0.style.portrait.saturated = var_50_1.content.respawning
end

function VersusTabUI._update_player_status_portrait(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9)
	local var_51_0 = arg_51_1.portrait_widget

	if not var_51_0 then
		return
	end

	local var_51_1 = arg_51_1.panel_widget
	local var_51_2 = var_51_1.content

	if arg_51_4 and not arg_51_5 then
		var_51_0.content.portrait = "eor_empty_player"
		var_51_0.style.portrait.color[1] = 255
	elseif var_51_2.is_wounded ~= arg_51_6 or var_51_2.is_knocked_down ~= arg_51_7 or var_51_2.needs_help ~= arg_51_8 or var_51_2.is_dead ~= arg_51_9 then
		local var_51_3 = var_51_1.style

		if arg_51_7 or arg_51_8 then
			var_51_0.content.portrait = "status_icon_needs_assist"
			var_51_0.style.portrait.color[1] = 150
		elseif arg_51_9 and not var_51_2.respawning then
			var_51_0.content.portrait = "status_icon_dead"
			var_51_0.style.portrait.color[1] = 255
		else
			local var_51_4 = arg_51_0:_get_hero_portrait(arg_51_2, arg_51_3)

			var_51_0.content.portrait = var_51_4
			var_51_0.style.portrait.color[1] = 255
		end
	end
end

function VersusTabUI._get_player_slot_by_peer_id(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0._custom_game_slots

	if var_52_0 then
		for iter_52_0 = 1, #var_52_0 do
			local var_52_1 = var_52_0[iter_52_0]

			for iter_52_1 = 1, #var_52_1 do
				local var_52_2 = var_52_1[iter_52_1]

				if var_52_2.peer_id == arg_52_1 then
					return var_52_2
				end
			end
		end
	end
end

function VersusTabUI._get_ping_texture_by_ping_value(arg_53_0, arg_53_1)
	if arg_53_1 <= 125 then
		return "ping_icon_01", "low_ping_color"
	elseif arg_53_1 > 125 and arg_53_1 <= 175 then
		return "ping_icon_02", "medium_ping_color"
	elseif arg_53_1 > 175 then
		return "ping_icon_03", "high_ping_color"
	end
end

function VersusTabUI._update_objectives(arg_54_0, arg_54_1, arg_54_2)
	if not arg_54_0._objective_system:is_active() then
		return
	end

	if not arg_54_0._objectives_initialized then
		local var_54_0 = not arg_54_0:_is_dark_pact()

		arg_54_0:_set_active_scoring_side_color(var_54_0)

		arg_54_0._num_main_objective = arg_54_0._objective_system:num_main_objectives()
		arg_54_0._objectives_initialized = true
	end

	local var_54_1 = arg_54_0._objective_system:current_objective_index()
	local var_54_2 = arg_54_0._objective_system:num_completed_main_objectives()

	if var_54_1 > arg_54_0._selected_objective_index then
		arg_54_0._selected_objective_index = var_54_1

		arg_54_0:_update_current_objective(var_54_1)

		local var_54_3 = "n/a"

		if arg_54_0:_is_dark_pact() then
			var_54_3 = Localize("level_objective_pactsworn")
		else
			var_54_3 = arg_54_0._objective_system:first_active_objective_description()
		end

		arg_54_0:_set_objective_text(var_54_3)
	end

	arg_54_0:_update_objective_progress()
end

function VersusTabUI._update_current_objective(arg_55_0)
	local var_55_0 = arg_55_0._widgets_by_name.score
	local var_55_1 = arg_55_0._objective_system:current_objective_icon()

	var_55_0.content.objective_icon = var_55_1
end

function VersusTabUI._update_objective_progress(arg_56_0)
	local var_56_0 = arg_56_0._objective_system:current_objective_progress() or 0
	local var_56_1 = 0
	local var_56_2 = 360 - var_56_1 * 2
	local var_56_3 = 255 * math.min(var_56_0 * 2, 1)
	local var_56_4 = (var_56_1 + var_56_2 * var_56_0) / 360

	arg_56_0._widgets_by_name.score.style.progress_bar.gradient_threshold = var_56_4

	if var_56_0 == 1 then
		return true
	end
end

function VersusTabUI._update_round_start_timer(arg_57_0, arg_57_1, arg_57_2)
	if arg_57_0._round_has_started then
		return
	end

	if arg_57_0._countdown_timer and arg_57_0._countdown_timer <= 0 then
		arg_57_0:_on_round_started()
	end
end

function VersusTabUI._set_pre_round_timer(arg_58_0, arg_58_1)
	arg_58_0._widgets_by_name.score.content.pre_round_timer = arg_58_1
	arg_58_0._countdown_timer = arg_58_1
end

function VersusTabUI._set_round_starting_text(arg_59_0)
	arg_59_0._widgets_by_name.round_starting_text.content.text = "Round Starting..."
end

function VersusTabUI._set_objective_text(arg_60_0, arg_60_1)
	local var_60_0 = arg_60_0._widgets_by_name.objective_text
	local var_60_1 = var_60_0.content
	local var_60_2 = var_60_0.style

	var_60_1.area_text_content = arg_60_1
end

function VersusTabUI._register_events(arg_61_0)
	local var_61_0 = Managers.state.event

	if var_61_0 then
		var_61_0:register(arg_61_0, "add_respawn_counter_event", "add_respawn_counter_event")
		var_61_0:register(arg_61_0, "ui_tab_update_start_round_counter", "update_start_round_counter")
		var_61_0:register(arg_61_0, "ui_tab_round_started", "round_started")
	end
end

function VersusTabUI._unregister_events(arg_62_0)
	local var_62_0 = Managers.state.event

	if var_62_0 then
		var_62_0:unregister("add_respawn_counter_event", arg_62_0)
		var_62_0:unregister("ui_tab_update_start_round_counter", arg_62_0)
		var_62_0:unregister("ui_tab_round_started", arg_62_0)
	end
end

function VersusTabUI.update_start_round_counter(arg_63_0, arg_63_1)
	arg_63_0:_set_pre_round_timer(arg_63_1)
end

function VersusTabUI._on_round_started(arg_64_0)
	arg_64_0._round_has_started = true

	local var_64_0 = arg_64_0._widgets_by_name.score.content

	if arg_64_0._custom_round_timer_active then
		-- block empty
	end

	var_64_0.pre_round_timer_done = true
end

function VersusTabUI.round_started(arg_65_0)
	arg_65_0:_on_round_started()
end

function VersusTabUI._set_active_scoring_side_color(arg_66_0, arg_66_1)
	local var_66_0 = arg_66_1 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	local var_66_1 = arg_66_0._widgets_by_name.score

	var_66_1.content.is_hero = arg_66_1
	var_66_1.style.progress_bar.color = var_66_0
	var_66_1.style.objective_icon.color = var_66_0
end

function VersusTabUI._is_dark_pact(arg_67_0)
	local var_67_0 = arg_67_0._party_id
	local var_67_1 = Managers.party:get_party(var_67_0)
	local var_67_2 = Managers.state.side.side_by_party[var_67_1]

	return var_67_2 and var_67_2:name() == "dark_pact"
end

function VersusTabUI._get_current_set(arg_68_0)
	local var_68_0 = arg_68_0._win_conditions:get_current_round()

	return math.round(var_68_0 / 2)
end

function VersusTabUI._setup_custom_settings_scrollbar(arg_69_0, arg_69_1, arg_69_2)
	local var_69_0 = arg_69_1 * arg_69_2 - var_0_0.scenegraph_definition.settings_container.size[2]

	if var_69_0 > 0 then
		local var_69_1 = arg_69_0._ui_scenegraph
		local var_69_2 = "settings_anchor"
		local var_69_3 = "settings_container"
		local var_69_4 = false
		local var_69_5
		local var_69_6

		arg_69_0._scrollbar_ui = ScrollbarUI:new(var_69_1, var_69_2, var_69_3, var_69_0, var_69_4, var_69_5, var_69_6)
	end
end
