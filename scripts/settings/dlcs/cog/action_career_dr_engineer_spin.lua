-- chunkname: @scripts/settings/dlcs/cog/action_career_dr_engineer_spin.lua

ActionCareerDREngineerSpin = class(ActionCareerDREngineerSpin, ActionMinigunSpin)

ActionCareerDREngineerSpin.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerDREngineerSpin.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
end

ActionCareerDREngineerSpin.client_owner_start_action = function (self, arg_2_1, arg_2_2)
	-- function 2
	ActionCareerDREngineerSpin.super.client_owner_start_action(self, arg_2_1, arg_2_2)

	self._override_visual_spinup = arg_2_1.override_visual_spinup
	self._visual_spinup_min = arg_2_1.visual_spinup_min
	self._visual_spinup_max = arg_2_1.visual_spinup_max
	self._visual_spinup_time = arg_2_1.visual_spinup_time
	self._last_update_t = arg_2_2

	if not self._talent_extension:has_talent("bardin_engineer_reduced_ability_fire_slowdown") then
		self._current_windup = CareerConstants.dr_engineer.talent_6_2_starting_rps

		if Managers.mechanism:current_mechanism_name() == "versus" then
			self._current_windup = CareerConstants.dr_engineer.talent_6_2_starting_rps_vs
		end
	end
end

ActionCareerDREngineerSpin.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	ActionCareerDREngineerSpin.super.client_owner_post_update(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	self._last_update_t = arg_3_2
end

ActionCareerDREngineerSpin.finish = function (self, arg_4_1)
	-- function 4
	ActionCareerDREngineerSpin.super.finish(self, arg_4_1)

	local get_custom_data = self.weapon_extension:get_custom_data("windup")

	if not self._override_visual_spinup then
		local num = (self._last_update_t - self.action_start_t) / self._visual_spinup_time

		get_custom_data = math.lerp(self._visual_spinup_min, self._visual_spinup_max, num)
	end

	Managers.state.event:trigger("on_engineer_weapon_spin_up", get_custom_data, self._override_visual_spinup)
end
