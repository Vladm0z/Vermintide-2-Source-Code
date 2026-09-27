-- chunkname: @scripts/managers/irc/irc_utils.lua

IrcUtils = {}

IrcUtils.convert_steam_user_id_to_base_64 = function (arg_1_0)
	-- function 1
	local tbl = {
		"0",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		"A",
		"B",
		"C",
		"D",
		"E",
		"F",
		"G",
		"H",
		"I",
		"J",
		"K",
		"L",
		"M",
		"N",
		"O",
		"P",
		"Q",
		"R",
		"S",
		"T",
		"U",
		"V",
		"W",
		"X",
		"Y",
		"Z",
		"a",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k",
		"l",
		"m",
		"n",
		"o",
		"p",
		"q",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z",
		"[",
		"]"
	}
	local hex64_to_dec = Application.hex64_to_dec(arg_1_0)
	local base_10_to_base = Math.base_10_to_base(hex64_to_dec, 64)

	table.reverse(base_10_to_base)

	local str = ""

	for i, v in ipairs(base_10_to_base) do
		local num = tonumber(v) + 1

		str = str .. tbl[num]
	end

	return str
end
