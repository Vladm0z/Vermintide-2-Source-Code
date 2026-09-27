-- chunkname: @scripts/settings/equipment/weapon_templates/bw_necromancer_career_skill.lua

local tbl = {
	actions = {
		action_career_hold = {
			default = {
				faster_breed_to_spawn = "pet_skeleton",
				breed_to_spawn = "pet_skeleton",
				weapon_action_hand = "left",
				kind = "career_bw_necromancer_raise_dead_targeting",
				hold_input = "action_career_hold",
				controlled_unit_template = "necromancer_pet_ability",
				uninterruptible = true,
				anim_event = "necro_ability_start",
				chain_condition_func = function (arg_1_0, arg_1_1)
					-- function 1
					return ScriptUnit.extension(arg_1_0, "career_system"):current_ability_cooldown() <= 0
				end,
				total_time = math.huge,
				radius = DLCSettings.shovel.buff_templates.raise_dead_ability.buffs[1].area_radius,
				allowed_chain_actions = {
					{
						sub_action = "spawn_summon_area",
						start_time = 0,
						action = "action_career_hold",
						input = "action_one"
					},
					{
						sub_action = "spawn_summon_area",
						start_time = 0,
						action = "action_career_hold",
						input = "action_career_release"
					},
					{
						sub_action = "spawn_summon_area",
						action = "action_career_hold",
						auto_chain = true,
						release_required = "action_career_hold",
						start_time = 0
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_wield",
						input = "action_wield"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two"
					}
				},
				enter_function = function (arg_2_0, arg_2_1)
					-- function 2
					arg_2_1:clear_input_buffer()

					return arg_2_1:reset_release_input()
				end
			},
			spawn_summon_area = {
				weapon_action_hand = "left",
				anim_event = "necro_ability_cast",
				uninterruptible = true,
				kind = "dummy",
				total_time = 0.51,
				allowed_chain_actions = {},
				enter_function = function (arg_3_0, arg_3_1)
					-- function 3
					arg_3_1:clear_input_buffer()

					return arg_3_1:reset_release_input()
				end,
				finish_function = function (arg_4_0, arg_4_1)
					-- function 4
					local extension = ScriptUnit.extension(arg_4_0, "input_system")

					extension:clear_input_buffer()
					extension:reset_release_input()
					ScriptUnit.extension(arg_4_0, "inventory_system"):wield_previous_non_level_slot()
				end
			}
		},
		action_two = {
			default = {
				kind = "career_dummy",
				weapon_action_hand = "left",
				anim_end_event = "ability_finished",
				anim_event = "necro_ability_cancel",
				total_time = 0.2,
				anim_end_event_condition_func = function (arg_5_0, arg_5_1)
					-- function 5
					return arg_5_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {}
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

return {
	bw_necromancer_career_skill_weapon = table.clone(tbl)
}
