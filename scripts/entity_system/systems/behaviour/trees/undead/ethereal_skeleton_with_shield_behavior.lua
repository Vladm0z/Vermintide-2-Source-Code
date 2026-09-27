-- chunkname: @scripts/entity_system/systems/behaviour/trees/undead/ethereal_skeleton_with_shield_behavior.lua

local ethereal_skeleton_with_shield = BreedActions.ethereal_skeleton_with_shield

BreedBehaviors.ethereal_skeleton_with_shield = {
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
		action_data = ethereal_skeleton_with_shield.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = ethereal_skeleton_with_shield.blocked
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
			action_data = ethereal_skeleton_with_shield.smash_door
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTHesitateAction",
		name = "hesitate",
		condition = "is_alerted",
		action_data = ethereal_skeleton_with_shield.alerted
	},
	{
		"BTUtilityNode",
		action_data = ethereal_skeleton_with_shield.utility_action,
		{
			"BTClanRatFollowAction",
			name = "follow",
			action_data = ethereal_skeleton_with_shield.follow
		},
		{
			"BTAttackAction",
			name = "running_attack",
			condition = "ask_target_before_attacking",
			action_data = ethereal_skeleton_with_shield.running_attack
		},
		{
			"BTAttackAction",
			name = "normal_attack",
			condition = "ask_target_before_attacking",
			action_data = ethereal_skeleton_with_shield.normal_attack
		},
		name = "in_combat",
		condition = "confirmed_player_sighting"
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = ethereal_skeleton_with_shield.alerted
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = ethereal_skeleton_with_shield.follow
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
	name = "shield_marauder"
}
