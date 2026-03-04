-- chunkname: @scripts/game_state/state_loading.lua

require("scripts/game_state/server_join_state_machine")
require("scripts/game_state/loading_sub_states/win32/state_loading_running")
require("scripts/game_state/loading_sub_states/win32/state_loading_restart_network")
require("scripts/game_state/loading_sub_states/win32/state_loading_migrate_host")
require("scripts/helpers/level_helper")
require("scripts/settings/level_settings")
require("scripts/utils/async_level_spawner")
require("scripts/game_state/loading_sub_states/win32/state_loading_versus_migration")

local var_0_0 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

StateLoading = class(StateLoading)
StateLoading.NAME = "StateLoading"

local var_0_1 = false
local var_0_2 = 30

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

local var_0_3 = {
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

local function var_0_4(arg_1_0)
	if arg_1_0 == "false" then
		return false
	else
		return arg_1_0
	end
end

function StateLoading.on_enter(arg_2_0, arg_2_1)
	print("[Gamestate] Enter state StateLoading")

	local var_2_0 = arg_2_0.parent.loading_context
	local var_2_1 = var_2_0.time_spent_in_level
	local var_2_2 = var_2_0.end_reason

	Managers.load_time:start_timer(var_2_1, var_2_2)

	if not Managers.play_go:installed() then
		Managers.play_go:set_install_speed("suspended")
	end

	if IS_XB1 then
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

	arg_2_0._registered_rpcs = false
	arg_2_0._loading_view_setup_is_done = false

	arg_2_0:set_loadout_resync_state(StateLoading.LoadoutResyncStates.IDLE)
	arg_2_0:_setup_state_managers()
	arg_2_0:_setup_garbage_collection()
	arg_2_0:_setup_world()
	arg_2_0:_setup_input()
	arg_2_0:_parse_loading_context()
	arg_2_0:_create_loading_view()
	arg_2_0:_setup_end_of_level_ui()
	arg_2_0:_setup_first_time_ui()
	arg_2_0:_setup_init_network_view()
	Managers.popup:set_input_manager(arg_2_0._input_manager)

	if not DEDICATED_SERVER then
		Managers.chat:set_input_manager(arg_2_0._input_manager)
	end

	arg_2_0:_setup_state_machine()
	arg_2_0:_unmute_all_world_sounds()

	if arg_2_0._switch_to_tutorial_backend then
		Managers.backend:start_tutorial()
		Managers.mechanism:choose_next_state(arg_2_0._wanted_tutorial_state)
		Managers.mechanism:progress_state()

		arg_2_0.parent.loading_context.switch_to_tutorial_backend = nil
		arg_2_0.parent.loading_context.wanted_tutorial_state = nil
	elseif LAUNCH_MODE == "attract_benchmark" then
		Managers.backend:start_benchmark()
	end

	local var_2_3 = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if var_2_3 and not var_2_3.is_host and not var_2_3:is_dedicated_server() then
		Managers.party:set_leader(var_2_3:lobby_host())
	end

	Managers.transition:hide_icon_background()
	Managers.transition:fade_out(GameSettings.transition_fade_out_speed)
	Managers.light_fx:set_lightfx_color_scheme("loading")

	arg_2_0._menu_setup_done = false

	if IS_XB1 and var_2_3 and var_2_3.is_host then
		Managers.account:set_round_id()
	end

	if arg_2_0._network_client then
		arg_2_0._network_client.voip:set_input_manager(arg_2_0._input_manager)
	end

	if arg_2_0._network_server then
		arg_2_0._network_server.voip:set_input_manager(arg_2_0._input_manager)
	end

	if arg_2_0.parent.loading_context.finished_tutorial then
		arg_2_0.parent.loading_context.finished_tutorial = nil
		arg_2_0.parent.loading_context.show_profile_on_startup = true

		if not Managers.play_go:installed() then
			arg_2_0._wanted_state = StateTitleScreen
			arg_2_0._teardown_network = true
		end
	end

	arg_2_0._has_invitation_error = false

	if DEDICATED_SERVER then
		local var_2_4 = Managers.level_transition_handler:get_current_level_key()

		if not arg_2_0:loading_view_setup_done() then
			arg_2_0:setup_loading_view(var_2_4)
		end
	end

	arg_2_0._ingame_world_object = nil
	arg_2_0._ingame_level_object = nil

	local var_2_5 = true

	Managers.music:unduck_sounds(var_2_5)
end

function StateLoading._setup_state_managers(arg_3_0)
	Managers.state.event = EventManager:new(Managers.persistent_event)
end

function StateLoading.set_loadout_resync_state(arg_4_0, arg_4_1)
	fassert(table.contains(StateLoading.LoadoutResyncStates, arg_4_1), "[StateLoading] State %s not found in LoadoutResyncStates", tostring(arg_4_1))

	arg_4_0._loadout_resync_state = arg_4_1
end

function StateLoading.loadout_resync_state(arg_5_0)
	return arg_5_0._loadout_resync_state
end

function StateLoading._setup_input(arg_6_0)
	local var_6_0 = InputManager:new()

	Managers.input = var_6_0
	arg_6_0._input_manager = var_6_0

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

function StateLoading._parse_loading_context(arg_7_0)
	local var_7_0 = arg_7_0.parent.loading_context

	if var_7_0 then
		arg_7_0._network_server = var_7_0.network_server
		arg_7_0._network_client = var_7_0.network_client
		arg_7_0._checkpoint_data = var_7_0.checkpoint_data
		arg_7_0._quickplay_bonus = var_7_0.quickplay_bonus
		arg_7_0._level_end_view_context = var_7_0.level_end_view_context
		arg_7_0._switch_to_tutorial_backend = var_7_0.switch_to_tutorial_backend
		arg_7_0._wanted_tutorial_state = var_7_0.wanted_tutorial_state
		arg_7_0._saved_scoreboard_stats = var_7_0.saved_scoreboard_stats
	end
end

function StateLoading._setup_garbage_collection(arg_8_0)
	local var_8_0 = true

	GarbageLeakDetector.run_leak_detection(var_8_0)
	GarbageLeakDetector.register_object(arg_8_0, "StateLoadingRunning")
end

function StateLoading._setup_world(arg_9_0)
	arg_9_0._world_name = "loading_world"
	arg_9_0._viewport_name = "loading_viewport"
	arg_9_0._world = Managers.world:create_world(arg_9_0._world_name, GameSettingsDevelopment.default_environment, nil, nil, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH)
	arg_9_0._viewport = ScriptWorld.create_viewport(arg_9_0._world, arg_9_0._viewport_name, "overlay", 1)
end

function StateLoading._setup_init_network_view(arg_10_0)
	if Development.parameter("goto_endoflevel") and false then
		require("scripts/game_state/state_loading")

		local var_10_0 = false

		Managers.package:load("resource_packages/levels/dicegame", "state_loading", nil, var_10_0)

		arg_10_0.parent.loading_context.play_end_of_level_game = true
		arg_10_0._wanted_state = StateLoading
	else
		require("scripts/game_state/state_ingame")

		arg_10_0._wanted_state = StateIngame
	end
end

function StateLoading._setup_end_of_level_ui(arg_11_0)
	if arg_11_0._level_end_view_context then
		arg_11_0._level_end_view_context.lobby = Managers.lobby:query_lobby("matchmaking_session_lobby")
		arg_11_0._level_end_view_wrappers = {}
		arg_11_0._level_end_view_wrappers[1] = LevelEndViewWrapper:new(arg_11_0._level_end_view_context)

		arg_11_0._level_end_view_wrappers[1]:start()

		arg_11_0._level_end_view_context = nil
		arg_11_0.parent.loading_context.level_end_view_context = nil
	end
end

function StateLoading._setup_first_time_ui(arg_12_0)
	local var_12_0 = arg_12_0.parent.loading_context

	if (var_12_0.first_time or var_12_0.gamma_correct or var_12_0.play_trailer) and not GameSettingsDevelopment.disable_intro_trailer and not script_data.skip_intro_trailer then
		local var_12_1 = Managers.mechanism:game_mechanism():get_hub_level_key()
		local var_12_2 = Boot.loading_context and Boot.loading_context.level_key or var_12_1
		local var_12_3
		local var_12_4 = {}
		local var_12_5 = Managers.level_transition_handler:get_current_level_key()

		var_12_4.is_prologue = arg_12_0._switch_to_tutorial_backend == true

		local var_12_6 = PLATFORM

		if IS_WINDOWS or IS_LINUX then
			var_12_2 = Development.parameter("attract_mode") and BenchmarkSettings.auto_host_level or var_12_2
			var_12_2 = var_0_4(Development.parameter("auto_host_level")) or Development.parameter("vs_auto_search") and "carousel_hub" or var_12_2
			var_12_3 = not LevelSettings[var_12_2].hub_level and not var_12_4.is_prologue
			var_12_3 = var_12_0.join_lobby_data or Development.parameter("auto_join") or var_12_3 or Development.parameter("skip_splash")

			if not var_12_3 and Development.parameter("weave_name") then
				var_12_3 = true
			end

			var_12_4.gamma = not SaveData.gamma_corrected
			var_12_4.trailer = var_12_0.play_trailer or Application.user_setting("play_intro_cinematic")
		elseif IS_CONSOLE then
			var_12_2 = var_0_4(Development.parameter("auto_host_level")) or var_12_2
			var_12_3 = not LevelSettings[var_12_2].hub_level
			var_12_3 = var_12_0.join_lobby_data or Development.parameter("auto_join") or var_12_3 or Development.parameter("skip_splash")

			if not var_12_3 and Development.parameter("weave_name") then
				var_12_3 = true
			end

			var_12_4.gamma = var_12_0.gamma_correct
			var_12_4.trailer = var_12_0.play_trailer or Application.user_setting("play_intro_cinematic")

			if var_12_4.gamma or var_12_4.trailer then
				var_12_3 = false
			end

			var_12_4.is_prologue = var_12_2 == "prologue"
		end

		print("[StateLoading] Auto Skip: ", var_12_3)

		var_12_0.gamma_correct = nil
		var_12_0.play_trailer = nil
		arg_12_0._first_time_view = TitleLoadingUI:new(arg_12_0._world, var_12_4, var_12_3)

		if not arg_12_0._first_time_view:is_loading_packages() then
			Managers.transition:hide_loading_icon()
		end

		Managers.chat:enable_gui(false)
		arg_12_0._loading_view:deactivate()
	end

	var_12_0.first_time = nil
end

function StateLoading._unmute_all_world_sounds(arg_13_0)
	Managers.music:trigger_event("unmute_all_world_sounds")
end

function StateLoading._get_game_difficulty(arg_14_0)
	return Managers.level_transition_handler:get_current_difficulty()
end

function StateLoading._create_loading_view(arg_15_0, arg_15_1, arg_15_2)
	if DEDICATED_SERVER then
		return
	end

	local var_15_0 = arg_15_0:_get_game_difficulty()
	local var_15_1 = {
		world = arg_15_0._world,
		input_manager = arg_15_0._input_manager,
		level_key = arg_15_1,
		game_difficulty = var_15_0,
		world_manager = Managers.world,
		chat_manager = Managers.chat,
		profile_synchronizer = arg_15_0._profile_synchronizer,
		act_progression_index = arg_15_2,
		return_to_pc_menu = arg_15_0.parent.loading_context.return_to_pc_menu
	}

	arg_15_0._loading_view = LoadingView:new(var_15_1)
	arg_15_0.parent.loading_context.return_to_pc_menu = nil
end

function StateLoading._trigger_loading_view(arg_16_0, arg_16_1, arg_16_2)
	arg_16_1 = arg_16_1 or Managers.mechanism:default_level_key()

	if not arg_16_0._loading_music_triggered then
		local var_16_0 = Managers.mechanism:game_mechanism()

		if var_16_0:should_play_level_introduction() and not Development.parameter("gdc") then
			local var_16_1 = LevelSettings[arg_16_1]
			local var_16_2 = Managers.lobby:query_lobby("matchmaking_session_lobby")
			local var_16_3 = var_16_2 and var_16_2:lobby_data("weave_name") or Managers.weave:get_next_weave() or Development.parameter("weave_name")
			local var_16_4 = WeaveSettings.templates[var_16_3]

			if var_16_4 then
				arg_16_0._weave_wwise_events = arg_16_0:_trigger_weave_sound_events(var_16_4, arg_16_1, var_16_1.is_arena)
			else
				arg_16_0._wwise_event = arg_16_0:_trigger_sound_events(arg_16_1)

				arg_16_0._loading_view:trigger_subtitles(arg_16_0._wwise_event, Managers.time:time("main"))
			end
		end

		local var_16_5 = LevelSettings[arg_16_1].mechanism
		local var_16_6 = var_0_3[var_16_5]

		var_16_6 = var_16_0.override_loading_screen_music and var_16_0:override_loading_screen_music() or var_16_6

		if Managers.weave:get_active_weave() then
			var_16_6 = "reset_between_winds"
		end

		if arg_16_2 and arg_16_2 >= 1 and arg_16_2 < 4 then
			var_16_6 = var_16_6 .. "_act" .. arg_16_2
		elseif arg_16_2 and arg_16_2 >= 4 then
			var_16_6 = var_16_6 .. "_finished"
		end

		if var_16_6 then
			Managers.music:trigger_event(var_16_6)
		end
	end

	arg_16_0._activate_loading_view = true
	arg_16_0._loading_music_triggered = true

	Managers.transition:hide_icon_background()
	Managers.transition:force_fade_in()
end

function StateLoading.setup_loading_view(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or Managers.mechanism:default_level_key()
	arg_17_0._level_key = arg_17_1

	if not DEDICATED_SERVER then
		local var_17_0 = Managers.package

		if arg_17_0._ui_package_name and (var_17_0:has_loaded(arg_17_0._ui_package_name, "global_loading_screens") or var_17_0:is_loading(arg_17_0._ui_package_name)) then
			var_17_0:unload(arg_17_0._ui_package_name, "global_loading_screens")
		end

		local var_17_1 = LevelSettings[arg_17_1]
		local var_17_2 = Managers.weave:get_next_weave() or Development.parameter("weave_name")

		if var_17_1.game_mode == "weave" then
			local var_17_3 = Managers.lobby:query_lobby("matchmaking_session_lobby")

			var_17_2 = var_17_3 and var_17_3:lobby_data("selected_mission_id") or var_17_2

			if not var_17_2 or var_17_2 == "false" or not WeaveSettings.templates[var_17_2] then
				if IS_XB1 and not var_17_3:is_updating_lobby_data() then
					var_17_3:force_update_lobby_data()
				end

				return
			end

			local var_17_4 = WeaveSettings.templates[var_17_2]
			local var_17_5 = var_17_4.objectives[1]
			local var_17_6 = var_17_5.level_id
			local var_17_7 = LevelSettings[var_17_6].level_key
			local var_17_8 = var_17_4.wind

			if var_17_1.is_arena then
				local var_17_9 = arg_17_0._level_key
				local var_17_10 = LevelSettings[var_17_9].loading_ui_package_name

				arg_17_0._ui_package_name = "resource_packages/loading_screens/" .. var_17_10
				arg_17_0._loading_material_path = nil
				arg_17_0._loading_material_name = nil
			else
				arg_17_0._ui_package_name = "resource_packages/loading_screens/" .. "weaves/" .. var_17_7 .. "/" .. var_17_7 .. "_" .. var_17_8
				arg_17_0._loading_material_path = "weaves/" .. var_17_7 .. "/" .. var_17_7 .. "_" .. var_17_8
				arg_17_0._loading_material_name = var_17_7 .. "_" .. var_17_8
			end

			arg_17_0._weave_data = {
				weave_display_name = var_17_4.display_name,
				location_display_name = var_17_1.display_name,
				wind_name = var_17_4.wind,
				is_arena = var_17_1.is_arena,
				objective_name = var_17_5.display_name
			}
		else
			local var_17_11 = LevelSettings[arg_17_1].loading_ui_package_name

			arg_17_0._ui_package_name = "resource_packages/loading_screens/" .. var_17_11
			arg_17_0._loading_material_path = nil
			arg_17_0._loading_material_name = nil
			arg_17_0._weave_data = nil
		end

		local var_17_12

		if not var_17_0:has_loaded(arg_17_0._ui_package_name) and not var_17_0:has_loaded(arg_17_0._ui_package_name, "global_loading_screens") then
			var_17_0:load(arg_17_0._ui_package_name, "global_loading_screens", callback(arg_17_0, "cb_loading_screen_loaded", arg_17_0._level_key, var_17_12), true, true)
		else
			arg_17_0:cb_loading_screen_loaded(arg_17_0._level_key, var_17_12, true)
		end
	end

	arg_17_0._loading_view_setup_is_done = true
end

function StateLoading.loading_view_setup_done(arg_18_0)
	return arg_18_0._loading_view_setup_is_done
end

function StateLoading.setup_menu_assets(arg_19_0)
	local var_19_0 = "menu_assets"
	local var_19_1 = "resource_packages/menu_assets"
	local var_19_2 = Managers.package
	local var_19_3 = var_19_2:has_loaded(var_19_1, var_19_0) or var_19_2:is_loading(var_19_1, var_19_0)
	local var_19_4

	if not var_19_3 then
		var_19_4 = var_19_1
	end

	if var_19_4 then
		var_19_2:load(var_19_4, var_19_0, nil, true, true)

		arg_19_0._ui_loading_package_reference_name = var_19_0
		arg_19_0._ui_loading_package_path = var_19_4
	end

	arg_19_0._menu_setup_done = true
end

function StateLoading.menu_assets_setup_done(arg_20_0)
	return arg_20_0._menu_setup_done
end

function StateLoading.cb_loading_screen_loaded(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_0._first_time_view or arg_21_0._level_end_view_wrappers then
		local var_21_0 = arg_21_0:_get_game_difficulty()

		arg_21_0._loading_view:texture_resource_loaded(arg_21_1, arg_21_2, var_21_0, arg_21_0._loading_material_path, arg_21_0._loading_material_name, arg_21_0._weave_data)
	elseif arg_21_3 then
		arg_21_0:cb_loading_screen_change_fade(arg_21_1, arg_21_2, arg_21_3)
	else
		Managers.transition:fade_in(3, callback(arg_21_0, "cb_loading_screen_change_fade", arg_21_1, arg_21_2))
	end
end

function StateLoading.cb_loading_screen_change_fade(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0:_get_game_difficulty()

	arg_22_0._loading_view:texture_resource_loaded(arg_22_1, arg_22_2, var_22_0, arg_22_0._loading_material_path, arg_22_0._loading_material_name, arg_22_0._weave_data)
	arg_22_0:_trigger_loading_view(arg_22_1, arg_22_2)

	if not arg_22_3 then
		Managers.transition:fade_out(3)
	end
end

function StateLoading._trigger_sound_events(arg_23_0, arg_23_1)
	local var_23_0 = LevelSettings[arg_23_1].loading_screen_wwise_events
	local var_23_1

	if var_23_0 then
		local var_23_2 = arg_23_0._network_server
		local var_23_3 = arg_23_0._network_client
		local var_23_4 = var_23_2 and var_23_2.profile_synchronizer or var_23_3 and var_23_3.profile_synchronizer

		if var_23_4 then
			local var_23_5 = var_23_4:get_peers_with_full_profiles()

			for iter_23_0 = 1, #var_23_5 do
				local var_23_6 = var_23_5[iter_23_0]
				local var_23_7 = var_23_6.profile_index
				local var_23_8 = var_23_6.career_index
				local var_23_9 = SPProfiles[var_23_7]
				local var_23_10 = var_23_9 and var_23_9.careers[var_23_8]
				local var_23_11 = var_23_10 and var_23_10.name

				if var_23_0[var_23_11] then
					var_23_1 = var_23_1 or {}

					table.append(var_23_1, var_23_0[var_23_11])
				end
			end
		end
	end

	local var_23_12 = var_23_1 or var_23_0

	if var_23_12 ~= nil and #var_23_12 > 0 then
		local var_23_13 = Managers.level_transition_handler:get_current_level_seed()
		local var_23_14, var_23_15 = Math.next_random(var_23_13, 1, #var_23_12)
		local var_23_16 = var_23_12[var_23_15]

		if not script_data.disable_level_intro_dialogue then
			local var_23_17, var_23_18 = Managers.music:trigger_event(var_23_16)

			arg_23_0.wwise_playing_id = var_23_17
		end

		return var_23_16
	end
end

function StateLoading._trigger_weave_sound_events(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0
	local var_24_1 = LevelSettings[arg_24_2]
	local var_24_2 = arg_24_1.wind
	local var_24_3 = WindSettings[var_24_2].loading_screen_wwise_events

	if arg_24_3 then
		local var_24_4 = var_24_3.primary_arena_wwise_events[Math.random(#var_24_3.primary_arena_wwise_events)]
		local var_24_5 = var_24_3.secondary_arena_wwise_events[Math.random(#var_24_3.secondary_arena_wwise_events)]

		var_24_0 = {
			var_24_4,
			var_24_5
		}
	else
		local var_24_6 = var_24_3.lore[Math.random(#var_24_3.lore)]
		local var_24_7 = var_24_3.mechanics[Math.random(#var_24_3.mechanics)]
		local var_24_8

		if not var_24_1.is_arena then
			local var_24_9 = 1
			local var_24_10 = arg_24_1.objectives[var_24_9].display_name
			local var_24_11 = var_24_3.objectives[var_24_10]

			var_24_8 = var_24_11[Math.random(#var_24_11)]
		end

		var_24_0 = {
			var_24_6,
			var_24_7,
			var_24_8
		}
	end

	Managers.music:stop_event_queue("weave_loading_vo")

	local var_24_12 = 0.5

	if not script_data.disable_level_intro_dialogue then
		local var_24_13, var_24_14 = Managers.music:trigger_event_queue("weave_loading_vo", var_24_0, var_24_12)

		arg_24_0.wwise_playing_id = var_24_13
	end

	return var_24_0
end

function StateLoading._setup_state_machine(arg_25_0)
	local var_25_0 = {
		world = arg_25_0._world,
		viewport = arg_25_0._viewport,
		loading_view = arg_25_0._loading_view,
		starting_tutorial = arg_25_0._switch_to_tutorial_backend
	}

	if arg_25_0.parent.loading_context.restart_network then
		arg_25_0._machine = GameStateMachine:new(arg_25_0, StateLoadingRestartNetwork, var_25_0, true)
	elseif arg_25_0.parent.loading_context.host_migration_info then
		arg_25_0._machine = GameStateMachine:new(arg_25_0, StateLoadingMigrateHost, var_25_0, true)
	elseif arg_25_0.parent.loading_context.versus_migration then
		arg_25_0._machine = GameStateMachine:new(arg_25_0, StateLoadingVersusMigration, var_25_0, true)
	else
		arg_25_0._machine = GameStateMachine:new(arg_25_0, StateLoadingRunning, var_25_0, true)
	end
end

function StateLoading._handle_do_reload(arg_26_0)
	if arg_26_0.wwise_playing_id then
		Managers.music:stop_event_id(arg_26_0.wwise_playing_id)

		arg_26_0.wwise_playing_id = nil
	end

	if var_0_1 and arg_26_0._wwise_event then
		arg_26_0.wwise_playing_id = Managers.music:trigger_event(arg_26_0._wwise_event)
		var_0_1 = false
	elseif var_0_1 and arg_26_0._weave_wwise_events then
		Managers.music:stop_event_queue("weave_loading_vo")

		local var_26_0 = 0.5

		arg_26_0.wwise_playing_id = Managers.music:trigger_event_queue("weave_loading_vo", arg_26_0._weave_wwise_events, var_26_0)
		var_0_1 = false
	end
end

function StateLoading.set_invitation_error(arg_27_0)
	arg_27_0._has_invitation_error = true
end

function StateLoading.update(arg_28_0, arg_28_1, arg_28_2)
	if script_data.subtitle_debug then
		arg_28_0:_handle_do_reload()
	end

	Network.update_receive(arg_28_1, arg_28_0._network_event_delegate.event_table)
	arg_28_0:_update_network(arg_28_1, arg_28_2)

	local var_28_0 = Managers.level_transition_handler

	if IS_PS4 and not arg_28_0._popup_id and not arg_28_0._handled_psn_client_error and arg_28_0:_update_loading_global_packages() and var_28_0:all_packages_loaded() and var_28_0.enemy_package_loader:loading_completed() and var_28_0.pickup_package_loader:loading_completed() and var_28_0.transient_package_loader:loading_completed() and var_28_0.general_synced_package_loader:loading_completed() and Managers.backend:profiles_loaded() then
		local var_28_1 = Managers.account:psn_client_error()

		if var_28_1 then
			printf("[StateLoading] PSN CLIENT ERROR %s", var_28_1)
			arg_28_0:create_popup("failure_psn_client_error", "popup_error_topic", "restart_as_server", "menu_accept")

			arg_28_0._handled_psn_client_error = true
			arg_28_0._wanted_state = StateTitleScreen
		end
	end

	if IS_CONSOLE and arg_28_0._has_invitation_error and not arg_28_0._popup_id then
		arg_28_0:create_popup("invite_broken", "invite_error", "restart_as_server", "menu_accept")

		arg_28_0._wanted_state = StateTitleScreen
		arg_28_0._has_invitation_error = false
	end

	if script_data.debug_enabled then
		VisualAssertLog.update(arg_28_1)
	end

	Managers.backend:update(arg_28_1, arg_28_2)
	Managers.input:update(arg_28_1)
	var_28_0:update(arg_28_1)

	local var_28_2 = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if arg_28_0._should_start_breed_loading and var_28_0:all_packages_loaded() and var_28_0.enemy_package_loader:matching_session(arg_28_0._network_server or arg_28_0._network_client) and var_28_2 and (not var_28_2.is_host or var_28_2:network_initialized()) then
		local var_28_3 = Managers.weave:get_next_weave() or Development.parameter("weave_name")
		local var_28_4 = Managers.weave:get_next_objective() or 1
		local var_28_5 = WeaveSettings.templates[var_28_3]
		local var_28_6 = var_28_0:get_current_level_key()
		local var_28_7 = LevelSettings[var_28_6].hub_level

		if var_28_5 and not var_28_7 then
			ConflictUtils.patch_terror_events_with_weaves(var_28_6, var_28_5, var_28_4)
		end

		if arg_28_0._network_server then
			local var_28_8 = var_28_0:get_current_level_seed()
			local var_28_9 = var_28_0:get_current_locked_director_functions()
			local var_28_10 = var_28_0:get_current_conflict_director()
			local var_28_11 = var_28_0:get_current_difficulty()
			local var_28_12 = var_28_0:get_current_difficulty_tweak()
			local var_28_13 = Managers.mechanism:uses_random_directors()

			var_28_0.enemy_package_loader:setup_startup_enemies(var_28_6, var_28_8, var_28_9, var_28_13, var_28_10, var_28_11, var_28_12)
		end

		arg_28_0._should_start_breed_loading = nil
	end

	Managers.music:update(arg_28_1, arg_28_2)

	if Managers.voice_chat then
		Managers.voice_chat:update(arg_28_1, arg_28_2)
	end

	if arg_28_0._level_end_view_wrappers then
		local var_28_14 = arg_28_0._level_end_view_wrappers[1]

		var_28_14:update(arg_28_1, arg_28_2)

		if var_28_14:done() then
			if var_28_14:do_retry() then
				arg_28_0._wanted_state = StateLoading
				arg_28_0._do_reload = true
			end

			arg_28_0:_tear_down_level_end_view_wrappers()
			Managers.weave:clear_weave_data()
		end
	elseif arg_28_0._first_time_view then
		arg_28_0._first_time_view:update(arg_28_1, arg_28_2)
	elseif arg_28_0._loading_view and not arg_28_0._do_reload then
		if arg_28_0._activate_loading_view then
			arg_28_0._loading_view:activate()
			Managers.transition:fade_out(GameSettings.transition_fade_out_speed)

			arg_28_0._activate_loading_view = nil
		end

		arg_28_0._loading_view:update(arg_28_1)
	end

	arg_28_0:_update_loading_screen(arg_28_1, arg_28_2)
	arg_28_0._machine:update(arg_28_1, arg_28_2)
	arg_28_0:_update_lobbies(arg_28_1, arg_28_2)

	if Managers.matchmaking then
		Managers.matchmaking:update(arg_28_1, arg_28_2)
	end

	if Managers.game_server then
		Managers.game_server:update(arg_28_1, arg_28_2)
	end

	if Managers.eac ~= nil then
		Managers.eac:update(arg_28_1, arg_28_2)
	end

	local var_28_15 = false
	local var_28_16

	if arg_28_0._level_end_view_wrappers then
		local var_28_17 = arg_28_0._level_end_view_wrappers[1]

		if var_28_17:enable_chat() then
			var_28_15 = true
			var_28_16 = var_28_17:active_input_service()
		end
	end

	Managers.chat:update(arg_28_1, arg_28_2, var_28_15, var_28_16)
	Network.update_transmit(arg_28_1)

	return arg_28_0:_try_next_state(arg_28_1)
end

function StateLoading._update_network(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_0._network_server then
		arg_29_0._network_server:update(arg_29_1, arg_29_2)

		if arg_29_0._network_server:disconnected() and not arg_29_0._popup_id then
			local var_29_0 = arg_29_0:_get_lost_connection_text_id()

			arg_29_0:create_popup(var_29_0, "popup_error_topic", "restart_as_server", "menu_accept")
			arg_29_0:_destroy_network_handler(false)
			arg_29_0:_destroy_lobby_host()
		end
	elseif arg_29_0._network_client then
		arg_29_0._network_client:update(arg_29_1, arg_29_2)

		if arg_29_0._network_client:is_in_post_game() and not arg_29_0._in_post_game_popup_id and not arg_29_0._in_post_game_popup_shown then
			arg_29_0._in_post_game_popup_id = Managers.popup:queue_popup(Localize("popup_is_in_post_game"), Localize("matchmaking_status_waiting_for_host"), "return_to_inn", Localize("return_to_inn"))
			arg_29_0._in_post_game_popup_shown = true

			Managers.popup:activate_timer(arg_29_0._in_post_game_popup_id, 200, "timeout", "center", false, function(arg_30_0)
				return string.format(Localize("timer_max_time") .. ": %.2d:%.2d", arg_30_0 / 60 % 60, arg_30_0 % 60)
			end, 28)
		elseif not arg_29_0._network_client:is_in_post_game() and arg_29_0._in_post_game_popup_id then
			Managers.popup:cancel_popup(arg_29_0._in_post_game_popup_id)

			arg_29_0._in_post_game_popup_id = nil
		end

		local var_29_1, var_29_2 = arg_29_0._network_client:has_bad_state()

		if var_29_1 and not arg_29_0._popup_id then
			print("bad_state:", var_29_2)

			arg_29_0._wanted_state = StateTitleScreen

			if arg_29_0._in_post_game_popup_id then
				Managers.popup:cancel_popup(arg_29_0._in_post_game_popup_id)

				arg_29_0._in_post_game_popup_id = nil
			end

			local var_29_3 = arg_29_0._network_client.fail_reason or "broken_connection"

			arg_29_0:_destroy_network_handler(false)

			if Managers.lobby:query_lobby("matchmaking_session_lobby") then
				arg_29_0:create_popup(var_29_3, "popup_error_topic", "restart_as_server", "menu_accept")
				arg_29_0:_destroy_lobby_client()
			end
		end
	end
end

function StateLoading._get_lost_connection_text_id(arg_31_0)
	local var_31_0

	return (IS_WINDOWS or IS_LINUX) and (rawget(_G, "Steam") and "failure_start_no_steam" or "broken_connection") or IS_XB1 and (not Network.xboxlive_client_exists() and "failure_start_xbox_live_client" or "failure_start_xbox_lobby_create") or IS_PS4 and "failure_psn_client_error" or "failure_start"
end

function StateLoading._update_lobbies(arg_32_0, arg_32_1, arg_32_2)
	if not arg_32_0:_update_loading_global_packages() then
		return
	end

	if arg_32_0._network_transmit then
		arg_32_0._network_transmit:transmit_local_rpcs()
	end

	if arg_32_0._password_request ~= nil then
		arg_32_0._password_request:update(arg_32_1)

		local var_32_0, var_32_1, var_32_2 = arg_32_0._password_request:result()

		if var_32_0 ~= nil then
			if var_32_0 == "join" then
				Managers.lobby:make_lobby(GameServerLobbyClient, "matchmaking_join_lobby", "StateLoading (GameServerLobbyClient)", var_32_1.network_options, var_32_1.game_server_data, var_32_2)
			else
				arg_32_0._teardown_network = true
				arg_32_0._permission_to_go_to_next_state = true
				arg_32_0._wanted_state = StateTitleScreen
			end

			arg_32_0._password_request:destroy()

			arg_32_0._password_request = nil
		end
	end

	local var_32_3 = Managers.lobby:query_lobby("matchmaking_session_lobby")
	local var_32_4 = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if var_32_3 and var_32_3.is_host then
		var_32_3:update(arg_32_1)

		if var_32_3:is_joined() and not var_32_3:network_initialized() and var_32_3:lobby_host() ~= "0" then
			if not arg_32_0._network_server then
				arg_32_0:host_joined()
			end

			local var_32_5 = Network.peer_id()
			local var_32_6 = var_32_3:lobby_host()
			local var_32_7 = true
			local var_32_8 = arg_32_0._network_server

			assert(var_32_6 == var_32_5, "Is not host of own lobby")
			arg_32_0:setup_chat_manager(var_32_3, var_32_6, var_32_5, var_32_7)
			arg_32_0:setup_deed_manager(var_32_3, var_32_6, var_32_5, var_32_7, var_32_8)
			arg_32_0:setup_enemy_package_loader(var_32_3, var_32_6, var_32_5, var_32_8)
			arg_32_0:setup_global_managers(var_32_3, var_32_6, var_32_5, var_32_7, var_32_8)
			var_32_3:set_network_initialized(true)
		elseif var_32_3.state == LobbyState.FAILED and not arg_32_0._popup_id then
			local var_32_9
			local var_32_10 = (IS_WINDOWS or IS_LINUX) and (rawget(_G, "Steam") and (Steam.connected() and "failure_start_steam_lobby_create" or "failure_start_no_steam") or "failure_start_no_lan") or IS_XB1 and (not Network.xboxlive_client_exists() and "failure_start_xbox_live_client" or "failure_start_xbox_lobby_create") or IS_PS4 and "failure_start_psn_lobby_create" or "failure_start"

			if arg_32_0._network_server then
				arg_32_0._network_server:disconnect_all_peers("unknown_error")
				arg_32_0:_destroy_network_handler(false)
			end

			arg_32_0:_destroy_lobby_host()
			arg_32_0:create_popup(var_32_10, "popup_error_topic", "restart_as_server", "menu_accept")
		end
	elseif arg_32_0._lobby_finder then
		arg_32_0:_update_lobby_join(arg_32_1, arg_32_2)
	elseif var_32_4 then
		arg_32_0:_update_server_lobby_join(arg_32_1, arg_32_2)
	elseif var_32_3 then
		var_32_3:update(arg_32_1)

		local var_32_11 = var_32_3.state

		if not arg_32_0._lobby_verified and var_32_3:is_joined() then
			arg_32_0:_verify_joined_lobby(arg_32_1, arg_32_2)
		elseif var_32_3:failed() and not arg_32_0._popup_id then
			arg_32_0:_destroy_lobby_client()
			arg_32_0:create_popup("failure_start_join_server", "popup_error_topic", "restart_as_server", "menu_accept")
			Managers.transition:fade_out(GameSettings.transition_fade_out_speed)
		end
	end

	if IS_XB1 and arg_32_0._waiting_for_cleanup and Managers.account:all_sessions_cleaned_up() and arg_32_2 > arg_32_0._cleanup_wait_time then
		arg_32_0._cleanup_done_func()

		arg_32_0._waiting_for_cleanup = nil
		arg_32_0._cleanup_done_func = nil
	end
end

function StateLoading._verify_joined_lobby(arg_33_0, arg_33_1, arg_33_2)
	if IS_XB1 and not arg_33_0:_update_xbox_lobby_data(arg_33_1, arg_33_2) then
		return
	end

	local var_33_0 = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local var_33_1 = var_33_0:lobby_host()
	local var_33_2 = var_33_0:get_stored_lobby_data()
	local var_33_3 = var_33_2.id
	local var_33_4 = var_33_2.network_hash
	local var_33_5 = var_33_2.matchmaking_type
	local var_33_6 = var_33_2.difficulty
	local var_33_7 = var_33_2.mechanism
	local var_33_8 = var_33_2.weave_quick_game
	local var_33_9 = MatchmakingManager.is_lobby_private(var_33_2)

	if var_33_3 then
		var_33_4 = LobbyInternal.get_lobby_data_from_id_by_key(var_33_3, "network_hash") or var_33_4
		var_33_5 = LobbyInternal.get_lobby_data_from_id_by_key(var_33_3, "matchmaking_type") or var_33_5
		var_33_6 = LobbyInternal.get_lobby_data_from_id_by_key(var_33_3, "difficulty") or var_33_6
		var_33_7 = LobbyInternal.get_lobby_data_from_id_by_key(var_33_3, "mechanism") or var_33_7
		var_33_8 = LobbyInternal.get_lobby_data_from_id_by_key(var_33_3, "weave_quick_game") or var_33_8
		var_33_9 = LobbyInternal.get_lobby_data_from_id_by_key(var_33_3, "is_private") == "true" or var_33_9
	end

	var_33_4 = var_33_4 or var_33_0:lobby_data("network_hash")
	var_33_5 = var_33_5 or var_33_0:lobby_data("matchmaking_type")
	var_33_6 = var_33_6 or var_33_0:lobby_data("difficulty")
	var_33_7 = var_33_7 or var_33_0:lobby_data("mechanism")
	var_33_8 = var_33_8 or var_33_0:lobby_data("weave_quick_game")
	var_33_9 = var_33_9 or var_33_0:lobby_data("is_private") == "true"

	local var_33_10 = IS_PS4 and var_33_5 or var_33_5 and NetworkLookup.game_modes[tonumber(var_33_5)]

	if var_33_1 ~= "0" and var_33_4 and var_33_10 and var_33_6 and arg_33_0._popup_id == nil then
		local var_33_11 = var_33_0.network_hash
		local var_33_12 = true
		local var_33_13 = {}
		local var_33_14 = MechanismSettings[var_33_7] or {}

		if var_33_14.required_dlc then
			var_33_13[var_33_14.required_dlc] = true
		end

		for iter_33_0, iter_33_1 in pairs(var_33_13) do
			if not Managers.unlock:is_dlc_unlocked(iter_33_0) then
				var_33_12 = false

				break
			end
		end

		local var_33_15 = true

		if not script_data.unlock_all_levels and var_33_14.extra_requirements_function and not var_33_14.extra_requirements_function() then
			var_33_15 = false
		end

		local var_33_16 = true
		local var_33_17 = ""

		if not Development.parameter("unlock_all_difficulties") and not var_33_9 and not var_33_14.disable_difficulty_check then
			local var_33_18 = BulldozerPlayer.best_aquired_power_level()
			local var_33_19 = DifficultySettings[var_33_6]

			if var_33_18 < var_33_19.required_power_level then
				var_33_16 = false

				local var_33_20 = Localize("required_power_level")

				var_33_17 = string.format("* %s: %s", var_33_20, tostring(UIUtils.presentable_hero_power_level(var_33_19.required_power_level)))
			end

			if var_33_19.extra_requirement_name then
				local var_33_21 = true
				local var_33_22 = ExtraDifficultyRequirements[var_33_19.extra_requirement_name]

				if not var_33_22.requirement_function(var_33_21) and var_33_8 ~= "true" then
					var_33_16 = false
					var_33_17 = var_33_17 .. string.format("\n* %s", Localize(var_33_22.description_text))
				end
			end
		end

		if not var_33_12 then
			arg_33_0:_destroy_lobby_client()
			arg_33_0:create_popup("failure_start_join_server_required_dlc_missing", "popup_error_topic", "restart_as_server", "menu_accept")
		elseif not var_33_15 then
			arg_33_0:_destroy_lobby_client()
			arg_33_0:create_popup("failure_start_join_server_game_mode_requirements_failed", "popup_error_topic", "restart_as_server", "menu_accept")
		elseif not var_33_16 then
			arg_33_0:_destroy_lobby_client()

			local var_33_23 = "failure_start_join_server_difficulty_requirements_failed"

			arg_33_0:create_popup(var_33_23, "popup_error_topic", "restart_as_server", "menu_accept", var_33_17)
		elseif var_33_11 == var_33_4 or Development.parameter("force_ignore_network_hash") then
			if arg_33_0._handle_new_lobby_connection then
				arg_33_0:setup_network_client(arg_33_0._joined_matchmaking_lobby)

				local var_33_24 = Network.peer_id()
				local var_33_25 = false
				local var_33_26 = arg_33_0._network_client

				assert(var_33_1 ~= var_33_24, "Is host of someone elses lobby")
				arg_33_0:setup_chat_manager(var_33_0, var_33_1, var_33_24, var_33_25)
				arg_33_0:setup_deed_manager(var_33_0, var_33_1, var_33_24, var_33_25, var_33_26)
				arg_33_0:setup_enemy_package_loader(var_33_0, var_33_1, var_33_24, var_33_26)
				arg_33_0:setup_global_managers(var_33_0, var_33_1, var_33_24, var_33_25, var_33_26)
			end
		else
			arg_33_0:_destroy_lobby_client()
			arg_33_0:create_popup("failure_start_join_server_incorrect_hash", "popup_error_topic", "restart_as_server", "menu_accept", var_33_11, var_33_4)
		end

		arg_33_0._lobby_verified = true
	elseif IS_XB1 then
		arg_33_0._xbox_lobby_data_state = "SET_COOLDOWN"
	end
end

local var_0_5 = 4

function StateLoading._update_xbox_lobby_data(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0._xbox_lobby_data_state

	if var_34_0 == "SET_COOLDOWN" then
		arg_34_0._xbox_lobby_cooldown = arg_34_2 + var_0_5
		var_34_0 = "WAIT_FOR_COOLDOWN"
	elseif var_34_0 == "WAIT_FOR_COOLDOWN" then
		if arg_34_2 > arg_34_0._xbox_lobby_cooldown then
			var_34_0 = "UPDATE_LOBBY_DATA"
		end
	elseif var_34_0 == "UPDATE_LOBBY_DATA" then
		Managers.lobby:get_lobby("matchmaking_session_lobby"):force_update_lobby_data()

		var_34_0 = "WAIT_FOR_LOBBY_UPDATE"
	elseif var_34_0 == "WAIT_FOR_LOBBY_UPDATE" and not Managers.lobby:get_lobby("matchmaking_session_lobby"):is_updating_lobby_data() then
		var_34_0 = "DONE"
	end

	arg_34_0._xbox_lobby_data_state = var_34_0 or "DONE"

	return var_34_0 == "DONE"
end

function StateLoading.lobby_verified(arg_35_0)
	return arg_35_0._lobby_verified
end

function StateLoading._destroy_lobby_client(arg_36_0)
	Managers.lobby:destroy_lobby("matchmaking_session_lobby")
	Managers.account:set_current_lobby(nil)

	if arg_36_0._voip then
		arg_36_0._voip:destroy()

		arg_36_0._voip = nil
	end

	if arg_36_0._level_end_view_wrappers then
		for iter_36_0, iter_36_1 in ipairs(arg_36_0._level_end_view_wrappers) do
			iter_36_1:left_lobby()
		end
	end

	arg_36_0._wanted_state = StateTitleScreen
end

function StateLoading._destroy_lobby_host(arg_37_0)
	Managers.lobby:destroy_lobby("matchmaking_session_lobby")
	Managers.account:set_current_lobby(nil)

	if Managers.matchmaking then
		if arg_37_0._registered_rpcs then
			Managers.matchmaking:unregister_rpcs()
		end

		Managers.matchmaking:destroy()

		Managers.matchmaking = nil
	end

	arg_37_0._wanted_state = StateTitleScreen
end

function StateLoading._update_lobby_join(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = Development.parameter("unique_server_name")
	local var_38_1 = false
	local var_38_2 = arg_38_0._lobby_finder

	var_38_2:update(arg_38_1)

	local var_38_3 = var_38_2:lobbies()

	for iter_38_0, iter_38_1 in ipairs(var_38_3) do
		local var_38_4 = false

		if not arg_38_0._lobby_to_join and not arg_38_0._host_to_join and var_38_0 and iter_38_1.unique_server_name == var_38_0 then
			var_38_4 = true
		elseif arg_38_0._lobby_to_join and arg_38_0._lobby_to_join == iter_38_1.id then
			var_38_4 = true
		elseif arg_38_0._host_to_join and arg_38_0._host_to_join == iter_38_1.host then
			var_38_4 = true
		end

		if iter_38_1.valid and var_38_4 then
			print("=======================Autojoining this lobby")

			local var_38_5 = LobbySetup.network_options()
			local var_38_6 = Managers.lobby:make_lobby(LobbyClient, "matchmaking_session_lobby", "StateLoading (_update_lobby_join)", var_38_5, iter_38_1)

			arg_38_0._lobby_finder:destroy()

			arg_38_0._lobby_finder = nil
			arg_38_0._handle_new_lobby_connection = true
			var_38_1 = true

			Managers.account:set_current_lobby(var_38_6.lobby)

			if arg_38_0._lobby_joined_callback then
				arg_38_0._lobby_joined_callback()

				arg_38_0._lobby_joined_callback = nil
			end

			break
		end
	end

	if not var_38_1 and arg_38_2 > arg_38_0._lobby_finder_timeout and not arg_38_0._popup_id then
		arg_38_0._lobby_finder:destroy()

		arg_38_0._lobby_finder = nil

		local var_38_7 = arg_38_0._host_to_join_name or Development.parameter("unique_server_name")

		arg_38_0:create_popup("failure_start_join_server_timeout", "failure_find_host", "restart_as_server", "menu_accept", var_38_7)

		arg_38_0._wanted_state = StateTitleScreen
	end

	if arg_38_0._lobby_finder and not var_38_1 and arg_38_2 > arg_38_0._lobby_finder_refresh_timer then
		printf("=======================Refresh lobby_finder search")
		arg_38_0._lobby_finder:refresh()

		arg_38_0._lobby_finder_refresh_timer = arg_38_2 + StateLoading.join_lobby_refresh_interval
	end
end

function StateLoading._update_server_lobby_join(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = Managers.lobby:get_lobby("matchmaking_join_lobby")

	var_39_0:update(arg_39_1)

	if var_39_0:is_joined() then
		Managers.lobby:move_lobby("matchmaking_join_lobby", "matchmaking_session_lobby")

		arg_39_0._handle_new_lobby_connection = true

		Managers.account:set_current_lobby(var_39_0.lobby)

		if arg_39_0._lobby_joined_callback then
			arg_39_0._lobby_joined_callback()

			arg_39_0._lobby_joined_callback = nil
		end

		return
	elseif var_39_0:failed() then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
		arg_39_0:create_popup("failure_start_join_server", "popup_error_topic", "restart_as_server", "menu_accept")
		Managers.transition:fade_out(GameSettings.transition_fade_out_speed)

		arg_39_0._wanted_state = StateTitleScreen

		return
	end

	if arg_39_2 > arg_39_0._lobby_finder_timeout and not arg_39_0._popup_id then
		local var_39_1 = var_39_0:id()

		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
		arg_39_0:create_popup("failure_start_join_server_timeout", "failure_find_host", "restart_as_server", "menu_accept", var_39_1)

		arg_39_0._wanted_state = StateTitleScreen
	end
end

function StateLoading._update_loading_screen(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0

	if arg_40_0._network_server then
		if Managers.lobby:get_lobby("matchmaking_session_lobby"):is_joined() and arg_40_0._network_server:waiting_to_enter_game() then
			var_40_0 = true
		end
	elseif arg_40_0._network_client and arg_40_0._network_client.state == NetworkClientStates.waiting_enter_game then
		var_40_0 = true
	end

	local var_40_1 = false

	if script_data.subtitle_debug and not DEDICATED_SERVER then
		var_40_1 = not (Mouse.button(Mouse.button_index("left")) == 1 and Mouse.button(Mouse.button_index("right")) == 1)

		if var_40_0 and var_40_1 then
			Debug.text("[SubtitleDebug] Waiting for both mouse buttons to progress...")
		end
	end

	local var_40_2 = Managers.level_transition_handler:get_current_level_keys()

	if var_40_0 and not arg_40_0._permission_to_go_to_next_state and not var_40_1 and var_40_2 then
		local var_40_3 = NetworkLookup.level_keys[var_40_2]

		if arg_40_0._network_server then
			arg_40_0._network_server.network_transmit:send_rpc("rpc_level_loaded", Network.peer_id(), var_40_3)
		end

		Managers.mechanism:load_packages()

		arg_40_0._permission_to_go_to_next_state = var_40_0
	end
end

function StateLoading._try_next_state(arg_41_0, arg_41_1)
	if arg_41_0._popup_id then
		arg_41_0:_handle_popup()
	end

	if arg_41_0._join_popup_id then
		arg_41_0:_handle_join_popup()
	end

	if arg_41_0._in_post_game_popup_id and not Managers.account:leaving_game() then
		arg_41_0:_handle_in_post_game_popup()
	elseif arg_41_0._in_post_game_popup_id then
		Managers.popup:cancel_popup(arg_41_0._in_post_game_popup_id)
	end

	if script_data.honduras_demo and Managers.time:get_demo_transition() then
		arg_41_0._teardown_network = true
		arg_41_0._join_popup_id = nil
		arg_41_0._permission_to_go_to_next_state = true

		if arg_41_0._first_time_view then
			arg_41_0._first_time_view:force_done()
		end

		arg_41_0._new_state = StateTitleScreen
	end

	if Managers.account:leaving_game() then
		if not arg_41_0._ui_package_name or arg_41_0._ui_package_name and Managers.package:has_loaded(arg_41_0._ui_package_name) then
			if arg_41_0._first_time_view then
				arg_41_0._first_time_view:destroy()

				arg_41_0._first_time_view = nil
			end

			Managers.transition:show_loading_icon()

			Managers.transition._callback = nil

			Managers.transition:force_fade_in()

			arg_41_0._teardown_network = true
			arg_41_0._new_state = StateTitleScreen
		end
	elseif arg_41_0.offline_invite then
		arg_41_0._teardown_network = true
		arg_41_0._join_popup_id = nil
		arg_41_0._permission_to_go_to_next_state = true

		if arg_41_0._first_time_view then
			arg_41_0._first_time_view:force_done()
		end

		arg_41_0._new_state = StateTitleScreen
	elseif not arg_41_0._transitioning then
		local var_41_0 = true

		if arg_41_0._first_time_view then
			var_41_0 = arg_41_0._first_time_view:is_done()

			if var_41_0 and not arg_41_0._popup_id and not arg_41_0:_packages_loaded() and arg_41_0._level_key then
				arg_41_0:_trigger_loading_view(arg_41_0._level_key)
				Managers.transition:show_loading_icon()
				arg_41_0._first_time_view:destroy()

				arg_41_0._first_time_view = nil

				Managers.chat:enable_gui(true)
			end
		elseif arg_41_0._loading_view then
			var_41_0 = arg_41_0._loading_view:is_done()
		end

		if arg_41_0._level_end_view_wrappers then
			var_41_0 = arg_41_0:_level_end_view_done()
		end

		local var_41_1 = Managers.backend

		if var_41_1:is_disconnected() and not arg_41_0._popup_id then
			arg_41_0:_backend_broken()
		end

		if var_41_1:is_waiting_for_user_input() then
			return
		end

		local var_41_2 = arg_41_0:_packages_loaded()

		if var_41_2 and not arg_41_0._async_level_spawner then
			local var_41_3 = Managers.level_transition_handler
			local var_41_4 = LevelHelper.INGAME_WORLD_NAME
			local var_41_5 = var_41_3:get_current_level_keys()
			local var_41_6 = LevelSettings[var_41_5].level_name

			printf("Starting async level spawning of %s", var_41_6)

			local var_41_7 = var_41_3:get_current_game_mode()
			local var_41_8, var_41_9 = GameModeHelper.get_object_sets(var_41_6, var_41_7)
			local var_41_10 = 0.02

			arg_41_0._async_level_spawner = AsyncLevelSpawner:new(var_41_4, var_41_6, var_41_9, var_41_10)
		end

		if arg_41_0._async_level_spawner and not arg_41_0._level_spawned then
			local var_41_11, var_41_12, var_41_13 = arg_41_0._async_level_spawner:update()

			if var_41_11 then
				print("Async level spawning done")

				arg_41_0._level_spawned = true
				arg_41_0._ingame_world_object = var_41_12
				arg_41_0._ingame_level_object = var_41_13

				Level.set_data(var_41_13, "intro_wwise_id", arg_41_0.wwise_playing_id or WwiseUtils.EVENT_ID_NONE)
				print("Spawn additional sub_levels:")

				local var_41_14 = Managers.level_transition_handler
				local var_41_15 = var_41_14:get_current_level_keys()
				local var_41_16 = LevelSettings[var_41_15].hero_specific_sublevels

				if var_41_16 then
					local var_41_17 = var_41_16[var_41_14.selected_hero_name_on_load]

					if var_41_17 and #var_41_17 > 0 then
						local var_41_18 = var_41_14:get_current_game_mode()
						local var_41_19 = {}

						for iter_41_0 = 1, #var_41_17 do
							local var_41_20 = var_41_17[iter_41_0]
							local var_41_21, var_41_22 = GameModeHelper.get_object_sets(var_41_20, var_41_18)
							local var_41_23 = ScriptWorld.spawn_level(var_41_12, var_41_20, var_41_22)

							Level.set_data(var_41_23, "parent_level", var_41_13)

							var_41_19[var_41_20] = var_41_23

							print(var_41_20)
						end

						Level.set_data(var_41_13, "sub_levels", var_41_19)
					end
				end
			end
		end

		if arg_41_0._wanted_state and var_41_0 and not arg_41_0._popup_id then
			local var_41_24 = arg_41_0._permission_to_go_to_next_state and var_41_2 and arg_41_0._level_spawned
			local var_41_25 = var_41_1:is_disconnected()

			if var_41_24 or var_41_25 or arg_41_0._teardown_network then
				local var_41_26

				if script_data.honduras_demo then
					var_41_26 = false

					if not arg_41_0._loading_view:showing_press_to_continue() and not arg_41_0._press_to_continue_shown then
						arg_41_0._loading_view:show_press_to_continue(true)

						arg_41_0._press_to_continue_shown = true

						Managers.transition:hide_loading_icon()
					else
						local var_41_27 = Managers.input:get_most_recent_device().any_pressed()

						arg_41_0._demo_continue_pressed = arg_41_0._demo_continue_pressed or var_41_27
						var_41_26 = arg_41_0._demo_continue_pressed

						if var_41_26 and arg_41_0._loading_view:showing_press_to_continue() then
							arg_41_0._loading_view:show_press_to_continue(false)
							Managers.transition:show_loading_icon()
						end
					end
				elseif GameSettingsDevelopment.use_global_chat then
					var_41_26 = Irc.is_connected()
				else
					var_41_26 = true
				end

				if var_41_26 then
					local var_41_28 = arg_41_0._level_end_view_wrappers

					if not var_41_28 and Managers.transition:fade_state() == "out" then
						Managers.transition:fade_in(GameSettings.transition_fade_out_speed)
						printf("[StateLoading] started fadeing in, want to go to state:%s", arg_41_0._wanted_state.NAME)
					elseif var_41_28 or Managers.transition:fade_in_completed() then
						arg_41_0._new_state = arg_41_0._wanted_state

						printf("[StateLoading] fade_in_completed, new state:%s", arg_41_0._new_state.NAME)

						if arg_41_0._join_popup_id then
							Managers.popup:cancel_popup(arg_41_0._join_popup_id)

							arg_41_0._join_popup_id = nil
						end
					end
				end
			end
		end
	end

	if IS_CONSOLE then
		arg_41_0:_handle_afk_timer(arg_41_1)
	end

	if (Managers.popup:has_popup() or Managers.account:user_detached() or Managers.account:has_popup()) and not Managers.account:leaving_game() then
		return
	end

	Managers.popup:cancel_all_popups()

	return arg_41_0._new_state
end

function StateLoading._handle_afk_timer(arg_42_0, arg_42_1)
	if Managers.account:leaving_game() then
		return
	end

	if Managers.account:has_popup() or arg_42_0._popup_id then
		local var_42_0 = Managers.time:time("main")

		arg_42_0._afk_timer = arg_42_0._afk_timer or var_42_0 + var_0_2

		if var_42_0 > arg_42_0._afk_timer and (not arg_42_0._ui_package_name or arg_42_0._ui_package_name and Managers.package:has_loaded(arg_42_0._ui_package_name)) then
			if arg_42_0._first_time_view then
				arg_42_0._first_time_view:destroy()

				arg_42_0._first_time_view = nil
			end

			Managers.transition:show_loading_icon()

			Managers.transition._callback = nil

			Managers.transition:force_fade_in()

			arg_42_0._teardown_network = true
			arg_42_0._new_state = StateTitleScreen
			arg_42_0._previous_session_error = "afk_kick"

			Managers.account:initiate_leave_game()
		end
	elseif arg_42_0._afk_timer then
		arg_42_0._afk_timer = nil
	end
end

function StateLoading._level_end_view_done(arg_43_0)
	local var_43_0 = arg_43_0._level_end_view_wrappers[1]

	return var_43_0 and var_43_0:done()
end

function StateLoading._handle_popup(arg_44_0)
	local var_44_0 = Managers.popup:query_result(arg_44_0._popup_id)

	if var_44_0 == "continue" then
		arg_44_0._popup_id = nil
	elseif var_44_0 == "restart_as_server" then
		arg_44_0._teardown_network = true
		arg_44_0._popup_id = nil
		arg_44_0._permission_to_go_to_next_state = true

		if arg_44_0._first_time_view then
			arg_44_0._first_time_view:force_done()
		end
	elseif var_44_0 == "quit" then
		Boot.quit_game = true
		arg_44_0._teardown_network = true
		arg_44_0._popup_id = nil
		arg_44_0._permission_to_go_to_next_state = true

		if arg_44_0._first_time_view then
			arg_44_0._first_time_view:force_done()
		end
	elseif var_44_0 then
		printf("[StateLoading:_handle_popup] No such result handled (%s)", var_44_0)
	end
end

function StateLoading._handle_join_popup(arg_45_0)
	local var_45_0 = Managers.popup:query_result(arg_45_0._join_popup_id)

	if var_45_0 == "cancel" or var_45_0 == "timeout" then
		Managers.popup:cancel_popup(arg_45_0._join_popup_id)

		arg_45_0._teardown_network = true
		arg_45_0._join_popup_id = nil
		arg_45_0._permission_to_go_to_next_state = true

		if arg_45_0._first_time_view then
			arg_45_0._first_time_view:force_done()
		end

		arg_45_0._new_state = StateTitleScreen
	elseif var_45_0 then
		printf("[StateLoading:_handle_join_popup] No such result handled (%s)", var_45_0)
	end
end

function StateLoading._handle_in_post_game_popup(arg_46_0)
	local var_46_0 = Managers.popup:query_result(arg_46_0._in_post_game_popup_id)

	if var_46_0 then
		if var_46_0 == "return_to_inn" then
			arg_46_0._teardown_network = true
			arg_46_0._restart_network = true
			arg_46_0._permission_to_go_to_next_state = true

			if arg_46_0._first_time_view then
				arg_46_0._first_time_view:force_done()
			end

			arg_46_0._wanted_state = StateLoading
		end

		arg_46_0._in_post_game_popup_id = nil
	end
end

function StateLoading._backend_broken(arg_47_0)
	print("[StateLoading] Backend_broken, returning to StateTitleScreen")

	arg_47_0._wanted_state = StateTitleScreen
	arg_47_0._teardown_network = true
	arg_47_0._permission_to_go_to_next_state = true

	if arg_47_0._first_time_view then
		arg_47_0._first_time_view:force_done()
	end

	if IS_XB1 then
		Managers.account:initiate_leave_game()
	end
end

function StateLoading.on_exit(arg_48_0, arg_48_1)
	Framerate.set_playing()

	if arg_48_0._registered_rpcs then
		arg_48_0:_unregister_rpcs()
	end

	if arg_48_0._password_request ~= nil then
		arg_48_0._password_request:destroy()

		arg_48_0._password_request = nil
	end

	arg_48_0._should_start_breed_loading = nil

	local var_48_0 = arg_48_0.parent.loading_context.skip_signin
	local var_48_1 = false

	if arg_48_1 or arg_48_0._teardown_network then
		arg_48_0:_destroy_network(arg_48_1)

		var_48_1 = true
	else
		local var_48_2 = {
			network_transmit = arg_48_0._network_transmit,
			checkpoint_data = arg_48_0._checkpoint_data,
			quickplay_bonus = arg_48_0._quickplay_bonus,
			level_end_view_wrappers = arg_48_0._level_end_view_wrappers,
			saved_scoreboard_stats = arg_48_0._saved_scoreboard_stats,
			host_migration_info = arg_48_0.parent.loading_context.host_migration_info
		}

		var_48_2.ingame_world_object, arg_48_0._ingame_world_object = arg_48_0._ingame_world_object, var_48_2.ingame_world_object
		var_48_2.ingame_level_object, arg_48_0._ingame_level_object = arg_48_0._ingame_level_object, var_48_2.ingame_level_object

		local var_48_3 = Managers.level_transition_handler
		local var_48_4 = Managers.lobby:get_lobby("matchmaking_session_lobby")

		if var_48_4.is_host then
			local var_48_5 = var_48_3:get_current_level_keys()
			local var_48_6 = var_48_4:get_stored_lobby_data() or {}

			var_48_6.mission_id = var_48_5
			var_48_6.unique_server_name = var_48_6.unique_server_name or LobbyAux.get_unique_server_name()
			var_48_6.host = var_48_6.host or Network.peer_id()
			var_48_6.num_players = var_48_6.num_players or 1
			var_48_6.country_code = Managers.account:region()

			local var_48_7

			if DEDICATED_SERVER then
				var_48_7 = NetworkLookup.host_types.community_dedicated_server
			else
				var_48_7 = NetworkLookup.host_types.player_hosted
			end

			var_48_6.host_type = var_48_7

			var_48_4:set_lobby_data(var_48_6)

			if var_48_4:is_dedicated_server() then
				var_48_4:set_level_name(Localize(LevelSettings[var_48_5].display_name))
			end

			var_48_2.network_server = arg_48_0._network_server

			arg_48_0._network_server:unregister_rpcs()
			arg_48_0._network_server.voip:set_input_manager(nil)
		else
			var_48_2.network_client = arg_48_0._network_client

			arg_48_0._network_client:unregister_rpcs()
			arg_48_0._network_client.voip:set_input_manager(nil)
		end

		if arg_48_0._do_reload then
			local var_48_8 = Managers.weave
			local var_48_9 = 1
			local var_48_10 = var_48_8:get_active_weave()
			local var_48_11 = WeaveSettings.templates[var_48_10].objectives[var_48_9].level_id
			local var_48_12 = 0
			local var_48_13 = Managers.mechanism:generate_level_seed()
			local var_48_14 = var_48_3:get_current_difficulty()
			local var_48_15 = var_48_3:get_current_difficulty_tweak()

			var_48_3:set_next_level(var_48_11, var_48_12, var_48_13, nil, nil, nil, var_48_14, var_48_15)
			var_48_3:promote_next_level_data()
		end

		var_48_2.show_profile_on_startup = arg_48_0.parent.loading_context.show_profile_on_startup
		arg_48_0.parent.loading_context = var_48_2
	end

	if arg_48_0._async_level_spawner then
		arg_48_0._async_level_spawner:destroy()

		arg_48_0._async_level_spawner = nil
	end

	if arg_48_0._ingame_level_object then
		ScriptWorld.trigger_level_shutdown(arg_48_0._ingame_level_object)
		ScriptWorld.destroy_level_from_reference(arg_48_0._ingame_world_object, arg_48_0._ingame_level_object)

		arg_48_0._ingame_level_object = nil
	end

	if arg_48_0._ingame_world_object then
		Managers.world:destroy_world(arg_48_0._ingame_world_object)

		arg_48_0._ingame_world_object = nil
	end

	arg_48_0._profile_synchronizer = nil

	if arg_48_0._network_event_delegate then
		arg_48_0._network_event_delegate:destroy()

		arg_48_0._network_event_delegate = nil
	end

	if arg_48_0._first_time_view then
		arg_48_0._first_time_view:destroy()

		arg_48_0._first_time_view = nil
	end

	if arg_48_0._loading_view then
		if arg_48_0.parent.loading_context then
			arg_48_0.parent.loading_context.subtitle_gui = arg_48_0._loading_view:subtitle_gui()
		end

		arg_48_0._loading_view:destroy()

		arg_48_0._loading_view = nil
	end

	arg_48_0:_tear_down_level_end_view_wrappers()
	arg_48_0._machine:destroy(arg_48_1)
	Managers.state:destroy()

	if arg_48_0.parent.loading_context then
		arg_48_0.parent.loading_context.host_to_migrate_to = nil
		arg_48_0.parent.loading_context.restart_network = nil
		arg_48_0.parent.loading_context.players = nil
		arg_48_0.parent.loading_context.local_player_index = nil
		arg_48_0.parent.loading_context.skip_signin = var_48_0
		arg_48_0.parent.loading_context.previous_session_error = arg_48_0._previous_session_error

		if arg_48_0._restart_network then
			arg_48_0.parent.loading_context.restart_network = true
		end
	end

	ScriptWorld.destroy_viewport(arg_48_0._world, arg_48_0._viewport_name)
	Managers.world:destroy_world(arg_48_0._world)

	local var_48_16 = Managers.package

	if arg_48_0._ui_package_name and (var_48_16:has_loaded(arg_48_0._ui_package_name, "global_loading_screens") or var_48_16:is_loading(arg_48_0._ui_package_name)) then
		var_48_16:unload(arg_48_0._ui_package_name, "global_loading_screens")
	end

	Managers.music:trigger_event("Stop_loading_screen_music")

	if IS_WINDOWS then
		fassert(arg_48_1 or arg_48_0._popup_id == nil, "StateLoading added a popup right before exiting")
	else
		Managers.popup:cancel_all_popups()
	end

	Managers.popup:remove_input_manager(arg_48_1)
	Managers.chat:set_input_manager(nil)
	Managers.chat:enable_gui(true)

	if not Managers.play_go:installed() then
		Managers.play_go:set_install_speed("slow")
	end

	if var_48_1 then
		Managers.level_transition_handler:release_level_resources()
	end
end

function StateLoading._update_loading_global_packages(arg_49_0)
	return (GlobalResources.update_loading())
end

function StateLoading._packages_loaded(arg_50_0)
	local var_50_0 = Managers.level_transition_handler

	if var_50_0:all_packages_loaded() and Managers.backend:profiles_loaded() then
		local var_50_1 = arg_50_0._network_server

		if not DEDICATED_SERVER and var_50_1 and not arg_50_0._has_sent_level_loaded then
			arg_50_0._has_sent_level_loaded = true

			local var_50_2 = var_50_0:get_current_level_keys()
			local var_50_3 = NetworkLookup.level_keys[var_50_2]

			var_50_1.network_transmit:send_rpc("rpc_level_loaded", Network.peer_id(), var_50_3)
		end

		local var_50_4 = Managers.package

		for iter_50_0, iter_50_1 in ipairs(GlobalResources) do
			if not var_50_4:has_loaded(iter_50_1) then
				return false
			end
		end

		if arg_50_0._should_start_breed_loading then
			return false
		end

		if not var_50_0.enemy_package_loader:loading_completed() then
			return false
		end

		if not var_50_0.pickup_package_loader:loading_completed() then
			return false
		end

		if not var_50_0.general_synced_package_loader:loading_completed() then
			return false
		end

		if not var_50_0.transient_package_loader:loading_completed() then
			return false
		end

		if arg_50_0:_update_loadout_resync() ~= StateLoading.LoadoutResyncStates.DONE then
			return false
		end

		if arg_50_0._ui_loading_package_path and arg_50_0._ui_loading_package_reference_name and not var_50_4:has_loaded(arg_50_0._ui_loading_package_path, arg_50_0._ui_loading_package_reference_name) then
			return false
		end

		if not Managers.mechanism:is_packages_loaded() then
			return false
		end

		return true
	end

	return false
end

function StateLoading.load_current_level(arg_51_0)
	print("[StateLoading] load_current_level")

	local var_51_0 = arg_51_0._already_loaded_once

	Managers.mechanism:handle_level_load(var_51_0)

	arg_51_0._already_loaded_once = true

	if arg_51_0._network_client then
		arg_51_0._network_client:set_state(NetworkClientStates.loading)
	end

	Managers.level_transition_handler:load_current_level()

	arg_51_0._should_start_breed_loading = true

	if arg_51_0._async_level_spawner then
		arg_51_0._async_level_spawner:destroy()

		arg_51_0._async_level_spawner = nil
	end

	if arg_51_0._ingame_level_object then
		ScriptWorld.destroy_level_from_reference(arg_51_0._ingame_world_object, arg_51_0._ingame_level_object)

		arg_51_0._ingame_level_object = nil
	end

	if arg_51_0._ingame_world_object then
		Managers.world:destroy_world(arg_51_0._ingame_world_object)

		arg_51_0._ingame_world_object = nil
	end

	arg_51_0._level_spawned = false
	arg_51_0._permission_to_go_to_next_state = false
	arg_51_0._has_sent_level_loaded = false

	arg_51_0:set_loadout_resync_state(StateLoading.LoadoutResyncStates.CHECK_RESYNC)
end

function StateLoading._update_loadout_resync(arg_52_0)
	local var_52_0 = arg_52_0:loadout_resync_state()
	local var_52_1 = StateLoading.LoadoutResyncStates

	if var_52_0 == var_52_1.IDLE then
		return var_52_0
	end

	if var_52_0 == var_52_1.WAIT_FOR_LEVEL_LOAD then
		-- block empty
	end

	if var_52_0 == var_52_1.CHECK_RESYNC and arg_52_0:has_joined() and Managers.mechanism:can_resync_loadout() and Managers.backend:is_mirror_ready() and not Managers.backend:is_pending_request() then
		local var_52_2 = Managers.level_transition_handler
		local var_52_3 = var_52_2:get_current_level_key()
		local var_52_4 = var_52_2:get_current_game_mode()

		Managers.backend:get_interface("items"):set_game_mode_specific_items(var_52_4)

		local var_52_5, var_52_6, var_52_7 = Managers.backend:set_loadout_interface_override(var_52_4)
		local var_52_8 = Managers.backend:set_talents_interface_override(var_52_4)

		var_52_5 = var_52_5 or var_52_8

		Managers.backend:get_interface("talents"):make_dirty()
		print("[StateLoading] loadout_changed:", var_52_5, "old_loadout:", var_52_6, "new_loadout:", var_52_7, "level_key:", var_52_3, "game_mode:", var_52_4)
		Managers.mechanism:update_loadout()

		if var_52_5 then
			var_52_0 = var_52_1.NEEDS_RESYNC

			print("[StateLoading] loadout_resync_state CHECK_RESYNC -> NEEDS_RESYNC")
		else
			var_52_0 = var_52_1.DONE

			print("[StateLoading] loadout_resync_state CHECK_RESYNC -> DONE")
		end
	end

	if var_52_0 == var_52_1.NEEDS_RESYNC then
		local var_52_9 = arg_52_0._network_server
		local var_52_10 = arg_52_0._network_client
		local var_52_11 = var_52_9 and var_52_9.profile_synchronizer or var_52_10 and var_52_10.profile_synchronizer

		if var_52_11 then
			local var_52_12 = Network.peer_id()
			local var_52_13 = 1
			local var_52_14 = false
			local var_52_15 = true

			var_52_11:resync_loadout(var_52_12, var_52_13, var_52_14, var_52_15)

			var_52_0 = var_52_1.RESYNCING

			print("[StateLoading] loadout_resync_state NEEDS_RESYNC -> RESYNCING")
		end
	end

	if var_52_0 == var_52_1.RESYNCING then
		local var_52_16 = arg_52_0._network_server
		local var_52_17 = arg_52_0._network_client
		local var_52_18 = var_52_16 and var_52_16.profile_synchronizer or var_52_17 and var_52_17.profile_synchronizer

		if var_52_18 and var_52_18:all_synced() then
			var_52_0 = var_52_1.DONE

			print("[StateLoading] loadout_resync_state RESYNCING -> DONE")
		end
	end

	if var_52_0 ~= arg_52_0:loadout_resync_state() then
		arg_52_0:set_loadout_resync_state(var_52_0)
	end

	return var_52_0
end

function StateLoading._destroy_network_handler(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_0._network_server or arg_53_0._network_client

	if arg_53_2 then
		var_53_0 = arg_53_2.network_server or arg_53_2.network_client
		arg_53_2.network_server = nil
		arg_53_2.network_client = nil
	else
		arg_53_0._network_server = nil
		arg_53_0._network_client = nil
	end

	if var_53_0 then
		local var_53_1 = Managers.level_transition_handler
		local var_53_2 = var_53_1.enemy_package_loader

		var_53_2:network_context_destroyed()

		if arg_53_1 then
			var_53_2:on_application_shutdown()
		end

		local var_53_3 = var_53_1.transient_package_loader

		var_53_3:network_context_destroyed()
		var_53_3:unload_all_packages()
		var_53_1.pickup_package_loader:network_context_destroyed()
		var_53_1.general_synced_package_loader:network_context_destroyed()
		Managers.party:network_context_destroyed()
		Managers.mechanism:network_context_destroyed()
		var_53_0:destroy()
	end
end

function StateLoading._destroy_network(arg_54_0, arg_54_1)
	PartyManager.reset()

	if Managers.matchmaking then
		Managers.matchmaking:destroy()

		Managers.matchmaking = nil
	end

	if arg_54_0._lobby_finder then
		arg_54_0._lobby_finder:destroy()

		arg_54_0._lobby_finder = nil
	end

	arg_54_0:_destroy_network_handler(arg_54_1)

	if Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	if Managers.lobby:query_lobby("matchmaking_session_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_session_lobby")
		Managers.account:set_current_lobby(nil)
	end

	if rawget(_G, "LobbyInternal") then
		if Managers.party:has_party_lobby() then
			local var_54_0 = Managers.party:steal_lobby()

			if type(var_54_0) ~= "table" then
				LobbyInternal.leave_lobby(var_54_0)
			end
		end

		LobbyInternal.shutdown_client()
	end

	Managers.chat:unregister_channel(1)
	Managers.mechanism:mechanism_try_call("unregister_chats")

	arg_54_0.parent.loading_context = {}

	if arg_54_0.offline_invite then
		arg_54_0.offline_invite = nil
		arg_54_0.parent.loading_context.offline_invite = true
	end

	if arg_54_0._network_transmit then
		arg_54_0._network_transmit:destroy()

		arg_54_0._network_transmit = nil
	end

	if arg_54_0._switch_to_tutorial_backend then
		Managers.backend:stop_tutorial()
	end
end

function StateLoading._tear_down_level_end_view_wrappers(arg_55_0)
	local var_55_0 = arg_55_0._level_end_view_wrappers

	if var_55_0 then
		for iter_55_0 = 1, #var_55_0 do
			var_55_0[iter_55_0]:destroy()
		end
	end

	arg_55_0._level_end_view_wrappers = nil
end

function StateLoading.set_matchmaking(arg_56_0, arg_56_1)
	arg_56_0._joined_matchmaking_lobby = arg_56_1
end

function StateLoading.has_registered_rpcs(arg_57_0)
	return arg_57_0._registered_rpcs
end

function StateLoading.register_rpcs(arg_58_0)
	local var_58_0 = NetworkEventDelegate:new()

	arg_58_0._network_event_delegate = var_58_0

	Managers.level_transition_handler:register_rpcs(var_58_0)
	Managers.mechanism:register_rpcs(var_58_0)
	Managers.party:register_rpcs(var_58_0)

	if Managers.matchmaking then
		Managers.matchmaking:register_rpcs(var_58_0)
		Managers.matchmaking:setup_post_init_data({})
	end

	Managers.chat:register_network_event_delegate(var_58_0)
	Managers.eac:register_network_event_delegate(var_58_0)

	if Managers.mod then
		Managers.mod:register_network_event_delegate(var_58_0)
	end

	Managers.deed:register_rpcs(var_58_0)

	if arg_58_0._level_end_view_wrappers then
		for iter_58_0, iter_58_1 in ipairs(arg_58_0._level_end_view_wrappers) do
			iter_58_1:register_rpcs(var_58_0)
		end
	end

	arg_58_0._registered_rpcs = true

	print("registering RPCs")
end

function StateLoading._unregister_rpcs(arg_59_0)
	Managers.level_transition_handler:unregister_rpcs()
	Managers.mechanism:unregister_rpcs()
	Managers.party:unregister_rpcs()

	if Managers.matchmaking then
		Managers.matchmaking:unregister_rpcs()
	end

	Managers.chat:unregister_network_event_delegate()
	Managers.eac:unregister_network_event_delegate()

	if Managers.mod then
		Managers.mod:unregister_network_event_delegate()
	end

	Managers.deed:unregister_rpcs()

	if arg_59_0._level_end_view_wrappers then
		for iter_59_0, iter_59_1 in ipairs(arg_59_0._level_end_view_wrappers) do
			iter_59_1:unregister_rpcs()
		end
	end

	arg_59_0._registered_rpcs = false
end

function StateLoading.waiting_for_cleanup(arg_60_0)
	return arg_60_0._waiting_for_cleanup
end

function StateLoading.setup_join_lobby(arg_61_0, arg_61_1, arg_61_2)
	if IS_XB1 and (not Managers.account:all_sessions_cleaned_up() or arg_61_1) then
		arg_61_0._waiting_for_cleanup = true
		arg_61_0._cleanup_done_func = callback(arg_61_0, "setup_join_lobby")
		arg_61_0._cleanup_wait_time = Managers.time:time("main") + (arg_61_1 or 0)

		return
	end

	local var_61_0 = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if not var_61_0 then
		local var_61_1 = LobbySetup.network_options()
		local var_61_2 = arg_61_0.parent.loading_context

		if var_61_2.join_lobby_data then
			var_61_0 = Managers.lobby:make_lobby(LobbyClient, "matchmaking_session_lobby", "StateLoading (setup_join_lobby)", var_61_1, arg_61_0.parent.loading_context.join_lobby_data)
		elseif var_61_2.join_server_data then
			local var_61_3 = {
				network_options = var_61_1,
				game_server_data = arg_61_0.parent.loading_context.join_server_data
			}

			arg_61_0._password_request = ServerJoinStateMachine:new(var_61_1, arg_61_0.parent.loading_context.join_server_data.server_info.ip_port, var_61_3)
		else
			ferror("no join lobby data")
		end

		arg_61_0.parent.loading_context.join_lobby_data = nil
		arg_61_0._handle_new_lobby_connection = true

		if var_61_0 ~= nil then
			Managers.account:set_current_lobby(var_61_0.lobby)
		end

		arg_61_0._lobby_finder_timeout = Managers.time:time("main") + StateLoading.join_lobby_timeout
	end

	if arg_61_2 then
		local var_61_4 = false

		arg_61_0._voip = Voip:new(var_61_4, var_61_0)
	end
end

function StateLoading.setup_lobby_finder(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	if Managers.package:is_loading("resource_packages/inventory", "global") then
		Managers.package:load("resource_packages/inventory", "global")
	end

	if Managers.package:is_loading("resource_packages/careers", "global") then
		Managers.package:load("resource_packages/careers", "global")
	end

	local var_62_0 = LobbySetup.network_options()

	if arg_62_4 then
		local var_62_1 = {
			server_info = {
				ip_port = arg_62_2
			}
		}
		local var_62_2 = {
			network_options = var_62_0,
			game_server_data = var_62_1
		}

		arg_62_0._password_request = ServerJoinStateMachine:new(var_62_0, var_62_1.server_info.ip_port, var_62_2)
	else
		arg_62_0._lobby_finder = LobbyFinder:new(var_62_0, nil, true)
		arg_62_0._lobby_to_join = arg_62_2
		arg_62_0._host_to_join = arg_62_3 and arg_62_3.peer_id
		arg_62_0._host_to_join_name = arg_62_3 and arg_62_3.name

		arg_62_0._lobby_finder:refresh()
		printf("[StateLoading] StateLoading will try to find a lobby with id=%s or host=%s or unique_server_name=%s", tostring(arg_62_2), tostring(arg_62_0._host_to_join), tostring(script_data.unique_server_name))
	end

	local var_62_3 = Managers.time:time("main")

	arg_62_0._lobby_joined_callback = arg_62_1
	arg_62_0._lobby_finder_timeout = var_62_3 + StateLoading.join_lobby_timeout
	arg_62_0._lobby_finder_refresh_timer = var_62_3 + StateLoading.join_lobby_refresh_interval

	local var_62_4 = arg_62_0.parent.loading_context
	local var_62_5 = var_62_4 and var_62_4.versus_migration

	if arg_62_3 and not var_62_5 then
		arg_62_0:create_join_popup(arg_62_0._host_to_join_name)
	end

	return arg_62_0._lobby_finder
end

function StateLoading.setup_lobby_host(arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
	if IS_XB1 and not Managers.account:all_sessions_cleaned_up() then
		arg_63_0._waiting_for_cleanup = true
		arg_63_0._cleanup_done_func = callback(arg_63_0, "setup_lobby_host", arg_63_1, arg_63_2, arg_63_3, arg_63_4)
		arg_63_0._cleanup_wait_time = 0

		return
	end

	local var_63_0 = arg_63_0.parent.loading_context

	assert(not var_63_0.profile_synchronizer)
	assert(not var_63_0.network_server)

	local var_63_1 = LobbySetup.network_options()
	local var_63_2 = table.tostring(var_63_1)
	local var_63_3 = type(arg_63_2) == "table" and table.tostring(arg_63_2) or tostring(arg_63_2)

	printf("StateLoading:setup_lobby_host - creating lobby_host with network_options: %s platform_lobby: %s", var_63_2, var_63_3)

	local var_63_4 = Managers.lobby:make_lobby(LobbyHost, "matchmaking_session_lobby", "StateLoading (setup_lobby_host)", var_63_1, arg_63_2, arg_63_3, arg_63_4)
	local var_63_5 = Managers.level_transition_handler

	if not var_63_5:has_next_level() then
		local var_63_6 = Managers.mechanism:default_level_key()
		local var_63_7 = rawget(LevelSettings, var_63_6)
		local var_63_8 = var_63_7 and var_63_7.conflict_settings

		var_63_5:set_next_level(var_63_6, nil, nil, nil, nil, var_63_8)
	end

	var_63_5:promote_next_level_data()

	local var_63_9 = var_63_5:get_current_level_key()

	if not arg_63_0:loading_view_setup_done() then
		arg_63_0:setup_loading_view(var_63_9)
	end

	if not arg_63_0:menu_assets_setup_done() then
		arg_63_0:setup_menu_assets()
	end

	arg_63_0:_update_loading_global_packages()

	if not arg_63_1 then
		arg_63_0:_create_network_server()
	end

	Managers.account:set_current_lobby(var_63_4.lobby)

	arg_63_0._waiting_for_joined_callback = arg_63_1
end

function StateLoading.host_joined(arg_64_0)
	arg_64_0:_create_network_server()

	if arg_64_0._waiting_for_joined_callback then
		arg_64_0._waiting_for_joined_callback()

		arg_64_0._waiting_for_joined_callback = nil
	end
end

function StateLoading._create_network_server(arg_65_0)
	local var_65_0 = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local var_65_1 = arg_65_0.parent.loading_context
	local var_65_2 = arg_65_0.parent.loading_context.wanted_profile_index

	arg_65_0._network_server = NetworkServer:new(Managers.player, var_65_0, var_65_2)
	arg_65_0._network_transmit = var_65_1.network_transmit or NetworkTransmit:new(true, arg_65_0._network_server.server_peer_id)

	arg_65_0._network_transmit:set_network_event_delegate(arg_65_0._network_event_delegate)
	arg_65_0._network_server:register_rpcs(arg_65_0._network_event_delegate, arg_65_0._network_transmit)
	arg_65_0._network_server:server_join()

	arg_65_0._profile_synchronizer = arg_65_0._network_server.profile_synchronizer

	arg_65_0._network_server.voip:set_input_manager(arg_65_0._input_manager)

	var_65_1.network_transmit = arg_65_0._network_transmit
end

function StateLoading.setup_chat_manager(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4)
	local var_66_0 = {
		is_server = arg_66_4,
		host_peer_id = arg_66_2,
		my_peer_id = arg_66_3
	}

	Managers.chat:setup_network_context(var_66_0)
	Managers.mechanism:mechanism_try_call("register_chats")

	local function var_66_1()
		if DEDICATED_SERVER and Managers.level_transition_handler:in_hub_level() then
			local var_67_0 = Managers.mechanism:game_mechanism()

			assert(DEDICATED_SERVER, "Mismanaged use of 'get_slot_reservation_handler'")

			return var_67_0:get_slot_reservation_handler(Network.peer_id(), var_0_0.session):reservers()
		end

		return arg_66_1:members():get_members()
	end

	Managers.chat:register_channel(1, var_66_1)
end

function StateLoading.setup_deed_manager(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5)
	Managers.deed:network_context_created(arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5)
end

function StateLoading.setup_enemy_package_loader(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	Managers.level_transition_handler.enemy_package_loader:network_context_created(arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	Managers.level_transition_handler.pickup_package_loader:network_context_created(arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	Managers.level_transition_handler.general_synced_package_loader:network_context_created(arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	Managers.level_transition_handler.transient_package_loader:network_context_created(arg_69_1, arg_69_2, arg_69_3)
end

function StateLoading.setup_global_managers(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5)
	Managers.mechanism:network_context_created(arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5)
	Managers.party:network_context_created(arg_70_1, arg_70_2, arg_70_3)

	if Managers.mod then
		Managers.mod:network_context_created(arg_70_2, arg_70_3, arg_70_4)
	end
end

function StateLoading.setup_network_transmit(arg_71_0, arg_71_1)
	local var_71_0 = arg_71_0._network_server and arg_71_0._network_server.server_peer_id or arg_71_0._network_client and arg_71_0._network_client.server_peer_id

	arg_71_0._network_transmit = arg_71_0.parent.loading_context.network_transmit or NetworkTransmit:new(true, var_71_0)

	arg_71_0._network_transmit:set_network_event_delegate(arg_71_0._network_event_delegate)
	arg_71_1:register_rpcs(arg_71_0._network_event_delegate, arg_71_0._network_transmit)

	arg_71_0.parent.loading_context.network_transmit = arg_71_0._network_transmit
end

function StateLoading.create_popup(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, ...)
	if Managers.account:leaving_game() then
		return
	end

	print("StateLoading:create_popup", Script.callstack())

	if arg_72_0._join_popup_id then
		Managers.popup:cancel_popup(arg_72_0._join_popup_id)

		arg_72_0._join_popup_id = nil
	end

	assert(arg_72_1, "[StateLoading] No error was passed to popup handler")

	local var_72_0 = arg_72_2 or "popup_error_topic"
	local var_72_1 = arg_72_3 or "restart_as_server"
	local var_72_2 = arg_72_4 or "menu_ok"
	local var_72_3 = Localize(arg_72_1)
	local var_72_4 = string.format(var_72_3, ...)

	assert(arg_72_0._popup_id == nil, "Tried to show popup even though we already had one.")

	arg_72_0._popup_id = Managers.popup:queue_popup(var_72_4, Localize(var_72_0), var_72_1, Localize(var_72_2))
end

function StateLoading.create_join_popup(arg_73_0, arg_73_1)
	if Managers.account:leaving_game() then
		return
	end

	local var_73_0 = Localize("popup_migrating_to_host_header")
	local var_73_1 = Localize("popup_migrating_to_host_message") .. "\n" .. arg_73_1
	local var_73_2 = StateLoading.join_lobby_timeout

	assert(arg_73_0._join_popup_id == nil, "Tried to show popup even though we already had one.")

	arg_73_0._join_popup_id = Managers.popup:queue_popup(var_73_1, var_73_0, "cancel", Localize("popup_choice_cancel"))

	local var_73_3 = "timeout"
	local var_73_4 = "center"
	local var_73_5 = false

	Managers.popup:activate_timer(arg_73_0._join_popup_id, var_73_2, var_73_3, var_73_4, var_73_5)
end

function StateLoading.clear_network_loading_context(arg_74_0)
	local var_74_0 = arg_74_0.parent.loading_context

	arg_74_0:_destroy_network_handler(false, var_74_0)

	local var_74_1 = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if var_74_1 and var_74_1.is_host then
		Managers.lobby:destroy_lobby("matchmaking_session_lobby")
		Managers.account:set_current_lobby(nil)
	end

	var_74_0.setup_voip = nil
end

function StateLoading.setup_network_client(arg_75_0, arg_75_1, arg_75_2)
	if not arg_75_2 then
		arg_75_2 = Managers.lobby:query_lobby("matchmaking_session_lobby")
	elseif arg_75_2.lobby ~= nil then
		Managers.lobby:register_existing_lobby(arg_75_2, "matchmaking_session_lobby", "StateLoading (setup_network_client)")
	end

	if not arg_75_2 or arg_75_2.lobby == nil then
		arg_75_0._wanted_state = StateTitleScreen

		if Managers.lobby:query_lobby("matchmaking_session_lobby") then
			Managers.lobby:destroy_lobby("matchmaking_session_lobby")
		end

		arg_75_0:create_popup("failure_start_join_server", "popup_error_topic", "restart_as_server", "menu_accept")

		return false
	end

	Application.warning("Setting up network client")

	local var_75_0 = arg_75_2:lobby_host()
	local var_75_1 = arg_75_0.parent.loading_context.wanted_profile_index
	local var_75_2 = arg_75_0.parent.loading_context.wanted_party_index

	arg_75_0._network_client = NetworkClient:new(var_75_0, var_75_1, var_75_2, arg_75_1, arg_75_2, arg_75_0._voip)
	arg_75_0._network_transmit = NetworkTransmit:new(false, arg_75_0._network_client.server_peer_id)

	arg_75_0._network_transmit:set_network_event_delegate(arg_75_0._network_event_delegate)
	arg_75_0._network_client:register_rpcs(arg_75_0._network_event_delegate, arg_75_0._network_transmit)

	arg_75_0._profile_synchronizer = arg_75_0._network_client.profile_synchronizer
	arg_75_0._handle_new_lobby_connection = nil
	arg_75_0._voip = nil

	arg_75_0._network_client.voip:set_input_manager(arg_75_0._input_manager)

	local var_75_3 = arg_75_0.parent.loading_context

	var_75_3.network_client = arg_75_0._network_client
	var_75_3.network_transmit = arg_75_0._network_transmit

	local var_75_4 = arg_75_2.lobby

	Managers.account:set_current_lobby(var_75_4)

	return true
end

function StateLoading.get_current_level_keys(arg_76_0)
	return Managers.level_transition_handler:get_current_level_keys()
end

function StateLoading.set_lobby_host_data(arg_77_0, arg_77_1)
	local var_77_0 = Managers.lobby:query_lobby("matchmaking_session_lobby")

	if var_77_0 and var_77_0.is_host then
		local var_77_1 = var_77_0:get_stored_lobby_data() or {}
		local var_77_2

		if IS_PS4 then
			var_77_2 = var_77_1.matchmaking_type or "n/a"
		else
			var_77_2 = var_77_1.matchmaking_type and NetworkLookup.matchmaking_types[tonumber(var_77_1.matchmaking_type)] or "n/a"
		end

		if var_77_2 ~= "weave" then
			var_77_1.mission_id = arg_77_1
		end

		var_77_1.matchmaking = var_77_1.matchmaking or "true"

		if LevelSettings[arg_77_1].hub_level then
			var_77_1.matchmaking = "false"
			var_77_1.matchmaking_type = IS_PS4 and "n/a" or NetworkLookup.matchmaking_types["n/a"]
			var_77_1.selected_mission_id = arg_77_1
		end

		if arg_77_1 == "prologue" then
			var_77_1.matchmaking = "false"
			var_77_1.matchmaking_type = IS_PS4 and "tutorial" or NetworkLookup.matchmaking_types.tutorial
		end

		local var_77_3 = Managers.level_transition_handler:get_current_mechanism()
		local var_77_4 = Managers.level_transition_handler:get_current_game_mode()

		var_77_1.mechanism = var_77_4 == "weave" and var_77_4 or var_77_3

		if IS_PS4 then
			local var_77_5 = Managers.account:region()
			local var_77_6, var_77_7 = MatchmakingRegionsHelper.get_matchmaking_regions(var_77_5)

			var_77_1.primary_region = var_77_6
			var_77_1.secondary_region = var_77_7
		end

		local var_77_8 = Development.parameter("weave_name")

		if var_77_8 then
			var_77_1.mission_id = var_77_8
			var_77_1.matchmaking_type = IS_PS4 and "custom" or NetworkLookup.matchmaking_types.custom
		elseif var_77_2 == "event" then
			var_77_1.matchmaking_type = IS_PS4 and "event" or NetworkLookup.matchmaking_types.event
		elseif Development.parameter("auto_host_level") then
			var_77_1.matchmaking_type = IS_PS4 and "custom" or NetworkLookup.matchmaking_types.custom
		elseif Managers.level_transition_handler:get_current_mechanism() == "versus" then
			var_77_1.matchmaking_type = DEDICATED_SERVER and NetworkLookup.matchmaking_types.versus or NetworkLookup.matchmaking_types.custom
		end

		if IS_WINDOWS or IS_LINUX then
			local var_77_9

			if DEDICATED_SERVER then
				var_77_9 = NetworkLookup.host_types.community_dedicated_server
			else
				var_77_9 = NetworkLookup.host_types.player_hosted
			end

			var_77_1.host_type = var_77_9
			var_77_1.eac_authorized = Managers.eac:is_trusted() and "true" or "false"
		end

		var_77_0:set_lobby_data(var_77_1)
	end
end

function StateLoading.start_matchmaking(arg_78_0)
	local var_78_0 = Managers.lobby:get_lobby("matchmaking_session_lobby")

	assert(var_78_0.is_host)

	local var_78_1 = var_78_0:get_stored_lobby_data() or {}

	var_78_1.matchmaking = "true"

	var_78_0:set_lobby_data(var_78_1)
end

function StateLoading.get_lobby(arg_79_0)
	return (Managers.lobby:query_lobby("matchmaking_session_lobby"))
end

function StateLoading.has_joined(arg_80_0)
	local var_80_0 = Managers.lobby:query_lobby("matchmaking_session_lobby")

	return var_80_0 and var_80_0:is_joined()
end
