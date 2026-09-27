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
DLCUtils.map_list("ui_views", function (self)
	-- function 1
	local file = self.file

	if not file then
		dofile(file)
	end
end)

for k, v in pairs(PopupSettings) do
	if not v.file then
		require(v.file)
	end
end

local tbl = {}
local scripts_ui_views_ingame_ui_settings = require("scripts/ui/views/ingame_ui_settings")
local view_settings = scripts_ui_views_ingame_ui_settings.view_settings
local transitions = scripts_ui_views_ingame_ui_settings.transitions
local testify = script_data.testify

testify = not testify and require("scripts/ui/views/ingame_ui_testify")
IngameUI = class(IngameUI)

IngameUI.init = function (self, arg_2_1)
	-- function 2
	printf("[IngameUI] init")

	self.unlock_manager = Managers.unlock
	self.world_manager = arg_2_1.world_manager
	self.camera_manager = arg_2_1.camera_manager
	self.is_in_inn = arg_2_1.is_in_inn

	local world = Managers.world:world("level_world")
	local world_2 = Managers.world:world("top_ingame_view")
	local wwise_world = Managers.world:wwise_world(world)

	self.wwise_world = wwise_world
	self.world = world
	self.top_world = world_2

	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local flag = game_mode_key == "tutorial"
	local is_in_inn = self.is_in_inn

	self.ui_renderer = self:create_ui_renderer(world, flag, is_in_inn, current_mechanism_name)
	self.ui_top_renderer = self:create_ui_renderer(world_2, flag, is_in_inn, current_mechanism_name)
	self.blocked_transitions = view_settings.blocked_transitions
	self.fps = 0
	self.mean_dt = 0
	self._fps_cooldown = 0

	UISetupFontHeights(self.ui_renderer.gui)

	local input_manager = arg_2_1.input_manager

	self.input_manager = input_manager

	input_manager:create_input_service("ingame_menu", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("ingame_menu", "keyboard")
	input_manager:map_device_to_service("ingame_menu", "mouse")
	input_manager:map_device_to_service("ingame_menu", "gamepad")

	arg_2_1.ui_renderer = self.ui_renderer
	arg_2_1.ui_top_renderer = self.ui_top_renderer
	arg_2_1.ingame_ui = self
	arg_2_1.wwise_world = wwise_world
	self.profile_synchronizer = arg_2_1.profile_synchronizer
	self.peer_id = arg_2_1.peer_id
	self.local_player_id = arg_2_1.local_player_id
	self._player = arg_2_1.player
	self.is_server = arg_2_1.is_server
	self.ingame_hud = IngameHud:new(self, arg_2_1)
	self.popups_by_name = {}
	self.last_resolution_x, self.last_resolution_y = Application.resolution()

	self:setup_views(arg_2_1)

	self.end_screen = EndScreenUI:new(arg_2_1)
	self.weave_onboarding = WeaveUIOnboardingTutorial:new(arg_2_1)
	self.popup_handler = CommonPopupHandler:new(arg_2_1)
	self.text_popup_ui = TextPopupUI:new(arg_2_1)
	self.hint_ui_handler = HintUIHandler:new(arg_2_1)

	if not GameSettingsDevelopment.help_screen_enabled then
		self.help_screen = HelpScreenUI:new(arg_2_1)
	end

	self.cutscene_system = Managers.state.entity:system("cutscene_system")

	self:register_rpcs(arg_2_1.network_event_delegate)
	GarbageLeakDetector.register_object(self, "IngameUI")

	if (self.is_server or not self.is_in_inn) and not self.views.map_view then
		self.views.map_view:set_map_interaction_state(false)
	end

	Managers.chat:set_profile_synchronizer(arg_2_1.profile_synchronizer)
	Managers.chat:set_wwise_world(wwise_world)
	Managers.chat:set_input_manager(input_manager)

	local network_server = arg_2_1.network_server

	network_server = network_server or arg_2_1.network_client
	self._profile_requester = network_server:profile_requester()
	self.telemetry_time_view_enter = 0
	self.ingame_ui_context = arg_2_1
end

IngameUI.create_ui_renderer = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	return view_settings.ui_renderer_function(arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end

IngameUI.setup_views = function (self, arg_4_1)
	-- function 4
	self.views = view_settings.views_function(arg_4_1)
	self.hotkey_mapping = view_settings.hotkey_mapping
end

IngameUI.setup_specific_view = function (self, arg_5_1, arg_5_2)
	-- function 5
	printf("[IngameUI] setup_specific_view %s", arg_5_2)

	local var_5_0 = rawget(_G, arg_5_2)

	if not self.views[arg_5_1] and not self.views[arg_5_1].destroy then
		self.views[arg_5_1]:destroy()
		printf("[IngameUI] setup_specific_view destroy %s", arg_5_2)
	end

	self.views[arg_5_1] = var_5_0:new(self.ingame_ui_context)
end

IngameUI.is_local_player_ready_for_game = function (self)
	-- function 6
	if not self.is_in_inn then
		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not flag then
			return ScriptUnit.extension(flag, "status_system"):is_in_end_zone()
		end
	end
end

IngameUI.can_view_lobby_browser = function (self)
	-- function 7
	local is_server = self.is_server
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()

	return not is_server and not is_game_matchmaking
end

local script_data = script_data
local lorebook_enabled = script_data.lorebook_enabled

lorebook_enabled = lorebook_enabled or Development.parameter("lorebook_enabled")
script_data.lorebook_enabled = lorebook_enabled

IngameUI.is_lorebook_enabled = function (arg_8_0)
	-- function 8
	if not script_data.lorebook_enabled then
		return false
	end

	return true
end

IngameUI.register_rpcs = function (self, arg_9_1)
	-- function 9
	self.network_event_delegate = arg_9_1

	arg_9_1:register(self, unpack(tbl))
end

IngameUI.unregister_rpcs = function (self)
	-- function 10
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

IngameUI.is_in_view_state = function (self, arg_11_1)
	-- function 11
	if not self.current_view then
		return false
	end

	local var_11_0 = self.views[self.current_view]
	local current_state = var_11_0.current_state

	current_state = not current_state and var_11_0:current_state()

	if not current_state then
		return false
	end

	return current_state.NAME == arg_11_1
end

IngameUI.destroy = function (self)
	-- function 12
	self:unregister_rpcs()
	Managers.chat:set_profile_synchronizer(nil)
	Managers.chat:set_wwise_world(nil)
	Managers.chat:set_input_manager(nil)

	local current_view = self.current_view

	if self.menu_active or not current_view then
		-- Nothing
	end

	if not current_view then
		local tbl = {}

		self.views[current_view]:on_exit(tbl)

		self.current_view = nil
	end

	for k, v in pairs(self.views) do
		if not v.destroy then
			v:destroy()
		end
	end

	self.end_screen:destroy()

	self.end_screen = nil

	self.ingame_hud:destroy()

	self.ingame_hud = nil

	if not self.help_screen then
		self.help_screen:destroy()

		self.help_screen = nil
	end

	local popups_by_name = self.popups_by_name

	for k_2, v_2 in pairs(self.popups_by_name) do
		local popup = v_2.popup

		popup:hide()
		popup:delete()

		popups_by_name[k_2] = nil
	end

	self.text_popup_ui:destroy()

	self.text_popup_ui = nil

	if not self.popup_id then
		Managers.popup:cancel_popup(self.popup_id)
	end

	if not self.weave_onboarding then
		self.weave_onboarding:destroy()

		self.weave_onboarding = nil
	end

	if not self.popup_handler then
		self.popup_handler:destroy()

		self.popup_handler = nil
	end

	if not self.hint_ui_handler then
		self.hint_ui_handler:destroy()

		self.hint_ui_handler = nil
	end

	UIRenderer.destroy(self.ui_renderer, self.world)
	UIRenderer.destroy(self.ui_top_renderer, self.top_world)

	self.ui_renderer = nil
	self.ui_top_renderer = nil

	printf("[IngameUI] destroy")
end

IngameUI.weaves_requirements_fulfilled = function (arg_13_0)
	-- function 13
	if Managers.mechanism:current_mechanism_name() ~= "adventure" then
		return false
	end

	if not script_data.unlock_all_levels then
		return true
	end

	local twitch = Managers.twitch

	if not twitch then
		twitch = Managers.twitch:is_connected()
		twitch = twitch or Managers.twitch:is_activated()
	end

	if not twitch then
		Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.twitch_not_supported_for_weaves)

		return false
	elseif not (Managers.player.is_server or Managers.state.network:lobby():lobby_data("twitch_enabled") ~= "true") then
		Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.twitch_not_supported_for_weaves_client)

		return false
	end

	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:local_player():stats_id()

	for k, v in pairs(HelmgartLevels) do
		if not (LevelSettings[v].mechanism ~= "adventure" or not (statistics_db:get_persistent_stat(stats_id, "completed_levels", v) < 1)) then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.requirements_not_met)

			return false
		end
	end

	local act_scorpion = GameActs.act_scorpion

	for k_2, v_2 in pairs(act_scorpion) do
		if not (LevelSettings[v_2].mechanism ~= "adventure" or not (statistics_db:get_persistent_stat(stats_id, "completed_levels", v_2) < 1)) then
			Managers.state.event:trigger("weave_tutorial_message", WeaveUITutorials.requirements_not_met)

			return false
		end
	end

	return true
