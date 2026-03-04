-- chunkname: @scripts/game_state/state_dedicated_server.lua

require("scripts/game_state/state_dedicated_server_init")
require("scripts/game_state/state_dedicated_server_running")
require("scripts/game_state/components/level_transition_handler")
require("scripts/game_state/state_loading")
require("scripts/network/game_server/game_server")
require("scripts/network/network_event_delegate")
require("scripts/network/network_transmit")
require("scripts/settings/platform_specific")
require("scripts/managers/matchmaking/matchmaking_manager")
require("scripts/managers/network/game_server_manager")
require("scripts/managers/input/input_manager")
require("scripts/managers/eac/eac_manager")
require("foundation/scripts/util/garbage_leak_detector")
require("foundation/scripts/managers/chat/chat_manager")
require("scripts/ui/ui_animations")
require("scripts/utils/visual_assert_log")

StateDedicatedServer = class(StateDedicatedServer)
StateDedicatedServer.NAME = "StateDedicatedServer"
StateDedicatedServer.packages_to_load = {}

StateDedicatedServer.on_enter = function (arg_1_0, arg_1_1)
	VisualAssertLog.setup(nil)
	arg_1_0:_setup_garbage_collection()
	arg_1_0:_setup_network()
	arg_1_0:_setup_state_machine()
	arg_1_0:_setup_popup_manager()
	arg_1_0:_setup_chat_manager()
	arg_1_0:_setup_account_manager()
	arg_1_0:_setup_eac_manager()

	if arg_1_0.parent.loading_context.reload_packages then
		arg_1_0:_unload_packages()
	end

	arg_1_0:_load_packages()
end

StateDedicatedServer._setup_garbage_collection = function (arg_2_0)
	local var_2_0 = true

	GarbageLeakDetector.run_leak_detection(var_2_0)
	GarbageLeakDetector.register_object(arg_2_0, "StateDedicatedServer")
end

StateDedicatedServer._init_input = function (arg_3_0)
	arg_3_0._input_manager = InputManager:new()

	local var_3_0 = arg_3_0._input_manager

	Managers.input = var_3_0

	var_3_0:initialize_device("keyboard", 1)
	var_3_0:initialize_device("mouse", 1)
	var_3_0:initialize_device("gamepad")
end

StateDedicatedServer._setup_network = function (arg_4_0)
	arg_4_0._network_event_delegate = NetworkEventDelegate:new()
end

StateDedicatedServer._setup_state_machine = function (arg_5_0)
	local var_5_0 = {}

	arg_5_0._machine = GameStateMachine:new(arg_5_0, StateDedicatedServerInit, var_5_0, true)
end

StateDedicatedServer._setup_popup_manager = function (arg_6_0)
	Managers.popup = PopupManager:new()
	Managers.simple_popup = SimplePopup:new()
end

StateDedicatedServer._setup_chat_manager = function (arg_7_0)
	Managers.chat = Managers.chat or ChatManager:new()
end

StateDedicatedServer._setup_account_manager = function (arg_8_0)
	Managers.account = Managers.account or AccountManager:new()
end

StateDedicatedServer._setup_eac_manager = function (arg_9_0)
	Managers.eac = Managers.eac or EacManager:new()
end

StateDedicatedServer._load_packages = function (arg_10_0)
	local var_10_0 = Managers.package

	for iter_10_0, iter_10_1 in ipairs(StateDedicatedServer.packages_to_load) do
		if not var_10_0:has_loaded(iter_10_1, "state_dedicated_server") then
			var_10_0:load(iter_10_1, "state_dedicated_server", nil, true)
		end
	end

	GlobalResources.update_loading()
end

StateDedicatedServer._unload_packages = function (arg_11_0)
	local var_11_0 = Managers.package

	for iter_11_0, iter_11_1 in ipairs(StateDedicatedServer.packages_to_load) do
		if var_11_0:has_loaded(iter_11_1, "state_dedicated_server") then
			var_11_0:unload(iter_11_1, "state_dedicated_server")
		end
	end

	if GlobalResources.loaded then
		GlobalResources.loaded = nil

		for iter_11_2, iter_11_3 in ipairs(GlobalResources) do
			var_11_0:unload(iter_11_3, "global")
		end
	end
end

StateDedicatedServer._packages_loaded = function (arg_12_0)
	local var_12_0 = Managers.package

	for iter_12_0, iter_12_1 in ipairs(StateDedicatedServer.packages_to_load) do
		if not var_12_0:has_loaded(iter_12_1) then
			return false
		end
	end

	return true
end

StateDedicatedServer.update = function (arg_13_0, arg_13_1, arg_13_2)
	Network.update_receive(arg_13_1, arg_13_0._network_event_delegate.event_table)
	arg_13_0._machine:update(arg_13_1, arg_13_2)
	arg_13_0:_update_network(arg_13_1, arg_13_2)

	if script_data.debug_enabled then
		VisualAssertLog.update(arg_13_1)
	end

	if Managers.matchmaking then
		Managers.matchmaking:update(arg_13_1, arg_13_2)
	end

	if Managers.game_server then
		Managers.game_server:update(arg_13_1, arg_13_2)

		local var_13_0 = Managers.game_server:start_game_params()

		if var_13_0 then
			local var_13_1 = var_13_0.level_key
			local var_13_2 = var_13_0.environment_variation_id or 0
			local var_13_3 = var_13_0.game_mode
			local var_13_4 = var_13_0.difficulty
			local var_13_5 = Managers.level_transition_handler
			local var_13_6 = Managers.mechanism:generate_locked_director_functions(var_13_1)
			local var_13_7 = Managers.mechanism:generate_level_seed()
			local var_13_8

			var_13_5:set_next_level(var_13_1, var_13_2, var_13_7, var_13_8, var_13_3, nil, var_13_6, var_13_4)
			var_13_5:promote_next_level_data()

			arg_13_0._wanted_state = StateLoading
		end

		arg_13_0:_update_wanted_state()
	end

	Network.update_transmit(arg_13_1)

	if arg_13_0:_packages_loaded() then
		return arg_13_0._wanted_state
	end
