-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_gutter_runner_foff.lua

CareerAbilityGutterRunnerFoff = class(CareerAbilityGutterRunnerFoff, CareerAbilityDarkPactBase)

function CareerAbilityGutterRunnerFoff._ability_available(arg_1_0)
	local var_1_0 = arg_1_0.super._ability_available(arg_1_0)
	local var_1_1 = arg_1_0._career_extension:get_state() == "vs_gutter_runner_smoke_bomb_invisible"

	return var_1_0 and not var_1_1
end

function CareerAbilityGutterRunnerFoff._start(arg_2_0)
	arg_2_0.super._start(arg_2_0)

	local var_2_0 = arg_2_0._career_extension
	local var_2_1 = arg_2_0._ability_data.ability_id

	var_2_0:start_activated_ability_cooldown(var_2_1)
	var_2_0:set_activated_ability_cooldown_paused(var_2_1)
end
