-- chunkname: @scripts/settings/light_weight_projectile_effects.lua

local function fn(arg_1_0)
	-- function 1
	local default_inventory_template = Unit.get_data(arg_1_0, "breed").default_inventory_template

	return (ScriptUnit.extension(arg_1_0, "ai_inventory_system"):get_unit(default_inventory_template))
end

local function fn_2(arg_2_0)
	-- function 2
	return (ScriptUnit.extension(arg_2_0, "inventory_system"):get_weapon_unit())
end

local function fn_3(arg_3_0)
	-- function 3
	return not NetworkUnit.is_network_unit(arg_3_0) and NetworkUnit.is_husk_unit(arg_3_0)
end

local function fn_4(arg_4_0)
	-- function 4
	return not fn_3(arg_4_0)
end

local function fn_5(arg_5_0)
	-- function 5
	return fn_3(arg_5_0)
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
				unit_function = fn
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
				condition_function = fn_4
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_muzzlefx_vs",
				link = "p_fx",
				unit_function = fn_2,
				condition_function = fn_4
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_bullet",
				kill_policy = "destroy",
				condition_function = fn_5
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_bullet_trail",
				kill_policy = "stop",
				condition_function = fn_5
			},
			{
				particle_name = "fx/wpnfx_skaven_ratlinggun_muzzlefx",
				link = "p_fx",
				unit_function = fn_2,
				condition_function = fn_5
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
