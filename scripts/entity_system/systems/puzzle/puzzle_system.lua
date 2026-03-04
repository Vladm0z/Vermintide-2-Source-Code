-- chunkname: @scripts/entity_system/systems/puzzle/puzzle_system.lua

require("scripts/unit_extensions/puzzle/combination_puzzle_extension")

PuzzleSystem = class(PuzzleSystem, ExtensionSystemBase)

local var_0_0 = {
	"PuzzleExtensionBase",
	"CombinationPuzzleExtension"
}
local var_0_1 = {
	"rpc_on_puzzle_completed"
}

function PuzzleSystem.init(arg_1_0, arg_1_1, arg_1_2)
	PuzzleSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._network_event_delegate = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_1))

	arg_1_0._extensions = Script.new_map(16)
	arg_1_0._network_manager = arg_1_1.network_manager
	arg_1_0._puzzle_groups = {}
	arg_1_0._puzzles_to_update = {}
	arg_1_0._group_id_hash_lookup = {}
	arg_1_0._puzzle_id_hash_lookup = {}
end

function PuzzleSystem.destroy(arg_2_0)
	PuzzleSystem.super.destroy(arg_2_0)
	arg_2_0._network_event_delegate:unregister(arg_2_0)
end

function PuzzleSystem.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = PuzzleSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_0._extensions[arg_3_2] = var_3_0

	local var_3_1 = var_3_0:puzzle_group_id()
	local var_3_2 = type(var_3_1)

	if var_3_2 == "string" then
		arg_3_0:_get_or_add_group(var_3_1).extensions[var_3_0] = true
	elseif var_3_2 == "table" then
		for iter_3_0 = 1, #var_3_2 do
			arg_3_0:_get_or_add_group(var_3_2[iter_3_0]).extensions[var_3_0] = true
		end
	end

	return var_3_0
end

