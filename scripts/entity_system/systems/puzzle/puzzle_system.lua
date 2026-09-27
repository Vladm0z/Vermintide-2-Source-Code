-- chunkname: @scripts/entity_system/systems/puzzle/puzzle_system.lua

require("scripts/unit_extensions/puzzle/combination_puzzle_extension")

PuzzleSystem = class(PuzzleSystem, ExtensionSystemBase)

local tbl = {
	"PuzzleExtensionBase",
	"CombinationPuzzleExtension"
}
local tbl_2 = {
	"rpc_on_puzzle_completed"
}

PuzzleSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	PuzzleSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	self._is_server = arg_1_1.is_server
	self._network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl_2))

	self._extensions = Script.new_map(16)
	self._network_manager = arg_1_1.network_manager
	self._puzzle_groups = {}
	self._puzzles_to_update = {}
	self._group_id_hash_lookup = {}
	self._puzzle_id_hash_lookup = {}
end

PuzzleSystem.destroy = function (self)
	-- function 2
	PuzzleSystem.super.destroy(self)
	self._network_event_delegate:unregister(self)
end

PuzzleSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local on_add_extension = PuzzleSystem.super.on_add_extension(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_0._extensions[arg_3_2] = on_add_extension

	local puzzle_group_id = on_add_extension:puzzle_group_id()
	local var_3_2 = type(puzzle_group_id)

	if var_3_2 == "string" then
		arg_3_0:_get_or_add_group(puzzle_group_id).extensions[on_add_extension] = true
	elseif var_3_2 == "table" then
		for i = 1, #var_3_2 do
			arg_3_0:_get_or_add_group(var_3_2[i]).extensions[on_add_extension] = true
		end
	end

	return on_add_extension
end

PuzzleSystem._get_or_add_group = function (self, arg_4_1)
	-- function 4
	local var_4_0 = self._puzzle_groups[arg_4_1]

	var_4_0 = var_4_0 or {
		extensions = {},
		puzzles = {}
	}
	self._puzzle_groups[arg_4_1] = var_4_0

	return var_4_0
end

PuzzleSystem.on_remove_extension = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self._extensions[arg_5_1]
	local puzzle_group_id = var_5_0:puzzle_group_id()

	self:_get_or_add_group(puzzle_group_id).extensions[var_5_0] = nil
	self._extensions[arg_5_1] = nil

	PuzzleSystem.super.on_remove_extension(self, arg_5_1, arg_5_2)
end

PuzzleSystem.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	PuzzleSystem.super.update(self, arg_6_1, arg_6_2)

	if not self._is_server then
		return
	end

	self:_update_puzzles()
end

PuzzleSystem.register_puzzle = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local _get_or_add_group = self:_get_or_add_group(arg_7_1)

	if not _get_or_add_group.puzzles[arg_7_2] then
		return
	end

	_get_or_add_group.puzzles[arg_7_2] = {
		completed = false,
		completed_level_event = "",
		ordered = false,
		group_name = arg_7_1,
		combination = {},
		num_per_combination_value = {}
	}

	local var_7_1 = _get_or_add_group.puzzles[arg_7_2]
	local combination = var_7_1.combination
	local num_per_combination_value = var_7_1.num_per_combination_value
	local split_deprecated = string.split_deprecated(arg_7_3, ",")

	for i = 1, #split_deprecated do
		local trim = string.trim(split_deprecated[i])

		if trim == "" then
			break
		end

		combination[i] = trim

		local var_7_6 = num_per_combination_value[trim]

		var_7_6 = var_7_6 or 0
		num_per_combination_value[trim] = var_7_6 + 1
	end

	var_7_1.ordered = arg_7_4
	var_7_1.completed_level_event = arg_7_5
	var_7_1.hot_join_sync_completion = arg_7_6
	self._puzzles_to_update[arg_7_2] = var_7_1

	local var_7_7 = self._group_id_hash_lookup[arg_7_1]

	var_7_7 = var_7_7 or HashUtils.fnv32_hash(arg_7_1)
	self._group_id_hash_lookup[var_7_7] = arg_7_1
	self._group_id_hash_lookup[arg_7_1] = var_7_7

	local var_7_8 = self._puzzle_id_hash_lookup[arg_7_2]

	var_7_8 = var_7_8 or HashUtils.fnv32_hash(arg_7_2)
	self._puzzle_id_hash_lookup[var_7_8] = arg_7_2
	self._puzzle_id_hash_lookup[arg_7_2] = var_7_8
end

PuzzleSystem.hot_join_sync = function (self, arg_8_1)
	-- function 8
	for k, v in pairs(self._puzzle_groups) do
		local var_8_0 = self._group_id_hash_lookup[k]

		for k_2, v_2 in pairs(v.puzzles) do
			if not v_2.hot_join_sync_completion and not v_2.completed then
				local var_8_1 = self._puzzle_id_hash_lookup[k_2]

				self.network_transmit:send_rpc("rpc_on_puzzle_completed", arg_8_1, var_8_0, var_8_1)
			end
		end
	end
end

PuzzleSystem._update_puzzles = function (self)
	-- function 9
	local _puzzles_to_update = self._puzzles_to_update

	for k, v in pairs(_puzzles_to_update) do
		if not self:_update_puzzle(v) then
			_puzzles_to_update[k] = nil

			self:_on_puzzle_complete(v.group_name, k)
		end
	end
end

local tbl_3 = {}
local tbl_4 = {}

PuzzleSystem._update_puzzle = function (self, arg_10_1)
	-- function 10
	local group_name = arg_10_1.group_name
	local _get_or_add_group = self:_get_or_add_group(group_name)
	local combination = arg_10_1.combination
	local num_per_combination_value = arg_10_1.num_per_combination_value
	local extensions = _get_or_add_group.extensions
	local ordered = arg_10_1.ordered
	local num = 0
	local count = #combination

	if not ordered then
		for k in pairs(extensions) do
			local puzzle_value = k:puzzle_value()
			local order_id = k:order_id()

			if puzzle_value ~= arg_10_1.combination[order_id] then
				break
			end

			num = num + 1
		end
	else
		table.clear(tbl_3)
		table.clear(tbl_4)

		for k_2 in pairs(extensions) do
			local puzzle_value_2 = k_2:puzzle_value()
			local var_10_11

			while var_10_11 ~= -1 do
				var_10_11 = table.index_of(combination, puzzle_value_2, (var_10_11 or 0) + 1)

				if not tbl_4[var_10_11] then
					if tbl_3[puzzle_value_2] >= num_per_combination_value[puzzle_value_2] then
						break
					end
				elseif var_10_11 ~= -1 then
					tbl_4[var_10_11] = true

					local var_10_12 = tbl_3
					local var_10_13 = tbl_3[puzzle_value_2]

					var_10_13 = var_10_13 or 0
					var_10_12[puzzle_value_2] = var_10_13 + 1
					num = num + 1

					break
				end
			end
		end
	end

	return count <= num
end

PuzzleSystem._on_puzzle_complete = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _get_or_add_group = self:_get_or_add_group(arg_11_1)
	local var_11_1 = _get_or_add_group.puzzles[arg_11_2]

	var_11_1.completed = true

	local extensions = _get_or_add_group.extensions

	for k in pairs(extensions) do
		k:on_puzzle_completed(arg_11_2)
	end

	local completed_level_event = var_11_1.completed_level_event
	local current_level = LevelHelper:current_level(self.world)

	Level.trigger_event(current_level, completed_level_event)

	if not self._is_server then
		local var_11_5 = self._group_id_hash_lookup[arg_11_1]
		local var_11_6 = self._puzzle_id_hash_lookup[arg_11_2]

		self.network_transmit:send_rpc_clients("rpc_on_puzzle_completed", var_11_5, var_11_6)
	end
end

PuzzleSystem.rpc_on_puzzle_completed = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0 = self._group_id_hash_lookup[arg_12_2]
	local var_12_1 = self._puzzle_id_hash_lookup[arg_12_3]

	if not var_12_0 then
		Crashify.print_exception("PuzzleSystem", "Desync during hot join. Missing puzzle group.")

		return
	elseif not var_12_1 then
		Crashify.print_exception("PuzzleSystem", "Desync during hot join. Missing puzzle in group '%s'", var_12_0)

		return
	end

	self:_on_puzzle_complete(var_12_0, var_12_1)
end

local str = "debug_puzzles"

PuzzleSystem._debug_draw_values = function (self)
	-- function 13
	local alloc_table = FrameTable.alloc_table()

	Managers.state.debug_text:clear_world_text(str)

	local _extensions = self._extensions

	for k, v in pairs(_extensions) do
		if not alloc_table[v] then
			local puzzle_value = v:puzzle_value()

			Managers.state.debug_text:output_world_text(puzzle_value, 0.6, Unit.local_position(k, 0), nil, str, Vector3(0, 255, 0), nil, Unit.local_rotation(k, 0))
		end

		alloc_table[v] = true
	end

	local alloc_table_2 = FrameTable.alloc_table()
	local alloc_table_3 = FrameTable.alloc_table()
	local _puzzle_groups = self._puzzle_groups

	for k_2, v_2 in pairs(_puzzle_groups) do
		for k_3, v_3 in pairs(v_2.puzzles) do
			if not v_3.completed then
				alloc_table_2[k_2] = true
			else
				alloc_table_3[k_2] = true
			end
		end
	end

	Debug.text("Puzzle Debug")

	if not table.is_empty(alloc_table_2) then
		Debug.text("    Active groups:")

		for k_4 in pairs(alloc_table_2) do
			Debug.text("        %s:", k_4)

			local _get_or_add_group = self:_get_or_add_group(k_4)

			for k_5, v_4 in pairs(_get_or_add_group.puzzles) do
				if not v_4.completed then
					local concat = table.concat(v_4.combination, ", ")
					local tbl = {}
					local extensions = _get_or_add_group.extensions
					local num = 1

					for k_6 in pairs(extensions) do
						local order_id = k_6:order_id()

						order_id = order_id or num
						tbl[order_id] = k_6:puzzle_value()
						num = num + 1
					end

					local concat_2 = table.concat(tbl, ", ")
					local text = Debug.text
					local str_2 = "            %s: Combination: %s, Values: %s, (Ordered=%s)"
					local flag

					flag = k_5 ~= "" or not "<no_name>" or k_5

					text(str_2, flag, concat, concat_2, v_4.ordered)
				end
			end
		end
	end

	if not table.is_empty(alloc_table_3) then
		Debug.text("    Inactive groups:")

		for k_7 in pairs(alloc_table_3) do
			local _get_or_add_group_2 = self:_get_or_add_group(k_7)

			Debug.text("        %s:", k_7)

			for k_8, v_5 in pairs(_get_or_add_group_2.puzzles) do
				if not v_5.completed then
					Debug.text("            %s", k_8)
				end
			end
		end
	end
end