end

IngameUI._handle_versus_matchmaking = function (self)
	-- function 14
	local matchmaking = Managers.matchmaking

	if not matchmaking:is_matchmaking_versus() then
		return true
	end

	if not matchmaking:is_in_versus_custom_game_lobby() then
		return true
	end

	self:add_local_system_message("matchmaking_ready_interaction_message_map")

	return false
end

IngameUI.can_open_loot = function (arg_15_0)
	-- function 15
	return not GameSettingsDevelopment.read_only_backend
end

local tbl_2 = {
	"hotkey_map"
}

IngameUI.handle_menu_hotkeys = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	if not arg_16_3 then
		return
	end

	local views = self.views
	local current_view = self.current_view
	local hotkey_mapping = self.hotkey_mapping
	local local_player = Managers.player:local_player()

	if not (not local_player and local_player.player_unit ~= nil) then
		return
	end

	local is_local_player_ready_for_game = self:is_local_player_ready_for_game()
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local voting = Managers.state.voting
	local vote_in_progress = voting:vote_in_progress()

	vote_in_progress = not vote_in_progress and voting:is_mission_vote()

	for k, v in pairs(hotkey_mapping) do
		if not current_view then
			if not (current_view == v.view) then
				local var_16_8 = views[current_view]
				local input_service = var_16_8:input_service()

				if var_16_8:transitioning() or not input_service:get(k) then
					local transition_params = self.transition_params
					local flag = not transition_params and transition_params.menu_state_name
					local flag_2 = not transition_params and transition_params.menu_sub_state_name
					local flag_3 = flag == v.transition_state
					local flag_4 = flag_2 == v.transition_sub_state
					local flag_5 = not transition_params and transition_params.ignore_sub_state_on_exit

					if not flag_3 and flag_4 and not flag_3 or not flag_5 then
						local hotkey_allowed = var_16_8.hotkey_allowed

						hotkey_allowed = not hotkey_allowed and var_16_8:hotkey_allowed(k, v)

						if not (hotkey_allowed ~= false) then
							local flag_6 = not arg_16_4

							views[current_view]:exit(flag_6)

							break
						end
					end
				end
			end
		else
			local var_16_18
			local var_16_19
			local var_16_20
			local current_mechanism_name = Managers.mechanism:current_mechanism_name()
			local disable_for_mechanism = v.disable_for_mechanism

			disable_for_mechanism = not disable_for_mechanism and v.disable_for_mechanism[current_mechanism_name]

			if not disable_for_mechanism then
				var_16_18 = disable_for_mechanism.matchmaking
				var_16_19 = disable_for_mechanism.matchmaking_ready
				var_16_20 = disable_for_mechanism.not_matchmaking
			end

			local contains = table.contains(tbl_2, k)
			local flag_7 = not is_local_player_ready_for_game and var_16_19 and not is_game_matchmaking or var_16_18 and not contains and vote_in_progress

			flag_7 = flag_7 or var_16_20

			local var_16_25 = views[v.view]
			local can_interact_flag = v.can_interact_flag
			local can_interact_func = v.can_interact_func
			local required_dlc = v.required_dlc

			if not arg_16_2:get(k) then
				local flag_8 = true

				if not (not can_interact_flag and var_16_25[can_interact_flag]) then
					flag_8 = false
				end

				if not (not flag_8 and not can_interact_func and self[can_interact_func](self)) then
					flag_8 = false
				end

				if not (not flag_8 and not required_dlc and Managers.unlock:is_dlc_unlocked(required_dlc)) then
					flag_8 = false
				end

				if not flag_8 then
					if not flag_7 then
						local error_message = v.error_message

						if not error_message then
							self:add_local_system_message(error_message)
						end

						break
					end

					local in_transition_menu

					if not arg_16_4 then
						in_transition_menu = v.in_transition_menu

						if not in_transition_menu then
							-- Nothing
						end
					end

					in_transition_menu = v.in_transition

					::label_16_0::

					local tbl = {
						menu_state_name = v.transition_state,
						menu_sub_state_name = v.transition_sub_state
					}
					local inject_transition_params_func = v.inject_transition_params_func

					if not inject_transition_params_func then
						inject_transition_params_func(tbl)
					end

					self:transition_with_fade(in_transition_menu, tbl)

					break
				end
			end
		end
	end
