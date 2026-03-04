-- chunkname: @scripts/ui/views/ingame_ui.lua

require("scripts/ui/ui_layer")
require("scripts/ui/ui_renderer")
require("scripts/ui/ui_elements")
require("scripts/ui/ui_widget")
require("scripts/ui/ui_widgets")
require("scripts/ui/ui_widgets_weaves")
require("scripts/ui/views/ingame_view")
require("scripts/ui/views/ingame_hud")
require("scripts/ui/views/popup_handler")
require("scripts/ui/views/end_screen_ui")
require("scripts/settings/ui_settings")
require("scripts/settings/ui_frame_settings")
require("scripts/ui/help_screen/help_screen_ui")
require("scripts/ui/views/credits_view")
require("scripts/ui/views/options_view")
require("scripts/ui/views/unlock_key_view")
require("scripts/ui/views/telemetry_survey_view")
require("scripts/ui/views/hero_view/hero_view")
require("scripts/ui/views/start_game_view/start_game_view")
require("scripts/ui/views/character_selection_view/character_selection_view")
require("scripts/ui/views/chat_view")
require("scripts/ui/views/start_menu_view/start_menu_view")
require("scripts/ui/views/console_friends_view")
require("scripts/ui/views/cinematics_view/cinematics_view_settings")
require("scripts/ui/views/cinematics_view/cinematics_view")
require("scripts/ui/views/friends_ui_component")
require("scripts/ui/text_popup/text_popup_ui")
require("scripts/ui/weave_tutorial/weave_ui_onboarding_tutorial")
require("scripts/ui/dlc_upsell/common_popup_handler")
require("scripts/ui/hint_ui/hint_ui_handler")
DLCUtils.map_list("ui_views", function (arg_1_0)
	local var_1_0 = arg_1_0.file

	if var_1_0 then
		dofile(var_1_0)
	end
end)

for iter_0_0, iter_0_1 in pairs(PopupSettings) do
	if iter_0_1.file then
		require(iter_0_1.file)
	end
end

local var_0_0 = {}
local var_0_1 = require("scripts/ui/views/ingame_ui_settings")
local var_0_2 = var_0_1.view_settings
local var_0_3 = var_0_1.transitions
local var_0_4 = script_data.testify and require("scripts/ui/views/ingame_ui_testify")

IngameUI = class(IngameUI)

IngameUI.init = function (arg_2_0, arg_2_1)
	printf("[IngameUI] init")

	arg_2_0.unlock_manager = Managers.unlock
	arg_2_0.world_manager = arg_2_1.world_manager
	arg_2_0.camera_manager = arg_2_1.camera_manager
	arg_2_0.is_in_inn = arg_2_1.is_in_inn

	local var_2_0 = Managers.world:world("level_world")
	local var_2_1 = Managers.world:world("top_ingame_view")
	local var_2_2 = Managers.world:wwise_world(var_2_0)

	arg_2_0.wwise_world = var_2_2
	arg_2_0.world = var_2_0
	arg_2_0.top_world = var_2_1

	local var_2_3 = Managers.state.game_mode:game_mode_key()
	local var_2_4 = Managers.mechanism:current_mechanism_name()
	local var_2_5 = var_2_3 == "tutorial"
	local var_2_6 = arg_2_0.is_in_inn

	arg_2_0.ui_renderer = arg_2_0:create_ui_renderer(var_2_0, var_2_5, var_2_6, var_2_4)
	arg_2_0.ui_top_renderer = arg_2_0:create_ui_renderer(var_2_1, var_2_5, var_2_6, var_2_4)
	arg_2_0.blocked_transitions = var_0_2.blocked_transitions
	arg_2_0.fps = 0
	arg_2_0.mean_dt = 0
	arg_2_0._fps_cooldown = 0

	UISetupFontHeights(arg_2_0.ui_renderer.gui)

	local var_2_7 = arg_2_1.input_manager

	arg_2_0.input_manager = var_2_7

	var_2_7:create_input_service("ingame_menu", "IngameMenuKeymaps", "IngameMenuFilters")
	var_2_7:map_device_to_service("ingame_menu", "keyboard")
	var_2_7:map_device_to_service("ingame_menu", "mouse")
	var_2_7:map_device_to_service("ingame_menu", "gamepad")

	arg_2_1.ui_renderer = arg_2_0.ui_renderer
	arg_2_1.ui_top_renderer = arg_2_0.ui_top_renderer
	arg_2_1.ingame_ui = arg_2_0
	arg_2_1.wwise_world = var_2_2
	arg_2_0.profile_synchronizer = arg_2_1.profile_synchronizer
	arg_2_0.peer_id = arg_2_1.peer_id
	arg_2_0.local_player_id = arg_2_1.local_player_id
	arg_2_0._player = arg_2_1.player
	arg_2_0.is_server = arg_2_1.is_server
	arg_2_0.ingame_hud = IngameHud:new(arg_2_0, arg_2_1)
	arg_2_0.popups_by_name = {}
	arg_2_0.last_resolution_x, arg_2_0.last_resolution_y = Application.resolution()

	arg_2_0:setup_views(arg_2_1)

	arg_2_0.end_screen = EndScreenUI:new(arg_2_1)
	arg_2_0.weave_onboarding = WeaveUIOnboardingTutorial:new(arg_2_1)
	arg_2_0.popup_handler = CommonPopupHandler:new(arg_2_1)
	arg_2_0.text_popup_ui = TextPopupUI:new(arg_2_1)
	arg_2_0.hint_ui_handler = HintUIHandler:new(arg_2_1)

	if GameSettingsDevelopment.help_screen_enabled then
		arg_2_0.help_screen = HelpScreenUI:new(arg_2_1)
	end

	arg_2_0.cutscene_system = Managers.state.entity:system("cutscene_system")

	arg_2_0:register_rpcs(arg_2_1.network_event_delegate)
	GarbageLeakDetector.register_object(arg_2_0, "IngameUI")

	if not arg_2_0.is_server and arg_2_0.is_in_inn and arg_2_0.views.map_view then
		arg_2_0.views.map_view:set_map_interaction_state(false)
	end

	Managers.chat:set_profile_synchronizer(arg_2_1.profile_synchronizer)
	Managers.chat:set_wwise_world(var_2_2)
	Managers.chat:set_input_manager(var_2_7)

	arg_2_0._profile_requester = (arg_2_1.network_server or arg_2_1.network_client):profile_requester()
	arg_2_0.telemetry_time_view_enter = 0
	arg_2_0.ingame_ui_context = arg_2_1
