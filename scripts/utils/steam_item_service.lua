-- chunkname: @scripts/utils/steam_item_service.lua

SteamItemService = SteamItemService or {}

local function var_0_0(arg_1_0, arg_1_1)
	for iter_1_0 in string.gmatch(arg_1_0, "[^,]+") do
		arg_1_1[string.sub(iter_1_0, 1, 3)] = tonumber(string.sub(iter_1_0, 4))
	end

	return arg_1_1
end

local var_0_1 = {}

function SteamItemService.parse(arg_2_0)
	string.split_deprecated(arg_2_0, ";", var_0_1)

	if var_0_1[1] ~= "1" then
		table.clear(var_0_1)

		return nil, "unknown version"
	end

	local var_2_0 = {
		regular_prices = var_0_0(var_0_1[2], {})
	}
	local var_2_1 = var_0_1[3]

	if var_2_1 then
		var_2_0.discount_prices = var_0_0(string.sub(var_2_1, 34), {})

		local var_2_2 = string.sub(var_2_1, 1, 16)
		local var_2_3 = string.sub(var_2_1, 18, 33)
		local var_2_4 = os.date("!%Y%m%dT%H%M%SZ")

		var_2_0.discount_is_active = var_2_2 <= var_2_4 and var_2_4 < var_2_3
		var_2_0.discount_start = var_2_2
		var_2_0.discount_end = var_2_3
	end

	table.clear(var_0_1)

	return var_2_0
end

function SteamItemService.get_item_data(arg_3_0)
	local var_3_0 = SteamInventory.get_item_definition_property(arg_3_0, "price")

	if not var_3_0 then
		return nil, "unknown item"
	end

	return SteamItemService.parse(var_3_0)
end
