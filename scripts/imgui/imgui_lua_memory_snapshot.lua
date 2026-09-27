-- chunkname: @scripts/imgui/imgui_lua_memory_snapshot.lua

local num = 300
local num_2 = 100
local num_3 = 700
local num_4 = 700
local num_5 = 20
local num_6 = 2500

ImguiLuaMemorySnapshot = class(ImguiLuaMemorySnapshot)

ImguiLuaMemorySnapshot.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._next_snapshot_id = 0
	self._snapshots = {}
	self._skip_determinism = true
end

ImguiLuaMemorySnapshot.is_persistent = function (arg_2_0)
	-- function 2
	return false
end

ImguiLuaMemorySnapshot.update = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	return
end

local tbl = {}

ImguiLuaMemorySnapshot.draw = function (self)
	-- function 4
	if not Imgui.button("Take Snapshot") then
		collectgarbage("collect")
		self:_add_snapshot(self:_traverse_memory(), "Memory Dump")
	end

	self._skip_determinism = Imgui.checkbox("Skip Determinism (Improves execution time)", self._skip_determinism)

	for i = #self._snapshots, 1, -1 do
		local var_4_0 = self._snapshots[i]

		if not var_4_0.window_initialized then
			local get_window_pos, var_4_2 = Imgui.get_window_pos()
			local get_window_size = Imgui.get_window_size()

			Imgui.set_next_window_pos(get_window_pos + get_window_size, var_4_2)
			Imgui.set_next_window_size(0, 0)
		elseif var_4_0.window_width or not var_4_0.window_height then
			Imgui.set_next_window_size(var_4_0.window_width, var_4_0.window_height)

			var_4_0.window_width = nil
			var_4_0.window_height = nil
		end

		local begin_window = Imgui.begin_window
		local format = string.format
		local str = "%s (%s)"
		local name = var_4_0.name

		name = name or "Memory Snapshot"

		if not begin_window(format(str, name, var_4_0.snapshot_id), "horizontal_scrollbar") then
			table.remove(self._snapshots, i)
		else
			local lua_memory = var_4_0.lua_memory
			local num_5 = 300

			Imgui.push_item_width(num_5)
			Imgui.text(string.format("\t\tFilter (Max hits %s): ", num_6))
			Imgui.same_line()

			local filter = var_4_0.filter

			var_4_0.filter = Imgui.input_text("", var_4_0.filter)

			if filter ~= var_4_0.filter then
				table.clear(var_4_0.filtered_ids)
				LuaMemory.ids_by_filter(lua_memory, var_4_0.filter, num_6, var_4_0.filtered_ids)
			end

			Imgui.pop_item_width()
			Imgui.separator()

			if not Imgui.button("Save to Disk##" .. i) then
				local _save_file, var_4_12 = self:_save_file(lua_memory)

				var_4_0.save_success = _save_file
				var_4_0.save_status = var_4_12
			end

			if not var_4_0.save_status then
				Imgui.same_line()

				if not var_4_0.save_success then
					Imgui.text(string.format("Saved at: %s", var_4_0.save_status))
					Imgui.same_line()

					if not Imgui.button("Copy##" .. i) then
						Clipboard.put(var_4_0.save_status)
					end
				else
					Imgui.text(string.format("Error: ", var_4_0.save_status))
				end
			end

			Imgui.separator()

			var_4_0.num_headers = 0

			local root_ids = LuaMemory.root_ids(lua_memory, tbl)

			for j = 1, root_ids do
				self:_recursive_header(var_4_0, tbl[j])
			end

			local get_item_rect_size, var_4_15 = Imgui.get_item_rect_size()
			local num_7 = var_4_15 * var_4_0.num_headers
			local max = math.max(get_item_rect_size, num)
			local max_2 = math.max(num_7, num_2)
			local get_window_size_2, var_4_20 = Imgui.get_window_size()

			if not var_4_0.window_initialized then
				local max_3 = math.max(get_window_size_2, math.min(max, num_3))
				local max_4 = math.max(var_4_20, math.min(max_2, num_4))

				if not (get_window_size_2 < max_3 or not (var_4_20 < max_4)) then
					var_4_0.window_width = max_3
					var_4_0.window_height = max_4
				end
			end

			var_4_0.window_initialized = true
		end

		Imgui.end_window()
	end
end

