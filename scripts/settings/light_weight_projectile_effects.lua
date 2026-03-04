-- chunkname: @scripts/settings/light_weight_projectile_effects.lua

local function var_0_0(arg_1_0)
	local var_1_0 = Unit.get_data(arg_1_0, "breed").default_inventory_template

	return (ScriptUnit.extension(arg_1_0, "ai_inventory_system"):get_unit(var_1_0))
end

local function var_0_1(arg_2_0)
	return (ScriptUnit.extension(arg_2_0, "inventory_system"):get_weapon_unit())
end

local function var_0_2(arg_3_0)
	return NetworkUnit.is_network_unit(arg_3_0) and NetworkUnit.is_husk_unit(arg_3_0)
end

local function var_0_3(arg_4_0)
	return not var_0_2(arg_4_0)
end

local function var_0_4(arg_5_0)
	return var_0_2(arg_5_0)
end

LightWeightProjectileEffects = {
	ratling_gun_bullet = {
		vfx = {
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_bullet",
				kill_policy = "destroy"
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_bullet_trail",
				kill_policy = "stop"
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_muzzlefx",
				link = "p_fx",
				unit_function = var_0_0
			}
		},
		sfx = {
			{
				looping_sound_event_name = "Play_weapon_warpbullet_flyby_proximity",
				looping_sound_stop_event_name = "Stop_weapon_warpbullet_flyby_proximity"
			}
		}
	},
	ratling_gun_bullet_vs = {
		vfx = {
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_bullet_trail_vs",
				kill_policy = "stop",
				condition_function = var_0_3
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_muzzlefx_vs",
				link = "p_fx",
				unit_function = var_0_1,
				condition_function = var_0_3
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_bullet",
				kill_policy = "destroy",
				condition_function = var_0_4
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_bullet_trail",
				kill_policy = "stop",
				condition_function = var_0_4
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_muzzlefx",
				link = "p_fx",
				unit_function = var_0_1,
				condition_function = var_0_4
			}
		},
		sfx = {
			{
				looping_sound_event_name = "Play_weapon_warpbullet_flyby_proximity",
				looping_sound_stop_event_name = "Stop_weapon_warpbullet_flyby_proximity"
			}
		}
	},
	autocannon_backdrop_bullet = {
		vfx = {
			{
				particle_name = "fx/wpnfx_skaven_autocannon_bullet",
				kill_policy = "destroy"
			},
			{
				particle_name = "fx/wpnfx_skaven_autocannon_bullet_trail",
				kill_policy = "stop"
			}
		},
		sfx = {
			{
				looping_sound_event_name = "Play_weapon_warpbullet_flyby_proximity",
				looping_sound_stop_event_name = "Stop_weapon_warpbullet_flyby_proximity"
			}
		}
	},
	stormfiend_gun_bullet = {
		vfx = {
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_bullet",
				kill_policy = "destroy"
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_bullet_trail",
				kill_policy = "stop"
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_muzzlefx"
			}
		},
		sfx = {
			{
				looping_sound_event_name = "Play_weapon_warpbullet_flyby_proximity",
				looping_sound_stop_event_name = "Stop_weapon_warpbullet_flyby_proximity"
			}
		}
	}
}

DLCUtils.merge("light_weight_projectile_effects", LightWeightProjectileEffects)
