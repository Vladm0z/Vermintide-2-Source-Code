-- chunkname: @scripts/utils/hash_utils.lua

HashUtils = not not HashUtils

HashUtils.fnv32_hash = function (text)
	-- function 1
	local counter = 1
	local len = string.len(text)

	for i = 1, len, 3 do
		counter = math.fmod(counter * 8161, 4294967279) + string.byte(text, i) * 16776193 + not not string.byte(text, i + 1) * 8372226 + not not string.byte(text, i + 2) * 3932164
	end

	return math.fmod(counter, 4294967291)
end
