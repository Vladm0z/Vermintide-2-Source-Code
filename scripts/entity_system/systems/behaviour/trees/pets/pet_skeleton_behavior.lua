-- chunkname: @scripts/entity_system/systems/behaviour/trees/pets/pet_skeleton_behavior.lua

local var_0_0 = BreedActions.pet_skeleton
local var_0_1 = BreedActions.pet_skeleton_armored
local var_0_2 = BreedActions.pet_skeleton_dual_wield
local var_0_3 = BreedActions.pet_skeleton_with_shield
local var_0_4 = {
	"BTSelector",
	{
		"BTUtilityNode",
		{
			"BTMeleeOverlapAttackAction",
			name = "running_command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = var_0_1.running_command_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = var_0_1.command_attack
		},
		{
			"BTClanRatFollowAction",
			name = "command_follow",
			condition = "has_target",
			action_data = var_0_0.command_follow
		},
		condition = "pet_skeleton_is_armored",
		name = "armored_command_combat"
	},
	{
		"BTUtilityNode",
		{
			"BTMeleeOverlapAttackAction",
			name = "running_command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = var_0_0.running_command_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = var_0_2.command_attack
		},
		{
			"BTClanRatFollowAction",
			name = "command_follow",
			condition = "has_target",
			action_data = var_0_0.command_follow
		},
		condition = "pet_skeleton_is_dual_wield",
		name = "dual_wield_command_combat"
	},
	{
		"BTUtilityNode",
		{
			"BTMeleeOverlapAttackAction",
			name = "running_command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = var_0_0.running_command_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = var_0_0.command_attack
		},
		{
			"BTClanRatFollowAction",
			name = "command_follow",
			condition = "has_target",
			action_data = var_0_0.command_follow
		},
		condition = "pet_skeleton_has_shield",
		name = "shield_command_combat"
	},
	{
		"BTUtilityNode",
		{
			"BTMeleeOverlapAttackAction",
			leave_hook = "command_attack_done",
			name = "running_command_attack",
			condition = "ask_target_before_attacking",
			action_data = var_0_0.running_command_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = var_0_0.command_attack
		},
		{
			"BTClanRatFollowAction",
			name = "command_follow",
			condition = "has_target",
			action_data = var_0_0.command_follow
		},
		condition = "pet_skeleton_default",
		name = "default_command_combat"
	},
	condition = "has_command_attack",
	name = "command_combat"
}
local var_0_5 = {
	"BTUtilityNode",
	action_data = var_0_0.utility_action,
	{
		"BTMeleeOverlapAttackAction",
		name = "running_sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_1.running_sweep_attack
	},
	{
		"BTRandom",
		action_data = var_0_1.moving_attack,
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "running_special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = var_0_1.moving_special_attack_sweep
		},
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "running_special_attack_cleave",
			condition = "ask_target_before_attacking",
			action_data = var_0_1.moving_special_attack_cleave
		},
		name = "moving_attack"
	},
	{
		"BTRandom",
		action_data = var_0_1.special_attack,
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = var_0_1.special_attack_sweep
		},
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "special_attack_cleave",
			condition = "ask_target_before_attacking",
			action_data = var_0_1.special_attack_cleave
		},
		name = "special_attack"
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		condition = "has_target",
		action_data = var_0_1.push_attack
	},
	{
		"BTMoveToGoalAction",
		enter_hook = "start_stand_ground",
		name = "hold_position",
		condition = "wants_stand_ground",
		action_data = var_0_0.follow
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		condition = "has_target",
		action_data = var_0_0.follow
	},
	name = "armored_combat",
	condition = "pet_skeleton_is_armored"
}
local var_0_6 = {
	"BTUtilityNode",
	action_data = var_0_0.utility_action,
	{
		"BTMeleeOverlapAttackAction",
		name = "running_sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.running_sweep_attack
	},
	{
		"BTMeleeOverlapAttackAction",
		name = "sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_2.sweep_attack
	},
	{
		"BTMoveToGoalAction",
		enter_hook = "start_stand_ground",
		name = "hold_position",
		condition = "wants_stand_ground",
		action_data = var_0_0.follow
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		condition = "has_target",
		action_data = var_0_0.follow
	},
	name = "dual_wield_combat",
	condition = "pet_skeleton_is_dual_wield"
}
local var_0_7 = {
	"BTUtilityNode",
	action_data = var_0_0.utility_action,
	{
		"BTMeleeOverlapAttackAction",
		name = "running_sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.running_sweep_attack
	},
	{
		"BTRandom",
		action_data = var_0_3.special_attack,
		{
			"BTMeleeOverlapAttackAction",
			weight = 10,
			name = "sweep_attack",
			condition = "ask_target_before_attacking",
			action_data = var_0_0.sweep_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "shield_bash",
			condition = "ask_target_before_attacking",
			action_data = var_0_3.shield_bash
		},
		name = "special_attack"
	},
	{
		"BTCombatShoutAction",
		name = "combat_shout",
		action_data = var_0_3.combat_shout
	},
	{
		"BTMoveToGoalAction",
		enter_hook = "start_stand_ground",
		name = "hold_position",
		condition = "wants_stand_ground",
		action_data = var_0_0.follow
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		condition = "has_target",
		action_data = var_0_0.follow
	},
	name = "shield_combat",
	condition = "pet_skeleton_has_shield"
}
local var_0_8 = {
	"BTUtilityNode",
	action_data = var_0_0.utility_action,
	{
		"BTMeleeOverlapAttackAction",
		name = "running_sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.running_sweep_attack
	},
	{
		"BTMeleeOverlapAttackAction",
		name = "sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.sweep_attack
	},
	{
		"BTMoveToGoalAction",
		enter_hook = "start_stand_ground",
		name = "hold_position",
		condition = "wants_stand_ground",
		action_data = var_0_0.follow
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		condition = "has_target",
		action_data = var_0_0.follow
	},
	name = "default_combat",
	condition = "pet_skeleton_default"
}

