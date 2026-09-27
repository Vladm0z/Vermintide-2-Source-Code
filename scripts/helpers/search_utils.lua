-- chunkname: @scripts/helpers/search_utils.lua

local SearchUtils = SearchUtils

SearchUtils = SearchUtils or {}
SearchUtils = SearchUtils

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	for i = 1, #arg_1_2 do
		local var_1_0 = arg_1_2[i]
		local var_1_1 = Localize(var_1_0[2])

		for iter_1_1 in string.gmatch(var_1_1, "[^,]+") do
			iter_1_1 = Utf8.lower(string.gsub(iter_1_1, "%s+", ""))

			local num = arg_1_1 + #iter_1_1 - 1

			if string.sub(arg_1_0, arg_1_1, num) == iter_1_1 then
				return var_1_0[1], num
			end
		end
	end

	return nil, nil
end

SearchUtils.extract_queries = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	arg_2_0 = Utf8.lower(arg_2_0)

	for i = 1, #arg_2_1 do
		local var_2_0 = arg_2_1[i]
		local key = var_2_0.key
		local str = Localize("search_filter_" .. key) .. "%s*:%s*"
		local find, var_2_4 = string.find(arg_2_0, str)

		if not find then
			local var_2_5, var_2_6 = fn(arg_2_0, var_2_4 + 1, var_2_0)

			if var_2_5 ~= nil then
				arg_2_2[key] = var_2_5
				arg_2_0 = string.remove(arg_2_0, find, var_2_6)
			end
		end
	end

	arg_2_0 = string.trim(string.gsub(arg_2_0, "%s+", " "))

	return arg_2_0, arg_2_2
end

local find = string.find
local lower = Utf8.lower

SearchUtils.simple_search = function (arg_3_0, arg_3_1)
	-- function 3
	return (find(lower(arg_3_1), arg_3_0, 1, true))
end
