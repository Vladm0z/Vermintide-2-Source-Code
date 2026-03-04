-- chunkname: @scripts/settings/equipment/weapon_templates/first_aid_kits.lua

local var_0_0 = 2
local var_0_1 = {
	actions = {
		action_one = {
			default = {
				damage_window_end = 0.35,
				anim_event = "interaction_bandage_self",
				ammo_usage = 1,
				kind = "self_interaction",
				interaction_type = "heal",
				damage_window_start = 0.1,
				weapon_action_hand = "left",
				uninterruptible = true,
				hold_input = "action_one_hold",
				interaction_priority = 4,
				total_time = InteractionDefinitions.heal.config.duration,
				allowed_chain_actions = {},
				condition_func = function (arg_1_0)
					return (ScriptUnit.extension(arg_1_0, "interactor_system"):can_interact(arg_1_0, "heal"))
				end
			}
		},
		action_two = {
			default = {
				damage_window_end = 0.35,
				anim_event = "interaction_bandage_team",
				ammo_usage = 1,
				kind = "interaction",
				interaction_type = "heal",
				damage_window_start = 0.1,
				weapon_action_hand = "left",
				uninterruptible = true,
				hold_input = "action_two_hold",
				interaction_priority = 5,
				total_time = InteractionDefinitions.heal.config.duration,
				allowed_chain_actions = {},
				condition_func = function (arg_2_0)
					local var_2_0 = ScriptUnit.extension(arg_2_0, "interactor_system")

					return var_2_0 and var_2_0:can_interact(nil, "heal")
				end
			}
		},
		action_inspect = ActionTemplates.action_inspect_left,
		action_wield = ActionTemplates.wield_left
	},
	ammo_data = {
		ammo_hand = "left",
		destroy_when_out_of_ammo = true,
		max_ammo = 1,
		ammo_per_clip = 1,
		reload_time = 0,
		ignore_ammo_pickup = true
	},
	pickup_data = {
		pickup_name = "first_aid_kit"
	}
}

var_0_1.left_hand_unit = "units/weapons/player/wpn_first_aid_kit/wpn_first_aid_kit"
var_0_1.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
var_0_1.wield_anim = "to_first_aid"
var_0_1.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_1.load_state_machine = false
var_0_1.gui_texture = "hud_teammate_consumable_icon_medkit"
var_0_1.can_heal_other = true
var_0_1.can_heal_self = true
var_0_1.bot_heal_threshold = 0.2
var_0_1.fast_heal = false
var_0_1.max_fatigue_points = 1
var_0_1.dodge_count = 3
var_0_1.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1.2
	},
	change_dodge_speed = {
		external_optional_multiplier = 1.2
	}
}

local var_0_2 = table.clone(var_0_1)

var_0_2.left_hand_unit = "units/weapons/player/wpn_first_aid_kit/wpn_first_aid_kit"
var_0_2.gui_texture = "hud_teammate_consumable_icon_medkit"

local var_0_3 = table.clone(var_0_1)

var_0_3.left_hand_unit = "units/weapons/player/wpn_first_aid_kit_02/wpn_first_aid_kit_02"
var_0_3.gui_texture = "hud_teammate_consumable_icon_medkit"

return {
	healthkit = table.clone(var_0_1),
	first_aid_kit = var_0_2,
	first_aid_kit_02 = var_0_3
}