ImguiLuaMemorySnapshot._add_snapshot = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _next_snapshot_id = self._next_snapshot_id

	self._next_snapshot_id = _next_snapshot_id + 1

	table.insert(self._snapshots, {
		memory_layout_name_max_size = 0,
		window_height = 0,
		filter = "",
		window_width = 0,
		name = arg_5_2,
		snapshot_id = _next_snapshot_id,
		lua_memory = arg_5_1,
		remember_open = {},
		max_children = {},
		filtered_ids = {},
		name_padding_cache = {},
		children_cache = {}
	})
end

ImguiLuaMemorySnapshot._traverse_memory = function (self, arg_6_1)
	-- function 6
	local var_6_0
	local str = "Memory Dump"
	local time = os.time()
	local traverse = LuaMemory.traverse(var_6_0, self._skip_determinism)

	printf("[LuaMemory] Finding references took: %ss", os.time() - time)

	return traverse, str
end

ImguiLuaMemorySnapshot._save_file = function (arg_7_0, arg_7_1)
	-- function 7
	local var_7_0

	if var_7_0 == "" then
		return nil
	end

	local dump, var_7_2 = LuaMemory.dump(arg_7_1, var_7_0)

	return dump, var_7_2
end

ImguiLuaMemorySnapshot._recursive_header = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local lua_memory = arg_8_1.lua_memory
	local flag = true
	local var_8_2 = arg_8_1.remember_open[arg_8_2]
	local flag_2 = false

	if arg_8_1.filter ~= "" then
		flag = arg_8_1.filtered_ids[arg_8_2]
		var_8_2 = not not arg_8_1.filtered_ids[arg_8_2]
		flag_2 = true
	end

	if arg_8_3 ~= nil then
		flag = arg_8_3
	end

	if not flag then
		local name_by_id = LuaMemory.name_by_id(lua_memory, arg_8_2)

		arg_8_1.memory_layout_name_max_size = math.clamp(#name_by_id, arg_8_1.memory_layout_name_max_size, 125)

		local memory_layout_name_max_size = arg_8_1.memory_layout_name_max_size

		arg_8_1.num_headers = arg_8_1.num_headers + 1
		arg_8_4 = arg_8_4 or 1

		local str = "\t\t"
		local size_by_id, var_8_8 = LuaMemory.size_by_id(lua_memory, arg_8_2)
		local name_padding_cache = arg_8_1.name_padding_cache
		local format = string.format("%s%s (self: %sb)%s##%s", string.pad_right(name_by_id, memory_layout_name_max_size + 4, " ", name_padding_cache), string.pad_right(string.chunk_from_right(tostring(size_by_id), 3, "'") .. "b", 15, " ", name_padding_cache), string.chunk_from_right(tostring(var_8_8), 3, "'"), str, arg_8_2)

		if not Imgui.collapsing_header(format, var_8_2) then
			local remember_open = arg_8_1.remember_open
			local flag_3

			flag_3 = flag_2 or not true or arg_8_1.remember_open[arg_8_2]
			remember_open[arg_8_2] = flag_3

			local var_8_13 = arg_8_1.max_children[arg_8_2]

			var_8_13 = var_8_13 or num_5

			local var_8_14 = arg_8_1.children_cache[arg_8_4]

			if not var_8_14 then
				var_8_14 = {}
				arg_8_1.children_cache[arg_8_4] = var_8_14
			end

			local children_by_id, var_8_16 = LuaMemory.children_by_id(lua_memory, arg_8_2, var_8_14)

			if var_8_16 > 0 then
				Imgui.indent()

				local num = 0
				local find

				if arg_8_3 ~= nil or not flag_2 then
					find = string.find(name_by_id, arg_8_1.filter)

					if not find then
						-- Nothing
					end
				end

				find = arg_8_3

				::label_8_0::

				for i = 1, var_8_16 do
					local _recursive_header, var_8_20 = self:_recursive_header(arg_8_1, children_by_id[i], find, arg_8_4 + 1)

					if (_recursive_header or not flag_2) and not var_8_20 then
						num = num + 1

						if var_8_13 <= num then
							find = false
						end
					end
				end

				local num_2 = num - var_8_13

				if num_2 > 0 then
					local min = math.min(num_5, num_2)

					if not Imgui.button(string.format("Show %s (out of %s) more...", min, num_2)) then
						local max_children = arg_8_1.max_children
						local var_8_24 = arg_8_1.max_children[arg_8_2]

						var_8_24 = var_8_24 or num_5
						max_children[arg_8_2] = var_8_24 + min
					end
				end

				Imgui.unindent()
			end
		else
			arg_8_1.remember_open[arg_8_2] = false
			arg_8_1.max_children[arg_8_2] = nil
		end
	end

	return flag, arg_8_1.filtered_ids[arg_8_2]
end
