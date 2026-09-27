-- chunkname: @scripts/settings/dlcs/cog/action_career_dr_engineer.lua

ActionCareerDREngineer = class(ActionCareerDREngineer, ActionMinigun)

local set_flow_variable = Unit.set_flow_variable
local flow_event = Unit.flow_event

ActionCareerDREngineer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionCareerDREngineer.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._talent_extension = ScriptUnit.extension(arg_1_4, "talent_system")
end

ActionCareerDREngineer.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	ActionCareerDREngineer.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	if not self._talent_extension:has_talent("bardin_engineer_reduced_ability_fire_slowdown") then
		self._max_rps = arg_2_1.max_rps * 1.3

		if Managers.mechanism:current_mechanism_name() == "versus" then
			self._current_rps = math.max(self._current_rps, self._max_rps * CareerConstants.dr_engineer.talent_6_2_starting_rps_vs)
		else
			self._current_rps = math.max(self._current_rps, self._max_rps * CareerConstants.dr_engineer.talent_6_2_starting_rps)
		end
	end

	Managers.state.achievement:trigger_event("crank_gun_fire_start", self.owner_unit)
end

ActionCareerDREngineer._update_attack_speed = function (self, arg_3_1)
	-- function 3
	if not self._calculated_attack_speed then
		self._attack_speed_mod = ActionUtils.get_action_time_scale(self.owner_unit, self.current_action)

		self.first_person_extension:animation_set_variable("barrel_spin_speed", self._attack_speed_mod)
	end

	ActionCareerDREngineer.super._update_attack_speed(self, arg_3_1)
end

ActionCareerDREngineer._shoot = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_handle_infinite_stacks(arg_4_1, arg_4_2)
	ActionCareerDREngineer.super._shoot(self, arg_4_1, arg_4_2)
end

ActionCareerDREngineer._staggered_shot_done = function (self, arg_5_1)
	-- function 5
	ActionCareerDREngineer.super._staggered_shot_done(self, arg_5_1)
	Managers.state.achievement:trigger_event("crank_gun_fire", self.owner_unit, 1)
	flow_event(self.weapon_unit, "lua_finish_shooting")
end

ActionCareerDREngineer.finish = function (self, arg_6_1)
	-- function 6
	ActionCareerDREngineer.super.finish(self, arg_6_1)

	local _initial_rounds_per_second = self._initial_rounds_per_second
	local num = self._max_rps - _initial_rounds_per_second
	local clamp = math.clamp((self._current_rps - _initial_rounds_per_second) / num, 0, 1)

	Managers.state.event:trigger("on_engineer_weapon_spin_up", clamp)
end

local num = 1
local num_2 = 2

ActionCareerDREngineer.fire_hitscan = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local fire_hitscan = ActionCareerDREngineer.super.fire_hitscan(self, arg_7_1, arg_7_2, arg_7_3)
	local var_7_1

	if not fire_hitscan then
		var_7_1 = fire_hitscan[#fire_hitscan][num]

		if not var_7_1 then
			-- Nothing
		end
	end

	var_7_1 = arg_7_1 + arg_7_2 * arg_7_3

	do
		local var_7_2
	end

	::label_7_0::

	if not fire_hitscan then
		var_7_2 = fire_hitscan[#fire_hitscan][num_2]

		if not var_7_2 then
			-- Nothing
		end
	end

	var_7_2 = arg_7_3

	::label_7_1::

	local num_3 = var_7_2 * 0.1

	self:_add_bullet_trail(var_7_1, num_3)
	Managers.state.event:trigger("on_engineer_weapon_fire", self._visual_heat_generation)

	return fire_hitscan
end

ActionCareerDREngineer._add_bullet_trail = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not self.is_bot then
		local weapon_unit = self.weapon_unit

		set_flow_variable(weapon_unit, "is_critical_strike", self._is_critical_strike)
		set_flow_variable(weapon_unit, "hit_position", arg_8_1)
		set_flow_variable(weapon_unit, "trail_life", arg_8_2)
		flow_event(weapon_unit, "lua_bullet_trail")
		flow_event(weapon_unit, "lua_bullet_trail_set")
	end
end

ActionCareerDREngineer.get_projectile_start_position_rotation = function (self)
	-- function 9
	return self.first_person_extension:get_projectile_start_position_rotation()
end

ActionCareerDREngineer._handle_infinite_stacks = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._talent_extension:has_talent("bardin_engineer_pump_buff_long") then
		return
	end

	local get_stacking_buff = self.buff_extension:get_stacking_buff("bardin_engineer_pump_buff")

	if not get_stacking_buff then
		if not self._first_shot then
			for i = 1, #get_stacking_buff do
				if not get_stacking_buff[i].duration then
					return
				end
			end

			local var_10_1 = get_stacking_buff[1]

			var_10_1.duration = CareerConstants.dr_engineer.talent_4_3_stack_duration
			var_10_1.start_time = arg_10_2
		else
			local var_10_2

			for j = 1, #get_stacking_buff do
				local var_10_3 = get_stacking_buff[j]

				if not var_10_3.duration then
					var_10_2 = var_10_3

					break
				end
			end

			if not var_10_2 then
				local var_10_4 = get_stacking_buff[1]

				var_10_4.duration = CareerConstants.dr_engineer.talent_4_3_stack_duration
				var_10_4.start_time = arg_10_2

				return
			end
		end
	end
end
