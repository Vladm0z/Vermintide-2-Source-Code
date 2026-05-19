-- chunkname: @scripts/game_state/loading_sub_states/win32/state_loading_restart_network.lua

require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
require("scripts/network/game_server/game_server")
require("scripts/network/game_server/game_server_finder")
require("scripts/network/game_server/game_server_finder_lan")
require("scripts/network/game_server/game_server_client")
require("scripts/game_state/components/level_transition_handler")
require("scripts/network/network_event_delegate")
require("scripts/network/network_server")
require("scripts/network/network_client")
require("scripts/network/network_transmit")

StateLoadingRestartNetwork = class(StateLoadingRestartNetwork)
StateLoadingRestartNetwork.NAME = "StateLoadingRestartNetwork"

function StateLoadingRestartNetwork.on_enter(arg_1_0, arg_1_1)
	print("[Gamestate] Enter Substate StateLoadingRestartNetwork")
	arg_1_0:_init_params(arg_1_1)
	arg_1_0:_init_network()
end

function StateLoadingRestartNetwork._init_params(arg_2_0, arg_2_1)
	arg_2_0._world = arg_2_1.world
	arg_2_0._viewport = arg_2_1.viewport
	arg_2_0._loading_view = arg_2_1.loading_view
	arg_2_0._starting_tutorial = arg_2_1.starting_tutorial
	arg_2_0._server_created = true
	arg_2_0._lobby_joined = true
	arg_2_0._previous_session_error_headers_lookup = {
		host_left_game = "popup_notice_topic",
		kicked_by_server = "popup_notice_topic",
		afk_kick = "popup_notice_topic"
	}
end

