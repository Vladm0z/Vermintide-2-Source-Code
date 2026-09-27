-- chunkname: @scripts/settings/equipment/weapon_templates/wh_priest_career_skill.lua

local tbl = {
	actions = {
		action_career_hold = {
			default = {
				max_range = 20,
				aim_time = 0,
				target_other_anim_event = "bless_target_other",
				anim_end_event = "ability_finished",
				kind = "career_wh_priest_target",
				target_self_anim_event = "bless_target_self",
				uninterruptible = true,
				target_sticky_time = 0.2,
				target_cone_angle = 50,
				hold_input = "action_career_hold",
				anim_event = "bless_start",
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					-- function 1
					return arg_1_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "target_other_check",
						input = "action_one"
					},
					{
						sub_action = "self_target",
						start_time = 0,
						action = "spells",
						input = "action_career_release"
					},
					{
						sub_action = "self_target",
						start_time = 0,
						action = "spells",
						input = "action_career_not_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_fake_inspect",
						input = "action_inspect_hold"
					}
				}
			},
			re_chain = {
				max_range = 20,
				anim_end_event = "ability_finished",
				aim_time = 0,
				target_other_anim_event = "bless_target_other",
				kind = "career_wh_priest_target",
				target_self_anim_event = "bless_target_self",
				hold_input = "action_career_hold",
				target_sticky_time = 0.2,
				target_cone_angle = 50,
				uninterruptible = true,
				anim_end_event_condition_func = function (arg_2_0, arg_2_1)
					-- function 2
					return arg_2_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "action_two"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_two",
						input = "weapon_reload"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "target_other_check",
						input = "action_one"
					},
					{
						sub_action = "self_target",
						start_time = 0,
						action = "spells",
						input = "action_career_release"
					},
					{
						sub_action = "self_target",
						start_time = 0,
						action = "spells",
						input = "action_career_not_hold"
					},
					{
						sub_action = "default",
						start_time = 0,
						action = "action_fake_inspect",
						input = "action_inspect_hold"
					}
				}
			}
		},
		spells = {
			self_target = {
				anim_end_event = "ability_finished",
				kind = "career_wh_priest",
				target_self = true,
				uninterruptible = true,
				anim_event = "bless_self",
				total_time = 0.9,
				anim_end_event_condition_func = function (arg_3_0, arg_3_1)
					-- function 3
					return arg_3_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {}
			},
			other_target = {
				anim_end_event = "ability_finished",
				kind = "career_wh_priest",
				uninterruptible = true,
				anim_event = "bless_other",
				total_time = 0.9,
				anim_end_event_condition_func = function (arg_4_0, arg_4_1)
					-- function 4
					return arg_4_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {}
			}
		},
		action_career_release = {
			default = {
				kind = "action_selector",
				conditional_actions = {
					{
						sub_action = "other_target",
						action = "spells",
						condition = function (arg_5_0, arg_5_1, arg_5_2)
							-- function 5
							return not arg_5_2 and arg_5_2:get_mode()
						end
					}
				},
				default_action = {
					action = "spells",
					sub_action = "self_target"
				}
			}
		},
		target_other_check = {
			default = {
				kind = "action_selector",
				conditional_actions = {
					{
						sub_action = "other_target",
						action = "spells",
						condition = function (arg_6_0, arg_6_1, arg_6_2)
							-- function 6
							return not arg_6_2 and arg_6_2:get_mode()
						end
					}
				},
				default_action = {
					action = "action_career_hold",
					sub_action = "re_chain"
				}
			}
		},
		action_two = {
			default = {
				kind = "career_dummy",
				anim_end_event = "ability_finished",
				anim_event = "bless_cancel",
				total_time = 0.5,
				anim_end_event_condition_func = function (arg_7_0, arg_7_1)
					-- function 7
					return arg_7_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {}
			}
		},
		action_fake_inspect = {
			default = {
				anim_end_event = "inspect_end",
				minimum_hold_time = 0.3,
				weapon_action_hand = "either",
				kind = "dummy",
				can_abort_reload = false,
				hold_input = "action_inspect_hold",
				anim_event = "inspect_start",
				anim_end_event_condition_func = function (arg_8_0, arg_8_1)
					-- function 8
					return arg_8_1 ~= "new_interupting_action"
				end,
				total_time = math.huge,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0,
						action = "action_fake_inspect_end",
						input = "action_inspect_release"
					}
				},
				finish_function = function (arg_9_0, arg_9_1)
					-- function 9
					local has_extension = ScriptUnit.has_extension(arg_9_0, "first_person_system")

					if not has_extension then
						has_extension:play_hud_sound_event("priest_book_loop_stop")
					end

					if arg_9_1 ~= "new_interupting_action" then
						local extension = ScriptUnit.extension(arg_9_0, "inventory_system")

						if not extension then
							extension:wield_previous_non_level_slot()
						end
					end
				end,
				weapon_sway_settings = {
					recentering_lerp_speed = 0,
					lerp_speed = 10,
					sway_range = 1,
					camera_look_sensitivity = 1,
					look_sensitivity = 1.5
				}
			}
		},
		action_fake_inspect_end = {
			default = {
				kind = "career_dummy",
				anim_end_event = "ability_finished",
				anim_event = "inspect_end",
				total_time = 0.7,
				anim_end_event_condition_func = function (arg_10_0, arg_10_1)
					-- function 10
					return arg_10_1 ~= "new_interupting_action"
				end,
				allowed_chain_actions = {}
			}
		},
		action_wield = ActionTemplates.wield
	}
}

tbl.right_hand_unit = "units/weapons/player/wpn_wh_book_01/wpn_wh_book_01"
tbl.right_hand_attachment_node_linking = AttachmentNodeLinking.book.left
tbl.wield_anim = "bless_start"
tbl.state_machine = "units/beings/player/first_person_base/state_machines/career/skill_priest"
tbl.load_state_machine = false
tbl.display_unit = "units/weapons/weapon_display/display_2h_swords_executioner"
tbl.crosshair_style = "wh_priest"
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
tbl.particle_fx = {}
tbl.particle_fx_lookup = table.mirror_array_inplace(table.keys(tbl.particle_fx))

return {
	wh_priest_career_skill_weapon = table.clone(tbl)
}
