-- chunkname: @scripts/managers/account/xbox_marketplace/script_xbox_marketplace.lua

ScriptXboxMarketplace = class(ScriptXboxMarketplace)

ScriptXboxMarketplace.init = function (self)
	-- function 1
	self._state = nil
	self._response_cb = nil
	self._error_code = nil

	local settings = Application.settings()

	self._initialized = XboxMarketplace.initialize(settings.xb1_product_id)
end

ScriptXboxMarketplace.destroy = function (arg_2_0)
	-- function 2
	XboxMarketplace.shutdown()
end

ScriptXboxMarketplace.update = function (self, arg_3_1)
	-- function 3
	if not (not self._state and self._initialized) then
		return
	end

	self[self._state](self, arg_3_1)
end

ScriptXboxMarketplace.get_product_details = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not XboxMarketplace.get_catalog_items(arg_4_1, unpack(arg_4_2)) then
		arg_4_3({
			error = "failed calling XboxMarketplace.get_catalog_items"
		})
	else
		self._state = "_waiting_for_catalog_details_result"
		self._response_cb = arg_4_3
	end
end

ScriptXboxMarketplace._waiting_for_catalog_details_result = function (self, arg_5_1)
	-- function 5
	local status, var_5_1 = XboxMarketplace.status()

	if not status then
		self._error_code = var_5_1
		self._state = "_get_catalog_details_information"
	end
end

ScriptXboxMarketplace._get_catalog_details_information = function (self, arg_6_1)
	-- function 6
	local var_6_0

	if self._error_code ~= 0 then
		local str = "0x" .. string.sub(string.format("%02X", self._error_code), 9)

		var_6_0 = string.format("There was an error while getting catalog items with the error code %q", str)
	end

	local tbl = {
		error = var_6_0,
		product_details = XboxMarketplace.get_result()
	}

	self._response_cb(tbl)

	self._state = "_cleanup"
end

ScriptXboxMarketplace._cleanup = function (self, arg_7_1)
	-- function 7
	XboxMarketplace.release_catalog()

	self._state = nil
	self._response_cb = nil
	self._error_code = nil
end