end

IngameUI.event_dlc_status_changed = function (self)
	-- function 17
	if self.current_view == "map_view" then
		self:handle_transition("exit_menu")
	end

	self:setup_specific_view("map_view", "ConsoleMapView")
end

IngameUI.update_loading_subtitle_gui = function (self, arg_18_1, arg_18_2)
	-- function 18
	arg_18_1:update(self.ui_top_renderer, arg_18_2)
end

IngameUI.update = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	self._disable_ingame_ui = arg_19_3

	self:_update_fade_transition()

	local views = self.views
	local is_in_inn = self.is_in_inn
	local get_service = self.input_manager:get_service("ingame_menu")
	local ingame_hud = self.ingame_hud
	local transition = Managers.transition
	local end_screen = self.end_screen

	self:_update_system_message_cooldown(arg_19_1)
	self:_handle_resolution_changes()

	if not self.is_server then
		self:update_map_enable_state()
	end

	if not self._respawning and not self:_update_respawning() then
		self._respawning = nil
	end

	if not self.popup_id then
		local query_result = Managers.popup:query_result(self.popup_id)

		if not query_result then
			self:handle_transition(query_result)
		end
	end

	if not self.survey_active then
		self:_survey_update(arg_19_1)
	end

	if not (not self.quit_game_retry and not (arg_19_2 >= self.delay_quit_game_retry)) then
		self.quit_game_retry = nil

		self:handle_transition("end_game")
	end

	if not self.hint_ui_handler then
		self.hint_ui_handler:update(arg_19_1, arg_19_2)
	end

	if not is_in_inn then
		local has_left_menu = self.has_left_menu

		has_left_menu = not has_left_menu and self.hud_visible

		self.text_popup_ui:update(arg_19_1)

		if not has_left_menu and self.text_popup_ui.is_visible and PlayerData.viewed_dialogues.dlc_holly or not Managers.unlock:is_dlc_unlocked("holly") then
			local var_19_8 = callback(self, "_holly_dlc_intro_closed")

			self.text_popup_ui:show("area_selection_holly_name", "holly_lohner_spiel_short", var_19_8)
		end

		if not self.weave_onboarding then
			self.weave_onboarding:update(arg_19_1, arg_19_2)
		end

		if not self.popup_handler then
			self.popup_handler:update(arg_19_1, arg_19_2)
		end
	end

	if not arg_19_3 then
		local flag = false

		if not self.current_view then
			local current_view = self.current_view

			views[current_view]:update(arg_19_1, arg_19_2)

			if not views[current_view].disable_toggle_menu then
				flag = views[current_view]:disable_toggle_menu()
			end
		end

		local is_device_active = Managers.input:is_device_active("gamepad")
		local flag_2 = true
		local component = ingame_hud:component("IngamePlayerListUI")
		local flag_3 = not component and component:is_active()
		local component_2 = ingame_hud:component("VersusTabUI")
		local component_3 = ingame_hud:component("VersusSlotStatusUI")

		flag_3 = not component_2 and component_2:is_active() and not component_3 or component_3:is_active() and flag_3

		local game_mode = Managers.state.game_mode:game_mode()

		if not (not game_mode.menu_access_allowed_in_state and game_mode:menu_access_allowed_in_state()) then
			flag_2 = false
		end

		local in_fade_active = Managers.transition:in_fade_active()

		if not flag_2 and flag_3 and flag and self:pending_transition() and in_fade_active and self:end_screen_active() and self.menu_active and self.leave_game and self.return_to_title_screen and self:get_active_popup("profile_picker") or not get_service:get("toggle_menu", true) then
			local IS_CONSOLE = IS_CONSOLE

			IS_CONSOLE = IS_CONSOLE or is_device_active or not UISettings.use_pc_menu_layout

			if not IS_CONSOLE then
				local str = "overview"

				if not is_in_inn and not is_device_active then
					local flag_4

					flag_4 = not is_device_active and "equipment" and "system"

					local tbl = {
						menu_state_name = str,
						menu_sub_state_name = flag_4
					}

					self:transition_with_fade("hero_view_force", tbl)
				else
					local str_2 = "system"
					local tbl_2 = {
						menu_state_name = str,
						menu_sub_state_name = str_2,
						force_ingame_menu = IS_WINDOWS
					}

					self:handle_transition("hero_view_force", tbl_2)
				end
			else
				self:handle_transition("ingame_menu")
			end
		end

		if not self:pending_transition() then
			local local_player = Managers.player:local_player()
			local flag_5 = not local_player and local_player.player_unit

			if not flag_5 and not Unit.alive(flag_5) then
				local flag_6 = arg_19_4 ~= nil
				local flag_7 = not is_in_inn and not not arg_19_3 or not flag_6

				self:handle_menu_hotkeys(arg_19_1, get_service, flag_7, self.menu_active)
			end
		end

		for k, v in pairs(self.popups_by_name) do
			v.popup:update(arg_19_1, arg_19_2)
		end

		end_screen:update(arg_19_1, arg_19_2)

		if not self.help_screen then
			self.help_screen:update(arg_19_1)
		end
	end

	if not Managers.state.network:game() then
		self.ingame_hud:update(arg_19_1, arg_19_2)
	end

	self:_update_menu_blocking_information(arg_19_1, arg_19_2, get_service, arg_19_4)
	self:_render_debug_ui(arg_19_1, arg_19_2)
	self:_update_fade_transition()

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

