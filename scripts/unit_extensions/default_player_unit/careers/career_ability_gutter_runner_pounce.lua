-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_gutter_runner_pounce.lua

CareerAbilityGutterRunnerPounce = class(CareerAbilityGutterRunnerPounce, CareerAbilityDarkPactBase)

function CareerAbilityGutterRunnerPounce._ability_available(arg_1_0)
	local var_1_0 = arg_1_0._career_extension
	local var_1_1 = arg_1_0._status_extension
	local var_1_2 = var_1_0:get_state() == "vs_gutter_runner_smoke_bomb_invisible"
	local var_1_3 = var_1_0:can_use_activated_ability(1)
	local var_1_4 = var_1_1:is_disabled()
	local var_1_5 = not var_1_1:is_disabled()

	return var_1_3 and not var_1_4 and not var_1_2 and var_1_5
end
