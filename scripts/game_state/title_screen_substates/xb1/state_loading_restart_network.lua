-- chunkname: @scripts/game_state/title_screen_substates/xb1/state_loading_restart_network.lua

require("scripts/network/lobby_host")
require("scripts/network/lobby_client")
require("scripts/network/lobby_finder")
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
end

function StateLoadingRestartNetwork._init_network(arg_3_0)
	local var_3_0 = arg_3_0.parent.parent.loading_context
	local var_3_1 = true

	LobbySetup.setup_network_options(var_3_1)

	if not rawget(_G, "LobbyInternal") or not LobbyInternal.network_initialized() then
		require("scripts/network/lobby_xbox_live")

		local var_3_2 = LobbySetup.network_options()

		LobbyInternal.init_client(var_3_2)
	end

	arg_3_0.parent:setup_level_transition()

	if var_3_0.join_lobby_data then
		arg_3_0.parent:setup_join_lobby()
	elseif auto_join_setting then
		arg_3_0.parent:setup_lobby_finder(Development.parameter("unique_server_name"))
	else
		arg_3_0.parent:setup_lobby_host()
	end

	if var_3_0.previous_session_error then
		local var_3_3 = var_3_0.previous_session_error

		var_3_0.previous_session_error = nil

		arg_3_0.parent:create_popup(var_3_3, nil, "continue")
	end
end
