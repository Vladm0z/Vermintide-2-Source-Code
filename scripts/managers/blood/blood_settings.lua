-- chunkname: @scripts/managers/blood/blood_settings.lua

BloodSettingsDefault = BloodSettingsDefault
BloodSettings = BloodSettings

if IS_WINDOWS then
	local num_decals = Application.user_setting("num_blood_decal")

	BloodSettings.blood_decals.num_decals = num_decals
end

BloodSettings.get_hit_effect_for_race = function (self, race)
	-- function 1
	if self.hit_effects.enabled then
		local race_blood = self.hit_effects.first_person_per_race[race]

		return race_blood or race_blood == nil and self.hit_effects.first_person_per_race.default
	end

	return nil
end
