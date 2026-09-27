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

StateDedicatedServer.on_enter = function (self, arg_1_1)
	-- function 1
	VisualAssertLog.setup(nil)
	self:_setup_garbage_collection()
	self:_setup_network()
	self:_setup_state_machine()
	self:_setup_popup_manager()
	self:_setup_chat_manager()
	self:_setup_account_manager()
	self:_setup_eac_manager()

	if not self.parent.loading_context.reload_packages then
		self:_unload_packages()
	end

	self:_load_packages()
end

StateDedicatedServer._setup_garbage_collection = function (arg_2_0)
	-- function 2
	local flag = true

	GarbageLeakDetector.run_leak_detection(flag)
	GarbageLeakDetector.register_object(arg_2_0, "StateDedicatedServer")
end

StateDedicatedServer._init_input = function (self)
	-- function 3
	self._input_manager = InputManager:new()

	local _input_manager = self._input_manager

	Managers.input = _input_manager

	_input_manager:initialize_device("keyboard", 1)
	_input_manager:initialize_device("mouse", 1)
	_input_manager:initialize_device("gamepad")
end

StateDedicatedServer._setup_network = function (self)
	-- function 4
	self._network_event_delegate = NetworkEventDelegate:new()
end

StateDedicatedServer._setup_state_machine = function (self)
	-- function 5
	local tbl = {}

	self._machine = GameStateMachine:new(self, StateDedicatedServerInit, tbl, true)
end

StateDedicatedServer._setup_popup_manager = function (arg_6_0)
	-- function 6
	Managers.popup = PopupManager:new()
	Managers.simple_popup = SimplePopup:new()
end

StateDedicatedServer._setup_chat_manager = function (arg_7_0)
	-- function 7
	local Managers = Managers
	local chat = Managers.chat

	chat = chat or ChatManager:new()
	Managers.chat = chat
end

StateDedicatedServer._setup_account_manager = function (arg_8_0)
	-- function 8
	local Managers = Managers
	local account = Managers.account

	account = account or AccountManager:new()
	Managers.account = account
end

StateDedicatedServer._setup_eac_manager = function (arg_9_0)
	-- function 9
	local Managers = Managers
	local eac = Managers.eac

	eac = eac or EacManager:new()
	Managers.eac = eac
end

StateDedicatedServer._load_packages = function (arg_10_0)
	-- function 10
	local package = Managers.package

	for i, v in ipairs(StateDedicatedServer.packages_to_load) do
		if not package:has_loaded(v, "state_dedicated_server") then
			package:load(v, "state_dedicated_server", nil, true)
		end
	end

	GlobalResources.update_loading()
end

StateDedicatedServer._unload_packages = function (arg_11_0)
	-- function 11
	local package = Managers.package

	for i, v in ipairs(StateDedicatedServer.packages_to_load) do
		if not package:has_loaded(v, "state_dedicated_server") then
			package:unload(v, "state_dedicated_server")
		end
	end

	if not GlobalResources.loaded then
		GlobalResources.loaded = nil

		for i_2, v_2 in ipairs(GlobalResources) do
			package:unload(v_2, "global")
		end
	end
end

StateDedicatedServer._packages_loaded = function (arg_12_0)
	-- function 12
	local package = Managers.package

	for i, v in ipairs(StateDedicatedServer.packages_to_load) do
		if not package:has_loaded(v) then
			return false
		end
	end

	return true
end

StateDedicatedServer.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	Network.update_receive(arg_13_1, self._network_event_delegate.event_table)
	self._machine:update(arg_13_1, arg_13_2)
	self:_update_network(arg_13_1, arg_13_2)

	if not script_data.debug_enabled then
		VisualAssertLog.update(arg_13_1)
	end

	if not Managers.matchmaking then
		Managers.matchmaking:update(arg_13_1, arg_13_2)
	end

	if not Managers.game_server then
		Managers.game_server:update(arg_13_1, arg_13_2)

		local start_game_params = Managers.game_server:start_game_params()

		if not start_game_params then
			local level_key = start_game_params.level_key
			local environment_variation_id = start_game_params.environment_variation_id

			environment_variation_id = environment_variation_id or 0

			local game_mode = start_game_params.game_mode
			local difficulty = start_game_params.difficulty
			local level_transition_handler = Managers.level_transition_handler
			local generate_locked_director_functions = Managers.mechanism:generate_locked_director_functions(level_key)
			local generate_level_seed = Managers.mechanism:generate_level_seed()
			local var_13_8

			level_transition_handler:set_next_level(level_key, environment_variation_id, generate_level_seed, var_13_8, game_mode, nil, generate_locked_director_functions, difficulty)
			level_transition_handler:promote_next_level_data()

			self._wanted_state = StateLoading
		end

		self:_update_wanted_state()
	end

	Network.update_transmit(arg_13_1)

	if not self:_packages_loaded() then
		return self._wanted_state
	end
