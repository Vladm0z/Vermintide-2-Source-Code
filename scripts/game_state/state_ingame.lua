-- chunkname: @scripts/game_state/state_ingame.lua

require("scripts/flow/flow_callbacks")
require("scripts/settings/quest_settings")
require("scripts/managers/backend/statistics_database")
require("scripts/managers/bot_nav_transition/bot_nav_transition_manager")
require("scripts/managers/camera/camera_manager")
require("scripts/managers/debug/debug_text_manager")
require("scripts/managers/debug/debug_event_manager_rpc")
require("scripts/managers/network/game_network_manager")
require("scripts/managers/networked_flow_state/networked_flow_state_manager")
require("scripts/managers/spawn/spawn_manager")
require("scripts/managers/game_mode/game_mode_manager")
require("scripts/managers/debug/debug_manager")
require("scripts/managers/conflict_director/conflict_director")
require("scripts/managers/entity/entity_manager2")
require("scripts/managers/room/room_manager_server")
require("scripts/managers/room/room_manager_client")
require("scripts/managers/difficulty/difficulty_manager")
require("scripts/managers/matchmaking/matchmaking_manager")
require("scripts/managers/url_loader/url_loader_manager")
require("scripts/helpers/action_utils")
require("scripts/helpers/camera_carrier")
require("scripts/helpers/damage_utils")
require("scripts/helpers/graph_drawer")
require("scripts/helpers/level_helper")
require("scripts/helpers/locomotion_utils")
require("scripts/helpers/pactsworn_utils")
require("scripts/helpers/status_utils")
require("scripts/utils/debug_screen")
require("scripts/utils/debug_key_handler")
require("scripts/utils/function_call_profiler")
require("scripts/utils/visual_assert_log")
require("scripts/helpers/graph_helper")
require("scripts/network/network_event_delegate")
require("scripts/managers/input/input_manager")
require("scripts/utils/debug_keymap")
require("scripts/settings/render_settings_templates")
require("scripts/settings/game_settings")
require("scripts/network/network_clock_server")
require("scripts/network/network_clock_client")
require("scripts/network/network_timer_handler")
require("scripts/game_state/state_ingame_running")
require("scripts/game_state/state_loading")
require("scripts/entity_system/entity_system_bag")
require("scripts/level/environment/environment_blender")
require("scripts/managers/voting/vote_manager")
require("scripts/managers/voting/vote_templates")
require("scripts/game_state/components/dice_keeper")
require("foundation/scripts/util/datacounter")
require("scripts/managers/blood/blood_manager")
require("scripts/managers/blood/blood_manager_dummy")
require("scripts/managers/crafting/crafting_manager")
require("scripts/managers/performance/performance_manager")
require("scripts/managers/world_interaction/world_interaction_manager")
require("scripts/managers/decal/decal_manager")
require("scripts/managers/performance_title/performance_title_manager")
require("scripts/managers/achievements/achievement_manager")
require("scripts/managers/quest/quest_manager")
require("scripts/managers/challenges/challenge_manager")
require("scripts/managers/quickplay/quickplay_manager")
require("scripts/managers/status_effect/status_effect_manager")
require("scripts/utils/fps_reporter")
require("scripts/utils/ping_reporter")
require("scripts/managers/side/side_manager")
require("scripts/managers/vce/vce_manager")
require("scripts/managers/flow_helper/flow_helper_manager")
DLCUtils.require_list("statistics_database")

local testify = script_data.testify

testify = not testify and require("scripts/game_state/state_ingame_testify")
StateIngame = class(StateIngame)
StateIngame.NAME = "StateIngame"

