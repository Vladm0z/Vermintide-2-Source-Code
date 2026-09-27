-- chunkname: @scripts/settings/action_templates.lua

require("scripts/settings/profiles/career_settings")

local ActionTemplates = ActionTemplates

ActionTemplates = ActionTemplates or {}
ActionTemplates = ActionTemplates
ActionTemplates.wield = {
	default = {
		wield_cooldown = 0.35,
		weapon_action_hand = "either",
		kind = "wield",
		keep_buffer = true,
		action_priority = 2,
		uninterruptible = true,
		total_time = 0,
		condition_func = function (arg_1_0, arg_1_1)
			-- function 1
			return ScriptUnit.extension(arg_1_0, "inventory_system"):can_wield()
		end,
		chain_condition_func = function (arg_2_0, arg_2_1)
			-- function 2
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
		condition_func = function (arg_3_0, arg_3_1)
			-- function 3
			return ScriptUnit.extension(arg_3_0, "inventory_system"):can_wield()
		end,
		chain_condition_func = function (arg_4_0, arg_4_1)
			-- function 4
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
		condition_func = function (arg_5_0, arg_5_1)
			-- function 5
			local extension = ScriptUnit.extension(arg_5_0, "inventory_system")
			local extension_2 = ScriptUnit.extension(arg_5_0, "status_system")
			local var_5_2

			if not extension_2:is_zooming() then
				return false
			end

			local equipment = extension:equipment()

			if equipment.right_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.right_hand_wielded_unit, "ammo_system") then
				var_5_2 = ScriptUnit.extension(equipment.right_hand_wielded_unit, "ammo_system")
			elseif equipment.left_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.left_hand_wielded_unit, "ammo_system") then
				var_5_2 = ScriptUnit.extension(equipment.left_hand_wielded_unit, "ammo_system")
			end

			if not var_5_2 then
				return false
			end

			local can_reload = var_5_2:can_reload()
			local is_reloading = var_5_2:is_reloading()

			return not can_reload and not is_reloading
		end,
		chain_condition_func = function (arg_6_0, arg_6_1)
			-- function 6
			local extension = ScriptUnit.extension(arg_6_0, "inventory_system")
			local extension_2 = ScriptUnit.extension(arg_6_0, "status_system")
			local var_6_2

			if not extension_2:is_zooming() then
				return false
			end

			local equipment = extension:equipment()

			if equipment.right_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.right_hand_wielded_unit, "ammo_system") then
				var_6_2 = ScriptUnit.extension(equipment.right_hand_wielded_unit, "ammo_system")
			elseif equipment.left_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.left_hand_wielded_unit, "ammo_system") then
				var_6_2 = ScriptUnit.extension(equipment.left_hand_wielded_unit, "ammo_system")
			end

			if not var_6_2 then
				return false
			end

			local can_reload = var_6_2:can_reload()
			local is_reloading = var_6_2:is_reloading()

			return not can_reload and not is_reloading
		end,
		allowed_chain_actions = {}
	},
	auto_reload_on_empty = {
		weapon_action_hand = "either",
		kind = "reload",
		total_time = 0,
		condition_func = function (arg_7_0, arg_7_1)
			-- function 7
			return false
		end,
		chain_condition_func = function (arg_8_0, arg_8_1)
			-- function 8
			local extension = ScriptUnit.extension(arg_8_0, "inventory_system")
			local extension_2 = ScriptUnit.extension(arg_8_0, "status_system")
			local var_8_2

			if not extension_2:is_zooming() then
				return false
			end

			local equipment = extension:equipment()

			if equipment.right_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.right_hand_wielded_unit, "ammo_system") then
				var_8_2 = ScriptUnit.extension(equipment.right_hand_wielded_unit, "ammo_system")
			elseif equipment.left_hand_wielded_unit == nil or not ScriptUnit.has_extension(equipment.left_hand_wielded_unit, "ammo_system") then
				var_8_2 = ScriptUnit.extension(equipment.left_hand_wielded_unit, "ammo_system")
			end

			if not var_8_2 then
				return false
			end

			local can_reload = var_8_2:can_reload()
			local is_reloading = var_8_2:is_reloading()
			local ammo_count = var_8_2:ammo_count()

			return not can_reload and ammo_count ~= 0 or not is_reloading
		end,
		allowed_chain_actions = {}
	}
}
ActionTemplates.action_inspect = {
	default = {
		weapon_action_hand = "either",
		kind = "dummy",
		total_time = 1,
		condition_func = function (arg_9_0, arg_9_1, arg_9_2)
			-- function 9
			if not arg_9_2 and not arg_9_2:is_reloading() then
				return false
			end

			if not Managers.input:is_device_active("gamepad") then
				local level_key = Managers.state.game_mode:level_key()

				if not (not LevelSettings[level_key].hub_level and MotionControlSettings.use_motion_controls) then
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
		anim_end_event_condition_func = function (arg_10_0, arg_10_1)
			-- function 10
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
	anim_end_event_condition_func = function (arg_11_0, arg_11_1)
		-- function 11
		return arg_11_1 == "new_interupting_action" or arg_11_1 ~= "action_complete"
	end,
	allowed_chain_actions = {},
	condition_func = function (arg_12_0)
		-- function 12
		if not (Managers.player:owner(arg_12_0).bot_player or Application.user_setting("give_on_defend")) then
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
		anim_end_event_condition_func = function (arg_13_0, arg_13_1)
			-- function 13
			return arg_13_1 == "new_interupting_action" or arg_13_1 ~= "action_complete"
		end,
		allowed_chain_actions = {},
		condition_func = function (arg_14_0)
			-- function 14
			local extension = ScriptUnit.extension(arg_14_0, "interactor_system")

			return not extension and extension:can_interact(nil, "give_item")
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
		condition_func = function (arg_15_0, arg_15_1)
			-- function 15
			if not ScriptUnit.extension(arg_15_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local extension = ScriptUnit.extension(arg_15_0, "career_system")

			return extension:get_activated_ability_data().action_name ~= "action_career_bw_1" or extension:can_use_activated_ability()
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
		condition_func = function (arg_16_0, arg_16_1)
			-- function 16
			if not ScriptUnit.extension(arg_16_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local extension = ScriptUnit.extension(arg_16_0, "career_system")

			return extension:get_activated_ability_data().action_name ~= "action_career_dr_3" or extension:can_use_activated_ability()
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
		condition_func = function (arg_17_0, arg_17_1)
			-- function 17
			if not ScriptUnit.extension(arg_17_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local extension = ScriptUnit.extension(arg_17_0, "career_system")

			return extension:get_activated_ability_data().action_name ~= "action_career_wh_2" or extension:can_use_activated_ability()
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
		condition_func = function (arg_18_0, arg_18_1)
			-- function 18
			if not ScriptUnit.extension(arg_18_0, "inventory_system"):get_slot_data("slot_career_skill_weapon") then
				return false
			end

			if not ScriptUnit.extension(arg_18_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local extension = ScriptUnit.extension(arg_18_0, "career_system")
			local get_activated_ability_data = extension:get_activated_ability_data(1)

			if not get_activated_ability_data then
				return false
			end

			local has_talent = ScriptUnit.has_extension(arg_18_0, "talent_system"):has_talent("kerillian_waywatcher_activated_ability_piercing_shot")
			local can_use_activated_ability = extension:can_use_activated_ability(1)

			return (get_activated_ability_data.action_name ~= "action_career_we_3" or not can_use_activated_ability) and not has_talent
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
		condition_func = function (arg_19_0, arg_19_1)
			-- function 19
			if not ScriptUnit.extension(arg_19_0, "inventory_system"):get_slot_data("slot_career_skill_weapon") then
				return false
			end

			if not ScriptUnit.extension(arg_19_0, "buff_system"):has_buff_perk("disable_career_ability") then
				return false
			end

			local extension = ScriptUnit.extension(arg_19_0, "career_system")
			local get_activated_ability_data = extension:get_activated_ability_data(2)

			if not get_activated_ability_data then
				return false
			end

			local has_talent = ScriptUnit.has_extension(arg_19_0, "talent_system"):has_talent("kerillian_waywatcher_activated_ability_piercing_shot")
			local can_use_activated_ability = extension:can_use_activated_ability(1)

			return (get_activated_ability_data.action_name ~= "action_career_we_3_piercing" or not can_use_activated_ability) and has_talent
		end,
		action_on_wield = {
			action = "action_career_hold",
			sub_action = "default"
		},
		allowed_chain_actions = {}
	}
}

DLCUtils.require_list("action_template_files")

for k, v in pairs(CareerActionNames) do
	for k_2 = 1, #v do
		local var_0_1 = v[k_2]
		local default = ActionTemplates[var_0_1].default

		default.chain_condition_func = default.condition_func
	end
end