function StateLoadingRestartNetwork._init_network(arg_3_0)
	local var_3_0 = Development.parameter("auto_join")

	assert(not var_3_0 or Development.parameter("unique_server_name"), "Can't use auto_join without unique_server_name")

	local var_3_1 = Development.parameter("auto_join_server")

	if var_3_0 then
		Development.set_parameter("client", true)
	end

	Development.set_parameter("auto_join", nil)
	Development.set_parameter("auto_join_server", nil)

	local var_3_2
	local var_3_3 = var_3_1 ~= nil
	local var_3_4 = arg_3_0.parent.parent.loading_context
	local var_3_5 = IS_WINDOWS and not Development.parameter("use_lan_backend")

	LobbySetup.setup_network_options(var_3_5)

	local var_3_6 = LobbySetup.network_options()
	local var_3_7 = PLATFORM

	if not rawget(_G, "LobbyInternal") or not LobbyInternal.network_initialized() then
		if IS_WINDOWS or IS_LINUX then
			if rawget(_G, "Steam") and not LEVEL_EDITOR_TEST and not Development.parameter("use_lan_backend") then
				require("scripts/network/lobby_steam")
				require("scripts/network/game_server/game_server_user_steam")

				if rawget(_G, "SteamGameServer") then
					require("scripts/network/game_server/game_server_steam")
				end

				local var_3_8, var_3_9 = Friends.boot_invite()

				if var_3_8 ~= Friends.NO_INVITE and not arg_3_0._starting_tutorial then
					var_3_3 = var_3_8 == Friends.INVITE_SERVER
					var_3_1 = var_3_9
				end

				print("state_loading_restart_network JOIN VIA STEAM " .. var_3_8)
			else
				rawset(_G, "Steam", nil)

				HAS_STEAM = false

				require("scripts/network/lobby_lan")

				var_3_2 = script_data.host_to_join
			end
		elseif IS_XB1 then
			if Managers.account:offline_mode() then
				if package.loaded["scripts/network/lobby_xbox_live"] then
					package.loaded["scripts/network/lobby_xbox_live"] = nil
					package.load_order[#package.load_order] = nil
				end

				require("scripts/network/lobby_lan")
			else
				if package.loaded["scripts/network/lobby_lan"] then
					package.loaded["scripts/network/lobby_lan"] = nil
					package.load_order[#package.load_order] = nil
				end

				require("scripts/network/lobby_xbox_live")
			end
		elseif IS_PS4 then
			if Managers.account:offline_mode() then
				if package.loaded["scripts/network/lobby_psn"] then
					package.loaded["scripts/network/lobby_psn"] = nil
					package.load_order[#package.load_order] = nil
				end

				require("scripts/network/lobby_lan")
			else
				if package.loaded["scripts/network/lobby_lan"] then
					package.loaded["scripts/network/lobby_lan"] = nil
					package.load_order[#package.load_order] = nil
				end

				require("scripts/network/lobby_psn")
			end
		end

		LobbyInternal.init_client(var_3_6)
	elseif IS_XB1 then
		if Managers.account:offline_mode() then
			if package.loaded["scripts/network/lobby_xbox_live"] then
				package.loaded["scripts/network/lobby_xbox_live"] = nil
				package.load_order[#package.load_order] = nil
			end

			require("scripts/network/lobby_lan")
		else
			if package.loaded["scripts/network/lobby_lan"] then
				package.loaded["scripts/network/lobby_lan"] = nil
				package.load_order[#package.load_order] = nil
			end

			require("scripts/network/lobby_xbox_live")
			LobbyInternal.init_client(var_3_6)
		end
	elseif IS_PS4 then
		if Managers.account:offline_mode() then
			if package.loaded["scripts/network/lobby_psn"] then
				package.loaded["scripts/network/lobby_psn"] = nil
				package.load_order[#package.load_order] = nil
			end

			require("scripts/network/lobby_lan")
		else
			if package.loaded["scripts/network/lobby_lan"] then
				package.loaded["scripts/network/lobby_lan"] = nil
				package.load_order[#package.load_order] = nil
			end

			require("scripts/network/lobby_psn")
			LobbyInternal.init_client(var_3_6)
		end
	end

	if script_data.done_initial_join then
		var_3_1 = nil
		var_3_2 = nil
	else
		script_data.done_initial_join = true
	end

	if not arg_3_0.parent:has_registered_rpcs() then
		arg_3_0.parent:register_rpcs()
	end

	if arg_3_0._starting_tutorial then
		local var_3_10 = Managers.invite:get_invited_lobby_data()
	end

	local var_3_11 = StateLoading.LoadoutResyncStates.WAIT_FOR_LEVEL_LOAD
	local var_3_12 = Managers.invite:has_invitation()

	print("[StateLoadingRestartNetwork] Selecting loadout_resync_state...", var_3_12, arg_3_0._starting_tutorial, var_3_4.join_lobby_data, var_3_4.join_server_data, var_3_0, var_3_1, var_3_2, var_3_7)

	if var_3_12 and not arg_3_0._starting_tutorial then
		arg_3_0._has_invitation = true
	elseif var_3_4.join_lobby_data or var_3_4.join_server_data then
		arg_3_0.parent:setup_join_lobby()
	elseif var_3_0 or var_3_1 or var_3_2 then
		arg_3_0.parent:setup_lobby_finder(callback(arg_3_0, "cb_lobby_joined"), var_3_1, var_3_2, var_3_3)

		arg_3_0._lobby_joined = false
	elseif IS_CONSOLE then
		arg_3_0._server_created = false
		arg_3_0._creating_lobby = false
	elseif var_3_4.rejoin_lobby then
		local var_3_13 = Managers.party:steal_lobby()

		if type(var_3_13) == "table" then
			var_3_4.join_lobby_data = var_3_13

			arg_3_0.parent:setup_join_lobby()
		else
			arg_3_0.parent:setup_lobby_host(nil, var_3_13)

			arg_3_0._server_created = true
		end
	else
		arg_3_0.parent:setup_lobby_host()

		arg_3_0._server_created = true
		var_3_11 = StateLoading.LoadoutResyncStates.CHECK_RESYNC
	end

	if arg_3_0.parent:loadout_resync_state() == StateLoading.LoadoutResyncStates.IDLE then
		print("[StateLoadingRestartNetwork] loadout_resync_state IDLE ->", var_3_11)
		arg_3_0.parent:set_loadout_resync_state(var_3_11)
	else
		print("[StateLoadingRestartNetwork] Ignoring selected loadout_resync_state, wasn't IDLE")
	end

	if var_3_4.previous_session_error then
		local var_3_14 = var_3_4.previous_session_error

		var_3_4.previous_session_error = nil

		arg_3_0.parent:create_popup(var_3_14, arg_3_0._previous_session_error_headers_lookup[var_3_14], "continue")
	end
end

function StateLoadingRestartNetwork.update(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._has_invitation_error or Managers.account:user_detached() then
		return
	end

	if arg_4_0._has_invitation then
		if Managers.invite:invites_handled() then
			if not Managers.account:offline_mode() then
				local var_4_0 = Managers.invite:get_invited_lobby_data()

				if var_4_0 then
					if var_4_0.is_server_invite then
						arg_4_0.parent.parent.loading_context.join_server_data = var_4_0
					else
						arg_4_0.parent.parent.loading_context.join_lobby_data = var_4_0
					end

					arg_4_0.parent:setup_join_lobby()

					arg_4_0._has_invitation = false
				else
					arg_4_0.parent:set_invitation_error()

					arg_4_0._has_invitation_error = true
				end
			else
				arg_4_0.parent.offline_invite = true
				arg_4_0._has_invitation = false
			end
		end
	elseif arg_4_0._server_created and arg_4_0._lobby_joined then
		return StateLoadingRunning
	elseif IS_CONSOLE and Managers.account:all_sessions_cleaned_up() and not arg_4_0._creating_lobby then
		arg_4_0.parent:setup_lobby_host(callback(arg_4_0, "cb_server_created"))

		arg_4_0._creating_lobby = true
	end
end

function StateLoadingRestartNetwork.on_exit(arg_5_0, arg_5_1)
	return
end

function StateLoadingRestartNetwork.cb_server_created(arg_6_0)
	arg_6_0._server_created = true
end

function StateLoadingRestartNetwork.cb_lobby_joined(arg_7_0)
	arg_7_0._lobby_joined = true
end
