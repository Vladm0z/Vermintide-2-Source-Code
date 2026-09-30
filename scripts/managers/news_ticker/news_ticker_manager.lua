-- chunkname: @scripts/managers/news_ticker/news_ticker_manager.lua

require("scripts/managers/news_ticker/news_ticker_token")

NewsTickerManager = class(NewsTickerManager)

NewsTickerManager.init = function (self)
	-- function 1
	self._server_name = "cdn.fatsharkgames.se"

	if IS_WINDOWS then
		self._loading_screen_url = Development.parameter("news_ticker_url")
		self._ingame_url = Development.parameter("news_ticker_ingame_url")
	else
		self._loading_screen_url = Development.parameter("news_ticker_url_xb1")
		self._ingame_url = Development.parameter("news_ticker_ingame_url_xb1")
	end

	self._loading_screen_text = nil
	self._ingame_text = nil
end

local function lines(str)
	-- function 2
	local t = {}

	local function helper(line)
		-- function 3
		table.insert(t, line)

		return ""
	end

	helper((str:gsub("(.-)\r?\n", helper)))

	return t
end

NewsTickerManager.update = function (self, dt)
	-- function 4
	return
end

NewsTickerManager.destroy = function (self)
	-- function 5
	return
end

local function _callback_wrapper(success, http_code, response_headers, data, userdata_callback)
	-- function 6
	local info = {
		done = false
	}

	if success and http_code >= 200 and http_code < 300 then
		info.done = true
		info.data = data
	end

	userdata_callback(info)
end

NewsTickerManager._load = function (self, url, callback)
	-- function 7
	if rawget(_G, "Curl") then
		Managers.curl:get(url, nil, _callback_wrapper, callback)
	elseif rawget(_G, "Http") then
		local message = Http.get_uri(self._server_name, 80, url)

		if message then
			local is_ok = string.find(message, "HTTP/1.1 200 OK")

			if is_ok then
				local start_idx, end_idx = string.find(message, "\r\n\r\n")
				local formatted_message = ""

				if end_idx then
					formatted_message = string.sub(message, end_idx + 1)
				end

				local info = {
					done = true,
					data = formatted_message
				}

				callback(info)

				return
			end
		end

		local info = {
			done = true,
			data = ""
		}

		callback(info)
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

	self:_load(Development.parameter("news_ticker_url_xb1"), callback(self, "cb_loading_screen_loaded"))
end

NewsTickerManager.cb_loading_screen_loaded = function (self, info)
	-- function 9
	if self._refreshing_loading_screen_message and info.done then
		local str = info.data

		if str and str ~= "" then
			self._loading_screen_text = str
		else
			self._loading_screen_text = nil
		end

		self._refreshing_loading_screen_message = nil
	end
end

NewsTickerManager.loading_screen_text = function (self)
	-- function 10
	local text = self._loading_screen_text

	return text
end

NewsTickerManager.refresh_ingame_message = function (self)
	-- function 11
	self._ingame_text = nil
	self._refreshing_ingame_message = true

	self:_load(Development.parameter("news_ticker_ingame_url_xb1"), callback(self, "cb_ingame_loaded"))
end

NewsTickerManager.refreshing_ingame_message = function (self)
	-- function 12
	return self._refreshing_ingame_message
end

NewsTickerManager.cb_ingame_loaded = function (self, info)
	-- function 13
	if self._refreshing_ingame_message and info.done then
		local str = info.data

		if str and str ~= "" then
			self._ingame_text = str
		else
			self._ingame_text = nil
		end

		self._refreshing_ingame_message = nil
	end
end

NewsTickerManager.ingame_text = function (self)
	-- function 14
	local text = self._ingame_text

	return text
end
