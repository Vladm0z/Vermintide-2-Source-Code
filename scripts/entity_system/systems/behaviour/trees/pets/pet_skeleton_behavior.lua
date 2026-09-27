-- chunkname: @scripts/entity_system/systems/behaviour/trees/pets/pet_skeleton_behavior.lua

local pet_skeleton = BreedActions.pet_skeleton
local pet_skeleton_armored = BreedActions.pet_skeleton_armored
local pet_skeleton_dual_wield = BreedActions.pet_skeleton_dual_wield
local pet_skeleton_with_shield = BreedActions.pet_skeleton_with_shield
local tbl = {
	"BTSelector",
	{
		"BTUtilityNode",
		{
			"BTMeleeOverlapAttackAction",
			name = "running_command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = pet_skeleton_armored.running_command_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = pet_skeleton_armored.command_attack
		},
		{
			"BTClanRatFollowAction",
			name = "command_follow",
			condition = "has_target",
			action_data = pet_skeleton.command_follow
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
			action_data = pet_skeleton.running_command_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = pet_skeleton_dual_wield.command_attack
		},
		{
			"BTClanRatFollowAction",
			name = "command_follow",
			condition = "has_target",
			action_data = pet_skeleton.command_follow
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
			action_data = pet_skeleton.running_command_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = pet_skeleton.command_attack
		},
		{
			"BTClanRatFollowAction",
			name = "command_follow",
			condition = "has_target",
			action_data = pet_skeleton.command_follow
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
			action_data = pet_skeleton.running_command_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "command_attack",
			leave_hook = "command_attack_done",
			condition = "ask_target_before_attacking",
			enter_hook = "start_command_attack",
			action_data = pet_skeleton.command_attack
		},
		{
			"BTClanRatFollowAction",
			name = "command_follow",
			condition = "has_target",
			action_data = pet_skeleton.command_follow
		},
		condition = "pet_skeleton_default",
		name = "default_command_combat"
	},
	condition = "has_command_attack",
	name = "command_combat"
}
local tbl_2 = {
	"BTUtilityNode",
	action_data = pet_skeleton.utility_action,
	{
		"BTMeleeOverlapAttackAction",
		name = "running_sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = pet_skeleton_armored.running_sweep_attack
	},
	{
		"BTRandom",
		action_data = pet_skeleton_armored.moving_attack,
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "running_special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = pet_skeleton_armored.moving_special_attack_sweep
		},
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "running_special_attack_cleave",
			condition = "ask_target_before_attacking",
			action_data = pet_skeleton_armored.moving_special_attack_cleave
		},
		name = "moving_attack"
	},
	{
		"BTRandom",
		action_data = pet_skeleton_armored.special_attack,
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = pet_skeleton_armored.special_attack_sweep
		},
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "special_attack_cleave",
			condition = "ask_target_before_attacking",
			action_data = pet_skeleton_armored.special_attack_cleave
		},
		name = "special_attack"
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		condition = "has_target",
		action_data = pet_skeleton_armored.push_attack
	},
	{
		"BTMoveToGoalAction",
		enter_hook = "start_stand_ground",
		name = "hold_position",
		condition = "wants_stand_ground",
		action_data = pet_skeleton.follow
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		condition = "has_target",
		action_data = pet_skeleton.follow
	},
	name = "armored_combat",
	condition = "pet_skeleton_is_armored"
}
local tbl_3 = {
	"BTUtilityNode",
	action_data = pet_skeleton.utility_action,
	{
		"BTMeleeOverlapAttackAction",
		name = "running_sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = pet_skeleton.running_sweep_attack
	},
	{
		"BTMeleeOverlapAttackAction",
		name = "sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = pet_skeleton_dual_wield.sweep_attack
	},
	{
		"BTMoveToGoalAction",
		enter_hook = "start_stand_ground",
		name = "hold_position",
		condition = "wants_stand_ground",
		action_data = pet_skeleton.follow
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		condition = "has_target",
		action_data = pet_skeleton.follow
	},
	name = "dual_wield_combat",
	condition = "pet_skeleton_is_dual_wield"
}
local tbl_4 = {
	"BTUtilityNode",
	action_data = pet_skeleton.utility_action,
	{
		"BTMeleeOverlapAttackAction",
		name = "running_sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = pet_skeleton.running_sweep_attack
	},
	{
		"BTRandom",
		action_data = pet_skeleton_with_shield.special_attack,
		{
			"BTMeleeOverlapAttackAction",
			weight = 10,
			name = "sweep_attack",
			condition = "ask_target_before_attacking",
			action_data = pet_skeleton.sweep_attack
		},
		{
			"BTMeleeOverlapAttackAction",
			weight = 1,
			name = "shield_bash",
			condition = "ask_target_before_attacking",
			action_data = pet_skeleton_with_shield.shield_bash
		},
		name = "special_attack"
	},
	{
		"BTCombatShoutAction",
		name = "combat_shout",
		action_data = pet_skeleton_with_shield.combat_shout
	},
	{
		"BTMoveToGoalAction",
		enter_hook = "start_stand_ground",
		name = "hold_position",
		condition = "wants_stand_ground",
		action_data = pet_skeleton.follow
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		condition = "has_target",
		action_data = pet_skeleton.follow
	},
	name = "shield_combat",
	condition = "pet_skeleton_has_shield"
}
local tbl_5 = {
	"BTUtilityNode",
	action_data = pet_skeleton.utility_action,
	{
		"BTMeleeOverlapAttackAction",
		name = "running_sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = pet_skeleton.running_sweep_attack
	},
	{
		"BTMeleeOverlapAttackAction",
		name = "sweep_attack",
		condition = "ask_target_before_attacking",
		action_data = pet_skeleton.sweep_attack
	},
	{
		"BTMoveToGoalAction",
		enter_hook = "start_stand_ground",
		name = "hold_position",
		condition = "wants_stand_ground",
		action_data = pet_skeleton.follow
	},
	{
		"BTClanRatFollowAction",
		name = "follow",
		condition = "has_target",
		action_data = pet_skeleton.follow
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
		action_data = pet_skeleton.spawn
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
		action_data = pet_skeleton.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = pet_skeleton.blocked
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
			action_data = pet_skeleton.smash_door
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
		action_data = pet_skeleton.utility_action,
		{
			"BTIdleAction",
			name = "commander_disabled_idle",
			leave_hook = "start_disabled_resume_timer",
			condition = "commander_disabled",
			enter_hook = "disable_perception",
			action_data = pet_skeleton.commander_disabled
		},
		{
			"BTFallbackIdleAction",
			name = "commander_disabled_idle_resume",
			leave_hook = "enable_perception",
			action_data = pet_skeleton.commander_disabled_resume
		},
		name = "commander_disabled",
		condition = "commander_disabled_or_resuming"
	},
	{
		"BTChargeAttackAction",
		leave_hook = "remove_charge_target",
		name = "ability_charge_attack",
		condition = "has_charge_target",
		action_data = pet_skeleton_armored.ability_charge
	},
	tbl,
	{
		"BTSelector",
		tbl_2,
		tbl_3,
		tbl_4,
		tbl_5,
		{
			"BTCombatIdleAction",
			name = "idle",
			action_data = pet_skeleton.idle
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
			action_data = pet_skeleton.follow
		},
		{
			"BTFallbackIdleAction",
			name = "fallback_idle",
			action_data = pet_skeleton.fallback_idle
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
			action_data = pet_skeleton.follow
		},
		{
			"BTFallbackIdleAction",
			name = "fallback_idle",
			action_data = pet_skeleton.fallback_idle
		},
		name = "follow",
		leave_hook = "stop_follow_commander",
		enter_hook = "start_follow_commander"
	},
	name = "pet_skeleton"
}
