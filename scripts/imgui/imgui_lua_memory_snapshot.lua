-- chunkname: @scripts/imgui/imgui_lua_memory_snapshot.lua

local var_0_0 = 300
local var_0_1 = 100
local var_0_2 = 700
local var_0_3 = 700
local var_0_4 = 20
local var_0_5 = 2500

ImguiLuaMemorySnapshot = class(ImguiLuaMemorySnapshot)

function ImguiLuaMemorySnapshot.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._next_snapshot_id = 0
	arg_1_0._snapshots = {}
	arg_1_0._skip_determinism = true
end

function ImguiLuaMemorySnapshot.is_persistent(arg_2_0)
	return false
end

function ImguiLuaMemorySnapshot.update(arg_3_0, arg_3_1, arg_3_2)
	return
end

local var_0_6 = {}

function ImguiLuaMemorySnapshot.draw(arg_4_0)
	if Imgui.button("Take Snapshot") then
		collectgarbage("collect")
		arg_4_0:_add_snapshot(arg_4_0:_traverse_memory(), "Memory Dump")
	end

	arg_4_0._skip_determinism = Imgui.checkbox("Skip Determinism (Improves execution time)", arg_4_0._skip_determinism)

	for iter_4_0 = #arg_4_0._snapshots, 1, -1 do
		local var_4_0 = arg_4_0._snapshots[iter_4_0]

		if not var_4_0.window_initialized then
			local var_4_1, var_4_2 = Imgui.get_window_pos()
			local var_4_3 = Imgui.get_window_size()

			Imgui.set_next_window_pos(var_4_1 + var_4_3, var_4_2)
			Imgui.set_next_window_size(0, 0)
		elseif var_4_0.window_width or var_4_0.window_height then
			Imgui.set_next_window_size(var_4_0.window_width, var_4_0.window_height)

			var_4_0.window_width = nil
			var_4_0.window_height = nil
		end

		if Imgui.begin_window(string.format("%s (%s)", var_4_0.name or "Memory Snapshot", var_4_0.snapshot_id), "horizontal_scrollbar") then
			table.remove(arg_4_0._snapshots, iter_4_0)
		else
			local var_4_4 = var_4_0.lua_memory
			local var_4_5 = 300

			Imgui.push_item_width(var_4_5)
			Imgui.text(string.format("\t\tFilter (Max hits %s): ", var_0_5))
			Imgui.same_line()

			local var_4_6 = var_4_0.filter

			var_4_0.filter = Imgui.input_text("", var_4_0.filter)

			if var_4_6 ~= var_4_0.filter then
				table.clear(var_4_0.filtered_ids)
				LuaMemory.ids_by_filter(var_4_4, var_4_0.filter, var_0_5, var_4_0.filtered_ids)
			end

			Imgui.pop_item_width()
			Imgui.separator()

			if Imgui.button("Save to Disk##" .. iter_4_0) then
				local var_4_7, var_4_8 = arg_4_0:_save_file(var_4_4)

				var_4_0.save_success = var_4_7
				var_4_0.save_status = var_4_8
			end

			if var_4_0.save_status then
				Imgui.same_line()

				if var_4_0.save_success then
					Imgui.text(string.format("Saved at: %s", var_4_0.save_status))
					Imgui.same_line()

					if Imgui.button("Copy##" .. iter_4_0) then
						Clipboard.put(var_4_0.save_status)
					end
				else
					Imgui.text(string.format("Error: ", var_4_0.save_status))
				end
			end

			Imgui.separator()

			var_4_0.num_headers = 0

			local var_4_9 = LuaMemory.root_ids(var_4_4, var_0_6)

			for iter_4_1 = 1, var_4_9 do
				arg_4_0:_recursive_header(var_4_0, var_0_6[iter_4_1])
			end

			local var_4_10, var_4_11 = Imgui.get_item_rect_size()
			local var_4_12 = var_4_11 * var_4_0.num_headers
			local var_4_13 = math.max(var_4_10, var_0_0)
			local var_4_14 = math.max(var_4_12, var_0_1)
			local var_4_15, var_4_16 = Imgui.get_window_size()

			if var_4_0.window_initialized then
				local var_4_17 = math.max(var_4_15, math.min(var_4_13, var_0_2))
				local var_4_18 = math.max(var_4_16, math.min(var_4_14, var_0_3))

				if var_4_15 < var_4_17 or var_4_16 < var_4_18 then
					var_4_0.window_width = var_4_17
					var_4_0.window_height = var_4_18
				end
			end

			var_4_0.window_initialized = true
		end

		Imgui.end_window()
	end
end

