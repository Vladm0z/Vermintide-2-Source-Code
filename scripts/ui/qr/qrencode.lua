-- chunkname: @scripts/ui/qr/qrencode.lua

local flag = false
local flag_2 = false
local bxor = require("bit").bxor

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local format = string.format("%o", arg_1_0)
	local tbl = {
		["0"] = "000",
		["1"] = "001",
		["6"] = "110",
		["2"] = "010",
		["5"] = "101",
		["3"] = "011",
		["7"] = "111",
		["4"] = "100"
	}
	local gsub = string.gsub(format, "(.)", function (arg_2_0)
		-- function 2
		return tbl[arg_2_0]
	end)
	local gsub_2 = string.gsub(gsub, "^0*(.*)$", "%1")
	local format_2 = string.format("%%%ds", arg_1_1)
	local format_3 = string.format(format_2, gsub_2)

	return string.gsub(format_3, " ", "0")
end

local function fn_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	if arg_3_1 == "1" then
		arg_3_0[arg_3_2][arg_3_3] = 2
	else
		arg_3_0[arg_3_2][arg_3_3] = -2
	end
end

local function fn_3(arg_4_0)
	-- function 4
	local var_4_0

	if not string.match(arg_4_0, "^[0-9]+$") then
		return 1
	elseif not string.match(arg_4_0, "^[0-9A-Z $%%*./:+-]+$") then
		return 2
	else
		return 4
	end

	assert(false, "never reached")

	return nil
end

local tbl = {
	{
		19,
		16,
		13,
		9
	},
	{
		34,
		28,
		22,
		16
	},
	{
		55,
		44,
		34,
		26
	},
	{
		80,
		64,
		48,
		36
	},
	{
		108,
		86,
		62,
		46
	},
	{
		136,
		108,
		76,
		60
	},
	{
		156,
		124,
		88,
		66
	},
	{
		194,
		154,
		110,
		86
	},
	{
		232,
		182,
		132,
		100
	},
	{
		274,
		216,
		154,
		122
	},
	{
		324,
		254,
		180,
		140
	},
	{
		370,
		290,
		206,
		158
	},
	{
		428,
		334,
		244,
		180
	},
	{
		461,
		365,
		261,
		197
	},
	{
		523,
		415,
		295,
		223
	},
	{
		589,
		453,
		325,
		253
	},
	{
		647,
		507,
		367,
		283
	},
	{
		721,
		563,
		397,
		313
	},
	{
		795,
		627,
		445,
		341
	},
	{
		861,
		669,
		485,
		385
	},
	{
		932,
		714,
		512,
		406
	},
	{
		1006,
		782,
		568,
		442
	},
	{
		1094,
		860,
		614,
		464
	},
	{
		1174,
		914,
		664,
		514
	},
	{
		1276,
		1000,
		718,
		538
	},
	{
		1370,
		1062,
		754,
		596
	},
	{
		1468,
		1128,
		808,
		628
	},
	{
		1531,
		1193,
		871,
		661
	},
	{
		1631,
		1267,
		911,
		701
	},
	{
		1735,
		1373,
		985,
		745
	},
	{
		1843,
		1455,
		1033,
		793
	},
	{
		1955,
		1541,
		1115,
		845
	},
	{
		2071,
		1631,
		1171,
		901
	},
	{
		2191,
		1725,
		1231,
		961
	},
	{
		2306,
		1812,
		1286,
		986
	},
	{
		2434,
		1914,
		1354,
		1054
	},
	{
		2566,
		1992,
		1426,
		1096
	},
	{
		2702,
		2102,
		1502,
		1142
	},
	{
		2812,
		2216,
		1582,
		1222
	},
	{
		2956,
		2334,
		1666,
		1276
	}
}

