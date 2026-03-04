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

local var_0_0 = script_data.testify and require("scripts/game_state/state_ingame_testify")

StateIngame = class(StateIngame)
StateIngame.NAME = "StateIngame"

function StateIngame.on_enter(arg_1_0)
	fassert(arg_1_0.parent.loading_context.ingame_world_object, "must have world")
	fassert(arg_1_0.parent.loading_context.ingame_level_object, "must have level")

	arg_1_0.parent.loading_context.ingame_world_object, arg_1_0.world = arg_1_0.world, arg_1_0.parent.loading_context.ingame_world_object
	arg_1_0.parent.loading_context.ingame_level_object, arg_1_0.level = arg_1_0.level, arg_1_0.parent.loading_context.ingame_level_object

	if IS_XB1 then
		Application.set_kinect_enabled(false)

		arg_1_0.hero_stats_updated = false
	end

	local var_1_0 = arg_1_0.parent.loading_context
	local var_1_1 = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local var_1_2 = var_1_1.is_host

	arg_1_0.is_server = var_1_2

	print("[Gamestate] Enter StateIngame", var_1_2 and "HOST" or "CLIENT")

	local var_1_3 = true

	GarbageLeakDetector.run_leak_detection(var_1_3)
	GarbageLeakDetector.register_object(arg_1_0, "StateIngame")
	NetworkUnit.reset_unit_data()
	Managers.time:register_timer("game", "main")
	CLEAR_POSITION_LOOKUP()
	Managers.mechanism:check_venture_start(arg_1_0.parent.loading_context)

	local var_1_4 = InputManager:new()

	arg_1_0.input_manager = var_1_4
	Managers.input = arg_1_0.input_manager

	var_1_4:initialize_device("keyboard")
	var_1_4:initialize_device("mouse")
	var_1_4:initialize_device("gamepad")

	if script_data.debug_enabled then
		var_1_4:create_input_service("Debug", "DebugKeymap", "DebugInputFilters")
		var_1_4:map_device_to_service("Debug", "keyboard")
		var_1_4:map_device_to_service("Debug", "mouse")
		var_1_4:map_device_to_service("Debug", "gamepad")
		var_1_4:create_input_service("DebugMenu", "DebugKeymap", "DebugInputFilters")
		var_1_4:map_device_to_service("DebugMenu", "keyboard")
		var_1_4:map_device_to_service("DebugMenu", "mouse")
		var_1_4:map_device_to_service("DebugMenu", "gamepad")
	end

	Managers.popup:set_input_manager(var_1_4)

	local var_1_5 = Managers.level_transition_handler:get_current_level_keys()

	Crashify.print_property("level", var_1_5)

	arg_1_0.level_key = var_1_5
	arg_1_0.is_in_inn = LevelSettings[var_1_5].hub_level
	arg_1_0.is_in_tutorial = var_1_5 == "prologue"
	DamageUtils.is_in_inn = arg_1_0.is_in_inn
	arg_1_0._called_level_flow_events = false
	arg_1_0._onclose_popup_id = nil
	arg_1_0._onclose_called = false
	arg_1_0._quit_game = false
	arg_1_0._gm_event_end_conditions_met = false
	arg_1_0._gm_event_end_reason = nil

	Managers.light_fx:set_lightfx_color_scheme(arg_1_0.is_in_inn and "inn_level" or "ingame")

	if IS_CONSOLE and arg_1_0.is_in_tutorial then
		Managers.backend:set_user_data("prologue_started", true)
		Managers.backend:commit()
	end

	if arg_1_0.is_in_inn then
		Managers.unlock:enable_update_unlocks(true)
	end

	local var_1_6 = Managers.venture.statistics

	var_1_0.statistics_db = var_1_6
	arg_1_0.statistics_db = var_1_6

	Managers.player:set_statistics_db(arg_1_0.statistics_db)

	arg_1_0._max_local_players = PlayerManager.MAX_PLAYERS

	if arg_1_0.is_server then
		local var_1_7 = var_1_1:get_stored_lobby_data()

		if var_1_7.mechanism == "adventure" then
			var_1_7.selected_mission_id = arg_1_0.level_key

			var_1_1:set_lobby_data(var_1_7)
		end
	end

	arg_1_0.world_name = LevelHelper.INGAME_WORLD_NAME

	arg_1_0:_setup_world()

	local var_1_8 = arg_1_0.world

	arg_1_0.peer_id = Network.peer_id()

	local var_1_9 = NetworkEventDelegate:new()

	arg_1_0.network_event_delegate = var_1_9
	arg_1_0.network_server = var_1_0.network_server
	arg_1_0.network_client = var_1_0.network_client

	if arg_1_0.network_server then
		arg_1_0.network_transmit = var_1_0.network_transmit or NetworkTransmit:new(var_1_2, arg_1_0.network_server.server_peer_id)

		arg_1_0.network_server:register_rpcs(var_1_9, arg_1_0.network_transmit)

		arg_1_0.profile_synchronizer = arg_1_0.network_server.profile_synchronizer

		arg_1_0.network_server.voip:set_input_manager(arg_1_0.input_manager)
		print("[StateIngame] Server ingame")
	elseif arg_1_0.network_client then
		print("[StateIngame] Client ingame")

		arg_1_0.network_transmit = var_1_0.network_transmit or NetworkTransmit:new(var_1_2, arg_1_0.network_client.server_peer_id)

		arg_1_0.network_client:register_rpcs(var_1_9, arg_1_0.network_transmit)

		arg_1_0.profile_synchronizer = arg_1_0.network_client.profile_synchronizer

		arg_1_0.network_client.voip:set_input_manager(arg_1_0.input_manager)
	end

	arg_1_0.network_transmit:set_network_event_delegate(var_1_9)
	var_1_9:register(arg_1_0, "rpc_kick_peer")
	arg_1_0.statistics_db:register_network_event_delegate(var_1_9)

	var_1_0.network_transmit = arg_1_0.network_transmit

	local var_1_10 = "top_ingame_view"

	arg_1_0._top_gui_world = Managers.world:world(var_1_10)

	Debug.setup(arg_1_0._top_gui_world, var_1_10)
	VisualAssertLog.setup(var_1_8)
	DebugKeyHandler.setup(var_1_8, arg_1_0.input_manager)
	FunctionCallProfiler.setup(var_1_8)

	if not script_data.debug_enabled then
		DebugKeyHandler.set_enabled(false)
	end

	Managers.state.crafting = CraftingManager:new()

	local var_1_11 = Managers.level_transition_handler
	local var_1_12 = var_1_11:get_current_difficulty()
	local var_1_13 = var_1_11:get_current_difficulty_tweak()

	if Development.parameter("weave_name") then
		local var_1_14 = Development.parameter("weave_name")

		var_1_12 = WeaveSettings.templates[var_1_14].difficulty_key
		var_1_13 = 0
	end

	Managers.state.difficulty = DifficultyManager:new(var_1_8, var_1_2, var_1_9, var_1_1)

	Managers.state.difficulty:set_difficulty(var_1_12, var_1_13)

	local var_1_15 = DEDICATED_SERVER and 0 or 1

	arg_1_0.num_local_human_players = var_1_15

	if Managers.matchmaking then
		if not DEDICATED_SERVER then
			Managers.matchmaking:reset_lobby_filters()
		end
	else
		local var_1_16 = {
			network_transmit = arg_1_0.network_transmit,
			network_server = arg_1_0.network_server,
			lobby = var_1_1,
			peer_id = arg_1_0.peer_id,
			is_server = var_1_2,
			profile_synchronizer = arg_1_0.profile_synchronizer,
			statistics_db = arg_1_0.statistics_db
		}

		if var_1_0.host_migration_info then
			var_1_16.game_mode_event_data = var_1_0.host_migration_info.game_mode_event_data
			var_1_0.host_migration_info = nil
		end

		Managers.matchmaking = MatchmakingManager:new(var_1_16)
	end

	Managers.matchmaking:register_rpcs(var_1_9)
	Managers.matchmaking:set_statistics_db(arg_1_0.statistics_db)
	Managers.deed:register_rpcs(var_1_9)
	arg_1_0:_setup_state_context(var_1_8, var_1_2, var_1_9)
	var_1_11:register_rpcs(var_1_9)
	Managers.mechanism:register_rpcs(var_1_9)
	Managers.party:register_rpcs(var_1_9)

	if rawget(_G, "ControllerFeaturesManager") then
		Managers.state.controller_features = ControllerFeaturesManager:new(arg_1_0.is_in_inn)
	end

	Managers.telemetry_events:client_session_id(Application.guid())
	Managers.telemetry_events.rpc_listener:register(arg_1_0.network_event_delegate)

	if var_1_2 then
		local var_1_17 = Managers.state.network:session_id()

		Managers.telemetry_events:server_session_id(var_1_17)
		arg_1_0.network_transmit:send_rpc_clients("rpc_to_client_sync_session_id", var_1_17)
	end

	local var_1_18 = Managers.state.event

	var_1_18:register(arg_1_0, "event_play_particle_effect", "event_play_particle_effect", "event_start_network_timer", "event_start_network_timer", "xbox_one_hack_start_game", "event_xbox_one_hack_start_game", "gm_event_end_conditions_met", "gm_event_end_conditions_met")

	for iter_1_0 = 1, var_1_15 do
		local var_1_19 = "player_" .. iter_1_0

		arg_1_0.viewport_name = var_1_19

		local var_1_20 = Managers.player:add_player(nil, var_1_19, arg_1_0.world_name, iter_1_0)
	end

	local var_1_21 = arg_1_0.level
	local var_1_22 = arg_1_0:_create_level()

	Managers.state.entity:system("darkness_system"):set_level(var_1_21)
	Managers.state.entity:system("ai_group_system"):set_level(var_1_21)

	local var_1_23 = Managers.mechanism:get_level_seed()
	local var_1_24 = var_1_0.checkpoint_data

	if arg_1_0.is_server then
		Managers.state.entity:system("pickup_system"):setup_taken_pickups(var_1_24)

		if var_1_24 then
			local var_1_25 = Managers.state

			var_1_25.spawn:load_checkpoint_data(var_1_24)
			var_1_25.conflict.level_analysis:set_random_seed(var_1_24.level_analysis)

			var_1_0.checkpoint_data = nil
		else
			local var_1_26 = Development.parameter("attract_mode") and BenchmarkSettings.game_seed or var_1_23

			Managers.state.conflict.level_analysis:set_random_seed(var_1_24, var_1_26)
		end
	end

	arg_1_0:_gather_backend_flow_events()

	if Managers.state.room then
		Managers.state.room:setup_level_anchor_points(arg_1_0.level)
	end

	local var_1_27 = LevelSettings[var_1_22].level_name

	ScriptWorld.optimize_level_units(var_1_8, var_1_27)
	InputDebugger:setup(var_1_8, arg_1_0.input_manager)

	arg_1_0.machines = {}

	local var_1_28 = var_1_0.level_end_view_wrappers
	local var_1_29 = Network.peer_id()

	for iter_1_1 = 1, var_1_15 do
		local var_1_30 = "player_" .. iter_1_1

		arg_1_0.viewport_name = var_1_30

		local var_1_31 = LobbySetup.network_options()
		local var_1_32 = {
			local_player_id = iter_1_1,
			viewport_name = var_1_30,
			is_in_inn = arg_1_0.is_in_inn,
			is_in_tutorial = arg_1_0.is_in_tutorial,
			is_server = var_1_2,
			network_options = var_1_31,
			input_manager = arg_1_0.input_manager,
			world_name = arg_1_0.world_name,
			free_flight_manager = arg_1_0.free_flight_manager,
			lobby = Managers.lobby:get_lobby("matchmaking_session_lobby"),
			profile_synchronizer = arg_1_0.profile_synchronizer,
			network_event_delegate = arg_1_0.network_event_delegate,
			statistics_db = arg_1_0.statistics_db,
			dice_keeper = arg_1_0.dice_keeper,
			level_key = var_1_22,
			network_server = arg_1_0.network_server,
			network_client = arg_1_0.network_client,
			network_transmit = arg_1_0.network_transmit,
			voip = arg_1_0.network_server and arg_1_0.network_server.voip or arg_1_0.network_client.voip
		}

		if var_1_28 and var_1_28[iter_1_1] then
			var_1_32.level_end_view_wrapper = var_1_28[iter_1_1]
		end

		if Managers.venture.quickplay:is_quick_game() then
			local var_1_33 = Managers.player:player(var_1_29, iter_1_1)

			StatisticsUtil.register_played_quickplay_level(arg_1_0.statistics_db, var_1_33, var_1_22)
		end

		arg_1_0.machines[iter_1_1] = GameStateMachine:new(arg_1_0, StateInGameRunning, var_1_32, true)
	end

	if arg_1_0.is_server and DEDICATED_SERVER and Managers.state.game_mode:game_mode_key() == "versus" then
		arg_1_0._saved_scoreboard_stats = arg_1_0.parent.loading_context.saved_scoreboard_stats
		arg_1_0.parent.loading_context.saved_scoreboard_stats = nil
	end

	if var_1_24 then
		Managers.state.entity:system("mission_system"):load_checkpoint_data(var_1_24.mission)
	end

	local var_1_34 = Managers.world:wwise_world(var_1_8)

	if Managers.matchmaking then
		local var_1_35 = {
			hero_spawner_handler = Managers.state.spawn.hero_spawner_handler,
			difficulty = Managers.state.difficulty,
			wwise_world = var_1_34,
			reset_matchmaking = arg_1_0.is_in_inn,
			is_in_inn = arg_1_0.is_in_inn
		}

		Managers.matchmaking:setup_post_init_data(var_1_35)
	end

	ScriptWorld.trigger_level_loaded(var_1_8, var_1_27)
	World.set_data(arg_1_0.world, "level_seed", nil)

	if var_1_24 then
		Managers.state.networked_flow_state:load_checkpoint_data(var_1_24.networked_flow_state)
	end

	if arg_1_0.is_in_inn then
		local var_1_36 = Managers.mechanism:current_mechanism_name()

		if var_1_36 == "adventure" and not SaveData.first_time_in_inn then
			Level.trigger_event(var_1_21, "first_time_started_game")

			SaveData.first_time_in_inn = true

			Managers.save:auto_save(SaveFileName, SaveData, callback(arg_1_0, "cb_save_data"))
		elseif var_1_36 == "versus" and not SaveData.first_time_in_versus_inn then
			Level.trigger_event(var_1_21, "first_time_started_versus_game")

			SaveData.first_time_in_versus_inn = true

			Managers.save:auto_save(SaveFileName, SaveData, callback(arg_1_0, "cb_save_data"))
		elseif var_1_36 == "deus" and not SaveData.first_time_in_deus_inn then
			Level.trigger_event(var_1_21, "first_time_started_deus_game")

			SaveData.first_time_in_deus_inn = true

			Managers.save:auto_save(SaveFileName, SaveData, callback(arg_1_0, "cb_save_data"))
		end
	end

	local var_1_37 = PLATFORM

	if IS_WINDOWS then
		Window.set_mouse_focus(true)
	end

	Network.write_dump_tag("start of game")

	local var_1_38 = Managers.state.network
	local var_1_39 = var_1_38:game()

	if var_1_1.is_host and var_1_39 or LEVEL_EDITOR_TEST then
		Managers.state.conflict:ai_ready(var_1_23)
		Managers.state.entity:system("volume_system"):ai_ready()
	else
		Managers.state.conflict:client_ready()
	end

	if arg_1_0.is_server and var_1_24 then
		if Managers.state.game_mode:setting("specified_pickups") then
			Managers.state.entity:system("pickup_system"):populate_specified_pickups(var_1_24.pickup)
		else
			Managers.state.entity:system("pickup_system"):populate_pickups(var_1_24.pickup)
		end
	elseif arg_1_0.is_server then
		if Managers.state.game_mode:setting("specified_pickups") then
			Managers.state.entity:system("pickup_system"):populate_specified_pickups()
		else
			Managers.state.entity:system("pickup_system"):populate_pickups()
		end
	end

	if arg_1_0.is_server then
		Managers.state.entity:system("surrounding_aware_system"):populate_global_observers()
	end

	Managers.state.entity:system("payload_system"):init_payloads()

	local var_1_40 = Application.user_setting("dynamic_range_sound")

	if var_1_40 ~= nil then
		local var_1_41

		if var_1_40 == "low" then
			var_1_41 = 1
		elseif var_1_40 == "high" then
			var_1_41 = 0
		else
			local var_1_42 = DefaultUserSettings.get("user_settings", "dynamic_range_sound")

			if var_1_42 == "low" then
				var_1_41 = 1
			elseif var_1_42 == "high" then
				var_1_41 = 0
			end
		end

		WwiseWorld.set_global_parameter(var_1_34, "dynamic_range_sound", var_1_41)
	end

	if IS_WINDOWS then
		local var_1_43 = Application.user_setting("sound_quality")

		SoundQualitySettings.set_sound_quality(var_1_34, var_1_43)

		local var_1_44 = Application.user_setting("sfx_bus_volume")

		if var_1_44 ~= nil then
			local var_1_45 = Managers.world:wwise_world(var_1_8)

			WwiseWorld.set_global_parameter(var_1_45, "sfx_bus_volume", var_1_44)
		end

		local var_1_46 = Application.user_setting("voice_bus_volume")

		if var_1_46 ~= nil then
			local var_1_47 = Managers.world:wwise_world(var_1_8)

			WwiseWorld.set_global_parameter(var_1_47, "voice_bus_volume", var_1_46)
		end

		local var_1_48 = Application.user_setting("master_bus_volume")

		if var_1_48 ~= nil then
			local var_1_49 = Managers.world:wwise_world(var_1_8)

			WwiseWorld.set_global_parameter(var_1_49, "master_bus_volume", var_1_48)
		end
	end

	Managers.music:on_enter_level(var_1_9, var_1_2)
	Managers.chat:register_network_event_delegate(var_1_9)
	Managers.eac:register_network_event_delegate(var_1_9)

	if Managers.mod then
		Managers.mod:register_network_event_delegate(var_1_9)
	end

	Managers.state.game_mode:setup_done()

	if var_1_2 then
		Managers.state.game_mode:apply_environment_variation()
	end

	local var_1_50, var_1_51 = Managers.state.difficulty:get_difficulty()
	local var_1_52 = Managers.state.game_mode:activated_mutators()
	local var_1_53 = Managers.state.game_mode:settings().key
	local var_1_54 = Managers.venture.quickplay:is_quick_game()
	local var_1_55 = "official"

	if HAS_STEAM and script_data["eac-untrusted"] then
		var_1_55 = "modded"
	end

	Managers.telemetry_events:game_started({
		peer_type = arg_1_0:peer_type(),
		country_code = Managers.account:region(),
		quick_game = var_1_54,
		game_mode = var_1_53,
		level_key = var_1_22,
		difficulty = var_1_50,
		difficulty_tweak = var_1_51,
		mutators = var_1_52,
		realm = var_1_55
	})

	if arg_1_0.network_server then
		arg_1_0.network_server:on_game_entered(var_1_38)
	elseif arg_1_0.network_client then
		arg_1_0.network_client:on_game_entered()
	end

	arg_1_0._camera_carrier = CameraCarrier:new()

	local var_1_56 = Application.user_setting("fullscreen")
	local var_1_57 = Application.user_setting("borderless_fullscreen")
	local var_1_58 = not var_1_56 and not var_1_57
	local var_1_59 = var_1_56 and "fullscreen" or var_1_57 and "borderless_fullscreen" or var_1_58 and "windowed"
	local var_1_60, var_1_61 = Application.resolution()
	local var_1_62 = string.format("%dx%d", var_1_60, var_1_61)
	local var_1_63 = Application.user_setting("graphics_quality")
	local var_1_64 = Renderer.render_device_string()

	Managers.telemetry_events:tech_settings(var_1_62, var_1_63, var_1_59, var_1_64)

	local var_1_65 = Application.sysinfo()
	local var_1_66 = Application.user_setting("adapter_index")

	Managers.telemetry_events:tech_system(var_1_65, var_1_66)

	local var_1_67 = Application.user_setting("use_pc_menu_layout")

	Managers.telemetry_events:ui_settings(var_1_67)

	if IS_XB1 then
		Managers.account:set_presence("playing")
	elseif IS_PS4 then
		if arg_1_0.is_in_inn then
			Managers.account:set_presence("inn")
		else
			local var_1_68 = LevelSettings[arg_1_0.level_key].display_name

			Managers.account:set_presence("playing", var_1_68)
		end
	elseif IS_WINDOWS then
		Managers.account:update_presence()
	end

	if Managers.deed:has_deed() then
		local var_1_69 = Managers.deed:is_deed_owner(arg_1_0.peer_id)

		printf("Entered StateIngame with a deed active! is_owner(%s)", tostring(var_1_69))
	end

	arg_1_0._fps_reporter = FPSReporter:new()
	arg_1_0._ping_reporter = PingReporter:new()

	Managers.state.entity:system("objective_system"):on_game_entered()
	Managers.state.event:trigger("start_game_time", Managers.state.network:network_time())
	Managers:on_round_start(var_1_9, var_1_18, arg_1_0.network_transmit)
	Managers.mechanism:handle_ingame_enter(var_1_53)
