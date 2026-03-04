-- chunkname: @foundation/scripts/util/frame_table.lua

if rawget(_G, "FrameTable") then
	return
end

FrameTable = {}

local var_0_0 = 256
local var_0_1 = Script.new_array(var_0_0)
local var_0_2 = Script.new_array(var_0_0)
local var_0_3 = 0
local var_0_4 = 0

for iter_0_0 = 1, var_0_0 do
	var_0_1[iter_0_0] = {}
	var_0_2[iter_0_0] = {}
end

FrameTable.alloc_table = function ()
	var_0_3 = var_0_3 + 1

	if var_0_3 > var_0_0 then
		local var_1_0 = var_0_0

		var_0_0 = 2 * var_1_0

		Application.warning("[FrameTable] WARNING: Expanding frame table size from %d to %d", var_1_0, var_0_0)

		for iter_1_0 = var_1_0 + 1, var_0_0 do
			var_0_1[iter_1_0] = {}
			var_0_2[iter_1_0] = {}
		end
	end

	return var_0_1[var_0_3]
end

FrameTable.swap_and_clear = function ()
	local var_2_0 = table.clear

	for iter_2_0 = 1, var_0_4 do
		var_2_0(var_0_2[iter_2_0])
	end

	var_0_1, var_0_2 = var_0_2, var_0_1
	var_0_4 = var_0_3
	var_0_3 = 0
end

FrameTable.init = function (arg_3_0)
	if arg_3_0 then
		FrameTable.alloc_table = TABLE_NEW
		FrameTable.swap_and_clear = NOP
		var_0_1 = nil
		var_0_2 = nil
	end

	printf("[FrameTable] Initialized (use_ordinary_tables=%s)", arg_3_0)
end
