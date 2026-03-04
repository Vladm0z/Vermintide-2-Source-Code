-- chunkname: @scripts/settings/dlcs/cog/action_career_dr_engineer.lua

ActionCareerDREngineer = class(ActionCareerDREngineer, ActionMinigun)

local var_0_0 = Unit.set_flow_variable
local var_0_1 = Unit.flow_event

ActionCareerDREngineer.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionCareerDREngineer.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
end

ActionCareerDREngineer.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionCareerDREngineer.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	if arg_2_0._talent_extension:has_talent("bardin_engineer_reduced_ability_fire_slowdown") then
		arg_2_0._max_rps = arg_2_1.max_rps * 1.3

		if Managers.mechanism:current_mechanism_name() == "versus" then
			arg_2_0._current_rps = math.max(arg_2_0._current_rps, arg_2_0._max_rps * CareerConstants.dr_engineer.talent_6_2_starting_rps_vs)
		else
			arg_2_0._current_rps = math.max(arg_2_0._current_rps, arg_2_0._max_rps * CareerConstants.dr_engineer.talent_6_2_starting_rps)
		end
	end

	Managers.state.achievement:trigger_event("crank_gun_fire_start", arg_2_0.owner_unit)
end

ActionCareerDREngineer._update_attack_speed = function (arg_3_0, arg_3_1)
	if not arg_3_0._calculated_attack_speed then
		arg_3_0._attack_speed_mod = ActionUtils.get_action_time_scale(arg_3_0.owner_unit, arg_3_0.current_action)

		arg_3_0.first_person_extension:animation_set_variable("barrel_spin_speed", arg_3_0._attack_speed_mod)
	end

	ActionCareerDREngineer.super._update_attack_speed(arg_3_0, arg_3_1)
end

ActionCareerDREngineer._shoot = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_handle_infinite_stacks(arg_4_1, arg_4_2)
	ActionCareerDREngineer.super._shoot(arg_4_0, arg_4_1, arg_4_2)
end

ActionCareerDREngineer._staggered_shot_done = function (arg_5_0, arg_5_1)
	ActionCareerDREngineer.super._staggered_shot_done(arg_5_0, arg_5_1)
	Managers.state.achievement:trigger_event("crank_gun_fire", arg_5_0.owner_unit, 1)
	var_0_1(arg_5_0.weapon_unit, "lua_finish_shooting")
end

ActionCareerDREngineer.finish = function (arg_6_0, arg_6_1)
	ActionCareerDREngineer.super.finish(arg_6_0, arg_6_1)

	local var_6_0 = arg_6_0._initial_rounds_per_second
	local var_6_1 = arg_6_0._max_rps - var_6_0
	local var_6_2 = math.clamp((arg_6_0._current_rps - var_6_0) / var_6_1, 0, 1)

	Managers.state.event:trigger("on_engineer_weapon_spin_up", var_6_2)
end

local var_0_2 = 1
local var_0_3 = 2

ActionCareerDREngineer.fire_hitscan = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = ActionCareerDREngineer.super.fire_hitscan(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_1 = var_7_0 and var_7_0[#var_7_0][var_0_2] or arg_7_1 + arg_7_2 * arg_7_3
	local var_7_2 = (var_7_0 and var_7_0[#var_7_0][var_0_3] or arg_7_3) * 0.1

	arg_7_0:_add_bullet_trail(var_7_1, var_7_2)
	Managers.state.event:trigger("on_engineer_weapon_fire", arg_7_0._visual_heat_generation)

	return var_7_0
end

ActionCareerDREngineer._add_bullet_trail = function (arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0.is_bot then
		local var_8_0 = arg_8_0.weapon_unit

		var_0_0(var_8_0, "is_critical_strike", arg_8_0._is_critical_strike)
		var_0_0(var_8_0, "hit_position", arg_8_1)
		var_0_0(var_8_0, "trail_life", arg_8_2)
		var_0_1(var_8_0, "lua_bullet_trail")
		var_0_1(var_8_0, "lua_bullet_trail_set")
	end
end

ActionCareerDREngineer.get_projectile_start_position_rotation = function (arg_9_0)
	return arg_9_0.first_person_extension:get_projectile_start_position_rotation()
end

ActionCareerDREngineer._handle_infinite_stacks = function (arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._talent_extension:has_talent("bardin_engineer_pump_buff_long") then
		return
	end

	local var_10_0 = arg_10_0.buff_extension:get_stacking_buff("bardin_engineer_pump_buff")

	if var_10_0 then
		if arg_10_0._first_shot then
			for iter_10_0 = 1, #var_10_0 do
				if var_10_0[iter_10_0].duration then
					return
				end
			end

			local var_10_1 = var_10_0[1]

			var_10_1.duration = CareerConstants.dr_engineer.talent_4_3_stack_duration
			var_10_1.start_time = arg_10_2
		else
			local var_10_2

			for iter_10_1 = 1, #var_10_0 do
				local var_10_3 = var_10_0[iter_10_1]

				if var_10_3.duration then
					var_10_2 = var_10_3

					break
				end
			end

			if not var_10_2 then
				local var_10_4 = var_10_0[1]

				var_10_4.duration = CareerConstants.dr_engineer.talent_4_3_stack_duration
				var_10_4.start_time = arg_10_2

				return
			end
		end
	end
end
