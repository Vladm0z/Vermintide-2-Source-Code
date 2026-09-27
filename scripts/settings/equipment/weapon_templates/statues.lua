-- chunkname: @scripts/settings/equipment/weapon_templates/statues.lua

local num = 2
local tbl = {
	actions = {
		action_one = {
			default = {
				uppety = 0,
				anim_time_scale = 0.8,
				kind = "throw",
				is_statue_and_needs_rotation_cause_reasons = true,
				throw_time = 0.43749999999999994,
				ammo_usage = 1,
				weapon_action_hand = "left",
				block_pickup = true,
				speed = 2,
				uninterruptible = true,
				anim_event = "attack_throw",
				total_time = 0.7249999999999999,
				anim_end_event_condition_func = function (arg_1_0, arg_1_1)
					-- function 1
					return arg_1_1 == "new_interupting_action" or arg_1_1 ~= "action_complete"
				end,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.5,
						end_time = 0.35,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				allowed_chain_actions = {},
				angular_velocity = {
					-1.85,
					-0.25,
					0
				},
				throw_offset = {
					0.39,
					1.15,
					-0.57
				},
				projectile_info = {
					projectile_unit_template_name = "pickup_projectile_unit",
					collision_filter = "n/a",
					drop_on_player_destroyed = true,
					use_dynamic_collision = false
				}
			}
		},
		action_two = {
			default = {
				damage_window_start = 0.05,
				outer_push_angle = 180,
				kind = "push_stagger",
				damage_profile_outer = "light_push",
				attack_template = "basic_sweep_push",
				push_angle = 100,
				hit_effect = "melee_hit_slashing",
				damage_window_end = 0.2,
				charge_value = "action_push",
				weapon_action_hand = "left",
				anim_event = "attack_push",
				damage_profile_inner = "medium_push",
				total_time = 0.8,
				anim_end_event_condition_func = function (arg_2_0, arg_2_1)
					-- function 2
					return arg_2_1 == "new_interupting_action" or arg_2_1 ~= "action_complete"
				end,
				allowed_chain_actions = {
					{
						sub_action = "default",
						start_time = 0.4,
						action = "action_one",
						end_time = 0.7,
						input = "action_one"
					}
				},
				push_radius = num,
				condition_func = function (arg_3_0, arg_3_1)
					-- function 3
					return not ScriptUnit.extension(arg_3_0, "status_system"):fatigued()
				end
			}
		},
		action_dropped = {
			default = {
				uppety = 0,
				anim_time_scale = 0.8,
				kind = "throw",
				is_statue_and_needs_rotation_cause_reasons = true,
				throw_time = 0.43749999999999994,
				ammo_usage = 1,
				weapon_action_hand = "left",
				block_pickup = true,
				speed = 2,
				uninterruptible = true,
				anim_event = "attack_throw",
				total_time = 0.7249999999999999,
				anim_end_event_condition_func = function (arg_4_0, arg_4_1)
					-- function 4
					return arg_4_1 == "new_interupting_action" or arg_4_1 ~= "action_complete"
				end,
				buff_data = {
					{
						start_time = 0,
						external_multiplier = 0.5,
						end_time = 0.35,
						buff_name = "planted_fast_decrease_movement"
					}
				},
				allowed_chain_actions = {},
				angular_velocity = {
					-1.85,
					-0.25,
					0
				},
				throw_offset = {
					0.39,
					1.15,
					-0.57
				},
				projectile_info = {
					projectile_unit_template_name = "pickup_projectile_unit",
					collision_filter = "n/a",
					drop_on_player_destroyed = true,
					use_dynamic_collision = false
				}
			}
		},
		action_wield = ActionTemplates.wield_left
	},
	ammo_data = {
		ammo_hand = "left",
		destroy_when_out_of_ammo = true,
		max_ammo = 1,
		ammo_per_clip = 1,
		reload_time = 0
	},
	pickup_data = {}
}

tbl.left_hand_unit = nil
tbl.left_hand_attachment_node_linking = AttachmentNodeLinking.barrel
tbl.wield_anim_3p = "to_statue"
tbl.wield_anim = "to_statue"
tbl.state_machine = "units/beings/player/first_person_base/state_machines/common"
tbl.load_state_machine = false
tbl.block_wielding = true
tbl.max_fatigue_points = 1
tbl.dodge_count = 1
tbl.buffs = {
	statue_decrease_movement = {
		variable_value = 1
	},
	change_dodge_distance = {
		external_optional_multiplier = 0.45
	},
	change_dodge_speed = {
		external_optional_multiplier = 0.65
	}
}