function ImguiLuaMemorySnapshot._add_snapshot(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._next_snapshot_id

	arg_5_0._next_snapshot_id = var_5_0 + 1

	table.insert(arg_5_0._snapshots, {
		memory_layout_name_max_size = 0,
		window_height = 0,
		filter = "",
		window_width = 0,
		name = arg_5_2,
		snapshot_id = var_5_0,
		lua_memory = arg_5_1,
		remember_open = {},
		max_children = {},
		filtered_ids = {},
		name_padding_cache = {},
		children_cache = {}
	})
end

function ImguiLuaMemorySnapshot._traverse_memory(arg_6_0, arg_6_1)
	local var_6_0
	local var_6_1 = "Memory Dump"
	local var_6_2 = os.time()
	local var_6_3 = LuaMemory.traverse(var_6_0, arg_6_0._skip_determinism)

	printf("[LuaMemory] Finding references took: %ss", os.time() - var_6_2)

	return var_6_3, var_6_1
end

function ImguiLuaMemorySnapshot._save_file(arg_7_0, arg_7_1)
	local var_7_0

	if var_7_0 == "" then
		return nil
	end

	local var_7_1, var_7_2 = LuaMemory.dump(arg_7_1, var_7_0)

	return var_7_1, var_7_2
end

function ImguiLuaMemorySnapshot._recursive_header(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_1.lua_memory
	local var_8_1 = true
	local var_8_2 = arg_8_1.remember_open[arg_8_2]
	local var_8_3 = false

	if arg_8_1.filter ~= "" then
		var_8_1 = arg_8_1.filtered_ids[arg_8_2]
		var_8_2 = not not arg_8_1.filtered_ids[arg_8_2]
		var_8_3 = true
	end

	if arg_8_3 ~= nil then
		var_8_1 = arg_8_3
	end

	if var_8_1 then
		local var_8_4 = LuaMemory.name_by_id(var_8_0, arg_8_2)

		arg_8_1.memory_layout_name_max_size = math.clamp(#var_8_4, arg_8_1.memory_layout_name_max_size, 125)

		local var_8_5 = arg_8_1.memory_layout_name_max_size

		arg_8_1.num_headers = arg_8_1.num_headers + 1
		arg_8_4 = arg_8_4 or 1

		local var_8_6 = "\t\t"
		local var_8_7, var_8_8 = LuaMemory.size_by_id(var_8_0, arg_8_2)
		local var_8_9 = arg_8_1.name_padding_cache
		local var_8_10 = string.format("%s%s (self: %sb)%s##%s", string.pad_right(var_8_4, var_8_5 + 4, " ", var_8_9), string.pad_right(string.chunk_from_right(tostring(var_8_7), 3, "'") .. "b", 15, " ", var_8_9), string.chunk_from_right(tostring(var_8_8), 3, "'"), var_8_6, arg_8_2)

		if Imgui.collapsing_header(var_8_10, var_8_2) then
			arg_8_1.remember_open[arg_8_2] = not var_8_3 and true or arg_8_1.remember_open[arg_8_2]

			local var_8_11 = arg_8_1.max_children[arg_8_2] or var_0_4
			local var_8_12 = arg_8_1.children_cache[arg_8_4]

			if not var_8_12 then
				var_8_12 = {}
				arg_8_1.children_cache[arg_8_4] = var_8_12
			end

			local var_8_13, var_8_14 = LuaMemory.children_by_id(var_8_0, arg_8_2, var_8_12)

			if var_8_14 > 0 then
				Imgui.indent()

				local var_8_15 = 0
				local var_8_16 = arg_8_3 == nil and var_8_3 and string.find(var_8_4, arg_8_1.filter) or arg_8_3

				for iter_8_0 = 1, var_8_14 do
					local var_8_17, var_8_18 = arg_8_0:_recursive_header(arg_8_1, var_8_13[iter_8_0], var_8_16, arg_8_4 + 1)

					if var_8_17 or not var_8_3 or var_8_18 then
						var_8_15 = var_8_15 + 1

						if var_8_11 <= var_8_15 then
							var_8_16 = false
						end
					end
				end

				local var_8_19 = var_8_15 - var_8_11

				if var_8_19 > 0 then
					local var_8_20 = math.min(var_0_4, var_8_19)

					if Imgui.button(string.format("Show %s (out of %s) more...", var_8_20, var_8_19)) then
						arg_8_1.max_children[arg_8_2] = (arg_8_1.max_children[arg_8_2] or var_0_4) + var_8_20
					end
				end

				Imgui.unindent()
			end
		else
			arg_8_1.remember_open[arg_8_2] = false
			arg_8_1.max_children[arg_8_2] = nil
		end
	end

	return var_8_1, arg_8_1.filtered_ids[arg_8_2]
end