StateIngame.on_enter = function (self)
	-- function 1
	fassert(self.parent.loading_context.ingame_world_object, "must have world")
	fassert(self.parent.loading_context.ingame_level_object, "must have level")

	self.parent.loading_context.ingame_world_object, self.world = self.world, self.parent.loading_context.ingame_world_object
	self.parent.loading_context.ingame_level_object, self.level = self.level, self.parent.loading_context.ingame_level_object

	if not IS_XB1 then
		Application.set_kinect_enabled(false)

		self.hero_stats_updated = false
	end

	local loading_context = self.parent.loading_context
	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local is_host = get_lobby.is_host

	self.is_server = is_host

	local print = print
	local str = "[Gamestate] Enter StateIngame"
	local flag

	flag = not is_host and "HOST" and "CLIENT"

	print(str, flag)

	local flag_2 = true

	GarbageLeakDetector.run_leak_detection(flag_2)
	GarbageLeakDetector.register_object(self, "StateIngame")
	NetworkUnit.reset_unit_data()
	Managers.time:register_timer("game", "main")
	CLEAR_POSITION_LOOKUP()
	Managers.mechanism:check_venture_start(self.parent.loading_context)

	local var_1_7 = InputManager:new()

	self.input_manager = var_1_7
	Managers.input = self.input_manager

	var_1_7:initialize_device("keyboard")
	var_1_7:initialize_device("mouse")
	var_1_7:initialize_device("gamepad")

	if not script_data.debug_enabled then
		var_1_7:create_input_service("Debug", "DebugKeymap", "DebugInputFilters")
		var_1_7:map_device_to_service("Debug", "keyboard")
		var_1_7:map_device_to_service("Debug", "mouse")
		var_1_7:map_device_to_service("Debug", "gamepad")
		var_1_7:create_input_service("DebugMenu", "DebugKeymap", "DebugInputFilters")
		var_1_7:map_device_to_service("DebugMenu", "keyboard")
		var_1_7:map_device_to_service("DebugMenu", "mouse")
		var_1_7:map_device_to_service("DebugMenu", "gamepad")
	end

	Managers.popup:set_input_manager(var_1_7)

	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()

	Crashify.print_property("level", get_current_level_keys)

	self.level_key = get_current_level_keys
	self.is_in_inn = LevelSettings[get_current_level_keys].hub_level
	self.is_in_tutorial = get_current_level_keys == "prologue"
	DamageUtils.is_in_inn = self.is_in_inn
	self._called_level_flow_events = false
	self._onclose_popup_id = nil
	self._onclose_called = false
	self._quit_game = false
	self._gm_event_end_conditions_met = false
	self._gm_event_end_reason = nil

	local light_fx = Managers.light_fx
	local var_1_10 = light_fx
	local set_lightfx_color_scheme = light_fx.set_lightfx_color_scheme
	local flag_3

	flag_3 = not self.is_in_inn and "inn_level" and "ingame"

	set_lightfx_color_scheme(var_1_10, flag_3)

	if not IS_CONSOLE and not self.is_in_tutorial then
		Managers.backend:set_user_data("prologue_started", true)
		Managers.backend:commit()
	end

	if not self.is_in_inn then
		Managers.unlock:enable_update_unlocks(true)
	end

	local statistics = Managers.venture.statistics

	loading_context.statistics_db = statistics
	self.statistics_db = statistics

	Managers.player:set_statistics_db(self.statistics_db)

	self._max_local_players = PlayerManager.MAX_PLAYERS

	if not self.is_server then
		local get_stored_lobby_data = get_lobby:get_stored_lobby_data()

		if get_stored_lobby_data.mechanism == "adventure" then
			get_stored_lobby_data.selected_mission_id = self.level_key

			get_lobby:set_lobby_data(get_stored_lobby_data)
		end
	end

	self.world_name = LevelHelper.INGAME_WORLD_NAME

	self:_setup_world()

	local world = self.world

	self.peer_id = Network.peer_id()

	local var_1_16 = NetworkEventDelegate:new()

	self.network_event_delegate = var_1_16
	self.network_server = loading_context.network_server
	self.network_client = loading_context.network_client

	if not self.network_server then
		local network_transmit = loading_context.network_transmit

		network_transmit = network_transmit or NetworkTransmit:new(is_host, self.network_server.server_peer_id)
		self.network_transmit = network_transmit

		self.network_server:register_rpcs(var_1_16, self.network_transmit)

		self.profile_synchronizer = self.network_server.profile_synchronizer

		self.network_server.voip:set_input_manager(self.input_manager)
		print("[StateIngame] Server ingame")
	elseif not self.network_client then
		print("[StateIngame] Client ingame")

		local network_transmit_2 = loading_context.network_transmit

		network_transmit_2 = network_transmit_2 or NetworkTransmit:new(is_host, self.network_client.server_peer_id)
		self.network_transmit = network_transmit_2

		self.network_client:register_rpcs(var_1_16, self.network_transmit)

		self.profile_synchronizer = self.network_client.profile_synchronizer

		self.network_client.voip:set_input_manager(self.input_manager)
	end

	self.network_transmit:set_network_event_delegate(var_1_16)
	var_1_16:register(self, "rpc_kick_peer")
	self.statistics_db:register_network_event_delegate(var_1_16)

	loading_context.network_transmit = self.network_transmit

	local str_2 = "top_ingame_view"

	self._top_gui_world = Managers.world:world(str_2)

	Debug.setup(self._top_gui_world, str_2)
	VisualAssertLog.setup(world)
	DebugKeyHandler.setup(world, self.input_manager)
	FunctionCallProfiler.setup(world)

	if not script_data.debug_enabled then
		DebugKeyHandler.set_enabled(false)
	end

	Managers.state.crafting = CraftingManager:new()

	local level_transition_handler = Managers.level_transition_handler
	local get_current_difficulty = level_transition_handler:get_current_difficulty()
	local get_current_difficulty_tweak = level_transition_handler:get_current_difficulty_tweak()

	if not Development.parameter("weave_name") then
		local parameter = Development.parameter("weave_name")

		get_current_difficulty = WeaveSettings.templates[parameter].difficulty_key
		get_current_difficulty_tweak = 0
	end

	Managers.state.difficulty = DifficultyManager:new(world, is_host, var_1_16, get_lobby)

	Managers.state.difficulty:set_difficulty(get_current_difficulty, get_current_difficulty_tweak)

	local flag_4

	flag_4 = not DEDICATED_SERVER and 0 and 1
	self.num_local_human_players = flag_4

	if not Managers.matchmaking then
		if not DEDICATED_SERVER then
			Managers.matchmaking:reset_lobby_filters()
		end
	else
		local tbl = {
			network_transmit = self.network_transmit,
			network_server = self.network_server,
			lobby = get_lobby,
			peer_id = self.peer_id,
			is_server = is_host,
			profile_synchronizer = self.profile_synchronizer,
			statistics_db = self.statistics_db
		}

		if not loading_context.host_migration_info then
			tbl.game_mode_event_data = loading_context.host_migration_info.game_mode_event_data
			loading_context.host_migration_info = nil
		end

		Managers.matchmaking = MatchmakingManager:new(tbl)
	end

	Managers.matchmaking:register_rpcs(var_1_16)
	Managers.matchmaking:set_statistics_db(self.statistics_db)
	Managers.deed:register_rpcs(var_1_16)
	self:_setup_state_context(world, is_host, var_1_16)
	level_transition_handler:register_rpcs(var_1_16)
	Managers.mechanism:register_rpcs(var_1_16)
	Managers.party:register_rpcs(var_1_16)

	if not rawget(_G, "ControllerFeaturesManager") then
		Managers.state.controller_features = ControllerFeaturesManager:new(self.is_in_inn)
	end

	Managers.telemetry_events:client_session_id(Application.guid())
	Managers.telemetry_events.rpc_listener:register(self.network_event_delegate)

	if not is_host then
		local session_id = Managers.state.network:session_id()

		Managers.telemetry_events:server_session_id(session_id)
		self.network_transmit:send_rpc_clients("rpc_to_client_sync_session_id", session_id)
	end

	local event = Managers.state.event

	event:register(self, "event_play_particle_effect", "event_play_particle_effect", "event_start_network_timer", "event_start_network_timer", "xbox_one_hack_start_game", "event_xbox_one_hack_start_game", "gm_event_end_conditions_met", "gm_event_end_conditions_met")

	for i = 1, flag_4 do
		local str_3 = "player_" .. i

		self.viewport_name = str_3

		local add_player = Managers.player:add_player(nil, str_3, self.world_name, i)
	end

	local level = self.level
	local _create_level = self:_create_level()

	Managers.state.entity:system("darkness_system"):set_level(level)
	Managers.state.entity:system("ai_group_system"):set_level(level)

	local get_level_seed = Managers.mechanism:get_level_seed()
	local checkpoint_data = loading_context.checkpoint_data

	if not self.is_server then
		Managers.state.entity:system("pickup_system"):setup_taken_pickups(checkpoint_data)

		if not checkpoint_data then
			local state = Managers.state

			state.spawn:load_checkpoint_data(checkpoint_data)
			state.conflict.level_analysis:set_random_seed(checkpoint_data.level_analysis)

			loading_context.checkpoint_data = nil
		else
			local game_seed

			if not Development.parameter("attract_mode") then
				game_seed = BenchmarkSettings.game_seed

				if not game_seed then
					-- Nothing
				end
			end

			game_seed = get_level_seed

			::label_1_0::

			Managers.state.conflict.level_analysis:set_random_seed(checkpoint_data, game_seed)
		end
	end

	self:_gather_backend_flow_events()

	if not Managers.state.room then
		Managers.state.room:setup_level_anchor_points(self.level)
	end

	local level_name = LevelSettings[_create_level].level_name

	ScriptWorld.optimize_level_units(world, level_name)
	InputDebugger:setup(world, self.input_manager)

	self.machines = {}

	local level_end_view_wrappers = loading_context.level_end_view_wrappers
	local peer_id = Network.peer_id()

	for j = 1, flag_4 do
		local str_4 = "player_" .. j

		self.viewport_name = str_4

		local network_options = LobbySetup.network_options()
		local tbl_2 = {
			local_player_id = j,
			viewport_name = str_4,
			is_in_inn = self.is_in_inn,
			is_in_tutorial = self.is_in_tutorial,
			is_server = is_host,
			network_options = network_options,
			input_manager = self.input_manager,
			world_name = self.world_name,
			free_flight_manager = self.free_flight_manager,
			lobby = Managers.lobby:get_lobby("matchmaking_session_lobby"),
			profile_synchronizer = self.profile_synchronizer,
			network_event_delegate = self.network_event_delegate,
			statistics_db = self.statistics_db,
			dice_keeper = self.dice_keeper,
			level_key = _create_level,
			network_server = self.network_server,
			network_client = self.network_client,
			network_transmit = self.network_transmit
		}
		local voip

		if not self.network_server then
			voip = self.network_server.voip

			if not voip then
				-- Nothing
			end
		end

		voip = self.network_client.voip

		::label_1_1::

		tbl_2.voip = voip

		if not level_end_view_wrappers and not level_end_view_wrappers[j] then
			tbl_2.level_end_view_wrapper = level_end_view_wrappers[j]
		end

		if not Managers.venture.quickplay:is_quick_game() then
			local player = Managers.player:player(peer_id, j)

			StatisticsUtil.register_played_quickplay_level(self.statistics_db, player, _create_level)
		end

		self.machines[j] = GameStateMachine:new(self, StateInGameRunning, tbl_2, true)
	end

	if not (not self.is_server and not DEDICATED_SERVER and Managers.state.game_mode:game_mode_key() ~= "versus") then
		self._saved_scoreboard_stats = self.parent.loading_context.saved_scoreboard_stats
		self.parent.loading_context.saved_scoreboard_stats = nil
	end

	if not checkpoint_data then
		Managers.state.entity:system("mission_system"):load_checkpoint_data(checkpoint_data.mission)
	end

	local wwise_world = Managers.world:wwise_world(world)

	if not Managers.matchmaking then
		local tbl_3 = {
			hero_spawner_handler = Managers.state.spawn.hero_spawner_handler,
			difficulty = Managers.state.difficulty,
			wwise_world = wwise_world,
			reset_matchmaking = self.is_in_inn,
			is_in_inn = self.is_in_inn
		}

		Managers.matchmaking:setup_post_init_data(tbl_3)
	end

	ScriptWorld.trigger_level_loaded(world, level_name)
	World.set_data(self.world, "level_seed", nil)

	if not checkpoint_data then
		Managers.state.networked_flow_state:load_checkpoint_data(checkpoint_data.networked_flow_state)
	end

	if not self.is_in_inn then
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()

		if not (current_mechanism_name ~= "adventure" or SaveData.first_time_in_inn) then
			Level.trigger_event(level, "first_time_started_game")

			SaveData.first_time_in_inn = true

			Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_save_data"))
		elseif not (current_mechanism_name ~= "versus" or SaveData.first_time_in_versus_inn) then
			Level.trigger_event(level, "first_time_started_versus_game")

			SaveData.first_time_in_versus_inn = true

			Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_save_data"))
		elseif not (current_mechanism_name ~= "deus" or SaveData.first_time_in_deus_inn) then
			Level.trigger_event(level, "first_time_started_deus_game")

			SaveData.first_time_in_deus_inn = true

			Managers.save:auto_save(SaveFileName, SaveData, callback(self, "cb_save_data"))
		end
	end

	local PLATFORM = PLATFORM

	if not IS_WINDOWS then
		Window.set_mouse_focus(true)
	end

	Network.write_dump_tag("start of game")

	local network = Managers.state.network
	local game = network:game()
	local is_host_2 = get_lobby.is_host

	is_host_2 = not is_host_2 and game

	if is_host_2 or not LEVEL_EDITOR_TEST then
		Managers.state.conflict:ai_ready(get_level_seed)
		Managers.state.entity:system("volume_system"):ai_ready()
	else
		Managers.state.conflict:client_ready()
	end

	if not self.is_server and not checkpoint_data then
		if not Managers.state.game_mode:setting("specified_pickups") then
			Managers.state.entity:system("pickup_system"):populate_specified_pickups(checkpoint_data.pickup)
		else
			Managers.state.entity:system("pickup_system"):populate_pickups(checkpoint_data.pickup)
		end
	elseif not self.is_server then
		if not Managers.state.game_mode:setting("specified_pickups") then
			Managers.state.entity:system("pickup_system"):populate_specified_pickups()
		else
			Managers.state.entity:system("pickup_system"):populate_pickups()
		end
	end

	if not self.is_server then
		Managers.state.entity:system("surrounding_aware_system"):populate_global_observers()
	end

	Managers.state.entity:system("payload_system"):init_payloads()

	local user_setting = Application.user_setting("dynamic_range_sound")

	if user_setting ~= nil then
		local var_1_52

		if user_setting == "low" then
			var_1_52 = 1
		elseif user_setting == "high" then
			var_1_52 = 0
		else
			local get = DefaultUserSettings.get("user_settings", "dynamic_range_sound")

			if get == "low" then
				var_1_52 = 1
			elseif get == "high" then
				var_1_52 = 0
			end
		end

		WwiseWorld.set_global_parameter(wwise_world, "dynamic_range_sound", var_1_52)
	end

	if not IS_WINDOWS then
		local user_setting_2 = Application.user_setting("sound_quality")

		SoundQualitySettings.set_sound_quality(wwise_world, user_setting_2)

		local user_setting_3 = Application.user_setting("sfx_bus_volume")

		if user_setting_3 ~= nil then
			local wwise_world_2 = Managers.world:wwise_world(world)

			WwiseWorld.set_global_parameter(wwise_world_2, "sfx_bus_volume", user_setting_3)
		end

		local user_setting_4 = Application.user_setting("voice_bus_volume")

		if user_setting_4 ~= nil then
			local wwise_world_3 = Managers.world:wwise_world(world)

			WwiseWorld.set_global_parameter(wwise_world_3, "voice_bus_volume", user_setting_4)
		end

		local user_setting_5 = Application.user_setting("master_bus_volume")

		if user_setting_5 ~= nil then
			local wwise_world_4 = Managers.world:wwise_world(world)

			WwiseWorld.set_global_parameter(wwise_world_4, "master_bus_volume", user_setting_5)
		end
	end

	Managers.music:on_enter_level(var_1_16, is_host)
	Managers.chat:register_network_event_delegate(var_1_16)
	Managers.eac:register_network_event_delegate(var_1_16)

	if not Managers.mod then
		Managers.mod:register_network_event_delegate(var_1_16)
	end

	Managers.state.game_mode:setup_done()

	if not is_host then
		Managers.state.game_mode:apply_environment_variation()
	end

	local get_difficulty, var_1_62 = Managers.state.difficulty:get_difficulty()
	local activated_mutators = Managers.state.game_mode:activated_mutators()
	local key = Managers.state.game_mode:settings().key
	local is_quick_game = Managers.venture.quickplay:is_quick_game()
	local str_5 = "official"

	if not MODDED_REALM then
		str_5 = "modded"
	end

	Managers.telemetry_events:game_started({
		peer_type = self:peer_type(),
		country_code = Managers.account:region(),
		quick_game = is_quick_game,
		game_mode = key,
		level_key = _create_level,
		difficulty = get_difficulty,
		difficulty_tweak = var_1_62,
		mutators = activated_mutators,
		realm = str_5
	})

	if not self.network_server then
		self.network_server:on_game_entered(network)
	elseif not self.network_client then
		self.network_client:on_game_entered()
	end

	self._camera_carrier = CameraCarrier:new()

	local user_setting_6 = Application.user_setting("fullscreen")
	local user_setting_7 = Application.user_setting("borderless_fullscreen")
	local flag_5 = not not user_setting_6 or not user_setting_7
	local flag_6

	flag_6 = not user_setting_6 and "fullscreen" and not user_setting_7 or "borderless_fullscreen" and not flag_5 and "windowed"

	local resolution, var_1_72 = Application.resolution()
	local format = string.format("%dx%d", resolution, var_1_72)
	local user_setting_8 = Application.user_setting("graphics_quality")
	local render_device_string = Renderer.render_device_string()

	Managers.telemetry_events:tech_settings(format, user_setting_8, flag_6, render_device_string)

	local sysinfo = Application.sysinfo()
	local user_setting_9 = Application.user_setting("adapter_index")

	Managers.telemetry_events:tech_system(sysinfo, user_setting_9)

	local user_setting_10 = Application.user_setting("use_pc_menu_layout")

	Managers.telemetry_events:ui_settings(user_setting_10)

	if not IS_XB1 then
		Managers.account:set_presence("playing")
	elseif not IS_PS4 then
		if not self.is_in_inn then
			Managers.account:set_presence("inn")
		else
			local display_name = LevelSettings[self.level_key].display_name

			Managers.account:set_presence("playing", display_name)
		end
	elseif not IS_WINDOWS then
		Managers.account:update_presence()
	end

	if not Managers.deed:has_deed() then
		local is_deed_owner = Managers.deed:is_deed_owner(self.peer_id)

		printf("Entered StateIngame with a deed active! is_owner(%s)", tostring(is_deed_owner))
	end

	self._fps_reporter = FPSReporter:new()
	self._ping_reporter = PingReporter:new()

	Managers.state.entity:system("objective_system"):on_game_entered()
	Managers.state.event:trigger("start_game_time", Managers.state.network:network_time())
	Managers:on_round_start(var_1_16, event, self.network_transmit)
	Managers.mechanism:handle_ingame_enter(key)
