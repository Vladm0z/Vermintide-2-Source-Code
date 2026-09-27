-- chunkname: @scripts/game_state/state_loading.lua

require("scripts/game_state/server_join_state_machine")
require("scripts/game_state/loading_sub_states/win32/state_loading_running")
require("scripts/game_state/loading_sub_states/win32/state_loading_restart_network")
require("scripts/game_state/loading_sub_states/win32/state_loading_migrate_host")
require("scripts/helpers/level_helper")
require("scripts/settings/level_settings")
require("scripts/utils/async_level_spawner")
require("scripts/game_state/loading_sub_states/win32/state_loading_versus_migration")

local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

StateLoading = class(StateLoading)
StateLoading.NAME = "StateLoading"

local flag = false
local num = 30

StateLoading.round_start_auto_join = 10
StateLoading.round_start_join_allowed = 20
StateLoading.join_lobby_timeout = 120
StateLoading.join_lobby_refresh_interval = 5
StateLoading.LoadoutResyncStates = {
	NEEDS_RESYNC = "needs_resync",
	WAIT_FOR_LEVEL_LOAD = "wait_for_level_load",
	IDLE = "idle",
	DONE = "done",
	CHECK_RESYNC = "check_resync",
	RESYNCING = "resyncing"
}

local tbl = {
	survival = "Play_loading_screen_music",
	weave = "Play_loading_screen_music",
	quad = "Play_loading_screen_music",
	inn = "Play_loading_screen_music",
	inn_vs = "Play_loading_screen_music_versus_small",
	demo = "Play_loading_screen_music",
	adventure = "Play_loading_screen_music",
	tutorial = "Play_loading_screen_music",
	versus = "Play_loading_screen_music_versus",
	deus = "Play_loading_screen_music_morris"
}

local function fn(arg_1_0)
	-- function 1
	if arg_1_0 == "false" then
		return false
	else
		return arg_1_0
	end
end

StateLoading.on_enter = function (self, arg_2_1)
	-- function 2
	print("[Gamestate] Enter state StateLoading")

	local loading_context = self.parent.loading_context
	local time_spent_in_level = loading_context.time_spent_in_level
	local end_reason = loading_context.end_reason

	Managers.load_time:start_timer(time_spent_in_level, end_reason)

	if not Managers.play_go:installed() then
		Managers.play_go:set_install_speed("suspended")
	end

	if not IS_XB1 then
		Application.set_kinect_enabled(true)
	end

	if not IS_WINDOWS then
		Managers.chat:set_chat_enabled(Application.user_setting("chat_enabled"))
	end

	if not DEDICATED_SERVER then
		GlobalShaderFlags.reset()
	end

	Framerate.set_low_power()
	Wwise.set_state("inside_waystone", "false")

	self._registered_rpcs = false
	self._loading_view_setup_is_done = false

	self:set_loadout_resync_state(StateLoading.LoadoutResyncStates.IDLE)
	self:_setup_state_managers()
	self:_setup_garbage_collection()
	self:_setup_world()
	self:_setup_input()
	self:_parse_loading_context()
	self:_create_loading_view()
	self:_setup_end_of_level_ui()
	self:_setup_first_time_ui()
	self:_setup_init_network_view()
	Managers.popup:set_input_manager(self._input_manager)

	if not DEDICATED_SERVER then
		Managers.chat:set_input_manager(self._input_manager)
	end

	self:_setup_state_machine()
	self:_unmute_all_world_sounds()

	if not self._switch_to_tutorial_backend then
		Managers.backend:start_tutorial()
		Managers.mechanism:choose_next_state(self._wanted_tutorial_state)
		Managers.mechanism:progress_state()

		self.parent.loading_context.switch_to_tutorial_backend = nil
		self.parent.loading_context.wanted_tutorial_state = nil
	elseif LAUNCH_MODE == "attract_benchmark" then
		Managers.backend:start_benchmark()
	end

	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if not (not query_lobby and query_lobby.is_host or query_lobby:is_dedicated_server()) then
		Managers.party:set_leader(query_lobby:lobby_host())
	end

	Managers.transition:hide_icon_background()
	Managers.transition:fade_out(GameSettings.transition_fade_out_speed)
	Managers.light_fx:set_lightfx_color_scheme("loading")

	self._menu_setup_done = false

	if not IS_XB1 and not query_lobby and not query_lobby.is_host then
		Managers.account:set_round_id()
	end

	if not self._network_client then
		self._network_client.voip:set_input_manager(self._input_manager)
	end

	if not self._network_server then
		self._network_server.voip:set_input_manager(self._input_manager)
	end

	if not self.parent.loading_context.finished_tutorial then
		self.parent.loading_context.finished_tutorial = nil
		self.parent.loading_context.show_profile_on_startup = true

		if not Managers.play_go:installed() then
			self._wanted_state = StateTitleScreen
			self._teardown_network = true
		end
	end

	self._has_invitation_error = false

	if not DEDICATED_SERVER then
		local get_current_level_key = Managers.level_transition_handler:get_current_level_key()

		if not self:loading_view_setup_done() then
			self:setup_loading_view(get_current_level_key)
		end
	end

	self._ingame_world_object = nil
	self._ingame_level_object = nil

	local flag = true

	Managers.music:unduck_sounds(flag)
end

StateLoading._setup_state_managers = function (arg_3_0)
	-- function 3
	Managers.state.event = EventManager:new(Managers.persistent_event)
end

StateLoading.set_loadout_resync_state = function (self, arg_4_1)
	-- function 4
	fassert(table.contains(StateLoading.LoadoutResyncStates, arg_4_1), "[StateLoading] State %s not found in LoadoutResyncStates", tostring(arg_4_1))

	self._loadout_resync_state = arg_4_1
end

StateLoading.loadout_resync_state = function (self)
	-- function 5
	return self._loadout_resync_state
end

StateLoading._setup_input = function (self)
	-- function 6
	local var_6_0 = InputManager:new()

	Managers.input = var_6_0
	self._input_manager = var_6_0

	var_6_0:initialize_device("keyboard", 1)
	var_6_0:initialize_device("mouse", 1)
	var_6_0:initialize_device("gamepad", 1)
	var_6_0:create_input_service("Player", "PlayerControllerKeymaps", "PlayerControllerFilters")
	var_6_0:map_device_to_service("Player", "keyboard")
	var_6_0:map_device_to_service("Player", "mouse")
	var_6_0:map_device_to_service("Player", "gamepad")
	var_6_0:create_input_service("ingame_menu", "IngameMenuKeymaps", "IngameMenuFilters")
	var_6_0:map_device_to_service("ingame_menu", "keyboard")
	var_6_0:map_device_to_service("ingame_menu", "mouse")
	var_6_0:map_device_to_service("ingame_menu", "gamepad")
	var_6_0:create_input_service("deus_run_stats_view", "IngameMenuKeymaps", "IngameMenuFilters")
	var_6_0:map_device_to_service("deus_run_stats_view", "keyboard")
	var_6_0:map_device_to_service("deus_run_stats_view", "mouse")
	var_6_0:map_device_to_service("deus_run_stats_view", "gamepad")
end

StateLoading._parse_loading_context = function (self)
	-- function 7
	local loading_context = self.parent.loading_context

	if not loading_context then
		self._network_server = loading_context.network_server
		self._network_client = loading_context.network_client
		self._checkpoint_data = loading_context.checkpoint_data
		self._quickplay_bonus = loading_context.quickplay_bonus
		self._level_end_view_context = loading_context.level_end_view_context
		self._switch_to_tutorial_backend = loading_context.switch_to_tutorial_backend
		self._wanted_tutorial_state = loading_context.wanted_tutorial_state
		self._saved_scoreboard_stats = loading_context.saved_scoreboard_stats
	end
end

StateLoading._setup_garbage_collection = function (arg_8_0)
	-- function 8
	local flag = true

	GarbageLeakDetector.run_leak_detection(flag)
	GarbageLeakDetector.register_object(arg_8_0, "StateLoadingRunning")
end

StateLoading._setup_world = function (self)
	-- function 9
	self._world_name = "loading_world"
	self._viewport_name = "loading_viewport"
	self._world = Managers.world:create_world(self._world_name, GameSettingsDevelopment.default_environment, nil, nil, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)
	self._viewport = ScriptWorld.create_viewport(self._world, self._viewport_name, "overlay", 1)
end

StateLoading._setup_init_network_view = function (self)
	-- function 10
	if not (not Development.parameter("goto_endoflevel") and true) then
		require("scripts/game_state/state_loading")

		local flag = false

		Managers.package:load("resource_packages/levels/dicegame", "state_loading", nil, flag)

		self.parent.loading_context.play_end_of_level_game = true
		self._wanted_state = StateLoading
	else
		require("scripts/game_state/state_ingame")

		self._wanted_state = StateIngame
	end
end

StateLoading._setup_end_of_level_ui = function (self)
	-- function 11
	if not self._level_end_view_context then
		self._level_end_view_context.lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")
		self._level_end_view_wrappers = {}
		self._level_end_view_wrappers[1] = LevelEndViewWrapper:new(self._level_end_view_context)

		self._level_end_view_wrappers[1]:start()

		self._level_end_view_context = nil
		self.parent.loading_context.level_end_view_context = nil
	end
end

StateLoading._setup_first_time_ui = function (self)
	-- function 12
	local loading_context = self.parent.loading_context

	if not ((loading_context.first_time or loading_context.gamma_correct or not loading_context.play_trailer) and GameSettingsDevelopment.disable_intro_trailer or script_data.skip_intro_trailer) then
		local get_hub_level_key = Managers.mechanism:game_mechanism():get_hub_level_key()
		local level_key

		if not Boot.loading_context then
			level_key = Boot.loading_context.level_key

			if not level_key then
				-- Nothing
			end
		end

		level_key = get_hub_level_key

		::label_12_0::

		local var_12_3
		local tbl = {}
		local get_current_level_key = Managers.level_transition_handler:get_current_level_key()

		tbl.is_prologue = self._switch_to_tutorial_backend == true

		local PLATFORM = PLATFORM

		if IS_WINDOWS or not IS_LINUX then
			level_key = not Development.parameter("attract_mode") and BenchmarkSettings.auto_host_level and level_key
			level_key = fn(Development.parameter("auto_host_level")) or not Development.parameter("vs_auto_search") or "carousel_hub" or level_key
			var_12_3 = not not LevelSettings[level_key].hub_level or not tbl.is_prologue
			var_12_3 = loading_context.join_lobby_data or Development.parameter("auto_join") or var_12_3 or Development.parameter("skip_splash")

			if var_12_3 or not Development.parameter("weave_name") then
				var_12_3 = true
			end

			tbl.gamma = not SaveData.gamma_corrected

			local play_trailer = loading_context.play_trailer

			play_trailer = play_trailer or Application.user_setting("play_intro_cinematic")
			tbl.trailer = play_trailer
		elseif not IS_CONSOLE then
			level_key = fn(Development.parameter("auto_host_level")) or level_key
			var_12_3 = not LevelSettings[level_key].hub_level
			var_12_3 = loading_context.join_lobby_data or Development.parameter("auto_join") or var_12_3 or Development.parameter("skip_splash")

			if var_12_3 or not Development.parameter("weave_name") then
				var_12_3 = true
			end

			tbl.gamma = loading_context.gamma_correct

			local play_trailer_2 = loading_context.play_trailer

			play_trailer_2 = play_trailer_2 or Application.user_setting("play_intro_cinematic")
			tbl.trailer = play_trailer_2

			if tbl.gamma or not tbl.trailer then
				var_12_3 = false
			end

			tbl.is_prologue = level_key == "prologue"
		end

		print("[StateLoading] Auto Skip: ", var_12_3)

		loading_context.gamma_correct = nil
		loading_context.play_trailer = nil
		self._first_time_view = TitleLoadingUI:new(self._world, tbl, var_12_3)

		if not self._first_time_view:is_loading_packages() then
			Managers.transition:hide_loading_icon()
		end

		Managers.chat:enable_gui(false)
		self._loading_view:deactivate()
	end

	loading_context.first_time = nil