IngameUI.disable_ingame_ui = function (self)
	-- function 20
	return self._disable_ingame_ui
end

IngameUI._holly_dlc_intro_closed = function (arg_21_0)
	-- function 21
	PlayerData.viewed_dialogues.dlc_holly = true

	Managers.save:auto_save(SaveFileName, SaveData)
end

IngameUI.post_update = function (self, arg_22_1, arg_22_2)
	-- function 22
	self:_post_handle_transition()

	local current_view = self.current_view

	if not current_view then
		local views = self.views

		if not views[current_view].post_update then
			views[current_view]:post_update(arg_22_1, arg_22_2)
		end
	end

	self.ingame_hud:post_update(arg_22_1, arg_22_2)
end

IngameUI.cutscene_active = function (self)
	-- function 23
	return self.cutscene_system.active_camera ~= nil
end

IngameUI._survey_update = function (self, arg_24_1)
	-- function 24
	local telemetry_survey = self.views.telemetry_survey

	telemetry_survey:update(arg_24_1)

	if telemetry_survey:is_survey_answered() or not telemetry_survey:is_survey_timed_out() then
		self.survey_active = false

		telemetry_survey:on_exit()
	end
end

IngameUI._handle_resolution_changes = function (self)
	-- function 25
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h

	if not (res_w ~= self.last_resolution_x or res_h == self.last_resolution_y) then
		self.last_resolution_x, self.last_resolution_y = res_w, res_h
	end
