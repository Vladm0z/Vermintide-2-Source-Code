-- chunkname: @scripts/managers/backend_playfab/backend_interface_cdn_resources_playfab.lua

local var_0_0 = require("PlayFab.json")

BackendInterfaceCdnResourcesPlayFab = class(BackendInterfaceCdnResourcesPlayFab)

local var_0_1 = 3000
local var_0_2 = 10
local var_0_3 = {
	failed = 2,
	loaded = 1
}

BackendInterfaceCdnResourcesPlayFab.init = function (arg_1_0, arg_1_1)
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._url_cache = {}
	arg_1_0._localization_status = {}
end

BackendInterfaceCdnResourcesPlayFab.ready = function (arg_2_0)
	return true
end

BackendInterfaceCdnResourcesPlayFab.load_backend_localizations = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(DLCSettings) do
		local var_3_2 = iter_3_1.backend_localizations

		if var_3_2 then
			for iter_3_2, iter_3_3 in pairs(var_3_2) do
				local var_3_3 = iter_3_3[arg_3_1] or iter_3_3.en

				var_3_0[#var_3_0 + 1] = var_3_3
				var_3_1[var_3_3] = iter_3_2
			end
		end
	end

	arg_3_0:get_resource_urls(var_3_0, callback(arg_3_0, "_cb_localization_urls_loaded", var_3_1, arg_3_2))
end

BackendInterfaceCdnResourcesPlayFab._cb_localization_urls_loaded = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	for iter_4_0, iter_4_1 in pairs(arg_4_1) do
		local var_4_0 = arg_4_3[iter_4_0]

		if var_4_0 then
			if IS_WINDOWS or IS_LINUX then
				Managers.curl:get(var_4_0, {}, callback(arg_4_0, "_cb_localization_loaded", iter_4_1, arg_4_2), nil, {})
			else
				Managers.rest_transport:get(var_4_0, {}, callback(arg_4_0, "_cb_localization_loaded", iter_4_1, arg_4_2), nil, nil)
			end
		else
			arg_4_0._localization_status[iter_4_1] = var_0_3.failed
		end
	end
end

BackendInterfaceCdnResourcesPlayFab._cb_localization_loaded = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	if arg_5_3 then
		local var_5_0, var_5_1 = pcall(var_0_0.decode, arg_5_6)

		if var_5_1 and type(var_5_1) == "table" then
			arg_5_0._localization_status[arg_5_1] = var_0_3.loaded

			local var_5_2 = {}

			for iter_5_0, iter_5_1 in pairs(var_5_1) do
				if iter_5_1 ~= "" then
					var_5_2[iter_5_0] = iter_5_1
				end
			end

			arg_5_2(var_5_2)

			return
		end
	end

	arg_5_0._localization_status[arg_5_1] = var_0_3.failed
end

local function var_0_4(arg_6_0, arg_6_1)
	local var_6_0 = {}

	for iter_6_0 = 1, #arg_6_0, arg_6_1 do
		var_6_0[#var_6_0 + 1] = table.slice(arg_6_0, iter_6_0, arg_6_1)
	end

	return var_6_0
end

BackendInterfaceCdnResourcesPlayFab.has_localization_loaded = function (arg_7_0, arg_7_1)
	return arg_7_0._localization_status[arg_7_1] == var_0_3.loaded
end

BackendInterfaceCdnResourcesPlayFab.has_localization_failed = function (arg_8_0, arg_8_1)
	return arg_8_0._localization_status[arg_8_1] == var_0_3.failed
end

BackendInterfaceCdnResourcesPlayFab.get_resource_urls = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = {}
	local var_9_1 = {}

	for iter_9_0 = 1, #arg_9_1 do
		local var_9_2 = arg_9_1[iter_9_0]
		local var_9_3 = arg_9_0:_get_url_from_cache(var_9_2)

		if var_9_3 then
			var_9_0[var_9_2] = var_9_3
		else
			var_9_1[#var_9_1 + 1] = var_9_2
		end
	end

	if #var_9_1 == 0 then
		arg_9_2(var_9_0)

		return
	end

	local var_9_4 = var_0_4(var_9_1, var_0_2)

	arg_9_0:_request_resource_urls(var_9_4, var_9_0, arg_9_2)
end

BackendInterfaceCdnResourcesPlayFab._request_resource_urls = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = table.remove(arg_10_1)
	local var_10_1 = {
		FunctionName = "getResourceURL",
		FunctionParameter = {
			identifiers = var_10_0
		}
	}

	arg_10_0._backend_mirror:request_queue():enqueue(var_10_1, callback(arg_10_0, "_request_resource_urls_cb", arg_10_1, arg_10_2, arg_10_3), false)
end

BackendInterfaceCdnResourcesPlayFab._request_resource_urls_cb = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_4.FunctionResult

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		arg_11_0:_add_url_to_cache(iter_11_0, iter_11_1, var_0_1)

		arg_11_2[iter_11_0] = iter_11_1
	end

	if #arg_11_1 == 0 then
		arg_11_3(arg_11_2)
	else
		arg_11_0:_request_resource_urls(arg_11_1, arg_11_2, arg_11_3)
	end
end

BackendInterfaceCdnResourcesPlayFab._add_url_to_cache = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0

	if arg_12_3 then
		var_12_0 = os.time() + arg_12_3
	end

	arg_12_0._url_cache[arg_12_1] = {
		url = arg_12_2,
		expire_time = var_12_0
	}
end

BackendInterfaceCdnResourcesPlayFab._get_url_from_cache = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._url_cache
	local var_13_1 = var_13_0[arg_13_1]

	if not var_13_1 then
		return nil
	end

	local var_13_2 = var_13_1.expire_time

	if var_13_2 and var_13_2 < os.time() then
		var_13_0[arg_13_1] = nil

		return nil
	end

	return var_13_1.url
end