end

IngameUI.create_ui_renderer = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return var_0_2.ui_renderer_function(arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end

IngameUI.setup_views = function (arg_4_0, arg_4_1)
	arg_4_0.views = var_0_2.views_function(arg_4_1)
	arg_4_0.hotkey_mapping = var_0_2.hotkey_mapping
end

IngameUI.setup_specific_view = function (arg_5_0, arg_5_1, arg_5_2)
	printf("[IngameUI] setup_specific_view %s", arg_5_2)

	local var_5_0 = rawget(_G, arg_5_2)

	if arg_5_0.views[arg_5_1] and arg_5_0.views[arg_5_1].destroy then
		arg_5_0.views[arg_5_1]:destroy()
		printf("[IngameUI] setup_specific_view destroy %s", arg_5_2)
	end

	arg_5_0.views[arg_5_1] = var_5_0:new(arg_5_0.ingame_ui_context)
end

IngameUI.is_local_player_ready_for_game = function (arg_6_0)
	if arg_6_0.is_in_inn then
		local var_6_0 = Managers.player:local_player()
		local var_6_1 = var_6_0 and var_6_0.player_unit

		if var_6_1 then
			return ScriptUnit.extension(var_6_1, "status_system"):is_in_end_zone()
		end
	end
end

IngameUI.can_view_lobby_browser = function (arg_7_0)
	local var_7_0 = arg_7_0.is_server
	local var_7_1 = Managers.matchmaking:is_game_matchmaking()

	return var_7_0 and not var_7_1
end

script_data.lorebook_enabled = script_data.lorebook_enabled or Development.parameter("lorebook_enabled")

IngameUI.is_lorebook_enabled = function (arg_8_0)
	if not script_data.lorebook_enabled then
		return false
	end

	return true
end

IngameUI.register_rpcs = function (arg_9_0, arg_9_1)
	arg_9_0.network_event_delegate = arg_9_1

	arg_9_1:register(arg_9_0, unpack(var_0_0))
end

IngameUI.unregister_rpcs = function (arg_10_0)
	arg_10_0.network_event_delegate:unregister(arg_10_0)

	arg_10_0.network_event_delegate = nil
end

IngameUI.is_in_view_state = function (arg_11_0, arg_11_1)
	if not arg_11_0.current_view then
		return false
	end

	local var_11_0 = arg_11_0.views[arg_11_0.current_view]
	local var_11_1 = var_11_0.current_state and var_11_0:current_state()

	if not var_11_1 then
		return false
	end

	return var_11_1.NAME == arg_11_1
end

IngameUI.destroy = function (arg_12_0)
	arg_12_0:unregister_rpcs()
	Managers.chat:set_profile_synchronizer(nil)
	Managers.chat:set_wwise_world(nil)
	Managers.chat:set_input_manager(nil)

	local var_12_0 = arg_12_0.current_view

	if not arg_12_0.menu_active and var_12_0 then
		-- Nothing
	end

	if var_12_0 then
		local var_12_1 = {}

		arg_12_0.views[var_12_0]:on_exit(var_12_1)

		arg_12_0.current_view = nil
	end

	for iter_12_0, iter_12_1 in pairs(arg_12_0.views) do
		if iter_12_1.destroy then
			iter_12_1:destroy()
		end
	end

	arg_12_0.end_screen:destroy()

	arg_12_0.end_screen = nil

	arg_12_0.ingame_hud:destroy()

	arg_12_0.ingame_hud = nil

	if arg_12_0.help_screen then
		arg_12_0.help_screen:destroy()

		arg_12_0.help_screen = nil
	end

	local var_12_2 = arg_12_0.popups_by_name

	for iter_12_2, iter_12_3 in pairs(arg_12_0.popups_by_name) do
		local var_12_3 = iter_12_3.popup

		var_12_3:hide()
		var_12_3:delete()

		var_12_2[iter_12_2] = nil
	end

	arg_12_0.text_popup_ui:destroy()

	arg_12_0.text_popup_ui = nil

	if arg_12_0.popup_id then
		Managers.popup:cancel_popup(arg_12_0.popup_id)
	end

	if arg_12_0.weave_onboarding then
		arg_12_0.weave_onboarding:destroy()

		arg_12_0.weave_onboarding = nil
	end

	if arg_12_0.popup_handler then
		arg_12_0.popup_handler:destroy()

		arg_12_0.popup_handler = nil
	end

	if arg_12_0.hint_ui_handler then
		arg_12_0.hint_ui_handler:destroy()

		arg_12_0.hint_ui_handler = nil
	end

	UIRenderer.destroy(arg_12_0.ui_renderer, arg_12_0.world)
	UIRenderer.destroy(arg_12_0.ui_top_renderer, arg_12_0.top_world)

	arg_12_0.ui_renderer = nil
	arg_12_0.ui_top_renderer = nil

	printf("[IngameUI] destroy")
end

IngameUI.weaves_requirements_fulfilled = function (arg_13_0)
	if Managers.mechanism:current_mechanism_name() ~= "adventure" then
		return false
	end

	if script_data.unlock_all_levels then
		return true
	end

	if Managers.twitch and (Managers.twitch:is_connected() or Managers.twitch:is_activated()) then
		Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.twitch_not_supported_for_weaves)

		return false
	elseif not Managers.player.is_server and Managers.state.network:lobby():lobby_data("twitch_enabled") == "true" then
		Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.twitch_not_supported_for_weaves_client)

		return false
	end

	local var_13_0 = Managers.player
	local var_13_1 = var_13_0:statistics_db()
	local var_13_2 = var_13_0:local_player():stats_id()

	for iter_13_0, iter_13_1 in pairs(HelmgartLevels) do
		if LevelSettings[iter_13_1].mechanism == "adventure" and var_13_1:get_persistent_stat(var_13_2, "completed_levels", iter_13_1) < 1 then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.requirements_not_met)

			return false
		end
	end

	local var_13_3 = GameActs.act_scorpion

	for iter_13_2, iter_13_3 in pairs(var_13_3) do
		if LevelSettings[iter_13_3].mechanism == "adventure" and var_13_1:get_persistent_stat(var_13_2, "completed_levels", iter_13_3) < 1 then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.requirements_not_met)

			return false
		end
	end

	return true
