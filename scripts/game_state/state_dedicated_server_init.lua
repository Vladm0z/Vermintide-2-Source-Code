-- chunkname: @scripts/game_state/state_dedicated_server_init.lua

require("scripts/managers/network/ban_list_manager")
require("scripts/network/network_server")

StateDedicatedServerInit = class(StateDedicatedServerInit)
StateDedicatedServerInit.NAME = "StateDedicatedServerInit"

StateDedicatedServerInit.on_enter = function (self, arg_1_1)
	-- function 1
	self:_init_network()
end

StateDedicatedServerInit._init_network = function (self)
	-- function 2
	LobbySetup.setup_network_options()

	local PLATFORM = PLATFORM

	if not rawget(_G, "GameServerInternal") then
		if IS_WINDOWS or not IS_LINUX then
			if not rawget(_G, "Steam") then
				ferror("Running dedicated server with Steam enabled. This will make it easy to introduce bugs.")
			end

			require("scripts/network/game_server/game_server_steam")
		else
			ferror("Running dedicated server on unsupported platform (%s)", PLATFORM)
		end
	end

	if rawget(_G, "GameliftServer") ~= nil then
		if not GameliftServer.can_get_session() then
			local get_session, var_2_2, var_2_3, var_2_4, var_2_5 = GameliftServer.get_session()

			print("Got gamelift session data (STATE INIT):", get_session, var_2_2, var_2_3, var_2_4, var_2_5)

			script_data.server_name = var_2_4
		else
			script_data.server_name = "AWS Gamelift unknown"
		end
	else
		print("GAMELIFTPROP NOPE")
	end

	local network_options = LobbySetup.network_options()
	local server_name = script_data.server_name

	server_name = server_name or script_data.settings.server_name

	cprint("Network Options:")
	cprint("----------------------------------------")

	for k, v in pairs(network_options) do
		cprintf("%s = %s", k, v)
	end

	cprintf("server_name = %s", server_name)
	cprint("----------------------------------------")
	cprintf("You need to open port %d for incoming traffic to make the server detectable", network_options.query_port)
	Managers.lobby:make_lobby(GameServer, "matchmaking_session_lobby", "StateDedicatedServerInit", network_options, server_name)
	Managers.party:set_leader(nil)
	self:_load_save_data()

	self._state = "waiting_for_backend"

	local Managers = Managers
	local ban_list = Managers.ban_list

	ban_list = ban_list or BanListManager:new()
	Managers.ban_list = ban_list
end

StateDedicatedServerInit._load_save_data = function (self)
	-- function 3
	print("[StateDedicatedServerInit] SaveFileName", SaveFileName)
	Managers.save:auto_load(SaveFileName, callback(self, "cb_save_data_loaded"))

	self._save_data_loaded = false
end

StateDedicatedServerInit.cb_save_data_loaded = function (self, arg_4_1)
	-- function 4
	if not arg_4_1.error then
		Application.warning("Load error %q", arg_4_1.error)
	else
		populate_save_data(arg_4_1.data)
	end

	self._save_data_loaded = true
	GameSettingsDevelopment.trunk_path = Development.parameter("trunk_path")
end

StateDedicatedServerInit.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local update = get_lobby:update(arg_5_1, arg_5_2)
	local _state = self._state

	if _state == "waiting_for_backend" then
		if not Managers.backend:has_loaded() then
			Managers.backend:signin()

			self._state = "load_save"

			cprint("Loading save...")
		end
	elseif _state == "load_save" then
		if not self._save_data_loaded then
			self._state = "wait_for_signin"

			cprint("Signing in...")
		end
	elseif _state == "wait_for_signin" then
		if not Managers.backend:signed_in() then
			self._state = "wait_for_connect"

			cprint("Connecting to Steam...")
		end
	elseif _state == "wait_for_connect" then
		if update == "connected" then
			cprint("Connected to Steam")
			self.parent:setup_network_server()
			self.parent:setup_global_managers(get_lobby)

			return StateDedicatedServerRunning
		elseif update == "disconnected" then
			print("Failed to connect the game server. Check the connection to Steam.")
			Application.quit()
		end
	end

	Managers.backend:update(arg_5_1, arg_5_2)

	return nil
end

StateDedicatedServerInit.on_exit = function (arg_6_0)
	-- function 6
	return
end
