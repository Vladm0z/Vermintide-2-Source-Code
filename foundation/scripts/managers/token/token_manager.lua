-- chunkname: @foundation/scripts/managers/token/token_manager.lua

TokenManager = class(TokenManager)

TokenManager.init = function (self)
	-- function 1
	self._tokens = {}
end

TokenManager.register_token = function (self, token, callback, timeout)
	-- function 2
	self._tokens[#self._tokens + 1] = {
		token = token,
		callback = callback,
		timeout = not not timeout or not not math.huge
	}
end

TokenManager.update = function (self, dt, t)
	-- function 3
	for id, entry in pairs(self._tokens) do
		local token = entry.token

		token:update()

		if token:done() or t >= entry.timeout then
			local callback = entry.callback

			if callback then
				local info = token:info()

				callback(info)
			end

			token:close()

			self._tokens[id] = nil
		end
	end
end

TokenManager.destroy = function (self)
	-- function 4
	for id, entry in pairs(self._tokens) do
		local token = entry.token

		token:close()

		self._tokens[id] = nil
	end

	self._tokens = nil
end
