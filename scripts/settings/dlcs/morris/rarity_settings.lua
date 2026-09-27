-- chunkname: @scripts/settings/dlcs/morris/rarity_settings.lua

local get_table = Colors.get_table("plentiful")
local num = 255 / get_table[2]
local num_2 = 255 / get_table[3]
local num_3 = 255 / get_table[4]
local flag = not (num < num_2) or not num or num_2

flag = not (flag < num_3) or not flag or num_3

local get_table_2 = Colors.get_table("common")
local num_4 = 255 / get_table_2[2]
local num_5 = 255 / get_table_2[3]
local num_6 = 255 / get_table_2[4]
local flag_2 = not (num_4 < num_5) or not num_4 or num_5

flag_2 = not (flag_2 < num_6) or not flag_2 or num_6

local get_table_3 = Colors.get_table("rare")
local num_7 = 255 / get_table_3[2]
local num_8 = 255 / get_table_3[3]
local num_9 = 255 / get_table_3[4]
local flag_3 = not (num_7 < num_8) or not num_7 or num_8

flag_3 = not (flag_3 < num_9) or not flag_3 or num_9

local get_table_4 = Colors.get_table("exotic")
local num_10 = 255 / get_table_4[2]
local num_11 = 255 / get_table_4[3]
local num_12 = 255 / get_table_4[4]
local flag_4 = not (num_10 < num_11) or not num_10 or num_11

flag_4 = not (flag_4 < num_12) or not flag_4 or num_12

local get_table_5 = Colors.get_table("unique")
local num_13 = 255 / get_table_5[2]
local num_14 = 255 / get_table_5[3]
local num_15 = 255 / get_table_5[4]
local flag_5 = not (num_13 < num_14) or not num_13 or num_14

flag_5 = not (flag_5 < num_15) or not flag_5 or num_15

local get_table_6 = Colors.get_table("event")
local num_16 = 255 / get_table_6[2]
local num_17 = 255 / get_table_6[3]
local num_18 = 255 / get_table_6[4]
local flag_6 = not (num_16 < num_17) or not num_16 or num_17

flag_6 = not (flag_6 < num_18) or not flag_6 or num_18
ORDER_RARITY = table.mirror_array({
	"plentiful",
	"common",
	"rare",
	"exotic",
	"unique",
	"magic",
	"promo"
})

local RaritySettings = RaritySettings

RaritySettings = RaritySettings or {
	plentiful = {
		name = "plentiful",
		display_name = "rarity_display_name_plentiful",
		order = 1,
		color = get_table,
		frame_color = {
			get_table[1],
			get_table[2] * flag,
			get_table[3] * flag,
			get_table[4] * flag
		}
	},
	common = {
		name = "common",
		display_name = "rarity_display_name_common",
		order = 2,
		color = get_table_2,
		frame_color = {
			get_table_2[1],
			get_table_2[2] * flag_2,
			get_table_2[3] * flag_2,
			get_table_2[4] * flag_2
		}
	},
	rare = {
		name = "rare",
		display_name = "rarity_display_name_rare",
		order = 3,
		color = get_table_3,
		frame_color = {
			get_table_3[1],
			get_table_3[2] * flag_3,
			get_table_3[3] * flag_3,
			get_table_3[4] * flag_3
		}
	},
	exotic = {
		name = "exotic",
		display_name = "rarity_display_name_exotic",
		order = 4,
		color = get_table_4,
		frame_color = {
			get_table_4[1],
			get_table_4[2] * flag_4,
			get_table_4[3] * flag_4,
			get_table_4[4] * flag_4
		}
	},
	unique = {
		name = "unique",
		display_name = "rarity_display_name_unique",
		order = 5,
		color = get_table_5,
		frame_color = {
			get_table_5[1],
			get_table_5[2] * flag_5,
			get_table_5[3] * flag_5,
			get_table_5[4] * flag_5
		}
	},
	event = {
		name = "event",
		display_name = "rarity_display_name_event",
		order = 6,
		color = get_table_6,
		frame_color = {
			get_table_6[1],
			get_table_6[2] * flag_6,
			get_table_6[3] * flag_6,
			get_table_6[4] * flag_6
		}
	}
}
RaritySettings = RaritySettings
RarityIndex = {}

for k, v in pairs(RaritySettings) do
	RarityIndex[k] = v.order
end
