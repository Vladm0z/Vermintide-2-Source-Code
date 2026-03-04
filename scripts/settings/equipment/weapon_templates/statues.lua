-- chunkname: @scripts/settings/equipment/weapon_templates/statues.lua

local var_0_0 = 2
local var_0_1 = {
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
					return arg_1_1 ~= "new_interupting_action" and arg_1_1 ~= "action_complete"
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
					return arg_2_1 ~= "new_interupting_action" and arg_2_1 ~= "action_complete"
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
				push_radius = var_0_0,
				condition_func = function (arg_3_0, arg_3_1)
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
					return arg_4_1 ~= "new_interupting_action" and arg_4_1 ~= "action_complete"
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

var_0_1.left_hand_unit = nil
var_0_1.left_hand_attachment_node_linking = AttachmentNodeLinking.barrel
var_0_1.wield_anim_3p = "to_statue"
var_0_1.wield_anim = "to_statue"
var_0_1.state_machine = "units/beings/player/first_person_base/state_machines/common"
var_0_1.load_state_machine = false
var_0_1.block_wielding = true
var_0_1.max_fatigue_points = 1
var_0_1.dodge_count = 1
var_0_1.buffs = {
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

local var_0_2 = table.clone(var_0_1)

var_0_2.left_hand_unit = "units/weapons/player/wpn_cannon_ball_01/wpn_cannon_ball_01"
var_0_2.actions.action_one.default.speed = 8
var_0_2.actions.action_one.default.throw_time = 0.35000000000000003
var_0_2.actions.action_one.default.throw_offset = {
	0.3,
	0.5,
	0
}
var_0_2.actions.action_one.default.buff_data = {
	{
		start_time = 0,
		external_multiplier = 0.5,
		end_time = 0.28,
		buff_name = "planted_fast_decrease_movement"
	}
}
var_0_2.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "cannon_ball",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_cannon_ball_01/pup_cannon_ball_01"
}
var_0_2.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "cannon_ball",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_cannon_ball_01/pup_cannon_ball_01"
}

local var_0_3 = table.clone(var_0_1)

var_0_3.wield_anim_3p = "to_cog"
var_0_3.wield_anim = "to_cog"
var_0_3.left_hand_unit = "units/weapons/player/wpn_trail_cog_02/wpn_trail_cog_02"
var_0_3.actions.action_inspect = ActionTemplates.action_inspect
var_0_3.actions.action_one.default.speed = 8
var_0_3.actions.action_one.default.throw_time = 0.35000000000000003
var_0_3.actions.action_one.default.throw_offset = {
	0.4,
	0.9,
	0
}
var_0_3.actions.action_one.default.angular_velocity = {
	0,
	0,
	0
}
var_0_3.actions.action_inspect = ActionTemplates.action_inspect
var_0_3.wield_anim = "to_cog"
var_0_3.wield_anim_3p = "to_cog"
var_0_3.actions.action_one.default.buff_data = {
	{
		start_time = 0,
		external_multiplier = 0.5,
		end_time = 0.28,
		buff_name = "planted_fast_decrease_movement"
	}
}
var_0_3.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit_limited",
	pickup_name = "trail_cog",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/wpn_trail_cog_02/pup_trail_cog_02"
}
var_0_3.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit_limited",
	pickup_name = "trail_cog",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/wpn_trail_cog_02/pup_trail_cog_02"
}

local var_0_4 = table.clone(var_0_1)

var_0_4.left_hand_unit = "units/weapons/player/wpn_gargoyle_head/wpn_gargoyle_head"
var_0_4.actions.action_one.default.speed = 8
var_0_4.actions.action_one.default.throw_time = 0.35000000000000003
var_0_4.actions.action_one.default.throw_offset = {
	0.3,
	0.5,
	0
}
var_0_4.actions.action_one.default.buff_data = {
	{
		start_time = 0,
		external_multiplier = 1,
		end_time = 0.28,
		buff_name = "planted_fast_decrease_movement"
	}
}
var_0_4.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "gargoyle_head",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_gargoyle_head/pup_gargoyle_head_01"
}
var_0_4.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "gargoyle_head",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_gargoyle_head/pup_gargoyle_head_01"
}

local var_0_5 = table.clone(var_0_1)

var_0_5.left_hand_unit = "units/weapons/player/wpn_shadow_gargoyle_head/wpn_shadow_gargoyle_head"
var_0_5.actions.action_one.default.speed = 8
var_0_5.actions.action_one.default.throw_time = 0.35000000000000003
var_0_5.actions.action_one.default.throw_offset = {
	0.3,
	0.5,
	0
}
var_0_5.actions.action_one.default.buff_data = {
	{
		start_time = 0,
		external_multiplier = 1,
		end_time = 0.28,
		buff_name = "planted_fast_decrease_movement"
	}
}
var_0_5.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "shadow_gargoyle_head",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_shadow_gargoyle_head/pup_shadow_gargoyle_head_01"
}
var_0_5.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "shadow_gargoyle_head",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_shadow_gargoyle_head/pup_shadow_gargoyle_head_01"
}