end

IngameUI._handle_versus_matchmaking = function (arg_14_0)
	local var_14_0 = Managers.matchmaking

	if not var_14_0:is_matchmaking_versus() then
		return true
	end

	if var_14_0:is_in_versus_custom_game_lobby() then
		return true
	end

	arg_14_0:add_local_system_message("matchmaking_ready_interaction_message_map")

	return false
end

IngameUI.not_in_modded = function (arg_15_0)
	return not script_data["eac-untrusted"]
end

local var_0_5 = {
	"hotkey_map"
}

IngameUI.handle_menu_hotkeys = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	if not arg_16_3 then
		return
	end

	local var_16_0 = arg_16_0.views
	local var_16_1 = arg_16_0.current_view
	local var_16_2 = arg_16_0.hotkey_mapping
	local var_16_3 = Managers.player:local_player()

	if not (var_16_3 and var_16_3.player_unit ~= nil) then
		return
	end

	local var_16_4 = arg_16_0:is_local_player_ready_for_game()
	local var_16_5 = Managers.matchmaking:is_game_matchmaking()
	local var_16_6 = Managers.state.voting
	local var_16_7 = var_16_6:vote_in_progress() and var_16_6:is_mission_vote()

	for iter_16_0, iter_16_1 in pairs(var_16_2) do
		if var_16_1 then
			if var_16_1 == iter_16_1.view then
				local var_16_8 = var_16_0[var_16_1]
				local var_16_9 = var_16_8:input_service()

				if not var_16_8:transitioning() and var_16_9:get(iter_16_0) then
					local var_16_10 = arg_16_0.transition_params
					local var_16_11 = var_16_10 and var_16_10.menu_state_name
					local var_16_12 = var_16_10 and var_16_10.menu_sub_state_name
					local var_16_13 = var_16_11 == iter_16_1.transition_state
					local var_16_14 = var_16_12 == iter_16_1.transition_sub_state
					local var_16_15 = var_16_10 and var_16_10.ignore_sub_state_on_exit

					if (var_16_13 and var_16_14 or var_16_13 and var_16_15) and (var_16_8.hotkey_allowed and var_16_8:hotkey_allowed(iter_16_0, iter_16_1)) ~= false then
						local var_16_16 = not arg_16_4

						var_16_0[var_16_1]:exit(var_16_16)

						break
					end
				end
			end
		else
			local var_16_17
			local var_16_18
			local var_16_19
			local var_16_20 = Managers.mechanism:current_mechanism_name()
			local var_16_21 = iter_16_1.disable_for_mechanism and iter_16_1.disable_for_mechanism[var_16_20]

			if var_16_21 then
				var_16_17 = var_16_21.matchmaking
				var_16_18 = var_16_21.matchmaking_ready
				var_16_19 = var_16_21.not_matchmaking
			end

			local var_16_22 = table.contains(var_0_5, iter_16_0)
			local var_16_23 = var_16_4 and var_16_18 or var_16_5 and var_16_17 or var_16_22 and var_16_7

			var_16_23 = var_16_23 or var_16_19

			local var_16_24 = var_16_0[iter_16_1.view]
			local var_16_25 = iter_16_1.can_interact_flag
			local var_16_26 = iter_16_1.can_interact_func
			local var_16_27 = iter_16_1.required_dlc

			if arg_16_2:get(iter_16_0) then
				local var_16_28 = true

				if var_16_25 and not var_16_24[var_16_25] then
					var_16_28 = false
				end

				if var_16_28 and var_16_26 and not arg_16_0[var_16_26](arg_16_0) then
					var_16_28 = false
				end

				if var_16_28 and var_16_27 and not Managers.unlock:is_dlc_unlocked(var_16_27) then
					var_16_28 = false
				end

				if var_16_28 then
					if var_16_23 then
						local var_16_29 = iter_16_1.error_message

						if var_16_29 then
							arg_16_0:add_local_system_message(var_16_29)
						end

						break
					end

					local var_16_30 = arg_16_4 and iter_16_1.in_transition_menu or iter_16_1.in_transition
					local var_16_31 = {
						menu_state_name = iter_16_1.transition_state,
						menu_sub_state_name = iter_16_1.transition_sub_state
					}
					local var_16_32 = iter_16_1.inject_transition_params_func

					if var_16_32 then
						var_16_32(var_16_31)
					end

					arg_16_0:transition_with_fade(var_16_30, var_16_31)

					break
				end
			end
		end
	end
end

IngameUI.event_dlc_status_changed = function (arg_17_0)
	if arg_17_0.current_view == "map_view" then
		arg_17_0:handle_transition("exit_menu")
	end

	arg_17_0:setup_specific_view("map_view", "ConsoleMapView")
end

IngameUI.update_loading_subtitle_gui = function (arg_18_0, arg_18_1, arg_18_2)
	arg_18_1:update(arg_18_0.ui_top_renderer, arg_18_2)
