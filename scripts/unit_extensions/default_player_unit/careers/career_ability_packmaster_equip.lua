-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_packmaster_equip.lua

CareerAbilityPackmasterEquip = class(CareerAbilityPackmasterEquip, CareerAbilityDarkPactBase)

CareerAbilityPackmasterEquip.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)

	arg_1_0._ability_default_startup_delay_time = arg_1_0._ability_data.startup_delay_time

	arg_1_0:freeze()
end

CareerAbilityPackmasterEquip.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0._freezed then
		return
	end

	if not arg_2_0._equip_ready then
		if not arg_2_0._equip_startup_delay_time then
			if arg_2_0:_ability_available() then
				arg_2_0._equip_startup_delay_time = arg_2_5 + arg_2_0._ability_default_startup_delay_time
			end
		elseif not arg_2_0._equip_ready and arg_2_5 >= arg_2_0._equip_startup_delay_time then
			arg_2_0._equip_ready = true
		end
	end

	local var_2_0 = arg_2_0._equip_startup_delay_time

	if var_2_0 then
		local var_2_1 = arg_2_0._ability_default_startup_delay_time

		arg_2_0._startup_delay_fraction = math.clamp((var_2_0 - arg_2_5) / var_2_1, 0, 1)
	end
end

CareerAbilityPackmasterEquip.was_triggered = function (arg_3_0)
	if arg_3_0:_ability_available() and arg_3_0._equip_ready then
		arg_3_0:_start()

		return true
	end

	return false
end

CareerAbilityPackmasterEquip.startup_delay_fraction = function (arg_4_0)
	return arg_4_0._startup_delay_fraction
end

CareerAbilityPackmasterEquip.startup_delay_time = function (arg_5_0)
	return arg_5_0._equip_startup_delay_time
end

CareerAbilityPackmasterEquip._start = function (arg_6_0)
	arg_6_0.super._start(arg_6_0)
	arg_6_0:freeze()

	arg_6_0._equip_ready = nil
	arg_6_0._startup_delay_fraction = nil
	arg_6_0._equip_startup_delay_time = nil
end

CareerAbilityPackmasterEquip.unfreeze = function (arg_7_0)
	arg_7_0._freezed = false
end

CareerAbilityPackmasterEquip.freeze = function (arg_8_0)
	arg_8_0._freezed = true
end
