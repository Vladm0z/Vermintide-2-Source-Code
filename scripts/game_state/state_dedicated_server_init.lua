-- chunkname: @scripts/game_state/state_dedicated_server_init.lua

require("scripts/managers/network/ban_list_manager")
require("scripts/network/network_server")

StateDedicatedServerInit = class(StateDedicatedServerInit)
StateDedicatedServerInit.NAME = "StateDedicatedServerInit"

function StateDedicatedServerInit.on_enter(arg_1_0, arg_1_1)
	arg_1_0:_init_network()
end

function StateDedicatedServerInit._init_network(arg_2_0)
	LobbySetup.setup_network_options()

	local var_2_0 = PLATFORM

	if not rawget(_G, "GameServerInternal") then
		if IS_WINDOWS or IS_LINUX then
			if rawget(_G, "Steam") then
				ferror("Running dedicated server with Steam enabled. This will make it easy to introduce bugs.")
			end

			require("scripts/network/game_server/game_server_steam")
		else
			ferror("Running dedicated server on unsupported platform (%s)", var_2_0)
		end
	end

	if rawget(_G, "GameliftServer") ~= nil then
		if GameliftServer.can_get_session() then
			local var_2_1, var_2_2, var_2_3, var_2_4, var_2_5 = GameliftServer.get_session()

			print("Got gamelift session data (STATE INIT):", var_2_1, var_2_2, var_2_3, var_2_4, var_2_5)

			script_data.server_name = var_2_4
		else
			script_data.server_name = "AWS Gamelift unknown"
		end
	else
		print("GAMELIFTPROP NOPE")
	end

	local var_2_6 = LobbySetup.network_options()
	local var_2_7 = script_data.server_name or script_data.settings.server_name

	cprint("Network Options:")
	cprint("----------------------------------------")

	for iter_2_0, iter_2_1 in pairs(var_2_6) do
		cprintf("%s = %s", iter_2_0, iter_2_1)
	end

	cprintf("server_name = %s", var_2_7)
	cprint("----------------------------------------")
	cprintf("You need to open port %d for incoming traffic to make the server detectable", var_2_6.query_port)
	Managers.lobby:make_lobby(GameServer, "matchmaking_session_lobby", "StateDedicatedServerInit", var_2_6, var_2_7)
	Managers.party:set_leader(nil)
	arg_2_0:_load_save_data()

	arg_2_0._state = "waiting_for_backend"
	Managers.ban_list = Managers.ban_list or BanListManager:new()
end

function StateDedicatedServerInit._load_save_data(arg_3_0)
	print("[StateDedicatedServerInit] SaveFileName", SaveFileName)
	Managers.save:auto_load(SaveFileName, callback(arg_3_0, "cb_save_data_loaded"))

	arg_3_0._save_data_loaded = false
end

function StateDedicatedServerInit.cb_save_data_loaded(arg_4_0, arg_4_1)
	if arg_4_1.error then
		Application.warning("Load error %q", arg_4_1.error)
	else
		populate_save_data(arg_4_1.data)
	end

	arg_4_0._save_data_loaded = true
	GameSettingsDevelopment.trunk_path = Development.parameter("trunk_path")
end

function StateDedicatedServerInit.update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local var_5_1 = var_5_0:update(arg_5_1, arg_5_2)
	local var_5_2 = arg_5_0._state

	if var_5_2 == "waiting_for_backend" then
		if Managers.backend:has_loaded() then
			Managers.backend:signin()

			arg_5_0._state = "load_save"

			cprint("Loading save...")
		end
	elseif var_5_2 == "load_save" then
		if arg_5_0._save_data_loaded then
			arg_5_0._state = "wait_for_signin"

			cprint("Signing in...")
		end
	elseif var_5_2 == "wait_for_signin" then
		if Managers.backend:signed_in() then
			arg_5_0._state = "wait_for_connect"

			cprint("Connecting to Steam...")
		end
	elseif var_5_2 == "wait_for_connect" then
		if var_5_1 == "connected" then
			cprint("Connected to Steam")
			arg_5_0.parent:setup_network_server()
			arg_5_0.parent:setup_global_managers(var_5_0)

			return StateDedicatedServerRunning
		elseif var_5_1 == "disconnected" then
			print("Failed to connect the game server. Check the connection to Steam.")
			Application.quit()
		end
	end

	Managers.backend:update(arg_5_1, arg_5_2)

	return nil
end

function StateDedicatedServerInit.on_exit(arg_6_0)
	return
end
