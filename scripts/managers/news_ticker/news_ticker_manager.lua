-- chunkname: @scripts/managers/news_ticker/news_ticker_manager.lua

require("scripts/managers/news_ticker/news_ticker_token")

NewsTickerManager = class(NewsTickerManager)

NewsTickerManager.init = function (arg_1_0)
	arg_1_0._server_name = "cdn.fatsharkgames.se"

	if IS_WINDOWS then
		arg_1_0._loading_screen_url = Development.parameter("news_ticker_url") or "http://cdn.fatsharkgames.se/vermintide_2_news_ticker.txt"
		arg_1_0._ingame_url = Development.parameter("news_ticker_ingame_url") or "http://cdn.fatsharkgames.se/vermintide_2_news_ticker_ingame.txt"
	else
		arg_1_0._loading_screen_url = Development.parameter("news_ticker_url_xb1") or "vermintide_2_news_ticker_" .. PLATFORM .. ".txt"
		arg_1_0._ingame_url = Development.parameter("news_ticker_ingame_url_xb1") or "vermintide_2_news_ticker_ingame_" .. PLATFORM .. ".txt"
	end

	arg_1_0._loading_screen_text = nil
	arg_1_0._ingame_text = nil
end

local function var_0_0(arg_2_0)
	local var_2_0 = {}

	local function var_2_1(arg_3_0)
		table.insert(var_2_0, arg_3_0)

		return ""
	end

	var_2_1((arg_2_0:gsub("(.-)\r?\n", var_2_1)))

	return var_2_0
end

NewsTickerManager.update = function (arg_4_0, arg_4_1)
	return
end

NewsTickerManager.destroy = function (arg_5_0)
	return
end

local function var_0_1(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = {
		done = false
	}

	if arg_6_0 and arg_6_1 >= 200 and arg_6_1 < 300 then
		var_6_0.done = true
		var_6_0.data = arg_6_3
	end

	arg_6_4(var_6_0)
end

NewsTickerManager._load = function (arg_7_0, arg_7_1, arg_7_2)
	if rawget(_G, "Curl") then
		Managers.curl:get(arg_7_1, nil, var_0_1, arg_7_2)
	elseif rawget(_G, "Http") then
		local var_7_0 = Http.get_uri(arg_7_0._server_name, 80, arg_7_1)

		if var_7_0 and (string.find(var_7_0, "HTTP/1.1 200 OK") or string.find(var_7_0, "HTTP/1.0 200 OK")) then
			local var_7_1, var_7_2 = string.find(var_7_0, "\r\n\r\n")
			local var_7_3 = ""

			if var_7_2 then
				var_7_3 = string.sub(var_7_0, var_7_2 + 1)
			end

			local var_7_4 = {
				done = true,
				data = var_7_3
			}

			arg_7_2(var_7_4)

			return
		end

		local var_7_5 = {
			done = true,
			data = ""
		}

		arg_7_2(var_7_5)
	else
		arg_7_0:cb_loading_screen_loaded({
			done = true,
			data = "This executable is built without Curl or Http. News ticker will be unavailable."
		})
	end
end

NewsTickerManager.refresh_loading_screen_message = function (arg_8_0)
	arg_8_0._loading_screen_text = nil
	arg_8_0._refreshing_loading_screen_message = true

	arg_8_0:_load(Development.parameter("news_ticker_url_xb1") or arg_8_0._loading_screen_url, callback(arg_8_0, "cb_loading_screen_loaded"))
end

NewsTickerManager.cb_loading_screen_loaded = function (arg_9_0, arg_9_1)
	if arg_9_0._refreshing_loading_screen_message and arg_9_1.done then
		local var_9_0 = arg_9_1.data

		if var_9_0 and var_9_0 ~= "" then
			arg_9_0._loading_screen_text = var_9_0
		else
			arg_9_0._loading_screen_text = nil
		end

		arg_9_0._refreshing_loading_screen_message = nil
	end
end

NewsTickerManager.loading_screen_text = function (arg_10_0)
	return arg_10_0._loading_screen_text
end

NewsTickerManager.refresh_ingame_message = function (arg_11_0)
	arg_11_0._ingame_text = nil
	arg_11_0._refreshing_ingame_message = true

	arg_11_0:_load(Development.parameter("news_ticker_ingame_url_xb1") or arg_11_0._ingame_url, callback(arg_11_0, "cb_ingame_loaded"))
end

NewsTickerManager.refreshing_ingame_message = function (arg_12_0)
	return arg_12_0._refreshing_ingame_message
end

NewsTickerManager.cb_ingame_loaded = function (arg_13_0, arg_13_1)
	if arg_13_0._refreshing_ingame_message and arg_13_1.done then
		local var_13_0 = arg_13_1.data

		if var_13_0 and var_13_0 ~= "" then
			arg_13_0._ingame_text = var_13_0
		else
			arg_13_0._ingame_text = nil
		end

		arg_13_0._refreshing_ingame_message = nil
	end
end

NewsTickerManager.ingame_text = function (arg_14_0)
	return arg_14_0._ingame_text
end