end

IngameUI._update_menu_blocking_information = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	-- function 26
	local _menu_blocking_information, var_26_1, var_26_2 = self:_menu_blocking_information(arg_26_3, arg_26_4)

	Managers.chat:update(arg_26_1, arg_26_2, _menu_blocking_information, var_26_1, var_26_2)

	if not (not IS_WINDOWS and _menu_blocking_information == self._was_in_view) then
		self._was_in_view = _menu_blocking_information

		Application.set_in_menu(_menu_blocking_information)
	end
end

IngameUI._menu_blocking_information = function (self, arg_27_1, arg_27_2)
	-- function 27
	local ingame_hud = self.ingame_hud
	local component = ingame_hud:component("IngamePlayerListUI")

	component = component or ingame_hud:component("VersusTabUI")

	local flag = not component and component:is_focused()
	local component_2 = ingame_hud:component("GiftPopupUI")
	local flag_2 = not component_2 and component_2:active()
	local end_screen_active = self:end_screen_active()
	local component_3 = ingame_hud:component("MissionVotingUI")
	local flag_3 = not component_3 and component_3:is_active()
	local cutscene_system = self.cutscene_system
	local get_active_popup = self:get_active_popup("profile_picker")
	local menu_active = self.menu_active

	if not menu_active then
		if not arg_27_2 then
			menu_active = arg_27_2:enable_chat()

			if not menu_active then
				-- Nothing
			end
		end

		menu_active = self.current_view == nil or not self.views[self.current_view].normal_chat
	end

	::label_27_0::

	local active_camera = cutscene_system.active_camera

	active_camera = not active_camera and not cutscene_system.ingame_hud_enabled

	if not self.current_view then
		local input_service = self.views[self.current_view]:input_service()

		return menu_active, input_service, false
	elseif not flag_3 then
		local active_input_service = component_3:active_input_service()

		return menu_active, active_input_service, false
	elseif not arg_27_2 then
		local active_input_service_2 = arg_27_2:active_input_service()

		return menu_active, active_input_service_2, false
	elseif not flag_2 then
		local active_input_service_3 = component_2:active_input_service()

		return menu_active, active_input_service_3, false
	elseif not get_active_popup then
		local input_service_2 = get_active_popup:input_service()

		return menu_active, input_service_2, false
	elseif not flag then
		local input_service_3 = component:input_service()

		return menu_active, input_service_3, false
	elseif not self.menu_active then
		return menu_active, arg_27_1, false
	elseif not active_camera then
		local input_service_4 = ingame_hud:component("CutsceneUI"):input_service()

		return menu_active, input_service_4, false
	elseif not end_screen_active then
		local input_service_5 = self.end_screen:input_service()

		return menu_active, input_service_5, false
	else
		return menu_active, nil, false
	end
end

IngameUI._render_debug_ui = function (self, arg_28_1, arg_28_2)
	-- function 28
	if not script_data.disable_debug_draw then
		if not (not self.menu_active and not GameSettingsDevelopment.show_version_info and script_data.hide_version_info) then
			self:_render_version_info()
		end

		if not (not GameSettingsDevelopment.show_fps and script_data.hide_fps) then
			self:_render_fps(arg_28_1)
		end
	end
end

IngameUI.show_info = function (self)
	-- function 29
	local system = Managers.state.entity:system("mission_system")
	local get_level_end_mission_data = system:get_level_end_mission_data("grimoire_hidden_mission")
	local get_level_end_mission_data_2 = system:get_level_end_mission_data("tome_bonus_mission")
	local resolution, var_29_4 = Application.resolution()
	local var_29_5 = Vector3(100, var_29_4 - 100, 999)
	local var_29_6 = self
	local _show_text = self._show_text
	local current_amount

	if not get_level_end_mission_data then
		current_amount = get_level_end_mission_data.current_amount

		if not current_amount then
			-- Nothing
		end
	end

	current_amount = ""

	::label_29_0::

	local var_29_9 = _show_text(var_29_6, current_amount, var_29_5)
	local var_29_10 = self
	local _show_text_2 = self._show_text
	local current_amount_2

	if not get_level_end_mission_data_2 then
		current_amount_2 = get_level_end_mission_data_2.current_amount

		if not current_amount_2 then
			-- Nothing
		end
	end

	current_amount_2 = ""

	::label_29_1::

	local var_29_13 = _show_text_2(var_29_10, current_amount_2, var_29_9)
end

IngameUI._show_text = function (self, arg_30_1, arg_30_2)
	-- function 30
	Gui.text(self.ui_renderer.gui, "text", "materials/fonts/gw_head", 20, "gw_head", arg_30_2, Color(0, 255, 0))

	return Vector3(arg_30_2[1], arg_30_2[2] - 30, arg_30_2[3])
end

