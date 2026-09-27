-- chunkname: @scripts/managers/news_ticker/news_ticker_token.lua

local NewsTickerToken = NewsTickerToken

NewsTickerToken = NewsTickerToken or class()
NewsTickerToken = NewsTickerToken

NewsTickerToken.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._loader = arg_1_1
	self._job = arg_1_2
end

NewsTickerToken.info = function (self)
	-- function 2
	if not self:done() and not UrlLoader.success(self._loader, self._job) then
		return UrlLoader.text(self._loader, self._job)
	else
		return "Failed loading news ticker"
	end
end

NewsTickerToken.update = function (arg_3_0)
	-- function 3
	return
end

NewsTickerToken.done = function (self)
	-- function 4
	return UrlLoader.done(self._loader, self._job)
end

NewsTickerToken.close = function (self)
	-- function 5
	UrlLoader.unload(self._loader, self._job)
end