end

IngameUI.update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	arg_19_0._disable_ingame_ui = arg_19_3

	arg_19_0:_update_fade_transition()

	local var_19_0 = arg_19_0.views
	local var_19_1 = arg_19_0.is_in_inn
	local var_19_2 = arg_19_0.input_manager:get_service("ingame_menu")
	local var_19_3 = arg_19_0.ingame_hud
	local var_19_4 = Managers.transition
	local var_19_5 = arg_19_0.end_screen

	arg_19_0:_update_system_message_cooldown(arg_19_1)
	arg_19_0:_handle_resolution_changes()

	if arg_19_0.is_server then
		arg_19_0:update_map_enable_state()
	end

	if arg_19_0._respawning and arg_19_0:_update_respawning() then
		arg_19_0._respawning = nil
	end

	if arg_19_0.popup_id then
		local var_19_6 = Managers.popup:query_result(arg_19_0.popup_id)

		if var_19_6 then
			arg_19_0:handle_transition(var_19_6)
		end
	end

	if arg_19_0.survey_active then
		arg_19_0:_survey_update(arg_19_1)
	end

	if arg_19_0.quit_game_retry and arg_19_2 >= arg_19_0.delay_quit_game_retry then
		arg_19_0.quit_game_retry = nil

		arg_19_0:handle_transition("end_game")
	end

	if arg_19_0.hint_ui_handler then
		arg_19_0.hint_ui_handler:update(arg_19_1, arg_19_2)
	end

	if var_19_1 then
		local var_19_7 = arg_19_0.has_left_menu and arg_19_0.hud_visible

		arg_19_0.text_popup_ui:update(arg_19_1)

		if var_19_7 and not arg_19_0.text_popup_ui.is_visible and not PlayerData.viewed_dialogues.dlc_holly and Managers.unlock:is_dlc_unlocked("holly") then
			local var_19_8 = callback(arg_19_0, "_holly_dlc_intro_closed")

			arg_19_0.text_popup_ui:show("area_selection_holly_name", "holly_lohner_spiel_short", var_19_8)
		end

		if arg_19_0.weave_onboarding then
			arg_19_0.weave_onboarding:update(arg_19_1, arg_19_2)
		end

		if arg_19_0.popup_handler then
			arg_19_0.popup_handler:update(arg_19_1, arg_19_2)
		end
	end

	if not arg_19_3 then
		local var_19_9 = false

		if arg_19_0.current_view then
			local var_19_10 = arg_19_0.current_view

			var_19_0[var_19_10]:update(arg_19_1, arg_19_2)

			if var_19_0[var_19_10].disable_toggle_menu then
				var_19_9 = var_19_0[var_19_10]:disable_toggle_menu()
			end
		end

		local var_19_11 = Managers.input:is_device_active("gamepad")
		local var_19_12 = true
		local var_19_13 = var_19_3:component("IngamePlayerListUI")
		local var_19_14 = var_19_13 and var_19_13:is_active()
		local var_19_15 = var_19_3:component("VersusTabUI")
		local var_19_16 = var_19_3:component("VersusSlotStatusUI")

		var_19_14 = var_19_15 and var_19_15:is_active() or var_19_16 and var_19_16:is_active() or var_19_14

		local var_19_17 = Managers.state.game_mode:game_mode()

		if var_19_17.menu_access_allowed_in_state and not var_19_17:menu_access_allowed_in_state() then
			var_19_12 = false
		end

		local var_19_18 = Managers.transition:in_fade_active()

		if var_19_12 and not var_19_14 and not var_19_9 and not arg_19_0:pending_transition() and not var_19_18 and not arg_19_0:end_screen_active() and not arg_19_0.menu_active and not arg_19_0.leave_game and not arg_19_0.return_to_title_screen and not arg_19_0:get_active_popup("profile_picker") and var_19_2:get("toggle_menu", true) then
			if IS_CONSOLE or var_19_11 or not UISettings.use_pc_menu_layout then
				local var_19_19 = "overview"

				if var_19_1 and var_19_11 then
					local var_19_20 = var_19_11 and "equipment" or "system"
					local var_19_21 = {
						menu_state_name = var_19_19,
						menu_sub_state_name = var_19_20
					}

					arg_19_0:transition_with_fade("hero_view_force", var_19_21)
				else
					local var_19_22 = "system"
					local var_19_23 = {
						menu_state_name = var_19_19,
						menu_sub_state_name = var_19_22,
						force_ingame_menu = IS_WINDOWS
					}

					arg_19_0:handle_transition("hero_view_force", var_19_23)
				end
			else
				arg_19_0:handle_transition("ingame_menu")
			end
		end

		if not arg_19_0:pending_transition() then
			local var_19_24 = Managers.player:local_player()
			local var_19_25 = var_19_24 and var_19_24.player_unit

			if var_19_25 and Unit.alive(var_19_25) then
				local var_19_26 = arg_19_4 ~= nil
				local var_19_27 = var_19_1 and not arg_19_3 and not var_19_26

				arg_19_0:handle_menu_hotkeys(arg_19_1, var_19_2, var_19_27, arg_19_0.menu_active)
			end
		end

		for iter_19_0, iter_19_1 in pairs(arg_19_0.popups_by_name) do
			iter_19_1.popup:update(arg_19_1, arg_19_2)
		end

		var_19_5:update(arg_19_1, arg_19_2)

		if arg_19_0.help_screen then
			arg_19_0.help_screen:update(arg_19_1)
		end
	end

	if Managers.state.network:game() then
		arg_19_0.ingame_hud:update(arg_19_1, arg_19_2)
	end

	arg_19_0:_update_menu_blocking_information(arg_19_1, arg_19_2, var_19_2, arg_19_4)
	arg_19_0:_render_debug_ui(arg_19_1, arg_19_2)
	arg_19_0:_update_fade_transition()

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_4, arg_19_0)
	end
