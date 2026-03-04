-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_utils.lua

local var_0_0 = require("scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_map_settings")
local var_0_1 = {}
local var_0_2 = {
	[2021] = {
		"dlc_portals",
		"bell",
		"military",
		"dlc_castle",
		"ussingen"
	},
	[2022] = {
		"catacombs",
		"mines",
		"ground_zero",
		"elven_ruins",
		"farmlands"
	},
	[2023] = {
		"warcamp",
		"nurgle",
		"dlc_wizards_tower",
		"dlc_bastion",
		"dlc_dwarf_beacons"
	},
	[2024] = {
		"dlc_dwarf_whaling",
		"catacombs",
		"ground_zero",
		"elven_ruins",
		"farmlands"
	},
	[2025] = {
		"dlc_termite_1",
		"military",
		"mines",
		"warcamp",
		"dlc_portals"
	}
}

var_0_1._cached_maps_by_event = {}

for iter_0_0, iter_0_1 in pairs(var_0_2) do
	var_0_1._cached_maps_by_event["geheimnisnacht_" .. iter_0_0] = iter_0_1
end

var_0_1.event_by_year = function (arg_1_0)
	return "geheimnisnacht_" .. arg_1_0
end

var_0_1.maps_by_year = function (arg_2_0, arg_2_1)
	local var_2_0 = var_0_1.event_by_year(arg_2_0)

	return var_0_1.maps_by_event(var_2_0, arg_2_1)
end

var_0_1.maps_by_event = function (arg_3_0, arg_3_1)
	if var_0_1._cached_maps_by_event[arg_3_0] then
		return var_0_1._cached_maps_by_event[arg_3_0]
	end

	if not arg_3_1 then
		return
	end

	local var_3_0 = HashUtils.fnv32_hash(arg_3_0)
	local var_3_1 = table.keys(var_0_0)
	local var_3_2 = {}

	for iter_3_0 = 1, 5 do
		local var_3_3
		local var_3_4

		var_3_0, var_3_4 = Math.next_random(var_3_0, 1, #var_3_1)
		var_3_2[iter_3_0] = var_3_1[var_3_4]

		table.remove(var_3_1, var_3_4)
	end

	var_0_1._cached_maps_by_event[arg_3_0] = var_3_2

	return var_3_2
end

var_0_1.maps_by_live_event = function (arg_4_0)
	local var_4_0 = Managers.backend:get_interface("live_events")
	local var_4_1 = var_4_0 and var_4_0:get_active_events()

	if var_4_1 then
		for iter_4_0 = 1, #var_4_1 do
			local var_4_2 = var_4_1[iter_4_0]

			if string.find(var_4_2, "geheimnisnacht_%d+") then
				return var_0_1.maps_by_event(var_4_2, arg_4_0)
			end
		end
	end

	if arg_4_0 then
		return {}
	end
end

return var_0_1