end

StateLoading._unmute_all_world_sounds = function (arg_13_0)
	-- function 13
	Managers.music:trigger_event("unmute_all_world_sounds")
end

StateLoading._get_game_difficulty = function (arg_14_0)
	-- function 14
	return Managers.level_transition_handler:get_current_difficulty()
end

StateLoading._create_loading_view = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not DEDICATED_SERVER then
		return
	end

	local _get_game_difficulty = self:_get_game_difficulty()
	local tbl = {
		world = self._world,
		input_manager = self._input_manager,
		level_key = arg_15_1,
		game_difficulty = _get_game_difficulty,
		world_manager = Managers.world,
		chat_manager = Managers.chat,
		profile_synchronizer = self._profile_synchronizer,
		act_progression_index = arg_15_2,
		return_to_pc_menu = self.parent.loading_context.return_to_pc_menu
	}

	self._loading_view = LoadingView:new(tbl)
	self.parent.loading_context.return_to_pc_menu = nil
end

StateLoading._trigger_loading_view = function (self, arg_16_1, arg_16_2)
	-- function 16
	arg_16_1 = arg_16_1 or Managers.mechanism:default_level_key()

	if not self._loading_music_triggered then
		local game_mechanism = Managers.mechanism:game_mechanism()

		if not (not game_mechanism:should_play_level_introduction() and Development.parameter("gdc")) then
			local var_16_1 = LevelSettings[arg_16_1]
			local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")
			local lobby_data

			if not query_lobby then
				lobby_data = query_lobby:lobby_data("weave_name")

				if not lobby_data then
					-- Nothing
				end
			end

			lobby_data = Managers.weave:get_next_weave()
			lobby_data = lobby_data or Development.parameter("weave_name")

			::label_16_0::

			local var_16_4 = WeaveSettings.templates[lobby_data]

			if not var_16_4 then
				self._weave_wwise_events = self:_trigger_weave_sound_events(var_16_4, arg_16_1, var_16_1.is_arena)
			else
				self._wwise_event = self:_trigger_sound_events(arg_16_1)

				self._loading_view:trigger_subtitles(self._wwise_event, Managers.time:time("main"))
			end
		end

		local mechanism = LevelSettings[arg_16_1].mechanism
		local var_16_6 = tbl[mechanism]

		var_16_6 = not game_mechanism.override_loading_screen_music and game_mechanism:override_loading_screen_music() and var_16_6

		if not Managers.weave:get_active_weave() then
			var_16_6 = "reset_between_winds"
		end

		if not (not arg_16_2 and not (arg_16_2 >= 1) or not (arg_16_2 < 4)) then
			var_16_6 = var_16_6 .. "_act" .. arg_16_2
		elseif not (not arg_16_2 and not (arg_16_2 >= 4)) then
			var_16_6 = var_16_6 .. "_finished"
		end

		if not var_16_6 then
			Managers.music:trigger_event(var_16_6)
		end
	end

	self._activate_loading_view = true
	self._loading_music_triggered = true

	Managers.transition:hide_icon_background()
	Managers.transition:force_fade_in()
end

StateLoading.setup_loading_view = function (self, arg_17_1)
	-- function 17
	arg_17_1 = arg_17_1 or Managers.mechanism:default_level_key()
	self._level_key = arg_17_1

	if not DEDICATED_SERVER then
		local package = Managers.package

		if not self._ui_package_name and package:has_loaded(self._ui_package_name, "global_loading_screens") and not package:is_loading(self._ui_package_name) then
			package:unload(self._ui_package_name, "global_loading_screens")
		end

		local var_17_1 = LevelSettings[arg_17_1]
		local get_next_weave = Managers.weave:get_next_weave()

		get_next_weave = get_next_weave or Development.parameter("weave_name")

		if var_17_1.game_mode == "weave" then
			local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")

			get_next_weave = not query_lobby and query_lobby:lobby_data("selected_mission_id") and get_next_weave

			if not (not get_next_weave and get_next_weave == "false" or WeaveSettings.templates[get_next_weave]) then
				if not (not IS_XB1 and query_lobby:is_updating_lobby_data()) then
					query_lobby:force_update_lobby_data()
				end

				return
			end

			local var_17_4 = WeaveSettings.templates[get_next_weave]
			local var_17_5 = var_17_4.objectives[1]
			local level_id = var_17_5.level_id
			local level_key = LevelSettings[level_id].level_key
			local wind = var_17_4.wind

			if not var_17_1.is_arena then
				local _level_key = self._level_key
				local loading_ui_package_name = LevelSettings[_level_key].loading_ui_package_name

				self._ui_package_name = "resource_packages/loading_screens/" .. loading_ui_package_name
				self._loading_material_path = nil
				self._loading_material_name = nil
			else
				self._ui_package_name = "resource_packages/loading_screens/" .. "weaves/" .. level_key .. "/" .. level_key .. "_" .. wind
				self._loading_material_path = "weaves/" .. level_key .. "/" .. level_key .. "_" .. wind
				self._loading_material_name = level_key .. "_" .. wind
			end

			self._weave_data = {
				weave_display_name = var_17_4.display_name,
				location_display_name = var_17_1.display_name,
				wind_name = var_17_4.wind,
				is_arena = var_17_1.is_arena,
				objective_name = var_17_5.display_name
			}
		else
			local loading_ui_package_name_2 = LevelSettings[arg_17_1].loading_ui_package_name

			self._ui_package_name = "resource_packages/loading_screens/" .. loading_ui_package_name_2
			self._loading_material_path = nil
			self._loading_material_name = nil
			self._weave_data = nil
		end

		local var_17_12

		if not (package:has_loaded(self._ui_package_name) or package:has_loaded(self._ui_package_name, "global_loading_screens")) then
			package:load(self._ui_package_name, "global_loading_screens", callback(self, "cb_loading_screen_loaded", self._level_key, var_17_12), true, true)
		else
			self:cb_loading_screen_loaded(self._level_key, var_17_12, true)
		end
	end

	self._loading_view_setup_is_done = true
end

StateLoading.loading_view_setup_done = function (self)
	-- function 18
	return self._loading_view_setup_is_done
end

StateLoading.setup_menu_assets = function (self)
	-- function 19
	local str = "menu_assets"
	local str_2 = "resource_packages/menu_assets"
	local package = Managers.package
	local has_loaded = package:has_loaded(str_2, str)

	has_loaded = has_loaded or package:is_loading(str_2, str)

	local var_19_4

	if not has_loaded then
		var_19_4 = str_2
	end

	if not var_19_4 then
		package:load(var_19_4, str, nil, true, true)

		self._ui_loading_package_reference_name = str
		self._ui_loading_package_path = var_19_4
	end

	self._menu_setup_done = true
end

StateLoading.menu_assets_setup_done = function (self)
	-- function 20
	return self._menu_setup_done
end

StateLoading.cb_loading_screen_loaded = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	if self._first_time_view or not self._level_end_view_wrappers then
		local _get_game_difficulty = self:_get_game_difficulty()

		self._loading_view:texture_resource_loaded(arg_21_1, arg_21_2, _get_game_difficulty, self._loading_material_path, self._loading_material_name, self._weave_data)
	elseif not arg_21_3 then
		self:cb_loading_screen_change_fade(arg_21_1, arg_21_2, arg_21_3)
	else
		Managers.transition:fade_in(3, callback(self, "cb_loading_screen_change_fade", arg_21_1, arg_21_2))
	end
end

StateLoading.cb_loading_screen_change_fade = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local _get_game_difficulty = self:_get_game_difficulty()

	self._loading_view:texture_resource_loaded(arg_22_1, arg_22_2, _get_game_difficulty, self._loading_material_path, self._loading_material_name, self._weave_data)
	self:_trigger_loading_view(arg_22_1, arg_22_2)

	if not arg_22_3 then
		Managers.transition:fade_out(3)
	end
end

