-- chunkname: @scripts/network/game_server/game_server_finder.lua

GameServerFinder = class(GameServerFinder)

local var_0_0 = 10

function GameServerFinder.init(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.config_file_name
	local var_1_1 = arg_1_1.project_hash

	arg_1_0._network_hash = GameServerAux.create_network_hash(var_1_0, var_1_1)
	arg_1_0._cached_servers = {}
	arg_1_0._pending_refresh_request = false
	arg_1_0._browser_wrapper = GameServerInternal.server_browser() or GameServerInternal.create_server_browser_wrapper()
end

function GameServerFinder.destroy(arg_2_0)
	GameServerInternal.forget_server_browser()
end

function GameServerFinder.refresh(arg_3_0)
	arg_3_0._browser_wrapper:refresh()

	arg_3_0._pending_refresh_request = true

	table.clear(arg_3_0._cached_servers)
end

function GameServerFinder.set_search_type(arg_4_0, arg_4_1)
	arg_4_0._browser_wrapper:set_search_type(arg_4_1)
end

function GameServerFinder.add_to_favorites(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0._browser_wrapper:add_to_favorites(arg_5_1, arg_5_2, arg_5_3)
end

function GameServerFinder.remove_from_favorites(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0._browser_wrapper:remove_from_favorites(arg_6_1, arg_6_2, arg_6_3)
end

function GameServerFinder.add_filter_requirements(arg_7_0, arg_7_1, arg_7_2)
	GameServerInternal.add_filter_requirements(arg_7_1)

	arg_7_0._skip_verify_lobby_data = arg_7_2
end

function GameServerFinder.servers(arg_8_0)
	return arg_8_0._cached_servers
end

function GameServerFinder.is_refreshing(arg_9_0)
	return arg_9_0._pending_refresh_request
end

function GameServerFinder.update(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._browser_wrapper

	var_10_0:update(arg_10_1)

	local var_10_1 = var_10_0:is_refreshing()

	if arg_10_0._pending_refresh_request and not var_10_1 then
		local var_10_2 = arg_10_0._cached_servers
		local var_10_3 = var_10_0:servers()

		for iter_10_0, iter_10_1 in ipairs(var_10_3) do
			if arg_10_0._skip_verify_lobby_data or GameServerAux.verify_lobby_data(iter_10_1) then
				iter_10_1.valid = true
				var_10_2[#var_10_2 + 1] = iter_10_1
			end
		end

		arg_10_0._pending_refresh_request = false
	end
end
