-- chunkname: @scripts/network/game_server/testify/game_server_testify.lua

return {
	wait_for_lobby_data_value = function(arg_1_0, arg_1_1)
		local var_1_0 = arg_1_1.key
		local var_1_1 = arg_1_1.value

		if arg_1_0:lobby_data(var_1_0) ~= var_1_1 then
			return Testify.RETRY
		end
	end
}
