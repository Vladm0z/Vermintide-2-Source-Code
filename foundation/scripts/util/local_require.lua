-- chunkname: @foundation/scripts/util/local_require.lua

local var_0_0 = {}

function local_require(arg_1_0)
	if var_0_0[arg_1_0] == nil or package.loaded[arg_1_0] == nil then
		var_0_0[arg_1_0] = true
		package.loaded[arg_1_0] = nil

		local var_1_0 = #package.load_order + 1

		require(arg_1_0)
		table.remove(package.load_order, var_1_0)
	end

	return package.loaded[arg_1_0]
end