IngameUI._update_system_message_cooldown = function (self, arg_31_1)
	-- function 31
	local system_message_delay = self.system_message_delay

	if not system_message_delay then
		local num = system_message_delay - arg_31_1

		self.system_message_delay = not (num > 0) or not num or nil
	end
end

IngameUI.add_local_system_message = function (self, arg_32_1)
	-- function 32
	if not (not self.system_message_delay and self.last_sent_system_message == arg_32_1) then
		local flag = true
		local var_32_1 = Localize(arg_32_1)

		if not IS_WINDOWS then
			Managers.chat:add_local_system_message(1, var_32_1, flag)
		else
			local stats_id = Managers.player:local_player():stats_id()

			Managers.state.event:trigger("add_personal_interaction_warning", stats_id .. arg_32_1, arg_32_1)
		end

		self.last_sent_system_message = arg_32_1
		self.system_message_delay = 1.5
	end
end

IngameUI.is_transition_allowed = function (self, arg_33_1)
	-- function 33
	local var_33_0
	local flag = true

	if not self:is_local_player_ready_for_game() then
		if arg_33_1 == "profile_view" then
			var_33_0 = "matchmaking_ready_interaction_message_profile_view"
			flag = false
		elseif arg_33_1 == "inventory_view_force" then
			var_33_0 = "matchmaking_ready_interaction_message_inventory"
			flag = false
		end
	end

	if not var_33_0 then
		self:add_local_system_message(var_33_0)
	end

	return flag
end

IngameUI._post_handle_transition = function (self)
	-- function 34
	if not self.new_transition then
		return
	end

	local transition_params = self.transition_params
	local var_34_1 = self.views[self.new_transition_old_view]

	if not var_34_1 and not var_34_1.post_update_on_exit then
		printf("[IngameUI] menu view post_update_on_exit %s", var_34_1)
		var_34_1:post_update_on_exit(transition_params, self.new_transition_old_view == self.current_view)
	end

	local var_34_2 = self.views[self.current_view]

	if not var_34_2 and not var_34_2.post_update_on_enter then
		printf("[IngameUI] menu view post_update_on_enter %s", var_34_2)
		var_34_2:post_update_on_enter(transition_params)
	end

	if not script_data.debug_enabled then
		self.last_transition_params = self.transition_params
		self.last_transition_name = self.new_transition
	end

	self.new_transition_old_view = nil
	self.new_transition = nil
end

IngameUI.handle_transition = function (self, arg_35_1, arg_35_2)
	-- function 35
	fassert(transitions[arg_35_1], "Missing transition to %s", arg_35_1)

	local blocked_transitions = self.blocked_transitions

	if not blocked_transitions and not blocked_transitions[arg_35_1] then
		return
	end

	local _previous_transition = self._previous_transition

	if not (not self:is_transition_allowed(arg_35_1) and not _previous_transition and _previous_transition ~= arg_35_1) then
		return
	end

	if not self.new_transition_old_view then
		return
	end

	arg_35_2 = arg_35_2 or {}

	local current_view = self.current_view

	transitions[arg_35_1](self, arg_35_2)

	local current_view_2 = self.current_view
	local force_open = arg_35_2.force_open

	if current_view ~= current_view_2 or not force_open then
		if not self.views[current_view] then
			if not self.views[current_view].on_exit then
				printf("[IngameUI] menu view on_exit %s", current_view)
				self.views[current_view]:on_exit(arg_35_2)

				self.views[current_view].exit_to_game = nil
			end

			local transition_params = self.transition_params
			local flag = not transition_params and transition_params.on_exit_callback

			if not flag then
				flag()
			end
		end

		if not current_view_2 and not self.views[current_view_2] and not self.views[current_view_2].on_enter then
			printf("[IngameUI] menu view on_enter %s", current_view_2)
			self.views[current_view_2]:on_enter(arg_35_2)
		end

		self.new_transition = arg_35_1
		self.new_transition_old_view = current_view
		self.transition_params = arg_35_2
		self._previous_transition = arg_35_1
	end
end

IngameUI.transition_with_fade = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	-- function 36
	local blocked_transitions = self.blocked_transitions

	if not blocked_transitions and not blocked_transitions[arg_36_1] then
		return
	end

	local _previous_transition = self._previous_transition

	if not (not self:is_transition_allowed(arg_36_1) and not _previous_transition and _previous_transition ~= arg_36_1) then
		return
	end

	self._transition_fade_data = {
		new_transition = arg_36_1,
		transition_params = arg_36_2,
		fade_out_speed = arg_36_4
	}

	Managers.transition:fade_in(arg_36_3 or 10)
end

IngameUI._update_fade_transition = function (self)
	-- function 37
	local _transition_fade_data = self._transition_fade_data

	if not _transition_fade_data then
		return
	end

	if not Managers.transition:fade_in_completed() then
		local new_transition = _transition_fade_data.new_transition
		local transition_params = _transition_fade_data.transition_params

		self:handle_transition(new_transition, transition_params)

		local fade_out_speed = self._transition_fade_data.fade_out_speed

		self._transition_fade_data = nil

		Managers.transition:fade_out(fade_out_speed or 10)
	end
end

