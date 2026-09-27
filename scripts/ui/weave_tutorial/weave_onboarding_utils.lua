-- chunkname: @scripts/ui/weave_tutorial/weave_onboarding_utils.lua

local WeaveOnboardingUtils = WeaveOnboardingUtils

WeaveOnboardingUtils = WeaveOnboardingUtils or {}
WeaveOnboardingUtils = WeaveOnboardingUtils

local str = "scorpion_onboarding_step"
local str_2 = "scorpion_ui_onboarding_state"

WeaveOnboardingUtils.tutorial_completed = function (arg_1_0, arg_1_1)
	-- function 1
	return arg_1_1.ui_onboarding_bit == 0 or bit.band(arg_1_0, arg_1_1.ui_onboarding_bit) == arg_1_1.ui_onboarding_bit
end

WeaveOnboardingUtils.reached_requirements = function (arg_2_0, arg_2_1)
	-- function 2
	return arg_2_0 >= arg_2_1.onboarding_step
end

WeaveOnboardingUtils.complete_tutorial = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self and not arg_3_1 and not arg_3_2 then
		local get_ui_onboarding_state = WeaveOnboardingUtils.get_ui_onboarding_state(self, arg_3_1)
		local bor = bit.bor(get_ui_onboarding_state, arg_3_2.ui_onboarding_bit)

		self:set_stat(arg_3_1, str_2, bor)
	end
end

WeaveOnboardingUtils.get_onboarding_step = function (self, arg_4_1)
	-- function 4
	return self:get_persistent_stat(arg_4_1, str)
end

WeaveOnboardingUtils.get_ui_onboarding_state = function (self, arg_5_1)
	-- function 5
	return self:get_persistent_stat(arg_5_1, str_2)
end

WeaveOnboardingUtils.complete_onboarding = function ()
	-- function 6
	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()

	statistics_db:set_stat(stats_id, str, 10)
	statistics_db:set_stat(stats_id, str_2, -1)
end
