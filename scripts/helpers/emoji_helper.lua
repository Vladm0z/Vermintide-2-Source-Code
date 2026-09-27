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

for i, v in ipairs(EMOJI_SETTINGS) do
	local keys = v.keys

	for i_2, v_2 in ipairs(ESCAPE_CHARACTERS) do
		keys = string.gsub(keys, "%" .. v_2, "%%" .. v_2)
	end

	v.pattern = keys

	local replacement_keys = v.replacement_keys

	if not replacement_keys then
		for i_3, v_3 in ipairs(ESCAPE_CHARACTERS) do
			replacement_keys = string.gsub(replacement_keys, "%" .. v_3, "%%" .. v_3)
		end

		v.replacement_pattern = replacement_keys
	end
end

EMOJI_SETTINGS_LUT = {}

for i_4, v_4 in ipairs(EMOJI_SETTINGS) do
	EMOJI_SETTINGS_LUT[v_4.keys] = i_4
end

EMOJI_REPLACEMENTS = {}

for i_5, v_5 in ipairs(EMOJI_SETTINGS) do
	if not v_5.replacement_keys then
		EMOJI_REPLACEMENTS[#EMOJI_REPLACEMENTS + 1] = {
			data = v_5,
			size = string.len(v_5.replacement_keys)
		}
	end
end

local function fn(self, arg_1_1)
	-- function 1
	return self.size > arg_1_1.size
end

table.sort(EMOJI_REPLACEMENTS, fn)

EmojiHelper = {}

local tbl = {}

EmojiHelper.parse_emojis = function (arg_2_0)
	-- function 2
	local var_2_0 = arg_2_0

	table.clear(tbl)

	local find = string.find(var_2_0, ":")

	while not find do
		local find_2 = string.find(var_2_0, ":", find + 1)
		local sub = string.sub(var_2_0, find, find_2)
		local var_2_4 = EMOJI_SETTINGS_LUT[sub]

		if not var_2_4 then
			tbl[#tbl + 1] = EMOJI_SETTINGS[var_2_4]
			find_2 = find_2 + 1
		end

		if not find_2 then
			return tbl
		end

		var_2_0 = string.sub(var_2_0, find_2)
		find = string.find(var_2_0, ":")
	end

	return tbl
end

EmojiHelper.replace_emojis = function (arg_3_0)
	-- function 3
	for i, v in ipairs(EMOJI_REPLACEMENTS) do
		local data = v.data

		if not data.replacement_pattern then
			arg_3_0 = string.gsub(arg_3_0, data.replacement_pattern, data.keys)
		end
	end

	return arg_3_0
end
