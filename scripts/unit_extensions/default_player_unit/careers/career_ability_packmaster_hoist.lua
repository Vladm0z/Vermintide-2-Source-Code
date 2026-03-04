-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_packmaster_hoist.lua

CareerAbilityPackmasterHoist = class(CareerAbilityPackmasterHoist, CareerAbilityDarkPactBase)

function CareerAbilityPackmasterHoist._ability_available(arg_1_0)
	local var_1_0 = arg_1_0.super._ability_available(arg_1_0)
	local var_1_1 = arg_1_0._status_extension
	local var_1_2 = arg_1_0._locomotion_extension

	return var_1_0 and var_1_1:get_is_packmaster_dragging() and var_1_2:is_on_ground()
end
