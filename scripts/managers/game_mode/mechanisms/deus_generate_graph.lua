-- chunkname: @scripts/managers/game_mode/mechanisms/deus_generate_graph.lua

require("scripts/managers/game_mode/mechanisms/deus_base_graph_generator")
require("scripts/managers/game_mode/mechanisms/deus_layout_base_graph")
require("scripts/managers/game_mode/mechanisms/deus_populate_graph")

local scripts_settings_dlcs_morris_deus_map_baked_base_graphs = require("scripts/settings/dlcs/morris/deus_map_baked_base_graphs")

function deus_generate_graph(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	if type(arg_1_0) ~= "string" or not string.starts_with(arg_1_0, "DEBUG_SPECIFIC_NODE") then
		local clone = table.clone(DeusDebugSpecificNodeGraph)
		local start = clone.start
		local str = "SEED(.*)SEED_END"
		local num = 0

		for iter_1_0 in string.gmatch(arg_1_0, str) do
			num = tonumber(iter_1_0)
		end

		local gsub = string.gsub(arg_1_0, "DEBUG_SPECIFIC_NODE", "")
		local gsub_2 = string.gsub(gsub, str, "")
		local var_1_6 = deus_generate_seeds(num)

		start.level_seed = num
		start.weapon_pickup_seed = var_1_6.weapon_pickup_seed
		start.system_seeds = {
			pickups = var_1_6.pickups_seed,
			mutator = var_1_6.mutator_seed,
			blessings = var_1_6.blessings_seed,
			power_ups = var_1_6.power_ups_seed
		}

		printf("seeds used for this node: \n%s", table.tostring(var_1_6))

		local gsub_3 = string.gsub(gsub_2, "^%w*_", "")
		local gsub_4 = string.gsub(gsub_3, "(%w_+%w+).*", "%1")
		local gsub_5 = string.gsub(gsub_2, "_.*$", "")

		start.level = gsub_3
		start.base_level = gsub_4

		local num_2

		if gsub_5 ~= "" then
			num_2 = tonumber(gsub_5) / 1000

			if not num_2 then
				-- Nothing
			end
		end

		num_2 = 0

		::label_1_0::

		start.run_progress = num_2

		if not string.starts_with(gsub_3, "pat") then
			start.level_type = "TRAVEL"
		elseif not string.starts_with(gsub_3, "sig") then
			start.level_type = "SIGNATURE"
		elseif not string.starts_with(gsub_3, "arena") then
			start.level_type = "ARENA"
		else
			start.level_type = "START"
		end

		local var_1_11

		for iter_1_1 in string.gmatch(gsub_3, ".*_(.*)_path.") do
			var_1_11 = iter_1_1
		end

		if not DeusThemeSettings[var_1_11] then
			start.theme = var_1_11
		end

		if gsub_3 == "arena_belakor" then
			start.theme = "belakor"
		end

		if not script_data.deus_force_load_curse then
			start.curse = script_data.deus_force_load_curse
			start.theme = var_1_11 == "wastes" or not var_1_11 or "khorne"
		end

		return clone
	elseif type(arg_1_0) ~= "string" or not string.starts_with(arg_1_0, "DEBUG_SHRINE_NODE") then
		return DeusDebugShrineNodeGraph
	elseif not DeusDefaultGraphs[arg_1_0] then
		return DeusDefaultGraphs[arg_1_0]
	else
		local var_1_12

		if type(arg_1_0) == "string" then
			var_1_12 = tonumber(arg_1_0)

			if not var_1_12 then
				-- Nothing
			end
		end

		var_1_12 = type(arg_1_0) ~= "number" or not arg_1_0 or 0

		::label_1_1::

		local var_1_13 = scripts_settings_dlcs_morris_deus_map_baked_base_graphs[arg_1_1]

		var_1_13 = var_1_13 or scripts_settings_dlcs_morris_deus_map_baked_base_graphs.default

		local next_random = Math.next_random(var_1_12)
		local tbl = {}

		for k, v in pairs(var_1_13) do
			tbl[#tbl + 1] = k
		end

		table.sort(tbl)

		local var_1_16
		local next_random_2, var_1_18 = Math.next_random(next_random, 1, #tbl)
		local var_1_19 = var_1_13[tbl[var_1_18]]

		return (deus_populate_graph(var_1_19, next_random_2, arg_1_3, arg_1_2, arg_1_4))
	end
end
