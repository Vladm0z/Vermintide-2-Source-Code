-- chunkname: @scripts/settings/versus_custom_settings_templates.lua

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local tbl = {
		arg_1_0
	}
	local num = (arg_1_1 - arg_1_0) / arg_1_2

	for i = 1, num do
		tbl[i + 1] = arg_1_0 + arg_1_2 * i
	end

	if not arg_1_3 then
		for k, v in pairs(arg_1_3) do
			tbl[#tbl + 1] = v
		end

		table.clear(arg_1_3)
	end

	return tbl
end

local tbl = {
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
		values = fn(0, 500, 50)
	},
	{
		default = false,
		setting_name = "round_time_limit",
		values = fn(3, 20, 1, {
			false
		})
	},
	{
		default = 100,
		setting_name = "horde_ability_recharge_rate_percent",
		values = fn(0, 500, 25)
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
		values = fn(0, 60, 5, {
			"default"
		})
	},
	{
		default = 40,
		setting_name = "catch_up_with_heroes",
		values = fn(0, 100, 10)
	},
	{
		default = 1,
		setting_name = "hero_damage_taken",
		values = fn(0.1, 5, 0.1)
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
		values = fn(0, 100, 2)
	},
	{
		default = 12,
		setting_name = "boss_spawn_range_distance",
		values = fn(0, 100, 2)
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
		values = fn(1, 7, 1)
	},
	{
		default = 1,
		setting_name = "vs_ratling_gunner_spawn_chance_multiplier",
		values = fn(0, 1, 0.1)
	},
	{
		default = 1,
		setting_name = "vs_packmaster_spawn_chance_multiplier",
		values = fn(0, 1, 0.1)
	},
	{
		default = 1,
		setting_name = "vs_gutter_runner_spawn_chance_multiplier",
		values = fn(0, 1, 0.1)
	},
	{
		default = 1,
		setting_name = "vs_poison_wind_globadier_spawn_chance_multiplier",
		values = fn(0, 1, 0.1)
	},
	{
		default = 1,
		setting_name = "vs_warpfire_thrower_spawn_chance_multiplier",
		values = fn(0, 1, 0.1)
	},
	{
		default = "default",
		setting_name = "vs_chaos_troll_spawn_chance_multiplier",
		values = fn(0.1, 1, 0.1, {
			false,
			"default"
		})
	},
	{
		default = "default",
		setting_name = "vs_rat_ogre_spawn_chance_multiplier",
		values = fn(0.1, 1, 0.1, {
			false,
			"default"
		})
	},
	{
		default = 50,
		setting_name = "vs_ratling_gunner_hp",
		values = fn(10, 1000, 10)
	},
	{
		default = 50,
		setting_name = "vs_packmaster_hp",
		values = fn(10, 1000, 10)
	},
	{
		default = 30,
		setting_name = "vs_gutter_runner_hp",
		values = fn(10, 1000, 10)
	},
	{
		default = 30,
		setting_name = "vs_poison_wind_globadier_hp",
		values = fn(10, 1000, 10)
	},
	{
		default = 50,
		setting_name = "vs_warpfire_thrower_hp",
		values = fn(10, 1000, 10)
	},
	{
		default = 800,
		setting_name = "vs_chaos_troll_hp",
		values = fn(100, 5000, 100)
	},
	{
		default = 800,
		setting_name = "vs_rat_ogre_hp",
		values = fn(100, 5000, 100)
	}
}
local num = 0

for i, v in ipairs(tbl) do
	num = num + 1
	v.id = num
	tbl[v.setting_name] = v

	local values = v.values

	v.values_reverse_lookup = {}

	for k, v_2 in pairs(values) do
		v.values_reverse_lookup[v_2] = k
	end
end

return tbl