IngameUI.pending_transition = function (self)
	-- function 38
	return self._transition_fade_data ~= nil or self.new_transition_old_view ~= nil
end

IngameUI.get_transition = function (self)
	-- function 39
	if not self.leave_game then
		if not Managers.play_go:installed() then
			return "leave_game"
		else
			return "finish_tutorial"
		end
	elseif not self.return_to_pc_menu then
		return "return_to_pc_menu"
	elseif not self.return_to_title_screen then
		return "return_to_title_screen"
	elseif not self.return_to_demo_title_screen then
		return "return_to_demo_title_screen"
	elseif not self.restart_demo then
		return "restart_demo"
	elseif not self.join_lobby then
		return "join_lobby", self.join_lobby
	elseif not self.restart_game then
		return "restart_game"
	elseif not self.quit_game then
		return "quit_game"
	end
end

IngameUI.suspend_active_view = function (self)
	-- function 40
	local current_view = self.current_view

	if not current_view and current_view == "exit_menu" or not self.views[current_view] then
		self:handle_transition("exit_menu")
	end
end

IngameUI.activate_end_screen_ui = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	self.end_screen:on_enter(arg_41_1, arg_41_2, arg_41_3)
end

IngameUI.deactivate_end_screen_ui = function (self)
	-- function 42
	local end_screen = self.end_screen

	if not end_screen.is_active then
		end_screen:on_exit()
	end
end

IngameUI.end_screen_active = function (self)
	-- function 43
	local end_screen = self.end_screen

	return not end_screen and end_screen.is_active
end

IngameUI.end_screen_completed = function (self)
	-- function 44
	local end_screen = self.end_screen

	return not end_screen and end_screen.is_complete
end

IngameUI.end_screen_fade_in_complete = function (self)
	-- function 45
	local end_screen = self.end_screen

	return not end_screen and end_screen:fade_in_complete()
end

IngameUI.update_map_enable_state = function (self)
	-- function 46
	if not self.is_in_inn then
		local map_view = self.views.map_view

		if not map_view then
			local map_interaction_enabled = map_view.map_interaction_enabled
			local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()

			if not map_interaction_enabled and not is_game_matchmaking then
				map_view:set_map_interaction_state(false)
			elseif not (map_interaction_enabled or is_game_matchmaking) then
				map_view:set_map_interaction_state(true)
			end
		end
	end
end

IngameUI.play_sound = function (self, arg_47_1)
	-- function 47
	WwiseWorld.trigger_event(self.wwise_world, arg_47_1)
end

local str = "arial"
local str_2 = "materials/fonts/" .. str
local tbl_3 = {}
local white = Colors.color_definitions.white
local black = Colors.color_definitions.black
local red = Colors.color_definitions.red

IngameUI._render_version_info = function (self)
	-- function 48
	local ui_top_renderer = self.ui_top_renderer
	local num = 1920
	local num_2 = 1080
	local num_3 = 18
	local build_identifier = script_data.build_identifier

	build_identifier = build_identifier or "???"

	local content_revision = script_data.settings.content_revision

	content_revision = content_revision or "???"

	local upper = tostring(Application.make_hash(build_identifier, content_revision)):sub(1, 4):upper()

	if not (build_identifier ~= "???" or content_revision ~= "???") then
		upper = "???"
	end

	local str_3 = "GAME HASH: " .. upper .. " | Content revision: " .. content_revision .. " | Engine version: " .. build_identifier:sub(1, 6) .. "..."

	if not rawget(_G, "Steam") then
		local app_id = Steam.app_id()

		str_3 = str_3 .. " Appid: " .. app_id
	end

	local text_size, var_48_10 = UIRenderer.text_size(ui_top_renderer, str_3, str_2, num_3)
	local num_4 = num - text_size - 8
	local var_48_12 = var_48_10

	tbl_3[1] = num_4
	tbl_3[2] = var_48_12
	tbl_3[3] = 899

	UIRenderer.draw_text(ui_top_renderer, str_3, str_2, num_3, str, Vector3(unpack(tbl_3)), white)

	tbl_3[1] = num_4 + 2
	tbl_3[2] = var_48_12 - 2
	tbl_3[3] = 898

	UIRenderer.draw_text(ui_top_renderer, str_3, str_2, num_3, str, Vector3(unpack(tbl_3)), black)
end

