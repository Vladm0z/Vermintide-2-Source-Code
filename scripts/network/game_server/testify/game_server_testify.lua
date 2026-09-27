-- chunkname: @scripts/network/game_server/testify/game_server_testify.lua

return {
	wait_for_lobby_data_value = function (self, arg_1_1)
		-- function 1
		local key = arg_1_1.key
		local value = arg_1_1.value

		if self:lobby_data(key) ~= value then
			return Testify.RETRY
		end
	end
}