end

IngameUI.disable_ingame_ui = function (arg_20_0)
	return arg_20_0._disable_ingame_ui
end

IngameUI._holly_dlc_intro_closed = function (arg_21_0)
	PlayerData.viewed_dialogues.dlc_holly = true

	Managers.save:auto_save(SaveFileName, SaveData)
end

IngameUI.post_update = function (arg_22_0, arg_22_1, arg_22_2)
	arg_22_0:_post_handle_transition()

	local var_22_0 = arg_22_0.current_view

	if var_22_0 then
		local var_22_1 = arg_22_0.views

		if var_22_1[var_22_0].post_update then
			var_22_1[var_22_0]:post_update(arg_22_1, arg_22_2)
		end
	end

	arg_22_0.ingame_hud:post_update(arg_22_1, arg_22_2)
end

IngameUI.cutscene_active = function (arg_23_0)
	return arg_23_0.cutscene_system.active_camera ~= nil
end

IngameUI._survey_update = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.views.telemetry_survey

	var_24_0:update(arg_24_1)

	if var_24_0:is_survey_answered() or var_24_0:is_survey_timed_out() then
		arg_24_0.survey_active = false

		var_24_0:on_exit()
	end
end

IngameUI._handle_resolution_changes = function (arg_25_0)
	local var_25_0 = RESOLUTION_LOOKUP.res_w
	local var_25_1 = RESOLUTION_LOOKUP.res_h

	if var_25_0 ~= arg_25_0.last_resolution_x or var_25_1 ~= arg_25_0.last_resolution_y then
		arg_25_0.last_resolution_x, arg_25_0.last_resolution_y = var_25_0, var_25_1
	end
end

IngameUI._update_menu_blocking_information = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0, var_26_1, var_26_2 = arg_26_0:_menu_blocking_information(arg_26_3, arg_26_4)

	Managers.chat:update(arg_26_1, arg_26_2, var_26_0, var_26_1, var_26_2)

	if IS_WINDOWS and var_26_0 ~= arg_26_0._was_in_view then
		arg_26_0._was_in_view = var_26_0

		Application.set_in_menu(var_26_0)
	end
end

IngameUI._menu_blocking_information = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0.ingame_hud
	local var_27_1 = var_27_0:component("IngamePlayerListUI") or var_27_0:component("VersusTabUI")
	local var_27_2 = var_27_1 and var_27_1:is_focused()
	local var_27_3 = var_27_0:component("GiftPopupUI")
	local var_27_4 = var_27_3 and var_27_3:active()
	local var_27_5 = arg_27_0:end_screen_active()
	local var_27_6 = var_27_0:component("MissionVotingUI")
	local var_27_7 = var_27_6 and var_27_6:is_active()
	local var_27_8 = arg_27_0.cutscene_system
	local var_27_9 = arg_27_0:get_active_popup("profile_picker")
	local var_27_10 = arg_27_0.menu_active or arg_27_2 and arg_27_2:enable_chat() or arg_27_0.current_view ~= nil and not arg_27_0.views[arg_27_0.current_view].normal_chat
	local var_27_11 = var_27_8.active_camera and not var_27_8.ingame_hud_enabled

	if arg_27_0.current_view then
		local var_27_12 = arg_27_0.views[arg_27_0.current_view]:input_service()

		return var_27_10, var_27_12, false
	elseif var_27_7 then
		local var_27_13 = var_27_6:active_input_service()

		return var_27_10, var_27_13, false
	elseif arg_27_2 then
		local var_27_14 = arg_27_2:active_input_service()

		return var_27_10, var_27_14, false
	elseif var_27_4 then
		local var_27_15 = var_27_3:active_input_service()

		return var_27_10, var_27_15, false
	elseif var_27_9 then
		local var_27_16 = var_27_9:input_service()

		return var_27_10, var_27_16, false
	elseif var_27_2 then
		local var_27_17 = var_27_1:input_service()

		return var_27_10, var_27_17, false
	elseif arg_27_0.menu_active then
		return var_27_10, arg_27_1, false
	elseif var_27_11 then
		local var_27_18 = var_27_0:component("CutsceneUI"):input_service()

		return var_27_10, var_27_18, false
	elseif var_27_5 then
		local var_27_19 = arg_27_0.end_screen:input_service()

		return var_27_10, var_27_19, false
	else
		return var_27_10, nil, false
	end
end

IngameUI._render_debug_ui = function (arg_28_0, arg_28_1, arg_28_2)
	if not script_data.disable_debug_draw then
		local var_28_0 = script_data.disable_colorize_unlocalized_strings

		script_data.disable_colorize_unlocalized_strings = true

		if arg_28_0.menu_active and GameSettingsDevelopment.show_version_info and not script_data.hide_version_info then
			arg_28_0:_render_version_info()
		end

		if GameSettingsDevelopment.show_fps and not script_data.hide_fps then
			arg_28_0:_render_fps(arg_28_1)
		end

		script_data.disable_colorize_unlocalized_strings = var_28_0
	end
end

IngameUI.show_info = function (arg_29_0)
	local var_29_0 = Managers.state.entity:system("mission_system")
	local var_29_1 = var_29_0:get_level_end_mission_data("grimoire_hidden_mission")
	local var_29_2 = var_29_0:get_level_end_mission_data("tome_bonus_mission")
	local var_29_3, var_29_4 = Application.resolution()
	local var_29_5 = Vector3(100, var_29_4 - 100, 999)
	local var_29_6 = arg_29_0:_show_text(var_29_1 and var_29_1.current_amount or "", var_29_5)
	local var_29_7 = arg_29_0:_show_text(var_29_2 and var_29_2.current_amount or "", var_29_6)
end

IngameUI._show_text = function (arg_30_0, arg_30_1, arg_30_2)
	Gui.text(arg_30_0.ui_renderer.gui, "text", "materials/fonts/gw_head", 20, "gw_head", arg_30_2, Color(0, 255, 0))

	return Vector3(arg_30_2[1], arg_30_2[2] - 30, arg_30_2[3])
