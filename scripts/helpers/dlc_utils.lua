-- chunkname: @scripts/helpers/dlc_utils.lua

if not DLCUtils then
	DLCUtils = {
		check_dupes = true
	}
else
	DLCUtils.check_dupes = false
end

function DLCUtils.map(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(DLCSettings) do
		if iter_1_1[arg_1_0] then
			arg_1_1(iter_1_1[arg_1_0])
		end
	end
end

function DLCUtils.map_list(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(DLCSettings) do
		local var_2_0 = iter_2_1[arg_2_0]

		if var_2_0 then
			for iter_2_2, iter_2_3 in pairs(var_2_0) do
				arg_2_1(iter_2_3)
			end
		end
	end
end

function DLCUtils.require(arg_3_0, arg_3_1)
	return DLCUtils.map(arg_3_0, arg_3_1 and local_require or require)
end

function DLCUtils.require_list(arg_4_0, arg_4_1)
	return DLCUtils.map_list(arg_4_0, arg_4_1 and local_require or require)
end

function DLCUtils.dofile(arg_5_0)
	return DLCUtils.map(arg_5_0, dofile)
end

function DLCUtils.dofile_list(arg_6_0)
	return DLCUtils.map_list(arg_6_0, dofile)
end

function DLCUtils.append(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = #arg_7_1

	for iter_7_0, iter_7_1 in pairs(DLCSettings) do
		local var_7_1 = iter_7_1[arg_7_0]

		if var_7_1 then
			for iter_7_2 = 1, #var_7_1 do
				var_7_0 = var_7_0 + 1
				arg_7_1[var_7_0] = var_7_1[iter_7_2]
			end
		end
	end
end

function DLCUtils.merge(arg_8_0, arg_8_1, arg_8_2)
	for iter_8_0, iter_8_1 in pairs(DLCSettings) do
		local var_8_0 = iter_8_1[arg_8_0]

		if var_8_0 then
			table.merge_recursive(arg_8_1, var_8_0)
		end
	end
end