StateLoading._trigger_sound_events = function (self, arg_23_1)
	-- function 23
	local loading_screen_wwise_events = LevelSettings[arg_23_1].loading_screen_wwise_events
	local var_23_1

	if not loading_screen_wwise_events then
		local _network_server = self._network_server
		local _network_client = self._network_client
		local profile_synchronizer

		if not _network_server then
			profile_synchronizer = _network_server.profile_synchronizer

			if not profile_synchronizer then
				-- Nothing
			end
		end

		profile_synchronizer = not _network_client and _network_client.profile_synchronizer

		::label_23_0::

		if not profile_synchronizer then
			local get_peers_with_full_profiles = profile_synchronizer:get_peers_with_full_profiles()

			for i = 1, #get_peers_with_full_profiles do
				local var_23_6 = get_peers_with_full_profiles[i]
				local profile_index = var_23_6.profile_index
				local career_index = var_23_6.career_index
				local var_23_9 = SPProfiles[profile_index]
				local flag = not var_23_9 and var_23_9.careers[career_index]
				local flag_2 = not flag and flag.name

				if not loading_screen_wwise_events[flag_2] then
					var_23_1 = var_23_1 or {}

					table.append(var_23_1, loading_screen_wwise_events[flag_2])
				end
			end
		end
	end

	local flag_3 = var_23_1 or loading_screen_wwise_events

	if not (flag_3 == nil or not (#flag_3 > 0)) then
		local get_current_level_seed = Managers.level_transition_handler:get_current_level_seed()
		local next_random, var_23_15 = Math.next_random(get_current_level_seed, 1, #flag_3)
		local var_23_16 = flag_3[var_23_15]

		if not script_data.disable_level_intro_dialogue then
			local trigger_event, var_23_18 = Managers.music:trigger_event(var_23_16)

			self.wwise_playing_id = trigger_event
		end

		return var_23_16
	end
end

StateLoading._trigger_weave_sound_events = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local var_24_0
	local var_24_1 = LevelSettings[arg_24_2]
	local wind = arg_24_1.wind
	local loading_screen_wwise_events = WindSettings[wind].loading_screen_wwise_events

	if not arg_24_3 then
		local var_24_4 = loading_screen_wwise_events.primary_arena_wwise_events[Math.random(#loading_screen_wwise_events.primary_arena_wwise_events)]
		local var_24_5 = loading_screen_wwise_events.secondary_arena_wwise_events[Math.random(#loading_screen_wwise_events.secondary_arena_wwise_events)]

		var_24_0 = {
			var_24_4,
			var_24_5
		}
	else
		local var_24_6 = loading_screen_wwise_events.lore[Math.random(#loading_screen_wwise_events.lore)]
		local var_24_7 = loading_screen_wwise_events.mechanics[Math.random(#loading_screen_wwise_events.mechanics)]
		local var_24_8

		if not var_24_1.is_arena then
			local num = 1
			local display_name = arg_24_1.objectives[num].display_name
			local var_24_11 = loading_screen_wwise_events.objectives[display_name]

			var_24_8 = var_24_11[Math.random(#var_24_11)]
		end

		var_24_0 = {
			var_24_6,
			var_24_7,
			var_24_8
		}
	end

	Managers.music:stop_event_queue("weave_loading_vo")

	local num_2 = 0.5

	if not script_data.disable_level_intro_dialogue then
		local trigger_event_queue, var_24_14 = Managers.music:trigger_event_queue("weave_loading_vo", var_24_0, num_2)

		self.wwise_playing_id = trigger_event_queue
	end

	return var_24_0
end

StateLoading._setup_state_machine = function (self)
	-- function 25
	local tbl = {
		world = self._world,
		viewport = self._viewport,
		loading_view = self._loading_view,
		starting_tutorial = self._switch_to_tutorial_backend
	}

	if not self.parent.loading_context.restart_network then
		self._machine = GameStateMachine:new(self, StateLoadingRestartNetwork, tbl, true)
	elseif not self.parent.loading_context.host_migration_info then
		self._machine = GameStateMachine:new(self, StateLoadingMigrateHost, tbl, true)
	elseif not self.parent.loading_context.versus_migration then
		self._machine = GameStateMachine:new(self, StateLoadingVersusMigration, tbl, true)
	else
		self._machine = GameStateMachine:new(self, StateLoadingRunning, tbl, true)
	end
end

StateLoading._handle_do_reload = function (self)
	-- function 26
	if not self.wwise_playing_id then
		Managers.music:stop_event_id(self.wwise_playing_id)

		self.wwise_playing_id = nil
	end

	if not flag and not self._wwise_event then
		self.wwise_playing_id = Managers.music:trigger_event(self._wwise_event)
		flag = false
	elseif not flag and not self._weave_wwise_events then
		Managers.music:stop_event_queue("weave_loading_vo")

		local num = 0.5

		self.wwise_playing_id = Managers.music:trigger_event_queue("weave_loading_vo", self._weave_wwise_events, num)
		flag = false
	end
end

StateLoading.set_invitation_error = function (self)
	-- function 27
	self._has_invitation_error = true
end

StateLoading.update = function (self, arg_28_1, arg_28_2)
	-- function 28
	if not script_data.subtitle_debug then
		self:_handle_do_reload()
	end

	Network.update_receive(arg_28_1, self._network_event_delegate.event_table)
	self:_update_network(arg_28_1, arg_28_2)

	local level_transition_handler = Managers.level_transition_handler

	if not IS_PS4 and (self._popup_id or self._handled_psn_client_error or not self:_update_loading_global_packages()) and not level_transition_handler:all_packages_loaded() and not level_transition_handler.enemy_package_loader:loading_completed() and not level_transition_handler.pickup_package_loader:loading_completed() and not level_transition_handler.transient_package_loader:loading_completed() and not level_transition_handler.general_synced_package_loader:loading_completed() and not Managers.backend:profiles_loaded() then
		local psn_client_error = Managers.account:psn_client_error()

		if not psn_client_error then
			printf("[StateLoading] PSN CLIENT ERROR %s", psn_client_error)
			self:create_popup("failure_psn_client_error", "popup_error_topic", "restart_as_server", "menu_accept")

			self._handled_psn_client_error = true
			self._wanted_state = StateTitleScreen
		end
	end

	if not (not IS_CONSOLE and not self._has_invitation_error and self._popup_id) then
		self:create_popup("invite_broken", "invite_error", "restart_as_server", "menu_accept")

		self._wanted_state = StateTitleScreen
		self._has_invitation_error = false
	end

	if not script_data.debug_enabled then
		VisualAssertLog.update(arg_28_1)
	end

	Managers.backend:update(arg_28_1, arg_28_2)
	Managers.input:update(arg_28_1)
	level_transition_handler:update(arg_28_1)

	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if not self._should_start_breed_loading and not level_transition_handler:all_packages_loaded() then
		local enemy_package_loader = level_transition_handler.enemy_package_loader
		local var_28_4 = enemy_package_loader
		local matching_session = enemy_package_loader.matching_session
		local _network_server = self._network_server

		_network_server = _network_server or self._network_client

		if not matching_session(var_28_4, _network_server) and not query_lobby and not query_lobby.is_host and not query_lobby:network_initialized() then
			local get_next_weave = Managers.weave:get_next_weave()

			get_next_weave = get_next_weave or Development.parameter("weave_name")

			local get_next_objective = Managers.weave:get_next_objective()

			get_next_objective = get_next_objective or 1

			local var_28_9 = WeaveSettings.templates[get_next_weave]
			local get_current_level_key = level_transition_handler:get_current_level_key()
			local hub_level = LevelSettings[get_current_level_key].hub_level

			if not (not var_28_9 and hub_level) then
				ConflictUtils.patch_terror_events_with_weaves(get_current_level_key, var_28_9, get_next_objective)
			end

			if not self._network_server then
				local get_current_level_seed = level_transition_handler:get_current_level_seed()
				local get_current_locked_director_functions = level_transition_handler:get_current_locked_director_functions()
				local get_current_conflict_director = level_transition_handler:get_current_conflict_director()
				local get_current_difficulty = level_transition_handler:get_current_difficulty()
				local get_current_difficulty_tweak = level_transition_handler:get_current_difficulty_tweak()
				local uses_random_directors = Managers.mechanism:uses_random_directors()

				level_transition_handler.enemy_package_loader:setup_startup_enemies(get_current_level_key, get_current_level_seed, get_current_locked_director_functions, uses_random_directors, get_current_conflict_director, get_current_difficulty, get_current_difficulty_tweak)
			end

			self._should_start_breed_loading = nil
		end
	end

	Managers.music:update(arg_28_1, arg_28_2)

	if not Managers.voice_chat then
		Managers.voice_chat:update(arg_28_1, arg_28_2)
	end

	if not self._level_end_view_wrappers then
		local var_28_18 = self._level_end_view_wrappers[1]

		var_28_18:update(arg_28_1, arg_28_2)

		if not var_28_18:done() then
			if not var_28_18:do_retry() then
				self._wanted_state = StateLoading
				self._do_reload = true
			end

			self:_tear_down_level_end_view_wrappers()
			Managers.weave:clear_weave_data()
		end
	elseif not self._first_time_view then
		self._first_time_view:update(arg_28_1, arg_28_2)
	elseif not (not self._loading_view and self._do_reload) then
		if not self._activate_loading_view then
			self._loading_view:activate()
			Managers.transition:fade_out(GameSettings.transition_fade_out_speed)

			self._activate_loading_view = nil
		end

		self._loading_view:update(arg_28_1)
	end

	self:_update_loading_screen(arg_28_1, arg_28_2)
	self._machine:update(arg_28_1, arg_28_2)
	self:_update_lobbies(arg_28_1, arg_28_2)

	if not Managers.matchmaking then
		Managers.matchmaking:update(arg_28_1, arg_28_2)
	end

	if not Managers.game_server then
		Managers.game_server:update(arg_28_1, arg_28_2)
	end

	if Managers.eac ~= nil then
		Managers.eac:update(arg_28_1, arg_28_2)
	end

	local flag = false
	local var_28_20

	if not self._level_end_view_wrappers then
		local var_28_21 = self._level_end_view_wrappers[1]

		if not var_28_21:enable_chat() then
			flag = true
			var_28_20 = var_28_21:active_input_service()
		end
	end

	Managers.chat:update(arg_28_1, arg_28_2, flag, var_28_20)
	Network.update_transmit(arg_28_1)

	return self:_try_next_state(arg_28_1)
end

StateLoading._update_network = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not self._network_server then
		self._network_server:update(arg_29_1, arg_29_2)

		if not (not self._network_server:disconnected() and self._popup_id) then
			local _get_lost_connection_text_id = self:_get_lost_connection_text_id()

			self:create_popup(_get_lost_connection_text_id, "popup_error_topic", "restart_as_server", "menu_accept")
			self:_destroy_network_handler(false)
			self:_destroy_lobby_host()
		end
	elseif not self._network_client then
		self._network_client:update(arg_29_1, arg_29_2)

		if not (not self._network_client:is_in_post_game() and self._in_post_game_popup_id or self._in_post_game_popup_shown) then
			self._in_post_game_popup_id = Managers.popup:queue_popup(Localize("popup_is_in_post_game"), Localize("matchmaking_status_waiting_for_host"), "return_to_inn", Localize("return_to_inn"))
			self._in_post_game_popup_shown = true

			Managers.popup:activate_timer(self._in_post_game_popup_id, 200, "timeout", "center", false, function (arg_30_0)
				-- function 30
				return string.format(Localize("timer_max_time") .. ": %.2d:%.2d", arg_30_0 / 60 % 60, arg_30_0 % 60)
			end, 28)
		elseif self._network_client:is_in_post_game() or not self._in_post_game_popup_id then
			Managers.popup:cancel_popup(self._in_post_game_popup_id)

			self._in_post_game_popup_id = nil
		end

		local has_bad_state, var_29_2 = self._network_client:has_bad_state()

		if not (not has_bad_state and self._popup_id) then
			print("bad_state:", var_29_2)

			self._wanted_state = StateTitleScreen

			if not self._in_post_game_popup_id then
				Managers.popup:cancel_popup(self._in_post_game_popup_id)

				self._in_post_game_popup_id = nil
			end

			local fail_reason = self._network_client.fail_reason

			fail_reason = fail_reason or "broken_connection"

			self:_destroy_network_handler(false)

			if not Managers.lobby:query_lobby("matchmaking_session_lobby") then
				self:create_popup(fail_reason, "popup_error_topic", "restart_as_server", "menu_accept")
				self:_destroy_lobby_client()
			end
		end
	end
end

StateLoading._get_lost_connection_text_id = function (arg_31_0)
	-- function 31
	local var_31_0
	local flag

	flag = (IS_WINDOWS or not IS_LINUX or not rawget(_G, "Steam")) and ("failure_start_no_steam" or "broken_connection") or not IS_XB1 and (Network.xboxlive_client_exists() or not "failure_start_xbox_live_client" or "failure_start_xbox_lobby_create") and not IS_PS4 or "failure_psn_client_error" or "failure_start"

	return flag
end

StateLoading._update_lobbies = function (self, arg_32_1, arg_32_2)
	-- function 32
	if not self:_update_loading_global_packages() then
		return
	end

	if not self._network_transmit then
		self._network_transmit:transmit_local_rpcs()
	end

	if self._password_request ~= nil then
		self._password_request:update(arg_32_1)

		local result, var_32_1, var_32_2 = self._password_request:result()

		if result ~= nil then
			if result == "join" then
				Managers.lobby:make_lobby(GameServerLobbyClient, "matchmaking_join_lobby", "StateLoading (GameServerLobbyClient)", var_32_1.network_options, var_32_1.game_server_data, var_32_2)
			else
				self._teardown_network = true
				self._permission_to_go_to_next_state = true
				self._wanted_state = StateTitleScreen
			end

			self._password_request:destroy()

			self._password_request = nil
		end
	end

	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")
	local query_lobby_2 = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not query_lobby and not query_lobby.is_host then
		query_lobby:update(arg_32_1)

		if not (not query_lobby:is_joined() and query_lobby:network_initialized() or query_lobby:lobby_host() == "0") then
			if not self._network_server then
				self:host_joined()
			end

			local peer_id = Network.peer_id()
			local lobby_host = query_lobby:lobby_host()
			local flag = true
			local _network_server = self._network_server

			assert(lobby_host == peer_id, "Is not host of own lobby")
			self:setup_chat_manager(query_lobby, lobby_host, peer_id, flag)
			self:setup_deed_manager(query_lobby, lobby_host, peer_id, flag, _network_server)
			self:setup_enemy_package_loader(query_lobby, lobby_host, peer_id, _network_server)
			self:setup_global_managers(query_lobby, lobby_host, peer_id, flag, _network_server)
			query_lobby:set_network_initialized(true)
		elseif not (query_lobby.state ~= LobbyState.FAILED or self._popup_id) then
			local var_32_9
			local flag_2

			flag_2 = (IS_WINDOWS or not IS_LINUX or not rawget(_G, "Steam")) and (not Steam.connected() and "failure_start_steam_lobby_create" and "failure_start_no_steam" or "failure_start_no_lan") or not IS_XB1 and (Network.xboxlive_client_exists() or not "failure_start_xbox_live_client" or "failure_start_xbox_lobby_create") and not IS_PS4 or "failure_start_psn_lobby_create" or "failure_start"

			if not self._network_server then
				self._network_server:disconnect_all_peers("unknown_error")
				self:_destroy_network_handler(false)
			end

			self:_destroy_lobby_host()
			self:create_popup(flag_2, "popup_error_topic", "restart_as_server", "menu_accept")
		end
	elseif not self._lobby_finder then
		self:_update_lobby_join(arg_32_1, arg_32_2)
	elseif not query_lobby_2 then
		self:_update_server_lobby_join(arg_32_1, arg_32_2)
	elseif not query_lobby then
		query_lobby:update(arg_32_1)

		local state = query_lobby.state

		if self._lobby_verified or not query_lobby:is_joined() then
			self:_verify_joined_lobby(arg_32_1, arg_32_2)
		elseif not (not query_lobby:failed() and self._popup_id) then
			self:_destroy_lobby_client()
			self:create_popup("failure_start_join_server", "popup_error_topic", "restart_as_server", "menu_accept")
			Managers.transition:fade_out(GameSettings.transition_fade_out_speed)
		end
	end

	if not (not IS_XB1 and not self._waiting_for_cleanup and not Managers.account:all_sessions_cleaned_up() and not (arg_32_2 > self._cleanup_wait_time)) then
		self._cleanup_done_func()

		self._waiting_for_cleanup = nil
		self._cleanup_done_func = nil
	end
end

StateLoading._verify_joined_lobby = function (self, arg_33_1, arg_33_2)
	-- function 33
	if not (not IS_XB1 and self:_update_xbox_lobby_data(arg_33_1, arg_33_2)) then
		return
	end

	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local lobby_host = get_lobby:lobby_host()
	local get_stored_lobby_data = get_lobby:get_stored_lobby_data()
	local id = get_stored_lobby_data.id
	local network_hash = get_stored_lobby_data.network_hash
	local matchmaking_type = get_stored_lobby_data.matchmaking_type
	local difficulty = get_stored_lobby_data.difficulty
	local mechanism = get_stored_lobby_data.mechanism
	local weave_quick_game = get_stored_lobby_data.weave_quick_game
	local is_lobby_private = MatchmakingManager.is_lobby_private(get_stored_lobby_data)

	if not id then
		network_hash = LobbyInternal.get_lobby_data_from_id_by_key(id, "network_hash") or network_hash
		matchmaking_type = LobbyInternal.get_lobby_data_from_id_by_key(id, "matchmaking_type") or matchmaking_type
		difficulty = LobbyInternal.get_lobby_data_from_id_by_key(id, "difficulty") or difficulty
		mechanism = LobbyInternal.get_lobby_data_from_id_by_key(id, "mechanism") or mechanism
		weave_quick_game = LobbyInternal.get_lobby_data_from_id_by_key(id, "weave_quick_game") or weave_quick_game
		is_lobby_private = LobbyInternal.get_lobby_data_from_id_by_key(id, "is_private") == "true" or is_lobby_private
	end

	network_hash = network_hash or get_lobby:lobby_data("network_hash")
	matchmaking_type = matchmaking_type or get_lobby:lobby_data("matchmaking_type")
	difficulty = difficulty or get_lobby:lobby_data("difficulty")
	mechanism = mechanism or get_lobby:lobby_data("mechanism")
	weave_quick_game = weave_quick_game or get_lobby:lobby_data("weave_quick_game")
	is_lobby_private = is_lobby_private or get_lobby:lobby_data("is_private") == "true"

	local flag = not IS_PS4 and matchmaking_type and not matchmaking_type or NetworkLookup.game_modes[tonumber(matchmaking_type)]

	if not ((lobby_host == "0" or not network_hash) and not flag and not difficulty and self._popup_id == nil) then
		local network_hash_2 = get_lobby.network_hash
		local flag_2 = true
		local tbl = {}
		local var_33_14 = MechanismSettings[mechanism]

		var_33_14 = var_33_14 or {}

		if not var_33_14.required_dlc then
			tbl[var_33_14.required_dlc] = true
		end

		for k, v in pairs(tbl) do
			if not Managers.unlock:is_dlc_unlocked(k) then
				flag_2 = false

				break
			end
		end

		local flag_3 = true

		if not ((script_data.unlock_all_levels or not var_33_14.extra_requirements_function) and var_33_14.extra_requirements_function()) then
			flag_3 = false
		end

		local flag_4 = true
		local str = ""

		if not (Development.parameter("unlock_all_difficulties") or is_lobby_private or var_33_14.disable_difficulty_check) then
			local best_aquired_power_level = BulldozerPlayer.best_aquired_power_level()
			local var_33_19 = DifficultySettings[difficulty]

			if best_aquired_power_level < var_33_19.required_power_level then
				flag_4 = false

				local var_33_20 = Localize("required_power_level")

				str = string.format("* %s: %s", var_33_20, tostring(UIUtils.presentable_hero_power_level(var_33_19.required_power_level)))
			end

			if not var_33_19.extra_requirement_name then
				local flag_5 = true
				local var_33_22 = ExtraDifficultyRequirements[var_33_19.extra_requirement_name]

				if not (var_33_22.requirement_function(flag_5) or weave_quick_game == "true") then
					flag_4 = false
					str = str .. string.format("\n* %s", Localize(var_33_22.description_text))
				end
			end
		end

		if not flag_2 then
			self:_destroy_lobby_client()
			self:create_popup("failure_start_join_server_required_dlc_missing", "popup_error_topic", "restart_as_server", "menu_accept")
		elseif not flag_3 then
			self:_destroy_lobby_client()
			self:create_popup("failure_start_join_server_game_mode_requirements_failed", "popup_error_topic", "restart_as_server", "menu_accept")
		elseif not flag_4 then
			self:_destroy_lobby_client()

			local str_2 = "failure_start_join_server_difficulty_requirements_failed"

			self:create_popup(str_2, "popup_error_topic", "restart_as_server", "menu_accept", str)
		elseif network_hash_2 == network_hash or not Development.parameter("force_ignore_network_hash") then
			if not self._handle_new_lobby_connection then
				self:setup_network_client(self._joined_matchmaking_lobby)

				local peer_id = Network.peer_id()
				local flag_6 = false
				local _network_client = self._network_client

				assert(lobby_host ~= peer_id, "Is host of someone elses lobby")
				self:setup_chat_manager(get_lobby, lobby_host, peer_id, flag_6)
				self:setup_deed_manager(get_lobby, lobby_host, peer_id, flag_6, _network_client)
				self:setup_enemy_package_loader(get_lobby, lobby_host, peer_id, _network_client)
				self:setup_global_managers(get_lobby, lobby_host, peer_id, flag_6, _network_client)
			end
		else
			self:_destroy_lobby_client()
			self:create_popup("failure_start_join_server_incorrect_hash", "popup_error_topic", "restart_as_server", "menu_accept", network_hash_2, network_hash)
		end

		self._lobby_verified = true
	elseif not IS_XB1 then
		self._xbox_lobby_data_state = "SET_COOLDOWN"
	end
end

local num_2 = 4

StateLoading._update_xbox_lobby_data = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _xbox_lobby_data_state = self._xbox_lobby_data_state

	if _xbox_lobby_data_state == "SET_COOLDOWN" then
		self._xbox_lobby_cooldown = arg_34_2 + num_2
		_xbox_lobby_data_state = "WAIT_FOR_COOLDOWN"
	elseif _xbox_lobby_data_state == "WAIT_FOR_COOLDOWN" then
		if arg_34_2 > self._xbox_lobby_cooldown then
			_xbox_lobby_data_state = "UPDATE_LOBBY_DATA"
		end
	elseif _xbox_lobby_data_state == "UPDATE_LOBBY_DATA" then
		Managers.lobby:get_lobby("matchmaking_session_lobby"):force_update_lobby_data()

		_xbox_lobby_data_state = "WAIT_FOR_LOBBY_UPDATE"
	elseif not (_xbox_lobby_data_state ~= "WAIT_FOR_LOBBY_UPDATE" or Managers.lobby:get_lobby("matchmaking_session_lobby"):is_updating_lobby_data()) then
		_xbox_lobby_data_state = "DONE"
	end

	self._xbox_lobby_data_state = _xbox_lobby_data_state or "DONE"

	return _xbox_lobby_data_state == "DONE"
end

StateLoading.lobby_verified = function (self)
	-- function 35
	return self._lobby_verified
end

StateLoading._destroy_lobby_client = function (self)
	-- function 36
	Managers.lobby:destroy_lobby("matchmaking_session_lobby")
	Managers.account:set_current_lobby(nil)

	if not self._voip then
		self._voip:destroy()

		self._voip = nil
	end

	if not self._level_end_view_wrappers then
		for i, v in ipairs(self._level_end_view_wrappers) do
			v:left_lobby()
		end
	end

	self._wanted_state = StateTitleScreen
end

StateLoading._destroy_lobby_host = function (self)
	-- function 37
	Managers.lobby:destroy_lobby("matchmaking_session_lobby")
	Managers.account:set_current_lobby(nil)

	if not Managers.matchmaking then
		if not self._registered_rpcs then
			Managers.matchmaking:unregister_rpcs()
		end

		Managers.matchmaking:destroy()

		Managers.matchmaking = nil
	end

	self._wanted_state = StateTitleScreen
end

StateLoading._update_lobby_join = function (self, arg_38_1, arg_38_2)
	-- function 38
	local parameter = Development.parameter("unique_server_name")
	local flag = false
	local _lobby_finder = self._lobby_finder

	_lobby_finder:update(arg_38_1)

	local lobbies = _lobby_finder:lobbies()

	for i, v in ipairs(lobbies) do
		local flag_2 = false

		if not ((self._lobby_to_join or self._host_to_join or not parameter) and v.unique_server_name ~= parameter) then
			flag_2 = true
		elseif not (not self._lobby_to_join and self._lobby_to_join ~= v.id) then
			flag_2 = true
		elseif not (not self._host_to_join and self._host_to_join ~= v.host) then
			flag_2 = true
		end

		if not v.valid and not flag_2 then
			print("=======================Autojoining this lobby")

			local network_options = LobbySetup.network_options()
			local make_lobby = Managers.lobby:make_lobby(LobbyClient, "matchmaking_session_lobby", "StateLoading (_update_lobby_join)", network_options, v)

			self._lobby_finder:destroy()

			self._lobby_finder = nil
			self._handle_new_lobby_connection = true
			flag = true

			Managers.account:set_current_lobby(make_lobby.lobby)

			if not self._lobby_joined_callback then
				self._lobby_joined_callback()

				self._lobby_joined_callback = nil
			end

			break
		end
	end

	if not (flag or not (arg_38_2 > self._lobby_finder_timeout) or self._popup_id) then
		self._lobby_finder:destroy()

		self._lobby_finder = nil

		local _host_to_join_name = self._host_to_join_name

		_host_to_join_name = _host_to_join_name or Development.parameter("unique_server_name")

		self:create_popup("failure_start_join_server_timeout", "failure_find_host", "restart_as_server", "menu_accept", _host_to_join_name)

		self._wanted_state = StateTitleScreen
	end

	if not (not self._lobby_finder and flag or not (arg_38_2 > self._lobby_finder_refresh_timer)) then
		printf("=======================Refresh lobby_finder search")
		self._lobby_finder:refresh()

		self._lobby_finder_refresh_timer = arg_38_2 + StateLoading.join_lobby_refresh_interval
	end
end

StateLoading._update_server_lobby_join = function (self, arg_39_1, arg_39_2)
	-- function 39
	local get_lobby = Managers.lobby:get_lobby("matchmaking_join_lobby")

	get_lobby:update(arg_39_1)

	if not get_lobby:is_joined() then
		Managers.lobby:move_lobby("matchmaking_join_lobby", "matchmaking_session_lobby")

		self._handle_new_lobby_connection = true

		Managers.account:set_current_lobby(get_lobby.lobby)

		if not self._lobby_joined_callback then
			self._lobby_joined_callback()

			self._lobby_joined_callback = nil
		end

		return
	elseif not get_lobby:failed() then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
		self:create_popup("failure_start_join_server", "popup_error_topic", "restart_as_server", "menu_accept")
		Managers.transition:fade_out(GameSettings.transition_fade_out_speed)

		self._wanted_state = StateTitleScreen

		return
	end

	if not (not (arg_39_2 > self._lobby_finder_timeout) or self._popup_id) then
		local id = get_lobby:id()

		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
		self:create_popup("failure_start_join_server_timeout", "failure_find_host", "restart_as_server", "menu_accept", id)

		self._wanted_state = StateTitleScreen
	end
end

StateLoading._update_loading_screen = function (self, arg_40_1, arg_40_2)
	-- function 40
	local var_40_0

	if not self._network_server then
		if not Managers.lobby:get_lobby("matchmaking_session_lobby"):is_joined() and not self._network_server:waiting_to_enter_game() then
			var_40_0 = true
		end
	elseif not (not self._network_client and self._network_client.state ~= NetworkClientStates.waiting_enter_game) then
		var_40_0 = true
	end

	local flag = false

	if not (not script_data.subtitle_debug and DEDICATED_SERVER) then
		flag = not (Mouse.button(Mouse.button_index("left")) ~= 1 or Mouse.button(Mouse.button_index("right")) == 1)

		if not var_40_0 and not flag then
			Debug.text("[SubtitleDebug] Waiting for both mouse buttons to progress...")
		end
	end

	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()

	if not var_40_0 and self._permission_to_go_to_next_state and flag or not get_current_level_keys then
		local var_40_3 = NetworkLookup.level_keys[get_current_level_keys]

		if not self._network_server then
			self._network_server.network_transmit:send_rpc("rpc_level_loaded", Network.peer_id(), var_40_3)
		end

		Managers.mechanism:load_packages()

		self._permission_to_go_to_next_state = var_40_0
	end
end

StateLoading._try_next_state = function (self, arg_41_1)
	-- function 41
	if not self._popup_id then
		self:_handle_popup()
	end

	if not self._join_popup_id then
		self:_handle_join_popup()
	end

	if not (not self._in_post_game_popup_id and Managers.account:leaving_game()) then
		self:_handle_in_post_game_popup()
	elseif not self._in_post_game_popup_id then
		Managers.popup:cancel_popup(self._in_post_game_popup_id)
	end

	if not script_data.honduras_demo and not Managers.time:get_demo_transition() then
		self._teardown_network = true
		self._join_popup_id = nil
		self._permission_to_go_to_next_state = true

		if not self._first_time_view then
			self._first_time_view:force_done()
		end

		self._new_state = StateTitleScreen
	end

	if not Managers.account:leaving_game() then
		if not self._ui_package_name and not self._ui_package_name and not Managers.package:has_loaded(self._ui_package_name) then
			if not self._first_time_view then
				self._first_time_view:destroy()

				self._first_time_view = nil
			end

			Managers.transition:show_loading_icon()

			Managers.transition._callback = nil

			Managers.transition:force_fade_in()

			self._teardown_network = true
			self._new_state = StateTitleScreen
		end
	elseif not self.offline_invite then
		self._teardown_network = true
		self._join_popup_id = nil
		self._permission_to_go_to_next_state = true

		if not self._first_time_view then
			self._first_time_view:force_done()
		end

		self._new_state = StateTitleScreen
	elseif not self._transitioning then
		local flag = true

		if not self._first_time_view then
			flag = self._first_time_view:is_done()

			if not flag and self._popup_id and self:_packages_loaded() or not self._level_key then
				self:_trigger_loading_view(self._level_key)
				Managers.transition:show_loading_icon()
				self._first_time_view:destroy()

				self._first_time_view = nil

				Managers.chat:enable_gui(true)
			end
		elseif not self._loading_view then
			flag = self._loading_view:is_done()
		end

		if not self._level_end_view_wrappers then
			flag = self:_level_end_view_done()
		end

		local backend = Managers.backend

		if not (not backend:is_disconnected() and self._popup_id) then
			self:_backend_broken()
		end

		if not backend:is_waiting_for_user_input() then
			return
		end

		local _packages_loaded = self:_packages_loaded()

		if not (not _packages_loaded and self._async_level_spawner) then
			local level_transition_handler = Managers.level_transition_handler
			local INGAME_WORLD_NAME = LevelHelper.INGAME_WORLD_NAME
			local get_current_level_keys = level_transition_handler:get_current_level_keys()
			local level_name = LevelSettings[get_current_level_keys].level_name

			printf("Starting async level spawning of %s", level_name)

			local get_current_game_mode = level_transition_handler:get_current_game_mode()
			local get_object_sets, var_41_9 = GameModeHelper.get_object_sets(level_name, get_current_game_mode)
			local num = 0.02

			self._async_level_spawner = AsyncLevelSpawner:new(INGAME_WORLD_NAME, level_name, var_41_9, num)
		end

		if not (not self._async_level_spawner and self._level_spawned) then
			local update, var_41_12, var_41_13 = self._async_level_spawner:update()

			if not update then
				print("Async level spawning done")

				self._level_spawned = true
				self._ingame_world_object = var_41_12
				self._ingame_level_object = var_41_13

				local set_data = Level.set_data
				local var_41_15 = var_41_13
				local str = "intro_wwise_id"
				local wwise_playing_id = self.wwise_playing_id

				wwise_playing_id = wwise_playing_id or WwiseUtils.EVENT_ID_NONE

				set_data(var_41_15, str, wwise_playing_id)
				print("Spawn additional sub_levels:")

				local level_transition_handler_2 = Managers.level_transition_handler
				local get_current_level_keys_2 = level_transition_handler_2:get_current_level_keys()
				local hero_specific_sublevels = LevelSettings[get_current_level_keys_2].hero_specific_sublevels

				if not hero_specific_sublevels then
					local var_41_21 = hero_specific_sublevels[level_transition_handler_2.selected_hero_name_on_load]

					if not (not var_41_21 and not (#var_41_21 > 0)) then
						local get_current_game_mode_2 = level_transition_handler_2:get_current_game_mode()
						local tbl = {}

						for i = 1, #var_41_21 do
							local var_41_24 = var_41_21[i]
							local get_object_sets_2, var_41_26 = GameModeHelper.get_object_sets(var_41_24, get_current_game_mode_2)
							local spawn_level = ScriptWorld.spawn_level(var_41_12, var_41_24, var_41_26)

							Level.set_data(spawn_level, "parent_level", var_41_13)

							tbl[var_41_24] = spawn_level

							print(var_41_24)
						end

						Level.set_data(var_41_13, "sub_levels", tbl)
					end
				end
			end
		end

		local _wanted_state = self._wanted_state

		_wanted_state = not _wanted_state and not flag and not self._popup_id

		if not _wanted_state then
			local _permission_to_go_to_next_state = self._permission_to_go_to_next_state

			_permission_to_go_to_next_state = not _permission_to_go_to_next_state and not _packages_loaded and self._level_spawned

			local is_disconnected = backend:is_disconnected()

			if _permission_to_go_to_next_state or is_disconnected or not self._teardown_network then
				local var_41_31

				if not script_data.honduras_demo then
					var_41_31 = false

					if not (self._loading_view:showing_press_to_continue() or self._press_to_continue_shown) then
						self._loading_view:show_press_to_continue(true)

						self._press_to_continue_shown = true

						Managers.transition:hide_loading_icon()
					else
						local any_pressed = Managers.input:get_most_recent_device().any_pressed()
						local _demo_continue_pressed = self._demo_continue_pressed

						_demo_continue_pressed = _demo_continue_pressed or any_pressed
						self._demo_continue_pressed = _demo_continue_pressed
						var_41_31 = self._demo_continue_pressed

						if not var_41_31 and not self._loading_view:showing_press_to_continue() then
							self._loading_view:show_press_to_continue(false)
							Managers.transition:show_loading_icon()
						end
					end
				elseif not GameSettingsDevelopment.use_global_chat then
					var_41_31 = Irc.is_connected()
				else
					var_41_31 = true
				end

				if not var_41_31 then
					local _level_end_view_wrappers = self._level_end_view_wrappers

					if not (_level_end_view_wrappers or Managers.transition:fade_state() ~= "out") then
						Managers.transition:fade_in(GameSettings.transition_fade_out_speed)
						printf("[StateLoading] started fadeing in, want to go to state:%s", self._wanted_state.NAME)
					elseif _level_end_view_wrappers or not Managers.transition:fade_in_completed() then
						self._new_state = self._wanted_state

						printf("[StateLoading] fade_in_completed, new state:%s", self._new_state.NAME)

						if not self._join_popup_id then
							Managers.popup:cancel_popup(self._join_popup_id)

							self._join_popup_id = nil
						end
					end
				end
			end
		end
	end

	if not IS_CONSOLE then
		self:_handle_afk_timer(arg_41_1)
	end

	if not ((Managers.popup:has_popup() or Managers.account:user_detached() or not Managers.account:has_popup()) and Managers.account:leaving_game()) then
		return
	end

	Managers.popup:cancel_all_popups()

	return self._new_state
end

StateLoading._handle_afk_timer = function (self, arg_42_1)
	-- function 42
	if not Managers.account:leaving_game() then
		return
	end

	if Managers.account:has_popup() or not self._popup_id then
		local time = Managers.time:time("main")
		local _afk_timer = self._afk_timer

		_afk_timer = _afk_timer or time + num
		self._afk_timer = _afk_timer

		if (not (time > self._afk_timer) or not self._ui_package_name) and not self._ui_package_name and not Managers.package:has_loaded(self._ui_package_name) then
			if not self._first_time_view then
				self._first_time_view:destroy()

				self._first_time_view = nil
			end

			Managers.transition:show_loading_icon()

			Managers.transition._callback = nil

			Managers.transition:force_fade_in()

			self._teardown_network = true
			self._new_state = StateTitleScreen
			self._previous_session_error = "afk_kick"

			Managers.account:initiate_leave_game()
		end
	elseif not self._afk_timer then
		self._afk_timer = nil
	end
end

StateLoading._level_end_view_done = function (self)
	-- function 43
	local var_43_0 = self._level_end_view_wrappers[1]

	return not var_43_0 and var_43_0:done()
end

StateLoading._handle_popup = function (self)
	-- function 44
	local query_result = Managers.popup:query_result(self._popup_id)

	if query_result == "continue" then
		self._popup_id = nil
	elseif query_result == "restart_as_server" then
		self._teardown_network = true
		self._popup_id = nil
		self._permission_to_go_to_next_state = true

		if not self._first_time_view then
			self._first_time_view:force_done()
		end
	elseif query_result == "quit" then
		Boot.quit_game = true
		self._teardown_network = true
		self._popup_id = nil
		self._permission_to_go_to_next_state = true

		if not self._first_time_view then
			self._first_time_view:force_done()
		end
	elseif not query_result then
		printf("[StateLoading:_handle_popup] No such result handled (%s)", query_result)
	end
end

StateLoading._handle_join_popup = function (self)
	-- function 45
	local query_result = Managers.popup:query_result(self._join_popup_id)

	if not (query_result == "cancel" or query_result ~= "timeout") then
		Managers.popup:cancel_popup(self._join_popup_id)

		self._teardown_network = true
		self._join_popup_id = nil
		self._permission_to_go_to_next_state = true

		if not self._first_time_view then
			self._first_time_view:force_done()
		end

		self._new_state = StateTitleScreen
	elseif not query_result then
		printf("[StateLoading:_handle_join_popup] No such result handled (%s)", query_result)
	end
end

StateLoading._handle_in_post_game_popup = function (self)
	-- function 46
	local query_result = Managers.popup:query_result(self._in_post_game_popup_id)

	if not query_result then
		if query_result == "return_to_inn" then
			self._teardown_network = true
			self._restart_network = true
			self._permission_to_go_to_next_state = true

			if not self._first_time_view then
				self._first_time_view:force_done()
			end

			self._wanted_state = StateLoading
		end

		self._in_post_game_popup_id = nil
	end
end

StateLoading._backend_broken = function (self)
	-- function 47
	print("[StateLoading] Backend_broken, returning to StateTitleScreen")

	self._wanted_state = StateTitleScreen
	self._teardown_network = true
	self._permission_to_go_to_next_state = true

	if not self._first_time_view then
		self._first_time_view:force_done()
	end

	if not IS_XB1 then
		Managers.account:initiate_leave_game()
	end
end

StateLoading.on_exit = function (self, arg_48_1)
	-- function 48
	Framerate.set_playing()

	if not self._registered_rpcs then
		self:_unregister_rpcs()
	end

	if self._password_request ~= nil then
		self._password_request:destroy()

		self._password_request = nil
	end

	self._should_start_breed_loading = nil

	local skip_signin = self.parent.loading_context.skip_signin
	local flag = false

	if arg_48_1 or not self._teardown_network then
		self:_destroy_network(arg_48_1)

		flag = true
	else
		local tbl = {
			network_transmit = self._network_transmit,
			checkpoint_data = self._checkpoint_data,
			quickplay_bonus = self._quickplay_bonus,
			level_end_view_wrappers = self._level_end_view_wrappers,
			saved_scoreboard_stats = self._saved_scoreboard_stats,
			host_migration_info = self.parent.loading_context.host_migration_info
		}

		tbl.ingame_world_object, self._ingame_world_object = self._ingame_world_object, tbl.ingame_world_object
		tbl.ingame_level_object, self._ingame_level_object = self._ingame_level_object, tbl.ingame_level_object

		local level_transition_handler = Managers.level_transition_handler
		local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")

		if not get_lobby.is_host then
			local get_current_level_keys = level_transition_handler:get_current_level_keys()
			local get_stored_lobby_data = get_lobby:get_stored_lobby_data()

			get_stored_lobby_data = get_stored_lobby_data or {}
			get_stored_lobby_data.mission_id = get_current_level_keys

			local unique_server_name = get_stored_lobby_data.unique_server_name

			unique_server_name = unique_server_name or LobbyAux.get_unique_server_name()
			get_stored_lobby_data.unique_server_name = unique_server_name

			local host = get_stored_lobby_data.host

			host = host or Network.peer_id()
			get_stored_lobby_data.host = host

			local num_players = get_stored_lobby_data.num_players

			num_players = num_players or 1
			get_stored_lobby_data.num_players = num_players
			get_stored_lobby_data.country_code = Managers.account:region()

			local var_48_10

			if not DEDICATED_SERVER then
				var_48_10 = NetworkLookup.host_types.community_dedicated_server
			else
				var_48_10 = NetworkLookup.host_types.player_hosted
			end

			get_stored_lobby_data.host_type = var_48_10

			get_lobby:set_lobby_data(get_stored_lobby_data)

			if not get_lobby:is_dedicated_server() then
				get_lobby:set_level_name(Localize(LevelSettings[get_current_level_keys].display_name))
			end

			tbl.network_server = self._network_server

			self._network_server:unregister_rpcs()
			self._network_server.voip:set_input_manager(nil)
		else
			tbl.network_client = self._network_client

			self._network_client:unregister_rpcs()
			self._network_client.voip:set_input_manager(nil)
		end

		if not self._do_reload then
			local weave = Managers.weave
			local num = 1
			local get_active_weave = weave:get_active_weave()
			local level_id = WeaveSettings.templates[get_active_weave].objectives[num].level_id
			local num_2 = 0
			local generate_level_seed = Managers.mechanism:generate_level_seed()
			local get_current_difficulty = level_transition_handler:get_current_difficulty()
			local get_current_difficulty_tweak = level_transition_handler:get_current_difficulty_tweak()

			level_transition_handler:set_next_level(level_id, num_2, generate_level_seed, nil, nil, nil, get_current_difficulty, get_current_difficulty_tweak)
			level_transition_handler:promote_next_level_data()
		end

		tbl.show_profile_on_startup = self.parent.loading_context.show_profile_on_startup
		self.parent.loading_context = tbl
	end

	if not self._async_level_spawner then
		self._async_level_spawner:destroy()

		self._async_level_spawner = nil
	end

	if not self._ingame_level_object then
		ScriptWorld.trigger_level_shutdown(self._ingame_level_object)
		ScriptWorld.destroy_level_from_reference(self._ingame_world_object, self._ingame_level_object)

		self._ingame_level_object = nil
	end

	if not self._ingame_world_object then
		Managers.world:destroy_world(self._ingame_world_object)

		self._ingame_world_object = nil
	end

	self._profile_synchronizer = nil

	if not self._network_event_delegate then
		self._network_event_delegate:destroy()

		self._network_event_delegate = nil
	end

	if not self._first_time_view then
		self._first_time_view:destroy()

		self._first_time_view = nil
	end

	if not self._loading_view then
		if not self.parent.loading_context then
			self.parent.loading_context.subtitle_gui = self._loading_view:subtitle_gui()
		end

		self._loading_view:destroy()

		self._loading_view = nil
	end

	self:_tear_down_level_end_view_wrappers()
	self._machine:destroy(arg_48_1)
	Managers.state:destroy()

	if not self.parent.loading_context then
		self.parent.loading_context.host_to_migrate_to = nil
		self.parent.loading_context.restart_network = nil
		self.parent.loading_context.players = nil
		self.parent.loading_context.local_player_index = nil
		self.parent.loading_context.skip_signin = skip_signin
		self.parent.loading_context.previous_session_error = self._previous_session_error

		if not self._restart_network then
			self.parent.loading_context.restart_network = true
		end
	end

	ScriptWorld.destroy_viewport(self._world, self._viewport_name)
	Managers.world:destroy_world(self._world)

	local package = Managers.package

	if not self._ui_package_name and package:has_loaded(self._ui_package_name, "global_loading_screens") and not package:is_loading(self._ui_package_name) then
		package:unload(self._ui_package_name, "global_loading_screens")
	end

	Managers.music:trigger_event("Stop_loading_screen_music")

	if not IS_WINDOWS then
		fassert(arg_48_1 or self._popup_id == nil, "StateLoading added a popup right before exiting")
	else
		Managers.popup:cancel_all_popups()
	end

	Managers.popup:remove_input_manager(arg_48_1)
	Managers.chat:set_input_manager(nil)
	Managers.chat:enable_gui(true)

	if not Managers.play_go:installed() then
		Managers.play_go:set_install_speed("slow")
	end

	if not flag then
		Managers.level_transition_handler:release_level_resources()
	end
end

StateLoading._update_loading_global_packages = function (arg_49_0)
	-- function 49
	return (GlobalResources.update_loading())
end

StateLoading._packages_loaded = function (self)
	-- function 50
	local level_transition_handler = Managers.level_transition_handler

	if not level_transition_handler:all_packages_loaded() and not Managers.backend:profiles_loaded() then
		local _network_server = self._network_server

		if not ((DEDICATED_SERVER or not _network_server) and self._has_sent_level_loaded) then
			self._has_sent_level_loaded = true

			local get_current_level_keys = level_transition_handler:get_current_level_keys()
			local var_50_3 = NetworkLookup.level_keys[get_current_level_keys]

			_network_server.network_transmit:send_rpc("rpc_level_loaded", Network.peer_id(), var_50_3)
		end

		local package = Managers.package

		for i, v in ipairs(GlobalResources) do
			if not package:has_loaded(v) then
				return false
			end
		end

		if not self._should_start_breed_loading then
			return false
		end

		if not level_transition_handler.enemy_package_loader:loading_completed() then
			return false
		end

		if not level_transition_handler.pickup_package_loader:loading_completed() then
			return false
		end

		if not level_transition_handler.general_synced_package_loader:loading_completed() then
			return false
		end

		if not level_transition_handler.transient_package_loader:loading_completed() then
			return false
		end

		if self:_update_loadout_resync() ~= StateLoading.LoadoutResyncStates.DONE then
			return false
		end

		if not (not self._ui_loading_package_path and not self._ui_loading_package_reference_name and package:has_loaded(self._ui_loading_package_path, self._ui_loading_package_reference_name)) then
			return false
		end

		if not Managers.mechanism:is_packages_loaded() then
			return false
		end

		return true
	end

	return false
end

StateLoading.load_current_level = function (self)
	-- function 51
	print("[StateLoading] load_current_level")

	local _already_loaded_once = self._already_loaded_once

	Managers.mechanism:handle_level_load(_already_loaded_once)

	self._already_loaded_once = true

	if not self._network_client then
		self._network_client:set_state(NetworkClientStates.loading)
	end

	Managers.level_transition_handler:load_current_level()

	self._should_start_breed_loading = true

	if not self._async_level_spawner then
		self._async_level_spawner:destroy()

		self._async_level_spawner = nil
	end

	if not self._ingame_level_object then
		ScriptWorld.destroy_level_from_reference(self._ingame_world_object, self._ingame_level_object)

		self._ingame_level_object = nil
	end

	if not self._ingame_world_object then
		Managers.world:destroy_world(self._ingame_world_object)

		self._ingame_world_object = nil
	end

	self._level_spawned = false
	self._permission_to_go_to_next_state = false
	self._has_sent_level_loaded = false

	self:set_loadout_resync_state(StateLoading.LoadoutResyncStates.CHECK_RESYNC)
end

StateLoading._update_loadout_resync = function (self)
	-- function 52
	local loadout_resync_state = self:loadout_resync_state()
	local LoadoutResyncStates = StateLoading.LoadoutResyncStates

	if loadout_resync_state == LoadoutResyncStates.IDLE then
		return loadout_resync_state
	end

	if loadout_resync_state == LoadoutResyncStates.WAIT_FOR_LEVEL_LOAD then
		-- Nothing
	end

	if not ((loadout_resync_state ~= LoadoutResyncStates.CHECK_RESYNC or not self:has_joined() or not Managers.mechanism:can_resync_loadout() or not Managers.backend:is_mirror_ready()) and Managers.backend:is_pending_request()) then
		local level_transition_handler = Managers.level_transition_handler
		local get_current_level_key = level_transition_handler:get_current_level_key()
		local get_current_game_mode = level_transition_handler:get_current_game_mode()

		Managers.backend:get_interface("items"):set_game_mode_specific_items(get_current_game_mode)

		local set_loadout_interface_override, var_52_6, var_52_7 = Managers.backend:set_loadout_interface_override(get_current_game_mode)
		local set_talents_interface_override = Managers.backend:set_talents_interface_override(get_current_game_mode)

		set_loadout_interface_override = set_loadout_interface_override or set_talents_interface_override

		Managers.backend:get_interface("talents"):make_dirty()
		print("[StateLoading] loadout_changed:", set_loadout_interface_override, "old_loadout:", var_52_6, "new_loadout:", var_52_7, "level_key:", get_current_level_key, "game_mode:", get_current_game_mode)
		Managers.mechanism:update_loadout()

		if not set_loadout_interface_override then
			loadout_resync_state = LoadoutResyncStates.NEEDS_RESYNC

			print("[StateLoading] loadout_resync_state CHECK_RESYNC -> NEEDS_RESYNC")
		else
			loadout_resync_state = LoadoutResyncStates.DONE

			print("[StateLoading] loadout_resync_state CHECK_RESYNC -> DONE")
		end
	end

	if loadout_resync_state == LoadoutResyncStates.NEEDS_RESYNC then
		local _network_server = self._network_server
		local _network_client = self._network_client
		local profile_synchronizer

		if not _network_server then
			profile_synchronizer = _network_server.profile_synchronizer

			if not profile_synchronizer then
				-- Nothing
			end
		end

		profile_synchronizer = not _network_client and _network_client.profile_synchronizer

		::label_52_0::

		if not profile_synchronizer then
			local peer_id = Network.peer_id()
			local num = 1
			local flag = false
			local flag_2 = true

			profile_synchronizer:resync_loadout(peer_id, num, flag, flag_2)

			loadout_resync_state = LoadoutResyncStates.RESYNCING

			print("[StateLoading] loadout_resync_state NEEDS_RESYNC -> RESYNCING")
		end
	end

	if loadout_resync_state == LoadoutResyncStates.RESYNCING then
		local _network_server_2 = self._network_server
		local _network_client_2 = self._network_client
		local profile_synchronizer_2

		if not _network_server_2 then
			profile_synchronizer_2 = _network_server_2.profile_synchronizer

			if not profile_synchronizer_2 then
				-- Nothing
			end
		end

		profile_synchronizer_2 = not _network_client_2 and _network_client_2.profile_synchronizer

		::label_52_1::

		if not profile_synchronizer_2 and not profile_synchronizer_2:all_synced() then
			loadout_resync_state = LoadoutResyncStates.DONE

			print("[StateLoading] loadout_resync_state RESYNCING -> DONE")
		end
	end

	if loadout_resync_state ~= self:loadout_resync_state() then
		self:set_loadout_resync_state(loadout_resync_state)
	end

	return loadout_resync_state
end

StateLoading._destroy_network_handler = function (self, arg_53_1, arg_53_2)
	-- function 53
	local _network_server = self._network_server

	_network_server = _network_server or self._network_client

	if not arg_53_2 then
		_network_server = arg_53_2.network_server or arg_53_2.network_client
		arg_53_2.network_server = nil
		arg_53_2.network_client = nil
	else
		self._network_server = nil
		self._network_client = nil
	end

	if not _network_server then
		local level_transition_handler = Managers.level_transition_handler
		local enemy_package_loader = level_transition_handler.enemy_package_loader

		enemy_package_loader:network_context_destroyed()

		if not arg_53_1 then
			enemy_package_loader:on_application_shutdown()
		end

		local transient_package_loader = level_transition_handler.transient_package_loader

		transient_package_loader:network_context_destroyed()
		transient_package_loader:unload_all_packages()
		level_transition_handler.pickup_package_loader:network_context_destroyed()
		level_transition_handler.general_synced_package_loader:network_context_destroyed()
		Managers.party:network_context_destroyed()
		Managers.mechanism:network_context_destroyed()
		_network_server:destroy()
	end
end

StateLoading._destroy_network = function (self, arg_54_1)
	-- function 54
	PartyManager.reset()

	if not Managers.matchmaking then
		Managers.matchmaking:destroy()

		Managers.matchmaking = nil
	end

	if not self._lobby_finder then
		self._lobby_finder:destroy()

		self._lobby_finder = nil
	end

	self:_destroy_network_handler(arg_54_1)

	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	if not Managers.lobby:query_lobby("matchmaking_session_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_session_lobby")
		Managers.account:set_current_lobby(nil)
	end

	if not rawget(_G, "LobbyInternal") then
		if not Managers.party:has_party_lobby() then
			local steal_lobby = Managers.party:steal_lobby()

			if type(steal_lobby) ~= "table" then
				LobbyInternal.leave_lobby(steal_lobby)
			end
		end

		LobbyInternal.shutdown_client()
	end

	Managers.chat:unregister_channel(1)
	Managers.mechanism:mechanism_try_call("unregister_chats")

	self.parent.loading_context = {}

	if not self.offline_invite then
		self.offline_invite = nil
		self.parent.loading_context.offline_invite = true
	end

	if not self._network_transmit then
		self._network_transmit:destroy()

		self._network_transmit = nil
	end

	if not self._switch_to_tutorial_backend then
		Managers.backend:stop_tutorial()
	end
end

StateLoading._tear_down_level_end_view_wrappers = function (self)
	-- function 55
	local _level_end_view_wrappers = self._level_end_view_wrappers

	if not _level_end_view_wrappers then
		for i = 1, #_level_end_view_wrappers do
			_level_end_view_wrappers[i]:destroy()
		end
	end

	self._level_end_view_wrappers = nil
end

StateLoading.set_matchmaking = function (self, arg_56_1)
	-- function 56
	self._joined_matchmaking_lobby = arg_56_1
end

StateLoading.has_registered_rpcs = function (self)
	-- function 57
	return self._registered_rpcs
end

StateLoading.register_rpcs = function (self)
	-- function 58
	local var_58_0 = NetworkEventDelegate:new()

	self._network_event_delegate = var_58_0

	Managers.level_transition_handler:register_rpcs(var_58_0)
	Managers.mechanism:register_rpcs(var_58_0)
	Managers.party:register_rpcs(var_58_0)

	if not Managers.matchmaking then
		Managers.matchmaking:register_rpcs(var_58_0)
		Managers.matchmaking:setup_post_init_data({})
	end

	Managers.chat:register_network_event_delegate(var_58_0)
	Managers.eac:register_network_event_delegate(var_58_0)

	if not Managers.mod then
		Managers.mod:register_network_event_delegate(var_58_0)
	end

	Managers.deed:register_rpcs(var_58_0)

	if not self._level_end_view_wrappers then
		for i, v in ipairs(self._level_end_view_wrappers) do
			v:register_rpcs(var_58_0)
		end
	end

	self._registered_rpcs = true

	print("registering RPCs")
end

StateLoading._unregister_rpcs = function (self)
	-- function 59
	Managers.level_transition_handler:unregister_rpcs()
	Managers.mechanism:unregister_rpcs()
	Managers.party:unregister_rpcs()

	if not Managers.matchmaking then
		Managers.matchmaking:unregister_rpcs()
	end

	Managers.chat:unregister_network_event_delegate()
	Managers.eac:unregister_network_event_delegate()

	if not Managers.mod then
		Managers.mod:unregister_network_event_delegate()
	end

	Managers.deed:unregister_rpcs()

	if not self._level_end_view_wrappers then
		for i, v in ipairs(self._level_end_view_wrappers) do
			v:unregister_rpcs()
		end
	end

	self._registered_rpcs = false
end

StateLoading.waiting_for_cleanup = function (self)
	-- function 60
	return self._waiting_for_cleanup
end

StateLoading.setup_join_lobby = function (self, arg_61_1, arg_61_2)
	-- function 61
	if not IS_XB1 and not Managers.account:all_sessions_cleaned_up() and not arg_61_1 then
		self._waiting_for_cleanup = true
		self._cleanup_done_func = callback(self, "setup_join_lobby")
		self._cleanup_wait_time = Managers.time:time("main") + (arg_61_1 or 0)

		return
	end

	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if not query_lobby then
		local network_options = LobbySetup.network_options()
		local loading_context = self.parent.loading_context

		if not loading_context.join_lobby_data then
			query_lobby = Managers.lobby:make_lobby(LobbyClient, "matchmaking_session_lobby", "StateLoading (setup_join_lobby)", network_options, self.parent.loading_context.join_lobby_data)
		elseif not loading_context.join_server_data then
			local tbl = {
				network_options = network_options,
				game_server_data = self.parent.loading_context.join_server_data
			}

			self._password_request = ServerJoinStateMachine:new(network_options, self.parent.loading_context.join_server_data.server_info.ip_port, tbl)
		else
			ferror("no join lobby data")
		end

		self.parent.loading_context.join_lobby_data = nil
		self._handle_new_lobby_connection = true

		if query_lobby ~= nil then
			Managers.account:set_current_lobby(query_lobby.lobby)
		end

		self._lobby_finder_timeout = Managers.time:time("main") + StateLoading.join_lobby_timeout
	end

	if not arg_61_2 then
		local flag = false

		self._voip = Voip:new(flag, query_lobby)
	end
end

StateLoading.setup_lobby_finder = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	-- function 62
	if not Managers.package:is_loading("resource_packages/inventory", "global") then
		Managers.package:load("resource_packages/inventory", "global")
	end

	if not Managers.package:is_loading("resource_packages/careers", "global") then
		Managers.package:load("resource_packages/careers", "global")
	end

	local network_options = LobbySetup.network_options()

	if not arg_62_4 then
		local tbl = {
			server_info = {
				ip_port = arg_62_2
			}
		}
		local tbl_2 = {
			network_options = network_options,
			game_server_data = tbl
		}

		self._password_request = ServerJoinStateMachine:new(network_options, tbl.server_info.ip_port, tbl_2)
	else
		self._lobby_finder = LobbyFinder:new(network_options, nil, true)
		self._lobby_to_join = arg_62_2
		self._host_to_join = not arg_62_3 and arg_62_3.peer_id
		self._host_to_join_name = not arg_62_3 and arg_62_3.name

		self._lobby_finder:refresh()
		printf("[StateLoading] StateLoading will try to find a lobby with id=%s or host=%s or unique_server_name=%s", tostring(arg_62_2), tostring(self._host_to_join), tostring(script_data.unique_server_name))
	end

	local time = Managers.time:time("main")

	self._lobby_joined_callback = arg_62_1
	self._lobby_finder_timeout = time + StateLoading.join_lobby_timeout
	self._lobby_finder_refresh_timer = time + StateLoading.join_lobby_refresh_interval

	local loading_context = self.parent.loading_context
	local flag = not loading_context and loading_context.versus_migration

	if not (not arg_62_3 and flag) then
		self:create_join_popup(self._host_to_join_name)
	end

	return self._lobby_finder
end

StateLoading.setup_lobby_host = function (self, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
	-- function 63
	if not (not IS_XB1 and Managers.account:all_sessions_cleaned_up()) then
		self._waiting_for_cleanup = true
		self._cleanup_done_func = callback(self, "setup_lobby_host", arg_63_1, arg_63_2, arg_63_3, arg_63_4)
		self._cleanup_wait_time = 0

		return
	end

	local loading_context = self.parent.loading_context

	assert(not loading_context.profile_synchronizer)
	assert(not loading_context.network_server)

	local network_options = LobbySetup.network_options()
	local tostring = table.tostring(network_options)
	local tostring_2

	if type(arg_63_2) == "table" then
		tostring_2 = table.tostring(arg_63_2)

		if not tostring_2 then
			-- Nothing
		end
	end

	tostring_2 = tostring(arg_63_2)

	::label_63_0::

	printf("StateLoading:setup_lobby_host - creating lobby_host with network_options: %s platform_lobby: %s", tostring, tostring_2)

	local make_lobby = Managers.lobby:make_lobby(LobbyHost, "matchmaking_session_lobby", "StateLoading (setup_lobby_host)", network_options, arg_63_2, arg_63_3, arg_63_4)
	local level_transition_handler = Managers.level_transition_handler

	if not level_transition_handler:has_next_level() then
		local default_level_key = Managers.mechanism:default_level_key()
		local var_63_7 = rawget(LevelSettings, default_level_key)
		local flag = not var_63_7 and var_63_7.conflict_settings

		level_transition_handler:set_next_level(default_level_key, nil, nil, nil, nil, flag)
	end

	level_transition_handler:promote_next_level_data()

	local get_current_level_key = level_transition_handler:get_current_level_key()

	if not self:loading_view_setup_done() then
		self:setup_loading_view(get_current_level_key)
	end

	if not self:menu_assets_setup_done() then
		self:setup_menu_assets()
	end

	self:_update_loading_global_packages()

	if not arg_63_1 then
		self:_create_network_server()
	end

	Managers.account:set_current_lobby(make_lobby.lobby)

	self._waiting_for_joined_callback = arg_63_1
end

StateLoading.host_joined = function (self)
	-- function 64
	self:_create_network_server()

	if not self._waiting_for_joined_callback then
		self._waiting_for_joined_callback()

		self._waiting_for_joined_callback = nil
	end
end

StateLoading._create_network_server = function (self)
	-- function 65
	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local loading_context = self.parent.loading_context
	local wanted_profile_index = self.parent.loading_context.wanted_profile_index

	self._network_server = NetworkServer:new(Managers.player, get_lobby, wanted_profile_index)

	local network_transmit = loading_context.network_transmit

	network_transmit = network_transmit or NetworkTransmit:new(true, self._network_server.server_peer_id)
	self._network_transmit = network_transmit

	self._network_transmit:set_network_event_delegate(self._network_event_delegate)
	self._network_server:register_rpcs(self._network_event_delegate, self._network_transmit)
	self._network_server:server_join()

	self._profile_synchronizer = self._network_server.profile_synchronizer

	self._network_server.voip:set_input_manager(self._input_manager)

	loading_context.network_transmit = self._network_transmit
end

StateLoading.setup_chat_manager = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4)
	-- function 66
	local tbl = {
		is_server = arg_66_4,
		host_peer_id = arg_66_2,
		my_peer_id = arg_66_3
	}

	Managers.chat:setup_network_context(tbl)
	Managers.mechanism:mechanism_try_call("register_chats")

	local function fn()
		-- function 67
		if not DEDICATED_SERVER and not Managers.level_transition_handler:in_hub_level() then
			local game_mechanism = Managers.mechanism:game_mechanism()

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			return game_mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session):reservers()
		end

		return arg_66_1:members():get_members()
	end

	Managers.chat:register_channel(1, fn)
end

StateLoading.setup_deed_manager = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5)
	-- function 68
	Managers.deed:network_context_created(arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5)
end

StateLoading.setup_enemy_package_loader = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	-- function 69
	Managers.level_transition_handler.enemy_package_loader:network_context_created(arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	Managers.level_transition_handler.pickup_package_loader:network_context_created(arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	Managers.level_transition_handler.general_synced_package_loader:network_context_created(arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	Managers.level_transition_handler.transient_package_loader:network_context_created(arg_69_1, arg_69_2, arg_69_3)
end

StateLoading.setup_global_managers = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5)
	-- function 70
	Managers.mechanism:network_context_created(arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5)
	Managers.party:network_context_created(arg_70_1, arg_70_2, arg_70_3)

	if not Managers.mod then
		Managers.mod:network_context_created(arg_70_2, arg_70_3, arg_70_4)
	end
end

StateLoading.setup_network_transmit = function (self, arg_71_1)
	-- function 71
	local server_peer_id

	if not self._network_server then
		server_peer_id = self._network_server.server_peer_id

		if not server_peer_id then
			-- Nothing
		end
	end

	server_peer_id = self._network_client
	server_peer_id = not server_peer_id and self._network_client.server_peer_id

	::label_71_0::

	local network_transmit = self.parent.loading_context.network_transmit

	network_transmit = network_transmit or NetworkTransmit:new(true, server_peer_id)
	self._network_transmit = network_transmit

	self._network_transmit:set_network_event_delegate(self._network_event_delegate)
	arg_71_1:register_rpcs(self._network_event_delegate, self._network_transmit)

	self.parent.loading_context.network_transmit = self._network_transmit
end

StateLoading.create_popup = function (self, arg_72_1, arg_72_2, arg_72_3, arg_72_4, ...)
	-- function 72
	if not Managers.account:leaving_game() then
		return
	end

	print("StateLoading:create_popup", Script.callstack())

	if not self._join_popup_id then
		Managers.popup:cancel_popup(self._join_popup_id)

		self._join_popup_id = nil
	end

	assert(arg_72_1, "[StateLoading] No error was passed to popup handler")

	local flag = arg_72_2 or "popup_error_topic"
	local flag_2 = arg_72_3 or "restart_as_server"
	local flag_3 = arg_72_4 or "menu_ok"
	local var_72_3 = Localize(arg_72_1)
	local format = string.format(var_72_3, ...)

	assert(self._popup_id == nil, "Tried to show popup even though we already had one.")

	self._popup_id = Managers.popup:queue_popup(format, Localize(flag), flag_2, Localize(flag_3))
end

StateLoading.create_join_popup = function (self, arg_73_1)
	-- function 73
	if not Managers.account:leaving_game() then
		return
	end

	local var_73_0 = Localize("popup_migrating_to_host_header")
	local str = Localize("popup_migrating_to_host_message") .. "\n" .. arg_73_1
	local join_lobby_timeout = StateLoading.join_lobby_timeout

	assert(self._join_popup_id == nil, "Tried to show popup even though we already had one.")

	self._join_popup_id = Managers.popup:queue_popup(str, var_73_0, "cancel", Localize("popup_choice_cancel"))

	local str_2 = "timeout"
	local str_3 = "center"
	local flag = false

	Managers.popup:activate_timer(self._join_popup_id, join_lobby_timeout, str_2, str_3, flag)
end

StateLoading.clear_network_loading_context = function (self)
	-- function 74
	local loading_context = self.parent.loading_context

	self:_destroy_network_handler(false, loading_context)

	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if not query_lobby and not query_lobby.is_host then
		Managers.lobby:destroy_lobby("matchmaking_session_lobby")
		Managers.account:set_current_lobby(nil)
	end

	loading_context.setup_voip = nil
end

StateLoading.setup_network_client = function (self, arg_75_1, arg_75_2)
	-- function 75
	if not arg_75_2 then
		arg_75_2 = Managers.lobby:query_lobby("matchmaking_session_lobby")
	elseif arg_75_2.lobby ~= nil then
		Managers.lobby:register_existing_lobby(arg_75_2, "matchmaking_session_lobby", "StateLoading (setup_network_client)")
	end

	if not (not arg_75_2 and arg_75_2.lobby ~= nil) then
		self._wanted_state = StateTitleScreen

		if not Managers.lobby:query_lobby("matchmaking_session_lobby") then
			Managers.lobby:destroy_lobby("matchmaking_session_lobby")
		end

		self:create_popup("failure_start_join_server", "popup_error_topic", "restart_as_server", "menu_accept")

		return false
	end

	Application.warning("Setting up network client")

	local lobby_host = arg_75_2:lobby_host()
	local wanted_profile_index = self.parent.loading_context.wanted_profile_index
	local wanted_party_index = self.parent.loading_context.wanted_party_index

	self._network_client = NetworkClient:new(lobby_host, wanted_profile_index, wanted_party_index, arg_75_1, arg_75_2, self._voip)
	self._network_transmit = NetworkTransmit:new(false, self._network_client.server_peer_id)

	self._network_transmit:set_network_event_delegate(self._network_event_delegate)
	self._network_client:register_rpcs(self._network_event_delegate, self._network_transmit)

	self._profile_synchronizer = self._network_client.profile_synchronizer
	self._handle_new_lobby_connection = nil
	self._voip = nil

	self._network_client.voip:set_input_manager(self._input_manager)

	local loading_context = self.parent.loading_context

	loading_context.network_client = self._network_client
	loading_context.network_transmit = self._network_transmit

	local lobby = arg_75_2.lobby

	Managers.account:set_current_lobby(lobby)

	return true
end

StateLoading.get_current_level_keys = function (arg_76_0)
	-- function 76
	return Managers.level_transition_handler:get_current_level_keys()
end

StateLoading.set_lobby_host_data = function (arg_77_0, arg_77_1)
	-- function 77
	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if not query_lobby and not query_lobby.is_host then
		local get_stored_lobby_data = query_lobby:get_stored_lobby_data()

		get_stored_lobby_data = get_stored_lobby_data or {}

		local var_77_2

		if not IS_PS4 then
			var_77_2 = get_stored_lobby_data.matchmaking_type or "n/a"
		else
			var_77_2 = not get_stored_lobby_data.matchmaking_type and NetworkLookup.matchmaking_types[tonumber(get_stored_lobby_data.matchmaking_type)] and "n/a"
		end

		if var_77_2 ~= "weave" then
			get_stored_lobby_data.mission_id = arg_77_1
		end

		local matchmaking = get_stored_lobby_data.matchmaking

		matchmaking = matchmaking or "true"
		get_stored_lobby_data.matchmaking = matchmaking

		if not LevelSettings[arg_77_1].hub_level then
			get_stored_lobby_data.matchmaking = "false"

			local flag

			flag = not IS_PS4 and "n/a" and NetworkLookup.matchmaking_types["n/a"]
			get_stored_lobby_data.matchmaking_type = flag
			get_stored_lobby_data.selected_mission_id = arg_77_1
		end

		if arg_77_1 == "prologue" then
			get_stored_lobby_data.matchmaking = "false"

			local flag_2

			flag_2 = not IS_PS4 and "tutorial" and NetworkLookup.matchmaking_types.tutorial
			get_stored_lobby_data.matchmaking_type = flag_2
		end

		local get_current_mechanism = Managers.level_transition_handler:get_current_mechanism()
		local get_current_game_mode = Managers.level_transition_handler:get_current_game_mode()

		get_stored_lobby_data.mechanism = get_current_game_mode ~= "weave" or not get_current_game_mode or get_current_mechanism

		if not IS_PS4 then
			local region = Managers.account:region()
			local get_matchmaking_regions, var_77_10 = MatchmakingRegionsHelper.get_matchmaking_regions(region)

			get_stored_lobby_data.primary_region = get_matchmaking_regions
			get_stored_lobby_data.secondary_region = var_77_10
		end

		local parameter = Development.parameter("weave_name")

		if not parameter then
			get_stored_lobby_data.mission_id = parameter

			local flag_3

			flag_3 = not IS_PS4 and "custom" and NetworkLookup.matchmaking_types.custom
			get_stored_lobby_data.matchmaking_type = flag_3
		elseif var_77_2 == "event" then
			local flag_4

			flag_4 = not IS_PS4 and "event" and NetworkLookup.matchmaking_types.event
			get_stored_lobby_data.matchmaking_type = flag_4
		elseif not Development.parameter("auto_host_level") then
			local flag_5

			flag_5 = not IS_PS4 and "custom" and NetworkLookup.matchmaking_types.custom
			get_stored_lobby_data.matchmaking_type = flag_5
		elseif Managers.level_transition_handler:get_current_mechanism() == "versus" then
			local versus

			if not DEDICATED_SERVER then
				versus = NetworkLookup.matchmaking_types.versus

				if not versus then
					-- Nothing
				end
			end

			versus = NetworkLookup.matchmaking_types.custom

			::label_77_0::

			get_stored_lobby_data.matchmaking_type = versus
		end

		if IS_WINDOWS or not IS_LINUX then
			local var_77_16

			if not DEDICATED_SERVER then
				var_77_16 = NetworkLookup.host_types.community_dedicated_server
			else
				var_77_16 = NetworkLookup.host_types.player_hosted
			end

			get_stored_lobby_data.host_type = var_77_16

			local flag_6

			flag_6 = not Managers.eac:is_trusted() and "true" and "false"
			get_stored_lobby_data.eac_authorized = flag_6
		end

		query_lobby:set_lobby_data(get_stored_lobby_data)
	end
end

StateLoading.start_matchmaking = function (arg_78_0)
	-- function 78
	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")

	assert(get_lobby.is_host)

	local get_stored_lobby_data = get_lobby:get_stored_lobby_data()

	get_stored_lobby_data = get_stored_lobby_data or {}
	get_stored_lobby_data.matchmaking = "true"

	get_lobby:set_lobby_data(get_stored_lobby_data)
end

StateLoading.get_lobby = function (arg_79_0)
	-- function 79
	return (Managers.lobby:query_lobby("matchmaking_session_lobby"))
end

StateLoading.has_joined = function (arg_80_0)
	-- function 80
	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")

	return not query_lobby and query_lobby:is_joined()
end
