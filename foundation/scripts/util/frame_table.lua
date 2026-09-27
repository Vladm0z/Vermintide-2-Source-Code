-- chunkname: @foundation/scripts/util/frame_table.lua

if not rawget(_G, "FrameTable") then
	return
end

FrameTable = {}

local num = 256
local new_array = Script.new_array(num)
local new_array_2 = Script.new_array(num)
local num_2 = 0
local num_3 = 0

for i = 1, num do
	new_array[i] = {}
	new_array_2[i] = {}
end

FrameTable.alloc_table = function ()
	-- function 1
	num_2 = num_2 + 1

	if num_2 > num then
		local var_1_0 = num

		num = 2 * var_1_0

		Application.warning("[FrameTable] WARNING: Expanding frame table size from %d to %d", var_1_0, num)

		for i = var_1_0 + 1, num do
			new_array[i] = {}
			new_array_2[i] = {}
		end
	end

	return new_array[num_2]
end

FrameTable.swap_and_clear = function ()
	-- function 2
	local clear = table.clear

	for i = 1, num_3 do
		clear(new_array_2[i])
	end

	new_array, new_array_2 = new_array_2, new_array
	num_3 = num_2
	num_2 = 0
end

FrameTable.init = function (arg_3_0)
	-- function 3
	if not arg_3_0 then
		FrameTable.alloc_table = TABLE_NEW
		FrameTable.swap_and_clear = NOP
		new_array = nil
		new_array_2 = nil
	end

	printf("[FrameTable] Initialized (use_ordinary_tables=%s)", arg_3_0)
end