end

IngameUI._update_system_message_cooldown = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.system_message_delay

	if var_31_0 then
		local var_31_1 = var_31_0 - arg_31_1

		arg_31_0.system_message_delay = var_31_1 > 0 and var_31_1 or nil
	end
end

IngameUI.add_local_system_message = function (arg_32_0, arg_32_1)
	if not arg_32_0.system_message_delay or arg_32_0.last_sent_system_message ~= arg_32_1 then
		local var_32_0 = true
		local var_32_1 = Localize(arg_32_1)

		if IS_WINDOWS then
			Managers.chat:add_local_system_message(1, var_32_1, var_32_0)
		else
			local var_32_2 = Managers.player:local_player():stats_id()

			Managers.state.event:trigger("add_personal_interaction_warning", var_32_2 .. arg_32_1, arg_32_1)
		end

		arg_32_0.last_sent_system_message = arg_32_1
		arg_32_0.system_message_delay = 1.5
	end
end

IngameUI.is_transition_allowed = function (arg_33_0, arg_33_1)
	local var_33_0
	local var_33_1 = true

	if arg_33_0:is_local_player_ready_for_game() then
		if arg_33_1 == "profile_view" then
			var_33_0 = "matchmaking_ready_interaction_message_profile_view"
			var_33_1 = false
		elseif arg_33_1 == "inventory_view_force" then
			var_33_0 = "matchmaking_ready_interaction_message_inventory"
			var_33_1 = false
		end
	end

	if var_33_0 then
		arg_33_0:add_local_system_message(var_33_0)
	end

	return var_33_1
end

IngameUI._post_handle_transition = function (arg_34_0)
	if not arg_34_0.new_transition then
		return
	end

	local var_34_0 = arg_34_0.transition_params
	local var_34_1 = arg_34_0.views[arg_34_0.new_transition_old_view]

	if var_34_1 and var_34_1.post_update_on_exit then
		printf("[IngameUI] menu view post_update_on_exit %s", var_34_1)
		var_34_1:post_update_on_exit(var_34_0, arg_34_0.new_transition_old_view == arg_34_0.current_view)
	end

	local var_34_2 = arg_34_0.views[arg_34_0.current_view]

	if var_34_2 and var_34_2.post_update_on_enter then
		printf("[IngameUI] menu view post_update_on_enter %s", var_34_2)
		var_34_2:post_update_on_enter(var_34_0)
	end

	if script_data.debug_enabled then
		arg_34_0.last_transition_params = arg_34_0.transition_params
		arg_34_0.last_transition_name = arg_34_0.new_transition
	end

	arg_34_0.new_transition_old_view = nil
	arg_34_0.new_transition = nil
end

IngameUI.handle_transition = function (arg_35_0, arg_35_1, arg_35_2)
	fassert(var_0_3[arg_35_1], "Missing transition to %s", arg_35_1)

	local var_35_0 = arg_35_0.blocked_transitions

	if var_35_0 and var_35_0[arg_35_1] then
		return
	end

	local var_35_1 = arg_35_0._previous_transition

	if not arg_35_0:is_transition_allowed(arg_35_1) or var_35_1 and var_35_1 == arg_35_1 then
		return
	end

	if arg_35_0.new_transition_old_view then
		return
	end

	arg_35_2 = arg_35_2 or {}

	local var_35_2 = arg_35_0.current_view

	var_0_3[arg_35_1](arg_35_0, arg_35_2)

	local var_35_3 = arg_35_0.current_view
	local var_35_4 = arg_35_2.force_open

	if var_35_2 ~= var_35_3 or var_35_4 then
		if arg_35_0.views[var_35_2] then
			if arg_35_0.views[var_35_2].on_exit then
				printf("[IngameUI] menu view on_exit %s", var_35_2)
				arg_35_0.views[var_35_2]:on_exit(arg_35_2)

				arg_35_0.views[var_35_2].exit_to_game = nil
			end

			local var_35_5 = arg_35_0.transition_params
			local var_35_6 = var_35_5 and var_35_5.on_exit_callback

			if var_35_6 then
				var_35_6()
			end
		end

		if var_35_3 and arg_35_0.views[var_35_3] and arg_35_0.views[var_35_3].on_enter then
			printf("[IngameUI] menu view on_enter %s", var_35_3)
			arg_35_0.views[var_35_3]:on_enter(arg_35_2)
		end

		arg_35_0.new_transition = arg_35_1
		arg_35_0.new_transition_old_view = var_35_2
		arg_35_0.transition_params = arg_35_2
		arg_35_0._previous_transition = arg_35_1
	end
end

IngameUI.transition_with_fade = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	local var_36_0 = arg_36_0.blocked_transitions

	if var_36_0 and var_36_0[arg_36_1] then
		return
	end

	local var_36_1 = arg_36_0._previous_transition

	if not arg_36_0:is_transition_allowed(arg_36_1) or var_36_1 and var_36_1 == arg_36_1 then
		return
	end

	arg_36_0._transition_fade_data = {
		new_transition = arg_36_1,
		transition_params = arg_36_2,
		fade_out_speed = arg_36_4
	}

	Managers.transition:fade_in(arg_36_3 or 10)
end

IngameUI._update_fade_transition = function (arg_37_0)
	local var_37_0 = arg_37_0._transition_fade_data

	if not var_37_0 then
		return
	end

	if Managers.transition:fade_in_completed() then
		local var_37_1 = var_37_0.new_transition
		local var_37_2 = var_37_0.transition_params

		arg_37_0:handle_transition(var_37_1, var_37_2)

		local var_37_3 = arg_37_0._transition_fade_data.fade_out_speed

		arg_37_0._transition_fade_data = nil

		Managers.transition:fade_out(var_37_3 or 10)
	end
