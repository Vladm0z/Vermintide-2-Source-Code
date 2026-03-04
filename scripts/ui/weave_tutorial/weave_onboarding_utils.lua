-- chunkname: @scripts/ui/weave_tutorial/weave_onboarding_utils.lua

WeaveOnboardingUtils = WeaveOnboardingUtils or {}

local var_0_0 = "scorpion_onboarding_step"
local var_0_1 = "scorpion_ui_onboarding_state"

WeaveOnboardingUtils.tutorial_completed = function (arg_1_0, arg_1_1)
	return arg_1_1.ui_onboarding_bit ~= 0 and bit.band(arg_1_0, arg_1_1.ui_onboarding_bit) == arg_1_1.ui_onboarding_bit
end

WeaveOnboardingUtils.reached_requirements = function (arg_2_0, arg_2_1)
	return arg_2_0 >= arg_2_1.onboarding_step
end

WeaveOnboardingUtils.complete_tutorial = function (arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0 and arg_3_1 and arg_3_2 then
		local var_3_0 = WeaveOnboardingUtils.get_ui_onboarding_state(arg_3_0, arg_3_1)
		local var_3_1 = bit.bor(var_3_0, arg_3_2.ui_onboarding_bit)

		arg_3_0:set_stat(arg_3_1, var_0_1, var_3_1)
	end
end

WeaveOnboardingUtils.get_onboarding_step = function (arg_4_0, arg_4_1)
	return arg_4_0:get_persistent_stat(arg_4_1, var_0_0)
end

WeaveOnboardingUtils.get_ui_onboarding_state = function (arg_5_0, arg_5_1)
	return arg_5_0:get_persistent_stat(arg_5_1, var_0_1)
end

WeaveOnboardingUtils.complete_onboarding = function ()
	local var_6_0 = Managers.player:statistics_db()
	local var_6_1 = Managers.player:local_player():stats_id()

	var_6_0:set_stat(var_6_1, var_0_0, 10)
	var_6_0:set_stat(var_6_1, var_0_1, -1)
end
