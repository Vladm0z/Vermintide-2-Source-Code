-- chunkname: @scripts/settings/dlcs/morris/deus_cost_settings.lua

local var_0_0 = {
	common = 60,
	plentiful = 0,
	exotic = 200,
	rare = 120,
	unique = 300
}
local var_0_1 = {
	common = 100,
	plentiful = 0,
	exotic = 350,
	rare = 200,
	unique = 500
}
local var_0_2 = 0.5
local var_0_3 = 0.5

local function var_0_4(arg_1_0, arg_1_1)
	local var_1_0 = var_0_0[arg_1_1] - var_0_0[arg_1_0] * var_0_2
	local var_1_1 = math.ceil(var_1_0 / 10) * 10

	return math.max(var_1_1, 0)
end

local function var_0_5(arg_2_0, arg_2_1)
	local var_2_0 = var_0_1[arg_2_1] - var_0_1[arg_2_0] * var_0_3
	local var_2_1 = math.ceil(var_2_0 / 10) * 10

	return math.max(var_2_1, 0)
end

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
				plentiful = var_0_4("plentiful", "plentiful"),
				common = var_0_4("plentiful", "common"),
				rare = var_0_4("plentiful", "rare"),
				exotic = var_0_4("plentiful", "exotic"),
				unique = var_0_4("plentiful", "unique")
			},
			common = {
				plentiful = var_0_4("common", "plentiful"),
				common = var_0_4("common", "common"),
				rare = var_0_4("common", "rare"),
				exotic = var_0_4("common", "exotic"),
				unique = var_0_4("common", "unique")
			},
			rare = {
				plentiful = var_0_4("rare", "plentiful"),
				common = var_0_4("rare", "common"),
				rare = var_0_4("rare", "rare"),
				exotic = var_0_4("rare", "exotic"),
				unique = var_0_4("rare", "unique")
			},
			exotic = {
				plentiful = var_0_4("exotic", "plentiful"),
				common = var_0_4("exotic", "common"),
				rare = var_0_4("exotic", "rare"),
				exotic = var_0_4("exotic", "exotic"),
				unique = var_0_4("exotic", "unique")
			},
			unique = {
				plentiful = var_0_4("unique", "plentiful"),
				common = var_0_4("unique", "common"),
				rare = var_0_4("unique", "rare"),
				exotic = var_0_4("unique", "exotic"),
				unique = var_0_4("unique", "unique")
			}
		},
		swap_melee = {
			plentiful = {
				plentiful = var_0_4("plentiful", "plentiful"),
				common = var_0_4("plentiful", "common"),
				rare = var_0_4("plentiful", "rare"),
				exotic = var_0_4("plentiful", "exotic"),
				unique = var_0_4("plentiful", "unique")
			},
			common = {
				plentiful = var_0_4("common", "plentiful"),
				common = var_0_4("common", "common"),
				rare = var_0_4("common", "rare"),
				exotic = var_0_4("common", "exotic"),
				unique = var_0_4("common", "unique")
			},
			rare = {
				plentiful = var_0_4("rare", "plentiful"),
				common = var_0_4("rare", "common"),
				rare = var_0_4("rare", "rare"),
				exotic = var_0_4("rare", "exotic"),
				unique = var_0_4("rare", "unique")
			},
			exotic = {
				plentiful = var_0_4("exotic", "plentiful"),
				common = var_0_4("exotic", "common"),
				rare = var_0_4("exotic", "rare"),
				exotic = var_0_4("exotic", "exotic"),
				unique = var_0_4("exotic", "unique")
			},
			unique = {
				plentiful = var_0_4("unique", "plentiful"),
				common = var_0_4("unique", "common"),
				rare = var_0_4("unique", "rare"),
				exotic = var_0_4("unique", "exotic"),
				unique = var_0_4("unique", "unique")
			}
		},
		upgrade = {
			plentiful = {
				plentiful = var_0_5("plentiful", "plentiful"),
				common = var_0_5("plentiful", "common"),
				rare = var_0_5("plentiful", "rare"),
				exotic = var_0_5("plentiful", "exotic"),
				unique = var_0_5("plentiful", "unique")
			},
			common = {
				plentiful = var_0_5("common", "plentiful"),
				common = var_0_5("common", "common"),
				rare = var_0_5("common", "rare"),
				exotic = var_0_5("common", "exotic"),
				unique = var_0_5("common", "unique")
			},
			rare = {
				plentiful = var_0_5("rare", "plentiful"),
				common = var_0_5("rare", "common"),
				rare = var_0_5("rare", "rare"),
				exotic = var_0_5("rare", "exotic"),
				unique = var_0_5("rare", "unique")
			},
			exotic = {
				plentiful = var_0_5("exotic", "plentiful"),
				common = var_0_5("exotic", "common"),
				rare = var_0_5("exotic", "rare"),
				exotic = var_0_5("exotic", "exotic"),
				unique = var_0_5("exotic", "unique")
			},
			unique = {
				plentiful = var_0_5("unique", "plentiful"),
				common = var_0_5("unique", "common"),
				rare = var_0_5("unique", "rare"),
				exotic = var_0_5("unique", "exotic"),
				unique = var_0_5("unique", "unique")
			}
		}
	}
}
