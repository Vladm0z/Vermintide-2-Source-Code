-- chunkname: @scripts/settings/dlcs/morris/deus_cost_settings.lua

local tbl = {
	common = 60,
	plentiful = 0,
	exotic = 200,
	rare = 120,
	unique = 300
}
local tbl_2 = {
	common = 100,
	plentiful = 0,
	exotic = 350,
	rare = 200,
	unique = 500
}
local num = 0.5
local num_2 = 0.5

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local num_2 = tbl[arg_1_1] - tbl[arg_1_0] * num
	local num_3 = math.ceil(num_2 / 10) * 10

	return math.max(num_3, 0)
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local num = tbl_2[arg_2_1] - tbl_2[arg_2_0] * num_2
	local num_3 = math.ceil(num / 10) * 10

	return math.max(num_3, 0)
end

local DeusCostSettings = DeusCostSettings

DeusCostSettings = DeusCostSettings or {
	shop = {
		consumables = {
			heal = 200,
			ammo = 100,
			potion = 250
		},
		blessings = {
			blessing_of_isha = 200,
			blessing_of_shallya = 200,
			blessing_of_grimnir = 200,
			blessing_of_power = 100,
			blessing_of_abundance = 200,
			blessing_holy_hand_grenade = 200,
			blessing_rally_flag = 200,
			blessing_of_ranald = 200
		},
		power_ups = {
			event = 100,
			uncommon = 100,
			exotic = 250,
			rare = 200,
			unique = 300
		}
	},
	deus_chest = {
		power_up = 150,
		swap_ranged = {
			plentiful = {
				plentiful = fn("plentiful", "plentiful"),
				common = fn("plentiful", "common"),
				rare = fn("plentiful", "rare"),
				exotic = fn("plentiful", "exotic"),
				unique = fn("plentiful", "unique")
			},
			common = {
				plentiful = fn("common", "plentiful"),
				common = fn("common", "common"),
				rare = fn("common", "rare"),
				exotic = fn("common", "exotic"),
				unique = fn("common", "unique")
			},
			rare = {
				plentiful = fn("rare", "plentiful"),
				common = fn("rare", "common"),
				rare = fn("rare", "rare"),
				exotic = fn("rare", "exotic"),
				unique = fn("rare", "unique")
			},
			exotic = {
				plentiful = fn("exotic", "plentiful"),
				common = fn("exotic", "common"),
				rare = fn("exotic", "rare"),
				exotic = fn("exotic", "exotic"),
				unique = fn("exotic", "unique")
			},
			unique = {
				plentiful = fn("unique", "plentiful"),
				common = fn("unique", "common"),
				rare = fn("unique", "rare"),
				exotic = fn("unique", "exotic"),
				unique = fn("unique", "unique")
			}
		},
		swap_melee = {
			plentiful = {
				plentiful = fn("plentiful", "plentiful"),
				common = fn("plentiful", "common"),
				rare = fn("plentiful", "rare"),
				exotic = fn("plentiful", "exotic"),
				unique = fn("plentiful", "unique")
			},
			common = {
				plentiful = fn("common", "plentiful"),
				common = fn("common", "common"),
				rare = fn("common", "rare"),
				exotic = fn("common", "exotic"),
				unique = fn("common", "unique")
			},
			rare = {
				plentiful = fn("rare", "plentiful"),
				common = fn("rare", "common"),
				rare = fn("rare", "rare"),
				exotic = fn("rare", "exotic"),
				unique = fn("rare", "unique")
			},
			exotic = {
				plentiful = fn("exotic", "plentiful"),
				common = fn("exotic", "common"),
				rare = fn("exotic", "rare"),
				exotic = fn("exotic", "exotic"),
				unique = fn("exotic", "unique")
			},
			unique = {
				plentiful = fn("unique", "plentiful"),
				common = fn("unique", "common"),
				rare = fn("unique", "rare"),
				exotic = fn("unique", "exotic"),
				unique = fn("unique", "unique")
			}
		},
		upgrade = {
			plentiful = {
				plentiful = fn_2("plentiful", "plentiful"),
				common = fn_2("plentiful", "common"),
				rare = fn_2("plentiful", "rare"),
				exotic = fn_2("plentiful", "exotic"),
				unique = fn_2("plentiful", "unique")
			},
			common = {
				plentiful = fn_2("common", "plentiful"),
				common = fn_2("common", "common"),
				rare = fn_2("common", "rare"),
				exotic = fn_2("common", "exotic"),
				unique = fn_2("common", "unique")
			},
			rare = {
				plentiful = fn_2("rare", "plentiful"),
				common = fn_2("rare", "common"),
				rare = fn_2("rare", "rare"),
				exotic = fn_2("rare", "exotic"),
				unique = fn_2("rare", "unique")
			},
			exotic = {
				plentiful = fn_2("exotic", "plentiful"),
				common = fn_2("exotic", "common"),
				rare = fn_2("exotic", "rare"),
				exotic = fn_2("exotic", "exotic"),
				unique = fn_2("exotic", "unique")
			},
			unique = {
				plentiful = fn_2("unique", "plentiful"),
				common = fn_2("unique", "common"),
				rare = fn_2("unique", "rare"),
				exotic = fn_2("unique", "exotic"),
				unique = fn_2("unique", "unique")
			}
		}
	}
}
DeusCostSettings = DeusCostSettings
