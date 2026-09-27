-- chunkname: @scripts/managers/backend_playfab/backend_interface_cdn_resources_playfab.lua

local json = require("PlayFab.json")

BackendInterfaceCdnResourcesPlayFab = class(BackendInterfaceCdnResourcesPlayFab)

local num = 3000
local num_2 = 10
local tbl = {
	failed = 2,
	loaded = 1
}

BackendInterfaceCdnResourcesPlayFab.init = function (self, arg_1_1)
	-- function 1
	self._backend_mirror = arg_1_1
	self._url_cache = {}
	self._localization_status = {}
end

BackendInterfaceCdnResourcesPlayFab.ready = function (arg_2_0)
	-- function 2
	return true
end

BackendInterfaceCdnResourcesPlayFab.load_backend_localizations = function (self, arg_3_1, arg_3_2)
	-- function 3
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(DLCSettings) do
		local backend_localizations = v.backend_localizations

		if not backend_localizations then
			for k_2, v_2 in pairs(backend_localizations) do
				local var_3_3 = v_2[arg_3_1]

				var_3_3 = var_3_3 or v_2.en
				tbl[#tbl + 1] = var_3_3
				tbl_2[var_3_3] = k_2
			end
		end
	end

	self:get_resource_urls(tbl, callback(self, "_cb_localization_urls_loaded", tbl_2, arg_3_2))
end

BackendInterfaceCdnResourcesPlayFab._cb_localization_urls_loaded = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	for k, v in pairs(arg_4_1) do
		local var_4_0 = arg_4_3[k]

		if not var_4_0 then
			if IS_WINDOWS or not IS_LINUX then
				Managers.curl:get(var_4_0, {}, callback(arg_4_0, "_cb_localization_loaded", v, arg_4_2), nil, {})
			else
				Managers.rest_transport:get(var_4_0, {}, callback(arg_4_0, "_cb_localization_loaded", v, arg_4_2), nil, nil)
			end
		else
			arg_4_0._localization_status[v] = tbl.failed
		end
	end
end

BackendInterfaceCdnResourcesPlayFab._cb_localization_loaded = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	if not arg_5_3 then
		local var_5_0, var_5_1 = pcall(json.decode, arg_5_6)

		if not (not var_5_1 and type(var_5_1) ~= "table") then
			arg_5_0._localization_status[arg_5_1] = tbl.loaded

			local tbl_2 = {}

			for k, v in pairs(var_5_1) do
				if v ~= "" then
					tbl_2[k] = v
				end
			end

			arg_5_2(tbl_2)

			return
		end
	end

	arg_5_0._localization_status[arg_5_1] = tbl.failed
end

local function fn(arg_6_0, arg_6_1)
	-- function 6
	local tbl = {}

	for i = 1, #arg_6_0, arg_6_1 do
		tbl[#tbl + 1] = table.slice(arg_6_0, i, arg_6_1)
	end

	return tbl
end

BackendInterfaceCdnResourcesPlayFab.has_localization_loaded = function (self, arg_7_1)
	-- function 7
	return self._localization_status[arg_7_1] == tbl.loaded
end

BackendInterfaceCdnResourcesPlayFab.has_localization_failed = function (self, arg_8_1)
	-- function 8
	return self._localization_status[arg_8_1] == tbl.failed
end

BackendInterfaceCdnResourcesPlayFab.get_resource_urls = function (self, arg_9_1, arg_9_2)
	-- function 9
	local tbl = {}
	local tbl_2 = {}

	for i = 1, #arg_9_1 do
		local var_9_2 = arg_9_1[i]
		local _get_url_from_cache = self:_get_url_from_cache(var_9_2)

		if not _get_url_from_cache then
			tbl[var_9_2] = _get_url_from_cache
		else
			tbl_2[#tbl_2 + 1] = var_9_2
		end
	end

	if #tbl_2 == 0 then
		arg_9_2(tbl)

		return
	end

	local var_9_4 = fn(tbl_2, num_2)

	self:_request_resource_urls(var_9_4, tbl, arg_9_2)
end

BackendInterfaceCdnResourcesPlayFab._request_resource_urls = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local remove = table.remove(arg_10_1)
	local tbl = {
		FunctionName = "getResourceURL",
		FunctionParameter = {
			identifiers = remove
		}
	}

	self._backend_mirror:request_queue():enqueue(tbl, callback(self, "_request_resource_urls_cb", arg_10_1, arg_10_2, arg_10_3), false)
end

BackendInterfaceCdnResourcesPlayFab._request_resource_urls_cb = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local FunctionResult = arg_11_4.FunctionResult

	for k, v in pairs(FunctionResult) do
		self:_add_url_to_cache(k, v, num)

		arg_11_2[k] = v
	end

	if #arg_11_1 == 0 then
		arg_11_3(arg_11_2)
	else
		self:_request_resource_urls(arg_11_1, arg_11_2, arg_11_3)
	end
end

BackendInterfaceCdnResourcesPlayFab._add_url_to_cache = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0

	if not arg_12_3 then
		var_12_0 = os.time() + arg_12_3
	end

	arg_12_0._url_cache[arg_12_1] = {
		url = arg_12_2,
		expire_time = var_12_0
	}
end

BackendInterfaceCdnResourcesPlayFab._get_url_from_cache = function (self, arg_13_1)
	-- function 13
	local _url_cache = self._url_cache
	local var_13_1 = _url_cache[arg_13_1]

	if not var_13_1 then
		return nil
	end

	local expire_time = var_13_1.expire_time

	if not (not expire_time and not (expire_time < os.time())) then
		_url_cache[arg_13_1] = nil

		return nil
	end

	return var_13_1.url
end
