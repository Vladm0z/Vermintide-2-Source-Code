-- chunkname: @scripts/settings/dlcs/woods/woods_bot_conditions.lua

local BTConditions = BTConditions
local can_activate = BTConditions.can_activate

can_activate = can_activate or {}
BTConditions.can_activate = can_activate

local BTConditions_2 = BTConditions
local can_activate_non_combat = BTConditions.can_activate_non_combat

can_activate_non_combat = can_activate_non_combat or {}
BTConditions_2.can_activate_non_combat = can_activate_non_combat

table.merge_recursive(BTConditions.ability_check_categories, {
	activate_ability = {
		we_thornsister = true
	}
})

local num = 100
local num_2 = 8
local num_3 = 1.5

BTConditions.can_activate.we_thornsister = function (self)
	-- function 1
	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "talent_system")
	local flag = not has_extension and has_extension:has_talent("kerillian_thorn_sister_debuff_wall")

	if not flag then
		local get_threat_value, var_1_4 = Managers.state.conflict:get_threat_value()

		if var_1_4 < 20 then
			return false
		end
	end

	local var_1_5 = POSITION_LOOKUP[unit]
	local target_unit = self.target_unit
	local var_1_7 = BLACKBOARDS[target_unit]
	local var_1_8
	local num_2 = 0

	if not target_unit then
		local distance_squared = Vector3.distance_squared(var_1_5, POSITION_LOOKUP[target_unit])

		if not (not (distance_squared <= num) or not (distance_squared >= 4)) then
			if not flag then
				local flag_2 = not var_1_7 and var_1_7.breed
				local threat_value

				if not flag_2 then
					threat_value = flag_2.threat_value

					if not threat_value then
						-- Nothing
					end
				end

				threat_value = 0

				::label_1_0::

				if not (target_unit == self.priority_target_enemy or target_unit == self.urgent_target_enemy or target_unit == self.opportunity_target_enemy or not (threat_value >= 8)) then
					var_1_8 = target_unit
				end
			elseif #self.proximite_enemies >= 10 then
				var_1_8 = target_unit
				num_2 = -(math.sqrt(distance_squared) / num_3)
			end
		end
	end

	if not var_1_8 then
		local var_1_13 = POSITION_LOOKUP[var_1_8]
		local normalize = Vector3.normalize(var_1_13 - var_1_5)
		local num_4 = var_1_13 + normalize * math.max(num_2, 0)
		local nav_world = self.nav_world
		local flag_3 = not var_1_7 and var_1_7.navigation_extension
		local flag_4 = not flag_3 and flag_3:traverse_logic()

		if not (flag or LocomotionUtils.ray_can_go_on_mesh(nav_world, var_1_5, num_4, flag_4, 1, 1)) then
			local num_5 = var_1_13 + normalize * num_2

			self.activate_ability_data.aim_position:store(num_5)

			return true
		end
	end

	return false
end
