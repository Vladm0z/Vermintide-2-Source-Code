-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_dark_pact_horde.lua

CareerAbilityDarkPactHorde = class(CareerAbilityDarkPactHorde, CareerAbilityDarkPactBase)

function CareerAbilityDarkPactHorde._ability_available(arg_1_0)
	local var_1_0 = arg_1_0._status_extension
	local var_1_1 = arg_1_0._ghost_mode_extension:is_in_ghost_mode()

	return not var_1_0:is_disabled() and not var_1_1
end
