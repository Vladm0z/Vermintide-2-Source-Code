-- chunkname: @scripts/settings/dlcs/shovel/shovel_bot_conditions.lua

BTConditions.can_activate = BTConditions.can_activate or {}
BTConditions.can_activate_non_combat = BTConditions.can_activate_non_combat or {}

table.merge_recursive(BTConditions.ability_check_categories, {
	activate_ability = {
		bw_necromancer = true
	}
})

BTConditions.can_activate.bw_necromancer = function (arg_1_0)
	if arg_1_0.ai_slot_extension.num_occupied_slots >= 3 then
		return true
	end

	if not Managers.state.game_mode:is_round_started() then
		arg_1_0._bt_conditions_first_ability = true

		return false
	elseif arg_1_0._bt_conditions_first_ability then
		local var_1_0 = Managers.time:time("game")

		arg_1_0._first_ability_t = arg_1_0._first_ability_t or var_1_0 + Math.random(1, 4)

		if var_1_0 < arg_1_0._first_ability_t then
			return false
		end

		arg_1_0._bt_conditions_first_ability = nil
		arg_1_0._first_ability_t = nil
	end

	if arg_1_0.ai_commander_extension:get_controlled_units_count() <= 4 then
		return true
	end

	return false
end