end

StateIngame.peer_type = function (self)
	-- function 2
	if not DEDICATED_SERVER then
		return "dedicated-server"
	elseif not self.is_server then
		return "server"
	else
		return "client"
	end
end

StateIngame.event_xbox_one_hack_start_game = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	print(arg_3_1, arg_3_2)
	Managers.level_transition_handler:set_next_level(arg_3_1, nil, nil, nil, nil, nil, arg_3_2)
	Managers.state.game_mode:complete_level()
end

StateIngame.cb_save_data = function (arg_4_0)
	-- function 4
	print("saved data")
end

StateIngame._setup_world = function (self)
	-- function 5
	local function fn()
		-- function 6
		Managers.ui:update()
	end

	Managers.world:set_anim_update_callback(self.world, fn)
	Managers.world:set_scene_update_callback(self.world, function ()
		-- function 7
		self:physics_async_update(self.dt)
	end)
	Managers.world:set_update_done_callback(self.world, function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		Managers.state.entity:system("transportation_system"):world_updated(arg_8_0, arg_8_1, arg_8_2)
	end)

	if not Managers.splitscreen then
		Managers.splitscreen:add_splitscreen_viewport(self.world)
	end
end

StateIngame._safe_to_do_entity_update = function (self)
	-- function 9
	local network = Managers.state.network

	if not (network:has_left_game() or network:in_game_session()) then
		return false
	end

	local time = Managers.time:time("game")

	if not Managers.state.game_mode:is_game_mode_ended() then
		-- Nothing
	end

	::label_9_0::

	local game_mode_end_timer = self.game_mode_end_timer

	game_mode_end_timer = not game_mode_end_timer and time >= self.game_mode_end_timer

	::label_9_1::

	return not game_mode_end_timer
end

StateIngame.physics_async_update = function (self, arg_10_1)
	-- function 10
	local time = Managers.time:time("game")

	Managers.music:update(self.dt, time)

	if not self:_safe_to_do_entity_update() then
		self.entity_system:physics_async_update()
	end
end

StateIngame.shading_callback = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	Managers.state.camera:shading_callback(arg_11_1, arg_11_2, arg_11_3)
end

StateIngame._teardown_level = function (self)
	-- function 12
	ScriptWorld.destroy_level_from_reference(self.world, self.level)
end

StateIngame._teardown_world = function (self)
	-- function 13
	if not Managers.splitscreen then
		Managers.splitscreen:remove_splitscreen_viewport()
	end

	if not Debug.active then
		Debug.teardown()
	end

	World.destroy_gui(self.world, self._debug_gui)
	World.destroy_gui(self.world, self._debug_gui_immediate)
	Managers.world:destroy_world(self.world_name)
end

StateIngame.spawn_unit = function (self, arg_14_1, ...)
	-- function 14
	if not Managers.state.entity then
		printf("Unit %s is spawned after level destroy?", tostring(arg_14_1))

		return
	end

	Managers.state.entity:register_unit(self.world, arg_14_1, ...)
end

StateIngame.unspawn_unit = function (arg_15_0, arg_15_1)
	-- function 15
	if not Managers.state.entity then
		printf("Unit %s has not been destroyed by entity manager or level destroy", tostring(arg_15_1))

		return
	end

	Unit.flow_event(arg_15_1, "unit_despawned")
	Managers.state.entity:unregister_unit(arg_15_1)
end

StateIngame._create_level = function (self)
	-- function 16
	local level = self.level

	Level.finish_spawn_time_sliced(level)
	ScriptWorld.activate(self.world)

	local level_transition_handler = Managers.level_transition_handler
	local get_current_level_key = level_transition_handler:get_current_level_key()
	local level_name = LevelSettings[get_current_level_key].level_name
	local get_current_game_mode = level_transition_handler:get_current_game_mode()
	local get_object_sets, var_16_6 = GameModeHelper.get_object_sets(level_name, get_current_game_mode)
	local get_current_level_seed = level_transition_handler:get_current_level_seed()

	print("[StateIngame] Level seed:", get_current_level_seed)
	World.set_data(self.world, "level_seed", get_current_level_seed)
	World.set_data(self.world, "debug_level_seed", {})
	World.set_data(self.world, "shading_callback", callback(self, "shading_callback"))

	local game_mode = Managers.state.game_mode

	Managers.state.networked_flow_state:set_level(level)
	World.set_flow_callback_object(self.world, self)
	Managers.state.entity:add_and_register_units(self.world, World.units(self.world))
	game_mode:register_object_sets(get_object_sets)
	Level.spawn_background(level)

	return get_current_level_key
end

