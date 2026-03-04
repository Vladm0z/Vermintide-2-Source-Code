-- chunkname: @scripts/entity_system/systems/behaviour/trees/beastmen/beastmen_bestigor_behavior.lua

local var_0_0 = BreedActions.beastmen_bestigor
local var_0_1 = {
	"BTUtilityNode",
	action_data = var_0_0.utility_action,
	{
		"BTClanRatFollowAction",
		name = "follow",
		action_data = var_0_0.follow
	},
	{
		"BTCombatStepAction",
		name = "combat_step",
		action_data = var_0_0.combat_step
	},
	{
		"BTChargeAttackAction",
		name = "charge_attack",
		condition = "ask_target_before_attacking",
		action_data = var_0_0.charge_attack
	},
	{
		"BTRandom",
		action_data = var_0_0.running_attack,
		{
			"BTStormVerminAttackAction",
			name = "running_special_attack_sweep",
			weight = 1,
			action_data = var_0_0.special_attack_sweep
		},
		name = "running_attack"
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
		"BTStormVerminPushAction",
		name = "push_attack",
		action_data = var_0_0.push_attack
	},
	{
		"BTCombatShoutAction",
		name = "combat_shout",
		action_data = var_0_0.combat_shout
	},
	name = "in_combat",
	condition = "confirmed_player_sighting"
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
	condition = "bestigor_at_smartobject",
	name = "smartobject"
}

BreedBehaviors.bestigor = {
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
		condition = "no_target",
		name = "idle"
	},
	{
		"BTFallbackIdleAction",
		name = "fallback_idle"
	},
	name = "bestigor"
}
