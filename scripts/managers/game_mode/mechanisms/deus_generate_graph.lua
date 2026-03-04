-- chunkname: @scripts/managers/game_mode/mechanisms/deus_generate_graph.lua

require("scripts/managers/game_mode/mechanisms/deus_base_graph_generator")
require("scripts/managers/game_mode/mechanisms/deus_layout_base_graph")
require("scripts/managers/game_mode/mechanisms/deus_populate_graph")

local var_0_0 = require("scripts/settings/dlcs/morris/deus_map_baked_base_graphs")

function deus_generate_graph(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if type(arg_1_0) == "string" and string.starts_with(arg_1_0, "DEBUG_SPECIFIC_NODE") then
		local var_1_0 = table.clone(DeusDebugSpecificNodeGraph)
		local var_1_1 = var_1_0.start
		local var_1_2 = "SEED(.*)SEED_END"
		local var_1_3 = 0

		for iter_1_0 in string.gmatch(arg_1_0, var_1_2) do
			var_1_3 = tonumber(iter_1_0)
		end

		local var_1_4 = string.gsub(arg_1_0, "DEBUG_SPECIFIC_NODE", "")
		local var_1_5 = string.gsub(var_1_4, var_1_2, "")
		local var_1_6 = deus_generate_seeds(var_1_3)

		var_1_1.level_seed = var_1_3
		var_1_1.weapon_pickup_seed = var_1_6.weapon_pickup_seed
		var_1_1.system_seeds = {
			pickups = var_1_6.pickups_seed,
			mutator = var_1_6.mutator_seed,
			blessings = var_1_6.blessings_seed,
			power_ups = var_1_6.power_ups_seed
		}

		printf("seeds used for this node: \n%s", table.tostring(var_1_6))

		local var_1_7 = string.gsub(var_1_5, "^%w*_", "")
		local var_1_8 = string.gsub(var_1_7, "(%w_+%w+).*", "%1")
		local var_1_9 = string.gsub(var_1_5, "_.*$", "")

		var_1_1.level = var_1_7
		var_1_1.base_level = var_1_8
		var_1_1.run_progress = var_1_9 ~= "" and tonumber(var_1_9) / 1000 or 0

		if string.starts_with(var_1_7, "pat") then
			var_1_1.level_type = "TRAVEL"
		elseif string.starts_with(var_1_7, "sig") then
			var_1_1.level_type = "SIGNATURE"
		elseif string.starts_with(var_1_7, "arena") then
			var_1_1.level_type = "ARENA"
		else
			var_1_1.level_type = "START"
		end

		local var_1_10

		for iter_1_1 in string.gmatch(var_1_7, ".*_(.*)_path.") do
			var_1_10 = iter_1_1
		end

		if DeusThemeSettings[var_1_10] then
			var_1_1.theme = var_1_10
		end

		if var_1_7 == "arena_belakor" then
			var_1_1.theme = "belakor"
		end

		if script_data.deus_force_load_curse then
			var_1_1.curse = script_data.deus_force_load_curse
			var_1_1.theme = var_1_10 ~= "wastes" and var_1_10 or "khorne"
		end

		return var_1_0
	elseif type(arg_1_0) == "string" and string.starts_with(arg_1_0, "DEBUG_SHRINE_NODE") then
		return DeusDebugShrineNodeGraph
	elseif DeusDefaultGraphs[arg_1_0] then
		return DeusDefaultGraphs[arg_1_0]
	else
		local var_1_11 = type(arg_1_0) == "string" and tonumber(arg_1_0) or type(arg_1_0) == "number" and arg_1_0 or 0
		local var_1_12 = var_0_0[arg_1_1] or var_0_0.default
		local var_1_13 = Math.next_random(var_1_11)
		local var_1_14 = {}

		for iter_1_2, iter_1_3 in pairs(var_1_12) do
			var_1_14[#var_1_14 + 1] = iter_1_2
		end

		table.sort(var_1_14)

		local var_1_15
		local var_1_16, var_1_17 = Math.next_random(var_1_13, 1, #var_1_14)
		local var_1_18 = var_1_12[var_1_14[var_1_17]]

		return (deus_populate_graph(var_1_18, var_1_16, arg_1_3, arg_1_2, arg_1_4))
	end
end
