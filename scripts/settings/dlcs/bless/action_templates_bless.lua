-- chunkname: @scripts/settings/dlcs/bless/action_templates_bless.lua

ActionTemplates.action_career_wh_priest = {
	default = {
		total_time = 0,
		slot_to_wield = "slot_career_skill_weapon",
		input_override = "action_career",
		weapon_action_hand = "either",
		kind = "instant_wield",
		condition_func = function (arg_1_0, arg_1_1)
			-- function 1
			if not ScriptUnit.extension(arg_1_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local extension = ScriptUnit.extension(arg_1_0, "career_system")
			local get_activated_ability_data = extension:get_activated_ability_data()
			local can_use_activated_ability = extension:can_use_activated_ability()

			can_use_activated_ability = not can_use_activated_ability and get_activated_ability_data.action_name == "action_career_wh_priest"

			return can_use_activated_ability
		end,
		enter_function = function (arg_2_0, arg_2_1)
			-- function 2
			local has_extension = ScriptUnit.has_extension(arg_2_0, "inventory_system")

			if not has_extension then
				has_extension:check_and_drop_pickups("career_ability")
			end
		end,
		allowed_chain_actions = {}
	}
}
