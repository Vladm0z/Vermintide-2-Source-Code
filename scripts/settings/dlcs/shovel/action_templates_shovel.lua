-- chunkname: @scripts/settings/dlcs/shovel/action_templates_shovel.lua

ActionTemplates.action_career_bw_necromancer = {
	default = {
		slot_to_wield = "slot_career_skill_weapon",
		weapon_action_hand = "either",
		kind = "instant_wield",
		input_override = "action_career",
		total_time = 0,
		condition_func = function (arg_1_0, arg_1_1)
			-- function 1
			if not ScriptUnit.extension(arg_1_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			if not ScriptUnit.extension(arg_1_0, "inventory_system"):can_wield() then
				return false
			end

			local extension = ScriptUnit.extension(arg_1_0, "career_system")
			local get_passive_ability_by_name = extension:get_passive_ability_by_name("bw_necromancer")

			if not (not get_passive_ability_by_name and get_passive_ability_by_name:is_ready()) then
				return false
			end

			local get_activated_ability_data = extension:get_activated_ability_data()
			local can_use_activated_ability = extension:can_use_activated_ability()

			can_use_activated_ability = not can_use_activated_ability and get_activated_ability_data.action_name == "action_career_bw_necromancer"

			return can_use_activated_ability
		end,
		enter_function = function (arg_2_0, arg_2_1)
			-- function 2
			local has_extension = ScriptUnit.has_extension(arg_2_0, "inventory_system")

			if not has_extension then
				has_extension:check_and_drop_pickups("career_ability")
			end
		end,
		action_on_wield = {
			action = "action_career_hold",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}
