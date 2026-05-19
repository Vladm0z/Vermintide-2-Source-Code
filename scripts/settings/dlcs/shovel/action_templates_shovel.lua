-- chunkname: @scripts/settings/dlcs/shovel/action_templates_shovel.lua

ActionTemplates.action_career_bw_necromancer = {
	default = {
		slot_to_wield = "slot_career_skill_weapon",
		weapon_action_hand = "either",
		kind = "instant_wield",
		input_override = "action_career",
		total_time = 0,
		condition_func = function(arg_1_0, arg_1_1)
			if ScriptUnit.extension(arg_1_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			if not ScriptUnit.extension(arg_1_0, "inventory_system"):can_wield() then
				return false
			end

			local var_1_0 = ScriptUnit.extension(arg_1_0, "career_system")
			local var_1_1 = var_1_0:get_passive_ability_by_name("bw_necromancer")

			if not var_1_1 or not var_1_1:is_ready() then
				return false
			end

			local var_1_2 = var_1_0:get_activated_ability_data()

			return var_1_0:can_use_activated_ability() and var_1_2.action_name == "action_career_bw_necromancer"
		end,
		enter_function = function(arg_2_0, arg_2_1)
			local var_2_0 = ScriptUnit.has_extension(arg_2_0, "inventory_system")

			if var_2_0 then
				var_2_0:check_and_drop_pickups("career_ability")
			end
		end,
		action_on_wield = {
			action = "action_career_hold",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}
