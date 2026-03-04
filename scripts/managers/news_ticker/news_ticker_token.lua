-- chunkname: @scripts/managers/news_ticker/news_ticker_token.lua

NewsTickerToken = NewsTickerToken or class()

NewsTickerToken.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._loader = arg_1_1
	arg_1_0._job = arg_1_2
end

NewsTickerToken.info = function (arg_2_0)
	if arg_2_0:done() and UrlLoader.success(arg_2_0._loader, arg_2_0._job) then
		return UrlLoader.text(arg_2_0._loader, arg_2_0._job)
	else
		return "Failed loading news ticker"
	end
end

NewsTickerToken.update = function (arg_3_0)
	return
end

NewsTickerToken.done = function (arg_4_0)
	return UrlLoader.done(arg_4_0._loader, arg_4_0._job)
end

NewsTickerToken.close = function (arg_5_0)
	UrlLoader.unload(arg_5_0._loader, arg_5_0._job)
end
