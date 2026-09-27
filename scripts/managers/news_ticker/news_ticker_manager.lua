-- chunkname: @scripts/managers/news_ticker/news_ticker_manager.lua

require("scripts/managers/news_ticker/news_ticker_token")

NewsTickerManager = class(NewsTickerManager)

NewsTickerManager.init = function (self)
	-- function 1
	self._server_name = "cdn.fatsharkgames.se"

	if not IS_WINDOWS then
		local parameter = Development.parameter("news_ticker_url")

		parameter = parameter or "http://cdn.fatsharkgames.se/vermintide_2_news_ticker.txt"
		self._loading_screen_url = parameter

		local parameter_2 = Development.parameter("news_ticker_ingame_url")

		parameter_2 = parameter_2 or "http://cdn.fatsharkgames.se/vermintide_2_news_ticker_ingame.txt"
		self._ingame_url = parameter_2
	else
		local parameter_3 = Development.parameter("news_ticker_url_xb1")

		parameter_3 = parameter_3 or "vermintide_2_news_ticker_" .. PLATFORM .. ".txt"
		self._loading_screen_url = parameter_3

		local parameter_4 = Development.parameter("news_ticker_ingame_url_xb1")

		parameter_4 = parameter_4 or "vermintide_2_news_ticker_ingame_" .. PLATFORM .. ".txt"
		self._ingame_url = parameter_4
	end

	self._loading_screen_text = nil
	self._ingame_text = nil
end

local function fn(self)
	-- function 2
	local tbl = {}

	local function fn(arg_3_0)
		-- function 3
		table.insert(tbl, arg_3_0)

		return ""
	end

	fn((self:gsub("(.-)\r?\n", fn)))

	return tbl
end

NewsTickerManager.update = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

NewsTickerManager.destroy = function (arg_5_0)
	-- function 5
	return
end

local function fn_2(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local tbl = {
		done = false
	}

	if not (not arg_6_0 and not (arg_6_1 >= 200) or not (arg_6_1 < 300)) then
		tbl.done = true
		tbl.data = arg_6_3
	end

	arg_6_4(tbl)
end

NewsTickerManager._load = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not rawget(_G, "Curl") then
		Managers.curl:get(arg_7_1, nil, fn_2, arg_7_2)
	elseif not rawget(_G, "Http") then
		local get_uri = Http.get_uri(self._server_name, 80, arg_7_1)

		if not get_uri then
			local find = string.find(get_uri, "HTTP/1.1 200 OK")

			find = find or string.find(get_uri, "HTTP/1.0 200 OK")

			if not find then
				local find_2, var_7_3 = string.find(get_uri, "\r\n\r\n")
				local str = ""

				if not var_7_3 then
					str = string.sub(get_uri, var_7_3 + 1)
				end

				local tbl = {
					done = true,
					data = str
				}

				arg_7_2(tbl)

				return
			end
		end

		local tbl_2 = {
			done = true,
			data = ""
		}

		arg_7_2(tbl_2)
	else
		self:cb_loading_screen_loaded({
			done = true,
			data = "This executable is built without Curl or Http. News ticker will be unavailable."
		})
	end
end

NewsTickerManager.refresh_loading_screen_message = function (self)
	-- function 8
	self._loading_screen_text = nil
	self._refreshing_loading_screen_message = true

	local var_8_0 = self
	local _load = self._load
	local parameter = Development.parameter("news_ticker_url_xb1")

	parameter = parameter or self._loading_screen_url

	_load(var_8_0, parameter, callback(self, "cb_loading_screen_loaded"))
end

NewsTickerManager.cb_loading_screen_loaded = function (self, arg_9_1)
	-- function 9
	if not self._refreshing_loading_screen_message and not arg_9_1.done then
		local data = arg_9_1.data

		if not (not data and data == "") then
			self._loading_screen_text = data
		else
			self._loading_screen_text = nil
		end

		self._refreshing_loading_screen_message = nil
	end
end

NewsTickerManager.loading_screen_text = function (self)
	-- function 10
	return self._loading_screen_text
end

NewsTickerManager.refresh_ingame_message = function (self)
	-- function 11
	self._ingame_text = nil
	self._refreshing_ingame_message = true

	local var_11_0 = self
	local _load = self._load
	local parameter = Development.parameter("news_ticker_ingame_url_xb1")

	parameter = parameter or self._ingame_url

	_load(var_11_0, parameter, callback(self, "cb_ingame_loaded"))
end

NewsTickerManager.refreshing_ingame_message = function (self)
	-- function 12
	return self._refreshing_ingame_message
end

NewsTickerManager.cb_ingame_loaded = function (self, arg_13_1)
	-- function 13
	if not self._refreshing_ingame_message and not arg_13_1.done then
		local data = arg_13_1.data

		if not (not data and data == "") then
			self._ingame_text = data
		else
			self._ingame_text = nil
		end

		self._refreshing_ingame_message = nil
	end
end

NewsTickerManager.ingame_text = function (self)
	-- function 14
	return self._ingame_text
end
