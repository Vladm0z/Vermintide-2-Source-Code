-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_bulwark_behavior.lua

local var_0_0 = BreedActions.chaos_bulwark

BreedBehaviors.chaos_bulwark = {
	"BTSelector",
	{
		"BTSpawningAction",
		condition = "spawn",
		name = "spawn"
	},
	{
		"BTInVortexAction",
		leave_hook = "bulwark_vortex_leave",
		name = "in_vortex",
		condition = "in_vortex"
	},
	{
		"BTFallAction",
		condition = "is_falling",
		name = "falling"
	},
	{
		"BTStaggerAction",
		leave_hook = "bulwark_stagger_leave",
		name = "stagger",
		condition = "stagger_activated",
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
			"BTSmashDoorAction",
			name = "smash_door",
			condition = "at_door_smartobject",
			action_data = var_0_0.smash_door
		},
		{
			"BTJumpAcrossAction",
			condition = "at_jump_smartobject",
			name = "jump_across"
		},
		condition = "at_smartobject",
		name = "smartobject"
	},
	{
		"BTUtilityNode",
		{
			"BTTargetRageAction",
			name = "target_changed",
			action_data = var_0_0.target_changed
		},
		{
			"BTStormVerminAttackAction",
			name = "special_attack_quick",
			condition = "ask_target_before_attacking",
			action_data = var_0_0.special_attack_quick
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "running_attack_charging",
			condition = "ask_target_before_attacking",
			action_data = var_0_0.running_attack_charging
		},
		{
			"BTMeleeOverlapAttackAction",
			name = "running_attack_right",
			condition = "ask_target_before_attacking",
			action_data = var_0_0.running_attack_right
		},
		{
			"BTStormVerminAttackAction",
			name = "special_attack_sweep",
			condition = "ask_target_before_attacking",
			action_data = var_0_0.special_attack_sweep
		},
		{
			"BTBulwarkFollowAction",
			name = "follow",
			action_data = var_0_0.follow
		},
		condition = "confirmed_player_sighting",
		name = "in_combat"
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = var_0_0.alerted
	},
	{
		"BTMoveToGoalAction",
		leave_hook = "remove_goal_destination",
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
		name = "fallback_idle"
	},
	name = "horde"
}
