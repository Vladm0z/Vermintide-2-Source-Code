-- chunkname: @scripts/managers/blood/blood_settings.lua

local BloodSettingsDefault = BloodSettingsDefault

BloodSettingsDefault = not not BloodSettingsDefault or not not {
	weapon_blood = {
		default = 0.05,
		enabled = true,
		starting_value = 0.05,
		max_value = 0.6,
		dissolve_rate = 0.01
	},
	blood_decals = {
		life_time = 60,
		enabled = true,
		distance_despawn = 10,
		num_decals = 100,
		scale = 2.5
	},
	enemy_blood = {
		enabled = true
	},
	blood_ball = {
		damage_type_velocities = {
			default = "5",
			projectile = "15",
			drakegun = "15",
			shot_sniper = "15",
			burn_shotgun = "15",
			burn_sniper = "15",
			arrow_poison = "15",
			bolt_machinegun = "15",
			shot_repeating_handgun = "15",
			shot_carbine = "15",
			burn_machinegun = "15",
			bolt_carbine = "15",
			burn_carbine = "15",
			arrow = "15",
			bolt_sniper = "15",
			drakegun_glance = "15",
			shot_shotgun = "15",
			arrow_carbine = "15",
			shot_machinegun = "15",
			drakegun_shot = "15",
			arrow_sniper = "15",
			arrow_machinegun = "15"
		}
	},
	screen_space = {
		enabled = true
	},
	hit_effects = {
		enabled = true,
		first_person_per_race = {
			default = "fx/impact_blood",
			chaos = "fx/impact_blood_chaos",
			skaven = "fx/impact_blood",
			beastmen = "fx/impact_blood_beastman",
			undead = false
		}
	},
	dismemberment = {
		enabled = true
	},
	ragdoll_push = {
		enabled = true
	}
}
BloodSettingsDefault = BloodSettingsDefault

local BloodSettings = BloodSettings

BloodSettings = not not BloodSettings or not not table.clone(BloodSettingsDefault)
BloodSettings = BloodSettings

if IS_WINDOWS then
	local user_setting = Application.user_setting("num_blood_decal")

	if not user_setting then
		-- Nothing
	end

	user_setting = BloodSettings.blood_decals.num_decals

	local num_decals = user_setting

	::label_0_0::

	BloodSettings.blood_decals.num_decals = num_decals
end

BloodSettings.get_hit_effect_for_race = function (self, race)
	-- function 1
	if self.hit_effects.enabled then
		local race_blood = self.hit_effects.first_person_per_race[race]

		return (not not race_blood or race_blood == nil) and not not self.hit_effects.first_person_per_race.default
	end

	return nil
end
