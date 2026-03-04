-- chunkname: @scripts/entity_system/systems/behaviour/trees/chaos/chaos_warrior_behavior.lua

local var_0_0 = BreedActions.chaos_warrior
local var_0_1 = {
	"BTUtilityNode",
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
		"BTStormVerminAttackAction",
		name = "running_attack_right",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.running_attack_right
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_cleave",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.special_attack_cleave
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_sweep",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.special_attack_sweep
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_launch",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.special_attack_launch
	},
	{
		"BTStormVerminPushAction",
		name = "push_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.push_attack
	},
	{
		"BTStormVerminAttackAction",
		name = "special_attack_quick",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.special_attack_quick
	},
	condition = "confirmed_player_sighting",
	name = "in_combat"
}
local var_0_2 = {
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
}

BreedBehaviors.chaos_warrior = {
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
	var_0_2,
	var_0_1,
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
		condition = "no_target",
		name = "idle"
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "horde"
}
