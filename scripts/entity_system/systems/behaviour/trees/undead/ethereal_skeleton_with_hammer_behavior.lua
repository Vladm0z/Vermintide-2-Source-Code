-- chunkname: @scripts/entity_system/systems/behaviour/trees/undead/ethereal_skeleton_with_hammer_behavior.lua

local ethereal_skeleton_with_hammer = BreedActions.ethereal_skeleton_with_hammer
local tbl = {
	"BTUtilityNode",
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = ethereal_skeleton_with_hammer.follow
	},
	{
		"BTStormVerminAttackAction",
		name = "running_attack",
		condition = "ask_target_before_attacking",
		action_data = ethereal_skeleton_with_hammer.running_attack
	},
	{
		"BTRandom",
		action_data = ethereal_skeleton_with_hammer.moving_attack,
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "running_special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = ethereal_skeleton_with_hammer.special_attack_sweep
		},
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "running_special_attack_cleave",
			condition = "ask_target_before_attacking",
			action_data = ethereal_skeleton_with_hammer.special_attack_cleave
		},
		name = "moving_attack"
	},
	{
		"BTRandom",
		action_data = ethereal_skeleton_with_hammer.special_attack,
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "special_attack_cleave",
			condition = "ask_target_before_attacking",
			action_data = ethereal_skeleton_with_hammer.special_attack_cleave
		},
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = ethereal_skeleton_with_hammer.special_attack_sweep
		},
		name = "special_attack"
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		action_data = ethereal_skeleton_with_hammer.push_attack
	},
	condition = "confirmed_player_sighting",
	name = "in_combat"
}
local tbl_2 = {
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
		action_data = ethereal_skeleton_with_hammer.smash_door
	},
	condition = "at_smartobject",
	name = "smartobject"
}

BreedBehaviors.ethereal_skeleton_with_hammer = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
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
		action_data = ethereal_skeleton_with_hammer.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = ethereal_skeleton_with_hammer.blocked
	},
	tbl_2,
	tbl,
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = ethereal_skeleton_with_hammer.alerted
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = ethereal_skeleton_with_hammer.follow
	},
	{
		"BTIdleAction",
		condition = "no_target",
		name = "idle"
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "horde"
}
