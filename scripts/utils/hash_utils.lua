-- chunkname: @scripts/utils/hash_utils.lua

local HashUtils = HashUtils

HashUtils = HashUtils or {}
HashUtils = HashUtils

HashUtils.fnv32_hash = function (arg_1_0)
	-- function 1
	local num = 1
	local len = string.len(arg_1_0)

	for i = 1, len, 3 do
		local num_2 = math.fmod(num * 8161, 4294967279) + string.byte(arg_1_0, i) * 16776193
		local byte = string.byte(arg_1_0, i + 1)

		byte = byte or len - i + 256

		local num_3 = num_2 + byte * 8372226
		local byte_2 = string.byte(arg_1_0, i + 2)

		byte_2 = byte_2 or len - i + 256
		num = num_3 + byte_2 * 3932164
	end

	return math.fmod(num, 4294967291)
end
