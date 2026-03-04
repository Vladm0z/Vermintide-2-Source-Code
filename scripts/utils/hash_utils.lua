-- chunkname: @scripts/utils/hash_utils.lua

HashUtils = HashUtils or {}

HashUtils.fnv32_hash = function (arg_1_0)
	local var_1_0 = 1
	local var_1_1 = string.len(arg_1_0)

	for iter_1_0 = 1, var_1_1, 3 do
		var_1_0 = math.fmod(var_1_0 * 8161, 4294967279) + string.byte(arg_1_0, iter_1_0) * 16776193 + (string.byte(arg_1_0, iter_1_0 + 1) or var_1_1 - iter_1_0 + 256) * 8372226 + (string.byte(arg_1_0, iter_1_0 + 2) or var_1_1 - iter_1_0 + 256) * 3932164
	end

	return math.fmod(var_1_0, 4294967291)
end