local clone = table.clone(tbl)

clone.left_hand_unit = "units/weapons/player/wpn_cannon_ball_01/wpn_cannon_ball_01"
clone.actions.action_one.default.speed = 8
clone.actions.action_one.default.throw_time = 0.35000000000000003
clone.actions.action_one.default.throw_offset = {
	0.3,
	0.5,
	0
}
clone.actions.action_one.default.buff_data = {
	{
		start_time = 0,
		external_multiplier = 0.5,
		end_time = 0.28,
		buff_name = "planted_fast_decrease_movement"
	}
}
clone.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "cannon_ball",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_cannon_ball_01/pup_cannon_ball_01"
}
clone.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "cannon_ball",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_cannon_ball_01/pup_cannon_ball_01"
}

local clone_2 = table.clone(tbl)

clone_2.wield_anim_3p = "to_cog"
clone_2.wield_anim = "to_cog"
clone_2.left_hand_unit = "units/weapons/player/wpn_trail_cog_02/wpn_trail_cog_02"
clone_2.actions.action_inspect = ActionTemplates.action_inspect
clone_2.actions.action_one.default.speed = 8
clone_2.actions.action_one.default.throw_time = 0.35000000000000003
clone_2.actions.action_one.default.throw_offset = {
	0.4,
	0.9,
	0
}
clone_2.actions.action_one.default.angular_velocity = {
	0,
	0,
	0
}
clone_2.actions.action_inspect = ActionTemplates.action_inspect
clone_2.wield_anim = "to_cog"
clone_2.wield_anim_3p = "to_cog"
clone_2.actions.action_one.default.buff_data = {
	{
		start_time = 0,
		external_multiplier = 0.5,
		end_time = 0.28,
		buff_name = "planted_fast_decrease_movement"
	}
}
clone_2.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit_limited",
	pickup_name = "trail_cog",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/wpn_trail_cog_02/pup_trail_cog_02"
}
clone_2.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit_limited",
	pickup_name = "trail_cog",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/wpn_trail_cog_02/pup_trail_cog_02"
}

local clone_3 = table.clone(tbl)

clone_3.left_hand_unit = "units/weapons/player/wpn_gargoyle_head/wpn_gargoyle_head"
clone_3.actions.action_one.default.speed = 8
clone_3.actions.action_one.default.throw_time = 0.35000000000000003
clone_3.actions.action_one.default.throw_offset = {
	0.3,
	0.5,
	0
}
clone_3.actions.action_one.default.buff_data = {
	{
		start_time = 0,
		external_multiplier = 1,
		end_time = 0.28,
		buff_name = "planted_fast_decrease_movement"
	}
}
clone_3.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "gargoyle_head",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_gargoyle_head/pup_gargoyle_head_01"
}
clone_3.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "gargoyle_head",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_gargoyle_head/pup_gargoyle_head_01"
}

local clone_4 = table.clone(tbl)

clone_4.left_hand_unit = "units/weapons/player/wpn_shadow_gargoyle_head/wpn_shadow_gargoyle_head"
clone_4.actions.action_one.default.speed = 8
clone_4.actions.action_one.default.throw_time = 0.35000000000000003
clone_4.actions.action_one.default.throw_offset = {
	0.3,
	0.5,
	0
}
clone_4.actions.action_one.default.buff_data = {
	{
		start_time = 0,
		external_multiplier = 1,
		end_time = 0.28,
		buff_name = "planted_fast_decrease_movement"
	}
}
clone_4.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "shadow_gargoyle_head",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_shadow_gargoyle_head/pup_shadow_gargoyle_head_01"
}
clone_4.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "shadow_gargoyle_head",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_shadow_gargoyle_head/pup_shadow_gargoyle_head_01"
}

local clone_5 = table.clone(tbl)

