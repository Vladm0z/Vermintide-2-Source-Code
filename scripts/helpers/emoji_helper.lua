-- chunkname: @scripts/helpers/emoji_helper.lua

ESCAPE_CHARACTERS = {
	"%",
	"(",
	")",
	".",
	"+",
	"-",
	"*",
	"?",
	"[",
	"^",
	"$"
}
EMOJI_SETTINGS = {
	{
		replacement_keys = ":)",
		keys = ":smiley:",
		texture = "emo_01",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ":O",
		keys = ":open_mouth:",
		texture = "emo_02",
		color = {
			255,
			255,
			0,
			0
		}
	},
	{
		keys = ":shocked:",
		texture = "emo_03",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ":/",
		keys = ":confused:",
		texture = "emo_04",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ":p",
		keys = ":stuck_out_tongue:",
		texture = "emo_05",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ":|",
		keys = ":neutral_face:",
		texture = "emo_06",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ":(",
		keys = ":disappointed:",
		texture = "emo_07",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ":'(",
		keys = ":cry:",
		texture = "emo_08",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		keys = ":smile:",
		texture = "emo_09",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ";)",
		keys = ":smirk:",
		texture = "emo_10",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ":D",
		keys = ":grinning:",
		texture = "emo_11",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ">_<",
		keys = ":tired_face:",
		texture = "emo_12",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = ">:(",
		keys = ":angry:",
		texture = "emo_13",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = "<3",
		keys = ":heart:",
		texture = "emo_14",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		replacement_keys = "</3",
		keys = ":broken_heart:",
		texture = "emo_15",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		keys = ":sun:",
		texture = "emo_16",
		color = {
			255,
			0,
			255,
			0
		}
	},
	{
		keys = ":cross:",
		texture = "emo_17",
		color = {
			255,
			0,
			255,
			0
		}
	}
}

for iter_0_0, iter_0_1 in ipairs(EMOJI_SETTINGS) do
	local var_0_0 = iter_0_1.keys

	for iter_0_2, iter_0_3 in ipairs(ESCAPE_CHARACTERS) do
		var_0_0 = string.gsub(var_0_0, "%" .. iter_0_3, "%%" .. iter_0_3)
	end

	iter_0_1.pattern = var_0_0

	local var_0_1 = iter_0_1.replacement_keys

	if var_0_1 then
		for iter_0_4, iter_0_5 in ipairs(ESCAPE_CHARACTERS) do
			var_0_1 = string.gsub(var_0_1, "%" .. iter_0_5, "%%" .. iter_0_5)
		end

		iter_0_1.replacement_pattern = var_0_1
	end
end

EMOJI_SETTINGS_LUT = {}

for iter_0_6, iter_0_7 in ipairs(EMOJI_SETTINGS) do
	EMOJI_SETTINGS_LUT[iter_0_7.keys] = iter_0_6
end

EMOJI_REPLACEMENTS = {}

for iter_0_8, iter_0_9 in ipairs(EMOJI_SETTINGS) do
	if iter_0_9.replacement_keys then
		EMOJI_REPLACEMENTS[#EMOJI_REPLACEMENTS + 1] = {
			data = iter_0_9,
			size = string.len(iter_0_9.replacement_keys)
		}
	end
end

local function var_0_2(arg_1_0, arg_1_1)
	return arg_1_0.size > arg_1_1.size
end

table.sort(EMOJI_REPLACEMENTS, var_0_2)

EmojiHelper = {}

local var_0_3 = {}

function EmojiHelper.parse_emojis(arg_2_0)
	local var_2_0 = arg_2_0

	table.clear(var_0_3)

	local var_2_1 = string.find(var_2_0, ":")

	while var_2_1 do
		local var_2_2 = string.find(var_2_0, ":", var_2_1 + 1)
		local var_2_3 = string.sub(var_2_0, var_2_1, var_2_2)
		local var_2_4 = EMOJI_SETTINGS_LUT[var_2_3]

		if var_2_4 then
			var_0_3[#var_0_3 + 1] = EMOJI_SETTINGS[var_2_4]
			var_2_2 = var_2_2 + 1
		end

		if not var_2_2 then
			return var_0_3
		end

		var_2_0 = string.sub(var_2_0, var_2_2)
		var_2_1 = string.find(var_2_0, ":")
	end

	return var_0_3
end

function EmojiHelper.replace_emojis(arg_3_0)
	for iter_3_0, iter_3_1 in ipairs(EMOJI_REPLACEMENTS) do
		local var_3_0 = iter_3_1.data

		if var_3_0.replacement_pattern then
			arg_3_0 = string.gsub(arg_3_0, var_3_0.replacement_pattern, var_3_0.keys)
		end
	end

	return arg_3_0
end
