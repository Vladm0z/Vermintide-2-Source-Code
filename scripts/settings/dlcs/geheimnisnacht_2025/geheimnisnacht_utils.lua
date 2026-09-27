-- chunkname: @scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_utils.lua

require("scripts/utils/hash_utils")

local scripts_settings_dlcs_geheimnisnacht_2025_geheimnisnacht_map_settings = require("scripts/settings/dlcs/geheimnisnacht_2025/geheimnisnacht_map_settings")
local tbl = {}
local tbl_2 = {
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
	},
	[2026] = {
		"farmlands",
		"dlc_wizards_tower",
		"catacombs",
		"bell",
		"ussingen"
	}
}

tbl._cached_maps_by_event = {}

for k, v in pairs(tbl_2) do
	tbl._cached_maps_by_event["geheimnisnacht_" .. k] = v
end

tbl.event_by_year = function (arg_1_0)
	-- function 1
	return "geheimnisnacht_" .. arg_1_0
end

tbl.maps_by_year = function (arg_2_0, arg_2_1)
	-- function 2
	local event_by_year = tbl.event_by_year(arg_2_0)

	return tbl.maps_by_event(event_by_year, arg_2_1)
end

tbl.maps_by_event = function (arg_3_0, arg_3_1)
	-- function 3
	if not tbl._cached_maps_by_event[arg_3_0] then
		return tbl._cached_maps_by_event[arg_3_0]
	end

	if not arg_3_1 then
		return
	end

	local fnv32_hash = HashUtils.fnv32_hash(arg_3_0)
	local keys = table.keys(scripts_settings_dlcs_geheimnisnacht_2025_geheimnisnacht_map_settings)
	local tbl_2 = {}

	for i = 1, 5 do
		local var_3_3
		local var_3_4

		fnv32_hash, var_3_4 = Math.next_random(fnv32_hash, 1, #keys)
		tbl_2[i] = keys[var_3_4]

		table.remove(keys, var_3_4)
	end

	tbl._cached_maps_by_event[arg_3_0] = tbl_2

	return tbl_2
end

tbl.maps_by_live_event = function (arg_4_0)
	-- function 4
	local get_interface = Managers.backend:get_interface("live_events")
	local flag = not get_interface and get_interface:get_active_events()

	if not flag then
		for i = 1, #flag do
			local var_4_2 = flag[i]

			if not string.find(var_4_2, "geheimnisnacht_%d+") then
				return tbl.maps_by_event(var_4_2, arg_4_0)
			end
		end
	end

	if not arg_4_0 then
		return {}
	end
end

return tbl
