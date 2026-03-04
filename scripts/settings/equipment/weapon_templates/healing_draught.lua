-- chunkname: @scripts/settings/equipment/weapon_templates/healing_draught.lua

local var_0_0 = {
	actions = {
		action_one = {
			default = {
				damage_window_end = 0.2,
				ammo_usage = 1,
				anim_end_event = "attack_finished",
				kind = "healing_draught",
				damage_window_start = 0.05,
				weapon_action_hand = "left",
				block_pickup = true,
				dialogue_event = "on_healing_draught",
				anim_event = "attack_heal",
				total_time = 1.2,
				allowed_chain_actions = {},
				condition_func = function (arg_1_0)
					local var_1_0 = ScriptUnit.extension(arg_1_0, "health_system")
					local var_1_1 = ScriptUnit.extension(arg_1_0, "status_system")
					local var_1_2 = var_1_0:current_permanent_health_percent() >= 1

					return var_1_1:is_wounded() or not var_1_2
				end,
				chain_condition_func = function (arg_2_0)
					local var_2_0 = ScriptUnit.extension(arg_2_0, "health_system")
					local var_2_1 = ScriptUnit.extension(arg_2_0, "status_system")
					local var_2_2 = var_2_0:current_permanent_health_percent() >= 1

					return var_2_1:is_wounded() or not var_2_2
				end
			}
		},
		action_two = {
			default = ActionTemplates.give_item_on_defend
		},
		action_inspect = ActionTemplates.action_inspect_left,
		action_wield = ActionTemplates.wield_left,
		action_instant_give_item = ActionTemplates.instant_give_item,
		action_instant_heal_self = {
			default = {
				kind = "dummy",
				weapon_action_hand = "left",
				total_time = 1,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_one",
						auto_chain = true
					}
				}
			}
		}
	},
	ammo_data = {
		ammo_hand = "left",
		destroy_when_out_of_ammo = true,
		max_ammo = 1,
		ammo_per_clip = 1,
		reload_time = 0
	},
	pickup_data = {
		pickup_name = "healing_draught"
	}
}

var_0_0.left_hand_unit = "units/weapons/player/wpn_potion/wpn_potion"
var_0_0.left_hand_attachment_node_linking = AttachmentNodeLinking.potion
var_0_0.wield_anim = "to_potion"
var_0_0.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_0.load_state_machine = false
var_0_0.gui_texture = "hud_consumable_icon_potion"
var_0_0.max_fatigue_points = 1
var_0_0.can_heal_self = true
var_0_0.fast_heal = true
var_0_0.can_give_other = true
var_0_0.bot_heal_threshold = 0.4
var_0_0.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}

return {
	healing_draught = table.clone(var_0_0)
}
