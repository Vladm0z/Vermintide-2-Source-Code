-- chunkname: @scripts/helpers/dlc_utils.lua

if not DLCUtils then
	DLCUtils = {
		check_dupes = true
	}
else
	DLCUtils.check_dupes = false
end

DLCUtils.map = function (table_path, func)
	-- function 1
	for dlc_name, dlc in pairs(DLCSettings) do
		local val = dlc[table_path]

		if val then
			func(dlc[table_path])
		end
	end
end

DLCUtils.map_list = function (table_path, func)
	-- function 2
	for dlc_name, dlc in pairs(DLCSettings) do
		local list = dlc[table_path]

		if list then
			for _, val in pairs(list) do
				func(val)
			end
		end
	end
end

DLCUtils.require = function (table_path, force_local_require)
	-- function 3
	local map = DLCUtils.map
	local var_3_1 = table_path
	local local_require

	if force_local_require then
		local_require = local_require

		if not local_require then
			-- Nothing
		end
	end

	local_require = require

	::label_3_0::

	return map(var_3_1, local_require)
end

DLCUtils.require_list = function (table_path, force_local_require)
	-- function 4
	local map_list = DLCUtils.map_list
	local var_4_1 = table_path
	local local_require

	if force_local_require then
		local_require = local_require

		if not local_require then
			-- Nothing
		end
	end

	local_require = require

	::label_4_0::

	return map_list(var_4_1, local_require)
end

DLCUtils.dofile = function (table_path)
	-- function 5
	return DLCUtils.map(table_path, dofile)
end

DLCUtils.dofile_list = function (table_path)
	-- function 6
	return DLCUtils.map_list(table_path, dofile)
end

DLCUtils.append = function (table_path, dst, allow_dupes)
	-- function 7
	local n = #dst

	for dlc_name, dlc in pairs(DLCSettings) do
		local val = dlc[table_path]

		if val then
			for i = 1, #val do
				n = n + 1
				dst[n] = val[i]
			end
		end
	end
end

DLCUtils.merge = function (table_path, dst, allow_dupes)
	-- function 8
	for dlc_name, dlc in pairs(DLCSettings) do
		local src = dlc[table_path]

		if src then
			table.merge_recursive(dst, src)
		end
	end
end
