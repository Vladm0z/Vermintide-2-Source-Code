-- chunkname: @scripts/settings/equipment/weapon_templates/bw_necromancer_career_utility.lua

local function var_0_0(arg_1_0)
	return ScriptUnit.extension(arg_1_0, "ai_commander_system"):get_controlled_units_count() > 0
end

local function var_0_1(arg_2_0)
	return var_0_0(arg_2_0)
end

local function var_0_2(arg_3_0)
	if not var_0_0(arg_3_0) then
		return false
	end

	if not ActionCareerBWNecromancerCommandAttack.pre_calculate_target(arg_3_0) then
		return false
	end

	return true
end

local function var_0_3(arg_4_0, arg_4_1)
	if not var_0_0(arg_4_0) then
		return false
	end

	local var_4_0 = ScriptUnit.extension(arg_4_0, "ai_commander_system")
	local var_4_1 = false

	for iter_4_0 in pairs(var_4_0:get_controlled_units()) do
		if HEALTH_ALIVE[iter_4_0] then
			var_4_1 = true

			break
		end
	end

	if not var_4_1 then
		return false
	end

	local var_4_2 = ScriptUnit.has_extension(arg_4_0, "talent_system")

	if var_4_2 and var_4_2:has_talent("sienna_necromancer_4_1") then
		return true
	end

	return true
end

local var_0_4 = {
	actions = {
		action_one = {
			default = {
				kind = "career_bw_necromancer_command_attack",
				weapon_action_hand = "left",
				anim_event = "pet_control_target_command",
				total_time = 0.2,
				chain_condition_func = var_0_2,
				condition_func = var_0_2,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				}
			},
			cast_stand = {
				anim_event = "pet_control_target_command",
				weapon_action_hand = "left",
				kind = "career_bw_necromancer_command_stand",
				total_time = 1,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.3,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.3,
						action = "action_three",
						input = "action_three"
					},
					{
						sub_action = "default",
						start_time = 0.5,
						action = "action_two",
						release_required = "action_two_hold",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				enter_function = function(arg_5_0, arg_5_1)
					arg_5_1:clear_input_buffer()

					return arg_5_1:reset_release_input()
				end
			}
		},
		action_two = {
			default = {
				kind = "action_selector",
				weapon_action_hand = "left",
				conditional_actions = {
					{
						sub_action = "command_stand",
						release_required = "action_two_hold",
						condition = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
							return var_0_1(arg_6_3)
						end
					}
				},
				default_action = {
					action = "action_two",
					sub_action = "dummy"
				}
			},
			command_stand = {
				weapon_action_hand = "left",
				anim_end_event = "pet_control_cancel",
				kind = "career_bw_necromancer_command_stand_targeting",
				hold_input = "action_two_hold",
				anim_event = "pet_control_target",
				minimum_hold_time = 0.3,
				anim_end_event_condition_func = function(arg_7_0, arg_7_1)
					return arg_7_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "cast_stand",
						start_time = 0.2,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_three",
						input = "action_three"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				enter_function = function(arg_8_0, arg_8_1)
					local var_8_0 = ScriptUnit.extension(arg_8_0, "ai_commander_system")
					local var_8_1 = var_8_0:get_controlled_units()

					for iter_8_0 in pairs(var_8_1) do
						if HEALTH_ALIVE[iter_8_0] then
							var_8_0:cancel_current_command(iter_8_0, true)
						end
					end
				end
			},
			dummy = {
				kind = "dummy",
				weapon_action_hand = "left",
				total_time = 0,
				allowed_chain_actions = {}
			}
		},
		action_three = {
			default = {
				anim_event = "pet_control_target_command_return",
				weapon_action_hand = "left",
				anim_event_3p = "pet_control_target_command",
				kind = "dummy",
				total_time = 0.7,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "action_two",
						release_required = "action_two_hold",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0.2,
						action = "weapon_reload",
						input = "weapon_reload"
					}
				},
				enter_function = function(arg_9_0, arg_9_1)
					local var_9_0 = ScriptUnit.extension(arg_9_0, "ai_commander_system")
					local var_9_1 = var_9_0:get_controlled_units()

					for iter_9_0 in pairs(var_9_1) do
						if HEALTH_ALIVE[iter_9_0] then
							var_9_0:cancel_current_command(iter_9_0)
						end
					end

					arg_9_1:clear_input_buffer()

					return arg_9_1:reset_release_input()
				end
			}
		},
		weapon_reload = {
			default = {
				anim_event = "pet_control_sacrifice",
				weapon_action_hand = "left",
				kind = "career_bw_necromancer_command_vent",
				total_time = 1,
				condition_func = var_0_3,
				chain_condition_func = var_0_3,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.9,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0.9,
						action = "action_two",
						input = "action_two_hold"
					},
					{
						sub_action = "default",
						start_time = 0.9,
						action = "action_one",
						input = "action_one"
					},
					{
						sub_action = "default",
						start_time = 0.9,
						action = "action_three",
						input = "action_three"
					}
				}
			}
		},
		action_inspect = ActionTemplates.action_inspect_left,
		action_wield = ActionTemplates.wield_left
	}
}

var_0_4.left_hand_unit = "units/weapons/player/wpn_bw_necromancer_ability/wpn_bw_necromancer_ability"
var_0_4.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
var_0_4.wield_anim = "to_necro_command_item"
var_0_4.state_machine = "units/beings/player/first_person_base/state_machines/career/skill_necromancer"
var_0_4.load_state_machine = false
var_0_4.display_unit = "units/weapons/weapon_display/display_staff"
var_0_4.crosshair_style = "default"
var_0_4.buff_type = "RANGED_ABILITY"
var_0_4.weapon_type = "RANGED_ABILITY"
var_0_4.dodge_count = 2
var_0_4.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}
var_0_4.is_command_utility_weapon = true

return {
	bw_necromancer_career_utility_weapon = table.clone(var_0_4)
}
