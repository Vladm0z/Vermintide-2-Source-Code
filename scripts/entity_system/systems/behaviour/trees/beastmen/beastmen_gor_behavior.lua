-- chunkname: @scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_gor_behavior.lua

local var_0_0 = BreedActions.beastmen_gor
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
		"BTAttackAction",
		name = "headbutt_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.headbutt_attack
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

BreedBehaviors.gor = {
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
		"BTInGravityWellAction",
		condition = "in_gravity_well",
		name = "in_gravity_well"
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
	{
		"BTHesitateAction",
		name = "hesitate",
		condition = "is_alerted",
		action_data = var_0_0.alerted
	},
	var_0_1,
	{
		"BTMoveToGoalAction",
		name = "move_to_goal",
		condition = "has_goal_destination",
		action_data = var_0_0.follow
	},
	{
		"BTAlertedAction",
		name = "alerted",
		condition = "player_spotted",
		action_data = var_0_0.alerted
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
	name = "gor"
}
