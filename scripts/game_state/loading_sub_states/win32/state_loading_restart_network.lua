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

StateLoadingRestartNetwork.on_enter = function (self, arg_1_1)
	-- function 1
	print("[Gamestate] Enter Substate StateLoadingRestartNetwork")
	self:_init_params(arg_1_1)
	self:_init_network()
end

StateLoadingRestartNetwork._init_params = function (self, arg_2_1)
	-- function 2
	self._world = arg_2_1.world
	self._viewport = arg_2_1.viewport
	self._loading_view = arg_2_1.loading_view
	self._starting_tutorial = arg_2_1.starting_tutorial
	self._server_created = true
	self._lobby_joined = true
	self._previous_session_error_headers_lookup = {
		host_left_game = "popup_notice_topic",
		kicked_by_server = "popup_notice_topic",
		afk_kick = "popup_notice_topic"
	}
end

StateLoadingRestartNetwork._init_network = function (self)
	-- function 3
	local parameter = Development.parameter("auto_join")

	assert(not parameter and Development.parameter("unique_server_name"), "Can't use auto_join without unique_server_name")

	local parameter_2 = Development.parameter("auto_join_server")

	if not parameter then
		Development.set_parameter("client", true)
	end

	Development.set_parameter("auto_join", nil)
	Development.set_parameter("auto_join_server", nil)

	local var_3_2
	local flag = parameter_2 ~= nil
	local loading_context = self.parent.parent.loading_context
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and not Development.parameter("use_lan_backend")

	LobbySetup.setup_network_options(IS_WINDOWS)

	local network_options = LobbySetup.network_options()
	local PLATFORM = PLATFORM

	if not (not rawget(_G, "LobbyInternal") and LobbyInternal.network_initialized()) then
		if IS_WINDOWS or not IS_LINUX then
			if not (not rawget(_G, "Steam") and LEVEL_EDITOR_TEST or Development.parameter("use_lan_backend")) then
				require("scripts/network/lobby_steam")
				require("scripts/network/game_server/game_server_user_steam")

				if not rawget(_G, "SteamGameServer") then
					require("scripts/network/game_server/game_server_steam")
				end

				local boot_invite, var_3_9 = Friends.boot_invite()

				if not (boot_invite == Friends.NO_INVITE or self._starting_tutorial) then
					flag = boot_invite == Friends.INVITE_SERVER
					parameter_2 = var_3_9
				end

				print("state_loading_restart_network JOIN VIA STEAM " .. boot_invite)
			else
				rawset(_G, "Steam", nil)

				HAS_STEAM = false

				require("scripts/network/lobby_lan")

				var_3_2 = script_data.host_to_join
			end
		elseif not IS_XB1 then
			if not Managers.account:offline_mode() then
				if not package.loaded["scripts/network/lobby_xbox_live"] then
					package.loaded["scripts/network/lobby_xbox_live"] = nil
					package.load_order[#package.load_order] = nil
				end

				require("scripts/network/lobby_lan")
			else
				if not package.loaded["scripts/network/lobby_lan"] then
					package.loaded["scripts/network/lobby_lan"] = nil
					package.load_order[#package.load_order] = nil
				end

				require("scripts/network/lobby_xbox_live")
			end
		elseif not IS_PS4 then
			if not Managers.account:offline_mode() then
				if not package.loaded["scripts/network/lobby_psn"] then
					package.loaded["scripts/network/lobby_psn"] = nil
					package.load_order[#package.load_order] = nil
				end

				require("scripts/network/lobby_lan")
			else
				if not package.loaded["scripts/network/lobby_lan"] then
					package.loaded["scripts/network/lobby_lan"] = nil
					package.load_order[#package.load_order] = nil
				end

				require("scripts/network/lobby_psn")
			end
		end

		LobbyInternal.init_client(network_options)
	elseif not IS_XB1 then
		if not Managers.account:offline_mode() then
			if not package.loaded["scripts/network/lobby_xbox_live"] then
				package.loaded["scripts/network/lobby_xbox_live"] = nil
				package.load_order[#package.load_order] = nil
			end

			require("scripts/network/lobby_lan")
		else
			if not package.loaded["scripts/network/lobby_lan"] then
				package.loaded["scripts/network/lobby_lan"] = nil
				package.load_order[#package.load_order] = nil
			end

			require("scripts/network/lobby_xbox_live")
			LobbyInternal.init_client(network_options)
		end
	elseif not IS_PS4 then
		if not Managers.account:offline_mode() then
			if not package.loaded["scripts/network/lobby_psn"] then
				package.loaded["scripts/network/lobby_psn"] = nil
				package.load_order[#package.load_order] = nil
			end

			require("scripts/network/lobby_lan")
		else
			if not package.loaded["scripts/network/lobby_lan"] then
				package.loaded["scripts/network/lobby_lan"] = nil
				package.load_order[#package.load_order] = nil
			end

			require("scripts/network/lobby_psn")
			LobbyInternal.init_client(network_options)
		end
	end

	dofile("scripts/network_lookup/network_constants")

	if not script_data.done_initial_join then
		parameter_2 = nil
		var_3_2 = nil
	else
		script_data.done_initial_join = true
	end

	if not self.parent:has_registered_rpcs() then
		self.parent:register_rpcs()
	end

	if not self._starting_tutorial then
		local get_invited_lobby_data = Managers.invite:get_invited_lobby_data()
	end

	local WAIT_FOR_LEVEL_LOAD = StateLoading.LoadoutResyncStates.WAIT_FOR_LEVEL_LOAD
	local has_invitation = Managers.invite:has_invitation()

	print("[StateLoadingRestartNetwork] Selecting loadout_resync_state...", has_invitation, self._starting_tutorial, loading_context.join_lobby_data, loading_context.join_server_data, parameter, parameter_2, var_3_2, PLATFORM)

	if not (not has_invitation and self._starting_tutorial) then
		self._has_invitation = true
	elseif loading_context.join_lobby_data or not loading_context.join_server_data then
		self.parent:setup_join_lobby()
	elseif parameter or parameter_2 or not var_3_2 then
		self.parent:setup_lobby_finder(callback(self, "cb_lobby_joined"), parameter_2, var_3_2, flag)

		self._lobby_joined = false
	elseif not IS_CONSOLE then
		self._server_created = false
		self._creating_lobby = false
	elseif not loading_context.rejoin_lobby then
		local steal_lobby = Managers.party:steal_lobby()

		if type(steal_lobby) == "table" then
			loading_context.join_lobby_data = steal_lobby

			self.parent:setup_join_lobby()
		else
			self.parent:setup_lobby_host(nil, steal_lobby)

			self._server_created = true
		end
	else
		self.parent:setup_lobby_host()

		self._server_created = true
		WAIT_FOR_LEVEL_LOAD = StateLoading.LoadoutResyncStates.CHECK_RESYNC
	end

	if self.parent:loadout_resync_state() == StateLoading.LoadoutResyncStates.IDLE then
		print("[StateLoadingRestartNetwork] loadout_resync_state IDLE ->", WAIT_FOR_LEVEL_LOAD)
		self.parent:set_loadout_resync_state(WAIT_FOR_LEVEL_LOAD)
	else
		print("[StateLoadingRestartNetwork] Ignoring selected loadout_resync_state, wasn't IDLE")
	end

	if not loading_context.previous_session_error then
		local previous_session_error = loading_context.previous_session_error

		loading_context.previous_session_error = nil

		self.parent:create_popup(previous_session_error, self._previous_session_error_headers_lookup[previous_session_error], "continue")
	end
end

StateLoadingRestartNetwork.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if self._has_invitation_error or not Managers.account:user_detached() then
		return
	end

	if not self._has_invitation then
		if not Managers.invite:invites_handled() then
			if not Managers.account:offline_mode() then
				local get_invited_lobby_data = Managers.invite:get_invited_lobby_data()

				if not get_invited_lobby_data then
					if not get_invited_lobby_data.is_server_invite then
						self.parent.parent.loading_context.join_server_data = get_invited_lobby_data
					else
						self.parent.parent.loading_context.join_lobby_data = get_invited_lobby_data
					end

					self.parent:setup_join_lobby()

					self._has_invitation = false
				else
					self.parent:set_invitation_error()

					self._has_invitation_error = true
				end
			else
				self.parent.offline_invite = true
				self._has_invitation = false
			end
		end
	elseif not self._server_created and not self._lobby_joined then
		return StateLoadingRunning
	elseif not (not IS_CONSOLE and not Managers.account:all_sessions_cleaned_up() and self._creating_lobby) then
		self.parent:setup_lobby_host(callback(self, "cb_server_created"))

		self._creating_lobby = true
	end
end

StateLoadingRestartNetwork.on_exit = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

StateLoadingRestartNetwork.cb_server_created = function (self)
	-- function 6
	self._server_created = true
end

StateLoadingRestartNetwork.cb_lobby_joined = function (self)
	-- function 7
	self._lobby_joined = true
end
