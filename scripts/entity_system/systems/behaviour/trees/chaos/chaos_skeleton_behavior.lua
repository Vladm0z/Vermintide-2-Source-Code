-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_skeleton_behavior.lua

local chaos_skeleton = BreedActions.chaos_skeleton

BreedBehaviors.chaos_skeleton = {
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
		action_data = chaos_skeleton.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = chaos_skeleton.blocked
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
			"BTZombieExplodeAction",
			name = "explosion_attack",
			condition = "at_door_smartobject",
			action_data = chaos_skeleton.explosion_attack
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTUtilityNode",
		{
			"BTClanRatFollowAction",
			name = "follow",
			action_data = chaos_skeleton.follow
		},
		condition = "confirmed_player_sighting",
		name = "in_combat"
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = chaos_skeleton.alerted
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = chaos_skeleton.follow
	},
	{
		"BTIdleAction",
		name = "idle",
		condition = "no_target",
		action_data = chaos_skeleton.idle
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle",
		action_data = chaos_skeleton.fallback_idle
	},
	name = "chaos_skeleton"
}