end

IngameUI.pending_transition = function (arg_38_0)
	return arg_38_0._transition_fade_data ~= nil or arg_38_0.new_transition_old_view ~= nil
end

IngameUI.get_transition = function (arg_39_0)
	if arg_39_0.leave_game then
		if Managers.play_go:installed() then
			return "leave_game"
		else
			return "finish_tutorial"
		end
	elseif arg_39_0.return_to_pc_menu then
		return "return_to_pc_menu"
	elseif arg_39_0.return_to_title_screen then
		return "return_to_title_screen"
	elseif arg_39_0.return_to_demo_title_screen then
		return "return_to_demo_title_screen"
	elseif arg_39_0.restart_demo then
		return "restart_demo"
	elseif arg_39_0.join_lobby then
		return "join_lobby", arg_39_0.join_lobby
	elseif arg_39_0.restart_game then
		return "restart_game"
	elseif arg_39_0.quit_game then
		return "quit_game"
	end
end

IngameUI.suspend_active_view = function (arg_40_0)
	local var_40_0 = arg_40_0.current_view

	if var_40_0 and var_40_0 ~= "exit_menu" and arg_40_0.views[var_40_0] then
		arg_40_0:handle_transition("exit_menu")
	end
end

IngameUI.activate_end_screen_ui = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	arg_41_0.end_screen:on_enter(arg_41_1, arg_41_2, arg_41_3)
end

IngameUI.deactivate_end_screen_ui = function (arg_42_0)
	local var_42_0 = arg_42_0.end_screen

	if var_42_0.is_active then
		var_42_0:on_exit()
	end
end

IngameUI.end_screen_active = function (arg_43_0)
	local var_43_0 = arg_43_0.end_screen

	return var_43_0 and var_43_0.is_active
end

IngameUI.end_screen_completed = function (arg_44_0)
	local var_44_0 = arg_44_0.end_screen

	return var_44_0 and var_44_0.is_complete
end

IngameUI.end_screen_fade_in_complete = function (arg_45_0)
	local var_45_0 = arg_45_0.end_screen

	return var_45_0 and var_45_0:fade_in_complete()
end

IngameUI.update_map_enable_state = function (arg_46_0)
	if arg_46_0.is_in_inn then
		local var_46_0 = arg_46_0.views.map_view

		if var_46_0 then
			local var_46_1 = var_46_0.map_interaction_enabled
			local var_46_2 = Managers.matchmaking:is_game_matchmaking()

			if var_46_1 and var_46_2 then
				var_46_0:set_map_interaction_state(false)
			elseif not var_46_1 and not var_46_2 then
				var_46_0:set_map_interaction_state(true)
			end
		end
	end
end

IngameUI.play_sound = function (arg_47_0, arg_47_1)
	WwiseWorld.trigger_event(arg_47_0.wwise_world, arg_47_1)
end

local var_0_6 = "arial"
local var_0_7 = "materials/fonts/" .. var_0_6
local var_0_8 = {}
local var_0_9 = Colors.color_definitions.white
local var_0_10 = Colors.color_definitions.black
local var_0_11 = Colors.color_definitions.red

IngameUI._render_version_info = function (arg_48_0)
	local var_48_0 = arg_48_0.ui_top_renderer
	local var_48_1 = 1920
	local var_48_2 = 1080
	local var_48_3 = 18
	local var_48_4 = script_data.build_identifier or "???"
	local var_48_5 = script_data.settings.content_revision or "???"
	local var_48_6 = tostring(Application.make_hash(var_48_4, var_48_5)):sub(1, 4):upper()

	if var_48_4 == "???" and var_48_5 == "???" then
		var_48_6 = "???"
	end

	local var_48_7 = "GAME HASH: " .. var_48_6 .. " | Content revision: " .. var_48_5 .. " | Engine version: " .. var_48_4:sub(1, 6) .. "..."

	if rawget(_G, "Steam") then
		local var_48_8 = Steam.app_id()

		var_48_7 = var_48_7 .. " Appid: " .. var_48_8
	end

	local var_48_9, var_48_10 = UIRenderer.text_size(var_48_0, var_48_7, var_0_7, var_48_3)
	local var_48_11 = var_48_1 - var_48_9 - 8
	local var_48_12 = var_48_10

	var_0_8[1] = var_48_11
	var_0_8[2] = var_48_12
	var_0_8[3] = 899

	UIRenderer.draw_text(var_48_0, var_48_7, var_0_7, var_48_3, var_0_6, Vector3(unpack(var_0_8)), var_0_9)

	var_0_8[1] = var_48_11 + 2
	var_0_8[2] = var_48_12 - 2
	var_0_8[3] = 898

	UIRenderer.draw_text(var_48_0, var_48_7, var_0_7, var_48_3, var_0_6, Vector3(unpack(var_0_8)), var_0_10)
end