end

StateDedicatedServer.setup_network_server = function (self)
	-- function 14
	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local default_level_key = Managers.mechanism:default_level_key()
	local loading_context = self.parent.loading_context

	fassert(Managers.game_server == nil, "Already has a game server manager.")

	Managers.game_server = GameServerManager:new()
	self._network_server = NetworkServer:new(Managers.player, get_lobby, nil, Managers.game_server)

	local network_transmit = loading_context.network_transmit

	network_transmit = network_transmit or NetworkTransmit:new(true, self._network_server.server_peer_id)
	self._network_transmit = network_transmit

	self._network_transmit:set_network_event_delegate(self._network_event_delegate)
	self._network_server:register_rpcs(self._network_event_delegate, self._network_transmit)

	self._profile_synchronizer = self._network_server.profile_synchronizer

	local tbl = {
		network_server = self._network_server,
		network_transmit = self._network_transmit,
		game_server = get_lobby,
		profile_synchronizer = self._profile_synchronizer
	}

	Managers.game_server:setup_network_context(tbl)
	fassert(Managers.matchmaking == nil, "Already has a matchmaking server manager.")

	local tbl_2 = {
		is_server = true,
		network_transmit = self._network_transmit,
		lobby = get_lobby,
		peer_id = Network.peer_id(),
		profile_synchronizer = self._profile_synchronizer,
		network_server = self._network_server
	}

	Managers.matchmaking = MatchmakingManager:new(tbl_2)

	Managers.matchmaking:register_rpcs(self._network_event_delegate)

	loading_context.game_server = get_lobby
	loading_context.network_server = self._network_server

	Managers.mechanism:generate_locked_director_functions(default_level_key)
	Managers.mechanism:generate_level_seed()

	local level_transition_handler = Managers.level_transition_handler

	level_transition_handler:set_next_level(default_level_key)
	level_transition_handler:promote_next_level_data()
end

StateDedicatedServer.setup_chat_manager = function (arg_15_0, arg_15_1)
	-- function 15
	local peer_id = Network.peer_id()
	local tbl = {
		is_server = true,
		host_peer_id = peer_id,
		my_peer_id = peer_id
	}

	Managers.chat:setup_network_context(tbl)
	Managers.mechanism:mechanism_try_call("register_chats")

	local function fn()
		-- function 16
		return arg_15_1:members():get_members()
	end

	Managers.chat:register_channel(1, fn)
end

StateDedicatedServer.setup_enemy_package_loader = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	local peer_id = Network.peer_id()

	Managers.level_transition_handler.enemy_package_loader:network_context_created(arg_17_1, peer_id, peer_id, arg_17_4)
	Managers.level_transition_handler.pickup_package_loader:network_context_created(arg_17_1, peer_id, peer_id, arg_17_4)
	Managers.level_transition_handler.general_synced_package_loader:network_context_created(arg_17_1, peer_id, peer_id, arg_17_4)
	Managers.level_transition_handler.transient_package_loader:network_context_created(arg_17_1, peer_id, peer_id)
end

StateDedicatedServer.setup_global_managers = function (self, arg_18_1)
	-- function 18
	local peer_id = Network.peer_id()
	local flag = true
	local _network_server = self._network_server

	Managers.mechanism:network_context_created(arg_18_1, peer_id, peer_id, flag, _network_server)
	Managers.party:network_context_created(arg_18_1, peer_id, peer_id)
end

StateDedicatedServer._update_network = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not self._network_server then
		self._network_server:update(arg_19_1, arg_19_2)
	end
end

StateDedicatedServer._update_wanted_state = function (self)
	-- function 20
	if self._machine:state().NAME == "StateDedicatedServerRunning" then
		self._wanted_state = StateLoading
	end
end

StateDedicatedServer._destroy_network = function (self)
	-- function 21
	if not self._network_server then
		self._network_server:destroy()

		self._network_server = nil
	end

	if not Managers.lobby:query_lobby("matchmaking_session_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_session_lobby")
	end

	self.parent.loading_context = {}

	Managers.chat:unregister_channel(1)
	Managers.mechanism:mechanism_try_call("unregister_chats")

	if not self._network_transmit then
		self._network_transmit:destroy()

		self._network_transmit = nil
	end
end

StateDedicatedServer.on_exit = function (self, arg_22_1)
	-- function 22
	if not self._network_server then
		self._network_server:unregister_rpcs()
	end

	if not Managers.matchmaking then
		Managers.matchmaking:unregister_rpcs()
	end

	if not arg_22_1 then
		self:_destroy_network()
	else
		local loading_context = self.parent.loading_context

		loading_context.network_server = self._network_server
		loading_context.network_transmit = self._network_transmit
	end

	self._network_event_delegate:destroy()

	self._network_event_delegate = nil
end