function PuzzleSystem._get_or_add_group(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._puzzle_groups[arg_4_1] or {
		extensions = {},
		puzzles = {}
	}

	arg_4_0._puzzle_groups[arg_4_1] = var_4_0

	return var_4_0
end

function PuzzleSystem.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._extensions[arg_5_1]
	local var_5_1 = var_5_0:puzzle_group_id()

	arg_5_0:_get_or_add_group(var_5_1).extensions[var_5_0] = nil
	arg_5_0._extensions[arg_5_1] = nil

	PuzzleSystem.super.on_remove_extension(arg_5_0, arg_5_1, arg_5_2)
end

function PuzzleSystem.update(arg_6_0, arg_6_1, arg_6_2)
	PuzzleSystem.super.update(arg_6_0, arg_6_1, arg_6_2)

	if not arg_6_0._is_server then
		return
	end

	arg_6_0:_update_puzzles()
end

function PuzzleSystem.register_puzzle(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = arg_7_0:_get_or_add_group(arg_7_1)

	if var_7_0.puzzles[arg_7_2] then
		return
	end

	var_7_0.puzzles[arg_7_2] = {
		completed = false,
		completed_level_event = "",
		ordered = false,
		group_name = arg_7_1,
		combination = {},
		num_per_combination_value = {}
	}

	local var_7_1 = var_7_0.puzzles[arg_7_2]
	local var_7_2 = var_7_1.combination
	local var_7_3 = var_7_1.num_per_combination_value
	local var_7_4 = string.split_deprecated(arg_7_3, ",")

	for iter_7_0 = 1, #var_7_4 do
		local var_7_5 = string.trim(var_7_4[iter_7_0])

		if var_7_5 == "" then
			break
		end

		var_7_2[iter_7_0] = var_7_5
		var_7_3[var_7_5] = (var_7_3[var_7_5] or 0) + 1
	end

	var_7_1.ordered = arg_7_4
	var_7_1.completed_level_event = arg_7_5
	var_7_1.hot_join_sync_completion = arg_7_6
	arg_7_0._puzzles_to_update[arg_7_2] = var_7_1

	local var_7_6 = arg_7_0._group_id_hash_lookup[arg_7_1] or HashUtils.fnv32_hash(arg_7_1)

	arg_7_0._group_id_hash_lookup[var_7_6] = arg_7_1
	arg_7_0._group_id_hash_lookup[arg_7_1] = var_7_6

	local var_7_7 = arg_7_0._puzzle_id_hash_lookup[arg_7_2] or HashUtils.fnv32_hash(arg_7_2)

	arg_7_0._puzzle_id_hash_lookup[var_7_7] = arg_7_2
	arg_7_0._puzzle_id_hash_lookup[arg_7_2] = var_7_7
end

function PuzzleSystem.hot_join_sync(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_0._puzzle_groups) do
		local var_8_0 = arg_8_0._group_id_hash_lookup[iter_8_0]

		for iter_8_2, iter_8_3 in pairs(iter_8_1.puzzles) do
			if iter_8_3.hot_join_sync_completion and iter_8_3.completed then
				local var_8_1 = arg_8_0._puzzle_id_hash_lookup[iter_8_2]

				arg_8_0.network_transmit:send_rpc("rpc_on_puzzle_completed", arg_8_1, var_8_0, var_8_1)
			end
		end
	end
end

function PuzzleSystem._update_puzzles(arg_9_0)
	local var_9_0 = arg_9_0._puzzles_to_update

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if arg_9_0:_update_puzzle(iter_9_1) then
			var_9_0[iter_9_0] = nil

			arg_9_0:_on_puzzle_complete(iter_9_1.group_name, iter_9_0)
		end
	end
end

local var_0_2 = {}
local var_0_3 = {}

function PuzzleSystem._update_puzzle(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1.group_name
	local var_10_1 = arg_10_0:_get_or_add_group(var_10_0)
	local var_10_2 = arg_10_1.combination
	local var_10_3 = arg_10_1.num_per_combination_value
	local var_10_4 = var_10_1.extensions
	local var_10_5 = arg_10_1.ordered
	local var_10_6 = 0
	local var_10_7 = #var_10_2

	if var_10_5 then
		for iter_10_0 in pairs(var_10_4) do
			local var_10_8 = iter_10_0:puzzle_value()
			local var_10_9 = iter_10_0:order_id()

			if var_10_8 ~= arg_10_1.combination[var_10_9] then
				break
			end

			var_10_6 = var_10_6 + 1
		end
	else
		table.clear(var_0_2)
		table.clear(var_0_3)

		for iter_10_1 in pairs(var_10_4) do
			local var_10_10 = iter_10_1:puzzle_value()
			local var_10_11

			while var_10_11 ~= -1 do
				var_10_11 = table.index_of(var_10_2, var_10_10, (var_10_11 or 0) + 1)

				if var_0_3[var_10_11] then
					if var_0_2[var_10_10] >= var_10_3[var_10_10] then
						break
					end
				elseif var_10_11 ~= -1 then
					var_0_3[var_10_11] = true
					var_0_2[var_10_10] = (var_0_2[var_10_10] or 0) + 1
					var_10_6 = var_10_6 + 1

					break
				end
			end
		end
	end

	return var_10_7 <= var_10_6
end

function PuzzleSystem._on_puzzle_complete(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0:_get_or_add_group(arg_11_1)
	local var_11_1 = var_11_0.puzzles[arg_11_2]

	var_11_1.completed = true

	local var_11_2 = var_11_0.extensions

	for iter_11_0 in pairs(var_11_2) do
		iter_11_0:on_puzzle_completed(arg_11_2)
	end

	local var_11_3 = var_11_1.completed_level_event
	local var_11_4 = LevelHelper:current_level(arg_11_0.world)

	Level.trigger_event(var_11_4, var_11_3)

	if arg_11_0._is_server then
		local var_11_5 = arg_11_0._group_id_hash_lookup[arg_11_1]
		local var_11_6 = arg_11_0._puzzle_id_hash_lookup[arg_11_2]

		arg_11_0.network_transmit:send_rpc_clients("rpc_on_puzzle_completed", var_11_5, var_11_6)
	end
end

function PuzzleSystem.rpc_on_puzzle_completed(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0._group_id_hash_lookup[arg_12_2]
	local var_12_1 = arg_12_0._puzzle_id_hash_lookup[arg_12_3]

	if not var_12_0 then
		Crashify.print_exception("PuzzleSystem", "Desync during hot join. Missing puzzle group.")

		return
	elseif not var_12_1 then
		Crashify.print_exception("PuzzleSystem", "Desync during hot join. Missing puzzle in group '%s'", var_12_0)

		return
	end

	arg_12_0:_on_puzzle_complete(var_12_0, var_12_1)
end

local var_0_4 = "debug_puzzles"

function PuzzleSystem._debug_draw_values(arg_13_0)
	local var_13_0 = FrameTable.alloc_table()

	Managers.state.debug_text:clear_world_text(var_0_4)

	local var_13_1 = arg_13_0._extensions

	for iter_13_0, iter_13_1 in pairs(var_13_1) do
		if not var_13_0[iter_13_1] then
			local var_13_2 = iter_13_1:puzzle_value()

			Managers.state.debug_text:output_world_text(var_13_2, 0.6, Unit.local_position(iter_13_0, 0), nil, var_0_4, Vector3(0, 255, 0), nil, Unit.local_rotation(iter_13_0, 0))
		end

		var_13_0[iter_13_1] = true
	end

	local var_13_3 = FrameTable.alloc_table()
	local var_13_4 = FrameTable.alloc_table()
	local var_13_5 = arg_13_0._puzzle_groups

	for iter_13_2, iter_13_3 in pairs(var_13_5) do
		for iter_13_4, iter_13_5 in pairs(iter_13_3.puzzles) do
			if not iter_13_5.completed then
				var_13_3[iter_13_2] = true
			else
				var_13_4[iter_13_2] = true
			end
		end
	end

	Debug.text("Puzzle Debug")

	if not table.is_empty(var_13_3) then
		Debug.text("    Active groups:")

		for iter_13_6 in pairs(var_13_3) do
			Debug.text("        %s:", iter_13_6)

			local var_13_6 = arg_13_0:_get_or_add_group(iter_13_6)

			for iter_13_7, iter_13_8 in pairs(var_13_6.puzzles) do
				if not iter_13_8.completed then
					local var_13_7 = table.concat(iter_13_8.combination, ", ")
					local var_13_8 = {}
					local var_13_9 = var_13_6.extensions
					local var_13_10 = 1

					for iter_13_9 in pairs(var_13_9) do
						var_13_8[iter_13_9:order_id() or var_13_10] = iter_13_9:puzzle_value()
						var_13_10 = var_13_10 + 1
					end

					local var_13_11 = table.concat(var_13_8, ", ")

					Debug.text("            %s: Combination: %s, Values: %s, (Ordered=%s)", iter_13_7 == "" and "<no_name>" or iter_13_7, var_13_7, var_13_11, iter_13_8.ordered)
				end
			end
		end
	end

	if not table.is_empty(var_13_4) then
		Debug.text("    Inactive groups:")

		for iter_13_10 in pairs(var_13_4) do
			local var_13_12 = arg_13_0:_get_or_add_group(iter_13_10)

			Debug.text("        %s:", iter_13_10)

			for iter_13_11, iter_13_12 in pairs(var_13_12.puzzles) do
				if iter_13_12.completed then
					Debug.text("            %s", iter_13_11)
				end
			end
		end
	end
end