end

function StateIngame.peer_type(arg_2_0)
	if DEDICATED_SERVER then
		return "dedicated-server"
	elseif arg_2_0.is_server then
		return "server"
	else
		return "client"
	end
end

function StateIngame.event_xbox_one_hack_start_game(arg_3_0, arg_3_1, arg_3_2)
	print(arg_3_1, arg_3_2)
	Managers.level_transition_handler:set_next_level(arg_3_1, nil, nil, nil, nil, nil, arg_3_2)
	Managers.state.game_mode:complete_level()
end

function StateIngame.cb_save_data(arg_4_0)
	print("saved data")
end

function StateIngame._setup_world(arg_5_0)
	local function var_5_0()
		Managers.ui:update()
	end

	Managers.world:set_anim_update_callback(arg_5_0.world, var_5_0)
	Managers.world:set_scene_update_callback(arg_5_0.world, function()
		arg_5_0:physics_async_update(arg_5_0.dt)
	end)
	Managers.world:set_update_done_callback(arg_5_0.world, function(arg_8_0, arg_8_1, arg_8_2)
		Managers.state.entity:system("transportation_system"):world_updated(arg_8_0, arg_8_1, arg_8_2)
	end)

	if Managers.splitscreen then
		Managers.splitscreen:add_splitscreen_viewport(arg_5_0.world)
	end