BreedBehaviors.pet_skeleton = {
	"BTSelector",
	{
		"BTSpawningAction",
		enter_hook = "to_combat",
		name = "spawn",
		condition = "spawn",
		action_data = var_0_0.spawn
	},
	{
		"BTTransportedAction",
		condition = "is_transported",
		name = "transported_idle"
	},
	{
		"BTInVortexAction",
		condition = "in_vortex",
		name = "in_vortex"
	},
	{
		"BTFallAction",
		condition = "is_falling",
		name = "falling"
	},
	{
		"BTStaggerAction",
		name = "stagger",
		condition = "stagger",
		action_data = var_0_0.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = var_0_0.blocked
	},
	{
		"BTSelector",
		{
			"BTTeleportAction",
			condition = "at_teleport_smartobject",
			name = "teleport"
		},
		{
			"BTClimbAction",
			condition = "at_climb_smartobject",
			name = "climb"
		},
		{
			"BTJumpAcrossAction",
			condition = "at_jump_smartobject",
			name = "jump_across"
		},
		{
			"BTSmashDoorAction",
			name = "smash_door",
			condition = "at_door_smartobject",
			action_data = var_0_0.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTTeleportToCommanderAction",
		condition = "should_teleport_to_commander",
		name = "teleport_out_of_range"
	},
	{
		"BTSelector",
		action_data = var_0_0.utility_action,
		{
			"BTIdleAction",
			name = "commander_disabled_idle",
			leave_hook = "start_disabled_resume_timer",
			condition = "commander_disabled",
			enter_hook = "disable_perception",
			action_data = var_0_0.commander_disabled
		},
		{
			"BTFallbackIdleAction",
			name = "commander_disabled_idle_resume",
			leave_hook = "enable_perception",
			action_data = var_0_0.commander_disabled_resume
		},
		name = "commander_disabled",
		condition = "commander_disabled_or_resuming"
	},
	{
		"BTChargeAttackAction",
		leave_hook = "remove_charge_target",
		name = "ability_charge_attack",
		condition = "has_charge_target",
		action_data = var_0_1.ability_charge
	},
	var_0_4,
	{
		"BTSelector",
		var_0_5,
		var_0_6,
		var_0_7,
		var_0_8,
		{
			"BTCombatIdleAction",
			name = "idle",
			action_data = var_0_0.idle
		},
		condition = "confirmed_enemy_sighting_within_commander_sticky",
		name = "in_combat"
	},
	{
		"BTSelector",
		{
			"BTMoveToGoalAction",
			name = "hold_position",
			condition = "has_goal_destination",
			action_data = var_0_0.follow
		},
		{
			"BTFallbackIdleAction",
			name = "fallback_idle",
			action_data = var_0_0.fallback_idle
		},
		name = "stand_ground",
		condition = "wants_stand_ground",
		enter_hook = "start_stand_ground"
	},
	{
		"BTSelector",
		{
			"BTMoveToGoalAction",
			name = "hold_position",
			condition = "has_goal_destination",
			action_data = var_0_0.follow
		},
		{
			"BTFallbackIdleAction",
			name = "fallback_idle",
			action_data = var_0_0.fallback_idle
		},
		name = "follow",
		leave_hook = "stop_follow_commander",
		enter_hook = "start_follow_commander"
	},
	name = "pet_skeleton"
}
