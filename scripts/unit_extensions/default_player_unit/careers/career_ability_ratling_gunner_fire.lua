-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_ratling_gunner_fire.lua

CareerAbilityRatlingGunnerFire = class(CareerAbilityRatlingGunnerFire, CareerAbilityDarkPactBase)

CareerAbilityRatlingGunnerFire.ability_ready = function (arg_1_0)
	arg_1_0.super.ability_ready(arg_1_0)

	if arg_1_0._first_person_extension then
		local var_1_0 = Unit.get_data(arg_1_0._unit, "breed")

		if not BLACKBOARDS[arg_1_0._unit].attack_pattern_data then
			local var_1_1 = {}
		end
	end
end

CareerAbilityRatlingGunnerReload = class(CareerAbilityRatlingGunnerReload, CareerAbilityDarkPactBase)

CareerAbilityRatlingGunnerReload.ability_ready = function (arg_2_0)
	arg_2_0.super.ability_ready(arg_2_0)
end

CareerAbilityRatlingGunnerReload._start = function (arg_3_0)
	arg_3_0.super.ability_ready(arg_3_0)

	local var_3_0 = arg_3_0._first_person_extension
	local var_3_1 = Unit.get_data(arg_3_0._unit, "breed")
	local var_3_2 = BLACKBOARDS[arg_3_0._unit].attack_pattern_data or {}

	if not arg_3_0._career_extension:can_use_activated_ability(2) or (var_3_2.current_ammo or 120) >= 120 then
		return
	end

	arg_3_0._career_extension:start_activated_ability_cooldown(1)
	arg_3_0._career_extension:start_activated_ability_cooldown(2)
end

CareerAbilityRatlingGunnerReload.force_trigger_ability = function (arg_4_0)
	arg_4_0:_start()
end

CareerAbilityRatlingGunnerReload._ability_available = function (arg_5_0)
	local var_5_0 = arg_5_0._career_extension
	local var_5_1 = arg_5_0._status_extension
	local var_5_2 = arg_5_0._locomotion_extension
	local var_5_3 = var_5_0:can_use_activated_ability(2)
	local var_5_4 = var_5_1:is_disabled()

	return var_5_3 and not var_5_4
end
