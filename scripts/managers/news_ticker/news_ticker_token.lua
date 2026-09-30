-- chunkname: @scripts/managers/news_ticker/news_ticker_token.lua

NewsTickerToken = NewsTickerToken

NewsTickerToken.init = function (self, loader, job)
	-- function 1
	self._loader = loader
	self._job = job
end

NewsTickerToken.info = function (self)
	-- function 2
	if self:done() and UrlLoader.success(self._loader, self._job) then
		return UrlLoader.text(self._loader, self._job)
	else
		return "Failed loading news ticker"
	end
end

NewsTickerToken.update = function (self)
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