IngameUI._render_fps = function (arg_49_0, arg_49_1)
	arg_49_0._fpses = arg_49_0._fpses or {}

	local var_49_0 = arg_49_0.ui_top_renderer

	arg_49_0._fpses[#arg_49_0._fpses + 1] = arg_49_1
	arg_49_0._fps_cooldown = arg_49_0._fps_cooldown + arg_49_1

	if arg_49_0._fps_cooldown > 1 then
		local var_49_1 = arg_49_0._fpses
		local var_49_2 = #arg_49_0._fpses
		local var_49_3 = 0

		for iter_49_0, iter_49_1 in pairs(arg_49_0._fpses) do
			var_49_3 = var_49_3 + iter_49_1
		end

		local var_49_4 = var_49_3 / var_49_2

		arg_49_0.mean_dt = var_49_4
		arg_49_0.fps = math.floor(1 / var_49_4 + 0.5)

		table.clear(arg_49_0._fpses)

		arg_49_0._fps_cooldown = arg_49_0._fps_cooldown - 1
	end

	local var_49_5 = arg_49_0.fps
	local var_49_6 = arg_49_0.mean_dt
	local var_49_7 = string.format("%.2fms  %i FPS", var_49_6 * 1000, var_49_5)
	local var_49_8
	local var_49_9 = 30

	if IS_CONSOLE then
		var_49_9 = 28
	end

	if var_49_5 < var_49_9 then
		var_49_8 = var_0_11
	else
		var_49_8 = var_0_9
	end

	local var_49_10 = RESOLUTION_LOOKUP.res_w
	local var_49_11 = RESOLUTION_LOOKUP.res_h
	local var_49_12 = 24
	local var_49_13 = RESOLUTION_LOOKUP.inv_scale
	local var_49_14, var_49_15 = UIRenderer.text_size(var_49_0, var_49_7, var_0_7, var_49_12 * RESOLUTION_LOOKUP.scale)
	local var_49_16 = (var_49_10 - var_49_14 - 8) * var_49_13
	local var_49_17 = (var_49_15 + 16) * var_49_13

	var_0_8[1] = var_49_16
	var_0_8[2] = var_49_17
	var_0_8[3] = 899

	UIRenderer.draw_text(var_49_0, var_49_7, var_0_7, var_49_12, var_0_6, Vector3(unpack(var_0_8)), var_49_8)

	var_0_8[1] = var_49_16 + 2
	var_0_8[2] = var_49_17 - 2
	var_0_8[3] = 898

	UIRenderer.draw_text(var_49_0, var_49_7, var_0_7, var_49_12, var_0_6, Vector3(unpack(var_0_8)), var_0_10)

	local var_49_18 = Managers.state.camera

	if var_49_18 then
		local var_49_19 = Managers.player:local_player(1)
		local var_49_20 = var_49_19 and var_49_19.viewport_name

		if var_49_20 then
			local var_49_21 = var_49_18:camera_position(var_49_20)
			local var_49_22 = var_49_18:camera_rotation(var_49_20)
			local var_49_23 = 18
			local var_49_24 = string.format("Position(%.2f, %.2f, %.2f) Rotation(%.4f, %.4f, %.4f, %.4f)", var_49_21.x, var_49_21.y, var_49_21.z, Quaternion.to_elements(var_49_22))

			UIRenderer.draw_text(var_49_0, var_49_24, var_0_7, var_49_23, var_0_6, Vector3(11, 11, 1), var_49_8)
			UIRenderer.draw_text(var_49_0, var_49_24, var_0_7, var_49_23, var_0_6, Vector3(10, 10, 0), var_0_10)
		end
	end

	local var_49_25, var_49_26 = Application.resolution()
	local var_49_27 = string.format("Resolution W:%i H:%i", var_49_25, var_49_26)

	UIRenderer.draw_text(var_49_0, var_49_27, var_0_7, 18, var_0_6, Vector3(11, 31, 1), var_49_8)
	UIRenderer.draw_text(var_49_0, var_49_27, var_0_7, 18, var_0_6, Vector3(10, 30, 0), var_0_10)

	if LobbyInternal.SESSION_NAME then
		UIRenderer.draw_text(var_49_0, "My server name:", var_0_7, 20, var_0_6, Vector3(20, 40, 999))
		UIRenderer.draw_text(var_49_0, "My server name:", var_0_7, 20, var_0_6, Vector3(22, 38, 998), var_0_10)
		UIRenderer.draw_text(var_49_0, LobbyInternal.SESSION_NAME, var_0_7, 20, var_0_6, Vector3(20, 20, 999))
		UIRenderer.draw_text(var_49_0, LobbyInternal.SESSION_NAME, var_0_7, 20, var_0_6, Vector3(22, 18, 998), var_0_10)
	end
end

IngameUI.open_popup = function (arg_50_0, arg_50_1, ...)
	local var_50_0 = arg_50_0.popups_by_name

	fassert(var_50_0[arg_50_1] == nil, "Trying to open a popup %q that is already active", arg_50_1)

	local var_50_1 = PopupSettingsByName[arg_50_1]
	local var_50_2 = rawget(_G, var_50_1.class):new(arg_50_0.ingame_ui_context, ...)

	var_50_0[arg_50_1] = {
		settings = var_50_1,
		popup = var_50_2
	}
end

IngameUI.close_popup = function (arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0.popups_by_name
	local var_51_1 = var_51_0[arg_51_1]

	fassert(var_51_1 ~= nil, "Trying to close a popup %q that is not active", arg_51_1)

	local var_51_2 = var_51_1.popup

	var_51_2:hide()
	var_51_2:delete()

	var_51_0[arg_51_1] = nil
end

IngameUI.get_active_popup = function (arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.popups_by_name[arg_52_1]

	return var_52_0 and var_52_0.popup
end

IngameUI.respawn = function (arg_53_0)
	if not Managers.state.network:game() then
		return
	end

	local var_53_0 = arg_53_0.peer_id
	local var_53_1 = arg_53_0.local_player_id
	local var_53_2, var_53_3 = arg_53_0.profile_synchronizer:profile_by_peer(var_53_0, var_53_1)
	local var_53_4, var_53_5 = hero_and_career_name_from_index(var_53_2, var_53_3)
	local var_53_6 = true

	arg_53_0._profile_requester:request_profile(var_53_0, var_53_1, var_53_4, var_53_5, var_53_6)

	arg_53_0._respawning = true
end

IngameUI._update_respawning = function (arg_54_0)
	if arg_54_0._profile_requester:result() ~= nil then
		return true
	end

	return false
end

IngameUI._cancel_popup = function (arg_55_0)
	if arg_55_0.popup_id then
		Managers.popup:cancel_popup(arg_55_0.popup_id)
	end
end

IngameUI.get_hud_component = function (arg_56_0, arg_56_1)
	return arg_56_0.ingame_hud:get_hud_component(arg_56_1)
end
