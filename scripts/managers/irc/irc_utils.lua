-- chunkname: @scripts/managers/irc/irc_utils.lua

IrcUtils = {}

function IrcUtils.convert_steam_user_id_to_base_64(arg_1_0)
	local var_1_0 = {
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
	local var_1_1 = Application.hex64_to_dec(arg_1_0)
	local var_1_2 = Math.base_10_to_base(var_1_1, 64)

	table.reverse(var_1_2)

	local var_1_3 = ""

	for iter_1_0, iter_1_1 in ipairs(var_1_2) do
		local var_1_4 = tonumber(iter_1_1) + 1

		var_1_3 = var_1_3 .. var_1_0[var_1_4]
	end

	return var_1_3
end
