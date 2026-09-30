-- chunkname: @scripts/settings/dlcs/bless/action_templates_bless.lua

ActionTemplates.action_career_wh_priest = {
	default = {
		total_time = 0,
		slot_to_wield = "slot_career_skill_weapon",
		input_override = "action_career",
		weapon_action_hand = "either",
		kind = "instant_wield",
		condition_func = function (action_user, input_extension)
			-- function 1
			local buff_extension = ScriptUnit.extension(action_user, "buff_system")
			local is_disabled = buff_extension:has_buff_perk("disable_career_ability")

			if is_disabled then
				return false
			end

			local career_extension = ScriptUnit.extension(action_user, "career_system")
			local activated_ability_data = career_extension:get_activated_ability_data()

			return (career_extension:can_use_activated_ability())
		end,
		enter_function = function (attacker_unit, input_extension)
			-- function 2
			local inventory_extension = ScriptUnit.has_extension(attacker_unit, "inventory_system")

			if inventory_extension then
				inventory_extension:check_and_drop_pickups("career_ability")
			end
		end,
		allowed_chain_actions = {}
	}
}