clone_5.left_hand_unit = "units/weapons/player/wpn_magic_crystal/wpn_magic_crystal"
clone_5.actions.action_one.default.speed = 8
clone_5.actions.action_one.default.throw_time = 0.35000000000000003
clone_5.actions.action_one.default.throw_offset = {
	-0.2,
	0.5,
	0
}
clone_5.actions.action_one.default.buff_data = {}
clone_5.wield_anim_3p = "to_crystal"
clone_5.wield_anim = "to_crystal"
clone_5.left_hand_attachment_node_linking = AttachmentNodeLinking.magic_crystal
clone_5.buffs = {}
clone_5.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "magic_crystal",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_magic_crystal/pup_magic_crystal"
}
clone_5.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "magic_crystal",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_magic_crystal/pup_magic_crystal"
}

local clone_6 = table.clone(tbl)

clone_6.buffs = nil
clone_6.left_hand_unit = "units/gameplay/training_dummy/wpn_training_dummy"
clone_6.actions.action_one.default.speed = 2
clone_6.actions.action_one.default.angular_velocity = {
	0,
	0,
	0
}
clone_6.actions.action_one.default.throw_offset = {
	0,
	1,
	-0.2
}
clone_6.actions.action_one.default.rotate_towards_owner_unit = true
clone_6.wield_anim = "to_statue"
clone_6.wield_anim_3p = "to_statue"

local clone_7 = table.clone(clone_6)

clone_7.left_hand_unit = "units/gameplay/training_dummy/wpn_training_dummy"
clone_7.actions.action_one.default.projectile_info.projectile_unit_name = "units/gameplay/training_dummy/training_dummy_bob"
clone_7.actions.action_one.default.projectile_info.projectile_unit_template_name = "ai_unit_training_dummy_bob"
clone_7.actions.action_one.default.projectile_info.pickup_name = "training_dummy_bob"
clone_7.actions.action_one.default.projectile_info.disable_throwing_dialogue = true
clone_7.actions.action_dropped.default.projectile_info.projectile_unit_name = "units/gameplay/training_dummy/training_dummy_bob"
clone_7.actions.action_dropped.default.projectile_info.projectile_unit_template_name = "ai_unit_training_dummy_bob"
clone_7.actions.action_dropped.default.projectile_info.pickup_name = "training_dummy_bob"
clone_7.actions.action_dropped.default.projectile_info.disable_throwing_dialogue = true

local clone_8 = table.clone(clone_6)

clone_8.left_hand_unit = "units/gameplay/training_dummy/wpn_training_dummy_armored"
clone_8.actions.action_one.default.projectile_info.projectile_unit_name = "units/gameplay/training_dummy/training_dummy_bob"
clone_8.actions.action_one.default.projectile_info.projectile_unit_template_name = "ai_unit_training_dummy_bob"
clone_8.actions.action_one.default.projectile_info.pickup_name = "training_dummy_armored_bob"
clone_8.actions.action_one.default.projectile_info.disable_throwing_dialogue = true
clone_8.actions.action_dropped.default.projectile_info.projectile_unit_name = "units/gameplay/training_dummy/training_dummy_bob"
clone_8.actions.action_dropped.default.projectile_info.projectile_unit_template_name = "ai_unit_training_dummy_bob"
clone_8.actions.action_dropped.default.projectile_info.pickup_name = "training_dummy_armored_bob"
clone_8.actions.action_dropped.default.projectile_info.disable_throwing_dialogue = true

local clone_9 = table.clone(clone_3)

clone_9.left_hand_unit = "units/weapons/player/pup_waystone_piece_01/wpn_waystone_piece_01"
clone_9.wield_anim_3p = "to_statue"
clone_9.wield_anim = "to_statue"
clone_9.actions.action_one.default.speed = 4
clone_9.actions.action_one.default.throw_time = 0.35000000000000003
clone_9.actions.action_one.default.throw_offset = {
	0.35,
	0.5,
	0
}
clone_9.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "waystone_piece",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_waystone_piece_01/pup_waystone_piece_01"
}
clone_9.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "waystone_piece",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_waystone_piece_01/pup_waystone_piece_01"
}

return {
	cannon_ball = clone,
	trail_cog = clone_2,
	gargoyle_head = clone_3,
	shadow_gargoyle_head = clone_4,
	magic_crystal = clone_5,
	training_dummy_bob = clone_7,
	training_dummy_armored_bob = clone_8,
	waystone_piece = clone_9
}
