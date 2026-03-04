-- chunkname: @scripts/settings/dlcs/morris/rarity_settings.lua

local var_0_0 = Colors.get_table("plentiful")
local var_0_1 = 255 / var_0_0[2]
local var_0_2 = 255 / var_0_0[3]
local var_0_3 = 255 / var_0_0[4]
local var_0_4 = var_0_1 < var_0_2 and var_0_1 or var_0_2

var_0_4 = var_0_4 < var_0_3 and var_0_4 or var_0_3

local var_0_5 = Colors.get_table("common")
local var_0_6 = 255 / var_0_5[2]
local var_0_7 = 255 / var_0_5[3]
local var_0_8 = 255 / var_0_5[4]
local var_0_9 = var_0_6 < var_0_7 and var_0_6 or var_0_7

var_0_9 = var_0_9 < var_0_8 and var_0_9 or var_0_8

local var_0_10 = Colors.get_table("rare")
local var_0_11 = 255 / var_0_10[2]
local var_0_12 = 255 / var_0_10[3]
local var_0_13 = 255 / var_0_10[4]
local var_0_14 = var_0_11 < var_0_12 and var_0_11 or var_0_12

var_0_14 = var_0_14 < var_0_13 and var_0_14 or var_0_13

local var_0_15 = Colors.get_table("exotic")
local var_0_16 = 255 / var_0_15[2]
local var_0_17 = 255 / var_0_15[3]
local var_0_18 = 255 / var_0_15[4]
local var_0_19 = var_0_16 < var_0_17 and var_0_16 or var_0_17

var_0_19 = var_0_19 < var_0_18 and var_0_19 or var_0_18

local var_0_20 = Colors.get_table("unique")
local var_0_21 = 255 / var_0_20[2]
local var_0_22 = 255 / var_0_20[3]
local var_0_23 = 255 / var_0_20[4]
local var_0_24 = var_0_21 < var_0_22 and var_0_21 or var_0_22

var_0_24 = var_0_24 < var_0_23 and var_0_24 or var_0_23

local var_0_25 = Colors.get_table("event")
local var_0_26 = 255 / var_0_25[2]
local var_0_27 = 255 / var_0_25[3]
local var_0_28 = 255 / var_0_25[4]
local var_0_29 = var_0_26 < var_0_27 and var_0_26 or var_0_27

var_0_29 = var_0_29 < var_0_28 and var_0_29 or var_0_28
ORDER_RARITY = table.mirror_array({
	"plentiful",
	"common",
	"rare",
	"exotic",
	"unique",
	"magic",
	"promo"
})
RaritySettings = RaritySettings or {
	plentiful = {
		name = "plentiful",
		display_name = "rarity_display_name_plentiful",
		order = 1,
		color = var_0_0,
		frame_color = {
			var_0_0[1],
			var_0_0[2] * var_0_4,
			var_0_0[3] * var_0_4,
			var_0_0[4] * var_0_4
		}
	},
	common = {
		name = "common",
		display_name = "rarity_display_name_common",
		order = 2,
		color = var_0_5,
		frame_color = {
			var_0_5[1],
			var_0_5[2] * var_0_9,
			var_0_5[3] * var_0_9,
			var_0_5[4] * var_0_9
		}
	},
	rare = {
		name = "rare",
		display_name = "rarity_display_name_rare",
		order = 3,
		color = var_0_10,
		frame_color = {
			var_0_10[1],
			var_0_10[2] * var_0_14,
			var_0_10[3] * var_0_14,
			var_0_10[4] * var_0_14
		}
	},
	exotic = {
		name = "exotic",
		display_name = "rarity_display_name_exotic",
		order = 4,
		color = var_0_15,
		frame_color = {
			var_0_15[1],
			var_0_15[2] * var_0_19,
			var_0_15[3] * var_0_19,
			var_0_15[4] * var_0_19
		}
	},
	unique = {
		name = "unique",
		display_name = "rarity_display_name_unique",
		order = 5,
		color = var_0_20,
		frame_color = {
			var_0_20[1],
			var_0_20[2] * var_0_24,
			var_0_20[3] * var_0_24,
			var_0_20[4] * var_0_24
		}
	},
	event = {
		name = "event",
		display_name = "rarity_display_name_event",
		order = 6,
		color = var_0_25,
		frame_color = {
			var_0_25[1],
			var_0_25[2] * var_0_29,
			var_0_25[3] * var_0_29,
			var_0_25[4] * var_0_29
		}
	}
}
RarityIndex = {}

for iter_0_0, iter_0_1 in pairs(RaritySettings) do
	RarityIndex[iter_0_0] = iter_0_1.order
end
