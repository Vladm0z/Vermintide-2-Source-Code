-- chunkname: @scripts/settings/action_templates.lua

require("scripts/settings/profiles/career_settings")

ActionTemplates = ActionTemplates or {}
ActionTemplates.wield = {
	default = {
		wield_cooldown = 0.35,
		weapon_action_hand = "either",
		kind = "wield",
		keep_buffer = true,
		action_priority = 2,
		uninterruptible = true,
		total_time = 0,
		condition_func = function(arg_1_0, arg_1_1)
			return ScriptUnit.extension(arg_1_0, "inventory_system"):can_wield()
		end,
		chain_condition_func = function(arg_2_0, arg_2_1)
			return ScriptUnit.extension(arg_2_0, "inventory_system"):can_wield()
		end,
		allowed_chain_actions = {}
	}
}
ActionTemplates.wield_left = table.clone(ActionTemplates.wield)
ActionTemplates.wield_left.default.weapon_action_hand = "left"
ActionTemplates.wield_and_use = {
	default = {
		ammo_usage = 1,
		slot_to_wield = "slot_level_event",
		weapon_action_hand = "either",
		kind = "instant_wield",
		uninterruptible = true,
		total_time = 0,
		condition_func = function(arg_3_0, arg_3_1)
			return ScriptUnit.extension(arg_3_0, "inventory_system"):can_wield()
		end,
		chain_condition_func = function(arg_4_0, arg_4_1)
			return ScriptUnit.extension(arg_4_0, "inventory_system"):can_wield()
		end,
		action_on_wield = {
			action = "action_one",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}
ActionTemplates.reload = {
	default = {
		weapon_action_hand = "either",
		kind = "reload",
		total_time = 0,
		condition_func = function(arg_5_0, arg_5_1)
			local var_5_0 = ScriptUnit.extension(arg_5_0, "inventory_system")
			local var_5_1 = ScriptUnit.extension(arg_5_0, "status_system")
			local var_5_2

			if var_5_1:is_zooming() then
				return false
			end

			local var_5_3 = var_5_0:equipment()

			if var_5_3.right_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_5_3.right_hand_wielded_unit, "ammo_system") then
				var_5_2 = ScriptUnit.extension(var_5_3.right_hand_wielded_unit, "ammo_system")
			elseif var_5_3.left_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_5_3.left_hand_wielded_unit, "ammo_system") then
				var_5_2 = ScriptUnit.extension(var_5_3.left_hand_wielded_unit, "ammo_system")
			end

			if not var_5_2 then
				return false
			end

			local var_5_4 = var_5_2:can_reload()
			local var_5_5 = var_5_2:is_reloading()

			return var_5_4 and not var_5_5
		end,
		chain_condition_func = function(arg_6_0, arg_6_1)
			local var_6_0 = ScriptUnit.extension(arg_6_0, "inventory_system")
			local var_6_1 = ScriptUnit.extension(arg_6_0, "status_system")
			local var_6_2

			if var_6_1:is_zooming() then
				return false
			end

			local var_6_3 = var_6_0:equipment()

			if var_6_3.right_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_6_3.right_hand_wielded_unit, "ammo_system") then
				var_6_2 = ScriptUnit.extension(var_6_3.right_hand_wielded_unit, "ammo_system")
			elseif var_6_3.left_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_6_3.left_hand_wielded_unit, "ammo_system") then
				var_6_2 = ScriptUnit.extension(var_6_3.left_hand_wielded_unit, "ammo_system")
			end

			if not var_6_2 then
				return false
			end

			local var_6_4 = var_6_2:can_reload()
			local var_6_5 = var_6_2:is_reloading()

			return var_6_4 and not var_6_5
		end,
		allowed_chain_actions = {}
	},
	auto_reload_on_empty = {
		weapon_action_hand = "either",
		kind = "reload",
		total_time = 0,
		condition_func = function(arg_7_0, arg_7_1)
			return false
		end,
		chain_condition_func = function(arg_8_0, arg_8_1)
			local var_8_0 = ScriptUnit.extension(arg_8_0, "inventory_system")
			local var_8_1 = ScriptUnit.extension(arg_8_0, "status_system")
			local var_8_2

			if var_8_1:is_zooming() then
				return false
			end

			local var_8_3 = var_8_0:equipment()

			if var_8_3.right_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_8_3.right_hand_wielded_unit, "ammo_system") then
				var_8_2 = ScriptUnit.extension(var_8_3.right_hand_wielded_unit, "ammo_system")
			elseif var_8_3.left_hand_wielded_unit ~= nil and ScriptUnit.has_extension(var_8_3.left_hand_wielded_unit, "ammo_system") then
				var_8_2 = ScriptUnit.extension(var_8_3.left_hand_wielded_unit, "ammo_system")
			end

			if not var_8_2 then
				return false
			end

			local var_8_4 = var_8_2:can_reload()
			local var_8_5 = var_8_2:is_reloading()
			local var_8_6 = var_8_2:ammo_count()

			return var_8_4 and var_8_6 == 0 and not var_8_5
		end,
		allowed_chain_actions = {}
	}
}
ActionTemplates.action_inspect = {
	default = {
		weapon_action_hand = "either",
		kind = "dummy",
		total_time = 1,
		condition_func = function(arg_9_0, arg_9_1, arg_9_2)
			if arg_9_2 and arg_9_2:is_reloading() then
				return false
			end

			if Managers.input:is_device_active("gamepad") then
				local var_9_0 = Managers.state.game_mode:level_key()

				if LevelSettings[var_9_0].hub_level and not MotionControlSettings.use_motion_controls then
					return true
				else
					return false
				end
			else
				return true
			end
		end,
		allowed_chain_actions = {
			{
				start_time = 0,
				end_time = 0,
				input = "action_inspect_hold"
			},
			{
				sub_action = "action_inspect_hold",
				start_time = 0,
				action = "action_inspect",
				auto_chain = true
			}
		}
	},
	action_inspect_hold = {
		cooldown = 0.15,
		minimum_hold_time = 0.3,
		anim_end_event = "inspect_end",
		kind = "dummy",
		can_abort_reload = false,
		weapon_action_hand = "either",
		hold_input = "action_inspect_hold",
		anim_event = "inspect_start",
		anim_end_event_condition_func = function(arg_10_0, arg_10_1)
			return arg_10_1 ~= "new_interupting_action"
		end,
		total_time = math.huge,
		allowed_chain_actions = {},
		weapon_sway_settings = {
			recentering_lerp_speed = 0,
			lerp_speed = 10,
			sway_range = 1,
			camera_look_sensitivity = 1,
			look_sensitivity = 1.5
		}
	}
}
ActionTemplates.action_inspect_left = table.clone(ActionTemplates.action_inspect)
ActionTemplates.action_inspect_left.default.weapon_action_hand = "left"
ActionTemplates.action_inspect_left.action_inspect_hold.weapon_action_hand = "left"
ActionTemplates.give_item_on_defend = {
	interaction_priority = 5,
	ammo_usage = 1,
	anim_end_event = "attack_finished",
	kind = "interaction",
	interaction_type = "give_item",
	weapon_action_hand = "left",
	uninterruptible = true,
	do_not_validate_with_hold = true,
	hold_input = "action_two_hold",
	anim_event = "parry_pose",
	total_time = 0,
	anim_end_event_condition_func = function(arg_11_0, arg_11_1)
		return arg_11_1 ~= "new_interupting_action" and arg_11_1 ~= "action_complete"
	end,
	allowed_chain_actions = {},
	condition_func = function(arg_12_0)
		if not Managers.player:owner(arg_12_0).bot_player and not Application.user_setting("give_on_defend") then
			return false
		end

		return ScriptUnit.extension(arg_12_0, "interactor_system"):can_interact(nil, "give_item")
	end
}
ActionTemplates.instant_give_item = {
	default = {
		kind = "dummy",
		weapon_action_hand = "left",
		total_time = 0,
		allowed_chain_actions = {}
	},
	instant_give = {
		interaction_priority = 4,
		ammo_usage = 1,
		anim_end_event = "attack_finished",
		kind = "interaction",
		interaction_type = "give_item",
		weapon_action_hand = "left",
		uninterruptible = true,
		hold_input = "interact",
		anim_event = "parry_pose",
		total_time = 0,
		anim_end_event_condition_func = function(arg_13_0, arg_13_1)
			return arg_13_1 ~= "new_interupting_action" and arg_13_1 ~= "action_complete"
		end,
		allowed_chain_actions = {},
		condition_func = function(arg_14_0)
			local var_14_0 = ScriptUnit.extension(arg_14_0, "interactor_system")

			return var_14_0 and var_14_0:can_interact(nil, "give_item")
		end
	}
}
ActionTemplates.career_skill_dummy = {
	default = {
		kind = "dummy",
		weapon_action_hand = "either",
		total_time = 0,
		allowed_chain_actions = {}
	}
}
ActionTemplates.action_career_bw_1 = {
	default = {
		slot_to_wield = "slot_career_skill_weapon",
		input_override = "action_career",
		weapon_action_hand = "either",
		kind = "instant_wield",
		total_time = 0,
		condition_func = function(arg_15_0, arg_15_1)
			if ScriptUnit.extension(arg_15_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local var_15_0 = ScriptUnit.extension(arg_15_0, "career_system")

			return var_15_0:get_activated_ability_data().action_name == "action_career_bw_1" and var_15_0:can_use_activated_ability()
		end,
		action_on_wield = {
			action = "action_career_hold",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}
ActionTemplates.action_career_dr_3 = {
	default = {
		slot_to_wield = "slot_career_skill_weapon",
		input_override = "action_career",
		weapon_action_hand = "either",
		kind = "instant_wield",
		total_time = 0,
		condition_func = function(arg_16_0, arg_16_1)
			if ScriptUnit.extension(arg_16_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local var_16_0 = ScriptUnit.extension(arg_16_0, "career_system")

			return var_16_0:get_activated_ability_data().action_name == "action_career_dr_3" and var_16_0:can_use_activated_ability()
		end,
		action_on_wield = {
			action = "action_career_hold",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}
ActionTemplates.action_career_wh_2 = {
	default = {
		slot_to_wield = "slot_career_skill_weapon",
		input_override = "action_career",
		weapon_action_hand = "either",
		kind = "instant_wield",
		total_time = 0,
		condition_func = function(arg_17_0, arg_17_1)
			if ScriptUnit.extension(arg_17_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local var_17_0 = ScriptUnit.extension(arg_17_0, "career_system")

			return var_17_0:get_activated_ability_data().action_name == "action_career_wh_2" and var_17_0:can_use_activated_ability()
		end,
		action_on_wield = {
			action = "action_career_hold",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}
ActionTemplates.action_career_we_3 = {
	default = {
		slot_to_wield = "slot_career_skill_weapon",
		input_override = "action_career",
		weapon_action_hand = "either",
		kind = "instant_wield",
		total_time = 0,
		condition_func = function(arg_18_0, arg_18_1)
			if not ScriptUnit.extension(arg_18_0, "inventory_system"):get_slot_data("slot_career_skill_weapon") then
				return false
			end

			if ScriptUnit.extension(arg_18_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local var_18_0 = ScriptUnit.extension(arg_18_0, "career_system")
			local var_18_1 = var_18_0:get_activated_ability_data(1)

			if not var_18_1 then
				return false
			end

			local var_18_2 = ScriptUnit.has_extension(arg_18_0, "talent_system"):has_talent("kerillian_waywatcher_activated_ability_piercing_shot")
			local var_18_3 = var_18_0:can_use_activated_ability(1)

			return var_18_1.action_name == "action_career_we_3" and var_18_3 and not var_18_2
		end,
		action_on_wield = {
			action = "action_career_hold",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}
ActionTemplates.action_career_we_3_piercing = {
	default = {
		slot_to_wield = "slot_career_skill_weapon",
		input_override = "action_career",
		weapon_action_hand = "either",
		kind = "instant_wield",
		total_time = 0,
		condition_func = function(arg_19_0, arg_19_1)
			if not ScriptUnit.extension(arg_19_0, "inventory_system"):get_slot_data("slot_career_skill_weapon") then
				return false
			end

			if ScriptUnit.extension(arg_19_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local var_19_0 = ScriptUnit.extension(arg_19_0, "career_system")
			local var_19_1 = var_19_0:get_activated_ability_data(2)

			if not var_19_1 then
				return false
			end

			local var_19_2 = ScriptUnit.has_extension(arg_19_0, "talent_system"):has_talent("kerillian_waywatcher_activated_ability_piercing_shot")
			local var_19_3 = var_19_0:can_use_activated_ability(1)

			return var_19_1.action_name == "action_career_we_3_piercing" and var_19_3 and var_19_2
		end,
		action_on_wield = {
			action = "action_career_hold",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}

DLCUtils.require_list("action_template_files")

for iter_0_0, iter_0_1 in pairs(CareerActionNames) do
	for iter_0_2 = 1, #iter_0_1 do
		local var_0_0 = iter_0_1[iter_0_2]
		local var_0_1 = ActionTemplates[var_0_0].default

		var_0_1.chain_condition_func = var_0_1.condition_func
	end
end
