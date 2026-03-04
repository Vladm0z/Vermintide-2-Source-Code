-- chunkname: @scripts/settings/versus_custom_settings_templates.lua

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = {
		arg_1_0
	}
	local var_1_1 = (arg_1_1 - arg_1_0) / arg_1_2

	for iter_1_0 = 1, var_1_1 do
		var_1_0[iter_1_0 + 1] = arg_1_0 + arg_1_2 * iter_1_0
	end

	if arg_1_3 then
		for iter_1_1, iter_1_2 in pairs(arg_1_3) do
			var_1_0[#var_1_0 + 1] = iter_1_2
		end

		table.clear(arg_1_3)
	end

	return var_1_0
end

local var_0_1 = {
	{
		default = true,
		setting_name = "early_win_enabled",
		values = {
			true,
			false
		}
	},
	{
		default = true,
		setting_name = "hero_bots_enabled",
		values = {
			true,
			false
		}
	},
	{
		default = "random",
		setting_name = "starting_as_heroes",
		values = {
			1,
			2,
			"random"
		}
	},
	{
		default = 3,
		setting_name = "wounds_amount",
		values = {
			0,
			1,
			2,
			3,
			4,
			5
		}
	},
	{
		default = 250,
		setting_name = "knockdown_hp",
		values = var_0_0(0, 500, 50)
	},
	{
		default = false,
		setting_name = "round_time_limit",
		values = var_0_0(3, 20, 1, {
			false
		})
	},
	{
		default = 100,
		setting_name = "horde_ability_recharge_rate_percent",
		values = var_0_0(0, 500, 25)
	},
	{
		default = false,
		setting_name = "friendly_fire",
		values = {
			false,
			"harder",
			"hardest"
		}
	},
	{
		default = "default",
		setting_name = "pactsworn_respawn_timer",
		values = var_0_0(0, 60, 5, {
			"default"
		})
	},
	{
		default = 40,
		setting_name = "catch_up_with_heroes",
		values = var_0_0(0, 100, 10)
	},
	{
		default = 1,
		setting_name = "hero_damage_taken",
		values = var_0_0(0.1, 5, 0.1)
	},
	{
		default = false,
		setting_name = "hero_rescues_enabled",
		values = {
			true,
			false
		}
	},
	{
		default = 8,
		setting_name = "special_spawn_range_distance",
		values = var_0_0(0, 100, 2)
	},
	{
		default = 12,
		setting_name = "boss_spawn_range_distance",
		values = var_0_0(0, 100, 2)
	},
	{
		default = false,
		setting_name = "pactsworn_stagger_immunity",
		values = {
			true,
			false
		}
	},
	{
		default = 2,
		setting_name = "num_pactsworn_picking_options",
		values = var_0_0(1, 7, 1)
	},
	{
		default = 1,
		setting_name = "vs_ratling_gunner_spawn_chance_multiplier",
		values = var_0_0(0, 1, 0.1)
	},
	{
		default = 1,
		setting_name = "vs_packmaster_spawn_chance_multiplier",
		values = var_0_0(0, 1, 0.1)
	},
	{
		default = 1,
		setting_name = "vs_gutter_runner_spawn_chance_multiplier",
		values = var_0_0(0, 1, 0.1)
	},
	{
		default = 1,
		setting_name = "vs_poison_wind_globadier_spawn_chance_multiplier",
		values = var_0_0(0, 1, 0.1)
	},
	{
		default = 1,
		setting_name = "vs_warpfire_thrower_spawn_chance_multiplier",
		values = var_0_0(0, 1, 0.1)
	},
	{
		default = "default",
		setting_name = "vs_chaos_troll_spawn_chance_multiplier",
		values = var_0_0(0.1, 1, 0.1, {
			false,
			"default"
		})
	},
	{
		default = "default",
		setting_name = "vs_rat_ogre_spawn_chance_multiplier",
		values = var_0_0(0.1, 1, 0.1, {
			false,
			"default"
		})
	},
	{
		default = 50,
		setting_name = "vs_ratling_gunner_hp",
		values = var_0_0(10, 1000, 10)
	},
	{
		default = 50,
		setting_name = "vs_packmaster_hp",
		values = var_0_0(10, 1000, 10)
	},
	{
		default = 30,
		setting_name = "vs_gutter_runner_hp",
		values = var_0_0(10, 1000, 10)
	},
	{
		default = 30,
		setting_name = "vs_poison_wind_globadier_hp",
		values = var_0_0(10, 1000, 10)
	},
	{
		default = 50,
		setting_name = "vs_warpfire_thrower_hp",
		values = var_0_0(10, 1000, 10)
	},
	{
		default = 800,
		setting_name = "vs_chaos_troll_hp",
		values = var_0_0(100, 5000, 100)
	},
	{
		default = 800,
		setting_name = "vs_rat_ogre_hp",
		values = var_0_0(100, 5000, 100)
	}
}
local var_0_2 = 0

for iter_0_0, iter_0_1 in ipairs(var_0_1) do
	var_0_2 = var_0_2 + 1
	iter_0_1.id = var_0_2
	var_0_1[iter_0_1.setting_name] = iter_0_1

	local var_0_3 = iter_0_1.values

	iter_0_1.values_reverse_lookup = {}

	for iter_0_2, iter_0_3 in pairs(var_0_3) do
		iter_0_1.values_reverse_lookup[iter_0_3] = iter_0_2
	end
end

return var_0_1
