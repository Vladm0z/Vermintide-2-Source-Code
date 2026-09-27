-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_zombie_behavior.lua

local chaos_zombie = BreedActions.chaos_zombie

BreedBehaviors.chaos_zombie = {
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
		action_data = chaos_zombie.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = chaos_zombie.blocked
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
			action_data = chaos_zombie.explosion_attack
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTUtilityNode",
		{
			"BTClanRatFollowAction",
			name = "follow",
			action_data = chaos_zombie.follow
		},
		{
			"BTZombieExplodeAction",
			name = "explosion_attack",
			action_data = chaos_zombie.explosion_attack
		},
		condition = "confirmed_player_sighting",
		name = "in_combat"
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = chaos_zombie.alerted
	},
	{
		"BTIdleAction",
		name = "idle",
		condition = "no_target",
		action_data = chaos_zombie.idle
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle",
		action_data = chaos_zombie.fallback_idle
	},
	name = "chaos_zombie"
}
