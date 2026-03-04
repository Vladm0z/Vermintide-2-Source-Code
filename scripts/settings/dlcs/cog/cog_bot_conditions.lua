-- chunkname: @scripts/settings/dlcs/cog/cog_bot_conditions.lua

BTConditions.can_activate = BTConditions.can_activate or {}
BTConditions.can_activate_non_combat = BTConditions.can_activate_non_combat or {}

table.merge_recursive(BTConditions.ability_check_categories, {
	ranged_weapon = {
		dr_engineer = true
	}
})

local var_0_0 = Vector3.distance_squared
local var_0_1 = 400

BTConditions.can_activate.dr_engineer = function (arg_1_0)
	local var_1_0 = arg_1_0.target_unit

	if not ALIVE[var_1_0] or Unit.get_data(var_1_0, "breed") == nil then
		return false
	end

	local var_1_1 = ScriptUnit.has_extension(var_1_0, "buff_system")

	if var_1_1 and var_1_1:has_buff_perk("invulnerable_ranged") then
		return false
	end

	local var_1_2 = arg_1_0.ranged_obstruction_by_static

	if var_1_2 and var_1_2.unit == var_1_0 and Managers.time:time("game") <= var_1_2.timer + 1 then
		return false
	end

	local var_1_3 = arg_1_0.career_extension
	local var_1_4 = arg_1_0.inventory_extension
	local var_1_5 = var_1_4 and var_1_4:get_wielded_slot_name() == "career_skill_weapon" and 0.6 or 0.95

	if not var_1_3 or var_1_5 < var_1_3:current_ability_cooldown_percentage() then
		return false
	end

	local var_1_6 = arg_1_0.unit
	local var_1_7 = POSITION_LOOKUP[var_1_6]

	if var_0_0(var_1_7, POSITION_LOOKUP[var_1_0]) > var_0_1 then
		return false
	end

	local var_1_8 = arg_1_0.proximite_enemies
	local var_1_9 = #var_1_8
	local var_1_10 = 9

	for iter_1_0 = 1, var_1_9 do
		local var_1_11 = var_1_8[iter_1_0]

		if ALIVE[var_1_11] then
			local var_1_12 = POSITION_LOOKUP[var_1_11]

			if var_1_10 >= var_0_0(var_1_7, var_1_12) then
				return false
			end
		end
	end

	return Managers.state.conflict:get_threat_value() > 10
end

BTConditions.reload_ability_weapon.dr_engineer = function (arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.career_extension

	if var_2_0 then
		local var_2_1 = arg_2_0.proximite_enemies

		return var_2_0:current_ability_cooldown() > arg_2_1.ability_cooldown_theshold and #var_2_1 == 0
	end

	return false
end
