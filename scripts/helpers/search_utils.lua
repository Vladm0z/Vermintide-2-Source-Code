-- chunkname: @scripts/helpers/search_utils.lua

SearchUtils = SearchUtils or {}

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	for iter_1_0 = 1, #arg_1_2 do
		local var_1_0 = arg_1_2[iter_1_0]
		local var_1_1 = Localize(var_1_0[2])

		for iter_1_1 in string.gmatch(var_1_1, "[^,]+") do
			iter_1_1 = Utf8.lower(string.gsub(iter_1_1, "%s+", ""))

			local var_1_2 = arg_1_1 + #iter_1_1 - 1

			if string.sub(arg_1_0, arg_1_1, var_1_2) == iter_1_1 then
				return var_1_0[1], var_1_2
			end
		end
	end

	return nil, nil
end

SearchUtils.extract_queries = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0 = Utf8.lower(arg_2_0)

	for iter_2_0 = 1, #arg_2_1 do
		local var_2_0 = arg_2_1[iter_2_0]
		local var_2_1 = var_2_0.key
		local var_2_2 = Localize("search_filter_" .. var_2_1) .. "%s*:%s*"
		local var_2_3, var_2_4 = string.find(arg_2_0, var_2_2)

		if var_2_3 then
			local var_2_5, var_2_6 = var_0_0(arg_2_0, var_2_4 + 1, var_2_0)

			if var_2_5 ~= nil then
				arg_2_2[var_2_1] = var_2_5
				arg_2_0 = string.remove(arg_2_0, var_2_3, var_2_6)
			end
		end
	end

	arg_2_0 = string.trim(string.gsub(arg_2_0, "%s+", " "))

	return arg_2_0, arg_2_2
end

local var_0_1 = string.find
local var_0_2 = Utf8.lower

SearchUtils.simple_search = function (arg_3_0, arg_3_1)
	return (var_0_1(var_0_2(arg_3_1), arg_3_0, 1, true))
end
