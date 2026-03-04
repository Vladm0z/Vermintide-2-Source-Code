-- chunkname: @scripts/network/game_server/game_server_user_steam.lua

require("scripts/network/game_server/game_server_aux")

GameServerInternal = GameServerInternal or {}
GameServerInternal.lobby_data_version = 2

function GameServerInternal.join_server(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.ip_port
	local var_1_1 = true
	local var_1_2 = arg_1_0.invitee
	local var_1_3

	if var_1_2 then
		var_1_3 = Network.join_steam_server(var_1_1, var_1_0, arg_1_1, var_1_2)
	else
		var_1_3 = Network.join_steam_server(var_1_1, var_1_0, arg_1_1)
	end

	SteamGameServerLobby.auto_update_data(var_1_3)

	return var_1_3
end

function GameServerInternal.reserve_server(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0.ip_port
	local var_2_1 = true
	local var_2_2 = Network.reserve_steam_server(var_2_1, arg_2_2, var_2_0, arg_2_1)

	SteamGameServerLobby.auto_update_data(var_2_2)

	return var_2_2
end

function GameServerInternal.claim_reserved(arg_3_0)
	SteamGameServerLobby.join(arg_3_0)
end

if not DEDICATED_SERVER then
	function GameServerInternal.open_channel(arg_4_0, arg_4_1)
		local var_4_0 = SteamGameServerLobby.open_channel(arg_4_0, arg_4_1)

		print("LobbyInternal.open_channel lobby: %s, to peer: %s channel: %s", arg_4_0, arg_4_1, var_4_0)

		return var_4_0
	end

	function GameServerInternal.close_channel(arg_5_0, arg_5_1)
		printf("LobbyInternal.close_channel lobby: %s, channel: %s", arg_5_0, arg_5_1)
		SteamGameServerLobby.close_channel(arg_5_0, arg_5_1)
	end
end

function GameServerInternal.leave_server(arg_6_0)
	Network.leave_steam_server(arg_6_0)
end

function GameServerInternal.lobby_host(arg_7_0)
	return SteamGameServerLobby.game_session_host(arg_7_0)
end

function GameServerInternal.lobby_id(arg_8_0)
	return SteamGameServerLobby.game_session_host(arg_8_0)
end

function GameServerInternal.server_browser()
	return GameServerInternal._browser_wrapper
end

function GameServerInternal.clear_filter_requirements()
	GameServerInternal._browser_wrapper:clear_filters()
end

function GameServerInternal.add_filter_requirements(arg_11_0)
	local var_11_0 = GameServerInternal._browser_wrapper

	var_11_0:clear_filters()
	var_11_0:add_filters(arg_11_0)
end

function GameServerInternal.forget_server_browser()
	if GameServerInternal._browser_wrapper then
		GameServerInternal._browser_wrapper:destroy()

		GameServerInternal._browser_wrapper = nil
	end
end

function GameServerInternal.create_server_browser_wrapper()
	fassert(GameServerInternal._browser_wrapper == nil, "Already has server browser wrapper")

	GameServerInternal._browser_wrapper = SteamServerBrowserWrapper:new()

	return GameServerInternal._browser_wrapper
end

SteamServerBrowserWrapper = class(SteamServerBrowserWrapper)
SteamServerBrowserWrapper.compare_funcs = {
	equal = function(arg_14_0, arg_14_1)
		return arg_14_0 == tostring(arg_14_1)
	end,
	not_equal = function(arg_15_0, arg_15_1)
		return arg_15_0 ~= tostring(arg_15_1)
	end,
	less = function(arg_16_0, arg_16_1)
		return arg_16_1 > tonumber(arg_16_0)
	end,
	less_or_equal = function(arg_17_0, arg_17_1)
		return arg_17_1 >= tonumber(arg_17_0)
	end,
	greater = function(arg_18_0, arg_18_1)
		return arg_18_1 < tonumber(arg_18_0)
	end,
	greater_or_equal = function(arg_19_0, arg_19_1)
		return arg_19_1 <= tonumber(arg_19_0)
	end
}
SteamServerBrowserWrapper.compare_func_names = {
	greater_or_equal = ">=",
	less_or_equal = "<=",
	greater = ">",
	less = "<",
	equal = "==",
	not_equal = "~="
}

function SteamServerBrowserWrapper.init(arg_20_0)
	arg_20_0._engine_browser = LobbyInternal.client:create_server_browser()
	arg_20_0._cached_servers = {}
	arg_20_0._filters = {}
	arg_20_0._search_type = "internet"
	arg_20_0._state = "waiting"
end

function SteamServerBrowserWrapper.destroy(arg_21_0)
	LobbyInternal.client:destroy_server_browser(arg_21_0._engine_browser)
end

function SteamServerBrowserWrapper.servers(arg_22_0)
	return arg_22_0._cached_servers
end

function SteamServerBrowserWrapper.is_refreshing(arg_23_0)
	local var_23_0 = arg_23_0._state

	return var_23_0 == "refreshing" or var_23_0 == "fetching_data"
end

function SteamServerBrowserWrapper.refresh(arg_24_0)
	if SteamServerBrowser.is_refreshing(arg_24_0._engine_browser) then
		SteamServerBrowser.abort_refresh(arg_24_0._engine_browser)
	end

	SteamServerBrowser.refresh(arg_24_0._engine_browser, arg_24_0._search_type)

	arg_24_0._state = "refreshing"
end

function SteamServerBrowserWrapper.set_search_type(arg_25_0, arg_25_1)
	arg_25_0._search_type = arg_25_1
end

function SteamServerBrowserWrapper.add_to_favorites(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	SteamServerBrowser.add_favorite(arg_26_0._engine_browser, arg_26_1, arg_26_2, arg_26_3)
end

function SteamServerBrowserWrapper.remove_from_favorites(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	SteamServerBrowser.remove_favorite(arg_27_0._engine_browser, arg_27_1, arg_27_2, arg_27_3)
end

function SteamServerBrowserWrapper.clear_filters(arg_28_0)
	SteamServerBrowser.clear_filters(arg_28_0._engine_browser)
	table.clear(arg_28_0._filters)
end

function SteamServerBrowserWrapper.add_filters(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.server_browser_filters

	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		SteamServerBrowser.add_filter(arg_29_0._engine_browser, iter_29_0, iter_29_1)
		mm_printf("Adding server filter: key(%s) value=%s", iter_29_0, iter_29_1)
	end

	local var_29_1 = arg_29_1.matchmaking_filters

	for iter_29_2, iter_29_3 in pairs(var_29_1) do
		local var_29_2 = iter_29_3.value
		local var_29_3 = iter_29_3.comparison
		local var_29_4 = SteamServerBrowserWrapper.compare_funcs[var_29_3]

		fassert(var_29_4, "Compare func does not exist for comparison(%s)", var_29_3)

		local var_29_5 = SteamServerBrowserWrapper.compare_func_names[var_29_3]

		arg_29_0._filters[iter_29_2] = {
			value = var_29_2,
			compare_name = var_29_5,
			compare_func = var_29_4
		}

		mm_printf("Server Filter: %s, comparison(%s), value=%s", tostring(iter_29_2), tostring(var_29_3), tostring(var_29_2))
	end
end

function SteamServerBrowserWrapper.update(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._state

	if var_30_0 == "refreshing" then
		if not SteamServerBrowser.is_refreshing(arg_30_0._engine_browser) then
			local var_30_1 = SteamServerBrowser.num_servers(arg_30_0._engine_browser)

			for iter_30_0 = 0, var_30_1 - 1 do
				SteamServerBrowser.request_data(arg_30_0._engine_browser, iter_30_0)
			end

			arg_30_0._state = "fetching_data"
		end
	elseif var_30_0 == "fetching_data" then
		local var_30_2 = false
		local var_30_3 = SteamServerBrowser.num_servers(arg_30_0._engine_browser)

		for iter_30_1 = 0, var_30_3 - 1 do
			local var_30_4, var_30_5 = SteamServerBrowser.is_fetching_data(arg_30_0._engine_browser, iter_30_1)

			if var_30_4 then
				var_30_2 = true

				break
			end
		end

		if not var_30_2 then
			local var_30_6 = arg_30_0._cached_servers

			table.clear(var_30_6)

			for iter_30_2 = 0, var_30_3 - 1 do
				local var_30_7 = SteamServerBrowser.server(arg_30_0._engine_browser, iter_30_2)

				var_30_7.ip_port = var_30_7.ip_address .. ":" .. var_30_7.query_port

				local var_30_8 = SteamServerBrowser.data_all(arg_30_0._engine_browser, iter_30_2)

				var_30_8.server_info = var_30_7

				if arg_30_0:_filter_server(var_30_8) then
					var_30_6[#var_30_6 + 1] = var_30_8
				end
			end

			arg_30_0._state = "waiting"
		end
	end

	if arg_30_0._state ~= var_30_0 then
		printf("[SteamServerBrowserWrapper] Switched state from (%s) to (%s)", var_30_0, arg_30_0._state)
	end
end

function SteamServerBrowserWrapper._filter_server(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._filters

	for iter_31_0, iter_31_1 in pairs(var_31_0) do
		local var_31_1 = arg_31_1[iter_31_0]

		if not var_31_1 then
			printf("[SteamServerBrowserWrapper] Could not find value for server (%s)", iter_31_0)

			return false
		else
			printf("[SteamServerBrowserWrapper] Found value %s, %s from server", tostring(var_31_1), iter_31_0)
		end

		local var_31_2 = iter_31_1.value
		local var_31_3 = iter_31_1.compare_func
		local var_31_4 = iter_31_1.compare_name

		if not var_31_3(var_31_1, var_31_2) then
			printf("[SteamServerBrowserWrapper] Server failed on filter %s, server_value(%s) %s compare_value=(%s)", iter_31_0, var_31_1, var_31_4, var_31_2)

			return false
		end
	end

	return true
end
