-- chunkname: @scripts/ui/weave_tutorial/weave_onboarding_utils.lua

WeaveOnboardingUtils = WeaveOnboardingUtils or {}

local var_0_0 = "scorpion_onboarding_step"
local var_0_1 = "scorpion_ui_onboarding_state"

function WeaveOnboardingUtils.tutorial_completed(arg_1_0, arg_1_1)
	return arg_1_1.ui_onboarding_bit ~= 0 and bit.band(arg_1_0, arg_1_1.ui_onboarding_bit) == arg_1_1.ui_onboarding_bit
end

function WeaveOnboardingUtils.reached_requirements(arg_2_0, arg_2_1)
	return arg_2_0 >= arg_2_1.onboarding_step
end

function WeaveOnboardingUtils.complete_tutorial(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0 and arg_3_1 and arg_3_2 then
		local var_3_0 = WeaveOnboardingUtils.get_ui_onboarding_state(arg_3_0, arg_3_1)
		local var_3_1 = bit.bor(var_3_0, arg_3_2.ui_onboarding_bit)

		arg_3_0:set_stat(arg_3_1, var_0_1, var_3_1)
	end
end

function WeaveOnboardingUtils.get_onboarding_step(arg_4_0, arg_4_1)
	return arg_4_0:get_persistent_stat(arg_4_1, var_0_0)
end

function WeaveOnboardingUtils.get_ui_onboarding_state(arg_5_0, arg_5_1)
	return arg_5_0:get_persistent_stat(arg_5_1, var_0_1)
end

function WeaveOnboardingUtils.complete_onboarding()
	local var_6_0 = Managers.player:statistics_db()
	local var_6_1 = Managers.player:local_player():stats_id()

	var_6_0:set_stat(var_6_1, var_0_0, 10)
	var_6_0:set_stat(var_6_1, var_0_1, -1)
end
