-- chunkname: @scripts/settings/dlcs/cog/cog_bot_conditions.lua

local BTConditions = BTConditions
local can_activate = BTConditions.can_activate

can_activate = can_activate or {}
BTConditions.can_activate = can_activate

local BTConditions_2 = BTConditions
local can_activate_non_combat = BTConditions.can_activate_non_combat

can_activate_non_combat = can_activate_non_combat or {}
BTConditions_2.can_activate_non_combat = can_activate_non_combat

table.merge_recursive(BTConditions.ability_check_categories, {
	ranged_weapon = {
		dr_engineer = true
	}
})

local distance_squared = Vector3.distance_squared
local num = 400

BTConditions.can_activate.dr_engineer = function (self)
	-- function 1
	local target_unit = self.target_unit

	if not (not ALIVE[target_unit] and Unit.get_data(target_unit, "breed") ~= nil) then
		return false
	end

	local has_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if not has_extension and not has_extension:has_buff_perk("invulnerable_ranged") then
		return false
	end

	local ranged_obstruction_by_static = self.ranged_obstruction_by_static

	if not ranged_obstruction_by_static and ranged_obstruction_by_static.unit ~= target_unit or not (Managers.time:time("game") <= ranged_obstruction_by_static.timer + 1) then
		return false
	end

	local career_extension = self.career_extension
	local inventory_extension = self.inventory_extension
	local flag

	flag = not (not inventory_extension and inventory_extension:get_wielded_slot_name() == "career_skill_weapon") and 0.6 and 0.95

	if not (not career_extension and not (flag < career_extension:current_ability_cooldown_percentage())) then
		return false
	end

	local unit = self.unit
	local var_1_7 = POSITION_LOOKUP[unit]

	if distance_squared(var_1_7, POSITION_LOOKUP[target_unit]) > num then
		return false
	end

	local proximite_enemies = self.proximite_enemies
	local count = #proximite_enemies
	local num_2 = 9

	for i = 1, count do
		local var_1_11 = proximite_enemies[i]

		if not ALIVE[var_1_11] then
			local var_1_12 = POSITION_LOOKUP[var_1_11]

			if num_2 >= distance_squared(var_1_7, var_1_12) then
				return false
			end
		end
	end

	return Managers.state.conflict:get_threat_value() > 10
end

BTConditions.reload_ability_weapon.dr_engineer = function (self, arg_2_1)
	-- function 2
	local career_extension = self.career_extension

	if not career_extension then
		local proximite_enemies = self.proximite_enemies

		return not (career_extension:current_ability_cooldown() > arg_2_1.ability_cooldown_theshold) or #proximite_enemies == 0
	end

	return false
end
