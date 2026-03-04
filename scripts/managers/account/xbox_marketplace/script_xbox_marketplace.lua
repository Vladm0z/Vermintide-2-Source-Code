-- chunkname: @scripts/managers/account/xbox_marketplace/script_xbox_marketplace.lua

ScriptXboxMarketplace = class(ScriptXboxMarketplace)

function ScriptXboxMarketplace.init(arg_1_0)
	arg_1_0._state = nil
	arg_1_0._response_cb = nil
	arg_1_0._error_code = nil

	local var_1_0 = Application.settings()

	arg_1_0._initialized = XboxMarketplace.initialize(var_1_0.xb1_product_id)
end

function ScriptXboxMarketplace.destroy(arg_2_0)
	XboxMarketplace.shutdown()
end

function ScriptXboxMarketplace.update(arg_3_0, arg_3_1)
	if not arg_3_0._state or not arg_3_0._initialized then
		return
	end

	arg_3_0[arg_3_0._state](arg_3_0, arg_3_1)
end

function ScriptXboxMarketplace.get_product_details(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not XboxMarketplace.get_catalog_items(arg_4_1, unpack(arg_4_2)) then
		arg_4_3({
			error = "failed calling XboxMarketplace.get_catalog_items"
		})
	else
		arg_4_0._state = "_waiting_for_catalog_details_result"
		arg_4_0._response_cb = arg_4_3
	end
end

function ScriptXboxMarketplace._waiting_for_catalog_details_result(arg_5_0, arg_5_1)
	local var_5_0, var_5_1 = XboxMarketplace.status()

	if var_5_0 then
		arg_5_0._error_code = var_5_1
		arg_5_0._state = "_get_catalog_details_information"
	end
end

function ScriptXboxMarketplace._get_catalog_details_information(arg_6_0, arg_6_1)
	local var_6_0

	if arg_6_0._error_code ~= 0 then
		local var_6_1 = "0x" .. string.sub(string.format("%02X", arg_6_0._error_code), 9)

		var_6_0 = string.format("There was an error while getting catalog items with the error code %q", var_6_1)
	end

	local var_6_2 = {
		error = var_6_0,
		product_details = XboxMarketplace.get_result()
	}

	arg_6_0._response_cb(var_6_2)

	arg_6_0._state = "_cleanup"
end

function ScriptXboxMarketplace._cleanup(arg_7_0, arg_7_1)
	XboxMarketplace.release_catalog()

	arg_7_0._state = nil
	arg_7_0._response_cb = nil
	arg_7_0._error_code = nil
end
