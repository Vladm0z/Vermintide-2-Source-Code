-- chunkname: @scripts/settings/dlcs/lake/action_templates_lake.lua

ActionTemplates.action_career_es_4 = {
	default = {
		slot_to_wield = "slot_career_skill_weapon",
		input_override = "action_career",
		weapon_action_hand = "either",
		kind = "instant_wield",
		total_time = 0,
		condition_func = function (arg_1_0, arg_1_1)
			if ScriptUnit.extension(arg_1_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local var_1_0 = ScriptUnit.extension(arg_1_0, "career_system")

			return var_1_0:get_activated_ability_data().action_name == "action_career_es_4" and var_1_0:can_use_activated_ability()
		end,
		action_on_wield = {
			action = "action_career_hold",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}
