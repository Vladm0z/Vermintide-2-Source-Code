-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_warpfire_thrower.lua

CareerAbilityWarpfireThrower = class(CareerAbilityWarpfireThrower, CareerAbilityDarkPactBase)

CareerAbilityWarpfireThrower.ability_ready = function (arg_1_0)
	arg_1_0.super.ability_ready(arg_1_0)

	local var_1_0 = arg_1_0._first_person_extension

	if var_1_0 then
		local var_1_1 = arg_1_0._unit
		local var_1_2 = arg_1_0._wwise_world

		WwiseWorld.trigger_event(var_1_2, "player_enemy_warpfire_steam_after_flame_stop", var_1_1)
		CharacterStateHelper.play_animation_event_first_person(var_1_0, "cooldown_ready")
		CharacterStateHelper.play_animation_event(var_1_1, "cooldown_ready")
	end
end
