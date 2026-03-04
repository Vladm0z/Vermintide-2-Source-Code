-- chunkname: @scripts/settings/dlcs/cog/action_career_dr_engineer_spin.lua

ActionCareerDREngineerSpin = class(ActionCareerDREngineerSpin, ActionMinigunSpin)

function ActionCareerDREngineerSpin.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerDREngineerSpin.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
end

function ActionCareerDREngineerSpin.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)
	ActionCareerDREngineerSpin.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0._override_visual_spinup = arg_2_1.override_visual_spinup
	arg_2_0._visual_spinup_min = arg_2_1.visual_spinup_min
	arg_2_0._visual_spinup_max = arg_2_1.visual_spinup_max
	arg_2_0._visual_spinup_time = arg_2_1.visual_spinup_time
	arg_2_0._last_update_t = arg_2_2

	if arg_2_0._talent_extension:has_talent("bardin_engineer_reduced_ability_fire_slowdown") then
		arg_2_0._current_windup = CareerConstants.dr_engineer.talent_6_2_starting_rps

		if Managers.mechanism:current_mechanism_name() == "versus" then
			arg_2_0._current_windup = CareerConstants.dr_engineer.talent_6_2_starting_rps_vs
		end
	end
end

function ActionCareerDREngineerSpin.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	ActionCareerDREngineerSpin.super.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)

	arg_3_0._last_update_t = arg_3_2
end

function ActionCareerDREngineerSpin.finish(arg_4_0, arg_4_1)
	ActionCareerDREngineerSpin.super.finish(arg_4_0, arg_4_1)

	local var_4_0 = arg_4_0.weapon_extension:get_custom_data("windup")

	if arg_4_0._override_visual_spinup then
		local var_4_1 = (arg_4_0._last_update_t - arg_4_0.action_start_t) / arg_4_0._visual_spinup_time

		var_4_0 = math.lerp(arg_4_0._visual_spinup_min, arg_4_0._visual_spinup_max, var_4_1)
	end

	Managers.state.event:trigger("on_engineer_weapon_spin_up", var_4_0, arg_4_0._override_visual_spinup)
end
