-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_marauder_behavior.lua

local var_0_0 = BreedActions.chaos_marauder

BreedBehaviors.marauder = {
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
			name = "climb",
			condition = "at_climb_smartobject",
			action_data = var_0_0.climb
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
		"BTHesitateAction",
		name = "hesitate",
		condition = "is_alerted",
		action_data = var_0_0.alerted
	},
	{
		"BTUtilityNode",
		action_data = var_0_0.utility_action,
		{
			"BTCombatStepAction",
			name = "combat_step",
			action_data = var_0_0.combat_step
		},
		{
			"BTClanRatFollowAction",
			name = "follow",
			action_data = var_0_0.follow
		},
		{
			"BTAttackAction",
			name = "running_attack",
			condition = "ask_target_before_attacking",
			action_data = var_0_0.running_attack
		},
		{
			"BTAttackAction",
			name = "normal_attack",
			condition = "ask_target_before_attacking",
			action_data = var_0_0.normal_attack
		},
		{
			"BTCombatShoutAction",
			name = "combat_shout",
			action_data = var_0_0.combat_shout
		},
		name = "in_combat",
		condition = "confirmed_player_sighting"
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = var_0_0.alerted
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = var_0_0.follow
	},
	{
		"BTIdleAction",
		name = "idle",
		condition = "no_target",
		action_data = var_0_0.idle
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle",
		action_data = var_0_0.fallback_idle
	},
	name = "marauder"
}
BreedBehaviors.marauder_tutorial = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
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
			name = "climb",
			condition = "at_climb_smartobject",
			action_data = var_0_0.climb
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
		"BTHesitateAction",
		name = "hesitate",
		condition = "is_alerted",
		action_data = var_0_0.alerted
	},
	{
		"BTUtilityNode",
		action_data = var_0_0.utility_action,
		{
			"BTClanRatFollowAction",
			name = "follow",
			action_data = var_0_0.follow
		},
		{
			"BTAttackAction",
			name = "tutorial_attack",
			condition = "ask_target_before_attacking",
			action_data = var_0_0.tutorial_attack
		},
		name = "in_combat",
		condition = "confirmed_player_sighting"
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = var_0_0.alerted
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = var_0_0.follow
	},
	{
		"BTIdleAction",
		name = "idle",
		condition = "no_target",
		action_data = var_0_0.idle
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle",
		action_data = var_0_0.fallback_idle
	},
	name = "marauder_tutorial"
}