end

StateDedicatedServer.setup_network_server = function (arg_14_0)
	local var_14_0 = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local var_14_1 = Managers.mechanism:default_level_key()
	local var_14_2 = arg_14_0.parent.loading_context

	fassert(Managers.game_server == nil, "Already has a game server manager.")

	Managers.game_server = GameServerManager:new()
	arg_14_0._network_server = NetworkServer:new(Managers.player, var_14_0, nil, Managers.game_server)
	arg_14_0._network_transmit = var_14_2.network_transmit or NetworkTransmit:new(true, arg_14_0._network_server.server_peer_id)

	arg_14_0._network_transmit:set_network_event_delegate(arg_14_0._network_event_delegate)
	arg_14_0._network_server:register_rpcs(arg_14_0._network_event_delegate, arg_14_0._network_transmit)

	arg_14_0._profile_synchronizer = arg_14_0._network_server.profile_synchronizer

	local var_14_3 = {
		network_server = arg_14_0._network_server,
		network_transmit = arg_14_0._network_transmit,
		game_server = var_14_0,
		profile_synchronizer = arg_14_0._profile_synchronizer
	}

	Managers.game_server:setup_network_context(var_14_3)
	fassert(Managers.matchmaking == nil, "Already has a matchmaking server manager.")

	local var_14_4 = {
		is_server = true,
		network_transmit = arg_14_0._network_transmit,
		lobby = var_14_0,
		peer_id = Network.peer_id(),
		profile_synchronizer = arg_14_0._profile_synchronizer,
		network_server = arg_14_0._network_server
	}

	Managers.matchmaking = MatchmakingManager:new(var_14_4)

	Managers.matchmaking:register_rpcs(arg_14_0._network_event_delegate)

	var_14_2.game_server = var_14_0
	var_14_2.network_server = arg_14_0._network_server

	Managers.mechanism:generate_locked_director_functions(var_14_1)
	Managers.mechanism:generate_level_seed()

	local var_14_5 = Managers.level_transition_handler

	var_14_5:set_next_level(var_14_1)
	var_14_5:promote_next_level_data()
end

StateDedicatedServer.setup_chat_manager = function (arg_15_0, arg_15_1)
	local var_15_0 = Network.peer_id()
	local var_15_1 = {
		is_server = true,
		host_peer_id = var_15_0,
		my_peer_id = var_15_0
	}

	Managers.chat:setup_network_context(var_15_1)
	Managers.mechanism:mechanism_try_call("register_chats")

	local function var_15_2()
		return arg_15_1:members():get_members()
	end

	Managers.chat:register_channel(1, var_15_2)
end

StateDedicatedServer.setup_enemy_package_loader = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = Network.peer_id()

	Managers.level_transition_handler.enemy_package_loader:network_context_created(arg_17_1, var_17_0, var_17_0, arg_17_4)
	Managers.level_transition_handler.pickup_package_loader:network_context_created(arg_17_1, var_17_0, var_17_0, arg_17_4)
	Managers.level_transition_handler.general_synced_package_loader:network_context_created(arg_17_1, var_17_0, var_17_0, arg_17_4)
	Managers.level_transition_handler.transient_package_loader:network_context_created(arg_17_1, var_17_0, var_17_0)
end

StateDedicatedServer.setup_global_managers = function (arg_18_0, arg_18_1)
	local var_18_0 = Network.peer_id()
	local var_18_1 = true
	local var_18_2 = arg_18_0._network_server

	Managers.mechanism:network_context_created(arg_18_1, var_18_0, var_18_0, var_18_1, var_18_2)
	Managers.party:network_context_created(arg_18_1, var_18_0, var_18_0)
end

StateDedicatedServer._update_network = function (arg_19_0, arg_19_1, arg_19_2)
	if arg_19_0._network_server then
		arg_19_0._network_server:update(arg_19_1, arg_19_2)
	end
end

StateDedicatedServer._update_wanted_state = function (arg_20_0)
	if arg_20_0._machine:state().NAME == "StateDedicatedServerRunning" then
		arg_20_0._wanted_state = StateLoading
	end
end

StateDedicatedServer._destroy_network = function (arg_21_0)
	if arg_21_0._network_server then
		arg_21_0._network_server:destroy()

		arg_21_0._network_server = nil
	end

	if Managers.lobby:query_lobby("matchmaking_session_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_session_lobby")
	end

	arg_21_0.parent.loading_context = {}

	Managers.chat:unregister_channel(1)
	Managers.mechanism:mechanism_try_call("unregister_chats")

	if arg_21_0._network_transmit then
		arg_21_0._network_transmit:destroy()

		arg_21_0._network_transmit = nil
	end
end

StateDedicatedServer.on_exit = function (arg_22_0, arg_22_1)
	if arg_22_0._network_server then
		arg_22_0._network_server:unregister_rpcs()
	end

	if Managers.matchmaking then
		Managers.matchmaking:unregister_rpcs()
	end

	if arg_22_1 then
		arg_22_0:_destroy_network()
	else
		local var_22_0 = arg_22_0.parent.loading_context

		var_22_0.network_server = arg_22_0._network_server
		var_22_0.network_transmit = arg_22_0._network_transmit
	end

	arg_22_0._network_event_delegate:destroy()

	arg_22_0._network_event_delegate = nil
end
