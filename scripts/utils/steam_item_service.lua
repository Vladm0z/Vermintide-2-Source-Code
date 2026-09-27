-- chunkname: @scripts/utils/steam_item_service.lua

local SteamItemService = SteamItemService

SteamItemService = SteamItemService or {}
SteamItemService = SteamItemService

local function fn(arg_1_0, arg_1_1)
	-- function 1
	for iter_1_0 in string.gmatch(arg_1_0, "[^,]+") do
		arg_1_1[string.sub(iter_1_0, 1, 3)] = tonumber(string.sub(iter_1_0, 4))
	end

	return arg_1_1
end

local tbl = {}

SteamItemService.parse = function (arg_2_0)
	-- function 2
	string.split_deprecated(arg_2_0, ";", tbl)

	if tbl[1] ~= "1" then
		table.clear(tbl)

		return nil, "unknown version"
	end

	local tbl_2 = {
		regular_prices = fn(tbl[2], {})
	}
	local var_2_1 = tbl[3]

	if not var_2_1 then
		tbl_2.discount_prices = fn(string.sub(var_2_1, 34), {})

		local sub = string.sub(var_2_1, 1, 16)
		local sub_2 = string.sub(var_2_1, 18, 33)
		local date = os.date("!%Y%m%dT%H%M%SZ")

		tbl_2.discount_is_active = not (sub <= date) or date < sub_2
		tbl_2.discount_start = sub
		tbl_2.discount_end = sub_2
	end

	table.clear(tbl)

	return tbl_2
end

SteamItemService.get_item_data = function (arg_3_0)
	-- function 3
	local get_item_definition_property = SteamInventory.get_item_definition_property(arg_3_0, "price")

	if not get_item_definition_property then
		return nil, "unknown item"
	end

	return SteamItemService.parse(get_item_definition_property)
end