end

function StateIngame._safe_to_do_entity_update(arg_9_0)
	local var_9_0 = Managers.state.network

	if var_9_0:has_left_game() or not var_9_0:in_game_session() then
		return false
	end

	local var_9_1 = Managers.time:time("game")

	return not (Managers.state.game_mode:is_game_mode_ended() and arg_9_0.game_mode_end_timer and var_9_1 >= arg_9_0.game_mode_end_timer)
end

function StateIngame.physics_async_update(arg_10_0, arg_10_1)
	local var_10_0 = Managers.time:time("game")

	Managers.music:update(arg_10_0.dt, var_10_0)

	if arg_10_0:_safe_to_do_entity_update() then
		arg_10_0.entity_system:physics_async_update()
	end
end

function StateIngame.shading_callback(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	Managers.state.camera:shading_callback(arg_11_1, arg_11_2, arg_11_3)
end

function StateIngame._teardown_level(arg_12_0)
	ScriptWorld.destroy_level_from_reference(arg_12_0.world, arg_12_0.level)
end

function StateIngame._teardown_world(arg_13_0)
	if Managers.splitscreen then
		Managers.splitscreen:remove_splitscreen_viewport()
	end

	if Debug.active then
		Debug.teardown()
	end

	World.destroy_gui(arg_13_0.world, arg_13_0._debug_gui)
	World.destroy_gui(arg_13_0.world, arg_13_0._debug_gui_immediate)
	Managers.world:destroy_world(arg_13_0.world_name)
end

function StateIngame.spawn_unit(arg_14_0, arg_14_1, ...)
	if not Managers.state.entity then
		printf("Unit %s is spawned after level destroy?", tostring(arg_14_1))

		return
	end

	Managers.state.entity:register_unit(arg_14_0.world, arg_14_1, ...)
end

function StateIngame.unspawn_unit(arg_15_0, arg_15_1)
	if not Managers.state.entity then
		printf("Unit %s has not been destroyed by entity manager or level destroy", tostring(arg_15_1))

		return
	end

	Unit.flow_event(arg_15_1, "unit_despawned")
	Managers.state.entity:unregister_unit(arg_15_1)
end

function StateIngame._create_level(arg_16_0)
	local var_16_0 = arg_16_0.level

	Level.finish_spawn_time_sliced(var_16_0)
	ScriptWorld.activate(arg_16_0.world)

	local var_16_1 = Managers.level_transition_handler
	local var_16_2 = var_16_1:get_current_level_key()
	local var_16_3 = LevelSettings[var_16_2].level_name
	local var_16_4 = var_16_1:get_current_game_mode()
	local var_16_5, var_16_6 = GameModeHelper.get_object_sets(var_16_3, var_16_4)
	local var_16_7 = var_16_1:get_current_level_seed()

	print("[StateIngame] Level seed:", var_16_7)
	World.set_data(arg_16_0.world, "level_seed", var_16_7)
	World.set_data(arg_16_0.world, "debug_level_seed", {})
	World.set_data(arg_16_0.world, "shading_callback", callback(arg_16_0, "shading_callback"))

	local var_16_8 = Managers.state.game_mode

	Managers.state.networked_flow_state:set_level(var_16_0)
	World.set_flow_callback_object(arg_16_0.world, arg_16_0)
	Managers.state.entity:add_and_register_units(arg_16_0.world, World.units(arg_16_0.world))
	var_16_8:register_object_sets(var_16_5)
	Level.spawn_background(var_16_0)

	return var_16_2
end

function StateIngame._gather_backend_flow_events(arg_17_0)
	local var_17_0 = {}
	local var_17_1 = "keep_event_default"
	local var_17_2 = Managers.backend:get_level_variation_data().level_settings
	local var_17_3 = var_17_2 and var_17_2[arg_17_0.level_key]

	if var_17_3 then
		local var_17_4 = var_17_3.environment_flow_event

		if var_17_4 then
			var_17_1 = var_17_4
		end

		local var_17_5 = var_17_3.level_flow_events

		if var_17_5 then
			for iter_17_0 = 1, #var_17_5 do
				local var_17_6 = var_17_5[iter_17_0]

				var_17_0[#var_17_0 + 1] = var_17_6
			end
		end
	end

	if var_17_1 then
		var_17_0[#var_17_0 + 1] = var_17_1
	end

	arg_17_0._level_flow_events = var_17_0
end

function StateIngame.pre_update(arg_18_0, arg_18_1)
	local var_18_0 = Managers.time:time("game")
	local var_18_1 = Managers.state.network

	UPDATE_POSITION_LOOKUP()
	Managers.state.side:update_frame_tables()
	var_18_1:update_receive(arg_18_1)
	arg_18_0.entity_system:commit_and_remove_pending_units()

	if arg_18_0.network_server then
		arg_18_0.network_server:update(arg_18_1, var_18_0)
	end

	if arg_18_0.network_client then
		arg_18_0.network_client:update(arg_18_1, var_18_0)
	end

	Managers.state.spawn:pre_update(arg_18_1, var_18_0)
	Managers.state.game_mode:pre_update(var_18_0, arg_18_1)
	Managers.state.conflict:pre_update()
	arg_18_0.entity_system:commit_and_remove_pending_units()

	if arg_18_0:_safe_to_do_entity_update() then
		arg_18_0.entity_system:pre_update(arg_18_1, var_18_0)
	end
end

local var_0_1 = 1
local var_0_2 = 0
local var_0_3 = 0
local var_0_4 = {
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

local function var_0_5(arg_19_0, arg_19_1)
	if arg_19_1 > var_0_2 then
		var_0_2 = arg_19_1 + 0.5

		local var_19_0 = Managers.player:local_player().player_unit

		if not ALIVE[var_19_0] then
			return
		end

		local var_19_1 = ScriptUnit.extension(var_19_0, "inventory_system"):equipment().right_hand_wielded_unit

		if ALIVE[var_19_1] then
			var_0_1 = var_0_1 + 1

			if not var_0_4[var_0_1] then
				var_0_1 = 1
				var_0_3 = (1 + var_0_3) % 2

				local var_19_2 = bit.lshift(var_0_3, 4)

				Application.set_render_setting("global_shader_variable", var_19_2)
			end

			local var_19_3 = var_0_4[var_0_1]

			Unit.flow_event(var_19_1, var_19_3)
		end
	end

	local var_19_4 = var_0_4[var_0_1]

	Debug.text(string.format("Event Name: %s - Remap Index: %s - Remap variable: %s", var_19_4, var_0_3, Application.render_config("settings", "global_shader_variable")))
end

function StateIngame.update(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.dt = arg_20_1

	if not arg_20_0.network_client or arg_20_0.network_client.state == NetworkClientStates.game_started then
		arg_20_0.network_clock:update(arg_20_1)
		arg_20_0.network_timer_handler:update(arg_20_1, arg_20_2)
	end

	local var_20_0 = arg_20_0.is_server
	local var_20_1 = Managers

	var_20_1.state.network:update(arg_20_1)
	var_20_1.backend:update(arg_20_1, arg_20_2)
	arg_20_0.input_manager:update(arg_20_1, arg_20_2)
	var_20_1.level_transition_handler:update()

	local var_20_2 = var_20_1.time:time("game")
	local var_20_3 = var_20_1.lobby:get_lobby("matchmaking_session_lobby")

	var_20_3:update(arg_20_1)
	var_20_1.state.voting:update(arg_20_1, var_20_2)

	if var_20_1.matchmaking then
		var_20_1.matchmaking:update(arg_20_1, arg_20_2)
	end

	if var_20_1.game_server then
		var_20_1.game_server:update(arg_20_1, var_20_2)
	end

	arg_20_0:_update_deed_manager(arg_20_1)
	var_20_1.venture.challenge:update(arg_20_1, arg_20_2)
	var_20_1.boon:update(arg_20_1, arg_20_2)
	var_20_1.party:update(var_20_2, arg_20_1)

	if var_20_1.state.quest then
		var_20_1.state.quest:update(arg_20_1, var_20_2)
	end

	var_20_1.state.achievement:update(arg_20_1, var_20_2)

	if var_20_1.state.decal ~= nil then
		var_20_1.state.decal:update(arg_20_1, var_20_2)
	end

	if var_20_1.eac ~= nil then
		var_20_1.eac:update(arg_20_1, var_20_2)
	end

	if not DEDICATED_SERVER then
		var_20_1.state.blood:update(arg_20_1, var_20_2)
		var_20_1.state.status_effect:update(arg_20_1, var_20_2)
	end

	var_20_1.state.world_interaction:update(arg_20_1, var_20_2)

	if var_20_1.state.controller_features then
		var_20_1.state.controller_features:update(arg_20_1, var_20_2)
	end

	if var_20_0 then
		var_20_1.state.conflict:reset_data()

		if var_20_3:is_joined() and var_20_1.state.network:game() then
			var_20_1.state.conflict:update(arg_20_1, var_20_2)
		end
	elseif var_20_1.state.network:game() then
		var_20_1.state.conflict:update_client(arg_20_1, var_20_2)
	end

	for iter_20_0, iter_20_1 in pairs(arg_20_0.machines) do
		iter_20_1:update(arg_20_1, var_20_2)
	end

	local var_20_4 = var_20_1.state.game_mode:is_game_mode_ended()

	if not var_20_4 and arg_20_0.game_mode_end_timer then
		arg_20_0.game_mode_end_timer = nil
	end

	if var_20_4 and not arg_20_0.game_mode_end_timer then
		arg_20_0.game_mode_end_timer = var_20_2 + 0.2
	end

	if arg_20_0:_safe_to_do_entity_update() then
		arg_20_0.entity_system:update(arg_20_1, var_20_2)
	else
		arg_20_0.entity_system:unsafe_entity_update(arg_20_1, var_20_2)
	end

	var_20_1.state.game_mode:update(arg_20_1, var_20_2)

	if var_20_0 then
		var_20_1.state.game_mode:server_update(arg_20_1, var_20_2)
	end

	if not arg_20_0._new_state then
		arg_20_0._new_state = arg_20_0:_check_exit(var_20_2)
	end

	if arg_20_0.exit_type then
		for iter_20_2, iter_20_3 in pairs(arg_20_0.machines) do
			iter_20_3._state:disable_ui()
		end
	end

	if arg_20_0._new_state then
		if arg_20_0.parent.loading_context.restart_network then
			arg_20_0.leave_lobby = true
		end

		if not var_20_1.popup:has_popup() then
			return arg_20_0._new_state
		end
	end

	var_20_1.state.bot_nav_transition:update(arg_20_1, var_20_2)
	var_20_1.state.flow_helper:update(var_20_2)
	var_20_1.state.performance:update(arg_20_1, var_20_2)
	arg_20_0._fps_reporter:update(arg_20_1, var_20_2)
	arg_20_0._ping_reporter:update(arg_20_1, var_20_2)
	arg_20_0:_update_onclose_check(arg_20_1, var_20_2)
	arg_20_0:_generate_ingame_clock()
	arg_20_0._camera_carrier:update(arg_20_1)

	if arg_20_0._level_flow_events and #arg_20_0._level_flow_events > 0 and not arg_20_0._called_level_flow_events then
		local var_20_5 = arg_20_0._level_flow_events

		for iter_20_4 = 1, #var_20_5 do
			local var_20_6 = var_20_5[iter_20_4]

			LevelHelper:flow_event(arg_20_0.world, var_20_6)
		end

		arg_20_0._called_level_flow_events = true
	end

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_20_0)
	end
end

function StateIngame._update_onclose_check(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0._onclose_called and not arg_21_0._onclose_popup_id then
		local var_21_0 = Localize("exit_game_popup_text") .. "\n\n" .. Localize("exit_game_popup_text_is_hosting_players")

		arg_21_0._onclose_popup_id = Managers.popup:queue_popup(var_21_0, Localize("popup_exit_game_topic"), "end_game", Localize("popup_choice_yes"), "cancel_popup", Localize("popup_choice_no"))
	end

	arg_21_0:_handle_onclose_warning_result()
end

function StateIngame._update_deed_manager(arg_22_0, arg_22_1)
	local var_22_0 = Managers.deed

	var_22_0:update(arg_22_1)

	if arg_22_0.is_server and var_22_0:has_deed() and var_22_0:is_session_faulty() then
		if arg_22_0.is_in_inn then
			var_22_0:reset()
		else
			Managers.state.game_mode:complete_level()
		end
	end
end

function StateIngame.cb_transition_fade_in_done(arg_23_0, arg_23_1)
	arg_23_0._new_state = arg_23_1
end

function StateIngame.event_start_network_timer(arg_24_0, arg_24_1)
	arg_24_0.network_timer_handler:start_timer_server(arg_24_1)
end

function StateIngame._check_exit(arg_25_0, arg_25_1)
	local var_25_0 = Managers.state.network
	local var_25_1 = Managers.lobby:query_lobby("matchmaking_session_lobby")
	local var_25_2 = PLATFORM
	local var_25_3 = arg_25_0.game_mode_key
	local var_25_4, var_25_5 = Managers.state.difficulty:get_difficulty()
	local var_25_6 = NetworkLookup.difficulties[var_25_4]
	local var_25_7 = Managers.backend
	local var_25_8 = var_25_7:is_waiting_for_user_input()
	local var_25_9 = (var_25_7:get_interface("items"):num_current_item_server_requests() ~= 0 or UISettings.waiting_for_response) and not var_25_7:is_disconnected()

	if not arg_25_0.exit_type and not var_25_8 and not var_25_9 then
		local var_25_10
		local var_25_11

		for iter_25_0, iter_25_1 in pairs(arg_25_0.machines) do
			iter_25_1:state():check_invites()

			var_25_10, var_25_11 = iter_25_1:state():wanted_transition()
		end

		if script_data.hammer_join and Managers.time:time("game") > 5 then
			var_25_10 = "restart_game"

			Development.set_parameter("auto_join", true)
		elseif not IS_WINDOWS and Managers.account:leaving_game() then
			var_25_10 = "return_to_title_screen"
		end

		var_25_10 = var_25_10 or Managers.state.game_mode:wanted_transition()

		if not var_25_10 and Managers.game_server then
			var_25_10 = Managers.game_server:get_transition()
		end

		if not var_25_10 and script_data.honduras_demo then
			var_25_10 = Managers.time:get_demo_transition()
		end

		local var_25_12 = Managers.level_transition_handler
		local var_25_13 = var_25_12:needs_level_load() and var_25_12:get_current_level_transition_type()

		if var_25_10 or var_25_11 or var_25_13 then
			print("TRANSITION", var_25_10, var_25_11, var_25_13)
		end

		if var_25_7:is_disconnected() then
			arg_25_0.exit_type = "backend_disconnected"

			if var_25_0:in_game_session() then
				local var_25_14 = true

				var_25_0:leave_game(var_25_14)
			end

			arg_25_0.leave_lobby = true

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "offline_invite" then
			arg_25_0.exit_type = "offline_invite"

			if not Managers.account:leaving_game() then
				Managers.account:initiate_leave_game()
			end

			if var_25_0:in_game_session() then
				local var_25_15 = true

				var_25_0:leave_game(var_25_15)
			end

			arg_25_0.leave_lobby = true

			Managers.account:set_should_teardown_xboxlive()
			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "return_to_title_screen" then
			arg_25_0.exit_type = "return_to_title_screen"

			if not Managers.account:leaving_game() then
				Managers.account:initiate_leave_game()
			end

			if var_25_0:in_game_session() then
				local var_25_16 = true

				var_25_0:leave_game(var_25_16)
			end

			arg_25_0.leave_lobby = true

			Managers.account:set_should_teardown_xboxlive()
			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "return_to_demo_title_screen" then
			arg_25_0.exit_type = "return_to_demo_title_screen"

			if var_25_0:in_game_session() then
				local var_25_17 = true

				var_25_0:leave_game(var_25_17)
			end

			arg_25_0.leave_lobby = true

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif arg_25_0.is_in_inn and var_25_1 and var_25_1:lost_connection_to_lobby() and not var_25_1:attempting_reconnect() then
			print("Lost connection to lobby, restarting to inn.")

			arg_25_0.exit_type = "lobby_state_failed"

			if var_25_0:in_game_session() then
				var_25_0:leave_game()
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif arg_25_0.network_client and arg_25_0.network_client.state == NetworkClientStates.denied_enter_game then
			if arg_25_0.network_client.host_to_migrate_to == nil then
				arg_25_0.exit_type = "join_lobby_failed"
			else
				arg_25_0.exit_type = "perform_host_migration"
			end

			if var_25_0:in_game_session() then
				local var_25_18 = true

				var_25_0:leave_game(var_25_18)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif arg_25_0.network_client and arg_25_0.network_client.state == NetworkClientStates.eac_match_failed then
			arg_25_0.exit_type = "join_lobby_failed"

			if var_25_0:in_game_session() then
				local var_25_19 = true

				var_25_0:leave_game(var_25_19)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif arg_25_0.network_client and arg_25_0.network_client.state == NetworkClientStates.lost_connection_to_host and var_25_1 and var_25_1:lost_connection_to_lobby() then
			if arg_25_0.network_client == nil or arg_25_0.network_client.host_to_migrate_to == nil then
				arg_25_0.exit_type = "rejoin_party"

				print("Game ended while reconnecting to lobby, restarting to inn.")
			else
				arg_25_0.exit_type = "perform_host_migration"

				if var_25_0:in_game_session() then
					local var_25_20 = true

					var_25_0:leave_game(var_25_20)
				end

				Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
				Managers.transition:show_loading_icon()
			end
		elseif var_25_1 and var_25_1.state == LobbyState.FAILED or arg_25_0.network_client and arg_25_0.network_client.state == NetworkClientStates.lost_connection_to_host then
			if arg_25_0.network_client == nil or arg_25_0.network_client.host_to_migrate_to == nil then
				arg_25_0.exit_type = "lobby_state_failed"
			else
				arg_25_0.exit_type = "perform_host_migration"
			end

			if var_25_0:in_game_session() then
				local var_25_21 = true

				var_25_0:leave_game(var_25_21)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif arg_25_0.kicked_by_server then
			arg_25_0.kicked_by_server = nil
			arg_25_0.exit_type = "kicked_by_server"

			if not var_25_1.is_host and var_25_1.state == LobbyState.JOINED then
				Managers.matchmaking:add_broken_lobby_client(var_25_1, arg_25_1, true)
			end

			if var_25_0:in_game_session() then
				local var_25_22 = true

				var_25_0:leave_game(var_25_22)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "finish_tutorial" then
			arg_25_0.exit_type = "finished_tutorial"

			arg_25_0.network_server:disconnect_all_peers("host_left_game")

			if var_25_0:in_game_session() then
				local var_25_23 = true

				var_25_0:leave_game(var_25_23)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "demo_completed" then
			arg_25_0.exit_type = "demo_completed"

			if var_25_0:in_game_session() then
				local var_25_24 = true

				var_25_0:leave_game(var_25_24)
			end

			Managers.transition:force_fade_in()
			Managers.transition:show_video(true)
			Managers.transition:show_loading_icon()
		elseif var_25_13 == "reload_level" then
			arg_25_0.exit_type = "reload_level"

			if arg_25_0.is_server then
				var_25_0:leave_game()
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_13 == "load_next_level" then
			arg_25_0.exit_type = "load_next_level"

			printf("Transition type %q, is server: %s", tostring(var_25_13), tostring(arg_25_0.is_server))

			if arg_25_0.is_server then
				var_25_0:leave_game()

				if var_25_12:get_current_level_key() == "prologue" then
					arg_25_0.parent.loading_context.play_trailer = true

					local var_25_25, var_25_26 = Managers.mechanism:should_run_tutorial()

					arg_25_0.parent.loading_context.switch_to_tutorial_backend = var_25_25
					arg_25_0.parent.loading_context.wanted_tutorial_state = var_25_26
				end
			else
				arg_25_0.network_client:set_wait_for_state_loading(true)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "leave_game" or var_25_10 == "quit_game" or arg_25_0._quit_game then
			if Managers.mechanism:current_mechanism_name() == "versus" then
				Managers.matchmaking:on_leave_game()
			end

			if var_25_10 == "leave_game" then
				arg_25_0.exit_type = "left_game"
			else
				arg_25_0.exit_type = "quit_game"
			end

			if arg_25_0.network_server then
				arg_25_0.network_server:disconnect_all_peers("host_left_game")
			elseif not var_25_1.is_host and var_25_1.state == LobbyState.JOINED then
				print("Leaving lobby, noting it as one I don't want to matchmake back into soon")
				Managers.matchmaking:add_broken_lobby_client(var_25_1, arg_25_1, true)
			end

			if var_25_0:in_game_session() then
				local var_25_27 = not arg_25_0.is_server

				var_25_0:leave_game(var_25_27)
			end

			if Development.parameter("attract_mode") then
				Managers.transition:force_fade_in()
			else
				Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			end

			Managers.transition:show_loading_icon()
		elseif var_25_10 == "return_to_pc_menu" then
			if GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen") then
				arg_25_0.exit_type = "return_to_pc_menu"

				if arg_25_0.network_server then
					arg_25_0.network_server:disconnect_all_peers("host_left_game")
				elseif not var_25_1.is_host and var_25_1.state == LobbyState.JOINED then
					print("Leaving lobby, noting it as one I don't want to matchmake back into soon")
					Managers.matchmaking:add_broken_lobby_client(var_25_1, arg_25_1, true)
				end

				if var_25_0:in_game_session() then
					local var_25_28 = not arg_25_0.is_server

					var_25_0:leave_game(var_25_28)
				end

				Managers.matchmaking:cancel_matchmaking()
				Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
				Managers.transition:show_loading_icon()
			else
				arg_25_0.exit_type = "return_to_title_screen"

				if not Managers.account:leaving_game() then
					Managers.account:initiate_leave_game()
				end

				if var_25_0:in_game_session() then
					local var_25_29 = true

					var_25_0:leave_game(var_25_29)
				end

				arg_25_0.leave_lobby = true

				Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
				Managers.transition:show_loading_icon()
			end
		elseif var_25_10 == "afk_kick" then
			arg_25_0.exit_type = "afk_kick"

			if var_25_0:in_game_session() then
				local var_25_30 = true

				var_25_0:leave_game(var_25_30)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "join_lobby" then
			arg_25_0.exit_type = "join_game"

			if var_25_0:in_game_session() then
				var_25_0:leave_game()
			end

			arg_25_0.parent.loading_context.join_lobby_data = var_25_11
			arg_25_0.parent.loading_context.setup_voip = IS_PS4

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "start_lobby" then
			arg_25_0.exit_type = "join_game"

			if var_25_0:in_game_session() then
				var_25_0:leave_game()
			end

			arg_25_0.parent.loading_context.start_lobby_data = var_25_11

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "join_server" then
			arg_25_0.exit_type = "join_game"

			if var_25_0:in_game_session() then
				var_25_0:leave_game()
			end

			arg_25_0.parent.loading_context.join_server_data = var_25_11

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "restart_game" then
			arg_25_0.exit_type = "restart_game"

			if var_25_0:in_game_session() then
				var_25_0:leave_game()
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "restart_demo" then
			arg_25_0.exit_type = "load_next_level"

			printf("Transition type %q, is server: %s", tostring(var_25_13), tostring(arg_25_0.is_server))

			if arg_25_0.is_server then
				local var_25_31 = DemoSettings.demo_level
				local var_25_32 = Managers.mechanism:generate_locked_director_functions(var_25_31)
				local var_25_33 = Managers.mechanism:generate_level_seed()

				var_25_12:set_next_level(var_25_31, nil, var_25_33, nil, nil, nil, var_25_32, var_25_4, var_25_5)
				var_25_12:promote_next_level_data()
				var_25_0:leave_game()
			else
				arg_25_0.network_client:set_wait_for_state_loading(true)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "rejoin_party" then
			arg_25_0.exit_type = "rejoin_party"

			if var_25_0:in_game_session() then
				local var_25_34 = true

				var_25_0:leave_game(var_25_34)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "versus_migration" then
			arg_25_0.exit_type = "versus_migration"

			if var_25_0:in_game_session() then
				local var_25_35 = true

				var_25_0:leave_game(var_25_35)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "restart_game_server" then
			arg_25_0.exit_type = "restart_game_server"

			if var_25_0:in_game_session() then
				local var_25_36 = true

				var_25_0:leave_game(var_25_36)
			end

			Managers.transition:fade_in(GameSettings.transition_fade_in_speed, nil)
			Managers.transition:show_loading_icon()
		elseif var_25_10 == "complete_level" then
			-- block empty
		end

		if arg_25_0.exit_type then
			arg_25_0.exit_time = arg_25_1 + 2

			printf("StateIngame: Got transition %s, set exit type to %s. Will exit at t=%.2f", tostring(var_25_10), arg_25_0.exit_type, arg_25_0.exit_time)

			local var_25_37 = arg_25_0.input_manager

			var_25_37:block_device_except_service(nil, "keyboard", 1)
			var_25_37:block_device_except_service(nil, "mouse", 1)
			var_25_37:block_device_except_service(nil, "gamepad", 1)
			Managers.popup:cancel_all_popups()

			if IS_XB1 then
				arg_25_0.machines[1]:state():trigger_xbox_multiplayer_round_end_events()
			end

			if IS_PS4 then
				Managers.account:set_realtime_multiplay(false)
			end

			if arg_25_0.is_in_tutorial then
				local var_25_38 = Managers.state.entity:system("play_go_tutorial_system")

				if var_25_38 then
					var_25_38:clear_hooks()
				end
			end
		end
	end

	local var_25_39 = 4

	if script_data.honduras_demo then
		local var_25_40 = Managers.transition

		if var_25_40:is_video_active() and not var_25_40:is_video_done() then
			return
		end
	end

	if arg_25_0.exit_time and arg_25_1 >= arg_25_0.exit_time then
		Managers.popup:cancel_all_popups()
		Managers.account:check_popup_retrigger()

		local var_25_41 = arg_25_0.exit_type
		local var_25_42 = var_25_0:has_left_game() or not var_25_0:in_game_session()

		if not var_25_42 and arg_25_1 >= arg_25_0.exit_time + var_25_39 then
			print("Session leave timeout reached, force disconnecting")
			var_25_0:force_disconnect_from_session()

			return
		elseif not var_25_42 then
			return
		end

		if arg_25_0.is_server and not arg_25_0.is_in_inn and var_25_41 ~= "reload_level" and Managers.matchmaking and Managers.matchmaking:have_game_mode_event_data() and Managers.mechanism:game_mechanism():is_venture_over() then
			Managers.matchmaking:clear_game_mode_event_data()
		end

		if Managers.backend:is_tutorial_backend() then
			Managers.backend:stop_tutorial()
		end

		if Managers.deed:has_deed() and not arg_25_0.is_in_inn and arg_25_0.is_server then
			Managers.deed:reset()
		end

		Managers.mechanism:handle_ingame_exit(var_25_41)

		if var_25_41 == "quit_game" then
			if var_25_0:in_game_session() then
				local var_25_43 = true

				var_25_0:leave_game(var_25_43)
			end

			if IS_XB1 and Managers.voice_chat then
				Managers.voice_chat:_remove_all_users()
			end

			Boot.quit_game = true
		elseif var_25_41 == "join_lobby_failed" or var_25_41 == "left_game" or var_25_41 == "lobby_state_failed" or var_25_41 == "kicked_by_server" or var_25_41 == "afk_kick" then
			printf("[StateIngame] Transition to StateLoadingRestartNetwork on %q", arg_25_0.exit_type)

			if IS_XB1 and Managers.voice_chat then
				Managers.voice_chat:_remove_all_users()
			end

			if var_25_41 == "lobby_state_failed" then
				if arg_25_0.is_server then
					arg_25_0.parent.loading_context.previous_session_error = "broken_connection"
				else
					local var_25_44 = Managers.mechanism:current_mechanism_name()
					local var_25_45 = var_25_1:get_stored_lobby_data()
					local var_25_46 = var_25_45.matchmaking_type and tonumber(var_25_45.matchmaking_type)

					if var_25_44 == "versus" and var_25_46 and NetworkLookup.matchmaking_types[var_25_46] == "versus" then
						arg_25_0.parent.loading_context.previous_session_error = "server_disconnected"
					else
						arg_25_0.parent.loading_context.previous_session_error = "lobby_disconnected"
					end
				end
			elseif var_25_41 == "kicked_by_server" then
				arg_25_0.parent.loading_context.previous_session_error = "kicked_by_server"
			elseif var_25_41 == "join_lobby_failed" and arg_25_0.network_client then
				arg_25_0.parent.loading_context.previous_session_error = arg_25_0.network_client.fail_reason
			elseif var_25_41 == "afk_kick" then
				arg_25_0.parent.loading_context.previous_session_error = "afk_kick"
			elseif (var_25_41 == "return_to_pc_menu" or var_25_41 == "left_game") and var_25_0:in_game_session() then
				local var_25_47 = true

				var_25_0:leave_game(var_25_47)
			end

			arg_25_0.parent.loading_context.restart_network = true
			arg_25_0.parent.loading_context.level_end_view_context = nil
			arg_25_0.parent.loading_context.time_spent_in_level = math.floor(Managers.time and Managers.time:time("game") or -1)
			arg_25_0.parent.loading_context.end_reason = var_25_41

			return StateLoading
		elseif var_25_41 == "return_to_pc_menu" then
			printf("[StateIngame] Transition to StateLoadingRestartNetwork on %q", arg_25_0.exit_type)

			arg_25_0.parent.loading_context.restart_network = true
			arg_25_0.parent.loading_context.show_profile_on_startup = true
			arg_25_0.parent.loading_context.return_to_pc_menu = true
			arg_25_0.parent.loading_context.time_spent_in_level = math.floor(Managers.time and Managers.time:time("game") or -1)
			arg_25_0.parent.loading_context.end_reason = "return_to_pc_menu"

			return StateLoading
		elseif var_25_41 == "demo_completed" then
			arg_25_0.parent.loading_context.restart_network = true

			return StateDemoEnd
		elseif var_25_41 == "finished_tutorial" then
			local var_25_48 = arg_25_0.parent.loading_context

			var_25_48.finished_tutorial = true
			var_25_48.time_spent_in_level = math.floor(Managers.time and Managers.time:time("game") or -1)
			var_25_48.end_reason = "finished_tutorial"

			if Managers.play_go:installed() then
				var_25_48.restart_network = true
				var_25_48.play_trailer = Application.user_setting("play_intro_cinematic")

				printf("[StateIngame] Transition to StateLoadingRestartNetwork on %q", var_25_41)
			else
				arg_25_0.leave_lobby = true
				var_25_48.restart_network = nil

				Managers.account:set_should_teardown_xboxlive()

				local var_25_49, var_25_50 = Managers.mechanism:should_run_tutorial()

				var_25_48.switch_to_tutorial_backend = var_25_49
				var_25_48.wanted_tutorial_state = var_25_50

				printf("[StateIngame] Transition to StateLoadingRunning on %q", var_25_41)
			end

			return StateLoading
		elseif var_25_41 == "perform_host_migration" then
			local var_25_51 = Managers.mechanism:create_host_migration_info(arg_25_0._gm_event_end_conditions_met, arg_25_0._gm_event_end_reason)

			arg_25_0.parent.loading_context.host_migration_info = var_25_51
			arg_25_0.parent.loading_context.wanted_profile_index = arg_25_0:wanted_profile_index()
			arg_25_0.parent.loading_context.wanted_party_index = arg_25_0:wanted_party_index()
			arg_25_0.parent.loading_context.time_spent_in_level = math.floor(Managers.time and Managers.time:time("game") or -1)
			arg_25_0.parent.loading_context.end_reason = "host_migration"
			arg_25_0.leave_lobby = true

			return StateLoading
		elseif var_25_41 == "versus_migration" then
			local var_25_52 = Managers.mechanism:game_mechanism():create_versus_migration_info(arg_25_0._gm_event_end_conditions_met, arg_25_0._gm_event_end_reason)

			arg_25_0.parent.loading_context.versus_migration_info = var_25_52
			arg_25_0.parent.loading_context.versus_migration = true
			arg_25_0.parent.loading_context.time_spent_in_level = math.floor(Managers.time and Managers.time:time("game") or -1)
			arg_25_0.parent.loading_context.end_reason = "versus_migration"
			arg_25_0.leave_lobby = true

			return StateLoading
		elseif var_25_41 == "rejoin_party" then
			local var_25_53 = arg_25_0.parent.loading_context

			var_25_53.restart_network = true
			var_25_53.rejoin_lobby = true
			arg_25_0.parent.loading_context.time_spent_in_level = math.floor(Managers.time and Managers.time:time("game") or -1)
			arg_25_0.parent.loading_context.end_reason = "rejoin_party"
			arg_25_0.leave_lobby = true

			return StateLoading
		elseif var_25_41 == "restart_game_server" then
			arg_25_0.leave_lobby = true

			return StateDedicatedServer
		elseif var_25_41 == "backend_disconnected" then
			printf("[StateIngame] Transition to StateTitleScreen on %q", arg_25_0.exit_type)

			arg_25_0.release_level_resources = true
			arg_25_0.parent.loading_context = {}

			return StateTitleScreen
		elseif var_25_41 == "offline_invite" then
			printf("[StateIngame] Transition to StateTitleScreen on %q", arg_25_0.exit_type)

			arg_25_0.release_level_resources = true
			arg_25_0.parent.loading_context = {}
			arg_25_0.parent.loading_context.offline_invite = true

			return StateTitleScreen
		elseif var_25_41 == "return_to_title_screen" then
			printf("[StateIngame] Transition to StateTitleScreen on %q", arg_25_0.exit_type)

			arg_25_0.release_level_resources = true
			arg_25_0.parent.loading_context = {}

			return StateTitleScreen
		elseif var_25_41 == "return_to_demo_title_screen" then
			printf("[StateIngame] Transition to Demo StateTitleScreen on %q", arg_25_0.exit_type)

			arg_25_0.parent.loading_context = {}

			return StateTitleScreen
		elseif var_25_41 == "load_next_level" or var_25_41 == "reload_level" then
			arg_25_0.parent.loading_context.checkpoint_data = arg_25_0.is_server and Managers.level_transition_handler:get_checkpoint_data() or nil
			arg_25_0.parent.loading_context.matchmaking_loading_context = Managers.matchmaking:loading_context()
			arg_25_0.parent.loading_context.wanted_profile_index = arg_25_0:wanted_profile_index()
			arg_25_0.parent.loading_context.wanted_party_index = arg_25_0:wanted_party_index()
			arg_25_0.parent.loading_context.quickplay_bonus = Managers.venture.quickplay:has_pending_quick_game() or nil
			arg_25_0.parent.loading_context.previous_session_error = Managers.twitch and Managers.twitch:get_twitch_popup_message()
			arg_25_0.parent.loading_context.time_spent_in_level = math.floor(Managers.time and Managers.time:time("game") or -1)
			arg_25_0.parent.loading_context.end_reason = Managers.state.game_mode:get_end_reason()

			return StateLoading
		elseif var_25_41 == "join_game" then
			arg_25_0.leave_lobby = true
			arg_25_0.parent.loading_context.matchmaking_loading_context = Managers.matchmaking:loading_context()
			arg_25_0.parent.loading_context.wanted_profile_index = arg_25_0:wanted_profile_index()
			arg_25_0.parent.loading_context.wanted_party_index = arg_25_0:wanted_party_index()
			arg_25_0.parent.loading_context.quickplay_bonus = arg_25_0.is_server and Managers.venture.quickplay:has_pending_quick_game() or nil
			arg_25_0.parent.loading_context.time_spent_in_level = math.floor(Managers.time and Managers.time:time("game") or -1)
			arg_25_0.parent.loading_context.end_reason = "join_game"

			return StateLoading
		elseif var_25_41 == "restart_game" then
			printf("[StateIngame] Transition to StateSplashScreen on %q", arg_25_0.exit_type)

			arg_25_0.leave_lobby = true
			arg_25_0.release_level_resources = true
			arg_25_0.parent.loading_context.restart_network = true
			arg_25_0.parent.loading_context.reload_packages = true

			return StateSplashScreen
		end
	end
end

function StateIngame.wanted_profile_index(arg_26_0)
	local var_26_0 = Network.peer_id()
	local var_26_1 = Managers.player:player_from_peer_id(var_26_0)
	local var_26_2 = var_26_1 and var_26_1:profile_index()

	if arg_26_0.is_in_tutorial then
		var_26_2 = nil
	end

	local var_26_3 = Managers.matchmaking.selected_profile_index
	local var_26_4 = SaveData.wanted_profile_index

	return var_26_3 or var_26_2 or var_26_4 or 0
end

function StateIngame.wanted_party_index(arg_27_0)
	return Managers.matchmaking.selected_party_index or 0
end

function StateIngame.post_update(arg_28_0, arg_28_1)
	local var_28_0 = Managers.time:time("game")

	arg_28_0.entity_system:post_update(arg_28_1, var_28_0)

	for iter_28_0, iter_28_1 in pairs(arg_28_0.machines) do
		if iter_28_1.post_update then
			iter_28_1:post_update(arg_28_1, var_28_0)
		end
	end

	Managers.state.game_mode:update_flow_object_set_enable(arg_28_1)
	Managers.state.game_mode:post_update(arg_28_1, var_28_0)
	Managers.state.unit_spawner:spawn_queued_units()

	local var_28_1 = Managers.state.network

	var_28_1.network_transmit:transmit_local_rpcs()
	Managers.state.unit_spawner:update_death_watch_list(arg_28_1, var_28_0)
	Managers.state.conflict:post_update()
	arg_28_0.entity_system:commit_and_remove_pending_units()
	var_28_1:update_transmit(arg_28_1)

	if Managers.voice_chat then
		Managers.voice_chat:update(arg_28_1, var_28_0)
	end
end

function StateIngame.pre_render(arg_29_0)
	if not arg_29_0.machines then
		return
	end

	for iter_29_0, iter_29_1 in pairs(arg_29_0.machines) do
		if iter_29_1.pre_render then
			iter_29_1:pre_render()
		end
	end
end

function StateIngame.render(arg_30_0)
	if not arg_30_0.machines then
		return
	end

	for iter_30_0, iter_30_1 in pairs(arg_30_0.machines) do
		if iter_30_1.render then
			iter_30_1:render()
		end
	end
end

function StateIngame.post_render(arg_31_0)
	if not arg_31_0.machines then
		return
	end

	for iter_31_0, iter_31_1 in pairs(arg_31_0.machines) do
		if iter_31_1.post_render then
			iter_31_1:post_render()
		end
	end
end

function StateIngame.on_exit(arg_32_0, arg_32_1)
	UPDATE_POSITION_LOOKUP()
	Managers:on_round_end()

	if arg_32_0.is_in_inn and not arg_32_0._gm_event_end_conditions_met and not arg_32_1 then
		Managers.backend:commit()
	end

	arg_32_0._camera_carrier:destroy()

	arg_32_0._camera_carrier = nil

	arg_32_0.free_flight_manager:cleanup_free_flight()

	if IS_XB1 and not arg_32_0.hero_stats_updated then
		Managers.xbox_stats:update_hero_stats(nil)

		arg_32_0.hero_stats_updated = true
	end

	arg_32_0._fps_reporter:report()
	arg_32_0._ping_reporter:report()
	arg_32_0:_check_and_add_end_game_telemetry(arg_32_1)

	if TelemetrySettings.collect_memory then
		local var_32_0 = Profiler.memory_tree()
		local var_32_1 = Profiler.memory_resources("all")

		Managers.telemetry_events:memory_statistics(var_32_0, var_32_1, "game_ended")
	end

	Managers.telemetry_events.rpc_listener:unregister(arg_32_0.network_event_delegate)
	Managers.state.performance_title:unregister_rpcs()
	DebugKeyHandler.set_enabled(false)
	DebugScreen.destroy()
	arg_32_0.network_timer_handler:unregister_rpcs()
	arg_32_0.network_timer_handler:destroy()

	arg_32_0.network_timer_handler = nil

	arg_32_0.network_clock:unregister_rpcs()
	arg_32_0.network_clock:destroy()

	arg_32_0.network_clock = nil

	if Managers.twitch then
		Managers.twitch:deactivate_twitch_game_mode()
	end

	for iter_32_0, iter_32_1 in pairs(arg_32_0.machines) do
		Managers.player:remove_player(Network.peer_id(), iter_32_0)
		iter_32_1:destroy()
	end

	arg_32_0.machines = nil

	Network.write_dump_tag("end of game")
	Managers.music:on_exit_level()

	local var_32_2 = Managers.level_transition_handler

	var_32_2:unregister_rpcs()
	Managers.mechanism:unregister_rpcs()
	Managers.party:unregister_rpcs()
	Managers.state.game_mode:cleanup_game_mode_units()
	Managers.state.game_mode:deactivate_mutators(true)

	local var_32_3 = Managers.state.unit_spawner

	var_32_3.locked = false

	var_32_3:commit_and_remove_pending_units()

	local var_32_4 = arg_32_0.world
	local var_32_5 = Managers.state.unit_storage:units()

	for iter_32_2, iter_32_3 in pairs(var_32_5) do
		if Unit.is_valid(iter_32_3) then
			Managers.state.entity:unregister_unit(iter_32_3)
			World.destroy_unit(var_32_4, iter_32_3)
		end
	end

	arg_32_0.entity_system:destroy()
	arg_32_0.entity_system_bag:destroy()
	ScriptWorld.trigger_level_shutdown(arg_32_0.level)
	Managers.player:exit_ingame()
	arg_32_0:_teardown_level()
	Managers.weave:teardown()
	Managers.state:destroy()
	VisualAssertLog.cleanup()
	arg_32_0:_teardown_world()
	ScriptUnit.check_all_units_deleted()

	if arg_32_1 then
		var_32_2.enemy_package_loader:on_application_shutdown()
		var_32_2.pickup_package_loader:on_application_shutdown()
		var_32_2.general_synced_package_loader:on_application_shutdown()
	end

	var_32_2.transient_package_loader:unload_all_packages(arg_32_1)
	arg_32_0.statistics_db:unregister_network_event_delegate()
	Managers.time:unregister_timer("game")

	local var_32_6 = arg_32_0.parent.loading_context.matchmaking_loading_context

	if var_32_6 and var_32_6.network_client then
		var_32_6.network_client:unregister_rpcs()
	end

	if arg_32_0.network_client then
		arg_32_0.network_client:unregister_rpcs()
	end

	if arg_32_0.network_server and not arg_32_1 then
		arg_32_0.network_server:on_level_exit()
	end

	if arg_32_0.network_client then
		arg_32_0.network_client.voip:set_input_manager(nil)
	end

	if arg_32_0.network_server then
		arg_32_0.network_server.voip:set_input_manager(nil)
	end

	if Managers.matchmaking then
		Managers.matchmaking:unregister_rpcs()
	end

	Managers.deed:unregister_rpcs()

	local var_32_7 = Managers.lobby:get_lobby("matchmaking_session_lobby")

	if arg_32_1 or arg_32_0.leave_lobby then
		if Managers.matchmaking then
			Managers.matchmaking:destroy()

			Managers.matchmaking = nil
		end

		if Managers.game_server then
			Managers.game_server:destroy()

			Managers.game_server = nil
		end

		Managers.chat:unregister_channel(1)
		Managers.mechanism:mechanism_try_call("unregister_chats")
		Managers.deed:network_context_destroyed()
		var_32_2.enemy_package_loader:network_context_destroyed()
		var_32_2.pickup_package_loader:network_context_destroyed()
		var_32_2.general_synced_package_loader:network_context_destroyed()
		var_32_2.transient_package_loader:network_context_destroyed()
		Managers.party:network_context_destroyed()

		local var_32_8 = arg_32_0.parent.loading_context
		local var_32_9 = var_32_8 and var_32_8.host_migration_info
		local var_32_10 = var_32_9 and var_32_9.current_level_key

		Managers.mechanism:network_context_destroyed(var_32_10)

		local var_32_11 = {
			__index = function(arg_33_0, arg_33_1)
				return function()
					Application.warning("Got RPC %s during forced network update when exiting StateIngame", arg_33_1)
				end
			end
		}
		local var_32_12 = var_32_8.start_lobby_data or var_32_8.join_lobby_data or var_32_8.join_server_data
		local var_32_13 = var_32_12 ~= nil and var_32_12.join_method == "party"

		if var_32_7.is_host then
			if arg_32_0.network_server then
				arg_32_0.network_server:destroy()

				arg_32_0.network_server = nil
			end
		else
			if var_32_13 then
				Managers.party:store_lobby(var_32_7:get_stored_lobby_data())
			end

			if arg_32_0.network_client then
				arg_32_0.network_client:destroy()

				arg_32_0.network_client = nil
			end
		end

		Managers.lobby:destroy_lobby("matchmaking_session_lobby")
		Network.update(0, setmetatable({}, var_32_11))
		Managers.account:set_current_lobby(nil)

		if arg_32_1 and rawget(_G, "LobbyInternal") then
			if Managers.party:has_party_lobby() then
				local var_32_14 = Managers.party:steal_lobby()

				if type(var_32_14) ~= "table" then
					LobbyInternal.leave_lobby(var_32_14)
				end
			end

			LobbyInternal.shutdown_client()
		end

		arg_32_0.profile_synchronizer = nil
		arg_32_0.parent.loading_context.network_client = nil
		arg_32_0.parent.loading_context.network_server = nil
		arg_32_0.parent.loading_context.network_transmit = nil

		arg_32_0.network_transmit:destroy()

		arg_32_0.network_transmit = nil
	else
		arg_32_0.profile_synchronizer:unregister_network_events()

		if arg_32_0.is_server and not arg_32_0.is_in_inn and not arg_32_0.is_in_tutorial and IS_XB1 and not script_data.honduras_demo then
			local var_32_15 = var_32_2:get_current_level_key()

			if LevelSettings[var_32_15].hub_level or var_32_15 == "prologue" then
				Application.warning("Cancelling matchmaking")
				var_32_7:enable_matchmaking(false)
			end
		end
	end

	arg_32_0.free_flight_manager:unregister_input_manager()

	arg_32_0.free_flight_manager = nil
	arg_32_0.parent = nil

	if arg_32_0._debug_event_manager_rpc then
		arg_32_0._debug_event_manager_rpc:delete()

		arg_32_0._debug_event_manager_rpc = nil
	end

	Managers.chat:unregister_network_event_delegate()
	Managers.eac:unregister_network_event_delegate()

	if Managers.mod then
		Managers.mod:unregister_network_event_delegate()
	end

	arg_32_0.dice_keeper:unregister_rpc()

	arg_32_0.dice_keeper = nil

	Managers.popup:remove_input_manager(arg_32_1)
	InputDebugger:clear()
	arg_32_0.input_manager:destroy()

	arg_32_0.input_manager = nil
	Managers.input = nil

	arg_32_0.network_event_delegate:unregister(arg_32_0)
	arg_32_0.network_event_delegate:destroy()

	arg_32_0.network_event_delegate = nil

	if arg_32_1 or arg_32_0.release_level_resources then
		var_32_2:release_level_resources()
	end

	Managers.transition:show_loading_icon()
	arg_32_0:_remove_ingame_clock()
	Managers.unlock:enable_update_unlocks(false)
	Managers.package:unload_dangling_painting_materials()
	Managers.mechanism:check_venture_end(arg_32_0.leave_lobby)
end

function StateIngame.on_close(arg_35_0)
	if arg_35_0.network_server and arg_35_0.network_server:num_active_peers() > 1 and not Development.parameter("disable_exit_popup_warning") then
		if arg_35_0._onclose_called then
			if arg_35_0.is_in_inn then
				arg_35_0:_commit_playfab_stats()
			else
				arg_35_0._quit_game = true
			end
		else
			arg_35_0._onclose_called = true

			Managers.chat.chat_gui:hide_chat()
			Managers.chat.chat_gui:unblock_input()
		end
	elseif arg_35_0.is_in_inn then
		arg_35_0:_commit_playfab_stats()
	else
		arg_35_0._quit_game = true
	end

	return false
end

function StateIngame._commit_playfab_stats(arg_36_0)
	local var_36_0 = Managers.backend

	local function var_36_1(arg_37_0)
		arg_36_0._quit_game = true
	end

	var_36_0:on_shutdown(var_36_1)
end

function StateIngame._check_and_add_end_game_telemetry(arg_38_0, arg_38_1)
	local var_38_0 = Managers.player:player_from_peer_id(arg_38_0.peer_id)
	local var_38_1 = arg_38_0.exit_type

	if arg_38_1 then
		var_38_1 = Boot.is_controlled_exit and "controlled_exit" or "forced_exit"
	elseif arg_38_0.exit_type == "load_next_level" or arg_38_0.exit_type == "reload_level" then
		if Managers.state.game_mode:game_won(var_38_0) then
			var_38_1 = "won"
		elseif Managers.state.game_mode:game_lost(var_38_0) then
			var_38_1 = "lost"
		end
	end

	Managers.telemetry_events:game_ended(var_38_1)
end

function StateIngame._setup_state_context(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0

	if arg_39_0.is_server then
		var_39_0 = NetworkClockServer:new()
	else
		var_39_0 = NetworkClockClient:new()
	end

	arg_39_0.network_clock = var_39_0

	var_39_0:register_rpcs(arg_39_3)

	local var_39_1 = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local var_39_2 = GameNetworkManager:new(arg_39_1, var_39_1, arg_39_2, arg_39_3)

	Managers.state.network = var_39_2

	local var_39_3 = BUILD

	if var_39_3 == "debug" or var_39_3 == "dev" then
		arg_39_0._debug_event_manager_rpc = DebugEventManagerRPC:new(arg_39_3)
	end

	if Development.parameter("weave_name") and not Managers.weave:get_active_objective() then
		Managers.mechanism:choose_next_state("weave")
		Managers.mechanism:progress_state()
	end

	local var_39_4 = EventManager:new(Managers.persistent_event)

	Managers.state.event = var_39_4
	Managers.state.flow_helper = FlowHelperManager:new(arg_39_1)

	local var_39_5 = Managers.level_transition_handler
	local var_39_6 = var_39_5:get_current_game_mode()
	local var_39_7, var_39_8, var_39_9 = Managers.mechanism:start_next_round()

	Managers.state.side = SideManager:new(var_39_8)

	for iter_39_0, iter_39_1 in pairs(DLCSettings) do
		local var_39_10 = iter_39_1.achievement_events

		if var_39_10 then
			for iter_39_2, iter_39_3 in pairs(var_39_10) do
				var_39_4:register(var_39_10, iter_39_2, iter_39_2)
			end
		end
	end

	arg_39_0.game_mode_key = var_39_6

	Managers.weave:initiate(arg_39_1, arg_39_3, arg_39_2, var_39_6)

	Managers.state.game_mode = GameModeManager:new(arg_39_1, var_39_1, arg_39_3, arg_39_0.statistics_db, var_39_6, arg_39_0.network_server or arg_39_0.network_client, arg_39_0.network_transmit, arg_39_0.profile_synchronizer, var_39_9)

	local var_39_11 = var_39_5:get_current_level_keys()
	local var_39_12 = var_39_5:get_current_level_seed()
	local var_39_13 = var_39_5:get_current_conflict_director()

	Managers.state.conflict = ConflictDirector:new(arg_39_1, var_39_11, arg_39_3, var_39_12, arg_39_2, var_39_13)
	Managers.state.networked_flow_state = NetworkedFlowStateManager:new(arg_39_1, arg_39_2, arg_39_3)

	Managers.level_transition_handler:create_queued_networked_flow_states(arg_39_0.level)
	GarbageLeakDetector.register_object(Managers.state.game_mode, "GameModeManager")
	GarbageLeakDetector.register_object(Managers.state.conflict, "ConflictDirector")

	Managers.state.camera = CameraManager:new(arg_39_1)

	GarbageLeakDetector.register_object(Managers.state.camera, "CameraManager")

	local var_39_14 = EntityManager2:new()

	Managers.state.entity = var_39_14

	if not DEDICATED_SERVER then
		Managers.state.decal = DecalManager:new(arg_39_1)
	end

	local var_39_15 = require("scripts/network/unit_extension_templates")

	local function var_39_16(arg_40_0, arg_40_1)
		if not arg_40_1 then
			local var_40_0, var_40_1 = ScriptUnit.extension_definitions(arg_40_0)

			return var_40_0, var_40_1
		end

		local var_40_2 = NetworkUnit.is_network_unit(arg_40_0) and NetworkUnit.is_husk_unit(arg_40_0)
		local var_40_3, var_40_4 = var_39_15.get_extensions(arg_40_1, var_40_2, arg_39_2)

		if not var_40_3 then
			var_40_3, var_40_4 = ScriptUnit.extension_definitions(arg_40_0)
		end

		return var_40_3, var_40_4
	end

	Managers.state.entity:set_extension_extractor_function(var_39_16)

	arg_39_0._debug_gui = World.create_screen_gui(arg_39_1, "material", "materials/fonts/gw_fonts")
	arg_39_0._debug_gui_immediate = World.create_screen_gui(arg_39_1, "material", "materials/fonts/gw_fonts", "immediate")
	Managers.state.debug_text = DebugTextManager:new(arg_39_1, arg_39_0._debug_gui, arg_39_2, arg_39_3)
	Managers.state.performance = PerformanceManager:new(arg_39_0._debug_gui_immediate, arg_39_2, var_39_11)
	Managers.state.world_interaction = WorldInteractionManager:new(arg_39_0.world)

	local var_39_17 = Managers.world:wwise_world(arg_39_1)
	local var_39_18 = {
		network_event_delegate = arg_39_3,
		is_server = arg_39_0.is_server,
		input_manager = arg_39_0.input_manager,
		network_server = arg_39_0.network_server,
		wwise_world = var_39_17
	}

	Managers.state.voting = VoteManager:new(var_39_18)
	arg_39_0.dice_keeper = DiceKeeper:new(7)

	arg_39_0.dice_keeper:register_rpcs(arg_39_3)

	local var_39_19 = UnitSpawner:new(arg_39_1, var_39_14, arg_39_2)

	Managers.state.unit_spawner = var_39_19

	var_39_5.enemy_package_loader:set_unit_spawner(var_39_19)
	var_39_19:set_unit_template_lookup_table(var_39_15)

	local var_39_20 = NetworkUnitStorage:new()

	Managers.state.unit_storage = var_39_20

	var_39_19:set_unit_storage(var_39_20)

	local var_39_21 = {
		world = arg_39_1
	}
	local var_39_22 = require("scripts/network/game_object_initializers_extractors")

	var_39_19:set_gameobject_initializer_data(var_39_22.initializers, var_39_22.extractors, var_39_21)
	var_39_19:set_gameobject_to_unit_creator_function(var_39_22.unit_from_gameobject_creator_func)

	arg_39_0.free_flight_manager = Managers.free_flight

	arg_39_0.free_flight_manager:register_input_manager(arg_39_0.input_manager)

	arg_39_0.network_timer_handler = NetworkTimerHandler:new(arg_39_0.world, arg_39_0.network_clock, arg_39_0.is_server)

	arg_39_0.network_timer_handler:register_rpcs(arg_39_3)

	Managers.state.debug = DebugManager:new(arg_39_1, arg_39_0.free_flight_manager, arg_39_0.input_manager, arg_39_3, arg_39_2)
	Managers.state.spawn = SpawnManager:new(arg_39_1, arg_39_2, arg_39_3, var_39_19, arg_39_0.profile_synchronizer, arg_39_0.network_server)

	local var_39_23 = var_39_5:get_current_level_keys()
	local var_39_24 = var_39_5:get_current_environment_variation_name()
	local var_39_25 = {
		profile_synchronizer = arg_39_0.profile_synchronizer,
		game_mode = Managers.state.game_mode,
		networked_flow_state = Managers.state.networked_flow_state,
		room_manager = Managers.state.room,
		spawn_manager = Managers.state.spawn,
		network_clock = arg_39_0.network_clock,
		player_manager = Managers.player,
		network_transmit = arg_39_0.network_transmit,
		network_server = arg_39_0.network_server,
		network_client = arg_39_0.network_client,
		statistics_db = arg_39_0.statistics_db,
		difficulty_manager = Managers.state.difficulty,
		weave_manager = Managers.weave,
		matchmaking_manager = Managers.matchmaking,
		voting_manager = Managers.state.voting,
		game_server_manager = Managers.game_server
	}

	var_39_2:post_init(var_39_25)

	arg_39_0.entity_system_bag = EntitySystemBag:new()

	local var_39_26 = {
		entity_manager = var_39_14,
		input_manager = arg_39_0.input_manager,
		unit_spawner = var_39_19,
		world = arg_39_0.world,
		startup_data = {
			level_key = var_39_23,
			environment_variation_name = var_39_24
		},
		is_server = arg_39_2,
		free_flight_manager = arg_39_0.free_flight_manager,
		network_event_delegate = arg_39_3,
		unit_storage = var_39_20,
		entity_system_bag = arg_39_0.entity_system_bag,
		network_clock = arg_39_0.network_clock,
		network_manager = Managers.state.network,
		network_lobby = var_39_1,
		network_transmit = arg_39_0.network_transmit,
		network_server = arg_39_0.network_server,
		profile_synchronizer = arg_39_0.profile_synchronizer,
		dice_keeper = arg_39_0.dice_keeper,
		system_api = {},
		statistics_db = arg_39_0.statistics_db,
		num_local_human_players = arg_39_0.num_local_human_players,
		level_transition_handler = var_39_5
	}
	local var_39_27 = EntitySystem:new(var_39_26)

	GarbageLeakDetector.register_object(var_39_27, "EntitySystem")
	GarbageLeakDetector.register_object(var_39_26, "entity_systems_init_context")
	GarbageLeakDetector.register_object(var_39_26.system_api, "system_api")

	arg_39_0.entity_system = var_39_27

	Managers.player:set_is_server(arg_39_2, arg_39_3, Managers.state.network)
	Managers.state.network:set_entity_system(var_39_27)
	Managers.state.network:set_unit_storage(var_39_20)
	Managers.state.network:set_unit_spawner(var_39_19)

	Managers.state.vce = VCEManager:new()

	local var_39_28 = require("scripts/utils/debug_screen_config")

	DebugScreen.setup(arg_39_0._top_gui_world, var_39_28.settings, var_39_28.callbacks, arg_39_2)

	local var_39_29 = Managers.state.entity:system("ai_system"):nav_world()
	local var_39_30 = World.get_data(arg_39_1, "physics_world")

	Managers.state.bot_nav_transition = BotNavTransitionManager:new(arg_39_1, var_39_30, var_39_29, arg_39_2, arg_39_3)

	if not DEDICATED_SERVER then
		Managers.state.quest = QuestManager:new(arg_39_0.statistics_db)
	end

	Managers.state.achievement = AchievementManager:new(arg_39_0.world, arg_39_0.statistics_db)

	if DEDICATED_SERVER then
		Managers.state.blood = BloodManagerDummy:new()
	else
		Managers.state.blood = BloodManager:new(arg_39_0.world)
	end

	Managers.state.status_effect = StatusEffectManager:new(arg_39_0.world)
	Managers.state.performance_title = PerformanceTitleManager:new(arg_39_0.network_transmit, arg_39_0.statistics_db, arg_39_2)

	Managers.state.performance_title:register_rpcs(arg_39_3)
	Managers.mechanism:state_context_set_up()
end

function StateIngame.rpc_kick_peer(arg_41_0, arg_41_1)
	if arg_41_0.network_client == nil then
		return
	end

	local var_41_0 = CHANNEL_TO_PEER_ID[arg_41_1]

	if arg_41_0.network_client.server_peer_id ~= var_41_0 then
		return
	end

	if arg_41_0.is_server then
		return
	end

	if Managers.party:is_leader(arg_41_0.peer_id) then
		return
	end

	arg_41_0.kicked_by_server = true
end

function StateIngame.event_play_particle_effect(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	if arg_42_6 then
		ScriptWorld.create_particles_linked(arg_42_0.world, arg_42_1, arg_42_2, arg_42_3, "destroy", Matrix4x4.from_quaternion_position(arg_42_5, arg_42_4))
	else
		local var_42_0
		local var_42_1

		if arg_42_2 then
			var_42_0 = Unit.world_position(arg_42_2, arg_42_3)
			var_42_1 = Unit.world_rotation(arg_42_2, arg_42_3)
		else
			var_42_0 = Vector3(0, 0, 0)
			var_42_1 = Quaternion.identity()
		end

		local var_42_2 = Matrix4x4.from_quaternion_position(var_42_1, var_42_0)
		local var_42_3 = Matrix4x4.from_quaternion_position(arg_42_5, arg_42_4)
		local var_42_4 = Matrix4x4.multiply(var_42_3, var_42_2)

		World.create_particles(arg_42_0.world, arg_42_1, Matrix4x4.translation(var_42_4), Matrix4x4.rotation(var_42_4))
	end
end

function StateIngame.gm_event_end_conditions_met(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	Managers.state.game_mode:gm_event_end_conditions_met(arg_43_1, arg_43_2, arg_43_3)
	LevelHelper:flow_event(arg_43_0.world, "gm_event_end_conditions_met")

	arg_43_0._gm_event_end_conditions_met = true
	arg_43_0._gm_event_end_reason = arg_43_1

	if arg_43_0.is_server then
		Managers.state.voting:set_vote_kick_enabled(false)
	end

	Managers.state.conflict:set_disabled(true)

	local var_43_0 = Managers.player:player_from_peer_id(arg_43_0.peer_id)
	local var_43_1 = Managers.state.game_mode:game_mode_key()
	local var_43_2, var_43_3 = Managers.state.game_mode:evaluate_end_condition_outcome(arg_43_1, var_43_0)

	print("gm_event_end_conditions_met", var_43_2, var_43_3)
	Managers.popup:cancel_all_popups()
	Managers.account:check_popup_retrigger()

	if var_43_1 == "survival" then
		if var_43_2 and arg_43_0.is_server then
			Managers.state.entity:system("leaderboard_system"):round_completed()

			if GameSettingsDevelopment.use_leaderboards or Development.parameter("use_leaderboards") then
				StatisticsUtil.register_online_leaderboards_data(arg_43_0.statistics_db)
			end
		end
	elseif var_43_2 then
		Managers.state.entity:system("mission_system"):evaluate_level_end_missions()

		if IS_PS4 then
			local var_43_4 = Managers.state.game_mode:level_key()
			local var_43_5 = LevelSettings[var_43_4].display_name
			local var_43_6 = Managers.state.difficulty:get_difficulty_settings().display_name

			Managers.account:activity_feed_post_mission_completed(var_43_5, var_43_6)
		end
	elseif var_43_3 and arg_43_0.is_server and arg_43_2 then
		Managers.state.voting:request_vote("continue_level", nil, Network.peer_id())
	end

	if arg_43_0.is_server and not arg_43_0.is_in_inn then
		local var_43_7 = Managers.player:human_players()

		Managers.state.performance_title:evaluate_titles(var_43_7)
	end

	for iter_43_0, iter_43_1 in pairs(arg_43_0.machines) do
		iter_43_1:state():gm_event_end_conditions_met(arg_43_1, arg_43_2, arg_43_3)
	end

	if arg_43_0.is_server and DEDICATED_SERVER then
		local var_43_8 = Managers.mechanism:is_final_round()
		local var_43_9 = Managers.mechanism:get_players_session_score(arg_43_0.statistics_db, arg_43_0.profile_synchronizer, arg_43_0._saved_scoreboard_stats)

		if var_43_8 then
			Managers.mechanism:sync_players_session_score(var_43_9)
		else
			arg_43_0.parent.loading_context.saved_scoreboard_stats = var_43_9
		end
	end
end

function StateIngame._generate_ingame_clock(arg_44_0)
	if arg_44_0.network_server and Managers.time:time("client_ingame") == nil then
		local var_44_0 = arg_44_0.network_server.peer_state_machines

		for iter_44_0, iter_44_1 in pairs(var_44_0) do
			if iter_44_1.current_state.state_name == "InGame" then
				Managers.time:register_timer("client_ingame", "main", 0)

				break
			end
		end
	end
end

function StateIngame._remove_ingame_clock(arg_45_0)
	local var_45_0 = Managers.time

	if var_45_0:has_timer("client_ingame") then
		var_45_0:unregister_timer("client_ingame")
	end
end

function StateIngame._handle_onclose_warning_result(arg_46_0)
	if arg_46_0._onclose_popup_id then
		local var_46_0 = Managers.popup:query_result(arg_46_0._onclose_popup_id)

		if var_46_0 == "end_game" then
			if arg_46_0.is_in_inn then
				arg_46_0:_commit_playfab_stats()
			else
				arg_46_0._quit_game = true
			end
		elseif var_46_0 == "cancel_popup" then
			arg_46_0._onclose_popup_id = nil
			arg_46_0._onclose_called = false
		end
	end
end