local function fn_4(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = arg_5_1

	if arg_5_1 == 4 then
		var_5_0 = 3
	elseif arg_5_1 == 8 then
		var_5_0 = 4
	end

	assert(var_5_0 <= 4)

	local var_5_1
	local var_5_2
	local var_5_3
	local var_5_4
	local var_5_5
	local tbl_2 = {
		{
			10,
			9,
			8,
			8
		},
		{
			12,
			11,
			16,
			10
		},
		{
			14,
			13,
			16,
			12
		}
	}
	local num = 40
	local flag = arg_5_2 or 1
	local num_2 = 1
	local num_3 = 4

	if not (not arg_5_2 and not (arg_5_2 >= 1) or not (arg_5_2 <= 4)) then
		num_2 = arg_5_2
		num_3 = arg_5_2
	end

	for i = num_2, num_3 do
		for j = 1, #tbl do
			local num_4 = tbl[j][i] * 8 - 4

			if j < 10 then
				var_5_3 = tbl_2[1][var_5_0]
			elseif j < 27 then
				var_5_3 = tbl_2[2][var_5_0]
			elseif j <= 40 then
				var_5_3 = tbl_2[3][var_5_0]
			end

			local num_5 = num_4 - var_5_3

			if var_5_0 == 1 then
				var_5_5 = math.floor(num_5 * 3 / 10)
			elseif var_5_0 == 2 then
				var_5_5 = math.floor(num_5 * 2 / 11)
			elseif var_5_0 == 3 then
				var_5_5 = math.floor(num_5 * 1 / 8)
			else
				var_5_5 = math.floor(num_5 * 1 / 13)
			end

			if arg_5_0 <= var_5_5 then
				if j <= num then
					num = j
					flag = i
				end

				break
			end
		end
	end

	return num, flag
end

local function fn_5(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = arg_6_2

	if arg_6_2 == 4 then
		var_6_0 = 3
	elseif arg_6_2 == 8 then
		var_6_0 = 4
	end

	assert(var_6_0 <= 4)

	local tbl = {
		{
			10,
			9,
			8,
			8
		},
		{
			12,
			11,
			16,
			10
		},
		{
			14,
			13,
			16,
			12
		}
	}
	local var_6_2

	if arg_6_1 < 10 then
		var_6_2 = tbl[1][var_6_0]
	elseif arg_6_1 < 27 then
		var_6_2 = tbl[2][var_6_0]
	elseif arg_6_1 <= 40 then
		var_6_2 = tbl[3][var_6_0]
	else
		assert(false, "get_length, version > 40 not supported")
	end

	return (fn(#arg_6_0, var_6_2))
end

local function fn_6(arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0

	if not arg_7_2 then
		assert(false, "not implemented")

		var_7_0 = arg_7_2
	else
		var_7_0 = fn_3(arg_7_0)
	end

	local var_7_1
	local var_7_2
	local var_7_3, var_7_4 = fn_4(#arg_7_0, var_7_0, arg_7_1)
	local var_7_5 = fn_5(arg_7_0, var_7_3, var_7_0)

	return var_7_3, var_7_4, fn(var_7_0, 4), var_7_0, var_7_5
end

local tbl_2 = {
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	36,
	-1,
	-1,
	-1,
	37,
	38,
	-1,
	-1,
	-1,
	-1,
	39,
	40,
	-1,
	41,
	42,
	43,
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	44,
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20,
	21,
	22,
	23,
	24,
	25,
	26,
	27,
	28,
	29,
	30,
	31,
	32,
	33,
	34,
	35,
	-1,
	-1,
	-1,
	-1,
	-1
}

local function fn_7(arg_8_0)
	-- function 8
	local str = ""
	local var_8_1

	string.gsub(arg_8_0, "..?.?", function (arg_9_0)
		-- function 9
		var_8_1 = tonumber(arg_9_0)

		if #arg_9_0 == 3 then
			str = str .. fn(var_8_1, 10)
		elseif #arg_9_0 == 2 then
			str = str .. fn(var_8_1, 7)
		else
			str = str .. fn(var_8_1, 4)
		end
	end)

	return str
end

local function fn_8(arg_10_0)
	-- function 10
	local str = ""
	local var_10_1
	local var_10_2
	local var_10_3

	string.gsub(arg_10_0, "..?", function (arg_11_0)
		-- function 11
		if #arg_11_0 == 2 then
			var_10_2 = tbl_2[string.byte(string.sub(arg_11_0, 1, 1))]
			var_10_3 = tbl_2[string.byte(string.sub(arg_11_0, 2, 2))]
			var_10_1 = var_10_2 * 45 + var_10_3
			str = str .. fn(var_10_1, 11)
		else
			var_10_1 = tbl_2[string.byte(arg_11_0)]
			str = str .. fn(var_10_1, 6)
		end
	end)

	return str
end

local function fn_9(arg_12_0)
	-- function 12
	local tbl = {}

	string.gsub(arg_12_0, ".", function (arg_13_0)
		-- function 13
		tbl[#tbl + 1] = fn(string.byte(arg_13_0), 8)
	end)

	return table.concat(tbl)
end

local function fn_10(arg_14_0, arg_14_1)
	-- function 14
	if arg_14_1 == 1 then
		return fn_7(arg_14_0)
	elseif arg_14_1 == 2 then
		return fn_8(arg_14_0)
	elseif arg_14_1 == 4 then
		return fn_9(arg_14_0)
	else
		assert(false, "not implemented yet")
	end
end

local function fn_11(arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0
	local var_15_1
	local num = tbl[arg_15_0][arg_15_1] * 8
	local min = math.min(4, num - #arg_15_2)

	if min > 0 then
		arg_15_2 = arg_15_2 .. string.rep("0", min)
	end

	if math.fmod(#arg_15_2, 8) ~= 0 then
		local num_2 = 8 - math.fmod(#arg_15_2, 8)

		arg_15_2 = arg_15_2 .. string.rep("0", num_2)
	end

	assert(math.fmod(#arg_15_2, 8) == 0)

	while num > #arg_15_2 do
		arg_15_2 = arg_15_2 .. "11101100"

		if num > #arg_15_2 then
			arg_15_2 = arg_15_2 .. "00010001"
		end
	end

	return arg_15_2
end

local tbl_3 = {
	[0] = 0,
	2,
	4,
	8,
	16,
	32,
	64,
	128,
	29,
	58,
	116,
	232,
	205,
	135,
	19,
	38,
	76,
	152,
	45,
	90,
	180,
	117,
	234,
	201,
	143,
	3,
	6,
	12,
	24,
	48,
	96,
	192,
	157,
	39,
	78,
	156,
	37,
	74,
	148,
	53,
	106,
	212,
	181,
	119,
	238,
	193,
	159,
	35,
	70,
	140,
	5,
	10,
	20,
	40,
	80,
	160,
	93,
	186,
	105,
	210,
	185,
	111,
	222,
	161,
	95,
	190,
	97,
	194,
	153,
	47,
	94,
	188,
	101,
	202,
	137,
	15,
	30,
	60,
	120,
	240,
	253,
	231,
	211,
	187,
	107,
	214,
	177,
	127,
	254,
	225,
	223,
	163,
	91,
	182,
	113,
	226,
	217,
	175,
	67,
	134,
	17,
	34,
	68,
	136,
	13,
	26,
	52,
	104,
	208,
	189,
	103,
	206,
	129,
	31,
	62,
	124,
	248,
	237,
	199,
	147,
	59,
	118,
	236,
	197,
	151,
	51,
	102,
	204,
	133,
	23,
	46,
	92,
	184,
	109,
	218,
	169,
	79,
	158,
	33,
	66,
	132,
	21,
	42,
	84,
	168,
	77,
	154,
	41,
	82,
	164,
	85,
	170,
	73,
	146,
	57,
	114,
	228,
	213,
	183,
	115,
	230,
	209,
	191,
	99,
	198,
	145,
	63,
	126,
	252,
	229,
	215,
	179,
	123,
	246,
	241,
	255,
	227,
	219,
	171,
	75,
	150,
	49,
	98,
	196,
	149,
	55,
	110,
	220,
	165,
	87,
	174,
	65,
	130,
	25,
	50,
	100,
	200,
	141,
	7,
	14,
	28,
	56,
	112,
	224,
	221,
	167,
	83,
	166,
	81,
	162,
	89,
	178,
	121,
	242,
	249,
	239,
	195,
	155,
	43,
	86,
	172,
	69,
	138,
	9,
	18,
	36,
	72,
	144,
	61,
	122,
	244,
	245,
	247,
	243,
	251,
	235,
	203,
	139,
	11,
	22,
	44,
	88,
	176,
	125,
	250,
	233,
	207,
	131,
	27,
	54,
	108,
	216,
	173,
	71,
	142,
	1
}
local tbl_4 = {
	[0] = 0,
	255,
	1,
	25,
	2,
	50,
	26,
	198,
	3,
	223,
	51,
	238,
	27,
	104,
	199,
	75,
	4,
	100,
	224,
	14,
	52,
	141,
	239,
	129,
	28,
	193,
	105,
	248,
	200,
	8,
	76,
	113,
	5,
	138,
	101,
	47,
	225,
	36,
	15,
	33,
	53,
	147,
	142,
	218,
	240,
	18,
	130,
	69,
	29,
	181,
	194,
	125,
	106,
	39,
	249,
	185,
	201,
	154,
	9,
	120,
	77,
	228,
	114,
	166,
	6,
	191,
	139,
	98,
	102,
	221,
	48,
	253,
	226,
	152,
	37,
	179,
	16,
	145,
	34,
	136,
	54,
	208,
	148,
	206,
	143,
	150,
	219,
	189,
	241,
	210,
	19,
	92,
	131,
	56,
	70,
	64,
	30,
	66,
	182,
	163,
	195,
	72,
	126,
	110,
	107,
	58,
	40,
	84,
	250,
	133,
	186,
	61,
	202,
	94,
	155,
	159,
	10,
	21,
	121,
	43,
	78,
	212,
	229,
	172,
	115,
	243,
	167,
	87,
	7,
	112,
	192,
	247,
	140,
	128,
	99,
	13,
	103,
	74,
	222,
	237,
	49,
	197,
	254,
	24,
	227,
	165,
	153,
	119,
	38,
	184,
	180,
	124,
	17,
	68,
	146,
	217,
	35,
	32,
	137,
	46,
	55,
	63,
	209,
	91,
	149,
	188,
	207,
	205,
	144,
	135,
	151,
	178,
	220,
	252,
	190,
	97,
	242,
	86,
	211,
	171,
	20,
	42,
	93,
	158,
	132,
	60,
	57,
	83,
	71,
	109,
	65,
	162,
	31,
	45,
	67,
	216,
	183,
	123,
	164,
	118,
	196,
	23,
	73,
	236,
	127,
	12,
	111,
	246,
	108,
	161,
	59,
	82,
	41,
	157,
	85,
	170,
	251,
	96,
	134,
	177,
	187,
	204,
	62,
	90,
	203,
	89,
	95,
	176,
	156,
	169,
	160,
	81,
	11,
	245,
	22,
	235,
	122,
	117,
	44,
	215,
	79,
	174,
	213,
	233,
	230,
	231,
	173,
	232,
	116,
	214,
	244,
	234,
	168,
	80,
	88,
	175
}
local tbl_5 = {
	[7] = {
		21,
		102,
		238,
		149,
		146,
		229,
		87,
		0
	},
	[10] = {
		45,
		32,
		94,
		64,
		70,
		118,
		61,
		46,
		67,
		251,
		0
	},
	[13] = {
		78,
		140,
		206,
		218,
		130,
		104,
		106,
		100,
		86,
		100,
		176,
		152,
		74,
		0
	},
	[15] = {
		105,
		99,
		5,
		124,
		140,
		237,
		58,
		58,
		51,
		37,
		202,
		91,
		61,
		183,
		8,
		0
	},
	[16] = {
		120,
		225,
		194,
		182,
		169,
		147,
		191,
		91,
		3,
		76,
		161,
		102,
		109,
		107,
		104,
		120,
		0
	},
	[17] = {
		136,
		163,
		243,
		39,
		150,
		99,
		24,
		147,
		214,
		206,
		123,
		239,
		43,
		78,
		206,
		139,
		43,
		0
	},
	[18] = {
		153,
		96,
		98,
		5,
		179,
		252,
		148,
		152,
		187,
		79,
		170,
		118,
		97,
		184,
		94,
		158,
		234,
		215,
		0
	},
	[20] = {
		190,
		188,
		212,
		212,
		164,
		156,
		239,
		83,
		225,
		221,
		180,
		202,
		187,
		26,
		163,
		61,
		50,
		79,
		60,
		17,
		0
	},
	[22] = {
		231,
		165,
		105,
		160,
		134,
		219,
		80,
		98,
		172,
		8,
		74,
		200,
		53,
		221,
		109,
		14,
		230,
		93,
		242,
		247,
		171,
		210,
		0
	},
	[24] = {
		21,
		227,
		96,
		87,
		232,
		117,
		0,
		111,
		218,
		228,
		226,
		192,
		152,
		169,
		180,
		159,
		126,
		251,
		117,
		211,
		48,
		135,
		121,
		229,
		0
	},
	[26] = {
		70,
		218,
		145,
		153,
		227,
		48,
		102,
		13,
		142,
		245,
		21,
		161,
		53,
		165,
		28,
		111,
		201,
		145,
		17,
		118,
		182,
		103,
		2,
		158,
		125,
		173,
		0
	},
	[28] = {
		123,
		9,
		37,
		242,
		119,
		212,
		195,
		42,
		87,
		245,
		43,
		21,
		201,
		232,
		27,
		205,
		147,
		195,
		190,
		110,
		180,
		108,
		234,
		224,
		104,
		200,
		223,
		168,
		0
	},
	[30] = {
		180,
		192,
		40,
		238,
		216,
		251,
		37,
		156,
		130,
		224,
		193,
		226,
		173,
		42,
		125,
		222,
		96,
		239,
		86,
		110,
		48,
		50,
		182,
		179,
		31,
		216,
		152,
		145,
		173,
		41,
		0
	}
}

local function fn_12(arg_16_0)
	-- function 16
	local tbl = {}
	local gsub = string.gsub(arg_16_0, "(........)", function (arg_17_0)
		-- function 17
		tbl[#tbl + 1] = tonumber(arg_17_0, 2)
	end)

	return tbl
end

local function fn_13(arg_18_0, arg_18_1)
	-- function 18
	local tbl = {
		[0] = 0
	}

	for i = 0, arg_18_1 - arg_18_0 - 1 do
		tbl[i] = 0
	end

	local var_18_1 = tbl_5[arg_18_0]

	for j = 1, arg_18_0 + 1 do
		tbl[arg_18_1 - arg_18_0 + j - 1] = var_18_1[j]
	end

	return tbl
end

local function fn_14(self)
	-- function 19
	local tbl = {}

	for i = 0, #self do
		tbl[i] = tbl_4[self[i]]
	end

	return tbl
end

local function fn_15(self, arg_20_1)
	-- function 20
	local tbl = {}

	for i = 0, #self do
		tbl[i] = tbl_3[self[i]]
	end

	return tbl
end

local function fn_16(arg_21_0, arg_21_1)
	-- function 21
	local var_21_0

	if type(arg_21_0) == "string" then
		var_21_0 = fn_12(arg_21_0)
	elseif type(arg_21_0) == "table" then
		var_21_0 = arg_21_0
	else
		assert(false, "Unknown type for data: %s", type(arg_21_0))
	end

	local count = #var_21_0
	local num = count + arg_21_1 - 1
	local var_21_3
	local var_21_4
	local var_21_5
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}

	for i = 1, count do
		tbl_2[num - i + 1] = var_21_0[i]
	end

	for j = 1, num - count do
		tbl_2[j] = 0
	end

	tbl_2[0] = 0

	local var_21_9 = fn_14(tbl_2)

	while arg_21_1 <= num do
		local var_21_10 = fn_13(arg_21_1, num)
		local var_21_11 = var_21_9[num]

		for k = num, num - arg_21_1, -1 do
			if var_21_10[k] + var_21_11 > 255 then
				var_21_10[k] = math.fmod(var_21_10[k] + var_21_11, 255)
			else
				var_21_10[k] = var_21_10[k] + var_21_11
			end
		end

		for l = num - arg_21_1 - 1, 0, -1 do
			var_21_10[l] = 0
		end

		local var_21_12 = fn_15(var_21_10)

		tbl_2 = fn_15(var_21_9)

		local tbl_4 = {}

		for i4 = num, 0, -1 do
			tbl_4[i4] = bxor(var_21_12[i4], tbl_2[i4])
		end

		for i5 = num, 0, -1 do
			if i5 < arg_21_1 then
				break
			end

			if tbl_4[i5] == 0 then
				tbl_4[i5] = nil
				num = num - 1
			else
				break
			end
		end

		tbl_2 = tbl_4
		var_21_9 = fn_14(tbl_2)
	end

	local tbl_5 = {}

	for i6 = #tbl_2, 0, -1 do
		tbl_5[#tbl_5 + 1] = tbl_2[i6]
	end

	return tbl_5
end

local tbl_6 = {
	{
		{
			1,
			{
				26,
				19,
				2
			}
		},
		{
			1,
			{
				26,
				16,
				4
			}
		},
		{
			1,
			{
				26,
				13,
				6
			}
		},
		{
			1,
			{
				26,
				9,
				8
			}
		}
	},
	{
		{
			1,
			{
				44,
				34,
				4
			}
		},
		{
			1,
			{
				44,
				28,
				8
			}
		},
		{
			1,
			{
				44,
				22,
				11
			}
		},
		{
			1,
			{
				44,
				16,
				14
			}
		}
	},
	{
		{
			1,
			{
				70,
				55,
				7
			}
		},
		{
			1,
			{
				70,
				44,
				13
			}
		},
		{
			2,
			{
				35,
				17,
				9
			}
		},
		{
			2,
			{
				35,
				13,
				11
			}
		}
	},
	{
		{
			1,
			{
				100,
				80,
				10
			}
		},
		{
			2,
			{
				50,
				32,
				9
			}
		},
		{
			2,
			{
				50,
				24,
				13
			}
		},
		{
			4,
			{
				25,
				9,
				8
			}
		}
	},
	{
		{
			1,
			{
				134,
				108,
				13
			}
		},
		{
			2,
			{
				67,
				43,
				12
			}
		},
		{
			2,
			{
				33,
				15,
				9
			},
			2,
			{
				34,
				16,
				9
			}
		},
		{
			2,
			{
				33,
				11,
				11
			},
			2,
			{
				34,
				12,
				11
			}
		}
	},
	{
		{
			2,
			{
				86,
				68,
				9
			}
		},
		{
			4,
			{
				43,
				27,
				8
			}
		},
		{
			4,
			{
				43,
				19,
				12
			}
		},
		{
			4,
			{
				43,
				15,
				14
			}
		}
	},
	{
		{
			2,
			{
				98,
				78,
				10
			}
		},
		{
			4,
			{
				49,
				31,
				9
			}
		},
		{
			2,
			{
				32,
				14,
				9
			},
			4,
			{
				33,
				15,
				9
			}
		},
		{
			4,
			{
				39,
				13,
				13
			},
			1,
			{
				40,
				14,
				13
			}
		}
	},
	{
		{
			2,
			{
				121,
				97,
				12
			}
		},
		{
			2,
			{
				60,
				38,
				11
			},
			2,
			{
				61,
				39,
				11
			}
		},
		{
			4,
			{
				40,
				18,
				11
			},
			2,
			{
				41,
				19,
				11
			}
		},
		{
			4,
			{
				40,
				14,
				13
			},
			2,
			{
				41,
				15,
				13
			}
		}
	},
	{
		{
			2,
			{
				146,
				116,
				15
			}
		},
		{
			3,
			{
				58,
				36,
				11
			},
			2,
			{
				59,
				37,
				11
			}
		},
		{
			4,
			{
				36,
				16,
				10
			},
			4,
			{
				37,
				17,
				10
			}
		},
		{
			4,
			{
				36,
				12,
				12
			},
			4,
			{
				37,
				13,
				12
			}
		}
	},
	{
		{
			2,
			{
				86,
				68,
				9
			},
			2,
			{
				87,
				69,
				9
			}
		},
		{
			4,
			{
				69,
				43,
				13
			},
			1,
			{
				70,
				44,
				13
			}
		},
		{
			6,
			{
				43,
				19,
				12
			},
			2,
			{
				44,
				20,
				12
			}
		},
		{
			6,
			{
				43,
				15,
				14
			},
			2,
			{
				44,
				16,
				14
			}
		}
	},
	{
		{
			4,
			{
				101,
				81,
				10
			}
		},
		{
			1,
			{
				80,
				50,
				15
			},
			4,
			{
				81,
				51,
				15
			}
		},
		{
			4,
			{
				50,
				22,
				14
			},
			4,
			{
				51,
				23,
				14
			}
		},
		{
			3,
			{
				36,
				12,
				12
			},
			8,
			{
				37,
				13,
				12
			}
		}
	},
	{
		{
			2,
			{
				116,
				92,
				12
			},
			2,
			{
				117,
				93,
				12
			}
		},
		{
			6,
			{
				58,
				36,
				11
			},
			2,
			{
				59,
				37,
				11
			}
		},
		{
			4,
			{
				46,
				20,
				13
			},
			6,
			{
				47,
				21,
				13
			}
		},
		{
			7,
			{
				42,
				14,
				14
			},
			4,
			{
				43,
				15,
				14
			}
		}
	},
	{
		{
			4,
			{
				133,
				107,
				13
			}
		},
		{
			8,
			{
				59,
				37,
				11
			},
			1,
			{
				60,
				38,
				11
			}
		},
		{
			8,
			{
				44,
				20,
				12
			},
			4,
			{
				45,
				21,
				12
			}
		},
		{
			12,
			{
				33,
				11,
				11
			},
			4,
			{
				34,
				12,
				11
			}
		}
	},
	{
		{
			3,
			{
				145,
				115,
				15
			},
			1,
			{
				146,
				116,
				15
			}
		},
		{
			4,
			{
				64,
				40,
				12
			},
			5,
			{
				65,
				41,
				12
			}
		},
		{
			11,
			{
				36,
				16,
				10
			},
			5,
			{
				37,
				17,
				10
			}
		},
		{
			11,
			{
				36,
				12,
				12
			},
			5,
			{
				37,
				13,
				12
			}
		}
	},
	{
		{
			5,
			{
				109,
				87,
				11
			},
			1,
			{
				110,
				88,
				11
			}
		},
		{
			5,
			{
				65,
				41,
				12
			},
			5,
			{
				66,
				42,
				12
			}
		},
		{
			5,
			{
				54,
				24,
				15
			},
			7,
			{
				55,
				25,
				15
			}
		},
		{
			11,
			{
				36,
				12,
				12
			},
			7,
			{
				37,
				13,
				12
			}
		}
	},
	{
		{
			5,
			{
				122,
				98,
				12
			},
			1,
			{
				123,
				99,
				12
			}
		},
		{
			7,
			{
				73,
				45,
				14
			},
			3,
			{
				74,
				46,
				14
			}
		},
		{
			15,
			{
				43,
				19,
				12
			},
			2,
			{
				44,
				20,
				12
			}
		},
		{
			3,
			{
				45,
				15,
				15
			},
			13,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			1,
			{
				135,
				107,
				14
			},
			5,
			{
				136,
				108,
				14
			}
		},
		{
			10,
			{
				74,
				46,
				14
			},
			1,
			{
				75,
				47,
				14
			}
		},
		{
			1,
			{
				50,
				22,
				14
			},
			15,
			{
				51,
				23,
				14
			}
		},
		{
			2,
			{
				42,
				14,
				14
			},
			17,
			{
				43,
				15,
				14
			}
		}
	},
	{
		{
			5,
			{
				150,
				120,
				15
			},
			1,
			{
				151,
				121,
				15
			}
		},
		{
			9,
			{
				69,
				43,
				13
			},
			4,
			{
				70,
				44,
				13
			}
		},
		{
			17,
			{
				50,
				22,
				14
			},
			1,
			{
				51,
				23,
				14
			}
		},
		{
			2,
			{
				42,
				14,
				14
			},
			19,
			{
				43,
				15,
				14
			}
		}
	},
	{
		{
			3,
			{
				141,
				113,
				14
			},
			4,
			{
				142,
				114,
				14
			}
		},
		{
			3,
			{
				70,
				44,
				13
			},
			11,
			{
				71,
				45,
				13
			}
		},
		{
			17,
			{
				47,
				21,
				13
			},
			4,
			{
				48,
				22,
				13
			}
		},
		{
			9,
			{
				39,
				13,
				13
			},
			16,
			{
				40,
				14,
				13
			}
		}
	},
	{
		{
			3,
			{
				135,
				107,
				14
			},
			5,
			{
				136,
				108,
				14
			}
		},
		{
			3,
			{
				67,
				41,
				13
			},
			13,
			{
				68,
				42,
				13
			}
		},
		{
			15,
			{
				54,
				24,
				15
			},
			5,
			{
				55,
				25,
				15
			}
		},
		{
			15,
			{
				43,
				15,
				14
			},
			10,
			{
				44,
				16,
				14
			}
		}
	},
	{
		{
			4,
			{
				144,
				116,
				14
			},
			4,
			{
				145,
				117,
				14
			}
		},
		{
			17,
			{
				68,
				42,
				13
			}
		},
		{
			17,
			{
				50,
				22,
				14
			},
			6,
			{
				51,
				23,
				14
			}
		},
		{
			19,
			{
				46,
				16,
				15
			},
			6,
			{
				47,
				17,
				15
			}
		}
	},
	{
		{
			2,
			{
				139,
				111,
				14
			},
			7,
			{
				140,
				112,
				14
			}
		},
		{
			17,
			{
				74,
				46,
				14
			}
		},
		{
			7,
			{
				54,
				24,
				15
			},
			16,
			{
				55,
				25,
				15
			}
		},
		{
			34,
			{
				37,
				13,
				12
			}
		}
	},
	{
		{
			4,
			{
				151,
				121,
				15
			},
			5,
			{
				152,
				122,
				15
			}
		},
		{
			4,
			{
				75,
				47,
				14
			},
			14,
			{
				76,
				48,
				14
			}
		},
		{
			11,
			{
				54,
				24,
				15
			},
			14,
			{
				55,
				25,
				15
			}
		},
		{
			16,
			{
				45,
				15,
				15
			},
			14,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			6,
			{
				147,
				117,
				15
			},
			4,
			{
				148,
				118,
				15
			}
		},
		{
			6,
			{
				73,
				45,
				14
			},
			14,
			{
				74,
				46,
				14
			}
		},
		{
			11,
			{
				54,
				24,
				15
			},
			16,
			{
				55,
				25,
				15
			}
		},
		{
			30,
			{
				46,
				16,
				15
			},
			2,
			{
				47,
				17,
				15
			}
		}
	},
	{
		{
			8,
			{
				132,
				106,
				13
			},
			4,
			{
				133,
				107,
				13
			}
		},
		{
			8,
			{
				75,
				47,
				14
			},
			13,
			{
				76,
				48,
				14
			}
		},
		{
			7,
			{
				54,
				24,
				15
			},
			22,
			{
				55,
				25,
				15
			}
		},
		{
			22,
			{
				45,
				15,
				15
			},
			13,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			10,
			{
				142,
				114,
				14
			},
			2,
			{
				143,
				115,
				14
			}
		},
		{
			19,
			{
				74,
				46,
				14
			},
			4,
			{
				75,
				47,
				14
			}
		},
		{
			28,
			{
				50,
				22,
				14
			},
			6,
			{
				51,
				23,
				14
			}
		},
		{
			33,
			{
				46,
				16,
				15
			},
			4,
			{
				47,
				17,
				15
			}
		}
	},
	{
		{
			8,
			{
				152,
				122,
				15
			},
			4,
			{
				153,
				123,
				15
			}
		},
		{
			22,
			{
				73,
				45,
				14
			},
			3,
			{
				74,
				46,
				14
			}
		},
		{
			8,
			{
				53,
				23,
				15
			},
			26,
			{
				54,
				24,
				15
			}
		},
		{
			12,
			{
				45,
				15,
				15
			},
			28,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			3,
			{
				147,
				117,
				15
			},
			10,
			{
				148,
				118,
				15
			}
		},
		{
			3,
			{
				73,
				45,
				14
			},
			23,
			{
				74,
				46,
				14
			}
		},
		{
			4,
			{
				54,
				24,
				15
			},
			31,
			{
				55,
				25,
				15
			}
		},
		{
			11,
			{
				45,
				15,
				15
			},
			31,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			7,
			{
				146,
				116,
				15
			},
			7,
			{
				147,
				117,
				15
			}
		},
		{
			21,
			{
				73,
				45,
				14
			},
			7,
			{
				74,
				46,
				14
			}
		},
		{
			1,
			{
				53,
				23,
				15
			},
			37,
			{
				54,
				24,
				15
			}
		},
		{
			19,
			{
				45,
				15,
				15
			},
			26,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			5,
			{
				145,
				115,
				15
			},
			10,
			{
				146,
				116,
				15
			}
		},
		{
			19,
			{
				75,
				47,
				14
			},
			10,
			{
				76,
				48,
				14
			}
		},
		{
			15,
			{
				54,
				24,
				15
			},
			25,
			{
				55,
				25,
				15
			}
		},
		{
			23,
			{
				45,
				15,
				15
			},
			25,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			13,
			{
				145,
				115,
				15
			},
			3,
			{
				146,
				116,
				15
			}
		},
		{
			2,
			{
				74,
				46,
				14
			},
			29,
			{
				75,
				47,
				14
			}
		},
		{
			42,
			{
				54,
				24,
				15
			},
			1,
			{
				55,
				25,
				15
			}
		},
		{
			23,
			{
				45,
				15,
				15
			},
			28,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			17,
			{
				145,
				115,
				15
			}
		},
		{
			10,
			{
				74,
				46,
				14
			},
			23,
			{
				75,
				47,
				14
			}
		},
		{
			10,
			{
				54,
				24,
				15
			},
			35,
			{
				55,
				25,
				15
			}
		},
		{
			19,
			{
				45,
				15,
				15
			},
			35,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			17,
			{
				145,
				115,
				15
			},
			1,
			{
				146,
				116,
				15
			}
		},
		{
			14,
			{
				74,
				46,
				14
			},
			21,
			{
				75,
				47,
				14
			}
		},
		{
			29,
			{
				54,
				24,
				15
			},
			19,
			{
				55,
				25,
				15
			}
		},
		{
			11,
			{
				45,
				15,
				15
			},
			46,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			13,
			{
				145,
				115,
				15
			},
			6,
			{
				146,
				116,
				15
			}
		},
		{
			14,
			{
				74,
				46,
				14
			},
			23,
			{
				75,
				47,
				14
			}
		},
		{
			44,
			{
				54,
				24,
				15
			},
			7,
			{
				55,
				25,
				15
			}
		},
		{
			59,
			{
				46,
				16,
				15
			},
			1,
			{
				47,
				17,
				15
			}
		}
	},
	{
		{
			12,
			{
				151,
				121,
				15
			},
			7,
			{
				152,
				122,
				15
			}
		},
		{
			12,
			{
				75,
				47,
				14
			},
			26,
			{
				76,
				48,
				14
			}
		},
		{
			39,
			{
				54,
				24,
				15
			},
			14,
			{
				55,
				25,
				15
			}
		},
		{
			22,
			{
				45,
				15,
				15
			},
			41,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			6,
			{
				151,
				121,
				15
			},
			14,
			{
				152,
				122,
				15
			}
		},
		{
			6,
			{
				75,
				47,
				14
			},
			34,
			{
				76,
				48,
				14
			}
		},
		{
			46,
			{
				54,
				24,
				15
			},
			10,
			{
				55,
				25,
				15
			}
		},
		{
			2,
			{
				45,
				15,
				15
			},
			64,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			17,
			{
				152,
				122,
				15
			},
			4,
			{
				153,
				123,
				15
			}
		},
		{
			29,
			{
				74,
				46,
				14
			},
			14,
			{
				75,
				47,
				14
			}
		},
		{
			49,
			{
				54,
				24,
				15
			},
			10,
			{
				55,
				25,
				15
			}
		},
		{
			24,
			{
				45,
				15,
				15
			},
			46,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			4,
			{
				152,
				122,
				15
			},
			18,
			{
				153,
				123,
				15
			}
		},
		{
			13,
			{
				74,
				46,
				14
			},
			32,
			{
				75,
				47,
				14
			}
		},
		{
			48,
			{
				54,
				24,
				15
			},
			14,
			{
				55,
				25,
				15
			}
		},
		{
			42,
			{
				45,
				15,
				15
			},
			32,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			20,
			{
				147,
				117,
				15
			},
			4,
			{
				148,
				118,
				15
			}
		},
		{
			40,
			{
				75,
				47,
				14
			},
			7,
			{
				76,
				48,
				14
			}
		},
		{
			43,
			{
				54,
				24,
				15
			},
			22,
			{
				55,
				25,
				15
			}
		},
		{
			10,
			{
				45,
				15,
				15
			},
			67,
			{
				46,
				16,
				15
			}
		}
	},
	{
		{
			19,
			{
				148,
				118,
				15
			},
			6,
			{
				149,
				119,
				15
			}
		},
		{
			18,
			{
				75,
				47,
				14
			},
			31,
			{
				76,
				48,
				14
			}
		},
		{
			34,
			{
				54,
				24,
				15
			},
			34,
			{
				55,
				25,
				15
			}
		},
		{
			20,
			{
				45,
				15,
				15
			},
			61,
			{
				46,
				16,
				15
			}
		}
	}
}
local tbl_7 = {
	0,
	7,
	7,
	7,
	7,
	7,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	3,
	3,
	3,
	3,
	3,
	3,
	3,
	4,
	4,
	4,
	4,
	4,
	4,
	4,
	3,
	3,
	3,
	3,
	3,
	3,
	3,
	0,
	0,
	0,
	0,
	0,
	0
}

local function fn_17(arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	if type(arg_22_2) == "table" then
		local str = ""

		for i = 1, #arg_22_2 do
			str = str .. fn(arg_22_2[i], 8)
		end

		arg_22_2 = str
	end

	local var_22_1 = tbl_6[arg_22_0][arg_22_1]
	local var_22_2
	local var_22_3
	local tbl = {}
	local tbl_2 = {}
	local num = 1
	local num_2 = 0
	local num_3 = 0

	for j = 1, #var_22_1 / 2 do
		for k = 1, var_22_1[2 * j - 1] do
			local var_22_9 = var_22_1[2 * j][2]
			local num_4 = var_22_1[2 * j][1] - var_22_1[2 * j][2]

			num_3 = num_3 + num_4 * 8
			tbl[#tbl + 1] = string.sub(arg_22_2, num_2 * 8 + 1, (num_2 + var_22_9) * 8)

			local var_22_11 = fn_16(tbl[#tbl], num_4)
			local str_2 = ""

			for l = 1, #var_22_11 do
				str_2 = str_2 .. fn(var_22_11[l], 8)
			end

			tbl_2[#tbl_2 + 1] = str_2
			num_2 = num_2 + var_22_9
			num = num + 1
		end
	end

	local str_3 = ""
	local num_5 = 1

	repeat
		for i4 = 1, #tbl do
			if num_5 < #tbl[i4] then
				str_3 = str_3 .. string.sub(tbl[i4], num_5, num_5 + 7)
			end
		end

		num_5 = num_5 + 8
	until #str_3 == #arg_22_2

	local str_4 = ""
	local num_6 = 1

	repeat
		for i5 = 1, #tbl_2 do
			if num_6 < #tbl_2[i5] then
				str_4 = str_4 .. string.sub(tbl_2[i5], num_6, num_6 + 7)
			end
		end

		num_6 = num_6 + 8
	until #str_4 == num_3

	return str_3 .. str_4
end

local function fn_18(arg_23_0)
	-- function 23
	local count = #arg_23_0

	for i = 1, 8 do
		for j = 1, 8 do
			arg_23_0[i][j] = -2
			arg_23_0[count - 8 + i][j] = -2
			arg_23_0[i][count - 8 + j] = -2
		end
	end

	for k = 1, 7 do
		arg_23_0[1][k] = 2
		arg_23_0[7][k] = 2
		arg_23_0[k][1] = 2
		arg_23_0[k][7] = 2
		arg_23_0[count][k] = 2
		arg_23_0[count - 6][k] = 2
		arg_23_0[count - k + 1][1] = 2
		arg_23_0[count - k + 1][7] = 2
		arg_23_0[1][count - k + 1] = 2
		arg_23_0[7][count - k + 1] = 2
		arg_23_0[k][count - 6] = 2
		arg_23_0[k][count] = 2
	end

	for l = 1, 3 do
		for i4 = 1, 3 do
			arg_23_0[2 + i4][l + 2] = 2
			arg_23_0[count - i4 - 1][l + 2] = 2
			arg_23_0[2 + i4][count - l - 1] = 2
		end
	end
end

local function fn_19(arg_24_0)
	-- function 24
	local var_24_0
	local var_24_1
	local num = 7
	local num_2 = 9

	for i = num_2, #arg_24_0 - 8 do
		if math.fmod(i, 2) == 1 then
			arg_24_0[i][num] = 2
		else
			arg_24_0[i][num] = -2
		end
	end

	for j = num_2, #arg_24_0 - 8 do
		if math.fmod(j, 2) == 1 then
			arg_24_0[num][j] = 2
		else
			arg_24_0[num][j] = -2
		end
	end
end

local tbl_8 = {
	{},
	{
		6,
		18
	},
	{
		6,
		22
	},
	{
		6,
		26
	},
	{
		6,
		30
	},
	{
		6,
		34
	},
	{
		6,
		22,
		38
	},
	{
		6,
		24,
		42
	},
	{
		6,
		26,
		46
	},
	{
		6,
		28,
		50
	},
	{
		6,
		30,
		54
	},
	{
		6,
		32,
		58
	},
	{
		6,
		34,
		62
	},
	{
		6,
		26,
		46,
		66
	},
	{
		6,
		26,
		48,
		70
	},
	{
		6,
		26,
		50,
		74
	},
	{
		6,
		30,
		54,
		78
	},
	{
		6,
		30,
		56,
		82
	},
	{
		6,
		30,
		58,
		86
	},
	{
		6,
		34,
		62,
		90
	},
	{
		6,
		28,
		50,
		72,
		94
	},
	{
		6,
		26,
		50,
		74,
		98
	},
	{
		6,
		30,
		54,
		78,
		102
	},
	{
		6,
		28,
		54,
		80,
		106
	},
	{
		6,
		32,
		58,
		84,
		110
	},
	{
		6,
		30,
		58,
		86,
		114
	},
	{
		6,
		34,
		62,
		90,
		118
	},
	{
		6,
		26,
		50,
		74,
		98,
		122
	},
	{
		6,
		30,
		54,
		78,
		102,
		126
	},
	{
		6,
		26,
		52,
		78,
		104,
		130
	},
	{
		6,
		30,
		56,
		82,
		108,
		134
	},
	{
		6,
		34,
		60,
		86,
		112,
		138
	},
	{
		6,
		30,
		58,
		86,
		114,
		142
	},
	{
		6,
		34,
		62,
		90,
		118,
		146
	},
	{
		6,
		30,
		54,
		78,
		102,
		126,
		150
	},
	{
		6,
		24,
		50,
		76,
		102,
		128,
		154
	},
	{
		6,
		28,
		54,
		80,
		106,
		132,
		158
	},
	{
		6,
		32,
		58,
		84,
		110,
		136,
		162
	},
	{
		6,
		26,
		54,
		82,
		110,
		138,
		166
	},
	{
		6,
		30,
		58,
		86,
		114,
		142,
		170
	}
}

local function fn_20(arg_25_0)
	-- function 25
	local num = (#arg_25_0 - 17) / 4
	local var_25_1 = tbl_8[num]
	local var_25_2
	local var_25_3

	for i = 1, #var_25_1 do
		for j = 1, #var_25_1 do
			if not ((i ~= 1 or j ~= 1 or i ~= #var_25_1) and j ~= 1 and i ~= 1 or j == #var_25_1) then
				local num_2 = var_25_1[i] + 1
				local num_3 = var_25_1[j] + 1

				arg_25_0[num_2][num_3] = 2
				arg_25_0[num_2 + 1][num_3] = -2
				arg_25_0[num_2 - 1][num_3] = -2
				arg_25_0[num_2 + 2][num_3] = 2
				arg_25_0[num_2 - 2][num_3] = 2
				arg_25_0[num_2][num_3 - 2] = 2
				arg_25_0[num_2 + 1][num_3 - 2] = 2
				arg_25_0[num_2 - 1][num_3 - 2] = 2
				arg_25_0[num_2 + 2][num_3 - 2] = 2
				arg_25_0[num_2 - 2][num_3 - 2] = 2
				arg_25_0[num_2][num_3 + 2] = 2
				arg_25_0[num_2 + 1][num_3 + 2] = 2
				arg_25_0[num_2 - 1][num_3 + 2] = 2
				arg_25_0[num_2 + 2][num_3 + 2] = 2
				arg_25_0[num_2 - 2][num_3 + 2] = 2
				arg_25_0[num_2][num_3 - 1] = -2
				arg_25_0[num_2 + 1][num_3 - 1] = -2
				arg_25_0[num_2 - 1][num_3 - 1] = -2
				arg_25_0[num_2 + 2][num_3 - 1] = 2
				arg_25_0[num_2 - 2][num_3 - 1] = 2
				arg_25_0[num_2][num_3 + 1] = -2
				arg_25_0[num_2 + 1][num_3 + 1] = -2
				arg_25_0[num_2 - 1][num_3 + 1] = -2
				arg_25_0[num_2 + 2][num_3 + 1] = 2
				arg_25_0[num_2 - 2][num_3 + 1] = 2
			end
		end
	end
end

local tbl_9 = {
	{
		[0] = "111011111000100",
		"111001011110011",
		"111110110101010",
		"111100010011101",
		"110011000101111",
		"110001100011000",
		"110110001000001",
		"110100101110110",
		[-1] = "111111111111111"
	},
	{
		[0] = "101010000010010",
		"101000100100101",
		"101111001111100",
		"101101101001011",
		"100010111111001",
		"100000011001110",
		"100111110010111",
		"100101010100000",
		[-1] = "111111111111111"
	},
	{
		[0] = "011010101011111",
		"011000001101000",
		"011111100110001",
		"011101000000110",
		"010010010110100",
		"010000110000011",
		"010111011011010",
		"010101111101101",
		[-1] = "111111111111111"
	},
	{
		[0] = "001011010001001",
		"001001110111110",
		"001110011100111",
		"001100111010000",
		"000011101100010",
		"000001001010101",
		"000110100001100",
		"000100000111011",
		[-1] = "111111111111111"
	}
}

local function fn_21(arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local var_26_0 = tbl_9[arg_26_1][arg_26_2]
	local var_26_1

	for i = 1, 7 do
		local sub = string.sub(var_26_0, i, i)

		fn_2(arg_26_0, sub, 9, #arg_26_0 - i + 1)
	end

	for j = 8, 9 do
		local sub_2 = string.sub(var_26_0, j, j)

		fn_2(arg_26_0, sub_2, 9, 17 - j)
	end

	for k = 10, 15 do
		local sub_3 = string.sub(var_26_0, k, k)

		fn_2(arg_26_0, sub_3, 9, 16 - k)
	end

	for l = 1, 6 do
		local sub_4 = string.sub(var_26_0, l, l)

		fn_2(arg_26_0, sub_4, l, 9)
	end

	local sub_5 = string.sub(var_26_0, 7, 7)

	fn_2(arg_26_0, sub_5, 8, 9)

	for i4 = 8, 15 do
		local sub_6 = string.sub(var_26_0, i4, i4)

		fn_2(arg_26_0, sub_6, #arg_26_0 - 15 + i4, 9)
	end
end

local tbl_10 = {
	"001010010011111000",
	"001111011010000100",
	"100110010101100100",
	"110010110010010100",
	"011011111101110100",
	"010001101110001100",
	"111000100001101100",
	"101100000110011100",
	"000101001001111100",
	"000111101101000010",
	"101110100010100010",
	"111010000101010010",
	"010011001010110010",
	"011001011001001010",
	"110000010110101010",
	"100100110001011010",
	"001101111110111010",
	"001000110111000110",
	"100001111000100110",
	"110101011111010110",
	"011100010000110110",
	"010110000011001110",
	"111111001100101110",
	"101011101011011110",
	"000010100100111110",
	"101010111001000001",
	"000011110110100001",
	"010111010001010001",
	"111110011110110001",
	"110100001101001001",
	"011101000010101001",
	"001001100101011001",
	"100000101010111001",
	"100101100011000101"
}

local function fn_22(arg_27_0, arg_27_1)
	-- function 27
	if arg_27_1 < 7 then
		return
	end

	local count = #arg_27_0
	local var_27_1 = tbl_10[arg_27_1 - 6]
	local var_27_2
	local var_27_3
	local var_27_4
	local var_27_5
	local var_27_6
	local num = #arg_27_0 - 10
	local num_2 = 1

	for i = 1, #var_27_1 do
		local sub = string.sub(var_27_1, i, i)
		local num_3 = num + math.fmod(i - 1, 3)
		local num_4 = num_2 + math.floor((i - 1) / 3)

		fn_2(arg_27_0, sub, num_3, num_4)
	end

	local num_5 = 1
	local num_6 = #arg_27_0 - 10

	for j = 1, #var_27_1 do
		local sub_2 = string.sub(var_27_1, j, j)
		local num_7 = num_5 + math.floor((j - 1) / 3)
		local num_8 = num_6 + math.fmod(j - 1, 3)

		fn_2(arg_27_0, sub_2, num_7, num_8)
	end
end

local function fn_23(arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local var_28_0
	local tbl = {}
	local num = arg_28_0 * 4 + 17

	for i = 1, num do
		tbl[i] = {}

		for j = 1, num do
			tbl[i][j] = 0
		end
	end

	fn_18(tbl)
	fn_19(tbl)
	fn_22(tbl, arg_28_0)

	tbl[9][num - 7] = 2

	fn_20(tbl)
	fn_21(tbl, arg_28_1, arg_28_2)

	return tbl
end

local function fn_24(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	arg_29_1 = arg_29_1 - 1
	arg_29_2 = arg_29_2 - 1

	local flag = false

	if arg_29_0 == -1 then
		-- Nothing
	elseif arg_29_0 == 0 then
		if math.fmod(arg_29_1 + arg_29_2, 2) == 0 then
			flag = true
		end
	elseif arg_29_0 == 1 then
		if math.fmod(arg_29_2, 2) == 0 then
			flag = true
		end
	elseif arg_29_0 == 2 then
		if math.fmod(arg_29_1, 3) == 0 then
			flag = true
		end
	elseif arg_29_0 == 3 then
		if math.fmod(arg_29_1 + arg_29_2, 3) == 0 then
			flag = true
		end
	elseif arg_29_0 == 4 then
		if math.fmod(math.floor(arg_29_2 / 2) + math.floor(arg_29_1 / 3), 2) == 0 then
			flag = true
		end
	elseif arg_29_0 == 5 then
		if math.fmod(arg_29_1 * arg_29_2, 2) + math.fmod(arg_29_1 * arg_29_2, 3) == 0 then
			flag = true
		end
	elseif arg_29_0 == 6 then
		if math.fmod(math.fmod(arg_29_1 * arg_29_2, 2) + math.fmod(arg_29_1 * arg_29_2, 3), 2) == 0 then
			flag = true
		end
	elseif arg_29_0 == 7 then
		if math.fmod(math.fmod(arg_29_1 * arg_29_2, 3) + math.fmod(arg_29_1 + arg_29_2, 2), 2) == 0 then
			flag = true
		end
	else
		assert(false, "This can't happen (mask must be <= 7)")
	end

	if not flag then
		return 1 - 2 * tonumber(arg_29_3)
	else
		return -1 + 2 * tonumber(arg_29_3)
	end
end

local function fn_25(self, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	local tbl = {}
	local num = 1
	local str = "right"

	while num <= #arg_30_4 do
		if not (str ~= "right" or self[arg_30_1][arg_30_2] ~= 0) then
			tbl[#tbl + 1] = {
				arg_30_1,
				arg_30_2
			}
			str = "left"
			num = num + 1
		elseif not (str ~= "left" or self[arg_30_1 - 1][arg_30_2] ~= 0) then
			tbl[#tbl + 1] = {
				arg_30_1 - 1,
				arg_30_2
			}
			str = "right"
			num = num + 1

			if arg_30_3 == "up" then
				arg_30_2 = arg_30_2 - 1
			else
				arg_30_2 = arg_30_2 + 1
			end
		elseif not (str ~= "right" or self[arg_30_1 - 1][arg_30_2] ~= 0) then
			tbl[#tbl + 1] = {
				arg_30_1 - 1,
				arg_30_2
			}
			num = num + 1

			if arg_30_3 == "up" then
				arg_30_2 = arg_30_2 - 1
			else
				arg_30_2 = arg_30_2 + 1
			end
		elseif arg_30_3 == "up" then
			arg_30_2 = arg_30_2 - 1
		else
			arg_30_2 = arg_30_2 + 1
		end

		if not (arg_30_2 < 1 or not (arg_30_2 > #self)) then
			arg_30_1 = arg_30_1 - 2

			if arg_30_1 == 7 then
				arg_30_1 = 6
			end

			if arg_30_3 == "up" then
				arg_30_3 = "down"
				arg_30_2 = 1
			else
				arg_30_3 = "up"
				arg_30_2 = #self
			end
		end
	end

	return tbl, arg_30_1, arg_30_2, arg_30_3
end

local function fn_26(arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	local count = #arg_31_0
	local var_31_1
	local var_31_2
	local var_31_3
	local var_31_4
	local var_31_5
	local var_31_6
	local str = "up"
	local num = 0
	local var_31_9, var_31_10 = count, count

	string.gsub(arg_31_1, ".?.?.?.?.?.?.?.?", function (arg_32_0)
		-- function 32
		num = num + 1
		var_31_3, var_31_9, var_31_10, str = fn_25(arg_31_0, var_31_9, var_31_10, str, arg_32_0, arg_31_2)

		for i = 1, #arg_32_0 do
			var_31_4 = var_31_3[i][1]
			var_31_5 = var_31_3[i][2]
			var_31_6 = fn_24(arg_31_2, var_31_4, var_31_5, string.sub(arg_32_0, i, i))

			if not flag then
				arg_31_0[var_31_4][var_31_5] = var_31_6 * (i + 10)
			else
				arg_31_0[var_31_4][var_31_5] = var_31_6
			end
		end
	end)
end

local function fn_27(self)
	-- function 33
	local num = 0
	local num_2 = 0
	local num_3 = 0
	local num_4 = 0
	local count = #self
	local num_5 = 0
	local var_33_6
	local var_33_7
	local var_33_8

	for i = 1, count do
		local num_6 = 0
		local var_33_10

		for j = 1, count do
			if self[i][j] > 0 then
				num_5 = num_5 + 1

				local flag = false
			else
				local flag_2 = true
			end

			local flag_3 = self[i][j] < 0

			if var_33_10 == flag_3 then
				num_6 = num_6 + 1
			else
				if num_6 >= 5 then
					num = num + num_6 - 2
				end

				num_6 = 1
			end

			var_33_10 = flag_3
		end

		if num_6 >= 5 then
			num = num + num_6 - 2
		end
	end

	for k = 1, count do
		local num_7 = 0
		local var_33_15

		for l = 1, count do
			local flag_4 = self[l][k] < 0

			if var_33_15 == flag_4 then
				num_7 = num_7 + 1
			else
				if num_7 >= 5 then
					num = num + num_7 - 2
				end

				num_7 = 1
			end

			var_33_15 = flag_4
		end

		if num_7 >= 5 then
			num = num + num_7 - 2
		end
	end

	for i4 = 1, count do
		for i5 = 1, count do
			if not (not (i5 < count - 1) or not (i4 < count - 1) or (not (self[i4][i5] < 0) or not (self[i4 + 1][i5] < 0) or not (self[i4][i5 + 1] < 0) or not (self[i4 + 1][i5 + 1] < 0) or not (self[i4][i5] > 0)) and (not (self[i4 + 1][i5] > 0) or not (self[i4][i5 + 1] > 0) or not (self[i4 + 1][i5 + 1] > 0))) then
				num_2 = num_2 + 3
			end

			if not (not (count > i5 + 6) or not (self[i4][i5] > 0) or not (self[i4][i5 + 1] < 0) or not (self[i4][i5 + 2] > 0) or not (self[i4][i5 + 3] > 0) or not (self[i4][i5 + 4] > 0) or not (self[i4][i5 + 5] < 0) or not (self[i4][i5 + 6] > 0) or (not (count > i5 + 10) or not (self[i4][i5 + 7] < 0) or not (self[i4][i5 + 8] < 0) or not (self[i4][i5 + 9] < 0) or not (self[i4][i5 + 10] < 0) or not (i5 - 4 >= 1)) and (not (self[i4][i5 - 1] < 0) or not (self[i4][i5 - 2] < 0) or not (self[i4][i5 - 3] < 0) or not (self[i4][i5 - 4] < 0))) then
				num_3 = num_3 + 40
			end

			if not (not (count >= i4 + 6) or not (self[i4][i5] > 0) or not (self[i4 + 1][i5] < 0) or not (self[i4 + 2][i5] > 0) or not (self[i4 + 3][i5] > 0) or not (self[i4 + 4][i5] > 0) or not (self[i4 + 5][i5] < 0) or not (self[i4 + 6][i5] > 0) or (not (count >= i4 + 10) or not (self[i4 + 7][i5] < 0) or not (self[i4 + 8][i5] < 0) or not (self[i4 + 9][i5] < 0) or not (self[i4 + 10][i5] < 0) or not (i4 - 4 >= 1)) and (not (self[i4 - 1][i5] < 0) or not (self[i4 - 2][i5] < 0) or not (self[i4 - 3][i5] < 0) or not (self[i4 - 4][i5] < 0))) then
				num_3 = num_3 + 40
			end
		end
	end

	local num_8 = num_5 / (count * count)
	local num_9 = math.floor(math.abs(num_8 * 100 - 50)) * 2

	return num + num_2 + num_3 + num_9
end

local function fn_28(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	local var_34_0 = fn_23(arg_34_0, arg_34_1, arg_34_3)

	fn_26(var_34_0, arg_34_2, arg_34_3)

	local var_34_1 = fn_27(var_34_0)

	return var_34_0, var_34_1
end

local function fn_29(arg_35_0, arg_35_1, arg_35_2)
	-- function 35
	local var_35_0
	local var_35_1
	local var_35_2
	local var_35_3
	local var_35_4, var_35_5 = fn_28(arg_35_0, arg_35_1, arg_35_2, 0)

	for i = 1, 7 do
		local var_35_6, var_35_7 = fn_28(arg_35_0, arg_35_1, arg_35_2, i)

		if var_35_7 < var_35_5 then
			var_35_4 = var_35_6
			var_35_5 = var_35_7
		end
	end

	return var_35_4
end

local function fn_30(arg_36_0, arg_36_1, arg_36_2)
	-- function 36
	local var_36_0
	local var_36_1
	local var_36_2
	local var_36_3
	local var_36_4
	local var_36_5, var_36_6, var_36_7, var_36_8

	var_36_5, arg_36_1, var_36_6, var_36_7, var_36_8 = fn_6(arg_36_0, arg_36_1)

	local str = (var_36_6 .. var_36_8) .. fn_10(arg_36_0, var_36_7)
	local var_36_10 = fn_11(var_36_5, arg_36_1, str)
	local var_36_11 = fn_17(var_36_5, arg_36_1, var_36_10)

	if math.fmod(#var_36_11, 8) ~= 0 then
		return false, string.format("Arranged data %% 8 != 0: data length = %d, mod 8 = %d", #var_36_11, math.fmod(#var_36_11, 8))
	end

	local str_2 = var_36_11 .. string.rep("0", tbl_7[var_36_5])
	local var_36_13 = fn_29(var_36_5, arg_36_1, str_2)

	return true, var_36_13
end

if not flag_2 then
	return {
		encode_string_numeric = fn_7,
		encode_string_ascii = fn_8,
		qrcode = fn_30,
		binary = fn,
		get_mode = fn_3,
		get_length = fn_5,
		add_pad_data = fn_11,
		get_generator_polynominal_adjusted = fn_13,
		get_pixel_with_mask = fn_24,
		get_version_eclevel_mode_bistringlength = fn_6,
		remainder = tbl_7,
		arrange_codewords_and_calculate_ec = fn_17,
		calculate_error_correction = fn_16,
		convert_bitstring_to_bytes = fn_12,
		bit_xor = bxor
	}
end

return {
	qrcode = fn_30
}
