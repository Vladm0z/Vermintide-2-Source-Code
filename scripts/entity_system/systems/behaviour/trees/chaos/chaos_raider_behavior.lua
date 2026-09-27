-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_raider_behavior.lua

local chaos_raider = BreedActions.chaos_raider
local tbl = {
	"BTUtilityNode",
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = chaos_raider.follow
	},
	{
		"BTStormVerminAttackAction",
		name = "running_attack",
		condition = "ask_target_before_attacking",
		action_data = chaos_raider.running_attack
	},
	{
		"BTRandom",
		action_data = chaos_raider.moving_attack,
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "running_special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = chaos_raider.special_attack_sweep
		},
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "running_special_attack_cleave",
			condition = "ask_target_before_attacking",
			action_data = chaos_raider.special_attack_cleave
		},
		name = "moving_attack"
	},
	{
		"BTRandom",
		action_data = chaos_raider.special_attack,
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "special_attack_cleave",
			condition = "ask_target_before_attacking",
			action_data = chaos_raider.special_attack_cleave
		},
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = chaos_raider.special_attack_sweep
		},
		name = "special_attack"
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		action_data = chaos_raider.push_attack
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
		action_data = chaos_raider.smash_door
	},
	condition = "at_smartobject",
	name = "smartobject"
}

BreedBehaviors.raider = {
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
		action_data = chaos_raider.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = chaos_raider.blocked
	},
	tbl_2,
	tbl,
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = chaos_raider.alerted
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = chaos_raider.follow
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
BreedBehaviors.raider_tutorial = {
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
		action_data = chaos_raider.stagger
	},
	{
		"BTBlockedAction",
		name = "blocked",
		condition = "blocked",
		action_data = chaos_raider.blocked
	},
	tbl_2,
	{
		"BTUtilityNode",
		{
			"BTClanRatFollowAction",
			name = "follow",
			action_data = chaos_raider.follow
		},
		{
			"BTStormVerminAttackAction",
			weight = 1,
			name = "special_attack_cleave_tutorial",
			condition = "ask_target_before_attacking",
			action_data = chaos_raider.special_attack_cleave_tutorial
		},
		condition = "confirmed_player_sighting",
		name = "in_combat"
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = chaos_raider.alerted
	},
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = chaos_raider.follow
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