StateIngame._gather_backend_flow_events = function (self)
	-- function 17
	local tbl = {}
	local str = "keep_event_default"
	local level_settings = Managers.backend:get_level_variation_data().level_settings
	local flag = not level_settings and level_settings[self.level_key]

	if not flag then
		local environment_flow_event = flag.environment_flow_event

		if not environment_flow_event then
			str = environment_flow_event
		end

		local level_flow_events = flag.level_flow_events

		if not level_flow_events then
			for i = 1, #level_flow_events do
				local var_17_6 = level_flow_events[i]

				tbl[#tbl + 1] = var_17_6
			end
		end
	end

	if not str then
		tbl[#tbl + 1] = str
	end

	self._level_flow_events = tbl
end

StateIngame.pre_update = function (self, arg_18_1)
	-- function 18
	local time = Managers.time:time("game")
	local network = Managers.state.network

	UPDATE_POSITION_LOOKUP()
	Managers.state.side:update_frame_tables()
	network:update_receive(arg_18_1)
	self.entity_system:commit_and_remove_pending_units()

	if not self.network_server then
		self.network_server:update(arg_18_1, time)
	end

	if not self.network_client then
		self.network_client:update(arg_18_1, time)
	end

	Managers.state.spawn:pre_update(arg_18_1, time)
	Managers.state.game_mode:pre_update(time, arg_18_1)
	Managers.state.conflict:pre_update()
	self.entity_system:commit_and_remove_pending_units()

	if not self:_safe_to_do_entity_update() then
		self.entity_system:pre_update(arg_18_1, time)
	end
end

local num = 1
local num_2 = 0
local num_3 = 0
local tbl = {
	"charge_end",
	"spark_muzzlefx_right",
	"spark_muzzlefx_left",
	"above_overcharge_threshold",
	"sfx_ranged_weapon_foley",
	"beam_muzzlefx",
	"fx_show_fire_trail",
	"below_overcharge_threshold",
	"send_spear",
	"fireball_charged_shoot",
	"fireball_shoot",
	"staff_charge_cancel",
	"fx_hide_fire_trail",
	"sfx_ranged_weapon_equip",
	"lua_wield",
	"geiser_muzzlefx"
}

local function fn(arg_19_0, arg_19_1)
	-- function 19
	if arg_19_1 > num_2 then
		num_2 = arg_19_1 + 0.5

		local player_unit = Managers.player:local_player().player_unit

		if not ALIVE[player_unit] then
			return
		end

		local right_hand_wielded_unit = ScriptUnit.extension(player_unit, "inventory_system"):equipment().right_hand_wielded_unit

		if not ALIVE[right_hand_wielded_unit] then
			num = num + 1

			if not tbl[num] then
				num = 1
				num_3 = (1 + num_3) % 2

				local lshift = bit.lshift(num_3, 4)

				Application.set_render_setting("global_shader_variable", lshift)
			end

			local var_19_3 = tbl[num]

			Unit.flow_event(right_hand_wielded_unit, var_19_3)
		end
	end

	local var_19_4 = tbl[num]

	Debug.text(string.format("Event Name: %s - Remap Index: %s - Remap variable: %s", var_19_4, num_3, Application.render_config("settings", "global_shader_variable")))
end

StateIngame.update = function (self, arg_20_1, arg_20_2)
	-- function 20
	self.dt = arg_20_1

	if not (not self.network_client and self.network_client.state ~= NetworkClientStates.game_started) then
		self.network_clock:update(arg_20_1)
		self.network_timer_handler:update(arg_20_1, arg_20_2)
	end

	local is_server = self.is_server
	local Managers = Managers

	Managers.state.network:update(arg_20_1)
	Managers.backend:update(arg_20_1, arg_20_2)
	self.input_manager:update(arg_20_1, arg_20_2)
	Managers.level_transition_handler:update()

	local time = Managers.time:time("game")
	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")

	get_lobby:update(arg_20_1)
	Managers.state.voting:update(arg_20_1, time)

	if not Managers.matchmaking then
		Managers.matchmaking:update(arg_20_1, arg_20_2)
	end

	if not Managers.game_server then
		Managers.game_server:update(arg_20_1, time)
	end

	self:_update_deed_manager(arg_20_1)
	Managers.venture.challenge:update(arg_20_1, arg_20_2)
	Managers.boon:update(arg_20_1, arg_20_2)
	Managers.party:update(time, arg_20_1)

	if not Managers.state.quest then
		Managers.state.quest:update(arg_20_1, time)
	end

	Managers.state.achievement:update(arg_20_1, time)

	if Managers.state.decal ~= nil then
		Managers.state.decal:update(arg_20_1, time)
	end

	if Managers.eac ~= nil then
		Managers.eac:update(arg_20_1, time)
	end

	if not DEDICATED_SERVER then
		Managers.state.blood:update(arg_20_1, time)
		Managers.state.status_effect:update(arg_20_1, time)
	end

	Managers.state.world_interaction:update(arg_20_1, time)

	if not Managers.state.controller_features then
		Managers.state.controller_features:update(arg_20_1, time)
	end

	if not is_server then
		Managers.state.conflict:reset_data()

		if not get_lobby:is_joined() and not Managers.state.network:game() then
			Managers.state.conflict:update(arg_20_1, time)
		end
	elseif not Managers.state.network:game() then
		Managers.state.conflict:update_client(arg_20_1, time)
	end

	for k, v in pairs(self.machines) do
		v:update(arg_20_1, time)
	end

	local is_game_mode_ended = Managers.state.game_mode:is_game_mode_ended()

	if is_game_mode_ended or not self.game_mode_end_timer then
		self.game_mode_end_timer = nil
	end

	if not (not is_game_mode_ended and self.game_mode_end_timer) then
		self.game_mode_end_timer = time + 0.2
	end

	if not self:_safe_to_do_entity_update() then
		self.entity_system:update(arg_20_1, time)
	else
		self.entity_system:unsafe_entity_update(arg_20_1, time)
	end

	Managers.state.game_mode:update(arg_20_1, time)

	if not is_server then
		Managers.state.game_mode:server_update(arg_20_1, time)
	end

	if not self._new_state then
		self._new_state = self:_check_exit(time)
	end

	if not self.exit_type then
		for k_2, v_2 in pairs(self.machines) do
			v_2._state:disable_ui()
		end
	end

	if not self._new_state then
		if not self.parent.loading_context.restart_network then
			self.leave_lobby = true
		end

		if not Managers.popup:has_popup() then
			return self._new_state
		end
	end

	Managers.state.bot_nav_transition:update(arg_20_1, time)
	Managers.state.flow_helper:update(time)
	Managers.state.performance:update(arg_20_1, time)
	self._fps_reporter:update(arg_20_1, time)
	self._ping_reporter:update(arg_20_1, time)
	self:_update_onclose_check(arg_20_1, time)
	self:_generate_ingame_clock()
	self._camera_carrier:update(arg_20_1)

	if not (not self._level_flow_events and not (#self._level_flow_events > 0) or self._called_level_flow_events) then
		local _level_flow_events = self._level_flow_events

		for i4 = 1, #_level_flow_events do
			local var_20_6 = _level_flow_events[i4]

			LevelHelper:flow_event(self.world, var_20_6)
		end

		self._called_level_flow_events = true
	end

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

StateIngame._update_onclose_check = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not (not self._onclose_called and self._onclose_popup_id) then
		local str = Localize("exit_game_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players")

		self._onclose_popup_id = Managers.popup:queue_popup(str, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end

	self:_handle_onclose_warning_result()
end

StateIngame._update_deed_manager = function (self, arg_22_1)
	-- function 22
	local deed = Managers.deed

	deed:update(arg_22_1)

	if not self.is_server and not deed:has_deed() and not deed:is_session_faulty() then
		if not self.is_in_inn then
			deed:reset()
		else
			Managers.state.game_mode:complete_level()
		end
	end
end

StateIngame.cb_transition_fade_in_done = function (self, arg_23_1)
	-- function 23
	self._new_state = arg_23_1
end

StateIngame.event_start_network_timer = function (self, arg_24_1)
	-- function 24
	self.network_timer_handler:start_timer_server(arg_24_1)
end

StateIngame._check_exit = function (self, arg_25_1)
	-- function 25
	local network = Managers.state.network
	local query_lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")
	local PLATFORM = PLATFORM
	local game_mode_key = self.game_mode_key
	local get_difficulty, var_25_5 = Managers.state.difficulty:get_difficulty()
	local var_25_6 = NetworkLookup.difficulties[get_difficulty]
	local backend = Managers.backend
	local is_waiting_for_user_input = backend:is_waiting_for_user_input()
	local waiting_for_response

	if backend:get_interface("items"):num_current_item_server_requests() == 0 then
		waiting_for_response = UISettings.waiting_for_response

		if not waiting_for_response then
			-- Nothing
		end
	end

	waiting_for_response = not backend:is_disconnected()

	::label_25_0::

	if not (self.exit_type or is_waiting_for_user_input or waiting_for_response) then
		local var_25_10
		local var_25_11

		for k, v in pairs(self.machines) do
			v:state():check_invites()

			var_25_10, var_25_11 = v:state():wanted_transition()
		end

		if not (not script_data.hammer_join and not (Managers.time:time("game") > 5)) then
			var_25_10 = "restart_game"

			Development.set_parameter("auto_join", true)
		elseif IS_WINDOWS or not Managers.account:leaving_game() then
			var_25_10 = "return_to_title_screen"
		end

		var_25_10 = var_25_10 or Managers.state.game_mode:wanted_transition()

		if var_25_10 or not Managers.game_server then
			var_25_10 = Managers.game_server:get_transition()
		end

		if var_25_10 or not script_data.honduras_demo then
			var_25_10 = Managers.time:get_demo_transition()
		end

		local level_transition_handler = Managers.level_transition_handler
		local needs_level_load = level_transition_handler:needs_level_load()

		needs_level_load = not needs_level_load and level_transition_handler:get_current_level_transition_type()

		if var_25_10 or var_25_11 or not needs_level_load then
			print("TRANSITION", var_25_10, var_25_11, needs_level_load)
		end

		if not backend:is_disconnected() then
			self.exit_type = "backend_disconnected"

			if not network:in_game_session() then
				local flag = true

				network:leave_game(flag)
			end

			self.leave_lobby = true

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "offline_invite" then
			self.exit_type = "offline_invite"

			if not Managers.account:leaving_game() then
				Managers.account:initiate_leave_game()
			end

			if not network:in_game_session() then
				local flag_2 = true

				network:leave_game(flag_2)
			end

			self.leave_lobby = true

			Managers.account:set_should_teardown_xboxlive()
			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "return_to_title_screen" then
			self.exit_type = "return_to_title_screen"

			if not Managers.account:leaving_game() then
				Managers.account:initiate_leave_game()
			end

			if not network:in_game_session() then
				local flag_3 = true

				network:leave_game(flag_3)
			end

			self.leave_lobby = true

			Managers.account:set_should_teardown_xboxlive()
			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "return_to_demo_title_screen" then
			self.exit_type = "return_to_demo_title_screen"

			if not network:in_game_session() then
				local flag_4 = true

				network:leave_game(flag_4)
			end

			self.leave_lobby = true

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif not (not self.is_in_inn and not query_lobby and not query_lobby:lost_connection_to_lobby() and query_lobby:attempting_reconnect()) then
			print("Lost connection to lobby, restarting to inn.")

			self.exit_type = "lobby_state_failed"

			if not network:in_game_session() then
				network:leave_game()
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif not (not self.network_client and self.network_client.state ~= NetworkClientStates.denied_enter_game) then
			if self.network_client.host_to_migrate_to == nil then
				self.exit_type = "join_lobby_failed"
			else
				self.exit_type = "perform_host_migration"
			end

			if not network:in_game_session() then
				local flag_5 = true

				network:leave_game(flag_5)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif not (not self.network_client and self.network_client.state ~= NetworkClientStates.eac_match_failed) then
			self.exit_type = "join_lobby_failed"

			if not network:in_game_session() then
				local flag_6 = true

				network:leave_game(flag_6)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif not self.network_client and (self.network_client.state ~= NetworkClientStates.lost_connection_to_host or not query_lobby) and not query_lobby:lost_connection_to_lobby() then
			if not (self.network_client == nil or self.network_client.host_to_migrate_to ~= nil) then
				self.exit_type = "rejoin_party"

				print("Game ended while reconnecting to lobby, restarting to inn.")
			else
				self.exit_type = "perform_host_migration"

				if not network:in_game_session() then
					local flag_7 = true

					network:leave_game(flag_7)
				end

				Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
				Managers.transition:show_loading_icon()
			end
		elseif not ((not query_lobby and query_lobby.state == LobbyState.FAILED or not self.network_client) and self.network_client.state ~= NetworkClientStates.lost_connection_to_host) then
			if not (self.network_client == nil or self.network_client.host_to_migrate_to ~= nil) then
				self.exit_type = "lobby_state_failed"
			else
				self.exit_type = "perform_host_migration"
			end

			if not network:in_game_session() then
				local flag_8 = true

				network:leave_game(flag_8)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif not self.kicked_by_server then
			self.kicked_by_server = nil
			self.exit_type = "kicked_by_server"

			if not (query_lobby.is_host or query_lobby.state ~= LobbyState.JOINED) then
				Managers.matchmaking:add_broken_lobby_client(query_lobby, arg_25_1, true)
			end

			if not network:in_game_session() then
				local flag_9 = true

				network:leave_game(flag_9)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "finish_tutorial" then
			self.exit_type = "finished_tutorial"

			self.network_server:disconnect_all_peers("host_left_game")

			if not network:in_game_session() then
				local flag_10 = true

				network:leave_game(flag_10)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "demo_completed" then
			self.exit_type = "demo_completed"

			if not network:in_game_session() then
				local flag_11 = true

				network:leave_game(flag_11)
			end

			Managers.transition:force_fade_in()
			Managers.transition:show_video(true)
			Managers.transition:show_loading_icon()
		elseif needs_level_load == "reload_level" then
			self.exit_type = "reload_level"

			if not self.is_server then
				network:leave_game()
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif needs_level_load == "load_next_level" then
			self.exit_type = "load_next_level"

			printf("Transition type %q, is server: %s", tostring(needs_level_load), tostring(self.is_server))

			if not self.is_server then
				network:leave_game()

				if level_transition_handler:get_current_level_key() == "prologue" then
					self.parent.loading_context.play_trailer = true

					local should_run_tutorial, var_25_26 = Managers.mechanism:should_run_tutorial()

					self.parent.loading_context.switch_to_tutorial_backend = should_run_tutorial
					self.parent.loading_context.wanted_tutorial_state = var_25_26
				end
			else
				self.network_client:set_wait_for_state_loading(true)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "leave_game" or var_25_10 == "quit_game" or not self._quit_game then
			if not (Managers.mechanism:current_mechanism_name() == "versus") then
				Managers.matchmaking:on_leave_game()
			end

			if var_25_10 == "leave_game" then
				self.exit_type = "left_game"
			else
				self.exit_type = "quit_game"
			end

			if not self.network_server then
				self.network_server:disconnect_all_peers("host_left_game")
			elseif not (query_lobby.is_host or query_lobby.state ~= LobbyState.JOINED) then
				print("Leaving lobby, noting it as one I don't want to matchmake back into soon")
				Managers.matchmaking:add_broken_lobby_client(query_lobby, arg_25_1, true)
			end

			if not network:in_game_session() then
				local flag_12 = not self.is_server

				network:leave_game(flag_12)
			end

			if not Development.parameter("attract_mode") then
				Managers.transition:force_fade_in()
			else
				Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			end

			Managers.transition:show_loading_icon()
		elseif var_25_10 == "return_to_pc_menu" then
			if GameSettingsDevelopment.skip_start_screen or not Development.parameter("skip_start_screen") then
				self.exit_type = "return_to_pc_menu"

				if not self.network_server then
					self.network_server:disconnect_all_peers("host_left_game")
				elseif not (query_lobby.is_host or query_lobby.state ~= LobbyState.JOINED) then
					print("Leaving lobby, noting it as one I don't want to matchmake back into soon")
					Managers.matchmaking:add_broken_lobby_client(query_lobby, arg_25_1, true)
				end

				if not network:in_game_session() then
					local flag_13 = not self.is_server

					network:leave_game(flag_13)
				end

				Managers.matchmaking:cancel_matchmaking()
				Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
				Managers.transition:show_loading_icon()
			else
				self.exit_type = "return_to_title_screen"

				if not Managers.account:leaving_game() then
					Managers.account:initiate_leave_game()
				end

				if not network:in_game_session() then
					local flag_14 = true

					network:leave_game(flag_14)
				end

				self.leave_lobby = true

				Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
				Managers.transition:show_loading_icon()
			end
		elseif var_25_10 == "afk_kick" then
			self.exit_type = "afk_kick"

			if not network:in_game_session() then
				local flag_15 = true

				network:leave_game(flag_15)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "join_lobby" then
			self.exit_type = "join_game"

			if not network:in_game_session() then
				network:leave_game()
			end

			self.parent.loading_context.join_lobby_data = var_25_11
			self.parent.loading_context.setup_voip = IS_PS4

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "start_lobby" then
			self.exit_type = "join_game"

			if not network:in_game_session() then
				network:leave_game()
			end

			self.parent.loading_context.start_lobby_data = var_25_11

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "join_server" then
			self.exit_type = "join_game"

			if not network:in_game_session() then
				network:leave_game()
			end

			self.parent.loading_context.join_server_data = var_25_11

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "restart_game" then
			self.exit_type = "restart_game"

			if not network:in_game_session() then
				network:leave_game()
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "restart_demo" then
			self.exit_type = "load_next_level"

			printf("Transition type %q, is server: %s", tostring(needs_level_load), tostring(self.is_server))

			if not self.is_server then
				local demo_level = DemoSettings.demo_level
				local generate_locked_director_functions = Managers.mechanism:generate_locked_director_functions(demo_level)
				local generate_level_seed = Managers.mechanism:generate_level_seed()

				level_transition_handler:set_next_level(demo_level, nil, generate_level_seed, nil, nil, nil, generate_locked_director_functions, get_difficulty, var_25_5)
				level_transition_handler:promote_next_level_data()
				network:leave_game()
			else
				self.network_client:set_wait_for_state_loading(true)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "rejoin_party" then
			self.exit_type = "rejoin_party"

			if not network:in_game_session() then
				local flag_16 = true

				network:leave_game(flag_16)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "versus_migration" then
			self.exit_type = "versus_migration"

			if not network:in_game_session() then
				local flag_17 = true

				network:leave_game(flag_17)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "restart_game_server" then
			self.exit_type = "restart_game_server"

			if not network:in_game_session() then
				local flag_18 = true

				network:leave_game(flag_18)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "complete_level" then
			-- Nothing
		end

		if not self.exit_type then
			self.exit_time = arg_25_1 + 2

			printf("StateIngame: Got transition %s, set exit type to %s. Will exit at t=%.2f", tostring(var_25_10), self.exit_type, self.exit_time)

			local input_manager = self.input_manager

			input_manager:block_device_except_service(nil, "keyboard", 1)
			input_manager:block_device_except_service(nil, "mouse", 1)
			input_manager:block_device_except_service(nil, "gamepad", 1)
			Managers.popup:cancel_all_popups()

			if not IS_XB1 then
				self.machines[1]:state():trigger_xbox_multiplayer_round_end_events()
			end

			if not IS_PS4 then
				Managers.account:set_realtime_multiplay(false)
			end

			if not self.is_in_tutorial then
				local system = Managers.state.entity:system("play_go_tutorial_system")

				if not system then
					system:clear_hooks()
				end
			end
		end
	end

	local num = 4

	if not script_data.honduras_demo then
		local transition = Managers.transition

		if not (not transition:is_video_active() and transition:is_video_done()) then
			return
		end
	end

	if not (not self.exit_time and not (arg_25_1 >= self.exit_time)) then
		Managers.popup:cancel_all_popups()
		Managers.account:check_popup_retrigger()

		local exit_type = self.exit_type
		local flag_19 = network:has_left_game() or not network:in_game_session()

		if not (flag_19 or not (arg_25_1 >= self.exit_time + num)) then
			print("Session leave timeout reached, force disconnecting")
			network:force_disconnect_from_session()

			return
		elseif not flag_19 then
			return
		end

		if not self.is_server and (self.is_in_inn or exit_type == "reload_level" or not Managers.matchmaking) and not Managers.matchmaking:have_game_mode_event_data() and not Managers.mechanism:game_mechanism():is_venture_over() then
			Managers.matchmaking:clear_game_mode_event_data()
		end

		if not Managers.backend:is_tutorial_backend() then
			Managers.backend:stop_tutorial()
		end

		if not Managers.deed:has_deed() and self.is_in_inn or not self.is_server then
			Managers.deed:reset()
		end

		Managers.mechanism:handle_ingame_exit(exit_type)

		if exit_type == "quit_game" then
			if not network:in_game_session() then
				local flag_20 = true

				network:leave_game(flag_20)
			end

			if not IS_XB1 and not Managers.voice_chat then
				Managers.voice_chat:_remove_all_users()
			end

			Boot.quit_game = true
		elseif not (exit_type == "join_lobby_failed" or exit_type == "left_game" or exit_type == "lobby_state_failed" or exit_type == "kicked_by_server" or exit_type ~= "afk_kick") then
			printf("[StateIngame] Transition to StateLoadingRestartNetwork on %q", self.exit_type)

			if not IS_XB1 and not Managers.voice_chat then
				Managers.voice_chat:_remove_all_users()
			end

			if exit_type == "lobby_state_failed" then
				if not self.is_server then
					self.parent.loading_context.previous_session_error = "broken_connection"
				else
					local current_mechanism_name = Managers.mechanism:current_mechanism_name()
					local get_stored_lobby_data = query_lobby:get_stored_lobby_data()
					local matchmaking_type = get_stored_lobby_data.matchmaking_type

					matchmaking_type = not matchmaking_type and tonumber(get_stored_lobby_data.matchmaking_type)

					if not ((current_mechanism_name ~= "versus" or not matchmaking_type) and NetworkLookup.matchmaking_types[matchmaking_type] ~= "versus") then
						self.parent.loading_context.previous_session_error = "server_disconnected"
					else
						self.parent.loading_context.previous_session_error = "lobby_disconnected"
					end
				end
			elseif exit_type == "kicked_by_server" then
				self.parent.loading_context.previous_session_error = "kicked_by_server"
			elseif exit_type ~= "join_lobby_failed" or not self.network_client then
				self.parent.loading_context.previous_session_error = self.network_client.fail_reason
			elseif exit_type == "afk_kick" then
				self.parent.loading_context.previous_session_error = "afk_kick"
			elseif exit_type == "return_to_pc_menu" or exit_type == "left_game" or not network:in_game_session() then
				local flag_21 = true

				network:leave_game(flag_21)
			end

			self.parent.loading_context.restart_network = true
			self.parent.loading_context.level_end_view_context = nil

			local loading_context = self.parent.loading_context
			local floor = math.floor
			local time

			if not Managers.time then
				time = Managers.time:time("game")

				if not time then
					-- Nothing
				end
			end

			time = -1

			::label_25_1::

			loading_context.time_spent_in_level = floor(time)
			self.parent.loading_context.end_reason = exit_type

			return StateLoading
		elseif exit_type == "return_to_pc_menu" then
			printf("[StateIngame] Transition to StateLoadingRestartNetwork on %q", self.exit_type)

			self.parent.loading_context.restart_network = true
			self.parent.loading_context.show_profile_on_startup = true
			self.parent.loading_context.return_to_pc_menu = true

			local loading_context_2 = self.parent.loading_context
			local floor_2 = math.floor
			local time_2

			if not Managers.time then
				time_2 = Managers.time:time("game")

				if not time_2 then
					-- Nothing
				end
			end

			time_2 = -1

			::label_25_2::

			loading_context_2.time_spent_in_level = floor_2(time_2)
			self.parent.loading_context.end_reason = "return_to_pc_menu"

			return StateLoading
		elseif exit_type == "demo_completed" then
			self.parent.loading_context.restart_network = true

			return StateDemoEnd
		elseif exit_type == "finished_tutorial" then
			local loading_context_3 = self.parent.loading_context

			loading_context_3.finished_tutorial = true

			local floor_3 = math.floor
			local time_3

			if not Managers.time then
				time_3 = Managers.time:time("game")

				if not time_3 then
					-- Nothing
				end
			end

			time_3 = -1

			::label_25_3::

			loading_context_3.time_spent_in_level = floor_3(time_3)
			loading_context_3.end_reason = "finished_tutorial"

			if not Managers.play_go:installed() then
				loading_context_3.restart_network = true
				loading_context_3.play_trailer = Application.user_setting("play_intro_cinematic")

				printf("[StateIngame] Transition to StateLoadingRestartNetwork on %q", exit_type)
			else
				self.leave_lobby = true
				loading_context_3.restart_network = nil

				Managers.account:set_should_teardown_xboxlive()

				local should_run_tutorial_2, var_25_58 = Managers.mechanism:should_run_tutorial()

				loading_context_3.switch_to_tutorial_backend = should_run_tutorial_2
				loading_context_3.wanted_tutorial_state = var_25_58

				printf("[StateIngame] Transition to StateLoadingRunning on %q", exit_type)
			end

			return StateLoading
		elseif exit_type == "perform_host_migration" then
			local create_host_migration_info = Managers.mechanism:create_host_migration_info(self._gm_event_end_conditions_met, self._gm_event_end_reason)

			self.parent.loading_context.host_migration_info = create_host_migration_info
			self.parent.loading_context.wanted_profile_index = self:wanted_profile_index()
			self.parent.loading_context.wanted_party_index = self:wanted_party_index()

			local loading_context_4 = self.parent.loading_context
			local floor_4 = math.floor
			local time_4

			if not Managers.time then
				time_4 = Managers.time:time("game")

				if not time_4 then
					-- Nothing
				end
			end

			time_4 = -1

			::label_25_4::

			loading_context_4.time_spent_in_level = floor_4(time_4)
			self.parent.loading_context.end_reason = "host_migration"
			self.leave_lobby = true

			return StateLoading
		elseif exit_type == "versus_migration" then
			local create_versus_migration_info = Managers.mechanism:game_mechanism():create_versus_migration_info(self._gm_event_end_conditions_met, self._gm_event_end_reason)

			self.parent.loading_context.versus_migration_info = create_versus_migration_info
			self.parent.loading_context.versus_migration = true

			local loading_context_5 = self.parent.loading_context
			local floor_5 = math.floor
			local time_5

			if not Managers.time then
				time_5 = Managers.time:time("game")

				if not time_5 then
					-- Nothing
				end
			end

			time_5 = -1

			::label_25_5::

			loading_context_5.time_spent_in_level = floor_5(time_5)
			self.parent.loading_context.end_reason = "versus_migration"
			self.leave_lobby = true

			return StateLoading
		elseif exit_type == "rejoin_party" then
			local loading_context_6 = self.parent.loading_context

			loading_context_6.restart_network = true
			loading_context_6.rejoin_lobby = true

			local loading_context_7 = self.parent.loading_context
			local floor_6 = math.floor
			local time_6

			if not Managers.time then
				time_6 = Managers.time:time("game")

				if not time_6 then
					-- Nothing
				end
			end

			time_6 = -1

			::label_25_6::

			loading_context_7.time_spent_in_level = floor_6(time_6)
			self.parent.loading_context.end_reason = "rejoin_party"
			self.leave_lobby = true

			return StateLoading
		elseif exit_type == "restart_game_server" then
			self.leave_lobby = true

			return StateDedicatedServer
		elseif exit_type == "backend_disconnected" then
			printf("[StateIngame] Transition to StateTitleScreen on %q", self.exit_type)

			self.release_level_resources = true
			self.parent.loading_context = {}

			return StateTitleScreen
		elseif exit_type == "offline_invite" then
			printf("[StateIngame] Transition to StateTitleScreen on %q", self.exit_type)

			self.release_level_resources = true
			self.parent.loading_context = {}
			self.parent.loading_context.offline_invite = true

			return StateTitleScreen
		elseif exit_type == "return_to_title_screen" then
			printf("[StateIngame] Transition to StateTitleScreen on %q", self.exit_type)

			self.release_level_resources = true
			self.parent.loading_context = {}

			return StateTitleScreen
		elseif exit_type == "return_to_demo_title_screen" then
			printf("[StateIngame] Transition to Demo StateTitleScreen on %q", self.exit_type)

			self.parent.loading_context = {}

			return StateTitleScreen
		elseif not (exit_type == "load_next_level" or exit_type ~= "reload_level") then
			local loading_context_8 = self.parent.loading_context
			local get_checkpoint_data

			if not self.is_server then
				get_checkpoint_data = Managers.level_transition_handler:get_checkpoint_data()

				if not get_checkpoint_data then
					-- Nothing
				end
			end

			get_checkpoint_data = nil

			::label_25_7::

			loading_context_8.checkpoint_data = get_checkpoint_data
			self.parent.loading_context.matchmaking_loading_context = Managers.matchmaking:loading_context()
			self.parent.loading_context.wanted_profile_index = self:wanted_profile_index()
			self.parent.loading_context.wanted_party_index = self:wanted_party_index()

			local loading_context_9 = self.parent.loading_context
			local has_pending_quick_game = Managers.venture.quickplay:has_pending_quick_game()

			has_pending_quick_game = has_pending_quick_game or nil
			loading_context_9.quickplay_bonus = has_pending_quick_game

			local loading_context_10 = self.parent.loading_context
			local twitch = Managers.twitch

			twitch = not twitch and Managers.twitch:get_twitch_popup_message()
			loading_context_10.previous_session_error = twitch

			local loading_context_11 = self.parent.loading_context
			local floor_7 = math.floor
			local time_7

			if not Managers.time then
				time_7 = Managers.time:time("game")

				if not time_7 then
					-- Nothing
				end
			end

			time_7 = -1

			::label_25_8::

			loading_context_11.time_spent_in_level = floor_7(time_7)
			self.parent.loading_context.end_reason = Managers.state.game_mode:get_end_reason()

			return StateLoading
		elseif exit_type == "join_game" then
			self.leave_lobby = true
			self.parent.loading_context.matchmaking_loading_context = Managers.matchmaking:loading_context()
			self.parent.loading_context.wanted_profile_index = self:wanted_profile_index()
			self.parent.loading_context.wanted_party_index = self:wanted_party_index()

			local loading_context_12 = self.parent.loading_context
			local has_pending_quick_game_2

			if not self.is_server then
				has_pending_quick_game_2 = Managers.venture.quickplay:has_pending_quick_game()

				if not has_pending_quick_game_2 then
					-- Nothing
				end
			end

			has_pending_quick_game_2 = nil

			::label_25_9::

			loading_context_12.quickplay_bonus = has_pending_quick_game_2

			local loading_context_13 = self.parent.loading_context
			local floor_8 = math.floor
			local time_8

			if not Managers.time then
				time_8 = Managers.time:time("game")

				if not time_8 then
					-- Nothing
				end
			end

			time_8 = -1

			::label_25_10::

			loading_context_13.time_spent_in_level = floor_8(time_8)
			self.parent.loading_context.end_reason = "join_game"

			return StateLoading
		elseif exit_type == "restart_game" then
			printf("[StateIngame] Transition to StateSplashScreen on %q", self.exit_type)

			self.leave_lobby = true
			self.release_level_resources = true
			self.parent.loading_context.restart_network = true
			self.parent.loading_context.reload_packages = true

			return StateSplashScreen
		end
	end
end

StateIngame.wanted_profile_index = function (self)
	-- function 26
	local peer_id = Network.peer_id()
	local player_from_peer_id = Managers.player:player_from_peer_id(peer_id)
	local flag = not player_from_peer_id and player_from_peer_id:profile_index()

	if not self.is_in_tutorial then
		flag = nil
	end

	local selected_profile_index = Managers.matchmaking.selected_profile_index
	local wanted_profile_index = SaveData.wanted_profile_index

	return selected_profile_index or flag or wanted_profile_index or 0
end

StateIngame.wanted_party_index = function (arg_27_0)
	-- function 27
	local selected_party_index = Managers.matchmaking.selected_party_index

	selected_party_index = selected_party_index or 0

	return selected_party_index
end

StateIngame.post_update = function (self, arg_28_1)
	-- function 28
	local time = Managers.time:time("game")

	self.entity_system:post_update(arg_28_1, time)

	for k, v in pairs(self.machines) do
		if not v.post_update then
			v:post_update(arg_28_1, time)
		end
	end

	Managers.state.game_mode:update_flow_object_set_enable(arg_28_1)
	Managers.state.game_mode:post_update(arg_28_1, time)
	Managers.state.unit_spawner:spawn_queued_units()

	local network = Managers.state.network

	network.network_transmit:transmit_local_rpcs()
	Managers.state.unit_spawner:update_death_watch_list(arg_28_1, time)
	Managers.state.conflict:post_update()
	self.entity_system:commit_and_remove_pending_units()
	network:update_transmit(arg_28_1)

	if not Managers.voice_chat then
		Managers.voice_chat:update(arg_28_1, time)
	end
end

StateIngame.pre_render = function (self)
	-- function 29
	if not self.machines then
		return
	end

	for k, v in pairs(self.machines) do
		if not v.pre_render then
			v:pre_render()
		end
	end
end

StateIngame.render = function (self)
	-- function 30
	if not self.machines then
		return
	end

	for k, v in pairs(self.machines) do
		if not v.render then
			v:render()
		end
	end
end

StateIngame.post_render = function (self)
	-- function 31
	if not self.machines then
		return
	end

	for k, v in pairs(self.machines) do
		if not v.post_render then
			v:post_render()
		end
	end
end

StateIngame.on_exit = function (self, arg_32_1)
	-- function 32
	UPDATE_POSITION_LOOKUP()
	Managers:on_round_end()

	if not (not self.is_in_inn and self._gm_event_end_conditions_met or arg_32_1) then
		Managers.backend:commit()
	end

	self._camera_carrier:destroy()

	self._camera_carrier = nil

	self.free_flight_manager:cleanup_free_flight()

	if not (not IS_XB1 and self.hero_stats_updated) then
		Managers.xbox_stats:update_hero_stats(nil)

		self.hero_stats_updated = true
	end

	self._fps_reporter:report()
	self._ping_reporter:report()
	self:_check_and_add_end_game_telemetry(arg_32_1)

	if not TelemetrySettings.collect_memory then
		local memory_tree = Profiler.memory_tree()
		local memory_resources = Profiler.memory_resources("all")

		Managers.telemetry_events:memory_statistics(memory_tree, memory_resources, "game_ended")
	end

	Managers.telemetry_events.rpc_listener:unregister(self.network_event_delegate)
	Managers.state.performance_title:unregister_rpcs()
	DebugKeyHandler.set_enabled(false)
	DebugScreen.destroy()
	self.network_timer_handler:unregister_rpcs()
	self.network_timer_handler:destroy()

	self.network_timer_handler = nil

	self.network_clock:unregister_rpcs()
	self.network_clock:destroy()

	self.network_clock = nil

	if not Managers.twitch then
		Managers.twitch:deactivate_twitch_game_mode()
	end

	for k, v in pairs(self.machines) do
		Managers.player:remove_player(Network.peer_id(), k)
		v:destroy()
	end

	self.machines = nil

	Network.write_dump_tag("end of game")
	Managers.music:on_exit_level()

	local level_transition_handler = Managers.level_transition_handler

	level_transition_handler:unregister_rpcs()
	Managers.mechanism:unregister_rpcs()
	Managers.party:unregister_rpcs()
	Managers.state.game_mode:cleanup_game_mode_units()
	Managers.state.game_mode:deactivate_mutators(true)

	local unit_spawner = Managers.state.unit_spawner

	unit_spawner.locked = false

	unit_spawner:commit_and_remove_pending_units()

	local world = self.world
	local units = Managers.state.unit_storage:units()

	for k_2, v_2 in pairs(units) do
		if not Unit.is_valid(v_2) then
			Managers.state.entity:unregister_unit(v_2)
			World.destroy_unit(world, v_2)
		end
	end

	self.entity_system:destroy()
	self.entity_system_bag:destroy()
	ScriptWorld.trigger_level_shutdown(self.level)
	Managers.player:exit_ingame()
	self:_teardown_level()
	Managers.weave:teardown()
	Managers.state:destroy()
	VisualAssertLog.cleanup()
	self:_teardown_world()
	ScriptUnit.check_all_units_deleted()

	if not arg_32_1 then
		level_transition_handler.enemy_package_loader:on_application_shutdown()
		level_transition_handler.pickup_package_loader:on_application_shutdown()
		level_transition_handler.general_synced_package_loader:on_application_shutdown()
	end

	level_transition_handler.transient_package_loader:unload_all_packages(arg_32_1)
	self.statistics_db:unregister_network_event_delegate()
	Managers.time:unregister_timer("game")

	local matchmaking_loading_context = self.parent.loading_context.matchmaking_loading_context

	if not matchmaking_loading_context and not matchmaking_loading_context.network_client then
		matchmaking_loading_context.network_client:unregister_rpcs()
	end

	if not self.network_client then
		self.network_client:unregister_rpcs()
	end

	if not (not self.network_server and arg_32_1) then
		self.network_server:on_level_exit()
	end

	if not self.network_client then
		self.network_client.voip:set_input_manager(nil)
	end

	if not self.network_server then
		self.network_server.voip:set_input_manager(nil)
	end

	if not Managers.matchmaking then
		Managers.matchmaking:unregister_rpcs()
	end

	Managers.deed:unregister_rpcs()

	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")

	if arg_32_1 or not self.leave_lobby then
		if not Managers.matchmaking then
			Managers.matchmaking:destroy()

			Managers.matchmaking = nil
		end

		if not Managers.game_server then
			Managers.game_server:destroy()

			Managers.game_server = nil
		end

		Managers.chat:unregister_channel(1)
		Managers.mechanism:mechanism_try_call("unregister_chats")
		Managers.deed:network_context_destroyed()
		level_transition_handler.enemy_package_loader:network_context_destroyed()
		level_transition_handler.pickup_package_loader:network_context_destroyed()
		level_transition_handler.general_synced_package_loader:network_context_destroyed()
		level_transition_handler.transient_package_loader:network_context_destroyed()
		Managers.party:network_context_destroyed()

		local loading_context = self.parent.loading_context
		local flag = not loading_context and loading_context.host_migration_info
		local flag_2 = not flag and flag.current_level_key

		Managers.mechanism:network_context_destroyed(flag_2)

		local tbl = {
			__index = function (arg_33_0, arg_33_1)
				-- function 33
				return function ()
					-- function 34
					Application.warning("Got RPC %s during forced network update when exiting StateIngame", arg_33_1)
				end
			end
		}
		local start_lobby_data = loading_context.start_lobby_data

		if not start_lobby_data then
			start_lobby_data = loading_context.join_lobby_data
			start_lobby_data = start_lobby_data or loading_context.join_server_data
		end

		local flag_3 = start_lobby_data == nil or start_lobby_data.join_method == "party"

		if not get_lobby.is_host then
			if not self.network_server then
				self.network_server:destroy()

				self.network_server = nil
			end
		else
			if not flag_3 then
				Managers.party:store_lobby(get_lobby:get_stored_lobby_data())
			end

			if not self.network_client then
				self.network_client:destroy()

				self.network_client = nil
			end
		end

		Managers.lobby:destroy_lobby("matchmaking_session_lobby")
		Network.update(0, setmetatable({}, tbl))
		Managers.account:set_current_lobby(nil)

		if not arg_32_1 and not rawget(_G, "LobbyInternal") then
			if not Managers.party:has_party_lobby() then
				local steal_lobby = Managers.party:steal_lobby()

				if type(steal_lobby) ~= "table" then
					LobbyInternal.leave_lobby(steal_lobby)
				end
			end

			LobbyInternal.shutdown_client()
		end

		self.profile_synchronizer = nil
		self.parent.loading_context.network_client = nil
		self.parent.loading_context.network_server = nil
		self.parent.loading_context.network_transmit = nil

		self.network_transmit:destroy()

		self.network_transmit = nil
	else
		self.profile_synchronizer:unregister_network_events()

		if not (not self.is_server and self.is_in_inn and self.is_in_tutorial and not IS_XB1 and script_data.honduras_demo) then
			local get_current_level_key = level_transition_handler:get_current_level_key()

			if not (LevelSettings[get_current_level_key].hub_level or get_current_level_key ~= "prologue") then
				Application.warning("Cancelling matchmaking")
				get_lobby:enable_matchmaking(false)
			end
		end
	end

	self.free_flight_manager:unregister_input_manager()

	self.free_flight_manager = nil
	self.parent = nil

	if not self._debug_event_manager_rpc then
		self._debug_event_manager_rpc:delete()

		self._debug_event_manager_rpc = nil
	end

	Managers.chat:unregister_network_event_delegate()
	Managers.eac:unregister_network_event_delegate()

	if not Managers.mod then
		Managers.mod:unregister_network_event_delegate()
	end

	self.dice_keeper:unregister_rpc()

	self.dice_keeper = nil

	Managers.popup:remove_input_manager(arg_32_1)
	InputDebugger:clear()
	self.input_manager:destroy()

	self.input_manager = nil
	Managers.input = nil

	self.network_event_delegate:unregister(self)
	self.network_event_delegate:destroy()

	self.network_event_delegate = nil

	if arg_32_1 or not self.release_level_resources then
		level_transition_handler:release_level_resources()
	end

	Managers.transition:show_loading_icon()
	self:_remove_ingame_clock()
	Managers.unlock:enable_update_unlocks(false)
	Managers.package:unload_dangling_painting_materials()
	Managers.mechanism:check_venture_end(self.leave_lobby)
end

StateIngame.on_close = function (self)
	-- function 35
	if not (not self.network_server and not (self.network_server:num_active_peers() > 1) or Development.parameter("disable_exit_popup_warning")) then
		if not self._onclose_called then
			if not self.is_in_inn then
				self:_commit_playfab_stats()
			else
				self._quit_game = true
			end
		else
			self._onclose_called = true

			Managers.chat.chat_gui:hide_chat()
			Managers.chat.chat_gui:unblock_input()
		end
	elseif not self.is_in_inn then
		self:_commit_playfab_stats()
	else
		self._quit_game = true
	end

	return false
end

StateIngame._commit_playfab_stats = function (arg_36_0)
	-- function 36
	local backend = Managers.backend

	local function fn(arg_37_0)
		-- function 37
		arg_36_0._quit_game = true
	end

	backend:on_shutdown(fn)
end

StateIngame._check_and_add_end_game_telemetry = function (self, arg_38_1)
	-- function 38
	local player_from_peer_id = Managers.player:player_from_peer_id(self.peer_id)
	local exit_type = self.exit_type

	if not arg_38_1 then
		exit_type = not Boot.is_controlled_exit and "controlled_exit" and "forced_exit"
	elseif not (self.exit_type == "load_next_level" or self.exit_type == "reload_level") then
		if not Managers.state.game_mode:game_won(player_from_peer_id) then
			exit_type = "won"
		elseif not Managers.state.game_mode:game_lost(player_from_peer_id) then
			exit_type = "lost"
		end
	end

	Managers.telemetry_events:game_ended(exit_type)
end

StateIngame._setup_state_context = function (self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local var_39_0

	if not self.is_server then
		var_39_0 = NetworkClockServer:new()
	else
		var_39_0 = NetworkClockClient:new()
	end

	self.network_clock = var_39_0

	var_39_0:register_rpcs(arg_39_3)

	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local var_39_2 = GameNetworkManager:new(arg_39_1, get_lobby, arg_39_2, arg_39_3)

	Managers.state.network = var_39_2

	local BUILD = BUILD

	if not (BUILD == "debug" or BUILD ~= "dev") then
		self._debug_event_manager_rpc = DebugEventManagerRPC:new(arg_39_3)
	end

	if not (not Development.parameter("weave_name") and Managers.weave:get_active_objective()) then
		Managers.mechanism:choose_next_state("weave")
		Managers.mechanism:progress_state()
	end

	local var_39_4 = EventManager:new(Managers.persistent_event)

	Managers.state.event = var_39_4
	Managers.state.flow_helper = FlowHelperManager:new(arg_39_1)

	local level_transition_handler = Managers.level_transition_handler
	local get_current_game_mode = level_transition_handler:get_current_game_mode()
	local start_next_round, var_39_8, var_39_9 = Managers.mechanism:start_next_round()

	Managers.state.side = SideManager:new(var_39_8)

	for k, v in pairs(DLCSettings) do
		local achievement_events = v.achievement_events

		if not achievement_events then
			for k_2, v_2 in pairs(achievement_events) do
				var_39_4:register(achievement_events, k_2, k_2)
			end
		end
	end

	self.game_mode_key = get_current_game_mode

	Managers.weave:initiate(arg_39_1, arg_39_3, arg_39_2, get_current_game_mode)

	local state = Managers.state
	local GameModeManager = GameModeManager
	local var_39_13 = GameModeManager
	local new = GameModeManager.new
	local var_39_15 = arg_39_1
	local var_39_16 = get_lobby
	local var_39_17 = arg_39_3
	local statistics_db = self.statistics_db
	local var_39_19 = get_current_game_mode
	local network_server = self.network_server

	network_server = network_server or self.network_client
	state.game_mode = new(var_39_13, var_39_15, var_39_16, var_39_17, statistics_db, var_39_19, network_server, self.network_transmit, self.profile_synchronizer, var_39_9)

	local get_current_level_keys = level_transition_handler:get_current_level_keys()
	local get_current_level_seed = level_transition_handler:get_current_level_seed()
	local get_current_conflict_director = level_transition_handler:get_current_conflict_director()

	Managers.state.conflict = ConflictDirector:new(arg_39_1, get_current_level_keys, arg_39_3, get_current_level_seed, arg_39_2, get_current_conflict_director)
	Managers.state.networked_flow_state = NetworkedFlowStateManager:new(arg_39_1, arg_39_2, arg_39_3)

	Managers.level_transition_handler:create_queued_networked_flow_states(self.level)
	GarbageLeakDetector.register_object(Managers.state.game_mode, "GameModeManager")
	GarbageLeakDetector.register_object(Managers.state.conflict, "ConflictDirector")

	Managers.state.camera = CameraManager:new(arg_39_1)

	GarbageLeakDetector.register_object(Managers.state.camera, "CameraManager")

	local var_39_24 = EntityManager2:new()

	Managers.state.entity = var_39_24

	if not DEDICATED_SERVER then
		Managers.state.decal = DecalManager:new(arg_39_1)
	end

	local scripts_network_unit_extension_templates = require("scripts/network/unit_extension_templates")

	local function fn(arg_40_0, arg_40_1)
		-- function 40
		if not arg_40_1 then
			local extension_definitions, var_40_1 = ScriptUnit.extension_definitions(arg_40_0)

			return extension_definitions, var_40_1
		end

		local flag = not NetworkUnit.is_network_unit(arg_40_0) and NetworkUnit.is_husk_unit(arg_40_0)
		local get_extensions, var_40_4 = scripts_network_unit_extension_templates.get_extensions(arg_40_1, flag, arg_39_2)

		if not get_extensions then
			get_extensions, var_40_4 = ScriptUnit.extension_definitions(arg_40_0)
		end

		return get_extensions, var_40_4
	end

	Managers.state.entity:set_extension_extractor_function(fn)

	self._debug_gui = World.create_screen_gui(arg_39_1, "material", "materials/fonts/gw_fonts")
	self._debug_gui_immediate = World.create_screen_gui(arg_39_1, "material", "materials/fonts/gw_fonts", "immediate")
	Managers.state.debug_text = DebugTextManager:new(arg_39_1, self._debug_gui, arg_39_2, arg_39_3)
	Managers.state.performance = PerformanceManager:new(self._debug_gui_immediate, arg_39_2, get_current_level_keys)
	Managers.state.world_interaction = WorldInteractionManager:new(self.world)

	local wwise_world = Managers.world:wwise_world(arg_39_1)
	local tbl = {
		network_event_delegate = arg_39_3,
		is_server = self.is_server,
		input_manager = self.input_manager,
		network_server = self.network_server,
		wwise_world = wwise_world
	}

	Managers.state.voting = VoteManager:new(tbl)
	self.dice_keeper = DiceKeeper:new(7)

	self.dice_keeper:register_rpcs(arg_39_3)

	local var_39_29 = UnitSpawner:new(arg_39_1, var_39_24, arg_39_2)

	Managers.state.unit_spawner = var_39_29

	level_transition_handler.enemy_package_loader:set_unit_spawner(var_39_29)
	var_39_29:set_unit_template_lookup_table(scripts_network_unit_extension_templates)

	local var_39_30 = NetworkUnitStorage:new()

	Managers.state.unit_storage = var_39_30

	var_39_29:set_unit_storage(var_39_30)

	local tbl_2 = {
		world = arg_39_1
	}
	local scripts_network_game_object_initializers_extractors = require("scripts/network/game_object_initializers_extractors")

	var_39_29:set_gameobject_initializer_data(scripts_network_game_object_initializers_extractors.initializers, scripts_network_game_object_initializers_extractors.extractors, tbl_2)
	var_39_29:set_gameobject_to_unit_creator_function(scripts_network_game_object_initializers_extractors.unit_from_gameobject_creator_func)

	self.free_flight_manager = Managers.free_flight

	self.free_flight_manager:register_input_manager(self.input_manager)

	self.network_timer_handler = NetworkTimerHandler:new(self.world, self.network_clock, self.is_server)

	self.network_timer_handler:register_rpcs(arg_39_3)

	Managers.state.debug = DebugManager:new(arg_39_1, self.free_flight_manager, self.input_manager, arg_39_3, arg_39_2)
	Managers.state.spawn = SpawnManager:new(arg_39_1, arg_39_2, arg_39_3, var_39_29, self.profile_synchronizer, self.network_server)

	local get_current_level_keys_2 = level_transition_handler:get_current_level_keys()
	local get_current_environment_variation_name = level_transition_handler:get_current_environment_variation_name()
	local tbl_3 = {
		profile_synchronizer = self.profile_synchronizer,
		game_mode = Managers.state.game_mode,
		networked_flow_state = Managers.state.networked_flow_state,
		room_manager = Managers.state.room,
		spawn_manager = Managers.state.spawn,
		network_clock = self.network_clock,
		player_manager = Managers.player,
		network_transmit = self.network_transmit,
		network_server = self.network_server,
		network_client = self.network_client,
		statistics_db = self.statistics_db,
		difficulty_manager = Managers.state.difficulty,
		weave_manager = Managers.weave,
		matchmaking_manager = Managers.matchmaking,
		voting_manager = Managers.state.voting,
		game_server_manager = Managers.game_server
	}

	var_39_2:post_init(tbl_3)

	self.entity_system_bag = EntitySystemBag:new()

	local tbl_4 = {
		entity_manager = var_39_24,
		input_manager = self.input_manager,
		unit_spawner = var_39_29,
		world = self.world,
		startup_data = {
			level_key = get_current_level_keys_2,
			environment_variation_name = get_current_environment_variation_name
		},
		is_server = arg_39_2,
		free_flight_manager = self.free_flight_manager,
		network_event_delegate = arg_39_3,
		unit_storage = var_39_30,
		entity_system_bag = self.entity_system_bag,
		network_clock = self.network_clock,
		network_manager = Managers.state.network,
		network_lobby = get_lobby,
		network_transmit = self.network_transmit,
		network_server = self.network_server,
		profile_synchronizer = self.profile_synchronizer,
		dice_keeper = self.dice_keeper,
		system_api = {},
		statistics_db = self.statistics_db,
		num_local_human_players = self.num_local_human_players,
		level_transition_handler = level_transition_handler
	}
	local var_39_37 = EntitySystem:new(tbl_4)

	GarbageLeakDetector.register_object(var_39_37, "EntitySystem")
	GarbageLeakDetector.register_object(tbl_4, "entity_systems_init_context")
	GarbageLeakDetector.register_object(tbl_4.system_api, "system_api")

	self.entity_system = var_39_37

	Managers.player:set_is_server(arg_39_2, arg_39_3, Managers.state.network)
	Managers.state.network:set_entity_system(var_39_37)
	Managers.state.network:set_unit_storage(var_39_30)
	Managers.state.network:set_unit_spawner(var_39_29)

	Managers.state.vce = VCEManager:new()

	local scripts_utils_debug_screen_config = require("scripts/utils/debug_screen_config")

	DebugScreen.setup(self._top_gui_world, scripts_utils_debug_screen_config.settings, scripts_utils_debug_screen_config.callbacks, arg_39_2)

	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local get_data = World.get_data(arg_39_1, "physics_world")

	Managers.state.bot_nav_transition = BotNavTransitionManager:new(arg_39_1, get_data, nav_world, arg_39_2, arg_39_3)

	if not DEDICATED_SERVER then
		Managers.state.quest = QuestManager:new(self.statistics_db)
	end

	Managers.state.achievement = AchievementManager:new(self.world, self.statistics_db)

	if not DEDICATED_SERVER then
		Managers.state.blood = BloodManagerDummy:new()
	else
		Managers.state.blood = BloodManager:new(self.world)
	end

	Managers.state.status_effect = StatusEffectManager:new(self.world)
	Managers.state.performance_title = PerformanceTitleManager:new(self.network_transmit, self.statistics_db, arg_39_2)

	Managers.state.performance_title:register_rpcs(arg_39_3)
	Managers.mechanism:state_context_set_up()
end

StateIngame.rpc_kick_peer = function (self, arg_41_1)
	-- function 41
	if self.network_client == nil then
		return
	end

	local var_41_0 = CHANNEL_TO_PEER_ID[arg_41_1]

	if self.network_client.server_peer_id ~= var_41_0 then
		return
	end

	if not self.is_server then
		return
	end

	if not Managers.party:is_leader(self.peer_id) then
		return
	end

	self.kicked_by_server = true
end

StateIngame.event_play_particle_effect = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	-- function 42
	if not arg_42_6 then
		ScriptWorld.create_particles_linked(self.world, arg_42_1, arg_42_2, arg_42_3, "destroy", Matrix4x4.from_quaternion_position(arg_42_5, arg_42_4))
	else
		local var_42_0
		local var_42_1

		if not arg_42_2 then
			var_42_0 = Unit.world_position(arg_42_2, arg_42_3)
			var_42_1 = Unit.world_rotation(arg_42_2, arg_42_3)
		else
			var_42_0 = Vector3(0, 0, 0)
			var_42_1 = Quaternion.identity()
		end

		local from_quaternion_position = Matrix4x4.from_quaternion_position(var_42_1, var_42_0)
		local from_quaternion_position_2 = Matrix4x4.from_quaternion_position(arg_42_5, arg_42_4)
		local multiply = Matrix4x4.multiply(from_quaternion_position_2, from_quaternion_position)

		World.create_particles(self.world, arg_42_1, Matrix4x4.translation(multiply), Matrix4x4.rotation(multiply))
	end
end

StateIngame.gm_event_end_conditions_met = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	Managers.state.game_mode:gm_event_end_conditions_met(arg_43_1, arg_43_2, arg_43_3)
	LevelHelper:flow_event(self.world, "gm_event_end_conditions_met")

	self._gm_event_end_conditions_met = true
	self._gm_event_end_reason = arg_43_1

	if not self.is_server then
		Managers.state.voting:set_vote_kick_enabled(false)
	end

	Managers.state.conflict:set_disabled(true)

	local player_from_peer_id = Managers.player:player_from_peer_id(self.peer_id)
	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local evaluate_end_condition_outcome, var_43_3 = Managers.state.game_mode:evaluate_end_condition_outcome(arg_43_1, player_from_peer_id)

	print("gm_event_end_conditions_met", evaluate_end_condition_outcome, var_43_3)
	Managers.popup:cancel_all_popups()
	Managers.account:check_popup_retrigger()

	if game_mode_key == "survival" then
		if not evaluate_end_condition_outcome and not self.is_server then
			Managers.state.entity:system("leaderboard_system"):round_completed()

			if GameSettingsDevelopment.use_leaderboards or not Development.parameter("use_leaderboards") then
				StatisticsUtil.register_online_leaderboards_data(self.statistics_db)
			end
		end
	elseif not evaluate_end_condition_outcome then
		Managers.state.entity:system("mission_system"):evaluate_level_end_missions()

		if not IS_PS4 then
			local level_key = Managers.state.game_mode:level_key()
			local display_name = LevelSettings[level_key].display_name
			local display_name_2 = Managers.state.difficulty:get_difficulty_settings().display_name

			Managers.account:activity_feed_post_mission_completed(display_name, display_name_2)
		end
	elseif not var_43_3 and not self.is_server and not arg_43_2 then
		Managers.state.voting:request_vote("continue_level", nil, Network.peer_id())
	end

	if not (not self.is_server and self.is_in_inn) then
		local human_players = Managers.player:human_players()

		Managers.state.performance_title:evaluate_titles(human_players)
	end

	for k, v in pairs(self.machines) do
		v:state():gm_event_end_conditions_met(arg_43_1, arg_43_2, arg_43_3)
	end

	if not self.is_server and not DEDICATED_SERVER then
		local is_final_round = Managers.mechanism:is_final_round()
		local get_players_session_score = Managers.mechanism:get_players_session_score(self.statistics_db, self.profile_synchronizer, self._saved_scoreboard_stats)

		if not is_final_round then
			Managers.mechanism:sync_players_session_score(get_players_session_score)
		else
			self.parent.loading_context.saved_scoreboard_stats = get_players_session_score
		end
	end
end

StateIngame._generate_ingame_clock = function (self)
	-- function 44
	if not (not self.network_server and Managers.time:time("client_ingame") ~= nil) then
		local peer_state_machines = self.network_server.peer_state_machines

		for k, v in pairs(peer_state_machines) do
			if v.current_state.state_name == "InGame" then
				Managers.time:register_timer("client_ingame", "main", 0)

				break
			end
		end
	end
end

StateIngame._remove_ingame_clock = function (arg_45_0)
	-- function 45
	local time = Managers.time

	if not time:has_timer("client_ingame") then
		time:unregister_timer("client_ingame")
	end
end

StateIngame._handle_onclose_warning_result = function (self)
	-- function 46
	if not self._onclose_popup_id then
		local query_result = Managers.popup:query_result(self._onclose_popup_id)

		if query_result == "end_game" then
			if not self.is_in_inn then
				self:_commit_playfab_stats()
			else
				self._quit_game = true
			end
		elseif query_result == "cancel_popup" then
			self._onclose_popup_id = nil
			self._onclose_called = false
		end
	end
end
