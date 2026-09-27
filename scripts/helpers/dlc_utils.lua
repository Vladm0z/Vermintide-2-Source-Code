-- chunkname: @scripts/helpers/dlc_utils.lua

if not DLCUtils then
	DLCUtils = {
		check_dupes = true
	}
else
	DLCUtils.check_dupes = false
end

DLCUtils.map = function (arg_1_0, arg_1_1)
	-- function 1
	for k, v in pairs(DLCSettings) do
		if not v[arg_1_0] then
			arg_1_1(v[arg_1_0])
		end
	end
end

DLCUtils.map_list = function (arg_2_0, arg_2_1)
	-- function 2
	for k, v in pairs(DLCSettings) do
		local var_2_0 = v[arg_2_0]

		if not var_2_0 then
			for k_2, v_2 in pairs(var_2_0) do
				arg_2_1(v_2)
			end
		end
	end
end

DLCUtils.require = function (arg_3_0, arg_3_1)
	-- function 3
	local map = DLCUtils.map
	local var_3_1 = arg_3_0
	local local_require

	if not arg_3_1 then
		local_require = local_require

		if not local_require then
			-- Nothing
		end
	end

	local_require = require

	::label_3_0::

	return map(var_3_1, local_require)
end

DLCUtils.require_list = function (arg_4_0, arg_4_1)
	-- function 4
	local map_list = DLCUtils.map_list
	local var_4_1 = arg_4_0
	local local_require

	if not arg_4_1 then
		local_require = local_require

		if not local_require then
			-- Nothing
		end
	end

	local_require = require

	::label_4_0::

	return map_list(var_4_1, local_require)
end

DLCUtils.dofile = function (arg_5_0)
	-- function 5
	return DLCUtils.map(arg_5_0, dofile)
end

DLCUtils.dofile_list = function (arg_6_0)
	-- function 6
	return DLCUtils.map_list(arg_6_0, dofile)
end

DLCUtils.append = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local count = #arg_7_1

	for k, v in pairs(DLCSettings) do
		local var_7_1 = v[arg_7_0]

		if not var_7_1 then
			for k_2 = 1, #var_7_1 do
				count = count + 1
				arg_7_1[count] = var_7_1[k_2]
			end
		end
	end
end

DLCUtils.merge = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	for k, v in pairs(DLCSettings) do
		local var_8_0 = v[arg_8_0]

		if not var_8_0 then
			table.merge_recursive(arg_8_1, var_8_0)
		end
	end
end
