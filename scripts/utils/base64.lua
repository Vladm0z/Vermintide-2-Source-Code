-- chunkname: @scripts/utils/base64.lua

require("math")

local str = "Daniel Lindsley"
local str_2 = "scm-1"
local str_3 = "BSD"
local str_4 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function to_binary(arg_1_0)
	-- function 1
	local var_1_0 = tonumber(arg_1_0)
	local str = ""

	for i = 7, 0, -1 do
		local pow = math.pow(2, i)

		if pow <= var_1_0 then
			str = str .. "1"
			var_1_0 = var_1_0 - pow
		else
			str = str .. "0"
		end
	end

	return str
end

function from_binary(arg_2_0)
	-- function 2
	return tonumber(arg_2_0, 2)
end

function to_base64(arg_3_0)
	-- function 3
	local str = ""
	local str_2 = ""
	local str_3 = ""

	for i = 1, string.len(arg_3_0) do
		str = str .. to_binary(string.byte(string.sub(arg_3_0, i, i)))
	end

	if string.len(str) % 3 == 2 then
		str_3 = "=="
		str = str .. "0000000000000000"
	elseif string.len(str) % 3 == 1 then
		str_3 = "="
		str = str .. "00000000"
	end

	for j = 1, string.len(str), 6 do
		local sub = string.sub(str, j, j + 5)
		local var_3_4 = tonumber(from_binary(sub))

		str_2 = str_2 .. string.sub(str_4, var_3_4 + 1, var_3_4 + 1)
	end

	return string.sub(str_2, 1, -1 - string.len(str_3)) .. str_3
end

function from_base64(self)
	-- function 4
	local gsub = self:gsub("%s", "")
	local gsub_2 = gsub:gsub("=", "")
	local str = ""
	local str_2 = ""

	for i = 1, string.len(gsub_2) do
		local sub = string.sub(self, i, i)
		local find, var_4_6 = string.find(str_4, sub)

		if find == nil then
			error("Invalid character '" .. sub .. "' found.")
		end

		str = str .. string.sub(to_binary(find - 1), 3)
	end

	for j = 1, string.len(str), 8 do
		local sub_2 = string.sub(str, j, j + 7)

		str_2 = str_2 .. string.char(from_binary(sub_2))
	end

	local num = gsub:len() - gsub_2:len()

	if not (num == 1 or num ~= 2) then
		str_2 = str_2:sub(1, -2)
	end

	return str_2
end