IngameUI._render_fps = function (self, arg_49_1)
	-- function 49
	local _fpses = self._fpses

	_fpses = _fpses or {}
	self._fpses = _fpses

	local ui_top_renderer = self.ui_top_renderer

	self._fpses[#self._fpses + 1] = arg_49_1
	self._fps_cooldown = self._fps_cooldown + arg_49_1

	if self._fps_cooldown > 1 then
		local _fpses_2 = self._fpses
		local count = #self._fpses
		local num = 0

		for k, v in pairs(self._fpses) do
			num = num + v
		end

		local num_2 = num / count

		self.mean_dt = num_2
		self.fps = math.floor(1 / num_2 + 0.5)

		table.clear(self._fpses)

		self._fps_cooldown = self._fps_cooldown - 1
	end

	local fps = self.fps
	local mean_dt = self.mean_dt
	local format = string.format("%.2fms  %i FPS", mean_dt * 1000, fps)
	local var_49_9
	local num_3 = 30

	if not IS_CONSOLE then
		num_3 = 28
	end

	if fps < num_3 then
		var_49_9 = red
	else
		var_49_9 = white
	end

	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_4 = 24
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local text_size, var_49_16 = UIRenderer.text_size(ui_top_renderer, format, str_2, num_4 * RESOLUTION_LOOKUP.scale)
	local num_5 = (res_w - text_size - 8) * inv_scale
	local num_6 = (var_49_16 + 16) * inv_scale

	tbl_3[1] = num_5
	tbl_3[2] = num_6
	tbl_3[3] = 899

	UIRenderer.draw_text(ui_top_renderer, format, str_2, num_4, str, Vector3(unpack(tbl_3)), var_49_9)

	tbl_3[1] = num_5 + 2
	tbl_3[2] = num_6 - 2
	tbl_3[3] = 898

	UIRenderer.draw_text(ui_top_renderer, format, str_2, num_4, str, Vector3(unpack(tbl_3)), black)

	local camera = Managers.state.camera

	if not camera then
		local local_player = Managers.player:local_player(1)
		local flag = not local_player and local_player.viewport_name

		if not flag then
			local camera_position = camera:camera_position(flag)
			local camera_rotation = camera:camera_rotation(flag)
			local num_7 = 18
			local format_2 = string.format("Position(%.2f, %.2f, %.2f) Rotation(%.4f, %.4f, %.4f, %.4f)", camera_position.x, camera_position.y, camera_position.z, Quaternion.to_elements(camera_rotation))

			UIRenderer.draw_text(ui_top_renderer, format_2, str_2, num_7, str, Vector3(11, 11, 1), var_49_9)
			UIRenderer.draw_text(ui_top_renderer, format_2, str_2, num_7, str, Vector3(10, 10, 0), black)
		end
	end

	local resolution, var_49_27 = Application.resolution()
	local format_3 = string.format("Resolution W:%i H:%i", resolution, var_49_27)

	UIRenderer.draw_text(ui_top_renderer, format_3, str_2, 18, str, Vector3(11, 31, 1), var_49_9)
	UIRenderer.draw_text(ui_top_renderer, format_3, str_2, 18, str, Vector3(10, 30, 0), black)

	if not LobbyInternal.SESSION_NAME then
		UIRenderer.draw_text(ui_top_renderer, "My server name:", str_2, 20, str, Vector3(20, 40, 999))
		UIRenderer.draw_text(ui_top_renderer, "My server name:", str_2, 20, str, Vector3(22, 38, 998), black)
		UIRenderer.draw_text(ui_top_renderer, LobbyInternal.SESSION_NAME, str_2, 20, str, Vector3(20, 20, 999))
		UIRenderer.draw_text(ui_top_renderer, LobbyInternal.SESSION_NAME, str_2, 20, str, Vector3(22, 18, 998), black)
	end
end

IngameUI.open_popup = function (self, arg_50_1, ...)
	-- function 50
	local popups_by_name = self.popups_by_name

	fassert(popups_by_name[arg_50_1] == nil, "Trying to open a popup %q that is already active", arg_50_1)

	local var_50_1 = PopupSettingsByName[arg_50_1]
	local var_50_2 = rawget(_G, var_50_1.class):new(self.ingame_ui_context, ...)

	popups_by_name[arg_50_1] = {
		settings = var_50_1,
		popup = var_50_2
	}
end

IngameUI.close_popup = function (self, arg_51_1)
	-- function 51
	local popups_by_name = self.popups_by_name
	local var_51_1 = popups_by_name[arg_51_1]

	fassert(var_51_1 ~= nil, "Trying to close a popup %q that is not active", arg_51_1)

	local popup = var_51_1.popup

	popup:hide()
	popup:delete()

	popups_by_name[arg_51_1] = nil
end

IngameUI.get_active_popup = function (self, arg_52_1)
	-- function 52
	local var_52_0 = self.popups_by_name[arg_52_1]

	return not var_52_0 and var_52_0.popup
end

IngameUI.respawn = function (self)
	-- function 53
	if not Managers.state.network:game() then
		return
	end

	local peer_id = self.peer_id
	local local_player_id = self.local_player_id
	local profile_by_peer, var_53_3 = self.profile_synchronizer:profile_by_peer(peer_id, local_player_id)
	local var_53_4, var_53_5 = hero_and_career_name_from_index(profile_by_peer, var_53_3)
	local flag = true

	self._profile_requester:request_profile(peer_id, local_player_id, var_53_4, var_53_5, flag)

	self._respawning = true
end

IngameUI._update_respawning = function (self)
	-- function 54
	if self._profile_requester:result() ~= nil then
		return true
	end

	return false
end

IngameUI._cancel_popup = function (self)
	-- function 55
	if not self.popup_id then
		Managers.popup:cancel_popup(self.popup_id)
	end
end

IngameUI.get_hud_component = function (self, arg_56_1)
	-- function 56
	return self.ingame_hud:get_hud_component(arg_56_1)
end
