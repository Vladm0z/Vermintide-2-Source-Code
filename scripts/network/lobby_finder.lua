-- chunkname: @scripts/network/lobby_finder.lua

require("scripts/network/lobby_aux")

LobbyFinder = class(LobbyFinder)

if not script_data.verbose_lobby_finder or not print then
	local var_0_0 = NOP
end

local var_0_1 = script_data.verbose_lobby_finder and printf or NOP

LobbyFinder.init = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.config_file_name
	local var_1_1 = arg_1_1.project_hash

	arg_1_0._network_hash = LobbyAux.create_network_hash(var_1_0, var_1_1)
	arg_1_0._server_port = arg_1_1.server_port

	assert(arg_1_0._server_port, "Must specify port to LobbyFinder.")

	arg_1_0._cached_lobbies = {}
	arg_1_0._max_num_lobbies = arg_1_2
	arg_1_0._refreshing = false

	if IS_XB1 then
		arg_1_0._browser = LobbyInternal.lobby_browser()
	else
		arg_1_0._browser = LobbyInternal.client:create_lobby_browser()

		print("===========Lobbyfinder CREATED", arg_1_0._browser)
	end
end

LobbyFinder.get_lobby_browser = function (arg_2_0)
	return arg_2_0._browser
end

LobbyFinder.destroy = function (arg_3_0)
	if not IS_XB1 then
		LobbyInternal.client.destroy_lobby_browser(LobbyInternal.client, arg_3_0._browser)
		print("===========Lobbyfinder DESTROYED", arg_3_0._browser)
	end
end

LobbyFinder.add_filter_requirements = function (arg_4_0, arg_4_1, arg_4_2)
	LobbyInternal.add_filter_requirements(arg_4_1, arg_4_0._browser)

	if arg_4_2 then
		var_0_1("===========LobbyFinder:add_filter_requirements force refresh")
		arg_4_0:refresh()
	end

	table.clear(arg_4_0._cached_lobbies)
end

LobbyFinder.network_hash = function (arg_5_0)
	return arg_5_0._network_hash
end

LobbyFinder.lobbies = function (arg_6_0)
	return arg_6_0._cached_lobbies
end

LobbyFinder.latest_filter_lobbies = function (arg_7_0)
	print("[LobbyFinder]:latest_filter_lobbies is deprecated")
end

LobbyFinder.refresh = function (arg_8_0)
	var_0_1("===========LobbyFinder:refresh() _refresing=%s", arg_8_0._refreshing)

	if not arg_8_0._refreshing then
		arg_8_0._browser:refresh(arg_8_0._server_port)

		arg_8_0._refreshing = true
	end
end

LobbyFinder.is_refreshing = function (arg_9_0)
	return arg_9_0._refreshing
end

LobbyFinder.update = function (arg_10_0, arg_10_1)
	if arg_10_0._refreshing then
		local var_10_0 = arg_10_0._browser

		if not var_10_0:is_refreshing() then
			local var_10_1 = arg_10_0._cached_lobbies

			table.clear_array(var_10_1)

			local var_10_2 = var_10_0:num_lobbies()
			local var_10_3 = arg_10_0._max_num_lobbies

			if var_10_3 then
				var_10_2 = math.min(var_10_3, var_10_2)
			end

			var_0_1("===========Lobbyfinder REFRESHING num_lobbies: %s", var_10_2)

			for iter_10_0 = 0, var_10_2 - 1 do
				local var_10_4 = LobbyInternal.get_lobby(var_10_0, iter_10_0)

				if var_10_4.network_hash == arg_10_0._network_hash and LobbyAux.verify_lobby_data(var_10_4) then
					var_10_1[#var_10_1 + 1] = var_10_4
					var_10_4.valid = true

					var_0_1("=======================Found valid lobby!")
				end
			end

			arg_10_0._cached_lobbies = var_10_1
			arg_10_0._refreshing = false
		end
	end
end
