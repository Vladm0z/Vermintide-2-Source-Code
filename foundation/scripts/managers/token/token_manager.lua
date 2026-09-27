-- chunkname: @foundation/scripts/managers/token/token_manager.lua

TokenManager = class(TokenManager)

TokenManager.init = function (self)
	-- function 1
	self._tokens = {}
end

TokenManager.register_token = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_0._tokens[#arg_2_0._tokens + 1] = {
		token = arg_2_1,
		callback = arg_2_2,
		timeout = arg_2_3 or math.huge
	}
end

TokenManager.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	for k, v in pairs(self._tokens) do
		local token = v.token

		token:update()

		if not (token:done() or not (arg_3_2 >= v.timeout)) then
			local callback = v.callback

			if not callback then
				local info = token:info()

				callback(info)
			end

			token:close()

			self._tokens[k] = nil
		end
	end
end

TokenManager.destroy = function (self)
	-- function 4
	for k, v in pairs(self._tokens) do
		v.token:close()

		self._tokens[k] = nil
	end

	self._tokens = nil
end
