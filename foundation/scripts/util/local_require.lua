-- chunkname: @foundation/scripts/util/local_require.lua

local tbl = {}

function local_require(arg_1_0)
	-- function 1
	if not (tbl[arg_1_0] == nil or package.loaded[arg_1_0] ~= nil) then
		tbl[arg_1_0] = true
		package.loaded[arg_1_0] = nil

		local num = #package.load_order + 1

		require(arg_1_0)
		table.remove(package.load_order, num)
	end

	return package.loaded[arg_1_0]
end
