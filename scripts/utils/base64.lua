-- chunkname: @scripts/utils/base64.lua

require("math")

local var_0_0 = "Daniel Lindsley"
local var_0_1 = "scm-1"
local var_0_2 = "BSD"
local var_0_3 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function to_binary(arg_1_0)
	local var_1_0 = tonumber(arg_1_0)
	local var_1_1 = ""

	for iter_1_0 = 7, 0, -1 do
		local var_1_2 = math.pow(2, iter_1_0)

		if var_1_2 <= var_1_0 then
			var_1_1 = var_1_1 .. "1"
			var_1_0 = var_1_0 - var_1_2
		else
			var_1_1 = var_1_1 .. "0"
		end
	end

	return var_1_1
end

function from_binary(arg_2_0)
	return tonumber(arg_2_0, 2)
end

function to_base64(arg_3_0)
	local var_3_0 = ""
	local var_3_1 = ""
	local var_3_2 = ""

	for iter_3_0 = 1, string.len(arg_3_0) do
		var_3_0 = var_3_0 .. to_binary(string.byte(string.sub(arg_3_0, iter_3_0, iter_3_0)))
	end

	if string.len(var_3_0) % 3 == 2 then
		var_3_2 = "=="
		var_3_0 = var_3_0 .. "0000000000000000"
	elseif string.len(var_3_0) % 3 == 1 then
		var_3_2 = "="
		var_3_0 = var_3_0 .. "00000000"
	end

	for iter_3_1 = 1, string.len(var_3_0), 6 do
		local var_3_3 = string.sub(var_3_0, iter_3_1, iter_3_1 + 5)
		local var_3_4 = tonumber(from_binary(var_3_3))

		var_3_1 = var_3_1 .. string.sub(var_0_3, var_3_4 + 1, var_3_4 + 1)
	end

	return string.sub(var_3_1, 1, -1 - string.len(var_3_2)) .. var_3_2
end

function from_base64(arg_4_0)
	local var_4_0 = arg_4_0:gsub("%s", "")
	local var_4_1 = var_4_0:gsub("=", "")
	local var_4_2 = ""
	local var_4_3 = ""

	for iter_4_0 = 1, string.len(var_4_1) do
		local var_4_4 = string.sub(arg_4_0, iter_4_0, iter_4_0)
		local var_4_5, var_4_6 = string.find(var_0_3, var_4_4)

		if var_4_5 == nil then
			error("Invalid character '" .. var_4_4 .. "' found.")
		end

		var_4_2 = var_4_2 .. string.sub(to_binary(var_4_5 - 1), 3)
	end

	for iter_4_1 = 1, string.len(var_4_2), 8 do
		local var_4_7 = string.sub(var_4_2, iter_4_1, iter_4_1 + 7)

		var_4_3 = var_4_3 .. string.char(from_binary(var_4_7))
	end

	local var_4_8 = var_4_0:len() - var_4_1:len()

	if var_4_8 == 1 or var_4_8 == 2 then
		var_4_3 = var_4_3:sub(1, -2)
	end

	return var_4_3
end