local var_0_6 = table.clone(var_0_1)

var_0_6.left_hand_unit = "units/weapons/player/wpn_magic_crystal/wpn_magic_crystal"
var_0_6.actions.action_one.default.speed = 8
var_0_6.actions.action_one.default.throw_time = 0.35000000000000003
var_0_6.actions.action_one.default.throw_offset = {
	-0.2,
	0.5,
	0
}
var_0_6.actions.action_one.default.buff_data = {}
var_0_6.wield_anim_3p = "to_crystal"
var_0_6.wield_anim = "to_crystal"
var_0_6.left_hand_attachment_node_linking = AttachmentNodeLinking.magic_crystal
var_0_6.buffs = {}
var_0_6.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "magic_crystal",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_magic_crystal/pup_magic_crystal"
}
var_0_6.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "magic_crystal",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_magic_crystal/pup_magic_crystal"
}

local var_0_7 = table.clone(var_0_1)

var_0_7.buffs = nil
var_0_7.left_hand_unit = "units/gameplay/training_dummy/wpn_training_dummy"
var_0_7.actions.action_one.default.speed = 2
var_0_7.actions.action_one.default.angular_velocity = {
	0,
	0,
	0
}
var_0_7.actions.action_one.default.throw_offset = {
	0,
	1,
	-0.2
}
var_0_7.actions.action_one.default.rotate_towards_owner_unit = true
var_0_7.wield_anim = "to_statue"
var_0_7.wield_anim_3p = "to_statue"

local var_0_8 = table.clone(var_0_7)

var_0_8.left_hand_unit = "units/gameplay/training_dummy/wpn_training_dummy"
var_0_8.actions.action_one.default.projectile_info.projectile_unit_name = "units/gameplay/training_dummy/training_dummy_bob"
var_0_8.actions.action_one.default.projectile_info.projectile_unit_template_name = "ai_unit_training_dummy_bob"
var_0_8.actions.action_one.default.projectile_info.pickup_name = "training_dummy_bob"
var_0_8.actions.action_one.default.projectile_info.disable_throwing_dialogue = true
var_0_8.actions.action_dropped.default.projectile_info.projectile_unit_name = "units/gameplay/training_dummy/training_dummy_bob"
var_0_8.actions.action_dropped.default.projectile_info.projectile_unit_template_name = "ai_unit_training_dummy_bob"
var_0_8.actions.action_dropped.default.projectile_info.pickup_name = "training_dummy_bob"
var_0_8.actions.action_dropped.default.projectile_info.disable_throwing_dialogue = true

local var_0_9 = table.clone(var_0_7)

var_0_9.left_hand_unit = "units/gameplay/training_dummy/wpn_training_dummy_armored"
var_0_9.actions.action_one.default.projectile_info.projectile_unit_name = "units/gameplay/training_dummy/training_dummy_bob"
var_0_9.actions.action_one.default.projectile_info.projectile_unit_template_name = "ai_unit_training_dummy_bob"
var_0_9.actions.action_one.default.projectile_info.pickup_name = "training_dummy_armored_bob"
var_0_9.actions.action_one.default.projectile_info.disable_throwing_dialogue = true
var_0_9.actions.action_dropped.default.projectile_info.projectile_unit_name = "units/gameplay/training_dummy/training_dummy_bob"
var_0_9.actions.action_dropped.default.projectile_info.projectile_unit_template_name = "ai_unit_training_dummy_bob"
var_0_9.actions.action_dropped.default.projectile_info.pickup_name = "training_dummy_armored_bob"
var_0_9.actions.action_dropped.default.projectile_info.disable_throwing_dialogue = true

local var_0_10 = table.clone(var_0_4)

var_0_10.left_hand_unit = "units/weapons/player/pup_waystone_piece_01/wpn_waystone_piece_01"
var_0_10.wield_anim_3p = "to_statue"
var_0_10.wield_anim = "to_statue"
var_0_10.actions.action_one.default.speed = 4
var_0_10.actions.action_one.default.throw_time = 0.35000000000000003
var_0_10.actions.action_one.default.throw_offset = {
	0.35,
	0.5,
	0
}
var_0_10.actions.action_one.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "waystone_piece",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_waystone_piece_01/pup_waystone_piece_01"
}
var_0_10.actions.action_dropped.default.projectile_info = {
	projectile_unit_template_name = "pickup_projectile_unit",
	pickup_name = "waystone_piece",
	drop_on_player_destroyed = true,
	projectile_unit_name = "units/weapons/player/pup_waystone_piece_01/pup_waystone_piece_01"
}

return {
	cannon_ball = var_0_2,
	trail_cog = var_0_3,
	gargoyle_head = var_0_4,
	shadow_gargoyle_head = var_0_5,
	magic_crystal = var_0_6,
	training_dummy_bob = var_0_8,
	training_dummy_armored_bob = var_0_9,
	waystone_piece = var_0_10
}
