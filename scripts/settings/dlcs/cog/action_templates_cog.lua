-- chunkname: @scripts/settings/dlcs/cog/action_templates_cog.lua

ActionTemplates.action_career_dr_4 = {
	default = {
		total_time = 0,
		slot_to_wield = "slot_career_skill_weapon",
		input_override = "action_career",
		weapon_action_hand = "either",
		kind = "instant_wield",
		condition_func = function(arg_1_0, arg_1_1)
			if ScriptUnit.extension(arg_1_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			if not ScriptUnit.extension(arg_1_0, "inventory_system"):can_wield() then
				return false
			end

			return ScriptUnit.extension(arg_1_0, "career_system"):get_activated_ability_data().action_name == "action_career_dr_4"
		end,
		enter_function = function(arg_2_0, arg_2_1)
			local var_2_0 = ScriptUnit.has_extension(arg_2_0, "inventory_system")

			if var_2_0 then
				var_2_0:check_and_drop_pickups("career_ability")
			end
		end,
		allowed_chain_actions = {}
	}
}
