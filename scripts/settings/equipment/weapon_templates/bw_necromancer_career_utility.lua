-- chunkname: @scripts/settings/equipment/weapon_templates/bw_necromancer_career_utility.lua

local function fn(arg_1_0)
	-- function 1
	return ScriptUnit.extension(arg_1_0, "ai_commander_system"):get_controlled_units_count() > 0
end

local function fn_2(arg_2_0)
	-- function 2
	return fn(arg_2_0)
end

local function fn_3(arg_3_0)
	-- function 3
	if not fn(arg_3_0) then
		return false
	end

	if not ActionCareerBWNecromancerCommandAttack.pre_calculate_target(arg_3_0) then
		return false
	end

	return true
end

local function fn_4(arg_4_0, arg_4_1)
	-- function 4
	if not fn(arg_4_0) then
		return false
	end

	local extension = ScriptUnit.extension(arg_4_0, "ai_commander_system")
	local flag = false

	for k in pairs(extension:get_controlled_units()) do
		if not HEALTH_ALIVE[k] then
			flag = true

			break
		end
	end

	if not flag then
		return false
	end

	local has_extension = ScriptUnit.has_extension(arg_4_0, "talent_system")

	if not has_extension and not has_extension:has_talent("sienna_necromancer_4_1") then
		return true
	end

	return true
end

local tbl = {
	actions = {
		action_one = {
			default = {
				kind = "career_bw_necromancer_command_attack",
				weapon_action_hand = "left",
				anim_event = "pet_control_target_command",
				total_time = 0.2,
				chain_condition_func = fn_3,
				condition_func = fn_3,
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
				enter_function = function (arg_5_0, arg_5_1)
					-- function 5
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
						condition = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
							-- function 6
							return fn_2(arg_6_3)
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
				anim_end_event_condition_func = function (arg_7_0, arg_7_1)
					-- function 7
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
				enter_function = function (arg_8_0, arg_8_1)
					-- function 8
					local extension = ScriptUnit.extension(arg_8_0, "ai_commander_system")
					local get_controlled_units = extension:get_controlled_units()

					for k in pairs(get_controlled_units) do
						if not HEALTH_ALIVE[k] then
							extension:cancel_current_command(k, true)
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
				enter_function = function (arg_9_0, arg_9_1)
					-- function 9
					local extension = ScriptUnit.extension(arg_9_0, "ai_commander_system")
					local get_controlled_units = extension:get_controlled_units()

					for k in pairs(get_controlled_units) do
						if not HEALTH_ALIVE[k] then
							extension:cancel_current_command(k)
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
				condition_func = fn_4,
				chain_condition_func = fn_4,
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

tbl.left_hand_unit = "units/weapons/player/wpn_bw_necromancer_ability/wpn_bw_necromancer_ability"
tbl.left_hand_attachment_node_linking = AttachmentNodeLinking.one_handed_melee_weapon.left
tbl.wield_anim = "to_necro_command_item"
tbl.state_machine = "units/beings/player/first_person_base/state_machines/career/skill_necromancer"
tbl.load_state_machine = false
tbl.display_unit = "units/weapons/weapon_display/display_staff"
tbl.crosshair_style = "default"
tbl.buff_type = "RANGED_ABILITY"
tbl.weapon_type = "RANGED_ABILITY"
tbl.dodge_count = 2
tbl.buffs = {
	change_dodge_distance = {
		external_optional_multiplier = 1
	},
	change_dodge_speed = {
		external_optional_multiplier = 1
	}
}
tbl.is_command_utility_weapon = true

return {
	bw_necromancer_career_utility_weapon = table.clone(tbl)
}
