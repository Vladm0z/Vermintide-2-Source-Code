-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_packmaster_grab.lua

CareerAbilityPackmasterGrab = class(CareerAbilityPackmasterGrab, CareerAbilityDarkPactBase)

function CareerAbilityPackmasterGrab._ability_available(arg_1_0)
	local var_1_0 = arg_1_0.super._ability_available(arg_1_0)
	local var_1_1 = arg_1_0._status_extension

	return var_1_0 and not var_1_1:get_unarmed()
end

function CareerAbilityPackmasterGrab._start(arg_2_0)
	arg_2_0.super._start(arg_2_0)

	local var_2_0 = arg_2_0._career_extension

	var_2_0:start_activated_ability_cooldown(arg_2_0._ability_data.ability_id)
	var_2_0:set_activated_ability_cooldown_paused(arg_2_0._ability_data.ability_id)
end

function CareerAbilityPackmasterGrab.ability_ready(arg_3_0)
	arg_3_0.super.ability_ready(arg_3_0)

	local var_3_0 = arg_3_0._first_person_extension

	if var_3_0 then
		CharacterStateHelper.play_animation_event_first_person(var_3_0, "cooldown_ready")
	end
end
